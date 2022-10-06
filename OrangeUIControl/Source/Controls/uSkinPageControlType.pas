//convert pas to utf8 by ¥
//TabButton 分页按钮
//TabSheet 分页
//PageControl 多页控件
//TabHeader 标签头

/// <summary>
///   <para>
///     多页控件
///   </para>
///   <para>
///     Page control
///   </para>
/// </summary>
unit uSkinPageControlType;

interface
{$I FrameWork.inc}

{$I Version.inc}


uses
  Classes,
  SysUtils,
  uFuncCommon,
  Math,
  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  Dialogs,
//  uSkinWindowsControl,
//  uSkinWindowsSwitchPageListPanel,
  Forms,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
//  uSkinFireMonkeyControl,
//  uSkinFireMonkeySwitchPageListPanel,
  FMX.Dialogs,
  {$ENDIF}
  Types,
//  uSkinSwitchPageListPanelType,
  uBaseLog,
  uBaseList,
  uDrawParam,
//  uFuncCommon,
//  uDialogCommon,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uBaseSkinControl,

  {$IFDEF IOS}
  iOSapi.Foundation,
  iOSApi.UIKit,
  iOSapi.Helpers,
  Macapi.Helpers,
  Macapi.ObjectiveC,
  Macapi.ObjCRuntime,
  FMX.Helpers.iOS,
  {$ENDIF}


//  {$IFDEF FMX}
    //不能有FMX.WebBrowser,因为有些人要改FMX.WebBrowser
//  FMX.WebBrowser,
//  FMX.Platform,
//  {$ENDIF}
//  {$IFDEF VCL}
//  uSkinWindowsButton,
//  uSkinDirectUIButton
//  {$ENDIF}
//  {$IFDEF FMX}
//  {$ENDIF},
  uSkinButtonType,
  uDrawRectParam,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam,
  uSkinControlGestureManager,
  uSkinControlPanDragGestureManager,
  uSkinNotifyNumberIconType;

const
  IID_ISkinTabSheet:TGUID='{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E2}';
const
  IID_ISkinPageControl:TGUID='{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E1}';




type
  TPageControlProperties=class;
  TTabSheetProperties=class;
  TSkinPageControl=class;
  TSkinTabSheet=class;



//  TSkinBaseTabSheet=TSkinTabSheet;//TParentControl;
//  TSkinBasePageControl=TSkinPageControl;//TParentControl;






  /// <summary>
  ///   <para>
  ///     标签头的摆放位置类型
  ///   </para>
  ///   <para>
  ///     Align position type of TabHeader
  ///   </para>
  /// </summary>
  TTabOrientation = (
                      /// <summary>
                      ///   不显示
                      ///   <para>
                      ///     Not display
                      ///   </para>
                      /// </summary>
                      toNone,
                      /// <summary>
                      ///   左边
                      ///   <para>
                      ///     Left
                      ///   </para>
                      /// </summary>
                      toLeft,
                      /// <summary>
                      ///   上部
                      ///   <para>
                      ///     Top
                      ///   </para>
                      /// </summary>
                      toTop,
                      /// <summary>
                      ///   右边
                      ///   <para>
                      ///     Right
                      ///   </para>
                      /// </summary>
                      toRight,
                      /// <summary>
                      ///   底部
                      ///   <para>
                      ///     Bottom
                      ///   </para>
                      /// </summary>
                      toBottom
                      );



  /// <summary>
  ///   <para>
  ///     分页按钮的尺寸计算类型
  ///   </para>
  ///   <para>
  ///     Size calculate type of TabButton
  ///   </para>
  /// </summary>
  TTabSizeCalcType=(
                    /// <summary>
                    ///   平均
                    ///   <para>
                    ///     Equal
                    ///   </para>
                    /// </summary>
                    tsctEqual,
                    /// <summary>
                    ///   固定
                    ///   <para>
                    ///     Fixed
                    ///   </para>
                    /// </summary>
                    tsctFixed,
                    /// <summary>
                    ///   单独
                    ///   <para>
                    ///     Separate
                    ///   </para>
                    /// </summary>
                    tsctSeparate
//                    tsctAutoSize, //自动计算
//                    tsctCustom   //自定义
                    );





  TPageChangingEvent = procedure(Sender: TObject;NewIndex: Integer; var AllowChange: Boolean) of object;
  //自定义头部的绘制矩形
  TCustomCalcHeadDrawRectEvent = procedure(Sender:TObject;var AHeadDrawRect:TRectF) of object;
  //自定义分页头的绘制矩形
  TCustomCalcTabDrawRectEvent = procedure(Sender:TObject;AVisibleIndex:Integer;var ATabDrawRect:TRectF) of object;
  TCustomCalcTabDrawIconRectEvent = procedure(Sender:TObject;ATabSheet:TSkinTabSheet;var ATabDrawRect:TRectF) of object;




  /// <summary>
  ///   <para>
  ///     分页接口
  ///   </para>
  ///   <para>
  ///     Interface of TabSheet
  ///   </para>
  /// </summary>
  ISkinTabSheet=interface//(ISkinControl)
  ['{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E2}']

    function GetTabSheetProperties:TTabSheetProperties;
    property Properties:TTabSheetProperties read GetTabSheetProperties;
    property Prop:TTabSheetProperties read GetTabSheetProperties;
  end;





  /// <summary>
  ///   <para>
  ///     多页控件接口
  ///   </para>
  ///   <para>
  ///     Interface of PageControl
  ///   </para>
  /// </summary>
  ISkinPageControl=interface//(ISkinControl)
  ['{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E1}']


    //绑定的按钮分组控件
    function GetSwitchButtonGroup:TSkinBaseButtonGroup;
    function GetSwitchButtonGroupIntf:ISkinButtonGroup;

    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);

    function GetOnChanging: TPageChangingEvent;
    procedure SetOnChanging(const Value: TPageChangingEvent);

    function GetOnCustomCalcTabDrawRect:TCustomCalcTabDrawRectEvent;
    function GetOnCustomCalcTabIconDrawRect:TCustomCalcTabDrawIconRectEvent;
    function GetOnCustomCalcHeadDrawRect:TCustomCalcHeadDrawRectEvent;

    //更改事件
    property OnChange: TNotifyEvent read GetOnChange write SetOnChange;
    property OnChanging: TPageChangingEvent read GetOnChanging write SetOnChanging;
    property OnCustomCalcTabDrawRect:TCustomCalcTabDrawRectEvent read GetOnCustomCalcTabDrawRect;
    property OnCustomCalcTabIconDrawRect:TCustomCalcTabDrawIconRectEvent read GetOnCustomCalcTabIconDrawRect;
    property OnCustomCalcHeadDrawRect:TCustomCalcHeadDrawRectEvent read GetOnCustomCalcHeadDrawRect;


    function GetPageControlProperties:TPageControlProperties;
    property PageControlProperties:TPageControlProperties read GetPageControlProperties;
  end;














  /// <summary>
  ///   <para>
  ///     分页属性
  ///   </para>
  ///   <para>
  ///     TabSheet properties
  ///   </para>
  /// </summary>
  TTabSheetProperties=class(TSkinControlProperties)
  protected
    //图标
    FIcon:TDrawPicture;
    //按下图标
    FPushedIcon:TDrawPicture;
    //尺寸
    FTabSize:Double;
    //当前下标
    FPageIndex:Integer;

    //分页是否显示
    FTabVisible:Boolean;

    FSwitchSize:Double;


    FSkinTabSheetIntf:ISkinTabSheet;

    FNotifyNumberIconControl:TControl;
    FNotifyNumberIconControlIntf:ISkinControl;
    FNotifyNumberIconIntf:ISkinNotifyNumberIcon;

    procedure DoNotifyNumberIconInvalidate(Sender:TObject);

    procedure SetNotifyNumberIconControl(const Value: TControl);

    procedure SetIcon(const Value: TDrawPicture);
    procedure SetPushedIcon(const Value: TDrawPicture);
    procedure SetTabSize(const Value: Double);
    procedure SetTabVisible(const Value:Boolean);
    procedure SetPageControl(Value:TSkinPageControl);
    procedure SetPageIndex(const Value: Integer);
    function GetPageIndex: Integer;
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public

    //所属的PageControl
    FPageControl:TSkinPageControl;
    FSkinPageControlIntf:ISkinPageControl;

    //获取分类名称
    function GetComponentClassify:String;override;
    //所属的PageControl
    property SkinPageControlIntf:ISkinPageControl read FSkinPageControlIntf;
  published
    //暂时不用
    property SwitchSize:Double read FSwitchSize write FSwitchSize Stored False;



    /// <summary>
    ///   <para>
    ///     是否显示
    ///   </para>
    ///   <para>
    ///     Whether display
    ///   </para>
    /// </summary>
    property TabVisible:Boolean read FTabVisible write SetTabVisible;

    /// <summary>
    ///   <para>
    ///     图标
    ///   </para>
    ///   <para>
    ///     Icon
    ///   </para>
    /// </summary>
    property Icon:TDrawPicture read FIcon write SetIcon;

    /// <summary>
    ///   <para>
    ///     顺序下标
    ///   </para>
    ///   <para>
    ///     Order Index
    ///   </para>
    /// </summary>
    property PageIndex:Integer read GetPageIndex write SetPageIndex;

    /// <summary>
    ///   <para>
    ///     标签按钮的尺寸
    ///   </para>
    ///   <para>
    ///     Size
    ///   </para>
    /// </summary>
    property TabSize:Double read FTabSize write SetTabSize;

    /// <summary>
    ///   <para>
    ///     按下状态的图标
    ///   </para>
    ///   <para>
    ///     Icon of pressed state
    ///   </para>
    /// </summary>
    property PushedIcon:TDrawPicture read FPushedIcon write SetPushedIcon;

    /// <summary>
    ///   <para>
    ///     所属的多页控件
    ///   </para>
    ///   <para>
    ///    Belonged MultiPage control
    ///   </para>
    /// </summary>
    property PageControl:TSkinPageControl read FPageControl write SetPageControl;

    /// <summary>
    ///   <para>
    ///     所绑定的提醒数字图标控件
    ///   </para>
    ///   <para>
    ///     Binding NotifyNumber icon control
    ///   </para>
    /// </summary>
    property NotifyNumberIconControl:TControl read FNotifyNumberIconControl write SetNotifyNumberIconControl;
  end;



  TSkinSwitchPageControlGestureManager=class(TBaseSkinSwitchPageGestureManager)
  protected
    FProperties:TPageControlProperties;
  protected
    function GetPageIndex:Integer;override;
    procedure SetPageIndex(APageIndex:Integer);override;
    function GetPageCount:Integer;override;
    function GetBaseControlStartPos:Double;override;
    function GetPageItemSize(APageIndex:Integer;AGestureKind:TGestureKind;AGestureDirection:TGestureDirection):Double;override;
    procedure SetPagePos(APageIndex:Integer;AGestureKind:TGestureKind;APos:Double);override;
  end;




  /// <summary>
  ///   <para>
  ///     多页控件属性
  ///   </para>
  ///   <para>
  ///     PageControl properties
  ///   </para>
  /// </summary>
//  TPageControlProperties=class(TSwitchPageListPanelProperties)
  TPageControlProperties=class(TSkinControlProperties)
  protected
    FPages:TBaseList;
    //可见的分页列表
    FVisiblePages:TBaseList;

    FMouseDownPage:TSkinTabSheet;
    FMouseOverPage:TSkinTabSheet;

    //当前选中的分页
    FActivePage:TSkinTabSheet;
    //以FActivePage为主,FActivePage.PageIndex，以FActivePage确定FActivePageIndex
    FActivePageIndex:Integer;


    //分页按钮是否居中
    FIsTabHeaderCenter:Boolean;


    FTabSize:Integer;
    FTabSizeCalcType: TTabSizeCalcType;

    FTabHeaderHeight:Integer;

    FOrientation: TTabOrientation;


//    FIsAutoSwitchPageAnimating:Boolean;
    FSwitchPageAnimated:Boolean;
    FSwitchPageAnimateSpeed:Double;


    FSkinPageControlIntf:ISkinPageControl;

    FSkinSwitchPageControlGestureManager:TSkinSwitchPageControlGestureManager;

    //放置TabControl的区域
    function GetPageRect:TRectF;
    procedure SetTabHeaderHeight(const Value: Integer);
    //头部区域
    function GetHeaderRect: TRectF;
    //头部放置页面按钮的区域
    function GetDrawTabButtonsHeaderRect: TRectF;


    procedure SetTabSize(const Value: Integer);
    procedure SetOrientation(const Value: TTabOrientation);
    procedure SetTabSizeCalcType(const Value: TTabSizeCalcType);
    procedure SetIsTabHeaderCenter(const Value: Boolean);
    procedure SetMouseDownPage(const Value: TSkinTabSheet);
    procedure SetMouseOverPage(const Value: TSkinTabSheet);

    //调用SetActivePageIndex
    procedure SetActivePage(Page: TSkinTabSheet);
    function GetActivePage:TSkinTabSheet;

    //调用ChangeActivePage
    procedure SetActivePageIndex(Value: Integer);
    function GetActivePageIndex:Integer;

    function GetPageCount:Integer;
  protected
    procedure DoChange;
    //重新生成可视分页列表,会刷新控件
    procedure ReBuildPageIndexAndVisiblePages(Page: TSkinTabSheet);

    procedure DoPagesChange(Sender:TObject);
    procedure DoPageDelete(Sender:TObject;AItem:TObject;AIndex:Integer);

    function GetPage(Index: Integer):TSkinTabSheet;
    function GetTabSheetIntf(Index: Integer):ISkinTabSheet;
    function GetVisibleTabSheetIntf(VisibleIndex: Integer):ISkinTabSheet;


    //TTabSheetProperties.SetPageControl中调用
    procedure AddPage(Page: TSkinTabSheet);
    procedure RemovePage(Page: TSkinTabSheet);

    procedure ChangeActivePage(Page: TSkinTabSheet;HasAligned:Boolean=False);
    function GetCanGesutreSwitch: Boolean;
    procedure SetCanGesutreSwitch(const Value: Boolean);
  private
    FIsAfterPaintTabIcon: Boolean;
    procedure SetIsAfterPaintTabIcon(const Value: Boolean);

  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
