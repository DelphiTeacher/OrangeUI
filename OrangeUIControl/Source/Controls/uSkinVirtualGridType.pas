//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     虚拟表格
///   </para>
///   <para>
///     Virtual Grid
///   </para>
/// </summary>
unit uSkinVirtualGridType;

interface
{$I FrameWork.inc}

{$I Version.inc}


uses
  Classes,
  SysUtils,
  Types,
  DateUtils,
  Math,

  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  StdCtrls,
  Dialogs,
  uSkinWindowsEdit,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,

  FMX.Edit,
  FMX.ListBox,
  uSkinFireMonkeyEdit,
  {$ENDIF}


  uFuncCommon,
  uSkinAnimator,
  uBaseList,
  uBinaryObjectList,
  uBaseLog,
  uSkinItems,
  uSkinListLayouts,
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
  uDrawPathParam,
  uSkinImageList,
  uSkinCustomListType,
  uSkinCheckBoxType,
  uSkinControlGestureManager,
  uSkinScrollControlType,
//  uSkinCustomListType,
  uSkinItemDesignerPanelType,
  {$IFDEF FMX}
  uSkinFireMonkeyItemDesignerPanel,
  {$ENDIF}

  uSkinListBoxType,

  uDrawPictureParam;




const
  IID_ISkinVirtualGrid:TGUID='{06786B16-959B-49B5-A48A-227F76786231}';



const
  //默认行高
  Const_DefaultRowHeight=30;
  //默认表格列宽
  Const_DefaultColumnWidth=100;
  //默认表头高度
  Const_DefaultColumnHeaderHeight=40;
  //默认指示列宽
  Const_DefaultIndicatorWidth=20;




type
  TSkinVirtualGridRow=class;
  TSkinVirtualGridRows=class;
  TSkinVirtualGridColumn=class;
  TSkinVirtualGridColumns=class;

  TVirtualGridProperties=class;
  
  TSkinVirtualGridColumnMaterial=class;
  TSkinVirtualGridColumnMaterialClass=class of TSkinVirtualGridColumnMaterial;


  TSkinVirtualGridColumnClass=class of TSkinVirtualGridColumn;
  TSkinVirtualGridColumnsClass=class of TSkinVirtualGridColumns;


  TSkinVirtualGridDefaultMaterial=class;


  //单元格点击事件
  TGridClickCellEvent=procedure(Sender:TObject;
                                ACol:TSkinVirtualGridColumn;
                                ARow:TBaseSkinItem
                                ) of object;
  TGridClickColumnEvent=procedure(Sender:TObject;
                                ACol:TSkinVirtualGridColumn
                                ) of object;
  //获取单元格自定义编辑控件的事件
  TGetGridCellEditControlEvent=procedure(Sender:TObject;
                                          ACol:TSkinVirtualGridColumn;
                                          ARow:TBaseSkinItem;
                                          var AEditControl:TControl
                                          ) of object;
  //单元格绘制开始事件,准备素材和设计面板
  TGridCustomPaintCellBeginEvent=procedure(
                                        ACanvas: TDrawCanvas;
                                        ARowIndex:Integer;
                                        ARow:TBaseSkinItem;
                                        ARowDrawRect:TRectF;
                                        AColumn:TSkinVirtualGridColumn;
                                        AColumnIndex:Integer;
                                        ACellDrawRect:TRectF;
                                        ARowEffectStates:TDPEffectStates;
                                        ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                        ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                                        ASkinItemColDesignerPanel:TSkinItemDesignerPanel;
                                        const ADrawRect: TRectF;
                                        AVirtualGridPaintData:TPaintData
                                        ) of object;

  //获取单元格的自定义显示文本
  TGetGridCellDisplayTextEvent=procedure(Sender:TObject;
                                        ACol:TSkinVirtualGridColumn;
                                        ARow:TBaseSkinItem;
                                        var ADisplayText:String) of object;
  //获取统计栏单元格的自定义显示文本
  TGetGridFooterCellDisplayTextEvent=procedure(Sender:TObject;
                                                ACol:TSkinVirtualGridColumn;
                                                AFooterRowIndex:Integer;
                                                var ADisplayText:String) of object;


//  TVirtualGridPrepareDrawCellEvent=procedure(Sender:TObject;
//                                      ACanvas:TDrawCanvas;
//                                      AItemDesignerPanel:TItemDesignerPanel;
//                                      AItem:TSkinItem;
//                                      ACol:TSkinVirtualGridColumn;
//                                      AItemDrawRect:TRect;
//                                      ACellDrawRect:TRect) of object;




  ISkinVirtualGrid=interface//(ISkinScrollControl)
    ['{06786B16-959B-49B5-A48A-227F76786231}']
    function GetOnClickCell:TGridClickCellEvent;
    function GetOnGetCellDisplayText:TGetGridCellDisplayTextEvent;
    function GetOnGetCellEditControl:TGetGridCellEditControlEvent;
    function GetOnGetFooterCellDisplayText:TGetGridFooterCellDisplayTextEvent;
    function GetOnCustomPaintCellBegin:TGridCustomPaintCellBeginEvent;
    function GetOnCustomPaintCellEnd:TGridCustomPaintCellBeginEvent;


//    function GetColumnHeader:TSkinListBox;
//    procedure SyncColumnHeader;

    //单元格点击事件
    property OnClickCell:TGridClickCellEvent read GetOnClickCell;
    //获取单元格显示文本
    property OnGetCellDisplayText:TGetGridCellDisplayTextEvent read GetOnGetCellDisplayText;// write SetOnGetDisplayText;
    //获取编辑单元格的控件
    property OnGetCellEditControl:TGetGridCellEditControlEvent read GetOnGetCellEditControl;// write SetOnGetCellEditControl;
    //获取统计栏显示文本
    property OnGetFooterCellDisplayText:TGetGridFooterCellDisplayTextEvent read GetOnGetFooterCellDisplayText;// write SetOnGetDisplayText;
    //准备绘制单元格
    property OnCustomPaintCellBegin:TGridCustomPaintCellBeginEvent read GetOnCustomPaintCellBegin;
    property OnCustomPaintCellEnd:TGridCustomPaintCellBeginEvent read GetOnCustomPaintCellEnd;



    function GetVirtualGridProperties:TVirtualGridProperties;
    property Properties:TVirtualGridProperties read GetVirtualGridProperties;
    property Prop:TVirtualGridProperties read GetVirtualGridProperties;
  end;








  //统计类型
  TSkinGridFooterValueType=(
                            //不显示统计
                            fvtNone,
                            //求和
                            fvtSum,
                            //固定
                            fvtStatic,
                            //个数
                            fvtCount,
                            //平均值
                            fvtAverage
                            );
  //表格列统计
  TSkinVirtualGridFooter=class(TPersistent)
  protected
    FOwner:TSkinVirtualGridColumn;


    FStaticValue: String;
    FSumValue:Double;
    FAverageValue:Double;
    FValueType: TSkinGridFooterValueType;
    FValueFormat: String;
    FRecordCount: Integer;

    procedure DoChange;
    procedure DoInvalidate;

    function GetValue: String;
    procedure SetStaticValue(const Value: String);
    procedure SetValueType(const Value: TSkinGridFooterValueType);
    procedure SetValueFormat(const Value: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner:TSkinVirtualGridColumn);
    destructor Destroy;override;
  public
    //统计值,比如0.99,FValueType为Sum时使用
    property SumValue:Double read FSumValue write FSumValue;
    //平均值,FValueType为Average时使用
    property AverageValue:Double read FAverageValue write FAverageValue;
    //显示值,比如99%,FValueType为Static时使用
    property StaticValue:String read FStaticValue write FStaticValue;
    //记录数,FValueType为Count时使用
    property RecordCount:Integer read FRecordCount write FRecordCount;
  published
    //显示值
    property Value:String read GetValue write SetStaticValue;
    //统计值的格式
    property ValueFormat:String read FValueFormat write SetValueFormat;
    //统计类型
    property ValueType:TSkinGridFooterValueType read FValueType write SetValueType;
  end;





  //表格列的内容类型,用于确定如何绘制单元格
//  TSkinGridColumnContentType=(cctText,
//                              cctCheckBox,
//                              cctPicture
//                              );
//  TSkinGridColumnContentTypes=set of TSkinGridColumnContentType;

  TSkinVirtualGridFooterClass=class of TSkinVirtualGridFooter;










  //表格列
  TSkinVirtualGridColumn=class(TCollectionItem,ISkinItem,IInterface)
  private
    //IInterface接口
    FOwnerInterface: IInterface;
//    function GetContentTypes: TSkinGridColumnContentTypes;
  protected
    { IInterface }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    procedure AfterConstruction; override;
  protected
    //自动计算时的内容宽度
    FCalcedAutoSizeWidth:TControlSize;

    //是否只读
    FReadonly: Boolean;
    //可选值列表,编辑单元格的时候,下拉框选择值
    FPickList: TStrings;
    function GetPickList: TStrings;
    procedure SetPickList(Value: TStrings);
  protected

    //ISkinItem接口需要,用于排列
    //宽度
    FWidth: Double;
    //是否显示
    FVisible:Boolean;
    FSelected:Boolean;

    //所在的位置
    FItemRect:TRectF;
    //绘制矩形
    FItemDrawRect:TRectF;

    //自适应尺寸
    FAutoSize:Boolean;
    FAutoSizeMinWidth:TControlSize;

    FSkinListIntf:ISkinList;

    //宽度
    function GetWidth: Double;virtual;
    //表格列头的高度都是统一的
    function GetHeight: Double;
    //层级
    function GetLevel:Integer;
    function GetVisible: Boolean;
    function GetObject:TObject;
    function GetSelected: Boolean;
    procedure SetItemRect(Value:TRectF);
    function GetItemRect:TRectF;
    function GetItemDrawRect:TRectF;
    procedure SetItemDrawRect(Value:TRectF);
    function GetIsRowEnd:Boolean;
    function GetThisRowItemCount:Integer;
    procedure SetSkinListIntf(ASkinListIntf:ISkinList);
    function GetListLayoutsManager:TSkinListLayoutsManager;

    procedure ClearItemRect;
    //鼠标是否在Item里面
    function PtInItem(APoint:TPointF):Boolean;
  protected
    //标题
    FCaption:String;
    procedure SetVisible(const Value: Boolean);
    procedure SetCaption(const Value: String);

    //DBGrid要扩展,默认显示字段名FieldName
    function GetCaption: String;virtual;
    //DBGrid要扩展
    procedure SetWidth(const Value: Double);virtual;

  protected
    //属性更改
    procedure DoPropChange(Sender:TObject=nil);virtual;
    //尺寸更改
    procedure DoSizeChange;virtual;
    //可视化更改
    procedure DoVisibleChange;virtual;
  protected
    //风格与素材
    FDefaultItemStyleSetting:TListItemTypeStyleSetting;
    //引用素材
//    FRefMaterial: TSkinVirtualGridColumnMaterial;
//    FMaterialUseKind: TMaterialUseKind;
    FMaterial: TSkinVirtualGridColumnMaterial;
    FCurrentUseSkinMaterial: TSkinVirtualGridColumnMaterial;
    FIsUseDefaultGridColumnMaterial:Boolean;
    FIsUseDefaultGridColumnCaptionParam:Boolean;
//    FIsUseDefaultGridColumnCellTextParam: Boolean;
//    FIsUseDefaultGridColumnCellText1Param: Boolean;
    procedure SetIsUseDefaultGridColumnCaptionParam(const Value: Boolean);
//    procedure SetIsUseDefaultGridColumnCellText1Param(const Value: Boolean);
//    procedure SetIsUseDefaultGridColumnCellTextParam(const Value: Boolean);
//    procedure SetRefMaterial(const Value: TSkinVirtualGridColumnMaterial);virtual;
//    procedure SetMaterialUseKind(const Value: TMaterialUseKind);
    procedure SetSelfOwnMaterial(const Value: TSkinVirtualGridColumnMaterial);
