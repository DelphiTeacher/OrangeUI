//命令行帮助
unit uCommandLineHelper;



interface

uses
  SysUtils, Types, Classes, Variants,

  {$IFDEF IN_ORANGESDK}
  uFuncCommon_Copy,
  uBaseList_Copy,
  uBaseLog_Copy,
  {$ELSE}
  uFuncCommon,
  uBaseList,
  uBaseLog,
  {$ENDIF}


  {$IFDEF MSWINDOWS}
  Windows,
//  Forms,
  ShellAPI,
  {$ENDIF}


//  {$IFDEF LINUX}
//  uLinuxShell,
//  {$ENDIF}
  {$IFDEF LINUX}
  Posix.Unistd,
  Posix.SysTypes,
  {$ENDIF }


  {$IF CompilerVersion <= 21.0} // D2010之前
  SuperObject,
  superobjecthelper,
  {$ELSE}
    //D2010之后
    {$IFDEF IN_ORANGESDK}
    XSuperObject_Copy,
    {$ELSE}
    XSuperObject,
    XSuperJson,
    {$ENDIF}
  {$IFEND}


  XMLDoc,
  XMLIntf;


const
  Const_CommandLineDataBegin='CommandLineDataBegin';
  Const_CommandLineDataEnd='CommandLineDataEnd';


type
  //获取到命令行输出文本的事件
  TGetCommandLineOutputEvent=procedure(ACommandLine:String;ATag:String;AOutput:String) of object;
  TGetCommandLineBufferEvent=procedure(ABuffer:Pointer;ABytesRead: Cardinal;ABufferSize:Cardinal) of object;
  TGetLogEvent=procedure(Sender:TObject;ALog:String) of object;
  TGetDataEvent=procedure(Sender:TObject;AData:String;ADataJson:ISuperObject) of object;


  TExecuteCommand=class;

  //命令行数据,以什么开头,以什么表示结束,
  //CommandLineDataBegin表示开始，以CommandLineDataEnd表示结束，然后中间是json
  //数据类型,有些是日志，有些是数据要存数据库
  TCommandLineData=class
    Data:String;
    DataJson:ISuperObject;
  end;
  TCommandLineDataList=class(TBaseList)
  private
    function GetItem(Index: Integer): TCommandLineData;
  public
    function Find(AFunctionName:String):TCommandLineData;
    property Items[Index:Integer]:TCommandLineData read GetItem;default;
  end;



  //用来处理命令行的输出,获取输出中的日志和返回的JSON数据
  TCommandLineOutputHelper=class
  public
    FOnGetData:TGetDataEvent;
    FOnGetLog:TGetLogEvent;

    FReadedDataString:AnsiString;
    FLastBuffer:AnsiString;
//    FReadedDataString:String;
    FCommandLineDataList:TCommandLineDataList;
    procedure DoGetCommandLineOutput(ACommandLine:String;ATag:String;AOutput:String);
    //获取到命令行的数据了
    procedure DoGetCommandLineBufferEvent(ABuffer:Pointer;ABytesRead: Cardinal;ABufferSize:Cardinal);

    constructor Create;
    destructor Destroy;override;
  end;




  //执行命令行的线程
  TReadPipeThread=class(TThread)
  public
//    FProgramFilePath:String;
//    //命令行
//    FCommandLine:String;
//    //工作路径
//    FWorkDir:String;
//    //获取到输出的事件
//    FOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//    //执行结束的事件
//    FOnExecuteEnd:TNotifyEvent;


//    FOnGetData:TGetDataEvent;
//    FOnGetLog:TGetLogEvent;


    FExecuteCommand:TExecuteCommand;

    procedure Execute;override;

  public
    constructor Create(ACreateSuspended:Boolean;
                        AExecuteCommand:TExecuteCommand//;
//                        //命令行
//                        AProgramFilePath:String;
//                        //命令行
//                        ACommandLine:String;
//                        //工作路径
//                        AWorkDir:String;
//                        //获取到输出的事件
//                        AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//                        //执行结束的事件
//                        AOnExecuteEnd:TNotifyEvent;
//                        //获取到数据的事件
//                        AOnGetData:TGetDataEvent;
//                        //获取到日志的事件
//                        AOnGetLog:TGetLogEvent
                        );
    destructor Destroy;override;
  end;


  //如果开了write的管道,运行进程读完数据就卡死了,进程一直在等输入,直到写管道被关闭
  TPipeUseType=(putReadFromStdout,putWriteToStdin);
  TExecuteCommand=class
  public

    {$IFDEF MSWINDOWS}
    //进程信息
    FPI: TProcessInformation;
    //用于重定位子程序的输出管道
    StdOutPipeRead, StdOutPipeWrite: THandle;
    //用于重定位子程序的输入管道
    StdinPipeRead, StdinPipeWrite: THandle;
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    //创建进程,需要管道
    function CreateProcessOnWindows(var ADesc:String):Boolean;
    procedure PipeReadOnWindows;
    {$ENDIF}
  private

    {$IFDEF LINUX}
