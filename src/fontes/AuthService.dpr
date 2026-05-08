program AuthService;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  AuthService.Config in '..\config\AuthService.Config.pas',
  AuthService.Utils in '..\utils\AuthService.Utils.pas',
  AuthService.Provider.AD in '..\provider\AuthService.Provider.AD.pas',
  AuthService.Routes in '..\routes\AuthService.Routes.pas',
  AuthService.Model.Login in '..\model\AuthService.Model.Login.pas',
  AuthService.Provider.Mock in '..\provider\AuthService.Provider.Mock.pas',
  AuthService.Service.Login in '..\service\AuthService.Service.Login.pas',
  AuthService.Controller.Login in '..\controller\AuthService.Controller.Login.pas';

begin
  try
    TLogger.Write('Serviço Iniciando...');
    TConfig.GetInstance; // Tenta carregar
    TLogger.Write('Configuração carregada. Host AD: ' + TConfig.GetInstance.Host);

    RegisterRoutes;


    TLogger.Write('Serviço rodando na porta 9000...');

    THorse.Listen(9000);

  except
    on E: Exception do
    begin
      TLogger.Error('Falha Crítica na Inicialização: ' + E.Message);
      Writeln('Erro critico: ' + E.Message);
      Readln; // <--- Segura a janela para você ler o erro na tela também
    end;
end;

end.
