//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     列表布局
///   </para>
///   <para>
///     ??
///   </para>
/// </summary>
unit uSkinListLayouts;

interface
{$I FrameWork.inc}
{$I Version.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  Math,
  {$IFDEF VCL}
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Controls,
  FMX.Types,
  UITypes,
  {$ENDIF}

  uBaseList,
  uSkinPicture,
  uDrawPicture,
  uDrawParam,
  uBinaryTreeDoc,
  uDrawEngine,
  uUrlPicture,
  uGraphicCommon,
  uSkinBufferBitmap,
  uSkinImageList,
  uBaseLog;



const
  IID_ISkinItem:TGUID='{FC88E99E-C733-4094-91FE-F61CADBB5B99}';
  IID_ISkinList:TGUID='{7E756205-368A-4241-A387-CD99BF9DBDBB}';


type
  ISkinList=interface;

  TSkinListLayoutsManager=class;
  TSkinListLayoutsManagerClass=class of TSkinListLayoutsManager;











  /// <summary>
  ///   <para>
  ///     项目排列接口
  ///   </para>
  ///   <para>
  ///     Item Layout interface
  ///   </para>
  /// </summary>
  ISkinItem=interface
    ['{FC88E99E-C733-4094-91FE-F61CADBB5B99}']

    /// <summary>
    ///   <para>
    ///     宽度
    ///   </para>
    ///   <para>
    ///     Width
    ///   </para>
    /// </summary>
    function GetWidth:Double;
    //层级
    function GetLevel:Integer;

    /// <summary>
    ///   <para>
    ///     高度
    ///   </para>
    ///   <para>
    ///     Height
    ///   </para>
    /// </summary>
    function GetHeight:Double;

    /// <summary>
    ///   <para>
    ///     是否显示
    ///   </para>
    ///   <para>
    ///     Is visible
    ///   </para>
    /// </summary>
    function GetVisible:Boolean;

    /// <summary>
    ///   <para>
    ///     是否选中
    ///   </para>
    ///   <para>
    ///     Whether select
    ///   </para>
    /// </summary>
    function GetSelected:Boolean;

    /// <summary>
    ///   <para>
    ///     获取引用
    ///   </para>
    ///   <para>
    ///     Get refrence
    ///   </para>
    /// </summary>
    function GetObject:TObject;




    //设置所属的列表(用于更改Width,Height等其他属性的时候调用OnChange事件)
    procedure SetSkinListIntf(ASkinListIntf:ISkinList);
//    function GetListLayoutsManager:TSkinListLayoutsManager;




    /// <summary>
    ///   <para>
    ///     清空位置矩形
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure ClearItemRect;


    /// <summary>
    ///   <para>
    ///     获取位置矩形
    ///   </para>
    ///   <para>
    ///     Get position rectangle
    ///   </para>
    /// </summary>
    function GetItemRect:TRectF;

    function GetIsRowEnd:Boolean;
    //因为列表项有间隔，所以在计算宽度的时候，要计算这行有几个Item，有几个Item就有几个间隔，就可以根据百分比算出来剩下那个Item的宽度，以便排成一行，
    //不然最后一个Item会排到下一行去
    function GetThisRowItemCount:Integer;

    /// <summary>
    ///   <para>
    ///     设置位置矩形
    ///   </para>
    ///   <para>
    ///     Set position rectangle
    ///   </para>
    /// </summary>
    procedure SetItemRect(Value:TRectF);



    /// <summary>
    ///   <para>
    ///     获取绘制矩形
    ///   </para>
    ///   <para>
    ///     Get draw rectangle
    ///   </para>
    /// </summary>
    function GetItemDrawRect:TRectF;

    /// <summary>
    ///   <para>
    ///     设置绘制矩形
    ///   </para>
    ///   <para>
    ///     Set draw rectangle
    ///   </para>
    /// </summary>
    procedure SetItemDrawRect(Value:TRectF);


    //鼠标是否在Item里面
    function PtInItem(APoint:TPointF):Boolean;

    /// <summary>
    ///   <para>
    ///     是否显示
    ///   </para>
    ///   <para>
    ///     Whether display
    ///   </para>
    /// </summary>
    property Visible:Boolean read GetVisible;
    /// <summary>
    ///   <para>
    ///     高度
    ///   </para>
    ///   <para>
    ///     Height
    ///   </para>
    /// </summary>
    property Height:Double read GetHeight;
    /// <summary>
    ///   <para>
    ///     宽度
    ///   </para>
    ///   <para>
    ///     Width
    ///   </para>
    /// </summary>
    property Width:Double read GetWidth;
    /// <summary>
    ///   <para>
    ///     是否选中
    ///   </para>
    ///   <para>
    ///     Whether select
    ///   </para>
    /// </summary>
    property Selected:Boolean read GetSelected;



    /// <summary>
    ///   <para>
    ///     列表项位置矩形(绝对位置)
    ///   </para>
    ///   <para>
    ///     ListItem rectangle
    ///   </para>
    /// </summary>
    property ItemRect:TRectF read GetItemRect write SetItemRect;
    /// <summary>
    ///   <para>
    ///     列表项绘制矩形(加上滚动条的偏移)
    ///   </para>
    ///   <para>
    ///     draw rectangle of ListItem
    ///   </para>
    /// </summary>
    property ItemDrawRect:TRectF read GetItemDrawRect write SetItemDrawRect;

  end;











  /// <summary>
  ///   <para>
  ///     列表接口(仅用于存储列表项)
  ///   </para>
  ///   <para>
  ///     ItemList array interface
  ///   </para>
  /// </summary>
  ISkinList=interface
    ['{7E756205-368A-4241-A387-CD99BF9DBDBB}']

    /// <summary>
    ///   <para>
    ///     获取更新计数(避免不必要的频繁刷新界面)
    ///   </para>
    ///   <para>
    ///     Get update count
    ///   </para>
    /// </summary>
    function GetUpdateCount:Integer;

    /// <summary>
    ///   <para>
    ///     获取某一项
    ///   </para>
    ///   <para>
    ///     Get one item
    ///   </para>
    /// </summary>
    function GetSkinItem(const Index:Integer):ISkinItem;
    function GetSkinObject(const Index:Integer):TObject;

    /// <summary>
    ///   <para>
    ///     获取个数
    ///   </para>
    ///   <para>
    ///     Get count
    ///   </para>
    /// </summary>
    function GetCount:Integer;

    /// <summary>
    ///   <para>
    ///     获取下标
    ///   </para>
    ///   <para>
    ///     Get index
    ///   </para>
    /// </summary>
    function IndexOf(AObject:TObject):Integer;
    //获取实列
    function GetObject:TObject;

    /// <summary>
    ///   <para>
    ///     设置排列布局管理者
    ///   </para>
    ///   <para>
    ///     Set layout
    ///   </para>
    /// </summary>
    procedure SetListLayoutsManager(ALayoutsManager:TSkinListLayoutsManager);
    /// <summary>
    ///   <para>
    ///     获取排列布局管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetListLayoutsManager:TSkinListLayoutsManager;


    /// <summary>
    ///   <para>
    ///     获取个数
    ///   </para>
    ///   <para>
    ///     Get count
    ///   </para>
    /// </summary>
    property Count:Integer read GetCount;
    /// <summary>
    ///   <para>
    ///     更新计数(避免频繁更新)
    ///   </para>
    ///   <para>
    ///     Update count
    ///   </para>
    /// </summary>
    property UpdateCount:Integer read GetUpdateCount;

    //调用DoItemVisibleChange
    procedure DoChange;//override;
    //调用DoItemVisibleChange
//    procedure EndUpdate(AIsForce:Boolean=False);//override;

  end;








  /// <summary>
  ///   <para>
  ///     列表的逻辑行为
  ///   </para>
  ///   <para>
  ///     ??
  ///   </para>
  /// </summary>
  TSkinListLayoutsManager=class(TPersistent)
  protected
    //所有的列表(如果切换这个列表,要清除VisibleItems)
    FSkinListIntf:ISkinList;
    procedure SetSkinListIntf(const Value: ISkinList);
  protected
    //显示的列表项
    FVisibleItems:TBaseList;
//  public
//    //固定数,一直显示在最顶部,而且在最前
//    FFixedItems:TBaseList;
  public
    //是否需要重新计算可以显示的项目(比如列表项Visible更改完)
    FIsNeedReCalcVisibleItems:Boolean;
  protected


    //内容的尺寸,计算出来的(比控件大的时候会出现滚动条)
    FContentWidth: Double;
    FContentHeight: Double;


    //保存下来,省的再计算控件的尺寸
    FCalcItemsMaxRight: Double;
    FCalcItemsMaxBottom: Double;


    //控件的尺寸
    FControlWidth: Double;
    FControlHeight: Double;
    //获取控件的尺寸(应对不断变化的控件尺寸)
    FOnGetControlWidth:TOnGetControlSizeEvent;
    FOnGetControlHeight:TOnGetControlSizeEvent;



    //列表项之间的间隔
    FItemSpace:Double;
    //列表项之间的间隔类型
    FItemSpaceType:TSkinItemSpaceType;



    //列表项的尺寸(如果是-1,表示使用控件宽度,0~1小数表示百分比)
    FItemWidth:Double;
    //列表项的尺寸(如果是-1,表示使用控件高度,0~1小数表示百分比)
    FItemHeight:Double;




    //选中状态时列表项的尺寸
    FSelectedItemHeight:Double;
    FSelectedItemWidth:Double;



    //排列方式(水平或垂直,....)
    FItemLayoutType:TItemLayoutType;



    //列表项高度宽度计算方式
    FItemSizeCalcType:TItemSizeCalcType;




    //是否需要重新计算项目矩形(比如列表项高度更改完)
    FIsNeedReCalcItemRect:Boolean;



    //通知ListBox需要刷新的事件
    FOnItemPropChange: TNotifyEvent;
    FOnItemSizeChange: TNotifyEvent;
    FOnItemVisibleChange: TNotifyEvent;


    FOnItemIconGetSkinImageList: TGetSkinImageListEvent;
    FOnItemIconGetDownloadPictureManager: TGetDownloadPictureManagerEvent;



    //设置选中的列表项
    FOnSetSelectedItem: TNotifyEvent;
    FOnItemExpandedChange: TNotifyEvent;






    //设置列表项高度
    procedure SetItemHeight(const Value: Double);
    //设置列表项宽度
    procedure SetItemWidth(const Value: Double);

    //设置列表项间隔
    procedure SetItemSpace(const Value: Double);
    procedure SetItemSpaceType(const Value: TSkinItemSpaceType);

    procedure SetSelectedItemHeight(const Value: Double);
    procedure SetSelectedItemWidth(const Value: Double);



    //列表项尺寸计算类型
    procedure SetItemSizeCalcType(const Value: TItemSizeCalcType);


    //列表项排列方向(水平或垂直)
    procedure SetItemLayoutType(const Value: TItemLayoutType);

    procedure SetControlLeftOffset(const Value: Double);
    procedure SetControlTopOffset(const Value: Double);
  public
    //
    /// <summary>
    ///   <para>
    ///     获取中间列表项的矩形(用于中间选择功能)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetCenterItemRect:TRectF;




    /// <summary>
    ///   <para>
    ///     列表项属性更改事件,只需要重绘,AIsNeedCheck,是否需要检查,如果为False,那么就直接调用相关的On****Change事件
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoItemPropChange(Sender:TObject;AIsNeedCheck:Boolean=False);virtual;

    /// <summary>
    ///   <para>
    ///     列表项尺寸更改事件,需要重新计算列表的内容尺寸和绘制矩形
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoItemSizeChange(Sender:TObject;AIsNeedCheck:Boolean=False);virtual;
    //
    /// <summary>
    ///   <para>
    ///     列表项可见属性更改事件,需要重新计算可见列表
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoItemVisibleChange(Sender:TObject;
                                  //如果为True,表示需要检查FIsNeedReCalcVisibleItems为True才重新计算
                                  AIsNeedCheck_IsNeedReCalcVisibleItems:Boolean=False);virtual;


    /// <summary>
    ///   <para>
    ///     调用列表项选中事件(传递选中的Item给ListBox.SelectedItem)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoItemSelected(AItem:TObject);
    procedure DoItemExpandedChange(AItem:TObject);




    /// <summary>
    ///   <para>
    ///     列表项用它来获取图标列表,调用FOnItemIconGetSkinImageList
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoGetItemIconDefaultSkinImageList(Sender:TObject;var ASkinImageList:TSkinBaseImageList);virtual;

    /// <summary>
    ///   <para>
    ///     列表项用它来获取图标下载管理者,调用FOnItemIconGetDownloadPictureManager
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoGetItemIconDefaultDownloadPictureManager(Sender:TObject;var ADownloadPictureManager:TBaseDownloadPictureManager);virtual;






    /// <summary>
    ///   <para>
    ///     获取列表项的默认宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetItemDefaultWidth:Double;virtual;
    function GetSelectedItemDefaultWidth:Double;virtual;
    //
    /// <summary>
    ///   <para>
    ///     获取列表项的默认高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetItemDefaultHeight:Double;virtual;
    function GetSelectedItemDefaultHeight:Double;virtual;



    /// <summary>
    ///   <para>
    ///     计算列表项的宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemWidth(AItem:ISkinItem):Double;virtual;

    /// <summary>
    ///   <para>
    ///     计算列表项的高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemHeight(AItem:ISkinItem):Double;virtual;


    /// <summary>
    ///   <para>
    ///     计算垂直模式下的列表项的左偏移(用于TreeView)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemLevelLeftOffsetAtVerticalLayout(AItem:ISkinItem):Double;virtual;



    /// <summary>
    ///   <para>
    ///     计算出最大的列表项宽度(用于垂直模式下计算内容的宽度,更新滚动条)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemsMaxRight:Double;

    /// <summary>
    ///   <para>
    ///     计算出最大的列表项高度(用于水平模式下计算内容的高度,更新滚动条)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemsMaxBottom:Double;






    /// <summary>
    ///   <para>
    ///     计算内容宽度(用于处理滚动条的Max)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcContentWidth:Double;virtual;
    /// <summary>
    ///   <para>
    ///     计算内容高度(用于处理滚动条的Max)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcContentHeight:Double;virtual;




    /// <summary>
    ///   <para>
    ///     根据绘制偏移,计算绘制的起始和结束下标
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure CalcDrawStartAndEndIndex(
                                      //滚动条位置
                                      ADrawLeftOffset,
                                      ADrawTopOffset//,
//                                      ADrawRightOffset,
//                                      ADrawBottomOffset
                                      :Double;
                                      //控件的尺寸,可以自定义
                                      AControlWidth,AControlHeight:Double;
                                      var ADrawStartIndex:Integer;
                                      var ADrawEndIndex:Integer);virtual;
//    //获取指定宽度内的列表项起始下标
//    procedure CalcStartAndEndIndex(AControlWidth:TControlSize;
//                                      var AStartIndex:Integer;
//                                      var AEndIndex:Integer);virtual;



    /// <summary>
    ///   <para>
    ///     计算可见的列表项列表
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure CalcVisibleItems;virtual;
    /// <summary>
    ///   <para>
    ///     获取指定列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetVisibleItem(const Index:Integer):ISkinItem;virtual;
    /// <summary>
    ///   <para>
    ///     获取可见的列表项个数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetVisibleItemsCount:Integer;virtual;
    /// <summary>
    ///   <para>
    ///     获取指定可见的列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetVisibleItemObject(const Index:Integer):TObject;virtual;
    /// <summary>
    ///   <para>
    ///     获取指定列表项的下标,主要用于判断是否存在,或判断是否可见
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetVisibleItemObjectIndex(AObject:TObject):Integer;virtual;



    /// <summary>
    ///   <para>
    ///     计算所有列表项的区域矩形
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoCalcAllSkinListItemRect(ASkinItems:TBaseList);virtual;
    /// <summary>
    ///   <para>
    ///     计算所有列表项的区域矩形
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure CalcAllSkinListItemRect;



    /// <summary>
    ///   <para>
    ///     获取列表项所在的区域
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function VisibleItemRectByIndex(AVisibleItemIndex:Integer): TRectF;virtual;
    /// <summary>
    ///   <para>
    ///     获取列表项所在的区域
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function VisibleItemRectByItem(AVisibleItem:ISkinItem): TRectF;

  public


    //鼠标按下的列表项
    //有时候鼠标点击在ItemDesignerPanel的子控件上,
    //那么MouseDownItem为nil,不然列表项会有点击效果
    FMouseDownItem:ISkinItem;
    FInteractiveMouseDownItem:ISkinItem;

    //延迟调用ClickItem事件中使用
    FLastMouseDownItem:ISkinItem;
    FLastMouseDownX:Double;
    FLastMouseDownY:Double;
    //鼠标按下的列表项
    //即使鼠标点击在ItemDesignerPanel的子控件上,
    //MouseDownItem为nil,InnerMouseDownItem指向鼠标所在行
    FInnerMouseDownItem:ISkinItem;


    //鼠标停靠的列表项
    FMouseOverItem:ISkinItem;

    //选中的列表项
    FSelectedItem:ISkinItem;

    //处理Item的状态
    function ProcessItemDrawEffectStates(AItem:ISkinItem):TDPEffectStates;virtual;

    //设置选中的列表项
    procedure DoSetSelectedItem(Value: ISkinItem);virtual;

    procedure SetMouseDownItem(Value: ISkinItem);
    procedure SetMouseOverItem(Value: ISkinItem);
    procedure SetSelectedItem(Value: ISkinItem);
//    procedure SetCenterItem(Value: ISkinItem);
//    procedure SetPanDragItem(Value: ISkinItem);


    function VisibleItemIndexAt(X, Y: Double):Integer;overload;
//    function VisibleItemAt(X, Y: Double):ISkinItem;overload;
    function VisibleItemAt(X, Y: Double):ISkinItem;overload;
    function VisibleItemDrawRect(AVisibleItem:ISkinItem): TRectF;

    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);virtual;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);virtual;
    procedure CustomMouseMove(Shift: TShiftState;X,Y:Double);virtual;
    procedure CustomMouseEnter;virtual;
    procedure CustomMouseLeave;virtual;

    /// <summary>
    ///   <para>
    ///     获取当前交互的项
    ///   </para>
    ///   <para>
    ///     Get interactive Item
    ///   </para>
    /// </summary>
