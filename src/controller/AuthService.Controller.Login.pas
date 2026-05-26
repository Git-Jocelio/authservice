{
  Controller responsável pelo endpoint de autenticação (/login).

  Esta unit recebe requisições HTTP enviadas para a API AuthService,
  realiza o tratamento do JSON recebido, extrai login e senha
  informados pelo cliente e encaminha a autenticação para a camada
  de serviço (AuthService.Service.Login).

  Também é responsável por:
  - validar JSON recebido
  - retornar status HTTP apropriado
  - devolver respostas no formato JSON
  - tratar exceções da requisição

  Fluxo:
  HTTP Request -> Controller -> Service -> Provider -> Logger
}

unit AuthService.Controller.Login;

interface

uses
  Horse, AuthService.Utils, AuthService.Service.JWT;


//rota Login
procedure Login(Req: THorseRequest;Res: THorseResponse);

implementation

uses
  System.JSON,
  System.SysUtils,
  AuthService.Service.Login;

procedure Login(Req: THorseRequest;Res: THorseResponse);
var
  LJSON: TJSONObject;
  LLogin: string;
  LPassword: string;
  LIP: string;
  LToken : string;
begin
  try
    // carrega o JSON na variável
    LJSON := TJSONObject.ParseJSONValue( Req.Body ) as TJSONObject;

    // validar JSON
    if not Assigned(LJson) then
    begin
      Res.ContentType('application/json');
      Res.Status(400).Send(TJSONObject.Create.AddPair('success',TJSONBool.Create(False))
                                             .AddPair('message','invalid json').ToJSON);
      Exit;
    end;

    // Captura campos
    LLogin := LJson.GetValue<string>('login');
    LPassword := LJson.GetValue<string>('password');
    LIP := Req.RawWebRequest.RemoteIP;

    // Validação login e Password
    if ( (Trim(LLogin) = '') or (Trim(LPassword) = '') ) then
    begin
      Res.ContentType('application/json');

      Res.Status(400).Send(
        TJSONObject.Create
          .AddPair('success', TJSONBool.Create(False))
          .AddPair('message', 'login and password are required')
          .ToJSON
      );

      Exit;
    end;


    // Autenticação
    if TLoginService.Authenticate(LLogin, LPassword, LIP) then
    begin
      // gerar token com id do usuário...
      LToken := Criar_Token(LLogin);

      Res.ContentType('application/json');
      Res.Status(200).Send(TJSONObject.Create.AddPair('success', TJSONBool.Create(True))
                                             .AddPair('user', LLogin)
                                             .AddPair('timestamp', formatDateTime('yyyy-mm-dd"T"hh:nn:ss', now))
                                             .AddPair('token',LToken)
                                             .ToJSON);


    end
    else
    begin
      Res.ContentType('application/json');
      Res.Status(401).Send(TJSONObject.Create.AddPair( 'success',TJSONBool.Create(False))
                                             .AddPair( 'message', 'authentication failed')
                                             .AddPair( 'timestamp', formatDateTime('yyyy-mm-dd"T"hh:nn:ss', now)).ToJSON );
    end;

  except
    on E: Exception do
    begin
      // mostra o erro somente no log interno
      TLogger.Error(E.Message);


      // devolve uma messagem genérica ao usuário
      Res.ContentType('application/json');

      Res.Status(500).Send(
         TJSONObject.Create
         .AddPair('success', TJSONBool.Create(false))
         .addPair('message', 'internal sever erro')
         );


    end;
  end;
end;

end.
