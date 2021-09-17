//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     动画
///   </para>
///   <para>
///     Animation
///   </para>
/// </summary>
unit uSkinAnimator;

interface
{$I FrameWork.inc}



uses
  Classes,
  SysUtils,
  Types,
  Math,

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
  FMX.Forms,
  System.Math.Vectors,
  System.RTLConsts,
  FMX.Consts,
  System.TypInfo,
  FMX.Platform,
  {$ENDIF}

  uGraphicCommon,
  uComponentType,
  uFuncCommon,
  uBaseLog;



const
  EpsilonPoint = 0.001;//TEpsilon.Position;
  //透明度间隔
  DefaultOpacityTime = 0.3;
  //
  MaxOpacity = 1.5;
  //最小时间,秒,10毫秒
  EpsilonTime = 0.01;
  //停止时间(7毫秒)
  StopTime = 0.007;



  //时间点记录的时间间隔
  DefaultStorageTime = 0.15;
  //定时器
  DefaultIntervalOfAni = 15.00;//20.00;//20;//10;
  //减速速度
  DecelerationRateNormal = 3.00;//4;//1.95;
  DecelerationRateFast = 12.00;//9.5;
  //弹性
//  DefaultElasticity = 100;
  //最小的速度(每毫秒像素)
  DefaultMinVelocity = 5.00;//20;//10

  DefaultVelocityPower = 1.3;//5;//原本是1.5;
  //取大的速度(每毫秒像素)
  DefaultMaxVelocity = 2500;//3000;//4000;//5000.00;//5000;
  //死区(超过这段距离才开始滚动)
  DefaultDeadZone = 3.00;//8;



type
  //用于ImageListPlayer,PageControl
  //图片列表切换效果
  TAnimateSwitchEffectType=(ilasetNone,      //没有效果,直接覆盖
                             ilasetMoveHorz, //水平切换
                             ilasetMoveVert  //垂直切换
                             );


  //用于ImageListPlayer
  //图片切换顺序
  TAnimateOrderType=(ilaotNone,//不切换
                    ilaotAsc,  //切换升序
                    ilaotDesc);//切换降序










  //顺序类型
  TAnimateDirectionType=(adtForward,        //增大
                         adtBackward);      //减小




  TTweenType=(
            Linear,     //：无缓动效果；
            Quadratic,  //：二次方的缓动（t^2）；
            Cubic,      //：三次方的缓动（t^3）；
            Quartic,    //：四次方的缓动（t^4）；
            Quintic,    //：五次方的缓动（t^5）；
            Sinusoidal, //：正弦曲线的缓动（sin(t)）；
            Exponential,//：指数曲线的缓动（2^t）；
            Circular,   //：圆形曲线的缓动（sqrt(1-t^2)）；
            Elastic,    //：指数衰减的正弦曲线缓动；
            Back,       //：超过范围的三次方缓动（(s+1)*t^3 - s*t^2）；
            Bounce,     //：指数衰减的反弹缓动。
            InertialScroll//,//惯性滚动
        );



  TEaseType=(
            //    每个效果都分三个缓动方式（方法）,分别是：
            easeIn,//：从0开始加速的缓动；
            easeOut,//：减速到0的缓动；
            easeInOut//：前半段从0开始加速,后半段减速到0的缓动。
        );



  TTweenEndType=(
                 tetTimes,       //次数
                 tetDistances    //距离
                 );
  TTweenNotifyEvent=procedure(Sender:TObject;var NeedStop:Boolean) of object;





  TPlatformTimer=class(TTimer)
  end;





  /// <summary>
  ///   动画
  /// </summary>
  TTween=class(TComponent)
  private
    FTimer:TPlatformTimer;

    FIsTweening:Boolean;
    FTweenType: TTweenType;
    FEaseType: TEaseType;
    FSpeed: Double;
    FSpeedTweenType: TTweenType;
    FSpeedEaseType: TEaseType;

    FInitialSpeed: Double;
    FMaxSpeed: Double;



    FIsRuning:Boolean;
    FIsPauseing:Boolean;
    FIsContinueing:Boolean;


    FIsNeedCallEnd:Boolean;


    FOnTween: TTweenNotifyEvent;
    FOnTweenBegin: TNotifyEvent;
    FOnTweenEnd: TNotifyEvent;
    procedure CreateTimer;
    procedure SetSpeed(const Value: Double);


    //定时器事件
    procedure DoTimer(Sender:TObject);
  public
    procedure Clear;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public



    //当前次数
    t,
    //初始位置
    b,
    //总距离
    c,
    //总次数
    d,
    //当前位置
    p,
    //
    s,
    Lastp,Nextp,minps

    :Double;




    //总次数
    speed_d,
    //当前位置
    speed_p,
    //
    speed_s
    :Double;





    //惯性滚动需要设置的特殊参数
    CurrentVelocity,
    MinVelocity,
    MaxVelocity: Double;
    //减速
    DecelerationRate: Double;

    AbsV: Double;
    //上次计算速度的时间
    LastTimeCalc: TDateTime;