//    property InteractiveItem:ISkinItem read GetInteractiveItem;

    /// <summary>
    ///   <para>
    ///     选中的列表项
    ///   </para>
    ///   <para>
    ///     Selected ListItem
    ///   </para>
    /// </summary>
    property SelectedItem:ISkinItem read FSelectedItem write SetSelectedItem;

    /// <summary>
    ///   <para>
    ///     鼠标按下的列表项
    ///   </para>
    ///   <para>
    ///     Pressed ListItem
    ///   </para>
    /// </summary>
    property MouseDownItem:ISkinItem read FMouseDownItem write SetMouseDownItem;
    property InnerMouseDownItem:ISkinItem read FInnerMouseDownItem write FInnerMouseDownItem;

    /// <summary>
    ///   <para>
    ///     居中的列表项
    ///   </para>
    ///   <para>
    ///     Centered ListItem
    ///   </para>
    /// </summary>
//    property CenterItem:ISkinItem read GetCenterItem write SetCenterItem;

    /// <summary>
    ///   <para>
    ///     停靠的列表项
    ///   </para>
    ///   <para>
    ///     Hovered :ListItem
    ///   </para>
    /// </summary>
    property MouseOverItem:ISkinItem read FMouseOverItem write SetMouseOverItem;
  public
    constructor Create(ASkinList:ISkinList);virtual;
    destructor Destroy;override;
  public
    FControlLeftOffset:Double;
    FControlTopOffset:Double;


    function GetControlHeight: Double;
    function GetControlWidth: Double;

    /// <summary>
    ///   <para>
    ///     内容的宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ContentWidth:Double read FContentWidth;
    /// <summary>
    ///   <para>
    ///     内容的高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ContentHeight:Double read FContentHeight;




    /// <summary>
    ///   <para>
    ///     列表接口
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property SkinListIntf:ISkinList read FSkinListIntf write SetSkinListIntf;





    /// <summary>
    ///   <para>
    ///     列表项宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemWidth:Double read FItemWidth write SetItemWidth;

    /// <summary>
    ///   <para>
    ///     列表项高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemHeight:Double read FItemHeight write SetItemHeight;


    /// <summary>
    ///   <para>
    ///     列表项间隔
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSpace:Double read FItemSpace write SetItemSpace;
    /// <summary>
    ///   <para>
    ///     列表项间隔类型
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSpaceType:TSkinItemSpaceType read FItemSpaceType write SetItemSpaceType;

    /// <summary>
    ///   <para>
    ///     静态的设置列表项宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property StaticItemWidth:Double read FItemWidth write FItemWidth;
    /// <summary>
    ///   <para>
    ///     静态的设置列表项高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property StaticItemHeight:Double read FItemHeight write FItemHeight;



    /// <summary>
    ///   <para>
    ///     选中状态的列表项高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property SelectedItemHeight:Double read FSelectedItemHeight write SetSelectedItemHeight;
    /// <summary>
    ///   <para>
    ///     选中状态的列表项宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property SelectedItemWidth:Double read FSelectedItemWidth write SetSelectedItemWidth;


    property ControlLeftOffset:Double read FControlLeftOffset write SetControlLeftOffset;
    property ControlTopOffset:Double read FControlTopOffset write SetControlTopOffset;


    /// <summary>
    ///   <para>
    ///     控件的宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ControlWidth:Double read GetControlWidth write FControlWidth;
    /// <summary>
    ///   <para>
    ///     控件的高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ControlHeight:Double read GetControlHeight write FControlHeight;




    /// <summary>
    ///   <para>
    ///     列表项的排列方向
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemLayoutType:TItemLayoutType read FItemLayoutType write SetItemLayoutType;
    /// <summary>
    ///   <para>
    ///     静态的设置列表项的排列方向
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property StaticItemLayoutType:TItemLayoutType read FItemLayoutType write FItemLayoutType;






    /// <summary>
    ///   <para>
    ///     列表项尺寸计算方式,固定的还是狡立的
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSizeCalcType:TItemSizeCalcType read FItemSizeCalcType write SetItemSizeCalcType;
    /// <summary>
    ///   <para>
    ///     静态的设置列表项尺寸计算方式
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property StaticItemSizeCalcType:TItemSizeCalcType read FItemSizeCalcType write FItemSizeCalcType;






    /// <summary>
    ///   <para>
    ///     选中列表项的通知事件,通知ListBox某个Item被选中了
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnSetSelectedItem:TNotifyEvent read FOnSetSelectedItem write FOnSetSelectedItem;
    property OnItemExpandedChange:TNotifyEvent read FOnItemExpandedChange write FOnItemExpandedChange;



    /// <summary>
    ///   <para>
    ///     获取控件的尺寸
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnGetControlWidth:TOnGetControlSizeEvent read FOnGetControlWidth write FOnGetControlWidth;
    /// <summary>
    ///   <para>
    ///     获取控件的尺寸
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnGetControlHeight:TOnGetControlSizeEvent read FOnGetControlHeight write FOnGetControlHeight;




    /// <summary>
    ///   <para>
    ///     列表项属性更改事件,用于通知ListBox刷新
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnItemPropChange:TNotifyEvent read FOnItemPropChange write FOnItemPropChange;
    /// <summary>
    ///   <para>
    ///     列表项尺寸更改事件,用于通知ListBox刷新
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnItemSizeChange:TNotifyEvent read FOnItemSizeChange write FOnItemSizeChange;
    /// <summary>
    ///   <para>
    ///     列表项可见性更改事件,用于通知ListBox刷新
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnItemVisibleChange:TNotifyEvent read FOnItemVisibleChange write FOnItemVisibleChange;



    /// <summary>
    ///   <para>
    ///     获取图标列表的事件,将ListBox设置的SkinImageList赋给Item
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnGetItemIconSkinImageList:TGetSkinImageListEvent read FOnItemIconGetSkinImageList write FOnItemIconGetSkinImageList;
    /// <summary>
    ///   <para>
    ///     获取图片下载管理者的事件,Item使用哪个DownloadPictureManager来下载
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property OnGetItemIconDownloadPictureManager:TGetDownloadPictureManagerEvent read FOnItemIconGetDownloadPictureManager write FOnItemIconGetDownloadPictureManager;

  end;