//  protected
//    procedure DoSwitchPageListControlGestureManagerPageIndexChange(Sender:TObject;APageIndex:Integer);
//    procedure DoSwitchPageListControlGestureManagerPageCountChange(Sender:TObject);
//    procedure DoSwitchPageListControlGestureManagerGetPageCount(Sender:TObject;var Param:Integer);
//    procedure DoSwitchPageListControlGestureManagerGetPageIndex(Sender:TObject;var Param:Integer);
//    procedure DoSwitchPageListControlGestureManagerGetPageWidth(Sender:TObject;Index:Integer;var Param:Double);
//    procedure DoSwitchPageListControlGestureManagerGetPageHeight(Sender:TObject;Index:Integer;var Param:Double);
//    procedure DoSwitchPageListControlGestureManagerGetPageControl(Sender:TObject;APageIndex:Integer;var AControl:TControl);
//    procedure DoSwitchPageListControlGestureManagerPageListSwitchingProgressChange(Sender: TObject);
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public


    //获取分类名称
    function GetComponentClassify:String;override;
    //排列切换按钮
    procedure AlignSwitchButtons;
    //切换按钮点击事件
    procedure DoImageListSwitchButtonClick(Sender:TObject);

    property SwitchPageControlGestureManager:TSkinSwitchPageControlGestureManager read FSkinSwitchPageControlGestureManager;
  public
    //清空所有分页
    procedure ClearPages;
    //分页按PageIndex排序
//    procedure SortPages;
    //排列分页
    procedure AlignPages;
    //指定坐标的分页
    function PageAt(X,Y:Double):TSkinTabSheet;
    //获取分页按钮的绘制矩形
    function GetVisibleTabDrawRect(VisibleIndex:Integer):TRectF;
    function GetVisibleTabIconDrawRect(ATabSheet:TSkinTabSheet;ATabIconDrawRect:TRectF):TRectF;
    //分页矩形
    property PageRect:TRectF read GetPageRect;
    //标签头矩形
    property HeaderRect:TRectF read GetHeaderRect;
  public
    property Pages[Index:Integer]:TSkinTabSheet read GetPage;
    property MouseDownPage:TSkinTabSheet read FMouseDownPage write SetMouseDownPage;
    property MouseOverPage:TSkinTabSheet read FMouseOverPage write SetMouseOverPage;
  published
    property CanGesutreSwitch:Boolean read GetCanGesutreSwitch write SetCanGesutreSwitch;
    property SwitchPageAnimated:Boolean read FSwitchPageAnimated write FSwitchPageAnimated;
    property SwitchPageAnimateSpeed:Double read FSwitchPageAnimateSpeed write FSwitchPageAnimateSpeed;
  published

    /// <summary>
    ///   <para>
    ///     页数
    ///   </para>
    ///   <para>
    ///     Page numbers
    ///   </para>
    /// </summary>
    property PageCount:Integer read GetPageCount;

    /// <summary>
    ///   <para>
    ///     当前选中页
    ///   </para>
    ///   <para>
    ///     Active Page
    ///   </para>
    /// </summary>
    property ActivePage:TSkinTabSheet read GetActivePage write SetActivePage;

    /// <summary>
    ///   <para>
    ///     当前选中的页下标
    ///   </para>
    ///   <para>
    ///     Index of active page
    ///   </para>
    /// </summary>
    property ActivePageIndex:Integer read GetActivePageIndex write SetActivePageIndex;
  published
    property IsAfterPaintTabIcon:Boolean read FIsAfterPaintTabIcon write SetIsAfterPaintTabIcon;
    /// <summary>
    ///   <para>
    ///     标签头居中
    ///   </para>
    ///   <para>
    ///     TabHeader center
    ///   </para>
    /// </summary>
    property IsTabHeaderCenter:Boolean read FIsTabHeaderCenter write SetIsTabHeaderCenter;


    /// <summary>
    ///   <para>
    ///     标签按钮的宽度
    ///   </para>
    ///   <para>
    ///     TabButton's width
    ///   </para>
    /// </summary>
    property TabSize:Integer read FTabSize write SetTabSize;

    /// <summary>
    ///   <para>
    ///     标签按钮尺寸计算类型
    ///   </para>
    ///   <para>
    ///     Caiculate type of TabButton size
    ///   </para>
    /// </summary>
    property TabSizeCalcType:TTabSizeCalcType read FTabSizeCalcType write SetTabSizeCalcType;

    /// <summary>
    ///   <para>
    ///     标签头的摆放位置类型
    ///   </para>
    ///   <para>
    ///     Orientation
    ///   </para>
    /// </summary>
    property Orientation:TTabOrientation read FOrientation write SetOrientation;

    /// <summary>
    ///   <para>
    ///     标签头的高度
    ///   </para>
    ///   <para>
    ///     TabHeader height
    ///   </para>
    /// </summary>
    property TabHeaderHeight:Integer read FTabHeaderHeight write SetTabHeaderHeight;
  end;

















  /// <summary>
  ///   <para>
  ///     分页的素材基类
  ///   </para>
  ///   <para>
  ///     TabSheet material base class
  ///   </para>
  /// </summary>
  TSkinTabSheetMaterial=class(TSkinControlMaterial)
  private
    FBackGndPicture: TDrawPicture;
    FDrawBackGndPictureParam: TDrawPictureParam;
//    FIsDrawBackGndPicture: Boolean;

    //参数矩形绘制设置
    FDrawNotifyNumberIconRectSetting:TDrawRectSetting;

    procedure SetDrawNotifyNumberIconRectSetting(const Value: TDrawRectSetting);
    procedure SetBackGndPicture(const Value: TDrawPicture);
    procedure SetDrawBackGndPictureParam(const Value: TDrawPictureParam);
//    procedure SetIsDrawBackGndPicture(const Value: Boolean);
//    procedure DoPropChange(Sender:TObject);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //
    /// <summary>
    ///   <para>
    ///     背景图片
    ///   </para>
    ///   <para>
    ///     Background Picture
    ///   </para>
    /// </summary>
    property BackGndPicture:TDrawPicture read FBackGndPicture write SetBackGndPicture;
    //
    /// <summary>
    ///   <para>
    ///     背景图片的绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of background picture
    ///   </para>
    /// </summary>
    property BackGndPictureParam: TDrawPictureParam read FDrawBackGndPictureParam write SetDrawBackGndPictureParam;
    /// <summary>
    ///   <para>
    ///     背景图片的绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of background picture
    ///   </para>
    /// </summary>
    property DrawBackGndPictureParam: TDrawPictureParam read FDrawBackGndPictureParam write SetDrawBackGndPictureParam;
//    //是否绘制背景
//    property IsDrawBackGndPicture:Boolean read FIsDrawBackGndPicture write SetIsDrawBackGndPicture ;//default False;
    //
    /// <summary>
    ///   <para>
    ///     提醒数字图标控件的绘制矩形设置
    ///   </para>
    ///   <para>
    ///     Set draw rectangle of notifying number icon control
    ///   </para>
    /// </summary>
    property DrawNotifyNumberIconRectSetting:TDrawRectSetting read FDrawNotifyNumberIconRectSetting write SetDrawNotifyNumberIconRectSetting;
  end;




  /// <summary>
  ///   <para>
  ///     多页控件素材基类
  ///   </para>
  ///   <para>
  ///     Base class of page control material
  ///   </para>
  /// </summary>
//  TSkinPageControlMaterial=class(TSkinSwitchPageListPanelMaterial)
  TSkinPageControlMaterial=class(TSkinControlMaterial)
  private
    //标签按钮正常状态图片
    FTabNormalPicture: TDrawPicture;
    //标签按钮鼠标停靠状态图片
    FTabHoverPicture: TDrawPicture;
    //标签按钮鼠标按下状态图片
    FTabDownPicture: TDrawPicture;
//    //标签按钮禁用状态图片
//    FTabDisabledPicture: TDrawPicture;
//    //标签按钮得到焦点状态图片
//    FTabFocusedPicture: TDrawPicture;
    //标签按钮按下状态图片
    FTabPushedPicture: TDrawPicture;

    //标签按钮图片绘制参数
    FDrawTabPictureParam:TDrawPictureParam;

    //标签按钮标题绘制参数
    FDrawTabCaptionParam:TDrawTextParam;
    //标签按钮图标绘制参数
    FDrawTabIconParam:TDrawPictureParam;

    //标签按钮背景颜色绘制参数
    FDrawTabBackColorParam:TDrawRectParam;
    FDrawTabBackColor2Param:TDrawRectParam;



    //背景图片
    FBackGndPicture: TDrawPicture;
    //背景图片绘制参数
    FDrawBackGndPictureParam: TDrawPictureParam;


    //标签头背景图片
    FTabHeaderPicture: TDrawPicture;
    //标签头背景图片绘制参数
    FDrawTabHeaderPictureParam: TDrawPictureParam;
    //标签头背景颜色绘制参数
    FDrawTabHeaderColorParam: TDrawRectParam;





//    //是否绘制背景图片
//    FIsDrawBackGndPicture: Boolean;
//    //是否绘制标签头背景图片
//    FIsDrawTabHeaderPicture: Boolean;



    procedure SetDrawTabCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawTabIconParam(const Value: TDrawPictureParam);
    procedure SetDrawTabPictureParam(const Value: TDrawPictureParam);

//    procedure SetIsDrawBackGndPicture(const Value: Boolean);
    procedure SetDrawBackGndPictureParam(const Value: TDrawPictureParam);

//    procedure SetIsDrawTabHeaderPicture(const Value: Boolean);
    procedure SetDrawTabHeaderPictureParam(const Value: TDrawPictureParam);
    procedure SetDrawTabHeaderColorParam(const Value: TDrawRectParam);


    procedure SetDrawTabBackColorParam(const Value: TDrawRectParam);
    procedure SetDrawTabBackColor2Param(const Value: TDrawRectParam);

    procedure SetTabPushedPicture(const Value: TDrawPicture);
    procedure SetTabHoverPicture(const Value: TDrawPicture);
    procedure SetTabNormalPicture(const Value: TDrawPicture);
    procedure SetTabDownPicture(const Value: TDrawPicture);
//    procedure SetTabFocusedPicture(const Value: TDrawPicture);
//    procedure SetTabDisabledPicture(const Value: TDrawPicture);

    procedure SetBackGndPicture(const Value: TDrawPicture);
    procedure SetTabHeaderPicture(const Value: TDrawPicture);
//  protected
//    procedure AssignTo(Dest: TPersistent); override;
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //
    /// <summary>
    ///   <para>
    ///     标签按钮图标绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabButton icon
    ///   </para>
    /// </summary>
    property DrawTabIconParam:TDrawPictureParam read FDrawTabIconParam write SetDrawTabIconParam;
    //
    /// <summary>
    ///   <para>
    ///     标签按钮标题绘制参数
    ///   </para>
    ///   <para>
    ///     TabButton caption draw parameter
    ///   </para>
    /// </summary>
    property DrawTabCaptionParam:TDrawTextParam read FDrawTabCaptionParam write SetDrawTabCaptionParam;








    //
    /// <summary>
    ///   <para>
    ///     标签按钮正常状态图片
    ///   </para>
    ///   <para>
    ///     TabButton normal state picture
    ///   </para>
    /// </summary>
    property TabNormalPicture:TDrawPicture read FTabNormalPicture write SetTabNormalPicture;
    //
    /// <summary>
    ///   <para>
    ///     标签按钮鼠标停靠状态图片
    ///   </para>
    ///   <para>
    ///     TabButton mouse hovering state picture
    ///   </para>
    /// </summary>
    property TabHoverPicture:TDrawPicture read FTabHoverPicture write SetTabHoverPicture;
    //
    /// <summary>
    ///   <para>
    ///     标签按钮鼠标按下状态图片
    ///   </para>
    ///   <para>
    ///   TabButton mouse pressed state picture
    ///   </para>
    /// </summary>
    property TabDownPicture: TDrawPicture read FTabDownPicture write SetTabDownPicture;


//    //标签按钮禁用状态图片
//    property TabDisabledPicture: TDrawPicture read FTabDisabledPicture write SetTabDisabledPicture;
//    //标签按钮得到焦点状态图片
//    property TabFocusedPicture: TDrawPicture read FTabFocusedPicture write SetTabFocusedPicture;


    //
    /// <summary>
    ///   <para>
    ///     标签按钮按下状态图片
    ///   </para>
    ///   <para>
    ///   TabButton pressed state picture
    ///   </para>
    /// </summary>
    property TabPushedPicture:TDrawPicture read FTabPushedPicture write SetTabPushedPicture;
    //
    /// <summary>
    ///   <para>
    ///     标签按钮背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabButton background picture
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawTabPictureParam write SetDrawTabPictureParam;
    /// <summary>
    ///   <para>
    ///     标签按钮背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabButton background picture
    ///   </para>
    /// </summary>
    property DrawTabPictureParam:TDrawPictureParam read FDrawTabPictureParam write SetDrawTabPictureParam;







    //
    /// <summary>
    ///   <para>
    ///     标签按钮背景颜色绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabButton background color
    ///   </para>
    /// </summary>
    property TabBackColor:TDrawRectParam read FDrawTabBackColorParam write SetDrawTabBackColorParam;
    /// <summary>
    ///   <para>
    ///     标签按钮背景颜色绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabButton background color
    ///   </para>
    /// </summary>
    property DrawTabBackColorParam:TDrawRectParam read FDrawTabBackColorParam write SetDrawTabBackColorParam;
    property DrawTabBackColor2Param:TDrawRectParam read FDrawTabBackColor2Param write SetDrawTabBackColor2Param;
  published
//    //是否绘制背景图片
//    property IsDrawBackGndPicture:Boolean read FIsDrawBackGndPicture write SetIsDrawBackGndPicture ;//default False;


    //
    /// <summary>
    ///   <para>
    ///     背景图片
    ///   </para>
    ///   <para>
    ///     Background picture
    ///   </para>
    /// </summary>
    property BackGndPicture:TDrawPicture read FBackGndPicture write SetBackGndPicture;
    //
    /// <summary>
    ///   <para>
    ///     背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of background picture
    ///   </para>
    /// </summary>
    property DrawBackGndPictureParam: TDrawPictureParam read FDrawBackGndPictureParam write SetDrawBackGndPictureParam;



//    //是否绘制标签头图片
//    property IsDrawTabHeaderPicture:Boolean read FIsDrawTabHeaderPicture write SetIsDrawTabHeaderPicture ;//default False;


    //
    /// <summary>
    ///   <para>
    ///     标签头背景图片
    ///   </para>
    ///   <para>
    ///     Tab header background picture
    ///   </para>
    /// </summary>
    property TabHeaderPicture:TDrawPicture read FTabHeaderPicture write SetTabHeaderPicture;
    //
    /// <summary>
    ///   <para>
    ///     标签头背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabHeader background picture
    ///   </para>
    /// </summary>
    property DrawTabHeaderPictureParam: TDrawPictureParam read FDrawTabHeaderPictureParam write SetDrawTabHeaderPictureParam;
    /// <summary>
    ///   <para>
    ///     标签头背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabHeader background picture
    ///   </para>
    /// </summary>
    property TabHeaderPictureParam: TDrawPictureParam read FDrawTabHeaderPictureParam write SetDrawTabHeaderPictureParam;
    //
    /// <summary>
    ///   <para>
    ///     标签头背景颜色绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of TabHeader background color
    ///   </para>
    /// </summary>
    property DrawTabHeaderColorParam: TDrawRectParam read FDrawTabHeaderColorParam write SetDrawTabHeaderColorParam;


  end;

















  TSkinTabSheetType=class(TSkinControlType)
  protected
    FSkinTabSheetIntf:ISkinTabSheet;
    function GetSkinMaterial:TSkinTabSheetMaterial;
  protected
    function CalcCurrentEffectStates:TDPEffectStates;override;

    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    procedure TextChanged;override;
    procedure Invalidate;override;
  end;


