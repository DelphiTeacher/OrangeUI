//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     列表框
///   </para>
///   <para>
///     List Box
///   </para>
/// </summary>
unit uSkinVirtualChartType;

interface
{$I FrameWork.inc}
{$I Version.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,

  {$IF CompilerVersion>=30.0}
  Types,//定义了TRectF
  {$IFEND}

  uBaseList,
  uBaseLog,
  DateUtils,

  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,
  {$ENDIF}


  Math,
  uBaseSkinControl,
  uSkinItems,
  uDrawParam,
  uGraphicCommon,
  uSkinBufferBitmap,
  uDrawCanvas,
  uFileCommon,
  uComponentType,
  uDrawEngine,
  uBinaryTreeDoc,
  uDrawPicture,
  uSkinMaterial,
  uDrawTextParam,
  uDrawLineParam,
  uDrawRectParam,
  uBasePathData,
  uDrawPathParam,
  uSkinImageList,
  uSkinListLayouts,
  uSkinPanelType,
  uSkinCustomListType,
  uSkinVirtualListType,
  uSkinListBoxType,
  uSkinLabelType,
  uSkinItemDesignerPanelType,

  {$IFDEF FMX}
  uSkinFireMonkeyItemDesignerPanel,
  {$ENDIF}

  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
  uSkinListViewType,
  {$ENDIF}

//  uSkinControlGestureManager,
//  uSkinScrollControlType,
  uDrawPictureParam;

const
  IID_ISkinVirtualChart:TGUID='{A9C74863-07FA-4F4E-9582-920D4019D37D}';




type
  TSkinVirtualChartItems=class;
  TSkinVirtualChartItemsClass=class of TSkinVirtualChartItems;
  TVirtualChartProperties=class;
//  TSkinVirtualChartLayoutsManager=class;

  /// <summary>
  ///   <para>
  ///     列表项
  ///   </para>
  ///   <para>
  ///     ListItem
  ///   </para>
  /// </summary>
  TSkinVirtualChartItem=TRealSkinItem;




  /// <summary>
  ///   <para>
  ///     列表框接口
  ///   </para>
  ///   <para>
  ///     Interface of VirtualChart
  ///   </para>
  /// </summary>
  ISkinVirtualChart=interface//(ISkinScrollControl)
  ['{A9C74863-07FA-4F4E-9582-920D4019D37D}']


    function GetVirtualChartProperties:TVirtualChartProperties;
    property Properties:TVirtualChartProperties read GetVirtualChartProperties;
    property Prop:TVirtualChartProperties read GetVirtualChartProperties;
  end;


//  //坐标上的某一项
//  TVirtualChartAxisDataItem=class(TRealSkinItem)
//
//  end;
//  TVirtualChartAxisDataItems=class(TSkinItems)
//  private
//    function GetItem(Index: Integer): TVirtualChartAxisDataItem;
//    procedure SetItem(Index: Integer; const Value: TVirtualChartAxisDataItem);
//  protected
////    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
////    procedure InitSkinItemClass;override;
//    function GetSkinItemClass:TBaseSkinItemClass;override;
//  public
//    function Add:TVirtualChartAxisDataItem;overload;
//    function Insert(Index:Integer):TVirtualChartAxisDataItem;
//    property Items[Index:Integer]:TVirtualChartAxisDataItem read GetItem write SetItem;default;
//  end;
  //坐标类型
  TSkinChartAxisType=(scatCategory,scatValue);
//  TVirtualChartAxis=class(TPersistent)
//  private
//    FItems:TVirtualChartAxisDataItems;
//    FAxisType: TSkinChartAxisType;
//    procedure SetItems(const Value: TVirtualChartAxisDataItems);
//  public
//    constructor Create;
//    destructor Destroy;override;
//    //FDataFieldName:String;
//    property AxisType:TSkinChartAxisType read FAxisType write FAxisType;
//    //这个坐标系是分类还是值
//    //数据列表，数据放Item.Json中即可
//    property Items:TVirtualChartAxisDataItems read FItems write SetItems;
//  end;







  TVirtualChartSeries=class;
  TVirtualChartSeriesDrawer=class;


  //图表项的数据项
  TVirtualChartSeriesDataItem=class(TRealSkinItem)
  public
    FValue:Double;
  protected
    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure AssignTo(Dest: TPersistent); override;

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    FDrawPercent:Double;
    FDrawPathActions:TPathActionCollection;
  public
    //扇形中心点的角度,-90,0,用于判断标题左边齐还是右对齐,-90~90之间是左对齐,其他情况是右对齐
    FPieArcCenterAngle:Double;
    //饼图圆弧的中心点
    FPieArcCenterPoint:TPointF;
    //中心点同角度的延伸线
    FPieArcCenterExtendPoint:TPointF;
    FPieArcCenterExtendHorzPoint:TPointF;
    //数据项标题的绘制矩形
    FCaptionRect:TRectF;
    //扇形的起点角度,正上方为-90度,用于在FMX下判断鼠标是否在该扇形内
    FPieStartAngle:Double;
    FPieSweepAngle:Double;
  public
    //线状图的点
    FLinePoint:TPointF;
    //线状图的点圆,用于画圆,也用于判断鼠标在不在数据项里面
    FLineDotRect:TRectF;
  public
    //柱子的矩形,用于在柱形图的时候判断鼠标是否在数据项里面
    FBarPathDrawRect:TRectF;

  public
    //判断鼠标是否在Item里面
    function PtInItem(APoint:TPointF):Boolean;override;
  private
    procedure SetValue(const AValue: Double);
  public
    constructor Create;override;
    destructor Destroy;override;
  published
    //数据值
    property Value:Double read FValue write SetValue;
  end;
  TVirtualChartSeriesDataItems=class(TSkinItems)
  private
    function GetItem(Index: Integer): TVirtualChartSeriesDataItem;
    procedure SetItem(Index: Integer; const Value: TVirtualChartSeriesDataItem);
  protected
//    function GetSkinItemClass:TBaseSkinItemClass;override;
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
  public
    FSeries:TVirtualChartSeries;
    function Add:TVirtualChartSeriesDataItem;overload;
    function Insert(Index:Integer):TVirtualChartSeriesDataItem;
    property Items[Index:Integer]:TVirtualChartSeriesDataItem read GetItem write SetItem;default;
  end;
  TSkinChartType=(sctBar,sctLine,sctPie);
  //图表数据
  TVirtualChartSeries=class(TCollectionItem)
  private
//    FIsGeneratedDrawPathList:Boolean;
    FDataItems: TVirtualChartSeriesDataItems;
//    FDrawPathItems: TVirtualChartSeriesDataDrawPathItems;
    FDrawer:TVirtualChartSeriesDrawer;
    FPathDrawRect:TRectF;
    FListLayoutsManager:TSkinListLayoutsManager;
    //图表项的名称,比如统计是的金额还是数量
    FCaption: String;

    FSameCharTypeIndex:Integer;

    FChartType: TSkinChartType;
    procedure DoItemPropChange(Sender:TObject);
    procedure SetDataItems(const Value: TVirtualChartSeriesDataItems);
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;virtual;
    procedure SetCaption(const Value: String);
    procedure SetChartType(const Value: TSkinChartType);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  public

    procedure GetMinMaxValue(var AMinValue:Double;var AMaxValue:Double;var ASumValue:Double);
    //生成列表项的绘制path
    procedure GenerateDrawPathList(const ADrawRect:TRectF);

  published
    //图表项的名称,比如统计是的金额还是数量
    property Caption:String read FCaption write SetCaption;
    //图标类型
    property ChartType:TSkinChartType read FChartType write SetChartType;
    //FDataFieldName:String;
    //数据列表，数据放Item.Json中即可
    property DataItems:TVirtualChartSeriesDataItems read FDataItems write SetDataItems;
//    property DrawPathItems:TVirtualChartSeriesDataDrawPathItems read FDrawPathItems;
  end;

  //图表数据列表
  TVirtualChartSeriesList=class(TCollection)
  private
    function GetItem(Index: Integer): TVirtualChartSeries;
    procedure SetItem(Index: Integer; const Value: TVirtualChartSeries);
  public
    FSkinVirtualChartIntf:ISkinVirtualChart;

    FSumValue:Double;
    FMinValue:Double;
    FMaxValue:Double;
//    FStep:Double;
    //是否已经生成了绘制参数
    FIsGeneratedDrawPathList:Boolean;

    FLineSeriesCount:Integer;
    FPieSeriesCount:Integer;
    FBarSeriesCount:Integer;

    procedure DoChange;

    constructor Create(ItemClass: TCollectionItemClass;ASkinVirtualChartIntf:ISkinVirtualChart);
    //获取最大的值,用来计算柱状图的百分比
    procedure CalcMinMaxValueAndStep;
    //生成列表项的绘制path
    procedure GenerateDrawPathList(const ADrawRect:TRectF);

    function Add:TVirtualChartSeries;

    property Items[Index:Integer]:TVirtualChartSeries read GetItem write SetItem;default;
  end;





  //图表数据项绘制路径生成基类
  TVirtualChartSeriesDrawer=class
  public
    FSeries:TVirtualChartSeries;
    //获取Path的绘制区域
    function GetPathDrawRect(ADrawRect:TRectF):TRectF;virtual;
    //生成绘制的Path列表
    procedure GenerateDrawPathList(APathDrawRect:TRectF);virtual;abstract;
    //获取这个数据项的颜色
    function GetDataItemColor(ADataItem:TVirtualChartSeriesDataItem):TDelphiColor;virtual;
    //绘制坐标轴
    procedure PaintAxis(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;
                        const ADrawRect:TRectF;
                        APaintData:TPaintData;
                        const APathDrawRect:TRectF);
    //绘制
    function CustomPaint(ACanvas:TDrawCanvas;
                          ASkinMaterial:TSkinControlMaterial;
                          const ADrawRect:TRectF;
                          APaintData:TPaintData;
                          const APathDrawRect:TRectF):Boolean;virtual;
  public
    constructor Create(AVirtualChartSeries:TVirtualChartSeries);virtual;
  end;

  //柱状图生成路径
  TVirtualChartSeriesBarDrawer=class(TVirtualChartSeriesDrawer)
  public
    procedure GenerateDrawPathList(APathDrawRect:TRectF);override;
    //绘制Y轴分隔线，X轴刻度值
    function CustomPaint(ACanvas:TDrawCanvas;
                          ASkinMaterial:TSkinControlMaterial;
                          const ADrawRect:TRectF;
                          APaintData:TPaintData;
                          const APathDrawRect:TRectF):Boolean;override;
  end;

  //线状图生成路径
  TVirtualChartSeriesLineDrawer=class(TVirtualChartSeriesDrawer)
  public
    procedure GenerateDrawPathList(APathDrawRect:TRectF);override;
//    function GetDataItemColor(ADataItem:TVirtualChartSeriesDataItem):TDelphiColor;override;
    //绘制Y轴分隔线，X轴刻度值
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData;const APathDrawRect:TRectF):Boolean;override;
  end;


  //饼状图生成路径
  TVirtualChartSeriesPieDrawer=class(TVirtualChartSeriesDrawer)
  public
    //大半径
    FRadius:Double;
    //小半径,中空那个圆的半径
    FInnerRadius:Double;
    //圆心
    FCircleCenterPoint:TPointF;

    procedure DoLegendListViewPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: {$IFDEF FMX}TSkinFMXItemDesignerPanel{$ENDIF}{$IFDEF VCL}TSkinItemDesignerPanel{$ENDIF}; AItem: TSkinItem;
      AItemDrawRect: TRect);

    //获取Path的绘制区域
    function GetPathDrawRect(ADrawRect:TRectF):TRectF;override;
    procedure GenerateDrawPathList(APathDrawRect:TRectF);override;
    function GetDataItemColor(ADataItem:TVirtualChartSeriesDataItem):TDelphiColor;override;
    //绘制Y轴分隔线，X轴刻度值
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData;const APathDrawRect:TRectF):Boolean;override;
  end;










  /// <summary>
  ///   <para>
  ///     列表框属性
  ///   </para>
  ///   <para>
  ///     Properties of VirtualChart
  ///   </para>
  /// </summary>
  TVirtualChartProperties=class(TSkinControlProperties)
  protected
    FSkinVirtualChartIntf:ISkinVirtualChart;
  private
    FXAxisType: TSkinChartAxisType;
    FYAxisType: TSkinChartAxisType;
//    procedure SetXAxis(const Value: TVirtualChartAxis);
//    procedure SetYAxis(const Value: TVirtualChartAxis);
//    procedure SetXAxis(const Value: TVirtualChartAxis);
//    procedure SetYAxis(const Value: TVirtualChartAxis);
    procedure SetSeriesList(const Value: TVirtualChartSeriesList);
    function GetAxisItems: TSkinListBoxItems;
    function GetYAxisItems: TSkinListBoxItems;
    procedure SetAxisItems(const Value: TSkinListBoxItems);
    procedure SetXAxisType(const Value: TSkinChartAxisType);
    procedure SetYAxisItems(const Value: TSkinListBoxItems);
    procedure SetYAxisType(const Value: TSkinChartAxisType);

    //X轴类型,默认是分类
    property XAxisType:TSkinChartAxisType read FXAxisType write SetXAxisType;
    //Y轴类型,默认是刻度
    property YAxisType:TSkinChartAxisType read FYAxisType write SetYAxisType;
  protected
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    {$IFDEF OPENSOURCE_VERSION}
    FLegendSkinListView:TSkinListBox;
    {$ELSE}
    FLegendSkinListView:TSkinListView;
    {$ENDIF}
    FXAxisSkinListBox:TSkinListBox;
    FYAxisSkinListBox:TSkinListBox;

//    FXAxis: TVirtualChartAxis;
//    FYAxis: TVirtualChartAxis;


    FSeriesList: TVirtualChartSeriesList;

    procedure BeginUpdate;override;
    procedure EndUpdate;override;
  public
    //饼图提示ListView的设计面板样式
    //默认的
    FLegendItemStyle:String;
    FLegendItemDesignerPanel:TSkinItemDesignerPanel;
    FLegendItemColorPanel:TSkinPanel;
    FLegendCategoryPanel:TSkinLabel;
    //提示Item鼠标停靠状态改变的时候,相应的扇形也鼠标停靠
    procedure DoLegendListViewMouseOverItemChange(Sender:TObject);
    procedure CreateLegendItemDesignerPanel;


  public
    //弹出提示
    FTooltipItemStyle: String;
    FShowTooltip: Boolean;

    FLastTooltipDataItem:TVirtualChartSeriesDataItem;
    FTooltipItemDesignerPanel:TSkinItemDesignerPanel;
    FTooltipSeriesCaptionLabel:TSkinLabel;
    FTooltipItemColorPanel:TSkinPanel;
    FTooltipCategoryPanel:TSkinLabel;
    FTooltipItemValuePanel:TSkinLabel;

    FTooltipItemDesignerPanelVisible:Boolean;
    procedure CreateTooltipItemDesignerPanel;
    procedure DoShowTooltip(ATooltipDataItem:TVirtualChartSeriesDataItem;X,Y:Double);

//    //X轴
//    property XAxis:TVirtualChartAxis read FXAxis write SetXAxis;
//    //X轴
//    property YAxis:TVirtualChartAxis read FYAxis write SetYAxis;
//    //提示窗体的样式
//    property TooltipItemStyle:String read FTooltipItemStyle write FTooltipItemStyle;

    property YAxisItems:TSkinListBoxItems read GetYAxisItems write SetYAxisItems;

  published
    //X轴刻度列表
    property AxisItems:TSkinListBoxItems read GetAxisItems write SetAxisItems;

    //图表项列表
    property SeriesList:TVirtualChartSeriesList read FSeriesList write SetSeriesList;

    //是否需要提示
    property ShowTooltip:Boolean read FShowTooltip write FShowTooltip;
  end;














  /// <summary>
  ///   <para>
  ///     列表项列表
  ///   </para>
  ///   <para>
  ///     ListItem List
  ///   </para>
  /// </summary>
  TSkinVirtualChartItems=class(TSkinItems)
  private
    function GetItem(Index: Integer): TSkinVirtualChartItem;
    procedure SetItem(Index: Integer; const Value: TSkinVirtualChartItem);
  protected
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
  public
    function Add:TSkinVirtualChartItem;overload;
    function Insert(Index:Integer):TSkinVirtualChartItem;
    property Items[Index:Integer]:TSkinVirtualChartItem read GetItem write SetItem;default;
  end;






//  /// <summary>
//  ///   <para>
//  ///     列表项逻辑
//  ///   </para>
//  ///   <para>
//  ///     ListItem Logic
//  ///   </para>
//  /// </summary>
//  TSkinVirtualChartLayoutsManager=class(TSkinVirtualListLayoutsManager)
//  end;

  //多个柱子的时候的排列方式
  TBarsStackType=(bstQueue,//排队
                  bstOverride//覆盖
                  );
  /// <summary>
  ///   <para>
  ///     列表框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of VirtualChart material
  ///   </para>
  /// </summary>
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinVirtualChartDefaultMaterial=class(TSkinControlMaterial)
  private
    FBarColorParam: TDrawPathParam;
    FBarAxisLineParam: TDrawLineParam;
    FDrawAxisCaptionParam: TDrawTextParam;
    FBarSizePercent: Double;
    FPieRadiusPercent: Double;
    FPieColorParam: TDrawPathParam;
    FPieInnerSizePercent: Double;
    FLineColorParam: TDrawLineParam;
    FLineDotParam: TDrawPathParam;
    FLineDotRadius: Double;
    FSeriesLegendListViewVisible: Boolean;
    FPieInfoVisible: Boolean;
    FPieInfoCaptionParam: TDrawTextParam;
    FBarsStackType: TBarsStackType;

    FYAxisCaptionWidth: Double;
    FXAxisCaptionHeight: Double;
    FMarginsLeft: Double;
    FMarginsTop: Double;
    FMarginsRight: Double;
    FMarginsBottom: Double;
    procedure SetBarColorParam(const Value: TDrawPathParam);
    procedure SetBarAxisLineParam(const Value: TDrawLineParam);
    procedure SetBarSizePercent(const Value: Double);
    procedure SetDrawAxisCaptionParam(const Value: TDrawTextParam);
    procedure SetPieRadiusPercent(const Value: Double);
    procedure SetPieColorParam(const Value: TDrawPathParam);
    procedure SetPieInnerRadiusPercent(const Value: Double);
    procedure SetLineColorParam(const Value: TDrawLineParam);
    procedure SetLineDotParam(const Value: TDrawPathParam);
    procedure SetPieInfoCaptionParam(const Value: TDrawTextParam);
    procedure SetBarsStackType(const Value: TBarsStackType);
    procedure SetPieInfoVisible(const Value: Boolean);
    procedure SetSeriesLegendListViewVisible(const Value: Boolean);
  public
    //多个柱状图、线状图，和饼图扇形的颜色数组
    FSeriesColorArray:Array of TDelphiColor;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;


    //柱子的路径绘制参数
    property BarColorParam: TDrawPathParam read FBarColorParam write SetBarColorParam;


    property LineDotParam: TDrawPathParam read FLineDotParam write SetLineDotParam;
    property LineDotRadius:Double read FLineDotRadius write FLineDotRadius;
    //线状图
    property LineColorParam: TDrawLineParam read FLineColorParam write SetLineColorParam;


    //饼图扇形的路径绘制参数
    property PieColorParam: TDrawPathParam read FPieColorParam write SetPieColorParam;
    //饼图说明的标题
    property PieInfoCaptionParam:TDrawTextParam read FPieInfoCaptionParam write SetPieInfoCaptionParam;


    //坐标线的颜色
    property BarAxisLineParam:TDrawLineParam read FBarAxisLineParam write SetBarAxisLineParam;