implementation


{$IFDEF OPENSOURCE_VERSION}
{$ELSE}
//  {$IFDEF OPENSOURCE_VERSION}
//  {$ELSE}
//uses
//  uSkinListViewType;
//  {$ENDIF}
{$ENDIF}



{ TSkinListLayoutsManager }

constructor TSkinListLayoutsManager.Create(ASkinList:ISkinList);
begin
  FVisibleItems:=TBaseList.Create(ooReference);

//  FFixedItems:=TBaseList.Create(ooReference);


  FSkinListIntf:=ASkinList;
  if (FSkinListIntf<>nil) then
  begin
    FSkinListIntf.SetListLayoutsManager(Self);
  end;



  //默认控件宽度
  FControlWidth:=100;
  FControlHeight:=100;

  FItemSpace:=0;

  FContentWidth:=-1;
  FContentHeight:=-1;

  FCalcItemsMaxRight:=0;
  FCalcItemsMaxBottom:=0;


  //默认列表项的宽度和高度
  FItemWidth:=Const_Tag_UseControlWidth;
  FItemHeight:=Const_DefaultItemHeight;



  //选中的高度和宽度
  FSelectedItemHeight:=Const_Tag_UseListItemHeight;
  FSelectedItemWidth:=Const_Tag_UseListItemWidth;




  //默认排列方式,垂直
  FItemLayoutType:=TItemLayoutType.iltVertical;


  //列表项宽度自动计算方式(默认采用固定的方式)
  FItemSizeCalcType:=TItemSizeCalcType.isctSeparate;




  FIsNeedReCalcItemRect:=True;
  FIsNeedReCalcVisibleItems:=True;

end;

procedure TSkinListLayoutsManager.CustomMouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Double);
var
  AItemDrawRect:TRectF;
//  APanDragItemDrawRect:TRectF;
//  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
//  APanDragItemDesignerPanelClipRect:TRectF;
begin
//  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown');


//  inherited;


//  //去掉子控件传递过来的鼠标消息
//  if Self.FCurrentMouseEventIsChildOwn then
//  begin
////    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown IsChildMouseEvent');
//    Exit;
//  end;


//    //启动长按列表项事件的定时器
//    Self.FHasCalledOnLongTapItem:=False;
//    Self.CreateCheckLongTapItemTimer;
//    Self.StartCheckLongTapItemTimer;
//
//
//    Self.FIsStayPressedItem:=False;
    Self.FLastMouseDownItem:=nil;
//    Self.CreateCheckStayPressedItemTimer;
//    Self.StartCheckStayPressedItemTimer;



    //获取列表项绘制矩形
    AItemDrawRect:=RectF(0,0,0,0);
    if Self.FMouseOverItem<>nil then
    begin
        AItemDrawRect:=Self.VisibleItemDrawRect(Self.FMouseOverItem);
//        //平拖过了,则获取平拖列表项的绘制矩形(加下平拖之后的偏移)
//        if Self.IsStartedItemPanDrag
//          and (Self.FMouseOverItem=Self.FPanDragItem) then
//        begin
//          AItemDrawRect:=Self.GetPanDragItemDrawRect;
//        end;
    end;





    //设置鼠标点击的内部的列表项
    //用于鼠标弹起的时候,调用该Item.FDrawItemDesignerPanel的弹起事件
    //避免点击了ItemDesignerPanel中的子控件,而不知道点击的是哪个列表项
    if PtInRect(AItemDrawRect,PointF(X,Y)) then
    begin
        Self.FInnerMouseDownItem:=Self.VisibleItemAt(X,Y);
        Self.FInteractiveMouseDownItem:=
              Self.FInnerMouseDownItem;


//        if Self.FInnerMouseDownItem<>
//          Self.FEditingItem then
//        begin
//          //点击的列表项切换过了,结束编辑
//          Self.StopEditingItem;
//        end
    end;




//    //处理列表项的鼠标点击事件
//    //判断鼠标点击事件是否被列表项的ItemDesignerPanel处理了
//    if DoProcessItemCustomMouseDown(Self.FMouseOverItem,
//                                    AItemDrawRect,Button,Shift,X,Y) then
//    begin
//      //点击到HitTest为True的子控件
//      Self.Invalidate;
//      Exit;
//    end
//    else
//    begin
//      //如果事件没有被处理,那么传递给Item,也就是点击列表项
//    end;






    //如果鼠标没有点击到ItemDesignerPanel上面的子控件
    //那么设置鼠标点击的列表项
    Self.MouseDownItem:=
        Self.InnerMouseDownItem;