//  TSkinPageControlType=class(TSkinSwitchPageListPanelType)
  TSkinPageControlType=class(TSkinControlType)
  protected
    FSkinPageControlIntf:ISkinPageControl;
    function GetSkinMaterial:TSkinPageControlMaterial;
  public
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState;X,Y:Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;
  protected
    procedure PaintPageControlTabIcons(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData);
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //
    procedure SizeChanged;override;
  end;












  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTabSheetDefaultMaterial=class(TSkinTabSheetMaterial);
  TSkinTabSheetDefaultType=TSkinTabSheetType;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinPageControlDefaultMaterial=class(TSkinPageControlMaterial);
  TSkinPageControlDefaultType=TSkinPageControlType;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTabSheet=class(TBaseSkinControl,ISkinTabSheet)
  private
    function GetTabSheetProperties:TTabSheetProperties;
    procedure SetTabSheetProperties(Value:TTabSheetProperties);
    function GetTabVisible: Boolean;
    procedure SetTabVisible(const Value: Boolean);
    function GetPageControl: TSkinPageControl;
    procedure SetPageControl(const Value: TSkinPageControl);
    function GetPageIndex: Integer;
    procedure SetPageIndex(const Value: Integer);
  protected
    procedure ReadState(Reader: TReader); override;
    procedure Loaded;override;
    procedure Notification(AComponent: TComponent;Operation: TOperation);override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    property Prop:TTabSheetProperties read GetTabSheetProperties write SetTabSheetProperties;
  public
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    DataObject:TObject;
    function SelfOwnMaterialToDefault:TSkinTabSheetDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinTabSheetDefaultMaterial;
    function Material:TSkinTabSheetDefaultMaterial;
    property TabVisible:Boolean read GetTabVisible write SetTabVisible;
    property PageControl:TSkinPageControl read GetPageControl write SetPageControl;
    property PageIndex:Integer read GetPageIndex write SetPageIndex;
  published
    //标题
    property Caption;
    property Text;
    //属性
    property Properties:TTabSheetProperties read GetTabSheetProperties write SetTabSheetProperties;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
//  TSkinPageControl=class(TSkinSwitchPageListPanel,ISkinPageControl)
  TSkinPageControl=class(TBaseSkinControl,ISkinPageControl)
  private

    FOnChange: TNotifyEvent;
    FOnChanging: TPageChangingEvent;
    FOnCustomCalcHeadDrawRect:TCustomCalcHeadDrawRectEvent;
    FOnCustomCalcTabDrawRect:TCustomCalcTabDrawRectEvent;
    FOnCustomCalcTabIconDrawRect:TCustomCalcTabDrawIconRectEvent;

    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);

    function GetOnChanging: TPageChangingEvent;
    procedure SetOnChanging(const Value: TPageChangingEvent);
    function GetOnCustomCalcTabDrawRect:TCustomCalcTabDrawRectEvent;
    function GetOnCustomCalcTabIconDrawRect:TCustomCalcTabDrawIconRectEvent;
    function GetOnCustomCalcHeadDrawRect:TCustomCalcHeadDrawRectEvent;

    function GetPageControlProperties:TPageControlProperties;
    procedure SetPageControlProperties(Value:TPageControlProperties);
    function GetActivePage: TSkinTabSheet;
    procedure SetActivePage(const Value: TSkinTabSheet);
    procedure SetOnCustomCalcHeadDrawRect(
      const Value: TCustomCalcHeadDrawRectEvent);
    procedure SetOnCustomCalcTabDrawRect(
      const Value: TCustomCalcTabDrawRectEvent);
    procedure SetOnCustomCalcTabIconDrawRect(
      const Value: TCustomCalcTabDrawIconRectEvent);
  protected
    //水平滚动条
    FSwitchButtonGroup:TSkinBaseButtonGroup;
//    FSwitchButtonGroupControlIntf:ISkinControl;
//    FSwitchButtonGroupComponentIntf:ISkinComponent;
    FSwitchButtonGroupIntf:ISkinButtonGroup;
    procedure SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
  public
    //水平滚动条
    function GetSwitchButtonGroup:TSkinBaseButtonGroup;
    function GetSwitchButtonGroupIntf:ISkinButtonGroup;
//    function GetSwitchButtonGroupControlIntf:ISkinControl;
//    function GetSwitchButtonGroupComponentIntf:ISkinComponent;
  protected
    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    procedure AfterPaint;{$IFDEF FMX}override;{$ENDIF}
  public
    procedure StayClick;override;
  public
    destructor Destroy;override;
  public
    property Prop:TPageControlProperties read GetPageControlProperties write SetPageControlProperties;
  public
    function SelfOwnMaterialToDefault:TSkinPageControlDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinPageControlDefaultMaterial;
    function Material:TSkinPageControlDefaultMaterial;
    property ActivePage:TSkinTabSheet read GetActivePage write SetActivePage;
    function PageCount:Integer;
  published
    //更改事件
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property OnChanging: TPageChangingEvent read FOnChanging write SetOnChanging;
    property OnCustomCalcTabDrawRect:TCustomCalcTabDrawRectEvent read GetOnCustomCalcTabDrawRect write SetOnCustomCalcTabDrawRect;
    property OnCustomCalcTabIconDrawRect:TCustomCalcTabDrawIconRectEvent read GetOnCustomCalcTabIconDrawRect write SetOnCustomCalcTabIconDrawRect;
    property OnCustomCalcHeadDrawRect:TCustomCalcHeadDrawRectEvent read GetOnCustomCalcHeadDrawRect write SetOnCustomCalcHeadDrawRect;
    property SwitchButtonGroup: TSkinBaseButtonGroup read GetSwitchButtonGroup write SetSwitchButtonGroup;
    //属性
    property Properties:TPageControlProperties read GetPageControlProperties write SetPageControlProperties;
  end;



  {$IFDEF VCL}
  TSkinWinTabSheet=class(TSkinTabSheet)
  end;
  TSkinWinPageControl=class(TSkinPageControl)
  end;
  {$ENDIF VCL}





//var
//  //如果是IPhoneX,那么底部要拖起来
//  GlobalIPhoneXBottomBarHeight:Double;
//
//function IsIPhoneX: Boolean;

implementation


//function IsIPhoneX: Boolean;
//{$IFDEF IOS}
//const
//  cIPhoneXHeight = 812;
//var
//  LOrientation: UIInterfaceOrientation;
//{$ENDIF IOS}
//begin
//  Result := False;
//  {$IFDEF IOS}
//  // Might be safe enough to just use statusBarOrientation
//  if SharedApplication.keyWindow = nil then
//    LOrientation := SharedApplication.statusBarOrientation
//  else
//    LOrientation := SharedApplication.keyWindow.rootViewController.interfaceOrientation;
//  case LOrientation of
//    UIInterfaceOrientationPortrait, UIInterfaceOrientationPortraitUpsideDown:
//      Result := TiOSHelper.MainScreen.bounds.size.height = cIPhoneXHeight;
//    UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight:
//      Result := TiOSHelper.MainScreen.bounds.size.width = cIPhoneXHeight;
//  end;
//  {$ENDIF IOS}
//end;



{ TSkinPageControlType }

function TSkinPageControlType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinPageControl,Self.FSkinPageControlIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinPageControl Interface');
    end;
  end;
end;

procedure TSkinPageControlType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinPageControlIntf:=nil;
end;

function TSkinPageControlType.GetSkinMaterial: TSkinPageControlMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinPageControlMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


procedure TSkinPageControlType.PaintPageControlTabIcons(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData);
var
  I: Integer;
  ATabIcon:TDrawPicture;
  ATabDrawRect:TRectF;
  ATabIconDrawRect:TRectF;
  ATempTabDrawRect:TRectF;
  ATabSheet:TSkinTabSheet;
  ATabSheetIntf:ISkinTabSheet;
  ATabSheetControlIntf:ISkinControl;
  ATabDrawPicture:TDrawPicture;

  AItemEffectStates:TDPEffectStates;
  AItemPaintData:TPaintData;
  ANotifyNumberIconControlIntf:ISkinControl;
var
  ANotifySkinMaterial:TSkinControlMaterial;
begin

  if Self.GetSkinMaterial<>nil then
  begin

//    if not GlobalIsGetedIPhoneX then
//    begin
//      IsIPhoneX(TForm(Application.MainForm));
//    end;


//    //绘制整体背景
//    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawBackGndPictureParam,
//                        Self.GetSkinMaterial.FBackGndPicture,
//                        ADrawRect);


    if (Self.FSkinPageControlIntf.PageControlProperties.FOrientation=TTabOrientation.toNone)
     or (Self.FSkinPageControlIntf.PageControlProperties.FTabHeaderHeight<=0) then
    begin
      Exit;
    end;


//    ACanvas.DrawRect(Self.GetSkinMaterial.FDrawTabHeaderColorParam,
//                        Self.FSkinPageControlIntf.PageControlProperties.HeaderRect);


//    if    (Self.FSkinPageControlIntf.PageControlProperties.FOrientation<>TTabOrientation.toNone)
//      and (Self.FSkinPageControlIntf.PageControlProperties.FTabHeaderHeight>0) then
//    begin
//      //绘制头部背景
//      ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawTabHeaderPictureParam,
//                          Self.GetSkinMaterial.FTabHeaderPicture,
//                          Self.FSkinPageControlIntf.PageControlProperties.HeaderRect);
//    end;


    if Self.FSkinPageControlIntf.PageControlProperties.FVisiblePages.Count=0 then Exit;



    for I := 0 to Self.FSkinPageControlIntf.PageControlProperties.FVisiblePages.Count-1 do
    begin
          ATabSheet:=TSkinTabSheet(Self.FSkinPageControlIntf.PageControlProperties.FVisiblePages[I]);
          ATabSheetIntf:=ATabSheet as ISkinTabSheet;
          ATabSheetControlIntf:=ATabSheet as ISkinControl;
          ATabDrawRect:=Self.FSkinPageControlIntf.PageControlProperties.GetVisibleTabDrawRect(I);


          if   IsSameDouble(RectWidthF(ATabDrawRect),0)
            or IsSameDouble(RectHeightF(ATabDrawRect),0) then
          begin
            Continue;
          end;


          AItemEffectStates:=[];
          if Self.FSkinPageControlIntf.PageControlProperties.FMouseOverPage=ATabSheet then
          begin
            AItemEffectStates:=AItemEffectStates+[dpstMouseOver];
          end;
          if Self.FSkinPageControlIntf.PageControlProperties.FMouseDownPage=ATabSheet then
          begin
            AItemEffectStates:=AItemEffectStates+[dpstMouseDown];
          end;
          if Self.FSkinPageControlIntf.PageControlProperties.FActivePage=ATabSheet then
          begin
            AItemEffectStates:=AItemEffectStates+[dpstPushed];
          end;

//          Self.GetSkinMaterial.FDrawTabPictureParam.StaticEffectStates:=AItemEffectStates;
//          Self.GetSkinMaterial.FDrawTabCaptionParam.StaticEffectStates:=AItemEffectStates;
          Self.GetSkinMaterial.FDrawTabIconParam.StaticEffectStates:=AItemEffectStates;
//          Self.GetSkinMaterial.FDrawTabBackColorParam.StaticEffectStates:=AItemEffectStates;
//          Self.GetSkinMaterial.FDrawTabBackColor2Param.StaticEffectStates:=AItemEffectStates;

          //处理绘制参数的透明度
//          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabPictureParam);
//          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabCaptionParam);
          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabIconParam);
//          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabBackColorParam);
//          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabBackColor2Param);



//          //绘制背景颜色
//          ACanvas.DrawRect(Self.GetSkinMaterial.FDrawTabBackColorParam,ATabDrawRect);
//          ACanvas.DrawRect(Self.GetSkinMaterial.FDrawTabBackColor2Param,ATabDrawRect);



//          //绘制背景图片
//          ATabDrawPicture:=nil;
//    //        if Not Self.FSkinControlIntf.Enabled then
//    //        begin
//    //          ATabDrawPicture:=Self.GetSkinMaterial.FTabDisabledPicture;
//    //        end
//    //        else
//          if ATabSheet=Self.FSkinPageControlIntf.PageControlProperties.ActivePage then
//          begin
//            ATabDrawPicture:=Self.GetSkinMaterial.FTabPushedPicture;
//          end
//          else
//          if (ATabSheet=Self.FSkinPageControlIntf.PageControlProperties.MouseDownPage) and APaintData.IsDrawInteractiveState then
//          begin
//            ATabDrawPicture:=Self.GetSkinMaterial.FTabDownPicture;
//          end
//          else if (ATabSheet=Self.FSkinPageControlIntf.PageControlProperties.MouseOverPage) and APaintData.IsDrawInteractiveState then
//          begin
//            ATabDrawPicture:=Self.GetSkinMaterial.FTabHoverPicture;
//          end
//          else
//          begin
//            ATabDrawPicture:=Self.GetSkinMaterial.FTabNormalPicture;
//          end;
//          if ATabDrawPicture.CurrentPictureIsEmpty then
//          begin
//            ATabDrawPicture:=Self.GetSkinMaterial.FTabNormalPicture;
//          end;
//          ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawTabPictureParam,
//                              ATabDrawPicture,
//                              ATabDrawRect);




          ATempTabDrawRect:=ATabDrawRect;
          //标签头在底部才需要抬高
          if (Self.FSkinPageControlIntf.PageControlProperties.FOrientation=TTabOrientation.toBottom)
            and IsIPhoneX(TForm(Application.MainForm)) then
          begin
            //IPhoneX底部要抬起来20
            ATempTabDrawRect.Bottom:=ATempTabDrawRect.Bottom-GlobalIPhoneXBottomBarHeight;
          end;