//    procedure UnUseCurrentUseMaterial;
//    function GetCurrentUseMaterial: TSkinVirtualGridColumnMaterial;
    procedure SetIsUseDefaultGridColumnMaterial(const Value: Boolean);
    function GetColumnMaterialClass:TSkinVirtualGridColumnMaterialClass;virtual;

  protected
    function GetDefaultItemStyle: String;
    procedure SetDefaultItemStyle(const Value: String);
    procedure SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
    function GetItemDesignerPanel: TSkinItemDesignerPanel;
  protected
    //设置CollectionItem设计时显示的名称
    function GetDisplayName: string; override;
    procedure SetDisplayName(const Value: string); override;
  protected
    function GetFooterClass:TSkinVirtualGridFooterClass;virtual;

    procedure SetFooter(const Value: TSkinVirtualGridFooter);

    function GetFooterStaticValue: String;
    function GetFooterValueType: TSkinGridFooterValueType;
    procedure SetFooterStaticValue(const Value: String);
    procedure SetFooterValueType(const Value: TSkinGridFooterValueType);
    function GetFooterValueFormat: String;
    procedure SetFooterValueFormat(const Value: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure DoNewListItemStyleFrameCacheInit(Sender:TObject;AListItemTypeStyleSetting:TListItemTypeStyleSetting;ANewListItemStyleFrameCache:TListItemStyleFrameCache);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  public
    //统计
    FFooter:TSkinVirtualGridFooter;

    //获取表格列的内容类型(默认是文本,勾选框CheckBox,图片),根据内容类型来绘制单元格
    //function GetContentTypes:TSkinGridColumnContentTypes;virtual;
    function GetValueType(ARow:TBaseSkinItem):TVarType;virtual;
    function GetValueType1(ARow:TBaseSkinItem):TVarType;virtual;

    function GetBindItemFieldName: String;virtual;
    function GetBindItemFieldName1: String;virtual;

  public

    //所属列表
    function Owner:TSkinVirtualGridColumns;
    //当前使用的素材
//    property CurrentUseMaterial:TSkinVirtualGridColumnMaterial read GetCurrentUseMaterial;
    property Material:TSkinVirtualGridColumnMaterial read FMaterial;
  published
    //设置默认列表项的风格
    property DefaultItemStyle:String read GetDefaultItemStyle write SetDefaultItemStyle;
    property ItemDesignerPanel: TSkinItemDesignerPanel read GetItemDesignerPanel write SetItemDesignerPanel;

    //列标题
    property Caption: String read GetCaption write SetCaption;
    //宽度,如果为-1,表示使用默认宽度
    property Width:Double read FWidth write SetWidth;
    //是否显示
    property Visible:Boolean read FVisible write SetVisible;
    //是否只读(不允许编辑)
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    //下拉选项
    property PickList: TStrings read GetPickList write SetPickList;

    //自适应宽度
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property AutoSizeMinWidth: TControlSize read FAutoSizeMinWidth write FAutoSizeMinWidth;

    //统计
    property Footer:TSkinVirtualGridFooter read FFooter write SetFooter;
    property FooterValue:String read GetFooterStaticValue write SetFooterStaticValue;
    property FooterValueType:TSkinGridFooterValueType read GetFooterValueType write SetFooterValueType;
    property FooterValueFormat:String read GetFooterValueFormat write SetFooterValueFormat;


    //是否使用表格默认的列素材
    property IsUseDefaultGridColumnMaterial:Boolean read FIsUseDefaultGridColumnMaterial write SetIsUseDefaultGridColumnMaterial;

    //是否使用表格默认列素材的列标题绘制参数
    property IsUseDefaultGridColumnCaptionParam:Boolean read FIsUseDefaultGridColumnCaptionParam write SetIsUseDefaultGridColumnCaptionParam;
//    property IsUseDefaultGridColumnCellTextParam:Boolean read FIsUseDefaultGridColumnCellTextParam write SetIsUseDefaultGridColumnCellTextParam;
//    property IsUseDefaultGridColumnCellText1Param:Boolean read FIsUseDefaultGridColumnCellText1Param write SetIsUseDefaultGridColumnCellText1Param;


//    //绘制的素材
//    property RefMaterial:TSkinVirtualGridColumnMaterial read FRefMaterial write SetRefMaterial;
//    //素材使用类型
//    property MaterialUseKind:TMaterialUseKind read FMaterialUseKind write SetMaterialUseKind;
    //自带素材
    property SelfOwnMaterial:TSkinVirtualGridColumnMaterial read FMaterial write SetSelfOwnMaterial;
  end;




  //表格列列表
  TSkinVirtualGridColumns=class(TCollection,ISkinList)
  private
    FOwnerInterface: IInterface;
  protected
    { IInterface }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    procedure AfterConstruction; override;
  protected
    FIsDestroying:Boolean;

    function GetItem(Index: Integer): TSkinVirtualGridColumn;
    procedure SetItem(Index: Integer; const Value: TSkinVirtualGridColumn);

    //添加列之后调用
    procedure Added(var Item: TCollectionItem); override;
    //删除列之后调用
    procedure Deleting(Item: TCollectionItem); override;
    //列释放或添加,或插入删除之后调用
    procedure Update(Item: TCollectionItem); override;
  protected
    //ISkinList接口的实现
    //布局管理(调用它的事件,来通知是否需要重新计算内容)
    FListLayoutsManager:TSkinListLayoutsManager;


    //停止更改调用的次数
    FUpdateCount: Integer;

    //更新个数
    function GetUpdateCount:Integer;
    //获取某一项
    function GetSkinItem(const Index:Integer):ISkinItem;
    function GetSkinObject(const Index:Integer):TObject;
    //获取个数
    function GetCount:Integer;
    //获取下标
    function IndexOf(AObject:TObject):Integer;
    function GetObject:TObject;
  public
    //调用DoItemVisibleChange
    procedure DoChange;//override;
    //调用DoItemVisibleChange
//    procedure EndUpdate(AIsForce:Boolean=False);//override;
    //开始更新
    procedure BeginUpdate;override;
    //结束更新
    procedure EndUpdate;override;
    //设置布局排列
    procedure SetListLayoutsManager(ALayoutsManager:TSkinListLayoutsManager);virtual;
    function GetListLayoutsManager:TSkinListLayoutsManager;
  public
    function Add:TSkinVirtualGridColumn;overload;
    function FindByCaption(ACaption:String):TSkinVirtualGridColumn;
  public
    //控件
    FVirtualGridProperties:TVirtualGridProperties;
    //AProperties控件设计器需要
    constructor Create(AProperties:TVirtualGridProperties;
                        ItemClass: TCollectionItemClass);virtual;
    destructor Destroy;override;
  public
    //表格列
    property Items[Index:Integer]:TSkinVirtualGridColumn read GetItem write SetItem;default;
  end;



//  TSkinColumnItem=class(TSkinItem)
//
//  end;

  
  //表格列布局类型
  TSkinVirtualGridColumnLayoutsManager=class(TSkinListLayoutsManager)
  protected
//    //处理不绘制超出的列
//    procedure CalcDrawStartAndEndIndex(
//                                      //滚动条位置
//                                      ADrawLeftOffset,
//                                      ADrawTopOffset:TControlSize;
//                                      //控件的尺寸,可以自定义
//                                      AControlWidth,AControlHeight:TControlSize;
//                                      var ADrawStartIndex:Integer;
//                                      var ADrawEndIndex:Integer);override;

  end;





  //表格数据行
  TSkinVirtualGridRow=class(TBaseSkinItem)
  protected
    //表格列的总宽度
    function GetWidth: Double;override;
  end;

  //表格数据行列表
  TSkinVirtualGridRows=class(TBaseSkinItems)
  public
    procedure DoAdd(AObject:TObject);override;
  public
    //添加数据行
    function Add:TSkinVirtualGridRow;overload;
    /// <summary>
    ///   <para>
    ///     结束更新,调用DoChange
    ///   </para>
    ///   <para>
    ///     End update
    ///   </para>
    /// </summary>
    procedure EndUpdate(AIsForce:Boolean=False);override;
  public
    //创建列表项
    function GetSkinItemClass:TBaseSkinItemClass;override;
  end;


  //表格数据行布局类型
  TSkinVirtualGridRowLayoutsManager=class(TSkinCustomListLayoutsManager)
  public
    //用于获取表格列的总宽度
    FVirtualGridProperties:TVirtualGridProperties;
  end;




//  TSkinGridOption = (
////    dgEditing,
////    sdgAlwaysShowEditor,
////    sdgTitles,
////    sdgIndicator,
////    sdgColumnResize,
////    sdgColLines,
////    sdgRowLines,
////    sdgTabs,
//    sdgRowSelect,
////    sdgAlwaysShowSelection,
////    sdgConfirmDelete,
////    sdgCancelOnExit,
//    sdgMultiSelect//,
////    sdgTitleClick//,
////    sdgTitleHotTrack
//    );
//  TSkinDBGridOptions = set of TSkinGridOption;




  //列表项列表
  TVirtualGridProperties=class(TCustomListProperties)
  protected

    //固定列数
    FFixedCols: Integer;
    //指示列的宽度
    FIndicatorWidth:Double;

    //统计行高度
    FFooterRowHeight:Double;
    //统计行的行数
    FFooterRowCount:Integer;

    //表格列
    FColumns:TSkinVirtualGridColumns;
    //表格列布局类型
    FColumnLayoutsManager:TSkinListLayoutsManager;

    //是否是行选择
    FIsRowSelect:Boolean;

    //是否只读
    FReadOnly: Boolean;


    FSkinVirtualGridIntf:ISkinVirtualGrid;

    procedure SetIsRowSelect(const Value: Boolean);

    function GetItems: TSkinVirtualGridRows;
    procedure SetItems(const Value: TSkinVirtualGridRows);

    procedure SetColumns(const Value: TSkinVirtualGridColumns);
    function GetRowHeight: Double;
    procedure SetRowHeight(const Value: Double);

    //设置表头高
    function GetColumnsHeaderHeight: Double;
    procedure SetColumnsHeaderHeight(const Value: Double);
    //设置行头指示宽
    procedure SetIndicatorWidth(const Value: Double);
    //设置固定列
    procedure SetFixedCols(const Value: Integer);
    procedure SetFooterRowCount(const Value: Integer);
    procedure SetFooterRowHeight(const Value: Double);
    //获取实际固定列的个数
    function GetRealFixedColCount:Integer;
    //获取实际固定列的绘制宽度
    function GetRealFixedColsDrawRight:Double;
  protected
    //绘制列头需要,没有去除左边提示列
    function GetContentRect_Header:TRectF;virtual;


    //表格列头的区域,去除左边指示列
    function GetClientRect_ColumnHeader:TRectF;virtual;
    //活动列的区域
    function GetClientRect_ColumnHeader_UnfixedCols:TRectF;virtual;


    //绘制指示列需要,没有去除左边提示列,去除底部统计行
    function GetClientRect_Grid:TRectF;virtual;


    //单元格的区域
    function GetClientRect_Cells:TRectF;virtual;
    //固定列单元格的区域
    function GetClientRect_Cells_FixedCols:TRectF;virtual;
    //活动列的单元格区域
    function GetClientRect_Cells_UnfixedCols:TRectF;virtual;


    //统计行
    function GetClientRect_Footer:TRectF;virtual;
    //统计行的固定列单元格
    function GetClientRect_Footer_UnfixedCols:TRectF;virtual;


    //绘制统计行需要
    function GetContentRect_Footer:TRectF;virtual;
    function FooterRowRect(AFooterRowIndex:Integer): TRectF;

    //获取行的固定列区域部分
    function GetRowDrawRect_FixedCols(ADrawRect:TRectF;ARowDrawRect:TRectF):TRectF;
    //获取行的不固定列区域部分
    function GetRowDrawRect_UnfixedCols(ADrawRect:TRectF;ARowDrawRect:TRectF):TRectF;


    procedure UpdateFooterRow;virtual;
  public
    //顶部间距,表头的高度
    function GetItemTopDrawOffset:Double;override;

    //计算内容尺寸(用于处理滚动条的Max)
    function CalcContentWidth:Double;override;
    function CalcContentHeight:Double;override;
  protected
    //当前点击选中的单元格
    FClickedCellCol:TSkinVirtualGridColumn;

    //当前编辑的单元格
    FEditingCellCol:TSkinVirtualGridColumn;

    //自动创建的编辑控件
    FAutoCreatedEditControl:TControl;

    //点击表格行,实现点击单元格的效果,或者单元格编辑
    procedure DoClickItem(ARow:TBaseSkinItem;X:Double;Y:Double);override;
    //点击单元格
    procedure DoClickCell(ARow:TBaseSkinItem;ACol:TSkinVirtualGridColumn);virtual;

    //根据表格列自动创建对应的编辑控件,是下拉框还是编辑框
    function AutoCreateEditControl(ACol:TSkinVirtualGridColumn):TControl;virtual;

//    //单元格是否允许编辑
//    function CanEditCell(ACol:TSkinVirtualGridColumn;
//                          ARow:TBaseSkinItem
//                          ):Boolean;virtual;

    //结束编辑的时候把编辑框的值赋给Item的属性
    procedure DoSetValueToEditingItem;override;
    //结束编辑时调用,清空一些变量
    procedure DoStopEditingItemEnd;override;
  public
    //编辑单元格
    procedure StartEditingCell(AItem:TBaseSkinItem;
                                ACol:TSkinVirtualGridColumn;
                                X:Double;Y:Double;
                                AItemDesignerPanelEditControl:TControl=nil);
  protected
    //获取表格数据行的列表类
    function GetItemsClass:TBaseSkinItemsClass;override;
    //获取表格数据行的列表布局管理者
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;override;

    //创建列管理
    function GetColumnClass:TSkinVirtualGridColumnClass;virtual;
    function GetColumnsClass:TSkinVirtualGridColumnsClass;virtual;
    //获取表格列排列管理类
    function GetColumnLayoutsManagerClass:TSkinListLayoutsManagerClass;virtual;
  protected

//    //列表更改事件
//    procedure DoItemsChange(Sender:TObject);override;
//    //列表项删除事件
//    procedure DoItemDelete(Sender:TObject;AItem:TObject;AIndex:Integer);override;


    //ListLayoutsManager传递出的列表项尺寸更改事件(需要重新计算内容尺寸,重绘列表)
    procedure DoColumnSizeChange(Sender:TObject);
    //ListLayoutsManager传递出的列表项隐藏显示更改事件(需要重新计算内容尺寸,重绘列表)
    procedure DoColumnVisibleChange(Sender:TObject);


  protected
    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;

//    //每次绘制列表项之前准备,调用OnPrepareDrawItem事件
//    //因为每次绘制时调用OnPrepareDrawItem事件非常耗时,因此当启用缓存的时候,不需要每次都调用它,提高效率
//    procedure CallOnPrepareDrawItemEvent(
//                  Sender:TObject;
//                  ACanvas:TDrawCanvas;
//                  AItem:TBaseSkinItem;
//                  AItemDrawRect:TRectF;
//                  AIsDrawItemInteractiveState:Boolean);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //列表项所在的绘制矩形
    function VisibleColumnDrawRect(AVisibleColumnIndex:Integer): TRectF;overload;
    //获取列表项所在的区域
    function VisibleColumnDrawRect(AVisibleColumn:TSkinVirtualGridColumn): TRectF;overload;

    function VisibleColumnRect(AVisibleColumnIndex:Integer): TRectF;overload;
    function VisibleColumnRect(AVisibleColumn:TSkinVirtualGridColumn): TRectF;overload;

//    function ColumnAt(X,Y:Double):TSkinVirtualGridColumn;overload;
    //仅需要X坐标就可以了,如果存在Y,那么当HeaderHeight为0时,就判断不出来了
    function ColumnAt(X:Double):TSkinVirtualGridColumn;overload;

    //获取单元格绘制矩形
    function GetCellDrawRect(ACol:TSkinVirtualGridColumn;ARow:TBaseSkinItem):TRectF;

  public
    procedure CalcAutoSizeColumnWidth;

    //获取指定单元格的文本
    function GetGridCellText(ACol:TSkinVirtualGridColumn;
                            ARow:TBaseSkinItem
                            ):String;virtual;
    function GetGridCellText1(ACol:TSkinVirtualGridColumn;
                            ARow:TBaseSkinItem
                            ):String;virtual;

    function GetCellValueType(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem
                              ):TVarType;
    function GetCellValue1Type(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem
                              ):TVarType;

    function GetCellValue(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem
                              ):Variant;virtual;
    function GetCellValueObject(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem
                              ):TObject;virtual;


    function GetCellValue1(ACol:TSkinVirtualGridColumn;
                                ARow:TBaseSkinItem
                                ):Variant;virtual;
    function GetCellValue1Object(ACol:TSkinVirtualGridColumn;
                                ARow:TBaseSkinItem
                                ):TObject;virtual;

    //设置单元格的值
    procedure SetGridCellValue(ACol:TSkinVirtualGridColumn;
                                ARow:TBaseSkinItem;
                                AValue:Variant
                                );virtual;
//    //获取指定单元格是否勾选
//    function GetGridCellChecked(ACol:TSkinVirtualGridColumn;
//                                ARow:TBaseSkinItem
//                                ):Boolean;virtual;
  public
    //测试属性
    FIsNeedClip:Boolean;


    //当前编辑的单元格列
    property EditingCol:TSkinVirtualGridColumn read FEditingCellCol;



    //选择的文本
    function SelectedText:String;

    //表格列布局管理
    property ColumnLayoutsManager:TSkinListLayoutsManager read FColumnLayoutsManager;

    //表格数据行
    property Items:TSkinVirtualGridRows read GetItems write SetItems;

  published
    //是否是只读的,不可以编辑
    property ReadOnly:Boolean read FReadOnly write FReadOnly;

    //是否是行选择
    property IsRowSelect:Boolean read FIsRowSelect write SetIsRowSelect;

    //表格列
    property Columns:TSkinVirtualGridColumns read FColumns write SetColumns;

    //固定列个数
    property FixedCols:Integer read FFixedCols write SetFixedCols;

    //表格表头高度
    property ColumnsHeaderHeight:Double read GetColumnsHeaderHeight write SetColumnsHeaderHeight stored True nodefault;
    //行高
    property RowHeight:Double read GetRowHeight write SetRowHeight;
    //指示宽度
    property IndicatorWidth:Double read FIndicatorWidth write SetIndicatorWidth;

    //统计行
    property FooterRowCount:Integer read FFooterRowCount write SetFooterRowCount;
    //统计行行高
    property FooterRowHeight:Double read FFooterRowHeight write SetFooterRowHeight;


  end;







  //表格列的绘制参数
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinVirtualGridColumnMaterial=class(TSkinControlMaterial)
  private
    //表格列标题绘制参数
    FDrawCaptionParam:TDrawTextParam;




    //单元格文本绘制参数
    FDrawCellTextParam:TDrawTextParam;
    //页脚文本绘制参数
    FDrawFooterCellTextParam:TDrawTextParam;
    //单元格图片绘制参数(如果是图片)
    FDrawCellPictureParam: TDrawPictureParam;

    FDrawCellText1Param:TDrawTextParam;
    procedure SetDrawCellText1Param(const Value: TDrawTextParam);
    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawCellTextParam(const Value: TDrawTextParam);
    procedure SetDrawFooterCellTextParam(const Value: TDrawTextParam);
    procedure SetDrawCellPictureParam(const Value: TDrawPictureParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //表格列标题绘制参数
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
    //单元格文本绘制参数
    property DrawCellTextParam:TDrawTextParam read FDrawCellTextParam write SetDrawCellTextParam;
    //单元格图片绘制参数
    property DrawCellPictureParam:TDrawPictureParam read FDrawCellPictureParam write SetDrawCellPictureParam;
    //统计单元格文本绘制参数
    property DrawFooterCellTextParam:TDrawTextParam read FDrawFooterCellTextParam write SetDrawFooterCellTextParam;
    //单元格文本绘制参数
    property DrawCellText1Param:TDrawTextParam read FDrawCellText1Param write SetDrawCellText1Param;
  end;





  //分隔线绘制参数
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinCellDevideMaterial=class(TSkinMaterial)
  private
    FDrawRowLineParam: TDrawLineParam;
    FDrawColLineParam: TDrawLineParam;
    FIsDrawColEndLine: Boolean;
    FIsDrawRowEndLine: Boolean;
    FIsDrawColBeginLine: Boolean;
    FIsDrawRowBeginLine: Boolean;
    FIsDrawColLine: Boolean;
    FIsDrawRowLine: Boolean;
    procedure SetDrawColLineParam(const Value: TDrawLineParam);
    procedure SetDrawRowLineParam(const Value: TDrawLineParam);
    procedure SetIsDrawColBeginLine(const Value: Boolean);
    procedure SetIsDrawColEndLine(const Value: Boolean);
    procedure SetIsDrawRowBeginLine(const Value: Boolean);
    procedure SetIsDrawRowEndLine(const Value: Boolean);
    procedure SetIsDrawColLine(const Value: Boolean);
    procedure SetIsDrawRowLine(const Value: Boolean);
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
    //是否绘制行分隔线
    property IsDrawRowLine:Boolean read FIsDrawRowLine write SetIsDrawRowLine;
    //是否绘制开始行分隔线
    property IsDrawRowBeginLine:Boolean read FIsDrawRowBeginLine write SetIsDrawRowBeginLine;
    //是否绘制结束行分隔线
    property IsDrawRowEndLine:Boolean read FIsDrawRowEndLine write SetIsDrawRowEndLine;

    //是否绘制列分隔线
    property IsDrawColLine:Boolean read FIsDrawColLine write SetIsDrawColLine;
    //是否绘制开始列分隔线
    property IsDrawColBeginLine:Boolean read FIsDrawColBeginLine write SetIsDrawColBeginLine;
    //是否绘制结束列分隔线
    property IsDrawColEndLine:Boolean read FIsDrawColEndLine write SetIsDrawColEndLine;

    //行分隔线绘制参数
    property DrawRowLineParam:TDrawLineParam read FDrawRowLineParam write SetDrawRowLineParam;
    //列分隔线绘制参数
    property DrawColLineParam:TDrawLineParam read FDrawColLineParam write SetDrawColLineParam;
  end;





  //表格行背景绘制参数
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinRowBackColorMaterial=class(TSkinMaterial)
  private
    //背景色
    FBackColor:TDrawRectParam;
    //奇数背景色
    FOddBackColor:TDrawRectParam;
    //偶数背景色
    FEvenBackColor:TDrawRectParam;


    //区分奇偶行
    FIsDiffOddAndEven:Boolean;

    procedure SetBackColor(const Value: TDrawRectParam);
    procedure SetEvenBackColor(const Value: TDrawRectParam);
    procedure SetOddBackColor(const Value: TDrawRectParam);

    procedure SetIsDiffOddAndEven(const Value: Boolean);
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

    //背景色
    property BackColor:TDrawRectParam read FBackColor write SetBackColor;
    //奇数
    property OddBackColor:TDrawRectParam read FOddBackColor write SetOddBackColor;
    //偶数
    property EvenBackColor:TDrawRectParam read FEvenBackColor write SetEvenBackColor;

    //区分奇数和偶数行
    property IsDiffOddAndEven:Boolean read FIsDiffOddAndEven write SetIsDiffOddAndEven;
  end;



  //支持固定列表格行背景绘制参数
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFixedRowBackColorMaterial=class(TSkinRowBackColorMaterial)
  private

    //固定列的背景色
    FFixedColsBackColor:TDrawRectParam;
    //固定列的奇数背景色
    FFixedColsOddBackColor:TDrawRectParam;
    //固定列的偶数背景色
    FFixedColsEvenBackColor:TDrawRectParam;

    //区分固定列和活动列
    FIsDiffFixedCols:Boolean;

    procedure SetFixedColsBackColor(const Value: TDrawRectParam);
    procedure SetFixedColsEvenBackColor(const Value: TDrawRectParam);
    procedure SetFixedColsOddBackColor(const Value: TDrawRectParam);

    procedure SetIsDiffFixedCols(const Value: Boolean);
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
    //固定列行的背景色
    property FixedColsBackColor:TDrawRectParam read FFixedColsBackColor write SetFixedColsBackColor;
    //奇数固定列行的背景色
    property FixedColsOddBackColor:TDrawRectParam read FFixedColsOddBackColor write SetFixedColsOddBackColor;
    //偶数固定列行的背景色
    property FixedColsEvenBackColor:TDrawRectParam read FFixedColsEvenBackColor write SetFixedColsEvenBackColor;

    //区分固定列和活动列
    property IsDiffFixedCols:Boolean read FIsDiffFixedCols write SetIsDiffFixedCols;
  end;





  
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinVirtualGridDefaultMaterial=class(TSkinCustomListDefaultMaterial)
  protected
    //默认的表格列标题,单元格文本等绘制参数
    FDrawColumnMaterial:TSkinVirtualGridColumnMaterial;

    //指示区的头部背景色
    FDrawIndicatorHeaderBackColor:TDrawRectParam;
    //指示区的尾部统计区单元格的背景色
    FDrawIndicatorFooterCellBackColorMaterial:TSkinRowBackColorMaterial;


    //活动列头背景颜色
    FColumnHeaderBackColor:TDrawRectParam;
    //固定列头背景颜色
    FFixedColumnHeaderBackColor:TDrawRectParam;




    //列头分隔线绘制参数
    FDrawColumnDevideMaterial:TSkinCellDevideMaterial;
    //单元格分隔线绘制参数
    FDrawGridCellDevideMaterial:TSkinCellDevideMaterial;
    //指示列分隔线绘制参数
    FDrawIndicatorDevideMaterial:TSkinCellDevideMaterial;





    //表格数据行背景色(分奇偶行)
    FRowBackColorMaterial:TSkinFixedRowBackColorMaterial;
    //指示列单元格的背景色(不分奇偶行)
    FDrawIndicatorCellBackColorMaterial: TSkinRowBackColorMaterial;
    //页脚行背景色(分奇偶行)
    FFooterRowBackColorMaterial:TSkinFixedRowBackColorMaterial;


    //是否绘制指示列序号
    FIsDrawIndicatorNumber: Boolean;
    //指示列序号绘制参数
    FDrawIndicatorNumberParam: TDrawTextParam;


    //选中的单元格背景色
    FDrawSelectedCellBackColorParam: TDrawRectParam;

    //勾选框绘制参数
    FDrawCheckBoxColorMaterial: TSkinCheckBoxColorMaterial;

    function GetColumnHeaderColor: TDelphiColor;
    function GetFixedColumnHeaderColor: TDelphiColor;
    procedure SetColumnHeaderColor(const Value: TDelphiColor);
    procedure SetFixedColumnHeaderColor(const Value: TDelphiColor);
    function GetEvenRowBackColor: TDelphiColor;
    function GetIndicatorHeaderBackColor: TDelphiColor;
    function GetIsDiffOddAndEvenRowBackColor: Boolean;
    function GetOddRowBackColor: TDelphiColor;
    function GetRowBackColor: TDelphiColor;
    procedure SetEvenRowBackColor(const Value: TDelphiColor);
    procedure SetIndicatorHeaderBackColor(const Value: TDelphiColor);
    procedure SetIsDiffOddAndEvenRowBackColor(const Value: Boolean);
    procedure SetOddRowBackColor(const Value: TDelphiColor);
    procedure SetRowBackColor(const Value: TDelphiColor);


    procedure SetDrawCheckBoxColorMaterial(const Value: TSkinCheckBoxColorMaterial);
    procedure SetDrawSelectedCellBackColorParam(const Value: TDrawRectParam);


    procedure SetColumnHeaderBackColor(const Value: TDrawRectParam);
    procedure SetFixedColumnHeaderBackColor(const Value: TDrawRectParam);

    procedure SetRowBackColorMaterial(const Value: TSkinFixedRowBackColorMaterial);
    procedure SetFooterRowBackColorMaterial(const Value: TSkinFixedRowBackColorMaterial);
    procedure SetDrawIndicatorCellBackColorMaterial(const Value: TSkinRowBackColorMaterial);

    procedure SetDrawColumnMaterial(const Value: TSkinVirtualGridColumnMaterial);
    procedure SetDrawColumnDevideMaterial(const Value: TSkinCellDevideMaterial);
    procedure SetDrawGridCellDevideMaterial(const Value: TSkinCellDevideMaterial);
    procedure SetDrawIndicatorDevideMaterial(const Value: TSkinCellDevideMaterial);

    procedure SetDrawIndicatorNumberParam(const Value: TDrawTextParam);
    procedure SetDrawIndicatorHeaderBackColor(const Value: TDrawRectParam);
    procedure SetDrawIndicatorFooterCellBackColorMaterial(const Value: TSkinRowBackColorMaterial);
  protected
    function GetColumnMaterialClass:TSkinVirtualGridColumnMaterialClass;virtual;
    procedure AssignTo(Dest: TPersistent); override;
  private
    function GetSelectedRowBackColor: TDelphiColor;
    procedure SetSelectedRowBackColor(const Value: TDelphiColor);
    function GetSelectedEvenRowBackColor: TDelphiColor;
    function GetSelectedOddRowBackColor: TDelphiColor;
    procedure SetSelectedEvenRowBackColor(const Value: TDelphiColor);
    procedure SetSelectedOddRowBackColor(const Value: TDelphiColor);
    function GetIsDiffFixedColsRowBackColor: Boolean;
    procedure SetIsDiffFixedColsRowBackColor(const Value: Boolean);
    function GetFixedColsEvenRowBackColor: TDelphiColor;
    function GetFixedColsOddRowBackColor: TDelphiColor;
    function GetFixedColsRowBackColor: TDelphiColor;
    procedure SetFixedColsEvenRowBackColor(const Value: TDelphiColor);
    procedure SetFixedColsOddRowBackColor(const Value: TDelphiColor);
    procedure SetFixedColsRowBackColor(const Value: TDelphiColor);
  protected
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    //初始
    procedure Init(AIsTest:Boolean;
                  AColumnBackColor:TDelphiColor;
                  AIndicatorBackColor:TDelphiColor;
                  ABorderColor:TDelphiColor;
                  AFixedColsOddRowBackColor:TDelphiColor;
                  AFixedColsEvenRowBackColor:TDelphiColor;
                  AOddRowBackColor:TDelphiColor;
                  AEvenRowBackColor:TDelphiColor;
                  ASelectedRowBackColor:TDelphiColor;
                  AIsDrawBorder:Boolean);
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property DrawCheckBoxColorMaterial:TSkinCheckBoxColorMaterial read FDrawCheckBoxColorMaterial write SetDrawCheckBoxColorMaterial;
  published

    //////////////////////////////////////
    //表头背景色
    property ColumnHeaderColor:TDelphiColor read GetColumnHeaderColor write SetColumnHeaderColor;
    //固定列的表头背景色
    property FixedColumnHeaderColor:TDelphiColor read GetFixedColumnHeaderColor write SetFixedColumnHeaderColor;
    //指示列的表头背景色
    property IndicatorHeaderBackColor:TDelphiColor read GetIndicatorHeaderBackColor write SetIndicatorHeaderBackColor;


    //行背景色
    property RowBackColor:TDelphiColor read GetRowBackColor write SetRowBackColor;
    //偶行背景色
    property EvenRowBackColor:TDelphiColor read GetEvenRowBackColor write SetEvenRowBackColor;
    //寄行背景色
    property OddRowBackColor:TDelphiColor read GetOddRowBackColor write SetOddRowBackColor;

    //选中的行背景色
    property SelectedRowBackColor:TDelphiColor read GetSelectedRowBackColor write SetSelectedRowBackColor;
    property SelectedEvenRowBackColor:TDelphiColor read GetSelectedEvenRowBackColor write SetSelectedEvenRowBackColor;
    property SelectedOddRowBackColor:TDelphiColor read GetSelectedOddRowBackColor write SetSelectedOddRowBackColor;

    //是否区分奇偶行背景色
    property IsDiffOddAndEvenRowBackColor:Boolean read GetIsDiffOddAndEvenRowBackColor write SetIsDiffOddAndEvenRowBackColor;



    //行背景色
    property FixedColsRowBackColor:TDelphiColor read GetFixedColsRowBackColor write SetFixedColsRowBackColor;
    //偶行背景色
    property FixedColsEvenRowBackColor:TDelphiColor read GetFixedColsEvenRowBackColor write SetFixedColsEvenRowBackColor;
    //寄行背景色
    property FixedColsOddRowBackColor:TDelphiColor read GetFixedColsOddRowBackColor write SetFixedColsOddRowBackColor;

    property IsDiffFixedColsRowBackColor:Boolean read GetIsDiffFixedColsRowBackColor write SetIsDiffFixedColsRowBackColor;




    ////////////////////////////////////

    //指示区//
    //指示区的头部背景色,也就是左上角
    property DrawIndicatorHeaderBackColor:TDrawRectParam read FDrawIndicatorHeaderBackColor write SetDrawIndicatorHeaderBackColor;
    //指示区的尾部单元格的背景色,也就是左下角
    property DrawIndicatorFooterCellBackColorMaterial:TSkinRowBackColorMaterial read FDrawIndicatorFooterCellBackColorMaterial write SetDrawIndicatorFooterCellBackColorMaterial;
    //是否绘制指示列的序号,1,2,3,4,5,.....
    property IsDrawIndicatorNumber:Boolean read FIsDrawIndicatorNumber write FIsDrawIndicatorNumber;
    //指示列序号的绘制参数
    property DrawIndicatorNumberParam:TDrawTextParam read FDrawIndicatorNumberParam write SetDrawIndicatorNumberParam;
    //指示列单元格的背景颜色
    property DrawIndicatorCellBackColorMaterial:TSkinRowBackColorMaterial read FDrawIndicatorCellBackColorMaterial write SetDrawIndicatorCellBackColorMaterial;
    //指示列单元格之间的分隔线
    property DrawIndicatorDevideMaterial:TSkinCellDevideMaterial read FDrawIndicatorDevideMaterial write SetDrawIndicatorDevideMaterial;




    //列头背景颜色
    property ColumnHeaderBackColor:TDrawRectParam read FColumnHeaderBackColor write SetColumnHeaderBackColor;
    //固定列头背景颜色
    property FixedColumnHeaderBackColor:TDrawRectParam read FFixedColumnHeaderBackColor write SetFixedColumnHeaderBackColor;



    //默认的列标题,单元格文本绘制参数
    property DrawColumnMaterial:TSkinVirtualGridColumnMaterial read FDrawColumnMaterial write SetDrawColumnMaterial;
    //表格列之间的分隔线
    property DrawColumnDevideMaterial:TSkinCellDevideMaterial read FDrawColumnDevideMaterial write SetDrawColumnDevideMaterial;


    //选中单元格背景绘制参数
    property DrawSelectedCellBackColorParam:TDrawRectParam read FDrawSelectedCellBackColorParam write SetDrawSelectedCellBackColorParam;


    //单元格的行背景色,区分奇偶行
    property RowBackColorMaterial:TSkinFixedRowBackColorMaterial read FRowBackColorMaterial write SetRowBackColorMaterial;
    //单元格的行列分隔线
    property DrawGridCellDevideMaterial:TSkinCellDevideMaterial read FDrawGridCellDevideMaterial write SetDrawGridCellDevideMaterial;


    //统计行的背景色,区分奇偶行
    property FooterRowBackColorMaterial:TSkinFixedRowBackColorMaterial read FFooterRowBackColorMaterial write SetFooterRowBackColorMaterial;

  end;





  TSkinVirtualGridDefaultType=class(TSkinCustomListDefaultType)
  protected
    //固定列占据的列宽
//    FFixedColsWidth:TControlSize;

    //真实的固定列个数
    FRealFixColCount:Integer;

    //列绘制的起始下标
    FDrawColumnStartIndex:Integer;
    FDrawColumnEndIndex:Integer;

    //固定列绘制的起始下标
    FDrawFixedColumnStartIndex:Integer;
    FDrawFixedColumnEndIndex:Integer;

    FSkinVirtualGridIntf:ISkinVirtualGrid;

  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  protected
    function GetSkinMaterial:TSkinVirtualGridDefaultMaterial;
  protected
    //处理单元格设计面板的鼠标点击
    function DoProcessItemCustomMouseDown(AMouseOverItem:TBaseSkinItem;
                                          AItemDrawRect:TRectF;
                                          Button: TMouseButton; Shift: TShiftState;X, Y: Double):Boolean;override;
    function DoProcessItemCustomMouseUp(AMouseDownItem:TBaseSkinItem;
                                        Button: TMouseButton;
                                        Shift: TShiftState;X, Y: Double):Boolean;override;
    function DoProcessItemCustomMouseMove(AMouseOverItem:TBaseSkinItem;
                                          Shift: TShiftState;X,Y:Double):Boolean;override;
    procedure DoProcessItemCustomMouseLeave(AMouseLeaveItem:TBaseSkinItem);override;
  public
    procedure SizeChanged;override;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绘制行背景色,区分奇偶行,区分固定列活动列
    procedure DrawRowBackColor(ACanvas:TDrawCanvas;
                              AItemIndex:Integer;
                              ARowBackColorDrawRect:TRectF;
                              ARowBackColorMaterial:TSkinRowBackColorMaterial;
                              AIsFixedCol:Boolean;
                              AItemEffectStates:TDPEffectStates);
    //绘制列头
    function CustomPaintContentBegin(ACanvas:TDrawCanvas;
                                    ASkinMaterial:TSkinControlMaterial;
                                    const ADrawRect:TRectF;
                                    APaintData:TPaintData)
                                    :Boolean;override;
    //绘制表头,表头尾分隔线
    function CustomPaintColumnsHeader(ACanvas:TDrawCanvas;
                                      ASkinMaterial:TSkinControlMaterial;
                                      const ADrawRect:TRectF;
                                      APaintData:TPaintData;
                                      //表头背景区域
                                      AHeaderDrawRect:TRectF;
//                                      ADrawColumnStartIndex:Integer;
//                                      ADrawColumnEndIndex:Integer;
                                      ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial
                                      ):Boolean;virtual;
    //绘制表格列,列分隔线
    function CustomPaintColumn(ACanvas:TDrawCanvas;
                              //表格列
                              AColumn:TSkinVirtualGridColumn;
                              //列下标
                              AColumnIndex:Integer;
                              //列的绘制区域
                              AColumnDrawRect:TRectF;
                              ADrawRect:TRectF;
                              APaintData:TPaintData;
                              //绘制列的素材
                              ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                              ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial
                              ):Boolean;virtual;

    //处理Item的状态
    function ProcessItemDrawEffectStates(AItem:TBaseSkinItem):TDPEffectStates;override;

    //绘制表格数据行,和行分隔线
    function CustomDrawItemContent(ACanvas: TDrawCanvas;
                                    //行下标
                                    AItemIndex:Integer;
                                    //行
                                    AItem:TBaseSkinItem;
                                    //行绘制区域
                                    AItemDrawRect:TRectF;
                                    ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    const ADrawRect: TRectF;
                                    ACustomListPaintData:TPaintData;
                                    //行的素材
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    //行的状态
                                    AItemEffectStates:TDPEffectStates;
                                    AIsDrawItemInteractiveState:Boolean
                                    ): Boolean;override;
    //绘制指示文字
    function CustomPaintIndicatorCell(ACanvas: TDrawCanvas;
                                      ARowIndex:Integer;
                                      ARow:TBaseSkinItem;
                                      ARowDrawRect:TRectF;
                                      ARowEffectStates:TDPEffectStates;
                                      AIndicatorCellDrawRect:TRectF;
                                      ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                      ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                                      const ADrawRect: TRectF;
                                      AVirtualGridPaintData:TPaintData
                                      ): Boolean;virtual;
    //绘制单元格
    function CustomPaintCell(ACanvas: TDrawCanvas;
                              ARowIndex:Integer;
                              ARow:TBaseSkinItem;
                              ARowDrawRect:TRectF;
                              AColumn:TSkinVirtualGridColumn;
                              AColumnIndex:Integer;
                              ACellDrawRect:TRectF;
                              ARowEffectStates:TDPEffectStates;
                              ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                              ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                              const ADrawRect: TRectF;
                              AVirtualGridPaintData:TPaintData
                              ): Boolean;virtual;
    function CustomPaintCellContent(ACanvas: TDrawCanvas;
                                        ARowIndex:Integer;
                                        ARow:TBaseSkinItem;
                                        ARowDrawRect:TRectF;
                                        AColumn:TSkinVirtualGridColumn;
                                        AColumnIndex:Integer;
                                        ACellDrawRect:TRectF;
                                        ARowEffectStates:TDPEffectStates;
                                        ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                        ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                                        const ADrawRect: TRectF;
                                        AVirtualGridPaintData:TPaintData
                                        ): Boolean;virtual;

    //绘制表格列分格线以及统计
    function AdvancedCustomPaintContent(ACanvas:TDrawCanvas;
                                        ASkinMaterial:TSkinControlMaterial;
                                        const ADrawRect:TRectF;
                                        APaintData:TPaintData)
                                        :Boolean;override;

    //绘制统计
    function CustomPaintColumnsFooter(ACanvas:TDrawCanvas;
                                      ASkinMaterial:TSkinControlMaterial;
                                      const ADrawRect:TRectF;
                                      APaintData:TPaintData;
                                      ADrawStartIndex:Integer;
                                      ADrawEndIndex:Integer;
                                      ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial
                                      ):Boolean;virtual;
    //绘制统计行
    function CustomPaintFooterRow(ACanvas: TDrawCanvas;
                                            AFooterRowIndex:Integer;
                                            AFooterRowDrawRect:TRectF;
                                            ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                            const ADrawRect: TRectF;
                                            AVirtualGridPaintData:TPaintData
                                            ): Boolean;
    //绘制统计行左边指示列单元格
    function CustomPaintIndicatorFooterCell(ACanvas: TDrawCanvas;
                                              AFooterRowIndex:Integer;
                                              AFooterRowDrawRect:TRectF;
                                              AIndicatorCellDrawRect:TRectF;
                                              ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                              const ADrawRect: TRectF;
                                              AVirtualGridPaintData:TPaintData
                                              ): Boolean;
    //绘制统计单元格
    function CustomPaintFooterCell(ACanvas: TDrawCanvas;
                                              AFooterRowIndex:Integer;
                                              AFooterRowDrawRect:TRectF;
                                              AColumn:TSkinVirtualGridColumn;
                                              AColumnIndex:Integer;
                                              ACellDrawRect:TRectF;
                                              ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                              const ADrawRect: TRectF;
                                              AVirtualGridPaintData:TPaintData
                                              ): Boolean;
    procedure MarkAllListItemTypeStyleSettingCacheUnUsed(
                        //起始下标
                        ADrawStartIndex:Integer;
                        ADrawEndIndex:Integer);override;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinVirtualGrid=class(TSkinCustomList,ISkinVirtualGrid)
//  private
//    FColumnHeader:TSkinListBox;
//
//    FSyncColumnHeaderTimer:TTimer;
//    procedure DoColumnHeader_HorzScrollBar_OnPositionChange(Sender:TObject);
//
//    procedure DoSyncColumnHeaderTimer(Sender:TObject);
//    function GetColumnHeader:TSkinListBox;
//    procedure SetColumnHeader(Value: TSkinListBox);
//    procedure SyncColumnHeader;
//  private
//    procedure DoHorzScrollBar_OnPositionChange(Sender:TObject);
  private
    FOnClickColumn:TGridClickColumnEvent;
    FOnClickCell:TGridClickCellEvent;
    FOnGetCellDisplayText:TGetGridCellDisplayTextEvent;
    FOnGetCellEditControl:TGetGridCellEditControlEvent;
    FOnGetFooterCellDisplayText:TGetGridFooterCellDisplayTextEvent;
    FOnCustomPaintCellBegin:TGridCustomPaintCellBeginEvent;
    FOnCustomPaintCellEnd:TGridCustomPaintCellBeginEvent;

    function GetOnClickCell:TGridClickCellEvent;
    function GetOnGetCellDisplayText: TGetGridCellDisplayTextEvent;
    function GetOnGetCellEditControl: TGetGridCellEditControlEvent;
    function GetOnGetFooterCellDisplayText: TGetGridFooterCellDisplayTextEvent;
    function GetOnCustomPaintCellBegin:TGridCustomPaintCellBeginEvent;
    function GetOnCustomPaintCellEnd:TGridCustomPaintCellBeginEvent;

    function GetVirtualGridProperties:TVirtualGridProperties;
    procedure SetVirtualGridProperties(Value:TVirtualGridProperties);
  protected
    procedure ReadState(Reader: TReader); override;

    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //绘制滚动条
    procedure AfterPaint; {$IFDEF FMX}override;{$ENDIF}
  public
    function SelfOwnMaterialToDefault:TSkinVirtualGridDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinVirtualGridDefaultMaterial;
    function Material:TSkinVirtualGridDefaultMaterial;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure StayClick;override;
    property Prop:TVirtualGridProperties read GetVirtualGridProperties write SetVirtualGridProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TVirtualGridProperties read GetVirtualGridProperties write SetVirtualGridProperties;

    //垂直滚动条
    property VertScrollBar;

    //水平滚动条
    property HorzScrollBar;

    //表头
//    property ColumnHeader:TSkinListBox read GetColumnHeader write SetColumnHeader;

    property OnClickCell:TGridClickCellEvent read GetOnClickCell write FOnClickCell;
    property OnClickColumn:TGridClickColumnEvent read FOnClickColumn write FOnClickColumn;

    //获取单元格显示文本
    property OnGetCellDisplayText:TGetGridCellDisplayTextEvent read GetOnGetCellDisplayText write FOnGetCellDisplayText;
    property OnGetCellEditControl:TGetGridCellEditControlEvent read GetOnGetCellEditControl write FOnGetCellEditControl;
    property OnGetFooterCellDisplayText:TGetGridFooterCellDisplayTextEvent read GetOnGetFooterCellDisplayText write FOnGetFooterCellDisplayText;
    property OnCustomPaintCellBegin:TGridCustomPaintCellBeginEvent read GetOnCustomPaintCellBegin write FOnCustomPaintCellBegin;
    property OnCustomPaintCellEnd:TGridCustomPaintCellBeginEvent read GetOnCustomPaintCellEnd write FOnCustomPaintCellEnd;


  end;



  {$IFDEF VCL}
  TSkinWinVirtualGrid=class(TSkinVirtualGrid)
  end;
  {$ENDIF VCL}


implementation





{ TVirtualGridProperties }


procedure TVirtualGridProperties.CalcAutoSizeColumnWidth;
var
  I: Integer;
  J:Integer;
  AColumn:TSkinVirtualGridColumn;
  AContent:String;
  AContentWidth:TControlSize;
  AHasAutoSizeColumn:Boolean;
  ADrawTextParam:TDrawTextParam;
begin
  //如果有自适应尺寸的列


  for I := 0 to Self.FColumns.Count-1 do
  begin
    AColumn:=Self.FColumns[I];
    if AColumn.AutoSize then
    begin
      AHasAutoSizeColumn:=True;
      AColumn.FCalcedAutoSizeWidth:=AColumn.AutoSizeMinWidth;
    end;
  end;


  if AHasAutoSizeColumn then
  begin
      ADrawTextParam:=
        TSkinVirtualGridDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial)
          .FDrawColumnMaterial.FDrawCellTextParam;


      //需要计算该列的宽度,然后自动调整列宽
      for I := 0 to Self.FColumns.Count-1 do
      begin
        AColumn:=Self.FColumns[I];
        if AColumn.AutoSize then
        begin
          for J := 0 to Self.Items.Count-1 do
          begin
            AContent:=Self.GetGridCellText(AColumn,Items[J]);
            AContentWidth:=Ceil(GetStringWidth(AContent,ADrawTextParam.FontSize));
            if AContentWidth>AColumn.FCalcedAutoSizeWidth then
            begin
              AColumn.FCalcedAutoSizeWidth:=Ceil(AContentWidth
                    +ADrawTextParam.DrawRectSetting.Left
                    +ADrawTextParam.DrawRectSetting.Right
                    //补一下
                    +20);
            end;

          end;

        end;
      end;
  end;

  for I := 0 to Self.FColumns.Count-1 do
  begin
    AColumn:=Self.FColumns[I];
    if AColumn.AutoSize then
    begin
      AColumn.Width:=AColumn.FCalcedAutoSizeWidth;
    end;
  end;

end;

function TVirtualGridProperties.CalcContentHeight:Double;
begin

  {$IFDEF FMX}

  Result:=Self.FListLayoutsManager.ContentHeight
          //加上列头
          +Self.FColumnLayoutsManager.StaticItemHeight
          //加上统计行
          +Self.FFooterRowHeight*Self.FFooterRowCount;




  //如果有统计行
  if Self.FFooterRowCount>0 then
  begin
    //那么需要空出一行,用于编辑,或隔离统计行
    Result:=Result+ItemHeight;
  end;

  {$ENDIF}
  {$IFDEF VCL}

  Result:=Self.FListLayoutsManager.ContentHeight
          //加上列头
          +ScreenScaleSizeInt(Self.FColumnLayoutsManager.StaticItemHeight)
          //加上统计行
          +ScreenScaleSizeInt(Self.FFooterRowHeight*Self.FFooterRowCount);




  //如果有统计行
  if Self.FFooterRowCount>0 then
  begin
    //那么需要空出一行,用于编辑,或隔离统计行
    Result:=ScreenScaleSizeInt(Result+ItemHeight);
  end;
  {$ENDIF}

end;

function TVirtualGridProperties.CalcContentWidth:Double;
begin
  //表格列的宽度总和
  Result:=Self.FColumnLayoutsManager.ContentWidth;
            //加上指示列的宽度
            //为什么不直接用FIndicatorWidth
            //wn
//            +FIndicatorWidth;


//            +ControlSize(Self.GetClientRect_ColumnHeader.Left);
end;

//procedure TVirtualGridProperties.CallOnPrepareDrawItemEvent(Sender: TObject;
//  ACanvas: TDrawCanvas; AItem: TBaseSkinItem; AItemDrawRect: TRectF;
//  AIsDrawItemInteractiveState: Boolean);
//var
//  AItemBufferCacheTag:Integer;
//  AItemDesignerPanel:TSkinItemDesignerPanel;
////  AItemListItemTypeStyleSetting:TListItemTypeStyleSetting;
//begin
//  AItemDesignerPanel:=TSkinItemDesignerPanel(TSkinItem(AItem).FDrawItemDesignerPanel);
////  AItemListItemTypeStyleSetting:=TListItemTypeStyleSetting(TSkinItem(AItem).FDrawListItemTypeStyleSetting);
//
//
//  if (AItemDesignerPanel<>nil) then
//  begin
//      //因为每次绘制时调用OnPrepareDrawItem事件非常耗时,
//      //因此当启用缓存的时候,不需要每次都调用它,提高效率
//
//      //-1表示需要重画
//      //默认不缓存
//      AItemBufferCacheTag:=-1;
//
//
////      //使用了Style,
////      //而且使用了缓存
////      if (AItemListItemTypeStyleSetting<>nil)
////        and AItemListItemTypeStyleSetting.IsUseCache
////        and (AItemListItemTypeStyleSetting.Style<>'') then
////      begin
//          //默认缓存
//          AItemBufferCacheTag:=Integer(AItem);
////          //使用了ListItemStyle且IsCache启用了之后才需要缓存功能
////          //不然都是所有Item共用了一个ItemDesignerPanel
////          //获取缓存标记
////          if Assigned(Self.FSkinVirtualGridIntf.OnGetItemBufferCacheTag) then
////          begin
////            Self.FSkinVirtualGridIntf.OnGetItemBufferCacheTag(
////                    Self,
////                    TSkinItem(AItem),
////                    AItemBufferCacheTag);
////          end;
////      end;
//
//
//
//
//      //默认每次都要重画
//      //判断是否需要重新调用OnPrepareDrawItem
//      if (AItemBufferCacheTag=-1)
//        //缓存标记改过了,比如Item.DataObject原来绑定的是A,后面绑定的B,缓存标记使用的是DataObject
//        or (AItemDesignerPanel.Prop.LastItemBufferCacheTag<>AItemBufferCacheTag)
//        //Item属性改过了
//        or TSkinItem(AItem).IsBufferNeedChange
//        //绘制区域的尺寸改过了要重绘
//        or not IsSameDouble(TSkinItem(AItem).FLastItemDrawRect.Width,AItemDrawRect.Width)
//        or not IsSameDouble(TSkinItem(AItem).FLastItemDrawRect.Height,AItemDrawRect.Height) then
//      begin
//              TSkinItem(AItem).FLastItemDrawRect:=AItemDrawRect;
//
////              uBaseLog.HandleException(nil,'TVirtualListProperties.CallOnPrepareDrawItemEvent '+Self.FSkinControl.Name+' '+TSkinItem(AItem).Caption);
//
//              AItemDesignerPanel.Prop.LastItem:=AItem;
////              AItemDesignerPanel.Prop.LastCol:=nil;
//              AItemDesignerPanel.Prop.LastItemBufferCacheTag:=AItemBufferCacheTag;
//              TSkinItem(AItem).IsBufferNeedChange:=False;
//
//
//              //自动绑定值,把Item的属性值赋给ItemDesignerPanel上面的控件
////              Self.FSkinVirtualGridIntf.Prop.BindItemDesignerPanelAndItem(
////                    AItemDesignerPanel,
////                    AItem,
////                    AIsDrawItemInteractiveState);
//              AItemDesignerPanel.Prop.SetControlsValueByItem(
//                    nil,//Self.SkinImageList,
//                    TSkinItem(AItem),
//                    AIsDrawItemInteractiveState);
//
//
//              //调用ListBox的OnPrepareDrawItem
//              if Assigned(Self.FSkinVirtualGridIntf.OnPrepareDrawItem) then
//              begin
//                //手动绑定值
//                Self.FSkinVirtualGridIntf.OnPrepareDrawItem(Self,
//                        ACanvas,
//                        TItemDesignerPanel(AItemDesignerPanel),
//                        TSkinItem(AItem),
//                        RectF2Rect(AItemDrawRect));
//              end;
//
//
//              //调用设计面板的OnPrepareDrawItem
//              if Assigned(AItemDesignerPanel.OnPrepareDrawItem) then
//              begin
//                AItemDesignerPanel.OnPrepareDrawItem(Self,ACanvas,
//                                          TSkinItemDesignerPanel(TSkinItem(AItem).FDrawItemDesignerPanel),
//                                          TSkinItem(AItem),
//                                          AItemDrawRect);
//              end;
//
//      end;
//
//  end
//  else
//  begin
//      //不使用ItemDesignerPanel绘制
//      if Assigned(Self.FSkinVirtualGridIntf.OnPrepareDrawItem) then
//      begin
//        //手动绑定值
//        Self.FSkinVirtualGridIntf.OnPrepareDrawItem(Self,
//                ACanvas,
//                nil,
//                TSkinItem(AItem),
//                RectF2Rect(AItemDrawRect));
//      end;
//  end;
//end;
//


//function TVirtualGridProperties.CanEditCell(ACol: TSkinVirtualGridColumn;ARow: TBaseSkinItem): Boolean;
//begin
////  Result:=Not (ACol.ReadOnly    //列是否允许编辑
////              or Self.ReadOnly //表格是否允许编辑
////              //固定列
////              or (Self.FColumnLayoutsManager.GetVisibleItemObjectIndex(ACol)<Self.FFixedCols)
////              );
//  Result:=not ACol.ReadOnly    //列是否允许编辑
//              and not Self.ReadOnly //表格是否允许编辑
//              //固定列
//              //固定列应该也要能编辑
////              or (Self.FColumnLayoutsManager.GetVisibleItemObjectIndex(ACol)<Self.FFixedCols)
//              ;
//end;

constructor TVirtualGridProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);

  if Not ASkinControl.GetInterface(IID_ISkinVirtualGrid,Self.FSkinVirtualGridIntf) then
  begin
    ShowException('This Component Do not Support ISkinVirtualGrid Interface');
  end
  else
  begin

      FReadOnly:=True;

      //行选择
      FIsRowSelect:=True;


      TSkinVirtualGridRowLayoutsManager(Self.FListLayoutsManager).FVirtualGridProperties:=Self;

      //统计行个数
      FFooterRowCount:=0;
      //统计行高度
      FFooterRowHeight:=Const_DefaultRowHeight;

      //行高
      Self.FListLayoutsManager.StaticItemHeight:=Const_DefaultRowHeight;
      //列表项的顶部偏移
      Self.FListLayoutsManager.FControlTopOffset:=Const_DefaultColumnHeaderHeight;


      //指示列宽度
      FIndicatorWidth:=0;
      //固定列个数
      FFixedCols:=0;



      //水平滚动条类型
      Self.FHorzScrollBarShowType:=sbstAutoCoverShow;



      if Not DirectoryExists('E:\MyFiles') then
      begin
        //别人的电脑
        Self.FHorzControlGestureManager.IsNeedDecideFirstGestureKind:=True;
        Self.FHorzControlGestureManager.CanOverRangeTypes:=[];

        Self.FVertControlGestureManager.CanOverRangeTypes:=[];
      end;





      //表格列列表
      FColumns:=GetColumnsClass.Create(Self,GetColumnClass);


      //表格列布局管理
      FColumnLayoutsManager:=GetColumnLayoutsManagerClass.Create(Self.FColumns);
      FColumnLayoutsManager.StaticItemWidth:=Const_DefaultColumnWidth;
      FColumnLayoutsManager.StaticItemHeight:=Const_DefaultColumnHeaderHeight;
      //水平排列
      FColumnLayoutsManager.StaticItemLayoutType:=TItemLayoutType.iltHorizontal;
//      //表格列的高度不变
//      FColumnLayoutsManager.StaticItemSizeCalcType:=isctFixed;
      //表格列的宽度变化
      FColumnLayoutsManager.StaticItemSizeCalcType:=isctSeparate;
      FColumnLayoutsManager.OnItemPropChange:=DoItemPropChange;
      FColumnLayoutsManager.OnItemSizeChange:=DoColumnSizeChange;//需要重新计算行宽度
      FColumnLayoutsManager.OnItemVisibleChange:=DoColumnVisibleChange;//需要重新计算行宽度
      FColumnLayoutsManager.OnGetControlWidth:=Self.DoGetListLayoutsManagerControlWidth;
      FColumnLayoutsManager.OnGetControlHeight:=Self.DoGetListLayoutsManagerControlHeight;

      


      FIsNeedClip:=True;
  end;