//    Handle: TStreamHandle;
    child_pid: pid_t;
    fd_stdout:Array [0..1] of Integer;//第一个是读端,第二个是写端
    fd_stdin:Array [0..1] of Integer;//第一个是读端,第二个是写端
    {$ENDIF}

    {$IFDEF LINUX}
    function CreateProcessOnLinux(var ADesc:String):Boolean;
    procedure PipeReadOnLinux;
    {$ENDIF}
  private
    Buffer: array [0 .. 2000] of AnsiChar;
    BytesRead: Cardinal;
    //数据读取完,会将进程的数据都释放掉,不需要手动调用ProcessKilled
    FReadPipeThread:TReadPipeThread;
    //创建进程,需要管道
    function CreateProcess(var ADesc:String):Boolean;
    //从输出管道读取数据
    procedure ReadFromStdoutPipe;
    //进程执行完之后,处理
    procedure ProcessKilled;
  public
    //命令行
    FProgramFilePath:String;
    //命令行
    FCommandLine:String;
    FParams:String;
    //工作路径
    FWorkDir:String;
    //日志标识
    FTag:String;
//    //进程信息
//    FPI: TProcessInformation;
    //获取到输出的事件
    FOnGetCommandLineOutput:TGetCommandLineOutputEvent;
    //执行结束的事件
    FOnExecuteEnd:TNotifyEvent;
    //获取到数据事件
    FOnGetData:TGetDataEvent;
    //获取到日志事件
    FOnGetLog:TGetLogEvent;
    FPipeUseTypes:set of TPipeUseType;

    FCommandLineOutputHelper:TCommandLineOutputHelper;
    FOtherCommandLineOutputHelper:TCommandLineOutputHelper;
  public
    //运行
    function Execute(AIsSync:Boolean;//同步还是异步
                    var ADesc:String):Boolean;
    //写数据到输入管道
    function WriteToStdinPipe(AInput:String):Boolean;
    //等待进程执行完,等待数据读取完
    procedure WaitFor;
  public
    constructor Create;
    destructor Destroy;override;
  end;




//  {$IFDEF MSWINDOWS}
//执行命令行,获取命令行的结果
function ExecuteCommand(AProgramFilePath:String;ACommandLine: string;AParams:String;
                        AWorkDir: string;
                        ATag:String;
                        //获取命令行输出的事件,因为要在界面上输出的
                        AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//                        var PI: TProcessInformation;
                        ACommandLineOutputHelper:TCommandLineOutputHelper;
                        var ADesc:String):Boolean;
//function ExecuteCommand_Windows(AProgramFilePath:String;ACommandLine: string;
//                              AWorkDir: string;
//                              ATag:String;
//                              //获取命令行输出的事件,因为要在界面上输出的
//                              AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//      //                        var PI: TProcessInformation;
//                              ACommandLineOutputHelper:TCommandLineOutputHelper=nil):String;
//  {$ENDIF}
//  {$IFDEF LINUX}
//function ExecuteCommand_OnLinux(AProgramFilePath:String;ACommandLine: string;
//                              AWorkDir: string;
//                              ATag:String;
//                              //获取命令行输出的事件,因为要在界面上输出的
//                              AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//      //                        var PI: TProcessInformation;
//                              ACommandLineOutputHelper:TCommandLineOutputHelper=nil):String;
//  {$ENDIF}

function ExecuteCommandProcess(ACommandLine: string;
                              AWorkDir: string;
                              AParams:String=''):String;



//var
////  GlobalCommandLineOutputHelper:TCommandLineOutputHelper;
//  GlobalOnGetCommandLineOutput:TGetCommandLineOutputEvent;

implementation



