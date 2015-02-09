unit Option;

interface

uses
  SysUtils, Classes;

type
  TOption = class
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TOption }

constructor TOption.Create;
begin
  inherited;

end;

destructor TOption.Destroy;
begin

  inherited;
end;

end.