end;

function TVirtualGridProperties.AutoCreateEditControl(ACol:TSkinVirtualGridColumn): TControl;
begin
  if ACol.PickList.Count>0 then
  begin
      Result:=TComboBox.Create(nil);
      //必须要设置Parent，不然TComboBox(Result).Items.Assign(ACol.PickList);会报错
      Result.Parent:=TParentControl(Self.FSkinControl);
      TComboBox(Result).Items.Assign(ACol.PickList);

  end
  else
  begin
      {$IFDEF FMX}
      Result:=TSkinFMXEdit.Create(nil);
      TSkinFMXEdit(Result).SkinControlType;
      TSkinFMXEdit(Result).SelfOwnMaterial;
      TSkinFMXEdit(Result).SelfOwnMaterial.IsTransparent:=False;
      TSkinFMXEdit(Result).SelfOwnMaterial.BackColor.IsFill:=True;
      {$ELSE}
      Result:=TEdit.Create(nil);
      {$ENDIF}

  end;
end;

function TVirtualGridProperties.GetColumnClass: TSkinVirtualGridColumnClass;
begin
  Result:=TSkinVirtualGridColumn;
end;

function TVirtualGridProperties.GetColumnLayoutsManagerClass: TSkinListLayoutsManagerClass;
begin
  Result:=TSkinVirtualGridColumnLayoutsManager;
end;

destructor TVirtualGridProperties.Destroy;
begin
  //表格列
  FreeAndNil(FColumns);

  FreeAndNil(FColumnLayoutsManager);

  inherited;
end;

procedure TVirtualGridProperties.DoClickCell(ARow: TBaseSkinItem; ACol: TSkinVirtualGridColumn);
begin
  if Assigned(Self.FSkinVirtualGridIntf.OnClickCell) then
  begin
    Self.FSkinVirtualGridIntf.OnClickCell(
                          Self,
                          ACol,
                          ARow
                          );
  end;
end;

procedure TVirtualGridProperties.DoClickItem(ARow: TBaseSkinItem; X,Y: Double);
var
  AClickedCellCol:TSkinVirtualGridColumn;
begin

    //没有在编辑单元格,

    //选中单元格,并且点击单元格
    AClickedCellCol:=Self.ColumnAt(X);

    if (Self.FSelectedItem=ARow)
      and (FClickedCellCol=AClickedCellCol)
      and (FClickedCellCol<>nil)
      and not FClickedCellCol.ReadOnly
      and not Self.ReadOnly then
    begin
        //那么两次点击同一单元格,就启动编辑

        //那么两次点击同一单元格,就启动编辑
        //编辑单元格
        Self.StartEditingCell(ARow,AClickedCellCol,X,Y);

    end
    else
    begin

        if (AClickedCellCol<>nil)
            and (AClickedCellCol.GetValueType(ARow)=varBoolean)
            and not AClickedCellCol.ReadOnly
            and not Self.ReadOnly then
        begin
            //复选框直接启动编辑
            Self.StartEditingCell(ARow,AClickedCellCol,X,Y);

        end
        else
        begin

            //行选择,并且点击行
            inherited;

            FClickedCellCol:=AClickedCellCol;

            //点击单元格事件
            if FClickedCellCol<>nil then
            begin
              DoClickCell(ARow,FClickedCellCol);
            end;
        end;

    end;


end;

procedure TVirtualGridProperties.DoColumnSizeChange(Sender: TObject);
begin
  uBaseLog.OutputDebugString('UpdateScrollBars In DoColumnSizeChange');
  //重新排列表格数据行
  Self.FListLayoutsManager.DoItemSizeChange(nil,False);

  Self.UpdateScrollBars;
  Invalidate;
end;

procedure TVirtualGridProperties.DoColumnVisibleChange(Sender: TObject);
begin
  uBaseLog.OutputDebugString('UpdateScrollBars In DoColumnVisibleChange');
  //重新排列表格数据行
  Self.FListLayoutsManager.DoItemSizeChange(nil,False);

  Self.UpdateScrollBars;
  Invalidate;
end;

//procedure TVirtualGridProperties.DoItemDelete(Sender, AItem: TObject; AIndex: Integer);
//begin
//  inherited;
////  if Self.FItems.HasItemDeleted then
////  begin
////    if (Self.FSelectedCellRow<>nil)
////      and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FSelectedCellRow)=-1) then
////    begin
////      FSelectedCellRow:=nil;
////    end;
////  end;
//
//end;

//procedure TVirtualGridProperties.DoItemsChange(Sender: TObject);
//begin
//  inherited;
////  if (Self.FSelectedCellRow<>nil)
////    and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FSelectedCellRow)=-1) then
////  begin
////    FSelectedCellRow:=nil;
////  end;
//
//end;

procedure TVirtualGridProperties.DoSetValueToEditingItem;
begin
  inherited;

  if FEditingItem_EditControl_ItemEditorIntf<>nil then
  begin
    //OrangeUI的控件,支持接口
    //将编辑控件的值赋回给列表项的属性
    SetGridCellValue(FEditingCellCol,
                    FEditingItem,
                    FEditingItem_EditControl_ItemEditorIntf.EditGetValue
                    );
  end
  else
  begin
    //原生控件,没有接口
    SetGridCellValue(FEditingCellCol,
                    FEditingItem,
                    GetValueFromEditControl(FEditingItem_EditControl)
                    );
  end;

end;

procedure TVirtualGridProperties.DoStopEditingItemEnd;
begin
  inherited;
  FEditingCellCol:=nil;
  FreeAndNil(FAutoCreatedEditControl);
end;

function TVirtualGridProperties.GetItemTopDrawOffset: Double;
begin
  {$IFDEF FMX}
  Result:=Self.FColumnLayoutsManager.StaticItemHeight;
  {$ENDIF}
  {$IFDEF VCL}
  Result:=ScreenScaleSizeInt(Self.FColumnLayoutsManager.StaticItemHeight);
  {$ENDIF}
end;

function TVirtualGridProperties.GetRealFixedColCount: Integer;
begin
  Result:=Self.FSkinVirtualGridIntf.Prop.FFixedCols;

  //固定列个数,不能超过总列数
  if Result>Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount then
  begin
    Result:=Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount;
  end;
end;

function TVirtualGridProperties.GetRealFixedColsDrawRight: Double;
begin
  Result:=0;
  //获取固定列的总宽度
  if Self.GetRealFixedColCount>0 then
  begin
    Result:=Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.VisibleItemRectByIndex(
      GetRealFixedColCount-1
      ).Right;
  end;
end;

function TVirtualGridProperties.GetRowDrawRect_FixedCols(ADrawRect:TRectF;ARowDrawRect: TRectF): TRectF;
begin
  Result:=ARowDrawRect;
  Result.Left:=ADrawRect.Left
               +FIndicatorWidth;
  Result.Right:=ADrawRect.Left
                +Self.FSkinVirtualGridIntf.Prop.GetClientRect_Cells_FixedCols.Right;
end;

function TVirtualGridProperties.GetRowDrawRect_UnfixedCols(ADrawRect:TRectF;ARowDrawRect: TRectF): TRectF;
begin
  Result:=ARowDrawRect;
  Result.Left:=Result.Left
              +Self.FSkinVirtualGridIntf.Prop.GetClientRect_Cells_UnfixedCols.Left;
end;

function TVirtualGridProperties.GetRowHeight: Double;
begin
  Result:=GetItemHeight;
end;

function TVirtualGridProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TSkinVirtualGridRows;
end;

function TVirtualGridProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinVirtualGridRowLayoutsManager;
end;

function TVirtualGridProperties.GetColumnsClass: TSkinVirtualGridColumnsClass;
begin
  Result:=TSkinVirtualGridColumns;
end;

function TVirtualGridProperties.GetColumnsHeaderHeight: Double;
begin
  Result:=Self.FColumnLayoutsManager.StaticItemHeight;
end;

//function TVirtualGridProperties.GetGridCellChecked(ACol: TSkinVirtualGridColumn;
//  ARow: TBaseSkinItem): Boolean;
//begin
//  Result:=False;
//end;

function TVirtualGridProperties.GetGridCellText(ACol: TSkinVirtualGridColumn;
                                                ARow: TBaseSkinItem
                                                ): String;
begin
  Result:=IntToStr(ACol.Index)+','+IntToStr(ARow.Index);
end;

function TVirtualGridProperties.GetGridCellText1(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): String;
begin
  Result:='';
end;

function TVirtualGridProperties.GetCellDrawRect(ACol: TSkinVirtualGridColumn;ARow: TBaseSkinItem): TRectF;
begin
  Result:=VisibleColumnDrawRect(ACol);
  Result.Top:=ARow.ItemDrawRect.Top;
  Result.Bottom:=ARow.ItemDrawRect.Bottom;
end;

function TVirtualGridProperties.GetCellValue(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): Variant;
begin
  Result:='';
end;

function TVirtualGridProperties.GetCellValueType(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): TVarType;
begin
  Result:=ACol.GetValueType(ARow);
end;

function TVirtualGridProperties.GetCellValueObject(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): TObject;
begin
  Result:=nil;
end;

function TVirtualGridProperties.GetCellValue1(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): Variant;
begin
  Result:='';
end;

function TVirtualGridProperties.GetCellValue1Type(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): TVarType;
begin
  Result:=ACol.GetValueType1(ARow);
end;

function TVirtualGridProperties.GetCellValue1Object(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): TObject;
begin
  Result:=nil;
end;

//function TVirtualGridProperties.GetCellValue1(ACol: TSkinVirtualGridColumn;
//  ARow: TBaseSkinItem): Variant;
//begin
//  Result:='';
//end;
//
//function TVirtualGridProperties.GetCellValue1Type(ACol: TSkinVirtualGridColumn;
//  ARow: TBaseSkinItem): TVarType;
//begin
//
//end;
//
//function TVirtualGridProperties.GetCellValueType(ACol: TSkinVirtualGridColumn;
//  ARow: TBaseSkinItem): TVarType;
//begin
//
//end;

function TVirtualGridProperties.GetClientRect_Cells: TRectF;
begin
  Result:=Self.GetClientRect;


  {$IFDEF FMX}
  Result.Top:=Result.Top
                +Self.FColumnLayoutsManager.StaticItemHeight;
  Result.Left:=Result.Left
                +Self.FIndicatorWidth;
  Result.Bottom:=Result.Bottom
                -Self.FFooterRowHeight*Self.FFooterRowCount;

  {$ENDIF}

  {$IFDEF VCL}
  Result.Top:=Result.Top
                +ScreenScaleSize(Self.FColumnLayoutsManager.StaticItemHeight);
  Result.Left:=Result.Left
                +ScreenScaleSize(Self.FIndicatorWidth);
  Result.Bottom:=Result.Bottom
                -ScreenScaleSize(Self.FFooterRowHeight*Self.FFooterRowCount);

  {$ENDIF}

end;

function TVirtualGridProperties.GetClientRect_ColumnHeader: TRectF;
begin
  Result:=Self.GetClientRect;


  {$IFDEF FMX}
  Result.Left:=Result.Left
                +Self.FIndicatorWidth;
  Result.Bottom:=Result.Top
                  +Self.FColumnLayoutsManager.ItemHeight;
  {$ENDIF}

  {$IFDEF VCL}
  Result.Left:=Result.Left
                +ScreenScaleSize(Self.FIndicatorWidth);
  Result.Bottom:=Result.Top
                  +ScreenScaleSize(Self.FColumnLayoutsManager.ItemHeight);
  {$ENDIF}

end;

function TVirtualGridProperties.GetClientRect_Cells_FixedCols: TRectF;
begin
  Result:=Self.GetClientRect_Cells;
  Result.Right:=Self.GetRealFixedColsDrawRight;
end;

function TVirtualGridProperties.GetClientRect_Footer: TRectF;
begin
  Result:=Self.GetClientRect;
  Result.Left:=Result.Left
                +Self.FIndicatorWidth;
  Result.Top:=Result.Bottom
                -Self.FFooterRowHeight*Self.FFooterRowCount;
end;

function TVirtualGridProperties.GetClientRect_Cells_UnfixedCols: TRectF;
begin
  Result:=Self.GetClientRect_Cells;
  Result.Left:=Self.GetRealFixedColsDrawRight;
end;

function TVirtualGridProperties.GetClientRect_ColumnHeader_UnfixedCols: TRectF;
begin
  Result:=Self.GetClientRect_ColumnHeader;
  Result.Left:=Self.GetRealFixedColsDrawRight;
end;

function TVirtualGridProperties.GetClientRect_Footer_UnfixedCols: TRectF;
begin
  Result:=Self.GetClientRect_Footer;
  Result.Left:=Self.GetRealFixedColsDrawRight;
end;

function TVirtualGridProperties.GetClientRect_Grid: TRectF;
begin
  Result:=Self.GetClientRect;


  {$IFDEF FMX}
  Result.Top:=Result.Top
                +Self.FColumnLayoutsManager.StaticItemHeight;
  Result.Bottom:=Result.Bottom
                -Self.FFooterRowHeight*Self.FFooterRowCount;
  {$ENDIF}
  {$IFDEF VCL}
  Result.Top:=Result.Top
                +ScreenScaleSize(Self.FColumnLayoutsManager.StaticItemHeight);
  Result.Bottom:=Result.Bottom
                -ScreenScaleSize(Self.FFooterRowHeight)*Self.FFooterRowCount;
  {$ENDIF}


end;

procedure TVirtualGridProperties.SetColumnsHeaderHeight(const Value: Double);
begin
  if Value>0 then
  begin
    //列表项的顶部偏移
    Self.FListLayoutsManager.ControlTopOffset:=Value;

    Self.FColumnLayoutsManager.ItemHeight:=Value;
  end
  else
  begin
    //列表项的顶部偏移
    Self.FListLayoutsManager.ControlTopOffset:=0;

    Self.FColumnLayoutsManager.ItemHeight:=0;
  end;
end;

procedure TVirtualGridProperties.SetFixedCols(const Value: Integer);
begin
  if FFixedCols<>Value then
  begin
    FFixedCols:=Value;
    Self.Invalidate;
  end;
end;

procedure TVirtualGridProperties.SetFooterRowCount(const Value: Integer);
begin
  if FFooterRowCount<>Value then
  begin
    FFooterRowCount:=Value;

    uBaseLog.OutputDebugString('UpdateScrollBars In SetFooterRowCount');
    Self.UpdateScrollBars;
    Self.Invalidate;
  end;
end;

procedure TVirtualGridProperties.SetIndicatorWidth(const Value: Double);
begin
  if FIndicatorWidth<>Value then
  begin
    FIndicatorWidth:=Value;

//    //重新计算表格数据行的绘制区域
//    Self.FListLayoutsManager.ControlLeftOffset:=Value;


    Self.FColumnLayoutsManager.ControlLeftOffset:=Value;

    //重新计算表格数据行的绘制区域
    Self.FListLayoutsManager.DoItemSizeChange(nil,False);

    Self.Invalidate;
  end;
end;

procedure TVirtualGridProperties.SetIsRowSelect(const Value: Boolean);
begin
  if FIsRowSelect<>Value then
  begin
    FIsRowSelect := Value;

    Self.Invalidate;

  end;
end;

procedure TVirtualGridProperties.SetFooterRowHeight(const Value: Double);
begin
  if FFooterRowHeight<>Value then
  begin
    FFooterRowHeight:=Value;

    uBaseLog.OutputDebugString('UpdateScrollBars In SetFooterRowHeight');
    Self.UpdateScrollBars;
    Self.Invalidate;
  end;
end;

procedure TVirtualGridProperties.SetGridCellValue(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem;
  AValue:Variant);
begin
  //
end;

procedure TVirtualGridProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

function TVirtualGridProperties.GetComponentClassify: String;
begin
  Result:='SkinVirtualGrid';
end;

function TVirtualGridProperties.GetContentRect_Footer: TRectF;
begin
  Result:=Self.GetClientRect;
  Result.Right:=Result.Left+Self.CalcContentWidth;
  Result.Top:=Result.Bottom
                -Self.FFooterRowHeight*Self.FFooterRowCount;
end;

function TVirtualGridProperties.GetContentRect_Header: TRectF;
begin
  Result:=Self.GetClientRect;

  {$IFDEF FMX}
  Result.Bottom:=Result.Top
                  +Self.FColumnLayoutsManager.ItemHeight;
  {$ENDIF}

  {$IFDEF VCL}
  Result.Bottom:=Result.Top
                  +ScreenScaleSize(Self.FColumnLayoutsManager.ItemHeight);
  {$ENDIF}

  Result.Right:=Result.Left+Self.CalcContentWidth;
end;

procedure TVirtualGridProperties.UpdateFooterRow;
begin
  Self.Invalidate;
end;

function TVirtualGridProperties.GetItems: TSkinVirtualGridRows;
begin
  Result:=TSkinVirtualGridRows(FItems);
end;

procedure TVirtualGridProperties.SetItems(const Value: TSkinVirtualGridRows);
begin
  FItems.Assign(Value);
end;

procedure TVirtualGridProperties.SetRowHeight(const Value: Double);
begin
  SetItemHeight(Value);
end;

procedure TVirtualGridProperties.StartEditingCell(AItem: TBaseSkinItem;
    ACol: TSkinVirtualGridColumn;
    X:Double;Y:Double;
    AItemDesignerPanelEditControl:TControl);
var
  ACellDrawRect:TRectF;
  AEditControlPutRect:TRectF;
  AEditValue:String;
  AEditControl:TControl;
begin

  if ACol.ReadOnly    //列是否允许编辑
     or Self.ReadOnly then//表格是否允许编辑
  begin
    //表格只读,不允许编辑
    Exit;
  end;


  if (FEditingItem=AItem) and (FEditingCellCol=ACol) then
  begin
    //重复调用相同的编辑,那么直接退出
    Exit;
  end;


//  if cctCheckBox in ACol.GetContentTypes then
  if ACol.GetValueType(AItem)=varBoolean then
  begin

      //勾选框,自动点击勾选/取消勾选
      SetGridCellValue(ACol,
                       AItem,
//                       Not GetGridCellChecked(ACol,AItem)
                       Not GetCellValue(ACol,AItem)
                       );

  end
  else
  begin

      AEditControl:=AItemDesignerPanelEditControl;

      //调用事件,获取外部自定义的编辑控件
      if (AItemDesignerPanelEditControl=nil) and Assigned(Self.FSkinVirtualGridIntf.OnGetCellEditControl) then
      begin
        Self.FSkinVirtualGridIntf.OnGetCellEditControl(
                                                      Self,
                                                      ACol,
                                                      AItem,
                                                      AEditControl
                                                      );
      end;



      if AEditControl=nil then
      begin
        FAutoCreatedEditControl:=AutoCreateEditControl(ACol);
        AEditControl:=FAutoCreatedEditControl;
      end;



      if AEditControl<>nil then
      begin

          //可以编辑

          AEditControlPutRect:=Self.VisibleColumnRect(ACol);
          AEditControlPutRect.Height:=AItem.ItemDrawRect.Height;

          if AItemDesignerPanelEditControl<>nil then
          begin
            //使用设计面板上放置的Edit

            {$IFDEF VCL}
            AEditControlPutRect.Left:=AEditControlPutRect.Left+AItemDesignerPanelEditControl.Left;
            AEditControlPutRect.Top:=AEditControlPutRect.Top+AItemDesignerPanelEditControl.Top;
            {$ENDIF}

            {$IFDEF FMX}
            AEditControlPutRect.Left:=AEditControlPutRect.Left+AItemDesignerPanelEditControl.Position.X;
            AEditControlPutRect.Top:=AEditControlPutRect.Top+AItemDesignerPanelEditControl.Position.Y;
            {$ENDIF}


            AEditControlPutRect.Width:=AItemDesignerPanelEditControl.Width;
            AEditControlPutRect.Height:=AItemDesignerPanelEditControl.Height;
          end
          else
          begin
            //使用自动创建的Edit


          end;

          //加入边框1
          AEditControlPutRect.Left:=AEditControlPutRect.Left+1;
          AEditControlPutRect.Top:=AEditControlPutRect.Top+1;
          AEditControlPutRect.Right:=AEditControlPutRect.Right-1;
          AEditControlPutRect.Bottom:=AEditControlPutRect.Bottom-1;









          //单元格绘制坐标
          //用于计算坐标
          ACellDrawRect:=GetCellDrawRect(ACol,AItem);
//          Self.VisibleColumnDrawRect(ACol);
//          ACellDrawRect.Top:=AItem.ItemDrawRect.Top;
//          ACellDrawRect.Bottom:=AItem.ItemDrawRect.Bottom;


          AEditValue:=Self.GetGridCellText(ACol,AItem);


          if StartEditingItem(AItem,
                             AEditControl,
                             AEditControlPutRect,
                             AEditValue,
                             X-ACellDrawRect.Left,
                             Y-ACellDrawRect.Top
                             ) then
          begin
            FEditingCellCol:=ACol;
          end;

      end;
  end;


//  Self.FSkinVirtualGridIntf.GetColumnHeader.BringToFront;
end;

function TVirtualGridProperties.SelectedText: String;
begin
  Result:='';
  if (Self.FSelectedItem<>nil)
    and (Self.FClickedCellCol<>nil) then
  begin
    Result:=Self.GetGridCellText(
                      FClickedCellCol,
                      FSelectedItem
                      );
  end;
end;

procedure TVirtualGridProperties.SetColumns(const Value: TSkinVirtualGridColumns);
begin
  FColumns.Assign(Value);
end;

function TVirtualGridProperties.FooterRowRect(AFooterRowIndex: Integer): TRectF;
begin
  Result:=Self.GetContentRect_Footer;
  Result.Top:=Result.Top+(AFooterRowIndex)*Self.FFooterRowHeight;
  Result.Bottom:=Result.Top+FFooterRowHeight;
end;

//function TVirtualGridProperties.ColumnAt(X, Y:Double): TSkinVirtualGridColumn;
//var
//  I: Integer;
//begin
//  Result:=nil;
//  for I := 0 to Self.FColumnLayoutsManager.GetVisibleItemsCount-1 do
//  begin
//    if PtInRect(Self.VisibleColumnDrawRect(I),PointF(X,Y)) then
//    begin
//      Result:=TSkinVirtualGridColumn(FColumnLayoutsManager.GetVisibleItemObject(I));
//      Break;
//    end;
//  end;
//end;

function TVirtualGridProperties.ColumnAt(X:Double): TSkinVirtualGridColumn;
var
  I: Integer;
  AColumnDrawRect:TRectF;
begin
  Result:=nil;
  for I := 0 to Self.FColumnLayoutsManager.GetVisibleItemsCount-1 do
  begin
    AColumnDrawRect:=Self.VisibleColumnDrawRect(I);
    if (X>=AColumnDrawRect.Left) and (X<=AColumnDrawRect.Right) then
    begin
      Result:=TSkinVirtualGridColumn(FColumnLayoutsManager.GetVisibleItemObject(I));
      Break;
    end;
  end;
end;

function TVirtualGridProperties.VisibleColumnDrawRect(AVisibleColumn:TSkinVirtualGridColumn): TRectF;
var
  AVisibleColumnIndex:Integer;
begin
  //判断是否是固定的列
  Result:=RectF(0,0,0,0);

  AVisibleColumnIndex:=Self.FColumnLayoutsManager.GetVisibleItemObjectIndex(AVisibleColumn);

//  if AVisibleColumnIndex<>-1 then
//  begin
    Result:=VisibleColumnDrawRect(AVisibleColumnIndex);
//  end;
end;

function TVirtualGridProperties.VisibleColumnRect(AVisibleColumnIndex: Integer): TRectF;
begin
  //判断是否是固定的列
  Result:=Self.FColumnLayoutsManager.VisibleItemRectByIndex(AVisibleColumnIndex);
//  //加上指示列的宽度
//  Result.Left:=Result.Left
//                +GetClientRect_ColumnHeader.Left;
//  Result.Right:=Result.Right
//                +GetClientRect_ColumnHeader.Left;
end;

function TVirtualGridProperties.VisibleColumnRect(AVisibleColumn: TSkinVirtualGridColumn): TRectF;
var
  AVisibleColumnIndex:Integer;
begin
  //判断是否是固定的列
  Result:=RectF(0,0,0,0);

  AVisibleColumnIndex:=Self.FColumnLayoutsManager.GetVisibleItemObjectIndex(AVisibleColumn);

  if AVisibleColumnIndex<>-1 then
  begin
    Result:=VisibleColumnRect(AVisibleColumnIndex);
  end;

end;

function TVirtualGridProperties.VisibleColumnDrawRect(AVisibleColumnIndex:Integer): TRectF;
begin
  //判断是否是固定的列
  Result:=Self.FColumnLayoutsManager.VisibleItemRectByIndex(AVisibleColumnIndex);

//  //加上指示列的宽度
//  Result.Left:=Result.Left
//                +GetClientRect_ColumnHeader.Left;
//  Result.Right:=Result.Right
//                +GetClientRect_ColumnHeader.Left;

  //不是固定的列,要加上水平偏移
  //只有水平滚动
  if AVisibleColumnIndex>=Self.FFixedCols then
  begin
    Result.Left:=Result.Left-Self.GetLeftDrawOffset;
    Result.Right:=Result.Right-Self.GetRightDrawOffset;
  end;

  Self.FColumnLayoutsManager.GetVisibleItem(AVisibleColumnIndex).SetItemDrawRect(Result);
end;

//function TVirtualGridProperties.RowDrawRect(AVisibleRowIndex: Integer): TRectF;
//begin
//  Result:=VisibleItemRect(AVisibleRowIndex);
//
//  Result.Top:=Result.Top
//                +Self.GetColumnsHeaderHeight
//                -Self.GetTopDrawOffset;//+GetCenterItemSelectModeTopDrawOffset;
//  Result.Bottom:=Result.Bottom
//                +Self.GetColumnsHeaderHeight
//                -Self.GetBottomDrawOffset;//+GetCenterItemSelectModeTopDrawOffset;
//  Result.Left:=Result.Left
//                +Self.FIndicatorWidth
//                -Self.GetLeftDrawOffset;//+GetCenterItemSelectModeLeftDrawOffset;
//  Result.Right:=Result.Right
//                -Self.GetRightDrawOffset;//+GetCenterItemSelectModeLeftDrawOffset;
//
//  Self.FListLayoutsManager.GetVisibleItem(AVisibleRowIndex).SetItemDrawRect(Result);
//end;
//
//function TVirtualGridProperties.RowIndexAt(X, Y: Double):Integer;
//var
//  I: Integer;
//begin
//  Result:=-1;
//  for I:=0 to Self.FColumnLayoutsManager.GetVisibleItemsCount - 1 do
//  begin
//    if PtInRect(RowDrawRect(I),PointF(X,Y)) then
//    begin
//      Result:=I;
//      Break;
//    end;
//  end;
//end;
//
//function TVirtualGridProperties.VisibleRowIndexAt(X, Y: Double):Integer;
//var
//  I: Integer;
//  ADrawStartIndex,ADrawEndIndex:Integer;
//begin
//  Result:=-1;
//  if Self.FListLayoutsManager.GetVisibleItemsCount>0 then
//  begin
//    Self.FListLayoutsManager.CalcDrawStartAndEndIndex(
//            Self.GetLeftDrawOffset,
//            Self.GetTopDrawOffset-Self.ColumnsHeaderHeight,
//            Self.GetRightDrawOffset,
//            Self.GetBottomDrawOffset,
//            ADrawStartIndex,
//            ADrawEndIndex
//            );
//
//    for I:=ADrawStartIndex to ADrawEndIndex do
//    begin
//      if (I<Self.FListLayoutsManager.GetVisibleItemsCount)
//        and PtInRect(RowDrawRect(I),PointF(X,Y))
//        and Self.FListLayoutsManager.GetVisibleItem(I).Visible then
//      begin
//        Result:=I;
//        Break;
//      end;
//    end;
//
//  end;
//end;



{ TSkinVirtualGridDefaultType }


function TSkinVirtualGridDefaultType.CustomPaintIndicatorCell(
                                    ACanvas: TDrawCanvas;
                                    ARowIndex:Integer;
                                    ARow:TBaseSkinItem;
                                    ARowDrawRect:TRectF;
                                    ARowEffectStates:TDPEffectStates;
                                    AIndicatorCellDrawRect:TRectF;
                                    ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                    ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                                    const ADrawRect: TRectF;
                                    AVirtualGridPaintData:TPaintData
                                    ): Boolean;
begin
  //绘制指示列单元格的背景色
  DrawRowBackColor(ACanvas,
                  ARowIndex,
                  AIndicatorCellDrawRect,
                  ASkinVirtualGridMaterial.FDrawIndicatorCellBackColorMaterial,
                  False,
                  ARowEffectStates
                  );


  //绘制指示列单元格的的序号
  if ASkinVirtualGridMaterial.FIsDrawIndicatorNumber then
  begin
    ACanvas.DrawText(ASkinVirtualGridMaterial.DrawIndicatorNumberParam,
                    IntToStr(ARowIndex+1),
                    AIndicatorCellDrawRect);
  end;





  //存在表格列头
  //存在指示列
  //并且要画左上角的底边框
  //并且当前垂直位置是0
  //那就不要画指示列单元格的行的开始分隔线了
  //避免线看起来重复
  if Not ( BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0)
          and BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0)
          and BiggerDouble(ASkinVirtualGridMaterial.FDrawIndicatorHeaderBackColor.BorderWidth,0)
          and (beBottom in ASkinVirtualGridMaterial.FDrawIndicatorHeaderBackColor.BorderEadges)
          and EqualDouble(Self.FDrawRectTopOffset,0)) then
  begin
    //绘制指示列单元格的行的开始分隔线
    if (ARowIndex=0)
      and ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FIsDrawRowBeginLine then
    begin
      ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FDrawRowLineParam,
                        AIndicatorCellDrawRect,lpTop);
    end;
  end;





  //绘制指示列单元格的的行的结束分隔线
  if (ARowIndex=Self.FSkinVirtualGridIntf.Prop.ListLayoutsManager.GetVisibleItemsCount-1)
    and ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FIsDrawRowEndLine then
  begin
    ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FDrawRowLineParam,
                          AIndicatorCellDrawRect,lpBottom);
  end;




  //绘制指示列单元格的的行的分隔线
  if (ARowIndex<Self.FSkinVirtualGridIntf.Prop.ListLayoutsManager.GetVisibleItemsCount-1)
     and ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FIsDrawRowLine then
  begin
    ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FDrawRowLineParam,
                    AIndicatorCellDrawRect,lpBottom);
  end;

end;

function TSkinVirtualGridDefaultType.CustomPaintCellContent(
                                                      ACanvas: TDrawCanvas;
                                                      ARowIndex:Integer;
                                                      ARow:TBaseSkinItem;
                                                      ARowDrawRect:TRectF;
                                                      AColumn:TSkinVirtualGridColumn;
                                                      AColumnIndex:Integer;
                                                      ACellDrawRect:TRectF;
                                                      ARowEffectStates:TDPEffectStates;
                                                      ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                                      ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                                                      const ADrawRect: TRectF;
                                                      AVirtualGridPaintData:TPaintData
                                                      ): Boolean;
const
  Const_DrawCheckBoxSize=24;
var
  ACheckBoxCurrentEffectStates:TDPEffectStates;
//  AColumnContentType:TSkinGridColumnContentTypes;
  ACellCheckBoxDrawRect:TRectF;
  ACellValueObject:TObject;
begin

      //不绘制正在编辑的单元格
      if (ARow=Self.FSkinVirtualGridIntf.Prop.FEditingItem)
        and (AColumn=Self.FSkinVirtualGridIntf.Prop.FEditingCellCol) then
      begin
        Exit;
      end;


      //BindItemFieldName
      if AColumn.GetBindItemFieldName<>'' then
      begin
          case AColumn.GetValueType(ARow) of
            varObject:
            begin
                ACellValueObject:=Self.FSkinVirtualGridIntf.Prop.GetCellValueObject(AColumn,ARow);
                if ACellValueObject<>nil then
                begin
                  //画图片
                  ACanvas.DrawPicture(ADrawColumnMaterial.DrawCellPictureParam,
                                      //TBaseDrawPicture(AItemRow.GetObjectByBindItemField(AItemColumn.FBindItemFieldName)),
                                      TBaseDrawPicture(ACellValueObject),
                                      ACellDrawRect);
                end;
            end;
            varBoolean:
            begin
                //绘制复选框

                //是否勾选
                ACheckBoxCurrentEffectStates:=[];
                if Self.FSkinVirtualGridIntf.Prop.GetCellValue(AColumn,ARow)=True then
                begin
                  ACheckBoxCurrentEffectStates:=[dpstPushed];
                end;
                ProcessMaterialEffectStates(ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial,
                                            1,
                                            ACheckBoxCurrentEffectStates,
                                            GlobalNullPaintData
                                            );

                //绘制复选框的位置
                ACellCheckBoxDrawRect.Left:=ACellDrawRect.Left
                                            +(ACellDrawRect.Width-Const_DrawCheckBoxSize)/2;
                ACellCheckBoxDrawRect.Top:=ACellDrawRect.Top
                                            +(ACellDrawRect.Height-Const_DrawCheckBoxSize)/2;
                ACellCheckBoxDrawRect.Right:=ACellCheckBoxDrawRect.Left+Const_DrawCheckBoxSize;
                ACellCheckBoxDrawRect.Bottom:=ACellCheckBoxDrawRect.Top+Const_DrawCheckBoxSize;

                ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial.DrawTo(
                                              ACanvas,
                                              '',
                                              ACellCheckBoxDrawRect,
                                              ACheckBoxCurrentEffectStates=[dpstPushed]);
            end;
            varEmpty:
            begin
              //不绘制
            end
            else
            begin
                //绘制文本
                if ADrawColumnMaterial<>nil then
                begin
                  ADrawColumnMaterial.DrawCellTextParam.StaticEffectStates:=ARowEffectStates;
                  ACanvas.DrawText(ADrawColumnMaterial.FDrawCellTextParam,
                                  Self.FSkinVirtualGridIntf.Prop.GetGridCellText(AColumn,ARow),
                                  ACellDrawRect);

                end;
            end;
          end;
      end;






      if AColumn.GetBindItemFieldName1<>'' then
      begin
          //BindItemFieldName1
          case AColumn.GetValueType1(ARow) of
            varObject:
            begin
                ACellValueObject:=Self.FSkinVirtualGridIntf.Prop.GetCellValue1Object(AColumn,ARow);
                if ACellValueObject<>nil then
                begin
                  ACanvas.DrawPicture(ADrawColumnMaterial.DrawCellPictureParam,
                                    //TBaseDrawPicture(AItemRow.GetObjectByBindItemField(AItemColumn.FBindItemFieldName)),
                                    TBaseDrawPicture(ACellValueObject),
                                    ACellDrawRect);
                end;
            end;
            varBoolean:
            begin
                //绘制复选框

                //是否勾选
                ACheckBoxCurrentEffectStates:=[];
                if Self.FSkinVirtualGridIntf.Prop.GetCellValue1(AColumn,ARow)=True then
                begin
                  ACheckBoxCurrentEffectStates:=[dpstPushed];
                end;
                ProcessMaterialEffectStates(ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial,
                                            1,
                                            ACheckBoxCurrentEffectStates,
                                            GlobalNullPaintData
                                            );

                //绘制复选框的位置
                ACellCheckBoxDrawRect.Left:=ACellDrawRect.Left
                                            +(ACellDrawRect.Width-Const_DrawCheckBoxSize)/2;
                ACellCheckBoxDrawRect.Top:=ACellDrawRect.Top
                                            +(ACellDrawRect.Height-Const_DrawCheckBoxSize)/2;
                ACellCheckBoxDrawRect.Right:=ACellCheckBoxDrawRect.Left+Const_DrawCheckBoxSize;
                ACellCheckBoxDrawRect.Bottom:=ACellCheckBoxDrawRect.Top+Const_DrawCheckBoxSize;

                ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial.DrawTo(
                                              ACanvas,
                                              '',
                                              ACellCheckBoxDrawRect,
                                              ACheckBoxCurrentEffectStates=[dpstPushed]);
            end;
            varEmpty:
            begin
              //不绘制
            end
            else
            begin
                //绘制文本
                if ADrawColumnMaterial<>nil then
                begin
                  ADrawColumnMaterial.DrawCellTextParam.StaticEffectStates:=ARowEffectStates;
                  ACanvas.DrawText(ADrawColumnMaterial.FDrawCellText1Param,
                                  Self.FSkinVirtualGridIntf.Prop.GetGridCellText1(AColumn,ARow),
                                  ACellDrawRect);

                end;
            end;
          end;
      end;



