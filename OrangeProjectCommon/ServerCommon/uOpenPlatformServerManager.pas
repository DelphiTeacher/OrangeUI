﻿//convert pas to utf8 by ¥
unit uOpenPlatformServerManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  DateUtils,
  SyncObjs,

  uLang,
  IniFiles,
  ActiveX,
  IdGlobal,
  uBaseLog,
  XSuperObject,
  uBaseDBHelper,
  uUniDBHelper,
  uBaseList,
  uFileCommon,
  uOpenCommon,
  uFuncCommon,
  uDatasetToJson,

  uDataBaseConfig,
  DataBaseConfigForm,

  uRestInterfaceCall,
  ServerDataBaseModule,

  kbmMWScheduler,
  kbmMWUniDAC,
  kbmMWCustomConnectionPool,
  Generics.Collections,
  uModule_InterfaceSign,
  Redis.Client,
  Redis.Commons,
  uRedisClientPool,
  uBaseDataBaseModule,
  uCommandLineHelper,
//  uRestInterfaceCall,


  kbmMWHTTPUtils,
  kbmMWCustomTransport,
  kbmMWServer,
  kbmMWAJAXTransStream,
//  kbmMWTCPIPIndyServerTransport,
  kbmMWCustomHTTPService,
  kbmMWCustomLoadBalancingService,
  kbmMWFilePool,
  kbmMWSecurity,
  kbmMWCrypt,

  IdSocketHandle,
  {$IFDEF NO_HTTPSYSServerTransport}
//  kbmMWAJAXTransStream,
  kbmMWSOAPTransStream,
  kbmMWRESTTransStream,
  kbmMWTCPIPIndyServerTransport,
  {$ELSE}
  kbmMWHTTPSYSServerTransport,
  {$ENDIF}

  MySQLUniProvider,
  UniProvider, Data.DB, DBAccess, Uni,
  kbmMWCustomSQLMetaData,
  kbmMWMSSQLMetaData,

  Vcl.StdCtrls, Vcl.ExtCtrls;





type
  TkbmMWCustomServiceClass = class of TkbmMWCustomService;
  TServiceProject=class;



  //开放平台的APP
  TOpenPlatformApp=class
  public
    fid:Integer;


    //是否启用签名
    is_enable_sign:Integer;
    //签名类型
    sign_type:String;
    //签名私钥
    appsecret_xfapp:String;



    //是否有FastMsg的功能
    is_enable_fastmsg:Integer;

    //FastMsg的WebService功能,不再使用
//    fastmsg_webservice_url:String;

    //Fastmsg的rest接口
    fastmsg_webapi_url:String;

    fastmsg_key:String;
    //客服
    service_user_fid:String;



//    appid:Integer;
//    user_fid:String;

    appsecret:String;
//    name:String;
//    icon_path:String;
//    app_desc:String;
    Json:ISuperObject;
    procedure LoadFromDataset(ADataset:TDataset);
  end;
  TOpenPlatformAppList=class(TBaseList)
  private
    function GetItem(Index: Integer): TOpenPlatformApp;
  public
    procedure Add(AAppID:Integer;
                  AIsEnableSign:Boolean;
                  ASignType:String;
                  AAppSecret:String
                  );overload;
    function Find(AAppID:Integer):TOpenPlatformApp;
    property Items[Index:Integer]:TOpenPlatformApp read GetItem;default;
  end;





  TBaseServiceThread=class(TThread)
  public
    procedure SleepThread(ATimeout:Integer;ACheckTerminateInterval:Integer=2000);
  end;



  //服务模块基类
  TServiceModule = class
  protected
  public
    FServiceProject:TServiceProject;

    //是否已连接数据库,避免重复启动
    IsStarted:Boolean;

    //模块名称,比如验证码、用户中心、IM、朋友圈
    Name: String;

    FIsInited:Boolean;
  public
    constructor Create; virtual;
  public
    //从别的APP复制配置到新APP
    function CopyConfigFromApp(ASourceAppID:Integer;ADestAppID:Integer;ADestAppJson:ISuperObject;var ADesc:String):Boolean;virtual;

    procedure Init;virtual;
    //准备启动
    function DoPrepareStart(var AError:String): Boolean; virtual; abstract;
    //准备停止
    function DoPrepareStop: Boolean; virtual; abstract;
  end;





  //KBM服务模块(含数据库)
  TKbmMWServiceModule = class(TServiceModule)
  protected
    function CustomCopyConfigFromApp(ASQLDBHelper:TBaseDBHelper;ASourceAppID:Integer;ADestAppID:Integer;ADestAppJson:ISuperObject;var ADesc:String):Boolean;virtual;
  public
    //使用的数据库连接
    FDBModule: TDatabaseModule;
    //实现服务的核心
    kbmMWCustomServiceClass: TkbmMWCustomServiceClass;
    function DBModule: TDatabaseModule;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    function CopyConfigFromApp(ASourceAppID:Integer;ADestAppID:Integer;ADestAppJson:ISuperObject;var ADesc:String):Boolean;override;

    //准备启动
    function DoPrepareStart(var AError:String): Boolean; override;
    //准备停止
    function DoPrepareStop: Boolean; override;
  end;



  //输出服务端状态的线程
  TServiceStatusOutputThread=class(TBaseServiceThread)
  protected
    procedure Execute;override;
  end;


//  TServiceModuleInitProcEvent=procedure(AServiceProject:TServiceProject);
//  TServiceModuleInitProcItem=class
//    FInitProc:TServiceModuleInitProcEvent;
//  end;
//  TServiceModuleInitProcList=class(TBaseList)
//  private
//    function GetItem(Index: Integer): TServiceModuleInitProcItem;
//  public
//    property Items[Index:Integer]:TServiceModuleInitProcItem read GetItem;default;
//  end;


  //服务工程
  TServiceProject = class
  public
    Name: String;
    ServiceName: String;
    ServiceDisplayName: String;
    //服务端端口
    Port: Integer;
    SSLPort: Integer;
    //域名
    Domain:String;

    //只需要一个数据库
    IsNeedOneDatabase:Boolean;

    //是否需要Redis
    IsNeedRedis:Boolean;

    //是否使用同一个DBModule
    IsUseOneDBModule:Boolean;

    kbmMWServer1: TkbmMWServer;
    {$IFDEF NO_HTTPSYSServerTransport}
    kbmMWTCPIPIndyServerTransport1: TkbmMWTCPIPIndyServerTransport;
    {$ELSE}
    kbmMWHTTPSysServerTransport1: TkbmMWHTTPSysServerTransport;
    {$ENDIF}

    //服务模块列表
    ServiceModuleList: TBaseList;
