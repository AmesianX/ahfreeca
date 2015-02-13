unit ServerUnit.TextServer;

interface

uses
  DebugTools, Config, Protocol, ProtocolText, UserLevel, UserList,
  MemoryPool, SuperServer, Connection,
  Strg, ValueList, IdURI,
  Windows, SysUtils, Classes, TypInfo;

type
  TTextServer = class
  private
    FMemoryPool : TMemoryPool;
  private
    FUserList : TUserList;
    procedure on_FUserList_UserIn(Sender:TObject; AConnection:TConnection);
    procedure on_FUserList_UserOut(Sender:TObject; AConnection:TConnection);
    procedure on_FUserList_IDinUse(Sender:TObject; AConnection:TConnection);
  private
    FSocket : TSuperServer;
    procedure on_FSocket_Connected(AConnection:TConnection);
    procedure on_FSocket_Received(AConnection:TConnection; ACustomData:DWord; AData:pointer; ASize:integer);
    procedure on_FSocket_Disconnected(AConnection:TConnection);
  private
    procedure do_LoginResult(AContext:TObject; AResult:TValueList; AErrorCode:integer);

    procedure rp_Login(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);

    procedure rp_Logout(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);

    procedure rp_UserLevel(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure rp_KickOut(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure rp_Mute(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);

    procedure rp_AskUserList(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);

    procedure rp_SetUserModeToSender(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);

    procedure rp_OnAir(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure rp_OffAir(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);

    procedure rp_UserStatus(AConnection:TConnection; ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
  private
    procedure sp_OkLogin(AConnection:TConnection);
    procedure sp_ErLogin(AConnection:TConnection; AErrorMsg:string);
    procedure sp_ErVersion(AConnection:TConnection);
    procedure sp_IDinUse(AConnection:TConnection);

    procedure sp_UserIn(AConnection:TConnection);
    procedure sp_UserOut(AConnection:TConnection);
    procedure sp_UserList(AConnection:TConnection; const AUserList:string);
  public
    constructor Create(AMemoryPool:TMemoryPool); reintroduce;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

uses
  Database;

{ TTextServer }

constructor TTextServer.Create(AMemoryPool:TMemoryPool);
begin
  inherited Create;

  FMemoryPool := AMemoryPool;

  FUserList := TUserList.Create;
  FUserList.OnUserIn := on_FUserList_UserIn;
  FUserList.OnUserOut := on_FUserList_UserOut;
  FUserList.OnIDinUse := on_FUserList_IDinUse;

  FSocket := TSuperServer.Create(nil, FMemoryPool);
  FSocket.UseNagel := false;
  FSocket.Port := TEXT_SERVER_PORT;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnReceived := on_FSocket_Received;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
end;

destructor TTextServer.Destroy;
begin
  Stop;

  FreeAndNil(FUserList);
  FreeAndNil(FSocket);

  inherited;
end;

procedure TTextServer.on_FSocket_Connected(AConnection: TConnection);
begin

end;

procedure TTextServer.on_FSocket_Disconnected(AConnection: TConnection);
begin
  FUserList.Remove( AConnection );
end;

procedure TTextServer.on_FSocket_Received(AConnection: TConnection;
  ACustomData: DWord; AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader absolute ACustomData;
begin
  {$IFDEF DEBUG}
  Trace( Format('TTextServer.on_FSocket_Received - PacketType: %s', [GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType)]) );
  {$ENDIF}

  try
    case CustomHeader.Direction of
      pdSendToAll: FSocket.SendToAll( ACustomData, AData, ASize );
      pdSendToOther: FSocket.SendToOther( AConnection, ACustomData, AData, ASize );
      pdSentToID: FSocket.SendToConnectionID( CustomHeader.ID, ACustomData, AData, ASize );
    end;

    case TPacketType(CustomHeader.PacketType) of
      ptLogin: rp_Login(AConnection, CustomHeader, AData, ASize);
      ptLogout: rp_Logout(AConnection, CustomHeader, AData, ASize);

      ptUserLevel: rp_UserLevel(AConnection, CustomHeader, AData, ASize);
      ptKickOut: rp_KickOut(AConnection, CustomHeader, AData, ASize);
      ptMute: rp_Mute(AConnection, CustomHeader, AData, ASize);

      ptSetUserModeToSender: rp_SetUserModeToSender(AConnection, CustomHeader, AData, ASize);

      ptAskUserList: rp_AskUserList(AConnection, CustomHeader, AData, ASize);

      ptOnAir: rp_OnAir(AConnection, CustomHeader, AData, ASize);
      ptOffAir: rp_OffAir(AConnection, CustomHeader, AData, ASize);

      ptUserStatus: rp_UserStatus(AConnection, CustomHeader, AData, ASize);
    end;
  except
     on E : Exception do begin
       Trace( 'TTextServer.on_FSocket_Received: ' + E.Message );
       Trace( '  * PacketType: ' + GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType) );

       AConnection.Disconnect;
     end;
  end;
end;

procedure TTextServer.on_FUserList_IDinUse(Sender: TObject;
  AConnection: TConnection);
begin
  sp_IDinUse( AConnection );
end;

procedure TTextServer.on_FUserList_UserIn(Sender: TObject;
  AConnection: TConnection);
begin
  sp_OkLogin( AConnection );
  sp_UserIn( AConnection );
end;

procedure TTextServer.on_FUserList_UserOut(Sender: TObject;
  AConnection: TConnection);
begin
  sp_UserOut( AConnection );
end;

procedure TTextServer.rp_AskUserList(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin
  FUserList.GetUserList(
    AConnection,
    procedure(UserList:string)
    begin
      sp_UserList( AConnection, UserList );
    end
  );
end;

procedure TTextServer.rp_KickOut(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
var
  sUserID : string;
  ValueList : TValueList;
  Connection : TConnection;
begin
  if not AConnection.IsLogined then Exit;

  if AConnection.UserLevel < TUserLevel.ADMIN then Exit;

  FSocket.SendToAll( ACustomHeader.ToDWord, AData, ASize );

  ValueList := TValueList.Create;
  try
    ValueList.Text := DataToText( AData, ASize );

    sUserID := ValueList.Values['UserID'];
  finally
    ValueList.Free;
  end;

  Connection := FUserList.FindByUserID( sUserID );
  if Connection <> nil then Connection.Disconnect;
end;

procedure TTextServer.do_LoginResult(AContext: TObject; AResult: TValueList;
  AErrorCode: integer);
var
  ErrorMsg : string;
  IsLogined : boolean;
  Connection : TConnection absolute AContext;
begin
  if Connection.IsLogined then Exit;
  if Connection.IsDisconnected then Exit;

  IsLogined := AResult.Booleans['result'];

  Connection.RoomID := AResult.Values['room_id'];
  Connection.UserName := AResult.Values['user_name'];
  Connection.UserLevel := AResult.Integers['user_level'];

  // 무료 버전 또는 테스트용으로 무조건 로그인 되는 경우에는 사용자 아이디가 URL 인코딩 되지 않는다.
  if not AResult.Booleans['FreeLogin'] then begin
    Connection.UserID := TIdURI.URLDecode(Connection.UserID);
    Connection.UserID := StringReplace(Connection.UserID, '%20', ' ', [rfReplaceAll]);
  end;

  ErrorMsg := AResult.Values['error_msg'];

  if Trim(ErrorMsg) <> '' then begin
    ErrorMsg := TIdURI.URLDecode(ErrorMsg);
    ErrorMsg := StringReplace(ErrorMsg, '%20', ' ', [rfReplaceAll]);
  end else begin
    ErrorMsg := AResult.Values['error_msg_euc-kr'];
  end;

  if not IsLogined then begin
    sp_ErLogin(Connection, ErrorMsg);
    Exit;
  end;

  Connection.IsLogined := IsLogined;

  FUserList.Add( Connection );
end;

procedure TTextServer.rp_Login(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
var
  ValueList : TValueList;
begin
  if AConnection.IsLogined then Exit;

  ValueList := TValueList.Create;
  try
    ValueList.Text := DataToText( AData, ASize );

    {$IFDEF DEBUG}
    Trace( Format('TTextServer.rp_Login: %s', [ValueList.Text]) );
    {$ENDIF}

    if ValueList.Integers['Version'] <> PROTOCOL_VERSION then begin
      sp_ErVersion(AConnection);
      Exit;
    end;

    AConnection.UserID := ValueList.Values['UserID'];
    AConnection.LocalIP := ValueList.Values['LocalIP'];

    TDatabase.Obj.RequestLogin( AConnection, ValueList.Text,
      procedure(Context:TObject; Result:TValueList; ErrorCode:integer)
      begin
        if ErrorCode = 0 then do_LoginResult( Context, Result, ErrorCode )
        else sp_ErLogin( AConnection, '로그인 처리 중 문제가 발생하였습니다.' );
      end
    );
  finally
    ValueList.Free;
  end;
end;

procedure TTextServer.rp_Logout(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin
  AConnection.Disconnect;
end;

procedure TTextServer.rp_Mute(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin

end;

procedure TTextServer.rp_OffAir(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin

end;

procedure TTextServer.rp_OnAir(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin

end;

procedure TTextServer.rp_SetUserModeToSender(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin

end;

procedure TTextServer.rp_UserLevel(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin

end;

procedure TTextServer.rp_UserStatus(AConnection: TConnection;
  ACustomHeader: TCustomHeader; AData: pointer; ASize: integer);
begin

end;

procedure TTextServer.sp_ErLogin(AConnection: TConnection; AErrorMsg: string);
var
  Data : pointer;
  Size : integer;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.PacketType := Byte( ptErLogin );

  TextToData( 'Msg=' + AErrorMsg, Data, Size );
  try
    AConnection.Send( CustomHeader.ToDWord, Data, Size );
  finally
    if Data <> nil then FreeMem(Data);
  end;
end;

procedure TTextServer.sp_ErVersion(AConnection: TConnection);
var
  Dummy : byte;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.PacketType := Byte( ptErVersion );

  AConnection.Send( CustomHeader.ToDWord, @Dummy, SizeOf(Dummy) );
end;

procedure TTextServer.sp_IDinUse(AConnection: TConnection);
var
  Dummy : byte;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.PacketType := Byte( ptIDinUse );

  AConnection.Send( CustomHeader.ToDWord, @Dummy, SizeOf(Dummy) );
end;

procedure TTextServer.sp_OkLogin(AConnection: TConnection);
var
  Data : pointer;
  Size : integer;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.PacketType := Byte( ptOkLogin );

  TextToData( AConnection.GetUserInfo, Data, Size );
  try
    AConnection.Send( CustomHeader.ToDWord, Data, Size );
  finally
    if Data <> nil then FreeMem(Data);
  end;
end;

procedure TTextServer.sp_UserIn(AConnection: TConnection);
var
  Data : pointer;
  Size : integer;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.PacketType := Byte( ptUserIn );

  TextToData( AConnection.GetUserInfo, Data, Size );
  try
    FSocket.SendToOther( AConnection, CustomHeader.ToDWord, Data, Size );
  finally
    if Data <> nil then FreeMem(Data);
  end;
end;

procedure TTextServer.sp_UserList(AConnection: TConnection;
  const AUserList: string);
var
  Data : pointer;
  Size : integer;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.PacketType := Byte( ptUserList );

  TextToData( AUserList, Data, Size );
  try
    AConnection.Send( CustomHeader.ToDWord, Data, Size );
  finally
    if Data <> nil then FreeMem(Data);
  end;
end;

procedure TTextServer.sp_UserOut(AConnection: TConnection);
var
  Data : pointer;
  Size : integer;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.PacketType := Byte( ptUserOut );

  TextToData( AConnection.GetUserInfo, Data, Size );
  try
    FSocket.SendToOther( AConnection, CustomHeader.ToDWord, Data, Size );
  finally
    if Data <> nil then FreeMem(Data);
  end;
end;

procedure TTextServer.Start;
begin
  FSocket.Start;
end;

procedure TTextServer.Stop;
begin
  FSocket.Stop;
end;

end.