//    //坐标轴刻度线的位置
//    property BarXAxisMarkPosition:TAxisMarkPosition read FBarXAxisMarkPosition write SetBarXAxisMarkPosition;

    //坐标刻度标题的文本绘制参数
    property DrawAxisCaptionParam:TDrawTextParam read FDrawAxisCaptionParam write SetDrawAxisCaptionParam;


  published
    property MarginsLeft:Double read FMarginsLeft write FMarginsLeft;
    property MarginsTop:Double read FMarginsTop write FMarginsTop;
    property MarginsRight:Double read FMarginsRight write FMarginsRight;
    property MarginsBottom:Double read FMarginsBottom write FMarginsBottom;

    //纵坐标刻度标题的宽度
    property YAxisCaptionWidth:Double read FYAxisCaptionWidth write FYAxisCaptionWidth;
    //横坐标刻度标题的高度
    property XAxisCaptionHeight:Double read FXAxisCaptionHeight write FXAxisCaptionHeight;

  published
    //多个柱子的时候的排列方式
    property BarsStackType: TBarsStackType read FBarsStackType write SetBarsStackType;

    //柱子宽度的百分比
    property BarSizePercent: Double read FBarSizePercent write SetBarSizePercent;

  published
    //饼图半径占控件的百分比
    property PieRadiusPercent: Double read FPieRadiusPercent write SetPieRadiusPercent;
    //饼图内部空心圆的半径百分比
    property PieInnerRadiusPercent: Double read FPieInnerSizePercent write SetPieInnerRadiusPercent;
    //饼图说明是否需要显示
    property PieInfoVisible:Boolean read FPieInfoVisible write SetPieInfoVisible;

    //饼图介绍的ListView是否显示
    property SeriesLegendListViewVisible:Boolean read FSeriesLegendListViewVisible write SetSeriesLegendListViewVisible;
  end;





  TSkinVirtualChartDefaultType=class(TSkinControlType)
  protected
    FSkinVirtualChartIntf:ISkinVirtualChart;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;



    //鼠标事件//
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;


    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //尺寸更改
    procedure SizeChanged;override;
  protected
    function GetSkinMaterial:TSkinVirtualChartDefaultMaterial;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinVirtualChart=class(TBaseSkinControl,ISkinVirtualChart)
  private

    function GetVirtualChartProperties:TVirtualChartProperties;
    procedure SetVirtualChartProperties(Value:TVirtualChartProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    function SelfOwnMaterialToDefault:TSkinVirtualChartDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinVirtualChartDefaultMaterial;
    function Material:TSkinVirtualChartDefaultMaterial;

    property Prop:TVirtualChartProperties read GetVirtualChartProperties write SetVirtualChartProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TVirtualChartProperties read GetVirtualChartProperties write SetVirtualChartProperties;

  end;





  {$IFDEF VCL}
  TSkinWinVirtualChart=class(TSkinVirtualChart)
  end;
  {$ENDIF}
  {$IFDEF FMX}
  TSkinFMXVirtualChart=class(TSkinVirtualChart)
  end;
  {$ENDIF}



//判断点是否在扇形内
function PtInPie(ACircleCenterPoint:TPointF;
                APoint:TPointF;
                ADataItem:TVirtualChartSeriesDataItem;
                ARadius:Double;
                AStartAngle:Double;
                ASweepAngle:Double):Boolean;
//获取某一点与圆心的角度
//返回的是0~360,正上方为0
function GetAngle(ACircleCenterPoint:TPointF;APoint:TPointF):Double;


implementation




{ TVirtualChartProperties }


procedure TVirtualChartProperties.BeginUpdate;
begin
  inherited;
  Self.FXAxisSkinListBox.Prop.Items.BeginUpdate;
  Self.FYAxisSkinListBox.Prop.Items.BeginUpdate;
end;

constructor TVirtualChartProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinVirtualChart,Self.FSkinVirtualChartIntf) then
  begin
    ShowException('This Component Do not Support ISkinVirtualChart Interface');
  end
  else
  begin
//    FXAxis:=TVirtualChartAxis.Create;
//    FXAxis.FAxisType:=scatCategory;
//
//    FYAxis:=TVirtualChartAxis.Create;
//    FYAxis.FAxisType:=scatValue;

    FXAxisType:=scatCategory;

    FYAxisType:=scatValue;

    FSeriesList:=TVirtualChartSeriesList.Create(TVirtualChartSeries,Self.FSkinVirtualChartIntf);



    {$IFDEF OPENSOURCE_VERSION}
      //图表提示的ListView
      FLegendSkinListView:=TSkinListBox.Create(nil);
    {$ELSE}
      //图表提示的ListView
      FLegendSkinListView:=TSkinListView.Create(nil);
    {$ENDIF}
      FLegendSkinListView.Parent:=TParentControl(Self.FSkinControl);
      FLegendSkinListView.Visible:=False;
      {$IFDEF FMX}
      FLegendSkinListView.Stored:=False;
      FLegendSkinListView.Locked:=True;
      {$ENDIF}
      {$IFDEF VCL}
      FLegendSkinListView.Material.IsTransparent:=True;
      FLegendSkinListView.Material.BackColor.IsFill:=False;
      {$ENDIF}
      FLegendSkinListView.Prop.ListLayoutsManager.SkinListIntf:=nil;
      FreeAndNil(FLegendSkinListView.Properties.FItems);


    //X轴
    FXAxisSkinListBox:=TSkinListBox.Create(nil);
    FXAxisSkinListBox.Parent:=TParentControl(Self.FSkinControl);
    FXAxisSkinListBox.Visible:=False;
    {$IFDEF FMX}
    FXAxisSkinListBox.Stored:=False;
    {$ENDIF}



    //Y轴
    FYAxisSkinListBox:=TSkinListBox.Create(nil);
    FYAxisSkinListBox.Parent:=TParentControl(Self.FSkinControl);
    FYAxisSkinListBox.Visible:=False;
    {$IFDEF FMX}
    FYAxisSkinListBox.Stored:=False;
    {$ENDIF}



    ShowTooltip:=True;

  end;
end;

procedure TVirtualChartProperties.CreateLegendItemDesignerPanel;
begin
  if FLegendItemStyle='' then
  begin
    FLegendItemDesignerPanel:=TSkinItemDesignerPanel.Create(nil);
    FLegendItemDesignerPanel.SkinControlType;
    FLegendItemDesignerPanel.SelfOwnMaterial;
    {$IFDEF FMX}
    FLegendItemDesignerPanel.Stored:=False;
    {$ENDIF}
    {$IFDEF VCL}
    FLegendItemDesignerPanel.Material.IsTransparent:=True;
    FLegendItemDesignerPanel.Material.BackColor.IsFill:=False;
    {$ENDIF}
//    FLegendItemDesignerPanel.Material.IsTransparent:=True;
//    FLegendItemDesignerPanel.Material.BackColor.FillColor.Color:=WhiteColor;
//    FLegendItemDesignerPanel.Material.BackColor.ShadowSize:=8;
//    FLegendItemDesignerPanel.Material.BackColor.IsRound:=True;
    FLegendItemDesignerPanel.Parent:=TParentControl(Self.FSkinControl);
    FLegendItemDesignerPanel.Visible:=False;
//    FLegendItemDesignerPanel.Padding.SetBounds(Ceil(FLegendItemDesignerPanel.Material.BackColor.ShadowSize),
//                                    Ceil(FLegendItemDesignerPanel.Material.BackColor.ShadowSize),
//                                    Ceil(FLegendItemDesignerPanel.Material.BackColor.ShadowSize),
//                                    Ceil(FLegendItemDesignerPanel.Material.BackColor.ShadowSize));
    FLegendItemDesignerPanel.Width:=150;
    FLegendItemDesignerPanel.Height:=24;




    //数据项的颜色,要圆形
    FLegendItemColorPanel:=TSkinPanel.Create(FLegendItemDesignerPanel);
    FLegendItemColorPanel.SkinControlType;
    FLegendItemColorPanel.SelfOwnMaterial;
    FLegendItemColorPanel.Parent:=FLegendItemDesignerPanel;
    FLegendItemColorPanel.BindItemFieldName:='ItemColor';
    {$IFDEF VCL}
    FLegendItemColorPanel.Material.IsTransparent:=True;
    {$ENDIF}
    {$IFDEF FMX}
    FLegendItemColorPanel.Material.IsTransparent:=False;
    {$ENDIF}
    FLegendItemColorPanel.Material.BackColor.IsFill:=True;
    FLegendItemColorPanel.Material.BackColor.IsRound:=True;
    FLegendItemColorPanel.Material.BackColor.RoundWidth:=-1;
    FLegendItemColorPanel.Material.BackColor.RoundHeight:=-1;
    FLegendItemColorPanel.Material.BackColor.Color:=RedColor;
//    FLegendItemColorPanel.Material.BackColor.ShadowSize:=3;
//    FLegendItemColorPanel.Material.BackColor.DrawRectSetting.Enabled:=True;
//    FLegendItemColorPanel.Material.BackColor.DrawRectSetting.SizeType:=dpstPixel;
//    FLegendItemColorPanel.Material.BackColor.DrawRectSetting.Height:=16;
//    FLegendItemColorPanel.Material.BackColor.DrawRectSetting.PositionVertType:=dppvtCenter;
//    FLegendItemColorPanel.Material.BackColor.DrawRectSetting.Width:=16;
//    FLegendItemColorPanel.Material.BackColor.DrawRectSetting.PositionHorzType:=dpphtCenter;
    FLegendItemColorPanel.SetBounds(0,0,32,20);
//    FLegendItemColorPanel.Align:=alLeft;
//    FLegendItemColorPanel.Width:=24;



    //分类
    FLegendCategoryPanel:=TSkinLabel.Create(FLegendItemDesignerPanel);
    FLegendCategoryPanel.SkinControlType;
    FLegendCategoryPanel.SelfOwnMaterial;
    FLegendCategoryPanel.Parent:=FLegendItemDesignerPanel;
//    FLegendCategoryPanel.Align:=alTop;
    FLegendCategoryPanel.BindItemFieldName:='ItemCaption';
    FLegendCategoryPanel.Material.IsTransparent:=True;
    FLegendCategoryPanel.Material.BackColor.FillColor.Color:=RedColor;
    FLegendCategoryPanel.Material.BackColor.IsFill:=False;
//    FLegendCategoryPanel.AlignWithMargins:=True;
//    FLegendCategoryPanel.Margins.SetBounds(5,5,5,5);
    FLegendCategoryPanel.Material.DrawCaptionParam.FontSize:=10;
    FLegendCategoryPanel.Material.DrawCaptionParam.FontVertAlign:=TFontVertAlign.fvaCenter;

    {$IFDEF VCL}
    FLegendCategoryPanel.Anchors:=[akLeft,akRight,akTop];
    {$ENDIF}
    {$IFDEF FMX}
    FLegendCategoryPanel.Anchors:=[TAnchorKind.akLeft,TAnchorKind.akRight,TAnchorKind.akTop];
    {$ENDIF}

    FLegendCategoryPanel.SetBounds(FLegendItemColorPanel.Left+FLegendItemColorPanel.Width+5,FLegendItemColorPanel.Top,FLegendItemDesignerPanel.Width-FLegendItemColorPanel.Width-5,20);
//    FLegendCategoryPanel.Prop.AutoSize:=True;
//    FLegendItemColorPanel.Align:=alClient;



//    //值
//    FTooltipItemValuePanel:=TSkinLabel.Create(FLegendItemDesignerPanel);
//    FTooltipItemValuePanel.SkinControlType;
//    FTooltipItemValuePanel.SelfOwnMaterial;
//    FTooltipItemValuePanel.Parent:=FLegendItemDesignerPanel;
////    FTooltipItemValuePanel.Align:=alTop;
//    FTooltipItemValuePanel.BindItemFieldName:='ItemDetail1';
//    FTooltipItemValuePanel.Material.IsTransparent:=True;
//    FTooltipItemValuePanel.Material.BackColor.FillColor.Color:=RedColor;
//    FTooltipItemValuePanel.Material.BackColor.IsFill:=False;
////    FTooltipItemValuePanel.AlignWithMargins:=True;
////    FTooltipItemValuePanel.Margins.SetBounds(5,5,5,5);
//    FTooltipItemValuePanel.Material.DrawCaptionParam.FontSize:=10;
//    FTooltipItemValuePanel.Material.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaRight;
//    FTooltipItemValuePanel.Material.DrawCaptionParam.FontVertAlign:=TFontVertAlign.fvaCenter;
//    FTooltipItemValuePanel.Anchors:=[akLeft,akRight];
//    FTooltipItemValuePanel.SetBounds(FTooltipItemColorPanel.Left+FTooltipItemColorPanel.Width+5,FTooltipItemColorPanel.Top,FTooltipSeriesCaptionLabel.Width-FTooltipItemColorPanel.Width-5,24);
////    FTooltipItemValuePanel.Prop.AutoSize:=True;



  end;


end;

procedure TVirtualChartProperties.CreateTooltipItemDesignerPanel;
begin
  if FTooltipItemStyle='' then
  begin
      FTooltipItemDesignerPanel:=TSkinItemDesignerPanel.Create(nil);
      FTooltipItemDesignerPanel.SkinControlType;
      FTooltipItemDesignerPanel.SelfOwnMaterial;

      {$IFDEF VCL}
      FTooltipItemDesignerPanel.Material.IsTransparent:=True;
      {$ENDIF}
      {$IFDEF FMX}
      FTooltipItemDesignerPanel.Material.IsTransparent:=False;
      FTooltipItemDesignerPanel.Stored:=False;
      {$ENDIF}

      FTooltipItemDesignerPanel.Material.BackColor.IsFill:=True;
      FTooltipItemDesignerPanel.Material.BackColor.FillColor.Color:=WhiteColor;
      FTooltipItemDesignerPanel.Material.BackColor.ShadowSize:=8;
      FTooltipItemDesignerPanel.Material.BackColor.IsRound:=True;

      FTooltipItemDesignerPanel.Material.BackColor.BorderWidth:=1;
//      FTooltipItemDesignerPanel.Parent:=TParentControl(Self.FSkinControl);
//      FTooltipItemDesignerPanel.Visible:=False;

  //    FTooltipItemDesignerPanel.Padding.SetBounds(Ceil(FTooltipItemDesignerPanel.Material.BackColor.ShadowSize),
  //                                    Ceil(FTooltipItemDesignerPanel.Material.BackColor.ShadowSize),
  //                                    Ceil(FTooltipItemDesignerPanel.Material.BackColor.ShadowSize),
  //                                    Ceil(FTooltipItemDesignerPanel.Material.BackColor.ShadowSize));

      FTooltipItemDesignerPanel.Width:=150;
      {$IFDEF VCL}
      FTooltipItemDesignerPanel.Height:=80;
      {$ENDIF}
      {$IFDEF FMX}
      FTooltipItemDesignerPanel.Height:=60;
      {$ENDIF}


      //图表项名称
      FTooltipSeriesCaptionLabel:=TSkinLabel.Create(FTooltipItemDesignerPanel);
      FTooltipSeriesCaptionLabel.SkinControlType;
      FTooltipSeriesCaptionLabel.SelfOwnMaterial;
      FTooltipSeriesCaptionLabel.Parent:=FTooltipItemDesignerPanel;
  //    FTooltipSeriesCaptionLabel.Align:=alTop;
      FTooltipSeriesCaptionLabel.BindItemFieldName:='ItemCaption';
      FTooltipSeriesCaptionLabel.Material.IsTransparent:=True;
      FTooltipSeriesCaptionLabel.Material.BackColor.FillColor.Color:=RedColor;
      FTooltipSeriesCaptionLabel.Material.BackColor.IsFill:=False;
  //    FTooltipSeriesCaptionLabel.AlignWithMargins:=True;
  //    FTooltipSeriesCaptionLabel.Margins.SetBounds(5,5,5,5);
      {$IFDEF VCL}
      FTooltipSeriesCaptionLabel.Material.DrawCaptionParam.FontSize:=8;
      FTooltipSeriesCaptionLabel.Anchors:=[akLeft,akRight];
      FTooltipSeriesCaptionLabel.SetBounds(10,10,FTooltipItemDesignerPanel.Width-10-10,20);
      {$ENDIF}
      {$IFDEF FMX}
      FTooltipSeriesCaptionLabel.Material.DrawCaptionParam.FontSize:=10;
      FTooltipSeriesCaptionLabel.Anchors:=[TAnchorKind.akLeft,TAnchorKind.akRight];
      FTooltipSeriesCaptionLabel.SetBounds(5,5,FTooltipItemDesignerPanel.Width-5-5,20);
      {$ENDIF}



      //数据项的颜色,要圆形
      FTooltipItemColorPanel:=TSkinPanel.Create(FTooltipItemDesignerPanel);
      FTooltipItemColorPanel.SkinControlType;
      FTooltipItemColorPanel.SelfOwnMaterial;
      FTooltipItemColorPanel.Parent:=FTooltipItemDesignerPanel;
      FTooltipItemColorPanel.BindItemFieldName:='ItemColor';
      {$IFDEF VCL}
      FTooltipItemColorPanel.Material.IsTransparent:=True;
      {$ENDIF}
      {$IFDEF FMX}
      FTooltipItemColorPanel.Material.IsTransparent:=False;
      {$ENDIF}
      FTooltipItemColorPanel.Material.BackColor.IsFill:=True;
      FTooltipItemColorPanel.Material.BackColor.IsRound:=True;
      FTooltipItemColorPanel.Material.BackColor.RoundWidth:=-1;
      FTooltipItemColorPanel.Material.BackColor.RoundHeight:=-1;
      FTooltipItemColorPanel.Material.BackColor.Color:=RedColor;
