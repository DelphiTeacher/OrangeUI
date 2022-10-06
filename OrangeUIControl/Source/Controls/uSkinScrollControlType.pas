//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     滚动控件
///   </para>
///   <para>
///     Scroll control
///   </para>
/// </summary>
unit uSkinScrollControlType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  uSkinPublic,
  uLang,
  {$IFDEF VCL}
  Controls,
  ExtCtrls,
  Forms,
  Windows,
  Messages,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Types,
  UITypes,
  FMX.Forms,
  FMX.Controls,
  FMX.Graphics,
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$ENDIF}
  Types,
  Math,
  {$IFDEF VCL}
//  uSkinWindowsLabel,
//  uSkinWindowsPanel,
//  uSkinWindowsImage,
//  uSkinWindowsScrollBar,
//  uSkinWindowsPullLoadPanel,
//  uSkinWindowsScrollControlCorner
  {$ENDIF}
  {$IFDEF FMX}
  System.Math.Vectors,
  uSkinFireMonkeyScrollBar,
  uSkinFireMonkeyPullLoadPanel,
  uSkinFireMonkeyScrollControlCorner,
  {$ENDIF}
  uSkinImageList,
  uSkinLabelType,
  uSkinImageType,
  uSkinPanelType,
  uBaseSkinControl,
  uSkinPullLoadPanelType,
  uBaseLog,
//  uFuncCommon,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinControlGestureManager,
  uSkinScrollBarType,
  uSkinScrollControlCornerType,
  uComponentType,
  uSkinMaterial,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uDrawPictureParam,
  uGraphicCommon;






const
  IID_ISkinScrollControl:TGUID='{15422D75-667A-4DBF-9343-FB70547AF10C}';



type
  TScrollControlProperties=class;




  /// <summary>
  ///   <para>
  ///     滚动控件接口
  ///   </para>
  ///   <para>
  ///     Interface of Scroll control
  ///   </para>
  /// </summary>
  ISkinScrollControl=interface//(ISkinControl)
  ['{15422D75-667A-4DBF-9343-FB70547AF10C}']

    //滚动框角
    function GetScrollControlCornerIntf:ISkinScrollControlCorner;
    function GetScrollControlCornerControlIntf:ISkinControl;


    //垂直滚动条
    procedure FreeVertScrollBar;
    function GetVertScrollBarIntf:ISkinScrollBar;
    function GetVertScrollBarControlIntf:ISkinControl;


    //水平滚动条
    procedure FreeHorzScrollBar;
    function GetHorzScrollBarIntf:ISkinScrollBar;
    function GetHorzScrollBarControlIntf:ISkinControl;


    //自绘事件(用于在ScrollBox上绘制滚动条)
    function GetOnPaintContent:TSkinControlPaintEvent;
    property OnPaintContent:TSkinControlPaintEvent read GetOnPaintContent;


    //下拉刷新事件
    function GetOnPullDownRefresh:TNotifyEvent;
    property OnPullDownRefresh:TNotifyEvent read GetOnPullDownRefresh;

    //上拉加载更多事件
    function GetOnPullUpLoadMore:TNotifyEvent;
    property OnPullUpLoadMore:TNotifyEvent read GetOnPullUpLoadMore;


    function GetScrollControlProperties:TScrollControlProperties;
    property Properties:TScrollControlProperties read GetScrollControlProperties;
    property Prop:TScrollControlProperties read GetScrollControlProperties;
  end;






  /// <summary>
  ///   <para>
  ///     滚动条显示类型
  ///   </para>
  ///   <para>
  ///     Display type of ScrollBar
  ///   </para>
  /// </summary>
  TScrollBarShowType=(
                      /// <summary>
                      ///   不存在,不响应消息
                      ///   <para>
                      ///     Not exist,not reply messages
                      ///   </para>
                      /// </summary>
                      sbstNone,
                      /// <summary>
                      ///   永远覆盖显示
                      ///   <para>
                      ///     Always cover show
                      ///   </para>
                      /// </summary>
                      sbstAlwaysCoverShow,
                      /// <summary>
                      ///   永远单独显示
                      ///   <para>
                      ///     Always clip show
                      ///   </para>
                      /// </summary>
                      sbstAlwaysClipShow,
                      /// <summary>
                      ///   自动覆盖显示
                      ///   <para>
                      ///     Cover show automaticly
                      ///   </para>
                      /// </summary>
                      sbstAutoCoverShow,
                      /// <summary>
                      ///   自动单独显示
                      ///   <para>
                      ///     Auto clip show
                      ///   </para>
                      /// </summary>
                      sbstAutoClipShow,
                      /// <summary>
                      ///   永远隐藏,但是它会处理滚动功能
                      ///   <para>
                      ///     Always hide,but it will deal with scroll function
                      ///   </para>
                      /// </summary>
                      sbstHide
                      );




  /// <summary>
  ///   <para>
  ///     滚动控件内嵌类型
  ///   </para>
  ///   <para>
  ///     Embeded type of Scroll control
  ///   </para>
  /// </summary>
  TScrollBarEmbeddedType=(
                          /// <summary>
                          ///   虚拟的
                          ///   <para>
                          ///   Virtual
                          ///   </para>
                          /// </summary>
                          sbetVirtualControl,
                          /// <summary>
                          ///   真实的
                          ///   <para>
                          ///   Actual
                          ///   </para>
                          /// </summary>
                          sbetActualControl
                          );






  /// <summary>
  ///   <para>
  ///     滚动控件属性
  ///   </para>
  ///   <para>
  ///     Scroll control properties
  ///   </para>
  /// </summary>
  TScrollControlProperties=class(TSkinControlProperties)
  protected

    //内容宽度,如果为-1,表示使用控制的宽度
    FContentWidth:Double;
    //内容高度,如果为-1,表示使用控制的高度
    FContentHeight:Double;


    //滚动条嵌入类型
    FScrollBarEmbeddedType: TScrollBarEmbeddedType;


    //滚动条显示类型
    FHorzScrollBarShowType: TScrollBarShowType;
    FVertScrollBarShowType: TScrollBarShowType;


    //水平手势管理者
    FHorzControlGestureManager: TSkinControlGestureManager;
    //垂直手势管理者
    FVertControlGestureManager: TSkinControlGestureManager;


    FIsProcessGestureInScrollBox: Boolean;


    FSkinScrollControlIntf:ISkinScrollControl;


    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;






    //内容尺寸更改事件
    procedure DoContentWidthChange;virtual;
    procedure DoContentHeightChange;virtual;

    //设置内容尽寸
    procedure SetContentWidth(const Value: Double);
    procedure SetContentHeight(const Value: Double);


    procedure SetHorzScrollBarShowType(const Value: TScrollBarShowType);
    procedure SetVertScrollBarShowType(const Value: TScrollBarShowType);
    procedure SetScrollBarEmbeddedType(const Value: TScrollBarEmbeddedType);
  public
    //自动计算内容尺寸
    function CalcContentHeight:Double;virtual;
    function CalcContentWidth:Double;virtual;

    //获取内容尺寸,UpdateScrollBars中调用
    function GetContentHeight: Double;virtual;
    function GetContentWidth: Double;virtual;


    //更新滚动条
    procedure UpdateScrollBars;


    //获取客户区矩形
    function GetClientRect:TRectF;virtual;



    //获取滚动条所在矩形
    function GetVertScrollBarRect:TRectF;
    function GetHorzScrollBarRect:TRectF;
    function GetScrollControlCornerRect:TRectF;


    //滚动条是否显示(获取客户区的绘制区域)
    function GetVertScrollBarVisible:Boolean;
    function GetHorzScrollBarVisible:Boolean;
    function GetScrollControlCornerVisible:Boolean;


    //滚动条是否存在
    function HasVertScrollBar:Boolean;
    function HasHorzScrollBar:Boolean;


    //绘制偏移
    function GetTopDrawOffset:Double;virtual;
    function GetLeftDrawOffset:Double;virtual;
    function GetRightDrawOffset:Double;virtual;
    function GetBottomDrawOffset:Double;virtual;
  private
    {$IFDEF FMX}
    function IsSelfBottomNotShowed: Boolean;
    {$ENDIF FMX}

  protected


    //是否启动下拉刷新面板
    FEnableAutoPullDownRefreshPanel: Boolean;
    //是否启动上拉加载面板
    FEnableAutoPullUpLoadMorePanel: Boolean;


    FAutoPullDownRefreshPanel:TSkinChildPullLoadPanel;
    FAutoPullUpLoadMorePanel:TSkinChildPullLoadPanel;


    //下拉或右拉加载面板
    FPullDownRefreshPanelControlIntf: ISkinControl;
    FPullDownRefreshPanelIntf: ISkinPullLoadPanel;



    //上拉或左拉加载面板
    FPullUpLoadMorePanelControlIntf: ISkinControl;
    FPullUpLoadMorePanelIntf: ISkinPullLoadPanel;

    function CreatePullLoadPanel(APullLoadPanelMaterial:TSkinPullLoadPanelDefaultMaterial):TSkinChildPullLoadPanel;

    //自动创建下拉刷新面板
    procedure AutoCreatePullDownRefreshPanel;
    procedure AutoCreatePullUpLoadMorePanel;


    procedure CheckMinPullLoadPanel(const Value: TChildControl);
    procedure CheckMaxPullLoadPanel(const Value: TChildControl);


    function GetAutoPullDownRefreshPanel: TSkinChildPullLoadPanel;
    function GetAutoPullUpLoadMorePanel: TSkinChildPullLoadPanel;


    function GetPullDownRefreshPanel:TChildControl;
    function GetPullUpLoadMorePanel:TChildControl;
    //设置下拉加载面板
    procedure SetPullDownRefreshPanel(const Value: TChildControl);
    //设置上拉加载面板
    procedure SetPullUpLoadMorePanel(const Value: TChildControl);



    //滚动条可以越界的类型
    function GetVertCanOverRangeTypes: TCanOverRangeTypes;
    procedure SetVertCanOverRangeTypes(const Value: TCanOverRangeTypes);
    function GetHorzCanOverRangeTypes: TCanOverRangeTypes;
    procedure SetHorzCanOverRangeTypes(const Value: TCanOverRangeTypes);


    //判断用户是否停止了滚动
    procedure DoVert_InnerDragingStateChange(Sender:TObject);virtual;
    procedure DoHorz_InnerDragingStateChange(Sender:TObject);virtual;

    procedure DoVert_InnerPositionBeforeChange(Sender:TObject);virtual;
    procedure DoHorz_InnerPositionBeforeChange(Sender:TObject);virtual;

    //控件手势管理者位置更改,相应更改滚动条的位置
    procedure DoVert_InnerPositionChange(Sender:TObject);virtual;
    procedure DoHorz_InnerPositionChange(Sender:TObject);virtual;


    //滚回到初始开始(用于居中选择滑动后滚回到最近的Item)
    procedure DoVert_InnerScrollToInitialAnimateBegin(Sender:TObject);virtual;
    procedure DoHorz_InnerScrollToInitialAnimateBegin(Sender:TObject);virtual;
    //滚回到初始结束(用于居中选择滑动后滚回到最近的Item)
    procedure DoVert_InnerScrollToInitialAnimateEnd(Sender:TObject);virtual;
    procedure DoHorz_InnerScrollToInitialAnimateEnd(Sender:TObject);virtual;


    //控件手势管理者最小值越界,显示下拉加载面板
    procedure DoVert_InnerMinOverRangePosValueChange(Sender:TObject;
                                                                NextValue:Double;
                                                                LastValue:Double;
                                                                Step:Double;
                                                                var NewValue:Double;
                                                                var CanChange:Boolean);virtual;
    procedure DoHorz_InnerMinOverRangePosValueChange(Sender:TObject;
                                                                NextValue:Double;
                                                                LastValue:Double;
                                                                Step:Double;
                                                                var NewValue:Double;
                                                                var CanChange:Boolean);virtual;
    //控件手势管理者最大值越界,显示上拉加载面板
    procedure DoVert_InnerMaxOverRangePosValueChange(Sender:TObject;
                                                                NextValue:Double;
                                                                LastValue:Double;
                                                                Step:Double;
                                                                var NewValue:Double;
                                                                var CanChange:Boolean);virtual;
    procedure DoHorz_InnerMaxOverRangePosValueChange(Sender:TObject;
                                                                NextValue:Double;
                                                                LastValue:Double;
                                                                Step:Double;
                                                                var NewValue:Double;
                                                                var CanChange:Boolean);virtual;

    //计算需要惯性滚动的距离
    procedure DoVert_InnerCalcInertiaScrollDistance(Sender:TObject;
                                                  var InertiaDistance:Double;
                                                  var CanInertiaScroll:Boolean
                                                  );virtual;
    procedure DoHorz_InnerCalcInertiaScrollDistance(Sender:TObject;
                                                  var InertiaDistance:Double;
                                                  var CanInertiaScroll:Boolean
                                                  );virtual;

    //惯性滚动结束事件
    procedure DoVert_InnerInertiaScrollAnimateBegin(Sender:TObject);virtual;
    procedure DoHorz_InnerInertiaScrollAnimateBegin(Sender:TObject);virtual;

    //惯性滚动结束事件
    procedure DoHorz_InnerInertiaScrollAnimateEnd(Sender:TObject;
                                                var CanStartScrollToInitial:Boolean;
                                                var AMinOverRangePosValue_Min:Double;
                                                var AMaxOverRangePosValue_Min:Double);virtual;
    procedure DoVert_InnerInertiaScrollAnimateEnd(Sender:TObject;
                                                var CanStartScrollToInitial:Boolean;
                                                var AMinOverRangePosValue_Min:Double;
                                                var AMaxOverRangePosValue_Min:Double);virtual;

  public
    //底部空间,留给全选/全不选的CheckBox
    FClientMarginBottom:TControlSize;
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public

    property SkinScrollControlIntf:ISkinScrollControl read FSkinScrollControlIntf;
  public
    procedure StartPullDownRefresh;
    procedure StartPullUpLoadMore;
    //结束下拉刷新
    procedure StopPullDownRefresh(const ALoadingStopCaption:String='刷新成功!';const AWaitHintTime:Integer=600);
    //结束上拉加载
    procedure StopPullUpLoadMore(const ALoadingStopCaption:String='刷新成功!';const AWaitHintTime:Integer=0;const AHasLoadMoreDataNeedScroll:Boolean=False);

    property AutoPullDownRefreshPanel:TSkinChildPullLoadPanel read GetAutoPullDownRefreshPanel;
    property AutoPullUpLoadMorePanel:TSkinChildPullLoadPanel read GetAutoPullUpLoadMorePanel;

    //水平手势管理者
    property HorzControlGestureManager: TSkinControlGestureManager read FHorzControlGestureManager;
    //垂直手势管理者
    property VertControlGestureManager: TSkinControlGestureManager read FVertControlGestureManager;

    //滚动条的嵌入类型
    property ScrollBarEmbeddedType:TScrollBarEmbeddedType read FScrollBarEmbeddedType write SetScrollBarEmbeddedType;
  public
    //当ListBox在ScrollBox上面时是否处理手势
    property IsProcessGestureInScrollBox:Boolean read FIsProcessGestureInScrollBox write FIsProcessGestureInScrollBox;
  published


    /// <summary>
    ///   <para>
    ///     内容宽度(-1表示自动计算)
    ///   </para>
    ///   <para>
    ///     Content width(-1 means calculate automaticly)
    ///   </para>
    /// </summary>
    property ContentWidth:Double read FContentWidth write SetContentWidth;

    /// <summary>
    ///   <para>
    ///     内容高度(-1表示自动计算)
    ///   </para>
    ///   <para>
    ///     Content height(-1 means calculate automaticly)
    ///   </para>
    /// </summary>
    property ContentHeight:Double read FContentHeight write SetContentHeight;



    /// <summary>
    ///   <para>
    ///     下拉加载面板
    ///   </para>
    ///   <para>
    ///     Pulldown load panel
    ///   </para>
    /// </summary>
    property PullDownRefreshPanel:TChildControl read GetPullDownRefreshPanel write SetPullDownRefreshPanel;
    //是否启用自动下拉刷新面板
    property EnableAutoPullDownRefreshPanel:Boolean read FEnableAutoPullDownRefreshPanel write FEnableAutoPullDownRefreshPanel;

    /// <summary>
    ///   <para>
    ///     上拉加载面板
    ///   </para>
    ///   <para>
    ///     Pullup load panel
    ///   </para>
    /// </summary>
    property PullUpLoadMorePanel:TChildControl read GetPullUpLoadMorePanel write SetPullUpLoadMorePanel;
    //是否启动自动上拉加载更多面板
    property EnableAutoPullUpLoadMorePanel:Boolean read FEnableAutoPullUpLoadMorePanel write FEnableAutoPullUpLoadMorePanel;

    /// <summary>
    ///   <para>
    ///     允许越界的类型(最小值越界,或最大值越界)
    ///   </para>
    ///   <para>
    ///     Type of over range(cross border at min,or cross border at max)
    ///   </para>
    /// </summary>
    property VertCanOverRangeTypes:TCanOverRangeTypes read GetVertCanOverRangeTypes write SetVertCanOverRangeTypes;
    /// <summary>
    ///   <para>
    ///     允许越界的类型(最小值越界,或最大值越界)
    ///   </para>
    ///   <para>
    ///     Type of over range(cross border at min,or cross border at max)
    ///   </para>
    /// </summary>
    property HorzCanOverRangeTypes:TCanOverRangeTypes read GetHorzCanOverRangeTypes write SetHorzCanOverRangeTypes;



    /// <summary>
    ///   <para>
    ///     垂直滚动条显示类型
    ///   </para>
    ///   <para>
    ///     Show type of vertical scrollbar
    ///   </para>
    /// </summary>
    property VertScrollBarShowType:TScrollBarShowType read FVertScrollBarShowType write SetVertScrollBarShowType;// default sbstAlwaysShow;

    /// <summary>
    ///   <para>
    ///     水平滚动条显示类型
    ///   </para>
    ///   <para>
    ///     Show Type of horizontal scrollbar
    ///   </para>
    /// </summary>
    property HorzScrollBarShowType:TScrollBarShowType read FHorzScrollBarShowType write SetHorzScrollBarShowType;// default sbstAlwaysShow;
  end;










  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     滚动控件素材基类
  ///   </para>
  ///   <para>
  ///     Base class of Scroll control material
  ///   </para>
  /// </summary>
  TSkinScrollControlMaterial=class(TSkinControlMaterial)
  private
    FPullDownRefreshPanelMaterial: TSkinPullLoadPanelDefaultMaterial;
    FPullUpLoadMorePanelMaterial: TSkinPullLoadPanelDefaultMaterial;
    procedure SetPullDownRefreshPanelMaterial(const Value: TSkinPullLoadPanelDefaultMaterial);
    procedure SetPullUpLoadMorePanelMaterial(const Value: TSkinPullLoadPanelDefaultMaterial);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //下拉刷新面板素材
    property PullDownRefreshPanelMaterial: TSkinPullLoadPanelDefaultMaterial read FPullDownRefreshPanelMaterial write SetPullDownRefreshPanelMaterial;
    //上拉加载更多面板素材
    property PullUpLoadMorePanelMaterial: TSkinPullLoadPanelDefaultMaterial read FPullUpLoadMorePanelMaterial write SetPullUpLoadMorePanelMaterial;
  end;

  TSkinScrollControlType=class(TSkinControlType)
  protected
    FDrawRectCenterItemSelectModeTopOffset,
    FDrawRectCenterItemSelectModeLeftOffset,

    FDrawRectTopOffset,
    FDrawRectLeftOffset,
    FDrawRectRightOffset,
    FDrawRectBottomOffset:Double;

    FSkinScrollControlIntf:ISkinScrollControl;


    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);override;
    function CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;


    procedure SizeChanged;override;

    //键盘事件
    procedure KeyDown(Key: Word; Shift: TShiftState);override;
    procedure KeyUp(Key: Word; Shift: TShiftState);override;



