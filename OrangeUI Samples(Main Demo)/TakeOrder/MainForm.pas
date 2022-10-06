//convert pas to utf8 by ¥

unit MainForm;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Messaging,

  uBaseLog,
  uFuncCommon,
  uComponentType,
  uFrameContext,
//  uVersionChecker,

  uUIFunction,
  uManager,

//  uPayAPIParam,
  uGraphicCommon,
  uBaseHttpControl,

  XSuperObject,
  XSuperJson,

  uTimerTask,
  uInterfaceClass,
  FMX.DeviceInfo,
  uGetDeviceInfo,
//  uFrameContext,
  EasyServiceCommonMaterialDataMoudle,


  FMX.Platform,

  {$IFDEF ANDROID}
  Androidapi.JNI.Net,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
  Androidapi.JNI.App,
  FMX.Helpers.Android,
  {$ENDIF}



  FMX.TKRBarCodeScanner,


  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyImage, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, IdBaseComponent, IdComponent, IdIPWatch,
  System.Notification, FMX.Objects, FMX.Gestures, System.Sensors,
  System.Sensors.Components, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyButton, uSkinButtonType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinPanelType;


const
  //扫描二维码的请求码
  ScanRequestCode = 0;


type
  TfrmMain = class(TForm)
    pnlVirtualKeyBoard: TSkinFMXPanel;
    tmrScanResult: TTimer;
    idpSummaryFilter: TSkinFMXItemDesignerPanel;
    lblDate: TSkinFMXButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure tmrScanResultTimer(Sender: TObject);
    { Private declarations }
  private
    FGestureManager:TGestureManager;
  private
    //获取当前版本
//    procedure GetVersionName;
    { Private declarations }
  public

    //登录
    procedure Login;
    //退出登录
    procedure Logout;

  private
    //IOS
    //扫描二维码
    TKRBarCodeScanner: TTKRBarCodeScanner;
    //启动扫描结果处理的定时器
    procedure TKRBarCodeScannerScanResult(Sender: TObject; AResult: string);
  private
    //Android
    //扫描二维码
    FMessageSubscriptionID: Integer;
    //扫描结果
    FScanFormat:String;
    FScanContent:String;
    {$IFDEF ANDROID}
    //启动扫描结果处理的定时器
    function OnActivityResult(RequestCode, ResultCode: Integer; Data: JIntent): Boolean;
    {$ENDIF}
    procedure HandleActivityMessage(const Sender: TObject; const M: TMessage);
  public
    //扫描二维码
    procedure ScanBarCode;
  protected
    FApplicationEventService:IFMXApplicationEventService;
    function DoApplicationEventHandler(AAppEvent: TApplicationEvent; AContext: TObject):Boolean;
    { Public declarations }
  end;




var
  frmMain: TfrmMain;


procedure LaunchQRScanner(RequestCode: Integer);

implementation


uses
  MainFrame,
//  ApplyIntroducerFrame,
  WebBrowserFrame,
//  FillUserInfoFrame,
  ClipHeadFrame,
  LoginFrame;


procedure LaunchQRScanner(RequestCode: Integer);
  {$IFDEF ANDROID}
var
  Intent: JIntent;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
  Intent := TJIntent.JavaClass.init;
  Intent.setClassName(SharedActivityContext, StringToJString('com.google.zxing.client.android.CaptureActivity'));
  //如果要预定扫描格式，UnComment 下面文字
  //Intent.putExtra(StringToJString('SCAN_MODE'), StringToJString('QR_CODE_MODE'));
  SharedActivity.startActivityForResult(Intent, RequestCode);
  {$ENDIF}
end;


