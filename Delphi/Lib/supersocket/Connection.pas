unit Connection;

interface

uses
  DebugTools, SuperSocketUtils, RyuLibBase, PacketReader,
  Windows, SysUtils, Classes, WinSock2, SyncObjs;

type
  TConnectionClass = class of TConnection;

  TConnection = class (TInterfaceBase, IConnection)
  private  // implementation of IConnection
    function SetSocket(AValue:integer):integer;
    procedure ClearIdleCount;
    procedure AddPacket(AData:pointer; ASize:integer);
    procedure ProceedPacket;
  private
    FSocket : integer;
    FSuperSocketServer : ISuperSocketServer;
  private
    FCS_ProceedPacket : TCriticalSection;
    FPacketReader : TPacketReader;
  protected
    procedure do_Initialization; virtual;
    procedure do_Finalization; virtual;
  private
    FIdleTime : integer;

    /// true가 리턴되면, 해당 컨넥션은 아이들 상태이다. 접속해제해야 함.
    function check_IdleCount(ATick:integer):boolean;
  private
    FIsDisconnected : integer;
    FID : integer;
    FRemoteIP: string;
    function GetIsDisconnected: boolean;
    function GetIsActive: boolean;
  public
    /// 추가 데이터를 위함 포인터
    Data : pointer;

    RoomUnit : TObject;
    RoomUser : TObject;

    RoomID : string;

    IsLogined : boolean;
    IsMute : boolean;

    UserID : string;
    UserName : string;
    UserLevel : integer;

    LocalIP : string;

    constructor Create; virtual;
    destructor Destroy; override;

    procedure Disconnect;

    function GetUserInfo:string; virtual;

    procedure SendRaw(AData:pointer; ASize:integer);

    procedure Send(ACustomData:DWord; AData:pointer; ASize:integer); overload;

    /// [Packet] = [Header:TRyuSocketPacketHeader] [Data]
    procedure Send(APacket:pointer); overload;
  public
    /// (FSocket <> 0) and (FID <> 0) and IsLogined
    property IsActive : boolean read GetIsActive;

    property Socket : integer read FSocket;

    {*
      접속이 끊어졌는 지를 알려준다.
      false 일 경우 접속이 유지되었다고 100% 장담할 수는 없다.  (풀링 등의 이유로 대기 중일 수도 있다)
      다만, true이면 접속이 100% 끊어진 것이다.
      접속이 끊어진 상태에서 추가로 프로세스가 일어나지 않도록 하기 위한 플래그이다.
    }
    property IsDisconnected : boolean read GetIsDisconnected;

    property ID : integer read FID;
    property RemoteIP : string read FRemoteIP;
  end;

  TSimpleIterateProcedure = reference to procedure(Connection:TConnection);
  TIterateProcedure = reference to procedure(Connection:TConnection; var NeedStop:boolean);

  TConnectionList = class
  private
    FSuperSocketServer : ISuperSocketServer;
    FConnectionClass : TConnectionClass;
  private
    FConnectionID : integer;
    FMaxUser : integer;
    FConnections : array of TConnection;
  private
    FCount: integer;
  public
    constructor Create(ARyuSocketServer:ISuperSocketServer; AMaxUser:integer; AConnectionClass:TConnectionClass); reintroduce;
    destructor Destroy; override;

    function GetConnection(ASocket:integer; ARemoteIP:string):TConnection;
    procedure ReleaseConnection(AConnection:TConnection);

    procedure CheckIdleCount(ATick:integer);

    procedure Iterate(AProcedure:TSimpleIterateProcedure); overload;
    procedure Iterate(AProcedure:TIterateProcedure); overload;

    function FindConnection(AConnectionID:integer):TConnection;
  public
    property Count : integer read FCount;
  end;

implementation

{ TConnection }

procedure TConnection.AddPacket(AData: pointer; ASize: integer);
begin
  FPacketReader.AddData( AData, ASize );
end;

function TConnection.check_IdleCount(ATick: integer): boolean;
var
  iIdleCount : integer;
begin
  iIdleCount := InterlockedExchangeAdd( FIdleTime, ATick );
  Result := iIdleCount >= MAX_IDLE_TIME;
end;

procedure TConnection.ClearIdleCount;
begin
  InterlockedExchange(FIdleTime, 0);
end;

constructor TConnection.Create;
begin
  inherited;

  FSocket := 0;

  FIsDisconnected := 0;

  RoomUnit := nil;
  RoomUser := nil;

  RoomID := '';

  IsLogined := false;
  IsMute := false;

  UserID := '';
  UserLevel := 0;

  LocalIP := '';

  FID := 0;
  FIdleTime := 0;

  FCS_ProceedPacket := TCriticalSection.Create;
  FPacketReader := TPacketReader.Create;
