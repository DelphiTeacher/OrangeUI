//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     滚动条
///   </para>
///   <para>
///     ScrollBar
///   </para>
/// </summary>
unit uSkinScrollBarType;

interface
{$I FrameWork.inc}

uses
  Classes,
  Math,
  DateUtils,
  SysUtils,
  uFuncCommon,
  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  uSkinWindowsControl,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Types,
  UITypes,
  FMX.Forms,
  FMX.Controls,
  uSkinFireMonkeyControl,
  {$ENDIF}
  Types,

  uGraphicCommon,
  uDrawParam,
  uBaseLog,
  uBaseSkinControl,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uSkinMaterial,
  uDrawEngine,
  uSkinAnimator,
  uDrawPicture,
  uDrawTextParam,
  uDrawRectParam,
  uSkinPullLoadPanelType,
  uSkinControlGestureManager,
  uDrawPictureParam;



const
  IID_ISkinScrollBar:TGUID='{61BC29DF-7B01-4F9A-A491-5C0758E0AE23}';

type
  TScrollBarProperties=class;







  //滚动条的按钮状态
  TScrollBarBtnState=class
  public
    MouseDown:Boolean;
    MouseHover:Boolean;
    MouseDownPt:TPointF;
    MouseDownOffset:Double;
  end;






  /// <summary>
  ///   <para>
  ///     滚动条接口
  ///   </para>
  ///   <para>
  ///     Interface of ScrollBar
  ///   </para>
  /// </summary>
  ISkinScrollBar=interface//(ISkinControl)
  ['{61BC29DF-7B01-4F9A-A491-5C0758E0AE23}']

    //位置更改事件
    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);

    procedure SetOnInvalidateScrollControl(const Value: TNotifyEvent);
    function GetOnInvalidateScrollControl: TNotifyEvent;

    property OnChange: TNotifyEvent read GetOnChange write SetOnChange;
    property OnInvalidateScrollControl: TNotifyEvent read GetOnInvalidateScrollControl write SetOnInvalidateScrollControl;

    function GetScrollBarProperties:TScrollBarProperties;
    property Properties:TScrollBarProperties read GetScrollBarProperties;
    property Prop:TScrollBarProperties read GetScrollBarProperties;
  end;





  /// <summary>
  ///   <para>
  ///     滚动条属性
  ///   </para>
  ///   <para>
  ///     Scrollbar property
  ///   </para>
  /// </summary>
  TScrollBarProperties=class(TSkinControlProperties)
  ///////////////接口实现///////////////
  protected
    //滚动条的类型
    FKind:TScrollBarKind;



    //各个按钮的状态
    FMinBtnState:TScrollBarBtnState;
    FMaxBtnState:TScrollBarBtnState;
    FMinSpaceState:TScrollBarBtnState;
    FMaxSpaceState:TScrollBarBtnState;
    FThumbBtnState:TScrollBarBtnState;



    FSkinScrollBarIntf:ISkinScrollBar;


    function GetKind: TScrollBarKind;
    procedure SetKind(const Value: TScrollBarKind);

    function GetMax: Double;
    procedure SetMax(const Value: Double);
    function GetMin: Double;
    procedure SetMin(const Value: Double);
    function GetPosition: Double;
    procedure SetPosition(const Value: Double);


    function GetPageSize: Double;
    procedure SetPageSize(const Value: Double);

    function GetLargeChange: Integer;
    procedure SetLargeChange(const Value: Integer);
    function GetSmallChange: Integer;
    procedure SetSmallChange(const Value: Integer);
//    procedure SetKeyPressChange(const Value: Integer);



    //从FControlGestureManager获取MinPullLoadPanel
    function GetMinPullLoadPanel:TChildControl;
    //从FControlGestureManager获取MaxPullLoadPanel
    function GetMaxPullLoadPanel:TChildControl;
    //设置下拉加载面板
    procedure SetMinPullLoadPanel(const Value: TChildControl);
    //设置上拉加载面板
    procedure SetMaxPullLoadPanel(const Value: TChildControl);


    //滚动条可以越界的类型
    function GetCanOverRangeTypes: TCanOverRangeTypes;
    procedure SetCanOverRangeTypes(const Value: TCanOverRangeTypes);

  protected

    //鼠标手势动态管理
    FControlGestureManager:TSkinControlGestureManager;


    //判断用户是否停止了滚动
    procedure DoControlGestureManagerDragingStateChange(Sender:TObject);

    //控件手势管理者位置更改,相应更改滚动条的位置
    procedure DoControlGestureManagerPositionChange(Sender:TObject);



  protected


    //是否寄生在滚动控件里
    FIsInScrollControl:Boolean;


    //当前是否可以自动隐藏滚动条了
    FIsCanAutoHide:Boolean;


    //自动隐藏计时器
    FAutoHideTimer:TTimer;


    //鼠标按钮停靠的计时器(用来鼠标一直按下的时候继续滚动)
    FMouseDownStayTimer:TTimer;





    //是否可以自动隐藏
    procedure SetIsCanAutoHide(const Value: Boolean);


    //自动隐藏计时器
    procedure CreateAutoHideTimer;
    procedure OnAutoHideTimer(Sender:TObject);


    //鼠标按下空白区域实现滚动
    procedure CreateMouseDownStayTimer;
    procedure OnMouseDownStayTimer(Sender:TObject);
  public
    //距离
    function CalcDistance:Double;


    //向上按钮状态
    property MinBtnState:TScrollBarBtnState read FMinBtnState write FMinBtnState;
    //向下按钮状态
    property MaxBtnState:TScrollBarBtnState read FMaxBtnState write FMaxBtnState;
    //向上空间状态
    property MinSpaceState:TScrollBarBtnState read FMinSpaceState write FMinSpaceState;
    //向下空间状态
    property MaxSpaceState:TScrollBarBtnState read FMaxSpaceState write FMaxSpaceState;
    //滚动滑块状态
    property ThumbBtnState:TScrollBarBtnState read FThumbBtnState write FThumbBtnState;


  protected
    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public

    //滚动滑块的大小
    property PageSize:Double read GetPageSize write SetPageSize;


    //滚动条的越界值
    function GetMinOverRangePosValue:Double;
    function GetMaxOverRangePosValue:Double;

//    //按键移动的距离
//    property KeyPressChange:Integer read FKeyPressChange write SetKeyPressChange ;//default 10;

    /// <summary>
    ///   <para>
    ///     当前是否可以隐藏滚动条
    ///   </para>
    ///   <para>
    ///     Whether can hide ScrollBar currently
    ///   </para>
    /// </summary>
    property IsCanAutoHide:Boolean read FIsCanAutoHide write SetIsCanAutoHide;

    /// <summary>
    ///   <para>
    ///     是否寄生在别的控件里
    ///   </para>
    ///   <para>
    ///     Whether parasitic in other controls
    ///   </para>
    /// </summary>
    property IsInScrollControl:Boolean read FIsInScrollControl write FIsInScrollControl;


    //手势管理者
    property ControlGestureManager:TSkinControlGestureManager read FControlGestureManager;


    procedure SetControlGestureManager(AControlGestureManager:TSkinControlGestureManager);
  published
    //
    /// <summary>
    ///   <para>
    ///     自动大小
    ///   </para>
    ///   <para>
    ///     Autosize
    ///   </para>
    /// </summary>
    property AutoSize;

    //
    /// <summary>
    ///   <para>
    ///     滚动条类型
    ///   </para>
    ///   <para>
    ///     ScrollBar Type
    ///   </para>
    /// </summary>
    property Kind: TScrollBarKind read GetKind write SetKind;


    /// <summary>
    ///   <para>
    ///     最小值
    ///   </para>
    ///   <para>
    ///     Min
    ///   </para>
    /// </summary>
    property Min: Double read GetMin write SetMin;


    /// <summary>
    ///   <para>
    ///     最大值
    ///   </para>
    ///   <para>
    ///     Max
    ///   </para>
    /// </summary>
    property Max: Double read GetMax write SetMax;


    /// <summary>
    ///   <para>
    ///     位置
    ///   </para>
    ///   <para>
    ///     Position
    ///   </para>
    /// </summary>
    property Position: Double read GetPosition write SetPosition;



    //点击按钮时的位置更改增量
    property SmallChange:Integer read GetSmallChange write SetSmallChange;
    //鼠标滚动时的位置更改增量
    property LargeChange:Integer read GetLargeChange write SetLargeChange;


    /// <summary>
    ///   <para>
    ///     允许越界的类型(最小值越界,或最大值越界)
    ///   </para>
    ///   <para>
    ///     Type of over range(cross border at min,or cross border at max)
    ///   </para>
    /// </summary>
    property CanOverRangeTypes:TCanOverRangeTypes read GetCanOverRangeTypes write SetCanOverRangeTypes;

    /// <summary>
    ///   <para>
    ///     下拉加载面板
    ///   </para>
    ///   <para>
    ///     Pulldown load panel
    ///   </para>
    /// </summary>
    property MinPullLoadPanel:TChildControl read GetMinPullLoadPanel write SetMinPullLoadPanel;

    /// <summary>
    ///   <para>
    ///     上拉加载面板
    ///   </para>
    ///   <para>
    ///     Pullup load panel
    ///   </para>
    /// </summary>
    property MaxPullLoadPanel:TChildControl read GetMaxPullLoadPanel write SetMaxPullLoadPanel;
  end;













  /// <summary>
  ///   <para>
  ///     滚动条素材基类
  ///   </para>
  ///   <para>
  ///     Base class of ScrollBar material
  ///   </para>
  /// </summary>
  TSkinScrollBarMaterial=class(TSkinControlMaterial)
  end;
  TSkinScrollBarType=class(TSkinControlType)
  protected
    FMouseMovePt:TPointF;
    FSkinScrollBarIntf:ISkinScrollBar;
  protected

    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;
    function CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;override;
    procedure SizeChanged;override;

