unit _frCamPreview;

interface

uses
  Config, EasyCam,
  FrameBase, ValueList, glCanvas, RyuGraphics,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls, BitmapTile;

type
  TfrCamPreview = class(TFrame, IFrameBase)
    Timer: TTimer;
    btCamOn: TButton;
    plClient: TPanel;
    BitmapTile1: TBitmapTile;
    btCamOff: TButton;
    procedure TimerTimer(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btCamOnClick(Sender: TObject);
    procedure btCamOffClick(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  private
    FEasyCam : TEasyCam;
    procedure do_Resize_glCanvas;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Core, VideoSender;

{$R *.dfm}

{ TfrCamPreview }

procedure TfrCamPreview.AfterShow;
begin

end;

procedure TfrCamPreview.BeforeShow;
begin

end;

procedure TfrCamPreview.btCamOffClick(Sender: TObject);
begin
  FEasyCam.Close;
end;

procedure TfrCamPreview.btCamOnClick(Sender: TObject);
begin
  FEasyCam.Open( TCore.Obj.Option.CamWidth, TCore.Obj.Option.CamHeight);
end;

procedure TfrCamPreview.BeforeClose;
begin

end;

constructor TfrCamPreview.Create(AOwner: TComponent);
begin
  inherited;

  DoubleBuffered := true;
  ControlStyle := ControlStyle + [csOpaque];

  TCore.Obj.View.Add(Self);

  FEasyCam := TEasyCam.Create(Self);
  FEasyCam.Parent := plClient;

  do_Resize_glCanvas;
end;

destructor TfrCamPreview.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  FreeAndNil(FEasyCam);

  inherited;
end;

procedure TfrCamPreview.do_Resize_glCanvas;
var
  ptResult : TPoint;
begin
  // Cam 화면의 비율에 맞춰서 plClient 크기 만큼 glCanvas의 크기를 조절한다.  (사방 3 픽셀 여유를 둠)
  ptResult :=
    RatioSize(
      Point(TCore.Obj.Option.CamWidth-6, TCore.Obj.Option.CamHeight-6),
      Point(plClient.Width, plClient.Height)
    );
  FEasyCam.Width  := ptResult.X;
  FEasyCam.Height := ptResult.Y;

  // plClient 가운데로 이동한다.
  FEasyCam.Left := (plClient.Width  div 2) - (FEasyCam.Width  div 2);
  FEasyCam.Top  := (plClient.Height div 2) - (FEasyCam.Height div 2);
end;

procedure TfrCamPreview.FrameResize(Sender: TObject);
begin
  do_Resize_glCanvas;
end;

procedure TfrCamPreview.TimerTimer(Sender: TObject);
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    if FEasyCam.IsActive and FEasyCam.GetBitmap(Bitmap) then begin
      TVideoSender.Obj.DataIn( Bitmap );
    end;
  finally
    Bitmap.Free;
  end;
end;

end.