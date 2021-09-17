//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     图片列表手势切换显示框
///   </para>
///   <para>
///     ImageList gesture switch display Box
///   </para>
/// </summary>
unit uSkinImageListViewerType;

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
  uBaseSkinControl,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinScrollBarType,
  uSkinScrollControlType,
  uSkinControlGestureManager,
  uSkinImageList,
  uComponentType,
  uDrawEngine,
  uDrawParam,
  uSkinPicture,
  uDrawPicture,
  uSkinButtonType,
  uDrawTextParam,
  uDrawRectParam,
  uSkinRegManager,
  uDrawPictureParam;

const
  IID_ISkinImageListViewer:TGUID='{B908F511-785E-4FCC-AAB2-F9FDBA3C8C4A}';




type
  TImageListViewerProperties=class;


  TSwitchBeginNotifyEvent=procedure(Sender:TObject;ABeforeIndex:Integer;AAfterIndex:Integer) of object;

  /// <summary>
  ///   <para>
  ///     图片列表播放框接口
  ///   </para>
  ///   <para>
  ///     Interface of ImageList Player Box
  ///   </para>
  /// </summary>
  ISkinImageListViewer=interface//(ISkinControl)
  ['{B908F511-785E-4FCC-AAB2-F9FDBA3C8C4A}']

    //绑定的按钮控件
    function GetSwitchButtonGroup:TSkinBaseButtonGroup;
    function GetSwitchButtonGroupIntf:ISkinButtonGroup;

    //图片列表切换结束事件
    function GetOnImageListSwitchEnd:TNotifyEvent;
    property OnImageListSwitchEnd:TNotifyEvent read GetOnImageListSwitchEnd;

    function GetOnImageListSwitchBegin:TSwitchBeginNotifyEvent;
    property OnImageListSwitchBegin:TSwitchBeginNotifyEvent read GetOnImageListSwitchBegin;

    function GetImageListViewerProperties:TImageListViewerProperties;
    property Properties:TImageListViewerProperties read GetImageListViewerProperties;
    property Prop:TImageListViewerProperties read GetImageListViewerProperties;
  end;





  /// <summary>
  ///   图片列表播放框属性
  ///   <para>
  ///  Properties of ImageList Player Box
  ///   </para>
  /// </summary>
  TImageListViewerProperties=class(TScrollControlProperties)
  protected

    //当前切换显示的图片的前一张(-1为自动计算)
    FCurrentSwitchBeforeImageIndex:Integer;
    //当前切换显示的图片的后一张(-1为自动计算)
    FCurrentSwitchAfterImageIndex:Integer;
    //当前图片的切换顺序(升序,降序)
    FCurrentSwitchOrderType:TAnimateOrderType;


    //当前图片的切换效果类型(水平,垂直)
    FCurrentImageListSwitchEffectType:TAnimateSwitchEffectType;




    //绘制的图片
    FPicture:TDrawPicture;



    //GIF支持
    FAnimated:Boolean;
    FAnimateSpeed:Double;



    //图片列表滚动
    FImageListAnimated: Boolean;
    //图片列表滚动速度
    FImageListAnimateSpeed: Double;
    //图片列表滚动顺序
    FImageListAnimateOrderType:TAnimateOrderType;




    //图片列表切换的类型
    FImageListSwitchEffectType:TAnimateSwitchEffectType;
    //图片列表循环速度
    FImageListSwitchingSpeed:Double;
    //当前切换的增量(百分比)
    FImageListSwitchingProgressIncrement:Integer;





    //当前正在切换
    FImageListSwitching:Boolean;
    //当前切换的进度
    FImageListSwitchingProgress:Double;
    //用户松开手指时当前切换的进度
    FUserStopDragImageListSwitchingProgress:Double;
    //用户松开手指时要切换到的图片不下
    FUserStopDragSwitchToImageIndex:Integer;



    //当前旋转的角度
    FRotated:Boolean;
    //旋转的速度
    FRotateSpeed:Double;
    //旋转的增量
    FRotateIncrement:Integer;
    //当前旋转的角度
    FCurrentRotateAngle:Integer;








    //是否是第一次用户拖动
    FIsFirstUserDrag:Boolean;
    //是否正在手势切换
    FIsGestureSwitching:Boolean;



    //上次手势缩放的距离
    FLastGestureZoomDistance:Integer;
    //手势缩放的比例
    FGestureZoomScale:Double;
    //最大缩放比例
    FMaxGestureZoomScale: Double;
    //最小缩放比例
    FMinGestureZoomScale: Double;
    //是否可以手势缩放
    FCanGestureZoom: Boolean;
    //是否正在手势缩放
    FIsGestureZooming:Boolean;



    //是否可以循环切换
    FGestureSwitchLooped:Boolean;
    //是否可以手势切换
    FCanGestureSwitch:Boolean;
    //可以手势切换的距离(小于1的小数为百分比,大于1时为距离)
    FCanGestureSwitchDistance:Double;




    FImageListAnimateTimer:TTimer;

    FImageListSwitchingTimer:TTimer;

    FSkinImageListViewerIntf:ISkinImageListViewer;


    //恢复到初始缩放比例
    FZoomingToInitialAnimator:TSkinAnimator;


    //如果超出缩放比例,那么弹回缩放比例
    procedure DoZoomToInitialAnimate(Sender:TObject);
    procedure DoZoomToInitialAnimateEnd(Sender:TObject);


    //图片切换结束事件
    procedure DoImageListSwitchEnd;


    //GIF图片引擎重绘事件
//    procedure DoGIFAnimateRePaint(Sender:TObject);
    //GIF图片引擎设置
    procedure SetAnimated(const Value: Boolean);
    procedure SetAnimateSpeed(const Value: Double);




    //图片列表定时切换定时器
    procedure CreateImageListAnimateTimer;
    procedure DoImageListAnimateTimer(Sender:TObject);


    //图片列表正在切换定时器
    procedure CreateImageListSwitchingTimer;
    procedure DoImageListSwitchingTimer(Sender:TObject);


    //启用循环定时切换
    procedure SetImageListAnimated(const Value: Boolean);
    //循环定时切换的间隔时间
    procedure SetImageListAnimateSpeed(const Value: Double);
    //循环定时切换的图片显示顺序
    procedure SetImageListAnimateOrderType(const Value: TAnimateOrderType);
    //手势切换的时候循环切换图片
    procedure SetGestureSwitchLooped(const Value: Boolean);



    //是否正在切换
    procedure SetImageListSwitching(const Value: Boolean);
    //切换效果的速度
    procedure SetImageListSwitchingSpeed(const Value: Double);
    //切换的增量
    procedure SetImageListSwitchingProgressIncrement(const Value: Integer);
    //切换的效果类型,水平切换,垂直切换等等
    procedure SetImageListSwitchEffectType(const Value: TAnimateSwitchEffectType);
    //切换进度的最大值,一般为控件的尺寸
    function GetImageListSwitchingProgressMaxSize:Double;





    //切换按钮点击事件
    procedure DoImageListSwitchButtonClick(Sender:TObject);



    //设置图片
    procedure SetPicture(Value:TDrawPicture);
    procedure DoPictureChanged(Sender: TObject);override;




    //检查当前是否正在切换图片列表
    function CheckIsImageListSwitching:Boolean;


    //获取当前图片的下一张图片
    function GetNextImageIndex(AImageIndex:Integer):Integer;
    //获取当前图片的上一张图片
    function GetPriorImageIndex(AImageIndex:Integer):Integer;


    //获取切换之前的图片下标
    function GetCurrentBeforePictureImageIndex:Integer;
    function GetCurrentBeforeSkinPicture:TDrawPicture;
    //获取切换之后的图片下标
    function GetCurrentAfterPictureImageIndex:Integer;
    function GetCurrentAfterSkinPicture:TDrawPicture;


    //获取当前的切换方向
    function GetCurrentSwitchOrderType:TAnimateOrderType;
    function GetCurrentImageListSwitchEffectType:TAnimateSwitchEffectType;




  private
    //初始滚动条
    procedure InitScrollBars;
    //根据图片的移动进度来初始手势管理滚动条越界值
    procedure InitScrollBarOverrangePosValue;

    //根据图片调整滚动条的边界
    procedure AdjustScrollBarRangeByPicture;


    //设置缩放比例,来确定是否显示滚动条
    procedure SetGestureZoomScale(Value:Double);


    //获取当前切换的滚动条类型
    function GetCurrentCanGestureScrollBarKind:TScrollBarKind;
    function GetCurrentCanGestureControlGestureManager:TSkinControlGestureManager;


    //默认可以手势切换下一张图片的距离
    function CalcCanGestureSwitchDistance:Double;



    //向右拖动事件,或向上拖动
    procedure DoVert_InnerMinOverRangePosValueChange(Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);override;
    //向左拖动事件,或向下拖动
    procedure DoVert_InnerMaxOverRangePosValueChange(Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);override;
    //计算需要惯性滚动的距离
    procedure DoVert_InnerCalcInertiaScrollDistance(Sender:TObject;
                                                  var InertiaDistance:Double;
                                                  var CanInertiaScroll:Boolean
                                                  );override;
    //惯性滚动结束事件
    procedure DoVert_InnerInertiaScrollAnimateBegin(Sender:TObject);override;
    procedure DoVert_InnerInertiaScrollAnimateEnd(Sender:TObject;
                                                var CanStartScrollToInitial:Boolean;
                                                var AMinOverRangePosValue_Min:Double;
                                                var AMaxOverRangePosValue_Min:Double);override;
    //滚回初始事件
    procedure DoVert_InnerScrollToInitialAnimateBegin(Sender:TObject);override;
    procedure DoVert_InnerScrollToInitialAnimateEnd(Sender:TObject);override;





    //向右拖动事件,或向上拖动
    procedure DoHorz_InnerMinOverRangePosValueChange(Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);override;
    //向左拖动事件,或向下拖动
    procedure DoHorz_InnerMaxOverRangePosValueChange(Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);override;
    //计算需要惯性滚动的距离
    procedure DoHorz_InnerCalcInertiaScrollDistance(Sender:TObject;
                                                  var InertiaDistance:Double;
                                                  var CanInertiaScroll:Boolean
                                                  );override;
    //惯性滚动结束事件
    procedure DoHorz_InnerInertiaScrollAnimateBegin(Sender:TObject);override;
    procedure DoHorz_InnerInertiaScrollAnimateEnd(Sender:TObject;
                                                var CanStartScrollToInitial:Boolean;
                                                var AMinOverRangePosValue_Min:Double;
                                                var AMaxOverRangePosValue_Min:Double);override;
    //滚回初始事件
    procedure DoHorz_InnerScrollToInitialAnimateBegin(Sender:TObject);override;
    procedure DoHorz_InnerScrollToInitialAnimateEnd(Sender:TObject);override;

  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public

    /// <summary>
    ///   <para>
    ///     切换图片
    ///   </para>
    ///   <para>
    ///     Switch picture
    ///   </para>
    /// </summary>
    procedure SwitchPicture(ABeginImageIndex:Integer;AAfterImageIndex:Integer);
    /// <summary>
    ///   <para>
    ///     切换到下一张
    ///   </para>
    ///   <para>
    ///     Switch to next picture
    ///   </para>
    /// </summary>
    procedure SwitchNext;
    /// <summary>
    ///   <para>
    ///     切换到上一张
    ///   </para>
    ///   <para>
    ///     Switch to prior picture
    ///   </para>
    /// </summary>
    procedure SwitchPrior;
    /// <summary>
    ///   <para>
    ///     释放切换按钮
    ///   </para>
    ///   <para>
    ///     Free switch buttons
    ///   </para>
    /// </summary>
