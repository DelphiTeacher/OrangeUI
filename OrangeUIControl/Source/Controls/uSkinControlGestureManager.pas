//convert pas to utf8 by ¥

/// <summary>
///   手势管理
/// </summary>
unit uSkinControlGestureManager;


interface
{$I FrameWork.inc}



uses
  Classes,
  Types,
  DateUtils,
  SysUtils,
  uBaseList,
  uFuncCommon,
  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  ExtCtrls,
  Forms,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Types,
  UITypes,
  FMX.Forms,
  FMX.Controls,
  System.Generics.Collections,
  {$ENDIF}
  Math,
  uBaseLog,
  uComponentType,
  uGraphicCommon,
  uSkinAnimator;





const
  //默认的速度
  Const_Deafult_AnimatorSpeed=1.0;

//  IID_ISetControlGestureManager:TGUID='{F90C0399-D52E-4017-BA33-B3D27D51A75C}';




type
//FireMonkey Advanced Platform-Independent Scrolling Engine
//Scrolling under iOS is more sophisticated than the default scrolling under Windows.
//The TSkinControlGestureManager class provides the universal scrolling engine supporting all iOS scrolling features.
//The TSkinControlGestureManager scrolling engine provides the same physical scrolling features under all platforms supported by FireMonkey.
//By default, on each platform the TSkinControlGestureManager scrolling engine gets scrolling behavior properties that provide the standard scrolling behavior for the platform.
//But you can programmatically set values of scrolling properties,
//which emulate scrolling behavior typical for other platforms.
//For example, you can select emulation of iOS scrolling behavior under Windows and vice versa.
//Here are some of the scrolling parameters that you can set or specify:
//Whether the scrolling is animated (FMX.InertialMovement.TSkinControlGestureManager.Animation).
//The deceleration rate shown by the animation (FMX.InertialMovement.TSkinControlGestureManager.DecelerationRate)
//Whether the scrolling animation is bound to the area (FMX.InertialMovement.TSkinControlGestureManager.BoundsAnimation)
//Whether the scrolling bars appear automatically when scrolling is initiated (FMX.InertialMovement.TSkinControlGestureManager.AutoShowing)
//Whether the scrolling bars are hidden automatically when they are not needed (FMX.InertialMovement.TSkinControlGestureManager.Shown)






  //坐标计算
  TPointD = record
  public
    X: Double;
    Y: Double;
  public
    constructor Create(const P: TPointD); overload;
    constructor Create(const P: TPointF); overload;
//    constructor Create(const P: TPoint); overload;
    constructor Create(const X, Y: Double); overload;
  public
    procedure SetLocation(const P: TPointD);
    //是否相等
    class operator Equal(const Lhs, Rhs: TPointD): Boolean;
    //是否不相等
    class operator NotEqual(const Lhs, Rhs: TPointD): Boolean; overload;
    //添加
    class operator Add(const Lhs, Rhs: TPointD): TPointD;
    //相减
    class operator Subtract(const Lhs, Rhs: TPointD): TPointD;
    //引入
    class operator Implicit(const APointF: TPointF): TPointD;
    //距离
    function Distance(const P2: TPointD): Double;
    //平方根
    function Abs: Double;
    //加上偏移
    procedure Offset(const DX, DY: Double);
  end;













  //目标类型
  TTargetType = (
              ttAchieved, //到达,0
              ttMax,      //最大值,1
              ttMin,      //最小值,2
              ttOther);   //其他,3,MouseWheel

//    TTargetTypeHelper = record helper for TTargetType
//    const
//      ttAchieved = TTargetType.Achieved deprecated 'Use TTargetType.Achieved';
//      ttMax = TTargetType.Max deprecated 'Use TTargetType.Max';
//      ttMin = TTargetType.Min deprecated 'Use TTargetType.Min';
//      ttOther = TTargetType.Other deprecated 'Use TTargetType.Other';
//    end;
  //目标,
  TTarget = record
    //方向
    TargetType: TTargetType;
    //点
    Point: TPointD;
  end;







  //坐标时间点
  TPointTime = record
    //坐标
    Point: TPointD;
    //时间
    Time: TDateTime;
  end;
  PPointTime=^TPointTime;

  //坐标时间点列表
  TPointTimeList=class
  private
    FItems:TList;
    function GetItem(Index: Integer): TPointTime;
    procedure SetItem(Index: Integer; const Value: TPointTime);
  public
    constructor Create;
    destructor Destroy;override;
  public
    procedure Clear;
    procedure Delete(Index:Integer);
    function Count:Integer;
    procedure Add(APointTime:TPointTime);
    property Items[Index:Integer]:TPointTime read GetItem write SetItem;default;
  end;














  //不确定方向、水平方向还是垂直方向
  TGestureKind=(gmkNone,
                gmkHorizontal,
                gmkVertical
                );


  //手势的方向:不确定、往最小值方向、往最大值方向
  //用于惯性滚动时往哪个方向滚
  TGestureDirection=(isdNone,
                      //往左移
                      isdScrollToMin,
                      //往右移
                      isdScrollToMax);
  TGestureDirections=set of TGestureDirection;



//  //键盘按键加速事件
//  TKeyPressAdjustSpeedType=(kpastAdd,
//                            kpastDec);



  //可以越界的类型
  TCanOverRangeType=(
                     cortMin,
                     cortMax
                     );
  //越界类型集合
  TCanOverRangeTypes=set of TCanOverRangeType;




  //惯性滚动结束事件(用于下拉刷新)
  TInertiaScrollAnimateEndEvent=procedure(Sender:TObject;
                                          var CanStartScrollToInitial:Boolean;
                                          var AMinOverRangePosValue_Min:Double;
                                          var AMaxOverRangePosValue_Min:Double) of object;

  //越界值更改事件(用于下拉刷新)
  TOverRangePosValueChangeEvent=procedure(Sender:TObject;
                                          NextValue:Double;     //下一值
                                          LastValue:Double;     //上一值
                                          Step:Double;          //
                                          var NewValue:Double;  //当前值
                                          var CanChange:Boolean  //是否可以更改
                                          ) of object;
  //计算惯性滚动的距离(用于页面切换)
  TCalcInertiaScrollDistanceEvent=procedure(Sender:TObject;
                                            var InertiaDistance:Double;  //惯性滚动的距离
                                            var CanInertiaScroll:Boolean //是否可以惯性滚动
                                            ) of object;

  TMouseEvent=procedure(Sender:TObject;X,Y:Double) of object;

  TPrepareDecidedFirstGestureKindEvent=procedure(Sender:TObject;
                                                 AMouseMoveX:Double;
                                                 AMouseMoveY:Double;
                                                 var AIsDecidedFirstGestureKind:Boolean;
                                                 var ADecidedFirstGestureKind:TGestureKind
                                                 ) of object;


  {$IFDEF VCL}
  TTouchTracking = set of (ttVertical, ttHorizontal);
  {$ENDIF}





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinControlGestureManager=class(TComponent)
  Private
    {$REGION Delphi中自带}
    //是否启用
    FEnabled: Boolean;

    //是否在调用TimerProc中
    FInTimerProc: Boolean;


    //触摸跟踪的类型
    FTouchTracking: TTouchTracking;
    //跟踪的时间间隔
    FInterval: Integer;
    //当前的速度
    FCurrentVelocity: TPointD;

    //弹起的速度和视图位置,时间
    FUpVelocity: TPointD;
    FUpPosition: TPointD;
    FUpDownTime: TDateTime;

    //上次计算速度的时间
    FLastTimeCalc: TDateTime;

    FTimer:TPlatformTimer;

    //记录下的时间点列表
    FPointTimeList: TPointTimeList;

    //多个目标点方向
    FTargets: array of TTarget;
    //最小值越界的方向位置
    FMinTarget: TTarget;
    //最大值越界的方向位置
    FMaxTarget: TTarget;
    //当前的方向和位置
    FTarget: TTarget;
    //上次的方向
    FLastTarget: TTarget;

//    //取消的X,Y
//    FCancelTargetX: Boolean;
//    FCancelTargetY: Boolean;
//    FEnableTargetX: Boolean;
//    FEnableTargetY: Boolean;

//    //开始
//    FOnStart: TNotifyEvent;
//    //进行
//    FOnTimer: TNotifyEvent;
//    //结束
//    FOnStop: TNotifyEvent;





    //是否鼠标按下
    FDown: Boolean;
    //按下的坐标
    FDownPoint: TPointD;
    //按下的视图位置
    FDownPosition: TPointD;

//    //惯性效果
//    FAnimation: Boolean;

    //当前视图的位置
    FViewportPosition: TPointD;

    //低速改变,最后一次调用TimeProc
    FLowChanged: Boolean;

    //上次调用Changed的时间
    FLastTimeChanged: TDateTime;


    FUpdateTimerCount: ShortInt;
    //更新计数
    FUpdateCount: Integer;


//    //弹性
//    FElasticity: Double;
//    //灵活性
//    FElasticityFactor: TPoint;
    //减速
    FDecelerationRate: Double;
    //越界时减速
    FOverRangeDecelerationRate:Double;


    //PointerTime的存储时间限制
    FStorageTime: Double;

//    //在调用Start或Stop
//    FInDoStart: Boolean;
//    FInDoStop: Boolean;



    //鼠标移动过了
    FMoved: Boolean;

    //是否启动了
    FStarted: Boolean;



//    //回弹效果
//    FBoundsAnimation: Boolean;


    //自动显示
    FAutoShowing: Boolean;

    //透明度(自动显示隐藏)
    FOpacity: Single;

    //是否显示滚动条
    FShown: Boolean;

    //鼠标的方向和位置
    FMouseTarget: TTarget;
    //计算平均值(如果是触摸状态,则使用平均值,FPointTimeList)
    FAveraging: Boolean;

    //惯性的力度
    FVelocityPower:Double;

    //最大最小的速度
    FMinVelocity: Double;
    FMaxVelocity: Double;

    //判断是否移动的最大距离
    FDeadZone: Double;

//    //方向
//    FDirection: TGestureDirectionType;

    //启动定时器
    procedure StartTimer;
    //停止计时器
    procedure StopTimer;
    //用来设置位置
    procedure TimerProc(Sender:TObject);
    //更新定时器,判断是否需要启动
    procedure UpdateTimer;
    //定时器间隔
    procedure SetInterval(const Value: Integer);
    procedure SetEnabled(const Value: Boolean);

    //清除一段时间间隔中记录的时间点,0.15秒间隔
    procedure Clear(T: TDateTime = 0);
    //设置触摸的方向
    procedure SetTouchTracking(const Value: TTouchTracking);

//    //计算速度和位置
//    procedure InternalCalc(DeltaTime: Double);
    //启动
    procedure InternalStart;
    //结束
    procedure InternalTerminated;
//    procedure InternalChanged;

//    procedure SetAnimation(const Value: Boolean);
//    procedure SetBoundsAnimation(const Value: Boolean);
    procedure SetDown(const Value: Boolean);
    procedure SetAutoShowing(const Value: Boolean);
    procedure SetShown(const Value: Boolean);
//    function DecelerationRateStored: Boolean;
//    function ElasticityStored: Boolean;
//    function StorageTimeStored: Boolean;

    procedure UpdateTarget;
    function FindTarget(var Target: TTarget): Boolean;
    function GetTargetCount: Integer;
    procedure SetMouseTarget(Value: TTarget);

    //计算速度
    procedure CalcVelocity(const Time: TDateTime = 0);

//    //设置越界值
//    procedure UpdateViewportPositionByBounds;

    function GetViewportPositionF: TPointF;
    procedure SetViewportPositionF(const Value: TPointF);
    procedure SetViewportPosition(const Value: TPointD);


    function GetInternalTouchTracking: TTouchTracking;
    function GetPositions(const Index: Integer): TPointD;
    function GetPositionCount: Integer;
    function GetPositionTimes(const Index: Integer): TDateTime;
    //添加时间点
    function AddPointTime(const X, Y: Double;
                          const Time: TDateTime = 0): TPointTime;

    //透明度
    function GetOpacity: Single;
    //低速
    function GetLowVelocity: Boolean;

    //将坐标转换与视图位置
    function PosToView(const APosition: TPointD): TPointD;

    //超时结束滚动
    function DoStopScrolling(CurrentTime: TDateTime = 0): Boolean;
  protected
//    //立即更改视图位置
//    procedure UpdatePosImmediately(const Force: Boolean = False);
    function IsSmall(const P: TPointD;
                     const Epsilon: Double): Boolean; overload;

    function IsSmall(const P: TPointD): Boolean; overload;

//    function GetOwner: TPersistent; override;
//
//    //调用OnStart
//    procedure DoStart; virtual;
//    //调用OnChange
//    procedure DoChanged; virtual;
//    //调用OnStop
//    procedure DoStop; virtual;
//    //计算下一个视图位置
//    procedure DoCalc(const DeltaTime: Double;
//                       var NewPoint, NewVelocity: TPointD;
//                       var Done: Boolean); virtual;

    property InternalTouchTracking: TTouchTracking read GetInternalTouchTracking;
    property Positions[const index: Integer]: TPointD read GetPositions;
    property PositionTimes[const index: Integer]: TDateTime read GetPositionTimes;

    //跟踪的时间点的个数
    property PositionCount: Integer read GetPositionCount;

    property Target: TTarget read FTarget;
    property MinTarget: TTarget read FMinTarget;
    property MaxTarget: TTarget read FMaxTarget;
    property MouseTarget: TTarget read FMouseTarget write SetMouseTarget;
  protected

    //鼠标弹起的速度
    property UpVelocity: TPointD read FUpVelocity;
    //鼠标弹起的位置
    property UpPosition: TPointD read FUpPosition;

    //鼠标按下弹起的时间
    property UpDownTime: TDateTime read FUpDownTime;

    //惯性力度
    property VelocityPower:Double read FVelocityPower write FVelocityPower;

    property DeadZone: Double read FDeadZone write FDeadZone;// default DefaultDeadZone;

//    property CancelTargetX: Boolean read FCancelTargetX;
//    property CancelTargetY: Boolean read FCancelTargetY;
  public
//    constructor Create(AOwner: TPersistent); virtual;
//    destructor Destroy; override;
    procedure AfterConstruction; override;
//    procedure Assign(Source: TPersistent); override;
//  public
//    //鼠标按下
//    procedure MouseDown(X, Y: Double);
//    procedure MouseMove(X, Y: Double);
//    procedure MouseLeave;
//    procedure MouseUp(X, Y: Double);
//    procedure MouseWheel(X, Y: Double);
  protected


    //是否显示滚动条
    property Shown: Boolean read FShown write SetShown;


//    //动画效果
//    property Animation: Boolean read FAnimation
//                               write SetAnimation default False;
    //自动隐藏显示
    property AutoShowing: Boolean read FAutoShowing
                                 write SetAutoShowing default False;

    //根据所有的PointTimes来计算平均速度
    property Averaging: Boolean read FAveraging
                               write FAveraging default False;
//    //越界效果
//    property BoundsAnimation: Boolean read FBoundsAnimation
//                                     write SetBoundsAnimation default True;
    //间隔
    property Interval: Integer read FInterval
                           write SetInterval;// default DefaultIntervalOfAni;
    //触摸跟踪
    property TouchTracking: TTouchTracking read FTouchTracking
                                          write SetTouchTracking
                                        default [ttVertical, ttHorizontal];
    property TargetCount: Integer read GetTargetCount;

    procedure SetTargets(const ATargets: array of TTarget);
    procedure GetTargets(var ATargets: array of TTarget);

    property OverRangeDecelerationRate: Double read FOverRangeDecelerationRate
                                     write FOverRangeDecelerationRate;

    property DecelerationRate: Double read FDecelerationRate
                                     write FDecelerationRate;
//                                    stored DecelerationRateStored nodefault;
//    property Elasticity: Double read FElasticity
//                               write FElasticity;
//                              stored ElasticityStored nodefault;
    property StorageTime: Double read FStorageTime
                                write FStorageTime;
//                               stored StorageTimeStored nodefault;


    //当前视图位置
    property ViewportPosition: TPointD read FViewportPosition
                                      write SetViewportPosition;
    property ViewportPositionF: TPointF read GetViewportPositionF
                                       write SetViewportPositionF;

    property LastTimeCalc: TDateTime read FLastTimeCalc;
    //鼠标是否按下
    property Down: Boolean read FDown write SetDown;

    //透明度
    property Opacity: Single read GetOpacity;


    property InTimerProc: Boolean read FInTimerProc;

    property Moved: Boolean read FMoved;

    procedure BeginUpdate;
    procedure EndUpdate;

    //刷新计数
    property UpdateCount: Integer read FUpdateCount;
//
//    property OnStart: TNotifyEvent read FOnStart write FOnStart;
//    property OnChanged: TNotifyEvent read FOnTimer write FOnTimer;
//    property OnStop: TNotifyEvent read FOnStop write FOnStop;




  public
    //当前的速度
    property CurrentVelocity: TPointD read FCurrentVelocity;


    //是否启用
    property Enabled: Boolean read FEnabled write SetEnabled;
    //当前的速度是不是很慢了
    property LowVelocity: Boolean read GetLowVelocity;




    //最小的速度
    property MinVelocity: Double read FMinVelocity write FMinVelocity;// default DefaultMinVelocity;
    //最大的速度
    property MaxVelocity: Double read FMaxVelocity write FMaxVelocity;// default DefaultMaxVelocity;


    {$ENDREGION Delphi中自带}

  protected
//    FKeyPressChange: Integer;
//    //按键按下移动
//    FKeyPressScrollAnimator:TSkinAnimator;
//    //按键滚动的方向
//    FKeyPressScrollDirection:TGestureDirection;
//    //按键滚动速度调整的计时器
//    FKeyPressAdjustSpeedTimer:TTimer;
//    FKeyPressAdjustSpeedType:TKeyPressAdjustSpeedType;

