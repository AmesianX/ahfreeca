unit SpeexUtils;

interface

const
  SPEEX_ECHO_SET_SAMPLING_RATE = 24;

  SPEEX_PREPROCESS_SET_ECHO_SUPPRESS = 20;
  SPEEX_PREPROCESS_GET_ECHO_SUPPRESS = 21;

  SPEEX_PREPROCESS_SET_ECHO_SUPPRESS_ACTIVE = 22;
  SPEEX_PREPROCESS_GET_ECHO_SUPPRESS_ACTIVE = 23;

  SPEEX_PREPROCESS_SET_ECHO_STATE = 24;

function speex_echo_state_init(frame_size,filter_length:integer):pointer; cdecl;
         external 'libspeexdsp-1.dll';

procedure speex_echo_cancel(st:pointer; rec,play,_out:PSmallInt; Yout:PLongInt); cdecl;
         external 'libspeexdsp-1.dll';

procedure speex_echo_cancellation(st:pointer; rec,play,_out:PSmallInt); cdecl;
         external 'libspeexdsp-1.dll';

procedure speex_echo_capture(st:pointer; rec,_out:PSmallInt); cdecl;
         external 'libspeexdsp-1.dll';

procedure speex_echo_playback(st:pointer; play:PSmallInt); cdecl;
         external 'libspeexdsp-1.dll';

function speex_echo_ctl(st:pointer; request:integer; ptr:pointer):integer; cdecl;
         external 'libspeexdsp-1.dll';

procedure speex_echo_state_reset(st:pointer); cdecl;
         external 'libspeexdsp-1.dll';

procedure speex_echo_state_destroy(st:pointer); cdecl;
         external 'libspeexdsp-1.dll';

function speex_preprocess_state_init(frame_size,sampling_rate:integer):pointer; cdecl;
         external 'libspeexdsp-1.dll';

function speex_preprocess_ctl(st:pointer; request:integer; ptr:pointer):pointer; cdecl;
         external 'libspeexdsp-1.dll';

function speex_preprocess_run(st:pointer; x:PSmallInt):integer; cdecl;
         external 'libspeexdsp-1.dll';

procedure speex_preprocess_state_destroy(st:pointer); cdecl;
         external 'libspeexdsp-1.dll';

implementation

end.
