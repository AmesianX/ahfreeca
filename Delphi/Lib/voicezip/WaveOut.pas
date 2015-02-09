unit WaveOut;

interface

uses
  RyuLibBase, DebugTools, VoiceZipUtils, msacm2,
  Windows, Messages, SysUtils, Classes, MMSystem, Vcl.Controls;

const
  HEADER_COUNT = 256;

type
  TWaveOut = class (TComponent)
  private
    FWaveFormat : TWaveFormatEx;
    procedure init_WaveFormat;
  private
    FHWaveOut : HWaveOut;
    FTerminateEvent : THandle;
    FTerminateEventFired : boolean;
    FHeaders : array [0..HEADER_COUNT-1] of TWaveHdr;
    procedure do_PrepareHeaders;
    procedure do_ClearHeaders;
    function get_Header(Data:pointer; Size:integer):pWaveHdr;
  private
    FSampleRate: integer;
    FChannels: integer;
    FDataInBuffer: integer;
    FActive: boolean;
    FOnPlayed: TDataEvent;
    procedure SetSampleRate(const Value: integer);
    procedure SetChannels(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    function Play(AData:Pointer; ASize:integer):boolean;
  published
    property Active : boolean read FActive default false;
    property DataInBuffer : integer read FDataInBuffer;
    property SampleRate : integer read FSampleRate write SetSampleRate;
    property Channels : integer read FChannels write SetChannels;

    property OnPlayed : TDataEvent read FOnPlayed write FOnPlayed;
  end;

implementation

procedure waveOutProc(hwi:HWAVEOUT; uMsg:UINT; dwInstance:DWORD; dwParam1:DWORD; dwParam2:DWORD); stdcall;
var
  pHeader : pWaveHdr;
  WaveOut : TWaveOut;
begin
  WaveOut := TWaveOut(dwInstance);

  case uMsg of
       MM_WOM_OPEN: ;
       MM_WOM_CLOSE: begin
         WaveOut.FTerminateEventFired := true;
         SetEvent(WaveOut.FTerminateEvent);
       end;
       MM_WOM_DONE: begin
         InterlockedDecrement( WaveOut.FDataInBuffer );
         if WaveOut.FDataInBuffer < 0 then WaveOut.FDataInBuffer := 0;

         if WaveOut.Active = false then Exit;

         pHeader := pWaveHdr(dwParam1);
         if Assigned(WaveOut.FOnPlayed) then begin
           WaveOut.FOnPlayed(WaveOut, pHeader^.lpData, pHeader^.dwBufferLength);
         end;
       end;
  end;
end;

{ TWaveOut }

constructor TWaveOut.Create(AOwner: TComponent);
begin
  inherited;

  FActive := false;
  FSampleRate := 8000;
  FChannels := 1;
  FDataInBuffer := 0;

  init_WaveFormat;

  FTerminateEvent := CreateEvent(nil, false, false, '');

  do_PrepareHeaders;
end;

destructor TWaveOut.Destroy;
begin
  Stop;

  inherited;
end;

procedure TWaveOut.do_ClearHeaders;
var
  Loop : Integer;
begin
  for Loop := 0 to HEADER_COUNT-1 do
    if FHeaders[Loop].lpData <> nil then begin
      if FHeaders[Loop].lpData <> nil then FreeMem(FHeaders[Loop].lpData);
      FHeaders[Loop].lpData := nil;
      FHeaders[Loop].dwFlags := 0;
    end;
end;

procedure TWaveOut.do_PrepareHeaders;
var
  Loop : Integer;
begin
  for Loop := 0 to HEADER_COUNT-1 do begin
    FHeaders[Loop].lpData := nil;
    FHeaders[Loop].dwFlags := 0;
  end;
end;

function TWaveOut.get_Header(Data: pointer; Size: integer): pWaveHdr;
var
  iDoneFlag : DWord;
  Loop, iHeaderIndex : integer;
begin
  // Todo : 헤더 목록을 동적리스트로 관리

  iDoneFlag := WHDR_DONE or WHDR_PREPARED;
  for Loop := 0 to HEADER_COUNT - 1 do begin
    if (FHeaders[Loop].dwFlags and iDoneFlag) = iDoneFlag then begin
      WaveOutUnprepareHeader(FHWaveOut, @FHeaders[Loop], SizeOf(TWaveHdr));
      FHeaders[Loop].dwFlags := 0;
    end;
  end;

  iHeaderIndex := -1;
  for Loop := 0 to HEADER_COUNT - 1 do
    if FHeaders[Loop].dwFlags = 0 then begin
      iHeaderIndex := Loop;
      Break;
    end;

  if iHeaderIndex = -1 then begin
    Result := nil;
    Exit;
  end;

  Result := @FHeaders[iHeaderIndex];
  Result^.dwUser   := 0;
  Result^.dwLoops  := 0;
  Result^.lpNext   := nil;
  Result^.reserved := 0;

  if (Result^.dwbufferlength < DWord(Size)) or (Result^.lpdata = nil) then begin
    Result^.dwbufferlength := Size;
    if Result^.lpData <> nil then FreeMem(Result^.lpdata);
    GetMem(Result^.lpdata, Size);
  end;

  Move(Data^, Result^.lpdata^, Size);
end;

procedure TWaveOut.init_WaveFormat;
begin
  with FWaveFormat do begin
    wFormatTag      := WAVE_FORMAT_PCM;
    nChannels       := FChannels;
    nSamplesPerSec  := FSampleRate;
    wBitsPerSample  := 16;
    nBlockAlign     := nChannels*wBitsPerSample div 8;
    nAvgBytesPerSec := nSamplesPerSec*nBlockAlign;
    cbSize          := 0;
  end;
end;

function TWaveOut.Play(AData: Pointer; ASize: integer):boolean;
var
  pHeader : pWaveHdr;
  iErrorCode : integer;
begin
  Result := false;

  if FActive = false then begin
    {$IFDEF DEBUG}
    Trace('Error: TWaveOut.Play: FActive = false');
    {$ENDIF}

    Exit;
  end;

  pHeader := get_Header(AData, ASize);
  if pHeader = nil then begin
    {$IFDEF DEBUG}
    Trace('Error: TWaveOut.Play: get_Header = nil');
    {$ENDIF}

    Exit;
  end;

  iErrorCode := WaveOutPrepareHeader(FHWaveOut, pHeader, SizeOf(TWaveHdr));
  if iErrorCode <> MMSYSERR_NOERROR then begin
    {$IFDEF DEBUG}
    Trace('Error: TWaveOut.Play: WaveOutPrepareHeader <> MMSYSERR_NOERROR');
    {$ENDIF}

    pHeader.dwFlags := 0;

    Exit;
  end;

  iErrorCode := WaveOutWrite(FHWaveOut, pHeader, SizeOf(TWaveHdr));
  if iErrorCode <> MMSYSERR_NOERROR then begin
    {$IFDEF DEBUG}
    Trace('Error: TWaveOut.Play: WaveOutWrite <> MMSYSERR_NOERROR');
    {$ENDIF}

    pHeader.dwFlags := WHDR_DONE or WHDR_PREPARED;

    Exit;
  end;

  InterlockedIncrement( FDataInBuffer );

  Result := true;
end;

procedure TWaveOut.SetChannels(const Value: integer);
begin
  FChannels := Value;
  init_WaveFormat;
end;

procedure TWaveOut.SetSampleRate(const Value: integer);
begin
  FSampleRate := Value;
  init_WaveFormat;
end;

procedure TWaveOut.Start;
var
  iErrorCode : Integer;
begin
  FDataInBuffer := 0;

  if FActive = true then begin
    {$IFDEF DEBUG}
    Trace('Error: TWaveOut.Start - 이미 TWaveOut가 Start 되었습니다.');
    {$ENDIF}

    raise ExceptionWithErrorCode.Create('TWaveOut.Start: 이미 TWaveOut가 Start 되었습니다.', 0);
  end;

  iErrorCode := WaveOutOpen(@FHWaveOut, WAVE_MAPPER, @FWaveFormat, DWORD(@waveOutProc), DWORD(Self), CALLBACK_FUNCTION);

  FActive := (iErrorCode = MMSYSERR_NOERROR);

  if FActive = false then begin
    {$IFDEF DEBUG}
    Trace('Error: TWaveOut.Start - WaveOutOpen <> MMSYSERR_NOERROR');
    {$ENDIF}

    raise ExceptionWithErrorCode.Create('TWaveOut.Start: WaveOutOpen error.', 1);
  end;

  FTerminateEventFired := false;
end;

procedure TWaveOut.Stop;
begin
  if Active = false then Exit;

  FActive := false;
  WaveOutReset(FHWaveOut);
  WaveOutClose(FHWaveOut);

  if FTerminateEventFired = false then WaitforSingleObject(FTerminateEvent, 5000);

  do_ClearHeaders;
end;

end.
