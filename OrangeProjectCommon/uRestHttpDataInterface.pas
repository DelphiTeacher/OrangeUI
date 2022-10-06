unit uRestHttpDataInterface;

interface


uses
  Classes,
  uFuncCommon,
  uOpenClientCommon,


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
    //�Ƿ�ʹ��Ĭ�ϵ�uOpenClientCommon�е�InterfaceUrl
    FIsUseDefaultInterfaceUrl:Boolean;
    function GetInterfaceUrl:String;

    //��json�м���
    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;

    //��ȡ�ֶ��б�
    function GetFieldList(AAppID:String;
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

    //�����¼�б�
    function AddDataList(ASaveDataSetting:TSaveDataSetting;
                      ARecordList:ISuperArray;
                      ADataIntfResult:TDataIntfResult):Boolean;override;


    //ɾ����¼,ɾ��ALoadDataIntfResult������ȡ�ļ�¼
    function DelData(ALoadDataSetting: TLoadDataSetting;
                      ALoadDataIntfResult:TDataIntfResult;
                      ADataIntfResult:TDataIntfResult):Boolean;override;
//  public
//    constructor Create;virtual;
  end;





  //Http��Rest�ӿ�
  TRestHttpDataInterface=class(TDataInterface)
  public

    //����http://www.orangeui.cn:10000/usercenter/
    InterfaceUrl:String;

    //��json�м���
    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;

    //����Json����ĸ�ʽ,[{����1},{},{},{}]
    {name,value}
    //����appid,user_fid,key,........
//    FLoadParams:ISuperArray;

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
    //�����¼�б�
    function AddDataList(ASaveDataSetting:TSaveDataSetting;
                      ARecordList:ISuperArray;
                      ADataIntfResult:TDataIntfResult):Boolean;override;
    //ɾ����¼,ɾ��ALoadDataIntfResult������ȡ�ļ�¼
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


  //����ɾ����¼������
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
  //���س���ģ������й��ܺ�ҳ��
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
  //���س���ģ������й��ܺ�ҳ��
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

  //���浽���ز���



  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;
  ADataIntfResult.Succ:=(ACode=SUCC);
  Result:=True;
end;

function TTableCommonRestHttpDataInterface.GetFieldList(AAppID:String;var ADesc: String; var ADataJson: ISuperObject): Boolean;
var
  ACode:Integer;
begin
  Result:=False;
  //���س���ģ������й��ܺ�ҳ��
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

          //���ӿڱ��浽���ݿ�
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



function TTableCommonRestHttpDataInterface.AddDataList(
  ASaveDataSetting: TSaveDataSetting;
  ARecordList: ISuperArray;
  ADataIntfResult: TDataIntfResult): Boolean;
var
  ACode:Integer;
begin
  Result:=False;

  ADataIntfResult.DataType:=TDataIntfResultType.ldtJson;


  //������fid,��ʾҪ�����ü�¼
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
//  //���ò����ĳ���
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
//  //���ز������Ͳ���ֵ
//  ALoadDataParamNames:TStringDynArray;
//  ALoadDataParamValues:TVariantDynArray;
//  I: Integer;
begin
  Result:=False;


//  GetParamsArray(FLoadParams,ALoadDataParamNames,ALoadDataParamValues);

  //���س���ģ������й��ܺ�ҳ��
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

  //���浽���ز���



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