//    StorageTime: Double;





  public

    /// <summary>
    ///   <para>
    ///     开始动画
    ///   </para>
    ///   <para>
    ///     Run animation
    ///   </para>
    /// </summary>
    procedure Run;
    /// <summary>
    ///   <para>
    ///     停止动画
    ///   </para>
    ///   <para>
    ///     Stop animation
    ///   </para>
    /// </summary>
    procedure Stop;
    /// <summary>
    ///   <para>
    ///     暂停动画
    ///   </para>
    ///   <para>
    ///     Pause animation
    ///   </para>
    /// </summary>
    procedure Pause;
    /// <summary>
    ///   <para>
    ///     继续动画
    ///   </para>
    ///   <para>
    ///     Continue animation
    ///   </para>
    /// </summary>
    procedure Continue;
  public

    /// <summary>
    ///   <para>
    ///     当前是否正在运行动画
    ///   </para>
    ///   <para>
    ///     Whether current is running animation
    ///   </para>
    /// </summary>
    property IsRuning:Boolean read FIsRuning;

    /// <summary>
    ///   <para>
    ///     当前是否暂停动画
    ///   </para>
    ///   <para>
    ///     Whether current is pausing animation
    ///   </para>
    /// </summary>
    property IsPauseing:Boolean read FIsPauseing;

    /// <summary>
    ///   <para>
    ///     当前是否正在继续动画
    ///   </para>
    ///   <para>
    ///     Whether current is continuing animation
    ///   </para>
    /// </summary>
    property IsContinueing:Boolean read FIsContinueing;
  public

    /// <summary>
    ///   <para>
    ///     正在动画的事件
    ///   </para>
    ///   <para>
    ///     Event of doing animation
    ///   </para>
    /// </summary>
    property OnTween:TTweenNotifyEvent read FOnTween write FOnTween;

    /// <summary>
    ///   <para>
    ///     开始动画事件
    ///   </para>
    ///   <para>
    ///    Event  of beginning animation
    ///   </para>
    /// </summary>
    property OnTweenBegin:TNotifyEvent read FOnTweenBegin write FOnTweenBegin;

    /// <summary>
    ///   <para>
    ///     结束动画事件
    ///   </para>
    ///   <para>
    ///     Event of ending animation
    ///   </para>
    /// </summary>
    property OnTweenEnd:TNotifyEvent read FOnTweenEnd write FOnTweenEnd;
  public


    /// <summary>
    ///   <para>
    ///     初始速度
    ///   </para>
    ///   <para>
    ///     Initial speed
    ///   </para>
    /// </summary>
    property InitialSpeed:Double read FInitialSpeed write FInitialSpeed;

    /// <summary>
    ///   <para>
    ///     最大速度
    ///   </para>
    ///   <para>
    ///     Max speed
    ///   </para>
    /// </summary>
    property MaxSpeed:Double read FMaxSpeed write FMaxSpeed;



    /// <summary>
    ///   <para>
    ///     动画速度
    ///   </para>
    ///   <para>
    ///     Animation speed
    ///   </para>
    /// </summary>
    property Speed:Double read FSpeed write SetSpeed;



    /// <summary>
    ///   <para>
    ///     动画类型
    ///   </para>
    ///   <para>
    ///     Animation type
    ///   </para>
    /// </summary>
    property TweenType:TTweenType read FTweenType write FTweenType;

    /// <summary>
    ///   <para>
    ///     速度变化的方式
    ///   </para>
    ///   <para>
    ///     Speed change type
    ///   </para>
    /// </summary>
    property EaseType:TEaseType read FEaseType write FEaseType;


  end;











  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinAnimator=class(TTween)
  private
    FMax:Double;

    //标记
    FTag: Integer;

    //移动的方向
    FDirectionType:TAnimateDirectionType;

    FOnAnimate: TNotifyEvent;
    FOnAnimateBegin: TNotifyEvent;
    FOnAnimateEnd: TNotifyEvent;

    function GetTween: TTween;

    function GetEndTimesCount: Double;

    procedure SetEndTimesCount(const Value: Double);

    procedure SetMax(const Value: Double);virtual;
    procedure SetMin(const Value: Double);virtual;

    procedure SetDirectionType(const Value: TAnimateDirectionType);
  protected
    procedure DoAnimateBegin(Sender:TObject);virtual;
    procedure DoAnimateEnd(Sender:TObject);virtual;
    procedure DoAnimate(Sender:TObject;var NeedStop:Boolean);virtual;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    property Tween:TTween read GetTween;
    property Tag:Integer read FTag write FTag;
  public
    function GetMax: Double;
    function GetMin: Double;
    function GetPosition: Double;
    function GetProgress: Double;
    function GetLastPosition: Double;
    function GetNextPosition: Double;
  public
    //做一个控件设计器,来模拟以下方法
    //
    /// <summary>
    ///   <para>
    ///     前进
    ///   </para>
    ///   <para>
    ///     Go forward
    ///   </para>
    /// </summary>
    procedure GoForward;

    /// <summary>
    ///   <para>
    ///     后退
    ///   </para>
    ///   <para>
    ///     Go backward
    ///   </para>
    /// </summary>
    procedure GoBackward;

    /// <summary>
    ///   <para>
    ///     开始
    ///   </para>
    ///   <para>
    ///     Start
    ///   </para>
    /// </summary>
    procedure Start;

  public
    /// <summary>
    ///   <para>
    ///     当前位置
    ///   </para>
    ///   <para>
    ///     Position
    ///   </para>
    /// </summary>
    property Position:Double read GetPosition;
    /// <summary>
    ///   <para>
    ///     进度(小数)
    ///   </para>
    ///   <para>
    ///     Progress
    ///   </para>
    /// </summary>
    property Progress:Double read GetProgress;
    /// <summary>
    ///   <para>
    ///     下一位置
    ///   </para>
    ///   <para>
    ///     Next position
    ///   </para>
    /// </summary>
    property NextPosition:Double read GetNextPosition;
    /// <summary>
    ///   <para>
    ///     上一位置
    ///   </para>
    ///   <para>
    ///     Last position
    ///   </para>
    /// </summary>
    property LastPosition:Double read GetLastPosition;
  published


    /// <summary>
    ///   <para>
    ///     超始位置
    ///   </para>
    ///   <para>
    ///     Start position
    ///   </para>
    /// </summary>
    property Min:Double read GetMin write SetMin;

    /// <summary>
    ///   <para>
    ///     终点位置
    ///   </para>
    ///   <para>
    ///     Final position
    ///   </para>
    /// </summary>
    property Max:Double read GetMax write SetMax stored True;





    /// <summary>
    ///   <para>
    ///     速度
    ///   </para>
    ///   <para>
    ///     Speed
    ///   </para>
    /// </summary>
    property Speed;


    /// <summary>
    ///   <para>
    ///     动画类型
    ///   </para>
    ///   <para>
    ///     Animation type
    ///   </para>
    /// </summary>
    property TweenType;

    /// <summary>
    ///   <para>
    ///     速度变化的方式
    ///   </para>
    ///   <para>
    ///    Speed change type
    ///   </para>
    /// </summary>
    property EaseType;





    /// <summary>
    ///   <para>
    ///     动画开始到结束需要移动的次数
    ///   </para>
    ///   <para>
    ///    Move count from begin to end
    ///   </para>
    /// </summary>
    property EndTimesCount:Double read GetEndTimesCount write SetEndTimesCount;




    /// <summary>
    ///   <para>
    ///     方向类型
    ///   </para>
    ///   <para>
    ///     Direction type
    ///   </para>
    /// </summary>
    property DirectionType:TAnimateDirectionType read FDirectionType write SetDirectionType;


    //
    /// <summary>
    ///   <para>
    ///     动画事件
    ///   </para>
    ///   <para>
    ///     Animate event
    ///   </para>
    /// </summary>
    property OnAnimate:TNotifyEvent read FOnAnimate write FOnAnimate;
    /// <summary>
    ///   <para>
    ///     开始动画事件
    ///   </para>
    ///   <para>
    ///     Animate begin event
    ///   </para>
    /// </summary>
    property OnAnimateBegin:TNotifyEvent read FOnAnimateBegin write FOnAnimateBegin;
    /// <summary>
    ///   <para>
    ///     动画结束事件
    ///   </para>
    ///   <para>
    ///     Animate end event
    ///   </para>
    /// </summary>
    property OnAnimateEnd:TNotifyEvent read FOnAnimateEnd write FOnAnimateEnd;

  end;











  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinAnimator=class(TBaseSkinAnimator);












  /// <summary>
  ///   <para>
  ///     控件移动的类型
  ///   </para>
  ///   <para>
  ///     Control move type
  ///   </para>
  /// </summary>
  TSkinControlMoveAnimateType=(
                              /// <summary>
                              ///   <para>
                              ///     移动控件的水平位置
                              ///   </para>
                              ///   <para>
                              ///     Move control's horizontal position
                              ///   </para>
                              /// </summary>
                              scmatAnimateLeft,
                              /// <summary>
                              ///   <para>
                              ///     移动控件的垂直位置
                              ///   </para>
                              ///   <para>
                              ///     Move control's vertical position <br />
                              ///   </para>
                              /// </summary>
                              scmatAnimateTop
                              );
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinControlMoveAnimator=class(TSkinAnimator)
  private
    FAnimateControl: TControl;
    FMoveAnimateType: TSkinControlMoveAnimateType;

  protected
    //
    procedure DoAnimate(Sender:TObject;var NeedStop:Boolean);override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
  published

    /// <summary>
    ///   <para>
    ///     控件移动的类型
    ///   </para>
    ///   <para>
    ///     Control move type
    ///   </para>
    /// </summary>
    property MoveAnimateType:TSkinControlMoveAnimateType read FMoveAnimateType write FMoveAnimateType;

    /// <summary>
    ///   <para>
    ///     需要移动的控件
    ///   </para>
    ///   <para>
    ///     Control which is need to be moved
    ///   </para>
    /// </summary>
    property AnimateControl:TControl read FAnimateControl write FAnimateControl;
  end;



















  TControlEffectAnimator=class;
  TBaseControlEffect=class(TPersistent)
  private
    FIsEnabled:Boolean;
  public
    constructor Create;virtual;
  public
    property IsEnabled:Boolean read FIsEnabled write FIsEnabled;
  end;




  /// <summary>
  ///   <para>
  ///     水平移动效果类型
  ///   </para>
  ///   <para>
  ///     Effect type of moving horizontally
  ///   </para>
  /// </summary>
  TControlMoveHorzEffect=class(TBaseControlEffect)
  private
    FFrom: Double;
    FDest: Double;
  protected
    procedure DoAnimate(AControl:TControl;ASkinAnimator:TSkinAnimator);
    procedure DoAnimateBegin(AControl:TControl;ASkinAnimator:TSkinAnimator);
    procedure DoAnimateEnd(AControl:TControl;ASkinAnimator:TSkinAnimator);
  public
  published
    property From:Double read FFrom write FFrom;
    property Dest:Double read FDest write FDest;
  end;

  /// <summary>
  ///   <para>
  ///     垂直移动效果类型
  ///   </para>
  ///   <para>
  ///     Effect type of moving vertically
  ///   </para>
  /// </summary>
  TControlMoveVertEffect=class(TBaseControlEffect)
  private
    FFrom: Double;
    FDest: Double;
  protected
    procedure DoAnimate(AControl:TControl;ASkinAnimator:TSkinAnimator);
    procedure DoAnimateBegin(AControl:TControl;ASkinAnimator:TSkinAnimator);
    procedure DoAnimateEnd(AControl:TControl;ASkinAnimator:TSkinAnimator);
  published
    property From:Double read FFrom write FFrom;
    property Dest:Double read FDest write FDest;
  end;

  /// <summary>
  ///   <para>
  ///     透明度变化的效果类型
  ///   </para>
  ///   <para>
  ///    Effect type of alpha changes
  ///   </para>
  /// </summary>
  TControlAlphaEffect=class(TBaseControlEffect)
  private
    FFrom: Byte;
    FDest: Byte;
  protected
    procedure DoAnimate(AControl:TControl;ASkinAnimator:TSkinAnimator);
    procedure DoAnimateBegin(AControl:TControl;ASkinAnimator:TSkinAnimator);
    procedure DoAnimateEnd(AControl:TControl;ASkinAnimator:TSkinAnimator);
  published
    property From:Byte read FFrom write FFrom;
    property Dest:Byte read FDest write FDest;
  end;


  /// <summary>
  ///   <para>
  ///     控件动画效果项
  ///   </para>
  ///   <para>
  ///     Control's animation effect item
  ///   </para>
  /// </summary>
  TControlEffectItem=class(TCollectionItem)
  private
    //标题
    FCaption: String;
    //控件
    FControl:TControl;


    //水平移动效果
    FMoveHorzEffect:TControlMoveHorzEffect;
    //垂直移动效果
    FMoveVertEffect:TControlMoveVertEffect;
    //透明度效果
    FAlphaEffect:TControlAlphaEffect;



    FOnAnimate: TNotifyEvent;
    FOnAnimateBegin: TNotifyEvent;
    FOnAnimateEnd: TNotifyEvent;


    FTag: Integer;


    procedure SetAlphaEffect(const Value: TControlAlphaEffect);
    procedure SetMoveHorzEffect(const Value: TControlMoveHorzEffect);
    procedure SetMoveVertEffect(const Value: TControlMoveVertEffect);
  protected
    function GetDisplayName: string; override;
  protected
    procedure DoAnimate(ASkinAnimator:TSkinAnimator);
    procedure DoAnimateBegin(ASkinAnimator:TSkinAnimator);
    procedure DoAnimateEnd(ASkinAnimator:TSkinAnimator);
  public
    property Tag:Integer read FTag write FTag;
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   标题
    /// </summary>
    property Caption:String read FCaption write FCaption;

    /// <summary>
    ///   控件
    /// </summary>
    property Control:TControl read FControl write FControl;




    /// <summary>
    ///   <para>
    ///     水平移动效果
    ///   </para>
    ///   <para>
    ///     Move horizontally effect
    ///   </para>
    /// </summary>
    property MoveHorzEffect:TControlMoveHorzEffect read FMoveHorzEffect write SetMoveHorzEffect;

    /// <summary>
    ///   <para>
    ///     垂直移动效果
    ///   </para>
    ///   <para>
    ///     Move vertically effect
    ///   </para>
    /// </summary>
    property MoveVertEffect:TControlMoveVertEffect read FMoveVertEffect write SetMoveVertEffect;

    /// <summary>
    ///   <para>
    ///     透明度变化效果
    ///   </para>
    ///   <para>
    ///     Alpha effect
    ///   </para>
    /// </summary>
    property AlphaEffect:TControlAlphaEffect read FAlphaEffect write SetAlphaEffect;





    /// <summary>
    ///   <para>
    ///     动画事件
    ///   </para>
    ///   <para>
    ///     Animate event
    ///   </para>
    /// </summary>
    property OnAnimate:TNotifyEvent read FOnAnimate write FOnAnimate;
    /// <summary>
    ///   <para>
    ///     动画开始事件
    ///   </para>
    ///   <para>
    ///     Animate begin event
    ///   </para>
    /// </summary>
    property OnAnimateBegin:TNotifyEvent read FOnAnimateBegin write FOnAnimateBegin;
    /// <summary>
    ///   <para>
    ///     动画结束事件
    ///   </para>
    ///   <para>
    ///     Animate end event
    ///   </para>
    /// </summary>
    property OnAnimateEnd:TNotifyEvent read FOnAnimateEnd write FOnAnimateEnd;
  end;







  /// <summary>
  ///   <para>
  ///     控件动画效果项的集合
  ///   </para>
  ///   <para>
  ///     Set of control's animation effect item
  ///   </para>
  /// </summary>
  TControlEffectItems=class(TCollection)
  protected
    function GetItem(Index: Integer): TControlEffectItem;
    procedure SetItem(Index: Integer; const Value: TControlEffectItem);
  public
    constructor Create;
  public
    property Items[Index:Integer]:TControlEffectItem read GetItem write SetItem;default;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     控件动画
  ///   </para>
  ///   <para>
  ///     Control animation
  ///   </para>
  /// </summary>
  TControlEffectAnimator=class(TSkinAnimator)
  private
    FControlEffectItems: TControlEffectItems;
    procedure SetControlEffectItems(const Value: TControlEffectItems);
  protected
    procedure DoAnimate(Sender:TObject;var NeedStop:Boolean);override;
    procedure DoAnimateBegin(Sender:TObject);override;
    procedure DoAnimateEnd(Sender:TObject);override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //
    /// <summary>
    ///   <para>
    ///     控件效果项的集合
    ///   </para>
    ///   <para>
    ///     Set of control effect items
    ///   </para>
    /// </summary>
    property ControlEffectItems:TControlEffectItems read FControlEffectItems write SetControlEffectItems;
  end;












