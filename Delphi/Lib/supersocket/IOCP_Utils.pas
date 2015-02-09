unit IOCP_Utils;

interface

uses
  DebugTools, LazyRelease, SimpleThread, SyncValues,
  Windows, SysUtils, Classes, WinSock2;

const
  /// 동시성의 문제로 바로 삭제하지 않고, 삭제 큐에 집어 넣는다.  해당 큐의 크기.
  IO_DATA_RING_FENDER_SIZE = $FFF;

type
  TIODataStatus = (iosStart, iosAccepted, iosSend, iosRecv, iosDisconnect, iosStop, iosTerminate);

  PIOData = ^TIOData;
  TIOData = record
    Overlapped : OVERLAPPED;
    wsaBuffer : TWSABUF;
    Status: TIODataStatus;
    Socket : integer;
    RemoteIP : string;
    Connection : TObject;
  end;

  TIODataPool = class
  private
    FLazyRelease : TLazyRelease;
  public
    constructor Create;
    destructor Destroy; override;

    function Get:PIOData;
    procedure Release(AIOData:PIOData);
  end;

  TIOCP_Event = procedure (Sender:TObject; ATransferred:DWord; AIOData:PIOData) of object;

  TIOCP_Handle = class (TComponent)
  private
    FCompletionPort : THandle;
    FIODataPool : TIODataPool;
    procedure do_Terminate;
  private
    FSimpleThread : TSimpleThread;
    procedure on_Repeat(Sender:TObject);
  private
    procedure do_Start(ATransferred:DWord; AIOData:PIOData);
  private
    FActive : TSyncBoolean;
    FOnAccepted: TIOCP_Event;
    FOnDisconnected: TIOCP_Event;
    FOnReceived: TIOCP_Event;
    FOnStart: TIOCP_Event;
    FOnStop: TIOCP_Event;
    FOnSended: TIOCP_Event;
    function GetActive: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    function AddSocket(ASocket:integer; Akey:DWORD):boolean;

    procedure Accepted(ASocket:integer; const ARemoteIP:string);
    procedure Send(AConnection:TObject; ASocket:integer; ABuffer:pointer; ABufferSize:integer);
    procedure Receive(AConnection:TObject; ASocket:integer; ABuffer:pointer; ABufferSize:integer);
    procedure Disconnect(AConnection:TObject);
  published
    property Active : boolean read GetActive;
    property OnStart : TIOCP_Event read FOnStart write FOnStart;
    property OnStop : TIOCP_Event read FOnStop write FOnStop;
    property OnAccepted : TIOCP_Event read FOnAccepted write FOnAccepted;
    property OnSended : TIOCP_Event read FOnSended write FOnSended;
    property OnReceived : TIOCP_Event read FOnReceived write FOnReceived;
    property OnDisconnected : TIOCP_Event read FOnDisconnected write FOnDisconnected;
  end;

implementation

{ TIODataPool }

constructor TIODataPool.Create;
begin
  inherited;

  FLazyRelease := TLazyRelease.Create(IO_DATA_RING_FENDER_SIZE);
end;

destructor TIODataPool.Destroy;
begin
  FreeAndNil(FLazyRelease);

  inherited;
end;

function TIODataPool.Get: PIOData;
begin
  New(Result);
  FillChar(Result^.Overlapped, SizeOf(Overlapped), 0);
end;

procedure TIODataPool.Release(AIOData: PIOData);
begin
  FLazyRelease.Release(AIOData);
end;

{ TIOCP_Handle }

procedure TIOCP_Handle.Accepted(ASocket: integer; const ARemoteIP: string);
var
  pData : PIOData;
begin
  pData := FIODataPool.Get;
  pData^.Socket := ASocket;
  pData^.RemoteIP := ARemoteIP;
  pData^.Status := iosAccepted;

  if not PostQueuedCompletionStatus( FCompletionPort, SizeOf(pData), 0, POverlapped(pData) ) then begin
    Trace( 'TIOCP_Handle.Accepted - PostQueuedCompletionStatus Error' );

    closesocket(ASocket);

    FIODataPool.Release( pData );
  end;
