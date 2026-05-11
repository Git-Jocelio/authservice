{
  Unit responsável pelo gerenciamento das configurações do AuthService.

  Esta camada realiza a leitura do arquivo config.ini,
  carregando parâmetros necessários para o funcionamento
  da aplicação, como host LDAP, porta, BaseDN e timeout.

  Implementa o padrão Singleton para manter uma única
  instância das configurações durante toda a execução
  do serviço.
}unit AuthService.Config;

interface

uses
  System.SysUtils, System.IniFiles, System.IOUtils;

type
  TConfig = class
  private
    FHost: string;
    FPort: Integer;
    FBaseDN: string;
    FTimeout: Integer;
    class var FInstance: TConfig;
    constructor Create;
  public
    property Host: string read FHost;
    property Port: Integer read FPort;
    property BaseDN: string read FBaseDN;
    property Timeout: Integer read FTimeout;

    class function GetInstance: TConfig;
  end;

implementation

constructor TConfig.Create;
var
  LIni: TIniFile;
  LPath: string;
begin
  // busca configurações no arquivo ini
  LPath := TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)), '..\config\config.ini'));
  if not TFile.Exists(LPath) then
    raise Exception.Create('Arquivo de configuração não encontrado em: ' + LPath);

  LIni := TIniFile.Create(LPath);
  try
    FHost    := LIni.ReadString('LDAP', 'Host', '127.0.0.1');
    FPort    := LIni.ReadInteger('LDAP', 'Port', 389);
    FBaseDN  := LIni.ReadString('LDAP', 'BaseDN', '');
    FTimeout := LIni.ReadInteger('LDAP', 'Timeout', 5);
  finally
    LIni.Free;
  end;
end;

class function TConfig.GetInstance: TConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TConfig.Create;
  Result := FInstance;
end;

initialization

finalization
  if Assigned(TConfig.FInstance) then
    TConfig.FInstance.Free;

end.
