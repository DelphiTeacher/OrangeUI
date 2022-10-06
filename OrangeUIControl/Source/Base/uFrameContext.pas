//convert pas to utf8 by ¥
unit uFrameContext;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  StrUtils,

  {$IF CompilerVersion>=30.0}
  Types,//定义了TRectF
  {$ENDIF}


  {$IFDEF VCL}
  Controls,
  StdCtrls,
  ExtCtrls,
  Forms,
  Graphics,
  {$ENDIF}

  {$IFDEF FMX}
  FMX.Types,
  FMX.Forms,
  FMX.Platform,
  FMX.StdCtrls,
  FMX.Controls,
  FMX.Graphics,
  //不能有FMX.WebBrowser,因为有些人要改FMX.WebBrowser
  //FMX.WebBrowser,
  System.UITypes,
  uSkinFireMonkeyImage,
  {$ENDIF}


  uLang,
  uBaseLog,
  uVersion,
  uBaseList,
  uComponentType,
  uGraphicCommon,
  uFuncCommon,
  DateUtils,
  uSkinAnimator;




const
  IID_IFrameChangeLanguageEvent:TGUID='{A6895200-4FEF-4412-89F4-3C940720FA79}';
  IID_IFramePaintSetting:TGUID='{96ED10A3-811E-40F1-A89D-C3593452E3F8}';
  IID_IFrameHistroyVisibleEvent:TGUID='{835FACFA-AB9F-4D4E-A7A4-B16286A64202}';
  IID_IFrameHistroyReturnEvent:TGUID='{05CC1EBF-5B6A-4E14-8EC0-EE570A457AC5}';




type
  //用在FrameContext的事件中
  TFrameReturnFromEvent=procedure(Sender:TObject;AFromFrame:TFrame) of object;

  //判断是否可以返回上一个页面
  TFrameReturnActionType=(fratDefault,//0表示可以返回
                          fratCanNotReturn,//1表示不能返回，直接到后台
                          fratReturnAndFree,//2表示能返回，并且释放
                          fratCanNotReturnAndToBack,//3表示不能返回，直接到后台
                          fratCustom//4自定义
                          );


  TFrameCanReturnEvent=procedure(Sender:TObject;var AIsCanReturn:TFrameReturnActionType) of object;



  //用在ShowFrame中,然后在ReturnFrame中调用
  TReturnFromFrameEvent=procedure(AFromFrame:TFrame) of object;



  TFrameClass=class of TFrame;
  TFrameHistoryLog=class;





  //Frame切换效果类型
  TFrameSwitchType=(
                    //没有效果
                   fstNone,
                   //普通效果(左右滑动)
                   fstDefault,
                   //普通效果(左右滑动)
                   fstMoveVert,
                   fstAlpha,
                   fstDefaultAndAlpha,
                   fstMoveVertAndAlpha
                   );


  //隐藏Frame的时候调用的类型
  THideFrameType=(
                  hftNone,
                  //自动
                  hftAuto,
                  //在ShowFrame之前调用HideFrame
                  hftBeforeShow,
                  //在ReturnFrame之前调用HideFrame
                  hftBeforeReturn
                  );




  //Frame背景颜色处理接口
  IFramePaintSetting=interface
    ['{96ED10A3-811E-40F1-A89D-C3593452E3F8}']
    //背景色(在Frame上绘制,Frame.OnPainting)
    function GetFillColor:TDelphiColor;
    //状态栏色(任务栏颜色,也就是窗体的颜色,设置Form.Fill.Color)
    //切换到此Frame的时候,设置Form的背景色
    //function GetFormColor:TDelphiColor;
  end;



  //Frame切换多语言的事件
  IFrameChangeLanguageEvent=interface
    ['{A6895200-4FEF-4412-89F4-3C940720FA79}']
    //切换语言
    procedure ChangeLanguage(ALangKind:TLangKind);
  end;




  //Frame显示/隐藏事件接口
  IFrameHistroyVisibleEvent=interface
  ['{835FACFA-AB9F-4D4E-A7A4-B16286A64202}']
    //显示Frame
    procedure DoShow;
    //隐藏Frame
    procedure DoHide;
  end;




  //判断Frame是否可以返回上一层的接口
  IFrameHistroyReturnEvent=interface
    ['{05CC1EBF-5B6A-4E14-8EC0-EE570A457AC5}']
    //是否可以返回上一个Frame
    function CanReturn:TFrameReturnActionType;
  end;




  //Frame绘制
  TFramePaintSettingEvent=class
  public
    //点击Frame,隐藏或者返回
    procedure DoPopupStyleFrameClick(Sender:TObject);
    //始终保持居中
    procedure DoPopupStyleFrameResize(Sender:TObject);
    //绘制
    procedure DoPopupStyleFramePainting(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);

//    procedure DoFramePainting(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  end;


  TFramePopupStyleClickSpaceType=(cstNone,
                                  cstHide,
                                  cstReturnFrame
                                  );
  TFramePopupStyle=record
    PopupWidth:Double;
    PopupHeight:Double;
    //点击空白的地方的处理
    ClickSpaceType:TFramePopupStyleClickSpaceType;
    procedure Clear;
  end;
  PFramePopupStyle=^TFramePopupStyle;

//  //获取Frame弹出的设置
//  IFramePopupStyleSetting=interface
//    ['{48F70344-B914-4388-8885-B5A8114474C1}']
//    function GetPopupStyle:TFramePopupStyle;
//  end;


  //Frame上下文
  TFrameHistory=Record


    //跳转到哪个Frame(函数中创建)
    [Weak]ToFrame:TFrame;
    ToFrameClass:TFrameClass;
    [Weak]ToFrameParent:TObject;


    //返回之后调用的事件
    OnReturnFrame:TReturnFromFrameEvent;


    //上次的跳转Frame(没有用了)
    [Weak]LastToFrame:TFrame;
    LastToFrameClass:TFrameClass;
    [Weak]LastToFrameParent:TObject;


    //是否使用页面切换效果
    FrameSwitchType:TFrameSwitchType;

    IsUsePopupStyle:Boolean;
    FramePopupStyle:TFramePopupStyle;

//    IsHidedPriorFrame:Boolean;

  end;
  PFrameHistory=^TFrameHistory;


  TFrameHistoryLog=class
  public
    FrameHistory:TFrameHistory;
  end;

  //Frame上下文列表
  TFrameHistoryLogList=class(TBaseList)
  private
    function GetItem(Index: Integer): TFrameHistoryLog;
  public
    function FindItemByToFrame(AToFrame:TFrame):TFrameHistoryLog;
    property Items[Index:Integer]:TFrameHistoryLog read GetItem;default;
  end;





  TFrameShowExEvent=procedure(Sender:TObject;AIsReturnShow:Boolean) of object;

  //Frame页面跳转上下文
  {$I ComponentPlatformsAttribute.inc}
  TFrameContext=class(TComponent)
  protected
    [Weak]FFrame:TFrame;

    FOnLoad: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOnShowEx: TFrameShowExEvent;
    FOnReturnFrom: TFrameReturnFromEvent;
    FOnHide: TNotifyEvent;
    FOnBeginHide: TNotifyEvent;
    FOnCreate: TNotifyEvent;
    FOnCanReturn: TFrameCanReturnEvent;
    FOnDestroy: TNotifyEvent;

    procedure DoCreateEvent;
    procedure DoDestroyEvent;
    procedure DoShowEvent;
    procedure DoHideEvent;
    procedure DoBeginHideEvent;
    procedure DoReturnFromEvent(AFromFrame:TFrame);
    procedure DoCanReturnEvent(var AIsCanReturn:TFrameReturnActionType);
  protected
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
  public
    FrameHistory:TFrameHistory;
    IsReturnShow:Boolean;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //返回事件
    property OnReturnFrom:TFrameReturnFromEvent read FOnReturnFrom write FOnReturnFrom;
    //是否可以返回事件
    property OnCanReturn:TFrameCanReturnEvent read FOnCanReturn write FOnCanReturn;
    //创建事件
    property OnCreate:TNotifyEvent read FOnCreate write FOnCreate;
    //释放事件
    property OnDestroy:TNotifyEvent read FOnDestroy write FOnDestroy;
    //显示事件
    property OnShow:TNotifyEvent read FOnShow write FOnShow;
    property OnShowEx:TFrameShowExEvent read FOnShowEx write FOnShowEx;
    property OnLoad:TNotifyEvent read FOnLoad write FOnLoad;
    //隐藏事件
    property OnHide:TNotifyEvent read FOnHide write FOnHide;
    property OnBeginHide:TNotifyEvent read FOnBeginHide write FOnBeginHide;
  end;




  //Frame操作类型
  TFrameOperType=(
                   //直接隐藏
                   fotHideDirect,
                   //显示一个Frame之前隐藏原Frame
                   fotHideBeforeShow,
                   //返回一个Frame之前隐藏当前Frame
                   fotHideBeforeReturn,
                   //自动检测
                   fotHideAuto,

                   fotShow,
                   fotReturnShow
                   );
  //Frame操作项
  TFrameOperItem=class
  public
    FrameOperType:TFrameOperType;
    Frame:TFrame;
    FrameHistory:TFrameHistory;
    LastFrameHistory:TFrameHistory;
    IsNeedFreeFrame:Boolean;
  end;



  //Frame操作管理
  TFrameOperManager=class
  private
    //将对话框Frame设置为置顶
    FSetFrameTopMostTimer:TTimer;
    procedure DoSetFrameTopMostTimer(Sender:TObject);
  private
    FCurrentShowFrameItem:TFrameOperItem;
    FCurrentHideFrameItem:TFrameOperItem;
    FFrameOperItems:TBaseList;

    FFrameOperTimer:TTimer;
    procedure DoFrameOperTimer(Sender:TObject);
    procedure EndCurrentShowFrameItem;
    procedure EndCurrentHideFrameItem;

    //执行显示或隐藏的操作
    procedure DoExecuteFrameOper(CurrentItem:TFrameOperItem);

  private
    //隐藏Frame的切换效果项
    HideFrameEffect:TControlEffectItem;
    //显示Frame的切换效果项
    ShowFrameEffect:TControlEffectItem;
    //返回Frame时隐藏Frame的切换效果项
    ReturnHideFrameEffect:TControlEffectItem;
    //返回Frame时显示Frame的切换效果项
    ReturnShowFrameEffect:TControlEffectItem;


    //页面隐藏效果事件
    procedure DoHideFrameAnimate(Sender:TObject);
    procedure DoHideFrameAnimateBegin(Sender:TObject);
    procedure DoHideFrameAnimateEnd(Sender:TObject);

    //页面显示效果事件
    procedure DoShowFrameAnimate(Sender:TObject);
    procedure DoShowFrameAnimateBegin(Sender:TObject);
    procedure DoShowFrameAnimateEnd(Sender:TObject);

  private
    //动画效果显示Frame
    procedure DoAnimateShowFrame(AFrameOperItem:TFrameOperItem;ToFrame:TFrame;ToFrameParent:TObject);
    procedure DoAnimateReturnShowFrame(AFrameOperItem:TFrameOperItem;ToFrame:TFrame;ToFrameParent:TObject);
    procedure DoAnimateHideFrame(AFrameOperItem:TFrameOperItem;Frame:TFrame;const HideFrameType:THideFrameType);
  public
  public
    constructor Create;
    destructor Destroy;override;
  public
    //Frame切换动画效果管理
    FrameSwitchEffectAnimator:TControlEffectAnimator;
    procedure Run;
  public
    //判断这个Frame是否正在隐藏
    function IsFrameHideing(AFrame:TFrame):Boolean;
    //判断这个Frame是否正在显示
    function IsFrameShowing(AFrame:TFrame):Boolean;
    //判断这个Frame是否正在返回
    function IsFrameReturning(AFrame:TFrame):Boolean;
  end;



  TFrameFormMap=class
  public
    FFrame:TFrame;
    FForm:TForm;
    FOnClose:TNotifyEvent;
    //正常关闭窗体的事件
    procedure DoFormClose(Sender: TObject; var Action: TCloseAction);
    //调用ReturnFrame而关闭窗体的事件
    procedure DoFormCloseInReturnFrame(Sender: TObject; var Action: TCloseAction);
  end;
  TFrameFormMapList=class(TBaseList)
  private
    function GetItem(Index: Integer): TFrameFormMap;
  published
  public
    function Add(AFrame:TFrame;AForm:TForm):TFrameFormMap;
    function FindByForm(AForm:TForm):TFrameFormMap;
    function FindByFrame(AFrame:TFrame):TFrameFormMap;
    property Items[Index:Integer]:TFrameFormMap read GetItem;default;
  end;


  TOnWebBrowserRealignEvent=procedure;







var
  //当前显示的页面
  [Weak]CurrentFrame:TFrame;
  //当前页面的上下文
  CurrentFrameHistory:TFrameHistory;


  //页面操作管理
  GlobalFrameOperManager:TFrameOperManager;
  //页面跳转历史
  GlobalFrameHistoryLogList:TFrameHistoryLogList;
  GlobalFrameSettingLogList:TFrameHistoryLogList;


  //Frame的背景色设置
  GlobalFramePaintSettingEvent:TFramePaintSettingEvent;
  //弹出风格下的Frame宽度,一般用于平板
  GlobalPopupStyleFrameWidth:Double;
  //弹出风格下的Frame背景色,一般用于平板
  GlobalPopupStyleFrameFillColor:TDelphiColor;


