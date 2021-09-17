//convert pas to utf8 by ¥
//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeUIControl
//  Unit: uSkinSwitchPageListPanelType
//  Description: 切换分页手势
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2014
//
//------------------------------------------------------------------

unit uSkinSwitchPageListControlGestureManager;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  ExtCtrls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  {$ENDIF}
  Math,
  uBaseLog,
  uSkinAnimator,
//  uDialogCommon,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uBaseList,
//  {$IFDEF VCL}
//  uSkinWindowsButton,
//  uSkinDirectUIButton
//  {$ENDIF}
//  {$IFDEF FMX}
//  {$ENDIF},
  uSkinScrollBarType,
  uSkinScrollControlType,
  uSkinControlGestureManager,
  uSkinControlPanDragGestureManager,
  uSkinImageList,
  uComponentType,
  uDrawEngine,
//  uBufferBitmap,
  uDrawParam,
  uSkinPicture,
  uDrawPicture,
  uSkinButtonType,
  uDrawTextParam,
  uDrawRectParam,
  uSkinRegManager,
  uDrawPictureParam;


type
//  //获取当前的页下标
//  TTGetPageIndexChangeEvent=procedure(Sender:TObject;APageIndex:Integer) of object;
//  //获取页的浮点型参数
//  TTGetPageFloatParamEvent=procedure(Sender:TObject;var Param:Double) of object;
//  TTGetPageIntParamEvent=procedure(Sender:TObject;var Param:Integer) of object;
//
//  TTGetPageIndexFloatParamEvent=procedure(Sender:TObject;Index:Integer;var Param:Double) of object;
//  TTGetPageIndexIntParamEvent=procedure(Sender:TObject;APageIndex:Integer;var Param:Integer) of object;
//  TTGetPageIndexControlParamEvent=procedure(Sender:TObject;APageIndex:Integer;var AControl:TControl) of object;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitchPageListControlGestureManager=class(TSkinSwitchPageGestureManager)
//  TSkinSwitchPageListControlGestureManager=class(TComponent)
//  protected
//    //当前页下标
//    FPageIndex:Integer;
//    //页个数
//    FPageCount:Integer;
//    //页宽
//    FPageWidth:Double;
//    //页高
//    FPageHeight:Double;
//
//
//
//    //动态获取以上这些参数的过程
//    FOnGetPageCount:TTGetPageIntParamEvent;
//    FOnGetPageIndex:TTGetPageIntParamEvent;
//    FOnGetPageWidth:TTGetPageIndexFloatParamEvent;
//    FOnGetPageHeight:TTGetPageIndexFloatParamEvent;
//    FOnGetPageControl:TTGetPageIndexControlParamEvent;
//
//
//
//
//    //当前切换显示的分页
//    FCurrentSwitchCurrentPageIndex:Integer;
////    //当前切换显示的分页的前一张
////    FCurrentSwitchBeforePageIndex:Integer;
//    //当前切换显示的分页的后一张
//    FCurrentSwitchAfterPageIndex:Integer;
//
//
//
//
//    //用户停止拖动要切换到的分页下标
//    FUserStopDragSwitchToPageIndex:Integer;
//
//
//
//    //当前分页的切换顺序
//    FCurrentSwitchOrderType:TAnimateOrderType;
//
//
//
//
//
//    //分页列表滚动顺序
//    FPageListAnimated: Boolean;
//    //分页列表滚动速度
//    FPageListAnimateSpeed: Double;
//    //分页列表滚动顺序
//    FPageListAnimateOrderType:TAnimateOrderType;
//
//
//
//    //当前正在切换
//    FPageListSwitching:Boolean;
//    //分页列表循环速度
//    FPageListSwitchingSpeed:Double;
//    //当前切换的进度
//    FPageListSwitchingProgress:Double;
//    //用户松开手指时当前切换的进度
//    FUserStopDragPageListSwitchingProgress:Double;
//
//
//
//
//
//
//    //当前切换的增量
//    FPageListSwitchingProgressIncement:Integer;
//    //分页列表切换的类型
//    FPageListSwitchEffectType:TAnimateSwitchEffectType;
//
//
//
//    //是否是第一次用户拖动
//    FIsFirstUserDrag:Boolean;
//    //是否正在手势切换
//    FIsGestureSwitching:Boolean;
//
//
//
//
//    //是否可以循环切换
//    FGestureSwitchLooped: Boolean;
//    //是否可以手势切换
//    FCanGestureSwitch:Boolean;
//    //可以手势切换的距离
//    FCanGestureSwitchDistance: Double;
//
//
//    //分页列表滚动定时器
//    FPageListAnimateTimer:TTimer;
//    //分页列表切换定时器
//    FPageListSwitchingTimer:TTimer;
//
//
//    //手势管理
//    FControlGestureManager:TSkinControlGestureManager;
//
//
//
//    function GetPageIndex: Integer;
//    function GetPageCount: Integer;
//    function GetPageWidth(Index:Integer): Double;
//    function GetPageHeight(Index:Integer): Double;
//    function GetPageIndexControl(const APageIndex:Integer): TControl;
//
//
//    procedure SetPageIndex(const Value: Integer);
//    procedure SetPageCount(const Value: Integer);
//
//
//
//    //分页列表定时切换定时器
//    procedure CreatePageListAnimateTimer;
//    procedure DoPageListAnimateTimer(Sender:TObject);
//
//
//    //分页列表正在切换定时器
//    procedure CreatePageListSwitchingTimer;
//    procedure DoPageListSwitchingTimer(Sender:TObject);
//
//
//    //启用循环定时切换
//    procedure SetPageListAnimated(const Value: Boolean);
//    //循环定时切换的间隔时间
//    procedure SetPageListAnimateSpeed(const Value: Double);
//
//
//    //切换进度的最大值,一般为控件的尺寸
//    function GetPageListSwitchingProgressMax(Index:Integer):Double;
//    //是否正在切换
//    procedure SetPageListSwitching(const Value: Boolean);
//    //切换效果的速度
//    procedure SetPageListSwitchingSpeed(const Value: Double);
//    procedure SetPageListSwitchEffectType(const Value: TAnimateSwitchEffectType);
//
//
//
//    //获取当前分页的下一张分页
//    function GetAfterNextPageIndex(APageIndex:Integer):Integer;
//    //获取当前分页的上一张分页
//    function GetAfterPriorPageIndex(APageIndex:Integer):Integer;
//
//
//    //获取当前的切换方向
//    function GetCurrentSwitchOrderType:TAnimateOrderType;
//
//
//
//  private
//
//    //初始手势管理越界值
//    procedure InitControlGestureManagerOverrangePosValue;
//
//
//
//
//    //获取当前切换的滚动条类型
//    function GetCurrentCanGestureScrollBarKind:TScrollBarKind;
//    //计算可以切换的距离
//    function CalcCanGestureSwitchDistance(Max:Double):Double;
//
//
//
//
//
//
//    //向右拖动事件,或向上拖动
//    procedure DoControlGestureManagerMinOverRangePosValueChange(Sender:TObject;
//                                                  NextValue:Double;
//                                                  LastValue:Double;
//                                                  Step:Double;
//                                                  var NewValue:Double;
//                                                  var CanChange:Boolean);
//    //向左拖动事件,或向下拖动
//    procedure DoControlGestureManagerMaxOverRangePosValueChange(Sender:TObject;
//                                                  NextValue:Double;
//                                                  LastValue:Double;
//                                                  Step:Double;
//                                                  var NewValue:Double;
//                                                  var CanChange:Boolean);
//    //计算需要惯性滚动的距离
//    procedure DoControlGestureManagerCalcInertiaScrollDistance(Sender:TObject;
//                                                  //MilliSecondSpace:Double;
//                                                  //SumDragCrement:Double;
//                                                  var InertiaDistance:Double;
//                                                  var CanInertiaScroll:Boolean
//                                                  //var EndTimesCount:Integer
//                                                  );
//    //惯性滚动结束事件
//    procedure DoControlGestureManagerInertiaScrollAnimateEnd(Sender:TObject;
//                                                var CanStartScrollToInitial:Boolean;
//                                                var AMinOverRangePosValue_Min:Double;
//                                                var AMaxOverRangePosValue_Min:Double);
//    //滚回初始事件
//    procedure DoControlGestureManagerScrollToInitialAnimateEnd(Sender:TObject);
//
//  protected
//    //水平滚动条
//    FSwitchButtonGroup:TSkinBaseButtonGroup;
////    FSwitchButtonGroupControlIntf:ISkinControl;
////    FSwitchButtonGroupComponentIntf:ISkinComponent;
//    FSwitchButtonGroupIntf:ISkinButtonGroup;
//
//
//    //按钮分组
//    function GetSwitchButtonGroup:TSkinBaseButtonGroup;
//    function GetSwitchButtonGroupIntf:ISkinButtonGroup;
////    function GetSwitchButtonGroupControlIntf:ISkinControl;
////    function GetSwitchButtonGroupComponentIntf:ISkinComponent;
//    procedure SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
//  protected
//    //分页下标更改
//    FOnPageIndexChange:TTGetPageIndexChangeEvent;
//    //分页个数更改
//    FOnPageCountChange:TNotifyEvent;
//
//    //分页列表切换结束事件
//    FOnSwitchPageListEnd: TNotifyEvent;
//
//    //滚动事件
//    FOnPageListSwitchingProgressChange:TNotifyEvent;
//
//
//    //分页切换结束事件
//    procedure DoPageIndexChange;
//
//    //分页切换结束事件
//    procedure DoPageListSwitchEnd;
//
//    //点击切换按钮
//    procedure DoPageListSwitchButtonClick(Sender: TObject);
//    //排列切换按钮
//    procedure AlignPageListSwitchButtons;
//    //分页个数更改事件
//    procedure DoPageCountChanged(Sender: TObject);
//
//    //设置切换进度
//    procedure DoPageListSwitchingProgressChange;
//  public
//    constructor Create(AOwner:TComponent);override;
//    destructor Destroy;override;
//  public
//    //手势管理
//    property ControlGestureManager:TSkinControlGestureManager read FControlGestureManager;
//
//    //切换的进度
//    property PageListSwitchingProgress:Double read FPageListSwitchingProgress;
//
//    //事件
//    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//    procedure MouseMove(Shift: TShiftState; X, Y: Double);
//    procedure MouseLeave;
//    function MouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;
//
//    //排列分页
//    procedure AlignSwitchListPages(ADrawRect:TRectF);
//
//    //切换分页
//    procedure SwitchPage(ABeginPageIndex:Integer;AAfterPageIndex:Integer);
//
//    //切换到下一张
//    procedure SwitchNext;
//    //切换到上一张
//    procedure SwitchPrior;
//
//
//
//    //获取切换之前的分页下标
//    function GetCurrentBeforePageIndex:Integer;
//    //获取切换的当前分页下标
//    function GetCurrentCurrentPageIndex:Integer;
//    //获取切换之后的分页下标
//    function GetCurrentAfterPageIndex:Integer;
//
//
//
//
//    //上一张显示的分页的切换时的显示矩形
//    function GetPageListSwitchingBeforePageDrawRect(const ADrawRect:TRectF):TRectF;
//    //当前显示的分页的切换时的显示矩形
//    function GetPageListSwitchingCurrentPageDrawRect(const ADrawRect:TRectF):TRectF;
//    //下一张显示的分页的切换时的显示矩形
//    function GetPageListSwitchingAfterPageDrawRect(const ADrawRect:TRectF):TRectF;
//
//
//  published
//    property PageIndex:Integer read GetPageIndex write SetPageIndex;
//    property PageCount:Integer read GetPageCount write SetPageCount;
////    property PageWidth:Double read GetPageWidth write FPageWidth;//SetPageWidth;
////    property PageHeight:Double read GetPageHeight write FPageHeight;//SetPageHeight;
////    property HardGestureSwitch:Boolean read FHardGestureSwitch write FHardGestureSwitch;
//
//    //是否可以手势切换
//    property CanGestureSwitch:Boolean read FCanGestureSwitch write FCanGestureSwitch;
//    //可以切换下一页的距离
//    property CanGestureSwitchDistance:Double read FCanGestureSwitchDistance write FCanGestureSwitchDistance;
//    //是否可以循环手势切换
//    property GestureSwitchLooped:Boolean read FGestureSwitchLooped write FGestureSwitchLooped;
//
//
//
//    //切换按钮分组
//    property SwitchButtonGroup: TSkinBaseButtonGroup read GetSwitchButtonGroup write SetSwitchButtonGroup;
//
//
//    //分页列表定时切换
//    property PageListAnimated:Boolean read FPageListAnimated write SetPageListAnimated;
//    property PageListAnimateSpeed:Double read FPageListAnimateSpeed write SetPageListAnimateSpeed;
//    property PageListAnimateOrderType:TAnimateOrderType read FPageListAnimateOrderType write FPageListAnimateOrderType;
//
//
//    //分页列表正在切换的效果设置
//    property PageListSwitchEffectType: TAnimateSwitchEffectType read FPageListSwitchEffectType write SetPageListSwitchEffectType;
//    property PageListSwitchingSpeed:Double read FPageListSwitchingSpeed write SetPageListSwitchingSpeed;
//    property PageListSwitchingProgressIncement:Integer read FPageListSwitchingProgressIncement write FPageListSwitchingProgressIncement;
//
//  published
//    property OnGetPageIndex:TTGetPageIntParamEvent read FOnGetPageIndex write FOnGetPageIndex;
//    property OnGetPageCount:TTGetPageIntParamEvent read FOnGetPageCount write FOnGetPageCount;
//    property OnGetPageWidth:TTGetPageIndexFloatParamEvent read FOnGetPageWidth write FOnGetPageWidth;
//    property OnGetPageHeight:TTGetPageIndexFloatParamEvent read FOnGetPageHeight write FOnGetPageHeight;
//    property OnGetPageControl:TTGetPageIndexControlParamEvent read FOnGetPageControl write FOnGetPageControl;
//
//    property OnPageIndexChange:TTGetPageIndexChangeEvent read FOnPageIndexChange write FOnPageIndexChange;
//    property OnPageCountChange:TNotifyEvent read FOnPageCountChange write FOnPageCountChange;
//
//    //列表切换结束事件
//    property OnSwitchPageListEnd:TNotifyEvent read FOnSwitchPageListEnd write FOnSwitchPageListEnd;
//    //分页列表切换进度事件
//    property OnPageListSwitchingProgressChange:TNotifyEvent read FOnPageListSwitchingProgressChange write FOnPageListSwitchingProgressChange;
  end;





