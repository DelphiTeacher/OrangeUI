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
  {$ENDIF}

  uBaseList,
  uSkinPicture,
  uDrawPicture,
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
    function GetWidth:TControlSize;
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
    function GetHeight:TControlSize;

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
    property Height:TControlSize read GetHeight;
    /// <summary>
    ///   <para>
    ///     宽度
    ///   </para>
    ///   <para>
    ///     Width
    ///   </para>
    /// </summary>
    property Width:TControlSize read GetWidth;
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
    FContentWidth: TControlSize;
    FContentHeight: TControlSize;


    //保存下来,省的再计算控件的尺寸
    FCalcItemsMaxRight: TControlSize;
    FCalcItemsMaxBottom: TControlSize;


    //控件的尺寸
    FControlWidth: TControlSize;
    FControlHeight: TControlSize;
    //获取控件的尺寸(应对不断变化的控件尺寸)
    FOnGetControlWidth:TOnGetControlSizeEvent;
    FOnGetControlHeight:TOnGetControlSizeEvent;



    //列表项之间的间隔
    FItemSpace:TControlSize;
    //列表项之间的间隔类型
    FItemSpaceType:TSkinItemSpaceType;



    //列表项的尺寸(如果是-1,表示使用控件宽度,0~1小数表示百分比)
    FItemWidth:TControlSize;
    //列表项的尺寸(如果是-1,表示使用控件高度,0~1小数表示百分比)
    FItemHeight:TControlSize;




    //选中状态时列表项的尺寸
    FSelectedItemHeight:TControlSize;
    FSelectedItemWidth:TControlSize;



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






    //设置列表项高度
    procedure SetItemHeight(const Value: TControlSize);
    //设置列表项宽度
    procedure SetItemWidth(const Value: TControlSize);

    //设置列表项间隔
    procedure SetItemSpace(const Value: TControlSize);
    procedure SetItemSpaceType(const Value: TSkinItemSpaceType);

    procedure SetSelectedItemHeight(const Value: TControlSize);
    procedure SetSelectedItemWidth(const Value: TControlSize);



    //列表项尺寸计算类型
    procedure SetItemSizeCalcType(const Value: TItemSizeCalcType);


    //列表项排列方向(水平或垂直)
    procedure SetItemLayoutType(const Value: TItemLayoutType);

    procedure SetControlLeftOffset(const Value: TControlSize);
    procedure SetControlTopOffset(const Value: TControlSize);
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
    function GetItemDefaultWidth:TControlSize;virtual;
    function GetSelectedItemDefaultWidth:TControlSize;virtual;
    //
    /// <summary>
    ///   <para>
    ///     获取列表项的默认高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetItemDefaultHeight:TControlSize;virtual;
    function GetSelectedItemDefaultHeight:TControlSize;virtual;



    /// <summary>
    ///   <para>
    ///     计算列表项的宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemWidth(AItem:ISkinItem):TControlSize;virtual;

    /// <summary>
    ///   <para>
    ///     计算列表项的高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemHeight(AItem:ISkinItem):TControlSize;virtual;


    /// <summary>
    ///   <para>
    ///     计算垂直模式下的列表项的左偏移(用于TreeView)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemLevelLeftOffsetAtVerticalLayout(AItem:ISkinItem):TControlSize;virtual;



    /// <summary>
    ///   <para>
    ///     计算出最大的列表项宽度(用于垂直模式下计算内容的宽度,更新滚动条)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemsMaxRight:TControlSize;

    /// <summary>
    ///   <para>
    ///     计算出最大的列表项高度(用于水平模式下计算内容的高度,更新滚动条)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcItemsMaxBottom:TControlSize;






    /// <summary>
    ///   <para>
    ///     计算内容宽度(用于处理滚动条的Max)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcContentWidth:TControlSize;virtual;
    /// <summary>
    ///   <para>
    ///     计算内容高度(用于处理滚动条的Max)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function CalcContentHeight:TControlSize;virtual;




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
                                      :TControlSize;
                                      //控件的尺寸,可以自定义
                                      AControlWidth,AControlHeight:TControlSize;
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
    constructor Create(ASkinList:ISkinList);virtual;
    destructor Destroy;override;
  public
    FControlLeftOffset:TControlSize;
    FControlTopOffset:TControlSize;


    function GetControlHeight: TControlSize;
    function GetControlWidth: TControlSize;

    /// <summary>
    ///   <para>
    ///     内容的宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ContentWidth:TControlSize read FContentWidth;
    /// <summary>
    ///   <para>
    ///     内容的高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ContentHeight:TControlSize read FContentHeight;




    /// <summary>
    ///   <para>
    ///     列表接口
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
//    property SkinListIntf:ISkinList read FSkinListIntf write SetSkinListIntf;





    /// <summary>
    ///   <para>
    ///     列表项宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemWidth:TControlSize read FItemWidth write SetItemWidth;

    /// <summary>
    ///   <para>
    ///     列表项高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemHeight:TControlSize read FItemHeight write SetItemHeight;


    /// <summary>
    ///   <para>
    ///     列表项间隔
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSpace:TControlSize read FItemSpace write SetItemSpace;
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
    property StaticItemWidth:TControlSize read FItemWidth write FItemWidth;
    /// <summary>
    ///   <para>
    ///     静态的设置列表项高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property StaticItemHeight:TControlSize read FItemHeight write FItemHeight;



    /// <summary>
    ///   <para>
    ///     选中状态的列表项高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property SelectedItemHeight:TControlSize read FSelectedItemHeight write SetSelectedItemHeight;
    /// <summary>
    ///   <para>
    ///     选中状态的列表项宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property SelectedItemWidth:TControlSize read FSelectedItemWidth write SetSelectedItemWidth;


    property ControlLeftOffset:TControlSize read FControlLeftOffset write SetControlLeftOffset;
    property ControlTopOffset:TControlSize read FControlTopOffset write SetControlTopOffset;


    /// <summary>
    ///   <para>
    ///     控件的宽度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ControlWidth:TControlSize read GetControlWidth write FControlWidth;
    /// <summary>
    ///   <para>
    ///     控件的高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ControlHeight:TControlSize read GetControlHeight write FControlHeight;




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
                FCalcItemsMaxRight:=ControlSize(AItemRect.Right);
              end;
              if FCalcItemsMaxBottom<AItemRect.Bottom then
              begin
                FCalcItemsMaxBottom:=ControlSize(AItemRect.Bottom);
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
                  FCalcItemsMaxRight:=ControlSize(AItemRect.Right);
                end;
                if FCalcItemsMaxBottom<AItemRect.Bottom then
                begin
                  FCalcItemsMaxBottom:=ControlSize(AItemRect.Bottom);
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