////执行命令行,获取命令行的结果
//function ExecuteCommand(AProgramFilePath:String;ACommandLine: string;
//                        AWorkDir: string;
//                        ATag:String;
//                        //获取命令行输出的事件,因为要在界面上输出的
//                        AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
////                        var PI: TProcessInformation;
//                        ACommandLineOutputHelper:TCommandLineOutputHelper=nil):String;
//begin
//  Result:='';
//
//  {$IFDEF MSWINDOWS}
//  Result:=ExecuteCommand_Windows(AProgramFilePath,ACommandLine,AWorkDir,ATag,AOnGetCommandLineOutput,ACommandLineOutputHelper);
//  {$ENDIF}
//
//
//  {$IFDEF LINUX}
//  Result:=ExecuteCommand_Linux(AProgramFilePath,ACommandLine,AWorkDir,ATag,AOnGetCommandLineOutput,ACommandLineOutputHelper);
//  {$ENDIF}
//
//
//end;


//  {$IFDEF LINUX}
//function ExecuteCommand_OnLinux(AProgramFilePath:String;ACommandLine: string;
//                              AWorkDir: string;
//                              ATag:String;
//                              //获取命令行输出的事件,因为要在界面上输出的
//                              AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//      //                        var PI: TProcessInformation;
//                              ACommandLineOutputHelper:TCommandLineOutputHelper=nil):String;
//begin
//
//end;
//  {$ENDIF}


//  {$IFDEF MSWINDOWS}
function ExecuteCommand(AProgramFilePath:String;
                        ACommandLine:String;
                        AParams:String;
                        AWorkDir:String;
                        ATag:String;
                        AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//                        var PI: TProcessInformation;
                        ACommandLineOutputHelper:TCommandLineOutputHelper;
                        var ADesc:String):Boolean;
//var
//  SA: TSecurityAttributes;
//  SI: TStartupInfo;
//  FPI: TProcessInformation;
//  StdOutPipeRead, StdOutPipeWrite: THandle;
//  WasOK: Boolean;
//  Handle: Boolean;
//
////  APosIndex:Integer;
////  ABufferSubStr: array [0 .. 2000] of AnsiChar;
////  ABuffer:PAnsiChar;
//  Buffer: array [0 .. 2000] of AnsiChar;
//  BytesRead: Cardinal;
////  AWorkDir: string;
var
  AExecuteCommand:TExecuteCommand;
begin
  Result := False;
  ADesc:='';

  AExecuteCommand:=TExecuteCommand.Create;
  try

    AExecuteCommand.FProgramFilePath:=AProgramFilePath;
    AExecuteCommand.FCommandLine:=ACommandLine;
    AExecuteCommand.FParams:=AParams;
    AExecuteCommand.FWorkDir:=AWorkDir;
    AExecuteCommand.FTag:=ATag;
    AExecuteCommand.FOnGetCommandLineOutput:=AOnGetCommandLineOutput;
    AExecuteCommand.FOtherCommandLineOutputHelper:=ACommandLineOutputHelper;

  //  Result:=AExecuteCommand.Execute(True,ADesc);
    Result:=AExecuteCommand.Execute(True,ADesc);
  //  if ACommandLineOutputHelper<>nil then
  //  begin
  //    AExecuteCommand.FOnGetCommandLineOutput:=ACommandLineOutputHelper.FOnGetCommandLineOutput;
  //    AExecuteCommand.FOnExecuteEnd:=ACommandLineOutputHelper.FOnExecuteEnd;
  //    AExecuteCommand.FOnGetData:=ACommandLineOutputHelper.FOnGetData;
  //    AExecuteCommand.FOnGetLog:=ACommandLineOutputHelper.FOnGetLog;
  //  end;
  finally
    FreeAndNil(AExecuteCommand);
  end;

end;

//  {$ENDIF}

function ExecuteCommandProcess(ACommandLine:String;
                                AWorkDir:String;
                                AParams:String):String;
//  {$IFDEF MSWINDOWS}
//var
//  SA: TSecurityAttributes;
//  SI: TStartupInfo;
//  Handle: Boolean;
//  {$ENDIF};
//                              var PI: TProcessInformation
begin
  {$IFDEF MSWINDOWS}
//  ShellExecute(0,'open',PWideChar(ACommandLine),'',PWideChar(AWorkDir),SW_SHOWNORMAL);
  ShellExecute(0,'open',PWideChar(ACommandLine),PWideChar(AParams),PWideChar(AWorkDir),
              SW_HIDE
              );
