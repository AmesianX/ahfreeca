unit VoiceQuality;

interface

uses
  Queue,
  SysUtils, Classes;

type
  TVoiceQuality = class
  private
    FQueue : TQueue;
    FOldDuration : integer;
  private
    FQuality : integer;
    function GetQuality: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(ADuration:integer);
  public
    property Quality : integer read GetQuality;
  end;

implementation

{ TVoiceQuality }

procedure TVoiceQuality.Add(ADuration: integer);
var
  pPop : pointer;
  iTerm : integer;
begin
  if FOldDuration = -1 then begin
    FOldDuration := ADuration;
    Exit;
  end;

  iTerm := Abs( ADuration - FOldDuration );
  FOldDuration := ADuration;

  if FQueue.IsFull then begin
    FQueue.Pop( pPop );
    FQuality := FQuality - Integer(pPop);
  end;

  FQuality := FQuality + iTerm;

  FQueue.Push( Pointer(iTerm) );
end;

procedure TVoiceQuality.Clear;
begin
  FOldDuration := -1;
  FQuality := 0;

  FQueue.Clear;
end;

constructor TVoiceQuality.Create;
begin
  inherited;

  // 1초에 해당하는 크기, 음성 패킷 하나가 20ms, 임계영역은 필요 없다.
  FQueue := TQueue.Create( 1000 div 20, false );

  Clear;
end;

destructor TVoiceQuality.Destroy;
begin
  FreeAndNil( FQueue );

  inherited;
end;

function TVoiceQuality.GetQuality: integer;
begin
  Result := FQuality;
end;

end.
