unit AuthService.Provider.Mock;

interface

uses AuthService.Provider.Interfaces;



type
  TMockProvider =  class(TInterfacedObject, IAuthProvider)
  public
    function Authenticate(const ALogin,APassword: string): Boolean;
  end;

implementation

// Isso simula autenticação no LDAP.
function TMockProvider.Authenticate(const ALogin,APassword: string): Boolean;
begin
  Result :=(ALogin = 'admin') and (APassword = '123');
end;

end.
