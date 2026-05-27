unit AuthService.Provider.LDAP;


interface

uses
  AuthService.Provider.Interfaces,
  AuthService.Model.User;

type
  TLDAPProvider = class(TInterfacedObject, IAuthProvider)
  public
    function Authenticate(const ALogin, APassword, AIP: string): Boolean;
    function GetUsers(const ALogin, APassword, AIP: string): TArray<TADUser>;
  end;

implementation

uses
  System.SysUtils,
  ldapsend,
  AuthService.Config,
  AuthService.Utils,
  System.Classes;

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


function TLDAPProvider.GetUsers(const ALogin, APassword, AIP: string): TArray<TADUser>;
var
  LDAP : TLDAPSend;
  LUser: TADUser;
  I:integer;
  LUserPrincipalName : string;
  LAttributes: TStringList;

begin
  setLength(Result,0);
  LDAP := TLDAPSend.Create;
  LAttributes := TStringList.Create;

  try
    //configura servidor e porta LDAP
    LDAP.TargetHost := TConfig.GetInstance.Host;
    LDAP.TargetPort := IntToStr(TConfig.GetInstance.Port);
    LDAP.Timeout    := TConfig.GetInstance.Timeout * 1000;

    LAttributes.add('cn');
    LAttributes.add('sAMAccountName');
    LAttributes.add('mail');

{   // debug
    LAttributes.add('*');
    LAttributes.add('*');
    LAttributes.add('*');
}
    //credenciais
    LUserPrincipalName := 'compbyte\' + ALogin;
    LDAP.UserName := LUserPrincipalName;
    LDAP.Password := APassword;

    if LDAP.Login then
    begin
      if LDAP.Bind then
      begin
        //filtro LDAP
        if LDAP.Search(
                  TConfig.GetInstance.BaseDN,
                  false,
                 '(&(objectClass=user)(objectCategory=person))',
                  LAttributes
                  ) then
        begin
          for I := 0 to LDAP.SearchResult.Count -1 do
          begin

           SetLength(Result, Length(Result) +1);

           LUser.Name := LDAP.SearchResult.Items[I].Attributes.Get('cn');

           LUser.Login := LDAP.SearchResult.Items[I].Attributes.Get('sAMAccountName');

           LUser.Email := LDAP.SearchResult.Items[I].Attributes.Get('mail');

           Result[High(Result)] := LUser;

           //debug
           //TLogger.Write(LDAPResultDump(LDAP.SearchResult));

          end;
        end;
        // debug
        //TLogger.Write('LDAP Search Count: ' + inttostr(LDAP.SearchResult.Count));
      end;
    end;
  finally
    LAttributes.free;
    LDAP.Free;
  end;

end;

end.