//  protected
//
//    //鼠标事件是否可以传递给父Scroll控件
//    function MouseDownEventCanTransWhenParentIsScrollBox:Boolean;override;
//    function MouseMoveEventCanTransWhenParentIsScrollBox:Boolean;override;
//    function MouseUpEventCanTransWhenParentIsScrollBox:Boolean;override;

  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //自定义绘制方法
    function CustomPaintContent(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;virtual;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollControlDefaultMaterial=class(TSkinScrollControlMaterial);
  TSkinScrollControlDefaultType=TSkinScrollControlType;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollControl=class(TBaseSkinControl,ISkinScrollControl)
  private
    function GetScrollControlProperties:TScrollControlProperties;
    procedure SetScrollControlProperties(Value:TScrollControlProperties);
  protected

    //角
    FScrollControlCorner:TSkinChildScrollControlCorner;
    FScrollControlCornerControlIntf:ISkinControl;
//    FScrollControlCornerComponentIntf:ISkinComponent;
    FScrollControlCornerIntf:ISkinScrollControlCorner;


    //垂直滚动条
    FVertScrollBar:TSkinChildScrollBar;
    FVertScrollBarControlIntf:ISkinControl;
//    FVertScrollBarComponentIntf:ISkinComponent;
    FVertScrollBarIntf:ISkinScrollBar;


    //水平滚动条
    FHorzScrollBar:TSkinChildScrollBar;
    FHorzScrollBarControlIntf:ISkinControl;
//    FHorzScrollBarComponentIntf:ISkinComponent;
    FHorzScrollBarIntf:ISkinScrollBar;


    function GetVertScrollBar: TSkinChildScrollBar;
    procedure SetVertScrollBar(Value: TSkinChildScrollBar);

    procedure SetHorzScrollBar(Value: TSkinChildScrollBar);
    function GetHorzScrollBar: TSkinChildScrollBar;


    procedure SetScrollControlCorner(Value: TSkinChildScrollControlCorner);
    function GetScrollControlCorner: TSkinChildScrollControlCorner;

  protected
    //绘制内容
    FOnPaintContent:TSkinControlPaintEvent;

    FOnPullDownRefresh:TNotifyEvent;
    FOnPullUpLoadMore:TNotifyEvent;

    function GetOnPaintContent:TSkinControlPaintEvent;

    function GetOnPullDownRefresh:TNotifyEvent;
    function GetOnPullUpLoadMore:TNotifyEvent;

  protected


    //滚动条需要刷新的时候重绘一下
    procedure DoScrollBarInvalidate(Sender:TObject);

//    //滚动条更改事件
//    procedure DoHorzScrollBarPositionChange(Sender:TObject);virtual;
//    procedure DoVertScrollBarPositionChange(Sender:TObject);virtual;


//    procedure Paint;override;

    //绘制滚动条
    procedure AfterPaint; {$IFDEF FMX}override;{$ENDIF}


    //加载
    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    property Prop:TScrollControlProperties read GetScrollControlProperties write SetScrollControlProperties;
  public

    //垂直滚动条
    procedure FreeVertScrollBar;
    function GetVertScrollBarIntf:ISkinScrollBar;
    function GetVertScrollBarControlIntf:ISkinControl;


    //水平滚动条
    procedure FreeHorzScrollBar;
    function GetHorzScrollBarIntf:ISkinScrollBar;
    function GetHorzScrollBarControlIntf:ISkinControl;

    //滚动框角
    procedure FreeScrollControlCorner;
    function GetScrollControlCornerIntf:ISkinScrollControlCorner;
    function GetScrollControlCornerControlIntf:ISkinControl;

  public
    function SelfOwnMaterialToDefault:TSkinScrollControlDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinScrollControlDefaultMaterial;
    function Material:TSkinScrollControlDefaultMaterial;
  published

    //垂直滚动条
    property VertScrollBar: TSkinChildScrollBar read GetVertScrollBar write SetVertScrollBar;
    //水平滚动条
    property HorzScrollBar: TSkinChildScrollBar read GetHorzScrollBar write SetHorzScrollBar;
    //滚动框角
    property ScrollControlCorner: TSkinChildScrollControlCorner read GetScrollControlCorner write SetScrollControlCorner;


    //绘制内容事件
    property OnPaintContent:TSkinControlPaintEvent read FOnPaintContent write FOnPaintContent;
    //下拉刷新事件
    property OnPullDownRefresh:TNotifyEvent read FOnPullDownRefresh write FOnPullDownRefresh;
    //上拉加载更多事件
    property OnPullUpLoadMore:TNotifyEvent read FOnPullUpLoadMore write FOnPullUpLoadMore;


    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TScrollControlProperties read GetScrollControlProperties write SetScrollControlProperties;
  end;



  {$IFDEF VCL}
  TSkinWinScrollControl=class(TSkinScrollControl)
  end;
  {$ENDIF VCL}




implementation



procedure PaintIndicator(ADrawPicture:TDrawPicture;ARotationAngle:Double;ASize:Integer;AColor:TDelphiColor);
{$IFDEF FMX}
var
  a: Integer;
  P, P2: TPointF;
  wSize, eSize: Single;
  V: Single;
  Fill: TBrush;
  Stroke: TStrokeBrush;
//  LRotatedControl: IRotatedControl;
var
  TranslateMatrix, ScaleMatrix, RotMatrix: TMatrix;
  M1, M2: TMatrix;
  FLocalMatrix:TMatrix;
{$ENDIF}
begin

//  OutputDebugString('PaintIndicator Begin ASize='+IntToStr(ASize));
//  uBaseLog.OutputDebugString('PaintIndicator '
//      +TCanvasManager.DefaultCanvas.ClassName+','
//      +IntToStr(TCanvasManager.DefaultCanvas.GetAttribute(TCanvasAttribute.MaxBitmapSize))
//      );



  {$IFDEF FMX}
  ADrawPicture.SetSize(Ceil(ASize*Const_BufferBitmapScale),
                      Ceil(ASize*Const_BufferBitmapScale));
  ADrawPicture.BitmapScale:=Const_BufferBitmapScale;
  ADrawPicture.Canvas.BeginScene();
  try
    ADrawPicture.Canvas.Clear(0);

    if not SameValue(ARotationAngle, 0.0, 0.001) then//TEpsilon.Scale) then
    begin
      // scale
      ScaleMatrix := TMatrix.Identity;
      ScaleMatrix.m11 := 1;
      ScaleMatrix.m22 := 1;
      FLocalMatrix := ScaleMatrix;
      // rotation
      if ARotationAngle <> 0 then
      begin
        M1 := TMatrix.Identity;
        M1.m31 := -0.5 * ASize * 1;
        M1.m32 := -0.5 * ASize * 1;
        M2 := TMatrix.Identity;
        M2.m31 := 0.5 * ASize * 1;
        M2.m32 := 0.5 * ASize * 1;
        RotMatrix := M1 * (TMatrix.CreateRotation(DegToRad(ARotationAngle)) * M2);
        FLocalMatrix := FLocalMatrix * RotMatrix;
      end;
      // translate
      TranslateMatrix := TMatrix.Identity;
      TranslateMatrix.m31 := 0;
      TranslateMatrix.m32 := 0;
      FLocalMatrix := FLocalMatrix * TranslateMatrix;
    end
    else
    begin
      FLocalMatrix := TMatrix.Identity;
      FLocalMatrix.m31 := 0;
      FLocalMatrix.m32 := 0;
      FLocalMatrix.m11 := 1;
      FLocalMatrix.m22 := 1;
    end;

    ADrawPicture.Canvas.SetMatrix(FLocalMatrix);


    wSize:=ASize / 2;
    eSize := wSize / 3.7;
    wSize := wSize - eSize;

//    case FStyle of
//      TAniIndicatorStyle.Linear:
//        begin
          Stroke := TStrokeBrush.Create(TBrushKind.Solid, AColor);
          Stroke.Thickness := eSize / 2;
          for a := 0 to 11 do
          begin
            P := PointF(ASize / 2 + (cos(DegToRad(a * 30)) * wSize), ASize / 2 + (sin(DegToRad(a * 30)) * wSize));
            P2 := PointF(ASize / 2 + (cos(DegToRad(a * 30)) * (wSize / 2)), ASize / 2 + (sin(DegToRad(a * 30)) * (wSize / 2)));
            ADrawPicture.Canvas.DrawLine(P, P2, 1 * 0.2, Stroke);

            V := ((trunc(ARotationAngle) + (30 - trunc((a / 12) * 30))) mod 30) / 30;
            if V > 1 then
              V := Abs(V - 2);
            V := 1 - V;
            ADrawPicture.Canvas.DrawLine(P, P2, V * 1, Stroke);

          end;
          Stroke.Free;
//        end;
//      TAniIndicatorStyle.Circular:
//        begin
//          Fill := TBrush.Create(TBrushKind.Solid, AColor);
//          for a := 0 to 7 do
//          begin
//            P := PointF(ASize / 2 + (cos(DegToRad(a * 45)) * wSize), ASize / 2 + (sin(DegToRad(a * 45)) * wSize));
//            ADrawPicture.Canvas.FillEllipse(RectF(P.X - eSize, P.Y - eSize, P.X + eSize, P.Y + eSize), 1 * 0.2, Fill);
////            if Enabled then
////            begin
//              V := ((trunc(ARotationAngle) + (30 - trunc((a / 7) * 30))) mod 30) / 30;
//              if V > 1 then
//                V := Abs(V - 2);
//              V := 1 - V;
//              ADrawPicture.Canvas.FillEllipse(RectF(P.X - eSize, P.Y - eSize, P.X + eSize, P.Y + eSize), V * 1, Fill);
////            end;
//          end;
//          Fill.Free;
//        end;
//    end;
//  end;
  finally
    ADrawPicture.Canvas.EndScene;
  end;
  {$ENDIF}

//  OutputDebugString('PaintIndicator End');
end;

function CreateIndicatorImageList(ASize:Integer;AColor:TDelphiColor):TSkinImageList;
var
  I: Integer;
  ADrawPicture:TDrawPicture;
begin
  Result:=TSkinImageList.Create(nil);
  for I := 0 to 11 do
  begin
    ADrawPicture:=Result.PictureList.Add;
    PaintIndicator(ADrawPicture,I*30,ASize,AColor);
  end;
end;





{ TScrollControlProperties }


function TScrollControlProperties.CalcContentHeight: Double;
begin
  Result:=Self.FSkinControlIntf.Height;
end;

function TScrollControlProperties.CalcContentWidth: Double;
begin
  Result:=Self.FSkinControlIntf.Width;
end;


procedure TScrollControlProperties.CheckMaxPullLoadPanel(const Value: TChildControl);
begin
    if Value<>nil then
    begin
        if Not Value.GetInterface(IID_ISkinPullLoadPanel,Self.FPullUpLoadMorePanelIntf) then
        begin
          ShowException('This Component Do not Support ISkinPullLoadPanel Interface');
        end
        else
        begin
          if Not Value.GetInterface(IID_ISkinControl,Self.FPullUpLoadMorePanelControlIntf) then
          begin
            ShowException('This Component Do not Support ISkinControl Interface');
          end
          else
          begin

            AddFreeNotification(Value,Self.FSkinControl);

            FPullUpLoadMorePanelIntf.Prop.LoadPanelType:=sborlptBottom;
            FPullUpLoadMorePanelIntf.Prop.FControlGestureManager:=FVertControlGestureManager;

          end;
        end;
    end
    else
    begin
        FPullUpLoadMorePanelIntf := nil;
        FPullUpLoadMorePanelControlIntf := nil;
    end;

end;

procedure TScrollControlProperties.CheckMinPullLoadPanel(const Value: TChildControl);
begin
    if Value<>nil then
    begin

        if Not Value.GetInterface(IID_ISkinPullLoadPanel,Self.FPullDownRefreshPanelIntf) then
        begin
          ShowException('This Component Do not Support ISkinPullLoadPanel Interface');
        end
        else
        begin
          if Not Value.GetInterface(IID_ISkinControl,Self.FPullDownRefreshPanelControlIntf) then
          begin
            ShowException('This Component Do not Support ISkinControl Interface');
          end
          else
          begin

            AddFreeNotification(Value,Self.FSkinControl);

            FPullDownRefreshPanelIntf.Prop.LoadPanelType:=sborlptTop;
            FPullDownRefreshPanelIntf.Prop.FControlGestureManager:=FVertControlGestureManager;

          end;
        end;

    end
    else
    begin
        FPullDownRefreshPanelIntf := nil;
        FPullDownRefreshPanelControlIntf := nil;
    end;

end;

procedure TScrollControlProperties.AutoCreatePullDownRefreshPanel;
begin

  if Self.FEnableAutoPullDownRefreshPanel and (FVertControlGestureManager.MinPullLoadPanel=nil) then
  begin
      //如果启动自动下拉刷新面板,并且没有设置自定义的面板
      //那么自动创建
      if (FAutoPullDownRefreshPanel=nil) then
      begin

          FAutoPullDownRefreshPanel:=CreatePullLoadPanel(TSkinScrollControlMaterial(FSkinControlIntf.GetCurrentUseMaterial).FPullDownRefreshPanelMaterial);
          FAutoPullDownRefreshPanel.OnExecuteLoad:=Self.FSkinScrollControlIntf.OnPullDownRefresh;
          Self.CheckMinPullLoadPanel(FAutoPullDownRefreshPanel);

      end;
  end
  else
  begin
      //如果FPullDownRefreshPanelControlIntf接口为空,那么获取
      if (FPullDownRefreshPanelControlIntf=nil) and (FVertControlGestureManager.MinPullLoadPanel<>nil) then
      begin
        Self.CheckMinPullLoadPanel(FVertControlGestureManager.MinPullLoadPanel);
      end;
      //如果MinPullLoadPanel为空,那么设置FPullDownRefreshPanelControlIntf也为空
      if (FPullDownRefreshPanelControlIntf<>nil) and (FVertControlGestureManager.MinPullLoadPanel=nil) then
      begin
        Self.CheckMinPullLoadPanel(nil);
      end;
  end;

end;

procedure TScrollControlProperties.AutoCreatePullUpLoadMorePanel;
begin

  if Self.FEnableAutoPullUpLoadMorePanel and (FVertControlGestureManager.MaxPullLoadPanel=nil) then
  begin
      //自动创建上拉加载更多面板
      //如果启动自动下拉刷新面板,并且没有设置自定义的面板
      //那么自动创建
      if (FAutoPullUpLoadMorePanel=nil) then
      begin

          FAutoPullUpLoadMorePanel:=CreatePullLoadPanel(
              TSkinScrollControlMaterial(FSkinControlIntf.GetCurrentUseMaterial).FPullUpLoadMorePanelMaterial
              );
          FAutoPullUpLoadMorePanel.OnExecuteLoad:=Self.FSkinScrollControlIntf.OnPullUpLoadMore;
          Self.CheckMaxPullLoadPanel(FAutoPullUpLoadMorePanel);

      end;
  end
  else
  begin
      if (FPullUpLoadMorePanelControlIntf=nil) and (FVertControlGestureManager.MaxPullLoadPanel<>nil) then
      begin
        Self.CheckMaxPullLoadPanel(FVertControlGestureManager.MaxPullLoadPanel);
      end;
      if (FPullUpLoadMorePanelControlIntf<>nil) and (FVertControlGestureManager.MaxPullLoadPanel=nil) then
      begin
        Self.CheckMaxPullLoadPanel(nil);
      end;
  end;

end;

constructor TScrollControlProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinScrollControl,Self.FSkinScrollControlIntf) then
  begin
    ShowException('This Component Do not Support ISkinScrollControl Interface');
  end
  else
  begin

      //内容宽度
      FContentWidth:=0;
      //内容高度
      FContentHeight:=0;


      //下拉或右拉加载面板
      FPullDownRefreshPanelControlIntf:=nil;
      FPullDownRefreshPanelIntf:=nil;



      //上拉或左拉加载面板
      FPullUpLoadMorePanelControlIntf:=nil;
      FPullUpLoadMorePanelIntf:=nil;


      //滚动条的嵌入类型
      FScrollBarEmbeddedType:=sbetVirtualControl;


      //自动隐藏显示滚动条
      FHorzScrollBarShowType:=sbstNone;
      FVertScrollBarShowType:=sbstAutoCoverShow;



      //初始尺寸
      FSkinControlIntf.Width:=100;
      FSkinControlIntf.Height:=100;


      //水平手势管理
      FHorzControlGestureManager:=TSkinControlGestureManager.Create(nil,Self.FSkinControl);

      FHorzControlGestureManager.OnInnerScrollToInitialAnimateBegin:=DoHorz_InnerScrollToInitialAnimateBegin;
      FHorzControlGestureManager.OnInnerScrollToInitialAnimateEnd:=DoHorz_InnerScrollToInitialAnimateEnd;

      FHorzControlGestureManager.OnInnerCalcInertiaScrollDistance:=Self.DoHorz_InnerCalcInertiaScrollDistance;
      FHorzControlGestureManager.OnInnerInertiaScrollAnimateBegin:=Self.DoHorz_InnerInertiaScrollAnimateBegin;
      FHorzControlGestureManager.OnInnerInertiaScrollAnimateEnd:=Self.DoHorz_InnerInertiaScrollAnimateEnd;

      FHorzControlGestureManager.OnInnerDragingStateChange:=Self.DoHorz_InnerDragingStateChange;
      //当前位置更改
      FHorzControlGestureManager.OnInnerPositionChange:=DoHorz_InnerPositionChange;
      FHorzControlGestureManager.OnInnerPositionBeforeChange:=DoHorz_InnerPositionBeforeChange;
      //最小值越界更改
      FHorzControlGestureManager.OnInnerMinOverRangePosValueChange:=DoHorz_InnerMinOverRangePosValueChange;
      //最大值越界更改
      FHorzControlGestureManager.OnInnerMaxOverRangePosValueChange:=DoHorz_InnerMaxOverRangePosValueChange;






      //垂直手持管理
      FVertControlGestureManager:=TSkinControlGestureManager.Create(nil,Self.FSkinControl);

      FVertControlGestureManager.OnInnerScrollToInitialAnimateBegin:=DoVert_InnerScrollToInitialAnimateBegin;
      FVertControlGestureManager.OnInnerScrollToInitialAnimateEnd:=DoVert_InnerScrollToInitialAnimateEnd;

      FVertControlGestureManager.OnInnerCalcInertiaScrollDistance:=Self.DoVert_InnerCalcInertiaScrollDistance;
      FVertControlGestureManager.OnInnerInertiaScrollAnimateBegin:=Self.DoVert_InnerInertiaScrollAnimateBegin;
      FVertControlGestureManager.OnInnerInertiaScrollAnimateEnd:=Self.DoVert_InnerInertiaScrollAnimateEnd;

      FVertControlGestureManager.OnInnerDragingStateChange:=Self.DoVert_InnerDragingStateChange;
      //当前位置更改
      FVertControlGestureManager.OnInnerPositionChange:=DoVert_InnerPositionChange;
      FVertControlGestureManager.OnInnerPositionBeforeChange:=DoVert_InnerPositionBeforeChange;
      //最小值越界更改
      FVertControlGestureManager.OnInnerMinOverRangePosValueChange:=DoVert_InnerMinOverRangePosValueChange;
      //最大值越界更改
      FVertControlGestureManager.OnInnerMaxOverRangePosValueChange:=DoVert_InnerMaxOverRangePosValueChange;


  end;