//    procedure KeyDown(Key: Word; Shift: TShiftState);override;
//    procedure KeyUp(Key: Word; Shift: TShiftState);override;


    //滚动条客户区尺寸
    function GetScrollBarClientSize:Double;
    //滚动滑块大小
    function GetScrollBarPageSize:Double;


    //获取减小增大按钮绘制大小
    function GetMinMaxBtnDrawSize:Double;virtual;
    function GetMinMaxBtnSize:Double;virtual;
    //滚动滑块绘制大小
    function GetThumbBtnDrawSize:Double;virtual;

    //滚动滑块绘制坐标
    function GetThumbBtnDrawPos:Double;
    function GetThumbBtnDrawPosOffset:Double;
    //滚动滑块绘制系数
    function GetThumbBtnDrawStep:Double;
    //滚动滑块位置绘制系数
    function GetThumbPosDrawStep:Double;


    //获取向上箭头矩形
    function GetMinBtnRect:TRectF;
    //获取向下箭头矩形
    function GetMaxBtnRect:TRectF;
    //获取滚动按钮矩形
    function GetThumbBtnDrawRect:TRectF;

    //向上空白区域矩形
    function GetMinSpaceRect:TRectF;
    //向下空白区域矩形
    function GetMaxSpaceRect:TRectF;


  protected
    //重绘控件
    procedure Invalidate;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  public
    property SkinScrollBarIntf:ISkinScrollBar read FSkinScrollBarIntf;
  end;










  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     滚动条手机端素材
  ///   </para>
  ///   <para>
  ///     ScrollBar mobile material
  ///   </para>
  /// </summary>
  TSkinScrollBarMobileMaterial=class(TSkinScrollBarMaterial)
  protected
    //滚动滑块大小
    FThumbBtnDrawSize: Integer;
    //滚动滑块最小大小
    FThumbBtnMinSize: Integer;
    //是否默认绘制滚动滑块
    FIsDefaultDrawThumbBtn:Boolean;
    //绘制按钮绘制参数
    FThumbBtnRectParam: TDrawRectParam;

    procedure SetThumbBtnMinSize(const Value: Integer);
    procedure SetThumbBtnRectParam(const Value: TDrawRectParam);
    procedure SetThumbBtnDrawSize(const Value: Integer);
    procedure SetIsDefaultDrawThumbBtn(const Value: Boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    /// <summary>
    ///   <para>
    ///     滚动滑块按钮最小大小
    ///   </para>
    ///   <para>
    ///     Min size of scroll button
    ///   </para>
    /// </summary>
    property ThumbBtnMinSize:Integer read FThumbBtnMinSize write SetThumbBtnMinSize;

    /// <summary>
    ///   <para>
    ///     滚动滑块绘制大小
    ///   </para>
    ///   <para>
    ///     Draw size of scroll button
    ///   </para>
    /// </summary>
    property ThumbBtnDrawSize:Integer read FThumbBtnDrawSize write SetThumbBtnDrawSize;

    /// <summary>
    ///   <para>
    ///     是否默认绘制滚动滑块
    ///   </para>
    ///   <para>
    ///     Whether draw scroll button defaultly
    ///   </para>
    /// </summary>
    property IsDefaultDrawThumbBtn:Boolean read FIsDefaultDrawThumbBtn write SetIsDefaultDrawThumbBtn;

    /// <summary>
    ///   <para>
    ///     滚动滑块按钮绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of scroll button
    ///   </para>
    /// </summary>
    property ThumbBtnRectParam: TDrawRectParam read FThumbBtnRectParam write SetThumbBtnRectParam;
  end;

  TSkinScrollBarMobileType=class(TSkinScrollBarType)
  private
    function GetSkinMaterial: TSkinScrollBarMobileMaterial;
  protected

    //获取减小增大按钮绘制大小
    function GetMinMaxBtnDrawSize:Double;override;
    function GetMinMaxBtnSize:Double;override;
    //滚动滑块绘制大小
    function GetThumbBtnDrawSize:Double;override;

    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;











  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollBarDefaultMaterial=class(TSkinScrollBarMobileMaterial);
  TSkinScrollBarDefaultType=class(TSkinScrollBarMobileType);











  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollBarDesktopMaterial=class(TSkinScrollBarMaterial)
  protected
    FMinMaxBtnSize: Integer;
    FMinMaxBtnDrawSize: Integer;
    FThumbBtnDrawSize: Integer;

    FThumbBtnMinSize: Integer;

    FHorzMinBtnNormalPicture: TDrawPicture;
    FHorzMinBtnHoverPicture: TDrawPicture;
    FHorzMinBtnDownPicture: TDrawPicture;
    FHorzMinBtnDisabledPicture: TDrawPicture;

    FHorzMaxBtnHoverPicture: TDrawPicture;
    FHorzMaxBtnDownPicture: TDrawPicture;
    FHorzMaxBtnDisabledPicture: TDrawPicture;
    FHorzMaxBtnNormalPicture: TDrawPicture;

    FHorzThumbBtnNormalPicture: TDrawPicture;
    FHorzThumbBtnHoverPicture: TDrawPicture;
    FHorzThumbBtnDownPicture: TDrawPicture;
    FHorzThumbBtnDisabledPicture: TDrawPicture;




    FVertMinBtnNormalPicture: TDrawPicture;
    FVertMinBtnHoverPicture: TDrawPicture;
    FVertMinBtnDownPicture: TDrawPicture;
    FVertMinBtnDisabledPicture: TDrawPicture;

    FVertMaxBtnNormalPicture: TDrawPicture;
    FVertMaxBtnHoverPicture: TDrawPicture;
    FVertMaxBtnDownPicture: TDrawPicture;
    FVertMaxBtnDisabledPicture: TDrawPicture;

    FVertThumbBtnNormalPicture: TDrawPicture;
    FVertThumbBtnHoverPicture: TDrawPicture;
    FVertThumbBtnDownPicture: TDrawPicture;
    FVertThumbBtnDisabledPicture: TDrawPicture;

    FHorzBackGndPicture: TDrawPicture;
    FVertBackGndPicture: TDrawPicture;




    FBackGndPictureParam: TDrawPictureParam;
    FMinMaxBtnPictureParam: TDrawPictureParam;
    FThumbBtnPictureParam: TDrawPictureParam;

    procedure SetHorzBackGndPicture(const Value: TDrawPicture);
    procedure SetVertBackGndPicture(const Value: TDrawPicture);


    procedure SetHorzMinBtnNormalPicture(const Value: TDrawPicture);
    procedure SetHorzMinBtnDownPicture(const Value: TDrawPicture);
    procedure SetHorzMinBtnHoverPicture(const Value: TDrawPicture);
    procedure SetHorzMinBtnDisabledPicture(const Value: TDrawPicture);


    procedure SetVertMinBtnNormalPicture(const Value: TDrawPicture);
    procedure SetVertMinBtnDownPicture(const Value: TDrawPicture);
    procedure SetVertMinBtnHoverPicture(const Value: TDrawPicture);
    procedure SetVertMinBtnDisabledPicture(const Value: TDrawPicture);


    procedure SetVertMaxBtnNormalPicture(const Value: TDrawPicture);
    procedure SetVertMaxBtnDownPicture(const Value: TDrawPicture);
    procedure SetVertMaxBtnHoverPicture(const Value: TDrawPicture);
    procedure SetVertMaxBtnDisabledPicture(const Value: TDrawPicture);


    procedure SetHorzMaxBtnNormalPicture(const Value: TDrawPicture);
    procedure SetHorzMaxBtnDownPicture(const Value: TDrawPicture);
    procedure SetHorzMaxBtnHoverPicture(const Value: TDrawPicture);
    procedure SetHorzMaxBtnDisabledPicture(const Value: TDrawPicture);


    procedure SetVertThumbBtnNormalPicture(const Value: TDrawPicture);
    procedure SetVertThumbBtnDownPicture(const Value: TDrawPicture);
    procedure SetVertThumbBtnHoverPicture(const Value: TDrawPicture);
    procedure SetVertThumbBtnDisabledPicture(const Value: TDrawPicture);

    procedure SetHorzThumbBtnNormalPicture(const Value: TDrawPicture);
    procedure SetHorzThumbBtnDownPicture(const Value: TDrawPicture);
    procedure SetHorzThumbBtnHoverPicture(const Value: TDrawPicture);
    procedure SetHorzThumbBtnDisabledPicture(const Value: TDrawPicture);


    procedure SetMinMaxBtnDrawSize(const Value: Integer);
    procedure SetMinMaxBtnSize(const Value: Integer);
    procedure SetThumbBtnMinSize(const Value: Integer);

    procedure SetBackGndPictureParam(const Value: TDrawPictureParam);
    procedure SetMinMaxBtnPictureParam(const Value: TDrawPictureParam);
    procedure SetThumbBtnPictureParam(const Value: TDrawPictureParam);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published

    //增大减小按钮绘制大小
    property MinMaxBtnDrawSize:Integer read FMinMaxBtnDrawSize write SetMinMaxBtnDrawSize stored false;
    property MinMaxBtnSize:Integer read FMinMaxBtnSize write SetMinMaxBtnSize stored false;


    //滚动滑块按钮最小大小
    property ThumbBtnMinSize:Integer read FThumbBtnMinSize write SetThumbBtnMinSize stored false;

    //水平样式向上箭头按钮图片
    property HorzMinBtnNormalPicture:TDrawPicture read FHorzMinBtnNormalPicture write SetHorzMinBtnNormalPicture stored false;
    //水平样式向上箭头按钮图片
    property HorzMinBtnDownPicture:TDrawPicture read FHorzMinBtnDownPicture write SetHorzMinBtnDownPicture stored false;
    //水平样式向上箭头按钮图片
    property HorzMinBtnHoverPicture:TDrawPicture read FHorzMinBtnHoverPicture write SetHorzMinBtnHoverPicture stored false;
    //水平样式向上箭头按钮图片
    property HorzMinBtnDisabledPicture:TDrawPicture read FHorzMinBtnDisabledPicture write SetHorzMinBtnDisabledPicture stored false;





    //垂直样式向上箭头按钮图片
    property VertMinBtnNormalPicture:TDrawPicture read FVertMinBtnNormalPicture write SetVertMinBtnNormalPicture stored false;
    //垂直样式向上箭头按钮图片
    property VertMinBtnHoverPicture:TDrawPicture read FVertMinBtnHoverPicture write SetVertMinBtnHoverPicture stored false;
    //垂直样式向上箭头按钮图片
    property VertMinBtnDownPicture:TDrawPicture read FVertMinBtnDownPicture write SetVertMinBtnDownPicture stored false;
    //垂直样式向上箭头按钮图片
    property VertMinBtnDisabledPicture:TDrawPicture read FVertMinBtnDisabledPicture write SetVertMinBtnDisabledPicture stored false;




    //垂直样式向下箭头按钮图片
    property VertMaxBtnNormalPicture: TDrawPicture read FVertMaxBtnNormalPicture write SetVertMaxBtnNormalPicture stored false;
    //垂直样式向下箭头按钮图片
    property VertMaxBtnHoverPicture: TDrawPicture read FVertMaxBtnHoverPicture write SetVertMaxBtnHoverPicture stored false;
    //垂直样式向下箭头按钮图片
    property VertMaxBtnDownPicture: TDrawPicture read FVertMaxBtnDownPicture write SetVertMaxBtnDownPicture stored false;
    //垂直样式向下箭头按钮图片
    property VertMaxBtnDisabledPicture: TDrawPicture read FVertMaxBtnDisabledPicture write SetVertMaxBtnDisabledPicture stored false;



    //水平样式向下箭头按钮图片
    property HorzMaxBtnNormalPicture: TDrawPicture read FHorzMaxBtnNormalPicture write SetHorzMaxBtnNormalPicture stored false;
    //水平样式向下箭头按钮图片
    property HorzMaxBtnHoverPicture: TDrawPicture read FHorzMaxBtnHoverPicture write SetHorzMaxBtnHoverPicture stored false;
    //水平样式向下箭头按钮图片
    property HorzMaxBtnDownPicture: TDrawPicture read FHorzMaxBtnDownPicture write SetHorzMaxBtnDownPicture stored false;
    //水平样式向下箭头按钮图片
    property HorzMaxBtnDisabledPicture: TDrawPicture read FHorzMaxBtnDisabledPicture write SetHorzMaxBtnDisabledPicture stored false;


    //垂直样式滚动滑块图片
    property VertThumbBtnNormalPicture: TDrawPicture read FVertThumbBtnNormalPicture write SetVertThumbBtnNormalPicture stored false;
    //垂直样式滚动滑块图片
    property VertThumbBtnHoverPicture: TDrawPicture read FVertThumbBtnHoverPicture write SetVertThumbBtnHoverPicture stored false;
    //垂直样式滚动滑块图片
    property VertThumbBtnDownPicture: TDrawPicture read FVertThumbBtnDownPicture write SetVertThumbBtnDownPicture stored false;
    //垂直样式滚动滑块图片
    property VertThumbBtnDisabledPicture: TDrawPicture read FVertThumbBtnDisabledPicture write SetVertThumbBtnDisabledPicture stored false;


    //水平样式滚动滑块图片
    property HorzThumbBtnNormalPicture: TDrawPicture read FHorzThumbBtnNormalPicture write SetHorzThumbBtnNormalPicture stored false;
    //水平样式滚动滑块图片
    property HorzThumbBtnHoverPicture: TDrawPicture read FHorzThumbBtnHoverPicture write SetHorzThumbBtnHoverPicture stored false;
    //水平样式滚动滑块图片
    property HorzThumbBtnDownPicture: TDrawPicture read FHorzThumbBtnDownPicture write SetHorzThumbBtnDownPicture stored false;
    //水平样式滚动滑块图片
    property HorzThumbBtnDisabledPicture: TDrawPicture read FHorzThumbBtnDisabledPicture write SetHorzThumbBtnDisabledPicture stored false;



    //垂直样式滚动条背景
    property VertBackGndPicture:TDrawPicture read FVertBackGndPicture write SetVertBackGndPicture stored false;
    //水平样式滚动条背景
    property HorzBackGndPicture:TDrawPicture read FHorzBackGndPicture write SetHorzBackGndPicture stored false;




    //滚动条背景绘制参数
    property BackGndPictureParam: TDrawPictureParam read FBackGndPictureParam write SetBackGndPictureParam stored false;
    //增大减小按钮绘制参数
    property MinMaxBtnPictureParam: TDrawPictureParam read FMinMaxBtnPictureParam write SetMinMaxBtnPictureParam stored false;
    //滚动滑块按钮绘制参数
    property ThumbBtnPictureParam: TDrawPictureParam read FThumbBtnPictureParam write SetThumbBtnPictureParam stored false;

  end;

  TSkinScrollBarDesktopType=class(TSkinScrollBarType)
  private
    function GetSkinMaterial: TSkinScrollBarDesktopMaterial;

    //根据按钮状态计算绘制下标
    function GetMinBtnPictureByBtnState(ABtnState:TScrollBarBtnState;AIsDrawInteractiveState:Boolean):TDrawPicture;
    function GetMaxBtnPictureByBtnState(ABtnState:TScrollBarBtnState;AIsDrawInteractiveState:Boolean):TDrawPicture;
    function GetThumbBtnPictureByBtnState(ABtnState:TScrollBarBtnState;AIsDrawInteractiveState:Boolean):TDrawPicture;


  protected
    //滚动滑块自动大小
    function CalcScrollBarAutoSize:Integer;


    //获取减小增大按钮绘制大小
    function GetMinMaxBtnDrawSize:Double;override;
    function GetMinMaxBtnSize:Double;override;
    //滚动滑块绘制大小
    function GetThumbBtnDrawSize:Double;override;



    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;

    //获取宽度
    function GetAutoSizeWidth:TControlSize;override;
    //获取高度
    function GetAutoSizeHeight:TControlSize;override;

    //计算大小
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinScrollBar=class(TBaseSkinControl,ISkinScrollBar)
  protected
    function GetScrollBarProperties:TScrollBarProperties;
    procedure SetScrollBarProperties(Value:TScrollBarProperties);
  protected
    //自已创建的
    FMyControlGestureManager: TSkinControlGestureManager;

  protected
    FOnChange: TNotifyEvent;
    FOnInvalidateScrollControl: TNotifyEvent;


    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);

    procedure SetOnInvalidateScrollControl(const Value: TNotifyEvent);
    function GetOnInvalidateScrollControl: TNotifyEvent;


    function GetOnMinOverRangePosValueChange: TOverRangePosValueChangeEvent;
    procedure SetOnMinOverRangePosValueChange(const Value: TOverRangePosValueChangeEvent);
    function GetOnMaxOverRangePosValueChange: TOverRangePosValueChangeEvent;
    procedure SetOnMaxOverRangePosValueChange(const Value: TOverRangePosValueChangeEvent);


    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
  public
    function SelfOwnMaterialToDefault:TSkinScrollBarDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinScrollBarDefaultMaterial;
    function Material:TSkinScrollBarDefaultMaterial;
  public
    constructor Create(AOwner:TComponent;AControlGestureManager:TSkinControlGestureManager);overload;
    constructor Create(AOwner:TComponent);overload;override;
    destructor Destroy;override;
  public
    property Prop:TScrollBarProperties read GetScrollBarProperties write SetScrollBarProperties;
  published
    //属性
    property Properties:TScrollBarProperties read GetScrollBarProperties write SetScrollBarProperties;

    //更改
    property OnChange: TNotifyEvent read GetOnChange write SetOnChange;

    //越界值更改事件
    property OnMinOverRangePosValueChange:TOverRangePosValueChangeEvent read GetOnMinOverRangePosValueChange write SetOnMinOverRangePosValueChange;
    property OnMaxOverRangePosValueChange:TOverRangePosValueChangeEvent read GetOnMaxOverRangePosValueChange write SetOnMaxOverRangePosValueChange;

  end;


  TSkinChildScrollBar=TBaseSkinScrollBar;

  {$IFDEF FMX}
  TSkinScrollBar=class(TBaseSkinScrollBar)
  end;
  {$ENDIF FMX}

  {$IFDEF VCL}
  TSkinWinScrollBar=class(TBaseSkinScrollBar)
  end;
  {$ENDIF VCL}