//    procedure FreeSwitchButtons;
    /// <summary>
    ///   <para>
    ///     排列切换按钮
    ///   </para>
    ///   <para>
    ///     Align switch buttons
    ///   </para>
    /// </summary>
    procedure AlignSwitchButtons;


    //开始缩放到初始大小
    procedure StartZoomingToInitial;
    //手势缩放的比例
    property GestureZoomScale:Double read FGestureZoomScale write SetGestureZoomScale;

  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property AutoSize;



    /// <summary>
    ///   <para>
    ///     垂直滚动条是否显示
    ///   </para>
    ///   <para>
    ///     Whether display vertical scrollbar
    ///   </para>
    /// </summary>
    property VertScrollBarShowType;
    /// <summary>
    ///   <para>
    ///     水平滚动条是否显示
    ///   </para>
    ///   <para>
    ///     Whether diaplay horizontal scrollbar
    ///   </para>
    /// </summary>
    property HorzScrollBarShowType;


    /// <summary>
    ///   <para>
    ///     图片
    ///   </para>
    ///   <para>
    ///     Picture
    ///   </para>
    /// </summary>
    property Picture: TDrawPicture read FPicture write SetPicture;



    /// <summary>
    ///   <para>
    ///     是否可以手势切换
    ///   </para>
    ///   <para>
    ///     Wheter can switch by gesture
    ///   </para>
    /// </summary>
    property CanGestureSwitch:Boolean read FCanGestureSwitch write FCanGestureSwitch;
    /// <summary>
    ///   <para>
    ///     可以切换到下一张的手势移动距离
    ///   </para>
    ///   <para>
    ///     Gesture move distance when switch to next page
    ///   </para>
    /// </summary>
    property CanGestureSwitchDistance:Double read FCanGestureSwitchDistance write FCanGestureSwitchDistance;
    /// <summary>
    ///   <para>
    ///     是否可以通过手势循环切换图片
    ///   </para>
    ///   <para>
    ///     Whether can loop switch picture by gestures
    ///   </para>
    /// </summary>
    property GestureSwitchLooped:Boolean read FGestureSwitchLooped write SetGestureSwitchLooped;





    //是否可以手势缩放
    property CanGestureZoom:Boolean read FCanGestureZoom write FCanGestureZoom;
    //最大缩放比例
    property MaxGestureZoomScale:Double read FMaxGestureZoomScale write FMaxGestureZoomScale;
    //最小缩放比例
    property MinGestureZoomScale:Double read FMinGestureZoomScale write FMinGestureZoomScale;




    //动画显示(暂不支持)
    property Animated:Boolean read FAnimated write SetAnimated;
    property AnimateSpeed:Double read FAnimateSpeed write SetAnimateSpeed;




    //是否旋转(暂不支持)
    property Rotated:Boolean read FRotated write FRotated;
    property RotateSpeed:Double read FRotateSpeed write FRotateSpeed;
    property RotateIncrement:Integer read FRotateIncrement write FRotateIncrement;
    property CurrentRotateAngle:Integer read FCurrentRotateAngle write FCurrentRotateAngle;




    /// <summary>
    ///   <para>
    ///     图片列表循环地播放
    ///   </para>
    ///   <para>
    ///     PictureList loop play
    ///   </para>
    /// </summary>
    property ImageListAnimated:Boolean read FImageListAnimated write SetImageListAnimated;
    /// <summary>
    ///   <para>
    ///     图片列表循环播放的速度
    ///   </para>
    ///   <para>
    ///     ImageList loop play speed
    ///   </para>
    /// </summary>
    property ImageListAnimateSpeed:Double read FImageListAnimateSpeed write SetImageListAnimateSpeed;
    /// <summary>
    ///   <para>
    ///     图片列表循环播放的顺序类型
    ///   </para>
    ///   <para>
    ///     ImageList loop play order type
    ///   </para>
    /// </summary>
    property ImageListAnimateOrderType:TAnimateOrderType read FImageListAnimateOrderType write SetImageListAnimateOrderType;




    /// <summary>
    ///   <para>
    ///     图片列表循环播放的切换时的切换效果类型(水平,垂直)
    ///   </para>
    ///   <para>
    ///   Switch effect type when PictureList loop playing
    ///   </para>
    /// </summary>
    property ImageListSwitchEffectType: TAnimateSwitchEffectType read FImageListSwitchEffectType write SetImageListSwitchEffectType;
    /// <summary>
    ///   <para>
    ///     图片列表循环播放切换时的切换速度
    ///   </para>
    ///   <para>
    ///     Switch speed when ImageList loop playing and switching
    ///   </para>
    /// </summary>
    property ImageListSwitchingSpeed:Double read FImageListSwitchingSpeed write SetImageListSwitchingSpeed;
    /// <summary>
    ///   <para>
    ///     图片列表循环播放的切换时的切换移动距离(百分比)
    ///   </para>
    ///   <para>
    ///    Switch move distance when ImageList loop playing and switching
    ///   </para>
    /// </summary>
    property ImageListSwitchingProgressIncrement:Integer read FImageListSwitchingProgressIncrement write SetImageListSwitchingProgressIncrement;





  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     图片列表播放框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of ImageList player material
  ///   </para>
  /// </summary>
  TSkinImageListViewerMaterial=class(TSkinScrollControlDefaultMaterial)
  private
    //图片绘制参数
    FDrawPictureParam:TDrawPictureParam;
    procedure SetDrawPictureParam(const Value: TDrawPictureParam);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  private
    //是否绘制空心圆
    FIsDrawClipRound: Boolean;
    FDrawRoundOutSideRectParam: TDrawRectParam;

    function GetClipRoundHeight: TControlSize;
    function GetClipRoundWidth: TControlSize;
    function GetClipRoundRectSetting: TDrawRectSetting;

    procedure SetClipRoundHeight(const Value: TControlSize);
    procedure SetClipRoundRectSetting(const Value: TDrawRectSetting);
    procedure SetClipRoundWidth(const Value: TControlSize);

    procedure SetIsDrawClipRound(const Value: Boolean);
    procedure SetDrawRoundOutSideRectParam(const Value: TDrawRectParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //图片绘制参数
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
    /// <summary>
    ///   <para>
    ///     是否剪裁出圆角矩形
    ///   </para>
    ///   <para>
    ///     Whether clip round corner rectangle
    ///   </para>
    /// </summary>
    property IsDrawClipRound:Boolean read FIsDrawClipRound write SetIsDrawClipRound;

    /// <summary>
    ///   <para>
    ///     剪裁出圆角矩形的圆角宽度
    ///   </para>
    ///   <para>
    ///    clip round corner rectangle's round corner width
    ///   </para>
    /// </summary>
    property ClipRoundWidth:TControlSize read GetClipRoundWidth write SetClipRoundWidth;

    /// <summary>
    ///   <para>
    ///     剪裁出圆角矩形的圆角高度
    ///   </para>
    ///   <para>
    ///     Clip round corner rectangle's round corner height
    ///   </para>
    /// </summary>
    property ClipRoundHeight:TControlSize read GetClipRoundHeight write SetClipRoundHeight;

    /// <summary>
    ///   <para>
    ///     剪裁出圆角矩形的绘制矩形设置
    ///   </para>
    ///   <para>
    ///     Clip round corner rectangle's draw rectangle setting
    ///   </para>
    /// </summary>
    property ClipRoundRectSetting:TDrawRectSetting read GetClipRoundRectSetting write SetClipRoundRectSetting;

    /// <summary>
    ///   <para>
    ///     圆角矩形外面的矩形绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of outside round rectangle
    ///   </para>
    /// </summary>
    property DrawRoundOutSideRectParam: TDrawRectParam read FDrawRoundOutSideRectParam write SetDrawRoundOutSideRectParam;
  end;

  TSkinImageListViewerType=class(TSkinScrollControlDefaultType)
  protected
    FIsZoomed:Boolean;
    FSkinImageListViewerIntf:ISkinImageListViewer;
    function GetSkinMaterial:TSkinImageListViewerMaterial;

    //当前显示的图片的切换时的显示矩形
    function GetImageListSwitchingBeforePictureDrawRect(const ADrawRect:TRectF):TRectF;
    //下一张显示的图片的切换时的显示矩形
    function GetImageListSwitchingAfterPictureDrawRect(const ADrawRect:TRectF):TRectF;
  protected
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);override;
    procedure CustomMouseLeave;override;
    function CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;override;

    procedure SizeChanged;override;
    {$IFDEF FMX}
    procedure Gesture(const EventInfo: TGestureEventInfo; var Handled: Boolean);override;
    {$ENDIF}
    //自定义绘制方法
    function CustomPaintContent(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;

    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;

    //计算图片绘制矩形
    function CalcPictureDrawRect(ACanvas:TDrawCanvas;APicture:TDrawPicture;ADrawRect:TRectF):TRectF;
  end;











  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinImageListViewerDefaultMaterial=class(TSkinImageListViewerMaterial);
  TSkinImageListViewerDefaultType=TSkinImageListViewerType;






  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinImageListViewer=class(TSkinScrollControl,ISkinImageListViewer)
  private
    function GetImageListViewerProperties:TImageListViewerProperties;
    procedure SetImageListViewerProperties(Value:TImageListViewerProperties);
  protected
    //水平滚动条
    FSwitchButtonGroup:TSkinBaseButtonGroup;
    FSwitchButtonGroupIntf:ISkinButtonGroup;

    //图片列表切换结束事件
    FOnImageListSwitchEnd: TNotifyEvent;
    FOnImageListSwitchBegin: TSwitchBeginNotifyEvent;

    function GetOnImageListSwitchEnd:TNotifyEvent;

    function GetOnImageListSwitchBegin:TSwitchBeginNotifyEvent;

  protected
    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;

    procedure SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
  public
    constructor Create(AOwner:TComponent);override;
    property Prop:TImageListViewerProperties read GetImageListViewerProperties write SetImageListViewerProperties;
  public
    //水平滚动条
    function GetSwitchButtonGroup:TSkinBaseButtonGroup;
    function GetSwitchButtonGroupIntf:ISkinButtonGroup;
  public
    function SelfOwnMaterialToDefault:TSkinImageListViewerDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinImageListViewerDefaultMaterial;
    function Material:TSkinImageListViewerDefaultMaterial;
  published




    //图片列表切换结束事件
    property OnImageListSwitchEnd:TNotifyEvent read GetOnImageListSwitchEnd write FOnImageListSwitchEnd;
    property OnImageListSwitchBegin:TSwitchBeginNotifyEvent read GetOnImageListSwitchBegin write FOnImageListSwitchBegin;
    //水平滚动条
    property SwitchButtonGroup: TSkinBaseButtonGroup read GetSwitchButtonGroup write SetSwitchButtonGroup;
    //属性
    property Properties:TImageListViewerProperties read GetImageListViewerProperties write SetImageListViewerProperties;
  end;




  {$IFDEF VCL}
  TSkinWinImageListViewer=class(TSkinImageListViewer)
  end;
  {$ENDIF VCL}




implementation





{ TSkinImageListViewerType }

function TSkinImageListViewerType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinImageListViewer,Self.FSkinImageListViewerIntf) then
    begin
      Result:=True;
    end
    else
    begin
      raise Exception.Create('此组件不支持ISkinImageListViewer接口');
    end;
  end;
