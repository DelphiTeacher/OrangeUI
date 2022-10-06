//convert pas to utf8 by ¥

unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  Math,

  uSkinItems,
  uDownloadPictureManager,
  uFireMonkeyDrawCanvas,
  uVersion,
  uLang,
  uComponentType,
  uBaseLog,
  uMobileUtils,
  uGraphicCommon,
  uUIFunction,
  uFrameContext,
//  FMX.Effects,
//  uSkinListViewType,
  uSkinImageListViewerType,



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


//  uSkinImageListViewerType,

  uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinControlGestureManager,
  uSkinControlPanDragGestureManager, uSkinFireMonkeyImage, FMX.StdCtrls,
  FMX.ExtCtrls,
  FMX.Objects, uSkinFireMonkeyPageControl,
  FMX.Controls.Presentation, uSkinFireMonkeyButton,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList, FMX.DateTimeCtrls,
  uSkinFireMonkeyTimeEdit, uSkinFireMonkeyDateEdit, uBaseSkinControl,
  uSkinPanelType, FMX.Edit, uSkinFireMonkeyEdit, uDrawPicture, uSkinImageList,
  uSkinImageType, FMX.ComboEdit, FMX.Effects;




type
  TfrmMain = class(TForm)
    pnlLeftPanel: TSkinFMXPanel;
    Timer1: TTimer;
    imgHomeIcons: TSkinImageList;
    imgShopHomeList: TSkinImageList;
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure gesturemanagerLeftMainMenuPositionChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormTouch(Sender: TObject; const Touches: TTouches;
      const Action: TTouchAction);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    { Private declarations }
  protected
//      procedure DoGlobalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
//      procedure DoGlobalMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
//      procedure DoGlobalMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
  public
    { Public declarations }
  end;




var
  frmMain: TfrmMain;



implementation

{$R *.fmx}

uses
  MainFrame,
//  ItemGridFrame,
  RoundImageFrame,
  ScrollBoxFrame,
  ChartFrame,
  ImageListViewerFrame,
//  ItemGridFrame_Simple,
//  ListViewFrame_UseItemDesignerPanel,
  ListBoxFrame_UseAutoDownloadIcon,
//  ListViewFrame_ItemDesignTimeColor,
//  VirtualGridFrame,
  CustomListFrame
//  PanelFrame,
//  HideVKboardFrame,
//  PullLoadPanelFrame,
//  ControlGestureManagerFrame,
//  ListViewFrame_TestComplexLayout,
//  ListViewFrame_TestWaterfall
  ;

//procedure TfrmMain.DoGlobalMouseDown(Sender: TObject; Button: TMouseButton;
//  Shift: TShiftState; X, Y: Single);
//begin
//  uBaseLog.OutputDebugString('Global MouseDown '+FloatToStr(X-Left-4)+','+FloatToStr(Y-Top-30));
//  gesturemanagerLeftMainMenu.MouseDown(Button,Shift,X-Left-4,Y-Top-30);
//end;
//
//procedure TfrmMain.DoGlobalMouseMove(Sender: TObject; Shift: TShiftState; X,
//  Y: Single);
//begin
//  uBaseLog.OutputDebugString('Global MouseMove '+FloatToStr(X-Left-4)+','+FloatToStr(Y-Top-30));
//  gesturemanagerLeftMainMenu.MouseMove(Shift,X-Left-4,Y-Top-30);
//end;
//
//procedure TfrmMain.DoGlobalMouseUp(Sender: TObject; Button: TMouseButton;
//  Shift: TShiftState; X, Y: Single);
//begin
//  uBaseLog.OutputDebugString('Global MouseUp '+FloatToStr(X-Left-5)+','+FloatToStr(Y-Top-30));
//  gesturemanagerLeftMainMenu.MouseUp(Button,Shift,X-Left-5,Y-Top-30);
//end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  uBaseLog.GetGlobalLog.IsWriteLog:=False;


  //改成根据区域语言来自动切换
  //swich to english
  //切换到英文版
  LangKind:=TLangKind.lkEN;



  //英文版的处理-对话框
  RecordLangIndex(GlobalLang,'确定','en','OK');
  RecordLangIndex(GlobalLang,'取消','en','Cancel');
  RecordLangIndex(GlobalLang,'警告','en','Cancel');
  RecordLangIndex(GlobalLang,'报错','en','Warning');
  RecordLangIndex(GlobalLang,'提示','en','Information');
  RecordLangIndex(GlobalLang,'确认','en','Confirmation');





//  uComponentType.GlobalMouseDownEvent:=Self.DoGlobalMouseDown;
//  uComponentType.GlobalMouseUpEvent:=Self.DoGlobalMouseUp;
//  uComponentType.GlobalMouseMoveEvent:=Self.DoGlobalMouseMove;

end;

procedure TfrmMain.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  LObj: IControl;
  LImage: TSkinImageListViewer;
  LImageCenter: TPointF;
begin
//  FMX.Types.Log.d('TfrmMain.FormGesture Begin');

  if EventInfo.GestureID = igiZoom then
  begin
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
//    FMX.Types.Log.d('TfrmMain.FormGesture igiZoom LObj:'+LObj.GetObject.ClassName);
    if LObj.GetObject is TSkinImageListViewer then
    begin
