program AuthService;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  AuthService.Config in '..\config\AuthService.Config.pas',
  AuthService.Utils in '..\utils\AuthService.Utils.pas';

begin
  try
    TLogger.Write('Serviço Iniciando...');
    TConfig.GetInstance; // Tenta carregar
    TLogger.Write('Configuração carregada. Host AD: ' + TConfig.GetInstance.Host);

    Writeln('Servidor rodando... Pressione ENTER para sair.');
    Readln; // <--- Isso segura a janela aberta

  except
    on E: Exception do
    begin
      TLogger.Error('Falha Crítica na Inicialização: ' + E.Message);
      Writeln('Erro critico: ' + E.Message);
      Readln; // <--- Segura a janela para você ler o erro na tela também
    end;
end;

end.
