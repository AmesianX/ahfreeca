unit _frVoice;

interface

uses
  FrameBase, ValueList,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrVoice = class(TFrame, IFrameBase)
    cbMic: TCheckBox;
    procedure cbMicClick(Sender: TObject);
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
  Core, VoiceIn;

{$R *.dfm}

{ TfrVoice }

procedure TfrVoice.AfterShow;
begin

end;

procedure TfrVoice.BeforeShow;
begin

end;

procedure TfrVoice.cbMicClick(Sender: TObject);
begin
  if cbMic.Checked then TVoiceIn.Obj.Start
  else TVoiceIn.Obj.Stop;
end;

procedure TfrVoice.BeforeClose;
begin

end;

constructor TfrVoice.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrVoice.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

end.