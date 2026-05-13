{
  Unit responsável pelo gerenciamento das configurações do AuthService.

  Esta camada realiza a leitura do arquivo config.ini,
  carregando parâmetros necessários para o funcionamento
  da aplicação, como configurações do servidor HTTP,
  parâmetros LDAP, domínio, SSL e timeout.

  Implementa o padrão Singleton para manter uma única
  instância das configurações durante toda a execução
  do serviço.
}

unit AuthService.Config;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils;

type
  TConfig = class
  private
    // LDAP
    FHost: string;
    FPort: Integer;
    FBaseDN: string;
    FDomain: string;
    FUseSSL: Boolean;
    FTimeout: Integer;

    // SERVER
    FServerPort: Integer;
    FEnvironment: string;

    class var FInstance: TConfig;

    constructor Create;

  public

    // LDAP
    property Host: string read FHost;
    property Port: Integer read FPort;
    property BaseDN: string read FBaseDN;
    property Domain: string read FDomain;
    property UseSSL: Boolean read FUseSSL;
    property Timeout: Integer read FTimeout;

    // SERVER
    property ServerPort: Integer read FServerPort;
    property Environment: string read FEnvironment;

    class function GetInstance: TConfig;
  end;

implementation

constructor TConfig.Create;
var
  LIni: TIniFile;
  LPath: string;
begin

  // busca arquivo config.ini
  LPath :=
    TPath.GetFullPath(TPath.Combine(ExtractFilePath(ParamStr(0)),'..\config\config.ini'));

  // valida existência arquivo
  if not TFile.Exists(LPath) then
    raise Exception.Create('Arquivo de configuração não encontrado em: ' + LPath);

  LIni := TIniFile.Create(LPath);

  try

    // SERVER
    FServerPort := LIni.ReadInteger('SERVER','Port', 9000);
    FEnvironment := LIni.ReadString('SERVER','Environment','DEV' );

    // LDAP
    FHost   := LIni.ReadString('LDAP','Host', '192.168.100.30' );
    FPort   := LIni.ReadInteger('LDAP','Port', 389);
    FBaseDN := LIni.ReadString('LDAP','BaseDN','' );
    FDomain := LIni.ReadString('LDAP', 'Domain', '' );
    FUseSSL := LIni.ReadBool('LDAP', 'UseSSL', False );
    FTimeout := LIni.ReadInteger('LDAP','Timeout',5);

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
