
{
  Unit responsável pelo sistema de logs do AuthService.

  Esta camada realiza o gerenciamento e gravação de logs
  da aplicação, registrando eventos importantes como:
  - inicialização do serviço
  - autenticações realizadas
  - falhas de login
  - erros internos

  Os logs são armazenados em arquivos diários na pasta /logs,
  utilizando codificação UTF-8 e timestamp para auditoria
  e rastreabilidade do serviço.
}

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

    class procedure AuthSuccess(const User, AIP: string; ALDAPCode: integer);
    class procedure AuthFailed(const User, AIP: string; ALDAPCode: integer);

    class function GetLDAPMessage(const Acode: integer): string;
    class function Sanitize(const AValue: string): string;

  end;

implementation

{ TLogger }

class procedure TLogger.AuthFailed(const User, AIP: string; ALDAPCode: integer);
begin
  write('AUTH | FAILED | ' +
        'USER=' + Sanitize(User) + ' | ' +
        'IP=' + Sanitize(AIP) + ' | ' +
        'LDAP_CODE=' + IntToStr(ALDAPCode) + '|'+
        GetLDAPMessage(ALDAPCode)
        );
end;

class procedure TLogger.AuthSuccess(const User, AIP: string; ALDAPCode: integer);
begin
  write('AUTH | SUCESS | ' +
        'USER=' + Sanitize(User) + ' | ' +
        'IP=' + Sanitize(AIP) + ' | ' +
        'LDAP_CODE=' + IntToStr(ALDAPCode) + '|'  +
        GetLDAPMessage(ALDAPCode)
        );
end;

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

class function TLogger.GetLDAPMessage(const Acode: integer): string;
begin
  case Acode of
    0:
     result := 'SUCESS';

    3:
     result := 'TIME LIMIT EXCEEDED';

    49:
     result := 'INVALID CREDENTIALS';


    50:
     result := 'INSUFFICIENT ACCESS RIGHTS';

    32:
     result := 'USE_NOT_FOUND';

    533:
     result := 'ACCOUNT_DISABLED';

    701:
     result := 'ACCOUNT_EXPIRED';

    773:
     result := 'PASSWORD_EXPIRED';

    775:
     result := 'ACCOUNT_LOCKED';
  else
     result := 'UNKNOWN_ERROR'

  end;

end;

class function TLogger.Sanitize(const AValue: string): string;
begin

  // evita JSON do tipo...
  //   {
  //    "login": "admin|ERROR",
  //    "password": "123"
  //   }
  //   evitando erros ao gerar o log


  Result := AValue;

  // remove quebra de linha
  Result := StringReplace(Result, sLineBreak, '', [rfReplaceAll]);

  // remove CR
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);

  // remove LF
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);

  // remove pipe
  Result := StringReplace(Result, '|', '', [rfReplaceAll]);

  // remove TAB
  Result := StringReplace(Result, #9, '', [rfReplaceAll]);

end;

end.
