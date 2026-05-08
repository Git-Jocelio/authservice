unit AuthService.Model.Login;

interface

// esta model representa
//  {
//    "login": "",
//    "password": ""
//  }

type
  TLoginRequest = class
  public
    Login: string;
    Password: string;
  end;

implementation

end.