{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin


  //获取设备详情
  DeviceInfoByPlatform;



  {$IFNDEF MSWINDOWS}
  //在有些Windows的电脑上
  //窗体上放TGestureManager会报错
  FGestureManager:=TGestureManager.Create(Self);
  Self.Touch.GestureManager:=FGestureManager;
  {$ENDIF}




  //在Windows平台下的模拟虚拟键盘控件
  SimulateWindowsVirtualKeyboardHeight:=160;
  IsSimulateVirtualKeyboardOnWindows:=True;
  GlobalAutoProcessVirtualKeyboardControlClass:=TSkinFMXPanel;
  GlobalAutoProcessVirtualKeyboardControl:=pnlVirtualKeyBoard;
  GlobalAutoProcessVirtualKeyboardControl.Visible:=False;
  {$IFNDEF MSWINDOWS}
  pnlVirtualKeyBoard.SelfOwnMaterialToDefault.IsTransparent:=True;
  pnlVirtualKeyBoard.Caption:='';
  {$ENDIF}
//  //修复Android下的虚拟键盘隐藏和显示
//  GetGlobalVirtualKeyboardFixer.StartSync(Self);

end;

procedure TfrmMain.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  FMX.Types.Log.d('OrangeUI TfrmMain.FormGesture');

  if CurrentFrame=GlobalClipHeadFrame then
  begin
    GlobalClipHeadFrame.DoGesture(Sender,EventInfo,Handled);
  end;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if
    (Key = vkHardwareBack)
    //Windows下Escape键模拟返回键
//    or (Key = vkEscape)
    then
  begin
    //返回
    if (CurrentFrameHistroy.ToFrame<>nil)
        //如果当前是登陆页面,不返回上一页
       and (CurrentFrameHistroy.ToFrame<>GlobalLoginFrame)
        //如果当前是主页面,不返回上一页
       and (CurrentFrameHistroy.ToFrame<>GlobalMainFrame)
       then
    begin
      if CanReturnFrame(CurrentFrameHistroy)=TFrameReturnActionType.fratDefault then
      begin
        HideFrame;////(CurrentFrameHistroy.ToFrame,hfcttBeforeReturnFrame);
        ReturnFrame;//(CurrentFrameHistroy);

        Key:=0;
        KeyChar:=#0;
      end
      else
      begin
        //表示当前Frame不允许返回
      end;
    end
    else
    begin
      {$IFDEF ANDROID}
      //程序退到后台挂起,需要引用Androidapi.Helpers单元
      FMX.Types.Log.d('OrangeUI moveTaskToBack');
      SharedActivity.moveTaskToBack(False);

      //表示不关闭APP
      Key:=0;
      KeyChar:=#0;
      {$ENDIF}
    end;
  end;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin


  //不较正一个像素的线条
  //不然ListBox滑动的时候分隔线会不对
  uGraphicCommon.IsAdjustDrawLinePos:=False;


  {$IFDEF ANDROID}

  OutputDebugString('OrangeUI OSVersion '+TOSVersion.ToString);
  OutputDebugString('OrangeUI OSVersion Major '+IntToStr(TOSVersion.Major));
  OutputDebugString('OrangeUI OSVersion Minor '+IntToStr(TOSVersion.Minor));
  OutputDebugString('OrangeUI OSVersion Build '+IntToStr(TOSVersion.Build));

  //Android 4.4.4及以上版本
  if (TOSVersion.Major>4)
    or (TOSVersion.Major=4)
    and (TOSVersion.Minor>=4)
    and (TOSVersion.Build>=4)
    //有时候不准
    or (Pos('4.4.4',TOSVersion.ToString)>0) then
  begin
    //Android下用了透明任务栏的模式
    //顶部任务栏用Panel增高的方式
    uComponentType.IsAndroidIntelCPU:=True;
  end;
  {$ENDIF}



//  Self.GetVersionName;
//  {$IFNDEF IOS}
//  //检查新版本
//  GlobalVersionChecker.CheckNewVersion();
//  {$ENDIF}




  //图片上传下载地址
  ImageHttpServerUrl:='http://www.orangeui.cn:9001';
  //服务端接口地址
  InterfaceUrl:='http://www.orangeui.cn:9000/easyservice/';



  //应用ID
  AppID:=1001;


  //加载上次登录的用户名和密码
  GlobalManager.Load;
  //显示登录界面
  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;




  //注册程序事件(用于推送)
  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(FApplicationEventService)) then
  begin
    FApplicationEventService.SetApplicationEventHandler(DoApplicationEventHandler);
  end;

