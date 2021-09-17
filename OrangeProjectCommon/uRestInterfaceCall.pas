﻿//convert pas to utf8 by ¥
//copyright delphiteacher QQ:452330643
//2015-08-08
//未经授权,严禁出售赠送或转上他人使用
//也在VCL服务端中使用
unit uRestInterfaceCall;

interface
{$IF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS) }
  {$DEFINE FMX}
{$IFEND}



//请在工程下放置FrameWork.inc
//或者在工程设置中配置FMX编译指令
//才可以正常编译此单元
{$IFNDEF FMX}
  {$IFNDEF VCL}
    {$I FrameWork.inc}
  {$ENDIF}
{$ENDIF}



uses
  Classes,
  SysUtils,
  Variants,
  Types,
  DateUtils,
  StrUtils,
  INIFiles,
  IdURI,
  uLang,
  uBaseLog,
  uBaseList,
//  uOpenCommon,
//  uOpenClientCommon,
  uFuncCommon,
  uFileCommon,
  uTimerTask,



  {$IF CompilerVersion <= 21.0} // Delphi 2010以前
  SuperObject,
  superobjecthelper,
  {$ELSE}
    {$IFDEF SKIN_SUPEROBJECT}
    uSkinSuperObject,
    {$ELSE}
    XSuperObject,
    XSuperJson,
    {$ENDIF}
  {$IFEND}


  {$IF CompilerVersion <= 21.0}
  uIdHttpControl,
  {$IFEND}



//  uModule_InterfaceSign,

//  {$IFDEF VCL}
//  {$ELSE}

  {$IF CompilerVersion > 21.0}
  System.Hash ,
  System.NetEncoding,
  System.Net.URLClient,
  {$IFEND}

//  {$ENDIF}

  ZLib,
  uBaseHttpControl
  ;

const
  //Rest接口签名类型
  CONST_REST_SIGNTYPE_XFAPP='1';
  CONST_REST_SIGNTYPE_MD5='md5';

Const
  SUCC=200;
  FAIL=400;


{$IF CompilerVersion<=33.0}
    {$IFDEF MSWINDOWS}
    const
      ENCRYPT_STRING_BASE_OFFSET=0;
    {$ELSE}
    const
      ENCRYPT_STRING_BASE_OFFSET=-1;
    {$ENDIF}
{$ELSE}
    const
      //10.4统计字符串下标了
      ENCRYPT_STRING_BASE_OFFSET=0;
{$IFEND}


type
  TNStringList = class(TStringList)
  protected
    function CompareStrings(const S1, S2: string): Integer; override;
  end;

type


  //调用接口的事件
  TCallAPIEvent=procedure(AHttpControl: THttpControl;AAPIUrl:String) of object;

//  TRestInterfaceCall=class(TObject,IRestInterfaceCall)
//
//  end;


//拼接参数到链接中
function GetUrl(API: String;
                  AInterfaceUrl:String;
                  AUrlParamNames:TStringDynArray;
                  AUrlParamValues:TVariantDynArray;
                  ASignType:String;
                  ASignSecret:String):String;


procedure SaveServerResponseLog(API:String;AResponseStream:TStringStream);

//调用rest接口,返回数据流
function SimpleGet(API: String;
                  AHttpControl: THttpControl;
                  AInterfaceUrl:String;
                  AUrlParamNames:TStringDynArray;
                  AUrlParamValues:TVariantDynArray;
                  AResponseStream: TStream;
                  ASignType:String='';
                  ASignSecret:String='';
                  AIsPost:Boolean=False;
                  APostStream:TStream=nil):Boolean;



//调用rest接口,返回字符串
function SimpleCallAPI(API: String;
                      AHttpControl: THttpControl;
                      AInterfaceUrl:String;
                      AUrlParamNames:TStringDynArray;
                      AUrlParamValues:TVariantDynArray;
                      ASignType:String='';
                      ASignSecret:String='';
                      AIsPost:Boolean=False;
                      APostStream:TStream=nil): String;overload;
function SimpleCallAPIPostString(API: String;
                      AHttpControl: THttpControl;
                      AInterfaceUrl:String;
                      AUrlParamNames:TStringDynArray;
                      AUrlParamValues:TVariantDynArray;
                      ASignType:String='';
                      ASignSecret:String='';
                      AIsPost:Boolean=False;
                      APostString:String=''): String;overload;

//调用rest接口,返回字符串,在服务端中使用
function SimpleCallAPI(API: String;
                      AHttpControl: THttpControl;
                      AInterfaceUrl:String;
                      AUrlParamNames:TStringDynArray;
                      AUrlParamValues:TVariantDynArray;
                      var ACode:Integer;
                      var ADesc:String;
                      var ADataJson:ISuperObject;
                      ASignType:String='';
                      ASignSecret:String='';
                      AIsPost:Boolean=False;
                      APostStream:TStream=nil;
                      APostString:String=''): Boolean;overload;






//保存记录到服务器
function SaveRecordToServer(AInterfaceUrl:String;
                            AAppID:Integer;
                            AUserFID:String;
                            AKey:String;
                            ATableCommonRestName:String;
                            AFID:Variant;
                            ARecordDataJson:ISuperObject;
                            var AIsAdd:Boolean;
                            var ADesc:String;
                            var ADataJson:ISuperObject;
                            ASignType:String;
                            ASignSecret:String;
                            AHasAppID:Boolean=True;
                            AFIDFieldName:String='fid'):Boolean;


{$IF CompilerVersion > 21.0}
//调用TableCommonRest的获取记录列表接口get_record_list,返回字符串
function SimpleCallAPI_TableCommonGetRecordList(
                            ARestName: String;
                            AHttpControl: THttpControl;
                            AInterfaceUrl:String;
                            AAppID:Integer;
                            AUserFID:String;
                            AKey:String;
                            APageIndex:Integer=1;
                            APageSize:Integer=MaxInt;
                            //4个String一组
                            AWhereConditions:TVariantDynArray=[];
                            AOrderBy:String='';
                            AWhereSQL:String='';
                            ASignType:String='';
                            ASignSecret:String=''): String;
{$IFEND}






//调用接口,返回数据流,用于推拿APP
function JsonSimplePost(API: String;
                        //不能为nil
                        AHttpControl: THttpControl;
                        AInterfaceUrl:String;
                        AParamJsonArray:ISuperArray;
                        AResponseStream: TStream):Boolean;overload;
