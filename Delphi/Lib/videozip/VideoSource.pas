unit VideoSource;

interface

uses
  SysUtils, Classes, Graphics;

type
  TVideoSourceType = (vsDesktop, vsCam);

  TVideoSource = class abstract
  private
  public
    function GetBitmap(ABitmap:TBitmap):boolean; virtual; abstract;
  end;

implementation

end.
