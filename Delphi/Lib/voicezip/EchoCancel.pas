unit EchoCancel;

interface

uses
  DebugTools, VoiceZipUtils, SpeexUtils,
  SysUtils, Classes;

type
  TEchoCancel = class
  private
    FEcho : pointer;
    FPreprocess : pointer;
    FEchoCanceled : pointer;
    FFrameSize : integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(ASampleSize,AFrameSize:integer);
    procedure Close;

    procedure Execute(ADataIn,AEchoData:pointer);
  public
    property EchoCanceled : pointer read FEchoCanceled;
  end;

implementation

const
  BUFFER_SIZE = 32 * 1024;

{ TEchoCancel }

procedure TEchoCancel.Close;
begin
  speex_preprocess_state_destroy( FPreprocess );
  speex_echo_state_destroy( FEcho );
end;

constructor TEchoCancel.Create;
begin
  inherited;

  GetMem( FEchoCanceled, BUFFER_SIZE );
end;

destructor TEchoCancel.Destroy;
begin
  Close;

  FreeMem(FEchoCanceled);

  inherited;
end;

procedure TEchoCancel.Execute(ADataIn,AEchoData: pointer);
begin
  speex_echo_cancellation( FEcho, ADataIn, AEchoData, FEchoCanceled );
end;

procedure TEchoCancel.Open(ASampleSize, AFrameSize: integer);
var
  iTemp : integer;
begin
  FFrameSize := AFrameSize;

  FillChar( FEchoCanceled^, BUFFER_SIZE, 0 );

  FEcho := speex_echo_state_init( AFrameSize, _SampleRate div 10 );

  ASampleSize := _SampleRate;
  speex_echo_ctl( FEcho, SPEEX_ECHO_SET_SAMPLING_RATE, @ASampleSize );

  FPreprocess:= speex_preprocess_state_init( AFrameSize, ASampleSize );

  speex_preprocess_ctl( FPreprocess, SPEEX_PREPROCESS_SET_ECHO_STATE, FEcho );

  iTemp := -45;
  speex_preprocess_ctl( FPreprocess, SPEEX_PREPROCESS_SET_ECHO_SUPPRESS, @iTemp );
  speex_preprocess_ctl( FPreprocess, SPEEX_PREPROCESS_SET_ECHO_SUPPRESS_ACTIVE, @iTemp );
end;

end.
