unit ClientUnit;

interface

uses
  CoreInterface,
  ClientUnit.TextClient,
  ClientUnit.VoiceClient,
  ClientUnit.VideoClient,
  Config, Protocol,
  RyuLibBase,
  SysUtils, Classes;

type
  {*
    클라이언트 소켓들의 관리를 목적으로 만든 클래스이다.
    소켓은 Text, Voice, Video 가 서도 다른 포트를 사용하고 있다.
  }
  TClientUnit = class
  private
    FTextClient : TTextClient;
  private
    FVoiceClient : TVoiceClient;
  private
    FVideoClient : TVideoClient;
    function GetTextClient: ITextClient;
    function GetVoiceClient: IVoiceClient;
    function GetVideoClient: IVideoClient;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TClientUnit;

    procedure Initialize;
    procedure Finalize;

    {*
      서버에 접속한다.
      Text, Voice, Video 소켓 전부가 접속되지 않으면 에러처리 한다.
      에러처리는 sp_Terminate를 이용해서 프로그램을 종료하도록 View 메시지를 보낸다.
    }
    procedure Connect;

    /// 서버 접속을 종료한다.
    procedure Disconnect;
  public
    property TextClient : ITextClient read GetTextClient;
    property VoiceClient : IVoiceClient read GetVoiceClient;
    property VideoClient : IVideoClient read GetVideoClient;
  end;

implementation

uses
  Core;

{ TClientUnit }

var
  MyObject : TClientUnit = nil;

class function TClientUnit.Obj: TClientUnit;
begin
  if MyObject = nil then MyObject := TClientUnit.Create;
  Result := MyObject;
end;

procedure TClientUnit.Connect;
begin
  if not FTextClient.Connect then begin
    TCore.Obj.View.sp_Terminate( '서버에 접속 할 수가 없습니다.' );
    Exit;
  end;

  if not FVoiceClient.Connect then begin
    TCore.Obj.View.sp_Terminate( '서버에 접속 할 수가 없습니다.' );
    Exit;
  end;

  if not FVideoClient.Connect then begin
    TCore.Obj.View.sp_Terminate( '서버에 접속 할 수가 없습니다.' );
    Exit;
  end;

  FTextClient.sp_Login;
end;

constructor TClientUnit.Create;
begin
  inherited;

  FTextClient := TTextClient.Create;
  FVoiceClient := TVoiceClient.Create;
  FVideoClient := TVideoClient.Create;
end;

destructor TClientUnit.Destroy;
begin
  Disconnect;

  FreeAndNil(FTextClient);
  FreeAndNil(FVoiceClient);
  FreeAndNil(FVideoClient);

  inherited;
end;

procedure TClientUnit.Disconnect;
begin

end;

procedure TClientUnit.Finalize;
begin
  Disconnect;
end;

function TClientUnit.GetTextClient: ITextClient;
begin
  Result := FTextClient;
end;

function TClientUnit.GetVideoClient: IVideoClient;
begin
  Result := FVideoClient as IVideoClient;
end;

function TClientUnit.GetVoiceClient: IVoiceClient;
begin
  Result := FVoiceClient as IVoiceClient;
end;

procedure TClientUnit.Initialize;
begin
  //
end;

initialization
  MyObject := TClientUnit.Create;
end.