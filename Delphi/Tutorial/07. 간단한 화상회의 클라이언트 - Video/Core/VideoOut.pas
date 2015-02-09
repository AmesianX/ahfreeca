unit VideoOut;

interface

uses
  Config, VideoZip,
  SysUtils, Classes, Graphics, SyncObjs;

type
  TVideoOut = class
  private
    FCS : TCriticalSection;
    FDecoder : TVideoZipDecoder;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TVideoOut;

    procedure DataIn(AData:pointer; ASize:integer);
    function GetBitmap(ABitmap:TBitmap):boolean;
  end;

implementation

{ TVideoOut }

var
  MyObject : TVideoOut = nil;

class function TVideoOut.Obj: TVideoOut;
begin
  if MyObject = nil then MyObject := TVideoOut.Create;
  Result := MyObject;
end;

constructor TVideoOut.Create;
begin
  inherited;

  FCS := TCriticalSection.Create;

  FDecoder := TVideoZipDecoder.Create(nil);
  FDecoder.Width  := VIDEO_WIDTH;
  FDecoder.Height := VIDEO_HEIGHT;
  FDecoder.Open;
end;

procedure TVideoOut.DataIn(AData: pointer; ASize: integer);
begin
  FCS.Acquire;
  try
    // TODO: 스레드 사용
    FDecoder.Decode( AData, ASize );
  finally
    FCS.Release;
  end;
end;

destructor TVideoOut.Destroy;
begin
  FreeAndNil(FCS);
  FreeAndNil(FDecoder);

  inherited;
end;

function TVideoOut.GetBitmap(ABitmap: TBitmap): boolean;
begin
  FCS.Acquire;
  try
    Result := FDecoder.GetBitmap( ABitmap );
  finally
    FCS.Release;
  end;
end;

initialization
  MyObject := TVideoOut.Create;
end.