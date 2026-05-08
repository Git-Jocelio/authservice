unit AuthService.Provider.Mock;

interface

type
  TMockProvider = class
  public
    class function Authenticate(
      const ALogin,
      APassword: string
    ): Boolean;
  end;

implementation

//Isso simula LDAP.

class function TMockProvider.Authenticate(
  const ALogin,
  APassword: string
): Boolean;
begin

  Result :=
    (ALogin = 'admin') and
    (APassword = '123');

end;

end.
