program VideoChatClient02;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  ClientSocket in 'Core\ClientSocket.pas',
  Core in 'Core\Core.pas',
  View in 'Core\View.pas',
  Option in 'Core\Option.pas',
  _frChat in '_frChat.pas' {frChat: TFrame},
  _frVoice in '_frVoice.pas' {frVoice: TFrame},
  VoiceOut in 'Core\VoiceOut.pas',
  VoiceIn in 'Core\VoiceIn.pas',
  Config in 'Config.pas',
  Protocol in 'Protocol.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