end;

function TScrollControlProperties.CreatePullLoadPanel(APullLoadPanelMaterial:TSkinPullLoadPanelDefaultMaterial): TSkinChildPullLoadPanel;
var
  ACenterPanel:TSkinChildPanel;
  ALoadingLabel:TSkinChildLabel;
  ALoadingImage:TSkinChildImage;
begin
  //自动创建下拉刷新面板
  Result:=TSkinChildPullLoadPanel.Create(Self.FSkinControl);
  Result.Width:=Self.FSkinControl.Width;
  //默认高度
  Result.Height:=60;
  Result.SkinControlType;
  Result.MaterialUseKind := mukRef;
  Result.RefMaterial:=APullLoadPanelMaterial;
  Result.Visible:=True;
  Result.Parent:=TParentControl(Self.FSkinControl);
  {$IFDEF FMX}
  Result.Stored:=False;
  {$ENDIF}


  //居中面板
  ACenterPanel:=TSkinChildPanel.Create(Result);
  ACenterPanel.Width:=320;
  ACenterPanel.Height:=Result.Height;
  ACenterPanel.Parent:=Result;
  {$IFDEF FMX}
  ACenterPanel.Align:=TAlignLayout.Center;
  {$ENDIF}


  //加载图片
  ALoadingImage:=TSkinChildImage.Create(Result);
  ALoadingImage.Left:=80;
  ALoadingImage.Width:=40;
  ALoadingImage.Height:=40;
  ALoadingImage.Prop.RotateSpeed:=10;
  ALoadingImage.Top:=ControlSize((Result.Height-ALoadingImage.Height) / 2);
  ALoadingImage.Parent:=ACenterPanel;
  ALoadingImage.SkinControlType;
  ALoadingImage.SelfOwnMaterial;
  ALoadingImage.SelfOwnMaterialToDefault.DrawPictureParam.IsAutoFit:=True;
  ALoadingImage.Prop.Picture.Assign(
        APullLoadPanelMaterial.LoadingPicture
        );
  if APullLoadPanelMaterial.LoadingPicture.IsEmpty then
  begin
    //自动生成ImageList
    if APullLoadPanelMaterial.FAutoCreatedIndicatorImageList=nil then
    begin
      APullLoadPanelMaterial.FAutoCreatedIndicatorImageList:=CreateIndicatorImageList(
                  40,//Ceil(ALoadingImage.Width),
                  APullLoadPanelMaterial.IndicatorColor);
    end;
    ALoadingImage.Prop.Picture.SkinImageList:=APullLoadPanelMaterial.FAutoCreatedIndicatorImageList;
    ALoadingImage.Prop.Picture.ImageIndex:=0;
  end;



  //正在加载标签
  ALoadingLabel:=TSkinChildLabel.Create(Result);
  ALoadingLabel.Height:=25;
  ALoadingLabel.Width:=200;
  ALoadingLabel.Left:=ALoadingImage.Left+ALoadingImage.Width+20;
  ALoadingLabel.Top:=ControlSize((Result.Height-ALoadingLabel.Height) / 2+5);
  ALoadingLabel.Parent:=ACenterPanel;
  ALoadingLabel.SkinControlType;
  ALoadingLabel.SelfOwnMaterialToDefault.DrawCaptionParam.Assign(APullLoadPanelMaterial.DrawLoadingCaptionParam);


  Result.Prop.LoadingLabel:=ALoadingLabel;
  Result.Prop.LoadingImage:=ALoadingImage;


  Result.Visible:=False;