//      FTooltipItemColorPanel.Material.BackColor.ShadowSize:=3;
  //    FTooltipItemColorPanel.Material.BackColor.DrawRectSetting.Enabled:=True;
  //    FTooltipItemColorPanel.Material.BackColor.DrawRectSetting.SizeType:=dpstPixel;
  //    FTooltipItemColorPanel.Material.BackColor.DrawRectSetting.Height:=16;
  //    FTooltipItemColorPanel.Material.BackColor.DrawRectSetting.PositionVertType:=dppvtCenter;
  //    FTooltipItemColorPanel.Material.BackColor.DrawRectSetting.Width:=16;
  //    FTooltipItemColorPanel.Material.BackColor.DrawRectSetting.PositionHorzType:=dpphtCenter;
      {$IFDEF VCL}
      FTooltipItemColorPanel.SetBounds(FTooltipSeriesCaptionLabel.Left,
                                      FTooltipSeriesCaptionLabel.Top+FTooltipSeriesCaptionLabel.Height+5,
                                      24,24);
      {$ENDIF}
      {$IFDEF FMX}
      FTooltipItemColorPanel.SetBounds(FTooltipSeriesCaptionLabel.Left,
                                      FTooltipSeriesCaptionLabel.Top+FTooltipSeriesCaptionLabel.Height+5,
                                      20,20);
      {$ENDIF}


      //分类
      FTooltipCategoryPanel:=TSkinLabel.Create(FTooltipItemDesignerPanel);
      FTooltipCategoryPanel.SkinControlType;
      FTooltipCategoryPanel.SelfOwnMaterial;
      FTooltipCategoryPanel.Parent:=FTooltipItemDesignerPanel;
  //    FTooltipCategoryPanel.Align:=alTop;
      FTooltipCategoryPanel.BindItemFieldName:='ItemDetail';
      FTooltipCategoryPanel.Material.IsTransparent:=True;
      FTooltipCategoryPanel.Material.BackColor.FillColor.Color:=RedColor;
      FTooltipCategoryPanel.Material.BackColor.IsFill:=False;
  //    FTooltipCategoryPanel.AlignWithMargins:=True;
  //    FTooltipCategoryPanel.Margins.SetBounds(5,5,5,5);
      FTooltipCategoryPanel.Material.DrawCaptionParam.FontVertAlign:=TFontVertAlign.fvaCenter;
      {$IFDEF VCL}
      FTooltipCategoryPanel.Material.DrawCaptionParam.FontSize:=8;
      FTooltipCategoryPanel.Anchors:=[akLeft,akRight];
      {$ENDIF}
      {$IFDEF FMX}
      FTooltipCategoryPanel.Material.DrawCaptionParam.FontSize:=10;
      FTooltipCategoryPanel.Anchors:=[TAnchorKind.akLeft,TAnchorKind.akRight];
      {$ENDIF}
      FTooltipCategoryPanel.SetBounds(FTooltipItemColorPanel.Left+FTooltipItemColorPanel.Width+5,
                                      FTooltipItemColorPanel.Top,
                                      FTooltipSeriesCaptionLabel.Width-FTooltipItemColorPanel.Width-5,
                                      FTooltipItemColorPanel.Height);
  //    FTooltipCategoryPanel.Prop.AutoSize:=True;



      //值
      FTooltipItemValuePanel:=TSkinLabel.Create(FTooltipItemDesignerPanel);
      FTooltipItemValuePanel.SkinControlType;
      FTooltipItemValuePanel.SelfOwnMaterial;
      FTooltipItemValuePanel.Parent:=FTooltipItemDesignerPanel;
  //    FTooltipItemValuePanel.Align:=alTop;
      FTooltipItemValuePanel.BindItemFieldName:='ItemDetail1';
      FTooltipItemValuePanel.Material.IsTransparent:=True;
      FTooltipItemValuePanel.Material.BackColor.FillColor.Color:=RedColor;
      FTooltipItemValuePanel.Material.BackColor.IsFill:=False;
  //    FTooltipItemValuePanel.AlignWithMargins:=True;
  //    FTooltipItemValuePanel.Margins.SetBounds(5,5,5,5);
      FTooltipItemValuePanel.Material.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaRight;
      FTooltipItemValuePanel.Material.DrawCaptionParam.FontVertAlign:=TFontVertAlign.fvaCenter;
      {$IFDEF VCL}
      FTooltipItemValuePanel.Material.DrawCaptionParam.FontSize:=8;
      FTooltipItemValuePanel.Anchors:=[akLeft,akRight];
      {$ENDIF}
      {$IFDEF FMX}
      FTooltipItemValuePanel.Material.DrawCaptionParam.FontSize:=10;
      FTooltipItemValuePanel.Anchors:=[TAnchorKind.akLeft,TAnchorKind.akRight];
      {$ENDIF}
      FTooltipItemValuePanel.SetBounds(FTooltipItemColorPanel.Left+FTooltipItemColorPanel.Width+5,
                                        FTooltipItemColorPanel.Top,
                                        FTooltipSeriesCaptionLabel.Width-FTooltipItemColorPanel.Width-5,
                                        24);
  //    FTooltipItemValuePanel.Prop.AutoSize:=True;



  end;
  
end;

destructor TVirtualChartProperties.Destroy;
begin

  FreeAndNil(FTooltipItemDesignerPanel);
  FreeAndNil(FLegendItemDesignerPanel);

  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
  FLegendSkinListView.Properties.FItems:=nil;
  FreeAndNil(FLegendSkinListView);
  {$ENDIF}


//  FXAxisSkinListBox.Properties.FItems:=nil;
  FreeAndNil(FXAxisSkinListBox);

//  FYAxisSkinListBox.Properties.FItems:=nil;
  FreeAndNil(FYAxisSkinListBox);





//  FreeAndNil(FXAxis);
//  FreeAndNil(FYAxis);
  FreeAndNil(FSeriesList);


  inherited;
end;

procedure TVirtualChartProperties.DoLegendListViewMouseOverItemChange(Sender: TObject);
begin
  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
  //提示Item鼠标停靠状态改变的时候,相应的扇形也鼠标停靠
  if Self.FLegendSkinListView.Prop.MouseOverItem<>nil then
  begin
    Self.FSeriesList[0].FListLayoutsManager.MouseOverItem:=Self.FSeriesList[0].FListLayoutsManager.GetVisibleItem(Self.FLegendSkinListView.Prop.MouseOverItem.Index);
  end
  else
  begin
    Self.FSeriesList[0].FListLayoutsManager.MouseOverItem:=nil;
  end;

  //if  then
  {$ENDIF}

end;

procedure TVirtualChartProperties.DoShowTooltip(ATooltipDataItem: TVirtualChartSeriesDataItem; X, Y: Double);
var
  ANewLeft,ANewTop:Double;
  ASeries:TVirtualChartSeries;
begin

  if Self.FTooltipItemDesignerPanel=nil then
  begin
    Self.CreateTooltipItemDesignerPanel;
  end;



  if (Self.FTooltipItemDesignerPanel<>nil) then
  begin



      ASeries:=TVirtualChartSeriesDataItems(ATooltipDataItem.Owner).FSeries;


      if Self.FLastTooltipDataItem<>ATooltipDataItem then
      begin
        FLastTooltipDataItem:=ATooltipDataItem;

        //需要重新赋值
        //图表名称
        //ATooltipDataItem.Caption:=ASeries.Caption;
        Self.FTooltipSeriesCaptionLabel.Caption:=ASeries.Caption;
        //分类名称
        //ATooltipDataItem.Detail:=Self.AxisItems[ATooltipDataItem.Index].Caption;
//        Self.FTooltipCategoryPanel.Caption:=Self.AxisItems[ATooltipDataItem.Index].Caption;
        Self.FTooltipCategoryPanel.Caption:=ATooltipDataItem.Caption;
        //值
        //ATooltipDataItem.Detail1:=FloatToStr(ATooltipDataItem.Value);
        Self.FTooltipItemValuePanel.Caption:=FloatToStr(ATooltipDataItem.Value);
        //设置颜色
//        Self.T.Caption:=ASeries.Caption;

        //FTooltipItemDesignerPanel.Prop.SetControlsValueByItem(nil,ATooltipDataItem,False);

        FTooltipItemColorPanel.Material.BackColor.FillColor.Color:=ASeries.FDrawer.GetDataItemColor(FLastTooltipDataItem);
        Self.FTooltipItemDesignerPanel.Material.BackColor.BorderColor.Color:=ASeries.FDrawer.GetDataItemColor(FLastTooltipDataItem);

        //计算宽度
        FTooltipItemDesignerPanel.Width:=Ceil(10+24+5
                                            +GetStringWidth(Self.FTooltipCategoryPanel.Caption,Self.FTooltipCategoryPanel.CurrentUseMaterialToDefault.DrawCaptionParam.FontSize)
                                            +10
                                            +GetStringWidth(FloatToStr(ATooltipDataItem.Value),FTooltipItemValuePanel.CurrentUseMaterialToDefault.DrawCaptionParam.FontSize)
                                            +10+5);

        FTooltipItemValuePanel.SetBounds(FTooltipItemColorPanel.Left+FTooltipItemColorPanel.Width+5,
                                          FTooltipItemColorPanel.Top,
                                          FTooltipItemDesignerPanel.Width-FTooltipItemValuePanel.Left-10,
                                          24);
      end;


      ANewLeft:=(X+10);
      ANewTop:=(Y+10);


      //坐标轴不能被挡住,提示框也不能被控件盖往
      //不能太右边,会被控件盖住
      //默认是在鼠标的右下角的
      if ((ANewLeft+FTooltipItemDesignerPanel.Width)>Self.FSkinControl.Width) then
      begin
        //处理方式,看看左边有没有空间
        ANewLeft:=X-FTooltipItemDesignerPanel.Width-10;
      end;


      //不能太下面，会被控件盖住
      if ((ANewTop+FTooltipItemDesignerPanel.Height)>Self.FSkinControl.Height) then
      begin
        //看看上面有没有空间,
        ANewTop:=(Y-FTooltipItemDesignerPanel.Height-10);

      end;

      //位置移大一点再刷新，不然的话，刷新太频繁，看起来卡
      if (ABS(FTooltipItemDesignerPanel.Left-ANewLeft)>3) or (ABS(FTooltipItemDesignerPanel.Top-ANewTop)>3) then
      begin

        FTooltipItemDesignerPanel.Left:=Ceil(ANewLeft);
        FTooltipItemDesignerPanel.Top:=Ceil(ANewTop);

        FTooltipItemDesignerPanelVisible:=True;
    //    FTooltipItemDesignerPanel.Visible:=True;
    //    FTooltipItemDesignerPanel.Invalidate;
        Invalidate;
      end;


  end;

end;

procedure TVirtualChartProperties.EndUpdate;
begin
  Self.FXAxisSkinListBox.Prop.Items.EndUpdate;
  Self.FYAxisSkinListBox.Prop.Items.EndUpdate;
  if Self.FIsChanging=1 then
  begin
    //需要重新生成数据项的路径
    Self.FSeriesList.FIsGeneratedDrawPathList:=False;
  end;
  inherited;
end;

//procedure TVirtualChartProperties.GenerateDrawPathList;
//var
//  I: Integer;
//begin
//  //先从简单的做，横排柱形
//
//
//
//
//  for I := 0 to Self.FSeriesList.Count-1 do
//  begin
//    Self.FSeriesList[I].GenerateDrawPathList();
//  end;
//
//
//end;

function TVirtualChartProperties.GetComponentClassify: String;
begin
  Result:='SkinVirtualChart';
end;

function TVirtualChartProperties.GetAxisItems: TSkinListBoxItems;
begin
  Result:=FXAxisSkinListBox.Prop.Items;
end;

function TVirtualChartProperties.GetYAxisItems: TSkinListBoxItems;
begin
  Result:=FYAxisSkinListBox.Prop.Items;
end;

//function TVirtualChartProperties.GetInteractiveItem: TSkinItem;
//begin
//  Result:=TSkinItem(Inherited InteractiveItem);
//end;
//
//function TVirtualChartProperties.GetItems: TSkinVirtualChartItems;
//begin
//  Result:=TSkinVirtualChartItems(FItems);
//end;
//
//function TVirtualChartProperties.GetItemsClass: TBaseSkinItemsClass;
//begin
//  Result:=TSkinVirtualChartItems;
//end;
//
//function TVirtualChartProperties.GetListLayoutsManager: TSkinVirtualChartLayoutsManager;
//begin
//  Result:=TSkinVirtualChartLayoutsManager(Self.FListLayoutsManager);
//end;
//
//function TVirtualChartProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
//begin
//  Result:=TSkinVirtualChartLayoutsManager;
//end;
//
//procedure TVirtualChartProperties.SetItems(const Value: TSkinVirtualChartItems);
//begin
//  Inherited SetItems(Value);
//end;
//
//function TVirtualChartProperties.GetMouseDownItem: TSkinItem;
//begin
//  Result:=TSkinItem(Inherited MouseDownItem);
//end;
//
//function TVirtualChartProperties.GetMouseOverItem: TSkinItem;
//begin
//  Result:=TSkinItem(Inherited MouseOverItem);
//end;
//
//function TVirtualChartProperties.GetPanDragItem: TSkinItem;
//begin
//  Result:=TSkinItem(Inherited PanDragItem);
//end;
//
//function TVirtualChartProperties.GetSelectedItem: TSkinItem;
//begin
//  Result:=TSkinItem(Inherited SelectedItem);
//end;
//
//procedure TVirtualChartProperties.SetMouseDownItem(Value: TSkinItem);
//begin
//  Inherited MouseDownItem:=Value;
//end;
//
//procedure TVirtualChartProperties.SetMouseOverItem(Value: TSkinItem);
//begin
//  Inherited MouseOverItem:=Value;
//end;
//
//procedure TVirtualChartProperties.SetSelectedItem(Value: TSkinItem);
//begin
//  Inherited SelectedItem:=Value;
//end;

procedure TVirtualChartProperties.SetSeriesList(
  const Value: TVirtualChartSeriesList);
begin
  FSeriesList.Assign(Value);
end;

procedure TVirtualChartProperties.SetAxisItems(const Value: TSkinListBoxItems);
begin
  FXAxisSkinListBox.Prop.Items:=TSkinListBoxItems(Value);
end;

procedure TVirtualChartProperties.SetXAxisType(const Value: TSkinChartAxisType);
begin
  FXAxisType:=Value;
end;

procedure TVirtualChartProperties.SetYAxisItems(const Value: TSkinListBoxItems);
begin
  FYAxisSkinListBox.Prop.Items:=TSkinListBoxItems(Value);

end;

procedure TVirtualChartProperties.SetYAxisType(const Value: TSkinChartAxisType);
begin
  FYAxisType:=Value;
end;

//procedure TVirtualChartProperties.SetXAxis(const Value: TVirtualChartAxis);
//begin
//  FXAxis.Assign(Value);
//end;
//
//procedure TVirtualChartProperties.SetYAxis(const Value: TVirtualChartAxis);
//begin
//  FYAxis.Assign(Value);
//end;

//procedure TVirtualChartProperties.SetPanDragItem(Value: TSkinItem);
//begin
//  Inherited PanDragItem:=Value;
//end;

{ TSkinVirtualChartDefaultType }

function TSkinVirtualChartDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinVirtualChart,Self.FSkinVirtualChartIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinVirtualChart Interface');
    end;
  end;
end;

procedure TSkinVirtualChartDefaultType.CustomMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Double);
var
  I: Integer;
begin
  inherited;

  for I := 0 to FSkinVirtualChartIntf.Properties.FSeriesList.Count-1 do
  begin
    FSkinVirtualChartIntf.Properties.FSeriesList[I].FListLayoutsManager.CustomMouseDown(Button,Shift,X,Y);
  end;

end;

procedure TSkinVirtualChartDefaultType.CustomMouseEnter;
var
  I: Integer;
begin
  inherited;

  for I := 0 to FSkinVirtualChartIntf.Properties.FSeriesList.Count-1 do
  begin
    FSkinVirtualChartIntf.Properties.FSeriesList[I].FListLayoutsManager.CustomMouseEnter;
  end;


end;

procedure TSkinVirtualChartDefaultType.CustomMouseLeave;
var
  I: Integer;
begin
  inherited;

  for I := 0 to FSkinVirtualChartIntf.Properties.FSeriesList.Count-1 do
  begin
    FSkinVirtualChartIntf.Properties.FSeriesList[I].FListLayoutsManager.CustomMouseLeave;
  end;


end;

procedure TSkinVirtualChartDefaultType.CustomMouseMove(Shift: TShiftState; X,
  Y: Double);
var
  I: Integer;
  AMouseOverDataItem:TVirtualChartSeriesDataItem;
begin
  inherited;

  AMouseOverDataItem:=nil;
  for I := 0 to FSkinVirtualChartIntf.Properties.FSeriesList.Count-1 do
  begin
    //设置数据项是否鼠标停靠
    FSkinVirtualChartIntf.Properties.FSeriesList[I].FListLayoutsManager.CustomMouseMove(Shift,X,Y);
    if FSkinVirtualChartIntf.Properties.FSeriesList[I].FListLayoutsManager.MouseOverItem<>nil then
    begin
      AMouseOverDataItem:=TVirtualChartSeriesDataItem(
        FSkinVirtualChartIntf.Properties.FSeriesList[I].FListLayoutsManager.MouseOverItem.GetObject);
    end;
  end;

  if (AMouseOverDataItem<>nil) and Self.FSkinVirtualChartIntf.Properties.ShowTooltip then
  begin
      //显示数据项提示框
      Self.FSkinVirtualChartIntf.Properties.DoShowTooltip(AMouseOverDataItem,X,Y);
  end
  else
  begin
      //隐藏数据项提示框
      if Self.FSkinVirtualChartIntf.Properties.FTooltipItemDesignerPanel<>nil then
      begin
        Self.FSkinVirtualChartIntf.Properties.FTooltipItemDesignerPanelVisible:=False;
      end;

  end;

