unit uRestHttpDataInterface;

interface


uses
  Classes,
  uFuncCommon,


  {$IF CompilerVersion <= 21.0} // D2010֮ǰ
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


  //ͨ�ýӿڿ�ܵ�Rest�ӿ�
  TTableCommonRestHttpDataInterface=class(TDataInterface)
  public
    FInterfaceUrl:String;
    //��ȡ�ֶ��б�
    function GetFieldList(AppID:Integer;
                          var ADesc:String;
                          var ADataJson:ISuperObject
                           ):Boolean;override;
    //��ȡ��¼�б�
    function GetDataList(
                           ALoadDataSetting:TLoadDataSetting;
                           ADataIntfResult:TDataIntfResult
                           ):Boolean;override;
    //��ȡ��¼
    function GetDataDetail(
                       ALoadDataSetting:TLoadDataSetting;
                       ADataIntfResult:TDataIntfResult
                       ):Boolean;override;
    //�����¼
    function SaveData(ASaveDataSetting:TSaveDataSetting;
                      ADataIntfResult:TDataIntfResult):Boolean;override;

//    //ɾ����¼,ɾ��ALoadDataIntfResult������ȡ�ļ�¼
//    function DelData(ALoadDataIntfResult:TDataIntfResult;
//                      ADataIntfResult:TDataIntfResult):Boolean;override;
  end;





  //Http��Rest�ӿ�
  TRestHttpDataInterface=class(TDataInterface)
  public
    //����http://www.orangeui.cn:10000/usercenter/
    InterfaceUrl:String;
    //����appid,user_fid,key,........
    Params:String;

    //��ȡ��¼�б�
    function GetDataList(
                         ALoadDataSetting:TLoadDataSetting;
                         ADataIntfResult:TDataIntfResult
                         ):Boolean;override;
    //��ȡ��¼
    function GetDataDetail(
                       ALoadDataSetting:TLoadDataSetting;
                       ADataIntfResult:TDataIntfResult
                       ):Boolean;override;
    //�����¼
    function SaveData(ASaveDataSetting:TSaveDataSetting;
                      ADataIntfResult:TDataIntfResult):Boolean;override;
//    //ɾ����¼,ɾ��ALoadDataIntfResult������ȡ�ļ�¼
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
//  //����ɾ����¼������
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
  //���س���ģ������й��ܺ�ҳ��
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
  //���س���ģ������й��ܺ�ҳ��
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

  //���浽���ز���



  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
  ADataIntfResult.Succ:=(ACode=SUCC);
  Result:=True;
end;

function TTableCommonRestHttpDataInterface.GetFieldList(AppID:Integer;var ADesc: String; var ADataJson: ISuperObject): Boolean;
var
  ACode:Integer;
begin
  Result:=False;
  //���س���ģ������й��ܺ�ҳ��
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

          //���ӿڱ��浽���ݿ�
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
//              //����ɹ�,Ҫȡ��������¼��fid
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
  //���س���ģ������й��ܺ�ҳ��
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

  //���浽���ز���



  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
  ADataIntfResult.Succ:=(ACode=SUCC);
  Result:=True;
end;

function TRestHttpDataInterface.SaveData(ASaveDataSetting: TSaveDataSetting;
  ADataIntfResult: TDataIntfResult): Boolean;
begin

end;




end.
