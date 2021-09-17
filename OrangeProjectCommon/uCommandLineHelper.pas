unit uCommandLineHelper;

interface

uses
  SysUtils, Types, Classes, Variants,

  {$IFDEF MSWINDOWS}
  Windows,
//  Forms,
  ShellAPI,
  {$ENDIF}


  {$IF CompilerVersion <= 21.0} // D2010之前
  SuperObject,
  superobjecthelper,
  {$ELSE}
    {$IFDEF IN_ORANGESDK}
    XSuperObject_Copy,
    {$ELSE}
    XSuperObject,
    XSuperJson,
    {$ENDIF}
  {$IFEND}


  XMLDoc,
  XMLIntf;


type
  TGetCommandLineOutputEvent=procedure(ACommandLine:String;ATag:String;AOutput:String) of object;


  TCommandLineOutputHelper=class
  public
    procedure DoGetCommandLineOutput(ACommandLine:String;ATag:String;AOutput:String);
  end;


  {$IFDEF MSWINDOWS}
  //执行命令行的线程
  TExecuteCommandThread=class(TThread)
  public
//    FTaskItem:TTaskItem;
    FCommandLine:String;
    FWorkDir:String;
    FPI: TProcessInformation;
    FOnGetCommandLineOutputEvent:TGetCommandLineOutputEvent;
    FOnExecuteEnd:TNotifyEvent;
    procedure Execute;override;
  public
    constructor Create(ACreateSuspended:Boolean;
//                        ATaskItem:TTaskItem;
                        ACommandLine:String;
                        AWorkDir:String;
                        AOnGetCommandLineOutputEvent:TGetCommandLineOutputEvent;
                        AOnExecuteEnd:TNotifyEvent);
  end;



//执行命令行,获取命令行的结果
function ExecuteCommand(ACommandLine: string;
                        AWorkDir: string;
                        ATag:String;
                        var AGetCommandLineOutputEvent:TGetCommandLineOutputEvent;
                        var PI: TProcessInformation):String;

function ExecuteCommandProcess(ACommandLine: string;
                              AWorkDir: string;
                              AParams:String=''):String;
  {$ENDIF}



var
  GlobalCommandLineOutputHelper:TCommandLineOutputHelper;

implementation




  {$IFDEF MSWINDOWS}
function ExecuteCommand(ACommandLine:String;
                        AWorkDir:String;
                        ATag:String;
                        var AGetCommandLineOutputEvent:TGetCommandLineOutputEvent;
                        var PI: TProcessInformation):String;
  {$IFDEF MSWINDOWS}
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
//  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array [0 .. 2000] of AnsiChar;
  BytesRead: Cardinal;
//  AWorkDir: string;
  Handle: Boolean;

//  APosIndex:Integer;
//  ABufferSubStr: array [0 .. 2000] of AnsiChar;
//  ABuffer:PAnsiChar;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := '';


  if Assigned(AGetCommandLineOutputEvent) then
  begin
    AGetCommandLineOutputEvent(ACommandLine,ATag,'准备执行命令:'+ACommandLine);
  end;


  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;


  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;



//    AWorkDir := Work;


//    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + ACommandLine), nil, nil,
//      True, 0, nil, PChar(AWorkDir), SI, PI);
    Handle := CreateProcess(nil, PChar(ACommandLine), nil, nil,
      True, 0, nil, PChar(AWorkDir), SI, PI);
    CloseHandle(StdOutPipeWrite);


    if Handle then
      try

          repeat
            WasOK := ReadFile(StdOutPipeRead, Buffer, Length(Buffer)-1, BytesRead, nil);
  //          WasOK := ReadFile(StdOutPipeRead, Buffer, 10, BytesRead, nil);
            if BytesRead > 0 then
            begin
              Buffer[BytesRead] := #0;
              Result := Result + Buffer;


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



              try
                if Assigned(AGetCommandLineOutputEvent) then
                begin
                  AGetCommandLineOutputEvent(ACommandLine,ATag,Buffer);
                end;
              except

              end;


            end;
          until not WasOK or (BytesRead = 0);
          WaitForSingleObject(PI.hProcess, INFINITE);

      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);

        PI.hThread:=0;
        PI.hProcess:=0;
      end;



      if Assigned(AGetCommandLineOutputEvent) then
      begin
        AGetCommandLineOutputEvent(ACommandLine,ATag,'命令执行结束');
      end;


  finally
    CloseHandle(StdOutPipeRead);
  end;
  {$ENDIF}



end;


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

end;

  {$ENDIF}

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


  {$IFDEF MSWINDOWS}

{ TExecuteCommandThread }

constructor TExecuteCommandThread.Create(ACreateSuspended: Boolean;
//  ATaskItem:TTaskItem;
  ACommandLine: String;
  AWorkDir:String;
  AOnGetCommandLineOutputEvent:TGetCommandLineOutputEvent;
  AOnExecuteEnd:TNotifyEvent);
begin
  Inherited Create(False);

//  FTaskItem:=ATaskItem;
  FCommandLine:=ACommandLine;
  FWorkDir:=AWorkDir;
  FOnGetCommandLineOutputEvent:=AOnGetCommandLineOutputEvent;
  FOnExecuteEnd:=AOnExecuteEnd;
end;

procedure TExecuteCommandThread.Execute;
begin
  inherited;

  ExecuteCommand(FCommandLine,FWorkDir,'',FOnGetCommandLineOutputEvent,FPI);

  if Assigned(FOnExecuteEnd) then
  begin
    FOnExecuteEnd(Self);
  end;

end;
  {$ENDIF}



initialization
  GlobalCommandLineOutputHelper:=TCommandLineOutputHelper.Create;

finalization
  FreeAndNil(GlobalCommandLineOutputHelper);


end.




