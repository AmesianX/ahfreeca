unit _fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _frChat, Vcl.ExtCtrls, _frVoice,
  _frCamPreview, _frScreen;

type
  TfmMain = class(TForm)
    frChat: TfrChat;
    Panel1: TPanel;
    frVoice: TfrVoice;
    frCamPreview: TfrCamPreview;
    frScreen: TfrScreen;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

uses
  Core, ClientSocket;

{$R *.dfm}

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TCore.Obj.Finalize;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TCore.Obj.Initialize;

  if not TClientSocket.Obj.Connect then begin
    MessageDlg( '서버에 접속 할 수가 없습니다.', mtError, [mbOK], 0 );
    Application.Terminate;
    Exit;
  end;
end;

end.