var
  EpsilonRange: Integer;


function CalcTweenValue(TweenType:TTweenType;EaseType:TEaseType;t,b,c,d,s:Double):Double;




implementation








function CalcTweenValue(TweenType:TTweenType;EaseType:TEaseType;t,b,c,d,s:Double): Double;
var
  Temp_t:Double;
begin
  Result:=0;
  case TweenType of
    Linear:
    begin
      Result:=c*t/d + b;//c*t/d + b;
    end;
    Quadratic:
    begin
      case EaseType of
        easeIn:
        begin
          Temp_t:=(t/d);
          Result:=c*Temp_t*Temp_t + b;//c*(t/=d)*t + b;
        end;
        easeOut:
        begin
          Temp_t:=(t/d);
          Result:=-c *Temp_t*(Temp_t-2) + b;//-c *(t/=d)*(t-2) + b;
        end;
        easeInOut:
        begin
          Temp_t:=t/(d/2);
          if (Temp_t < 1) then
          begin
            Result:=c/2*Temp_t*Temp_t + b;//c/2*t*t + b;
          end
          else
          begin
            Temp_t:=Temp_t-1;
            Result:=-c/2 * (Temp_t*(Temp_t-2) - 1) + b;//-c/2 * ((--t)*(t-2) - 1) + b;
          end;
        end;
      end;
    end;
    Cubic:
    begin
      case EaseType of
        easeIn:
        begin
          Temp_t:=(t/d);
          Result:=c*Temp_t*Temp_t*Temp_t + b;//c*(t/=d)*t*t + b;
        end;
        easeOut:
        begin
          Temp_t:=(t/d)-1;
          Result:=c*(Temp_t*Temp_t*Temp_t + 1) + b;//c*((t=t/d-1)*t*t + 1) + b;
        end;
        easeInOut:
        begin
          Temp_t:=t/(d/2);
          if (Temp_t < 1) then
          begin
            Result:= c/2*Temp_t*Temp_t*Temp_t + b;//c/2*t*t*t + b;
          end
          else
          begin
            Temp_t:=Temp_t-2;
            Result:= c/2*(Temp_t*Temp_t*Temp_t + 2) + b;//c/2*((t-=2)*t*t + 2) + b;
          end;
        end;
      end;
    end;
    Quartic:
    begin
      case EaseType of
        easeIn:
        begin
            Temp_t:=t/d;
            Result:= c*Temp_t*Temp_t*Temp_t*Temp_t + b;//c*(t/=d)*t*t*t + b;
        end;
        easeOut:
        begin
            Temp_t:=t/d-1;
            Result:= -c * (Temp_t*Temp_t*Temp_t*Temp_t - 1) + b;//-c * ((t=t/d-1)*t*t*t - 1) + b;
        end;
        easeInOut:
        begin
            Temp_t:=t/(d/2);
            if (Temp_t < 1) then
            begin
              Result:= c/2*Temp_t*Temp_t*Temp_t*Temp_t + b;//c/2*t*t*t*t + b;
            end
            else
            begin
              Temp_t:=Temp_t-2;
              Result:= -c/2 * (Temp_t*Temp_t*Temp_t*Temp_t - 2) + b;//-c/2 * ((t-=2)*t*t*t - 2) + b;
            end;
        end;
      end;
    end;
    Quintic:
    begin
      case EaseType of
        easeIn:
        begin
            Temp_t:=(t/d);
            Result:= c*Temp_t*Temp_t*Temp_t*Temp_t*Temp_t + b;//c*(t/=d)*t*t*t*t + b;
        end;
        easeOut:
        begin
            Temp_t:=t/d-1;
            Result:= c*(Temp_t*Temp_t*Temp_t*Temp_t*Temp_t + 1) + b;//c*((t=t/d-1)*t*t*t*t + 1) + b;
        end;
        easeInOut:
        begin
            Temp_t:=t/(d/2);
            if (Temp_t < 1) then
            begin
              Result:= c/2*Temp_t*Temp_t*Temp_t*Temp_t*Temp_t + b;//c/2*t*t*t*t*t + b;
            end
            else
            begin
              Temp_t:=Temp_t-2;
              Result:= c/2*(Temp_t*Temp_t*Temp_t*Temp_t*Temp_t + 2) + b;//c/2*((t-=2)*t*t*t*t + 2) + b;
            end;
        end;
      end;
    end;
    Sinusoidal:
    begin
      case EaseType of
        easeIn:
        begin
            Result:= -c * Cos(t/d * (3.1415926/2)) + c + b;//-c * Math.cos(t/d * (Math.PI/2)) + c + b;
        end;
        easeOut:
        begin
            Result:= c * Sin(t/d * (3.1415926/2)) + b;//c * Math.sin(t/d * (Math.PI/2)) + b;
        end;
        easeInOut:
        begin
            Result:= -c/2 * (Cos(3.1415926*t/d) - 1) + b;//-c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
        end;
      end;
    end;
    Exponential:
    begin
      case EaseType of
        easeIn:
        begin
          if t=0 then
          begin
            Result:=b;
          end
          else
          begin
            Result:=c * Math.Power(2, 10 * (t/d - 1)) + b;
          end;
