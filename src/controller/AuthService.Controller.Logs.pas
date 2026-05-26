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

  LDate: string;

  LFileName: string;
  LLines: TStringList;

  LArray: TJSonArray;

  LParts: TArray<string>;

  I: integer;
begin

  LDate := Req.Query['date'];

  if Trim( LDate) = '' then
    LDate := FormatDateTime('yyyy-mm-dd', Now);

  // arquivo log do dia atual
  LFileName := TPath.Combine(ExtractFilePath(ParamStr(0)),
               '..\logs\Log_' + LDate  + '.log');

  // arquivo não existe...
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

      LParts:= LLines[I].Split(['|']);

      if length(LParts) < 7 then
        continue;

      LArray.Add(

        TJSONObject.Create
          .AddPair('date', Trim(LParts[0]))

          .AddPair('type', Trim(LParts[1]))

          .AddPair('status', Trim(LParts[2]))

          .AddPair('username', StringReplace(LParts[3], 'USER=', '', [rfIgnoreCase]))

          .AddPair('ip', StringReplace(LParts[4], 'IP=', '', [rfIgnoreCase]))

          .AddPair('ldap_code', StringReplace(LParts[5], 'LDAP_CODE=', '', [rfIgnoreCase]))

          .AddPair('ldap_message', StringReplace(LParts[6], 'LDAP_MESSAGE=', '', [rfIgnoreCase]))
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
