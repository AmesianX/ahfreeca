unit VoiceIn;

interface

uses
  VoiceRecorder,
  SysUtils, Classes;

type
  TVoiceIn = class
  private
    FVoiceRecorder : TVoiceRecorder;
    procedure on_FVoiceRecorder_VoiceData(Sender:TObject; AData:pointer; ASize,AVolume:integer);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVoiceIn;

    procedure Start;
    procedure Stop;
  end;

implementation

uses
  ClientSocket;

{ TVoiceIn }

var
  MyObject : TVoiceIn = nil;

class function TVoiceIn.Obj: TVoiceIn;
begin
  if MyObject = nil then MyObject := TVoiceIn.Create;
  Result := MyObject;
end;

procedure TVoiceIn.on_FVoiceRecorder_VoiceData(Sender: TObject; AData: pointer; ASize,
  AVolume: integer);
begin
  TClientSocket.Obj.SendVoice( AData, ASize );
end;

procedure TVoiceIn.Start;
begin
  FVoiceRecorder.Start;
end;

procedure TVoiceIn.Stop;
begin
  FVoiceRecorder.Stop;
end;

constructor TVoiceIn.Create;
begin
  inherited;

  FVoiceRecorder := TVoiceRecorder.Create(nil);
  FVoiceRecorder.OnData := on_FVoiceRecorder_VoiceData;
end;

destructor TVoiceIn.Destroy;
begin
  Stop;

  FreeAndNil(FVoiceRecorder);

  inherited;
end;

initialization
  MyObject := TVoiceIn.Create;
end.