//  //是否使用全局的绘制函数(仅在孚盟验货管理中使用过)
//  GlobalIsPaintSetting:Boolean;
//  //全局的背景颜色
//  GlobalFrameFillColor:TDelphiColor;


  //重新排列WebBrowser
  OnWebBrowserRealign:TOnWebBrowserRealignEvent;

  //有时候会弹出多个对话框,用于管理
  GlobalTopMostFrameList:TBaseList;
  GlobalFrameFormMapList:TFrameFormMapList;



{$IFDEF VCL}
var
  GlobalFrameParentFormClass:TFormClass;
{$ENDIF}


var
  //已经释放掉的FrameList
  //比如GlobalLoginFrame已经被释放了,但是没有置nil,再次ShowFrame会报错
  FreedFrameList:TList;
  GlobalClickButtonTime:TDateTime;

//上一页
function LastFrame(AFrame:TFrame):TFrame;


//设置Frame唯一的名字,避免创建重命而失败
procedure SetFrameName(AFrame:TComponent);




//显示一个页面
procedure DoShowFrame(
                    //目标页面引用变量
                    var ToFrame:TFrame;
                    //目标页面类(如果ToFrame为nil,那么使用ToFrameClass来创建)
                    const ToFrameClass:TFrameClass;
                    //目标页面的父控件
                    ToFrameParent:TObject;

                    //其他(不使用,为nil即可)
                    const NoUse:TObject;
                    //源页面(不使用,为nil即可)
                    const NoUse1:TFrame;

                    //返回调用的事件
                    const OnReturnFrame:TReturnFromFrameEvent;
                    //目标页面创建拥有者
                    const Owner:TComponent=nil;
                    //是否记录到页面跳转历史列表
                    const IsLogInHistory:Boolean=True;
                    //是否使用全局的背景色
                    const IsUseGlobalPaintSetting:Boolean=True;
                    //是否使用页面切换效果
                    const FrameSwitchType:TFrameSwitchType=fstDefault;
                    //是否使用弹出风格,在Pad中使用的时候
                    const IsUsePopupStyle:Boolean=False;
                    //弹出时的宽度
                    const APFramePopupStyle:PFramePopupStyle=nil
                    );
//直接显示Frame,设置Frame的Parent和Visible
procedure DoDirectShowFrame(ToFrame:TFrame;ToFrameParent:TObject);
//结束显示Frame,调用OnShow方法
procedure DoFinishShowFrame(ToFrame:TFrame);



//隐藏一个页面
procedure DoHideFrame(
                      //要隐藏的页面,如果为nil,表示隐藏CurrentFrame
                      AFrame:TFrame;
                      //调用的时机,是显示之前隐藏,还是返回之前隐藏
                      const AHideFrameType:THideFrameType=hftAuto;
                      //是否使用页面切换效果
                      const AFrameSwitchType:TFrameSwitchType=fstDefault
                      );
//直接隐藏页面
procedure DoDirectHideFrame(const AFrame:TFrame);
//隐藏页面结束,调用OnHide事件
procedure DoFinishHideFrame(const AFrame:TFrame);



//返回上一个页面
procedure DoReturnFrame(
                      //当前Frame,为空表示自动返回上一页
                      AFromFrame:TFrame=nil;
                      //返回前几页
                      const ReturnStep:Integer=1;
                      //是否需要释放
                      const IsNeedFree:Boolean=False;
                      //是否使用页面切换效果
                      const FrameSwitchType:TFrameSwitchType=fstDefault
                      );
function GetReturnFrameHistoryLog(
                                  //当前Frame
                                  AFrame:TFrame
                                  ):TFrameHistoryLog;
function GetFrameHistory(
                        //当前Frame
                        AFrame:TFrame
                        ):PFrameHistory;
procedure DoFinishReturnShowFrame(AFrameHistory:TFrameHistory;
                                  ALastFrameHistory:TFrameHistory;
                                  AIsNeedFreeFrame:Boolean);
//判断是否可以返回上一个页面
function DoCanReturnFrame(const AFrameHistory:TFrameHistory):TFrameReturnActionType;

function GetFramePopupStyle(AFrame:TFrame):PFramePopupStyle;



//重新排列WebBrowser
procedure WebBrowserRealign;
//输出当前页面跳转历史
procedure OutputFrameHistoryLogList;
{$IFDEF FMX}
//刷新窗体的任务栏颜色
procedure UpdateFormStatusBarColor(AForm:TForm);
{$ENDIF FMX}

//页面切换管理
function GetGlobalFrameOperManager:TFrameOperManager;

//切换语言
procedure ChangeLanguage(ALangKind:TLangKind);


//是否重复按了返回键
function IsRepeatClickReturnButton(AFrame:TFrame):Boolean;


implementation



function IsRepeatClickReturnButton(AFrame:TFrame):Boolean;
begin
  Result:=False;
  if DateUtils.MilliSecondsBetween(Now,GlobalClickButtonTime)<500 then
  begin
    uBaseLog.HandleException(nil,'OrangeUI IsRepeatClickReturnButton');
    //重复点击了
    Result:=True;
  end
  else
  begin
    //没有重复点击
    GlobalClickButtonTime:=Now;
  end;

end;


function LastFrame(AFrame:TFrame):TFrame;
var
  I: Integer;
begin
  Result:=nil;
  for I := GlobalFrameHistoryLogList.Count-1 downto 0 do
  begin
    if GlobalFrameHistoryLogList[I].FrameHistory.ToFrame=AFrame then
    begin
      if I>0 then
      begin
        Result:=GlobalFrameHistoryLogList[I-1].FrameHistory.ToFrame;
      end;
      Break;
    end;
  end;
end;


function GetFramePopupStyle(AFrame:TFrame):PFramePopupStyle;
var
  I: Integer;
  AFrameSettingLog:TFrameHistoryLog;
begin
  Result:=nil;
  AFrameSettingLog:=GlobalFrameSettingLogList.FindItemByToFrame(AFrame);
  if AFrameSettingLog<>nil then
  begin
    Result:=@AFrameSettingLog.FrameHistory.FramePopupStyle;
  end;
end;

procedure ChangeLanguage(ALangKind:TLangKind);
var
  FrameChangeLanguageEvent:IFrameChangeLanguageEvent;
begin
  LangKind:=ALangKind;

  {$IFDEF FMX}
  if (CurrentFrame<>nil) and CurrentFrame.GetInterface(IID_IFrameChangeLanguageEvent,FrameChangeLanguageEvent) then
  begin
    FrameChangeLanguageEvent.ChangeLanguage(LangKind);
  end;

  //遍历子控件
  if (CurrentFrame<>nil) then
  begin
    DoTranslateSubControlsLang(CurrentFrame,
                                GlobalLang,
                                GlobalCurLang
                                );
  end;
  {$ENDIF}

end;



//页面切换管理
function GetGlobalFrameOperManager:TFrameOperManager;
begin
  if GlobalFrameOperManager=nil then
  begin
    GlobalFrameOperManager:=TFrameOperManager.Create;
  end;
  Result:=GlobalFrameOperManager;
end;



procedure SetFrameName(AFrame:TComponent);
begin
  AFrame.Name:=AFrame.ClassName+ReplaceStr(IntToStr(Integer(Pointer(AFrame))),'-','_');
end;

procedure WebBrowserRealign;
begin
  if Assigned(OnWebBrowserRealign) then
  begin
    OnWebBrowserRealign();
  end;
end;

function FrameHistoryDebugString(FrameHistory:TFrameHistory):String;
begin
  Result:=//'ToFrame '+
        FrameHistory.ToFrame.Name;//ClassName;

//  {$IFNDEF MSWINDOWS}
//  Result:=Result+' RefCount '+IntToStr(FrameHistory.ToFrame.RefCount);
//  {$ENDIF}
//
//  Result:=Result+' '+'FromFrame ';
//  if FrameHistory.LastToFrame<>nil then
//  begin
//    Result:=Result+FrameHistory.LastToFrame.ClassName;
//    {$IFNDEF MSWINDOWS}
//    Result:=Result+' RefCount '+IntToStr(FrameHistory.LastToFrame.RefCount);
//    {$ENDIF}
//  end
//  else
//  begin
//    Result:=Result+'nil';
//  end;
end;

procedure OutputFrameHistoryLogList;
var
  I: Integer;
  ALogList:String;
begin
  ALogList:='';
  for I := GlobalFrameHistoryLogList.Count-1 downto 0 do
  begin
    ALogList:=
        IntToStr(I+1)
        +' '
        +FrameHistoryDebugString(TFrameHistoryLog(GlobalFrameHistoryLogList[I]).FrameHistory)
        +', '
        +ALogList;
  end;
  uBaseLog.OutputDebugString('HistoryLogList '+ALogList);

//    uBaseLog.OutputDebugString('-------Begin-----------------------------------');
//  for I := 0 to GlobalFrameHistoryLogList.Count-1 do
//  begin
//    uBaseLog.OutputDebugString('------- '
//        +IntToStr(I)
//        +' '
//        +FrameHistoryDebugString(TFrameHistoryLog(GlobalFrameHistoryLogList[I]).FrameHistory)
//        +' '
//        +' '
//        +' '
//        +' '
//        +' '
//        +' '
//        );
//  end;
//    uBaseLog.OutputDebugString('-------End-------------------------------------');
end;

{$IFDEF FMX}
procedure UpdateFormStatusBarColor(AForm:TForm);
var
  FWinService: IFMXWindowService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXWindowService, FWinService) then
  begin
    FWinService.ShowWindow(AForm);
  end;
end;
{$ENDIF FMX}

procedure CallFrameShowEvent(ToFrame:TFrame;AIsReturnShow:Boolean);
var
  FramePaintSetting:IFramePaintSetting;
  FrameHistoryVisibleEvent:IFrameHistroyVisibleEvent;
//  FrameChangeLanguageEvent:IFrameChangeLanguageEvent;
begin


//    //先调用翻译事件
//    if ToFrame.GetInterface(IID_IFrameChangeLanguageEvent,FrameChangeLanguageEvent) then
//    begin
//      FrameChangeLanguageEvent.ChangeLanguage(LangKind);
//    end;


    //再调用Show事件
    if ToFrame.GetInterface(IID_IFrameHistroyVisibleEvent,FrameHistoryVisibleEvent) then
    begin
      FrameHistoryVisibleEvent.DoShow;
    end;
    {$IFDEF FMX}
    if (ToFrame.TagObject<>nil) and (ToFrame.TagObject is TFrameContext) then
    begin
      TFrameContext(ToFrame.TagObject).IsReturnShow:=AIsReturnShow;
      TFrameContext(ToFrame.TagObject).DoShowEvent;
    end;
    {$ENDIF FMX}



//    {$IFDEF FMX}
//    if ToFrame.GetInterface(IID_IFramePaintSetting,FramePaintSetting) then
//    begin
//        //设置窗体背景色
//        if ToFrame.Parent is TForm then
//        begin
//          TForm(ToFrame.Parent).Fill.Color:=FramePaintSetting.GetFormColor;
//          //更新
//          UpdateFormStatusBarColor(TForm(ToFrame.Parent));
//        end;
//    end;
//    {$ENDIF FMX}


    ToFrame.BringToFront;

end;


function DoCanReturnFrame(const AFrameHistory:TFrameHistory):TFrameReturnActionType;
var
  FrameHistoryReturnEvent:IFrameHistroyReturnEvent;
begin
  Result:=TFrameReturnActionType.fratDefault;
  if (AFrameHistory.ToFrame<>nil)
    and AFrameHistory.ToFrame.GetInterface(IID_IFrameHistroyReturnEvent,FrameHistoryReturnEvent) then
  begin
    Result:=FrameHistoryReturnEvent.CanReturn;
  end;
  {$IFDEF FMX}
  if (AFrameHistory.ToFrame.TagObject<>nil)
    and (AFrameHistory.ToFrame.TagObject is TFrameContext) then
  begin
    TFrameContext(AFrameHistory.ToFrame.TagObject).DoCanReturnEvent(Result);
  end;
  {$ENDIF FMX}
end;

procedure DoDirectShowFrame(ToFrame:TFrame;ToFrameParent:TObject);
begin
  uBaseLog.OutputDebugString('DoDirectShowFrame '+ToFrame.Name);


  //设置父控件
  if (ToFrameParent<>nil) then
  begin
    if ToFrameParent is TForm then
    begin
      ToFrame.Parent:=TForm(ToFrameParent);
    end
    else
    begin
      ToFrame.Parent:=TParentControl(ToFrameParent);
    end;
  end;


  //再设置ToFrame为显示状态
  ToFrame.Visible:=True;


  if ToFrame.ClassName<>'TFrameMessageBox' then
  begin
    {$IFDEF FMX}
    //有些盖住的Frame不需要Client,不然会被其他client的控件挡住
    ToFrame.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}Client{$ELSE}alClient{$IFEND};
    {$ELSE}
    ToFrame.Align:=alClient;
    {$ENDIF}
  end;


  {$IFDEF FMX}
  if ToFrame.Opacity=0 then
  begin
    ToFrame.Opacity:=1;
  end;
  {$ENDIF}


  ToFrame.BringToFront;

end;

procedure DoFinishShowFrame(ToFrame:TFrame);
begin
//  uBaseLog.OutputDebugString('DoFinishShowFrame '+ToFrame.Name);

  //调用DoShow方法
  CallFrameShowEvent(ToFrame,False);


  //重新翻译一下
  //不能写在这里,