//      AColumnContentType:=AColumn.GetContentTypes;
//      if cctText in AColumnContentType then
//      begin
//          //绘制文本
//          if ADrawColumnMaterial<>nil then
//          begin
//            ADrawColumnMaterial.DrawCellTextParam.StaticEffectStates:=ARowEffectStates;
//            ACanvas.DrawText(ADrawColumnMaterial.FDrawCellTextParam,
//                            Self.FSkinVirtualGridIntf.Prop.GetGridCellText(AColumn,ARow),
//                            ACellDrawRect);
//
//          end;
//      end;


//      if (cctCheckBox in AColumnContentType)
////        or (AColumn.GetBindItemFieldName<>'') and (ARow.GetValueTypeByBindItemField(AColumn.GetBindItemFieldName)=varBoolean)
//        then
//      begin
//          //绘制复选框
//
//          //是否勾选
//          ACheckBoxCurrentEffectStates:=[];
//          if Self.FSkinVirtualGridIntf.Prop.GetGridCellChecked(AColumn,ARow) then
//          begin
//            ACheckBoxCurrentEffectStates:=[dpstPushed];
//          end;
//          ProcessMaterialEffectStates(ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial,
//                                      1,
//                                      ACheckBoxCurrentEffectStates,
//                                      GlobalNullPaintData
//                                      );
//
//          //绘制复选框的位置
//          ACellCheckBoxDrawRect.Left:=ACellDrawRect.Left
//                                      +(ACellDrawRect.Width-Const_DrawCheckBoxSize)/2;
//          ACellCheckBoxDrawRect.Top:=ACellDrawRect.Top
//                                      +(ACellDrawRect.Height-Const_DrawCheckBoxSize)/2;
//          ACellCheckBoxDrawRect.Right:=ACellCheckBoxDrawRect.Left+Const_DrawCheckBoxSize;
//          ACellCheckBoxDrawRect.Bottom:=ACellCheckBoxDrawRect.Top+Const_DrawCheckBoxSize;
//
//          ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial.DrawTo(
//                                        ACanvas,
//                                        '',
//                                        ACellCheckBoxDrawRect
//                                        );
//      end;




end;

function TSkinVirtualGridDefaultType.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData): Boolean;
var
  AHeaderDrawRect:TRectF;
begin
  Result:=Inherited;

  {$IFDEF VCL}

  if
      //设置了列头的高度
      BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0) then
  begin

      //绘制列头
      AHeaderDrawRect:=Self.FSkinVirtualGridIntf.Prop.GetContentRect_Header;
      //列头不能上下滑动的,所以不需要加上上下偏移
      //加上水平滚动偏移
      AHeaderDrawRect.Left:=AHeaderDrawRect.Left-Self.FDrawRectLeftOffset;
      AHeaderDrawRect.Right:=AHeaderDrawRect.Right-Self.FDrawRectRightOffset;

      Self.CustomPaintColumnsHeader(
                                ACanvas,
                                ASkinMaterial,
                                RectF(0,0,ADrawRect.Width,ADrawRect.Height),
                                APaintData,

                                AHeaderDrawRect,

//                                FDrawColumnStartIndex,
//                                FDrawColumnEndIndex,

                                TSkinVirtualGridDefaultMaterial(ASkinMaterial));

  end;
  {$ENDIF}


end;

function TSkinVirtualGridDefaultType.CustomPaintCell(
                                                      ACanvas: TDrawCanvas;
                                                      ARowIndex:Integer;
                                                      ARow:TBaseSkinItem;
                                                      ARowDrawRect:TRectF;
                                                      AColumn:TSkinVirtualGridColumn;
                                                      AColumnIndex:Integer;
                                                      ACellDrawRect:TRectF;
                                                      ARowEffectStates:TDPEffectStates;
                                                      ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                                      ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                                                      const ADrawRect: TRectF;
                                                      AVirtualGridPaintData:TPaintData
                                                      ): Boolean;
var
  ABindCellControl:TChildControl;
  ABindCellControl1:TChildControl;
  AItemDesignerPanel:TSkinItemDesignerPanel;
  AItemPaintData:TPaintData;
  AIsDrawItemInteractiveState:Boolean;
  ACustomListItemPaintOtherData:TVirtualListItemPaintOtherData;
begin
  //AColumn.FDefaultItemStyleSetting.FCustomListProperties:=Self.FSkinVirtualGridIntf.Prop;
  AItemDesignerPanel:=AColumn.FDefaultItemStyleSetting.GetInnerItemDesignerPanel(ARow);





  //绘制单元格
  if Assigned(Self.FSkinVirtualGridIntf.OnCustomPaintCellBegin) then
  begin
    Self.FSkinVirtualGridIntf.OnCustomPaintCellBegin(
                                                     ACanvas,
                                                     ARowIndex,
                                                     ARow,
                                                     ARowDrawRect,
                                                     AColumn,
                                                     AColumnIndex,
                                                     ACellDrawRect,
                                                     ARowEffectStates,
                                                     ASkinVirtualGridMaterial,
                                                     ADrawColumnMaterial,
                                                     AItemDesignerPanel,
                                                     ADrawRect,
                                                     AVirtualGridPaintData
                                                     );
  end;



  //如果单元格选中了,那么绘制选中的单元格背景色
  //并且是单元格选择模式
  if    (ARow=Self.FSkinVirtualGridIntf.Prop.FSelectedItem)
    and (AColumn=Self.FSkinVirtualGridIntf.Prop.FClickedCellCol)
    and (not Self.FSkinVirtualGridIntf.Prop.FIsRowSelect) then
  begin
//      ARowEffectStates:=ARowEffectStates+[dpstPushed];
    ACanvas.DrawRect(ASkinVirtualGridMaterial.FDrawSelectedCellBackColorParam,
                      ACellDrawRect);
  end;








  if AItemDesignerPanel<>nil then
  begin
      AIsDrawItemInteractiveState:=False;


//      //自动调整ItemDesignerPanel的尺寸(区分设计时与运行时)
//      if  ASkinVirtualListMaterial.FIsAutoAdjustItemDesignerPanelSize then
//      begin
//        AutoAdjustItemDesignerPanelSize(AItemDesignerPanel,ASkinItem);
//      end;


      //自动调整ItemDesignerPanel的尺寸(区分设计时与运行时)
      AItemDesignerPanel.Width:=Ceil(ACellDrawRect.Width);
      AItemDesignerPanel.Height:=Ceil(ACellDrawRect.Height);


//      //准备绘制列表项
//      FSkinVirtualGridIntf.Prop.CallOnPrepareDrawItemEvent(
//            Self,
//            ACanvas,
//            ASkinItem,
//            AItemDrawRect,
//            AIsDrawItemInteractiveState);


      //从设计面板上获取到绑定的控件
      ABindCellControl:=AItemDesignerPanel.Prop.FindControlByBindItemFieldName(AItemDesignerPanel,'GridCellValue');
      ABindCellControl1:=AItemDesignerPanel.Prop.FindControlByBindItemFieldName(AItemDesignerPanel,'GridCellValue1');
      if ABindCellControl=nil then
      begin
        //如果设计面板上某个控件绑定的是ItemCaption,那么就把单元格的文本赋给这个控件
        ABindCellControl:=AItemDesignerPanel.Prop.FindControlByBindItemFieldName(AItemDesignerPanel,'ItemCaption');
        ABindCellControl1:=AItemDesignerPanel.Prop.FindControlByBindItemFieldName(AItemDesignerPanel,'ItemDetail');
      end;


      AItemDesignerPanel.Prop.SetControlsValueByItem(
                                                    nil,//Self.FSkinVirtualGridIntf.Prop.SkinImageList,
                                                    TSkinItem(ARow),
                                                    AIsDrawItemInteractiveState);//False);//


      //设置绑定控件的值
      if (ABindCellControl<>nil) and (AColumn.GetBindItemFieldName<>'') then
      begin
        AItemDesignerPanel.Prop.SetSkinItemBindingControlValueByItem(ABindCellControl,
                                                                      nil,
                                                                      ARow,
                                                                      AColumn.GetBindItemFieldName,
                                                                      Self.FSkinVirtualGridIntf.Prop.GetCellValueType(AColumn,ARow),
                                                                      Self.FSkinVirtualGridIntf.Prop.GetCellValue(AColumn,ARow),
                                                                      Self.FSkinVirtualGridIntf.Prop.GetCellValueObject(AColumn,ARow),
                                                                      AIsDrawItemInteractiveState);
      end;
      if (ABindCellControl1<>nil) and (AColumn.GetBindItemFieldName1<>'') then
      begin
        AItemDesignerPanel.Prop.SetSkinItemBindingControlValueByItem(ABindCellControl1,
                                                                    nil,
                                                                    ARow,
                                                                    AColumn.GetBindItemFieldName1,
                                                                    Self.FSkinVirtualGridIntf.Prop.GetCellValue1Type(AColumn,ARow),
                                                                    Self.FSkinVirtualGridIntf.Prop.GetCellValue1(AColumn,ARow),
                                                                    Self.FSkinVirtualGridIntf.Prop.GetCellValue1Object(AColumn,ARow),
                                                                    AIsDrawItemInteractiveState);
      end;



      //再调用OnPrepareDrawItem事件




//      AItemDesignerPanel.Prop.SetControlsValueByItem(
//            nil,
//            TBaseSkinItem(ARow),
//            AIsDrawItemInteractiveState);

      //AItemDesignerPanel绘制
      if (AItemDesignerPanel.SkinControlType<>nil) then
      begin


//              //备份颜色
//              if (Self.FSkinVirtualGridIntf.Prop.ItemColorType<>sictNone)
//                and (ASkinItem.Color<>NullColor) then
//              begin
//                AItemDesignerPanel.Prop.ProcessItemBindingControlColor(Self.FSkinVirtualGridIntf.Prop.ItemColorType,ASkinItem.Color,ATempColor);
//              end;
//
//
//              //绘制列表项背景色(因为有些功能要启动,比如GroupRoundRect)
//              ACanvas.DrawRect(ASkinVirtualItemMaterial.FDrawItemBackColorParam,AItemDrawRect);



              AItemDesignerPanel.SkinControlType.IsUseCurrentEffectStates:=True;
              AItemDesignerPanel.SkinControlType.CurrentEffectStates:=ARowEffectStates;

              //绘制ItemDesignerPanel的背景,背景色
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=True;
              AItemPaintData.IsInDrawDirectUI:=True;
              AItemDesignerPanel.SkinControlType.Paint(ACanvas,
                        AItemDesignerPanel.SkinControlType.GetPaintCurrentUseMaterial,
                        ACellDrawRect,
                        AItemPaintData);
              //绘制ItemDesignerPanel的子控件
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=AIsDrawItemInteractiveState;
              AItemPaintData.IsInDrawDirectUI:=True;
              //正在编辑的绑定控件不绘制
              ACustomListItemPaintOtherData.IsEditingItem:=False;//(Self.FSkinVirtualGridIntf.Prop.FEditingItem=ARow) and (AColumn=Self.FSkinVirtualGridIntf.Prop.FEditingCellCol);

//              ACustomListItemPaintOtherData.EditingItemDataType:=Self.FSkinVirtualGridIntf.Prop.FEditingItem_DataType;
//              ACustomListItemPaintOtherData.EditingSubItemsIndex:=Self.FSkinVirtualGridIntf.Prop.FEditingItem_SubItemsIndex;
//              ACustomListItemPaintOtherData.EditingItemDataType:=Self.FSkinVirtualGridIntf.Prop.FEditingItem_DataType;
//              ACustomListItemPaintOtherData.EditingItemFieldName:=Self.FSkinVirtualGridIntf.Prop.FEditingItem_FieldName;
              AItemPaintData.OtherData:=@ACustomListItemPaintOtherData;
              AItemDesignerPanel.SkinControlType.DrawChildControls(ACanvas,ACellDrawRect,AItemPaintData,ACellDrawRect);




//              //更新编辑框的位置和尺寸
//              if Self.FSkinVirtualGridIntf.Prop.FEditingItem<>nil then
//              begin
//                  If Self.FSkinVirtualGridIntf.Prop.FEditingItem<>ASkinItem then
//                  begin
//
//                      //使用相同的绘制面板
//                      if ASkinItem.FDrawItemDesignerPanel=
//                        TBaseSkinItem(Self.FSkinVirtualGridIntf.Prop.FEditingItem).FDrawItemDesignerPanel then
//                      begin
//                          //如果BindingControl和EditControl相同
//                          //那么编辑时,BindingControl的Parent设置为了ListBox
//                          //没有在ItemDesignerPanel上面了
//                          //所以需要自己将它画上去
//                          if Self.FSkinVirtualGridIntf.Prop.FEditingItem_BindingControl
//                              =Self.FSkinVirtualGridIntf.Prop.FEditingItem_EditControl then
//                          begin
//                              Self.FSkinVirtualGridIntf.Prop.FEditingItem_BindingControlIntf.GetSkinControlType.Paint(
//                                  ACanvas,
//                                  Self.FSkinVirtualGridIntf.Prop.FEditingItem_BindingControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial,
//                                  RectF(AItemDrawRect.Left
//                                            +Self.FSkinVirtualGridIntf.Prop.FEditingItem_EditControlPutRect.Left,
//                                        AItemDrawRect.Top
//                                            +Self.FSkinVirtualGridIntf.Prop.FEditingItem_EditControlPutRect.Top,
//                                        AItemDrawRect.Left
//                                            +Self.FSkinVirtualGridIntf.Prop.FEditingItem_EditControlPutRect.Left
//                                            +Self.FSkinVirtualGridIntf.Prop.FEditingItem_EditControlPutRect.Width,
//                                        AItemDrawRect.Top
//                                           +Self.FSkinVirtualGridIntf.Prop.FEditingItem_EditControlPutRect.Top
//                                           +Self.FSkinVirtualGridIntf.Prop.FEditingItem_EditControlPutRect.Height
//                                        ),
//                                  AItemPaintData
//                                  );
//                          end;
//                      end;
//
//
//                  end;
//              end;




//              //还原颜色
//              if (Self.FSkinVirtualGridIntf.Prop.ItemColorType<>sictNone)
//                  and (ASkinItem.Color<>NullColor) then
//              begin
//                AItemDesignerPanel.Prop.RestoreItemBindingControlColor(Self.FSkinVirtualGridIntf.Prop.ItemColorType,ASkinItem.Color,ATempColor);
//              end;


      end;

  end
  else
  begin


    //绘制单元格内容
    CustomPaintCellContent(ACanvas,
                          ARowIndex,
                          ARow,
                          ARowDrawRect,
                          AColumn,
                          AColumnIndex,
                          ACellDrawRect,
                          ARowEffectStates,
                          ASkinVirtualGridMaterial,
                          ADrawColumnMaterial,
                          ADrawRect,
                          AVirtualGridPaintData
                          );


//      //不绘制正在编辑的单元格
//      if (ARow=Self.FSkinVirtualGridIntf.Prop.FEditingItem)
//        and (AColumn=Self.FSkinVirtualGridIntf.Prop.FEditingCellCol) then
//      begin
//        Exit;
//      end;
//
//
//      AColumnContentType:=AColumn.GetContentTypes;
//      if cctText in AColumnContentType then
//      begin
//          //绘制文本
//          if ADrawColumnMaterial<>nil then
//          begin
//            ADrawColumnMaterial.DrawCellTextParam.StaticEffectStates:=ARowEffectStates;
//            ACanvas.DrawText(ADrawColumnMaterial.FDrawCellTextParam,
//                            Self.FSkinVirtualGridIntf.Prop.GetGridCellText(AColumn,ARow),
//                            ACellDrawRect);
//
//          end;
//      end;
//
//
//      if cctCheckBox in AColumnContentType then
//      begin
//          //绘制复选框
//
//          //是否勾选
//          ACheckBoxCurrentEffectStates:=[];
//          if Self.FSkinVirtualGridIntf.Prop.GetGridCellChecked(AColumn,ARow) then
//          begin
//            ACheckBoxCurrentEffectStates:=[dpstPushed];
//          end;
//          ProcessMaterialEffectStates(ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial,
//                                      1,
//                                      ACheckBoxCurrentEffectStates,
//                                      GlobalNullPaintData
//                                      );
//
//          //绘制复选框的位置
//          ACellCheckBoxDrawRect.Left:=ACellDrawRect.Left
//                                      +(ACellDrawRect.Width-Const_DrawCheckBoxSize)/2;
//          ACellCheckBoxDrawRect.Top:=ACellDrawRect.Top
//                                      +(ACellDrawRect.Height-Const_DrawCheckBoxSize)/2;
//          ACellCheckBoxDrawRect.Right:=ACellCheckBoxDrawRect.Left+Const_DrawCheckBoxSize;
//          ACellCheckBoxDrawRect.Bottom:=ACellCheckBoxDrawRect.Top+Const_DrawCheckBoxSize;
//
//          ASkinVirtualGridMaterial.FDrawCheckBoxColorMaterial.DrawTo(
//                                        ACanvas,
//                                        '',
//                                        ACellCheckBoxDrawRect
//                                        );
//      end;


  end;

  //绘制单元格
  if Assigned(Self.FSkinVirtualGridIntf.OnCustomPaintCellEnd) then
  begin
    Self.FSkinVirtualGridIntf.OnCustomPaintCellEnd(
                                                     ACanvas,
                                                     ARowIndex,
                                                     ARow,
                                                     ARowDrawRect,
                                                     AColumn,
                                                     AColumnIndex,
                                                     ACellDrawRect,
                                                     ARowEffectStates,
                                                     ASkinVirtualGridMaterial,
                                                     ADrawColumnMaterial,
                                                     AItemDesignerPanel,
                                                     ADrawRect,
                                                     AVirtualGridPaintData
                                                     );
  end;

end;

function TSkinVirtualGridDefaultType.CustomPaintFooterCell(
                                                ACanvas: TDrawCanvas;
                                                AFooterRowIndex:Integer;
                                                AFooterRowDrawRect:TRectF;
                                                AColumn:TSkinVirtualGridColumn;
                                                AColumnIndex:Integer;
                                                ACellDrawRect:TRectF;
                                                ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                                const ADrawRect: TRectF;
                                                AVirtualGridPaintData:TPaintData
                                                ): Boolean;
var
  ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
begin
  if (AColumn.Footer.FValueType<>fvtNone) and (AColumn.Footer.GetValue<>'') then
  begin
      //绘制统计
      ADrawColumnMaterial:=ASkinVirtualGridMaterial.FDrawColumnMaterial;
      if Not AColumn.FIsUseDefaultGridColumnMaterial then
      begin
        ADrawColumnMaterial:=AColumn.FMaterial;
      end;

      if ADrawColumnMaterial<>nil then
      begin
        //AColumn.Footer.FValue
        ACanvas.DrawText(ADrawColumnMaterial.FDrawFooterCellTextParam,
                          AColumn.Footer.Value,
                          ACellDrawRect);
      end;
  end;
end;

function TSkinVirtualGridDefaultType.CustomPaintIndicatorFooterCell(
                                                ACanvas: TDrawCanvas;
                                                AFooterRowIndex:Integer;
                                                AFooterRowDrawRect:TRectF;
                                                AIndicatorCellDrawRect:TRectF;
                                                ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                                const ADrawRect: TRectF;
                                                AVirtualGridPaintData:TPaintData
                                                ): Boolean;
begin
  //绘制统计区的指示列单元格
  DrawRowBackColor(ACanvas,
                  AFooterRowIndex,
                  AIndicatorCellDrawRect,
                  ASkinVirtualGridMaterial.FDrawIndicatorFooterCellBackColorMaterial,
                  False,
                  []
                  );
end;

function TSkinVirtualGridDefaultType.CustomDrawItemContent(
                                ACanvas: TDrawCanvas;
                                AItemIndex:Integer;
                                AItem:TBaseSkinItem;
                                AItemDrawRect:TRectF;
                                ASkinMaterial:TSkinCustomListDefaultMaterial;
                                const ADrawRect: TRectF;
                                ACustomListPaintData:TPaintData;
                                ASkinItemMaterial:TBaseSkinListItemMaterial;
                                AItemEffectStates:TDPEffectStates;
                                AIsDrawItemInteractiveState:Boolean): Boolean;
var
  I: Integer;
  ACellDrawRect:TRectF;
  AIndicatorCellDrawRect:TRectF;
  ARowBackColorDrawRect:TRectF;

//  ASkinItem:TSkinItem;
var
  AClipRect:TRectF;
  AColumn:TSkinVirtualGridColumn;
  ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
  ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;

  ALineRect:TRectF;
begin
//    //绘制表格数据行
//    ASkinItem:=TSkinItem(AItem);


    //绘制列表项的背景
    Inherited;

    ASkinVirtualGridMaterial:=TSkinVirtualGridDefaultMaterial(ASkinMaterial);




//    //备份颜色
//    if (Self.FSkinVirtualGridIntf.Prop.ItemColorType<>sictNone)
//      and (ASkinItem.Color<>NullColor) then
//    begin
//        case Self.FSkinVirtualGridIntf.Prop.ItemColorType of
//          sictNone: ;
//          sictBackColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemBackColorParam.FillDrawColor.FColor;
//            ASkinVirtualItemMaterial.FDrawItemBackColorParam.FillDrawColor.FColor:=ASkinItem.Color;
//          end;
//          sictCaptionFontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemCaptionParam.FontColor;
//            ASkinVirtualItemMaterial.DrawItemCaptionParam.FontColor:=ASkinItem.Color;
//          end;
//          sictDetailFontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetailParam.FontColor;
//            ASkinVirtualItemMaterial.FDrawItemDetailParam.FontColor:=ASkinItem.Color;
//          end;
//          sictDetail1FontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail1Param.FontColor;
//            ASkinVirtualItemMaterial.FDrawItemDetail1Param.FontColor:=ASkinItem.Color;
//          end;
//          sictDetail2FontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail2Param.FontColor;
//            ASkinVirtualItemMaterial.FDrawItemDetail2Param.FontColor:=ASkinItem.Color;
//          end;
//          sictDetail3FontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail3Param.FontColor;
//            ASkinVirtualItemMaterial.FDrawItemDetail3Param.FontColor:=ASkinItem.Color;
//          end;
//          sictDetail4FontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail4Param.FontColor;
//            ASkinVirtualItemMaterial.FDrawItemDetail4Param.FontColor:=ASkinItem.Color;
//          end;
//          sictDetail5FontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail5Param.FontColor;
//            ASkinVirtualItemMaterial.FDrawItemDetail5Param.FontColor:=ASkinItem.Color;
//          end;
//          sictDetail6FontColor:
//          begin
//            ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail6Param.FontColor;
//            ASkinVirtualItemMaterial.FDrawItemDetail6Param.FontColor:=ASkinItem.Color;
//          end;
//        end;
//    end;
//
//
//    //绘制列表项背景色
//    ACanvas.DrawRect(ASkinVirtualItemMaterial.FDrawItemBackColorParam,AItemDrawRect);
//
//
//      //还原颜色
//      if (Self.FSkinVirtualGridIntf.Prop.ItemColorType<>sictNone)
//        and (ASkinItem.Color<>NullColor) then
//      begin
//        case Self.FSkinVirtualGridIntf.Prop.ItemColorType of
//          sictNone: ;
//          sictBackColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemBackColorParam.FillDrawColor.FColor:=ATempColor;
//          end;
//          sictCaptionFontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemCaptionParam.FontColor:=ATempColor;
//          end;
//          sictDetailFontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemDetailParam.FontColor:=ATempColor;
//          end;
//          sictDetail1FontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemDetail1Param.FontColor:=ATempColor;
//          end;
//          sictDetail2FontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemDetail2Param.FontColor:=ATempColor;
//          end;
//          sictDetail3FontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemDetail3Param.FontColor:=ATempColor;
//          end;
//          sictDetail4FontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemDetail4Param.FontColor:=ATempColor;
//          end;
//          sictDetail5FontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemDetail5Param.FontColor:=ATempColor;
//          end;
//          sictDetail6FontColor:
//          begin
//            ASkinVirtualItemMaterial.FDrawItemDetail6Param.FontColor:=ATempColor;
//          end;
//        end;
//      end;







    //绘制活动列的数据
    //存在活动列
    if FDrawColumnStartIndex<=FDrawColumnEndIndex then
    begin

      //因为第一行和表头要重合,所以需要剪裁
      //设置绘制剪裁区域
      AClipRect:=Self.FSkinVirtualGridIntf.Properties.GetClientRect_Cells_UnfixedCols;
      OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
      if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
      try

          ARowBackColorDrawRect:=
                Self.FSkinVirtualGridIntf.Prop.GetRowDrawRect_UnfixedCols(ADrawRect,AItemDrawRect);

          //绘制活动列的背景色
          DrawRowBackColor(ACanvas,
                          AItemIndex,
                          ARowBackColorDrawRect,
                          ASkinVirtualGridMaterial.FRowBackColorMaterial,
                          False,
                          AItemEffectStates
                          );


          //绘制活动列的单元格
          for I := FDrawColumnStartIndex to FDrawColumnEndIndex do
          begin
            if I>=FRealFixColCount then
            begin

              //绘制单元格
              //根据表格列的类型来判断绘制
              //比如表格列的内容是字段串的,那么就绘制这个字符串就可以了
              ACellDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);
              //加上水平垂直的偏移
              ACellDrawRect.Top:=AItemDrawRect.Top;
              ACellDrawRect.Bottom:=AItemDrawRect.Bottom;


            
              //绘制单元格          
              AColumn:=TSkinVirtualGridColumn(Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemObject(I));
              //绘制单元格
              //默认的绘制参数
              ADrawColumnMaterial:=ASkinVirtualGridMaterial.FDrawColumnMaterial;

              //自定的绘制参数
              if Not AColumn.FIsUseDefaultGridColumnMaterial then
              begin
                ADrawColumnMaterial:=AColumn.FMaterial;
              end;
            
              CustomPaintCell(ACanvas,
                              AItemIndex,
                              TBaseSkinItem(AItem),
                              AItemDrawRect,
                              AColumn,
                              I,
                              ACellDrawRect,
                              AItemEffectStates,
                              ASkinVirtualGridMaterial,
                              ADrawColumnMaterial,
                              ADrawRect,
                              ACustomListPaintData);

            end;
          end;



          //绘制活动列的表格数据行分隔线
          ALineRect:=ARowBackColorDrawRect;

          //存在表格列头
          //如果要画列头的行尾分隔线
          //并且当前垂直位置是0
          //避免线看起来重复
          if Not (BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0)
                  and ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FIsDrawRowEndLine
                  and EqualDouble(Self.FDrawRectTopOffset,0)) then
          begin
              //绘制表格数据行的开始分隔线
              if (AItemIndex=0)
                and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawRowBeginLine then
              begin
                ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FDrawRowLineParam,
                                    ALineRect,lpTop);
              end;
          end;

          //绘制表格数据行的结束分隔线
          if (AItemIndex=Self.FSkinVirtualGridIntf.Prop.ListLayoutsManager.GetVisibleItemsCount-1)
            and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawRowEndLine then
          begin
            ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FDrawRowLineParam,
                                ALineRect,lpBottom);
          end;


          //绘制表格数据行的分隔线
          if (AItemIndex<Self.FSkinVirtualGridIntf.Prop.ListLayoutsManager.GetVisibleItemsCount-1)
             and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawRowLine then
          begin
            ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FDrawRowLineParam,
                                  ALineRect,lpBottom);
          end;

      finally
        if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
      end;

    end;

    





    //绘制固定列的数据
    //wn
//    if BiggerDouble(FFixedColsWidth,0) then
//    if Self.FSkinVirtualGridIntf.Prop.FFixedCols>0 then
    if FRealFixColCount>0 then
    begin
      if FDrawFixedColumnStartIndex<=FDrawFixedColumnEndIndex then
      begin

        //因为第一行和列表头要重合,所以需要剪裁
        AClipRect:=Self.FSkinVirtualGridIntf.Properties.GetClientRect_Cells_FixedCols;
        OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
        if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
        try

            //绘制固定列的表格数据行的背景色
            ARowBackColorDrawRect:=
                Self.FSkinVirtualGridIntf.Prop.GetRowDrawRect_FixedCols(ADrawRect,AItemDrawRect);

            //区分奇偶行
            DrawRowBackColor(ACanvas,
                            AItemIndex,
                            ARowBackColorDrawRect,
                            ASkinVirtualGridMaterial.FRowBackColorMaterial,
                            True,
                            AItemEffectStates
                            );


            //先绘制固定列的单元格
            //wn
//            for I := 0 to FRealFixColCount-1 do
            for I := Self.FDrawFixedColumnStartIndex to FDrawFixedColumnEndIndex do
            begin
              //绘制单元格
              ACellDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);
              ACellDrawRect.Top:=AItemDrawRect.Top;
              ACellDrawRect.Bottom:=AItemDrawRect.Bottom;


              AColumn:=TSkinVirtualGridColumn(Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemObject(I));
              //绘制单元格
              //默认的绘制参数
              ADrawColumnMaterial:=ASkinVirtualGridMaterial.FDrawColumnMaterial;

              //自定的绘制参数
              if Not AColumn.FIsUseDefaultGridColumnMaterial then
              begin
                ADrawColumnMaterial:=AColumn.FMaterial;
              end;

              CustomPaintCell(ACanvas,
                              AItemIndex,
                              TBaseSkinItem(AItem),
                              AItemDrawRect,
                              AColumn,
                              I,
                              ACellDrawRect,
                              AItemEffectStates,
                              ASkinVirtualGridMaterial,
                              ADrawColumnMaterial,
                              ADrawRect,
                              ACustomListPaintData);
            end;


            //绘制固定列的表格数据行的分隔线
            ALineRect:=ARowBackColorDrawRect;


            //存在表格列头
            //如果要画列头的行尾分隔线
            //并且当前垂直位置是0
            //避免线看起来重复
            if Not ( BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0)
                    and ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FIsDrawRowEndLine
                    and EqualDouble(Self.FDrawRectTopOffset,0)) then
            begin
              //绘制表格数据行的开始分隔线
              if (AItemIndex=0)
                and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawRowBeginLine then
              begin
                ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FDrawRowLineParam,
                                  ALineRect,lpTop);
              end;
            end;

            //绘制表格数据行的结束分隔线
            if (AItemIndex=Self.FSkinVirtualGridIntf.Prop.ListLayoutsManager.GetVisibleItemsCount-1)
              and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawRowEndLine then
            begin
              ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FDrawRowLineParam,
                              ALineRect,lpBottom);
            end;

            //绘制表格数据行的分隔线
            if (AItemIndex<Self.FSkinVirtualGridIntf.Prop.ListLayoutsManager.GetVisibleItemsCount-1)
               and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawRowLine then
            begin
              ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FDrawRowLineParam,
                              ALineRect,lpBottom);
            end;


        finally
          if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
        end;
      end;
    end;








    

    //绘制固定的指示列
    if BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0) then
    begin

        //因为第一行和列表头要重合,所以需要剪裁
        //设置绘制剪裁区域
        AClipRect:=Self.FSkinVirtualGridIntf.Properties.GetClientRect_Grid;
        OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
        if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
        try

              AIndicatorCellDrawRect:=AItemDrawRect;
              //指示列的水平位置固定,在最左边
              AIndicatorCellDrawRect.Left:=ADrawRect.Left;
              AIndicatorCellDrawRect.Right:=AIndicatorCellDrawRect.Left
                                            +Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth;


              //绘制指示列的单元格
              CustomPaintIndicatorCell(ACanvas,
                                      AItemIndex,
                                      TBaseSkinItem(AItem),
                                      AItemDrawRect,
                                      AItemEffectStates,
                                      AIndicatorCellDrawRect,
                                      ASkinVirtualGridMaterial,
                                      ADrawColumnMaterial,
                                      ADrawRect,
                                      ACustomListPaintData);

        finally
          if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
        end;
    end;


//    //不存在表格列,直接退出
//    if (Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount=0) then
//    begin
//      Exit;
//    end;


 


end;

function TSkinVirtualGridDefaultType.CustomPaintFooterRow(
                                                        ACanvas: TDrawCanvas;
                                                        AFooterRowIndex:Integer;
                                                        AFooterRowDrawRect:TRectF;
                                                        ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
                                                        const ADrawRect: TRectF;
                                                        AVirtualGridPaintData:TPaintData
                                                        ): Boolean;
var
  I: Integer;
  ACellDrawRect:TRectF;
  ARowBackColorDrawRect:TRectF;
  ABackColor:TDrawRectParam;
  AClipRect:TRectF;
  AColumn:TSkinVirtualGridColumn;
  AIndicatorCellDrawRect:TRectF;
begin
    if FDrawColumnStartIndex<=FDrawColumnEndIndex then
    begin
      //设置绘制剪裁区域
      AClipRect:=Self.FSkinVirtualGridIntf.Prop.GetClientRect_Footer_UnfixedCols;
      OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
      if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
      try

          //绘制统计区的活动列的行的背景色
          ARowBackColorDrawRect:=
            Self.FSkinVirtualGridIntf.Prop.GetRowDrawRect_UnfixedCols(ADrawRect,AFooterRowDrawRect);

          DrawRowBackColor(ACanvas,
                          AFooterRowIndex,
                          ARowBackColorDrawRect,
                          ASkinVirtualGridMaterial.FFooterRowBackColorMaterial,
                          False,
                          []
                          );


          //绘制统计区的活动列的表格列
          for I := FDrawColumnStartIndex to FDrawColumnEndIndex do
          begin
            if I>=FRealFixColCount then
            begin

              //绘制单元格
              ACellDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);
              ACellDrawRect.Top:=AFooterRowDrawRect.Top;
              ACellDrawRect.Bottom:=AFooterRowDrawRect.Bottom;
              //绘制单元格
              CustomPaintFooterCell(ACanvas,
                                          AFooterRowIndex,
                                          AFooterRowDrawRect,
                                          TSkinVirtualGridColumn(Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemObject(I)),
                                          I,
                                          ACellDrawRect,
                                          ASkinVirtualGridMaterial,
                                          ADrawRect,
                                          AVirtualGridPaintData);

            end;
          end;

      finally
        if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
      end;
    end;




    
    //wn
