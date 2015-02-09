unit Protocol;

interface

uses
  Windows, SysUtils, Classes;

const
  PROTOCOL_VERSION = 4;

type
  TProtocolDirection = (pdNone, pdSendToAll, pdSendToOther, pdSentToID);

  TCustomHeader = packed record
    PacketType : byte;
    Direction : TProtocolDirection;
    ID : word;

    procedure Init;

    procedure FromDWord(AValue:DWord);
    function ToDWord:DWord;
  end;

implementation

{ TCustomHeader }

procedure TCustomHeader.FromDWord(AValue: DWord);
begin
  Self := TCustomHeader( AValue );
end;

procedure TCustomHeader.Init;
begin
  PacketType := 0;
  Direction := pdNone;
  ID := 0;
end;

function TCustomHeader.ToDWord: DWord;
begin
  Result := DWord(Self);
end;

end.
