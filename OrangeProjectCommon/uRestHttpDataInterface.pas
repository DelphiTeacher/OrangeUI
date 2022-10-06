unit uRestHttpDataInterface;

interface


uses
  Classes,
  uFuncCommon,
  uOpenClientCommon,


  {$IF CompilerVersion <= 21.0} // D2010之前
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

  uRestInterfaceCall,
  uDataInterface;

type


  //通用接口框架的Rest接口
  TTableCommonRestHttpDataInterface=class(TDataInterface)
  public
    FInterfaceUrl:String;
    //是否使用默认的uOpenClientCommon中的InterfaceUrl
    FIsUseDefaultInterfaceUrl:Boolean;
    function GetInterfaceUrl:String;

    //从json中加载
    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;

    //获取字段列表
    function GetFieldList(AAppID:String;
                          var ADesc:String;
                          var ADataJson:ISuperObject
                           ):Boolean;override;
    //获取记录列表
    function GetDataList(
                           ALoadDataSetting:TLoadDataSetting;
                           ADataIntfResult:TDataIntfResult
                           ):Boolean;override;
    //获取记录
    function GetDataDetail(
                       ALoadDataSetting:TLoadDataSetting;
                       ADataIntfResult:TDataIntfResult
                       ):Boolean;override;
    //保存记录
    function SaveData(ASaveDataSetting:TSaveDataSetting;
                      ADataIntfResult:TDataIntfResult):Boolean;override;

    //保存记录列表
    function AddDataList(ASaveDataSetting:TSaveDataSetting;
                      ARecordList:ISuperArray;
                      ADataIntfResult:TDataIntfResult):Boolean;override;


    //删除记录,删除ALoadDataIntfResult这条获取的记录
    function DelData(ALoadDataSetting: TLoadDataSetting;
                      ALoadDataIntfResult:TDataIntfResult;
                      ADataIntfResult:TDataIntfResult):Boolean;override;
//  public
//    constructor Create;virtual;
  end;





  //Http的Rest接口
  TRestHttpDataInterface=class(TDataInterface)
  public

    //比如http://www.orangeui.cn:10000/usercenter/
    InterfaceUrl:String;

    //从json中加载
    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;

    //参数Json数组的格式,[{参数1},{},{},{}]
    {name,value}
    //比如appid,user_fid,key,........
//    FLoadParams:ISuperArray;

    //获取记录列表
    function GetDataList(
                         ALoadDataSetting:TLoadDataSetting;
                         ADataIntfResult:TDataIntfResult
                         ):Boolean;override;
    //获取记录
    function GetDataDetail(
                       ALoadDataSetting:TLoadDataSetting;
                       ADataIntfResult:TDataIntfResult
                       ):Boolean;override;
    //保存记录
    function SaveData(ASaveDataSetting:TSaveDataSetting;
                      ADataIntfResult:TDataIntfResult):Boolean;override;
    //保存记录列表
    function AddDataList(ASaveDataSetting:TSaveDataSetting;
                      ARecordList:ISuperArray;
                      ADataIntfResult:TDataIntfResult):Boolean;override;
    //删除记录,删除ALoadDataIntfResult这条获取的记录
    function DelData(ALoadDataSetting: TLoadDataSetting;ALoadDataIntfResult:TDataIntfResult;
                      ADataIntfResult:TDataIntfResult):Boolean;override;
  end;







implementation



{ TTableCommonRestHttpDataInterface }

function TTableCommonRestHttpDataInterface.CustomLoadFromJson(
  ASuperObject: ISuperObject): Boolean;
begin
  FIsUseDefaultInterfaceUrl:=ASuperObject.B['is_use_default_interface_url'];
  FInterfaceUrl:=ASuperObject.S['interface_url'];
end;

function TTableCommonRestHttpDataInterface.DelData(
  ALoadDataSetting: TLoadDataSetting;
//  ADelDataSetting:TDelDataSetting;
//  ALoadDataSetting:TLoadDataSetting;
  ALoadDataIntfResult:TDataIntfResult;
  ADataIntfResult: TDataIntfResult): Boolean;
var
  ACode:Integer;
  AWhereKeyJson:String;
begin
  Result:=False;


  //生成删除记录的条件
  AWhereKeyJson:=GetWhereConditions(['appid','fid'],
                                    [ALoadDataSetting.AppID,ALoadDataIntfResult.DataJson.I['fid']]);

  if not SimpleCallAPI('del_record',
                      nil,
                      GetInterfaceUrl+'tablecommonrest/',
                      ['appid',
                      'user_fid',
                      'key',
                      'rest_name',
                      'where_key_json'
                      ],
                      [ALoadDataSetting.AppID,
                      '',
                      '',
                      Name,
                      AWhereKeyJson
      //                GetWhereConditions(['appid','user_fid','shield_user_fid'],
      //                                    [AppID,GlobalManager.User.fid,FUserFID])
                      ],
                      ACode,
                      ADataIntfResult.Desc,
                      ADataIntfResult.DataJson,
                      GlobalRestAPISignType,
                      GlobalRestAPIAppSecret) then
  begin
    Exit;
  end;


  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
  ADataIntfResult.Succ:=(ACode=SUCC);
  Result:=True;

