unit uTaskManager;

interface

uses
  SysUtils,
  Classes,
  {$IFDEF MSWINDOWS}
  Windows,
  uCommandLineHelper,
  {$ENDIF}
//  Dialogs,
  uBaseList,
  uBaseLog,
  uFuncCommon,
  DateUtils,



  {$IF CompilerVersion <= 21.0} // XE or older
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



  SyncObjs,
  Math,

  uFileCommon,

//  uBaseDataBaseModule,
//  uBinaryObjectList,
  uOpenClientCommon,

//  uBaseDBHelper,
  uDataInterface,
  uDatasetToJson,


//  {$IFDEF HAS_LOCAL_DB_INTERFACE}
//  //ʹ�ñ������ݿ�ģʽ
//  uTableCommonRestCenter,
//  {$ELSE}
//  {$ENDIF}



  uRestInterfaceCall,
  uTimerTask;



const
  //��������
  //�˺ŵ�¼
  Const_TaskType_Login='Login';
  Const_TaskType_LoginSubWork='Login_SubWork';
  Const_TaskType_GetAccountInfo='GetAccountInfo';
  Const_TaskType_GetUserInfo='GetUserInfo';
  Const_TaskType_GetAccountInfoSubWork='GetAccountInfoSubWork';
  //�˺��˳���¼
  Const_TaskType_Logout='Logout';
  Const_TaskType_LogoutSubWork='Logout_SubWork';
  //��������
  Const_TaskType_UploadContent='UploadContent';
  Const_TaskType_UploadContentSubWork='UploadContent_SubWork';
  //ת������
  Const_TaskType_TransferContent='TransferContent';
  Const_TaskType_TransferContentSubWork='TransferContent_SubWork';
  //��������
  Const_TaskType_LikeContent='LikeContent';
  //��������
  Const_TaskType_CommentContent='CommentContent';
  //�û�����
  Const_TaskType_UserSearch='UserSearch';
  Const_TaskType_UserSearchSubWork='UserSearch_SubWork';
  //Ⱥ������
  Const_TaskType_GroupSearch='GroupSearch';
  Const_TaskType_GroupSearchSubWork='GroupSearch_SubWork';
  //��������
  Const_TaskType_ContentSearch='ContentSearch';
  Const_TaskType_ContentSearchSubWork='ContentSearch_SubWork';
  //��������
  Const_TaskType_CommentSearch='CommentSearch';
  Const_TaskType_CommentSearchSubWork='CommentSearch_SubWork';
  //������۹ؼ��ʶ���
  Const_TaskType_CommentSubscribe='CommentSubscribe';

  //LinkedIn��̬����
  Const_TaskType_DynamicSearch='DynamicSearch';
  Const_TaskType_DynamicSearchSubWork='DynamicSearch_SubWork';
  //LinkedIn����û�
  Const_TaskType_AddUser='AddUser';
  Const_TaskType_AddUserSubWork='AddUser_SubWork';
  //LinkedIn��ע��˾
  Const_TaskType_FollowCompany='FollowCompany';
  Const_TaskType_FollowCompanySubWork='FollowCompany_SubWork';
  //LinkedIn���Ⱥ��
  Const_TaskType_JoinGroup='AddGroup';
  Const_TaskType_JoinGroupSubWork='AddGroup_SubWork';
  //LinkedInɾ��Ⱥ��
  Const_TaskType_DeleteGroup='DeleteGroup';
  Const_TaskType_DeleteGroupSubWork='DeleteGroup_SubWork';
  //LinkedInȺ������
  Const_TaskType_GroupComment='GroupComment';
  Const_TaskType_GroupCommentSubWork='GroupComment_SubWork';

  //����˽��
  Const_TaskType_BatchChat='BatchChat';
  Const_TaskType_BatchChatSubWork='BatchChat_SubWork';


  //Ins��������
  Const_TaskType_TopicSearch='TopicSearch';
  Const_TaskType_TopicSearchSubWork='TopicSearch_SubWork';


const
//  DataFetchTask_TestLogin='TestLogin';
//  DataFetchTask_SearchTopic='SearchTopic';
//  DataFetchTask_TopicUserCollect='TopicUserCollect';
//  DataFetchTask_ContentLikersCollect='ContentLikersCollect';
//  DataFetchTask_ContentReviewersCollect='ContentReviewersCollect';
//  DataFetchTask_UserFansCollect='UserFansCollect';
//  DataFetchTask_UserFocusedCollect='UserFocusedCollect';
//  DataFetchTask_UserInfoCollect='UserInfoCollect';
  DataFetchTask_ContentSearch='ContentSearch';
  DataFetchTask_UserSearch='UserSearch';
  DataFetchTask_ContentSearchByUserList='ContentSearchByUserList';
  DataFetchTask_ContentTranslate='ContentTranslate';
  DataFetchTask_ContentUpload='ContentUpload';
//  DataFetchTask_BrandSearch='BrandSearch';
//
//  DataFetchTask_ContentsSearch='ContentsSearch';
//  DataFetchTask_ContentSearchByLink='ContentSearch_ByLink';
//  DataFetchTask_ContentSearchByIndustry='ContentSearch_ByIndustry';
//  DataFetchTask_ContentSearchByBrand='ContentSearch_ByBrand';






type
  TTaskManager=class;
  TTaskWorkThreadItem=class;
  TTaskItem=class;
  TThreadClass=class of TThread;
  TWorkThreadExecuteEvent=procedure(Sender:TObject;AWorkThreadItem:TTaskWorkThreadItem;ATaskItem:TTaskItem) of object;


  TProtectedThread=class(TThread)
  public
    property Terminated;
  end;


  TWorkThread=class(TProtectedThread)
  protected
    procedure Execute;override;
  public
    ThreadItem:TTaskWorkThreadItem;
  end;







  //�����߳�
  TTaskWorkThreadItem=class//(TThread)
  public
    TaskManager:TTaskManager;

    //��ǰ�߳���Ҫ����������
    TaskItem:TTaskItem;


    //��ǰ�������ӹ���
    WorkItem:TTaskItem;

    FThread:TWorkThread;
    FThreadClass:TThreadClass;
//    OnExecute:TWorkThreadExecuteEvent;


//    function GetCaption:String;virtual;


    //�����߼���ִ������ķ���
    //�Ȼ�ȡ�ӹ���,Ȼ�����DoExecuteWorkItem������,�������ٻ�ȡһ���ӹ���ȥ����


    //�����̺߳���
    procedure Execute;virtual;
        //�߳̿�ʼ��ʼ
        procedure DoExecuteBegin;virtual;
        //�Ƿ�����˳��߳���
        function CanExitThread:Boolean;virtual;
        //��ȡһ��������Ĺ���
        function GetTaskUnWorkItem
    //                  (AIsNeedCheckCanDoThisTask:Boolean=True)
                      :TTaskItem;virtual;
        //��������Ƿ����ִ��
        function CanDoThisTask(ATaskItem:TTaskItem):Boolean;virtual;
        //�����̹߳���
        procedure DoExecuteWorkItem;virtual;
        //�߳̽���
        procedure DoExecuteEnd;virtual;
        //�߳̿���
        procedure DoExecuteIdle;virtual;
    function CreateThread(ACreateSuspended:Boolean;ATaskItem:TTaskItem):TWorkThread;virtual;
    function GetLogID:String;
  public
    constructor Create(ACreateSuspended:Boolean;ATaskItem:TTaskItem;ATaskManager:TTaskManager);virtual;
    destructor Destroy;override;

  end;

  TTaskWorkThreadItems=class(TBaseList)
  public
  private
    function GetItem(Index: Integer): TTaskWorkThreadItem;
  public
    function FreeCount:Integer;
    property Items[Index:Integer]:TTaskWorkThreadItem read GetItem;default;
  end;







  TTaskWorkThreadItemClass=class of TTaskWorkThreadItem;
  TTaskList=class;
  TTaskCallback=procedure(Sender:TObject;AWorkThreadItem: TTaskWorkThreadItem;ATaskItem:TTaskItem;ADataIntfResult:TDataIntfResult) of object;
  TTaskState=(tsWaiting,
              tsWorking,//tsStop,
              tsFinished);
  //һ������,�����ȡ����,��ȡ�û���˿,��ȡ��������
  //�Լ����������
  TTaskItem=class
  public
//    fid:Integer;
//    AppID:Integer;
//    UserFID:String;
    FAppID:String;
    FUserFID:String;
  public
    //��ʼ������
    State:TTaskState;
  public
    //����ID
    GUID:String;
    //��������
    Name:String;
    //��������
    Type_:String;

    //����,����˵������Ҫ��������������
    Params:ISuperObject;
    DataObject:TObject;
    //��������
    DataJson:ISuperObject;
