unit VideoSender;

interface

uses
  Config, ProtocolVideo,
  Scheduler, VideoZip, RyuGraphics,
  SysUtils, Classes, Graphics;

type
  {*
    Cam 화면을 압축하는 클래스.
    TClientUnit.Obj.VideoClient.SendVideo()를 이용해서 압축 데이터를 전송한다.
  }
  TVideoSender = class
  private
    FBitmap : TBitmap;
  private
    FEncoder : TVideoZipEncoder;
    procedure on_FEncoder_Data(Sender:TObject; AData:pointer; ASize:integer);
  private
    FScheduler : TScheduler;
    procedure on_FScheduler_Start(Sender:TObject);
    procedure on_FScheduler_Stop(Sender:TObject);
    procedure on_FScheduler_Task(Sender:TObject; AData:pointer; ASize:integer; ATag:pointer);
    procedure on_FScheduler_Terminate(Sender:TObject);
    procedure on_FScheduler_Error(Sender:TObject; const AMsg:string);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVideoSender;

    procedure Initialize;
    procedure Finalize;

    /// 캠 화면 압축 준비를 한다.
    procedure Start;

    /// 캠 화면 압축을 종료 한다.
    procedure Stop;

    /// 압축 할 캠 화면을 입력 한다.
    procedure DataIn(ABitmap:TBitmap);
  end;

implementation

uses
  Core, ClientUnit;

{ TVideoSender }

var
  MyObject : TVideoSender = nil;

class function TVideoSender.Obj: TVideoSender;
begin
  if MyObject = nil then MyObject := TVideoSender.Create;
  Result := MyObject;
end;

procedure TVideoSender.on_FEncoder_Data(Sender: TObject; AData: pointer;
  ASize: integer);
begin
  TClientUnit.Obj.VideoClient.SendVideo( AData, ASize );
end;

procedure TVideoSender.on_FScheduler_Error(Sender: TObject; const AMsg: string);
begin
  // TODO:
end;

procedure TVideoSender.on_FScheduler_Start(Sender: TObject);
var
  Header : TVPX_Header;
begin
  Header.Width  := TCore.Obj.Option.CamWidth;
  Header.Height := TCore.Obj.Option.CamHeight;
  TClientUnit.Obj.VideoClient.SendHeader( @Header, SizeOf(Header) );

  FEncoder.Width  := TCore.Obj.Option.CamWidth;
  FEncoder.Height := TCore.Obj.Option.CamHeight;
  FEncoder.Open;
end;

procedure TVideoSender.on_FScheduler_Stop(Sender: TObject);
begin
  FEncoder.Close;
end;

procedure TVideoSender.on_FScheduler_Task(Sender: TObject; AData: pointer;
  ASize: integer; ATag: pointer);
var
  BitmapSrc : TBitmap absolute ATag;
begin
  if BitmapSrc = nil then Exit;

  try
    FBitmap.Width  := TCore.Obj.Option.CamWidth;
    FBitmap.Height := TCore.Obj.Option.CamHeight;

    SmoothResize( BitmapSrc, FBitmap );

    FEncoder.Encode( FBitmap );
  finally
    BitmapSrc.Free;
  end;
end;

procedure TVideoSender.on_FScheduler_Terminate(Sender: TObject);
begin
  FreeAndNil(FBitmap);
  FreeAndNil(FEncoder);
end;

procedure TVideoSender.Start;
begin
  FScheduler.Start;
end;

procedure TVideoSender.Stop;
begin
  FScheduler.Stop;
end;

constructor TVideoSender.Create;
begin
  inherited;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;

  FEncoder := TVideoZipEncoder.Create(nil);
  FEncoder.OnData := on_FEncoder_Data;

  FScheduler := TScheduler.Create;
  FScheduler.OnStart     := on_FScheduler_Start;
  FScheduler.OnStop      := on_FScheduler_Stop;
  FScheduler.OnTask      := on_FScheduler_Task;
  FScheduler.OnTerminate := on_FScheduler_Terminate;
  FScheduler.OnError     := on_FScheduler_Error;
end;

procedure TVideoSender.DataIn(ABitmap: TBitmap);
var
  Bitmap : TBitmap;
begin
  Bitmap := TBitmap.Create;
  AssignBitmap( ABitmap, Bitmap );
  FScheduler.Add( Bitmap );
end;

destructor TVideoSender.Destroy;
begin
  Stop;

  FreeAndNil(FScheduler);

  inherited;
end;

procedure TVideoSender.Finalize;
begin

end;

procedure TVideoSender.Initialize;
begin
  Stop;
end;

initialization
  MyObject := TVideoSender.Create;
end.