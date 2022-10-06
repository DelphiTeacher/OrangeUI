//convert pas to utf8 by ¥

unit uUIFunction;

interface

//{$DEFINE FMX}

{$I FrameWork.inc}



uses
  SysUtils,
  Types,
  Classes,
  Variants,
  SyncObjs,
  StrUtils,
  Math,

  uSkinMaterial,

  {$IFDEF FMX}
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.VirtualKeyboard,

  UITypes,
  System.Messaging,
//  FMX.WebBrowser,
  FMX.Platform,
  FMX.StdCtrls,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollBox,
  {$ENDIF}


  {$IFDEF VCL}
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls,
  {$ENDIF VCL}




  {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  FMX.Platform.Android,
//  System.Messaging,
    {$IF RTLVersion>=33}// 10.3+
    FMX.Platform.UI.Android,
    {$IFEND}

  {$ENDIF}

  {$IFDEF IOS}
  FMX.Helpers.iOS,
  {$ENDIF}

  uLang,
  uVersion,
  uBaseLog,
  uBaseList,
  uComponentType,
  uFrameContext,
  uFuncCommon,
  uGraphicCommon,
  uDrawCanvas,
  uSkinBufferBitmap,
  uSkinAnimator,
  uSkinPanelType,
  uDrawTextParam,
  uSkinPageControlType,

  uSkinControlGestureManager,
  uSkinScrollControlType;




const
  IID_IFrameVirtualKeyboardEvent:TGUID='{3EA28E86-BEC2-432A-A744-C5210B0D3B85}';
  IID_IFrameVirtualKeyboardAutoProcessEvent:TGUID='{D25150F4-EB4C-4097-93FE-51BFD19FF29D}';
  IID_IFrameHistroyCanReturnEvent:TGUID='{F7691EDC-4E9D-4295-85C5-950EF297C55D}';

type
  TControlClass=class of TControl;

  //页面的使用类型
  TFrameUseType=(futManage,     //用于管理
                  futSelectList,//用于列表选择
                  futViewList   //用于查看列表
                  );


  //Frame键盘显示/隐藏接口,需要手动处理遮挡Edit
  IFrameVirtualKeyboardEvent=interface
    ['{3EA28E86-BEC2-432A-A744-C5210B0D3B85}']
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
  end;



  //Frame自动处理虚拟键盘遮挡Edit的事件
  IFrameVirtualKeyboardAutoProcessEvent=interface
    ['{D25150F4-EB4C-4097-93FE-51BFD19FF29D}']
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    //虚拟键盘放在哪里
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  end;




  IFrameHistroyCanReturnEvent=interface
    ['{F7691EDC-4E9D-4295-85C5-950EF297C55D}']
    //是否可以返回上一个Frame
    function CanReturn:TFrameReturnActionType;
  end;




  //别名,因为原来的Histroy拼错了
  TFrameHistroy=TFrameHistory;



  //Frame切换效果类型
  TUseFrameSwitchEffectType=
                            (
                             //没有效果
                             ufsefNone,
                             //普通效果(左右滑动)
                             ufsefDefault,
                             //普通效果(垂直滑动)
                             ufsefMoveVert,
                             //透明度
                             ufsefAlpha,
                             //水平带透明度
                             ufsefDefaultAndAlpha,
                             //垂直带透明度
                             ufsefMoveVertAndAlpha
                            );




  //隐藏Frame的时候调用时机的类型
  THideFrameCalledTimeType=
                            (
                            hfcttNone,//0
                            hfcttAuto,//1
                            hfcttBeforeShowFrame,//2
                            hfcttBeforeReturnFrame//3
                            );


  {$REGION 'TVirtualKeyboardFixer 虚拟键盘修复'}
  {$IFDEF FMX}
  //虚拟键盘修复
  TVirtualKeyboardFixer=class
  private
    //用于调用窗体的虚拟键盘事件来通知Frames
//    FMainForm:TForm;

    //Android平台下虚拟键盘隐藏时的高度
    FVirtualKeyboardHeightWhenHideInAndroid:Integer;

  private
    {$IFDEF ANDROID}
    //Android下面需要,IOS下面不需要,因为IOS下面比较准确
    //上次虚拟键盘的状态
    FLastVirtualKeyboardVisible:Boolean;
    //检测虚拟键盘是否隐藏，是否显示
    tmrSyncVirtualKeyboardVisibleInAndroid: TTimer;
    procedure OnSyncVirtualKeyboardVisibleInAndroidTimer(Sender:TObject);
    {$ENDIF}
  private
    //模拟键盘的点击事件
    procedure DoSimulateWindowsVirtualKeyBoardClick(Sender: TObject);
  private
    //延迟调用虚拟键盘隐藏事件的参数
    FCallHiddenSender:TObject;
//    FCallHiddenParent:TFmxObject;
    FCallHiddenBounds:TRect;


    //检测虚拟键盘是否是真的隐藏了
    tmrCheckVirtualKeyboardRealHidden: TTimer;

    procedure DoCheckVirtualKeyboardRealHiddenTimer(Sender:TObject);
    procedure StartCheckRealHidden(Sender: TObject;
//                                    AParent:TFmxObject;
                                    const ABounds: TRect);
  private
    //处理键盘弹起,
    //设置ScrollControl的Position,
    //把FocusedControl移上来
    FVKBoardShow_FocusedControl:TControl;
    FVKBoardShow_Height:Double;

    tmrProcessVKboardShow: TTimer;

    procedure DoProcessVKboardShowTimer(Sender:TObject);
    procedure ProcessVKShowFocusedControl(AFocusedControl:TControl;AVKBoardHeight:Double);

  private
    //虚拟键盘状态消息事件
    FVKStateChangeMessageId: Integer;
    procedure VirtualKeyboardChangeHandler(const Sender: TObject; const Msg: System.Messaging.TMessage); virtual;
  public
    VirtualKeyboardQuickShowedAfterHidden:Boolean;
    //虚拟键盘的最小高度(在安卓下会有这个问题)
    property VirtualKeyboardHideHeight:Integer read FVirtualKeyboardHeightWhenHideInAndroid;
  public
    constructor Create;
    destructor Destroy;override;
  public
    //每200ms检测Android平台虚拟键盘是否隐藏或显示,
    //因为虚拟键盘事件在Android平台不太准确
    procedure StartSync;//(AMainForm:TForm);
  end;
  {$ENDIF}
  {$ENDREGION 'TVirtualKeyboardFixer 虚拟键盘修复'}


{$IFDEF FMX}
var
  GlobalVirtualKeyboardFixer:TVirtualKeyboardFixer;

var
  //虚拟键盘控件
  GlobalAutoProcessVirtualKeyboardControl:TBaseSkinPanel;
  //不再使用,虚拟键盘控件类,如果GlobalAutoProcessVirtualKeyboardControl为空,则会自动创建
  GlobalAutoProcessVirtualKeyboardControlClass:TControlClass;
{$ENDIF}


//设置Frame唯一的名字
procedure SetFrameName(AFrame:TComponent);

//显示一个页面
procedure ShowFrame(
                    //目标页面引用变量,要显示哪个页面,跳转到哪个页面
                    var ToFrame:TFrame;
                    //目标页面类
                    const ToFrameClass:TFrameClass;
                    //目标页面的父控件
                    const ToFrameParent:TObject;

                    //其他(不使用,为nil即可)
                    const NoUse:TObject;
                    //源页面(不使用,为nil即可)
                    const NoUse1:TFrame;

                    //返回时调用的事件
                    const OnReturnFrame:TReturnFromFrameEvent;
                    //目标页面创建拥有者
                    const Owner:TComponent=nil;
                    //是否记录到历史列表
                    const IsLogInHistory:Boolean=True;
                    //是否使用全局的背景色
                    const IsUseGlobalPaintSetting:Boolean=True;
                    //是否使用页面切换效果
                    const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType=ufsefDefault;
                    //是否使用弹出风格,在Pad中使用的时候
                    const IsUsePopupStyle:Boolean=False;
                    //弹出时的宽度
                    const APFramePopupStyle:PFramePopupStyle=nil
                    );
                    {$IF CompilerVersion > 30.0}overload;{$IFEND}

{$IF CompilerVersion>30.0}
procedure ShowFrame(
                    //目标页面引用变量
                    var ToFrame:TFrame;
                    //目标页面类
                    const ToFrameClass:TFrameClass;
                    const OnReturnFrame:TReturnFromFrameEvent=nil);overload;
{$IFEND}




//隐藏一个页面
procedure HideFrame(
                    //要隐藏的页面,如果为nil,表示隐藏CurrentFrame
                    AFrame:TFrame=nil;
                    //调用的时机,是显示之前隐藏,还是返回之前隐藏
                    const AHideFrameCalledTimeType:THideFrameCalledTimeType=hfcttAuto;
                    //是否使用页面切换效果
                    const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType=ufsefDefault
                    );
procedure HideFrameBeforeShow(
                        //要隐藏的页面,如果为nil,表示隐藏CurrentFrame
                        AFrame:TFrame=nil;
                        //是否使用页面切换效果
                        const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType=ufsefDefault
                        );
procedure HideFrameBeforeReturn(
                        //要隐藏的页面,如果为nil,表示隐藏CurrentFrame
                        AFrame:TFrame=nil;
                        //是否使用页面切换效果
                        const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType=ufsefDefault
                        );


//返回上一个页面
procedure ReturnFrame(
                      //当前的页面历史
                      AFrameHistroy:TFrameHistroy;
                      //返回第几层
                      const AReturnStep:Integer=1;
                      //是否需要释放AFrame
                      const AIsNeedFree:Boolean=False
                      );overload;
//返回上一个页面
procedure ReturnFrame(
                      //当前Frame,为空表示自动返回上一页
                      AFrame:TFrame=nil;
                      //返回第几层
                      const AReturnStep:Integer=1;
                      //是否需要释放AFrame
                      const AIsNeedFree:Boolean=False
                      );overload;
//判断是否可以返回上一个页面
//0表示不能返回，直接到后台
//1表示可以返回
//2表示不能返回，不到后台
function CanReturnFramePro(const AFrameHistroy:TFrameHistroy):TFrameReturnActionType;
function CanReturnFrame(const AFrameHistroy:TFrameHistroy):TFrameReturnActionType;

//当前页的上下文
function CurrentFrameHistroy:TFrameHistroy;
//当前显示的Frame
function CurrentFrame:TFrame;

function GetFrameHistory(
                        //当前Frame
                        AFrame:TFrame
                        ):PFrameHistory;

procedure ClearOnReturnFrameEvent(AFrame:TFrame);



{$IFDEF FMX}
//获取Android平台虚拟键盘的高度,用于判断虚拟键盘是隐藏还是显示
function GetCurrentVirtualKeyboardRectInAndroid:TRect;

//键盘隐藏显示修复器
function GetGlobalVirtualKeyboardFixer:TVirtualKeyboardFixer;

//在窗体的键盘显示事件中,通知Frame虚拟键盘显示
//procedure CallSubFrameVirtualKeyboardShown(Sender: TObject;Parent:TFmxObject;KeyboardVisible: Boolean;const Bounds: TRect;AIsFirst:Boolean=True);
//在窗体的键盘隐藏事件中,通知Frame检测键盘有没有隐藏
//procedure CallSubFrameVirtualKeyboardHidden(Sender: TObject;Parent:TFmxObject;KeyboardVisible: Boolean;const Bounds: TRect);

procedure RealCallSubFrameVirtualKeyboardHidden_InTimer(Sender: TObject;
                                                        Parent:TChildControl;
                                                        KeyboardVisible: Boolean;
                                                        const Bounds: TRect);
//处理虚拟键盘弹起(需要独立出来,可以给别的地方调用)
function ProcessVirtualKeyboardShow(
            AForm:TForm;
            const AKeyboardBounds_Height: Double;
            AFocusedControl:TControl;
            AVirtualKeyboardPanel:TControl;
            AKeyboardHeightOffset:Double=0;
            AVirtualKeyboardHeightAdjustHeight:Double=0
            ):Boolean;
{$ENDIF FMX}




//获取子控件相关的滚动控件
function GetReleatedScrollControl(AChild:TChildControl):TSkinScrollControl;
//计算合适的高度,
//当不足一行的高度时,可以补足一行
function GetSuitContentHeight(AControlWidth:Double;
                              //内容
                              AContent:String;
                              //字体大小
                              AFontSize:Integer;
                              //最小值
                              AOneLineControlHeight:Double
                              ):Double;






//获取控件相对于父控件的高度
function GetReleatedTop(AChild:TControl;AParent:TChildControl):TControlSize;
//自动计算ScrollBoxContent的合适内容高度
function GetSuitScrollContentHeight(AScrollBoxContent:TParentControl;
                                    const ABottomSpace:TControlSize=20):TControlSize;
//自动计算Content的合适内容高度
function GetSuitControlContentHeight(AControl:TParentControl;
                                    const ABottomSpace:TControlSize=20):TControlSize;
//自动设置ScrollBoxContent的高度
procedure SetSuitScrollContentHeight(AScrollBoxContent:TParentControl;
                                    const ABottomSpace:TControlSize=20);




{$IFDEF FMX}
//隐藏虚拟键盘
procedure HideVirtualKeyboard;
//显示虚拟键盘
procedure ShowVirtualKeyboard(const AControl: TFmxObject);
//虚拟键盘是否显示
function IsVirtualKeyboardVisible:Boolean;
//procedure SetVirtualKeyboardHideButtonVisible(const Value: Boolean);
procedure SetVirtualKeyboardToolBarEnabled(const Value: Boolean);
{$ENDIF}



//procedure DoWebBrowserRealign;


//记录子控件的翻译索引
procedure RecordSubControlsLang(
                            //父控件,Frame或Form
                            AParent:TChildControl;
                            //当前的语言
                            ACurLang:String='cn');
//翻译子控件
procedure TranslateSubControlsLang(
                            //父控件,Frame或Form
                            AParent:TChildControl);


//主题色
function SkinThemeColor:TDelphiColor;
//主题色2
function SkinThemeColor1:TDelphiColor;


procedure AlignControls(ATopControl:TControl;
                        AControl1:TControl=nil;
                        AControl2:TControl=nil;
                        AControl3:TControl=nil;
                        AControl4:TControl=nil;
                        AControl5:TControl=nil;
                        AControl6:TControl=nil;
                        AControl7:TControl=nil;
                        AControl8:TControl=nil;
                        AControl9:TControl=nil;
                        AControl10:TControl=nil;
                        AControl11:TControl=nil;
                        AControl12:TControl=nil;
                        AControl13:TControl=nil;
                        AControl14:TControl=nil
                        );
//procedure AlignControlArray(AControlArray:ATControl;

function IsRepeatClickReturnButton(AFrame:TFrame):Boolean;


{$IFDEF FMX}
var
  //当前应用程序的状态
  GlobalApplicationState:TApplicationEvent;
{$ENDIF}



implementation


function IsRepeatClickReturnButton(AFrame:TFrame):Boolean;
begin
  Result:=uFrameContext.IsRepeatClickReturnButton(AFrame);
end;






//主题色
function SkinThemeColor:TDelphiColor;
begin
  Result:=uGraphicCommon.SkinThemeColor;
end;

//主题色2
function SkinThemeColor1:TDelphiColor;
begin
  Result:=uGraphicCommon.SkinThemeColor1;
end;

procedure RecordSubControlsLang(
                            //父控件,Frame或Form
                            AParent:TChildControl;
                            //当前的语言
                            ACurLang:String);
begin
  //记录索引
  uLang.DoRecordSubControlsLangIndex(AParent,
                            GlobalLang,
                            ACurLang,
                            ''
                            );
end;

procedure TranslateSubControlsLang(
                            //父控件,Frame或Form
                            AParent:TChildControl);
begin
  uLang.DoTranslateSubControlsLang(AParent,
                            GlobalLang,
                            GlobalCurLang);
end;



//procedure DoWebBrowserRealign;
//{$IFDEF FMX}
//var
//  BrowserManager : IFMXWBService;
//{$ENDIF}
//begin
//{$IFDEF FMX}
//  if TPlatformServices.Current.SupportsPlatformService(IFMXWBService, BrowserManager) then
//    BrowserManager.RealignBrowsers;
//{$ENDIF}
//end;

procedure ClearOnReturnFrameEvent(AFrame:TFrame);
begin
  //什么也不做
  //清空返回事件,也就是返回的时候不调用它
  if GetFrameHistory(AFrame)<>nil then
  begin
    GetFrameHistory(AFrame).OnReturnFrame:=nil;
  end;
end;

function GetFrameHistory(
                        //当前Frame
                        AFrame:TFrame
                        ):PFrameHistory;
begin
  Result:=uFrameContext.GetFrameHistory(AFrame);
end;

procedure SetFrameName(AFrame:TComponent);
begin
  uFrameContext.SetFrameName(AFrame);
end;

function CurrentFrame:TFrame;
begin
  Result:=uFrameContext.CurrentFrame;
end;

function CurrentFrameHistroy:TFrameHistroy;
begin
  Result:=uFrameContext.CurrentFrameHistory;
end;

function CanReturnFramePro(const AFrameHistroy:TFrameHistroy):TFrameReturnActionType;
var
  AFrameHistoryCanReturnEvent:IFrameHistroyCanReturnEvent;
begin
  Result:=TFrameReturnActionType.fratDefault;
  if (AFrameHistroy.ToFrame<>nil)
    and AFrameHistroy.ToFrame.GetInterface(IID_IFrameHistroyCanReturnEvent,AFrameHistoryCanReturnEvent) then
  begin
    Result:=AFrameHistoryCanReturnEvent.CanReturn;
  end
  else
  begin
    Result:=uFrameContext.DoCanReturnFrame(AFrameHistroy);
  end;
end;

function CanReturnFrame(const AFrameHistroy:TFrameHistroy):TFrameReturnActionType;
begin
  Result:=uFrameContext.DoCanReturnFrame(AFrameHistroy);
end;

procedure ReturnFrame(
                      //当前Frame
                      AFrameHistroy:TFrameHistroy;
                      //返回前几页
                      const AReturnStep:Integer=1;
                      //是否需要释放
                      const AIsNeedFree:Boolean=False
                      );
begin

  {$IFDEF FMX}
  //隐藏虚拟键盘
  HideVirtualKeyboard;
  {$ENDIF}


  //不再使用FrameHistroy
//  uFrameContext.DoReturnFrame(AFrameHistroy.ToFrame,AReturnStep,AIsNeedFree);

  uFrameContext.DoReturnFrame(nil,AReturnStep,AIsNeedFree);
end;

procedure ReturnFrame(
                      //当前Frame,为空表示自动返回上一页
                      AFrame:TFrame=nil;
                      //返回前几页
                      const AReturnStep:Integer=1;
                      //是否需要释放
                      const AIsNeedFree:Boolean=False
                      );
begin
  {$IFDEF FMX}
  //隐藏虚拟键盘
  HideVirtualKeyboard;
  {$ENDIF}

  //
  uFrameContext.DoReturnFrame(AFrame,AReturnStep,AIsNeedFree);
end;

{$IF CompilerVersion>30.0}
procedure ShowFrame(
                    //目标页面引用变量
                    var ToFrame:TFrame;
                    //目标页面类
                    const ToFrameClass:TFrameClass;
                    const OnReturnFrame:TReturnFromFrameEvent);overload;
begin
  uFrameContext.DoShowFrame(ToFrame,
                            ToFrameClass,
                            {$IFDEF FMX}Application.MainForm{$ENDIF}{$IFDEF VCL}nil{$ENDIF},
                            nil,//NoUse,
                            nil,//NoUse1,
                            OnReturnFrame,//OnReturnFrame,

                            Application.MainForm//Owner,

                            );
end;
{$IFEND}

procedure ShowFrame(var ToFrame:TFrame;
                    const ToFrameClass:TFrameClass;
                    const ToFrameParent:TObject;
                    const NoUse:TObject;
                    const NoUse1:TFrame;
                    const OnReturnFrame:TReturnFromFrameEvent;
                    const Owner:TComponent;
                    const IsLogInHistory:Boolean;
                    const IsUseGlobalPaintSetting:Boolean;
                    const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType;
                    const IsUsePopupStyle:Boolean;
                    const APFramePopupStyle:PFramePopupStyle
                    );
begin
  uFrameContext.DoShowFrame(ToFrame,
                            ToFrameClass,
                            ToFrameParent,
                            NoUse,
                            NoUse1,
                            OnReturnFrame,
                            Owner,
                            IsLogInHistory,
                            IsUseGlobalPaintSetting,
                            TFrameSwitchType(Ord(AUseFrameSwitchEffectType)),
                            IsUsePopupStyle,
                            APFramePopupStyle
                            );
end;

procedure HideFrame(AFrame:TFrame;
                    const AHideFrameCalledTimeType:THideFrameCalledTimeType;
                    const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType
                    );
begin
  if AFrame=nil then
  begin
    AFrame:=CurrentFrame;
  end;
  uFrameContext.DoHideFrame(AFrame,
                            THideFrameType(Ord(AHideFrameCalledTimeType)),
                            TFrameSwitchType(Ord(AUseFrameSwitchEffectType))
                            );
end;

procedure HideFrameBeforeShow(
                        //要隐藏的页面
                        AFrame:TFrame;
                        //是否使用页面切换效果
                        const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType
                        );
begin
  if AFrame=nil then
  begin
    AFrame:=CurrentFrame;
  end;
  uFrameContext.DoHideFrame(AFrame,
                          THideFrameType(Ord(hfcttBeforeShowFrame)),
                          TFrameSwitchType(Ord(AUseFrameSwitchEffectType))
                          );
end;

procedure HideFrameBeforeReturn(
                        //要隐藏的页面
                        AFrame:TFrame;
                        //是否使用页面切换效果
                        const AUseFrameSwitchEffectType:TUseFrameSwitchEffectType
                        );
begin
  if AFrame=nil then
  begin
    AFrame:=CurrentFrame;
  end;
  uFrameContext.DoHideFrame(AFrame,
                          THideFrameType(Ord(hfcttBeforeReturnFrame)),
                          TFrameSwitchType(Ord(AUseFrameSwitchEffectType))
                          );
end;







{$REGION '摘自qdac_fmx_vkhelper.pas'}
{$IFDEF ANDROID}
{$IF RTLVersion>=33}// 10.3+
type
  TVKStateHandler = class(TComponent)
  protected
    FVKMsgId: Integer; // TVKStateChangeMessage 消息的订阅ID
    procedure DoVKVisibleChanged(const Sender: TObject;
      const Msg: System.Messaging.TMessage);
  public
    constructor Create(AOwner: TComponent); overload; override;
    destructor Destroy; override;
  end;

  TAndroidContentChangeMessage = TMessage<TRect>;

var
  VKHandler: TVKStateHandler;


{$IF RTLVersion>=33}// 10.3+
  _AndroidVKBounds: TRectF;
{$IFEND}

function JRectToRectF(R: JRect): TRectF;
begin
  Result.Left := R.Left;
  Result.Top := R.Top;
  Result.Right := R.Right;
  Result.Bottom := R.Bottom;
end;

function GetVKPixelBounds: TRect;
var
  TotalRect: JRect;
  Content, Total: TRectF;
  ContentRect: JRect;
  AView: JView;
begin
  TotalRect := TJRect.Create;
  ContentRect := TJRect.Create;
  AView := TAndroidHelper.Activity.getWindow.getDecorView;
  AView.getDrawingRect(ContentRect);
  Content := JRectToRectF(ContentRect);
  AView.getDrawingRect(TotalRect);
  Total := JRectToRectF(TotalRect);
  Result.Left := Trunc(Total.Left);
  Result.Top := Trunc(Total.Top + AView.getHeight);
  Result.Right := Trunc(Total.Right);
  Result.Bottom := Trunc(Total.Bottom);
end;

function GetVKBounds(var ARect: TRectF): Boolean; overload;
begin
  {$IF RTLVersion>=33}// 10.3+
  if MainActivity.getVirtualKeyboard.isVirtualKeyboardShown then
  begin
    ARect := _AndroidVKBounds;
    Result := not ARect.IsEmpty;
  end
  else
  begin
    ARect := TRectF.Empty;
    Result := false;
  end;
  {$IFEND}
end;

function GetVKBounds: TRectF; overload;
var
  b: TRectF;
begin
  if not GetVKBounds(Result) then
    Result := TRectF.Empty;
end;

function GetVKBounds(var ARect: TRect): Boolean; overload;
var
  R: TRectF;
begin
  Result := GetVKBounds(R);
  ARect := R.Truncate;
end;

/// 根据MainActivity的可视区域和绘图区域大小来确定是否显示了虚拟键盘
function IsVKVisible: Boolean;
var
  R: TRect;
begin
{$IFDEF NEXTGEN}
  Result := GetVKBounds(R);
{$ELSE}
  Result := false;
{$ENDIF}
end;



{ TVKStateHandler }

// 构造函数，订阅消息
constructor TVKStateHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVKMsgId := TMessageManager.DefaultManager.SubscribeToMessage
    (TVKStateChangeMessage, DoVKVisibleChanged);
end;

/// 析构函数，取消消息订阅
destructor TVKStateHandler.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TVKStateChangeMessage, FVKMsgId);
  inherited;
