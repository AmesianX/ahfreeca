unit SuperServer;

interface

uses
  DebugTools, SuperSocketUtils, Connection, IOCP_Utils, MemoryPool,
  SimpleThread, ThreadPool,
  Windows, Messages, Classes, SysUtils, WinSock2, ExtCtrls, AnsiStrings;

type
  TServerSocketEvent = procedure (AConnection:TConnection) of object;
  TReceivedEvent = procedure (AConnection:TConnection; ACustomData:DWord; AData:pointer; ASize:integer) of object;

  TSuperServer = class (TComponent, ISuperSocketServer)
  private  // implementation of IRyuSocketServer
    function GetPacket(ACustomData:DWord; AData:pointer; ASize:integer):pointer;
    procedure Disconnect(AConnection:TObject);
    procedure Send(AConnection:TObject; ASocket:integer; ABuffer:pointer; ABufferSize:integer);
    procedure FireReceivedEvent(AConnection:TObject; ACustomData:DWord; AData:pointer; ASize:integer);
  private
    FMemoryPool : TMemoryPool;
    FSocket : TSocket;
  private
    FAcceptThread : TSimpleThread;
    procedure on_AcceptThread_Repeat(Sender:TObject);
  private
    FOldTick : Cardinal;
    FIdleTimer : TTimer;
    procedure on_IdleCheck(Sender:TObject);
  private
    FIOCP_Handle : TIOCP_Handle;
    procedure on_Start(Sender:TObject; ATransferred:DWord; AIOData:PIOData);
    procedure on_Stop(Sender:TObject; ATransferred:DWord; AIOData:PIOData);
    procedure on_Accepted(Sender:TObject; ATransferred:DWord; AIOData:PIOData);
    procedure on_Sended(Sender:TObject; ATransferred:DWord; AIOData:PIOData);
    procedure on_Received(Sender:TObject; ATransferred:DWord; AIOData:PIOData);
    procedure on_Disconnected(Sender:TObject; ATransferred:DWord; AIOData:PIOData);
  private
    FOnConnected: TServerSocketEvent;
    FConnectionList: TConnectionList;
    FOnDisconnected: TServerSocketEvent;
    FPort: integer;
    FOnReceived: TReceivedEvent;
    FUseNagel: boolean;
    procedure SetPort(const Value: integer);
    function GetActive: boolean;
    procedure SetUseNagel(const Value: boolean);
  public
     {*
       @param AMaxUser 최대 접속자 수
       @param AMemoryPoolSize 메모리 풀의 크기이다.
       @param AConnectionClass 사용자(접속) 정보를 관리하는 클래스.
         디폴트로 지정되는 정보 이외에 추가 정보 등이 필요한 경우 TConnection를
         상속 받아서 ConnectionClass 프로퍼티에 대입해주면 된다.
    }
    constructor Create(AOwner:TComponent; AMemoryPool:TMemoryPool; AMaxUser:integer=0; AConnectionClass:TConnectionClass=nil); reintroduce;

    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    /// 전체 사용자에게 패킷([Header] [Data])을 전달한다.  메모리 복사가 일어나지 않는다.
    procedure SendToAll(APacket:pointer); overload;

    /// 전체 사용자에게 데이타를 전달한다.  메모리 복사가 일어난다.
    procedure SendToAll(ACustomData:DWord; AData:pointer; ASize:integer); overload;

    /// 자신 이외의 전체 사용자에게 패킷([Header] [Data])을 전달한다.  메모리 복사가 일어나지 않는다.
    procedure SendToOther(AConnection:TConnection; APacket:pointer); overload;

    /// 자신 이외의 전체 사용자에게 데이타를 전달한다.  메모리 복사가 일어난다.
    procedure SendToOther(AConnection:TConnection; ACustomData:DWord; AData:pointer; ASize:integer); overload;

    /// 지정 된 AConnectionID의 사용자에게 패킷([Header] [Data])을 전달한다.  메모리 복사가 일어나지 않는다.
    procedure SendToConnectionID(AConnectionID:integer; APacket:pointer); overload;

    /// 지정 된 AConnectionID의 사용자에게 데이타를 전달한다.  메모리 복사가 일어난다.
    procedure SendToConnectionID(AConnectionID:integer; ACustomData:DWord; AData:pointer; ASize:integer); overload;
  published
    property Active : boolean read GetActive;
    property Port : integer read FPort write SetPort;
    property UseNagel : boolean read FUseNagel write SetUseNagel;
    property ConnectionList : TConnectionList read FConnectionList;
  published
    property OnConnected : TServerSocketEvent read FOnConnected write FOnConnected;
    property OnReceived : TReceivedEvent read FOnReceived write FOnReceived;
    property OnDisconnected : TServerSocketEvent read FOnDisconnected write FOnDisconnected;
  end;