//            Result:= (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;//(t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
        end;
        easeOut:
        begin
            if t=d then
            begin
              Result:=b+c;
            end
            else
            begin
              Result:=c * (-Math.Power(2, -10 * t/d) + 1) + b;;
            end;
//            Result:= (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;//(t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
        end;
        easeInOut:
        begin
            if (t=0) then
            begin
              Result:= b;
            end
            else if (t=d) then
            begin
              Result:= b+c;
            end
            else
            begin
              Temp_t:=t/(d/2);
              if (Temp_t < 1) then
              begin
                Result:= c/2 * Math.Power(2, 10 * (Temp_t - 1)) + b;//c/2 * Math.pow(2, 10 * (t - 1)) + b;
              end
              else
              begin
                Temp_t:=Temp_t-2;
                Temp_t:=Temp_t-1;
                Result:= c/2 * (-Math.Power(2, -10 * Temp_t) + 2) + b;//c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
              end;            
            end;
        end;
      end;
    end;
    Circular: 
    begin
      case EaseType of
        easeIn: 
        begin
            Temp_t:=(t/d);
            Result:= -c * (sqrt(1 -Temp_t*Temp_t) - 1) + b;//-c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
        end;
        easeOut:
        begin
            Temp_t:=t/d-1;
            Result:= c * sqrt(1 - Temp_t*Temp_t) + b;//c * Math.sqrt(1 - (t=t/d-1)*t) + b;
        end;
        easeInOut: 
        begin
            Temp_t:=t/(d/2);
            if (Temp_t < 1) then
            begin
              Result:= -c/2 * (sqrt(1 - Temp_t*Temp_t) - 1) + b;//-c/2 * (Math.sqrt(1 - t*t) - 1) + b;
            end
            else
            begin
              Temp_t:=Temp_t-2;
              Result:= c/2 * (sqrt(1 - Temp_t*Temp_t) + 1) + b;//c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
            end;
        end;
      end;
    end;
    Elastic: 
    begin
      Result:=c*t/d + b;//c*t/d + b;
