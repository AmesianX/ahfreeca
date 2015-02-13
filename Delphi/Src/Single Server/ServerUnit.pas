unit ServerUnit;

interface

uses
  ServerUnit.TextServer,
  ServerUnit.VoiceServer,
  ServerUnit.VideoServer,
  Config, Protocol, MemoryPool,
  SysUtils, Classes;

type
  TServerUnit = class
  private
    FMemoryPool : TMemoryPool;
    FTextServer : TTextServer;
    FVoiceServer : TVoiceServer;
    FVideoServer : TVideoServer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

uses
  Option;

{ TServerUnit }

procedure TServerUnit.Start;
begin
  FTextServer.Start;
  FVoiceServer.Start;
  FVideoServer.Start;
end;

procedure TServerUnit.Stop;
begin
  FTextServer.Stop;
  FVoiceServer.Stop;
  FVideoServer.Stop;
end;

constructor TServerUnit.Create;
begin
  inherited;

  {$IFDEF WIN64}
  FMemoryPool := TMemoryPool64.Create( TOption.Obj.MemoryPoolSize );
  {$ELSE}
  FMemoryPool := TMemoryPool32.Create( TOption.Obj.MemoryPoolSize );
  {$ENDIF}

  FTextServer  := TTextServer.Create(FMemoryPool);
  FVoiceServer := TVoiceServer.Create(FMemoryPool);
  FVideoServer := TVideoServer.Create(FMemoryPool);
end;

destructor TServerUnit.Destroy;
begin
  Stop;

  FreeAndNil(FMemoryPool);
  FreeAndNil(FTextServer);
  FreeAndNil(FVoiceServer);
  FreeAndNil(FVideoServer);

  inherited;
end;

end.
