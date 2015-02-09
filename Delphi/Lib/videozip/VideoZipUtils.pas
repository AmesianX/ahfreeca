unit VideoZipUtils;

interface

uses
  Classes, SysUtils, Graphics;

const
  PIXEL_FORMAT = pf32bit;
  PIXEL_SIZE = 4;

  ERROR_GENERAL = -1;
  ERROR_CAN_NOT_OPEN_FILE = -2;
  ERROR_CAN_NOT_FIND_STREAMINFO = -3;
  ERROR_CAN_NOT_FIND_VIDOESTREAM = -4;
  ERROR_CAN_NOT_FIND_AUDIOSTREAM = -5;
  ERROR_CAN_NOT_OPEN_VIDEOCODEC = -6;
  ERROR_CAN_NOT_OPEN_AUDIOCODEC = -7;
  ERROR_CAN_NOT_FIND_VIDEOCODEC = -8;
  ERROR_CAN_NOT_FIND_AUDIOCODEC = -9;

  VPX_DL_REALTIME     = 0;
  VPX_DL_GOOD_QUALITY = 1;
  VPX_DL_BEST_QUALITY = 2;

function  openEncoder(var AErrorCode:integer; width,height,bitRate,gop:integer):pointer;
          cdecl; external 'VideoZip.dll';

procedure closeEncoder(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

function  encodeBitmap(AHandle:pointer; pBitmap,pBuffer:pointer; sizeOfBuffer,deadline:integer; var pts:int64):integer;
          cdecl; external 'VideoZip.dll';

function  openDecoder(var AErrorCode:integer; width,height:integer):pointer;
          cdecl; external 'VideoZip.dll';

procedure closeDecoder(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

procedure initDecoder(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

function  decodeBitmap(AHandle:pointer; pBitmap,pBuffer:pointer; sizeOfBuffer:integer):boolean;
          cdecl; external 'VideoZip.dll';

implementation

end.