function JsonSimpleCall(API: String;
                        //可以为nil
                        AHttpControl: THttpControl;
                        AInterfaceUrl:String;
                        AJsonParamNames:TStringDynArray;
                        AJsonParamValues:TVariantDynArray):String;overload;
function JsonSimpleCall(API: String;
                        //可以为nil
                        AHttpControl: THttpControl;
                        AInterfaceUrl:String;
                        AParamJsonArray:ISuperArray):String;overload;



function DoUploadFile(ALocalFilePath:String;
                      AUploadHttpServer:String;
                      AAppID:Integer;
                      ARemoteFileDir:String;
                      var ARemoteFilePath:String;
                      var ADesc:String):Boolean;



function GetWhereConditions(AFieldNames:TStringDynArray;
                            AFieldValues:TVariantDynArray):String;
function GetWhereKeyJson(AFieldNames:TStringDynArray;
                            AFieldValues:TVariantDynArray):String;
function GetWhereConditionsPro(AFieldNames:TStringDynArray;
                            //比较运算符
                            AFieldOpers:TStringDynArray;
                            AFieldValues:TVariantDynArray):String;



Function myStrtoHex(s:string):string;                       //原字符串转16进制字符串
Function smyHextoStr(s:string):string;                      //16进制字符串转原字符串
function encryptstr(const s:string; skey:string):string;overload;    //加密字符串
function decryptstr(const s:string; skey:string):string;overload;    //解密字符串

//function encryptstr(const s:string):string; overload;       //加密字符串
//function decryptstr(const s:string):string; overload;       //解密字符串

{$IF CompilerVersion > 21.0}
function LoadSignAsStringList(sl:TStringList; skey:string):string;
function LoadMD5SignAsStringList(sl:TStringList; skey:string):string;   //获取sign签名
{$IFEND}


var
  OnCallAPIEvent:TCallAPIEvent;
//  GlobalCallAPITaskList:TBaseList;
  //用户再次提交时使用
  GlobalLastParamJsonArray:ISuperArray;

  //全局的加签方式
  GlobalRestAPISignType:String;
  //APP接口签名方式的私钥
  GlobalRestAPIAppSecret:String;
  //是否启用加签的接口调用
  GlobalRestAPICheckSignIsEnable:Boolean;



function SignParam(
                  AUrlParamNames:TStringDynArray;
                  AUrlParamValues:TVariantDynArray;
                  ASignType:String;
                  ASignSecret:String):String;


implementation



function DoUploadFile(ALocalFilePath:String;
                      AUploadHttpServer:String;
                      AAppID:Integer;
                      ARemoteFileDir:String;
                      var ARemoteFilePath:String;
                      var ADesc:String):Boolean;
var
  AHttpControl:THttpControl;
  I: Integer;
  AResponseStream:TStringStream;
  ASuperObject:ISuperObject;
  APicStream:TMemoryStream;
  APicUploadSucc:Boolean;
begin
  Result:=False;

  ADesc:='';
  ARemoteFilePath:='';

  AHttpControl:=TSystemHttpControl.Create;
  APicStream:=TMemoryStream.Create;
  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try

      APicUploadSucc:=True;
      //上传图片
      APicStream.LoadFromFile(ALocalFilePath);

      APicUploadSucc:=AHttpControl.Post(
                          TIdURI.URLEncode(
                              AUploadHttpServer
                              +'/upload'
                                +'?appid='+IntToStr(AAppID)
                                +'&filename='+ExtractFileName(ALocalFilePath)
                                +'&filedir='+ARemoteFileDir
                                +'&fileext='+ExtractFileExt(ALocalFilePath)
                              ),
                              APicStream,
                              AResponseStream);


      if APicUploadSucc then
      begin
        AResponseStream.Position:=0;

        //ASuperObject:=TSuperObject.ParseStream(AResponseStream);
        //会报错'Access violation at address 004B6C7C in module ''Server.exe''. Read of address 00000000'
        //要从AResponseStream.DataString加载
        ASuperObject:=SO(AResponseStream.DataString);

//            '{"Code":200,"Desc":"\u4E0A\u4F20\u6587\u4EF6\u6210\u529F",
//            "Data":{
//            "RemoteFilePath":"Upload\\1002\\Shop_Pic\\2018\\2018-03-18\\C8B626D93B014B098B8BC829BE13D744.jpg",
//            "Url":"Upload/1002/Shop_Pic/2018/2018-03-18/C8B626D93B014B098B8BC829BE13D744.jpg"
//                  }
//            }'

        ADesc:=ASuperObject.S['Desc'];

        if ASuperObject.I['Code']=200 then
        begin
          //上传成功
          ARemoteFilePath:=ASuperObject.O['Data'].S['RemoteFilePath'];

          Result:=True;
        end
        else
        begin
          //上传失败
        end;

      end
      else
      begin
        //Http调用失败
        ADesc:=Trans('服务器连接失败');
      end;


  finally
    FreeAndNil(AHttpControl);
    uFuncCommon.FreeAndNil(APicStream);
    uFuncCommon.FreeAndNil(AResponseStream);
  end;

end;


function GetWhereKeyJson(AFieldNames:TStringDynArray;
                            AFieldValues:TVariantDynArray):String;
begin
  Result:=GetWhereConditions(AFieldNames,AFieldValues);
end;


function GetWhereConditions(AFieldNames:TStringDynArray;
                            AFieldValues:TVariantDynArray):String;
var
  I:Integer;

  AWhereKeyJson:ISuperObject;
  AWhereKeyJsonArray:ISuperArray;
begin
  AWhereKeyJsonArray:=TSuperArray.Create;

  for I := 0 to Length(AFieldNames)-1 do
  begin

    AWhereKeyJson:=TSuperObject.Create;
    AWhereKeyJson.S['logical_operator']:='AND';
    AWhereKeyJson.S['name']:=AFieldNames[I];
    AWhereKeyJson.S['operator']:='=';
    AWhereKeyJson.V['value']:=AFieldValues[I];

    AWhereKeyJsonArray.O[I]:=AWhereKeyJson;

  end;

  Result:=AWhereKeyJsonArray.AsJSON;
end;


function GetWhereConditionsPro(AFieldNames:TStringDynArray;
                            AFieldOpers:TStringDynArray;
                            AFieldValues:TVariantDynArray):String;