end;

/// 虚拟键盘可见性变更消息，调整或恢复控件位置
procedure TVKStateHandler.DoVKVisibleChanged(const Sender: TObject;
  const Msg: System.Messaging.TMessage);
var
  AVKMsg: TVKStateChangeMessage absolute Msg;
begin
  {$IFDEF IOS}
    _IOS_VKBounds := TRectF.Create(AVKMsg.KeyboardBounds);
  {$ENDIF}
  {$IFDEF ANDROID}
  {$IF RTLVersion>=33}// 10.3+
    _AndroidVKBounds := TRectF.Create(AVKMsg.KeyboardBounds);
  {$IFEND}
  {$ENDIF}
end;
{$IFEND RTLVersion}
{$ENDIF ANDROID}
{$ENDREGION '摘自qdac_fmx_vkhelper.pas'}



procedure AlignControls(ATopControl:TControl;
                        AControl1:TControl=nil;
                        AControl2:TControl=nil;
                        AControl3:TControl=nil;
                        AControl4:TControl=nil;
                        AControl5:TControl=nil;
                        AControl6:TControl=nil;
                        AControl7:TControl=nil;
                        AControl8:TControl=nil;
                        AControl9:TControl=nil;
                        AControl10:TControl=nil;
                        AControl11:TControl=nil;
                        AControl12:TControl=nil;
                        AControl13:TControl=nil;
                        AControl14:TControl=nil
                        );