implementation


{ TSkinSwitchPageListControlGestureManager }


//function TSkinSwitchPageListControlGestureManager.GetSwitchButtonGroupIntf:ISkinButtonGroup;
//begin
//  Result:=FSwitchButtonGroupIntf;
//end;
//
////function TSkinSwitchPageListControlGestureManager.GetSwitchButtonGroupComponentIntf:ISkinComponent;
////begin
////  Result:=FSwitchButtonGroupComponentIntf;
////end;
////
////function TSkinSwitchPageListControlGestureManager.GetSwitchButtonGroupControlIntf:ISkinControl;
////begin
////  Result:=FSwitchButtonGroupControlIntf;
////end;
//
//function TSkinSwitchPageListControlGestureManager.GetSwitchButtonGroup: TSkinBaseButtonGroup;
//begin
//  Result:=Self.FSwitchButtonGroup;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
//begin
//  if FSwitchButtonGroup<>Value then
//  begin
//    //将原Style释放或解除绑定
//    if FSwitchButtonGroup<>nil then
//    begin
//      if (FSwitchButtonGroup.Owner=Self) then
//      begin
//        //释放自己创建的
//        FreeAndNil(FSwitchButtonGroup);
//      end
//      else
//      begin
//        //解除别人的
//        FSwitchButtonGroup:=nil;
//        FSwitchButtonGroupIntf:=nil;
////        FSwitchButtonGroupControlIntf:=nil;
////        FSwitchButtonGroupComponentIntf:=nil;
//      end;
//    end;
//    if Value<>nil then
//    begin
//      FSwitchButtonGroup:=Value;
////      FSwitchButtonGroup.FreeNotification(Self);
//      FSwitchButtonGroupIntf:=FSwitchButtonGroup as ISkinButtonGroup;
////      FSwitchButtonGroupControlIntf:=FSwitchButtonGroup as ISkinControl;
////      FSwitchButtonGroupComponentIntf:=FSwitchButtonGroup as ISkinComponent;
//
//      //创建分页列表下标按钮
//      Self.AlignPageListSwitchButtons;
//    end
//    else//nil value
//    begin
//
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//begin
//  if CanGestureSwitch then
//  begin
//    Self.InitControlGestureManagerOverrangePosValue;
//    Self.FControlGestureManager.MouseDown(Button,Shift,X,Y);
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.MouseLeave;
//begin
//  if CanGestureSwitch then
//  begin
//    Self.FControlGestureManager.MouseLeave;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.MouseMove(Shift: TShiftState; X, Y: Double);
//begin
//  if CanGestureSwitch then
//  begin
//    Self.FControlGestureManager.MouseMove(Shift,X,Y);
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//begin
//  if CanGestureSwitch then
//  begin
//    Self.FControlGestureManager.MouseUp(Button,Shift,X,Y);
//    Self.FIsFirstUserDrag:=True;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.MouseWheel(Shift: TShiftState; WheelDelta:Integer; X,Y: Double): Boolean;
//begin
//  if CanGestureSwitch then
//  begin
//    Self.FControlGestureManager.MouseWheel(Shift,WheelDelta,X,Y);
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.AlignSwitchListPages(ADrawRect:TRectF);
//var
//  ABeforeControl:TControl;
//  ACurrentControl:TControl;
//  AAfterControl:TControl;
//
//  ABeforePageDrawRect:TRectF;
//  ACurrentPageDrawRect:TRectF;
//  AAfterPageDrawRect:TRectF;
//begin
//  //切换之前分页和切换之后分页的绘制矩形
//  ACurrentPageDrawRect:=Self.GetPageListSwitchingCurrentPageDrawRect(ADrawRect);
//  //以ACurrentPageDrawRect为中心,计算出两边靠着的矩形就行了
//  ABeforePageDrawRect:=Self.GetPageListSwitchingBeforePageDrawRect(ADrawRect);
//  AAfterPageDrawRect:=Self.GetPageListSwitchingAfterPageDrawRect(ADrawRect);
//
//
//  //如果宽度不相等的,加上偏移
//  //当前页比下一页窄
//  if (GetCurrentCurrentPageIndex<>-1)
//    and (GetCurrentAfterPageIndex<>-1)
//    and SmallerDouble(Self.GetPageWidth(GetCurrentCurrentPageIndex),Self.GetPageWidth(GetCurrentAfterPageIndex)) then
//  begin
//    AAfterPageDrawRect:=ACurrentPageDrawRect;
//    ACurrentPageDrawRect.Right:=ACurrentPageDrawRect.Left+GetPageWidth(GetCurrentCurrentPageIndex);
//    OffsetRect(AAfterPageDrawRect,GetPageWidth(GetCurrentCurrentPageIndex),0);
//  end;
//
//  if (GetCurrentCurrentPageIndex<>-1)
//    and (GetCurrentBeforePageIndex<>-1)
//    and SmallerDouble(Self.GetPageWidth(GetCurrentCurrentPageIndex),Self.GetPageWidth(GetCurrentBeforePageIndex)) then
//  begin
//    ABeforePageDrawRect:=ACurrentPageDrawRect;
//    ACurrentPageDrawRect.Right:=ACurrentPageDrawRect.Left+GetPageWidth(GetCurrentCurrentPageIndex);
//    OffsetRect(ABeforePageDrawRect,GetPageWidth(GetCurrentCurrentPageIndex),0);
//  end;
//
//
//  ABeforeControl:=GetPageIndexControl(GetCurrentBeforePageIndex);
//  if FCurrentSwitchCurrentPageIndex=-1 then
//  begin
//    ACurrentControl:=GetPageIndexControl(PageIndex);
//    AAfterControl:=GetPageIndexControl(GetCurrentAfterPageIndex);
//  end
//  else
//  begin
//    ACurrentControl:=GetPageIndexControl(FCurrentSwitchCurrentPageIndex);
//    AAfterControl:=GetPageIndexControl(Self.FCurrentSwitchAfterPageIndex);
//  end;
//
//
//
//  if (PageCount<=2) then
//  begin
//
//
//    if (ACurrentControl<>nil) then
//    begin
//      ACurrentControl.Visible:=True;
//      (ACurrentControl as ISkinControl).SetBounds(ACurrentPageDrawRect);
//    end;
//    if (AAfterControl<>nil) then
//    begin
//      AAfterControl.Visible:=True;
//      (AAfterControl as ISkinControl).SetBounds(AAfterPageDrawRect);
//    end;
//    if (ABeforeControl<>nil) and (AAfterControl<>ABeforeControl) then
//    begin
//      ABeforeControl.Visible:=True;
//      (ABeforeControl as ISkinControl).SetBounds(ABeforePageDrawRect);
//    end;
//  end
//  else
//  begin
//    if (ACurrentControl<>AAfterControl) then
//    begin
//
//      //不等
//      if (ABeforeControl<>nil) then
//      begin
//        ABeforeControl.Visible:=True;
//        (ABeforeControl as ISkinControl).SetBounds(ABeforePageDrawRect);
//      end;
//
//      if (ACurrentControl<>nil) then
//      begin
//        ACurrentControl.Visible:=True;
//        (ACurrentControl as ISkinControl).SetBounds(ACurrentPageDrawRect);
//      end;
//
//      if (AAfterControl<>nil) then
//      begin
//        AAfterControl.Visible:=True;
//        (AAfterControl as ISkinControl).SetBounds(AAfterPageDrawRect);
//      end;
//
//
//    end
//    else
//    begin
//
//
//      //相等
//      if (ABeforeControl<>nil) then
//      begin
//        ABeforeControl.Visible:=True;
//        (ABeforeControl as ISkinControl).SetBounds(ACurrentPageDrawRect);
//      end;
//
//
//      if (AAfterControl<>nil) then
//      begin
//        AAfterControl.Visible:=True;
//        (AAfterControl as ISkinControl).SetBounds(AAfterPageDrawRect);
//      end;
//
//
//    end;
//  end;
//
//end;
//
//function TSkinSwitchPageListControlGestureManager.CalcCanGestureSwitchDistance(Max:Double): Double;
//begin
//  Result:=Max/3;
//  if (Self.FCanGestureSwitchDistance>0) and (Self.FCanGestureSwitchDistance<1) then
//  begin
//    //如果小于零,表示百分比
//    Result:=Max*FCanGestureSwitchDistance;
//  end
//  else if (Self.FCanGestureSwitchDistance>0) then
//  begin
//    Result:=FCanGestureSwitchDistance;
//  end;
//end;
//
//constructor TSkinSwitchPageListControlGestureManager.Create(AOwner:TComponent);
//begin
//  inherited Create(AOwner);
//
//  FPageIndex:=-1;
//  FPageCount:=0;
//  FPageWidth:=100;
//  FPageHeight:=100;
//
//
////  FHardGestureSwitch:=False;
//
//
//  FPageListAnimated:=False;
//  FPageListAnimateSpeed:=500;
//
//  FPageListSwitchingSpeed:=10;
//  FPageListSwitching:=False;
//  FPageListSwitchingProgress:=0;
//
//
//  //增量
//  FPageListSwitchingProgressIncement:=20;
//  FPageListAnimateOrderType:=TAnimateOrderType.ilaotAsc;
//  FPageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetNone;
//
//  FCurrentSwitchCurrentPageIndex:=-1;
//  FCurrentSwitchOrderType:=TAnimateOrderType.ilaotNone;
//
//
//  FIsFirstUserDrag:=True;
//
//
//  FGestureSwitchLooped:=True;
//  FCanGestureSwitch:=True;
//  FCanGestureSwitchDistance:=0.2;
//
//
//  FControlGestureManager:=TSkinControlGestureManager.Create(nil,nil);
//
//  Self.FControlGestureManager.StaticMin:=0;
//  Self.FControlGestureManager.StaticMax:=0;
//  Self.FControlGestureManager.StaticPosition:=0;
//
////  Self.FControlGestureManager.IsCheckInertiaDirectionTime:=False;
//
//  Self.FControlGestureManager.InertiaScrollAnimator.MaxSpeed:=0;
//  Self.FControlGestureManager.InertiaScrollAnimator.InitialSpeed:=5;
//
//
////  Self.FControlGestureManager.DecideDoDragDirectionCrement:=5;
////  Self.FControlGestureManager.DecideInertiaDirectionCrement:=5;
////
////  Self.FControlGestureManager.StrictScroll:=True;
////  Self.FControlGestureManager.StrictScrollPrecision:=10;
//
//
//
////  Self.FControlGestureManager.InertiaScrollAnimator.Speed:=2;
//
////  Self.FControlGestureManager.InertiaScrollAnimator.Speed:=2;
//
//
//
////  Self.FControlGestureManager.InertiaScrollPower1:=5;
////  Self.FControlGestureManager.InertiaScrollPower2:=2;
//
//
//
//  Self.FControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
//
//
//  Self.FControlGestureManager.OnCalcInertiaScrollDistance:=Self.DoControlGestureManagerCalcInertiaScrollDistance;
//  Self.FControlGestureManager.OnInertiaScrollAnimateEnd:=Self.DoControlGestureManagerInertiaScrollAnimateEnd;
//  Self.FControlGestureManager.OnScrollToInitialAnimateEnd:=Self.DoControlGestureManagerScrollToInitialAnimateEnd;
//
//
//  Self.FControlGestureManager.OnMinOverRangePosValueChange:=Self.DoControlGestureManagerMinOverRangePosValueChange;
//  Self.FControlGestureManager.OnMaxOverRangePosValueChange:=Self.DoControlGestureManagerMaxOverRangePosValueChange;
//
//
//
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.CreatePageListAnimateTimer;
//begin
//  if FPageListAnimateTimer=nil then
//  begin
//    FPageListAnimateTimer:=TTimer.Create(nil);
//    FPageListAnimateTimer.OnTimer:=Self.DoPageListAnimateTimer;
//    FPageListAnimateTimer.Interval:=Ceil(Self.FPageListAnimateSpeed*10);
//    FPageListAnimateTimer.Enabled:=False;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.CreatePageListSwitchingTimer;
//begin
//  if FPageListSwitchingTimer=nil then
//  begin
//    FPageListSwitchingTimer:=TTimer.Create(nil);
//    FPageListSwitchingTimer.OnTimer:=Self.DoPageListSwitchingTimer;
//    FPageListSwitchingTimer.Interval:=Ceil(Self.FPageListSwitchingSpeed*10);
//    FPageListSwitchingTimer.Enabled:=False;
//  end;
//end;
//
//destructor TSkinSwitchPageListControlGestureManager.Destroy;
//begin
//  FreeAndNil(FControlGestureManager);
//  FreeAndNil(FPageListAnimateTimer);
//  FreeAndNil(FPageListSwitchingTimer);
//  inherited;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoPageListAnimateTimer(Sender: TObject);
//begin
//  //如果正在切换或手势切换那么不执行
//  if (not Self.FPageListSwitching)
//   and Not Self.FIsGestureSwitching
//   and not Self.FControlGestureManager.InertiaScrollAnimator.IsRuning then
//  begin
//    SwitchNext;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoPageListSwitchingProgressChange;
//begin
//  if Assigned(FOnPageListSwitchingProgressChange) then
//  begin
//    FOnPageListSwitchingProgressChange(Self);
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoPageListSwitchingTimer(Sender: TObject);
//begin
//  if FCanGestureSwitch then
//  begin
//    //当前正在拖动,那么也不处理
//    if Self.FControlGestureManager.IsMouseDown then Exit;
//    if Self.FControlGestureManager.IsDraging then Exit;
//    if Self.FControlGestureManager.ScrollingToInitialAnimator.IsRuning then Exit;
//    if Self.FControlGestureManager.InertiaScrollAnimator.IsRuning then Exit;
//  end;
//
//  case Self.FPageListSwitchEffectType of
//    ilasetNone:
//    begin
//      //没有切换效果
//      Self.FPageIndex:=FCurrentSwitchAfterPageIndex;//Self.GetCurrentAfterPageIndex;
////      FCurrentSwitchAfterPageIndex:=-1;
////      DoPageIndexChange;
////      Self.SetPageListSwitching(False);
//
//      DoPageListSwitchEnd;
//    end;
//    ilasetMoveHorz,ilasetMoveVert:
//    begin
//      //水平垂直切换
//      Self.FPageListSwitchingProgress:=FPageListSwitchingProgress
//            +FPageListSwitchingProgressIncement*Self.GetPageListSwitchingProgressMax(FCurrentSwitchCurrentPageIndex)/10;
//      DoPageListSwitchingProgressChange;
//      if FPageListSwitchingProgress>=GetPageListSwitchingProgressMax(FCurrentSwitchCurrentPageIndex) then
//      begin
//        //切换结束
//        Self.FPageIndex:=FCurrentSwitchAfterPageIndex;//Self.GetCurrentAfterPageIndex;
////        FCurrentSwitchAfterPageIndex:=-1;
////
////        DoPageIndexChange;
////        Self.SetPageListSwitching(False);
//
//        DoPageListSwitchEnd;
//
//      end;
//    end;
//  end;
//
//
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoControlGestureManagerCalcInertiaScrollDistance(Sender: TObject;
//  //MilliSecondSpace, SumDragCrement: Double;
//  var InertiaDistance:Double;
//  var CanInertiaScroll:Boolean
//  //var EndTimesCount: Integer
//  );
//var
//  APageListSwitchingProgressMax:Double;
//begin
//  if FCanGestureSwitch then
//  begin
//      if Self.FControlGestureManager.MaxOverRangePosValue>0 then
//      begin
//        //移过去
//        FUserStopDragSwitchToPageIndex:=GetAfterNextPageIndex(Self.PageIndex);
//      end
//      else
//      if Self.FControlGestureManager.MinOverRangePosValue>0 then
//      begin
//        //移回来
//        FUserStopDragSwitchToPageIndex:=GetAfterPriorPageIndex(Self.PageIndex);
//      end;
//
//      Self.SetPageListSwitching(False);
//
//      //计算惯性滚动的距离
//      APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(FUserStopDragSwitchToPageIndex);
//      if APageListSwitchingProgressMax>Self.GetPageListSwitchingProgressMax(PageIndex) then
//      begin
//        APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(PageIndex);
//      end;
//
//
//
//      FUserStopDragPageListSwitchingProgress:=FPageListSwitchingProgress;
//      if (FPageListSwitchingProgress>CalcCanGestureSwitchDistance(APageListSwitchingProgressMax))
//        and (FUserStopDragSwitchToPageIndex<>-1) then
//      begin
//        if FPageListSwitchingProgress<APageListSwitchingProgressMax then
//        begin
//          InertiaDistance:=APageListSwitchingProgressMax-Self.FPageListSwitchingProgress;
//        end
//        else
//        begin
////          CanInertiaScroll:=False;
//          InertiaDistance:=0;//APageListSwitchingProgressMax-Self.FPageListSwitchingProgress;
//        end;
////        if InertiaDistance<0 then InertiaDistance:=0;
////        EndTimesCount:=3;//Ceil(EndTimesCount*3/4);
//      end
////      else
////      begin
////        InertiaDistance:=-1;
////      end
//      ;
//
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoControlGestureManagerInertiaScrollAnimateEnd(Sender: TObject;
//  var CanStartScrollToInitial: Boolean;
//  var AMinOverRangePosValue_Min:Double;
//  var AMaxOverRangePosValue_Min:Double);
//var
//  APageListSwitchingProgressMax:Double;
//begin
//  if FCanGestureSwitch then
//  begin
//      if (Self.PageCount>0) then
//      begin
//
//        //计算惯性滚动的距离
//        APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(FUserStopDragSwitchToPageIndex);
//        if APageListSwitchingProgressMax>Self.GetPageListSwitchingProgressMax(PageIndex) then
//        begin
//          APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(PageIndex);
//        end;
//
//
//        if (FUserStopDragPageListSwitchingProgress>CalcCanGestureSwitchDistance(APageListSwitchingProgressMax))
////          and (FUserStopDragPageListSwitchingProgress<APageListSwitchingProgressMax)
//          and (FUserStopDragSwitchToPageIndex<>-1) then
//        begin
//
//
//
//          if (Self.FControlGestureManager.MaxOverRangePosValue>0)
//            then
//          begin
//            CanStartScrollToInitial:=False;
//
//            if SmallerDouble(Self.FControlGestureManager.MaxOverRangePosValue,APageListSwitchingProgressMax/Self.FControlGestureManager.FOverRangePosValueStep) then
//            begin
//              Self.FControlGestureManager.CustomStartScrollToInitial(0,
//                      Self.FControlGestureManager.MaxOverRangePosValue,
//                      0,
//                      APageListSwitchingProgressMax/Self.FControlGestureManager.FOverRangePosValueStep);
//            end
//            else
//            begin
//              Self.FControlGestureManager.DoScrollToInitialAnimateEnd(Self);
//            end;
//          end
//          else
//          if (Self.FControlGestureManager.MinOverRangePosValue>0)
//            then
//          begin
//            CanStartScrollToInitial:=False;
//            if SmallerDouble(Self.FControlGestureManager.MinOverRangePosValue,APageListSwitchingProgressMax/Self.FControlGestureManager.FOverRangePosValueStep) then
//            begin
//              Self.FControlGestureManager.CustomStartScrollToInitial(Self.FControlGestureManager.MinOverRangePosValue,
//                      0,
//                      APageListSwitchingProgressMax/Self.FControlGestureManager.FOverRangePosValueStep,
//                      0);
//            end
//            else
//            begin
//              Self.FControlGestureManager.DoScrollToInitialAnimateEnd(Self);
//            end;
//          end;
//        end;
//
//      end;
//  end;
//
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoControlGestureManagerMaxOverRangePosValueChange(Sender: TObject;
//  NextValue, LastValue: Double;
//  Step: Double;
//  var NewValue: Double; var CanChange: Boolean);
//var
//  APageListSwitchingProgressMax:Double;
//  AUserStopDragSwitchToPageIndex:Integer;
//begin
//  //向左拖动事件,或向下拖动
//  if FCanGestureSwitch then
//  begin
//    //水平滚动条是否是当前可以切换的滚动条
//    FIsGestureSwitching:=True;
//
//
//    //移回来
//    AUserStopDragSwitchToPageIndex:=GetAfterPriorPageIndex(Self.PageIndex);
//
//    //计算惯性滚动的距离
//    APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(AUserStopDragSwitchToPageIndex);
//    if APageListSwitchingProgressMax>Self.GetPageListSwitchingProgressMax(PageIndex) then
//    begin
//      APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(PageIndex);
//    end;
//
//
//
//
//    //在没有启动的时候切换顺序
//    if not Self.FControlGestureManager.InertiaScrollAnimator.IsRuning
//      and not Self.FControlGestureManager.ScrollingToInitialAnimator.IsRuning then
//    begin
//      Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;
//    end;
//
//      //如果是最后一张,需要加大拖动难度
//      if PageCount>0 then
//      begin
//        if (Self.PageIndex=Self.PageCount-1)
//          and (not Self.FGestureSwitchLooped)
//          then
//        begin
//          Self.FControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
//        end
//        else
//        begin
//          if //FHardGestureSwitch
//            (Self.GetPageWidth(PageIndex)>Self.GetPageWidth(PageIndex+1))
//            then
//          begin
//            Self.FControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
//          end
//          else
//          begin
//            Self.FControlGestureManager.FOverRangePosValueStep:=1;
//          end;
//        end;
//      end
//      else
//      begin
//        Self.FControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
//      end;
//
//
////      Self.FPageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetMoveHorz;
//
//
//      if FIsFirstUserDrag then//and (FPageListSwitchingProgress>0) then
//      begin
//        FIsFirstUserDrag:=False;
////        NewValue:=FPageListSwitchingProgress;
//      end;
//
//      Self.FPageListSwitchingProgress:=Self.FControlGestureManager.CalcOverRangePosValue(NewValue);
//      if FPageListSwitchingProgress>APageListSwitchingProgressMax then
//      begin
//        //不能越界
//        NewValue:=APageListSwitchingProgressMax/Self.FControlGestureManager.FOverRangePosValueStep;
//      end;
//      Self.DoPageListSwitchingProgressChange;
//
////      uBaseLog.OutputDebugString(FormatDateTime('HH:MM:SS ZZZ',Now));
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoControlGestureManagerMinOverRangePosValueChange(Sender: TObject;
//  NextValue, LastValue: Double; Step: Double;
//  var NewValue: Double; var CanChange: Boolean);
//var
//  APageListSwitchingProgressMax:Double;
//  AUserStopDragSwitchToPageIndex:Integer;
//begin
//  //向右拖动事件,或向上拖动
//  if FCanGestureSwitch then
//  begin
//      FIsGestureSwitching:=True;
//
//      //移回来
//      AUserStopDragSwitchToPageIndex:=GetAfterPriorPageIndex(Self.PageIndex);
//
//      //计算惯性滚动的距离
//      APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(AUserStopDragSwitchToPageIndex);
//      if APageListSwitchingProgressMax>Self.GetPageListSwitchingProgressMax(PageIndex) then
//      begin
//        APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(PageIndex);
//      end;
//
//
//      //在没有启动的时候切换顺序
//      if not Self.FControlGestureManager.InertiaScrollAnimator.IsRuning
//        and not Self.FControlGestureManager.ScrollingToInitialAnimator.IsRuning then
//      begin
//        Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;
//      end;
//
//
//      //如果是最后一张,需要加大拖动难度
//      if (Self.PageCount>0) then
//      begin
//        if (Self.PageIndex=0)
//          and (not Self.FGestureSwitchLooped)
//          then
//        begin
//          Self.FControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
//        end
//        else
//        begin
//          //移动的距离超过宽度的时候,也需要难拉一点
//          if //FHardGestureSwitch
//            (Self.GetPageWidth(PageIndex)>Self.GetPageWidth(PageIndex-1))
//             then
//          begin
//            Self.FControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
//          end
//          else
//          begin
//            Self.FControlGestureManager.FOverRangePosValueStep:=1;
//          end;
//
//
//        end;
//      end
//      else
//      begin
//        Self.FControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
//      end;
//
////      Self.FPageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetMoveHorz;
//
//      if FIsFirstUserDrag then//and (FPageListSwitchingProgress>0) then
//      begin
//        FIsFirstUserDrag:=False;
////        NewValue:=FPageListSwitchingProgress;
//      end;
//
//      Self.FPageListSwitchingProgress:=Self.FControlGestureManager.CalcOverRangePosValue(NewValue);
//      if FPageListSwitchingProgress>APageListSwitchingProgressMax then
//      begin
//        //不能越界
//        NewValue:=APageListSwitchingProgressMax/Self.FControlGestureManager.FOverRangePosValueStep;
//      end;
//      Self.DoPageListSwitchingProgressChange;
//
////      uBaseLog.OutputDebugString(FormatDateTime('HH:MM:SS ZZZ',Now));
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoControlGestureManagerScrollToInitialAnimateEnd(Sender: TObject);
//var
//  APageListSwitchingProgressMax:Double;
//begin
//  //计算惯性滚动的距离
//  APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(FUserStopDragSwitchToPageIndex);
//  if APageListSwitchingProgressMax>Self.GetPageListSwitchingProgressMax(PageIndex) then
//  begin
//    APageListSwitchingProgressMax:=Self.GetPageListSwitchingProgressMax(PageIndex);
//  end;
//
//  if (FUserStopDragPageListSwitchingProgress>CalcCanGestureSwitchDistance(Self.GetPageListSwitchingProgressMax(FUserStopDragSwitchToPageIndex)))
//    and (FUserStopDragSwitchToPageIndex<>-1) then
//  begin
//
//    Self.FPageIndex:=FUserStopDragSwitchToPageIndex;
//    DoPageIndexChange;
//
//    DoPageListSwitchEnd;
//  end;
//
//  Self.FIsGestureSwitching:=False;
//  Self.FIsFirstUserDrag:=True;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetPageCount(const Value: Integer);
//begin
//  if FPageCount<>Value then
//  begin
//    FPageCount := Value;
//    Self.DoPageCountChanged(Self);
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetPageIndex(const Value: Integer);
//begin
//  if FPageIndex<>Value then
//  begin
//    if (FPageIndex>-1) and (FPageIndex<PageCount) then
//    begin
//      Self.SwitchPage(FPageIndex,Value);
//    end
//    else
//    begin
//      FPageIndex := Value;
//
//      Self.DoPageIndexChange;
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetPageListAnimated(const Value: Boolean);
//begin
//  if FPageListAnimated<>Value then
//  begin
//    FPageListAnimated := Value;
//    if FPageListAnimated then
//    begin
//      Self.CreatePageListAnimateTimer;
//      if Self.FPageListAnimateTimer<>nil then
//      begin
//        Self.FPageListAnimateTimer.Enabled:=True;
//      end;
//    end
//    else
//    begin
//      if Self.FPageListAnimateTimer<>nil then
//      begin
//        Self.FPageListAnimateTimer.Enabled:=False;
//      end;
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetPageListSwitchEffectType(const Value: TAnimateSwitchEffectType);
//begin
//  if FPageListSwitchEffectType<>Value then
//  begin
//    FPageListSwitchEffectType := Value;
//    case FPageListSwitchEffectType of
//      ilasetNone: ;
//      ilasetMoveHorz:
//      begin
//        Self.FControlGestureManager.Kind:=TGestureKind.gmkHorizontal;
//      end;
//      ilasetMoveVert:
//      begin
//        Self.FControlGestureManager.Kind:=TGestureKind.gmkVertical;
//      end;
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetPageListSwitching(const Value: Boolean);
//begin
//  if FPageListSwitching<>Value then
//  begin
//    //当前是否正在切换
//    FPageListSwitching := Value;
//
//    if FPageListSwitching then
//    begin
//      //开始切换
//      Self.CreatePageListSwitchingTimer;
//      if Self.FPageListSwitchingTimer<>nil then
//      begin
//        Self.FPageListSwitchingTimer.Enabled:=True;
//      end;
//    end
//    else
//    begin
//      //停正切换
//      if Self.FPageListSwitchingTimer<>nil then
//      begin
//        Self.FPageListSwitchingTimer.Enabled:=False;
//      end;
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetPageListAnimateSpeed(const Value: Double);
//begin
//  if FPageListAnimateSpeed<>Value then
//  begin
//    FPageListAnimateSpeed := Value;
//    if Self.FPageListAnimateTimer<>nil then
//    begin
//      Self.FPageListAnimateTimer.Interval:=Ceil(FPageListAnimateSpeed*10);
////      Self.FPageListAnimateTimer.Enabled:=Self.FPageListAnimated;
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SetPageListSwitchingSpeed(const Value: Double);
//begin
//  if FPageListSwitchingSpeed<>Value then
//  begin
//    FPageListSwitchingSpeed := Value;
//    if Self.FPageListSwitchingTimer<>nil then
//    begin
//      Self.FPageListSwitchingTimer.Interval:=Ceil(FPageListSwitchingSpeed*10);
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SwitchNext;
//var
//  ABeginPageIndex:Integer;
//  AAfterPageIndex:Integer;
//begin
//  //如果当前正在切换,那么不处理
//  if Self.FPageListSwitching then Exit;
//
//  if FCanGestureSwitch then
//  begin
//    //当前正在拖动,那么也不处理
//    if Self.FControlGestureManager.IsMouseDown then Exit;
//    if Self.FControlGestureManager.IsDraging then Exit;
//    if Self.FControlGestureManager.ScrollingToInitialAnimator.IsRuning then Exit;
//    if Self.FControlGestureManager.InertiaScrollAnimator.IsRuning then Exit;
//  end;
//
//
//  if (Self.PageCount>1) then
//  begin
//
//    //当前显示的分页下标
//    ABeginPageIndex:=Self.PageIndex;
//    //下一张显示的分页下标
//    AAfterPageIndex:=ABeginPageIndex;
//    case GetCurrentSwitchOrderType of
//      ilaotAsc:
//      begin
//        //顺序
//        AAfterPageIndex:=GetAfterNextPageIndex(AAfterPageIndex);
//      end;
//      ilaotDesc:
//      begin
//        //倒序
//        AAfterPageIndex:=GetAfterPriorPageIndex(AAfterPageIndex);
//      end;
//    end;
//
//
////    if FPageListSwitchEffectType<>TAnimateSwitchEffectType.ilasetNone then
////    begin
////      FPageListSwitchEffectType:=Self.FPageListSwitchEffectType;
////    end;
//
//
//    if (Self.FPageListAnimateOrderType<>TAnimateOrderType.ilaotNone)
//      and (ABeginPageIndex<>AAfterPageIndex) then
//    begin
//      Self.SwitchPage(ABeginPageIndex,AAfterPageIndex);
//    end;
//
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SwitchPage(ABeginPageIndex: Integer;AAfterPageIndex:Integer);
//begin
//  //判断是否合法
//  if (Self.PageCount>0)
//    and (ABeginPageIndex<>AAfterPageIndex) then
//  begin
//
//    //当前显示的分页下标
//    FCurrentSwitchCurrentPageIndex:=ABeginPageIndex;
//    //下一个显示的分页下标
//    FCurrentSwitchAfterPageIndex:=AAfterPageIndex;
//
//
//
//
//    case FPageListAnimateOrderType of
//      ilaotNone: ;
//      ilaotAsc:
//      begin
//        //判断切换方向
//        if (FCurrentSwitchCurrentPageIndex<FCurrentSwitchAfterPageIndex)
//          or
//            //顺序,当前是第一张分页,切换到最后一张
//            (FCurrentSwitchCurrentPageIndex=Self.PageCount-1) and (FCurrentSwitchAfterPageIndex=0)
//             then
//        begin
//          FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;
//        end
//        else
//        begin
//          FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;
//        end;
//      end;
//      ilaotDesc:
//      begin
//        //判断切换方向
//        if (FCurrentSwitchCurrentPageIndex<FCurrentSwitchAfterPageIndex)
//          and
//          not ((FCurrentSwitchCurrentPageIndex=0) and (FCurrentSwitchAfterPageIndex=Self.PageCount-1)) then
//        begin
//          FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;
//        end
//        else
//        begin
//          FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;
//        end;
//      end;
//    end;
//
//
//
//
//    //开始切换
//    Self.SetPageListSwitching(True);
//
//
//  end;
//
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.SwitchPrior;
//var
//  ABeginPageIndex:Integer;
//  AAfterPageIndex:Integer;
//begin
//  //如果当前正在切换,那么不处理
//  if Self.FPageListSwitching then Exit;
//
//  if FCanGestureSwitch then
//  begin
//    //当前正在拖动,那么也不处理
//    if Self.FControlGestureManager.IsMouseDown then Exit;
//    if Self.FControlGestureManager.IsDraging then Exit;
//    if Self.FControlGestureManager.ScrollingToInitialAnimator.IsRuning then Exit;
//    if Self.FControlGestureManager.InertiaScrollAnimator.IsRuning then Exit;
//  end;
//
//
//  if (Self.PageCount>1) then
//  begin
//
//    //当前显示的分页下标
//    ABeginPageIndex:=Self.PageIndex;
//    //下一张显示的分页下标
//    AAfterPageIndex:=ABeginPageIndex;
//    case GetCurrentSwitchOrderType of
//      ilaotAsc:
//      begin
//        //顺序
//        AAfterPageIndex:=GetAfterPriorPageIndex(AAfterPageIndex);
//      end;
//      ilaotDesc:
//      begin
//        //倒序
//        AAfterPageIndex:=GetAfterNextPageIndex(AAfterPageIndex);
//      end;
//    end;
//
//
////    if FPageListSwitchEffectType<>TAnimateSwitchEffectType.ilasetNone then
////    begin
////      FPageListSwitchEffectType:=Self.FPageListSwitchEffectType;
////    end;
//
//
//    if (Self.FPageListAnimateOrderType<>TAnimateOrderType.ilaotNone)
//      and (ABeginPageIndex<>AAfterPageIndex) then
//    begin
//      Self.SwitchPage(ABeginPageIndex,AAfterPageIndex);
//    end;
//
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.AlignPageListSwitchButtons;
//begin
//  if (Self.GetSwitchButtonGroup<>nil) then
//  begin
//    Self.GetSwitchButtonGroupIntf.FixChildButtonCount(Self.PageCount,
//                                  Self.PageIndex,
//                                  DoPageListSwitchButtonClick);
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoPageListSwitchButtonClick(Sender: TObject);
//begin
//  //图标列表切换按钮按下
//  Self.SwitchPage(Self.PageIndex,((Sender as TChildControl) as ISkinButton).Properties.ButtonIndex);
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoPageCountChanged(Sender: TObject);
//begin
//  //排列分页列表切换按钮
//  Self.AlignPageListSwitchButtons;
//  if Assigned(FOnPageCountChange) then
//  begin
//    FOnPageCountChange(Self);
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoPageIndexChange;
//begin
//  if Assigned(Self.OnPageIndexChange) then
//  begin
//    Self.OnPageIndexChange(Self,FPageIndex);
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetCurrentAfterPageIndex: Integer;
//begin
//  Result:=-1;
//  if Self.PageCount=0 then Exit;
//
//  case Self.GetCurrentSwitchOrderType of
//    ilaotAsc:
//    begin
//      Result:=GetAfterNextPageIndex(Self.PageIndex);
//    end;
//    ilaotDesc:
//    begin
//      Result:=GetAfterPriorPageIndex(Self.PageIndex);
//    end;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetCurrentBeforePageIndex: Integer;
//begin
//  Result:=-1;
//  if Self.PageCount=0 then Exit;
//
//  case Self.GetCurrentSwitchOrderType of
//    ilaotAsc:
//    begin
//      Result:=GetAfterPriorPageIndex(Self.PageIndex);
//    end;
//    ilaotDesc:
//    begin
//      Result:=GetAfterNextPageIndex(Self.PageIndex);
//    end;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetCurrentCurrentPageIndex: Integer;
//begin
//  Result:=-1;
//  if Self.FCurrentSwitchCurrentPageIndex<>-1 then
//  begin
//    Result:=Self.FCurrentSwitchCurrentPageIndex;
//  end
//  else
//  begin
////    case Self.FPageListSwitchEffectType of
////      ilasetNone: ;
////      ilasetMoveHorz,ilasetMoveVert:
////      begin
////        case Self.GetCurrentSwitchOrderType of
////          ilaotAsc:
////          begin
////            Result:=Self.PageIndex;
////          end;
////          ilaotDesc:
////          begin
//            Result:=Self.PageIndex;
////          end;
////        end;
////      end;
////    end;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetCurrentCanGestureScrollBarKind: TScrollBarKind;
//begin
//  Result:=TScrollBarKind.sbHorizontal;
//  case Self.FPageListSwitchEffectType of
//    TAnimateSwitchEffectType.ilasetMoveVert:
//    begin
//      Result:=TScrollBarKind.sbVertical;
//    end;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetCurrentSwitchOrderType: TAnimateOrderType;
//begin
//  Result:=ilaotNone;
//  if Self.FCurrentSwitchOrderType<>ilaotNone then
//  begin
//    Result:=FCurrentSwitchOrderType;
//  end
//  else
//  begin
//    Result:=Self.FPageListAnimateOrderType;
//  end;
////  //
////  case FCurrentSwitchOrderType of
////    ilaotNone: ;
////    ilaotAsc: OutputDebugString('顺序');
////    ilaotDesc: OutputDebugString('逆序');
////  end;
//
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageListSwitchingBeforePageDrawRect(const ADrawRect: TRectF): TRectF;
//begin
//  Result:=ADrawRect;
//  case Self.FPageListSwitchEffectType of
//    ilasetNone: ;
//    ilasetMoveHorz:
//    begin
//      case GetCurrentSwitchOrderType of
//        ilaotAsc:
//        begin
//          Result.Left:=Result.Left-FPageListSwitchingProgress-RectWidthF(ADrawRect);
//          Result.Right:=Result.Left+RectWidthF(ADrawRect);
//        end;
//        ilaotDesc:
//        begin
//          Result.Left:=Result.Left+FPageListSwitchingProgress+RectWidthF(ADrawRect);
//          Result.Right:=Result.Left+RectWidthF(ADrawRect);
//        end;
//      end;
//    end;
//    ilasetMoveVert:
//    begin
//      case GetCurrentSwitchOrderType of
//        ilaotAsc:
//        begin
//          Result.Top:=Result.Top-FPageListSwitchingProgress-RectHeightF(ADrawRect);
//          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
//        end;
//        ilaotDesc:
//        begin
//          Result.Top:=Result.Top+FPageListSwitchingProgress+RectHeightF(ADrawRect);
//          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
//        end;
//      end;
//    end;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageListSwitchingCurrentPageDrawRect(const ADrawRect: TRectF): TRectF;
//begin
//  Result:=ADrawRect;
//  case Self.FPageListSwitchEffectType of
//    ilasetNone: ;
//    ilasetMoveHorz:
//    begin
//      case GetCurrentSwitchOrderType of
//        ilaotAsc:
//        begin
//          Result.Left:=Result.Left-FPageListSwitchingProgress;
//          Result.Right:=Result.Left+RectWidthF(ADrawRect);
//        end;
//        ilaotDesc:
//        begin
//          Result.Left:=Result.Left+FPageListSwitchingProgress;
//          Result.Right:=Result.Left+RectWidthF(ADrawRect);
//        end;
//      end;
//    end;
//    ilasetMoveVert:
//    begin
//      case GetCurrentSwitchOrderType of
//        ilaotAsc:
//        begin
//          Result.Top:=Result.Top-FPageListSwitchingProgress;
//          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
//        end;
//        ilaotDesc:
//        begin
//          Result.Top:=Result.Top+FPageListSwitchingProgress;
//          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
//        end;
//      end;
//    end;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageListSwitchingProgressMax(Index:Integer): Double;
//begin
//  Result:=100;
//  case FPageListSwitchEffectType of
//    ilasetNone: ;
//    ilasetMoveHorz:
//    begin
//      Result:=Self.GetPageWidth(Index);
//    end;
//    ilasetMoveVert:
//    begin
//      Result:=Self.GetPageHeight(Index);
//    end;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetAfterNextPageIndex(APageIndex: Integer): Integer;
//begin
//  if Self.PageCount>1 then
//  begin
//    if (APageIndex+1>Self.PageCount-1) then
//    begin
//      if Self.FIsGestureSwitching and (not Self.FGestureSwitchLooped) then
//      begin
//        Result:=-1;
//      end
//      else
//      begin
//        Result:=0;
//      end;
//    end
//    else
//    begin
//      Result:=APageIndex+1;
//    end;
//  end
//  else
//  begin
//    Result:=-1;
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetAfterPriorPageIndex(APageIndex: Integer): Integer;
//begin
//  if Self.PageCount>1 then
//  begin
//    if (APageIndex-1<0) then
//    begin
//      if Self.FIsGestureSwitching and (not Self.FGestureSwitchLooped) then
//      begin
//        Result:=-1;
//      end
//      else
//      begin
//        Result:=Self.PageCount-1;
//      end;
//    end
//    else
//    begin
//      Result:=APageIndex-1;
//    end;
//  end
//  else
//  begin
//    Result:=-1;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.InitControlGestureManagerOverrangePosValue;
//begin
//  if Self.FIsFirstUserDrag then//and (Self.FPageListSwitchingProgress>0) then
//  begin
//    FIsFirstUserDrag:=False;
//    case FPageListSwitchEffectType of
//      ilasetNone: ;
//      ilasetMoveHorz,ilasetMoveVert:
//      begin
//        case Self.FPageListAnimateOrderType of
//          ilaotNone: ;
//          ilaotAsc:
//          begin
//            Self.FControlGestureManager.MaxOverRangePosValue:=FPageListSwitchingProgress;
//          end;
//          ilaotDesc:
//          begin
//            Self.FControlGestureManager.MinOverRangePosValue:=FPageListSwitchingProgress;
//          end;
//        end;
//      end;
//    end;
//  end;
//end;
//
//procedure TSkinSwitchPageListControlGestureManager.DoPageListSwitchEnd;
//begin
//  FCurrentSwitchAfterPageIndex:=-1;
//  Self.FPageListSwitchingProgress:=0;
//  Self.FCurrentSwitchCurrentPageIndex:=-1;
//  FUserStopDragPageListSwitchingProgress:=0;
//  Self.FUserStopDragSwitchToPageIndex:=-1;
//
//  Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotNone;
//  Self.FControlGestureManager.MinOverRangePosValue:=0;
//  Self.FControlGestureManager.MaxOverRangePosValue:=0;
//
//
//
//  DoPageIndexChange;
//  Self.SetPageListSwitching(False);
//
//
//  Self.AlignPageListSwitchButtons;
//
//
//  Self.DoPageListSwitchingProgressChange;
//
//
//  if Assigned(Self.OnSwitchPageListEnd) then
//  begin
//    Self.OnSwitchPageListEnd(Self);
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageCount: Integer;
//begin
//  if Assigned(FOnGetPageCount) then
//  begin
//    FOnGetPageCount(Self,FPageCount);
//  end;
//  Result:=FPageCount;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageIndexControl(const APageIndex:Integer): TControl;
//begin
//  Result:=nil;
//  if (APageIndex>=0) and (APageIndex<PageCount) and Assigned(FOnGetPageControl) then
//  begin
//    FOnGetPageControl(Self,APageIndex,Result);
//  end;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageIndex: Integer;
//begin
//  if Assigned(FOnGetPageIndex) then
//  begin
//    FOnGetPageIndex(Self,FPageIndex);
//  end;
//  Result:=FPageIndex;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageWidth(Index:Integer): Double;
//begin
//  if Assigned(FOnGetPageWidth) then
//  begin
//    FOnGetPageWidth(Self,Index,FPageWidth);
//  end;
//  Result:=FPageWidth;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageHeight(Index:Integer): Double;
//begin
//  if Assigned(FOnGetPageHeight) then
//  begin
//    FOnGetPageHeight(Self,Index,FPageHeight);
//  end;
//  Result:=FPageHeight;
//end;
//
//function TSkinSwitchPageListControlGestureManager.GetPageListSwitchingAfterPageDrawRect(const ADrawRect: TRectF): TRectF;
//begin
//  Result:=ADrawRect;
//  case Self.FPageListSwitchEffectType of
//    ilasetNone: ;
//    ilasetMoveHorz:
//    begin
//      case GetCurrentSwitchOrderType of
//        ilaotAsc:
//        begin
//          Result.Left:=Result.Right-FPageListSwitchingProgress;
//          Result.Right:=Result.Left+RectWidthF(ADrawRect);
////          if Self.FCurrentSwitchAfterPageIndex<>-1 then
////          begin
////            Result.Left:=Result.Left++Self.GetPageWidth(FCurrentSwitchAfterPageIndex);
////          end;
//        end;
//        ilaotDesc:
//        begin
//          Result.Left:=Result.Left-RectWidthF(ADrawRect)+FPageListSwitchingProgress;
//          Result.Right:=Result.Left+RectWidthF(ADrawRect);
//
//        end;
//      end;
//    end;
//    ilasetMoveVert:
//    begin
//      case GetCurrentSwitchOrderType of
//        ilaotAsc:
//        begin
//          Result.Top:=Result.Bottom-FPageListSwitchingProgress;
//          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
//        end;
//        ilaotDesc:
//        begin
//          Result.Top:=Result.Top-RectHeightF(ADrawRect)+FPageListSwitchingProgress;
//          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
//        end;
//      end;
//    end;
//  end;
//end;


end.