//    //服务端模块初始方法
//    FServiceModuleInitProcList: TServiceModuleInitProcList;


    //使用的数据库连接
    FDBModule: TDatabaseModule;


  public

    //开放平台的应用列表
    AppList:TOpenPlatformAppList;

    //是否启用接口参数验签名
    IsEnableRestAPICheckSign:Boolean;
    IsNeedLoadAppList:Boolean;

    NonceList:TStringList;
    NonceListLock:TCriticalSection;
    //上一次是什么时候清的
    LastNoceListClearTime:TDateTime;
    //上一次清的时候还剩多少,下一期清
    LastNoceListCount:Integer;




    //当前总调用数
    SumCallCount:Integer;
    InvalidCallCount:Integer;




    //上次总调用数
    LastSumCallCount:Integer;
    //最高每秒并发
    MaxParallelCallCountPerSecond:Integer;
    //输出服务端状态的线程
    FServiceStatusOutputThread:TServiceStatusOutputThread;

    FOnGetCommandLineOutput: TGetCommandLineOutputEvent;
    procedure DoGetCommandLineOutput(ACommandLine:String;ATag:String;AOutput:String);
  public
    FRedis_Host:String;
    FRedis_Port:Integer;
//    FRedis_Password:String;
//    FRedis_dbIdx:Integer;
//    //有效期几秒
//    FTimerInval_VerifyExpire:Integer;
  public
    procedure Load;
    procedure Save;
  public
    //签名相关
    function GetAppSignType(AAppID:Integer):String;
    function GetAppSecret(AAppID:Integer):String;
    //更新开放平台的应用列表
    function SyncAppList(var ADesc:String):Boolean;
    procedure SyncAppListEvent(const AScheduledEvent:IkbmMWScheduledEvent);
    //检测接口的签名
    function CheckInterfaceSign(AAPI:String;AUrlParams:String;var ADesc:String):Boolean;
    function CheckInterfaceSignByAppSecret(AUrlParams:String;
                                            AAppSecret_XFAPP:String;
                                            var ADesc:String;
                                            AOldQueryParams:TkbmMWHTTPQueryValues=nil
                                            ):Boolean;
    //返回数据
    function ReturnJson(AAppID:Integer;
                        ACode:Integer;
                        ADesc:String;
                        ADataJson:ISuperObject;
                        ADesc2:String='';
                        ADataJson2:ISuperObject=nil):ISuperObject;

  public
    function AddApp(ASQLDBHelper:TBaseDBHelper;AAppID:Integer;ARecordDataJsonObject:ISuperObject;copy_from_appid:String;var AError:String):Boolean;
    //从别的APP复制配置到新APP
    function CopyConfigFromApp(ASourceAppID:Integer;ADestAppID:Integer;ADestAppJson:ISuperObject;var ADesc:String):Boolean;
  public
    constructor Create; virtual;
    destructor Destroy;override;
  public
    function Start: Boolean;
    function Stop: Boolean;
  public
    function GetRedisClient:TRedisClient;
    procedure FreeRedisClient(ARedisClient:TRedisClient);

  public

    function ServerUrl:String;
    function ServerUploadUrl:String;
    function UserCenterServer:String;
    function CaptchaServer:String;
    function ContentCenterServer:String;
    function ScoreCenterServer:String;
    function ShopCenterServer:String;
    function PayCenterServer:String;
  public
    function IsValidUserRestUrl:String;
    //查询验证码的接口地址
    function QueryCaptchaRestUrl:String;
    //发送验证码的接口地址
    function SendCaptchaRestUrl:String;
    //检查验证码的接口地址
    function CheckCaptchaRestUrl:String;
//    //发送通知给用户
//    function PushMessageToUser:String;
    //上传商品防伪码、积分兑换码Excel文件的接口地址
    function UploadExcelFile:String;

    //更新订单状态
    function UpdateOrderStateRestUrl:String;
    //添加订单跟踪状态记录
    function AddOrderStateTrackRestUrl:String;
    //商家中心订单完成接口
    function OrderCompletedRestUrl:String;
    //获取订单详情接口
    function GetOrderInfoRestUrl:String;


    //积分中心获取积分规则列表接口
    function GetRuleTypeListRestUrl:String;
    //积分中心操作用户积分接口
    function ChangeUserScoreRestUrl:String;
    //积分中心操作用户经验接口
    function ChangeUserExpRestUrl:String;

    //积分中心计算积分
    function GetUserScoreRestUrl:String;

    //支付中心操作用户余额接口
    function ChangeUserMoneyRestUrl:String;
  public
    //获取用户类型
    function GetUserType(AAppID:Integer;
                          AUserFID:String;
                          AKey:String;
                          var ACode:Integer;
                          var ADesc:String;
                          var ADataJson:ISuperObject;
                          var AUserType:Integer):Boolean;
  end;









var
  //服务模块
  GlobalServiceProject:TServiceProject;

  //是否需要从Ini文件加载端口的配置,像汽修服务就不需要从配置中加载
  IsNeedLoadServiceProjectFromIni:Boolean;
  IsNeedSaveServiceProjectFromIni:Boolean;


var
  //REDIS默认的缓存时间
  REDIS_COMMON_TIMEOUT:Integer;//=10*60;
  //验证码
  CAPTCHA_REDIS_COMMON_TIMEOUT:Integer;//=1*60;


function RegisterServiceModule(AServiceModule: TServiceModule): Boolean;


implementation



uses
  uTableCommonRestCenter,
  TableCommonRestService;



function GetGlobalServiceProject:TServiceProject;
begin
  if GlobalServiceProject=nil then
  begin
    GlobalServiceProject:=TServiceProject.Create
  end;
  Result:=GlobalServiceProject;
end;

function RegisterServiceModule(AServiceModule: TServiceModule): Boolean;
begin
  uBaseLog.HandleException(nil,'RegisterServiceModule '+AServiceModule.Name);
  AServiceModule.FServiceProject:=GetGlobalServiceProject;
  GetGlobalServiceProject.ServiceModuleList.Add(AServiceModule);
end;


{ TServiceProject }

function TServiceProject.AddApp(ASQLDBHelper:TBaseDBHelper;AAppID:Integer;ARecordDataJsonObject: ISuperObject;copy_from_appid:String;
  var AError: String): Boolean;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;

  ADesc2:String;
  ARecordDataJson:ISuperObject;
  AClientAppPackage:String;
begin
      Result:=False;

      //初始接口访问密钥
      ARecordDataJsonObject.I['is_enable_sign']:=1;
      ARecordDataJsonObject.S['sign_type']:='MD5';
      ARecordDataJsonObject.S['appsecret']:=CreateGUIDString();
      ARecordDataJsonObject.S['appsecret_xfapp']:=CreateGUIDString();





      if not CommonRestServiceModule.AddRecord(
          'app',
          ASQLDBHelper,
          AAppID,
          ARecordDataJsonObject,
          ACode,
          ADesc,
          ADataJson
          ) then
      begin
        Exit;
      end;



      //应用初始
      //初始包名
      AClientAppPackage:='';
      AClientAppPackage:='com.jinjie.appid'+IntToStr(ADataJson.I['fid']);
      if not ASQLDBHelper.SelfQuery('UPDATE tblapp SET client_android_package=:client_android_package,client_ios_package=:client_ios_package WHERE fid=:fid',
                                    ['client_android_package','client_ios_package','fid'],[AClientAppPackage,AClientAppPackage,ADataJson.I['fid']],
                                    asoExec) then
      begin
        //数据库连接失败或异常
        ADesc:='更新应用包名时'+Trans('数据库连接失败或异常')+' '+ASQLDBHelper.LastExceptMessage;
        Exit;
      end;
      ADataJson.S['client_android_package']:=AClientAppPackage;
      ADataJson.S['client_ios_package']:=AClientAppPackage;



      if copy_from_appid<>'' then
      begin
        //复制配置,比如创圈客平台创建了一个社区应用,那么这个新建应用的配置可以直接从创圈客APP中复制,避免
        CopyConfigFromApp(StrToInt(copy_from_appid),ADataJson.I['fid'],ADataJson,ADesc2);
      end;


      Result:=True;

