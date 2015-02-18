unit _frCamPreview;

interface

uses
  Config, EasyCam,
  FrameBase, ValueList, RyuGraphics,
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
    cbResolution: TComboBox;
    procedure TimerTimer(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btCamOnClick(Sender: TObject);
    procedure btCamOffClick(Sender: TObject);
    procedure cbResolutionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbResolutionKeyPress(Sender: TObject; var Key: Char);
    procedure cbResolutionChange(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  private
    FEasyCam : TEasyCam;
    procedure do_Resize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_StartShow(Aparams:TValueList);
    procedure rp_StopShow(Aparams:TValueList);
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
  cbResolution.Enabled := (not TCore.Obj.IsShowStarted) and (not FEasyCam.IsActive);
end;

procedure TfrCamPreview.btCamOnClick(Sender: TObject);
begin
  cbResolution.Enabled := false;
  FEasyCam.Open( TCore.Obj.Option.CamWidth, TCore.Obj.Option.CamHeight);
end;

procedure TfrCamPreview.BeforeClose;
begin

end;

procedure TfrCamPreview.cbResolutionChange(Sender: TObject);
var
  iWidth, iHeight : integer;
begin
  case cbResolution.ItemIndex of
    0 : begin iWidth :=  320; iHeight := 240; end;
    1 : begin iWidth :=  640; iHeight := 480; end;
    2 : begin iWidth := 1024; iHeight := 768; end;
    3 : begin iWidth := 1280; iHeight := 720; end;
  end;

  TCore.Obj.Option.CamWidth  := iWidth;
  TCore.Obj.Option.CamHeight := iHeight;
end;

procedure TfrCamPreview.cbResolutionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
end;

procedure TfrCamPreview.cbResolutionKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

constructor TfrCamPreview.Create(AOwner: TComponent);
begin
  inherited;

  case TCore.Obj.Option.CamWidth of
     640 : cbResolution.ItemIndex := 1;
    1024 : cbResolution.ItemIndex := 2;
    1280 : cbResolution.ItemIndex := 3;
    else cbResolution.ItemIndex := 0;
  end;

  DoubleBuffered := true;
  ControlStyle := ControlStyle + [csOpaque];

  TCore.Obj.View.Add(Self);

  FEasyCam := TEasyCam.Create(Self);
  FEasyCam.Parent := plClient;

  do_Resize;
end;

destructor TfrCamPreview.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  FreeAndNil(FEasyCam);

  inherited;
end;

procedure TfrCamPreview.do_Resize;
var
  ptResult : TPoint;
begin
  // 비율에 맞춰서 화면 크기 만큼 glCanvas의 크기를 조절한다.  (사방 3 픽셀 여유를 둠)
  ptResult :=
    RatioSize(
      Point(TCore.Obj.Option.CamWidth-6, TCore.Obj.Option.CamHeight-6),
      Point(plClient.Width, plClient.Height)
    );
  FEasyCam.Width  := ptResult.X;
  FEasyCam.Height := ptResult.Y;

  // 화면 가운데로 이동한다.
  FEasyCam.Left := (plClient.Width  div 2) - (FEasyCam.Width  div 2);
  FEasyCam.Top  := (plClient.Height div 2) - (FEasyCam.Height div 2);
end;

procedure TfrCamPreview.FrameResize(Sender: TObject);
begin
  do_Resize;
end;

procedure TfrCamPreview.rp_StartShow(Aparams: TValueList);
begin
  cbResolution.Enabled := false;
end;

procedure TfrCamPreview.rp_StopShow(Aparams: TValueList);
begin
  cbResolution.Enabled := (not TCore.Obj.IsShowStarted) and (not FEasyCam.IsActive);
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