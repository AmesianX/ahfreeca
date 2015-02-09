unit VideoSource.Desktop;

interface

uses
  Config,
  VideoSource, WindowRect,
  Windows, SysUtils, Classes, Graphics;

type
  TDesktop = class (TVideoSource)
  private
    FCaptureRect: IWindowRect;
    procedure SetCaptureRect(const Value: IWindowRect);
  public
    constructor Create;

    function GetBitmap(ABitmap:TBitmap):boolean; override;
  public
    property CaptureRect : IWindowRect read FCaptureRect write SetCaptureRect;
  end;

implementation

{ TDesktop }

constructor TDesktop.Create;
begin
  inherited;

  FCaptureRect := nil;
end;

procedure ScreenCaptureToBitmap(ARect:TRect; ABitmap:TBitmap);
const
  CAPTUREBLT = $40000000;
var
  dc: HDC;
  DRect : TRect;
  DeskCanvas : TCanvas;
begin
  dc := GetDC(0);
  if dc = 0 then Exit;

  DRect := Rect( 0, 0, ARect.Width, ARect.Height );

  DeskCanvas := TCanvas.Create;
  try
    DeskCanvas.Handle := dc;

    ABitmap.Width  := ARect.Width;
    ABitmap.Height := ARect.Height;

    ABitmap.Canvas.CopyMode := SRCCOPY or CAPTUREBLT;

    ABitmap.Canvas.CopyRect(DRect, DeskCanvas, ARect);
  finally
    ReleaseDC(0, dc);
    DeskCanvas.Free;
  end;
end;

function TDesktop.GetBitmap(ABitmap: TBitmap): boolean;
var
  Rect : TRect;
begin
  Result := false;

  if FCaptureRect = nil then Exit;

  Rect.Left := FCaptureRect.GetWindowLeft;
  Rect.Top  := FCaptureRect.GetWindowTop;

  Rect.Width  := FCaptureRect.GetWindowWidth;
  Rect.Height := FCaptureRect.GetWindowHeight;

  try
    ScreenCaptureToBitmap( Rect, ABitmap );
    Result := true;
  except
    // TODO:
  end;
end;

procedure TDesktop.SetCaptureRect(const Value: IWindowRect);
begin
  FCaptureRect := Value;
end;

end.