end;

function TServiceProject.AddOrderStateTrackRestUrl: String;
begin
  Result:=ShopCenterServer+'add_order_state_track';
end;

function TServiceProject.CaptchaServer: String;
begin
  Result:=ServerUrl+'captcha/';
end;

function TServiceProject.ChangeUserMoneyRestUrl: String;
begin
  Result:=PayCenterServer+'direct_oper_money';
end;

function TServiceProject.ChangeUserScoreRestUrl: String;
begin
  Result:=ScoreCenterServer+'direct_oper_score';
end;

function TServiceProject.ChangeUserExpRestUrl: String;
begin
  Result:=ScoreCenterServer+'direct_oper_exp';
end;

function TServiceProject.CheckCaptchaRestUrl: String;
begin
  Result:=CaptchaServer+'check_captcha';
end;

function TServiceProject.ReturnJson(
                                    AAppID:Integer;
                                    ACode:Integer;
                                    ADesc:String;
                                    ADataJson:ISuperObject;
                                    ADesc2:String;
                                    ADataJson2:ISuperObject):ISuperObject;
var
  ASign:String;
  ATimestamp:Integer;

  AApp:TOpenPlatformApp;
begin
  Result:=TSuperObject.Create;

  //返回的Json规范
  //Code是代码,200表示成功,400表示失败
  Result.I['Code']:=ACode;
  //Desc为返回的信息,比如操作***成功,***失败
  Result.S['Desc']:=ADesc;
  //Data则为返回的数据,比如***列表
  if ADataJson<>nil then
  begin
    Result.O['Data']:=ADataJson;
  end;




  if ADesc2<>'' then
  begin
    //Desc为返回的信息,比如操作***成功,***失败
    Result.S['Desc2']:=ADesc2;
    //Data则为返回的数据,比如***列表
    if ADataJson2<>nil then
    begin
      Result.O['Data2']:=ADataJson2;
    end;
  end;



  //加上时间戳
  ATimestamp:=DateTimeToUnix(now,false);//timeIntervalSince1970(Now);
  Result.I['Timestamp']:=ATimestamp;



  //判断是否需要签名
  //判断APP是否存在
  AApp:=Self.AppList.Find(AAppID);
  if AApp=nil then
  begin
    Exit;
  end;



  if AApp.is_enable_sign=0 then
  begin
      //该App不需要签名就能调用
      Exit;
  end;


  Result.S['SignType']:=AApp.sign_type;

  Result.S['Sign']:=SignParam(
                              ['code','desc','timestamp'],
                              [ACode,ADesc,ATimestamp],
                              AApp.sign_type,
                              AApp.appsecret_xfapp);


end;


function TServiceProject.CheckInterfaceSign(AAPI:String;AUrlParams: String;var ADesc: String): Boolean;
var
  AQueryParams:TkbmMWHTTPQueryValues;
  I: Integer;
  sl:TStringList;
  AApp:TOpenPlatformApp;
  AAppID:Integer;
  ASignType:String;
  ASign:String;
  AServerSign:String;
begin
  Result:=False;//内测阶段
  ADesc:='';



  //当前总调用数
  Inc(SumCallCount);




  if not IsEnableRestAPICheckSign then
  begin
    Result:=True;
    Exit;
  end;




  //判断有没有sign,signtype
  // Execute method.
  AQueryParams:=TkbmMWHTTPQueryValues.Create;
  try
      AQueryParams.AsString:=AUrlParams;



      //判断有没有appid
      if AQueryParams.ValueByName['appid']='' then
      begin
          ADesc:='appid参数不存在';
          //表示不签名
          Result:=False;
          Exit;


//          //表示不签名
//          Result:=True;
//          Exit;
      end;
      AAppID:=0;
      TryStrToInt(AQueryParams.ValueByName['appid'],AAppID);




      //判断是否需要签名
      //判断APP是否存在
      AApp:=Self.AppList.Find(AAppID);
      if AApp=nil then
      begin
        ADesc:='appid为'+IntToStr(AAppID)+'的App不存在';
        Exit;
      end;
      if AApp.is_enable_sign=0 then
      begin
          //该App不需要签名就能调用
          Result:=True;
          Exit;
      end;




      //判断有没有sign
      if AQueryParams.ValueByName['sign']='' then
      begin
          Inc(InvalidCallCount);
          ADesc:='sign参数不存在';
          Exit;
      end;



      //判断有没有signtype
      if AQueryParams.ValueByName['signtype']='' then
      begin
          Inc(InvalidCallCount);
          ADesc:='signtype参数不存在';
          Exit;
      end;



      ASign:=AQueryParams.ValueByName['sign'];
      ASignType:=AQueryParams.ValueByName['signtype'];



      AAppID:=0;
      if not TryStrToInt(AQueryParams.ValueByName['appid'],AAppID) then
      begin
          Inc(InvalidCallCount);
          ADesc:='appid参数不合法';
          Exit;
      end;





      //1是旋风OnLine项目所使用的签名方式
      if ASignType<>'' then
      begin
          //1是旋风OnLine项目所使用的签名方式

          //判断APP的私钥是否存在
          if not CheckInterfaceSignByAppSecret(AUrlParams,
                                              AApp.appsecret_xfapp,
                                              ADesc,
                                              AQueryParams) then
          begin
            Exit;
          end;


      end;



      Result:=True;

  finally
    if not Result then
    begin
      uBaseLog.HandleException(nil,'TServiceProject.CheckInterfaceSign '+AAPI+' '+ADesc);
    end;
    Result:=True;//内测阶段，只记录不开放
    FreeAndNil(AQueryParams);
  end;

  Result:=True;
end;

function TServiceProject.CheckInterfaceSignByAppSecret(AUrlParams,
  AAppSecret_XFAPP: String;
  var ADesc: String;
  AOldQueryParams:TkbmMWHTTPQueryValues=nil): Boolean;
var
  AQueryParams:TkbmMWHTTPQueryValues;
  I: Integer;
  sl:TStringList;
  AAppID:Integer;
  ASignType:String;
  ASign:String;
  AServerSign:String;
  ATimestamp:Int64;
