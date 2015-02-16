unit VoiceSender;

interface

uses
  RyuLibBase, VoiceRecorder,
  SysUtils, Classes;

type
  /// 음성 입력 디바이스의 데이터를 압축하여 서버로 전송하는 클래스
  TVoiceSender = class
  private
    FVoiceRecorder : TVoiceRecorder;
    procedure on_FVoiceRecorder_Data(Sender:TObject; AData:pointer; ASize,AVolume:integer);
  private
    function GetIsMute:boolean;
    procedure SetIsMute(const Value:boolean);
    function GetVolume:single;
    procedure SetVolume(const Value:single);
    function GetVolumeIn:integer;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVoiceSender;

    procedure Initialize;
    procedure Finalize;

    /// 마이크(음성 입력 디바이스)로부터 음원 캡쳐를 시작한다.
    procedure Start;

    /// 마이크를 끈다.
    procedure Stop;
  public
    /// 음 소거
    property IsMute : boolean read GetIsMute write SetIsMute;

    /// 입력 볼륨 (Volume > 1.0 이면 증폭)
    property Volume: Single read GetVolume write SetVolume;

    /// 현재 입력되고 있는 소리의 크기
    property VolumeIn : integer read GetVolumeIn;
  end;

implementation

uses
  ClientUnit;

{ TVoiceSender }

var
  MyObject : TVoiceSender = nil;

class function TVoiceSender.Obj: TVoiceSender;
begin
  if MyObject = nil then MyObject := TVoiceSender.Create;
  Result := MyObject;
end;

procedure TVoiceSender.on_FVoiceRecorder_Data(Sender: TObject; AData: pointer;
  ASize, AVolume: integer);
begin
  TClientUnit.Obj.VoiceClient.SendVoice( AData, ASize );
end;

procedure TVoiceSender.SetIsMute(const Value: boolean);
begin
  FVoiceRecorder.Mute := Value;
end;

procedure TVoiceSender.SetVolume(const Value: single);
begin
  FVoiceRecorder.Volume := Value;
end;

procedure TVoiceSender.Start;
begin
  FVoiceRecorder.Start;
end;

procedure TVoiceSender.Stop;
begin
  FVoiceRecorder.Stop;
end;

constructor TVoiceSender.Create;
begin
  inherited;

  FVoiceRecorder := TVoiceRecorder.Create(nil);
  FVoiceRecorder.OnData := on_FVoiceRecorder_Data;
end;

destructor TVoiceSender.Destroy;
begin
  Stop;

  FreeAndNil(FVoiceRecorder);

  inherited;
end;

procedure TVoiceSender.Finalize;
begin
  Stop;
end;

function TVoiceSender.GetIsMute: boolean;
begin
  Result := FVoiceRecorder.Mute;
end;

function TVoiceSender.GetVolume: single;
begin
  Result := FVoiceRecorder.Volume;
end;

function TVoiceSender.GetVolumeIn: integer;
begin
  Result := FVoiceRecorder.VolumeIn;
end;

procedure TVoiceSender.Initialize;
begin
  //
end;

initialization
  MyObject := TVoiceSender.Create;
end.