implementation





{ TSkinScrollBarMobileType }

function TSkinScrollBarMobileType.GetSkinMaterial: TSkinScrollBarMobileMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinScrollBarMobileMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinScrollBarMobileType.GetMinMaxBtnDrawSize: Double;
begin
  Result:=0;
end;

function TSkinScrollBarMobileType.GetMinMaxBtnSize: Double;
begin
  Result:=0;
end;

function TSkinScrollBarMobileType.GetThumbBtnDrawSize: Double;
var
  PageSize:Double;
  DrawStep:Double;
begin
  //PageSize不能太大,算出最合适的PageSize
  DrawStep:=GetThumbBtnDrawStep;
  PageSize:=GetScrollBarPageSize;

  Result:=Round(PageSize*DrawStep);

  if Result<GetSkinMaterial.FThumbBtnMinSize then
  begin
    Result:=GetSkinMaterial.FThumbBtnMinSize;
  end;
  if Result>(GetScrollBarClientSize
            - GetMinMaxBtnSize
            - GetMinMaxBtnSize) then
  begin
    Result:=(GetScrollBarClientSize
            - GetMinMaxBtnSize
            - GetMinMaxBtnSize);
  end;
end;

function TSkinScrollBarMobileType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  AThumbBtnDrawRect:TRectF;
  BSkinMaterial:TSkinScrollBarMobileMaterial;
begin

  BSkinMaterial:=GetSkinMaterial;
  if BSkinMaterial<>nil then
  begin
    //确定绘制矩形
    if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
    begin
      if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
      begin
        AThumbBtnDrawRect:=ADrawRect;
        AThumbBtnDrawRect.Top:=AThumbBtnDrawRect.Top+Self.GetThumbBtnDrawPos;
        AThumbBtnDrawRect.Bottom:=AThumbBtnDrawRect.Top+Self.GetThumbBtnDrawSize;
      end
      else
      begin
        AThumbBtnDrawRect:=RectF(0,0,0,0);
      end;
    end
    else
    begin
      if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
      begin
        AThumbBtnDrawRect:=ADrawRect;
        AThumbBtnDrawRect.Left:=AThumbBtnDrawRect.Left+Self.GetThumbBtnDrawPos;
        AThumbBtnDrawRect.Right:=AThumbBtnDrawRect.Left+Self.GetThumbBtnDrawSize;
      end
      else
      begin
        AThumbBtnDrawRect:=RectF(0,0,0,0);
      end;
    end;



    if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
    begin
      //绘制滚动条滑动块

      if BSkinMaterial.FIsDefaultDrawThumbBtn then
      begin


        BSkinMaterial.FThumbBtnRectParam.IsFill:=True;

        {$IFDEF FMX}
        BSkinMaterial.FThumbBtnRectParam.FillDrawColor.Color:=$64000000;
        {$ENDIF FMX}


        BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Enabled:=True;
        BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.SizeType:=dpstPixel;
        if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
        begin
//          BSkinMaterial.FThumbBtnDrawSize:=
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Left:=1;
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Right:=1;
//          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Width:=BSkinMaterial.FThumbBtnDrawSize;
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Height:=0;
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.PositionHorzType:=dpphtCenter;
        end
        else
        begin
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Top:=1;
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Bottom:=1;
//          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Height:=BSkinMaterial.FThumbBtnDrawSize;
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.Width:=0;
          BSkinMaterial.FThumbBtnRectParam.DrawRectSetting.PositionVertType:=dppvtCenter;
        end;
        BSkinMaterial.FThumbBtnRectParam.IsRound:=True;
        BSkinMaterial.FThumbBtnRectParam.RoundWidth:=2;
        BSkinMaterial.FThumbBtnRectParam.RoundHeight:=2;

      end;

      ACanvas.DrawRect(BSkinMaterial.FThumbBtnRectParam,AThumbBtnDrawRect);
    end;


  end;

end;

{ TSkinScrollBarMobileMaterial }

procedure TSkinScrollBarMobileMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinScrollBarMobileMaterial;
begin

  if Dest is TSkinScrollBarMobileMaterial then
  begin
    DestObject:=TSkinScrollBarMobileMaterial(Dest);

    DestObject.FThumbBtnMinSize:=Self.FThumbBtnMinSize;
    DestObject.FThumbBtnDrawSize:=Self.FThumbBtnDrawSize;
    DestObject.FIsDefaultDrawThumbBtn:=Self.FIsDefaultDrawThumbBtn;

  end;

  inherited;

end;

constructor TSkinScrollBarMobileMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);


  FThumbBtnDrawSize:=4;
  FIsDefaultDrawThumbBtn:=True;

  FThumbBtnRectParam:=CreateDrawRectParam('ThumbBtnRectParam','滚动滑块矩形绘制参数');
  {$IFDEF FMX}
  Self.FThumbBtnRectParam.FillDrawColor.Color:=$64000000;
  FThumbBtnMinSize:=20;
  {$ENDIF FMX}
  {$IFDEF VCL}
//  Self.FThumbBtnRectParam.FillDrawColor.Color:=clGray;
  Self.FThumbBtnRectParam.FillDrawColor.Color:=$AFAFAF;
  FThumbBtnMinSize:=40;
  {$ENDIF VCL}

end;

function TSkinScrollBarMobileMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsDefaultDrawThumbBtn' then
    begin
      FIsDefaultDrawThumbBtn:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='ThumbBtnMinSize' then
    begin
      FThumbBtnMinSize:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='ThumbBtnDrawSize' then
    begin
      FThumbBtnDrawSize:=ABTNode.ConvertNode_Int32.Data;
    end
    ;

  end;

  Result:=True;
end;

function TSkinScrollBarMobileMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Bool32('IsDefaultDrawThumbBtn','是否绘制空心圆');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsDefaultDrawThumbBtn;

  ABTNode:=ADocNode.AddChildNode_Int32('ThumbBtnMinSize','滚动滑块按钮最小大小');
  ABTNode.ConvertNode_Int32.Data:=Self.FThumbBtnMinSize;

  ABTNode:=ADocNode.AddChildNode_Int32('ThumbBtnDrawSize','滚动滑块绘制大小');
  ABTNode.ConvertNode_Int32.Data:=Self.FThumbBtnDrawSize;

  Result:=True;
end;

destructor TSkinScrollBarMobileMaterial.Destroy;
begin
  FreeAndNil(FThumbBtnRectParam);
  inherited;
end;

procedure TSkinScrollBarMobileMaterial.SetIsDefaultDrawThumbBtn(const Value: Boolean);
begin
  if FIsDefaultDrawThumbBtn<>Value then
  begin
    FIsDefaultDrawThumbBtn := Value;
    DoChange;
  end;
end;

procedure TSkinScrollBarMobileMaterial.SetThumbBtnDrawSize(const Value: Integer);
begin
  if FThumbBtnDrawSize<>Value then
  begin
    FThumbBtnDrawSize := Value;
    DoChange;
  end;
end;

procedure TSkinScrollBarMobileMaterial.SetThumbBtnMinSize(const Value: Integer);
begin
  if FThumbBtnMinSize<>Value then
  begin
    FThumbBtnMinSize := Value;
    DoChange;
  end;
end;

procedure TSkinScrollBarMobileMaterial.SetThumbBtnRectParam(const Value: TDrawRectParam);
begin
  FThumbBtnRectParam.Assign(Value);
end;




{ TScrollBarProperties }

constructor TScrollBarProperties.Create(ASkinControl:TControl);
begin
  FMinBtnState:=TScrollBarBtnState.Create;
  FMaxBtnState:=TScrollBarBtnState.Create;
  FMinSpaceState:=TScrollBarBtnState.Create;
  FMaxSpaceState:=TScrollBarBtnState.Create;
  FThumbBtnState:=TScrollBarBtnState.Create;

  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinScrollBar,Self.FSkinScrollBarIntf) then
  begin
    ShowException('This Component Do not Support ISkinScrollBar Interface');
  end
  else
  begin
    FKind:=sbVertical;



    FIsCanAutoHide:=True;

    Self.FIsInScrollControl:=False;



    //滚动条默认大小
    case FKind of
      sbHorizontal:
      begin
        FSkinControlIntf.Width:=120;
        FSkinControlIntf.Height:=17;
      end;
      sbVertical:
      begin
        FSkinControlIntf.Width:=17;
        FSkinControlIntf.Height:=120;
      end;
    end;



  end;
end;

destructor TScrollBarProperties.Destroy;
begin
  //鼠标按钮停靠的计时器
  FreeAndNil(FMouseDownStayTimer);

  //自动隐藏计时器
  FreeAndNil(FAutoHideTimer);



  FreeAndNil(FMinBtnState);
  FreeAndNil(FMaxBtnState);
  FreeAndNil(FMinSpaceState);
  FreeAndNil(FMaxSpaceState);
  FreeAndNil(FThumbBtnState);

  inherited;
end;

procedure TScrollBarProperties.DoControlGestureManagerPositionChange(Sender: TObject);
begin


  //触发更改事件
  if Assigned(Self.FSkinScrollBarIntf.OnChange) then
  begin
    Self.FSkinScrollBarIntf.OnChange(Self);
  end;

  Invalidate;

