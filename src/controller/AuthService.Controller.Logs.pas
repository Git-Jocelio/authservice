unit AuthService.Controller.Logs;
// esnpoint protegido para busca de logs
interface

uses Horse;

procedure GetLogs(Req: THorseRequest; Res: THorseResponse);

implementation

uses
 System.SysUtils,
 System.JSON,

 System.IOUtils,
 System.Classes;

procedure GetLogs(Req: THorseRequest; Res: THorseResponse);
var
  LFileName: string;

  LLines: TStringList;
  LArray: TJSonArray;

  I: integer;
begin
  // arquivo log dia atual
  LFileName := TPath.Combine(ExtractFilePath(ParamStr(0)),
               '..\logs\Log_' + FormatDateTime('yyyy-mm-dd', Now) + '.log');

  if not TFile.Exists(LFileName) then
  begin

    Res.Status(404).send(

       TJSONObject.Create
          .AddPair('success',TJSONBool.Create(false))
          .AddPair('message', 'log file not foud')
          .ToJSON
    );

    exit;
  end;

  LLines:= TStringList.Create;
  LArray:= TJSonArray.Create;

  try

    // carrega arquivo
    LLines.LoadFromFile(LFileName, TEncoding.UTF8);

    // transforma linhas em JSON
    for i := 0 to LLines.Count -1 do
    begin

      LArray.Add(

        TJSONObject.Create
          .AddPair('line',LLines[I])

       );

    end;


    //Res.Send<TJSONArray>(LArray)

    Res.ContentType('application/json');
    Res.Send(LArray.ToJSON);

  finally
    LLines.Free;
  end;


end;

end.
