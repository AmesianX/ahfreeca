unit UserLevel;

interface

uses
  Classes, SysUtils;

type
  TUserLevel = class
  const
    /// 수강생
    NORMAL_USER = 0;

    /// 실제 클라이언트로 접속하는 관리자
    ADMIN = 10;

    /// 방장 (강사)
    ROOM_MASTER = 20;

    /// 보조강사 (방장 권한 없음)
    ROOM_ASSISTANCE = 30;
  end;

implementation

end.
