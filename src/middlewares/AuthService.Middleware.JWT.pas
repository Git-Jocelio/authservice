unit AuthService.Middleware.JWT;

interface

uses
  Horse;

 procedure JWTMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc );


implementation

uses
  System.JSON,
  System.SysUtils,
  AuthService.Service.JWT,

  JOSE.Core.JWT,
  JOSE.Consumer,        // aqui
  JOSE.Consumer.Validators,   // aqui
  JOSE.Types.JSON;

procedure JWTMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TProc );
var
  LAuthHeader: string;
  LToken: string;
 // LJWT: TJWT;
begin
  // pega header authozization. recebe algo assim : Authorization: Bearer eyJ0eXAiOiJKV1Qi...
  LAuthHeader := Req.Headers['Authorization'];

  if trim(LAuthHeader) = '' then
  begin
    Res.Status(401).Send( TJSONOBject.Create.AddPair('success', TJSONBool(False) )
                                            .AddPair('message','token not provided')
                                            .ToJSON
                                            );
    exit;
  end;

  LToken := trim( StringReplace(LAuthHeader,'Bearer','',[rfIgnoreCase]) );

  if LToken = '' then
  begin
    Res.Status(401).Send( TJSONOBject.Create.AddPair('success', TJSONBool(False) )
                                            .AddPair('message','invalid token')
                                            .ToJSON
                                            );
    exit;

  end;


  try
    // validar token
    TJOSEConsumerBuilder.NewConsumer.SetVerificationKey(SECRET)
                                    .SetExpectedIssuer(true,'AuthService')
                                    .Build
                                    .Process(LToken);

  except
    on e: exception do
    begin
      Res.Status(401).Send( TJSONOBject.Create.AddPair('success', TJSONBool(False) )
                                              .AddPair('message','invalid or expired token')
                                              .ToJSON
                                              );
      exit;

    end;
  end;

  Next;
end;

end.
