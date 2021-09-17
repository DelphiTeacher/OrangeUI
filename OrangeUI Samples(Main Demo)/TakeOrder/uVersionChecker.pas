//convert pas to utf8 by ¥
unit uVersionChecker;


interface

uses
  System.SysUtils,uFuncCommon, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms,


  uManager,
  uFileCommon,
  uBaseLog,

  WaitingFrame,
  MessageBoxFrame,

  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,

  IniFiles,

  IdURI,
  StrUtils,
  uIdHttpControl,

  Math,
  System.IOUtils,
  uMobileUtils;



type
  //版本检测
  TVersionChecker=class
  private
    //是否正在检测新版本
    FIsCheckingNewVersion:Boolean;

    GlobalTimerThread:TTimerThread;

    //新APK下载的路径
    FURL:String;


    //检测新版本
    procedure DoCheckNewVersionExecute(ATimerTask:TObject);
    procedure DoCheckNewVersionExecuteEnd(ATimerTask:TObject);

    //选择是否更新
    procedure DoSelectAppUpdateMethodUseSelectMessageBoxModalResult(Sender:TObject);
  public
    //检测新版本
    procedure CheckNewVersion;
  public
    destructor Destroy;override;
  end;


var
  GlobalVersionChecker:TVersionChecker;

  //IOS和Android的版本更新节点要分开Version.ini
  ReadSection:String;


implementation

uses
  MainForm,
  UpdateFrame;



{ TVersionChecker }

procedure TVersionChecker.CheckNewVersion;
begin
  if Not FIsCheckingNewVersion then
  begin
    FIsCheckingNewVersion:=True;
    GlobalTimerThread:=TTimerThread.Create(True);



    GlobalTimerThread.RunTempTask(
            DoCheckNewVersionExecute,
            DoCheckNewVersionExecuteEnd
                           );

//    GetGlobalTimerThread.RunTempTask(
//            DoCheckNewVersionExecute,
//            DoCheckNewVersionExecuteEnd
//            );

  end;
end;


destructor TVersionChecker.Destroy;
begin
  uFuncCommon.FreeAndNil(GlobalTimerThread);
  inherited;
end;

procedure TVersionChecker.DoCheckNewVersionExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
  AResponseStream:TMemoryStream;
begin
  //下载版本文件Version.ini

  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  AHttpControl:=TSystemHttpControl.Create;
  AResponseStream:=TMemoryStream.Create;
  try
    try
      AHttpControl.Get(
                        TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Update/Version.ini'),
                        AResponseStream
                        );
      AResponseStream.Position:=0;
      AResponseStream.SaveToFile(uFileCommon.GetApplicationPath+'Version.ini');

      TTimerTask(ATimerTask).TaskTag:=0;

    except
      on E:Exception do
      begin
        //异常
        HandleException(E,'TVersionChecker.DoCheckNewVersionExecute');
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;

  finally
    uFuncCommon.FreeAndNil(AHttpControl);
    uFuncCommon.FreeAndNil(AResponseStream);
  end;
end;

procedure TVersionChecker.DoCheckNewVersionExecuteEnd(ATimerTask: TObject);
var
  AIniFile:TIniFile;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin

        if FileExists(uFileCommon.GetApplicationPath+'Version.ini') then
        begin

            AIniFile:=TIniFile.Create(uFileCommon.GetApplicationPath+'Version.ini'{$IFNDEF MSWINDOWS},TEncoding.UTF8{$ENDIF});

            try
                //检查新版本成功

                //检测版本
                if AIniFile.ReadString(ReadSection,'Version','')>CurrentVersion then
                begin

                    FURL:=AIniFile.ReadString(ReadSection,'Url','');


                    //检测是否必须升级
                    if AIniFile.ReadBool(ReadSection,'MustUpdate',False) then
                    begin
                        //提示有新版本,必须升级
                        ShowMessageBoxFrame(frmMain,
                                    AIniFile.ReadString(ReadSection,'UpdateLog',''),
                                    '',
                                    TMsgDlgType.mtCustom,
                                    ['立即更新'],
                                    Self.DoSelectAppUpdateMethodUseSelectMessageBoxModalResult,
                                    nil,
                                    '程序更新(更新版本:'+AIniFile.ReadString(ReadSection,'Version','')+')');
                    end
                    else
                    begin
                        //有新版本,不强制升级
                        ShowMessageBoxFrame(frmMain,
                                    AIniFile.ReadString(ReadSection,'UpdateLog',''),
                                    '',
                                    TMsgDlgType.mtCustom,
                                    ['立即更新','稍后再说'],
                                    Self.DoSelectAppUpdateMethodUseSelectMessageBoxModalResult,
                                    nil,
                                    '程序更新(更新版本:'+AIniFile.ReadString(ReadSection,'Version','')+')');
                    end;


                end;
            finally
              FreeAndNil(AIniFile);
            end;


        end
        else
        begin
          //检查新版本失败
          HandleException(nil,'TVersionChecker.DoCheckNewVersionExecuteEnd Version.ini Not Existed');
        end;

    end;
  finally
    FIsCheckingNewVersion:=False;
  end;

end;

procedure TVersionChecker.DoSelectAppUpdateMethodUseSelectMessageBoxModalResult(Sender: TObject);
begin
  //选择升级方式
  if GlobalMessageBoxFrame.ModalResult='立即更新' then
  begin

    {$IFDEF IOS}
    //IOS跳到AppStore
    OpenWebBrowserAndNavigateURL(FURL);
    {$ELSE}
    //Android跳转到更新页面
    ShowFrame(TFrame(GlobalUpdateFrame),TFrameUpdate,frmMain,nil,nil,nil,Application,False,False,ufsefNone);
    GlobalUpdateFrame.UpdateApp(
          ImageHttpServerUrl+'/Upload/Update/'+FURL,
          System.IOUtils.TPath.GetSharedDownloadsPath+PathDelim+ExtractFileName(FURL)
          );
    {$ENDIF}

  end;
end;


initialization
  GlobalVersionChecker:=TVersionChecker.Create;

  ReadSection:='Android';
  {$IFDEF IOS}
  ReadSection:='IOS';
  {$ENDIF}


finalization
  uFuncCommon.FreeAndNil(GlobalVersionChecker);



end.