end;

procedure TSkinImageListViewerType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinImageListViewerIntf:=nil;
end;

function TSkinImageListViewerType.CalcPictureDrawRect(ACanvas:TDrawCanvas;APicture: TDrawPicture;ADrawRect:TRectF): TRectF;
begin
  Result:=ADrawRect;
  if GetSkinMaterial<>nil then
  begin
    //缩放比例
    GetSkinMaterial.FDrawPictureParam.StaticScale:=
      Self.FSkinImageListViewerIntf.Prop.FGestureZoomScale;
    //计算绘制矩形
    CalcImageDrawRect(GetSkinMaterial.DrawPictureParam,
                              APicture.CurrentPictureDrawWidth,
                              APicture.CurrentPictureDrawHeight,
                              ADrawRect,
                              Result);
  end;
end;

function TSkinImageListViewerType.GetSkinMaterial: TSkinImageListViewerMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinImageListViewerMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


procedure TSkinImageListViewerType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin

//  if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft  then
//  begin
    FIsZoomed:=False;

    if Self.FSkinImageListViewerIntf.Prop.FIsGestureZooming then Exit;

    //初始滚动条
    Self.FSkinImageListViewerIntf.Prop.InitScrollBarOverrangePosValue;

//  end;

  inherited;
end;


function TSkinImageListViewerType.GetImageListSwitchingBeforePictureDrawRect(const ADrawRect: TRectF): TRectF;
begin
  Result:=ADrawRect;
//  if Self.GetSkinMaterial<>nil then
//  begin
//    Result:=Self.GetSkinMaterial.DrawPictureParam.CalcDrawRect(ADrawRect);
//  end;

  case Self.FSkinImageListViewerIntf.Prop.GetCurrentImageListSwitchEffectType of
    ilasetNone: ;
    ilasetMoveHorz:
    begin
      case Self.FSkinImageListViewerIntf.Prop.GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Left:=Result.Left-Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Left:=Result.Left+Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
      end;
    end;
    ilasetMoveVert:
    begin
      case Self.FSkinImageListViewerIntf.Prop.GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Top:=Result.Top-Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Top:=Result.Top+Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
      end;
    end;
  end;
end;



function TSkinImageListViewerType.GetImageListSwitchingAfterPictureDrawRect(const ADrawRect: TRectF): TRectF;
begin
  Result:=ADrawRect;
//
//  if Self.GetSkinMaterial<>nil then
//  begin
//    Result:=Self.GetSkinMaterial.DrawPictureParam.CalcDrawRect(ADrawRect);
//  end;

  case Self.FSkinImageListViewerIntf.Prop.GetCurrentImageListSwitchEffectType of
    ilasetNone: ;
    ilasetMoveHorz:
    begin
      case Self.FSkinImageListViewerIntf.Prop.GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Left:=Result.Right-Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Left:=Result.Left-RectWidthF(ADrawRect)+Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
      end;
    end;
    ilasetMoveVert:
    begin
      case Self.FSkinImageListViewerIntf.Prop.GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Top:=Result.Bottom-Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Top:=Result.Top-RectHeightF(ADrawRect)+Self.FSkinImageListViewerIntf.Prop.FImageListSwitchingProgress;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
      end;
    end;
  end;
end;



procedure TSkinImageListViewerType.CustomMouseLeave;
begin
  inherited;
end;

procedure TSkinImageListViewerType.CustomMouseMove(Shift: TShiftState; X, Y: Double);
begin

  if Self.FSkinImageListViewerIntf.Prop.FIsGestureZooming then Exit;

  //手指滑动的时候也初始滚动条(因为移动平台MouseMove和MouseDown无先后)
  Self.FSkinImageListViewerIntf.Prop.InitScrollBarOverrangePosValue;

  inherited;
end;

procedure TSkinImageListViewerType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  inherited;
end;

function TSkinImageListViewerType.CustomMouseWheel(Shift: TShiftState; WheelDelta:Integer; X,Y: Double): Boolean;
begin
  Inherited;
//  Self.FSkinImageListViewerIntf.Prop.FControlGestureManager.CustomMouseWheel(Shift,WheelDelta,X,Y);
end;

procedure TSkinImageListViewerType.SizeChanged;
begin
  inherited;
  Self.FSkinImageListViewerIntf.Prop.AdjustScrollBarRangeByPicture;
end;

{$IFDEF FMX}
procedure TSkinImageListViewerType.Gesture(const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  inherited;


  if (EventInfo.GestureID = igiZoom) and Self.FSkinImageListViewerIntf.Prop.FCanGestureZoom then
  begin
    Handled:=True;
    FIsZoomed:=True;
    if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
    begin
      //暂停切换
      Self.FSkinImageListViewerIntf.Prop.FIsGestureZooming:=True;
    end;
    if (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
    begin
      //可以切换
      Self.FSkinImageListViewerIntf.Prop.FIsGestureZooming:=False;
      Self.FSkinImageListViewerIntf.Prop.StartZoomingToInitial;
    end;

    if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
      (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
    begin

      { zoom the image }
        Self.FSkinImageListViewerIntf.Prop.FGestureZoomScale:=
          Self.FSkinImageListViewerIntf.Prop.FGestureZoomScale
          *(1-(Self.FSkinImageListViewerIntf.Prop.FLastGestureZoomDistance-EventInfo.Distance)
              /Self.FSkinControlIntf.Width);
        Self.FSkinImageListViewerIntf.Prop.SetGestureZoomScale(
                Self.FSkinImageListViewerIntf.Prop.FGestureZoomScale);

        Self.Invalidate;

    end;
    Self.FSkinImageListViewerIntf.Prop.FLastGestureZoomDistance := EventInfo.Distance;


  end;
end;
{$ENDIF}


function TSkinImageListViewerType.CustomPaintContent(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ABeforePicture:TDrawPicture;
  AAfterPicture:TDrawPicture;

  ABeforePictureDrawRect:TRectF;
  AAfterPictureDrawRect:TRectF;

  AScrollDrawRect:TRectF;

  ADrawRectLeftOffset,
  ADrawRectTopOffset:Double;
  AClipRect:TRectF;
begin
  if Self.GetSkinMaterial<>nil then
  begin


      AClipRect:=GetSkinMaterial.DrawPictureParam.CalcDrawRect(ADrawRect);
      ACanvas.SetClip(AClipRect);
      try


          //滚动位移
          case Self.FSkinImageListViewerIntf.Prop.GetCurrentCanGestureScrollBarKind of
            sbHorizontal:
            begin
              ADrawRectLeftOffset:=Self.FSkinScrollControlIntf.Prop.HorzControlGestureManager.Position;
              ADrawRectTopOffset:=Self.FSkinScrollControlIntf.Prop.GetTopDrawOffset;
            end;
            sbVertical:
            Begin
              ADrawRectLeftOffset:=Self.FSkinScrollControlIntf.Prop.GetLeftDrawOffset;
              ADrawRectTopOffset:=Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Position;
            End;
          end;


          AScrollDrawRect:=ADrawRect;
          AScrollDrawRect.Left:=AScrollDrawRect.Left-ADrawRectLeftOffset;
          AScrollDrawRect.Top:=AScrollDrawRect.Top-ADrawRectTopOffset;
          AScrollDrawRect.Right:=AScrollDrawRect.Right-ADrawRectLeftOffset;
          AScrollDrawRect.Bottom:=AScrollDrawRect.Bottom-ADrawRectTopOffset;


          //缩放比例
          GetSkinMaterial.FDrawPictureParam.StaticScale:=
            Self.FSkinImageListViewerIntf.Prop.FGestureZoomScale;




    //      //图片旋转
    //      Self.GetSkinMaterial.FDrawPictureParam.StaticRotateAngle:=Self.FSkinImageListViewerIntf.Prop.FCurrentRotateAngle;



            //当前正在切换图片
            if Self.FSkinImageListViewerIntf.Prop.CheckIsImageListSwitching then
            begin
      //        OutputDebugString('前一张 '+IntToStr(Self.FSkinImageListViewerIntf.Prop.GetCurrentBeforePictureImageIndex)
      //                          +'后一张 '+IntToStr(Self.FSkinImageListViewerIntf.Prop.GetCurrentAfterPictureImageIndex)
      //                          );




              //切换之前的图片
              ABeforePicture:=Self.FSkinImageListViewerIntf.Prop.GetCurrentBeforeSkinPicture;
              //切换之后的图片
              AAfterPicture:=Self.FSkinImageListViewerIntf.Prop.GetCurrentAfterSkinPicture;


              //切换之前图片和切换之后图片的绘制矩形
              ABeforePictureDrawRect:=Self.GetImageListSwitchingBeforePictureDrawRect(AScrollDrawRect);
              //下一张图片不做缩放
              AAfterPictureDrawRect:=Self.GetImageListSwitchingAfterPictureDrawRect(ADrawRect);


              //绘制之前的图片
              if (ABeforePicture<>nil) then
              begin
      //            if Self.FSkinImageListViewerIntf.Prop.FAnimated
      //              //是GIF引擎
      //              and (ABeforePicture.SkinPictureEngine is TSkinBaseGIFPictureEngine)
      //            then
      //            begin
      //              //GIF图片播放
      //              TSkinBaseGIFPictureEngine(ABeforePicture.SkinPictureEngine).DrawToCanvas(ACanvas,
      //                                              Self.GetSkinMaterial.FDrawPictureParam,
      //                                              ABeforePictureDrawRect);
      //            end
      //            else
      //            begin
                    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                                            ABeforePicture,
                                            ABeforePictureDrawRect
                                            );

//                    if (GetSkinMaterial<>nil) and (GetSkinMaterial.FIsDrawClipRound) then
//                    begin
//                      ACanvas.DrawRect(GetSkinMaterial.FDrawRoundOutSideRectParam,ABeforePictureDrawRect);
//                    end;
      //            end;
              end;



              //绘制之后的图片
              if (AAfterPicture<>nil) then
              begin
      //          if Self.FSkinImageListViewerIntf.Prop.FAnimated
      //            //是GIF引擎
      //            and (AAfterPicture.SkinPictureEngine is TSkinBaseGIFPictureEngine)
      //          then
      //          begin
      //            //GIF图片播放
      //            TSkinBaseGIFPictureEngine(AAfterPicture.SkinPictureEngine).DrawToCanvas(ACanvas,
      //                                            Self.GetSkinMaterial.FDrawPictureParam,
      //                                            AAfterPictureDrawRect);
      //          end
      //          else
      //          begin
                  GetSkinMaterial.FDrawPictureParam.StaticScale:=1;
                  ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                                          AAfterPicture,
                                          AAfterPictureDrawRect
                                          );

//                  if (GetSkinMaterial<>nil) and (GetSkinMaterial.FIsDrawClipRound) then
//                  begin
//                    ACanvas.DrawRect(GetSkinMaterial.FDrawRoundOutSideRectParam,AAfterPictureDrawRect);
//                  end;
      //          end;
              end;



              if (GetSkinMaterial<>nil) and (GetSkinMaterial.FIsDrawClipRound) then
              begin
                ACanvas.DrawRect(GetSkinMaterial.FDrawRoundOutSideRectParam,ADrawRect);
              end;

          end
          else
          begin

      //        if Self.FSkinImageListViewerIntf.Prop.FAnimated
      //          //是GIF引擎
      //          and (Self.FSkinImageListViewerIntf.Prop.Picture.SkinPictureEngine is TSkinBaseGIFPictureEngine)
      //        then
      //        begin
      //          //GIF图片播放
      //          TSkinBaseGIFPictureEngine(Self.FSkinImageListViewerIntf.Prop.Picture.SkinPictureEngine).DrawToCanvas(ACanvas,
      //                                          Self.GetSkinMaterial.FDrawPictureParam,
      //                                          AScrollDrawRect);
      //        end
      //        else
      //        begin

      //          if Self.FSkinImageListViewerIntf.Prop.Rotated then
      //          begin
      //            //图片旋转
      //            Self.GetSkinMaterial.FDrawPictureParam.StaticRotateAngle:=Self.FSkinImageListViewerIntf.Prop.FCurrentRotateAngle;
      //          end;

                ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                                    Self.FSkinImageListViewerIntf.Prop.Picture,
                                    AScrollDrawRect);
                if (GetSkinMaterial<>nil) and (GetSkinMaterial.FIsDrawClipRound) then
                begin
                  ACanvas.DrawRect(GetSkinMaterial.FDrawRoundOutSideRectParam,AScrollDrawRect);
                end;
      //        end;

          end;


      finally
        ACanvas.ResetClip;
      end;
  end;
end;

function TSkinImageListViewerType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
begin
  Result:=False;
  AWidth:=0;
  AHeight:=0;

  if not (csReading in Self.FSkinControl.ComponentState)
      and (Self.FSkinControlIntf.GetParent<>nil)
      and (Self.FSkinImageListViewerIntf.Prop.FPicture.CurrentPictureDrawWidth>0)
      and (Self.FSkinImageListViewerIntf.Prop.FPicture.CurrentPictureDrawHeight>0) then
  begin
    AWidth:=Self.FSkinImageListViewerIntf.Prop.FPicture.CurrentPictureDrawWidth;
    AHeight:=Self.FSkinImageListViewerIntf.Prop.FPicture.CurrentPictureDrawHeight;
    Result:=True;
  end;

end;


{ TSkinImageListViewerMaterial }

constructor TSkinImageListViewerMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');

  FIsDrawClipRound:=True;

  FDrawRoundOutSideRectParam:=CreateDrawRectParam('DrawRoundOutSideRectParam','圆外矩形绘制参数');
  FDrawRoundOutSideRectParam.FIsClipRound:=True;
end;

destructor TSkinImageListViewerMaterial.Destroy;
begin
  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FDrawRoundOutSideRectParam);
  inherited;
