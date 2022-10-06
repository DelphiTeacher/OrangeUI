
//convert pas to utf8 by ¥
//UniDac数据库操作类,用于连接MSSQL//
unit uDBHelperForElasticSearchDB;

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
//  Windows,
  SysUtils,
  Classes,
//  Forms,
  IniFiles,
//  ADODB,
  SyncObjs,
  DB,
  XSuperObject,
//  ActiveX,
  uBaseLog,
  uFuncCommon,

  StrUtils,
  uBaseDBHelper,
  uDataBaseConfig,

  System.NetEncoding,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,


  DateUtils
//  Messages
  ;



  //不使用kbmMWUNIDACConnectionPool
//  {$DEFINE NOT_USE_kbmMWUNIDACConnectionPool}


type
  TDBHelperForElasticSearchDB=class(TBaseDBHelper)
  protected
  public
    ANetHttpClient:TNetHttpClient;
    ANameValuePair:TNameValuePair;
    FNetHTTPRequestHeaders:TNetHeaders;
    FDBInfo:ISuperObject;
    FDataBaseConfig:TDataBaseConfig;
    FResponseJson:ISuperObject;


    function ServerUrl:String;
    constructor Create;overload;override;
    destructor Destroy;override;

  public
    procedure Close;override;

    function GetConnectionFromPool:TObject;override;
    procedure UnlockConnectionToPool;override;


    function Connect(ADataBaseConfig:TDataBaseConfig):Boolean;override;
    function Disconnect:Boolean;override;

    //添加一条记录
    function DoAddRecord(ATableName:String;AID:String;ARecordDataJson:ISuperObject):Boolean;
    function DoQueryBySQL(AQueryJson:ISuperObject):Boolean;
    //AAPI:String='_search?scroll=5m';
    function DoQueryBySearch(AQueryJsonStr:String;AIsScroll:Boolean=False):Boolean;

    //数据库查询
    function QueryRecordList:ISuperArray;virtual;abstract;
    //查询,标准:select * from
    function SelfQuery(AQueryString:String;
                        AParamNames:TStringDynArray;
                        AParamValues:TVariantDynArray;
                        AOperation:TSQLOperation;
                        AParamsCompleted:Boolean=False;
                        ACustomQueryDataSet:TDataSet=nil):Boolean;override;
  end;


  TElasticSearchDBHelper=TDBHelperForElasticSearchDB;




implementation





{ TDBHelperForElasticSearchDB }

procedure TDBHelperForElasticSearchDB.Close;
begin
  inherited;

end;

function TDBHelperForElasticSearchDB.Connect(ADataBaseConfig: TDataBaseConfig): Boolean;
var
  AResponseStream:TStringStream;
begin
          Result:=False;

          FDataBaseConfig.Assign(ADataBaseConfig);

          AResponseStream:=TStringStream.Create('',TEncoding.UTF8);


          Self.DBType:=ADataBaseConfig.FDBType;


          if ADataBaseConfig.FDBUserName<>'' then
          begin
            SetLength(FNetHTTPRequestHeaders,2);
            ANameValuePair.Name:= 'Authorization';
            //Basic bXhlczptZjJvZWc2VVU0ViM=
            ANameValuePair.Value:= 'Basic '+TNetEncoding.Base64.Encode(ADataBaseConfig.FDBUserName+':'+ADataBaseConfig.FDBPassword);
            FNetHTTPRequestHeaders[0]:=ANameValuePair;

            ANameValuePair.Name:= 'Content-type';
            ANameValuePair.Value:= 'application/json';
            FNetHTTPRequestHeaders[1]:=ANameValuePair;
          end
          else
          begin
            SetLength(FNetHTTPRequestHeaders,1);

            ANameValuePair.Name:= 'Content-type';
            ANameValuePair.Value:= 'application/json';
            FNetHTTPRequestHeaders[0]:=ANameValuePair;
          end;



          try
              uBaseLog.HandleException(nil,'TDBHelperForElasticSearchDB.Connect '
                                            +'Server='+ADataBaseConfig.FDBHostName+' '
                                            +'Port='+ADataBaseConfig.FDBHostPort+' '
                                            +'Username='+ADataBaseConfig.FDBUserName+' '
                                            +'Password='+ADataBaseConfig.FDBPassword+' '
                                            +'Database='+ADataBaseConfig.FDBDataBaseName+' '
                                            );

              //连接数据库,ElasticSearch
              ANetHttpClient.Get(Self.ServerUrl+ADataBaseConfig.FDBDataBaseName,AResponseStream,FNetHTTPRequestHeaders);
              FDBInfo:=SO(AResponseStream.DataString);
              if FDBInfo.Contains('error') then
              begin
                Exit;
              end;
              //{
              //	"error": {
              //		"root_cause": [{
              //			"type": "index_not_found_exception",
              //			"reason": "no such index [user_center]",
              //			"resource.type": "index_or_alias",
              //			"resource.id": "user_center",
              //			"index_uuid": "_na_",
              //			"index": "user_center"
              //		}],
              //		"type": "index_not_found_exception",
              //		"reason": "no such index [user_center]",
              //		"resource.type": "index_or_alias",
              //		"resource.id": "user_center",
              //		"index_uuid": "_na_",
              //		"index": "user_center"
              //	},
              //	"status": 404
              //}

              Result:=True;
          except
            on E:Exception do
            begin