end;

destructor TScrollControlProperties.Destroy;
begin

  FreeAndNil(FAutoPullDownRefreshPanel);
  FreeAndNil(FAutoPullUpLoadMorePanel);

  FreeAndNil(FHorzControlGestureManager);
  FreeAndNil(FVertControlGestureManager);


  inherited;
end;

procedure TScrollControlProperties.DoContentHeightChange;
begin
end;

procedure TScrollControlProperties.DoContentWidthChange;
begin
end;

procedure TScrollControlProperties.DoVert_InnerPositionBeforeChange(
  Sender: TObject);
begin

end;

procedure TScrollControlProperties.DoVert_InnerPositionChange(Sender:TObject);
var
  AParentScrollBox:TSkinScrollControl;
begin


  if   //处理手势
       (Self.FIsProcessGestureInScrollBox)
       //父控件是SrollBox
    and Self.FSkinControlIntf.GetParentIsScrollBox
      //存在父控件
    and (Self.FSkinControlIntf.GetParentScrollBox<>nil) then
  begin
        AParentScrollBox:=TSkinScrollControl(Self.FSkinControlIntf.GetParentScrollBox);


        //子ListBox鼠标往下移
        //子ListBox的内容滚动到顶部的情况下
        if IsSameDouble(Self.FVertControlGestureManager.Position,Self.FVertControlGestureManager.Min) then
        begin
//            uBaseLog.HandleException(nil,'子ListBox内容滚动到顶了,父ScrollBox滑动');
            //父ScrollBox滑动
            AParentScrollBox.Prop.VertControlGestureManager.FIsNotChangePosition:=False;
            //子ListBox也能滑动
            FVertControlGestureManager.FIsNotChangePosition:=False;
        end
        //子ListBox鼠标往上移
        //子ListBox的内容滚动到底部的情况下
        else
        if IsSameDouble(Self.FVertControlGestureManager.Position,Self.FVertControlGestureManager.Max) then
        begin
//            uBaseLog.HandleException(nil,'子ListBox内容滚动到底了,父ScrollBox滑动');
            FVertControlGestureManager.FIsNotChangePosition:=False;
            AParentScrollBox.Prop.VertControlGestureManager.FIsNotChangePosition:=False;
        end
        //如果子ListBox的底部还没有显示全，
        //并且往上拉MouseMoveDirection=isdScrollToMax，想要显示底部内容的时候,子ListBox不需要滚动,
        //而是父ParentScrollBox滚动,将子ListBox全部显示全
        {$IFDEF FMX}
        else
        if  IsSelfBottomNotShowed
          and (Self.FVertControlGestureManager.MouseMoveDirection=isdScrollToMax) then
        begin
//            if
//            begin

                if IsSameDouble(AParentScrollBox.Prop.VertControlGestureManager.Position,
                                AParentScrollBox.Prop.VertControlGestureManager.Max) then
                begin
                    //往上拉,父ScrollBox滚动到底了
//                    uBaseLog.HandleException(nil,'父ScrollBox滚动到底了,子ListBox滚动');
                    FVertControlGestureManager.FIsNotChangePosition:=False;
                    AParentScrollBox.Prop.VertControlGestureManager.FIsNotChangePosition:=True;
                end
                else
                begin
                    //那么子ListBox不需要滚动
                    //只需要父ScrollBox滚动即可
//                    uBaseLog.HandleException(nil,'子ListBox的底部还没有显示全,不能滚动,父ScrollBox滑动');
                    FVertControlGestureManager.FIsNotChangePosition:=True;
                    AParentScrollBox.Prop.VertControlGestureManager.FIsNotChangePosition:=False;
                end;

//            end
//            ;
        end
        {$ENDIF FMX}
        else
        begin
            //显示全了
//            uBaseLog.HandleException(nil,'子ListBox底部显示全了,父ScrollBox不能滑动');
            FVertControlGestureManager.FIsNotChangePosition:=False;
            AParentScrollBox.Prop.VertControlGestureManager.FIsNotChangePosition:=True;
        end;


  end;

  //刷新
  Invalidate;

end;

procedure TScrollControlProperties.DoHorz_InnerPositionBeforeChange(
  Sender: TObject);
begin

end;

procedure TScrollControlProperties.DoHorz_InnerPositionChange(Sender:TObject);
begin

//  //触发更改事件
//  if Assigned(Self.FSkinScrollBarIntf.OnChange) then
//  begin
//    Self.FSkinScrollBarIntf.OnChange(Self);
//  end;
//
//  if Assigned(Self.FSkinScrollBarIntf.OnInnerChange) then
//  begin
//    Self.FSkinScrollBarIntf.OnInnerChange(Self);
//  end;

  //刷新
  Invalidate;

end;

procedure TScrollControlProperties.DoVert_InnerCalcInertiaScrollDistance(
  Sender: TObject; var InertiaDistance: Double; var CanInertiaScroll: Boolean);
begin

end;

procedure TScrollControlProperties.DoVert_InnerDragingStateChange(Sender: TObject);
begin

  AutoCreatePullDownRefreshPanel;
  AutoCreatePullUpLoadMorePanel;


  if (Self.FPullDownRefreshPanelControlIntf<>nil)
    and (FPullDownRefreshPanelControlIntf.GetSkinControlType<>nil) then
  begin
    //加载面板
    FPullDownRefreshPanelIntf.Prop.
                DoDragingStateChange(Self,
                                  sbVertical,
                                  Self.FVertControlGestureManager.IsDraging,
                                  Self.FVertControlGestureManager.CalcOverRangePosValue(Self.FVertControlGestureManager.MinOverRangePosValue));
  end;

  if (Self.FPullUpLoadMorePanelControlIntf<>nil)
    and (FPullUpLoadMorePanelControlIntf.GetSkinControlType<>nil) then
  begin
    //加载面板
    FPullUpLoadMorePanelIntf.Prop.
                DoDragingStateChange(Self,
                                  sbVertical,
                                  Self.FVertControlGestureManager.IsDraging,
                                  Self.FVertControlGestureManager.CalcOverRangePosValue(Self.FVertControlGestureManager.MaxOverRangePosValue));
  end;


end;

procedure TScrollControlProperties.DoHorz_InnerCalcInertiaScrollDistance(
  Sender: TObject; var InertiaDistance: Double; var CanInertiaScroll: Boolean);
begin

end;

procedure TScrollControlProperties.DoVert_InnerInertiaScrollAnimateBegin(
  Sender: TObject);
begin

end;

procedure TScrollControlProperties.DoVert_InnerInertiaScrollAnimateEnd(
  Sender: TObject;
  var CanStartScrollToInitial: Boolean;
  var AMinOverRangePosValue_Min:Double;
  var AMaxOverRangePosValue_Min:Double);
begin
//  //恢复父ScrollBox可以滚动
//  if Self.FSkinControlIntf.GetSkinControlType.FParentIsScrollBoxContent
//    and (Self.FSkinControlIntf.GetSkinControlType.FParentScrollBox<>nil) then
//  begin
//      //子ListBox滑到顶了,那么父ScrollBox可以滑动了
//      TSkinScrollControl(Self.FSkinControlIntf.GetSkinControlType.FParentScrollBox)
//        .Prop.VertControlGestureManager.FIsNotChangePosition:=False;
//  end;

end;

procedure TScrollControlProperties.DoHorz_InnerDragingStateChange(Sender: TObject);
begin
  AutoCreatePullDownRefreshPanel;
  AutoCreatePullUpLoadMorePanel;


  if (Self.FPullDownRefreshPanelControlIntf<>nil)
    and (FPullDownRefreshPanelControlIntf.GetSkinControlType<>nil) then
  begin
    //加载面板
    FPullDownRefreshPanelIntf.Prop.
                DoDragingStateChange(Self,
                                  sbHorizontal,
                                  Self.FHorzControlGestureManager.IsDraging,
                                  Self.FHorzControlGestureManager.CalcOverRangePosValue(Self.FHorzControlGestureManager.MinOverRangePosValue));
  end;

  if (Self.FPullUpLoadMorePanelControlIntf<>nil)
    and (FPullUpLoadMorePanelControlIntf.GetSkinControlType<>nil) then
  begin
    //加载面板
    FPullUpLoadMorePanelIntf.Prop.
                DoDragingStateChange(Self,
                                  sbHorizontal,
                                  Self.FHorzControlGestureManager.IsDraging,
                                  Self.FHorzControlGestureManager.CalcOverRangePosValue(Self.FHorzControlGestureManager.MaxOverRangePosValue));
  end;

//  if (FPullDownRefreshPanelControlIntf=nil)
//    and (Self.FVertControlGestureManager.FMinPullLoadPanel<>nil) then
//  begin
//    Self.SetPullDownRefreshPanel(Self.FVertControlGestureManager.FMinPullLoadPanel);
//  end;
//
//  if (FPullDownRefreshPanelControlIntf<>nil)
//    and (Self.FVertControlGestureManager.FMinPullLoadPanel=nil) then
//  begin
//    Self.SetPullDownRefreshPanel(Self.FVertControlGestureManager.FMinPullLoadPanel);
//  end;
//
//
//  if (Self.FPullDownRefreshPanelControlIntf<>nil)
//    and (FPullDownRefreshPanelControlIntf.GetSkinControlType<>nil) then
//  begin
//    //加载面板
//    FPullDownRefreshPanelIntf.Prop.
//                DoDragingStateChange(Self,
//                                  Self.FVertControlGestureManager.IsDraging,
//                                  Self.FVertControlGestureManager.CalcOverRangePosValue(Self.FVertControlGestureManager.MinOverRangePosValue));
//  end;
//
//  if (Self.FPullUpLoadMorePanelControlIntf<>nil)
//    and (FPullUpLoadMorePanelControlIntf.GetSkinControlType<>nil) then
//  begin
//    //加载面板
//    FPullUpLoadMorePanelIntf.Prop.
//                DoDragingStateChange(Self,
//                                  Self.FVertControlGestureManager.IsDraging,
//                                  Self.FVertControlGestureManager.CalcOverRangePosValue(Self.FVertControlGestureManager.MaxOverRangePosValue));
//  end;


end;

procedure TScrollControlProperties.DoHorz_InnerInertiaScrollAnimateBegin(
  Sender: TObject);
begin

end;

procedure TScrollControlProperties.DoHorz_InnerInertiaScrollAnimateEnd(
  Sender: TObject;
  var CanStartScrollToInitial: Boolean;
  var AMinOverRangePosValue_Min:Double;
  var AMaxOverRangePosValue_Min:Double);
begin

end;

procedure TScrollControlProperties.DoVert_InnerMinOverRangePosValueChange(Sender:TObject;
                                                            NextValue:Double;
                                                            LastValue:Double;
                                                            Step:Double;
                                                            var NewValue:Double;
                                                            var CanChange:Boolean);
begin
  AutoCreatePullDownRefreshPanel;

  if (Self.FPullDownRefreshPanelControlIntf<>nil)
    and (FPullDownRefreshPanelControlIntf.GetSkinControlType<>nil) then
  begin
    //加载面板
    FPullDownRefreshPanelIntf.Prop.
                DoOverRangePosValueChange(Self,
                                          sbVertical,
                                          Self.FVertControlGestureManager.IsDraging,
                                          Self.FVertControlGestureManager.CalcOverRangePosValue(NewValue),
                                          Self.FVertControlGestureManager.CalcOverRangePosValue(NextValue),
                                          Self.FVertControlGestureManager.CalcOverRangePosValue(LastValue),
                                          NextValue,
                                          LastValue,
                                          Step,
                                          NewValue,
                                          CanChange);
  end;

end;

procedure TScrollControlProperties.DoVert_InnerMaxOverRangePosValueChange(Sender:TObject;
                                                            NextValue:Double;
                                                            LastValue:Double;
                                                            Step:Double;
                                                            var NewValue:Double;
                                                            var CanChange:Boolean);
