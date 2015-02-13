program VideoChatClient01;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  ClientSocket in 'Core\ClientSocket.pas',
  Core in 'Core\Core.pas',
  View in 'Core\View.pas',
  Option in 'Core\Option.pas',
  _frChat in '_frChat.pas' {frChat: TFrame},
  Config in 'Config.pas',
  Protocol in 'Protocol.pas',
  SuperClient in '..\..\Lib\supersocket\SuperClient.pas',
  SuperClient.Repeater in '..\..\Lib\supersocket\SuperClient.Repeater.pas',
  SuperClient.Socket in '..\..\Lib\supersocket\SuperClient.Socket.pas',
  SuperSocketUtils in '..\..\Lib\supersocket\SuperSocketUtils.pas',
  PacketReader in '..\..\Lib\supersocket\PacketReader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
