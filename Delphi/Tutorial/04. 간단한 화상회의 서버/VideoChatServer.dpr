program VideoChatServer;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  Config in 'Config.pas',
  Protocol in 'Protocol.pas',
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
