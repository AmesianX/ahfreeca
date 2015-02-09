unit SnapShot;

interface

uses
  WebCam, RyuGraphics,
  Classes, SysUtils, Graphics, SyncObjs, ExtCtrls;

const
  CAM_WIDTH  = 800;
  CAM_HEIGHT = 600;

type
  TSnapShot = class (TComponent)
  private
    FCS_SnapShot : TCriticalSection;
    FBitmapSnapShot : TBitmap;
    FBitmapSrc : TBitmap;
    FHasPreview : boolean;
    FHasSnapShot : boolean;
    FWebCam : TWebCam;
  private
    FWidth : integer;
    FHeight : integer;
  private
    FTimer : TTimer;
    procedure on_Timer(Sender:TObject);
  private
    function GetDeviceCount: Integer;
    function GetDeviceList: TStringList;
    function GetDeviceNo: Integer;
    procedure SetDeviceNo(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    function GetBitmap(ABitmap:TBitmap):boolean;
    function GetSnapShot(ABitmap:TBitmap):boolean;
  published
    property DeviceNo : Integer read GetDeviceNo write SetDeviceNo;
    property DeviceCount : Integer read GetDeviceCount;
    property DeviceList : TStringList read GetDeviceList;
  end;

implementation

{ TSnapShot }

constructor TSnapShot.Create(AOwner: TComponent);
begin
  inherited;

  FHasPreview := false;
  FHasSnapShot := false;

  FWidth  := CAM_WIDTH;
  FHeight := CAM_HEIGHT;

  FCS_SnapShot := TCriticalSection.Create;

  FBitmapSnapShot := TBitmap.Create;
  FBitmapSnapShot.PixelFormat := pf32bit;
  FBitmapSnapShot.Canvas.Brush.Color := clBlack;
  FBitmapSnapShot.Width := FWidth;
  FBitmapSnapShot.Height := FHeight;

  FBitmapSrc := TBitmap.Create;
  FBitmapSrc.PixelFormat := pf32bit;
  FBitmapSrc.Canvas.Brush.Color := clBlack;
  FBitmapSrc.Width := FWidth;
  FBitmapSrc.Height := FHeight;

  FWebCam := TWebCam.Create(Self);

  // Cam을 미리 오픈하지 않으면 바로 쓸 수 없는 제품 군들이 있다.
  FWebCam.Start(FWidth, FHeight);
  FWebCam.Stop;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := 10;
  FTimer.Enabled := true;
end;

destructor TSnapShot.Destroy;
begin
  Stop;

  FreeAndNil(FTimer);
  FreeAndNil(FWebCam);
  FreeAndNil(FBitmapSrc);
  FreeAndNil(FBitmapSnapShot);
  FreeAndNil(FCS_SnapShot);

  inherited;
end;

function TSnapShot.GetBitmap(ABitmap: TBitmap): boolean;
begin
  FCS_SnapShot.Enter;
  try
    Result := FHasSnapShot;
    if Result then ABitmap.Assign(FBitmapSnapShot);
  finally
    FCS_SnapShot.Leave;
  end;
end;

function TSnapShot.GetDeviceCount: Integer;
begin
  Result := FWebCam.DeviceCount;
end;

function TSnapShot.GetDeviceList: TStringList;
begin
  Result := FWebCam.DeviceList;
end;

function TSnapShot.GetDeviceNo: Integer;
begin
  Result := FWebCam.DeviceNo;
end;

function TSnapShot.GetSnapShot(ABitmap: TBitmap): boolean;
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf32bit;

    FCS_SnapShot.Enter;
    try
      Result := FHasSnapShot;
      if Result then begin
        FHasSnapShot := false;

        Bitmap.Width :=  FBitmapSnapShot.Width;
        Bitmap.Height := FBitmapSnapShot.Height;

        Move(
          FBitmapSnapShot.ScanLine[FBitmapSnapShot.Height-1]^,
          Bitmap.ScanLine[Bitmap.Height-1]^,
          Bitmap.Width * Bitmap.Height * 4
        );
      end;
    finally
      FCS_SnapShot.Leave;
    end;

    if Result then begin
      SmoothResize(Bitmap, ABitmap);
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure TSnapShot.on_Timer(Sender: TObject);
begin
  FTimer.Enabled := false;
  try
    if FHasSnapShot then Exit;

    try
      if FWebCam.Active then
        FHasSnapShot := FWebCam.GetBitmap(FBitmapSrc);
    except
      Exit;
    end;

    FCS_SnapShot.Enter;
    try
      if FHasSnapShot then FHasPreview := true;
      FBitmapSnapShot.Assign(FBitmapSrc);
    finally
      FCS_SnapShot.Leave;
    end;
  finally
    FTimer.Enabled := true;
  end;
end;

procedure TSnapShot.SetDeviceNo(const Value: Integer);
begin
  FWebCam.DeviceNo := Value;
end;

procedure TSnapShot.Start;
begin
  FWebCam.Start(FWidth, FHeight);
  FTimer.OnTimer := on_Timer;
end;

procedure TSnapShot.Stop;
begin
  FTimer.OnTimer := nil;
  FWebCam.Stop;
end;

end.
