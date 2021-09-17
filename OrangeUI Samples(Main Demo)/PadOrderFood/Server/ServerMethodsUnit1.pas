unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,


  Windows,
  Math,
  Forms,

  uConfig,
  XSuperObject,
  XSuperJson,

  uBaseDBHelper,
  uADODBHelper,
  uADODBHelperPool,
  Variants,

  IniFiles,

//  uTaoBaoManager,
//  uTaoBaoPublic,
//  uTaoBaoAPI,
//  uTaoBaoAuth,


  Data.DBXCommon,
  Data.DBXMSSQL,
  Data.DB, Data.SqlExpr, Data.FMTBcd;






Const
  SUCC=200;
  FAIL=400;

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
    //����°汾
    function CheckNewVersion:String;
  public
    //��ȡ���ŷ���
    function GetGoodsCategory:String;
    //��ȡ�����б�
    function GetGoodsList:String;

  public
    //������Ʒ,���ض����źʹ�����
    function BuyGoods(//�����
                      ARoomNO:String;
                      //����Ա��
                      AWaitorNO:String;
                      //�������Ʒ�б�Json
                      AGoodsListJsonStr:String;
                      //���
                      AMoney:Double
                      ):String;


//    //��ȡ����鼮�б�
//    function GetBookList(AUserID:Integer;
//                            ALoginKey:String;
//                            APageIndex:Integer;
//                            APageSize:Integer):String;
//    //��ȡ�û��鼮�б�
//    function GetUserBookList(AUserID:Integer;
//                            ALoginKey:String;
//                            APageIndex:Integer;
//                            APageSize:Integer):String;
//    //����鼮
//    function AddUserBook(AUserID:Integer;
//                            ABookID:Integer):String;
//    //�Ƿ����û��鼮(�û��Ƿ��Ѿ������˴��鼮)
//    function IsUserBook(AUserID:Integer;
//                            ABookID:Integer):String;
//  public
//    //��ȡ�ҵ��ĵ��б�(���ڹ���,ɾ��)
//    function GetMyMindList(AUserID:Integer;
//                            ALoginKey:String;
//                            APageIndex:Integer;
//                            APageSize:Integer):String;
//    //��ȡ�ĵ��б�
//    function GetUserMindList(AUserID:Integer;
//                            ALoginKey:String;
//                            APageIndex:Integer;
//                            APageSize:Integer):String;
//    //����ĵ�
//    function AddMind(AUserID:Integer;
//                      ALoginKey:String;
//                      ABookID:Integer;
//                      ASelectedContent:String;
//                      AMind:String
//                      ):String;
//    //ɾ���ĵ�
//    function DelMind(AUserID:Integer;
//                      ALoginKey:String;
//                      AMindID:Integer):String;
//  public
//    //��ȡ�ҵķ���б�(���ڹ���,ɾ��)
//    function GetMySpiritList(AUserID:Integer;
//                            ALoginKey:String;
//                            APageIndex:Integer;
//                            APageSize:Integer):String;
//    //��ȡ����б�
//    function GetUserSpiritList(AUserID:Integer;
//                              ALoginKey:String;
//                              APageIndex:Integer;
//                              APageSize:Integer):String;
//    //��ӷ��
//    function AddSpirit(AUserID:Integer;
//                      ALoginKey:String;
//                      ASpirit:String;
//                      APic1:String;
//                      APic2:String;
//                      APic3:String;
//                      APic4:String;
//                      APic5:String;
//                      APic6:String;
//                      APic7:String;
//                      APic8:String;
//                      APic9:String;
//                      APic1Width:Integer;
//                      APic1Height:Integer
//                      ):String;
//
//    //ɾ�����
//    function DelSpirit(AUserID:Integer;
//                      ALoginKey:String;
//                      ASpiritID:Integer):String;
//
//  public
//    //�������ʱ��
//    function AddUserReadTime(AUserID:Integer;
//                            ALoginKey:String;
//                            AReadSeconds:Integer):String;
//    //��ȡ��������ʱ��
//    function GetUserReadTimeList(AUserID:Integer;
//                                ALoginKey:String):String;
  end;
{$METHODINFO OFF}



function ReturnJson(ACode:Integer;ADesc:String;ADataJson:ISuperObject):ISuperObject;
//�ѷ�ɵ���ʱͼƬ�ƶ�����ʽĿ¼
function MoveTempSpiritPic(ASpiritID:Integer;ATempFileName:String):Boolean;


function GetJsonDoubleValue(AJson: ISuperObject;Name:String):Double;

implementation



uses System.StrUtils;



function GetJsonDoubleValue(AJson: ISuperObject;Name:String):Double;
begin
//  if AJson.Null[Name]=jNull then
//  begin
//    Result:='';
//  end
//  else
//  begin
//    Result:=AJson.V[Name];
//  end;
  if VarIsNull(AJson.V[Name]) then
  begin
    Result:=0.00;
  end
  else
  if (AJson.GetType(Name)=varString) and (AJson.V[Name]='') then
  begin
    Result:=0.00;
  end
  else
  begin
    Result:=AJson.V[Name];
  end;
end;

