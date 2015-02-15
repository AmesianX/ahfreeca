unit Frames;

interface

uses
  _frUserList,
  SysUtils, Classes;

type
  TFrames = class
  private
    FUserList: TfrUserList;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TFrames;
  public
    property UserList : TfrUserList read FUserList write FUserList;
  end;

implementation

{ TFrames }

var
  MyObject : TFrames = nil;

class function TFrames.Obj: TFrames;
begin
  if MyObject = nil then MyObject := TFrames.Create;
  Result := MyObject;
end;

constructor TFrames.Create;
begin
  inherited;

end;

destructor TFrames.Destroy;
begin

  inherited;
end;

initialization
  MyObject := TFrames.Create;
end.