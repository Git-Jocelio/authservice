unit AuthService.Provider.LDAP;


interface

uses
  AuthService.Provider.Interfaces;

type
  TLDAPProvider = class(TInterfacedObject, IAuthProvider)
  public
    function Authenticate(const ALogin, APassword: string): Boolean;
  end;

implementation

uses
  System.SysUtils,
  ldapsend, AuthService.Config;

function TLDAPProvider.Authenticate(const ALogin, APassword: string): Boolean;
var
  LDAP: TLDAPSend;
begin
  result := False;

  LDAP := TLDAPSend.Create;

  try

    LDAP.TargetHost := TConfig.GetInstance.Host;

   LDAP.TargetPort := IntToStr(TConfig.GetInstance.Port);

    // teste conexão
    Result := LDAP.Login;

  finally
    LDAP.Free;
  end;

end;

end.