begin
  Result:=False;
  ADesc:='';



  //判断有没有sign,signtype
  // Execute method.
  AQueryParams:=AOldQueryParams;
  if AOldQueryParams=nil then
  begin
    AQueryParams:=TkbmMWHTTPQueryValues.Create;
  end;
  try
      if AOldQueryParams=nil then
      begin
        AQueryParams.AsString:=AUrlParams;
      end;

      //判断有没有appid
      if AQueryParams.ValueByName['appid']='' then
      begin
          Inc(InvalidCallCount);
          ADesc:='appid参数不存在';
          Exit;
      end;



      //判断有没有timestamp
      if AQueryParams.ValueByName['timestamp']='' then
      begin
          //老版本的接口
          //ADesc:='timestamp参数不存在';
          //Exit;
      end
      else
      begin

          ATimestamp:=0;
          TryStrToInt64(AQueryParams.ValueByName['timestamp'],ATimestamp);
          //超过30秒就算是非法的请求了
          //if ABS(ATimestamp-timeIntervalSince1970(Now))>5*60 the//1609312837 1609312813
          if ABS(ATimestamp-DateTimeToUnix(now,false))>5*60 then//1609312837 1609312813
          begin
            Inc(InvalidCallCount);
            ADesc:='timestamp超时,请求已过期';
            Exit;
          end;

      end;




      //判断有没有nonce随机数
      if AQueryParams.ValueByName['nonce']='' then
      begin
          //老版本的接口
          //ADesc:='nonce参数不存在';
          //Exit;
      end
      else
      begin


          //判断有没有重复
          if NonceList.IndexOf(AQueryParams.ValueByName['nonce'])<>-1 then
          begin
            //重复了
            Inc(InvalidCallCount);
            ADesc:='nonce参数不能重复';
            Exit;
          end;
          NonceListLock.Enter;
          try
            NonceList.Add(AQueryParams.ValueByName['nonce']);

            //删除过期的,一方面这个随机数只要保证90秒之内的请求不要重复就可以了
            //超过90秒由timestamp会检测
            if DateUtils.SecondsBetween(LastNoceListClearTime,Now)>5*60 then
            begin
              //上一次是什么时候清的
              LastNoceListClearTime:=Now;
              //清掉上一90秒的
              for I := 0 to LastNoceListCount-1 do
              begin
                NonceList.Delete(0);
              end;
              //上一次清的时候还剩多少,下一期清
              LastNoceListCount:=NonceList.Count;
            end;

          finally
            NonceListLock.Leave;
          end;

      end;




      //判断有没有sign
      if AQueryParams.ValueByName['sign']='' then
      begin
          Inc(InvalidCallCount);
          ADesc:='sign参数不存在';
          Exit;
      end;



      //判断有没有signtype
      if AQueryParams.ValueByName['signtype']='' then
      begin
          Inc(InvalidCallCount);
          ADesc:='signtype参数不存在';
          Exit;
      end;



      ASign:=AQueryParams.ValueByName['sign'];
      ASignType:=AQueryParams.ValueByName['signtype'];



      AAppID:=0;
      if not TryStrToInt(AQueryParams.ValueByName['appid'],AAppID) then
      begin
          Inc(InvalidCallCount);
          ADesc:='appid参数不合法';
          Exit;
      end;




      //1是旋风OnLine项目所使用的签名方式
      if ASignType=CONST_REST_SIGNTYPE_XFAPP then
      begin
          //1是旋风OnLine项目所使用的签名方式

          //判断APP的私钥是否存在
          if AAppSecret_XFAPP='' then
          begin
            Inc(InvalidCallCount);
            ADesc:='appid为'+IntToStr(AAppID)+'的私钥appsecrect_xfapp为空';
            Exit;
          end;


          sl:=TStringList.Create;
          try

              //开始验签
              for I := 0 to AQueryParams.Count-1 do
              begin

                if AQueryParams[I].Name<>'sign' then
                begin
                  sl.Values[AQueryParams[I].Name]:=AQueryParams[I].Value;
                end;
              end;

              //生成签名
              AServerSign:=uModule_InterfaceSign.LoadSignAsStringList(sl,AAppSecret_XFAPP);


              //比对
              if ASign<>AServerSign then
              begin
                Inc(InvalidCallCount);
                ADesc:='签名不一致,请升级新版本';
                Exit;
              end;


          finally
            FreeAndNil(sl);
          end;

      end
      else if ASignType=CONST_REST_SIGNTYPE_MD5 then
      begin
          //1是旋风OnLine项目所使用的签名方式

          //判断APP的私钥是否存在
          if AAppSecret_XFAPP='' then
          begin
            Inc(InvalidCallCount);
            ADesc:='appid为'+IntToStr(AAppID)+'的私钥appsecrect_xfapp为空';
            Exit;
          end;


          sl:=TStringList.Create;
          try

              //开始验签
              for I := 0 to AQueryParams.Count-1 do
              begin

                if AQueryParams[I].Name<>'sign' then
                begin
                  sl.Values[AQueryParams[I].Name]:=AQueryParams[I].Value;
                end;
              end;

              //生成签名
              AServerSign:=uModule_InterfaceSign.LoadMD5SignAsStringList(sl,AAppSecret_XFAPP);


              //比对
              if ASign<>AServerSign then
              begin
                Inc(InvalidCallCount);
                ADesc:='签名不一致,请升级新版本';
                Exit;
              end;


          finally
            FreeAndNil(sl);
          end;

      end
      else
      begin
          Inc(InvalidCallCount);
          ADesc:='不支持该签名方法'+ASignType;
          Exit;
      end;


  finally
    if AOldQueryParams=nil then
    begin
        FreeAndNil(AQueryParams);
    end;
  end;


  Result:=True;

end;

function TServiceProject.ContentCenterServer: String;
begin
  Result:=ServerUrl+'contentcenter/';
end;

function TServiceProject.CopyConfigFromApp(ASourceAppID, ADestAppID: Integer;ADestAppJson:ISuperObject;
  var ADesc: String): Boolean;
var
  I: Integer;
  ASubDesc:String;
begin

    Result:=True;


    //服务模块列表
    for I := 0 to ServiceModuleList.Count-1 do
    begin

      ASubDesc:='';

      if not TServiceModule(ServiceModuleList[I]).CopyConfigFromApp(ASourceAppID,ADestAppID,ADestAppJson,ASubDesc) then
      begin
        Result:=False;
      end;

      if ASubDesc<>'' then
      begin
        ADesc:=ADesc+',';
      end;
      ADesc:=ADesc+ASubDesc;

    end;


end;

constructor TServiceProject.Create;
begin
  Name := Trans('默认服务');

  Port:=10000;
  SSLPort:=0;
  Domain:='www.orangeui.cn';


  FRedis_Host:='127.0.0.1';
  FRedis_Port:=6379;
//  FRedis_Password:='';
//  FRedis_dbIdx:=0;
//  //有效期几秒
//  FTimerInval_VerifyExpire:=;


  //是否需要Redis
  IsNeedRedis:=True;


  //服务包含的模块
  ServiceModuleList := TBaseList.Create(ooReference);
  AppList:=TOpenPlatformAppList.Create();
  //数据库模块
  FDBModule := TDatabaseModule.Create;
  FDBModule.DBConfigFileName:='ProgramFrameworkManageDBConfig.ini';


  NonceList:=TStringList.Create;
  NonceListLock:=TCriticalSection.Create;

//  FServiceModuleInitProcList:=TServiceModuleInitProcList.Create;

end;

destructor TServiceProject.Destroy;
//var
//  I: Integer;
//  AServiceModule:TServiceModule;
begin

//  for I := 0 to ServiceModuleList.Count-1 do
//  begin
//    AServiceModule:=TServiceModule(ServiceModuleList[I]);
//    FreeAndNil(AServiceModule);
//  end;

