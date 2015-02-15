program Client;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in '..\..\Lib\Config.pas',
  Protocol in '..\..\Lib\Protocol.pas',
  ProtocolText in '..\..\Lib\ProtocolText.pas',
  ProtocolVideo in '..\..\Lib\ProtocolVideo.pas',
  ProtocolVoice in '..\..\Lib\ProtocolVoice.pas',
  UserLevel in '..\..\Lib\UserLevel.pas',
  Core in 'Core\Core.pas',
  _fmMain.frLoginedLayout in '_fmMain.frLoginedLayout.pas' {frLoginedLayout: TFrame},
  PacketReader in '..\..\Lib\supersocket\PacketReader.pas',
  SuperClient in '..\..\Lib\supersocket\SuperClient.pas',
  SuperClient.Repeater in '..\..\Lib\supersocket\SuperClient.Repeater.pas',
  SuperClient.Socket in '..\..\Lib\supersocket\SuperClient.Socket.pas',
  SuperSocketUtils in '..\..\Lib\supersocket\SuperSocketUtils.pas',
  ClientUnit in 'Core\ClientUnit.pas',
  ClientUnit.TextClient in 'Core\ClientUnit.TextClient.pas',
  ClientUnit.TextClient.UserList in 'Core\ClientUnit.TextClient.UserList.pas',
  ClientUnit.VideoClient in 'Core\ClientUnit.VideoClient.pas',
  ClientUnit.VoiceClient in 'Core\ClientUnit.VoiceClient.pas',
  CoreInterface in 'Core\CoreInterface.pas',
  Option in 'Core\Option.pas',
  View in 'Core\View.pas',
  SelectColorDialog in 'Dialogs\SelectColorDialog.pas' {fmSelectColorDialog},
  _frChat in 'Frames\_frChat.pas' {frChat: TFrame},
  _frLoginLayout in 'Frames\_frLoginLayout.pas' {frLoginLayout: TFrame},
  _frUserList in 'Frames\_frUserList.pas' {frUserList: TFrame},
  Frames in 'Frames\Frames.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