end;

//function TSkinImageListViewerMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited LoadFromDocNode(ADocNode);
//
////  for I := 0 to ADocNode.ChildNodes.Count - 1 do
////  begin
////    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='DrawPictureParam' then
////    begin
////      FDrawPictureParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    ;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinImageListViewerMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawPictureParam',FDrawPictureParam.Name);
////  Self.FDrawPictureParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//
//end;

procedure TSkinImageListViewerMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;


function TSkinImageListViewerMaterial.GetClipRoundHeight: TControlSize;
begin
  Result:=FDrawRoundOutSideRectParam.FClipRoundHeight;
end;

function TSkinImageListViewerMaterial.GetClipRoundRectSetting: TDrawRectSetting;
begin
  Result:=FDrawRoundOutSideRectParam.FClipRoundRectSetting;
end;

function TSkinImageListViewerMaterial.GetClipRoundWidth: TControlSize;
begin
  Result:=FDrawRoundOutSideRectParam.FClipRoundWidth;
end;

procedure TSkinImageListViewerMaterial.SetDrawRoundOutSideRectParam(const Value: TDrawRectParam);
begin
  FDrawRoundOutSideRectParam.Assign(Value);
end;

procedure TSkinImageListViewerMaterial.SetIsDrawClipRound(const Value: Boolean);
begin
  if FIsDrawClipRound<>Value then
  begin
    FIsDrawClipRound := Value;
    Self.DoChange();
  end;
end;

procedure TSkinImageListViewerMaterial.SetClipRoundHeight(const Value: TControlSize);
begin
  FDrawRoundOutSideRectParam.ClipRoundHeight:=Value;
end;

procedure TSkinImageListViewerMaterial.SetClipRoundWidth(const Value: TControlSize);
begin
  FDrawRoundOutSideRectParam.ClipRoundWidth:=Value;
end;

procedure TSkinImageListViewerMaterial.SetClipRoundRectSetting(const Value: TDrawRectSetting);
begin
  FDrawRoundOutSideRectParam.FClipRoundRectSetting.Assign(Value);
end;


{ TImageListViewerProperties }


procedure TImageListViewerProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
//  FPicture.Assign(TImageListViewerProperties(Src).FPicture);
//
//  FAnimated:=TImageListViewerProperties(Src).FAnimated;
//  FAnimateSpeed:=TImageListViewerProperties(Src).FAnimateSpeed;

//  FRotated:=TImageListViewerProperties(Src).FRotated;
//  FRotateSpeed:=TImageListViewerProperties(Src).FRotateSpeed;
//  FRotateIncrement:=TImageListViewerProperties(Src).FRotateIncrement;

//  FImageListAnimated:=TImageListViewerProperties(Src).FImageListAnimated;
//  FImageListAnimateSpeed:=TImageListViewerProperties(Src).FImageListAnimateSpeed;
//  FImageListAnimateOrderType:=TImageListViewerProperties(Src).FImageListAnimateOrderType;
//
//  FCanGestureZoom:=TImageListViewerProperties(Src).FCanGestureZoom;
//  FMaxGestureZoomScale:=TImageListViewerProperties(Src).FMaxGestureZoomScale;
//  FMinGestureZoomScale:=TImageListViewerProperties(Src).FMinGestureZoomScale;
//
//
//  FCanGestureSwitch:=TImageListViewerProperties(Src).FCanGestureSwitch;
//  FCanGestureSwitchDistance:=TImageListViewerProperties(Src).FCanGestureSwitchDistance;
//  FGestureSwitchLooped:=TImageListViewerProperties(Src).FGestureSwitchLooped;
//
//  FImageListSwitchingSpeed:=TImageListViewerProperties(Src).FImageListSwitchingSpeed;
//  FImageListSwitching:=TImageListViewerProperties(Src).FImageListSwitching;
//  FImageListSwitchingProgress:=TImageListViewerProperties(Src).FImageListSwitchingProgress;
//  FImageListSwitchingProgressIncrement:=TImageListViewerProperties(Src).FImageListSwitchingProgressIncrement;
//  FImageListSwitchEffectType:=TImageListViewerProperties(Src).FImageListSwitchEffectType;//ilasetMoveHorz;//
end;

function TImageListViewerProperties.CalcCanGestureSwitchDistance: Double;
begin
  //默认可以手势切换下一张图片的距离
  Result:=Self.GetImageListSwitchingProgressMaxSize/3;

  if (Self.FCanGestureSwitchDistance>0)
    and (Self.FCanGestureSwitchDistance<1) then
  begin
    Result:=GetImageListSwitchingProgressMaxSize*FCanGestureSwitchDistance;
  end
  else if (Self.FCanGestureSwitchDistance>0) then
  begin
    Result:=FCanGestureSwitchDistance;
  end;

end;

function TImageListViewerProperties.CheckIsImageListSwitching: Boolean;
begin
  //当前是否正在切换
  Result:=False;
  case Self.GetCurrentImageListSwitchEffectType of
    ilasetNone: ;
    ilasetMoveHorz,ilasetMoveVert:
    begin
      if (FImageListSwitchingProgress>0) then
      begin
        Result:=True;
      end;
    end;
  end;
end;

constructor TImageListViewerProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinImageListViewer,Self.FSkinImageListViewerIntf) then
  begin
    ShowException('此组件不支持ISkinImageListViewer接口');
  end
  else
  begin
      Self.FSkinControlIntf.Width:=120;
      Self.FSkinControlIntf.Height:=100;


      //内容宽度
      FContentWidth:=-1;
      //内容高度
      FContentHeight:=-1;



      //支持GIF
      FPicture:=CreateDrawPicture('Picture','图片');
  //    FPicture.GIFSupport:=True;
  //    FPicture.OnAnimateRePaint:=Self.DoGIFAnimateRePaint;
      FPicture.OnChange:=DoPictureChanged;



      FAnimated:=False;
      FAnimateSpeed:=10;




      FImageListAnimated:=False;
      FImageListAnimateSpeed:=500;



      FImageListSwitchingSpeed:=5;
      FImageListSwitching:=False;
      FImageListSwitchingProgress:=0;
      //增量(百分比)
      FImageListSwitchingProgressIncrement:=20;
      FImageListAnimateOrderType:=TAnimateOrderType.ilaotAsc;
      FImageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetNone;



      FCurrentSwitchBeforeImageIndex:=-1;
      FCurrentSwitchAfterImageIndex:=-1;
      FCurrentSwitchOrderType:=TAnimateOrderType.ilaotNone;



  //    FRotated:=False;
  //    FRotateSpeed:=10;
  //    FRotateIncrement:=10;
  //    FCurrentRotateAngle:=0;


      FIsFirstUserDrag:=True;



      FLastGestureZoomDistance:=0;
      FGestureZoomScale:=1;
      FIsGestureZooming:=False;

      FCanGestureZoom:=False;
      FGestureSwitchLooped:=True;
      Self.FCanGestureSwitch:=True;
      FCanGestureSwitchDistance:=8;//0.33
      FMaxGestureZoomScale:=3;
      FMinGestureZoomScale:=1;




      //滚动到初始缩放比例的定时器
      FZoomingToInitialAnimator:=TSkinAnimator.Create(nil);
      FZoomingToInitialAnimator.TweenType:=Quadratic;//TTweenType.Linear;//Quartic;//Quadratic;
      FZoomingToInitialAnimator.EaseType:=TEaseType.easeOut;
      FZoomingToInitialAnimator.EndTimesCount:=10;
      FZoomingToInitialAnimator.OnAnimate:=Self.DoZoomToInitialAnimate;
      FZoomingToInitialAnimator.OnAnimateEnd:=Self.DoZoomToInitialAnimateEnd;
      FZoomingToInitialAnimator.Speed:=6;//15帧



      //自动隐藏显示滚动条
      FHorzScrollBarShowType:=sbstHide;
      FVertScrollBarShowType:=sbstNone;

  end;

end;

//procedure TImageListViewerProperties.CreateRotateTimer;
//begin
//  if FRotateTimer=nil then
//  begin
//    FRotateTimer:=TTimer.Create(nil);
//    FRotateTimer.OnTimer:=Self.DoRotateTimer;
//    FRotateTimer.Interval:=Ceil(Self.FRotateSpeed*10);
//    FRotateTimer.Enabled:=False;
//  end;
//end;

procedure TImageListViewerProperties.CreateImageListAnimateTimer;
begin
  if FImageListAnimateTimer=nil then
  begin
    FImageListAnimateTimer:=TTimer.Create(nil);
    FImageListAnimateTimer.OnTimer:=Self.DoImageListAnimateTimer;
    FImageListAnimateTimer.Interval:=Ceil(Self.FImageListAnimateSpeed*10);
    FImageListAnimateTimer.Enabled:=False;
  end;
