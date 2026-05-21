program AuthService;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  AuthService.Config in '..\config\AuthService.Config.pas',
  AuthService.Utils in '..\utils\AuthService.Utils.pas',
  AuthService.Routes in '..\routes\AuthService.Routes.pas',
  AuthService.Middleware.JWT in '..\middlewares\AuthService.Middleware.JWT.pas';


begin
  try
    TLogger.Write('Serviço Iniciando...');
    TConfig.GetInstance; // busca configurações no arquivo ini e carrega o host armazenado. ex.: 127.0.0.1
    TLogger.Write('Configuração carregada. Host AD: ' + TConfig.GetInstance.Host);

    // configura rotas
    RegisterRoutes;

    TLogger.Write('LDAP Host: ' + TConfig.GetInstance.Host );
    TLogger.Write('LDAP Port: ' +  IntToStr(TConfig.GetInstance.Port) );

    THorse.Listen(TConfig.GetInstance.ServerPort);

  except
    on E: Exception do
    begin
      TLogger.Error('Falha na Inicialização: ' + E.Message);
      Writeln('Erro critico: ' + E.Message);
      Readln; // <--- Segura a janela para você ler o erro na tela também
    end;
end;

end.