//    //按键滚动速度调整的计时器
//    procedure CreateKeyPressAdjustSpeedTimer;
//    procedure OnKeyPressAdjustSpeedTimer(Sender:TObject);
//    //键盘滚动
//    procedure DoKeyPressScrollAnimate(Sender:TObject);
//    function GetKeyPressScrollAnimatorEndTimesCount:Integer;



  protected
    //MyProperties
    //宿主控件,用于获取相对的坐标
    //鼠标移动时坐标计算所用的坐标必须是相对于FParentControl的坐标
    //比如在ScrollContent中调用ScrollBar.MouseMove,
    FParentControl:TComponent;



    FSumInertiaDistance:Double;
    FInertiaDistance:Double;


    //最小值
    FMin:Double;
    //最大值
    FMax:Double;

    //当前位置
    FPosition:Double;

    FPageSize: Double;

    FSmallChange:Integer;
    FLargeChange:Integer;





    //手势处理的方向(水平还是垂直)
    FKind:TGestureKind;




    //允许越界的类型(最小值越界,或最大值越界)
    FCanOverRangeTypes:TCanOverRangeTypes;



    //最小值越界的值(大于0)
    FMinOverRangePosValue:Double;
    //最大值越界的值(大于0)
    FMaxOverRangePosValue:Double;



    //位置更改事件
    FOnPositionChange: TNotifyEvent;
    FOnInnerPositionChange: TNotifyEvent;
    FOnInnerPositionBeforeChange: TNotifyEvent;
    //越界值更改事件
    FOnMinOverRangePosValueChange:TOverRangePosValueChangeEvent;
    FOnInnerMinOverRangePosValueChange:TOverRangePosValueChangeEvent;
    FOnMaxOverRangePosValueChange:TOverRangePosValueChangeEvent;
    FOnInnerMaxOverRangePosValueChange:TOverRangePosValueChangeEvent;

    //日志标识
    function GetDebugLogID:String;

    //计算Min和Max的差,距离
    function CalcDistance: Double;

    procedure SetKind(const Value: TGestureKind);

    procedure SetMin(const Value: Double);
    procedure SetMax(const Value: Double);
    procedure SetPosition(const Value: Double);

    procedure SetParams(APosition, AMin, AMax: Double);

    procedure SetMinOverRangePosValue(const Value: Double);overload;
    procedure SetMaxOverRangePosValue(const Value: Double);overload;

    procedure SetMinOverRangePosValue(const Value: Double;NextValue:Double;LastValue:Double);overload;
    procedure SetMaxOverRangePosValue(const Value: Double;NextValue:Double;LastValue:Double);overload;


    //自定义Position更改事件,用于扩展
    procedure DoCustomPositionChange(Sender:TObject);virtual;
    procedure DoCustomPositionBeforeChange(Sender:TObject);virtual;

  protected

    //用户正在拖动(手指拖,鼠标滚)
    FIsDraging:Boolean;



    //检测用户释放滑动检测计时器
    FCheckUserStopMouseWheelTimer:TTimer;



    //滚回初始位置的动画
    FScrollingToInitialAnimator:TSkinAnimator;







    //惯性相关//
    //惯性滚动的方向
    FInertiaScrollDirection:TGestureDirection;
    //鼠标移动的方向
    FMouseMoveDirection:TGestureDirection;
    //上次鼠标移动方向改变时的坐标
    FLastMouseMoveDirectionChangePoint:TPointF;

    //惯性滚动
    FInertiaScrollAnimator:TSkinAnimator;







    //开始拖动
    FOnStartDrag:TNotifyEvent;
    //停止拖动
    FOnStopDrag:TNotifyEvent;
    //用户拖动状态更改事件
    FOnDragingStateChange: TNotifyEvent;
    FOnInnerDragingStateChange: TNotifyEvent;




    //回滚到初始开始事件
    FOnScrollToInitialAnimateBegin: TNotifyEvent;
    FOnInnerScrollToInitialAnimateBegin: TNotifyEvent;
    //回滚到初始结束事件
    FOnScrollToInitialAnimateEnd: TNotifyEvent;
    FOnInnerScrollToInitialAnimateEnd: TNotifyEvent;



    //惯性滚动开始事件
    FOnInertiaScrollAnimateBegin: TNotifyEvent;
    FOnInnerInertiaScrollAnimateBegin: TNotifyEvent;
    //惯性滚动结束事件(判断是否需要滚回初始)
    FOnInertiaScrollAnimateEnd: TInertiaScrollAnimateEndEvent;
    FOnInnerInertiaScrollAnimateEnd: TInertiaScrollAnimateEndEvent;
    //计算惯性滚动距离
    FOnCalcInertiaScrollDistance:TCalcInertiaScrollDistanceEvent;
    FOnInnerCalcInertiaScrollDistance:TCalcInertiaScrollDistanceEvent;







    //用户是否正在拖动(隐藏显示滚动条)
    procedure SetIsDraging(const Value: Boolean);

    //判断用户是否停止了滚动
    procedure CreateCheckUserStopMouseWheelTimer;
    procedure OnCheckUserStopMouseWheelTimer(Sender:TObject);






    //如果越界了,那么滚回边界,回弹
    procedure DoScrollToInitialAnimate(Sender:TObject);
    //滚回边界结束事件
    procedure DoScrollToInitialAnimateBegin(Sender:TObject);



    //启动惯性滚动
    procedure StartInertiaScroll;
    //惯性滚动定时器
    procedure DoInertiaScrollAnimate(Sender:TObject);
    //惯性滚动开始
    procedure DoInertiaScrollAnimateBegin(Sender:TObject);
    //惯性滚动结束
    procedure DoInertiaScrollAnimateEnd(Sender:TObject);

    //计算惯性滚动需要滚动的距离
    //用于平拖自定义
    procedure DoCustomCalcInertiaScrollDistance(Sender:TObject;
                                            var InertiaDistance:Double;
                                            var CanInertiaScroll:Boolean
                                            );virtual;
  public

    //是否正在鼠标拖动
    FIsStartDrag:Boolean;





    //在开始阶段确定之后的方向
    //比如在移动开始的十个像素之后,
    //而且主要是水平移动,
    //那么以后也只能水平移动


    //需要决定初始手势方向
    FIsNeedDecideFirstGestureKind:Boolean;
    //决定初始手势方向的距离(比如一共移动了5个像素,不管有没有判断出方向,也不再判断)
    FDecideFirstGestureKindDistance:Integer;
    //角度限制(用来判断是水平的还是垂直的)
    FDecideFirstGestureKindAngle:Integer;
    //允许移动的方向(往最小值方向,或往最大值方向)
    FDecideFirstGestureKindDirections:TGestureDirections;



    //已经确定了的初始手势方向
    FDecidedFirstGestureKind:TGestureKind;
    //是否确定了初始手势方向
    FHasDecidedFirstGestureKind:Boolean;









    //当前鼠标及手势坐标
    FMouseMovePt:TPointF;
    FMouseMoveAbsolutePt:TPointF;


    //上次鼠标移动或手势坐标
    FLastMouseMovePt:TPointF;
    FLastMouseMoveAbsolutePt:TPointF;


    //鼠标按下了
    FIsMouseDown:Boolean;

    //第一次鼠标移动的位置
    FFirstMouseMovePt:TPointF;
    FFirstMouseMoveAbsolutePt:TPointF;







    //第一次鼠标按下事件
    FOnFirstMouseDown:TMouseEvent;
    //判断初始手势方向类型结束
    FOnDecidedFirstGestureKind:TNotifyEvent;
    //准备判断初始手势方向类型事件
    FOnPrepareDecidedFirstGestureKind:TPrepareDecidedFirstGestureKindEvent;



    //用于平拖自定义
    procedure DoCustomFirstMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);virtual;
    //用于平拖自定义
    procedure DoCustomStartDrag(Sender:TObject);virtual;

    //鼠标按下初始
    procedure FirstMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    //调用FirstMouseDown
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure MouseMove(Shift: TShiftState; X, Y: Double);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure MouseEnter;
    procedure MouseLeave;
    function MouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;

    //键盘事件
    procedure KeyDown(Key: Word; Shift: TShiftState);
    procedure KeyUp(Key: Word; Shift: TShiftState);


//  public
//    //用在虚拟键盘弹出延迟惯性滚动
//    FCancelMouseUpTimer:TTimer;
//    procedure DoCancelMouseUpTimer(Sender:TObject);
    procedure CancelMouseUp;

  protected
    FMinPullLoadPanel:TChildControl;
    FMaxPullLoadPanel: TChildControl;
    procedure SetMinPullLoadPanel(Value:TChildControl);
    procedure SetMaxPullLoadPanel(Value:TChildControl);
  public
    property MinPullLoadPanel:TChildControl read FMinPullLoadPanel write SetMinPullLoadPanel;
    property MaxPullLoadPanel:TChildControl read FMaxPullLoadPanel write SetMaxPullLoadPanel;
  public
    constructor Create(AOwner:TComponent;AParentControl:TComponent);overload;
    constructor Create(AOwner:TComponent);overload;override;
    destructor Destroy;override;
  published

    //滑动类型
    property Kind: TGestureKind read FKind write SetKind;


    //最小值
    property Min: Double read FMin write SetMin;
    //最大值
    property Max: Double read FMax write SetMax;
    //当前位置
    property Position: Double read FPosition write SetPosition;



    //点击按钮位置更改增量
    property SmallChange: Integer read FSmallChange write FSmallChange;
    //鼠标滚动时的最大更改增量
    property LargeChange: Integer read FLargeChange write FLargeChange;
//    //键盘按键的更改增量
//    property KeyPressChange:Integer read FKeyPressChange write FKeyPressChange;

    //允许越界的类型(最小值越界,或最大值越界)
    property CanOverRangeTypes:TCanOverRangeTypes read FCanOverRangeTypes write FCanOverRangeTypes;

  public
    FIsNotChangePosition:Boolean;


    //最小值
    property StaticMin: Double read FMin write FMin;
    //最大值
    property StaticMax: Double read FMax write FMax;
    //位置
    property StaticPosition: Double read FPosition write FPosition;
    //页面大小
    property PageSize:Double read FPageSize write FPageSize;


    //当前的最小值越界
    property MinOverRangePosValue:Double read FMinOverRangePosValue write FMinOverRangePosValue;
    property StaticMinOverRangePosValue:Double read FMinOverRangePosValue write FMinOverRangePosValue;
    //当前的最大值越界
    property MaxOverRangePosValue:Double read FMaxOverRangePosValue write FMaxOverRangePosValue;
    property StaticMaxOverRangePosValue:Double read FMaxOverRangePosValue write FMaxOverRangePosValue;


  public
    //越界时,越界空白的区域尺寸变化计算因子(比如向下拉动,并不是拉多少,下移多少)
    FOverRangePosValueStep: Double;


    //计算滚动滑块大小的尺寸
    function CalcMinOverRangeScrollBarSize: Double;
    function CalcMaxOverRangeScrollBarSize: Double;

    function CalcOverRangePosValue(Value:Double):Double;

    //位置
    function CalcMinOverRangePosValue:Double;
    function CalcMaxOverRangePosValue:Double;


    //空白区域变量的因子
    property OverRangePosValueStep:Double read FOverRangePosValueStep write FOverRangePosValueStep;
  public
    //滚动回初始结束事件
    procedure DoScrollToInitialAnimateEnd(Sender:TObject);virtual;


    //手动以一定的速度滚动
    procedure DoInertiaScroll(AUpVelocity:Double;AInertiaDistance:Double=0);


    //滚动到初始
    procedure CustomStartScrollToInitial(ASrcMinOverRangePosValue:Double;
                                          ASrcMaxOverRangePosValue:Double;
                                          ADestMinOverRangePosValue:Double;
                                          ADestMaxOverRangePosValue:Double);
    //滚动到初始
    procedure StartScrollToInitial(AMinOverRangePosValue_Min:Double=0;
                                   AMaxOverRangePosValue_Min:Double=0);

    //取消本次惯性滚动,用于ImageListViewer开始缩放前有鼠标滑动，缩放结束后不能再惯性滚动
    procedure CancelInertiaScroll;



    //惯性滚动动画
    property InertiaScrollAnimator:TSkinAnimator read FInertiaScrollAnimator;
    //滚回初始位置动画
    property ScrollingToInitialAnimator:TSkinAnimator read FScrollingToInitialAnimator;
//    //按键按下移动
//    property KeyPressScrollAnimator:TSkinAnimator read FKeyPressScrollAnimator;





    //鼠标是否按下
    property IsMouseDown:Boolean read FIsMouseDown;

    //是否正在拖动
    property IsDraging:Boolean read FIsDraging;

    //当前鼠标移动方向
    property MouseMoveDirection:TGestureDirection read FMouseMoveDirection write FMouseMoveDirection;
    //当前惯性滚动的方向
    property InertiaScrollDirection:TGestureDirection read FInertiaScrollDirection write FInertiaScrollDirection;
  public
    //内部使用事件

    //用户拖动状态改变事件(在ScrollControl中使用)
    property OnInnerDragingStateChange:TNotifyEvent read FOnInnerDragingStateChange write FOnInnerDragingStateChange;

    //内部事件(在ScrollControl中使用)
    property OnInnerPositionChange: TNotifyEvent read FOnInnerPositionChange write FOnInnerPositionChange;
    property OnInnerPositionBeforeChange: TNotifyEvent read FOnInnerPositionBeforeChange write FOnInnerPositionBeforeChange;
    //内部事件(在ScrollControl中使用)
    property OnInnerMinOverRangePosValueChange:TOverRangePosValueChangeEvent read FOnInnerMinOverRangePosValueChange write FOnInnerMinOverRangePosValueChange;
    //内部事件(在ScrollControl中使用)
    property OnInnerMaxOverRangePosValueChange:TOverRangePosValueChangeEvent read FOnInnerMaxOverRangePosValueChange write FOnInnerMaxOverRangePosValueChange;

    //内部事件(在ScrollControl中使用)
    property OnInnerScrollToInitialAnimateBegin:TNotifyEvent read FOnInnerScrollToInitialAnimateBegin write FOnInnerScrollToInitialAnimateBegin;
    //内部事件(在ScrollControl中使用,用于ListBox的居中选择模式)
    property OnInnerScrollToInitialAnimateEnd:TNotifyEvent read FOnInnerScrollToInitialAnimateEnd write FOnInnerScrollToInitialAnimateEnd;
    //计算惯性滚动距离(ImageListView调用)
    property OnInnerCalcInertiaScrollDistance:TCalcInertiaScrollDistanceEvent read FOnInnerCalcInertiaScrollDistance write FOnInnerCalcInertiaScrollDistance;
    //惯性滚动开始事件(ScrollBar调用)
    property OnInnerInertiaScrollAnimateBegin:TNotifyEvent read FOnInnerInertiaScrollAnimateBegin write FOnInnerInertiaScrollAnimateBegin;
    //惯性滚动结束事件(判断是否需要滚回初始)(ScrollBar调用)
    property OnInnerInertiaScrollAnimateEnd:TInertiaScrollAnimateEndEvent read FOnInnerInertiaScrollAnimateEnd write FOnInnerInertiaScrollAnimateEnd;
  published

    //是否需要决定初始手势方向
    property IsNeedDecideFirstGestureKind:Boolean read FIsNeedDecideFirstGestureKind write FIsNeedDecideFirstGestureKind;
    //决定初始手势方向的判断距离
    property DecideFirstGestureKindDistance:Integer read FDecideFirstGestureKindDistance write FDecideFirstGestureKindDistance;
    //角度限制(用来判断是水平的还是垂直的)
    property DecideFirstGestureKindAngle:Integer read FDecideFirstGestureKindAngle write FDecideFirstGestureKindAngle;
    //允许移动的方向(往最小值方向,或往最大值方向)
    property DecideFirstGestureKindDirections:TGestureDirections read FDecideFirstGestureKindDirections write FDecideFirstGestureKindDirections;


    //判断了初始手势方向类型结束事件
    property OnDecidedFirstGestureKind:TNotifyEvent read FOnDecidedFirstGestureKind write FOnDecidedFirstGestureKind;
    //准备判断初始手势方向类型事件(用于指定矩形)
    property OnPrepareDecidedFirstGestureKind:TPrepareDecidedFirstGestureKindEvent read FOnPrepareDecidedFirstGestureKind write FOnPrepareDecidedFirstGestureKind;

  published
    //Position更改(ScrollBar调用)
    property OnPositionChange: TNotifyEvent read FOnPositionChange write FOnPositionChange;
    //最小值越界(ScrollBar调用)
    property OnMinOverRangePosValueChange:TOverRangePosValueChangeEvent read FOnMinOverRangePosValueChange write FOnMinOverRangePosValueChange;
    //最大值越界(ScrollBar调用)
    property OnMaxOverRangePosValueChange:TOverRangePosValueChangeEvent read FOnMaxOverRangePosValueChange write FOnMaxOverRangePosValueChange;
  published

    //开始拖动
    property OnStartDrag:TNotifyEvent read FOnStartDrag write FOnStartDrag;
    //停止拖动
    property OnStopDrag:TNotifyEvent read FOnStopDrag write FOnStopDrag;
    //用户拖动状态改变事件(ScrollBar调用)
    property OnDragingStateChange:TNotifyEvent read FOnDragingStateChange write FOnDragingStateChange;


    //第一次鼠标按下事件
    property OnFirstMouseDown:TMouseEvent read FOnFirstMouseDown write FOnFirstMouseDown;

  published
    //计算惯性滚动距离(ImageListView调用)
    property OnCalcInertiaScrollDistance:TCalcInertiaScrollDistanceEvent read FOnCalcInertiaScrollDistance write FOnCalcInertiaScrollDistance;


    //惯性滚动开始事件(ScrollBar调用)
    property OnInertiaScrollAnimateBegin:TNotifyEvent read FOnInertiaScrollAnimateBegin write FOnInertiaScrollAnimateBegin;
    //惯性滚动结束事件(ScrollBar调用)
    property OnInertiaScrollAnimateEnd:TInertiaScrollAnimateEndEvent read FOnInertiaScrollAnimateEnd write FOnInertiaScrollAnimateEnd;



    //回滚到初始定时器开始事件(ScrollBar调用)
    property OnScrollToInitialAnimateBegin:TNotifyEvent read FOnScrollToInitialAnimateBegin write FOnScrollToInitialAnimateBegin;
    //回滚到初始定时器结束事件(ScrollBar调用)
    property OnScrollToInitialAnimateEnd:TNotifyEvent read FOnScrollToInitialAnimateEnd write FOnScrollToInitialAnimateEnd;
  end;







  TSkinControlGestureManagerList=class(TBaseList)
  private
    function GetItem(Index: Integer): TSkinControlGestureManager;
  public
    property Items[Index:Integer]:TSkinControlGestureManager read GetItem;default;
  end;









var
  CurrentGestureManagerList:TSkinControlGestureManagerList;


var
  //决定惯性滚动方向的位移
  FDecideInertiaDirectionCrement:Integer;

  //决定拖动方向的位移
  FDecideDoDragDirectionCrement:Integer;


  //越界时,滚动条滑块变化计算因子(向下拉动,拉动的距离越长,滚动条变得越短)
  FOverRangeScrollBarSizeStep: Double;
  FDefaultOverRangePosValueStep:Double;

  //用于ClipHeadFrame
  ZoomingHorzGestureManager:TObject;
  ZoomingVertGestureManager:TObject;



//计算越界的值
function CalcOverRangeScrollBarSize(Value:Double):Double;




implementation






function CalcOverRangeScrollBarSize(Value: Double): Double;
begin
  Result:=Value*FOverRangeScrollBarSizeStep;
end;


{ TSkinControlGestureManager }

function TSkinControlGestureManager.CalcOverRangePosValue(Value: Double): Double;
begin
  Result:=Value*FOverRangePosValueStep;
end;

constructor TSkinControlGestureManager.Create(AOwner:TComponent;AParentControl:TComponent);
begin
  Create(AOwner);
  FParentControl:=AParentControl;
end;

procedure TSkinControlGestureManager.SetIsDraging(const Value: Boolean);
begin
  if FIsDraging<>Value then
  begin
    FIsDraging := Value;

    if Assigned(Self.FOnDragingStateChange) then
    begin
      FOnDragingStateChange(Self);
    end;
    if Assigned(Self.FOnInnerDragingStateChange) then
    begin
      FOnInnerDragingStateChange(Self);
    end;

  end;
end;

destructor TSkinControlGestureManager.Destroy;
begin
  //从激活手势列表去排除
  CurrentGestureManagerList.Remove(Self,False);



  StopTimer;
  FreeAndNil(FTimer);
  FreeAndNil(FPointTimeList);






  //检测用户释放滑动检测计时器
  FreeAndNil(FCheckUserStopMouseWheelTimer);

  //滑动滚回初始位置
  FreeAndNil(FScrollingToInitialAnimator);
  //惯性滚动
  FreeAndNil(FInertiaScrollAnimator);


//  //按键移动
//  FreeAndNil(FKeyPressScrollAnimator);

  inherited;
end;

procedure TSkinControlGestureManager.SetKind(const Value: TGestureKind);
begin
  if Value <> FKind then
  begin
    FKind := Value;
    case FKind of
      gmkNone: Self.FTouchTracking:=[];
      gmkHorizontal: Self.FTouchTracking:=[ttHorizontal];
      gmkVertical: Self.FTouchTracking:=[ttVertical];
    end;
  end;
end;

procedure TSkinControlGestureManager.SetMax(const Value: Double);
begin
  SetParams(FPosition, FMin, Value);
end;

procedure TSkinControlGestureManager.SetMin(const Value: Double);
begin
  SetParams(FPosition, Value, FMax);
end;

procedure TSkinControlGestureManager.SetMaxOverRangePosValue(const Value: Double;NextValue:Double;LastValue:Double);
var
  CanChange:Boolean;
  NewValue:Double;
begin
  CanChange:=True;
  NewValue:=Value;

  if Assigned(Self.FOnMaxOverRangePosValueChange) then
  begin
    Self.FOnMaxOverRangePosValueChange(Self,NextValue,LastValue,FOverRangePosValueStep,NewValue,CanChange);
  end;

  if Assigned(Self.FOnInnerMaxOverRangePosValueChange) then
  begin
    Self.FOnInnerMaxOverRangePosValueChange(Self,NextValue,LastValue,FOverRangePosValueStep,NewValue,CanChange);
  end;




  if CanChange then
  begin
    if FMaxOverRangePosValue<>NewValue then
    begin
      if NewValue<0 then
      begin
        FMaxOverRangePosValue:=0;
      end
      else
      begin
        FMaxOverRangePosValue := NewValue;
      end;
    end;




    //触发更改事件
    DoCustomPositionChange(Self);



  end;
end;

procedure TSkinControlGestureManager.SetMaxPullLoadPanel(Value: TChildControl);
//var
//  ASetControlGestureManagerIntf:ISetControlGestureManager;
begin
  Self.FMaxPullLoadPanel:=Value;
//  if Value<>nil then
//  begin
//    if Value.GetInterface(IID_ISetControlGestureManager,ASetControlGestureManagerIntf) then
//    begin
//      ASetControlGestureManagerIntf.SetControlGestureManager(Self);
//    end;
//  end;
end;

function TSkinControlGestureManager.CalcDistance: Double;
begin
  Result:=(FMax-FMin);
end;

procedure TSkinControlGestureManager.SetPosition(const Value: Double);
begin
  SetParams(Value, FMin, FMax);
end;

