unit VoiceSender;

interface

uses
  CoreInterface,
  RyuLibBase, VoiceRecorder,
  SysUtils, Classes;

type
  TVoiceSender = class (TInterfaceBase, ICore)
  private // implementation of ICore
    procedure Initialize;
    procedure Finalize;
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

    procedure Start;
    procedure Stop;
  public
    property IsMute : boolean read GetIsMute write SetIsMute;
    property Volume: Single read GetVolume write SetVolume;
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