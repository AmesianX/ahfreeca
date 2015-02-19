unit _fmMain;

interface

uses
  ValueList,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UiTypes;

type
  TfmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
  public
  published
    procedure rp_OkLogin(AParams:TValueList);
  end;

var
  fmMain: TfmMain;

implementation

uses
  Core, ClientUnit,
  _fmMain.frLoginLayout,
  _fmMain.frLoginedLayout;

{$R *.dfm}

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TCore.Obj.View.Remove( Self );
  TCore.Obj.Finalize;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  TCore.Obj.View.Add( Self );
  TCore.Obj.Initialize;

  _fmMain.frLoginedLayout.Prepare(Self);

  _fmMain.frLoginLayout.SetLayout( Self );
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  TClientUnit.Obj.Connect;
end;

procedure TfmMain.rp_OkLogin(AParams: TValueList);
begin
  _fmMain.frLoginedLayout.SetLayout( Self );
  TCore.Obj.View.sp_ViewIsReady;
end;

end.
