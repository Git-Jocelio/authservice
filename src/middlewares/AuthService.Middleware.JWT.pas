unit AuthService.Middleware.JWT;

interface

uses
  Horse;

 procedure JWTMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc );


implementation

uses
  System.JSON,
  System.SysUtils,
  AuthService.Service.JWT,

  JOSE.Core.JWT,
  JOSE.Consumer,        // aqui
  JOSE.Consumer.Validators,   // aqui
  JOSE.Types.JSON, AuthService.Utils;
  //JOSE.Core.JWK;

procedure JWTMiddleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc );
var
  LAuthHeader: string;
  LToken: string;
 // LJWT: TJWT;
begin
  // pega header authozization. recebe algo assim : Authorization: Bearer eyJ0eXAiOiJKV1Qi...
  LAuthHeader := Req.Headers['Authorization'];

  LAuthHeader := StringReplace(LAuthHeader,'%20',' ',[rfReplaceAll]);


  {debug
TLogger.Write(
  'AUTH HEADER=' + LAuthHeader
);
}


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
    TJOSEConsumerBuilder.NewConsumer.SetVerificationKey( BytesOf (SECRET) )
                                    .SetExpectedIssuer(false,'AuthService')
                                    .Build
                                    .Process(BytesOf(LToken));




  except
    on e: exception do
    begin
      Res.Status(THTTPStatus.Unauthorized);

      Res.Send(TJSONObject.Create
           .AddPair('success',TJSONBool.Create(False))
           .AddPair('message',E.Message).ToJSON);

      Exit;

    end;
  end;

  //Res.Status(THTTPStatus.OK);
  //Res.Status(200);
  Next;
end;

end.