//    //平拖列表项的事件
//    //如果开始了列表项平拖,获取平拖列表项的鼠标按下事件,并且鼠标在平拖列表设计面板上
//    if Self.IsStartedItemPanDrag then
//    begin
//        APanDragItemDrawRect:=Self.VisibleItemDrawRect(Self.FPanDragItem);
//        APanDragItemDesignerPanelClipRect:=Self.GetPanDragItemDesignerPanelDrawRect;
//
//        if PtInRect(APanDragItemDrawRect,PointF(X,Y)) then
//        begin
//
//            Self.FItemPanDragGestureManager.MouseDown(Button,Shift,X,Y);
//
//
//            if PtInRect(APanDragItemDesignerPanelClipRect,PointF(X,Y)) then
//            begin
//              APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FItemPanDragDesignerPanel);
//              //初始事件没有被处理
//              APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;
//              //处理鼠标按下消息
//              APanDragItemDrawItemDesignerPanel.SkinControlType
//                              .DirectUIMouseDown(Self.FSkinControl,Button,Shift,X-APanDragItemDesignerPanelClipRect.Left,Y-APanDragItemDesignerPanelClipRect.Top);
//              if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
//              begin
//                Self.Invalidate;
//                //消息被平拖列表项的控件处理过了
//                Exit;
//              end
//              else
//              begin
//                //如果事件没有被处理,那么传递给Item,也就是点击列表项
//              end;
//            end;
//
//
//        end
//        else
//        begin
//          //在别的地方平拖
//          //停止平拖
//          Self.StopItemPanDrag;
//        end;
//
//
//    end
//    else
//    begin
//
//        //尚没有启动平拖
//        if Self.CanEnableItemPanDrag
//          and (Self.FMouseDownItem<>nil) then
//        begin
//          Self.FItemPanDragGestureManager.MouseDown(Button,Shift,X,Y);
//        end;
//
//
//    end;


end;

procedure TSkinListLayoutsManager.CustomMouseEnter;
begin

end;

procedure TSkinListLayoutsManager.CustomMouseLeave;
begin

//  Self.FItemPanDragGestureManager.MouseLeave;
//
//  //如果开始项目平拖了
//  if Self.IsStartedItemPanDrag then
//  begin
//    TSkinItemDesignerPanel(Self.FItemPanDragDesignerPanel).SkinControlType.DirectUIMouseLeave;
//  end;
//
//  DoProcessItemCustomMouseLeave(Self.MouseOverItem);

  Self.MouseOverItem:=nil;


end;

procedure TSkinListLayoutsManager.CustomMouseMove(Shift: TShiftState; X,
  Y: Double);
var
  AItemDrawRect:TRectF;
//  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
//  APanDragItemDesignerPanelClipRect:TRectF;
begin
//  inherited;

//
//  //去掉子控件传递过来的鼠标消息
//  if Self.FCurrentMouseEventIsChildOwn then
//  begin
////    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseMove IsChildMouseEvent');
//    Exit;
//  end;



//  //在一段时间内鼠标超出一段距离
//  //就表示不是鼠标点击事件
//  //需要停止长按的定时器
//  if (Self.FMouseDownItem<>nil)
//    and (GetDis(PointF(X,Y),FMouseDownPt)>8) then
//  begin
//    Self.StopCheckLongTapItemTimer;
//    Self.StopCheckStayPressedItemTimer;
//  end;




//
//  //在这里也要判断是否需要平拖列表项,因为移动平台上有可能MouseMove消息比MousrDown消息早
//  if
//    Self.CanEnableItemPanDrag
//    and not Self.FIsStopingItemPanDrag
//   then
//  begin
//    Self.FItemPanDragGestureManager.MouseMove(Shift,X,Y);
//  end;






  //原ItemDesignerPanel处理鼠标离开效果
  Self.MouseOverItem:=Self.VisibleItemAt(X,Y);





//  //获取平拖列表项的鼠标移动事件
//  if Self.IsStartedItemPanDrag then
//  begin
//      APanDragItemDesignerPanelClipRect:=Self.GetPanDragItemDesignerPanelDrawRect;
//      APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FItemPanDragDesignerPanel);
//
//      //初始事件没有被处理
//      APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;
//      //处理鼠标按下消息
//      APanDragItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseMove(Self.FSkinControl,Shift,X-APanDragItemDesignerPanelClipRect.Left,Y-APanDragItemDesignerPanelClipRect.Top);
//      if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
//      begin
//        Exit;
//      end;
//  end;
//
//
//
//  //现ItemDesignerPanel处理鼠标移动效果
//  Self.DoProcessItemCustomMouseMove(Self.FMouseOverItem,
//                  Shift,X,Y);




end;

procedure TSkinListLayoutsManager.CustomMouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Double);
var
  AItem:ISkinItem;
//  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
//  APanDragItemDesignerPanelClipRect:TRectF;
//
//  AIsDoProcessItemCustomMouseUp:Boolean;
begin
//  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp');

//  inherited;

//  //去掉子控件传递过来的鼠标消息
//  if Self.FCurrentMouseEventIsChildOwn then
//  begin
////    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown IsChildMouseEvent');
//    Exit;
//  end;
//
//
//      //停止检测长按列表项事件
//      Self.StopCheckLongTapItemTimer;
//      Self.StopCheckStayPressedItemTimer;
//
//
//
//      //平拖列表项处理
//      if Self.CanEnableItemPanDrag
//        and Not Self.FIsStopingItemPanDrag then
//      begin
//        Self.FItemPanDragGestureManager.MouseUp(Button,Shift,X,Y);
//      end;




//      //获取平拖列表项的鼠标弹起事件
//      if Self.IsStartedItemPanDrag then
//      begin
//          APanDragItemDesignerPanelClipRect:=Self.GetPanDragItemDesignerPanelDrawRect;
//          APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FItemPanDragDesignerPanel);
//          //初始事件没有被处理
//          APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;
//
//          //处理鼠标按下消息
//          APanDragItemDrawItemDesignerPanel.SkinControlType
//                          .DirectUIMouseUp(Self.FSkinControl,Button,
//                                Shift,
//                                X-APanDragItemDesignerPanelClipRect.Left,
//                                Y-APanDragItemDesignerPanelClipRect.Top,
//                                True);
//          if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
//          begin
//            Invalidate;
//
//            Exit;
//          end;
//
//      end;



//      //处理列表项的鼠标消息
//      //判断鼠标消息是否被列表项的DrawItemDesignerPanel上面的子控件处理
//      AIsDoProcessItemCustomMouseUp:=DoProcessItemCustomMouseUp(
//                                Self.FInnerMouseDownItem,
//                                Button,Shift,X,Y
//                                );



//      if
//        Not Self.FHasCalledOnLongTapItem
//        and Not AIsDoProcessItemCustomMouseUp
//        then
//      begin

          //选中列表项
          AItem:=Self.VisibleItemAt(X,Y);
          if
            (AItem = Self.FMouseDownItem)

//              and (Abs(FMouseDownAbsolutePt.X-Self.FMouseUpAbsolutePt.X)<Const_CanCallClickEventDistance)
//                and (Abs(FMouseDownAbsolutePt.Y-FMouseUpAbsolutePt.Y)<Const_CanCallClickEventDistance)
            then
              begin
//
//
//
//                  //也可以呼叫点击事件
//                  //选中列表项
////                  Self.DoClickItem(AItem,X,Y);
//
////                  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp ClickItem');
//
//
//                  //在Timer中调用DoClickItem
//                  Self.CreateCallOnClickItemTimer;
//                  Self.StartCallOnClickItemTimer;

                  //需要绘制点击效果
                  Self.FLastMouseDownItem:=AItem;
                  Self.FLastMouseDownX:=X;
                  Self.FLastMouseDownY:=Y;
              end;
//              else
//              begin
////                  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp Move Over 5Pixel,Not Click');
//
//              end;

//      end;



      Self.FMouseDownItem:=nil;
      Self.FInnerMouseDownItem:=nil;

      DoItemPropChange(Self);
//      Invalidate;



end;

destructor TSkinListLayoutsManager.Destroy;
begin

  //去除引用
  if (FSkinListIntf<>nil) then
  begin
    FSkinListIntf.SetListLayoutsManager(nil);
  end;

  FreeAndNil(FVisibleItems);
//  FreeAndNil(FFixedItems);

  Inherited;
end;

procedure TSkinListLayoutsManager.DoCalcAllSkinListItemRect(ASkinItems:TBaseList);
var
  I: Integer;
  ASkinItem:ISkinItem;
  AItemRect:TRectF;
begin
      FCalcItemsMaxBottom:=0;
      FCalcItemsMaxRight:=0;



      //预计算
      case Self.FItemLayoutType of
        iltVertical:
        begin


            //垂直排列
            AItemRect.Top:=FControlTopOffset;//0;
            AItemRect.Bottom:=0;
            case Self.FItemSpaceType of
              sistDefault:
              begin
                //每个列表项都有间隔
                AItemRect.Bottom:=AItemRect.Bottom+FItemSpace;
              end;
              sistMiddle:
              begin
                //首末无间隔
              end;
            end;


            //一个个计算
//            for I := 0 to Self.GetVisibleItemsCount-1 do
            for I := 0 to ASkinItems.Count-1 do
            begin
//              ASkinItem:=Self.GetVisibleItem(I);
//              ASkinItem:=Self.GetVisibleItem(I);
              ASkinItems[I].GetInterface(IID_ISkinItem,ASkinItem);


              //显示

              //水平层级偏移(用于TreeView)
              AItemRect.Left:=CalcItemLevelLeftOffsetAtVerticalLayout(ASkinItem);
              AItemRect.Right:=AItemRect.Left+CalcItemWidth(ASkinItem);
              AItemRect.Top:=AItemRect.Bottom;
              AItemRect.Bottom:=AItemRect.Top+CalcItemHeight(ASkinItem);