//    Data:Pointer;
//    DataStr:String;

    //�����������Э���߳���
    MaxWorkThreadCount:Integer;
    ParentTask:TTaskItem;

    ParentTaskGUID:String;
    RootTaskGUID:String;
    //��ʼʱ��
    StartTime:TDateTime;

    //�Ƿ��ȡ�����µ�����
    HasNewResultData:Boolean;

    Error:String;
  public
    function SaveToJson:ISuperObject;virtual;
    //�����������ݿ�,������ʷ,�Ա���Բ鿴
    function AddToDB(AAppID:String;
                      AUserFID:String;
//                      ADBModule:TBaseDatabaseModule;
                      var ADesc:String):Boolean;virtual;abstract;
    //���������״̬
    function UpdateStateToDB(AAppID:String;
                            AUserFID:String;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;
    //���������״̬
    function UpdateToDB(AAppID:String;
                            AUserFID:String;
                            ARecordDataJson:ISuperObject;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;
    //���������
    function AddSubWorkToDB(AAppID:String;
                            AUserFID:String;
                            ASubWorkGUID:String;
                            ASubWorkParmasStr:String;
                            ATaskType:String;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;
  public
    //ִ������
    procedure DoWorkInWorkThreadExecute(Sender:TObject;
                                        AWorkThreadItem:TTaskWorkThreadItem;
                                        ATaskItem:TTaskItem);virtual;

    //�������
    procedure DoFinishedInWorkThreadExecute(Sender:TObject;
                                            AWorkThreadItem:TTaskWorkThreadItem);virtual;


  public

    //�������Ĺ����߳���Ҫִ�еķ���
    OnWorkThreadExecute:TWorkThreadExecuteEvent;
    //��չ����,���ȷ���,�������ȽϺ�ʱ,��ô������¼���֪ͨ
    OnWorkThreadProgress:TTaskCallback;
    //��������¼�
    OnFinishedCallback:TTaskCallback;



    GetUnWorkLock:TCriticalSection;
    //�����б�
    Works:TTaskList;
    FWorkGUIDList:TStringList;
    //��ȡһ��δ�����Ĺ�����,׼������
    function GetUnWorkItem:TTaskItem;
    function UnWorkItemCount:Integer;
    function IsWorkFinished:Boolean;
  public
    Owner:TTaskManager;
    //�ӿ�ִ�з��صĽ��
    DataIntfResult:TDataIntfResult;

  public
    constructor Create(AOwner:TTaskManager);virtual;
    destructor Destroy;override;
  public
    //�������������Ĺ����߳��б�
    ThreadItems:TTaskWorkThreadItems;
    //�Ƿ���ͣ
    IsPause:Boolean;
    IsStop:Boolean;
    //���񷵻صĽ������
    ResultDataJson:ISuperObject;
    //��ʼ����,�����Լ��Ĺ����߳�
    procedure Start(ATaskWorkThreadItemClass:TTaskWorkThreadItemClass=nil);
    //ֹͣ�Լ��Ĺ����߳�
    procedure Stop;virtual;
    //��ͣ�Լ��Ĺ����߳�
    procedure Pause;virtual;
    //�����Լ��Ĺ����߳�
    procedure Resume;virtual;
  end;
  TTaskList=class(TBaseList)
  private
    function GetItem(Index: Integer): TTaskItem;
  public
    Owner:TTaskItem;
    function Add(AObject:TObject):Integer;override;
    function Find(ATaskGUID:String):TTaskItem;
    function UnWorkItemsCount:Integer;
    property Items[Index:Integer]:TTaskItem read GetItem;default;
  end;




  //����ͨ��Rest�ӿڱ��浽���ݿ������
  TTaskItem_SaveToRest=class(TTaskItem)
  public
    //ִ������,��������״̬,��������Ŀ�ʼʱ��
    procedure DoWorkInWorkThreadExecute(Sender:TObject;
                                        AWorkThreadItem:TTaskWorkThreadItem;
                                        ATaskItem:TTaskItem);override;

    //�������,��������״̬,��������Ľ���ʱ��
    procedure DoFinishedInWorkThreadExecute(Sender:TObject;
                                            AWorkThreadItem:TTaskWorkThreadItem);override;
    procedure Stop;override;
    procedure Pause;override;
    procedure Resume;override;
    //
    function AddToDB(AAppID:String;
                      AUserFID:String;
//                      ADBModule:TBaseDatabaseModule;
                      var ADesc:String):Boolean;override;
    function UpdateStateToDB(AAppID:String;
                            AUserFID:String;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;override;
    //���������
    function AddSubWorkToDB(AAppID:String;
                            AUserFID:String;
                            ASubWorkGUID:String;
                            ASubWorkParmasStr:String;
                            ATaskType:String;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;override;
    //���������״̬
    function UpdateToDB(AAppID:String;
                            AUserFID:String;
                            ARecordDataJson:ISuperObject;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;override;
  end;







  //��ѯ���¼������,ֻ��ѯһ��
  TGetRecordListTaskItem=class(TTaskItem_SaveToRest)
  protected
    procedure DoGetRecordListTask(Sender:TObject;
                                        AWorkThreadItem:TTaskWorkThreadItem;
                                        ATaskItem:TTaskItem;
                                        AWhereSQL:String);
    procedure DoWorkInWorkThreadExecute(Sender:TObject;
                                        AWorkThreadItem:TTaskWorkThreadItem;
                                        ATaskItem:TTaskItem);override;
  public
    //�ӿ�����
    FRestName:String;
    //��ѯ����
    FWhereSQL:String;
    FPageIndex:Integer;
    FPageSize:Integer;
  public
    constructor Create(AOwner:TTaskManager);override;
  end;



  //��ѯ����¼�¼�������ظ���ѯ
  TGetUpdatedRecordListTaskItem=class(TGetRecordListTaskItem)
  public
    FLastQueryResultDataUpdateTime:TDateTime;
    procedure DoWorkInWorkThreadExecute(Sender:TObject;
                                        AWorkThreadItem:TTaskWorkThreadItem;
                                        ATaskItem:TTaskItem);override;

  end;




  {$IFDEF MSWINDOWS}
  //Python����������
  TPythonCommandLineTaskItem=class(TTaskItem_SaveToRest)
  public
    //������
    FCommandLine:String;
    FCommandParams:String;
    FCommandLineOutputHelper:TCommandLineOutputHelper;
    //������Ϣ
    FPI: TProcessInformation;
    //����������,���ڴ��ܸ�������,
    FFunctionName:String;

    //��ȡ�������ݵ�����
    FProgressDataName:String;
    //�����еĲ�������
    FParamsJson:ISuperObject;
    procedure DoGetDataEvent(Sender:TObject;AData:String;ADataJson:ISuperObject);
    procedure DoWorkInWorkThreadExecute(Sender:TObject;
                                        AWorkThreadItem:TTaskWorkThreadItem;
                                        ATaskItem:TTaskItem);override;
  public
    constructor Create(AOwner:TTaskManager);override;
    destructor Destroy;override;
  end;



  //һ������,�����ȡ����,��ȡ�û���˿,��ȡ��������
  //�Լ����������
  TCommonTaskDataFetchTaskItem=class(TTaskItem_SaveToRest)
  public
    //��������
    FSpiderName:String;
    //���̹���·��
    FWorkDir:String;
    //������������־������¼�
    FOnGetCommandLineOutputEvent:TGetCommandLineOutputEvent;

//    {$IFDEF PYTHON_TASKMANAGER_MODE}
//    {$ELSE}
//      //ÿ�����񵥶�һ��python���̵�ģʽ
//      //ִ��������߳�
//      FExecuteSpiderCommandThread:TExecuteCommandThread;
//    {$ENDIF}


    //���ݱ���
    FDataTableNames:TStringList;

    //���ݱ�������
    FDataTableKeys:TStringList;
    //�ϴβ�ѯ������ID
    //���ڻ�ȡ���µ�����
    FLastQueryResultDataFID:Integer;

    //���ݱ�2
    FLastQueryResultDataFID2:Integer;
    FLastQueryResultDataUpdateTime:TDateTime;

    FCustomDataSelectWhereSQL:String;

    //��ѯ���ݵ�ʱ��OR����
    function GetDataRecordListSelectWhereSQL:String;
//    procedure Stop;override;
//    procedure Pause;override;
//    procedure Resume;override;
//
//    procedure DoUpdateTaskStateExecute(Sender:TObject);
  public
//    //��ֹ�������
//    procedure StopExecuteCommandThread;
  public
    constructor Create(AOwner:TTaskManager);override;
    destructor Destroy;override;
  end;
  TCommonTaskDataFetchTaskItemClass=class of TCommonTaskDataFetchTaskItem;
  {$ENDIF}




  //��ȡ������������߳�
  TRequestTaskThread=class(TThread)
  private
  public
    FTaskManager:TTaskManager;
    function NeedRequestTaskItem:Boolean;virtual;
    //��ȡһ��������Ĺ���
    function RequestTaskItem:TTaskItem;virtual;
    //�����̺߳���
    procedure Execute;override;
    constructor Create(ACreateSuspended:Boolean;ATaskManager:TTaskManager);
  end;




  //������ȡ�������
  TTaskManager=class
  public

    //��ǰ����ID
    FCurrentProcessId:String;

    //�����б�
    TaskList:TTaskList;
    FinishedTaskList:TTaskList;
    TaskWorkThreadItemClass:TTaskWorkThreadItemClass;

    //�̳߳�
    ThreadItems:TTaskWorkThreadItems;

    MaxThreadCount:Integer;

    FEventManager:TSkinObjectChangeManager;


    //���ݽӿڣ�����֧��SQL��֧��Rest
//    FDataInterface:TDataInterface;
    function CanDoThisTask(ATaskItem:TTaskItem):Boolean;virtual;
    //��ȡһ��������Ĺ���
    function GetUnWorkTaskItem(ATaskWorkThreadItem:TTaskWorkThreadItem)
//                  (AIsNeedCheckCanDoThisTask:Boolean=True)
                  :TTaskItem;virtual;
//    function CreateDataInterface:TDataInterface;virtual;abstract;
    procedure DoWorkThreadExecuteIdle;virtual;
    function GetMaxThreadCount:Integer;virtual;
    function CreateTaskWorkThreadItem:TTaskWorkThreadItem;virtual;

    //��ȡ�������ݵĽӿ���
    function CreateSaveDataInterface:TDataInterface;virtual;

    constructor Create;virtual;
    destructor Destroy;override;
  public
    function IsWorkThreadsSuspended:Boolean;virtual;
    procedure SuspendWorkThreads;virtual;
    procedure ResumeWorkThreads;virtual;

    procedure StartWorkThread;virtual;
    function StartTask(ATaskItem:TTaskItem//;
//                        //����ִ���¼�
//                        AWorkThreadExecute:TWorkThreadExecuteEvent;
//                        //����������ɺ�Ļص��¼�
//                        AFinishedCallback:TTaskCallback;
//                        //���������л�ȡ���������ݺ�Ļص��¼�
//                        AProgressCallback:TTaskCallback=nil;
//                        //������������Ҫ�Ĳ���
//                        AParams:ISuperObject=nil
                        ):TTaskItem;virtual;
    procedure StopTaskList;virtual;
    //���ݹ�������̵߳�����
    procedure SyncWorkThreadItems;

    //��ȡ״̬��־,Ҫ��ӡ����
    function GetStatusLog:String;virtual;
  end;




  //�������ִ��״̬��
  TQueryTaskStateItem=class(TTimerTask)
//    TaskGUID:String;
    FAppID:String;
    FUserFID:String;
    //����Ϊ��λ
    Timeout:Integer;
    //��ʼ��ѯ��ʱ��
    StartTime:TDateTime;
    //��ʼ������
    State:TTaskState;


    FExecuteTimerTask:TTimerTask;
    FTaskJson:ISuperObject;
  end;
//  TQueryTaskStateList=class(TBaseList)
//  private
//    function GetItem(Index: Integer): TQueryTaskStateItem;
//  public
//    property Items[Index:Integer]:TQueryTaskStateItem read GetItem;default;
//  end;
  //�������ִ��״̬�Ĺ�����
  TQueryTaskStateMananger=class(TTimerThread)
  protected
    //�������״̬
    function QueryTaskState(ATimerTask:TTimerTask):TTaskState;virtual;
    procedure DoExecute;override;
  public
    function AddQueryTask(AAppID:String;
                            AUserFID:String;
                            ATaskGUID:String;
                            AOnExecute:TTaskNotify;
                            AOnExecuteEnd:TTaskNotify;
                            ATimeout:Integer=60):TQueryTaskStateItem;overload;
    function AddQueryTask(AAppID:String;
                            AUserFID:String;
                            ATaskGUID:String;
                            AExecuteTimerTask:TTimerTask;
                            ATimeout:Integer=60):TQueryTaskStateItem;overload;

  end;








var
  GlobalQueryTaskStateMananger:TQueryTaskStateMananger;


  {$IFDEF MSWINDOWS}
//����HttpServer�ķ���˽���,��Щ�������Ҫ,��Щ����²���Ҫ
procedure StartContentHttpServerProgress(AHttpInterfacePort:Integer);
  {$ENDIF}

function GetGlobalQueryTaskStateMananger:TQueryTaskStateMananger;

implementation


  {$IFDEF MSWINDOWS}
procedure StartContentHttpServerProgress(AHttpInterfacePort:Integer);
begin
  //����HttpServer�Ľ���
  ExecuteCommandProcess('ContentHttpServer.exe',GetApplicationPath,IntToStr(AHttpInterfacePort));
end;
  {$ENDIF}



function GetGlobalQueryTaskStateMananger:TQueryTaskStateMananger;
begin
  if GlobalQueryTaskStateMananger=nil then
  begin
    GlobalQueryTaskStateMananger:=TQueryTaskStateMananger.Create(True);
  end;
  Result:=GlobalQueryTaskStateMananger;
end;




{ TTaskWorkThreadItems }

function TTaskWorkThreadItems.FreeCount: Integer;
var
  I: Integer;
begin
  Result:=0;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].WorkItem=nil then
    begin
      Inc(Result);
    end;
  end;
end;

function TTaskWorkThreadItems.GetItem(Index: Integer): TTaskWorkThreadItem;
begin
  Result:=TTaskWorkThreadItem(Inherited Items[Index]);
end;

{ TTaskItem }

constructor TTaskItem.Create(AOwner:TTaskManager);
begin
  GUID:=CreateGUIDString;

  ParentTaskGUID:='';
  RootTaskGUID:=GUID;

  Owner:=AOwner;
  ThreadItems:=TTaskWorkThreadItems.Create;
  MaxWorkThreadCount:=1;
  DataIntfResult:=TDataIntfResult.Create;
  Params:=TSuperObject.Create();
  DataJson:=SO();

  Works:=TTaskList.Create;
  Works.Owner:=Self;

  GetUnWorkLock:=TCriticalSection.Create;
  FWorkGUIDList:=TStringList.Create;

  ResultDataJson:=TSuperObject.Create;

  StartTime:=Now;
end;

//function TTaskItem.AddSubWorkToDB(AAppID: String; AUserFID: String;
//  ASubWorkGUID:String;
//  ASubWorkParmasStr:String;
////  ADBModule: TBaseDatabaseModule;
//  var ADesc: String): Boolean;
////var
////  ASQLDBHelper:TBaseDBHelper;
//
//begin
//  Result:=False;
//  ADesc:='';
//
////  if not ADBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
////  begin
////    Exit;
////  end;
////  try
////
//////    AParmasStr:='';
//////    if Params<>nil then
//////    begin
//////      AParmasStr:=Params.AsJSON;
//////    end;
////
//////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
//////                                           ['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count'],
//////                                           [AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,StdDateTimeToStr(Now),'',GUID,'',0,0]
//////                                            ) then
//////    begin
//////      //���ݿ�����ʧ�ܻ��쳣
//////      ADesc := '�������' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
//////      Exit;
//////    end;
////
////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
////                                           ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count']),
////                                           ConvertToVariantDynArray([AAppID,AUserFID,ASubWorkGUID,Type_,Name,ASubWorkParmasStr,0,StdDateTimeToStr(Now),GUID,GUID,IntToStr(GetCurrentProcessId),0,0]),
////                                           '',
////                                           asoExec,
////                                           nil
////                                            ) then
////    begin
////      //���ݿ�����ʧ�ܻ��쳣
////      ADesc := '����ӹ���' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////      Exit;
////    end;
////
////
////    FWorkGUIDList.Add(ASubWorkGUID);
////
////    //����������ӹ�����+1
////    if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET works_count=IFNULL(works_count,0)+1 WHERE task_guid='+QuotedStr(GUID),GetEmptyStringDynArray,GetEmptyVariantDynArray,asoExec) then
////    begin
////      //���ݿ�����ʧ�ܻ��쳣
////      ADesc := '����ӹ���' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////      Exit;
////    end;
////
////
////    Result:=True;
////  finally
////    ADBModule.FreeDBHelperToPool(ASQLDBHelper);
////  end;
//
//
//end;
//
//function TTaskItem.AddToDB(AAppID: String; AUserFID: String;
////  ADBModule:TBaseDatabaseModule;
//  var ADesc: String): Boolean;
//var
////  ASQLDBHelper:TBaseDBHelper;
//  AParmasStr:String;
//begin
//  Result:=False;
//  ADesc:='';
//
////  if not ADBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
////  begin
////    Exit;
////  end;
////  try
////
////    AParmasStr:='';
////    if Params<>nil then
////    begin
////      AParmasStr:=Params.AsJSON;
////    end;
////
//////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
//////                                           ['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count'],
//////                                           [AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,StdDateTimeToStr(Now),'',GUID,'',0,0]
//////                                            ) then
//////    begin
//////      //���ݿ�����ʧ�ܻ��쳣
//////      ADesc := '�������' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
//////      Exit;
//////    end;
////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
////                                           ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime']),
////                                           ConvertToVariantDynArray([AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,StdDateTimeToStr(Now)])
////                                            ) then
////    begin
////      //���ݿ�����ʧ�ܻ��쳣
////      ADesc := '�������' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////      Exit;
////    end;
////
////    Result:=True;
////  finally
////    ADBModule.FreeDBHelperToPool(ASQLDBHelper);
////  end;
//end;


destructor TTaskItem.Destroy;
begin
  uBaseLog.HandleException(nil,'TTaskItem.Destroy');


  //��������Stop,���ͷ�֮ǰStop
//  Self.Stop;



  FreeAndNil(DataIntfResult);
  FreeAndNil(ThreadItems);
  FreeAndNil(Works);
  FreeAndNil(GetUnWorkLock);
  FreeAndNil(FWorkGUIDList);
  inherited;
end;

procedure TTaskItem.DoFinishedInWorkThreadExecute(Sender: TObject;
  AWorkThreadItem: TTaskWorkThreadItem);
begin
  try


      if Assigned(Self.OnFinishedCallback) then
      begin
        Self.OnFinishedCallback(Self,AWorkThreadItem,Self,Self.DataIntfResult);
      end;


  except
    on E:Exception do
    begin
      Self.DataIntfResult.Desc:=E.Message;
      uBaseLog.HandleException(E,'TTaskItem.DoFinishedInWorkThreadExecute '+ClassName+' OnFinishedCallback Work:'+Self.Name+' Params:'+Self.Params.AsJSON);
    end;
  end;

end;

procedure TTaskItem.DoWorkInWorkThreadExecute(Sender: TObject;
  AWorkThreadItem: TTaskWorkThreadItem; ATaskItem: TTaskItem);
begin
  ATaskItem.StartTime:=Now;
  if Assigned(Self.OnWorkThreadExecute) then
  begin
    Self.OnWorkThreadExecute(Sender,AWorkThreadItem,ATaskItem);
  end;
end;

function TTaskItem.GetUnWorkItem: TTaskItem;
var
  I: Integer;
begin
  Result:=nil;

  GetUnWorkLock.Enter;
  try

    //����û�б���ͣ
    if not Self.IsPause then
    begin
        if Works.Count>0 then
        begin
          //��������
          for I := 0 to Works.Count-1 do
          begin
            if (Works[I].State=tsWaiting) and Self.Owner.CanDoThisTask(Works[I]) then
            begin
              Result:=Works[I];
              Break;
            end;
          end;

        end
        else
        begin
          if State=tsWaiting then
          begin
            Result:=Self;
          end;
        end;
    end;


    //������
    if Result<>nil then
    begin
      Result.State:=tsWorking;
    end;

  finally
    GetUnWorkLock.Leave;
  end;
end;

function TTaskItem.UnWorkItemCount: Integer;
var
  I: Integer;
begin
  Result:=0;

  GetUnWorkLock.Enter;
  try


    //����û�б���ͣ
    if not Self.IsPause then
    begin
        if Works.Count>0 then
        begin
          for I := 0 to Works.Count-1 do
          begin
            if Works[I].State=tsWaiting then
            begin
              Inc(Result);
            end;
          end;

        end
        else
        begin
          if State=tsWaiting then
          begin
            Inc(Result);
          end;
        end;
    end;


  finally
    GetUnWorkLock.Leave;
  end;


end;

//function TTaskItem.UpdateStateToDB(AAppID: String; AUserFID: String;
////  ADBModule: TBaseDatabaseModule;
//  var ADesc: String): Boolean;
//var
////  ASQLDBHelper:TBaseDBHelper;
//  AParmasStr:String;
//begin
//  Result:=False;
//  ADesc:='';
//
////  if not ADBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
////  begin
////    Exit;
////  end;
////  try
////
////    AParmasStr:='';
////    if Params<>nil then
////    begin
////      AParmasStr:=Params.AsJSON;
////    end;
////
////    if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET is_stop=:is_stop,is_pause=:is_pause WHERE task_guid=:task_guid',
////                                   ConvertToStringDynArray(['task_guid','is_stop','is_pause']),
////                                   ConvertToVariantDynArray([GUID,Ord(IsStop),Ord(IsPause)]),
////                                   asoExec
////                                    ) then
////    begin
////      //���ݿ�����ʧ�ܻ��쳣
////      ADesc := '��������״̬' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////      Exit;
////    end;
////
////
////    if IsStop then
////    begin
////      if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET state=''finished'' WHERE task_guid=:task_guid',
////                                     ConvertToStringDynArray(['task_guid']),
////                                     ConvertToVariantDynArray([GUID]),
////                                      asoExec
////                                      ) then
////      begin
////        //���ݿ�����ʧ�ܻ��쳣
////        ADesc := '��������״̬' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////        Exit;
////      end;
////    end;
////
////
////    Result:=True;
////  finally
////    ADBModule.FreeDBHelperToPool(ASQLDBHelper);
////  end;
//
//
//end;

function TTaskItem.IsWorkFinished: Boolean;
var
  I: Integer;
begin
  Result:=False;
  if Self.Works.Count>0 then
  begin
      for I := 0 to Works.Count-1 do
      begin
        if (Works[I].State<>tsFinished)
//          and (Works[I].State<>tsStop)
          then
        begin
          Exit;
        end;
      end;
      Result:=True;
  end
  else
  begin
      Result:=(Self.State=tsFinished)
              //or (Self.State=tsStop)
//              or (Self.IsStop)
              ;
  end;
end;

procedure TTaskItem.Pause;
var
  I: Integer;
begin

  IsPause:=True;


  for I := 0 to ThreadItems.Count-1 do
  begin
    ThreadItems[I].FThread.Suspended:=True;
  end;



end;

procedure TTaskItem.Resume;
var
  I: Integer;
begin

  IsPause:=False;

  for I := 0 to ThreadItems.Count-1 do
  begin
    ThreadItems[I].FThread.Suspended:=False;
  end;


end;

function TTaskItem.SaveToJson: ISuperObject;
begin
  Result:=SO();
  Result.I['appid']:=StrToInt(FAppID);
  Result.S['user_fid']:=FUserFID;
  Result.S['task_guid']:=GUID;
  Result.S['name']:=Name;
  Result.S['task_type']:=Type_;
  Result.O['params']:=Params;
  Result.O['data']:=DataJson;



//    FAppID:String;
//    FUserFID:String;
//  public
//    //��ʼ������
//    State:TTaskState;
//  public
//    //����ID
//    GUID:String;
//    //��������
//    Name:String;
//    //��������
//    Type_:String;
//
//    //����,����˵������Ҫ��������������
//    Params:ISuperObject;
//    DataObject:TObject;
////    Data:Pointer;
////    DataStr:String;
//
//    //�����������Э���߳���
//    MaxWorkThreadCount:Integer;
//    ParentTask:TTaskItem;
//
//    ParentTaskGUID:String;
//    RootTaskGUID:String;
//    StartTime:TDateTime;

end;

procedure TTaskItem.Start(ATaskWorkThreadItemClass:TTaskWorkThreadItemClass=nil);
var
  I:Integer;
  AWorkThreadItem:TTaskWorkThreadItem;
begin
  for I := 0 to MaxWorkThreadCount-1 do
  begin

    if ATaskWorkThreadItemClass<>nil then
    begin
      //������������߳�
      AWorkThreadItem:=ATaskWorkThreadItemClass.Create(False,Self,Owner);
    end
    else
    begin
      //������������߳�
      AWorkThreadItem:=Owner.TaskWorkThreadItemClass.Create(False,Self,Owner);
    end;



    ThreadItems.Add(AWorkThreadItem);

  end;
end;

procedure TTaskItem.Stop;
var
  I: Integer;
begin
  uBaseLog.HandleException(nil,'TTaskItem.Stop Begin');


  //��������
  IsStop:=True;
//  State:=tsFinished;

//  Self.State:=tsStop;


  for I := 0 to Self.Works.Count-1 do
  begin
//    Self.Works[I].State:=tsFinished;
//    Self.Works[I].IsStop:=True;
    Self.Works[I].Stop;
  end;


//  Self.DataIntfResult.Succ:=True;
//  try
//    if Assigned(Self.OnFinishedCallback) then
//    begin
//      Self.OnFinishedCallback(Self,Self,Self.DataIntfResult);
//    end;
//  except
//    on E:Exception do
//    begin
//      Self.DataIntfResult.Desc:=E.Message;
//      uBaseLog.HandleException(E,'TTaskItem.Stop OnFinishedCallback Task:'+Self.Name);
//    end;
//  end;
//  FreeAndNil(Self.DataIntfResult);



  //�������������Ĺ����߳��б�
  for I := 0 to ThreadItems.Count-1 do
  begin
    if not TProtectedThread(ThreadItems[I].FThread).Terminated then
    begin
//      ThreadItems[I].Terminate;
//      ThreadItems[I].WaitFor;
      ThreadItems[I].Free;
    end;
  end;
  ThreadItems.Clear(False);


  uBaseLog.HandleException(nil,'TTaskItem.Stop End');
end;

{ TTaskList }

function TTaskList.Add(AObject: TObject): Integer;
begin
  Result:=Inherited Add(AObject);

  TTaskItem(AObject).ParentTask:=Owner;
end;

function TTaskList.Find(ATaskGUID: String): TTaskItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].GUID=ATaskGUID then
    begin
      Result:=Items[I];
      Break;
    end;
    Result:=Items[I].Works.Find(ATaskGUID);
    if Result<>nil then
    begin
      Break;
    end;
  end;
end;

function TTaskList.GetItem(Index: Integer): TTaskItem;
begin
  Result:=TTaskItem(Inherited Items[Index]);
end;

function TTaskList.UnWorkItemsCount: Integer;
var
  I: Integer;
begin
  Result:=0;

  for I := 0 to Count-1 do
  begin
    Result:=Result+Items[I].UnWorkItemCount;
  end;
end;

{ TTaskManager }

function TTaskManager.CanDoThisTask(ATaskItem: TTaskItem): Boolean;
begin
  Result:=True;
end;

constructor TTaskManager.Create;
begin
  FCurrentProcessId:=CreateGUIDString();


  //�����б�
  TaskList:=TTaskList.Create;
  //����ɵ������б�
  FinishedTaskList:=TTaskList.Create();

  TaskWorkThreadItemClass:=TTaskWorkThreadItem;

//  FDataInterface:=Self.CreateDataInterface;

  MaxThreadCount:=1;
  //�̳߳�
  ThreadItems:=TTaskWorkThreadItems.Create;

  FEventManager:=TSkinObjectChangeManager.Create(nil);


end;

//function TTaskManager.CreateDataInterface: TDataInterface;
//begin
//  Result:=nil;
//end;

function TTaskManager.CreateTaskWorkThreadItem: TTaskWorkThreadItem;
begin
  Result:=TaskWorkThreadItemClass.Create(False,nil,Self);
end;

destructor TTaskManager.Destroy;
var
  I: Integer;
begin
  for I := 0 to ThreadItems.Count-1 do
  begin
    ThreadItems[I].Free;
  end;
  ThreadItems.Clear(False);


  FreeAndNil(ThreadItems);


  FreeAndNil(TaskList);

  FinishedTaskList.Clear(True);
  FreeAndNil(FinishedTaskList);

  FreeAndNil(FEventManager);

  inherited;
end;


procedure TTaskManager.DoWorkThreadExecuteIdle;
begin

end;

function TTaskManager.GetMaxThreadCount: Integer;
var
  AUnWorkItemsCount:Integer;
begin
  AUnWorkItemsCount:=Self.TaskList.UnWorkItemsCount;
  Result:=Min(AUnWorkItemsCount,MaxThreadCount);
end;


function TTaskManager.GetStatusLog: String;
begin
  Result:='��������������'+IntToStr(TaskList.Count)+#13#10
          +'�������������'+IntToStr(FinishedTaskList.Count)+#13#10
          +'����߳�����'+IntToStr(MaxThreadCount)+#13#10
          +'��ǰ�߳�����'+IntToStr(ThreadItems.Count)+#13#10;


end;

function TTaskManager.GetUnWorkTaskItem(ATaskWorkThreadItem:TTaskWorkThreadItem): TTaskItem;
var
  I:Integer;
  ATaskItem:TTaskItem;
begin
    Result:=nil;

    for I := 0 to Self.TaskList.Count-1 do
    begin
      ATaskItem:=Self.TaskList[I];
      if //(not AIsNeedCheckCanDoThisTask or AIsNeedCheckCanDoThisTask and CanDoThisTask(ATaskItem))
        CanDoThisTask(ATaskItem)
        and not ATaskItem.IsPause
        and not ATaskItem.IsWorkFinished then
      begin
        Result:=ATaskItem.GetUnWorkItem;

        if Result<>nil then
        begin
          ATaskWorkThreadItem.TaskItem:=ATaskItem;
          Self.TaskList.Remove(ATaskItem,False);
          Exit;
        end;

      end;

    end;
end;

function TTaskManager.IsWorkThreadsSuspended: Boolean;
var
  I: Integer;
begin
  Result:=True;
  for I := 0 to ThreadItems.Count-1 do
  begin
    Result:=Result and ThreadItems[I].FThread.Suspended;
  end;
end;

procedure TTaskManager.ResumeWorkThreads;
var
  I: Integer;
begin
  for I := 0 to ThreadItems.Count-1 do
  begin
    ThreadItems[I].FThread.Resume;
  end;
end;

function TTaskManager.CreateSaveDataInterface: TDataInterface;
begin
  Result:=GlobalDataInterfaceClass.Create;
end;

function TTaskManager.StartTask(ATaskItem:TTaskItem
//                                AWorkThreadExecute:TWorkThreadExecuteEvent;
//                                //����������ɺ�Ļص��¼�
//                                AFinishedCallback:TTaskCallback;
//                                //���������л�ȡ���������ݺ�Ļص��¼�
//                                AProgressCallback:TTaskCallback=nil;
//                                //������������Ҫ�Ĳ���
//                                AParams:ISuperObject=nil
                                ): TTaskItem;
begin
  Result:=ATaskItem;

//  Result.OnWorkThreadExecute:=AWorkThreadExecute;
//  Result.OnWorkThreadProgress:=AProgressCallback;
//  Result.OnFinishedCallback:=AFinishedCallback;
//
//  Result.Params:=AParams;
//  Result.MaxWorkThreadCount:=AMaxWorkThreadCount;

  Self.TaskList.Add(Result);



//  //�����񱣴浽���ݿ�
//  Result.AddToDB(AppID,
//                  UserFID,

  StartWorkThread;

end;

procedure TTaskManager.StartWorkThread;
var
//  ADesc:String;
  ATaskWorkThreadItem:TTaskWorkThreadItem;
begin

  //û�п��еĹ����߳̾ʹ���
  if ThreadItems.FreeCount=0 then
  begin
    ATaskWorkThreadItem:=CreateTaskWorkThreadItem;
    ThreadItems.Add(ATaskWorkThreadItem);
  end;

end;

procedure TTaskManager.StopTaskList;
var
  I:Integer;
begin
  for I := 0 to TaskList.Count-1 do
  begin
    TaskList[I].Stop;
  end;

end;

procedure TTaskManager.SuspendWorkThreads;
var
  I: Integer;
begin
  for I := 0 to ThreadItems.Count-1 do
  begin
    ThreadItems[I].FThread.Suspend;
  end;
end;

procedure TTaskManager.SyncWorkThreadItems;
var
  I: Integer;
  ANeedCreateCount:Integer;
  ATaskWorkThreadItem:TTaskWorkThreadItem;
begin
  ANeedCreateCount:=GetMaxThreadCount-Self.ThreadItems.Count;
  for I := 0 to ANeedCreateCount-1 do
  begin
    ATaskWorkThreadItem:=CreateTaskWorkThreadItem;
    ThreadItems.Add(ATaskWorkThreadItem);
  end;
end;

{ TTaskWorkThreadItem }

function TTaskWorkThreadItem.CanDoThisTask(ATaskItem: TTaskItem): Boolean;
begin
  Result:=Self.TaskManager.CanDoThisTask(ATaskItem);
end;

function TTaskWorkThreadItem.CanExitThread: Boolean;
begin
  Result:=False;//(WorkItem=nil);
end;

constructor TTaskWorkThreadItem.Create(ACreateSuspended: Boolean;
  ATaskItem: TTaskItem;ATaskManager:TTaskManager);
begin
  //Inherited Create(ACreateSuspended);

//  if AThreadClass=nil then
//  begin
//    AThreadClass:=TThread;
//  end;
//  FThread:=AThreadClass.Create(ACreateSuspended);

  //����һ���߳�
  FThread:=CreateThread(ACreateSuspended,ATaskItem);

  TaskItem:=ATaskItem;
  TaskManager:=ATaskManager;
//  OnExecute:=TaskItem.OnWorkThreadExecute;
end;

function TTaskWorkThreadItem.CreateThread(ACreateSuspended:Boolean;ATaskItem:TTaskItem): TWorkThread;
begin
  Result:=TWorkThread.Create(ACreateSuspended);
  TWorkThread(Result).ThreadItem:=Self;

end;

destructor TTaskWorkThreadItem.Destroy;
begin
  uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Destroy Begin');

  FThread.Terminate;
  FThread.WaitFor;
  FreeAndNil(FThread);


  inherited;
  uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Destroy End');
end;

procedure TTaskWorkThreadItem.DoExecuteBegin;
begin

end;

procedure TTaskWorkThreadItem.DoExecuteEnd;
begin

end;

procedure TTaskWorkThreadItem.DoExecuteIdle;
begin
  Sleep(3000);

  if TaskManager<>nil then
  begin
    TaskManager.DoWorkThreadExecuteIdle;
  end;

end;

procedure TTaskWorkThreadItem.DoExecuteWorkItem;
begin
  if Assigned(WorkItem.OnWorkThreadExecute) then
  begin
    WorkItem.DoWorkInWorkThreadExecute(Self,Self,WorkItem);
  end
  else
  begin
    TaskItem.DoWorkInWorkThreadExecute(Self,Self,WorkItem);
  end;
end;

procedure TTaskWorkThreadItem.Execute;
begin
  uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+Self.GetLogID+' Begin');






  try

      while not TProtectedThread(FThread).Terminated do
      begin


          //��ȡһ�����ʵ��˺�
          DoExecuteBegin;




          //�м�������,�Ϳ������˺źͼ����߳�һ���ȡ
          uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+Self.GetLogID+' ׼����ȡ����');

          //��Params�л�ȡһ��������Ĺ���
//          uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+ClassName+' TaskList Count ��������'+IntToStr(TaskManager.TaskList.Count));
          WorkItem:=GetTaskUnWorkItem;//TaskItem.GetUnWorkItem;




          if CanExitThread then//WorkItem=nil then
          begin
            Exit;
          end;




          if WorkItem<>nil then
          begin
              uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+Self.GetLogID+' ��ȡ������');

              try


                  if not TaskItem.IsStop then//����û�б�ֹͣ
                  begin
                      try

                         DoExecuteWorkItem;

                      except
                        on E:Exception do
                        begin
                          WorkItem.DataIntfResult.Desc:=E.Message;
                          uBaseLog.HandleException(E,'TTaskWorkThreadItem.Execute '+GetLogID+' OnExecute Work:'+WorkItem.Name+' Params:'+WorkItem.Params.AsJSON);
                        end;
                      end;
                  end
                  else
                  begin
                      uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+GetLogID+' ����ֹͣ��');
                      WorkItem.State:=tsFinished;
                  end;



                  //һ���ӹ����������¼�
                  if WorkItem.Works.Count=0 then//û���ӹ���
                  begin
                        WorkItem.DoFinishedInWorkThreadExecute(Self,Self);
                  end;


              finally


                  //���й�����ɾͱ�ʾ���������
                  if TaskItem.IsWorkFinished then
                  begin
                      uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+Self.GetLogID+' ����ִ�н�����');
                      TaskItem.State:=tsFinished;
                      TaskManager.FinishedTaskList.Add(TaskItem);
                  end;

                  if WorkItem<>TaskItem then
                  begin
                      uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+Self.GetLogID+' ��һ��������ִ�н�����');

                      if TaskItem.IsWorkFinished then
                      begin