end;

function TTableCommonRestHttpDataInterface.GetDataDetail(
  ALoadDataSetting: TLoadDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
var
  ACode:Integer;
begin
  Result:=False;
  //加载程序模板的所有功能和页面
  if not SimpleCallAPI(
                      'get_record',
                      nil,
                      GetInterfaceUrl+'tablecommonrest/',
                      ConvertToStringDynArray(['appid',
                                              'user_fid',
                                              'key',

                                              'rest_name',
                                              'where_key_json'
                                              ]),
                      ConvertToVariantDynArray([
                                                ALoadDataSetting.AppID,
                          //                      GlobalMainProgramSetting.AppID,
                                                '',
                                                '',
                                                Name,
                                                ALoadDataSetting.WhereKeyJson
                                                ]),
                      ACode,
                      ADataIntfResult.Desc,
                      ADataIntfResult.DataJson,
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret) then
  begin
    Exit;
  end;


  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
  ADataIntfResult.Succ:=(ACode=SUCC);
  Result:=True;

end;

function TTableCommonRestHttpDataInterface.GetDataList(
  ALoadDataSetting: TLoadDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
var
  ACode:Integer;
begin
  Result:=False;
  //加载程序模板的所有功能和页面
  if not SimpleCallAPI(
                      'get_record_list',
                      nil,
                      GetInterfaceUrl+'tablecommonrest/',
                      ConvertToStringDynArray(['appid',
                                            'user_fid',
                                            'key',
                                            'rest_name',
                                            'pageindex',
                                            'pagesize',
                                            'where_key_json',
                                            'order_by',
                                            'where_sql'
                                            ]),
                      ConvertToVariantDynArray([
                                              ALoadDataSetting.AppID,
                        //                      GlobalMainProgramSetting.AppID,
                                              '',
                                              '',
                                              Name,
                                              ALoadDataSetting.PageIndex,
                                              ALoadDataSetting.PageSize,
                                              ALoadDataSetting.WhereKeyJson,
                                              ALoadDataSetting.OrderBy,
                                              ALoadDataSetting.CustomWhereSQL
                                              ]),
                      ACode,
                      ADataIntfResult.Desc,
                      ADataIntfResult.DataJson,
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret) then
  begin
    Exit;
  end;

  //保存到本地测试



  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
  ADataIntfResult.Succ:=(ACode=SUCC);
  Result:=True;
end;

function TTableCommonRestHttpDataInterface.GetFieldList(AAppID:String;var ADesc: String; var ADataJson: ISuperObject): Boolean;
var
  ACode:Integer;
begin
  Result:=False;
  //加载程序模板的所有功能和页面
  if not SimpleCallAPI(
                      'get_field_list',
                      nil,
                      GetInterfaceUrl+'tablecommonrest/',
                      ConvertToStringDynArray(['appid',
                                            'user_fid',
                                            'key',
                                            'rest_name'
                                            ]),
                      ConvertToVariantDynArray([
                                              AppID,
                        //                      GlobalMainProgramSetting.AppID,
                                              '',
                                              '',
                                              Name
                                              ]),
                      ACode,
                      ADesc,
                      ADataJson,
                      GlobalRestAPISignType,
                      GlobalRestAPIAppSecret) or (ACode<>SUCC) then
  begin
    Exit;
  end;

  Result:=True;

end;

function TTableCommonRestHttpDataInterface.GetInterfaceUrl: String;
begin
  if FIsUseDefaultInterfaceUrl then
  begin
    Result:=uOpenClientCommon.InterfaceUrl;
  end
  else
  begin
    Result:=Self.FInterfaceUrl;
  end;
end;

function TTableCommonRestHttpDataInterface.SaveData(ASaveDataSetting: TSaveDataSetting;ADataIntfResult:TDataIntfResult): Boolean;
begin
  Result:=False;

  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;

          //将接口保存到数据库
          if SaveRecordToServer(GetInterfaceUrl,//GlobalMainProgramSetting.DataIntfServerUrl,//Self.InterfaceUrl,//
                                ASaveDataSetting.AppID,
                                '',
                                '',
                                Self.Name,
                                ASaveDataSetting.EditingRecordKeyValue,//Self.FDataIntfResult.DataJson.I['fid'],
                                ASaveDataSetting.RecordDataJson,
                                ASaveDataSetting.IsAddedRecord,
                                ADataIntfResult.Desc,
                                ADataIntfResult.DataJson,
                                GlobalRestAPISignType,
                                GlobalRestAPIAppSecret,
                                FHasAppID,
                                Self.FKeyFieldName,
                                ASaveDataSetting.CustomWhereSQL,
                                ASaveDataSetting.CustomWhereKeyJson) then
          begin
            ADataIntfResult.Succ:=True;//(ACode=SUCC);
//              //保存成功,要取出新增记录的fid
//              if AIsAdd then
//              begin
//                FPage.DataInterface.fid:=ADataJson.I['fid'];
//              end;
//              TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
            Result:=True;
          end
          else
          begin
        //      ShowMessage(ADesc);
            Exit;
          end;

end;



function TTableCommonRestHttpDataInterface.AddDataList(
  ASaveDataSetting: TSaveDataSetting;
  ARecordList: ISuperArray;
  ADataIntfResult: TDataIntfResult): Boolean;
var
  ACode:Integer;
begin
  Result:=False;

  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;


  //不存在fid,表示要新增该记录
  if not SimpleCallAPI('add_record_list_post_2',
                          nil,
                          GetInterfaceUrl+'tablecommonrest/',
                          ConvertToStringDynArray(
                                                  ['appid',
                                                  'user_fid',
                                                  'key',
                                                  'rest_name'
                                                  ]),
                          ConvertToVariantDynArray([ASaveDataSetting.AppID,
                                                    '',
                                                    '',
                                                    Self.Name
                                                    ]),
                          ACode,
                          ADataIntfResult.Desc,
                          ADataIntfResult.DataJson,
                          GlobalRestAPISignType,
                          GlobalRestAPIAppSecret,
                          True,
                          nil,
                          ARecordList.AsJson
                          ) or (ACode<>SUCC) then
  begin
    //uBaseLog.HandleException(nil,'SaveRecordToServer '+ADesc);
    Exit;
  end;

  ADataIntfResult.Succ:=True;
  Result:=True;

end;

{ TRestHttpDataInterface }

function TRestHttpDataInterface.AddDataList(ASaveDataSetting: TSaveDataSetting;
  ARecordList: ISuperArray; ADataIntfResult: TDataIntfResult): Boolean;
begin

end;

function TRestHttpDataInterface.CustomLoadFromJson(
  ASuperObject: ISuperObject): Boolean;
begin
  InterfaceUrl:=ASuperObject.S['interface_url'];

end;

function TRestHttpDataInterface.DelData(ALoadDataSetting: TLoadDataSetting;ALoadDataIntfResult,
  ADataIntfResult: TDataIntfResult): Boolean;
begin

end;

function TRestHttpDataInterface.GetDataDetail(
  ALoadDataSetting: TLoadDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
begin

end;

//procedure GetParamsArray(AParams:ISuperArray;var ALoadDataParamNames:TStringDynArray;var ALoadDataParamValues:TVariantDynArray);
//begin
//  //设置参数的长度
//  SetLength(ALoadDataParamNames,AParams.Length);
//  SetLength(ALoadDataParamValues,AParams.Length);
//
//
//  //{name:appid,value:1012,....}
//  for I := 0 to AParams.Length-1 do
//  begin
//    ALoadDataParamNames[I]:=AParams.O[I].S['name'];
//    ALoadDataParamValues[I]:=AParams.O[I].S['value'];
//  end;
//
//
//
//end;


function TRestHttpDataInterface.GetDataList(ALoadDataSetting: TLoadDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
var
  ACode:Integer;
//  //加载参数名和参数值
//  ALoadDataParamNames:TStringDynArray;
//  ALoadDataParamValues:TVariantDynArray;
//  I: Integer;
begin
  Result:=False;


//  GetParamsArray(FLoadParams,ALoadDataParamNames,ALoadDataParamValues);

  //加载程序模板的所有功能和页面
  if not SimpleCallAPI(
                      Name,
                      nil,
                      InterfaceUrl+ALoadDataSetting.InterfaceName,
//                      ['appid',
//                      'user_fid',
//                      'key',
//                      'rest_name',
//                      'pageindex',
//                      'pagesize',
//                      'where_key_json',
//                      'order_by'
//                      ],
                      ALoadDataSetting.ParamNames,
//                      [
////                      ALoadDataSetting.AppID,
//                      GlobalMainProgramSetting.AppID,
//                      0,
//                      '',
//                      Name,
//                      ALoadDataSetting.PageIndex,
//                      ALoadDataSetting.PageSize,
//                      ALoadDataSetting.WhereKeyJson,
//                      ''//ALoadDataSetting.OrderBy
//                      ],
                      ALoadDataSetting.ParamValues,

                      ACode,
                      ADataIntfResult.Desc,
                      ADataIntfResult.DataJson,

                      GlobalRestAPISignType,
                      GlobalRestAPIAppSecret) then
  begin
    Exit;
  end;

  //保存到本地测试



  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
  ADataIntfResult.Succ:=(ACode=SUCC);
  Result:=True;
end;

function TRestHttpDataInterface.SaveData(ASaveDataSetting: TSaveDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
begin

end;

initialization
  GlobalDataInterfaceClassRegList.Add('TableCommonRestHttp',TTableCommonRestHttpDataInterface);
  GlobalDataInterfaceClassRegList.Add('RestHttp',TRestHttpDataInterface);



end.
