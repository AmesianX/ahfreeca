unit WaveInDeviceList;

interface

uses
  Windows, SysUtils, Classes, MMSystem;

const
{ defines for dwFormat field of WAVEINCAPS and WAVEOUTCAPS }
  WAVE_INVALIDFORMAT     = $00000000;       { invalid format             }
  WAVE_FORMAT_1M08       = $00000001;       { 11.025 kHz, Mono,   8-bit  }
  WAVE_FORMAT_1S08       = $00000002;       { 11.025 kHz, Stereo, 8-bit  }
  WAVE_FORMAT_1M16       = $00000004;       { 11.025 kHz, Mono,   16-bit }
  WAVE_FORMAT_1S16       = $00000008;       { 11.025 kHz, Stereo, 16-bit }
  WAVE_FORMAT_2M08       = $00000010;       { 22.05  kHz, Mono,   8-bit  }
  WAVE_FORMAT_2S08       = $00000020;       { 22.05  kHz, Stereo, 8-bit  }
  WAVE_FORMAT_2M16       = $00000040;       { 22.05  kHz, Mono,   16-bit }
  WAVE_FORMAT_2S16       = $00000080;       { 22.05  kHz, Stereo, 16-bit }
  WAVE_FORMAT_4M08       = $00000100;       { 44.1   kHz, Mono,   8-bit  }
  WAVE_FORMAT_4S08       = $00000200;       { 44.1   kHz, Stereo, 8-bit  }
  WAVE_FORMAT_4M16       = $00000400;       { 44.1   kHz, Mono,   16-bit }
  WAVE_FORMAT_4S16       = $00000800;       { 44.1   kHz, Stereo, 16-bit }

  WAVE_FORMAT_44M08      = $00000100;       { 44.1   kHz, Mono,   8-bit  }
  WAVE_FORMAT_44S08      = $00000200;       { 44.1   kHz, Stereo, 8-bit  }
  WAVE_FORMAT_44M16      = $00000400;       { 44.1   kHz, Mono,   16-bit }
  WAVE_FORMAT_44S16      = $00000800;       { 44.1   kHz, Stereo, 16-bit }
  WAVE_FORMAT_48M08      = $00001000;       { 48     kHz, Mono,   8-bit  }
  WAVE_FORMAT_48S08      = $00002000;       { 48     kHz, Stereo, 8-bit  }
  WAVE_FORMAT_48M16      = $00004000;       { 48     kHz, Mono,   16-bit }
  WAVE_FORMAT_48S16      = $00008000;       { 48     kHz, Stereo, 16-bit }
  WAVE_FORMAT_96M08      = $00010000;       { 96     kHz, Mono,   8-bit  }
  WAVE_FORMAT_96S08      = $00020000;       { 96     kHz, Stereo, 8-bit  }
  WAVE_FORMAT_96M16      = $00040000;       { 96     kHz, Mono,   16-bit }
  WAVE_FORMAT_96S16      = $00080000;       { 96     kHz, Stereo, 16-bit }

type
  TWaveFormat = (wf1M08, wf1S08, wf1M16, wf1S16, wf2M08, wf2S08, wf2M16, wf2S16,
    wf4M08, wf4S08, wf4M16, wf4S16, wf44M08, wf44S08, wf44M16, wf44S16,
    wf48M08, wf48S08, wf48M16, wf48S16, wf96M08, wf96S08, wf96M16, wf96S16);

  TWaveFormats = set of TWaveFormat;

  TWaveInDeviceInfo = class
  private
  public
    DeviceID: Cardinal;
    ManufacturerID: WORD;
    ProductID: WORD;
    DriverVersion: MMVERSION;
    ProductName: String;
    WaveFormats: TWaveFormats;
    Channels: WORD;
    DefaultDevice: Boolean;
  end;

  TWaveInDeviceList = class
  private
    FList: TList;
    function get_WaveInDeviceInfo(const ADeviceID: Cardinal): TWaveInDeviceInfo;
    procedure set_WaveFormats(var AWaveFormats: TWaveFormats; const dwFormats: DWORD);
  private
    function GetItem(Index: Integer): TWaveInDeviceInfo;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function IndexOfDevice(ADeviceID: Cardinal): Integer;
    function IndexOfDeviceName(ADeviceName: String): Integer;

    property Items[Index: Integer]: TWaveInDeviceInfo read GetItem;
    property Count: Integer read GetCount;
  end;

implementation

{ TWaveInDeviceList }

function TWaveInDeviceList.get_WaveInDeviceInfo(const ADeviceID: Cardinal): TWaveInDeviceInfo;
var
  Caps : WAVEINCAPS;
  mm_result : MMRESULT;