//  FreeAndNil(FServiceModuleInitProcList);

  FreeAndNil(FDBModule);

  {$IFDEF NO_HTTPSYSServerTransport}
  FreeAndNil(kbmMWTCPIPIndyServerTransport1);
  {$ELSE}
  FreeAndNil(kbmMWHTTPSysServerTransport1);
  {$ENDIF}
  FreeAndNil(kbmMWServer1);


  FreeAndNil(ServiceModuleList);
  FreeAndNil(AppList);



  FreeAndNil(NonceList);
  FreeAndNil(NonceListLock);

  Inherited;
end;

procedure TServiceProject.DoGetCommandLineOutput(ACommandLine, ATag,
  AOutput: String);
begin
  if Assigned(FOnGetCommandLineOutput) then
  begin
    FOnGetCommandLineOutput(ACommandLine,ATag,AOutput);
  end;
end;

procedure TServiceProject.FreeRedisClient(ARedisClient: TRedisClient);
begin
  GetGlobalRedisClientPool.FreeCustomObject(ARedisClient);
end;

function TServiceProject.GetAppSecret(AAppID: Integer): String;
var
  AApp:TOpenPlatformApp;
begin
  Result:='';

  AApp:=Self.AppList.Find(AAppID);
  if AApp=nil then
  begin
//    ADesc:='appid为'+IntToStr(AAppID)+'的App不存在';
    Exit;
  end;
  if AApp.is_enable_sign=0 then
  begin
      //该App不需要签名就能调用
      Exit;
  end;

//  if AApp.sign_type=CONST_REST_SIGNTYPE_XFAPP then
//  begin
    Result:=AApp.appsecret_xfapp;
//  end
//  else
//  begin
//
//  end;

end;

function TServiceProject.GetAppSignType(AAppID: Integer): String;
var
  AApp:TOpenPlatformApp;
begin
  Result:='';

  AApp:=Self.AppList.Find(AAppID);
  if AApp=nil then
  begin
//    ADesc:='appid为'+IntToStr(AAppID)+'的App不存在';
    Exit;
  end;
  if AApp.is_enable_sign=0 then
  begin
      //该App不需要签名就能调用
      Exit;
  end;

  Result:=AApp.sign_type;

end;

function TServiceProject.GetOrderInfoRestUrl: String;
begin
  Result:=ShopCenterServer+'user_get_order';
end;

//function TServiceProject.GetRedisOptClass: TRedisOptClass;
//begin
//
//end;

function TServiceProject.GetRedisClient: TRedisClient;
begin
//    FRedis_Host:=ARedis_Host;
//    FRedis_Port:=ARedis_Port;
//    FRedis_Password:=ARedis_Password;
//    FRedis_dbIdx:=ARedis_dbIdx;
//    FTimerInval_VerifyExpire:=ATimerInval_VerifyExpire;


//    Result := TRedisClient.Create(FRedis_Host, FRedis_Port);
//    Result.Connect;
////    if FRedis_Password<>'' then
////    begin
////      FRedisClient.AUTH(FRedis_Password);
////    end;
//    Result.SELECT(0);    // 选择库，默认有16个（0..15）
  Result:=TRedisClient(GetGlobalRedisClientPool.GetCustomObject);
end;

function TServiceProject.GetRuleTypeListRestUrl: String;
begin
  Result:=ScoreCenterServer+'get_app_score_rule_list';
end;

function TServiceProject.GetUserScoreRestUrl: String;
begin
  Result:=ScoreCenterServer+'calc_gift_score';
end;

function TServiceProject.GetUserType(AAppID:Integer;
  AUserFID: String; AKey: String;
  var ACode: Integer; var ADesc: String; var ADataJson: ISuperObject;
  var AUserType: Integer): Boolean;
begin
  Result:=False;
  AUserType:=0;

  //接口验证用户是否合法
  if not SimpleCallAPI(Self.UserCenterServer+'get_user_type',
                              nil,
                              '',
                              ['appid',
                              'user_fid',
                              'key'],
                              [AAppID,
                              AUserFID,
                              AKey],
                              ACode,
                              ADesc,
                              ADataJson,
                              Self.GetAppSignType(AAppID),
                              Self.GetAppSecret(AAppID)
                              ) then
  begin
    Exit;
  end;
  //'{"user_type":1}'
  AUserType:=ADataJson.I['user_type'];
  Result:=True;
end;

function TServiceProject.IsValidUserRestUrl: String;
begin
  Result:=UserCenterServer+'is_valid_user';
end;

procedure TServiceProject.Load;
var
  AIniFile:TIniFile;
begin

  if IsNeedLoadServiceProjectFromIni and FileExists(GetApplicationPath+'Config.ini') then
  begin
    AIniFile:=TIniFile.Create(GetApplicationPath+'Config.ini');


    Self.Name:=AIniFile.ReadString('','Name',Name);
    if AIniFile.ReadString('','ServiceName',ServiceName)<>'' then
    begin
      Self.ServiceName:=AIniFile.ReadString('','ServiceName',ServiceName);
    end;
    if AIniFile.ReadString('','ServiceDisplayName',ServiceDisplayName)<>'' then
    begin
      Self.ServiceDisplayName:=AIniFile.ReadString('','ServiceDisplayName',ServiceDisplayName);
    end;

    Self.Port:=AIniFile.ReadInteger('','Port',Port);
    Self.SSLPort:=AIniFile.ReadInteger('','SSLPort',SSLPort);
    Self.Domain:=AIniFile.ReadString('','Domain','www.orangeui.cn');


    Self.FRedis_Host:=AIniFile.ReadString('','Redis_Host','127.0.0.1');
    Self.FRedis_Port:=AIniFile.ReadInteger('','Redis_Port',6379);
    if IsNeedRedis then
    begin
      GetGlobalRedisClientPool.FRedis_Host:=FRedis_Host;//'127.0.0.1';
      GetGlobalRedisClientPool.FRedis_Port:=FRedis_Port;//6379;
    //  GetGlobalSQLDBHelperPool.FRedis_Password:='';
    //  GetGlobalSQLDBHelperPool.FRedis_dbIdx:=0;
    //  //有效期几秒
    //  GetGlobalSQLDBHelperPool.FTimerInval_VerifyExpire:=;
    end;


    FreeAndNil(AIniFile);
  end;
end;

function TServiceProject.OrderCompletedRestUrl: String;
begin
  Result:=ShopCenterServer+'order_completed';
end;

function TServiceProject.PayCenterServer: String;
begin
  Result:=ServerUrl+'paycenter/';
end;

//function TServiceProject.PushMessageToUser: String;
//begin
//  Result:=ServerUrl+'pushmanage/push_message_to_user';
//end;

function TServiceProject.QueryCaptchaRestUrl: String;
begin
  Result:=CaptchaServer+'query_captcha';
end;

procedure TServiceProject.Save;
var
  AIniFile:TIniFile;
begin
  

  AIniFile:=TIniFile.Create(GetApplicationPath+'Config.ini');


  AIniFile.WriteString('','Name',Self.Name);
  AIniFile.WriteString('','ServiceName',Self.ServiceName);
  AIniFile.WriteString('','ServiceDisplayName',Self.ServiceDisplayName);
  AIniFile.WriteInteger('','Port',Self.Port);
  AIniFile.WriteInteger('','SSLPort',Self.SSLPort);
  AIniFile.WriteString('','Domain',Self.Domain);


  FreeAndNil(AIniFile);
