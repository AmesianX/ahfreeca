/// TCamEncoder가 정의되고 구현된 유닛이다.
unit CamEncoder;

interface

uses
  RyuLibBase, SnapShot, VideoZip, SimpleRepeater,
  Windows, Classes, SysUtils, SyncObjs, Graphics;

type
  /// PC 캠에 대한 인터페이스
  ICamEncoder = interface
    ['{C293B78E-F07B-42C9-AA4B-59B5785D3CEE}']

    procedure Start; /// 캠을 가동 시킨다.
    procedure Stop;  /// 캠을 중단 한다.

    function GetWidth:integer;
    function GetHeight:integer;

    function IsActive:boolean;  /// 캠이 작동되는 지 알려 준다.

    function DeviceCount:integer;  /// PC에 설치되어 있는 캠의 개수를 알려 준다.

    {*
      캠의 현재 화면을 얻어 온다.
      @param ABitmap 화면의 데이터를 보관 할 TBitmap 객체
      @return 화면을 가져 왔는 지의 여부.  화면이 변하지 않았다면, false가 된다.
    }
    function GetBitmap(ABitmap:TBitmap):boolean;
  end;

  TCamEncoder = class(TComponent, ICamEncoder)
  private // implementation of ICamEncoder
    function GetWidth:integer;
    function GetHeight:integer;
    function IsActive:boolean;
  private
    FSnapShot : TSnapShot;
  private
    FCS_ScreenSize : TCriticalSection;
    FBitmapEncoder : TBitmap;
    FEncoder : TVideoZipEncoder;
  private
    FSimpleRepeater : TSimpleRepeater;
    procedure on_Repeat(Sender:TObject);
  private
    FActive : boolean;
    FWidth : integer;
    FHeight : integer;
    function GetOnNewData: TNewDataEvent;
    procedure SetOnNewData(const Value: TNewDataEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;  /// Cam 인코딩을 시작한다.
    procedure Stop;  /// Cam 인코딩을 중단한다.  Repeater가 멈출 때까지 기다린다.

    procedure SetScreenSize(AWidth,AHeight:integer);

    function DeviceCount:integer;  /// PC에 설치되어 있는 캠의 개수를 알려 준다.

    {*
      캠의 현재 화면을 얻어 온다.
      @param ABitmap 화면의 데이터를 보관 할 TBitmap 객체
      @return 화면을 가져 왔는 지의 여부.  화면이 변하지 않았다면, false가 된다.
    }
    function GetBitmap(ABitmap:TBitmap):boolean;
  published
    property Active : boolean read FActive;
    property OnNewData : TNewDataEvent read GetOnNewData write SetOnNewData;
  end;

implementation

{ TCamEncoder }

constructor TCamEncoder.Create(AOwner: TComponent);
begin
  inherited;

  FActive := false;

  FWidth := 320 div 2;
  FHeight := 240 div 2;

  FCS_ScreenSize := TCriticalSection.Create;

  FBitmapEncoder := TBitmap.Create;
  FBitmapEncoder.PixelFormat := pf32bit;
  FBitmapEncoder.Canvas.Brush.Color := clBlack;
  FBitmapEncoder.Width := FWidth;
  FBitmapEncoder.Height := FHeight;

  FEncoder := TVideoZipEncoder.Create(Self);
  FEncoder.Width := FWidth;
  FEncoder.Height := FHeight;
  FEncoder.GOP_Size := 128;
  FEncoder.BitRate := 256 * 1024;

  FSnapShot := TSnapShot.Create(Self);
  FSnapShot.SetScreenSize(FWidth, FHeight);

  FSimpleRepeater := TSimpleRepeater.Create(on_Repeat);
end;

destructor TCamEncoder.Destroy;
begin
  Stop;

  FSimpleRepeater.Terminate(250);

  FreeAndNil(FCS_ScreenSize);
  FreeAndNil(FBitmapEncoder);
  FreeAndNil(FSnapShot);
  FreeAndNil(FEncoder);

  inherited;
end;

function TCamEncoder.DeviceCount: integer;
begin
  Result := FSnapShot.DeviceCount;
end;

function TCamEncoder.GetBitmap(ABitmap: TBitmap): boolean;
begin
  Result := FActive and FSnapShot.GetBitmap(ABitmap);
end;

function TCamEncoder.GetHeight: integer;
begin
  Result := FHeight;
end;

function TCamEncoder.GetOnNewData: TNewDataEvent;
begin
  Result := FEncoder.OnNewData;
end;

function TCamEncoder.GetWidth: integer;
begin
  Result := FWidth;
end;

function TCamEncoder.IsActive: boolean;
begin
  Result := FActive;
end;

procedure TCamEncoder.on_Repeat(Sender: TObject);
var
  SnapShotResult : boolean;
begin
  while not FSimpleRepeater.Terminated do begin
    if not FActive then begin
      Sleep(10);
      Continue;
    end;

    FCS_ScreenSize.Enter;
    try
      if (FEncoder.Width <> FWidth) or (FEncoder.Height <> FHeight) then begin
        FEncoder.Close;

        FBitmapEncoder.Width := FWidth;
        FBitmapEncoder.Height := FHeight;

        FEncoder.Width := FWidth;
        FEncoder.Height := FHeight;
      end;
    finally
      FCS_ScreenSize.Leave;
    end;

    try
      if not FEncoder.Opened then FEncoder.Open;
    except
    end;

    if FEncoder.Opened then begin
      SnapShotResult := FSnapShot.GetSnapShot(FBitmapEncoder);
      if SnapShotResult then FEncoder.Encode(FBitmapEncoder);
    end;

    Sleep(10);
  end;

  FEncoder.Close;
end;

procedure TCamEncoder.SetOnNewData(const Value: TNewDataEvent);
begin
  FEncoder.OnNewData := Value;
end;

procedure TCamEncoder.SetScreenSize(AWidth, AHeight: integer);
begin
  FSnapShot.SetScreenSize(AWidth, AHeight);

  FCS_ScreenSize.Enter;
  try
    FWidth := AWidth;
    FHeight := AHeight;
  finally
    FCS_ScreenSize.Leave;
  end;
end;

procedure TCamEncoder.Start;
begin
  if FActive then begin
    OutputDebugString('TCamEncoder.Start: TCamEncoder has been started already!');
    Exit;
  end;

  FActive := true;
  FSnapShot.Start;
end;

procedure TCamEncoder.Stop;
begin
  FActive := false;
  FSnapShot.Stop;
end;

end.