//              ShowException('数据库连接错误，请确认正确参数配置并重启服务端');
              uBaseLog.HandleException(nil,'TDBHelperForElasticSearchDB.Connect '+E.Message);
            end;
          end;

          FreeAndNil(AResponseStream);
end;

constructor TDBHelperForElasticSearchDB.Create;
begin
  Inherited;
  ANetHttpClient:=TNetHttpClient.Create(nil);
//  ANetHttpClient.ResponseTimeout:=10*60*1000;//10分钟
  FDataBaseConfig:=TDataBaseConfig.Create;

  SetLength(FNetHTTPRequestHeaders,0);

end;


destructor TDBHelperForElasticSearchDB.Destroy;
begin
  FreeAndNil(ANetHttpClient);
  FreeAndNil(FDataBaseConfig);
  inherited;
end;

function TDBHelperForElasticSearchDB.Disconnect: Boolean;
begin
  Result:=False;
  Result:=True;
end;

function TDBHelperForElasticSearchDB.DoAddRecord(ATableName, AID: String;
  ARecordDataJson: ISuperObject): Boolean;
var
  AUrl:String;
  ARequestStream:TStringStream;
  AResponseStream:TStringStream;
begin
  Result:=False;

  FResponseJson:=nil;

  ARequestStream:=TStringStream.Create('',TEncoding.UTF8);
  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try

        try



                ARequestStream.WriteString(ARecordDataJson.AsJSON);
                ARequestStream.Position:=0;

                AUrl:=Self.ServerUrl+Self.FDataBaseConfig.FDBDataBaseName+'/'+ATableName+'/'+AID;
                //PUT和POST都能新增修改
                //ANetHttpClient.Put(AUrl,ARequestStream,AResponseStream,FNetHTTPRequestHeaders);
                ANetHttpClient.Post(AUrl,ARequestStream,AResponseStream,FNetHTTPRequestHeaders);


                FResponseJson:=SO(AResponseStream.DataString);
                uBaseLog.HandleException(nil,'TDBHelperForElasticSearchDB.DoAddRecord '
                                            +' '+AUrl+' '+ARecordDataJson.AsJson
                                            +' '+AResponseStream.DataString);



                Result:=not FResponseJson.Contains('error');
                if not Result then
                begin
                  FLastExceptMessage:=FResponseJson.AsJSON;
                  uBaseLog.HandleException(nil,'TDBHelperForElasticSearchDB.DoAddRecord '
                                              +' '+AUrl+' '+ARecordDataJson.AsJson+' '+AResponseStream.DataString);
                end;


        except
            on E: Exception do
            begin
              Result:=False;
              //'Lost connection to MySQL server during query'#$D#$A'Error on data reading from the connection:'#$D#$A'你的主机中的软件中止了一个已建立的连接。.'#$D#$A'Socket Error Code: 10053($2745)'
              FLastExceptMessage:=E.Message;
              //      DoLog(E,'SelfQuery');
              uBaseLog.HandleException(E,'TDBHelperForElasticSearchDB.DoAddRecord '//+E.Message
                                          //上次使用时间,跟踪MYSQL是否在10分钟之内就断开连接了
                                          //+' '+FormatDateTime('YYYY-MM-DD HH:MM:SS:ZZZ',Self.FLastUseTime)
                                          +' '+AUrl+' '+ARecordDataJson.AsJson);


            end;
        end;

  finally
    FreeAndNil(ARequestStream);
    FreeAndNil(AResponseStream);
  end;