end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);
end;

//procedure TfrmMain.GetVersionName;
//{$IFDEF ANDROID}
//var
//  Manager:JPackageManager;
//  Info:JPackageInfo;
//  Version:JString;
//{$ENDIF}
//begin
//  {$IFDEF ANDROID}
//  Manager:=SharedActivityContext.getPackageManager;
//  Info:=Manager.getPackageInfo(SharedActivityContext.getPackageName,0);
//  Version:=Info.versionName;
//
////  CurrentVersion:=JStringToString(Version);
//  {$ENDIF}
//end;

procedure TfrmMain.Login;
begin

  //为不同的角色分配权限
  //获取未读通知数
  GlobalMainFrame.Login;


  //把窗体颜色改为黑色
  //因为要把IOS下面状态栏的字体改为白色
  Self.Fill.Color:=SkinThemeColor;
  UpdateFormStatusBarColor(Self);
  Self.Fill.Color:=TAlphaColorRec.White;
end;

procedure TfrmMain.Logout;
begin


  if GlobalMainFrame<>nil then
  begin
    GlobalMainFrame.Logout;
  end;


  //把窗体颜色改为白色
  //因为要把IOS下面状态栏的字体改为黑色
  Self.Fill.Color:=TAlphaColorRec.White;
  UpdateFormStatusBarColor(Self);
end;

function TfrmMain.DoApplicationEventHandler(AAppEvent: TApplicationEvent;AContext: TObject): Boolean;
begin


  case AAppEvent of
    TApplicationEvent.FinishedLaunching:
    begin
      //程序第一次启动结束
      HandleException(nil,'FinishedLaunching');
    end;
    TApplicationEvent.BecameActive:
    begin
      //转到前台
      HandleException(nil,'BecameActive');

      //更新推送前后台状态
//      UpdatePushIsAtBackground(True);
    end;
    TApplicationEvent.WillBecomeInactive:
    begin
      HandleException(nil,'WillBecomeInactive');
    end;
    TApplicationEvent.EnteredBackground:
    begin
      //转到后台
      HandleException(nil,'EnteredBackground');

      //更新推送前后台状态
//      UpdatePushIsAtBackground(False);
    end;
    TApplicationEvent.WillBecomeForeground:
    begin
      HandleException(nil,'WillBecomeForeground');
    end;
    TApplicationEvent.WillTerminate:
    begin
      HandleException(nil,'WillTerminate');
    end;
    TApplicationEvent.LowMemory:
    begin
      HandleException(nil,'LowMemory');
    end;
    TApplicationEvent.TimeChange:
    begin

    end;
    TApplicationEvent.OpenURL:
    begin

    end;
  end;

end;

procedure TfrmMain.ScanBarCode;
//  {$IFDEF ANDROID}
//var
//  LIntent: JIntent;
//  {$ENDIF}
begin
//  FScanContent:='';
//  FScanFormat:='';
//
//
//
//  //扫描二维码
//  //启动二维码扫描
//  {$IFDEF ANDROID}
//  FMessageSubscriptionID := TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification,HandleActivityMessage);
//  LaunchQRScanner(ScanRequestCode);
//  {$ENDIF}
//
//
//
//  {$IFDEF IOS}
//  if TKRBarCodeScanner=nil then
//  begin
//    TKRBarCodeScanner:=TTKRBarCodeScanner.Create(Self);
//    TKRBarCodeScanner.OnScanResult:=TKRBarCodeScannerScanResult;
//  end;
//  TKRBarCodeScanner.Scan;
//  {$ENDIF}
//
//
//
//  //Windows下面测试
//  {$IFDEF MSWINDOWS}
//  FScanFormat:='QR_CODE';
////  FScanContent:='http://www.orangeui.cn';
//  FScanContent:='http://www.orangeui.cn/register?bind_code=3V5GOZ';
//  Self.tmrScanResult.Enabled:=True;
//  {$ENDIF}



end;

