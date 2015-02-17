program Client;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  _frChat in 'Frames\_frChat.pas' {frChat: TFrame},
  _frControlBoxReceiver in 'Frames\_frControlBoxReceiver.pas' {frControlBoxReceiver: TFrame},
  _frControlBoxSender in 'Frames\_frControlBoxSender.pas' {frControlBoxSender: TFrame},
  _frUserList in 'Frames\_frUserList.pas' {frUserList: TFrame},
  Frames in 'Frames\Frames.pas',
  SelectColorDialog in 'Dialogs\SelectColorDialog.pas' {fmSelectColorDialog},
  ClientUnit in 'Core\ClientUnit.pas',
  ClientUnit.TextClient in 'Core\ClientUnit.TextClient.pas',
  ClientUnit.TextClient.UserList in 'Core\ClientUnit.TextClient.UserList.pas',
  ClientUnit.VideoClient in 'Core\ClientUnit.VideoClient.pas',
  ClientUnit.VoiceClient in 'Core\ClientUnit.VoiceClient.pas',
  Core in 'Core\Core.pas',
  CoreInterface in 'Core\CoreInterface.pas',
  Option in 'Core\Option.pas',
  View in 'Core\View.pas',
  VoiceReceiver in 'Core\VoiceReceiver.pas',
  VoiceSender in 'Core\VoiceSender.pas',
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
  VoicePlayers in '..\..\Lib\voicezip\VoicePlayers.pas',
  VoiceQuality in '..\..\Lib\voicezip\VoiceQuality.pas',
  VoiceRecorder in '..\..\Lib\voicezip\VoiceRecorder.pas',
  VoiceZipUtils in '..\..\Lib\voicezip\VoiceZipUtils.pas',
  WaveIn in '..\..\Lib\voicezip\WaveIn.pas',
  WaveInDeviceList in '..\..\Lib\voicezip\WaveInDeviceList.pas',
  WaveOut in '..\..\Lib\voicezip\WaveOut.pas',
  WaveOutHeader in '..\..\Lib\voicezip\WaveOutHeader.pas',
  Config in '..\..\Lib\Config.pas',
  Protocol in '..\..\Lib\Protocol.pas',
  ProtocolText in '..\..\Lib\ProtocolText.pas',
  ProtocolVideo in '..\..\Lib\ProtocolVideo.pas',
  ProtocolVoice in '..\..\Lib\ProtocolVoice.pas',
  UserLevel in '..\..\Lib\UserLevel.pas',
  _fmMain.frLoginedLayout in '_fmMain.frLoginedLayout.pas' {frLoginedLayout: TFrame},
  _fmMain.frLoginLayout in '_fmMain.frLoginLayout.pas' {frLoginLayout: TFrame},
  _frCamPreview in 'Frames\_frCamPreview.pas' {frCamPreview: TFrame},
  VideoSender in 'Core\VideoSender.pas',
  VideoReceiver in 'Core\VideoReceiver.pas',
  _frCamScreen in 'Frames\_frCamScreen.pas' {frCamScreen: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
