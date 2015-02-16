unit Option;

interface

uses
  Para, Strg, Disk,
  SysUtils, Classes;

type
  /// 프로그램의 각종 옵션을 관리하는 클래스
  TOption = class
  private
    FIniFileName : string;
  private
    FUserID: string;
    FUserPW: string;
    function GetChatFontSize: integer;
    procedure SetChatFontSize(const Value: integer);
    function GetAlarmSound: string;
    procedure SetAlarmSound(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
  public
    /// 접속자의 계정 아이디
    property UserID : string read FUserID;

    /// 접속자의 계정 암호
    property UserPW : string read FUserPW;

    /// 채팅 문자 수신 등의 변화에 따라 경고음을 출력 할 것인가?
    property AlarmSound : string read GetAlarmSound write SetAlarmSound;

    /// 채팅 문자의 폰트 크기
    property ChatFontSize : integer read GetChatFontSize write SetChatFontSize;
  end;

implementation

{ TOption }

constructor TOption.Create;
begin
  inherited;

  FIniFileName := DeleteRight(ParamStr(0), '.') + 'ini';

  FUserID := GetSwitchValue('UserID');
  FUserPW := GetSwitchValue('UserPW');
end;

destructor TOption.Destroy;
begin

  inherited;
end;

function TOption.GetAlarmSound: string;
begin
  Result := IniString( FIniFileName, 'Chat', 'AlarmSound', 'SystemAsterisk' );
end;

function TOption.GetChatFontSize: integer;
begin
  Result := IniInteger( FIniFileName, 'Chat', 'FontSize', 10 );
end;

procedure TOption.SetAlarmSound(const Value: string);
begin
  WriteIniStr( FIniFileName, 'Chat', 'AlarmSound', Value );
end;

procedure TOption.SetChatFontSize(const Value: integer);
begin
  if Value in [8, 10, 14] then
    WriteIniInt( FIniFileName, 'Chat', 'FontSize', Value );
end;

end.

