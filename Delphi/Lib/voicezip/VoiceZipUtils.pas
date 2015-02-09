unit VoiceZipUtils;

interface

uses
  msacm2,
  Windows, Messages, SysUtils, Classes, MMSystem;

const
  _Channels = 1;
  _SampleRate = 8000;

  // 현재 사용 중인 Speex의 FrameSize를 기준으로 한 것임.
  _FrameSize = 320;
  _FrameTime = 20;

  ERROR_WAVEIN_OPEN = -1;

type
  IAudioDecoder = interface
    ['{1099D56E-F76C-406A-B242-460EE532D97C}']

    function GetDelayedTime: integer;
    property DelayedTime : integer read GetDelayedTime;
  end;

  IEchoData = interface
    ['{444CF2F8-BFA8-40A6-BE2D-AE09B5726C14}']

    function GetEchoData:pointer;
  end;

  TBufferSmallInt = packed array of SmallInt;
  TBufferSingle = packed array of single;

  TVoiceDataEvent = procedure (Sender:TObject; AData:pointer; ASize,AVolume:integer) of object;

function GetErrorText(ErrorCode:MMRESULT):string;

implementation

function GetErrorText(ErrorCode:MMRESULT):string;
var
  ErrorText: array[0..255] of Char;
begin
  if waveOutGetErrorText(ErrorCode, ErrorText, SizeOf(ErrorText)) = MMSYSERR_NOERROR then
    Result := StrPas(ErrorText)
  else
    Result := '';
end;

end.