end;

destructor TConnection.Destroy;
begin
  FreeAndNil(FCS_ProceedPacket);
  FreeAndNil(FPacketReader);

  inherited;
end;

procedure TConnection.Disconnect;
begin
  FSuperSocketServer.Disconnect( Self );
end;

procedure TConnection.do_Finalization;
var
  Socket : integer;
begin
  {$IFDEF DEBUG}
//  Trace((Format('TConnection.do_Finalization - UserID: %s', [UserID]));
  {$ENDIF}

  Socket := InterlockedExchange( FSocket, 0 );

  if Socket <> 0 then begin
    SetSocketLingerOption( Socket, 0 );
    shutdown( Socket, SD_BOTH );
    closesocket( Socket );
  end;

  FRemoteIP := '';

  FPacketReader.Clear;
end;

procedure TConnection.do_Initialization;
var
  Socket : integer;
begin
  {$IFDEF DEBUG}
//  Trace(Format('TConnection.do_Initialization - UserID: %s', [UserID]));
  {$ENDIF}

  Socket := InterlockedExchange( FSocket, 0 );

  if Socket <> 0 then begin
    SetSocketLingerOption( Socket, 0 );
    shutdown( Socket, SD_BOTH );
    closesocket( Socket );
  end;

  FIsDisconnected := 0;

  RoomUnit := nil;
  RoomUser := nil;

  RoomID := '';

  IsLogined := false;
  IsMute := false;

  UserID := '';
  UserLevel := 0;

  LocalIP := '';

  FIdleTime := 0;
  FRemoteIP := '';

  FPacketReader.Clear;
end;

function TConnection.GetIsActive: boolean;
begin
  Result := (FSocket <> 0) and (FID <> 0) and IsLogined;
end;

function TConnection.GetIsDisconnected: boolean;
begin
  Result := FIsDisconnected = 1;
end;

function TConnection.GetUserInfo: string;
begin
  Result :=
    'ID='        + IntToStr(ID)              + '<rYu>' +
    'UserID='    + UserID                    + '<rYu>' +
    'UserName='  + UserName                  + '<rYu>' +
    'UserLevel=' + IntToStr(UserLevel)       + '<rYu>' +
    'IsMute='    + IntToStr(Integer(IsMute)) + '<rYu>' +
    'RemoteIP='  + RemoteIP                  + '<rYu>' +
    'LocalIP='   + LocalIP                   + '<rYu>';
end;

procedure TConnection.ProceedPacket;
var
  CustomData : DWord;
  pPacket : pointer;
  PacketSize : integer;
begin
  while True do begin
    if FIsDisconnected = 1 then Exit;

    FCS_ProceedPacket.Acquire;
    try
      if not FPacketReader.GetPacket(CustomData, pPacket, PacketSize) then Exit;

      try
        if PacketSize = 0 then begin
          Send(0, nil, 0);

        end else if PacketSize < 0 then begin
          raise Exception.Create(Format('TConnection.ProceedPacket - Packet Size Limit Error: UserID=%s, PacketSize=%d', [UserID, PacketSize]));

        end else if PacketSize > PACKET_SIZE_LIMIT then begin
          raise Exception.Create(Format('TConnection.ProceedPacket - Packet Size Limit Error: UserID=%s, PacketSize=%d', [UserID, PacketSize]));

        end else begin
          FSuperSocketServer.FireReceivedEvent(Self, CustomData, pPacket, PacketSize);
        end;
      finally
        if pPacket <> nil then FreeMem(pPacket);
      end;
    finally
      FCS_ProceedPacket.Release;
    end;
  end;
end;

procedure TConnection.Send(APacket: pointer);
var
  pHeader : PSuperSocketPacketHeader;
begin
  if FIsDisconnected = 1 then Exit;

  pHeader := Pointer(APacket);

  FSuperSocketServer.Send( Self, FSocket, APacket, pHeader^.Size + SizeOf(TSuperSocketPacketHeader) );
end;

procedure TConnection.Send(ACustomData: DWord; AData: pointer; ASize: integer);
var
  pPacket : PSuperSocketPacket;
begin
  pPacket := FSuperSocketServer.GetPacket( ACustomData, AData, ASize );
  Send( pPacket );
end;

procedure TConnection.SendRaw(AData: pointer; ASize: integer);
begin
  FSuperSocketServer.Send( Self, FSocket, AData, ASize );
end;

