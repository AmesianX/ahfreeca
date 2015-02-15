unit WaveOutHeader;

interface

uses
  RyuLibBase, DebugTools, VoiceZipUtils, msacm2, MMSystem,
  Windows, SysUtils, Classes;

const
  HEADER_COUNT = 256;

type
  TWaveOutHeader = class
  private
    FHeaderIndex : integer;
    FHeaders : array [0..HEADER_COUNT-1] of TWaveHdr;
  public
    constructor Create;
    destructor Destroy; override;

    function Get(AHWaveOut:HWaveOut; AData:pointer; ASize:integer):PWaveHdr;
  end;

implementation

{ TWaveOutHeader }

constructor TWaveOutHeader.Create;
var
  Loop: Integer;
begin
  inherited;

  FHeaderIndex := 0;

  for Loop := 0 to HEADER_COUNT-1 do begin
    FHeaders[Loop].dwbufferlength := 0;;
    FHeaders[Loop].lpData := nil;
    FHeaders[Loop].dwFlags := 0;
  end;
end;

destructor TWaveOutHeader.Destroy;
begin

  inherited;
end;

function TWaveOutHeader.Get(AHWaveOut:HWaveOut; AData:pointer; ASize:integer): PWaveHdr;
var
  isReady : boolean;
  Loop, iErrorCode : integer;
begin
  Result := nil;

  // 재 사용 가능 한 헤더를 찾는다.
  for Loop := 0 to HEADER_COUNT - 1 do begin
    FHeaderIndex := FHeaderIndex + 1;
    if FHeaderIndex >= HEADER_COUNT then FHeaderIndex := 0;

    if FHeaders[FHeaderIndex].dwFlags = 0 then Break;
  end;

  // TODO: 못 찾았을 때 처리

  Result := @FHeaders[FHeaderIndex];
  Result^.dwUser   := 0;
  Result^.dwLoops  := 0;
  Result^.lpNext   := nil;
  Result^.reserved := 0;

  if (Result^.dwbufferlength < DWord(ASize)) or (Result^.lpdata = nil) then begin
    Result^.dwbufferlength := ASize;
    if Result^.lpData <> nil then FreeMem(Result^.lpdata);
    GetMem(Result^.lpdata, ASize);
  end;

  Move( AData^, Result^.lpdata^, ASize );

  iErrorCode := WaveOutPrepareHeader(AHWaveOut, Result, SizeOf(TWaveHdr));
  if iErrorCode <> MMSYSERR_NOERROR then Result := nil;
end;

end.