//  if LangKind<>lkZH then
//  begin
//    uLang.DoTranslateSubControlsLang(ToFrame,
//                                    GlobalLang,
//                                    GlobalCurLang);
//  end;


  WebBrowserRealign;

end;

procedure DoShowFrame(var ToFrame:TFrame;
                      const ToFrameClass:TFrameClass;
                      ToFrameParent:TObject;
                      const NoUse:TObject;
                      const NoUse1:TFrame;
                      const OnReturnFrame:TReturnFromFrameEvent;
                      const Owner:TComponent;
                      const IsLogInHistory:Boolean;
                      const IsUseGlobalPaintSetting:Boolean;
                      const FrameSwitchType:TFrameSwitchType;
                      const IsUsePopupStyle:Boolean;
                      const APFramePopupStyle:PFramePopupStyle
                      );
var
  AIsNew:Boolean;
  AFrameOperItem:TFrameOperItem;
var
  AFrameHistoryLog:TFrameHistoryLog;
  AFrameSettingLog:TFrameHistoryLog;
//  AFramePopupStyleSettingIntf:IFramePopupStyleSetting;
  AFrameFormMap:TFrameFormMap;
  FrameChangeLanguageEvent:IFrameChangeLanguageEvent;
begin
//    uBaseLog.OutputDebugString('DoShowFrame');


    AIsNew:=False;
    //是否需要创建Frame
    if (
           //没有创建过
           (ToFrame=nil)

//        {$IFDEF FMX}
//           //已经释放了
//        or (ToFrame<>nil) and ToFrame.Released//没有效果
//        {$ENDIF FMX}
           //已经释放过了,避免Frame被释放了,但了变量Global***Frame还引用着,导致不创建而访问报错的问题
        or (FreedFrameList.IndexOf(ToFrame)<>-1)


        )
      and (ToFrameClass<>nil) then
    begin
        AIsNew:=True;
        
        ToFrame:=ToFrameClass.Create(Owner);


        //设置控件唯一Name,避免报错
        SetFrameName(ToFrame);


        {$IFDEF FMX}
        //调用创建事件
        if (ToFrame.TagObject<>nil) and (ToFrame.TagObject is TFrameContext) then
        begin
          TFrameContext(ToFrame.TagObject).DoCreateEvent;
        end;
        {$ENDIF FMX}


        //设置切换效果前先填满窗体,设置好大小,拉伸会不会耗时
        if (ToFrameParent<>nil) then
        begin
          ToFrame.Width:=GetControlParentWidth(TParentControl(ToFrameParent));
          ToFrame.Height:=GetControlParentHeight(TParentControl(ToFrameParent));
        end;

    end;


        {$IFDEF VCL}
        if ToFrameParent=nil then
        begin
          ToFrameParent:=GlobalFrameParentFormClass.Create(Application);

//          AForm.WindowState:=wsMaximized;

          if (APFramePopupStyle<>nil) and (APFramePopupStyle.PopupWidth>0) then
          begin
            TForm(ToFrameParent).ClientWidth:=ScreenScaleSizeInt(APFramePopupStyle.PopupWidth);
            TForm(ToFrameParent).ClientHeight:=ScreenScaleSizeInt(APFramePopupStyle.PopupHeight);
          end
          else
          begin
            TForm(ToFrameParent).ClientWidth:=ScreenScaleSizeInt(ToFrame.Width);
            TForm(ToFrameParent).ClientHeight:=ScreenScaleSizeInt(ToFrame.Height);
          end;


          TForm(ToFrameParent).Position:=Forms.TPosition.poMainFormCenter;


//          TForm(ToFrameParent).Caption:='图片查看';
          TForm(ToFrameParent).Show;


          AFrameFormMap:=GlobalFrameFormMapList.Add(ToFrame,TForm(ToFrameParent));
          TForm(ToFrameParent).OnClose:=AFrameFormMap.DoFormClose;


          ToFrame.Width:=GetControlParentWidth(TParentControl(ToFrameParent));
          ToFrame.Height:=GetControlParentHeight(TParentControl(ToFrameParent));
        end;
        {$ENDIF}



    if NoUse1<>nil then
    begin
      DoHideFrame(NoUse1);
    end;

    //先调用翻译事件
    if ToFrame.GetInterface(IID_IFrameChangeLanguageEvent,FrameChangeLanguageEvent) then
    begin
      FrameChangeLanguageEvent.ChangeLanguage(LangKind);
    end;


    if
      //或者是创建在Frame中的子控件,那就不需要显示效果了
      //not (ToFrameParent is TForm)
      //or
      //第一页直接创建
      (GlobalFrameHistoryLogList.Count=0) or (FrameSwitchType=fstNone) then
    begin
        //不放在历史中的页面
        //直接创建显示

        //直接显示Frame
        DoDirectShowFrame(ToFrame,ToFrameParent);
        //完成显示
        DoFinishShowFrame(ToFrame);

    end
    else
    begin

//        if GetGlobalFrameOperManager.IsFrameShowing(ToFrame) then
//        begin
//          uBaseLog.OutputDebugString('--ShowFrame '+ToFrame.Name+' Is Showing,Exit');
//          Exit;
//        end;


        uBaseLog.OutputDebugString('--ShowFrame '+ToFrame.Name);


        if FrameSwitchType<>fstNone then
        begin
          //先隐藏
          //不然的话，如果立即显示出来，
          //就会出现窗体已经在目的地显示，
          //又突然从别的地方移过来
          ToFrame.Visible:=False;
        end;



        AFrameOperItem:=TFrameOperItem.Create;
        AFrameOperItem.Frame:=ToFrame;
        AFrameOperItem.FrameOperType:=fotShow;

        AFrameOperItem.FrameHistory.ToFrame:=ToFrame;
        AFrameOperItem.FrameHistory.ToFrameClass:=ToFrameClass;
        AFrameOperItem.FrameHistory.ToFrameParent:=ToFrameParent;
//        AFrameOperItem.FrameHistory.FromFrame:=NoUse1;//FromFrame;
        AFrameOperItem.FrameHistory.OnReturnFrame:=OnReturnFrame;

        AFrameOperItem.FrameHistory.FrameSwitchType:=FrameSwitchType;

//        AFrameOperItem.IsUseCacheImage:=Not AIsNew;




        GetGlobalFrameOperManager.FFrameOperItems.Add(AFrameOperItem);
        GetGlobalFrameOperManager.Run;
    end;





//    if GlobalIsPaintSetting and IsUseGlobalPaintSetting then
//    begin
//      //绘制背景色事件
//      ToFrame.OnPainting:=GlobalFramePaintSettingEvent.DoFramePainting;
//    end;


    //找到设置项
    AFrameSettingLog:=GlobalFrameSettingLogList.FindItemByToFrame(ToFrame);
    //使用弹出风格
    if IsUsePopupStyle then
    begin
        if AFrameSettingLog=nil then
        begin
          AFrameSettingLog:=TFrameHistoryLog.Create;
          AFrameSettingLog.FrameHistory:=CurrentFrameHistory;
          GlobalFrameSettingLogList.Add(AFrameSettingLog);
        end;
        AFrameSettingLog.FrameHistory.ToFrame:=ToFrame;
        AFrameSettingLog.FrameHistory.IsUsePopupStyle:=IsUsePopupStyle;
        AFrameSettingLog.FrameHistory.FramePopupStyle:=APFramePopupStyle^;


        {$IFDEF FMX}
        //绘制蒙板的效果
        ToFrame.OnPainting:=GlobalFramePaintSettingEvent.DoPopupStyleFramePainting;
        {$ENDIF FMX}

        //拉伸之后保持内容居中
        ToFrame.OnResize:=GlobalFramePaintSettingEvent.DoPopupStyleFrameResize;
        //点击隐藏页面的功能
        ToFrame.OnClick:=GlobalFramePaintSettingEvent.DoPopupStyleFrameClick;
        ToFrame.OnResize(ToFrame);
    end
    else
    begin
        if (AFrameSettingLog<>nil) and AFrameSettingLog.FrameHistory.IsUsePopupStyle then
        begin
            //从弹出风格恢复成原样
            GlobalFrameSettingLogList.Remove(AFrameSettingLog);
            {$IFDEF FMX}
            ToFrame.OnPainting:=nil;
            {$ENDIF FMX}
            ToFrame.OnResize:=nil;
            ToFrame.OnResize:=nil;
            ToFrame.Padding.Left:=0;
            ToFrame.Padding.Top:=0;
            ToFrame.Padding.Right:=0;
            ToFrame.Padding.Bottom:=0;
        end;
    end;




    if IsLogInHistory then
    begin
      //wn
      //不能立即设置CurrentFrame
        CurrentFrame:=ToFrame;

//        if
//          //或者是创建在Frame中的子控件,那就不需要显示效果了
//          not (ToFrameParent is TForm)
//          or
//          //第一页直接创建
//          (GlobalFrameHistoryLogList.Count=0) and (FrameSwitchType=fstNone) then
//        begin
//          CurrentFrame:=ToFrame;
//        end;


        //之前的Frame
        CurrentFrameHistory.LastToFrame:=CurrentFrameHistory.ToFrame;
        CurrentFrameHistory.LastToFrameClass:=CurrentFrameHistory.ToFrameClass;
        CurrentFrameHistory.LastToFrameParent:=CurrentFrameHistory.ToFrameParent;


        //新的Frame
        CurrentFrameHistory.ToFrame:=ToFrame;
        CurrentFrameHistory.ToFrameClass:=ToFrameClass;
        CurrentFrameHistory.ToFrameParent:=ToFrameParent;
//        CurrentFrameHistory.FromFrame:=NoUse1;//FromFrame;
        CurrentFrameHistory.OnReturnFrame:=OnReturnFrame;


        CurrentFrameHistory.FrameSwitchType:=FrameSwitchType;







//        //Show这个NewFrame的时候,如果没有Hide之前那个PriorFrame
//        //那么在Return这个NewFrame的时候,不需要重新Show那个PriorFrame
//        CurrentFrameHistory.IsHidedPriorFrame:=False;
//        if GetGlobalFrameOperManager.FFrameOperItems.Count>1 then
//        begin
//          if TFrameOperItem(GetGlobalFrameOperManager.FFrameOperItems[IGetGlobalFrameOperManager.FFrameOperItems.Count-2]).FrameOperType=fotHideAuto then
//          begin
//            CurrentFrameHistory.IsHidedPriorFrame:=True;
//          end;
//        end;






        //记录到切换历史列表
        AFrameHistoryLog:=TFrameHistoryLog.Create;
        AFrameHistoryLog.FrameHistory:=CurrentFrameHistory;
        GlobalFrameHistoryLogList.Add(AFrameHistoryLog);


        {$IFDEF FMX}
        //把CurrentFrameHistory赋给Frame.FrameContext
        if (ToFrame.TagObject<>nil) and (ToFrame.TagObject is TFrameContext) then
        begin
          TFrameContext(ToFrame.TagObject).FrameHistory:=CurrentFrameHistory;
        end;
        {$ENDIF FMX}

        OutputFrameHistoryLogList;


    end
    else
    begin
    end;




end;



procedure DoFinishHideFrame(const AFrame:TFrame);
var
  AFrameHistoryVisibleEvent:IFrameHistroyVisibleEvent;
begin
//  uBaseLog.OutputDebugString('DoFinishHideFrame '+Frame.Name);



  //调用DoHide事件
  if AFrame.GetInterface(IID_IFrameHistroyVisibleEvent,AFrameHistoryVisibleEvent) then
  begin
    AFrameHistoryVisibleEvent.DoHide;
  end;
  {$IFDEF FMX}
  if (AFrame.TagObject<>nil) and (AFrame.TagObject is TFrameContext) then
  begin
    TFrameContext(AFrame.TagObject).DoHideEvent;
  end;
  {$ENDIF FMX}

  WebBrowserRealign;



  //2020-05-06:结束显示Frame并不代表当前Frame为nil,
//  //wn
//  //不使用切换效果
//  if AFrame=CurrentFrame then
//  begin
//    CurrentFrame:=nil;
//  end;



  OutputFrameHistoryLogList;
end;

procedure DoDirectHideFrame(const AFrame:TFrame);
begin
//  uBaseLog.OutputDebugString('DoDirectHideFrame '+Frame.Name);


  //2020-05-06:HideFrame只是用来隐藏一个Frame,不影响页面跳转记录
//  //wn
//  //不使用切换效果
//  if AFrame=CurrentFrame then
//  begin
//    CurrentFrame:=nil;
//  end;


  AFrame.Visible:=False;
  {$IFDEF FMX}
  AFrame.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}None{$ELSE}alNone{$IFEND};
  {$ELSE}
  AFrame.Align:=alNone;
  {$ENDIF}

end;

procedure DoHideFrame(AFrame:TFrame;
                      const AHideFrameType:THideFrameType;
                      const AFrameSwitchType:TFrameSwitchType
                      );
var
  AFrameOperItem:TFrameOperItem;
begin
//  uBaseLog.OutputDebugString('DoHideFrame');
  if AFrame=nil then
  begin
    AFrame:=CurrentFrame;
  end;
  if (AFrame<>nil) then
  begin

      if GetGlobalFrameOperManager.IsFrameHideing(AFrame) then
      begin
        uBaseLog.OutputDebugString('--HideFrame '+AFrame.Name+' Is Hideing,Exit');
        Exit;
      end;




      //如果是仅剩的一个Frame,那么它不能被隐藏




