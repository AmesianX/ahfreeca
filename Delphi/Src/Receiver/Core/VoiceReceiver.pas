unit VoiceReceiver;

interface

uses
  RyuLibBase, VoicePlayer, VoiceZipUtils,
  SysUtils, Classes;

type
  /// 서버로부터 수신한 음성 패킷을 디코딩 및 재생하는 클래스
  TVoiceReceiver = class
  private
    FVoicePlayer : TVoicePlayer;
  private
    function GetIsMute:boolean;
    procedure SetIsMute(AValue:boolean);
    function GetVolume: Single;
    procedure SetVolume(const Value: Single);
    function GetVolumeOut:integer;
    function GetDelayedTime: integer;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVoiceReceiver;

    procedure Initialize;
    procedure Finalize;

    /// 음성 재생을 시작한다.  (음성 출력 디바이스 오픈)
    procedure Start;

    /// 음성 재생을 멈춘다.
    procedure Stop;

    {*
      수신 된 패킷을 재생한다.
      @param AData 수신 된 데이터의 포인터 주소
      @Param ASize 수신 된 데이터의 바이트 크기
    }
    procedure DataIn(AData:pointer; ASize:integer);
  public
    /// 음소거
    property IsMute : boolean read GetIsMute write SetIsMute;

    /// 출력 볼륨 (Volume > 1.0 이면 증폭)
    property Volume: Single read GetVolume write SetVolume;

    /// 현재 재생되고 있는 소리의 크기
    property VolumeOut : integer read GetVolumeOut;

    /// 버퍼에 쌓여서 아직 출력되고 있지 않는 데이터의 양 (ms 단위)
    property DelayedTime : integer read GetDelayedTime;
  end;

implementation

{ TVoiceReceiver }

var
  MyObject : TVoiceReceiver = nil;

class function TVoiceReceiver.Obj: TVoiceReceiver;
begin
  if MyObject = nil then MyObject := TVoiceReceiver.Create;
  Result := MyObject;
end;

procedure TVoiceReceiver.SetIsMute(AValue: boolean);
begin
  FVoicePlayer.Mute := AValue;
end;

procedure TVoiceReceiver.SetVolume(const Value: Single);
begin
  FVoicePlayer.Volume := Value;
end;

procedure TVoiceReceiver.Start;
begin
  FVoicePlayer.Start;
end;

procedure TVoiceReceiver.Stop;
begin
  FVoicePlayer.Stop;
end;

constructor TVoiceReceiver.Create;
begin
  inherited;

  FVoicePlayer := TVoicePlayer.Create(nil);
  FVoicePlayer.Start;
end;

procedure TVoiceReceiver.DataIn(AData: pointer; ASize: integer);
begin
  FVoicePlayer.DataIn( AData, ASize );
end;

destructor TVoiceReceiver.Destroy;
begin
  Stop;

  FreeAndNil(FVoicePlayer);

  inherited;
end;

procedure TVoiceReceiver.Finalize;
begin
  Stop;
end;

function TVoiceReceiver.GetDelayedTime: integer;
begin
  Result := (FVoicePlayer as IAudioDecoder).DelayedTime;
end;

function TVoiceReceiver.GetIsMute: boolean;
begin
  Result := FVoicePlayer.Mute;
end;

function TVoiceReceiver.GetVolume: Single;
begin
  Result := FVoicePlayer.Volume;
end;

function TVoiceReceiver.GetVolumeOut: integer;
begin
  Result := FVoicePlayer.VolumeOut;
end;

procedure TVoiceReceiver.Initialize;
begin
  //
end;

initialization
  MyObject := TVoiceReceiver.Create;
end.