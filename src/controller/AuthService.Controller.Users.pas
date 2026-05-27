unit AuthService.Controller.Users;

{
  Controller responsável pelo endpoint de consulta
  de usuários do Active Directory (/users).

  Esta unit recebe requisições HTTP da API AuthService
  e retorna uma lista de usuários cadastrados no AD.

  Também é responsável por:
  - validar autenticação
  - devolver respostas JSON
  - tratar exceções
  - retornar status HTTP apropriado

  Fluxo:
  HTTP Request -> Controller -> Service -> Provider LDAP
}


interface

uses
  Horse;

procedure GetUsers(Req: THorseRequest; Res: THorseResponse);

implementation

uses
  System.JSON,
  System.SysUtils,

  AuthService.Model.User,
  AuthService.Service.Users,
  AuthService.Utils;

procedure GetUsers(Req: THorseRequest; Res: THorseResponse);
var
  LUsers: TArray<TADUser>;
  LArray: TJSONArray;
  LObject: TJSONObject;
  LUser: TADUser;

  LLogin: string;
  LPassword: string;
  LIP: string;
begin
  try

    LLogin := Req.Headers['x-login'];
    LPassword := Req.Headers['x-password'];
    LIP := Req.RawWebRequest.RemoteIP;

    // busca usuários AD
    LUsers := TUserService.GetUsers(LLogin, LPassword, LIP);;

    LArray := TJSONArray.Create;

    for LUser in LUsers do
    begin

      LObject := TJSONObject.Create;

      LObject
        .AddPair('name', LUser.Name)
        .AddPair('login', LUser.Login)
        .AddPair('email', LUser.Email);

      LArray.AddElement(LObject);

    end;

    Res.ContentType('application/json');

    Res.Status(200).Send(LArray.ToJSON);

  except
    on E: Exception do
    begin

      TLogger.Error(E.Message);

      Res.ContentType('application/json');

      Res.Status(500).Send(
        TJSONObject.Create
          .AddPair('success', TJSONBool.Create(False))
          .AddPair('message', 'internal server error')
          .ToJSON
                          );

    end;
  end;
end;

end.