//      if GetGlobalFrameOperManager.IsFrameShowing(AFrame) then
//      begin
//        uBaseLog.OutputDebugString('--ShowFrame '+AFrame.Name+' Is Showing,Exit');
//        Exit;
//      end;


      {$IFDEF FMX}
      //Frame开始隐藏事件
      if (AFrame.TagObject<>nil) and (AFrame.TagObject is TFrameContext) then
      begin
        TFrameContext(AFrame.TagObject).DoBeginHideEvent;
      end;
      {$ENDIF}

      uBaseLog.OutputDebugString('--HideFrame '+AFrame.Name);


//      if GetReturnFrameHistoryLog(AFrame)<>nil then
//      begin
//        //隐藏该Frame时使用什么效果,返回的时候也用什么效果
//        GetReturnFrameHistoryLog(AFrame).FrameHistory.FrameSwitchType:=AFrameSwitchType;
//      end;



      {$IFDEF FMX}
      AFrameOperItem:=TFrameOperItem.Create;
      AFrameOperItem.Frame:=AFrame;
      AFrameOperItem.FrameHistory.FrameSwitchType:=AFrameSwitchType;

      //在显示Frame之前,设置切换效果
      case AHideFrameType of
        hftNone:
        begin
          AFrameOperItem.FrameOperType:=fotHideDirect;
        end;
        hftBeforeShow:
        begin
          //隐藏新页面时隐藏当前页,从右往左隐藏
          AFrameOperItem.FrameOperType:=fotHideBeforeShow;
        end;
        hftBeforeReturn:
        begin
          //返回上一页时隐藏当前页,从左往右隐藏
          AFrameOperItem.FrameOperType:=fotHideBeforeReturn;
        end;
        hftAuto:
        begin
          AFrameOperItem.FrameOperType:=fotHideAuto;
        end;
      end;

      GetGlobalFrameOperManager.FFrameOperItems.Add(AFrameOperItem);
      GetGlobalFrameOperManager.Run;
      {$ENDIF}


//      {$IFDEF VCL}
//      if AFrame<>nil then
//      begin
//        AFrameFormMap:=GlobalFrameFormMapList.FindByFrame(AFrame);
//        if AFrameFormMap<>nil then
//        begin
//          AFrameFormMap.FForm.Close;
//        end;
//      end;
//      {$ENDIF}


      //wn这里面不能影响CurrentFrame
//      if AFrame=CurrentFrame then
//      begin
//        CurrentFrame:=nil;
//      end;


  end;

end;

procedure DoFinishReturnShowFrame(AFrameHistory:TFrameHistory;
                                  ALastFrameHistory:TFrameHistory;
                                  AIsNeedFreeFrame:Boolean);
var
  AFrameFormMap:TFrameFormMap;
begin
//  uBaseLog.OutputDebugString('DoFinishReturnShowFrame '+AFrameHistory.ToFrame.Name);


  //调用Show
  if AFrameHistory.ToFrame<>nil then CallFrameShowEvent(AFrameHistory.ToFrame,True);



  //调用返回事件
  if Assigned(ALastFrameHistory.OnReturnFrame) then
  begin
    ALastFrameHistory.OnReturnFrame(ALastFrameHistory.ToFrame);
  end;
  {$IFDEF FMX}
  if (AFrameHistory.ToFrame.TagObject<>nil)
    and (AFrameHistory.ToFrame.TagObject is TFrameContext) then
  begin
    TFrameContext(AFrameHistory.ToFrame.TagObject).DoReturnFromEvent(ALastFrameHistory.ToFrame);
  end;
  {$ENDIF FMX}


  {$IFDEF VCL}
  //关闭窗体
  if ALastFrameHistory.ToFrame<>nil then
  begin
    AFrameFormMap:=GlobalFrameFormMapList.FindByFrame(ALastFrameHistory.ToFrame);
    if (AFrameFormMap<>nil) and (AFrameFormMap.FForm<>nil) then
    begin
      AFrameFormMap.FForm.OnClose:=AFrameFormMap.DoFormCloseInReturnFrame;
      AFrameFormMap.FForm.Close;
    end;
  end;
  {$ENDIF}



  //调用完DoReturn再释放FrameHistory.ToFrame,不然会报错
  //释放
  if AIsNeedFreeFrame then
  begin
      uBaseLog.HandleException(nil,'DoFinishReturnShowFrame Return Direct Free '+ALastFrameHistory.ToFrame.ClassName);

      //去掉引用
      ALastFrameHistory.ToFrame.Parent:=nil;
      FreedFrameList.Add(ALastFrameHistory.ToFrame);

      try
        {$IFNDEF MSWINDOWS}
        ALastFrameHistory.ToFrame.DisposeOf;
        {$ELSE}
        ALastFrameHistory.ToFrame.Free;
        {$ENDIF}
      except
        on E:Exception do
        begin
          uBaseLog.HandleException(E,'DoFinishReturnShowFrame Return Direct Free '+ALastFrameHistory.ToFrame.ClassName);
        end;
      end;

  end;

  WebBrowserRealign;

end;

function GetReturnFrameHistoryLog(
                                  //当前Frame
                                  AFrame:TFrame
                                  ):TFrameHistoryLog;
var
  I:Integer;
begin
  Result:=nil;
  if AFrame<>nil then
  begin
      //找出前一个跳转记录
      for I := GlobalFrameHistoryLogList.Count-1 downto 0 do
      begin

          //当一个Frame被显示了两次,FrameHistory.FrameHistoryLog会变,
          //但是ToFrame不会变
          if AFrame=GlobalFrameHistoryLogList[I].FrameHistory.ToFrame then
          begin
              //获取到当时的FrameHistory
              Result:=GlobalFrameHistoryLogList[I];

              Break;
          end;
      end;
  end
  else
  begin
      if GlobalFrameHistoryLogList.Count>1 then
      begin
          //自动返回上一页
          Result:=GlobalFrameHistoryLogList[GlobalFrameHistoryLogList.Count-1];
      end;
  end;

end;

function GetFrameHistory(
                        //当前Frame
                        AFrame:TFrame
                        ):PFrameHistory;
begin
  Result:=nil;
  if GetReturnFrameHistoryLog(AFrame)<>nil then
  begin
    Result:=@(GetReturnFrameHistoryLog(AFrame).FrameHistory);
  end;
end;

procedure DoReturnFrame(
                        //当前Frame
                        AFromFrame:TFrame;
                        //返回前几页
                        const ReturnStep:Integer;
                        //是否需要释放
                        const IsNeedFree:Boolean;
                        //是否使用页面切换效果
                        const FrameSwitchType:TFrameSwitchType
                        );
var
  I,AStep:Integer;
  AIsCanReturn:TFrameReturnActionType;
  AIsFirstFrame:Boolean;
  AReturnLog:TFrameHistoryLog;
  ALastFrameHistory:TFrameHistory;
var
  AFrameOperItem:TFrameOperItem;
begin

  {$IFDEF FMX}
  AFromFrame:=nil;
  {$ENDIF}

  if AFromFrame<>nil then
  begin
//    uBaseLog.OutputDebugString('DoReturnFrame '+AFromFrame.ClassName);
  end
  else
  begin
//    AFromFrame:=CurrentFrame;
  end;



  for AStep := ReturnStep-1 downto 0 do
  begin

        //是否是初始页面
        AIsFirstFrame:=False;



        //这里比较容易有问题
        AReturnLog:=nil;
        if AFromFrame<>nil then
        begin
            //找出当前工FromFrame的前一个跳转记录
            for I := GlobalFrameHistoryLogList.Count-1 downto 0 do
            begin

                //当一个Frame被显示了两次,FrameHistory.FrameHistoryLog会变,
                //但是ToFrame不会变
                if AFromFrame=GlobalFrameHistoryLogList[I].FrameHistory.ToFrame then
                begin
                    //获取到当时的FrameHistory
                    ALastFrameHistory:=GlobalFrameHistoryLogList[I].FrameHistory;
                    if I>0 then
                    begin
                        //前一个页面跳转记录
                        AReturnLog:=GlobalFrameHistoryLogList[I-1];
                    end
                    else
                    begin
                        //回到初始页面
                        AIsFirstFrame:=True;
                    end;
                    Break;
                end;
            end;
        end;




        if AReturnLog=nil then//说明这个页面,没有加入到HistoryLog
        begin
            //AFromFrame为nil


            {$IFDEF FMX}
            //自动返回上一页
            if GlobalFrameHistoryLogList.Count>1 then
            begin
                //自动返回上一页
                ALastFrameHistory:=GlobalFrameHistoryLogList[GlobalFrameHistoryLogList.Count-1].FrameHistory;
                AFromFrame:=ALastFrameHistory.ToFrame;
                AReturnLog:=GlobalFrameHistoryLogList[GlobalFrameHistoryLogList.Count-2];
            end
            else
            begin
                if GlobalFrameHistoryLogList.Count=1 then
                begin
                    //获取到当时的FrameHistory
//                    ALastFrameHistory:=GlobalFrameHistoryLogList[0].FrameHistory;
                    //回到初始页面
                    AIsFirstFrame:=True;
                end;
            end;
            {$ENDIF}
            {$IFDEF VCL}
            if GlobalFrameHistoryLogList.Count>0 then
            begin
              //自动返回上一页
              ALastFrameHistory:=GlobalFrameHistoryLogList[GlobalFrameHistoryLogList.Count-1].FrameHistory;
              AFromFrame:=ALastFrameHistory.ToFrame;
            end;
            {$ENDIF}

        end;





        {$IFDEF FMX}
        //因为FrameHistory每个Frame只有一个,多次显示Frame后FrameHistory会变,造成循环切换
        //所以使用AReturnLog.FrameHistory,为那时的FrameHistory
        if (AReturnLog<>nil) and (AReturnLog.FrameHistory.ToFrame<>nil) then
        begin


            if GetGlobalFrameOperManager.IsFrameReturning(AReturnLog.FrameHistory.ToFrame) then
            begin
              uBaseLog.OutputDebugString('--ReturnFrame '+AReturnLog.FrameHistory.ToFrame.Name+' Is Showing,Exit');
              Exit;
            end;


            uBaseLog.OutputDebugString('--ReturnFrame '+AReturnLog.FrameHistory.ToFrame.Name);





            //判断这个FrameHistory是否可以跳转，但是它已经Hide了就会有问题
            AIsCanReturn:=DoCanReturnFrame(ALastFrameHistory);
//            if (AIsCanReturn=TFrameReturnActionType.fratCanNotReturn)
//              or (AIsCanReturn=TFrameReturnActionType.fratCanNotReturnAndToBack) then
//            begin
//              //有不能跳转的Frame
//              Exit;
//            end;



            //可以返回的之后才能删除
            //删除之前的记录
            for I := GlobalFrameHistoryLogList.Count-1 downto 0 do
            begin
                if AReturnLog<>GlobalFrameHistoryLogList[I] then
                begin
                  GlobalFrameHistoryLogList.Delete(I,True);
                end
                else
                begin
                  Break;
                end;
            end;



            AFrameOperItem:=TFrameOperItem.Create;
            AFrameOperItem.Frame:=AReturnLog.FrameHistory.ToFrame;
            AFrameOperItem.FrameOperType:=fotReturnShow;
            AFrameOperItem.FrameHistory:=AReturnLog.FrameHistory;
            AFrameOperItem.LastFrameHistory:=ALastFrameHistory;
            AFrameOperItem.IsNeedFreeFrame:=IsNeedFree or (AIsCanReturn=fratReturnAndFree);


            GetGlobalFrameOperManager.FFrameOperItems.Add(AFrameOperItem);
            GetGlobalFrameOperManager.Run;




            //CurrentFrameHistory恢复成上一个FrameHistory
            CurrentFrame:=AReturnLog.FrameHistory.ToFrame;//wn
            CurrentFrameHistory:=AReturnLog.FrameHistory;
            {$IFDEF FMX}
            //把CurrentFrameHistory赋给Frame.FrameContext
            if (AReturnLog.FrameHistory.ToFrame.TagObject<>nil) and (AReturnLog.FrameHistory.ToFrame.TagObject is TFrameContext) then
            begin
              TFrameContext(AReturnLog.FrameHistory.ToFrame.TagObject).FrameHistory:=CurrentFrameHistory;
            end;
            {$ENDIF FMX}
            OutputFrameHistoryLogList;



            //退回页面数大于1的，需要隐藏当前显示的页面
            if (ReturnStep>1) and (GlobalFrameHistoryLogList<>nil) and (CurrentFrame<>nil) then
            begin
                if (AStep>0) then
                begin
                  DoHideFrame(nil);
//                  DoHideFrame(CurrentFrame,
//                              hftBeforeReturn,
//                              AReturnLog.FrameHistory.FrameSwitchType);
                end;
//                ALastFrameHistory:=AReturnLog.FrameHistory;
//                AFromFrame:=ALastFrameHistory.ToFrame;
            end;




        end
        else
        begin
//            uBaseLog.OutputDebugString('ReturnFrame No Frame Can Be Return,Exit');

            if AIsFirstFrame then
            begin
                //回到初始状态
                uBaseLog.OutputDebugString('ReturnFrame Is First Frame');
                //首个Frame不返回
                //2022-09-13改为可返回,有人在单独的窗体中使用了一个Frame,这个Frame需要返回调用事件