//              FMX.Types.log.d('OrangeUI '+FloatToStr(AItemRect.Top));
              ASkinItem.SetItemRect(AItemRect);



              if FCalcItemsMaxRight<AItemRect.Right then
              begin
                FCalcItemsMaxRight:=AItemRect.Right;
              end;
              if FCalcItemsMaxBottom<AItemRect.Bottom then
              begin
                FCalcItemsMaxBottom:=AItemRect.Bottom;
              end;



              AItemRect.Bottom:=AItemRect.Bottom+FItemSpace;


            end;


        end;
        iltHorizontal:
        begin


            //水平方式
            AItemRect.Top:=FControlTopOffset;//0;
            AItemRect.Left:=FControlLeftOffset;//0;
            AItemRect.Right:=FControlLeftOffset;//0;
            case Self.FItemSpaceType of
              sistDefault:
              begin
                //每个列表项都有间隔
                AItemRect.Right:=AItemRect.Right+FItemSpace;
              end;
              sistMiddle:
              begin
                //首末无间隔
              end;
            end;


            //一个个计算
//            for I := 0 to Self.GetVisibleItemsCount-1 do
            for I := 0 to ASkinItems.Count-1 do
            begin
//                ASkinItem:=Self.GetVisibleItem(I);
                ASkinItems[I].GetInterface(IID_ISkinItem,ASkinItem);

                //显示
                AItemRect.Bottom:=CalcItemHeight(ASkinItem);
                AItemRect.Left:=AItemRect.Right;
                AItemRect.Right:=AItemRect.Left+CalcItemWidth(ASkinItem);





                ASkinItem.SetItemRect(AItemRect);


                if FCalcItemsMaxRight<AItemRect.Right then
                begin
                  FCalcItemsMaxRight:=AItemRect.Right;
                end;
                if FCalcItemsMaxBottom<AItemRect.Bottom then
                begin
                  FCalcItemsMaxBottom:=AItemRect.Bottom;
                end;



                AItemRect.Right:=AItemRect.Right+FItemSpace;

            end;



        end;
      end;


end;

procedure TSkinListLayoutsManager.DoGetItemIconDefaultSkinImageList(Sender: TObject;var ASkinImageList: TSkinBaseImageList);
begin
  if Assigned(Self.FOnItemIconGetSkinImageList) then
  begin
    FOnItemIconGetSkinImageList(Sender,ASkinImageList);
  end;
end;

procedure TSkinListLayoutsManager.DoGetItemIconDefaultDownloadPictureManager(Sender: TObject;var ADownloadPictureManager: TBaseDownloadPictureManager);
begin
  if Assigned(Self.FOnItemIconGetDownloadPictureManager) then
  begin
    FOnItemIconGetDownloadPictureManager(Sender,ADownloadPictureManager);
  end;
end;

procedure TSkinListLayoutsManager.DoItemSelected(AItem: TObject);
begin
  if Assigned(FOnSetSelectedItem) then
  begin
    FOnSetSelectedItem(AItem);
  end;
end;

procedure TSkinListLayoutsManager.DoItemExpandedChange(AItem: TObject);
begin
  if Assigned(FOnItemExpandedChange) then
  begin
    FOnItemExpandedChange(AItem);
  end;
end;

procedure TSkinListLayoutsManager.DoItemSizeChange(Sender:TObject;AIsNeedCheck:Boolean);
begin
  if Not AIsNeedCheck then
  begin
    FIsNeedReCalcItemRect:=True;
  end;


  if Not AIsNeedCheck or AIsNeedCheck and FIsNeedReCalcItemRect then
  begin
    if (FSkinListIntf<>nil) and (FSkinListIntf.GetUpdateCount=0) then
    begin

      //计算所有列表项的矩形
      Self.CalcAllSkinListItemRect;

      if Assigned(Self.FOnItemSizeChange) then
      begin
        FOnItemSizeChange(Sender);
      end;

    end;
  end;
end;

procedure TSkinListLayoutsManager.DoItemPropChange(Sender:TObject;AIsNeedCheck:Boolean);
begin
  if FSkinListIntf.GetUpdateCount=0 then
  begin
    if Assigned(Self.FOnItemPropChange) then
    begin
      FOnItemPropChange(Sender);
    end;
  end;
end;

procedure TSkinListLayoutsManager.DoItemVisibleChange(Sender:TObject;AIsNeedCheck_IsNeedReCalcVisibleItems:Boolean);
begin
  if FSkinListIntf=nil then Exit;
  
  if Not AIsNeedCheck_IsNeedReCalcVisibleItems then
  begin
    FIsNeedReCalcItemRect:=True;
    FIsNeedReCalcVisibleItems:=True;
  end;

  if Not AIsNeedCheck_IsNeedReCalcVisibleItems
    or AIsNeedCheck_IsNeedReCalcVisibleItems and FIsNeedReCalcVisibleItems then
  begin
      if FSkinListIntf.GetUpdateCount=0 then
      begin
          //计算可见的列表
          Self.CalcVisibleItems;

          //计算所有列表项的显示矩形
          Self.CalcAllSkinListItemRect;

          if Assigned(Self.FOnItemVisibleChange) then
          begin
            FOnItemVisibleChange(Sender);
          end;
      end;
  end;

end;

function TSkinListLayoutsManager.GetControlHeight: Double;
begin
  Result:=FControlHeight;
  if Assigned(Self.FOnGetControlHeight) then
  begin
    Result:=FOnGetControlHeight(Self);
  end;
end;

function TSkinListLayoutsManager.GetControlWidth: Double;
begin
  Result:=FControlWidth;
  if Assigned(Self.FOnGetControlWidth) then
  begin
    Result:=FOnGetControlWidth(Self);
  end;
end;

function TSkinListLayoutsManager.GetItemDefaultHeight: Double;
begin
  Result:=FItemHeight;
  //ListBox.Prop.ItemHeight为-1,表示使用控件高度
  if IsSameDouble(FItemHeight,Const_Tag_UseControlHeight) then
  begin
    Result:=Self.GetControlHeight;
  end
  else if BiggerDouble(FItemHeight,0) and SmallerDouble(FItemHeight,1) then
  begin
    //如果ListBox.Prop.ItemHeight是0~1的小数,那么取控件高度的百分比
    Result:=FItemHeight*GetControlHeight;
  end
  else
  begin
    {$IFDEF VCL}
    Result:=ScreenScaleSizeInt(Result);
    {$ENDIF}

  end;
end;

function TSkinListLayoutsManager.GetSelectedItemDefaultHeight: Double;
begin
  Result:=FSelectedItemHeight;
  //ListBox.Prop.SelectedItemHeight为-1,表示使用控件高度
  if IsSameDouble(FSelectedItemHeight,Const_Tag_UseControlHeight) then
  begin
    Result:=Self.GetControlHeight;
  end
  else if BiggerDouble(FSelectedItemHeight,0) and SmallerDouble(FSelectedItemHeight,1) then
  begin
    //如果ListBox.Prop.SelectedItemHeight是0~1的小数,那么取控件高度的百分比
    Result:=FSelectedItemHeight*GetControlHeight;
  end
end;

function TSkinListLayoutsManager.GetItemDefaultWidth: Double;
begin
  Result:=FItemWidth;
  //ListBox.Prop.ItemWidth为-1,表示使用控件宽度
  if IsSameDouble(FItemWidth,Const_Tag_UseControlWidth) then
  begin
    Result:=Self.GetControlWidth;
  end
  else if BiggerDouble(FItemWidth,0) and SmallerDouble(FItemWidth,1) then
  begin
    //如果是ListBox.Prop.ItemWidth为~1的小数,那么取控件宽度的百分比
    Result:=FItemWidth*GetControlWidth;
  end
  else
  begin

    {$IFDEF VCL}
    Result:=ScreenScaleSizeInt(Result);
    {$ENDIF}

  end;
end;

function TSkinListLayoutsManager.GetSelectedItemDefaultWidth: Double;
begin
  Result:=FSelectedItemWidth;
  //ListBox.Prop.SelectedItemWidth为-1,表示使用控件宽度
  if IsSameDouble(FSelectedItemWidth,Const_Tag_UseControlWidth) then
  begin
    Result:=Self.GetControlWidth;
  end
  else if BiggerDouble(FSelectedItemWidth,0) and SmallerDouble(FSelectedItemWidth,1) then
  begin
    //如果是ListBox.Prop.SelectedItemWidth为~1的小数,那么取控件宽度的百分比
    Result:=FSelectedItemWidth*GetControlWidth;
  end
end;

function TSkinListLayoutsManager.GetVisibleItemObject(const Index:Integer): TObject;
begin
    Result:=FVisibleItems[Index];
end;

function TSkinListLayoutsManager.GetVisibleItem(const Index:Integer): ISkinItem;
begin
    FVisibleItems[Index].GetInterface(IID_ISkinItem,Result);
end;

function TSkinListLayoutsManager.GetVisibleItemObjectIndex(AObject: TObject): Integer;
begin
  Result:=FVisibleItems.IndexOf(AObject);
end;

function TSkinListLayoutsManager.GetVisibleItemsCount: Integer;
begin
  Result:=FVisibleItems.Count;
end;

function TSkinListLayoutsManager.ProcessItemDrawEffectStates(
  AItem: ISkinItem): TDPEffectStates;
begin
  Result:=[];

  if Self.FMouseOverItem=AItem then
  begin
    Result:=Result+[dpstMouseOver];
  end;

  if (Self.FMouseDownItem=AItem) then
  begin
      //当前按下,且移动距离不超过5个像素，触发了OnClickItem事件,需要重绘
//      if Self.FSkinCustomListIntf.Prop.FIsStayPressedItem then
//      begin
        Result:=Result+[dpstMouseDown];

//        Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;
//      end;
  end;


  //上次按下的列表项,调用了OnClickItem之后会清空
  if (Self.FLastMouseDownItem=AItem) then
  begin
    Result:=Result+[dpstMouseDown];
  end;

  //选中的效果
  if AItem.Selected then
  begin
    Result:=Result+[dpstPushed];
  end;