//  {$IFDEF MSWINDOWS}
//  Result := '';
//
//  with SA do
//  begin
//    nLength := SizeOf(SA);
//    bInheritHandle := True;
//    lpSecurityDescriptor := nil;
//  end;
//
//  with SI do
//  begin
//    FillChar(SI, SizeOf(SI), 0);
//    cb := SizeOf(SI);
//    dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
////    wShowWindow := SW_HIDE;
//    wShowWindow := SW_SHOW;
//  end;
//
//  Handle := CreateProcess(nil, PChar(ACommandLine), nil, nil,
//                          True, 0, nil, PChar(AWorkDir), SI, PI);
//
//  {$ENDIF}
  {$ENDIF}

end;



{ TCommandLineOutputHelper }


procedure TCommandLineOutputHelper.DoGetCommandLineOutput(ACommandLine, ATag,AOutput: String);
begin
  if ATag<>'' then
  begin
    Writeln(Output,ATag+':'+AOutput);
  end
  else
  begin
    Writeln(Output,AOutput);
  end;


end;

constructor TCommandLineOutputHelper.Create;
begin
  FCommandLineDataList:=TCommandLineDataList.Create;

end;

destructor TCommandLineOutputHelper.Destroy;
begin
  FreeAndNil(FCommandLineDataList);
  inherited;
end;

procedure TCommandLineOutputHelper.DoGetCommandLineBufferEvent(ABuffer: Pointer;
  ABytesRead: Cardinal;ABufferSize:Cardinal);
var
  AIndex:Integer;

  ALog:AnsiString;
  AData:AnsiString;
//  ALog:String;
//  AData:String;

  ADataJson:ISuperObject;
  AHasCommandLineDataBegin:Boolean;
  AHasCommandLineDataEnd:Boolean;
  ACommandLineData:TCommandLineData;
begin
  FLastBuffer:=PAnsiChar(ABuffer);
  FReadedDataString:=FReadedDataString+PAnsiChar(ABuffer);

  repeat

      //取出非数据包,日志
      ALog:='';
      AHasCommandLineDataBegin:=PosAndCutAnsiString(Const_CommandLineDataBegin,FReadedDataString,ALog,AIndex,False);
  //    AHasCommandLineDataBegin:=PosAndCutString(Const_CommandLineDataBegin,FReadedDataString,ALog,AIndex,False);


      if not AHasCommandLineDataBegin and (ABytesRead<ABufferSize) then
      begin
        ALog:=FReadedDataString;
        FReadedDataString:='';
      end;
      if (ALog<>'') then
      begin
        HandleException(nil,'TCommandLineOutputHelper.DoGetCommandLineBufferEvent Log:'+ALog);
        if Assigned(FOnGetLog) then
        begin
          FOnGetLog(Self,ALog);
        end;
      end;


      AHasCommandLineDataEnd:=False;
      if AHasCommandLineDataBegin then//有数据包
      begin

        //取出数据包
        AData:='';
        if PosAndCutAnsiString(Const_CommandLineDataEnd,FReadedDataString,AData,AIndex,True) then
  //      if PosAndCutString(Const_CommandLineDataEnd,FReadedDataString,AData,AIndex,True) then
        begin
          AHasCommandLineDataEnd:=True;
          AData:=Copy(AData,Length(Const_CommandLineDataBegin)+1,MaxInt);
          HandleException(nil,'TCommandLineOutputHelper.DoGetCommandLineBufferEvent Data:'+AData);
          ADataJson:=SO(AData);
          //有一个数据了,就立即处理
          if Assigned(FOnGetData) then
          begin
            FOnGetData(Self,AData,ADataJson);
          end;

          ACommandLineData:=TCommandLineData.Create;
          ACommandLineData.Data:=AData;
          ACommandLineData.DataJson:=ADataJson;
          FCommandLineDataList.Add(ACommandLineData);
        end;

      end;

  until not AHasCommandLineDataEnd;

end;


{ TReadPipeThread }


destructor TReadPipeThread.Destroy;
begin
  Inherited;
end;

constructor TReadPipeThread.Create(ACreateSuspended: Boolean;
  AExecuteCommand:TExecuteCommand
//  ATaskItem:TTaskItem;
//  AProgramFilePath:String;
//  ACommandLine: String;
//  AWorkDir:String;
//  AOnGetCommandLineOutput:TGetCommandLineOutputEvent;
//  AOnExecuteEnd:TNotifyEvent;
//  AOnGetData:TGetDataEvent;
//  AOnGetLog:TGetLogEvent
  );
