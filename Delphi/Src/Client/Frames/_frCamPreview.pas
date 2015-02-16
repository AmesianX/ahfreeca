unit _frCamPreview;

interface

uses
  Config, EasyCam,
  FrameBase, ValueList,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TfrCamPreview = class(TFrame, IFrameBase)
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  private
    FEasyCam : TEasyCam;
    procedure on_FEasyCam_Click(Sender:TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Core;

{$R *.dfm}

{ TfrCamPreview }

procedure TfrCamPreview.AfterShow;
begin

end;

procedure TfrCamPreview.BeforeShow;
begin

end;

procedure TfrCamPreview.BeforeClose;
begin

end;

constructor TfrCamPreview.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);

  FEasyCam := TEasyCam.Create(Self);
  FEasyCam.Parent := Self;
  FEasyCam.Align := alClient;
  FEasyCam.OnClick := on_FEasyCam_Click;
end;

destructor TfrCamPreview.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  FreeAndNil(FEasyCam);

  inherited;
end;

procedure TfrCamPreview.on_FEasyCam_Click(Sender: TObject);
begin
  if not FEasyCam.IsActive then FEasyCam.Open( VIDEO_WIDTH, VIDEO_HEIGHT )
  else FEasyCam.Close;
end;

procedure TfrCamPreview.TimerTimer(Sender: TObject);
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    if FEasyCam.IsActive and FEasyCam.GetBitmap(Bitmap) then begin
//      TVideoIn.Obj.DataIn( Bitmap );
    end;
  finally
    Bitmap.Free;
  end;
end;

end.