end;

procedure TSkinListLayoutsManager.SetControlLeftOffset(
  const Value: Double);
begin
  if FControlLeftOffset<>Value then
  begin
    FControlLeftOffset := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetControlTopOffset(
  const Value: Double);
begin
  if FControlTopOffset<>Value then
  begin
    FControlTopOffset := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetItemHeight(const Value: Double);
begin
  if (FItemHeight<>Value) then
  begin
    FItemHeight:=Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetSelectedItemHeight(const Value: Double);
begin
  if (FSelectedItemHeight<>Value) then
  begin
    FSelectedItemHeight:=Value;

    //如果有选中的列表项,那么需要重新排列
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetItemLayoutType(const Value: TItemLayoutType);
begin
  if FItemLayoutType<>Value then
  begin
    FItemLayoutType := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetItemWidth(const Value: Double);
begin
  if (FItemWidth<>Value) then
  begin
    FItemWidth:=Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetSelectedItemWidth(const Value: Double);
begin
  if (FSelectedItemWidth<>Value) then
  begin
    FSelectedItemWidth:=Value;

    //如果有选中的列表项,那么需要重新排列
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetSkinListIntf(const Value: ISkinList);
begin
  if FSkinListIntf<>Value then
  begin
    if (FSkinListIntf<>nil) then
    begin
      FSkinListIntf.SetListLayoutsManager(nil);
    end;

    FSkinListIntf := Value;

    if (FSkinListIntf<>nil) then
    begin
      FSkinListIntf.SetListLayoutsManager(Self);
    end;

    //重新计算可见列表和矩形
    Self.DoItemVisibleChange(nil);

  end;
end;

procedure TSkinListLayoutsManager.SetItemSizeCalcType(const Value: TItemSizeCalcType);
begin
  if FItemSizeCalcType<>Value then
  begin
    FItemSizeCalcType := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetItemSpace(const Value: Double);
begin
  if (FItemSpace<>Value) then
  begin
    FItemSpace:=Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetItemSpaceType(const Value: TSkinItemSpaceType);
begin
  if (FItemSpaceType<>Value) then
  begin
    FItemSpaceType:=Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.CalcAllSkinListItemRect;
var
  I: Integer;
begin
  if FIsNeedReCalcItemRect then
  begin
      FIsNeedReCalcItemRect:=False;


      //要先清空所有Item的ItemRect和ItemDrawRect
      for I := 0 to Self.FSkinListIntf.Count-1 do
      begin
        FSkinListIntf.GetSkinItem(I).ClearItemRect;
      end;


      //如果发现VisibleItems为空,那么需要重新计算VisibleItems
      Self.CalcVisibleItems;


      //计算所有列表项的矩形
      DoCalcAllSkinListItemRect(Self.FVisibleItems);

//      //计算固定项的矩形
//      DoCalcAllSkinListItemRect(Self.FFixedItems);


      //算出列表最大的宽度
      FContentWidth:=0;
      if Self.GetVisibleItemsCount>0 then
      begin
        //计算列表的总宽度
        Self.FContentWidth:=Self.CalcContentWidth;
      end;

      //算出列表最大的高度
      FContentHeight:=0;
      if Self.GetVisibleItemsCount>0 then
      begin
        //计算列表的总高度
        Self.FContentHeight:=Self.CalcContentHeight;
      end;

  end;
end;

procedure TSkinListLayoutsManager.CalcVisibleItems;
var
  I: Integer;
begin
  if FIsNeedReCalcVisibleItems then
  begin
    FIsNeedReCalcVisibleItems:=False;


    Self.FVisibleItems.Clear(False);



    //在TreeView中需要遍历的是树型,而不是单一的列表,
    //所以在TreeView中要用递归
    for I := 0 to Self.FSkinListIntf.Count-1 do
    begin
      if Self.FSkinListIntf.GetSkinItem(I).Visible
        //并且不再
         then
      begin
        Self.FVisibleItems.Add(Self.FSkinListIntf.GetSkinObject(I));
      end;
    end;


  end;
end;

function TSkinListLayoutsManager.GetCenterItemRect: TRectF;
begin
  case Self.FItemLayoutType of
    iltVertical:
    begin
      Result:=RectF(0,
                    (Self.GetControlHeight-Self.ItemHeight)/2,
                    GetControlWidth,
                    (Self.GetControlHeight-Self.ItemHeight)/2+ItemHeight
                    );
    end;
    iltHorizontal:
    begin
      Result:=RectF(
                    (Self.GetControlWidth-Self.ItemWidth)/2,
                    0,
                    (Self.GetControlWidth-Self.ItemWidth)/2+ItemWidth,
                    GetControlHeight
                    );
    end;
  end;

end;

function TSkinListLayoutsManager.CalcContentHeight: Double;
begin
  Result:=0;
  //算出列表最大的高度
//  if Self.GetVisibleItemsCount>0 then
//  begin


//    case Self.FItemLayoutType of
//      iltVertical:
//      begin
//          //最后一个Item的底边距
//          Result:=ControlSize(Self.VisibleItemRectByIndex(Self.GetVisibleItemsCount-1).Bottom);
//      end;
//      iltHorizontal:
//      begin
//          case Self.FItemSizeCalcType of
//            isctFixed:
//            begin
//              //列表项高度固定,那就直接取固定高度
//              Result:=Self.GetItemDefaultHeight;
//            end;
//            isctSeparate:
//            begin
//              //列表项高度不固定,遍历所有列表项,取列表项中高度最大一个
//              Result:=CalcItemsMaxBottom;
//            end;
//          end;
//      end;
//    end;
      Result:=FCalcItemsMaxBottom;

//  end;
end;

function TSkinListLayoutsManager.CalcContentWidth: Double;
begin
  Result:=0;
  //算出列表最大的宽度
//  if Self.GetVisibleItemsCount>0 then
//  begin


//    case Self.FItemLayoutType of
//      iltVertical:
//      begin
//          case Self.FItemSizeCalcType of
//            isctFixed:
//            begin
//                //列表项宽度固定,取固定宽度
//                Result:=Self.GetItemDefaultWidth;
//            end;
//            isctSeparate:
//            begin
//                //列表项宽度不固定,遍历所有列表项,取列表项中最大一个
//                Result:=CalcItemsMaxRight;
//            end;
//          end;
//      end;
//      iltHorizontal:
//      begin
//          //最后一个Item的右边距
//          Result:=ControlSize(Self.VisibleItemRectByIndex(Self.GetVisibleItemsCount-1).Right);
//      end;
//    end;
      Result:=FCalcItemsMaxRight;


//  end;
end;


procedure TSkinListLayoutsManager.CalcDrawStartAndEndIndex(ADrawLeftOffset,
                                                            ADrawTopOffset//,
//                                                            ADrawRightOffset,
//                                                            ADrawBottomOffset
                                                            :Double;
                                                            AControlWidth,AControlHeight:Double;
                                                            var ADrawStartIndex:Integer;
                                                            var ADrawEndIndex:Integer);
var
  I: Integer;

  AFirstItemBottom:Double;
  AFirstItemRight:Double;
var
  l,h,m :Integer;
  found :Boolean;
  ASearchCount:Integer;
  AItemRect:TRectF;
begin
  //默认值
//  ADrawStartIndex:=0;
//  ADrawEndIndex:=Self.GetVisibleItemsCount-1;

  //默认不绘制
  ADrawStartIndex:=Self.GetVisibleItemsCount;
  ADrawEndIndex:=Self.GetVisibleItemsCount-1;


  if Self.GetVisibleItemsCount>0 then
  begin
    case Self.FItemLayoutType of
      iltVertical:
      begin
            //需要加上间隔
            //垂直排列
            case Self.FItemSizeCalcType of
              isctFixed:
              begin
                    //高度固定,计算的时候直接除就行了
                    ADrawStartIndex:=Floor(
                                        ADrawTopOffset
                                          /(Self.GetItemDefaultHeight+Self.FItemSpace)
                                      )-1;//误差
                    ADrawEndIndex:=ADrawStartIndex
                                    +Ceil(
                                            AControlHeight
                                            /(GetItemDefaultHeight)
                                            )
                                    +1;//误差
              end;
              isctSeparate:
              begin


                    //需要加上间隔
                    //高度不固定
                    AFirstItemBottom:=0;


                    //下面应该使用查找算法做优化,比如当有1000个Item的时候,每个查询都要遍历1000次也是非常麻烦的
                    { TODO : 下面应该使用查找算法做优化 }
                    //遍历,顺序查找,慢的一逼
//                    for I := 0 to Self.GetVisibleItemsCount-1 do
//                    begin
//                      if (Self.GetVisibleItem(I).ItemRect.Bottom>=ADrawTopOffset) then
//                      begin
//                        ADrawStartIndex:=I;
//                        AFirstItemBottom:=ControlSize(Self.GetVisibleItem(I).ItemRect.Bottom);
//                        Break;
//                      end;
//                    end;


                    case Self.FItemSpaceType of
                      sistDefault:
                      begin
                        //每个列表项都有间隔
                        ADrawTopOffset:=ADrawTopOffset+FItemSpace;
                      end;
                      sistMiddle:
                      begin
                        //首末无间隔
                      end;
                    end;



                    //二分法查找
                    found:=False;
                    l :=0;
                    h :=Self.GetVisibleItemsCount-1;
                    ASearchCount:=0;

                    while l<=h do
                    begin
                      m := (l + h) div 2;


                      AItemRect:=Self.GetVisibleItem(m).ItemRect;
                      if (AItemRect.Top<=ADrawTopOffset)
                              and (AItemRect.Bottom>=ADrawTopOffset) then
                      begin
                        //找到第一个Item
                        //ShowMessage('found number !');
                        found :=True;
                        Inc(ASearchCount);
                        Break;
                      end
                      //if chazhao < a[m] then
                      else if AItemRect.Top>ADrawTopOffset then
                      begin
                        h :=m -1;
                        //found :=False;
                        Inc(ASearchCount);
                      end
                      //else if chazhao > a[m] then
                      else //if Self.GetVisibleItem(m).ItemRect.Bottom>AFirstItemBottom then
                      begin
                        l :=m+1 ;
                        //found :=False;
                        Inc(ASearchCount);
                      end;
