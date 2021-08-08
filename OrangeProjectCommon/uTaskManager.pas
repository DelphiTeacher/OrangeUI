unit uTaskManager;

interface

uses
  SysUtils,
  Classes,
  Windows,
  uBaseList,
  uBaseLog,
  uFuncCommon,



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

//  uBaseDBHelper,
  uDataInterface,
//  uBaseDataBaseModule,
  uBinaryObjectList;

type
  TTaskManager=class;
  TTaskWorkThreadItem=class;
  TTaskItem=class;
  TThreadClass=class of TThread;
  TWorkThreadExecuteEvent=procedure(Sender:TObject;AWorkThread:TTaskWorkThreadItem;ATaskItem:TTaskItem) of object;




  TWorkThread=class(TThread)
  protected
    procedure Execute;override;
  public
    ThreadItem:TTaskWorkThreadItem;
  end;


  TProtectedThread=class(TThread)
  public
    property Terminated;
  end;

  //工作线程
  TTaskWorkThreadItem=class//(TThread)
  public
    TaskManager:TTaskManager;

    //当前线程所要工作的任务
    TaskItem:TTaskItem;


    //当前所做的子工作
    WorkItem:TTaskItem;

    FThread:TThread;
    FThreadClass:TThreadClass;
//    OnExecute:TWorkThreadExecuteEvent;


//    function GetCaption:String;virtual;


    //工作逻辑：执行任务的方法
    //先获取子工作,然后调用DoExecuteWorkItem处理工作,处理完再获取一个子工作去处理

    //获取一个待处理的工作
    function GetTaskUnWorkItem
//                  (AIsNeedCheckCanDoThisTask:Boolean=True)
                  :TTaskItem;
    function CanDoThisTask(ATaskItem:TTaskItem):Boolean;virtual;

    //工作线程函数
    procedure Execute;virtual;
        //线程开始初始
        procedure DoExecuteBegin;virtual;
        function CanExitThread:Boolean;virtual;
        //处理线程工作
        procedure DoExecuteWorkItem;virtual;
        //线程结束
        procedure DoExecuteEnd;virtual;
    function CreateThread(ACreateSuspended:Boolean;ATaskItem:TTaskItem):TThread;virtual;
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
  TTaskCallback=procedure(Sender:TObject;AWorkThread: TTaskWorkThreadItem;ATaskItem:TTaskItem;ADataIntfResult:TDataIntfResult) of object;
  TTaskState=(tsWaiting,
              tsWorking,//tsStop,
              tsFinished);
  //一次任务,比如获取话题,获取用户粉丝,获取内容评论
  //以及任务的配置
  TTaskItem=class
  public
    fid:Integer;
    AppID:Integer;
    UserFID:String;
  public
    //开始工作了
    State:TTaskState;
  public
    //任务ID
    GUID:String;
    //任务名称
    Name:String;
    //任务类型
    Type_:String;

    //参数,或者说包含需要操作的子任务数
    Params:ISuperObject;
    DataObject:TObject;
//    Data:Pointer;
//    DataStr:String;

    //这个任务的最大协作线程数
    MaxWorkThreadCount:Integer;

