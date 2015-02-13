program SingleServer;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in '..\..\Lib\Config.pas',
  Protocol in '..\..\Lib\Protocol.pas',
  Option in 'Option.pas',
  ServerUnit in 'ServerUnit.pas',
  ServerUnit.TextServer in 'ServerUnit.TextServer.pas',
  ServerUnit.VoiceServer in 'ServerUnit.VoiceServer.pas',
  ServerUnit.VideoServer in 'ServerUnit.VideoServer.pas',
  ProtocolText in '..\..\Lib\ProtocolText.pas',
  ProtocolVoice in '..\..\Lib\ProtocolVoice.pas',
  ProtocolVideo in '..\..\Lib\ProtocolVideo.pas',
  UserLevel in '..\..\Lib\UserLevel.pas',
  Database in 'Database.pas',
  UserList in 'UserList.pas',
  Connection in '..\..\Lib\supersocket\Connection.pas',
  IOCP_Utils in '..\..\Lib\supersocket\IOCP_Utils.pas',
  PacketReader in '..\..\Lib\supersocket\PacketReader.pas',
  SuperServer in '..\..\Lib\supersocket\SuperServer.pas',
  SuperSocketUtils in '..\..\Lib\supersocket\SuperSocketUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