end;

function TDBHelperForElasticSearchDB.DoQueryBySearch(
  AQueryJsonStr: String//;AAPI:String
  ;AIsScroll:Boolean
  ): Boolean;
var
  AUrl:String;
  ARequestStream:TStringStream;
  AResponseStream:TStringStream;
begin
  Result:=False;

  FResponseJson:=nil;

  ARequestStream:=TStringStream.Create('',TEncoding.UTF8);
  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try

        try



                ARequestStream.WriteString(AQueryJsonStr);
                ARequestStream.Position:=0;

                //'_search?scroll=5m'
                if not AIsScroll then
                begin
                  AUrl:=Self.ServerUrl+Self.FDataBaseConfig.FDBDataBaseName+'/'+'_search?scroll=5m';
                end
                else
                begin
                  //'_search/scroll'
                  AUrl:=Self.ServerUrl+'_search/scroll';
                end;
                ANetHttpClient.Post(AUrl,ARequestStream,AResponseStream,FNetHTTPRequestHeaders);


                FResponseJson:=SO(AResponseStream.DataString);
//                uBaseLog.HandleException(nil,'TDBHelperForElasticSearchDB.DoQueryBySearch '
//                                            +' '+AUrl+' '+AQueryJsonStr+' '+AResponseStream.DataString);



                Result:=not FResponseJson.Contains('error');
                if not Result then
                begin
                  FLastExceptMessage:=FResponseJson.AsJSON;
                  uBaseLog.HandleException(nil,'TDBHelperForElasticSearchDB.DoQueryBySearch '
                                              +' '+AUrl+' '+AQueryJsonStr+' '+AResponseStream.DataString);
                end;


        except
          on E: Exception do
          begin
            Result:=False;
            //'Lost connection to MySQL server during query'#$D#$A'Error on data reading from the connection:'#$D#$A'你的主机中的软件中止了一个已建立的连接。.'#$D#$A'Socket Error Code: 10053($2745)'
            FLastExceptMessage:=E.Message;
            //      DoLog(E,'SelfQuery');
            uBaseLog.HandleException(E,'TDBHelperForElasticSearchDB.DoQueryBySearch '//+E.Message
                                        //上次使用时间,跟踪MYSQL是否在10分钟之内就断开连接了
                                        //+' '+FormatDateTime('YYYY-MM-DD HH:MM:SS:ZZZ',Self.FLastUseTime)
                                        +' '+AUrl+' '+AQueryJsonStr);


          end;
        end;

  finally
    FreeAndNil(ARequestStream);
    FreeAndNil(AResponseStream);
  end;



end;

function TDBHelperForElasticSearchDB.DoQueryBySQL(AQueryJson: ISuperObject): Boolean;
var
  ARequestStream:TStringStream;
  AResponseStream:TStringStream;
begin
  Result:=False;

  FResponseJson:=nil;

  ARequestStream:=TStringStream.Create('',TEncoding.UTF8);
  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try

        try



                ARequestStream.WriteString(AQueryJson.AsJSON);
                ARequestStream.Position:=0;

                ANetHttpClient.Post(Self.ServerUrl+'_sql',ARequestStream,AResponseStream,FNetHTTPRequestHeaders);


                FResponseJson:=SO(AResponseStream.DataString);


                Result:=not FResponseJson.Contains('error');
                if not Result then
                begin
                  FLastExceptMessage:=FResponseJson.AsJSON;
                  uBaseLog.HandleException(nil,'TDBHelperForElasticSearchDB.DoQueryBySQL '
                                              +' '+AResponseStream.DataString);
                end;


        except
          on E: Exception do
          begin
            Result:=False;
            //'Lost connection to MySQL server during query'#$D#$A'Error on data reading from the connection:'#$D#$A'你的主机中的软件中止了一个已建立的连接。.'#$D#$A'Socket Error Code: 10053($2745)'
            FLastExceptMessage:=E.Message;
            //      DoLog(E,'SelfQuery');
            uBaseLog.HandleException(E,'TDBHelperForElasticSearchDB.DoQueryBySQL '+E.Message
                                        //上次使用时间,跟踪MYSQL是否在10分钟之内就断开连接了
                                        +' '+FormatDateTime('YYYY-MM-DD HH:MM:SS:ZZZ',Self.FLastUseTime)
                                        +' '+AQueryJson.AsJSON);


          end;
        end;

  finally
    FreeAndNil(ARequestStream);
    FreeAndNil(AResponseStream);
  end;