//          if not Self.FSkinPageControlIntf.PageControlProperties.FIsAfterPaintTabIcon then
//          begin
//
              ATabIconDrawRect:=Self.FSkinPageControlIntf.PageControlProperties.GetVisibleTabIconDrawRect(ATabSheet,ATempTabDrawRect);
              //绘制图标
              if Self.FSkinPageControlIntf.PageControlProperties.FActivePage<>ATabSheet then
              begin
                ATabIcon:=ATabSheetIntf.Prop.FIcon;
              end
              else
              begin
                ATabIcon:=ATabSheetIntf.Prop.FPushedIcon;
              end;
              if ATabIcon.CurrentPictureIsEmpty then
              begin
                ATabIcon:=ATabSheetIntf.Prop.FIcon;
              end;
              ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawTabIconParam,
                                  ATabIcon,
                                  ATabIconDrawRect);


              //绘制通知图标
              if ATabSheetIntf.Prop.FNotifyNumberIconControlIntf<>nil then
              begin

                ANotifyNumberIconControlIntf:=ATabSheetIntf.Prop.FNotifyNumberIconControlIntf;
                if ANotifyNumberIconControlIntf.GetSkinControlType<>nil then
                begin
                  //绘制
                  ANotifyNumberIconControlIntf.GetSkinControlType.IsUseCurrentEffectStates:=True;
                  ANotifyNumberIconControlIntf.GetSkinControlType.CurrentEffectStates:=AItemEffectStates;
                  //绘制
                  AItemPaintData:=GlobalNullPaintData;
                  AItemPaintData.IsDrawInteractiveState:=True;
                  AItemPaintData.IsInDrawDirectUI:=APaintData.IsInDrawDirectUI;
                  ANotifySkinMaterial:=ANotifyNumberIconControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
                  ANotifyNumberIconControlIntf.GetSkinControlType.Paint(ACanvas,
                            ANotifySkinMaterial,
                            TSkinTabSheetMaterial(ATabSheetControlIntf.GetCurrentUseMaterial).FDrawNotifyNumberIconRectSetting.CalcDrawRect(ATabDrawRect),
                            AItemPaintData);
                end;

              end;



//          end;
//
//
//          //绘制标题
//          ACanvas.DrawText(Self.GetSkinMaterial.FDrawTabCaptionParam,
//                            ATabSheetControlIntf.Caption,
//                            ATempTabDrawRect);
//
//
//

    end;




  end;

end;

procedure TSkinPageControlType.SizeChanged;
begin
  inherited;
  Self.FSkinPageControlIntf.PageControlProperties.AlignPages;
end;

function TSkinPageControlType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  I: Integer;
  ATabIcon:TDrawPicture;
  ATabDrawRect:TRectF;
  ATempTabDrawRect:TRectF;
  ATabSheet:TSkinTabSheet;
  ATabSheetIntf:ISkinTabSheet;
  ATabSheetControlIntf:ISkinControl;
  ATabDrawPicture:TDrawPicture;

  AItemEffectStates:TDPEffectStates;
  AItemPaintData:TPaintData;
  ANotifyNumberIconControlIntf:ISkinControl;
var
  ANotifySkinMaterial:TSkinControlMaterial;
begin

  if Self.GetSkinMaterial<>nil then
  begin

//    if not GlobalIsGetedIPhoneX then
//    begin
//      IsIPhoneX(TForm(Application.MainForm));
//    end;


    //绘制整体背景
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawBackGndPictureParam,
                        Self.GetSkinMaterial.FBackGndPicture,
                        ADrawRect);


    if (Self.FSkinPageControlIntf.PageControlProperties.FOrientation=TTabOrientation.toNone)
     or (Self.FSkinPageControlIntf.PageControlProperties.FTabHeaderHeight<=0) then
    begin
      Exit;
    end;


    ACanvas.DrawRect(Self.GetSkinMaterial.FDrawTabHeaderColorParam,
                        Self.FSkinPageControlIntf.PageControlProperties.HeaderRect);


    if    (Self.FSkinPageControlIntf.PageControlProperties.FOrientation<>TTabOrientation.toNone)
      and (Self.FSkinPageControlIntf.PageControlProperties.FTabHeaderHeight>0) then
    begin
      //绘制头部背景
      ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawTabHeaderPictureParam,
                          Self.GetSkinMaterial.FTabHeaderPicture,
                          Self.FSkinPageControlIntf.PageControlProperties.HeaderRect);
    end;


    if Self.FSkinPageControlIntf.PageControlProperties.FVisiblePages.Count=0 then Exit;



    for I := 0 to Self.FSkinPageControlIntf.PageControlProperties.FVisiblePages.Count-1 do
    begin
          ATabSheet:=TSkinTabSheet(Self.FSkinPageControlIntf.PageControlProperties.FVisiblePages[I]);
          ATabSheetIntf:=ATabSheet as ISkinTabSheet;
          ATabSheetControlIntf:=ATabSheet as ISkinControl;
          ATabDrawRect:=Self.FSkinPageControlIntf.PageControlProperties.GetVisibleTabDrawRect(I);


          if   IsSameDouble(RectWidthF(ATabDrawRect),0)
            or IsSameDouble(RectHeightF(ATabDrawRect),0) then
          begin
            Continue;
          end;


          AItemEffectStates:=[];
          if Self.FSkinPageControlIntf.PageControlProperties.FMouseOverPage=ATabSheet then
          begin
            AItemEffectStates:=AItemEffectStates+[dpstMouseOver];
          end;
          if Self.FSkinPageControlIntf.PageControlProperties.FMouseDownPage=ATabSheet then
          begin
            AItemEffectStates:=AItemEffectStates+[dpstMouseDown];
          end;
          if Self.FSkinPageControlIntf.PageControlProperties.FActivePage=ATabSheet then
          begin
            AItemEffectStates:=AItemEffectStates+[dpstPushed];
          end;

          Self.GetSkinMaterial.FDrawTabPictureParam.StaticEffectStates:=AItemEffectStates;
          Self.GetSkinMaterial.FDrawTabCaptionParam.StaticEffectStates:=AItemEffectStates;
          Self.GetSkinMaterial.FDrawTabIconParam.StaticEffectStates:=AItemEffectStates;
          Self.GetSkinMaterial.FDrawTabBackColorParam.StaticEffectStates:=AItemEffectStates;
          Self.GetSkinMaterial.FDrawTabBackColor2Param.StaticEffectStates:=AItemEffectStates;

          //处理绘制参数的透明度
          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabPictureParam);
          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabCaptionParam);
          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabIconParam);
          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabBackColorParam);
          ProcessDrawParamDrawAlpha(GetSkinMaterial.FDrawTabBackColor2Param);



          //绘制背景颜色
          ACanvas.DrawRect(Self.GetSkinMaterial.FDrawTabBackColorParam,ATabDrawRect);
          ACanvas.DrawRect(Self.GetSkinMaterial.FDrawTabBackColor2Param,ATabDrawRect);



          //绘制背景图片
          ATabDrawPicture:=nil;
    //        if Not Self.FSkinControlIntf.Enabled then
    //        begin
    //          ATabDrawPicture:=Self.GetSkinMaterial.FTabDisabledPicture;
    //        end
    //        else
          if ATabSheet=Self.FSkinPageControlIntf.PageControlProperties.ActivePage then
          begin
            ATabDrawPicture:=Self.GetSkinMaterial.FTabPushedPicture;
          end
          else
          if (ATabSheet=Self.FSkinPageControlIntf.PageControlProperties.MouseDownPage) and APaintData.IsDrawInteractiveState then
          begin
            ATabDrawPicture:=Self.GetSkinMaterial.FTabDownPicture;
          end
          else if (ATabSheet=Self.FSkinPageControlIntf.PageControlProperties.MouseOverPage) and APaintData.IsDrawInteractiveState then
          begin
            ATabDrawPicture:=Self.GetSkinMaterial.FTabHoverPicture;
          end
          else
          begin
            ATabDrawPicture:=Self.GetSkinMaterial.FTabNormalPicture;
          end;
          if ATabDrawPicture.CurrentPictureIsEmpty then
          begin
            ATabDrawPicture:=Self.GetSkinMaterial.FTabNormalPicture;
          end;
          ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawTabPictureParam,
                              ATabDrawPicture,
                              ATabDrawRect);




          ATempTabDrawRect:=ATabDrawRect;
          //标签头在底部才需要抬高
          if (Self.FSkinPageControlIntf.PageControlProperties.FOrientation=TTabOrientation.toBottom)
            and IsIPhoneX(TForm(Application.MainForm)) then
          begin
            //IPhoneX底部要抬起来20
            ATempTabDrawRect.Bottom:=ATempTabDrawRect.Bottom-GlobalIPhoneXBottomBarHeight;
          end;

//
//          if not Self.FSkinPageControlIntf.PageControlProperties.FIsAfterPaintTabIcon then
//          begin
//
//              //绘制图标
//              if Self.FSkinPageControlIntf.PageControlProperties.FActivePage<>ATabSheet then
//              begin
//                ATabIcon:=ATabSheetIntf.Prop.FIcon;
//              end
//              else
//              begin
//                ATabIcon:=ATabSheetIntf.Prop.FPushedIcon;
//              end;
//              if ATabIcon.CurrentPictureIsEmpty then
//              begin
//                ATabIcon:=ATabSheetIntf.Prop.FIcon;
//              end;
//              ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawTabIconParam,
//                                  ATabIcon,
//                                  ATempTabDrawRect);
//
//          end;
//

          //绘制标题
          ACanvas.DrawText(Self.GetSkinMaterial.FDrawTabCaptionParam,
                            ATabSheetControlIntf.Caption,
                            ATempTabDrawRect);




//          //绘制通知图标
//          if ATabSheetIntf.Prop.FNotifyNumberIconControlIntf<>nil then
//          begin
//
//            ANotifyNumberIconControlIntf:=ATabSheetIntf.Prop.FNotifyNumberIconControlIntf;
//            if ANotifyNumberIconControlIntf.GetSkinControlType<>nil then
//            begin
//              //绘制
//              ANotifyNumberIconControlIntf.GetSkinControlType.IsUseCurrentEffectStates:=True;
//              ANotifyNumberIconControlIntf.GetSkinControlType.CurrentEffectStates:=AItemEffectStates;
//              //绘制
//              AItemPaintData:=GlobalNullPaintData;
//              AItemPaintData.IsDrawInteractiveState:=True;
//              AItemPaintData.IsInDrawDirectUI:=APaintData.IsInDrawDirectUI;
//              ANotifySkinMaterial:=ANotifyNumberIconControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
//              ANotifyNumberIconControlIntf.GetSkinControlType.Paint(ACanvas,
//                        ANotifySkinMaterial,
//                        TSkinTabSheetMaterial(ATabSheetControlIntf.GetCurrentUseMaterial).FDrawNotifyNumberIconRectSetting.CalcDrawRect(ATabDrawRect),
//                        AItemPaintData);
//            end;
//
//          end;




          //设计时绘制虚线框和控件名称
          if (csDesigning in Self.FSkinControl.ComponentState) then
          begin
            if Self.FSkinPageControlIntf.PageControlProperties.ActivePageIndex<>I then
            begin
              ACanvas.DrawDesigningRect(ATabDrawRect,GlobalNormalDesignRectBorderColor);
            end
            else
            begin
              ACanvas.DrawDesigningRect(ATabDrawRect,GlobalActivePageDesignRectBorderColor);
            end;

          end;




    end;

    //最后绘制图标
    PaintPageControlTabIcons(ACanvas,ASkinMaterial,ADrawRect,APaintData);


  end;
end;

procedure TSkinPageControlType.CustomMouseDown(Button: TMouseButton;Shift: TShiftState;X, Y: Double);
begin
  inherited;


//  if Button={$IFDEF FMX}TMouseButton.{$                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       }mbLeft then
//  begin
    //获取按下的列表项
    Self.FSkinPageControlIntf.PageControlProperties.MouseDownPage:=Self.FSkinPageControlIntf.PageControlProperties.PageAt(X,Y);
//  end;

  Self.FSkinPageControlIntf.PageControlProperties.FSkinSwitchPageControlGestureManager.MouseDown(Button,Shift,X,Y);

end;

procedure TSkinPageControlType.CustomMouseEnter;
begin
  inherited;
  Self.FSkinPageControlIntf.PageControlProperties.FSkinSwitchPageControlGestureManager.MouseEnter;
end;

procedure TSkinPageControlType.CustomMouseLeave;
begin
  inherited;
  Self.FSkinPageControlIntf.PageControlProperties.MouseOverPage:=nil;

  Self.FSkinPageControlIntf.PageControlProperties.FSkinSwitchPageControlGestureManager.MouseLeave;
end;

procedure TSkinPageControlType.CustomMouseMove(Shift: TShiftState;X,Y:Double);
begin
  inherited;

  Self.FSkinPageControlIntf.PageControlProperties.MouseOverPage:=
    Self.FSkinPageControlIntf.PageControlProperties.PageAt(X,Y);

  Self.FSkinPageControlIntf.PageControlProperties.FSkinSwitchPageControlGestureManager.MouseMove(Shift,X,Y);
end;

procedure TSkinPageControlType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//var
//  APage:TSkinTabSheet;
begin
  inherited;


//      //选中列表项
//      APage:=Self.FSkinPageControlIntf.PageControlProperties.PageAt(X,Y);
//      if (APage<>nil) and (APage = Self.FSkinPageControlIntf.PageControlProperties.MouseDownPage) then
//      begin
//        Self.FSkinPageControlIntf.PageControlProperties.ActivePage:=APage;
//      end;
//      Self.FSkinPageControlIntf.PageControlProperties.MouseDownPage:=nil;

  Self.FSkinPageControlIntf.PageControlProperties.FSkinSwitchPageControlGestureManager.MouseUp(Button,Shift,X,Y);

end;



{ TSkinTabSheetMaterial }

constructor TSkinTabSheetMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawBackGndPictureParam:=CreateDrawPictureParam('DrawBackGndPictureParam','背景图片绘制参数');

  FDrawNotifyNumberIconRectSetting:=TDrawRectSetting.Create;
  FDrawNotifyNumberIconRectSetting.OnChange:=DoChange;

  FBackGndPicture:=CreateDrawPicture('BackGndPicture','背景图片');
end;

procedure TSkinTabSheetMaterial.SetBackGndPicture(const Value: TDrawPicture);
begin
  FBackGndPicture.Assign(Value);
end;

procedure TSkinTabSheetMaterial.SetDrawBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDrawBackGndPictureParam.Assign(Value);
end;

//procedure TSkinTabSheetMaterial.SetIsDrawBackGndPicture(const Value: Boolean);
//begin
//  if FIsDrawBackGndPicture<>Value then
//  begin
//    FIsDrawBackGndPicture := Value;
//    DoChange;
//  end;
//end;

//function TSkinTabSheetMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////    if ABTNode.NodeName='DrawTabCaptionParam' then
////    begin
////      FDrawTabCaptionParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinTabSheetMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawTabCaptionParam',FDrawTabCaptionParam.Name);
////  Self.FDrawTabCaptionParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;