//    if BiggerDouble(Self.FFixedColsWidth,0) then
//    if Self.FSkinVirtualGridIntf.Prop.FFixedCols>0 then
    if FRealFixColCount>0 then    
    begin
      if FDrawFixedColumnStartIndex<=FDrawFixedColumnEndIndex then
      begin

        //绘制统计区的固定列的行的背景色
        ARowBackColorDrawRect:=
          Self.FSkinVirtualGridIntf.Prop.GetRowDrawRect_FixedCols(ADrawRect,AFooterRowDrawRect);

        DrawRowBackColor(ACanvas,
                        AFooterRowIndex,
                        ARowBackColorDrawRect,
                        ASkinVirtualGridMaterial.FFooterRowBackColorMaterial,
                        True,
                        []
                        );



        //绘制统计区的固定列的单元格
        //wn
//        for I := 0 to FRealFixColCount-1 do
        for I := Self.FDrawFixedColumnStartIndex to FDrawFixedColumnEndIndex do
        begin
          //绘制统计区的单元格
          ACellDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);
          ACellDrawRect.Top:=AFooterRowDrawRect.Top;
          ACellDrawRect.Bottom:=AFooterRowDrawRect.Bottom;
          //绘制单元格
          AColumn:=TSkinVirtualGridColumn(Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemObject(I));
          CustomPaintFooterCell(
                                    ACanvas,
                                    AFooterRowIndex,
                                    AFooterRowDrawRect,
                                    AColumn,
                                    I,
                                    ACellDrawRect,
                                    ASkinVirtualGridMaterial,
                                    ADrawRect,
                                    AVirtualGridPaintData);
        end;


      end;

    end;







  
    //绘制固定的指示列尾部单元格
    if BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0) then
    begin

        AIndicatorCellDrawRect:=AFooterRowDrawRect;
        AIndicatorCellDrawRect.Left:=ADrawRect.Left;
        AIndicatorCellDrawRect.Right:=AIndicatorCellDrawRect.Left
                                      +Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth;

        CustomPaintIndicatorFooterCell(
                                    ACanvas,
                                    AFooterRowIndex,
                                    AFooterRowDrawRect,
                                    AIndicatorCellDrawRect,
                                    ASkinVirtualGridMaterial,
                                    ADrawRect,
                                    AVirtualGridPaintData);
    end;








end;


function TSkinVirtualGridDefaultType.CustomPaintColumn(
                              ACanvas: TDrawCanvas;
                              AColumn:TSkinVirtualGridColumn;
                              AColumnIndex:Integer;
                              AColumnDrawRect:TRectF;
                              ADrawRect: TRectF;
                              APaintData: TPaintData;
                              ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
                              ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial
                              ): Boolean;
begin


  if ADrawColumnMaterial<>nil then
  begin
    //绘制表格列的背景色
    ACanvas.DrawRect(ADrawColumnMaterial.BackColor,AColumnDrawRect);
    //绘制表格列的标题
    ACanvas.DrawText(ADrawColumnMaterial.DrawCaptionParam,
                        AColumn.Caption,
                        AColumnDrawRect);
  end;



  //有固定列
  if (Self.FRealFixColCount>0) then
  begin

      //存在表格列头
      //存在指示列
      //如果要画指示列的列尾分隔线
      //要画左上角的右边框
      //第一列
      //那就不要画表格列的列头分隔线
      //避免线看起来重复
      if Not ( BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0)
              and BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0)
              and BiggerDouble(ASkinVirtualGridMaterial.FDrawIndicatorHeaderBackColor.BorderWidth,0)
              and (beRight in ASkinVirtualGridMaterial.FDrawIndicatorHeaderBackColor.BorderEadges)
              and (AColumnIndex=0)
              ) then
      begin
        //绘制表格列的列头分隔线
        if (AColumnIndex=0)
          and (ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.IsDrawColBeginLine) then
        begin
          ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                                AColumnDrawRect,lpLeft);
        end;
      end;

      //存在表格列头
      //如果要画列的分隔线
      //并且当前水平位置是0
      //活动列的第一列
      //那就不要画表格列的列头分隔线
      //避免线看起来重复
      if Not ( BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0)
              and ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.IsDrawColLine
              and EqualDouble(Self.FDrawRectLeftOffset,0)
              and (AColumnIndex=FRealFixColCount)
              ) then
      begin
        //绘制表格列的列头分隔线
        if (AColumnIndex=FRealFixColCount)
          and (ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.IsDrawColBeginLine) then
        begin
          ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                                AColumnDrawRect,lpLeft);
        end;
      end;



  end
  else
  begin
      //存在表格列头
      //存在指示列
      //如果要画指示列的列尾分隔线
      //要画左上角的右边框
      //并且当前水平位置是0
      //那就不要画表格列的列头分隔线
      //避免线看起来重复
      if Not ( BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0)
              and BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0)
              and BiggerDouble(ASkinVirtualGridMaterial.FDrawIndicatorHeaderBackColor.BorderWidth,0)
              and (beRight in ASkinVirtualGridMaterial.FDrawIndicatorHeaderBackColor.BorderEadges)
              and EqualDouble(Self.FDrawRectLeftOffset,0)
              ) then
      begin
        //绘制表格列的列头分隔线
        if (AColumnIndex=0)
          and (ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.IsDrawColBeginLine) then
        begin
          ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                                AColumnDrawRect,lpLeft);
        end;
      end;

  end;



  //绘制表格列的列尾分隔线
  if (AColumnIndex=Self.FSkinVirtualGridIntf.Prop.Columns.Count-1)
    and (ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.IsDrawColEndLine) then
  begin
    ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                        AColumnDrawRect,lpRight);
  end;

  //绘制表格列的列分隔线
  if (AColumnIndex<Self.FSkinVirtualGridIntf.Prop.Columns.Count-1)
    and (ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.IsDrawColLine) then
  begin
    ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                        AColumnDrawRect,lpRight);
  end;

end;

function TSkinVirtualGridDefaultType.CustomPaintColumnsHeader(ACanvas: TDrawCanvas;
                                                              ASkinMaterial:TSkinControlMaterial;
                                                              const ADrawRect: TRectF;
                                                              APaintData: TPaintData;
                                                              AHeaderDrawRect:TRectF;
//                                                              ADrawColumnStartIndex:Integer;
//                                                              ADrawColumnEndIndex:Integer;
                                                              ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial
                                                              ): Boolean;
var
  I: Integer;
  AColumn:TSkinVirtualGridColumn;
  ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
  ATemp_ColumnHeaderDrawRect:TRectF;
  AColumnDrawRect:TRectF;
  AIndicatorHeaderDrawRect:TRectF;
  AClipRect:TRectF;
begin

  //再绘制活动列
  //设置绘制剪裁区域
  //有需要绘制的活动列
  if FDrawColumnStartIndex<=FDrawColumnEndIndex then
  begin
      AClipRect:=Self.FSkinVirtualGridIntf.Prop.GetClientRect_ColumnHeader_UnfixedCols;
      OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
      if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
      try
          //活动列背景的绘制区域
          ATemp_ColumnHeaderDrawRect:=
            Self.FSkinVirtualGridIntf.Prop.GetRowDrawRect_UnfixedCols(ADrawRect,AHeaderDrawRect);

          //活动列的列头背景
          ACanvas.DrawRect(ASkinVirtualGridMaterial.FColumnHeaderBackColor,
                            ATemp_ColumnHeaderDrawRect);

          //绘制活动的表格列
          for I := FDrawColumnStartIndex to FDrawColumnEndIndex do
          begin
            if I>=FRealFixColCount then
            begin
              AColumn:=TSkinVirtualGridColumn(Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemObject(I));
              AColumnDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);

              //绘制单元格
              //默认的绘制参数
              ADrawColumnMaterial:=ASkinVirtualGridMaterial.FDrawColumnMaterial;
              //自定的绘制参数
//              if Not AColumn.FIsUseDefaultGridColumnMaterial then
              if Not AColumn.FIsUseDefaultGridColumnCaptionParam then
              begin
                ADrawColumnMaterial:=AColumn.FMaterial;
              end;


              CustomPaintColumn(ACanvas,
                                AColumn,
                                I,
                                AColumnDrawRect,
                                ADrawRect,
                                APaintData,
                                ADrawColumnMaterial,
                                ASkinVirtualGridMaterial);
            end;
          end;


          //活动表格列头的行头分隔线
          if ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FIsDrawRowBeginLine then
          begin
            ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                                ATemp_ColumnHeaderDrawRect,lpTop);
          end;


          //活动表格列头的行尾分隔线
          if ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FIsDrawRowEndLine then
          begin
            ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                                ATemp_ColumnHeaderDrawRect,lpBottom);
          end;


      finally
        if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
      end;
  end;




  //wn
  //绘制固定列的列头
//  if BiggerDouble(FFixedColsWidth,0) then
//  if Self.FSkinVirtualGridIntf.Prop.FFixedCols>0 then
  if FRealFixColCount>0 then
  begin

      //需要绘制固定列,开始下标小于结束小标则表示需要绘制一些固定列
      if FDrawFixedColumnStartIndex<=FDrawFixedColumnEndIndex then
      begin
      
            //有固定列,获取固定列头的矩形
            ATemp_ColumnHeaderDrawRect:=
              Self.FSkinVirtualGridIntf.Prop.GetRowDrawRect_FixedCols(ADrawRect,AHeaderDrawRect);


            //固定列的列头背景
            ACanvas.DrawRect(ASkinVirtualGridMaterial.FFixedColumnHeaderBackColor,
                              ATemp_ColumnHeaderDrawRect);

            //绘制固定的表格列
            //wn
      //      for I := 0 to FRealFixColCount-1 do
            for I := Self.FDrawFixedColumnStartIndex to FDrawFixedColumnEndIndex do
            begin
              AColumn:=TSkinVirtualGridColumn(Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemObject(I));
              AColumnDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);

              //绘制单元格
              //默认的绘制参数
              ADrawColumnMaterial:=ASkinVirtualGridMaterial.FDrawColumnMaterial;

              //自定的绘制参数
              if Not AColumn.FIsUseDefaultGridColumnMaterial then
              begin
                ADrawColumnMaterial:=AColumn.FMaterial;
              end;

              CustomPaintColumn(ACanvas,
                                AColumn,
                                I,
                                AColumnDrawRect,
                                ADrawRect,
                                APaintData,
                                ADrawColumnMaterial,
                                ASkinVirtualGridMaterial);
            end;



            //固定表格列头的行头分隔线
            if ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FIsDrawRowBeginLine then
            begin
              ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                                  ATemp_ColumnHeaderDrawRect,lpTop);
            end;


            //固定表格列头的行尾分隔线
            if ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FIsDrawRowEndLine then
            begin
              ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawColumnDevideMaterial.FDrawColLineParam,
                                  ATemp_ColumnHeaderDrawRect,lpBottom);
            end;

      end;
  end;






  
  //绘制固定的指示列头,也就是左上角
  if BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0) then
  begin

    AIndicatorHeaderDrawRect:=AHeaderDrawRect;
    AIndicatorHeaderDrawRect.Left:=ADrawRect.Left;
    AIndicatorHeaderDrawRect.Right:=AIndicatorHeaderDrawRect.Left
                                    +Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth;
//                              +Self.FSkinVirtualGridIntf.Prop.GetClientRect_Cells.Left;

    ACanvas.DrawRect(ASkinVirtualGridMaterial.FDrawIndicatorHeaderBackColor,
                      AIndicatorHeaderDrawRect);
  end;



//  //不存在表格列
//  if (Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount=0) then
//  begin
//    Exit;
//  end;



end;

function TSkinVirtualGridDefaultType.CustomPaintContentBegin(
                                    ACanvas:TDrawCanvas;
                                    ASkinMaterial:TSkinControlMaterial;
                                    const ADrawRect:TRectF;
                                    APaintData:TPaintData)
                                    :Boolean;
begin
  //准备工作



  FDrawColumnStartIndex:=0;
  FDrawColumnEndIndex:=-1;

  FDrawFixedColumnStartIndex:=0;
  FDrawFixedColumnEndIndex:=-1;


  //判断真实的固定列的个数
  FRealFixColCount:=Self.FSkinVirtualGridIntf.Prop.GetRealFixedColCount;


  //计算固定的表格列的起始下标
  Self.FSkinVirtualGridIntf.Prop.ColumnLayoutsManager.CalcDrawStartAndEndIndex(
                            0,//固定列不需要移动,左边坐标永远是0
                            Self.FSkinScrollControlIntf.Prop.GetTopDrawOffset,
                            Self.FSkinVirtualGridIntf.Prop.ColumnLayoutsManager.GetControlWidth,
                            Self.FSkinVirtualGridIntf.Prop.ColumnLayoutsManager.GetControlHeight,
                            FDrawFixedColumnStartIndex,
                            FDrawFixedColumnEndIndex);
  if FDrawFixedColumnEndIndex>Self.FSkinVirtualGridIntf.Prop.FFixedCols-1 then
  begin
    FDrawFixedColumnEndIndex:=Self.FSkinVirtualGridIntf.Prop.FFixedCols-1;
  end;
//  uBaseLog.OutputDebugString(Self.FSkinControl.Name
//                            +' FDrawFixedColumnStartIndex:'+IntToStr(FDrawFixedColumnStartIndex)
//                            +' FDrawFixedColumnEndIndex:'+IntToStr(FDrawFixedColumnEndIndex)
//                            );




  //计算活动的表格列的起始下标
  Self.FSkinVirtualGridIntf.Prop.ColumnLayoutsManager.CalcDrawStartAndEndIndex(
                            Self.FSkinScrollControlIntf.Prop.GetLeftDrawOffset
                                +Self.FSkinVirtualGridIntf.Prop.GetRealFixedColsDrawRight,
                            Self.FSkinScrollControlIntf.Prop.GetTopDrawOffset,
                            Self.FSkinVirtualGridIntf.Prop.ColumnLayoutsManager.GetControlWidth
                                -Self.FSkinVirtualGridIntf.Prop.GetRealFixedColsDrawRight,
                            Self.FSkinVirtualGridIntf.Prop.ColumnLayoutsManager.GetControlHeight,
                            FDrawColumnStartIndex,
                            FDrawColumnEndIndex);
  if FDrawColumnStartIndex<Self.FRealFixColCount then
  begin
    FDrawColumnStartIndex:=FRealFixColCount;
  end;
//  uBaseLog.OutputDebugString(Self.FSkinControl.Name
//                            +' FDrawColumnStartIndex:'+IntToStr(FDrawColumnStartIndex)
//                            +' FDrawColumnEndIndex:'+IntToStr(FDrawColumnEndIndex)
//                            );



end;

function TSkinVirtualGridDefaultType.CustomPaintColumnsFooter(
                                      ACanvas:TDrawCanvas;
                                      ASkinMaterial:TSkinControlMaterial;
                                      const ADrawRect:TRectF;
                                      APaintData:TPaintData;
                                      ADrawStartIndex:Integer;
                                      ADrawEndIndex:Integer;
                                      ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial
                                      ):Boolean;
var
  I: Integer;
  AFooterRowDrawRect:TRectF;
begin



  //绘制统计行
  for I := 0 to Self.FSkinVirtualGridIntf.Prop.FFooterRowCount-1 do
  begin
    AFooterRowDrawRect:=Self.FSkinVirtualGridIntf.Prop.FooterRowRect(I);

    //统计不能上下滑动的,所以不需要加上上下偏移
    //算上水平滚动偏移
    AFooterRowDrawRect.Left:=AFooterRowDrawRect.Left-FDrawRectLeftOffset;
    AFooterRowDrawRect.Right:=AFooterRowDrawRect.Right-FDrawRectRightOffset;

    OffsetRect(AFooterRowDrawRect,ADrawRect.Left,ADrawRect.Top);
    //绘制统计行
    CustomPaintFooterRow(ACanvas,
                        I,
                        AFooterRowDrawRect,
                        ASkinVirtualGridMaterial,
                        ADrawRect,
                        APaintData);


  end;

end;

function TSkinVirtualGridDefaultType.AdvancedCustomPaintContent(
                                        ACanvas:TDrawCanvas;
                                        ASkinMaterial:TSkinControlMaterial;
                                        const ADrawRect:TRectF;
                                        APaintData:TPaintData
                                        ):Boolean;
var
  I: Integer;
  AColumnHeaderDrawRect:TRectF;
  AFixedColsColumnHeaderClipRect:TRectF;
var
  AColumnDrawRect:TRectF;
  ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
  ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
  ALineRect:TRectF;
  AClipRect:TRectF;
var
//  I: Integer;
  AHeaderDrawRect:TRectF;
begin

  ASkinVirtualGridMaterial:=TSkinVirtualGridDefaultMaterial(ASkinMaterial);


  //存在表格列
  if (Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount>0) then
  begin
      //绘制统计区
      CustomPaintColumnsFooter(
                              ACanvas,
                              ASkinMaterial,
                              ADrawRect,
                              APaintData,

                              FDrawColumnStartIndex,
                              FDrawColumnEndIndex,

                              ASkinVirtualGridMaterial
                              );
  end;



  //没有需要绘制的行,那就不需要绘制分隔线
  if Self.FFirstDrawItem<>nil then
  begin





          //绘制固定的指示列尾部分隔线
          AClipRect:=Self.FSkinVirtualGridIntf.Prop.GetClientRect_Grid;
          OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
          if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
          try

              if BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0) then
              begin

                  ALineRect.Left:=ADrawRect.Left;
                  ALineRect.Top:=Self.FFirstDrawItemRect.Top;
                  ALineRect.Right:=ADrawRect.Left
                                  +Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth;
                  //画到最后一行表格数据行的底部为止
                  ALineRect.Bottom:=Self.FLastRowDrawItemRect.Bottom;


                  //绘制指示列的开始分隔线
                  if ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FIsDrawColBeginLine then
                  begin
                    ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FDrawColLineParam,
                                          ALineRect,lpLeft);
                  end;

                  //绘制指示列的结束分隔线
                  if ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FIsDrawColEndLine then
                  begin
                    ACanvas.DrawRectLine(ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FDrawColLineParam,
                                          ALineRect,lpRight);
                  end;
              end;

          finally
            if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
          end;



        //  //不存在表格列
        //  if (Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount=0) then
        //  begin
        //    Exit;
        //  end;



          if FRealFixColCount>0 then
          begin
              //绘制固定列分隔线
              AClipRect:=Self.FSkinVirtualGridIntf.Prop.GetClientRect_Cells;
              OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
              if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
              try


                  //绘制固定列分隔线
                  //wn
        //          for I := 0 to FRealFixColCount-1 do
                  for I := Self.FDrawFixedColumnStartIndex to FDrawFixedColumnEndIndex do
                  begin

                        AColumnDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);


                        ALineRect:=AColumnDrawRect;
                        ALineRect.Top:=Self.FFirstDrawItemRect.Top;
                        ALineRect.Bottom:=Self.FLastRowDrawItemRect.Bottom;


                        //存在指示列
                        //如果要画指示列的列尾分隔线
                        //并且当前是固定的第一列
                        //那就不要画表格列的开始分隔线
                        //避免线看起来重复
                        if Not (BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0)
                                and ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FIsDrawColEndLine
                                and (I=0) and (Self.FRealFixColCount>0)
                                ) then
                        begin

                            //绘制表格固定列的开始分隔线
                            if (I=0)
                              and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColBeginLine then
                            begin
                              ACanvas.DrawRectLine(ASkinVirtualGridMaterial.DrawGridCellDevideMaterial.FDrawColLineParam,
                                                ALineRect,lpLeft);
                            end;

                        end;


                        //绘制表格固定列的结束分隔线
                        if (I=FRealFixColCount-1)
                          and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColEndLine then
                        begin
                          ACanvas.DrawRectLine(ASkinVirtualGridMaterial.DrawGridCellDevideMaterial.FDrawColLineParam,
                                            ALineRect,lpRight);
                        end;


                        //绘制表格固定列的分隔线
                        if (I<Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount-1)
                           and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColLine then
                        begin
                          ACanvas.DrawRectLine(ASkinVirtualGridMaterial.DrawGridCellDevideMaterial.FDrawColLineParam,
                                            ALineRect,lpRight);
                        end;

                  end;


              finally
                if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
              end;
          end;





          //绘制活动列分隔线
          AClipRect:=Self.FSkinVirtualGridIntf.Prop.GetClientRect_Cells_UnfixedCols;
          OffsetRect(AClipRect,ADrawRect.Left,ADrawRect.Top);
          if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.SetClip(AClipRect);
          try


              //绘制活动列分隔线
              for I := FDrawColumnStartIndex to FDrawColumnEndIndex do
              begin

                  if I>=FRealFixColCount then
                  begin

                      AColumnDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleColumnDrawRect(I);


                      ALineRect:=AColumnDrawRect;
                      ALineRect.Top:=Self.FFirstDrawItemRect.Top;
                      ALineRect.Bottom:=Self.FLastRowDrawItemRect.Bottom;


                      if FRealFixColCount>0 then
                      begin
                            //存在固定列
                            //如果要画固定列的列尾分隔线
                            //并且当前水平位置是0
                            //那就不要画表格列的开始分隔线
                            //避免线看起来重复
                            if  (
                                    ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColLine
                                    and EqualDouble(Self.FDrawRectLeftOffset,0)
                                    ) then
                            begin
                            end
                            else
                            begin

                                //绘制表格列的开始分隔线
                                if (I=FRealFixColCount)
                                  and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColBeginLine
                                  and (ALineRect.Left>ADrawRect.Left+Self.FSkinVirtualGridIntf.Prop.GetRealFixedColsDrawRight) then
                                begin
                                  ACanvas.DrawRectLine(ASkinVirtualGridMaterial.DrawGridCellDevideMaterial.FDrawColLineParam,
                                                      ALineRect,lpLeft);
                                end;

                            end;
                      end
                      else
                      begin
                          //存在指示列
                          //如果要画指示列的列尾分隔线
                          //并且当前水平位置是0
                          //那就不要画表格列的开始分隔线
                          //避免线看起来重复
                          if (BiggerDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0)
                                  and ASkinVirtualGridMaterial.FDrawIndicatorDevideMaterial.FIsDrawColEndLine
                                  and EqualDouble(Self.FDrawRectLeftOffset,0))
                                  or IsSameDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0) then
                          begin
                          end
                          else
                          begin


                              //绘制表格列的开始分隔线
                              if (I=0)
                                and (
                                      ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColBeginLine
                                    and (ALineRect.Left>ADrawRect.Left+Self.FSkinVirtualGridIntf.Prop.GetRealFixedColsDrawRight)
                                    or IsSameDouble(Self.FSkinVirtualGridIntf.Prop.FIndicatorWidth,0)
                                    ) then
                              begin
                                ACanvas.DrawRectLine(ASkinVirtualGridMaterial.DrawGridCellDevideMaterial.FDrawColLineParam,
                                                  ALineRect,lpLeft);
                              end;

                          end;


                      end;




                      //绘制表格列的结束分隔线
                      if (I=Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount-1)
                        and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColEndLine
                        and (ALineRect.Right>ADrawRect.Left+Self.FSkinVirtualGridIntf.Prop.GetRealFixedColsDrawRight) then
                      begin
                        ACanvas.DrawRectLine(ASkinVirtualGridMaterial.DrawGridCellDevideMaterial.FDrawColLineParam,
                                          ALineRect,lpRight);
                      end;


                      //绘制表格列的分隔线
                      if (I<Self.FSkinVirtualGridIntf.Prop.FColumnLayoutsManager.GetVisibleItemsCount-1)
                         and ASkinVirtualGridMaterial.FDrawGridCellDevideMaterial.FIsDrawColLine
                          and (ALineRect.Right>ADrawRect.Left+Self.FSkinVirtualGridIntf.Prop.GetRealFixedColsDrawRight) then
                      begin
                        ACanvas.DrawRectLine(ASkinVirtualGridMaterial.DrawGridCellDevideMaterial.FDrawColLineParam,
                                          ALineRect,lpRight);
                      end;

                  end;

              end;


          finally
            if Self.FSkinVirtualGridIntf.Properties.FIsNeedClip then ACanvas.ResetClip;
          end;

  end;




//  if
//      //设置了列头的高度
//      BiggerDouble(Self.FSkinVirtualGridIntf.Prop.ColumnsHeaderHeight,0) then
//  begin
//
//      //绘制列头
//      AHeaderDrawRect:=Self.FSkinVirtualGridIntf.Prop.GetContentRect_Header;
//      //列头不能上下滑动的,所以不需要加上上下偏移
//      //加上水平滚动偏移
//      AHeaderDrawRect.Left:=AHeaderDrawRect.Left-FDrawRectLeftOffset;
//      AHeaderDrawRect.Right:=AHeaderDrawRect.Right-FDrawRectRightOffset;
//
//      CustomPaintColumnsHeader(ACanvas,
//                                ASkinMaterial,
//                                ADrawRect,
//                                APaintData,
//
//                                AHeaderDrawRect,
//
////                                FDrawColumnStartIndex,
////                                FDrawColumnEndIndex,
//
//                                GetSkinMaterial);
//
//  end;

  

end;

function TSkinVirtualGridDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinVirtualGrid,Self.FSkinVirtualGridIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinVirtualGrid Interface');
    end;
  end;
end;

procedure TSkinVirtualGridDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinVirtualGridIntf:=nil;
end;

function TSkinVirtualGridDefaultType.DoProcessItemCustomMouseDown(
  AMouseOverItem: TBaseSkinItem; AItemDrawRect: TRectF; Button: TMouseButton;
  Shift: TShiftState; X, Y: Double): Boolean;
var
  ACellDrawRect:TRectF;
  AMoveOverCol:TSkinVirtualGridColumn;
  AMouseOverItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
begin
  Result:=inherited;

  
  AMoveOverCol:=nil;
  AMouseOverItemDrawItemDesignerPanel:=nil;
  if (AMouseOverItem<>nil) then
  begin
    AMoveOverCol:=Self.FSkinVirtualGridIntf.Prop.ColumnAt(X);
    if AMoveOverCol<>nil then
    begin
      ACellDrawRect:=Self.FSkinVirtualGridIntf.Prop.GetCellDrawRect(AMoveOverCol,AMouseOverItem);
      AMouseOverItemDrawItemDesignerPanel:=AMoveOverCol.FDefaultItemStyleSetting.GetInnerItemDesignerPanel(AMouseOverItem);
    end;
  end;


  //ItemDesignerPanel处理鼠标按下事件
  if    //PtInRect(ACellDrawRect,PointF(X,Y))
    //and 
        (AMouseOverItem<>nil)
    and (AMoveOverCol<>nil)
    and (AMouseOverItemDrawItemDesignerPanel<>nil)
    then
  begin



          //TSkinItemDesignerPanel(ASkinMouseOverItem.FDrawItemDesignerPanel);
        //初始事件没有被处理
        AMouseOverItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;


        //设置设计面板的高度和宽度(以便排列好控件,进行消息响应)
        AMouseOverItemDrawItemDesignerPanel.Height:=ControlSize(RectHeightF(ACellDrawRect));
        AMouseOverItemDrawItemDesignerPanel.Width:=ControlSize(RectWidthF(ACellDrawRect));

        
//        //再调用OnPrepareDrawItem事件
//        //准备绘制列表项
//        if Self.FSkinVirtualGridIntf.Prop.IsItemMouseEventNeedCallPrepareDrawItem then
//        begin
//          //手动绑定值,以及设置设计面板上面的控件位置等
//          Self.FSkinVirtualGridIntf.Prop.CallOnPrepareDrawItemEvent(
//                          Self,
//                          nil,
//                          AMouseOverItem,
//                          AItemDrawRect,
//                          False
//                          );
//        end;


        //判断之前鼠标按下的Item时有没有控件弹起来


        //处理鼠标按下消息
        AMouseOverItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseDown(Self.FSkinControl,Button,Shift,X-ACellDrawRect.Left,Y-ACellDrawRect.Top);

        if AMouseOverItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
        begin
          //点击到HitTest为True的子控件
          Result:=True;
          Exit;
        end
        else
        begin
          //如果事件没有被处理,那么传递给Item,也就是点击列表项
        end;


  end;

end;

procedure TSkinVirtualGridDefaultType.DoProcessItemCustomMouseLeave(
  AMouseLeaveItem: TBaseSkinItem);
//var
//  ASkinMouseLeaveItem:TBaseSkinItem;
begin
  Inherited;

//  ASkinMouseLeaveItem:=TBaseSkinItem(AMouseLeaveItem);
//
//  if (ASkinMouseLeaveItem<>nil)
//    and (ASkinMouseLeaveItem.FDrawItemDesignerPanel<>nil)
//    and (TSkinItemDesignerPanel(ASkinMouseLeaveItem.FDrawItemDesignerPanel).SkinControlType<>nil) then
//  begin
//    TSkinItemDesignerPanel(ASkinMouseLeaveItem.FDrawItemDesignerPanel).SkinControlType.DirectUIMouseLeave;
//  end;
end;

function TSkinVirtualGridDefaultType.DoProcessItemCustomMouseMove(
  AMouseOverItem: TBaseSkinItem; Shift: TShiftState; X, Y: Double): Boolean;
var
  ACellDrawRect:TRectF;
  AMoveOverCol:TSkinVirtualGridColumn;
  AMouseOverItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
begin
  Result:=inherited;

  AMoveOverCol:=nil;
  AMouseOverItemDrawItemDesignerPanel:=nil;
  if (AMouseOverItem<>nil) then
  begin
    AMoveOverCol:=Self.FSkinVirtualGridIntf.Prop.ColumnAt(X);
    if AMoveOverCol<>nil then
    begin
      ACellDrawRect:=Self.FSkinVirtualGridIntf.Prop.GetCellDrawRect(AMoveOverCol,AMouseOverItem);
      AMouseOverItemDrawItemDesignerPanel:=AMoveOverCol.FDefaultItemStyleSetting.GetInnerItemDesignerPanel(AMouseOverItem);
    end;
  end;



  //现ItemDesignerPanel处理鼠标移动效果
  if    (AMouseOverItem<>nil)
    and (AMoveOverCol<>nil)
    and (AMouseOverItemDrawItemDesignerPanel<>nil)
    then
  begin

//      AItemDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleItemDrawRect(ASkinMouseOverItem);
//      //如果当前列表项正在平拖,那么获取平拖后的绘制矩形
//      if (ASkinMouseOverItem=Self.FSkinVirtualGridIntf.Prop.FPanDragItem) then
//      begin
//        AItemDrawRect:=Self.FSkinVirtualGridIntf.Prop.GetPanDragItemDrawRect;
//      end;
//      AMouseOverItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(ASkinMouseOverItem.FDrawItemDesignerPanel);


      AMouseOverItemDrawItemDesignerPanel.Height:=ControlSize(RectHeightF(ACellDrawRect));
      AMouseOverItemDrawItemDesignerPanel.Width:=ControlSize(RectWidthF(ACellDrawRect));



//      //再调用OnPrepareDrawItem事件
//      //准备绘制列表项
//      if Self.FSkinVirtualGridIntf.Prop.IsItemMouseEventNeedCallPrepareDrawItem then
//      begin
//        //手动绑定值,以及设置设计面板上面的控件位置等
//        Self.FSkinVirtualGridIntf.Prop.CallOnPrepareDrawItemEvent(
//                        Self,
//                        nil,
//                        AMouseOverItem,
//                        AItemDrawRect,
//                        False
//                        );
//      end;



      AMouseOverItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseMove(Self.FSkinControl,Shift,
        X-ACellDrawRect.Left,
        Y-ACellDrawRect.Top);

  end;
end;

function TSkinVirtualGridDefaultType.DoProcessItemCustomMouseUp(
  AMouseDownItem: TBaseSkinItem; Button: TMouseButton; Shift: TShiftState; X,
  Y: Double): Boolean;
var
  ACellDrawRect:TRectF;
  AMoveOverCol:TSkinVirtualGridColumn;
  AMouseOverItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
begin
  Result:=inherited;

  AMoveOverCol:=nil;
  AMouseOverItemDrawItemDesignerPanel:=nil;
  if (AMouseDownItem<>nil) then
  begin
    AMoveOverCol:=Self.FSkinVirtualGridIntf.Prop.ColumnAt(X);
    if AMoveOverCol<>nil then
    begin
      ACellDrawRect:=Self.FSkinVirtualGridIntf.Prop.GetCellDrawRect(AMoveOverCol,AMouseDownItem);
      AMouseOverItemDrawItemDesignerPanel:=AMoveOverCol.FDefaultItemStyleSetting.GetInnerItemDesignerPanel(AMouseDownItem);
    end;
  end;



  //ItemDesignerPanel处理鼠标弹起效果
  if    (AMouseDownItem<>nil)
    and (AMoveOverCol<>nil)
    and (AMouseOverItemDrawItemDesignerPanel<>nil)
    then
  begin
//      AItemDrawRect:=Self.FSkinVirtualGridIntf.Prop.VisibleItemDrawRect(ASkinMouseDownItem);
//
//      //获取平拖后的绘制矩形
//      if (ASkinMouseDownItem=Self.FSkinVirtualGridIntf.Prop.FPanDragItem) then
//      begin
//        AItemDrawRect:=Self.FSkinVirtualGridIntf.Prop.GetPanDragItemDrawRect;
//      end;
//
//      AMouseOverItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(ASkinMouseDownItem.FDrawItemDesignerPanel);


      AMouseOverItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;

      AMouseOverItemDrawItemDesignerPanel.Height:=ControlSize(RectHeightF(ACellDrawRect));
      AMouseOverItemDrawItemDesignerPanel.Width:=ControlSize(RectWidthF(ACellDrawRect));

      
      //再调用OnPrepareDrawItem事件
      //准备绘制列表项
//      if Self.FSkinCustomListIntf.Prop.IsItemMouseEventNeedCallPrepareDrawItem then
      begin
        //手动绑定值
        Self.FSkinCustomListIntf.Prop.CallOnPrepareDrawItemEvent(
                        Self,
                        nil,
                        AMouseDownItem,
                        ACellDrawRect,
                        False
                        );
      end;


      AMouseOverItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseUp(Self.FSkinControl,Button,Shift,X-ACellDrawRect.Left,Y-ACellDrawRect.Top,
              //移动距离小于5才能调用点击事件
              (Abs(FMouseDownAbsolutePt.X-Self.FMouseUpAbsolutePt.X)<Const_CanCallClickEventDistance)
                and (Abs(FMouseDownAbsolutePt.Y-FMouseUpAbsolutePt.Y)<Const_CanCallClickEventDistance)
                );





      if AMouseOverItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
      begin
          //点击到HitTest为True的子控件

          if AMouseOverItemDrawItemDesignerPanel.SkinControlType.EventClickedByChild then
          begin
              //是OnClick

              //可以点击
              //用于一个设计面板共享给多个ListBox使用的时候,
              //可以在ListBox中的此事件分别处理对应的操作
              if Assigned(Self.FSkinCustomListIntf.OnClickItemDesignerPanelChild) then
              begin
                Self.FSkinCustomListIntf.OnClickItemDesignerPanelChild(
                    Self.FSkinControl,
                    AMouseDownItem,
                    TItemDesignerPanel(AMouseOverItemDrawItemDesignerPanel),
                    AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl
                    );
              end;



