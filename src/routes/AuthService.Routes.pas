unit AuthService.Routes;

{
  Unit responsável pelo registro das rotas (endpoints) da API AuthService.

  Esta camada define os endpoints HTTP disponíveis no serviço
  e realiza o direcionamento das requisições para seus respectivos
  controllers.

  Endpoints atuais:
  - GET  /teste  -> teste disponibilidade API
  - POST /login  -> autenticação LDAP
  - GET  /logs   -> consulta logs protegidos JWT
  - GET  /users  -> consulta usuários AD protegida JWT

  Fluxo:
  Cliente HTTP -> Routes -> Controller
}


interface

  procedure RegisterRoutes;

implementation

uses
  Horse,

  AuthService.Controller.Login,
  AuthService.Controller.Logs,
  AuthService.Controller.Users,

  AuthService.Middleware.JWT;

procedure TesteRota(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Servidor Rodando...');
end;

procedure RegisterRoutes;
begin

  THorse.Get('/teste', TesteRota );

  // login
  THorse.Post('/login', Login);


  // AD protegidos JWT
(*  THORSE
        .Group
        .AddCallback(JWTMiddleware)
        .Get('/logs', GetLogs)
        .Get('/users', GetUsers);
*)

    THorse.Get('/logs',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TNextProc)
    begin
      JWTMiddleware(Req, Res, Next);

      if Res.Status = 401 then
        Exit;

      GetLogs(Req, Res);
    end
    );



    // users protegidos
    THorse.Get('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TNextProc)
    begin
      JWTMiddleware(Req, Res, Next);

      if Res.Status = 401 then
        Exit;

      GetUsers(Req, Res);
    end
    );

end;




end.
