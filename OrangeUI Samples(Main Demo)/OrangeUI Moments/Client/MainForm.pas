//convert pas to utf8 by ¥

unit MainForm;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uBaseLog,
  uFuncCommon,
  uUIFunction,
  uManager,
  uComponentType,
  ClientModuleUnit1,
  uGPSLocation,
  uBaseHttpControl,
  uGPSUtils,
  uGraphicCommon,

  FMX.Platform,
  HintFrame,

  {$IFDEF ANDROID}
  Androidapi.JNI.Net,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
  Androidapi.JNI.App,
  FMX.Helpers.Android,
  Androidapi.JNI.Os,
    {$IF RTLVersion>=33}// 10.3+
    System.Permissions, // 动态权限单元
    {$ENDIF}
  {$ENDIF}

  MessageBoxFrame,
  PopupMenuFrame,
  ViewPictureListFrame,



  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyImage, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, IdBaseComponent, IdComponent, IdIPWatch,
  System.Notification, FMX.Objects, FMX.Gestures, System.Sensors,
  System.Sensors.Components, uBaseSkinControl, uSkinPanelType;



type
  TfrmMain = class(TForm)
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
    procedure FormDestroy(Sender: TObject);
    { Private declarations }
  private
    FGestureManager:TGestureManager;
  public
//    FGPSLocation:TGPSLocation;

    //登录
    procedure Login;
    //退出登录
    procedure Logout;

    { Public declarations }
  end;




var
  frmMain: TfrmMain;

implementation


uses
  MainFrame,
  ClipHeadFrame,
  LoginFrame;


{$R *.fmx}


procedure TfrmMain.FormCreate(Sender: TObject);
begin



  {$IFNDEF MSWINDOWS}
  FGestureManager:=TGestureManager.Create(Self);
  Self.Touch.GestureManager:=FGestureManager;
  {$ENDIF}


  {$IFDEF ANDROID}
  //Android 4.4.4及以上版本
  if (TOSVersion.Major>4)
    or (TOSVersion.Major=4)
    and (TOSVersion.Minor>=4)
    and (TOSVersion.Build>=4) then
  begin
    //Android下用了透明任务栏的模式
    //顶部任务栏用Panel增高的方式
    uComponentType.IsAndroidIntelCPU:=True;
  end;
  {$ENDIF}




//  //在Windows平台下的模拟虚拟键盘控件
//  SimulateWindowsVirtualKeyboardHeight:=160;
//  IsSimulateVirtualKeyboardOnWindows:=True;
//  GlobalAutoProcessVirtualKeyboardControlClass:=TSkinFMXPanel;
//  GlobalAutoProcessVirtualKeyboardControl:=pnlVirtualKeyBoard;
//  GlobalAutoProcessVirtualKeyboardControl.Visible:=False;
//
//
//
//  {$IFNDEF MSWINDOWS}
//  pnlVirtualKeyBoard.SelfOwnMaterialToDefault.IsTransparent:=True;
//  pnlVirtualKeyBoard.Caption:='';
//  {$ENDIF}
//



//  //修复Android下的虚拟键盘隐藏和显示
//  GetGlobalVirtualKeyboardFixer.StartSync(Self);

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
//  FreeAndNil(FGPSLocation);
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
  if (Key = vkHardwareBack)
    //Windows下Escape键模拟返回键
    or (Key = vkEscape) then
  begin
    //返回
    if (CurrentFrameHistroy.ToFrame<>nil)
        //如果当前是登陆页面,不返回上一页
       and (CurrentFrameHistroy.ToFrame<>GlobalLoginFrame)
        //如果当前是主页面,不返回上一页
       and (CurrentFrameHistroy.ToFrame<>GlobalMainFrame) then
    begin
      if CanReturnFrame(CurrentFrameHistroy) then
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

  uGraphicCommon.SkinThemeColor:=$FF438DF5;


  //等ClientModule创建才行
  //写个您自己的服务器地址
//  {$IFDEF LOCALNETWORK}
//  ClientModule.DSRestConnection1.Host:='192.168.1.122';
//    '192.168.1.100';
//  ImageHttpServerUrl:='http://'+ClientModule.DSRestConnection1.Host+':7041';
//  {$ELSE}


  ClientModule.DSRestConnection1.Host:='www.orangeui.cn';
  ImageHttpServerUrl:='http://www.orangeui.cn:7041';


//  ClientModule.DSRestConnection1.Host:='192.168.1.112';

//  //本地测试
//  ClientModule.DSRestConnection1.Host:='127.0.0.1';
//  ImageHttpServerUrl:='http://127.0.0.1:7041';


//  {$ENDIF}




  //加载上次登录的用户名和密码
  GlobalManager.Load;


  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;






//  //启动定位
//  FGPSLocation:=TGPSLocation.Create();
//  FGPSLocation.GPSType:=uGPSLocation.gtGCJ02;



  //申请权限
  {$IFDEF ANDROID}
    {$IF RTLVersion>=33}// 10.3+
        PermissionsService.RequestPermissions
            ([JStringToString(TJManifest_permission.JavaClass.ACCESS_COARSE_LOCATION),
              JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE),
              JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE),
              JStringToString(TJManifest_permission.JavaClass.CAMERA)
              ],
          procedure(const APermissions: {$IF CompilerVersion >= 35.0}TClassicStringDynArray{$ELSE}TArray<string>{$IFEND};
            const AGrantResults: {$IF CompilerVersion >= 35.0}TClassicPermissionStatusDynArray{$ELSE}TArray<TPermissionStatus>{$IFEND})
          begin
//            FGPSLocation.StartLocation;
          end);
    {$ELSE}
//      FGPSLocation.StartLocation;
    {$ENDIF}
  {$ELSE}
//      FGPSLocation.StartLocation;
  {$ENDIF}
//  FGPSLocation.StartLocation;



//
//  if GlobalGPSLocation=nil then
//  begin
//    //启动定位
//    GlobalGPSLocation:=TGPSLocation.Create(nil);
//    GlobalGPSLocation.GPSType:=gtGCJ02;
//
//    GlobalGPSLocation.Clear;
//
////    GlobalGPSLocation.OnLocationChange:=Self.DoGPSLocation_LocationChange;
////    GlobalGPSLocation.OnLocationTimeout:=Self.DoGPSLocation_LocationTimeout;
////    GlobalGPSLocation.OnStartError:=Self.DoGPSLocation_StartError;
////
////
////    GlobalGPSLocation.OnAddrChange:=Self.DoGPSLocation_AddrChange;
////    GlobalGPSLocation.OnGeocodeAddrError:=Self.DoGPSLocation_GeocodeAddrError;
////    GlobalGPSLocation.OnGeocodeAddrTimeout:=Self.DoGPSLocation_GeocodeAddrTimeout;
//
//    GlobalGPSLocation.LocationChanged:=False;
//
//
//  end;
//  if not GlobalGPSLocation.StartLocation then
//  begin
//    ShowHintFrame(Self,'启动定位失败!');
//  end;
//


end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.Login;
begin
  //显示首页
  GlobalMainFrame.pcMain.Prop.ActivePage:=GlobalMainFrame.tsSpirit;
  GlobalMainFrame.pcMainChange(GlobalMainFrame.pcMain);


end;

procedure TfrmMain.Logout;
begin

end;



end.