//                          TaskManager.TaskList.Remove(TaskItem,False);
//                          TaskManager.FinishedTaskList.Add(TaskItem);


                          if TaskItem.DataIntfResult<>nil then TaskItem.DataIntfResult.Succ:=True;
                          TaskItem.DoFinishedInWorkThreadExecute(Self,Self);
//                          try
//
//
//                            if Assigned(TaskItem.OnFinishedCallback) then
//                            begin
//                              TaskItem.OnFinishedCallback(Self,Self,TaskItem,TaskItem.DataIntfResult);
//                            end;
//
//
//                          except
//                            on E:Exception do
//                            begin
//                              TaskItem.DataIntfResult.Desc:=E.Message;
//                              uBaseLog.HandleException(E,'TTaskWorkThreadItem.Execute '+ClassName+' OnFinishedCallback Task:'+TaskItem.Name);
//                            end;
//                          end;
                          FreeAndNil(TaskItem.DataIntfResult);


                      end;
                  end
                  else
                  begin
                      uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+Self.GetLogID+' ��һ��������ִ�н�����');
                  end;

              end;


          end
          else
          begin
              //����,��Ϣ
              uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+Self.GetLogID+' û��ȡ������');
//              uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+ClassName+' NO WorkItem, Can Sleep');
//              uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+ClassName+' Thread Count �����߳����� '+IntToStr(TaskManager.ThreadItems.Count));
              Sleep(3000);
              DoExecuteIdle;
          end;


      end;


  finally

    DoExecuteEnd;

  end;

  uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+GetLogID+' End');