begin
  Inherited Create(False);

//  FTaskItem:=ATaskItem;
//  FProgramFilePath:=AProgramFilePath;
//  FCommandLine:=ACommandLine;
//  FWorkDir:=AWorkDir;
//  FOnGetCommandLineOutput:=AOnGetCommandLineOutput;
//  FOnExecuteEnd:=AOnExecuteEnd;
//  FOnGetData:=AOnGetData;
//  FOnGetLog:=AOnGetLog;
  FExecuteCommand:=AExecuteCommand;


end;

procedure TReadPipeThread.Execute;
begin
  inherited;

  FExecuteCommand.ReadFromStdoutPipe;


  FExecuteCommand.ProcessKilled;



//  {$IFDEF MSWINDOWS}
////  ExecuteCommand(FProgramFilePath,FCommandLine,FWorkDir,'',FOnGetCommandLineOutput,
//////                FPI,
////                FCommandLineOutputHelper);
//  {$ENDIF}
//
////  if Assigned(FExecuteCommand.FOnExecuteEnd) then
////  begin
////    FExecuteCommand.FOnExecuteEnd(Self);
////  end;

end;

{ TExecuteCommand }

destructor TExecuteCommand.Destroy;
begin
  FreeAndNil(FCommandLineOutputHelper);
  FreeAndNil(FReadPipeThread);

  inherited;
end;

function TExecuteCommand.Execute(AIsSync:Boolean;//同步还是异步
                                  var ADesc:String):Boolean;
begin
  Result:=CreateProcess(ADesc);


  if Result and (putReadFromStdout in Self.FPipeUseTypes) then
  begin
        FreeAndNil(FReadPipeThread);
        if AIsSync then
        begin
          //同步执行管道读取
          Self.ReadFromStdoutPipe;

        end
        else
        begin
          //异步执行管道读取
          FReadPipeThread:=TReadPipeThread.Create(False,Self);//FProgramFilePath,FCommandLine,FWorkDir,nil,FOnExecuteEnd,FOnGetData,nil);
        end;

  end;


end;

constructor TExecuteCommand.Create;
begin
  FCommandLineOutputHelper:=TCommandLineOutputHelper.Create;
  FPipeUseTypes:=[putReadFromStdout];
end;

function TExecuteCommand.CreateProcess(var ADesc:String): Boolean;
begin
    Result:=False;
    ADesc:='';


    {$IFDEF MSWINDOWS}
    Result:=CreateProcessOnWindows(ADesc);
    {$ENDIF}
    {$IFDEF LINUX}
    Result:=CreateProcessOnLinux(ADesc);
    {$ENDIF}


end;

    {$IFDEF LINUX}
function TExecuteCommand.CreateProcessOnLinux(var ADesc: String): Boolean;
var
  AAnsiProgramFilePath:AnsiString;
  AAnsiCommandLine:AnsiString;
  AAnsiParams:AnsiString;
  AResult:Integer;
begin
  Result:=False;

//    AAnsiCommandLine:=FCommandLine;
//    Handle := popen(PAnsiChar(AAnsiCommandLine),'r');

  //返回值：成功，返回0，否则返回-1。参数数组包含pipe使用的两个文件的描述符。fd_stdout[0]:管道读端，fd_stdout[1]:管道写端。

  if pipe(@fd_stdout[0])=-1 then
  begin
      Writeln('创建stdout管道失败');
      Exit;
  end;


  if pipe(@fd_stdin[0])=-1 then
  begin
      Writeln('创建stdin管道失败');
      Exit;
  end;


  child_pid := fork;//创建一个子进程
  if child_pid = 0 then
  begin
        //是子进程
        //fork()的子进程默认继承父进程打开的管道


        Writeln('子进程 Begin');




        //0、1、2分别代表进程的标准输入、标准输出、标准错误流文件，默认是已打开状态
        // 关闭子进程的标准输入管道的读端
        __close(0);
        //改为，即重定向到fd_stdin[0]， 即fd_stdin管道 的读端
        dup(fd_stdin[0]);

        //关闭原先用来从管道读取数据的文件描述符
        __close(fd_stdin[0]);
        //关闭原先用于向管道写数据的文件描述符
        __close(fd_stdin[1]);

        Writeln('子进程 重定向stdin管道');




        //0、1、2分别代表进程的标准输入、标准输出、标准错误流文件，默认是已打开状态
        // 关闭子进程的标准输出
        __close(1);
        // 利用dup(fd[1]])从管道写端复制一个描述符，新文件新的文件为最小可用的文件描述符，即上面关闭的1，所以这里是将标准输出重定向至管道写端
        //改为，即重定向输出到fd_stdout[1]
        dup(fd_stdout[1]);

        //关闭原先用来从管道读取数据的文件描述符
        //关闭管道读端
        __close(fd_stdout[0]);
        //关闭原先用于向管道写数据的文件描述符
        //关闭已复制的文件描述符
        __close(fd_stdout[1]);
        Writeln('子进程 重定向stdout管道');



        //param:=PAnsiChar(GetApplicationPath+'hello.py');
        //param:='inputname.py';//PAnsiChar(GetApplicationPath+'hello.py');
        //Writeln(GetApplicationPath);


        //执行python命令,并通过读取管道读取打印的结果