begin
  AutoCreatePullUpLoadMorePanel;


  if (Self.FPullUpLoadMorePanelControlIntf<>nil) then
  begin
    //加载面板
    FPullUpLoadMorePanelIntf.Prop.
              DoOverRangePosValueChange(Self,sbVertical,
                                        Self.FVertControlGestureManager.IsDraging,
                                        Self.FVertControlGestureManager.CalcOverRangePosValue(NewValue),
                                        Self.FVertControlGestureManager.CalcOverRangePosValue(NextValue),
                                        Self.FVertControlGestureManager.CalcOverRangePosValue(LastValue),
                                        NextValue,LastValue,Step,
                                        NewValue,CanChange);
  end;


end;

procedure TScrollControlProperties.DoHorz_InnerScrollToInitialAnimateBegin(Sender: TObject);
begin
end;

procedure TScrollControlProperties.DoHorz_InnerScrollToInitialAnimateEnd(Sender: TObject);
begin
  //滚回初始的类型

  //滚动到最小值
  if Self.FHorzControlGestureManager.ScrollingToInitialAnimator.Tag=1 then
  begin
      if Self.FPullDownRefreshPanelIntf<>nil then
      begin
        FPullDownRefreshPanelIntf.Prop.DoScrollingToInitialEnd;
      end;


      if (csDesigning in Self.FSkinControl.ComponentState)
        and
        (FAutoPullDownRefreshPanel<>nil)
        {$IFDEF FMX}
        and Not FAutoPullDownRefreshPanel.Stored
        {$ENDIF}
        then
      begin
          //在设计时释放自动创建的下拉加载面板
          Self.CheckMinPullLoadPanel(nil);
          FreeAndNil(FAutoPullDownRefreshPanel);
      end;

  end;

  //滚回到最大值
  if Self.FHorzControlGestureManager.ScrollingToInitialAnimator.Tag=2 then
  begin
      if Self.FPullUpLoadMorePanelIntf<>nil then
      begin
        FPullUpLoadMorePanelIntf.Prop.DoScrollingToInitialEnd;
      end;


      if (csDesigning in Self.FSkinControl.ComponentState)
        and
        (FAutoPullUpLoadMorePanel<>nil)
        {$IFDEF FMX}
        and Not FAutoPullUpLoadMorePanel.Stored
        {$ENDIF}
        then
      begin
          //在设计时释放自动创建的下拉加载面板
          Self.CheckMaxPullLoadPanel(nil);
          FreeAndNil(FAutoPullUpLoadMorePanel);
      end;

  end;

end;

procedure TScrollControlProperties.DoHorz_InnerMaxOverRangePosValueChange(
  Sender: TObject; NextValue, LastValue, Step: Double; var NewValue: Double;
  var CanChange: Boolean);
begin
  AutoCreatePullUpLoadMorePanel;


  if (Self.FPullUpLoadMorePanelControlIntf<>nil) then
  begin
    //加载面板
    FPullUpLoadMorePanelIntf.Prop.
              DoOverRangePosValueChange(Self,sbHorizontal,
                                        Self.FHorzControlGestureManager.IsDraging,
                                        Self.FHorzControlGestureManager.CalcOverRangePosValue(NewValue),
                                        Self.FHorzControlGestureManager.CalcOverRangePosValue(NextValue),
                                        Self.FHorzControlGestureManager.CalcOverRangePosValue(LastValue),
                                        NextValue,LastValue,Step,
                                        NewValue,CanChange);
  end;


end;

procedure TScrollControlProperties.DoHorz_InnerMinOverRangePosValueChange(
  Sender: TObject; NextValue, LastValue, Step: Double; var NewValue: Double;
  var CanChange: Boolean);
begin
  AutoCreatePullDownRefreshPanel;

  if (Self.FPullDownRefreshPanelControlIntf<>nil)
    and (FPullDownRefreshPanelControlIntf.GetSkinControlType<>nil) then
  begin
    //加载面板
    FPullDownRefreshPanelIntf.Prop.
                DoOverRangePosValueChange(Self,sbHorizontal,
                                          Self.FHorzControlGestureManager.IsDraging,
                                          Self.FHorzControlGestureManager.CalcOverRangePosValue(NewValue),
                                          Self.FHorzControlGestureManager.CalcOverRangePosValue(NextValue),
                                          Self.FHorzControlGestureManager.CalcOverRangePosValue(LastValue),
                                          NextValue,
                                          LastValue,
                                          Step,
                                          NewValue,
                                          CanChange);
  end;
end;

procedure TScrollControlProperties.DoVert_InnerScrollToInitialAnimateBegin(Sender: TObject);
begin

end;

procedure TScrollControlProperties.DoVert_InnerScrollToInitialAnimateEnd(Sender: TObject);
begin
  //滚回初始的类型

  //滚动到最小值
  if Self.FVertControlGestureManager.ScrollingToInitialAnimator.Tag=1 then
  begin
      if Self.FPullDownRefreshPanelIntf<>nil then
      begin
        FPullDownRefreshPanelIntf.Prop.DoScrollingToInitialEnd;
      end;


      if (csDesigning in Self.FSkinControl.ComponentState)
        and
        (FAutoPullDownRefreshPanel<>nil)
        {$IFDEF FMX}
        and Not FAutoPullDownRefreshPanel.Stored
        {$ENDIF}
        then
      begin
          //在设计时释放自动创建的下拉加载面板
          Self.CheckMinPullLoadPanel(nil);
          FreeAndNil(FAutoPullDownRefreshPanel);
      end;

  end;

  //滚回到最大值
  if Self.FVertControlGestureManager.ScrollingToInitialAnimator.Tag=2 then
  begin
      if Self.FPullUpLoadMorePanelIntf<>nil then
      begin
        FPullUpLoadMorePanelIntf.Prop.DoScrollingToInitialEnd;
      end;


      if (csDesigning in Self.FSkinControl.ComponentState)
        and
        (FAutoPullUpLoadMorePanel<>nil)
        {$IFDEF FMX}
        and Not FAutoPullUpLoadMorePanel.Stored
        {$ENDIF}
        then
      begin
          //在设计时释放自动创建的下拉加载面板
          Self.CheckMaxPullLoadPanel(nil);
          FreeAndNil(FAutoPullUpLoadMorePanel);
      end;

  end;
end;

function TScrollControlProperties.GetVertCanOverRangeTypes: TCanOverRangeTypes;
begin
  Result:=Self.FVertControlGestureManager.CanOverRangeTypes;
end;

procedure TScrollControlProperties.SetVertCanOverRangeTypes(const Value: TCanOverRangeTypes);
begin
  Self.FVertControlGestureManager.CanOverRangeTypes:=Value;
end;

function TScrollControlProperties.GetHorzCanOverRangeTypes: TCanOverRangeTypes;
begin
  Result:=Self.FHorzControlGestureManager.CanOverRangeTypes;
end;

procedure TScrollControlProperties.SetHorzCanOverRangeTypes(const Value: TCanOverRangeTypes);
begin
  Self.FHorzControlGestureManager.CanOverRangeTypes:=Value;
end;

function TScrollControlProperties.GetPullDownRefreshPanel:TChildControl;
begin
  Result:=Self.FVertControlGestureManager.MinPullLoadPanel;
end;

function TScrollControlProperties.GetPullUpLoadMorePanel:TChildControl;
begin
  Result:=Self.FVertControlGestureManager.MaxPullLoadPanel;
end;

procedure TScrollControlProperties.SetPullDownRefreshPanel(const Value: TChildControl);
begin
  if FVertControlGestureManager.MinPullLoadPanel<>Value then
  begin
      CheckMinPullLoadPanel(nil);
      FVertControlGestureManager.MinPullLoadPanel:=Value;
  end;
end;

procedure TScrollControlProperties.SetPullUpLoadMorePanel(const Value: TChildControl);
begin
  if FVertControlGestureManager.MaxPullLoadPanel<>Value then
  begin
    CheckMaxPullLoadPanel(nil);
    FVertControlGestureManager.MaxPullLoadPanel:=Value;
  end;
end;

function TScrollControlProperties.GetComponentClassify: String;
begin
  Result:='SkinScrollControl';
end;

function TScrollControlProperties.GetContentHeight: Double;
begin
  case Ceil(FContentHeight) of
    -1:
    begin
      Result:=CalcContentHeight;
    end;
    else
    begin
      Result:=FContentHeight;
    end;
  end;
end;

function TScrollControlProperties.GetContentWidth: Double;
begin
  case Ceil(FContentWidth) of
    -1:
    begin
      Result:=CalcContentWidth;
    end;
    else
    begin
      Result:=FContentWidth;
    end;
  end;
end;

function TScrollControlProperties.HasVertScrollBar: Boolean;
begin
  Result:=FVertScrollBarShowType<>sbstNone;
end;

function TScrollControlProperties.HasHorzScrollBar: Boolean;
begin
  Result:=FHorzScrollBarShowType<>sbstNone;
end;

function TScrollControlProperties.GetHorzScrollBarRect: TRectF;
begin
  Result:=RectF(0,0,0,0);
  if Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf<>nil then
  begin
    Result:=RectF(Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Left,
                  Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Top,
                  Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Left
                    +Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Width,
                  Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Top
                    +Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Height);
  end;
end;

function TScrollControlProperties.GetScrollControlCornerRect: TRectF;
begin
  Result:=RectF(0,0,0,0);
  if Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf<>nil then
  begin
    Result:=RectF(Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Left,
                  Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Top,
                  Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Left
                    +Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Width,
                  Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Top
                    +Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Height);
  end;
end;

function TScrollControlProperties.GetVertScrollBarRect: TRectF;
begin
  Result:=RectF(0,0,0,0);
  if Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf<>nil then
  begin
    Result:=RectF(Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Left,
                  Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Top,
                  Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Left
                    +Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Width,
                  Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Top
                    +Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Height);
  end;
end;

function TScrollControlProperties.GetScrollControlCornerVisible: Boolean;
begin
  Result:=False;
  if Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf=nil then Exit;
  Result:=GetHorzScrollBarVisible and GetVertScrollBarVisible;
end;


function TScrollControlProperties.GetHorzScrollBarVisible: Boolean;
begin
//                      sbstAlwaysCoverShow,  //永远覆盖显示
//                      sbstAlwaysClipShow,   //永远单独显示
//                      sbstAutoCoverShow,    //自动覆盖显示
//                      sbstAutoClipShow,     //自动单独显示
//                      sbstHide              //永远隐藏
  Result:=False;
  if Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf=nil then Exit;

  case FHorzScrollBarShowType of
    sbstNone:Result:=False;
//    sbstAlwaysCoverShow: Result:=True;
    sbstAlwaysClipShow,sbstAlwaysCoverShow: Result:=True;
    sbstAutoCoverShow,sbstAutoClipShow: Result:=(GetContentWidth>RectWidthF(Self.GetClientRect))
                            and Not Self.FSkinScrollControlIntf.GetHorzScrollBarIntf.Prop.IsCanAutoHide;
//    sbstAutoClipShow: Result:=(GetContentWidth>RectWidthF(Self.GetClientRect))
//                            and Not Self.FSkinScrollControlIntf.GetHorzScrollBarIntf.Prop.IsCanAutoHide;
    sbstHide: Result:=False;
  end;
end;

function TScrollControlProperties.GetVertScrollBarVisible: Boolean;
begin
  Result:=False;
  if Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf=nil then Exit;
  
  case FVertScrollBarShowType of
    sbstNone:Result:=False;
//    sbstAlwaysCoverShow: Result:=True;
    sbstAlwaysClipShow,sbstAlwaysCoverShow: Result:=True;
    sbstAutoCoverShow,sbstAutoClipShow: Result:=(GetContentHeight>RectHeightF(Self.GetClientRect))
                               and Not Self.FSkinScrollControlIntf.GetVertScrollBarIntf.Prop.IsCanAutoHide;
//    sbstAutoClipShow: Result:=(GetContentHeight>RectHeightF(Self.GetClientRect))
//                               and Not Self.FSkinScrollControlIntf.GetVertScrollBarIntf.Prop.IsCanAutoHide;
    sbstHide: Result:=False;
  end;
end;

function TScrollControlProperties.GetAutoPullDownRefreshPanel: TSkinChildPullLoadPanel;
begin
  AutoCreatePullDownRefreshPanel;
  Result:=Self.FAutoPullDownRefreshPanel;
end;

function TScrollControlProperties.GetAutoPullUpLoadMorePanel: TSkinChildPullLoadPanel;
begin
  AutoCreatePullUpLoadMorePanel;
  Result:=Self.FAutoPullUpLoadMorePanel;
end;

function TScrollControlProperties.GetBottomDrawOffset: Double;
begin
  Result:=
          Self.FVertControlGestureManager.Position
          -Self.FVertControlGestureManager.CalcMinOverRangePosValue
          +Self.FVertControlGestureManager.CalcMaxOverRangePosValue

          ;
end;

function TScrollControlProperties.GetLeftDrawOffset: Double;
begin
  Result:=
          Self.FHorzControlGestureManager.Position
          -Self.FHorzControlGestureManager.CalcMinOverRangePosValue
          +Self.FHorzControlGestureManager.CalcMaxOverRangePosValue;
end;

function TScrollControlProperties.GetRightDrawOffset: Double;
begin
  Result:=
          Self.FHorzControlGestureManager.Position
          -Self.FHorzControlGestureManager.CalcMinOverRangePosValue
          +Self.FHorzControlGestureManager.CalcMaxOverRangePosValue;
end;

function TScrollControlProperties.GetTopDrawOffset: Double;
begin
  Result:=
          Self.FVertControlGestureManager.Position
          -Self.FVertControlGestureManager.CalcMinOverRangePosValue
          +Self.FVertControlGestureManager.CalcMaxOverRangePosValue;
end;

function TScrollControlProperties.GetClientRect: TRectF;
begin
  Result:=RectF(0,
                0,
                Self.FSkinControlIntf.Width,
                Self.FSkinControlIntf.Height-ScreenScaleSize(FClientMarginBottom)
                );