end;

procedure TScrollBarProperties.DoControlGestureManagerDragingStateChange(Sender: TObject);
begin

  if Self.FControlGestureManager.IsDraging then
  begin

    //不可以自动隐藏
    Self.IsCanAutoHide:=False;
    //停止定时器
    if Self.FAutoHideTimer<>nil then
    begin
      Self.FAutoHideTimer.Enabled:=False;
    end;

  end
  else
  begin

    //启动自动隐藏计时器
    Self.CreateAutoHideTimer;
    Self.FAutoHideTimer.Enabled:=True;

  end;
end;

procedure TScrollBarProperties.SetCanOverRangeTypes(const Value: TCanOverRangeTypes);
begin
  Self.FControlGestureManager.CanOverRangeTypes:=Value;
end;

procedure TScrollBarProperties.SetControlGestureManager(AControlGestureManager: TSkinControlGestureManager);
begin
  //用户拖动时候滚动的位置全部由FControlGestureManager来设置
  FControlGestureManager:=AControlGestureManager;

  //Position更改
  FControlGestureManager.OnPositionChange:=DoControlGestureManagerPositionChange;

  //自动隐藏
  FControlGestureManager.OnDragingStateChange:=DoControlGestureManagerDragingStateChange;

end;

procedure TScrollBarProperties.SetIsCanAutoHide(const Value: Boolean);
begin
  if FIsCanAutoHide<>Value then
  begin
    FIsCanAutoHide := Value;
    Self.Invalidate;
  end;
end;

//procedure TScrollBarProperties.SetKeyPressChange(const Value: Integer);
//begin
//  if FKeyPressChange<>Value then
//  begin
//    FKeyPressChange := Value;
//    SyncControlGestureManagerProperties;
//  end;
//end;

procedure TScrollBarProperties.SetKind(const Value: TScrollBarKind);
begin
  if Value <> FKind then
  begin
    FKind := Value;
    case FKind of
      sbHorizontal: Self.FControlGestureManager.Kind:=gmkHorizontal;
      sbVertical: Self.FControlGestureManager.Kind:=gmkVertical;
    end;
    if not (csLoading in Self.FSkinControl.ComponentState) then
     begin
       Self.FSkinControlIntf.SetBounds(Self.FSkinControlIntf.Left,
                                        Self.FSkinControlIntf.Top,
                                        Self.FSkinControlIntf.Height,
                                        Self.FSkinControlIntf.Width);
     end;
  end;
end;

procedure TScrollBarProperties.SetLargeChange(const Value: Integer);
begin
  FControlGestureManager.LargeChange:=Value;
end;

procedure TScrollBarProperties.SetMax(const Value: Double);
begin
  //会死循环
  FControlGestureManager.StaticMax:=Value;

  //万一在刷新中,直接设置MinOverRangePosValue会造成刷新失败
//  if Not FControlGestureManager.ScrollingToInitialAnimator.IsRuning then
//  begin
//    FControlGestureManager.MinOverRangePosValue:=0;
//    FControlGestureManager.MaxOverRangePosValue:=0;
//  end;

  if FControlGestureManager.Position>FControlGestureManager.StaticMax then
  begin
    FControlGestureManager.Position:=FControlGestureManager.StaticMax;
  end
  else
  begin
    FControlGestureManager.Position:=FControlGestureManager.Position;
  end;
end;

procedure TScrollBarProperties.SetMaxPullLoadPanel(const Value: TChildControl);
var
  ASkinPullLoadPanelIntf:ISkinPullLoadPanel;
begin
  if FControlGestureManager.MaxPullLoadPanel<>Value then
  begin
    FControlGestureManager.MaxPullLoadPanel:=Value;

    if Value<>nil then
    begin
      if Not Value.GetInterface(IID_ISkinPullLoadPanel,ASkinPullLoadPanelIntf) then
      begin
        ShowException('This Component Do not Support ISkinPullLoadPanel Interface');
      end
      else
      begin
          ASkinPullLoadPanelIntf.Prop.LoadPanelType:=sborlptBottom;
          ASkinPullLoadPanelIntf.Prop.FControlGestureManager:=Self.FControlGestureManager;
      end;
    end
    else
    begin
    end;
  end;
end;

procedure TScrollBarProperties.SetMin(const Value: Double);
begin
  FControlGestureManager.StaticMin:=Value;

  if FControlGestureManager.Position<FControlGestureManager.StaticMin then
  begin
    FControlGestureManager.Position:=FControlGestureManager.StaticMin;
  end
  else
  begin
    FControlGestureManager.Position:=FControlGestureManager.Position;
  end;

end;

function TScrollBarProperties.GetMinPullLoadPanel:TChildControl;
begin
  Result:=Self.FControlGestureManager.MinPullLoadPanel;
end;

function TScrollBarProperties.GetMaxPullLoadPanel:TChildControl;
begin
  Result:=Self.FControlGestureManager.MaxPullLoadPanel;
end;

procedure TScrollBarProperties.SetMinPullLoadPanel(const Value: TChildControl);
var
  ASkinPullLoadPanelIntf:ISkinPullLoadPanel;
begin
  if FControlGestureManager.MinPullLoadPanel<>Value then
  begin
    FControlGestureManager.MinPullLoadPanel:=Value;

    if Value<>nil then
    begin
      if Not Value.GetInterface(IID_ISkinPullLoadPanel,ASkinPullLoadPanelIntf) then
      begin
        ShowException('This Component Do not Support ISkinPullLoadPanel Interface');
      end
      else
      begin

          ASkinPullLoadPanelIntf.Prop.LoadPanelType:=sborlptTop;
          ASkinPullLoadPanelIntf.Prop.FControlGestureManager:=Self.FControlGestureManager;

      end;
    end
    else
    begin
    end;
  end;
end;

procedure TScrollBarProperties.SetPageSize(const Value: Double);
begin
  FControlGestureManager.PageSize:=Value;
end;

procedure TScrollBarProperties.SetPosition(const Value: Double);
var
  APosition:Double;
begin
  APosition:=Value;


  if SmallerDouble(APosition,FControlGestureManager.Min) then
  begin
    APosition := FControlGestureManager.Min;
  end;
  if BiggerDouble(APosition,FControlGestureManager.Max) then
  begin
    APosition := FControlGestureManager.Max;
  end;

  if IsNotSameDouble(FControlGestureManager.Position,APosition) then
  begin

    FControlGestureManager.Position:=APosition;

  end;

end;

procedure TScrollBarProperties.SetSmallChange(const Value: Integer);
begin
  FControlGestureManager.SmallChange:=Value;
end;

function TScrollBarProperties.GetCanOverRangeTypes: TCanOverRangeTypes;
begin
  Result:=Self.FControlGestureManager.CanOverRangeTypes;
end;

function TScrollBarProperties.GetComponentClassify: String;
begin
  Result:='SkinScrollBar';
end;

function TScrollBarProperties.GetKind: TScrollBarKind;
begin
  Result:=FKind;
end;

function TScrollBarProperties.GetLargeChange: Integer;
begin
  Result:=Self.FControlGestureManager.LargeChange;
end;

function TScrollBarProperties.CalcDistance: Double;
begin
  Result:=(FControlGestureManager.Max-FControlGestureManager.Min);
end;

function TScrollBarProperties.GetMin: Double;
begin
  Result:=Self.FControlGestureManager.Min;
end;

function TScrollBarProperties.GetMinOverRangePosValue:Double;
begin
  Result:=Self.FControlGestureManager.CalcMinOverRangePosValue;
end;

function TScrollBarProperties.GetMax: Double;
begin
  Result:=Self.FControlGestureManager.Max;
end;

function TScrollBarProperties.GetPageSize: Double;
begin
  Result:=Self.FControlGestureManager.PageSize;
end;

function TScrollBarProperties.GetPosition: Double;
begin
  Result:=Self.FControlGestureManager.Position;
end;

function TScrollBarProperties.GetSmallChange: Integer;
begin
  Result:=Self.FControlGestureManager.SmallChange;
end;

function TScrollBarProperties.GetMaxOverRangePosValue:Double;
begin
  Result:=Self.FControlGestureManager.CalcMaxOverRangePosValue;
end;

procedure TScrollBarProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;

  Kind:=TScrollBarProperties(Src).FKind;

  Max:=TScrollBarProperties(Src).Max;
  Min:=TScrollBarProperties(Src).Min;

  Position:=TScrollBarProperties(Src).Position;

  SmallChange:=TScrollBarProperties(Src).SmallChange;
  LargeChange:=TScrollBarProperties(Src).LargeChange;
//  KeyPressChange:=TScrollBarProperties(Src).FKeyPressChange;

  PageSize:=TScrollBarProperties(Src).PageSize;

  //加载面板
  MinPullLoadPanel:=TScrollBarProperties(Src).FControlGestureManager.MinPullLoadPanel;
  MaxPullLoadPanel:=TScrollBarProperties(Src).FControlGestureManager.MaxPullLoadPanel;


end;

procedure TScrollBarProperties.OnAutoHideTimer(Sender: TObject);
begin
  if Self.FControlGestureManager.ScrollingToInitialAnimator.IsRuning then Exit;
  if Self.FControlGestureManager.InertiaScrollAnimator.IsRuning then Exit;
//  if Self.FControlGestureManager.KeyPressScrollAnimator.IsRuning then Exit;

  Self.FAutoHideTimer.Enabled:=False;
  //检测是否可以隐藏滚动条
  Self.IsCanAutoHide:=True;
end;

procedure TScrollBarProperties.CreateAutoHideTimer;
begin
  if FAutoHideTimer=nil then
  begin
    FAutoHideTimer:=TTimer.Create(nil);
    FAutoHideTimer.Enabled:=False;
    FAutoHideTimer.OnTimer:=Self.OnAutoHideTimer;
    FAutoHideTimer.Interval:=2000;
  end;
end;

procedure TScrollBarProperties.CreateMouseDownStayTimer;
begin
  if FMouseDownStayTimer=nil then
  begin
    FMouseDownStayTimer:=TTimer.Create(nil);
    FMouseDownStayTimer.Enabled:=False;
    FMouseDownStayTimer.OnTimer:=Self.OnMouseDownStayTimer;
  end;
  //第一次比较慢
  FMouseDownStayTimer.Interval:=500;
end;

procedure TScrollBarProperties.OnMouseDownStayTimer(Sender: TObject);
begin
  //第二次以后就快了
  FMouseDownStayTimer.Interval:=10;
  if Self.MaxBtnState.MouseDown
    and Self.MaxBtnState.MouseHover
    or Self.MaxSpaceState.MouseDown then
  begin
    Self.Position:=Self.Position+Self.SmallChange;
  end;
  if Self.MinBtnState.MouseDown
    and Self.MinBtnState.MouseHover
    or Self.MinSpaceState.MouseDown then
  begin
    Self.Position:=Self.Position-Self.SmallChange;
  end;
end;




{ TSkinScrollBarType }

function TSkinScrollBarType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinScrollBar,Self.FSkinScrollBarIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinScrollBar Interface');
    end;
  end;
end;

procedure TSkinScrollBarType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinScrollBarIntf:=nil;
end;

procedure TSkinScrollBarType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
var
  NeedInvalidate:Boolean;

  PtInMinBtnRect:Boolean;
  PtInMaxBtnRect:Boolean;
  PtInThumbBtnRect:Boolean;
  PtInMinSpaceRect:Boolean;
  PtInMaxSpaceRect:Boolean;