//      case EaseType of
//        easeIn:
//        begin
//            Temp_t:=t/d;
//            if (t=0) then
//            begin
//              Result:= b; 
//            end
//            else if (Temp_t=1) then
//            begin
//              Result:= b+c; 
//            end
//            else
//            begin 
//              if (!p) p=d*.3;
//              if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
//              else var s = p/(2*Math.PI) * Math.asin (c/a);
//              return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
//            end;
//        end;
//        easeOut:
//        begin
//            if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
//            if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
//            else var s = p/(2*Math.PI) * Math.asin (c/a);
//            return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
//        end;
//        easeInOut:
//        begin
//            if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
//            if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
//            else var s = p/(2*Math.PI) * Math.asin (c/a);
//            if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
//            return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
//        end;
//      end;
    end;
    Back:
    begin
      case EaseType of
        easeIn:
        begin
            Temp_t:=(t/d);
            if (s = -MaxInt) then s := 1.70158;
            Result:= c*Temp_t*Temp_t*((s+1)*Temp_t - s) + b;//c*(t/=d)*t*((s+1)*t - s) + b;
        end;
        easeOut:
        begin
            Temp_t:=t/d-1;
            if (s = -MaxInt) then s := 1.70158;
            Result:= c*(Temp_t*Temp_t*((s+1)*Temp_t + s) + 1) + b;//c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
        end;
        easeInOut:
        begin
            Temp_t:=t/(d/2);
            if (s = -MaxInt) then s := 1.70158;
            if (Temp_t < 1) then
            begin
              s:=s*1.525;
              Result:= c/2*(Temp_t*Temp_t*((s+1)*Temp_t - s)) + b;//c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
            end
            else
            begin
              s:=s*1.525;
              Temp_t:=Temp_t-2;
              Result:= c/2*(Temp_t*Temp_t*((s+1)*Temp_t + s) + 2) + b;//c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
            end;
        end;
      end;

    end;
    Bounce:
    begin
      case EaseType of
        easeIn:
        begin
            Result:= c - CalcTweenValue(Bounce,easeOut,d-t, 0, c, d, s) + b; //c - Tween.Bounce.easeOut(d-t, 0, c, d) + b;
        end;
        easeOut:
        begin
          Temp_t:=t/d;
          if (Temp_t < (1/2.75)) then
          begin
              Result:= c*(7.5625*Temp_t*Temp_t) + b;//c*(7.5625*t*t) + b;
          end
          else if (Temp_t < (2/2.75)) then
          begin
              Temp_t:=Temp_t-(1.5/2.75);
              Result:= c*(7.5625*Temp_t*Temp_t + 0.75) + b;//c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
          end
          else if (Temp_t < (2.5/2.75)) then
          begin
              Temp_t:=Temp_t-(2.25/2.75);
              Result:= c*(7.5625*Temp_t*Temp_t + 0.9375) + b;//c*(7.5625*(t-=(2.25/2.75))*t + 0.9375) + b;
          end
          else
          begin
              Temp_t:=Temp_t-(2.625/2.75);
              Result:= c*(7.5625*Temp_t*Temp_t + 0.984375) + b;//c*(7.5625*(t-=(2.625/2.75))*t + 0.984375) + b;
          end;
        end;
        easeInOut:
        begin
            if (t < d/2) then
            begin
              Result:= CalcTweenValue(Bounce,easeIn,t*2, 0, c, d, s) * 0.5 + b;
            end
            else
            begin
              Result:= CalcTweenValue(Bounce,easeOut,t*2-d, 0, c, d, s) * 0.5 + c*0.5 + b;
            end;
        end;
      end;
    end;
  end;
end;










{ TTween }

procedure TTween.Clear;
begin
  t:=0;
  p:=0;
  s:=-MaxInt;

  speed_p:=0;
  speed_s:=-MaxInt;


  Lastp:=0;
  Nextp:=0;


  FIsRuning:=False;
  FIsPauseing:=False;
  FIsContinueing:=False;

end;

procedure TTween.Continue;
var
  NeedStop:Boolean;
begin
  if FIsPauseing then
  begin
    FIsContinueing:=True;
    FIsPauseing:=False;
    FIsRuning:=True;

    if FTimer<>nil then
    begin

      NeedStop:=False;
      if (t<d) and Not NeedStop then
      begin
        Self.FTimer.Enabled:=True;
        DoTimer(FTimer);
      end
      else
      begin
        Self.FTimer.Enabled:=False;

        if Assigned(Self.OnTween) then
        begin
          Self.OnTween(Self,NeedStop);
        end;

        if Assigned(Self.FOnTweenEnd) then
        begin
          FOnTweenEnd(Self);
        end;

      end;

    end;
  end;
end;

constructor TTween.Create(AOwner:TComponent);
begin
  Inherited Create(AOwner);



  //减速
  DecelerationRate := DecelerationRateNormal;
  //150毫秒
//  StorageTime := DefaultStorageTime;

  //最小的速度
  MinVelocity := DefaultMinVelocity;
  //最大的速度
  MaxVelocity := DefaultMaxVelocity;








  FTweenType:=TTWeenType.Linear;
  FEaseType:=TEaseType.easeIn;

  FSpeedTweenType:=TTWeenType.Linear;
  FSpeedEaseType:=TEaseType.easeIn;





//  c:=500;
//  d:=40;

  c:=500;
  d:=40;
  b:=0;

  speed_d:=40;

  FSpeed:=3;

  FInitialSpeed:=0;
  FMaxSpeed:=0;

  minps:=0;





  Clear;
end;

procedure TTween.CreateTimer;
begin
  if FTimer=nil then
  begin
    FTimer:=TPlatformTimer.Create(nil);//TTimer.Create(nil);
    FTimer.OnTimer:=DoTimer;
    FTimer.Enabled:=False;
  end;
  FTimer.Interval:=Ceil(FSpeed*10);
end;

destructor TTween.Destroy;
begin

  FreeAndNil(FTimer);

  inherited;
end;

function AniSign(const CurrentValue, TargetValue, EpsilonPoint: Double): TValueSign;
begin
  Result := -CompareValue(CurrentValue, TargetValue, EpsilonPoint);