//  //去除滚动条
//  if (Self.FVertScrollBarShowType=sbstAlwaysClipShow)
//    or (Self.FVertScrollBarShowType=sbstAutoClipShow){ and Self.GetVertScrollBarVisible} then
//  begin
//    Result.Right:=Result.Right-Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Width;
//  end;


//  //去除滚动条
//  if (Self.FHorzScrollBarShowType=sbstAlwaysClipShow)
//    or (Self.FHorzScrollBarShowType=sbstAutoClipShow){ and Self.GetHorzScrollBarVisible} then
//  begin
//    Result.Bottom:=Result.Bottom-Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Height;
//  end;

end;

procedure TScrollControlProperties.SetContentHeight(const Value: Double);
begin
  if FContentHeight<>Value then
  begin
    FContentHeight:=Value;

    DoContentHeightChange;
    Self.UpdateScrollBars;
  end;
end;

procedure TScrollControlProperties.SetContentWidth(const Value: Double);
begin
  if FContentWidth<>Value then
  begin
    FContentWidth:=Value;

    DoContentWidthChange;
    Self.UpdateScrollBars;
  end;
end;

procedure TScrollControlProperties.SetHorzScrollBarShowType(const Value: TScrollBarShowType);
begin
  if FHorzScrollBarShowType<>Value then
  begin
    FHorzScrollBarShowType := Value;
    //如果不需要水平滚动条,那么释放
    if FHorzScrollBarShowType=sbstNone then
    begin
      Self.FSkinScrollControlIntf.FreeHorzScrollBar;
    end;
    Self.UpdateScrollBars;
  end;
end;

procedure TScrollControlProperties.SetVertScrollBarShowType(const Value: TScrollBarShowType);
begin
  if FVertScrollBarShowType<>Value then
  begin
    FVertScrollBarShowType := Value;
    //如果不需要垂直滚动条,那么释放
    if FVertScrollBarShowType=sbstNone then
    begin
      Self.FSkinScrollControlIntf.FreeVertScrollBar;
    end;
    Self.UpdateScrollBars;
  end;
end;

procedure TScrollControlProperties.StartPullDownRefresh;
begin
  AutoCreatePullDownRefreshPanel;
  if FPullDownRefreshPanelIntf<>nil then
  begin
    Self.FPullDownRefreshPanelIntf.Prop.StartLoad(sbVertical);
  end;
end;

procedure TScrollControlProperties.StartPullUpLoadMore;
begin
  AutoCreatePullUpLoadMorePanel;
  if FPullUpLoadMorePanelIntf<>nil then
  begin
    Self.FPullUpLoadMorePanelIntf.Prop.StartLoad(sbVertical);
  end;
end;

procedure TScrollControlProperties.StopPullDownRefresh(const ALoadingStopCaption:String;const AWaitHintTime:Integer);
begin
  if FPullDownRefreshPanelIntf<>nil then
  begin
    Self.FPullDownRefreshPanelIntf.Prop.StopLoad(ALoadingStopCaption,AWaitHintTime);
  end;
end;

procedure TScrollControlProperties.StopPullUpLoadMore(const ALoadingStopCaption:String;const AWaitHintTime:Integer;const AHasLoadMoreDataNeedScroll:Boolean);
begin
  if FPullUpLoadMorePanelIntf<>nil then
  begin
    Self.FPullUpLoadMorePanelIntf.Prop.StopLoad(ALoadingStopCaption,AWaitHintTime,AHasLoadMoreDataNeedScroll);
  end;
end;

procedure TScrollControlProperties.SetScrollBarEmbeddedType(const Value: TScrollBarEmbeddedType);
begin
  if FScrollBarEmbeddedType<>Value then
  begin
    FScrollBarEmbeddedType := Value;
    Self.UpdateScrollBars;
  end;
end;

procedure TScrollControlProperties.UpdateScrollBars;
begin
//  uBaseLog.OutputDebugString('UpdateScrollBars Begin');

  //垂直滚动条
  if (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf<>nil) then
  begin

      Self.FVertControlGestureManager.StaticMin:=0;

      //判断是否需要垂直滚动条
      if BiggerDouble(GetContentHeight-RectHeightF(GetClientRect),0) then
      begin
        Self.FVertControlGestureManager.Max:=GetContentHeight-RectHeightF(GetClientRect);
      end
      else
      begin
        Self.FVertControlGestureManager.Max:=0;
      end;
      Self.FVertControlGestureManager.PageSize:=RectHeightF(GetClientRect);



      //设置垂直滚动条的位置和大小
      {$IFDEF FMX}
      Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Width:=7;
      {$ENDIF FMX}
      Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Left:=Self.FSkinControlIntf.Width
                                      -Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Width
//                                      {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
                                      {$IFDEF FMX}
                                      -1
                                      {$ENDIF}
//                                      {$ENDIF}
                                      ;
      Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Top:=ControlSize(GetClientRect.Top);
      Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Height:=ControlSize(RectHeightF(GetClientRect));


  end;




  //水平滚动条
  if (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf<>nil) then
  begin

      Self.FHorzControlGestureManager.StaticMin:=0;

      if BiggerDouble(GetContentWidth-RectWidthF(GetClientRect),0) then
      begin
        Self.FHorzControlGestureManager.Max:=GetContentWidth-RectWidthF(GetClientRect);
      end
      else
      begin
        Self.FHorzControlGestureManager.Max:=0;
      end;
      Self.FHorzControlGestureManager.PageSize:=RectWidthF(GetClientRect);

      //设置水平滚动条的位置和大小
      Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Left:=ControlSize(GetClientRect.Left);
      Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Top:=ControlSize(
                                      Self.FSkinControlIntf.Height
                                      -Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Height
//                                      {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
                                      {$IFDEF FMX}
                                      -1
                                      {$ENDIF}
//                                      {$ENDIF}
                                      );
      Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Width:=ControlSize(RectWidthF(GetClientRect));

  end;





  //右下角
  if (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf<>nil)
    and (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf<>nil)
    and (Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf<>nil) then
  begin

      Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Left:=Self.FSkinControlIntf.Width
                                      -Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Width;
      Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Top:=Self.FSkinControlIntf.Height
                                      -Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Height;
      Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Width:=Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.Width;
      Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.Height:=Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.Height;

  end;


//  uBaseLog.OutputDebugString('UpdateScrollBars End '
//                              +' Min:'+FloatToStr(Self.FHorzControlGestureManager.StaticMin)
//                              +' Max:'+FloatToStr(Self.FHorzControlGestureManager.StaticMax)
//                              +' Pos:'+FloatToStr(Self.FHorzControlGestureManager.StaticPosition)
//                              +' MinOver:'+FloatToStr(Self.FHorzControlGestureManager.StaticMinOverRangePosValue)
//                              +' MaxOver:'+FloatToStr(Self.FHorzControlGestureManager.StaticMaxOverRangePosValue)
//
//                              );

end;

procedure TScrollControlProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;

  FContentHeight:=TScrollControlProperties(Src).FContentHeight;

  FContentWidth:=TScrollControlProperties(Src).FContentWidth;

  //滚动条嵌入类型
  FScrollBarEmbeddedType:=TScrollControlProperties(Src).FScrollBarEmbeddedType;

  //滚动条显示类型
  FHorzScrollBarShowType:=TScrollControlProperties(Src).FHorzScrollBarShowType;
  FVertScrollBarShowType:=TScrollControlProperties(Src).FVertScrollBarShowType;
end;

{$IFDEF FMX}
function TScrollControlProperties.IsSelfBottomNotShowed: Boolean;
var
  AParentScrollBoxBottomPoint:TPointF;
  ASelfBottomPoint:TPointF;
begin
  //当前ListBox的底部显示全了,
  Result:=False;

//  //有父ScrollControl控件
//  if Self.FSkinControlIntf.GetParentIsScrollBox
//    and (Self.FSkinControlIntf.GetParentScrollBox<>nil) then
//  begin

      //父ScrollBox底部的绝对坐标
      AParentScrollBoxBottomPoint:=
        Self.FSkinControlIntf.GetParentScrollBox.LocalToAbsolute(
                                    PointF(Self.FSkinControlIntf.GetParentScrollBox.Width,
                                          Self.FSkinControlIntf.GetParentScrollBox.Height));
      //子ListBox底部的绝对坐标
      ASelfBottomPoint:=Self.FSkinControl.LocalToAbsolute(
                                                PointF(Self.FSkinControl.Width,
                                                       Self.FSkinControl.Height));

      if BiggerDouble(ASelfBottomPoint.Y,AParentScrollBoxBottomPoint.Y) then
      begin
//          uBaseLog.HandleException('子ListBox与父ScrollBox底部的距离'+FloatToStr(ASelfBottomPoint.Y-AParentScrollBoxBottomPoint.Y));
          //子ListBox的底部还在父ScrollBox的底下,
          //子ListBox的底部没有全部显示出来,
          //那么父ScrollBox跟着滚动,直到ListBox显示出来
          Result:=True;
      end
      else
      begin
          Result:=False;
      end;

//  end;


end;
{$ENDIF FMX}


{ TSkinScrollControlType }


function TSkinScrollControlType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinScrollControl,Self.FSkinScrollControlIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinScrollControl Interface');
    end;
  end;
end;

function TSkinScrollControlType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  AScrollBarRect:TRectF;
  ACustomDrawRect: TRectF;
var
  AChildSkinMaterial:TSkinControlMaterial;
begin

  CustomPaintContent(ACanvas,ASkinMaterial,ADrawRect,APaintData);
//  ACustomDrawRect:=ADrawRect;
//  ACustomDrawRect.Bottom:=ACustomDrawRect.Bottom-40;
//  CustomPaintContent(ACanvas,ASkinMaterial,ACustomDrawRect,APaintData);


  {$IFDEF VCL}
  //绘制滚动条
  //最后绘制滚动条
  //让他绘制在所有之上
  if Self.FSkinScrollControlIntf.Prop.ScrollBarEmbeddedType=sbetVirtualControl then
  begin
      //绘制垂直滚动条
      if TScrollControlProperties(Self.FSkinScrollControlIntf.Prop).GetVertScrollBarVisible then
      begin
        AScrollBarRect:=TScrollControlProperties(Self.FSkinScrollControlIntf.Prop).GetVertScrollBarRect;
        AChildSkinMaterial:=Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
        Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType.Paint(ACanvas,
                                                                                          AChildSkinMaterial,
                                                                                          AScrollBarRect,
                                                                                          APaintData);
      end;


      //绘制水平滚动条
      if TScrollControlProperties(Self.FSkinScrollControlIntf.Prop).GetHorzScrollBarVisible then
      begin
        AScrollBarRect:=TScrollControlProperties(Self.FSkinScrollControlIntf.Prop).GetHorzScrollBarRect;
        AChildSkinMaterial:=Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
        Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType.Paint(ACanvas,
                                                                                          AChildSkinMaterial,
                                                                                          AScrollBarRect,
                                                                                          APaintData);
      end;


      //绘制滚动框角
      if TScrollControlProperties(Self.FSkinScrollControlIntf.Prop).GetScrollControlCornerVisible then
      begin
        AScrollBarRect:=TScrollControlProperties(Self.FSkinScrollControlIntf.Prop).GetScrollControlCornerRect;
        AChildSkinMaterial:=Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
        Self.FSkinScrollControlIntf.GetScrollControlCornerControlIntf.GetSkinControlType.Paint(ACanvas,AChildSkinMaterial,AScrollBarRect,APaintData);
      end;

  end;

  {$ENDIF VCL}

end;

function TSkinScrollControlType.CustomPaintContent(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  AScrollDrawRect:TRectF;
begin

  FDrawRectTopOffset:=Self.FSkinScrollControlIntf.Prop.GetTopDrawOffset;
  FDrawRectLeftOffset:=Self.FSkinScrollControlIntf.Prop.GetLeftDrawOffset;
  FDrawRectRightOffset:=Self.FSkinScrollControlIntf.Prop.GetRightDrawOffset;
  FDrawRectBottomOffset:=Self.FSkinScrollControlIntf.Prop.GetBottomDrawOffset;

  AScrollDrawRect:=ADrawRect;
  AScrollDrawRect.Left:=AScrollDrawRect.Left-FDrawRectLeftOffset;
  AScrollDrawRect.Top:=AScrollDrawRect.Top-FDrawRectTopOffset;
  AScrollDrawRect.Right:=AScrollDrawRect.Right-FDrawRectLeftOffset;
  AScrollDrawRect.Bottom:=AScrollDrawRect.Bottom-FDrawRectTopOffset;

  //绘制内容
  if Assigned(Self.FSkinScrollControlIntf.OnPaintContent) then
  begin
    Self.FSkinScrollControlIntf.OnPaintContent(ACanvas,AScrollDrawRect);
  end;
end;

procedure TSkinScrollControlType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinScrollControlIntf:=nil;
end;

procedure TSkinScrollControlType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
var
  AScrollBarRect:TRectF;
  AScrollBarX,AScrollBarY:Double;
begin
  Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.FIsNotChangePosition:=False;
  Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.FIsNotChangePosition:=False;

//  if Self.FSkinControl.Name='SkinFMXScrollBox1' then
//  begin
//    uBaseLog.OutputDebugString('SkinFMXScrollBox1 CustomMouseDown '+FloatToStr(Y));
//  end;
  

  inherited;



  //处理垂直滚动条点击
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar)
    and (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf<>nil)
    and (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType<>nil)
    then
  begin
      AScrollBarRect:=Self.FSkinScrollControlIntf.Prop.GetVertScrollBarRect;
      if PtInRect(AScrollBarRect,PointF(X,Y)) then
      begin
        //在垂直滚动条中
        AScrollBarX:=X-AScrollBarRect.Left;
        AScrollBarY:=Y-AScrollBarRect.Top;
        Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType.CustomMouseDown(Button,Shift,AScrollBarX,AScrollBarY);
      end
      else
      begin
        Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.MouseDown(Button,Shift,X,Y);
      end;
  end;



  //处理水平滚动条点击
  if (Self.FSkinScrollControlIntf.Prop.HasHorzScrollBar)
    and (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf<>nil)
    and (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType<>nil)
    then
  begin
      AScrollBarRect:=Self.FSkinScrollControlIntf.Prop.GetHorzScrollBarRect;
      if PtInRect(AScrollBarRect,PointF(X,Y)) then
      begin
        //在水平滚动条中
        AScrollBarX:=X-AScrollBarRect.Left;
        AScrollBarY:=Y-AScrollBarRect.Top;
        Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType.CustomMouseDown(Button,Shift,AScrollBarX,AScrollBarY);
      end
      else
      begin
        Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.MouseDown(Button,Shift,X,Y);
      end;
  end;


