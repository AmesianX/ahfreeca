unit SuperClient;

interface

uses
  SuperClient.Repeater,
  DebugTools, SuperSocketUtils, Strg,
  Windows, Classes, SysUtils, SyncObjs;

type
  TSuperClient = class (TComponent, ISuperSocketClient)
  private
    FCS : TCriticalSection;
  private
    FRepeater : TRepeater;
    procedure on_Connected(Sender:TObject);
    procedure on_Disconnected(Sender:TObject);
    procedure on_Received(Sender:TObject; ACustomData:DWord; AData:pointer; ASize:integer);
  private
    FPort: integer;
    FHost: string;
    FOnConnected: TNotifyEvent;
    FOnDisconnected: TNotifyEvent;
    FOnReceived: TReceivedEvent;
    function GetConnected: boolean;
    function GetServerIsBusy: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;

    procedure Send(ACustomData:DWord; AData:Pointer; ASize:integer); overload;
    procedure Send(ACustomData:DWord; AText:string); overload;

    procedure SendNow(ACustomData:DWord; AData:Pointer; ASize:integer); overload;
    procedure SendNow(ACustomData:DWord; AText:string); overload;

    procedure Flush;
  published
    property Connected : boolean read GetConnected;
    property Host : string read FHost write FHost;
    property Port : integer read FPort write FPort;
    property ServerIsBusy : boolean read GetServerIsBusy;
    property OnConnected : TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisconnected : TNotifyEvent read FOnDisconnected write FOnDisconnected;
    property OnReceived : TReceivedEvent read FOnReceived write FOnReceived;
  end;

implementation

{ TSuperClient }

procedure TSuperClient.Connect;
begin
  FCS.Acquire;
  try
    if FRepeater <> nil then begin
      FRepeater.Disconnect;
      FRepeater := nil;
    end;

    FRepeater := TRepeater.Create( FHost, FPort );

    FRepeater.OnConnected := on_Connected;
    FRepeater.OnDisconnected := on_Disconnected;
    FRepeater.OnReceived := on_Received;

    FRepeater.Connect;
  finally
    FCS.Release;
  end;
end;

constructor TSuperClient.Create(AOwner: TComponent);
begin
  inherited;

  FRepeater := nil;

  FCS := TCriticalSection.Create;
end;

destructor TSuperClient.Destroy;
begin
  Disconnect;

  FreeAndNil(FCS);

  inherited;
end;

procedure TSuperClient.Disconnect;
begin
  FCS.Acquire;
  try
    if FRepeater <> nil then begin
      FRepeater.Disconnect;
      FRepeater := nil;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TSuperClient.Flush;
begin
  FCS.Acquire;
  try
    if FRepeater <> nil then FRepeater.Flush;
  finally
    FCS.Release;
  end;
end;

function TSuperClient.GetConnected: boolean;
begin
  FCS.Acquire;
  try
    if FRepeater <> nil then Result := FRepeater.Connected
    else Result := false;
  finally
    FCS.Release;
  end;
end;

function TSuperClient.GetServerIsBusy: boolean;
begin
  FCS.Acquire;
  try
    if FRepeater <> nil then Result := FRepeater.ServerIsBusy
    else Result := false;
  finally
    FCS.Release;
  end;
end;

procedure TSuperClient.on_Connected(Sender: TObject);
begin
  if (FRepeater = Sender) and Assigned(FOnConnected) then FOnConnected(Self);
end;

procedure TSuperClient.on_Disconnected(Sender: TObject);
begin
  if (FRepeater = Sender) and Assigned(FOnDisconnected) then FOnDisconnected(Self);
end;

procedure TSuperClient.on_Received(Sender: TObject; ACustomData: DWord;
  AData: pointer; ASize: integer);
begin
  if (FRepeater = Sender) and Assigned(FOnReceived) then FOnReceived(Self, ACustomData, AData, ASize);
end;

procedure TSuperClient.Send(ACustomData: DWord; AData: Pointer;
  ASize: integer);
begin
  FCS.Acquire;
  try
    if FRepeater <> nil then FRepeater.Send(ACustomData, AData, ASize);
  finally
    FCS.Release;
  end;
end;

procedure TSuperClient.SendNow(ACustomData: DWord; AData: Pointer;
  ASize: integer);
begin
  FCS.Acquire;
  try
    if FRepeater <> nil then FRepeater.SendNow(ACustomData, AData, ASize);
  finally
    FCS.Release;
  end;
end;

procedure TSuperClient.Send(ACustomData: DWord; AText: string);
var
  Data : pointer;
  Size : integer;
begin
  TextToData( AText, Data, Size);
  try
    Send( ACustomData, Data, Size );
  finally
    if Data <> nil then FreeMem(Data);
  end;
end;

procedure TSuperClient.SendNow(ACustomData: DWord; AText: string);
var
  Data : pointer;
  Size : integer;
begin
  TextToData( AText, Data, Size);
  try
    SendNow( ACustomData, Data, Size );
  finally
    if Data <> nil then FreeMem(Data);
  end;
end;

end.
