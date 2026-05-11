{
  Model responsável por representar a estrutura de dados
  utilizada na requisição de autenticação do AuthService.

  Esta classe corresponde ao JSON recebido no endpoint /login,
  contendo os campos necessários para autenticação do usuário.

  Exemplo:
  {
    "login": "",
    "password": ""
  }

unit AuthService.Model.Login;

interface


type
  TLoginRequest = class
  public
    Login: string;
    Password: string;
  end;

implementation

end.