//    //账号类型,instagram
//    AccountType:String;

    //保存任务到数据库,任务历史,以便可以查看
    function AddToDB(AAppID:Integer;
                      AUserFID:String;
//                      ADBModule:TBaseDatabaseModule;
                      var ADesc:String):Boolean;virtual;abstract;
    //更新任务的状态
    function UpdateStateToDB(AAppID:Integer;
                            AUserFID:String;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;
    //更新任务的状态
    function UpdateToDB(AAppID:Integer;
                            AUserFID:String;
                            ARecordDataJson:ISuperObject;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;
    //添加子任务
    function AddSubWorkToDB(AAppID:Integer;
                            AUserFID:String;
                            ASubWorkGUID:String;
                            ASubWorkParmasStr:String;
                            ATaskType:String;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;

    procedure DoWorkInWorkThreadExecute(Sender:TObject;
                                        AWorkThread:TTaskWorkThreadItem;
                                        ATaskItem:TTaskItem);virtual;
  public

    ThreadItems:TTaskWorkThreadItems;

//    OnExecute:TWorkThreadExecuteEvent;


    OnFinishedCallback:TTaskCallback;
    //这个任务的工作线程所要执行的方法
    OnWorkThreadExecute:TWorkThreadExecuteEvent;
    //进展方法,进度方法,如果任务比较耗时,那么用这个事件来通知
    OnWorkThreadProgress:TTaskCallback;



    GetUnWorkLock:TCriticalSection;
    //工作列表
    Works:TTaskList;
    FWorkGUIDList:TStringList;
    //获取一个未工作的工作项,准备开工
    function GetUnWorkItem:TTaskItem;
    function UnWorkItemCount:Integer;
    function IsWorkFinished:Boolean;
  public
    Owner:TTaskManager;
    //接口执行返回的结果
    DataIntfResult:TDataIntfResult;

  public
    constructor Create(AOwner:TTaskManager);virtual;
    destructor Destroy;override;
  public
    //是否暂停
    IsPause:Boolean;
    IsStop:Boolean;
    //开始任务
    procedure Start(ATaskWorkThreadItemClass:TTaskWorkThreadItemClass=nil);
    procedure Stop;virtual;
    procedure Pause;virtual;
    procedure Resume;virtual;
  end;
  TTaskList=class(TBaseList)
  private
    function GetItem(Index: Integer): TTaskItem;
  public
    function UnWorkItemsCount:Integer;
    property Items[Index:Integer]:TTaskItem read GetItem;default;
  end;








  //数据提取任务管理
  TTaskManager=class
  public
    AppID:Integer;
    UserFID:String;

    //任务列表
    TaskList:TTaskList;
    FinishedTaskList:TTaskList;
    TaskWorkThreadItemClass:TTaskWorkThreadItemClass;

    //线程池
    ThreadItems:TTaskWorkThreadItems;

    MaxThreadCount:Integer;

    //数据接口，支持SQL，支持Rest
    FDataInterface:TDataInterface;
    function CreateDataInterface:TDataInterface;virtual;

    function GetMaxThreadCount:Integer;virtual;
    function CreateTaskWorkThreadItem:TTaskWorkThreadItem;virtual;

    constructor Create;virtual;
    destructor Destroy;override;
  public
    function StartTask(ATaskItem:TTaskItem//;
//                        //任务执行事件
//                        AWorkThreadExecute:TWorkThreadExecuteEvent;
//                        //整个任务完成后的回调事件
//                        AFinishedCallback:TTaskCallback;
//                        //任务运行中获取到部分数据后的回调事件
//                        AProgressCallback:TTaskCallback=nil;
//                        //任务运行所需要的参数
//                        AParams:ISuperObject=nil
                        ):TTaskItem;virtual;
    procedure StopTaskList;
    //根据规则更新线程的数量
    procedure SyncWorkThreadItems;

  end;




implementation




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

  Owner:=AOwner;
  ThreadItems:=TTaskWorkThreadItems.Create;
  MaxWorkThreadCount:=1;
  DataIntfResult:=TDataIntfResult.Create;
  Params:=TSuperObject.Create();
  Works:=TTaskList.Create;
  GetUnWorkLock:=TCriticalSection.Create;
  FWorkGUIDList:=TStringList.Create;
end;

//function TTaskItem.AddSubWorkToDB(AAppID: Integer; AUserFID: String;
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
//////                                           [AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,Now,'',GUID,'',0,0]
//////                                            ) then
//////    begin
//////      //数据库连接失败或异常
//////      ADesc := '添加任务' + '时' + '数据库连接失败或异常' + ' ' + ASQLDBHelper.LastExceptMessage;
//////      Exit;
//////    end;
////
////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
////                                           ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime','parent_task_guid','root_task_guid','process_id','works_count','finished_works_count']),
////                                           ConvertToVariantDynArray([AAppID,AUserFID,ASubWorkGUID,Type_,Name,ASubWorkParmasStr,0,Now,GUID,GUID,IntToStr(GetCurrentProcessId),0,0]),
////                                           '',
////                                           asoExec,
////                                           nil
////                                            ) then
////    begin
////      //数据库连接失败或异常
////      ADesc := '添加子工作' + '时' + '数据库连接失败或异常' + ' ' + ASQLDBHelper.LastExceptMessage;
////      Exit;
////    end;
////
////
////    FWorkGUIDList.Add(ASubWorkGUID);
////
////    //给父任务的子工作数+1
////    if not ASQLDBHelper.SelfQuery('UPDATE tbltask SET works_count=IFNULL(works_count,0)+1 WHERE task_guid='+QuotedStr(GUID),GetEmptyStringDynArray,GetEmptyVariantDynArray,asoExec) then
////    begin
////      //数据库连接失败或异常
////      ADesc := '添加子工作' + '时' + '数据库连接失败或异常' + ' ' + ASQLDBHelper.LastExceptMessage;
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
//function TTaskItem.AddToDB(AAppID: Integer; AUserFID: String;
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
//////                                           [AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,Now,'',GUID,'',0,0]
//////                                            ) then
//////    begin
//////      //数据库连接失败或异常
//////      ADesc := '添加任务' + '时' + '数据库连接失败或异常' + ' ' + ASQLDBHelper.LastExceptMessage;
//////      Exit;
//////    end;
////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
////                                           ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime']),
////                                           ConvertToVariantDynArray([AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,Now])
////                                            ) then
////    begin
////      //数据库连接失败或异常
////      ADesc := '添加任务' + '时' + '数据库连接失败或异常' + ' ' + ASQLDBHelper.LastExceptMessage;
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


  //不再这里Stop,在释放之前Stop
//  Self.Stop;



  FreeAndNil(DataIntfResult);
  FreeAndNil(ThreadItems);
  FreeAndNil(Works);
  FreeAndNil(GetUnWorkLock);
  FreeAndNil(FWorkGUIDList);
  inherited;
end;

procedure TTaskItem.DoWorkInWorkThreadExecute(Sender: TObject;
  AWorkThread: TTaskWorkThreadItem; ATaskItem: TTaskItem);
begin
  if Assigned(Self.OnWorkThreadExecute) then
  begin
    Self.OnWorkThreadExecute(Sender,AWorkThread,ATaskItem);
  end;
end;

function TTaskItem.GetUnWorkItem: TTaskItem;
var
  I: Integer;
begin
  Result:=nil;

  GetUnWorkLock.Enter;
  try

    //任务没有被暂停
    if not Self.IsPause then
    begin
        if Works.Count>0 then
        begin
          for I := 0 to Works.Count-1 do
          begin
            if Works[I].State=tsWaiting then
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


    //开工了
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


    //任务没有被暂停
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

//function TTaskItem.UpdateStateToDB(AAppID: Integer; AUserFID: String;
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
////      //数据库连接失败或异常
////      ADesc := '更新任务状态' + '时' + '数据库连接失败或异常' + ' ' + ASQLDBHelper.LastExceptMessage;
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
////        //数据库连接失败或异常
////        ADesc := '更新任务状态' + '时' + '数据库连接失败或异常' + ' ' + ASQLDBHelper.LastExceptMessage;
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

procedure TTaskItem.Start(ATaskWorkThreadItemClass:TTaskWorkThreadItemClass=nil);
var
  I:Integer;
  ADataWorkThread:TTaskWorkThreadItem;
begin
  for I := 0 to MaxWorkThreadCount-1 do
  begin

    if ATaskWorkThreadItemClass<>nil then
    begin
      //创建多个工作线程
      ADataWorkThread:=ATaskWorkThreadItemClass.Create(False,Self,Owner);
    end
    else
    begin
      //创建多个工作线程
      ADataWorkThread:=Owner.TaskWorkThreadItemClass.Create(False,Self,Owner);
    end;



    ThreadItems.Add(ADataWorkThread);

  end;
end;

procedure TTaskItem.Stop;
var
  I: Integer;
begin
  uBaseLog.HandleException(nil,'TTaskItem.Stop Begin');


  //结束任务
  IsStop:=True;
//  State:=tsFinished;

//  Self.State:=tsStop;


  for I := 0 to Self.Works.Count-1 do
  begin
//    Self.Works[I].State:=tsFinished;
    Self.Works[I].IsStop:=True;
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

constructor TTaskManager.Create;
begin
  //任务列表
  TaskList:=TTaskList.Create;
  //已完成的任务列表
  FinishedTaskList:=TTaskList.Create(ooReference);

  TaskWorkThreadItemClass:=TTaskWorkThreadItem;

  FDataInterface:=Self.CreateDataInterface;

  MaxThreadCount:=1;
  //线程池
  ThreadItems:=TTaskWorkThreadItems.Create;
end;

function TTaskManager.CreateDataInterface: TDataInterface;
begin
  Result:=nil;
end;

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

  FinishedTaskList.Clear(False);
  FreeAndNil(FinishedTaskList);
  inherited;
end;


function TTaskManager.GetMaxThreadCount: Integer;
var
  AUnWorkItemsCount:Integer;
begin
  AUnWorkItemsCount:=Self.TaskList.UnWorkItemsCount;
  Result:=Min(AUnWorkItemsCount,MaxThreadCount);
end;

function TTaskManager.StartTask(ATaskItem:TTaskItem
//                                AWorkThreadExecute:TWorkThreadExecuteEvent;
//                                //整个任务完成后的回调事件
//                                AFinishedCallback:TTaskCallback;
//                                //任务运行中获取到部分数据后的回调事件
//                                AProgressCallback:TTaskCallback=nil;
//                                //任务运行所需要的参数
//                                AParams:ISuperObject=nil
                                ): TTaskItem;
var
  ADesc:String;
  ATaskWorkThreadItem:TTaskWorkThreadItem;
begin
  Result:=ATaskItem;

//  Result.OnWorkThreadExecute:=AWorkThreadExecute;
//  Result.OnWorkThreadProgress:=AProgressCallback;
//  Result.OnFinishedCallback:=AFinishedCallback;
//
//  Result.Params:=AParams;
//  Result.MaxWorkThreadCount:=AMaxWorkThreadCount;

  Self.TaskList.Add(Result);



//  //将任务保存到数据库
//  Result.AddToDB(AppID,
//                  UserFID,


  //没有空闲的工作线程就创建
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
  Result:=True;
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


  FThread:=CreateThread(ACreateSuspended,ATaskItem);

  TaskItem:=ATaskItem;
  TaskManager:=ATaskManager;
//  OnExecute:=TaskItem.OnWorkThreadExecute;
end;

function TTaskWorkThreadItem.CreateThread(ACreateSuspended:Boolean;ATaskItem:TTaskItem): TThread;
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

procedure TTaskWorkThreadItem.DoExecuteWorkItem;
begin
  TaskItem.DoWorkInWorkThreadExecute(Self,Self,WorkItem);
end;

procedure TTaskWorkThreadItem.Execute;
begin
  uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Execute '+ClassName+' Begin Task');






  try

      while not TProtectedThread(FThread).Terminated do
      begin


          //获取一个合适的账号
          DoExecuteBegin;




          //有几个主题,就开几个账号和几个线程一起获取

          //从Params中获取一个待处理的工作
          uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Executee '+ClassName+' TaskList Count '+IntToStr(TaskManager.TaskList.Count));
          WorkItem:=GetTaskUnWorkItem;//TaskItem.GetUnWorkItem;




          if CanExitThread then//WorkItem=nil then
          begin
            Exit;
          end;




          if WorkItem<>nil then
          begin

              try


                  if not TaskItem.IsStop then//任务没有被停止
                  begin
                      try

                         DoExecuteWorkItem;

                      except
                        on E:Exception do
                        begin
                          WorkItem.DataIntfResult.Desc:=E.Message;
                          uBaseLog.HandleException(E,'TTaskWorkThreadItem.Executee '+ClassName+' OnExecute Work:'+WorkItem.Name+' Params:'+WorkItem.Params.AsJSON);
                        end;
                      end;
                  end
                  else
                  begin
                      uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Executee '+ClassName+' Task is Stoped');
                      WorkItem.State:=tsFinished;
                  end;



                  //一个子工作结束的事件
                  if WorkItem.Works.Count=0 then//没有子工作
                  begin
                      try
                          if Assigned(WorkItem.OnFinishedCallback) then
                          begin
                            WorkItem.OnFinishedCallback(Self,Self,WorkItem,WorkItem.DataIntfResult);
                          end;
                      except
                        on E:Exception do
                        begin
                          WorkItem.DataIntfResult.Desc:=E.Message;
                          uBaseLog.HandleException(E,'TTaskWorkThreadItem.Executee '+ClassName+' OnFinishedCallback Work:'+WorkItem.Name+' Params:'+WorkItem.Params.AsJSON);
                        end;
                      end;
                  end;


              finally


                  //所有工作完成就表示任务结束了
                  if TaskItem.IsWorkFinished then
                  begin
                      TaskManager.TaskList.Remove(TaskItem,False);
                      TaskManager.FinishedTaskList.Add(TaskItem);
                  end;

                  if WorkItem<>TaskItem then
                  begin
                      if TaskItem.IsWorkFinished then
                      begin
//                          TaskManager.TaskList.Remove(TaskItem,False);
//                          TaskManager.FinishedTaskList.Add(TaskItem);


                          TaskItem.DataIntfResult.Succ:=True;
                          try
                            if Assigned(TaskItem.OnFinishedCallback) then
                            begin
                              TaskItem.OnFinishedCallback(Self,Self,TaskItem,TaskItem.DataIntfResult);
                            end;
                          except
                            on E:Exception do
                            begin
                              TaskItem.DataIntfResult.Desc:=E.Message;
                              uBaseLog.HandleException(E,'TTaskWorkThreadItem.Executee '+ClassName+' OnFinishedCallback Task:'+TaskItem.Name);
                            end;
                          end;
                          FreeAndNil(TaskItem.DataIntfResult);
                      end;
                  end
                  else
                  begin
                  end;

              end;


          end
          else
          begin
              //空闲,休息
              uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Executee '+ClassName+' no WorkItem Sleep');
              uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Executee '+ClassName+' Thread Count is '+IntToStr(TaskManager.ThreadItems.Count));
              Sleep(3000);
          end;


      end;


  finally

    DoExecuteEnd;

  end;

  uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Executee '+ClassName+' End');

end;


function TTaskWorkThreadItem.GetTaskUnWorkItem//(AIsNeedCheckCanDoThisTask:Boolean=True)
                                              : TTaskItem;
var
  I: Integer;
  ATaskItem:TTaskItem;
begin
  //根据线程模式来判断使用

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
    for I := 0 to TaskManager.TaskList.Count-1 do
    begin
      ATaskItem:=TaskManager.TaskList[I];
      if //(not AIsNeedCheckCanDoThisTask or AIsNeedCheckCanDoThisTask and CanDoThisTask(ATaskItem))
        CanDoThisTask(ATaskItem)
        and not ATaskItem.IsPause
        and not ATaskItem.IsWorkFinished then
      begin
        Result:=ATaskItem.GetUnWorkItem;

        if Result<>nil then
        begin
          TaskItem:=ATaskItem;
          Exit;
        end;

      end;

    end;

  end;

end;

{ TWorkThread }

procedure TWorkThread.Execute;
begin
  ThreadItem.Execute;

end;

end.
