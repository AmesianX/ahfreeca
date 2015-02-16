unit _frLoginLayout;

interface

uses
  FrameBase, ValueList, RyuGraphics,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrLoginLayout = class(TFrame, IFrameBase)
    btClose: TButton;
    plMsg: TPanel;
    procedure btCloseClick(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_ErVersion(AParams:TValueList);
    procedure rp_ErLogin(AParams:TValueList);
  end;

procedure SetLayout(ATarget:TForm);

implementation

uses
  Core;

var
  frLoginLayout : TfrLoginLayout = nil;

procedure SetLayout(ATarget:TForm);
var
  Rect : TRect;
begin
  ATarget.BorderStyle := bsNone;
  ATarget.Width := 320;
  ATarget.Height := 240;

  Rect := FindMonitorRect(ATarget.Left, ATarget.Top);
  ATarget.Left := (Rect.Width  div 2) - (ATarget.Width  div 2);
  ATarget.Top  := (Rect.Height div 2) - (ATarget.Height div 2);

  if frLoginLayout = nil then frLoginLayout := TfrLoginLayout.Create(ATarget);

  frLoginLayout.Align := alClient;
  frLoginLayout.Parent := ATarget;
end;

{$R *.dfm}

{ TfrLoginLayout }

procedure TfrLoginLayout.AfterShow;
begin

end;

procedure TfrLoginLayout.BeforeShow;
begin

end;

procedure TfrLoginLayout.btCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrLoginLayout.BeforeClose;
begin

end;

constructor TfrLoginLayout.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrLoginLayout.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrLoginLayout.rp_ErLogin(AParams: TValueList);
begin
  TCore.Obj.Finalize;
  plMsg.Caption := AParams.Values['Msg'];
end;

procedure TfrLoginLayout.rp_ErVersion(AParams: TValueList);
begin
  TCore.Obj.Finalize;
  plMsg.Caption := '프로그램을 업데이트 해주시기 바랍니다.';
end;

end.
