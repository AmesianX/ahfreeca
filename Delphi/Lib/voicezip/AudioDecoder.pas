unit AudioDecoder;

interface

uses
  AudioDecoder.AudioOut,
  VoiceZipUtils,
  RyuLibBase, LazyRelease,
  PacketProcessor, SpeexDecoder, DelayRemover, EchoCancel,
  SysUtils, Classes, SyncObjs;

type
  TAudioDecoder = class (TInterfaceBase, IAudioDecoder, IEchoData)
  private  // implementation of IAudioDecoder
    function GetDelayedTime: integer;
  private  // implementation of IEchoData
    function GetEchoData:pointer;
  private
    FCS : TCriticalSection;
    FAudioOut : TAudioOut;
  private
    FEchoData : TLazyRelease;
  private
    FSpeexDecoder : TSpeexDecoder;
    procedure on_SpeexDecoder(Sender:TObject; AData:pointer; ASize,AVolume:integer);
  private
    FDelayRemover : TDelayRemover;
    procedure on_DelayRemover(Sender:TObject; AData:pointer; ASize:integer);
  private
    FPacketProcessor : TPacketProcessor;
    procedure on_PacketProcessor(Sender:TObject; AData:pointer; ASize:integer);
    procedure on_PacketProcessorTerminate(Sender:TObject);
  private
    FVolumeOut: integer;
    FIsMute: boolean;
    function GetVolume: Single;
    procedure SetVolume(const Value: Single);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure Execute(AData:pointer; ASize:integer);
  public
    property IsMute : boolean read FIsMute write FIsMute;
    property VolumeOut : integer read FVolumeOut;
    property Volume: Single read GetVolume write SetVolume;
  end;

implementation

{ TAudioDecoder }

procedure TAudioDecoder.Close;
begin
  FCS.Acquire;
  try
    FAudioOut.Close;
    FSpeexDecoder.Stop;
    FDelayRemover.Tempo := 0;
  finally
    FCS.Release;
  end;
end;

constructor TAudioDecoder.Create;
const
  ECHO_CANCEL_RING_BUFFER_SIZE = 32;
var
  pTemp : pointer;
begin
  FIsMute := false;

  FEchoData := TLazyRelease.Create( ECHO_CANCEL_RING_BUFFER_SIZE );

  GetMem( pTemp, 1024 );
  FEchoData.Release( pTemp );

  FCS := TCriticalSection.Create;

  FAudioOut := TAudioOut.Create;

  FSpeexDecoder := TSpeexDecoder.Create(nil);
  FSpeexDecoder.OnData := on_SpeexDecoder;

  FDelayRemover := TDelayRemover.Create;
  FDelayRemover.Tempo := 0;
  FDelayRemover.OnData := on_DelayRemover;

  FPacketProcessor := TPacketProcessor.Create;
  FPacketProcessor.SeamlessProcessor := true;
  FPacketProcessor.OnData := on_PacketProcessor;
  FPacketProcessor.OnTerminate := on_PacketProcessorTerminate;
end;

destructor TAudioDecoder.Destroy;
begin
  Close;

  inherited;
end;

procedure TAudioDecoder.Execute(AData: pointer; ASize: integer);
begin
  FPacketProcessor.Add( AData, ASize );
end;

function TAudioDecoder.GetDelayedTime: integer;
begin
  Result := FAudioOut.DelayedTime;
end;

function TAudioDecoder.GetEchoData: pointer;
begin
  Result := FEchoData.Current;
end;

function TAudioDecoder.GetVolume: Single;
begin
  Result := FSpeexDecoder.Volume;
end;

procedure TAudioDecoder.on_DelayRemover(Sender: TObject; AData: pointer;
  ASize: integer);
begin
  if not FIsMute then FAudioOut.DataIn( AData, ASize );
end;

procedure TAudioDecoder.on_PacketProcessor(Sender: TObject; AData: pointer;
  ASize: integer);
begin
  FCS.Acquire;
  try
    FSpeexDecoder.Excute( AData, ASize );
  finally
    FCS.Release;
  end;
end;

procedure TAudioDecoder.on_PacketProcessorTerminate(Sender: TObject);
begin
//  FreeAndNil(FEchoData);
//  FreeAndNil(FCS);
//  FreeAndNil(FAudioOut);
//  FreeAndNil(FSpeexDecoder);
//  FreeAndNil(FDelayRemover);
//  FreeAndNil(FPacketProcessor);
end;

procedure TAudioDecoder.on_SpeexDecoder(Sender: TObject; AData: pointer; ASize,
  AVolume: integer);
var
  pTemp : pointer;
  iDelayedTime : integer;
begin
  GetMem( pTemp, ASize );
  Move( AData^, pTemp^, ASize );
  FEchoData.Release( pTemp );

  FVolumeOut := AVolume;

  iDelayedTime := FAudioOut.DelayedTime;

       if iDelayedTime >= 500 then FDelayRemover.Tempo := 16
  else if iDelayedTime >= 250 then FDelayRemover.Tempo :=  8
  else if iDelayedTime >= 150 then FDelayRemover.Tempo :=  4
  else if iDelayedTime >= 100 then FDelayRemover.Tempo :=  2
  else if iDelayedTime >=  60 then FDelayRemover.Tempo :=  1
  else FDelayRemover.Tempo := 0;

  if FDelayRemover.Tempo = 0 then begin
    if not FIsMute then FAudioOut.DataIn( AData, ASize );
  end else begin
    if not FIsMute then FDelayRemover.DataIn( AData, ASize );
  end;
end;

procedure TAudioDecoder.Open;
begin
  FCS.Acquire;
  try
    FDelayRemover.Tempo := 0;
    FSpeexDecoder.Start;
    FAudioOut.Open;
  finally
    FCS.Release;
  end;
end;

procedure TAudioDecoder.SetVolume(const Value: Single);
begin
  FSpeexDecoder.Volume := Value;
end;

end.