end;

procedure TImageListViewerProperties.CreateImageListSwitchingTimer;
begin
  if FImageListSwitchingTimer=nil then
  begin
    FImageListSwitchingTimer:=TTimer.Create(nil);
    FImageListSwitchingTimer.OnTimer:=Self.DoImageListSwitchingTimer;
    FImageListSwitchingTimer.Interval:=Ceil(Self.FImageListSwitchingSpeed*10);
    FImageListSwitchingTimer.Enabled:=False;
  end;
end;

destructor TImageListViewerProperties.Destroy;
begin
//  FreeAndNil(FRotateTimer);

  FreeAndNil(FImageListAnimateTimer);
  FreeAndNil(FImageListSwitchingTimer);

  FreeAndNil(FZoomingToInitialAnimator);

  FreeAndNil(FPicture);
  inherited;
end;

//procedure TImageListViewerProperties.DoGIFAnimateRePaint(Sender: TObject);
//begin
//  //重绘
//  Self.Invalidate;
//end;

//procedure TImageListViewerProperties.DoRotateTimer(Sender: TObject);
//begin
//  //ShowDialog('FCurrentRotateAngle');
//  //角度
//  if FCurrentRotateAngle>=360 then
//  begin
//    FCurrentRotateAngle:=0;
//  end;
//
//  if FCurrentRotateAngle<=0 then
//  begin
//    FCurrentRotateAngle:=360;
//  end;
//
//  FCurrentRotateAngle:=FCurrentRotateAngle+Self.FRotateIncrement;
//
//  if FCurrentRotateAngle>360 then
//  begin
//    FCurrentRotateAngle:=360;
//  end;
//
//  if FCurrentRotateAngle<0 then
//  begin
//    FCurrentRotateAngle:=0;
//  end;
//
//  Self.Invalidate;
//end;

procedure TImageListViewerProperties.DoZoomToInitialAnimate(Sender: TObject);
begin
  Self.FGestureZoomScale:=Self.FZoomingToInitialAnimator.Position/100;
  SetGestureZoomScale(FGestureZoomScale);
  Self.Invalidate;
end;

procedure TImageListViewerProperties.DoZoomToInitialAnimateEnd(Sender: TObject);
begin

end;

procedure TImageListViewerProperties.DoImageListAnimateTimer(Sender: TObject);
begin
  SwitchNext;
end;

procedure TImageListViewerProperties.DoImageListSwitchingTimer(Sender: TObject);
begin
  //手势缩放的时候不切换
  if FIsGestureZooming then Exit;


  //当前正在手势拖动,也不切换
  if FCanGestureSwitch then
  begin
    //当前正在拖动,那么也不处理
    if Self.FSkinControlIntf.IsMouseDown then Exit;
  end;




  case Self.FImageListSwitchEffectType of
    ilasetNone:
    begin


      //没有切换效果,直接切换下标
      Self.SetImageListSwitching(False);
      Self.FPicture.ImageIndex:=Self.GetCurrentAfterPictureImageIndex;
      DoImageListSwitchEnd;

    end;
    ilasetMoveHorz,ilasetMoveVert:
    begin



      //水平垂直切换
      FImageListSwitchingProgress:=Self.FImageListSwitchingProgress
            +FImageListSwitchingProgressIncrement*Self.GetImageListSwitchingProgressMaxSize/100;
      if FImageListSwitchingProgress>=GetImageListSwitchingProgressMaxSize then
      begin
        //切换结束
        Self.SetImageListSwitching(False);

        //切换到下一张图片
        Self.FPicture.ImageIndex:=Self.GetCurrentAfterPictureImageIndex;


        //结束了
        DoImageListSwitchEnd;

      end;
    end;
  end;

  Invalidate;

end;

procedure TImageListViewerProperties.DoHorz_InnerCalcInertiaScrollDistance(Sender: TObject;
  var InertiaDistance:Double;
  var CanInertiaScroll:Boolean
  );
begin
  Inherited;
  if FCanGestureSwitch then
  begin
    if GetCurrentCanGestureScrollBarKind=sbHorizontal then
    begin


      if Self.GetCurrentCanGestureControlGestureManager.MinOverRangePosValue>0 then
      begin
        FUserStopDragSwitchToImageIndex:=GetPriorImageIndex(Self.FPicture.ImageIndex);
      end;
      if Self.GetCurrentCanGestureControlGestureManager.MaxOverRangePosValue>0 then
      begin
        FUserStopDragSwitchToImageIndex:=GetNextImageIndex(Self.FPicture.ImageIndex);
      end;


      Self.SetImageListSwitching(False);

//      EndTimesCount:=EndTimesCount;// div 2;


      //计算惯性滚动的距离
      FUserStopDragImageListSwitchingProgress:=FImageListSwitchingProgress;
      if (FImageListSwitchingProgress>CalcCanGestureSwitchDistance)
        and (FUserStopDragSwitchToImageIndex<>-1) then
      begin
        InertiaDistance:=Self.GetImageListSwitchingProgressMaxSize-Self.FImageListSwitchingProgress;

        Self.FHorzControlGestureManager.InertiaScrollAnimator.TweenType:=TTweenType.Cubic;
        Self.FHorzControlGestureManager.InertiaScrollAnimator.EaseType:=TEaseType.easeOut;
        Self.FHorzControlGestureManager.InertiaScrollAnimator.d:=10;
        Self.FHorzControlGestureManager.InertiaScrollAnimator.Speed:=Const_Deafult_AnimatorSpeed;
        Self.FHorzControlGestureManager.InertiaScrollAnimator.InitialSpeed:=3;
        Self.FHorzControlGestureManager.InertiaScrollAnimator.MaxSpeed:=3;
        Self.FHorzControlGestureManager.InertiaScrollAnimator.minps:=6;

      end;


    end;
  end;
end;

procedure TImageListViewerProperties.DoHorz_InnerInertiaScrollAnimateBegin(Sender: TObject);
begin
  Inherited;

end;

procedure TImageListViewerProperties.DoHorz_InnerInertiaScrollAnimateEnd(Sender: TObject;
  var CanStartScrollToInitial: Boolean;
  var AMinOverRangePosValue_Min:Double;
  var AMaxOverRangePosValue_Min:Double);
begin
  Inherited;

  if FCanGestureSwitch then
  begin
    if GetCurrentCanGestureScrollBarKind=sbHorizontal then
    begin
      //惯性滚动结束
      if (Self.FPicture.SkinImageList<>nil)
      and (Self.FPicture.SkinImageList.Count>1)
      then
      begin



        if (FUserStopDragImageListSwitchingProgress>CalcCanGestureSwitchDistance)
          and (FUserStopDragSwitchToImageIndex<>-1) then
        begin


          Self.FPicture.ImageIndex:=FUserStopDragSwitchToImageIndex;


          CanStartScrollToInitial:=False;

          DoImageListSwitchEnd;
        end;

      end;
    end;
  end;

end;


procedure TImageListViewerProperties.DoHorz_InnerMaxOverRangePosValueChange(Sender: TObject; NextValue, LastValue: Double; Step: Double;
  var NewValue: Double; var CanChange: Boolean);
begin
  Inherited;
  //向左拖动事件,或向下拖动
  if FCanGestureSwitch then
  begin
    //水平滚动条是否是当前可以切换的滚动条
    if GetCurrentCanGestureScrollBarKind=sbHorizontal then
    begin
    FIsGestureSwitching:=True;
    Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;

      //如果是最后一张,需要加大拖动难度
      if Self.FPicture.SkinImageList<>nil then
      begin
        if (Self.FPicture.ImageIndex=Self.FPicture.SkinImageList.Count-1)
          and (not Self.FGestureSwitchLooped)
          then
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
        end
        else
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=1;
        end;
      end
      else
      begin
        Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
      end;


      Self.FCurrentImageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetMoveHorz;


      if FIsFirstUserDrag and (FImageListSwitchingProgress>0) then
      begin
        FIsFirstUserDrag:=False;
        NewValue:=FImageListSwitchingProgress;
      end;

      Self.FImageListSwitchingProgress:=Self.GetCurrentCanGestureControlGestureManager.CalcOverRangePosValue(NewValue);
//      uBaseLog.OutputDebugString('FImageListSwitchingProgress:'+FloatToStr(FImageListSwitchingProgress));


      Self.Invalidate;
    end;
  end;
end;

procedure TImageListViewerProperties.DoHorz_InnerMinOverRangePosValueChange(Sender: TObject; NextValue, LastValue: Double;
  Step: Double;
  var NewValue: Double;
  var CanChange: Boolean);
begin
  Inherited;

  //向右拖动事件,或向上拖动
  if FCanGestureSwitch then
  begin
    //水平滚动条是否是当前可以切换的滚动条
    if GetCurrentCanGestureScrollBarKind=sbHorizontal then
    begin

      FIsGestureSwitching:=True;
      Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;



      //如果是最后一张,并且不允许循环切换,那么需要加大拖动难度
      if (Self.FPicture.SkinImageList<>nil) then
      begin
        if (Self.FPicture.ImageIndex=0)
          and (not Self.FGestureSwitchLooped)
          then
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
        end
        else
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=1;
        end;
      end
      else
      begin
        Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
      end;

      Self.FCurrentImageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetMoveHorz;

      //第一次拖动,要设置初始值
      if FIsFirstUserDrag and (FImageListSwitchingProgress>0) then
      begin
        FIsFirstUserDrag:=False;
        NewValue:=FImageListSwitchingProgress;
      end;

      Self.FImageListSwitchingProgress:=Self.GetCurrentCanGestureControlGestureManager.CalcOverRangePosValue(NewValue);
//      uBaseLog.OutputDebugString('FImageListSwitchingProgress:'+FloatToStr(FImageListSwitchingProgress));


      Self.Invalidate;
    end;
  end;
end;

procedure TImageListViewerProperties.DoHorz_InnerScrollToInitialAnimateBegin(Sender: TObject);
begin
  Inherited;

end;

procedure TImageListViewerProperties.DoHorz_InnerScrollToInitialAnimateEnd(Sender: TObject);
begin
  Inherited;
  if GetCurrentCanGestureScrollBarKind=sbHorizontal then
  begin
    Self.FIsGestureSwitching:=False;
    Self.FIsFirstUserDrag:=True;
  end;
end;



procedure TImageListViewerProperties.DoVert_InnerCalcInertiaScrollDistance(Sender: TObject;
  var InertiaDistance:Double;
  var CanInertiaScroll:Boolean
  );
