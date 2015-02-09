unit SoundTouchDLL;

interface

uses
  RyuLibBase,
  Classes, SysUtils;

const
  _SETTING_USE_AA_FILTER = 0;
  _SETTING_AA_FILTER_LENGTH = 1;
  _SETTING_USE_QUICKSEEK = 2;
  _SETTING_SEQUENCE_MS = 3;
  _SETTING_SEEKWINDOW_MS = 4;
  _SETTING_OVERLAP_MS = 5;

  // 바이트 단위의 샘플 크기
  _SampleSize = 2;

  // 샘플 단위의 버퍼 크기
  _OutputBufferSize = 1024 * 32;

type
  TSoundTouch = class
  private
    FHandle : pointer;
    FBuffer : pointer;
    procedure receive_Samples;
  private
    FSampleRate: Cardinal;
    FChannels: Cardinal;
    FOnData: TDataEvent;
    FTempo: integer;
    function GetIsEmpty: boolean;
    function GetNumUnprocessedSamples: Cardinal;
    procedure SetTempo(const value: integer);
  public
    constructor Create(AChannels,ASampleRate:integer; ASpeechMode:Boolean= false); reintroduce;
    destructor Destroy; override;

    procedure DataIn(AData:pointer; ASize:integer);
    procedure Flush;
  public
    property Channels: Cardinal read FChannels;
    property SampleRate: Cardinal read FSampleRate;
    property Tempo : integer read FTempo write SetTempo;
    property NumUnprocessedSamples: Cardinal read GetNumUnprocessedSamples;
    property IsEmpty : boolean read GetIsEmpty;
    property OnData : TDataEvent read FOnData write FOnData;
  end;

function soundtouch_createInstance:pointer; cdecl;
procedure soundtouch_destroyInstance(handle:pointer); cdecl;
function soundtouch_getVersionString:PAnsiChar; cdecl;
procedure soundtouch_getVersionString2(versionString:PAnsiChar; bufferSize:integer); cdecl;
function soundtouch_getVersionId:integer; cdecl;
procedure soundtouch_setRate(handle:pointer; newRate:single); cdecl;
procedure soundtouch_setTempo(handle:pointer; newTempo:single); cdecl;
procedure soundtouch_setRateChange(handle:pointer; newRate:single); cdecl;
procedure soundtouch_setTempoChange(handle:pointer; newTempo:single); cdecl;
procedure soundtouch_setPitch(handle:pointer; newPitch:single); cdecl;
procedure soundtouch_setPitchOctaves(handle:pointer; newPitch:single); cdecl;
procedure soundtouch_setPitchSemiTones(handle:pointer; newPitch:single); cdecl;
procedure soundtouch_setChannels(handle:pointer; numChannels:Cardinal); cdecl;
procedure soundtouch_setSampleRate(handle:pointer; numChannels:Cardinal); cdecl;
procedure soundtouch_flush(handle:pointer); cdecl;
procedure soundtouch_putSamples(handle:pointer; const Samples:PSingle; numSamples:Cardinal); cdecl;
procedure soundtouch_clear(handle:pointer); cdecl;
function soundtouch_setSetting(handle:pointer; settingId,value:integer):boolean; cdecl;
function soundtouch_getSetting(handle:pointer; settingId:integer):integer; cdecl;
function soundtouch_numUnprocessedSamples(handle:pointer):Cardinal; cdecl;
function soundtouch_receiveSamples(handle:pointer; outBuffer:PSingle; maxSamples:Cardinal):Cardinal; cdecl;
function soundtouch_numSamples(handle:pointer):Cardinal; cdecl;
function soundtouch_isEmpty(handle:pointer):integer; cdecl; 

implementation

function soundtouch_createInstance:pointer; cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_destroyInstance(handle:pointer); cdecl;
         external 'SoundTouch.dll';

function soundtouch_getVersionString:PAnsiChar; cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_getVersionString2(versionString:PAnsiChar; bufferSize:integer); cdecl;
         external 'SoundTouch.dll';

