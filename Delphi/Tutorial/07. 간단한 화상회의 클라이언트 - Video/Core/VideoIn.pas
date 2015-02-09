unit VideoIn;

interface

uses
  Config, VideoZip, SimpleThread, RyuGraphics,
  SysUtils, Classes, Graphics, SyncObjs;

type
  TVideoIn = class
  private
    FCS : TCriticalSection;
    FBitmap : TBitmap;
  private
    FEncoder : TVideoZipEncoder;
    procedure on_VideoZipEncoder_Data(Sender:TObject; AData:pointer; ASize:integer);
  private
    FSimpleThread : TSimpleThread;
    procedure on_SimpleThread_Repeat(Sender:TObject);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVideoIn;

    procedure DataIn(ABitmap:TBitmap);
  end;

implementation

uses
  ClientSocket;

{ TVideoIn }

var
  MyObject : TVideoIn = nil;

class function TVideoIn.Obj: TVideoIn;
begin
  if MyObject = nil then MyObject := TVideoIn.Create;
  Result := MyObject;
end;

procedure TVideoIn.on_SimpleThread_Repeat(Sender: TObject);
var
  SimpleThread : TSimpleThread absolute Sender;
begin
  while not SimpleThread.Terminated do begin
    SimpleThread.SleepTight;

    FCS.Acquire;
    try
      FEncoder.Encode( FBitmap );
    finally
      FCS.Release;
    end;
  end;
end;

procedure TVideoIn.on_VideoZipEncoder_Data(Sender: TObject; AData: pointer;
  ASize: integer);
begin
  TClientSocket.Obj.SendVideo( AData, ASize );
end;

constructor TVideoIn.Create;
begin
  inherited;

  FCS := TCriticalSection.Create;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;
  FBitmap.Canvas.Brush.Color := clBlack;
  FBitmap.Width  := VIDEO_WIDTH;
  FBitmap.Height := VIDEO_HEIGHT;

  FEncoder := TVideoZipEncoder.Create(nil);
  FEncoder.GOP_Size := 16;
  FEncoder.Width  := VIDEO_WIDTH;
  FEncoder.Height := VIDEO_HEIGHT;
  FEncoder.OnData := on_VideoZipEncoder_Data;
  FEncoder.Open;

  FSimpleThread := TSimpleThread.Create(on_SimpleThread_Repeat);
end;

procedure TVideoIn.DataIn(ABitmap: TBitmap);
begin
  FCS.Acquire;
  try
    AssignBitmap( ABitmap, FBitmap );
  finally
    FCS.Release;
  end;

  FSimpleThread.WakeUp;
end;

destructor TVideoIn.Destroy;
begin
  FEncoder.Close;

  FSimpleThread.TerminateNow;

  FreeAndNil(FCS);
  FreeAndNil(FBitmap);
  FreeAndNil(FEncoder);

  inherited;
end;

initialization
  MyObject := TVideoIn.Create;
end.