end;

procedure TTween.DoTimer(Sender: TObject);
var
  NeedStop:Boolean;

  SpeedBetween:Double;
var
  dV,
  DX,
  aT,
  aTDecelerationRate,
  Tmp
  : Double;
  LSign, LSignV: TValueSign;
  CurTime,
  DeltaTime:Double;
  LDecelerationRate: Double;
  Arrived:Boolean;
begin
  if Not Self.FIsRuning then Exit;


  if FIsNeedCallEnd then
  begin
      FIsNeedCallEnd:=False;

      Self.FTimer.Enabled:=False;

      if Assigned(Self.FOnTweenEnd) then
      begin
        FOnTweenEnd(Self);
      end;

      FIsRuning:=False;

      Exit;
  end;


  if Self.FTweenType=InertialScroll then
  begin

        //速度
        AbsV := ABS(CurrentVelocity);


        //减速因子,越小越慢
        if (AbsV < MinVelocity) or (DecelerationRate <= 0) then
        begin
          LDecelerationRate := 0;
        end
        else
        begin
          LDecelerationRate := DecelerationRate;
        end;
        LDecelerationRate:=Abs(LDecelerationRate * CurrentVelocity);

        CurTime := Now;

        //与上次调用TimerProc的时间间隔
        DeltaTime := CurTime - LastTimeCalc;
        //记录上次时间
        LastTimeCalc := CurTime;

        //时间间隔大与0
        if (DeltaTime > 0) then
        begin
            //转换成秒
            DeltaTime := DeltaTime * SecsPerDay;

            if DeltaTime>0.1 then
            begin
              DeltaTime:=0.1;
            end;

            //滚动的方向
            LSign := AniSign(p, p, EpsilonPoint);
            //速度的方向,1正方向,0相等,-1反方向
            LSignV := AniSign(CurrentVelocity, 0, EpsilonPoint);
            //暂存速度
            Tmp := CurrentVelocity;


            //速度*加速度
            aTDecelerationRate := LSignV * LDecelerationRate;
            aT := aTDecelerationRate;


            //速度的距离,减速度*时间
            dV := aT * DeltaTime;
            if (CurrentVelocity > 0) and (dV < 0) and (-dV > CurrentVelocity) then
            begin
              //改变方向,变0
              dV := -CurrentVelocity;
            end
            else if (CurrentVelocity < 0) and (dV > 0) and (dV > -CurrentVelocity) then
            begin
              //改变方向,变0
              dV := -CurrentVelocity;
            end;


            //速度增量,加上加速度
            CurrentVelocity := CurrentVelocity + dV;
            //单位时间速度
            aT := dV / DeltaTime;
            //距离增量=速度*时间+
            DX := Tmp * DeltaTime + (aT * Sqr(DeltaTime)) / 2;


            Arrived:=False;

            p:=p+ABS(DX);//CalcTweenValue(Self.TweenType,Self.EaseType,t,b,c,d,s);

//            uBaseLog.HandleException(nil,'TTween.DoTimer InertialScroll '+FormatDateTime('HH:MM:SS:ZZZ',Now)+' '+FloatToStr(DX));

            Nextp:=p+ABS(DX);
            if (IsNotSameDouble(c,0) and (p-b>c)) then
            begin
              Arrived:=True;
              //不能超出
              p:=b+c;
              Nextp:=p+ABS(DX);
            end;

            //速度为0了,并且规定有距离要求
            if (Self.FTweenType=InertialScroll) and (ABS(CurrentVelocity)<MinVelocity) and BiggerDouble(c,0) then
            begin
              //不能超出
              p:=b+c;
            end;



            NeedStop:=False;
            if (p<>Lastp) then
            begin
              if Assigned(Self.OnTween) then
              begin
                Self.OnTween(Self,NeedStop);
              end;
            end;


            //加速度为0
            if (Self.FTweenType=InertialScroll) and (ABS(CurrentVelocity)<MinVelocity)
              //距离超出了
              or (Self.FTweenType<>InertialScroll) and Arrived
            then
            begin

                FIsNeedCallEnd:=True;



                //距离偏移为0,结束了
//                Self.FTimer.Enabled:=False;
//
//                if Assigned(Self.FOnTweenEnd) then
//                begin
//                  FOnTweenEnd(Self);
//                end;
//
//                FIsRuning:=False;

            end;
        end
        else
        begin

          //时间间隔等于0
    //      OutputDebugString('时间间隔等于0');
        end;

  end
  else
  begin

        //渐近式的减慢
        //5~10
        //SpeedInterval 5
        SpeedBetween:=Self.FMaxSpeed-Self.FInitialSpeed;



        if SpeedBetween>0 then
        begin
          //有时间需要渐近改变
          speed_p:=CalcTweenValue(Self.FSpeedTweenType,Self.FSpeedEaseType,t,0,SpeedBetween,d,speed_s);
          if FSpeed<>FInitialSpeed+speed_p then
          begin
            Speed:=FInitialSpeed+speed_p;
          end;
        end;


        p:=CalcTweenValue(Self.TweenType,Self.EaseType,t,b,c,d,s);
        Nextp:=CalcTweenValue(Self.TweenType,Self.EaseType,t+1,b,c,d,s);



        //最小的间距
        while (ABS(p-Lastp)<minps) and (t<d) do
        begin
          t:=t+1;

          p:=CalcTweenValue(Self.TweenType,Self.EaseType,t,b,c,d,s);
          Nextp:=CalcTweenValue(Self.TweenType,Self.EaseType,t+1,b,c,d,s);

        end;



        NeedStop:=False;
        if (p<>Lastp) then
        begin
          if Assigned(Self.OnTween) then
          begin
            Self.OnTween(Self,NeedStop);
          end;
        end;




        if (t<d) and Not NeedStop then
        begin
          t:=t+1;
        end
        else
        begin

          if Assigned(Self.OnTween) then
          begin
            Self.OnTween(Self,NeedStop);
          end;


          FIsNeedCallEnd:=True;


//          Self.FTimer.Enabled:=False;
//
//          if Assigned(Self.FOnTweenEnd) then
//          begin
//            FOnTweenEnd(Self);
//          end;
//
//          FIsRuning:=False;

        end;

  end;


  if (p-Lastp)>=minps then
  begin
    Lastp:=p;
  end;

end;

procedure TTween.Pause;
begin
  FIsPauseing:=True;
  FIsRuning:=False;
  if FTimer<>nil then
  begin
    FTimer.Enabled:=False;
  end;
end;

procedure TTween.Run;
begin

  if Self.FInitialSpeed>0 then
  begin
    FSpeed:=FInitialSpeed;
  end;

  CreateTimer;
  Clear;

  Lastp:=b;

  FTimer.Enabled:=True;

  FIsRuning:=True;
  FIsNeedCallEnd:=False;

  if Assigned(Self.FOnTweenBegin) then
  begin
    FOnTweenBegin(Self);
  end;


  //立即响应
  DoTimer(FTimer);
end;