end;

procedure TSkinVirtualChartDefaultType.CustomMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Double);
var
  I: Integer;
begin
  inherited;

  for I := 0 to FSkinVirtualChartIntf.Properties.FSeriesList.Count-1 do
  begin
    FSkinVirtualChartIntf.Properties.FSeriesList[I].FListLayoutsManager.CustomMouseUp(Button,Shift,X,Y);
  end;

end;

function TSkinVirtualChartDefaultType.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData): Boolean;
var
  I: Integer;
  ASeries:TVirtualChartSeries;
  AItemPaintData:TPaintData;
  AItemDesignerPanel:TSkinItemDesignerPanel;
begin
  Inherited;

  if not FSkinVirtualChartIntf.Properties.FSeriesList.FIsGeneratedDrawPathList then
  begin
    FSkinVirtualChartIntf.Properties.FSeriesList.FIsGeneratedDrawPathList:=True;
    FSkinVirtualChartIntf.Properties.FSeriesList.GenerateDrawPathList(ADrawRect);
  end;


  //绘制坐标轴,只需要画一次就可以了
  for I := 0 to FSkinVirtualChartIntf.Properties.FSeriesList.Count-1 do
  begin
    ASeries:=FSkinVirtualChartIntf.Properties.FSeriesList[I];
    if (ASeries.FChartType=sctBar)
      or (ASeries.FChartType=sctLine) then
    begin
      if ASeries.FDrawer<>nil then
      begin
        ASeries.FDrawer.PaintAxis(ACanvas,ASkinMaterial,ADrawRect,APaintData,ASeries.FPathDrawRect);
      end;
      Break;
    end;
  end;


  //绘制图表项列表
  for I := 0 to FSkinVirtualChartIntf.Properties.FSeriesList.Count-1 do
  begin
    ASeries:=FSkinVirtualChartIntf.Properties.FSeriesList[I];
    ASeries.CustomPaint(ACanvas,ASkinMaterial,ADrawRect,APaintData);
  end;



  //绘制提示框
  if Self.FSkinVirtualChartIntf.Properties.FTooltipItemDesignerPanelVisible then
  begin
    AItemDesignerPanel:=Self.FSkinVirtualChartIntf.Properties.FTooltipItemDesignerPanel;

    //绘制ItemDesignerPanel的背景
    AItemPaintData:=GlobalNullPaintData;
    AItemPaintData.IsDrawInteractiveState:=True;
    AItemPaintData.IsInDrawDirectUI:=True;
    AItemDesignerPanel.SkinControlType.Paint(ACanvas,
                          AItemDesignerPanel.SkinControlType.GetPaintCurrentUseMaterial,
                          RectF(AItemDesignerPanel.Left,AItemDesignerPanel.Top,AItemDesignerPanel.Left+AItemDesignerPanel.Width,AItemDesignerPanel.Top+AItemDesignerPanel.Height),
                          AItemPaintData);
    //绘制ItemDesignerPanel的子控件
    AItemPaintData:=GlobalNullPaintData;
    AItemPaintData.IsDrawInteractiveState:=True;
    AItemPaintData.IsInDrawDirectUI:=True;
    AItemDesignerPanel.SkinControlType.DrawChildControls(ACanvas,
                          //Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect,
                          RectF(AItemDesignerPanel.Left,AItemDesignerPanel.Top,AItemDesignerPanel.Left+AItemDesignerPanel.Width,AItemDesignerPanel.Top+AItemDesignerPanel.Height),
                          AItemPaintData,
                          ADrawRect);
  end;


end;

procedure TSkinVirtualChartDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinVirtualChartIntf:=nil;
end;

function TSkinVirtualChartDefaultType.GetSkinMaterial: TSkinVirtualChartDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinVirtualChartDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinVirtualChartDefaultType.SizeChanged;
begin
  inherited;

  if (FSkinVirtualChartIntf<>nil)
    and (FSkinVirtualChartIntf.Properties<>nil)
    and (FSkinVirtualChartIntf.Properties.FSeriesList<>nil) then
  begin
    FSkinVirtualChartIntf.Properties.FSeriesList.FIsGeneratedDrawPathList:=False;
  end;

end;

{ TSkinVirtualChartItems }


function TSkinVirtualChartItems.Add: TSkinVirtualChartItem;
begin
  Result:=TSkinVirtualChartItem(Inherited Add);
end;

//procedure TSkinVirtualChartItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TSkinVirtualChartItem;
//end;

function TSkinVirtualChartItems.Insert(Index:Integer): TSkinVirtualChartItem;
begin
  Result:=TSkinVirtualChartItem(Inherited Insert(Index));
end;

procedure TSkinVirtualChartItems.SetItem(Index: Integer;const Value: TSkinVirtualChartItem);
begin
  Inherited Items[Index]:=Value;
end;

//function TSkinVirtualChartItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=SkinItemClass.Create;//(Self);
//end;

function TSkinVirtualChartItems.GetItem(Index: Integer): TSkinVirtualChartItem;
begin
  Result:=TSkinVirtualChartItem(Inherited Items[Index]);
end;

function TSkinVirtualChartItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TSkinVirtualChartItem;
end;

{ TSkinVirtualChart }

function TSkinVirtualChart.Material:TSkinVirtualChartDefaultMaterial;
begin
  Result:=TSkinVirtualChartDefaultMaterial(SelfOwnMaterial);
end;

function TSkinVirtualChart.SelfOwnMaterialToDefault:TSkinVirtualChartDefaultMaterial;
begin
  Result:=TSkinVirtualChartDefaultMaterial(SelfOwnMaterial);
end;

function TSkinVirtualChart.CurrentUseMaterialToDefault:TSkinVirtualChartDefaultMaterial;
begin
  Result:=TSkinVirtualChartDefaultMaterial(CurrentUseMaterial);
end;

procedure TSkinVirtualChart.DoCustomSkinMaterialChange(Sender: TObject);
begin
  inherited;
  Self.Prop.FSeriesList.FIsGeneratedDrawPathList:=False;
end;

function TSkinVirtualChart.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TVirtualChartProperties;
end;

function TSkinVirtualChart.GetVirtualChartProperties: TVirtualChartProperties;
begin
  Result:=TVirtualChartProperties(Self.FProperties);
end;

procedure TSkinVirtualChart.SetVirtualChartProperties(Value: TVirtualChartProperties);
begin
  Self.FProperties.Assign(Value);
end;






//{ TVirtualChartAxis }
//
//constructor TVirtualChartAxis.Create;
//begin
//  FItems:=TVirtualChartAxisDataItems.Create;
//
//end;
//
//destructor TVirtualChartAxis.Destroy;
//begin
//  FreeAndNil(FItems);
//  inherited;
//end;
//
//procedure TVirtualChartAxis.SetItems(const Value: TVirtualChartAxisDataItems);
//begin
//  FItems.Assign(Value);
//end;

{ TVirtualChartSeries }

constructor TVirtualChartSeries.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDataItems:=TVirtualChartSeriesDataItems.Create();
  FDataItems.FSeries:=Self;

//  FDrawPathItems:=TVirtualChartSeriesDataDrawPathItems.Create();
//  FSkinVirtualChartIntf:=ASkinVirtualChartIntf;
  FListLayoutsManager:=TSkinListLayoutsManager.Create(FDataItems);
  FListLayoutsManager.OnItemPropChange:=DoItemPropChange;
end;

function TVirtualChartSeries.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData): Boolean;
//  APathDrawRect:TRectF;
begin
  //生成需要绘制的Path列表
//  if not FIsGeneratedDrawPathList then
//  begin
//    FIsGeneratedDrawPathList:=True;
//    Self.GenerateDrawPathList(ADrawRect);
//  end;

  if Self.FDrawer<>nil then
  begin
    Self.FDrawer.CustomPaint(ACanvas,ASkinMaterial,ADrawRect,APaintData,FPathDrawRect);
  end;


end;

destructor TVirtualChartSeries.Destroy;
begin
  FreeAndNil(FListLayoutsManager);
  FreeAndNil(FDataItems);
  FreeAndNil(FDrawer);
//  FreeAndNil(FDrawPathItems);
  inherited;
end;

procedure TVirtualChartSeries.DoItemPropChange(Sender: TObject);
begin
//  TVirtualChartSeriesList(Self.Collection).DoChange;

  //这里只是Item的MouseOver状态改变,不需要重新计算绘制路径
  TVirtualChartSeriesList(Self.Collection).FSkinVirtualChartIntf.Properties.Invalidate;
end;

procedure TVirtualChartSeries.GenerateDrawPathList(const ADrawRect:TRectF);
//var
//  APathDrawRect:TRectF;
begin
//  FDrawPathItems.Clear;

  case Self.ChartType of
    sctBar:
    begin
      if (FDrawer=nil) or not (FDrawer is TVirtualChartSeriesBarDrawer) then
      begin
        FreeAndNil(FDrawer);
        FDrawer:=TVirtualChartSeriesBarDrawer.Create(Self);
      end;

    end;
    sctLine:
    begin
      if (FDrawer=nil) or not (FDrawer is TVirtualChartSeriesLineDrawer) then
      begin
        FreeAndNil(FDrawer);
        FDrawer:=TVirtualChartSeriesLineDrawer.Create(Self);
      end;

    end;
    sctPie:
    begin
      if (FDrawer=nil) or not (FDrawer is TVirtualChartSeriesPieDrawer) then
      begin
        FreeAndNil(FDrawer);
        FDrawer:=TVirtualChartSeriesPieDrawer.Create(Self);
      end;

    end;
  end;

  if FDrawer<>nil then
  begin
    FPathDrawRect:=FDrawer.GetPathDrawRect(ADrawRect);
    FDrawer.GenerateDrawPathList(FPathDrawRect);
  end;

end;

procedure TVirtualChartSeries.GetMinMaxValue(var AMinValue:Double;var AMaxValue:Double;var ASumValue:Double);
var
  I: Integer;
begin
  AMinValue:=0;

  ASumValue:=0;
  AMaxValue:=0;
  if Self.FDataItems.Count>0 then
  begin
//    AMinValue:=FDataItems[0].Value;


    AMaxValue:=FDataItems[0].Value;
    ASumValue:=FDataItems[0].Value;


    for I := 1 to FDataItems.Count-1 do
    begin
      if FDataItems[I].Value>AMaxValue then
      begin
        AMaxValue:=FDataItems[I].Value;
      end;

      ASumValue:=ASumValue+FDataItems[I].Value;

//      if FDataItems[I].Value<AMinValue then
//      begin
//        AMinValue:=FDataItems[I].Value;
//      end;
    end;

  end;
end;

procedure TVirtualChartSeries.SetCaption(const Value: String);
begin
  if FCaption<>Value then
  begin
    FCaption := Value;
    TVirtualChartSeriesList(Self.Collection).DoChange;
  end;
end;

procedure TVirtualChartSeries.SetChartType(const Value: TSkinChartType);
begin
  if FChartType<> Value then
  begin
    FChartType := Value;
    TVirtualChartSeriesList(Self.Collection).DoChange;
  end;
end;

procedure TVirtualChartSeries.SetDataItems(const Value: TVirtualChartSeriesDataItems);
begin
  FDataItems.Assign(Value);
end;

{ TVirtualChartSeriesList }
function log(n:Real):Real;
begin
    Result := Ln(n)/ln(10.0);
end;

function standard( cormax:double;  var cormin:double; var cornumber:Integer;var keduwidth:Double;var realmaxmoney: Double;var realminmoney: Double):Boolean;
var
         //realmaxmoney,
//         realminmoney,
         corstep, tmpstep, temp:double;
         tmp_cor_number:Integer;
         nummoney:Double;
         text:String;
         I:Integer;
begin
  Result:=False;

//        Log.d("yangbin---", "cormax:--" + cormax + "--cormin:--" + cormin + "--cornumber:--" + cornumber);
//        realmaxmoney = Double.valueOf(cormax);
//        realminmoney = Double.valueOf(cormin);
        realmaxmoney := cormax;
        realminmoney := cormin;

        if (cormax <= cormin) then
            Exit;

        corstep := (cormax - cormin) / cornumber;

//        if (Math.pow(10, (int) (Math.log(corstep) / Math.log(10))) = corstep) {
//            temp = Math.pow(10, (int) (Math.log(corstep) / Math.log(10)));
//        } else {
//            temp = Math.pow(10, ((int) (Math.log(corstep) / Math.log(10)) + 1));
//        }
        //(int) (Math.log(corstep) / Math.log(10))
        if (Math.Power(10, Floor(log(corstep) / log(10))) = corstep) then
        begin
            temp := Math.Power(10, Floor(log(corstep) / log(10)));
        end
        else
        begin
            temp := Math.Power(10, (Floor(log(corstep) / log(10)) + 1));
        end;




        tmpstep := corstep / temp;
        //选取规范步长
//        if (tmpstep >= 0 && tmpstep <= 0.1) {
//            tmpstep = 0.1;
//        } else if (tmpstep >= 0.100001 && tmpstep <= 0.2) {
//            tmpstep = 0.2;
//        } else if (tmpstep >= 0.200001 && tmpstep <= 0.25) {
//            tmpstep = 0.25;
//        } else if (tmpstep >= 0.250001 && tmpstep <= 0.5) {
//            tmpstep = 0.5;
//        } else {
//            tmpstep = 1;
//        }

        if (tmpstep >= 0) and (tmpstep <= 0.1) then
        begin
            tmpstep := 0.1;
        end
        else if (tmpstep >= 0.100001) and (tmpstep <= 0.2) then
        begin
            tmpstep := 0.2;
        end
        else if (tmpstep >= 0.200001) and (tmpstep <= 0.25) then
        begin
            tmpstep := 0.25;
        end
        else if (tmpstep >= 0.250001) and (tmpstep <= 0.5) then
        begin
            tmpstep := 0.5;
        end
        else
        begin
            tmpstep := 1;
        end;



        tmpstep := tmpstep * temp;
//        if ((int) (cormin / tmpstep) != (cormin / tmpstep)) {
//            if (cormin < 0) {
//                cormin = (-1) * Math.ceil(Math.abs(cormin / tmpstep)) * tmpstep;
//            } else {
//                cormin = (int) (Math.abs(cormin / tmpstep)) * tmpstep;
//            }
//
//        }
        if (Floor(cormin / tmpstep) <> (cormin / tmpstep)) then
        begin
            if (cormin < 0) then
            begin
                cormin := (-1) * Ceil(abs(cormin / tmpstep)) * tmpstep;
            end
            else
            begin
                cormin := Floor(abs(cormin / tmpstep)) * tmpstep;
            end;

        end;




//        if ((int) (cormax / tmpstep) != (cormax / tmpstep)) {
//            cormax = (int) (cormax / tmpstep + 1) * tmpstep;
//        }
        if (Floor(cormax / tmpstep) <> (cormax / tmpstep)) then
        begin
            cormax := Floor(cormax / tmpstep + 1) * tmpstep;
        end;

        //多出来的刻度,比如我要6个刻度，但是算出来只需要4个，那么多出来的会往底下减，原本从0开始的最小刻度，会变为负数
        tmp_cor_number := Ceil((cormax - cormin) / tmpstep);
//        if (tmp_cor_number < cornumber) {
//            extra_cor_number = cornumber - tmp_cor_number;
//            tmp_cor_number = cornumber;
//            if (extra_cor_number % 2 = 0) {
//                cormax = cormax + tmpstep * (int) (extra_cor_number / 2);
//            } else {
//                cormax = cormax + tmpstep * (int) (extra_cor_number / 2 + 1);
//            }
//            cormin = cormin - tmpstep * (int) (extra_cor_number / 2);
//        }
//        if (tmp_cor_number < cornumber) then
//        begin
//            extra_cor_number := cornumber - tmp_cor_number;
//            tmp_cor_number := cornumber;
//            if ((Floor(extra_cor_number) mod 2) = 0) then
//            begin
//                cormax := cormax + tmpstep * Floor(extra_cor_number / 2);
//            end
//            else
//            begin
//                cormax := cormax + tmpstep * Floor(extra_cor_number / 2 + 1);
//            end;
//            cormin := cormin - tmpstep * Floor(extra_cor_number / 2);
//        end;



        cornumber := tmp_cor_number;

//        double nummoney = 0;
//        String text = "";
//        double keduwidth = (cormax - cormin) / cornumber;
        nummoney := 0;
        text := '';
        keduwidth := (cormax - cormin) / cornumber;

//        for (int i = 1; nummoney < realmaxmoney; i++) {
//            nummoney = keduwidth * i + cormin;
//            text = text + String.valueOf(nummoney) + "---";
//        }
        i := 1;
        while nummoney < realmaxmoney do
        begin
          nummoney := keduwidth * i + cormin;
          text:=text+FloatToStr(nummoney)+'---';
          I:=I+1;
        end;
        

        uBaseLog.HandleException(nil,text);

//        Log.d("yangbin", "cormax---" + cormax + "--cormin--" + cormin + "--cornumber--" + cornumber +
//                        "\n您的坐标依次为:" + text
//        );


  Result:=True;
end;

function TVirtualChartSeriesList.Add: TVirtualChartSeries;
begin
  Result:=TVirtualChartSeries(Inherited Add);
end;

procedure TVirtualChartSeriesList.CalcMinMaxValueAndStep;
var
  I: Integer;
  ASeriesMinValue,ASeriesMaxValue,ASeriesSumValue:Double;
  keduwidth:Double;
//  keduwidth:Double;
  realmaxmoney:Double;
  realminmoney:Double;
  nummoney:Double;
  ACorMinValue:Double;
  ACorMaxValue:Double;
  cornumber:Integer;
begin
  //最小值默认是0
  FMinValue:=0;

  //总和
  FSumValue:=0;

  FMaxValue:=0;
//  FStep:=1;
  if Self.Count>0 then
  begin
    Self.Items[0].GetMinMaxValue(FMinValue,FMaxValue,FSumValue);

    for I := 1 to Count-1 do
    begin
      Self.Items[0].GetMinMaxValue(ASeriesMinValue,ASeriesMaxValue,ASeriesSumValue);