end;

procedure TSkinScrollControlType.CustomMouseEnter;
begin
  inherited;


  //处理垂直滚动条进入
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.MouseEnter;
  end;

  //处理水平滚动条进入
  if (Self.FSkinScrollControlIntf.Prop.HasHorzScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.MouseEnter;
  end;


end;

procedure TSkinScrollControlType.CustomMouseLeave;
begin
  inherited;

  {$IFNDEF MSWINDOWS}
  //处理垂直滚动条离开
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.MouseLeave;
  end;

  //处理水平滚动条离开
  if (Self.FSkinScrollControlIntf.Prop.HasHorzScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.MouseLeave;
  end;
  {$ENDIF}

end;

function TSkinScrollControlType.CustomMouseWheel(Shift: TShiftState; WheelDelta:Integer; X,Y: Double): Boolean;
begin

  //鼠标滚动
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.MouseWheel(Shift,WheelDelta,X,Y);
  end;

end;

procedure TSkinScrollControlType.CustomMouseMove(Shift: TShiftState; X, Y: Double);
var
  AScrollBarRect:TRectF;
  AScrollBarX,AScrollBarY:Double;
begin
//  if Self.FSkinControl.Name='SkinFMXScrollBox1' then
//  begin
//    uBaseLog.OutputDebugString('SkinFMXScrollBox1 CustomMouseMove '+FloatToStr(Y));
//  end;


  inherited;


  //处理垂直滚动条鼠标移动
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar)
      and (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf<>nil)
      and (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType<>nil)
      then
  begin
      AScrollBarRect:=Self.FSkinScrollControlIntf.Prop.GetVertScrollBarRect;
      if Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.IsMouseDown then
      begin
        AScrollBarX:=X-AScrollBarRect.Left;
        AScrollBarY:=Y-AScrollBarRect.Top;
        Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType.CustomMouseMove(Shift,AScrollBarX,AScrollBarY);
      end
      else
      begin
        Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.MouseMove(Shift,X,Y);
      end;
  end;




  //处理水平滚动条鼠标移动
  if (Self.FSkinScrollControlIntf.Prop.HasHorzScrollBar)
      and (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf<>nil)
      and (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType<>nil)
      then
  begin
      AScrollBarRect:=Self.FSkinScrollControlIntf.Prop.GetHorzScrollBarRect;
      if Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.IsMouseDown then
      begin
        AScrollBarX:=X-AScrollBarRect.Left;
        AScrollBarY:=Y-AScrollBarRect.Top;
        Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType.CustomMouseMove(Shift,AScrollBarX,AScrollBarY);
      end
      else
      begin
        Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.MouseMove(Shift,X,Y);
      end;
  end;


end;

procedure TSkinScrollControlType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
var
  AScrollBarRect:TRectF;
  AScrollBarX,AScrollBarY:Double;
begin
//  if Self.FSkinControl.Name='SkinFMXScrollBox1' then
//  begin
//    uBaseLog.OutputDebugString('SkinFMXScrollBox1 CustomMouseUp '+FloatToStr(Y));
//  end;

  inherited;

  //处理垂直滚动条点击
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar)
    and (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf<>nil)
    and (Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType<>nil)
    then
  begin
      AScrollBarRect:=Self.FSkinScrollControlIntf.Prop.GetVertScrollBarRect;
      if Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.IsMouseDown
        then
      begin
          AScrollBarX:=X-AScrollBarRect.Left;
          AScrollBarY:=Y-AScrollBarRect.Top;
          Self.FSkinScrollControlIntf.GetVertScrollBarControlIntf.GetSkinControlType.CustomMouseUp(Button,Shift,AScrollBarX,AScrollBarY);
      end
      else
      begin
          Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.MouseUp(Button,Shift,X,Y);
      end;
  end;




  //处理水平滚动条点击
  if (Self.FSkinScrollControlIntf.Prop.HasHorzScrollBar)
    and (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf<>nil)
    and (Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType<>nil)
    then
  begin
      AScrollBarRect:=Self.FSkinScrollControlIntf.Prop.GetHorzScrollBarRect;
      if Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.IsMouseDown
        then
      begin
        AScrollBarX:=X-AScrollBarRect.Left;
        AScrollBarY:=Y-AScrollBarRect.Top;
        Self.FSkinScrollControlIntf.GetHorzScrollBarControlIntf.GetSkinControlType.CustomMouseUp(Button,Shift,AScrollBarX,AScrollBarY);
      end
      else
      begin
        Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.MouseUp(Button,Shift,X,Y);
      end;
  end;

end;

procedure TSkinScrollControlType.SizeChanged;
begin
  inherited;
//  uBaseLog.OutputDebugString('TSkinScrollControlType.SizeChanged');

  //更新滚动条
  Self.FSkinScrollControlIntf.Prop.UpdateScrollBars;
end;

