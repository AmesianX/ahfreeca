unit Protocol;

interface

uses
  Windows, SysUtils, Classes;

const
  PROTOCOL_VERSION = 4;

type
  TProtocolLayer = (plText, plVoice, plVideo);

  TCustomHeader = packed record
    ProtocolLayer : TProtocolLayer;
    Reserved1 : byte;
    Reserved2 : byte;
    Reserved3 : byte;
    procedure FromDWord(AValue:DWord);
    function ToDWord:DWord;
  end;

implementation

{ TCustomHeader }

procedure TCustomHeader.FromDWord(AValue: DWord);
begin
  Self := TCustomHeader( AValue );
end;

function TCustomHeader.ToDWord: DWord;
begin
  Result := DWord(Self);
end;

end.
