unit DelayRemover;

interface

uses
  RyuLibBase,
  SysUtils, Classes;

const
  DEFAULT_BUFFER_SIZE = 1024 * 4;

type
  TDelayRemover = class
  private
    FBuffer : pointer;
    procedure dec_Delay(ATempo:integer; AData: pointer; ASize: integer);
    procedure inc_Delay(ATempo:integer; AData: pointer; ASize: integer);
  private
    FOnData: TDataEvent;
    FTempo: integer;
    procedure SetTempo(const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;

    procedure DataIn(AData:pointer; ASize:integer);
  public
    property Tempo : integer read FTempo write SetTempo;
    property OnData : TDataEvent read FOnData write FOnData;
  end;

implementation

{ TDelayRemover }

constructor TDelayRemover.Create;
begin
  inherited;

  FTempo := 0;

  GetMem( FBuffer, DEFAULT_BUFFER_SIZE );
end;

procedure TDelayRemover.DataIn(AData: pointer; ASize: integer);
begin
  if FTempo > 0 then dec_Delay( FTempo, AData, ASize )
  else if FTempo < 0 then inc_Delay( -FTempo, AData, ASize )
  else begin
    if Assigned(FOnData) then FOnData(Self, AData, ASize );
  end;
end;

procedure TDelayRemover.dec_Delay(ATempo: integer; AData: pointer; ASize: integer);
var
  pSrc, pDst : PSMallInt;
  Loop, Count, Interval, SizeOut : integer;
begin
  pSrc := AData;
  pDst := FBuffer;

  Count := 0;
  Interval := (ASize div 2) div ATempo;
  SizeOut := ASize;

  // TODO: 너무 밀리면 SoundTouch를 사용 고려, 음질 때문

  for Loop := 0 to (ASize div 2)-1 do begin
    Count := Count + 1;

    if Count >= Interval then begin
      Count := 0;

      SizeOut := SizeOut - 2;
      Inc(pSrc);
    end else begin
      pDst^ := pSrc^;
      Inc(pSrc);
      Inc(pDst);
    end;
  end;

  if Assigned(FOnData) then FOnData(Self, FBuffer, SizeOut );
end;

destructor TDelayRemover.Destroy;
begin
  FreeMem( FBuffer );

  inherited;
end;

procedure TDelayRemover.inc_Delay(ATempo: integer; AData: pointer; ASize: integer);
var
  pSrc, pDst : PSMallInt;
  Loop, Count, Interval, SizeOut : integer;
begin
  pSrc := AData;
  pDst := FBuffer;

  Count := 0;
  Interval := (ASize div 2) div ATempo;
  SizeOut := ASize;

  for Loop := 0 to (ASize div 2)-1 do begin
    Count := Count + 1;

    if Count >= Interval then begin
      Count := 0;

      SizeOut := SizeOut + 2;
      pDst^ := pSrc^;
      Inc(pDst);

      pDst^ := pSrc^;
      Inc(pSrc);
      Inc(pDst);
    end else begin
      pDst^ := pSrc^;

      Inc(pSrc);
      Inc(pDst);
    end;
  end;

  if Assigned(FOnData) then FOnData(Self, FBuffer, SizeOut );
end;

procedure TDelayRemover.SetTempo(const Value: integer);
begin
  FTempo := Value;
end;

end.