//              {$IFDEF FMX}
//              //如果是Edit,那么启动自动编辑
//              if (AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl is TSkinEdit)
//                and TSkinEdit(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl).IsAutoEditInItem then
//              begin
//                Self.FSkinVirtualGridIntf.Prop.StartEditingItem(
//                              ASkinMouseDownItem,
//                              TControl(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl),
//                              nil,
//                              TSkinFMXEdit(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl).SkinControlType.FMouseUpPt.X,
//                              TSkinFMXEdit(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl).SkinControlType.FMouseUpPt.Y
//                              );
//              end;
//              {$ENDIF FMX}

              {$IFDEF VCL}
              //如果是Edit,那么启动自动编辑
              if (AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl is TSkinEdit)
//                and TSkinEdit(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl).IsAutoEditInItem
                then
              begin
                Self.FSkinVirtualGridIntf.Prop.StartEditingCell(
                              AMouseDownItem,
                              AMoveOverCol,
                              TSkinEdit(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl).SkinControlType.FMouseUpPt.X,
                              TSkinEdit(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl).SkinControlType.FMouseUpPt.Y,
                              TControl(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl)
                              );
              end;
              {$ENDIF VCL}
          end;

          Result:=True;
          Exit;
      end
      else
      begin
        //如果事件没有被处理,那么传递给Item,也就是点击列表项
      end;



  end;

end;

procedure TSkinVirtualGridDefaultType.DrawRowBackColor(
                          ACanvas:TDrawCanvas;
                          AItemIndex: Integer;
                          ARowBackColorDrawRect:TRectF;
                          ARowBackColorMaterial: TSkinRowBackColorMaterial;
                          AIsFixedCol: Boolean;
                          AItemEffectStates:TDPEffectStates);
var
  ABackColor:TDrawRectParam;
  AFixedRowBackColorMaterial: TSkinFixedRowBackColorMaterial;
begin

  //TSkinFixedRowBackColorMaterial
  ABackColor:=ARowBackColorMaterial.BackColor;
  AFixedRowBackColorMaterial:=nil;
  if AIsFixedCol then
  begin
    AFixedRowBackColorMaterial:=TSkinFixedRowBackColorMaterial(ARowBackColorMaterial);
  end;

  if AIsFixedCol and (AFixedRowBackColorMaterial<>nil) and AFixedRowBackColorMaterial.IsDiffFixedCols then
  begin

      //绘制背景色
      if ARowBackColorMaterial.FIsDiffOddAndEven then
      begin
        if AItemIndex mod 2=0 then
        begin
          //奇数,1,3,7,
          ABackColor:=AFixedRowBackColorMaterial.FFixedColsOddBackColor;
        end
        else
        begin
          //偶数,0,2,4,
          ABackColor:=AFixedRowBackColorMaterial.FFixedColsEvenBackColor;
        end;
      end
      else
      begin
          ABackColor:=AFixedRowBackColorMaterial.FFixedColsBackColor;
      end;

  end
  else
  begin

      //绘制背景色
      if ARowBackColorMaterial.FIsDiffOddAndEven then
      begin
        if AItemIndex mod 2=0 then
        begin
          //奇数,1,3,7,
          ABackColor:=ARowBackColorMaterial.FOddBackColor;
        end
        else
        begin
          //偶数,0,2,4,
          ABackColor:=ARowBackColorMaterial.FEvenBackColor;
        end;
      end
      else
      begin
          ABackColor:=ARowBackColorMaterial.BackColor;
      end;
  end;


  ABackColor.StaticEffectStates:=AItemEffectStates;
  ACanvas.DrawRect(ABackColor,ARowBackColorDrawRect);

end;

function TSkinVirtualGridDefaultType.GetSkinMaterial: TSkinVirtualGridDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinVirtualGridDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


procedure TSkinVirtualGridDefaultType.MarkAllListItemTypeStyleSettingCacheUnUsed(
  ADrawStartIndex, ADrawEndIndex: Integer);
var
  I:Integer;
  J:Integer;
  AItem:TBaseSkinItem;
begin

  //先将所有缓存标记为不使用
  for I := 0 to Self.FSkinVirtualGridIntf.Prop.Columns.Count-1 do
  begin
    Self.FSkinVirtualGridIntf.Prop.Columns[I].FDefaultItemStyleSetting.MarkAllCacheNoUsed;
  end;
//  Self.FSkinVirtualGridIntf.Prop.FDefaultItemStyleSetting.MarkAllCacheNoUsed;
//  Self.FSkinVirtualGridIntf.Prop.FItem1ItemStyleSetting.MarkAllCacheNoUsed;
//  Self.FSkinVirtualGridIntf.Prop.FItem2ItemStyleSetting.MarkAllCacheNoUsed;
//  Self.FSkinVirtualGridIntf.Prop.FItem3ItemStyleSetting.MarkAllCacheNoUsed;
//  Self.FSkinVirtualGridIntf.Prop.FItem4ItemStyleSetting.MarkAllCacheNoUsed;
//  Self.FSkinVirtualGridIntf.Prop.FHeaderItemStyleSetting.MarkAllCacheNoUsed;
//  Self.FSkinVirtualGridIntf.Prop.FFooterItemStyleSetting.MarkAllCacheNoUsed;
//  Self.FSkinVirtualGridIntf.Prop.FSearchBarItemStyleSetting.MarkAllCacheNoUsed;




  //再将使用的缓存标记为已使用
  for I:=ADrawStartIndex to ADrawEndIndex do
  begin
    //将不再绘制的Item的缓存设置为不使用
    AItem:=TBaseSkinItem(Self.FSkinCustomListIntf.Prop.ListLayoutsManager.GetVisibleItems(I));


    for J := 0 to Self.FSkinVirtualGridIntf.Prop.Columns.Count-1 do
    begin
      Self.FSkinVirtualGridIntf.Prop.Columns[J].FDefaultItemStyleSetting.MarkCacheUsed(AItem);
    end;


//    case AItem.ItemType of
//      sitDefault: Self.FSkinVirtualGridIntf.Prop.FDefaultItemStyleSetting.MarkCacheUsed(AItem);
//      sitHeader: Self.FSkinVirtualGridIntf.Prop.FHeaderItemStyleSetting.MarkCacheUsed(AItem);
//      sitFooter: Self.FSkinVirtualGridIntf.Prop.FFooterItemStyleSetting.MarkCacheUsed(AItem);
//      sitSpace: ;
//      sitItem1: Self.FSkinVirtualGridIntf.Prop.FItem1ItemStyleSetting.MarkCacheUsed(AItem);
//      sitItem2: Self.FSkinVirtualGridIntf.Prop.FItem2ItemStyleSetting.MarkCacheUsed(AItem);
//      sitItem3: Self.FSkinVirtualGridIntf.Prop.FItem3ItemStyleSetting.MarkCacheUsed(AItem);
//      sitSearchBar: Self.FSkinVirtualGridIntf.Prop.FSearchBarItemStyleSetting.MarkCacheUsed(AItem);
//      sitUseMaterialDraw: ;
//      sitItem4: Self.FSkinVirtualGridIntf.Prop.FItem4ItemStyleSetting.MarkCacheUsed(AItem);
//      sitUseDrawItemDesignerPanel: ;
//    end;

  end;
end;

function TSkinVirtualGridDefaultType.ProcessItemDrawEffectStates(AItem: TBaseSkinItem): TDPEffectStates;
begin
  Result:=Inherited;

  if AItem.Selected and not Self.FSkinVirtualGridIntf.Prop.FIsRowSelect then
  begin
    Result:=Result-[dpstPushed];
  end;

end;

procedure TSkinVirtualGridDefaultType.SizeChanged;
var
  I: Integer;
  AHasPercentColumn:Boolean;
begin
  inherited;

  AHasPercentColumn:=False;

  for I := 0 to Self.FSkinVirtualGridIntf.Properties.Columns.Count-1 do
  begin
    if Self.FSkinVirtualGridIntf.Properties.Columns[I].Visible and (Self.FSkinVirtualGridIntf.Properties.Columns[I].Width<1) then
    begin
      AHasPercentColumn:=True;
    end;
  end;
  //如果表格列是按比例的,那么每次拖动尺寸,都要重新计算
  if AHasPercentColumn then Self.FSkinVirtualGridIntf.Properties.Columns.GetListLayoutsManager.DoItemSizeChange(nil);

end;

{ TSkinVirtualGridDefaultMaterial }


procedure TSkinVirtualGridDefaultMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinVirtualGridDefaultMaterial;
begin
  if Dest is TSkinVirtualGridDefaultMaterial then
  begin

    DestObject:=TSkinVirtualGridDefaultMaterial(Dest);


    DestObject.FDrawColumnMaterial.Assign(FDrawColumnMaterial);

    DestObject.FDrawColumnDevideMaterial.Assign(FDrawColumnDevideMaterial);
    DestObject.FDrawGridCellDevideMaterial.Assign(FDrawGridCellDevideMaterial);
    DestObject.FDrawIndicatorDevideMaterial.Assign(FDrawIndicatorDevideMaterial);

    DestObject.FRowBackColorMaterial.Assign(FRowBackColorMaterial);
    DestObject.FFooterRowBackColorMaterial.Assign(FFooterRowBackColorMaterial);
    DestObject.FDrawIndicatorCellBackColorMaterial.Assign(FDrawIndicatorCellBackColorMaterial);


    DestObject.FDrawCheckBoxColorMaterial.Assign(FDrawCheckBoxColorMaterial);


  end;
  inherited;
end;

constructor TSkinVirtualGridDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawCheckBoxColorMaterial:=TSkinCheckBoxColorMaterial.Create(Self);
  FDrawCheckBoxColorMaterial.SetSubComponent(True);
  FDrawCheckBoxColorMaterial.Name:='DrawCheckBoxColorMaterial';
  FDrawCheckBoxColorMaterial.OnChange:=Self.DoChange;


  //勾选框边框为2
  FDrawCheckBoxColorMaterial.DrawCheckRectParam.BorderWidth:=2;

  //勾选框边框为2
  FDrawCheckBoxColorMaterial.DrawCheckStateParam.DrawEffectSetting.PushedEffect.PenWidth:=2;
  FDrawCheckBoxColorMaterial.DrawCheckStateParam.DrawEffectSetting.PushedEffect.EffectTypes:=[dppetPenWidthChange];




  FDrawColumnMaterial:=GetColumnMaterialClass.Create(Self);
  FDrawColumnMaterial.SetSubComponent(True);
  FDrawColumnMaterial.Name:='DrawColumnMaterial';
  FDrawColumnMaterial.OnChange:=Self.DoChange;




  FRowBackColorMaterial:=TSkinFixedRowBackColorMaterial.Create(Self);
  FRowBackColorMaterial.SetSubComponent(True);
  FRowBackColorMaterial.Name:='RowBackColorMaterial';
  FRowBackColorMaterial.OnChange:=Self.DoChange;




  FFooterRowBackColorMaterial:=TSkinFixedRowBackColorMaterial.Create(Self);
  FFooterRowBackColorMaterial.SetSubComponent(True);
  FFooterRowBackColorMaterial.Name:='FooterRowBackColorMaterial';
  FFooterRowBackColorMaterial.OnChange:=Self.DoChange;




  FDrawIndicatorCellBackColorMaterial:=TSkinRowBackColorMaterial.Create(Self);
  FDrawIndicatorCellBackColorMaterial.SetSubComponent(True);
  FDrawIndicatorCellBackColorMaterial.Name:='DrawIndicatorCellBackColorMaterial';
  FDrawIndicatorCellBackColorMaterial.OnChange:=Self.DoChange;




  FDrawIndicatorFooterCellBackColorMaterial:=TSkinRowBackColorMaterial.Create(Self);
  FDrawIndicatorFooterCellBackColorMaterial.SetSubComponent(True);
  FDrawIndicatorFooterCellBackColorMaterial.Name:='DrawIndicatorFooterCellBackColorMaterial';
  FDrawIndicatorFooterCellBackColorMaterial.OnChange:=Self.DoChange;





  FDrawColumnDevideMaterial:=TSkinCellDevideMaterial.Create(Self);
  FDrawColumnDevideMaterial.SetSubComponent(True);
  FDrawColumnDevideMaterial.Name:='DrawColumnDevideMaterial';
  FDrawColumnDevideMaterial.OnChange:=Self.DoChange;





  FDrawGridCellDevideMaterial:=TSkinCellDevideMaterial.Create(Self);
  FDrawGridCellDevideMaterial.SetSubComponent(True);
  FDrawGridCellDevideMaterial.Name:='DrawGridCellDevideMaterial';
  FDrawGridCellDevideMaterial.OnChange:=Self.DoChange;




  FDrawIndicatorDevideMaterial:=TSkinCellDevideMaterial.Create(Self);
  FDrawIndicatorDevideMaterial.SetSubComponent(True);
  FDrawIndicatorDevideMaterial.Name:='DrawIndicatorDevideMaterial';
  FDrawIndicatorDevideMaterial.OnChange:=Self.DoChange;




  FDrawIndicatorNumberParam:=CreateDrawTextParam('DrawIndicatorNumberParam','指示列序号绘制参数');
  FDrawIndicatorNumberParam.IsControlParam:=False;


  FDrawIndicatorHeaderBackColor:=CreateDrawRectParam('IndicatorHeaderBackColor','指示列头部背景绘制参数');
  FDrawIndicatorHeaderBackColor.IsControlParam:=False;


  FDrawSelectedCellBackColorParam:=CreateDrawRectParam('DrawSelectedCellBackColorParam','选中单元格背景绘制参数');
  FDrawSelectedCellBackColorParam.IsControlParam:=False;

  FColumnHeaderBackColor:=CreateDrawRectParam('ColumnHeaderBackColor','列头背景绘制参数');
  FColumnHeaderBackColor.IsControlParam:=False;

  FFixedColumnHeaderBackColor:=CreateDrawRectParam('FixedColumnHeaderBackColor','固定列头背景绘制参数');
  FFixedColumnHeaderBackColor.IsControlParam:=False;


  FIsDrawIndicatorNumber:=True;




//  //初始绘制参数//
//  AColumnBackColor:=$FF799CB0;//MediumseagreenColor;//
//
//  ABorderColor:=BlackColor;
//
//  AFixedColsOddRowBackColor:=$FFF5F5F5;
//  AFixedColsEvenRowBackColor:=$FFE0E0E0;
//
//  AOddRowBackColor:=WhiteColor;
//  AEvenRowBackColor:=$FFEDEDED;
//
//  ASelectedRowBackColor:=$FFA0A0A0;

  {$IFDEF FMX}
  Init(False,
        $FF799CB0,
        $FF8AADC8,
        BlackColor,
        $FFF5F5F5,
        $FFE0E0E0,
        WhiteColor,
        $FFEDEDED,
        $FFA0A0A0,
        False);
  {$ENDIF FMX}

//  {$IFDEF VCL}
//  Init(False,
//        $B09C79,
//        $C8AD8A,
//        BlackColor,
//        $F5F5F5,
//        $E0E0E0,
//        WhiteColor,
//        $EDEDED,
//        $A0A0A0,
//        False);
//  {$ENDIF VCL}

end;

function TSkinVirtualGridDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];
    if ABTNode.NodeName='DrawColumnMaterial' then
    begin
      FDrawColumnMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    else if ABTNode.NodeName='IsDrawIndicatorNumber' then
    begin
      FIsDrawIndicatorNumber:=ABTNode.ConvertNode_Bool32.Data;
    end

    else if ABTNode.NodeName='DrawColumnDevideMaterial' then
    begin
      FDrawColumnDevideMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='DrawGridCellDevideMaterial' then
    begin
      FDrawGridCellDevideMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='DrawIndicatorDevideMaterial' then
    begin
      FDrawIndicatorDevideMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    else if ABTNode.NodeName='DrawCheckBoxColorMaterial' then
    begin
      FDrawCheckBoxColorMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='RowBackColorMaterial' then
    begin
      FRowBackColorMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='FooterRowBackColorMaterial' then
    begin
      FFooterRowBackColorMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='DrawIndicatorCellBackColorMaterial' then
    begin
      FDrawIndicatorCellBackColorMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    ;
  end;

  Result:=True;
end;

function TSkinVirtualGridDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Class('DrawColumnMaterial','表格列绘制参数');
  Self.FDrawColumnMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);


  ABTNode:=ADocNode.AddChildNode_Class('DrawColumnDevideMaterial','列头分隔线绘制参数');
  Self.FDrawColumnDevideMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('DrawGridCellDevideMaterial','单元格分隔线绘制参数');
  Self.FDrawGridCellDevideMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('DrawIndicatorDevideMaterial','指示列分隔线绘制参数');
  Self.FDrawIndicatorDevideMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);


  ABTNode:=ADocNode.AddChildNode_Class('DrawCheckBoxColorMaterial','布尔型字段复选框绘制参数');
  Self.FDrawCheckBoxColorMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('RowBackColorMaterial','表格数据行背景色');
  Self.FRowBackColorMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('FooterRowBackColorMaterial','统计行背景色');
  Self.FFooterRowBackColorMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('DrawIndicatorCellBackColorMaterial','指示列单元格的背景色');
  Self.FDrawIndicatorCellBackColorMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawIndicatorNumber','是否绘制指示列序号');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawIndicatorNumber;


  Result:=True;
end;

destructor TSkinVirtualGridDefaultMaterial.Destroy;
begin

  FreeAndNil(FDrawCheckBoxColorMaterial);

  FreeAndNil(FDrawSelectedCellBackColorParam);

  FreeAndNil(FDrawIndicatorNumberParam);

  FreeAndNil(FColumnHeaderBackColor);
  FreeAndNil(FFixedColumnHeaderBackColor);

  FreeAndNil(FDrawIndicatorHeaderBackColor);
  FreeAndNil(FDrawIndicatorFooterCellBackColorMaterial);

  FreeAndNil(FDrawColumnMaterial);


  FreeAndNil(FRowBackColorMaterial);
  FreeAndNil(FFooterRowBackColorMaterial);
  FreeAndNil(FDrawIndicatorCellBackColorMaterial);


  FreeAndNil(FDrawColumnDevideMaterial);
  FreeAndNil(FDrawGridCellDevideMaterial);
  FreeAndNil(FDrawIndicatorDevideMaterial);

  inherited;
end;

function TSkinVirtualGridDefaultMaterial.GetColumnHeaderColor: TDelphiColor;
begin
  Result:=Self.FColumnHeaderBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetColumnMaterialClass: TSkinVirtualGridColumnMaterialClass;
begin
  Result:=TSkinVirtualGridColumnMaterial;
end;

function TSkinVirtualGridDefaultMaterial.GetEvenRowBackColor: TDelphiColor;
begin
  Result:=Self.FRowBackColorMaterial.FEvenBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetFixedColsEvenRowBackColor: TDelphiColor;
begin
  Result:=Self.FRowBackColorMaterial.FFixedColsEvenBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetFixedColsOddRowBackColor: TDelphiColor;
begin
  Result:=Self.FRowBackColorMaterial.FFixedColsOddBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetFixedColsRowBackColor: TDelphiColor;
begin
  Result:=Self.FRowBackColorMaterial.FFixedColsBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetFixedColumnHeaderColor: TDelphiColor;
begin
  Result:=Self.FFixedColumnHeaderBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetIndicatorHeaderBackColor: TDelphiColor;
begin
  Result:=Self.FDrawIndicatorHeaderBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetIsDiffFixedColsRowBackColor: Boolean;
begin
  Result:=Self.FRowBackColorMaterial.IsDiffFixedCols;
end;

function TSkinVirtualGridDefaultMaterial.GetIsDiffOddAndEvenRowBackColor: Boolean;
begin
  Result:=Self.FRowBackColorMaterial.FIsDiffOddAndEven;
end;

function TSkinVirtualGridDefaultMaterial.GetOddRowBackColor: TDelphiColor;
begin
  Result:=Self.FRowBackColorMaterial.FOddBackColor.FillColor.FColor;

end;

function TSkinVirtualGridDefaultMaterial.GetRowBackColor: TDelphiColor;
begin
  Result:=Self.FRowBackColorMaterial.FBackColor.FillColor.FColor;
end;

function TSkinVirtualGridDefaultMaterial.GetSelectedEvenRowBackColor: TDelphiColor;
begin
  Result:=TDrawRectParamEffect(FRowBackColorMaterial.EvenBackColor.DrawEffectSetting.PushedEffect).FillColor.Color;
end;

function TSkinVirtualGridDefaultMaterial.GetSelectedOddRowBackColor: TDelphiColor;
begin
  Result:=TDrawRectParamEffect(FRowBackColorMaterial.OddBackColor.DrawEffectSetting.PushedEffect).FillColor.Color;
end;

function TSkinVirtualGridDefaultMaterial.GetSelectedRowBackColor: TDelphiColor;
begin
  Result:=TDrawRectParamEffect(FRowBackColorMaterial.BackColor.DrawEffectSetting.PushedEffect).FillColor.Color;
end;

procedure TSkinVirtualGridDefaultMaterial.Init(
                          AIsTest: Boolean;
                          AColumnBackColor:TDelphiColor;
                          AIndicatorBackColor:TDelphiColor;
                          ABorderColor:TDelphiColor;
                          AFixedColsOddRowBackColor:TDelphiColor;
                          AFixedColsEvenRowBackColor:TDelphiColor;
                          AOddRowBackColor:TDelphiColor;
                          AEvenRowBackColor:TDelphiColor;
                          ASelectedRowBackColor:TDelphiColor;
                          AIsDrawBorder:Boolean);
var
  AColorAlpha:Byte;
begin

//  FFixedColumnHeaderBackColor.IsFill:=True;
//  FFixedColumnHeaderBackColor.FillDrawColor.Color:=$FF799CB0;
//
//  FColumnHeaderBackColor.IsFill:=True;
//  FColumnHeaderBackColor.FillDrawColor.Color:=$FF8B9BAF;


  if AIsTest then
    AColorAlpha:=150
  else
    AColorAlpha:=255;
  




  //指示列头的背景颜色,也就是左上角
  Self.FDrawIndicatorHeaderBackColor.IsFill:=True;
  if AIsTest then
    Self.FDrawIndicatorHeaderBackColor.FillDrawColor.Color:=GoldColor
  else
    Self.FDrawIndicatorHeaderBackColor.FillDrawColor.Color:=AIndicatorBackColor;
  Self.FDrawIndicatorHeaderBackColor.FillDrawColor.Alpha:=AColorAlpha;




  //列头背景-活动列
  Self.FColumnHeaderBackColor.IsFill:=True;
  if AIsTest then
    Self.FColumnHeaderBackColor.FillDrawColor.Color:=GreenColor
  else
    Self.FColumnHeaderBackColor.FillDrawColor.Color:=AColumnBackColor;
  Self.FColumnHeaderBackColor.FillDrawColor.Alpha:=AColorAlpha;




  //列头背景-固定列
  Self.FFixedColumnHeaderBackColor.IsFill:=True;
  if AIsTest then
    Self.FFixedColumnHeaderBackColor.FillDrawColor.Color:=RedColor
  else
    Self.FFixedColumnHeaderBackColor.FillDrawColor.Color:=AColumnBackColor;
  Self.FFixedColumnHeaderBackColor.FillDrawColor.Alpha:=AColorAlpha;






  //指示列的单元格,区分奇偶行
  Self.FDrawIndicatorCellBackColorMaterial.IsDiffOddAndEven:=True;
  //奇
  Self.FDrawIndicatorCellBackColorMaterial.OddBackColor.IsFill:=True;
  if AIsTest then
    Self.FDrawIndicatorCellBackColorMaterial.OddBackColor.FillDrawColor.Color:=MediumseagreenColor
  else
    Self.FDrawIndicatorCellBackColorMaterial.OddBackColor.FillDrawColor.Color:=AIndicatorBackColor;
  Self.FDrawIndicatorCellBackColorMaterial.OddBackColor.FillDrawColor.Alpha:=AColorAlpha;
  //偶
  Self.FDrawIndicatorCellBackColorMaterial.EvenBackColor.IsFill:=True;
  if AIsTest then
    Self.FDrawIndicatorCellBackColorMaterial.EvenBackColor.FillDrawColor.Color:=MoneyGreenColor
  else
    Self.FDrawIndicatorCellBackColorMaterial.EvenBackColor.FillDrawColor.Color:=AIndicatorBackColor;
  Self.FDrawIndicatorCellBackColorMaterial.EvenBackColor.FillDrawColor.Alpha:=AColorAlpha;




  //指示列尾的单元格背景颜色,也就是左下角
  Self.FDrawIndicatorFooterCellBackColorMaterial.IsDiffOddAndEven:=True;
  //奇
  Self.FDrawIndicatorFooterCellBackColorMaterial.OddBackColor.IsFill:=True;
  if AIsTest then
    Self.FDrawIndicatorFooterCellBackColorMaterial.OddBackColor.FillDrawColor.Color:=LemonchiffonColor
  else
    Self.FDrawIndicatorFooterCellBackColorMaterial.OddBackColor.FillDrawColor.Color:=AColumnBackColor;
  Self.FDrawIndicatorFooterCellBackColorMaterial.OddBackColor.FillDrawColor.Alpha:=AColorAlpha;
  //偶
  Self.FDrawIndicatorFooterCellBackColorMaterial.EvenBackColor.IsFill:=True;
  if AIsTest then
    Self.FDrawIndicatorFooterCellBackColorMaterial.EvenBackColor.FillDrawColor.Color:=GoldColor
  else
    Self.FDrawIndicatorFooterCellBackColorMaterial.EvenBackColor.FillDrawColor.Color:=AColumnBackColor;
  Self.FDrawIndicatorFooterCellBackColorMaterial.EvenBackColor.FillDrawColor.Alpha:=AColorAlpha;





