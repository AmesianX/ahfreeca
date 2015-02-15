unit _frChat;

interface

uses
  DebugTools, ValueList, RyuGraphics, RichEditPlus, UserLevel,
  MMSystem, ShellAPI, Types,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.Buttons, Vcl.Imaging.pngimage, SwitchButton;

const
  WM_Lock = WM_USER + 1;
  WM_Unlock = WM_USER + 2;

type
  TRichEdit = class (TRichEditPlus);

  TfrChat = class(TFrame)
    plMain: TPanel;
    plChatInput: TPanel;
    cbWhisper: TCheckBox;
    edMsg: TMemo;
    moChat: TRichEdit;
    PopupMenu: TPopupMenu;
    miClear: TMenuItem;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    lbFontColor: TLabel;
    lbFontSize: TLabel;
    btLock: TSwitchButton;
    procedure ColorBoxChange(Sender: TObject);
    procedure miClearClick(Sender: TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure edMsgKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edMsgKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbFontSizeKeyPress(Sender: TObject; var Key: Char);
    procedure cbFontSizeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbFontSizeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbFontColorClick(Sender: TObject);
    procedure lbFontSizeClick(Sender: TObject);
    procedure btLockClick(Sender: TObject);
  private
    procedure on_TURLClick(Sender:TObject; const AURL:string);
  private
    procedure on_FontColorSelected(Sender:TObject; AValue:Integer);
  private
    function GetVisibleOfInput: boolean;
    procedure SetVisibleOfInput(const Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property VisibleOfInput : boolean read GetVisibleOfInput write SetVisibleOfInput;
  published
    procedure rp_ViewIsReady(APacket: TValueList);

    procedure rp_SystemMessage(APacket: TValueList);
    procedure rp_Notice(APacket: TValueList);

    procedure rp_Chat(APacket: TValueList);
    procedure rp_Whisper(APacket: TValueList);
    procedure rp_ClearChatMessages(APacket: TValueList);

    procedure rp_KickOut(APacket:TValueList);
    procedure rp_UserLevel(APacket:TValueList);
    procedure rp_Mute(APacket:TValueList);

    procedure rp_CallSender(APacket:TValueList);
  end;

implementation

uses
  Core, Frames, ClientUnit, SelectColorDialog;

{$R *.dfm}

{ TfrChat }

procedure TfrChat.ColorBoxChange(Sender: TObject);
begin
  edMsg.SetFocus;
end;

procedure TfrChat.btLockClick(Sender: TObject);
begin
  btLock.SwitchOn := not btLock.SwitchOn;

  if btLock.SwitchOn then begin
    moChat.HideSelection := true
  end else begin
    moChat.HideSelection := false;

    moChat.SetFocus;
    moChat.SelStart := moChat.GetTextLen;
    moChat.Perform(EM_SCROLLCARET, 0, 0);

    edMsg.SetFocus;
  end;
end;

procedure TfrChat.cbFontSizeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
end;

procedure TfrChat.cbFontSizeKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TfrChat.cbFontSizeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
end;

constructor TfrChat.Create(AOwner: TComponent);
begin
  inherited;

  DoubleBuffered := true;
  ControlStyle := ControlStyle + [csOpaque];

  moChat.HideSelection := False;
  moChat.OnURLClick := on_TURLClick;

  VisibleOfInput := not TClientUnit.Obj.TextClient.GetUserMuteStatus( TCore.Obj.Option.UserID );

  lbFontSize.Caption := IntToStr(TCore.Obj.Option.ChatFontSize) + ' pt';

  moChat.Font.Size := TCore.Obj.Option.ChatFontSize;
  edMsg.Font.Size  := TCore.Obj.Option.ChatFontSize;

  TCore.Obj.View.Add(Self);
end;

destructor TfrChat.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

function DeleteRightReturnChars(AStr:string):string;
var
  Loop: Integer;
  isReturnChar : boolean;
begin
  Result := '';

  isReturnChar := true;
  for Loop := Length(AStr) downto 1 do begin
    if isReturnChar then isReturnChar := CharInSet(AStr[Loop], [#13, #10]);
    if not isReturnChar then Result := AStr[Loop] + Result;
  end;
end;

procedure TfrChat.edMsgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sMsg, sUserIDs : string;
begin
  if (Key = VK_RETURN) and (Shift <> [ssShift]) then begin
    Key := 0;

    sMsg := DeleteRightReturnChars(Trim(edMsg.Text));
    edMsg.Text := '';

    if sMsg = '' then Exit;

    if cbWhisper.Checked then begin
      sUserIDs := TFrames.Obj.UserList.SelectedUserIDs;

      if sUserIDs = '' then begin
        try
          moChat.SelAttributes.Color := clRed;
          moChat.SelText := '* 귓속말을 받을 사용자를 선택 하세요.' + #13;
        except
          moChat.Lines.Clear;
        end;
      end else begin
        TClientUnit.Obj.TextClient.sp_Whisper(TCore.Obj.Option.UserID, sUserIDs, sMsg, lbFontColor.Font.Color);
      end;
    end else begin
      TClientUnit.Obj.TextClient.sp_Chat(TCore.Obj.Option.UserID, sMsg, lbFontColor.Font.Color);
    end;
  end;
end;

procedure TfrChat.edMsgKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (Shift <> [ssShift]) then begin
    Key := 0;

    edMsg.Text := '';
  end;
end;

function TfrChat.GetVisibleOfInput: boolean;
begin
  Result := plChatInput.Visible;
end;

procedure TfrChat.lbFontColorClick(Sender: TObject);
var
  Pos : TPoint;
begin
  Pos := Point( (lbFontColor.Width  div 2), (lbFontColor.Height div 2) );
  Pos := lbFontColor.ClientToScreen( Pos );

  ShowSelectColorDialog( Pos.X, Pos.Y, lbFontColor.Font.Color, on_FontColorSelected );
end;

procedure TfrChat.lbFontSizeClick(Sender: TObject);
begin
  case TCore.Obj.Option.ChatFontSize of
    8: TCore.Obj.Option.ChatFontSize := 10;
    10: TCore.Obj.Option.ChatFontSize := 14;
    else TCore.Obj.Option.ChatFontSize := 8;
  end;

  lbFontSize.Caption := IntToStr(TCore.Obj.Option.ChatFontSize) + ' pt';

  moChat.Font.Size := TCore.Obj.Option.ChatFontSize;
  edMsg.Font.Size := TCore.Obj.Option.ChatFontSize;
end;

procedure TfrChat.miClearClick(Sender: TObject);
begin
  moChat.Lines.Clear;
end;

procedure TfrChat.miSelectAllClick(Sender: TObject);
begin
  moChat.SelectAll;
end;

procedure TfrChat.on_FontColorSelected(Sender: TObject; AValue: Integer);
begin
  lbFontColor.Font.Color := AValue;
  edMsg.Font.Color := AValue;
end;

procedure TfrChat.on_TURLClick(Sender: TObject; const AURL: string);
begin
  ShellExecute(Handle, 'open', PChar(AURL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrChat.rp_ClearChatMessages(APacket: TValueList);
begin
  moChat.Lines.Clear;
end;

procedure TfrChat.rp_KickOut(APacket: TValueList);
begin
  try
    moChat.SelAttributes.Color := lbFontColor.Font.Color;
    moChat.SelText := APacket.Values['UserID'];

    moChat.SelAttributes.Color := clRed;
    moChat.SelText := '님께서 강퇴 되셨습니다.'#13;
  except
    moChat.Lines.Clear;
  end;
end;

procedure TfrChat.rp_Mute(APacket: TValueList);
begin
  try
    moChat.SelAttributes.Color := lbFontColor.Font.Color;
    moChat.SelText := APacket.Values['UserID'];

    moChat.SelAttributes.Color := clRed;

    if APacket.Booleans['Mute'] then moChat.SelText := '님께서 채팅금지가 되었습니다.'#13
    else moChat.SelText := '님께서 채팅금지 해제 되었습니다.'#13;
  except
    moChat.Lines.Clear;
  end;

  if TCore.Obj.Option.UserID = APacket.Values['UserID'] then VisibleOfInput := not APacket.Booleans['Mute'];
end;

procedure TfrChat.rp_Notice(APacket: TValueList);
begin
  try
    moChat.SelAttributes.Color := clRed;
    moChat.SelText := '전체공지: ' + APacket.Values['Msg'] + #13;
  except
    moChat.Lines.Clear;
  end;

  RyuGraphics.FalshWindow(Application.MainForm.Handle, 10, 100);
  SndPlaySound(PChar(TCore.Obj.Option.AlarmSound), SND_NODEFAULT or SND_ASYNC);
end;

procedure TfrChat.rp_SystemMessage(APacket: TValueList);
begin
  try
    moChat.SelAttributes.Color := APacket.Integers['Color'];
    moChat.SelText := '시스템 메시지: '#13#10 + APacket.Values['Msg'] + #13;
  except
    moChat.Lines.Clear;
  end;

  RyuGraphics.FalshWindow(Application.MainForm.Handle, 10, 100);
  SndPlaySound(PChar(TCore.Obj.Option.AlarmSound), SND_NODEFAULT or SND_ASYNC);
end;

procedure TfrChat.rp_UserLevel(APacket: TValueList);
begin
  try
    moChat.SelAttributes.Color := lbFontColor.Font.Color;
    moChat.SelText := APacket.Values['UserID'];

    moChat.SelAttributes.Color := clRed;

    case APacket.Integers['UserLevel'] of
      TUserLevel.NORMAL_USER: moChat.SelText := '님께서 부매니저 권한이 해제되었습니다.'#13;
      TUserLevel.ADMIN: moChat.SelText := '님께서 부매니저로 임명되었습니다.'#13;
    end;
  except
    moChat.Lines.Clear;
  end;
end;

procedure TfrChat.rp_ViewIsReady(APacket: TValueList);
begin
  VisibleOfInput := (not APacket.Booleans['IsMute']);

  try
    if plMain.Visible and VisibleOfInput then edMsg.SetFocus;
  except
    Trace('TfrChat.SetFocusToEdit - ');
  end;
end;

procedure TfrChat.rp_Whisper(APacket: TValueList);
begin
  try
    moChat.SelAttributes.Color := APacket.Integers['Color'];
    moChat.SelText := Format('%s ', [APacket.Values['FromID']]);

    moChat.SelAttributes.Color := clRed;
    moChat.SelText := '귓속말';

    moChat.SelAttributes.Color := APacket.Integers['Color'];
    moChat.SelText := ': ' + APacket.Values['Msg'] + #13;
  except
    moChat.Lines.Clear;
  end;

//  if Check and (APacket.Values['FromID'] <> TCore.Obj.Option.UserID) then
//    SndPlaySound(PChar(TCore.Obj.Option.AlarmSound), SND_NODEFAULT or SND_ASYNC);
end;

procedure TfrChat.rp_CallSender(APacket: TValueList);
begin
  if not TClientUnit.Obj.TextClient.IsSender then Exit;

  try
    moChat.SelAttributes.Color := lbFontColor.Font.Color;
    moChat.SelText := APacket.Values['UserID'];

    moChat.SelAttributes.Color := clRed;
    moChat.SelText := '님께서 호출 하셨습니다.'#13;
  except
    moChat.Lines.Clear;
  end;

  if TClientUnit.Obj.TextClient.IsSender or (TCore.Obj.Option.UserID = APacket.Values['UserID']) then begin
    if TCore.Obj.Option.AlarmSound <> '' then
      SndPlaySound(PChar(TCore.Obj.Option.AlarmSound), SND_NODEFAULT or SND_ASYNC);

    if not Application.MainForm.Active then
      RyuGraphics.FalshWindow(Application.MainForm.Handle, 10, 100);
  end;
end;

procedure TfrChat.rp_Chat(APacket: TValueList);
var
  TextString : String;
begin
  TextString := Format('%s: %s', [APacket.Values['FromID'], APacket.Values['Msg']]);

  try
    moChat.SelAttributes.Color := APacket.Integers['Color'];

    // 채팅창과 같은 색은 허용하지 않는다.
    if moChat.Color = moChat.SelAttributes.Color then moChat.SelAttributes.Color := clBlack;

    moChat.Lines.Add(TextString);
  except
    moChat.Lines.Clear;
  end;

//  if Check and (APacket.Values['FromID'] <> TCore.Obj.Option.UserID) then
//    SndPlaySound(PChar(TCore.Obj.Option.AlarmSound), SND_NODEFAULT or SND_ASYNC);
end;

procedure TfrChat.SetVisibleOfInput(const Value: boolean);
begin
  plChatInput.Visible := Value;
end;

end.