function soundtouch_getVersionId:integer; cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setRate(handle:pointer; newRate:single); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setTempo(handle:pointer; newTempo:single); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setRateChange(handle:pointer; newRate:single); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setTempoChange(handle:pointer; newTempo:single); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setPitch(handle:pointer; newPitch:single); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setPitchOctaves(handle:pointer; newPitch:single); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setPitchSemiTones(handle:pointer; newPitch:single); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setChannels(handle:pointer; numChannels:Cardinal); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_setSampleRate(handle:pointer; numChannels:Cardinal); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_flush(handle:pointer); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_putSamples(handle:pointer; const Samples:PSingle; numSamples:Cardinal); cdecl;
         external 'SoundTouch.dll';

procedure soundtouch_clear(handle:pointer); cdecl;
         external 'SoundTouch.dll';

function soundtouch_setSetting(handle:pointer; settingId,value:integer):boolean; cdecl;
         external 'SoundTouch.dll';

function soundtouch_getSetting(handle:pointer; settingId:integer):integer; cdecl;
         external 'SoundTouch.dll';

function soundtouch_numUnprocessedSamples(handle:pointer):Cardinal; cdecl;
         external 'SoundTouch.dll';

function soundtouch_receiveSamples(handle:pointer; outBuffer:PSingle; maxSamples:Cardinal):Cardinal; cdecl;
         external 'SoundTouch.dll';

function soundtouch_numSamples(handle:pointer):Cardinal; cdecl;
         external 'SoundTouch.dll';

function soundtouch_isEmpty(handle:pointer):integer; cdecl;
         external 'SoundTouch.dll';

{ TSoundTouch }

constructor TSoundTouch.Create(AChannels,ASampleRate:integer; ASpeechMode:Boolean);
begin
  inherited Create;

  if AChannels = 0 then
    raise Exception.Create(ClassName + '.Open: AChannels은 0보다 큰 정수여야 합니다.');

  FChannels := AChannels;
  FSampleRate := ASampleRate;
  FTempo := 0;

  // 오디오 샘플은 16비트
  GetMem(FBuffer, _OutputBufferSize * _SampleSize);

  FHandle := soundtouch_createInstance;

  soundtouch_setChannels(FHandle, FChannels);
  soundtouch_setSampleRate(FHandle, FSampleRate);

  soundtouch_setTempoChange(FHandle, FTempo);
  soundtouch_setPitchSemiTones(FHandle, 0);
  soundtouch_setRateChange(FHandle, 0);

  soundtouch_setSetting(FHandle, _SETTING_USE_QUICKSEEK, 0);
  soundtouch_setSetting(FHandle, _SETTING_USE_AA_FILTER, 0);

  if ASpeechMode then begin
    soundtouch_setSetting(FHandle, _SETTING_SEQUENCE_MS, 40);
    soundtouch_setSetting(FHandle, _SETTING_SEEKWINDOW_MS, 15);
    soundtouch_setSetting(FHandle, _SETTING_OVERLAP_MS, 8);
  end;
end;

procedure TSoundTouch.DataIn(AData: pointer; ASize: integer);
var
  Old8087CW : word;
  pTemp : PByteArray absolute AData;
begin
  // FPU 에러를 잠시 끈다.
  Old8087CW := Default8087CW;
  Set8087CW($133F);
  try
    soundtouch_putSamples(FHandle, AData, ASize div (FChannels * _SampleSize));
  finally
    Set8087CW(Old8087CW);
  end;
  
  receive_Samples;
end;

destructor TSoundTouch.Destroy;
begin
  Flush;

  soundtouch_destroyInstance(FHandle);
  FreeMem(FBuffer);

  inherited;
end;

procedure TSoundTouch.Flush;
begin
  soundtouch_flush(FHandle);
  receive_Samples;
end;

function TSoundTouch.GetIsEmpty: boolean;
begin
  Result := soundtouch_isEmpty(FHandle) > 0;
end;

function TSoundTouch.GetNumUnprocessedSamples: Cardinal;
begin
  Result := soundtouch_numUnprocessedSamples(FHandle);
end;

procedure TSoundTouch.receive_Samples;
var
  iSamples : Cardinal;
begin
  repeat
    iSamples := soundtouch_receiveSamples(FHandle, FBuffer, _OutputBufferSize div FChannels);
    if (iSamples > 0) and (Assigned(FOnData)) then FOnData(Self, FBuffer, iSamples * FChannels * _SampleSize);
  until iSamples = 0;
end;

procedure TSoundTouch.SetTempo(const value: integer);
begin
  FTempo := Value;
  soundtouch_setTempoChange(FHandle, FTempo);
end;

end.