//      if ASeriesMinValue<FMinValue then
//      begin
//        FMinValue:=ASeriesMinValue;
//      end;
      if ASeriesMaxValue<FMaxValue then
      begin
        FMaxValue:=ASeriesMaxValue;
      end;

      FSumValue:=FSumValue+ASeriesSumValue;

    end;

  end;


  ACorMinValue:=FMinValue;
  ACorMaxValue:=FMaxValue;
  cornumber:=6;
  standard(ACorMaxValue,ACorMinValue,cornumber,keduwidth,realmaxmoney,realminmoney);


  //清除坐标系
  Self.FSkinVirtualChartIntf.Properties.YAxisItems.BeginUpdate;
  try
    Self.FSkinVirtualChartIntf.Properties.YAxisItems.Clear();

    nummoney := 0;
    i := 0;//1;
    while nummoney < realmaxmoney do
    begin
      nummoney := keduwidth * i + ACorMinValue;
//      text:=text+FloatToStr(nummoney)+'---';
      Self.FSkinVirtualChartIntf.Properties.YAxisItems.Insert(0).Caption:=FloatToStr(nummoney);
      I:=I+1;
    end;

//    FMinValue:=keduwidth * 1 + ACorMinValue;
    FMinValue:=ACorMinValue;
    FMaxValue:=nummoney;



  finally
    Self.FSkinVirtualChartIntf.Properties.YAxisItems.EndUpdate;
  end;


end;

constructor TVirtualChartSeriesList.Create(ItemClass: TCollectionItemClass;
  ASkinVirtualChartIntf: ISkinVirtualChart);
begin
  Inherited Create(ItemClass);
  FSkinVirtualChartIntf:=ASkinVirtualChartIntf;
end;

procedure TVirtualChartSeriesList.DoChange;
begin
  FIsGeneratedDrawPathList:=False;
  Self.FSkinVirtualChartIntf.Properties.Invalidate;

end;

procedure TVirtualChartSeriesList.GenerateDrawPathList(const ADrawRect: TRectF);
var
  I: Integer;
  ASameCharTypeIndex:Integer;
begin

  Self.CalcMinMaxValueAndStep;

  FLineSeriesCount:=0;
  FPieSeriesCount:=0;
  FBarSeriesCount:=0;

  ASameCharTypeIndex:=0;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FChartType=sctBar then
    begin
      Items[I].FSameCharTypeIndex:=ASameCharTypeIndex;
      Inc(ASameCharTypeIndex);
    end;
  end;
  FBarSeriesCount:=ASameCharTypeIndex;


  ASameCharTypeIndex:=0;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FChartType=sctPie then
    begin
      Items[I].FSameCharTypeIndex:=ASameCharTypeIndex;
      Inc(ASameCharTypeIndex);
    end;
  end;
  FPieSeriesCount:=ASameCharTypeIndex;


  ASameCharTypeIndex:=0;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FChartType=sctLine then
    begin
      Items[I].FSameCharTypeIndex:=ASameCharTypeIndex;
      Inc(ASameCharTypeIndex);
    end;
  end;
  FLineSeriesCount:=ASameCharTypeIndex;


  for I := 0 to Self.Count-1 do
  begin
    Items[I].GenerateDrawPathList(ADrawRect);
  end;


end;

function TVirtualChartSeriesList.GetItem(Index: Integer): TVirtualChartSeries;
begin
  Result:=TVirtualChartSeries(Inherited Items[Index]);
end;

procedure TVirtualChartSeriesList.SetItem(Index: Integer;
  const Value: TVirtualChartSeries);
begin
  Inherited Items[Index]:=Value;
end;

//{ TVirtualChartAxisDataItems }
//
//
//
//function TVirtualChartAxisDataItems.Add: TVirtualChartAxisDataItem;
//begin
//  Result:=TVirtualChartAxisDataItem(Inherited Add);
//end;
//
////procedure TVirtualChartAxisDataItems.InitSkinItemClass;
////begin
////  SkinItemClass:=TVirtualChartAxisDataItem;
////end;
//
//function TVirtualChartAxisDataItems.Insert(Index:Integer): TVirtualChartAxisDataItem;
//begin
//  Result:=TVirtualChartAxisDataItem(Inherited Insert(Index));
//end;
//
//procedure TVirtualChartAxisDataItems.SetItem(Index: Integer;const Value: TVirtualChartAxisDataItem);
//begin
//  Inherited Items[Index]:=Value;
//end;
//
////function TVirtualChartAxisDataItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
////begin
////  Result:=SkinItemClass.Create;//(Self);
////end;
//
//function TVirtualChartAxisDataItems.GetItem(Index: Integer): TVirtualChartAxisDataItem;
//begin
//  Result:=TVirtualChartAxisDataItem(Inherited Items[Index]);
//end;
//
//function TVirtualChartAxisDataItems.GetSkinItemClass: TBaseSkinItemClass;
//begin
//  Result:=TVirtualChartAxisDataItem;
//end;

{ TVirtualChartSeriesDataItems }



function TVirtualChartSeriesDataItems.Add: TVirtualChartSeriesDataItem;
begin
  Result:=TVirtualChartSeriesDataItem(Inherited Add);
end;

//procedure TVirtualChartSeriesDataItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TVirtualChartSeriesDataItem;
//end;

function TVirtualChartSeriesDataItems.Insert(Index:Integer): TVirtualChartSeriesDataItem;
begin
  Result:=TVirtualChartSeriesDataItem(Inherited Insert(Index));
end;

procedure TVirtualChartSeriesDataItems.SetItem(Index: Integer;const Value: TVirtualChartSeriesDataItem);
begin
  Inherited Items[Index]:=Value;
end;

//function TVirtualChartSeriesDataItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=SkinItemClass.Create;//(Self);
//end;

function TVirtualChartSeriesDataItems.GetItem(Index: Integer): TVirtualChartSeriesDataItem;
begin
  Result:=TVirtualChartSeriesDataItem(Inherited Items[Index]);
end;

function TVirtualChartSeriesDataItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TVirtualChartSeriesDataItem;
end;


//{ TVirtualChartSeriesDataDrawPathItem }
//
//constructor TVirtualChartSeriesDataDrawPathItem.Create;
//begin
//  FDrawPathActions:=TPathActionCollection.Create(TPathActionItem,nil,GlobalDrawPathDataClass);
//
//end;
//
//destructor TVirtualChartSeriesDataDrawPathItem.Destroy;
//begin
//  FreeAndNil(FDrawPathActions);
//  inherited;
//end;
//
//{ TVirtualChartSeriesDataDrawPathItems }
//
//
//
//function TVirtualChartSeriesDataDrawPathItems.Add: TVirtualChartSeriesDataDrawPathItem;
//begin
//  Result:=TVirtualChartSeriesDataDrawPathItem(Inherited Add);
//end;
//
////procedure TVirtualChartSeriesDataDrawPathItems.InitSkinItemClass;
////begin
////  SkinItemClass:=TVirtualChartSeriesDataDrawPathItem;
////end;
//
//function TVirtualChartSeriesDataDrawPathItems.Insert(Index:Integer): TVirtualChartSeriesDataDrawPathItem;
//begin
//  Result:=TVirtualChartSeriesDataDrawPathItem(Inherited Insert(Index));
//end;
//
//procedure TVirtualChartSeriesDataDrawPathItems.SetItem(Index: Integer;const Value: TVirtualChartSeriesDataDrawPathItem);
//begin
//  Inherited Items[Index]:=Value;
//end;
//
////function TVirtualChartSeriesDataDrawPathItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
////begin
////  Result:=SkinItemClass.Create;//(Self);
////end;
//
//function TVirtualChartSeriesDataDrawPathItems.GetItem(Index: Integer): TVirtualChartSeriesDataDrawPathItem;
//begin
//  Result:=TVirtualChartSeriesDataDrawPathItem(Inherited Items[Index]);
//end;
//
//function TVirtualChartSeriesDataDrawPathItems.GetSkinItemClass: TBaseSkinItemClass;
//begin
//  Result:=TVirtualChartSeriesDataDrawPathItem;
//end;

{ TVirtualChartSeriesDrawer }

constructor TVirtualChartSeriesDrawer.Create(AVirtualChartSeries: TVirtualChartSeries);
begin
  FSeries:=AVirtualChartSeries;

end;

function TVirtualChartSeriesDrawer.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData;const APathDrawRect:TRectF): Boolean;
begin

end;

function TVirtualChartSeriesDrawer.GetDataItemColor(ADataItem: TVirtualChartSeriesDataItem): TDelphiColor;
var
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin
  if ADataItem.Color=0 then
  begin
    //默认颜色
    ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);
    Result:=ASkinVirtualChartDefaultMaterial.FSeriesColorArray[Self.FSeries.FSameCharTypeIndex];
  end
  else
  begin
    //
    Result:=ADataItem.Color;
  end;
end;

function TVirtualChartSeriesDrawer.GetPathDrawRect(ADrawRect: TRectF): TRectF;
var
//  ADrawRect:TRectF;
//  AXAxisSkinListBox:TSkinListBox;
//  AYAxisSkinListBox:TSkinListBox;
  ASkinVirtualChartIntf:ISkinVirtualChart;
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin

  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);


  ASkinVirtualChartIntf:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf;
  Result:=ADrawRect;
//
//  AXAxisSkinListBox:=ASkinVirtualChartIntf.Properties.FXAxisSkinListBox;
////  AXAxisSkinListBox.Visible:=False;
//  AYAxisSkinListBox:=ASkinVirtualChartIntf.Properties.FYAxisSkinListBox;
////  AYAxisSkinListBox.Visible:=False;


//
//  AXAxisSkinListBox.Properties.ListLayoutsManager.SkinListIntf:=ASkinVirtualChartIntf.Properties.AxisItems;
//
//  FreeAndNil(AXAxisSkinListBox.Properties.FItems);
//  AXAxisSkinListBox.Properties.FItems:=ASkinVirtualChartIntf.Properties.FXAxis.FItems;
//
//
//
//
//  AYAxisSkinListBox.Properties.ListLayoutsManager.SkinListIntf:=ASkinVirtualChartIntf.Properties.FYAxis.FItems;
//
//  FreeAndNil(AYAxisSkinListBox.Properties.FItems);
//  AYAxisSkinListBox.Properties.FItems:=ASkinVirtualChartIntf.Properties.FYAxis.FItems;
//



//  //画出纵坐标系
//  {$IFDEF VCL}
//  AYAxisSkinListBox.AlignWithMargins:=True;
//  AYAxisSkinListBox.Align:=alLeft;
//  {$ENDIF}
//  {$IFDEF FMX}
//  AYAxisSkinListBox.Align:=TAlignLayout.Left;
//  {$ENDIF}
//  AYAxisSkinListBox.Margins.Left:=0;
//  AYAxisSkinListBox.Margins.Top:=100;
//  AYAxisSkinListBox.Margins.Right:=0;
//  AYAxisSkinListBox.Margins.Bottom:=0;
//  //水平排列的
//  AYAxisSkinListBox.Prop.ItemWidth:=-2;
//  if AYAxisSkinListBox.Prop.Items.Count>1 then
//  begin
//    AYAxisSkinListBox.Prop.ItemHeight:=1/AYAxisSkinListBox.Prop.Items.Count;
//  end
//  else
//  begin
//    AYAxisSkinListBox.Prop.ItemHeight:=1/AYAxisSkinListBox.Prop.Items.Count;
//  end;
//
//
//  //画出横坐标系
//  {$IFDEF VCL}
//  AXAxisSkinListBox.AlignWithMargins:=True;
//  AXAxisSkinListBox.Align:=alBottom;
//  {$ENDIF}
//  {$IFDEF FMX}
//  AYAxisSkinListBox.Align:=TAlignLayout.Bottom;
//  {$ENDIF}
//  AXAxisSkinListBox.Margins.Left:=100;
//  AXAxisSkinListBox.Margins.Top:=0;
//  AXAxisSkinListBox.Margins.Right:=0;
//  AXAxisSkinListBox.Margins.Bottom:=0;
//  //水平排列的
//  if AXAxisSkinListBox.Prop.Items.Count>1 then
//  begin
//    AXAxisSkinListBox.Prop.ItemCountPerLine:=AXAxisSkinListBox.Prop.Items.Count;
//  end
//  else
//  begin
//    AXAxisSkinListBox.Prop.ItemCountPerLine:=1;
//  end;


//  Result:=RectF(AYAxisSkinListBox.Width,
//                    AYAxisSkinListBox.Margins.Top,
//                    ASkinVirtualChartIntf.Properties.SkinControl.Width,
//                    AYAxisSkinListBox.Margins.Top+AYAxisSkinListBox.Height
//                    );

  Result:=RectF(ASkinVirtualChartDefaultMaterial.FMarginsLeft
                            +ASkinVirtualChartDefaultMaterial.FYAxisCaptionWidth,
                ASkinVirtualChartDefaultMaterial.FMarginsTop,

                ASkinVirtualChartIntf.Properties.SkinControl.Width
                            -ASkinVirtualChartDefaultMaterial.FMarginsRight,

                ASkinVirtualChartIntf.Properties.SkinControl.Height
                            -ASkinVirtualChartDefaultMaterial.FMarginsBottom
                            -ASkinVirtualChartDefaultMaterial.FXAxisCaptionHeight
                );

end;

procedure TVirtualChartSeriesDrawer.PaintAxis(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData; const APathDrawRect: TRectF);
var
  I: Integer;
var
//  ADrawRect:TRectF;
  X:Double;
  Y:Double;
  AXAxisSkinListBox:TSkinListBox;
  AYAxisSkinListBox:TSkinListBox;
  ASkinVirtualChartIntf:ISkinVirtualChart;
  ACaptionRect:TRectF;
  AItemWidth:Double;
var
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
//var
//  I:Integer;
var
  ADataItem:TVirtualChartSeriesDataItem;
  AItemEffectStates:TDPEffectStates;
  AOldColor:TDelphiColor;
  AItemCaptionWidth:Double;
  ALastItemCaptionDrawLeft:Double;
//  AItemPaintData:TPaintData;
//var
//  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin

  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(ASkinMaterial);
  ASkinVirtualChartIntf:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf;

  AXAxisSkinListBox:=ASkinVirtualChartIntf.Properties.FXAxisSkinListBox;
  AYAxisSkinListBox:=ASkinVirtualChartIntf.Properties.FYAxisSkinListBox;




  //绘制Y轴的背景线

  Y:=APathDrawRect.Top;
  for I := 0 to AYAxisSkinListBox.Prop.Items.Count-1 do
  begin
    //画行线
    ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,APathDrawRect.Left,Y,APathDrawRect.Right,Y);



    //绘制左边的刻度值,垂直居中,水平右对齐
    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontHorzAlign:=fhaRight;
    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontVertAlign:=fvaCenter;
    //右边要空出一点
    ACaptionRect:=RectF(0,Y-20,APathDrawRect.Left-5,Y+20);
    ACanvas.DrawText(ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam,AYAxisSkinListBox.Prop.Items[I].Caption,ACaptionRect);

//    Y:=Y+AYAxisSkinListBox.Prop.ListLayoutsManager.CalcItemHeight(AYAxisSkinListBox.Prop.Items[I]);
    Y:=Y+APathDrawRect.Height / (AYAxisSkinListBox.Prop.Items.Count-1);
  end;







  //画X轴的刻度线
  X:=APathDrawRect.Left;
  AItemWidth:=APathDrawRect.Width / (AXAxisSkinListBox.Prop.Items.Count);
  ALastItemCaptionDrawLeft:=0;
  for I := 0 to AXAxisSkinListBox.Prop.Items.Count-1 do
  begin


    //画刻度线
    //目前这个模式,刻度线画在DataItem的中心点
//    ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,
//                      X+AItemWidth/2,
//                      APathDrawRect.Bottom,
//                      X+AItemWidth/2,
//                      APathDrawRect.Bottom+5);
    ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,
                      X,
                      APathDrawRect.Bottom,
                      X,
                      APathDrawRect.Bottom+5);
    //画最后的刻度线
    if I=AXAxisSkinListBox.Prop.Items.Count-1 then
    begin
      ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,
                        X+AItemWidth,
                        APathDrawRect.Bottom,
                        X+AItemWidth,
                        APathDrawRect.Bottom+5);
    end;
    


    //绘制左边的刻度值,垂直居中,水平右对齐
    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontHorzAlign:=fhaCenter;
    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontVertAlign:=fvaTop;



    //上边要空出一点
    //绘制刻度标题
    AItemCaptionWidth:=GetStringWidth(AXAxisSkinListBox.Prop.Items[I].Caption,ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.FontSize);

    //绘制标题前需要判断能不能绘制的下,绘制不下则不绘制
//    if (X+AItemWidth/2-ALastItemCaptionDrawLeft)>AItemCaptionWidth/2 then
    if ((X-ALastItemCaptionDrawLeft)*2+AItemWidth)>AItemCaptionWidth then
    begin
      ACaptionRect.Left:=X+(AItemWidth-AItemCaptionWidth)/2;
      ACaptionRect.Top:=APathDrawRect.Bottom+5;//上面空出一点
      ACaptionRect.Right:=ACaptionRect.Left+AItemCaptionWidth;
      ACaptionRect.Bottom:=APathDrawRect.Bottom+5+24;
      ACanvas.DrawText(ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam,AXAxisSkinListBox.Prop.Items[I].Caption,ACaptionRect);

      ALastItemCaptionDrawLeft:=ACaptionRect.Right;

    end;

//    Y:=Y+AYAxisSkinListBox.Prop.ListLayoutsManager.CalcItemHeight(AYAxisSkinListBox.Prop.Items[I]);
    X:=X+AItemWidth;


  end;


end;

{ TVirtualChartSeriesBarDrawer }

function TVirtualChartSeriesBarDrawer.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData;const APathDrawRect:TRectF): Boolean;
var
  I: Integer;
  ADataItem:TVirtualChartSeriesDataItem;
  AItemEffectStates:TDPEffectStates;
  AOldColor:TDelphiColor;
  ASkinVirtualChartIntf:ISkinVirtualChart;
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin

  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(ASkinMaterial);
  ASkinVirtualChartIntf:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf;

  Inherited;


  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(ASkinMaterial);

  //绘制柱子
  for I := 0 to Self.FSeries.FDataItems.Count-1 do
  begin
    ADataItem:=Self.FSeries.FDataItems[I];


    //获取数据项的状态，是否鼠标停靠
    AItemEffectStates:=Self.FSeries.FListLayoutsManager.ProcessItemDrawEffectStates(ADataItem);
    ASkinVirtualChartDefaultMaterial.FBarColorParam.StaticEffectStates:=AItemEffectStates;


    AOldColor:=ASkinVirtualChartDefaultMaterial.FBarColorParam.FillColor.FColor;
    //获取数据项的柱子填充色
    ASkinVirtualChartDefaultMaterial.FBarColorParam.FillColor.FColor:=Self.GetDataItemColor(ADataItem);


    //处理绘制参数的透明度
    ASkinVirtualChartDefaultMaterial.FBarColorParam.DrawAlpha:=
                  Ceil(ASkinVirtualChartDefaultMaterial.FBarColorParam.CurrentEffectAlpha*1);

    //绘制柱子
    ACanvas.DrawPath(ASkinVirtualChartDefaultMaterial.FBarColorParam,APathDrawRect,ADataItem.FDrawPathActions);

    ASkinVirtualChartDefaultMaterial.FBarColorParam.FillColor.FColor:=AOldColor;

  end;