//                //判断这个FrameHistory是否可以跳转
//                AIsCanReturn:=DoCanReturnFrame(ALastFrameHistory);
//                if AIsCanReturn then
//                begin

                    //调用返回事件
                    if Assigned(GlobalFrameHistoryLogList[0].FrameHistory.OnReturnFrame) then
                    begin
                      GlobalFrameHistoryLogList[0].FrameHistory.OnReturnFrame(nil);
                    end;

//                end;

              GlobalFrameHistoryLogList.Clear(True);

              CurrentFrame:=nil;


            end;



        end;
        {$ENDIF FMX}



        {$IFDEF VCL}
        if GlobalFrameHistoryLogList.Count=1 then
        begin
          GlobalFrameHistoryLogList.Clear(True);
        end;
        
        AFrameOperItem:=TFrameOperItem.Create;
        if AReturnLog<>nil then AFrameOperItem.Frame:=AReturnLog.FrameHistory.ToFrame;
        AFrameOperItem.FrameOperType:=fotReturnShow;
        if AReturnLog<>nil then AFrameOperItem.FrameHistory:=AReturnLog.FrameHistory;
        AFrameOperItem.LastFrameHistory:=ALastFrameHistory;
        AFrameOperItem.IsNeedFreeFrame:=IsNeedFree;


        GetGlobalFrameOperManager.FFrameOperItems.Add(AFrameOperItem);
        GetGlobalFrameOperManager.Run;

        {$ENDIF VCL}


  end;

end;



{ TFramePaintSettingEvent }

//procedure TFramePaintSettingEvent.DoFramePainting(Sender: TObject; Canvas: TCanvas;const ARect: TRectF);
//var
//  AFrame:TFrame;
//  AFillColor:TDelphiColor;
//  FramePaintSetting:IFramePaintSetting;
//begin
//  if (Sender<>nil) and (Sender is TFrame) then
//  begin
//      AFrame:=TFrame(Sender);
//
//      //使用全局背景色
//      AFillColor:=GlobalFrameFillColor;
//
//      if AFrame.GetInterface(IID_IFramePaintSetting,FramePaintSetting) then
//      begin
//        //使用自己的背景色
//        AFillColor:=FramePaintSetting.GetFillColor;
//      end;
//
//
//      //不是透明色,那么绘制
//      {$IFDEF FMX}
//      if AFillColor<>NullColor then
//      begin
//        Canvas.Fill.Color:=AFillColor;
//        Canvas.Fill.Kind:=TBrushKind.Solid;
//        Canvas.FillRect(ARect, 0, 0, AllCorners, 1);
//      end;
//      {$ENDIF}
//
//  end;
//end;

procedure TFramePaintSettingEvent.DoPopupStyleFramePainting(Sender: TObject;
  Canvas: TCanvas; const ARect: TRectF);
begin
  {$IFDEF FMX}
  Canvas.Fill.Color:=GlobalPopupStyleFrameFillColor;
  Canvas.Fill.Kind:=TBrushKind.Solid;
  Canvas.FillRect(ARect, 0, 0, AllCorners, 1);
  {$ENDIF FMX}
end;

procedure TFramePaintSettingEvent.DoPopupStyleFrameResize(Sender: TObject);
var
  AFramePopupWidth:Double;
  AFramePopupHeight:Double;
  AFrameSettingLog:TFrameHistoryLog;
begin
  if Sender is TFrame then
  begin
    AFrameSettingLog:=GlobalFrameSettingLogList.FindItemByToFrame(TFrame(Sender));

    if (AFrameSettingLog<>nil) and AFrameSettingLog.FrameHistory.IsUsePopupStyle then
    begin
        AFramePopupWidth:=AFrameSettingLog.FrameHistory.FramePopupStyle.PopupWidth;
        AFramePopupHeight:=AFrameSettingLog.FrameHistory.FramePopupStyle.PopupHeight;
        if AFramePopupWidth=0 then
        begin
          AFramePopupWidth:=GlobalPopupStyleFrameWidth;
        end;
        TFrame(Sender).Padding.Left:=ControlSize((TFrame(Sender).Width-AFramePopupWidth)/2);
        TFrame(Sender).Padding.Right:=ControlSize((TFrame(Sender).Width-AFramePopupWidth)/2);

        TFrame(Sender).Padding.Top:=ControlSize((TFrame(Sender).Height-AFramePopupHeight)/2);
        TFrame(Sender).Padding.Bottom:=ControlSize((TFrame(Sender).Height-AFramePopupHeight)/2);
    end;

  end;
end;

procedure TFramePaintSettingEvent.DoPopupStyleFrameClick(Sender: TObject);
var
  AFrameSettingLog:TFrameHistoryLog;
begin
  if Sender is TFrame then
  begin
    AFrameSettingLog:=GlobalFrameSettingLogList.FindItemByToFrame(TFrame(Sender));

    if (AFrameSettingLog<>nil) and AFrameSettingLog.FrameHistory.IsUsePopupStyle then
    begin
      case AFrameSettingLog.FrameHistory.FramePopupStyle.ClickSpaceType of
        cstNone: ;
        cstHide:
        begin
          TFrame(Sender).Visible:=False;
        end;
        cstReturnFrame:
        begin
          //按空白区域则返回上一页
          if GetFrameHistory(TFrame(Sender))<>nil then GetFrameHistory(TFrame(Sender)).OnReturnFrame:=nil;

          DoHideFrame(TFrame(Sender),THideFrameType.hftBeforeReturn,TFrameSwitchType.fstNone);
          DoReturnFrame(TFrame(Sender));

        end;
      end;
    end;

  end;

end;

{ TFrameContext }

constructor TFrameContext.Create(AOwner: TComponent);
begin
  inherited;

  if AOwner is TFrame then
  begin
    FFrame:=TFrame(AOwner);
    {$IFDEF FMX}
    FFrame.TagObject:=Self;
    {$ENDIF}
    {$IFDEF VCL}
    FFrame.Tag:=Integer(Self);
    {$ENDIF}
  end;

end;

destructor TFrameContext.Destroy;
begin
  if FFrame<>nil then
  begin
    {$IFDEF FMX}
    FFrame.TagObject:=nil;
    {$ENDIF}
    {$IFDEF VCL}
    FFrame.Tag:=Integer(Self);
    {$ENDIF}
  end;

  DoDestroyEvent;

  inherited;
end;

procedure TFrameContext.DoCanReturnEvent(var AIsCanReturn: TFrameReturnActionType);
begin
  if Assigned(FOnCanReturn) then
  begin
    FOnCanReturn(Self,AIsCanReturn);
  end;
end;

procedure TFrameContext.DoCreateEvent;
begin
  if Assigned(FOnCreate) then
  begin
    FOnCreate(Self);
  end;
end;

procedure TFrameContext.DoDestroyEvent;
begin
  if Assigned(FOnDestroy) then
  begin
    FOnDestroy(Self);
  end;
end;

procedure TFrameContext.DoHideEvent;
begin
  if Assigned(FOnHide) then
  begin
    FOnHide(Self);
  end;
end;

procedure TFrameContext.DoBeginHideEvent;
begin
  if Assigned(FOnBeginHide) then
  begin
    FOnBeginHide(Self);
  end;
end;

procedure TFrameContext.DoReturnFromEvent(AFromFrame:TFrame);
begin
  if Assigned(FOnReturnFrom) then
  begin
    FOnReturnFrom(Self,AFromFrame);
  end;
end;

procedure TFrameContext.DoShowEvent;
begin
  if not IsReturnShow then
  begin
    if Assigned(FOnLoad) then
    begin
      FOnLoad(Self);
    end;
  end;
  if Assigned(FOnShow) then
  begin
    FOnShow(Self);
  end;
  if Assigned(FOnShowEx) then
  begin
    FOnShowEx(Self,IsReturnShow);
  end;

end;

procedure TFrameContext.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation=opRemove) then
  begin
    if (AComponent=Self.FFrame) then
    begin
      {$IFDEF FMX}
      FFrame.TagObject:=nil;
      {$ENDIF}
      {$IFDEF VCL}
      FFrame.Tag:=0;
      {$ENDIF}
      FFrame:=nil;
    end;
  end;

end;




{ TFrameHistoryLogList }

function TFrameHistoryLogList.FindItemByToFrame(AToFrame: TFrame): TFrameHistoryLog;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FrameHistory.ToFrame=AToFrame then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TFrameHistoryLogList.GetItem(Index: Integer): TFrameHistoryLog;
begin
  Result:=TFrameHistoryLog(Inherited Items[Index]);
end;



{ TFrameOperManager }

procedure TFrameOperManager.DoExecuteFrameOper(CurrentItem: TFrameOperItem);
begin
  if CurrentItem=nil then Exit;

  case CurrentItem.FrameOperType of
    fotHideDirect,fotHideBeforeShow,fotHideBeforeReturn,fotHideAuto:
    begin

        if (CurrentItem.FrameHistory.FrameSwitchType=fstNone)
          or (CurrentItem.FrameOperType=fotHideDirect)
          or (CurrentItem.FrameOperType=fotHideAuto) then
        begin

            //直接隐藏Frame
            DoDirectHideFrame(CurrentItem.Frame);
            DoFinishHideFrame(CurrentItem.Frame);

            EndCurrentHideFrameItem;

        end
        else
        begin

            case CurrentItem.FrameOperType of
              fotHideBeforeShow:
              begin
                DoAnimateHideFrame(CurrentItem,CurrentItem.Frame,hftBeforeShow);
              end;
              fotHideBeforeReturn:
              begin
                DoAnimateHideFrame(CurrentItem,CurrentItem.Frame,hftBeforeReturn);
              end;
            end;

        end;


    end;
    fotShow:
    begin
//        CurrentFrame:=CurrentItem.Frame;//wn

        if CurrentItem.FrameHistory.FrameSwitchType=fstNone then
        begin
            //直接显示Frame
            DoDirectShowFrame(CurrentItem.Frame,CurrentItem.FrameHistory.ToFrameParent);
            //完成显示
            DoFinishShowFrame(CurrentItem.FrameHistory.ToFrame);

            EndCurrentShowFrameItem;
        end
        else
        begin
            //动画显示Frame
            DoAnimateShowFrame(CurrentItem,
                              CurrentItem.Frame,
                              CurrentItem.FrameHistory.ToFrameParent);

        end;


    end;
    fotReturnShow:
    begin
//        CurrentFrame:=CurrentItem.Frame;//wn

        if CurrentItem.LastFrameHistory.FrameSwitchType=fstNone then
        begin
            //直接显示Frame
            DoDirectShowFrame(CurrentItem.Frame,CurrentItem.FrameHistory.ToFrameParent);
            DoFinishReturnShowFrame(CurrentItem.FrameHistory,CurrentItem.LastFrameHistory,CurrentItem.IsNeedFreeFrame);


            EndCurrentShowFrameItem;
        end
        else
        begin

            DoAnimateReturnShowFrame(CurrentItem,CurrentItem.Frame,CurrentItem.FrameHistory.ToFrameParent);

        end;

    end;
  end;

end;

constructor TFrameOperManager.Create;
begin

  //设置
  FSetFrameTopMostTimer:=TTimer.Create(nil);
  FSetFrameTopMostTimer.OnTimer:=DoSetFrameTopMostTimer;
  FSetFrameTopMostTimer.Interval:=100;
  FSetFrameTopMostTimer.Enabled:=True;




  //页面切换效果
  FrameSwitchEffectAnimator:=TControlEffectAnimator.Create(nil);
  //页面切换效果的速度
  FrameSwitchEffectAnimator.Speed:=1.2;//3;//2;//20;//2;//2;//
  //页面切换效果的移动次数
  FrameSwitchEffectAnimator.EndTimesCount:=20;
  //页面切换效果的类型
