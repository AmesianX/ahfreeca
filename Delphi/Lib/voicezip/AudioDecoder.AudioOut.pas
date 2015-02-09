unit AudioDecoder.AudioOut;

interface

uses
  MemoryReader, SimpleThread, WaveOut,
  SysUtils, Classes, SyncObjs;

const
  AUDIO_FRAME_SIZE = 320;

type
  TAudioOut = class
  private
    FCS : TCriticalSection;
    FWaveOut : TWaveOut;
    FMemoryReader : TMemoryReader;
    function get_Data(var AData:pointer; ASize:integer):boolean;
  private
    FSimpleThread : TSimpleThread;
    procedure on_Repeat(Sender:TObject);
  private
    function GetDelayedTime: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open;
    procedure Close;

    procedure DataIn(AData:pointer; ASize:integer);
  public
    property DelayedTime : integer read GetDelayedTime;
  end;

implementation

{ TAudioOut }

procedure TAudioOut.Close;
begin
  FCS.Acquire;
  try
    FWaveOut.Stop;
  finally
    FCS.Release;
  end;
end;

constructor TAudioOut.Create;
begin
  inherited;

  FCS := TCriticalSection.Create;
  FWaveOut := TWaveOut.Create(nil);
  FMemoryReader := TMemoryReader.Create;

  FSimpleThread := TSimpleThread.Create(on_Repeat);
end;

procedure TAudioOut.DataIn(AData: pointer; ASize: integer);
begin
  FCS.Acquire;
  try
    FMemoryReader.Write( AData, ASize );
  finally
    FCS.Release;
  end;

  FSimpleThread.WakeUp;
end;

destructor TAudioOut.Destroy;
begin
  Close;

  FSimpleThread.Terminate;

  inherited;
end;

function TAudioOut.GetDelayedTime: integer;
begin
  Result := (FWaveOut.DataInBuffer * 20) + ((FMemoryReader.Size div AUDIO_FRAME_SIZE) * 20);
end;

function TAudioOut.get_Data(var AData: pointer; ASize: integer): boolean;
begin
  FCS.Acquire;
  try
    Result := FMemoryReader.Read( AData, ASize );
  finally
    FCS.Release;
  end;
end;

procedure TAudioOut.on_Repeat(Sender: TObject);
var
  Data : pointer;
  SimpleThread : TSimpleThread absolute Sender;
begin
  while not SimpleThread.Terminated do begin
    while (FWaveOut.DataInBuffer <= 3) and get_Data(Data, AUDIO_FRAME_SIZE) do begin
      try
        FWaveOut.Play(Data, AUDIO_FRAME_SIZE);
      finally
        if Data <> nil then FreeMem(Data);
      end;

      if FWaveOut.DataInBuffer > 3 then Break;
    end;

    SimpleThread.Sleep(1);
  end;

//  FreeAndNil(FCS);
//  FreeAndNil(FWaveOut);
//  FreeAndNil(FMemoryReader);
end;

procedure TAudioOut.Open;
begin
  FCS.Acquire;
  try
    FWaveOut.Start;
  finally
    FCS.Release;
  end;
end;

end.