end;

function TServiceProject.ScoreCenterServer: String;
begin
  Result:=ServerUrl+'scorecenter/';
end;

function TServiceProject.SendCaptchaRestUrl: String;
begin
  Result:=CaptchaServer+'send_captcha';
end;

function TServiceProject.ServerUploadUrl: String;
begin
  Result:='http://127.0.0.1:'+IntToStr(Self.Port+1)+'/';
end;

function TServiceProject.ServerUrl: String;
begin
  Result:='http://127.0.0.1:'+IntToStr(Self.Port)+'/';
end;

function TServiceProject.ShopCenterServer: String;
begin
  Result:=ServerUrl+'shopcenter/';
end;

function TServiceProject.Start: Boolean;
var
  I: Integer;
  AServiceModule: TServiceModule;
var
  sd: TKbmMWCustomServiceDefinition;
  AError:String;
  AMessages:String;
  AIdSocketHandle:TIdSocketHandle;
begin
  Result := False;



  CoInitializeEx(nil,COINIT_MULTITHREADED);
  try

      uBaseLog.HandleException(nil,'TServiceProject.Start Begin');

      if kbmMWServer1=nil then
      begin
        kbmMWServer1 := TkbmMWServer.Create(nil);

        {$IFDEF NO_HTTPSYSServerTransport}
        kbmMWTCPIPIndyServerTransport1:=TkbmMWTCPIPIndyServerTransport.Create(Application);
        kbmMWTCPIPIndyServerTransport1.Server := kbmMWServer1;
        {$ELSE}
        kbmMWHTTPSysServerTransport1 := TkbmMWHTTPSysServerTransport.Create(Application);
        kbmMWHTTPSysServerTransport1.Server := kbmMWServer1;
        {$ENDIF}


//        for I := 0 to FServiceModuleInitProcList.Count-1 do
//        begin
//          FServiceModuleInitProcList[I].FInitProc(Self);
//        end;

      end;


      uBaseLog.HandleException(nil,'TServiceProject.Start ServiceModuleList.Count='+IntToStr(ServiceModuleList.Count));





      //所有模块使用同一个数据库连接
      //先启动这个数据库连接，因为其他模块可能需要使用数据库连接查询一些东西
      if Self.IsUseOneDBModule then
      begin
          AError:='';
          if not FDBModule.DoPrepareStart(AError) then
          begin
              AMessages:='FDBModule.DoPrepareStart '+AMessages+AError+#13#10;
          end;
      end;



      //取到开放平台的APP列表
      //顺序不能换
      if IsEnableRestAPICheckSign or IsNeedLoadAppList then
      begin
          //查询所有App列有
          AError:='';
          if not FDBModule.DoPrepareStart(AError) then
          begin
              AMessages:='FDBModule.DoPrepareStart '+AMessages+AError+#13#10;
          end
          else
          begin
              AppList.Clear();

              if not Self.SyncAppList(AError) then
              begin
                AMessages:='SyncAppList '+AMessages+AError+#13#10;
              end;

          end;
      end;



      //启动各个服务模块
      AMessages:='';
      for I := 0 to Self.ServiceModuleList.Count - 1 do
      begin
          //注册
          AServiceModule := TServiceModule(ServiceModuleList[I]);

          AServiceModule.IsStarted:=False;
          //连接数据库等初始
          AError:='';
          if not AServiceModule.DoPrepareStart(AError) then
          begin
              AMessages:=AServiceModule.Name+' '+AMessages+AError+#13#10;
              //如果启动失败,不退出
          end
          else
          begin
              AServiceModule.IsStarted:=True;
          end;
      end;




      if AMessages<>'' then
      begin
        //初始模块失败
        ShowMessage(AMessages);
      end;






      //自动注册
      kbmMWServer1.AutoRegisterServices;




    {$IFDEF NO_HTTPSYSServerTransport}
      kbmMWTCPIPIndyServerTransport1.Bindings.Clear;
      AIdSocketHandle:=kbmMWTCPIPIndyServerTransport1.Bindings.Add;
      AIdSocketHandle.IP:='0.0.0.0';
      AIdSocketHandle.Port:=Port;//+3;
//      AIdSocketHandle.Port:=Port+3;
      kbmMWTCPIPIndyServerTransport1.StreamFormat:='REST';
    {$ELSE}
//      //使用设置的端口号
//      kbmMWHTTPSysServerTransport1.URLs.Clear;
//      kbmMWHTTPSysServerTransport1.URLs.Add('http://+:' + IntToStr(Port) + '/');
      //使用设置的端口号
      kbmMWHTTPSysServerTransport1.URLs.Clear;
      kbmMWHTTPSysServerTransport1.URLs.Add('http://+:' + IntToStr(Port) + '/');
    {$ENDIF}


      //SSL
      if SSLPort<>0 then
      begin
          {$IFDEF NO_HTTPSYSServerTransport}
          {$ELSE}
          //需要SSL
          if Port=10000 then
          begin
            kbmMWHTTPSysServerTransport1.URLs.Add('https://+:' + IntToStr(SSLPort) +'/');
          end
          else
          begin
            kbmMWHTTPSysServerTransport1.URLs.Add('https://+:' + IntToStr(Port+443) +'/');
          end;
          {$ENDIF}

      end;




      //启动服务
      //提供数据服务
      kbmMWServer1.Active := True;



//      //定时更新AppList
//      Scheduler
//          .Schedule(SyncAppListEvent)
//          .NamedAs('SyncAppListEvent')
////          .Synchronized
//          //每五分钟
//          .EveryMSecond(5*60)
//          //指任务的精度类型，可忽略
//          .Relaxed
//          //第一次执行的延时
//          .DelayInitial(60)
//          //
//          .Active:=True;

      FServiceStatusOutputThread:=TServiceStatusOutputThread.Create(False);


      uBaseLog.HandleException(nil,'TServiceProject.Start End');


      Result := True;

  finally
    CoUnInitialize;
  end;

end;

function TServiceProject.Stop: Boolean;
var
  I: Integer;
  AStartTime:TDateTime;
  AServiceModule: TServiceModule;
begin
  Result:=False;

  if (kbmMWServer1=nil) or not kbmMWServer1.Active then Exit;

  CoInitializeEx(nil,COINIT_MULTITHREADED);
  try

      FServiceStatusOutputThread.Terminate;
      FServiceStatusOutputThread.WaitFor;
      FreeAndNil(FServiceStatusOutputThread);



      AStartTime:=Now;
      uBaseLog.HandleException(nil,'kbmMWServer1.Stop Begin ');
      //停止服务
      try
        if kbmMWServer1.Active then
        begin
          kbmMWServer1.Active := False;
        end;
//        kbmMWServer1.Shutdown;
//
//        kbmMWServer1.ShutdownWait;
      finally
      end;
      uBaseLog.HandleException(nil,'kbmMWServer1.Stop End 耗时'+IntToStr(DateUtils.SecondsBetween(Now,AStartTime))+'秒');



      //停止各个模块
      for I := 0 to Self.ServiceModuleList.Count - 1 do
      begin
        AServiceModule := TServiceModule(ServiceModuleList[I]);

        if AServiceModule.IsStarted then
        begin
          AServiceModule.IsStarted:=False;

          AStartTime:=Now;
          uBaseLog.HandleException(nil,AServiceModule.ClassName+' DoPrepareStop Begin ');
          //断开数据库连接等停止
          AServiceModule.DoPrepareStop;

          uBaseLog.HandleException(nil,AServiceModule.ClassName+' DoPrepareStop End 耗时'+IntToStr(DateUtils.SecondsBetween(Now,AStartTime))+'秒');

        end;

      end;



      kbmMWServer1.UnregisterServices;

      Result := True;

  finally
    CoUnInitialize;
  end;