end;


function TTaskWorkThreadItem.GetLogID: String;
begin
  Result:='�߳�'+IntToStr(Self.TaskManager.ThreadItems.IndexOf(Self));
end;

function TTaskWorkThreadItem.GetTaskUnWorkItem//(AIsNeedCheckCanDoThisTask:Boolean=True)
                                              : TTaskItem;
var
  I: Integer;
  ATaskItem:TTaskItem;
begin
  //�����߳�ģʽ���ж�ʹ��

  Result:=nil;

  if TaskItem<>nil then
  begin
    Result:=TaskItem.GetUnWorkItem;
  end;

  if Result<>nil then
  begin
    Exit;
  end;

  if TaskManager<>nil then
  begin
    Result:=TaskManager.GetUnWorkTaskItem(Self);
  end;


end;

{ TWorkThread }

procedure TWorkThread.Execute;
begin
  ThreadItem.Execute;

end;


{$IFDEF MSWINDOWS}

{ TCommonTaskDataFetchTaskItem }
constructor TCommonTaskDataFetchTaskItem.Create(AOwner: TTaskManager);
begin
  inherited;

  //���ݱ���
  FDataTableNames:=TStringList.Create;

  //���ݱ�������
  FDataTableKeys:=TStringList.Create;
end;

destructor TCommonTaskDataFetchTaskItem.Destroy;
begin
//  {$IFDEF PYTHON_TASKMANAGER_MODE}
//      //��פһ��Python��taskmanager.py�Ľ���,���ᶨʱ���������������
//  {$ELSE}
//      //ÿ�����񵥶�һ��python���̵�ģʽ
//      StopExecuteCommandThread;
//  {$ENDIF}

  FreeAndNil(FDataTableNames);
  FreeAndNil(FDataTableKeys);
  inherited;