begin
  Inherited;
  if FCanGestureSwitch then
  begin

    if GetCurrentCanGestureScrollBarKind=sbVertical then
    begin

      if Self.GetCurrentCanGestureControlGestureManager.MinOverRangePosValue>0 then
      begin
        FUserStopDragSwitchToImageIndex:=GetPriorImageIndex(Self.FPicture.ImageIndex);
      end;
      if Self.GetCurrentCanGestureControlGestureManager.MaxOverRangePosValue>0 then
      begin
        FUserStopDragSwitchToImageIndex:=GetNextImageIndex(Self.FPicture.ImageIndex);
      end;


      Self.SetImageListSwitching(False);


      //计算惯性滚动的距离
      FUserStopDragImageListSwitchingProgress:=FImageListSwitchingProgress;
      if (FImageListSwitchingProgress>CalcCanGestureSwitchDistance)
        and (FUserStopDragSwitchToImageIndex<>-1) then
      begin


        Self.FVertControlGestureManager.InertiaScrollAnimator.TweenType:=TTweenType.Cubic;
        Self.FVertControlGestureManager.InertiaScrollAnimator.EaseType:=TEaseType.easeOut;
        Self.FVertControlGestureManager.InertiaScrollAnimator.d:=10;
        Self.FVertControlGestureManager.InertiaScrollAnimator.Speed:=Const_Deafult_AnimatorSpeed;
        Self.FVertControlGestureManager.InertiaScrollAnimator.InitialSpeed:=3;
        Self.FVertControlGestureManager.InertiaScrollAnimator.MaxSpeed:=3;
        Self.FVertControlGestureManager.InertiaScrollAnimator.minps:=6;


        InertiaDistance:=Self.GetImageListSwitchingProgressMaxSize-Self.FImageListSwitchingProgress;
      end;


    end;
  end;
end;

procedure TImageListViewerProperties.DoVert_InnerInertiaScrollAnimateBegin(Sender: TObject);
begin
  Inherited;

end;

procedure TImageListViewerProperties.DoVert_InnerInertiaScrollAnimateEnd(Sender: TObject;
  var CanStartScrollToInitial: Boolean;
  var AMinOverRangePosValue_Min:Double;
  var AMaxOverRangePosValue_Min:Double);
var
  ACurrentImageIndex:Integer;
begin
  Inherited;

  if FCanGestureSwitch then
  begin
    if GetCurrentCanGestureScrollBarKind=sbVertical then
    begin
      //惯性滚动结束
      if (Self.FPicture.SkinImageList<>nil)
      and (Self.FPicture.SkinImageList.Count>1)
      then
      begin


        if (FUserStopDragImageListSwitchingProgress>CalcCanGestureSwitchDistance)
          and (FUserStopDragSwitchToImageIndex<>-1) then
        begin


          Self.FPicture.ImageIndex:=FUserStopDragSwitchToImageIndex;


          DoImageListSwitchEnd;
        end;

      end;
    end;
  end;

end;


procedure TImageListViewerProperties.DoVert_InnerMaxOverRangePosValueChange(Sender: TObject; NextValue, LastValue: Double; Step: Double;
  var NewValue: Double; var CanChange: Boolean);
begin
  Inherited;
  //向左拖动事件,或向下拖动
  if FCanGestureSwitch then
  begin
    //垂直滚动条是否是当前可以切换的滚动条
    if GetCurrentCanGestureScrollBarKind=sbVertical then
    begin
      FIsGestureSwitching:=True;
      Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;

      //如果是最后一张,需要加大拖动难度
      if Self.FPicture.SkinImageList<>nil then
      begin
        if (Self.FPicture.ImageIndex=Self.FPicture.SkinImageList.Count-1)
          and (not Self.FGestureSwitchLooped)
          then
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
        end
        else
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=1;
        end;
      end
      else
      begin
        Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
      end;


      Self.FCurrentImageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetMoveVert;


      if FIsFirstUserDrag and (FImageListSwitchingProgress>0) then
      begin
        FIsFirstUserDrag:=False;
        NewValue:=FImageListSwitchingProgress;
      end;

      Self.FImageListSwitchingProgress:=Self.GetCurrentCanGestureControlGestureManager.CalcOverRangePosValue(NewValue);
//      uBaseLog.OutputDebugString('FImageListSwitchingProgress:'+FloatToStr(FImageListSwitchingProgress));


      Self.Invalidate;
    end;
  end;
end;

procedure TImageListViewerProperties.DoVert_InnerMinOverRangePosValueChange(Sender: TObject; NextValue, LastValue: Double; Step: Double;
  var NewValue: Double; var CanChange: Boolean);
begin
  Inherited;

  //向右拖动事件,或向上拖动
  if FCanGestureSwitch then
  begin
    //垂直滚动条是否是当前可以切换的滚动条
    if GetCurrentCanGestureScrollBarKind=sbVertical then
    begin

      FIsGestureSwitching:=True;
      Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;

      //如果是最后一张,需要加大拖动难度
      if (Self.FPicture.SkinImageList<>nil) then
      begin
        if (Self.FPicture.ImageIndex=0)
          and (not Self.FGestureSwitchLooped)
          then
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
        end
        else
        begin
          Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=1;
        end;
      end
      else
      begin
        Self.GetCurrentCanGestureControlGestureManager.FOverRangePosValueStep:=FDefaultOverRangePosValueStep;
      end;

      Self.FCurrentImageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetMoveVert;


      if FIsFirstUserDrag and (FImageListSwitchingProgress>0) then
      begin
        FIsFirstUserDrag:=False;
        NewValue:=FImageListSwitchingProgress;
      end;

      Self.FImageListSwitchingProgress:=Self.GetCurrentCanGestureControlGestureManager.CalcOverRangePosValue(NewValue);
//      uBaseLog.OutputDebugString('FImageListSwitchingProgress:'+FloatToStr(FImageListSwitchingProgress));

      Self.Invalidate;
    end;
  end;
end;

procedure TImageListViewerProperties.DoVert_InnerScrollToInitialAnimateBegin(Sender: TObject);
begin
  Inherited;

end;

procedure TImageListViewerProperties.DoVert_InnerScrollToInitialAnimateEnd(Sender: TObject);
begin
  Inherited;
  if GetCurrentCanGestureScrollBarKind=sbVertical then
  begin
    Self.FIsGestureSwitching:=False;
    Self.FIsFirstUserDrag:=True;
  end;
end;





procedure TImageListViewerProperties.SetAnimated(const Value: Boolean);
begin
  if FAnimated<>Value then
  begin
    FAnimated := Value;
    if Self.FPicture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
    begin
      TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).Animated:=FAnimated;
    end;
  end;
end;

procedure TImageListViewerProperties.SetAnimateSpeed(const Value: Double);
begin
  if FAnimateSpeed<>Value then
  begin
    FAnimateSpeed := Value;
    TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).AnimateSpeed:=FAnimateSpeed;
  end;
end;

procedure TImageListViewerProperties.SetGestureZoomScale(Value: Double);
begin
  FGestureZoomScale:=Value;

  AdjustScrollBarRangeByPicture;

end;

procedure TImageListViewerProperties.SetImageListAnimated(const Value: Boolean);
begin
  if FImageListAnimated<>Value then
  begin
    FImageListAnimated := Value;
    if FImageListAnimated then
    begin
      Self.CreateImageListAnimateTimer;
      if Self.FImageListAnimateTimer<>nil then
      begin
        Self.FImageListAnimateTimer.Enabled:=True;
      end;
    end
    else
    begin
      if Self.FImageListAnimateTimer<>nil then
      begin
        Self.FImageListAnimateTimer.Enabled:=False;
      end;
    end;
  end;
end;

procedure TImageListViewerProperties.SetImageListAnimateOrderType(const Value: TAnimateOrderType);
begin
  if FImageListAnimateOrderType<>Value then
  begin
    FImageListAnimateOrderType := Value;
  end;
end;

procedure TImageListViewerProperties.SetImageListSwitchEffectType(const Value: TAnimateSwitchEffectType);
begin
  if FImageListSwitchEffectType<>Value then
  begin
    FImageListSwitchEffectType := Value;
  end;
end;

procedure TImageListViewerProperties.SetImageListSwitching(const Value: Boolean);
begin
  if FImageListSwitching<>Value then
  begin
    //当前是否正在切换
    FImageListSwitching := Value;

    if FImageListSwitching then
    begin
      //开始切换
      Self.CreateImageListSwitchingTimer;
      if Self.FImageListSwitchingTimer<>nil then
      begin
        Self.FImageListSwitchingTimer.Enabled:=True;
      end;
    end
    else
    begin
      //停正切换
      if Self.FImageListSwitchingTimer<>nil then
      begin
        Self.FImageListSwitchingTimer.Enabled:=False;
      end;
    end;
  end;
end;

procedure TImageListViewerProperties.SetImageListSwitchingProgressIncrement(const Value: Integer);
begin
  if FImageListSwitchingProgressIncrement<>Value then
  begin
    FImageListSwitchingProgressIncrement := Value;
//    Invalidate;
  end;
end;

procedure TImageListViewerProperties.SetImageListAnimateSpeed(const Value: Double);
begin
  if FImageListAnimateSpeed<>Value then
  begin
    FImageListAnimateSpeed := Value;
    if Self.FImageListAnimateTimer<>nil then
    begin
      Self.FImageListAnimateTimer.Interval:=Ceil(FImageListAnimateSpeed*10);
      Self.FImageListAnimateTimer.Enabled:=Self.FImageListAnimated;
    end;
  end;
end;

procedure TImageListViewerProperties.SetGestureSwitchLooped(const Value: Boolean);
begin
  FGestureSwitchLooped := Value;
end;

procedure TImageListViewerProperties.SetImageListSwitchingSpeed(const Value: Double);
begin
  if FImageListSwitchingSpeed<>Value then
  begin
    FImageListSwitchingSpeed := Value;
    if Self.FImageListSwitchingTimer<>nil then
    begin
      Self.FImageListSwitchingTimer.Interval:=Ceil(FImageListSwitchingSpeed*10);
    end;
  end;
end;

procedure TImageListViewerProperties.SetPicture(Value: TDrawPicture);
begin
  FPicture.Assign(Value);
end;

//procedure TImageListViewerProperties.SetRotated(const Value: Boolean);
//begin
//  if FRotated<>Value then
//  begin
//    FRotated := Value;
//    if FRotated then
//    begin
//      Self.CreateRotateTimer;
//      if Self.FRotateTimer<>nil then
//      begin
//        Self.FRotateTimer.Enabled:=True;
////        uDialogCommon.ShowDialog('True');
//      end;
//      //ShowException('SetRotated');
//    end
//    else
//    begin
////      uDialogCommon.ShowDialog('False');
//      if Self.FRotateTimer<>nil then
//      begin
//        Self.FRotateTimer.Enabled:=False;
//      end;
//    end;
//  end;
//end;

//procedure TImageListViewerProperties.SetRotateSpeed(const Value: Double);
//begin
//  if FRotateSpeed<>Value then
//  begin
//    FRotateSpeed := Value;
//    if Self.FRotateTimer<>nil then
//    begin
////      ShowDialog('SetRotateSpeed');
//      Self.FRotateTimer.Interval:=Ceil(FRotateSpeed*10);
//      Self.FRotateTimer.Enabled:=Self.FRotated;
//    end;
//  end;
//end;

procedure TImageListViewerProperties.StartZoomingToInitial;
begin

  //启动越界回滚到初始
  if (Self.FGestureZoomScale<Self.FMinGestureZoomScale)
    or (Self.FGestureZoomScale>Self.FMaxGestureZoomScale) then
  begin
    if Self.FGestureZoomScale>FMaxGestureZoomScale then
    begin
      //滚回边界
      FZoomingToInitialAnimator.Tag:=1;
      FZoomingToInitialAnimator.Min:=Ceil(FMaxGestureZoomScale*100);
      FZoomingToInitialAnimator.Max:=Ceil(FGestureZoomScale*100);
    end
    else if Self.FGestureZoomScale<FMinGestureZoomScale then
    begin
      //滚回边界
      FZoomingToInitialAnimator.Tag:=2;
      FZoomingToInitialAnimator.Min:=Ceil(FMinGestureZoomScale*100);
      FZoomingToInitialAnimator.Max:=Ceil(FGestureZoomScale*100);
    end;

    FZoomingToInitialAnimator.DirectionType:=TAnimateDirectionType.adtBackward;

    FZoomingToInitialAnimator.Start;
  end
  else
  begin


  end;
