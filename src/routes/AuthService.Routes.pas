{
  Unit responsável pelo registro das rotas (endpoints) da API AuthService.

  Esta camada define os endpoints HTTP disponíveis no serviço
  e realiza o direcionamento das requisições para seus respectivos
  controllers.

  Endpoints atuais:
  - GET  /ping   -> teste de disponibilidade da API
  - POST /login -> autenticação de usuários

  Fluxo:
  Cliente HTTP -> Routes -> Controller
}
unit AuthService.Routes;

interface

procedure RegisterRoutes;

implementation

uses
  Horse,
  AuthService.Controller.Login;

procedure RegisterRoutes;
begin

  THorse.Get('/teste',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('Servidor Rodando...');
    end);

  THorse.Post('/login', Login);

end;

procedure TesteRota(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Send('Servidor Rodando...');
end;


end.
