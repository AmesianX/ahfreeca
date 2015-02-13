unit ServerUnit.VoiceServer;

interface

uses
  DebugTools, Config, Protocol, ProtocolVoice,
  MemoryPool, SuperServer, Connection,
  Windows, SysUtils, Classes, TypInfo;

type
  TVoiceServer = class
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

{ TVoiceServer }

constructor TVoiceServer.Create(AMemoryPool:TMemoryPool);
begin
  inherited Create;

  FMemoryPool := AMemoryPool;

  FSocket := TSuperServer.Create(nil, FMemoryPool);
  FSocket.UseNagel := false;
  FSocket.Port := VOICE_SERVER_PORT;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnReceived := on_FSocket_Received;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
end;

destructor TVoiceServer.Destroy;
begin
  Stop;

  FreeAndNil(FSocket);

  inherited;
end;

procedure TVoiceServer.on_FSocket_Connected(AConnection: TConnection);
begin
  // TODO: Text 로그인 시 RandomPW 발생하여 처리
  AConnection.IsLogined := true;
end;

procedure TVoiceServer.on_FSocket_Disconnected(AConnection: TConnection);
begin

end;

procedure TVoiceServer.on_FSocket_Received(AConnection: TConnection;
  ACustomData: DWord; AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader absolute ACustomData;
begin
  {$IFDEF DEBUG}
  Trace( Format('TVoiceServer.on_FSocket_Received - PacketType: %s', [GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType)]) );
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
       Trace( 'TVoiceServer.on_FSocket_Received: ' + E.Message );
       Trace( '  * PacketType: ' + GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType) );

       AConnection.Disconnect;
     end;
  end;
end;

procedure TVoiceServer.Start;
begin
  FSocket.Start;
end;

procedure TVoiceServer.Stop;
begin
  FSocket.Stop;
end;

end.