end;

function TServiceProject.SyncAppList(var ADesc:String):Boolean;
var
  ASQLDBHelper:TBaseDBHelper;
  AApp:TOpenPlatformApp;
begin
    Result:=False;

    if not FDBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
    begin
      Exit;
    end;
    try
        if not ASQLDBHelper.SelfQuery('SELECT * FROM tblapp',[],[],asoOpen) then
        begin
          ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
          Exit;
        end;


        while not ASQLDBHelper.Query.Eof do
        begin
          AApp:=AppList.Find(ASQLDBHelper.Query.FieldByName('fid').AsInteger);
          if AApp=nil then
          begin
            AApp:=TOpenPlatformApp.Create;
            AppList.Add(AApp);
          end;

          AApp.LoadFromDataset(ASQLDBHelper.Query);

          ASQLDBHelper.Query.Next;
        end;

    finally
      FDBModule.FreeDBHelperToPool(ASQLDBHelper);
    end;

    Result:=True;
end;

procedure TServiceProject.SyncAppListEvent(const AScheduledEvent: IkbmMWScheduledEvent);
var
  ADesc:String;
begin
  SyncAppList(ADesc);
end;

function TServiceProject.UpdateOrderStateRestUrl: String;
begin
  Result:=ShopCenterServer+'update_order_state';
end;

function TServiceProject.UploadExcelFile: String;
begin
  Result:=ServerUploadUrl+'upload';
end;

function TServiceProject.UserCenterServer: String;
begin
  Result:=ServerUrl+'usercenter/';
end;

{ TKbmMWServiceModule }

function TKbmMWServiceModule.CopyConfigFromApp(ASourceAppID,
  ADestAppID: Integer;ADestAppJson:ISuperObject;var ADesc:String): Boolean;
var
  ASQLDBHelper:TBaseDBHelper;
begin
  if not Self.DBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
  begin
    Exit;
  end;
  try

      Result:=CustomCopyConfigFromApp(ASQLDBHelper,ASourceAppID,ADestAppID,ADestAppJson,ADesc);

  finally
    Self.DBModule.FreeDBHelperToPool(ASQLDBHelper);
  end;
end;

constructor TKbmMWServiceModule.Create;
begin
  //数据库模块
  FDBModule := TDatabaseModule.Create;
end;

function TKbmMWServiceModule.CustomCopyConfigFromApp(
  ASQLDBHelper: TBaseDBHelper; ASourceAppID, ADestAppID: Integer;ADestAppJson:ISuperObject;var ADesc:String): Boolean;
begin
  Result:=True;
end;

function TKbmMWServiceModule.DBModule: TDatabaseModule;
begin
  if (FServiceProject<>nil) and (FServiceProject.IsUseOneDBModule) then
  begin
    Result:=FServiceProject.FDBModule;
  end
  else
  begin
    Result:=FDBModule;
  end;
end;

destructor TKbmMWServiceModule.Destroy;
begin
  FreeAndNil(FDBModule);
  Inherited;
end;

function TKbmMWServiceModule.DoPrepareStart(var AError:String): Boolean;
begin
  Result := False;


  if not FIsInited then
  begin
    Self.Init;
    FIsInited:=True;
  end;


  if (FServiceProject<>nil) and (FServiceProject.IsUseOneDBModule) then
  begin
    //所有模块使用同一个数据库连接
    Result:=True;
  end
  else
  begin
    //连接数据库
    Result := DBModule.DoPrepareStart(AError);
  end;


  if Result then
  begin
    uBaseLog.HandleException('TKbmMWServiceModule.DoPrepareStart '+Name+'模块启动成功');
  end
  else
  begin
    uBaseLog.HandleException('TKbmMWServiceModule.DoPrepareStart '+Name+'模块启动失败');
  end;
end;

function TKbmMWServiceModule.DoPrepareStop: Boolean;
begin
  Result := False;

  //断开数据库
  Result := DBModule.DoPrepareStop;
end;

{ TServiceModule }

function TServiceModule.CopyConfigFromApp(ASourceAppID, ADestAppID: Integer;ADestAppJson:ISuperObject;
  var ADesc: String): Boolean;
begin
  Result:=True;
end;

constructor TServiceModule.Create;
begin
end;

procedure TServiceModule.Init;
begin

end;

{ TBaseServiceThread }

procedure TBaseServiceThread.SleepThread(ATimeout,
  ACheckTerminateInterval: Integer);
var
  ASumTimeout:Integer;
begin
  ASumTimeout:=0;
  while not Self.Terminated and (ASumTimeout<ATimeout) do
  begin
    Sleep(ACheckTerminateInterval);
    ASumTimeout:=ASumTimeout+ACheckTerminateInterval;
  end;
end;




{ TOpenPlatformAppList }

procedure TOpenPlatformAppList.Add(AAppID: Integer; AIsEnableSign: Boolean;
  ASignType, AAppSecret: String);
var
  AApp:TOpenPlatformApp;
begin
  AApp:=TOpenPlatformApp.Create;

  AApp.fid:=AAppID;


  AApp.appsecret:=AAppSecret;
  AApp.sign_type:=ASignType;
  AApp.is_enable_sign:=Ord(AIsEnableSign);

  Inherited Add(AApp);



end;

function TOpenPlatformAppList.Find(AAppID: Integer): TOpenPlatformApp;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].fid=AAppID then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TOpenPlatformAppList.GetItem(Index: Integer): TOpenPlatformApp;
begin
  Result:=TOpenPlatformApp(Inherited Items[Index]);
end;




{ TOpenPlatformApp }

procedure TOpenPlatformApp.LoadFromDataset(ADataset: TDataset);
begin
  Self.fid:=ADataset.FieldByName('fid').AsInteger;

  //是否有FastMsg的功能
  Self.is_enable_fastmsg:=ADataset.FieldByName('is_enable_fastmsg').AsInteger;

  //FastMsg的WebService功能
//  Self.fastmsg_webservice_url:=ADataset.FieldByName('fastmsg_webservice_url').AsString;
  Self.fastmsg_webapi_url:=ADataset.FieldByName('fastmsg_webapi_url').AsString;
  Self.fastmsg_key:=ADataset.FieldByName('fastmsg_key').AsString;


  Self.appsecret_xfapp:=ADataset.FieldByName('appsecret_xfapp').AsString;
  Self.sign_type:=ADataset.FieldByName('sign_type').AsString;
  Self.is_enable_sign:=ADataset.FieldByName('is_enable_sign').AsInteger;

  Self.service_user_fid:=ADataset.FieldByName('service_user_fid').AsString;

  Json:=JsonFromRecord(ADataset);
end;





{ TServiceStatusOutputThread }

