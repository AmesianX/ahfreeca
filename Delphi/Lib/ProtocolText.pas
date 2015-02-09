unit ProtocolText;

interface

uses
  Classes, SysUtils;

type
  TPacketType = (
    // 사용자 인증 및 정보
    ptLogin, ptLogout,
    ptAskUserList,
    ptErVersion, ptOkLogin, ptErLogin, ptIDinUse,
    ptUserIn, ptUserOut, ptUserList,

    // 공통
    ptChat, ptWhisper,

    // 수강생 기능
    ptCallSender,

    // 방장 기능
    ptKickOut, ptUserLevel, ptMute, ptNotice, ptCloseRoom, ptOpenModule,

    // 기타
    ptOnAir, ptOffAir,
    ptSetUserModeToSender,

    // 사용자들의 현재 상태를 전송한다.
    ptUserStatus
  );

implementation

end.