//  FRowBackColorMaterial.IsDiffOddAndEven:=True;
//
//  FRowBackColorMaterial.OddBackColor.IsFill:=True;
//  FRowBackColorMaterial.OddBackColor.FillColor.Color:=TAlphaColorRec.White;
//  FRowBackColorMaterial.EvenBackColor.IsFill:=True;
//  FRowBackColorMaterial.EvenBackColor.FillColor.Color:=$FFEDEDED;
//
//  //加深
//  FRowBackColorMaterial.FixedColsOddBackColor.IsFill:=True;
//  FRowBackColorMaterial.FixedColsOddBackColor.FillColor.Color:=$FFF5F5F5;
//  FRowBackColorMaterial.FixedColsEvenBackColor.IsFill:=True;
//  FRowBackColorMaterial.FixedColsEvenBackColor.FillColor.Color:=$FFE0E0E0;
//
//  //选中的效果
//  TDrawRectParamEffect(FRowBackColorMaterial.EvenBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
//  TDrawRectParamEffect(FRowBackColorMaterial.EvenBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=$FFA0A0A0;
//  TDrawRectParamEffect(FRowBackColorMaterial.OddBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
//  TDrawRectParamEffect(FRowBackColorMaterial.OddBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=$FFA0A0A0;
//  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsEvenBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
//  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsEvenBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=$FFA0A0A0;
//  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsOddBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
//  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsOddBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=$FFA0A0A0;





  //行背景色,活动列的,区分奇偶行
  Self.FRowBackColorMaterial.IsDiffOddAndEven:=True;

  Self.FRowBackColorMaterial.OddBackColor.IsFill:=True;
  if AIsTest then
    Self.FRowBackColorMaterial.OddBackColor.FillDrawColor.Color:=OrangeColor
  else
    Self.FRowBackColorMaterial.OddBackColor.FillDrawColor.Color:=AOddRowBackColor;
  Self.FRowBackColorMaterial.OddBackColor.FillDrawColor.Alpha:=AColorAlpha;

  Self.FRowBackColorMaterial.EvenBackColor.IsFill:=True;
  if AIsTest then
    Self.FRowBackColorMaterial.EvenBackColor.FillDrawColor.Color:=GrayColor
  else
    Self.FRowBackColorMaterial.EvenBackColor.FillDrawColor.Color:=AEvenRowBackColor;
  Self.FRowBackColorMaterial.EvenBackColor.FillDrawColor.Alpha:=AColorAlpha;




  //行背景色,固定列的,加深
  Self.FRowBackColorMaterial.FixedColsOddBackColor.IsFill:=True;
  if AIsTest then
    Self.FRowBackColorMaterial.FixedColsOddBackColor.FillDrawColor.Color:=ChocolateColor
  else
    Self.FRowBackColorMaterial.FixedColsOddBackColor.FillDrawColor.Color:=AFixedColsOddRowBackColor;
  Self.FRowBackColorMaterial.FixedColsOddBackColor.FillDrawColor.Alpha:=AColorAlpha;

  Self.FRowBackColorMaterial.FixedColsEvenBackColor.IsFill:=True;
  if AIsTest then
    Self.FRowBackColorMaterial.FixedColsEvenBackColor.FillDrawColor.Color:=BlueColor
  else
    Self.FRowBackColorMaterial.FixedColsEvenBackColor.FillDrawColor.Color:=AFixedColsEvenRowBackColor;
  Self.FRowBackColorMaterial.FixedColsEvenBackColor.FillDrawColor.Alpha:=AColorAlpha;





  //行选中的效果
  TDrawRectParamEffect(FRowBackColorMaterial.BackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
  TDrawRectParamEffect(FRowBackColorMaterial.BackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=ASelectedRowBackColor;

  TDrawRectParamEffect(FRowBackColorMaterial.EvenBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
  TDrawRectParamEffect(FRowBackColorMaterial.EvenBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=ASelectedRowBackColor;

  TDrawRectParamEffect(FRowBackColorMaterial.OddBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
  TDrawRectParamEffect(FRowBackColorMaterial.OddBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=ASelectedRowBackColor;

  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsEvenBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsEvenBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=ASelectedRowBackColor;

  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsOddBackColor.DrawEffectSetting.PushedEffect).EffectTypes:=[drpetFillColorChange];
  TDrawRectParamEffect(FRowBackColorMaterial.FixedColsOddBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=ASelectedRowBackColor;






  FDrawSelectedCellBackColorParam.IsFill:=True;
  FDrawSelectedCellBackColorParam.FillDrawColor.Color:=ASelectedRowBackColor;




  //列的标题绘制参数
  FDrawColumnMaterial.DrawCaptionParam.DrawFont.FontSize:=14;
  FDrawColumnMaterial.DrawCaptionParam.DrawFont.FontColor.Color:=WhiteColor;
  //表格列标题绘制
  Self.FDrawColumnMaterial.DrawCaptionParam.FontVertAlign:=fvaCenter;
  Self.FDrawColumnMaterial.DrawCaptionParam.FontHorzAlign:=fhaCenter;

  //单元格文本绘制
  Self.FDrawColumnMaterial.DrawCellTextParam.FontVertAlign:=fvaCenter;
  Self.FDrawColumnMaterial.DrawCellTextParam.FontHorzAlign:=fhaCenter;
  TDrawTextParamEffect(FDrawColumnMaterial.DrawCellTextParam.DrawEffectSetting.PushedEffect).EffectTypes:=[dtpetFontColorChange];
  TDrawTextParamEffect(FDrawColumnMaterial.DrawCellTextParam.DrawEffectSetting.PushedEffect).FontColor.Color:=WhiteColor;
  TDrawTextParamEffect(FDrawColumnMaterial.DrawCellTextParam.DrawEffectSetting.PushedEffect).FontColor.StoredDefaultColor:=WhiteColor;

  //统计文本绘制
  Self.FDrawColumnMaterial.DrawFooterCellTextParam.FontVertAlign:=fvaCenter;
  Self.FDrawColumnMaterial.DrawFooterCellTextParam.FontHorzAlign:=fhaCenter;

  //提示文字
  Self.FDrawIndicatorNumberParam.FontVertAlign:=fvaCenter;
  Self.FDrawIndicatorNumberParam.FontHorzAlign:=fhaCenter;
  Self.FDrawIndicatorNumberParam.DrawFont.FontColor.Color:=WhiteColor;







  //统计,区分奇偶行
  Self.FFooterRowBackColorMaterial.IsDiffOddAndEven:=True;
  //奇
  Self.FFooterRowBackColorMaterial.OddBackColor.IsFill:=True;
  if AIsTest then
    Self.FFooterRowBackColorMaterial.OddBackColor.FillDrawColor.Color:=MedGrayColor
  else
    Self.FFooterRowBackColorMaterial.OddBackColor.FillDrawColor.Color:=AEvenRowBackColor;
  Self.FFooterRowBackColorMaterial.OddBackColor.FillDrawColor.Alpha:=AColorAlpha;
  //偶
  Self.FFooterRowBackColorMaterial.EvenBackColor.IsFill:=True;
  if AIsTest then
    Self.FFooterRowBackColorMaterial.EvenBackColor.FillDrawColor.Color:=KhakiColor
  else
    Self.FFooterRowBackColorMaterial.EvenBackColor.FillDrawColor.Color:=AEvenRowBackColor;
  Self.FFooterRowBackColorMaterial.EvenBackColor.FillDrawColor.Alpha:=AColorAlpha;

  //固定
  //奇
  Self.FFooterRowBackColorMaterial.FixedColsOddBackColor.IsFill:=True;
  if AIsTest then
    Self.FFooterRowBackColorMaterial.FixedColsOddBackColor.FillDrawColor.Color:=NavyColor
  else
    Self.FFooterRowBackColorMaterial.FixedColsOddBackColor.FillDrawColor.Color:=AEvenRowBackColor;
  Self.FFooterRowBackColorMaterial.FixedColsOddBackColor.FillDrawColor.Alpha:=AColorAlpha;
  //偶
  Self.FFooterRowBackColorMaterial.FixedColsEvenBackColor.IsFill:=True;
  if AIsTest then
    Self.FFooterRowBackColorMaterial.FixedColsEvenBackColor.FillDrawColor.Color:=MaroonColor
  else
    Self.FFooterRowBackColorMaterial.FixedColsEvenBackColor.FillDrawColor.Color:=AEvenRowBackColor;
  Self.FFooterRowBackColorMaterial.FixedColsEvenBackColor.FillDrawColor.Alpha:=AColorAlpha;






  if AIsDrawBorder then
    Self.FDrawIndicatorHeaderBackColor.BorderWidth:=1
  else
    Self.FDrawIndicatorHeaderBackColor.BorderWidth:=0;

  //表格数据行分隔线
  Self.FDrawGridCellDevideMaterial.IsDrawRowBeginLine:=AIsDrawBorder;
  Self.FDrawGridCellDevideMaterial.IsDrawRowEndLine:=AIsDrawBorder;
  Self.FDrawGridCellDevideMaterial.IsDrawColBeginLine:=AIsDrawBorder;
  Self.FDrawGridCellDevideMaterial.IsDrawColEndLine:=AIsDrawBorder;
  Self.FDrawGridCellDevideMaterial.IsDrawRowLine:=AIsDrawBorder;
  Self.FDrawGridCellDevideMaterial.IsDrawColLine:=AIsDrawBorder;
  Self.FDrawGridCellDevideMaterial.DrawRowLineParam.PenWidth:=1;
  Self.FDrawGridCellDevideMaterial.DrawRowLineParam.Color.Color:=ABorderColor;
  Self.FDrawGridCellDevideMaterial.DrawColLineParam.PenWidth:=1;
  Self.FDrawGridCellDevideMaterial.DrawColLineParam.Color.Color:=ABorderColor;


  //表格列分隔线
  Self.FDrawColumnDevideMaterial.IsDrawRowBeginLine:=AIsDrawBorder;
  Self.FDrawColumnDevideMaterial.IsDrawRowEndLine:=AIsDrawBorder;
  Self.FDrawColumnDevideMaterial.IsDrawColBeginLine:=AIsDrawBorder;
  Self.FDrawColumnDevideMaterial.IsDrawColEndLine:=AIsDrawBorder;
  Self.FDrawColumnDevideMaterial.IsDrawRowLine:=AIsDrawBorder;
  Self.FDrawColumnDevideMaterial.IsDrawColLine:=AIsDrawBorder;
  Self.FDrawColumnDevideMaterial.DrawRowLineParam.PenWidth:=1;
  Self.FDrawColumnDevideMaterial.DrawRowLineParam.Color.Color:=ABorderColor;
  Self.FDrawColumnDevideMaterial.DrawColLineParam.PenWidth:=1;
  Self.FDrawColumnDevideMaterial.DrawColLineParam.Color.Color:=ABorderColor;



  //指示列分隔线
  Self.FDrawIndicatorDevideMaterial.IsDrawRowBeginLine:=AIsDrawBorder;
  Self.FDrawIndicatorDevideMaterial.IsDrawRowEndLine:=AIsDrawBorder;
  Self.FDrawIndicatorDevideMaterial.IsDrawColBeginLine:=AIsDrawBorder;
  Self.FDrawIndicatorDevideMaterial.IsDrawColEndLine:=AIsDrawBorder;
  Self.FDrawIndicatorDevideMaterial.IsDrawRowLine:=AIsDrawBorder;
  Self.FDrawIndicatorDevideMaterial.IsDrawColLine:=AIsDrawBorder;
  Self.FDrawIndicatorDevideMaterial.DrawRowLineParam.PenWidth:=1;
  Self.FDrawIndicatorDevideMaterial.DrawRowLineParam.Color.Color:=ABorderColor;
  Self.FDrawIndicatorDevideMaterial.DrawColLineParam.PenWidth:=1;
  Self.FDrawIndicatorDevideMaterial.DrawColLineParam.Color.Color:=ABorderColor;

end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawColumnMaterial(const Value: TSkinVirtualGridColumnMaterial);
begin
  FDrawColumnMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetFooterRowBackColorMaterial(const Value: TSkinFixedRowBackColorMaterial);
begin
  FFooterRowBackColorMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetIndicatorHeaderBackColor(
  const Value: TDelphiColor);
begin
  Self.FDrawIndicatorHeaderBackColor.FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetIsDiffFixedColsRowBackColor(
  const Value: Boolean);
begin
  Self.FRowBackColorMaterial.IsDiffFixedCols:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetIsDiffOddAndEvenRowBackColor(
  const Value: Boolean);
begin
  Self.FRowBackColorMaterial.IsDiffOddAndEven:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetOddRowBackColor(
  const Value: TDelphiColor);
begin
  Self.FRowBackColorMaterial.FOddBackColor.FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawIndicatorHeaderBackColor(const Value: TDrawRectParam);
begin
  FDrawIndicatorHeaderBackColor.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawIndicatorFooterCellBackColorMaterial(const Value: TSkinRowBackColorMaterial);
begin
  FDrawIndicatorFooterCellBackColorMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawIndicatorCellBackColorMaterial(const Value: TSkinRowBackColorMaterial);
begin
  FDrawIndicatorCellBackColorMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetRowBackColor(
  const Value: TDelphiColor);
begin
  Self.FRowBackColorMaterial.FBackColor.FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetRowBackColorMaterial(const Value: TSkinFixedRowBackColorMaterial);
begin
  FRowBackColorMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetSelectedEvenRowBackColor(
  const Value: TDelphiColor);
begin
  TDrawRectParamEffect(FRowBackColorMaterial.EvenBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetSelectedOddRowBackColor(
  const Value: TDelphiColor);
begin
  TDrawRectParamEffect(FRowBackColorMaterial.OddBackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetSelectedRowBackColor(
  const Value: TDelphiColor);
begin
  TDrawRectParamEffect(FRowBackColorMaterial.BackColor.DrawEffectSetting.PushedEffect).FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetColumnHeaderBackColor(const Value: TDrawRectParam);
begin
  FColumnHeaderBackColor.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetColumnHeaderColor(const Value: TDelphiColor);
begin
  Self.FColumnHeaderBackColor.FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetFixedColsEvenRowBackColor(
  const Value: TDelphiColor);
begin

end;

procedure TSkinVirtualGridDefaultMaterial.SetFixedColsOddRowBackColor(
  const Value: TDelphiColor);
begin

end;

procedure TSkinVirtualGridDefaultMaterial.SetFixedColsRowBackColor(
  const Value: TDelphiColor);
begin

end;

procedure TSkinVirtualGridDefaultMaterial.SetFixedColumnHeaderBackColor(const Value: TDrawRectParam);
begin
  FFixedColumnHeaderBackColor.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetFixedColumnHeaderColor(
  const Value: TDelphiColor);
begin
  Self.FFixedColumnHeaderBackColor.FillColor.Color:=Value;
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawCheckBoxColorMaterial(const Value: TSkinCheckBoxColorMaterial);
begin
  FDrawCheckBoxColorMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawColumnDevideMaterial(const Value: TSkinCellDevideMaterial);
begin
  FDrawColumnDevideMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawGridCellDevideMaterial(const Value: TSkinCellDevideMaterial);
begin
  FDrawGridCellDevideMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawIndicatorDevideMaterial(const Value: TSkinCellDevideMaterial);
begin
  FDrawIndicatorDevideMaterial.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawIndicatorNumberParam(const Value: TDrawTextParam);
begin
  FDrawIndicatorNumberParam.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetDrawSelectedCellBackColorParam(const Value: TDrawRectParam);
begin
  FDrawSelectedCellBackColorParam.Assign(Value);
end;

procedure TSkinVirtualGridDefaultMaterial.SetEvenRowBackColor(const Value: TDelphiColor);
begin
  Self.FRowBackColorMaterial.FEvenBackColor.FillColor.Color:=Value;
end;

{ TSkinCellDevideMaterial }


procedure TSkinCellDevideMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinCellDevideMaterial;
begin

  if Dest is TSkinCellDevideMaterial then
  begin
    DestObject:=TSkinCellDevideMaterial(Dest);

    DestObject.FIsDrawColLine:=FIsDrawColLine;
    DestObject.FIsDrawRowLine:=FIsDrawRowLine;

    DestObject.FIsDrawColEndLine:=FIsDrawColEndLine;
    DestObject.FIsDrawRowEndLine:=FIsDrawRowEndLine;
    DestObject.FIsDrawColBeginLine:=FIsDrawColBeginLine;
    DestObject.FIsDrawRowBeginLine:=FIsDrawRowBeginLine;

  end;


  inherited;
end;

constructor TSkinCellDevideMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawColLineParam:=CreateDrawLineParam('DrawColLineParam','列分隔线绘制参数');
  FDrawColLineParam.PenDrawColor.Color:=$FFD4D0C8;

  FDrawRowLineParam:=CreateDrawLineParam('DrawRowLineParam','行分隔线绘制参数');
  FDrawRowLineParam.PenDrawColor.Color:=$FFD4D0C8;


  FIsDrawColLine:=False;
  FIsDrawRowLine:=False;

  FIsDrawColEndLine:=False;
  FIsDrawRowEndLine:=False;
  FIsDrawColBeginLine:=False;
  FIsDrawRowBeginLine:=False;

end;

function TSkinCellDevideMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);


  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsDrawRowLine' then
    begin
      FIsDrawRowLine:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsDrawRowBeginLine' then
    begin
      FIsDrawRowBeginLine:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsDrawRowEndLine' then
    begin
      FIsDrawRowEndLine:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsDrawColLine' then
    begin
      FIsDrawColLine:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsDrawColBeginLine' then
    begin
      FIsDrawColBeginLine:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsDrawColEndLine' then
    begin
      FIsDrawColEndLine:=ABTNode.ConvertNode_Bool32.Data;
    end

    ;
  end;

  Result:=True;
end;

function TSkinCellDevideMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  //是否绘制行分隔线
  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawRowLine','是否绘制行分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawRowLine;
  //是否绘制开始行分隔线
  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawRowBeginLine','是否绘制开始行分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawRowBeginLine;
  //是否绘制结束行分隔线
  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawRowEndLine','是否绘制结束行分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawRowEndLine;


  //是否绘制列分隔线
  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawColLine','是否绘制列分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawColLine;
  //是否绘制开始列分隔线
  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawColBeginLine','是否绘制开始列分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawColBeginLine;
  //是否绘制结束列分隔线
  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawColEndLine','是否绘制结束列分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawColEndLine;


  Result:=True;
end;

destructor TSkinCellDevideMaterial.Destroy;
begin
  FreeAndNil(FDrawColLineParam);
  FreeAndNil(FDrawRowLineParam);
  inherited;
end;


procedure TSkinCellDevideMaterial.SetDrawColLineParam(const Value: TDrawLineParam);
begin
  FDrawColLineParam.Assign(Value);
end;

procedure TSkinCellDevideMaterial.SetDrawRowLineParam(const Value: TDrawLineParam);
begin
  FDrawRowLineParam.Assign(Value);
end;

procedure TSkinCellDevideMaterial.SetIsDrawColBeginLine(const Value: Boolean);
begin
  if FIsDrawColBeginLine<>Value then
  begin
    FIsDrawColBeginLine := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCellDevideMaterial.SetIsDrawColEndLine(const Value: Boolean);
begin
  if FIsDrawColEndLine<>Value then
  begin
    FIsDrawColEndLine := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCellDevideMaterial.SetIsDrawColLine(const Value: Boolean);
begin
  if FIsDrawColLine<>Value then
  begin
    FIsDrawColLine := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCellDevideMaterial.SetIsDrawRowBeginLine(const Value: Boolean);
begin
  if FIsDrawRowBeginLine<>Value then
  begin
    FIsDrawRowBeginLine := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCellDevideMaterial.SetIsDrawRowEndLine(const Value: Boolean);
begin
  if FIsDrawRowEndLine<>Value then
  begin
    FIsDrawRowEndLine := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCellDevideMaterial.SetIsDrawRowLine(const Value: Boolean);
begin
  if FIsDrawRowLine<>Value then
  begin
    FIsDrawRowLine := Value;
    Self.DoChange;
  end;
end;



{ TSkinVirtualGridColumns }

function TSkinVirtualGridColumns.Add: TSkinVirtualGridColumn;
begin
  Result:=TSkinVirtualGridColumn(Inherited Add);
end;

procedure TSkinVirtualGridColumns.Added(var Item: TCollectionItem);
begin
  uBaseLog.OutputDebugString('TSkinVirtualGridColumns.Added');

  TSkinVirtualGridColumn(Item).SetSkinListIntf(Self);
  inherited;
end;

procedure TSkinVirtualGridColumns.AfterConstruction;
begin
  inherited;
  if GetOwner <> nil then
    GetOwner.GetInterface(IInterface, FOwnerInterface);
end;

procedure TSkinVirtualGridColumns.BeginUpdate;
begin
  uBaseLog.OutputDebugString('TSkinVirtualGridColumns.BeginUpdate');
  Inc(FUpdateCount);
  inherited;
end;

function TSkinVirtualGridColumns._AddRef: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._AddRef else
    Result := -1;
end;

function TSkinVirtualGridColumns._Release: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._Release else
    Result := -1;
end;

function TSkinVirtualGridColumns.QueryInterface(const IID: TGUID;
  out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;

constructor TSkinVirtualGridColumns.Create(AProperties:TVirtualGridProperties;
                                          ItemClass: TCollectionItemClass);
begin
  Inherited Create(ItemClass);
  FVirtualGridProperties:=AProperties;
end;

procedure TSkinVirtualGridColumns.Deleting(Item: TCollectionItem);
begin
  uBaseLog.OutputDebugString('TSkinVirtualGridColumns.Deleting');
  TSkinVirtualGridColumn(Item).SetSkinListIntf(nil);
  inherited;
end;

destructor TSkinVirtualGridColumns.Destroy;
begin
  FIsDestroying:=True;

  
  inherited;
end;

procedure TSkinVirtualGridColumns.DoChange;
begin
  //
end;

function TSkinVirtualGridColumns.GetCount: Integer;
begin
  Result:=Self.Count;
end;

function TSkinVirtualGridColumns.GetSkinItem(const Index: Integer): ISkinItem;
begin
  Result:=Items[Index] as ISkinItem;
end;

function TSkinVirtualGridColumns.GetSkinObject(const Index: Integer): TObject;
begin
  Result:=Items[Index];
end;

function TSkinVirtualGridColumns.GetListLayoutsManager: TSkinListLayoutsManager;
begin
  Result:=FListLayoutsManager;
end;

function TSkinVirtualGridColumns.GetObject: TObject;
begin
  Result:=Self;
end;

function TSkinVirtualGridColumns.IndexOf(AObject: TObject): Integer;
var
  I: Integer;
begin
  Result:=-1;
  for I := 0 to Count-1 do
  begin
    if Items[I]=AObject then
    begin
      Result:=I;
      Break;
    end;
  end;
end;

function TSkinVirtualGridColumns.GetItem(Index: Integer): TSkinVirtualGridColumn;
begin
  Result:=TSkinVirtualGridColumn(Inherited Items[Index]);
end;

procedure TSkinVirtualGridColumns.SetItem(Index: Integer;const Value: TSkinVirtualGridColumn);
begin
  Inherited Items[Index]:=Value;
end;

procedure TSkinVirtualGridColumns.SetListLayoutsManager(ALayoutsManager: TSkinListLayoutsManager);
begin
  FListLayoutsManager:=ALayoutsManager;
end;

procedure TSkinVirtualGridColumns.Update(Item: TCollectionItem);
begin
  uBaseLog.OutputDebugString('TSkinVirtualGridColumns.Update');


  inherited;

  //表格列数据更改或被删除
  if (Self.FVirtualGridProperties = nil)
    or (csLoading in FVirtualGridProperties.FSkinControl.ComponentState) then
  begin
    Exit;
  end;


  //当列被删除的时候,去除单元格选择列
  if (Self.FVirtualGridProperties<>nil)
    and (FVirtualGridProperties.FClickedCellCol<>nil)
    and (Self.IndexOf(FVirtualGridProperties.FClickedCellCol)=-1) then
  begin

    //如果当前列正在编辑,那么取消编辑
    if FVirtualGridProperties.FClickedCellCol=Self.FVirtualGridProperties.FEditingCellCol then
    begin
      FVirtualGridProperties.CancelEditingItem;
    end;

    FVirtualGridProperties.FClickedCellCol:=nil;
  end;


  if GetListLayoutsManager<>nil then
  begin
    Self.GetListLayoutsManager.DoItemVisibleChange(nil,False);
  end;

end;

function TSkinVirtualGridColumns.GetUpdateCount: Integer;
begin
  Result:=Self.FUpdateCount;
end;

procedure TSkinVirtualGridColumns.EndUpdate;
//var
//  ASkinItem:TSkinListBoxItem;
//  I: Integer;
//  AColumnHeader:TSkinListBox;
begin
  uBaseLog.OutputDebugString('TSkinVirtualGridColumns.EndUpdate Begin');


  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
  end;


  inherited;




  //是不是在释放的过程中
  if not FIsDestroying then
  begin

//      if FUpdateCount = 0 then
//      begin
//        Self.FVirtualGridProperties.FSkinVirtualGridIntf.SyncColumnHeader;
//      end;



      //EndUpate会调用Update,
      //所以不需要再在这里调用DoItemVisibleChange


      //当表格列加载结束的时候,也需要调用,不然表格列画不出来

      //判断列表项是否改变过大小再调用
      //万一有Item的Visible更改过了,也需要调用的
      if GetListLayoutsManager<>nil then
      begin
        Self.GetListLayoutsManager.DoItemVisibleChange(nil,True);
        Self.GetListLayoutsManager.DoItemPropChange(nil);
      end;


  end;

  
  uBaseLog.OutputDebugString('TSkinVirtualGridColumns.EndUpdate UpdateCount '+IntToStr(GetUpdateCount));

end;

function TSkinVirtualGridColumns.FindByCaption(
  ACaption: String): TSkinVirtualGridColumn;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Count-1 do
  begin
    if Items[I].Caption=ACaption then
    begin
      Result:=Items[I];
      Break;
    end;
  end;


end;

{ TSkinVirtualGridColumn }


procedure TSkinVirtualGridColumn.AfterConstruction;
begin
  inherited;
  if GetOwner <> nil then
    GetOwner.GetInterface(IInterface, FOwnerInterface);
end;

function TSkinVirtualGridColumn._AddRef: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._AddRef else
    Result := -1;
end;

function TSkinVirtualGridColumn._Release: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._Release else
    Result := -1;
end;

function TSkinVirtualGridColumn.QueryInterface(const IID: TGUID;
  out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;


procedure TSkinVirtualGridColumn.ClearItemRect;
begin
  //所在的位置
  FItemRect:=RectF(0,0,0,0);
  //绘制矩形
  FItemDrawRect:=RectF(0,0,0,0);
end;

constructor TSkinVirtualGridColumn.Create(Collection: TCollection);
begin
  //必须放在前面,因为Add之后调用Update,
  //但是如果FVisible为False,那就不显示了
  FVisible:=True;
  FWidth:=Const_DefaultColumnWidth;

  FAutoSize:=False;
  FAutoSizeMinWidth:=Const_DefaultColumnWidth;


  inherited Create(Collection);


//  Self.FMaterialUseKind:=mukSelfOwn;

  FIsUseDefaultGridColumnMaterial:=True;
  FIsUseDefaultGridColumnCaptionParam:=True;
//  FIsUseDefaultGridColumnCellText1Param:=True;
//  FIsUseDefaultGridColumnCellTextParam:=True;

  FFooter:=GetFooterClass.Create(Self);

  FMaterial:=GetColumnMaterialClass.Create(TSkinVirtualGridColumns(Collection).FVirtualGridProperties.FSkinControl);
  FMaterial.SetSubComponent(True);


  FDefaultItemStyleSetting:=TListItemTypeStyleSetting.Create(nil,sitDefault);
  FDefaultItemStyleSetting.FOnInit:=Self.DoNewListItemStyleFrameCacheInit;
  FDefaultItemStyleSetting.FCustomListProperties:=TSkinVirtualGridColumns(Collection).FVirtualGridProperties;

end;

destructor TSkinVirtualGridColumn.Destroy;
begin
  FreeAndNil(FPickList);

  FreeAndNil(FFooter);
  FreeAndNil(FMaterial);

  FreeAndNil(FDefaultItemStyleSetting);

  inherited;
end;

function TSkinVirtualGridColumn.GetBindItemFieldName: String;
begin
  Result:='';
end;

function TSkinVirtualGridColumn.GetBindItemFieldName1: String;
begin
  Result:='';
end;

function TSkinVirtualGridColumn.GetCaption: String;
begin
  Result:=FCaption;
end;

function TSkinVirtualGridColumn.GetColumnMaterialClass: TSkinVirtualGridColumnMaterialClass;
begin
  Result:=TSkinVirtualGridColumnMaterial;
end;

//function TSkinVirtualGridColumn.GetContentTypes: TSkinGridColumnContentTypes;
//begin
//  Result:=[cctText];
//end;
//
//function TSkinVirtualGridColumn.GetCurrentUseMaterial: TSkinVirtualGridColumnMaterial;
//begin
//  if FCurrentUseSkinMaterial=nil then
//  begin
//    case Self.FMaterialUseKind of
//      mukSelfOwn:
//      begin
//        //使用自已的皮肤素材
//        FCurrentUseSkinMaterial:=Self.FMaterial;
//      end;
//      mukDefault:
//      begin
//      end;
//      mukName:
//      begin
//      end;
//      mukRef,mukRefOnly:
//      begin
//        //使用引用的皮肤素材
//        FCurrentUseSkinMaterial:=Self.FRefMaterial;
//      end;
//    end;
////    if FCurrentUseSkinMaterial<>nil then
////    begin
////      //加入更改通知
////      Self.FCurrentUseSkinMaterial.RegisterChanges(FMaterialChangeLink);
////      //加入释放通知
////      Self.FCurrentUseSkinMaterial.FreeNotification(Self);
////    end;
//  end;
//  Result:=Self.FCurrentUseSkinMaterial;
//end;

function TSkinVirtualGridColumn.GetDisplayName: string;
begin
  Result:=Self.GetBindItemFieldName+' '+FCaption;
end;

function TSkinVirtualGridColumn.GetFooterClass: TSkinVirtualGridFooterClass;
begin
  Result:=TSkinVirtualGridFooter;
end;

function TSkinVirtualGridColumn.GetFooterStaticValue: String;
begin
  Result:=FFooter.StaticValue;
end;

function TSkinVirtualGridColumn.GetFooterValueFormat: String;
begin
  Result:=FFooter.FValueFormat;
end;

//层级
function TSkinVirtualGridColumn.GetLevel:Integer;
begin
  Result:=0;
end;

function TSkinVirtualGridColumn.GetHeight: Double;
begin
  if (Collection=nil) or (TSkinVirtualGridColumns(Collection).FListLayoutsManager=nil) then
  begin
    //默认列高
    Result:=Const_DefaultColumnHeaderHeight;
  end
  else
  begin
    //列高
    Result:=TSkinVirtualGridColumns(Collection).FListLayoutsManager.ItemHeight;
  end;
end;

function TSkinVirtualGridColumn.GetItemRect: TRectF;
begin
  Result:=FItemRect;
end;

function TSkinVirtualGridColumn.GetItemDrawRect: TRectF;
begin
  Result:=FItemDrawRect;
end;

function TSkinVirtualGridColumn.GetListLayoutsManager:TSkinListLayoutsManager;
begin
  Result:=nil;
  if FSkinListIntf<>nil then
  begin
    Result:=Self.FSkinListIntf.GetListLayoutsManager;
  end;
end;

function TSkinVirtualGridColumn.GetSelected: Boolean;
begin
  Result:=FSelected;
end;

function TSkinVirtualGridColumn.GetThisRowItemCount: Integer;
begin
  Result:=0;
end;

function TSkinVirtualGridColumn.GetObject: TObject;
begin
  Result:=Self;
end;

function TSkinVirtualGridColumn.GetPickList: TStrings;
begin
  if FPickList = nil then
    FPickList := TStringList.Create;
  Result := FPickList;
end;

function TSkinVirtualGridColumn.GetFooterValueType: TSkinGridFooterValueType;
begin
  Result:=FFooter.FValueType;
end;

function TSkinVirtualGridColumn.GetValueType(ARow: TBaseSkinItem): TVarType;
begin
  Result:=varEmpty;
end;

function TSkinVirtualGridColumn.GetValueType1(ARow: TBaseSkinItem): TVarType;
begin
  Result:=varEmpty;
end;

function TSkinVirtualGridColumn.GetVisible: Boolean;
begin
  Result:=FVisible;
end;

function TSkinVirtualGridColumn.GetWidth: Double;
begin
  Result:=FWidth;
end;

function TSkinVirtualGridColumn.Owner: TSkinVirtualGridColumns;
begin
  Result:=TSkinVirtualGridColumns(Collection);
end;

function TSkinVirtualGridColumn.PtInItem(APoint: TPointF): Boolean;
begin
  Result:=PtInRect(Self.FItemDrawRect,APoint);

end;

procedure TSkinVirtualGridColumn.SetDisplayName(const Value: string);
begin
  FCaption:=Value;
end;

procedure TSkinVirtualGridColumn.SetFooter(const Value: TSkinVirtualGridFooter);
begin
  FFooter.Assign(Value);
end;

procedure TSkinVirtualGridColumn.SetFooterStaticValue(const Value: String);
begin
  FFooter.StaticValue:=Value;
end;

procedure TSkinVirtualGridColumn.SetFooterValueFormat(const Value: String);
begin
  FFooter.ValueFormat:=Value;
end;

procedure TSkinVirtualGridColumn.SetItemRect(Value: TRectF);
begin
  FItemRect:=Value;
end;

procedure TSkinVirtualGridColumn.SetPickList(Value: TStrings);
begin
  if Value = nil then
  begin
    FreeAndNil(FPickList);
  end
  else
  begin
    PickList.Assign(Value);
  end;
end;


//procedure TSkinVirtualGridColumn.SetMaterialUseKind(const Value: TMaterialUseKind);
//begin
//  if FMaterialUseKind<>Value then
//  begin
//    FMaterialUseKind := Value;
//
////  if (FMaterialUseKind<>Value) then
////  begin
////    if Not FKeepSelfOwnMaterial then
////    begin
////      //不保存自已的素材
////      if (Value<>mukSelfOwn) then
////      begin
////        ClearSelfOwnMaterial;
////      end;
////    end;
////  end;
//
////  if (FMaterialUseKind<>Value)
////    or (FMaterialUseKind=Value) and (FCurrentUseSkinMaterial=nil) then
////  begin
//    FMaterialUseKind := Value;
//    case FMaterialUseKind of
//      mukSelfOwn:
//      begin
////        //自己拥有的
////        //先释放
////        Self.UnUseCurrentUseMaterial;
////        //再创建
////        Self.CreateSelfOwnMaterial;
////        //再获取当前使用的
////        Self.GetCurrentUseMaterial;
//      end;
//      mukDefault:
//      begin
//        //皮肤包默认的
//        //先释放
//        Self.UnUseCurrentUseMaterial;
//        //再获取当前使用的
//        Self.GetCurrentUseMaterial;
//      end;
//      mukName:
//      begin
////        //皮肤包指定名称
////        //先释放
////        Self.UnUseCurrentUseMaterial;
////        //再获取当前使用的
////        Self.GetCurrentUseMaterial;
//      end;
//      mukRef,mukRefOnly:
//      begin
//        //皮肤包指定名称
//        //先释放
//        Self.UnUseCurrentUseMaterial;
//        //再获取当前使用的
//        Self.GetCurrentUseMaterial;
//      end;
//    end;
////  end;
//
//
//    DoPropChange;
//  end;
//end;

procedure TSkinVirtualGridColumn.SetIsUseDefaultGridColumnCaptionParam(
  const Value: Boolean);
begin
  if FIsUseDefaultGridColumnCaptionParam<>Value then
  begin
    FIsUseDefaultGridColumnCaptionParam := Value;
//    UnUseCurrentUseMaterial;
    //应该刷新界面
    DoPropChange;
  end;
end;

//procedure TSkinVirtualGridColumn.SetIsUseDefaultGridColumnCellText1Param(
//  const Value: Boolean);
//begin
//  if FIsUseDefaultGridColumnCellText1Param<>Value then
//  begin
//    FIsUseDefaultGridColumnCellText1Param := Value;
////    UnUseCurrentUseMaterial;
//    //应该刷新界面
//    DoPropChange;
//  end;
//end;
//
//procedure TSkinVirtualGridColumn.SetIsUseDefaultGridColumnCellTextParam(
//  const Value: Boolean);
//begin
//  if FIsUseDefaultGridColumnCellTextParam<>Value then
//  begin
//    FIsUseDefaultGridColumnCellTextParam := Value;
////    UnUseCurrentUseMaterial;
//    //应该刷新界面
//    DoPropChange;
//  end;
//end;

procedure TSkinVirtualGridColumn.SetIsUseDefaultGridColumnMaterial(const Value: Boolean);
begin
  if FIsUseDefaultGridColumnMaterial<>Value then
  begin
    FIsUseDefaultGridColumnMaterial := Value;
//    UnUseCurrentUseMaterial;
    //应该刷新界面
    DoPropChange;
  end;
end;

function TSkinVirtualGridColumn.GetDefaultItemStyle: String;
begin
  Result:=FDefaultItemStyleSetting.Style;
end;

procedure TSkinVirtualGridColumn.SetDefaultItemStyle(const Value: String);
begin
  FDefaultItemStyleSetting.Style:=Value;
end;

procedure TSkinVirtualGridColumn.SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FDefaultItemStyleSetting.ItemDesignerPanel:=Value;
end;

function TSkinVirtualGridColumn.GetIsRowEnd: Boolean;
begin
  Result:=False;
end;

function TSkinVirtualGridColumn.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FDefaultItemStyleSetting.ItemDesignerPanel;
end;

procedure TSkinVirtualGridColumn.SetItemDrawRect(Value: TRectF);
begin
  FItemDrawRect:=Value;
end;

procedure TSkinVirtualGridColumn.SetSkinListIntf(ASkinListIntf: ISkinList);
begin
  FSkinListIntf:=ASkinListIntf;
end;

//procedure TSkinVirtualGridColumn.SetRefMaterial(const Value: TSkinVirtualGridColumnMaterial);
//begin
//  if FRefMaterial<>Value then
//  begin
//
//    UnUseCurrentUseMaterial;
//
//    //加入释放通知
//    if FRefMaterial<>nil then
//    begin
//      Self.FRefMaterial.RemoveFreeNotification(TComponent(Self.Collection.Owner));
//    end;
//
//
//    FRefMaterial := Value;
//
//    //加入释放通知
//    if FRefMaterial<>nil then
//    begin
//      Self.FRefMaterial.FreeNotification(TComponent(Self.Collection.Owner));
//    end;
//
//    //应该刷新界面
//    DoPropChange;
//  end;
//end;

procedure TSkinVirtualGridColumn.SetSelfOwnMaterial(const Value: TSkinVirtualGridColumnMaterial);
begin
  FMaterial.AssignTo(Value);
  DoPropChange;
end;

procedure TSkinVirtualGridColumn.DoSizeChange;
begin
  if Self.GetListLayoutsManager<>nil then
  begin
    Self.GetListLayoutsManager.DoItemSizeChange(Self);
  end;
end;

procedure TSkinVirtualGridColumn.DoVisibleChange;
begin
  if Self.GetListLayoutsManager<>nil then
  begin
    Self.GetListLayoutsManager.DoItemVisibleChange(Self);
  end;
end;

procedure TSkinVirtualGridColumn.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinVirtualGridColumn;
begin
  if Dest is TSkinVirtualGridColumn then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      DestObject:=Dest as TSkinVirtualGridColumn;

      DestObject.FCaption:=Self.FCaption;
      DestObject.FAutoSize:=Self.FAutoSize;
      DestObject.FWidth:=Self.FWidth;
      DestObject.FVisible:=Self.FVisible;
      DestObject.FReadonly:=Self.FReadonly;
      DestObject.PickList.Assign(Self.PickList);
      DestObject.FIsUseDefaultGridColumnMaterial:=Self.FIsUseDefaultGridColumnMaterial;
      DestObject.FIsUseDefaultGridColumnCaptionParam:=Self.FIsUseDefaultGridColumnCaptionParam;
//      DestObject.FIsUseDefaultGridColumnCellTextParam:=Self.FIsUseDefaultGridColumnCellTextParam;
//      DestObject.FIsUseDefaultGridColumnCellText1Param:=Self.FIsUseDefaultGridColumnCellText1Param;
//      DestObject.FMaterialUseKind:=Self.FMaterialUseKind;
      DestObject.FMaterial.Assign(FMaterial);

      DestObject.FFooter.Assign(Self.FFooter);


      DestObject.DefaultItemStyle:=Self.DefaultItemStyle;
      DestObject.ItemDesignerPanel:=Self.ItemDesignerPanel;


      DestObject.DoPropChange;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;

  end
  else
  begin
    inherited ;
  end;
end;

procedure TSkinVirtualGridColumn.DoNewListItemStyleFrameCacheInit(
  Sender: TObject; AListItemTypeStyleSetting: TListItemTypeStyleSetting;
  ANewListItemStyleFrameCache: TListItemStyleFrameCache);
begin

end;

procedure TSkinVirtualGridColumn.DoPropChange(Sender:TObject);
begin
  if Self.GetListLayoutsManager<>nil then
  begin
    GetListLayoutsManager.DoItemPropChange(Self);
  end;
end;

procedure TSkinVirtualGridColumn.SetFooterValueType(const Value: TSkinGridFooterValueType);
begin
  if FFooter.FValueType<>Value then
  begin
    FFooter.ValueType:=Value;
  end;
end;

procedure TSkinVirtualGridColumn.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible := Value;
    DoVisibleChange;
    DoSizeChange;
    DoPropChange;
  end;
end;

procedure TSkinVirtualGridColumn.SetWidth(const Value: Double);
begin
  if FWidth<>Value then
  begin
    FWidth := Value;
    DoSizeChange;
    DoPropChange;
  end;
end;

//procedure TSkinVirtualGridColumn.UnUseCurrentUseMaterial;
//begin
//  if (Self.FCurrentUseSkinMaterial<>nil) then
//  begin
//    if FCurrentUseSkinMaterial=FRefMaterial then
//    begin
//      FRefMaterial:=nil;
//    end;
//
//    FCurrentUseSkinMaterial.RemoveFreeNotification(TComponent(Self.Collection.Owner));
//
////    //去除更改通知
////    FCurrentUseSkinMaterial.UnRegisterChanges(FMaterialChangeLink);
//
//    FCurrentUseSkinMaterial:=nil;
//  end;
//end;

procedure TSkinVirtualGridColumn.SetCaption(const Value: String);
begin
  if Value<>Caption then
  begin
    FCaption:=Value;
    DoPropChange;
  end;
end;

{ TSkinVirtualGridColumnMaterial }


constructor TSkinVirtualGridColumnMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //默认不填充
//  Self.FDrawBackColorParam.IsFill:=False;

  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','表格列标题绘制参数');
  FDrawCaptionParam.FIsMustStoreFontColor:=True;

  FDrawCellTextParam:=CreateDrawTextParam('DrawCellTextParam','单元格文本绘制参数');
  FDrawCellTextParam.FIsMustStoreFontColor:=True;

  FDrawCellPictureParam:=CreateDrawPictureParam('DrawCellPictureParam','单元格图片绘制参数');

  FDrawFooterCellTextParam:=CreateDrawTextParam('DrawFooterCellTextParam','统计单元格文本绘制参数');
  FDrawFooterCellTextParam.FIsMustStoreFontColor:=True;

  FDrawCellText1Param:=CreateDrawTextParam('DrawCellText1Param','单元格文本1绘制参数');
end;

destructor TSkinVirtualGridColumnMaterial.Destroy;
begin
  FreeAndNil(FDrawCellText1Param);
  FreeAndNil(FDrawCaptionParam);
  FreeAndNil(FDrawCellTextParam);
  FreeAndNil(FDrawCellPictureParam);
  FreeAndNil(FDrawFooterCellTextParam);
  inherited;
end;

procedure TSkinVirtualGridColumnMaterial.SetDrawCellText1Param(const Value: TDrawTextParam);
begin
  FDrawCellText1Param.Assign(Value);
end;

procedure TSkinVirtualGridColumnMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;

procedure TSkinVirtualGridColumnMaterial.SetDrawCellPictureParam(const Value: TDrawPictureParam);
begin
  FDrawCellPictureParam.Assign(Value);
end;

procedure TSkinVirtualGridColumnMaterial.SetDrawCellTextParam(const Value: TDrawTextParam);
begin
  FDrawCellTextParam.Assign(Value);
end;

procedure TSkinVirtualGridColumnMaterial.SetDrawFooterCellTextParam(const Value: TDrawTextParam);
begin
  FDrawFooterCellTextParam.Assign(Value);
end;



{ TSkinVirtualGridRows }

function TSkinVirtualGridRows.Add: TSkinVirtualGridRow;
begin
  Result:=TSkinVirtualGridRow(Inherited Add);
end;

//function TSkinVirtualGridRows.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=SkinItemClass.Create;//(Self);
//end;


procedure TSkinVirtualGridRows.DoAdd(AObject: TObject);
begin
  inherited;


  {$IFDEF FREE_VERSION}
  if Count=200 then
  begin
    ShowMessage('OrangeUI免费版限制(Grid只能200条记录数)');
  end;
  {$ENDIF}


end;

procedure TSkinVirtualGridRows.EndUpdate(AIsForce: Boolean);
//var
//  I: Integer;
//  J:Integer;
//  AColumn:TSkinVirtualGridColumn;
//  AContent:String;
//  AContentWidth:Double;
//  AHasAutoSizeColumn:Boolean;
var
  AVirtualGridProperties:TVirtualGridProperties;
begin
  //如果有自适应尺寸的列
  AVirtualGridProperties:=TSkinVirtualGridRowLayoutsManager(Self.FListLayoutsManager).FVirtualGridProperties;
  AVirtualGridProperties.CalcAutoSizeColumnWidth;


//  for I := 0 to AVirtualGridProperties.FColumns.Count-1 do
//  begin
//    AColumn:=AVirtualGridProperties.FColumns[I];
//    if AColumn.AutoSize then
//    begin
//      AHasAutoSizeColumn:=True;
//      AColumn.FWidth:=AColumn.AutoSizeMinWidth;
//      Break;
//    end;
//  end;
//
//
//  if AHasAutoSizeColumn then
//  begin
//      GetGlobalDrawTextParam.FontSize:=
//        TSkinVirtualGridDefaultMaterial(AVirtualGridProperties.FSkinControlIntf.GetCurrentUseMaterial)
//          .FDrawColumnMaterial.FDrawCellTextParam.FontSize;
//      GetGlobalDrawTextParam.IsWordWrap:=False;
//
//      //需要计算该列的宽度,然后自动调整列宽
//      for I := 0 to AVirtualGridProperties.FColumns.Count-1 do
//      begin
//        AColumn:=AVirtualGridProperties.FColumns[I];
//        if AColumn.AutoSize then
//        begin
//          for J := 0 to Self.Count-1 do
//          begin
//            AContent:=AVirtualGridProperties.GetGridCellText(AColumn,Items[J]);
//            AContentWidth:=GetStringWidth(AContent,GetGlobalDrawTextParam.FontSize);
//            if AContentWidth>AColumn.FCalcedAutoSizeWidth then
//            begin
//              AColumn.FCalcedAutoSizeWidth:=AContentWidth;
//            end;
//
//          end;
//
//        end;
//      end;
//  end;
//
//
//  for I := 0 to AVirtualGridProperties.FColumns.Count-1 do
//  begin
//    AColumn:=AVirtualGridProperties.FColumns[I];
//    if AColumn.AutoSize then
//    begin
//      AColumn.Width:=AColumn.FCalcedAutoSizeWidth;
//    end;
//  end;



  inherited;

end;

function TSkinVirtualGridRows.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TSkinVirtualGridRow;
end;

//procedure TSkinVirtualGridRows.InitSkinItemClass;
//begin
//  inherited;
//
//end;

//procedure TSkinVirtualGridRows.InitSkinItemClass;
//begin
//  SkinItemClass:=TSkinVirtualGridRow;
//end;

{ TSkinRowBackColorMaterial }

procedure TSkinRowBackColorMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinRowBackColorMaterial;
begin
  if Dest is TSkinRowBackColorMaterial then
  begin

    DestObject:=TSkinRowBackColorMaterial(Dest);

    DestObject.FIsDiffOddAndEven:=FIsDiffOddAndEven;

  end;
  inherited;
end;

constructor TSkinRowBackColorMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FIsDiffOddAndEven:=False;

  //背景色
  FBackColor:=CreateDrawRectParam('BackColor','背景绘制参数');
  //奇数
  FOddBackColor:=CreateDrawRectParam('OddBackColor','奇数背景绘制参数');
  //偶数
  FEvenBackColor:=CreateDrawRectParam('EvenBackColor','偶数背景绘制参数');


end;

function TSkinRowBackColorMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsDiffOddAndEven' then
    begin
      FIsDiffOddAndEven:=ABTNode.ConvertNode_Bool32.Data;
    end

    ;
  end;

  Result:=True;
end;

function TSkinRowBackColorMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsDiffOddAndEven','区分奇数和偶数行');
  ABTNode.ConvertNode_Bool32.Data:=FIsDiffOddAndEven;


  Result:=True;
end;

destructor TSkinRowBackColorMaterial.Destroy;
begin

  //背景色
  FreeAndNil(FBackColor);
  //厅数
  FreeAndNil(FOddBackColor);
  //偶数
  FreeAndNil(FEvenBackColor);


  inherited;
end;


procedure TSkinRowBackColorMaterial.SetIsDiffOddAndEven(const Value: Boolean);
begin
  if FIsDiffOddAndEven<>Value then
  begin
    FIsDiffOddAndEven := Value;
    Self.DoChange;
  end;
end;

procedure TSkinRowBackColorMaterial.SetOddBackColor(const Value: TDrawRectParam);
begin
  FOddBackColor.Assign(Value);
end;

procedure TSkinRowBackColorMaterial.SetBackColor(const Value: TDrawRectParam);
begin
  FBackColor.Assign(Value);
end;

procedure TSkinRowBackColorMaterial.SetEvenBackColor(const Value: TDrawRectParam);
begin
  FEvenBackColor.Assign(Value);
end;

{ TSkinFixedRowBackColorMaterial }

procedure TSkinFixedRowBackColorMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinFixedRowBackColorMaterial;
begin
  if Dest is TSkinFixedRowBackColorMaterial then
  begin

    DestObject:=TSkinFixedRowBackColorMaterial(Dest);

    DestObject.FIsDiffFixedCols:=FIsDiffFixedCols;

  end;
  inherited;
end;

constructor TSkinFixedRowBackColorMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FIsDiffFixedCols:=False;



  //背景色
  FFixedColsBackColor:=CreateDrawRectParam('FixedColsBackColor','固定列背景绘制参数');
  //奇数
  FFixedColsOddBackColor:=CreateDrawRectParam('FixedColsOddBackColor','固定列奇数背景绘制参数');
  //偶数
  FFixedColsEvenBackColor:=CreateDrawRectParam('FixedColsEvenBackColor','固定列偶数背景绘制参数');



end;

function TSkinFixedRowBackColorMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsDiffFixedCols' then
    begin
      FIsDiffFixedCols:=ABTNode.ConvertNode_Bool32.Data;
    end

    ;
  end;

  Result:=True;
end;

function TSkinFixedRowBackColorMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsDiffFixedCols','区分固定列和活动列');
  ABTNode.ConvertNode_Bool32.Data:=FIsDiffFixedCols;

  Result:=True;
end;

destructor TSkinFixedRowBackColorMaterial.Destroy;
begin

  //背景色
  FreeAndNil(FFixedColsBackColor);
  //厅数
  FreeAndNil(FFixedColsOddBackColor);
  //偶数
  FreeAndNil(FFixedColsEvenBackColor);


  inherited;
end;

procedure TSkinFixedRowBackColorMaterial.SetIsDiffFixedCols(const Value: Boolean);
begin
  if FIsDiffFixedCols<>Value then
  begin
    FIsDiffFixedCols := Value;
    Self.DoChange;
  end;
end;

procedure TSkinFixedRowBackColorMaterial.SetFixedColsOddBackColor(const Value: TDrawRectParam);
begin
  FFixedColsOddBackColor.Assign(Value);
end;

procedure TSkinFixedRowBackColorMaterial.SetFixedColsBackColor(const Value: TDrawRectParam);
begin
  FFixedColsBackColor.Assign(Value);
end;

procedure TSkinFixedRowBackColorMaterial.SetFixedColsEvenBackColor(const Value: TDrawRectParam);
begin
  FFixedColsEvenBackColor.Assign(Value);
end;

{ TSkinVirtualGridFooter }

procedure TSkinVirtualGridFooter.AssignTo(Dest: TPersistent);
begin
  if Dest is TSkinVirtualGridFooter then
  begin
    TSkinVirtualGridFooter(Dest).FStaticValue:=FStaticValue;
    TSkinVirtualGridFooter(Dest).FSumValue:=FSumValue;
    TSkinVirtualGridFooter(Dest).FAverageValue:=FAverageValue;
    TSkinVirtualGridFooter(Dest).FValueType:=FValueType;
    TSkinVirtualGridFooter(Dest).FValueFormat:=FValueFormat;
    TSkinVirtualGridFooter(Dest).FRecordCount:=FRecordCount;
  end;
end;

constructor TSkinVirtualGridFooter.Create(AOwner:TSkinVirtualGridColumn);
begin
  FOwner:=AOwner;
end;

destructor TSkinVirtualGridFooter.Destroy;
begin

  inherited;
end;

procedure TSkinVirtualGridFooter.DoChange;
begin
  if (Self.FOwner<>nil) then
  begin
    if (Self.FOwner.Owner<>nil) then
    begin
      if (Self.FOwner.Owner.FVirtualGridProperties<>nil) then
      begin
        if (Self.FValueType=fvtSum)
          or (Self.FValueType=fvtCount)
          or (Self.FValueType=fvtAverage) then
        begin
          Self.FOwner//Column
              .Owner//Columns
              .FVirtualGridProperties//VirtualGrid
              .UpdateFooterRow;
        end;
      end;
    end;
  end;
end;

procedure TSkinVirtualGridFooter.DoInvalidate;
begin
  if (Self.FOwner<>nil) then
  begin
    if (Self.FOwner.Owner<>nil) then
    begin
      if (Self.FOwner.Owner.FVirtualGridProperties<>nil) then
      begin
        Self.FOwner.Owner.FVirtualGridProperties.Invalidate;
      end;
    end;
  end;
end;

function TSkinVirtualGridFooter.GetValue: String;
begin
  case FValueType of
    fvtNone: Result:='';
    fvtSum:
    begin
        if Self.FValueFormat<>'' then
        begin
          Result:=Format(FValueFormat,[FSumValue]);
        end
        else
        begin
          Result:=FloatToStr(FSumValue);
        end;
    end;
    fvtStatic:
    begin
        Result:=FStaticValue;
    end;
    fvtCount:
    begin
        Result:=IntToStr(FRecordCount);
    end;
    fvtAverage:
    begin
        if Self.FValueFormat<>'' then
        begin
          Result:=Format(FValueFormat,[FAverageValue]);
        end
        else
        begin
          Result:=FloatToStr(FAverageValue);
        end;
    end;
  end;
end;

procedure TSkinVirtualGridFooter.SetStaticValue(const Value: String);
begin
  if FStaticValue<>Value then
  begin
    FStaticValue := Value;
    DoInvalidate;
  end;
end;

procedure TSkinVirtualGridFooter.SetValueFormat(const Value: String);
begin
  if FValueFormat<>Value then
  begin
    FValueFormat := Value;
    DoInvalidate;
  end;
end;

procedure TSkinVirtualGridFooter.SetValueType(const Value: TSkinGridFooterValueType);
begin
  if FValueType<>Value then
  begin
    FValueType := Value;
    DoChange;
  end;
end;



{ TSkinVirtualGridRow }

function TSkinVirtualGridRow.GetWidth: Double;
begin
  Result:=Inherited GetWidth;
  if Self.GetListLayoutsManager<>nil then
  begin
    Result:=TSkinVirtualGridRowLayoutsManager(GetListLayoutsManager).FVirtualGridProperties.CalcContentWidth;
//    Result:=TSkinVirtualGridRowLayoutsManager(GetListLayoutsManager).ContentWidth;
  end;
end;



{ TSkinVirtualGrid }

function TSkinVirtualGrid.Material:TSkinVirtualGridDefaultMaterial;
begin
  Result:=TSkinVirtualGridDefaultMaterial(SelfOwnMaterial);
end;

function TSkinVirtualGrid.SelfOwnMaterialToDefault:TSkinVirtualGridDefaultMaterial;
begin
  Result:=TSkinVirtualGridDefaultMaterial(SelfOwnMaterial);
end;

procedure TSkinVirtualGrid.AfterPaint;
var
  AHeaderDrawRect:TRectF;
  ASkinMaterial:TSkinControlMaterial;
begin
  inherited;


  {$IFDEF FMX}
  FCanvas.Prepare(Canvas);


  if
      //设置了列头的高度
      BiggerDouble(Self.Prop.ColumnsHeaderHeight,0) then
  begin
      ASkinMaterial:=Self.GetSkinControlType.GetPaintCurrentUseMaterial;

      //绘制列头
      AHeaderDrawRect:=Self.Prop.GetContentRect_Header;
      //列头不能上下滑动的,所以不需要加上上下偏移
      //加上水平滚动偏移
      AHeaderDrawRect.Left:=AHeaderDrawRect.Left-TSkinVirtualGridDefaultType(Self.SkinControlType).FDrawRectLeftOffset;
      AHeaderDrawRect.Right:=AHeaderDrawRect.Right-TSkinVirtualGridDefaultType(Self.SkinControlType).FDrawRectRightOffset;

      TSkinVirtualGridDefaultType(Self.SkinControlType).CustomPaintColumnsHeader(
                                FCanvas,
                                ASkinMaterial,
                                RectF(0,0,Width,Height),
                                FPaintData,

                                AHeaderDrawRect,

//                                FDrawColumnStartIndex,
//                                FDrawColumnEndIndex,

                                TSkinVirtualGridDefaultMaterial(ASkinMaterial));

  end;

  FCanvas.UnPrepare;
  {$ENDIF FMX}

end;

constructor TSkinVirtualGrid.Create(AOwner: TComponent);
begin
  inherited;


//  FSyncColumnHeaderTimer:=TTimer.Create(Self);
//  FSyncColumnHeaderTimer.OnTimer:=DoSyncColumnHeaderTimer;
//
//
//  FColumnHeader:=TSkinListBox.Create(Self);
//  FColumnHeader.SetSubComponent(True);
//  AddFreeNotification(FColumnHeader,Self);
//  FColumnHeader.Name:='ColumnHeader';
//
//  FColumnHeader.Stored:=False;
//
//  FColumnHeader.Parent:=Self;
//  FColumnHeader.Align:=TAlignLayout.Top;
//  FColumnHeader.Height:=Self.Prop.ColumnsHeaderHeight;
//  FColumnHeader.SkinControlType;
//  FColumnHeader.SelfOwnMaterial;
//
//
////  FColumnHeader.Material.IsTransparent:=False;
////  FColumnHeader.Material.BackColor.FillColor.Color:=TAlphaColorRec.White;//Red;
////  FColumnHeader.Material.BackColor.IsFill:=True;
//
//
//  FColumnHeader.Prop.HorzScrollBarShowType:=sbstHide;
//  FColumnHeader.Prop.ItemLayoutType:=TItemLayoutType.iltHorizontal;
//  FColumnHeader.Prop.ItemHeight:=-1;//20;//
//  FColumnHeader.Prop.VertScrollBarShowType:=sbstNone;
//
//
//  FColumnHeader.HorzScrollBar.OnChange:=DoColumnHeader_HorzScrollBar_OnPositionChange;
//  Self.HorzScrollBar.OnChange:=Self.DoHorzScrollBar_OnPositionChange;
//
//
//  FColumnHeader.Visible:=False;
end;

function TSkinVirtualGrid.CurrentUseMaterialToDefault:TSkinVirtualGridDefaultMaterial;
begin
  Result:=TSkinVirtualGridDefaultMaterial(CurrentUseMaterial);
end;

function TSkinVirtualGrid.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TVirtualGridProperties;
end;

function TSkinVirtualGrid.GetVirtualGridProperties: TVirtualGridProperties;
begin
  Result:=TVirtualGridProperties(Self.FProperties);
end;

procedure TSkinVirtualGrid.SetVirtualGridProperties(Value: TVirtualGridProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinVirtualGrid.StayClick;
var
  I: Integer;
begin
  inherited;

  if Assigned(FOnClickColumn)
      and 
      PtInRect(
              Self.Prop.GetContentRect_Header,
              Self.GetSkinControlType.FMouseDownPt
              ) then
  begin
      //判断鼠标是否在列头区域
      for I := 0 to Self.Prop.FColumns.Count-1 do
      begin
          if PtInRect(Self.Prop.VisibleColumnDrawRect(Self.Prop.FColumns[I]),
                      Self.GetSkinControlType.FMouseDownPt
                      ) then
          begin
            FOnClickColumn(Self,Self.Prop.FColumns[I]);
            Break;
          end;
      end;
  end;
end;

//procedure TSkinVirtualGrid.SyncColumnHeader;
//var
//  I:Integer;
//  ASkinItem:TSkinListBoxItem;
//begin
//  if FColumnHeader<>nil then
//  begin
//        //表头的滚动设置
//
//        FColumnHeader.Prop.HorzCanOverRangeTypes:=Self.Prop.HorzCanOverRangeTypes;
//
//
//
//
////        //表头背景色
////        FColumnHeader.Material.BackColor.Assign(
////              Self.Material.ColumnHeaderBackColor
////              );
//
//
//
//        //列单独背景色
//        FColumnHeader.Material.DrawItemBackColorParam//.FillColor.Color:=TAlphaColorRec.Blue;
//            .Assign(
//                  Self.Material.ColumnHeaderBackColor//FDrawColumnMaterial.BackColor
//                );
////        FColumnHeader.Material.DrawItemBackColorParam.IsFill:=True;
//
//
//        //列标题字体
//        FColumnHeader.Material.DrawItemCaptionParam//.FontColor:=TAlphaColorRec.Black;
//            .Assign(
//                  Self.Material.FDrawColumnMaterial.FDrawCaptionParam
//                  );
//
//
//
//        //列分隔线
//        Self.FColumnHeader.Material.DrawItemDevideParam.IsFill:=
//            Self.Material.FDrawColumnDevideMaterial.IsDrawColLine;
//        Self.FColumnHeader.Material.DrawItemDevideParam.FillColor.Color:=
//            Self.Material.FDrawColumnDevideMaterial.DrawColLineParam.PenDrawColor.Color;
//
//        Self.FColumnHeader.Material.DrawGroupBeginDevideParam.IsFill:=
//            Self.Material.FDrawColumnDevideMaterial.IsDrawColBeginLine;
//        Self.FColumnHeader.Material.DrawGroupBeginDevideParam.FillColor.Color:=
//            Self.Material.FDrawColumnDevideMaterial.DrawColLineParam.PenDrawColor.Color;
//
//        Self.FColumnHeader.Material.DrawGroupEndDevideParam.IsFill:=
//            Self.Material.FDrawColumnDevideMaterial.IsDrawColEndLine;
//        Self.FColumnHeader.Material.DrawGroupEndDevideParam.FillColor.Color:=
//            Self.Material.FDrawColumnDevideMaterial.DrawColLineParam.PenDrawColor.Color;
//
//
//        //行分隔线
//        Self.FColumnHeader.Material.DrawItemBackColorParam.BorderEadges:=[];
//        Self.FColumnHeader.Material.DrawItemBackColorParam.BorderWidth:=0;
////        if Self.Material.FDrawColumnDevideMaterial.IsDrawRowBeginLine then
////        begin
////          Self.FColumnHeader.Material.DrawItemBackColorParam.BorderWidth:=1;
////          Self.FColumnHeader.Material.DrawItemBackColorParam.BorderEadges:=[beTop];
////        end;
//        if Self.Material.FDrawColumnDevideMaterial.IsDrawRowEndLine then
//        begin
//        Self.FColumnHeader.Material.DrawItemBackColorParam.BorderWidth:=1;
//          Self.FColumnHeader.Material.DrawItemBackColorParam.BorderEadges:=
//            Self.FColumnHeader.Material.DrawItemBackColorParam.BorderEadges
//            +[beBottom];
//        end;
//        Self.FColumnHeader.Material.DrawItemBackColorParam.BorderColor.Color:=
//            Self.Material.FDrawColumnDevideMaterial.DrawRowLineParam.PenDrawColor.Color;
//
//
//
//
//
//
//        if FColumnHeader<>nil then
//        begin
//          FColumnHeader.Prop.Items.BeginUpdate();
//          try
//              //  ASkinItem:TSkinListBoxItem;
//
//              FColumnHeader.Prop.Items.Clear(True);
//
//
//
//              for I := 0 to Self.Prop.Columns.Count-1 do
//              begin
//                ASkinItem:=FColumnHeader.Prop.Items.Add;
//
//                //列标题
//                ASkinItem.Caption:=Self.Prop.Columns[I].Caption;
//                ASkinItem.Width:=Self.Prop.Columns[I].Width;
////                ASkinItem.Height:=20;
//
//              end;
//
//
////              FColumnHeader.Prop.ListLayoutsManager.FFixedItems.Clear(False);
////              for I:=0 to Self.FVirtualGridProperties.FFixedCols-1 do
////              begin
////                if I<FColumnHeader.Prop.Items.Count then
////                begin
////                  FColumnHeader.Prop.ListLayoutsManager.FFixedItems.Add(Self.Items[I]);
////                end;
////              end;
//
//
//
//          finally
//            FColumnHeader.Prop.Items.EndUpdate();
//          end;
//        end;
//
//  end;
//end;

procedure TSkinVirtualGrid.Loaded;
begin
  Inherited;

  //表格列结束更新
  //它自己会调用
//  Self.Properties.Columns.EndUpdate();


//  Self.SyncColumnHeader;

  uBaseLog.OutputDebugString('TSkinVirtualGrid.Loaded End');
end;

procedure TSkinVirtualGrid.ReadState(Reader: TReader);
begin
  uBaseLog.OutputDebugString('TSkinVirtualGrid.ReadState Begin');

  //表格列开始更新
  //它自己会调用
//  Self.Properties.Columns.BeginUpdate;


  inherited ReadState(Reader);
end;

procedure TSkinVirtualGrid.Notification(AComponent: TComponent; Operation: TOperation);
//var
//  I:Integer;
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
//    if (AComponent=Self.FColumnHeader) then
//    begin
//      FColumnHeader:=nil;
//    end;

//    if (Self.Properties<>nil) and (AComponent is TSkinVirtualGridColumnMaterial) then
//    begin
//      //表格列的引用素材被删除
//      for I := 0 to Self.Properties.Columns.Count-1 do
//      begin
//        if Self.Properties.Columns[I].RefMaterial=AComponent then
//        begin
//          Self.Properties.Columns[I].RefMaterial:=nil;
//        end;
//      end;
//    end
//    ;
  end;
end;


destructor TSkinVirtualGrid.Destroy;
begin

  inherited;
end;

//procedure TSkinVirtualGrid.DoColumnHeader_HorzScrollBar_OnPositionChange(
//  Sender: TObject);
//begin
//  Self.HorzScrollBar.OnChange:=nil;
//  try
//    Self.Prop.HorzControlGestureManager.StaticPosition:=
//      Self.FColumnHeader.Prop.HorzControlGestureManager.StaticPosition;
//
//    Self.Prop.HorzControlGestureManager.StaticMinOverRangePosValue:=
//      Self.FColumnHeader.Prop.HorzControlGestureManager.StaticMinOverRangePosValue;
//
//    Self.Prop.HorzControlGestureManager.StaticMaxOverRangePosValue:=
//      Self.FColumnHeader.Prop.HorzControlGestureManager.StaticMaxOverRangePosValue;
//
//    Self.Invalidate;
//  finally
//    Self.HorzScrollBar.OnChange:=Self.DoHorzScrollBar_OnPositionChange;
//  end;
//end;
//
//procedure TSkinVirtualGrid.DoHorzScrollBar_OnPositionChange(Sender: TObject);
//begin
//  Self.FColumnHeader.HorzScrollBar.OnChange:=nil;
//  try
//    Self.FColumnHeader.Prop.HorzControlGestureManager.StaticPosition:=
//      Self.Prop.HorzControlGestureManager.StaticPosition;
//
//    Self.FColumnHeader.Prop.HorzControlGestureManager.StaticMinOverRangePosValue:=
//      Self.Prop.HorzControlGestureManager.StaticMinOverRangePosValue;
//
//    Self.FColumnHeader.Prop.HorzControlGestureManager.StaticMaxOverRangePosValue:=
//      Self.Prop.HorzControlGestureManager.StaticMaxOverRangePosValue;
//
//    Self.FColumnHeader.Invalidate;
//  finally
//    Self.FColumnHeader.HorzScrollBar.OnChange:=Self.DoColumnHeader_HorzScrollBar_OnPositionChange;
//  end;
//end;
//
//procedure TSkinVirtualGrid.DoSyncColumnHeaderTimer(Sender: TObject);
//begin
//  SyncColumnHeader;
//end;

function TSkinVirtualGrid.GetOnClickCell: TGridClickCellEvent;
begin
  Result:=FOnClickCell;
end;

function TSkinVirtualGrid.GetOnGetCellDisplayText: TGetGridCellDisplayTextEvent;
begin
  Result:=FOnGetCellDisplayText;
end;

function TSkinVirtualGrid.GetOnGetCellEditControl: TGetGridCellEditControlEvent;
begin
  Result:=FOnGetCellEditControl;
end;

function TSkinVirtualGrid.GetOnGetFooterCellDisplayText: TGetGridFooterCellDisplayTextEvent;
begin
  Result:=FOnGetFooterCellDisplayText;
end;

function TSkinVirtualGrid.GetOnCustomPaintCellBegin: TGridCustomPaintCellBeginEvent;
begin
  Result:=FOnCustomPaintCellBegin;
end;

function TSkinVirtualGrid.GetOnCustomPaintCellEnd: TGridCustomPaintCellBeginEvent;
begin
  Result:=FOnCustomPaintCellEnd;
end;

//function TSkinVirtualGrid.GetColumnHeader:TSkinListBox;
//begin
//  Result:=FColumnHeader;
//end;
//
//procedure TSkinVirtualGrid.SetColumnHeader(Value: TSkinListBox);
//begin
//  if FColumnHeader<>Value then
//  begin
//    //将原Style释放或解除绑定
//    if FColumnHeader<>nil then
//    begin
//      if (FColumnHeader.Owner=Self) then
//      begin
//        FColumnHeader.Name:='';
////        //释放自己创建的
////        //会重复释放
////        FHorzScrollBarIntf:=nil;
////        FHorzScrollBarControlIntf:=nil;
//////        FHorzScrollBarComponentIntf:=nil;
//        FreeAndNil(FColumnHeader);
//      end
//      else
//      begin
//        //解除别人的
//        FColumnHeader:=nil;
////        FHorzScrollBarIntf:=nil;
////        FHorzScrollBarControlIntf:=nil;
//////        FHorzScrollBarComponentIntf:=nil;
//      end;
//    end;
//
//    if (Value<>nil)
////    //需要滚动条
////    and (Properties.HorzScrollBarShowType<>sbstNone)
//    then
//    begin
//      FColumnHeader:=Value;
////      FHorzScrollBarIntf:=FColumnHeader as ISkinScrollBar;
////      FHorzScrollBarControlIntf:=FColumnHeader as ISkinControl;
//////      FHorzScrollBarComponentIntf:=FColumnHeader as ISkinComponent;
////
////      //水平滚动条默认不启用越界
////      FHorzScrollBarIntf.Prop.ControlGestureManager.CanOverRangeTypes:=[];
//////      //位置更改事件
//////      FHorzScrollBarIntf.OnInnerChange:=Self.DoHorzScrollBarPositionChange;
////      //绘制事件
////      FHorzScrollBarIntf.OnInvalidateScrollControl:=Self.DoScrollBarInvalidate;
////
//
//      AddFreeNotification(FColumnHeader,Self);
//
//    end
//    else//nil value
//    begin
//
//    end;
//  end;
//end;


{ TSkinVirtualGridColumnLayoutsManager }

//procedure TSkinVirtualGridColumnLayoutsManager.CalcDrawStartAndEndIndex(ADrawLeftOffset,
//                                                            ADrawTopOffset//,
////                                                            ADrawRightOffset,
////                                                            ADrawBottomOffset
//                                                            :TControlSize;
//                                                            AControlWidth,AControlHeight:TControlSize;
//                                                            var ADrawStartIndex:Integer;
//                                                            var ADrawEndIndex:Integer);
//var
//  I: Integer;
//  AItemRect:TRectF;
//  AFirstItemBottom:TControlSize;
//  AFirstItemRight:TControlSize;
//begin
//  //默认值
////  ADrawStartIndex:=0;
////  ADrawEndIndex:=Self.GetVisibleItemsCount-1;
//
//  //默认不绘制
//  ADrawStartIndex:=Self.GetVisibleItemsCount;
//  ADrawEndIndex:=Self.GetVisibleItemsCount-1;
//
//
//  if Self.GetVisibleItemsCount>0 then
//  begin
//    case Self.FItemLayoutType of
//      iltVertical:
//      begin
//        //需要加上间隔
//        //垂直排列
//        case Self.FItemSizeCalcType of
//          isctFixed:
//          begin
//                //高度固定
//                ADrawStartIndex:=Floor(
//                                    ADrawTopOffset
//                                      /(Self.GetItemDefaultHeight+Self.FItemSpace)
//                                  )-1;//误差
//                ADrawEndIndex:=ADrawStartIndex
//                                +Ceil(
//                                        AControlHeight
//                                        /(GetItemDefaultHeight)
//                                        )
//                                +1;//误差
//          end;
//          isctSeparate:
//          begin
//
//
//                //需要加上间隔
//                //高度不固定
//                AFirstItemBottom:=0;
//
//                //下面应该使用查找算法做优化
//                //遍历
//                for I := 0 to Self.GetVisibleItemsCount-1 do
//                begin
//                  AItemRect:=Self.GetVisibleItem(I).ItemRect;
//
//                  if (AItemRect.Bottom>=ADrawTopOffset) and (AItemRect.Bottom<=ADrawTopOffset+AControlHeight)
//                   or (AItemRect.Top>=ADrawTopOffset) and (AItemRect.Top<=ADrawTopOffset+AControlHeight)
//                  then
//                  begin
//                    ADrawStartIndex:=I;
//                    AFirstItemBottom:=ControlSize(AItemRect.Bottom);
//                    Break;
//                  end;
//                end;
//
//
//                //wn
////                for I := ADrawStartIndex+1 to Self.GetVisibleItemsCount-1 do
//                for I := ADrawStartIndex to Self.GetVisibleItemsCount-1 do
//                begin
//                  //wn
////                  if Self.GetVisibleItem(I).ItemRect.Bottom>=AFirstItemBottom+AControlHeight then
//                  if Self.GetVisibleItem(I).ItemRect.Bottom>=ADrawTopOffset+AControlHeight then
//                  begin
//                    //wn
////                    ADrawEndIndex:=I+1;
//                    ADrawEndIndex:=I;
//                    Break;
//                  end;
//                end;
//
//
//
//
//          end;
//        end;
//
//      end;
//      iltHorizontal:
//      begin
//        //水平排列
//        case Self.FItemSizeCalcType of
//          isctFixed:
//          begin
//                //需要加上间隔
//                //宽度固定
//                ADrawStartIndex:=Floor(
//                            ADrawLeftOffset
//                              /(Self.GetItemDefaultWidth+FItemSpace)
//                              )-1;
//                ADrawEndIndex:=ADrawStartIndex
//                            +Ceil(
//                            AControlWidth
//                              /(GetItemDefaultWidth+FItemSpace)
//                              )+1;
//          end;
//          isctSeparate:
//          begin
//                //需要加上间隔
//                //宽度不固定
//                AFirstItemRight:=0;
//
//
//                //下面应该使用查找算法做优化
//                //遍历
//                for I := 0 to Self.GetVisibleItemsCount-1 do
//                begin
//                  AItemRect:=Self.GetVisibleItem(I).ItemRect;
//                  //wn
////                  if (Self.GetVisibleItem(I).ItemRect.Right>=ADrawLeftOffset)
//                  //在控件之间
//                  if (AItemRect.Right>=ADrawLeftOffset) and (AItemRect.Right<=ADrawLeftOffset+AControlWidth)
//                    or (AItemRect.Left>=ADrawLeftOffset) and (AItemRect.Left<=ADrawLeftOffset+AControlWidth) then
//                  begin
//                    ADrawStartIndex:=I;
//                    AFirstItemRight:=ControlSize(AItemRect.Right);
//                    Break;
//                  end;
//                end;
//
//
//                //wn
////                for I := ADrawStartIndex+1 to Self.GetVisibleItemsCount-1 do
//                for I := ADrawStartIndex to Self.GetVisibleItemsCount-1 do
//                begin
//                  //为什么是AFirstItemRight?
//                  //wn
////                  if Self.GetVisibleItem(I).ItemRect.Right>=AFirstItemRight+AControlWidth then
//                  if Self.GetVisibleItem(I).ItemRect.Right>=ADrawLeftOffset+AControlWidth then
//                  begin
//                    //wn
////                    ADrawEndIndex:=I+1;
//                    ADrawEndIndex:=I;
//                    Break;
//                  end;
//                end;
//
//          end;
//        end;
//
//      end;
//    end;
//
//
//    if (ADrawStartIndex<0) then
//    begin
//      ADrawStartIndex:=0;
//    end;
//
//   if (ADrawEndIndex>Self.GetVisibleItemsCount-1) then
//    begin
//      ADrawEndIndex:=Self.GetVisibleItemsCount-1;
//    end;
//
//
////    if (Self.GetVisibleItemsCount>0) and (ADrawStartIndex>Self.GetVisibleItemsCount-1) then
////    begin
////      ADrawStartIndex:=Self.GetVisibleItemsCount-1;
////    end;
////
////    if (Self.FSkinListIntf.Count>0) and (ADrawEndIndex>Self.GetVisibleItemsCount-1) then
////    begin
////      ADrawEndIndex:=Self.GetVisibleItemsCount-1;
////    end;
//  end;
//end;

end.


