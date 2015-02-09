unit WaveIn;

interface

uses
  DebugTools, RyuLibBase, VoiceZipUtils, msacm2, SimpleThread, PacketList,
  LazyRelease,
  Windows, Messages, SysUtils, Classes, MMSystem, Controls;

const
  HEADER_FENDER_SIZE = 256;

type
  TWaveIn = class(TComponent)
  private
    FDeviceID : integer;
    FHWaveIn : HWaveIn;
    FWaveFormat : TWaveFormatEx;
    procedure init_WaveFormat;
  private
    FLazyRelease : TLazyRelease;
    procedure prepare_Header;
    procedure do_NewData(Header:PWaveHdr);
  private
    FPacketList : TPacketList;
    FSimpleThread : TSimpleThread;
    procedure on_SimpleThread(Sender:TObject);
  private
    FActive : Boolean;
    FBufferSize : integer;
    FOnData : TDataEvent;
    FSampleRate : integer;
    FChannels: integer;
    procedure SetChannels(const Value: integer);
    procedure SetSampleRate(const Value: integer);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure Start(const AudioDeviceID: Integer = -1);
    procedure Stop;
  published
    property Active : boolean read FActive default false;
    property BufferSize : integer read FBufferSize write FBufferSize;
    property SampleRate : integer read FSampleRate write SetSampleRate;
    property Channels : integer read FChannels write SetChannels;
    property OnData : TDataEvent read FOnData write FOnData;
end;

implementation

constructor TWaveIn.Create(AOwner:TComponent);
begin
  inherited;

  FDeviceID := -1;
  FActive := false;
  FSampleRate := 8000;
  FChannels := 1;
  FBufferSize := 320;

  init_WaveFormat;

  FLazyRelease := TLazyRelease.Create( HEADER_FENDER_SIZE );
  FPacketList := TPacketList.Create;

  FSimpleThread := nil;
end;

destructor TWaveIn.Destroy;
begin
  Stop;

//  FreeAndNil(FLazyRelease);
//  FreeAndNil(FPacketList);

  inherited;
end;

procedure TWaveIn.init_WaveFormat;
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

procedure TWaveIn.on_SimpleThread(Sender: TObject);
var
  pHeader: PWaveHdr;
  SimpleThread : TSimpleThread absolute Sender;
begin
  while not SimpleThread.Terminated do begin

    while FPacketList.Get(Pointer(pHeader)) do begin

      if SimpleThread.Terminated then Break;

      try
        if Assigned(FOnData) then FOnData(Self, pHeader.lpData, pHeader.dwBytesRecorded);

        waveInUnprepareHeader( FHWaveIn, pHeader, SizeOf(TWaveHdr) );

        FLazyRelease.Release( pHeader^.lpData );
        FLazyRelease.Release( pHeader );

        prepare_Header;
      except
        on E : Exception do Trace( 'TWaveIn.on_SimpleThread - ' + E.Message );
      end;
    end;

    SimpleThread.SleepTight;
  end;
end;

procedure TWaveIn.prepare_Header;
var
  pHeader: PWaveHdr;
  iErrorCode : integer;
begin
  New( pHeader );
  ZeroMemory( pHeader, SizeOf(TWaveHdr) );

  GetMem( pHeader^.lpData, FBufferSize);

  pHeader^.dwBufferLength := FBufferSize;

  iErrorCode := waveInPrepareHeader(FHWaveIn, pHeader, SizeOf(TWaveHdr));
  if iErrorCode <> MMSYSERR_NOERROR then
    Trace( 'TWaveIn.prepare_Header - waveInPrepareHeader' );

  iErrorCode := waveInAddBuffer(FHWaveIn, pHeader, SizeOf(TWaveHdr));
  if iErrorCode <> MMSYSERR_NOERROR then
    Trace( 'TWaveIn.prepare_Header - waveInAddBuffer' );
end;

procedure TWaveIn.do_NewData(Header: PWaveHdr);
begin
  FPacketList.Add(Header);
  FSimpleThread.WakeUp;
end;

procedure waveInProc(hwi:HWAVEIN; uMsg:UINT; dwInstance:DWORD; dwParam1:DWORD; dwParam2:DWORD); stdcall;
var
  WaveIn : TWaveIn;
begin
  WaveIn := TWaveIn(dwInstance);
  case uMsg of
    MM_WIM_OPEN: ;

    MM_WIM_CLOSE: ;

    MM_WIM_DATA: if WaveIn.Active then begin
      WaveIn.do_NewData(pWaveHdr(dwParam1));
    end;
  end;
end;

procedure TWaveIn.SetChannels(const Value: integer);
begin
  FChannels := Value;

  init_WaveFormat;
end;

procedure TWaveIn.SetSampleRate(const Value: integer);
begin
  FSampleRate := Value;

  init_WaveFormat;
end;

procedure TWaveIn.Start(const AudioDeviceID: Integer);
var
  iErrorCode : Integer;
begin
  if FActive = true then
    raise ExceptionWithErrorCode.Create('TWaveIn.Start: 이미 TWaveIn가 Start 되었습니다.', 3);

  FPacketList.Clear;

  if AudioDeviceID = -1 then FDeviceID := WAVE_MAPPER
  else FDeviceID := AudioDeviceID;

  iErrorCode := WaveInOpen(@FHWaveIn, FDeviceID, @FWaveFormat, DWORD(@waveInProc), DWORD(Self), CALLBACK_FUNCTION);
  FActive := (iErrorCode = MMSYSERR_NOERROR);
  if FActive = false then
    raise ExceptionWithErrorCode.Create('TWaveIn.Start: WaveOutOpen error.', 4);

  prepare_Header;
  prepare_Header;
  prepare_Header;

  iErrorCode := waveInStart(FHWaveIn);
  FActive := iErrorCode = MMSYSERR_NOERROR;
  if FActive = false then
    raise ExceptionWithErrorCode.Create('TWaveIn.Start: waveInStart error.', 6);

  FSimpleThread := TSimpleThread.Create(on_SimpleThread);
  FSimpleThread.Name := 'TWaveIn';
end;

procedure TWaveIn.Stop;
begin
  if FActive = False then Exit;

  FActive := False;

  FSimpleThread.Terminate(INFINITE);

  FPacketList.Clear;

  waveInStop(FHWaveIn);
  WaveInClose(FHWaveIn);
end;

end.