//键盘事件
procedure TSkinScrollControlType.KeyDown(Key: Word; Shift: TShiftState);
begin
  //处理垂直滚动条键盘事件
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.KeyDown(Key,Shift);
  end;


  //处理水平滚动条键盘事件
  if (Self.FSkinScrollControlIntf.Prop.HasHorzScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.KeyDown(Key,Shift);
  end;
end;

procedure TSkinScrollControlType.KeyUp(Key: Word; Shift: TShiftState);
begin
  //处理垂直滚动条键盘事件
  if (Self.FSkinScrollControlIntf.Prop.HasVertScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FVertControlGestureManager.KeyUp(Key,Shift);
  end;


  //处理水平滚动条键盘事件
  if (Self.FSkinScrollControlIntf.Prop.HasHorzScrollBar) then
  begin
    Self.FSkinScrollControlIntf.Prop.FHorzControlGestureManager.KeyUp(Key,Shift);
  end;

end;

//function TSkinScrollControlType.MouseDownEventCanTransWhenParentIsScrollBox: Boolean;
//begin
//  Result:=True;
//  //初始
////  FSkinScrollControlIntf.Prop.VertControlGestureManager.FIsNotChangePosition:=False;
////  TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=False;
//end;
//
//function TSkinScrollControlType.MouseMoveEventCanTransWhenParentIsScrollBox: Boolean;
//begin
////  if Self.FSkinScrollControlIntf.Prop.FIsProcessGestureInScrollBox then
////  begin
////      if (Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.MouseMoveDirection<>isdNone)
////        and (Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.IsMouseDown) then
////      begin
////        //判断好了方向
////        case Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.MouseMoveDirection of
////          isdScrollToMin:
////          begin
////            //往下移
////            if IsSameDouble(Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Position,
////                                  Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Min) then
////            begin
////              //到顶部的情况下
////              //父ScrollBox滑动
////              TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=False;
////            end
////            else
////            begin
////              //没有到顶部的情况下
////              //父ScrollBox不滑动
////              TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=True;
////            end;
////          end;
////          isdScrollToMax:
////          begin
////
////            //往上移
////            //到底部的情况下
//////            Result:=IsSameDouble(Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Position,
//////                                  Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Max)
//////
//////                    //如果子ListBox的底部还没有显示全，
//////                    //那么子ListBox不需要滚动
//////                    //只需要父ScrollBox滚动即可
//////                    or IsSelfBottomNotShowed
//////              ;
////
////
////            //如果子ListBox的底部还没有显示全，
////            if IsSelfBottomNotShowed then
////            begin
////              //那么子ListBox不需要滚动
////              //只需要父ScrollBox滚动即可
////              FSkinScrollControlIntf.Prop.VertControlGestureManager.FIsNotChangePosition:=True;
////              TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=False;
////            end
////            else if IsSameDouble(Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Position,
////                                  Self.FSkinScrollControlIntf.Prop.VertControlGestureManager.Max) then
////            begin
////              FSkinScrollControlIntf.Prop.VertControlGestureManager.FIsNotChangePosition:=False;
////              TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=False;
////            end
////            else
////            begin
////              //显示全了
////              FSkinScrollControlIntf.Prop.VertControlGestureManager.FIsNotChangePosition:=False;
////              TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=True;
////            end;
////
////
////            //子ListBox到底了,设置子ListBox不能动,父ScrollBox滑动
//////            FSkinScrollControlIntf.Prop.VertControlGestureManager.FIsNotChangePosition:=Result;
//////            TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=Not Result;
////
////
////          end;
////        end;
////      end
////      else
////      begin
////        //还未确定方式
////      end;
////  end
////  else
////  begin
////  end;
//  Result:=True;
//end;
//
//function TSkinScrollControlType.MouseUpEventCanTransWhenParentIsScrollBox: Boolean;
//begin
//  Result:=True;
////  FSkinScrollControlIntf.Prop.VertControlGestureManager.FIsNotChangePosition:=False;
////  TSkinScrollControl(FParentScrollBox).Prop.VertControlGestureManager.FIsNotChangePosition:=False;
//end;



{ TSkinScrollControlMaterial }

constructor TSkinScrollControlMaterial.Create(AOwner: TComponent);
begin
  inherited;

  FPullDownRefreshPanelMaterial:=TSkinPullLoadPanelDefaultMaterial.Create(Self);
  FPullDownRefreshPanelMaterial.SetSubComponent(True);
  FPullDownRefreshPanelMaterial.Name:='PullDownRefreshPanelMaterial';

  FPullUpLoadMorePanelMaterial:=TSkinPullLoadPanelDefaultMaterial.Create(Self);
  FPullUpLoadMorePanelMaterial.SetSubComponent(True);
  FPullUpLoadMorePanelMaterial.Name:='PullUpLoadMorePanelMaterial';

  FPullUpLoadMorePanelMaterial.LoadingCaption:=('正在加载...');
  FPullUpLoadMorePanelMaterial.DecidedLoadCaption:=('松开加载更多');
  FPullUpLoadMorePanelMaterial.UnDecidedLoadCaption:=('上拉加载更多');

end;

destructor TSkinScrollControlMaterial.Destroy;
begin
  FreeAndNil(FPullDownRefreshPanelMaterial);
  FreeAndNil(FPullUpLoadMorePanelMaterial);

  inherited;
end;

procedure TSkinScrollControlMaterial.SetPullDownRefreshPanelMaterial(const Value: TSkinPullLoadPanelDefaultMaterial);
begin
  FPullDownRefreshPanelMaterial.Assign(Value);
end;

procedure TSkinScrollControlMaterial.SetPullUpLoadMorePanelMaterial(const Value: TSkinPullLoadPanelDefaultMaterial);
begin
  FPullUpLoadMorePanelMaterial.Assign(Value);
end;




{ TSkinScrollControl }

constructor TSkinScrollControl.Create(AOwner:TComponent);
begin
  Inherited;

  {$IFDEF FMX}
  Self.ClipChildren:=True;
  {$ENDIF}
end;

function TSkinScrollControl.Material:TSkinScrollControlDefaultMaterial;
begin
  Result:=TSkinScrollControlDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollControl.SelfOwnMaterialToDefault:TSkinScrollControlDefaultMaterial;
begin
  Result:=TSkinScrollControlDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollControl.CurrentUseMaterialToDefault:TSkinScrollControlDefaultMaterial;
begin
  Result:=TSkinScrollControlDefaultMaterial(CurrentUseMaterial);
end;

destructor TSkinScrollControl.Destroy;
begin
  Inherited;
end;

function TSkinScrollControl.GetOnPaintContent:TSkinControlPaintEvent;
begin
  Result:=FOnPaintContent;
end;

function TSkinScrollControl.GetOnPullDownRefresh:TNotifyEvent;
begin
  Result:=FOnPullDownRefresh;
end;

function TSkinScrollControl.GetOnPullUpLoadMore:TNotifyEvent;
begin
  Result:=FOnPullUpLoadMore;
end;

function TSkinScrollControl.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TScrollControlProperties;
end;

function TSkinScrollControl.GetScrollControlProperties: TScrollControlProperties;
begin
  Result:=TScrollControlProperties(Self.FProperties);
end;

procedure TSkinScrollControl.FreeVertScrollBar;
begin
  SetVertScrollBar(nil);
end;

function TSkinScrollControl.GetVertScrollBarIntf:ISkinScrollBar;
begin
  Result:=FVertScrollBarIntf;
end;

//function TSkinScrollControl.GetVertScrollBarComponentIntf:ISkinComponent;
//begin
//  Result:=FVertScrollBarComponentIntf;
//end;

function TSkinScrollControl.GetVertScrollBarControlIntf:ISkinControl;
begin
  Result:=FVertScrollBarControlIntf;
end;

procedure TSkinScrollControl.FreeHorzScrollBar;
begin
  SetHorzScrollBar(nil);
end;

function TSkinScrollControl.GetHorzScrollBarIntf:ISkinScrollBar;
begin
  Result:=FHorzScrollBarIntf;
end;

//function TSkinScrollControl.GetHorzScrollBarComponentIntf:ISkinComponent;
//begin
//  Result:=FHorzScrollBarComponentIntf;
//end;

function TSkinScrollControl.GetHorzScrollBarControlIntf:ISkinControl;
begin
  Result:=FHorzScrollBarControlIntf;
end;

procedure TSkinScrollControl.FreeScrollControlCorner;
begin
  SetScrollControlCorner(nil);
end;

function TSkinScrollControl.GetScrollControlCornerIntf:ISkinScrollControlCorner;
begin
  Result:=FScrollControlCornerIntf;
end;

//function TSkinScrollControl.GetScrollControlCornerComponentIntf:ISkinComponent;
//begin
//  Result:=FScrollControlCornerComponentIntf;
//end;

function TSkinScrollControl.GetScrollControlCornerControlIntf:ISkinControl;
begin
  Result:=FScrollControlCornerControlIntf;
end;

procedure TSkinScrollControl.SetScrollControlProperties(Value: TScrollControlProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinScrollControl.DoScrollBarInvalidate(Sender: TObject);
begin
  if Not (csLoading in Self.ComponentState) then
  begin
    if (Properties<>nil)
      and (Properties.ScrollBarEmbeddedType=sbetVirtualControl) then
    begin
      //刷新
      Self.Invalidate;
    end;
  end;
end;

function TSkinScrollControl.GetVertScrollBar: TSkinChildScrollBar;
begin


  if (FVertScrollBar=nil) then
  //需要滚动条
//  and (Properties.VertScrollBarShowType<>sbstNone) then
  begin
    FVertScrollBar:=TSkinChildScrollBar.Create(Self,Self.Properties.VertControlGestureManager);
    if FVertScrollBar<>nil then
    begin
//      uBaseLog.HandleException(nil,'OrangeUI','uSkinScrollControl','GetVertScrollBar');

      FVertScrollBar.SetSubComponent(True);
      AddFreeNotification(FVertScrollBar,Self);

      FVertScrollBar.Name:='VertScrollBar';

      FVertScrollBarIntf:=FVertScrollBar as ISkinScrollBar;
      FVertScrollBarControlIntf:=FVertScrollBar as ISkinControl;


      FVertScrollBarIntf.Prop.Kind:=sbVertical;
      FVertScrollBarIntf.Prop.IsInScrollControl:=True;
      FVertScrollBarIntf.Prop.Min:=0;
      FVertScrollBarIntf.Prop.Max:=0;
      {$IFDEF FMX}
      FVertScrollBar.Width:=7;
      {$ENDIF}
      {$IFDEF VCL}
      FVertScrollBar.Width:=12;
      {$ENDIF}



      //垂直滚动条默认启用越界
      FVertScrollBarIntf.Prop.ControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
//      //位置更改事件
//      FVertScrollBarIntf.OnInnerChange:=Self.DoVertScrollBarPositionChange;
//      //需要绘制事件
      FVertScrollBarIntf.OnInvalidateScrollControl:=Self.DoScrollBarInvalidate;

    end;
  end;
  Result:=Self.FVertScrollBar;
end;

procedure TSkinScrollControl.SetVertScrollBar(Value: TSkinChildScrollBar);
begin


  if FVertScrollBar<>Value then
  begin
    //将原Style释放或解除绑定
    if FVertScrollBar<>nil then
    begin
      if (FVertScrollBar.Owner=Self) then
      begin
        FVertScrollBar.Name:='';
        //释放自己创建的
        FVertScrollBarIntf:=nil;
//        FVertScrollBarComponentIntf:=nil;
        FVertScrollBarControlIntf:=nil;
        FreeAndNil(FVertScrollBar);
      end
      else
      begin
        //解除别人的
        FVertScrollBar:=nil;
        FVertScrollBarIntf:=nil;
//        FVertScrollBarComponentIntf:=nil;
        FVertScrollBarControlIntf:=nil;
      end;
    end;
    if (Value<>nil)
//    //需要滚动条
//    and (Properties.HorzScrollBarShowType<>sbstNone)
    then
    begin
      FVertScrollBar:=Value;
      FVertScrollBarIntf:=FVertScrollBar as ISkinScrollBar;
//      FVertScrollBarComponentIntf:=FVertScrollBar as ISkinComponent;
      FVertScrollBarControlIntf:=FVertScrollBar as ISkinControl;


      //垂直滚动条默认启用越界
      FVertScrollBarIntf.Prop.ControlGestureManager.CanOverRangeTypes:=[cortMin,cortMax];
//      //位置更改事件
//      FVertScrollBarIntf.OnInnerChange:=Self.DoVertScrollBarPositionChange;
//      //需要绘制事件
      FVertScrollBarIntf.OnInvalidateScrollControl:=Self.DoScrollBarInvalidate;


      AddFreeNotification(FVertScrollBar,Self);

    end
    else//nil value
    begin

    end;
  end;
end;

function TSkinScrollControl.GetHorzScrollBar: TSkinChildScrollBar;
begin


  if (FHorzScrollBar=nil) then
    //需要滚动条
//    and (Properties.HorzScrollBarShowType<>sbstNone) then
  begin
    FHorzScrollBar:=TSkinChildScrollBar.Create(Self,Self.Properties.HorzControlGestureManager);
    //CreateChildScrollBar(Self);
    if (FHorzScrollBar<>nil) then
    begin
//      uBaseLog.HandleException(nil,'OrangeUI','uSkinScrollControl','GetHorzScrollBar');

      FHorzScrollBar.SetSubComponent(True);
      AddFreeNotification(FHorzScrollBar,Self);

      FHorzScrollBar.Name:='HorzScrollBar';

      FHorzScrollBarIntf:=FHorzScrollBar as ISkinScrollBar;
      FHorzScrollBarControlIntf:=FHorzScrollBar as ISkinControl;

      FHorzScrollBarIntf.Prop.Kind:=sbHorizontal;
      FHorzScrollBarIntf.Prop.IsInScrollControl:=True;
      FHorzScrollBarIntf.Prop.Min:=0;
      FHorzScrollBarIntf.Prop.Max:=0;
      {$IFDEF FMX}
      FHorzScrollBar.Height:=7;
      {$ENDIF}
      {$IFDEF VCL}
      FHorzScrollBar.Height:=12;
      {$ENDIF}

      //水平滚动条默认不启用越界
      FHorzScrollBarIntf.Prop.ControlGestureManager.CanOverRangeTypes:=[];
//      //位置更改事件
//      FHorzScrollBarIntf.OnInnerChange:=Self.DoHorzScrollBarPositionChange;
//      //绘制事件
      FHorzScrollBarIntf.OnInvalidateScrollControl:=Self.DoScrollBarInvalidate;

    end;
  end;
  Result:=Self.FHorzScrollBar;
end;

procedure TSkinScrollControl.SetHorzScrollBar(Value: TSkinChildScrollBar);
begin
  if FHorzScrollBar<>Value then
  begin
    //将原Style释放或解除绑定
    if FHorzScrollBar<>nil then
    begin
      if (FHorzScrollBar.Owner=Self) then
      begin
        FHorzScrollBar.Name:='';
        //释放自己创建的
        //会重复释放
        FHorzScrollBarIntf:=nil;
        FHorzScrollBarControlIntf:=nil;
//        FHorzScrollBarComponentIntf:=nil;
        FreeAndNil(FHorzScrollBar);
      end
      else
      begin
        //解除别人的
        FHorzScrollBar:=nil;
        FHorzScrollBarIntf:=nil;
        FHorzScrollBarControlIntf:=nil;
//        FHorzScrollBarComponentIntf:=nil;
      end;
    end;

    if (Value<>nil)
//    //需要滚动条
//    and (Properties.HorzScrollBarShowType<>sbstNone)
    then
    begin
      FHorzScrollBar:=Value;
      FHorzScrollBarIntf:=FHorzScrollBar as ISkinScrollBar;
      FHorzScrollBarControlIntf:=FHorzScrollBar as ISkinControl;
//      FHorzScrollBarComponentIntf:=FHorzScrollBar as ISkinComponent;

      //水平滚动条默认不启用越界
      FHorzScrollBarIntf.Prop.ControlGestureManager.CanOverRangeTypes:=[];
//      //位置更改事件
//      FHorzScrollBarIntf.OnInnerChange:=Self.DoHorzScrollBarPositionChange;
      //绘制事件
      FHorzScrollBarIntf.OnInvalidateScrollControl:=Self.DoScrollBarInvalidate;


      AddFreeNotification(FHorzScrollBar,Self);

    end
    else//nil value
    begin

    end;
  end;
end;


function TSkinScrollControl.GetScrollControlCorner: TSkinChildScrollControlCorner;
begin


  if (FScrollControlCorner=nil) then
  begin
    FScrollControlCorner:=CreateChildScrollControlCorner(Self);
    if (FScrollControlCorner<>nil) then
    begin
//      uBaseLog.HandleException(nil,'OrangeUI','uSkinScrollControl','GetScrollControlCorner');

      FScrollControlCorner.SetSubComponent(True);
      AddFreeNotification(FScrollControlCorner,Self);

      FScrollControlCorner.Name:='ScrollControlCorner';

      FScrollControlCornerIntf:=FScrollControlCorner as ISkinScrollControlCorner;
      FScrollControlCornerControlIntf:=FScrollControlCorner as ISkinControl;
//      FScrollControlCornerComponentIntf:=FScrollControlCorner as ISkinComponent;

    end;
  end;
  Result:=Self.FScrollControlCorner;
end;

procedure TSkinScrollControl.SetScrollControlCorner(Value: TSkinChildScrollControlCorner);
begin
  if FScrollControlCorner<>Value then
  begin
    //将原Style释放或解除绑定
    if FScrollControlCorner<>nil then
    begin
      if (FScrollControlCorner.Owner=Self) then
      begin
        FScrollControlCorner.Name:='';
        //释放自己创建的
        //会重复释放
        FScrollControlCornerIntf:=nil;
        FScrollControlCornerControlIntf:=nil;
//        FScrollControlCornerComponentIntf:=nil;
        FreeAndNil(FScrollControlCorner);
      end
      else
      begin
        //解除别人的
        FScrollControlCorner:=nil;
        FScrollControlCornerIntf:=nil;
        FScrollControlCornerControlIntf:=nil;
//        FScrollControlCornerComponentIntf:=nil;
      end;
    end;

    if (Value<>nil)then
    begin
      FScrollControlCorner:=Value;
      AddFreeNotification(FScrollControlCorner,Self);
      FScrollControlCornerIntf:=FScrollControlCorner as ISkinScrollControlCorner;
      FScrollControlCornerControlIntf:=FScrollControlCorner as ISkinControl;
//      FScrollControlCornerComponentIntf:=FScrollControlCorner as ISkinComponent;
    end
    else//nil value
    begin

    end;
  end;
end;


procedure TSkinScrollControl.AfterPaint;
var
  AScrollBarRect:TRectF;
var
  ASkinMaterial:TSkinControlMaterial;
begin
  inherited;


  {$IFDEF FMX}
  //绘制滚动条
  //最后绘制滚动条
  //让他绘制在所有之上
  if TScrollControlProperties(Self.Properties).ScrollBarEmbeddedType=sbetVirtualControl then
  begin
      FCanvas.Prepare(Canvas);


      //绘制垂直滚动条
      if TScrollControlProperties(Self.Properties).GetVertScrollBarVisible then
      begin
        AScrollBarRect:=TScrollControlProperties(Self.Properties).GetVertScrollBarRect;
        ASkinMaterial:=Self.FVertScrollBarControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
        Self.FVertScrollBarControlIntf.GetSkinControlType.Paint(FCanvas,ASkinMaterial,AScrollBarRect,FPaintData);
      end;


      //绘制水平滚动条
      if TScrollControlProperties(Self.Properties).GetHorzScrollBarVisible then
      begin
        AScrollBarRect:=TScrollControlProperties(Self.Properties).GetHorzScrollBarRect;
        ASkinMaterial:=Self.FHorzScrollBarControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
        Self.FHorzScrollBarControlIntf.GetSkinControlType.Paint(FCanvas,ASkinMaterial,AScrollBarRect,FPaintData);
      end;


      //绘制滚动框角
      if TScrollControlProperties(Self.Properties).GetScrollControlCornerVisible then
      begin
        AScrollBarRect:=TScrollControlProperties(Self.Properties).GetScrollControlCornerRect;
        ASkinMaterial:=Self.FScrollControlCornerControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
        Self.FScrollControlCornerControlIntf.GetSkinControlType.Paint(FCanvas,ASkinMaterial,AScrollBarRect,FPaintData);
      end;


      FCanvas.UnPrepare;
  end;

  {$ENDIF FMX}


end;


procedure TSkinScrollControl.Loaded;
begin
  inherited;



  if (Properties.VertScrollBarShowType<>sbstNone) then
  begin
    Self.GetVertScrollBar;
  end;
  if (Properties.HorzScrollBarShowType<>sbstNone) then
  begin
    Self.GetHorzScrollBar;
  end;
  Self.GetScrollControlCorner;
  Self.Properties.UpdateScrollBars;


//  uBaseLog.HandleException(nil,'OrangeUI','uSkinScrollControl',Name+' '+ClassName+' '+'Loaded'+' '+IntToStr(Integer(Self)));

end;

procedure TSkinScrollControl.Notification(AComponent: TComponent;Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (AComponent=Self.FVertScrollBar) then
    begin
      FVertScrollBar:=nil;
      FVertScrollBarIntf:=nil;
//      FVertScrollBarComponentIntf:=nil;
      FVertScrollBarControlIntf:=nil;
    end
    else if (AComponent=Self.FHorzScrollBar) then
    begin
      FHorzScrollBar:=nil;
      FHorzScrollBarIntf:=nil;
      FHorzScrollBarControlIntf:=nil;
//      FHorzScrollBarComponentIntf:=nil;
    end
    else if (AComponent=Self.FScrollControlCorner) then
    begin
      FScrollControlCorner:=nil;
      FScrollControlCornerIntf:=nil;
      FScrollControlCornerControlIntf:=nil;
//      FScrollControlCornerComponentIntf:=nil;
    end;
  end;
end;






end.

