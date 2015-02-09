unit _fmMain;

interface

uses
  EasyCam, VideoZip,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    plCam: TPanel;
    Panel1: TPanel;
    btCamOn: TButton;
    btCamOff: TButton;
    Image: TImage;
    btVideoZipStart: TButton;
    btVideoZipStop: TButton;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btCamOnClick(Sender: TObject);
    procedure btCamOffClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btVideoZipStartClick(Sender: TObject);
    procedure btVideoZipStopClick(Sender: TObject);
  private
    FEasyCam : TEasyCam;
  private
    FEncoder : TVideoZipEncoder;
    procedure on_VideoZipEncoder_Data(Sender:TObject; AData:pointer; ASize:integer);
  public
    FDecoder : TVideoZipDecoder;
  private
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btCamOffClick(Sender: TObject);
begin
  FEasyCam.Close;
end;

procedure TfmMain.btCamOnClick(Sender: TObject);
begin
  FEasyCam.Open(320, 240);
end;

procedure TfmMain.btVideoZipStartClick(Sender: TObject);
begin
  Timer.OnTimer := TimerTimer;
end;

procedure TfmMain.btVideoZipStopClick(Sender: TObject);
begin
  Timer.OnTimer := nil;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Image.Picture.Bitmap.Width  := 320;
  Image.Picture.Bitmap.Height := 240;

  FEasyCam := TEasyCam.Create(Self);
  FEasyCam.Align := alClient;
  FEasyCam.Parent := plCam;

  FEncoder := TVideoZipEncoder.Create(Self);
  FEncoder.Width  := 320;
  FEncoder.Height := 240;
  FEncoder.OnData := on_VideoZipEncoder_Data;
  FEncoder.Open;

  FDecoder := TVideoZipDecoder.Create(Self);
  FDecoder.Width  := 320;
  FDecoder.Height := 240;
  FDecoder.Open;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEasyCam);
  FreeAndNil(FEncoder);
  FreeAndNil(FDecoder);
end;

procedure TfmMain.on_VideoZipEncoder_Data(Sender: TObject; AData: pointer;
  ASize: integer);
begin
  Caption := Format('TfmMain.on_VideoZipEncoder_Data - ASize: %d', [ASize]);
  if FDecoder.Decode(Image.Picture.Bitmap,  AData, ASize) then Image.Repaint;
end;

procedure TfmMain.TimerTimer(Sender: TObject);
var
  Bitmap : TBitmap;
begin
  Timer.Enabled := false;
  Bitmap := TBitmap.Create;
  try
    if FEasyCam.GetBitmap(Bitmap) then FEncoder.Encode(Bitmap);
  finally
    Bitmap.Free;
    Timer.Enabled := true;
  end;
end;

end.
