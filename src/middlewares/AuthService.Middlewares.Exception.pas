unit AuthService.Middlewares.Exception;

interface

uses
  Horse, System.SysUtils;

procedure HandleException(HorseException: Exception; Req: THorseRequest; Res: THorseResponse);

implementation

uses
  System.JSON,
  AuthService.Utils;

procedure HandleException(HorseException: Exception; Req: THorseRequest; Res: THorseResponse);
begin

  // Log erro
  TLogger.Error(HorseException.Message);

  // Response padrão API
  Res.ContentType('application/json');

  Res.Status(500).Send(
    TJSONObject.Create
      .AddPair('success', TJSONBool.Create(False))
      .AddPair('message', 'internal server error')
      .ToJSON
  );

end;

end.
