unit ClientUnit.TextClient.UserList;

interface

uses
  ValueList, UserLevel,
  Generics.Collections,
  Windows, Classes, SysUtils, ComCtrls, SyncObjs;

type
  TUserInfo = class
  private
    FIsNewObject : boolean;
    FText: string;
    FUserID: string;
    FUserLevel: integer;
    FIsMute: boolean;
    procedure SetText(const Value: string);
  public
    constructor Create(AValueList: TValueList); reintroduce;

    property UserID : string read FUserID;
    property UserLevel : integer read FUserLevel;
    property IsMute : boolean read FIsMute;
    property Text : string read FText write SetText;
  end;

  TUserList = class
  private
    FCS : TCriticalSection;
    FList : TList<TUserInfo>;
    function get_FindUserInfo(AUserID:string):TUserInfo;
    procedure do_UserIn(AValueList:TValueList);
  private
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure UserIn(AText:string);
    procedure UserOut(AText:string);

    procedure SetUserInfo(AText:string);
    procedure SetUserLevel(AText:string);
    procedure SetUserMuteStatus(AText:string);

    function FindUserID(AUserID:string):boolean;

    function GetUserLevel(AUserID:string):integer;
    function GetUserMuteStatus(AUserID:string):boolean;

    procedure Update(AListView:TListView);
  public
    property Count : integer read GetCount;
  end;

implementation

{ TUserInfo }

constructor TUserInfo.Create(AValueList: TValueList);
begin
  inherited Create;

  FUserID := Trim(AValueList.Values['UserID']);
  FUserLevel := AValueList.Integers['UserLevel'];
  FIsMute := AValueList.Booleans['IsMute'];
  FText := AValueList.Text;
end;

procedure TUserInfo.SetText(const Value: string);
var
  ValueList : TValueList;
begin
  FText := Value;

  ValueList := TValueList.Create;
  try
    ValueList.Text := Value;

    FUserID := Trim(ValueList.Values['UserID']);
    FUserLevel := ValueList.Integers['UserLevel'];
    FIsMute := ValueList.Booleans['IsMute'];
  finally
    ValueList.Free;
  end;
end;

{ TUserList }

procedure TUserList.Clear;
var
  Loop: Integer;
begin
  FCS.Enter;
  try
    for Loop := 0 to FList.Count-1 do FList[Loop].Free;
    FList.Clear;
  finally
    FCS.Leave;
  end;
end;

constructor TUserList.Create;
begin
  inherited;

  FCS := TCriticalSection.Create;
  FList := TList<TUserInfo>.Create;
end;

destructor TUserList.Destroy;
begin
  Clear;

  FreeAndNil(FCS);
  FreeAndNil(FList);

  inherited;
end;

procedure TUserList.do_UserIn(AValueList: TValueList);
var
  UserInfo : TUserInfo;
begin
  if Trim(AValueList.Values['UserID']) = '' then Exit;
  UserInfo := get_FindUserInfo(Trim(AValueList.Values['UserID']));

  if UserInfo = nil then
    FList.Add(TUserInfo.Create(AValueList))
  else
    UserInfo.Text := AValueList.Text;
end;

function TUserList.FindUserID(AUserID: string): boolean;
var
  UserInfo : TUserInfo;
begin
  FCS.Enter;
  try
    UserInfo := get_FindUserInfo(AUserID);
    Result := UserInfo <> nil;
  finally
    FCS.Leave;
  end;
end;

function TUserList.GetCount: integer;
begin
  FCS.Enter;
  try
    Result := FList.Count;
  finally
    FCS.Leave;
  end;
end;

function TUserList.GetUserLevel(AUserID: string): integer;
var
  UserInfo : TUserInfo;
begin
  Result := 0;

  FCS.Enter;
  try
    UserInfo := get_FindUserInfo(AUserID);
    if UserInfo <> nil then Result := UserInfo.UserLevel;
  finally
    FCS.Leave;
  end;
end;

function TUserList.GetUserMuteStatus(AUserID: string): boolean;
var
  UserInfo : TUserInfo;
begin
  Result := false;

  FCS.Enter;
  try
    UserInfo := get_FindUserInfo(AUserID);
    if UserInfo <> nil then Result := UserInfo.IsMute;
  finally
    FCS.Leave;
  end;
end;

function TUserList.get_FindUserInfo(AUserID: string): TUserInfo;
var
  Loop: Integer;
begin
  Result := nil;

  for Loop := 0 to FList.Count-1 do begin
    if FList[Loop].UserID = AUserID then begin
      Result := FList[Loop];
      Break;
    end;
  end;