//        execl('/usr/bin/python3',param,nil);
//        execlp('/usr/bin/python3','python3',param,nil);


        AAnsiProgramFilePath:=FProgramFilePath;
        AAnsiCommandLine:=FCommandLine;
        AAnsiParams:=FParams;
        Writeln('子进程 准备执行命令');
        AResult:=execlp(PAnsiChar(AAnsiProgramFilePath),PAnsiChar(AAnsiCommandLine),PAnsiChar(AAnsiParams),nil);
        if AResult=-1 then
        begin
          Writeln('子进程 命令执行失败');
        end
        else
        begin
          Writeln('子进程 命令执行成功');
        end;

//        execl('/bin/ls','-l',nil);

//        system('/usr/bin/python3 hello.py');


        Writeln('子进程 End');



        //退出子进程
        _exit(0);

  end;


  //是父进程




  // 关闭输出管道写端
  __close(fd_stdout[1]);


  // 关闭输入管道读端
  __close(fd_stdin[0]);


  Result:=True;
end;
    {$ENDIF}


    {$IFDEF MSWINDOWS}
function TExecuteCommand.CreateProcessOnWindows(var ADesc: String): Boolean;
var
    SA: TSecurityAttributes;
    SI: TStartupInfo;
begin

    //安全属性,TSecurityAttributes
    with SA do
    begin
      nLength := SizeOf(SA);
      bInheritHandle := True;
      lpSecurityDescriptor := nil;
    end;


    //创建进程间读通道
    //一条用于重定向子进程的输出管道stdout
    if (putReadFromStdout in FPipeUseTypes) then
    begin
      CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
    end;

    //一条用于重定向子进程的输入管道stdin
    if (putWriteToStdin in FPipeUseTypes) then
    begin
      CreatePipe(StdinPipeRead, StdinPipeWrite, @SA, 0);
    end;


//  try

    //TStartupInfo
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;


      //先判断是否需要重定向输入
      //子进程从StdinPipeRead获取用户输入
      if (putWriteToStdin in FPipeUseTypes) then
      begin
  //      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
        hStdInput := StdinPipeRead;//GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      end;


      //子进程的输出写入到StdOutPipeWrite
      if (putReadFromStdout in FPipeUseTypes) then
      begin
        hStdOutput := StdOutPipeWrite;
        hStdError := StdOutPipeWrite;
      end;
    end;




    FillChar(FPI, SizeOf(FPI), 0);



//    AWorkDir := Work;



    //https://wenku.baidu.com/view/6351a03a5aeef8c75fbfc77da26925c52cc59108.html
//    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + ACommandLine), nil, nil,
//      True, 0, nil, PChar(AWorkDir), SI, PI);
    //不传AProgramFilePath会报错
    Result := CreateProcessW(PWideChar(FProgramFilePath),PWideChar(FCommandLine+' '+FParams), nil, nil,True, 0, nil, PWideChar(FWorkDir), SI, FPI);



    if (putReadFromStdout in FPipeUseTypes) then
    begin
      //关闭了stdout的写端,因为写在子进程写,父进程不需要写
      CloseHandle(StdOutPipeWrite);
      StdOutPipeWrite:=0;
    end;



    if (putWriteToStdin in FPipeUseTypes) then
    begin
      //关闭了stdin的读端，因为获取输入在子进程获取,父进程不需要写
      CloseHandle(StdinPipeRead);
      StdinPipeRead:=0;

    end;




    if Result then
    begin


    end
    else
    begin

        try
          //进程创建失败
          RaiseLastOSError;

        except
          on E:Exception do
          begin
              HandleException(E,'TReadPipeThread.CreateProcess');
              ADesc:=E.Message;
  //          if Assigned(AOnGetCommandLineOutput) then
  //          begin
  //            AOnGetCommandLineOutput(ACommandLine,ATag,'进程创建失败:'+E.Message);
  //          end;

          end;
        end;

    end;


