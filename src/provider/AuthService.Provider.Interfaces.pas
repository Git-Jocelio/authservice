unit AuthService.Provider.Interfaces;


interface

uses
  AuthService.Model.User;

type
  IAuthProvider = interface
    ['{8D43A7D1-8A7A-4C4B-9A2A-123456789ABC}']

    function Authenticate(const ALogin, APassword, AIP: string): Boolean;
    function GetUsers(const ALogin, APassword, AIP: string): TArray<TADUser>;

  end;

implementation

end.
