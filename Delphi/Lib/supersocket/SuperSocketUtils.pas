unit SuperSocketUtils;

interface

uses
  Windows, Classes, SysUtils, Winsock2;

const
  PACKET_SIZE_LIMIT = 1024 * 2;

  CLIENT_PING_INTERVAL = 1000;

  MAX_IDLE_TIME = 1000 * 60; /// 일정 시간 이상 아무런 통신이 없으면 Disconnect

  {*
    Idle을 CLIENT_PING_INTERVAL 단위로 증가시켜서 검사 할 때 사용한다.
    기존에 MAX_IDLE_COUNT를 다른 용도로 사용한 적이 있기 때문에 이름의 규칙을 일부로 어겼다.
  }
  _MAX_IDLE_COUNT = MAX_IDLE_TIME div CLIENT_PING_INTERVAL;

  SERVER_IS_BUSY_LIMIT = 2;

type
  TSuperSocketPacketHeader = packed record
    CustomData : DWord;
    Size : word;
  end;
  PSuperSocketPacketHeader = ^TSuperSocketPacketHeader;

  TSuperSocketPacket = packed record
    Header : TSuperSocketPacketHeader;
    DataStart : byte;
  end;
  PSuperSocketPacket = ^TSuperSocketPacket;

  ISuperSocketServer = interface
    ['{4147839F-CC60-42FA-A3A6-472D61F0A1E5}']

    function GetPacket(ACustomData:DWord; AData:pointer; ASize:integer):pointer;

    procedure Disconnect(AConnection:TObject);

    procedure Send(AConnection:TObject; ASocket:integer; ABuffer:pointer; ABufferSize:integer);

    procedure FireReceivedEvent(AConnection:TObject; ACustomData:DWord; AData:pointer; ASize:integer);
  end;

  IConnection = interface
    ['{70D4AD4A-592A-474D-87D7-0D80E619F00B}']

    function SetSocket(AValue:integer):integer;

    procedure ClearIdleCount;

    procedure AddPacket(AData:pointer; ASize:integer);
    procedure ProceedPacket;
  end;

  ISuperSocketClient = interface
    ['{3EA21770-A621-43F3-8D25-172AC97DBFC1}']

    procedure Connect;
    procedure Disconnect;

    procedure Send(ACustomData:DWord; AData:Pointer; ASize:integer);
    procedure SendNow(ACustomData:DWord; AData:Pointer; ASize:integer);

    procedure Flush;
  end;

  TReceivedEvent = procedure (Sender:TObject; ACustomData:DWord; AData:pointer; ASize:integer) of object;

procedure SetSocketDelayOption(ASocket:integer; ADelay:boolean);
procedure SetSocketLingerOption(ASocket,ALinger:integer);

implementation

procedure SetSocketDelayOption(ASocket:integer; ADelay:boolean);
var
  iValue : integer;
begin
  if ADelay then iValue := 0
  else iValue := 1;

  setsockopt( ASocket, IPPROTO_TCP, TCP_NODELAY, @iValue, SizeOf(iValue) );
end;

procedure SetSocketLingerOption(ASocket,ALinger:integer);
type
  TLinger = packed record
    OnOff : integer;
    Linger : integer;
  end;
var
  Linger : TLinger;
begin
  Linger.OnOff := 1;
  Linger.Linger := ALinger;
  setsockopt( ASocket, SOL_SOCKET, SO_LINGER, @Linger, SizeOf(Linger) );
end;

end.