end;

//procedure TCommonTaskDataFetchTaskItem.DoUpdateTaskStateExecute(
//  Sender: TObject);
//var
//  ADesc:String;
//begin
//  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.DoUpdateTaskStateExecute Begin');
//
//  //����Ῠ��,���Է��߳�������
//  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.DoUpdateTaskStateExecute UpdateStateToDB');
////  GlobalWebSearchTaskManager.DBModuleLock.Enter;
////  try
//    Self.UpdateStateToDB(GlobalWebSearchTaskManager.AppID,
//                            GlobalWebSearchTaskManager.UserFID,
////                            GlobalWebSearchTaskManager.DBModule,
//                            ADesc);
////  finally
////    GlobalWebSearchTaskManager.DBModuleLock.Leave;
////  end;
//
//  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.DoUpdateTaskStateExecute End');
//end;

function TCommonTaskDataFetchTaskItem.GetDataRecordListSelectWhereSQL: String;
begin

  if FCustomDataSelectWhereSQL='' then
  begin
    Result:=' AND task_guid='+QuotedStr(Self.GUID)+' ';
  end
  else
  begin
    Result:=FCustomDataSelectWhereSQL;
  end;
end;

//procedure TCommonTaskDataFetchTaskItem.Pause;
//var
//  ADesc:String;
//begin
//  inherited;
//
////  GlobalWebSearchTaskManager.DBModuleLock.Enter;
////  try
//    Self.UpdateStateToDB(FAppID,
//                        FUserFID,//GlobalBaseManager.User.fid,
////                        GlobalWebSearchTaskManager.DBModule,
//                        ADesc);
////  finally
////    GlobalWebSearchTaskManager.DBModuleLock.Leave;
////  end;
//
//end;
//
//procedure TCommonTaskDataFetchTaskItem.Resume;
//var
//  ADesc:String;
//begin
//  inherited;
//
//
////  GlobalWebSearchTaskManager.DBModuleLock.Enter;
////  try
//    Self.UpdateStateToDB(AppID,
//                        GlobalBaseManager.User.fid,
////                        GlobalWebSearchTaskManager.DBModule,
//                        ADesc);
////  finally
////    GlobalWebSearchTaskManager.DBModuleLock.Leave;
////  end;
//end;
//
//procedure TCommonTaskDataFetchTaskItem.Stop;
//var
//  ADesc:String;
//begin
//
//  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.Stop Begin');
//
//  inherited;
//
//
////  {$IFDEF PYTHON_TASKMANAGER_MODE}
////      //��פһ��Python��taskmanager.py�Ľ���,���ᶨʱ���������������
////  {$ELSE}
////      //ÿ�����񵥶�һ��python���̵�ģʽ
////      uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.Stop StopExecuteCommandThread');
////      StopExecuteCommandThread;
////  {$ENDIF}
//
//
////  GlobalWebSearchTaskManager.DBModuleLock.Enter;
////  try
//    Self.UpdateStateToDB(AppID,
//                        GlobalBaseManager.User.fid,
////                        GlobalWebSearchTaskManager.DBModule,
//                        ADesc);
////  finally
////    GlobalWebSearchTaskManager.DBModuleLock.Leave;
////  end;
//
////  GetGlobalTimerThread.RunTempTask(Self.DoUpdateTaskStateExecute,nil);
//
//
//  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.Stop End');
//end;

//procedure TCommonTaskDataFetchTaskItem.StopExecuteCommandThread;
//begin
//  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.StopExecuteCommandThread Begin');
//
//  {$IFDEF PYTHON_TASKMANAGER_MODE}
//      //��פһ��Python��taskmanager.py�Ľ���,���ᶨʱ���������������
//  {$ELSE}
//      //ÿ�����񵥶�һ��python���̵�ģʽ
//      if FExecuteSpiderCommandThread<>nil then
//      begin
//        //�ֶ���ֹ����
//        //ÿ��python�����Լ����̻߳��������Ƿ�ֹͣ�����ֹͣ��ִֹͣ��
//        //    if FExecuteSpiderCommandThread.FPI.hProcess>0 then
//        //    begin
//        //      uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.StopExecuteCommandThread TerminateProcess Begin');
//        //      TerminateProcess(FExecuteSpiderCommandThread.FPI.hProcess,0);
//        //      uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.StopExecuteCommandThread TerminateProcess End');
//        //    end;
//
//        //scrapy����TaskListenThread����ʱ��������״̬,���Ϊstop����finished
//        //��ô�����Զ���ֹ����
//        FExecuteSpiderCommandThread.Terminate;
//        FExecuteSpiderCommandThread.WaitFor;
//        FreeAndNil(FExecuteSpiderCommandThread);
//      end;
//  {$ENDIF}
//
//  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.StopExecuteCommandThread End');
//end;
{$ENDIF}


{ TTaskItem_SaveToRest }

function TTaskItem_SaveToRest.AddSubWorkToDB(AAppID: String; AUserFID,
  ASubWorkGUID, ASubWorkParmasStr: String;
  ATaskType:String;
  var ADesc: String): Boolean;
var
  ACode:Integer;
  ADataJson:ISuperObject;
  AParmasStr:String;
  ARecordDataJson:ISuperObject;
  AStringStream:TStringStream;

  ADataInterface:TDataInterface;
  ASaveDataSetting:TSaveDataSetting;
  ADataIntfResult:TDataIntfResult;
begin
  Result:=False;
  ADesc:='';


  AParmasStr:='';
  if Params<>nil then
  begin
    AParmasStr:=Params.AsJSON;
  end;

  if ATaskType='' then
  begin
    ATaskType:=Type_;
  end;

  ARecordDataJson:=SO();
  uDatasetToJson.ConvertArrayToJson(
      ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count']),
      ConvertToVariantDynArray([AAppID,AUserFID,ASubWorkGUID,ATaskType,Name+'_SubWork',ASubWorkParmasStr,0,StdDateTimeToStr(Now),GUID,GUID,Self.Owner.FCurrentProcessId,0,0]),
      ARecordDataJson
      );
  AParmasStr:=ARecordDataJson.AsJSON;


  {$IFDEF HAS_LOCAL_DB_INTERFACE}
//  //ʹ�ñ������ݿ�ģʽ
//  GlobalCommonRestIntfList.Find('task').AddRecord(GlobalCommonRestIntfList.Find('task').DBModule,
//                                                  nil,AAppID,ARecordDataJson,nil,ACode,ADesc,ADataJson);


  //ʹ�ñ������ݿ�ģʽ
  ADataInterface:=Self.Owner.CreateSaveDataInterface;
  ADataInterface.Name:='task';
  ADataIntfResult:=TDataIntfResult.Create;
  try
    ASaveDataSetting.Clear;
    ASaveDataSetting.AppID:=AAppID;
    ASaveDataSetting.RecordDataJson:=ARecordDataJson;
    if not ADataInterface.SaveData(ASaveDataSetting,ADataIntfResult) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.AddToDB ��������add_record_post_2 '+ADesc);
      Exit;
    end;

  finally
    FreeAndNil(ADataInterface);
    FreeAndNil(ADataIntfResult);
  end;

  {$ELSE}

  AStringStream:=TStringStream.Create(AParmasStr,TEncoding.UTF8);
  AStringStream.Position:=0;
  try


    if not SimpleCallAPI('add_record_post_2',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ConvertToStringDynArray(['appid',
                                                'user_fid',
                                                'key',
                                                'rest_name'//,
                        //                        'record_data_json'
                                                ]),
                        ConvertToVariantDynArray([AAppID,
                                                  0,
                                                  '',
                                                  'task'//,
                          //                        AParmasStr
                                                  ]),
                        ACode,
                        ADesc,
                        ADataJson,
                        GlobalRestAPISignType,
                        GlobalRestAPIAppSecret,
                        True,
                        AStringStream
                        ) or (ACode<>200) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.AddSubWorkToDB ���������add_record_post_2 '+ADesc);
      Exit;
    end;




  finally
    FreeAndNil(AStringStream);
  end;

  {$ENDIF}


  Result:=True;


end;

procedure TTaskItem_SaveToRest.Pause;
var
  ADesc:String;
begin
  inherited;

//  GlobalWebSearchTaskManager.DBModuleLock.Enter;
//  try
    Self.UpdateStateToDB(FAppID,
                        FUserFID,//GlobalBaseManager.User.fid,
//                        GlobalWebSearchTaskManager.DBModule,
                        ADesc);
//  finally
//    GlobalWebSearchTaskManager.DBModuleLock.Leave;
//  end;

end;

procedure TTaskItem_SaveToRest.Resume;
var
  ADesc:String;
begin
  inherited;


//  GlobalWebSearchTaskManager.DBModuleLock.Enter;
//  try
    Self.UpdateStateToDB(FAppID,
                        FUserFID,//GlobalBaseManager.User.fid,
//                        GlobalWebSearchTaskManager.DBModule,
                        ADesc);
//  finally
//    GlobalWebSearchTaskManager.DBModuleLock.Leave;
//  end;
end;

procedure TTaskItem_SaveToRest.Stop;
var
  ADesc:String;
begin

  uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.Stop Begin');

  inherited;


//  {$IFDEF PYTHON_TASKMANAGER_MODE}
//      //��פһ��Python��taskmanager.py�Ľ���,���ᶨʱ���������������
//  {$ELSE}
//      //ÿ�����񵥶�һ��python���̵�ģʽ
//      uBaseLog.HandleException(nil,'TCommonTaskDataFetchTaskItem.Stop StopExecuteCommandThread');
//      StopExecuteCommandThread;
//  {$ENDIF}


//  GlobalWebSearchTaskManager.DBModuleLock.Enter;
//  try
    Self.UpdateStateToDB(FAppID,
                        FUserFID,//GlobalBaseManager.User.fid,
//                        GlobalWebSearchTaskManager.DBModule,
                        ADesc);
//  finally
//    GlobalWebSearchTaskManager.DBModuleLock.Leave;
//  end;

//  GetGlobalTimerThread.RunTempTask(Self.DoUpdateTaskStateExecute,nil);


  uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.Stop End');
end;

function TTaskItem_SaveToRest.AddToDB(AAppID: String; AUserFID: String;
//  ADBModule: TBaseDatabaseModule;
  var ADesc: String): Boolean;
var
//  ASQLDBHelper:TBaseDBHelper;
  ACode:Integer;
  ADataJson:ISuperObject;
  AParmasStr:String;
  ARecordDataJson:ISuperObject;
  AStringStream:TStringStream;

  ADataInterface:TDataInterface;
  ASaveDataSetting:TSaveDataSetting;
  ADataIntfResult:TDataIntfResult;
begin
  Result:=False;
  ADesc:='';

//'appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count']),
//[AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,StdDateTimeToStr(Now),'',GUID,GlobalWebSearchTaskManager.FCurrentProcessId,0,0])


  AParmasStr:='';
  if Params<>nil then
  begin
    AParmasStr:=Params.AsJSON;//(False,False);