implementation

{ TSuperServer }

constructor TSuperServer.Create(AOwner: TComponent; AMemoryPool:TMemoryPool; AMaxUser:integer; AConnectionClass: TConnectionClass);
const
  DEFAULT_MAXUSER = $FFF;
begin
  inherited Create(AOwner);

  FUseNagel := true;
  FAcceptThread := nil;

  FMemoryPool := AMemoryPool;

  if AMaxUser <= 0 then AMaxUser := DEFAULT_MAXUSER;

  FIOCP_Handle := TIOCP_Handle.Create(Self);
  FIOCP_Handle.OnStart        := on_Start;
  FIOCP_Handle.OnStop         := on_Stop;
  FIOCP_Handle.OnAccepted     := on_Accepted;
  FIOCP_Handle.OnSended       := on_Sended;
  FIOCP_Handle.OnReceived     := on_Received;
  FIOCP_Handle.OnDisconnected := on_Disconnected;

  FConnectionList := TConnectionList.Create( Self, AMaxUser, AConnectionClass );

  FOldTick := GetTickCount;

  FIdleTimer := TTimer.Create(Self);
  FIdleTimer.Interval := 1000;
  FIdleTimer.Enabled := true;
end;

destructor TSuperServer.Destroy;
begin
  Stop;

//  FreeAndNil(FMemoryPool);
//  FreeAndNil(FIOCP_Handle);
//  FreeAndNil(FConnectionList);
//  FreeAndNil(FIdleTimer);

  inherited;
end;

procedure TSuperServer.Disconnect(AConnection: TObject);
begin
  FIOCP_Handle.Disconnect( AConnection );
end;

procedure TSuperServer.FireReceivedEvent(AConnection:TObject; ACustomData: DWord; AData: pointer; ASize: integer);
begin
  if Assigned(FOnReceived) then FOnReceived(TConnection(AConnection), ACustomData, AData, ASize);
end;

function TSuperServer.GetActive: boolean;
begin
  Result := FIOCP_Handle.Active;
end;

function TSuperServer.GetPacket(ACustomData: DWord; AData: pointer;
  ASize: integer): pointer;
var
  pPacket : PSuperSocketPacket;
begin
  if ASize < 0 then
    raise Exception.Create('TRyuSocketServer.GetPacket: ASize < 0');

  FMemoryPool.GetMem(Result, ASize + SizeOf(TSuperSocketPacketHeader));

  pPacket := Result;
  pPacket^.Header.CustomData := ACustomData;
  pPacket^.Header.Size := ASize;
  if ASize > 0 then Move(AData^, pPacket^.DataStart, ASize);
end;

procedure TSuperServer.on_Accepted(Sender: TObject; ATransferred: DWord;
  AIOData: PIOData);
var
  Connection : TConnection;
begin
  Connection := FConnectionList.GetConnection(AIOData^.Socket, AIOData^.RemoteIP);

  if Connection = nil then begin
    Trace('TRyuSocketServer.on_Accepted - Connection = nil');
    Exit;
  end;

  if not FIOCP_Handle.AddSocket(AIOData^.Socket, DWORD(Connection)) then begin
    FConnectionList.ReleaseConnection(Connection);
    Trace('TRyuSocketServer.on_Accepted - FIOCP_Handle.AddSocket failed.');
    Exit;
  end;

  if Assigned(FOnConnected) then FOnConnected(Connection);

  FIOCP_Handle.Receive( Connection, Connection.Socket, FMemoryPool.GetMem(PACKET_SIZE_LIMIT), PACKET_SIZE_LIMIT );
end;