//      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
//        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
//      begin
//        { zoom the image }
//        LImage := TImage(LObj.GetObject);
//        LImageCenter := LImage.Position.Point + PointF(LImage.Width / 2,
//          LImage.Height / 2);
//        LImage.Width := Max(LImage.Width + (EventInfo.Distance - FLastDistance), 10);
//        LImage.Height := Max(LImage.Height + (EventInfo.Distance - FLastDistance), 10);
//        LImage.Position.X := LImageCenter.X - LImage.Width / 2;
//        LImage.Position.Y := LImageCenter.Y - LImage.Height / 2;
//      end;
//      FLastDistance := EventInfo.Distance;

        //缩放
        TSkinImageListViewer(LObj.GetObject).Prop.Gesture(EventInfo,Handled);

    end;
  end;


  if EventInfo.GestureID = igiDoubleTap then
  begin
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
//    FMX.Types.Log.d('TfrmMain.FormGesture igiDoubleTap LObj:'+LObj.GetObject.ClassName);
    if LObj.GetObject is TSkinImageListViewer then
    begin
//      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
//        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
//      begin
//        { zoom the image }
//        LImage := TImage(LObj.GetObject);
//        LImageCenter := LImage.Position.Point + PointF(LImage.Width / 2,
//          LImage.Height / 2);
//        LImage.Width := Max(LImage.Width + (EventInfo.Distance - FLastDistance), 10);
//        LImage.Height := Max(LImage.Height + (EventInfo.Distance - FLastDistance), 10);
//        LImage.Position.X := LImageCenter.X - LImage.Width / 2;
//        LImage.Position.Y := LImageCenter.Y - LImage.Height / 2;
//      end;
//      FLastDistance := EventInfo.Distance;

        //恢复初始
        TSkinImageListViewer(LObj.GetObject).Prop.CancelZoom;

    end;
  end;

//  FMX.Types.Log.d('TfrmMain.FormGesture End');

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
       and (CurrentFrameHistroy.ToFrame<>GlobalMainFrame)
       then
    begin
      if (CanReturnFrame(CurrentFrameHistroy)=TFrameReturnActionType.fratDefault) then
      begin
        HideFrame;//(CurrentFrameHistroy.ToFrame,hfcttBeforeReturnFrame);
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
var
  AFrame:TFrame;
begin



//  //在Windows平台下的模拟虚拟键盘控件
//  SimulateWindowsVirtualKeyboardHeight:=160;
//  IsSimulateVirtualKeyboardOnWindows:=True;
//  GlobalAutoProcessVirtualKeyboardControlClass:=TSkinFMXPanel;
//  GlobalAutoProcessVirtualKeyboardControl:=pnlVirtualKeyBoard;
//  GlobalAutoProcessVirtualKeyboardControl.Visible:=False;
//
//
//  {$IFNDEF MSWINDOWS}
//  pnlVirtualKeyBoard.SelfOwnMaterialToDefault.IsTransparent:=True;
//  pnlVirtualKeyBoard.Caption:='';
//  {$ENDIF}




//  GetGlobalVirtualKeyboardFixer.StartSync(Self);
//  ShowFrame(TFrame(AFrame),TFrameImageListViewer,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//  Exit;

//  AFrame:=nil;
//  ShowFrame(TFrame(AFrame),TFrameImageListViewer,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//  Exit;

  if DirectoryExists('C:\MyFiles') then
  begin
//      SkinFMXImage3.Prop.Picture.LoadFromFile('C:\Users\ggggcexx\Downloads\aa.gif');
//      SkinFMXImage3.Prop.Animated:=False;
//      SkinFMXImage3.Prop.Animated:=True;
//      Exit;

      //如果是我的电脑,测试用
      AFrame:=nil;
//  ShowFrame(TFrame(AFrame),TFrameImageListViewer,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameChart,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
////      ShowFrame(TFrame(AFrame),TFrameCustomList,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameItemGrid,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameRoundImage,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameItemGrid_Simple,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameListView_UseItemDesignerPanel,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameListBox_UseAutoDownloadIcon,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameScrollBox,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      ShowFrame(TFrame(AFrame),TFrameListView_ItemDesignTimeColor,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//    ////  ShowFrame(TFrame(AFrame),TFrameVirtualGrid,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//      Exit;

      ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
  end
  else
  begin
    ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
  end;

//  AFrame:=nil;
//  ShowFrame(TFrame(AFrame),TFrameListView_TestComplexLayout,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//  ShowFrame(TFrame(AFrame),TFrameControlGestureManager,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);
//  ShowFrame(TFrame(AFrame),TFramePullLoadPanel,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);




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



end;

procedure TfrmMain.FormTouch(Sender: TObject; const Touches: TTouches;
  const Action: TTouchAction);
begin

  //引用uSkinImageListViewerType单元
  //可能是放大缩小的手势
  if (Length(Touches)=2) then
  begin
    gFormTouch1:=Touches[0].Location;
    gFormTouch2:=Touches[1].Location;
  end;
  gFormTouchCount:=Length(Touches);
  ProcessFormTouch(Sender,Touches,Action);

end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.gesturemanagerLeftMainMenuPositionChange(Sender: TObject);
begin

//  uBaseLog.OutputDebugString('位置更改'+FloatToStr(Self.gesturemanagerLeftMainMenu.Position));
//  pnlLeftPanel.BringToFront;
//  Self.pnlLeftPanel.Left:=
//                  //    gesturemanagerLeftMainMenu.Max
//                      -gesturemanagerLeftMainMenu.Position;

end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
//  //释放下载的但短时间内不再绘制的图片,避免内存占用过大
//  GetGlobalDownloadPictureManager.FreeNoUsePicture(5);
end;

end.