//    uBaseLog.HandleException(nil,'AParmasStr:'+AParmasStr);
//    AParmasStr:=ReplaceStr(AParmasStr,'\/','/');
//    uBaseLog.HandleException(nil,'AParmasStr:'+AParmasStr);
//    AParmasStr:=Params.AsJSON(True,True);
//    uBaseLog.HandleException(nil,'AParmasStr:'+AParmasStr);
//    AParmasStr:=Params.AsJSON(False,True);
//    uBaseLog.HandleException(nil,'AParmasStr:'+AParmasStr);
//    AParmasStr:=Params.AsJSON(True,False);
//    uBaseLog.HandleException(nil,'AParmasStr:'+AParmasStr);
//    ShowMessage(AParmasStr);
  end;

  ARecordDataJson:=SO();
  uDatasetToJson.ConvertArrayToJson(
      ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count']),
      ConvertToVariantDynArray([AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,StdDateTimeToStr(Now),ParentTaskGUID,RootTaskGUID,Self.Owner.FCurrentProcessId,0,0]),
      ARecordDataJson
      );
  AParmasStr:=ARecordDataJson.AsJSON;//(False,False);
  uBaseLog.HandleException(nil,'ARecordDataJson:'+AParmasStr);
//  AParmasStr:=ReplaceStr(AParmasStr,'\/','/');
//  uBaseLog.HandleException(nil,'ARecordDataJson:'+AParmasStr);






  {$IFDEF HAS_LOCAL_DB_INTERFACE}
  //ʹ�ñ������ݿ�ģʽ
  ADataInterface:=Self.Owner.CreateSaveDataInterface;
  ADataInterface.Name:='task';
  ADataIntfResult:=TDataIntfResult.Create;
  try
    ASaveDataSetting.Clear;
    ASaveDataSetting.AppID:=AAppID;
    ASaveDataSetting.RecordDataJson:=ARecordDataJson;
    if not ADataInterface.SaveData(ASaveDataSetting,ADataIntfResult) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.AddToDB ��������add_record_post_2 '+ADesc);
      Exit;
    end;

  finally
    FreeAndNil(ADataInterface);
    FreeAndNil(ADataIntfResult);
  end;
  {$ELSE}
  AStringStream:=TStringStream.Create(AParmasStr,TEncoding.UTF8);
  AStringStream.Position:=0;
  try

    if not SimpleCallAPI('add_record_post_2',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ConvertToStringDynArray(['appid',
                                                'user_fid',
                                                'key',
                                                'rest_name'//,
//                                                'record_data_json'
                                                ]),
                        ConvertToVariantDynArray([AAppID,
                                                  0,
                                                  '',
                                                  'task'//,
//                                                  AParmasStr//(False,False)
                                                  ]),
                        ACode,
                        ADesc,
                        ADataJson,
                        GlobalRestAPISignType,
                        GlobalRestAPIAppSecret,
                        True,
                        AStringStream
                        ) or (ACode<>200) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.AddToDB ��������add_record_post_2 '+ADesc);
      Exit;
    end;

  finally
    FreeAndNil(AStringStream);
  end;
  {$ENDIF}



//  if not ADBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
//  begin
//    Exit;
//  end;
//  try
//
//    AParmasStr:='';
//    if Params<>nil then
//    begin
//      AParmasStr:=Params.AsJSON;
//    end;
//
//    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
//                                           ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count']),
//                                           ConvertToVariantDynArray([AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,StdDateTimeToStr(Now),'',GUID,GlobalWebSearchTaskManager.FCurrentProcessId,0,0])
//                                            ) then
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc := '�������' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
//      Exit;
//    end;
////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
////                                           ['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime'],
////                                           [AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,StdDateTimeToStr(Now)]
////                                            ) then
////    begin
////      //���ݿ�����ʧ�ܻ��쳣
////      ADesc := '�������' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////      Exit;
////    end;

    Result:=True;
//  finally
//    ADBModule.FreeDBHelperToPool(ASQLDBHelper);
//  end;

end;

procedure TTaskItem_SaveToRest.DoFinishedInWorkThreadExecute(Sender: TObject;
  AWorkThreadItem: TTaskWorkThreadItem);
var
//  ACode:Integer;
  ADesc:String;
//  ADataJson:ISuperObject;
//  ARecordDataJson:ISuperObject;
begin
  inherited;

//  //�����������ʱ��
//  ARecordDataJson:=SO();
//  ARecordDataJson.S['end_time']:=StdDateTimeToStr(Now);
//  UpdateToDB(FAppID,FUserFID,ARecordDataJson,ADesc);


  UpdateStateToDB(FAppID,FUserFID,ADesc);

//  SimpleCallAPI('update_record',
//                      nil,
//                      TableRestCenterInterfaceUrl,
//                      ConvertToStringDynArray(['appid',
//                                              'user_fid',
//                                              'key',
//                                              'rest_name',
//                                              'record_data_json',
//                                              'where_sql']),
//                      ConvertToVariantDynArray([AppID,
//                                                0,
//                                                '',
//                                                'task',
//                                                ARecordDataJson.AsJSON,
//                                                ' AND task_guid='+QuotedStr(Self.GUID)+' ']),
//                      ACode,
//                      ADesc,
//                      ADataJson,
//                      GlobalRestAPISignType,
//                      GlobalRestAPIAppSecret
//                      );
//

end;

procedure TTaskItem_SaveToRest.DoWorkInWorkThreadExecute(Sender: TObject;
  AWorkThreadItem: TTaskWorkThreadItem; ATaskItem: TTaskItem);
var
//  ACode:Integer;
  ADesc:String;
//  ADataJson:ISuperObject;
  ARecordDataJson:ISuperObject;
begin
  //��������ʼʱ��
  ARecordDataJson:=SO();
  ARecordDataJson.S['start_time']:=StdDateTimeToStr(Now);
  ATaskItem.UpdateToDB(FAppID,FUserFID,ARecordDataJson,ADesc);
//  SimpleCallAPI('update_record',
//                      nil,
//                      TableRestCenterInterfaceUrl,
//                      ConvertToStringDynArray(['appid',
//                                              'user_fid',
//                                              'key',
//                                              'rest_name',
//                                              'record_data_json',
//                                              'where_sql']),
//                      ConvertToVariantDynArray([AppID,
//                                                0,
//                                                '',
//                                                'task',
//                                                ARecordDataJson.AsJSON,
//                                                ' AND task_guid='+QuotedStr(ATaskItem.GUID)+' ']),
//                      ACode,
//                      ADesc,
//                      ADataJson,
//                      GlobalRestAPISignType,
//                      GlobalRestAPIAppSecret
//                      );
//

  inherited;

end;


function TTaskItem_SaveToRest.UpdateStateToDB(AAppID: String;
  AUserFID: String;
//  ADBModule: TBaseDatabaseModule;
  var ADesc: String): Boolean;
var
  ACode:Integer;
//  ADesc:String;
  ADataJson:ISuperObject;

//  ASQLDBHelper:TBaseDBHelper;
  AParmasStr:String;
  ARecordDataJson:ISuperObject;

//  AStopTaskItem:TTaskItem_SaveToRest;
  AParams:ISuperObject;

  ADataInterface:TDataInterface;
  ASaveDataSetting:TSaveDataSetting;
  ADataIntfResult:TDataIntfResult;

begin
  Result:=False;
  ADesc:='';

//  if not ADBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
//  begin
//    Exit;
//  end;
//  try

    AParmasStr:='';
    if Params<>nil then
    begin
      AParmasStr:=Params.AsJSON;
    end;

//    if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET is_stop=:is_stop,is_pause=:is_pause WHERE task_guid=:task_guid',
//                                   ConvertToStringDynArray(['task_guid','is_stop','is_pause']),
//                                   ConvertToVariantDynArray([GUID,Ord(IsStop),Ord(IsPause)]),
//                                   asoExec
//                                    ) then
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc := '��������״̬' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
//      Exit;
//    end;

    ARecordDataJson:=SO();
    ARecordDataJson.I['is_stop']:=Ord(IsStop);
    ARecordDataJson.I['is_pause']:=Ord(IsPause);

    if IsStop or (Self.State=tsFinished) then
    begin
      ARecordDataJson.S['state']:='finished';
      ARecordDataJson.S['end_time']:=StdDateTimeToStr(Now);
      //������ʱ���,���統ǰ�����ж�ʱ���±ꡢ�Ƿ�����һҳ
      ARecordDataJson.S['result_data_json']:=Self.ResultDataJson.AsJSON;
    end;

    ARecordDataJson.S['error']:=Error;


  {$IFDEF HAS_LOCAL_DB_INTERFACE}
  //ʹ�ñ������ݿ�ģʽ
  ADataInterface:=Self.Owner.CreateSaveDataInterface;
  ADataInterface.Name:='task';
  ADataInterface.FKeyFieldName:='task_guid';
  ADataIntfResult:=TDataIntfResult.Create;
  try
    ASaveDataSetting.Clear;
    ASaveDataSetting.AppID:=AAppID;
    ASaveDataSetting.EditingRecordKeyValue:=GUID;
    ASaveDataSetting.RecordDataJson:=ARecordDataJson;
    if not ADataInterface.SaveData(ASaveDataSetting,ADataIntfResult) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.UpdateStateToDB ��������״̬update_record '+ADataIntfResult.Desc);
      Exit;
    end;

  finally
    FreeAndNil(ADataInterface);
    FreeAndNil(ADataIntfResult);
  end;
  {$ELSE}

    if not SimpleCallAPI('update_record',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ConvertToStringDynArray(['appid',
                                                'user_fid',
                                                'key',
                                                'rest_name',
                                                'record_data_json',
                                                'where_sql']),
                        ConvertToVariantDynArray([AAppID,
                                                  0,
                                                  '',
                                                  'task',
                                                  ARecordDataJson.AsJSON,
                                                  ' AND task_guid='+QuotedStr(GUID)+' ']),
                        ACode,
                        ADesc,
                        ADataJson,
                        GlobalRestAPISignType,
                        GlobalRestAPIAppSecret
                        ) or (ACode<>200) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.UpdateStateToDB ��������״̬update_record '+ADesc);
      Exit;
    end;
  {$ENDIF}




//    if Self.IsStop then
//    begin
//
//      //����ֹͣ���������
//      //ֹͣ����Ľ���
//      AParams:=TSuperObject.Create;
//      AParams.S['task_guid']:=Self.GUID;
//
//
//      AStopTaskItem:=TTaskItem_SaveToRest.Create(Self.Owner);
//      try
//        AStopTaskItem.GUID:=CreateGUIDString();
//        AStopTaskItem.Type_:='stop_task';
//        AStopTaskItem.Params:=AParams;
//        AStopTaskItem.AddToDB(AppID,GlobalBaseManager.User.fid,ADesc);
//      finally
//        FreeAndNil(AStopTaskItem);
//      end;
//
//
//    end;






//    if IsStop then
//    begin
////      if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET state=''finished'' WHERE task_guid=:task_guid',
////                                     ConvertToStringDynArray(['task_guid']),
////                                     ConvertToVariantDynArray([GUID]),
////                                      asoExec
////                                      ) then
////      begin
////        //���ݿ�����ʧ�ܻ��쳣
////        ADesc := '��������״̬' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////        Exit;
////      end;
//        ARecordDataJson:=TSuperObject.Create;
//        ARecordDataJson.S['state']:='finished';
//        if not SimpleCallAPI('update_record',
//                            nil,
//                            TableRestCenterInterfaceUrl,
//                            ['appid',
//                            'user_fid',
//                            'key',
//                            'rest_name',
//                            'record_data_json',
//                            'where_sql'],
//                            [AAppID,
//                            0,
//                            '',
//                            'task',
//                            ARecordDataJson.AsJSON,
//                            ' AND task_guid='+QuotedStr(GUID)+' '
//                            ],
//                            ACode,
//                            ADesc,
//                            ADataJson,
//                            GlobalRestAPISignType,
//                            GlobalRestAPIAppSecret
//                            ) or (ACode<>200) then
//        begin
//          ShowMessage(ADesc);
//          Exit;
//        end;
//    end;


    Result:=True;
//  finally
//    ADBModule.FreeDBHelperToPool(ASQLDBHelper);
//  end;


end;

function TTaskItem_SaveToRest.UpdateToDB(AAppID:String;
                                        AUserFID:String;
                                        ARecordDataJson: ISuperObject;
                                        var ADesc: String): Boolean;
var
  ACode:Integer;
//  ADesc:String;
  ADataJson:ISuperObject;

