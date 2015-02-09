unit VideoSource.Cam;

interface

uses
  Config,
  VideoSource,
  WebCam,
  Windows, SysUtils, Classes, Graphics;

type
  TCam = class (TVideoSource)
  private
    FWebCam : TWebCam;
  public
    constructor Create;
    destructor Destroy; override;

    function GetBitmap(ABitmap:TBitmap): boolean; override;
  end;

implementation

{ TCam }

constructor TCam.Create;
begin
  inherited;

  FWebCam := TWebCam.Create(nil);
  FWebCam.Start( VIDEO_BIG_WIDTH, VIDEO_BIG_HEIGHT );
end;

destructor TCam.Destroy;
begin
  FWebCam.Stop;

  FreeAndNil(FWebCam);

  inherited;
end;

function TCam.GetBitmap(ABitmap: TBitmap): boolean;
begin
  Result := FWebCam.GetBitmap( ABitmap );
end;

end.
