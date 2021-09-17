//
// Created by the DataSnap proxy generator.
// 2017/7/5 14:57:04
//

unit ClientClassesUnit1;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FCheckNewVersionCommand: TDSRestCommand;
    FRegisterUserCommand: TDSRestCommand;
    FSendRegisterCaptchaCommand: TDSRestCommand;
    FSendForgetPasswordCaptchaCommand: TDSRestCommand;
    FCheckForgetPasswordCaptchaCommand: TDSRestCommand;
    FReSetPasswordCommand: TDSRestCommand;
    FChangePasswordCommand: TDSRestCommand;
    FLoginCommand: TDSRestCommand;
    FUpdateUserInfoCommand: TDSRestCommand;
    FUpdateUserHeadCommand: TDSRestCommand;
    FGetUserInfoCommand: TDSRestCommand;
    FWantedShieldUserCommand: TDSRestCommand;
    FCanCelledShieldUserCommand: TDSRestCommand;
    FGetShieldUserListCommand: TDSRestCommand;
    FWantedComplainUserCommand: TDSRestCommand;
    FGetUserSpiritListCommand: TDSRestCommand;
    FAddSpiritCommand: TDSRestCommand;
    FAddSpirit_V2Command: TDSRestCommand;
    FDelSpiritCommand: TDSRestCommand;
    FLikeSpiritCommand: TDSRestCommand;
    FCancelLikeSpiritCommand: TDSRestCommand;
    FCommentSpiritCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function CheckNewVersion(const ARequestFilter: string = ''): string;
    function RegisterUser(AName: string; APhone: string; ACaptcha: string; APassword: string; ARePassword: string; const ARequestFilter: string = ''): string;
    function SendRegisterCaptcha(APhone: string; const ARequestFilter: string = ''): string;
    function SendForgetPasswordCaptcha(APhone: string; const ARequestFilter: string = ''): string;
    function CheckForgetPasswordCaptcha(APhone: string; ACaptcha: string; const ARequestFilter: string = ''): string;
    function ReSetPassword(APhone: string; ACaptcha: string; APassword: string; ARePassword: string; const ARequestFilter: string = ''): string;
    function ChangePassword(AUserID: Integer; ALoginKey: string; AOldPassword: string; APassword: string; ARePassword: string; const ARequestFilter: string = ''): string;
    function Login(ALoginUser: string; APassword: string; AVersion: string; const ARequestFilter: string = ''): string;
    function UpdateUserInfo(AUserID: Integer; ALoginKey: string; AUpdateJsonStr: string; const ARequestFilter: string = ''): string;
    function UpdateUserHead(AUserID: Integer; ALoginKey: string; AHeadPic: string; const ARequestFilter: string = ''): string;
    function GetUserInfo(AUserID: Integer; ALoginUserID: Integer; const ARequestFilter: string = ''): string;
    function WantedShieldUser(AUserFID: Integer; AShieldUserFID: Integer; const ARequestFilter: string = ''): string;
    function CanCelledShieldUser(AUserFID: Integer; AShieldUserFID: Integer; const ARequestFilter: string = ''): string;
    function GetShieldUserList(AUserFID: Integer; const ARequestFilter: string = ''): string;
    function WantedComplainUser(AUserFID: Integer; AComplainUserFID: Integer; AType: string; AComplainContant: string; const ARequestFilter: string = ''): string;
    function GetUserSpiritList(AUserID: Integer; ALoginKey: string; APageIndex: Integer; APageSize: Integer; const ARequestFilter: string = ''): string;
    function AddSpirit(AUserID: Integer; ALoginKey: string; ASpirit: string; APic1: string; APic2: string; APic3: string; APic4: string; APic5: string; APic6: string; APic7: string; APic8: string; APic9: string; APic1Width: Integer; APic1Height: Integer; const ARequestFilter: string = ''): string;
    function AddSpirit_V2(AUserID: Integer; ALoginKey: string; ASpirit: string; APic1: string; APic2: string; APic3: string; APic4: string; APic5: string; APic6: string; APic7: string; APic8: string; APic9: string; APic1Width: Integer; APic1Height: Integer; ALatitude: Double; ALongitude: Double; AAddr: string; APhoneType: string; const ARequestFilter: string = ''): string;
    function DelSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; const ARequestFilter: string = ''): string;
    function LikeSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; const ARequestFilter: string = ''): string;
    function CancelLikeSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; const ARequestFilter: string = ''): string;
    function CommentSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; AComment: string; AReplyUserID: Integer; const ARequestFilter: string = ''): string;
  end;

