unit CoreInterface;

interface

uses
  Classes, SysUtils, Graphics, ComCtrls;

type
  ITextClient = interface
    ['{AA3E769A-97D8-42C4-B8EF-964D5BE65A65}']

    /// AUserID를 강퇴 시킨다.
    procedure sp_KickOut(AUserID:string);

    /// AUserID를 벙어리 등록 또는 해제 한다.
    procedure sp_Mute(AUserID:string; AMute:boolean);

    /// 대화 메시지를 전송한다.  자신을 포함한 모두에게 전달된다.
    procedure sp_Chat(AFromID,AMsg:string; AColor:TColor);

    {*
      특정 사용자에게만 대화 메시지를 전달한다.  AUserIDs는 아디를 구분자로 서로 띄워서 나열하면 된다.
      아이디에 포함 될 수 없는 문자를 이용해서 구분하면 된다.
    }
    procedure sp_Whisper(AFromID,AUserIDs,AMsg:string; AColor:TColor);

    /// 현재 사용자 목록을 가져온다.
    procedure GetUserList(AListView:TListView);

    /// AUserID를 벙어리 상태인지 확인한다.
    function GetUserMuteStatus(AUserID:string):boolean;

    /// 강사 자격이 있는 가?
    function GetIsSender:boolean;
    property IsSender : boolean read GetIsSender;
  end;

  IVoiceClient = interface
    ['{EFF69078-CC22-42B6-8CE6-CA5B3E7A47E3}']

    /// 음성 데이터를 전송한다.
    procedure SendVoice(AData:pointer; ASize:integer);
  end;

implementation

end.
