unit _frControlBoxReceiver;

interface

uses
  Config,
  DebugTools, FrameBase, ValueList, Disk, RyuGraphics,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, MusicTrackBar, SwitchButton, Vcl.StdCtrls, BitmapTile;

type
  TfrControlBoxReceiver = class(TFrame, IFrameBase)
    BitmapTile1: TBitmapTile;
    LevelMeterBack: TShape;
    lbVolume: TLabel;
    LevelMeter: TShape;
    btSpeaker: TSwitchButton;
    Volume: TMusicTrackBar;
    Timer: TTimer;
    procedure btSpeakerClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure VolumeChanged(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Core, VoiceReceiver;

{$R *.dfm}

{ TfrCamReceiver }

procedure TfrControlBoxReceiver.AfterShow;
begin

end;

procedure TfrControlBoxReceiver.BeforeClose;
begin

end;

procedure TfrControlBoxReceiver.BeforeShow;
begin

end;

procedure TfrControlBoxReceiver.btSpeakerClick(Sender: TObject);
begin
  btSpeaker.SwitchOn := not btSpeaker.SwitchOn;
  TVoiceReceiver.Obj.IsMute := not btSpeaker.SwitchOn;
end;

constructor TfrControlBoxReceiver.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrControlBoxReceiver.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrControlBoxReceiver.TimerTimer(Sender: TObject);
var
  Color : TColor;
  iVolumeInPercent : integer;
begin
  Timer.Enabled := false;
  try
    iVolumeInPercent := 100 * TVoiceReceiver.Obj.VolumeOut div ($FFFF div 2);

    LevelMeter.Width := LevelMeterBack.Width * iVolumeInPercent div 100;

    if iVolumeInPercent > 80 then Color := clRed
    else if iVolumeInPercent > 60 then Color := clYellow
    else Color := $0019F81D;

    LevelMeter.Brush.Color := Color;
    LevelMeter.Pen.Color   := Color;
  finally
    Timer.Enabled := true;
  end;
end;

procedure TfrControlBoxReceiver.VolumeChanged(Sender: TObject);
begin
  TVoiceReceiver.Obj.Volume := Volume.Position / 100;
  lbVolume.Caption := Format( '%d%%', [Volume.Position div 10] );
end;

end.