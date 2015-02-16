unit SelectColorDialog;

interface

uses
  RyuLibBase, RyuGraphics,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TfmSelectColorDialog = class(TForm)
    ImageFull: TImage;
    Shape: TShape;
    ImageHalf: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeMouseEnter(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);
  private
    FPngImage : TPngImage;
    FBitmap : TBitmap;
    FBitmapInnerCircle : TBitmap;
    FOrigonalColor : TColor;
    FSelectingColor : TColor;
    FSelectedColor : TColor;
    FOnSelected : TIntegerEvent;
    procedure init(AFullScreen:boolean);
  public
  end;

procedure ShowSelectColorDialog(AX,AY:integer; AOrogonalColor:TColor; OnSelected:TIntegerEvent; AFullScreen:boolean=true);

implementation

var
  fmSelectColorDialog : TfmSelectColorDialog = nil;

procedure ShowSelectColorDialog(AX,AY:integer; AOrogonalColor:TColor; OnSelected:TIntegerEvent; AFullScreen:boolean);
begin
  fmSelectColorDialog := TfmSelectColorDialog.Create(nil);
  fmSelectColorDialog.init( AFullScreen );
  fmSelectColorDialog.Left := AX - (fmSelectColorDialog.Width  div 2);
  fmSelectColorDialog.Top  := AY - (fmSelectColorDialog.Height div 2);
  fmSelectColorDialog.FOrigonalColor := AOrogonalColor;
  fmSelectColorDialog.FSelectedColor := AOrogonalColor;
  fmSelectColorDialog.FOnSelected := OnSelected;
  fmSelectColorDialog.Show;
end;

{$R *.dfm}

procedure TfmSelectColorDialog.FormClick(Sender: TObject);
begin
  FSelectedColor := FSelectingColor;
  Close;
end;

procedure TfmSelectColorDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fmSelectColorDialog := nil;
  Action := caFree;

  if Assigned(FOnSelected) then FOnSelected(Self, FSelectedColor);
end;

procedure TfmSelectColorDialog.FormCreate(Sender: TObject);
begin
  FOnSelected := nil;

  SetWindowLong( Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED );

  FBitmap := TBitmap.Create;

  FBitmapInnerCircle := TBitmap.Create;
  FBitmapInnerCircle.PixelFormat := pf32bit;
  FBitmapInnerCircle.Width  := 14;
  FBitmapInnerCircle.Height := 14;
end;

procedure TfmSelectColorDialog.FormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TfmSelectColorDialog.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  FSelectingColor := FBitmap.Canvas.Pixels[X, Y];
  if FSelectingColor = clWhite then FSelectingColor := FOrigonalColor;

  Shape.Brush.Color := FSelectingColor;

  FBitmapInnerCircle.Canvas.Pen.Color := FSelectingColor;
  FBitmapInnerCircle.Canvas.Brush.Color := FSelectingColor;
  FBitmapInnerCircle.Canvas.Ellipse( 0, 0, FBitmapInnerCircle.Width, FBitmapInnerCircle.Height );

  SetAlpha( FBitmapInnerCircle, 255 );

  FBitmap.Canvas.Draw(
    (FBitmap.Width  div 2) - (FBitmapInnerCircle.Width  div 2),
    (FBitmap.Height div 2) - (FBitmapInnerCircle.Height div 2),
    FBitmapInnerCircle
  );

  UpdateLayeredControl( Self, FBitmap );
end;

procedure TfmSelectColorDialog.FormShow(Sender: TObject);
begin
  Shape.Brush.Color := FOrigonalColor;
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
end;

procedure TfmSelectColorDialog.init(AFullScreen: boolean);
begin
  if AFullScreen then FPngImage := TPngImage(ImageFull.Picture.Graphic)
  else FPngImage := TPngImage(ImageHalf.Picture.Graphic);

  PngToBitmap( FPngImage, FBitmap );
  UpdateLayeredControl( Self, FBitmap );
end;

procedure TfmSelectColorDialog.ShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSelectedColor := FOrigonalColor;
  Close;
end;

procedure TfmSelectColorDialog.ShapeMouseEnter(Sender: TObject);
begin
  Shape.Brush.Color := FOrigonalColor;
end;

end.
