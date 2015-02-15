unit VoiceRecorder;

interface

uses
  VoiceZipUtils, WaveIn, SpeexEncoder, EchoCancel,
  RyuLibBase, SimpleThread,
  Windows, Classes, SysUtils;

type
  TVoiceRecorder = class (TComponent)
  private
    FWaveIn : TWaveIn;
    FSpeexEncoder : TSpeexEncoder;
    procedure on_VoiceDataIn(Sender:TObject; AData:pointer; ASize:integer);
    procedure on_DataEncode(Sender:TObject; AData:pointer; ASize,AVolume:integer);
  private
    FEchoTemp : pointer;
    FEchoCancel : TEchoCancel;
    FUseEchoCancel: boolean;
    FEchoData : pointer;
  private
    FOnData: TVoiceDataEvent;
    FVolumeIn: integer;
    FMute: boolean;
  protected
    function GetMute: boolean;
    procedure SetMute(const Value: boolean);
    function GetVolume: Single;
    procedure SetVolume(const Value: Single);
    function GetVolumeIn: integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start(AMicDeviceID: Integer = -1);
    procedure Stop;

    procedure SetEchoData(AValue:pointer);
  published
    property Mute : boolean read GetMute write SetMute;
    property VolumeIn: integer read GetVolumeIn;
    property Volume: Single read GetVolume write SetVolume;
    property UseEchoCancel : boolean read FUseEchoCancel write FUseEchoCancel;
    property OnData : TVoiceDataEvent read FOnData write FOnData;
  end;

  TFakeVoiceRecorder = class (TComponent)
  private
    FStarted : boolean;
  private
    FSimpleThread : TSimpleThread;
    procedure on_Repeat(Sender:TObject);
  private
    FOnData: TVoiceDataEvent;
    FMute: boolean;
    FVolume: Single;
    FVolumeIn: integer;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Start(AMicDeviceID: Integer = -1);
    procedure Stop;
  published
    property Mute : boolean read FMute write FMute;
    property VolumeIn: integer read FVolumeIn;
    property Volume: Single read FVolume write FVolume;
    property OnData : TVoiceDataEvent read FOnData write FOnData;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Voice Zip', [TVoiceRecorder]);
end;

{ TVoiceRecorder }

constructor TVoiceRecorder.Create(AOwner: TComponent);
begin
  inherited;

  FMute := false;

  GetMem(FEchoTemp, 1024);

  FUseEchoCancel := true;

  FEchoData := nil;

  FEchoCancel := TEchoCancel.Create;
  FEchoCancel.Open( _SampleRate, _FrameSize div 2);

  FSpeexEncoder := TSpeexEncoder.Create(Self);
  FSpeexEncoder.OnNewData := on_DataEncode;
  FSpeexEncoder.Start;

  FWaveIn := TWaveIn.Create(Self);
  FWaveIn.BufferSize := _FrameSize;
  FWaveIn.Channels := _Channels;
  FWaveIn.SampleRate := _SampleRate;
  FWaveIn.OnData := on_VoiceDataIn;
end;

destructor TVoiceRecorder.Destroy;
begin
  Stop;

  FWaveIn.OnData := nil;
  FEchoCancel.Close;
  FSpeexEncoder.Stop;

//  FreeAndNil(FEchoCancel);
//  FreeAndNil(FWaveIn);
//  FreeAndNil(FSpeexEncoder);

  inherited;
end;

function TVoiceRecorder.GetMute: boolean;
begin
  Result := FMute;
end;

function TVoiceRecorder.GetVolume: Single;
begin
  Result := FSpeexEncoder.Volume;
end;

function TVoiceRecorder.GetVolumeIn: integer;
begin
  Result := FVolumeIn;
end;

procedure TVoiceRecorder.on_DataEncode(Sender: TObject; AData: pointer;
  ASize, AVolume: integer);
var
  VoiceDataEvent : TVoiceDataEvent;
begin
  // TODO: 시간이 지나면 0으로 세팅
  FVolumeIn := AVolume;

  VoiceDataEvent := FOnData;
  if Assigned(VoiceDataEvent) then VoiceDataEvent(Self, AData, ASize, AVolume);
end;

procedure TVoiceRecorder.on_VoiceDataIn(Sender: TObject;
  AData: pointer; ASize: integer);
var
  pEchoData : pointer;
begin
  if not FWaveIn.Active then Exit;

  // 데이터를 아예 발생하지 않으면 음성 기준 싱크가 무너진다.
  if FMute then FillChar(AData^, ASize, #0);

  pEchoData := FEchoData;

  if (pEchoData <> nil) and FUseEchoCancel then begin
    FEchoCancel.Execute( AData, pEchoData );
    FSpeexEncoder.Excute( FEchoCancel.EchoCanceled, ASize );
  end else begin
    FSpeexEncoder.Excute( AData, ASize );
  end;
end;

procedure TVoiceRecorder.SetEchoData(AValue: pointer);
begin
  FEchoData := AValue;
end;

procedure TVoiceRecorder.SetMute(const Value: boolean);
begin
  FMute := Value;
end;

procedure TVoiceRecorder.SetVolume(const Value: Single);
begin
  FSpeexEncoder.Volume := Value;
end;

procedure TVoiceRecorder.Start(AMicDeviceID: Integer);
begin
  FWaveIn.Start(AMicDeviceID);
end;

procedure TVoiceRecorder.Stop;
begin
  FWaveIn.Stop;

  FVolumeIn := 0;
end;

{ TFakeVoiceRecorder }

constructor TFakeVoiceRecorder.Create(AOwner: TComponent);
begin
  inherited;

  FStarted := false;

  FMute := false;
  FVolume := 1.0;
  FVolumeIn := 0;

  FSimpleThread := TSimpleThread.Create(on_Repeat);
end;

procedure TFakeVoiceRecorder.on_Repeat(Sender: TObject);
var
  OldTick, Tick, Term, Count : Cardinal;
  SimpleThread : TSimpleThread absolute Sender;
begin
  OldTick := 0;
  Count := 0;

  while not SimpleThread.Terminated do begin
    if OldTick = 0 then begin
      OldTick := GetTickCount;
      Continue;
    end;

    Tick := GetTickCount;

    if OldTick > Tick then begin
      OldTick := Tick;
      Continue;
    end;

    Term := Tick - OldTick;
    Count := Count + Term;

    while Count >= 20 do begin
      if FStarted and Assigned(FOnData) then FOnData(Self, nil, 0, 0);
      Count := Count - 20;
    end;

    OldTick := Tick;

    Sleep(10);
  end;
end;

procedure TFakeVoiceRecorder.Start(AMicDeviceID: Integer);
begin
  FStarted := true;
end;

procedure TFakeVoiceRecorder.Stop;
begin
  FStarted := false;
end;

end.