var
  I:Integer;

  AWhereKeyJson:ISuperObject;
  AWhereKeyJsonArray:ISuperArray;
begin
  AWhereKeyJsonArray:=TSuperArray.Create;

  for I := 0 to Length(AFieldNames)-1 do
  begin

    AWhereKeyJson:=TSuperObject.Create;
    AWhereKeyJson.S['logical_operator']:='AND';
    AWhereKeyJson.S['name']:=AFieldNames[I];
    AWhereKeyJson.S['operator']:=AFieldOpers[I];
    AWhereKeyJson.V['value']:=AFieldValues[I];

    AWhereKeyJsonArray.O[I]:=AWhereKeyJson;

  end;

  Result:=AWhereKeyJsonArray.AsJSON;
end;

{$IF CompilerVersion > 21.0}
function SimpleCallAPI_TableCommonGetRecordList(
                      ARestName: String;
                      AHttpControl: THttpControl;
                      AInterfaceUrl:String;
                      AAppID:Integer;
                      AUserFID:String;
                      AKey:String;
                      APageIndex:Integer;
                      APageSize:Integer;
                      AWhereConditions:TVariantDynArray;
                      AOrderBy:String;
                      AWhereSQL:String;
                      ASignType:String;
                      ASignSecret:String): String;
var
  AWhereKeyJson:ISuperObject;
  AWhereKeyJsonArray:ISuperArray;

  ASuperObject:ISuperObject;
  I: Integer;
begin
  Result:='';


  //条件
  AWhereKeyJsonArray:=TSuperArray.Create;
  for I := 0 to Length(AWhereConditions) div 4 -1 do
  begin
    AWhereKeyJson:=TSuperObject.Create;
    AWhereKeyJson.S['logical_operator']:=AWhereConditions[I*4];
    AWhereKeyJson.S['name']:=AWhereConditions[I*4+1];
    AWhereKeyJson.S['operator']:=AWhereConditions[I*4+2];
    AWhereKeyJson.V['value']:=AWhereConditions[I*4+3];
    AWhereKeyJsonArray.O[I]:=AWhereKeyJson;
  end;



  Result:=SimpleCallAPI('get_record_list',
                    AHttpControl,
                    AInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key',
                    'rest_name',
                    'pageindex',
                    'pagesize',
                    'where_key_json',
                    'order_by',
                    'where_sql'],
                    [AAppID,
                    AUserFID,
                    AKey,
                    ARestName,
                    APageIndex,
                    APageSize,
                    AWhereKeyJsonArray.AsJson,
                    AOrderBy,
                    AWhereSQL
                    ],
                    ASignType,
                    ASignSecret
                    );


end;
{$IFEND}

function SaveRecordToServer(AInterfaceUrl:String;
                            AAppID:Integer;
                            AUserFID:String;
                            AKey:String;
                            ATableCommonRestName:String;
                            AFID:Variant;
                            ARecordDataJson:ISuperObject;
                            var AIsAdd:Boolean;
                            var ADesc:String;
                            var ADataJson:ISuperObject;
                            ASignType:String;
                            ASignSecret:String;
                            AHasAppID:Boolean;
                            AFIDFieldName:String):Boolean;
var
  ACode: Integer;
  AFIDIsEmpty:Boolean;
  AWhereKeyJsonStr:String;
begin
  uBaseLog.HandleException(nil,'SaveRecordToServer Begin');


  Result:=False;
  AIsAdd:=False;

  if AHasAppID then
  begin
    AWhereKeyJsonStr:=GetWhereKeyJson(ConvertToStringDynArray(['appid',AFIDFieldName]),ConvertToVariantDynArray([AAppID,AFID]));
  end
  else
  begin
    AWhereKeyJsonStr:=GetWhereKeyJson(ConvertToStringDynArray([AFIDFieldName]),ConvertToVariantDynArray([AFID]));
  end;


  AFIDIsEmpty:=False;
  if (VarType(AFID)=varInteger)
    or (VarType(AFID)=varInt64)
    or (VarType(AFID)=varSmallint)
    or (VarType(AFID)=varByte)
    or (VarType(AFID)=varWord)
    or (VarType(AFID)=varLongWord)
    {$IF CompilerVersion > 21.0}
    or (VarType(AFID)=varUInt32)
    {$IFEND}
    or (VarType(AFID)=varUInt64)
    then
  begin
    AFIDIsEmpty:=(AFID=0);
  end
  else
  if (VarType(AFID)=varString) or (VarType(AFID)=varUString) then
  begin
    AFIDIsEmpty:=(AFID='');
  end
  else
  begin
    ADesc:='AFID值类型不支持';
    Exit;
  end;




  if AFIDIsEmpty then
  begin

      AIsAdd:=True;
      //不存在fid,表示要新增该记录
      if not SimpleCallAPI('add_record_post_2',
                              nil,
                              AInterfaceUrl+'tablecommonrest/',
                              ConvertToStringDynArray(
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'rest_name',
                                                      'record_data_json']),
                              ConvertToVariantDynArray([AAppID,
                                                        AUserFID,
                                                        AKey,
                                                        ATableCommonRestName,
                                                        ARecordDataJson.AsJson]),
                              ACode,
                              ADesc,
                              ADataJson,
                              ASignType,
                              ASignSecret,
                              True,
                              nil,
                              ARecordDataJson.AsJson
                              ) or (ACode<>SUCC) then
      begin
        uBaseLog.HandleException(nil,'SaveRecordToServer '+ADesc);
        Exit;
      end;

      Result:=True;
  end
  else if ARecordDataJson.Contains('is_deleted') and (ARecordDataJson.I['is_deleted']=1) then
  begin
      //删除记录
      if not SimpleCallAPI('update_record',
                              nil,
                              AInterfaceUrl+'tablecommonrest/',
                              ConvertToStringDynArray(['appid',
                              'user_fid',
                              'key',
                              'rest_name',
                              'record_data_json',
                              'where_key_json']),
                              ConvertToVariantDynArray([AAppID,
                              AUserFID,
                              AKey,
                              ATableCommonRestName,
                              ARecordDataJson.AsJson,
                              AWhereKeyJsonStr//GetWhereKeyJson(['appid','fid'],[AAppID,AFID])
                              ]),
                              ACode,
                              ADesc,
                              ADataJson,
                              ASignType,
                              ASignSecret) or (ACode<>SUCC)  then
      begin
        uBaseLog.HandleException(nil,'SaveRecordToServer '+ADesc);
        Exit;
      end;

      Result:=True;
  end
  else
  begin
      //更新记录
      if not SimpleCallAPI('update_record_post',
                              nil,
                              AInterfaceUrl+'tablecommonrest/',
                              ConvertToStringDynArray(['appid',
                                                      'user_fid',
                                                      'key',
                                                      'rest_name',
//                                                      'record_data_json',
                                                      'where_key_json']),
                              ConvertToVariantDynArray([AAppID,
                                                        AUserFID,
                                                        AKey,
                                                        ATableCommonRestName,
//                                                        ARecordDataJson.AsJson,
                                                        AWhereKeyJsonStr//GetWhereKeyJson(['appid','fid'],[AAppID,AFID])
                                                        ]),
                              ACode,
                              ADesc,
                              ADataJson,
                              ASignType,
                              ASignSecret,
                              True,
                              nil,
                              ARecordDataJson.AsJson
                              ) or (ACode<>SUCC)  then
      begin
        uBaseLog.HandleException(nil,'SaveRecordToServer '+ADesc);
        Exit;
      end;

      Result:=True;
  end;