end;

procedure TVirtualChartSeriesBarDrawer.GenerateDrawPathList(APathDrawRect:TRectF);
var
  I: Integer;
  ADataItemRect:TRectF;
  ADataItemPathRect:TRectF;
  AVirtualChartSeriesList:TVirtualChartSeriesList;
  AXAxisSkinListBox:TSkinListBox;
  ALegendSkinListView:TSkinVirtualList;
  AAxisItemWidth:Double;
  ADataItemLeft:Double;
  ADataItemWidth:Double;
  ALeft:Double;
  ADataItem:TVirtualChartSeriesDataItem;
  APathActionItem:TPathActionItem;
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
  ABarSizePercent:Double;
  ASeriesItemSpace:Double;
begin
  Inherited;



  AVirtualChartSeriesList:=TVirtualChartSeriesList(Self.FSeries.Collection);

  AXAxisSkinListBox:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FXAxisSkinListBox;
  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);


  ALegendSkinListView:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FLegendSkinListView;

  if ALegendSkinListView<>nil then
  begin
      ALegendSkinListView.Visible:=False;
      ALegendSkinListView.OnMouseOverItemChange:=nil;
      ALegendSkinListView.OnPrepareDrawItem:=nil;
  end;

  //取出柱子宽度的百分比
  ABarSizePercent:=0.5;
  if ASkinVirtualChartDefaultMaterial<>nil then
  begin
    ABarSizePercent:=ASkinVirtualChartDefaultMaterial.BarSizePercent;
  end;




  //然后生成柱子
  //需要最大值,计算出百分比
  ALeft:=0;
  for I := 0 to Self.FSeries.FDataItems.Count-1 do
  begin
      ADataItem:=Self.FSeries.FDataItems[I];


      //算出百分比
      ADataItem.FDrawPercent:=0;
      if (AVirtualChartSeriesList.FMaxValue-AVirtualChartSeriesList.FMinValue)>0 then
      begin
        ADataItem.FDrawPercent:=(ADataItem.Value-AVirtualChartSeriesList.FMinValue)/(AVirtualChartSeriesList.FMaxValue-AVirtualChartSeriesList.FMinValue);
      end;




      //横排的
      //生成Path列表
      //AAxisItemWidth:=AXAxisSkinListBox.Prop.CalcItemWidth(AXAxisSkinListBox.Prop.Items[I]);
      AAxisItemWidth:=APathDrawRect.Width / AXAxisSkinListBox.Prop.Items.Count;



      case ASkinVirtualChartDefaultMaterial.FBarsStackType of
        bstOverride:
        begin
            ADataItemLeft:=AAxisItemWidth*(1-ABarSizePercent)/2;
            ADataItemWidth:=AAxisItemWidth*ABarSizePercent;
        end;
        bstQueue:
        begin
            ADataItemWidth:=AAxisItemWidth*ABarSizePercent;//用作显示所有序列的宽度
            //每个序列柱子间的间隔
            ASeriesItemSpace:=0;
            //20%空出来作为序列的间隔
            if AVirtualChartSeriesList.FBarSeriesCount>1 then
            begin
              ASeriesItemSpace:=ADataItemWidth * 0.1 / (AVirtualChartSeriesList.FBarSeriesCount-1);
            end;
            //每个序列柱子的宽度
            ADataItemWidth:=(ADataItemWidth - ASeriesItemSpace*(AVirtualChartSeriesList.FBarSeriesCount-1))
                            / AVirtualChartSeriesList.FBarSeriesCount;
            //左边距
            ADataItemLeft:=AAxisItemWidth*(1-ABarSizePercent)/2
                            +(Self.FSeries.FSameCharTypeIndex)*ADataItemWidth
                            +(Self.FSeries.FSameCharTypeIndex)*ASeriesItemSpace;

        end;
      end;

      //数据项所在的大矩形-相对坐标
      ADataItemRect:=RectF(0,0,0,0);
      ADataItemRect.Left:=ALeft;
      ADataItemRect.Top:=0;
      ADataItemRect.Right:=ALeft+AAxisItemWidth;
      ADataItemRect.Bottom:=APathDrawRect.Height;







      ADataItem.FDrawPathActions.Clear;



      //柱子的相对坐标
      ADataItemPathRect.Left:=ADataItemRect.Left+ADataItemLeft;
      ADataItemPathRect.Top:=ADataItemRect.Top+APathDrawRect.Height*(1-ADataItem.FDrawPercent);
      ADataItemPathRect.Right:=ADataItemPathRect.Left+ADataItemWidth;
      ADataItemPathRect.Bottom:=ADataItemRect.Bottom;


      //生成柱子的Path
      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
      APathActionItem.ActionType:=patAddRect;
      APathActionItem.X:=ADataItemPathRect.Left;
      //这个柱状图是从底部上来的
      APathActionItem.Y:=ADataItemPathRect.Top;
      APathActionItem.X1:=ADataItemPathRect.Right;
      APathActionItem.Y1:=ADataItemPathRect.Bottom;

      //填充
      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
      APathActionItem.ActionType:=patFillPath;



      //绝对坐标
      OffsetRect(ADataItemPathRect,APathDrawRect.Left,APathDrawRect.Top);
      OffsetRect(ADataItemRect,APathDrawRect.Left,APathDrawRect.Top);
      ADataItem.FItemRect:=ADataItemRect;
      ADataItem.FItemDrawRect:=ADataItemRect;
      ADataItem.FBarPathDrawRect:=ADataItemPathRect;



      //下一个Item的左边距
      ALeft:=ALeft+AAxisItemWidth;


  end;


end;

//function TVirtualChartSeriesBarDrawer.GetDataItemColor(ADataItem: TVirtualChartSeriesDataItem): TDelphiColor;
//var
//  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
//begin
//  if ADataItem.Color=0 then
//  begin
//    //默认颜色
//    ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);
//    Result:=ASkinVirtualChartDefaultMaterial.BarColorParam.FillColor.Color;
//  end
//  else
//  begin
//    //
//    Result:=ADataItem.Color;
//  end;
//end;

{ TVirtualChartSeriesDataItem }

procedure TVirtualChartSeriesDataItem.AssignTo(Dest: TPersistent);
var
  DestObject:TVirtualChartSeriesDataItem;
begin
  if Dest is TVirtualChartSeriesDataItem then
  begin

    DestObject:=Dest as TVirtualChartSeriesDataItem;

    DestObject.FValue:=Self.FValue;

    //inherited里面已经有了DestObject.DoPropChange;
    inherited;

  end
  else
  begin
    inherited;
  end;

end;

constructor TVirtualChartSeriesDataItem.Create;
begin
  Inherited;
  FDrawPathActions:=TPathActionCollection.Create(TPathActionItem,nil,GlobalDrawPathDataClass);

end;

destructor TVirtualChartSeriesDataItem.Destroy;
begin
  FreeAndNil(FDrawPathActions);

  inherited;
end;

