unit _frCamScreen;

interface

uses
  Config,
  FrameBase, ValueList, glCanvas, RyuGraphics,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TfrCamScreen = class(TFrame, IFrameBase)
    Timer: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  private
    FglCanvas : TglCanvas;
    procedure do_Resize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Core, VideoReceiver;

{$R *.dfm}

{ TfrCamScreen }

procedure TfrCamScreen.AfterShow;
begin

end;

procedure TfrCamScreen.BeforeShow;
begin

end;

procedure TfrCamScreen.BeforeClose;
begin

end;

constructor TfrCamScreen.Create(AOwner: TComponent);
begin
  inherited;

  DoubleBuffered := true;
  ControlStyle := ControlStyle + [csOpaque];

  FglCanvas := TglCanvas.Create(Self);
  FglCanvas.Parent := Self;

  do_Resize;

  TCore.Obj.View.Add(Self);
end;

destructor TfrCamScreen.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  FreeAndNil(FglCanvas);

  inherited;
end;

procedure TfrCamScreen.do_Resize;
var
  ptResult : TPoint;
begin
  // 비율에 맞춰서 화면 크기 만큼 glCanvas의 크기를 조절한다.  (사방 3 픽셀 여유를 둠)
  ptResult :=
    RatioSize(
      Point(TCore.Obj.Option.CamWidth-6, TCore.Obj.Option.CamHeight-6),
      Point(Width, Height)
    );
  FglCanvas.Width  := ptResult.X;
  FglCanvas.Height := ptResult.Y;

  // 화면 가운데로 이동한다.
  FglCanvas.Left := (Width  div 2) - (FglCanvas.Width  div 2);
  FglCanvas.Top  := (Height div 2) - (FglCanvas.Height div 2);
end;

procedure TfrCamScreen.FrameResize(Sender: TObject);
begin
  do_Resize;
end;

procedure TfrCamScreen.TimerTimer(Sender: TObject);
var
  Bitmap : TBitmap;
begin
  Timer.Enabled := false;
  try
    if not TVideoReceiver.Obj.IsBitmapChanged then Exit;

    Bitmap := TBitmap.Create;
    try
      if TVideoReceiver.Obj.GetBitmap(Bitmap) then FglCanvas.Draw( Bitmap );
    finally
      Bitmap.Free;
    end;
  finally
    Timer.Enabled := true;
  end;
end;

end.