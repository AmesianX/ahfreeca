unit _frChat;

interface

uses
  FrameBase, ValueList,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrChat = class(TFrame, IFrameBase)
    moMsgIn: TMemo;
    edMsgOut: TEdit;
    procedure edMsgOutKeyPress(Sender: TObject; var Key: Char);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_Chat(AParams:TValueList);
  end;

implementation

uses
  Core, ClientSocket;

{$R *.dfm}

{ TfrChat }

procedure TfrChat.AfterShow;
begin

end;

procedure TfrChat.BeforeShow;
begin

end;

procedure TfrChat.BeforeClose;
begin

end;

constructor TfrChat.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrChat.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrChat.edMsgOutKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    moMsgIn.Lines.Add( edMsgOut.Text );
    TClientSocket.Obj.SendChat( edMsgOut.Text );
    edMsgOut.Text := '';
  end;
end;

procedure TfrChat.rp_Chat(AParams: TValueList);
begin
  moMsgIn.Lines.Add( AParams.Values['Msg'] );
end;

end.