//�ѷ�ɵ���ʱͼƬ�ƶ�����ʽĿ¼
function MoveTempSpiritPic(ASpiritID:Integer;ATempFileName:String):Boolean;
begin
  Result:=True;
  if ATempFileName<>'' then
  begin
    System.SysUtils.ForceDirectories(GlobalConfig.GetWWWRootDir+'Upload\Spirit\'+IntToStr(ASpiritID)+'\');
    Result:=MoveFile(PWideChar(GlobalConfig.GetWWWRootDir+'Upload\Spirit\Temp\'+ATempFileName),
                    PWideChar(GlobalConfig.GetWWWRootDir+'Upload\Spirit\'+IntToStr(ASpiritID)+'\'+ATempFileName));
  end;
end;


function CreateJsonValueByField(Json: ISuperObject;Field: TField): Boolean;
//var
//  value:Variant;
begin

//  value:=varNull;

  try
    if (Field Is TDateTimeField)
      or(Field is TSQLTimeStampField) then
        Json.S[Field.FieldName] := //SO(
                                    FormatDateTime('YYYY-MM-DD HH:MM:SS',Field.AsDateTime)
                                    //)
//    else if Field is TBlobField then
//        Json.S[Field.FieldName] := //EncodeString(
//                                    Field.AsString
//                                    //)
    else if Field is TIntegerField then
        Json.I[Field.FieldName] := //EncodeString(
                                    Field.Value
                                    //)
    else if Field is TBooleanField then
        Json.B[Field.FieldName] := //EncodeString(
                                    Field.Value
                                    //)
    else if (Field is TFloatField)
      or (Field is TSingleField)
      or (Field is TFloatField)
      or (Field is TExtendedField)
      then
        Json.F[Field.FieldName] := //EncodeString(
                                    Field.Value
                                    //)
    else
        Json.S[Field.FieldName] := //SO(
                                      Field.Value
                                   //   )
                                      ;
    Result := True;
  except
    Result:=False;
  end;
end;


function JSonFromDataSet(DataSet: TDataSet;tableName: string): ISuperObject;
var
  sj,sj2:ISuperObject;
  aj:TSuperArray;
  i:Integer;
  index:Integer;
begin
  sj := TSuperObject.Create();
  try
    //�������ݼ�������
//    DataSet.DisableControls;
    DataSet.First;
    aj := TSuperArray.Create();
    index:=0;
    while not DataSet.Eof do
    begin
      sj2 := TSuperObject.Create();
      for i := 0 to DataSet.FieldCount - 1 do
      begin
        if VarIsNull(DataSet.Fields[i].Value) then
          sj2.S[DataSet.Fields[i].FieldName] := ''
        else
        begin
          CreateJsonValueByField(sj2,DataSet.Fields[i]);
        end;
      end;
      aj.O[index]:=sj2;
      Inc(index);
      DataSet.Next;
    end;
    sj.A[tableName] := aj;

    Result := sj;
  finally
//    DataSet.EnableControls;
  end;
end;


function ReturnJson(ACode:Integer;ADesc:String;ADataJson:ISuperObject):ISuperObject;
begin
  Result:=TSuperObject.Create;
  Result.I['Code']:=ACode;
  Result.S['Desc']:=ADesc;
  if ADataJson<>nil then
  begin
    Result.O['Data']:=ADataJson;
  end;
end;

function TServerMethods1.BuyGoods(
                      //�����
                      ARoomNO:String;
                      //����Ա��
                      AWaitorNO:String;
                      //�������Ʒ�б�Json
                      AGoodsListJsonStr:String;
                      //���
                      AMoney:Double
                      ):String;

var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  AMaxFID:Integer;
  ASQLDBHelper:TADODBHelper;

  AMaxGoodsListFID:Integer;
  I: Integer;

var
  AGoodsListJson:ISuperObject;
  AGoodsListItemJson:ISuperObject;
begin

  ACode:=FAIL;
  ADesc:='';
  ADataJson:=nil;


  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
  ASQLDBHelper.Lock;
  try


    AGoodsListJson:=TSuperObject.Create(AGoodsListJsonStr);


    AMaxFID:=GetMaxFID(ASQLDBHelper,'tblOrder','FID',False);
    if AMaxFID<>-1 then
    begin





      //�Ȳ�����Ʒ�б�
      for I := 0 to AGoodsListJson.A['GoodsList'].Length-1 do
      begin
        AMaxGoodsListFID:=GetMaxFID(ASQLDBHelper,'tblOrderGoodsList','FID',False);

        AGoodsListItemJson:=AGoodsListJson.A['GoodsList'].O[I];

        if AMaxGoodsListFID<>-1 then
        begin
          //������Ʒ�б�
          if ASQLDBHelper.SelfQuery('INSERT INTO tblOrderGoodsList'
              +'(FID,OrderFID,GoodsFID,Name,Price,Unit,Number,OrderNO) '
              +'VALUES '
              +'(:FID,:OrderFID,:GoodsFID,:Name,:Price,:Unit,:Number,:OrderNO)',
                ['FID','OrderFID','GoodsFID','Name','Price','Unit','Number','OrderNO'],
                [
                AMaxGoodsListFID,
                AMaxFID,
                AGoodsListItemJson.I['GoodsFID'],
                AGoodsListItemJson.S['Name'],
                GetJsonDoubleValue(AGoodsListItemJson,'Price'),
                AGoodsListItemJson.S['Unit'],
                GetJsonDoubleValue(AGoodsListItemJson,'Number'),
                I
                ],
                asoExec) then
          begin

          end
          else
          begin
            //���ݿ�����ʧ�ܻ��쳣
            ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
            Exit;
          end;

        end
        else
        begin
          //���ݿ�����ʧ�ܻ��쳣
          ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
          Exit;
        end;

      end;








      //����
      if ASQLDBHelper.SelfQuery('INSERT INTO tblOrder'
          +'(FID,RoomNO,WaitorNO,Money,AddTime) '
          +'VALUES '
          +'(:FID,:RoomNO,:WaitorNO,:Money,:AddTime)',
          ['FID','RoomNO','WaitorNO','Money','AddTime'],
          [
          AMaxFID,
          ARoomNO,
          AWaitorNO,
          AMoney,
          Now
          ],
          asoExec) then
      begin


        //�������ɵĶ���
        if ASQLDBHelper.SelfQuery('SELECT * FROM tblOrder WHERE FID=:FID',
                            ['FID'],
                            [AMaxFID],
                            asoOpen) then
        begin
          //�ɹ�
          ADesc:='���ɶ����ɹ�';
          ACode:=SUCC;

          ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'Order');
        end
        else
        begin
          //���ݿ�����ʧ�ܻ��쳣
          ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
        end;



      end
      else
      begin
        //���ݿ�����ʧ�ܻ��쳣
        ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
      end;




    end
    else
    begin
      //���ݿ�����ʧ�ܻ��쳣
      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
    end;


  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;

end;

//function TServerMethods1.CheckForgetPasswordCaptcha(
//                APhone,
//                ACaptcha: String): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//
//  //��֤�����ɹ�
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
//                        ['Phone'],
//                        [APhone],
//                        asoOpen) then
//    begin
//      ASQLDBHelper.Query.First;
//      if not ASQLDBHelper.Query.Eof then
//      begin
//
//
//
//
//            //�ȶ���֤��
//            if ASQLDBHelper.SelfQuery('SELECT TOP 1 * FROM tblCaptcha WHERE Phone=:Phone AND Method=:Method ORDER BY AddTime DESC',
//                                ['Phone','Method'],
//                                [APhone,'ForgetPassword'],
//                                asoOpen) then
//            begin
//                if Not ASQLDBHelper.Query.Eof then
//                begin
//                  if ASQLDBHelper.Query.FieldByName('Captcha').AsString=ACaptcha then
//                  begin
//                      //��֤����ͬ
//
//                      //�ɹ�
//                      ADesc:='��֤����ȷ';
//                      ACode:=SUCC;
//
//                  end
//                  else
//                  begin
//                    //��֤�벻��ȷ
//                    ADesc:='��֤�벻��ȷ';
//                  end;
//                end
//                else
//                begin
//                  ADesc:='δ���͹���֤��';
//                end;
//
//
//            end
//            else
//            begin
//              //���ݿ�����ʧ�ܻ��쳣
//              ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//            end;
//
//
//
//
//
//
//
//
//      end
//      else
//      begin
//        //���ֻ���δ��ע��
//        ADesc:='���ֻ���δ��ע��';
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//end;

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
      //�汾
      AVersion:=AIniFile.ReadString('','Version','');
      //������־
      AUpdateLog:=AIniFile.ReadString('','UpdateLog','');
      //Android������
      AAndroid:=AIniFile.ReadString('','Android','');
      //IOS��appstore��ַ
      AIOS:=AIniFile.ReadString('','IOS','');
      //�Ƿ��������
      AMustUpdate:=AIniFile.ReadBool('','MustUpdate',False);


      //�ɹ�
      ADesc:='��ȡ�°汾��Ϣ�ɹ�';
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

constructor TServerMethods1.Create(AOwner: TComponent);
begin
  inherited;
end;

//function TServerMethods1.DelMind(AUserID: Integer; ALoginKey: String;
//  AMindID: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//
//      //����
//      if ASQLDBHelper.SelfQuery('DELETE tblMind WHERE FID=:FID ',
//          ['FID'],
//          [
//          AMindID
//          ],
//          asoExec) then
//      begin
//
//          //�ɹ�
//          ADesc:='�ĵ�ɾ���ɹ�';
//          ACode:=SUCC;
//
//      end
//      else
//      begin
//        //���ݿ�����ʧ�ܻ��쳣
//        ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//      end;
//
//
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.DelSpirit(AUserID: Integer; ALoginKey: String;
//  ASpiritID: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//
//      //����
//      if ASQLDBHelper.SelfQuery('DELETE tblSpirit WHERE FID=:FID ',
//          ['FID'],
//          [
//          ASpiritID
//          ],
//          asoExec) then
//      begin
//
//          //�ɹ�
//          ADesc:='���ɾ���ɹ�';
//          ACode:=SUCC;
//
//      end
//      else
//      begin
//        //���ݿ�����ʧ�ܻ��쳣
//        ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//      end;
//
//
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;

destructor TServerMethods1.Destroy;
begin
  inherited;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

//function TServerMethods1.GetUserMindList(AUserID: Integer; ALoginKey: String;
//  APageIndex, APageSize: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if APageSize<=0 then APageSize:=Const_PageSize;
//
//
//    if ASQLDBHelper.SelfQuery(
//
//
//                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '
//
//
//                                      +'SELECT '
//                                      +'ROW_NUMBER() OVER (ORDER BY A.AddTime DESC) AS RowNumber, '
//                                      +'A.*,'
//                                      +'B.Name as UserName,B.HeadPicPath as UserHeadPicPath,'
//                                      +'C.Name as BookName,'
//                                      +'D.Name as CompanyName'
//                                      +' FROM tblMind A '
//
//                                      //��ʾ�û���
//                                      +'LEFT JOIN tblUser B ON A.UserID=B.FID '
//                                      //��ʾ�鼮����
//                                      +'LEFT JOIN tblBook C ON A.BookID=C.FID '
//                                      //��ʾ֧������
//                                      +'LEFT JOIN tblCompany D ON B.CompanyID=D.FID '
//                                      //���ִ��
//                                      +'LEFT JOIN vwCompanyRelation E ON B.CompanyID=E.FID '
//
//
//                                      +'WHERE B.FID IS NOT NULL '
//
//                                      //�û����ڵĴ��Ҫ���Լ���ͬ
//                                      +'AND SUBSTRING(E.FIDPath,1,CHARINDEX(''>'',E.FIDPath)-1)'
//                                      +'=(SELECT SUBSTRING(FIDPath,1,CHARINDEX(''>'',FIDPath)-1) FROM vwCompanyRelation WHERE FID=(SELECT CompanyID FROM tblUser WHERE FID='+IntToStr(AUserID)+'))'
//
//                                      +') Z '
//                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '
//
//
//                                      +'ORDER BY AddTime DESC ',
//                                      [],
//                                      [],
//                                      asoOpen) then
//    begin
//
//      //��ȡ�ɹ�
//      ADesc:='��ȡ�ɹ�';
//      ACode:=SUCC;
//      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'UserMindList');
//
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.GetUserSpiritList(AUserID: Integer; ALoginKey: String;
//  APageIndex, APageSize: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if APageSize<=0 then APageSize:=Const_PageSize;
//
//
//    if ASQLDBHelper.SelfQuery(
//
//                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '
//
//                                      +'SELECT '
//                                      +'ROW_NUMBER() OVER (ORDER BY A.AddTime DESC) AS RowNumber, '
//                                      +'A.*,'
//                                      +'B.Name as UserName,B.HeadPicPath as UserHeadPicPath, '
//                                      +'C.Name as CompanyName'
//                                      +' FROM tblSpirit A '
//
//                                      //��ʾ�û���
//                                      +'LEFT JOIN tblUser B ON A.UserID=B.FID '
//                                      //��ʾ֧������
//                                      +'LEFT JOIN tblCompany C ON B.CompanyID=C.FID '
//                                      //���ִ��
//                                      +'LEFT JOIN vwCompanyRelation E ON B.CompanyID=E.FID '
//
//                                      +'WHERE B.FID IS NOT NULL '
//
//                                      //�û����ڵĴ��Ҫ���Լ���ͬ
//                                      +'AND SUBSTRING(E.FIDPath,1,CHARINDEX(''>'',E.FIDPath)-1)'
//                                      +'=(SELECT SUBSTRING(FIDPath,1,CHARINDEX(''>'',FIDPath)-1) FROM vwCompanyRelation WHERE FID=(SELECT CompanyID FROM tblUser WHERE FID='+IntToStr(AUserID)+'))'
//
//
//
//                                      +') Z '
//                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '
//
//                                      +'ORDER BY AddTime DESC ',
//                                      [],
//                                      [],
//                                      asoOpen) then
//    begin
//
//      //��ȡ�ɹ�
//      ADesc:='��ȡ�ɹ�';
//      ACode:=SUCC;
//      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'UserSpiritList');
//
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.IsUserBook(AUserID: Integer; ABookID: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//
//      if ASQLDBHelper.SelfQuery('SELECT * FROM tblUserBook WHERE UserID=:UserID AND BookID=:BookID',
//                          ['UserID','BookID'],
//                          [AUserID,ABookID],
//                          asoOpen) then
//      begin
//
//
//
//          //�ɹ�
//          ADesc:='��ѯ�鼮�ɹ�';
//          ACode:=SUCC;
//
//          ADataJson:=TSuperObject.Create();
//          ADataJson.B['IsUserBook']:=Not ASQLDBHelper.Query.Eof;
//
//      end
//      else
//      begin
//        //���ݿ�����ʧ�ܻ��쳣
//        ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//      end;
//
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.GetMyMindList(AUserID: Integer; ALoginKey: String;
//  APageIndex, APageSize: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if APageSize<=0 then APageSize:=Const_PageSize;
//
//
//    if ASQLDBHelper.SelfQuery(
//
//
//                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '
//
//                                      +'SELECT '
//                                      +'ROW_NUMBER() OVER (ORDER BY AddTime DESC) AS RowNumber, '
//                                      +'* '
//                                      +'FROM tblMind '
//
//                                      +') Z '
//                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '
//
//                                      +'ORDER BY AddTime DESC ',
//
//                                      [],
//                                      [],
//                                      asoOpen) then
//    begin
//
//      //��ȡ�ɹ�
//      ADesc:='��ȡ�ɹ�';
//      ACode:=SUCC;
//      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'MyMindList');
//
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.GetMySpiritList(AUserID: Integer; ALoginKey: String;
//  APageIndex, APageSize: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if APageSize<=0 then APageSize:=Const_PageSize;
//
//
//    if ASQLDBHelper.SelfQuery(
//
//                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '
//
//                                      +'SELECT '
//                                      +'ROW_NUMBER() OVER (ORDER BY AddTime DESC) AS RowNumber, '
//                                      +'* '
//                                      +'FROM tblSpirit '
//
//                                      +') Z '
//                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '
//
//                                      +'ORDER BY AddTime DESC ',
//                                      [],
//                                      [],
//                                      asoOpen) then
//    begin
//
//      //��ȡ�ɹ�
//      ADesc:='��ȡ�ɹ�';
//      ACode:=SUCC;
//      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'MySpiritList');
//
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;

function TServerMethods1.GetGoodsCategory: String;
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
    if ASQLDBHelper.SelfQuery('SELECT * FROM tblGoodsCategory',
                        [],
                        [],
                        asoOpen) then
    begin

      //��ȡ�ɹ�
      ADesc:='��ȡ�ɹ�';
      ACode:=SUCC;
      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'GoodsCategorys');

    end
    else
    begin
      //���ݿ�����ʧ�ܻ��쳣
      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

function TServerMethods1.GetGoodsList: String;
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
//    if APageSize<=0 then APageSize:=Const_PageSize;

    if ASQLDBHelper.SelfQuery(
//                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '

                                      'SELECT '
//                                      +'ROW_NUMBER() OVER (ORDER BY AddTime DESC) AS RowNumber, '
                                      +'* FROM tblGoods '
//                                      +' '

//                                      +') Z '
//                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '

                                      +'ORDER BY GoodsCategoryID,AddTime ASC '


                                      ,

                        [],
                        [],
                        asoOpen) then
    begin

      //��ȡ�ɹ�
      ADesc:='��ȡ�ɹ�';
      ACode:=SUCC;
      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'GoodsList');

    end
    else
    begin
      //���ݿ�����ʧ�ܻ��쳣
      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
    end;
  finally
    ASQLDBHelper.UnLock;
    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
  end;
end;

//function TServerMethods1.GetUserReadTimeList(AUserID: Integer;
//                                            ALoginKey: String): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT TOP 10 A.FID AS UserID,A.Name,A.Phone,ISNULL(A.ReadSeconds,0) AS ReadSeconds,HeadPicPath '
//
//                                      +'FROM tblUser A '
//
//                                      //���ִ��
//                                      +'LEFT JOIN vwCompanyRelation E ON A.CompanyID=E.FID '
//
//                                      +'WHERE (1=1) '
//
//                                      //�û����ڵĴ��Ҫ���Լ���ͬ
//                                      +'AND SUBSTRING(E.FIDPath,1,CHARINDEX(''>'',E.FIDPath)-1)'
//                                      +'=(SELECT SUBSTRING(FIDPath,1,CHARINDEX(''>'',FIDPath)-1) FROM vwCompanyRelation WHERE FID=(SELECT CompanyID FROM tblUser WHERE FID='+IntToStr(AUserID)+'))'
//
//
//
//                                      +'ORDER BY ISNULL(ReadSeconds,0) DESC ',
//                                      [],
//                                      [],
//                                      asoOpen) then
//    begin
//
//      //��ȡ�ɹ�
//      ADesc:='��ȡ�ɹ�';
//      ACode:=SUCC;
//      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'UserReadTimeList');
//
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//end;
//
//function TServerMethods1.GetUserBookList(
//            AUserID:Integer;
//            ALoginKey: String;
//            APageIndex,
//            APageSize: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if APageSize<=0 then APageSize:=Const_PageSize;
//
//
//    if ASQLDBHelper.SelfQuery(
//
//                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '
//
//                                      +'SELECT '
//                                      +'ROW_NUMBER() OVER (ORDER BY A.LastReadTime DESC) AS RowNumber, '
//                                      +'A.BookID,A.AddTime,A.LastReadTime,A.LastReadPageIndex,'
//                                      +'B.Name,B.PicPath,B.FileSize,B.FilePath,B.IOSFilePath,B.AndroidFilePath,B.TextFilePath,B.FileDesc,B.FileDescPath,B.BookCategoryID '
//                                      +'FROM tblUserBook A '
//                                      +'LEFT JOIN tblBook B ON A.BookID=B.FID '
//
//                                      +'WHERE A.UserID='+IntToStr(AUserID)+' '
//
//                                      +') Z '
//                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '
//
//                                      +'ORDER BY LastReadTime DESC ',
//
//
//                                      [],
//                                      [],
//                                      asoOpen) then
//    begin
//
//      //��ȡ�ɹ�
//      ADesc:='��ȡ�ɹ�';
//      ACode:=SUCC;
//      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'UserBookList');
//
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//
//function TServerMethods1.GetBookList(
//            AUserID:Integer;
//            ALoginKey: String;
//            APageIndex,
//            APageSize: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if APageSize<=0 then APageSize:=Const_PageSize;
//
//
//    if ASQLDBHelper.SelfQuery(
//
//                                      'SELECT TOP '+IntToStr(APageSize)+' * FROM ( '
//
//                                      +'SELECT '
//                                      +'ROW_NUMBER() OVER (ORDER BY AddTime DESC) AS RowNumber, '
////                                      +'Name,PicPath,FileSize,FilePath,IOSFilePath,AndroidFilePath,TextFilePath,FileDesc,FileDescPath,BookCategoryID '
//                                      +'* '
//                                      +'FROM tblBook  '
//
//                                      +') Z '
//                                      +'WHERE RowNumber > '+IntToStr(APageSize)+'*('+IntToStr(APageIndex)+'-1) '
//
//                                      +'ORDER BY AddTime DESC ',
//
//
//                                      [],
//                                      [],
//                                      asoOpen) then
//    begin
//
//      //��ȡ�ɹ�
//      ADesc:='��ȡ�ɹ�';
//      ACode:=SUCC;
//      ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'BookList');
//
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.Login(ALoginUser,
//                              APassword: String;
//                              AVersion:String): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//
//  AUserFID:Integer;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE LoginUser=:LoginUser',
//                        ['LoginUser'],
//                        [ALoginUser],
//                        asoOpen) then
//    begin
//      ASQLDBHelper.Query.First;
//      if Not ASQLDBHelper.Query.Eof then
//      begin
//
//
//            //���ڴ��û�
//
//
//            //�ȶ�����
//            if ASQLDBHelper.Query.FieldByName('LoginPass').AsString=APassword then
//            begin
//              //������ȷ
//              AUserFID:=ASQLDBHelper.Query.FieldByName('FID').AsInteger;
//
//              if ASQLDBHelper.SelfQuery('SELECT A.*,B.Name as CompanyName FROM tblUser A '
//                                  +'LEFT JOIN tblCompany B ON A.CompanyID=B.FID WHERE A.FID=:FID',
//                                  ['FID'],
//                                  [AUserFID],
//                                  asoOpen) then
//              begin
//                ADesc:='��½�ɹ�';
//                ACode:=SUCC;
//
//                ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'User');
//              end
//              else
//              begin
//                //���ݿ�����ʧ�ܻ��쳣
//                ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//              end;
//            end
//            else
//            begin
//              //���벻��ȷ
//              ADesc:='���벻��ȷ';
//            end;
//
//
//
//      end
//      else
//      begin
//        //�����ڴ��û�
//        ADesc:='�����ڴ��û�';
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//
//end;
//
//function TServerMethods1.RegisterPush(AUserID: Integer;
//                                      ALoginKey,
//                                      APushInfoJsonStr: String): string;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AMaxFID:Integer;
//var
//  SuperObject:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//
//
//
//  //'{"Command":"Register",
//  //"OS":"Android",
//  //"Badge":0,
//  //"NeedPush":True,
//  //"ClientID":"c82366727a9b5dd055f718f3ff305711",
//  //"DeviceToken":""}'
//
//  SuperObject:=TSuperObject.Create(APushInfoJsonStr);
//  //�����������ж�
//  //ע��
//  if SuperObject.S['Command']='Register' then
//  begin
//
//      ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//      ASQLDBHelper.Lock;
//      try
//
//        //�Ƚ��ô��û����е�����ע���豸
//        ASQLDBHelper.SelfQuery('UPDATE tblPush SET NeedPush=0 WHERE UserID=:UserID',
//                            ['UserID'],
//                            [AUserID],
//                            asoExec);
//
//
//
//
//
//        //��ѯ�Ƿ��Ѿ����������豸
//        if ASQLDBHelper.SelfQuery('SELECT * FROM tblPush WHERE ClientID=:ClientID',
//                            ['ClientID'],
//                            [
//                            SuperObject.S['ClientID']
//                            ],
//                            asoOpen) then
//        begin
//          ASQLDBHelper.Query.First;
//          if ASQLDBHelper.Query.Eof then
//          begin
//
//
//
//              //������
//              AMaxFID:=GetMaxFID(ASQLDBHelper,'tblPush','FID',False);
//              if AMaxFID<>-1 then
//              begin
//                //����
//                if ASQLDBHelper.SelfQuery('INSERT INTO tblPush'
//                    +'(FID,ClientID,DeviceToken,UserID,OS,Badge,NeedPush,AddTime) '
//                    +'VALUES '
//                    +'(:FID,:ClientID,:DeviceToken,:UserID,:OS,:Badge,:NeedPush,:AddTime)',
//                            ['FID','ClientID','DeviceToken','UserID','OS','Badge','NeedPush','AddTime'],
//                            [
//                            AMaxFID,
//                            SuperObject.S['ClientID'],
//                            SuperObject.S['DeviceToken'],
//                            AUserID,
//                            SuperObject.S['OS'],
//                            SuperObject.I['Badge'],
//                            SuperObject.B['NeedPush'],
//                            Now
//                            ],
//                            asoExec) then
//                begin
//                  //�ɹ�
//                  ADesc:='ע��ɹ�';
//                  ACode:=SUCC;
//
//                end
//                else
//                begin
//                  //���ݿ�����ʧ�ܻ��쳣
//                  ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                end;
//              end
//              else
//              begin
//                //���ݿ�����ʧ�ܻ��쳣
//                ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//              end;
//
//
//          end
//          else
//          begin
//
//
//              //�Ѿ�ע��,�����û�ID,��Ϊ�豸���ܵ�½������û�ID
//              if ASQLDBHelper.SelfQuery('UPDATE tblPush SET UserID=:UserID,Badge=:Badge,NeedPush=:NeedPush WHERE FID=:FID',
//                                  ['UserID','Badge','NeedPush','FID'],
//                                  [AUserID,
//                                  SuperObject.I['Badge'],
//                                  SuperObject.B['NeedPush'],
//                                  ASQLDBHelper.Query.FieldByName('FID').AsInteger
//                                  ],
//                                  asoExec) then
//              begin
//                //���³ɹ�
//                ADesc:='���³ɹ�';
//                ACode:=SUCC;
//              end
//              else
//              begin
//                //���ݿ�����ʧ�ܻ��쳣
//                ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//              end;
//
//
//          end;
//        end
//        else
//        begin
//          //���ݿ�����ʧ�ܻ��쳣
//          ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//        end;
//      finally
//        ASQLDBHelper.UnLock;
//        GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//        Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//
//      end;
//
//  end;
//end;
//
//function TServerMethods1.UpdatePush(AUserID: Integer;
//                                      ALoginKey,
//                                      APushInfoJsonStr: String): string;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AMaxFID:Integer;
//var
//  SuperObject:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//
//  //'{"Command":"Update",
//  //"OS":"Android",
//  //"Badge":0,
//  //"NeedPush":True/False,
//  //"ClientID":"c82366727a9b5dd055f718f3ff305711",
//  //"DeviceToken":""}'
//
//  SuperObject:=TSuperObject.Create(APushInfoJsonStr);
//  //�����������ж�
//  //����
//  if SuperObject.S['Command']='Update' then
//  begin
//
//
//
//      ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//      ASQLDBHelper.Lock;
//      try
//
//
//
//                //����
//                if ASQLDBHelper.SelfQuery('UPDATE tblPush '
//                    +'SET Badge=:Badge,NeedPush=:NeedPush '
//                    +'WHERE ClientID=:ClientID ',
//                            ['Badge','NeedPush','ClientID'],
//                            [
//                            SuperObject.I['Badge'],
//                            SuperObject.B['NeedPush'],
//                            SuperObject.S['ClientID']
//                            ],
//                            asoExec) then
//                begin
//                  //����
//                  ADesc:='���³ɹ�';
//                  ACode:=SUCC;
//
//                end
//                else
//                begin
//                  //���ݿ�����ʧ�ܻ��쳣
//                  ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                end;
//
//
//      finally
//        ASQLDBHelper.UnLock;
//        GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//        Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//
//      end;
//
//  end;
//end;
//
//function TServerMethods1.RegisterUser(AName,
//                                      APhone,
//                                      ACaptcha,
//                                      APassword,
//                                      ARePassword: String): string;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AMaxFID:Integer;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  if Trim(AName)='' then
//  begin
//    ADesc:='��������Ϊ��';
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//    Exit;
//  end;
//
//  if Trim(APhone)='' then
//  begin
//    ADesc:='�ֻ��Ų���Ϊ��';
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//    Exit;
//  end;
//
//  if Trim(ACaptcha)='' then
//  begin
//    ADesc:='��֤�벻��Ϊ��';
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//    Exit;
//  end;
//
//  if Trim(APassword)='' then
//  begin
//    ADesc:='���벻��Ϊ��';
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//    Exit;
//  end;
//
//  if APassword<>ARePassword then
//  begin
//    ADesc:='������������벻��ͬ';
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//    Exit;
//  end;
//
//
//
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
//                        ['Phone'],
//                        [APhone],
//                        asoOpen) then
//    begin
//      ASQLDBHelper.Query.First;
//      if ASQLDBHelper.Query.Eof then
//      begin
//
//
//
//
//
//            //�ȶ��û�ע����֤��
//            if ASQLDBHelper.SelfQuery('SELECT TOP 1 * FROM tblCaptcha WHERE Phone=:Phone AND Method=:Method ORDER BY AddTime DESC',
//                                ['Phone','Method'],
//                                [APhone,'Register'],
//                                asoOpen) then
//            begin
//                if Not ASQLDBHelper.Query.Eof then
//                begin
//                  if ASQLDBHelper.Query.FieldByName('Captcha').AsString=ACaptcha then
//                  begin
//                          //��֤��ֻ��ʹ��һ��,������ʱ������
//
//                          //�û�ע�����֤����ͬ
//
//
//                          AMaxFID:=GetMaxFID(ASQLDBHelper,'tblUser','FID',False);
//                          if AMaxFID<>-1 then
//                          begin
//                            //�������û�
//                            if ASQLDBHelper.SelfQuery('INSERT INTO tblUser'
//                                +'(FID,LoginUser,LoginPass,Name,Phone,RegTime,ReadSeconds) '
//                                +'VALUES '
//                                +'(:FID,:LoginUser,:LoginPass,:Name,:Phone,:RegTime,:ReadSeconds)',
//                                        ['FID','LoginUser','LoginPass','Name','Phone','RegTime','ReadSeconds'],
//                                        [
//                                        AMaxFID,
//                                        APhone,
//                                        APassword,
//                                        AName,
//                                        APhone,
//                                        Now,
//                                        0
//                                        ],
//                                        asoExec) then
//                            begin
//                              //�ɹ�
//                              ADesc:='ע��ɹ�';
//                              ACode:=SUCC;
//
//                            end
//                            else
//                            begin
//                              //���ݿ�����ʧ�ܻ��쳣
//                              ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                            end;
//                          end
//                          else
//                          begin
//                            //���ݿ�����ʧ�ܻ��쳣
//                            ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                          end;
//
//
//
//
//
//
//                  end
//                  else
//                  begin
//                    //��֤�벻��ȷ
//                    ADesc:='��֤�벻��ȷ';
//                  end;
//                end
//                else
//                begin
//                  ADesc:='δ�Դ��ֻ����͹���֤��';
//                end;
//
//
//            end
//            else
//            begin
//              //���ݿ�����ʧ�ܻ��쳣
//              ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//            end;
//
//
//
//
//
//
//
//
//      end
//      else
//      begin
//        //���ֻ����Ѿ���ע��
//        ADesc:='���ֻ����Ѿ���ע��';
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//
//  end;
//
//
//
//end;
//
//function TServerMethods1.AddUserBook(AUserID: Integer; ABookID: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AMaxFID:Integer;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//
//    AMaxFID:=GetMaxFID(ASQLDBHelper,'tblUserBook','FID',False);
//    if AMaxFID<>-1 then
//    begin
//      //����
//      if ASQLDBHelper.SelfQuery('INSERT INTO tblUserBook'
//          +'(FID,UserID,BookID,AddTime) '
//          +'VALUES '
//          +'(:FID,:UserID,:BookID,:AddTime)',
//                  ['FID','UserID','BookID','AddTime'],
//                  [
//                  AMaxFID,
//                  AUserID,
//                  ABookID,
//                  Now
//                  ],
//                  asoExec) then
//      begin
//
//
////        //������ӵ��ĵ�
////        if ASQLDBHelper.SelfQuery('SELECT * FROM tblMind WHERE FID=:FID',
////                            ['FID'],
////                            [AMaxFID],
////                            asoOpen) then
////        begin
//
//
//          //�ɹ�
//          ADesc:='����鼮�ɹ�';
//          ACode:=SUCC;
//
////          ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'Mind');
//
////        end
////        else
////        begin
////          //���ݿ�����ʧ�ܻ��쳣
////          ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
////        end;
//
//
//
//      end
//      else
//      begin
//        //���ݿ�����ʧ�ܻ��쳣
//        ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//
//
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//end;
//
//function TServerMethods1.AddUserReadTime(AUserID: Integer;
//                                        ALoginKey: String;
//                                        AReadSeconds: Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//
//      //����Ķ�ʱ��
//      if ASQLDBHelper.SelfQuery('UPDATE tblUser SET ReadSeconds=ISNULL(ReadSeconds,0)+:ReadSeconds WHERE FID=:FID',
//                          ['ReadSeconds','FID'],
//                          [AReadSeconds,AUserID],
//                          asoExec) then
//      begin
//        //�Ķ�ʱ���޸ĳɹ�
//        ADesc:='�Ķ�ʱ���޸ĳɹ�';
//        ACode:=SUCC;
//      end
//      else
//      begin
//        //���ݿ�����ʧ�ܻ��쳣
//        ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//      end;
//
//
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//end;
//
//function TServerMethods1.AddSpirit(AUserID: Integer; ALoginKey, ASpirit, APic1,
//  APic2, APic3, APic4, APic5, APic6, APic7, APic8, APic9: String;
//                      APic1Width:Integer;
//                      APic1Height:Integer): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AMaxFID:Integer;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//
//    AMaxFID:=GetMaxFID(ASQLDBHelper,'tblSpirit','FID',False);
//    if AMaxFID<>-1 then
//    begin
//
//      //�ƶ��ļ�
//      MoveTempSpiritPic(AMaxFID,APic1);
//      MoveTempSpiritPic(AMaxFID,APic2);
//      MoveTempSpiritPic(AMaxFID,APic3);
//      MoveTempSpiritPic(AMaxFID,APic4);
//      MoveTempSpiritPic(AMaxFID,APic5);
//      MoveTempSpiritPic(AMaxFID,APic6);
//      MoveTempSpiritPic(AMaxFID,APic7);
//      MoveTempSpiritPic(AMaxFID,APic8);
//      MoveTempSpiritPic(AMaxFID,APic9);
//
//      //����
//      if ASQLDBHelper.SelfQuery('INSERT INTO tblSpirit'
//          +'(FID,UserID,Spirit,Pic1Path,Pic2Path,Pic3Path,Pic4Path,Pic5Path,Pic6Path,Pic7Path,Pic8Path,Pic9Path,AddTime,Pic1Width,Pic1Height) '
//          +'VALUES '
//          +'(:FID,:UserID,:Spirit,:Pic1Path,:Pic2Path,:Pic3Path,:Pic4Path,:Pic5Path,:Pic6Path,:Pic7Path,:Pic8Path,:Pic9Path,:AddTime,:Pic1Width,:Pic1Height)',
//          ['FID','UserID','Spirit','Pic1Path','Pic2Path','Pic3Path','Pic4Path','Pic5Path','Pic6Path','Pic7Path','Pic8Path','Pic9Path','AddTime','Pic1Width','Pic1Height'],
//          [
//          AMaxFID,
//          AUserID,
//          ASpirit,
//          APic1,
//          APic2,
//          APic3,
//          APic4,
//          APic5,
//          APic6,
//          APic7,
//          APic8,
//          APic9,
//          Now,
//          APic1Width,
//          APic1Height
//          ],
//          asoExec) then
//      begin
//
//
//        //������ӵķ��
//        if ASQLDBHelper.SelfQuery('SELECT * FROM tblMind WHERE FID=:FID',
//                            ['FID'],
//                            [AMaxFID],
//                            asoOpen) then
//        begin
//          //�ɹ�
//          ADesc:='�����ӳɹ�';
//          ACode:=SUCC;
//
//          ADataJson:=JSonFromDataSet(ASQLDBHelper.Query,'Spirit');
//        end
//        else
//        begin
//          //���ݿ�����ʧ�ܻ��쳣
//          ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//        end;
//
//
//
//      end
//      else
//      begin
//        //���ݿ�����ʧ�ܻ��쳣
//        ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//
//
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.ChangePassword(AUserID: Integer; ALoginKey,
//                                        AOldPassword, APassword, ARePassword: String): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  if APassword<>ARePassword then
//  begin
//    ADesc:='������������벻��ͬ';
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//    Exit;
//  end;
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE FID=:FID',
//                        ['FID'],
//                        [AUserID],
//                        asoOpen) then
//    begin
//      ASQLDBHelper.Query.First;
//      if Not ASQLDBHelper.Query.Eof then
//      begin
//          //���ڴ��û�
//
//
//
//
//          //�ȶ�����
//          if ASQLDBHelper.Query.FieldByName('LoginPass').AsString=AOldPassword then
//          begin
//
//                //�����޸�
//                if ASQLDBHelper.SelfQuery('UPDATE tblUser SET LoginPass=:LoginPass WHERE FID=:FID',
//                                    ['LoginPass','FID'],
//                                    [APassword,AUserID],
//                                    asoExec) then
//                begin
//                  //�����޸ĳɹ�
//                  ADesc:='�����޸ĳɹ�';
//                  ACode:=SUCC;
//                end
//                else
//                begin
//                  //���ݿ�����ʧ�ܻ��쳣
//                  ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                end;
//
//          end
//          else
//          begin
//            ADesc:='ԭ�������';
//          end;
//
//
//
//
//      end
//      else
//      begin
//        //�����ڴ��û�
//        ADesc:='�����ڴ��û�';
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//end;
//
//function TServerMethods1.ReSetPassword(APhone,
//                                      ACaptcha,
//                                      APassword,
//                                      ARePassword: String): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  if APassword<>ARePassword then
//  begin
//    ADesc:='������������벻��ͬ';
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//    Exit;
//  end;
//
//
//
//
//  //��֤�����ɹ�
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
//                        ['Phone'],
//                        [APhone],
//                        asoOpen) then
//    begin
//      ASQLDBHelper.Query.First;
//      if not ASQLDBHelper.Query.Eof then
//      begin
//            //���ڴ��ֻ�
//
//
//
//            //�ȶ���֤��
//            if ASQLDBHelper.SelfQuery('SELECT TOP 1 * FROM tblCaptcha WHERE Phone=:Phone AND Method=:Method ORDER BY AddTime DESC',
//                                ['Phone','Method'],
//                                [APhone,'ForgetPassword'],
//                                asoOpen) then
//            begin
//                if Not ASQLDBHelper.Query.Eof then
//                begin
//                  if ASQLDBHelper.Query.FieldByName('Captcha').AsString=ACaptcha then
//                  begin
//
//
//
//                          //��֤����ͬ
//
//
//                          //���ڴ��û�
//                          //��������
//                          if ASQLDBHelper.SelfQuery('UPDATE tblUser SET LoginPass=:LoginPass WHERE Phone=:Phone',
//                                                            ['LoginPass','Phone'],
//                                                            [APassword,APhone],
//                                                            asoExec) then
//                          begin
//                            //�������óɹ�
//                            ADesc:='�������óɹ�';
//                            ACode:=SUCC;
//                          end
//                          else
//                          begin
//                            //���ݿ�����ʧ�ܻ��쳣
//                            ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                          end;
//
//
//
//                  end
//                  else
//                  begin
//                    //��֤�벻��ȷ
//                    ADesc:='��֤�벻��ȷ';
//                  end;
//                end
//                else
//                begin
//                  ADesc:='δ���͹���֤��';
//                end;
//
//
//            end
//            else
//            begin
//              //���ݿ�����ʧ�ܻ��쳣
//              ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//            end;
//
//
//
//
//
//
//
//
//      end
//      else
//      begin
//        //���ֻ���δ��ע��
//        ADesc:='���ֻ���δ��ע��';
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//
//
//end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;


//function TServerMethods1.SendForgetPasswordCaptcha(APhone: String): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AMaxFID:Integer;
//var
//  ACaptcha:String;
//  AHttpResponse:String;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//
//
//  //��������������֤��
//
//  //'{"error_response":{"code":15,"msg":"Remote service error","sub_code":"isv.BUSINESS_LIMIT_CONTROL","sub_msg":"����ҵ������","request_id":"43w0kbsij3k7"}}'
//  //'{"alibaba_aliqin_fc_sms_num_send_response":{"result":{"err_code":"0","model":"102475257659^1103163056321","success":true},"request_id":"13yk4gjlsuxvd"}
//
//
//  ACaptcha:=GenerateCaptcha;
//
//  //����֤�뱣�浽���ݿ���,��ʮ������Ч
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
//                        ['Phone'],
//                        [APhone],
//                        asoOpen) then
//    begin
//      ASQLDBHelper.Query.First;
//      if Not ASQLDBHelper.Query.Eof then
//      begin
//                //���ڴ��ֻ���
//
//
//                //��������������֤��
//                GlobalTaoBaoManager.APIClient.CustomExecuteAPI(
//                        GlobalTaoBaoManager.CallAPIHttpControl,
//                        GlobalSendSmsTaoBaoAPIItem,
//                        ['sms_type',
//                        'sms_free_sign_name',
//                        'sms_param',
//                        'rec_num',
//                        'sms_template_code'],
//                        ['normal',
//                        '�����֤',
//                        '{"code":"'+ACaptcha+'","product":"��������App"}',
//                        APhone,
//                        'SMS_13042194'],
//                        cpsJson,
//                        rmGet,
//                        AHttpResponse
//                        );
//
//
//
//
//                AMaxFID:=GetMaxFID(ASQLDBHelper,'tblCaptcha','FID',False);
//                if AMaxFID<>-1 then
//                begin
//                  //����
//                  if ASQLDBHelper.SelfQuery('INSERT INTO tblCaptcha'
//                      +'(FID,Phone,Method,Captcha,AddTime,Response) '
//                      +'VALUES '
//                      +'(:FID,:Phone,:Method,:Captcha,:AddTime,:Response)',
//                              ['FID','Phone','Method','Captcha','AddTime','Response'],
//                              [
//                              AMaxFID,
//                              APhone,
//                              'ForgetPassword',
//                              ACaptcha,
//                              Now,
//                              AHttpResponse
//                              ],
//                              asoExec) then
//                  begin
//
//
//
//                    //�ɹ�
//                    ADesc:='���ͳɹ�';
//                    ACode:=SUCC;
//
//                  end
//                  else
//                  begin
//                    //���ݿ�����ʧ�ܻ��쳣
//                    ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                  end;
//                end
//                else
//                begin
//                  //���ݿ�����ʧ�ܻ��쳣
//                  ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                end;
//
//
//
//
//      end
//      else
//      begin
//        //���ֻ���δע��
//        ADesc:='���ֻ���δע��';
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//end;
//
//function TServerMethods1.SendRegisterCaptcha(APhone: String): String;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AMaxFID:Integer;
//var
//  ACaptcha:String;
//  AHttpResponse:String;
//  ASQLDBHelper:TADODBHelper;
//begin
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  //�����û�ע����֤��
//
//  //'{"error_response":{"code":15,"msg":"Remote service error","sub_code":"isv.BUSINESS_LIMIT_CONTROL","sub_msg":"����ҵ������","request_id":"43w0kbsij3k7"}}'
//  //'{"alibaba_aliqin_fc_sms_num_send_response":{"result":{"err_code":"0","model":"102475257659^1103163056321","success":true},"request_id":"13yk4gjlsuxvd"}
//
//
//  ACaptcha:=GenerateCaptcha;
//
//  //����֤�뱣�浽���ݿ���,��ʮ������Ч
//
//
//  ASQLDBHelper:=GetGlobalSQLDBHelperPool.GetCustomObject as TADODBHelper;
//  ASQLDBHelper.Lock;
//  try
//    if ASQLDBHelper.SelfQuery('SELECT * FROM tblUser WHERE Phone=:Phone',
//                              ['Phone'],
//                              [APhone],
//                              asoOpen) then
//    begin
//      ASQLDBHelper.Query.First;
//      if ASQLDBHelper.Query.Eof then
//      begin
//              //�����ڴ��ֻ���
//
//
//              //�����û�ע����֤��
//              GlobalTaoBaoManager.APIClient.CustomExecuteAPI(
//                      GlobalTaoBaoManager.CallAPIHttpControl,
//                      GlobalSendSmsTaoBaoAPIItem,
//                      ['sms_type',
//                      'sms_free_sign_name',
//                      'sms_param',
//                      'rec_num',
//                      'sms_template_code'],
//                      ['normal',
//                      'ע����֤',
//                      '{"code":"'+ACaptcha+'","product":"��������App"}',
//                      APhone,
//                      'SMS_13042196'],
//                      cpsJson,
//                      rmGet,
//                      AHttpResponse
//                      );
//
//
//
//
//              AMaxFID:=GetMaxFID(ASQLDBHelper,'tblCaptcha','FID',False);
//              if AMaxFID<>-1 then
//              begin
//                //����
//                if ASQLDBHelper.SelfQuery('INSERT INTO tblCaptcha'
//                    +'(FID,Phone,Method,Captcha,AddTime,Response) '
//                    +'VALUES '
//                    +'(:FID,:Phone,:Method,:Captcha,:AddTime,:Response)',
//                            ['FID','Phone','Method','Captcha','AddTime','Response'],
//                            [
//                            AMaxFID,
//                            APhone,
//                            'Register',
//                            ACaptcha,
//                            Now,
//                            AHttpResponse
//                            ],
//                            asoExec) then
//                begin
//
//
//
//                  //�ɹ�
//                  ADesc:='���ͳɹ�';
//                  ACode:=SUCC;
//
//                end
//                else
//                begin
//                  //���ݿ�����ʧ�ܻ��쳣
//                  ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//                end;
//
//
//
//              end
//              else
//              begin
//                //���ݿ�����ʧ�ܻ��쳣
//                ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//              end;
//
//
//
//
//
//      end
//      else
//      begin
//        //���ֻ����Ѿ���ע��
//        ADesc:='���ֻ����Ѿ���ע��';
//      end;
//    end
//    else
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc:='���ݿ�����ʧ�ܻ��쳣'+' '+ASQLDBHelper.LastExceptMessage;
//    end;
//  finally
//    ASQLDBHelper.UnLock;
//    GetGlobalSQLDBHelperPool.FreeCustomObject(ASQLDBHelper);
//    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
//  end;
//
//end;

end.

