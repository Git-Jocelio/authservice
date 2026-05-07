unit AuthService.Utils;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils;

type
  TLogger = class
  private
    class var FLogPath: string;
    class procedure EnsureLogDirectory;
  public
    class procedure Write(const AMessage: string);
    class procedure Error(const AMessage: string);
  end;

implementation

{ TLogger }

class procedure TLogger.EnsureLogDirectory;
begin
  // "Garantir" o caminho para D:\AuthService\logs\ baseado na estrutura de pastas
  if FLogPath = '' then
    FLogPath := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\logs');

  if not TDirectory.Exists(FLogPath) then
    TDirectory.CreateDirectory(FLogPath);
end;

class procedure TLogger.Write(const AMessage: string);
var
  LFileName: string;
  LContent: string;
begin
  try
    EnsureLogDirectory;
    // Cria um arquivo(LFileName) por dia: Log_2026-05-06.log
    LFileName := TPath.Combine(FLogPath, 'Log_' + FormatDateTime('yyyy-mm-dd', Now) + '.log');

    // Formato da linha conforme requisito: 2026-04-30 10:00:00 | MENSAGEM
    LContent := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' | ' + AMessage + sLineBreak;

    // TFile.AppendAllText abre, escreve e fecha o arquivo(LFileName) de forma segura
    TFile.AppendAllText(LFileName, LContent, TEncoding.UTF8);
  except
    // Em serviços, se o log falhar, não podemos parar a aplicação com erro de tela
  end;
end;

class procedure TLogger.Error(const AMessage: string);
begin
  Write('ERROR | ' + AMessage);
end;

end.