end;

procedure TImageListViewerProperties.SwitchNext;
var
  ABeginImageIndex:Integer;
  AAfterImageIndex:Integer;
begin
  //如果当前正在切换,那么不处理
  if Self.FImageListSwitching then Exit;


  //当前正在缩放
  if FIsGestureZooming then Exit;


  if FCanGestureSwitch then
  begin
    //当前正在拖动,那么也不处理
    if Self.FSkinControlIntf.IsMouseDown then Exit;
  end;


  if (Self.FPicture.SkinImageList<>nil)
    and (Self.FPicture.SkinImageList.Count>1) then
  begin

    //当前显示的图片下标
    ABeginImageIndex:=Self.FPicture.ImageIndex;
    //下一张显示的图片下标
    AAfterImageIndex:=ABeginImageIndex;
    case GetCurrentSwitchOrderType of
      ilaotAsc:
      begin
        //顺序
        AAfterImageIndex:=GetNextImageIndex(AAfterImageIndex);
      end;
      ilaotDesc:
      begin
        //倒序
        AAfterImageIndex:=GetPriorImageIndex(AAfterImageIndex);
      end;
    end;


    //当前的切换类型
    if FImageListSwitchEffectType<>TAnimateSwitchEffectType.ilasetNone then
    begin
      FCurrentImageListSwitchEffectType:=Self.FImageListSwitchEffectType;
    end;


    if (Self.FImageListAnimateOrderType<>TAnimateOrderType.ilaotNone)
      and (ABeginImageIndex<>AAfterImageIndex) then
    begin
      Self.SwitchPicture(ABeginImageIndex,AAfterImageIndex);
    end;

  end;
end;

procedure TImageListViewerProperties.SwitchPicture(ABeginImageIndex: Integer;AAfterImageIndex:Integer);
begin
  //判断参数是否合法
  if (Self.FPicture.SkinImageList<>nil)
    and (Self.FPicture.SkinImageList.Count>1)
    and (ABeginImageIndex<>AAfterImageIndex) then
  begin


//      //判断下一张是否有图片,或者图片有没有下载好
//      if (Self.FPicture.SkinImageList.PictureList[AAfterImageIndex].CurrentPicture=nil)
//        or Self.FPicture.SkinImageList.PictureList[AAfterImageIndex].CurrentPicture.IsEmpty then
//      begin
//        uBaseLog.OutputDebugString('TImageListViewerProperties.SwitchPicture AAfterImageIndex Is No Picture,Waiting');
//        Exit;
//      end;


      //图片切换开始
      if Assigned(Self.FSkinImageListViewerIntf.OnImageListSwitchBegin) then
      begin
        Self.FSkinImageListViewerIntf.OnImageListSwitchBegin(Self,
                        ABeginImageIndex,
                        AAfterImageIndex
                        );
      end;


      //当前显示的图片下标
      FCurrentSwitchBeforeImageIndex:=ABeginImageIndex;
      //下一个显示的图片下标
      FCurrentSwitchAfterImageIndex:=AAfterImageIndex;



      case FImageListAnimateOrderType of
        ilaotNone: ;
        ilaotAsc:
        begin
          //判断切换方向
          if (FCurrentSwitchBeforeImageIndex<FCurrentSwitchAfterImageIndex)
            or
              //顺序,当前是第一张图片,切换到最后一张
              (FCurrentSwitchBeforeImageIndex=Self.FPicture.SkinImageList.Count-1) and (FCurrentSwitchAfterImageIndex=0)
               then
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;
          end
          else
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;
          end;
        end;
        ilaotDesc:
        begin
          //判断切换方向
          if (FCurrentSwitchBeforeImageIndex<FCurrentSwitchAfterImageIndex)
            and
            not ((FCurrentSwitchBeforeImageIndex=0) and (FCurrentSwitchAfterImageIndex=Self.FPicture.SkinImageList.Count-1)) then
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;
          end
          else
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;
          end;
        end;
      end;




      //开始切换
      Self.SetImageListSwitching(True);

  end;

end;

procedure TImageListViewerProperties.SwitchPrior;
var
  ABeginImageIndex:Integer;
  AAfterImageIndex:Integer;
begin
  //如果当前正在切换,那么不处理
  if Self.FImageListSwitching then Exit;
  if FIsGestureZooming then Exit;


  if FCanGestureSwitch then
  begin
    //当前正在拖动,那么也不处理
    if Self.FSkinControlIntf.IsMouseDown then Exit;
  end;


  if (Self.FPicture.SkinImageList<>nil)
    and (Self.FPicture.SkinImageList.Count>1) then
  begin

    //当前显示的图片下标
    ABeginImageIndex:=Self.FPicture.ImageIndex;
    //下一张显示的图片下标
    AAfterImageIndex:=ABeginImageIndex;
    case GetCurrentSwitchOrderType of
      ilaotAsc:
      begin
        //顺序
        AAfterImageIndex:=GetPriorImageIndex(AAfterImageIndex);
      end;
      ilaotDesc:
      begin
        //倒序
        AAfterImageIndex:=GetNextImageIndex(AAfterImageIndex);
      end;
    end;


    if FImageListSwitchEffectType<>TAnimateSwitchEffectType.ilasetNone then
    begin
      FCurrentImageListSwitchEffectType:=Self.FImageListSwitchEffectType;
    end;


    if (Self.FImageListAnimateOrderType<>TAnimateOrderType.ilaotNone)
      and (ABeginImageIndex<>AAfterImageIndex) then
    begin
      Self.SwitchPicture(ABeginImageIndex,AAfterImageIndex);
    end;

  end;
end;

//procedure TImageListViewerProperties.FreeSwitchButtons;
//begin
//  if (Self.FSkinImageListViewerIntf.GetSwitchButtonGroup<>nil) then
//  begin
//    Self.FSkinImageListViewerIntf.GetSwitchButtonGroupIntf.FreeChildButtons;
//  end;
//end;

procedure TImageListViewerProperties.AdjustScrollBarRangeByPicture;
var
  AHorzScrollBarMax:TControlSize;
  AVertScrollBarMax:TControlSize;
var
  ADrawRect:TRectF;
//  AImageWidth:Integer;
//  AImageHeight:Integer;
//  AImageDrawWidth:Integer;
//  AImageDrawHeight:Integer;
//  AImageDrawMaxWidth:Integer;
//  AImageDrawMaxHeight:Integer;
  AImageDrawRect:TRectF;
//  AImageDrawRectZoomScale:Double;
begin

  //当前的绘制矩形



  //看一下图片的绘制矩形
  if Self.FSkinControlIntf.GetSkinControlType<>nil then
  begin


    //计算出图片绘制的矩形
    ADrawRect:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    AImageDrawRect:=TSkinImageListViewerType(Self.FSkinControlIntf.GetSkinControlType)
        .CalcPictureDrawRect(uSkinBufferBitmap.GetGlobalAutoSizeBufferBitmap.DrawCanvas,
                              Self.FPicture,
                              ADrawRect);


    //计算出绘制大小
    Self.FContentWidth:=ControlSize(RectWidthF(AImageDrawRect));
    Self.FContentHeight:=ControlSize(RectHeightF(AImageDrawRect));
    AHorzScrollBarMax:=ControlSize(RectWidthF(AImageDrawRect)-Self.FSkinControlIntf.Width);
    AVertScrollBarMax:=ControlSize(RectHeightF(AImageDrawRect)-Self.FSkinControlIntf.Height);



    if AHorzScrollBarMax<0 then
    begin
      AHorzScrollBarMax:=0;
    end;
    if AVertScrollBarMax<0 then
    begin
      AVertScrollBarMax:=0;
    end;

  end;



  Self.FSkinScrollControlIntf.Prop.HorzControlGestureManager.MinOverRangePosValue:=0;
  Self.FSkinScrollControlIntf.Prop.HorzControlGestureManager.MaxOverRangePosValue:=0;
  Self.FSkinScrollControlIntf.Prop.HorzControlGestureManager.Max:=AHorzScrollBarMax;

  Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.MinOverRangePosValue:=0;
  Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.MaxOverRangePosValue:=0;
  Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Max:=AVertScrollBarMax;


end;

procedure TImageListViewerProperties.AlignSwitchButtons;
begin
  if (Self.FSkinImageListViewerIntf.GetSwitchButtonGroup<>nil)
    and (Self.FPicture.SkinImageList<>nil) then
  begin


    Self.FSkinImageListViewerIntf.GetSwitchButtonGroupIntf.FixChildButtonCount(
                                  Self.Picture.SkinImageList.Count,
                                  Self.Picture.ImageIndex,
                                  DoImageListSwitchButtonClick);

  end;
end;

procedure TImageListViewerProperties.DoPictureChanged(Sender: TObject);
begin

  //自动计算控件的大小
  Self.AdjustAutoSizeBounds;

  //排列图片列表切换按钮
  Self.AlignSwitchButtons;


  Inherited;
end;

function TImageListViewerProperties.GetCurrentAfterPictureImageIndex: Integer;
begin
  Result:=-1;
  if Self.FPicture.SkinImageList=nil then Exit;

  case Self.GetCurrentSwitchOrderType of
    ilaotAsc:
    begin
      Result:=GetNextImageIndex(Self.FPicture.ImageIndex);
    end;
    ilaotDesc:
    begin
      Result:=GetPriorImageIndex(Self.FPicture.ImageIndex);
    end;
  end;
end;

function TImageListViewerProperties.GetCurrentAfterSkinPicture: TDrawPicture;
begin
  Result:=nil;
  if Self.FPicture.SkinImageList=nil then Exit;
  if (Self.GetCurrentAfterPictureImageIndex>-1)
      and (GetCurrentAfterPictureImageIndex<Self.FPicture.SkinImageList.PictureList.Count) then
  begin
    Result:=Self.FPicture.SkinImageList.PictureList[GetCurrentAfterPictureImageIndex];
  end;
end;

function TImageListViewerProperties.GetCurrentBeforePictureImageIndex: Integer;
begin
  Result:=-1;
  if Self.FCurrentSwitchBeforeImageIndex<>-1 then
  begin
      Result:=Self.FCurrentSwitchBeforeImageIndex;
  end
  else
  begin
      case Self.GetCurrentImageListSwitchEffectType of
        ilasetNone: ;
        ilasetMoveHorz,ilasetMoveVert:
        begin
          case Self.GetCurrentSwitchOrderType of
            ilaotAsc:
            begin
              Result:=Self.FPicture.ImageIndex;
            end;
            ilaotDesc:
            begin
              Result:=Self.FPicture.ImageIndex;
            end;
          end;
        end;
      end;
  end;


end;

