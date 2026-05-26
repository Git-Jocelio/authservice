{
  Unit responsável pela regra de negócio de consulta
  de usuários no Active Directory.

  Esta camada realiza a comunicação entre o Controller
  e o Provider LDAP, retornando a lista de usuários
  cadastrados no AD.

  Fluxo:
  Controller -> Service -> Provider LDAP
}
unit AuthService.Service.Users;

interface

uses
  AuthService.Model.User;

  type
    TUserService = class
    public

     class function GetUsers:TArray<TADUser>;

  end;


implementation
uses
  AuthService.Provider.Interfaces,
  AuthService.Provider.LDAP;


class function TUserService.GetUsers:TArray<TADUser>;
var
  LProvider : IAuthProvider;
begin

  LProvider := TLDAPProvider.create;

  Result := LProvider.GetUsers;


end;



end.