begin
  inherited;


      NeedInvalidate:=False;

      PtInMinBtnRect:=False;
      PtInMaxBtnRect:=False;
      PtInThumbBtnRect:=False;
      PtInMinSpaceRect:=False;
      PtInMaxSpaceRect:=False;
      FMouseMovePt:=PointF(X,Y);








      if PtInRect(RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),Self.FMouseMovePt) then
      begin
        PtInMinBtnRect:=PtInRect(Self.GetMinBtnRect,Self.FMouseMovePt);
        PtInMaxBtnRect:=PtInRect(Self.GetMaxBtnRect,Self.FMouseMovePt);

        if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
        begin
          PtInThumbBtnRect:=PtInRect(Self.GetThumbBtnDrawRect,Self.FMouseMovePt);
          PtInMinSpaceRect:=PtInRect(Self.GetMinSpaceRect,Self.FMouseMovePt);
          PtInMaxSpaceRect:=PtInRect(Self.GetMaxSpaceRect,Self.FMouseMovePt);
        end;
      end;




      //减小按钮状态更改
      if Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseDown<>PtInMinBtnRect then
      begin
        Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseDown:=PtInMinBtnRect;
        NeedInvalidate:=True;
      end;




      //减小空间状态更改
      if Self.FSkinScrollBarIntf.Prop.MinSpaceState.MouseDown<>PtInMinSpaceRect then
      begin
        Self.FSkinScrollBarIntf.Prop.MinSpaceState.MouseDown:=PtInMinSpaceRect;
        if Not PtInMinSpaceRect then
        begin
          if Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer<>nil then
          begin
            Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=False;
          end;
        end;
      end;


      //处理上移
      if PtInMinBtnRect or PtInMinSpaceRect then
      begin
        Self.FSkinScrollBarIntf.Prop.Position:=
          Self.FSkinScrollBarIntf.Prop.Position-Self.FSkinScrollBarIntf.Prop.SmallChange;
        Self.FSkinScrollBarIntf.Prop.CreateMouseDownStayTimer;
        Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=True;
      end;



      //增大按钮状态更改
      if Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseDown<>PtInMaxBtnRect then
      begin
        Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseDown:=PtInMaxBtnRect;
        NeedInvalidate:=True;
      end;





      //增大空间状态更新
      if Self.FSkinScrollBarIntf.Prop.MaxSpaceState.MouseDown<>PtInMaxSpaceRect then
      begin
        Self.FSkinScrollBarIntf.Prop.MaxSpaceState.MouseDown:=PtInMaxSpaceRect;
        if Not PtInMaxSpaceRect then
        begin
          if Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer<>nil then
          begin
            Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=False;
          end;
        end;
      end;



      //处理下移
      if PtInMaxBtnRect or PtInMaxSpaceRect then
      begin
        Self.FSkinScrollBarIntf.Prop.Position:=
          Self.FSkinScrollBarIntf.Prop.Position+Self.FSkinScrollBarIntf.Prop.SmallChange;
        Self.FSkinScrollBarIntf.Prop.CreateMouseDownStayTimer;
        Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=True;
      end;





      //滚动滑块状态更改
      if Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDown<>PtInThumbBtnRect then
      begin
        Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDown:=PtInThumbBtnRect;
        if PtInThumbBtnRect then
        begin




          Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownPt:=Self.FMouseMovePt;
          case Self.FSkinScrollBarIntf.Prop.FKind of
            sbHorizontal:
            begin
              Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownOffset:=
                Self.FMouseMovePt.X-Self.GetThumbBtnDrawPos;
            end;
            sbVertical:
            begin
              Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownOffset:=
                Self.FMouseMovePt.Y-Self.GetThumbBtnDrawPos;
            end;
          end;


        end;
        NeedInvalidate:=True;
      end;




      if PtInThumbBtnRect then
      begin
        if Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer<>nil then
        begin
          Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=False;
        end;
      end;


      if NeedInvalidate then
      begin
        Self.Invalidate;
      end;

end;

procedure TSkinScrollBarType.CustomMouseEnter;
begin
  inherited;
  {$IFDEF MSWINDOWS}
  Self.FSkinScrollBarIntf.Prop.IsCanAutoHide:=False;
  {$ENDIF}
  {$IFDEF _MACOS}
  Self.FSkinScrollBarIntf.Prop.IsCanAutoHide:=False;
  {$ENDIF}
  {$IFDEF LINUX}
  Self.FSkinScrollBarIntf.Prop.IsCanAutoHide:=False;
  {$ENDIF}
end;

procedure TSkinScrollBarType.CustomMouseLeave;
var
  NeedInvalidate:Boolean;
begin
  inherited;

    NeedInvalidate:=False;

    if Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseHover then
    begin
      Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseHover:=False;
      NeedInvalidate:=True;
    end;

    if Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseHover then
    begin
      Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseHover:=False;
      NeedInvalidate:=True;
    end;

    if Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseHover then
    begin
      Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseHover:=False;
      NeedInvalidate:=True;
    end;

    if Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer<>nil then
    begin
      Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=False;
    end;

    Self.FSkinScrollBarIntf.Prop.CreateAutoHideTimer;
    Self.FSkinScrollBarIntf.Prop.FAutoHideTimer.Enabled:=True;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
end;

function TSkinScrollBarType.GetScrollBarClientSize: Double;
begin
  case Self.FSkinScrollBarIntf.Prop.Kind of
    sbHorizontal:
    begin
      Result:=Self.FSkinControlIntf.Width;
    end;
    sbVertical:
    begin
      Result:=Self.FSkinControlIntf.Height;
    end;
  end;
end;

function TSkinScrollBarType.GetScrollBarPageSize: Double;
begin
  case Ceil(Self.FSkinScrollBarIntf.Prop.PageSize) of
    -1:
    begin
      Result:=Self.GetScrollBarClientSize;
    end;
    0:
    begin
      Result:=0;
    end;
    else
    begin
      Result:=Self.FSkinScrollBarIntf.Prop.PageSize;
    end;
  end;
end;

procedure TSkinScrollBarType.CustomMouseMove(Shift: TShiftState; X, Y: Double);
var
  Offset:Double;
  TempPosition:Double;
  NeedInvalidate:Boolean;
  PtInMinBtnRect:Boolean;
  PtInMaxBtnRect:Boolean;
  PtInThumbBtnRect:Boolean;
begin
  inherited;

    NeedInvalidate:=False;

    PtInMinBtnRect:=False;
    PtInMaxBtnRect:=False;
    PtInThumbBtnRect:=False;
    FMouseMovePt:=PointF(X,Y);



    if PtInRect(RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),Self.FMouseMovePt) then
    begin
      PtInMinBtnRect:=PtInRect(Self.GetMinBtnRect,Self.FMouseMovePt);
      PtInMaxBtnRect:=PtInRect(Self.GetMaxBtnRect,Self.FMouseMovePt);
      if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
      begin
        PtInThumbBtnRect:=PtInRect(Self.GetThumbBtnDrawRect,Self.FMouseMovePt);
      end;
    end;

    if Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseHover<>PtInMinBtnRect then
    begin
      Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseHover:=PtInMinBtnRect;
      NeedInvalidate:=True;
      if Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer<>nil then
      begin
        Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=False;
      end;
    end;

    if Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseHover<>PtInMaxBtnRect then
    begin
      Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseHover:=PtInMaxBtnRect;
      NeedInvalidate:=True;
      if Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer<>nil then
      begin
        Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=False;
      end;
    end;

    if Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseHover<>PtInThumbBtnRect then
    begin
      Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseHover:=PtInThumbBtnRect;
      NeedInvalidate:=True;
    end;



    //如果在移动平台的情况下,那么要处理移动
    if Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDown then
    begin



          //鼠标拖动滚动滑块的时候
          case Self.FSkinScrollBarIntf.Prop.Kind of
            sbHorizontal:
            begin
              Offset := Self.FMouseMovePt.X - Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownPt.X;
            end;
            sbVertical:
            begin
              Offset := Self.FMouseMovePt.Y - Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownPt.Y;
            end;
          end;
          if Offset <> 0 then
          begin
            //当前的Position位置
            case Self.FSkinScrollBarIntf.Prop.Kind of
              sbHorizontal:
              begin
                Offset := Self.FMouseMovePt.X
                                      - Self.GetMinMaxBtnSize
                                      -Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownOffset;
              end;
              sbVertical:
              begin
                Offset := Self.FMouseMovePt.Y
                                      - Self.GetMinMaxBtnSize
                                      -Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownOffset;
              end;
            end;

            if (GetScrollBarClientSize
                  - GetMinMaxBtnSize
                  - GetMinMaxBtnSize
                  - GetThumbBtnDrawSize)>0 then
            begin
                  //直接设置位置

                  TempPosition:=Self.FSkinScrollBarIntf.Prop.Min
                                +
                                Offset
                                *(Self.FSkinScrollBarIntf.Prop.CalcDistance)
                                /(GetScrollBarClientSize
                                  - GetMinMaxBtnSize
                                  - GetMinMaxBtnSize
                                  - GetThumbBtnDrawSize);

                  if (TempPosition>Self.FSkinScrollBarIntf.Prop.Max)
                   then
                  begin
                    Self.FSkinScrollBarIntf.Prop.Position:=Self.FSkinScrollBarIntf.Prop.Max;
                  end
                  else if
                   (TempPosition<Self.FSkinScrollBarIntf.Prop.Min)
                   then
                  begin
                    Self.FSkinScrollBarIntf.Prop.Position:=Self.FSkinScrollBarIntf.Prop.Min;
                  end
                  else begin
                    Self.FSkinScrollBarIntf.Prop.Position:=TempPosition;
                  end;

            end
            else
            begin
                //不需要显示滚动条
                Self.FSkinScrollBarIntf.Prop.Position:=Self.FSkinScrollBarIntf.Prop.Min;
            end;



            Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDownPt := Self.FMouseMovePt;


          end;
    end
    else
    begin
    end;





    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;


end;

procedure TSkinScrollBarType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
var
  NeedInvalidate:Boolean;
begin
  inherited;


    NeedInvalidate:=False;


    Self.FMouseMovePt:=PointF(X,Y);


    if Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseDown then
    begin
      Self.FSkinScrollBarIntf.Prop.MinBtnState.MouseDown:=False;
      NeedInvalidate:=True;
    end;

    if Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseDown then
    begin
      Self.FSkinScrollBarIntf.Prop.MaxBtnState.MouseDown:=False;
      NeedInvalidate:=True;
    end;


    if Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDown then
    begin
      Self.FSkinScrollBarIntf.Prop.ThumbBtnState.MouseDown:=False;
      NeedInvalidate:=True;
    end;

    if Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer<>nil then
    begin
      Self.FSkinScrollBarIntf.Prop.FMouseDownStayTimer.Enabled:=False;
    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;

end;

function TSkinScrollBarType.CustomMouseWheel(Shift: TShiftState; WheelDelta:Integer; X,Y: Double): Boolean;
begin
  //手指滑动的时候
  //鼠标滚轮滚动事件
  Self.FSkinScrollBarIntf.Prop.FControlGestureManager.MouseWheel(Shift,WheelDelta,X,Y);
end;

procedure TSkinScrollBarType.SizeChanged;
begin
  inherited;
  Invalidate;
end;

////键盘事件
//procedure TSkinScrollBarType.KeyDown(Key: Word; Shift: TShiftState);
//begin
//  Self.FSkinScrollBarIntf.Prop.ControlGestureManager.KeyDown(Key,Shift);
//end;
//
//procedure TSkinScrollBarType.KeyUp(Key: Word; Shift: TShiftState);
//begin
//  //停止加速
//  Self.FSkinScrollBarIntf.Prop.ControlGestureManager.KeyUp(Key,Shift);
//end;

function TSkinScrollBarType.GetThumbBtnDrawPos: Double;
begin
  Result:=Self.GetMinMaxBtnSize+GetThumbBtnDrawPosOffset;
end;

function TSkinScrollBarType.GetThumbBtnDrawPosOffset: Double;
begin
  if Self.FSkinScrollBarIntf.Prop.Position=Self.FSkinScrollBarIntf.Prop.Min then
  begin
    Result:=0;
  end
  else if Self.FSkinScrollBarIntf.Prop.Position=Self.FSkinScrollBarIntf.Prop.Max then
  begin
    Result:=Self.GetScrollBarClientSize-Self.GetMinMaxBtnSize*2-Self.GetThumbBtnDrawSize;
  end
  else
  begin
    Result:=Round((Self.FSkinScrollBarIntf.Prop.Position
                  -Self.FSkinScrollBarIntf.Prop.Min
                  -Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMinOverRangePosValue
                  -Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMaxOverRangePosValue
                  )
                  *GetThumbPosDrawStep);
  end;
end;

function TSkinScrollBarType.GetThumbBtnDrawRect: TRectF;
begin
  //确定绘制矩形
  if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    Result.Top:=Self.GetThumbBtnDrawPos;
    Result.Bottom:=Result.Top+Self.GetThumbBtnDrawSize;
  end
  else
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    Result.Left:=Self.GetThumbBtnDrawPos;
    Result.Right:=Result.Left+Self.GetThumbBtnDrawSize;
  end;
end;

function TSkinScrollBarType.GetMinBtnRect: TRectF;
begin
  if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    Result.Bottom:=Result.Top+Self.GetMinMaxBtnDrawSize;
  end
  else
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    Result.Right:=Result.Left+Self.GetMinMaxBtnDrawSize;
  end;
end;

