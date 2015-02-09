unit VideoEncoder;

interface

uses
  DebugTools, RyuLibBase, VideoZipUtils,
  SysUtils, Classes, Graphics, syncObjs;

type
  TVideoEncoder = class
  private
    FCS : TCriticalSection;
    FHandle : pointer;
    FBufferEncode : pointer;
    FBufferSize : integer;
  private
    FOnVideoData: TDataEvent;
    FWidth: integer;
    FHeight: integer;
    FBitrate: integer;
    FQuality: integer;
    FGOP: integer;
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    function GetIsOpened: boolean;
    procedure SetBitrate(const Value: integer);
    procedure SetQuality(const Value: integer);
    procedure SetGOP(const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure Execute(ABitmap:TBitmap);
  public
    property IsOpened : boolean read GetIsOpened;
    property Width : integer read FWidth write SetWidth;
    property Height : integer read FHeight write SetHeight;
    property GOP : integer read FGOP write SetGOP;
    property Quality : integer read FQuality write SetQuality;
    property Bitrate : integer read FBitrate write SetBitrate;
    property OnVideoData : TDataEvent read FOnVideoData write FOnVideoData;
  end;

implementation

{ TVideoEncoder }

procedure TVideoEncoder.Close;
begin
  FCS.Acquire;
  try
    if FHandle <> nil then begin
      closeEncoder( FHandle );
      FHandle := nil;
    end;
  finally
    FCS.Release;
  end;
end;

constructor TVideoEncoder.Create;
begin
  inherited;

  FHandle := nil;

  FGOP := -1;
  FBufferSize := 0;
  FQuality := VPX_DL_BEST_QUALITY;
  FBitrate := 0;

  FCS := TCriticalSection.Create;
end;

destructor TVideoEncoder.Destroy;
begin
  Close;

  FreeAndNil(FCS);

  inherited;
end;

procedure TVideoEncoder.Execute(ABitmap: TBitmap);
var
  pts : int64;
  iEncodeSize : integer;
begin
  FCS.Acquire;
  try
    if FHandle = nil then Exit;

    if (ABitmap.Width > 0) and (ABitmap.Height > 0) then begin
      iEncodeSize := encodeBitmap(FHandle, ABitmap.ScanLine[ABitmap.Height-1], FBufferEncode, FBufferSize, FQuality, pts);

      if Assigned(FOnVideoData) then FOnVideoData(Self, FBufferEncode, iEncodeSize);

      {$IFDEF DEBUG}
//      Trace( Format('TVideoEncoder.Execute - iEncodeSize: %d', [iEncodeSize]) );
      {$ENDIF}
    end;
  finally
    FCS.Release;
  end;
end;

function TVideoEncoder.GetIsOpened: boolean;
begin
  FCS.Acquire;
  try
    Result := FHandle <> nil;
  finally
    FCS.Release;
  end;
end;

procedure TVideoEncoder.Open;
var
  iErrorCode : integer;
begin
  FCS.Acquire;
  try
    if FHandle <> nil then closeEncoder( FHandle );

    FHandle := openEncoder( iErrorCode, FWidth, FHeight, FBitrate, FGOP );

    if iErrorCode <> 0 then begin
      FHandle := nil;
      raise Exception.Create( Format('TVideoEncoder.Open - ErrorCode: %d', [iErrorCode]) );
    end;

    FBufferSize := FWidth * FHeight * 4;
    GetMem( FBufferEncode, FBufferSize);
  finally
    FCS.Release;
  end;
end;

procedure TVideoEncoder.SetBitrate(const Value: integer);
begin
  FCS.Acquire;
  try
    if FHandle <> nil then
      raise Exception.Create('TVideoEncoder.SetBitrate - IsOpened = true');

    FBitrate := Value;
  finally
    FCS.Release;
  end;
end;

procedure TVideoEncoder.SetGOP(const Value: integer);
begin
  FGOP := Value;
end;

procedure TVideoEncoder.SetHeight(const Value: integer);
begin
  FCS.Acquire;
  try
    if FHandle <> nil then
      raise Exception.Create('TVideoEncoder.SetHeight - IsOpened = true');

    FHeight := Value;
  finally
    FCS.Release;
  end;
end;

procedure TVideoEncoder.SetQuality(const Value: integer);
begin
  FCS.Acquire;
  try
    if FHandle <> nil then
      raise Exception.Create('TVideoEncoder.SetQuality - IsOpened = true');

    FQuality := Value;
  finally
    FCS.Release;
  end;
end;

procedure TVideoEncoder.SetWidth(const Value: integer);
begin
  FCS.Acquire;
  try
    if FHandle <> nil then
      raise Exception.Create('TVideoEncoder.SetWidth - IsOpened = true');

    FWidth := Value;
  finally
    FCS.Release;
  end;
end;

end.