procedure TServiceStatusOutputThread.Execute;
var
  I: Integer;
  ASumCurCount:Integer;
  AServiceModule:TServiceModule;
  ADatabaseModuleStatus:TDatabaseModuleStatus;
  ALog:String;
begin

  while not Self.Terminated do
  begin

      SleepThread(60*1000);


    //    //上次总调用数
    //    LastSumCallCount:Integer;
    //    //最高每秒并发
    //    MaxParallelCallCountPerSecond:Integer;

      //刷新服务端状态

      ALog:='服务端状态:'+#13#10;

    //  Self.lblSumCallCount.Caption:=IntToStr(GlobalServiceProject.SumCallCount);
      ALog:=ALog+'接口中总调用次数:'+IntToStr(GlobalServiceProject.SumCallCount)+#13#10;



      if GlobalServiceProject.SumCallCount-GlobalServiceProject.LastSumCallCount>GlobalServiceProject.MaxParallelCallCountPerSecond then
      begin
        GlobalServiceProject.MaxParallelCallCountPerSecond:=GlobalServiceProject.SumCallCount-GlobalServiceProject.LastSumCallCount;
      end;
//      Self.lblMaxCallCountPerSecond.Caption:=IntToStr(GlobalServiceProject.MaxParallelCallCountPerSecond);
      ALog:=ALog+'每秒最高并发数:'+IntToStr(GlobalServiceProject.MaxParallelCallCountPerSecond)+#13#10;


      GlobalServiceProject.LastSumCallCount:=GlobalServiceProject.SumCallCount;
    //  Self.lblInvalidCallCount.Caption:=IntToStr(GlobalServiceProject.InvalidCallCount);
      ALog:=ALog+'无效调用次数:'+IntToStr(GlobalServiceProject.InvalidCallCount)+#13#10;



      //Redis缓存池
    //  Self.lblRedisPoolCount.Caption:=IntToStr(GetGlobalRedisClientPool.FCustomObjects.Count);



      ASumCurCount:=0;
    //  Self.gridDatabasePool.RowCount:=GlobalServiceProject.ServiceModuleList.Count+2;
    //  Self.gridDatabasePool.ColCount:=9;
    //
    //  Self.gridDatabasePool.Cells[0,0]:='模块名';
    //  Self.gridDatabasePool.Cells[1,0]:='最大数';
    //  Self.gridDatabasePool.Cells[2,0]:='当前数';
    //  Self.gridDatabasePool.Cells[3,0]:='使用次数';
    //  Self.gridDatabasePool.Cells[4,0]:='归还次数';
    //  Self.gridDatabasePool.Cells[5,0]:='检测连接状态次数';
    //  Self.gridDatabasePool.Cells[6,0]:='连接成功次数';
    //  Self.gridDatabasePool.Cells[7,0]:='连接断开次数';
    //  Self.gridDatabasePool.Cells[8,0]:='重连成功次数';
      //先将数据库模块显示出来
      for I := 0 to GlobalServiceProject.ServiceModuleList.Count-1 do
      begin
        AServiceModule:=TServiceModule(GlobalServiceProject.ServiceModuleList[I]);

    //    Self.gridDatabasePool.Cells[0,I+1]:=AServiceModule.Name;
        ALog:=ALog+'模块名:'+AServiceModule.Name+#9;
        if AServiceModule is TKbmMWServiceModule then
        begin

          ADatabaseModuleStatus:=TKbmMWServiceModule(AServiceModule).DBModule.GetStatus;


    //      Self.gridDatabasePool.Cells[1,I+1]:=IntToStr(ADatabaseModuleStatus.MaxCount);
          ALog:=ALog+'最大数:'+IntToStr(ADatabaseModuleStatus.MaxCount)+#9;
    //      Self.gridDatabasePool.Cells[2,I+1]:=IntToStr(ADatabaseModuleStatus.CurCount);
          ALog:=ALog+'当前数:'+IntToStr(ADatabaseModuleStatus.CurCount)+#9;
          ASumCurCount:=ASumCurCount+ADatabaseModuleStatus.CurCount;

    //      Self.gridDatabasePool.Cells[3,I+1]:=IntToStr(ADatabaseModuleStatus.LockTimes);
          ALog:=ALog+'使用次数:'+IntToStr(ADatabaseModuleStatus.LockTimes)+#9;
    //      Self.gridDatabasePool.Cells[4,I+1]:=IntToStr(ADatabaseModuleStatus.UnlockTimes);
          ALog:=ALog+'归还次数:'+IntToStr(ADatabaseModuleStatus.UnlockTimes)+#9;
    //      Self.gridDatabasePool.Cells[5,I+1]:=IntToStr(ADatabaseModuleStatus.CheckConnectTimes);
          ALog:=ALog+'检测连接状态次数:'+IntToStr(ADatabaseModuleStatus.CheckConnectTimes)+#9;
    //      Self.gridDatabasePool.Cells[6,I+1]:=IntToStr(ADatabaseModuleStatus.ConnectedTimes);
          ALog:=ALog+'连接成功次数:'+IntToStr(ADatabaseModuleStatus.ConnectedTimes)+#9;
    //      Self.gridDatabasePool.Cells[7,I+1]:=IntToStr(ADatabaseModuleStatus.DisconnectedTimes);
          ALog:=ALog+'连接断开次数:'+IntToStr(ADatabaseModuleStatus.DisconnectedTimes)+#9;
    //      Self.gridDatabasePool.Cells[8,I+1]:=IntToStr(ADatabaseModuleStatus.ReConnectedTimes);
          ALog:=ALog+'重连成功次数:'+IntToStr(ADatabaseModuleStatus.ReConnectedTimes)+#13#10;



        end;

      end;


    //  //汇总
    //  Self.gridDatabasePool.Cells[0,I+1]:='汇总';
    //  Self.gridDatabasePool.Cells[2,I+1]:=IntToStr(ASumCurCount);

      uBaseLog.HandleException(nil,ALog);


  end;


end;

//{ TServiceModuleInitProcList }
//
//function TServiceModuleInitProcList.GetItem(Index: Integer): TServiceModuleInitProcItem;
//begin
//  Result:=TServiceModuleInitProcItem(Inherited Items[Index]);
//end;

initialization
  //需要记录日志
  uBaseLog.GetGlobalLog.IsWriteLog:=True;


  GlobalServiceProject:=GetGlobalServiceProject;

  //默认服务的标题(不要改)
  GlobalServiceProject.Name:='开放平台服务端';
  //默认服务的端口
  GlobalServiceProject.Port:=10000;

  IsNeedLoadServiceProjectFromIni:=True;
//  IsNeedSaveServiceProjectFromIni:=True;


  //REDIS默认的缓存时间
  REDIS_COMMON_TIMEOUT:=10*60;
  //验证码
  CAPTCHA_REDIS_COMMON_TIMEOUT:=1*60;


  if DirectoryExists('C:\MyFiles') or DirectoryExists('D:\MyFiles') then
  begin
    //开发测试电脑
    //缓存时间调短一点

    //REDIS默认的缓存时间
//    REDIS_COMMON_TIMEOUT:=10*60;
    REDIS_COMMON_TIMEOUT:=1;//10*60;

  end;




finalization
  FreeAndNil(GlobalServiceProject);


end.