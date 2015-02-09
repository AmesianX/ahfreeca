program VideoChatServer;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in 'Config.pas',
  Protocol in 'Protocol.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