procedure TSkinTabSheetMaterial.SetDrawNotifyNumberIconRectSetting(const Value: TDrawRectSetting);
begin
  FDrawNotifyNumberIconRectSetting.Assign(Value);
end;

destructor TSkinTabSheetMaterial.Destroy;
begin
  FreeAndNil(FDrawNotifyNumberIconRectSetting);
  FreeAndNil(FBackGndPicture);
  FreeAndNil(FDrawBackGndPictureParam);
  inherited;
end;

{ TPageControlProperties }

//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerPageIndexChange(Sender:TObject;APageIndex:Integer);
//begin
//  Self.FActivePageIndex:=Self.FPages.IndexOf(Self.FVisiblePages[APageIndex]);
//  Self.ChangeActivePage(TSkinTabSheet(Self.FVisiblePages[APageIndex]),True);
//end;
//
//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerPageCountChange(Sender:TObject);
//begin
//end;
//
//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerGetPageCount(Sender:TObject;var Param:Integer);
//begin
//  Param:=Self.FVisiblePages.Count;
//end;
//
//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerGetPageIndex(Sender:TObject;var Param:Integer);
//begin
//  Param:=Self.ActivePageIndex;
//end;
//
//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerGetPageWidth(Sender:TObject;Index:Integer;var Param:Double);
//begin
//  if (Index<>-1) and (Index<Self.FVisiblePages.Count) and (Self.GetVisibleTabSheetIntf(Index).Properties.FSwitchSize>0) then
//  begin
//    Param:=Self.GetVisibleTabSheetIntf(Index).Properties.FSwitchSize;
//  end
//  else
//  begin
//    Param:=Self.GetPageRect.Width;
//  end;
//end;
//
//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerGetPageHeight(Sender:TObject;Index:Integer;var Param:Double);
//begin
//  if (Index<>-1) and (Index<Self.FVisiblePages.Count) and (Self.GetVisibleTabSheetIntf(Index).Properties.FSwitchSize>0) then
//  begin
//    Param:=Self.GetVisibleTabSheetIntf(Index).Properties.FSwitchSize;
//  end
//  else
//  begin
//    Param:=Self.GetPageRect.Height;
//  end;
//end;
//
//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerGetPageControl(Sender:TObject;APageIndex:Integer;var AControl:TControl);
//begin
//  AControl:=nil;
//  if (APageIndex>=0) and (APageIndex<Self.FVisiblePages.Count) then
//  begin
//    AControl:=TControl(FVisiblePages[APageIndex]);
//  end;
//end;
//
//procedure TPageControlProperties.DoSwitchPageListControlGestureManagerPageListSwitchingProgressChange(Sender:TObject);
//begin
//  Self.FSwitchPageListControlGestureManager.AlignSwitchListPages(Self.GetPageRect);
//end;

procedure TPageControlProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TPageControlProperties.Create(ASkinControl:TControl);
//var
//  ADeviceInfo_diDevice:String;
begin
  FPages:=TBaseList.Create(ooReference);
  FVisiblePages:=TBaseList.Create(ooReference);

  inherited Create(ASkinControl);

  FSkinSwitchPageControlGestureManager:=TSkinSwitchPageControlGestureManager.Create(nil);
  FSkinSwitchPageControlGestureManager.FProperties:=Self;
  FSkinSwitchPageControlGestureManager.Enabled:=False;
  FSkinSwitchPageControlGestureManager.FIsNotCanSeeOutOfBoundArea:=True;


//  {$IFDEF IOS}
//        with TUIDevice.Wrap(TUIDevice.OCClass.currentDevice) do
//        begin
//
//          //后面会多出#0
//          ADeviceInfo_diDevice := platform.UTF8String;
//
//          //Trim(GetSysInfoByName('hw.machine'));
//
////          //model.UTF8String;
////          //@"iPhone1,1" on iPhone
////          //@"iPhone1,2" on iPhone 3G
//          if SameText(ADeviceInfo_diDevice,'iPhone10,3')
//            or SameText(ADeviceInfo_diDevice,'iPhone10,6') then
//          begin
//            GlobalIsIPhoneX:=True;
//          end
//        end;
//  {$ENDIF IOS}
//  //测试
//  GlobalIsIPhoneX:=True;

  if Not ASkinControl.GetInterface(IID_ISkinPageControl,Self.FSkinPageControlIntf) then
  begin
    ShowException('This Component Do not Support ISkinPageControl Interface');
  end
  else
  begin

    FIsTabHeaderCenter:=False;

    FTabSize:=60;
    Self.FTabSizeCalcType:=tsctEqual;

    FOrientation:=toTop;
    FTabHeaderHeight:=30;

    FPages.OnChange:=DoPagesChange;
    FPages.OnItemDelete:=DoPageDelete;

//    FIsAutoSwitchPageAnimating:=False;
//    FSwitchPageAnimated:=False;
//    FSwitchPageAnimateSpeed:=1;

    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=200;
    FMouseDownPage:=nil;
    FMouseOverPage:=nil;

//    FSwitchPageListControlGestureManager.OnPageIndexChange:=DoSwitchPageListControlGestureManagerPageIndexChange;
//    FSwitchPageListControlGestureManager.OnPageCountChange:=DoSwitchPageListControlGestureManagerPageCountChange;
//
//    FSwitchPageListControlGestureManager.OnGetPageCount:=DoSwitchPageListControlGestureManagerGetPageCount;
//    FSwitchPageListControlGestureManager.OnGetPageIndex:=DoSwitchPageListControlGestureManagerGetPageIndex;
//    FSwitchPageListControlGestureManager.OnGetPageWidth:=DoSwitchPageListControlGestureManagerGetPageWidth;
//    FSwitchPageListControlGestureManager.OnGetPageHeight:=DoSwitchPageListControlGestureManagerGetPageHeight;
//    FSwitchPageListControlGestureManager.OnGetPageControl:=DoSwitchPageListControlGestureManagerGetPageControl;
//    FSwitchPageListControlGestureManager.OnPageListSwitchingProgressChange:=DoSwitchPageListControlGestureManagerPageListSwitchingProgressChange;
  end;
end;

destructor TPageControlProperties.Destroy;
var
  I: Integer;
  ATabSheet:TObject;
begin
  Self.FSkinPageControlIntf.OnChange:=nil;
  Self.FSkinPageControlIntf.OnChanging:=nil;
  Self.FActivePage:=nil;
  Self.FActivePageIndex:=-1;
  Self.FMouseDownPage:=nil;
  Self.FMouseOverPage:=nil;

  for I := FPages.Count-1 downto 0 do
  begin
    ATabSheet:=TSkinTabSheet(FPages[I]);
//    Self.GetTabSheetIntf(I).Properties.PageControl:=nil;

    Self.GetTabSheetIntf(I).Properties.FPageControl:=nil;
    Self.GetTabSheetIntf(I).Properties.FSkinPageControlIntf:=nil;

    //释放暂时去掉
//    FreeAndNil(ATabSheet);
  end;


  FreeAndNil(FPages);
  FreeAndNil(FVisiblePages);


  FreeAndNil(FSkinSwitchPageControlGestureManager);
  inherited;
end;

procedure TPageControlProperties.DoPagesChange(Sender: TObject);
begin
  if Self.FPages.HasItemDeleted then
  begin
    //判断一下选中的,鼠标停靠的项目还存在不存在
    if (FMouseDownPage<>nil) and (Self.FPages.IndexOf(Self.FMouseDownPage)=-1) then
    begin
      FMouseDownPage:=nil;
    end;
    if (FMouseOverPage<>nil) and (Self.FPages.IndexOf(Self.FMouseOverPage)=-1) then
    begin
      FMouseOverPage:=nil;
    end;
    if (FActivePage<>nil) and (Self.FPages.IndexOf(Self.FActivePage)=-1) then
    begin
      FActivePage:=nil;

      //当前页被删除的时候,需要重新确定当前页
      { TODO : 当前页被删除的时候,需要重新确定当前页 }
    end;
  end;

  Invalidate;
end;

procedure TPageControlProperties.DoPageDelete(Sender:TObject;AItem:TObject;AIndex:Integer);
begin

  //判断一下选中的,鼠标停靠的项目还存在不存在
  if (FMouseDownPage<>nil) and (FMouseDownPage=AItem) then
  begin
    FMouseDownPage:=nil;
  end;
  if (FMouseOverPage<>nil) and (FMouseOverPage=AItem) then
  begin
    FMouseOverPage:=nil;
  end;
  if (FActivePage<>nil) and (FActivePage=AItem) then
  begin
    FActivePage:=nil;
    { TODO : 当前页被删除的时候,需要重新确定当前页 }
  end;

end;

function TPageControlProperties.GetCanGesutreSwitch: Boolean;
begin
  Result:=FSkinSwitchPageControlGestureManager.Enabled;
end;

function TPageControlProperties.GetComponentClassify: String;
begin
  Result:='SkinPageControl';
end;

function TPageControlProperties.GetDrawTabButtonsHeaderRect: TRectF;
begin
  Result:=GetHeaderRect;
  case Self.FOrientation of
    toBottom:
    begin

//        if GlobalIsIPhoneX then
//        begin
//          //IPhoneX底部要抬起来20
//          Result.Bottom:=Result.Bottom-GlobalIPhoneXBottomBarHeight;
//        end;

    end;
  end;
end;

function TPageControlProperties.GetHeaderRect: TRectF;
var
  ATabHeaderHeight:Double;
begin
  Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);

  ATabHeaderHeight:=FTabHeaderHeight;
  {$IFDEF VCL}
  ATabHeaderHeight:=ScreenScaleSize(Self.FTabHeaderHeight);
  {$ENDIF VCL}

  case Self.FOrientation of
    toNone: Result:=RectF(0,0,0,0);
    toLeft:
    begin
      Result.Right:=Result.Left+ATabHeaderHeight;
    end;
    toTop:
    begin
      Result.Bottom:=Result.Top+ATabHeaderHeight;
    end;
    toRight:
    begin
      Result.Left:=Result.Right-ATabHeaderHeight;
    end;
    toBottom:
    begin


        if IsIPhoneX(TForm(Application.MainForm)) then
        begin
          //IPhoneX底部要抬起来20
          Result.Top:=Result.Bottom-ATabHeaderHeight-GlobalIPhoneXBottomBarHeight;
        end
        else
        begin
          Result.Top:=Result.Bottom-ATabHeaderHeight;
        end;

    end;
  end;

  if Assigned(Self.FSkinPageControlIntf.OnCustomCalcHeadDrawRect) then
  begin
    Self.FSkinPageControlIntf.OnCustomCalcHeadDrawRect(Self,Result);
  end;
end;

function TPageControlProperties.GetPageRect: TRectF;
var
  ATabHeaderHeight:Double;
begin
  Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);

  ATabHeaderHeight:=FTabHeaderHeight;
  {$IFDEF VCL}
  ATabHeaderHeight:=ScreenScaleSize(Self.FTabHeaderHeight);
  {$ENDIF VCL}

  case Self.FOrientation of
    toNone: ;
    toLeft:
    begin
      Result.Left:=Result.Left+ATabHeaderHeight;
    end;
    toTop:
    begin
      Result.Top:=Result.Top+ATabHeaderHeight;
    end;
    toRight:
    begin
      Result.Right:=Result.Right-ATabHeaderHeight;
    end;
    toBottom:
    begin
        if IsIPhoneX(TForm(Application.MainForm)) then
        begin

          //IPhoneX底部要抬起来20
          Result.Bottom:=Result.Bottom-ATabHeaderHeight-GlobalIPhoneXBottomBarHeight;
        end
        else
        begin
          Result.Bottom:=Result.Bottom-ATabHeaderHeight;
        end;
    end;
  end;
end;

function TPageControlProperties.GetTabSheetIntf(Index: Integer): ISkinTabSheet;
begin
  Result:=TSkinTabSheet(Self.FPages[Index]) as ISkinTabSheet;
end;

function TPageControlProperties.GetVisibleTabSheetIntf(VisibleIndex: Integer): ISkinTabSheet;
begin
  Result:=TSkinTabSheet(Self.FVisiblePages[VisibleIndex]) as ISkinTabSheet;
end;

procedure TPageControlProperties.AlignSwitchButtons;
begin
  if (Self.FSkinPageControlIntf.GetSwitchButtonGroup<>nil)
    then
  begin

    Self.FSkinPageControlIntf.GetSwitchButtonGroupIntf.FixChildButtonCount(Self.FSkinPageControlIntf.PageControlProperties.FVisiblePages.Count,
                                                Self.FSkinPageControlIntf.PageControlProperties.ActivePageIndex,
                                                DoImageListSwitchButtonClick);

  end;
end;

//procedure TPageControlProperties.FreeSwitchButtons;
//begin
//  if (Self.FSkinPageControlIntf.GetSwitchButtonGroup<>nil) then
//  begin
//    Self.FSkinPageControlIntf.GetSwitchButtonGroupIntf.FreeChildButtons;
//  end;
//end;


procedure TPageControlProperties.DoImageListSwitchButtonClick(Sender: TObject);
begin
  //图标列表切换按钮按下
  Self.ActivePageIndex:=((Sender as TChildControl) as ISkinButton).Properties.ButtonIndex;
end;

function TPageControlProperties.GetVisibleTabIconDrawRect(ATabSheet:TSkinTabSheet;ATabIconDrawRect:TRectF):TRectF;
begin
  Result:=ATabIconDrawRect;
  if Assigned(Self.FSkinPageControlIntf.OnCustomCalcTabIconDrawRect) then
  begin
    Self.FSkinPageControlIntf.OnCustomCalcTabIconDrawRect(Self,ATabSheet,Result);
  end;

end;

function TPageControlProperties.GetVisibleTabDrawRect(VisibleIndex: Integer): TRectF;
      function GetTabHeaderSize:Double;
      var
        I: Integer;
      Begin
        Result:=0;
        case Self.FTabSizeCalcType of
          tsctEqual:
          begin
              case Self.FOrientation of
                toNone: ;
                toLeft: Result:=RectHeightF(GetHeaderRect);
                toTop: Result:=RectWidthF(GetHeaderRect);
                toRight: Result:=RectHeightF(GetHeaderRect);
                toBottom: Result:=RectWidthF(GetHeaderRect);
              end;
          end;
          tsctFixed:
          begin
              Result:=Self.FTabSize*Self.FVisiblePages.Count;
          end;
          tsctSeparate:
          begin
              for I := 0 to Self.FVisiblePages.Count-1 do
              begin
                Result:=Result+Self.GetVisibleTabSheetIntf(I).Properties.TabSize;
              end;
          end;
        end;
      End;