procedure TTween.SetSpeed(const Value: Double);
begin
  if FSpeed<>Value then
  begin
    FSpeed:=Value;
    if FTimer<>nil then
    begin
      FTimer.Interval:=Ceil(FSpeed*10);
    end;
  end;
end;

procedure TTween.Stop;
begin
  if FIsRuning then
  begin
    if Assigned(Self.FOnTweenEnd) then
    begin
      FOnTweenEnd(Self);
    end;
  end;

  FIsRuning:=False;
  FIsNeedCallEnd:=False;

  if FTimer<>nil then
  begin
    FTimer.Enabled:=False;
  end;

end;






{ TBaseSkinAnimator }


constructor TBaseSkinAnimator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FMax:=c;

  Self.OnTween:=Self.DoAnimate;
  Self.OnTweenBegin:=Self.DoAnimateBegin;
  Self.OnTweenEnd:=Self.DoAnimateEnd;

  FDirectionType:=TAnimateDirectionType.adtForward;

end;

destructor TBaseSkinAnimator.Destroy;
begin
  inherited;
end;

procedure TBaseSkinAnimator.DoAnimateBegin(Sender:TObject);
begin
  if Assigned(FOnAnimateBegin) then
  begin
    FOnAnimateBegin(Self);
  end;
end;

procedure TBaseSkinAnimator.DoAnimateEnd(Sender:TObject);
begin
  if Assigned(FOnAnimateEnd) then
  begin
    FOnAnimateEnd(Self);
  end;
end;

procedure TBaseSkinAnimator.DoAnimate(Sender:TObject;var NeedStop:Boolean);
begin
  if Assigned(FOnAnimate) then
  begin
    FOnAnimate(Self);
  end;
end;

function TBaseSkinAnimator.GetEndTimesCount: Double;
begin
  Result:=Self.d;
end;

function TBaseSkinAnimator.GetLastPosition: Double;
begin
  case Self.FDirectionType of
    adtForward:
    begin
      Result:=Self.Lastp;
    end;
    adtBackward:
    begin
      Result:=Self.b+Self.c-(Self.Lastp-Self.b);
    end;
  end;
end;

function TBaseSkinAnimator.GetMax: Double;
begin
  Result:=FMax;//Self.b+Self.c;
end;

function TBaseSkinAnimator.GetMin: Double;
begin
  Result:=Self.b;
end;

function TBaseSkinAnimator.GetNextPosition: Double;
begin
  case Self.FDirectionType of
    adtForward:
    begin
      Result:=Self.Nextp;
    end;
    adtBackward:
    begin
      Result:=Self.b+Self.c-(Self.Nextp-Self.b);
    end;
  end;
end;

function TBaseSkinAnimator.GetPosition: Double;
begin
  case Self.FDirectionType of
    adtForward:
    begin
      Result:=Self.p;
    end;
    adtBackward:
    begin
      Result:=Self.b+Self.c-(Self.p-Self.b);
    end;
  end;
end;

function TBaseSkinAnimator.GetProgress: Double;
begin
  case Self.FDirectionType of
    adtForward:
    begin
      Result:=(GetPosition-GetMin)/(GetMax-GetMin);
    end;
    adtBackward:
    begin
      Result:=(GetMax-GetPosition)/(GetMax-GetMin);
    end;
  end;
end;

function TBaseSkinAnimator.GetTween: TTween;
begin
  Result:=Self;
end;

procedure TBaseSkinAnimator.SetDirectionType(const Value: TAnimateDirectionType);
begin
  if FDirectionType<>Value then
  begin
    FDirectionType := Value;
  end;
end;

procedure TBaseSkinAnimator.SetEndTimesCount(const Value: Double);
begin
  Self.d:=Value;
end;

procedure TBaseSkinAnimator.SetMax(const Value: Double);
begin
  FMax:=Value;
//  Self.c:=Value-Self.b;
end;

procedure TBaseSkinAnimator.SetMin(const Value: Double);
begin
  Self.b:=Value;
end;

procedure TBaseSkinAnimator.Start;
begin
  Self.c:=FMax-Self.b;

  Self.Run;
end;

procedure TBaseSkinAnimator.GoBackward;
begin

  Self.FDirectionType:=adtBackward;
  Self.Start;
end;

procedure TBaseSkinAnimator.GoForward;
begin
  Self.FDirectionType:=adtForward;
  Self.Start;
end;








{ TSkinControlMoveAnimator }


procedure TSkinControlMoveAnimator.Notification(AComponent: TComponent;Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);

  if (Operation=opRemove) then
  begin
    if (AComponent=Self.FAnimateControl) then
    begin
      FAnimateControl:=nil;
    end;
  end;

end;

procedure TSkinControlMoveAnimator.DoAnimate(Sender:TObject;var NeedStop:Boolean);
begin
  Inherited;

  case FMoveAnimateType of
    scmatAnimateLeft:
    begin
      if Self.FAnimateControl<>nil then
      begin
        {$IFDEF FMX}
        FAnimateControl.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}None{$ELSE}alNone{$IFEND};
        FAnimateControl.Position.X:=Self.Position;
        FAnimateControl.BringToFront;
        {$ENDIF}
        {$IFDEF VCL}
        FAnimateControl.Left:=Ceil(Self.Position);
        {$ENDIF}
      end;
    end;
    scmatAnimateTop:
    begin
      if Self.FAnimateControl<>nil then
      begin
        {$IFDEF FMX}
        FAnimateControl.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}None{$ELSE}alNone{$IFEND};
        FAnimateControl.Position.Y:=Self.Position;
        FAnimateControl.BringToFront;
        {$ENDIF}
        {$IFDEF VCL}
        FAnimateControl.Top:=Ceil(Self.Position);
        {$ENDIF}
      end;
    end;
  end;

end;



{ TControlEffectAnimator }

constructor TControlEffectAnimator.Create(AOwner: TComponent);
begin
  inherited;

  FControlEffectItems:=TControlEffectItems.Create;//(Self);

end;

destructor TControlEffectAnimator.Destroy;
begin
  FreeAndNil(FControlEffectItems);
  inherited;
end;

procedure TControlEffectAnimator.DoAnimate(Sender: TObject; var NeedStop: Boolean);
var
  I: Integer;
begin
  inherited;
  for I := 0 to FControlEffectItems.Count-1 do
  begin
    FControlEffectItems[I].DoAnimate(Self);
  end;
end;