procedure TSuperServer.on_Disconnected(Sender: TObject; ATransferred: DWord;
  AIOData: PIOData);
var
  Socket : integer;
  Connection : TConnection;
begin
  Connection := Pointer(AIOData^.Connection);

  Socket := (Connection as IConnection).SetSocket( 0 );

  if Socket = 0 then Exit;

  FConnectionList.ReleaseConnection(Connection);

  shutdown( Socket, SD_BOTH );
  closesocket( Socket );

  if Assigned(FOnDisconnected) then FOnDisconnected(Connection);
end;

procedure TSuperServer.on_IdleCheck(Sender: TObject);
var
  iTerm : integer;
  iTick : Cardinal;
begin
  FIdleTimer.Enabled := false;
  try
    iTick := GetTickCount;

    if iTick > FOldTick then begin
      iTerm := iTick - FOldTick;
      FOldTick := iTick;
    end else begin
      FOldTick := iTick;
      Exit;
    end;

    if iTerm >= (FIdleTimer.Interval * 2) then Exit;

    FConnectionList.CheckIdleCount( iTerm );
  finally
    FIdleTimer.Enabled := true;
  end;
end;

function ProceedPacket(lpThreadParameter: Pointer): Integer; stdcall;
var
  AConnection : TConnection absolute lpThreadParameter;
begin
  Result := 0;
  try
    (AConnection as IConnection).ProceedPacket;
  except
    on E : Exception do begin
      AConnection.Disconnect;
      Trace((Format('TConnection.ProceedPacket: UserID=%s, %s', [AConnection.UserID, E.Message])));
    end;
  end;
end;

procedure TSuperServer.on_Received(Sender: TObject; ATransferred: DWord;
  AIOData: PIOData);
var
  Connection : TConnection;
begin
  Connection := Pointer(AIOData^.Connection);

  if Connection.IsDisconnected then Exit;

  if (ATransferred <= 0) or (ATransferred > PACKET_SIZE_LIMIT) then begin
    FIOCP_Handle.Disconnect( Connection );
    Trace( (Format('TRyuSocketServer.on_Received: UserID=%s, ATransferred=%d', [Connection.UserID, ATransferred])) );
    Exit;
  end;

  (Connection as IConnection).AddPacket( AIOData^.wsaBuffer.buf, ATransferred );
  (Connection as IConnection).ClearIdleCount;

  QueueWorkItem( ProceedPacket, Connection );

  FIOCP_Handle.Receive( Connection, Connection.Socket, FMemoryPool.GetMem(PACKET_SIZE_LIMIT), PACKET_SIZE_LIMIT );
end;

procedure TSuperServer.on_AcceptThread_Repeat(Sender: TObject);
var
  NewSocket : TSocket;
  Addr : TSockAddrIn;
  AddrLen : Integer;
  LastError : integer;
  SimpleThread : TSimpleThread absolute Sender;
begin
  while not SimpleThread.Terminated do begin
    if FSocket = INVALID_SOCKET then Break;

    AddrLen := SizeOf(Addr);
    NewSocket := WSAAccept(FSocket, PSockAddr(@Addr), @AddrLen, nil, 0);

    if SimpleThread.Terminated then Break;

    if NewSocket = INVALID_SOCKET then begin
      LastError := WSAGetLastError;
      Trace(Format('TRyuSocketServer.on_AcceptThread_Repeat: %s', [SysErrorMessage(LastError)]));

      Continue;
    end;

    SetSocketDelayOption( FSocket, FUseNagel );
    SetSocketLingerOption( NewSocket, 0 );

    FIOCP_Handle.Accepted( NewSocket, String(AnsiStrings.StrPas(inet_ntoa(sockaddr_in(Addr).sin_addr))) );
  end;
end;

procedure TSuperServer.on_Sended(Sender: TObject; ATransferred: DWord;
  AIOData: PIOData);
begin
  //
end;

procedure TSuperServer.on_Start(Sender: TObject; ATransferred: DWord;
  AIOData: PIOData);
var
  Addr : TSockAddrIn;