procedure TfrmMain.TKRBarCodeScannerScanResult(Sender: TObject;AResult: string);
begin
  FScanFormat:='QR_CODE';
  FScanContent:=AResult;

  uBaseLog.OutputDebugString('ScanResult Format:'+FScanFormat+' Content:'+FScanContent);

  //在这里不能直接访问UI,启动定时器,在定时器里面进行操作
  tmrScanResult.Enabled:=True;

end;

procedure TfrmMain.tmrScanResultTimer(Sender: TObject);
//var
//  ABindCode:String;
//  AInterfaceParameters:TInterfaceParameters;
begin
  //处理二维码扫描结果
  tmrScanResult.Enabled:=False;

  if FScanFormat='QR_CODE' then
  begin

//      //二维码
//      if Pos('bind_code=',FScanContent)>0 then
//      begin
//          //是挂勾码
//          //打开挂勾码页面,自动填入挂勾码
//          AInterfaceParameters:=ParseUrlQueryParameters(FScanContent);
//          try
//              ABindCode:=AInterfaceParameters.ItemValueByName('bind_code');
//              if ABindCode<>'' then
//              begin
//
//                  if CurrentFrame<>GlobalApplyIntroducerFrame then
//                  begin
//
//                      //隐藏
//                      HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//
//                      //显示申请介绍人页面
//                      ShowFrame(TFrame(GlobalApplyIntroducerFrame),TFrameApplyIntroducer,frmMain,nil,nil,nil,Application);
//                      GlobalApplyIntroducerFrame.FrameHistroy:=CurrentFrameHistroy;
//                      GlobalApplyIntroducerFrame.Clear;
//                      GlobalApplyIntroducerFrame.LoadApplyIntroducerType(aitAfterRegister);
//
//                  end;
//                  GlobalApplyIntroducerFrame.edtBindCode.Text:=ABindCode;
//
//              end
//              else
//              begin
//                //挂勾码为空
//
//              end;
//          finally
//            FreeAndNil(AInterfaceParameters);
//          end;
//
//      end
//      else
//      begin
          //是其他内容
          if (Pos('http://',LowerCase(FScanContent))=1)
            or (Pos('https://',LowerCase(FScanContent))=1) then
          begin
            //是网页
            //网页链接
            HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

            //显示网页界面
            ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser,frmMain,nil,nil,nil,Application);
//            GlobalWebBrowserFrame.FrameHistroy:=CurrentFrameHistroy;
            GlobalWebBrowserFrame.LoadUrl(FScanContent);

          end
          else
          begin

          end;
//      end;


  end
  else
  begin
      //其他码

  end;

//  ShowMessage('扫描结果:'+FScanContent);
end;

procedure TfrmMain.HandleActivityMessage(const Sender: TObject;const M: TMessage);
begin
  {$IFDEF ANDROID}
  if M is TMessageResultNotification then
  begin
    OnActivityResult(TMessageResultNotification(M).RequestCode,
                      TMessageResultNotification(M).ResultCode,
                      TMessageResultNotification(M).Value);
  end;
  {$ENDIF}
end;


{$IFDEF ANDROID}
function TfrmMain.OnActivityResult(RequestCode,ResultCode: Integer; Data: JIntent): Boolean;
begin
  Result := False;

  TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, FMessageSubscriptionID);
  FMessageSubscriptionID := 0;

  if RequestCode = ScanRequestCode then
  begin
    if ResultCode = TJActivity.JavaClass.RESULT_OK then
    begin
      if Assigned(Data) then
      begin

          FScanFormat:=JStringToString(Data.getStringExtra(StringToJString('SCAN_RESULT_FORMAT')));
          FScanContent:=JStringToString(Data.getStringExtra(StringToJString('SCAN_RESULT')));

          uBaseLog.OutputDebugString('ScanResult Format:'+FScanFormat+' Content:'+FScanContent);

          //在这里不能直接访问UI,启动定时器,在定时器里面进行操作
          CallInUIThread(
          procedure
          begin
            tmrScanResult.Enabled:=True;
          end);

      end;
    end;
//    else if ResultCode = TJActivity.JavaClass.RESULT_CANCELED then
//    begin
//      //取消扫描
//    end;
    Result := True;
  end;
end;
{$ENDIF}


end.