//                      Application.ProcessMessages;
                    end;
//                    if not found then  ShowMessage('not found number !');
//                    if found then
//                    begin
//                      ADrawStartIndex:=m;
//                    end;
                    ADrawStartIndex:=m;
                    AFirstItemBottom:=Self.GetVisibleItem(m).ItemRect.Bottom;


                    //uBaseLog.HandleException(nil,'TSkinListLayoutsManager.CalcDrawStartAndEndIndex ASearchCount:'+IntToStr(ASearchCount));
                    
                    if ADrawStartIndex>0 then
                    begin
                      for I := ADrawStartIndex-1 downto 0 do
                      begin
                        AItemRect:=Self.GetVisibleItem(I).ItemRect;
                        if (AItemRect.Bottom>ADrawTopOffset) then
                        begin
                          ADrawStartIndex:=ADrawStartIndex-1;
                        end
                        else
                        begin
                          Break;
                        end;

                      end;
                    end;

                    
                    //wn
    //                for I := ADrawStartIndex+1 to Self.GetVisibleItemsCount-1 do
                    for I := ADrawStartIndex to Self.GetVisibleItemsCount-1 do
                    begin
                      AItemRect:=Self.GetVisibleItem(I).ItemRect;
                      if AItemRect.Bottom>=AFirstItemBottom+AControlHeight then
                      begin
                        ADrawEndIndex:=I+1;

                        //Item的Top超出了底部就不需要绘制了
                        if AItemRect.Top>AFirstItemBottom+AControlHeight then
                        begin
                          ADrawEndIndex:=I-1;
                          Break;
                        end;
                      end;
                    end;




              end;
            end;

      end;
      iltHorizontal:
      begin
            //水平排列
            case Self.FItemSizeCalcType of
              isctFixed:
              begin
                    //需要加上间隔
                    //宽度固定
                    ADrawStartIndex:=Floor(
                                ADrawLeftOffset
                                  /(Self.GetItemDefaultWidth+FItemSpace)
                                  )-1;
                    ADrawEndIndex:=ADrawStartIndex
                                +Ceil(
                                AControlWidth
                                  /(GetItemDefaultWidth+FItemSpace)
                                  )+1;
              end;
              isctSeparate:
              begin
                    //需要加上间隔
                    //宽度不固定
                    AFirstItemRight:=0;


                    //下面应该使用查找算法做优化
                    { TODO : 下面应该使用查找算法做优化 }
                    //遍历
//                    for I := 0 to Self.GetVisibleItemsCount-1 do
//                    begin
//                      //wn
//                      if (Self.GetVisibleItem(I).ItemRect.Right>=ADrawLeftOffset) then
//                      begin
//                        ADrawStartIndex:=I;
//                        AFirstItemRight:=ControlSize(Self.GetVisibleItem(I).ItemRect.Right);
//                        Break;
//                      end;
//                    end;




                    case Self.FItemSpaceType of
                      sistDefault:
                      begin
                        //每个列表项都有间隔
                        ADrawLeftOffset:=ADrawLeftOffset+FItemSpace;
                      end;
                      sistMiddle:
                      begin
                        //首末无间隔
                      end;
                    end;




                    //二分法查找
                    found:=False;
                    l :=0;
                    h :=Self.GetVisibleItemsCount-1;
                    ASearchCount:=0;

                    while l<=h do
                    begin
                      m := (l + h) div 2;


                      AItemRect:=Self.GetVisibleItem(m).ItemRect;
                      if (AItemRect.Left<=ADrawLeftOffset)
                              and (AItemRect.Right>=ADrawLeftOffset) then
                      begin
                        //找到第一个Item
                        //ShowMessage('found number !');
                        found :=True;
                        Inc(ASearchCount);
                        Break;
                      end
                      //if chazhao < a[m] then
                      else if AItemRect.Left>+ADrawLeftOffset then
                      begin
                        h :=m -1;
                        //found :=False;
                        Inc(ASearchCount);
                      end
                      //else if chazhao > a[m] then
                      else //if Self.GetVisibleItem(m).ItemRect.Right> then
                      begin
                        l :=m+1 ;
                        //found :=False;
                        Inc(ASearchCount);
                      end;
//                      Application.ProcessMessages;
                    end;
//                    if not found then  ShowMessage('not found number !');
//                    if found then
//                    begin
//                      ADrawStartIndex:=m;
//                    end;
                    ADrawStartIndex:=m;
                    AFirstItemRight:=Self.GetVisibleItem(m).ItemRect.Right;



                    //uBaseLog.HandleException(nil,'TSkinListLayoutsManager.CalcDrawStartAndEndIndex ASearchCount:'+IntToStr(ASearchCount));

                    if ADrawStartIndex>0 then
                    begin
                      for I := ADrawStartIndex-1 downto 0 do
                      begin
                        AItemRect:=Self.GetVisibleItem(I).ItemRect;
                        if (AItemRect.Right>ADrawLeftOffset) then
                        begin
                          ADrawStartIndex:=ADrawStartIndex-1;
                        end
                        else
                        begin
                          Break;
                        end;

                      end;
                    end;




                    
                    //wn
    //                for I := ADrawStartIndex+1 to Self.GetVisibleItemsCount-1 do
                    for I := ADrawStartIndex to Self.GetVisibleItemsCount-1 do
                    begin
                      AItemRect:=Self.GetVisibleItem(I).ItemRect;
                      if AItemRect.Right>=AFirstItemRight+AControlWidth then
                      begin
                        ADrawEndIndex:=I+1;

                        //Item的Top超出了底部就不需要绘制了
                        if AItemRect.Left>AFirstItemRight+AControlWidth then
                        begin
                          ADrawEndIndex:=I-1;
                          Break;
                        end;
                      end;
                    end;

              end;
            end;

      end;
    end;


    if (ADrawStartIndex<0) then
    begin
      ADrawStartIndex:=0;
    end;

   if (ADrawEndIndex>Self.GetVisibleItemsCount-1) then
    begin
      ADrawEndIndex:=Self.GetVisibleItemsCount-1;
    end;


//    if (Self.GetVisibleItemsCount>0) and (ADrawStartIndex>Self.GetVisibleItemsCount-1) then
//    begin
//      ADrawStartIndex:=Self.GetVisibleItemsCount-1;
//    end;
//
//    if (Self.FSkinListIntf.Count>0) and (ADrawEndIndex>Self.GetVisibleItemsCount-1) then
//    begin
//      ADrawEndIndex:=Self.GetVisibleItemsCount-1;
//    end;
  end;
end;

function TSkinListLayoutsManager.CalcItemHeight(AItem: ISkinItem): Double;
begin
  if
      (Self.FItemSizeCalcType=isctFixed)
      //AItem.Height为-1,表示使用默认值ListBox.Prop.ItemHeight
    or IsSameDouble(AItem.Height,Const_Tag_UseListItemHeight) then
  begin
      //设计时固定尺寸
      Result:=Self.GetItemDefaultHeight;
  end
  else if BiggerDouble(AItem.Height,0) and SmallerDouble(AItem.Height,1) then
  begin
      //如果是小数,那么取控件高度的百分比
      Result:=AItem.Height*GetControlHeight;
  end
  else
  begin
      {$IFDEF FMX}
      Result:=AItem.Height;
      {$ENDIF}
      {$IFDEF VCL}
      Result:=ScreenScaleSizeInt(AItem.Height);
      {$ENDIF}
  end;

      //选中的列表项高度
  if (Self.FItemSizeCalcType<>isctFixed)
      //选中高度设置了指定值
    and IsNotSameDouble(FSelectedItemHeight,Const_Tag_UseListItemHeight)
    and AItem.Selected then
  begin
    Result:=GetSelectedItemDefaultHeight;
  end;
end;

function TSkinListLayoutsManager.CalcItemLevelLeftOffsetAtVerticalLayout(AItem: ISkinItem): Double;
begin
  Result:=0;
end;

function TSkinListLayoutsManager.CalcItemsMaxBottom: Double;
var
  I: Integer;
begin
  Result:=0;
  //算出列表最大的高度
  if Self.GetVisibleItemsCount>0 then
  begin
    for I := 0 to GetVisibleItemsCount-1 do
    begin
      if Self.VisibleItemRectByIndex(I).Bottom>Result then
      begin
        Result:=Self.VisibleItemRectByIndex(I).Bottom;
      end;
    end;
  end;
end;

function TSkinListLayoutsManager.CalcItemsMaxRight: Double;
var
  I: Integer;
begin
  Result:=0;
  //算出列表最大的宽度
//  if Self.GetVisibleItemsCount>0 then
//  begin
    for I := 0 to GetVisibleItemsCount-1 do
    begin
      if Self.VisibleItemRectByIndex(I).Right>Result then
      begin
        Result:=Self.VisibleItemRectByIndex(I).Right;
      end;
    end;
//  end;
end;

function TSkinListLayoutsManager.CalcItemWidth(AItem: ISkinItem): Double;
var
  AThisRowItemCount:Integer;