end;

function TIOCP_Handle.AddSocket(ASocket: integer; Akey: DWORD): boolean;
begin
  Result := CreateIoCompletionPort(ASocket, FCompletionPort, Akey, 0) <> 0;
end;

constructor TIOCP_Handle.Create(AOwner: TComponent);
begin
  inherited;

  FActive := TSyncBoolean.Create;
  FActive.SetValue( False );

  FCompletionPort := CreateIoCompletionPort(INVALID_HANDLE_VALUE, 0, 0, 0);
  FIODataPool := TIODataPool.Create;

  FSimpleThread := TSimpleThread.Create( on_Repeat );
end;

destructor TIOCP_Handle.Destroy;
begin
  Stop;

  do_Terminate;

  inherited;
end;

procedure TIOCP_Handle.Disconnect(AConnection: TObject);
var
  pData : PIOData;
begin
  pData := FIODataPool.Get;
  pData^.Status := iosDisconnect;
  pData^.Connection := AConnection;

  if not PostQueuedCompletionStatus( FCompletionPort, SizeOf(pData), 0, POverlapped(pData) ) then begin
    Trace( 'TIOCP_Handle.Disconnect - PostQueuedCompletionStatus Error' );

    FIODataPool.Release( pData );
  end;
end;

procedure TIOCP_Handle.do_Start(ATransferred: DWord; AIOData: PIOData);
begin
  try
    if Assigned(FOnStart) then FOnStart( Self, ATransferred, AIOData );
  except
    FActive.SetValue( false );
    raise;
  end;
end;

procedure TIOCP_Handle.do_Terminate;
var
  pData : PIOData;
begin
  pData := FIODataPool.Get;
  pData^.Status := iosTerminate;

  if not PostQueuedCompletionStatus( FCompletionPort, SizeOf(pData), 0, POverlapped(pData) ) then begin
    Trace( 'TIOCP_Handle.do_Terminate - PostQueuedCompletionStatus Error' );

    FIODataPool.Release( pData );
  end;
end;

function TIOCP_Handle.GetActive: boolean;
begin
  Result := FActive.Value;
end;

procedure TIOCP_Handle.on_Repeat(Sender: TObject);
var
  pData : PIOData;
  Transferred : DWord;
  Key : NativeUInt;
  isGetOk, isCondition : boolean;
  SimpleThread : TSimpleThread absolute Sender;
  {$IFDEF DEBUG} LastError : integer; {$ENDIF}
begin
  while not SimpleThread.Terminated do begin
    isGetOk := GetQueuedCompletionStatus( FCompletionPort, Transferred, Key, POverlapped(pData), INFINITE );

    isCondition :=
      (pData <> nil) and ((Transferred = 0) or (not isGetOk));
    if isCondition then begin
      {$IFDEF DEBUG}
      if not isGetOk then begin
        LastError := WSAGetLastError;
        Trace(Format('TIOCP_Handle.on_Repeat: %s', [SysErrorMessage(LastError)]));
      end;
      {$ENDIF}

      FIODataPool.Release( pData );
      Disconnect( pData^.Connection );

      Continue;
    end;

    if pData = nil then Continue;

    if pData^.Status = iosTerminate then begin
      FIODataPool.Release(pData);
      Break;
    end;

    FActive.Lock;
    try
      if not FActive.Value then begin
        FIODataPool.Release(pData);
        Continue;
      end;
    finally
      FActive.Unlock;
    end;

    case pData^.Status of
      iosStart: do_Start( Transferred, pData );
      iosAccepted: if Assigned(FOnAccepted) then FOnAccepted( Self, Transferred, pData );
      iosSend: if Assigned(FOnSended) then FOnSended( Self, Transferred, pData );
      iosRecv: if Assigned(FOnReceived) then FOnReceived( Self, Transferred, pData );
      iosDisconnect: if Assigned(FOnDisconnected) then FOnDisconnected( Self, Transferred, pData );

      iosStop: begin
        if Assigned(FOnStop) then FOnStop( Self, Transferred, pData );
        FActive.SetValue( false );
      end;
    end;

    FIODataPool.Release(pData);
  end;