var
  I: Integer;
  SumSize:Double;
  EqualSize:Double;
  AControlWidth:Double;
  AControlHeight:Double;
begin

  Result:=GetDrawTabButtonsHeaderRect;

  AControlWidth:=Result.Width;
  AControlHeight:=Result.Height;


  case Self.FTabSizeCalcType of
    tsctEqual:
    begin
        case Self.FOrientation of
          toNone: Result:=RectF(0,0,0,0);
          toLeft:
          begin
            EqualSize:=AControlHeight / FVisiblePages.Count;
            Result.Top:=Result.Top+VisibleIndex*EqualSize;
            Result.Bottom:=Result.Top+EqualSize;
          end;
          toTop:
          begin
            EqualSize:=AControlWidth / FVisiblePages.Count;
            Result.Left:=Result.Left+VisibleIndex*EqualSize;
            Result.Right:=Result.Left+EqualSize;
          end;
          toRight:
          begin
            EqualSize:=AControlHeight / FVisiblePages.Count;
            Result.Top:=Result.Top+VisibleIndex*EqualSize;
            Result.Bottom:=Result.Top+EqualSize;
          end;
          toBottom:
          begin
            EqualSize:=AControlWidth / FVisiblePages.Count;
            Result.Left:=Result.Left+VisibleIndex*EqualSize;
            Result.Right:=Result.Left+EqualSize;
          end;
        end;
    end;
    tsctFixed:
    begin
      case Self.FOrientation of
        toNone: Result:=RectF(0,0,0,0);
        toLeft:
        begin
          Result.Top:=Result.Top+VisibleIndex*FTabSize;
          Result.Bottom:=Result.Top+Self.FTabSize;
        end;
        toTop:
        begin
          Result.Left:=Result.Left+VisibleIndex*FTabSize;
          Result.Right:=Result.Left+Self.FTabSize;
        end;
        toRight:
        begin
          Result.Top:=Result.Top+VisibleIndex*FTabSize;
          Result.Bottom:=Result.Top+Self.FTabSize;
        end;
        toBottom:
        begin
          Result.Left:=Result.Left+VisibleIndex*FTabSize;
          Result.Right:=Result.Left+Self.FTabSize;
        end;
      end;
    end;
    tsctSeparate:
    begin
      SumSize:=0;
      for I := 0 to VisibleIndex-1 do
      begin
        SumSize:=SumSize+Self.GetVisibleTabSheetIntf(I).Properties.TabSize;
      end;

      case Self.FOrientation of
        toNone: Result:=RectF(0,0,0,0);
        toLeft:
        begin
          Result.Top:=Result.Top+SumSize;
          Result.Bottom:=Result.Top+Self.GetVisibleTabSheetIntf(VisibleIndex).Properties.FTabSize;
        end;
        toTop:
        begin
          Result.Left:=Result.Left+SumSize;
          Result.Right:=Result.Left+Self.GetVisibleTabSheetIntf(VisibleIndex).Properties.FTabSize;
        end;
        toRight:
        begin
          Result.Top:=Result.Top+SumSize;
          Result.Bottom:=Result.Top+Self.GetVisibleTabSheetIntf(VisibleIndex).Properties.FTabSize;
        end;
        toBottom:
        begin
          Result.Left:=Result.Left+SumSize;
          Result.Right:=Result.Left+Self.GetVisibleTabSheetIntf(VisibleIndex).Properties.FTabSize;
        end;
      end;
    end;
//    tsctAutoSize: ;
//    tsctCustom: ;
  end;
  if Self.FIsTabHeaderCenter then
  begin
    case Self.FOrientation of
      toNone: ;
      toLeft: OffsetRect(Result,0,(RectHeightF(GetHeaderRect)-GetTabHeaderSize)/2);
      toTop: OffsetRect(Result,(RectWidthF(GetHeaderRect)-GetTabHeaderSize)/2,0);
      toRight: OffsetRect(Result,0,(RectHeightF(GetHeaderRect)-GetTabHeaderSize)/2);
      toBottom: OffsetRect(Result,(RectWidthF(GetHeaderRect)-GetTabHeaderSize)/2,0);
    end;
  end;

  if Assigned(Self.FSkinPageControlIntf.OnCustomCalcTabDrawRect) then
  begin
    Self.FSkinPageControlIntf.OnCustomCalcTabDrawRect(Self,VisibleIndex,Result);
  end;

end;

procedure TPageControlProperties.SetOrientation(const Value: TTabOrientation);
begin
  if FOrientation<>Value then
  begin
    FOrientation := Value;
    Self.AlignPages;
  end;
end;

procedure TPageControlProperties.SetTabHeaderHeight(const Value: Integer);
begin
  if FTabHeaderHeight<>Value then
  begin
    FTabHeaderHeight := Value;
    Self.AlignPages;
  end;
end;

procedure TPageControlProperties.SetTabSize(const Value: Integer);
begin
  if FTabSize<>Value then
  begin
    FTabSize := Value;
    Invalidate;
  end;
end;

procedure TPageControlProperties.SetTabSizeCalcType(const Value: TTabSizeCalcType);
begin
  if FTabSizeCalcType<>Value then
  begin
    FTabSizeCalcType := Value;
    Invalidate;
  end;
end;

procedure TPageControlProperties.SetIsAfterPaintTabIcon(const Value: Boolean);
begin
  if FIsAfterPaintTabIcon<>Value then
  begin
    FIsAfterPaintTabIcon := Value;
    Invalidate;
  end;
end;

procedure TPageControlProperties.SetIsTabHeaderCenter(const Value: Boolean);
begin
  if FIsTabHeaderCenter<>Value then
  begin
    FIsTabHeaderCenter := Value;
    Invalidate;
  end;
end;

function ListCompareByPageIndex(Item1, Item2: Pointer): Integer;
begin
  Result:=0;
  if (TSkinTabSheet(Item1) as ISkinTabSheet).Properties.FPageIndex
    >(TSkinTabSheet(Item2) as ISkinTabSheet).Properties.FPageIndex then
  begin
    Result:=1;
  end
  else if (TSkinTabSheet(Item1) as ISkinTabSheet).Properties.FPageIndex
          <(TSkinTabSheet(Item2) as ISkinTabSheet).Properties.FPageIndex then
  begin
    Result:=-1;
  end;
end;


procedure TPageControlProperties.ReBuildPageIndexAndVisiblePages(Page: TSkinTabSheet);
var
  I: Integer;
  OldActivePageIndex:Integer;
begin

  if Page<>nil then
  begin
    if (csLoading in Page.ComponentState)
      or (csReading in Page.ComponentState) then
    begin
      Exit;
    end;
  end;


  if (csLoading in Self.FSkinControl.ComponentState)
    or (csReading in Self.FSkinControl.ComponentState) then
  begin
    Exit;
  end;



  //根据PageIndex排序
  Self.FPages.Sort(ListCompareByPageIndex);
  //比如原PageIndex为0,1,2,3
  //2被删除了,那么PageIndex为0,1,3
  //排序之后,就变成0,1,3
  //要改为0,1,2
  for I := 0 to FPages.Count-1 do
  begin
    TSkinTabSheet(FPages[I]).Prop.FPageIndex:=I;
  end;


  if Self.ActivePage<>nil then
  begin
    FActivePageIndex:=ActivePage.Prop.FPageIndex;
  end
  else
  begin
    //如果ActivePage被删除了,那么以当前的FActivePageIndex为准
    OldActivePageIndex:=FActivePageIndex;
    if OldActivePageIndex>Self.FPages.Count-1 then
    begin
      OldActivePageIndex:=Self.FPages.Count-1;
    end;
    FActivePageIndex:=-1;
    ActivePageIndex:=OldActivePageIndex;
  end;


  Self.FVisiblePages.Clear(False);
  for I := 0 to Self.FPages.Count-1 do
  begin
    if Self.GetTabSheetIntf(I).Properties.TabVisible then
    begin
      Self.FVisiblePages.Add(FPages[I]);
    end;
  end;


  Self.Invalidate;
end;

//procedure TPageControlProperties.SortPages;
//begin
//  ReBuildPageIndexAndVisiblePages(nil);
//  FActivePageIndex:=Self.FPages.IndexOf(Self.FActivePage);
//end;

procedure TPageControlProperties.ClearPages;
var
  I: Integer;
  ATabSheet:TControl;
begin
  for I := Self.FPages.Count-1 downto 0 do
  begin
    ATabSheet:=TControl(Self.FPages.Items[I]);
    ATabSheet.Parent:=nil;
    FreeAndNil(ATabSheet);
  end;
  Self.FPages.Clear(False);
  ReBuildPageIndexAndVisiblePages(nil);
end;

function TPageControlProperties.GetPageCount:Integer;
begin
  Result:=Self.FPages.Count;
end;

function TPageControlProperties.GetPage(Index: Integer):TSkinTabSheet;
begin
  Result:=TSkinTabSheet(Self.FPages[Index]);
end;

procedure TPageControlProperties.AddPage(Page: TSkinTabSheet);
begin
  Self.FPages.Add(Page);
  //如果没有指定PageIndex,那么获取一下,因为要排序
  if (Page as ISkinTabSheet).Properties.FPageIndex=-1 then
  begin
    (Page as ISkinTabSheet).Properties.GetPageIndex;
  end;
  (Page as ISkinTabSheet).Properties.FPageControl:=TSkinPageControl(Self.FSkinControl);

  Page.Parent:=TParentControl(Self.FSkinControl);


  ReBuildPageIndexAndVisiblePages(Page);

  //排列分页
  Self.AlignPages;
end;

function TPageControlProperties.PageAt(X, Y:Double): TSkinTabSheet;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.FVisiblePages.Count-1 do
  begin
    if PtInRect(Self.GetVisibleTabDrawRect(I),PointF(X,Y)) then
    begin
      Result:=TSkinTabSheet(Self.FVisiblePages[I]);
      Break;
    end;
  end;
end;

procedure TPageControlProperties.RemovePage(Page: TSkinTabSheet);
begin
  Self.FPages.Remove(Page,False);
  if (Page as ISkinTabSheet).Properties<>nil then
  begin
    (Page as ISkinTabSheet).Properties.FPageControl:=nil;
  end;
  //重建可视化列表
  ReBuildPageIndexAndVisiblePages(Page);
end;

procedure TPageControlProperties.DoChange;
begin
  if Assigned(Self.FSkinPageControlIntf.OnChange) then
  begin
    Self.FSkinPageControlIntf.OnChange(Self);
  end;
end;

procedure TPageControlProperties.AlignPages;
var
  I:Integer;
  ASkinControl:TControl;
  ASkinControlIntf:ISkinControl;
begin
  if //not (csLoading in Self.FSkinControl.ComponentState)
//    and
    not (csReading in Self.FSkinControl.ComponentState) then
  begin
    for I := 0 to Self.FPages.Count-1 do
    begin
      ASkinControl:=TControl(Self.FPages[I]);
      ASkinControlIntf:=ASkinControl as ISkinControl;
      if ASkinControl=FActivePage then
      begin
        ASkinControlIntf.SetVisible(True);
        ASkinControlIntf.SetBounds(Self.PageRect);
      end
      else
      begin
        if not (csDesigning in Self.FSkinControl.ComponentState) then
        begin
          ASkinControlIntf.SetVisible(False);
        end;
        ASkinControlIntf.SetBounds(Self.PageRect);
      end;
    end;
  end;
end;



procedure TPageControlProperties.ChangeActivePage(Page: TSkinTabSheet;HasAligned:Boolean);
var
  AOldPageIndex:Integer;
  ANewPageIndex:Integer;
begin

  if FActivePage <> Page then
  begin

//    if not FSwitchPageAnimated or FIsAutoSwitchPageAnimating then
//    begin
//        //静态切换
//        FIsAutoSwitchPageAnimating:=False;


        //测试注释掉了
        if not HasAligned then
        begin
          if Page <> nil then
          begin
            (Page as TChildControl).BringToFront;
            (Page as ISkinControl).Visible:=True;
            (Page as ISkinControl).Left:=0;
          end;

          if FActivePage <> nil then
          begin
            (FActivePage as ISkinControl).Visible:=False;
            (FActivePage as ISkinControl).Left:=-MaxInt;
          end;
        end;


        FActivePage := Page;
        FActivePage.BringToFront;
        AlignPages;


        Self.AlignSwitchButtons;

        DoChange;


//    end
//    else
//    begin
//
//        //动态切换
//        AOldPageIndex:=Self.FVisiblePages.IndexOf(FActivePage);
//        ANewPageIndex:=Self.FVisiblePages.IndexOf(Page);
//
//        FIsAutoSwitchPageAnimating:=True;
//        Self.FSwitchPageListControlGestureManager.PageListAnimateSpeed:=FSwitchPageAnimateSpeed;
//        Self.FSwitchPageListControlGestureManager.SwitchPage(AOldPageIndex,ANewPageIndex);
//
//    end;

    Invalidate;
  end;

end;

procedure TPageControlProperties.SetActivePage(Page: TSkinTabSheet);
var
  NewActivePageIndex: Integer;
begin

  if (Page<>nil)
    and ((Page as ISkinTabSheet).Properties.FPageControl<>Self.FSkinControl) then
    begin
      //不是属于自己的Page
      FActivePageIndex:=-1;
      FActivePage := nil;
      Invalidate;
      Exit;
    end;

  if (csLoading in Self.FSkinControl.ComponentState)
    or (csReading in Self.FSkinControl.ComponentState) then
  begin
    FActivePage := Page;
    Exit;
  end;

  NewActivePageIndex:=Self.FPages.IndexOf(Page);
  SetActivePageIndex(NewActivePageIndex);

end;

procedure TPageControlProperties.SetActivePageIndex(Value: Integer);
var
//  OldActivePageIndex: Integer;
  AllowChange: Boolean;
begin
  if (csLoading in Self.FSkinControl.ComponentState)
    or (csReading in Self.FSkinControl.ComponentState) then
  begin
    FActivePageIndex := Value;
    Exit;
  end;


  if (Value<0)
    or (Value>=FPages.Count)
    or Not Self.GetTabSheetIntf(Value).Properties.FTabVisible then
  begin
    FActivePageIndex := -1;
    FActivePage := nil;
    Invalidate;
  end
  else
  begin
//    OldActivePageIndex := FActivePageIndex;

    AllowChange := True;
    if (FActivePageIndex<>Value) then
    begin
      if Assigned(Self.FSkinPageControlIntf.OnChanging) then
      begin
        Self.FSkinPageControlIntf.OnChanging(Self,Value,AllowChange);
      end;
    end;

    if AllowChange then
    begin
      FActivePageIndex := Value;
      ChangeActivePage(TSkinTabSheet(FPages[FActivePageIndex]));
    end;

  end;

end;

