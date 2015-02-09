unit VideoZip;

interface

uses
  DebugTools, VideoZipUtils, RyuLibBase, RyuGraphics, VideoZipPacketSlice,
  Windows, Classes, SysUtils, SyncObjs, Graphics;

type
  TVideoZipEncoder = class (TComponent)
  private
    FCS : TCriticalSection;
    FCamSliceSeq : Cardinal;
    FHandle : pointer;
    FBitmap : TBitmap;
    FBuffer : pointer;
    FBufferSize : integer;
    procedure check_EncoderIsOpen;
  private
    FBitRate: integer;
    FGOP_Size: integer;
    FOnData: TDataEvent;
    procedure SetBitRate(const Value: integer);
    procedure SetGOP_Size(const Value: integer);
    function GetHeight: integer;
    function GetWidth: integer;
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    function GetOpened: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure Encode(ABitmap:TBitmap; AQuality:integer = VPX_DL_BEST_QUALITY);
  published
    property Opened : boolean read GetOpened;
    property Width : integer read GetWidth write SetWidth;
    property Height : integer read GetHeight write SetHeight;
    property BitRate : integer read FBitRate write SetBitRate;
    property GOP_Size : integer read FGOP_Size write SetGOP_Size;
    property OnData : TDataEvent read FOnData write FOnData;
  end;

  /// 동영상 디코더에 대한 인터페이스
  IVideoZipDecoder = interface
    ['{EAE8D415-23A4-45A8-8DE4-EB708AFA5C9C}']

    function GetWidth:integer;
    function GetHeight:integer;

    function GetBitmap(ABitmap:TBitmap):boolean;  /// 동영상 디코더의 현재 화면을 얻는다.
  end;

  TVideoZipDecoder = class (TComponent, IVideoZipDecoder)
  private
    FCS : TCriticalSection;
    FHandle : pointer;
    FBitmap : TBitmap;
    FIsBitmapChanged : boolean;
    FPacketSliceMerge : TPacketSliceMerge;
    procedure check_DecoderIsOpen;
  private
    FOnBitmapIsReady: TNotifyEvent;
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    function GetHeight: integer;
    function GetWidth: integer;
    function GetOpened: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure Init;

    procedure Decode(AData:pointer; ASize:integer); overload;
    function Decode(ABitmap:TBitmap; AData:pointer; ASize:integer):boolean; overload;

    function GetBitmap(ABitmap:TBitmap):boolean;
  published
    property Opened : boolean read GetOpened;
    property Width : integer read GetWidth write SetWidth;
    property Height : integer read GetHeight write SetHeight;
    property OnBitmapIsReady : TNotifyEvent read FOnBitmapIsReady write FOnBitmapIsReady;
  end;

implementation

{ TVideoZipEncoder }

procedure TVideoZipEncoder.check_EncoderIsOpen;
begin
  if FHandle <> nil then
    raise Exception.Create('Encoder is opened.  Change properties before open it!');
end;

procedure TVideoZipEncoder.Close;
begin
  FCS.Acquire;
  try
    if FHandle <> nil then begin
      closeEncoder(FHandle);
      FHandle := nil;
    end;

    if FBuffer <> nil then begin
      FreeMem(FBuffer);
      FBuffer := nil;
    end;

    FBufferSize := 0;
  finally
    FCS.Release;
  end;
end;

constructor TVideoZipEncoder.Create(AOwner: TComponent);
begin
  inherited;

  FCamSliceSeq := 0;
  FHandle := nil;

  FBuffer := nil;
  FBufferSize := 0;

  FCS := TCriticalSection.Create;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := PIXEL_FORMAT;
  FBitmap.Width := 320;
  FBitmap.Height := 240;

  FBitRate := 0;
  FGOP_Size := 0;
end;

destructor TVideoZipEncoder.Destroy;
begin
  Close;

  FreeAndNil(FCS);
  FreeAndNil(FBitmap);

  inherited;
end;

