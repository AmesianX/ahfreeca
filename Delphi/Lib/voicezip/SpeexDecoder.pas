unit SpeexDecoder;

interface

uses
  VoiceZipUtils, Speex, TickCounter,
  Windows, Classes, SysUtils;

const
  _NormalizerInterval = 1000;

type
  TSpeexDecoder = class (TComponent)
  private
    FBits : TSpeexBits;
    FState : Pointer;
    FFrameSize : integer;
    FBufferDec : TBufferSingle;
    FBufferOut : TBufferSmallInt;
  private // Normalizer
    FVolumeCopy : single;
    FTickCounter : TTickCounter;
  private
    FPerceptualPostFiltering: boolean;
    FActive: boolean;
    FOnData: TVoiceDataEvent;
    FVolume: single;
    FDelay: integer;
    FWaveVolume: integer;
    procedure SetPerceptualPostFiltering(const Value: boolean);
    procedure SetVolume(const Value: single);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure Excute(AData:pointer; ASize:integer); overload;
    procedure Excute(Stream:TStream); overload;
  published
    property Active : boolean read FActive;
    property FrameSize : integer read FFrameSize;
    property Volume : single read FVolume write SetVolume;
    property WaveVolume : integer read FWaveVolume;
    property PerceptualPostFiltering : boolean read FPerceptualPostFiltering write SetPerceptualPostFiltering;
    property OnData : TVoiceDataEvent read FOnData write FOnData;
  end;

implementation

{ TSpeexDecoder }

constructor TSpeexDecoder.Create(AOwner: TComponent);
begin
  inherited;

  FActive := false;
  FVolume := 1.0;
  FWaveVolume := 0;
  FPerceptualPostFiltering := false;
  FDelay := 0;

  FVolumeCopy := 1.0;
  FTickCounter := TTickCounter.Create;
end;

destructor TSpeexDecoder.Destroy;
begin
  Stop;

  FreeAndNil(FTickCounter);

  inherited;
end;

procedure TSpeexDecoder.Excute(Stream: TStream);
var
  Data : pointer;
begin
  if not FActive then Exit;

  GetMem(Data, Stream.Size);
  try
    Stream.Position := 0;
    Stream.Read(Data^, Stream.Size);

    Excute(Data, Stream.Size);
  finally
    FreeMem(Data);
  end;
end;

procedure TSpeexDecoder.Excute(AData: pointer; ASize: integer);
var
  Loop, iVolume, iVolumeOut : integer;
begin
  if not FActive then Exit;

  speex_bits_read_from(@FBits, AData, ASize);
  speex_decode(FState, @FBits, @FBufferDec[0]);

  if (FVolume <> FVolumeCopy) and (FTickCounter.GetDuration > _NormalizerInterval)  then FVolumeCopy := FVolume;

  iVolumeOut := 0;
  for Loop := 0 to FrameSize-1 do begin
    FBufferOut[Loop] := Round( FBufferDec[Loop] * FVolumeCopy );

    iVolume := Abs(Round(FBufferDec[Loop]));
    if iVolume > iVolumeOut then iVolumeOut := iVolume;
  end;

  if Round(iVolumeOut * FVolumeCopy) >= High(SmallInt) then begin
    FTickCounter.Start;
    FVolumeCopy := (High(SmallInt) / iVolumeOut) * 0.9;
    for Loop := 0 to FrameSize-1 do FBufferOut[Loop] := Round( FBufferDec[Loop] * FVolumeCopy );
  end;

  FWaveVolume := iVolumeOut;

  if Assigned(FOnData) then FOnData(Self, @FBufferOut[0], FrameSize*SizeOf(SmallInt), FWaveVolume);
end;

procedure TSpeexDecoder.SetPerceptualPostFiltering(const Value: boolean);
begin
  FPerceptualPostFiltering := Value;
end;

procedure TSpeexDecoder.SetVolume(const Value: single);
begin
  FVolume := Value;
  FVolumeCopy := Value;
end;

procedure TSpeexDecoder.Start;
begin
  speex_bits_init(@FBits);
  FState := speex_decoder_init(speex_lib_get_mode(SPEEX_MODEID_NB));
  speex_decoder_ctl(FState, SPEEX_GET_FRAME_SIZE, @FFrameSize);
  speex_decoder_ctl(FState, SPEEX_SET_ENH , @FPerceptualPostFiltering);

  SetLength(FBufferDec, FrameSize);
  SetLength(FBufferOut, FrameSize);

  FActive := true;

  FWaveVolume := 0;
end;

procedure TSpeexDecoder.Stop;
begin
  if not FActive then Exit;

  FActive := false;

  FWaveVolume := 0;

  speex_bits_destroy(@FBits);
  speex_decoder_destroy(FState);
end;

end.