function TSkinControlGestureManager.CalcMaxOverRangeScrollBarSize: Double;
begin
  Result:=CalcOverRangeScrollBarSize(Self.FMaxOverRangePosValue);
end;

function TSkinControlGestureManager.CalcMinOverRangeScrollBarSize: Double;
begin
  Result:=CalcOverRangeScrollBarSize(Self.FMinOverRangePosValue);
end;

function TSkinControlGestureManager.CalcMaxOverRangePosValue: Double;
begin
  Result:=CalcOverRangePosValue(Self.FMaxOverRangePosValue);
end;

function TSkinControlGestureManager.CalcMinOverRangePosValue: Double;
begin
  Result:=CalcOverRangePosValue(Self.FMinOverRangePosValue);
end;

procedure TSkinControlGestureManager.SetMinOverRangePosValue(const Value: Double);
begin
  SetMinOverRangePosValue(Value,Value,Value);
end;

procedure TSkinControlGestureManager.SetMaxOverRangePosValue(const Value: Double);
begin
  SetMaxOverRangePosValue(Value,Value,Value);
end;

procedure TSkinControlGestureManager.SetMinOverRangePosValue(const Value: Double;NextValue:Double;LastValue:Double);
var
  CanChange:Boolean;
  NewValue:Double;
begin

  CanChange:=True;
  NewValue:=Value;

  if Assigned(Self.FOnMinOverRangePosValueChange) then
  begin
    Self.FOnMinOverRangePosValueChange(Self,NextValue,LastValue,FOverRangePosValueStep,NewValue,CanChange);
  end;

  if Assigned(Self.FOnInnerMinOverRangePosValueChange) then
  begin
    Self.FOnInnerMinOverRangePosValueChange(Self,NextValue,LastValue,FOverRangePosValueStep,NewValue,CanChange);
  end;

  if CanChange then
  begin


    if FMinOverRangePosValue<>NewValue then
    begin
      if NewValue<0 then
      begin
        FMinOverRangePosValue:=0;
      end
      else
      begin
        FMinOverRangePosValue := NewValue;
      end;
    end;


    //触发更改事件(要刷新)
    DoCustomPositionChange(Self);



  end;
end;

procedure TSkinControlGestureManager.SetMinPullLoadPanel(Value: TChildControl);
begin
  Self.FMinPullLoadPanel:=Value;
end;

procedure TSkinControlGestureManager.SetParams(APosition, AMin, AMax: Double);
begin
//  if FIsNotChangePosition then Exit;

//  if Self.FKind=gmkVertical then
//  begin
//    uBaseLog.OutputDebugString(GetDebugLogID+'前 FPosition:'+FloatToStr(FPosition)+', '
//                               +'APosition:'+FloatToStr(APosition)+', '
//                               +'AMin:'+FloatToStr(AMin)+', '
//                               +'AMax:'+FloatToStr(AMax)+', '
//                               +'FMinOverRangePosValue:'+FloatToStr(FMinOverRangePosValue)+', '
//                               +'FMaxOverRangePosValue:'+FloatToStr(FMaxOverRangePosValue)+', '
//                                );
//  end;

  if Self.FKind=gmkHorizontal then
  begin
    uBaseLog.OutputDebugString(GetDebugLogID+'前 FPosition:'+FloatToStr(FPosition)+', '
                               +'APosition:'+FloatToStr(APosition)+', '
                               +'AMin:'+FloatToStr(AMin)+', '
                               +'AMax:'+FloatToStr(AMax)+', '
                               +'FMinOverRangePosValue:'+FloatToStr(FMinOverRangePosValue)+', '
                               +'FMaxOverRangePosValue:'+FloatToStr(FMaxOverRangePosValue)+', '
                                );
  end;



  //因为Min和Max与Position无关
  //每次必设
  if IsNotSameDouble(FMin,AMin)
    or IsNotSameDouble(FMax,AMax)  then
  begin
      //界限值更改了
      FMin := AMin;
      FMax := AMax;
      //那么APosition需要判断是不是在新的界限值中
      //不然会触发OnMinOverRangePosValueChange事件
      //而导致下拉刷新和上拉加载
      if SmallerDouble(APosition,AMin) then
      begin
        APosition := AMin;
      end;
      if BiggerDouble(APosition,AMax) then
      begin
        APosition := AMax;
      end;
      //触发更改事件
      DoCustomPositionChange(Self);
  end;




  if BiggerDouble(FMaxOverRangePosValue,0) then
  begin
      //有越界,先处理越界
      SetMaxOverRangePosValue(FMaxOverRangePosValue-(FPosition-APosition));

      if SmallerDouble(FPosition,AMin) then
      begin
        FPosition := AMin;
        //触发更改事件
        DoCustomPositionChange(Self);
      end;
      if BiggerDouble(FPosition,AMax) then
      begin
        FPosition := AMax;
        //触发更改事件
        DoCustomPositionChange(Self);
      end;

  end
  else
  if BiggerDouble(FMinOverRangePosValue,0) then
  begin
      //有越界,先处理越界
      SetMinOverRangePosValue(FMinOverRangePosValue-(APosition-FPosition));

      if SmallerDouble(FPosition,AMin) then
      begin
        FPosition := AMin;
        //触发更改事件
        DoCustomPositionChange(Self);
      end;
      if BiggerDouble(FPosition,AMax) then
      begin
        FPosition := AMax;
        //触发更改事件
        DoCustomPositionChange(Self);
      end;
  end
  else
  begin
      if Self.FCanOverRangeTypes<>[] then
      begin
            //如果需要设置的位置比最小值小,那么启动越界模式
            if SmallerDouble(APosition,AMin) and (cortMin in FCanOverRangeTypes) then
            begin
              //越界了
              SetMinOverRangePosValue(FMinOverRangePosValue+AMin-APosition);
            end
            else if BiggerDouble(APosition,AMax) and (cortMax in FCanOverRangeTypes) then
            begin
              //越界了
              SetMaxOverRangePosValue(FMaxOverRangePosValue+APosition-AMax);
            end;
      end;


      if SmallerDouble(APosition,AMin) then
      begin
        APosition := AMin;
      end;
      if BiggerDouble(APosition,AMax) then
      begin
        APosition := AMax;
      end;

      if IsNotSameDouble(FPosition,APosition)
        or IsNotSameDouble(FMin,AMin)
        or IsNotSameDouble(FMax,AMax)  then
      begin
        FMin := AMin;
        FMax := AMax;

        DoCustomPositionBeforeChange(Self);


        if Not FIsNotChangePosition then
        begin
          FPosition := APosition;
        end;


        //触发更改事件
        DoCustomPositionChange(Self);


      end;

  end;

//  uBaseLog.OutputDebugString(GetDebugLogID+'后 FPosition:'+FloatToStr(FPosition)+', '
//                             +'APosition:'+FloatToStr(APosition)+', '
//                             +'AMin:'+FloatToStr(AMin)+', '
//                             +'AMax:'+FloatToStr(AMax)+', '
//                             +'FMinOverRangePosValue:'+FloatToStr(FMinOverRangePosValue)+', '
//                             +'FMaxOverRangePosValue:'+FloatToStr(FMaxOverRangePosValue)+', '
//
//                              );

end;

constructor TSkinControlGestureManager.Create(AOwner: TComponent);
begin
  Inherited;


  BeginUpdate;
  //时间点
  FPointTimeList := TPointTimeList.Create;

  //惯性力度
  FVelocityPower := DefaultVelocityPower;
  //初始
  //最小的速度
  FMinVelocity := DefaultMinVelocity;
  //最大的速度
  FMaxVelocity := DefaultMaxVelocity;
  //起始距离
  FDeadZone := DefaultDeadZone;
//  //动态
//  FAnimation := False;
  //自动隐藏
  FAutoShowing := False;
  //是否计算平均值
  FAveraging := False;//True;//True;//False;

//  FBoundsAnimation := True;
  //间隔
  FInterval := Ceil(DefaultIntervalOfAni);
  FTouchTracking := [ttVertical];
  SetTargets([]);
  //
  FDecelerationRate := DecelerationRateNormal;
  FOverRangeDecelerationRate := DecelerationRateFast*2;
  //
//  FElasticity := DefaultElasticity;
  //150毫秒
  FStorageTime := DefaultStorageTime;

  FEnabled:=True;
//  FEnabled:=False;//True;












  //水平滚动
  FKind:=gmkVertical;


  FMin:=0;
  FMax:=100;
  FPosition:=0;
  FPageSize:=100;

  FSmallChange:=1;
  FLargeChange:=10;
//  FKeyPressChange:=10;



  //越界的值(大于0)
  FMinOverRangePosValue:=0;
  FMaxOverRangePosValue:=0;


  //计算因子
  FOverRangePosValueStep:=FDefaultOverRangePosValueStep;

  //鼠标是否按下
  FIsMouseDown:=False;


  //判断第一次手势方向的参数
  FIsNeedDecideFirstGestureKind:=False;
  FDecideFirstGestureKindDistance:=10;
  FDecideFirstGestureKindAngle:=15;
  FDecideFirstGestureKindDirections:=[isdScrollToMin,isdScrollToMax];



  //第一次手势的类型
  FDecidedFirstGestureKind:=gmkNone;
  FHasDecidedFirstGestureKind:=False;



  //惯性滚动的方向
  FInertiaScrollDirection:=isdNone;
  //鼠标移动的方向
  FMouseMoveDirection:=isdNone;




  //允许越界的类型
  FCanOverRangeTypes:=[cortMin,cortMax];







  //滚动到初始位置的定时器
  FScrollingToInitialAnimator:=TSkinAnimator.Create(nil);
  FScrollingToInitialAnimator.TweenType:=TTweenType.Quadratic;
  FScrollingToInitialAnimator.EaseType:=TEaseType.easeOut;
  FScrollingToInitialAnimator.OnAnimate:=Self.DoScrollToInitialAnimate;
  FScrollingToInitialAnimator.OnAnimateBegin:=Self.DoScrollToInitialAnimateBegin;
  FScrollingToInitialAnimator.OnAnimateEnd:=Self.DoScrollToInitialAnimateEnd;
  //原本是6,5,现在为了加速,用了2,10
  FScrollingToInitialAnimator.Speed:=Const_Deafult_AnimatorSpeed;
  FScrollingToInitialAnimator.EndTimesCount:=8;




//  //按键按下移动
//  FKeyPressScrollAnimator:=TSkinAnimator.Create(nil);
//  FKeyPressScrollAnimator.TweenType:=TTweenType.Linear;//Cubic;//Quartic;//Quadratic;
//  FKeyPressScrollAnimator.EaseType:=TEaseType.easeIn;
//  FKeyPressScrollAnimator.OnAnimate:=Self.DoKeyPressScrollAnimate;





  //惯性滚动
  FInertiaScrollAnimator:=TSkinAnimator.Create(nil);
  FInertiaScrollAnimator.Speed:=Const_Deafult_AnimatorSpeed;
  FInertiaScrollAnimator.OnAnimate:=Self.DoInertiaScrollAnimate;
  FInertiaScrollAnimator.OnAnimateBegin:=Self.DoInertiaScrollAnimateBegin;
  FInertiaScrollAnimator.OnAnimateEnd:=Self.DoInertiaScrollAnimateEnd;
  FInertiaScrollAnimator.TweenType:=TTweenType.InertialScroll;



end;

procedure TSkinControlGestureManager.CreateCheckUserStopMouseWheelTimer;
begin
  if FCheckUserStopMouseWheelTimer=nil then
  begin
    FCheckUserStopMouseWheelTimer:=TTimer.Create(nil);
    FCheckUserStopMouseWheelTimer.Enabled:=False;
    FCheckUserStopMouseWheelTimer.OnTimer:=Self.OnCheckUserStopMouseWheelTimer;
    FCheckUserStopMouseWheelTimer.Interval:=100;
  end;
end;

procedure TSkinControlGestureManager.OnCheckUserStopMouseWheelTimer(Sender: TObject);
begin
  if Not Self.FIsDraging then
  begin
    Self.FCheckUserStopMouseWheelTimer.Enabled:=False;

//    if Self.FKind=gmkHorizontal then
//      OutputDebugString(GetDebugLogID+'TSkinControlGestureManager.OnCheckUserStopMouseWheelTimer 启动惯性滚动');

    //启动惯性滚动
    Self.StartInertiaScroll;
  end;
  if Self.FIsDraging then
  begin
    Self.FIsDraging:=False;
    Self.FIsStartDrag:=False;
  end;
end;

//procedure TSkinControlGestureManager.CreateKeyPressAdjustSpeedTimer;
//begin
//  if FKeyPressAdjustSpeedTimer=nil then
//  begin
//    FKeyPressAdjustSpeedTimer:=TTimer.Create(nil);
//    FKeyPressAdjustSpeedTimer.Enabled:=False;
//    FKeyPressAdjustSpeedTimer.OnTimer:=Self.OnKeyPressAdjustSpeedTimer;
//  end;
//end;
//
//procedure TSkinControlGestureManager.OnKeyPressAdjustSpeedTimer(Sender: TObject);
//begin
//
//  //增速
//  if FKeyPressAdjustSpeedType=kpastAdd then
//  begin
////    if Self.FKeyPressScrollAnimator.Speed>1 then
////    begin
////      //增加速度
////      Self.FKeyPressScrollAnimator.Speed:=Self.FKeyPressScrollAnimator.Speed-1;
////    end;
//
//    if Self.FKeyPressScrollAnimator.EndTimesCount>Ceil(GetKeyPressScrollAnimatorEndTimesCount*0.1) then
//    begin
//      //增加速度
//      Self.FKeyPressScrollAnimator.EndTimesCount:=
//        Self.FKeyPressScrollAnimator.EndTimesCount - Ceil(Self.FKeyPressScrollAnimator.EndTimesCount * 0.3);
////      OutputDebugString('Self.FKeyPressScrollAnimator.EndTimesCount 正在加速'+IntToStr(Self.FKeyPressScrollAnimator.EndTimesCount));
//    end
//    else
//    begin
//      FKeyPressAdjustSpeedTimer.Enabled:=False;
////      OutputDebugString('Self.FKeyPressScrollAnimator.EndTimesCount 最快了');
//    end;
//
//  end;
//
//
//  //减速
//  if FKeyPressAdjustSpeedType=kpastDec then
//  begin
//    if Self.FKeyPressScrollAnimator.EndTimesCount<GetKeyPressScrollAnimatorEndTimesCount*32 then
//    begin
//      Self.FKeyPressScrollAnimator.EndTimesCount:=Self.FKeyPressScrollAnimator.EndTimesCount * 2;
////      OutputDebugString('Self.FKeyPressScrollAnimator.EndTimesCount 正在减速'+IntToStr(Self.FKeyPressScrollAnimator.EndTimesCount));
//    end
//    else
//    begin
//      FKeyPressScrollAnimator.Pause;
//      FKeyPressAdjustSpeedTimer.Enabled:=False;
//      //滚动到初始
//      Self.StartScrollToInitial;
////      OutputDebugString('Self.FKeyPressScrollAnimator.EndTimesCount 结束了');
//    end;
//  end;
//
//end;

//procedure TSkinControlGestureManager.DoCancelMouseUpTimer(Sender: TObject);
//begin
//    Self.FCancelMouseUpTimer.Enabled:=False;
//
////不需要这句
////    if Not FEnabled then Exit;
//
////    OutputDebugString(GetDebugLogID+'CancelMouseUp');
//
//
//    //从激活手势列表去排除
//    CurrentGestureManagerList.Remove(Self,False);
//
//
//    if Down then
//    begin
//
////      MouseMove(shift,X, Y);
//
//  //    //添加坐标点
//  //    AddPointTime(X, Y, Now);
//
//      //计算速度
//      CalcVelocity;
//
//      //弹起的速度
//      FUpVelocity := CurrentVelocity;
//      //弹起的位置
//      FUpPosition := ViewportPosition;
//
//      UpdateTimer;
//
//  //    if (not Animation) then
//  //    begin
//  //      UpdateViewportPositionByBounds;
//  //    end;
//
//      Down := False;
//    end;
//
//
//
//
//
//
//
//
////    if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft  then
////    begin
//      FIsMouseDown:=False;
//
//
//      if FIsStartDrag then
//      begin
////        Self.FMouseMovePt:=PointF(X,Y);
//
//
//        //停止滚动
//        Self.FIsStartDrag:=False;
//
//
//        //用户不滚动了
//        SetIsDraging(False);
//        Self.FIsDraging:=False;
//
//
//        //停止拖动
//        if Assigned(FOnStopDrag) then
//        begin
//          FOnStopDrag(Self);
//        end;
//
//
//
//        if Self.FCheckUserStopMouseWheelTimer<>nil then
//        begin
//          Self.FCheckUserStopMouseWheelTimer.Enabled:=False;
//        end;
//
//
////        if  (FDecidedFirstGestureKind=FKind) then
////        begin
////          //启动惯性滚动
////          Self.StartInertiaScroll;
////        end
////        else
////        begin
//////          OutputDebugString(GetDebugLogID+'方向不对,不启动惯性滚动');
////        end;
//
//      end;
//
////   end;
//
//
//
//
//end;

procedure TSkinControlGestureManager.DoCustomCalcInertiaScrollDistance(
  Sender: TObject; var InertiaDistance: Double; var CanInertiaScroll: Boolean);
begin


end;

procedure TSkinControlGestureManager.DoCustomFirstMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Double);
begin

end;

procedure TSkinControlGestureManager.DoCustomPositionBeforeChange(
  Sender: TObject);
begin
  if Assigned(Self.OnInnerPositionBeforeChange) then
  begin
    Self.OnInnerPositionBeforeChange(Self);
  end;
end;

procedure TSkinControlGestureManager.DoCustomPositionChange(Sender: TObject);
begin
  if Assigned(Self.FOnPositionChange) then
  begin
    Self.FOnPositionChange(Self);
  end;
  if Assigned(Self.OnInnerPositionChange) then
  begin
    Self.OnInnerPositionChange(Self);
  end;
end;

procedure TSkinControlGestureManager.DoCustomStartDrag(Sender: TObject);
begin

end;

procedure TSkinControlGestureManager.DoInertiaScroll(AUpVelocity: Double;AInertiaDistance:Double);
begin
  FInertiaDistance:=AInertiaDistance;

  //比对一下时间,判断出惯性的力量
  if IsNotSameDouble(AUpVelocity,0) then
  begin
    if AUpVelocity<0 then
    begin
      FInertiaScrollDirection:=isdScrollToMin;
    end
    else
    begin
      FInertiaScrollDirection:=isdScrollToMax;
    end;


    //计算出来的速度
    FInertiaScrollAnimator.CurrentVelocity:=AUpVelocity;
    FInertiaScrollAnimator.MinVelocity:=Self.MinVelocity;
    FInertiaScrollAnimator.MaxVelocity:=Self.MaxVelocity;
//    FInertiaScrollAnimator.Elasticity:=Self.Elasticity;
    FInertiaScrollAnimator.DecelerationRate:=Self.FDecelerationRate;
    FInertiaScrollAnimator.LastTimeCalc:=FLastTimeCalc;
    FInertiaScrollAnimator.TweenType:=TTweenType.InertialScroll;//Cubic;//InertialScroll;//Cubic;//InertialScroll;//InertialScroll;//.Cubic;

    FInertiaScrollAnimator.Min:=0;
    FInertiaScrollAnimator.Max:=AInertiaDistance;

    FInertiaScrollAnimator.Start;
  end;

end;

procedure TSkinControlGestureManager.DoInertiaScrollAnimate(Sender: TObject);
var
  AHardFactor:Double;
  AAdjust:Double;
begin

//  uBaseLog.OutputDebugString('TSkinControlGestureManager.DoInertiaScrollAnimate');


  //如果越界了,那么惯性滚动的距离将大大缩短,并且表现得很难滚动
  AHardFactor:=1;
  if (Self.FMinOverRangePosValue>0) or (Self.FMaxOverRangePosValue>0) then
  begin
    AHardFactor:=FOverRangePosValueStep;
  end;



