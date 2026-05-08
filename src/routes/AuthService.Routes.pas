unit AuthService.Routes;

interface

procedure RegisterRoutes;

implementation

uses
  Horse,
  AuthService.Controller.Login;

procedure RegisterRoutes;
begin

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Post('/login', Login);

end;

end.