function TVirtualChartSeriesDataItem.LoadFromDocNode(
  ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Value' then
    begin
      FValue:=ABTNode.ConvertNode_Real64.Data;
    end
    ;

  end;

  Result:=True;


end;

function TVirtualChartSeriesDataItem.PtInItem(APoint: TPointF): Boolean;
var
  APieDrawer:TVirtualChartSeriesPieDrawer;
begin

  Result:=False;

  //还没生成
  if TVirtualChartSeriesDataItems(Self.Owner).FSeries.FDrawer=nil then
  begin
    Exit;
  end;

//  {$IFDEF VCL}
//  if (TVirtualChartSeriesDataItems(Self.Owner).FSeries.FChartType=sctPie)
//    or (TVirtualChartSeriesDataItems(Self.Owner).FSeries.FChartType=sctLine) then
//  begin
//    //饼图是扇形,需要用到GDI+的Region
//    Result:=Self.FDrawPathActions.FDrawPathData.IsInRegion(APoint);
//  end
//  else
//  begin
//    //有时候是矩形内的柱子里移上去就要有效果
//    Result:=PtInRect(FBarPathDrawRect,APoint);
//
//
//    //有时候是在整个矩形内就要有鼠标停靠效果
//  //  Result:=PtInRect(FItemDrawRect,APoint);
//  end;
//
//  {$ENDIF}
//  {$IFDEF FMX}


  if (TVirtualChartSeriesDataItems(Self.Owner).FSeries.FChartType=sctPie) then
  begin
    //饼图是扇形,需要判断鼠标是否在扇形中
    //Result:=Self.FDrawPathActions.FDrawPathData.IsInRegion(APoint);
    APieDrawer:=TVirtualChartSeriesPieDrawer(TVirtualChartSeriesDataItems(Self.Owner).FSeries.FDrawer);
    //判断鼠标是否在外扇形中
    Result:=PtInPie(APieDrawer.FCircleCenterPoint,APoint,Self,APieDrawer.FRadius,Self.FPieStartAngle+90,Self.FPieSweepAngle);
    if APieDrawer.FInnerRadius>0 then
    begin
      //判断鼠标是否在空心圆的内扇形中
      if PtInPie(APieDrawer.FCircleCenterPoint,APoint,Self,APieDrawer.FInnerRadius,Self.FPieStartAngle+90,Self.FPieSweepAngle) then
      begin
        Result:=False;
      end;
    end;

  end
  else if (TVirtualChartSeriesDataItems(Self.Owner).FSeries.FChartType=sctLine) then
  begin
    //线状图,只需要判断鼠标是否在那个圆点上即可
    Result:=PtInRect(Self.FLineDotRect,APoint);
  end
  else
  begin
    //有时候是矩形内的柱子里移上去就要有效果
    Result:=PtInRect(FBarPathDrawRect,APoint);


    //有时候是在整个矩形内就要有鼠标停靠效果
  //  Result:=PtInRect(FItemDrawRect,APoint);
  end;

//  {$ENDIF}

end;

function TVirtualChartSeriesDataItem.SaveToDocNode(
  ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Real64('Value');
  ABTNode.ConvertNode_Real64.Data:=FValue;

  Result:=True;


end;

procedure TVirtualChartSeriesDataItem.SetValue(const AValue: Double);
begin
  if FValue<>AValue then
  begin
    FValue := AValue;
    Self.DoPropChange();
  end;
end;

{ TSkinVirtualChartDefaultMaterial }

constructor TSkinVirtualChartDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited;


  FBarColorParam:=CreateDrawPathParam('BarColorParam','柱子的路径绘制参数');
  FBarColorParam.FillColor.Color:={$IFDEF VCL}$00F79087{$ENDIF}{$IFDEF FMX}$FF8790F7{$ENDIF};//BlueColor;
//  FBarColorParam.FillColor.Color:=BlueColor;
  FBarColorParam.IsControlParam:=False;

  //鼠标移上去渐变
//  Self.BarColorParam.DrawEffectSetting.MouseOverEffect.CommonEffectTypes:=[dpcetAlphaChange];
//  Self.BarColorParam.DrawEffectSetting.MouseOverEffect.Alpha:=230;
  Self.BarColorParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=[dppetFillColorChange];
//  Self.BarColorParam.DrawEffectSetting.MouseOverEffect.FillColor.Color:=RedColor;
//  Self.BarColorParam.DrawEffectSetting.MouseOverEffect.FillColorChangeType:=TColorChangeType.cctBrightness;
  Self.BarColorParam.DrawEffectSetting.MouseOverEffect.FillColorChangeType:=TColorChangeType.cctDarkness;
//  Self.BarColorParam.DrawEffectSetting.MouseOverEffect.IsFill:=True;
//  Self.BarColorParam.IsFill:=True;


  FPieColorParam:=CreateDrawPathParam('PieColorParam','饼的路径绘制参数');
  FPieColorParam.FillColor.Color:={$IFDEF VCL}$00F79087{$ENDIF}{$IFDEF FMX}$FF8790F7{$ENDIF};//BlueColor;
//  FPieColorParam.FillColor.Color:=BlueColor;
  FPieColorParam.IsControlParam:=False;

  //鼠标移上去渐变
//  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.CommonEffectTypes:=[];

//  //鼠标移上去变大一点
//  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.SizeChange:=5;
//  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=[dppetFillColorChange,dpcetPathRectSizeChange];
  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=[dppetFillColorChange];


//  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.FillColor.Color:=RedColor;
//  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.FillColorChangeType:=TColorChangeType.cctBrightness;
  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.FillColorChangeType:=TColorChangeType.cctDarkness;
//  Self.FPieColorParam.DrawEffectSetting.MouseOverEffect.IsFill:=True;
//  Self.FPieColorParam.IsFill:=True;



  FBarSizePercent:=0.7;//当一个序列的时候百分比小一点
  //当多个序列的时候，百分比要大一些


  FBarAxisLineParam:=CreateDrawLineParam('BarAxisLineParam','坐标线的线条绘制参数');
  FBarAxisLineParam.IsControlParam:=False;
  FBarAxisLineParam.Color.FColor:=GrayColor;

  FDrawAxisCaptionParam:=CreateDrawTextParam('DrawAxisCaptionParam','坐标刻度标题的文本绘制参数');
  FDrawAxisCaptionParam.IsControlParam:=False;
  FDrawAxisCaptionParam.DrawFont.FontColor.Color:=GrayColor;





  FPieRadiusPercent:=0.7;
  FPieInnerSizePercent:=0.4;

  SetLength(FSeriesColorArray,9);
  FSeriesColorArray[0]:={$IFDEF VCL}$D97B5C{$ENDIF}{$IFDEF FMX}$FF5C7BD9{$ENDIF};
  FSeriesColorArray[1]:={$IFDEF VCL}$80E09F{$ENDIF}{$IFDEF FMX}$FF9FE080{$ENDIF};
  FSeriesColorArray[2]:={$IFDEF VCL}$60DCFF{$ENDIF}{$IFDEF FMX}$FFFFDC60{$ENDIF};
  FSeriesColorArray[3]:={$IFDEF VCL}$7070FF{$ENDIF}{$IFDEF FMX}$FFFF7070{$ENDIF};
  FSeriesColorArray[4]:={$IFDEF VCL}$F4D37E{$ENDIF}{$IFDEF FMX}$FF7ED3F4{$ENDIF};
  FSeriesColorArray[5]:={$IFDEF VCL}$7DB240{$ENDIF}{$IFDEF FMX}$FF40B27D{$ENDIF};
  FSeriesColorArray[6]:={$IFDEF VCL}$5A91FF{$ENDIF}{$IFDEF FMX}$FFFF915A{$ENDIF};
  FSeriesColorArray[7]:={$IFDEF VCL}$C669A9{$ENDIF}{$IFDEF FMX}$FFA969C6{$ENDIF};
  FSeriesColorArray[8]:={$IFDEF VCL}$E088FF{$ENDIF}{$IFDEF FMX}$FFFF88E0{$ENDIF};

  FSeriesLegendListViewVisible:=True;
  FPieInfoVisible:=True;


  FPieInfoCaptionParam:=CreateDrawTextParam('PieInfoCaptionParam','饼图信息标题的文本绘制参数');
  FPieInfoCaptionParam.IsControlParam:=False;



  FLineColorParam:=CreateDrawLineParam('LineColorParam','线状的线条绘制参数');
  FLineColorParam.IsControlParam:=False;
  FLineColorParam.PenDrawColor.FColor:={$IFDEF VCL}$00F79087{$ENDIF}{$IFDEF FMX}$FF8790F7{$ENDIF};//BlueColor;
  FLineColorParam.PenWidth:=2;



  FLineDotParam:=CreateDrawPathParam('LineDotParam','线点的路径绘制参数');
  FLineDotParam.IsControlParam:=False;
  FLineDotParam.PenDrawColor.FColor:={$IFDEF VCL}$00F79087{$ENDIF}{$IFDEF FMX}$FF8790F7{$ENDIF};//BlueColor;
  FLineDotParam.PenWidth:=2;
  FLineDotParam.FillColor.FColor:=WhiteColor;
  Self.FLineDotParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=[dpcetPathRectSizeChange];
  //鼠标移上去变大一点
  Self.FLineDotParam.DrawEffectSetting.MouseOverEffect.SizeChange:=3;
  FLineDotRadius:=5;



  FMarginsLeft:=10;
  FMarginsTop:=10;
  FMarginsRight:=10;
  FMarginsBottom:=10;

  FYAxisCaptionWidth:=32;
  FXAxisCaptionHeight:=24;
end;

destructor TSkinVirtualChartDefaultMaterial.Destroy;
begin
  FreeAndNil(FBarColorParam);
  FreeAndNil(FPieColorParam);
  FreeAndNil(FBarAxisLineParam);
  FreeAndNil(FDrawAxisCaptionParam);
  FreeAndNil(FLineColorParam);
  FreeAndNil(FLineDotParam);
  FreeAndNil(FPieInfoCaptionParam);

  inherited;
end;

procedure TSkinVirtualChartDefaultMaterial.SetBarSizePercent(const Value: Double);
begin
  if FBarSizePercent<>Value then
  begin
    FBarSizePercent := Value;
    DoChange;
  end;
end;

procedure TSkinVirtualChartDefaultMaterial.SetBarsStackType(
  const Value: TBarsStackType);
begin
  if FBarsStackType<>Value then
  begin
    FBarsStackType := Value;
    DoChange;
  end;
end;

procedure TSkinVirtualChartDefaultMaterial.SetDrawAxisCaptionParam(
  const Value: TDrawTextParam);
begin
  FDrawAxisCaptionParam.Assign(Value);
end;

procedure TSkinVirtualChartDefaultMaterial.SetPieInfoCaptionParam(
  const Value: TDrawTextParam);
begin
  FPieInfoCaptionParam.Assign(Value);
end;

procedure TSkinVirtualChartDefaultMaterial.SetPieInfoVisible(
  const Value: Boolean);
begin
  if FPieInfoVisible<>Value then
  begin
    FPieInfoVisible := Value;
    DoChange;
  end;
end;

procedure TSkinVirtualChartDefaultMaterial.SetPieInnerRadiusPercent(
  const Value: Double);
begin
  if FPieInnerSizePercent<>Value then
  begin
    FPieInnerSizePercent := Value;
    DoChange;
  end;
end;

procedure TSkinVirtualChartDefaultMaterial.SetLineColorParam(
  const Value: TDrawLineParam);
begin
  FLineColorParam.Assign(Value);
end;

procedure TSkinVirtualChartDefaultMaterial.SetLineDotParam(
  const Value: TDrawPathParam);
begin
  FLineDotParam.Assign(Value);
end;

procedure TSkinVirtualChartDefaultMaterial.SetBarAxisLineParam(
  const Value: TDrawLineParam);
begin
  FBarAxisLineParam.Assign(Value);
end;

procedure TSkinVirtualChartDefaultMaterial.SetBarColorParam(
  const Value: TDrawPathParam);
begin
  FBarColorParam.Assign(Value);
end;

procedure TSkinVirtualChartDefaultMaterial.SetPieColorParam(
  const Value: TDrawPathParam);
begin
  FPieColorParam.Assign(Value);
end;

procedure TSkinVirtualChartDefaultMaterial.SetPieRadiusPercent(
  const Value: Double);
begin
  if FPieRadiusPercent<>Value then
  begin
    FPieRadiusPercent := Value;
    DoChange;
  end;
end;

procedure TSkinVirtualChartDefaultMaterial.SetSeriesLegendListViewVisible(
  const Value: Boolean);
begin
  if FSeriesLegendListViewVisible<>Value then
  begin
    FSeriesLegendListViewVisible := Value;
    DoChange;
  end;
end;

{ TVirtualChartSeriesPieDrawer }

function ExPandLine(pt1:TPointF; pt2:TPointF; nLen:Double;var OutPt:TPointF):Boolean;
var
  k,b,zoom:Double;
begin
	if (pt1.x - pt2.x = 0) then
	begin
		OutPt.x := pt1.x;
		if (pt1.y - pt2.y > 0) then
		begin
			OutPt.y := pt2.y - nLen;
		end
		else
		begin
			OutPt.y := pt2.y + nLen;
		end;
	end
	else if (pt1.y - pt2.y = 0) then
	begin
		OutPt.y := pt1.y;
		if (pt1.x - pt2.x > 0) then
		begin
			OutPt.x := pt2.x - nLen;
		end
		else
		begin
			OutPt.x := pt2.x + nLen;
		end;
	end
	else
	begin
	  k := 0.0;
	  b := 0.0;
		k := (pt1.y - pt2.y)/(pt1.x-pt2.x);
		b := pt1.y - k * pt1.x;
	  zoom := 0.0;
		zoom := nLen/sqrt((pt2.x-pt1.x)*(pt2.x-pt1.x)+(pt2.y-pt1.y)*(pt2.y-pt1.y));

		if (k > 0) then
		begin
			if (pt1.x-pt2.x > 0) then
			begin
				OutPt.x := pt2.x - zoom * (pt1.x-pt2.x);
				OutPt.y := k*OutPt.x + b;
			end
			else
			begin
				OutPt.x := pt2.x + zoom * (pt2.x-pt1.x);
				OutPt.y := k*OutPt.x + b;
			end;
		end
		else
		begin
			if (pt1.x-pt2.x > 0) then
			begin
				OutPt.x := pt2.x - zoom * (pt1.x-pt2.x) ;
				OutPt.y := k*OutPt.x + b;
			end
			else
			begin
				OutPt.x := pt2.x + zoom * (pt2.x - pt1.x);
				OutPt.y := k*OutPt.x + b;
			end
		end
	end;
	Result:=True;
end;



function TVirtualChartSeriesPieDrawer.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData; const APathDrawRect: TRectF): Boolean;
var
  I: Integer;
var
//  ADrawRect:TRectF;
  X:Double;
  Y:Double;
  AXAxisSkinListBox:TSkinListBox;
  AYAxisSkinListBox:TSkinListBox;
  ASkinVirtualChartIntf:ISkinVirtualChart;
//  ACaptionRect:TRectF;
//  AItemWidth:Double;
var
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
//var
//  I:Integer;
var
  ADataItem:TVirtualChartSeriesDataItem;
  AItemEffectStates:TDPEffectStates;
  ADataItemColor:TDelphiColor;
  AOldColor:TDelphiColor;
  AItemCaptionWidth:Double;
  ALastItemCaptionDrawLeft:Double;
  ALastItemCaptionDrawRect:TRectF;
//  AItemPaintData:TPaintData;
//var
//  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin

  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(ASkinMaterial);
  ASkinVirtualChartIntf:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf;

//  AXAxisSkinListBox:=ASkinVirtualChartIntf.Properties.FXAxisSkinListBox;
//  AYAxisSkinListBox:=ASkinVirtualChartIntf.Properties.FYAxisSkinListBox;




//  //绘制Y轴的背景线
//
////  ADrawLineParam:=TDrawLineParam.Create('','');
//  Y:=APathDrawRect.Top;
//  for I := 0 to AYAxisSkinListBox.Prop.Items.Count-1 do
//  begin
//    //画行线
//    ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,APathDrawRect.Left,Y,APathDrawRect.Right,Y);
//    //绘制左边的刻度值,垂直居中,水平右对齐
//    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontHorzAlign:=fhaRight;
//    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontVertAlign:=fvaCenter;
//    //右边要空出一点
//    ACaptionRect:=RectF(0,Y-20,APathDrawRect.Left-5,Y+20);
//    ACanvas.DrawText(ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam,AYAxisSkinListBox.Prop.Items[I].Caption,ACaptionRect);
//
////    Y:=Y+AYAxisSkinListBox.Prop.ListLayoutsManager.CalcItemHeight(AYAxisSkinListBox.Prop.Items[I]);
//    Y:=Y+APathDrawRect.Height / (AYAxisSkinListBox.Prop.Items.Count-1);
//  end;
//
////  FreeAndNil(ADrawLineParam);





//
//  //画X轴的刻度线
//  X:=APathDrawRect.Top;
//  AItemWidth:=APathDrawRect.Width / (AXAxisSkinListBox.Prop.Items.Count);
//  ALastItemCaptionDrawLeft:=0;
//  for I := 0 to AXAxisSkinListBox.Prop.Items.Count-1 do
//  begin
//
//
//    //画刻度线
//    //目前这个模式,刻度线画在DataItem的中心点
//    ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,
//                      X+AItemWidth/2,
//                      APathDrawRect.Bottom,
//                      X+AItemWidth/2,
//                      APathDrawRect.Bottom+5);
//
//
//
//    //绘制左边的刻度值,垂直居中,水平右对齐
//    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontHorzAlign:=fhaCenter;
//    ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontVertAlign:=fvaTop;
//
//
//
//    //上边要空出一点
//    //绘制刻度标题
//    AItemCaptionWidth:=GetStringWidth(AXAxisSkinListBox.Prop.Items[I].Caption,ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.FontSize);
//
//    //绘制标题前需要判断能不能绘制的下,绘制不下则不绘制
//    if (X+AItemWidth/2-ALastItemCaptionDrawLeft)>AItemCaptionWidth/2 then
//    begin
//      ACaptionRect.Left:=X+(AItemWidth-AItemCaptionWidth)/2;
//      ACaptionRect.Top:=APathDrawRect.Bottom+5;
//      ACaptionRect.Right:=ACaptionRect.Left+AItemCaptionWidth;
//      ACaptionRect.Bottom:=APathDrawRect.Bottom+5+24;
//      ACanvas.DrawText(ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam,AXAxisSkinListBox.Prop.Items[I].Caption,ACaptionRect);
//
//      ALastItemCaptionDrawLeft:=ACaptionRect.Right;
//
//    end;
//
////    Y:=Y+AYAxisSkinListBox.Prop.ListLayoutsManager.CalcItemHeight(AYAxisSkinListBox.Prop.Items[I]);
//    X:=X+AItemWidth;
//
//
//  end;



  Inherited;



  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(ASkinMaterial);
  ALastItemCaptionDrawRect:=RectF(0,0,0,0);

  //绘制柱子
  for I := 0 to Self.FSeries.FDataItems.Count-1 do
  begin
    ADataItem:=Self.FSeries.FDataItems[I];


    //给数据项加上状态
    AItemEffectStates:=Self.FSeries.FListLayoutsManager.ProcessItemDrawEffectStates(ADataItem);
    ASkinVirtualChartDefaultMaterial.FPieColorParam.StaticEffectStates:=AItemEffectStates;
    AOldColor:=ASkinVirtualChartDefaultMaterial.FPieColorParam.FillColor.FColor;
    ADataItemColor:=Self.GetDataItemColor(ADataItem);
    ASkinVirtualChartDefaultMaterial.FPieColorParam.FillColor.FColor:=ADataItemColor;


    //处理绘制参数的透明度
    ASkinVirtualChartDefaultMaterial.FPieColorParam.DrawAlpha:=Ceil(ASkinVirtualChartDefaultMaterial.FPieColorParam.CurrentEffectAlpha*1);

//    AItemPaintData:=GlobalNullPaintData;
//    AItemPaintData.IsDrawInteractiveState:=True;
//    ProcessParamEffectStates(ASkinVirtualChartDefaultMaterial.FPieColorParam,
//                                1,
//                                AItemEffectStates,
//                                AItemPaintData
//                                );

    ACanvas.DrawPath(ASkinVirtualChartDefaultMaterial.FPieColorParam,APathDrawRect,ADataItem.FDrawPathActions);


    ASkinVirtualChartDefaultMaterial.FPieColorParam.FillColor.FColor:=AOldColor;


    if (ASkinVirtualChartDefaultMaterial.PieInfoVisible) then
    begin


//        if (ADataItem.FPieArcCenterAngle>=-90) and (ADataItem.FPieArcCenterAngle<90) then
//        begin
//          //标题在右边的,用标题矩形的左上角进行判断，是不是在上一个数据项的标题里
//          if PtInRect(ALastItemCaptionDrawRect,ADataItem.FCaptionRect.TopLeft) then
//          begin
//            Continue;
//          end;
//        end
//        else
//        begin
//          //标题在左边的,用标题矩形的右下角进行判断，是不是在上一个数据项的标题里
//          if PtInRect(ALastItemCaptionDrawRect,ADataItem.FCaptionRect.BottomRight) then
//          begin
//            Continue;
//          end;
//
//        end;
        if IntersectRect(ALastItemCaptionDrawRect,ADataItem.FCaptionRect) then
        begin
          Continue;
        end;
        ALastItemCaptionDrawRect:=ADataItem.FCaptionRect;




        //画上线条,标注出数据项标题
        //画刻度线
        //目前这个模式,刻度线画在DataItem的中心点
        AOldColor:=ASkinVirtualChartDefaultMaterial.FBarAxisLineParam.PenDrawColor.FColor;
        ASkinVirtualChartDefaultMaterial.FBarAxisLineParam.PenDrawColor.FColor:=ADataItemColor;
        ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,
                          ADataItem.FPieArcCenterPoint.X,
                          ADataItem.FPieArcCenterPoint.Y,
                          ADataItem.FPieArcCenterExtendPoint.X,
                          ADataItem.FPieArcCenterExtendPoint.Y);
        //如果是-90~0~90度,那么横线向右延伸
        //如果是90~180~-90度之间,那么横线向左延伸
        ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FBarAxisLineParam,
                          ADataItem.FPieArcCenterExtendPoint.X,
                          ADataItem.FPieArcCenterExtendPoint.Y,
                          ADataItem.FPieArcCenterExtendHorzPoint.X,
                          ADataItem.FPieArcCenterExtendHorzPoint.Y);

        ASkinVirtualChartDefaultMaterial.FBarAxisLineParam.PenDrawColor.FColor:=AOldColor;


        //画刻度标题

        //上边要空出一点
        //绘制刻度标题
        //绘制标题前需要判断能不能绘制的下,绘制不下则不绘制
        if (ADataItem.FPieArcCenterAngle>=-90) and (ADataItem.FPieArcCenterAngle<90) then
        begin
          //横线往右
          //字体左对齐
          ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontHorzAlign:=fhaLeft;
        end
        else
        begin
          //横线往左
          //字体右对齐
          ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam.StaticFontHorzAlign:=fhaRight;
        end;
        ACanvas.DrawText(ASkinVirtualChartDefaultMaterial.FDrawAxisCaptionParam,ADataItem.Caption,ADataItem.FCaptionRect);



    end;


//    Exit;
  end;


  //画上说明


end;

procedure TVirtualChartSeriesPieDrawer.DoLegendListViewPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: {$IFDEF FMX}TSkinFMXItemDesignerPanel{$ENDIF}{$IFDEF VCL}TSkinItemDesignerPanel{$ENDIF}; AItem: TSkinItem;
  AItemDrawRect: TRect);
begin
  TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FLegendItemColorPanel.Material.BackColor.FillColor.Color:=
    GetDataItemColor(TVirtualChartSeriesDataItem(AItem));

end;

procedure TVirtualChartSeriesPieDrawer.GenerateDrawPathList(APathDrawRect: TRectF);
var
  I: Integer;
//  ADataItemRect:TRectF;
//  ADataItemPathRect:TRectF;
  AVirtualChartSeriesList:TVirtualChartSeriesList;
  ALegendSkinListView:TSkinVirtualList;
//  AItemWidth:Double;
  AStartAngle:Double;
  ADataItem:TVirtualChartSeriesDataItem;
  APathActionItem:TPathActionItem;
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
//  ABarSizePercent:Double;
  AMinValue,AMaxValue,ASumValue:Double;
  ARad:Double;
  ACos:Double;
  AItemCaptionWidth:Double;
  AItemCaptionHeight:Double;
  AOffset:Double;
begin
  Inherited;



  AVirtualChartSeriesList:=TVirtualChartSeriesList(Self.FSeries.Collection);

  ALegendSkinListView:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FLegendSkinListView;
  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);


  if ASkinVirtualChartDefaultMaterial.FSeriesLegendListViewVisible then
  begin
      ALegendSkinListView.Prop.ListLayoutsManager.SkinListIntf:=Self.FSeries.FDataItems;
      ALegendSkinListView.Prop.FItems:=Self.FSeries.FDataItems;

      ALegendSkinListView.Visible:=True;
      //设置提示区的位置
      //默认在最左边,从上到下排列
      {$IFDEF VCL}
      ALegendSkinListView.Align:=alLeft;
      {$ENDIF}
      {$IFDEF FMX}
      ALegendSkinListView.Align:=TAlignLayout.Left;
      {$ENDIF}

      ALegendSkinListView.Visible:=True;
      if TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FLegendItemDesignerPanel=nil then
      begin
        TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.CreateLegendItemDesignerPanel;
      end;
      ALegendSkinListView.Prop.ItemDesignerPanel:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FLegendItemDesignerPanel;
      ALegendSkinListView.Prop.ItemHeight:=26;
      {$IFDEF VCL}
      ALegendSkinListView.AlignWithMargins:=True;
      ALegendSkinListView.Margins.SetBounds(10,10,0,10);
      {$ENDIF}
      {$IFDEF FMX}
      ALegendSkinListView.Margins.Left:=10;
      ALegendSkinListView.Margins.Top:=10;
      ALegendSkinListView.Margins.Right:=0;
      ALegendSkinListView.Margins.Bottom:=10;
      {$ENDIF}
      ALegendSkinListView.OnPrepareDrawItem:=DoLegendListViewPrepareDrawItem;
      ALegendSkinListView.OnMouseOverItemChange:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.DoLegendListViewMouseOverItemChange;
  end
  else
  begin
      ALegendSkinListView.Visible:=False;
      ALegendSkinListView.OnMouseOverItemChange:=nil;
      ALegendSkinListView.OnPrepareDrawItem:=nil;
  end;


  FSeries.GetMinMaxValue(AMinValue,AMaxValue,ASumValue);


  //然后生成柱子
  //需要最大值,计算出百分比
  AStartAngle:=0;
  for I := 0 to Self.FSeries.FDataItems.Count-1 do
  begin
      ADataItem:=Self.FSeries.FDataItems[I];


      ADataItem.FDrawPercent:=0;
      if ASumValue>0 then
      begin
        ADataItem.FDrawPercent:=ADataItem.Value/ASumValue;
      end;

//      //提示,不能直接这样赋值,不然DataItem的颜色被改过来了
//      ADataItem.Color:=Self.GetDataItemColor(ADataItem);


      //横排的
      //生成Path列表
      //AItemWidth:=AXAxisSkinListBox.Prop.CalcItemWidth(AXAxisSkinListBox.Prop.Items[I]);
      //AItemWidth:=APathDrawRect.Width / AXAxisSkinListBox.Prop.Items.Count;

//      //数据项所在的大矩形-相对坐标
//      ADataItemRect:=RectF(0,0,0,0);
//      ADataItemRect.Left:=ALeft;
//      ADataItemRect.Top:=0;
//      ADataItemRect.Right:=ALeft+AItemWidth;
//      ADataItemRect.Bottom:=APathDrawRect.Height;
//
//
//
//
//      //下一个Item的左边距
//      ALeft:=ALeft+AItemWidth;



      ADataItem.FDrawPathActions.Clear;


//      ADataItemPathRect.Left:=ADataItemRect.Left+AItemWidth*(1-ABarSizePercent)/2;
//      ADataItemPathRect.Top:=ADataItemRect.Top+APathDrawRect.Height*(1-ADataItem.FDrawPercent);
//      ADataItemPathRect.Right:=ADataItemPathRect.Left+AItemWidth*ABarSizePercent;
//      ADataItemPathRect.Bottom:=ADataItemRect.Bottom;

      if ASkinVirtualChartDefaultMaterial.FPieInnerSizePercent=0 then
      begin
          //没有内环
          //生成饼的Path
          APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
          //饼
          APathActionItem.ActionType:=patAddPie;
          APathActionItem.X:=0;
          APathActionItem.Y:=0;
          APathActionItem.X1:=APathDrawRect.Width;
          APathActionItem.Y1:=APathDrawRect.Height;

          APathActionItem.StartAngle:=AStartAngle-90;
          APathActionItem.SweepAngle:=ADataItem.FDrawPercent*360;
      end
      else
      begin
          //有内环
          //圆环
          //外环
          APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
          APathActionItem.ActionType:=patAddArc;
          APathActionItem.X:=0;
          APathActionItem.Y:=0;
          APathActionItem.X1:=APathDrawRect.Width;
          APathActionItem.Y1:=APathDrawRect.Height;

          APathActionItem.StartAngle:=AStartAngle-90;
          APathActionItem.SweepAngle:=ADataItem.FDrawPercent*360;
          //内环
          AOffset:=(APathDrawRect.Width-(APathDrawRect.Width/ASkinVirtualChartDefaultMaterial.FPieRadiusPercent)*ASkinVirtualChartDefaultMaterial.FPieInnerSizePercent)/2;
          APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
          APathActionItem.ActionType:=patAddArc;
          APathActionItem.X:=AOffset;
          APathActionItem.Y:=AOffset;
          APathActionItem.X1:=APathDrawRect.Width-AOffset;
          APathActionItem.Y1:=APathDrawRect.Height-AOffset;
          //要反方向画,不然填充不了扇形
          APathActionItem.StartAngle:=AStartAngle-90+ADataItem.FDrawPercent*360;
          APathActionItem.SweepAngle:=-ADataItem.FDrawPercent*360;
      end;

      ADataItem.FPieStartAngle:=AStartAngle-90;
      ADataItem.FPieSweepAngle:=ADataItem.FDrawPercent*360;


      //填充
      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
      APathActionItem.ActionType:=patFillPath;

