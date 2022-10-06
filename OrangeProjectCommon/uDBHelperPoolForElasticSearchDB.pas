//convert pas to utf8 by ¥
//Uni数据库操作类的线程池,用于连接MSSQL//
unit uDBHelperPoolForElasticSearchDB;


interface


uses
//  Windows,
  SysUtils,
  Classes,
//  Forms,
//  IniFiles,
//  DB,ADODB,
//  SyncObjs,



  uBaseLog,
  uDatabaseConfig,
  uDBHelperForElasticSearchDB,
  uObjectPool;


  //不使用kbmMWUNIDACConnectionPool
//  {$DEFINE NOT_USE_kbmMWUNIDACConnectionPool}


type
  TElasticSearchDBHelperPoolObject = class(TPoolObject)
  protected
    function CreateCustomObject: TObject; override;
  public
    FDBHelper:TElasticSearchDBHelper;
    destructor Destroy; override;
  end;



  TElasticSearchDBHelperPool=class(TObjectPool)
  protected
    function GetPoolItemClass: TPoolObjectClass; override;
  public
    //FMX,APP,一般不需要KBMMW的线程池控件
    FDBConfig:TDatabaseConfig;
  end;




//function GetGlobalSQLDBHelperPool
////  (AUnidacConnectionPool:TkbmMWUNIDACConnectionPool)
//  :TElasticSearchDBHelperPool;
//procedure FreeGlobalElasticSearchDBHelperPool;



implementation



//var
//  GlobalElasticSearchDBHelperPool: TElasticSearchDBHelperPool;
//
//function GetGlobalSQLDBHelperPool
////  (AUnidacConnectionPool:TkbmMWUNIDACConnectionPool)
//  :TElasticSearchDBHelperPool;
//begin
//  if GlobalElasticSearchDBHelperPool=nil then
//  begin
//    GlobalElasticSearchDBHelperPool:=TElasticSearchDBHelperPool.Create(nil);
////    GlobalElasticSearchDBHelperPool.FUnidacConnectionPool:=AUnidacConnectionPool;
//  end;
//  Result:=GlobalElasticSearchDBHelperPool;
//end;
//
//procedure FreeGlobalElasticSearchDBHelperPool;
//begin
//  FreeAndNil(GlobalElasticSearchDBHelperPool);
//end;









{ TElasticSearchDBHelperPool }

function TElasticSearchDBHelperPool.GetPoolItemClass: TPoolObjectClass;
begin
  Result:=TElasticSearchDBHelperPoolObject;
end;

{ TElasticSearchDBHelperPoolObject }

function TElasticSearchDBHelperPoolObject.CreateCustomObject: TObject;
var
  AProviderName:String;
  AElasticSearchDBHelperPool:TElasticSearchDBHelperPool;

begin
  Result:=nil;

  AElasticSearchDBHelperPool:=TElasticSearchDBHelperPool(Self.Collection.Owner);


  try

      FDBHelper:=TElasticSearchDBHelper.Create;//(AElasticSearchDBHelperPool.FUnidacConnectionPool);

      FDBHelper.Connect(AElasticSearchDBHelperPool.FDBConfig);





      Result:=FDBHelper;


  finally
  end;
end;


destructor TElasticSearchDBHelperPoolObject.Destroy;
begin

  inherited;
end;

end.



