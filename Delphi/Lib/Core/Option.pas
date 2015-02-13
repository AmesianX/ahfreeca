unit Option;

interface

uses
  Para, Strg, Disk,
  SysUtils, Classes;

type
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
    property UserID : string read FUserID;
    property UserPW : string read FUserPW;

    property AlarmSound : string read GetAlarmSound write SetAlarmSound;
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
