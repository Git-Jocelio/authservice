unit AuthService.Controller.Login;

interface

uses
  Horse;

procedure Login(
  Req: THorseRequest;
  Res: THorseResponse
);

implementation

uses
  System.JSON,
  System.SysUtils,
  AuthService.Service.Login;

procedure Login(
  Req: THorseRequest;
  Res: THorseResponse
);
var
  LJson: TJSONObject;
  LLogin: string;
  LPassword: string;
begin

  try

    // Parse JSON manual
    LJson :=
      TJSONObject.ParseJSONValue(
        Req.Body
      ) as TJSONObject;

    // JSON inválido
    if not Assigned(LJson) then
    begin

      Res.ContentType('application/json');

      Res.Status(400).Send(
        TJSONObject.Create
          .AddPair(
            'success',
            TJSONBool.Create(False)
          )
          .AddPair(
            'message',
            'invalid json'
          ).ToJSON
      );

      Exit;

    end;

    // Captura campos
    LLogin :=
      LJson.GetValue<string>('login');

    LPassword :=
      LJson.GetValue<string>('password');

    // Autenticação
    if TLoginService.Authenticate(
         LLogin,
         LPassword
       ) then
    begin

      Res.ContentType('application/json');

      Res.Status(200).Send(
        TJSONObject.Create
          .AddPair(
            'success',
            TJSONBool.Create(True)
          ).ToJSON
      );

    end
    else
    begin

      Res.ContentType('application/json');

      Res.Status(401).Send(
        TJSONObject.Create
          .AddPair(
            'success',
            TJSONBool.Create(False)
          )
          .AddPair(
            'message',
            'authentication failed'
          ).ToJSON
      );

    end;

  except
    on E: Exception do
    begin

      Res.ContentType('application/json');

      Res.Status(500).Send(
        TJSONObject.Create
          .AddPair(
            'success',
            TJSONBool.Create(False)
          )
          .AddPair(
            'message',
            E.Message
          ).ToJSON
      );

    end;
  end;

end;

end.