function TSkinScrollBarType.GetMinMaxBtnDrawSize: Double;
begin
  ShowException('Have Not Implement TSkinScrollBarType.GetMinMaxBtnDrawSize');
end;

function TSkinScrollBarType.GetMinMaxBtnSize: Double;
begin
  ShowException('Have Not Implement TSkinScrollBarType.GetMinMaxBtnSize');
end;

function TSkinScrollBarType.GetMinSpaceRect: TRectF;
begin
  if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
  begin
    Result:=RectF(0,
                  Self.GetMinMaxBtnSize,
                  Self.FSkinControlIntf.Width,
                  Self.GetThumbBtnDrawPos);
  end
  else
  begin
    Result:=RectF(Self.GetMinMaxBtnSize,
                  0,
                  Self.GetThumbBtnDrawPos,
                  Self.FSkinControlIntf.Height);
  end;
end;


function TSkinScrollBarType.GetThumbBtnDrawSize: Double;
begin
  ShowException('Have Not Implement TSkinScrollBarType.GetThumbBtnDrawSize');
end;

function TSkinScrollBarType.GetThumbBtnDrawStep: Double;
begin
  if (Self.FSkinScrollBarIntf.Prop.CalcDistance
      +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMinOverRangeScrollBarSize
      +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMaxOverRangeScrollBarSize
      )=0 then
  begin
    Result := (GetScrollBarClientSize
        - GetMinMaxBtnSize
        - GetMinMaxBtnSize
        );
  end
  else
  begin
    Result := (GetScrollBarClientSize
        - GetMinMaxBtnSize
        - GetMinMaxBtnSize

        )
        /(Self.FSkinScrollBarIntf.Prop.CalcDistance
        +GetScrollBarPageSize
        +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMinOverRangeScrollBarSize
        +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMaxOverRangeScrollBarSize
        );
  end;
end;

function TSkinScrollBarType.GetThumbPosDrawStep: Double;
begin
  if (Self.FSkinScrollBarIntf.Prop.CalcDistance
      +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMinOverRangeScrollBarSize
      +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMaxOverRangeScrollBarSize
      )=0 then
  begin

    Result := (GetScrollBarClientSize
        - GetMinMaxBtnSize
        - GetMinMaxBtnSize
        - GetThumbBtnDrawSize
        );
  end
  else
  begin
    Result := (GetScrollBarClientSize
        - GetMinMaxBtnSize
        - GetMinMaxBtnSize
        - GetThumbBtnDrawSize
        )
        /(Self.FSkinScrollBarIntf.Prop.CalcDistance
        +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMinOverRangeScrollBarSize
        +Self.FSkinScrollBarIntf.Prop.FControlGestureManager.CalcMaxOverRangeScrollBarSize
        );

  end;
end;


procedure TSkinScrollBarType.Invalidate;
begin
  if Self.FSkinScrollBarIntf.Prop.FIsInScrollControl
//     and (Assigned(Self.FSkinScrollBarIntf.OnInvalidate)
      and Assigned(Self.FSkinScrollBarIntf.OnInvalidateScrollControl)
      then
  begin

//    if Assigned(Self.FSkinScrollBarIntf.OnInnerInvalidate) then
//    begin
//      Self.FSkinScrollBarIntf.OnInnerInvalidate(Self);
//    end;

    if Assigned(Self.FSkinScrollBarIntf.OnInvalidateScrollControl) then
    begin
      Self.FSkinScrollBarIntf.OnInvalidateScrollControl(Self);
    end;

  end
  else
  begin
    inherited;
  end;
end;

function TSkinScrollBarType.GetMaxBtnRect: TRectF;
begin
  //确定绘制矩形
  if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    Result.Top:=Result.Bottom-Self.GetMinMaxBtnSize;
  end
  else
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    Result.Left:=Result.Right-Self.GetMinMaxBtnSize;
  end;
end;

function TSkinScrollBarType.GetMaxSpaceRect: TRectF;
begin
  if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
  begin
    Result:=RectF(0,
                Self.GetThumbBtnDrawPos+Self.GetThumbBtnDrawSize,
                Self.FSkinControlIntf.Width,
                Self.FSkinControlIntf.Height-Self.GetMinMaxBtnSize);
  end
  else
  begin
    Result:=RectF(Self.GetThumbBtnDrawPos+Self.GetThumbBtnDrawSize,
                  0,
                  Self.FSkinControlIntf.Width-Self.GetMinMaxBtnSize,
                  Self.FSkinControlIntf.Height);
  end;
end;


{ TSkinScrollBarDesktopType }

function TSkinScrollBarDesktopType.GetSkinMaterial: TSkinScrollBarDesktopMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinScrollBarDesktopMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinScrollBarDesktopType.GetAutoSizeHeight: TControlSize;
begin
  case Self.FSkinScrollBarIntf.Prop.Kind of
    sbHorizontal:
    begin
      Result:=CalcScrollBarAutoSize;
    end;
    sbVertical:
    begin
      Result:=Self.FSkinControlIntf.Height;
    end;
  end;
end;

function TSkinScrollBarDesktopType.GetAutoSizeWidth: TControlSize;
begin
  case Self.FSkinScrollBarIntf.Prop.Kind of
    sbHorizontal:
    begin
      Result:=Self.FSkinControlIntf.Width;
    end;
    sbVertical:
    begin
      Result:=Self.CalcScrollBarAutoSize;
    end;
  end;
end;

function TSkinScrollBarDesktopType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
begin
  Result:=False;
  if Self.GetSkinMaterial<>nil then
  begin
    Result:=True;
    AWidth:=GetAutoSizeWidth;
    AHeight:=GetAutoSizeHeight;
  end;
end;

function TSkinScrollBarDesktopType.GetMinBtnPictureByBtnState(ABtnState: TScrollBarBtnState;
                                                          AIsDrawInteractiveState:Boolean): TDrawPicture;
begin
  Result:=nil;
  case Self.FSkinScrollBarIntf.Prop.FKind of
    sbHorizontal:
    begin
        if GetSkinMaterial<>nil then
        begin
          if ABtnState.MouseDown and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FHorzMinBtnDownPicture;
          end
          else if ABtnState.MouseHover and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FHorzMinBtnHoverPicture;
          end
          else
          begin
            Result:=Self.GetSkinMaterial.FHorzMinBtnNormalPicture;
          end;
        end;
        if Result.CurrentPictureIsEmpty then
        begin
          Result:=Self.GetSkinMaterial.FHorzMinBtnNormalPicture;
        end;
    end;
    sbVertical:
    begin
        if GetSkinMaterial<>nil then
        begin
          if ABtnState.MouseDown and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FVertMinBtnDownPicture;
          end
          else if ABtnState.MouseHover and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FVertMinBtnHoverPicture;
          end
          else
          begin
            Result:=Self.GetSkinMaterial.FVertMinBtnNormalPicture;
          end;
        end;
        if Result.CurrentPictureIsEmpty then
        begin
          Result:=Self.GetSkinMaterial.FVertMinBtnNormalPicture;
        end;
    end;
  end;
end;


function TSkinScrollBarDesktopType.GetMaxBtnPictureByBtnState(ABtnState: TScrollBarBtnState;
                                                          AIsDrawInteractiveState:Boolean): TDrawPicture;
begin
  Result:=nil;
  case Self.FSkinScrollBarIntf.Prop.FKind of
    sbHorizontal:
    begin
        if GetSkinMaterial<>nil then
        begin
          if ABtnState.MouseDown and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FHorzMaxBtnDownPicture;
          end
          else if ABtnState.MouseHover and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FHorzMaxBtnHoverPicture;
          end
          else
          begin
            Result:=Self.GetSkinMaterial.FHorzMaxBtnNormalPicture;
          end;
        end;
        if Result.CurrentPictureIsEmpty then
        begin
          Result:=Self.GetSkinMaterial.FHorzMaxBtnNormalPicture;
        end;
    end;
    sbVertical:
    begin
        if GetSkinMaterial<>nil then
        begin
          if ABtnState.MouseDown and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FVertMaxBtnDownPicture;
          end
          else if ABtnState.MouseHover and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FVertMaxBtnHoverPicture;
          end
          else
          begin
            Result:=Self.GetSkinMaterial.FVertMaxBtnNormalPicture;
          end;
        end;
        if Result.CurrentPictureIsEmpty then
        begin
          Result:=Self.GetSkinMaterial.FVertMaxBtnNormalPicture;
        end;
    end;
  end;
end;


function TSkinScrollBarDesktopType.GetThumbBtnPictureByBtnState(ABtnState: TScrollBarBtnState;
                                                          AIsDrawInteractiveState:Boolean): TDrawPicture;
begin
  Result:=nil;
  case Self.FSkinScrollBarIntf.Prop.FKind of
    sbHorizontal:
    begin
        if GetSkinMaterial<>nil then
        begin
          if ABtnState.MouseDown and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FHorzThumbBtnDownPicture;
          end
          else if ABtnState.MouseHover and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FHorzThumbBtnHoverPicture;
          end
          else
          begin
            Result:=Self.GetSkinMaterial.FHorzThumbBtnNormalPicture;
          end;
        end;
        if Result.CurrentPictureIsEmpty then
        begin
          Result:=Self.GetSkinMaterial.FHorzThumbBtnNormalPicture;
        end;
    end;
    sbVertical:
    begin
        if GetSkinMaterial<>nil then
        begin
          if ABtnState.MouseDown and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FVertThumbBtnDownPicture;
          end
          else if ABtnState.MouseHover and AIsDrawInteractiveState then
          begin
            Result:=Self.GetSkinMaterial.FVertThumbBtnHoverPicture;
          end
          else
          begin
            Result:=Self.GetSkinMaterial.FVertThumbBtnNormalPicture;
          end;
        end;
        if Result.CurrentPictureIsEmpty then
        begin
          Result:=Self.GetSkinMaterial.FVertThumbBtnNormalPicture;
        end;
    end;
  end;
end;


function TSkinScrollBarDesktopType.GetMinMaxBtnDrawSize: Double;
begin
  case GetSkinMaterial.FMinMaxBtnDrawSize of
    -1:
    begin
      Result:=0;
    end;
    0:
    begin
      if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
      begin
        Result:=Self.GetSkinMaterial.FVertMaxBtnNormalPicture.CurrentPictureDrawHeight;
      end
      else
      begin
          Result:=Self.GetSkinMaterial.FHorzMaxBtnNormalPicture.CurrentPictureDrawWidth;
      end;
    end;
    else
    begin
      Result:=GetSkinMaterial.FMinMaxBtnDrawSize;
    end;
  end;
end;

function TSkinScrollBarDesktopType.GetMinMaxBtnSize: Double;
begin
  case GetSkinMaterial.FMinMaxBtnSize of
    -1:
    begin
      Result:=0;
    end;
    0:
    begin
      Result:=GetMinMaxBtnDrawSize;
    end;
    else
    begin
      Result:=GetSkinMaterial.FMinMaxBtnSize;
    end;
  end;
end;

function TSkinScrollBarDesktopType.CalcScrollBarAutoSize: Integer;
begin
  case Self.GetSkinMaterial.FThumbBtnDrawSize of
    -1:
    begin
      Result:=0;
    end;
    0:
    begin
      if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
      begin
        Result:=Self.GetSkinMaterial.FVertBackGndPicture.CurrentPictureDrawWidth;
        if (Result=0)
        then
        begin
          Result:=Self.GetSkinMaterial.FVertThumbBtnNormalPicture.CurrentPictureDrawWidth;
        end;
      end
      else
      begin
        Result:=Self.GetSkinMaterial.FHorzBackGndPicture.CurrentPictureDrawHeight;
        if (Result=0)
        then
        begin
          Result:=Self.GetSkinMaterial.FHorzThumbBtnNormalPicture.CurrentPictureDrawHeight;
        end;
      end;
    end;
    else
    begin
      Result:=Self.GetSkinMaterial.FThumbBtnDrawSize;
    end;
  end;
end;

function TSkinScrollBarDesktopType.GetThumbBtnDrawSize: Double;
var
  PageSize:Double;
  DrawStep:Double;
begin
  //PageSize不能太大,算出最合适的PageSize
  DrawStep:=GetThumbBtnDrawStep;
  PageSize:=GetScrollBarPageSize;

  Result:=Round(PageSize*DrawStep);

  if Result<GetSkinMaterial.FThumbBtnMinSize then
  begin
    Result:=GetSkinMaterial.FThumbBtnMinSize;
  end;
  if Result>(GetScrollBarClientSize
            - GetMinMaxBtnSize
            - GetMinMaxBtnSize) then
  begin
    Result:=(GetScrollBarClientSize
            - GetMinMaxBtnSize
            - GetMinMaxBtnSize);
  end;
