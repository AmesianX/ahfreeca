unit _fmMain.frLoginedLayout;

interface

uses
  FrameBase, ValueList, RyuGraphics, Para,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, _frChat, _frUserList, _frControlBoxSender, _frControlBoxReceiver;

type
  TfrLoginedLayout = class(TFrame, IFrameBase)
    plRight: TPanel;
    plControlBox: TPanel;
    Splitter1: TSplitter;
    frChat: TfrChat;
    frUserList: TfrUserList;
    frControlBoxSender: TfrControlBoxSender;
    frControlBoxReceiver: TfrControlBoxReceiver;
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure SetLayout(ATarget:TForm);

implementation

uses
  Core;

var
  frLoginedLayout : TfrLoginedLayout = nil;

procedure SetLayout(ATarget:TForm);
var
  Rect : TRect;
begin
  ATarget.BorderStyle := bsSizeable;

  // TODO: 기존 사용을 저장해서 불러오기
  ATarget.Width := 1024;
  ATarget.Height := 768;

  Rect := FindMonitorRect(ATarget.Left, ATarget.Top);
  ATarget.Left := (Rect.Width  div 2) - (ATarget.Width  div 2);
  ATarget.Top  := (Rect.Height div 2) - (ATarget.Height div 2);

  if frLoginedLayout = nil then frLoginedLayout := TfrLoginedLayout.Create(ATarget);

  frLoginedLayout.Align := alClient;
  frLoginedLayout.Parent := ATarget;
end;

{$R *.dfm}

{ TfrLoginedLayout }

procedure TfrLoginedLayout.AfterShow;
begin

end;

procedure TfrLoginedLayout.BeforeShow;
begin

end;

procedure TfrLoginedLayout.BeforeClose;
begin

end;

constructor TfrLoginedLayout.Create(AOwner: TComponent);
begin
  inherited;

  frControlBoxSender.Visible   := FindSwitchName('IsSender');
  frControlBoxReceiver.Visible := not FindSwitchName('IsSender');

  TCore.Obj.View.Add(Self);
end;

destructor TfrLoginedLayout.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

end.