begin
  Result := nil;

  FillChar(Caps, SizeOf(Caps), #0);
  mm_result := waveInGetDevCaps(ADeviceID, @Caps, SizeOf(Caps));
  if mm_result <> MMSYSERR_NOERROR then Exit;

  Result := TWaveInDeviceInfo.Create;
  Result.DeviceID := ADeviceID;
  Result.ManufacturerID := Caps.wMid;
  Result.ProductID := Caps.wPid;
  Result.DriverVersion := Caps.vDriverVersion;
  Result.ProductName := StrPas(Caps.szPname);
  set_WaveFormats(Result.WaveFormats, Caps.dwFormats);
  Result.Channels := Caps.wChannels;
  Result.DefaultDevice := (Result.DeviceID = 0);
end;

constructor TWaveInDeviceList.Create;
var
  DeviceID : Cardinal;
  WaveInDeviceInfo : TWaveInDeviceInfo;
begin
  FList := TList.Create;

  for DeviceID := 0 to waveInGetNumDevs-1 do begin
    WaveInDeviceInfo := get_WaveInDeviceInfo(DeviceID);
    if WaveInDeviceInfo = nil then Break;
    
    FList.Add(WaveInDeviceInfo);
  end;
end;

destructor TWaveInDeviceList.Destroy;
var
  Loop : Integer;
begin
  for Loop := 0 to Count-1 do TObject(FList[Loop]).Free;
  FList.Clear;
  FList.Free;

  inherited;
end;

function TWaveInDeviceList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TWaveInDeviceList.GetItem(Index: Integer): TWaveInDeviceInfo;
begin
  Result := Pointer(FList[Index]);
end;

function TWaveInDeviceList.IndexOfDevice(ADeviceID: Cardinal): Integer;
var
  Loop: Integer;
begin
  Result := -1;

  for Loop := 0 to Count-1 do begin
    if Items[Loop].DeviceID  = ADeviceID then begin
      Result := Loop;
      Break;
    end;
  end;
end;

function TWaveInDeviceList.IndexOfDeviceName(ADeviceName: String): Integer;
var
  Loop: Integer;
begin
  Result := -1;

  for Loop := 0 to Count-1 do begin
    if Items[Loop].ProductName  = ADeviceName then begin
      Result := Loop;
      Break;
    end;
  end;
end;

procedure TWaveInDeviceList.set_WaveFormats(var AWaveFormats: TWaveFormats;
  const dwFormats: DWORD);
begin
  AWaveFormats := [];

  if dwFormats and WAVE_FORMAT_1M08  <> 0 then AWaveFormats := AWaveFormats + [wf1M08 ];
  if dwFormats and WAVE_FORMAT_1S08  <> 0 then AWaveFormats := AWaveFormats + [wf1S08 ];
  if dwFormats and WAVE_FORMAT_1M16  <> 0 then AWaveFormats := AWaveFormats + [wf1M16 ];
  if dwFormats and WAVE_FORMAT_1S16  <> 0 then AWaveFormats := AWaveFormats + [wf1S16 ];
  if dwFormats and WAVE_FORMAT_2M08  <> 0 then AWaveFormats := AWaveFormats + [wf2M08 ];
  if dwFormats and WAVE_FORMAT_2S08  <> 0 then AWaveFormats := AWaveFormats + [wf2S08 ];
  if dwFormats and WAVE_FORMAT_2M16  <> 0 then AWaveFormats := AWaveFormats + [wf2M16 ];
  if dwFormats and WAVE_FORMAT_2S16  <> 0 then AWaveFormats := AWaveFormats + [wf2S16 ];
  if dwFormats and WAVE_FORMAT_4M08  <> 0 then AWaveFormats := AWaveFormats + [wf4M08 ];
  if dwFormats and WAVE_FORMAT_4S08  <> 0 then AWaveFormats := AWaveFormats + [wf4S08 ];
  if dwFormats and WAVE_FORMAT_4M16  <> 0 then AWaveFormats := AWaveFormats + [wf4M16 ];
  if dwFormats and WAVE_FORMAT_4S16  <> 0 then AWaveFormats := AWaveFormats + [wf4S16 ];
  if dwFormats and WAVE_FORMAT_44M08 <> 0 then AWaveFormats := AWaveFormats + [wf44M08];
  if dwFormats and WAVE_FORMAT_44S08 <> 0 then AWaveFormats := AWaveFormats + [wf44S08];
  if dwFormats and WAVE_FORMAT_44M16 <> 0 then AWaveFormats := AWaveFormats + [wf44M16];
  if dwFormats and WAVE_FORMAT_44S16 <> 0 then AWaveFormats := AWaveFormats + [wf44S16];
  if dwFormats and WAVE_FORMAT_48M08 <> 0 then AWaveFormats := AWaveFormats + [wf48M08];
  if dwFormats and WAVE_FORMAT_48S08 <> 0 then AWaveFormats := AWaveFormats + [wf48S08];
  if dwFormats and WAVE_FORMAT_48M16 <> 0 then AWaveFormats := AWaveFormats + [wf48M16];
  if dwFormats and WAVE_FORMAT_48S16 <> 0 then AWaveFormats := AWaveFormats + [wf48S16];
  if dwFormats and WAVE_FORMAT_96M08 <> 0 then AWaveFormats := AWaveFormats + [wf96M08];
  if dwFormats and WAVE_FORMAT_96S08 <> 0 then AWaveFormats := AWaveFormats + [wf96S08];
  if dwFormats and WAVE_FORMAT_96M16 <> 0 then AWaveFormats := AWaveFormats + [wf96M16];
  if dwFormats and WAVE_FORMAT_96S16 <> 0 then AWaveFormats := AWaveFormats + [wf96S16];
end;

end.
