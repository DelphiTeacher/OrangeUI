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

  //�����߳�
  TTaskWorkThreadItem=class//(TThread)
  public
    TaskManager:TTaskManager;

    //��ǰ�߳���Ҫ����������
    TaskItem:TTaskItem;


    //��ǰ�������ӹ���
    WorkItem:TTaskItem;

    FThread:TThread;
    FThreadClass:TThreadClass;
//    OnExecute:TWorkThreadExecuteEvent;


//    function GetCaption:String;virtual;


    //�����߼���ִ������ķ���
    //�Ȼ�ȡ�ӹ���,Ȼ�����DoExecuteWorkItem������,�������ٻ�ȡһ���ӹ���ȥ����

    //��ȡһ��������Ĺ���
    function GetTaskUnWorkItem
//                  (AIsNeedCheckCanDoThisTask:Boolean=True)
                  :TTaskItem;
    function CanDoThisTask(ATaskItem:TTaskItem):Boolean;virtual;

    //�����̺߳���
    procedure Execute;virtual;
        //�߳̿�ʼ��ʼ
        procedure DoExecuteBegin;virtual;
        function CanExitThread:Boolean;virtual;
        //�����̹߳���
        procedure DoExecuteWorkItem;virtual;
        //�߳̽���
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
  //һ������,�����ȡ����,��ȡ�û���˿,��ȡ��������
  //�Լ����������
  TTaskItem=class
  public
    fid:Integer;
    AppID:Integer;
    UserFID:String;
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
//    Data:Pointer;
//    DataStr:String;

    //�����������Э���߳���
    MaxWorkThreadCount:Integer;

//    //�˺�����,instagram
//    AccountType:String;

    //�����������ݿ�,������ʷ,�Ա���Բ鿴
    function AddToDB(AAppID:Integer;
                      AUserFID:String;
//                      ADBModule:TBaseDatabaseModule;
                      var ADesc:String):Boolean;virtual;abstract;
    //���������״̬
    function UpdateStateToDB(AAppID:Integer;
                            AUserFID:String;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;
    //���������״̬
    function UpdateToDB(AAppID:Integer;
                            AUserFID:String;
                            ARecordDataJson:ISuperObject;
//                            ADBModule:TBaseDatabaseModule;
                            var ADesc:String):Boolean;virtual;abstract;
    //���������
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
    //�������Ĺ����߳���Ҫִ�еķ���
    OnWorkThreadExecute:TWorkThreadExecuteEvent;
    //��չ����,���ȷ���,�������ȽϺ�ʱ,��ô������¼���֪ͨ
    OnWorkThreadProgress:TTaskCallback;



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
    //�Ƿ���ͣ
    IsPause:Boolean;
    IsStop:Boolean;
    //��ʼ����
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








  //������ȡ�������
  TTaskManager=class
  public
    AppID:Integer;
    UserFID:String;

    //�����б�
    TaskList:TTaskList;
    FinishedTaskList:TTaskList;
    TaskWorkThreadItemClass:TTaskWorkThreadItemClass;

    //�̳߳�
    ThreadItems:TTaskWorkThreadItems;

    MaxThreadCount:Integer;

    //���ݽӿڣ�֧��SQL��֧��Rest
    FDataInterface:TDataInterface;
    function CreateDataInterface:TDataInterface;virtual;

    function GetMaxThreadCount:Integer;virtual;
    function CreateTaskWorkThreadItem:TTaskWorkThreadItem;virtual;

    constructor Create;virtual;
    destructor Destroy;override;
  public
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
    procedure StopTaskList;
    //���ݹ�������̵߳�����
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
//////      //���ݿ�����ʧ�ܻ��쳣
//////      ADesc := '�������' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
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
//////      //���ݿ�����ʧ�ܻ��쳣
//////      ADesc := '�������' + 'ʱ' + '���ݿ�����ʧ�ܻ��쳣' + ' ' + ASQLDBHelper.LastExceptMessage;
//////      Exit;
//////    end;
////    if not ASQLDBHelper.SelfQuery_EasyInsert('tbltask',
////                                           ConvertToStringDynArray(['appid','user_fid','task_guid','task_type','name','params_json','is_deleted','createtime']),
////                                           ConvertToVariantDynArray([AAppID,AUserFID,GUID,Type_,Name,AParmasStr,0,Now])
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

    //����û�б���ͣ
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

procedure TTaskItem.Start(ATaskWorkThreadItemClass:TTaskWorkThreadItemClass=nil);
var
  I:Integer;
  ADataWorkThread:TTaskWorkThreadItem;
begin
  for I := 0 to MaxWorkThreadCount-1 do
  begin

    if ATaskWorkThreadItemClass<>nil then
    begin
      //������������߳�
      ADataWorkThread:=ATaskWorkThreadItemClass.Create(False,Self,Owner);
    end
    else
    begin
      //������������߳�
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


  //��������
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
  //�����б�
  TaskList:=TTaskList.Create;
  //����ɵ������б�
  FinishedTaskList:=TTaskList.Create(ooReference);

  TaskWorkThreadItemClass:=TTaskWorkThreadItem;

  FDataInterface:=Self.CreateDataInterface;

  MaxThreadCount:=1;
  //�̳߳�
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
//                                //����������ɺ�Ļص��¼�
//                                AFinishedCallback:TTaskCallback;
//                                //���������л�ȡ���������ݺ�Ļص��¼�
//                                AProgressCallback:TTaskCallback=nil;
//                                //������������Ҫ�Ĳ���
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



//  //�����񱣴浽���ݿ�
//  Result.AddToDB(AppID,
//                  UserFID,


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


          //��ȡһ�����ʵ��˺�
          DoExecuteBegin;




          //�м�������,�Ϳ������˺źͼ����߳�һ���ȡ

          //��Params�л�ȡһ��������Ĺ���
          uBaseLog.HandleException(nil,'TTaskWorkThreadItem.Executee '+ClassName+' TaskList Count '+IntToStr(TaskManager.TaskList.Count));
          WorkItem:=GetTaskUnWorkItem;//TaskItem.GetUnWorkItem;




          if CanExitThread then//WorkItem=nil then
          begin
            Exit;
          end;




          if WorkItem<>nil then
          begin

              try


                  if not TaskItem.IsStop then//����û�б�ֹͣ
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



                  //һ���ӹ����������¼�
                  if WorkItem.Works.Count=0 then//û���ӹ���
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


                  //���й�����ɾͱ�ʾ���������
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
              //����,��Ϣ
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
