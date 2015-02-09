unit _frScreen;

interface

uses
  FrameBase, ValueList,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TfrScreen = class(TFrame, IFrameBase)
    Image: TImage;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Core, VideoOut;

{$R *.dfm}

{ TfrScreen }

procedure TfrScreen.AfterShow;
begin

end;

procedure TfrScreen.BeforeShow;
begin

end;

procedure TfrScreen.BeforeClose;
begin

end;

constructor TfrScreen.Create(AOwner: TComponent);
begin
  inherited;

  ControlStyle := ControlStyle + [csOpaque];
  DoubleBuffered := true;

  TCore.Obj.View.Add(Self);
end;

destructor TfrScreen.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrScreen.TimerTimer(Sender: TObject);
begin
  if TVideoOut.Obj.GetBitmap(Image.Picture.Bitmap) then Image.Repaint;
end;

end.