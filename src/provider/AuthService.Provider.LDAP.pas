unit AuthService.Provider.LDAP;


interface

uses
  AuthService.Provider.Interfaces;

type
  TLDAPProvider = class(TInterfacedObject, IAuthProvider)
  public
    function Authenticate(const ALogin, APassword, AIP: string): Boolean;
  end;

implementation

uses
  System.SysUtils,
  ldapsend,
  AuthService.Config,
  AuthService.Utils;

function TLDAPProvider.Authenticate(const ALogin, APassword, AIP: string): Boolean;
var
  LDAP: TLDAPSend;
  LUserPrincipalName : string;
begin
  result := False;

  LDAP := TLDAPSend.Create;
  try

    //configura servidor e porta LDAP
    LDAP.TargetHost := TConfig.GetInstance.Host;
    LDAP.TargetPort := IntToStr(TConfig.GetInstance.Port);

    //timeout conexão LDAP( se AD travar API pode fica presa esperando
    LDAP.Timeout := TConfig.GetInstance.Timeout * 1000;

    //monta usuário e dominio --> ex.: compbyte\vgomes
    LUserPrincipalName := 'compbyte\' + ALogin;

    //credenciais
    LDAP.UserName := LUserPrincipalName;
    LDAP.Password := APassword;

    //registro no log
    TLogger.Write('Tentando autenticar: ' + LUserPrincipalName);

    if LDAP.Login then
    begin

      result := LDAP.Bind;

      if result then
        TLogger.AuthSuccess(ALogin, AIP , LDAP.ResultCode)
      else
        TLogger.AuthFailed(ALogin, AIP, LDAP.ResultCode);

     end
     else
     begin
       TLogger.Error('LDAP connection failed: ' + 'TIMEOUT OR UNREACHABLE SERVER');
     end;

  finally
    LDAP.Free;
  end;

end;

end.
