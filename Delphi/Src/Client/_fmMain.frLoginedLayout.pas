unit _fmMain.frLoginedLayout;

interface

uses
  FrameBase, ValueList, RyuGraphics, Para,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, _frChat, _frUserList, _frControlBoxSender, _frControlBoxReceiver,
  _frCamPreview, _frCamScreen;

type
  TfrLoginedLayout = class(TFrame, IFrameBase)
    plRight: TPanel;
    plControlBox: TPanel;
    Splitter1: TSplitter;
    frChat: TfrChat;
    frUserList: TfrUserList;
    frControlBoxSender: TfrControlBoxSender;
    frControlBoxReceiver: TfrControlBoxReceiver;
    frCamPreview: TfrCamPreview;
    frCamScreen: TfrCamScreen;
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

/// 미리 객체를 생성하여 View 메시지를 수신 할 수 있는 상태를 만든다.
procedure Prepare(ATarget:TForm);

procedure SetLayout(ATarget:TForm);

implementation

uses
  Core;

var
  frLoginedLayout : TfrLoginedLayout = nil;

procedure Prepare(ATarget:TForm);
begin
  if frLoginedLayout = nil then frLoginedLayout := TfrLoginedLayout.Create(ATarget);
end;

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

  frCamPreview.Visible := FindSwitchName('IsSender');
  frCamScreen.Visible  := not FindSwitchName('IsSender');

  TCore.Obj.View.Add(Self);
end;

destructor TfrLoginedLayout.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

end.