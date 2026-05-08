unit AuthService.Service.Login;

interface

type
  TLoginService = class
  public
    class function Authenticate(
      const ALogin,
      APassword: string
    ): Boolean;
  end;

implementation

uses
  AuthService.Provider.Mock;

class function TLoginService.Authenticate(
  const ALogin,
  APassword: string
): Boolean;
begin

  Result :=
    TMockProvider.Authenticate(
      ALogin,
      APassword
    );

end;

end.