end;

function TSkinScrollBarDesktopType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ABackGndPicture:TDrawPicture;
  AMinBtnPicture:TDrawPicture;
  AMaxBtnPicture:TDrawPicture;
  AThumbBtnPicture:TDrawPicture;

  AMinBtnDrawRect:TRectF;
  AMaxBtnDrawRect:TRectF;
  AThumbBtnDrawRect:TRectF;
begin
  if GetSkinMaterial<>nil then
  begin
    //确定素材
    if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
    begin
      ABackGndPicture:=Self.GetSkinMaterial.FVertBackGndPicture;
    end
    else
    begin
      ABackGndPicture:=Self.GetSkinMaterial.FHorzBackGndPicture;
    end;

    //确定绘制矩形
    if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
    begin
      AMinBtnDrawRect:=ADrawRect;
      AMinBtnDrawRect.Bottom:=AMinBtnDrawRect.Top+Self.GetMinMaxBtnDrawSize;

      AMaxBtnDrawRect:=ADrawRect;
      AMaxBtnDrawRect.Top:=AMaxBtnDrawRect.Bottom-Self.GetMinMaxBtnDrawSize;

      if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
      begin
        AThumbBtnDrawRect:=ADrawRect;
        AThumbBtnDrawRect.Top:=AThumbBtnDrawRect.Top+Self.GetThumbBtnDrawPos;
        AThumbBtnDrawRect.Bottom:=AThumbBtnDrawRect.Top+Self.GetThumbBtnDrawSize;
      end
      else
      begin
        AThumbBtnDrawRect:=RectF(0,0,0,0);
      end;
    end
    else
    begin
      AMinBtnDrawRect:=ADrawRect;
      AMinBtnDrawRect.Right:=AMinBtnDrawRect.Left+Self.GetMinMaxBtnDrawSize;

      AMaxBtnDrawRect:=ADrawRect;
      AMaxBtnDrawRect.Left:=AMaxBtnDrawRect.Right-Self.GetMinMaxBtnDrawSize;

      if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
      begin
        AThumbBtnDrawRect:=ADrawRect;
        AThumbBtnDrawRect.Left:=AThumbBtnDrawRect.Left+Self.GetThumbBtnDrawPos;
        AThumbBtnDrawRect.Right:=AThumbBtnDrawRect.Left+Self.GetThumbBtnDrawSize;
      end
      else
      begin
        AThumbBtnDrawRect:=RectF(0,0,0,0);
      end;
    end;

    AMinBtnPicture:=Self.GetMinBtnPictureByBtnState(Self.FSkinScrollBarIntf.Prop.MinBtnState,APaintData.IsDrawInteractiveState);
    AMaxBtnPicture:=Self.GetMaxBtnPictureByBtnState(Self.FSkinScrollBarIntf.Prop.MaxBtnState,APaintData.IsDrawInteractiveState);
    AThumbBtnPicture:=Self.GetThumbBtnPictureByBtnState(Self.FSkinScrollBarIntf.Prop.ThumbBtnState,APaintData.IsDrawInteractiveState);



    //绘制滚动条的背景
    ACanvas.DrawPicture(Self.GetSkinMaterial.FBackGndPictureParam,
                        ABackGndPicture,
                        ADrawRect);



    //绘制增大减小按钮
    if (RectWidthF(AMinBtnDrawRect)<>0)
      and (RectHeightF(AMinBtnDrawRect)<>0)
      and (AMinBtnPicture<>nil)
    then
    begin
      ACanvas.DrawPicture(Self.GetSkinMaterial.FMinMaxBtnPictureParam,
                          AMinBtnPicture,
                          AMinBtnDrawRect
                          );
    end;

    if (RectWidthF(AMaxBtnDrawRect)<>0)
      and (RectHeightF(AMaxBtnDrawRect)<>0)
      and (AMinBtnPicture<>nil)
    then
    begin
      ACanvas.DrawPicture(Self.GetSkinMaterial.FMinMaxBtnPictureParam,
                          AMaxBtnPicture,
                          AMaxBtnDrawRect
                          );
    end;




    if (Self.FSkinScrollBarIntf.Prop.CalcDistance)>0 then
    begin
      //绘制滚动条滑动块
      if Self.FSkinScrollBarIntf.Prop.Kind=sbVertical then
      begin
        GetSkinMaterial.FThumbBtnPictureParam.StretchStyle:=issThreePartVert;
      end
      else
      begin
        GetSkinMaterial.FThumbBtnPictureParam.StretchStyle:=issThreePartHorz;
      end;
      ACanvas.DrawPicture(Self.GetSkinMaterial.FThumbBtnPictureParam,
                          AThumbBtnPicture,
                          AThumbBtnDrawRect
                          );
    end;


  end;

end;

{ TSkinScrollBarDesktopMaterial }

procedure TSkinScrollBarDesktopMaterial.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TSkinScrollBarDesktopMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);

  FThumbBtnMinSize:=20;


  //0是自动计算大小
  //-1是无
  //>0,则此值
  FMinMaxBtnSize:=0;
  FMinMaxBtnDrawSize:=0;
  FThumbBtnDrawSize:=0;


  FHorzBackGndPicture:=CreateDrawPicture('HorzBackGndPicture','水平样式背景图片');
  FVertBackGndPicture:=CreateDrawPicture('VertBackGndPicture','垂直样式背景图片');

  FHorzMinBtnNormalPicture:=CreateDrawPicture('HorzMinBtnNormalPicture','正常状态水平样式向上按钮图片','水平样式向上按钮所有状态图片');
  FHorzMinBtnHoverPicture:=CreateDrawPicture('HorzMinBtnHoverPicture','鼠标停靠状态水平样式向上按钮图片','水平样式向上按钮所有状态图片');
  FHorzMinBtnDownPicture:=CreateDrawPicture('HorzMinBtnDownPicture','鼠标按下状态水平样式向上按钮图片','水平样式向上按钮所有状态图片');
  FHorzMinBtnDisabledPicture:=CreateDrawPicture('HorzMinBtnDisabledPicture','禁用状态水平样式向上按钮图片','水平样式向上按钮所有状态图片');

  FVertMinBtnNormalPicture:=CreateDrawPicture('VertMinBtnNormalPicture','正常状态垂直样式向上按钮图片','垂直样式向上按钮所有状态图片');
  FVertMinBtnHoverPicture:=CreateDrawPicture('VertMinBtnHoverPicture','鼠标停靠状态垂直样式向上按钮图片','垂直样式向上按钮所有状态图片');
  FVertMinBtnDownPicture:=CreateDrawPicture('VertMinBtnDownPicture','鼠标按下状态垂直样式向上按钮图片','垂直样式向上按钮所有状态图片');
  FVertMinBtnDisabledPicture:=CreateDrawPicture('VertMinBtnDisabledPicture','禁用状态垂直样式向上按钮图片','垂直样式向上按钮所有状态图片');


  FVertMaxBtnNormalPicture:=CreateDrawPicture('VertMaxBtnNormalPicture','正常状态垂直样式向下按钮图片','垂直样式向下按钮所有状态图片');
  FVertMaxBtnHoverPicture:=CreateDrawPicture('VertMaxBtnHoverPicture','鼠标停靠状态垂直样式向下按钮图片','垂直样式向下按钮所有状态图片');
  FVertMaxBtnDownPicture:=CreateDrawPicture('VertMaxBtnDownPicture','鼠标按下状态垂直样式向下按钮图片','垂直样式向下按钮所有状态图片');
  FVertMaxBtnDisabledPicture:=CreateDrawPicture('VertMaxBtnDisabledPicture','禁用状态垂直样式向下按钮图片','垂直样式向下按钮所有状态图片');

  FHorzMaxBtnNormalPicture:=CreateDrawPicture('HorzMaxBtnNormalPicture','正常状态水平样式向下按钮图片','水平样式向下按钮所有状态图片');
  FHorzMaxBtnHoverPicture:=CreateDrawPicture('HorzMaxBtnHoverPicture','鼠标停靠状态水平样式向下按钮图片','水平样式向下按钮所有状态图片');
  FHorzMaxBtnDownPicture:=CreateDrawPicture('HorzMaxBtnDownPicture','鼠标按下状态水平样式向下按钮图片','水平样式向下按钮所有状态图片');
  FHorzMaxBtnDisabledPicture:=CreateDrawPicture('HorzMaxBtnDisabledPicture','禁用状态水平样式向下按钮图片','水平样式向下按钮所有状态图片');


  FVertThumbBtnNormalPicture:=CreateDrawPicture('VertThumbBtnNormalPicture','正常状态垂直样式滚动滑块图片','垂直样式滚动滑块所有状态图片');
  FVertThumbBtnHoverPicture:=CreateDrawPicture('VertThumbBtnHoverPicture','鼠标停靠状态垂直样式滚动滑块图片','垂直样式滚动滑块所有状态图片');
  FVertThumbBtnDownPicture:=CreateDrawPicture('VertThumbBtnDownPicture','按下状态垂直样式滚动滑块图片','垂直样式滚动滑块所有状态图片');
  FVertThumbBtnDisabledPicture:=CreateDrawPicture('VertThumbBtnDisabledPicture','禁用状态垂直样式滚动滑块图片','垂直样式滚动滑块所有状态图片');


  FHorzThumbBtnNormalPicture:=CreateDrawPicture('HorzThumbBtnNormalPicture','正常状态水平样式滚动滑块图片','水平样式滚动滑块所有状态图片');
  FHorzThumbBtnHoverPicture:=CreateDrawPicture('HorzThumbBtnHoverPicture','鼠标停靠状态水平样式滚动滑块图片','水平样式滚动滑块所有状态图片');
  FHorzThumbBtnDownPicture:=CreateDrawPicture('HorzThumbBtnDownPicture','按下状态水平样式滚动滑块图片','水平样式滚动滑块所有状态图片');
  FHorzThumbBtnDisabledPicture:=CreateDrawPicture('HorzThumbBtnDisabledPicture','禁用状态水平样式滚动滑块图片','水平样式滚动滑块所有状态图片');



  FBackGndPictureParam:=CreateDrawPictureParam('BackGndPictureParam','背景图片绘制参数');

  FMinMaxBtnPictureParam:=CreateDrawPictureParam('MinMaxBtnPictureParam','增大减小按钮图片绘制参数');

  FThumbBtnPictureParam:=CreateDrawPictureParam('ThumbBtnPictureParam','滚动滑块图片绘制参数');


end;

function TSkinScrollBarDesktopMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I: Integer;
//  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);

//
//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
//    if ABTNode.NodeName='MinMaxBtnDrawSize' then
//    begin
//      FMinMaxBtnDrawSize:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='MinMaxBtnSize' then
//    begin
//      FMinMaxBtnSize:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='ThumbBtnMinSize' then
//    begin
//      FThumbBtnMinSize:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='NormalPicture' then
//    begin
//      FNormalPicture:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='HoverPicture' then
//    begin
//      FHoverPicture:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='DisabledPicture' then
//    begin
//      FDisabledPicture:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='DownPicture' then
//    begin
//      FDownPicture:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='AllStatePictureColCount' then
//    begin
//      FAllStatePictureColCount:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='VertMinBtnPicture' then
//    begin
//      FVertMinBtnPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else if ABTNode.NodeName='HorzMinBtnPicture' then
//    begin
//      FHorzMinBtnPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else if ABTNode.NodeName='VertBackGndPicture' then
//    begin
//      FVertBackGndPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else if ABTNode.NodeName='HorzBackGndPicture' then
//    begin
//      FHorzBackGndPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else if ABTNode.NodeName='VertMaxBtnPicture' then
//    begin
//      FVertMaxBtnPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else if ABTNode.NodeName='HorzMaxBtnPicture' then
//    begin
//      FHorzMaxBtnPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else if ABTNode.NodeName='VertThumbBtnPicture' then
//    begin
//      FVertThumbBtnPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else if ABTNode.NodeName='HorzThumbBtnPicture' then
//    begin
//      FHorzThumbBtnPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    ;
//
//  end;

  Result:=True;
end;

function TSkinScrollBarDesktopMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