procedure TVideoZipEncoder.Encode(ABitmap:TBitmap; AQuality:integer);
var
  Packet : TPacket;
  pData : pbyte;
  iSize, iSizeOfSlice : integer;
  NewDataEvent : TDataEvent;
  pts : int64;
begin
  NewDataEvent := FOnData;

  FCS.Acquire;
  try
    if (FHandle = nil) or (not Assigned(NewDataEvent)) then Exit;

    SmoothResize(ABitmap, FBitmap);

    iSize := encodeBitmap(FHandle, FBitmap.ScanLine[FBitmap.Height-1], FBuffer, FBufferSize, AQuality, pts);

    FCamSliceSeq := FCamSliceSeq + 1;

    Packet.Header.Seq := FCamSliceSeq;
    Packet.Header.Index := 0;
    Packet.Header.Size := iSize;

    pData := FBuffer;

    while iSize > 0 do begin
      if iSize >= SLICE_SIZE  then iSizeOfSlice := SLICE_SIZE
      else iSizeOfSlice := iSize;
      iSize := iSize - SLICE_SIZE;

      Move(pData^, Packet.Data[0], iSizeOfSlice);
      Inc(pData, iSizeOfSlice);

      FOnData(Self, @Packet, SizeOF(TPacketHeader) + iSizeOfSlice);

      Packet.Header.Index := Packet.Header.Index + 1;
    end;
  finally
    FCS.Release;
  end;
end;

function TVideoZipEncoder.GetHeight: integer;
begin
  FCS.Acquire;
  try
    Result := FBitmap.Height;
  finally
    FCS.Release;
  end;
end;

function TVideoZipEncoder.GetOpened: boolean;
begin
  FCS.Acquire;
  try
    Result := FHandle <> nil;
  finally
    FCS.Release;
  end;
end;

function TVideoZipEncoder.GetWidth: integer;
begin
  FCS.Acquire;
  try
    Result := FBitmap.Width;
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipEncoder.Open;
var
  iErrorCode : integer;
