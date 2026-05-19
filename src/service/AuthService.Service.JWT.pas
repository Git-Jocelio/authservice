// responsável pela geração e validação de tokens JWT
// utilizados após autenticação do usuário no Active Directory

unit AuthService.Service.JWT;

interface

uses
  Horse,
  Horse.JWT,
  JOSE.Core.JWT,
  JOSE.Types.JSON,
  JOSE.Core.Builder,
  System.JSON,
  System.SysUtils,
  System.DateUtils;

const
  SECRET = 'Assel@2026';

type

  TMYClaims = class(TJWTClaims)

  strict private


    function GetLogin: string;
    procedure SetLogin(const Value: string);

  public


    // login amigável usuário
    property LOGIN: string read GetLogin write SetLogin;

  end;


// cria token JWT após autenticação AD
function Criar_Token(ALogin: string): string;


// obtém usuário da requisição JWT
function Get_Usuario_Request(req: THorseRequest): string;


implementation


function Criar_Token(ALogin: string): string;
var
  jwt : TJWT;
  claims : TMYClaims;
begin
  Result := '';
  jwt := TJWT.Create;

  try
    claims := TMYClaims(jwt.Claims);

    // claims do token
    claims.LOGIN := ALogin;

    // expiração token
    claims.Expiration := IncHour(Now, 1);

    // data criação token
    claims.IssuedAt := Now;

    // emissor token
    claims.Issuer := 'AuthService';

    // gera token JWT
    Result := TJOSE.SHA256CompactToken(SECRET, jwt);

  finally
    jwt.Free;
  end;

end;


function Get_Usuario_Request(req: THorseRequest): string;
var
  claims : TMYClaims;
begin
  claims := req.Session<TMYClaims>;

  // retorna login usuário autenticado
  Result := claims.LOGIN;
end;


{ TMYClaims }

function TMYClaims.GetLogin: string;
begin
  Result := FJSON.GetValue<string>('login','');
end;

procedure TMYClaims.SetLogin(const Value: string);
begin
  TJSONUtils.SetJSONValueFrom<string>('login', Value, FJSON);
end;


end.
