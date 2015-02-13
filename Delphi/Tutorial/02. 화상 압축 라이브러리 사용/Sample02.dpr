program Sample02;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  VideoZip in '..\..\Lib\videozip\VideoZip.pas',
  VideoZipPacketSlice in '..\..\Lib\videozip\VideoZipPacketSlice.pas',
  VideoZipUtils in '..\..\Lib\videozip\VideoZipUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
