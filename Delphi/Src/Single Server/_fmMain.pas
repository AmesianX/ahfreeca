unit _fmMain;

interface

uses
  ServerUnit,
  DebugTools,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.AppEvnts;

type
  TfmMain = class(TForm)
    tmClose: TTimer;
    ApplicationEvents: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure tmCloseTimer(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  private
    FServerUnit : TServerUnit;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  Trace( Format('%s - %s', [ParamStr(0), E.Message]) );
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Caption := '종료 중입니다.  잠시만 기다려 주세요.';

  Action := caNone;
  FServerUnit.Stop;
  tmClose.Enabled := true;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FServerUnit := TServerUnit.Create;
  FServerUnit.Start;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FServerUnit);
end;

procedure TfmMain.tmCloseTimer(Sender: TObject);
begin
  Application.Terminate;
end;

end.