begin
  FSocket := WSASocket(AF_INET, SOCK_STREAM, 0, nil, 0, WSA_FLAG_OVERLAPPED);
  if FSocket = INVALID_SOCKET then
    raise Exception.Create(SysErrorMessage(WSAGetLastError));

  FillChar(Addr, SizeOf(TSockAddrIn), 0);
  Addr.sin_family := AF_INET;
  Addr.sin_port := htons(FPort);
  Addr.sin_addr.S_addr := INADDR_ANY;

  if bind(FSocket, TSockAddr(Addr), SizeOf(Addr)) <> 0 then
    raise Exception.Create(SysErrorMessage(WSAGetLastError));

  if listen(FSocket, SOMAXCONN) <> 0 then
    raise Exception.Create(SysErrorMessage(WSAGetLastError));

  SetSocketDelayOption( FSocket, FUseNagel );
  SetSocketLingerOption( FSocket, 0 );

  FAcceptThread := TSimpleThread.Create( on_AcceptThread_Repeat );
  FAcceptThread.Name := 'AcceptThread';

  FIdleTimer.OnTimer := on_IdleCheck;
end;

procedure TSuperServer.on_Stop(Sender: TObject; ATransferred: DWord;
  AIOData: PIOData);
begin
  FIdleTimer.OnTimer := nil;

  FAcceptThread.Terminate;

  if FSocket <> INVALID_SOCKET then begin
    closesocket(FSocket);
    FSocket := INVALID_SOCKET;
  end;
end;

procedure TSuperServer.SendToAll(APacket: pointer);
begin
  FConnectionList.Iterate(
    procedure (Connection:TConnection) begin
      if not Connection.IsLogined then Exit;

      Connection.Send(APacket);
    end
  );
end;

procedure TSuperServer.Send(AConnection: TObject; ASocket: integer;
  ABuffer: pointer; ABufferSize: integer);
begin
  FIOCP_Handle.Send( AConnection, ASocket, ABuffer, ABufferSize );
end;

procedure TSuperServer.SendToAll(ACustomData: DWord; AData: pointer;
  ASize: integer);
var
  pPacket : PSuperSocketPacket;
begin
  pPacket := GetPacket(ACustomData, AData, ASize);

  FConnectionList.Iterate(
    procedure (Connection:TConnection) begin
      if not Connection.IsLogined then Exit;

      Connection.Send(pPacket);
    end
  );
end;

procedure TSuperServer.SendToConnectionID(AConnectionID: integer;
  APacket: pointer);
var
  Connection : TConnection;
begin
  Connection := FConnectionList.FindConnection(AConnectionID);
  if Connection <> nil then Connection.Send(APacket);
end;

procedure TSuperServer.SendToConnectionID(AConnectionID: integer;
  ACustomData: DWord; AData: pointer; ASize: integer);
var
  pPacket : pointer;
  Connection : TConnection;
begin
  pPacket := GetPacket(ACustomData, AData, ASize);

  Connection := FConnectionList.FindConnection(AConnectionID);
  if Connection <> nil then Connection.Send(pPacket);
end;

procedure TSuperServer.SendToOther(AConnection: TConnection;
  ACustomData: DWord; AData: pointer; ASize: integer);
var
  pPacket : pointer;
begin
  pPacket := GetPacket(ACustomData, AData, ASize);

  FConnectionList.Iterate(
    procedure (Connection:TConnection) begin
      if not Connection.IsLogined then Exit;
      if AConnection = Connection then Exit;

      Connection.Send(pPacket);
    end
  );
end;

procedure TSuperServer.SendToOther(AConnection: TConnection;
  APacket: pointer);
begin
  FConnectionList.Iterate(
    procedure (Connection:TConnection) begin
      if not Connection.IsLogined then Exit;
      if AConnection = Connection then Exit;

      Connection.Send(APacket);
    end
  );
end;

procedure TSuperServer.SetPort(const Value: integer);
begin
  FPort := Value;
end;

procedure TSuperServer.SetUseNagel(const Value: boolean);
begin
  FUseNagel := Value;
end;

procedure TSuperServer.Start;
begin
  FIOCP_Handle.Start;
end;

procedure TSuperServer.Stop;
begin
  FIOCP_Handle.Stop;
end;

var
  WSAData : TWSAData;

initialization
  if WSAStartup(WINSOCK_VERSION, WSAData) <> 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
finalization
  WSACleanup;
end.

