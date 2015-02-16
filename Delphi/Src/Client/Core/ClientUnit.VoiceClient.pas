unit ClientUnit.VoiceClient;

interface

uses
  CoreInterface,
  Config, Protocol, ProtocolVoice,
  DebugTools, RyuLibBase, SuperClient,
  Windows, SysUtils, Classes, TypInfo;

type
  TVoiceClient = class (TInterfaceBase, IVoiceClient)
  private // implementation of IVoiceClient
    procedure SendVoice(AData:pointer; ASize:integer);
  private
    FSocket : TSuperClient;
    procedure on_FSocket_Connected(Sender:TObject);
    procedure on_FSocket_Received(Sender:TObject; ACustomData:DWord; AData:pointer; ASize:integer);
    procedure on_FSocket_Disconnected(Sender:TObject);
  private
    procedure rp_Speex(ACustomHeader:TCustomHeader; AData:pointer; ASize:integer);
  public
    constructor Create;
    destructor Destroy; override;

    function Connect:boolean;
    procedure Disconnect;
  end;

implementation

uses
  VoiceReceiver;

{ TVoiceClient }

function TVoiceClient.Connect: boolean;
begin
  FSocket.Connect;
  Result := FSocket.Connected;
end;

constructor TVoiceClient.Create;
begin
  inherited;

  FSocket := TSuperClient.Create(nil);
  FSocket.Host := SERVER_HOST;
  FSocket.Port := VOICE_SERVER_PORT;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnReceived := on_FSocket_Received;
  FSocket.OnDisconnected := on_FSocket_Disconnected;
end;

destructor TVoiceClient.Destroy;
begin
  Disconnect;

  FreeAndNil(FSocket);

  inherited;
end;

procedure TVoiceClient.Disconnect;
begin
  FSocket.Disconnect;
end;

procedure TVoiceClient.on_FSocket_Connected(Sender: TObject);
begin

end;

procedure TVoiceClient.on_FSocket_Disconnected(Sender: TObject);
begin
  // TODO: 접속 종료 처리 (에러 처리, 프로그램 종료)
end;

procedure TVoiceClient.on_FSocket_Received(Sender: TObject; ACustomData: DWord;
  AData: pointer; ASize: integer);
var
  sPacketType : string;
  CustomHeader : TCustomHeader absolute ACustomData;
begin
  sPacketType := GetEnumName(TypeInfo(TPacketType), CustomHeader.PacketType);

  {$IFDEF DEBUG}
  Trace( Format('TVoiceClient.on_FSocket_Received - PacketType: %s', [sPacketType]) );
  {$ENDIF}

  case TPacketType(CustomHeader.PacketType) of
    ptSpeex: rp_Speex( CustomHeader, AData, ASize );
  end;
end;

procedure TVoiceClient.rp_Speex(ACustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin
  TVoiceReceiver.Obj.DataIn( AData, ASize );
end;

procedure TVoiceClient.SendVoice(AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.Init;
  CustomHeader.Direction := pdSendToOther;
  CustomHeader.PacketType := Byte( ptSpeex );

  FSocket.SendNow( CustomHeader.ToDWord, AData, ASize );
end;

end.