var
  ALastControl:TControl;
  ATop:TControlSize;
begin
  ALastControl:=nil;
  ATop:=0;

  if (ATopControl<>nil) and ATopControl.Visible then
  begin
    ALastControl:=ATopControl;
  end;



  if (AControl1<>nil) and AControl1.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl1,AControl1.Margins.Top+ATop+1);
    ALastControl:=AControl1;
  end;



  if (AControl2<>nil) and AControl2.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl2,AControl2.Margins.Top+ATop+1);
    ALastControl:=AControl2;
  end;



  if (AControl3<>nil) and AControl3.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl3,AControl3.Margins.Top+ATop+1);
    ALastControl:=AControl3;
  end;



  if (AControl4<>nil) and AControl4.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl4,AControl4.Margins.Top+ATop+1);
    ALastControl:=AControl4;
  end;



  if (AControl5<>nil) and AControl5.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl5,AControl5.Margins.Top+ATop+1);
    ALastControl:=AControl5;
  end;



  if (AControl6<>nil) and AControl6.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl6,AControl6.Margins.Top+ATop+1);
    ALastControl:=AControl6;
  end;



  if (AControl7<>nil) and AControl7.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl7,AControl7.Margins.Top+ATop+1);
    ALastControl:=AControl7;
  end;



  if (AControl8<>nil) and AControl8.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl8,AControl8.Margins.Top+ATop+1);
    ALastControl:=AControl8;
  end;



  if (AControl9<>nil) and AControl9.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl9,AControl9.Margins.Top+ATop+1);
    ALastControl:=AControl9;
  end;



  if (AControl10<>nil) and AControl10.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl10,AControl10.Margins.Top+ATop+1);
    ALastControl:=AControl10;
  end;



  if (AControl11<>nil) and AControl11.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl11,AControl11.Margins.Top+ATop+1);
    ALastControl:=AControl11;
  end;



  if (AControl12<>nil) and AControl12.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl12,AControl12.Margins.Top+ATop+1);
    ALastControl:=AControl12;
  end;



  if (AControl13<>nil) and AControl13.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl13,AControl13.Margins.Top+ATop+1);
    ALastControl:=AControl13;
  end;



  if (AControl14<>nil) and AControl14.Visible then
  begin
    if ALastControl<>nil then ATop:=GetControlTop(ALastControl)+ALastControl.Height;
    SetControlTop(AControl14,AControl14.Margins.Top+ATop+1);
    ALastControl:=AControl14;
  end;


