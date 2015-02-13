program VideoChatClient03;

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
  _frCamPreview in '_frCamPreview.pas' {frCamPreview: TFrame},
  VideoIn in 'Core\VideoIn.pas',
  VideoOut in 'Core\VideoOut.pas',
  _frScreen in '_frScreen.pas' {frScreen: TFrame},
  Config in 'Config.pas',
  Protocol in 'Protocol.pas',
  PacketReader in '..\..\Lib\supersocket\PacketReader.pas',
  SuperClient in '..\..\Lib\supersocket\SuperClient.pas',
  SuperClient.Repeater in '..\..\Lib\supersocket\SuperClient.Repeater.pas',
  SuperClient.Socket in '..\..\Lib\supersocket\SuperClient.Socket.pas',
  SuperSocketUtils in '..\..\Lib\supersocket\SuperSocketUtils.pas',
  VideoZip in '..\..\Lib\videozip\VideoZip.pas',
  VideoZipPacketSlice in '..\..\Lib\videozip\VideoZipPacketSlice.pas',
  VideoZipUtils in '..\..\Lib\videozip\VideoZipUtils.pas',
  EchoCancel in '..\..\Lib\voicezip\EchoCancel.pas',
  msacm2 in '..\..\Lib\voicezip\msacm2.pas',
  SoundTouchDLL in '..\..\Lib\voicezip\SoundTouchDLL.pas',
  Speex in '..\..\Lib\voicezip\Speex.pas',
  SpeexDecoder in '..\..\Lib\voicezip\SpeexDecoder.pas',
  SpeexEncoder in '..\..\Lib\voicezip\SpeexEncoder.pas',
  SpeexUtils in '..\..\Lib\voicezip\SpeexUtils.pas',
  VoiceBuffer in '..\..\Lib\voicezip\VoiceBuffer.pas',
  VoicePlayer in '..\..\Lib\voicezip\VoicePlayer.pas',
  VoiceQuality in '..\..\Lib\voicezip\VoiceQuality.pas',
  VoiceRecorder in '..\..\Lib\voicezip\VoiceRecorder.pas',
  VoiceZipUtils in '..\..\Lib\voicezip\VoiceZipUtils.pas',
  WaveIn in '..\..\Lib\voicezip\WaveIn.pas',
  WaveInDeviceList in '..\..\Lib\voicezip\WaveInDeviceList.pas',
  WaveOut in '..\..\Lib\voicezip\WaveOut.pas',
  WaveOutHeader in '..\..\Lib\voicezip\WaveOutHeader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