//  ASQLDBHelper:TBaseDBHelper;
  AParmasStr:String;
//  ARecordDataJson:ISuperObject;
  ADataInterface:TDataInterface;
  ASaveDataSetting:TSaveDataSetting;
  ADataIntfResult:TDataIntfResult;
begin
  Result:=False;
  ADesc:='';

//  if not ADBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
//  begin
//    Exit;
//  end;
//  try

    AParmasStr:='';
    if Params<>nil then
    begin
      AParmasStr:=Params.AsJSON;
    end;





//    if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET is_stop=:is_stop,is_pause=:is_pause WHERE task_guid=:task_guid',
//                                   ConvertToStringDynArray(['task_guid','is_stop','is_pause']),
//                                   ConvertToVariantDynArray([GUID,Ord(IsStop),Ord(IsPause)]),
//                                   asoExec
//                                    ) then
//    begin
//      //���ݿ�����ʧ�ܻ��쳣
//      ADesc := '��������״̬' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
//      Exit;
//    end;




  {$IFDEF HAS_LOCAL_DB_INTERFACE}
  //ʹ�ñ������ݿ�ģʽ
  ADataInterface:=Self.Owner.CreateSaveDataInterface;
  ADataInterface.Name:='task';
  ADataInterface.FKeyFieldName:='task_guid';
  ADataIntfResult:=TDataIntfResult.Create;
  try
    ASaveDataSetting.Clear;
    ASaveDataSetting.AppID:=AAppID;
    ASaveDataSetting.EditingRecordKeyValue:=GUID;
    ASaveDataSetting.RecordDataJson:=ARecordDataJson;
    if not ADataInterface.SaveData(ASaveDataSetting,ADataIntfResult) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TTaskItem_SaveToRest.UpdateStateToDB ��������״̬update_record '+ADataIntfResult.Desc);
      Exit;
    end;

  finally
    FreeAndNil(ADataInterface);
    FreeAndNil(ADataIntfResult);
  end;
  {$ELSE}


    if not SimpleCallAPI('update_record',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ConvertToStringDynArray(['appid',
                                                'user_fid',
                                                'key',
                                                'rest_name',
                                                'record_data_json',
                                                'where_sql']),
                        ConvertToVariantDynArray([AAppID,
                                                  0,
                                                  '',
                                                  'task',
                                                  ARecordDataJson.AsJSON,
                                                  ' AND task_guid='+QuotedStr(GUID)+' ']),
                        ACode,
                        ADesc,
                        ADataJson,
                        GlobalRestAPISignType,
                        GlobalRestAPIAppSecret
                        ) or (ACode<>200) then
    begin
//      ShowMessage(ADesc);
      uBaseLog.HandleException(nil,'TWebSearchTaskManager.TTaskItem_SaveToRest.UpdateToDB ��������update_record '+ADesc);
      Exit;
    end;
  {$ENDIF}



//    if IsStop then
//    begin
////      if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET state=''finished'' WHERE task_guid=:task_guid',
////                                     ConvertToStringDynArray(['task_guid']),
////                                     ConvertToVariantDynArray([GUID]),
////                                      asoExec
////                                      ) then
////      begin
////        //���ݿ�����ʧ�ܻ��쳣
////        ADesc := '��������״̬' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
////        Exit;
////      end;
//        ARecordDataJson:=TSuperObject.Create;
//        ARecordDataJson.S['state']:='finished';
//        if not SimpleCallAPI('update_record',
//                            nil,
//                            TableRestCenterInterfaceUrl,
//                            ['appid',
//                            'user_fid',
//                            'key',
//                            'rest_name',
//                            'record_data_json',
//                            'where_sql'],
//                            [AAppID,
//                            0,
//                            '',
//                            'task',
//                            ARecordDataJson.AsJSON,
//                            ' AND task_guid='+QuotedStr(GUID)+' '
//                            ],
//                            ACode,
//                            ADesc,
//                            ADataJson,
//                            GlobalRestAPISignType,
//                            GlobalRestAPIAppSecret
//                            ) or (ACode<>200) then
//        begin
//          ShowMessage(ADesc);
//          Exit;
//        end;
//    end;


    Result:=True;
//  finally
//    ADBModule.FreeDBHelperToPool(ASQLDBHelper);
//  end;

end;


{ TGetRecordListTaskItem }

procedure TGetRecordListTaskItem.DoWorkInWorkThreadExecute(Sender: TObject;
  AWorkThreadItem: TTaskWorkThreadItem; ATaskItem: TTaskItem);
begin
  try

    Self.DoGetRecordListTask(Sender,AWorkThreadItem,ATaskItem,FWhereSQL);

  finally
    ATaskItem.State:=tsFinished;
  end;
end;

constructor TGetRecordListTaskItem.Create(AOwner: TTaskManager);
begin
  inherited;

  FPageIndex:=1;
  FPageSize:=MaxInt;

end;

procedure TGetRecordListTaskItem.DoGetRecordListTask(Sender: TObject;
  AWorkThreadItem: TTaskWorkThreadItem; ATaskItem: TTaskItem;
                                        AWhereSQL:String);
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  ARecordList:ISuperArray;

  ALoadDataSetting:TLoadDataSetting;
  ADataInterface:TDataInterface;
  ADataIntfResult:TDataIntfResult;
begin
  Inherited;
  uBaseLog.HandleException(nil,'TGetRecordListTaskItem.DoWorkInWorkThreadExecute Begin');
  try
      ARecordList:=nil;


      {$IFDEF HAS_LOCAL_DB_INTERFACE}
      //ʹ�ñ������ݿ�ģʽ
      ADataInterface:=Self.Owner.CreateSaveDataInterface;
      ADataInterface.Name:=FRestName;
      ADataIntfResult:=TDataIntfResult.Create;
      ALoadDataSetting:=TLoadDataSetting.Create;
      ALoadDataSetting.AppID:=FAppID;
      ALoadDataSetting.PageIndex:=FPageIndex;
      ALoadDataSetting.PageSize:=FPageSize;
      ALoadDataSetting.CustomWhereSQL:=AWhereSQL;
      try
        if not ADataInterface.GetDataList(ALoadDataSetting,ADataIntfResult) then
        begin
          uBaseLog.HandleException(nil,'TGetRecordListTaskItem.DoGetRecordListTask ��ȡ����get_record_list '+ADataIntfResult.Desc);
          Exit;
        end;

      finally
        FreeAndNil(ADataInterface);
        FreeAndNil(ADataIntfResult);
        FreeAndNil(ALoadDataSetting);
      end;
      {$ELSE}
          if not SimpleCallAPI('get_record_list',
                             nil,
                             TableRestCenterInterfaceUrl,
                            ConvertToStringDynArray(['appid','rest_name','where_sql','pageindex','pagesize']),
                            ConvertToVariantDynArray([AppID,FRestName,AWhereSQL,FPageIndex,FPageSize]),
                            ACode,
                            ADesc,
                            ADataJson,
                            GlobalRestAPISignType,
                            GlobalRestAPIAppSecret
                            ) or (ACode<>200) then
          begin
            uBaseLog.HandleException(nil,'TGetRecordListTaskItem.DoGetRecordListTask ��ȡ����get_record_list '+ADesc);
            Exit;
          end;
      {$ENDIF}






      if ADataJson.A['RecordList'].Length>0 then
      begin
        ARecordList:=ADataJson.A['RecordList'];
      end;

      if (ARecordList<>nil) then
      begin
          ATaskItem.DataIntfResult.DataJson:=ADataJson;//TSuperObject.Create;
//          ATaskItem.DataIntfResult.DataJson.I['Code']:=SUCC;
//          if ARecordList<>nil then
//          begin
//            ATaskItem.DataIntfResult.DataJson.A['RecordList']:=ARecordList;
//          end;

          //��֪ͨ����ȥ��ѯ���ݿ�,��ȡ���µ�����
          if Assigned(ATaskItem.OnWorkThreadProgress) then
          begin
            ATaskItem.OnWorkThreadProgress(Self,
                                            nil,
                                            ATaskItem,
                                            ATaskItem.DataIntfResult
                                            );
          end;

      end;


  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TGetRecordListTaskItem.DoWorkInWorkThreadExecute Error');
    end;
  end;

  uBaseLog.HandleException(nil,'TGetRecordListTaskItem.DoWorkInWorkThreadExecute End');


end;



{ TGetUpdatedRecordListTaskItem }

procedure TGetUpdatedRecordListTaskItem.DoWorkInWorkThreadExecute(
  Sender: TObject; AWorkThreadItem: TTaskWorkThreadItem; ATaskItem: TTaskItem);
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
  AWhereSQL:String;
  ALastQueryResultDataUpdateTime:TDateTime;

  ALoadDataSetting:TLoadDataSetting;
  ADataInterface:TDataInterface;
  ADataIntfResult:TDataIntfResult;
begin
  FLastQueryResultDataUpdateTime:=Now;

  while (not TProtectedThread(AWorkThreadItem.FThread).Terminated)
        and (ATaskItem.State<>tsFinished) do
  begin

      Sleep(3000);



      {$IFDEF HAS_LOCAL_DB_INTERFACE}
      //ʹ�ñ������ݿ�ģʽ
      ADataInterface:=Self.Owner.CreateSaveDataInterface;
      ADataInterface.Name:=FRestName;
      ADataIntfResult:=TDataIntfResult.Create;
      ALoadDataSetting:=TLoadDataSetting.Create;
      ALoadDataSetting.AppID:=FAppID;
      ALoadDataSetting.CustomWhereSQL:=' AND task_guid='+QuotedStr(ATaskItem.GUID)+' ';
      try
        if not ADataInterface.GetDataDetail(ALoadDataSetting,ADataIntfResult) then
        begin
          uBaseLog.HandleException(nil,'TGetRecordListTaskItem.DoGetRecordListTask ��ȡ����get_record '+ADataIntfResult.Desc);
          Exit;
        end;

      finally
        FreeAndNil(ADataInterface);
        FreeAndNil(ADataIntfResult);
        FreeAndNil(ALoadDataSetting);
      end;
      {$ELSE}
          if not SimpleCallAPI('get_record',
                             nil,
                             TableRestCenterInterfaceUrl,
                            ConvertToStringDynArray(['appid',
                                                    'rest_name',
                                                    'where_sql'
                                                    ]),
                            ConvertToVariantDynArray([AppID,
                                                      'task',
                                                      ' AND task_guid='+QuotedStr(ATaskItem.GUID)+' '
                                                      ]),
                            ACode,
                            ADesc,
                            ADataJson,
                            GlobalRestAPISignType,
                            GlobalRestAPIAppSecret
                            ) or (ACode<>200) then
          begin
            uBaseLog.HandleException(nil,'TGetRecordListTaskItem.DoGetRecordListTask ��ȡ����get_record '+ADesc);
            Exit;
          end;
      {$ENDIF}



      //  TTaskState=(tsWaiting,
      //              tsWorking,//tsStop,
      //              tsFinished);

//          if ASQLDBHelper.Query.FieldByName('state').AsString='finished' then
//          begin
//            AWorkItem.State:=tsFinished;
//          end;
      if ADataJson.S['state']='finished' then
      begin
        ATaskItem.State:=tsFinished;
      end;



      ALastQueryResultDataUpdateTime:=FLastQueryResultDataUpdateTime;
      FLastQueryResultDataUpdateTime:=Now;
      Self.DoGetRecordListTask(Sender,AWorkThreadItem,ATaskItem,FWhereSQL+' AND updatetime>='+QuotedStr(StdDateTimeToStr(ALastQueryResultDataUpdateTime))+' ');



  end;

end;


  {$IFDEF MSWINDOWS}

{ TPythonCommandLineTaskItem }

constructor TPythonCommandLineTaskItem.Create(AOwner: TTaskManager);
begin
  inherited;

  FCommandLineOutputHelper:=TCommandLineOutputHelper.Create;
  FCommandLineOutputHelper.FOnGetData:=Self.DoGetDataEvent;
end;

destructor TPythonCommandLineTaskItem.Destroy;
begin
  FreeAndNil(FCommandLineOutputHelper);
  inherited;
end;

procedure TPythonCommandLineTaskItem.DoGetDataEvent(Sender: TObject; AData: String;
  ADataJson: ISuperObject);