end;

function GetReleatedTop(AChild:TControl;AParent:TChildControl):TControlSize;
var
  BParent:TControl;
begin
  Result:=GetControlTop(AChild);
  BParent:=TControl(AChild.Parent);
  while (BParent<>nil) and (BParent<>AParent) do
  begin
    if BParent<>nil then
    begin
      Result:=Result+GetControlTop(BParent);
    end;
    BParent:=TControl(BParent.Parent);
  end;
end;

procedure SetSuitScrollContentHeight(AScrollBoxContent:TParentControl;
                                    const ABottomSpace:TControlSize=20);
begin
  AScrollBoxContent.Height:=
    GetSuitScrollContentHeight(AScrollBoxContent,ABottomSpace);
end;

function GetSuitScrollContentHeight(AScrollBoxContent:TParentControl;const ABottomSpace:TControlSize):TControlSize;
begin
  Result:=GetSuitControlContentHeight(AScrollBoxContent,ABottomSpace);
end;

function GetSuitControlContentHeight(AControl:TParentControl;const ABottomSpace:TControlSize):TControlSize;
var
  I: Integer;
  AChildControl:TChildControl;
begin
  Result:=0;
  AChildControl:=nil;
  for I := 0 to GetParentChildControlCount(AControl)-1 do
  begin
    AChildControl:=GetParentChildControl(AControl,I);
    if  //必须要统计显示的控件
        TControl(AChildControl).Visible
      and (GetControlTop(TControl(AChildControl))
            +TControl(AChildControl).Height>Result) then
    begin
      Result:=GetControlTop(TControl(AChildControl))
              +TControl(AChildControl).Height;
    end;
  end;
  Result:=Result+ABottomSpace;
end;



{$IFDEF FMX}
procedure HideVirtualKeyboard;
{$IFDEF MSWINDOWS}
{$ELSE}
var
  VKbSvc: IFMXVirtualKeyboardService;
{$ENDIF}
begin
  if Screen.ActiveForm<>nil then
  begin
//    uBaseLog.OutputDebugString('HideVirtualKeyboard');
    {$IFDEF MSWINDOWS}
    //Windows下模拟隐藏虚拟键盘
    if Screen.ActiveForm.Focused<>nil then
    begin
      SimulateCallMainFormVirtualKeyboardHide(Screen.ActiveForm.Focused.GetObject,True);
    end
    else
    begin
      SimulateCallMainFormVirtualKeyboardHide(nil,True);
    end;
    {$ELSE}
    //关闭虚拟键盘
    if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, VKbSvc) then
    begin
      VKbSvc.HideVirtualKeyboard;
    end;
    {$ENDIF}
    Screen.ActiveForm.Focused := nil;
  end;
end;

procedure ShowVirtualKeyboard(const AControl: TFmxObject);
{$IFDEF MSWINDOWS}
{$ELSE}
var
  VKbSvc: IFMXVirtualKeyboardService;
{$ENDIF}
begin
//  uBaseLog.OutputDebugString('ShowVirtualKeyboard');
  {$IFDEF MSWINDOWS}
  //Windows下模拟显示虚拟键盘
  SimulateCallMainFormVirtualKeyboardShow(AControl);
  {$ELSE}
  //显示虚拟键盘
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, VKbSvc) then
  begin
    VKbSvc.ShowVirtualKeyboard(AControl);
  end;
  {$ENDIF}
end;

procedure SetVirtualKeyboardToolBarEnabled(const Value: Boolean);
{$IFDEF MSWINDOWS}
{$ELSE}
var
  VKbToolBarSvc: IFMXVirtualKeyboardToolbarService;
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  {$ELSE}
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardToolbarService, VKbToolBarSvc) then
  begin
    VKbToolBarSvc.SetToolbarEnabled(Value);
  end;
  {$ENDIF}
end;

function IsVirtualKeyboardVisible:Boolean;
{$IFDEF MSWINDOWS}
{$ELSE}
  var
    VKbSvc: IFMXVirtualKeyboardService;
{$ENDIF}
begin
  Result:=False;
  {$IFDEF MSWINDOWS}
    Result:=(GlobalAutoProcessVirtualKeyboardControl<>nil)
        and GlobalAutoProcessVirtualKeyboardControl.Visible;
  {$ELSE}
    if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, VKbSvc) then
    begin
      Result:=VKbSvc.VirtualKeyboardState * [TVirtualKeyboardState.Visible] <> [];
    end;
    {$IFDEF ANDROID}
    Result:=RectHeight(GetCurrentVirtualKeyboardRectInAndroid)>50;
    {$ENDIF}

  {$ENDIF}
end;

function ProcessVirtualKeyboardShow(AForm:TForm;
                                    const AKeyboardBounds_Height:Double;
                                    AFocusedControl:TControl;
                                    AVirtualKeyboardPanel:TControl;
                                    AKeyboardHeightOffset:Double;
                                    AVirtualKeyboardHeightAdjustHeight:Double
                                    ):Boolean;
begin
    Result:=False;


    //设置虚拟键盘控件的高度
    if AVirtualKeyboardPanel<>nil then
    begin
      AVirtualKeyboardPanel.Height:=AKeyboardBounds_Height
                                    -GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight
                                    -1
                                    +AKeyboardHeightOffset;
    end;



    //获取指定的Form
    if (AForm=nil) and (AFocusedControl<>nil) then
    begin
      AForm:=GetReleatedForm(AFocusedControl);
    end;



    //获取当前得到输入焦点的控件,Edit
    if AFocusedControl=nil then
    begin
      if (AForm.Focused<>nil) and (AForm.Focused.Parent<>nil) then
      begin
        AFocusedControl:=TControl(AForm.Focused.GetObject);
      end;
    end;



    //计算出合理的位置
    if (AFocusedControl<>nil)
      and (GetReleatedScrollControl(AFocusedControl)<>nil) then
    begin

        //因为ScrollBox鼠标按下弹起,Edit会获得焦点,弹出虚拟键盘,ScrollBox还会惯性滚动
        //并且虚拟键盘弹起,鼠标弹起,会引起剧烈的惯性滚动,故先不设置Position,
        //在Timer中停止惯性滚动,然后再设置Position
        GetGlobalVirtualKeyboardFixer.ProcessVKShowFocusedControl(AFocusedControl,AKeyboardBounds_Height+AVirtualKeyboardHeightAdjustHeight);

        Result:=True;

    end
    else
    begin
      uBaseLog.OutputDebugString('ProcessVirtualKeyboardShow AFocusedControl=nil');
    end;


end;
{$ENDIF}

function GetReleatedScrollControl(AChild:TChildControl):TSkinScrollControl;
var
  AParent:TControl;
