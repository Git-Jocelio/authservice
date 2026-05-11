{
  Unit responsável pela regra de negócio de autenticação do AuthService.

  Esta camada faz a comunicação entre o Controller e o Provider,
  executando o processo de autenticação do usuário e registrando
  logs de sucesso ou falha através da unit AuthService.Utils.

  Fluxo:
  Controller -> Service -> Provider -> Logger
}
unit AuthService.Service.Login;

interface

type
  TLoginService = class
  public
    class function Authenticate(const ALogin, APassword, AIP: string ): Boolean;
  end;

implementation

uses
  AuthService.Provider.Mock,
  AuthService.Utils;

class function TLoginService.Authenticate(const ALogin, APassword, AIP: string): Boolean;
begin

  Result := TMockProvider.Authenticate(ALogin, APassword);

  if Result then
    TLogger.Write('LOGIN OK | ' + ALogin + ' | IP: ' + AIP)
  else
    TLogger.Write('LOGIN FAILED | ' + ALogin + ' | IP: ' + AIP);

end;

end.