//  uBaseLog.OutputDebugString(GetDebugLogID+' 越界 DoInertiaScrollAnimate FMaxOverRangePosValue '+FloatToStr(FMaxOverRangePosValue));
//  uBaseLog.OutputDebugString(GetDebugLogID+' 越界 DoInertiaScrollAnimate FMinOverRangePosValue '+FloatToStr(FMinOverRangePosValue));
//  uBaseLog.OutputDebugString('距离 '+FloatToStr((Self.FInertiaScrollAnimator.Position-Self.FInertiaScrollAnimator.LastPosition)));//


  //SumInertiaDistance和实际的会有误差,比如FInertiaDistance为59,但FSumInertiaDistance会为63,超出
  AAdjust:=0;
  if (FInertiaDistance>0) then
  begin
    FSumInertiaDistance:=FSumInertiaDistance+(Self.FInertiaScrollAnimator.Position-Self.FInertiaScrollAnimator.LastPosition);
    if (FSumInertiaDistance>Self.FInertiaDistance) then
    begin
      AAdjust:=FSumInertiaDistance-FInertiaDistance;
      FSumInertiaDistance:=FInertiaDistance;
    end;
  end;


  case Self.FInertiaScrollDirection of
    isdScrollToMin:
    begin
      Self.Position:=Self.Position-
        (Self.FInertiaScrollAnimator.Position-Self.FInertiaScrollAnimator.LastPosition-AAdjust)*AHardFactor;
    end;
    isdScrollToMax:
    begin
      Self.Position:=Self.Position+
        (Self.FInertiaScrollAnimator.Position-Self.FInertiaScrollAnimator.LastPosition-AAdjust)*AHardFactor;
    end;
  end;


//  uBaseLog.OutputDebugString(GetDebugLogID+' 越界 DoInertiaScrollAnimate FInertiaScrollAnimator.Position '+FloatToStr(FSumInertiaDistance));

//  uBaseLog.OutputDebugString(GetDebugLogID+' DoInertiaScrollAnimate Position '+FloatToStr(Position));
//  uBaseLog.OutputDebugString(GetDebugLogID+' 越界 DoInertiaScrollAnimate FMaxOverRangePosValue '+FloatToStr(FMaxOverRangePosValue));
//  uBaseLog.OutputDebugString(GetDebugLogID+' 越界 DoInertiaScrollAnimate FMinOverRangePosValue '+FloatToStr(FMinOverRangePosValue));


  //如果越界了,速度要快
  if (Self.FMaxOverRangePosValue>0)
    or (Self.FMinOverRangePosValue>0) then
  begin
    Self.FInertiaScrollAnimator.DecelerationRate:=FOverRangeDecelerationRate;
  end
  else
  begin
    Self.FInertiaScrollAnimator.DecelerationRate:=FDecelerationRate;
  end;





end;

procedure TSkinControlGestureManager.DoInertiaScrollAnimateBegin(Sender: TObject);
begin
  FSumInertiaDistance:=0;


  if Assigned(FOnInertiaScrollAnimateBegin) then
  begin
    FOnInertiaScrollAnimateBegin(Self);
  end;
  if Assigned(FOnInnerInertiaScrollAnimateBegin) then
  begin
    FOnInnerInertiaScrollAnimateBegin(Self);
  end;
end;

procedure TSkinControlGestureManager.DoInertiaScrollAnimateEnd(Sender: TObject);
var
  ACanStartScrollToInitial:Boolean;
  AMinOverRangePosValue_Min:Double;
  AMaxOverRangePosValue_Min:Double;
begin
  //结束惯性滚动,滚动回初始状态
  ACanStartScrollToInitial:=True;
  AMinOverRangePosValue_Min:=0;
  AMaxOverRangePosValue_Min:=0;

  if Assigned(FOnInertiaScrollAnimateEnd) then
  begin
    FOnInertiaScrollAnimateEnd(Self,ACanStartScrollToInitial,AMinOverRangePosValue_Min,AMaxOverRangePosValue_Min);
  end;
  if Assigned(FOnInnerInertiaScrollAnimateEnd) then
  begin
    FOnInnerInertiaScrollAnimateEnd(Self,ACanStartScrollToInitial,AMinOverRangePosValue_Min,AMaxOverRangePosValue_Min);
  end;
  if ACanStartScrollToInitial then
  begin
    Self.StartScrollToInitial(AMinOverRangePosValue_Min,AMaxOverRangePosValue_Min);
  end;
end;

//function TSkinControlGestureManager.GetKeyPressScrollAnimatorEndTimesCount: Integer;
//begin
//  Result:=ABS(Ceil(FKeyPressScrollAnimator.Max-FKeyPressScrollAnimator.Min)) div Self.FKeyPressChange;
//  if Result<10 then
//  begin
//    Result:=10;
//  end;
//end;
//
//procedure TSkinControlGestureManager.DoKeyPressScrollAnimate(Sender: TObject);
//var
//  AHardFactor:Double;
//begin
//  //如果越界了,那么惯性滚动的距离将大大缩短,并且表现得很难滚动
//  AHardFactor:=1;
//  if (Self.FMinOverRangePosValue>0) or (Self.FMaxOverRangePosValue>0) then
//  begin
//    AHardFactor:=Self.FOverRangePosValueStep;
//  end;
//  case Self.FKeyPressScrollDirection of
//    isdNone:
//    begin
//    end;
//    isdScrollToMin:
//    begin
//      Self.Position:=Self.Position-Floor(ABS(Self.FKeyPressScrollAnimator.LastPosition-Self.FKeyPressScrollAnimator.Position)*AHardFactor);
//    end;
//    isdScrollToMax:
//    begin
//      Self.Position:=Self.Position+Floor(ABS(Self.FKeyPressScrollAnimator.Position-Self.FKeyPressScrollAnimator.LastPosition)*AHardFactor);
//    end;
//  end;
////  OutputDebugString('Position:'+IntToStr(Position));
//end;

procedure TSkinControlGestureManager.DoScrollToInitialAnimate(Sender: TObject);
begin
//  uBaseLog.OutputDebugString('TSkinControlGestureManager.DoScrollToInitialAnimate');
//  uBaseLog.OutputDebugString(GetDebugLogID+' 越界 DoScrollToInitialAnimate '+FloatToStr(FMaxOverRangePosValue));

  //滚回边界
  if Self.FMinOverRangePosValue>0 then
  begin
    if IsSameDouble(Self.FPosition,Self.FMin) then
    begin
      //滚回边界Min
      SetMinOverRangePosValue(Self.FScrollingToInitialAnimator.Position,
                              Self.FScrollingToInitialAnimator.NextPosition,
                              Self.FScrollingToInitialAnimator.LastPosition);
    end
    else
    begin
      //立即结束滚回边界Min
      SetMinOverRangePosValue(0,0,0);
    end;
  end
  else if Self.FMaxOverRangePosValue>0 then
  begin
    if IsSameDouble(Self.FPosition,Self.FMax) then
    begin
      //滚回边界Max
      SetMaxOverRangePosValue(Self.FScrollingToInitialAnimator.Position,
                              Self.FScrollingToInitialAnimator.NextPosition,
                              Self.FScrollingToInitialAnimator.LastPosition);
    end
    else
    begin
      //立即结束滚回边界Max
      SetMaxOverRangePosValue(0,0,0);
    end;
  end;

end;

procedure TSkinControlGestureManager.DoScrollToInitialAnimateBegin(Sender: TObject);
begin
  if Assigned(FOnScrollToInitialAnimateBegin) then
  begin
    FOnScrollToInitialAnimateBegin(Self);
  end;
  if Assigned(FOnInnerScrollToInitialAnimateBegin) then
  begin
    FOnInnerScrollToInitialAnimateBegin(Self);
  end;
end;

procedure TSkinControlGestureManager.DoScrollToInitialAnimateEnd(Sender: TObject);
begin
//  uBaseLog.OutputDebugString(GetDebugLogID+'结束滚回初始');

  //滚回边界结束事件
  if Assigned(FOnScrollToInitialAnimateEnd) then
  begin
    FOnScrollToInitialAnimateEnd(Self);
  end;
  if Assigned(FOnInnerScrollToInitialAnimateEnd) then
  begin
    FOnInnerScrollToInitialAnimateEnd(Self);
  end;
end;

procedure TSkinControlGestureManager.StartInertiaScroll;
var
  AUpVelocity:Double;
  AIsCanInertiaScroll:Boolean;
begin

  AUpVelocity:=0;
  case Self.FKind of
    gmkNone: ;
    gmkHorizontal: AUpVelocity:=Self.UpVelocity.X;
    gmkVertical: AUpVelocity:=Self.UpVelocity.Y;
  end;



//  //比对一下时间,判断出惯性的力量
//  //为什么移出控件外的时候UpVelocity.X为0
//  if IsNotSameDouble(AUpVelocity,0) then
//  begin


//      if Self.FKind=gmkHorizontal then
//        uBaseLog.OutputDebugString(GetDebugLogID+'StartInertiaScroll 开始惯性滚动 AUpVelocity:'+FloatToStr(AUpVelocity));

      if AUpVelocity<0 then
      begin
        FInertiaScrollDirection:=isdScrollToMin;
      end
      else
      begin
        FInertiaScrollDirection:=isdScrollToMax;
      end;

      //计算出来的速度
      FInertiaScrollAnimator.CurrentVelocity:=AUpVelocity;
      FInertiaScrollAnimator.MinVelocity:=Self.MinVelocity;
      FInertiaScrollAnimator.MaxVelocity:=Self.MaxVelocity;
  //    FInertiaScrollAnimator.Elasticity:=Self.Elasticity;
      FInertiaScrollAnimator.DecelerationRate:=Self.FDecelerationRate;
  //    if FLastTimeCalc=0 then
  //    FLastTimeCalc:=Now;
  //    uBaseLog.OutputDebugString('开始 Start '+FormatDateTime('HH:MM:SS ZZZ',FLastTimeCalc));
      FInertiaScrollAnimator.LastTimeCalc:=FLastTimeCalc;
      FInertiaScrollAnimator.TweenType:=TTweenType.InertialScroll;



      //计算可以惯性滚动的距离
      FInertiaDistance:=0;
      AIsCanInertiaScroll:=IsNotSameDouble(AUpVelocity,0);//True;
      if Assigned(FOnCalcInertiaScrollDistance) then
      begin
        FOnCalcInertiaScrollDistance(Self,
                                      FInertiaDistance,
                                      AIsCanInertiaScroll
                                      );
      end;
      if Assigned(FOnInnerCalcInertiaScrollDistance) then
      begin
        FOnInnerCalcInertiaScrollDistance(Self,
                                          FInertiaDistance,
                                          AIsCanInertiaScroll
                                          );
      end;
      DoCustomCalcInertiaScrollDistance(Self,
                                        FInertiaDistance,
                                        AIsCanInertiaScroll);


//      {$IFDEF MSWINDOWS}
//      //回滚到初始
//      StartScrollToInitial;
//      {$ELSE}
      if AIsCanInertiaScroll then
      begin
          //可以惯性滚动,可以反方向滚回来
          if FInertiaDistance<0 then
          begin
              case FInertiaScrollDirection of
                isdNone: ;
                isdScrollToMin: FInertiaScrollDirection:=isdScrollToMax;
                isdScrollToMax: FInertiaScrollDirection:=isdScrollToMin;
              end;
              FInertiaScrollAnimator.Min:=FInertiaDistance;
              FInertiaScrollAnimator.Max:=0;
          end
          else
          begin
              FInertiaScrollAnimator.Min:=0;
              FInertiaScrollAnimator.Max:=FInertiaDistance;
          end;

          FInertiaScrollAnimator.Start;
      end
      else
      begin
          //回滚到初始
          StartScrollToInitial;
      end;
//      {$ENDIF}



//  end
//  else
//  begin
//
//      //如果移动慢,那么不使用惯性
//      //时间太长了,如果有越界值,那么滚回初始值
//      StartScrollToInitial;
//  end;

end;

procedure TSkinControlGestureManager.StartScrollToInitial(
                                    AMinOverRangePosValue_Min:Double=0;
                                   AMaxOverRangePosValue_Min:Double=0);
begin
//  uBaseLog.OutputDebugString(GetDebugLogID+' 滚回 StartScrollToInitial FMaxOverRangePosValue '+FloatToStr(FMaxOverRangePosValue));
//  uBaseLog.OutputDebugString(GetDebugLogID+' 滚回 StartScrollToInitial FMinOverRangePosValue '+FloatToStr(FMinOverRangePosValue));



  //启动越界回滚到初始
  if (FMinOverRangePosValue<>0) or (FMaxOverRangePosValue<>0) then
  begin
      if FMinOverRangePosValue<>0 then
      begin
          //最小值越界,滚回边界
          FScrollingToInitialAnimator.Tag:=1;
          if FMinOverRangePosValue>0 then
          begin
            FScrollingToInitialAnimator.Min:=AMinOverRangePosValue_Min;
            FScrollingToInitialAnimator.Max:=FMinOverRangePosValue;
          end;
      end
      else if FMaxOverRangePosValue<>0 then
      begin
          //最大值越界,滚回边界
          FScrollingToInitialAnimator.Tag:=2;
          if FMaxOverRangePosValue>0 then
          begin
            FScrollingToInitialAnimator.Min:=AMaxOverRangePosValue_Min;
            FScrollingToInitialAnimator.Max:=FMaxOverRangePosValue;
          end;
      end;
      FScrollingToInitialAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
      FScrollingToInitialAnimator.Start;
  end
  else
  begin
      //滚动回边界结束事件
      Self.DoScrollToInitialAnimateEnd(Self);
  end;
end;

procedure TSkinControlGestureManager.CustomStartScrollToInitial(ASrcMinOverRangePosValue:Double;
                                                                ASrcMaxOverRangePosValue:Double;
                                                                ADestMinOverRangePosValue:Double;
                                                                ADestMaxOverRangePosValue:Double);
begin
  //启动越界回滚到初始
  if (ADestMinOverRangePosValue<>0) or (ADestMaxOverRangePosValue<>0) then
  begin
      if ADestMinOverRangePosValue<>0 then
      begin
          //滚回边界
          FScrollingToInitialAnimator.Tag:=1;
          if ADestMinOverRangePosValue>0 then
          begin
              FScrollingToInitialAnimator.Min:=ASrcMinOverRangePosValue;
              FScrollingToInitialAnimator.Max:=ADestMinOverRangePosValue;
              if ASrcMinOverRangePosValue>ADestMinOverRangePosValue then
              begin
                FScrollingToInitialAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
              end
              else
              begin
                FScrollingToInitialAnimator.DirectionType:=TAnimateDirectionType.adtForward;
              end;
          end;
      end
      else if ADestMaxOverRangePosValue<>0 then
      begin
          //滚回边界
          FScrollingToInitialAnimator.Tag:=2;
          if ADestMaxOverRangePosValue>0 then
          begin
              FScrollingToInitialAnimator.Min:=ASrcMaxOverRangePosValue;
              FScrollingToInitialAnimator.Max:=ADestMaxOverRangePosValue;
              if ASrcMaxOverRangePosValue>ADestMaxOverRangePosValue then
              begin
                FScrollingToInitialAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
              end
              else
              begin
                FScrollingToInitialAnimator.DirectionType:=TAnimateDirectionType.adtForward;
              end;
          end;
      end;
      FScrollingToInitialAnimator.Start;
  end
  else
  begin
      //滚动回边界结束事件
      Self.DoScrollToInitialAnimateEnd(Self);
  end;
end;

procedure TSkinControlGestureManager.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  //不要这句
//  uBaseLog.OutputDebugString(GetDebugLogID+'MouseDown('+FloatToStr(X)+','+FloatToStr(Y)+')');
  if Not FEnabled then Exit;
  FirstMouseDown(Button,Shift,X,Y);
end;

procedure TSkinControlGestureManager.MouseEnter;
begin
  if Not FEnabled then Exit;
end;

procedure TSkinControlGestureManager.MouseLeave;
begin
  if Not FEnabled then Exit;

