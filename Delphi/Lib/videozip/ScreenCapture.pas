unit ScreenCapture;

interface

uses
  Windows, SysUtils, Classes, Graphics;

procedure ScreenCaptureToBitmap(ARect:TRect; ABitmap:TBitmap);

implementation

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

end.
