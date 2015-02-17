unit ProtocolVideo;

interface

uses
  Classes, SysUtils;

type
  TPacketType = (ptDeskCam, ptVPX_Header, ptVPX);

  TVPX_Header = packed record
    Width : word;
    Height : word;
  end;

implementation

end.
