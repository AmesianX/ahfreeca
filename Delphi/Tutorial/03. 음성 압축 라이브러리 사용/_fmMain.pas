unit _fmMain;

interface

uses
  VoiceRecorder, VoicePlayer,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    btRecordStart: TButton;
    btRecordStop: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    lbInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btRecordStartClick(Sender: TObject);
    procedure btRecordStopClick(Sender: TObject);
  private
    FMemoryStream : TMemoryStream;
  private
    FVoiceRecorder : TVoiceRecorder;
    procedure on_VoiceData(Sender:TObject; AData:pointer; ASize,AVolume:integer);
  private
    FVoicePlayer : TVoicePlayer;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{ TfmMain }

procedure TfmMain.btRecordStartClick(Sender: TObject);
begin
  FMemoryStream.Clear;
  FVoiceRecorder.Start;
end;

procedure TfmMain.btRecordStopClick(Sender: TObject);
var
  Buffer : array [0..1024-1] of byte;
begin
  FVoiceRecorder.Stop;

  FMemoryStream.Position := 0;
  while FMemoryStream.Position < FMemoryStream.Size do begin
    if FVoicePlayer.IsBusy then begin
      Sleep(10);
      Continue;
    end;

    FMemoryStream.Read( Buffer, 62 );
    FVoicePlayer.DataIn( @Buffer, 62 );

    lbInfo.Caption := Format( 'TfmMain.btRecordStopClick - AVolume: %d', [FVoicePlayer.VolumeOut] );
    lbInfo.Repaint;
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FMemoryStream := TMemoryStream.Create;

  FVoiceRecorder := TVoiceRecorder.Create(Self);
  FVoiceRecorder.OnData := on_VoiceData;

  FVoicePlayer := TVoicePlayer.Create(Self);
  FVoicePlayer.Start;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FMemoryStream);
  FreeAndNil(FVoiceRecorder);
  FreeAndNil(FVoicePlayer);
end;

procedure TfmMain.on_VoiceData(Sender: TObject; AData: pointer; ASize,
  AVolume: integer);
begin
  lbInfo.Caption := Format( 'TfmMain.on_VoiceData - Size: %d, AVolume: %d', [ASize, AVolume] );
  FMemoryStream.Write( AData^, ASize );
end;

end.
