unit VoiceOut;

interface

uses
  VoicePlayer,
  SysUtils, Classes;

type
  TVoiceOut = class
  private
    FVoicePlayer : TVoicePlayer;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVoiceOut;

    procedure Start;
    procedure Stop;

    procedure DataIn(AData:pointer; ASize:integer);
  end;

implementation

{ TVoiceOut }

var
  MyObject : TVoiceOut = nil;

class function TVoiceOut.Obj: TVoiceOut;
begin
  if MyObject = nil then MyObject := TVoiceOut.Create;
  Result := MyObject;
end;

procedure TVoiceOut.Start;
begin
  FVoicePlayer.Start;
end;

procedure TVoiceOut.Stop;
begin
  FVoicePlayer.Stop;
end;

constructor TVoiceOut.Create;
begin
  inherited;

  FVoicePlayer := TVoicePlayer.Create(nil);
  FVoicePlayer.Start;
end;

procedure TVoiceOut.DataIn(AData: pointer; ASize: integer);
begin
  // TODO: 스레드 사용
  FVoicePlayer.DataIn( AData, ASize );
end;

destructor TVoiceOut.Destroy;
begin
  Stop;

  FreeAndNil(FVoicePlayer);

  inherited;
end;

initialization
  MyObject := TVoiceOut.Create;
end.