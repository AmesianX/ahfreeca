unit Option;

interface

uses
  Config,
  Para, Strg, Disk,
  SysUtils, Classes;

type
  /// 프로그램의 각종 옵션을 관리하는 클래스
  TOption = class
  private
    FIniFileName : string;
    procedure load_IniFile;
  private
    FUserID: string;
    FUserPW: string;
    FCamWidth: integer;
    FCamHeight: integer;
    FAlarmSound: string;
    FChatFontSize: integer;
    FHost: string;
    procedure SetChatFontSize(const Value: integer);
    procedure SetAlarmSound(const Value: string);
    procedure SetCamHeight(const Value: integer);
    procedure SetCamWidth(const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;
  public
    // 접속 할 서버의 주소
    property Host : string read FHost;

    /// 접속자의 계정 아이디
    property UserID : string read FUserID;

    /// 접속자의 계정 암호
    property UserPW : string read FUserPW;

    /// 채팅 문자 수신 등의 변화에 따라 경고음을 출력 할 것인가?
    property AlarmSound : string read FAlarmSound write SetAlarmSound;

    /// 채팅 문자의 폰트 크기
    property ChatFontSize : integer read FChatFontSize write SetChatFontSize;

    /// 캠 화면의 넓이 (픽셀 단위)
    property CamWidth : integer read FCamWidth write SetCamWidth;

    /// 캠 화면의 높이 (픽셀 단위)
    property CamHeight : integer read FCamHeight write SetCamHeight;
  end;

implementation

{ TOption }

constructor TOption.Create;
begin
  inherited;

  if FindSwitchName('Host') then FHost := GetSwitchValue('Host')
  else FHost := SERVER_HOST;

  FUserID := GetSwitchValue('UserID');
  FUserPW := GetSwitchValue('UserPW');

  FIniFileName := DeleteRight(ParamStr(0), '.') + 'ini';
  load_IniFile;
end;

destructor TOption.Destroy;
begin

  inherited;
end;

procedure TOption.load_IniFile;
begin
  FAlarmSound   := IniString(  FIniFileName, 'Chat', 'AlarmSound', 'SystemAsterisk' );
  FChatFontSize := IniInteger( FIniFileName, 'Chat', 'FontSize',   10 );

  FCamWidth  := IniInteger( FIniFileName, 'Cam', 'Width',  VIDEO_WIDTH );
  FCamHeight := IniInteger( FIniFileName, 'Cam', 'Height', VIDEO_HEIGHT );
end;

procedure TOption.SetAlarmSound(const Value: string);
begin
  WriteIniStr( FIniFileName, 'Chat', 'AlarmSound', Value );
end;

procedure TOption.SetCamHeight(const Value: integer);
begin
  FCamHeight := Value;
  WriteIniInt( FIniFileName, 'Cam', 'Height', Value );
end;

procedure TOption.SetCamWidth(const Value: integer);
begin
  FCamWidth := Value;
  WriteIniInt( FIniFileName, 'Cam', 'Width', Value );
end;

procedure TOption.SetChatFontSize(const Value: integer);
begin
  if Value in [8, 10, 14] then
    WriteIniInt( FIniFileName, 'Chat', 'FontSize', Value );
end;

end.

