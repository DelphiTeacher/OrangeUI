//convert pas to utf8 by ¥

unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,


  Windows,
  Math,
  Forms,
  Variants,

  IniFiles,
  XSuperObject,
  XSuperJson,
  uFuncCommon,

  uCaptcha,
  uTaoBaoManager,
  uTaoBaoPublic,
  uTaoBaoAPI,
  uTaoBaoAuth,

  uGenerateThumb,
//  uThumbCommon,
  uDataSetToJson,
  uBaseDBHelper,
  uADODBHelper,
  uADODBHelperPool,


  ImageIndyHttpServerModule,

  Data.DBXCommon,
  Data.DBXMSSQL,
  Data.DB,
  Data.SqlExpr,
  Data.FMTBcd;






const
  Const_PageSize=20;

type
{$METHODINFO ON}
  TServerMethods1 = class(TComponent)
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
  public
    //检测新版本
    function CheckNewVersion:String;
  public
    //注册
    function RegisterUser(AName:String;
                          APhone:String;
                          ACaptcha:String;
                          APassword:String;
                          ARePassword:String
                          ):string;
    //发送注册的验证码
    function SendRegisterCaptcha(APhone:String):String;
  public
    //发送忘记密码的验证码
    function SendForgetPasswordCaptcha(APhone:String):String;
    //检查忘记密码的验证码
    function CheckForgetPasswordCaptcha(APhone:String;ACaptcha:String):String;
    //重置密码
    function ReSetPassword(APhone:String;
                           ACaptcha:String;
                           APassword:String;
                           ARePassword:String
                            ):String;

  public
    //更改密码
    function ChangePassword(AUserID:Integer;
                           ALoginKey:String;
                           AOldPassword:String;
                           APassword:String;
                           ARePassword:String
                            ):String;
  public
    //登录,返回用户信息和LoginKey
    function Login(ALoginUser:String;
                    APassword:String;
                    AVersion:String):string;
    //更新用户资料
    function UpdateUserInfo(AUserID:Integer;
                            ALoginKey:String;
                            AUpdateJsonStr:String
                            ):String;
    //更新用户头像,
    //先用上传接口上传图片,
    //AHeadPic为上传后的文件名
    function UpdateUserHead(AUserID:Integer;
                            ALoginKey:String;
                            AHeadPic:String
                            ):String;
    //获取用户信息
    function GetUserInfo(AUserID:Integer;
                         ALoginUserID:Integer):String;
  public
    //屏蔽朋友圈
    function WantedShieldUser(AUserFID:Integer;
                              AShieldUserFID:Integer
                              ):String;
    //取消屏蔽
    function CanCelledShieldUser(AUserFID:Integer;
                                 AShieldUserFID:Integer
                                  ):String;
    //获取屏蔽人列表
    function GetShieldUserList(AUserFID:Integer
                         ):String;
    //投诉
    function WantedComplainUser(AUserFID:Integer;
                                AComplainUserFID:Integer;
                                AType:String;
                                AComplainContant:String
                                ):String;

  public
    //获取朋友圈列表
    function GetUserSpiritList(AUserID:Integer;
                              ALoginKey:String;
                              APageIndex:Integer;
                              APageSize:Integer):String;
    //添加朋友圈
    function AddSpirit(AUserID:Integer;
                      ALoginKey:String;
                      ASpirit:String;
                      APic1:String;
                      APic2:String;
                      APic3:String;
                      APic4:String;
                      APic5:String;
                      APic6:String;
                      APic7:String;
                      APic8:String;
                      APic9:String;
                      APic1Width:Integer;
                      APic1Height:Integer
                      ):String;
    function AddSpirit_V2(AUserID:Integer;
                      ALoginKey:String;
                      ASpirit:String;
                      APic1:String;
                      APic2:String;
                      APic3:String;
                      APic4:String;
                      APic5:String;
                      APic6:String;
                      APic7:String;
                      APic8:String;
                      APic9:String;
                      APic1Width:Integer;
                      APic1Height:Integer;
                      ALatitude:Double;
                      ALongitude:Double;
                      AAddr:String;
                      APhoneType:String
                      ):String;

    //删除朋友圈
    function DelSpirit(AUserID:Integer;
                      ALoginKey:String;
                      ASpiritID:Integer):String;

    //朋友圈点赞
    function LikeSpirit(AUserID:Integer;
                        ALoginKey:String;
                        ASpiritID:Integer):String;
    function CancelLikeSpirit(AUserID:Integer;
                              ALoginKey:String;
                              ASpiritID:Integer):String;

    //朋友圈评论
    function CommentSpirit(AUserID:Integer;
                          ALoginKey:String;
                          ASpiritID:Integer;
                          AComment:String;
                          AReplyUserID:Integer):String;

  end;
{$METHODINFO OFF}




var
  WWWRootDir:String;



////把朋友圈的临时图片移动到正式目录
//function MoveTempPicTo(ADestDir:String;ATempFileName:String):Boolean;



