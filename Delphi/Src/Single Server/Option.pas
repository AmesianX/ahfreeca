unit Option;

interface

uses
  SysUtils, Classes;

type
  TOption = class
  private
    FMemoryPoolSize: int64;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TOption;
  public
    property MemoryPoolSize : int64 read FMemoryPoolSize;
  end;

implementation

{ TOption }

var
  MyObject : TOption = nil;

class function TOption.Obj: TOption;
begin
  if MyObject = nil then MyObject := TOption.Create;
  Result := MyObject;
end;

constructor TOption.Create;
const
  DEFAULT_MEMORY_POOL_SIZE = 256 * 1024 * 1024;
begin
  inherited;

  FMemoryPoolSize := DEFAULT_MEMORY_POOL_SIZE;
end;

destructor TOption.Destroy;
begin

  inherited;
end;

initialization
  MyObject := TOption.Create;
end.