begin
  Result:=nil;
  AParent:=TControl(AChild.Parent);
  while (AParent<>nil) do
  begin
    if (AParent is TSkinScrollControl) then
    begin
      Result:=TSkinScrollControl(AParent);
      //遍历到最后,不退出
//      Break;
    end;
    AParent:=TControl(AParent.Parent);
  end;
end;

function GetSuitContentHeight(AControlWidth:Double;
                              AContent:String;
                              AFontSize:Integer;
                              AOneLineControlHeight:Double
                              ):Double;
var
  ATextHeight:Double;
  ALineHeight:Double;
begin
  GetGlobalDrawTextParam.IsWordWrap:=True;
  GetGlobalDrawTextParam.FontSize:=AFontSize;

  //文字的高度
  ATextHeight:=uSkinBufferBitmap.GetStringHeight(AContent,
                                RectF(0,0,AControlWidth,MaxInt),
                                GlobalDrawTextParam);

  //判断出有几行
  ALineHeight:=GetStringHeight('判断有几行',
                                RectF(0,0,1000,MaxInt),
                                GlobalDrawTextParam
                                );

  if ATextHeight/ALineHeight<1.2 then
  begin
    //只有一行
    Result:=AOneLineControlHeight;
  end
  else
  begin
    //每行再加上5个点的偏移
    Result:=(AOneLineControlHeight-ALineHeight)
              +ATextHeight
              +ATextHeight/ALineHeight*5;
  end;

end;


{$IFDEF FMX}
function GetGlobalVirtualKeyboardFixer:TVirtualKeyboardFixer;
begin
  if GlobalVirtualKeyboardFixer=nil then
  begin
    GlobalVirtualKeyboardFixer:=TVirtualKeyboardFixer.Create;
  end;
  Result:=GlobalVirtualKeyboardFixer;
end;


procedure CallSubFrameVirtualKeyboardShown(Sender: TObject;
//                                          Parent:TFmxObject;
                                          KeyboardVisible: Boolean;
                                          const Bounds: TRect;
                                          AIsFirst:Boolean=True);
var
//  I: Integer;
//  AFrame:TFrame;
//  AChild:TFmxObject;
  AVirtualKeyboardPanelParent:TFmxObject;
  AFocusedControl:TControl;
  AOldFrameVirtualKeyboardEvent:IFrameVirtualKeyboardEvent;
  AFrameVirtualKeyboardAutoProcessEvent:IFrameVirtualKeyboardAutoProcessEvent;
  AParentIsScrollBoxContent:Boolean;
  AParentScrollBox:TControl;
  AParent:TFmxObject;
  AVirtualKeyboardHeightAdjustHeight:Double;
begin
  if AIsFirst then
  begin
    uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown IsFirst');
  end;


  if AIsFirst then
  begin
    //设置状态,虚拟键盘又显示了,避免在自动检测时虚拟键盘被关掉
    GetGlobalVirtualKeyboardFixer.VirtualKeyboardQuickShowedAfterHidden:=True;
    uBaseLog.OutputDebugString('VirtualKeyboardQuickShowedAfterHidden True ');
  end;


  AVirtualKeyboardHeightAdjustHeight:=0;


  {$IFDEF ANDROID}
  //判断
  if AIsFirst then
  begin
      //虚拟键盘是否已经显示了,虚拟键盘已经显示了就不用再调用了
      //避免出现跳动的情况
      if GetGlobalVirtualKeyboardFixer.FLastVirtualKeyboardVisible then
      begin
          uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown Already Visible');
          Exit;
      end;
  end;
  GetGlobalVirtualKeyboardFixer.FLastVirtualKeyboardVisible:=True;
  {$ENDIF ANDROID}



  //获取弹出虚拟键盘的控件-基本上是文本框
  AFocusedControl:=nil;
  if Screen.ActiveForm.Focused<>nil then
  begin
    AFocusedControl:=TControl(Screen.ActiveForm.Focused.GetObject);
  end;
  if AFocusedControl=nil then
  begin
    //当WebBrowser中的输入框获取了焦点,那么WebBrowserFrame也要处理一下,以便文本框显示出来
    uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown AFocusedControl is nil or webbrowser');
    //Exit;
  end
  else
  begin
    uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown AFocusedControl is '+AFocusedControl.Name);
  end;



  //找到焦点控件Edit所在的父SrollBox,如果有父ScrollBox,
  //那就直接把VitualKeyboardPanel添加到ScrollBox.Parent,一般就是一个Frame
  AParentIsScrollBoxContent:=False;
  AParentScrollBox:=nil;
  if AFocusedControl<>nil then
  begin
    if not GetParentIsScrollBoxContent(AFocusedControl,AParentIsScrollBoxContent,AParentScrollBox) then
    begin
      uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown Parent Is Not ScrollBox');
    end
    else
    begin
      uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown Parent ScrollBox is '+AParentScrollBox.Name);
    end;
  end;



//  for I := Parent.ChildrenCount-1 downto 0 do
//  begin
//      AChild:=Parent.Children[I];
//      if (AChild is TFrame)
//        and TControl(AChild).Visible
//        //如果Frame中有子Frame,那么这句应该去掉
//        //如果Frame中有多个Farme,那么...
////        and (AChild=CurrentFrame)
//        and (
//              //不是嵌套在PageControl中的Frame
//              not (AChild.Parent is TSkinTabSheet)
//              //是嵌套在PageControl中的Frame,而且
//              or (AChild.Parent is TSkinTabSheet)
//                  and (TSkinPageControl(TSkinTabSheet(AChild.Parent).Prop.PageControl).Prop.ActivePage=AChild.Parent)
//             )
//      then
//      begin
//
//
//          AFrame:=TFrame(AChild);
//
//          uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown '+AFrame.Name);




//          //AFrame有ScrollBox
//          if
//            //新的不需要接口,有ScrollBox即可
//            ParentHasScrollBox(AFrame)
//
//            //老的需要IFrameVirtualKeyboardAutoProcessEvent接口
//            or AFrame.GetInterface(IID_IFrameVirtualKeyboardAutoProcessEvent,AFrameVirtualKeyboardAutoProcessEvent)
//                //规定GetVirtualKeyboardControlParent必须返回不为空,不然不处理
//                //处理键盘的Frame嵌套在处理键盘的Frame中时，里面的Frame可以返回nil来让父Frame来处理键盘
//                and (AFrameVirtualKeyboardAutoProcessEvent.GetVirtualKeyboardControlParent<>nil)
//            then
//          begin