begin
  if ADataJson.S['FunctionName']=FProgressDataName then
  begin
    Self.DataIntfResult.Succ:=(ADataJson.I['Code']<>SUCC);
    Self.DataIntfResult.Desc:=ADataJson.S['Desc'];
    Self.DataIntfResult.DataJson:=ADataJson.O['Data'];

    //����ִ���еĽ�������
    if Assigned(Self.OnWorkThreadProgress) then
    begin
      Self.OnWorkThreadProgress(Self,nil,Self,Self.DataIntfResult);
    end;

  end;

end;

procedure TPythonCommandLineTaskItem.DoWorkInWorkThreadExecute(Sender: TObject;
  AWorkThreadItem: TTaskWorkThreadItem; ATaskItem: TTaskItem);
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//  AStartTime:TDateTime;
//
//  AGroupsCount: Integer;
var
  ADesc:String;
  APythonExePath:String;
  ACommandLineData:TCommandLineData;
  AParamsJsonFilePath:String;
  //����·��
  AWorkDir:String;
begin
  //����,һЩ����������AParams��,���緢������������,������С��
  //���ص�Json��Ҫ������
  //like_count��int����������
  //share_to_my_homepage_count��int������������ҳ��
  //share_to_my_dynamic_count��int��ת�������˶�̬��
  //share_to_group_count��int��ת��С����
  //share_to_friend_count��int��ת��������



//  Result:=nil;
//
//
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;


//    ATaskJson.O['content']:=AContentJson;
//    ATaskJson.O['account']:=FAccount;
//    ATaskJson.O['params']:=AParams;


  //ģ�ⷢ��
  //Result:=FAPIFrame.UploadContent(AContentJson, AParams);
  //ֱ�ӵ���Python�еķ������з���


  try
      //����·��
      AWorkDir:=
                                        {$IFDEF DEV_MODE}
    //                                    //���ܵĿ�������
    //                                    GetApplicationPath+'..\union_search\',
                                        //C:\MyFiles\OrangeUIProduct\��վ����\union_search\union_search\
                                        //GetApplicationPath+'..\union_search\',
                                        //C:\MyFiles\OrangeUIProduct\��վ����\union_search\
                                        GetApplicationPath+'..\'

                                        //zkn�Ŀ�������
                                        //'D:\PythonProjects\union_search\',

                                        {$ELSE}
                                        //��������
    //                                    GetApplicationPath+'lib\Lib\site-packages\union_search\',
                                        //�ĳ���
    //                                    GetApplicationPath+'lib\union_search\',
                                        GetApplicationPath+'lib\'
                                        {$ENDIF}
      ;
      //'ScrapyTaskManager.py'

      //���������Json
      AParamsJsonFilePath:=GetApplicationPath+'log\'+'CommandLineParams_'+FFunctionName+'_'+FormatDateTime('YYYY_MM_DD_HH_MM_SS_ZZZ',Now)+CreateGUIDString+'.json';
      SaveStringToFile(FParamsJson.AsJSON,AParamsJsonFilePath,TEncoding.UTF8);

      APythonExePath:=GetApplicationPath+'lib\'+'python.exe';
      {$IFDEF DEV_MODE}
      //����ģʽ,����Ҫָ��·����ֱ����PATHָ���ļ���
      APythonExePath:='python.exe';
      {$ENDIF DEV_MODE}
      FCommandParams:='CommandLineHelper.py'
                                    +' '+FFunctionName
                                    +' '+AParamsJsonFilePath
                                    ;
      FCommandLine:=APythonExePath;//+' '+'CommandLineHelper.py'
//                                    +' '+FFunctionName
//                                    +' '+AParamsJsonFilePath
//                                    ;
      //ShellExecute(0, 'open', PWideChar(), '', '', SW_SHOWNORMAL);

  //    FExecuteTaskManagerCommandThread:=TExecuteCommandThread.Create(False,
  //    //                                                                                            AWorkItem,
  //                                                                    ACommandLine,
  //                                                                    AWorkDir,
  //                                                                    AOnGetCommandLineOutput,
  //                                                                    DoExecuteTaskManagerCommandThreadExecuteEnd,
  //                                                                    DoGetTaskManagerScriptCommandLineData,
  //                                                                    nil);

      ExecuteCommand(APythonExePath,FCommandLine,FCommandParams,AWorkDir,'',nil,FCommandLineOutputHelper,ADesc);


      //��ȡ�������еĽ��
      //�н������
      //ȡָ���Ľ��
      ACommandLineData:=FCommandLineOutputHelper.FCommandLineDataList.Find(FFunctionName);
//      if ACommandLineData<>nil then
//      begin
//        Result:=ACommandLineData.DataJson;
//      end;

//    //�жϷ����Ƿ�ɹ�
//    //�ȴ���������
//    while (DateUtils.MilliSecondsBetween(Now,AStartTime) < 30*1000) do
//    begin
//      Sleep(1000);
//    end;
//
//
//    if (DateUtils.MilliSecondsBetween(Now,AStartTime)>=Self.FUploadContentTimeoutInterval) then
//    begin
//      //������ʱ
//      ADesc:='������ʱ';
//      Exit;
//    end;

//    if AParams.I['is_published_to_group'] = 1 then
//    begin
//      if FAPIFrame.FUserInfoJsonObj.I['groupsCount'] <= 20 then
//      begin
//        AGroupsCount:= FAPIFrame.FUserInfoJsonObj.I['groupsCount'];
//      end
//      else
//      begin
//        AGroupsCount:= 20;
//      end;
//    end
//    else
//    begin
//      AGroupsCount:= 0;
//    end;
//
//    ADataJson:=TSuperObject.Create();
////    ADataJson.I['like_count']:= 1;
//    ADataJson.I['share_to_my_homepage_count']:= 1;
////    ADataJson.I['share_to_my_dynamic_count']:= 3;
//    ADataJson.I['share_to_group_count']:= AGroupsCount;
////    ADataJson.I['share_to_friend_count']:= 5;


    if (ACommandLineData<>nil) then
    begin
      Self.DataIntfResult.Succ:=(ACommandLineData.DataJson.I['Code']=SUCC);
      Self.DataIntfResult.Desc:=ACommandLineData.DataJson.S['Desc'];
      Self.DataIntfResult.DataJson:=ACommandLineData.DataJson.O['Data'];
    end;

  finally
  end;

end;
  {$ENDIF}

//{ TQueryTaskStateList }
//
//function TQueryTaskStateList.GetItem(Index: Integer): TQueryTaskStateItem;
//begin
//  Result:=TQueryTaskStateItem(Inherited Items[Index]);
//end;

{ TQueryTaskStateMananger }

function TQueryTaskStateMananger.AddQueryTask(AAppID:String;AUserFID:String;ATaskGUID: String; AOnExecute,
  AOnExecuteEnd: TTaskNotify; ATimeout: Integer): TQueryTaskStateItem;
var
  ATimerTask:TQueryTaskStateItem;
begin
  ATimerTask:=TQueryTaskStateItem.Create;
  ATimerTask.FAppID:=AAppID;
  ATimerTask.FUserFID:=AUserFID;
  ATimerTask.TaskID:=ATaskGUID;
  ATimerTask.Timeout:=ATimeout;
  ATimerTask.StartTime:=Now;
  ATimerTask.OnExecute:=AOnExecute;
  ATimerTask.OnExecuteEnd:=AOnExecuteEnd;
  Result:=ATimerTask;
  Self.RunTask(ATimerTask,False);
end;

function TQueryTaskStateMananger.AddQueryTask(AAppID:String;AUserFID:String;ATaskGUID: String;
  AExecuteTimerTask: TTimerTask; ATimeout: Integer): TQueryTaskStateItem;
var
  ATimerTask:TQueryTaskStateItem;
begin
  ATimerTask:=TQueryTaskStateItem.Create;
  ATimerTask.FAppID:=AAppID;
  ATimerTask.FUserFID:=AUserFID;
  ATimerTask.TaskID:=ATaskGUID;
  ATimerTask.Timeout:=ATimeout;
  ATimerTask.StartTime:=Now;
  ATimerTask.FExecuteTimerTask:=AExecuteTimerTask;
  Result:=ATimerTask;
  Self.RunTask(ATimerTask,False);


end;

procedure TQueryTaskStateMananger.DoExecute;
var
  I: Integer;
  AQueryTaskStateItem:TQueryTaskStateItem;
begin
  //inherited;

  while (Self.TimerTaskList.Count>0) and not Self.Terminated do
  begin

      I:=0;
      while I < Self.TimerTaskList.Count do
      begin
          AQueryTaskStateItem:=TQueryTaskStateItem(TimerTaskList[I]);
          AQueryTaskStateItem.State:=QueryTaskState(AQueryTaskStateItem);
          if AQueryTaskStateItem.State=tsFinished then
          begin
            if AQueryTaskStateItem.FExecuteTimerTask<>nil then
            begin
              DoExecuteTask(AQueryTaskStateItem.FExecuteTimerTask);
              DoExecuteTaskEnd(AQueryTaskStateItem.FExecuteTimerTask);
            end
            else
            begin
              DoExecuteTask(AQueryTaskStateItem);
              DoExecuteTaskEnd(AQueryTaskStateItem);
            end;
            TimerTaskList.Remove(AQueryTaskStateItem);
            continue;
          end;
          if DateUtils.SecondsBetween(Now,AQueryTaskStateItem.StartTime)>AQueryTaskStateItem.Timeout then
          begin
            //��ʱ��
            DoExecuteTaskEnd(AQueryTaskStateItem);
            TimerTaskList.Remove(AQueryTaskStateItem);
          end;

          Inc(I);
      end;

      //��Ϣ����
      Sleep(3*1000);
  end;
end;

function TQueryTaskStateMananger.QueryTaskState(ATimerTask: TTimerTask): TTaskState;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
begin
  Result:=TTaskState.tsWaiting;

  //����Rest�ӿ�,��ѯ����״̬
  if not SimpleCallAPI('get_record',
                     nil,
                     TableRestCenterInterfaceUrl,
                    ConvertToStringDynArray(['appid',
                                            'user_fid',
                                            'rest_name',
                                            'where_key_json'
                                            ]),
                    ConvertToVariantDynArray([TQueryTaskStateItem(ATimerTask).FAppID,
                                            TQueryTaskStateItem(ATimerTask).FUserFID,
                                            'task',
                                            GetWhereKeyJson(['task_guid'],[TQueryTaskStateItem(ATimerTask).TaskID])
                                            ]),
                    ACode,
                    ADesc,
                    ADataJson,
                    GlobalRestAPISignType,
                    GlobalRestAPIAppSecret
                    ) or (ACode<>200) then
  begin
    uBaseLog.HandleException(nil,'TQueryTaskStateMananger.QueryTaskState '+ADesc);
    Exit;
  end;

  //������������Ҫ��,������result_data_json��������cursor��has_next_page��
  TQueryTaskStateItem(ATimerTask).FTaskJson:=ADataJson;

  //  TTaskState=(tsWaiting,
  //              tsWorking,//tsStop,
  //              tsFinished);

  if ADataJson.S['state']='finished' then
  begin
    Result:=tsFinished;
  end;

end;


{ TRequestTaskThread }

constructor TRequestTaskThread.Create(ACreateSuspended: Boolean;
  ATaskManager: TTaskManager);
begin
  Inherited Create(ACreateSuspended);
  FTaskManager:=ATaskManager;
end;

procedure TRequestTaskThread.Execute;
var
  ATaskItem:TTaskItem;
begin
  while not Self.Terminated do
  begin

    if NeedRequestTaskItem then
    begin

      ATaskItem:=Self.RequestTaskItem;

      if ATaskItem<>nil then
      begin
        Self.FTaskManager.TaskList.Add(ATaskItem);
      end;

    end;

    Sleep(3*1000);
  end;

end;

function TRequestTaskThread.RequestTaskItem: TTaskItem;
begin
  Result:=nil;
end;

function TRequestTaskThread.NeedRequestTaskItem: Boolean;
begin
  Result:=True;
end;

initialization


finalization
  if GlobalQueryTaskStateMananger<>nil then
  begin
    GlobalQueryTaskStateMananger.Terminate;
    GlobalQueryTaskStateMananger.WaitFor;
  end;
  SysUtils.FreeAndNil(GlobalQueryTaskStateMananger);


end.