implementation




uses System.StrUtils;



////把朋友圈的临时图片移动到正式目录
//function MoveTempPicTo(ADestDir:String;ATempFileName:String):Boolean;
//begin
//  Result:=True;
//  if ATempFileName<>'' then
//  begin
//    //创建文件夹
//    System.SysUtils.ForceDirectories(ADestDir);
//
//    //移动原图
//    Result:=MoveFile(PWideChar(WWWRootDir+'Temp\'+ATempFileName),
//                    PWideChar(ADestDir+ATempFileName));
//
//    //移动缩略图
//    if FileExists(WWWRootDir+'Temp\'+const_ThumbPrefix+ATempFileName) then
//    begin
//      Result:=MoveFile(PWideChar(WWWRootDir+'Temp\'+const_ThumbPrefix+ATempFileName),
//                      PWideChar(ADestDir+const_ThumbPrefix+ATempFileName));
//    end;
//  end;
//end;


function TServerMethods1.RegisterUser(AName,
                                      APhone,
                                      ACaptcha,
                                      APassword,
                                      ARePassword: String): string;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  AMaxFID:Integer;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  if Trim(AName)='' then
  begin
    ADesc:='姓名不能为空';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;

  if Trim(APhone)='' then
  begin
    ADesc:='手机号不能为空';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;

  if Trim(ACaptcha)='' then
  begin
    ADesc:='验证码不能为空';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;

  if Trim(APassword)='' then
  begin
    ADesc:='密码不能为空';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;

  if APassword<>ARePassword then
  begin
    ADesc:='两次输入的密码不相同';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;





  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
                        ['Phone'],
                        [APhone],
                        asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if ASQLDBHelper.Query.Eof then
      begin





            //比对用户注册验证码
            if ASQLDBHelper.SelfQuery('SELECT TOP 1 * FROM tblCaptcha WHERE Phone=:Phone AND Method=:Method ORDER BY AddTime DESC',
                                ['Phone','Method'],
                                [APhone,'Register'],
                                asoOpen) then
            begin
                if Not ASQLDBHelper.Query.Eof then
                begin
                  if ASQLDBHelper.Query.FieldByName('Captcha').AsString=ACaptcha then
                  begin
                          //验证码只能使用一次,并且有时间限制

                          //用户注册的验证码相同


                          AMaxFID:=GetMaxFID(ASQLDBHelper,'tblUser','FID',False);
                          if AMaxFID<>-1 then
                          begin
                            //插入新用户
                            if ASQLDBHelper.SelfQuery('INSERT INTO tblUser'
                                +'(FID,LoginUser,LoginPass,Name,Phone,RegTime,CompanyID,Sex,Sign) '
                                +'VALUES '
                                +'(:FID,:LoginUser,:LoginPass,:Name,:Phone,:RegTime,:CompanyID,:Sex,:Sign)',
                                        ['FID','LoginUser','LoginPass','Name','Phone','RegTime','CompanyID','Sex','Sign'],
                                        [
                                        AMaxFID,
                                        APhone,
                                        APassword,
                                        AName,
                                        APhone,
                                        Now,
                                        1,
                                        True,
                                        '无个性签名'
                                        ],
                                        asoExec) then
                            begin
                              //成功
                              ADesc:='注册成功';
                              ACode:=SUCC;

                            end
                            else
                            begin
                              //数据库连接失败或异常
                              ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                            end;
                          end
                          else
                          begin
                            //数据库连接失败或异常
                            ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                          end;






                  end
                  else
                  begin
                    //验证码不正确
                    ADesc:='验证码不正确';
                  end;
                end
                else
                begin
                  ADesc:='未对此手机发送过验证码';
                end;


            end
            else
            begin
              //数据库连接失败或异常
              ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
            end;








      end
      else
      begin
        //此手机号已经被注册
        ADesc:='此手机号已经被注册';
      end;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;

  end;



end;

function TServerMethods1.CheckNewVersion: String;
var
  AIniFile:TIniFile;
  ANewVersion:String;
  AVersion:String;
  AUpdateLog:String;
  AAndroid:String;
  AIOS:String;
  AMustUpdate:Boolean;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;



  AIniFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Upload\Update\Update.ini');
  try
    ANewVersion:=AIniFile.ReadString('','NewVersion','');
  finally
    FreeAndNil(AIniFile);
  end;

  if ANewVersion<>'' then
  begin


    AIniFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'Upload\Update\'+ANewVersion+'\Version.ini');

    try
      //版本
      AVersion:=AIniFile.ReadString('','Version','');
      //升级日志
      AUpdateLog:=AIniFile.ReadString('','UpdateLog','');
      //Android升级包
      AAndroid:=AIniFile.ReadString('','Android','');
      //IOS的appstore地址
      AIOS:=AIniFile.ReadString('','IOS','');
      //是否必须升级
      AMustUpdate:=AIniFile.ReadBool('','MustUpdate',False);


      //成功
      ADesc:='获取新版本信息成功';
      ACode:=SUCC;
      ADataJson:=TSuperObject.Create;
      ADataJson.S['Version']:=AVersion;
      ADataJson.S['UpdateLog']:=AUpdateLog;
      ADataJson.S['Android']:=AAndroid;
      ADataJson.S['IOS']:=AIOS;
      ADataJson.B['MustUpdate']:=AMustUpdate;

    finally
      FreeAndNil(AIniFile);
    end;

  end;

  Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;

