/// TView 정의되고 구현된 유닛이다.
unit View;

interface

uses
  ObserverList, ValueList,
  Classes, SysUtils;

type
  ///  Core에서 UI 객체에게 메시지를 전달하는 과정을 대신 해 준다.
  TView = class (TComponent)
  private
    function GetActive: boolean;
    procedure SetActive(const Value: boolean);
  protected
    FObserverList : TObserverList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Add(Observer:TObject);  /// 메시지를 수신 할 객체를 등록한다.
    procedure Remove(Observer:TObject);  /// Observer에게 메시지 전송을 중단한다.

    procedure sp_Initialize;  /// TCore가 초기화 됐다.
    procedure sp_Finalize;    /// TCore의 종료처리가 시작됐다.

    procedure sp_ViewIsReady;  /// 모든 View 객체들이 생성 되었다.
  published
    property Active : boolean read GetActive write SetActive;  /// 메시지 전송 중인 가?
  end;

implementation

{ TView }

procedure TView.Add(Observer: TObject);
begin
  FObserverList.Add(Observer);
end;

constructor TView.Create(AOwner: TComponent);
begin
  inherited;

  FObserverList := TObserverList.Create(nil);
end;

destructor TView.Destroy;
begin
  FreeAndNil(FObserverList);

  inherited;
end;

function TView.GetActive: boolean;
begin
  Result := FObserverList.Active;
end;

procedure TView.Remove(Observer: TObject);
begin
  FObserverList.Remove(Observer);
end;

procedure TView.SetActive(const Value: boolean);
begin
  FObserverList.Active := Value;
end;

procedure TView.sp_Finalize;
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'Finalize';
    FObserverList.Broadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TView.sp_Initialize;
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'Initialize';
    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

procedure TView.sp_ViewIsReady;
var
  Params : TValueList;
begin
  Params := TValueList.Create;
  try
    Params.Values['Code'] := 'ViewIsReady';
    FObserverList.AsyncBroadcast(Params);
  finally
    Params.Free;
  end;
end;

end.