//  FrameSwitchEffectAnimator.TweenType:=TTweenType.Quadratic;
//  FrameSwitchEffectAnimator.TweenType:=TTweenType.Quartic;
  FrameSwitchEffectAnimator.TweenType:=TTweenType.Quintic;
  FrameSwitchEffectAnimator.EaseType:=TEaseType.easeOut;

  //隐藏
  HideFrameEffect:=TControlEffectItem(FrameSwitchEffectAnimator.ControlEffectItems.Add);
  HideFrameEffect.Caption:='HideFrame';
  HideFrameEffect.MoveHorzEffect.From:=0;
  HideFrameEffect.MoveHorzEffect.Dest:=-320;
  HideFrameEffect.MoveVertEffect.From:=0;
  HideFrameEffect.MoveVertEffect.Dest:=-480;
  HideFrameEffect.MoveVertEffect.IsEnabled:=False;
  HideFrameEffect.AlphaEffect.From:=255;
  HideFrameEffect.AlphaEffect.Dest:=0;
  HideFrameEffect.AlphaEffect.IsEnabled:=False;

  //显示
  ShowFrameEffect:=TControlEffectItem(FrameSwitchEffectAnimator.ControlEffectItems.Add);
  ShowFrameEffect.Caption:='ShowFrame';
  ShowFrameEffect.MoveHorzEffect.From:=320;
  ShowFrameEffect.MoveHorzEffect.Dest:=0;
  ShowFrameEffect.MoveVertEffect.From:=480;
  ShowFrameEffect.MoveVertEffect.Dest:=0;
  ShowFrameEffect.MoveVertEffect.IsEnabled:=False;
  ShowFrameEffect.AlphaEffect.From:=0;
  ShowFrameEffect.AlphaEffect.Dest:=255;
  ShowFrameEffect.AlphaEffect.IsEnabled:=False;

  //返回隐藏
  ReturnHideFrameEffect:=TControlEffectItem(FrameSwitchEffectAnimator.ControlEffectItems.Add);
  ReturnHideFrameEffect.Caption:='ReturnHideFrame';
  ReturnHideFrameEffect.MoveHorzEffect.From:=0;
  ReturnHideFrameEffect.MoveHorzEffect.Dest:=320;
  ReturnHideFrameEffect.MoveVertEffect.From:=0;
  ReturnHideFrameEffect.MoveVertEffect.Dest:=480;
  ReturnHideFrameEffect.MoveVertEffect.IsEnabled:=False;
  ReturnHideFrameEffect.AlphaEffect.From:=255;
  ReturnHideFrameEffect.AlphaEffect.Dest:=0;
  ReturnHideFrameEffect.AlphaEffect.IsEnabled:=False;

  //返回显示
  ReturnShowFrameEffect:=TControlEffectItem(FrameSwitchEffectAnimator.ControlEffectItems.Add);
  ReturnShowFrameEffect.Caption:='ReturnShowFrame';
  ReturnShowFrameEffect.MoveHorzEffect.From:=-320;
  ReturnShowFrameEffect.MoveHorzEffect.Dest:=0;
  ReturnShowFrameEffect.MoveVertEffect.From:=-480;
  ReturnShowFrameEffect.MoveVertEffect.Dest:=0;
  ReturnShowFrameEffect.MoveVertEffect.IsEnabled:=False;
  ReturnShowFrameEffect.AlphaEffect.From:=0;
  ReturnShowFrameEffect.AlphaEffect.Dest:=255;
  ReturnShowFrameEffect.AlphaEffect.IsEnabled:=False;



  HideFrameEffect.OnAnimate:=Self.DoHideFrameAnimate;
  HideFrameEffect.OnAnimateBegin:=Self.DoHideFrameAnimateBegin;
  HideFrameEffect.OnAnimateEnd:=Self.DoHideFrameAnimateEnd;

  ReturnHideFrameEffect.OnAnimate:=Self.DoHideFrameAnimate;
  ReturnHideFrameEffect.OnAnimateBegin:=Self.DoHideFrameAnimateBegin;
  ReturnHideFrameEffect.OnAnimateEnd:=Self.DoHideFrameAnimateEnd;



  ShowFrameEffect.OnAnimate:=Self.DoShowFrameAnimate;
  ShowFrameEffect.OnAnimateBegin:=Self.DoShowFrameAnimateBegin;
  ShowFrameEffect.OnAnimateEnd:=Self.DoShowFrameAnimateEnd;

  ReturnShowFrameEffect.OnAnimate:=Self.DoShowFrameAnimate;
  ReturnShowFrameEffect.OnAnimateBegin:=Self.DoShowFrameAnimateBegin;
  ReturnShowFrameEffect.OnAnimateEnd:=Self.DoShowFrameAnimateEnd;




  FFrameOperTimer:=TTimer.Create(nil);
  FFrameOperTimer.Interval:=200;//100;//1000;
  FFrameOperTimer.OnTimer:=Self.DoFrameOperTimer;
  FFrameOperTimer.Enabled:=False;



  FFrameOperItems:=TBaseList.Create;


//  //加速
//  HideFrameImage:=TSkinFMXImage.Create(nil);
//  HideFrameImage.SkinControlType;
//  HideFrameImage.SelfOwnMaterial.IsTransparent:=False;
//  HideFrameImage.SelfOwnMaterial.BackColor.IsFill:=True;
//  HideFrameImage.SelfOwnMaterial.BackColor.FillColor.Color:=GreenColor;
//  HideFrameImage.Caption:='Hide';
//  HideFrameImage.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize:=20;
//  HideFrameImage.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=WhiteColor;
//  HideFrameImage.Opacity:=0.5;
//
//
//  ShowFrameImage:=TSkinFMXImage.Create(nil);
//  ShowFrameImage.SkinControlType;
//  ShowFrameImage.SelfOwnMaterial.IsTransparent:=False;
//  ShowFrameImage.SelfOwnMaterial.BackColor.IsFill:=True;
//  ShowFrameImage.SelfOwnMaterial.BackColor.FillColor.Color:=RedColor;
//  ShowFrameImage.Caption:='Show';
//  ShowFrameImage.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize:=20;
//  ShowFrameImage.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=WhiteColor;
//  ShowFrameImage.Opacity:=0.5;

end;

destructor TFrameOperManager.Destroy;
begin
  FreeAndNil(FrameSwitchEffectAnimator);


  FreeAndNil(FFrameOperTimer);
  FreeAndNil(FFrameOperItems);


  FreeAndNil(FSetFrameTopMostTimer);

//  FreeAndNil(HideFrameImage);
//  FreeAndNil(ShowFrameImage);

  inherited;
end;

procedure TFrameOperManager.DoFrameOperTimer(Sender: TObject);
begin
  Self.FFrameOperTimer.Enabled:=False;


  if (FCurrentHideFrameItem=nil) and (FCurrentShowFrameItem=nil) then
  begin

      //提取隐藏Frame的操作项
      if (FFrameOperItems.Count>0) then
      begin

          case TFrameOperItem(FFrameOperItems[0]).FrameOperType of
             fotHideDirect,fotHideBeforeShow,fotHideBeforeReturn,fotHideAuto:
             begin
                FCurrentHideFrameItem:=TFrameOperItem(FFrameOperItems[0]);
             end;
             fotShow,fotReturnShow:
             begin
                FCurrentShowFrameItem:=TFrameOperItem(FFrameOperItems[0]);
             end;
          end;
          FFrameOperItems.Delete(0,False);

      end;




      //提取显示Frame的操作项
      if (FFrameOperItems.Count>0) then
      begin

          case TFrameOperItem(FFrameOperItems[0]).FrameOperType of
             fotHideDirect,fotHideBeforeShow,fotHideBeforeReturn,fotHideAuto:
             begin
                if FCurrentHideFrameItem=nil then
                begin
                    FCurrentHideFrameItem:=TFrameOperItem(FFrameOperItems[0]);
                    FFrameOperItems.Delete(0,False);
                end;
             end;
             fotShow,fotReturnShow:
             begin
                if FCurrentShowFrameItem=nil then
                begin

                    FCurrentShowFrameItem:=TFrameOperItem(FFrameOperItems[0]);


                    FFrameOperItems.Delete(0,False);
                end;
             end;
          end;

      end;





      //判断隐藏Frame的操作方向,是为了显示还是为了隐藏
      if    (FCurrentHideFrameItem<>nil)
        and (FCurrentHideFrameItem.FrameOperType=fotHideAuto) then
      begin

          if FCurrentShowFrameItem=nil then
          begin
              //直接隐藏,还是说它原来怎么显示,现在怎么隐藏
              FCurrentHideFrameItem.FrameOperType:=fotHideDirect;

              //判断该Frame是不是第一个Frame,如果隐藏了就什么都没有了
              //wn
                if (GlobalFrameHistoryLogList.Count=1) and (GlobalFrameHistoryLogList[0].FrameHistory.ToFrame=FCurrentHideFrameItem.Frame) then
                begin
                    //获取到当时的FrameHistory
//                    ALastFrameHistory:=GlobalFrameHistoryLogList[0].FrameHistory;
//                    //回到初始页面
//                    AIsFirstFrame:=True;
                   FCurrentHideFrameItem:=nil;
                   Exit;
                end;


          end
          else
          begin


              //根据显示的动画来判断HideFrame往哪个方向
              case FCurrentShowFrameItem.FrameOperType of
                 fotShow:
                 begin
                   FCurrentHideFrameItem.FrameOperType:=fotHideBeforeShow;
                 end;
                 fotReturnShow:
                 begin
                    FCurrentHideFrameItem.FrameOperType:=fotHideBeforeReturn;

                    //看看它目前有没有显示,如果有,是什么效果显示的,就用什么效果隐藏
                    if (FCurrentShowFrameItem.LastFrameHistory.ToFrame=FCurrentHideFrameItem.Frame) then
                    begin
                      FCurrentHideFrameItem.FrameHistory.FrameSwitchType:=FCurrentShowFrameItem.LastFrameHistory.FrameSwitchType;
                    end
                    else
                    begin
                    end;


                 end;
              end;



          end;



      end;


//      if (FCurrentHideFrameItem<>nil)
//        and (FCurrentShowFrameItem<>nil)
//        and (FCurrentShowFrameItem.FrameOperType=fotShow)
//        and (FCurrentHideFrameItem.Frame=FCurrentShowFrameItem.FrameHistory.ToFrame) then
//      begin
//        FCurrentHideFrameItem:=nil;
//        FCurrentShowFrameItem:=nil;
//        Exit;
//      end;




      //执行操作
      if FCurrentHideFrameItem<>nil then
      begin
        DoExecuteFrameOper(FCurrentHideFrameItem);
      end;
      if FCurrentShowFrameItem<>nil then
      begin
        DoExecuteFrameOper(FCurrentShowFrameItem);
      end;


  end;

end;

procedure TFrameOperManager.EndCurrentShowFrameItem;
begin
  FreeAndNil(FCurrentShowFrameItem);
  FFrameOperTimer.Enabled:=True;
end;

function TFrameOperManager.IsFrameHideing(AFrame: TFrame): Boolean;
var
  I: Integer;
begin
  Result:=False;

  for I := 0 to Self.FFrameOperItems.Count-1 do
  begin
    if    (
          (TFrameOperItem(Self.FFrameOperItems[I]).FrameOperType=fotHideBeforeShow)
          or
          (TFrameOperItem(Self.FFrameOperItems[I]).FrameOperType=fotHideBeforeReturn)
          )
      and (TFrameOperItem(Self.FFrameOperItems[I]).Frame=AFrame) then
    begin
      Result:=True;
      Exit;
    end;
  end;


  if    (FCurrentHideFrameItem<>nil)
    and (
        (FCurrentHideFrameItem.FrameOperType=fotHideBeforeShow)
        or
        (FCurrentHideFrameItem.FrameOperType=fotHideBeforeReturn)
        )
    and (FCurrentHideFrameItem.Frame=AFrame) then
  begin
    Result:=True;
    Exit;
  end;

end;

function TFrameOperManager.IsFrameReturning(AFrame: TFrame): Boolean;
var
  I: Integer;
begin
  Result:=False;

  for I := 0 to Self.FFrameOperItems.Count-1 do
  begin
    if    (TFrameOperItem(Self.FFrameOperItems[I]).FrameOperType=fotReturnShow)
      and (TFrameOperItem(Self.FFrameOperItems[I]).Frame=AFrame) then
    begin
      Result:=True;
      Exit;
    end;
  end;


  if    (FCurrentShowFrameItem<>nil)
    and (FCurrentShowFrameItem.FrameOperType=fotReturnShow)
    and (FCurrentShowFrameItem.Frame=AFrame) then
  begin
    Result:=True;
    Exit;
  end;

end;

function TFrameOperManager.IsFrameShowing(AFrame: TFrame): Boolean;
var
  I: Integer;
begin
  Result:=False;

  for I := 0 to Self.FFrameOperItems.Count-1 do
  begin
    if    (TFrameOperItem(Self.FFrameOperItems[I]).FrameOperType=fotShow)
      and (TFrameOperItem(Self.FFrameOperItems[I]).Frame=AFrame) then
    begin
      Result:=True;
      Exit;
    end;
  end;


  if    (FCurrentShowFrameItem<>nil)
    and (FCurrentShowFrameItem.FrameOperType=fotShow)
    and (FCurrentShowFrameItem.Frame=AFrame) then
  begin
    Result:=True;
    Exit;
  end;

end;

//procedure TFrameOperManager.MakeScreenshot(AFrame: TFrame;AImage: TSkinFMXImage);
//var
//  AScreenshot:TBitmap;
//begin
//  AScreenshot:=AFrame.MakeScreenshot;
//  AImage.Prop.Picture.Assign(AScreenshot);
//  FreeAndNil(AScreenshot);
//end;

procedure TFrameOperManager.EndCurrentHideFrameItem;
begin
  FreeAndNil(FCurrentHideFrameItem);
  FFrameOperTimer.Enabled:=True;
end;

procedure TFrameOperManager.Run;
begin
  FFrameOperTimer.Enabled:=True;
end;

procedure TFrameOperManager.DoSetFrameTopMostTimer(Sender: TObject);
var
  I: Integer;
  AFrame:TFrame;
begin
  if (GlobalTopMostFrameList<>nil)
    and (GlobalTopMostFrameList.Count>0) then
  begin

    AFrame:=TFrame(GlobalTopMostFrameList[GlobalTopMostFrameList.Count-1]);



    if AFrame.ClassName<>'TFrameHint' then//HintFrame不是全屏的
    begin
      AFrame.SetBounds(0,0,GetControlParentWidth(AFrame.Parent),GetControlParentHeight(AFrame.Parent));
    end;
    if not AFrame.Visible then
    begin
      AFrame.Visible:=True;
      AFrame.BringToFront;
      AFrame.RePaint;
    end;




    {$IFDEF FMX}
    if AFrame.Visible and IsSameDouble(AFrame.Opacity,1) then
    begin
      AFrame.Visible:=True;
      AFrame.BringToFront;
      AFrame.RePaint;
    end;
    {$ENDIF}


    for I := 0 to GlobalTopMostFrameList.Count-2 do
    begin
      AFrame:=TFrame(GlobalTopMostFrameList[I]);
      AFrame.SendToBack;
      //要隐藏,如果Frame上面有WebBrowser的话,光SendToBack不会隐藏WebBrowser导致挡住一切
      AFrame.Visible:=False;
    end;


  end;
  
