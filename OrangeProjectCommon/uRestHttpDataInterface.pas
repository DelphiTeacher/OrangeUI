unit uRestHttpDataInterface;

interface


uses
  Classes,
  uFuncCommon,


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
    //获取字段列表
    function GetFieldList(AppID:Integer;
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

//    //删除记录,删除ALoadDataIntfResult这条获取的记录
//    function DelData(ALoadDataIntfResult:TDataIntfResult;
//                      ADataIntfResult:TDataIntfResult):Boolean;override;
  end;





  //Http的Rest接口
  TRestHttpDataInterface=class(TDataInterface)
  public
    //比如http://www.orangeui.cn:10000/usercenter/
    InterfaceUrl:String;
    //比如appid,user_fid,key,........
    Params:String;

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
//    //删除记录,删除ALoadDataIntfResult这条获取的记录
//    function DelData(ALoadDataIntfResult:TDataIntfResult;
//                      ADataIntfResult:TDataIntfResult):Boolean;override;
  end;







implementation



{ TTableCommonRestHttpDataInterface }

//function TTableCommonRestHttpDataInterface.DelData(
////  ADelDataSetting:TDelDataSetting;
////  ALoadDataSetting:TLoadDataSetting;
//  ALoadDataIntfResult:TDataIntfResult;
//  ADataIntfResult: TDataIntfResult): Boolean;
//var
//  ACode:Integer;
//  AWhereKeyJson:String;
//begin
//  Result:=False;
//
//
//  //生成删除记录的条件
//  AWhereKeyJson:=GetWhereConditions(['appid','fid'],
//                                    [AppID,ALoadDataIntfResult.DataJson.I['fid']]);
//
//  if not SimpleCallAPI('del_record',
//                      nil,
//                      FInterfaceUrl,
//                      ['appid',
//                      'user_fid',
//                      'key',
//                      'rest_name',
//                      'where_key_json'
//                      ],
//                      [GlobalMainProgramSetting.AppID,
//                      '',
//                      '',
//                      Name,
//                      AWhereKeyJson
//      //                GetWhereConditions(['appid','user_fid','shield_user_fid'],
//      //                                    [AppID,GlobalManager.User.fid,FUserFID])
//                      ],
//                      ACode,
//                      ADataIntfResult.Desc,
//                      ADataIntfResult.DataJson,
//                      GlobalRestAPISignType,
//                      GlobalRestAPIAppSecret) then
//  begin
//    Exit;
//  end;
//
//
//  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
//  ADataIntfResult.Succ:=(ACode=SUCC);
//  Result:=True;
//
//end;

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
                      FInterfaceUrl+'tablecommonrest/',
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
                      FInterfaceUrl+'tablecommonrest/',
                      ConvertToStringDynArray(['appid',
                                            'user_fid',
                                            'key',
                                            'rest_name',
                                            'pageindex',
                                            'pagesize',
                                            'where_key_json',
                                            'order_by'
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
                                              ''//ALoadDataSetting.OrderBy
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

function TTableCommonRestHttpDataInterface.GetFieldList(AppID:Integer;var ADesc: String; var ADataJson: ISuperObject): Boolean;
var
  ACode:Integer;
begin
  Result:=False;
  //加载程序模板的所有功能和页面
  if not SimpleCallAPI(
                      'get_field_list',
                      nil,
                      FInterfaceUrl+'tablecommonrest/',
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

function TTableCommonRestHttpDataInterface.SaveData(ASaveDataSetting: TSaveDataSetting;ADataIntfResult:TDataIntfResult): Boolean;
begin
  Result:=False;

  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;

          //将接口保存到数据库
          if SaveRecordToServer(FInterfaceUrl,//GlobalMainProgramSetting.DataIntfServerUrl,//Self.InterfaceUrl,//
                                ASaveDataSetting.AppID,
                                '',
                                '',
                                Self.Name,
                                ASaveDataSetting.EditingRecordFID,//Self.FDataIntfResult.DataJson.I['fid'],
                                ASaveDataSetting.RecordDataJson,
                                ASaveDataSetting.IsAddedRecord,
                                ADataIntfResult.Desc,
                                ADataIntfResult.DataJson,
                                GlobalRestAPISignType,
                                GlobalRestAPIAppSecret,
                                FHasAppID) then
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



{ TRestHttpDataInterface }

//function TRestHttpDataInterface.DelData(ALoadDataIntfResult,
//  ADataIntfResult: TDataIntfResult): Boolean;
//begin
//
//end;

function TRestHttpDataInterface.GetDataDetail(
  ALoadDataSetting: TLoadDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
begin

end;

function TRestHttpDataInterface.GetDataList(ALoadDataSetting: TLoadDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
var
  ACode:Integer;
begin
  Result:=False;
  //加载程序模板的所有功能和页面
  if not SimpleCallAPI(
                      Name,
                      nil,
                      Self.InterfaceUrl,
//                      ['appid',
//                      'user_fid',
//                      'key',
//                      'rest_name',
//                      'pageindex',
//                      'pagesize',
//                      'where_key_json',
//                      'order_by'
//                      ],
                      ALoadDataSetting.LoadDataParamNames,
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
                      ALoadDataSetting.LoadDataParamValues,

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




end.
