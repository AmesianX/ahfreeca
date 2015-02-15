unit SuperClient.Repeater;

interface

uses
  SuperClient.Socket, LazyRelease,
  DebugTools, SuperSocketUtils, SimpleThread, TickCounter,
  Windows, Classes, SysUtils;

type
  TRepeater = class
  private
    FLazyDestroy : TLazyDestroy;
    FServerIsBusy : integer;
    FCounterPing : TTickCounter;
    procedure do_Ping;
    procedure do_ReadPacket;
    procedure release_Objects;
  private
    FSocket : TSocket;
  private
    FSimpleThread : TSimpleThread;
    procedure on_Repeat(Sender:TObject);
  private
    FOnConnected: TNotifyEvent;
    FOnDisconnected: TNotifyEvent;
    FOnReceived: TReceivedEvent;
    function GetConnected: boolean;
    function GetHost: string;
    function GetPort: integer;
    procedure SetHost(const Value: string);
    procedure SetPort(const Value: integer);
    function GetServerIsBusy: boolean;
  public
    constructor Create(AHost:string; APort:integer); reintroduce;

    procedure Connect;
    procedure Disconnect;

    procedure Send(ACustomData:DWord; AData:Pointer; ASize:integer);
    procedure SendNow(ACustomData:DWord; AData:Pointer; ASize:integer);

    procedure Flush;
  public
    property Connected : boolean read GetConnected;
    property Host : string read GetHost write SetHost;
    property Port : integer read GetPort write SetPort;
    property ServerIsBusy : boolean read GetServerIsBusy;
  public
    property OnConnected : TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisconnected : TNotifyEvent read FOnDisconnected write FOnDisconnected;
    property OnReceived : TReceivedEvent read FOnReceived write FOnReceived;
  end;

implementation

{ TRepeater }

procedure TRepeater.Connect;
begin
  FSocket.Connect;

  if FSocket.Connected then begin
    if Assigned(FOnConnected) then FOnConnected(Self);
    FSimpleThread.WakeUp;
  end;
end;

constructor TRepeater.Create(AHost:string; APort:integer);
begin
  inherited Create;

  FServerIsBusy := 0;

  FLazyDestroy := TLazyDestroy.Create(16);
  FCounterPing := TTickCounter.Create;

  FSocket := TSocket.Create(nil);
  FSocket.Host := AHost;
  FSocket.Port := APort;

  FSimpleThread := TSimpleThread.Create(on_Repeat);
  FSimpleThread.Name := 'SuperClient.TRepeater';

  SetThreadPriority(FSimpleThread.Handle, THREAD_PRIORITY_HIGHEST);
end;

procedure TRepeater.Disconnect;
begin
  FSocket.Disconnect;

  FSimpleThread.Terminate;
  FSimpleThread.WakeUp;
end;

procedure TRepeater.do_Ping;
begin
  if FCounterPing.GetDuration >= CLIENT_PING_INTERVAL then begin
    FCounterPing.Start;

    Inc( FServerIsBusy );

    if FServerIsBusy > _MAX_IDLE_COUNT then begin
      FSocket.DisconnectForIdle;
    end else begin
      FSocket.SendNow(0, nil, 0);
    end;

    {$IFDEF DEBUG}
    if ServerIsBusy then
      Trace( Format('SuperClient.TRepeater.on_Repeat: FServerIsBusy=%d', [FServerIsBusy]) );
    {$ENDIF}
  end;
end;

procedure TRepeater.do_ReadPacket;
var
  CustomData : DWord;
  Data : Pointer;
  Size : integer;
begin
  if not FSocket.CheckForDataOnSource then Exit;

  while FSocket.ReadPacket(CustomData, Data, Size) do begin
    try
      if Size = 0 then begin
        FServerIsBusy := 0;
      end else begin
        if Assigned(FOnReceived) then FOnReceived(Self, CustomData, Data, Size);
      end;
    finally
      if Data <> nil then FreeMem(Data);
    end;
  end;
end;

procedure TRepeater.Flush;
begin
  FSocket.Flush;
end;

function TRepeater.GetConnected: boolean;
begin
  Result := FSocket.Connected;
end;

function TRepeater.GetHost: string;
begin
  Result := FSocket.Host;
end;

function TRepeater.GetPort: integer;
begin
  Result := FSocket.Port;
end;

function TRepeater.GetServerIsBusy: boolean;
begin
  Result := FServerIsBusy >= SERVER_IS_BUSY_LIMIT;
end;

procedure TRepeater.on_Repeat(Sender: TObject);
var
  SimpleThread : TSimpleThread absolute Sender;
begin
  SimpleThread.SleepTight;

  while (not SimpleThread.Terminated) and FSocket.Connected do begin
    try
      do_Ping;
      do_ReadPacket;
    except
      on E : Exception do begin
        Trace('SuperClient.TRepeater.on_Repeat: ' + E.Message);
        SimpleThread.Terminate;
        Break;
      end;
    end;
  end;

  if FSocket.NeedDisconnectedEvent and Assigned(FOnDisconnected) then FOnDisconnected(Self);

  release_Objects;
end;

procedure TRepeater.release_Objects;
begin
  FLazyDestroy.Release(FCounterPing);
  FLazyDestroy.Release(FSocket);
  FLazyDestroy.Release(Self);
end;

procedure TRepeater.Send(ACustomData: DWord; AData: Pointer; ASize: integer);
begin
  FSocket.Send(ACustomData, AData, ASize);
end;

procedure TRepeater.SendNow(ACustomData: DWord; AData: Pointer; ASize: integer);
begin
  FSocket.SendNow(ACustomData, AData, ASize);
end;

procedure TRepeater.SetHost(const Value: string);
begin
  FSocket.Host := Value;
end;

procedure TRepeater.SetPort(const Value: integer);
begin
  FSocket.Port := Value;
end;

end.