begin
  FCamSliceSeq := 0;

  FCS.Acquire;
  try
    FHandle := openEncoder(iErrorCode, FBitmap.Width, FBitmap.Height, FBitRate, FGOP_Size);
    if iErrorCode <> 0 then begin
      FHandle := nil;
      raise Exception.Create(Format('Can''t open Encoder.'#13#10'ErrorCode = %d', [iErrorCode]));
    end;

    FBufferSize := FBitmap.Width * FBitmap.Height * PIXEL_SIZE;
    GetMem(FBuffer, FBufferSize);
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipEncoder.SetBitRate(const Value: integer);
begin
  FCS.Acquire;
  try
    check_EncoderIsOpen;

    FBitRate := Value;
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipEncoder.SetGOP_Size(const Value: integer);
begin
  FCS.Acquire;
  try
    check_EncoderIsOpen;

    FGOP_Size := Value;
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipEncoder.SetHeight(const Value: integer);
begin
  FCS.Acquire;
  try
    check_EncoderIsOpen;

    FBitmap.Height := Value;
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipEncoder.SetWidth(const Value: integer);
begin
  FCS.Acquire;
  try
    check_EncoderIsOpen;

    FBitmap.Width := Value;
  finally
    FCS.Release;
  end;
end;

{ TVideoZipDecoder }

procedure TVideoZipDecoder.check_DecoderIsOpen;
begin
  if FHandle <> nil then
    raise Exception.Create('Decoder is opened.  Change properties before open it!');
end;

procedure TVideoZipDecoder.Close;
begin
  FCS.Acquire;
  try
    if FHandle <> nil then begin
      closeDecoder(FHandle);
      FHandle := nil;
    end;
  finally
    FCS.Release;
  end;
end;

constructor TVideoZipDecoder.Create(AOwner: TComponent);
begin
  inherited;

  FHandle := nil;
  FIsBitmapChanged := false;

  FCS := TCriticalSection.Create;
  FPacketSliceMerge := TPacketSliceMerge.Create;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := PIXEL_FORMAT;
  FBitmap.Width := 320;
  FBitmap.Height := 240;
end;

function TVideoZipDecoder.Decode(ABitmap:TBitmap; AData: pointer; ASize: integer): boolean;
var
  Data : pointer;
  Size : integer;
  isChanged : boolean;
  PacketSlice : TPacketSlice;
begin
  Result := false;

  FCS.Acquire;
  try
    if FHandle = nil then Exit;

    PacketSlice := FPacketSliceMerge.GetPacketSlice(AData, ASize);
    if not PacketSlice.Get(Data, Size) then Exit;

    try
      isChanged := decodeBitmap(FHandle, FBitmap.ScanLine[FBitmap.Height-1], Data, Size);
      if isChanged then FIsBitmapChanged := true;

      if FIsBitmapChanged then begin
        AssignBitmap( FBitmap, ABitmap );
        Result := true;
      end;
    finally
      if Data <> nil then FreeMem(Data);
    end;
  finally
    FCS.Release;
  end;

  if isChanged and Assigned(FOnBitmapIsReady) then FOnBitmapIsReady(Self);
end;

procedure TVideoZipDecoder.Decode(AData: pointer; ASize: integer);
var
  Data : pointer;
  Size : integer;
  isChanged : boolean;
  PacketSlice : TPacketSlice;
begin
  FCS.Acquire;
  try
    if FHandle = nil then Exit;

    PacketSlice := FPacketSliceMerge.GetPacketSlice(AData, ASize);
    if not PacketSlice.Get(Data, Size) then Exit;

    try
      isChanged := decodeBitmap(FHandle, FBitmap.ScanLine[FBitmap.Height-1], Data, Size);
      if isChanged then FIsBitmapChanged := true;
    finally
      if Data <> nil then FreeMem(Data);
    end;
  finally
    FCS.Release;
  end;

  if isChanged and Assigned(FOnBitmapIsReady) then FOnBitmapIsReady(Self);
end;

destructor TVideoZipDecoder.Destroy;
begin
  Close;

  FreeAndNil(FCS);
  FreeAndNil(FPacketSliceMerge);
  FreeAndNil(FBitmap);

  inherited;
end;

function TVideoZipDecoder.GetBitmap(ABitmap: TBitmap): boolean;
begin
  Result := false;

  FCS.Acquire;
  try
    if not FIsBitmapChanged then Exit;

    FIsBitmapChanged := false;

    AssignBitmap( FBitmap, ABitmap );

    Result := true;
  finally
    FCS.Release;
  end;
end;

function TVideoZipDecoder.GetHeight: integer;
begin
  FCS.Acquire;
  try
    Result := FBitmap.Height;
  finally
    FCS.Release;
  end;
end;

function TVideoZipDecoder.GetOpened: boolean;
begin
  FCS.Acquire;
  try
    Result := FHandle <> nil;
  finally
    FCS.Release;
  end;
end;

function TVideoZipDecoder.GetWidth: integer;
begin
  FCS.Acquire;
  try
    Result := FBitmap.Width;
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipDecoder.Init;
begin
  FCS.Acquire;
  try
    initDecoder(FHandle);
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipDecoder.Open;
var
  iErrorCode : integer;
begin
  FCS.Acquire;
  try
    FHandle := openDecoder(iErrorCode, Width, Height);
    if iErrorCode <> 0 then begin
      FHandle := nil;
      raise Exception.Create(Format('Can''t open Decoder.'#13#10'ErrorCode = %d', [iErrorCode]));
    end;

    FIsBitmapChanged := false;
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipDecoder.SetHeight(const Value: integer);
begin
  FCS.Acquire;
  try
    check_DecoderIsOpen;

    FBitmap.Height := Value;
  finally
    FCS.Release;
  end;
end;

procedure TVideoZipDecoder.SetWidth(const Value: integer);
begin
  FCS.Acquire;
  try
    check_DecoderIsOpen;

    FBitmap.Width := Value;
  finally
    FCS.Release;
  end;
end;

end.
