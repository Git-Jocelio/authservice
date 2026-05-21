unit AuthService.Controller.Logs;
// esnpoint protegido para busca de logs
interface

uses Horse;

procedure GetLogs(Req: THorseRequest; Res: THorseResponse);

implementation

uses
 System.SysUtils,
 System.JSON;

procedure GetLogs(Req: THorseRequest; Res: THorseResponse);
var
 LArray: TJSonArray;
begin

  LArray:= TJSonArray.Create;

  LArray.Add(
     TJSONObject.Create
       .AddPair('date','2026-05-21 10:00:00')
       .AddPair('date','2026-05-22 11:23:09')
           );

   Res.Send<TJSonArray>(LArray)

end;

end.
