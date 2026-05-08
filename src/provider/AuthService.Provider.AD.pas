unit AuthService.Provider.AD;
// deu erro da em winapi.winldap vou ver de outra forma
interface

uses
//  winapi.WinLDAP,
  Winapi.Windows,
  System.SysUtils,
  AuthService.Config,
  AuthService.Utils;

type
  TADProvider = class
  public
    /// <summary>
    ///  Tenta realizar o Bind (login) no servidor LDAP/AD
    /// </summary>
//    class function ValidarLogin(const AUsuario, ASenha: string): Boolean;
  end;

implementation

{ TADProvider }
(*
class function TADProvider.ValidarLogin(const AUsuario, ASenha: string): Boolean;
var
  LdapHandle: PLDAP;
  LRetorno: Integer;
  LDN: string;
  LConfig: TConfig;
begin
  Result := False;
  LConfig := TConfig.GetInstance;

  // 1. Inicializa a estrutura de conexão com Host e Porta do seu .ini
  LdapHandle := ldap_init(PChar(LConfig.Host), LConfig.Port);

  if LdapHandle = nil then
  begin
    TLogger.Error('Falha ao inicializar LDAP no Host: ' + LConfig.Host);
    Exit;
  end;

  try
    // 2. Configura a versão do protocolo para LDAP v3 (essencial para ApacheDS e AD)
    LRetorno := LDAP_VERSION3;
    ldap_set_option(LdapHandle, LDAP_OPT_PROTOCOL_VERSION, @LRetorno);

    // 3. Define o Timeout de conexão (conforme seu requisito de 5 segundos)
    // Nota: O Winldap usa milissegundos em algumas versões ou segundos em outras,
    // ldap_set_option com LDAP_OPT_TIMELIMIT define o limite de busca.
    LRetorno := LConfig.Timeout;
    ldap_set_option(LdapHandle, LDAP_OPT_TIMELIMIT, @LRetorno);

    // 4. Monta o Distinguished Name (DN)
    // Para Docker ApacheDS geralmente é: uid=jgsilva,ou=users,dc=example,dc=com
    // Ajuste o BaseDN no seu arquivo .ini conforme sua partição no Docker
    LDN := Format('uid=%s,%s', [AUsuario, LConfig.BaseDN]);

    // 5. O BIND: É aqui que a senha é validada de fato
    // Se a senha estiver correta e o DN existir, retorna LDAP_SUCCESS (0)
    LRetorno := ldap_simple_bind_s(LdapHandle, PChar(LDN), PChar(ASenha));

    if LRetorno = LDAP_SUCCESS then
    begin
      Result := True;
    end
    else
    begin
      // Registra o erro específico no Log para debugar (Ex: Erro 49 = Credenciais Inválidas)
      TLogger.Write(Format('Tentativa de Login Falhou | Usuário: %s | Erro LDAP: %d', [AUsuario, LRetorno]));
    end;

  finally
    // 6. Encerra a conexão e libera memória da DLL
    ldap_unbind(LdapHandle);
  end;
end;
       *)
end.
