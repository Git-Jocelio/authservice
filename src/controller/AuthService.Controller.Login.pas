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
  Horse;

//rota Login
procedure Login(Req: THorseRequest;Res: THorseResponse);

implementation

uses
  System.JSON,
  System.SysUtils,
  AuthService.Service.Login;

procedure Login(Req: THorseRequest;Res: THorseResponse);
var
  LJson: TJSONObject;
  LLogin: string;
  LPassword: string;
  LIP: string;
begin
  try
    // Parse JSON manual
    LJson := TJSONObject.ParseJSONValue( Req.Body ) as TJSONObject;

    // JSON inválido
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
    if TLoginService.Authenticate(LLogin, LPassword) then
    begin
      Res.ContentType('application/json');
      Res.Status(200).Send(TJSONObject.Create.AddPair('success', TJSONBool.Create(True)).ToJSON);
    end
    else
    begin
      Res.ContentType('application/json');
      Res.Status(401).Send(TJSONObject.Create.AddPair( 'success',TJSONBool.Create(False))
                                             .AddPair( 'message', 'authentication failed').ToJSON );
    end;

  except
    on E: Exception do
    begin
      Res.ContentType('application/json');
      Res.Status(500).Send(TJSONObject.Create.AddPair('success',TJSONBool.Create(False))
                                             .AddPair('message', E.Message).ToJSON);
    end;
  end;
end;

end.