//      //获取区域,用于判断鼠标是否停靠
//      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
//      APathActionItem.ActionType:=patGetRegion;



        //圆弧中心点计算出来，这个位置要用来绘制数据标题
  //      ARad:=Math.DegToRad(AAngle);
  //      ARad:=Math.CycleToRad(AAngle);
  //      ARad:=Math.GradToRad(AAngle);
        ADataItem.FPieArcCenterAngle:=(AStartAngle-90+ADataItem.FDrawPercent*360/2);//中心点的坐标,所以角度要除以2
        ARad:=ADataItem.FPieArcCenterAngle*PI/180;

        //x都是弧度
        ACos:=Cos(ARad);
        ADataItem.FPieArcCenterPoint.X := FCircleCenterPoint.X + FRadius * ACos;
        ADataItem.FPieArcCenterPoint.Y := FCircleCenterPoint.Y + FRadius * Sin(ARad);


        //延伸线的点算出来
        ExPandLine(FCircleCenterPoint,ADataItem.FPieArcCenterPoint,20,ADataItem.FPieArcCenterExtendPoint);

        AItemCaptionWidth:=GetStringWidth(ADataItem.Caption,ASkinVirtualChartDefaultMaterial.FPieInfoCaptionParam.FontSize);
        AItemCaptionHeight:=GetStringHeight(ADataItem.Caption,ASkinVirtualChartDefaultMaterial.FPieInfoCaptionParam.FontSize);

        //延伸线横出来的点算出来
        if (ADataItem.FPieArcCenterAngle>=-90) and (ADataItem.FPieArcCenterAngle<90) then
        begin
          //横线往右
          ADataItem.FPieArcCenterExtendHorzPoint:=ADataItem.FPieArcCenterExtendPoint;
          ADataItem.FPieArcCenterExtendHorzPoint.X:=ADataItem.FPieArcCenterExtendHorzPoint.X+20;

          ADataItem.FCaptionRect.Left:=ADataItem.FPieArcCenterExtendHorzPoint.X
                                        //标题前空出一点
                                        +5;
          ADataItem.FCaptionRect.Right:=ADataItem.FCaptionRect.Left
                                        +AItemCaptionWidth;
        end
        else
        begin
          //横线往左
          ADataItem.FPieArcCenterExtendHorzPoint:=ADataItem.FPieArcCenterExtendPoint;
          ADataItem.FPieArcCenterExtendHorzPoint.X:=ADataItem.FPieArcCenterExtendHorzPoint.X-20;

          //
          ADataItem.FCaptionRect.Right:=ADataItem.FPieArcCenterExtendHorzPoint.X
                                        //标题前空出一点
                                        -8;
          ADataItem.FCaptionRect.Left:=ADataItem.FCaptionRect.Right
                                        -AItemCaptionWidth;

        end;
        ADataItem.FCaptionRect.Top:=ADataItem.FPieArcCenterExtendPoint.Y-AItemCaptionHeight/2;
        ADataItem.FCaptionRect.Bottom:=ADataItem.FPieArcCenterExtendPoint.Y+AItemCaptionHeight/2;






        AStartAngle:=AStartAngle+ADataItem.FDrawPercent*360;

  //      //绝对坐标
  //      OffsetRect(ADataItemPathRect,APathDrawRect.Left,APathDrawRect.Top);
  //      OffsetRect(ADataItemRect,APathDrawRect.Left,APathDrawRect.Top);
  //      ADataItem.FItemRect:=ADataItemRect;
  //      ADataItem.FItemDrawRect:=ADataItemRect;
  //      ADataItem.FBarPathDrawRect:=ADataItemPathRect;




  end;


end;

function TVirtualChartSeriesPieDrawer.GetDataItemColor(
  ADataItem: TVirtualChartSeriesDataItem): TDelphiColor;
var
  AColorIndex:Integer;
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin
  if ADataItem.Color=0 then
  begin
    //默认颜色
    ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);
    AColorIndex:=ADataItem.Index mod Length(ASkinVirtualChartDefaultMaterial.FSeriesColorArray);
    Result:=ASkinVirtualChartDefaultMaterial.FSeriesColorArray[AColorIndex];
  end
  else
  begin
    //
    Result:=ADataItem.Color;
  end;
end;

function TVirtualChartSeriesPieDrawer.GetPathDrawRect(ADrawRect: TRectF): TRectF;
var
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin
  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);

  //取最小的长度
  if ADrawRect.Width>ADrawRect.Height then
  begin
    FRadius:=ADrawRect.Height*ASkinVirtualChartDefaultMaterial.FPieRadiusPercent/2;
    FInnerRadius:=ADrawRect.Height*ASkinVirtualChartDefaultMaterial.FPieInnerSizePercent/2;
  end
  else
  begin
    FRadius:=ADrawRect.Width*ASkinVirtualChartDefaultMaterial.FPieRadiusPercent/2;
    FInnerRadius:=ADrawRect.Width*ASkinVirtualChartDefaultMaterial.FPieInnerSizePercent/2;
  end;

  Result.Left:=ADrawRect.Left+(ADrawRect.Width-FRadius*2)/2;
  Result.Top:=ADrawRect.Top+(ADrawRect.Height-FRadius*2)/2;
  Result.Right:=Result.Left+FRadius*2;
  Result.Bottom:=Result.Top+FRadius*2;

  FCircleCenterPoint.X:=Result.Left+Self.FRadius;
  FCircleCenterPoint.Y:=Result.Top+Self.FRadius;

end;

function GetAngle(ACircleCenterPoint:TPointF;APoint:TPointF):Double;
var
  x,y:Double;
  xC,yC:Double;
  distance:Double;
  xD:Double;
  mySin:Double;
  degree:Double;
begin
    Result:=0;

    x:=APoint.X;
    y:=APoint.Y;


    xC:=ACircleCenterPoint.X;
    yC:=ACircleCenterPoint.Y;


    // 计算控件距离圆心距离
    //CGFloat distance = sqrt(pow((x - xC), 2) + pow(y - yC, 2));
    distance:=Sqrt(Power(x-xC,2)+Power(y - yC,2));

//    CGFloat xD = (x - xC);
    xD := (x - xC);
//    CGFloat mySin = fabs(xD) / distance;
    mySin := abs(xD) / distance;
//    CGFloat degree;
    if (APoint.x < ACircleCenterPoint.x) then
    begin
        if (APoint.y < ACircleCenterPoint.y) then
        begin
//            degree := 360 - Math.asin(mySin) / PI * 180;
            degree := 360 - Math.ArcSin(mySin) / PI * 180;
        end
        else
        begin
            degree := Math.ArcSin(mySin) / PI * 180 + 180;
        end;
    end
    else
    begin
        if (APoint.y < ACircleCenterPoint.y) then
        begin
            degree := Math.ArcSin(mySin) / PI * 180;
        end
        else
        begin
            degree := 180 - Math.ArcSin(mySin) / PI * 180;
        end;
    end;
//    return degree;

    Result:=degree;


end;


function PtInPie(ACircleCenterPoint:TPointF;
                APoint:TPointF;
                ADataItem:TVirtualChartSeriesDataItem;
                ARadius:Double;
                AStartAngle:Double;
                ASweepAngle:Double): Boolean;
var
  ADistance:Double;
  AAngle:Double;
begin
  Result:=False;

  //先判断与圆心的距离,如果超了,肯定不在里面
  ADistance:=Sqrt(Power(ACircleCenterPoint.X-APoint.X,2)+Power(ACircleCenterPoint.Y-APoint.Y,2));
  if ADistance>ARadius then
  begin
    Exit;
  end;

  //再判断与圆心的角度,如果在扇形中,则在里面
  AAngle:=GetAngle(ACircleCenterPoint,APoint);
//  OutputDebugString('AAngle:'+FloatToStr(AAngle)+' AStartAngle:'+FloatToStr(AStartAngle)+' ASweepAngle:'+FloatToStr(ASweepAngle));

  if (AAngle>=AStartAngle) and (AAngle<=AStartAngle+ASweepAngle) then
  begin
    Result:=True;
  end;

end;

{ TVirtualChartSeriesLineDrawer }

function TVirtualChartSeriesLineDrawer.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData; const APathDrawRect: TRectF): Boolean;
var
  I: Integer;
var
//  ADrawRect:TRectF;
  X:Double;
  Y:Double;
  AXAxisSkinListBox:TSkinListBox;
  AYAxisSkinListBox:TSkinListBox;
  ASkinVirtualChartIntf:ISkinVirtualChart;
  ACaptionRect:TRectF;
  AItemWidth:Double;
var
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
//var
//  I:Integer;
var
  ADataItem:TVirtualChartSeriesDataItem;
  AItemEffectStates:TDPEffectStates;
  AOldColor:TDelphiColor;
  AItemCaptionWidth:Double;
  ALastItemCaptionDrawLeft:Double;
//  AItemPaintData:TPaintData;
//var
//  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin

  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(ASkinMaterial);
  ASkinVirtualChartIntf:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf;



//  PaintAxis(ACanvas,ASkinMaterial,ADrawRect,APaintData,APathDrawRect);


  Inherited;



  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(ASkinMaterial);

  //绘制线条
  for I := 0 to Self.FSeries.FDataItems.Count-1 do
  begin
    ADataItem:=Self.FSeries.FDataItems[I];

    if I+1<Self.FSeries.FDataItems.Count then
    begin
      AOldColor:=ASkinVirtualChartDefaultMaterial.FLineColorParam.Color.FColor;

      ASkinVirtualChartDefaultMaterial.FLineColorParam.Color.FColor:=Self.GetDataItemColor(ADataItem);
      ACanvas.DrawLine(ASkinVirtualChartDefaultMaterial.FLineColorParam,
                       APathDrawRect.Left+ADataItem.FLinePoint.X,
                       APathDrawRect.Top+ADataItem.FLinePoint.Y,
                       APathDrawRect.Left+Self.FSeries.FDataItems[I+1].FLinePoint.X,
                       APathDrawRect.Top+Self.FSeries.FDataItems[I+1].FLinePoint.Y
                        );

      ASkinVirtualChartDefaultMaterial.FLineColorParam.Color.FColor:=AOldColor;
    end;
    

    //给数据项加上状态
    AItemEffectStates:=Self.FSeries.FListLayoutsManager.ProcessItemDrawEffectStates(ADataItem);
    ASkinVirtualChartDefaultMaterial.FLineDotParam.StaticEffectStates:=AItemEffectStates;
//    ASkinVirtualChartDefaultMaterial.FBarColorParam.FillColor.FColor:=Self.GetDataItemColor(ADataItem);
//
//
//    //处理绘制参数的透明度
//    ASkinVirtualChartDefaultMaterial.FBarColorParam.DrawAlpha:=Ceil(ASkinVirtualChartDefaultMaterial.FBarColorParam.CurrentEffectAlpha*1);

//    AItemPaintData:=GlobalNullPaintData;
//    AItemPaintData.IsDrawInteractiveState:=True;
//    ProcessParamEffectStates(ASkinVirtualChartDefaultMaterial.FBarColorParam,
//                                1,
//                                AItemEffectStates,
//                                AItemPaintData
//                                );


    AOldColor:=ASkinVirtualChartDefaultMaterial.FBarColorParam.FillColor.FColor;

    ASkinVirtualChartDefaultMaterial.FLineDotParam.PenColor.FColor:=Self.GetDataItemColor(ADataItem);
    ACanvas.DrawPath(ASkinVirtualChartDefaultMaterial.FLineDotParam,APathDrawRect,ADataItem.FDrawPathActions);


    ASkinVirtualChartDefaultMaterial.FBarColorParam.FillColor.FColor:=AOldColor;

  end;

end;

procedure TVirtualChartSeriesLineDrawer.GenerateDrawPathList(
  APathDrawRect: TRectF);
var
  I: Integer;
//  ADataItemRect:TRectF;
//  ADataItemPathRect:TRectF;
  AVirtualChartSeriesList:TVirtualChartSeriesList;
  AXAxisSkinListBox:TSkinListBox;
  ALegendSkinListView:TSkinVirtualList;
  AItemWidth:Double;
  ALeft:Double;
  ADataItem:TVirtualChartSeriesDataItem;
  APathActionItem:TPathActionItem;
  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
begin
  Inherited;



  AVirtualChartSeriesList:=TVirtualChartSeriesList(Self.FSeries.Collection);

  AXAxisSkinListBox:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FXAxisSkinListBox;
  ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);

  ALegendSkinListView:=TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FLegendSkinListView;

  if ALegendSkinListView<>nil then
  begin
      ALegendSkinListView.Visible:=False;
      ALegendSkinListView.OnMouseOverItemChange:=nil;
      ALegendSkinListView.OnPrepareDrawItem:=nil;
  end;

  //然后生成柱子
  //需要最大值,计算出百分比
  ALeft:=0;
  for I := 0 to Self.FSeries.FDataItems.Count-1 do
  begin
      ADataItem:=Self.FSeries.FDataItems[I];


      ADataItem.FDrawPercent:=0;
      if (AVirtualChartSeriesList.FMaxValue-AVirtualChartSeriesList.FMinValue)>0 then
      begin
        ADataItem.FDrawPercent:=
              (ADataItem.Value-AVirtualChartSeriesList.FMinValue)/(AVirtualChartSeriesList.FMaxValue-AVirtualChartSeriesList.FMinValue);
      end;




      //横排的
      //生成Path列表
      //AItemWidth:=AXAxisSkinListBox.Prop.CalcItemWidth(AXAxisSkinListBox.Prop.Items[I]);
      AItemWidth:=APathDrawRect.Width / AXAxisSkinListBox.Prop.Items.Count;

//      //数据项所在的大矩形-相对坐标
//      ADataItemRect:=RectF(0,0,0,0);
//      ADataItemRect.Left:=ALeft;
//      ADataItemRect.Top:=0;
//      ADataItemRect.Right:=ALeft+AItemWidth;
//      ADataItemRect.Bottom:=APathDrawRect.Height;

      ADataItem.FLinePoint.X:=ALeft+AItemWidth/2;
      ADataItem.FLinePoint.Y:=APathDrawRect.Height*(1-ADataItem.FDrawPercent);



      //下一个Item的左边距
      ALeft:=ALeft+AItemWidth;



      ADataItem.FDrawPathActions.Clear;


//      ADataItemPathRect.Left:=ADataItemRect.Left+AItemWidth*(1-ABarSizePercent)/2;
//      ADataItemPathRect.Top:=ADataItemRect.Top+APathDrawRect.Height*(1-ADataItem.FDrawPercent);
//      ADataItemPathRect.Right:=ADataItemPathRect.Left+AItemWidth*ABarSizePercent;
//      ADataItemPathRect.Bottom:=ADataItemRect.Bottom;


      //生成圈的Path
      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
      APathActionItem.ActionType:=patAddEllipse;
      APathActionItem.X:=ADataItem.FLinePoint.X-ASkinVirtualChartDefaultMaterial.FLineDotRadius;
      //这个柱状图是从底部上来的
      APathActionItem.Y:=ADataItem.FLinePoint.Y-ASkinVirtualChartDefaultMaterial.FLineDotRadius;
      APathActionItem.X1:=ADataItem.FLinePoint.X+ASkinVirtualChartDefaultMaterial.FLineDotRadius;
      APathActionItem.Y1:=ADataItem.FLinePoint.Y+ASkinVirtualChartDefaultMaterial.FLineDotRadius;

      ADataItem.FLineDotRect.Left:=APathDrawRect.Left+APathActionItem.X;
      ADataItem.FLineDotRect.Top:=APathDrawRect.Top+APathActionItem.Y;
      ADataItem.FLineDotRect.Right:=APathDrawRect.Left+APathActionItem.X1;
      ADataItem.FLineDotRect.Bottom:=APathDrawRect.Top+APathActionItem.Y1;


//      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
//      APathActionItem.ActionType:=patGetRegion;

      //填充
      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
      APathActionItem.ActionType:=patFillPath;

      APathActionItem:=TPathActionItem(ADataItem.FDrawPathActions.Add);
      APathActionItem.ActionType:=patDrawPath;




//      //绝对坐标
//      OffsetRect(ADataItemPathRect,APathDrawRect.Left,APathDrawRect.Top);
//      OffsetRect(ADataItemRect,APathDrawRect.Left,APathDrawRect.Top);
//      ADataItem.FItemRect:=ADataItemRect;
//      ADataItem.FItemDrawRect:=ADataItemRect;
//      ADataItem.FBarPathDrawRect:=ADataItemPathRect;



  end;


end;

//function TVirtualChartSeriesLineDrawer.GetDataItemColor(ADataItem: TVirtualChartSeriesDataItem): TDelphiColor;
//var
//  ASkinVirtualChartDefaultMaterial:TSkinVirtualChartDefaultMaterial;
//begin
//  if ADataItem.Color=0 then
//  begin
//    //默认颜色
//    ASkinVirtualChartDefaultMaterial:=TSkinVirtualChartDefaultMaterial(TVirtualChartSeriesList(Self.FSeries.Collection).FSkinVirtualChartIntf.Properties.FSkinControlIntf.GetCurrentUseMaterial);
//    Result:=ASkinVirtualChartDefaultMaterial.BarColorParam.FillColor.Color;
//  end
//  else
//  begin
//    //
//    Result:=ADataItem.Color;
//  end;
//
//
//end;

end.