const
  TServerMethods1_EchoString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ReverseString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_CheckNewVersion: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_RegisterUser: array [0..5] of TDSRestParameterMetaData =
  (
    (Name: 'AName'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APhone'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ACaptcha'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ARePassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_SendRegisterCaptcha: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'APhone'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_SendForgetPasswordCaptcha: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'APhone'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_CheckForgetPasswordCaptcha: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'APhone'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ACaptcha'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ReSetPassword: array [0..4] of TDSRestParameterMetaData =
  (
    (Name: 'APhone'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ACaptcha'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ARePassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ChangePassword: array [0..5] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AOldPassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ARePassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_Login: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'ALoginUser'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APassword'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AVersion'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_UpdateUserInfo: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AUpdateJsonStr'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_UpdateUserHead: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AHeadPic'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_GetUserInfo: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_WantedShieldUser: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'AUserFID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'AShieldUserFID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_CanCelledShieldUser: array [0..2] of TDSRestParameterMetaData =
  (
    (Name: 'AUserFID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'AShieldUserFID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_GetShieldUserList: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'AUserFID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_WantedComplainUser: array [0..4] of TDSRestParameterMetaData =
  (
    (Name: 'AUserFID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'AComplainUserFID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'AType'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AComplainContant'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_GetUserSpiritList: array [0..4] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APageIndex'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'APageSize'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_AddSpirit: array [0..14] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ASpirit'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic1'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic2'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic3'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic4'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic5'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic6'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic7'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic8'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic9'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic1Width'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'APic1Height'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_AddSpirit_V2: array [0..18] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ASpirit'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic1'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic2'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic3'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic4'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic5'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic6'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic7'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic8'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic9'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APic1Width'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'APic1Height'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALatitude'; Direction: 1; DBXType: 7; TypeName: 'Double'),
    (Name: 'ALongitude'; Direction: 1; DBXType: 7; TypeName: 'Double'),
    (Name: 'AAddr'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'APhoneType'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_DelSpirit: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ASpiritID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_LikeSpirit: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ASpiritID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_CancelLikeSpirit: array [0..3] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ASpiritID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_CommentSpirit: array [0..5] of TDSRestParameterMetaData =
  (
    (Name: 'AUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'ALoginKey'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'ASpiritID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: 'AComment'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AReplyUserID'; Direction: 1; DBXType: 6; TypeName: 'Integer'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

implementation

function TServerMethods1Client.EchoString(Value: string; const ARequestFilter: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FConnection.CreateCommand;
    FEchoStringCommand.RequestType := 'GET';
    FEchoStringCommand.Text := 'TServerMethods1.EchoString';
    FEchoStringCommand.Prepare(TServerMethods1_EchoString);
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.Execute(ARequestFilter);
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.ReverseString(Value: string; const ARequestFilter: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FConnection.CreateCommand;
    FReverseStringCommand.RequestType := 'GET';
    FReverseStringCommand.Text := 'TServerMethods1.ReverseString';
    FReverseStringCommand.Prepare(TServerMethods1_ReverseString);
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.Execute(ARequestFilter);
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.CheckNewVersion(const ARequestFilter: string): string;
begin
  if FCheckNewVersionCommand = nil then
  begin
    FCheckNewVersionCommand := FConnection.CreateCommand;
    FCheckNewVersionCommand.RequestType := 'GET';
    FCheckNewVersionCommand.Text := 'TServerMethods1.CheckNewVersion';
    FCheckNewVersionCommand.Prepare(TServerMethods1_CheckNewVersion);
  end;
  FCheckNewVersionCommand.Execute(ARequestFilter);
  Result := FCheckNewVersionCommand.Parameters[0].Value.GetWideString;
end;

function TServerMethods1Client.RegisterUser(AName: string; APhone: string; ACaptcha: string; APassword: string; ARePassword: string; const ARequestFilter: string): string;
begin
  if FRegisterUserCommand = nil then
  begin
    FRegisterUserCommand := FConnection.CreateCommand;
    FRegisterUserCommand.RequestType := 'GET';
    FRegisterUserCommand.Text := 'TServerMethods1.RegisterUser';
    FRegisterUserCommand.Prepare(TServerMethods1_RegisterUser);
  end;
  FRegisterUserCommand.Parameters[0].Value.SetWideString(AName);
  FRegisterUserCommand.Parameters[1].Value.SetWideString(APhone);
  FRegisterUserCommand.Parameters[2].Value.SetWideString(ACaptcha);
  FRegisterUserCommand.Parameters[3].Value.SetWideString(APassword);
  FRegisterUserCommand.Parameters[4].Value.SetWideString(ARePassword);
  FRegisterUserCommand.Execute(ARequestFilter);
  Result := FRegisterUserCommand.Parameters[5].Value.GetWideString;
end;

function TServerMethods1Client.SendRegisterCaptcha(APhone: string; const ARequestFilter: string): string;
begin
  if FSendRegisterCaptchaCommand = nil then
  begin
    FSendRegisterCaptchaCommand := FConnection.CreateCommand;
    FSendRegisterCaptchaCommand.RequestType := 'GET';
    FSendRegisterCaptchaCommand.Text := 'TServerMethods1.SendRegisterCaptcha';
    FSendRegisterCaptchaCommand.Prepare(TServerMethods1_SendRegisterCaptcha);
  end;
  FSendRegisterCaptchaCommand.Parameters[0].Value.SetWideString(APhone);
  FSendRegisterCaptchaCommand.Execute(ARequestFilter);
  Result := FSendRegisterCaptchaCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.SendForgetPasswordCaptcha(APhone: string; const ARequestFilter: string): string;
begin
  if FSendForgetPasswordCaptchaCommand = nil then
  begin
    FSendForgetPasswordCaptchaCommand := FConnection.CreateCommand;
    FSendForgetPasswordCaptchaCommand.RequestType := 'GET';
    FSendForgetPasswordCaptchaCommand.Text := 'TServerMethods1.SendForgetPasswordCaptcha';
    FSendForgetPasswordCaptchaCommand.Prepare(TServerMethods1_SendForgetPasswordCaptcha);
  end;
  FSendForgetPasswordCaptchaCommand.Parameters[0].Value.SetWideString(APhone);
  FSendForgetPasswordCaptchaCommand.Execute(ARequestFilter);
  Result := FSendForgetPasswordCaptchaCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.CheckForgetPasswordCaptcha(APhone: string; ACaptcha: string; const ARequestFilter: string): string;
begin
  if FCheckForgetPasswordCaptchaCommand = nil then
  begin
    FCheckForgetPasswordCaptchaCommand := FConnection.CreateCommand;
    FCheckForgetPasswordCaptchaCommand.RequestType := 'GET';
    FCheckForgetPasswordCaptchaCommand.Text := 'TServerMethods1.CheckForgetPasswordCaptcha';
    FCheckForgetPasswordCaptchaCommand.Prepare(TServerMethods1_CheckForgetPasswordCaptcha);
  end;
  FCheckForgetPasswordCaptchaCommand.Parameters[0].Value.SetWideString(APhone);
  FCheckForgetPasswordCaptchaCommand.Parameters[1].Value.SetWideString(ACaptcha);
  FCheckForgetPasswordCaptchaCommand.Execute(ARequestFilter);
  Result := FCheckForgetPasswordCaptchaCommand.Parameters[2].Value.GetWideString;
end;

function TServerMethods1Client.ReSetPassword(APhone: string; ACaptcha: string; APassword: string; ARePassword: string; const ARequestFilter: string): string;
begin
  if FReSetPasswordCommand = nil then
  begin
    FReSetPasswordCommand := FConnection.CreateCommand;
    FReSetPasswordCommand.RequestType := 'GET';
    FReSetPasswordCommand.Text := 'TServerMethods1.ReSetPassword';
    FReSetPasswordCommand.Prepare(TServerMethods1_ReSetPassword);
  end;
  FReSetPasswordCommand.Parameters[0].Value.SetWideString(APhone);
  FReSetPasswordCommand.Parameters[1].Value.SetWideString(ACaptcha);
  FReSetPasswordCommand.Parameters[2].Value.SetWideString(APassword);
  FReSetPasswordCommand.Parameters[3].Value.SetWideString(ARePassword);
  FReSetPasswordCommand.Execute(ARequestFilter);
  Result := FReSetPasswordCommand.Parameters[4].Value.GetWideString;
end;

function TServerMethods1Client.ChangePassword(AUserID: Integer; ALoginKey: string; AOldPassword: string; APassword: string; ARePassword: string; const ARequestFilter: string): string;
begin
  if FChangePasswordCommand = nil then
  begin
    FChangePasswordCommand := FConnection.CreateCommand;
    FChangePasswordCommand.RequestType := 'GET';
    FChangePasswordCommand.Text := 'TServerMethods1.ChangePassword';
    FChangePasswordCommand.Prepare(TServerMethods1_ChangePassword);
  end;
  FChangePasswordCommand.Parameters[0].Value.SetInt32(AUserID);
  FChangePasswordCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FChangePasswordCommand.Parameters[2].Value.SetWideString(AOldPassword);
  FChangePasswordCommand.Parameters[3].Value.SetWideString(APassword);
  FChangePasswordCommand.Parameters[4].Value.SetWideString(ARePassword);
  FChangePasswordCommand.Execute(ARequestFilter);
  Result := FChangePasswordCommand.Parameters[5].Value.GetWideString;
end;

function TServerMethods1Client.Login(ALoginUser: string; APassword: string; AVersion: string; const ARequestFilter: string): string;
begin
  if FLoginCommand = nil then
  begin
    FLoginCommand := FConnection.CreateCommand;
    FLoginCommand.RequestType := 'GET';
    FLoginCommand.Text := 'TServerMethods1.Login';
    FLoginCommand.Prepare(TServerMethods1_Login);
  end;
  FLoginCommand.Parameters[0].Value.SetWideString(ALoginUser);
  FLoginCommand.Parameters[1].Value.SetWideString(APassword);
  FLoginCommand.Parameters[2].Value.SetWideString(AVersion);
  FLoginCommand.Execute(ARequestFilter);
  Result := FLoginCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.UpdateUserInfo(AUserID: Integer; ALoginKey: string; AUpdateJsonStr: string; const ARequestFilter: string): string;
begin
  if FUpdateUserInfoCommand = nil then
  begin
    FUpdateUserInfoCommand := FConnection.CreateCommand;
    FUpdateUserInfoCommand.RequestType := 'GET';
    FUpdateUserInfoCommand.Text := 'TServerMethods1.UpdateUserInfo';
    FUpdateUserInfoCommand.Prepare(TServerMethods1_UpdateUserInfo);
  end;
  FUpdateUserInfoCommand.Parameters[0].Value.SetInt32(AUserID);
  FUpdateUserInfoCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FUpdateUserInfoCommand.Parameters[2].Value.SetWideString(AUpdateJsonStr);
  FUpdateUserInfoCommand.Execute(ARequestFilter);
  Result := FUpdateUserInfoCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.UpdateUserHead(AUserID: Integer; ALoginKey: string; AHeadPic: string; const ARequestFilter: string): string;
begin
  if FUpdateUserHeadCommand = nil then
  begin
    FUpdateUserHeadCommand := FConnection.CreateCommand;
    FUpdateUserHeadCommand.RequestType := 'GET';
    FUpdateUserHeadCommand.Text := 'TServerMethods1.UpdateUserHead';
    FUpdateUserHeadCommand.Prepare(TServerMethods1_UpdateUserHead);
  end;
  FUpdateUserHeadCommand.Parameters[0].Value.SetInt32(AUserID);
  FUpdateUserHeadCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FUpdateUserHeadCommand.Parameters[2].Value.SetWideString(AHeadPic);
  FUpdateUserHeadCommand.Execute(ARequestFilter);
  Result := FUpdateUserHeadCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.GetUserInfo(AUserID: Integer; ALoginUserID: Integer; const ARequestFilter: string): string;
begin
  if FGetUserInfoCommand = nil then
  begin
    FGetUserInfoCommand := FConnection.CreateCommand;
    FGetUserInfoCommand.RequestType := 'GET';
    FGetUserInfoCommand.Text := 'TServerMethods1.GetUserInfo';
    FGetUserInfoCommand.Prepare(TServerMethods1_GetUserInfo);
  end;
  FGetUserInfoCommand.Parameters[0].Value.SetInt32(AUserID);
  FGetUserInfoCommand.Parameters[1].Value.SetInt32(ALoginUserID);
  FGetUserInfoCommand.Execute(ARequestFilter);
  Result := FGetUserInfoCommand.Parameters[2].Value.GetWideString;
end;

function TServerMethods1Client.WantedShieldUser(AUserFID: Integer; AShieldUserFID: Integer; const ARequestFilter: string): string;
begin
  if FWantedShieldUserCommand = nil then
  begin
    FWantedShieldUserCommand := FConnection.CreateCommand;
    FWantedShieldUserCommand.RequestType := 'GET';
    FWantedShieldUserCommand.Text := 'TServerMethods1.WantedShieldUser';
    FWantedShieldUserCommand.Prepare(TServerMethods1_WantedShieldUser);
  end;
  FWantedShieldUserCommand.Parameters[0].Value.SetInt32(AUserFID);
  FWantedShieldUserCommand.Parameters[1].Value.SetInt32(AShieldUserFID);
  FWantedShieldUserCommand.Execute(ARequestFilter);
  Result := FWantedShieldUserCommand.Parameters[2].Value.GetWideString;
end;

function TServerMethods1Client.CanCelledShieldUser(AUserFID: Integer; AShieldUserFID: Integer; const ARequestFilter: string): string;
begin
  if FCanCelledShieldUserCommand = nil then
  begin
    FCanCelledShieldUserCommand := FConnection.CreateCommand;
    FCanCelledShieldUserCommand.RequestType := 'GET';
    FCanCelledShieldUserCommand.Text := 'TServerMethods1.CanCelledShieldUser';
    FCanCelledShieldUserCommand.Prepare(TServerMethods1_CanCelledShieldUser);
  end;
  FCanCelledShieldUserCommand.Parameters[0].Value.SetInt32(AUserFID);
  FCanCelledShieldUserCommand.Parameters[1].Value.SetInt32(AShieldUserFID);
  FCanCelledShieldUserCommand.Execute(ARequestFilter);
  Result := FCanCelledShieldUserCommand.Parameters[2].Value.GetWideString;
end;

function TServerMethods1Client.GetShieldUserList(AUserFID: Integer; const ARequestFilter: string): string;
begin
  if FGetShieldUserListCommand = nil then
  begin
    FGetShieldUserListCommand := FConnection.CreateCommand;
    FGetShieldUserListCommand.RequestType := 'GET';
    FGetShieldUserListCommand.Text := 'TServerMethods1.GetShieldUserList';
    FGetShieldUserListCommand.Prepare(TServerMethods1_GetShieldUserList);
  end;
  FGetShieldUserListCommand.Parameters[0].Value.SetInt32(AUserFID);
  FGetShieldUserListCommand.Execute(ARequestFilter);
  Result := FGetShieldUserListCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.WantedComplainUser(AUserFID: Integer; AComplainUserFID: Integer; AType: string; AComplainContant: string; const ARequestFilter: string): string;
begin
  if FWantedComplainUserCommand = nil then
  begin
    FWantedComplainUserCommand := FConnection.CreateCommand;
    FWantedComplainUserCommand.RequestType := 'GET';
    FWantedComplainUserCommand.Text := 'TServerMethods1.WantedComplainUser';
    FWantedComplainUserCommand.Prepare(TServerMethods1_WantedComplainUser);
  end;
  FWantedComplainUserCommand.Parameters[0].Value.SetInt32(AUserFID);
  FWantedComplainUserCommand.Parameters[1].Value.SetInt32(AComplainUserFID);
  FWantedComplainUserCommand.Parameters[2].Value.SetWideString(AType);
  FWantedComplainUserCommand.Parameters[3].Value.SetWideString(AComplainContant);
  FWantedComplainUserCommand.Execute(ARequestFilter);
  Result := FWantedComplainUserCommand.Parameters[4].Value.GetWideString;
end;

function TServerMethods1Client.GetUserSpiritList(AUserID: Integer; ALoginKey: string; APageIndex: Integer; APageSize: Integer; const ARequestFilter: string): string;
begin
  if FGetUserSpiritListCommand = nil then
  begin
    FGetUserSpiritListCommand := FConnection.CreateCommand;
    FGetUserSpiritListCommand.RequestType := 'GET';
    FGetUserSpiritListCommand.Text := 'TServerMethods1.GetUserSpiritList';
    FGetUserSpiritListCommand.Prepare(TServerMethods1_GetUserSpiritList);
  end;
  FGetUserSpiritListCommand.Parameters[0].Value.SetInt32(AUserID);
  FGetUserSpiritListCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FGetUserSpiritListCommand.Parameters[2].Value.SetInt32(APageIndex);
  FGetUserSpiritListCommand.Parameters[3].Value.SetInt32(APageSize);
  FGetUserSpiritListCommand.Execute(ARequestFilter);
  Result := FGetUserSpiritListCommand.Parameters[4].Value.GetWideString;
end;

function TServerMethods1Client.AddSpirit(AUserID: Integer; ALoginKey: string; ASpirit: string; APic1: string; APic2: string; APic3: string; APic4: string; APic5: string; APic6: string; APic7: string; APic8: string; APic9: string; APic1Width: Integer; APic1Height: Integer; const ARequestFilter: string): string;
begin
  if FAddSpiritCommand = nil then
  begin
    FAddSpiritCommand := FConnection.CreateCommand;
    FAddSpiritCommand.RequestType := 'GET';
    FAddSpiritCommand.Text := 'TServerMethods1.AddSpirit';
    FAddSpiritCommand.Prepare(TServerMethods1_AddSpirit);
  end;
  FAddSpiritCommand.Parameters[0].Value.SetInt32(AUserID);
  FAddSpiritCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FAddSpiritCommand.Parameters[2].Value.SetWideString(ASpirit);
  FAddSpiritCommand.Parameters[3].Value.SetWideString(APic1);
  FAddSpiritCommand.Parameters[4].Value.SetWideString(APic2);
  FAddSpiritCommand.Parameters[5].Value.SetWideString(APic3);
  FAddSpiritCommand.Parameters[6].Value.SetWideString(APic4);
  FAddSpiritCommand.Parameters[7].Value.SetWideString(APic5);
  FAddSpiritCommand.Parameters[8].Value.SetWideString(APic6);
  FAddSpiritCommand.Parameters[9].Value.SetWideString(APic7);
  FAddSpiritCommand.Parameters[10].Value.SetWideString(APic8);
  FAddSpiritCommand.Parameters[11].Value.SetWideString(APic9);
  FAddSpiritCommand.Parameters[12].Value.SetInt32(APic1Width);
  FAddSpiritCommand.Parameters[13].Value.SetInt32(APic1Height);
  FAddSpiritCommand.Execute(ARequestFilter);
  Result := FAddSpiritCommand.Parameters[14].Value.GetWideString;
end;

function TServerMethods1Client.AddSpirit_V2(AUserID: Integer; ALoginKey: string; ASpirit: string; APic1: string; APic2: string; APic3: string; APic4: string; APic5: string; APic6: string; APic7: string; APic8: string; APic9: string; APic1Width: Integer; APic1Height: Integer; ALatitude: Double; ALongitude: Double; AAddr: string; APhoneType: string; const ARequestFilter: string): string;
begin
  if FAddSpirit_V2Command = nil then
  begin
    FAddSpirit_V2Command := FConnection.CreateCommand;
    FAddSpirit_V2Command.RequestType := 'GET';
    FAddSpirit_V2Command.Text := 'TServerMethods1.AddSpirit_V2';
    FAddSpirit_V2Command.Prepare(TServerMethods1_AddSpirit_V2);
  end;
  FAddSpirit_V2Command.Parameters[0].Value.SetInt32(AUserID);
  FAddSpirit_V2Command.Parameters[1].Value.SetWideString(ALoginKey);
  FAddSpirit_V2Command.Parameters[2].Value.SetWideString(ASpirit);
  FAddSpirit_V2Command.Parameters[3].Value.SetWideString(APic1);
  FAddSpirit_V2Command.Parameters[4].Value.SetWideString(APic2);
  FAddSpirit_V2Command.Parameters[5].Value.SetWideString(APic3);
  FAddSpirit_V2Command.Parameters[6].Value.SetWideString(APic4);
  FAddSpirit_V2Command.Parameters[7].Value.SetWideString(APic5);
  FAddSpirit_V2Command.Parameters[8].Value.SetWideString(APic6);
  FAddSpirit_V2Command.Parameters[9].Value.SetWideString(APic7);
  FAddSpirit_V2Command.Parameters[10].Value.SetWideString(APic8);
  FAddSpirit_V2Command.Parameters[11].Value.SetWideString(APic9);
  FAddSpirit_V2Command.Parameters[12].Value.SetInt32(APic1Width);
  FAddSpirit_V2Command.Parameters[13].Value.SetInt32(APic1Height);
  FAddSpirit_V2Command.Parameters[14].Value.SetDouble(ALatitude);
  FAddSpirit_V2Command.Parameters[15].Value.SetDouble(ALongitude);
  FAddSpirit_V2Command.Parameters[16].Value.SetWideString(AAddr);
  FAddSpirit_V2Command.Parameters[17].Value.SetWideString(APhoneType);
  FAddSpirit_V2Command.Execute(ARequestFilter);
  Result := FAddSpirit_V2Command.Parameters[18].Value.GetWideString;
end;

function TServerMethods1Client.DelSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; const ARequestFilter: string): string;
begin
  if FDelSpiritCommand = nil then
  begin
    FDelSpiritCommand := FConnection.CreateCommand;
    FDelSpiritCommand.RequestType := 'GET';
    FDelSpiritCommand.Text := 'TServerMethods1.DelSpirit';
    FDelSpiritCommand.Prepare(TServerMethods1_DelSpirit);
  end;
  FDelSpiritCommand.Parameters[0].Value.SetInt32(AUserID);
  FDelSpiritCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FDelSpiritCommand.Parameters[2].Value.SetInt32(ASpiritID);
  FDelSpiritCommand.Execute(ARequestFilter);
  Result := FDelSpiritCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.LikeSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; const ARequestFilter: string): string;
begin
  if FLikeSpiritCommand = nil then
  begin
    FLikeSpiritCommand := FConnection.CreateCommand;
    FLikeSpiritCommand.RequestType := 'GET';
    FLikeSpiritCommand.Text := 'TServerMethods1.LikeSpirit';
    FLikeSpiritCommand.Prepare(TServerMethods1_LikeSpirit);
  end;
  FLikeSpiritCommand.Parameters[0].Value.SetInt32(AUserID);
  FLikeSpiritCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FLikeSpiritCommand.Parameters[2].Value.SetInt32(ASpiritID);
  FLikeSpiritCommand.Execute(ARequestFilter);
  Result := FLikeSpiritCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.CancelLikeSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; const ARequestFilter: string): string;
begin
  if FCancelLikeSpiritCommand = nil then
  begin
    FCancelLikeSpiritCommand := FConnection.CreateCommand;
    FCancelLikeSpiritCommand.RequestType := 'GET';
    FCancelLikeSpiritCommand.Text := 'TServerMethods1.CancelLikeSpirit';
    FCancelLikeSpiritCommand.Prepare(TServerMethods1_CancelLikeSpirit);
  end;
  FCancelLikeSpiritCommand.Parameters[0].Value.SetInt32(AUserID);
  FCancelLikeSpiritCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FCancelLikeSpiritCommand.Parameters[2].Value.SetInt32(ASpiritID);
  FCancelLikeSpiritCommand.Execute(ARequestFilter);
  Result := FCancelLikeSpiritCommand.Parameters[3].Value.GetWideString;
end;

function TServerMethods1Client.CommentSpirit(AUserID: Integer; ALoginKey: string; ASpiritID: Integer; AComment: string; AReplyUserID: Integer; const ARequestFilter: string): string;
begin
  if FCommentSpiritCommand = nil then
  begin
    FCommentSpiritCommand := FConnection.CreateCommand;
    FCommentSpiritCommand.RequestType := 'GET';
    FCommentSpiritCommand.Text := 'TServerMethods1.CommentSpirit';
    FCommentSpiritCommand.Prepare(TServerMethods1_CommentSpirit);
  end;
  FCommentSpiritCommand.Parameters[0].Value.SetInt32(AUserID);
  FCommentSpiritCommand.Parameters[1].Value.SetWideString(ALoginKey);
  FCommentSpiritCommand.Parameters[2].Value.SetInt32(ASpiritID);
  FCommentSpiritCommand.Parameters[3].Value.SetWideString(AComment);
  FCommentSpiritCommand.Parameters[4].Value.SetInt32(AReplyUserID);
  FCommentSpiritCommand.Execute(ARequestFilter);
  Result := FCommentSpiritCommand.Parameters[5].Value.GetWideString;
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FCheckNewVersionCommand.DisposeOf;
  FRegisterUserCommand.DisposeOf;
  FSendRegisterCaptchaCommand.DisposeOf;
  FSendForgetPasswordCaptchaCommand.DisposeOf;
  FCheckForgetPasswordCaptchaCommand.DisposeOf;
  FReSetPasswordCommand.DisposeOf;
  FChangePasswordCommand.DisposeOf;
  FLoginCommand.DisposeOf;
  FUpdateUserInfoCommand.DisposeOf;
  FUpdateUserHeadCommand.DisposeOf;
  FGetUserInfoCommand.DisposeOf;
  FWantedShieldUserCommand.DisposeOf;
  FCanCelledShieldUserCommand.DisposeOf;
  FGetShieldUserListCommand.DisposeOf;
  FWantedComplainUserCommand.DisposeOf;
  FGetUserSpiritListCommand.DisposeOf;
  FAddSpiritCommand.DisposeOf;
  FAddSpirit_V2Command.DisposeOf;
  FDelSpiritCommand.DisposeOf;
  FLikeSpiritCommand.DisposeOf;
  FCancelLikeSpiritCommand.DisposeOf;
  FCommentSpiritCommand.DisposeOf;
  inherited;
end;

end.