function TImageListViewerProperties.GetCurrentBeforeSkinPicture: TDrawPicture;
begin
  Result:=nil;
  if (Self.FPicture.SkinImageList<>nil) then
  begin
    if (Self.GetCurrentBeforePictureImageIndex>-1)
      and (GetCurrentBeforePictureImageIndex<Self.FPicture.SkinImageList.PictureList.Count) then
    begin
      Result:=Self.FPicture.SkinImageList.PictureList[GetCurrentBeforePictureImageIndex];
    end;
  end
  else
  begin
    Result:=Self.FPicture;
  end;
end;

function TImageListViewerProperties.GetCurrentCanGestureControlGestureManager: TSkinControlGestureManager;
begin
  //水平滚动条是否是当前可以切换的滚动条
  if GetCurrentCanGestureScrollBarKind=sbHorizontal then
  begin
    Result:=Self.FSkinScrollControlIntf.Prop.HorzControlGestureManager;
  end
  else
  begin
    Result:=Self.FSkinScrollControlIntf.Prop.VertControlGestureManager;
  end;
end;

function TImageListViewerProperties.GetCurrentCanGestureScrollBarKind: TScrollBarKind;
begin
  Result:=TScrollBarKind.sbHorizontal;
  case Self.GetCurrentImageListSwitchEffectType of
    TAnimateSwitchEffectType.ilasetMoveVert:
    begin
      Result:=TScrollBarKind.sbVertical;
    end;
  end;
end;

function TImageListViewerProperties.GetCurrentImageListSwitchEffectType: TAnimateSwitchEffectType;
begin
  Result:=Self.FCurrentImageListSwitchEffectType;
end;

function TImageListViewerProperties.GetCurrentSwitchOrderType: TAnimateOrderType;
begin
  Result:=ilaotNone;
  if Self.FCurrentSwitchOrderType<>ilaotNone then
  begin
    Result:=FCurrentSwitchOrderType;
  end
  else
  begin
    Result:=Self.FImageListAnimateOrderType;
  end;
end;

function TImageListViewerProperties.GetComponentClassify: String;
begin
  Result:='SkinImageListViewer';
end;

function TImageListViewerProperties.GetImageListSwitchingProgressMaxSize: Double;
begin
  Result:=100;
  case GetCurrentImageListSwitchEffectType of
    ilasetNone: ;
    ilasetMoveHorz:
    begin
      Result:=Self.FSkinControlIntf.Width;
    end;
    ilasetMoveVert:
    begin
      Result:=Self.FSkinControlIntf.Height;
    end;
  end;
end;

function TImageListViewerProperties.GetNextImageIndex(AImageIndex: Integer): Integer;
begin
  if Self.FPicture.SkinImageList<>nil then
  begin
    if (AImageIndex+1>Self.FPicture.SkinImageList.Count-1) then
    begin
      if Self.FIsGestureSwitching and (not Self.FGestureSwitchLooped) then
      begin
        Result:=-1;
      end
      else
      begin
        Result:=0;
      end;
    end
    else
    begin
      Result:=AImageIndex+1;
    end;
  end
  else
  begin
    Result:=-1;
  end;
end;

function TImageListViewerProperties.GetPriorImageIndex(AImageIndex: Integer): Integer;
begin
  if Self.FPicture.SkinImageList<>nil then
  begin
    if (AImageIndex-1<0) then
    begin
      if Self.FIsGestureSwitching and (not Self.FGestureSwitchLooped) then
      begin
        Result:=-1;
      end
      else
      begin
        Result:=Self.FPicture.SkinImageList.Count-1;
      end;
    end
    else
    begin
      Result:=AImageIndex-1;
    end;
  end
  else
  begin
    Result:=-1;
  end;
end;

procedure TImageListViewerProperties.InitScrollBarOverrangePosValue;
begin
  if Self.FIsFirstUserDrag then
  begin
    Self.InitScrollBars;
  end;

  if Self.FIsFirstUserDrag and (Self.FImageListSwitchingProgress>0) then
  begin
    FIsFirstUserDrag:=False;
    case GetCurrentImageListSwitchEffectType of
      ilasetNone: ;
      ilasetMoveHorz,ilasetMoveVert:
      begin
        case Self.FImageListAnimateOrderType of
          ilaotNone: ;
          ilaotAsc:
          begin
            Self.GetCurrentCanGestureControlGestureManager.MaxOverRangePosValue:=FImageListSwitchingProgress;
          end;
          ilaotDesc:
          begin
            Self.GetCurrentCanGestureControlGestureManager.MinOverRangePosValue:=FImageListSwitchingProgress;
          end;
        end;
      end;
    end;
  end;

end;

procedure TImageListViewerProperties.InitScrollBars;
begin

  case FImageListSwitchEffectType of
    ilasetNone:
    begin
      if Self.FVertControlGestureManager.Max>0 then
      begin
        Self.FVertControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
      end
      else
      begin
        Self.FVertControlGestureManager.CanOverRangeTypes:=[];
      end;
      Self.FHorzControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
    end;
    ilasetMoveHorz:
    begin
      if Self.FVertControlGestureManager.Max>0 then
      begin
        Self.FVertControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
      end
      else
      begin
        Self.FVertControlGestureManager.CanOverRangeTypes:=[];
      end;
      Self.FHorzControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
    end;
    ilasetMoveVert:
    begin
      Self.FVertControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
      if Self.FHorzControlGestureManager.Max>0 then
      begin
        Self.FHorzControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
      end
      else
      begin
        Self.FHorzControlGestureManager.CanOverRangeTypes:=[];
      end;
    end;
  end;



  //根据图片调整滚动条的边界
  AdjustScrollBarRangeByPicture;


end;

procedure TImageListViewerProperties.DoImageListSwitchButtonClick(Sender: TObject);
begin
  //图标列表切换按钮按下
  Self.SwitchPicture(
                      //当前图片的下标
                      Self.FPicture.ImageIndex,
                      //点击按钮的下标
                      ((Sender as TChildControl) as ISkinButton).Properties.ButtonIndex
                    );
end;

procedure TImageListViewerProperties.DoImageListSwitchEnd;
begin
  Self.AlignSwitchButtons;


//  //如果是GIF图片那就启动
//  //如果是GIF,则播放GIF
//  if Self.Animated then
//  begin
//    if FPicture.CurrentPictureIsGIF then
//    begin
//      if Self.FPicture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
//      begin
//        TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).StartAnimate;
//      end;
//    end
//    else
//    begin
//      if Self.FPicture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
//      begin
//        TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).StopAnimate;
//      end;
//    end;
//  end;


  //移动的进度为0
  Self.FImageListSwitchingProgress:=0;
  Self.FCurrentSwitchBeforeImageIndex:=-1;
  Self.FCurrentSwitchAfterImageIndex:=-1;
  //初始的缩放比例
  Self.FGestureZoomScale:=1;
  Self.SetGestureZoomScale(1);

  Self.GetCurrentCanGestureControlGestureManager.MinOverRangePosValue:=0;
  Self.GetCurrentCanGestureControlGestureManager.MaxOverRangePosValue:=0;

  Self.InitScrollBars;

  Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotNone;

  //图片切换结构
  if Assigned(Self.FSkinImageListViewerIntf.OnImageListSwitchEnd) then
  begin
    Self.FSkinImageListViewerIntf.OnImageListSwitchEnd(Self);
  end;


end;


{ TSkinImageListViewer }

constructor TSkinImageListViewer.Create(AOwner:TComponent);
begin
  inherited;
  {$IFDEF FMX}
  Touch.DefaultInteractiveGestures := Touch.DefaultInteractiveGestures
    + [TInteractiveGesture.{$IF CompilerVersion >= 35.0}Zoom{$ELSE}igZoom{$IFEND}]
    + [TInteractiveGesture.{$IF CompilerVersion >= 35.0}Rotate{$ELSE}igRotate{$IFEND}]

    ;
  Touch.InteractiveGestures := Touch.InteractiveGestures
    + [TInteractiveGesture.{$IF CompilerVersion >= 35.0}Zoom{$ELSE}igZoom{$IFEND}]
    + [TInteractiveGesture.{$IF CompilerVersion >= 35.0}Rotate{$ELSE}igRotate{$IFEND}]

    ;
  {$ENDIF}

end;
function TSkinImageListViewer.Material:TSkinImageListViewerDefaultMaterial;
begin
  Result:=TSkinImageListViewerDefaultMaterial(SelfOwnMaterial);
end;

function TSkinImageListViewer.SelfOwnMaterialToDefault:TSkinImageListViewerDefaultMaterial;
begin
  Result:=TSkinImageListViewerDefaultMaterial(SelfOwnMaterial);
end;

function TSkinImageListViewer.CurrentUseMaterialToDefault:TSkinImageListViewerDefaultMaterial;
begin
  Result:=TSkinImageListViewerDefaultMaterial(CurrentUseMaterial);
end;

function TSkinImageListViewer.GetOnImageListSwitchEnd:TNotifyEvent;
begin
  Result:=FOnImageListSwitchEnd;
end;

function TSkinImageListViewer.GetOnImageListSwitchBegin:TSwitchBeginNotifyEvent;
begin
  Result:=FOnImageListSwitchBegin;
end;

function TSkinImageListViewer.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TImageListViewerProperties;
end;

function TSkinImageListViewer.GetImageListViewerProperties: TImageListViewerProperties;
begin
  Result:=TImageListViewerProperties(Self.FProperties);
end;

procedure TSkinImageListViewer.SetImageListViewerProperties(Value: TImageListViewerProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinImageListViewer.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetImageListViewerProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TSkinImageListViewer.Loaded;
begin
  Inherited;
  if Self.GetImageListViewerProperties.Animated then
  begin
    if Self.GetImageListViewerProperties.Picture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
    begin
      TSkinBaseGIFPictureEngine(Self.GetImageListViewerProperties.Picture.SkinPictureEngine).StartAnimate;
    end;
  end;
  //创建图片列表下标按钮
  Properties.AlignSwitchButtons;
end;

function TSkinImageListViewer.GetSwitchButtonGroupIntf:ISkinButtonGroup;
begin
  Result:=FSwitchButtonGroupIntf;
end;

function TSkinImageListViewer.GetSwitchButtonGroup: TSkinBaseButtonGroup;
begin
  Result:=Self.FSwitchButtonGroup;
end;

procedure TSkinImageListViewer.SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
begin
  if FSwitchButtonGroup<>Value then
  begin
      //将原Style释放或解除绑定
      if FSwitchButtonGroup<>nil then
      begin
          uComponentType.RemoveFreeNotification(FSwitchButtonGroup,Self);
          if (FSwitchButtonGroup.Owner=Self) then
          begin
            //释放自己创建的
    //        Properties.FreeSwitchButtons;
            FreeAndNil(FSwitchButtonGroup);
          end
          else
          begin
            //解除别人的
            FSwitchButtonGroup:=nil;
            FSwitchButtonGroupIntf:=nil;
          end;
      end;


      FSwitchButtonGroup:=Value;


      if Value<>nil then
      begin
          AddFreeNotification(FSwitchButtonGroup,Self);
          FSwitchButtonGroupIntf:=FSwitchButtonGroup as ISkinButtonGroup;

          //创建图片列表下标按钮
          Properties.AlignSwitchButtons;

      end;
  end;
end;

procedure TSkinImageListViewer.Notification(AComponent: TComponent;Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (AComponent=Self.FSwitchButtonGroup) then
    begin
      SetSwitchButtonGroup(nil);
    end;
  end;
end;



end.