begin
  if  //固定尺寸
      (Self.FItemSizeCalcType=isctFixed)
      //AItem.Width为-1,表示使用默认尺寸ListBox.Prop.ItemWidth
    or IsSameDouble(AItem.Width,Const_Tag_UseListItemWidth) then
  begin
      //取ListBox.Prop.ItemWidth
      Result:=GetItemDefaultWidth;
  end
  else if BiggerDouble(AItem.Width,0) and SmallerDouble(AItem.Width,1) then
  begin
      if Self.FItemSpace=0 then
      begin
        //如果是小数,那么取控件宽度的百分比,要去掉间隔的
        Result:=AItem.Width*GetControlWidth;
      end
      else
      begin
        case Self.FItemSpaceType of
          sistDefault: Result:=AItem.Width*(GetControlWidth-(AItem.GetThisRowItemCount-1+2)*FItemSpace);
          sistMiddle: Result:=AItem.Width*(GetControlWidth-(AItem.GetThisRowItemCount-1)*FItemSpace);
        end;

      end;


  end
  else
  begin
      //使用自己的尺寸
      {$IFDEF FMX}
      Result:=AItem.Width;
      {$ENDIF}
      {$IFDEF VCL}
      //要放大
      Result:=ScreenScaleSizeInt(AItem.Width);
      {$ENDIF}
  end;

      //选中的列表项宽度
  if (Self.FItemSizeCalcType<>isctFixed)
      //选中宽度设置为指定值
    and IsNotSameDouble(FSelectedItemWidth,Const_Tag_UseListItemWidth)
      //并且列表项选中
    and AItem.Selected then
  begin
    Result:=GetSelectedItemDefaultWidth;
  end;

end;

procedure TSkinListLayoutsManager.DoSetSelectedItem(Value: ISkinItem);
begin
  if FSelectedItem<>Value then
  begin

//      //如果是单选的,那么之前选中的列表项取消选择
//      if FSelectedItem<>nil then
//      begin
//  //        uBaseLog.OutputDebugString('--取消选中 ');
//          if not Self.FMultiSelect then
//          begin
//            FSelectedItem.StaticSelected:=False;
//          end;
//          FSelectedItem.DoPropChange;
//
//      end
//      else
//      begin
//  //        uBaseLog.OutputDebugString('FSelectedItem 为nil');
//      end;

      FSelectedItem := Value;

//      if FSelectedItem<>nil then
//      begin
//  //        uBaseLog.OutputDebugString('--选中 ');
//          FSelectedItem.StaticSelected:=True;
//          FSelectedItem.DoPropChange;
//
//          CallOnSelectedItemEvent(Self,FSelectedItem);
//      end;
//
//
//      //如果选中列表项的宽度和高度与正常的宽度和高度不一样,
//      //那么需要重新计算每个列表项的绘制尺寸
//      if IsNotSameDouble(Self.FListLayoutsManager.SelectedItemHeight,-1)
//        or IsNotSameDouble(Self.FListLayoutsManager.SelectedItemWidth,-1) then
//      begin
//        //重新计算尺寸
//        Self.FListLayoutsManager.DoItemSizeChange(Self);
//      end;
//
//      Invalidate;
      DoItemPropChange(Self);
  end
  else
  begin
//    uBaseLog.OutputDebugString('已经选中此Item');
  end;
end;

procedure TSkinListLayoutsManager.SetMouseDownItem(Value: ISkinItem);
begin
  if FMouseDownItem<>Value then
  begin
    FMouseDownItem := Value;
    DoItemPropChange(Self);
//    Invalidate;
  end;
end;

procedure TSkinListLayoutsManager.SetMouseOverItem(Value: ISkinItem);
begin
  if FMouseOverItem<>Value then
  begin
//    if FMouseOverItem<>nil then
//    begin
//      FMouseOverItem.IsBufferNeedChange:=True;
//    end;
//
//    DoMouseOverItemChange(Value,FMouseOverItem);

    FMouseOverItem := Value;

//    if FMouseOverItem<>nil then
//    begin
//      FMouseOverItem.IsBufferNeedChange:=True;
//    end;
//
//    Invalidate;
    DoItemPropChange(Self);
  end;
end;


procedure TSkinListLayoutsManager.SetSelectedItem(Value: ISkinItem);
begin
  if FSelectedItem<>Value then
  begin
    DoSetSelectedItem(Value);


//    //居中选择
//    if Self.FIsEnabledCenterItemSelectMode then
//    begin
//      DoSetCenterItem(Value);
//    end;
  end;
end;

//procedure TSkinListLayoutsManager.SetCenterItem(Value: ISkinItem);
//begin
//  DoSetCenterItem(Value);
//  if Self.FIsEnabledCenterItemSelectMode then
//  begin
//    DoSetSelectedItem(Value);
//  end;
//end;


function TSkinListLayoutsManager.VisibleItemAt(X, Y: Double):ISkinItem;
var
  AVisibleItemIndex:Integer;
begin
  Result:=nil;
  AVisibleItemIndex:=Self.VisibleItemIndexAt(X,Y);
  if AVisibleItemIndex<>-1 then
  begin
    Result:=Self.GetVisibleItem(AVisibleItemIndex);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinListLayoutsManager.VisibleItemDrawRect(AVisibleItem:ISkinItem): TRectF;
//var
//  AVisibleItemIndex:Integer;
begin

  Result:=Self.VisibleItemRectByItem(AVisibleItem);

//  Result.Top:=Result.Top
//              -Self.GetTopDrawOffset
//              +GetItemTopDrawOffset
//              +GetCenterItemSelectModeTopDrawOffset;
//  Result.Bottom:=Result.Bottom
//              -Self.GetBottomDrawOffset
//              +GetItemTopDrawOffset
//              +GetCenterItemSelectModeTopDrawOffset;
//  Result.Left:=Result.Left
//                -Self.GetLeftDrawOffset
//                +GetCenterItemSelectModeLeftDrawOffset;
//  Result.Right:=Result.Right
//                -Self.GetRightDrawOffset
//                +GetCenterItemSelectModeLeftDrawOffset;

  AVisibleItem.ItemDrawRect:=Result;

//  Result:=RectF(0,0,0,0);
//  AVisibleItemIndex:=Self.FListLayoutsManager.GetVisibleItemObjectIndex(AVisibleItem);
//  if AVisibleItemIndex<>-1 then
//  begin
//    Result:=VisibleItemDrawRect(AVisibleItemIndex);
//  end;

end;

function TSkinListLayoutsManager.VisibleItemIndexAt(X, Y: Double): Integer;
var
  I: Integer;
//  ADrawStartIndex,ADrawEndIndex:Integer;
begin
  Result:=-1;
//  ADrawStartIndex:=0;
//  ADrawEndIndex:=Self.GetVisibleItemsCount;
//  if Self.FListLayoutsManager.GetVisibleItemsCount>0 then
//  begin
//    Self.FListLayoutsManager.CalcDrawStartAndEndIndex(
//
//                                                      Self.GetLeftDrawOffset,
//                                                      Self.GetTopDrawOffset,
//                                          //            Self.GetRightDrawOffset,
//                                          //            Self.GetBottomDrawOffset,
//                                                      Self.FListLayoutsManager.GetControlWidth,
//                                                      Self.FListLayoutsManager.GetControlHeight,
//                                                      ADrawStartIndex,
//                                                      ADrawEndIndex
//                                                      );

    for I:=0 to Self.GetVisibleItemsCount-1 do
    begin
//      if Self.GetVisibleItem(I).PtInItem(VisibleItemDrawRect(Self.GetVisibleItem(I)),PointF(X,Y)) then
      if Self.GetVisibleItem(I).PtInItem(PointF(X,Y)) then
      begin
        Result:=I;
        Break;
      end;
    end;

//  end;


end;

//function TSkinListLayoutsManager.VisibleItemAt(X, Y: Double): ISkinItem;
//var
//  I: Integer;
//  ADrawStartIndex,ADrawEndIndex:Integer;
//begin
//  Result:=-1;
//  ADrawStartIndex:=0;
//  ADrawEndIndex:=Self.
////  if Self.FListLayoutsManager.GetVisibleItemsCount>0 then
////  begin
////    Self.FListLayoutsManager.CalcDrawStartAndEndIndex(
////
////                                                      Self.GetLeftDrawOffset,
////                                                      Self.GetTopDrawOffset,
////                                          //            Self.GetRightDrawOffset,
////                                          //            Self.GetBottomDrawOffset,
////                                                      Self.FListLayoutsManager.GetControlWidth,
////                                                      Self.FListLayoutsManager.GetControlHeight,
////                                                      ADrawStartIndex,
////                                                      ADrawEndIndex
////                                                      );
//
//    for I:=ADrawStartIndex to ADrawEndIndex do
//    begin
//      if PtInRect(VisibleItemDrawRect(TBaseSkinItem(Self.FListLayoutsManager.GetVisibleItemObject(I))),PointF(X,Y)) then
//      begin
//        Result:=I;
//        Break;
//      end;
//    end;
//
////  end;
//
//
//end;

function TSkinListLayoutsManager.VisibleItemRectByIndex(AVisibleItemIndex:Integer): TRectF;
var
  AItem:ISkinItem;
begin
  Result:=RectF(0,0,0,0);
  if (AVisibleItemIndex<0) or (AVisibleItemIndex>=Self.GetVisibleItemsCount) then
  begin
    Exit;
  end;

  AItem:=GetVisibleItem(AVisibleItemIndex);

  Result:=AItem.GetItemRect;
end;

function TSkinListLayoutsManager.VisibleItemRectByItem(AVisibleItem:ISkinItem): TRectF;
//var
//  AItemIndex:Integer;
begin
  Result:=AVisibleItem.GetItemRect;

//  Result:=RectF(0,0,0,0);
//  AItemIndex:=Self.GetVisibleItemObjectIndex(AVisibleItem.GetObject);
//  if AItemIndex<>-1 then
//  begin
//    Result:=VisibleItemRectByIndex(AItemIndex);
//  end;


//  if AVisibleItem<>nil then
//  begin
//    Result:=AVisibleItem.GetItemRect;
//  end;
end;



end.