//                uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown '+AFrame.Name+' IFrameVirtualKeyboardAutoProcessEvent');




            //遍历编辑控件的Parent,如果是Frame,那么判断它是否实现了IFrameVirtualKeyboardEvent,
            //实现了就调用
            //老的接口IFrameVirtualKeyboardEvent
            if AFocusedControl<>nil then
            begin
              AParent:=AFocusedControl.Parent;
            end
            else
            begin
              //WebBrowser中文本框输入的情况
              AParent:=CurrentFrame;
            end;
            while AParent<>nil do
            begin
              if AParent is TFrame then
              begin
                  //有时候需要同时支持IFrameVirtualKeyboardEvent和IFrameVirtualKeyboardAutoProcessEvent
                  if AParent.GetInterface(IID_IFrameVirtualKeyboardEvent,AOldFrameVirtualKeyboardEvent) then
                  begin
                    uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown '+AParent.Name+' IID_IFrameVirtualKeyboardEvent');
                    //手动处理虚拟键盘
                    AOldFrameVirtualKeyboardEvent.DoVirtualKeyboardShow(KeyboardVisible,Bounds);
                    Break;
                  end;
              end;
              AParent:=AParent.Parent;
            end;



            if AFocusedControl=nil then Exit;



            //获取虚拟键盘抬高Panel所要设置的Parent
            AVirtualKeyboardPanelParent:=nil;
            AFrameVirtualKeyboardAutoProcessEvent:=nil;
            if AParentScrollBox<>nil then
            begin
                //有ScrollBox,那么取ScrollBox.Parent,一般为Frame
                AVirtualKeyboardPanelParent:=AParentScrollBox.Parent;

                  if AParentScrollBox.Parent is TFrame then
                  begin
                      //有时候需要同时支持IFrameVirtualKeyboardEvent和IFrameVirtualKeyboardAutoProcessEvent
                      if AParentScrollBox.Parent.GetInterface(IID_IFrameVirtualKeyboardAutoProcessEvent,AFrameVirtualKeyboardAutoProcessEvent) then
                      begin

                        uBaseLog.OutputDebugString('IFrameVirtualKeyboardAutoProcessEvent '+AParentScrollBox.Parent.Name+'');

                        AVirtualKeyboardHeightAdjustHeight:=AFrameVirtualKeyboardAutoProcessEvent.GetVirtualKeyboardHeightAdjustHeight;
                      end;
                  end;

            end
            else
            begin
                //没有ScrollBox
                AParent:=AFocusedControl.Parent;
                while AParent<>nil do
                begin
                  if AParent is TFrame then
                  begin
                      //有时候需要同时支持IFrameVirtualKeyboardEvent和IFrameVirtualKeyboardAutoProcessEvent
                      if AParent.GetInterface(IID_IFrameVirtualKeyboardAutoProcessEvent,AFrameVirtualKeyboardAutoProcessEvent) then
                      begin

                        uBaseLog.OutputDebugString('IFrameVirtualKeyboardAutoProcessEvent '+AParent.Name+'');

                        //手动处理虚拟键盘
                        AVirtualKeyboardPanelParent:=AFrameVirtualKeyboardAutoProcessEvent.GetVirtualKeyboardControlParent;
                        AVirtualKeyboardHeightAdjustHeight:=AFrameVirtualKeyboardAutoProcessEvent.GetVirtualKeyboardHeightAdjustHeight;
                        Break;
                      end;

                  end;
                  AParent:=AParent.Parent;
                end;
            end;



            if AVirtualKeyboardPanelParent<>nil then
            begin
                uBaseLog.OutputDebugString('IFrameVirtualKeyboardAutoProcessEvent AVirtualKeyboardPanelParent is '+AVirtualKeyboardPanelParent.Name);



                //自动处理虚拟键盘
                if (GlobalAutoProcessVirtualKeyboardControl=nil)  then
                begin
                    //自动创建虚拟键盘Panel,不再需要通过MainForm赋值了
                    GlobalAutoProcessVirtualKeyboardControl:=TSkinPanel.Create(Application);
                    GlobalAutoProcessVirtualKeyboardControl.Material.IsTransparent:=False;
                    GlobalAutoProcessVirtualKeyboardControl.Material.BackColor.IsFill := True;
                    GlobalAutoProcessVirtualKeyboardControl.Material.BackColor.FillColor.Color := TAlphaColorRec.Black;
                    GlobalAutoProcessVirtualKeyboardControl.Material.IsTransparent := False;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.FontSize := 20;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.FontColor := TAlphaColorRec.White;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.DrawFont.Size := 20;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.DrawFont.Color := TAlphaColorRec.White;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.DrawFont.FontColor.Color := TAlphaColorRec.White;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.FontTrimming := fttNone;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.FontHorzAlign := fhaCenter;
                    GlobalAutoProcessVirtualKeyboardControl.Material.DrawCaptionParam.FontVertAlign := fvaCenter;
                    GlobalAutoProcessVirtualKeyboardControl.Caption := 'WindowsVirtualKeyBoard';
                    {$IFNDEF MSWINDOWS}
                    //手机上透明,Windows上黑色
                    GlobalAutoProcessVirtualKeyboardControl.SelfOwnMaterialToDefault.IsTransparent:=True;
                    GlobalAutoProcessVirtualKeyboardControl.Caption:='';
                    {$ENDIF}
                end;



                //Parent没有变过就不需要重新排列位置,避免ScrollBox的Position移动
                if (GlobalAutoProcessVirtualKeyboardControl.Parent<>AVirtualKeyboardPanelParent) then
//                  AFrameVirtualKeyboardAutoProcessEvent.GetVirtualKeyboardControlParent then
                begin

                      //虚拟键盘控件放在哪个父控件里面
                      GlobalAutoProcessVirtualKeyboardControl.Parent:=AVirtualKeyboardPanelParent;//AFrameVirtualKeyboardAutoProcessEvent.GetVirtualKeyboardControlParent;
//                      uBaseLog.OutputDebugString('GlobalAutoProcessVirtualKeyboardControl.Parent '+GlobalAutoProcessVirtualKeyboardControl.Parent.ClassName+' '+GlobalAutoProcessVirtualKeyboardControl.Parent.Name);
                      GlobalAutoProcessVirtualKeyboardControl.Position.Y:=GetControlParentHeight(GlobalAutoProcessVirtualKeyboardControl.Parent);
                      GlobalAutoProcessVirtualKeyboardControl.Align:=TAlignLayout.None;
                      GlobalAutoProcessVirtualKeyboardControl.Align:=TAlignLayout.MostBottom;
                      GlobalAutoProcessVirtualKeyboardControl.Visible:=True;
                      GlobalAutoProcessVirtualKeyboardControl.Height:=Bounds.Height
                                                      -GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight
                                                      -1;

                      //点击关闭虚拟键盘的事件(在Win32平台下)
                      GlobalAutoProcessVirtualKeyboardControl.OnClick:=GetGlobalVirtualKeyboardFixer.DoSimulateWindowsVirtualKeyBoardClick;

                end;



                //获取弹出虚拟键盘的控件-基本上是文本框
//                AFocusedControl:=nil;
//                if Screen.ActiveForm.Focused<>nil then
//                begin
//                  AFocusedControl:=TControl(Screen.ActiveForm.Focused.GetObject);
//                end;


                //有些情况,Edit并不在ScrollBox里面,只需要将VirtualKeyboardPanel插入到Frame就可以了
                if AFrameVirtualKeyboardAutoProcessEvent<>nil then
                begin
                  AFocusedControl:=AFrameVirtualKeyboardAutoProcessEvent.GetCurrentPorcessControl(AFocusedControl);
                end;


                //设置ScrollBox的位置
                if (AFocusedControl<>nil) and (AParentScrollBox<>nil) then
                begin
                  ProcessVirtualKeyboardShow(TForm(Sender),Bounds.Height,AFocusedControl,nil,0,AVirtualKeyboardHeightAdjustHeight);
                end;


            end;



//          end;





//          //有时候需要同时支持IFrameVirtualKeyboardEvent和IFrameVirtualKeyboardAutoProcessEvent
//          if AChild.GetInterface(IID_IFrameVirtualKeyboardEvent,AOldFrameVirtualKeyboardEvent) then
//          begin
//
////                uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardShown '+AFrame.Name+' IID_IFrameVirtualKeyboardEvent');
//
//                //手动处理虚拟键盘
//                AOldFrameVirtualKeyboardEvent.DoVirtualKeyboardShow(KeyboardVisible,Bounds);
//
//          end;




//      end;
//
//      CallSubFrameVirtualKeyboardShown(Sender,AChild,KeyboardVisible,Bounds,False);
//  end;




end;


procedure CallSubFrameVirtualKeyboardHidden(Sender: TObject;
//                                            Parent:TFmxObject;
                                            KeyboardVisible: Boolean;
                                            const Bounds: TRect);
begin
  uBaseLog.OutputDebugString('CallSubFrameVirtualKeyboardHidden');


  //不能立即调用虚拟键盘隐藏事件,
  //得设置一个间隔等待一下,
  //如果立即又显示了键盘,那么就不需要隐藏VirtualKeyboardPanel了
  //启动Timer
  GetGlobalVirtualKeyboardFixer.StartCheckRealHidden(Sender,
//                                                      Parent,
                                                      Bounds);
end;

function GetCurrentVirtualKeyboardRectInAndroid:TRect;
{$IFDEF ANDROID}
var
  ContentRect, TotalRect: JRect;
//  AVKHeight:Integer;
//  ATotalHeight:Integer;
{$ENDIF}
begin
{$IFDEF ANDROID}
  ContentRect := TJRect.Create;
  TotalRect := TJRect.Create;

  //当前屏幕可见区域
  TAndroidHelper.Activity.getWindow.getDecorView.getWindowVisibleDisplayFrame(ContentRect);


  //当前屏幕内容的高度
  TAndroidHelper.Activity.getWindow.getDecorView.getDrawingRect(TotalRect);
  //屏幕整体的高度
//  ATotalHeight:=TAndroidHelper.Activity.getWindow.getDecorView.getHeight();


  Result := TRectF.Create(
                ConvertPixelToPoint(TPointF.Create(TotalRect.left, TotalRect.top + ContentRect.height)),
                ConvertPixelToPoint(TPointF.Create(TotalRect.right, TotalRect.bottom))
                ).Truncate;



  {$IF RTLVersion>=33}// 10.3+
  Result:=GetVKBounds.Truncate;
//  ATotalHeight:=RectHeight(Result);
  {$IFEND}

//  uBaseLog.OutputDebugString('OrangeUI GetCurrentVirtualKeyboardRectInAndroid getWindowVisibleDisplayFrame '
//                              +FloatToStr(ContentRect.left)+','
//                              +FloatToStr(ContentRect.top)+','
//                              +FloatToStr(ContentRect.right)+','
//                              +FloatToStr(ContentRect.bottom)+','
//                              );
//
//  uBaseLog.OutputDebugString('OrangeUI GetCurrentVirtualKeyboardRectInAndroid getDrawingRect '
//                              +FloatToStr(TotalRect.left)+','
//                              +FloatToStr(TotalRect.top)+','
//                              +FloatToStr(TotalRect.right)+','
//                              +FloatToStr(TotalRect.bottom)+','
//                              );
//
//  uBaseLog.OutputDebugString('OrangeUI GetCurrentVirtualKeyboardRectInAndroid GetVKBounds '
//                              +FloatToStr(Result.left)+','
//                              +FloatToStr(Result.top)+','
//                              +FloatToStr(Result.right)+','
//                              +FloatToStr(Result.bottom)+','
//                              );
//  uBaseLog.OutputDebugString('OrangeUI GetCurrentVirtualKeyboardRectInAndroid ATotalHeight '
//                              +FloatToStr(ATotalHeight)
//                              );