end;

procedure TDBHelperForElasticSearchDB.UnlockConnectionToPool;
begin

end;

function TDBHelperForElasticSearchDB.GetConnectionFromPool: TObject;
begin

end;

function TDBHelperForElasticSearchDB.SelfQuery(AQueryString: String;
                                                AParamNames: TStringDynArray;
                                                AParamValues: TVariantDynArray;
                                                AOperation: TSQLOperation;
                                                AParamsCompleted:Boolean;
                                                ACustomQueryDataSet:TDataSet): Boolean;
var
  I: Integer;

  AIndex:Integer;
  AValueStr:String;
  ATempQuerySQL:String;
  AParams:ISuperObject;
//  StartTime,EndTime:TDateTime;
//  sParams : String;
begin
  Result:=False;

  FResponseJson:=nil;



//                HandleException(nil,'TDBHelperForElasticSearchDB.SelfQuery '+AQueryString);
                ATempQuerySQL:=AQueryString;

                AQueryString:=TransSelectSQL(AQueryString,DBType);
                //AQuery.Prepare;
                if Not AParamsCompleted then
                begin
                  for I:=Length(AParamNames)-1 downto 0 do
                  begin
                    if AParamNames[I]<>'' then
                    begin
//                        AQuery.Params.ParamByName(AParamNames[I]).Value:=AParamValues[I];
//
//
//                        //f,保存到日志文件中去
//                        try
//                            AIndex:=Pos(':'+AParamNames[I],ATempQuerySQL);
//                            AValueStr:=AParamValues[I];
//                            case VarType(AParamValues[I]) of
//                                varString, varUString:
//                                begin
//                                  AValueStr:=QuotedStr(AValueStr);
//                                end
//                                else
//                                begin
//
//                                end;
//                            end;
//
//                            if AIndex>0 then
//                            begin
//                              ATempQuerySQL:=Copy(ATempQuerySQL,1,AIndex-1)
//                                              +AValueStr
//                                              +Copy(ATempQuerySQL,AIndex+Length(AParamNames[I])+1{:的长度},MaxInt);
//                            end;
//                        except
//                           //避免出错
//                        end;


                    end;
                  end;
                end;


                if Length(AParamNames)>0 then
                begin
                    HandleException(nil,'TDBHelperForElasticSearchDB.SelfQuery '+ATempQuerySQL);

//                    if (Pos('INSERT',UpperCase(ATempQuerySQL))>0)
//                      or (Pos('UPDATE',UpperCase(ATempQuerySQL))>0)
//                      or (Pos('DELETE',UpperCase(ATempQuerySQL))>0) then
//                    begin
//                      GetGlobalDBLog.HandleException(nil,'TDBHelperForElasticSearchDB.SelfQuery '+ATempQuerySQL);
//                    end;
                end
                else
                begin
                    HandleException(nil,'TDBHelperForElasticSearchDB.SelfQuery '+AQueryString);
                end;


                AParams:=SO();
                AParams.S['query']:=AQueryString;

//                ARequestStream.WriteString(AParams.AsJSON);

//                case AOperation of
//                  asoOpen: AQuery.Open;
//                  asoExec:
//                  begin
//                      //AQuery.Prepare;
//                      AQuery.ExecSql;
//                  end;
//                end;
//                ANetHttpClient.Post(Self.ServerUrl+'_sql',ARequestStream,AResponseStream);

                Result:=DoQueryBySQL(AParams);


//                Result:=True;


end;


function TDBHelperForElasticSearchDB.ServerUrl: String;
begin
  Result:='http://'+FDataBaseConfig.FDBHostName+':'+FDataBaseConfig.FDBHostPort+'/';
end;

end.



