unit ServerUnit.VideoServer;

interface

uses
  DebugTools, Config, Protocol, ProtocolVideo,
  MemoryPool, SuperServer, Connection,
  Windows, SysUtils, Classes, TypInfo;

type
  TVideoServer = class
  private
    FMemoryPool : TMemoryPool;
  private
    FSocket : TSuperServer;
    procedure on_FSocket_Connected(AConnection:TConnection);
    procedure on_FSocket_Received(AConnection:TConnection; ACustomData:DWord; AData:pointer; ASize:integer);
    procedure on_FSocket_Disconnected(AConnection:TConnection);
  public
    constructor Create(AMemoryPool:TMemoryPool); reintroduce;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TVideoServer }

constructor TVideoServer.Create(AMemoryPool:TMemoryPool);
begin
  inherited Create;

  FMemoryPool := AMemoryPool;

  FSocket := TSuperServer.Create(nil, FMemoryPool);
  FSocket.UseNagel := false;
  FSocket.Port := VIDEO_SERVER_PORT;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnReceived := on_FSocket_Received;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
end;

destructor TVideoServer.Destroy;
begin
  Stop;

  FreeAndNil(FSocket);

  inherited;
end;

procedure TVideoServer.on_FSocket_Connected(AConnection: TConnection);
begin
  // TODO: Text 로그인 시 RandomPW 발생하여 처리
  AConnection.IsLogined := true;
end;

procedure TVideoServer.on_FSocket_Disconnected(AConnection: TConnection);
begin

end;

procedure TVideoServer.on_FSocket_Received(AConnection: TConnection;
  ACustomData: DWord; AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader absolute ACustomData;
begin
  {$IFDEF DEBUG}
  Trace( Format('TVideoServer.on_FSocket_Received - PacketType: %s', [GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType)]) );
  {$ENDIF}

  try
    case CustomHeader.Direction of
      pdSendToAll: FSocket.SendToAll( ACustomData, AData, ASize );
      pdSendToOther: FSocket.SendToOther( AConnection, ACustomData, AData, ASize );
      pdSentToID: FSocket.SendToConnectionID( CustomHeader.ID, ACustomData, AData, ASize );
    end;

//    case TPacketType(CustomHeader.PacketType) of
//    end;
  except
     on E : Exception do begin
       Trace( 'TVideoServer.on_FSocket_Received: ' + E.Message );
       Trace( '  * PacketType: ' + GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType) );

       AConnection.Disconnect;
     end;
  end;
end;

procedure TVideoServer.Start;
begin
  FSocket.Start;
end;

procedure TVideoServer.Stop;
begin
  FSocket.Stop;
end;

end.
