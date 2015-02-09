unit SuperClient.Socket;

interface

uses
  DebugTools, SuperSocketUtils, PacketReader,
  IdGlobal, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  Windows, Classes, SysUtils, SyncObjs;

type
  TSocket = class (TComponent)
  private
    FCS : TCriticalSection;
    FPacketReader : TPacketReader;
    procedure do_Send(ACustomData:DWord; AData:Pointer; ASize:integer);
    procedure do_Disconnect;
  private
    FSocket : TIdTCPClient;
    procedure on_SocketDisconnected(Sender: TObject);
  private
    FConnected: boolean;
    FNeedDisconnectedEvent : boolean;
    function GetHost: string;
    function GetPort: integer;
    procedure SetHost(const Value: string);
    procedure SetPort(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;

    procedure DisconnectForIdle;

    function CheckForDataOnSource:boolean;

    function ReadPacket(var ACustomData:DWord; var AData:pointer; var ASize:integer):boolean;

    procedure Send(ACustomData:DWord; AData:Pointer; ASize:integer);
    procedure SendNow(ACustomData:DWord; AData:Pointer; ASize:integer);

    procedure Flush;
  published
    property Connected : boolean read FConnected;
    property NeedDisconnectedEvent : boolean read FNeedDisconnectedEvent;
    property Host : string read GetHost write SetHost;
    property Port : integer read GetPort write SetPort;
  end;

implementation

{ TSocket }

function TSocket.CheckForDataOnSource:boolean;
var
  Buffer : TIdBytes;
  iReadSize : integer;
begin
  Result := false;

  if not FConnected then Exit;

  try
    FSocket.IOHandler.CheckForDataOnSource(5);
  except
    on E : Exception do begin
      Trace('SuperClient.TSocket.CheckForDataOnSource: ' + E.Message);
      Exit;
    end;
  end;

  FCS.Acquire;
  try
    if not FConnected then Exit;

    try
      iReadSize := FSocket.IOHandler.InputBuffer.Size;

      if iReadSize > 0 then begin
        Result := true;

        FSocket.IOHandler.ReadBytes(Buffer, iReadSize, false);

        FPacketReader.AddData(@Buffer[0], iReadSize);
      end;
    except
      on E : Exception do begin
        do_Disconnect;

        Trace('SuperClient.TSocket.CheckForDataOnSource: ' + E.Message);
      end;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TSocket.Connect;
begin
  Disconnect;

  FCS.Acquire;
  try
    try
      FSocket.Connect;
    except
      Exit;
    end;

    if FSocket.Connected then begin
      FConnected := true;
      FNeedDisconnectedEvent := true;
    end;
  finally
    FCS.Release;
  end;
end;

constructor TSocket.Create(AOwner: TComponent);
begin
  inherited;

  FConnected := false;
  FNeedDisconnectedEvent := true;

  FCS := TCriticalSection.Create;
  FPacketReader := TPacketReader.Create;

  FSocket := TIdTCPClient.Create(Self);
  FSocket.IOHandler := TIdIOHandlerStack.Create(Self);
  FSocket.IOHandler.WriteBufferOpen(2 * 1024);
  FSocket.OnDisconnected := on_SocketDisconnected;
end;

destructor TSocket.Destroy;
begin
  Disconnect;

  FreeAndNil(FCS);
  FreeAndNil(FPacketReader);
  FSocket.IOHandler.Free;
  FreeAndNil(FSocket);

  inherited;
end;

procedure TSocket.Disconnect;
begin
  FCS.Acquire;
  try
    if FConnected = false then Exit;

    FConnected := false;

    FNeedDisconnectedEvent := false;

    FPacketReader.Clear;

    try
      FSocket.Disconnect;
    except
      Trace('SuperClient.TSocket.Disconnect: FSocket.Disconnect Exception');
    end;
  finally
    FCS.Release;
  end;
end;

procedure TSocket.DisconnectForIdle;
begin
  FCS.Acquire;
  try
    do_Disconnect;
  finally
    FCS.Release;
  end;

  Trace( 'SuperClient.TRepeater.on_Repeat: FServerIsBusy > _MAX_IDLE_COUNT' );
end;

procedure TSocket.do_Disconnect;
begin
  if FConnected = false then Exit;

  FConnected := false;

  try
    FSocket.Disconnect;
  except
    Trace('SuperClient.TSocket.do_Disconnect: FSocket.Disconnect Exception');
  end;
end;

procedure TSocket.Flush;
begin
  FCS.Acquire;
  try
    try
      if FConnected then FSocket.IOHandler.WriteBufferFlush;
    except
      do_Disconnect;
    end;
  finally
    FCS.Release;
  end;
end;

function TSocket.GetHost: string;
begin
  FCS.Acquire;
  try
    Result := FSocket.Host;
  finally
    FCS.Release;
  end;
end;

function TSocket.GetPort: integer;
begin
  FCS.Acquire;
  try
    Result := FSocket.Port;
  finally
    FCS.Release;
  end;
end;

procedure TSocket.on_SocketDisconnected(Sender: TObject);
begin
  FCS.Acquire;
  try
    FConnected := false;
  finally
    FCS.Release;
  end;
end;

function TSocket.ReadPacket(var ACustomData: DWord;
  var AData: pointer; var ASize: integer): boolean;
begin
  ACustomData := 0;
  AData := nil;
  ASize := 0;

  Result := false;

  FCS.Acquire;
  try
    if FConnected = false then Exit;

    try
      Result := FPacketReader.GetPacket(ACustomData, AData, ASize);

      if ASize < 0 then
        raise Exception.Create(Format('Packet의 크기가 범위를 벗어났습니다. (Size=%d)', [ASize]));
    except
      on E : Exception do begin
        Result := false;

        if AData <> nil then begin
          FreeMem(AData);
          AData := nil;
        end;

        do_Disconnect;

        Trace('SuperClient.TSocket.ReadPacket: ' + E.Message);
      end;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TSocket.do_Send(ACustomData:DWord; AData: Pointer; ASize: integer);
var
  Buffer : TIdBytes;
  Header : TSuperSocketPacket;
begin
  if ASize < 0 then
    raise Exception.Create('SuperClient.TSocket.do_Send: 패킷 크기가 제한을 넘었습니다. (ASize < 0)');

  if ASize > PACKET_SIZE_LIMIT then
    raise Exception.Create('SuperClient.TSocket.do_Send: 패킷 크기가 제한을 넘었습니다. (ASize > PACKET_SIZE_LIMIT)');

  Header.Header.CustomData := ACustomData;
  Header.Header.Size := ASize;

  SetLength(Buffer, SizeOf(TSuperSocketPacket) + ASize);

  Move(Header, Buffer[0], SizeOf(TSuperSocketPacket));

  if ASize > 0 then Move(AData^, Buffer[SizeOf(TSuperSocketPacket)], ASize);

  FSocket.IOHandler.Write(Buffer, SizeOf(TSuperSocketPacket) + ASize);
end;

procedure TSocket.Send(ACustomData:DWord; AData: Pointer; ASize: integer);
begin
  FCS.Acquire;
  try
    if not FConnected then Exit;

    try
      do_Send(ACustomData, AData, ASize);
    except
      on E : Exception do begin
        do_Disconnect;

        Trace('SuperClient.TSocket.Send: ' + E.Message);
      end;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TSocket.SendNow(ACustomData:DWord; AData: Pointer; ASize: integer);
begin
  FCS.Acquire;
  try
    if not FConnected then Exit;

    try
      do_Send(ACustomData, AData, ASize);
      FSocket.IOHandler.WriteBufferFlush;
    except
      on E : Exception do begin
        do_Disconnect;

        Trace('SuperClient.TSocket.SendNow: ' + E.Message);
      end;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TSocket.SetHost(const Value: string);
begin
  FCS.Acquire;
  try
    FSocket.Host := Value;
  finally
    FCS.Release;
  end;
end;

procedure TSocket.SetPort(const Value: integer);
begin
  FCS.Acquire;
  try
    FSocket.Port := Value;
  finally
    FCS.Release;
  end;
end;

end.
