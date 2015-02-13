program Sender;

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
  _frLoginLayout in '..\..\Lib\Frames\_frLoginLayout.pas' {frLoginLayout: TFrame},
  _fmMain.frLoginedLayout in '_fmMain.frLoginedLayout.pas' {frLoginedLayout: TFrame},
  ClientUnit in '..\..\Lib\Core\ClientUnit.pas',
  ClientUnit.TextClient in '..\..\Lib\Core\ClientUnit.TextClient.pas',
  ClientUnit.VideoClient in '..\..\Lib\Core\ClientUnit.VideoClient.pas',
  ClientUnit.VoiceClient in '..\..\Lib\Core\ClientUnit.VoiceClient.pas',
  Option in '..\..\Lib\Core\Option.pas',
  View in '..\..\Lib\Core\View.pas',
  _frUserList in '..\..\Lib\Frames\_frUserList.pas' {frUserList: TFrame},
  CoreInterface in '..\..\Lib\Core\CoreInterface.pas',
  _frChat in '..\..\Lib\Frames\_frChat.pas' {frChat: TFrame},
  SelectColorDialog in '..\..\Lib\Dialogs\SelectColorDialog.pas' {fmSelectColorDialog},
  Frames in 'Frames.pas',
  ClientUnit.TextClient.UserList in '..\..\Lib\Core\ClientUnit.TextClient.UserList.pas',
  PacketReader in '..\..\Lib\supersocket\PacketReader.pas',
  SuperClient in '..\..\Lib\supersocket\SuperClient.pas',
  SuperClient.Repeater in '..\..\Lib\supersocket\SuperClient.Repeater.pas',
  SuperClient.Socket in '..\..\Lib\supersocket\SuperClient.Socket.pas',
  SuperSocketUtils in '..\..\Lib\supersocket\SuperSocketUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
