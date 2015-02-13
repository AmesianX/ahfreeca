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
  Protocol in 'Protocol.pas',
  PacketReader in '..\..\Lib\supersocket\PacketReader.pas',
  SuperClient in '..\..\Lib\supersocket\SuperClient.pas',
  SuperClient.Repeater in '..\..\Lib\supersocket\SuperClient.Repeater.pas',
  SuperClient.Socket in '..\..\Lib\supersocket\SuperClient.Socket.pas',
  SuperSocketUtils in '..\..\Lib\supersocket\SuperSocketUtils.pas',
  EchoCancel in '..\..\Lib\voicezip\EchoCancel.pas',
  msacm2 in '..\..\Lib\voicezip\msacm2.pas',
  SoundTouchDLL in '..\..\Lib\voicezip\SoundTouchDLL.pas',
  Speex in '..\..\Lib\voicezip\Speex.pas',
  SpeexDecoder in '..\..\Lib\voicezip\SpeexDecoder.pas',
  SpeexUtils in '..\..\Lib\voicezip\SpeexUtils.pas',
  VoiceBuffer in '..\..\Lib\voicezip\VoiceBuffer.pas',
  VoicePlayer in '..\..\Lib\voicezip\VoicePlayer.pas',
  WaveOut in '..\..\Lib\voicezip\WaveOut.pas',
  WaveOutHeader in '..\..\Lib\voicezip\WaveOutHeader.pas',
  VoiceZipUtils in '..\..\Lib\voicezip\VoiceZipUtils.pas',
  VoiceQuality in '..\..\Lib\voicezip\VoiceQuality.pas',
  VoiceRecorder in '..\..\Lib\voicezip\VoiceRecorder.pas',
  WaveIn in '..\..\Lib\voicezip\WaveIn.pas',
  WaveInDeviceList in '..\..\Lib\voicezip\WaveInDeviceList.pas',
  SpeexEncoder in '..\..\Lib\voicezip\SpeexEncoder.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