end;

function JsonSimpleCall(API: String;
                        //可以为nil
                        AHttpControl: THttpControl;
                        AInterfaceUrl:String;
                        AParamJsonArray:ISuperArray):String;
var
  ACallResult:Boolean;
  AIsNeedFreeAHttpControl:Boolean;
  AResponseStream: TStringStream;
begin
//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'begin');

  Result:='';

  AIsNeedFreeAHttpControl:=False;
  if AHttpControl=nil then
  begin
    AIsNeedFreeAHttpControl:=True;
    AHttpControl:=TSystemHttpControl.Create;
  end;


  //AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try


    //2、登录
    //APP到电脑
    //[
    //  {"HotelID":"分店号","Action":"Login","AccountID":"工号","PassWord":"密码"}
    //]
    //
    //电脑到APP
    //[
    //  {"Action":"Login","Flag":"4"},
    //  {
    //	 权限参数,隐藏功能按钮
    //	 ...
    //  }
    //]



    GlobalLastParamJsonArray:=AParamJsonArray;
    ACallResult:=JsonSimplePost(
                               API,
                               AHttpControl,
                               AInterfaceUrl,
                               AParamJsonArray,
                               AResponseStream
                               );


    if ACallResult then
    begin
        //调用成功

        //保存成临时文件,用来查日志
        {$IFDEF MSWINDOWS}
        AResponseStream.Position:=0;
        AResponseStream.
            SaveToFile(GetApplicationPath
//                        +ReplaceStr(API,'/','_')+' '
                        +AParamJsonArray.O[0].S['Action']+' '
                        +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.json');
        {$ENDIF}



        AResponseStream.Position:=0;
        try
          Result:=AResponseStream.DataString;//列名 'SvrHandID' 无效。
        except
          on E:Exception do
          begin
            //编码不能识别,需要特殊处理一下
            Result:='';
          end;
        end;

        //服务不可用
        if Result='Service Unavailable' then
        begin
          Result:='';
        end;

        if Result='Internal Server Error' then
        begin
          Result:='';
        end;


    end
    else
    begin
        //调用失败

    end;

  finally
    SysUtils.FreeAndNil(AResponseStream);
    if AIsNeedFreeAHttpControl then
    begin
      SysUtils.FreeAndNil(AHttpControl);
    end;
  end;

//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'end');


end;

function JsonSimpleCall(API: String;
                        AHttpControl: THttpControl;
                        AInterfaceUrl:String;
                        AJsonParamNames:TStringDynArray;
                        AJsonParamValues:TVariantDynArray):String;
var
  I:Integer;
  AParamJsonArray:ISuperArray;
  AParamJson:ISuperObject;
begin
//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'begin');

  Result:='';


  AParamJsonArray:=TSuperArray.Create;
  AParamJson:=TSuperObject.Create;
  AParamJsonArray.O[0]:=AParamJson;

  for I:=0 to Length(AJsonParamNames)-1 do
  begin
    AParamJson.V[AJsonParamNames[I]]:=AJsonParamValues[I];
  end;


  Result:=JsonSimpleCall(
                         API,
                         AHttpControl,
                         AInterfaceUrl,
                         AParamJsonArray
                         );

end;


procedure SaveServerResponseLog(API:String;AResponseStream:TStringStream);
var
  ALogDir:String;
  ARandom:Integer;
begin
        {$IFDEF MSWINDOWS}
        if DirectoryExists('C:\MyFiles') or DirectoryExists('D:\MyFiles') then
        begin
          Randomize();
          ARandom:=Random(1000);

          try
            AResponseStream.Position:=0;

            ALogDir:=GetApplicationPath+'log\ServerReponse\';
            if not DirectoryExists(ALogDir) then
            begin
              SysUtils.ForceDirectories(ALogDir);
            end;
            if Pos('://',API)>0 then
            begin
              AResponseStream.SaveToFile(ALogDir
                              //+ReplaceStr(API,'/','_')+' '
                              +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+' '+IntToStr(ARandom)+'.json');

            end
            else
            begin

              AResponseStream.SaveToFile(ALogDir
                              +ReplaceStr(API,'/','_')+' '
                              +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+' '+IntToStr(ARandom)+'.json');
            end;

          except

          end;
        end;
        {$ENDIF}



end;


function SimpleCallAPI(API: String;
                      AHttpControl:THttpControl;
                      AInterfaceUrl:String;
                      AUrlParamNames:TStringDynArray;
                      AUrlParamValues:TVariantDynArray;
                      ASignType:String;
                      ASignSecret:String;
                      AIsPost:Boolean;
                      APostStream:TStream): String;
var
  ACallResult:Boolean;
  AResponseStream: TStringStream;
  ALogDir:String;
begin
//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'begin');

  Result:='';

  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try
    ACallResult:=SimpleGet(
                         API,
                         AHttpControl,
                         AInterfaceUrl,
                         AUrlParamNames,
                         AUrlParamValues,
                         AResponseStream,
  //                       False,
  //                       AIsPost,
                          ASignType,
                          ASignSecret,
                          AIsPost,
                          APostStream
                         );


    if ACallResult then
    begin
        //调用成功



        //保存成临时文件,用来查日志
        SaveServerResponseLog(API,AResponseStream);


        AResponseStream.Position:=0;
        Result:=AResponseStream.DataString;

//        //服务不可用
//        if Result='Service Unavailable' then
//        begin
//          Result:='';
//        end;
//
//        //'Service . not available.'
//
//        if Result='Internal Server Error' then
//        begin
//          Result:='';
//        end;
//
//        if Result='Service . not available.' then
//        begin
//          Result:='';
//        end;
//
//        //'Service . not available.'
    end
    else
    begin
      //调用失败

    end;

  finally
    SysUtils.FreeAndNil(AResponseStream);
  end;

//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'end');
end;

function SimpleCallAPIPostString(API: String;
                                  AHttpControl:THttpControl;
                                  AInterfaceUrl:String;
                                  AUrlParamNames:TStringDynArray;
                                  AUrlParamValues:TVariantDynArray;
                                  ASignType:String;
                                  ASignSecret:String;
                                  AIsPost:Boolean;
                                  APostString:String): String;
var
  APostStream:TStringStream;
begin
//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'begin');

  Result:='';

  APostStream:=TStringStream.Create(APostString,TEncoding.UTF8);
  try
    Result:=SimpleCallAPI(
                         API,
                         AHttpControl,
                         AInterfaceUrl,
                         AUrlParamNames,
                         AUrlParamValues,
//                         AResponseStream,
  //                       False,
  //                       AIsPost,
                          ASignType,
                          ASignSecret,
                          AIsPost,
                          APostStream
                         );
  finally
    SysUtils.FreeAndNil(APostStream);
  end;

//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'end');
end;


function SimpleCallAPI(API: String;
                        AHttpControl: THttpControl;
                        AInterfaceUrl:String;
                        AUrlParamNames:TStringDynArray;
                        AUrlParamValues:TVariantDynArray;
                        var ACode:Integer;
                        var ADesc:String;
                        var ADataJson:ISuperObject;
                        ASignType:String;
                        ASignSecret:String;
                        AIsPost:Boolean;
                        APostStream:TStream;
                        APostString:String): Boolean;
var
  AHttpResponse:String;
  ASuperObject:ISuperObject;
  AIsNeedFreePostStream:Boolean;
begin
  Result:=False;

  //在外面初始好了,不用再在里面初始了
  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;

  AIsNeedFreePostStream:=False;
  if AIsPost then
  begin
    if (APostStream=nil) and (APostString<>'') then
    begin
      APostStream:=TStringStream.Create(APostString,TEncoding.UTF8);
      AIsNeedFreePostStream:=True;
    end;
  end;


  AHttpResponse:=SimpleCallAPI(API,
                              AHttpControl,
                              AInterfaceUrl,
                              AUrlParamNames,
                              AUrlParamValues,
                              ASignType,
                              ASignSecret,
                              AIsPost,
                              APostStream
                              );


  if AIsNeedFreePostStream then
  begin
    FreeAndNil(APostStream);
  end;

  if (AHttpResponse<>'')
//    and not SameText(AHttpResponse,'Service Unavailable')
    then
  begin

      //服务不可用
      if AHttpResponse='Service Unavailable' then
      begin
        ADesc:=AHttpResponse;
        Result:=False;
        Exit;
      end;

      //'Service . not available.'

      if AHttpResponse='Internal Server Error' then
      begin
        ADesc:=AHttpResponse;
        Result:=False;
        Exit;
      end;

      if AHttpResponse='Service . not available.' then
      begin
        ADesc:=AHttpResponse;
        Result:=False;
        Exit;
      end;

      //'Service . not available.'


      try
          ASuperObject:=SO(AHttpResponse);

          ACode:=ASuperObject.I['Code'];
          ADesc:=ASuperObject.S['Desc'];
          ADataJson:=ASuperObject.O['Data'];

//          if ACode=SUCC then
//          begin

            //接口返回成功
            Result:=True;

            if ACode<>SUCC then
            begin
              uBaseLog.HandleException(nil,'SimpleCallAPI '
                                            +' API:'+API
                                            +' Url:'+AInterfaceUrl
                                            );
              if ADataJson<>nil then
              begin
              uBaseLog.HandleException(nil,'SimpleCallAPI '
                                            +' API:'+API
                                            +' Url:'+AInterfaceUrl
                                            +' DataJson:'+ADataJson.AsJSON
                                            );

              end;
            end;

//          end;

      except
        on E:Exception do
        begin
          ADesc:=E.Message;
          uBaseLog.HandleException(E,'SimpleCallAPI Url:'+AInterfaceUrl+' API'+API);
        end;
      end;
  end
  else
  begin
      //返回为空
      ADesc:=API+Trans('接口调用失败'+AHttpResponse+',请检查网络连接');
  end;
end;


function SignParam(
                  AUrlParamNames:TStringDynArray;
                  AUrlParamValues:TVariantDynArray;
                  ASignType:String;
                  ASignSecret:String):String;
//var
//  AStrValue:String;
//  sl:TStringList;
begin
  Result:='';
  if ASignType='' then
  begin
    Exit;
  end;

  {$IF CompilerVersion > 21.0}

  if ASignType=CONST_REST_SIGNTYPE_XFAPP then
  begin

      sl:=TStringList.Create;
      try
          sl.Values['signtype']:=CONST_REST_SIGNTYPE_XFAPP;


          //需要签名
          for I:=0 to Length(AUrlParamNames)-1 do
          begin
//              AStrValue:=AUrlParamValues[I];
              AStrValue:='';
              if not VarIsNull(AUrlParamValues[I]) then
              begin
                AStrValue:=AUrlParamValues[I];
              end;

              sl.Values[AUrlParamNames[I]]:=AStrValue;

          end;


          //GlobalRestAPISignType_AppSecret_XFApp
          Result:=LoadSignAsStringList(sl,ASignSecret);


      finally
        FreeAndNil(sl);
      end;

  end;


  if ASignType=CONST_REST_SIGNTYPE_MD5 then
  begin

      sl:=TStringList.Create;
      try
          sl.Values['signtype']:=CONST_REST_SIGNTYPE_MD5;


          //需要签名
          for I:=0 to Length(AUrlParamNames)-1 do
          begin
//              AStrValue:=AUrlParamValues[I];
              AStrValue:='';
              if not VarIsNull(AUrlParamValues[I]) then
              begin
                AStrValue:=AUrlParamValues[I];
              end;

              sl.Values[AUrlParamNames[I]]:=AStrValue;

          end;


          //GlobalRestAPISignType_AppSecret_XFApp
          Result:=LoadMD5SignAsStringList(sl,ASignSecret);


      finally
        FreeAndNil(sl);
      end;

  end;
  {$IFEND}

end;


//拼接参数到链接中
function GetUrl(API: String;
                  AInterfaceUrl:String;
                  AUrlParamNames:TStringDynArray;
                  AUrlParamValues:TVariantDynArray;
                  ASignType:String;
                  ASignSecret:String
                  ):String;
var
  I:Integer;
  AStrValue:String;
  AParamsStr:String;
  AUrlEncode:String;
  AHasSignParam:Boolean;
  AHasTimestamp:Boolean;
  AHasNonce:Boolean;
begin
      Result:='';

      AParamsStr:='';
//      for I:=0 to Length(AUrlParamNames)-1 do
//      begin
//        AStrValue:=AUrlParamValues[I];
//        if AParamsStr<>'' then
//        begin
//          AParamsStr:=AParamsStr+'&'+AUrlParamNames[I]+'='+TNetEncoding.HTML.Encode(AStrValue);
//        end
//        else
//        begin
//          AParamsStr:=AUrlParamNames[I]+'='+TNetEncoding.HTML.Encode(AStrValue);
//        end;
//      end;


      AHasSignParam:=(FindInArray('sign',AUrlParamNames)<>-1);


      //启用了调用Rest接口都自动加上签名
      {$IF CompilerVersion > 21.0}
      if GlobalRestAPICheckSignIsEnable then
      begin
          AHasTimestamp:=(FindInArray('timestamp',AUrlParamNames)<>-1);
          AHasNonce:=(FindInArray('nonce',AUrlParamNames)<>-1);


          //已经存在时间戳了就不再传了
          if not AHasTimestamp then
          begin
            AUrlParamNames:=AddStrToArray(AUrlParamNames,'timestamp');
            AUrlParamValues:=AddValueToArray(AUrlParamValues,
                                            //秒
                                            DateTimeToUnix(now,false)
                                            //timeIntervalSince1970(Now)
                                            );
          end;


          //已经存在随机数了,就不再传了
          if not AHasNonce then
          begin
            AUrlParamNames:=AddStrToArray(AUrlParamNames,'nonce');
            AUrlParamValues:=AddValueToArray(AUrlParamValues,
                                              IntToStr(//timeIntervalSince1970(Now)
                                                        DateTimeToUnix(now,false)
                                                        )+GetRandStr(5)
                                              );
          end;
      end;
      {$IFEND}


      for I:=0 to Length(AUrlParamNames)-1 do
      begin

        AStrValue:='';
        if not VarIsNull(AUrlParamValues[I]) then
        begin
          AStrValue:=AUrlParamValues[I];
        end;

        if AParamsStr<>'' then
        begin
          AParamsStr:=AParamsStr+'&'+AUrlParamNames[I]+'='+AStrValue;
        end
        else
        begin
          AParamsStr:=AUrlParamNames[I]+'='+AStrValue;
        end;

      end;




      //启用了调用Rest接口都自动加上签名
      if GlobalRestAPICheckSignIsEnable and (ASignType='') then
      begin
        ASignType:=GlobalRestAPISignType;
        ASignSecret:=GlobalRestAPIAppSecret;
      end;


      if not AHasSignParam
        //指定了签名方法,或者必须要签名
        and (ASignType<>'') then
      begin
        AParamsStr:=AParamsStr
                    +'&'+'signtype'+'='+ASignType
                    +'&'+'sign'+'='+SignParam(AUrlParamNames,
                                              AUrlParamValues,
                                              ASignType,
                                              ASignSecret);
      end;





      if AParamsStr<>'' then
      begin
//          AUrlEncode:=AInterfaceUrl+API+'?'+AParamsStr;
//          {$IF CompilerVersion > 21.0}
          AUrlEncode:=TIdURI.URLEncode(AInterfaceUrl+API+'?'+AParamsStr);
//          {$IFEND}
      end
      else
      begin
//          AUrlEncode:=AInterfaceUrl+API;
//          {$IF CompilerVersion > 21.0}
          AUrlEncode:=TIdURI.URLEncode(AInterfaceUrl+API);
//          {$IFEND}
      end;


      Result:=AUrlEncode;

end;


function SimpleGet(API: String;
                  AHttpControl:THttpControl;
                  AInterfaceUrl:String;
                  AUrlParamNames:TStringDynArray;
                  AUrlParamValues:TVariantDynArray;
                  AResponseStream: TStream;
                  ASignType:String;
                  ASignSecret:String;
                  AIsPost:Boolean;
                  APostStream:TStream): Boolean;
var
  ABefore:TDateTime;
  AIsNeedFreeAHttpControl:Boolean;

  ALogDir:String;
  ALogs:TStringList;
  ARecvStream: TStream;
  AExtractResponseStream: TStream;

  AUrlEncode:String;
begin
  ABefore:=Now;
  uBaseLog.HandleException(nil,'SimplePost'+' '+'begin'+' '+FormatDateTime('HH:MM:SS',ABefore));


  AIsNeedFreeAHttpControl:=False;
  if AHttpControl=nil then
  begin
    AIsNeedFreeAHttpControl:=True;
    AHttpControl:=TSystemHttpControl.Create;
  end;
  try

      AUrlEncode:=GetUrl(API,AInterfaceUrl,AUrlParamNames,AUrlParamValues,ASignType,ASignSecret);

      if Assigned(OnCallAPIEvent) then
      begin
        OnCallAPIEvent(AHttpControl,AUrlEncode);//AInterfaceUrl+API+'?'+AParamsStr);
      end;


//      AUrlEncode:=ReplaceStr(AUrlEncode,'+','%2B');
      //保存成临时文件,用来查日志
      {$IFDEF MSWINDOWS}
      if DirectoryExists('C:\MyFiles') or DirectoryExists('D:\MyFiles') then
      begin
        try
            ALogDir:=GetApplicationPath+'log\ServerReponse\';
            if not DirectoryExists(ALogDir) then
            begin
              SysUtils.ForceDirectories(ALogDir);
            end;

            ALogs:=TStringList.Create;
            try
              ALogs.Add(AUrlEncode);

              if Pos('://',API)>0 then
              begin
                ALogs.SaveToFile(ALogDir
                                //+ReplaceStr(API,'/','_')+' '
                                +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.txt');

              end
              else
              begin

                ALogs.SaveToFile(ALogDir
                                +ReplaceStr(API,'/','_')+' '
                                +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.txt');
              end;


            finally
              FreeAndNil(ALogs);
            end;
        except

        end;
      end;
      {$ENDIF}


      uBaseLog.OutputDebugString('SimpleGet '+AUrlEncode);


      ARecvStream:=AResponseStream;
      if (Pos('compressed=1',AUrlEncode)>0) then
      begin
        AExtractResponseStream:=TMemoryStream.Create;
        ARecvStream:=AExtractResponseStream;
      end;
      try

          if not AIsPost then
          begin
            Result:=AHttpControl.Get(
                                    AUrlEncode,
                                    ARecvStream);
          end
          else
          begin
            Result:=AHttpControl.Post(
                                    AUrlEncode,//TIdURI.URLEncode(AInterfaceUrl+API+'?'+AParamsStr),
                                    APostStream,
                                    ARecvStream);
          end;


      finally
        if (Pos('compressed=1',AUrlEncode)>0) then
        begin

          if Result then
          begin
            try
              //解压
              ZLib.ZDecompressStream(AExtractResponseStream,AResponseStream);
            except
              //解压失败,可能是未压缩过的
              AExtractResponseStream.Position:=0;
              AResponseStream.Position:=0;
              AResponseStream.CopyFrom(AExtractResponseStream,AExtractResponseStream.Size);
            end;
          end;


          FreeAndNil(AExtractResponseStream);
        end;
      end;



  finally
    if AIsNeedFreeAHttpControl then
    begin
      SysUtils.FreeAndNil(AHttpControl);
    end;
  end;

  uBaseLog.HandleException(nil,'SimpleGet'+' '+AInterfaceUrl+API+' '+'end'+' '+'耗时'+IntToStr(DateUtils.MilliSecondsBetween(ABefore,Now)));

end;

function JsonSimplePost(API: String;
                  AHttpControl:THttpControl;
                  AInterfaceUrl:String;
                  AParamJsonArray:ISuperArray;
//                  AJsonParamNames:TStringDynArray;
//                  AJsonParamValues:TVariantDynArray;
                  AResponseStream: TStream): Boolean;
var
  ABefore:TDateTime;
  ARequestStream:TStringStream;
begin
    ABefore:=Now;
//    FMX.Types.Log.d('SimplePost'+' '+'begin'+' '+FormatDateTime('HH:MM:SS',ABefore));


    if Assigned(OnCallAPIEvent) then
    begin
      OnCallAPIEvent(AHttpControl,AInterfaceUrl+API);
    end;



    ARequestStream:=TStringStream.Create('',TEncoding.UTF8);
    try
        ARequestStream.WriteString(AParamJsonArray.AsJSON);
        ARequestStream.Position:=0;

        Result:=AHttpControl.Post(
                                TIdURI.URLEncode(AInterfaceUrl+API),
                                ARequestStream,
                                AResponseStream);
    finally
      FreeAndNil(ARequestStream);
    end;


//    uBaseLog.OutputDebugString('SimpleGet'+' '+AInterfaceUrl+API+' '+'end'+' '+'耗时'+IntToStr(DateUtils.MilliSecondsBetween(ABefore,Now)));

end;


{ TNStringList }
function TNStringList.CompareStrings(const S1, S2: string): Integer;
  begin
    if CaseSensitive then
      Result := CompareStr(S1, S2)
    else
      Result := CompareText(S1, S2);
  end;


Function smyHextoStr(s:string):string;
  var
    hexS,tmpstr:string;
    i:integer;
    a:byte;
  begin
    hexS:=s;    //应该是该字符串
    if length(hexS) mod 2=1 then
    begin
        hexS:=hexS+'0';
    end;
    tmpstr:='';
    for i:=1 to (length(hexS) div 2) do
    begin
        a:=strtoint('$'+hexS[2*i-1+ENCRYPT_STRING_BASE_OFFSET]+hexS[2*i+ENCRYPT_STRING_BASE_OFFSET]);
        tmpstr := tmpstr+chr(a);
    end;
    result :=tmpstr;
  end;

Function myHextoStr(s:string):string;
  var
    hexS,tmpstr:string;
    i:integer;
    a:byte;
  begin
    hexS:=s;    //应该是该字符串
    if length(hexS) mod 2=1 then
    begin
        hexS:=hexS+'0';
    end;
    tmpstr:='';
    for i:=1 to (length(hexS) div 2) do
    begin
        a:=strtoint('$'+hexS[2*i-1+ENCRYPT_STRING_BASE_OFFSET]+hexS[2*i+ENCRYPT_STRING_BASE_OFFSET]);
        tmpstr := tmpstr+chr(a);
    end;
    result :=tmpstr;
  end;

function encryptstr(const s:string; skey:string):string;        //加密
  var
    i,j: integer;
    hexS,hexskey,midS,tmpstr:string;
    a,b,c:byte;

  begin
    hexS   :=myStrtoHex(s);
    hexskey:=myStrtoHex(skey);
    midS   :=hexS;
    for i:=1 to (length(hexskey) div 2)   do
    begin
        if i<>1 then midS:= tmpstr;
        tmpstr:='';
        for j:=1 to (length(midS) div 2) do
        begin
            a:=strtoint('$'+midS[2*j-1+ENCRYPT_STRING_BASE_OFFSET]+midS[2*j+ENCRYPT_STRING_BASE_OFFSET]);
            b:=strtoint('$'+hexskey[2*i-1+ENCRYPT_STRING_BASE_OFFSET]+hexskey[2*i+ENCRYPT_STRING_BASE_OFFSET]);
            c:=a xor b;
            tmpstr := tmpstr+myStrtoHex(chr(c));
        end;
    end;
    result := tmpstr;
  end;

function decryptstr(const s:string; skey:string):string;        //解密
  var
    i,j: integer;
    hexS,hexskey,midS,tmpstr:string;
    a,b,c:byte;
  begin
    try
      hexS  :=s;//应该是该字符串
      if length(hexS) mod 2=1 then begin
        //  showmessage('密文错误！');
        exit;
      end;

      hexskey:=myStrtoHex(skey);
      tmpstr :=hexS;
      midS   :=hexS;
      for i:=(length(hexskey) div 2) downto 1 do begin
          if i<>(length(hexskey) div 2) then midS:= tmpstr;
          tmpstr:='';
          for j:=1 to (length(midS) div 2) do
          begin
              a:=strtoint('$'+midS[2*j-1+ENCRYPT_STRING_BASE_OFFSET]+midS[2*j+ENCRYPT_STRING_BASE_OFFSET]);
              b:=strtoint('$'+hexskey[2*i-1+ENCRYPT_STRING_BASE_OFFSET]+hexskey[2*i+ENCRYPT_STRING_BASE_OFFSET]);
              c:=a xor b;
              tmpstr := tmpstr+myStrtoHex(chr(c));
          end;
      end;
      result := myHextoStr(tmpstr);
    except
      Result := '';
    end;
  end;

Function myStrtoHex(s: string): string;
  var
    tmpstr:string;
    i:integer;
  begin
    tmpstr := '';
    for i:=1 to length(s) do
    begin
        tmpstr := tmpstr + inttoHex(ord(s[i+ENCRYPT_STRING_BASE_OFFSET]),2);
    end;
    result := tmpstr;
  end;

//function encryptstr(const s:string):string;     //加密字符串
//  begin
//    Result := encryptstr(s, Encry_password);
//  end;
//
//function decryptstr(const s:string):string;
//  begin
//    Result := decryptstr(s, Encry_password);
//  end;

{$IF CompilerVersion > 21.0}
function LoadSignAsStringList(sl:TStringList; skey:string):string;   //获取sign签名
  var
    i     : Integer;
    sText : string;
    md5   : THashMD5;
    sl1   : TNStringList;
  begin
    Result := '';
    if sl = nil then Exit;

    sl1 :=  TNStringList.Create;

    for i := 0 to sl.Count -1  do begin
      sl1.Values[sl.Names[i]] :=  sl.ValueFromIndex[i];
    end;

    sl1.Sort;
    for i := 0 to sl1.Count - 1 do begin
      if i > 0 then  sText := sText + '&';
      sText := sText + sl1.Names[i] + '=' + sl1.ValueFromIndex[i] ;
    end;

    sText := md5.GetHashString(sText);
    Result := encryptstr(sText,skey);

    sl1.Free;
  end;

function LoadMD5SignAsStringList(sl:TStringList; skey:string):string;   //获取sign签名
  var
    i     : Integer;
    sText : string;
    md5   : THashMD5;
    sl1   : TNStringList;
  begin
    Result := '';
    if sl = nil then Exit;

    sl1 :=  TNStringList.Create;

    for i := 0 to sl.Count -1  do begin
      sl1.Values[sl.Names[i]] :=  sl.ValueFromIndex[i];
    end;

    sl1.Sort;
    for i := 0 to sl1.Count - 1 do begin
      if i > 0 then  sText := sText + '&';
      sText := sText + sl1.Names[i] + '=' + sl1.ValueFromIndex[i] ;
    end;

    sText := md5.GetHashString(sText+skey);
    Result := sText;//encryptstr(sText,skey);

    sl1.Free;
  end;
{$IFEND}


//function SimpleCallAPIByTimerTask(API: String;
//                                  AInterfaceUrl:String;
//                                  AUrlParamNames:TStringDynArray;
//                                  AUrlParamValues:TVariantDynArray;
//                                  AOnExecuteEnd:TTimerTaskNotify;
//                                  AOnExecuteEndCallback:TTimerTaskNotifyCallback): String;
//var
//  I:Integer;
//  ACallAPITaskItem:TCallAPITaskItem;
//begin
//  ACallAPITaskItem:=TCallAPITaskItem.Create;
//  ACallAPITaskItem.API:=API;
//  ACallAPITaskItem.InterfaceUrl:=AInterfaceUrl;
//  ACallAPITaskItem.OnExecuteEnd:=AOnExecuteEnd;
//  ACallAPITaskItem.OnExecuteEndCallback:=AOnExecuteEndCallback;
//
//  //复制参数名数组
//  SetLength(ACallAPITaskItem.UrlParamNames,Length(AUrlParamNames));
//  for I := 0 to Length(AUrlParamNames)-1 do
//  begin
//    ACallAPITaskItem.UrlParamNames[I]:=AUrlParamNames[I];
//  end;
//
//  //复制参数值数组
//  SetLength(ACallAPITaskItem.UrlParamValues,Length(AUrlParamValues));
//  for I := 0 to Length(AUrlParamValues)-1 do
//  begin
//    ACallAPITaskItem.UrlParamValues[I]:=AUrlParamValues[I];
//  end;
//
//
//  GetGlobalTimerThread.RunTempTask(
//      ACallAPITaskItem.DoTaskExecute,
//      ACallAPITaskItem.DoTaskExecuteEnd,
//      'SimpleCallAPIByTimerTask'
//      );
//  GlobalCallAPITaskList.Add(ACallAPITaskItem);
//
//end;
//
//
//{ TCallAPITaskItem }
//
//procedure TCallAPITaskItem.DoTaskExecute(ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=0;
//  try
//
//    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI(Self.API,
//                                          nil,
//                                          Self.InterfaceUrl,
//                                          Self.UrlParamNames,
//                                          Self.UrlParamValues
//                                          );
//
//    if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      TTimerTask(ATimerTask).TaskTag:=0;
//    end;
//
//  except
//    on E:Exception do
//    begin
//      //异常
//      TTimerTask(ATimerTask).TaskDesc:=E.Message;
//    end;
//  end;
//end;
//
//procedure TCallAPITaskItem.DoTaskExecuteEnd(ATimerTask: TObject);
//begin
//  if Assigned(Self.OnExecuteEnd) then
//  begin
//    OnExecuteEnd(TTimerTask(ATimerTask));
//  end;
//  if Assigned(Self.OnExecuteEndCallback) then
//  begin
//    OnExecuteEndCallback(TTimerTask(ATimerTask));
//  end;
//end;
//
//
//
//
//initialization
//  GlobalCallAPITaskList:=TBaseList.Create;
//
//finalization
//  FreeAndNil(GlobalCallAPITaskList);


initialization

end.