end;
    {$ENDIF}


procedure TExecuteCommand.ReadFromStdoutPipe;
begin
  FCommandLineOutputHelper.FOnGetData:=Self.FOnGetData;
  FCommandLineOutputHelper.FOnGetLog:=Self.FOnGetLog;

  {$IFDEF MSWINDOWS}
  PipeReadOnWindows;
  {$ENDIF}

  {$IFDEF LINUX}
  PipeReadOnLinux;
  {$ENDIF}


  //执行结束
  if Assigned(Self.FOnExecuteEnd) then
  begin
    Self.FOnExecuteEnd(Self);
  end;

end;

  {$IFDEF LINUX}
procedure TExecuteCommand.PipeReadOnLinux;
//var
//  Buffer: array[0..512] of AnsiChar;
//  BytesRead: Cardinal;
//  AAnsiCommandLine:AnsiString;
begin

  if Assigned(FOnGetCommandLineOutput) then
  begin
    FOnGetCommandLineOutput(FCommandLine,FTag,'准备执行命令:'+FCommandLine);
  end;



  while True do
  begin

    WriteLn('TExecuteCommand.PipeReadOnLinux __read begin');
    //从输出管道读取数据
    BytesRead:=__read(fd_stdout[0],@Buffer[0],SizeOf(Buffer)-1);
    WriteLn('TExecuteCommand.PipeReadOnLinux __readed bytes length:'+IntToStr(BytesRead));


    if BytesRead=0 then
    begin
      Break;
    end;
    Buffer[BytesRead]:=#0;

    if FCommandLineOutputHelper<>nil then
    begin
      FCommandLineOutputHelper.DoGetCommandLineBufferEvent(@Buffer[0],BytesRead,SizeOf(Buffer)-1);
    end;

    try
      if Assigned(FOnGetCommandLineOutput) then
      begin
        FOnGetCommandLineOutput(FCommandLine,FTag,Buffer);
      end;
    except

    end;

    //Writeln(Buffer);

  end;


//    Buffer[Sizeof(Buffer)-1]:=chr(0);
//
//    while fgets(@Buffer[0],Sizeof(Buffer)-1,Handle)<>nil do
//    begin
//
//        //Writeln('read a line from pipe:'+BufferToString(@Data[0],sizeof(Data)));
//        //Write(BufferToString(@Data[0],sizeof(Data)));
//
//        BytesRead:=BufferLength(@Buffer[0],sizeof(Buffer)-1);
//
//        if FCommandLineOutputHelper<>nil then
//        begin
//          FCommandLineOutputHelper.DoGetCommandLineBufferEvent(@Buffer[0],BytesRead,SizeOf(Buffer)-1);
//        end;
//
//        try
//          if Assigned(FOnGetCommandLineOutput) then
//          begin
//            FOnGetCommandLineOutput(FCommandLine,FTag,Buffer);
//          end;
//        except
//
//        end;
//
//
//    end;


  if Assigned(FOnGetCommandLineOutput) then
  begin
    FOnGetCommandLineOutput(FCommandLine,FTag,'命令执行结束');
  end;

end;
  {$ENDIF}

    {$IFDEF MSWINDOWS}
procedure TExecuteCommand.PipeReadOnWindows;
var
  WasOK: Boolean;
begin

      if Assigned(FOnGetCommandLineOutput) then
      begin
        FOnGetCommandLineOutput(FCommandLine,FTag,'准备执行命令:'+FCommandLine+' '+Self.FParams);
      end;






          repeat
            WasOK := ReadFile(StdOutPipeRead, Buffer, Length(Buffer)-1, BytesRead, nil);
  //          WasOK := ReadFile(StdOutPipeRead, Buffer, 10, BytesRead, nil);


            if BytesRead > 0 then
            begin



              Buffer[BytesRead] := #0;