procedure TPageControlProperties.SetCanGesutreSwitch(const Value: Boolean);
begin
  FSkinSwitchPageControlGestureManager.Enabled:=Value;

  {$IFDEF FREE_VERSION}
  if Value then
  begin
    ShowMessage('OrangeUI免费版限制(PageControl不支持手势切换)');
  end;
  {$ENDIF}
end;

procedure TPageControlProperties.SetMouseDownPage(const Value: TSkinTabSheet);
begin
  if FMouseDownPage<>Value then
  begin
    FMouseDownPage := Value;
    Invalidate;
  end;
end;

procedure TPageControlProperties.SetMouseOverPage(const Value: TSkinTabSheet);
begin
  if FMouseOverPage<>Value then
  begin
    FMouseOverPage := Value;
    Invalidate;
  end;
end;

function TPageControlProperties.GetActivePageIndex: Integer;
begin
  Result:=FActivePageIndex;
//  if (Self.FActivePageIndex<0) or (Self.FActivePageIndex>Self.FPages.Count) then
//  begin
//    Result := -1;
//  end;
end;

function TPageControlProperties.GetActivePage: TSkinTabSheet;
begin
  Result:=FActivePage;
//  if (Self.FActivePageIndex>=0) and (Self.FActivePageIndex<Self.FPages.Count) then
//  begin
//    Result := TComponent(FPages[FActivePageIndex]);
//  end;
end;


{ TSkinTabSheetType }

function TSkinTabSheetType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinTabSheet,Self.FSkinTabSheetIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinTabSheet Interface');
    end;
  end;
end;

procedure TSkinTabSheetType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinTabSheetIntf:=nil;
end;

function TSkinTabSheetType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited CalcCurrentEffectStates;
  if Self.FSkinTabSheetIntf.Prop.FSkinPageControlIntf<>nil then
  begin
    if Self.FSkinTabSheetIntf.Prop.FSkinPageControlIntf.PageControlProperties.FMouseDownPage=Self.FSkinControl then
    begin
      Result:=Result+[dpstMouseDown];
    end;
    if Self.FSkinTabSheetIntf.Prop.FSkinPageControlIntf.PageControlProperties.FMouseOverPage=Self.FSkinControl then
    begin
      Result:=Result+[dpstMouseOver];
    end;
    if Self.FSkinTabSheetIntf.Prop.FSkinPageControlIntf.PageControlProperties.FActivePage=Self.FSkinControl then
    begin
      Result:=Result+[dpstPushed];
    end;
  end;
end;

function TSkinTabSheetType.GetSkinMaterial: TSkinTabSheetMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinTabSheetMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinTabSheetType.Invalidate;
begin
  inherited;
  if Self.FSkinTabSheetIntf.Prop.PageControl<>nil then
  begin
    (Self.FSkinTabSheetIntf.Prop.PageControl as ISkinPageControl).PageControlProperties.Invalidate;
  end;
end;

procedure TSkinTabSheetType.TextChanged;
begin
  inherited;
  if Self.FSkinTabSheetIntf.Prop.PageControl<>nil then
  begin
    (Self.FSkinTabSheetIntf.Prop.PageControl as ISkinPageControl).PageControlProperties.Invalidate;
  end;
end;

function TSkinTabSheetType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  if Self.GetSkinMaterial<>nil then
  begin
//    if csDesigning in Self.FSkinControl.ComponentState then
//    begin
//      GlobalDrawRectParam.FillColor.Color:=WhiteColor;
//      GlobalDrawRectParam.FillColor.Alpha:=255;
//      GlobalDrawRectParam.IsFill:=True;
//      ACanvas.DrawRect(GlobalDrawRectParam,ADrawRect);
//    end;

    if Self.GetSkinMaterial<>nil then
    begin
//      if Self.GetSkinMaterial.FIsDrawBackGndPicture then
//      begin
        //绘制整体背景
        ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawBackGndPictureParam,
                            Self.GetSkinMaterial.FBackGndPicture,
                            ADrawRect);
//      end;
    end;


//    if Self.FSkinTabSheetIntf.Caption <> '' then
//    begin
//      ACanvas.DrawText(Self.GetSkinMaterial.FDrawTabCaptionParam,
//                        Self.FSkinTabSheetIntf.Caption,
//                        ADrawRect);
//    end;
  end;
end;



{ TSkinPageControlMaterial }

constructor TSkinPageControlMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  FIsDrawBackGndPicture:=False;
//  FIsDrawTabHeaderPicture:=False;

  FDrawTabCaptionParam:=CreateDrawTextParam('DrawTabCaptionParam','标签按钮标题绘制参数');
  FDrawTabIconParam:=CreateDrawPictureParam('DrawTabIconParam','标签按钮图标绘制参数');


  FTabNormalPicture:=CreateDrawPicture('TabNormalPicture','标签按钮正常状态图片','标签按钮所有状态图片');
  FTabHoverPicture:=CreateDrawPicture('TabHoverPicture','标签按钮鼠标停靠状态图片','标签按钮所有状态图片');
  FTabDownPicture:=CreateDrawPicture('TabDownPicture','标签按钮鼠标按下状态图片','标签按钮所有状态图片');
//  FTabDisabledPicture:=CreateDrawPicture('TabDisabledPicture','标签按钮禁用状态图片','标签按钮所有状态图片');
//  FTabFocusedPicture:=CreateDrawPicture('TabFocusedPicture','标签按钮得到焦点状态图片','标签按钮所有状态图片');
  FTabPushedPicture:=CreateDrawPicture('TabPushedPicture','标签按钮按下状态图片','标签按钮所有状态图片');
  FDrawTabPictureParam:=CreateDrawPictureParam('DrawTabPictureParam','标签按钮图片绘制参数');

  FDrawTabBackColorParam:=CreateDrawRectParam('TabBackColor','标签按钮背景颜色绘制参数');
  FDrawTabBackColor2Param:=CreateDrawRectParam('TabBackColor2','标签按钮背景颜色绘制参数2');



  FBackGndPicture:=CreateDrawPicture('BackGndPicture','背景图片');
  FDrawBackGndPictureParam:=CreateDrawPictureParam('DrawBackGndPictureParam','背景图片绘制参数');


  FTabHeaderPicture:=CreateDrawPicture('BackGndPicture','标签头背景图片');
  FDrawTabHeaderColorParam:=CreateDrawRectParam('DrawTabHeaderColorParam','标签头背景颜色绘制参数');
  FDrawTabHeaderPictureParam:=CreateDrawPictureParam('DrawTabHeaderPictureParam','标签头背景图片绘制参数');



end;

//procedure TSkinPageControlMaterial.AssignTo(Dest: TPersistent);
//var
//  DestObject:TSkinPageControlMaterial;
//begin
//  if Dest is TSkinPageControlMaterial then
//  begin
//    DestObject:=TSkinPageControlMaterial(Dest);
//
//    DestObject.FAutoSuitNumberHorzMargin:=FAutoSuitNumberHorzMargin;
//    DestObject.FAutoSuitNumberVertMargin:=FAutoSuitNumberVertMargin;
//    DestObject.FIsDrawPictureAutoSuitNumber:=FIsDrawPictureAutoSuitNumber;
//
//  end;
//
//  inherited;
//end;

//function TSkinPageControlMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////    if ABTNode.NodeName='DrawTabCaptionParam' then
////    begin
////      FDrawTabCaptionParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinPageControlMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawTabCaptionParam',FDrawTabCaptionParam.Name);
////  Self.FDrawTabCaptionParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DrawTabIconParam',FDrawTabIconParam.Name);
////  Self.FDrawTabIconParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;

destructor TSkinPageControlMaterial.Destroy;
begin

  FreeAndNil(FTabHoverPicture);
  FreeAndNil(FTabNormalPicture);
//  FreeAndNil(FTabDisabledPicture);
  FreeAndNil(FTabDownPicture);
  FreeAndNil(FTabPushedPicture);
//  FreeAndNil(FTabFocusedPicture);
  FreeAndNil(FBackGndPicture);
  FreeAndNil(FTabHeaderPicture);

  FreeAndNil(FDrawTabBackColorParam);
  FreeAndNil(FDrawTabBackColor2Param);

  FreeAndNil(FDrawTabCaptionParam);
  FreeAndNil(FDrawTabIconParam);
  FreeAndNil(FDrawTabPictureParam);
  FreeAndNil(FDrawBackGndPictureParam);
  FreeAndNil(FDrawTabHeaderPictureParam);
  FreeAndNil(FDrawTabHeaderColorParam);
  inherited;
end;

//procedure TSkinPageControlMaterial.SetIsDrawTabHeaderPicture(const Value: Boolean);
//begin
//  if FIsDrawTabHeaderPicture<>Value then
//  begin
//    FIsDrawTabHeaderPicture := Value;
//    DoChange;
//  end;
//end;

procedure TSkinPageControlMaterial.SetDrawTabHeaderPictureParam(const Value: TDrawPictureParam);
begin
  FDrawTabHeaderPictureParam.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetDrawBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDrawBackGndPictureParam.Assign(Value);
end;



procedure TSkinPageControlMaterial.SetDrawTabHeaderColorParam(const Value: TDrawRectParam);
begin
  FDrawTabHeaderColorParam.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetDrawTabBackColorParam(const Value: TDrawRectParam);
begin
  FDrawTabBackColorParam.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetDrawTabBackColor2Param(const Value: TDrawRectParam);
begin
  FDrawTabBackColor2Param.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetBackGndPicture(const Value: TDrawPicture);
begin
  FBackGndPicture.Assign(Value);
end;

//procedure TSkinPageControlMaterial.SetDrawBackGndPictureParam(const Value: TDrawPictureParam);
//begin
//  FDrawBackGndPictureParam.Assign(Value);
//end;
//
//procedure TSkinPageControlMaterial.SetIsDrawBackGndPicture(const Value: Boolean);
//begin
//  if FIsDrawBackGndPicture<>Value then
//  begin
//    FIsDrawBackGndPicture := Value;
//    DoChange;
//  end;
//end;

procedure TSkinPageControlMaterial.SetTabHeaderPicture(const Value: TDrawPicture);
begin
  FTabHeaderPicture.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetDrawTabCaptionParam(const Value: TDrawTextParam);
begin
  FDrawTabCaptionParam.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetDrawTabIconParam(const Value: TDrawPictureParam);
begin
  FDrawTabIconParam.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetDrawTabPictureParam(const Value: TDrawPictureParam);
begin
  FDrawTabPictureParam.Assign(Value);
end;

//procedure TSkinPageControlMaterial.SetTabDisabledPicture(const Value: TDrawPicture);
//begin
//  FTabDisabledPicture.Assign(Value);
//end;

procedure TSkinPageControlMaterial.SetTabDownPicture(const Value: TDrawPicture);
begin
  FTabDownPicture.Assign(Value);
end;

//procedure TSkinPageControlMaterial.SetTabFocusedPicture(const Value: TDrawPicture);
//begin
//  FTabFocusedPicture.Assign(Value);
//end;

procedure TSkinPageControlMaterial.SetTabHoverPicture(const Value: TDrawPicture);
begin
  FTabHoverPicture.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetTabNormalPicture(const Value: TDrawPicture);
begin
  FTabNormalPicture.Assign(Value);
end;

procedure TSkinPageControlMaterial.SetTabPushedPicture(const Value: TDrawPicture);
begin
  FTabPushedPicture.Assign(Value);
end;


{ TTabSheetProperties }


procedure TTabSheetProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  FIcon.Assign(TTabSheetProperties(Src).FIcon);
  FPushedIcon.Assign(TTabSheetProperties(Src).FPushedIcon);
end;

