program Sample03;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  EchoCancel in '..\..\Lib\voicezip\EchoCancel.pas',
  msacm2 in '..\..\Lib\voicezip\msacm2.pas',
  SoundTouchDLL in '..\..\Lib\voicezip\SoundTouchDLL.pas',
  Speex in '..\..\Lib\voicezip\Speex.pas',
  SpeexDecoder in '..\..\Lib\voicezip\SpeexDecoder.pas',
  SpeexEncoder in '..\..\Lib\voicezip\SpeexEncoder.pas',
  SpeexUtils in '..\..\Lib\voicezip\SpeexUtils.pas',
  VoicePlayer in '..\..\Lib\voicezip\VoicePlayer.pas',
  VoiceRecorder in '..\..\Lib\voicezip\VoiceRecorder.pas',
  VoiceZipUtils in '..\..\Lib\voicezip\VoiceZipUtils.pas',
  WaveIn in '..\..\Lib\voicezip\WaveIn.pas',
  WaveOut in '..\..\Lib\voicezip\WaveOut.pas',
  WaveOutHeader in '..\..\Lib\voicezip\WaveOutHeader.pas',
  VoiceBuffer in '..\..\Lib\voicezip\VoiceBuffer.pas',
  VoiceQuality in '..\..\Lib\voicezip\VoiceQuality.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
