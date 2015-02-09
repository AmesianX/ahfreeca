unit _fmMain;

interface

uses
  Config, MemoryPool, SuperServer, Connection, Protocol,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMemoryPool : TMemoryPool;
  private
    FSocket : TSuperServer;
    procedure on_FSocket_Connected(AConnection:TConnection);
    procedure on_FSocket_Received(AConnection:TConnection; ACustomData:DWord; AData:pointer; ASize:integer);
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FSocket.Stop;
end;

procedure TfmMain.FormCreate(Sender: TObject);
const
  MEMORY_POOL_SIZE = 256 * 1024 * 1024;
begin
  {$IFDEF WIN64}
  FMemoryPool := TMemoryPool64.Create(MEMORY_POOL_SIZE);
  {$ELSE}
  FMemoryPool := TMemoryPool32.Create(MEMORY_POOL_SIZE);
  {$ENDIF}

  FSocket := TSuperServer.Create(Self, FMemoryPool, 0);
  FSocket.UseNagel := false;
  FSocket.Port := ECHO_SERVER_PORT;
  FSocket.OnConnected := on_FSocket_Connected;
  FSocket.OnReceived := on_FSocket_Received;

  FSocket.Start;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FMemoryPool);
  FreeAndNil(FSocket);
end;

procedure TfmMain.on_FSocket_Connected(AConnection: TConnection);
begin
  AConnection.IsLogined := true;
end;

procedure TfmMain.on_FSocket_Received(AConnection: TConnection;
  ACustomData: DWord; AData: pointer; ASize: integer);
begin
  FSocket.SendToOther( AConnection, ACustomData, AData, ASize );
end;

end.