constructor TTabSheetProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinTabSheet,Self.FSkinTabSheetIntf) then
  begin
    ShowException('This Component Do not Support ISkinTabSheet Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=100;

    FTabVisible:=True;

    FSwitchSize:=-1;
    
    FTabSize:=60;
    FPageIndex:=-1;
    FIcon:=CreateDrawPicture('Icon','图标');
    FPushedIcon:=CreateDrawPicture('PushedIcon','按下图标');
  end;
end;

destructor TTabSheetProperties.Destroy;
begin
  if Self.FPageControl <> nil then
  begin
    Self.FSkinPageControlIntf.PageControlProperties.RemovePage(TSkinTabSheet(Self.FSkinControl));
  end;
  FreeAndNil(FPushedIcon);
  FreeAndNil(FIcon);
  inherited;
end;

function TTabSheetProperties.GetComponentClassify: String;
begin
  Result:='SkinTabSheet';
end;

function TTabSheetProperties.GetPageIndex: Integer;
begin
  if FPageControl <> nil then
  begin
    Result := FSkinPageControlIntf.PageControlProperties.FPages.IndexOf(Self.FSkinControl);
  end
  else
  begin
    Result := -1;
  end;
  Self.FPageIndex:=Result;
  Result:=FPageIndex;
end;

procedure TTabSheetProperties.SetIcon(const Value: TDrawPicture);
begin
  FIcon.Assign(Value);
end;

procedure TTabSheetProperties.SetPageControl(Value: TSkinPageControl);
begin
  if FPageControl<>Value then
  begin

    //如果页面被删除,那么原来的PageIndex就需要重建一下
    //比如原来PageIndex是0,1,2,3，如果2被删除了,那么原来的3就要变成2
    if FPageControl<>nil then
    begin
      Self.FSkinControlIntf.Parent:=nil;
      if Self.FSkinPageControlIntf.PageControlProperties<>nil then
      begin
        Self.FSkinPageControlIntf.PageControlProperties.RemovePage(TSkinTabSheet(Self.FSkinControl));
      end;
      FSkinPageControlIntf:=nil;
    end;


    FPageControl:=Value;


    if FPageControl<>nil then
    begin

      FSkinPageControlIntf:=FPageControl as ISkinPageControl;

      if (Self.FSkinPageControlIntf.PageControlProperties<>nil)
        and (Self.FSkinPageControlIntf.PageControlProperties.FPages.IndexOf(FSkinControl)=-1) then
      begin
        Self.FSkinPageControlIntf.PageControlProperties.AddPage(TSkinTabSheet(Self.FSkinControl));
      end;


    end;

  end;
end;

procedure TTabSheetProperties.SetPageIndex(const Value: Integer);
//var
//  I: Integer;
//  AIsExist:Boolean;
begin
  if (csLoading in Self.FSkinControl.ComponentState)
    or (csReading in Self.FSkinControl.ComponentState) then
  begin
    FPageIndex := Value;
    Exit;
  end;

  if (FPageControl <> nil) and (PageIndex<>Value) then
  begin
    if Value <= FSkinPageControlIntf.PageControlProperties.FPages.Count - 1 then
    begin

//      //是否有冲突,0,0    8,8
//      AIsExist:=False;
//      for I := 0 to FSkinPageControlIntf.PageControlProperties.FPages.Count-1 do
//      begin
//        if Value=FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex then
//        begin
//          //存在
//          AIsExist:=True;
//        end;
//      end;
//
//
//      if AIsExist then
//      begin
//        //往前插
//        if Value<FPageIndex then
//        begin
//            for I := 0 to FSkinPageControlIntf.PageControlProperties.FPages.Count-1 do
//            begin
//              if FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex>=Value then
//              begin
//                //后移
//                FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex:=
//                  FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex+1;
//              end;
//            end;
//        end
//        else
//        //往后插
//        begin
//            for I := 0 to FSkinPageControlIntf.PageControlProperties.FPages.Count-1 do
//            begin
//              if (FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex>FPageIndex)
//                and (FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex<=Value) then
//              begin
//                //前移
//                FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex:=
//                  FSkinPageControlIntf.PageControlProperties.GetTabSheetIntf(I).Prop.FPageIndex-1;
//              end;
//            end;
//        end;
//      end;
//
//
//      FSkinPageControlIntf.PageControlProperties.FPages.Remove(Self.FSkinControl,False);
//      //插入到指定下标
//      FSkinPageControlIntf.PageControlProperties.FPages.Insert(Value,Self.FSkinControl);

      FPageIndex:=Value;


      //重建可视页列表
      FSkinPageControlIntf.PageControlProperties.ReBuildPageIndexAndVisiblePages(TSkinTabSheet(Self.FSkinControl));
    end;
  end;
end;

procedure TTabSheetProperties.DoNotifyNumberIconInvalidate(Sender:TObject);
begin
  Invalidate;
end;

procedure TTabSheetProperties.SetNotifyNumberIconControl(const Value: TControl);
begin
  if FNotifyNumberIconControl<>Value then
  begin

      //原提醒图标去掉
      if FNotifyNumberIconControl<>nil then
      begin
          RemoveFreeNotification(FNotifyNumberIconControl,Self.FSkinControl);

          //在FNotifyNumberIcon释放的时候,Prop会为空
          if FNotifyNumberIconIntf.Prop<>nil then
          begin
            FNotifyNumberIconIntf.Prop.IsInHostControl:=False;
            FNotifyNumberIconIntf.Prop.OnInvalidate:=nil;
          end;
          FNotifyNumberIconControl.Visible:=True;


          FNotifyNumberIconControl:=nil;
          FNotifyNumberIconControlIntf:=nil;
      end;



      FNotifyNumberIconControl := nil;


      if Value<>nil then
      begin

          //设置NotifyNumberIcon在PageControl中
          if Not Value.GetInterface(IID_ISkinNotifyNumberIcon,FNotifyNumberIconIntf) then
          begin
            ShowException('This Component Do not Support ISkinControl Interface');
          end
          else
          begin

            FNotifyNumberIconControl := Value;

            Value.GetInterface(IID_ISkinControl,FNotifyNumberIconControlIntf);
            AddFreeNotification(FNotifyNumberIconControl,Self.FSkinControl);
            if FNotifyNumberIconControl<>nil then
            begin
              FNotifyNumberIconIntf.Prop.IsInHostControl:=True;
              FNotifyNumberIconIntf.Prop.OnInvalidate:=DoNotifyNumberIconInvalidate;


              //运行时隐藏
              if not (csDesigning in Self.FSkinControl.ComponentState) then
              begin
                FNotifyNumberIconControl.Visible:=False;
              end;

            end;

          end;
      end;
      Invalidate;
  end;
end;

procedure TTabSheetProperties.SetPushedIcon(const Value: TDrawPicture);
begin
  FPushedIcon.Assign(Value);
end;

procedure TTabSheetProperties.SetTabSize(const Value: Double);
begin
  if FTabSize<>Value then
  begin
    FTabSize := Value;
    Invalidate;
  end;
end;

procedure TTabSheetProperties.SetTabVisible(const Value: Boolean);
begin
  if FTabVisible<>Value then
  begin
    FTabVisible := Value;
    if FSkinPageControlIntf<>nil then
    begin
      FSkinPageControlIntf.PageControlProperties.ReBuildPageIndexAndVisiblePages(TSkinTabSheet(Self.FSkinControl));
    end;
  end;
end;





{ TSkinTabSheet }

function TSkinTabSheet.Material:TSkinTabSheetDefaultMaterial;
begin
  Result:=TSkinTabSheetDefaultMaterial(SelfOwnMaterial);
end;

function TSkinTabSheet.SelfOwnMaterialToDefault:TSkinTabSheetDefaultMaterial;
begin
  Result:=TSkinTabSheetDefaultMaterial(SelfOwnMaterial);
end;

function TSkinTabSheet.CurrentUseMaterialToDefault:TSkinTabSheetDefaultMaterial;
begin
  Result:=TSkinTabSheetDefaultMaterial(CurrentUseMaterial);
end;

function TSkinTabSheet.GetPageControl: TSkinPageControl;
begin
  Result:=Prop.PageControl;
end;

function TSkinTabSheet.GetPageIndex: Integer;
begin
  Result:=Prop.PageIndex;
end;

function TSkinTabSheet.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TTabSheetProperties;
end;

function TSkinTabSheet.GetTabSheetProperties: TTabSheetProperties;
begin
  Result:=TTabSheetProperties(Self.FProperties);
end;

function TSkinTabSheet.GetTabVisible: Boolean;
begin
  Result:=Self.Prop.TabVisible;
end;

procedure TSkinTabSheet.SetPageControl(const Value: TSkinPageControl);
begin
  Prop.PageControl:=Value;
end;

procedure TSkinTabSheet.SetPageIndex(const Value: Integer);
begin
  Prop.PageIndex:=Value;
end;

procedure TSkinTabSheet.SetTabSheetProperties(Value: TTabSheetProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinTabSheet.SetTabVisible(const Value: Boolean);
begin
  Self.Prop.TabVisible:=Value;
end;

procedure TSkinTabSheet.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  if Reader.Parent is TSkinPageControl then
  begin
    Self.Properties.PageControl:=TSkinPageControl(Reader.Parent);
  end;
end;

procedure TSkinTabSheet.Loaded;
begin
  inherited;

  //运行时隐藏
  if not (csDesigning in Self.ComponentState) then
  begin
    if Self.Properties.NotifyNumberIconControl<>nil then
    begin
      Self.Properties.NotifyNumberIconControl.Visible:=False;
    end;
  end;


end;

procedure TSkinTabSheet.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState)
    and (Properties.PageControl<>nil) then
  begin
    TControl(Properties.PageControl).RePaint;
  end;
  Inherited;
end;

procedure TSkinTabSheet.Notification(AComponent: TComponent;Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin
      if (AComponent=Self.Properties.NotifyNumberIconControl) then
      begin
        Self.Properties.NotifyNumberIconControl:=nil;
      end;
    end;
  end;
end;



{ TSkinPageControl }

function TSkinPageControl.Material:TSkinPageControlDefaultMaterial;
begin
  Result:=TSkinPageControlDefaultMaterial(SelfOwnMaterial);
end;

function TSkinPageControl.SelfOwnMaterialToDefault:TSkinPageControlDefaultMaterial;
begin
  Result:=TSkinPageControlDefaultMaterial(SelfOwnMaterial);
end;

function TSkinPageControl.CurrentUseMaterialToDefault:TSkinPageControlDefaultMaterial;
begin
  Result:=TSkinPageControlDefaultMaterial(CurrentUseMaterial);
end;

procedure TSkinPageControl.AfterPaint;
var
  ACanvas:TDrawCanvas;
begin
  {$IFDEF FMX}
  if Self.Properties.FIsAfterPaintTabIcon then
  begin
    ACanvas:=CreateDrawCanvas('TSkinPageControl');
    try
      ACanvas.Prepare(Canvas);
      TSkinPageControlType(Self.GetSkinControlType).PaintPageControlTabIcons(ACanvas,Self.CurrentUseMaterial,RectF(0,0,Width,Height),GlobalNullPaintData);
    finally
      FreeAndNil(ACanvas);
    end;
  end;
  {$ENDIF FMX}

end;

function TSkinPageControl.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TPageControlProperties;
end;

function TSkinPageControl.GetPageControlProperties: TPageControlProperties;
begin
  Result:=TPageControlProperties(Self.FProperties);
end;

procedure TSkinPageControl.SetPageControlProperties(Value: TPageControlProperties);
begin
  Self.FProperties.Assign(Value);
end;

destructor TSkinPageControl.Destroy;
begin
  Inherited;
end;

procedure TSkinPageControl.Loaded;
begin
  Inherited;

  //FPages根据FPageIndex排序
  //Self.Properties.SortPages;
  Self.Properties.ReBuildPageIndexAndVisiblePages(nil);
  Self.Properties.FActivePageIndex:=Self.Properties.FPages.IndexOf(Self.Properties.FActivePage);

  //创建图片列表下标按钮
  Properties.AlignSwitchButtons;

  Properties.AlignPages;
end;

procedure TSkinPageControl.SetActivePage(const Value: TSkinTabSheet);
begin
  Self.Prop.SetActivePage(Value);
end;

procedure TSkinPageControl.SetOnChange(const Value: TNotifyEvent);
begin
  Self.FOnChange:=Value;
end;

function TSkinPageControl.GetActivePage: TSkinTabSheet;
begin
  Result:=Self.Prop.ActivePage;
end;

function TSkinPageControl.GetOnChange: TNotifyEvent;
begin
  Result:=Self.FOnChange;
end;

procedure TSkinPageControl.SetOnChanging(const Value: TPageChangingEvent);
begin
  Self.FOnChanging:=Value;
end;

procedure TSkinPageControl.SetOnCustomCalcHeadDrawRect(
  const Value: TCustomCalcHeadDrawRectEvent);
begin
  FOnCustomCalcHeadDrawRect:=Value;
end;

procedure TSkinPageControl.SetOnCustomCalcTabDrawRect(
  const Value: TCustomCalcTabDrawRectEvent);
begin
  FOnCustomCalcTabDrawRect:=Value;
end;

procedure TSkinPageControl.SetOnCustomCalcTabIconDrawRect(
  const Value: TCustomCalcTabDrawIconRectEvent);
begin
  FOnCustomCalcTabIconDrawRect:=Value;
end;

function TSkinPageControl.GetOnChanging: TPageChangingEvent;
begin
  Result:=Self.FOnChanging;
end;

function TSkinPageControl.GetOnCustomCalcHeadDrawRect: TCustomCalcHeadDrawRectEvent;
begin
  Result:=FOnCustomCalcHeadDrawRect;
end;

function TSkinPageControl.GetOnCustomCalcTabDrawRect: TCustomCalcTabDrawRectEvent;
begin
  Result:=FOnCustomCalcTabDrawRect;
end;

function TSkinPageControl.GetOnCustomCalcTabIconDrawRect: TCustomCalcTabDrawIconRectEvent;
begin
  Result:=FOnCustomCalcTabIconDrawRect;
end;

function TSkinPageControl.GetSwitchButtonGroupIntf:ISkinButtonGroup;
begin
  Result:=FSwitchButtonGroupIntf;
end;

//function TSkinPageControl.GetSwitchButtonGroupComponentIntf:ISkinComponent;
//begin
//  Result:=FSwitchButtonGroupComponentIntf;
//end;
//
//function TSkinPageControl.GetSwitchButtonGroupControlIntf:ISkinControl;
//begin
//  Result:=FSwitchButtonGroupControlIntf;
//end;

function TSkinPageControl.GetSwitchButtonGroup: TSkinBaseButtonGroup;
begin
  Result:=Self.FSwitchButtonGroup;
end;

procedure TSkinPageControl.SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
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
              //释放里面的按钮
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
          FSwitchButtonGroupIntf:=FSwitchButtonGroup as ISkinButtonGroup;
          AddFreeNotification(FSwitchButtonGroup,Self);
          //创建图片列表下标按钮
          Properties.AlignSwitchButtons;


        end;
  end;
end;

procedure TSkinPageControl.StayClick;
var
  APage:TSkinTabSheet;
begin
  inherited;

  //选中列表项
  APage:=Self.Prop.PageAt(Self.GetSkinControlType.FMouseDownPt.X,
                          Self.GetSkinControlType.FMouseDownPt.Y);

  if (APage<>nil) and (APage = Self.Prop.MouseDownPage) then
  begin
    Self.Prop.ActivePage:=APage;
  end;
  Self.Prop.MouseDownPage:=nil;

end;

procedure TSkinPageControl.Notification(AComponent: TComponent;Operation: TOperation);
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



function TSkinPageControl.PageCount: Integer;
begin
  Result:=Self.Prop.PageCount;
end;

{ TSkinSwitchPageControlGestureManager }


function TSkinSwitchPageControlGestureManager.GetBaseControlStartPos: Double;
begin
  Result:=0;
end;

function TSkinSwitchPageControlGestureManager.GetPageCount: Integer;
begin
  Result:=0;
  if Self.FProperties<>nil then
  begin
    Result:=FProperties.PageCount;
  end;
end;

function TSkinSwitchPageControlGestureManager.GetPageIndex: Integer;
begin
  Result:=-1;
  if Self.FProperties<>nil then
  begin
    Result:=FProperties.ActivePageIndex;
  end;
end;

function TSkinSwitchPageControlGestureManager.GetPageItemSize(
  APageIndex: Integer; AGestureKind: TGestureKind;
  AGestureDirection: TGestureDirection): Double;
begin
  Result:=0;
  if FProperties<>nil then
  begin
      case AGestureKind of
        gmkHorizontal: Result:=Self.FProperties.GetPageRect.Width;
        gmkVertical: Result:=Self.FProperties.GetPageRect.Height;
      end;
  end;
end;

procedure TSkinSwitchPageControlGestureManager.SetPageIndex(
  APageIndex: Integer);
begin
  if Self.FProperties<>nil then
  begin
    FProperties.ActivePageIndex:=APageIndex;
  end;
end;

procedure TSkinSwitchPageControlGestureManager.SetPagePos(APageIndex: Integer;
  AGestureKind: TGestureKind; APos: Double);
begin
  if (APageIndex>=0)
    and (APageIndex<Self.GetPageCount)
    and (FProperties<>nil) then
  begin
    case AGestureKind of
      gmkHorizontal:
      begin
        FProperties.Pages[APageIndex].Visible:=True;
        SetControlLeft(FProperties.Pages[APageIndex],ControlSize(APos));
      end;
      gmkVertical:
      begin
        FProperties.Pages[APageIndex].Visible:=True;
        SetControlTop(FProperties.Pages[APageIndex],ControlSize(APos));
      end;
    end;
  end;

end;

//initialization
//  GlobalIPhoneXBottomBarHeight:=20;


end.


