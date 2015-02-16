unit _frUserList;

interface

uses
  ValueList, UserLevel,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.ImgList;

type
  TfrUserList = class(TFrame)
    UserList: TListView;
    PopupMenu: TPopupMenu;
    miKickOut: TMenuItem;
    miMute: TMenuItem;
    ImageList: TImageList;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    tmUserList: TTimer;
    procedure miKickOutClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure UserListColumnClick(Sender: TObject; Column: TListColumn);
    procedure UserListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure miMuteClick(Sender: TObject);
    procedure tmUserListTimer(Sender: TObject);
  private
    FUserListUpdated : boolean;
  private
    FIsAdmin: boolean;
    FAssendingSort: boolean;
    function GetSelectedUserIDs: string;
    procedure SetIsAdmin(const Value: boolean);
    procedure SetAssendingSort(const Value: boolean);
    function GetSelectedUserID: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ClearSelectedUsers;
  published
    property IsAdmin : boolean read FIsAdmin write SetIsAdmin;
    property AssendingSort : boolean read FAssendingSort write SetAssendingSort;
    property SelectedUserID : string read GetSelectedUserID;
    property SelectedUserIDs : string read GetSelectedUserIDs;
  published
    procedure rp_UserOut(APacket:TValueList);
    procedure rp_UserListChanged(APacket: TValueList);
  end;

implementation

uses
  Core, Frames, ClientUnit;

{$R *.dfm}

{ TfrUserList }

procedure TfrUserList.ClearSelectedUsers;
var
  Loop : Integer;
begin
  for Loop := 0 to UserList.Items.Count-1 do UserList.Items[Loop].Checked := false;
end;

constructor TfrUserList.Create(AOwner: TComponent);
begin
  inherited;

  TFrames.Obj.UserList := Self;

  FUserListUpdated := true;
  FAssendingSort := true;

  if TClientUnit.Obj.TextClient.IsSender then UserList.PopupMenu := PopupMenu;

  TCore.Obj.View.Add(Self);
end;

destructor TfrUserList.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

function TfrUserList.GetSelectedUserID: string;
var
  ListItem : TListItem;
begin
  Result := '';

  ListItem := UserList.Selected;
  if ListItem = nil then Exit;

  Result := ListItem.Caption;
end;

function TfrUserList.GetSelectedUserIDs: string;
var
  Loop : Integer;
begin
  Result := '';
  for Loop := 0 to UserList.Items.Count-1 do
    if UserList.Items[Loop].Checked then Result := Result + UserList.Items[Loop].Caption + ', ';
end;

procedure TfrUserList.miKickOutClick(Sender: TObject);
begin
  if MessageDlg('해당 사용자를 강퇴하시겠습니까?', mtConfirmation, [mbOK, mbNo], 0) <> mrOk then Exit;

  if (SelectedUserID <> '') and (SelectedUserID <> TCore.Obj.Option.UserID) then
    TClientUnit.Obj.TextClient.sp_KickOut(SelectedUserID);
end;

procedure TfrUserList.miMuteClick(Sender: TObject);
begin
  if (SelectedUserID <> '') and (SelectedUserID <> TCore.Obj.Option.UserID) then begin
    miMute.Checked := not miMute.Checked;
    TClientUnit.Obj.TextClient.sp_Mute(SelectedUserID, miMute.Checked);
  end;
end;

procedure TfrUserList.PopupMenuPopup(Sender: TObject);
var
  isCondition : boolean;
begin
  isCondition :=
    (SelectedUserID <> '') and
    (SelectedUserID <> TCore.Obj.Option.UserID);

  miKickOut.Enabled := isCondition;
  miMute.Enabled := isCondition;

  miMute.Checked := TClientUnit.Obj.TextClient.GetUserMuteStatus(SelectedUserID);
end;

procedure TfrUserList.rp_UserListChanged(APacket: TValueList);
begin
  FUserListUpdated := true;
end;

procedure TfrUserList.rp_UserOut(APacket: TValueList);
begin
  FUserListUpdated := true;
end;

procedure TfrUserList.SetAssendingSort(const Value: boolean);
begin
  FAssendingSort := Value;
  UserList.AlphaSort;
end;

procedure TfrUserList.SetIsAdmin(const Value: boolean);
begin
  FIsAdmin := Value;

  if Value then UserList.PopupMenu := PopupMenu
  else UserList.PopupMenu := nil;
end;

procedure TfrUserList.tmUserListTimer(Sender: TObject);
begin
  tmUserList.Enabled := false;
  try
    if FUserListUpdated then begin
      FUserListUpdated := false;
      TClientUnit.Obj.TextClient.GetUserList(UserList);
    end;
  finally
    tmUserList.Enabled := true;
  end;
end;

procedure TfrUserList.UserListColumnClick(Sender: TObject; Column: TListColumn);
begin
  AssendingSort := not AssendingSort;
end;

procedure TfrUserList.UserListCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  if Item1.Caption > Item2.Caption then Compare := 1
  else if Item1.Caption < Item2.Caption then Compare := -1
  else Compare := 0;

  if not FAssendingSort then Compare := - Compare;
end;

end.