function TConnection.SetSocket(AValue: integer): integer;
begin
  Result := InterlockedExchange( FSocket, AValue );
end;

{ TConnectionList }

procedure TConnectionList.CheckIdleCount(ATick: integer);
var
  Loop: Integer;
begin
  for Loop := Low(FConnections) to High(FConnections) do begin
    if FConnections[Loop].IsActive and FConnections[Loop].check_IdleCount(ATick) then begin
      Trace(Format('TConnectionList.CheckIdleCount: UserID=%s, Socket=%d', [FConnections[Loop].UserID, FConnections[Loop].FSocket]));
      FConnections[Loop].Disconnect;
    end;
  end;
end;

constructor TConnectionList.Create(ARyuSocketServer:ISuperSocketServer; AMaxUser:integer; AConnectionClass:TConnectionClass);
var
  Loop: Integer;
begin
  inherited Create;

  FSuperSocketServer := ARyuSocketServer;
  FMaxUser := AMaxUser;

  FConnectionID := 0;
  FCount := 0;

  if AMaxUser = 0 then
    raise Exception.Create('TConnectionList.Create - AMaxUser = 0');

  SetLength( FConnections, AMaxUser );

  if AConnectionClass = nil then FConnectionClass := TConnection
  else FConnectionClass := AConnectionClass;

  for Loop := Low(FConnections) to High(FConnections) do begin
    TObject(FConnections[Loop]) := FConnectionClass.NewInstance;
    FConnections[Loop].Create;

    FConnections[Loop].FSuperSocketServer := ARyuSocketServer;
  end;
end;

destructor TConnectionList.Destroy;
var
  Loop: Integer;
  Connection : TConnection;
begin
  for Loop := Low(FConnections) to High(FConnections) do begin
    Connection := Pointer( InterlockedExchangePointer(Pointer(FConnections[Loop]), nil) );
    Connection.Free;
  end;

  inherited;
end;

function TConnectionList.FindConnection(AConnectionID: integer): TConnection;
var
  ID : Word;
begin
  // ID를 Word 단위로 비교해서 사용한다.
  // DWord를 사용해서 전체 비트를 이용할 수 있으나,
  // FMaxUser 넘는 범위는 무시되기 때문에 FMaxUser 값이 $FFFF를 넘지 않는 한 문제 없다.
  // 또한, RyuSocket의 CustomData의 빈 영역을 이용 할 수 있도록 한다. (특정 ConnectionID에만 패킷 보내기)
  ID := Word(AConnectionID);

  Result := nil;

  if ID <> 0 then begin
    Result := FConnections[ID mod FMaxUser];
    if (Result <> nil) and (Word(Result.FID) <> ID) then Result := nil;
  end;
end;

function TConnectionList.GetConnection(ASocket:integer; ARemoteIP:string): TConnection;
var
  iID, iOldID, iCount : integer;
begin
  Result := nil;

  // Get serial number and skip when it is zero or has taken.
  iCount := 0;
  while true do begin
    iCount := iCount + 1;
    if iCount > FMaxUser then Break;

    iID := InterlockedIncrement( FConnectionID );

    // "ID = 0" means that Connection is not assigned.
    if iID = 0 then Continue;

    iOldID := InterlockedCompareExchange( FConnections[DWord(iID) mod FMaxUser].FID, iID, 0 );

    // 아직 할달 되지 않은 Connection 객체를 찾음
    if iOldID = 0 then begin
      Result := FConnections[DWord(iID) mod FMaxUser];
      Break;
    end;
  end;

  if Result <> nil then begin
    Result.do_Initialization;

    Result.FSocket := ASocket;
    Result.FRemoteIP := ARemoteIP;

    InterlockedIncrement( FCount );
  end;
end;

procedure TConnectionList.Iterate(AProcedure: TSimpleIterateProcedure);
var
  Loop: Integer;
begin
  for Loop := Low(FConnections) to High(FConnections) do begin
    if FConnections[Loop].IsActive then
      AProcedure( FConnections[Loop] );
  end;
end;

procedure TConnectionList.Iterate(AProcedure: TIterateProcedure);
var
  Loop: Integer;
  NeedStop : boolean;
begin
  for Loop := Low(FConnections) to High(FConnections) do begin
    if FConnections[Loop].IsActive then begin
      AProcedure( FConnections[Loop], NeedStop );
      if NeedStop then Break;
    end;
  end;
end;

procedure TConnectionList.ReleaseConnection(AConnection: TConnection);
begin
  AConnection.do_Finalization;
  AConnection.FID := 0;

  InterlockedDecrement( FCount );
end;

end.