end;

procedure TFrameOperManager.DoShowFrameAnimate(Sender: TObject);
begin
end;

procedure TFrameOperManager.DoShowFrameAnimateBegin(Sender: TObject);
begin
  TControlEffectItem(Sender).Control.Visible:=True;
  TControlEffectItem(Sender).Control.BringToFront;
end;

procedure TFrameOperManager.DoShowFrameAnimateEnd(Sender: TObject);
begin
  //效果结束,页面填满
//  {$IFDEF FMX}
//  TControlEffectItem(Sender).Control.Opacity:=1;
//  {$ENDIF}

//  if Not FCurrentShowFrameItem.IsUseCacheImage then
//  begin
//
//  end
//  else
//  begin
//    //隐藏Image
//    TControlEffectItem(Sender).Control.Visible:=False;
//    TControlEffectItem(Sender).Control.Parent:=nil;
//  end;


  if Sender<>nil then
  begin
    TControlEffectItem(Sender).Control:=nil;
  end;

  if FCurrentShowFrameItem=nil then
  begin
    Exit;
  end;


//  if FCurrentShowFrameItem.FrameHistory.FrameSwitchType=fstNone then
//  begin
//    //已经手动调用过DoShowFrameAnimateEnd
//    Exit;
//  end;

  if (Sender<>nil)
        and not TControlEffectItem(Sender).MoveVertEffect.IsEnabled
        and not TControlEffectItem(Sender).MoveHorzEffect.IsEnabled
        and not TControlEffectItem(Sender).AlphaEffect.IsEnabled then
  begin
    //没有效果,就表示这个DoShowFrameAnimateEnd已经执行过了
    Exit;
  end;



  //ShowFrame
  DoDirectShowFrame(FCurrentShowFrameItem.FrameHistory.ToFrame,
                    FCurrentShowFrameItem.FrameHistory.ToFrameParent);


  if FCurrentShowFrameItem.FrameOperType=fotShow then
  begin
      //完成显示
      DoFinishShowFrame(FCurrentShowFrameItem.FrameHistory.ToFrame);

  end
  else
  begin
      //ReturnFrame
      //完成返回显示
      DoFinishReturnShowFrame(FCurrentShowFrameItem.FrameHistory,
                              FCurrentShowFrameItem.LastFrameHistory,
                              FCurrentShowFrameItem.IsNeedFreeFrame);
  end;



  //动画结束之后再设置CurrentFrame
  //CurrentFrame:=FCurrentShowFrameItem.FrameHistory.ToFrame;//wn

  EndCurrentShowFrameItem;

end;

procedure TFrameOperManager.DoHideFrameAnimate(Sender: TObject);
begin
end;

procedure TFrameOperManager.DoHideFrameAnimateBegin(Sender: TObject);
begin
  TControlEffectItem(Sender).Control.Visible:=True;
  TControlEffectItem(Sender).Control.BringToFront;
end;

procedure TFrameOperManager.DoHideFrameAnimateEnd(Sender: TObject);
begin
  //效果结束,页面隐藏
  TControlEffectItem(Sender).Control.Visible:=False;
  {$IFDEF FMX}
  TControlEffectItem(Sender).Control.Align:=TAlignLayout.None;
  {$ELSE}
  TControlEffectItem(Sender).Control.Align:=TAlignLayout.alNone;
  {$ENDIF}

  TControlEffectItem(Sender).Control:=nil;



  //再隐藏
  DoDirectHideFrame(FCurrentHideFrameItem.Frame);
  DoFinishHideFrame(FCurrentHideFrameItem.Frame);


  //释放
  if FCurrentHideFrameItem.IsNeedFreeFrame then
  begin
//      uBaseLog.OutputDebugString('THideFrameSwitchAnimateEvent Free '
//                                  +FCurrentHideFrameItem.Frame.Name
//                                  );

      //去掉引用
      FCurrentHideFrameItem.Frame.Parent:=nil;
      FreedFrameList.Add(FCurrentHideFrameItem.Frame);

      try


        {$IFNDEF MSWINDOWS}
        FCurrentHideFrameItem.Frame.DisposeOf;
        {$ELSE}
        //释放页面
        FCurrentHideFrameItem.Frame.Free;
        {$ENDIF}
      except

      end;

  end;


  EndCurrentHideFrameItem;
end;

procedure TFrameOperManager.DoAnimateShowFrame(AFrameOperItem:TFrameOperItem;ToFrame:TFrame;ToFrameParent:TObject);
begin

//  uBaseLog.OutputDebugString('DoAnimateShowFrame '+ToFrame.Name);


//  if Not AFrameOperItem.IsUseCacheImage then
//  begin




     


      //设置切换效果前先填满窗体,设置好大小
      if (ToFrameParent<>nil) then
      begin
        ToFrame.Width:=GetControlParentWidth(TParentControl(ToFrameParent));
        ToFrame.Height:=GetControlParentHeight(TParentControl(ToFrameParent));
      end;


    //        //隐藏来源Frame
    //        if FromFrame<>nil then
    //        begin
    //          HideFrame(FromFrame,hftBeforeShow,fstDefault);
    //        end;

      Self.ShowFrameEffect.Control:=ToFrame;


//  end
//  else
//  begin
//
//
//
//      if (ToFrameParent<>nil) then
//      begin
//        ShowFrameImage.Width:=GetControlParentWidth(TFmxObject(ToFrameParent));
//        ShowFrameImage.Height:=GetControlParentHeight(TFmxObject(ToFrameParent));
//      end;
//      ShowFrameImage.Position.X:=ToFrame.Width;
//      ShowFrameImage.Parent:=TFmxObject(ToFrameParent);
//      Self.ShowFrameEffect.Control:=Self.ShowFrameImage;
//
//
//      MakeScreenshot(ToFrame,ShowFrameImage);
//
//  end;


  case AFrameOperItem.FrameHistory.FrameSwitchType of
    fstNone:
    begin
        Self.ShowFrameEffect.MoveVertEffect.IsEnabled:=False;
        Self.ShowFrameEffect.MoveHorzEffect.IsEnabled:=False;
        Self.ShowFrameEffect.AlphaEffect.IsEnabled:=False;

        DoShowFrameAnimateEnd(nil);
        Exit;

    end;
    fstDefault,fstDefaultAndAlpha:
    begin

        //设置父控件
        if (ToFrameParent<>nil) then
        begin
          //ToFrame.Parent:=TParentControl(ToFrameParent);

          if ToFrameParent is TForm then
          begin
            ToFrame.Parent:=TForm(ToFrameParent);
          end
          else
          begin
            ToFrame.Parent:=TParentControl(ToFrameParent);
          end;


        end;

        //先初始位置
        {$IFDEF FMX}
  //      ToFrame.Position.X:=ToFrame.Width;
        ToFrame.Position.X:=GetControlParentWidth(TFmxObject(AFrameOperItem.FrameHistory.ToFrameParent));
        ToFrame.Position.Y:=0;
        {$ELSE}
        ToFrame.Left:=ToFrame.Width;
        ToFrame.Top:=0;
        {$ENDIF}

        Self.ShowFrameEffect.MoveHorzEffect.From:=GetControlLeft(ToFrame);
        Self.ShowFrameEffect.MoveHorzEffect.Dest:=0;
        Self.ShowFrameEffect.MoveHorzEffect.IsEnabled:=True;

        Self.ShowFrameEffect.MoveVertEffect.IsEnabled:=False;

        Self.ShowFrameEffect.AlphaEffect.From:=0;
        Self.ShowFrameEffect.AlphaEffect.Dest:=255;
        Self.ShowFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstDefaultAndAlpha);
        Self.FrameSwitchEffectAnimator.Run;


    end;
    fstMoveVert,fstMoveVertAndAlpha:
    begin

        //设置父控件
        if (ToFrameParent<>nil) then
        begin
          //ToFrame.Parent:=TParentControl(ToFrameParent);
          if ToFrameParent is TForm then
          begin
            ToFrame.Parent:=TForm(ToFrameParent);
          end
          else
          begin
            ToFrame.Parent:=TParentControl(ToFrameParent);
          end;
        end;

        //先初始位置
        {$IFDEF FMX}
        ToFrame.Position.X:=0;
  //      ToFrame.Position.Y:=ToFrame.Height;
        ToFrame.Position.Y:=GetControlParentHeight(TFmxObject(AFrameOperItem.FrameHistory.ToFrameParent));
        {$ELSE}
        ToFrame.Left:=0;
        ToFrame.Top:=ToFrame.Height;
        {$ENDIF}

  //      Self.ShowFrameEffect.MoveVertEffect.From:=ToFrame.Height;
        Self.ShowFrameEffect.MoveVertEffect.From:=GetControlLeft(ToFrame);
        Self.ShowFrameEffect.MoveVertEffect.Dest:=0;
        Self.ShowFrameEffect.MoveVertEffect.IsEnabled:=True;

        Self.ShowFrameEffect.MoveHorzEffect.IsEnabled:=False;

        Self.ShowFrameEffect.AlphaEffect.From:=0;
        Self.ShowFrameEffect.AlphaEffect.Dest:=255;
        Self.ShowFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstMoveVertAndAlpha);

        Self.FrameSwitchEffectAnimator.Run;


    end;
    fstAlpha:
    begin

        //显示之前先将透明度设置为0,避免突然显示
        {$IFDEF FMX}
        ToFrame.Opacity:=0;
        {$ENDIF}


        //设置父控件
        if (ToFrameParent<>nil) then
        begin
          //ToFrame.Parent:=TParentControl(ToFrameParent);
          if ToFrameParent is TForm then
          begin
            ToFrame.Parent:=TForm(ToFrameParent);
          end
          else
          begin
            ToFrame.Parent:=TParentControl(ToFrameParent);
          end;
        end;

        //先初始位置
        {$IFDEF FMX}
        ToFrame.Position.X:=0;
        ToFrame.Position.Y:=0;
        {$ELSE}
        ToFrame.Left:=0;
        ToFrame.Top:=0;
        {$ENDIF}

        Self.ShowFrameEffect.MoveVertEffect.IsEnabled:=False;
        Self.ShowFrameEffect.MoveHorzEffect.IsEnabled:=False;

        Self.ShowFrameEffect.AlphaEffect.From:=0;
        Self.ShowFrameEffect.AlphaEffect.Dest:=255;
        Self.ShowFrameEffect.AlphaEffect.IsEnabled:=True;

        Self.FrameSwitchEffectAnimator.Run;


    end;
  end;

end;

procedure TFrameOperManager.DoAnimateReturnShowFrame(AFrameOperItem:TFrameOperItem;ToFrame:TFrame;ToFrameParent:TObject);
begin
//  uBaseLog.OutputDebugString('DoAnimateReturnShowFrame '+ToFrame.Name);



      //if TFrameOperItem(FFrameOperItems[0]).FrameHistory.ToFrame.Align=TAlignLayout.None then
      //begin
      //end
      //else
      //begin
      //  //这个Frame在显示的时候没有Hide,那么不需要动画效果
      //end;
      if (ToFrame=nil) or (ToFrame.Align={$IFDEF FMX}TAlignLayout.Client{$ELSE}alClient{$ENDIF}) then
      begin
        //已经显示了,就不再搞什么效果了
        //DoShowFrameAnimateEnd(nil);
        DoFinishReturnShowFrame(AFrameOperItem.FrameHistory,AFrameOperItem.LastFrameHistory,AFrameOperItem.IsNeedFreeFrame);
        EndCurrentShowFrameItem;
        Exit;
      end;




  //切换效果
//  if Not AFrameOperItem.IsUseCacheImage then
//  begin

      //MainFrame->DemoFrame
      ToFrame.Visible:=True;

      //设置切换效果前先填满窗体
      if (ToFrameParent<>nil) then
      begin
        ToFrame.Width:=GetControlParentWidth(TParentControl(ToFrameParent));
        ToFrame.Height:=GetControlParentHeight(TParentControl(ToFrameParent));
      end;

      Self.ReturnShowFrameEffect.Control:=ToFrame;