end;

procedure TUserList.SetUserInfo(AText: string);
var
  ValueList : TValueList;
  UserInfo : TUserInfo;
begin
  ValueList := TValueList.Create;
  try
    ValueList.Text := AText;

    FCS.Enter;
    try
      UserInfo := get_FindUserInfo(ValueList.Values['UserID']);
      if UserInfo <> nil then UserInfo.Text := AText;
    finally
      FCS.Leave;
    end;
  finally
    ValueList.Free;
  end;
end;

procedure TUserList.SetUserLevel(AText: string);
var
  ValueList : TValueList;
  UserInfo : TUserInfo;
begin
  ValueList := TValueList.Create;
  try
    ValueList.Text := AText;

    FCS.Enter;
    try
      UserInfo := get_FindUserInfo(ValueList.Values['UserID']);
      if UserInfo <> nil then UserInfo.FUserLevel := ValueList.Integers['UserLevel'];
    finally
      FCS.Leave;
    end;
  finally
    ValueList.Free;
  end;
end;

procedure TUserList.SetUserMuteStatus(AText: string);
var
  ValueList : TValueList;
  UserInfo : TUserInfo;
begin
  ValueList := TValueList.Create;
  try
    ValueList.Text := AText;

    FCS.Enter;
    try
      UserInfo := get_FindUserInfo(ValueList.Values['UserID']);
      if UserInfo <> nil then UserInfo.FIsMute := ValueList.Booleans['Mute'];
    finally
      FCS.Leave;
    end;
  finally
    ValueList.Free;
  end;
end;

procedure SetImageIndex(AListItem:TListItem; AUserInfo:TUserInfo);
begin
  if AUserInfo.IsMute then begin
    AListItem.ImageIndex := 1;
  end else begin
    case AUserInfo.UserLevel of
      TUserLevel.NORMAL_USER: AListItem.ImageIndex := -1;
      TUserLevel.ADMIN : AListItem.ImageIndex := 0;
      TUserLevel.ROOM_MASTER: AListItem.ImageIndex := 0;
      else AListItem.ImageIndex := -1;
    end;
  end;
end;

procedure TUserList.Update(AListView: TListView);
var
  Loop : Integer;
  UserInfo : TUserInfo;
  ListItem : TListItem;
begin
  FCS.Enter;
  try
    for Loop := 0 to FList.Count-1 do FList[Loop].FIsNewObject := true;

    AListView.Items.BeginUpdate;
    try
      for Loop := AListView.Items.Count-1 downto 0 do begin
        ListItem := AListView.Items[Loop];

        UserInfo := get_FindUserInfo(ListItem.Caption);

        if UserInfo = nil then begin
          AListView.Items[Loop].Free;
        end else begin
          UserInfo.FIsNewObject := false;
          SetImageIndex(ListItem, UserInfo);
        end;
      end;

      for Loop := 0 to FList.Count-1 do begin
        if FList[Loop].FIsNewObject then begin
          ListItem := AListView.Items.Add;
          ListItem.Caption := FList[Loop].UserID;
          SetImageIndex(ListItem, FList[Loop]);
          ListItem.SubItems.Add('');
        end;
      end;
    finally
      AListView.Items.EndUpdate;
    end;
  finally
    FCS.Leave;
  end;
end;

procedure TUserList.UserIn(AText: string);
var
  Loop : Integer;
  Source, stlTemp : TValueList;
begin
  Source := TValueList.Create;
  stlTemp := TValueList.Create;
  try
    Source.Text := AText;

    for Loop := 0 to Source.Count-1 do  begin
      stlTemp.Add(Source.Strings[Loop]);
      if Source.Strings[Loop] = 'end.' then begin

        FCS.Enter;
        try
          do_UserIn(stlTemp);
        finally
          FCS.Leave;
        end;

        stlTemp.Clear;
      end;
    end;

    if stlTemp.Count > 0 then do_UserIn(stlTemp);
  finally
    Source.Free;
    stlTemp.Free;
  end;
end;

procedure TUserList.UserOut(AText: string);
var
  Loop: Integer;
  Source : TValueList;
begin
  Source := TValueList.Create;
  try
    Source.Text := AText;

    FCS.Enter;
    try
      for Loop := 0 to FList.Count-1 do begin
        if FList[Loop].UserID = Trim(Source.Values['UserID']) then begin
          FList.Delete(Loop);
          Break;
        end;
      end;
    finally
      FCS.Leave;
    end;
  finally
    Source.Free;
  end;
end;

end.