//              Result := Result + Buffer;


  //            //从Buffer中取出一行
  //            APosIndex:=StrPos(Buffer,PAnsiChar(#13#10));
  //            if APosIndex>=0 then
  //            begin
  //              //有换行符
  //            end
  //            else
  //            begin
  //              //没有换行符
  //              ABuffer:=Buffer;
  //            end;

              if FCommandLineOutputHelper<>nil then
              begin
                FCommandLineOutputHelper.DoGetCommandLineBufferEvent(@Buffer[0],BytesRead,2000-1);
              end;

              if FOtherCommandLineOutputHelper<>nil then
              begin
                FOtherCommandLineOutputHelper.DoGetCommandLineBufferEvent(@Buffer[0],BytesRead,2000-1);
              end;

              try
                if Assigned(FOnGetCommandLineOutput) then
                begin
                  FOnGetCommandLineOutput(FCommandLine,FTag,Buffer);
                end;
              except

              end;


            end;


          until not WasOK or (BytesRead = 0);




      if Assigned(FOnGetCommandLineOutput) then
      begin
        FOnGetCommandLineOutput(FCommandLine,FTag,'命令执行结束');
      end;

end;
    {$ENDIF}


function TExecuteCommand.WriteToStdinPipe(AInput: String):Boolean;
var
  ABuffer: TBytes;//array [0 .. 2000] of AnsiChar;
  ABytesWrite: Cardinal;
  AAnsiInput:String;
begin
  Result:=False;

  {$IFDEF MSWINDOWS}
  AInput:=AInput+#13#10;//要加回车,不然子进程读取不到

  ABuffer:=TEncoding.UTF8.GetBytes(AInput);
  //function WriteFile(hFile: THandle; const Buffer; nNumberOfBytesToWrite: DWORD;
  //  var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;
  Result := WriteFile(StdinPipeWrite, ABuffer[0], Length(ABuffer), ABytesWrite, nil);
  {$ENDIF}

  {$IFDEF LINUX}
  AInput:=AInput+#10;//要加回车,不然子进程读取不到

  ABuffer:=TEncoding.UTF8.GetBytes(AInput);
  //往stdin输入管道 写入数据
  ABytesWrite:=__write(fd_stdin[1],@ABuffer[0],Length(ABuffer));
  Result:=ABytesWrite>0;
  {$ENDIF}

end;


procedure TExecuteCommand.ProcessKilled;
begin


  {$IFDEF MSWINDOWS}
  if FPI.hProcess>0 then
  begin
    CloseHandle(FPI.hThread);
    CloseHandle(FPI.hProcess);

    FPI.hThread:=0;
    FPI.hProcess:=0;

    if StdOutPipeRead>0 then
    begin
      CloseHandle(StdOutPipeRead);
    end;
    StdOutPipeRead:=0;
    //关闭了写通道？
    if StdOutPipeWrite>0 then
    begin
      CloseHandle(StdOutPipeWrite);
    end;
    StdOutPipeWrite:=0;


    if StdinPipeRead>0 then
    begin
      CloseHandle(StdinPipeRead);
    end;
    StdinPipeRead:=0;
    //关闭了写通道？
    if StdinPipeWrite>0 then
    begin
      CloseHandle(StdinPipeWrite);
    end;
    StdinPipeWrite:=0;


  end;

  {$ENDIF}

  {$IFDEF LINUX}
//  pclose(Handle);
  //关闭输出管道的读端
  __close(fd_stdout[0]);

  //关闭输入管端的写端
  __close(fd_stdin[1]);
  {$ENDIF}

end;


procedure TExecuteCommand.WaitFor;
begin
  if Self.FReadPipeThread<>nil then
  begin
    Self.FReadPipeThread.WaitFor;
  end;

  {$IFDEF MSWINDOWS}
  if FPI.hProcess>0 then
  begin
    WaitForSingleObject(FPI.hProcess, INFINITE);
  end;
  {$ENDIF}

  ProcessKilled;
end;

//initialization
//  GlobalCommandLineOutputHelper:=TCommandLineOutputHelper.Create;
//
//finalization
//  FreeAndNil(GlobalCommandLineOutputHelper);


{ TCommandLineDataList }

function TCommandLineDataList.Find(AFunctionName: String): TCommandLineData;
var
  I: Integer;
begin
  Result:=nil;
  for I := Self.Count-1 downto 0 do
  begin
    if Items[I].DataJson.S['FunctionName']=AFunctionName then
    begin
      Result:=Items[I];
      Break;
    end;

  end;
end;

function TCommandLineDataList.GetItem(Index: Integer): TCommandLineData;
begin
  Result:=TCommandLineData(Inherited Items[Index]);
end;



end.