//  end
//  else
//  begin
//
//      //设置切换效果前先填满窗体
//      if (ToFrameParent<>nil) then
//      begin
//        ShowFrameImage.Width:=GetControlParentWidth(TFmxObject(ToFrameParent));
//        ShowFrameImage.Height:=GetControlParentHeight(TFmxObject(ToFrameParent));
//      end;
//      ShowFrameImage.Parent:=ToFrame.Parent;
//      Self.ReturnShowFrameEffect.Control:=Self.ShowFrameImage;//ToFrame;
//
//      MakeScreenshot(ToFrame,ShowFrameImage);
//  end;

  //前一个Frame是怎么显示的,是什么显示效果,现在就反着来
  case AFrameOperItem.FrameHistory.FrameSwitchType of
    fstNone:
    begin
        Self.ReturnShowFrameEffect.MoveVertEffect.IsEnabled:=False;
        Self.ReturnShowFrameEffect.MoveHorzEffect.IsEnabled:=False;
        Self.ReturnShowFrameEffect.AlphaEffect.IsEnabled:=False;


        DoShowFrameAnimateEnd(nil);

        //设置父控件
        if (ToFrameParent<>nil) then
        begin
          //ToFrame.Parent:=TParentControl(ToFrameParent);
          if ToFrameParent is TForm then
          begin
            ToFrame.Parent:=TForm(ToFrameParent);
          end
          else
          begin
            ToFrame.Parent:=TParentControl(ToFrameParent);
          end;
        end;



    end;
    fstDefault,fstDefaultAndAlpha:
    begin

        //先初始位置
        {$IFDEF FMX}
        ToFrame.Position.X:=-ToFrame.Width;
        {$ELSE}
        ToFrame.Left:=-ToFrame.Width;
        {$ENDIF}


        Self.ReturnShowFrameEffect.MoveHorzEffect.From:=-ToFrame.Width;
        Self.ReturnShowFrameEffect.MoveHorzEffect.Dest:=0;
        Self.ReturnShowFrameEffect.MoveHorzEffect.IsEnabled:=True;

        Self.ReturnShowFrameEffect.MoveVertEffect.IsEnabled:=False;


        Self.ReturnShowFrameEffect.AlphaEffect.From:=0;
        Self.ReturnShowFrameEffect.AlphaEffect.Dest:=255;
        Self.ReturnShowFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstDefaultAndAlpha);
        Self.FrameSwitchEffectAnimator.Run;


    end;
    fstMoveVert,fstMoveVertAndAlpha:
    begin


        //先初始位置
        {$IFDEF FMX}
        ToFrame.Position.X:=-ToFrame.Height;
        {$ELSE}
        ToFrame.Left:=-ToFrame.Height;
        {$ENDIF}


        Self.ReturnShowFrameEffect.MoveVertEffect.From:=-ToFrame.Height;
        Self.ReturnShowFrameEffect.MoveVertEffect.Dest:=0;
        Self.ReturnShowFrameEffect.MoveVertEffect.IsEnabled:=True;

        Self.ReturnShowFrameEffect.MoveHorzEffect.IsEnabled:=False;

        Self.ReturnShowFrameEffect.AlphaEffect.From:=0;
        Self.ReturnShowFrameEffect.AlphaEffect.Dest:=255;
        Self.ReturnShowFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstMoveVertAndAlpha);

        Self.FrameSwitchEffectAnimator.Run;


    end;
    fstAlpha:
    begin


        //先初始位置
        {$IFDEF FMX}
        ToFrame.Position.X:=0;
        ToFrame.Position.Y:=0;
        {$ELSE}
        ToFrame.Left:=0;
        ToFrame.Top:=0;
        {$ENDIF}

        Self.ReturnShowFrameEffect.MoveVertEffect.IsEnabled:=False;
        Self.ReturnShowFrameEffect.MoveHorzEffect.IsEnabled:=False;

        Self.ReturnShowFrameEffect.AlphaEffect.From:=0;
        Self.ReturnShowFrameEffect.AlphaEffect.Dest:=255;
        Self.ReturnShowFrameEffect.AlphaEffect.IsEnabled:=True;

        Self.FrameSwitchEffectAnimator.Run;


    end;
  end;


end;


procedure TFrameOperManager.DoAnimateHideFrame(AFrameOperItem:TFrameOperItem;Frame:TFrame;const HideFrameType:THideFrameType);
begin
//  uBaseLog.OutputDebugString('DoAnimateHideFrame '+Frame.Name);

  {$IFDEF FMX}
  Frame.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}None{$ELSE}alNone{$IFEND};
  {$ELSE}
  Frame.Align:=alNone;
  {$ENDIF}


//  if Not AFrameOperItem.IsUseCacheImage then
//  begin
//
//
//  end
//  else
//  begin
//
//      Frame.Visible:=False;
//
//      //设置切换效果前先填满窗体
//      if (Frame.Parent<>nil) then
//      begin
//        HideFrameImage.Width:=GetControlParentWidth(TFmxObject(Frame.Parent));
//        HideFrameImage.Height:=GetControlParentHeight(TFmxObject(Frame.Parent));
//      end;
//      HideFrameImage.Parent:=Frame.Parent;
//
//      MakeScreenshot(Frame,HideFrameImage);
//  end;



  case HideFrameType of
    hftBeforeShow:
    begin

        case AFrameOperItem.FrameHistory.FrameSwitchType of
          fstNone:
          begin
            Self.HideFrameEffect.MoveVertEffect.IsEnabled:=False;
            Self.HideFrameEffect.MoveHorzEffect.IsEnabled:=False;
            Self.HideFrameEffect.AlphaEffect.IsEnabled:=False;


          end;
          fstDefault,fstDefaultAndAlpha:
          begin
            //

                    //从右移到左边隐藏起来
            //        if Not AFrameOperItem.IsUseCacheImage then
            //        begin
                      Self.HideFrameEffect.Control:=Frame;
            //        end
            //        else
            //        begin
            //          Self.HideFrameEffect.Control:=Self.HideFrameImage;
            //        end;
                    Self.HideFrameEffect.MoveHorzEffect.From:=0;
                    //除以2提高效率
                    Self.HideFrameEffect.MoveHorzEffect.Dest:=-Frame.Width;
                    Self.HideFrameEffect.MoveHorzEffect.IsEnabled:=True;

                    Self.HideFrameEffect.MoveVertEffect.IsEnabled:=False;

                    Self.HideFrameEffect.AlphaEffect.From:=255;
                    Self.HideFrameEffect.AlphaEffect.Dest:=0;
                    Self.HideFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstDefaultAndAlpha);

                    Self.FrameSwitchEffectAnimator.Run;

          end;
          fstMoveVert,fstMoveVertAndAlpha:
          begin
                    //从右移到左边隐藏起来
            //        if Not AFrameOperItem.IsUseCacheImage then
            //        begin
                      Self.HideFrameEffect.Control:=Frame;
            //        end
            //        else
            //        begin
            //          Self.HideFrameEffect.Control:=Self.HideFrameImage;
            //        end;
                    Self.HideFrameEffect.MoveVertEffect.From:=0;
                    //除以2提高效率
                    Self.HideFrameEffect.MoveVertEffect.Dest:=-Frame.Height;
                    Self.HideFrameEffect.MoveVertEffect.IsEnabled:=True;

                    Self.HideFrameEffect.MoveHorzEffect.IsEnabled:=False;

                    Self.HideFrameEffect.AlphaEffect.From:=255;
                    Self.HideFrameEffect.AlphaEffect.Dest:=0;
                    Self.HideFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstMoveVertAndAlpha);

                    Self.FrameSwitchEffectAnimator.Run;


          end;
          fstAlpha:
          begin
                    //从右移到左边隐藏起来
                    Self.HideFrameEffect.Control:=Frame;
                    Self.HideFrameEffect.MoveVertEffect.IsEnabled:=False;
                    Self.HideFrameEffect.MoveHorzEffect.IsEnabled:=False;

                    Self.HideFrameEffect.AlphaEffect.From:=255;
                    Self.HideFrameEffect.AlphaEffect.Dest:=0;
                    Self.HideFrameEffect.AlphaEffect.IsEnabled:=True;

                    Self.FrameSwitchEffectAnimator.Run;


          end;
        end;

    end;
    hftBeforeReturn:
    begin
        //返回
        case AFrameOperItem.FrameHistory.FrameSwitchType of
          fstNone: ;
          fstDefault,fstDefaultAndAlpha:
          begin


                  //从左移到右边隐藏起来
          //        if Not AFrameOperItem.IsUseCacheImage then
          //        begin
                    Self.ReturnHideFrameEffect.Control:=Frame;
          //        end
          //        else
          //        begin
          //          Self.ReturnHideFrameEffect.Control:=Self.HideFrameImage;
          //        end;
                  Self.ReturnHideFrameEffect.MoveHorzEffect.From:=0;
                  Self.ReturnHideFrameEffect.MoveHorzEffect.Dest:=Frame.Width;
                  Self.ReturnHideFrameEffect.MoveHorzEffect.IsEnabled:=True;

                  Self.ReturnHideFrameEffect.MoveVertEffect.IsEnabled:=False;

                  Self.ReturnHideFrameEffect.AlphaEffect.From:=255;
                  Self.ReturnHideFrameEffect.AlphaEffect.Dest:=0;
                  Self.ReturnHideFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstDefaultAndAlpha);

                  Self.FrameSwitchEffectAnimator.Run;

          end;
          fstMoveVert,fstMoveVertAndAlpha:
          begin


                  //从左移到右边隐藏起来
          //        if Not AFrameOperItem.IsUseCacheImage then
          //        begin
                    Self.ReturnHideFrameEffect.Control:=Frame;
          //        end
          //        else
          //        begin
          //          Self.ReturnHideFrameEffect.Control:=Self.HideFrameImage;
          //        end;
                  Self.ReturnHideFrameEffect.MoveVertEffect.From:=0;
                  Self.ReturnHideFrameEffect.MoveVertEffect.Dest:=Frame.Height;
                  Self.ReturnHideFrameEffect.MoveVertEffect.IsEnabled:=True;

                  Self.ReturnHideFrameEffect.MoveHorzEffect.IsEnabled:=False;

                  Self.ReturnHideFrameEffect.AlphaEffect.From:=255;
                  Self.ReturnHideFrameEffect.AlphaEffect.Dest:=0;
                  Self.ReturnHideFrameEffect.AlphaEffect.IsEnabled:=(AFrameOperItem.FrameHistory.FrameSwitchType=fstMoveVertAndAlpha);

                  Self.FrameSwitchEffectAnimator.Run;

          end;
          fstAlpha:
          begin

                  Self.ReturnHideFrameEffect.Control:=Frame;
                  Self.ReturnHideFrameEffect.MoveVertEffect.IsEnabled:=False;
                  Self.ReturnHideFrameEffect.MoveHorzEffect.IsEnabled:=False;

                  Self.ReturnHideFrameEffect.AlphaEffect.From:=255;
                  Self.ReturnHideFrameEffect.AlphaEffect.Dest:=0;
                  Self.ReturnHideFrameEffect.AlphaEffect.IsEnabled:=True;

                  Self.FrameSwitchEffectAnimator.Run;

          end;
        end;

    end;
  end;
end;






{ TFrameFormMapList }

function TFrameFormMapList.Add(AFrame: TFrame; AForm: TForm): TFrameFormMap;
begin
  Result:=TFrameFormMap.Create;
  Result.FFrame:=AFrame;
  Result.FForm:=AForm;
  Inherited Add(Result);
end;

function TFrameFormMapList.FindByFrame(AFrame: TFrame): TFrameFormMap;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count - 1 do
  begin
    if Items[I].FFrame=AFrame then
    begin
      Result:=Items[I];
      Exit;
    end;
  end;
end;

function TFrameFormMapList.FindByForm(AForm: TForm): TFrameFormMap;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count - 1 do
  begin
    if Items[I].FForm=AForm then
    begin
      Result:=Items[I];
      Exit;
    end;
  end;
end;

function TFrameFormMapList.GetItem(Index: Integer): TFrameFormMap;
begin
  Result:=TFrameFormMap(Inherited Items[Index]);
end;




{ TFrameFormMap }

procedure TFrameFormMap.DoFormClose(Sender: TObject; var Action: TCloseAction);
begin
  //中断了
  if GetFrameHistory(Self.FFrame)<>nil then GetFrameHistory(Self.FFrame).OnReturnFrame:=nil;

  if Assigned(FOnClose) then
  begin
    FOnClose(Self);
  end;



  DoHideFrame(Self.FFrame);
  DoReturnFrame(Self.FFrame);

end;


procedure TFrameFormMap.DoFormCloseInReturnFrame(Sender: TObject;
  var Action: TCloseAction);
begin
  FFrame.Parent:=nil;//不能释放Frame，下次还要用

  GlobalFrameFormMapList.Remove(Self,False);

  Action:={$IFDEF FMX}TCloseAction.caFree{$ENDIF}{$IFDEF VCL}caFree{$ENDIF};

  Self.FForm:=nil;
  Self.Free;
end;

{ TFramePopupStyle }

procedure TFramePopupStyle.Clear;
begin
  PopupWidth:=0;
  PopupHeight:=0;
  //点击空白的地方的处理
  ClickSpaceType:=TFramePopupStyleClickSpaceType.cstNone;

end;

initialization
  GlobalFrameHistoryLogList:=TFrameHistoryLogList.Create;
  GlobalFrameSettingLogList:=TFrameHistoryLogList.Create;


//  GlobalIsPaintSetting:=False;
//  GlobalFrameFillColor:=NullColor;
  //弹出样式的背景色
  GlobalPopupStyleFrameFillColor:=$80000000;
  //弹出样式的宽度
  GlobalPopupStyleFrameWidth:=320;
  GlobalFramePaintSettingEvent:=TFramePaintSettingEvent.Create;

  FreedFrameList:=TList.Create;

  GlobalTopMostFrameList:=TBaseList.Create(ooReference);

  GlobalFrameOperManager:=TFrameOperManager.Create;

  GlobalFrameFormMapList:=TFrameFormMapList.Create;

  {$IFDEF VCL}
  GlobalFrameParentFormClass:=TForm;
  {$ENDIF}

finalization
  FreeAndNil(GlobalFrameHistoryLogList);
  FreeAndNil(GlobalFrameSettingLogList);

  FreeAndNil(GlobalFramePaintSettingEvent);

  FreeAndNil(GlobalFrameOperManager);

  FreeAndNil(FreedFrameList);

  FreeAndNil(GlobalTopMostFrameList);

  FreeAndNil(GlobalFrameFormMapList);



end.
