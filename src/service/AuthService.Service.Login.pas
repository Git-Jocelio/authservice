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
    class function Authenticate(const ALogin, APassword, AID: string ): Boolean;
  end;

implementation

uses
  AuthService.Provider.Interfaces,
  AuthService.Provider.LDAP;

class function TLoginService.Authenticate(const ALogin, APassword, AID: string): Boolean;
var
  LProvider: IAuthProvider;
begin

  LProvider := TLDAPProvider.Create;

  // autenticação
  Result := LProvider.Authenticate( ALogin, APassword, AID );

end;

end.
