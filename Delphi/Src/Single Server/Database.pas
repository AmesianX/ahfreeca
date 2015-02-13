unit Database;

interface

uses
  ValueList, ThreadPool,
  SysUtils, Classes;

type
  TResultOfLogin = reference to procedure(Context:TObject; Result:TValueList; ErrorCode:integer);

  TDatabase = class
  private
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TDatabase;

    procedure RequestLogin(AContext:TObject; ARequest:string; ACallbak:TResultOfLogin);
  end;

implementation

type
  TRequest = class
    Context : TObject;
    Request : string;
    Callbak : TResultOfLogin;
  end;

{ TDatabase }

var
  MyObject : TDatabase = nil;

class function TDatabase.Obj: TDatabase;
begin
  if MyObject = nil then MyObject := TDatabase.Create;
  Result := MyObject;
end;

function ThreadFunctionLogin(lpThreadParameter: Pointer): Integer; stdcall;
var
  ValueList : TValueList;
  Request : TRequest absolute lpThreadParameter;
begin
  Result := 0;

  ValueList := TValueList.Create;
  try
    try
      // TODO:

      ValueList.Booleans['Result'] := true;

      Request.Callbak( Request.Context, ValueList, 0 );
    except
      on E : Exception do begin
        ValueList.Values['Msg'] := E.Message;
        Request.Callbak( Request.Context, ValueList, -1 );
      end;
    end;
  finally
    ValueList.Free;
    Request.Free;
  end;
end;

procedure TDatabase.RequestLogin(AContext: TObject; ARequest: string;
  ACallbak: TResultOfLogin);
var
  Request : TRequest;
begin
  Request := TRequest.Create;
  Request.Context := AContext;
  Request.Request := ARequest;
  Request.Callbak := ACallbak;

  QueueIOWorkItem( ThreadFunctionLogin, Request );
end;

constructor TDatabase.Create;
begin
  inherited;

end;

destructor TDatabase.Destroy;
begin

  inherited;
end;

initialization
  MyObject := TDatabase.Create;
end.