//  ABTNode:=ADocNode.AddChildNode_Int32('MinMaxBtnDrawSize','增大减小按钮绘制大小');
//  Self.FMinMaxBtnDrawSize:=ABTNode.ConvertNode_Int32.Data;
//  ABTNode:=ADocNode.AddChildNode_Int32('MinMaxBtnSize','增大减小按钮大小');
//  Self.FMinMaxBtnSize:=ABTNode.ConvertNode_Int32.Data;
//  ABTNode:=ADocNode.AddChildNode_Class('ThumbBtnMinSize','滚动滑块按钮最小大小');
//  Self.FThumbBtnMinSize:=ABTNode.ConvertNode_Int32.Data;

//  ABTNode:=ADocNode.AddChildNode_Class('NormalPicture','正常状态图片列下标');
//  Self.FNormalPicture:=ABTNode.ConvertNode_Int32.Data;
//  ABTNode:=ADocNode.AddChildNode_Class('HoverPicture','鼠标停靠状态图片列下标');
//  Self.FHoverPicture:=ABTNode.ConvertNode_Int32.Data;
//  ABTNode:=ADocNode.AddChildNode_Class('DisabledPicture','禁用状态图片列下标');
//  Self.FDisabledPicture:=ABTNode.ConvertNode_Int32.Data;
//  ABTNode:=ADocNode.AddChildNode_Class('DownPicture','鼠标按下状态图片列下标');
//  Self.FDownPicture:=ABTNode.ConvertNode_Int32.Data;
//  ABTNode:=ADocNode.AddChildNode_Class('AllStatePictureColCount','图片列数');
//  Self.FAllStatePictureColCount:=ABTNode.ConvertNode_Int32.Data;


//  ABTNode:=ADocNode.AddChildNode_Class('VertMinBtnPicture',FVertMinBtnPicture.Name);
//  Self.FVertMinBtnPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('HorzMinBtnPicture',FHorzMinBtnPicture.Name);
//  Self.FHorzMinBtnPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('VertBackGndPicture',FVertBackGndPicture.Name);
//  Self.FVertBackGndPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('HorzBackGndPicture',FHorzBackGndPicture.Name);
//  Self.FHorzBackGndPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('VertMaxBtnPicture',FVertMaxBtnPicture.Name);
//  Self.FVertMaxBtnPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('HorzMaxBtnPicture',FHorzMaxBtnPicture.Name);
//  Self.FHorzMaxBtnPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('VertThumbBtnPicture',FVertThumbBtnPicture.Name);
//  Self.FVertThumbBtnPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('HorzThumbBtnPicture',FHorzThumbBtnPicture.Name);
//  Self.FHorzThumbBtnPicture.SaveToDocNode(ABTNode.ConvertNode_Class);


  Result:=True;
end;

destructor TSkinScrollBarDesktopMaterial.Destroy;
begin

  FreeAndNil(FThumbBtnPictureParam);
  FreeAndNil(FBackGndPictureParam);
  FreeAndNil(FMinMaxBtnPictureParam);

  FreeAndNil(FHorzBackGndPicture);
  FreeAndNil(FVertBackGndPicture);

  FreeAndNil(FHorzMinBtnNormalPicture);
  FreeAndNil(FVertMinBtnNormalPicture);
  FreeAndNil(FVertMaxBtnNormalPicture);
  FreeAndNil(FHorzMaxBtnNormalPicture);
  FreeAndNil(FVertThumbBtnNormalPicture);
  FreeAndNil(FHorzThumbBtnNormalPicture);

  FreeAndNil(FHorzMinBtnHoverPicture);
  FreeAndNil(FVertMinBtnHoverPicture);
  FreeAndNil(FVertMaxBtnHoverPicture);
  FreeAndNil(FHorzMaxBtnHoverPicture);
  FreeAndNil(FVertThumbBtnHoverPicture);
  FreeAndNil(FHorzThumbBtnHoverPicture);

  FreeAndNil(FHorzMinBtnDownPicture);
  FreeAndNil(FVertMinBtnDownPicture);
  FreeAndNil(FVertMaxBtnDownPicture);
  FreeAndNil(FHorzMaxBtnDownPicture);
  FreeAndNil(FVertThumbBtnDownPicture);
  FreeAndNil(FHorzThumbBtnDownPicture);

  FreeAndNil(FHorzMinBtnDisabledPicture);
  FreeAndNil(FVertMinBtnDisabledPicture);
  FreeAndNil(FVertMaxBtnDisabledPicture);
  FreeAndNil(FHorzMaxBtnDisabledPicture);
  FreeAndNil(FVertThumbBtnDisabledPicture);
  FreeAndNil(FHorzThumbBtnDisabledPicture);

  inherited;
end;


procedure TSkinScrollBarDesktopMaterial.SetBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FBackGndPictureParam.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzBackGndPicture(const Value: TDrawPicture);
begin
  FHorzBackGndPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertBackGndPicture(const Value: TDrawPicture);
begin
  FVertBackGndPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMaxBtnNormalPicture(const Value: TDrawPicture);
begin
  FVertMaxBtnNormalPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMaxBtnNormalPicture(const Value: TDrawPicture);
begin
  FHorzMaxBtnNormalPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMinBtnNormalPicture(const Value: TDrawPicture);
begin
  FHorzMinBtnNormalPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMinBtnNormalPicture(const Value: TDrawPicture);
begin
  FVertMinBtnNormalPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzThumbBtnNormalPicture(const Value: TDrawPicture);
begin
  FHorzThumbBtnNormalPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertThumbBtnNormalPicture(const Value: TDrawPicture);
begin
  FVertThumbBtnNormalPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMaxBtnHoverPicture(const Value: TDrawPicture);
begin
  FVertMaxBtnHoverPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMaxBtnHoverPicture(const Value: TDrawPicture);
begin
  FHorzMaxBtnHoverPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMinBtnHoverPicture(const Value: TDrawPicture);
begin
  FHorzMinBtnHoverPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMinBtnHoverPicture(const Value: TDrawPicture);
begin
  FVertMinBtnHoverPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzThumbBtnHoverPicture(const Value: TDrawPicture);
begin
  FHorzThumbBtnHoverPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertThumbBtnHoverPicture(const Value: TDrawPicture);
begin
  FVertThumbBtnHoverPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMaxBtnDownPicture(const Value: TDrawPicture);
begin
  FVertMaxBtnDownPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMaxBtnDownPicture(const Value: TDrawPicture);
begin
  FHorzMaxBtnDownPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMinBtnDownPicture(const Value: TDrawPicture);
begin
  FHorzMinBtnDownPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMinBtnDownPicture(const Value: TDrawPicture);
begin
  FVertMinBtnDownPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzThumbBtnDownPicture(const Value: TDrawPicture);
begin
  FHorzThumbBtnDownPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertThumbBtnDownPicture(const Value: TDrawPicture);
begin
  FVertThumbBtnDownPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMaxBtnDisabledPicture(const Value: TDrawPicture);
begin
  FVertMaxBtnDisabledPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMaxBtnDisabledPicture(const Value: TDrawPicture);
begin
  FHorzMaxBtnDisabledPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzMinBtnDisabledPicture(const Value: TDrawPicture);
begin
  FHorzMinBtnDisabledPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertMinBtnDisabledPicture(const Value: TDrawPicture);
begin
  FVertMinBtnDisabledPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetHorzThumbBtnDisabledPicture(const Value: TDrawPicture);
begin
  FHorzThumbBtnDisabledPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetVertThumbBtnDisabledPicture(const Value: TDrawPicture);
begin
  FVertThumbBtnDisabledPicture.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetMinMaxBtnDrawSize(
  const Value: Integer);
begin
  if FMinMaxBtnDrawSize<>Value then
  begin
    FMinMaxBtnDrawSize := Value;
    DoChange;
  end;
end;

procedure TSkinScrollBarDesktopMaterial.SetMinMaxBtnPictureParam(
  const Value: TDrawPictureParam);
begin
  FMinMaxBtnPictureParam.Assign(Value);
end;

procedure TSkinScrollBarDesktopMaterial.SetMinMaxBtnSize(const Value: Integer);
begin
  if FMinMaxBtnSize<>Value then
  begin
    FMinMaxBtnSize := Value;
    DoChange;
  end;
end;

procedure TSkinScrollBarDesktopMaterial.SetThumbBtnMinSize(
  const Value: Integer);
begin
  if FThumbBtnMinSize<>Value then
  begin
    FThumbBtnMinSize := Value;
    DoChange;
  end;
end;

procedure TSkinScrollBarDesktopMaterial.SetThumbBtnPictureParam(const Value: TDrawPictureParam);
begin
  FThumbBtnPictureParam.Assign(Value);
end;






{ TBaseSkinScrollBar }


constructor TBaseSkinScrollBar.Create(AOwner:TComponent;AControlGestureManager:TSkinControlGestureManager);
begin
  Inherited Create(AOwner);

  Properties.SetControlGestureManager(AControlGestureManager);

end;

constructor TBaseSkinScrollBar.Create(AOwner:TComponent);
begin
  //用户拖动时候滚动的位置全部由FControlGestureManager来设置
  FMyControlGestureManager:=TSkinControlGestureManager.Create(nil,Self);

  Create(AOwner,FMyControlGestureManager);
end;

destructor TBaseSkinScrollBar.Destroy;
begin
  //按件手势管理者
  FreeAndNil(FMyControlGestureManager);

  Inherited;
end;

function TBaseSkinScrollBar.Material:TSkinScrollBarDefaultMaterial;
begin
  Result:=TSkinScrollBarDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinScrollBar.SelfOwnMaterialToDefault:TSkinScrollBarDefaultMaterial;
begin
  Result:=TSkinScrollBarDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinScrollBar.CurrentUseMaterialToDefault:TSkinScrollBarDefaultMaterial;
begin
  Result:=TSkinScrollBarDefaultMaterial(CurrentUseMaterial);
end;

function TBaseSkinScrollBar.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TScrollBarProperties;
end;

function TBaseSkinScrollBar.GetScrollBarProperties: TScrollBarProperties;
begin
  Result:=TScrollBarProperties(Self.FProperties);
end;

procedure TBaseSkinScrollBar.SetScrollBarProperties(Value: TScrollBarProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TBaseSkinScrollBar.DoCustomSkinMaterialChange(Sender: TObject);
begin
  Self.GetScrollBarProperties.AdjustAutoSizeBounds;
  Inherited;
end;

procedure TBaseSkinScrollBar.SetOnInvalidateScrollControl(const Value: TNotifyEvent);
begin
  FOnInvalidateScrollControl := Value;
end;

function TBaseSkinScrollBar.GetOnInvalidateScrollControl: TNotifyEvent;
begin
  Result:=FOnInvalidateScrollControl;
end;

//procedure TBaseSkinScrollBar.SetOnInnerInvalidate(const Value: TNotifyEvent);
//begin
//  FOnInnerInvalidate := Value;
//end;
//
//function TBaseSkinScrollBar.GetOnInnerInvalidate: TNotifyEvent;
//begin
//  Result:=FOnInnerInvalidate;
//end;

function TBaseSkinScrollBar.GetOnMinOverRangePosValueChange: TOverRangePosValueChangeEvent;
begin
  Result:=Prop.ControlGestureManager.OnMinOverRangePosValueChange;
end;

function TBaseSkinScrollBar.GetOnMaxOverRangePosValueChange: TOverRangePosValueChangeEvent;
begin
  Result:=Prop.ControlGestureManager.OnMaxOverRangePosValueChange;
end;

procedure TBaseSkinScrollBar.SetOnMaxOverRangePosValueChange(const Value: TOverRangePosValueChangeEvent);
begin
  Prop.ControlGestureManager.OnMaxOverRangePosValueChange:=Value;
end;

procedure TBaseSkinScrollBar.SetOnMinOverRangePosValueChange(const Value: TOverRangePosValueChangeEvent);
begin
  Prop.ControlGestureManager.OnMinOverRangePosValueChange:=Value;
end;

procedure TBaseSkinScrollBar.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange:=Value;
end;

function TBaseSkinScrollBar.GetOnChange: TNotifyEvent;
begin
  Result:=FOnChange;
end;

procedure TBaseSkinScrollBar.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);


  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin
      if (AComponent=Self.Properties.MaxPullLoadPanel) then
      begin
        Self.Properties.MaxPullLoadPanel:=nil;
      end;
      if (AComponent=Self.Properties.MinPullLoadPanel) then
      begin
        Self.Properties.MinPullLoadPanel:=nil;
      end;
    end
    ;
  end;

end;



end.





