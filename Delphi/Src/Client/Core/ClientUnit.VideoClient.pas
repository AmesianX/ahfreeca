unit ClientUnit.VideoClient;

interface

uses
  CoreInterface,
  Config, Protocol, ProtocolVideo,
  DebugTools, RyuLibBase, SuperClient,
  Windows, SysUtils, Classes, TypInfo;

type
  TVideoClient = class (TInterfaceBase, IVideoClient)
  private
  private
    FSocket : TSuperClient;
    procedure on_FSocket_Connected(Sender:TObject);
    procedure on_FSocket_Received(Sender:TObject; ACustomData:DWord; AData:pointer; ASize:integer);
    procedure on_FSocket_Disconnected(Sender:TObject);
  public
    constructor Create;
    destructor Destroy; override;

    function Connect:boolean;
    procedure Disconnect;

    procedure SendVideo(AData:pointer; ASize:integer);
  end;

implementation

{ TVideoClient }

function TVideoClient.Connect: boolean;
begin
  FSocket.Connect;
  Result := FSocket.Connected;
end;

constructor TVideoClient.Create;
begin
  inherited;

  FSocket := TSuperClient.Create(nil);
  FSocket.Host := SERVER_HOST;
  FSocket.Port := VIDEO_SERVER_PORT;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnReceived := on_FSocket_Received;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
end;

destructor TVideoClient.Destroy;
begin
  Disconnect;

  FreeAndNil(FSocket);

  inherited;
end;

procedure TVideoClient.Disconnect;
begin
  FSocket.Disconnect;
end;

procedure TVideoClient.on_FSocket_Connected(Sender: TObject);
begin

end;

procedure TVideoClient.on_FSocket_Disconnected(Sender: TObject);
begin
  // TODO: 접속 종료 처리 (에러 처리, 프로그램 종료)
end;

procedure TVideoClient.on_FSocket_Received(Sender: TObject; ACustomData: DWord;
  AData: pointer; ASize: integer);
var
  sPacketType : string;
  CustomHeader : TCustomHeader absolute ACustomData;
begin
  sPacketType := GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType);

  {$IFDEF DEBUG}
  Trace( Format('TVideoClient.on_FSocket_Received - PacketType: %s', [sPacketType]) );
  {$ENDIF}

//  case TPacketType(CustomHeader.PacketType) of
//  end;
end;

procedure TVideoClient.SendVideo(AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.Direction := pdSendToOther;
  CustomHeader.PacketType := Byte( ptVPX );

  FSocket.SendNow( CustomHeader.ToDWord, AData, ASize );
end;

end.
