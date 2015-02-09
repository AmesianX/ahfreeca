unit VoicePlayers;

interface

uses
  VoicePlayer, SimpleThread, PacketBuffer,
  Generics.Collections,
  Windows, Messages, Classes, SysUtils;

type
  TVoicePlayerUnit = class (TVoicePlayer)
  private
    FConnectionID : integer;
  public
    procedure DataInEx(AData:pointer; ASize:integer);
  end;

  TVoicePlayers = class (TComponent)
  private
    FVoicePlayerUnits : TList<TVoicePlayerUnit>;
    function find_VoicePlayerUnits(AConnectionID:integer):TVoicePlayerUnit;
    function create_VoicePlayerUnits(AConnectionID:integer):TVoicePlayerUnit;
    procedure release_VoicePlayerUnits;
  private
    FPacketBuffer : TPacketBuffer;
    FSimpleThread : TSimpleThread;
    procedure on_Repeat(Sender:TObject);
  private
    FDurationLimit: integer;
    FMute: Boolean;
    FVolume: Single;
    procedure SetDurationLimit(const Value: integer);
    procedure SetMute(const Value: Boolean);
    procedure SetVolume(const Value: Single);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DataIn(AConnectionID:integer; AData:pointer; ASize:integer); overload;
    procedure DataIn(AConnectionID:integer; AStream:TStream); overload;
  published
    property Mute: Boolean read FMute write SetMute;
    property Volume: Single read FVolume write SetVolume;

    /// VoiceBuffer can't hold data more than DurationLimit.  When it over the limit, Tempo will increased automatically to reduce it's amount.
    property DurationLimit : integer read FDurationLimit write SetDurationLimit;
  end;

implementation

{ TVoicePlayerUnit }

procedure TVoicePlayerUnit.DataInEx(AData: pointer; ASize: integer);
begin
  // TODO: 재사용을 위해서 Alive를 점검 할 수 있는 준비 (최근 사용 기록)
  DataIn(AData, ASize);
end;

{ TVoicePlayers }

constructor TVoicePlayers.Create(AOwner: TComponent);
begin
  inherited;

  FMute := false;
  FVolume := 1.0;
  FDurationLimit := 0;

  FPacketBuffer := TPacketBuffer.Create;
  FSimpleThread := TSimpleThread.Create(on_Repeat);
  FVoicePlayerUnits := TList<TVoicePlayerUnit>.Create;
end;

procedure TVoicePlayers.DataIn(AConnectionID: integer; AData: pointer;
  ASize: integer);
begin
  FPacketBuffer.Add( AData, ASize, Pointer(AConnectionID) );
  FSimpleThread.WakeUp;
end;

function TVoicePlayers.create_VoicePlayerUnits(AConnectionID:integer): TVoicePlayerUnit;
begin
  // TODO: 오랫 동안 방치된 유닛을 재 사용

  Result := TVoicePlayerUnit.Create(Self);
  Result.FConnectionID := AConnectionID;
  Result.DurationLimit := FDurationLimit;
  Result.Start;

  FVoicePlayerUnits.Add(Result);
end;

procedure TVoicePlayers.DataIn(AConnectionID: integer; AStream: TStream);
var
  Data : pointer;
begin
  if AStream.Size = 0 then Exit;

  GetMem( Data, AStream.Size );
  try
    AStream.Position := 0;
    AStream.Write( Data^, AStream.Size );

    DataIn( AConnectionID, Data, AStream.Size );
  finally
    FreeMem( Data );
  end;
end;

destructor TVoicePlayers.Destroy;
begin
  FSimpleThread.Terminate;

  inherited;
end;

function TVoicePlayers.find_VoicePlayerUnits(
  AConnectionID: integer): TVoicePlayerUnit;
var
  Loop: Integer;
begin
  for Loop := 0 to FVoicePlayerUnits.Count-1 do
    if FVoicePlayerUnits[Loop].FConnectionID = AConnectionID then begin
      Result := FVoicePlayerUnits[Loop];
      Exit;
    end;

  Result := create_VoicePlayerUnits(AConnectionID);
end;

procedure TVoicePlayers.on_Repeat(Sender: TObject);
var
  Data : pointer;
  Size : integer;
  ConnectionID : pointer;
  VoicePlayerUnit : TVoicePlayerUnit;
begin
  while not FSimpleThread.Terminated do begin
    FSimpleThread.SleepTight;

    while FPacketBuffer.GetPacket(Data, Size, ConnectionID) do begin
      try
        VoicePlayerUnit := find_VoicePlayerUnits( Integer(ConnectionID) );
        if VoicePlayerUnit <> nil then VoicePlayerUnit.DataInEx( Data, Size );
      finally
        if Data <> nil then FreeMem(Data);
      end;
    end;
  end;

  release_VoicePlayerUnits;

  FreeAndNil(FPacketBuffer);
  FreeAndNil(FVoicePlayerUnits);
end;

procedure TVoicePlayers.release_VoicePlayerUnits;
var
  Loop: Integer;
begin
  for Loop := 0 to FVoicePlayerUnits.Count-1 do begin
    FVoicePlayerUnits[Loop].Stop;
    FVoicePlayerUnits[Loop].Free;
  end;

  FVoicePlayerUnits.Clear;
end;

procedure TVoicePlayers.SetDurationLimit(const Value: integer);
var
  Loop: Integer;
begin
  FDurationLimit := Value;
  for Loop := 0 to FVoicePlayerUnits.Count-1 do FVoicePlayerUnits[Loop].DurationLimit := Value;
end;

procedure TVoicePlayers.SetMute(const Value: Boolean);
var
  Loop: Integer;
begin
  FMute := Value;
  for Loop := 0 to FVoicePlayerUnits.Count-1 do FVoicePlayerUnits[Loop].Mute := Value;
end;

procedure TVoicePlayers.SetVolume(const Value: Single);
var
  Loop: Integer;
begin
  FVolume := Value;
  for Loop := 0 to FVoicePlayerUnits.Count-1 do FVoicePlayerUnits[Loop].Volume := Value;
end;

end.