end;

function TServerMethods1.CommentSpirit(AUserID: Integer; ALoginKey: String;
  ASpiritID: Integer; AComment: String;
                          AReplyUserID:Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  if Trim(AComment)='' then
  begin

    ADesc:='评论不能为空!';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;



  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try



      //插入
      if ASQLDBHelper.SelfQuery('INSERT INTO tblSpiritComment(UserID,SpiritID,Comment,ReplyUserID,CreateTime) '
                              +' VALUES(:UserID,:SpiritID,:Comment,:ReplyUserID,:CreateTime) ',
          ['UserID','SpiritID','Comment','ReplyUserID','CreateTime'],
          [
          AUserID,ASpiritID,AComment,AReplyUserID,Now()
          ],
          asoExec) then
      begin

          //评论数加1
          if ASQLDBHelper.SelfQuery('UPDATE tblSpirit SET CommentCount=ISNULL(CommentCount,0)+1 '
                                  +' WHERE FID=:FID ',
              ['FID'],
              [
              ASpiritID
              ],
              asoExec) then
          begin

              //成功
              ADesc:='朋友圈评论成功';
              ACode:=SUCC;

          end
          else
          begin
            //数据库连接失败或异常
            ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
          end;

      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;


  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.CheckForgetPasswordCaptcha(
                APhone,
                ACaptcha: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;



  //验证码检验成功
  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
                        ['Phone'],
                        [APhone],
                        asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if not ASQLDBHelper.Query.Eof then
      begin




            //比对验证码
            if ASQLDBHelper.SelfQuery('SELECT TOP 1 * FROM tblCaptcha WHERE Phone=:Phone AND Method=:Method ORDER BY AddTime DESC',
                                ['Phone','Method'],
                                [APhone,'ForgetPassword'],
                                asoOpen) then
            begin
                if Not ASQLDBHelper.Query.Eof then
                begin
                  if ASQLDBHelper.Query.FieldByName('Captcha').AsString=ACaptcha then
                  begin
                      //验证码相同

                      //成功
                      ADesc:='验证码正确';
                      ACode:=SUCC;

                  end
                  else
                  begin
                    //验证码不正确
                    ADesc:='验证码不正确';
                  end;
                end
                else
                begin
                  ADesc:='未发送过验证码';
                end;


            end
            else
            begin
              //数据库连接失败或异常
              ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
            end;








      end
      else
      begin
        //此手机号未被注册
        ADesc:='此手机号未被注册';
      end;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;


function TServerMethods1.ReSetPassword(APhone,
                                      ACaptcha,
                                      APassword,
                                      ARePassword: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  if APassword<>ARePassword then
  begin
    ADesc:='两次输入的密码不相同';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;


//  Self.ContentStream:=nil;


  //验证码检验成功
  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
                        ['Phone'],
                        [APhone],
                        asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if not ASQLDBHelper.Query.Eof then
      begin
            //存在此手机



            //比对验证码
            if ASQLDBHelper.SelfQuery('SELECT TOP 1 * FROM tblCaptcha WHERE Phone=:Phone AND Method=:Method ORDER BY AddTime DESC',
                                ['Phone','Method'],
                                [APhone,'ForgetPassword'],
                                asoOpen) then
            begin
                if Not ASQLDBHelper.Query.Eof then
                begin
                  if ASQLDBHelper.Query.FieldByName('Captcha').AsString=ACaptcha then
                  begin



                          //验证码相同


                          //存在此用户
                          //重置密码
                          if ASQLDBHelper.SelfQuery('UPDATE tblUser SET LoginPass=:LoginPass WHERE Phone=:Phone',
                                                            ['LoginPass','Phone'],
                                                            [APassword,APhone],
                                                            asoExec) then
                          begin
                            //密码重置成功
                            ADesc:='密码重置成功';
                            ACode:=SUCC;
                          end
                          else
                          begin
                            //数据库连接失败或异常
                            ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                          end;



                  end
                  else
                  begin
                    //验证码不正确
                    ADesc:='验证码不正确';
                  end;
                end
                else
                begin
                  ADesc:='未发送过验证码';
                end;


            end
            else
            begin
              //数据库连接失败或异常
              ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
            end;








      end
      else
      begin
        //此手机号未被注册
        ADesc:='此手机号未被注册';
      end;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;



end;

function TServerMethods1.SendForgetPasswordCaptcha(APhone: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  AMaxFID:Integer;
var
  ACaptcha:String;
  AHttpResponse:String;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;




  //发送忘记密码验证码

  //'{"error_response":{"code":15,"msg":"Remote service error","sub_code":"isv.BUSINESS_LIMIT_CONTROL","sub_msg":"触发业务流控","request_id":"43w0kbsij3k7"}}'
  //'{"alibaba_aliqin_fc_sms_num_send_response":{"result":{"err_code":"0","model":"102475257659^1103163056321","success":true},"request_id":"13yk4gjlsuxvd"}


  ACaptcha:=GenerateCaptcha_6;

  //将验证码保存到数据库中,并十分钟有效


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
                        ['Phone'],
                        [APhone],
                        asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if Not ASQLDBHelper.Query.Eof then
      begin
                //存在此手机号


                //发送忘记密码验证码
                GlobalTaoBaoManager.APIClient.CustomExecuteAPI(
                        GlobalTaoBaoManager.CallAPIHttpControl,
                        GlobalSendSmsTaoBaoAPIItem,
                        ['sms_type',
                        'sms_free_sign_name',
                        'sms_param',
                        'rec_num',
                        'sms_template_code'],
                        ['normal',
                        '变更验证',
                        '{"code":"'+ACaptcha+'","product":"OrangeUI朋友圈App"}',
                        APhone,
                        'SMS_13042194'],
                        cpsJson,
                        rmGet,
                        AHttpResponse
                        );




                AMaxFID:=GetMaxFID(ASQLDBHelper,'tblCaptcha','FID',False);
                if AMaxFID<>-1 then
                begin
                  //插入
                  if ASQLDBHelper.SelfQuery('INSERT INTO tblCaptcha'
                      +'(FID,Phone,Method,Captcha,AddTime,Response) '
                      +'VALUES '
                      +'(:FID,:Phone,:Method,:Captcha,:AddTime,:Response)',
                              ['FID','Phone','Method','Captcha','AddTime','Response'],
                              [
                              AMaxFID,
                              APhone,
                              'ForgetPassword',
                              ACaptcha,
                              Now,
                              AHttpResponse
                              ],
                              asoExec) then
                  begin



                    //成功
                    ADesc:='发送成功';
                    ACode:=SUCC;

                  end
                  else
                  begin
                    //数据库连接失败或异常
                    ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                  end;
                end
                else
                begin
                  //数据库连接失败或异常
                  ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                end;




      end
      else
      begin
        //此手机号未注册
        ADesc:='此手机号未注册';
      end;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.SendRegisterCaptcha(APhone: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  AMaxFID:Integer;
var
  ACaptcha:String;
  AHttpResponse:String;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  //发送用户注册验证码

  //'{"error_response":{"code":15,"msg":"Remote service error","sub_code":"isv.BUSINESS_LIMIT_CONTROL","sub_msg":"触发业务流控","request_id":"43w0kbsij3k7"}}'
  //'{"alibaba_aliqin_fc_sms_num_send_response":{"result":{"err_code":"0","model":"102475257659^1103163056321","success":true},"request_id":"13yk4gjlsuxvd"}


  ACaptcha:=GenerateCaptcha;

  //将验证码保存到数据库中,并十分钟有效


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
                              ['Phone'],
                              [APhone],
                              asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if ASQLDBHelper.Query.Eof then
      begin
              //不存在此手机号


              //发送用户注册验证码
              GlobalTaoBaoManager.APIClient.CustomExecuteAPI(
                      GlobalTaoBaoManager.CallAPIHttpControl,
                      GlobalSendSmsTaoBaoAPIItem,
                      ['sms_type',
                      'sms_free_sign_name',
                      'sms_param',
                      'rec_num',
                      'sms_template_code'],
                      ['normal',
                      '注册验证',
                      '{"code":"'+ACaptcha+'","product":"OrangeUI朋友圈App"}',
                      APhone,
                      'SMS_13042196'],
                      cpsJson,
                      rmGet,
                      AHttpResponse
                      );




              AMaxFID:=GetMaxFID(ASQLDBHelper,'tblCaptcha','FID',False);
              if AMaxFID<>-1 then
              begin
                //插入
                if ASQLDBHelper.SelfQuery('INSERT INTO tblCaptcha'
                    +'(FID,Phone,Method,Captcha,AddTime,Response) '
                    +'VALUES '
                    +'(:FID,:Phone,:Method,:Captcha,:AddTime,:Response)',
                            ['FID','Phone','Method','Captcha','AddTime','Response'],
                            [
                            AMaxFID,
                            APhone,
                            'Register',
                            ACaptcha,
                            Now,
                            AHttpResponse
                            ],
                            asoExec) then
                begin



                  //成功
                  ADesc:='发送成功';
                  ACode:=SUCC;

                end
                else
                begin
                  //数据库连接失败或异常
                  ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                end;



              end
              else
              begin
                //数据库连接失败或异常
                ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
              end;





      end
      else
      begin
        //此手机号已经被注册
        ADesc:='此手机号已经被注册';
      end;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.GetShieldUserList(AUserFID: Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;

  try
    if ASQLDBHelper.SelfQuery(' SELECT ShieldUserFID,B.* FROM  tblShieldUser A'
                                  +' LEFT JOIN tblUser B ON A.ShieldUserFID=B.FID'
                                  +' WHERE UserFID=:UserFID',
                                  ['UserFID'],
                                  [AUserFID],
                                  asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      //存在此用户
      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'User');
      ADesc:='获取成功';
      ACode:=SUCC;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

function TServerMethods1.UpdateUserHead(AUserID: Integer; ALoginKey,
  AHeadPic: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;



  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try

      //移动头像文件
      MoveTempPicTo(WWWRootDir+'Upload\UserHead\',AHeadPic);


      //资料修改
      if ASQLDBHelper.SelfQuery('UPDATE tblUser SET HeadPicPath=:HeadPicPath WHERE FID=:FID',
                                ['HeadPicPath','FID'],
                                [AHeadPic,AUserID],
                                asoExec) then
      begin
        //头像修改成功
        ADesc:='头像修改成功';
        ACode:=SUCC;
      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;


  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.UpdateUserInfo(AUserID: Integer; ALoginKey,
  AUpdateJsonStr: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;

  AUpdateJson:ISuperObject;

  AParamNames: array of String;
  AParamValues: array of Variant;

  I:Integer;
  AFieldList:TStringList;
  ACount:Integer;
  AIndex:Integer;
  AUpdateSQL:String;
begin
  //更新用户资料

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  //Json中包含需要更新哪些资料
  AUpdateJson:=TSuperObject.Create(AUpdateJsonStr);


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try

      //判断用户是否已经存在
      if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE FID=:FID',
                              ['FID'],
                              [AUserID],
                              asoOpen) then
      begin
          if ASQLDBHelper.Query.Eof then
          begin
            //不存在此用户
            ADesc:='不存在此用户';
            Exit;
          end;
      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;




      //判断用户名是否已经存在
      if AUpdateJson.Contains('Name') then
      begin
        if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Name=:Name AND FID<>:FID',
                                ['Name','FID'],
                                [AUpdateJson.S['Name'],AUserID],
                                asoOpen) then
        begin
            if not ASQLDBHelper.Query.Eof then
            begin
              //已经存在此用户名
              ADesc:='已经存在此用户名';
              Exit;
            end;
        end
        else
        begin
          //数据库连接失败或异常
          ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
        end;
      end;


      AFieldList:=TStringList.Create;
      AFieldList.CommaText:='Name,Sign,Sex,Area';
      ACount:=0;
      for I := 0 to AFieldList.Count-1 do
      begin
        if AUpdateJson.Contains(AFieldList[I]) then
        begin
          Inc(ACount);
        end;
      end;


      //获取需要更新的字段
      SetLength(AParamNames,ACount+1);
      SetLength(AParamValues,ACount+1);
      AParamNames[0]:='FID';
      AParamValues[0]:=AUserID;
      AUpdateSQL:='';


      AIndex:=1;
      for I := 0 to AFieldList.Count-1 do
      begin
        if AUpdateJson.Contains(AFieldList[I]) then
        begin

          AParamNames[AIndex]:=AFieldList[I];
          AParamValues[AIndex]:=AUpdateJson.V[AFieldList[I]];
          if AUpdateSQL='' then
          begin
            AUpdateSQL:=AFieldList[I]+'=:'+AFieldList[I];
          end
          else
          begin
            AUpdateSQL:=AUpdateSQL+','+AFieldList[I]+'=:'+AFieldList[I];
          end;

          Inc(AIndex);

        end;
      end;


      AFieldList.Free;


      //资料修改
      if ASQLDBHelper.SelfQuery('UPDATE tblUser SET '+AUpdateSQL+' WHERE FID=:FID',
                          ConvertToStringDynArray(AParamNames),
                          ConvertToVariantDynArray(AParamValues),
                          asoExec) then
      begin
        //资料修改成功
        ADesc:='资料修改成功';
        ACode:=SUCC;
      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;





  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.WantedComplainUser(AUserFID, AComplainUserFID: Integer;
  AType, AComplainContant: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin
  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;

  try
    if ASQLDBHelper.SelfQuery(' INSERT  INTO  tblComplain(Type,UserFID,ComplainUserFID,ComplainTime,ComplainContant) '
                                 +' VALUES(:Type,:UserFID,:ComplainUserFID,:ComplainTime,:ComplainContant)' ,
                                  ['Type','UserFID','ComplainUserFID','ComplainTime','ComplainContant'],
                                  [AType,AUserFID,AComplainUserFID,Now,AComplainContant],
                                  asoExec) then

    begin
      ADesc:='插入成功';
      ACode:=SUCC;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;


end;

function TServerMethods1.WantedShieldUser(AUserFID,
  AShieldUserFID: Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin
  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;

  try
    if ASQLDBHelper.SelfQuery(' INSERT INTO  tblShieldUser(UserFID,ShieldUserFID,CreateTime)'
                                 +' VALUES(:UserFID,:ShieldUserFID,:CreateTime)' ,
                                  ['UserFID','ShieldUserFID','CreateTime'],
                                  [AUserFID,AShieldUserFID,Now],
                                  asoExec) then

    begin
      ADesc:='插入成功';
      ACode:=SUCC;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;


end;

constructor TServerMethods1.Create(AOwner: TComponent);
begin
  inherited;
end;


function TServerMethods1.DelSpirit(AUserID: Integer; ALoginKey: String;
  ASpiritID: Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try

      //插入
      if ASQLDBHelper.SelfQuery('UPDATE tblSpirit SET IsDeleted=1 WHERE FID=:FID ',
          ['FID'],
          [
          ASpiritID
          ],
          asoExec) then
      begin

          //成功
          ADesc:='朋友圈删除成功';
          ACode:=SUCC;

      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;


  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

destructor TServerMethods1.Destroy;
begin
  inherited;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.GetUserInfo(AUserID: Integer;ALoginUserID:Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;

  try
    if ASQLDBHelper.SelfQuery('SELECT A.*,B.Name as CompanyName FROM tblUser A '
                                  +'LEFT JOIN tblCompany B ON A.CompanyID=B.FID WHERE A.FID=:FID',
                                  ['FID'],
                                  [AUserID],
                                  asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if Not ASQLDBHelper.Query.Eof then
      begin
        //存在此用户
        ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'User');

        if ASQLDBHelper.SelfQuery('SELECT * FROM tblShieldUser '
                                  +'WHERE UserFID=:UserFID AND ShieldUserFID=:ShieldUserFID',
                                  ['UserFID','ShieldUserFID'],
                                  [ALoginUserID,AUserID],
                                  asoOpen) then
        begin

          if ASQLDBHelper.Query.RecordCount>0 then
          begin
            ADataJson.B['IsShield']:=True;
          end
          else
          begin
            ADataJson.B['IsShield']:=False;
          end;

        end;


        ADesc:='获取成功';
        ACode:=SUCC;
      end
      else
      begin
        //不存在此用户
        ADesc:='不存在此用户';
      end;


    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

function TServerMethods1.GetUserSpiritList(AUserID: Integer; ALoginKey: String;
  APageIndex, APageSize: Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASpiritJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
  I: Integer;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if APageSize<=0 then APageSize:=Const_PageSize;


    if ASQLDBHelper.SelfQuery(

                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '


                                      +'SELECT '
                                      +'ROW_NUMBER() OVER (ORDER BY A.AddTime DESC) AS RowNumber, '
                                      +'A.*,'
                                      +'B.Name as UserName,B.HeadPicPath as UserHeadPicPath, '
                                      +'C.Name as CompanyName'
                                      +' FROM tblSpirit A '

                                      //显示用户名
                                      +'LEFT JOIN tblUser B ON A.UserID=B.FID '
                                      //显示部门名称
                                      +'LEFT JOIN tblCompany C ON B.CompanyID=C.FID '



                                      +'WHERE B.FID IS NOT NULL '
                                      +' AND ISNULL(A.IsDeleted,0)<>1 '
//                                      +'SELECT B.Name,A.* FROM tblSpirit A LEFT JOIN tblUser B ON A.UserID=B.FID'

                                      +'AND  A.UserID NOT IN (SELECT ShieldUserFID FROM tblShieldUser WHERE UserFID=:UserFID)'


                                      +') Z '
                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '

                                      +'ORDER BY AddTime DESC ',
                                      ['UserFID'],
                                      [AUserID],
                                      asoOpen) then
    begin

        //获取成功
        ADesc:='获取成功';
        ACode:=SUCC;
        ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'UserSpiritList');


        //根据CommentCount和LikeCount判断是否需要查询
        for I := 0 to ADataJson.A['UserSpiritList'].Length-1 do
        begin
            ASpiritJson:=ADataJson.A['UserSpiritList'].O[I];


            if ASpiritJson.I['LikeCount']>0 then
            begin
              //查询每个朋友圈的前五个点赞,以及点赞总数
              if ASQLDBHelper.SelfQuery('SELECT A.*,'
                                        +'B.Name as UserName,B.HeadPicPath as UserHeadPicPath '
                                        +' FROM tblSpiritLike A '
                                        +' LEFT JOIN tblUser B ON A.UserID=B.FID '
                                        +' WHERE SpiritID=:SpiritID'
                                        +' ORDER BY A.CreateTime ',
                                        ['SpiritID'],[ASpiritJson.I['FID']],asoOpen) then
              begin
                ASpiritJson.O['Like']:=JSonFromDataSet(ASQLDBHelper.Query,'LikeList');
              end
              else
              begin
                //数据库连接失败或异常
                ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                Exit;
              end;
            end;



            if ASpiritJson.I['CommentCount']>0 then
            begin
              //查询每个朋友圈的前五个评论,评论总数
              if ASQLDBHelper.SelfQuery('SELECT A.*, '
                                        +'B.Name as UserName,B.HeadPicPath as UserHeadPicPath, '
                                        +'C.Name as ReplyUserName '
                                        +' FROM tblSpiritComment A '
                                        +' LEFT JOIN tblUser B ON A.UserID=B.FID '
                                        +' LEFT JOIN tblUser C ON A.ReplyUserID=C.FID '
                                        +' WHERE SpiritID=:SpiritID'
                                        +' ORDER BY A.CreateTime ',
                                        ['SpiritID'],[ASpiritJson.I['FID']],asoOpen) then
              begin
                ASpiritJson.O['Comment']:=JSonFromDataSet(ASQLDBHelper.Query,'CommentList');
              end
              else
              begin
                //数据库连接失败或异常
                ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                Exit;
              end;
            end;

        end;





    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

function TServerMethods1.AddSpirit_V2(AUserID: Integer; ALoginKey, ASpirit,
  APic1, APic2, APic3, APic4, APic5, APic6, APic7, APic8, APic9: String;
  APic1Width, APic1Height: Integer; ALatitude, ALongitude: Double; AAddr,
  APhoneType: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  AMaxFID:Integer;
  ASQLDBHelper:TADODBHelper;
  ADestDir:String;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try

      AMaxFID:=GetMaxFID(ASQLDBHelper,'tblSpirit','FID',False);
      if AMaxFID<>-1 then
      begin

          //移动文件
          ADestDir:=WWWRootDir+'Upload\Spirit\'+IntToStr(AMaxFID)+'\';

          MoveTempPicTo(ADestDir,APic1);
          MoveTempPicTo(ADestDir,APic2);
          MoveTempPicTo(ADestDir,APic3);
          MoveTempPicTo(ADestDir,APic4);
          MoveTempPicTo(ADestDir,APic5);
          MoveTempPicTo(ADestDir,APic6);
          MoveTempPicTo(ADestDir,APic7);
          MoveTempPicTo(ADestDir,APic8);
          MoveTempPicTo(ADestDir,APic9);

          //插入
          if ASQLDBHelper.SelfQuery('INSERT INTO tblSpirit'
                                  +'(FID,UserID,Spirit,Pic1Path,Pic2Path,Pic3Path,Pic4Path,Pic5Path,Pic6Path,Pic7Path,Pic8Path,Pic9Path,AddTime,Pic1Width,Pic1Height,CommentCount,LikeCount,Latitude,Longitude,Addr,PhoneType) '
                                  +'VALUES '
                                  +'(:FID,:UserID,:Spirit,:Pic1Path,:Pic2Path,:Pic3Path,:Pic4Path,:Pic5Path,:Pic6Path,:Pic7Path,:Pic8Path,:Pic9Path,:AddTime,:Pic1Width,:Pic1Height,:CommentCount,:LikeCount,:Latitude,:Longitude,:Addr,:PhoneType)',
                                  ['FID','UserID','Spirit','Pic1Path','Pic2Path','Pic3Path','Pic4Path','Pic5Path','Pic6Path','Pic7Path','Pic8Path','Pic9Path','AddTime','Pic1Width','Pic1Height','CommentCount','LikeCount','Latitude','Longitude','Addr','PhoneType'],
                                  [
                                  AMaxFID,
                                  AUserID,
                                  ASpirit,
                                  APic1,
                                  APic2,
                                  APic3,
                                  APic4,
                                  APic5,
                                  APic6,
                                  APic7,
                                  APic8,
                                  APic9,
                                  Now,
                                  APic1Width,
                                  APic1Height,
                                  0,
                                  0,
                                  ALatitude,
                                  ALongitude,
                                  AAddr,
                                  APhoneType
                                  ],
                                  asoExec) then
          begin

              //返回添加的朋友圈

              if ASQLDBHelper.SelfQuery('SELECT * FROM tblSpirit '
                                      +' WHERE FID=:FID ',
                                      ['FID'],
                                      [
                                      AMaxFID
                                      ],
                                      asoOpen) then
              begin

                  //成功
                  ADesc:='朋友圈添加成功';
                  ACode:=SUCC;

                  ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'UserSpirit');

              end
              else
              begin
                //数据库连接失败或异常
                ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
              end;

          end
          else
          begin
            //数据库连接失败或异常
            ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
          end;
      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;


  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.CanCelledShieldUser(AUserFID,
  AShieldUserFID: Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin
  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;

    try
    if ASQLDBHelper.SelfQuery(' DELETE FROM tblShieldUser WHERE '
                                 +'UserFID=:UserFID  AND ShieldUserFID=:ShieldUserFID' ,
                                  ['UserFID','ShieldUserFID'],
                                  [AUserFID,AShieldUserFID],
                                  asoExec) then

    begin
      ADesc:='删除成功';
      ACode:=SUCC;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.CancelLikeSpirit(AUserID: Integer; ALoginKey: String;
  ASpiritID: Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try

      //删除
      if ASQLDBHelper.SelfQuery('DELETE tblSpiritLike WHERE UserID=:UserID AND SpiritID=:SpiritID ',
          ['UserID','SpiritID'],
          [
          AUserID,ASpiritID
          ],
          asoExec) then
      begin

          //点赞数减1
          if ASQLDBHelper.SelfQuery('UPDATE tblSpirit SET LikeCount=ISNULL(LikeCount,0)-1 '
                                  +' WHERE FID=:FID ',
              ['FID'],
              [
              ASpiritID
              ],
              asoExec) then
          begin

              //成功
              ADesc:='朋友圈取消点赞成功';
              ACode:=SUCC;

          end
          else
          begin
            //数据库连接失败或异常
            ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
          end;

      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;


  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.ChangePassword(AUserID: Integer; ALoginKey,
                                        AOldPassword, APassword, ARePassword: String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  if APassword<>ARePassword then
  begin
    ADesc:='两次输入的密码不相同';
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE FID=:FID',
                        ['FID'],
                        [AUserID],
                        asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if Not ASQLDBHelper.Query.Eof then
      begin
          //存在此用户




          //比对密码
          if ASQLDBHelper.Query.FieldByName('LoginPass').AsString=AOldPassword then
          begin

                //密码修改
                if ASQLDBHelper.SelfQuery('UPDATE tblUser SET LoginPass=:LoginPass WHERE FID=:FID',
                                    ['LoginPass','FID'],
                                    [APassword,AUserID],
                                    asoExec) then
                begin
                  //密码修改成功
                  ADesc:='密码修改成功';
                  ACode:=SUCC;
                end
                else
                begin
                  //数据库连接失败或异常
                  ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
                end;

          end
          else
          begin
            ADesc:='原密码错误';
          end;




      end
      else
      begin
        //不存在此用户
        ADesc:='不存在此用户';
      end;
    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

function TServerMethods1.LikeSpirit(AUserID: Integer; ALoginKey: String;
  ASpiritID: Integer): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try

      //插入
      if ASQLDBHelper.SelfQuery('INSERT INTO tblSpiritLike(UserID,SpiritID,CreateTime) '
                              +' VALUES(:UserID,:SpiritID,:CreateTime) ',
          ['UserID','SpiritID','CreateTime'],
          [
          AUserID,ASpiritID,Now()
          ],
          asoExec) then
      begin

          //点赞数加1
          if ASQLDBHelper.SelfQuery('UPDATE tblSpirit SET LikeCount=ISNULL(LikeCount,0)+1 '
                                  +' WHERE FID=:FID ',
              ['FID'],
              [
              ASpiritID
              ],
              asoExec) then
          begin

              //成功
              ADesc:='朋友圈点赞成功';
              ACode:=SUCC;

          end
          else
          begin
            //数据库连接失败或异常
            ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
          end;

      end
      else
      begin
        //数据库连接失败或异常
        ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
      end;


  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

function TServerMethods1.Login(ALoginUser,
                              APassword: String;
                              AVersion:String): String;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;

  AUserFID:Integer;
  ASQLDBHelper:TADODBHelper;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE LoginUser=:LoginUser',
                        ['LoginUser'],
                        [ALoginUser],
                        asoOpen) then
    begin
      ASQLDBHelper.Query.First;
      if Not ASQLDBHelper.Query.Eof then
      begin


            //存在此用户


            //比对密码
            if ASQLDBHelper.Query.FieldByName('LoginPass').AsString=APassword then
            begin
              //密码正确
              AUserFID:=ASQLDBHelper.Query.FieldByName('FID').AsInteger;

              if ASQLDBHelper.SelfQuery('SELECT A.*,B.Name as CompanyName FROM tblUser A '
                                  +'LEFT JOIN tblCompany B ON A.CompanyID=B.FID WHERE A.FID=:FID',
                                  ['FID'],
                                  [AUserFID],
                                  asoOpen) then
              begin
                ADesc:='登陆成功';
                ACode:=SUCC;

                ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'User');
              end
              else
              begin
                //数据库连接失败或异常
                ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
              end;
            end
            else
            begin
              //密码不正确
              ADesc:='密码不正确';
            end;



      end
      else
      begin
        //不存在此用户
        ADesc:='不存在此用户';
      end;

    end
    else
    begin
      //数据库连接失败或异常
      ADesc:='数据库连接失败或异常'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

function TServerMethods1.AddSpirit(AUserID: Integer; ALoginKey, ASpirit, APic1,
  APic2, APic3, APic4, APic5, APic6, APic7, APic8, APic9: String;
                      APic1Width:Integer;
                      APic1Height:Integer): String;
begin
  Result:=AddSpirit_V2(AUserID,ALoginKey, ASpirit,
                      APic1,APic2, APic3, APic4, APic5, APic6, APic7, APic8, APic9,
                      APic1Width,APic1Height,
                      0,0,'','');
end;


function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;



end.