//  CloseHandle(FCompletionPort);
//
//  FreeAndNil(FActive);
//  FreeAndNil(FIODataPool);
end;

procedure TIOCP_Handle.Receive(AConnection:TObject; ASocket:integer; ABuffer:pointer; ABufferSize:integer);
var
  pData : PIOData;
  byteRecv, dwFlags: DWord;
  recv_ret, LastError: Integer;
begin
  pData := FIODataPool.Get;
  pData^.Connection := AConnection;
  pData^.Status := iosRecv;
  PData^.wsaBuffer.buf := ABuffer;
  pData^.wsaBuffer.len := ABufferSize;

  dwFlags := 0;
  recv_ret := WSARecv(ASocket, LPWSABUF(@pData^.wsaBuffer), 1, byteRecv, dwFlags, LPWSAOVERLAPPED(pData), nil);

  if recv_ret = SOCKET_ERROR then begin
    LastError := WSAGetLastError;
    if LastError <> ERROR_IO_PENDING then begin
      FIODataPool.Release(pData);
      Disconnect(AConnection);
      Trace( 'TIOCP_Handle.Receive - PostQueuedCompletionStatus Error' );
    end;
  end;
end;

procedure TIOCP_Handle.Send(AConnection: TObject; ASocket: integer;
  ABuffer: pointer; ABufferSize: integer);
var
  pData : PIOData;
  BytesSent, Flags: DWORD;
  ErrorCode, LastError : integer;
begin
  pData := FIODataPool.Get;
  pData^.Connection := AConnection;
  pData^.Status := iosSend;
  PData^.wsaBuffer.buf := ABuffer;
  pData^.wsaBuffer.len := ABufferSize;

  Flags := 0;
  ErrorCode := WSASend(ASocket, @(PData^.wsaBuffer), 1, BytesSent, Flags, Pointer(pData), nil);

  if ErrorCode = SOCKET_ERROR then begin
    LastError := WSAGetLastError;
    if LastError <> ERROR_IO_PENDING then begin
      FIODataPool.Release(pData);
      Disconnect(AConnection);
      Trace(Format('TIOCP_Handle.Send: %s', [SysErrorMessage(LastError)]));
    end;
  end;
end;

procedure TIOCP_Handle.Start;
var
  pData : PIOData;
begin
  FActive.Lock;
  try
    if FActive.Value then
      raise Exception.Create('TIOCP_Handle.Start - FActive = true');

    FActive.Value := true;
  finally
    FActive.Unlock;
  end;

  pData := FIODataPool.Get;
  pData^.Status := iosStart;

  if not PostQueuedCompletionStatus( FCompletionPort, SizeOf(pData), 0, POverlapped(pData) ) then begin
    Trace( 'TIOCP_Handle.Start - PostQueuedCompletionStatus Error' );

    FIODataPool.Release( pData );
  end;
end;

procedure TIOCP_Handle.Stop;
var
  pData : PIOData;
begin
  FActive.Lock;
  try
    if not FActive.Value then Exit;
  finally
    FActive.Unlock;
  end;

  pData := FIODataPool.Get;
  pData^.Status := iosStop;

  if not PostQueuedCompletionStatus( FCompletionPort, SizeOf(pData), 0, POverlapped(pData) ) then begin
    Trace( 'TIOCP_Handle.Stop - PostQueuedCompletionStatus Error' );

    FIODataPool.Release( pData );

    FActive.Lock;
    try
      FActive.Value := false;
    finally
      FActive.Unlock;
    end;
  end;
end;

end.