{$ENDIF}

end;


{ TVirtualKeyboardFixer }


procedure TVirtualKeyboardFixer.DoProcessVKboardShowTimer(Sender: TObject);
var
  APosition:Double;
  AFocusedControlRelatedTop:Double;
  AFocusedControlPos:TPointF;
  AScrollControlPos:TPointF;
  AScrollControl:TSkinScrollControl;
begin
  Self.tmrProcessVKboardShow.Enabled:=False;


  AScrollControl:=GetReleatedScrollControl(FVKBoardShow_FocusedControl);
  if AScrollControl<>nil then
  begin



//      //停止惯性滚动
//      uBaseLog.OutputDebugString('TVirtualKeyboardFixer.DoProcessVKboardShowTimer InertiaScrollAnimator.Pause');
//      AScrollControl.Prop.VertControlGestureManager.InertiaScrollAnimator.Pause;



      //计算出合理的位置
      AFocusedControlPos:=PointF(0,0);
      AFocusedControlPos:=FVKBoardShow_FocusedControl.LocalToAbsolute(AFocusedControlPos);
      AScrollControlPos:=PointF(0,0);
      AScrollControlPos:=AScrollControl.LocalToAbsolute(AScrollControlPos);



      //当文本框已经显示到正确的位置,将不再设置
      if Not (
                  (AFocusedControlPos.Y-AScrollControlPos.Y>=0)
              and (AFocusedControlPos.Y-AScrollControlPos.Y+FVKBoardShow_FocusedControl.Height<=AScrollControl.Height)
              ) then
      begin


          APosition:=AScrollControl.VertScrollBar.Properties.Position
                      +AFocusedControlPos.Y-AScrollControlPos.Y+FVKBoardShow_FocusedControl.Height
                      //Android下KeyboardBounds.Height比正常要多VirtualKeyboardHideHeight,所以要减去
                      -(Screen.ActiveForm.ClientHeight-(FVKBoardShow_Height-GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight))
                      +GetReleatedTop(AScrollControl,Screen.ActiveForm)
                      +10
                      ;

          uBaseLog.OutputDebugString('TVirtualKeyboardFixer.DoProcessVKboardShowTimer'
                                      +' AFocusedControl='+FVKBoardShow_FocusedControl.Name
                                      +' OldPosition='+FloatToStr(AScrollControl.VertScrollBar.Properties.Position)
                                      +' NewPosition='+FloatToStr(APosition)
                                      +' Max='+FloatToStr(AScrollControl.VertScrollBar.Properties.Max)
                                      );

          //设置文本框的位置
          AScrollControl.Prop.VertControlGestureManager.Position:=APosition;

      end
      else
      begin
          uBaseLog.OutputDebugString('TVirtualKeyboardFixer.DoProcessVKboardShowTimer'
                                      +' AFocusedControl='+FVKBoardShow_FocusedControl.Name
                                      +' Position Is OK'
                                      );

      end;

  end;


  FVKBoardShow_FocusedControl:=nil;

end;

procedure TVirtualKeyboardFixer.DoSimulateWindowsVirtualKeyBoardClick(Sender: TObject);
begin
  //隐藏虚拟键盘
  if GlobalAutoProcessVirtualKeyboardControl<>nil then
  begin
    if GlobalAutoProcessVirtualKeyboardControl.CanFocus then
    begin
      GlobalAutoProcessVirtualKeyboardControl.SetFocus;
    end;
  end;

  TMessageManager.DefaultManager.SendMessage(Screen.ActiveForm,
                                            TVKStateChangeMessage.Create(False, TRect.Empty),
                                            True);

//  if Assigned(GetReleatedForm(TControl(Sender)).OnVirtualKeyboardHidden) then
//  begin
//    //虚拟键盘隐藏
//    GetReleatedForm(TControl(Sender)).OnVirtualKeyboardHidden(Self,False,Rect(0,0,0,0));
//  end;



end;

constructor TVirtualKeyboardFixer.Create;
begin
  {$IFDEF ANDROID}
  FLastVirtualKeyboardVisible:=False;
  {$ENDIF}
  FVirtualKeyboardHeightWhenHideInAndroid:=0;

  FVKStateChangeMessageId := TMessageManager.DefaultManager.SubscribeToMessage(TVKStateChangeMessage, VirtualKeyboardChangeHandler);

end;

destructor TVirtualKeyboardFixer.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TVKStateChangeMessage, FVKStateChangeMessageId);

  {$IFDEF ANDROID}
  FreeAndNil(tmrSyncVirtualKeyboardVisibleInAndroid);
  {$ENDIF}

  FreeAndNil(tmrCheckVirtualKeyboardRealHidden);
  FreeAndNil(tmrProcessVKboardShow);
  inherited;
end;

procedure TVirtualKeyboardFixer.DoCheckVirtualKeyboardRealHiddenTimer(Sender: TObject);
begin

  //不能立即调用虚拟键盘隐藏事件,
  //得设置一个间隔等待一下,
  //如果立即又显示了键盘,那么就不需要隐藏
  //启动Timer


  tmrCheckVirtualKeyboardRealHidden.Enabled:=False;
  if Not VirtualKeyboardQuickShowedAfterHidden then
  begin
      //虚拟键盘真的隐藏了

//      OutputDebugString('TVirtualKeyboardFixer.DoCheckVirtualKeyboardRealHiddenTimer');



      //当在ScrollBox上面关闭了虚拟键盘
      if (Screen.ActiveForm<>nil)
        and (Screen.ActiveForm.Focused<>nil) then
      begin
        OutputDebugString('TVirtualKeyboardFixer.DoCheckVirtualKeyboardRealHiddenTimer Screen.ActiveForm.Focused:=nil');
        //那么取消焦点,避免滑动的时候又弹出来了
        Screen.ActiveForm.Focused:=nil;
      end;





      //隐藏虚拟键盘Panel
      if (GlobalAutoProcessVirtualKeyboardControl<>nil)
        and (GlobalAutoProcessVirtualKeyboardControl.Visible) then
      begin
        GlobalAutoProcessVirtualKeyboardControl.Visible:=False;
        GlobalAutoProcessVirtualKeyboardControl.Parent:=nil;
      end;


      //如果在短时间内虚拟键盘真的没有显示
      //那就调用隐藏
      if Screen.ActiveForm<>nil then
      begin
        RealCallSubFrameVirtualKeyboardHidden_InTimer(FCallHiddenSender,
                                                    Screen.ActiveForm,
//                                                    FCallHiddenParent,
                                                    False,
                                                    FCallHiddenBounds);
      end;


  end
  else
  begin
//      OutputDebugString('TVirtualKeyboardFixer.DoCheckVirtualKeyboardRealHiddenTimer VirtualKeyboardQuickShowedAfterHidden');

  end;


end;

{$IFDEF ANDROID}
procedure TVirtualKeyboardFixer.OnSyncVirtualKeyboardVisibleInAndroidTimer(Sender: TObject);
var
  AVKBounds:TRect;
begin
//  if FMainForm<>nil then
//  begin
        AVKBounds:=GetCurrentVirtualKeyboardRectInAndroid;


//        uBaseLog.OutputDebugString('OrangeUI TVirtualKeyboardFixer.OnSyncVirtualKeyboardVisibleInAndroidTimer '+IntToStr(AVKBounds.Height));




        //记录Android平台下虚拟键盘隐藏时的高度
        //因为虚拟键盘隐藏时它的高度并不为0,而是15,20这样比较小的值
        if (AVKBounds.Height<50) then
        begin
//          uBaseLog.OutputDebugString('OrangeUI TVirtualKeyboardFixer.OnSyncVirtualKeyboardVisibleInAndroidTimer OnVirtualKeyboardHidden Bounds.Height='+IntToStr(AVKBounds.Height));
          FVirtualKeyboardHeightWhenHideInAndroid:=AVKBounds.Height;
        end;




        //键盘高度小于50,表示虚拟键盘当前已经隐藏
        if (AVKBounds.Height<50)
            //上次虚拟键盘是显示的状态
            and FLastVirtualKeyboardVisible
//            and Assigned(FMainForm.OnVirtualKeyboardHidden)
            then
        begin
          uBaseLog.OutputDebugString('OrangeUI TVirtualKeyboardFixer.OnSyncVirtualKeyboardVisibleInAndroidTimer CallSubFrameVirtualKeyboardHidden');
          //记录虚拟键盘的显示状态为False
          Self.FLastVirtualKeyboardVisible:=False;

          //那么调用虚拟键盘隐藏
//          FMainForm.OnVirtualKeyboardHidden(Self,False,Rect(0,0,0,0));
          CallSubFrameVirtualKeyboardHidden(Sender,
      //                                        Self,
                                              False,
                                              Rect(0,0,0,0));

          Exit;
        end;




        //键盘高度大于50,表示虚拟键盘当前已经显示
        if (AVKBounds.Height>50)
            //上次虚拟键盘隐藏
            and not FLastVirtualKeyboardVisible