procedure TSkinListLayoutsManager.DoItemSizeChange(Sender:TObject;AIsNeedCheck:Boolean);
begin
  if Not AIsNeedCheck then
  begin
    FIsNeedReCalcItemRect:=True;
  end;


  if Not AIsNeedCheck or AIsNeedCheck and FIsNeedReCalcItemRect then
  begin
    if FSkinListIntf.GetUpdateCount=0 then
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

function TSkinListLayoutsManager.GetControlHeight: TControlSize;
begin
  Result:=FControlHeight;
  if Assigned(Self.FOnGetControlHeight) then
  begin
    Result:=FOnGetControlHeight(Self);
  end;
end;

function TSkinListLayoutsManager.GetControlWidth: TControlSize;
begin
  Result:=FControlWidth;
  if Assigned(Self.FOnGetControlWidth) then
  begin
    Result:=FOnGetControlWidth(Self);
  end;
end;

function TSkinListLayoutsManager.GetItemDefaultHeight: TControlSize;
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

function TSkinListLayoutsManager.GetSelectedItemDefaultHeight: TControlSize;
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

function TSkinListLayoutsManager.GetItemDefaultWidth: TControlSize;
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

function TSkinListLayoutsManager.GetSelectedItemDefaultWidth: TControlSize;
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

procedure TSkinListLayoutsManager.SetControlLeftOffset(
  const Value: TControlSize);
begin
  if FControlLeftOffset<>Value then
  begin
    FControlLeftOffset := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetControlTopOffset(
  const Value: TControlSize);
begin
  if FControlTopOffset<>Value then
  begin
    FControlTopOffset := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetItemHeight(const Value: TControlSize);
begin
  if (FItemHeight<>Value) then
  begin
    FItemHeight:=Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetSelectedItemHeight(const Value: TControlSize);
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

procedure TSkinListLayoutsManager.SetItemWidth(const Value: TControlSize);
begin
  if (FItemWidth<>Value) then
  begin
    FItemWidth:=Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinListLayoutsManager.SetSelectedItemWidth(const Value: TControlSize);
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

procedure TSkinListLayoutsManager.SetItemSpace(const Value: TControlSize);
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

function TSkinListLayoutsManager.CalcContentHeight: TControlSize;
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

function TSkinListLayoutsManager.CalcContentWidth: TControlSize;
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
                                                            :TControlSize;
                                                            AControlWidth,AControlHeight:TControlSize;
                                                            var ADrawStartIndex:Integer;
                                                            var ADrawEndIndex:Integer);
var
  I: Integer;

  AFirstItemBottom:TControlSize;
  AFirstItemRight:TControlSize;
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
                    AFirstItemBottom:=ControlSize(Self.GetVisibleItem(m).ItemRect.Bottom);


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
                    AFirstItemRight:=ControlSize(Self.GetVisibleItem(m).ItemRect.Right);



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

function TSkinListLayoutsManager.CalcItemHeight(AItem: ISkinItem): TControlSize;
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

function TSkinListLayoutsManager.CalcItemLevelLeftOffsetAtVerticalLayout(AItem: ISkinItem): TControlSize;
begin
  Result:=0;
end;

function TSkinListLayoutsManager.CalcItemsMaxBottom: TControlSize;
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
        Result:=ControlSize(Self.VisibleItemRectByIndex(I).Bottom);
      end;
    end;
  end;
end;

function TSkinListLayoutsManager.CalcItemsMaxRight: TControlSize;
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
        Result:=ControlSize(Self.VisibleItemRectByIndex(I).Right);
      end;
    end;
//  end;
end;

function TSkinListLayoutsManager.CalcItemWidth(AItem: ISkinItem): TControlSize;
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
      //如果是小数,那么取控件宽度的百分比
      Result:=AItem.Width*GetControlWidth;
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
var
  AItemIndex:Integer;
begin
  Result:=RectF(0,0,0,0);
  AItemIndex:=Self.GetVisibleItemObjectIndex(AVisibleItem.GetObject);
  if AItemIndex<>-1 then
  begin
    Result:=VisibleItemRectByIndex(AItemIndex);
  end;
//  if AVisibleItem<>nil then
//  begin
//    Result:=AVisibleItem.GetItemRect;
//  end;
end;






end.

