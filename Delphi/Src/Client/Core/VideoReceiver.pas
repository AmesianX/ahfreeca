unit VideoReceiver;

interface

uses
  Config, ProtocolVideo,
  Scheduler, VideoZip, RyuGraphics,
  SysUtils, Classes, Graphics, SyncObjs;

type
  /// 서버로부터 수신한 캠 영상 데이타를 디코딩하는 클래스
  TVideoReceiver = class
  private
    FCS : TCriticalSection;
    FBitmap : TBitmap;
  private
    FDecoder : TVideoZipDecoder;
  private
    FScheduler : TScheduler;
    procedure on_FScheduler_Task(Sender:TObject; AData:pointer; ASize:integer; ATag:pointer);
    procedure on_FScheduler_Terminate(Sender:TObject);
    procedure on_FScheduler_Error(Sender:TObject; const AMsg:string);
  private
    procedure rp_VPX_Header(AData:pointer; ASize:integer);
    procedure rp_VPX(AData:pointer; ASize:integer);
  private
    FIsBitmapChanged: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVideoReceiver;

    procedure Initialize;
    procedure Finalize;

    {*
      수신 된 패킷을 디코딩한다.
      @param APacketType 수신 된 데이터의 PacketType
      @param AData 수신 된 데이터의 포인터 주소
      @Param ASize 수신 된 데이터의 바이트 크기
    }
    procedure DataIn(APacketType:integer; AData:pointer; ASize:integer);

    /// 수신 받은 Bitmap을 가져온다.
    function GetBitmap(ABitmap:TBitmap):boolean;
  public
    property IsBitmapChanged : boolean read FIsBitmapChanged;
  end;

implementation

uses
  Core;

{ TVideoReceiver }

var
  MyObject : TVideoReceiver = nil;

class function TVideoReceiver.Obj: TVideoReceiver;
begin
  if MyObject = nil then MyObject := TVideoReceiver.Create;
  Result := MyObject;
end;

procedure TVideoReceiver.on_FScheduler_Error(Sender: TObject;
  const AMsg: string);
begin
  // TODO:
end;

procedure TVideoReceiver.on_FScheduler_Task(Sender: TObject; AData: pointer;
  ASize: integer; ATag: pointer);
var
  PacketType : TPacketType;
begin
  PacketType := TPacketType( Integer(ATag) );
  case PacketType of
    ptVPX_Header: rp_VPX_Header( AData, ASize );
    ptVPX: rp_VPX( AData, ASize );
  end;
end;

procedure TVideoReceiver.on_FScheduler_Terminate(Sender: TObject);
begin
  FDecoder.Close;

  FreeAndNil(FCS);
  FreeAndNil(FBitmap);
  FreeAndNil(FDecoder);
end;

procedure TVideoReceiver.rp_VPX(AData: pointer; ASize: integer);
begin
  FDecoder.Decode( AData, ASize );

  FCS.Acquire;
  try
    if FDecoder.GetBitmap( FBitmap ) then FIsBitmapChanged := true;
  finally
    FCs.Release;
  end;
end;

procedure TVideoReceiver.rp_VPX_Header(AData: pointer; ASize: integer);
var
  Header : TVPX_Header;
begin
  Move( AData^, Header, ASize );

  if (Header.Width <> FDecoder.Width) or (Header.Height <> FDecoder.Height) then begin
    FDecoder.Close;

    FDecoder.Width  := Header.Width;
    FDecoder.Height := Header.Height;
    FDecoder.Open;

    FIsBitmapChanged := false;
  end;
end;

constructor TVideoReceiver.Create;
begin
  inherited;

  FIsBitmapChanged := false;

  FCS := TCriticalSection.Create;

  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf32bit;
  FBitmap.Canvas.Brush.Color := clBlack;
  FBitmap.Width  := VIDEO_WIDTH;
  FBitmap.Height := VIDEO_HEIGHT;

  FDecoder := TVideoZipDecoder.Create(nil);
  FDecoder.Width  := VIDEO_WIDTH;
  FDecoder.Height := VIDEO_HEIGHT;
  FDecoder.Open;

  FScheduler := TScheduler.Create;
  FScheduler.OnTask      := on_FScheduler_Task;
  FScheduler.OnTerminate := on_FScheduler_Terminate;
  FScheduler.OnError     := on_FScheduler_Error;
end;

procedure TVideoReceiver.DataIn(APacketType:integer; AData: pointer; ASize: integer);
begin
  FScheduler.Add( AData, ASize, Pointer(APacketType) );
end;

destructor TVideoReceiver.Destroy;
begin
  FreeAndNil(FScheduler);

  inherited;
end;

procedure TVideoReceiver.Finalize;
begin
  FScheduler.Stop;
end;

function TVideoReceiver.GetBitmap(ABitmap: TBitmap): boolean;
begin
  Result := FIsBitmapChanged;

  FIsBitmapChanged := false;

  FCS.Acquire;
  try
    AssignBitmap( FBitmap, ABitmap );
  finally
    FCS.Release;
  end;
end;

procedure TVideoReceiver.Initialize;
begin
  FScheduler.Start;
end;

initialization
  MyObject := TVideoReceiver.Create;
end.