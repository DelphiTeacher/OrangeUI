unit uConfig;

interface

uses
  Classes,
  SysUtils,
  IniFiles,
  Forms,
  Types;

//const
//  Const_Default_DBHostName='125.91.225.68';
//  Const_Default_DBDataBaseName='BookRead';
//  Const_Default_DBUserName='sa';
//  Const_Default_DBPassword='138575wangneng';
//  Const_Default_ServerUrl='http://125.91.225.68:7001';

type

  TConfig=class
  private
    //网站文件根目录
    FWWWRootDir:String;

    //数据库服务器
    FDBHostName:String;
    //数据库
    FDBDataBaseName:String;
    //数据库用户名
    FDBUserName:String;
    //数据库密码
    FDBPassword:String;


    //Windows账户验证
    FDBOSAuthentication:Boolean;


    //服务器地址
    FServerUrl:String;
  public
    function LoadFromINI(AINIFilePath: String): Boolean;
    function SaveToINI(AINIFilePath: String): Boolean;
  public
    constructor Create;
    destructor Destroy;override;
  public
    procedure Load;
    procedure Save;
  public
    //网站文件根目录
    function GetWWWRootDir:String;



    //数据库服务器
    function GetDBHostName:String;
    //数据库
    function GetDBDataBaseName:String;
    //数据库用户名
    function GetDBUserName:String;
    //数据库密码
    function GetDBPassword:String;




    //是否使用windows验证
    function GetDBOSAuthentication:Boolean;

    //服务器地址
    function GetServerUrl:String;

  end;


var
  GlobalConfig:TConfig;


implementation


{ TConfig }

constructor TConfig.Create;
begin

end;

destructor TConfig.Destroy;
begin
  inherited;
end;

function TConfig.GetDBDataBaseName: String;
begin
  Result:=FDBDataBaseName;
//  if Result='' then
//  begin
//    Result:=Const_Default_DBDataBaseName;
//  end;
end;

function TConfig.GetDBHostName: String;
begin
  Result:=FDBHostName;
//  if Result='' then
//  begin
//    Result:=Const_Default_DBHostName;
//  end;
end;

function TConfig.GetDBOSAuthentication: Boolean;
begin
  Result:=FDBOSAuthentication;
end;

function TConfig.GetDBPassword: String;
begin
  Result:=FDBPassword;
//  if Result='' then
//  begin
//    Result:=Const_Default_DBPassword;
//  end;
end;

function TConfig.GetDBUserName: String;
begin
  Result:=FDBUserName;
//  if Result='' then
//  begin
//    Result:=Const_Default_DBUserName;
//  end;
end;

function TConfig.GetServerUrl: String;
begin
  Result:=FServerUrl;
//  if Result='' then
//  begin
//    Result:=ExtractFilePath(Application.ExeName);
//  end;
end;

function TConfig.GetWWWRootDir: String;
begin
  Result:=FWWWRootDir;
  if Result='' then
  begin
    Result:=ExtractFilePath(Application.ExeName);
  end;
end;

procedure TConfig.Load;
begin
  Self.LoadFromINI(ExtractFilePath(Application.ExeName)+'Config.ini');
end;

function TConfig.LoadFromINI(AINIFilePath: String): Boolean;
var
  AIniFile:TIniFile;
begin
  Result:=False;

  AIniFile:=TIniFile.Create(AINIFilePath);

  Self.FDBHostName:=AIniFile.ReadString('','DBHostName','');
  Self.FDBDataBaseName:=AIniFile.ReadString('','DBDataBaseName','');
  Self.FDBUserName:=AIniFile.ReadString('','DBUserName','');
  Self.FDBPassword:=AIniFile.ReadString('','DBPassword','');
  Self.FDBOSAuthentication:=AIniFile.ReadBool('','DBOSAuthentication',False);

  Self.FServerUrl:=AIniFile.ReadString('','ServerUrl','');

  FreeAndNil(AIniFile);

  Result:=True;

end;

procedure TConfig.Save;
begin
  Self.SaveToINI(ExtractFilePath(Application.ExeName)+'Config.ini');
end;

function TConfig.SaveToINI(AINIFilePath: String): Boolean;
var
  AIniFile:TIniFile;
begin
  Result:=False;
  AIniFile:=TIniFile.Create(AINIFilePath);

  AIniFile.WriteString('','DBHostName',Self.FDBHostName);
  AIniFile.WriteString('','DBDataBaseName',Self.FDBDataBaseName);
  AIniFile.WriteString('','DBUserName',Self.FDBUserName);
  AIniFile.WriteString('','DBPassword',Self.FDBPassword);
  AIniFile.WriteBool('','DBOSAuthentication',Self.FDBOSAuthentication);

  AIniFile.WriteString('','ServerUrl',Self.FServerUrl);

  FreeAndNil(AIniFile);
  Result:=True;

end;


initialization
  GlobalConfig:=TConfig.Create;
  GlobalConfig.Load;
  GlobalConfig.Save;

finalization
  FreeAndNil(GlobalConfig);

end.
