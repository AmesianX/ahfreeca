unit VideoDecoder;

interface

uses
  Config,
  RyuLibBase, VideoZipUtils, RyuGraphics, PacketProcessor,
  SysUtils, Classes, Graphics, SyncObjs;

type
  IVideoDecoder = interface
    ['{0D3F8EF4-A20D-4402-9A99-82AE13AD6EE2}']

    function GetBitmap(ABitmap:TBitmap):boolean;
  end;

  TVideoDecoder = class (TInterfaceBase, IVideoDecoder)
  public  // implementation of IVideoDecoder
    function GetBitmap(ABitmap:TBitmap):boolean;
  private
    FHandle : pointer;
    FCS : TCriticalSection;
  private
    FPacketProcessor : TPacketProcessor;
    procedure on_PacketProcessor(Sender:TObject; AData:pointer; ASize:integer);
  private
    FBitmap : TBitmap;
    FIsBitmapReady : boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(AWidth,AHeight:integer);
    procedure Close;

    procedure Execute(AData:pointer; ASize:integer);
  end;

implementation

{ TVideoDecoder }

procedure TVideoDecoder.Close;
begin
  FCS.Acquire;
  try
    FIsBitmapReady := false;

    if FHandle <> nil then begin
      closeDecoder(FHandle);
      FHandle := nil;
    end;
  finally
    FCS.Release;
  end;
end;

constructor TVideoDecoder.Create;
begin
  inherited;

  FHandle := nil;

  FIsBitmapReady := false;

  FCS := TCriticalSection.Create;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;

  FPacketProcessor := TPacketProcessor.Create;
  FPacketProcessor.OnData := on_PacketProcessor;
end;

destructor TVideoDecoder.Destroy;
begin
  Close;

  FreeAndNil(FCS);
  FreeAndNil(FBitmap);
  FreeAndNil(FPacketProcessor);

  inherited;
end;

procedure TVideoDecoder.Execute(AData: pointer; ASize: integer);
begin
  FPacketProcessor.Add( AData, ASize );
end;

function TVideoDecoder.GetBitmap(ABitmap: TBitmap): boolean;
begin
  Result := false;

  FCS.Acquire;
  try
    if FHandle = nil then Exit;

    if FIsBitmapReady = false then Exit;

    FIsBitmapReady := false;

    AssignBitmap( FBitmap, ABitmap );

    Result := true;
  finally
    FCS.Release;
  end;
end;

procedure TVideoDecoder.on_PacketProcessor(Sender: TObject; AData: pointer; ASize: integer);
begin
  FCS.Acquire;
  try
    if FHandle = nil then Exit;

    if decodeBitmap( FHandle, FBitmap.ScanLine[FBitmap.Height-1], AData, ASize ) then FIsBitmapReady := true;
  finally
    FCS.Release;
  end;
end;

procedure TVideoDecoder.Open(AWidth, AHeight: integer);
var
  iErrorCode : integer;
begin
  FCS.Acquire;
  try
    FIsBitmapReady := false;

    if FHandle <> nil then closeDecoder( FHandle );

    FHandle := openDecoder( iErrorCode, AWidth, AHeight );

    if iErrorCode <> 0 then begin
      FHandle := nil;
      raise Exception.Create( Format('TVideoDecoder.Open - ErrorCode: %d', [iErrorCode]) );
    end;

    FBitmap.Width  := AWidth;
    FBitmap.Height := AHeight;
  finally
    FCS.Release;
  end;
end;

end.