//  if Self.FKind=gmkHorizontal then
//    OutputDebugString(GetDebugLogID+'TSkinControlGestureManager.MouseLeave');

  MouseUp({$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft,[],Self.FLastMouseMovePt.X,Self.FLastMouseMovePt.Y);
end;

procedure TSkinControlGestureManager.MouseMove(Shift: TShiftState; X, Y: Double);
var
  NewVal: TPointTime;
  NewViewportPosition: TPointD;
  D, DZ: Double;
  P: TPointD;
  I: Integer;
var
  Crement:Double;

  AMouseMoveDirection:TGestureDirection;
begin
  if Not FEnabled then Exit;

  if Self=ZoomingHorzGestureManager then Exit;
  if Self=ZoomingVertGestureManager then Exit;

  {$IFDEF MSWINDOWS}
  if GlobalIsMouseDown then
  begin
    FirstMouseDown({$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft,Shift,X,Y);
  end;
  {$ENDIF}


  //在Windows平台或MacOSX平台,如果手指没有触摸到,那么退出
  {$IFDEF MSWINDOWS}
  if Not FIsMouseDown then Exit;
  {$ENDIF}
  {$IFDEF VCL}
  if Not FIsMouseDown then Exit;
  {$ENDIF}
  {$IFDEF _MACOS}
  if Not FIsMouseDown then Exit;
  {$ENDIF}
  {$IFDEF LINUX}
  if Not FIsMouseDown then Exit;
  {$ENDIF}




  //确定不了手势方向就不更改Position
  if FHasDecidedFirstGestureKind and (FDecidedFirstGestureKind<>FKind) then
  begin
//    if Self.FKind=gmkHorizontal then
//      OutputDebugString(GetDebugLogID+'TSkinControlGestureManager.MouseMove FHasDecidedFirstGestureKind and FDecidedFirstGestureKind<>FKind 确定不了手势方向就不更改Position');
    Exit;
  end;





  {$IFDEF IOS}
  //因为在移动平台上,MouseMove可能先于MouseDown消息
  FirstMouseDown({$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft,Shift,X,Y);
  {$ENDIF}
  {$IFDEF ANDROID}
  //因为在移动平台上,MouseMove可能先于MouseDown消息
  FirstMouseDown({$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft,Shift,X,Y);
  {$ENDIF}



  //当前鼠标的坐标
  Self.FMouseMovePt:=PointF(X,Y);
  Self.FMouseMoveAbsolutePt:=PointF(X,Y);
  {$IFDEF FMX}
  if (FParentControl<>nil) and (FParentControl is TControl) then
  begin
    //获取绝对坐标
    FMouseMoveAbsolutePt:=TControl(Self.FParentControl).LocalToAbsolute(FMouseMovePt);
  end;
  {$ENDIF}





  if Down and ([ttVertical, ttHorizontal] * TouchTracking <> []) then
  begin
    if not FMoved then
    begin
//      uBaseLog.OutputDebugString('MouseMove Begin '+FormatDateTime('HH:MM:SS ZZZ',Now));
      //还没有移动过,第一次移动
      P := TPointD.Create(FMouseMoveAbsolutePt.X, FMouseMoveAbsolutePt.Y);

      //计算出距离
      if TouchTracking = [ttVertical, ttHorizontal] then
        D := P.Distance(FDownPoint)
      else if (TouchTracking = [ttVertical]) then
        D := Abs(P.Y - FDownPoint.Y)
      else if (TouchTracking = [ttHorizontal]) then
        D := Abs(P.X - FDownPoint.X)
      else
        D := 0;

      if Averaging //and Animation
      then
      begin
        //起始距离
        DZ := Math.Max(FDeadZone, 1);
        if D > DZ then
        begin
          //如果大于死区,那么开始移动了
          FMoved := True;
          //按下的坐标,视图位置
          FDownPoint := TPointD.Create(FMouseMoveAbsolutePt.X, FMouseMoveAbsolutePt.Y);
          FDownPosition := ViewportPosition;
        end;
      end
      else
      begin
        FMoved := D > 0;
      end;

      if FMoved then
      begin
        FMoved := True;
        //调用Start
        InternalStart;
      end;
//      uBaseLog.OutputDebugString('MouseMove End   '+FormatDateTime('HH:MM:SS ZZZ',Now));

    end;

    if FMoved then
    begin
      //移动过了
      NewVal := AddPointTime(FMouseMoveAbsolutePt.X, FMouseMoveAbsolutePt.Y);
      //设置视图
      if (ttHorizontal in TouchTracking) then
        NewViewportPosition.X := FDownPosition.X - (NewVal.Point.X - FDownPoint.X)
      else
        NewViewportPosition.X := ViewportPosition.X;

      if (ttVertical in TouchTracking) then
        NewViewportPosition.Y := FDownPosition.Y - (NewVal.Point.Y - FDownPoint.Y)
      else
        NewViewportPosition.Y := ViewportPosition.Y;
      //只保留最近一段时间的时间点StorageTime
      Clear;
      //当前的位置
      ViewportPosition := NewViewportPosition;
      //更新拖动的方向
      //设置FTarget为ViewportPosition
      UpdateTarget;
    end;
  end;


















  //不管是任何情况,都需要如下判断
  //如果拖动超出了一定的距离,就不需要再判断了
  if Not FHasDecidedFirstGestureKind then
  begin

      //计算当前所有响应的手势管理列表
      //如果别的ControlGestureManager已经判断了方向
      //那么自己就不再响应MouseMove消息了
      //别的CurrentGestureManagerList是怎么加入到列表中的??
      for I := 0 to CurrentGestureManagerList.Count-1 do
      begin
        if  (CurrentGestureManagerList[I]<>Self)
            and CurrentGestureManagerList[I].FIsNeedDecideFirstGestureKind
            and CurrentGestureManagerList[I].FHasDecidedFirstGestureKind
            and (CurrentGestureManagerList[I].FDecidedFirstGestureKind<>gmkNone) then
        begin
          //别的ControlGestureManager已经判断了方向
          //自已就不再响应了
          FHasDecidedFirstGestureKind:=True;
          FDecidedFirstGestureKind:=gmkNone;
//          OutputDebugString(CurrentGestureManagerList[I].GetDebugLogID
//                            +'的ControlGestureManager已经判断了方向'
//                            );
        end;
      end;


  end
  else
  begin
      //已经判断方向
  end;









  if Not Self.FIsStartDrag then
  begin
      //先判断可以手势的方向



      //需要确定手势方向
      if FIsNeedDecideFirstGestureKind
        //还没有确定手势方向
       and not FHasDecidedFirstGestureKind then
      begin
        //判断此区域是否需要判断方向
        if Assigned(Self.FOnPrepareDecidedFirstGestureKind) then
        begin
          FOnPrepareDecidedFirstGestureKind(Self,
                                              X,
                                              Y,
                                              FHasDecidedFirstGestureKind,
                                              FDecidedFirstGestureKind);
        end;
      end;



        //需要确定手势方向
      if FIsNeedDecideFirstGestureKind
        //还没有确定手势方向
       and not FHasDecidedFirstGestureKind then
      begin



          case Self.Kind of
            gmkHorizontal:
            begin
                  //水平滚动条

                  if  //精度限制
                      (GetDis(Self.FMouseMoveAbsolutePt,Self.FFirstMouseMoveAbsolutePt)>=Self.FDecideFirstGestureKindDistance)
                      //水平方向的角度限制
                    and (GetAbsAngle(Self.FMouseMoveAbsolutePt.X,Self.FMouseMoveAbsolutePt.Y,Self.FFirstMouseMoveAbsolutePt.X,Self.FFirstMouseMoveAbsolutePt.Y,True)<=Self.FDecideFirstGestureKindAngle) then
                  begin

                      if (FMouseMoveAbsolutePt.X - Self.FLastMouseMoveAbsolutePt.X)>0 then
                      begin
                        AMouseMoveDirection:=isdScrollToMax;
                      end
                      else
                      begin
                        AMouseMoveDirection:=isdScrollToMin;
                      end;
                      if AMouseMoveDirection<>FMouseMoveDirection then
                      begin
                        FMouseMoveDirection:=AMouseMoveDirection;
                        Self.FLastMouseMoveDirectionChangePoint:=FMouseMovePt;
                      end;


                      //恢复成初始的点击坐标
                      FLastMouseMovePt:=FFirstMouseMovePt;
                      FLastMouseMoveAbsolutePt:=FFirstMouseMoveAbsolutePt;


                      if FMouseMoveDirection in FDecideFirstGestureKindDirections then
                      begin
                        //判断成功
//                        OutputDebugString(GetDebugLogID+'方向判断成功');
                        FDecidedFirstGestureKind:=gmkHorizontal;
                      end
                      else
                      begin
//                        OutputDebugString(GetDebugLogID+'方向不匹配');
                      end;

                      //判断结束
                      FHasDecidedFirstGestureKind:=True;


                  end
                  else
                  begin
                      //距离不够或角度不匹配
//                      OutputDebugString(GetDebugLogID+'正在匹配方向');
                  end;


                  //手势滑动的距离超出了,表示判断结束
                  if (GetDis(Self.FMouseMoveAbsolutePt,Self.FFirstMouseMoveAbsolutePt)>=Self.FDecideFirstGestureKindDistance) then
                  begin
//                    OutputDebugString(GetDebugLogID+'距离超出了,方向判断结束');
                    FHasDecidedFirstGestureKind:=True;
                  end;


            end;
            gmkVertical:
            begin
                  //垂直滚动条

                  if    //精度限制
                        (GetDis(Self.FMouseMoveAbsolutePt,Self.FFirstMouseMoveAbsolutePt)>=Self.FDecideFirstGestureKindDistance)
                        //垂直角度限制
                    and (GetAbsAngle(Self.FMouseMoveAbsolutePt.X,Self.FMouseMoveAbsolutePt.Y,Self.FFirstMouseMoveAbsolutePt.X,Self.FFirstMouseMoveAbsolutePt.Y,False)<=Self.FDecideFirstGestureKindAngle) then
                  begin

                      if (FMouseMoveAbsolutePt.Y - Self.FLastMouseMoveAbsolutePt.Y)>0 then
                      begin
                        AMouseMoveDirection:=isdScrollToMax;
                      end
                      else
                      begin
                        AMouseMoveDirection:=isdScrollToMin;
                      end;
                      if AMouseMoveDirection<>FMouseMoveDirection then
                      begin
                        FMouseMoveDirection:=AMouseMoveDirection;
                        Self.FLastMouseMoveDirectionChangePoint:=FMouseMovePt;
                      end;


                      //恢复成初始的点击坐标
                      FLastMouseMovePt:=FFirstMouseMovePt;
                      FLastMouseMoveAbsolutePt:=FFirstMouseMoveAbsolutePt;

                      //判断成功
                      if FMouseMoveDirection in FDecideFirstGestureKindDirections then
                      begin
                        FDecidedFirstGestureKind:=gmkVertical;
//                        OutputDebugString(GetDebugLogID+'方向判断成功');
                      end
                      else
                      begin
//                        OutputDebugString(GetDebugLogID+'方向不匹配');
                      end;

                      //判断结束
                      FHasDecidedFirstGestureKind:=True;


                  end
                  else
                  begin
                      //距离不够或角度不匹配
//                      OutputDebugString(GetDebugLogID+'正在匹配方向');
                  end;


                  //手势滑动的距离超出了,表示判断结束
                  if (GetDis(Self.FMouseMoveAbsolutePt,Self.FFirstMouseMoveAbsolutePt)>=Self.FDecideFirstGestureKindDistance) then
                  begin
//                    OutputDebugString(GetDebugLogID+'距离超出了,方向判断结束');
                    FHasDecidedFirstGestureKind:=True;
                  end;

            end;
          end;





          //判断方向结束事件
          if FHasDecidedFirstGestureKind then
          begin
            if FDecidedFirstGestureKind=gmkNone then
            begin
//              OutputDebugString(GetDebugLogID+'方向判断失败');
            end;

            if Assigned(Self.FOnDecidedFirstGestureKind) then
            begin
              FOnDecidedFirstGestureKind(Self);
            end;
          end;


      end;



      //距离超出了,表示判断结束
      if (GetDis(Self.FMouseMoveAbsolutePt,Self.FFirstMouseMoveAbsolutePt)>=Self.FDecideFirstGestureKindDistance) then
      begin
//        OutputDebugString(GetDebugLogID+'距离超出了,方向判断结束');
        FHasDecidedFirstGestureKind:=True;
      end;

  end;







  //确定不了手势方向就不更改Position
  if (FDecidedFirstGestureKind<>FKind) then
  begin
//    if Self.FKind=gmkHorizontal then
//      OutputDebugString(GetDebugLogID+'TSkinControlGestureManager.MouseMove FDecidedFirstGestureKind<>FKind 确定不了手势方向就不更改Position');

    Exit;
  end;







  //第一次确定手指滑动的时候,记录下滚动开始的位置,时间
  if Not Self.FIsStartDrag then
  begin


      Self.FIsStartDrag:=True;



      //停止回滚到初始的定时器
      //这里要特殊处理,如果正在加载中,拖动的时候,停止的话,就停在中间了
      if FScrollingToInitialAnimator.IsRuning then
      begin
        FScrollingToInitialAnimator.Pause;
      end;


      //停止惯性滚动的定时器
      if FInertiaScrollAnimator.IsRuning then
      begin
        FInertiaScrollAnimator.Pause;
      end;


      //开始拖动
      if Assigned(FOnStartDrag) then
      begin
        FOnStartDrag(Self);
      end;

      DoCustomStartDrag(Self);

  end;





  //鼠标移动
  if Self.FIsStartDrag then
  begin
    //手指滑动的时候,到达一定的偏移才开始滚动,可以提高绘制效率
    if (GetDis(Self.FLastMouseMoveAbsolutePt,FMouseMoveAbsolutePt)>=FDecideDoDragDirectionCrement)  then
    begin

          //移动一段距离才显示滚动条
          //检测用户是否停止滚动
          SetIsDraging(True);
          Self.FIsDraging:=True;



          //第二次鼠标移动
          //直接滚动
          case Self.Kind of
            gmkHorizontal:
            begin

                //更新位置(正常模式)
                Crement:=FMouseMoveAbsolutePt.X - Self.FLastMouseMoveAbsolutePt.X;

                //更新位置(正常模式)
                Self.Position:=Self.FPosition-Crement;
//                uBaseLog.OutputDebugString(GetDebugLogID+' 更新位置 Crement:'+FloatToStr(-Crement)
//                                                  +' FPosition:'+FloatToStr(FPosition)
//                                                  +' FMaxOverRangePosValue:'+FloatToStr(FMaxOverRangePosValue)
//                                                  +' FLastMouseMoveAbsolutePt.X:'+FloatToStr(FLastMouseMoveAbsolutePt.X)
//                                                  +' FMouseMoveAbsolutePt.X:'+FloatToStr(FMouseMoveAbsolutePt.X)
//                                                  );

            end;
            gmkVertical:
            begin

                Crement:=FMouseMoveAbsolutePt.Y - Self.FLastMouseMoveAbsolutePt.Y;

                //更新位置(正常模式)
                Self.Position:=Self.FPosition-Crement;
//                uBaseLog.OutputDebugString(GetDebugLogID+' 更新位置 Crement:'+FloatToStr(-Crement)
//                                                  +' FPosition'+FloatToStr(FPosition)
//                                                  +' FMaxOverRangePosValue'+FloatToStr(FMaxOverRangePosValue)
//                                                  +' FLastMouseMoveAbsolutePt.Y:'+FloatToStr(FLastMouseMoveAbsolutePt.Y)
//                                                  +' FMouseMoveAbsolutePt.Y:'+FloatToStr(FMouseMoveAbsolutePt.Y)
//                                                  );
            end;
          end;



          //确定方向
          if (Crement>=0) then//2) then
          begin
            AMouseMoveDirection:=isdScrollToMin;
          end
          else if (Crement<=0) then//-2) then
          begin
            AMouseMoveDirection:=isdScrollToMax;
          end;
          if AMouseMoveDirection<>FMouseMoveDirection then
          begin
            FMouseMoveDirection:=AMouseMoveDirection;
            Self.FLastMouseMoveDirectionChangePoint:=FMouseMovePt;
          end;


          //确定方向
          if (Crement>=0) then//FDecideInertiaDirectionCrement) then
          begin
            Self.FInertiaScrollDirection:=isdScrollToMin;
          end;
          if (Crement<=0) then//-FDecideInertiaDirectionCrement) then
          begin
            Self.FInertiaScrollDirection:=isdScrollToMax;
          end;

    end
    else
    begin

//        if Self.FKind=gmkHorizontal then
//          OutputDebugString(GetDebugLogID+'TSkinControlGestureManager.MouseMove distance < '+IntToStr(FDecideDoDragDirectionCrement));


    end;
  end
  else
  begin
//    if Self.FKind=gmkHorizontal then
//      OutputDebugString(GetDebugLogID+'TSkinControlGestureManager.MouseMove not FIsStartDrag');


  end;



  Self.FLastMouseMovePt:=Self.FMouseMovePt;
  FLastMouseMoveAbsolutePt:=Self.FMouseMoveAbsolutePt;
end;

procedure TSkinControlGestureManager.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin

//    if Self.FKind=gmkHorizontal then
//      uBaseLog.OutputDebugString(GetDebugLogID+'MouseUp');
//    uBaseLog.OutputDebugString(GetDebugLogID+'MouseUp('+FloatToStr(X)+','+FloatToStr(Y)+')');
//    uBaseLog.OutputDebugString(GetDebugLogID+'MouseDown('+FloatToStr(Self.FFirstMouseMovePt.X)+','+FloatToStr(Self.FFirstMouseMovePt.Y)+')');

    if Not FEnabled then Exit;


    //从激活手势列表去排除
    CurrentGestureManagerList.Remove(Self,False);

    //用于ClipHeadFrame
    if Self=ZoomingHorzGestureManager then
    begin
        CancelMouseUp;
        ZoomingHorzGestureManager:=nil;

        Exit;
    end;
    if Self=ZoomingVertGestureManager then
    begin
        CancelMouseUp;
        ZoomingVertGestureManager:=nil;
        Exit;
    end;


    Self.FMouseMovePt:=PointF(X,Y);
    Self.FMouseMoveAbsolutePt:=PointF(X,Y);
    {$IFDEF FMX}
    if (FParentControl<>nil) and (FParentControl is TControl) then
    begin
      //获取绝对坐标
      FMouseMoveAbsolutePt:=TControl(Self.FParentControl).LocalToAbsolute(FMouseMovePt);
    end;
    {$ENDIF}



    if Down then
    begin


//      if Self.FKind=gmkHorizontal then
//        uBaseLog.OutputDebugString(GetDebugLogID+'MouseUp MouseMove Begin');
      //最后再来个MouseMove
      MouseMove(Shift,X, Y);
//      if Self.FKind=gmkHorizontal then
//        uBaseLog.OutputDebugString(GetDebugLogID+'MouseUp MouseMove End');


  //    //添加坐标点
  //    AddPointTime(X, Y, Now);

      //计算速度
      CalcVelocity;

      //弹起的速度
      FUpVelocity := CurrentVelocity;
      //弹起的位置
      FUpPosition := ViewportPosition;

      UpdateTimer;

  //    if (not Animation) then
  //    begin
  //      UpdateViewportPositionByBounds;
  //    end;

      Down := False;
    end;







    FIsMouseDown:=False;


    if FIsStartDrag then
    begin


        //停止滚动
        Self.FIsStartDrag:=False;


        //用户不滚动了
        SetIsDraging(False);
        Self.FIsDraging:=False;


        //停止拖动
        if Assigned(FOnStopDrag) then
        begin
          FOnStopDrag(Self);
        end;



        if Self.FCheckUserStopMouseWheelTimer<>nil then
        begin
          Self.FCheckUserStopMouseWheelTimer.Enabled:=False;
        end;


        if (FDecidedFirstGestureKind=FKind) then
        begin
//          if Self.FKind=gmkHorizontal then
//            OutputDebugString(GetDebugLogID+'TSkinControlGestureManager.MouseUp 启动惯性滚动');
          //启动惯性滚动
          Self.StartInertiaScroll;
        end
        else
        begin
//          OutputDebugString(GetDebugLogID+'方向不对,不启动惯性滚动');
        end;

    end;


end;

procedure TSkinControlGestureManager.CancelInertiaScroll;
begin
  Self.FUpVelocity.X:=0;
  Self.FUpVelocity.Y:=0;
end;

procedure TSkinControlGestureManager.CancelMouseUp;
begin
//  Self.FEnabled:=False;
  FIsMouseDown:=False;
  Self.FIsStartDrag:=False;

//  if FCancelMouseUpTimer=nil then
//  begin
//    FCancelMouseUpTimer:=TTimer.Create(Self);
//    FCancelMouseUpTimer.Interval:=100;
//    FCancelMouseUpTimer.OnTimer:=Self.DoCancelMouseUpTimer;
//  end;
//  FCancelMouseUpTimer.Enabled:=False;
//  FCancelMouseUpTimer.Enabled:=True;
end;

function TSkinControlGestureManager.MouseWheel(Shift: TShiftState; WheelDelta:Integer; X,Y: Double): Boolean;
//var
//  DX, DY: Double;
//  NewTarget: TTarget;
//begin
//  DX := RoundTo(X, EpsilonRange);
//  DY := RoundTo(Y, EpsilonRange);
//  if (DX <> 0) or (DY <> 0) then
//  begin
//    NewTarget.TargetType := TTargetType.ttOther;
//    if FMouseTarget.TargetType <> TTargetType.ttOther then
//    begin
//      NewTarget.Point := ViewportPosition;
//    end
//    else
//    begin
//      NewTarget.Point := FMouseTarget.Point;
//    end;
//    NewTarget.Point.Offset(DX, DY);
//    FUpdateTimerCount := 0;
//    FUpdateTimerCount := -1;
//    SetMouseTarget(NewTarget);
//  end;
begin
  if Not FEnabled then Exit;





  case Self.FKind of
    gmkNone: ;
    gmkHorizontal: ;
    gmkVertical:
    begin
  //      OutputDebugString('MouseWheel '+IntToStr(WheelDelta));

        Self.SetIsDraging(True);
        //检查用户什么时候停止滚动
        Self.CreateCheckUserStopMouseWheelTimer;
        Self.FCheckUserStopMouseWheelTimer.Enabled:=True;



        //停止回滚到初始的定时器
        if FScrollingToInitialAnimator.IsRuning then
        begin
          FScrollingToInitialAnimator.Pause;
        end;


        //停止惯性滚动定时器
        if Self.FInertiaScrollAnimator.IsRuning then
        begin
          FInertiaScrollAnimator.Pause;
        end;



        //更新位置(正常模式)
        Self.Position:=Self.Position-WheelDelta/Self.LargeChange*3;
        Self.FUpVelocity.Y:=-(WheelDelta*LargeChange);
    end;
  end;

end;

//{$IFDEF FMX}
//procedure TSkinControlGestureManager.Gesture(const EventInfo: TGestureEventInfo; var Handled: Boolean);
//begin
//  if EventInfo.GestureID = igiPan then
//  begin
//    Handled:=True;
//
//    //弹起的时候自动回缩
//    Self.IsDraging:=True;
//
//    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
//    begin
//      //保存初始的手指位置
//      Self.FChangeInertiaScrollDirectionTime:=Now;
//    end
//    else
//    begin
//      if TInteractiveGestureFlag.gfEnd in EventInfo.Flags then
//      begin
//
//        Self.FIsDraging:=False;
//        if Self.FCheckUserStopMouseWheelTimer<>nil then
//        begin
//          Self.FCheckUserStopMouseWheelTimer.Enabled:=False;
//        end;
//
//        //惯性滚动
//        Self.StartInertiaScroll;
//
//      end;
//    end;
//  end;
//end;
//{$ENDIF}

//键盘事件
procedure TSkinControlGestureManager.KeyDown(Key: Word; Shift: TShiftState);
//const
//  vkLeft             = $25;  {  37 }
//  vkUp               = $26;  {  38 }
//  vkRight            = $27;  {  39 }
//  vkDown             = $28;  {  40 }
begin
//
//  if (((Self.FKind=gmkHorizontal) and (Key=vkLeft))
//    or ((Self.FKind=gmkVertical) and (Key=vkUp)))
//    and (Self.FMin<>Self.FPosition) then
//  begin
//    //减小
//    FKeyPressScrollAnimator.Pause;
//
//    FKeyPressScrollAnimator.Min:=Self.FMin;
//    FKeyPressScrollAnimator.Max:=Self.FPosition;
//
//    FKeyPressScrollDirection:=isdScrollToMin;
//
//    FKeyPressScrollAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
//
//    FKeyPressScrollAnimator.Speed:=10;
//    FKeyPressScrollAnimator.EndTimesCount:=GetKeyPressScrollAnimatorEndTimesCount;
//
//    FKeyPressScrollAnimator.Start;
//
//    FKeyPressScrollAnimator.DoTimer(nil);
//
//    //速度调整的定时器
//    Self.CreateKeyPressAdjustSpeedTimer;
//    Self.FKeyPressAdjustSpeedType:=kpastAdd;
//    FKeyPressAdjustSpeedTimer.Interval:=200;
//    Self.FKeyPressAdjustSpeedTimer.Enabled:=True;
//
//
//    //检测用户是否停止滚动
//    SetIsDraging(True);
//    Self.FIsDraging:=True;
//
//  end;
//
//  if (((Self.FKind=gmkHorizontal) and (Key=vkRight))
//    or ((Self.FKind=gmkVertical) and (Key=vkDown)))
//    and (Self.FMax<>Self.FPosition) then
//  begin
//    //增大
//    FKeyPressScrollAnimator.Pause;
//
//    FKeyPressScrollAnimator.Min:=Self.FPosition;
//    FKeyPressScrollAnimator.Max:=Self.FMax;
//
//    FKeyPressScrollDirection:=isdScrollToMax;
//
//    FKeyPressScrollAnimator.DirectionType:=TAnimateDirectionType.adtForward;
//
//    FKeyPressScrollAnimator.Speed:=10;
//    FKeyPressScrollAnimator.EndTimesCount:=GetKeyPressScrollAnimatorEndTimesCount;
//
//    FKeyPressScrollAnimator.Start;
//
//    FKeyPressScrollAnimator.DoTimer(nil);
//
//    //速度调整的定时器
//    Self.CreateKeyPressAdjustSpeedTimer;
//    Self.FKeyPressAdjustSpeedType:=kpastAdd;
//    FKeyPressAdjustSpeedTimer.Interval:=200;
//    Self.FKeyPressAdjustSpeedTimer.Enabled:=True;
//
//
//    //检测用户是否停止滚动
//    SetIsDraging(True);
//    Self.FIsDraging:=True;
//
//  end;

end;

procedure TSkinControlGestureManager.KeyUp(Key: Word; Shift: TShiftState);
//const
//  vkLeft             = $25;  {  37 }
//  vkUp               = $26;  {  38 }
//  vkRight            = $27;  {  39 }
//  vkDown             = $28;  {  40 }
begin
//  if (((Self.FKind=gmkHorizontal) and (Key=vkLeft))
//    or ((Self.FKind=gmkVertical) and (Key=vkUp)))
//    or (((Self.FKind=gmkHorizontal) and (Key=vkRight))
//    or ((Self.FKind=gmkVertical) and (Key=vkDown))) then
//  begin
//    //减小
//
//    //停止移动
//    //惯性滚动一点点
//    //减小速度,直到停止
//    Self.CreateKeyPressAdjustSpeedTimer;
//    Self.FKeyPressAdjustSpeedType:=kpastDec;
//    Self.FKeyPressAdjustSpeedTimer.Interval:=100;
//    Self.FKeyPressAdjustSpeedTimer.Enabled:=True;
//
//    //用户不滚动了
//    SetIsDraging(False);
//    Self.FIsDraging:=False;
//  end;

end;


function AniSign(const CurrentValue, TargetValue, EpsilonPoint: Double): TValueSign;
begin
  Result := -CompareValue(CurrentValue, TargetValue, EpsilonPoint);
end;


{ TPointD }

constructor TPointD.Create(const P: TPointD);
begin
  self.X := P.X;
  self.Y := P.Y;
end;

constructor TPointD.Create(const X, Y: Double);
begin
  self.X := X;
  self.Y := Y;
end;

//constructor TPointD.Create(const P: TPoint);
//begin
//  self.X := P.X;
//  self.Y := P.Y;
//end;

constructor TPointD.Create(const P: TPointF);
begin
  self.X := P.X;
  self.Y := P.Y;
end;

class operator TPointD.Equal(const Lhs, Rhs: TPointD): Boolean;
begin
  Result := SameValue(Lhs.X, Rhs.X) and
    SameValue(Lhs.Y, Rhs.Y);
end;

class operator TPointD.Implicit(const APointF: TPointF): TPointD;
begin
  Result.X := APointF.X;
  Result.Y := APointF.Y;
end;

class operator TPointD.NotEqual(const Lhs, Rhs: TPointD): Boolean;
begin
  Result := not(Lhs = Rhs);
end;

class operator TPointD.Add(const Lhs, Rhs: TPointD): TPointD;
begin
  Result.X := Lhs.X + Rhs.X;
  Result.Y := Lhs.Y + Rhs.Y;
end;

class operator TPointD.Subtract(const Lhs, Rhs: TPointD): TPointD;
begin
  Result.X := Lhs.X - Rhs.X;
  Result.Y := Lhs.Y - Rhs.Y;
end;

function TPointD.Abs: Double;
begin
  Result := Sqrt(Sqr(self.X) + Sqr(self.Y));
end;

function TPointD.Distance(const P2: TPointD): Double;
begin
  Result := Sqrt(Sqr(self.X - P2.X) + Sqr(self.Y - P2.Y));
end;

procedure TPointD.Offset(const DX, DY: Double);
begin
  self.X := self.X + DX;
  self.Y := self.Y + DY;
end;

procedure TPointD.SetLocation(const P: TPointD);
begin
  self.X := RoundTo(P.X, EpsilonRange);
  self.Y := RoundTo(P.Y, EpsilonRange);
end;



{ TSkinControlGestureManager }

//constructor TSkinControlGestureManager.Create(AOwner: TPersistent);
//begin
//  inherited Create;
//  FOwner := AOwner;
//
//  FTimerHandle := TFmxHandle(-1);
//
//  BeginUpdate;
//
//  FPointTimeList := TPointTimeList.Create;
//
//  if not TPlatformServices.Current.SupportsPlatformService(IFMXTimerService, FPlatformTimer) then
//    raise EUnsupportedPlatformService.Create('IFMXTimerService');
//
//  //初始
//  Assign(nil);
//
//end;
//
//destructor TSkinControlGestureManager.Destroy;
//begin
//  StopTimer;
//  FreeAndNil(FPointTimeList);
//  inherited;
//end;

procedure TSkinControlGestureManager.AfterConstruction;
begin
  inherited;
  EndUpdate;
end;

//procedure TSkinControlGestureManager.Assign(Source: TPersistent);
//var
//  LSource: TSkinControlGestureManager;
//  LTargets: array of TTarget;
//begin
//  if Source is TSkinControlGestureManager then
//  begin
//    LSource := TSkinControlGestureManager(Source);
//    MinVelocity := LSource.MinVelocity;
//    MaxVelocity := LSource.MaxVelocity;
//    DeadZone := LSource.DeadZone;
//    Animation := LSource.Animation;
//    AutoShowing := LSource.AutoShowing;
//    Averaging := LSource.Averaging;
//    BoundsAnimation := LSource.BoundsAnimation;
//    Interval := LSource.Interval;
//    TouchTracking := LSource.TouchTracking;
//    LSource.GetTargets(LTargets);
//    SetTargets(LTargets);
//    DecelerationRate := LSource.DecelerationRate;
//    Elasticity := LSource.Elasticity;
//    StorageTime := LSource.StorageTime;
//  end
//  else if not Assigned(Source) then
//  begin
//    MinVelocity := DefaultMinVelocity;
//    MaxVelocity := DefaultMaxVelocity;
//    DeadZone := DefaultDeadZone;
//    Animation := False;
//    AutoShowing := False;
//    Averaging := False;
//    BoundsAnimation := True;
//    Interval := DefaultIntervalOfAni;
//    TouchTracking := [ttVertical, ttHorizontal];
//    SetTargets([]);
//    DecelerationRate := DecelerationRateNormal;
//    Elasticity := DefaultElasticity;
//    StorageTime := DefaultStorageTime;
//  end
//  else
//    inherited;
//end;

function TSkinControlGestureManager.GetInternalTouchTracking: TTouchTracking;
begin
  Result := FTouchTracking;
//  if FMouseTarget.TargetType = TTargetType.ttOther then//MouseWheel
//  begin
//    if not SameValue(FMouseTarget.Point.X, FViewportPosition.X, EpsilonPoint)
//    then
//      Result := Result + [ttHorizontal];
//
//    if not SameValue(FMouseTarget.Point.Y, FViewportPosition.Y, EpsilonPoint)
//    then
//      Result := Result + [ttVertical];
//  end;
end;

function TSkinControlGestureManager.GetOpacity: Single;
begin
  Result := Math.Min(1, Math.Max(0, FOpacity));
end;

//function TSkinControlGestureManager.GetOwner: TPersistent;
//begin
//  Result := FOwner;
//end;

//procedure TSkinControlGestureManager.SetAnimation(const Value: Boolean);
//begin
//  if FAnimation <> Value then
//  begin
//    FAnimation := Value;
//
//    FLastTimeCalc := 0;
//
//    FCurrentVelocity := TPointD.Create(0, 0);
//
//    UpdateTimer;
//
//    if (not Animation) then
//    begin
//      UpdatePosImmediately(True);
//    end;
//  end;
//end;
//
//procedure TSkinControlGestureManager.SetBoundsAnimation(const Value: Boolean);
//begin
//  if FBoundsAnimation <> Value then
//  begin
//    FBoundsAnimation := Value;
//    SetViewportPosition(ViewportPosition);
//  end;
//end;

procedure TSkinControlGestureManager.SetDown(const Value: Boolean);
var
  Target: TTarget;
  T: TDateTime;
begin
  if FDown <> Value then
  begin
    T := Now;
    if Value then
    begin
      //按下了
      FDown := Value;
//      uBaseLog.OutputDebugString('FDown=True');
      //清除记录时间点
      FPointTimeList.Clear;

      if not Averaging then
      begin
        FCurrentVelocity := TPointD.Create(0, 0);
      end;

      //上次计算速度的时间
      FLastTimeCalc := 0;

      FUpDownTime := T;

      //设置方向
      Target.TargetType := TTargetType.ttAchieved;
      Target.Point := TPointD.Create(0, 0);

      //设置方向
      SetMouseTarget(Target);
    end
    else
    begin
//      uBaseLog.OutputDebugString('FDown=False');

      //弹起了
      try
        DoStopScrolling(T);
        FUpDownTime := T;
      finally
        FDown := Value;
      end;

    end;

    UpdateTimer;

//    //设置显示坐标
//    if (not FDown) and (not Animation)
//    and (InternalTouchTracking <> []) then
//    begin
//      UpdatePosImmediately;
//    end;
  end;
end;

procedure TSkinControlGestureManager.InternalStart;
begin
  if //(not FInDoStart) and
   (not FStarted) then
  begin
//    FInDoStart := True;
//    try
//      DoStart;
      FStarted := True;
//    finally
//      FInDoStart := False;
//    end;
  end;
end;

procedure TSkinControlGestureManager.InternalTerminated;
var
  Target: TTarget;
begin
  if //(not FInDoStop) and
  (FStarted) then
  begin
//    FInDoStop := True;
//    try
      Target.TargetType := TTargetType.ttAchieved;
      Target.Point := TPointD.Create(0, 0);
      SetMouseTarget(Target);
//      DoStop;
      FStarted := False;
//    finally
//      FInDoStop := False;
//    end;
  end;
end;

function TSkinControlGestureManager.IsSmall(const P: TPointD; const Epsilon: Double): Boolean;
var
  LTouchTracking: TTouchTracking;
begin
  LTouchTracking := InternalTouchTracking;

  if LTouchTracking = [ttVertical, ttHorizontal] then
    Result := P.Abs < Epsilon
  else if LTouchTracking = [ttVertical] then
    Result := System.Abs(P.Y) < Epsilon
  else if LTouchTracking = [ttHorizontal] then
    Result := System.Abs(P.X) < Epsilon
  else
    Result := True
end;

function TSkinControlGestureManager.IsSmall(const P: TPointD): Boolean;
begin
  Result := IsSmall(P, EpsilonPoint);
end;

procedure TSkinControlGestureManager.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;

//  if FEnabled <> Value then
//  begin
//
//    if Value and (FInterval > 0) then
//    begin
//      if FUpdateCount = 0 then
//      begin
////        uBaseLog.OutputDebugString('启动计时器');
//        InternalStart;
//        StartTimer;
//        FEnabled := Value;
//      end;
//    end
//    else
//    begin
////      uBaseLog.OutputDebugString('停止计时器');
//      StopTimer;
//      FEnabled := Value;
//      InternalTerminated;
//    end;
//
//  end;
end;

procedure TSkinControlGestureManager.SetInterval(const Value: Integer);
begin
  if FInterval <> Value then
  begin
    StopTimer;
    FInterval := Value;
    if FEnabled and
      (FInterval > 0) and (FUpdateCount <= 0)
    then
    begin
      StartTimer;
    end;
  end;
end;

function TSkinControlGestureManager.GetViewportPositionF: TPointF;
begin
  Result.X := FViewportPosition.X;
  Result.Y := FViewportPosition.Y;
end;

procedure TSkinControlGestureManager.SetViewportPosition(const Value: TPointD);
var
  LChanged: Boolean;
  OldViewportPosition: TPointD;
  Target: TTarget;
begin
  OldViewportPosition := FViewportPosition;
  FViewportPosition := Value;


//  UpdateViewportPositionByBounds;


  LChanged := FViewportPosition <> OldViewportPosition;
  if LChanged and (not FInTimerProc) then
  begin


    Target.TargetType := TTargetType.ttAchieved;
    Target.Point := TPointD.Create(0, 0);
    SetMouseTarget(Target);


    if Down then
    begin
      //如果按下了
//      InternalChanged;
    end
    else
    begin
      //如果没有按下
      UpdateTimer;
//      InternalChanged;
    end;


  end;
end;

procedure TSkinControlGestureManager.SetViewportPositionF(const Value: TPointF);
var
  NewValue: TPointD;
begin
  NewValue := TPointD.Create(Value);
  ViewportPosition := NewValue;
end;

procedure TSkinControlGestureManager.SetTouchTracking(const Value: TTouchTracking);
begin
  if FTouchTracking <> Value then
  begin
    FTouchTracking := Value;
    UpdateTimer;
  end;
end;

procedure TSkinControlGestureManager.SetShown(const Value: Boolean);
var
  NewVisible, ChangeOpacity: Boolean;
begin
  NewVisible := (not AutoShowing) or (Value);

  //是否需要更改透明度
  ChangeOpacity := ((FOpacity < MaxOpacity) and (NewVisible))
                    or ((FOpacity > 0) and (not NewVisible));

  FShown := Value;

  //如果需要改透明度,那么更新定时器
  if ChangeOpacity then
  begin
    FUpdateTimerCount := -1;
    UpdateTimer;
  end;

end;

procedure TSkinControlGestureManager.StartTimer;
begin
  if FTimer=nil then
  begin
    FTimer:=TPlatformTimer.Create(nil);//(nil);
    FTimer.OnTimer:=TimerProc;
  end;
  FTimer.Interval:=FInterval;
  FTimer.Enabled:=True;
//  if FTimerHandle = TFmxHandle(-1) then
//  begin
//    FTimerHandle := FPlatformTimer.CreateTimer(FInterval, TimerProc);
//  end;
end;

procedure TSkinControlGestureManager.StopTimer;
begin
//  if FTimerHandle <> TFmxHandle(-1) then
//  begin
//    FPlatformTimer.DestroyTimer(FTimerHandle);
//    FTimerHandle := TFmxHandle(-1);
//  end;
  if FTimer<>nil then
  begin
    FTimer.Enabled:=False;
  end;
end;

//procedure TSkinControlGestureManager.DoCalc(const DeltaTime: Double;
//  var NewPoint, NewVelocity: TPointD;
//  var Done: Boolean);
//var
//  //计算下一步的速度和位置
//  procedure UpdatePhysicalParameters(const Target: Double;
//                                      var Pos,
//                                      Velocity: Double;
//                                      const ADecelerationRate: Double;
//                                      const EnableTarget: Boolean;
//                                      const CancelTarget: Boolean;
//                                      var ElasticityFactor: Integer);
//  var
//    dV, DX, aT, aTDecelerationRate, Tmp, R: Double;
//    LSign, LSignV: TValueSign;
//  begin
//
//    //滚动的方向
//    LSign := AniSign(Pos, Target, EpsilonPoint);
//    //速度的方向,1正方向,0相等,-1反方向
//    LSignV := AniSign(Velocity, 0, EpsilonPoint);
//    //
//    R := Abs(Target - Pos);
//    //暂存速度
//    Tmp := Velocity;
//
//
//    //速度*加速度
//    aTDecelerationRate := LSignV * ADecelerationRate;
//    if EnableTarget then
//    begin
//      //
//      if Velocity = 0 then
//        Inc(ElasticityFactor)
//      else
//        ElasticityFactor := 1;
//
//      aT := (LSign * Ceil(Elasticity * ElasticityFactor * R));
//
//      aT := aT + (aTDecelerationRate / DecelerationRate * 8);
//    end
//    else
//    begin
//      //
//      aT := aTDecelerationRate;
//      ElasticityFactor := 0;
//    end;
//
//
//
//    //速度的距离,减速度*时间
//    dV := aT * DeltaTime;
//    if (Velocity > 0) and (dV < 0) and (-dV > Velocity) then
//    begin
//      //改变方向,变0
//      dV := -Velocity;
//    end
//    else if (Velocity < 0) and (dV > 0) and (dV > -Velocity) then
//    begin
//      //改变方向,变0
//      dV := -Velocity;
//    end;
//
//
//    //速度增量
//    Velocity := Velocity + dV;
//    //
//    aT := dV / DeltaTime;
//    //距离增量=速度*时间+
//    DX := Tmp * DeltaTime + (aT * Sqr(DeltaTime)) / 2;
//
//
//    OutputDebugString('dV '+FloatToStr(dV)
//                      +' aT '+FloatToStr(aT)
//                      +' DX '+FloatToStr(DX)
//                      +' LSign '
//                          +FloatToStr(LSign)
//                      +' LSignV '+FloatToStr(LSignV)
//                      +' R '+FloatToStr(R)
//                      +' aTDecelerationRate '+FloatToStr(aTDecelerationRate)
//                      );
//
//
//    if EnableTarget and (not CancelTarget) then
//    begin
//      Tmp := Math.Max(1, StorageTime / DeltaTime);
//      if LSign = 1 then
//      begin
//        if (Pos + DX > Target) and (StorageTime > 0) then
//          DX := (Target - Pos) / Math.Max(1, Tmp / 3);
//        Pos := Pos + DX;
//      end
//      else if LSign = -1 then
//      begin
//        if (Pos + DX < Target) and (StorageTime > 0) then
//          DX := (Target - Pos) / Math.Max(1, Tmp / 3);
//        Pos := Pos + DX;
//      end
//      else
//        Velocity := 0;
//      if SameValue(Pos, Target, EpsilonPoint) then
//      begin
//        Pos := Target;
//        Velocity := 0;
//      end;
//    end
//    else
//    begin
//      //添加
//      Pos := Pos + DX;
//    end;
//  end;
//
//
//
//  procedure UpdateParams;
//  var
//    LDecelerationRate: Double;
//    AbsV: Double;
//  begin
//    //速度
//    AbsV := NewVelocity.Abs;
//
//
//    //减速因子,越小越慢
//    if (AbsV < MinVelocity) or (DecelerationRate <= 0) then
//    begin
//      LDecelerationRate := 0;
//    end
//    else
//    begin
//      LDecelerationRate := DecelerationRate;
//    end;
//
//
//    //计算下次的位置和速度
////    UpdatePhysicalParameters(Target.Point.X,
////                              NewPoint.X,
////                              NewVelocity.X,
////                              //根据速度计算出
////                              Abs(LDecelerationRate * NewVelocity.X),
////                              EnableTargetX,
////                              CancelTargetX,
////                              FElasticityFactor.X);
//
////    OutputDebugString('Target.Point.Y '+FloatToStr(Target.Point.Y)
////                      +' NewPoint.Y '+FloatToStr(NewPoint.Y)
////                      +' NewVelocity.Y '+FloatToStr(NewVelocity.Y)
////                      +' Abs(LDecelerationRate * NewVelocity.Y) '+FloatToStr(Abs(LDecelerationRate * NewVelocity.Y))
////                      +' EnableTargetY '+BoolToStr(EnableTargetY)
////                      +' CancelTargetY '+BoolToStr(CancelTargetY)
////                      +' FElasticityFactor.Y '+FloatToStr(FElasticityFactor.Y)
////                      );
//
//    UpdatePhysicalParameters(Target.Point.Y,
//                              NewPoint.Y,
//                              NewVelocity.Y,
//                              Abs(LDecelerationRate * NewVelocity.Y),
//                              EnableTargetY,
//                              CancelTargetY,
//                              FElasticityFactor.Y);
//
//
//  end;
//
//begin
//  if not Done then
//  begin
//    //启用水平,有水平方向的滚动
//    EnableTargetX := ([ttHorizontal] * InternalTouchTracking <> []) and
//      (Target.TargetType <> TTargetType.ttAchieved) and
//      (AniSign(NewPoint.X,
//              Target.Point.X,
//              EpsilonPoint) <> 0);
//
//    //启用垂直,有垂直方向的滚动
//    EnableTargetY := ([ttVertical] * InternalTouchTracking <> []) and
//      (Target.TargetType <> TTargetType.ttAchieved) and
//      (AniSign(NewPoint.Y,
//              Target.Point.Y,
//              EpsilonPoint) <> 0);
//
//    //更新垂直和水平的速度和位置
//    UpdateParams;
//  end;
//end;
//
//procedure TSkinControlGestureManager.DoStart;
//begin
//  if Assigned(FOnStart) then
//    FOnStart(self);
//end;
//
//procedure TSkinControlGestureManager.DoChanged;
//begin
//  if Assigned(FOnTimer) then
//    FOnTimer(self);
//end;
//
//function TSkinControlGestureManager.ElasticityStored: Boolean;
//begin
//  Result := not SameValue(FElasticity, DefaultElasticity);
//end;

procedure TSkinControlGestureManager.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TSkinControlGestureManager.EndUpdate;
begin
  if FUpdateCount > 0 then
    Dec(FUpdateCount);
end;

//function TSkinControlGestureManager.DecelerationRateStored: Boolean;
//begin
//  Result := not SameValue(FDecelerationRate, DecelerationRateNormal);
//end;
//
//function TSkinControlGestureManager.StorageTimeStored: Boolean;
//begin
//  Result := not SameValue(FStorageTime, DefaultStorageTime);
//end;
//
//procedure TSkinControlGestureManager.DoStop;
//begin
//  if Assigned(FOnStop) then
//    FOnStop(self);
//end;

function TSkinControlGestureManager.DoStopScrolling(CurrentTime: TDateTime = 0): Boolean;
var
  T: Double;
begin
  if CurrentTime = 0 then
  begin
    CurrentTime := Now;
  end;

  //与按下的时间比较
  T := (CurrentTime - FUpDownTime) * SecsPerDay;


  Result := Down                //按下,
            and (not Moved)     //不移动
            and (T >= StopTime);//时间超出

  if Result then
  begin
//    uBaseLog.OutputDebugString(FloatToStr(CurrentTime)+'时间太长了,停止滚动');
    //时间太长了,停止滚动
    FCurrentVelocity := TPointD.Create(0, 0);
    FPointTimeList.Clear;
  end;
end;

procedure TSkinControlGestureManager.TimerProc(Sender:TObject);
var
  D, T: TDateTime;
  IsInit: Boolean;
  DOpacity: Single;
begin
  if not FInTimerProc then
  begin
    T := Now;

    //初始过了
    IsInit := FLastTimeCalc > 0;

    //与上次调用TimerProc的时间间隔
    D := T - FLastTimeCalc;

    //记录上次时间
    FLastTimeCalc := T;
    FInTimerProc := True;

    try
      //时间间隔
      if (D > 0) then
      begin
        //秒
        D := D * SecsPerDay;

//        uBaseLog.OutputDebugString(GetDebugLogID+'时间间隔 '+FloatToStr(D));

        //自动显示隐藏
        if AutoShowing then
        begin
          //更改透明度的间隔,计算,
          DOpacity := Math.Min(D, 2 * Interval / 1000);

          DOpacity := DOpacity / DefaultOpacityTime;

          if (FOpacity < MaxOpacity) and (Shown) then
          begin
            //如果已经显示
            FOpacity := MaxOpacity;
          end
          else if (FOpacity > 0) and (not Shown) then
          begin
            //慢慢隐藏
            FOpacity := Math.Max(FOpacity - DOpacity, 0);
          end;

//          uBaseLog.OutputDebugString(GetDebugLogID+'透明度 '+FloatToStr(FOpacity));

        end
        else
        begin
          FOpacity := MaxOpacity;
        end;



        if IsInit
          and (
            (D > EpsilonTime)//EpsilonTime 0.01,间隔大于一定时
            or (not Down)    //鼠标不按下
            or FLowChanged   //
          ) then
        begin


          //判断是否需要停止滚动（根据间隔时间,清除PointTimes）
          DoStopScrolling(FLastTimeCalc);


//          if Animation//弹起惯性滚动
//            and (not (
//                      Down       //按下
//                      and Moved  //并且正在移动
//                      )) then
//          begin
//            //计算速度
////            InternalCalc(D);
//          end;


//          //设置视图位置
//          InternalChanged;



          //低速的话,只执行一次InternalChanged
          FLowChanged := False;



          UpdateTimer;
        end;


//      except
//        on E: Exception do
//        begin
//          Enabled := False;
//          raise;
//        end;
      end;
    finally
      FInTimerProc := False;
    end;


  end;
end;

function TSkinControlGestureManager.GetTargetCount: Integer;
begin
  Result := Length(FTargets);
end;

procedure TSkinControlGestureManager.GetTargets(var ATargets: array of TTarget);
var
  N, I: Integer;
begin
  N := Math.Min(TargetCount, Length(ATargets));
  for I := 0 to N - 1 do
    ATargets[I] := FTargets[I];
  UpdateTimer;
end;

procedure TSkinControlGestureManager.SetTargets(const ATargets: array of TTarget);
  function FindMaxTarget(var Target: TTarget): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to TargetCount - 1 do
      if FTargets[I].TargetType = TTargetType.ttMax then
      begin
        if not Result then
        begin
          Target := FTargets[I];
          Result := True;
        end
        else
        begin
          if (Target.Point.X > FTargets[I].Point.X) then
            Target.Point.X := FTargets[I].Point.X;
          if (Target.Point.Y > FTargets[I].Point.Y) then
            Target.Point.Y := FTargets[I].Point.Y;
        end;
      end;
  end;
  function FindMinTarget(var Target: TTarget): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to TargetCount - 1 do
      if FTargets[I].TargetType = TTargetType.ttMin then
      begin
        if not Result then
        begin
          Target := FTargets[I];
          Result := True;
        end
        else
        begin
          if (Target.Point.X < FTargets[I].Point.X) then
            Target.Point.X := FTargets[I].Point.X;
          if (Target.Point.Y < FTargets[I].Point.Y) then
            Target.Point.Y := FTargets[I].Point.Y;
        end;
      end;
  end;

var
  I: Integer;

  LogStr:String;
begin
  SetLength(FTargets, Length(ATargets));
  for I := 0 to Length(ATargets) - 1 do
  begin
    FTargets[I] := ATargets[I];
  end;

  //找出往最小的方向
  if not FindMinTarget(FMinTarget) then
  begin
    FMinTarget.TargetType := TTargetType.ttAchieved;
    FMinTarget.Point := TPointD.Create(0, 0);
  end;

  //找出往最大的方向
  if not FindMaxTarget(FMaxTarget) then
  begin
    FMaxTarget.TargetType := TTargetType.ttAchieved;
    FMaxTarget.Point := TPointD.Create(0, 0);
  end;

  if IsSmall(FCurrentVelocity, MinVelocity) then
  begin
    FLastTimeCalc := 0;
  end;

//  UpdateTimer;

//  if (not FDown) and (not Animation) and (InternalTouchTracking <> []) then
//    UpdatePosImmediately;



//  LogStr:='FTargets Count '+IntToStr(Length(FTargets))+' ';
//  for I := low(FTargets) to high(FTargets) do
//  begin
//    LogStr:=LogStr+' '+IntToStr(Ord(FTargets[I].TargetType))
//                  +' '+FloatToStr(FTargets[I].Point.X)
//                  +' '+FloatToStr(FTargets[I].Point.Y);
//
//  end;
//  OutputDebugString(LogStr);
//  LogStr:='FTarget';
//  LogStr:=LogStr+' '+IntToStr(Ord(FTarget.TargetType))
//                +' '+FloatToStr(FTarget.Point.X)
//                +' '+FloatToStr(FTarget.Point.Y);
//  OutputDebugString(LogStr);
//
//  OutputDebugString(LogStr);
//  LogStr:='FMouseTarget';
//  LogStr:=LogStr+' '+IntToStr(Ord(FMouseTarget.TargetType))
//                +' '+FloatToStr(FMouseTarget.Point.X)
//                +' '+FloatToStr(FMouseTarget.Point.Y);
//  OutputDebugString(LogStr);

end;

function TSkinControlGestureManager.FindTarget(var Target: TTarget): Boolean;
var
  MinR: Extended;

  function FindMinMaxTarget(var Target: TTarget): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    Target.TargetType := TTargetType.ttAchieved;
    Target.Point := ViewportPosition;

    for I := 0 to TargetCount - 1 do
      if (FTargets[I].TargetType = TTargetType.ttMax) then
      begin
        if Target.Point.X > FTargets[I].Point.X then
        begin
          Target.Point.X := FTargets[I].Point.X;
          Result := True;
        end;
        if Target.Point.Y > FTargets[I].Point.Y then
        begin
          Target.Point.Y := FTargets[I].Point.Y;
          Result := True;
        end;
      end;
    for I := 0 to TargetCount - 1 do
      if (FTargets[I].TargetType = TTargetType.ttMin) then
      begin
        if Target.Point.X < FTargets[I].Point.X then
        begin
          Target.Point.X := FTargets[I].Point.X;
          Result := True;
        end;
        if Target.Point.Y < FTargets[I].Point.Y then
        begin
          Target.Point.Y := FTargets[I].Point.Y;
          Result := True;
        end;
      end;
    if Result then
      Target.TargetType := TTargetType.ttMin;
  end;
  procedure UpdateResult(P: TPointD);
  var
    R: Extended;
  begin
    R := ViewportPosition.Distance(P);
    if R < MinR then
    begin
      MinR := R;
      Result := True;
      Target.Point := P;
      //MouseWheel
      Target.TargetType := TTargetType.ttOther;
    end;
  end;

var
  I: Integer;
  MinFound, MaxFound: Boolean;
  X, Y: Double;
begin
  Result := False;
  MinR := MaxInt;


  //存在最小值越界
  MinFound := FMinTarget.TargetType = TTargetType.ttMin;
  //存在最大值越界
  MaxFound := FMaxTarget.TargetType = TTargetType.ttMax;



  for I := 0 to TargetCount - 1 do
  begin
    if (FTargets[I].TargetType = TTargetType.ttOther) then
    begin
      if FTargets[I].Point = ViewportPosition then
      begin
        //当前位置
        Target.Point := FTargets[I].Point;
        Target.TargetType := TTargetType.ttAchieved;
        Result := False;
        Exit;
      end
      else
      begin
        X := FTargets[I].Point.X;
        Y := FTargets[I].Point.Y;

        if ((not MinFound) or (MinFound and (X >= FMinTarget.Point.X))) and
          ((not MaxFound) or (MaxFound and (X <= FMaxTarget.Point.X))) and
          ((not MinFound) or (MinFound and (Y >= FMinTarget.Point.Y))) and
          ((not MaxFound) or (MaxFound and (Y <= FMaxTarget.Point.Y))) then
        begin
          UpdateResult(FTargets[I].Point);
        end;

      end;
    end;
  end;



  if Result then
  begin
    if Target.Point = ViewportPosition then
    begin
      Target.TargetType := TTargetType.ttAchieved;
      Result := False;
    end;
  end
  else
  begin
    if MinFound or MaxFound then
    begin
      Result := FindMinMaxTarget(Target);
    end
    else
    begin
      //没有找到Min,Max,更新Target
      Target.TargetType := TTargetType.ttAchieved;
      Target.Point := ViewportPosition;
    end;
  end;

//  LogStr:=LogStr+' '+IntToStr(Ord(FTarget.TargetType))
//                +' '+FloatToStr(FTarget.Point.X)
//                +' '+FloatToStr(FTarget.Point.Y);
//  OutputDebugString('FindTarget FTarget'+' '+IntToStr(Ord(FTarget.TargetType))
//                            +' '+FloatToStr(FTarget.Point.X)
//                            +' '+FloatToStr(FTarget.Point.Y));

end;

procedure TSkinControlGestureManager.FirstMouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Double);
begin
    if Not FIsMouseDown then
    begin

//        if Self.FKind=gmkHorizontal then
//          OutputDebugString(GetDebugLogID+'FirstMouseDown');
        //鼠标按下
        FIsMouseDown:=True;

        FHasDecidedFirstGestureKind:=False;

        FFirstMouseMovePt:=PointF(X,Y);
        //绝对坐标
        FFirstMouseMoveAbsolutePt:=PointF(X,Y);
        {$IFDEF FMX}
        if (FParentControl<>nil) and (FParentControl is TControl) then
        begin
          FFirstMouseMoveAbsolutePt:=TControl(Self.FParentControl).LocalToAbsolute(FFirstMouseMoveAbsolutePt);
        end;
        {$ENDIF}




        //鼠标移动方向
        FMouseMoveDirection:=isdNone;



        //加入激活手势列表
        CurrentGestureManagerList.Add(Self);


        //
        if Assigned(FOnFirstMouseDown) then
        begin
          FOnFirstMouseDown(Self,X,Y);
        end;



        //放在OnFirstMouseDown后面
        //初始FDecidedFirstGestureKind
        if Self.FIsNeedDecideFirstGestureKind then
        begin
          //需要判断第一次手势的方向,匹配了才能滑动
          FDecidedFirstGestureKind:=gmkNone;
        end
        else
        begin
          //不需要判断
          FDecidedFirstGestureKind:=FKind;
        end;


        DoCustomFirstMouseDown(Button,Shift,X,Y);



        //上次滑动的坐标
        FLastMouseMovePt:=PointF(X,Y);
        FLastMouseMoveDirectionChangePoint:=PointF(X,Y);
        FLastMouseMoveAbsolutePt:=FFirstMouseMoveAbsolutePt;

//        if Self.FKind=gmkHorizontal then
//          uBaseLog.OutputDebugString('GetDebugLogID FirstMouseDown FLastMouseMoveAbsolutePt:'+FloatToStr(FLastMouseMoveAbsolutePt.X)+','+FloatToStr(FLastMouseMoveAbsolutePt.Y));

    end;





    if Not Down then
    begin
    //    uBaseLog.OutputDebugString('Ani MouseDown Begin '+FormatDateTime('HH:MM:SS ZZZ',Now));
        //按下了
        Down := True;

        //找到上次的Target
        FindTarget(FLastTarget);

      //  //
      //  FCancelTargetX := False;
      //  FCancelTargetY := False;

        FMoved := False;

        //按下的坐标
        FDownPoint := TPointD.Create(FLastMouseMoveAbsolutePt.X, FLastMouseMoveAbsolutePt.Y);
        //按下的
        FDownPosition := ViewportPosition;

        //添加坐标点
        AddPointTime(FLastMouseMoveAbsolutePt.X, FLastMouseMoveAbsolutePt.Y, FUpDownTime);

        //开始启用更新定时器
        UpdateTimer;
    //    uBaseLog.OutputDebugString('Ani MouseDown End   '+FormatDateTime('HH:MM:SS ZZZ',Now));
    end
    else
    begin
        //添加坐标点
        AddPointTime(FLastMouseMoveAbsolutePt.X, FLastMouseMoveAbsolutePt.Y, Now);
    end;


end;

procedure TSkinControlGestureManager.UpdateTarget;
//var
//  SignPos: TValueSign;
begin
  FindTarget(FTarget);


  //是否与上次的Target相同,如果不同,

//  //横坐标动过了
//  if (FTarget.TargetType = TTargetType.ttAchieved) or
//  //EpsilonPoint 0.001
//    (not SameValue(FLastTarget.Point.X, FTarget.Point.X, EpsilonPoint)) then
//    FCancelTargetX := False;
//
//
//  //纵坐标动过了
//  if (FTarget.TargetType = TTargetType.ttAchieved) or
//    (not SameValue(FLastTarget.Point.Y, FTarget.Point.Y, EpsilonPoint)) then
//    FCancelTargetY := False;



  //保存上次的Target
  FLastTarget := FTarget;



//  if //Animation
//    //and
//      Down
//    and Moved
//    and (not InTimerProc)
//    and (PositionCount > 1)
//    and (FMinTarget.TargetType <> TTargetType.ttAchieved)
//    and (FMaxTarget.TargetType <> TTargetType.ttAchieved)
//    and (FTarget.TargetType <> TTargetType.ttAchieved) then
//  begin
//      //判断方向,如果方向相同,FCancelTargetX为True
//      if not SameValue(FMinTarget.Point.X, FMaxTarget.Point.X, EpsilonPoint) then
//      begin
//        //
//        SignPos := System.Math.Sign(Positions[PositionCount - 1].X - Positions[PositionCount - 2].X);
//
////        FCancelTargetX := (SignPos <> 0)
////                  and (SignPos = System.Math.Sign(ViewportPosition.X - FTarget.Point.X));
//      end;
//      if not SameValue(FMinTarget.Point.Y, FMaxTarget.Point.Y, EpsilonPoint) then
//      begin
//        SignPos := System.Math.Sign(Positions[PositionCount - 1].Y - Positions[PositionCount - 2].Y);
////        FCancelTargetY := (SignPos <> 0)
////                  and (SignPos = System.Math.Sign(ViewportPosition.Y - FTarget.Point.Y));
//      end;
//  end;
//
//  if FCancelTargetX then OutputDebugString('FCancelTargetX '+BoolToStr(FCancelTargetX));
//  if FCancelTargetY then OutputDebugString('FCancelTargetY '+BoolToStr(FCancelTargetY));

end;

//procedure TSkinControlGestureManager.UpdateViewportPositionByBounds;
//  function NotBoundsAni(const Vert: Boolean): Boolean;
//  begin
//    if Vert then
//      Result := not(BoundsAnimation and (ttVertical in TouchTracking))
//    else
//      Result := not(BoundsAnimation and (ttHorizontal in TouchTracking));
//  end;
//
//begin
//  if FMinTarget.TargetType = TTargetType.ttMin then
//  begin
//    //往最小方向
//    if (FViewportPosition.X < FMinTarget.Point.X) and NotBoundsAni(False) then
//    begin
//      FViewportPosition.X := FMinTarget.Point.X;
//      FCurrentVelocity.X := 0;
//    end;
//    if (FViewportPosition.Y < FMinTarget.Point.Y) and NotBoundsAni(True) then
//    begin
//      FViewportPosition.Y := FMinTarget.Point.Y;
//      FCurrentVelocity.Y := 0;
//    end;
//  end;
//  if FMaxTarget.TargetType = TTargetType.ttMax then
//  begin
//    //往最大方向
//    if (FViewportPosition.X > FMaxTarget.Point.X) and NotBoundsAni(False) then
//    begin
//      FViewportPosition.X := FMaxTarget.Point.X;
//      FCurrentVelocity.X := 0;
//    end;
//    if (FViewportPosition.Y > FMaxTarget.Point.Y) and NotBoundsAni(True) then
//    begin
//      FViewportPosition.Y := FMaxTarget.Point.Y;
//      FCurrentVelocity.Y := 0;
//    end;
//  end;
//end;

procedure TSkinControlGestureManager.UpdateTimer;
var
  EnableTimer, NewVisible, ChangeOpacity, LSmall: Boolean;
  Target: TTarget;
begin
//  Exit;

  EnableTimer := FUpdateTimerCount < 0;

  if not EnableTimer then
  begin
    //按下就要更新
    EnableTimer := //Animation and
        Down;
    if not EnableTimer then
    begin
      //不启用定时器
      //是否处理慢速滚动中
      LSmall := LowVelocity;
      EnableTimer := (not LSmall) //and Animation
          ;

      if not EnableTimer then
      begin
        EnableTimer := FindTarget(Target);
      end;

      if EnableTimer then
      begin
        FUpdateTimerCount := 0;
      end;

      NewVisible := (not AutoShowing) or Shown;


      ChangeOpacity := ((FOpacity < MaxOpacity) and NewVisible) or
                       ((FOpacity > 0) and (not NewVisible));


      if (not EnableTimer) and
         (not ChangeOpacity) then
      begin
        Inc(FUpdateTimerCount);
        if FUpdateTimerCount < 3 then
          EnableTimer := True;
      end
      else
      begin
        EnableTimer := True;
      end;
    end;
  end
  else
  begin
    Inc(FUpdateTimerCount);
  end;

  Enabled := EnableTimer;
end;

//procedure TSkinControlGestureManager.UpdatePosImmediately(const Force: Boolean = False);
//var
//  NewViewportPosition, OldViewportPosition: TPointD;
//begin
//  NewViewportPosition := ViewportPosition;
//  OldViewportPosition := NewViewportPosition;
//
//
//  try
//    if FindTarget(FTarget) then
//    begin
//      if ttHorizontal in InternalTouchTracking then
//        NewViewportPosition.X := Target.Point.X;
//      if ttVertical in InternalTouchTracking then
//        NewViewportPosition.Y := Target.Point.Y;
//    end;
//  finally
//    FViewportPosition := OldViewportPosition;
//  end;
//
//
//  if Force
//    or not IsSmall(TPointD.Create(NewViewportPosition.X - OldViewportPosition.X, NewViewportPosition.Y - OldViewportPosition.Y)) then
//  begin
//    FCurrentVelocity := TPointD.Create(0, 0);
//    FViewportPosition := NewViewportPosition;
//
////    UpdateViewportPositionByBounds;
//    FUpdateTimerCount := -1;
//    UpdateTimer;
//  end;
//
//end;
//
//procedure TSkinControlGestureManager.InternalCalc(DeltaTime: Double);
//var
//  Done: Boolean;
//  LMinVelocity: Double;
//  NewPoint, NewVelocity: TPointD;
//begin
//  //新的视图位置
//  NewPoint := ViewportPosition;
//  //新的速度
//  NewVelocity := FCurrentVelocity;
//
//  //寻找Target,更新Target
//  FindTarget(FTarget);
//
//  Done := False;
//
//  //更新Target
//  UpdateTarget;
//
//
//  //计算新的视图位置,新的速度
//  DoCalc(DeltaTime, NewPoint, NewVelocity, Done);
//
//
//  if FTarget.TargetType <> TTargetType.ttAchieved then
//  begin
//    //最小的速度,Min,Max,Other时候的最小速度
//    LMinVelocity := Math.Min(MinVelocity,(MinVelocity * DeltaTime / EpsilonPoint));
//  end
//  else
//  begin
//    //最小的速度
//    LMinVelocity := MinVelocity;
//  end;
//
//
//  if IsSmall(NewVelocity, LMinVelocity) then
//  begin
//    //速度为零
//    FCurrentVelocity := TPointD.Create(0, 0);
//
//    if (FTarget.TargetType <> TTargetType.ttAchieved) and
//       (Abs(NewPoint.X - FTarget.Point.X) < EpsilonPoint) then
//      NewPoint.X := FTarget.Point.X;
//
//    if (FTarget.TargetType <> TTargetType.ttAchieved) and
//       (Abs(NewPoint.Y - FTarget.Point.Y) < EpsilonPoint) then
//      NewPoint.Y := FTarget.Point.Y;
//
//    //低速,再调用最后一次TimeProc
//    FLowChanged := True;
//
//    //
//    ViewportPosition := NewPoint;
//  end
//  else
//  begin
//    FCurrentVelocity := NewVelocity;
//    ViewportPosition := NewPoint;
//  end;
//
////  OutputDebugString(GetDebugLogID+'FCurrentVelocity '+FloatToStr(FCurrentVelocity.Y));
//
//end;
//
//procedure TSkinControlGestureManager.InternalChanged;
//var
//  T: TDateTime;
//begin
//  T := Now;
//  //超过一定的时间才调用DoChanged
//  if (FLastTimeChanged = 0) or
//    ((T - FLastTimeChanged) * SecsPerDay >= EpsilonTime) then
//  begin
//    try
////      DoChanged;
//    finally
//      FLastTimeChanged := T;
//    end;
//  end
//  else if not InTimerProc then
//  begin
//    //
//    FUpdateTimerCount := -1;
//    UpdateTimer;
//  end;
//end;

procedure TSkinControlGestureManager.SetAutoShowing(const Value: Boolean);
begin
  if FAutoShowing <> Value then
  begin
    FAutoShowing := Value;
    UpdateTimer;
  end;
end;

function TSkinControlGestureManager.GetDebugLogID: String;
begin
  Result:=Name+' ';
  if Self.FParentControl<>nil then
  begin
    Result:=Result+Self.FParentControl.Name+' ';
  end;
  case Self.FKind of
    gmkNone: Result:=Result+'None '+' ';
    gmkHorizontal: Result:=Result+'Horz =='+' ';
    gmkVertical: Result:=Result+'Vert ||'+' ';
  end;
end;

function TSkinControlGestureManager.GetLowVelocity: Boolean;
begin
  Result := IsSmall(FCurrentVelocity, MinVelocity);
end;

procedure TSkinControlGestureManager.CalcVelocity(const Time: TDateTime);
var
  D, VAbs: Double;
  I: Integer;
begin
  if Time > 0 then
    FLastTimeCalc := Time
  else
    FLastTimeCalc := Now;

  //清除当前的记录点
  Clear(FLastTimeCalc);


  if Averaging then
    I := 0
  else if PositionCount > 2 then
    I := PositionCount - 3
  else
    I := PositionCount - 2;


//  OutputDebugString(GetDebugLogID+'计算速度:I'+IntToStr(I)+'  PositionCount'+IntToStr(PositionCount));


  //计算速度
  if (I >= 0)
    and ((PositionCount - 1) > I)
    and (InternalTouchTracking <> [])
  then
  begin


    FCurrentVelocity := TPointD.Create(0, 0);

    //计算耗时
    D := PositionTimes[PositionCount - 1] - PositionTimes[I];
    //计算出秒数
    D := D * (SecsPerDay);

//    OutputDebugString(GetDebugLogID+'时间间隔:'+FloatToStr(D));

    if D > 0 then
    begin


      //计算时间最大值
      D := Math.Max(D, EpsilonTime);

//      D:=0.0260000349953771;
//时间间隔:0.0260000349953771
//垂直距离:-94.6666870117187
//垂直距离速度:4369.22582735989
//速度平方根:4369.22582735989
//速度因子:5000
//最后的水平距离速度:0
//最后的垂直距离速度:4369.22582735989
//DX:815.432676474237


      //计算出当前的水平速度和垂直速度
      if ttHorizontal in InternalTouchTracking then
      begin
        //计算水平速度,距离除以时间
        FCurrentVelocity.X := Positions[PositionCount - 1].X - Positions[I].X;
//        OutputDebugString('水平距离:'+FloatToStr(FCurrentVelocity.X));
        FCurrentVelocity.X := -FCurrentVelocity.X / D * FVelocityPower;
//        OutputDebugString('水平距离速度:'+FloatToStr(FCurrentVelocity.X));
      end;
      if ttVertical in InternalTouchTracking then
      begin
        //计算垂直速度,距离除以时间
        FCurrentVelocity.Y := Positions[PositionCount - 1].Y - Positions[I].Y;
//        OutputDebugString('垂直距离:'+FloatToStr(FCurrentVelocity.Y));
        FCurrentVelocity.Y := -FCurrentVelocity.Y / D * FVelocityPower;
//        OutputDebugString('垂直距离速度:'+FloatToStr(FCurrentVelocity.Y));
      end;


      //速度的平均值,计算出平方根,
      //100,100->100
      VAbs := FCurrentVelocity.Abs;
//      OutputDebugString('速度平方根:'+FloatToStr(VAbs));

      //最大速度(10~5000),5000
      D := Math.Max(1, MaxVelocity);
//      OutputDebugString(Self.GetDebugLogID+' 速度因子:'+FloatToStr(D));


      if (VAbs < MinVelocity) and (not Down) then
      begin
//        OutputDebugString(GetDebugLogID+'速度太小');
        //速度太小
        FCurrentVelocity := TPointD.Create(0, 0);
      end
      else if VAbs > D then
      begin
        //速度太大
        //计算出当前速度,5000/3.3
        VAbs := D / VAbs;
        FCurrentVelocity.X := FCurrentVelocity.X * VAbs * FVelocityPower;
        FCurrentVelocity.Y := FCurrentVelocity.Y * VAbs * FVelocityPower;
      end
      else
      begin
        FCurrentVelocity.X := FCurrentVelocity.X * FVelocityPower;
        FCurrentVelocity.Y := FCurrentVelocity.Y * FVelocityPower;
      end;


//      FCurrentVelocity.Y:=5000;
//      OutputDebugString('最后的水平距离速度:'+FloatToStr(FCurrentVelocity.X));
//      OutputDebugString('最后的垂直距离速度:'+FloatToStr(FCurrentVelocity.Y));


    end;
  end;


  UpdateTimer;
end;

procedure TSkinControlGestureManager.Clear(T: TDateTime);
begin
  if FPointTimeList.Count > 0 then
  begin
    //最后一次的时间点
    if T <= 0 then
    begin
      //最后一次时间
      T := FPointTimeList[FPointTimeList.Count - 1].Time;
    end;

    while (FPointTimeList.Count > 0) and
      //超时了
      ((T - FPointTimeList[0].Time) * (SecsPerDay) > FStorageTime) do
    begin
      FPointTimeList.Delete(0);
    end;

  end;
end;

function TSkinControlGestureManager.GetPositionCount: Integer;
begin
  if Assigned(FPointTimeList) then
    Result := FPointTimeList.Count
  else
    Result := 0;
end;

function TSkinControlGestureManager.PosToView(const APosition: TPointD): TPointD;
var
  X, Y, D: Double;
  P: TPointD;
  function NewDelta(X: Double): Double;
  const
    q = (5 / 6) * (5 / 6) * (5 / 6) * (5 / 6) * (5 / 6) * (5 / 6);
  begin
    if X > D + q then
      Result := D - q + (Power(X - D, 5 / 6))
    else
      Result := X;
  end;

begin
  P := TPointD.Create(FDownPosition.X + FDownPoint.X, FDownPosition.Y + FDownPoint.Y);
  D := Math.Min(24, Math.Max(1, FDeadZone));

  X := P.X - APosition.X;
  Y := P.Y - APosition.Y;

  //如果越界了,位置拖动的就比较慢了
  if (FMinTarget.TargetType = TTargetType.ttMin) and (X < FMinTarget.Point.X) then
    X := FMinTarget.Point.X - NewDelta(FMinTarget.Point.X - X);

  if (FMaxTarget.TargetType = TTargetType.ttMax) and (X > FMaxTarget.Point.X) then
    X := FMaxTarget.Point.X + NewDelta(X - FMaxTarget.Point.X);

  if (FMinTarget.TargetType = TTargetType.ttMin) and (Y < FMinTarget.Point.Y) then
    Y := FMinTarget.Point.Y - NewDelta(FMinTarget.Point.Y - Y);

  if (FMaxTarget.TargetType = TTargetType.ttMax) and (Y > FMaxTarget.Point.Y) then
    Y := FMaxTarget.Point.Y + NewDelta(Y - FMaxTarget.Point.Y);


  Result := TPointD.Create(P.X - X, P.Y - Y);
end;

function TSkinControlGestureManager.GetPositions(const Index: Integer): TPointD;
begin
//  if (index < 0) or (index >= PositionCount) then
//    raise EListError.CreateFMT(sArgumentOutOfRange_Index,
//      [index, PositionCount]);
  Result := FPointTimeList[index].Point;
end;

function TSkinControlGestureManager.GetPositionTimes(const Index: Integer): TDateTime;
begin
//  if (index < 0) or (index >= PositionCount) then
//    raise EListError.CreateFMT(sArgumentOutOfRange_Index,
//      [index, PositionCount]);
  Result := FPointTimeList[index].Time;
end;

function TSkinControlGestureManager.AddPointTime(const X, Y: Double;
  const Time: TDateTime): TPointTime;
begin

  if Time > 0 then
    Result.Time := Time
  else
    Result.Time := Now;


  Result.Point.X := X;
  Result.Point.Y := Y;
  Result.Point := PosToView(Result.Point);


  if FPointTimeList.Count > 0 then
  begin
    //如果只是水平或垂直的,那么设置成直线,牛B
    if (not(ttHorizontal in TouchTracking)) then
      Result.Point.X := FPointTimeList[FPointTimeList.Count - 1].Point.X;
    if (not(ttVertical in TouchTracking)) then
      Result.Point.Y := FPointTimeList[FPointTimeList.Count - 1].Point.Y;
  end;



  //添加点
  if (FPointTimeList.Count = 0) or
    (Result.Point <> FPointTimeList[FPointTimeList.Count - 1].Point) then
  begin
    //
//    uBaseLog.OutputDebugString('添加了一个点');
    FPointTimeList.Add(Result);
  end
  else
  begin
//    uBaseLog.OutputDebugString('更新了一个点');
    //如果相同,那么只需要更新时间
    Result.Point := FPointTimeList[FPointTimeList.Count - 1].Point;
    FPointTimeList[FPointTimeList.Count - 1] := Result;
  end;

end;

//procedure TSkinControlGestureManager.MouseDown(X, Y: Double);
//begin
//  //如果已经按下了,那么退出
//  if Down then
//  begin
//    Exit;
//  end;
//
//  //按下了
//  Down := True;
//
//  //找到上次的Target
//  FindTarget(FLastTarget);
//
//  //
//  FCancelTargetX := False;
//  FCancelTargetY := False;
//  FMoved := False;
//
//
//  //按下的坐标
//  FDownPoint := TPointD.Create(X, Y);
//  FDownPosition := ViewportPosition;
//
//
//  //添加坐标点
//  AddPointTime(X, Y, FUpDownTime);
//
//
//  //开始启用更新定时器
//  UpdateTimer;
//end;
//
//procedure TSkinControlGestureManager.MouseMove(X, Y: Double);
//var
//  NewVal: TPointTime;
//  NewViewportPosition: TPointD;
//  D, DZ: Double;
//  P: TPointD;
//begin
//  //存在跟踪
//  if Down and ([ttVertical, ttHorizontal] * TouchTracking <> []) then
//  begin
//    if not FMoved then
//    begin
//
//      //还没有移动过,第一次移动
//      P := TPointD.Create(X, Y);
//
//
//
//      //计算出距离
//      if TouchTracking = [ttVertical, ttHorizontal] then
//        D := P.Distance(FDownPoint)
//      else if (TouchTracking = [ttVertical]) then
//        D := Abs(P.Y - FDownPoint.Y)
//      else if (TouchTracking = [ttHorizontal]) then
//        D := Abs(P.X - FDownPoint.X)
//      else
//        D := 0;
//
//
//
//      if Averaging and Animation then
//      begin
//        //起始距离
//        DZ := Math.Max(FDeadZone, 1);
//        if D > DZ then
//        begin
//          //如果大于死区,那么开始移动了
//          FMoved := True;
//          //按下的坐标,视图位置
//          FDownPoint := TPointD.Create(X, Y);
//          FDownPosition := ViewportPosition;
//        end;
//      end
//      else
//      begin
//        FMoved := D > 0;
//      end;
//
//
//
//
//      if FMoved then
//      begin
//
//        FMoved := True;
//
//        //调用Start
//        InternalStart;
//      end;
//
//
//    end;
//
//
//
//
//    if FMoved then
//    begin
//      //移动过了
//      NewVal := AddPointTime(X, Y);
//
////      uBaseLog.OutputDebugString('FPointTimeList.Count '+IntToStr(FPointTimeList.Count));
//
//
//
//      //设置视图
//      if (ttHorizontal in TouchTracking) then
//        NewViewportPosition.X := FDownPosition.X - (NewVal.Point.X - FDownPoint.X)
//      else
//        NewViewportPosition.X := ViewportPosition.X;
//
//      if (ttVertical in TouchTracking) then
//        NewViewportPosition.Y := FDownPosition.Y - (NewVal.Point.Y - FDownPoint.Y)
//      else
//        NewViewportPosition.Y := ViewportPosition.Y;
//
//
//
//
//      //只保留最近一段时间的时间点
//      Clear;
//
//
//
//      //当前的位置
//      ViewportPosition := NewViewportPosition;
//
//
//
//
//      //更新拖动的方向
//      //设置FTarget
//      UpdateTarget;
//
//    end;
//
//
//  end;
//end;
//
//procedure TSkinControlGestureManager.MouseUp(X, Y: Double);
//begin
//  if Down then
//  begin
//    MouseMove(X, Y);
//
//
//
//    //计算速度
//    CalcVelocity;
//
//
//    //弹起的速度
//    FUpVelocity := CurrentVelocity;
//    //弹起的位置
//    FUpPosition := ViewportPosition;
//
//
//    UpdateTimer;
//
//
//
//    if (not Animation) then
//    begin
//      UpdateViewportPositionByBounds;
//    end;
//
//    Down := False;
//  end;
//end;
//
//procedure TSkinControlGestureManager.MouseLeave;
//var
//  PointTime: TPointTime;
//begin
//  if Down then
//  begin
//
//    if PositionCount > 0 then
//    begin
//      PointTime := FPointTimeList[PositionCount - 1];
//      PointTime.Time := Now;
//      FPointTimeList[PositionCount - 1] := PointTime;
//    end;
//
//
//    CalcVelocity;
//
//
//    FUpVelocity := CurrentVelocity;
//    FUpPosition := ViewportPosition;
//
//
//
//    UpdateTimer;
//
//
//    if (not Enabled) and (not Animation) then
//    begin
//      UpdateViewportPositionByBounds;
//    end;
//
//
//    Down := False;
//  end;
//end;
//
//procedure TSkinControlGestureManager.MouseWheel(X, Y: Double);
//var
//  DX, DY: Double;
//  NewTarget: TTarget;
//begin
//  DX := RoundTo(X, EpsilonRange);
//  DY := RoundTo(Y, EpsilonRange);
//  if (DX <> 0) or (DY <> 0) then
//  begin
//    NewTarget.TargetType := TTargetType.ttOther;
//
//    if FMouseTarget.TargetType <> TTargetType.ttOther then
//      NewTarget.Point := ViewportPosition
//    else
//      NewTarget.Point := FMouseTarget.Point;
//
//
//    NewTarget.Point.Offset(DX, DY);
//
//
//    FUpdateTimerCount := 0;
//    FUpdateTimerCount := -1;
//    SetMouseTarget(NewTarget);
//
//  end;
//end;

procedure TSkinControlGestureManager.SetMouseTarget(Value: TTarget);
var
  NewTargets: array of TTarget;
  I: Integer;
  Target: TTarget;
begin
  if Value.TargetType in [TTargetType.ttMin, TTargetType.ttMax] then
  begin
    //如果是越界的,直接退出
    Exit;
  end;


  Target := Value;
  SetLength(NewTargets, 0);

  for I := low(FTargets) to high(FTargets) do
  begin
    if FTargets[I].TargetType in [TTargetType.ttMin, TTargetType.ttMax] then
    begin
      //越界的留下,确定方向
      SetLength(NewTargets, Length(NewTargets) + 1);
      NewTargets[Length(NewTargets) - 1] := FTargets[I];
      //
      if (FTargets[I].TargetType = TTargetType.ttMin) then
      begin
        Target.Point.X := Math.Max(Target.Point.X, FTargets[I].Point.X);
        Target.Point.Y := Math.Max(Target.Point.Y, FTargets[I].Point.Y);
      end;
      //
      if (FTargets[I].TargetType = TTargetType.ttMax) then
      begin
        Target.Point.X := Math.Min(Target.Point.X, FTargets[I].Point.X);
        Target.Point.Y := Math.Min(Target.Point.Y, FTargets[I].Point.Y);
      end;
    end;
  end;


  if Target.TargetType = TTargetType.ttAchieved then
  begin
    //方向
    for I := low(FTargets) to high(FTargets) do
    begin
      if (not(FTargets[I].TargetType in [TTargetType.ttMin, TTargetType.ttMax]))
        and (FTargets[I].Point <> FMouseTarget.Point) then
      begin
        SetLength(NewTargets, Length(NewTargets) + 1);
        NewTargets[Length(NewTargets) - 1] := FTargets[I];
      end;
    end;
    FMouseTarget := Target;
  end
  else
  begin
    FMouseTarget := Target;
    if (FMouseTarget.TargetType <> TTargetType.ttAchieved) then
    begin
      SetLength(NewTargets, Length(NewTargets) + 1);
      NewTargets[Length(NewTargets) - 1] := FMouseTarget;
    end;
  end;


  SetTargets(NewTargets);

end;





{ TPointTimeList }

procedure TPointTimeList.Add(APointTime:TPointTime);
var
  P:PPointTime;
begin
  New(P);
  P^:=APointTime;
  FItems.Add(P);
end;

procedure TPointTimeList.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count-1 do
  begin
    Dispose(FItems[I]);
  end;
  FItems.Clear;
end;

function TPointTimeList.Count: Integer;
begin
  Result:=FItems.Count;
end;

constructor TPointTimeList.Create;
begin
  FItems:=TList.Create;
end;

procedure TPointTimeList.Delete(Index: Integer);
begin
  Dispose(FItems[Index]);
  Self.FItems.Delete(Index);
end;

destructor TPointTimeList.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  inherited;
end;

function TPointTimeList.GetItem(Index: Integer): TPointTime;
begin
  Result:=PPointTime(FItems[Index])^;
end;

procedure TPointTimeList.SetItem(Index: Integer; const Value: TPointTime);
begin
  PPointTime(FItems[Index])^:=Value;
end;


{ TSkinControlGestureManagerList }

function TSkinControlGestureManagerList.GetItem(Index: Integer): TSkinControlGestureManager;
begin
  Result:=TSkinControlGestureManager(Inherited Items[Index]);
end;

initialization
  CurrentGestureManagerList:=TSkinControlGestureManagerList.Create(ooReference,False);

  //判断更改方向的增量
  FDecideInertiaDirectionCrement:=2;
  //判断更改方向的增量
  FDecideDoDragDirectionCrement:=1;


  //计算绘制条绘制的因子,一越界,滚动条要急剧减小
  FOverRangeScrollBarSizeStep:=20;

  FDefaultOverRangePosValueStep:=0.4;


finalization
  FreeAndNil(CurrentGestureManagerList);

end.


