unit SpeexEncoder;

interface

uses
  VoiceZipUtils, Speex,
  Classes, SysUtils;

type
  TSpeexEncoder = class (TComponent)
  private
    FBits : TSpeexBits;
    FState : Pointer;
    FBuffer : TMemoryStream;
    FBufferOut : pointer;
    FBufferIn : TBufferSmallInt;
    FBufferEnc : TBufferSingle;
  private
    FQuality: integer;
    FVBR: boolean;
    FActive: boolean;
    FFrameSize : integer;
    FSampleRate : integer;
    FOnNewData: TVoiceDataEvent;
    FVolume: single;
    FWaveVolume: integer;
    procedure SetQuality(const Value: integer);
    procedure SetVBR(const Value: boolean);
    function GetFrameSizeInByte: integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
    procedure Excute(AData:pointer; ASize:integer);
  published
    property Active : boolean read FActive;
    property FrameSize : integer read FFrameSize;
    property FrameSizeInByte : integer read GetFrameSizeInByte;
    property Quality : integer read FQuality write SetQuality;
    property Volume : single read FVolume write FVolume;
    property WaveVolume : integer read FWaveVolume;
    property SampleRate : integer read FSampleRate write FSampleRate;
    property VBR : boolean read FVBR write SetVBR;
    property OnNewData : TVoiceDataEvent read FOnNewData write FOnNewData;
  end;

implementation

{ TSpeexEncoder }

constructor TSpeexEncoder.Create(AOwner: TComponent);
begin
  inherited;

  FQuality := 10;
  FVBR := false;
  FVolume := 1.0;
  FWaveVolume := 0;
  FSampleRate := 8000;

  GetMem(FBufferOut, MAX_WB_BYTES);
  FBuffer := TMemoryStream.Create;
end;

destructor TSpeexEncoder.Destroy;
begin
  Stop;

  FreeMem(FBufferOut);
  FBuffer.Free;

  inherited;
end;

procedure TSpeexEncoder.Excute(AData:pointer; ASize:integer);
var
  Loop : Integer;
  pBufferIn : ^SmallInt;
  iSize, iVolume, iVolumeOut : integer;
begin
  if not Active then Exit;

  if ASize <> FrameSizeInByte then
    raise Exception.Create('TSpeexEncoder.Excute: ASize와 FrameSize 크기가 다릅니다.');

  pBufferIn := AData;

  iVolumeOut := 0;
  for Loop := 0 to FrameSize-1 do begin
    FBufferEnc[Loop] := pBufferIn^ * FVolume;

    iVolume := pBufferIn^;
    if iVolume > iVolumeOut then iVolumeOut := iVolume;

    Inc(pBufferIn);
  end;

  FWaveVolume := iVolumeOut;

  speex_bits_reset(@FBits);
  speex_encode(FState, @FBufferEnc[0], @FBits);
  iSize := speex_bits_write(@FBits, FBufferOut, MAX_NB_BYTES);

  if Assigned(FOnNewData) then FOnNewData(Self, FBufferOut, iSize, FWaveVolume);
end;

function TSpeexEncoder.GetFrameSizeInByte: integer;
begin
  Result := FrameSize * SizeOf(SmallInt);
end;

procedure TSpeexEncoder.SetQuality(const Value: integer);
begin
  FQuality := Value;

  if Active then begin
    speex_encoder_ctl(FState, SPEEX_SET_QUALITY,     @FQuality);
    speex_encoder_ctl(FState, SPEEX_SET_VBR_QUALITY, @FQuality);
  end;
end;

procedure TSpeexEncoder.SetVBR(const Value: boolean);
begin
  FVBR := Value;
  if Active then speex_encoder_ctl(FState, SPEEX_SET_VBR, @FVBR);
end;

procedure TSpeexEncoder.Start;
begin
  speex_bits_init(@FBits);
  FState := speex_encoder_init(speex_lib_get_mode(SPEEX_MODEID_NB));
  speex_encoder_ctl(FState, SPEEX_SET_SAMPLING_RATE, @FSampleRate);
  speex_encoder_ctl(FState, SPEEX_SET_QUALITY,       @FQuality);
  speex_encoder_ctl(FState, SPEEX_SET_VBR_QUALITY,   @FQuality);
  speex_encoder_ctl(FState, SPEEX_SET_VBR,           @FVBR);
  speex_encoder_ctl(FState, SPEEX_GET_FRAME_SIZE,    @FFrameSize);

  SetLength(FBufferIn, FrameSize);
  SetLength(FBufferEnc, FrameSize);

  FActive := true;

  FWaveVolume := 0;
end;

procedure TSpeexEncoder.Stop;
begin
  if not FActive then Exit;
  FActive := false;

  FWaveVolume := 0;

  speex_bits_destroy(@FBits);
  speex_encoder_destroy(FState);
end;

end.
