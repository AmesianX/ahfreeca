unit VideoCapture;

interface

uses
  Config,
  VideoSource,
  VideoSource.Desktop,
  VideoSource.Cam,
  DebugTools, RyuLibBase, RyuGraphics, TickCounter, WindowRect,
  Windows, SysUtils, Classes, Graphics, ExtCtrls, SyncObjs;

type
  IVideoCapture = interface
    ['{E0657972-BF90-46E6-9F97-EFECC5D06D01}']

    function GetVideoSourceType: TVideoSourceType;
    procedure SetVideoSourceType(const Value: TVideoSourceType);
    property VideoSourceType : TVideoSourceType read GetVideoSourceType write SetVideoSourceType;

    function GetDestopRect: IWindowRect;
    procedure SetDestopRect(const Value: IWindowRect);
    property DestopRect : IWindowRect read GetDestopRect write SetDestopRect;
  end;

  TVideoCapture = class (TInterfaceBase, IVideoCapture)
  private  // implementation of IVideoCapture
    function GetVideoSourceType: TVideoSourceType;
    procedure SetVideoSourceType(const Value: TVideoSourceType);
    function GetDestopRect: IWindowRect;
    procedure SetDestopRect(const Value: IWindowRect);
  private
    FCS : TCriticalSection;
    FBitmap : TBitmap;
    FInterval : integer;
    FTickCounter : TTickCounter;
    FIsBitmapReady : boolean;
    FIsEncoderDelayed : boolean;
    procedure do_Capture;
  private
    FVideoSource : TVideoSource;
    FVideoSourceDesktop : TDesktop;
    FVideoSourceCam : TCam;
  private
    FTimer : TTimer;
    procedure on_Timer(Sender:TObject);
  private
    FFramesPerSecond: integer;
    FVideoSourceType: TVideoSourceType;
    procedure SetFramesPerSecond(const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    {*
      화면을 캡쳐해서 ABitmap으로 옮긴다.
      @param ABitmap
      @AIsEncoderDelayed 캡쳐 된 화면이 사용되지 못하고 버려진 것이 있다.  (캡쳐보다, GetBitmap 횟수가 느린 경우)
    }
    function GetBitmap(ABitmap:TBitmap; var AIsEncoderDelayed:boolean):boolean;
  public
    property VideoSourceType : TVideoSourceType read GetVideoSourceType write SetVideoSourceType;

    /// Desktop에서 어디를 캡쳐 할 것인 가?  VideoSourceType = vsDesktop 인 경우에만 사용된다.
    property DestopRect : IWindowRect read GetDestopRect write SetDestopRect;

    property FramesPerSecond : integer read FFramesPerSecond write SetFramesPerSecond;
  end;

implementation

{ TVideoCapture }

constructor TVideoCapture.Create;
begin
  inherited Create;

  FVideoSourceDesktop := TDesktop.Create;
  FVideoSourceCam := TCam.Create;

  FVideoSource := FVideoSourceDesktop;
  FVideoSourceType := vsDesktop;

  FFramesPerSecond := 15;
  FInterval := 1000 div FFramesPerSecond;

  FIsBitmapReady := false;
  FIsEncoderDelayed := false;

  FCS := TCriticalSection.Create;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;
  FBitmap.Canvas.Brush.Color := clBlack;
  FBitmap.Width  := VIDEO_BIG_WIDTH;
  FBitmap.Height := VIDEO_BIG_HEIGHT;

  FTickCounter := TTickCounter.Create;

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 5;
  FTimer.Enabled := true;
end;

destructor TVideoCapture.Destroy;
begin
  Stop;

  FreeAndNil(FCS);
  FreeAndNil(FVideoSourceDesktop);
  FreeAndNil(FVideoSourceCam);
  FreeAndNil(FBitmap);
  FreeAndNil(FTimer);

  inherited;
end;

procedure TVideoCapture.do_Capture;
begin
  FCS.Acquire;
  try
    if not Assigned(FTimer.OnTimer) then Exit;

    if not FVideoSource.GetBitmap(FBitmap) then Exit;

    // 이전 캡쳐가 아직 사용되고 있지 않다.
    if FIsBitmapReady then FIsEncoderDelayed := true
    else FIsEncoderDelayed := false;

    FIsBitmapReady := true;
  finally
    FCS.Release;
  end;
end;

function TVideoCapture.GetBitmap(ABitmap: TBitmap; var AIsEncoderDelayed: boolean): boolean;
begin
  Result := false;
  AIsEncoderDelayed := false;

  FCS.Acquire;
  try
    if not Assigned(FTimer.OnTimer) then Exit;

    AssignBitmap( FBitmap, ABitmap );

    AIsEncoderDelayed := FIsEncoderDelayed;
    FIsBitmapReady := false;

    Result := true;
  finally
    FCS.Release;
  end;
end;

function TVideoCapture.GetDestopRect: IWindowRect;
begin
  Result := FVideoSourceDesktop.CaptureRect;
end;

function TVideoCapture.GetVideoSourceType: TVideoSourceType;
begin
  Result := FVideoSourceType;
end;

procedure TVideoCapture.on_Timer(Sender: TObject);
begin
  FTimer.Enabled := false;
  try
    if FTickCounter.GetDuration < FInterval then Exit;

    {$IFDEF DEBUG}
//    Trace( Format('TVideoSource.on_Timer - FTickCounter.GetDuration: %d', [FTickCounter.GetDuration]) );
    {$ENDIF}

    FTickCounter.Start;

    do_Capture;
  finally
    FTimer.Enabled := true;
  end;
end;

procedure TVideoCapture.SetDestopRect(const Value: IWindowRect);
begin
  FVideoSourceDesktop.CaptureRect := Value;
end;

procedure TVideoCapture.SetFramesPerSecond(const Value: integer);
var
  iInterval : integer;
begin
  FFramesPerSecond := Value;

  iInterval := 1000 div FFramesPerSecond;
  FInterval := iInterval;
end;

procedure TVideoCapture.SetVideoSourceType(const Value: TVideoSourceType);
begin
  FCS.Acquire;
  try
    FVideoSourceType := Value;

    case Value of
      vsDesktop: FVideoSource := FVideoSourceDesktop;
      vsCam: FVideoSource := FVideoSourceCam;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TVideoCapture.Start;
begin
  FIsBitmapReady := false;
  FIsEncoderDelayed := false;

  FCS.Acquire;
  try
    FTickCounter.Start;
    FTimer.OnTimer := on_Timer;
  finally
    FCS.Release;
  end;
end;

procedure TVideoCapture.Stop;
begin
  FCS.Acquire;
  try
    FTimer.OnTimer := nil;
  finally
    FCS.Release;
  end;
end;

end.