//            and Assigned(FMainForm.OnVirtualKeyboardShown)
            then
        begin
          uBaseLog.OutputDebugString('OrangeUI TVirtualKeyboardFixer.OnSyncVirtualKeyboardVisibleInAndroidTimer CallSubFrameVirtualKeyboardShown');


//          FMainForm.OnVirtualKeyboardShown(Self,
//                                          True,
//                                          Rect(AVKBounds.Left,
//                                          AVKBounds.Top,
//                                          AVKBounds.Right,
//                                          AVKBounds.Bottom));
            CallSubFrameVirtualKeyboardShown(Sender,
        //                                    Self,
                                            True,
                                            Rect(AVKBounds.Left,
                                                  AVKBounds.Top,
                                                  AVKBounds.Right,
                                                  AVKBounds.Bottom));

          Exit;
        end;


//  end;
end;
{$ENDIF}

procedure TVirtualKeyboardFixer.ProcessVKShowFocusedControl(AFocusedControl:TControl;AVKBoardHeight:Double);
begin
//  OutputDebugString('TVirtualKeyboardFixer.ProcessVKShowFocusedControl');

  FVKBoardShow_FocusedControl:=AFocusedControl;
  FVKBoardShow_Height:=AVKBoardHeight;


  if tmrProcessVKboardShow=nil then
  begin
    tmrProcessVKboardShow:=TTimer.Create(nil);
    tmrProcessVKboardShow.Interval:=10;
    tmrProcessVKboardShow.OnTimer:=DoProcessVKboardShowTimer;
  end;
  tmrProcessVKboardShow.Enabled:=False;
  tmrProcessVKboardShow.Enabled:=True;

end;

procedure TVirtualKeyboardFixer.StartCheckRealHidden(Sender: TObject;
//                                                      AParent:TFmxObject;
                                                      const ABounds: TRect);
begin
  FCallHiddenSender:=Sender;
//  FCallHiddenParent:=AParent;
  FCallHiddenBounds:=ABounds;//用不到


  //不能立即调用虚拟键盘隐藏事件,
  //得设置一个间隔等待一下,
  //如果立即又显示了键盘,那么就不需要隐藏,避免ScrollBox滚来滚去
  //启动Timer



  VirtualKeyboardQuickShowedAfterHidden:=False;
  uBaseLog.OutputDebugString('VirtualKeyboardQuickShowedAfterHidden False ');
  if tmrCheckVirtualKeyboardRealHidden=nil then
  begin
    tmrCheckVirtualKeyboardRealHidden:=TTimer.Create(nil);
    tmrCheckVirtualKeyboardRealHidden.Interval:=100;
    tmrCheckVirtualKeyboardRealHidden.OnTimer:=DoCheckVirtualKeyboardRealHiddenTimer;
  end;
  tmrCheckVirtualKeyboardRealHidden.Enabled:=False;
  tmrCheckVirtualKeyboardRealHidden.Enabled:=True;
end;

procedure TVirtualKeyboardFixer.StartSync;//(AMainForm: TForm);
begin
  //只有安卓才需要
  {$IFDEF ANDROID}
//  FMainForm:=AMainForm;
  if tmrSyncVirtualKeyboardVisibleInAndroid=nil then
  begin
    tmrSyncVirtualKeyboardVisibleInAndroid:=TTimer.Create(nil);
    tmrSyncVirtualKeyboardVisibleInAndroid.Interval:=500;//原来是200毫秒，但是有时候键盘隐藏了又弹起来，
    tmrSyncVirtualKeyboardVisibleInAndroid.OnTimer:=OnSyncVirtualKeyboardVisibleInAndroidTimer;
  end;
  tmrSyncVirtualKeyboardVisibleInAndroid.Enabled:=True;
  {$ENDIF}
end;


procedure TVirtualKeyboardFixer.VirtualKeyboardChangeHandler(const Sender: TObject; const Msg: System.Messaging.TMessage);
begin
  if TVKStateChangeMessage(Msg).KeyboardVisible then
  begin
//    if Assigned(FOnVirtualKeyboardShown) then
//      FOnVirtualKeyboardShown(Self, True, TVKStateChangeMessage(Msg).KeyboardBounds)
    FMX.Types.Log.d('OrangeUI TVirtualKeyboardFixer.VirtualKeyboardChangeHandler ');
    CallSubFrameVirtualKeyboardShown(Sender,
//                                    Self,
                                    True,
                                    TVKStateChangeMessage(Msg).KeyboardBounds);
  end
  else// if Assigned(FOnVirtualKeyboardHidden) then
  begin
    //FOnVirtualKeyboardHidden(Self, False, TVKStateChangeMessage(Msg).KeyboardBounds);
    FMX.Types.Log.d('OrangeUI TVirtualKeyboardFixer.VirtualKeyboardChangeHandler ');
    CallSubFrameVirtualKeyboardHidden(Sender,
//                                        Self,
                                        False,
                                        TVKStateChangeMessage(Msg).KeyboardBounds);
  end;

end;

procedure RealCallSubFrameVirtualKeyboardHidden_InTimer(Sender: TObject;
                                                        Parent:TChildControl;
                                                        KeyboardVisible: Boolean;
                                                        const Bounds: TRect);
var
  I: Integer;
  AChild:TChildControl;
  AOldFrameVirtualKeyboardEvent:IFrameVirtualKeyboardEvent;
begin
      for I := Parent.ChildrenCount-1 downto 0 do
      begin
          AChild:=Parent.Children[I];
          if (AChild is TFrame) and TControl(AChild).Visible then
          begin

              if AChild.GetInterface(IID_IFrameVirtualKeyboardEvent,AOldFrameVirtualKeyboardEvent) then
              begin
                OutputDebugString('RealCallSubFrameVirtualKeyboardHidden_InTimer'+' '+AChild.ClassName);
                AOldFrameVirtualKeyboardEvent.DoVirtualKeyboardHide(KeyboardVisible,Bounds);
              end;

          end;
          RealCallSubFrameVirtualKeyboardHidden_InTimer(Sender,AChild,KeyboardVisible,Bounds);
      end;

end;

{$ENDIF}

//function ParentHasScrollBox(AParent:TControl):Boolean;
//var
//  I: Integer;
//begin
//  Result:=False;
//  for I := 0 to AParent.ChildrenCount-1 do
//  begin
//      if AParent.Children[I] is TSkinFMXScrollBox then
//      begin
//          Result:=True;
//          Break;
//      end;
//      //递归它的子控件
//      if AParent.Children[I] is TControl then
//      begin
//          if ParentHasScrollBox(TControl(AParent.Children[I])) then
//          begin
//            Result:=True;
//            Break;
//          end;
//      end;
//  end;
//
//end;

//procedure CallFocusedControlParentFrameVirtualKeyboard(AChild:TFmxObject);
//var
//  I: Integer;
//  AFrame:TFrame;
//  AOldFrameVirtualKeyboardEvent:IFrameVirtualKeyboardEvent;
//begin
//
//
//end;








initialization
  {$IFDEF IOS}
  //在IOS平台下会快(因为GPU绘制中文字体的文本之前先要生成文字的Bitmap)
  GlobalIsUseDefaultFontFamily:=True;
  {$ENDIF}


//  //因为OrangeUI不能引用FMX.WebBrowser,因为别人会用一些修复单元
//  uFrameContext.OnWebBrowserRealign:=DoWebBrowserRealign;


//  //默认主题色
//  uGraphicCommon.SkinThemeColor:=TAlphaColorRec.Orange;
//  //默认主题色2
//  uGraphicCommon.SkinThemeColor1:=TAlphaColorRec.Orange;


  //OrangeUI默认主题色
  uGraphicCommon.SkinThemeColor:=$FF0199FF;//TAlphaColorRec.Orange;
  //OrangeUI默认主题色2
  uGraphicCommon.SkinThemeColor1:=$FF4DC060;//TAlphaColorRec.Orange;



//  {$IFDEF FMX}
//  //在Windows平台下的模拟虚拟键盘控件
//  SimulateWindowsVirtualKeyboardHeight:=160;
//  IsSimulateVirtualKeyboardOnWindows:=True;
//  {$ENDIF}



  // 仅需要Android
  {$IFDEF ANDROID}
  {$IF RTLVersion>=33}// 10.3+
  VKHandler := TVKStateHandler.Create(nil);
  {$IFEND RTLVersion}
  {$ENDIF ANDROID}



  {$IFDEF FMX}
  //主要是虚拟键盘处理和修复Android下的虚拟键盘隐藏和显示
  GetGlobalVirtualKeyboardFixer.StartSync;//(Self);
  {$ENDIF}



finalization
  {$IFDEF FMX}
  FreeAndNil(GlobalVirtualKeyboardFixer);
  {$ENDIF}


  {$IFDEF ANDROID}
  {$IF RTLVersion>=33}// 10.3+
  VKHandler.DisposeOf;
  VKHandler := nil;
  {$IFEND RTLVersion}
  {$ENDIF ANDROID}





end.





