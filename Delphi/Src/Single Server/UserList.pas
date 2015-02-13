unit UserList;

interface

uses
  DebugTools, SuperSocketUtils, Connection, LinkedList,
  SysUtils, Classes, SyncObjs;

type
  TUserListCallback = reference to procedure(UserList:string);

  TUserListEvent = procedure (Sender:TObject; AConnection:TConnection) of object;

  // TOTO: BlackList, MuteList 등 관리
  TUserList = class
  private
    FCS : TCriticalSection;
    FLinkedList : TLinkedList;
  private
    FOnUserIn: TUserListEvent;
    FOnUserOut: TUserListEvent;
    FOnIDinUse: TUserListEvent;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(AConnection:TConnection);
    procedure Remove(AConnection:TConnection); overload;

    function FindByUserID(AUserID:string):TConnection;

    procedure GetUserList(AConnection:TConnection; ACallback:TUserListCallback);
  public
    property OnUserIn : TUserListEvent read FOnUserIn write FOnUserIn;
    property OnUserOut : TUserListEvent read FOnUserOut write FOnUserOut;
    property OnIDinUse : TUserListEvent read FOnIDinUse write FOnIDinUse;
 end;

implementation

{ TUserList }

procedure TUserList.Add(AConnection: TConnection);
begin
  FCS.Acquire;
  try
    // TODO: check IDinUse

    // TODO: AConnection.Data 대신 상속을 통해서 전용 속성 추가
    AConnection.Data := Pointer( FLinkedList.Add(AConnection) );

    if Assigned(FOnUserIn) then FOnUserIn(Self, AConnection);
  finally
    FCS.Release;
  end;
end;

procedure TUserList.Clear;
var
  Node : TLinkedListNode;
begin
  FCS.Acquire;
  try
    Node := Pointer( FLinkedList.RemoveLast );
    while Node <> nil do begin
      Node.Free;
      Node := Pointer( FLinkedList.RemoveLast );
    end;
  finally
    FCS.Release;
  end;
end;

constructor TUserList.Create;
begin
  inherited;

  FCS := TCriticalSection.Create;
  FLinkedList := TLinkedList.Create;
end;

destructor TUserList.Destroy;
begin
  Clear;

  FreeAndNil(FCS);
  FreeAndNil(FLinkedList);

  inherited;
end;

function TUserList.FindByUserID(AUserID: string): TConnection;
var
  Connection : TConnection;
begin
  Connection := nil;

  FCS.Acquire;
  try
    FLinkedList.Iterate(
      procedure(ALinkedListNode:ILinkedListNode; var ANeedStop:boolean)
      var
        Item : TConnection;
      begin
        Item := ALinkedListNode.GetObject.Data;
        ANeedStop := Item.UserID = AUserID;
        if ANeedStop then Connection := Item;
      end
    );
  finally
    FCS.Release;
  end;

  Result := Connection;
end;

procedure TUserList.GetUserList(AConnection:TConnection; ACallback: TUserListCallback);
var
  isCondition : boolean;
  sUserList, sUserInfo : string;
  Connection : TConnection;
begin
  sUserList := '';

  FCS.Acquire;
  try
    FLinkedList.Iterate(
      procedure(ALinkedListNode:ILinkedListNode)
      begin
        Connection := ALinkedListNode.GetObject.Data;

        isCondition :=
          Connection.IsDisconnected or
          (Connection.IsLogined = false) and
          (Connection.UserID = '') and
          (Connection.UserID = AConnection.UserID);
        if isCondition then Exit;

        sUserInfo := Connection.GetUserInfo;

        if (ByteLength(sUserList) + ByteLength(sUserInfo)) >= (PACKET_SIZE_LIMIT - 128) then begin
          ACallback( 'Code=UserList<rYu>' + sUserList );
          sUserList := '';
        end;

        sUserList := sUserList + sUserInfo + '<rYu>end.<rYu>';
      end
    );

    if sUserList <> '' then ACallback( 'Code=UserList<rYu>' + sUserList );
  finally
    FCS.Release;
  end;
end;

procedure TUserList.Remove(AConnection: TConnection);
var
  Node : ILinkedListNode;
begin
  FCS.Acquire;
  try
    Node := ILinkedListNode( AConnection.Data );

    FLinkedList.Remove( Node );

    if Assigned(FOnUserOut) then FOnUserOut(Self, AConnection);
  finally
    FCS.Release;
  end;
end;

end.