procedure TControlEffectAnimator.DoAnimateBegin(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to FControlEffectItems.Count-1 do
  begin
//    if FControlEffectItems[I].F then

    FControlEffectItems[I].DoAnimateBegin(Self);
  end;
end;

procedure TControlEffectAnimator.DoAnimateEnd(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  for I := 0 to FControlEffectItems.Count-1 do
  begin
    FControlEffectItems[I].DoAnimateEnd(Self);
  end;
end;

procedure TControlEffectAnimator.SetControlEffectItems(const Value: TControlEffectItems);
begin
  FControlEffectItems.Assign(Value);
end;




{ TControlEffectItems }

constructor TControlEffectItems.Create;//(AControlEffectAnimator: TControlEffectAnimator);
begin
  Inherited Create(TControlEffectItem);
//  FControlEffectAnimator:=AControlEffectAnimator;
end;

function TControlEffectItems.GetItem(Index: Integer): TControlEffectItem;
begin
  Result:=TControlEffectItem(Inherited Items[Index]);
end;

procedure TControlEffectItems.SetItem(Index: Integer;const Value: TControlEffectItem);
begin
  Inherited Items[Index]:=Value;
end;



{ TControlEffectItem }

constructor TControlEffectItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FMoveHorzEffect:=TControlMoveHorzEffect.Create;
  FMoveVertEffect:=TControlMoveVertEffect.Create;
  FAlphaEffect:=TControlAlphaEffect.Create;

end;

destructor TControlEffectItem.Destroy;
begin
  FreeAndNil(FMoveHorzEffect);
  FreeAndNil(FMoveVertEffect);
  FreeAndNil(FAlphaEffect);

  inherited;
end;

procedure TControlEffectItem.DoAnimate(ASkinAnimator: TSkinAnimator);
begin
  if FControl<>nil then
  begin
    FMoveHorzEffect.DoAnimate(FControl,ASkinAnimator);
    FMoveVertEffect.DoAnimate(FControl,ASkinAnimator);
    FAlphaEffect.DoAnimate(FControl,ASkinAnimator);

    if Assigned(FOnAnimate) then
    begin
      FOnAnimate(Self);
    end;
  end;
end;

procedure TControlEffectItem.DoAnimateBegin(ASkinAnimator: TSkinAnimator);
begin
  if FControl<>nil then
  begin
    FMoveHorzEffect.DoAnimateBegin(FControl,ASkinAnimator);
    FMoveVertEffect.DoAnimateBegin(FControl,ASkinAnimator);
    FAlphaEffect.DoAnimateBegin(FControl,ASkinAnimator);

    if Assigned(FOnAnimateBegin) then
    begin
      FOnAnimateBegin(Self);
    end;
  end;
end;

procedure TControlEffectItem.DoAnimateEnd(ASkinAnimator: TSkinAnimator);
begin
  if FControl<>nil then
  begin
    FMoveHorzEffect.DoAnimateEnd(FControl,ASkinAnimator);
    FMoveVertEffect.DoAnimateEnd(FControl,ASkinAnimator);
    FAlphaEffect.DoAnimateEnd(FControl,ASkinAnimator);

    if Assigned(FOnAnimateEnd) then
    begin
      FOnAnimateEnd(Self);
    end;
  end;
end;

function TControlEffectItem.GetDisplayName: string;
begin
  if Self.FControl=nil then
  begin
    Result:=Inherited GetDisplayName;
  end
  else
  begin
    Result:=FControl.Name;
  end;
end;

procedure TControlEffectItem.SetAlphaEffect(const Value: TControlAlphaEffect);
begin
  FAlphaEffect.Assign(Value);
end;

procedure TControlEffectItem.SetMoveHorzEffect(const Value: TControlMoveHorzEffect);
begin
  FMoveHorzEffect.Assign(Value);
end;

procedure TControlEffectItem.SetMoveVertEffect(const Value: TControlMoveVertEffect);
begin
  FMoveVertEffect.Assign(Value);
end;

{ TControlMoveHorzEffect }

procedure TControlMoveHorzEffect.DoAnimate(AControl:TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;
  

  if (AControl<>nil) and IsNotSameDouble(Self.FFrom,FDest) then
  begin
        case ASkinAnimator.FDirectionType of
          adtForward:
          begin
            {$IFDEF FMX}
            AControl.Position.X:=FFrom+ASkinAnimator.GetProgress*(FDest-FFrom);
            {$ENDIF}
            {$IFDEF VCL}
            AControl.Left:=Ceil(FFrom+ASkinAnimator.GetProgress*(FDest-FFrom));
            {$ENDIF}
          end
          ;
          adtBackward:
          begin
            {$IFDEF FMX}
            AControl.Position.X:=FDest-ASkinAnimator.GetProgress*(FDest-FFrom);
            {$ENDIF}
            {$IFDEF VCL}
            AControl.Left:=Ceil(FDest-ASkinAnimator.GetProgress*(FDest-FFrom));
            {$ENDIF}
          end;
        end;
  end;
end;

procedure TControlMoveHorzEffect.DoAnimateBegin(AControl: TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;


end;

procedure TControlMoveHorzEffect.DoAnimateEnd(AControl: TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;

end;



{ TControlMoveVertEffect }

procedure TControlMoveVertEffect.DoAnimate(AControl:TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;


  if (AControl<>nil) and IsNotSameDouble(Self.FFrom,FDest) then
  begin
        case ASkinAnimator.FDirectionType of
          adtForward:
          begin
            SetControlTop(AControl,ControlSize(FFrom+ASkinAnimator.GetProgress*(FDest-FFrom)));
//            {$IFDEF FMX}
//            AControl.Position.Y:=FFrom+ASkinAnimator.GetProgress*(FDest-FFrom);
//            {$ENDIF}
//            {$IFDEF VCL}
//            AControl.Left:=Ceil(FFrom+ASkinAnimator.GetProgress*(FDest-FFrom));
//            {$ENDIF}
          end
          ;
          adtBackward:
          begin
            SetControlTop(AControl,ControlSize(FDest-ASkinAnimator.GetProgress*(FDest-FFrom)));
//            {$IFDEF FMX}
//            AControl.Position.Y:=FDest-ASkinAnimator.GetProgress*(FDest-FFrom);
//            {$ENDIF}
//            {$IFDEF VCL}
//            AControl.Left:=Ceil(FDest-ASkinAnimator.GetProgress*(FDest-FFrom));
//            {$ENDIF}
          end;
        end;
  end;
end;

procedure TControlMoveVertEffect.DoAnimateBegin(AControl: TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;



end;

procedure TControlMoveVertEffect.DoAnimateEnd(AControl: TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;


end;

{ TControlAlphaEffect }

procedure TControlAlphaEffect.DoAnimate(AControl: TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;


  if (AControl<>nil) and IsNotSameDouble(Self.FFrom,FDest) then
  begin
        case ASkinAnimator.FDirectionType of
          adtForward:
          begin
            {$IFDEF FMX}
            AControl.Opacity:=(FFrom+ASkinAnimator.GetProgress*(FDest-FFrom))/255;
            {$ENDIF}
          end
          ;
          adtBackward:
          begin
            {$IFDEF FMX}
            AControl.Opacity:=(FDest-ASkinAnimator.GetProgress*(FDest-FFrom))/255;
            {$ENDIF}
          end;
        end;
  end;
end;

procedure TControlAlphaEffect.DoAnimateBegin(AControl: TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;


end;

procedure TControlAlphaEffect.DoAnimateEnd(AControl: TControl;ASkinAnimator: TSkinAnimator);
begin
  if not FIsEnabled then Exit;


end;








{ TBaseControlEffect }

constructor TBaseControlEffect.Create;
begin
  FIsEnabled:=True;
end;

initialization
  EpsilonRange := Trunc(Log10(EpsilonPoint));



finalization




end.




