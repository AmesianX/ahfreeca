unit ClientSocket;

interface

uses
  Config, Protocol, SuperClient, Strg,
  Windows, SysUtils, Classes, SyncObjs;

type
  TClientSocket = class
  private
    FCS : TCriticalSection;
  private
    FRyuSocketClient : TSuperClient;
    procedure on_FRyuSocketClient_Connected(Sender:TObject);
    procedure on_FRyuSocketClient_Received(Sender:TObject; ACustomData:DWord; AData:pointer; ASize:integer);
    procedure on_FRyuSocketClient_Disconnected(Sender:TObject);
  private
    procedure do_Text(CustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure do_Voice(CustomHeader:TCustomHeader; AData:pointer; ASize:integer);
    procedure do_Video(CustomHeader:TCustomHeader; AData:pointer; ASize:integer);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TClientSocket;

    function Connect:boolean;
    procedure Disconnect;

    procedure SendChat(AText:string);
    procedure SendVoice(AData:pointer; ASize:integer);
    procedure SendVideo(AData:pointer; ASize:integer);
  end;

implementation

uses
  Core;

{ TClientSocket }

var
  MyObject : TClientSocket = nil;

class function TClientSocket.Obj: TClientSocket;
begin
  if MyObject = nil then MyObject := TClientSocket.Create;
  Result := MyObject;
end;

procedure TClientSocket.on_FRyuSocketClient_Connected(Sender: TObject);
begin

end;

procedure TClientSocket.on_FRyuSocketClient_Disconnected(Sender: TObject);
begin

end;

procedure TClientSocket.on_FRyuSocketClient_Received(Sender: TObject;
  ACustomData: DWord; AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.FromDWord( ACustomData );

  case CustomHeader.ProtocolLayer of
    plText: do_Text( CustomHeader, AData, ASize );
    plVoice: do_Voice( CustomHeader, AData, ASize );
    plVideo: do_Video( CustomHeader, AData, ASize );
  end;
end;

procedure TClientSocket.SendChat(AText: string);
var
  CustomHeader : TCustomHeader;
  Data : pointer;
  Size : integer;
begin
  CustomHeader.ProtocolLayer := plText;

  TextToData( AText, Data, Size );

  FCS.Acquire;
  try
    FRyuSocketClient.Send( CustomHeader.ToDWord, Data, Size );
  finally
    FCS.Release;
  end;
end;

procedure TClientSocket.SendVideo(AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.ProtocolLayer := plVideo;

  FCS.Acquire;
  try
    FRyuSocketClient.Send( CustomHeader.ToDWord, AData, ASize );
  finally
    FCS.Release;
  end;
end;

procedure TClientSocket.SendVoice(AData: pointer; ASize: integer);
var
  CustomHeader : TCustomHeader;
begin
  CustomHeader.ProtocolLayer := plVoice;

  FCS.Acquire;
  try
    FRyuSocketClient.Send( CustomHeader.ToDWord, AData, ASize );
  finally
    FCS.Release;
  end;
end;

function TClientSocket.Connect: boolean;
begin
  FCS.Acquire;
  try
    FRyuSocketClient.Connect;
  finally
    FCS.Release;
  end;

  Result := FRyuSocketClient.Connected;
end;

constructor TClientSocket.Create;
begin
  inherited;

  FCS := TCriticalSection.Create;

  FRyuSocketClient := TSuperClient.Create(nil);
  FRyuSocketClient.Host := SERVER_HOST;
  FRyuSocketClient.Port := ECHO_SERVER_PORT;
  FRyuSocketClient.OnConnected := on_FRyuSocketClient_Connected;
  FRyuSocketClient.OnReceived := on_FRyuSocketClient_Received;
  FRyuSocketClient.OnDisconnected := on_FRyuSocketClient_Disconnected;
end;

destructor TClientSocket.Destroy;
begin
  Disconnect;

  FreeAndNil(FCS);
  FreeAndNil(FRyuSocketClient);

  inherited;
end;

procedure TClientSocket.Disconnect;
begin
  FCS.Acquire;
  try
    FRyuSocketClient.Disconnect;
  finally
    FCS.Release;
  end;
end;

procedure TClientSocket.do_Text(CustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
var
  sMsg : string;
begin
  sMsg := DataToText( AData, ASize );
  TCore.Obj.View.sp_Chat( sMsg );
end;

procedure TClientSocket.do_Video(CustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin

end;

procedure TClientSocket.do_Voice(CustomHeader: TCustomHeader; AData: pointer;
  ASize: integer);
begin

end;

initialization
  MyObject := TClientSocket.Create;
end.