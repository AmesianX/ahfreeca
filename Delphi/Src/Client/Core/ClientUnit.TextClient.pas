unit ClientUnit.TextClient;

interface

uses
  ClientUnit.TextClient.UserList,
  CoreInterface,
  Config, Protocol, ProtocolText,
  DebugTools, RyuLibBase, SuperClient, Strg, ValueList,
  Windows, SysUtils, Classes, Graphics, ComCtrls, TypInfo;

type
  TTextClient = class (TInterfaceBase, ITextClient)
  private  // implementation of ITextClient
    procedure sp_KickOut(AUserID:string);
    procedure sp_Mute(AUserID:string; AMute:boolean);
    procedure sp_Chat(AFromID,AMsg:string; AColor:TColor);
    procedure sp_Whisper(AFromID,AUserIDs,AMsg:string; AColor:TColor);
    procedure sp_OnAir;
    procedure sp_OffAir;

    procedure GetUserList(AListView:TListView);
    function GetUserMuteStatus(AUserID:string):boolean;
    function GetIsSender:boolean;
  private
    FUserList : TUserList;
  private
    FSocket : TSuperClient;
    procedure on_FSocket_Connected(Sender:TObject);
    procedure on_FSocket_Received(Sender:TObject; ACustomData:DWord; AData:pointer; ASize:integer);
    procedure on_FSocket_Disconnected(Sender:TObject);
  private
    procedure rp_OkLogin(ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure rp_UserIn(ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure rp_UserList(ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure rp_UserOut(ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure rp_Mute(ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
  public
    constructor Create;
    destructor Destroy; override;

    function Connect:boolean;
    procedure Disconnect;
  public
    procedure sp_Login;
    procedure sp_AskUserList;
  end;

implementation

uses
  Core;

{ TTextClient }

function TTextClient.Connect: boolean;
begin
  FSocket.Host := TCore.Obj.Option.Host;
  FSocket.Port := TEXT_SERVER_PORT;

  FSocket.Connect;

  Result := FSocket.Connected;
end;

constructor TTextClient.Create;
begin
  inherited;

  FUserList := TUserList.Create;

  FSocket := TSuperClient.Create(nil);
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnReceived := on_FSocket_Received;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
end;

destructor TTextClient.Destroy;
begin
  Disconnect;

  FreeAndNil(FUserList);
  FreeAndNil(FSocket);

  inherited;
end;

procedure TTextClient.Disconnect;
begin
  FSocket.Disconnect;
end;

function TTextClient.GetIsSender: boolean;
begin
  // TODO:
  Result := true;
end;

procedure TTextClient.GetUserList(AListView: TListView);
begin
  FUserList.Update( AListView );
end;

function TTextClient.GetUserMuteStatus(AUserID: string): boolean;
begin
  // TODO:
  Result := FUserList.GetUserMuteStatus( AUserID );
end;

procedure TTextClient.on_FSocket_Connected(Sender: TObject);
begin

end;

procedure TTextClient.on_FSocket_Disconnected(Sender: TObject);
begin
  // TODO: 접속 종료 처리 (에러 처리, 프로그램 종료)
end;

procedure TTextClient.on_FSocket_Received(Sender: TObject; ACustomData: DWord;
  AData: pointer; ASize: integer);
var
  sPacketType, sParams : string;
  CustomHeader : TCustomHeader absolute ACustomData;
begin
  sPacketType := GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType);
  sParams := DataToText(AData, ASize);

  {$IFDEF DEBUG}
  Trace( Format('TTextClient.on_FSocket_Received - PacketType: %s', [sPacketType]) );
  Trace( '  * Text: ' + sParams );
  {$ENDIF}

  case TPacketType(CustomHeader.PacketType) of
    ptOkLogin: rp_OkLogin(CustomHeader, AData, ASize);
    ptUserIn: rp_UserIn(CustomHeader, AData, ASize);
    ptUserList: rp_UserList(CustomHeader, AData, ASize);
    ptUserOut: rp_UserOut(CustomHeader, AData, ASize);
    ptMute: rp_Mute(CustomHeader, AData, ASize);
  end;

  Delete( sPacketType, 1, 2 );
  TCore.Obj.View.AsyncBroadcast( Format('Code=%s<rYu>%s', [sPacketType, sParams]) );
end;

procedure TTextClient.rp_Mute(ACustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin
  FUserList.SetUserMuteStatus( DataToText(AData, ASize) );
  TCore.Obj.View.sp_UserListChanged;
end;

procedure TTextClient.rp_OkLogin(ACustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin
  FUserList.UserIn( DataToText(AData, ASize) );
  TCore.Obj.View.sp_UserListChanged;

  sp_AskUserList;
end;

procedure TTextClient.rp_UserIn(ACustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin
  FUserList.UserIn( DataToText(AData, ASize) );
  TCore.Obj.View.sp_UserListChanged;
end;

procedure TTextClient.rp_UserList(ACustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin
  FUserList.UserIn( DataToText(AData, ASize) );
  TCore.Obj.View.sp_UserListChanged;
end;

procedure TTextClient.rp_UserOut(ACustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin
  FUserList.UserOut( DataToText(AData, ASize) );
  TCore.Obj.View.sp_UserListChanged;
end;

procedure TTextClient.sp_AskUserList;
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptAskUserList );

  FSocket.SendNow( CustomHeader.ToDWord );
end;

procedure TTextClient.sp_Chat(AFromID, AMsg: string; AColor: TColor);
var
  ValueList : TValueList;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptChat );
  CustomHeader.Direction := pdSendToAll;

  ValueList := TValueList.Create;
  try
    ValueList.Values['FromID'] := AFromID;
    ValueList.Values['Msg'] := AMsg;
    ValueList.Integers['Color'] := AColor;

    FSocket.SendNow( CustomHeader.ToDWord, ValueList.Text );
  finally
    ValueList.Free;
  end;
end;

procedure TTextClient.sp_KickOut(AUserID: string);
var
  ValueList : TValueList;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptKickOut );

  ValueList := TValueList.Create;
  try
    ValueList.Values['UserID'] := AUserID;

    FSocket.SendNow( CustomHeader.ToDWord, ValueList.Text );
  finally
    ValueList.Free;
  end;
end;

procedure TTextClient.sp_Login;
var
  ValueList : TValueList;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptLogin );

  ValueList := TValueList.Create;
  try
    // TODO: LoginString

    ValueList.Integers['Version'] := PROTOCOL_VERSION;
    ValueList.Values['UserID'] := TCore.Obj.Option.UserID;
    ValueList.Values['UserPW'] := TCore.Obj.Option.UserPW;

    FSocket.SendNow( CustomHeader.ToDWord, ValueList.Text );
  finally
    ValueList.Free;
  end;
end;

procedure TTextClient.sp_Mute(AUserID: string; AMute: boolean);
var
  ValueList : TValueList;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptMute );

  ValueList := TValueList.Create;
  try
    ValueList.Values['UserID'] := AUserID;
    ValueList.Booleans['Mute'] := AMute;

    FSocket.SendNow( CustomHeader.ToDWord, ValueList.Text );
  finally
    ValueList.Free;
  end;
end;

procedure TTextClient.sp_OffAir;
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptOffAir );
  CustomHeader.Direction := pdSendToOther;

  FSocket.SendNow( CustomHeader.ToDWord );
end;

procedure TTextClient.sp_OnAir;
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptOnAir );
  CustomHeader.Direction := pdSendToOther;

  FSocket.SendNow( CustomHeader.ToDWord );
end;

procedure TTextClient.sp_Whisper(AFromID, AUserIDs, AMsg: string; AColor: TColor);
var
  ValueList : TValueList;
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.PacketType := Byte( ptWhisper );

  ValueList := TValueList.Create;
  try
    ValueList.Values['FromID'] := AFromID;
    ValueList.Values['UserIDs'] := AUserIDs;
    ValueList.Values['Msg'] := AMsg;
    ValueList.Integers['Color'] := AColor;

    FSocket.SendNow( CustomHeader.ToDWord, ValueList.Text );
  finally
    ValueList.Free;
  end;
end;

end.
