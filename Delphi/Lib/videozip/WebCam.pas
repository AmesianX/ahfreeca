unit WebCam;

interface

uses
  SysUtils, Classes, Graphics;

const
  _PixelSize = 4;  

type
  TWebCam = class (TComponent)
  private
    FObject : pointer;
    FDeviceList: TStringList;
  private
    function GetActive: boolean;
    function GetDeviceList: TStringList;
    function GetDeviceNo: Integer;
    function GetHeight: integer;
    function GetWidth: integer;
    procedure SetDeviceNo(const Value: Integer);
    function GetDeviceCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start(AWidth,AHeight:integer);
    procedure Stop;

    function GetBitmap(ABitmap:TBitmap):boolean;
  published
    property Active : boolean read GetActive;
    property Width : integer read GetWidth;
    property Height : integer read GetHeight;

    property DeviceNo : Integer read GetDeviceNo write SetDeviceNo;
    property DeviceCount : Integer read GetDeviceCount;
    property DeviceList : TStringList read GetDeviceList;
  end;

implementation

function _CreateObject:TWebCam;
         external 'libWebCam.dll';

procedure _ReleaseObject(AObject:pointer);
         external 'libWebCam.dll';

procedure _Start(AObject:pointer; AWidth,AHeight:integer);
         external 'libWebCam.dll';

procedure _Stop(AObject:pointer);
         external 'libWebCam.dll';

function _SaveBitmapToData(AObject,AData:pointer):boolean;
         external 'libWebCam.dll';

function _GetActive(AObject:pointer):boolean;
         external 'libWebCam.dll';

function _GetWidth(AObject:pointer):integer;
         external 'libWebCam.dll';

function _GetHeight(AObject:pointer):integer;
         external 'libWebCam.dll';

function _GetDeviceNo(AObject:pointer):integer;
         external 'libWebCam.dll';

procedure _SetDeviceNo(AObject:pointer; AValue:integer);
         external 'libWebCam.dll';

function _GetDeviceList(AObject:pointer):PAnsiChar;
         external 'libWebCam.dll';

{ TWebCam }

constructor TWebCam.Create(AOwner: TComponent);
begin
  inherited;

  FDeviceList := TStringList.Create;
  FObject := _CreateObject;
end;

destructor TWebCam.Destroy;
begin
  Stop;

  if FObject <> nil then begin
    _ReleaseObject(FObject);
    FObject := nil;
  end;

  FreeAndNil(FDeviceList);

  inherited;
end;

function TWebCam.GetActive: boolean;
begin
  Result := _GetActive(FObject);
end;

function TWebCam.GetBitmap(ABitmap: TBitmap): boolean;
begin
  Result := _SaveBitmapToData(FObject, ABitmap.ScanLine[ABitmap.Height-1]);
end;

function TWebCam.GetDeviceCount: Integer;
begin
  Result := DeviceList.Count;
end;

function TWebCam.GetDeviceList: TStringList;
begin
  FDeviceList.Text := String(_GetDeviceList(FObject));
  Result := FDeviceList;
end;

function TWebCam.GetDeviceNo: Integer;
begin
  Result := _GetDeviceNo(FObject);
end;

function TWebCam.GetHeight: integer;
begin
  Result := _GetHeight(FObject);
end;

function TWebCam.GetWidth: integer;
begin
  Result := _GetWidth(FObject);
end;

procedure TWebCam.SetDeviceNo(const Value: Integer);
begin
  _SetDeviceNo(FObject, Value);
end;

procedure TWebCam.Start(AWidth, AHeight: integer);
begin
  _Start(FObject, AWidth, AHeight);
end;

procedure TWebCam.Stop;
begin
  _Stop(FObject);
end;

end.
