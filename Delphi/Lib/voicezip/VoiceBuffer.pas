unit VoiceBuffer;

interface

uses
  DebugTools, VoiceZipUtils, DynamicQueue,
  Classes, SysUtils, SyncObjs;

type
  TVoiceBuffer = class
  private
    FCS : TCriticalSection;
    FList : TDynamicQueue;
  private
    FDuration: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(AData:pointer; ASize:integer);
    function Get(var AData:pointer; var ASize:integer):boolean; overload;

    /// ADuration만큼 데이터를 가져온다.
    function Get(var AData:pointer; var ASize:integer; ADuration:integer):boolean; overload;
  public
    property Duration : integer read FDuration;
  end;

implementation

type
  TPacket = class
  private
  public
    Data : pointer;
    Size : integer;
    constructor Create(AData:pointer; ASize:integer); reintroduce;
  end;

{ TPacket }

constructor TPacket.Create(AData: pointer; ASize: integer);
begin
  inherited Create;

  Size := ASize;
  if Size <= 0 then begin
    Data := nil;
  end else begin
    GetMem(Data, Size);
    Move(AData^, Data^, Size);
  end;
end;

{ TVoiceBuffer }

procedure TVoiceBuffer.Add(AData: pointer; ASize: integer);
var
  Packet : TPacket;
begin
  FCS.Enter;
  try
    Packet := TPacket.Create(AData, ASize);
    FList.Push(Packet);
    FDuration := FDuration + (ASize div _FrameSize) * _FrameTime;
  finally
    FCS.Leave;
  end;
end;

procedure TVoiceBuffer.Clear;
var
  Packet : TPacket;
begin
  FCS.Enter;
  try
    while FList.Pop(Pointer(Packet)) do begin
      if Packet.Data <> nil then FreeMem(Packet.Data);
      Packet.Free;
    end;

    FDuration := 0;
  finally
    FCS.Leave;
  end;
end;

constructor TVoiceBuffer.Create;
begin
  inherited;

  FDuration := 0;

  FCS := TCriticalSection.Create;
  FList := TDynamicQueue.Create(false);
end;

destructor TVoiceBuffer.Destroy;
begin
  Clear;

  FreeAndNil(FCS);
  FreeAndNil(FList);

  inherited;
end;

function TVoiceBuffer.Get(var AData: pointer; var ASize: integer;
  ADuration: integer): boolean;
var
  Packet : TPacket;
  msData : TMemoryStream;
begin
  AData := nil;
  ASize := 0;
  Result := false;

  FCS.Enter;
  try
    if FDuration < ADuration then Exit;

    msData := TMemoryStream.Create;
    try
      while ADuration > 0 do begin
        if not FList.Pop(Pointer(Packet)) then Exit;

        msData.Write(Packet.Data, Packet.Size);

        ASize := msData.Size;

        ADuration := ADuration - (ASize div _FrameSize) * _FrameTime;
        FDuration := FDuration - (ASize div _FrameSize) * _FrameTime;
      end;

      Result := (ADuration <= 0) and (msData.Size > 0);
      if Result then begin
        ASize := msData.Size;

        GetMem(AData, ASize);
        Move(msData.Memory^, AData^, ASize);
      end;
    finally
      msData.Free;
    end;
  finally
    FCS.Leave;
  end;
end;

function TVoiceBuffer.Get(var AData: pointer; var ASize: integer): boolean;
var
  Packet : TPacket;
begin
  AData := nil;
  ASize := 0;
  Result := false;

  FCS.Enter;
  try
    if not FList.Pop(Pointer(Packet)) then Exit;

    try
      ASize := Packet.Size;
      AData := Packet.Data;

      Result := true;
    finally
      Packet.Free;
    end;

    FDuration := FDuration - (ASize div _FrameSize) * _FrameTime;
  finally
    FCS.Leave;
  end;
end;

end.
