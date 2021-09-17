//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     虚拟列表框,带有列表项绑定设计面板功能
///   </para>
///   <para>
///     Virtual List Box
///   </para>
/// </summary>
unit uSkinVirtualListType;

interface
{$I FrameWork.inc}

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
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,
  {$ENDIF}


  uLang,
  uFuncCommon,
  uSkinAnimator,
  uBaseList,
  uBaseLog,
  uSkinItems,
  uUrlPicture,
  uDownloadPictureManager,
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
  uSkinImageList,
  uSkinItemDesignerPanelType,
  uSkinCustomListType,

  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
  {$ELSE}
  XSuperObject,
  XSuperJson,
  {$ENDIF}


//  BaseListItemStyleFrame,


  {$IFDEF VCL}
//  uSkinWindowsItemDesignerPanel,
  {$ENDIF}
  {$IFDEF FMX}
  uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyEdit,
  uSkinFireMonkeyComboBox,
  uSkinFireMonkeyComboEdit,
  {$ENDIF}

  uSkinControlGestureManager,
  uSkinControlPanDragGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;



const
  IID_ISkinVirtualList:TGUID='{06786B16-959B-49B5-A48A-227F76786231}';



type
  TSkinVirtualListLayoutsManagerClass=class of TSkinVirtualListLayoutsManager;
  TVirtualListProperties=class;




  TVirtualListEditingItemEvent=procedure(Sender:TObject;
                                          AItem:TSkinItem;
                                          ABindingControl:TChildControl;
                                          AEditControl:TChildControl) of object;
  TVirtualListClickItemExEvent=procedure(Sender:TObject;
                                          AItem:TSkinItem;
                                          X:Double;
                                          Y:Double) of object;
  TVirtualListClickItemEvent=procedure(AItem:TSkinItem) of object;
  TVirtualListDoItemEvent=procedure(Sender:TObject;AItem:TSkinItem) of object;
  TVirtualListPrepareItemPanDragEvent=procedure(Sender:TObject;
                                                AItem:TSkinItem;
                                                var AItemIsCanPanDrag:Boolean) of object;

  //获取列表项缓存标记的事件
  TVirtualListGetItemBufferCacheTagEvent=procedure(
      Sender:TObject;
      AItem:TSkinItem;
      var ACacheTag:Integer) of object;



  /// <summary>
  ///   <para>
  ///     虚拟列表框接口
  ///   </para>
  ///   <para>
  ///     Interface of VirtualList Box
  ///   </para>
  /// </summary>
  ISkinVirtualList=interface//(ISkinScrollControl)
    ['{06786B16-959B-49B5-A48A-227F76786231}']

    //准备平拖事件(可以根据Item设置ItemPanDragDesignerPanel)
    function GetOnPrepareItemPanDrag:TVirtualListPrepareItemPanDragEvent;

    function GetOnClickItem: TVirtualListClickItemEvent;
    function GetOnLongTapItem: TVirtualListDoItemEvent;
    function GetOnClickItemEx: TVirtualListClickItemExEvent;
    function GetOnSelectedItem: TVirtualListDoItemEvent;
    function GetOnCenterItemChange:TVirtualListDoItemEvent;

    function GetOnGetItemBufferCacheTag:TVirtualListGetItemBufferCacheTagEvent;
    function GetOnPrepareDrawItem: TVirtualListDrawItemEvent;
    function GetOnAdvancedDrawItem: TVirtualListDrawItemEvent;

    function GetOnStartEditingItem: TVirtualListEditingItemEvent;
    function GetOnStopEditingItem: TVirtualListEditingItemEvent;


    //居中列表项更改事件
    property OnCenterItemChange:TVirtualListDoItemEvent read GetOnCenterItemChange;

    //点击列表项事件
    property OnClickItem:TVirtualListClickItemEvent read GetOnClickItem;
    //长按列表项事件
    property OnLongTapItem:TVirtualListDoItemEvent read GetOnLongTapItem;
    //点击列表项事件
    property OnClickItemEx:TVirtualListClickItemExEvent read GetOnClickItemEx;
    //列表项被选中的事件
    property OnSelectedItem:TVirtualListDoItemEvent read GetOnSelectedItem;


    //列表项开始编辑事件
    property OnStartEditingItem:TVirtualListEditingItemEvent read GetOnStartEditingItem;
    //列表项结束编辑事件
    property OnStopEditingItem:TVirtualListEditingItemEvent read GetOnStopEditingItem;



    property OnGetItemBufferCacheTag:TVirtualListGetItemBufferCacheTagEvent read GetOnGetItemBufferCacheTag;
    //每次绘制列表项之前准备
    property OnPrepareDrawItem:TVirtualListDrawItemEvent read GetOnPrepareDrawItem;
    //增强绘制列表项事件
    property OnAdvancedDrawItem:TVirtualListDrawItemEvent read GetOnAdvancedDrawItem;

    //准备平拖事件(可以根据Item设置ItemPanDragDesignerPanel)
    property OnPrepareItemPanDrag:TVirtualListPrepareItemPanDragEvent read GetOnPrepareItemPanDrag;


    function GetVirtualListProperties:TVirtualListProperties;
    property Properties:TVirtualListProperties read GetVirtualListProperties;
    property Prop:TVirtualListProperties read GetVirtualListProperties;
  end;









  /// <summary>
  ///   <para>
  ///     虚拟列表框属性
  ///   </para>
  ///   <para>
  ///     Properties of VirtualList Box
  ///   </para>
  /// </summary>
  TVirtualListProperties=class(TCustomListProperties)
  protected

    //是否启用缓存(目前不再使用)
    FEnableBuffer:Boolean;



    //列表项颜色Item.Color的类型(可以设置为列表项的背景色,)
    //以便可以每个Item设置不同的颜色
    FItemColorType:TSkinItemColorType;


    //Item.Icon的图标列表
    FIconSkinImageList:TSkinImageList;
    FIconSkinImageListChangeLink:TSkinObjectChangeLink;


    //Item.Icon的图片下载管理者
    FIconDownloadPictureManager:TDownloadPictureManager;



    FSkinVirtualListIntf:ISkinVirtualList;

    //给列表项赋值
    function GetItems:TSkinItems;
    //给列表项赋值
    procedure SetItems(const Value: TSkinItems);


    procedure SetMouseDownItem(Value: TSkinItem);
    procedure SetInnerMouseDownItem(Value: TSkinItem);
    procedure SetMouseOverItem(Value: TSkinItem);
    procedure SetSelectedItem(Value: TSkinItem);
    procedure SetCenterItem(Value: TSkinItem);
    procedure SetPanDragItem(Value: TSkinItem);

    function GetMouseDownItem: TSkinItem;
    function GetInnerMouseDownItem: TSkinItem;
    function GetMouseOverItem: TSkinItem;
    function GetSelectedItem: TSkinItem;
    function GetCenterItem: TSkinItem;
    function GetPanDragItem: TSkinItem;
    function GetEditingItem: TSkinItem;



    procedure SetIconDownloadPictureManager(const Value: TDownloadPictureManager);


    //图标列表
    procedure SetIconSkinImageList(const Value: TSkinImageList);
    procedure OnIconSkinImageListChange(Sender: TObject);
    procedure OnIconSkinImageListDestroy(Sender: TObject);

    function GetListLayoutsManager:TSkinVirtualListLayoutsManager;
  private

    function GetDefaultItemStyle: String;
    function GetFooterItemStyle: String;
    function GetHeaderItemStyle: String;
    function GetItem1ItemStyle: String;
    function GetItem2ItemStyle: String;
    function GetItem3ItemStyle: String;
    function GetItem4ItemStyle: String;
    function GetSearchBarItemStyle: String;
    procedure SetDefaultItemStyle(const Value: String);
    procedure SetFooterItemStyle(const Value: String);
    procedure SetHeaderItemStyle(const Value: String);
    procedure SetItem1ItemStyle(const Value: String);
    procedure SetItem2ItemStyle(const Value: String);
    procedure SetItem3ItemStyle(const Value: String);
    procedure SetItem4ItemStyle(const Value: String);
    procedure SetSearchBarItemStyle(const Value: String);

    function GetFooterDesignerPanel: TSkinItemDesignerPanel;
    function GetHeaderDesignerPanel: TSkinItemDesignerPanel;
    function GetItem1DesignerPanel: TSkinItemDesignerPanel;
    function GetItem2DesignerPanel: TSkinItemDesignerPanel;
    function GetItem3DesignerPanel: TSkinItemDesignerPanel;
    function GetItem4DesignerPanel: TSkinItemDesignerPanel;
    function GetItemDesignerPanel: TSkinItemDesignerPanel;
    function GetSearchBarDesignerPanel: TSkinItemDesignerPanel;
    procedure SetFooterDesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetSearchBarDesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetItem1DesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetItem2DesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetItem3DesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetItem4DesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetHeaderDesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetDefaultItemStyleConfig(const Value: TStringList);
    procedure SetFooterItemStyleConfig(const Value: TStringList);
    procedure SetHeaderItemStyleConfig(const Value: TStringList);
    procedure SetItem1ItemStyleConfig(const Value: TStringList);
    procedure SetItem2ItemStyleConfig(const Value: TStringList);
    procedure SetItem3ItemStyleConfig(const Value: TStringList);
    procedure SetItem4ItemStyleConfig(const Value: TStringList);
    procedure SetSearchBarItemStyleConfig(const Value: TStringList);
    function GetDefaultItemStyleConfig: TStringList;
    function GetFooterItemStyleConfig: TStringList;
    function GetHeaderItemStyleConfig: TStringList;
    function GetItem1ItemStyleConfig: TStringList;
    function GetItem2ItemStyleConfig: TStringList;
    function GetItem3ItemStyleConfig: TStringList;
    function GetItem4ItemStyleConfig: TStringList;
    function GetSearchBarItemStyleConfig: TStringList;

  protected
    procedure DoMouseOverItemChange(ANewItem,AOldItem: TBaseSkinItem);override;
  protected
    //给设计面板上的控件赋值
//    procedure BindItemDesignerPanelAndItem(AItemDesignerPanel:TSkinItemDesignerPanel;AItem:TSkinItem;AIsDrawItemInteractiveState:Boolean);virtual;
    //确定列表项使用哪个列表项设计面板来绘制
    function DecideItemDesignerPanel(AItem:TSkinItem):TSkinItemDesignerPanel;virtual;
  protected
    //编辑情况有两种,
    //一种是显示元素是Label,但编辑时使用Edit
    //另一种是显示元素和编辑时都使用Edit


    //绑定的控件(可以是Label)
    //如果没有绑定控件怎么办,那可以直接设置编辑控件需要显示的相对矩形
    FEditingItem_BindingControl:TControl;
    //需要绘制到不在编辑状态的列表项
    FEditingItem_BindingControlIntf:ISkinControl;

    FEditingItem_FieldName:String;
//    FEditingItem_DataType:TSkinItemDataType;
//    FEditingItem_SubItemsIndex:Integer;

    //结束编辑的时候把编辑框的值赋给Item
    procedure DoSetValueToEditingItem;override;
    //结束编辑时调用
    procedure DoStopEditingItemEnd;override;
  public
    /// <summary>
    ///   <para>
    ///     开始编辑列表项
    ///   </para>
    ///   <para>
    ///     Start editing ListItem
    ///   </para>
    /// </summary>
    procedure StartEditingItem(AItem:TBaseSkinItem;
                                ABindingControl:TControl;
                                AEditControl:TControl;
                                X, Y: Double);overload;
    procedure StartEditingItemByFieldName(AItem:TBaseSkinItem;
//                                          AEditItemDataType:TSkinItemDataType;
//                                          AEditItemSubItemsIndex:Integer;
                                          AEditItemFieldName:String;
                                          AEditControl:TControl;
                                          AEditControlPutRect: TRectF;
                                          X, Y: Double);overload;

  protected
    procedure CallOnPrepareItemPanDrag(Sender:TObject;AItem:TBaseSkinItem; var AItemIsCanPanDrag: Boolean);override;

    //居中的列表项更改事件
    procedure CallOnCenterItemChangeEvent(Sender:TObject;AItem:TBaseSkinItem);override;

    //点击列表项事件
    procedure CallOnClickItemEvent(AItem:TBaseSkinItem);override;
    //是否拥有长按列表项事件
    function HasOnLongTapItemEvent:Boolean;override;
    //长按列表项事件
    procedure CallOnLongTapItemEvent(Sender:TObject;AItem:TBaseSkinItem);override;
    //点击列表项事件
    procedure CallOnClickItemExEvent(AItem:TBaseSkinItem;X:Double;Y:Double);override;
    //列表项被选中的事件
    procedure CallOnSelectedItemEvent(Sender:TObject;AItem:TBaseSkinItem);override;


    //列表项开始编辑事件
    procedure CallOnStartEditingItemEvent(Sender:TObject;AItem:TBaseSkinItem;AEditControl:TChildControl);override;
    //列表项结束编辑事件
    procedure CallOnStopEditingItemEvent(Sender:TObject;AItem:TBaseSkinItem;AEditControl:TChildControl);override;

    //每次绘制列表项之前准备,调用OnPrepareDrawItem事件
    //因为每次绘制时调用OnPrepareDrawItem事件非常耗时,因此当启用缓存的时候,不需要每次都调用它,提高效率
    procedure CallOnPrepareDrawItemEvent(
                  Sender:TObject;
                  ACanvas:TDrawCanvas;
                  AItem:TBaseSkinItem;
                  AItemDrawRect:TRectF;
                  AIsDrawItemInteractiveState:Boolean);override;
    //增强绘制列表项事件
    procedure CallOnAdvancedDrawItemEvent(
                  Sender:TObject;
                  ACanvas:TDrawCanvas;
                  AItem:TBaseSkinItem;
                  AItemDrawRect:TRectF);override;
  protected
    //获取列表类
    function GetItemsClass:TBaseSkinItemsClass;override;
    //获取列表布局管理者
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;override;
  protected

    //获取默认的图标列表
    procedure DoGetItemDefaultSkinImageList(Sender:TObject;var ASkinImageList:TSkinBaseImageList);
    //获取默认的图片下载管理者
    procedure DoGetItemDefaultDownloadPictureManager(Sender:TObject;var ADownloadPictureManager:TBaseDownloadPictureManager);

  protected

    //开放平台的框架所需要使用的,存储不同控件的特殊属性,不可能每个属性都加个字段的吧,你说是不是
    procedure GetPropJson(ASuperObject:ISuperObject);override;
    procedure SetPropJson(ASuperObject:ISuperObject);override;

    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public

    FDefaultItemStyleSetting:TListItemTypeStyleSetting;
    FItem1ItemStyleSetting:TListItemTypeStyleSetting;
    FItem2ItemStyleSetting:TListItemTypeStyleSetting;
    FItem3ItemStyleSetting:TListItemTypeStyleSetting;
    FItem4ItemStyleSetting:TListItemTypeStyleSetting;
    FHeaderItemStyleSetting:TListItemTypeStyleSetting;
    FFooterItemStyleSetting:TListItemTypeStyleSetting;
    FSearchBarItemStyleSetting:TListItemTypeStyleSetting;

    FListItemTypeStyleSettingList:TListItemTypeStyleSettingList;


    IsItemMouseEventNeedCallPrepareDrawItem:Boolean;


    //根据ItemStyle返回ItemType的机制
    //先清空ItemStyle和ItemDesignerPanel
    procedure ClearItemTypeStyles;
    function SetItemTypeStyle(AItemStyle:String):TListItemTypeStyleSetting;
    function GetItemTypeByStyle(AItemStyle:String):TSkinItemType;
    function GetItemStyleByItemType(AItemType:TSkinItemType):String;
    function IsItemTypeStyleExists(AItemStyle:String):TListItemTypeStyleSetting;


    //计算列表项的尺寸
    function CalcItemAutoSize(AItem:TSkinItem;
          const ABottomSpace:TControlSize=10):TSizeF;
//    //获取列表项类型的风格Frame
//    function GetItemTypeStyleCacheFrame(AItemType:TSkinItemType):TFrame;
    /// <summary>
    ///   <para>
    ///     选中的列表项
    ///   </para>
    ///   <para>
    ///     Selected ListItem
    ///   </para>
    /// </summary>
    property SelectedItem:TSkinItem read GetSelectedItem write SetSelectedItem;
    /// <summary>
    ///   <para>
    ///     鼠标按下的列表项
    ///   </para>
    ///   <para>
    ///     Pressed ListItem
    ///   </para>
    /// </summary>
    property MouseDownItem:TSkinItem read GetMouseDownItem write SetMouseDownItem;
    property InnerMouseDownItem:TSkinItem read GetInnerMouseDownItem write SetInnerMouseDownItem;
    /// <summary>
    ///   <para>
    ///     居中的列表项
    ///   </para>
    ///   <para>
    ///     Centered ListItem
    ///   </para>
    /// </summary>
    property CenterItem:TSkinItem read GetCenterItem write SetCenterItem;

    /// <summary>
    ///   <para>
    ///     停靠的列表项
    ///   </para>
    ///   <para>
    ///     Hovered :ListItem
    ///   </para>
    /// </summary>
    property MouseOverItem:TSkinItem read GetMouseOverItem write SetMouseOverItem;
    /// <summary>
    ///   <para>
    ///     平拖的列表项
    ///   </para>
    ///   <para>
    ///     PanDragged ListItem
    ///   </para>
    /// </summary>
    property PanDragItem:TSkinItem read GetPanDragItem write SetPanDragItem;
    /// <summary>
    ///   <para>
    ///     获取当前编辑的项
    ///   </para>
    ///   <para>
    ///     Get editing item
    ///   </para>
    /// </summary>
    property EditingItem:TSkinItem read GetEditingItem;
    /// <summary>
    ///   <para>
    ///     获取坐标所在的列表项
    ///   </para>
    ///   <para>
    ///     Get ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemAt(X, Y: Double):TSkinItem;
    /// <summary>
    ///   <para>
    ///     列表项布局管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ListLayoutsManager:TSkinVirtualListLayoutsManager read GetListLayoutsManager;

//    //设置列表项的风格
//    function SetListBoxItemStyle(AItemType:TSkinItemType;
//                                  AListItemStyle:String):Boolean;override;
  published
    property IsEnabledCenterItemSelectMode;
    property ItemWidth;
    property SelectedItemWidth;
    property ItemWidthCalcType;
    property ItemLayoutType;


    //设置默认列表项的风格
    property DefaultItemStyle:String read GetDefaultItemStyle write SetDefaultItemStyle;
    property Item1ItemStyle:String read GetItem1ItemStyle write SetItem1ItemStyle;
    property Item2ItemStyle:String read GetItem2ItemStyle write SetItem2ItemStyle;
    property Item3ItemStyle:String read GetItem3ItemStyle write SetItem3ItemStyle;
    property Item4ItemStyle:String read GetItem4ItemStyle write SetItem4ItemStyle;
    property HeaderItemStyle:String read GetHeaderItemStyle write SetHeaderItemStyle;
    property FooterItemStyle:String read GetFooterItemStyle write SetFooterItemStyle;
    property SearchBarItemStyle:String read GetSearchBarItemStyle write SetSearchBarItemStyle;

    property DefaultItemStyleConfig:TStringList read GetDefaultItemStyleConfig write SetDefaultItemStyleConfig;
    property Item1ItemStyleConfig:TStringList read GetItem1ItemStyleConfig write SetItem1ItemStyleConfig;
    property Item2ItemStyleConfig:TStringList read GetItem2ItemStyleConfig write SetItem2ItemStyleConfig;
    property Item3ItemStyleConfig:TStringList read GetItem3ItemStyleConfig write SetItem3ItemStyleConfig;
    property Item4ItemStyleConfig:TStringList read GetItem4ItemStyleConfig write SetItem4ItemStyleConfig;
    property HeaderItemStyleConfig:TStringList read GetHeaderItemStyleConfig write SetHeaderItemStyleConfig;
    property FooterItemStyleConfig:TStringList read GetFooterItemStyleConfig write SetFooterItemStyleConfig;
    property SearchBarItemStyleConfig:TStringList read GetSearchBarItemStyleConfig write SetSearchBarItemStyleConfig;


    /// <summary>
    ///   <para>
    ///     列表项颜色类型
    ///   </para>
    ///   <para>
    ///     ListItem color type
    ///   </para>
    /// </summary>
    property ItemColorType:TSkinItemColorType read FItemColorType write FItemColorType;
    /// <summary>
    ///   <para>
    ///     列表项列表
    ///   </para>
    ///   <para>
    ///     List of ListItem
    ///   </para>
    /// </summary>
    property Items:TSkinItems read GetItems write SetItems;
    //启用缓存
    property EnableBuffer:Boolean read FEnableBuffer write FEnableBuffer;// stored False;//default False;

    /// <summary>
    ///   <para>
    ///     图标列表
    ///   </para>
    ///   <para>
    ///     Image list
    ///   </para>
    /// </summary>
    property SkinImageList:TSkinImageList read FIconSkinImageList write SetIconSkinImageList;
    /// <summary>
    ///   <para>
    ///     图片下载管理者
    ///   </para>
    ///   <para>
    ///     Image list
    ///   </para>
    /// </summary>
    property DownloadPictureManager:TDownloadPictureManager read FIconDownloadPictureManager write SetIconDownloadPictureManager;
    /// <summary>
    ///   <para>
    ///     列表项类型Item.ItemType为sitHeader时所使用的列表项设计面板
    ///   </para>
    ///   <para>
    ///     Item Designer Panel of group header
    ///   </para>
    /// </summary>
    property HeaderDesignerPanel: TSkinItemDesignerPanel read GetHeaderDesignerPanel write SetHeaderDesignerPanel;
    /// <summary>
    ///   <para>
    ///     列表项类型Item.ItemType为sitFooter时所使用的列表项设计面板
    ///   </para>
    ///   <para>
    ///     Item Designer Panel of group footer
    ///   </para>
    /// </summary>
    property FooterDesignerPanel: TSkinItemDesignerPanel read GetFooterDesignerPanel write SetFooterDesignerPanel;
    /// <summary>
    ///   <para>
    ///     列表项类型Item.ItemType为sitSearchBar时所使用的列表项设计面板
    ///   </para>
    ///   <para>
    ///     Item Designer Panel of search box
    ///   </para>
    /// </summary>
    property SearchBarDesignerPanel: TSkinItemDesignerPanel read GetSearchBarDesignerPanel write SetSearchBarDesignerPanel;
    /// <summary>
    ///   <para>
    ///     默认的列表项设计面板
    ///   </para>
    ///   <para>
    ///     Default Item Designer Panel
    ///   </para>
    /// </summary>
    property ItemDesignerPanel: TSkinItemDesignerPanel read GetItemDesignerPanel write SetItemDesignerPanel;
    /// <summary>
    ///   <para>
    ///     列表项类型Item.ItemType为sitItem1时所使用的列表项设计面板
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Item1DesignerPanel: TSkinItemDesignerPanel read GetItem1DesignerPanel write SetItem1DesignerPanel;
    /// <summary>
    ///   <para>
    ///     列表项类型Item.ItemType为sitItem2时所使用的列表项设计面板
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Item2DesignerPanel: TSkinItemDesignerPanel read GetItem2DesignerPanel write SetItem2DesignerPanel;
    /// <summary>
    ///   <para>
    ///     列表项类型Item.ItemType为sitItem3时所使用的列表项设计面板
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Item3DesignerPanel: TSkinItemDesignerPanel read GetItem3DesignerPanel write SetItem3DesignerPanel;
    /// <summary>
    ///   <para>
    ///     列表项类型Item.ItemType为sitItem4时所使用的列表项设计面板
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Item4DesignerPanel: TSkinItemDesignerPanel read GetItem4DesignerPanel write SetItem4DesignerPanel;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinListItemMaterial=class(TBaseSkinListItemMaterial)
  private
    //标题绘制参数
    FDrawItemCaptionParam:TDrawTextParam;
    //图标绘制参数
    FDrawItemIconParam:TDrawPictureParam;
    FDrawItemPicParam:TDrawPictureParam;


    FDrawItemDetailParam:TDrawTextParam;
    FDrawItemDetail1Param:TDrawTextParam;
    FDrawItemDetail2Param:TDrawTextParam;
    FDrawItemDetail3Param:TDrawTextParam;
    FDrawItemDetail4Param:TDrawTextParam;
    FDrawItemDetail5Param:TDrawTextParam;
    FDrawItemDetail6Param:TDrawTextParam;


    procedure SetDrawItemCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawItemIconParam(const Value: TDrawPictureParam);
    procedure SetDrawItemPicParam(const Value: TDrawPictureParam);


    procedure SetDrawItemDetailParam(const Value: TDrawTextParam);
    procedure SetDrawItemDetail1Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail2Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail3Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail4Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail5Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail6Param(const Value: TDrawTextParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    /// <summary>
    ///   <para>
    ///     列表项的标题绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemCaptionParam:TDrawTextParam read FDrawItemCaptionParam write SetDrawItemCaptionParam;
    /// <summary>
    ///   <para>
    ///     列表项的图标绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemIconParam:TDrawPictureParam read FDrawItemIconParam write SetDrawItemIconParam;

    /// <summary>
    ///   <para>
    ///     列表项的图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemPicParam:TDrawPictureParam read FDrawItemPicParam write SetDrawItemPicParam;

    /// <summary>
    ///   <para>
    ///     列表项的明细绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetailParam:TDrawTextParam read FDrawItemDetailParam write SetDrawItemDetailParam;
    /// <summary>
    ///   <para>
    ///     列表项的明细1绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail1Param:TDrawTextParam read FDrawItemDetail1Param write SetDrawItemDetail1Param;
    /// <summary>
    ///   <para>
    ///     列表项的明细2绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail2Param:TDrawTextParam read FDrawItemDetail2Param write SetDrawItemDetail2Param;
    /// <summary>
    ///   <para>
    ///     列表项的明细3绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail3Param:TDrawTextParam read FDrawItemDetail3Param write SetDrawItemDetail3Param;
    /// <summary>
    ///   <para>
    ///     列表项的明细4绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail4Param:TDrawTextParam read FDrawItemDetail4Param write SetDrawItemDetail4Param;
    /// <summary>
    ///   <para>
    ///     列表项的明细5绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail5Param:TDrawTextParam read FDrawItemDetail5Param write SetDrawItemDetail5Param;
    /// <summary>
    ///   <para>
    ///     列表项的明细6绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail6Param:TDrawTextParam read FDrawItemDetail6Param write SetDrawItemDetail6Param;
  end;



  TSkinListItemMaterialItem=class(TCollectionItem)
  private
    FStyleName:String;
    FMaterial: TSkinListItemMaterial;
    FDesc: String;
    procedure SetMaterial(const Value: TSkinListItemMaterial);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  published
    //风格名称
    property StyleName:String read FStyleName write FStyleName;
    //描述
    property Desc:String read FDesc write FDesc;
    //素材
    property Material:TSkinListItemMaterial read FMaterial write SetMaterial;
  end;

  TSkinListItemMaterials=class(TCollection)
  private
    function GetItem(Index: Integer): TSkinListItemMaterialItem;
  public
    property Items[Index:Integer]:TSkinListItemMaterialItem read GetItem;default;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinItemMaterialStylePackage=class(TComponent)
  private
    FMaterials: TSkinListItemMaterials;
    procedure SetMaterials(const Value: TSkinListItemMaterials);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //获取素材
    function GetMaterial(AStyleName:String):TSkinListItemMaterial;
  published
    //素材列表
    property Materials:TSkinListItemMaterials read FMaterials write SetMaterials;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinVirtualListDefaultMaterial=class(TSkinCustomListDefaultMaterial)
  private

    //空白项绘制参数
    FDrawSpaceParam:TDrawRectParam;

    //分组开始分隔线
    FDrawGroupBeginDevideParam:TDrawRectParam;
    //分组结束分隔线
    FDrawGroupEndDevideParam:TDrawRectParam;


    //只是简单的画一条一个像素的直线
    FIsSimpleDrawGroupBeginDevide: Boolean;
    FIsSimpleDrawGroupEndDevide: Boolean;


    //是否简单绘制分组矩形
    FIsSimpleDrawGroupRoundRect: Boolean;


    //自动调整ItemDesignerPanel
    FIsAutoAdjustItemDesignerPanelSize:Boolean;


    function GetDrawItemDetailParam: TDrawTextParam;
    function GetDrawItemDetail1Param: TDrawTextParam;
    function GetDrawItemDetail2Param: TDrawTextParam;
    function GetDrawItemDetail3Param: TDrawTextParam;
    function GetDrawItemDetail4Param: TDrawTextParam;
    function GetDrawItemDetail5Param: TDrawTextParam;
    function GetDrawItemDetail6Param: TDrawTextParam;

    function GetDrawItemCaptionParam: TDrawTextParam;
    function GetDrawItemIconParam: TDrawPictureParam;
    function GetDrawItemPicParam: TDrawPictureParam;


    procedure SetDrawItemDetailParam(const Value: TDrawTextParam);
    procedure SetDrawItemDetail1Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail2Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail3Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail4Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail5Param(const Value: TDrawTextParam);
    procedure SetDrawItemDetail6Param(const Value: TDrawTextParam);


    procedure SetDrawItemCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawItemIconParam(const Value: TDrawPictureParam);
    procedure SetDrawItemPicParam(const Value: TDrawPictureParam);

    procedure SetDrawSpaceParam(const Value: TDrawRectParam);

    procedure SetDrawGroupBeginDevideParam(const Value: TDrawRectParam);
    procedure SetDrawGroupEndDevideParam(const Value: TDrawRectParam);

    procedure SetIsSimpleDrawGroupBeginDevide(const Value: Boolean);
    procedure SetIsSimpleDrawGroupEndDevide(const Value: Boolean);
    procedure SetIsSimpleDrawGroupRoundRect(const Value: Boolean);

    function GetDefaultTypeItemMaterial: TSkinListItemMaterial;
    procedure SetDefaultTypeItemMaterial(const Value: TSkinListItemMaterial);
    function GetItem1TypeItemMaterial: TSkinListItemMaterial;
    procedure SetItem1TypeItemMaterial(const Value: TSkinListItemMaterial);
  protected
    procedure AssignTo(Dest: TPersistent); override;

    //获取列表项素材基类
    function GetSkinCustomListItemMaterialClass:TBaseSkinItemMaterialClass;override;
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
    ///     列表项的正常状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackNormalPicture;//:TDrawPicture read GetItemBackNormalPicture write SetItemBackNormalPicture;
    /// <summary>
    ///   <para>
    ///     列表项的鼠标停靠状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackHoverPicture;//:TDrawPicture read GetItemBackHoverPicture write SetItemBackHoverPicture;

    /// <summary>
    ///   <para>
    ///     列表项的鼠标按下状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackDownPicture;//: TDrawPicture read GetItemBackDownPicture write SetItemBackDownPicture;
//    //列表项的禁用状态图片
//    property ItemBackDisabledPicture: TDrawPicture read GetItemBackDisabledPicture write SetItemBackDisabledPicture;
//    //列表项的得到焦点状态图片
//    property ItemBackFocusedPicture: TDrawPicture read GetItemBackFocusedPicture write SetItemBackFocusedPicture;

    /// <summary>
    ///   <para>
    ///     列表项的按下状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackPushedPicture;//:TDrawPicture read GetItemBackPushedPicture write SetItemBackPushedPicture;
    /// <summary>
    ///   <para>
    ///     列表项的背景颜色绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackColorParam;//:TDrawRectParam read GetDrawItemBackColorParam write SetDrawItemBackColorParam;

    /// <summary>
    ///   <para>
    ///     列表项的背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackGndPictureParam;//:TDrawPictureParam read GetDrawItemBackGndPictureParam write SetDrawItemBackGndPictureParam;
    /// <summary>
    ///   <para>
    ///     列表项的展开图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemAccessoryPicture;//:TDrawPicture read GetItemAccessoryPicture write SetItemAccessoryPicture;

    /// <summary>
    ///   <para>
    ///     列表项的展开图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemAccessoryPictureParam;//:TDrawPictureParam read GetDrawItemAccessoryPictureParam write SetDrawItemAccessoryPictureParam;
  published

    /// <summary>
    ///   <para>
    ///     默认类型列表项绘制素材
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
//    property DefaultTypeItemMaterial:TBaseSkinListItemMaterial read FDefaultTypeItemMaterial write SetDefaultTypeItemMaterial;

    /// <summary>
    ///   <para>
    ///     是否绘制中心矩形块
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsDrawCenterItemRect;//:Boolean read FIsDrawCenterItemRect write SetIsDrawCenterItemRect;

    /// <summary>
    ///   <para>
    ///     中心矩形块绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawCenterItemRectParam;//:TDrawRectParam read FDrawCenterItemRectParam write SetDrawCenterItemRectParam;

    /// <summary>
    ///   <para>
    ///     是否简单绘制分隔线
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsSimpleDrawItemDevide;//:Boolean read FIsSimpleDrawItemDevide write SetIsSimpleDrawItemDevide ;//default True;

    /// <summary>
    ///   <para>
    ///     分隔线绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDevideParam;//:TDrawRectParam read FDrawItemDevideParam write SetDrawItemDevideParam;
  published
    /// <summary>
    ///   <para>
    ///     列表项的标题绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemCaptionParam:TDrawTextParam read GetDrawItemCaptionParam write SetDrawItemCaptionParam;
    /// <summary>
    ///   <para>
    ///     列表项的图标绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemIconParam:TDrawPictureParam read GetDrawItemIconParam write SetDrawItemIconParam;
    /// <summary>
    ///   <para>
    ///     列表项的图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemPicParam:TDrawPictureParam read GetDrawItemPicParam write SetDrawItemPicParam;
    /// <summary>
    ///   <para>
    ///     列表项的明细绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetailParam:TDrawTextParam read GetDrawItemDetailParam write SetDrawItemDetailParam;
    //
    /// <summary>
    ///   <para>
    ///     列表项的明细1绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail1Param:TDrawTextParam read GetDrawItemDetail1Param write SetDrawItemDetail1Param;
    //
    /// <summary>
    ///   <para>
    ///     列表项的明细2绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail2Param:TDrawTextParam read GetDrawItemDetail2Param write SetDrawItemDetail2Param;
    //
    /// <summary>
    ///   <para>
    ///     列表项的明细3绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail3Param:TDrawTextParam read GetDrawItemDetail3Param write SetDrawItemDetail3Param;
    //
    /// <summary>
    ///   <para>
    ///     列表项的明细4绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail4Param:TDrawTextParam read GetDrawItemDetail4Param write SetDrawItemDetail4Param;

    /// <summary>
    ///   <para>
    ///     列表项的明细5绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail5Param:TDrawTextParam read GetDrawItemDetail5Param write SetDrawItemDetail5Param;

    /// <summary>
    ///   <para>
    ///     列表项的明细6绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDetail6Param:TDrawTextParam read GetDrawItemDetail6Param write SetDrawItemDetail6Param;
    /// <summary>
    ///   <para>
    ///     默认类型列表项绘制素材
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DefaultTypeItemMaterial:TSkinListItemMaterial read GetDefaultTypeItemMaterial write SetDefaultTypeItemMaterial;
    property Item1TypeItemMaterial:TSkinListItemMaterial read GetItem1TypeItemMaterial write SetItem1TypeItemMaterial;

    /// <summary>
    ///   <para>
    ///     空白项绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawSpaceParam:TDrawRectParam read FDrawSpaceParam write SetDrawSpaceParam;
    /// <summary>
    ///   <para>
    ///     是否简单绘制分组矩形
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsSimpleDrawGroupRoundRect:Boolean read FIsSimpleDrawGroupRoundRect write SetIsSimpleDrawGroupRoundRect;

    /// <summary>
    ///   <para>
    ///     是否简单绘制分组开始分隔线
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsSimpleDrawGroupBeginDevide:Boolean read FIsSimpleDrawGroupBeginDevide write SetIsSimpleDrawGroupBeginDevide ;//default True;
    //
    /// <summary>
    ///   <para>
    ///     是否简单绘制分组结束分隔线
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsSimpleDrawGroupEndDevide:Boolean read FIsSimpleDrawGroupEndDevide write SetIsSimpleDrawGroupEndDevide ;//default True;

    /// <summary>
    ///   <para>
    ///     分组开始分隔线绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawGroupBeginDevideParam:TDrawRectParam read FDrawGroupBeginDevideParam write SetDrawGroupBeginDevideParam;
    /// <summary>
    ///   <para>
    ///     分组结束分隔线绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawGroupEndDevideParam:TDrawRectParam read FDrawGroupEndDevideParam write SetDrawGroupEndDevideParam;



    /// <summary>
    ///   <para>
    ///     是否自动调整ItemDesignerPanel宽度和高度
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsAutoAdjustItemDesignerPanelSize:Boolean read FIsAutoAdjustItemDesignerPanelSize write FIsAutoAdjustItemDesignerPanelSize ;//default True;
  end;




  TSkinVirtualListDefaultType=class(TSkinCustomListDefaultType)
  protected

    FSkinVirtualListIntf:ISkinVirtualList;

    FOriginStaticRectCorners:TDRPRectCorners;
    FIsGroupBegin:Boolean;
    FIsGroupEnd:Boolean;


    //按回车键结束编辑
    procedure DoAutoEditControlKeyUp(Sender:TObject; var Key: Word;var KeyChar: Char; Shift: TShiftState);
    procedure DoAutoEditControlClosePopup(Sender:TObject);

    function DoProcessItemCustomMouseDown(AMouseOverItem:TBaseSkinItem;
                                          AItemDrawRect:TRectF;
                                          Button: TMouseButton; Shift: TShiftState;X, Y: Double):Boolean;override;
    function DoProcessItemCustomMouseUp(AMouseDownItem:TBaseSkinItem;
                                        Button: TMouseButton;
                                        Shift: TShiftState;X, Y: Double):Boolean;override;
    function DoProcessItemCustomMouseMove(AMouseOverItem:TBaseSkinItem;
                                          Shift: TShiftState;X,Y:Double):Boolean;override;
    procedure DoProcessItemCustomMouseLeave(AMouseLeaveItem:TBaseSkinItem);override;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  protected
    function GetSkinMaterial:TSkinVirtualListDefaultMaterial;
    //自动调整列表项设计器的宽度和高度
    procedure AutoAdjustItemDesignerPanelSize(AItemDesignerPanel:TSkinItemDesignerPanel;AItem:TSkinItem);virtual;
    //决定列表项所使用的素材
    function DecideItemMaterial(AItem:TBaseSkinItem;ASkinMaterial:TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;override;
    //处理Item绘制参数
    procedure ProcessItemDrawParams(ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    AItemEffectStates:TDPEffectStates);override;
    procedure MarkAllListItemTypeStyleSettingCacheUnUsed(
                        //起始下标
                        ADrawStartIndex:Integer;
                        ADrawEndIndex:Integer);override;
    //准备
    function CustomDrawItemBegin(ACanvas: TDrawCanvas;
                                  AItemIndex:Integer;
                                  AItem:TBaseSkinItem;
                                  AItemDrawRect:TRectF;
                                  ASkinMaterial:TSkinCustomListDefaultMaterial;
                                  const ADrawRect: TRectF;
                                  ACustomListPaintData:TPaintData;
                                  ASkinItemMaterial:TBaseSkinListItemMaterial;
                                  AItemEffectStates:TDPEffectStates;
                                  AIsDrawItemInteractiveState:Boolean): Boolean;override;
    //绘制内容
    function CustomDrawItemContent(ACanvas: TDrawCanvas;
                                    AItemIndex:Integer;
                                    AItem:TBaseSkinItem;
                                    AItemDrawRect:TRectF;
                                    ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    const ADrawRect: TRectF;
                                    ACustomListPaintData:TPaintData;
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    AItemEffectStates:TDPEffectStates;
                                    AIsDrawItemInteractiveState:Boolean): Boolean;override;
    //绘制起始分隔线
    function CustomDrawItemEnd(ACanvas: TDrawCanvas;
                                AItemIndex:Integer;
                                AItem:TBaseSkinItem;
                                AItemDrawRect:TRectF;
                                ASkinMaterial:TSkinCustomListDefaultMaterial;
                                const ADrawRect: TRectF;
                                ACustomListPaintData:TPaintData;
                                ASkinItemMaterial:TBaseSkinListItemMaterial;
                                AItemEffectStates:TDPEffectStates;
                                AIsDrawItemInteractiveState:Boolean): Boolean;override;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinVirtualList=class(TSkinCustomList,ISkinVirtualList,ISkinItems)
  private
    //准备平拖事件(可以根据Item设置ItemPanDragDesignerPanel)
    FOnPrepareItemPanDrag:TVirtualListPrepareItemPanDragEvent;

    //点击列表项事件
    FOnClickItem:TVirtualListClickItemEvent;
    //长按列表项事件
    FOnLongTapItem:TVirtualListDoItemEvent;
    //点击列表项事件
    FOnClickItemEx:TVirtualListClickItemExEvent;
    //列表项被选中的事件
    FOnSelectedItem:TVirtualListDoItemEvent;
    //中间列表项更改事件
    FOnCenterItemChange:TVirtualListDoItemEvent;


    //开始编辑列表项事件
    FOnStartEditingItem:TVirtualListEditingItemEvent;
    //结束编辑列表项事件
    FOnStopEditingItem:TVirtualListEditingItemEvent;


    //
    FOnGetItemBufferCacheTag:TVirtualListGetItemBufferCacheTagEvent;
    //绘制列表项
    FOnPrepareDrawItem: TVirtualListDrawItemEvent;
    FOnAdvancedDrawItem: TVirtualListDrawItemEvent;


    function GetOnPrepareItemPanDrag:TVirtualListPrepareItemPanDragEvent;

    function GetOnSelectedItem: TVirtualListDoItemEvent;
    function GetOnClickItem: TVirtualListClickItemEvent;
    function GetOnLongTapItem: TVirtualListDoItemEvent;
    function GetOnClickItemEx: TVirtualListClickItemExEvent;
    function GetOnCenterItemChange:TVirtualListDoItemEvent;

    function GetOnGetItemBufferCacheTag:TVirtualListGetItemBufferCacheTagEvent;
    function GetOnPrepareDrawItem: TVirtualListDrawItemEvent;
    function GetOnAdvancedDrawItem: TVirtualListDrawItemEvent;

    function GetOnStartEditingItem: TVirtualListEditingItemEvent;
    function GetOnStopEditingItem: TVirtualListEditingItemEvent;


    function GetVirtualListProperties:TVirtualListProperties;
    procedure SetVirtualListProperties(Value:TVirtualListProperties);

  protected
    procedure ReadState(Reader: TReader); override;

    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;

  protected
    function GetItems:TBaseSkinItems;
    property Items:TBaseSkinItems read GetItems;
  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);override;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);override;
  public
    function SelfOwnMaterialToDefault:TSkinVirtualListDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinVirtualListDefaultMaterial;
    function Material:TSkinVirtualListDefaultMaterial;
  public
    property Prop:TVirtualListProperties read GetVirtualListProperties write SetVirtualListProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TVirtualListProperties read GetVirtualListProperties write SetVirtualListProperties;

    //垂直滚动条
    property VertScrollBar;

    //水平滚动条
    property HorzScrollBar;




    //点击列表项事件
    property OnClickItem:TVirtualListClickItemEvent read GetOnClickItem write FOnClickItem;
    //长按列表项事件
    property OnLongTapItem:TVirtualListDoItemEvent read GetOnLongTapItem write FOnLongTapItem;
    //点击列表项事件
    property OnClickItemEx:TVirtualListClickItemExEvent read GetOnClickItemEx write FOnClickItemEx;
    //列表项被选中事件
    property OnSelectedItem:TVirtualListDoItemEvent read GetOnSelectedItem write FOnSelectedItem;

    //中间项列表项事件
    property OnCenterItemChange:TVirtualListDoItemEvent read GetOnCenterItemChange write FOnCenterItemChange;


    property OnStartEditingItem:TVirtualListEditingItemEvent read GetOnStartEditingItem write FOnStartEditingItem;
    property OnStopEditingItem:TVirtualListEditingItemEvent read GetOnStopEditingItem write FOnStopEditingItem;


    //获取缓存标记,判断是否需要重新调用OnPrepareDrawItem事件
    property OnGetItemBufferCacheTag:TVirtualListGetItemBufferCacheTagEvent read GetOnGetItemBufferCacheTag write FOnGetItemBufferCacheTag;
    //每次绘制列表项之前准备
    property OnPrepareDrawItem:TVirtualListDrawItemEvent read GetOnPrepareDrawItem write FOnPrepareDrawItem;
    //增强绘制列表项事件
    property OnAdvancedDrawItem:TVirtualListDrawItemEvent read GetOnAdvancedDrawItem write FOnAdvancedDrawItem;

    //准备平拖事件(可以根据Item设置ItemPanDragDesignerPanel)
    property OnPrepareItemPanDrag:TVirtualListPrepareItemPanDragEvent read GetOnPrepareItemPanDrag write FOnPrepareItemPanDrag;

  end;


  {$IFDEF VCL}
  TSkinWinVirtualList=class(TSkinVirtualList)
  end;
  {$ENDIF VCL}



var
  GlobalSkinItemMaterialStylePackage:TSkinItemMaterialStylePackage;

implementation







{ TVirtualListProperties }

constructor TVirtualListProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);

  if Not ASkinControl.GetInterface(IID_ISkinVirtualList,Self.FSkinVirtualListIntf) then
  begin
    ShowException('This Component Do not Support ISkinVirtualList Interface');
  end
  else
  begin
    IsItemMouseEventNeedCallPrepareDrawItem:=True;



    FDefaultItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitDefault);
    FItem1ItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitItem1);
    FItem2ItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitItem2);
    FItem3ItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitItem3);
    FItem4ItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitItem4);
    FHeaderItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitHeader);
    FFooterItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitFooter);
    FSearchBarItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitSearchBar);



    FListItemTypeStyleSettingList:=TListItemTypeStyleSettingList.Create(ooReference);
    FListItemTypeStyleSettingList.Add(FDefaultItemStyleSetting);
    FListItemTypeStyleSettingList.Add(FItem1ItemStyleSetting);
    FListItemTypeStyleSettingList.Add(FItem2ItemStyleSetting);
    FListItemTypeStyleSettingList.Add(FItem3ItemStyleSetting);
    FListItemTypeStyleSettingList.Add(FItem4ItemStyleSetting);
    FListItemTypeStyleSettingList.Add(FHeaderItemStyleSetting);
    FListItemTypeStyleSettingList.Add(FFooterItemStyleSetting);
    FListItemTypeStyleSettingList.Add(FSearchBarItemStyleSetting);



    //列表项颜色类型
    FItemColorType:=TSkinItemColorType.sictNone;



    FIconSkinImageListChangeLink:=TSkinObjectChangeLink.Create;
    FIconSkinImageListChangeLink.OnChange:=OnIconSkinImageListChange;
    FIconSkinImageListChangeLink.OnDestroy:=OnIconSkinImageListChange;

    FEditingItem_BindingControl:=nil;
    FEditingItem_BindingControlIntf:=nil;
    FEditingItem_FieldName:='';
//    FEditingItem_DataType:=idtNone;
//    FEditingItem_SubItemsIndex:=-1;


    FListLayoutsManager.OnGetItemIconSkinImageList:=DoGetItemDefaultSkinImageList;
    FListLayoutsManager.OnGetItemIconDownloadPictureManager:=DoGetItemDefaultDownloadPictureManager;


  end;
end;

procedure TVirtualListProperties.OnIconSkinImageListChange(Sender: TObject);
begin
//  if Sender = FIconSkinImageList then
//  begin
//    if FIconSkinImageList.SkinObjectChangeManager.IsDestroy then
//    begin
//      Self.SetIconSkinImageList(nil);
//    end;
//  end;
  Invalidate;
end;

procedure TVirtualListProperties.OnIconSkinImageListDestroy(Sender: TObject);
begin
  FIconSkinImageList:=nil;
//  if Sender = FIconSkinImageList.SkinObjectChangeManager then
//  begin
//    if FIconSkinImageList.SkinObjectChangeManager.IsDestroy then
//    begin
//      Self.SetIconSkinImageList(nil);
//    end;
//  end;
  Invalidate;
end;

function TVirtualListProperties.DecideItemDesignerPanel(AItem: TSkinItem): TSkinItemDesignerPanel;
begin
  Result:=nil;

//  AItem.FDrawListItemTypeStyleSetting:=nil;


//  if Result=nil then
//  begin
    case AItem.ItemType of
      sitDefault:
      begin
        Result:=Self.FDefaultItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitItem1:
      begin
        Result:=Self.FItem1ItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitItem2:
      begin
        Result:=Self.FItem2ItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitItem3:
      begin
        Result:=Self.FItem3ItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitItem4:
      begin
        Result:=Self.FItem4ItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitHeader:
      begin
        Result:=Self.FHeaderItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitFooter:
      begin
        Result:=Self.FFooterItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitSearchBar:
      begin
        Result:=Self.FSearchBarItemStyleSetting.GetInnerItemDesignerPanel(AItem);
      end;
      sitUseDrawItemDesignerPanel:
      begin
        Result:=TSkinItemDesignerPanel(AItem.FDrawItemDesignerPanel);
      end;
    end;
//  end;
end;

destructor TVirtualListProperties.Destroy;
begin
  try

    SetIconSkinImageList(nil);

    FreeAndNil(FIconSkinImageListChangeLink);


    SetFooterDesignerPanel(nil);
    SetSearchBarDesignerPanel(nil);
    SetItemDesignerPanel(nil);
    SetItem1DesignerPanel(nil);
    SetItem2DesignerPanel(nil);
    SetItem3DesignerPanel(nil);
    SetItem4DesignerPanel(nil);
    SetHeaderDesignerPanel(nil);



    FreeAndNil(FDefaultItemStyleSetting);
    FreeAndNil(FItem1ItemStyleSetting);
    FreeAndNil(FItem2ItemStyleSetting);
    FreeAndNil(FItem3ItemStyleSetting);
    FreeAndNil(FItem4ItemStyleSetting);
    FreeAndNil(FHeaderItemStyleSetting);
    FreeAndNil(FFooterItemStyleSetting);
    FreeAndNil(FSearchBarItemStyleSetting);

    FreeAndNil(FListItemTypeStyleSettingList);


    FEditingItem_BindingControl:=nil;
    FEditingItem_BindingControlIntf:=nil;
    FEditingItem_FieldName:='';
//    FEditingItem_DataType:=idtNone;
//    FEditingItem_SubItemsIndex:=-1;


    inherited;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TVirtualListProperties.Destroy');
    end;
  end;
end;

procedure TVirtualListProperties.DoGetItemDefaultSkinImageList(Sender: TObject; var ASkinImageList: TSkinBaseImageList);
begin
  //获取默认的图标列表
  ASkinImageList:=Self.FIconSkinImageList;
end;

procedure TVirtualListProperties.DoGetItemDefaultDownloadPictureManager(Sender: TObject; var ADownloadPictureManager: TBaseDownloadPictureManager);
begin
  //获取默认的图标列表
  ADownloadPictureManager:=Self.FIconDownloadPictureManager;
end;

procedure TVirtualListProperties.DoMouseOverItemChange(ANewItem,AOldItem: TBaseSkinItem);
var
  AMouseOverItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
begin
  inherited;

  if (Self.FMouseOverItem<>nil)
    and (Self.MouseOverItem.FDrawItemDesignerPanel<>nil)
    and (TSkinItemDesignerPanel(Self.MouseOverItem.FDrawItemDesignerPanel).SkinControlType<>nil) then
  begin
    AMouseOverItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.MouseOverItem.FDrawItemDesignerPanel);
    AMouseOverItemDrawItemDesignerPanel.SkinControlType.CustomMouseLeave;
  end;

end;

procedure TVirtualListProperties.DoSetValueToEditingItem;
begin
  if FEditingItem_EditControl_ItemEditorIntf<>nil then
  begin
    //将编辑控件的值赋回给列表项的属性
//    SetItemValueByItemDataType(
//                                TSkinItem(FEditingItem),
//                                FEditingItem_DataType,
//                                FEditingItem_SubItemsIndex,
//                                FEditingItem_EditControl_ItemEditorIntf.EditGetValue
//                                );

    FEditingItem.SetValueByBindItemField(FEditingItem_FieldName,FEditingItem_EditControl_ItemEditorIntf.EditGetValue);
  end
  else
  begin
//    SetItemValueByItemDataType(TSkinItem(FEditingItem),
//                                FEditingItem_DataType,
//                                FEditingItem_SubItemsIndex,
//                                GetValueFromEditControl(FEditingItem_EditControl)
//                                );
    FEditingItem.SetValueByBindItemField(FEditingItem_FieldName,GetValueFromEditControl(FEditingItem_EditControl));
  end;
end;

procedure TVirtualListProperties.DoStopEditingItemEnd;
begin
  FEditingItem_BindingControl:=nil;
  FEditingItem_BindingControlIntf:=nil;
  FEditingItem_FieldName:='';
//  FEditingItem_DataType:=idtNone;
//  FEditingItem_SubItemsIndex:=-1;
end;

function TVirtualListProperties.GetListLayoutsManager:TSkinVirtualListLayoutsManager;
begin
  Result:=TSkinVirtualListLayoutsManager(FListLayoutsManager);
end;

function TVirtualListProperties.GetComponentClassify: String;
begin
  Result:='SkinVirtualList';
end;

procedure TVirtualListProperties.CallOnClickItemEvent(AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnClickItem) then
  begin
    Self.FSkinVirtualListIntf.OnClickItem(TSkinItem(AItem));
  end;
end;

function TVirtualListProperties.CalcItemAutoSize(AItem: TSkinItem;
    const ABottomSpace:TControlSize=10): TSizeF;
var
  AItemDrawRect:TRect;
  AListItemTypeStyleSetting:TListItemTypeStyleSetting;
begin
  //默认值
  Result.cx:=AItem.Width;
  Result.cy:=AItem.Height;

  AListItemTypeStyleSetting:=
    Self.FListItemTypeStyleSettingList.FindByItemType(AItem.ItemType);

  if AListItemTypeStyleSetting<>nil then
  begin
    Result:=AListItemTypeStyleSetting.CalcItemAutoSize(
                AItem,ABottomSpace);
  end;
end;

procedure TVirtualListProperties.CallOnAdvancedDrawItemEvent(Sender: TObject;
  ACanvas: TDrawCanvas;
  AItem: TBaseSkinItem;
  AItemDrawRect: TRectF);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnAdvancedDrawItem) then
  begin
    Self.FSkinVirtualListIntf.OnAdvancedDrawItem(Self,
                  ACanvas,
                  TItemDesignerPanel(TSkinItem(AItem).FDrawItemDesignerPanel),
                  TSkinItem(AItem),
                  RectF2Rect(AItemDrawRect));
  end;
end;

procedure TVirtualListProperties.CallOnCenterItemChangeEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnCenterItemChange) then
  begin
    Self.FSkinVirtualListIntf.OnCenterItemChange(Self,TSkinItem(AItem));
  end;
end;

procedure TVirtualListProperties.CallOnClickItemExEvent(AItem: TBaseSkinItem; X,Y: Double);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnClickItemEx) then
  begin
    Self.FSkinVirtualListIntf.OnClickItemEx(Self.FSkinControl,
                                            TSkinItem(AItem),
                                            X-AItem.ItemDrawRect.Left,
                                            Y-AItem.ItemDrawRect.Top);
  end;
end;

procedure TVirtualListProperties.CallOnLongTapItemEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnLongTapItem) and (MouseDownItem<>nil) then
  begin
    FHasCalledOnLongTapItem:=True;
    //调用了LongTap之后,就不再调用ClickItem了
    Self.FSkinVirtualListIntf.OnLongTapItem(Self,TSkinItem(AItem));
  end;
end;

procedure TVirtualListProperties.CallOnPrepareDrawItemEvent(
  Sender: TObject;
  ACanvas: TDrawCanvas;
  AItem: TBaseSkinItem;
  AItemDrawRect: TRectF;
  AIsDrawItemInteractiveState:Boolean);
var
  AItemBufferCacheTag:Integer;
  AItemDesignerPanel:TSkinItemDesignerPanel;
//  AItemListItemTypeStyleSetting:TListItemTypeStyleSetting;
begin
  AItemDesignerPanel:=TSkinItemDesignerPanel(TSkinItem(AItem).FDrawItemDesignerPanel);
//  AItemListItemTypeStyleSetting:=TListItemTypeStyleSetting(TSkinItem(AItem).FDrawListItemTypeStyleSetting);


  if (AItemDesignerPanel<>nil) then
  begin
      //因为每次绘制时调用OnPrepareDrawItem事件非常耗时,
      //因此当启用缓存的时候,不需要每次都调用它,提高效率

      //-1表示需要重画
      //默认不缓存
      AItemBufferCacheTag:=-1;


//      //使用了Style,
//      //而且使用了缓存
//      if (AItemListItemTypeStyleSetting<>nil)
//        and AItemListItemTypeStyleSetting.IsUseCache
//        and (AItemListItemTypeStyleSetting.Style<>'') then
//      begin
          //默认缓存
          AItemBufferCacheTag:=Integer(AItem);
//          //使用了ListItemStyle且IsCache启用了之后才需要缓存功能
//          //不然都是所有Item共用了一个ItemDesignerPanel
//          //获取缓存标记
//          if Assigned(Self.FSkinVirtualListIntf.OnGetItemBufferCacheTag) then
//          begin
//            Self.FSkinVirtualListIntf.OnGetItemBufferCacheTag(
//                    Self,
//                    TSkinItem(AItem),
//                    AItemBufferCacheTag);
//          end;
//      end;




      //默认每次都要重画
      //判断是否需要重新调用OnPrepareDrawItem
      if (AItemBufferCacheTag=-1)
        //缓存标记改过了,比如Item.DataObject原来绑定的是A,后面绑定的B,缓存标记使用的是DataObject
        or (AItemDesignerPanel.Prop.LastItemBufferCacheTag<>AItemBufferCacheTag)
        //Item属性改过了
        or TSkinItem(AItem).IsBufferNeedChange
        //绘制区域的尺寸改过了要重绘
        or not IsSameDouble(TSkinItem(AItem).FLastItemDrawRect.Width,AItemDrawRect.Width)
        or not IsSameDouble(TSkinItem(AItem).FLastItemDrawRect.Height,AItemDrawRect.Height) then
      begin
              TSkinItem(AItem).FLastItemDrawRect:=AItemDrawRect;

//              uBaseLog.HandleException(nil,'TVirtualListProperties.CallOnPrepareDrawItemEvent '+Self.FSkinControl.Name+' '+TSkinItem(AItem).Caption);

              AItemDesignerPanel.Prop.LastItem:=AItem;
//              AItemDesignerPanel.Prop.LastCol:=nil;
              AItemDesignerPanel.Prop.LastItemBufferCacheTag:=AItemBufferCacheTag;
              TSkinItem(AItem).IsBufferNeedChange:=False;


              LockSkinControlInvalidate;
              try

                //自动绑定值,把Item的属性值赋给ItemDesignerPanel上面的控件
  //              Self.FSkinVirtualListIntf.Prop.BindItemDesignerPanelAndItem(
  //                    AItemDesignerPanel,
  //                    AItem,
  //                    AIsDrawItemInteractiveState);
                AItemDesignerPanel.Prop.SetControlsValueByItem(
                      Self.SkinImageList,
                      TSkinItem(AItem),
                      AIsDrawItemInteractiveState);


                //调用ListBox的OnPrepareDrawItem
                if Assigned(Self.FSkinVirtualListIntf.OnPrepareDrawItem) then
                begin
                  //手动绑定值
                  Self.FSkinVirtualListIntf.OnPrepareDrawItem(Self,
                          ACanvas,
                          TItemDesignerPanel(AItemDesignerPanel),
                          TSkinItem(AItem),
                          RectF2Rect(AItemDrawRect));
                end;


                //调用设计面板的OnPrepareDrawItem
                if Assigned(AItemDesignerPanel.OnPrepareDrawItem) then
                begin
                  AItemDesignerPanel.OnPrepareDrawItem(Self,ACanvas,
                                            TSkinItemDesignerPanel(TSkinItem(AItem).FDrawItemDesignerPanel),
                                            TSkinItem(AItem),
                                            AItemDrawRect);
                end;
              finally
                UnLockSkinControlInvalidate;
              end;
      end;

  end
  else
  begin
      //不使用ItemDesignerPanel绘制
      if Assigned(Self.FSkinVirtualListIntf.OnPrepareDrawItem) then
      begin
        //手动绑定值
        Self.FSkinVirtualListIntf.OnPrepareDrawItem(Self,
                ACanvas,
                nil,
                TSkinItem(AItem),
                RectF2Rect(AItemDrawRect));
      end;
  end;
end;

procedure TVirtualListProperties.CallOnPrepareItemPanDrag(Sender: TObject;
  AItem: TBaseSkinItem; var AItemIsCanPanDrag: Boolean);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnPrepareItemPanDrag) then
  begin
    Self.FSkinVirtualListIntf.OnPrepareItemPanDrag(Self,TSkinItem(AItem),AItemIsCanPanDrag);
  end;
end;

procedure TVirtualListProperties.CallOnStartEditingItemEvent(Sender: TObject;
  AItem: TBaseSkinItem; AEditControl: TChildControl);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnStartEditingItem) then
  begin
    FSkinVirtualListIntf.OnStartEditingItem(Sender,TSkinItem(AItem),FEditingItem_BindingControl,AEditControl);
  end;
end;

procedure TVirtualListProperties.CallOnStopEditingItemEvent(Sender: TObject;
  AItem: TBaseSkinItem; AEditControl: TChildControl);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnStopEditingItem) then
  begin
    FSkinVirtualListIntf.OnStopEditingItem(Sender,TSkinItem(AItem),FEditingItem_BindingControl,AEditControl);
  end;
end;

procedure TVirtualListProperties.ClearItemTypeStyles;
begin
  //设置默认列表项的风格
  FDefaultItemStyleSetting.Clear;
  FItem1ItemStyleSetting.Clear;
  FItem2ItemStyleSetting.Clear;
  FItem3ItemStyleSetting.Clear;
  FItem4ItemStyleSetting.Clear;
  FHeaderItemStyleSetting.Clear;
  FFooterItemStyleSetting.Clear;
  FSearchBarItemStyleSetting.Clear;
end;

procedure TVirtualListProperties.CallOnSelectedItemEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinVirtualListIntf.OnSelectedItem) then
  begin
    FSkinVirtualListIntf.OnSelectedItem(Sender,TSkinItem(AItem));
  end;
end;

function TVirtualListProperties.HasOnLongTapItemEvent: Boolean;
begin
  Result:=Assigned(Self.FSkinVirtualListIntf.OnLongTapItem);
end;

function TVirtualListProperties.IsItemTypeStyleExists(AItemStyle: String): TListItemTypeStyleSetting;
begin
  Result:=nil;
  if FDefaultItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FDefaultItemStyleSetting;
  end
  else if FItem1ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FItem1ItemStyleSetting;
  end
  else if FItem2ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FItem2ItemStyleSetting;
  end
  else if FItem3ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FItem3ItemStyleSetting;
  end
  else if FItem4ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FItem4ItemStyleSetting;
  end
  else if FHeaderItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FHeaderItemStyleSetting;
  end
  else if FFooterItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FFooterItemStyleSetting;
  end
  else if FSearchBarItemStyleSetting.Style=AItemStyle then
  begin
    Result:=FSearchBarItemStyleSetting;
  end
  ;

end;

function TVirtualListProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TSkinItems;
end;

function TVirtualListProperties.GetItemStyleByItemType(
  AItemType: TSkinItemType): String;
begin
  Result:='';
  if AItemType=sitDefault then
  begin
    Result:=FDefaultItemStyleSetting.Style;
  end
  else if AItemType=sitItem1 then
  begin
    Result:=FItem1ItemStyleSetting.Style;
  end
  else if AItemType=sitItem2 then
  begin
    Result:=FItem2ItemStyleSetting.Style;
  end
  else if AItemType=sitItem3 then
  begin
    Result:=FItem3ItemStyleSetting.Style;
  end
  else if AItemType=sitItem4 then
  begin
    Result:=FItem4ItemStyleSetting.Style;
  end
  else if AItemType=sitHeader then
  begin
    Result:=FHeaderItemStyleSetting.Style;
  end
  else if AItemType=sitFooter then
  begin
    Result:=FFooterItemStyleSetting.Style;
  end
  else if AItemType=sitSearchBar then
  begin
    Result:=FSearchBarItemStyleSetting.Style;
  end
  ;


end;

function TVirtualListProperties.GetItemTypeByStyle(AItemStyle: String): TSkinItemType;
begin
  Result:=sitDefault;
  if FDefaultItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitDefault;
  end
  else if FItem1ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitItem1;
  end
  else if FItem2ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitItem2;
  end
  else if FItem3ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitItem3;
  end
  else if FItem4ItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitItem4;
  end
  else if FHeaderItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitHeader;
  end
  else if FFooterItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitFooter;
  end
  else if FSearchBarItemStyleSetting.Style=AItemStyle then
  begin
    Result:=sitSearchBar;
  end
  ;

end;

//function TVirtualListProperties.GetItemTypeStyleCacheFrame(
//  AItemType: TSkinItemType): TFrame;
//var
//  AListItemTypeStyleSetting:TListItemTypeStyleSetting;
//begin
//  //默认值
//  Result:=nil;
//
//  AListItemTypeStyleSetting:=
//    Self.FListItemTypeStyleSettingList.FindByItemType(AItem.ItemType);
//
//  if AListItemTypeStyleSetting<>nil then
//  begin
//    Result:=AListItemTypeStyleSetting.CalcItemAutoSize(
//                AItem,ABottomSpace);
//  end;
//end;

function TVirtualListProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinVirtualListLayoutsManager;
end;

function TVirtualListProperties.GetDefaultItemStyle: String;
begin
  Result:=FDefaultItemStyleSetting.Style;
end;

function TVirtualListProperties.GetDefaultItemStyleConfig: TStringList;
begin
  Result:=FDefaultItemStyleSetting.FConfig;
end;

function TVirtualListProperties.GetEditingItem: TSkinItem;
begin
  Result:=TSkinItem(FEditingItem);
end;

function TVirtualListProperties.GetFooterDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FFooterItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetFooterItemStyle: String;
begin
  Result:=FFooterItemStyleSetting.Style;
end;

function TVirtualListProperties.GetFooterItemStyleConfig: TStringList;
begin
  Result:=FFooterItemStyleSetting.FConfig;
end;

function TVirtualListProperties.GetHeaderDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FHeaderItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetHeaderItemStyle: String;
begin
  Result:=FHeaderItemStyleSetting.Style;
end;

function TVirtualListProperties.GetHeaderItemStyleConfig: TStringList;
begin
  Result:=FHeaderItemStyleSetting.FConfig;
end;

procedure TVirtualListProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
//  FIsAutoSelected:=TVirtualListProperties(Src).FIsAutoSelected;
//
//
//  FItemDrawType:=TVirtualListProperties(Src).FItemDrawType;
//
//  FItems.Assign(TVirtualListProperties(Src).FItems);
//
//  FListLayoutsManager.StaticItemWidth:=TVirtualListProperties(Src).FListLayoutsManager.StaticItemWidth;
//  FListLayoutsManager.StaticItemHeight:=TVirtualListProperties(Src).FListLayoutsManager.StaticItemHeight;
//  FListLayoutsManager.StaticItemSizeCalcType:=TVirtualListProperties(Src).FListLayoutsManager.StaticItemSizeCalcType;
//
//  FIconSkinImageList:=TVirtualListProperties(Src).FIconSkinImageList;
//  SetIconSkinImageList(FIconSkinImageList);
//
//
//
//  FItemDesignerPanel:=TVirtualListProperties(Src).FItemDesignerPanel;
//  FItem1DesignerPanel:=TVirtualListProperties(Src).FItem1DesignerPanel;
//  FItem2DesignerPanel:=TVirtualListProperties(Src).FItem2DesignerPanel;
//  FItem3DesignerPanel:=TVirtualListProperties(Src).FItem3DesignerPanel;
//  FItem4DesignerPanel:=TVirtualListProperties(Src).FItem4DesignerPanel;
//  FHeaderDesignerPanel:=TVirtualListProperties(Src).FHeaderDesignerPanel;
//  FFooterDesignerPanel:=TVirtualListProperties(Src).FFooterDesignerPanel;
//  FSearchBarDesignerPanel:=TVirtualListProperties(Src).FSearchBarDesignerPanel;
//  FItemPanDragDesignerPanel:=TVirtualListProperties(Src).FItemPanDragDesignerPanel;
//
//
//
//
//  //列表项平拖的方向
//  FItemPanDragGestureDirection:=TVirtualListProperties(Src).FItemPanDragGestureDirection;
//
////  //最大的平拖位置
////  FMaxItemPanDragPosition:=TVirtualListProperties(Src).FMaxItemPanDragPosition;
////  //最小的平拖位置
////  FMinItemPanDragPosition:=TVirtualListProperties(Src).FMinItemPanDragPosition;
//
//
//  //是否启用平拖
//  FEnableItemPanDrag:=TVirtualListProperties(Src).FEnableItemPanDrag;
//
//
////  //开始平拖的增量
////  FDecideStartItemPanDragPosition:=TVirtualListProperties(Src).FDecideStartItemPanDragPosition;


end;

//procedure TVirtualListProperties.BindItemDesignerPanelAndItem(
//                      AItemDesignerPanel: TSkinItemDesignerPanel;
//                      AItem: TSkinItem;
//                      AIsDrawItemInteractiveState:Boolean);
//var
//  I: Integer;
//  AControlItem:TItemBindingStringsControlItem;
//begin
//  //给设计面板上的控件赋值
//  if AItemDesignerPanel.Prop.ItemCaptionBindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemCaptionIntf.BindingItemText('ItemCaption',AItem.Caption,AItem,AIsDrawItemInteractiveState);
//  end;
//  if AItemDesignerPanel.Prop.ItemDetailBindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemDetailIntf.BindingItemText('ItemDetail',AItem.Detail,AItem,AIsDrawItemInteractiveState);
//  end;
//  if AItemDesignerPanel.Prop.ItemDetail1BindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemDetail1Intf.BindingItemText('ItemDetail1',AItem.Detail1,AItem,AIsDrawItemInteractiveState);
//  end;
//  if AItemDesignerPanel.Prop.ItemDetail2BindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemDetail2Intf.BindingItemText('ItemDetail2',AItem.Detail2,AItem,AIsDrawItemInteractiveState);
//  end;
//  if AItemDesignerPanel.Prop.ItemDetail3BindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemDetail3Intf.BindingItemText('ItemDetail3',AItem.Detail3,AItem,AIsDrawItemInteractiveState);
//  end;
//  if AItemDesignerPanel.Prop.ItemDetail4BindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemDetail4Intf.BindingItemText('ItemDetail4',AItem.Detail4,AItem,AIsDrawItemInteractiveState);
//  end;
//  if AItemDesignerPanel.Prop.ItemDetail5BindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemDetail5Intf.BindingItemText('ItemDetail5',AItem.Detail5,AItem,AIsDrawItemInteractiveState);
//  end;
//  if AItemDesignerPanel.Prop.ItemDetail6BindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemDetail6Intf.BindingItemText('ItemDetail6',AItem.Detail6,AItem,AIsDrawItemInteractiveState);
//  end;
//
//  //设置控件是否隐藏或显示
//  if AItemDesignerPanel.Prop.ItemAccessoryMoreBindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemAccessoryMoreIntf.Visible:=(AItem.Accessory<>satNone);
//  end;
//
//
//  if AItemDesignerPanel.Prop.ItemIconBindingControl<>nil then
//  begin
//    //必须用
//    AItemDesignerPanel.Prop.ItemIconIntf.BindingItemIcon(
//                  AItem.StaticIcon,
//                  Self.FIconSkinImageList,
//                  AItem.IconImageIndex,
//                  AItem.IconRefPicture,
//                  AIsDrawItemInteractiveState);
//  end;
//
//  if AItemDesignerPanel.Prop.ItemPicBindingControl<>nil then
//  begin
//    //必须用
//    AItemDesignerPanel.Prop.ItemPicIntf.BindingItemIcon(
//                  AItem.StaticPic,
//                  nil,
//                  AItem.PicImageIndex,
//                  AItem.PicRefPicture,
//                  AIsDrawItemInteractiveState);
//  end;
//
//  if AItemDesignerPanel.Prop.ItemCheckedBindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemCheckedIntf.BindingItemBool(AItem.Checked,AIsDrawItemInteractiveState);
//  end;
//
//  if AItemDesignerPanel.Prop.ItemSelectedBindingControl<>nil then
//  begin
//    AItemDesignerPanel.Prop.ItemSelectedIntf.BindingItemBool(AItem.Selected,AIsDrawItemInteractiveState);
//  end;
//
//
//  for I := 0 to AItemDesignerPanel.Prop.ItemStringsBindingControlCollection.Count-1 do
//  begin
//    AControlItem:=AItemDesignerPanel.Prop.ItemStringsBindingControlCollection[I];
//    if AControlItem.Intf<>nil then
//    begin
//      if (AControlItem.StringsIndex>-1)
//        and (AControlItem.StringsIndex<AItem.SubItems.Count) then
//      begin
//        AControlItem.Intf.BindingItemText(
//              'ItemSubItems'+IntToStr(AControlItem.StringsIndex),
//              AItem.SubItems[AControlItem.StringsIndex],
//              AItem,
//              AIsDrawItemInteractiveState);
//      end
//      else
//      begin
//        AControlItem.Intf.BindingItemText(
//              'ItemSubItems'+IntToStr(AControlItem.StringsIndex),
//              '',
//              AItem,
//              AIsDrawItemInteractiveState);
//      end;
//    end;
//  end;
//
//end;

procedure TVirtualListProperties.SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FDefaultItemStyleSetting.ItemDesignerPanel:=Value;
//  if FItemDesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FItemDesignerPanel);
//    FItemDesignerPanel:=Value;
//    FInnerItemDesignerPanel:=Value;
//    AddNewDesignerPanel(FItemDesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetItem1DesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FItem1ItemStyleSetting.ItemDesignerPanel:=Value;
//  if FItem1DesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FItem1DesignerPanel);
//    FItem1DesignerPanel:=Value;
//    FInnerItem1DesignerPanel:=Value;
//    AddNewDesignerPanel(FItem1DesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetItem1ItemStyle(const Value: String);
begin
  FItem1ItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetItem1ItemStyleConfig(
  const Value: TStringList);
begin
  FItem1ItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetItem2DesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FItem2ItemStyleSetting.ItemDesignerPanel:=Value;
//  if FItem2DesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FItem2DesignerPanel);
//    FItem2DesignerPanel:=Value;
//    FInnerItem2DesignerPanel:=Value;
//    AddNewDesignerPanel(FItem2DesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetItem2ItemStyle(const Value: String);
begin
  FItem2ItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetItem2ItemStyleConfig(
  const Value: TStringList);
begin
  FItem2ItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetItem3DesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FItem3ItemStyleSetting.ItemDesignerPanel:=Value;
//  if FItem3DesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FItem3DesignerPanel);
//    FItem3DesignerPanel:=Value;
//    FInnerItem3DesignerPanel:=Value;
//    AddNewDesignerPanel(FItem3DesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetItem3ItemStyle(const Value: String);
begin
  FItem3ItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetItem3ItemStyleConfig(
  const Value: TStringList);
begin
  FItem3ItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetItem4DesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FItem4ItemStyleSetting.ItemDesignerPanel:=Value;
//  if FItem4DesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FItem4DesignerPanel);
//    FItem4DesignerPanel:=Value;
//    FInnerItem4DesignerPanel:=Value;
//    AddNewDesignerPanel(FItem4DesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetItem4ItemStyle(const Value: String);
begin
  FItem4ItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetItem4ItemStyleConfig(
  const Value: TStringList);
begin
  FItem4ItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetHeaderDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FHeaderItemStyleSetting.ItemDesignerPanel:=Value;
//  if FHeaderDesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FHeaderDesignerPanel);
//    FHeaderDesignerPanel:=Value;
//    FInnerHeaderDesignerPanel:=Value;
//    AddNewDesignerPanel(FHeaderDesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetHeaderItemStyle(const Value: String);
begin
  FHeaderItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetHeaderItemStyleConfig(
  const Value: TStringList);
begin
  FHeaderItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetFooterDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FFooterItemStyleSetting.ItemDesignerPanel:=Value;
//  if FFooterDesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FFooterDesignerPanel);
//    FFooterDesignerPanel:=Value;
//    FInnerFooterDesignerPanel:=Value;
//    AddNewDesignerPanel(FFooterDesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetFooterItemStyle(const Value: String);
begin
  FFooterItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetFooterItemStyleConfig(
  const Value: TStringList);
begin
  FFooterItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetSearchBarDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FSearchBarItemStyleSetting.ItemDesignerPanel:=Value;
//  if FSearchBarDesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FSearchBarDesignerPanel);
//    FSearchBarDesignerPanel:=Value;
//    FInnerSearchBarDesignerPanel:=Value;
//    AddNewDesignerPanel(FSearchBarDesignerPanel);
//  end;
end;

procedure TVirtualListProperties.SetSearchBarItemStyle(const Value: String);
begin
  FSearchBarItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetSearchBarItemStyleConfig(
  const Value: TStringList);
begin
  FSearchBarItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetDefaultItemStyle(const Value: String);
begin
  FDefaultItemStyleSetting.Style:=Value;
end;

procedure TVirtualListProperties.SetDefaultItemStyleConfig(
  const Value: TStringList);
begin
  FDefaultItemStyleSetting.FConfig.Assign(Value);
end;

procedure TVirtualListProperties.SetIconDownloadPictureManager(const Value: TDownloadPictureManager);
begin
  FIconDownloadPictureManager := Value;
end;

procedure TVirtualListProperties.SetIconSkinImageList(const Value: TSkinImageList);
begin
  if FIconSkinImageList <> nil then
  begin
    FIconSkinImageList.UnRegisterChanges(FIconSkinImageListChangeLink);
    //FSkinImageList释放了通知FSkinControl
    FIconSkinImageList.RemoveFreeNotification(Self.FSkinControl);
  end;


  FIconSkinImageList:=Value;


  if FIconSkinImageList <> nil then
  begin
    FIconSkinImageList.RegisterChanges(FIconSkinImageListChangeLink);
    //FSkinImageList释放了通知FSkinControl
    FIconSkinImageList.FreeNotification(Self.FSkinControl);
  end;
  Invalidate;
end;

procedure TVirtualListProperties.StartEditingItem(AItem:TBaseSkinItem;
                                                  ABindingControl:TControl;
                                                  AEditControl:TControl;
                                                  X, Y: Double);
var
  ALeftOffset:Double;
  ATopOffset:Double;
  AParent:TControl;
  AEditingItem_EditControlPutRect:TRectF;
  AEditingItem_FieldName:String;
//  AEditingItem_DataType:TSkinItemDataType;
//  AEditingItem_SubItemsIndex:Integer;
begin
    if (FEditingItem=AItem)
      and (FEditingItem_EditControl=AEditControl) then
    begin
      //重复调用相同的编辑,那么直接退出
      Exit;
    end;


    //ABindingControl用来确定是编辑哪个属性

    //ABindingControl可能重复点击
    if (ABindingControl<>nil) and (AItem=nil) then
    begin
      Exit;
    end;


    if (AItem=nil) then
    begin
      Exit;
    end;

    if ABindingControl=nil then
    begin
      //如果没有传入绑定控件,那么退出
      //因为需要绑定控件判断出编辑的是Item的哪个属性
      Exit;
    end;


    if (AEditControl=nil) then
    begin
      //如果没有传入编辑控件,那么使用自身
      AEditControl:=ABindingControl;
    end;




    //获取相对位置
    //计算出BindingControl控件在设计面板中的相对位置
    //用来确定EditingControl的位置和尺寸
    ALeftOffset:=GetControlLeft(ABindingControl);
    ATopOffset:=GetControlTop(ABindingControl);
    AParent:=TControl(ABindingControl.Parent);
    while (AParent<>nil)
        and (AParent<>TSkinItem(AItem).FDrawItemDesignerPanel) do
    begin
      if AParent<>nil then
      begin
        ALeftOffset:=ALeftOffset+GetControlLeft(AParent);
        ATopOffset:=ATopOffset+GetControlTop(AParent);
      end;
      AParent:=TControl(AParent.Parent);
    end;
    AEditingItem_EditControlPutRect.Left:=ALeftOffset;
    AEditingItem_EditControlPutRect.Top:=ATopOffset;
    AEditingItem_EditControlPutRect.Width:=ABindingControl.Width;
    AEditingItem_EditControlPutRect.Height:=ABindingControl.Height;



    FEditingItem_BindingControl:=TControl(ABindingControl);
    FEditingItem_BindingControl.GetInterface(IID_ISkinControl,FEditingItem_BindingControlIntf);


    //获取绑定控件对应的数据类型,是Caption还是Detail
    AEditingItem_FieldName:=GetItemFieldNameByEditingControl(
                                   TSkinItemDesignerPanel(TSkinItem(AItem).FDrawItemDesignerPanel).Prop,
                                   ABindingControl);//,
//                                   AEditingItem_DataType,
//                                   AEditingItem_SubItemsIndex
//                                   );

    //没有找到对应的列表项的数据
    if //(AEditingItem_DataType=idtNone)
//      or (AEditingItem_DataType=idtSubItems)
//          and (AEditingItem_SubItemsIndex=-1)
      (AEditingItem_FieldName='') then
    begin
      Exit;
    end;


    //有这么一个方法,不需要BindingControl也能进行编辑了
    StartEditingItemByFieldName(AItem,
//                                AEditingItem_DataType,
//                                AEditingItem_SubItemsIndex,
                                AEditingItem_FieldName,
                                AEditControl,
                                AEditingItem_EditControlPutRect,
                                X,Y
                                );


end;

procedure TVirtualListProperties.StartEditingItemByFieldName(
                                                  AItem:TBaseSkinItem;
                                                  AEditItemFieldName:String;
//                                                  AEditItemDataType:TSkinItemDataType;
//                                                  AEditItemSubItemsIndex:Integer;
                                                  AEditControl:TControl;
                                                  AEditControlPutRect: TRectF;
                                                  X, Y: Double);
var
  AEditValue:String;
begin

//  if (FEditingItem_DataType=AEditItemDataType)
//    and (FEditingItem_SubItemsIndex=AEditItemSubItemsIndex)
//    and (FEditingItem_EditControl=AEditControl) then
  if (FEditingItem_FieldName=AEditItemFieldName) then
  begin
    //重复调用相同的编辑,直接退出
    Exit;
  end;


//  FEditingItem_DataType:=AEditItemDataType;
//  FEditingItem_SubItemsIndex:=AEditItemSubItemsIndex;
  FEditingItem_FieldName:=AEditItemFieldName;//SubItemsIndex;


  //获取当前的值
  AEditValue:=AItem.GetValueByBindItemField(FEditingItem_FieldName);
//  GetItemDataText(TSkinItem(AItem),
//                              AEditItemDataType,
//                              AEditItemSubItemsIndex);


  //启动编辑
  Inherited StartEditingItem(AItem,
                             AEditControl,
                             AEditControlPutRect,
                             AEditValue,
                             X,Y
                             );
end;

procedure TVirtualListProperties.SetSelectedItem(Value: TSkinItem);
begin
  Inherited SelectedItem:=Value;
end;

procedure TVirtualListProperties.SetCenterItem(Value: TSkinItem);
begin
  Inherited CenterItem:=Value;
end;

procedure TVirtualListProperties.SetItems(const Value: TSkinItems);
begin
  FItems.Assign(Value);
end;

function TVirtualListProperties.SetItemTypeStyle(AItemStyle:String):TListItemTypeStyleSetting;
begin
  Result:=nil;


  Result:=IsItemTypeStyleExists(AItemStyle);
  if Result<>nil then Exit;


  if FDefaultItemStyleSetting.Style='' then
  begin
    FDefaultItemStyleSetting.Style:=AItemStyle;
    Result:=FDefaultItemStyleSetting;
  end
  else if FItem1ItemStyleSetting.Style='' then
  begin
    FItem1ItemStyleSetting.Style:=AItemStyle;
    Result:=FItem1ItemStyleSetting;
  end
  else if FItem2ItemStyleSetting.Style='' then
  begin
    FItem2ItemStyleSetting.Style:=AItemStyle;
    Result:=FItem2ItemStyleSetting;
  end
  else if FItem3ItemStyleSetting.Style='' then
  begin
    FItem3ItemStyleSetting.Style:=AItemStyle;
    Result:=FItem3ItemStyleSetting;
  end
  else if FItem4ItemStyleSetting.Style='' then
  begin
    FItem4ItemStyleSetting.Style:=AItemStyle;
    Result:=FItem4ItemStyleSetting;
  end
  else if FHeaderItemStyleSetting.Style='' then
  begin
    FHeaderItemStyleSetting.Style:=AItemStyle;
    Result:=FHeaderItemStyleSetting;
  end
  else if FFooterItemStyleSetting.Style='' then
  begin
    FFooterItemStyleSetting.Style:=AItemStyle;
    Result:=FFooterItemStyleSetting;
  end
  else if FSearchBarItemStyleSetting.Style='' then
  begin
    FSearchBarItemStyleSetting.Style:=AItemStyle;
    Result:=FSearchBarItemStyleSetting;
  end
  ;


end;

function TVirtualListProperties.GetItem1DesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FItem1ItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetItem1ItemStyle: String;
begin
  Result:=FItem1ItemStyleSetting.Style;
end;

function TVirtualListProperties.GetItem1ItemStyleConfig: TStringList;
begin
  Result:=FItem1ItemStyleSetting.FConfig;
end;

function TVirtualListProperties.GetItem2DesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FItem2ItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetItem2ItemStyle: String;
begin
  Result:=FItem2ItemStyleSetting.Style;
end;

function TVirtualListProperties.GetItem2ItemStyleConfig: TStringList;
begin
  Result:=FItem2ItemStyleSetting.FConfig;
end;

function TVirtualListProperties.GetItem3DesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FItem3ItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetItem3ItemStyle: String;
begin
  Result:=FItem3ItemStyleSetting.Style;
end;

function TVirtualListProperties.GetItem3ItemStyleConfig: TStringList;
begin
  Result:=FItem3ItemStyleSetting.FConfig;
end;

function TVirtualListProperties.GetItem4DesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FItem4ItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetItem4ItemStyle: String;
begin
  Result:=FItem4ItemStyleSetting.Style;
end;

function TVirtualListProperties.GetItem4ItemStyleConfig: TStringList;
begin
  Result:=FItem4ItemStyleSetting.FConfig;
end;

function TVirtualListProperties.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FDefaultItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetItems: TSkinItems;
begin
  Result:=TSkinItems(FItems);
end;

procedure TVirtualListProperties.SetMouseDownItem(Value: TSkinItem);
begin
  Inherited MouseDownItem:=Value;
end;

procedure TVirtualListProperties.SetInnerMouseDownItem(Value: TSkinItem);
begin
  Inherited InnerMouseDownItem:=Value;
end;

procedure TVirtualListProperties.SetPanDragItem(Value: TSkinItem);
begin
  Inherited PanDragItem:=Value;
end;

procedure TVirtualListProperties.SetPropJson(ASuperObject: ISuperObject);
begin
  inherited;
//  DefaultItemStyle

  {$IF CompilerVersion >= 30.0}
  if ASuperObject.Contains('DefaultItemStyle') then
  begin
    DefaultItemStyle:=ASuperObject.S['DefaultItemStyle'];
  end;
  if ASuperObject.Contains('ItemHeight') then
  begin
    ItemHeight:=ASuperObject.I['ItemHeight'];
  end;
  {$IFEND}

end;

procedure TVirtualListProperties.SetMouseOverItem(Value: TSkinItem);
begin
  Inherited MouseOverItem:=Value;
end;

function TVirtualListProperties.GetMouseDownItem: TSkinItem;
begin
  Result:=TSkinItem(FMouseDownItem);
end;

function TVirtualListProperties.GetInnerMouseDownItem: TSkinItem;
begin
  Result:=TSkinItem(InnerMouseDownItem);
end;

function TVirtualListProperties.GetPanDragItem: TSkinItem;
begin
  Result:=TSkinItem(FPanDragItem);
end;

procedure TVirtualListProperties.GetPropJson(ASuperObject: ISuperObject);
begin
  inherited;

end;

function TVirtualListProperties.GetCenterItem: TSkinItem;
begin
  Result:=TSkinItem(FCenterItem);
end;

function TVirtualListProperties.GetMouseOverItem: TSkinItem;
begin
  Result:=TSkinItem(FMouseOverItem);
end;

function TVirtualListProperties.GetSearchBarDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FSearchBarItemStyleSetting.ItemDesignerPanel;
end;

function TVirtualListProperties.GetSearchBarItemStyle: String;
begin
  Result:=FSearchBarItemStyleSetting.Style;
end;

function TVirtualListProperties.GetSearchBarItemStyleConfig: TStringList;
begin
  Result:=FSearchBarItemStyleSetting.FConfig;
end;

function TVirtualListProperties.GetSelectedItem: TSkinItem;
begin
  Result:=TSkinItem(FSelectedItem);
end;

function TVirtualListProperties.VisibleItemAt(X, Y: Double):TSkinItem;
begin
  Result:=TSkinItem(Inherited VisibleItemAt(X,Y));
end;



{ TSkinVirtualListDefaultType }

procedure TSkinVirtualListDefaultType.AutoAdjustItemDesignerPanelSize(AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem);
begin
  AItemDesignerPanel.Width:=ControlSize(Self.FSkinVirtualListIntf.Prop.CalcItemWidth(AItem));

//  if (Self.FSkinVirtualListIntf.Prop.FListLayoutsManager.ItemSizeCalcType=isctFixed) then
//  begin
//    //设计时固定尺寸
//    AItemDesignerPanel.Height:=ControlSize(Self.FSkinVirtualListIntf.Prop.FListLayoutsManager.GetItemDefaultHeight);
//  end
//  else
//  if IsSameDouble(AItem.Height,-1) then
//  begin
    //设计时固定尺寸
    AItemDesignerPanel.Height:=ControlSize(Self.FSkinVirtualListIntf.Prop.FListLayoutsManager.CalcItemHeight(AItem));
//  end
//  else
////if (AItem.ItemType<>sitDefault)
////    or (AItem.ItemType=sitDefault) //and not (csDesigning in Self.FSkinControl.ComponentState)
////    then
//  begin
//    //运行时动态尺寸
//    AItemDesignerPanel.Height:=ControlSize(AItem.Height);
//  end;
end;

function TSkinVirtualListDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinVirtualList,Self.FSkinVirtualListIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinVirtualList Interface');
    end;
  end;
end;

procedure TSkinVirtualListDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinVirtualListIntf:=nil;
end;

function TSkinVirtualListDefaultType.DecideItemMaterial(AItem: TBaseSkinItem;
  ASkinMaterial: TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;
begin
  Result:=nil;
  if ASkinMaterial.DefaultTypeItemStyle<>'' then
  begin
    Result:=GlobalSkinItemMaterialStylePackage.GetMaterial(ASkinMaterial.DefaultTypeItemStyle);
  end;
  if Result=nil then
  begin
    if TSkinItem(AItem).ItemType=sitItem1 then
    begin
      Result:=ASkinMaterial.Item1TypeItemMaterial;
    end
    else
    begin
      Result:=ASkinMaterial.DefaultTypeItemMaterial;
    end;
//    Result:=Inherited DecideItemMaterial(AItem,ASkinMaterial);
  end;
end;

procedure TSkinVirtualListDefaultType.DoAutoEditControlClosePopup(Sender: TObject);
begin
  //结束编辑
  Self.FSkinVirtualListIntf.Prop.StopEditingItem;
end;

procedure TSkinVirtualListDefaultType.DoAutoEditControlKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key=13 then
  begin
    //结束编辑
    Self.FSkinVirtualListIntf.Prop.StopEditingItem;
  end;
end;

function TSkinVirtualListDefaultType.DoProcessItemCustomMouseDown(
          AMouseOverItem:TBaseSkinItem;
          AItemDrawRect:TRectF;
          Button: TMouseButton;
          Shift: TShiftState;
          X, Y: Double): Boolean;
var
  ASkinMouseOverItem:TSkinItem;
  AMouseOverItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
begin
  Result:=inherited;

  ASkinMouseOverItem:=TSkinItem(AMouseOverItem);


  //ItemDesignerPanel处理鼠标按下事件
  if    PtInRect(AItemDrawRect,PointF(X,Y))
    and (AMouseOverItem<>nil)
    and (ASkinMouseOverItem.FDrawItemDesignerPanel<>nil)
    and (TSkinItemDesignerPanel(ASkinMouseOverItem.FDrawItemDesignerPanel).SkinControlType<>nil) then
  begin



        AMouseOverItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(ASkinMouseOverItem.FDrawItemDesignerPanel);
        //初始事件没有被处理
        AMouseOverItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;


        //设置设计面板的高度和宽度(以便排列好控件,进行消息响应)
        AMouseOverItemDrawItemDesignerPanel.Height:=ControlSize(RectHeightF(AItemDrawRect));
        AMouseOverItemDrawItemDesignerPanel.Width:=ControlSize(RectWidthF(AItemDrawRect));

        //再调用OnPrepareDrawItem事件
        //准备绘制列表项
        if Self.FSkinVirtualListIntf.Prop.IsItemMouseEventNeedCallPrepareDrawItem then
        begin
          //手动绑定值,以及设置设计面板上面的控件位置等
          Self.FSkinVirtualListIntf.Prop.CallOnPrepareDrawItemEvent(
                          Self,
                          nil,
                          AMouseOverItem,
                          AItemDrawRect,
                          False
                          );
        end;


        //判断之前鼠标按下的Item时有没有控件弹起来


        //处理鼠标按下消息
        AMouseOverItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseDown(Self.FSkinControl,Button,Shift,X-AItemDrawRect.Left,Y-AItemDrawRect.Top);

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

procedure TSkinVirtualListDefaultType.DoProcessItemCustomMouseLeave(AMouseLeaveItem:TBaseSkinItem);
var
  ASkinMouseLeaveItem:TSkinItem;
begin
  Inherited;

  ASkinMouseLeaveItem:=TSkinItem(AMouseLeaveItem);

  if (ASkinMouseLeaveItem<>nil)
    and (ASkinMouseLeaveItem.FDrawItemDesignerPanel<>nil)
    and (TSkinItemDesignerPanel(ASkinMouseLeaveItem.FDrawItemDesignerPanel).SkinControlType<>nil) then
  begin
    TSkinItemDesignerPanel(ASkinMouseLeaveItem.FDrawItemDesignerPanel).SkinControlType.DirectUIMouseLeave;
  end;

end;

function TSkinVirtualListDefaultType.DoProcessItemCustomMouseMove(
                                        AMouseOverItem: TBaseSkinItem;
                                        Shift: TShiftState;
                                        X, Y: Double): Boolean;
var
  AItemDrawRect:TRectF;
  ASkinMouseOverItem:TSkinItem;
  AMouseOverItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
begin
  Result:=inherited;

  ASkinMouseOverItem:=TSkinItem(AMouseOverItem);

  //现ItemDesignerPanel处理鼠标移动效果
  if (ASkinMouseOverItem<>nil)
    and (ASkinMouseOverItem.FDrawItemDesignerPanel<>nil)
    and (TSkinItemDesignerPanel(ASkinMouseOverItem.FDrawItemDesignerPanel).SkinControlType<>nil) then
  begin

      AItemDrawRect:=Self.FSkinVirtualListIntf.Prop.VisibleItemDrawRect(ASkinMouseOverItem);
      //如果当前列表项正在平拖,那么获取平拖后的绘制矩形
      if (ASkinMouseOverItem=Self.FSkinVirtualListIntf.Prop.FPanDragItem) then
      begin
        AItemDrawRect:=Self.FSkinVirtualListIntf.Prop.GetPanDragItemDrawRect;
      end;
      AMouseOverItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(ASkinMouseOverItem.FDrawItemDesignerPanel);

      AMouseOverItemDrawItemDesignerPanel.Height:=ControlSize(RectHeightF(AItemDrawRect));
      AMouseOverItemDrawItemDesignerPanel.Width:=ControlSize(RectWidthF(AItemDrawRect));



      //再调用OnPrepareDrawItem事件
      //准备绘制列表项
      if Self.FSkinVirtualListIntf.Prop.IsItemMouseEventNeedCallPrepareDrawItem then
      begin
        //手动绑定值,以及设置设计面板上面的控件位置等
        Self.FSkinVirtualListIntf.Prop.CallOnPrepareDrawItemEvent(
                        Self,
                        nil,
                        AMouseOverItem,
                        AItemDrawRect,
                        False
                        );
      end;



      AMouseOverItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseMove(Self.FSkinControl,Shift,
        X-AItemDrawRect.Left,
        Y-AItemDrawRect.Top);

  end;

end;

function TSkinVirtualListDefaultType.DoProcessItemCustomMouseUp(
  AMouseDownItem: TBaseSkinItem;
  Button: TMouseButton;
  Shift: TShiftState;
  X, Y: Double):Boolean;
var
  AItemDrawRect:TRectF;
  ASkinMouseDownItem: TSkinItem;
  AMouseOverItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
  ACurrentHitTestChildControl:TControl;
begin
  Result:=inherited;

  ASkinMouseDownItem:=TSkinItem(AMouseDownItem);

  //ItemDesignerPanel处理鼠标弹出效果
  if (ASkinMouseDownItem<>nil)
    and (ASkinMouseDownItem.FDrawItemDesignerPanel<>nil)
    and (TSkinItemDesignerPanel(ASkinMouseDownItem.FDrawItemDesignerPanel).SkinControlType<>nil) then
  begin
      AItemDrawRect:=Self.FSkinVirtualListIntf.Prop.VisibleItemDrawRect(ASkinMouseDownItem);

      //获取平拖后的绘制矩形
      if (ASkinMouseDownItem=Self.FSkinVirtualListIntf.Prop.FPanDragItem) then
      begin
        AItemDrawRect:=Self.FSkinVirtualListIntf.Prop.GetPanDragItemDrawRect;
      end;

      AMouseOverItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(ASkinMouseDownItem.FDrawItemDesignerPanel);
      AMouseOverItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;

      AMouseOverItemDrawItemDesignerPanel.Height:=ControlSize(RectHeightF(AItemDrawRect));
      AMouseOverItemDrawItemDesignerPanel.Width:=ControlSize(RectWidthF(AItemDrawRect));

      //再调用OnPrepareDrawItem事件
      //准备绘制列表项
      if Self.FSkinVirtualListIntf.Prop.IsItemMouseEventNeedCallPrepareDrawItem then
      begin
        //手动绑定值
        Self.FSkinVirtualListIntf.Prop.CallOnPrepareDrawItemEvent(
                        Self,
                        nil,
                        ASkinMouseDownItem,
                        AItemDrawRect,
                        False
                        );
      end;

      AMouseOverItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseUp(Self.FSkinControl,Button,Shift,X-AItemDrawRect.Left,Y-AItemDrawRect.Top,
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
                    ASkinMouseDownItem,
                    TItemDesignerPanel(AMouseOverItemDrawItemDesignerPanel),
                    AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl
                    );
              end;



              {$IFDEF FMX}
              //如果是Edit,那么启动自动编辑
              ACurrentHitTestChildControl:=TControl(AMouseOverItemDrawItemDesignerPanel.SkinControlType.CurrentHitTestChildControl);
              if ( ACurrentHitTestChildControl is TSkinEdit)
                and TSkinEdit(ACurrentHitTestChildControl).IsAutoEditInItem then
              begin
                  if not Assigned(TSkinEdit(ACurrentHitTestChildControl).OnKeyUp) then
                  begin
                    TSkinEdit(ACurrentHitTestChildControl).OnKeyUp:=Self.DoAutoEditControlKeyUp;
                  end;

                  Self.FSkinVirtualListIntf.Prop.StartEditingItem(
                                ASkinMouseDownItem,
                                TControl(ACurrentHitTestChildControl),
                                nil,
                                TSkinEdit(ACurrentHitTestChildControl).SkinControlType.FMouseUpPt.X,
                                TSkinEdit(ACurrentHitTestChildControl).SkinControlType.FMouseUpPt.Y
                                );
              end;
              //如果是Edit,那么启动自动编辑
              if (ACurrentHitTestChildControl is TSkinCombobox)
                and TSkinCombobox(ACurrentHitTestChildControl).IsAutoEditInItem then
              begin
                  if not Assigned(TSkinCombobox(ACurrentHitTestChildControl).OnClosePopup) then
                  begin
                    TSkinCombobox(ACurrentHitTestChildControl).OnClosePopup:=Self.DoAutoEditControlClosePopup;
                  end;
                  Self.FSkinVirtualListIntf.Prop.StartEditingItem(
                                ASkinMouseDownItem,
                                TControl(ACurrentHitTestChildControl),
                                nil,
                                TSkinCombobox(ACurrentHitTestChildControl).SkinControlType.FMouseUpPt.X,
                                TSkinCombobox(ACurrentHitTestChildControl).SkinControlType.FMouseUpPt.Y
                                );
              end;
              //如果是Edit,那么启动自动编辑
              if (ACurrentHitTestChildControl is TSkinComboEdit)
                and TSkinComboEdit(ACurrentHitTestChildControl).IsAutoEditInItem then
              begin
                  if not Assigned(TSkinComboEdit(ACurrentHitTestChildControl).OnKeyUp) then
                  begin
                    TSkinComboEdit(ACurrentHitTestChildControl).OnKeyUp:=Self.DoAutoEditControlKeyUp;
                  end;
                  if not Assigned(TSkinComboEdit(ACurrentHitTestChildControl).OnClosePopup) then
                  begin
                    TSkinComboEdit(ACurrentHitTestChildControl).OnClosePopup:=Self.DoAutoEditControlClosePopup;
                  end;
                  Self.FSkinVirtualListIntf.Prop.StartEditingItem(
                                ASkinMouseDownItem,
                                TControl(ACurrentHitTestChildControl),
                                nil,
                                TSkinComboEdit(ACurrentHitTestChildControl).SkinControlType.FMouseUpPt.X,
                                TSkinComboEdit(ACurrentHitTestChildControl).SkinControlType.FMouseUpPt.Y
                                );
              end;
              {$ENDIF FMX}

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

function TSkinVirtualListDefaultType.GetSkinMaterial: TSkinVirtualListDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinVirtualListDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinVirtualListDefaultType.MarkAllListItemTypeStyleSettingCacheUnUsed(ADrawStartIndex, ADrawEndIndex: Integer);
var
  I:Integer;
  AItem:TSkinItem;
begin

  //先将所有缓存标记为不使用
  Self.FSkinVirtualListIntf.Prop.FDefaultItemStyleSetting.MarkAllCacheNoUsed;
  Self.FSkinVirtualListIntf.Prop.FItem1ItemStyleSetting.MarkAllCacheNoUsed;
  Self.FSkinVirtualListIntf.Prop.FItem2ItemStyleSetting.MarkAllCacheNoUsed;
  Self.FSkinVirtualListIntf.Prop.FItem3ItemStyleSetting.MarkAllCacheNoUsed;
  Self.FSkinVirtualListIntf.Prop.FItem4ItemStyleSetting.MarkAllCacheNoUsed;
  Self.FSkinVirtualListIntf.Prop.FHeaderItemStyleSetting.MarkAllCacheNoUsed;
  Self.FSkinVirtualListIntf.Prop.FFooterItemStyleSetting.MarkAllCacheNoUsed;
  Self.FSkinVirtualListIntf.Prop.FSearchBarItemStyleSetting.MarkAllCacheNoUsed;




  //再将使用的缓存标记为已使用
  for I:=ADrawStartIndex to ADrawEndIndex do
  begin
    //将不再绘制的Item的缓存设置为不使用
    AItem:=TSkinItem(Self.FSkinCustomListIntf.Prop.ListLayoutsManager.GetVisibleItems(I));

    case AItem.ItemType of
      sitDefault: Self.FSkinVirtualListIntf.Prop.FDefaultItemStyleSetting.MarkCacheUsed(AItem);
      sitHeader: Self.FSkinVirtualListIntf.Prop.FHeaderItemStyleSetting.MarkCacheUsed(AItem);
      sitFooter: Self.FSkinVirtualListIntf.Prop.FFooterItemStyleSetting.MarkCacheUsed(AItem);
      sitSpace: ;
      sitRowDevideLine: ;
      sitItem1: Self.FSkinVirtualListIntf.Prop.FItem1ItemStyleSetting.MarkCacheUsed(AItem);
      sitItem2: Self.FSkinVirtualListIntf.Prop.FItem2ItemStyleSetting.MarkCacheUsed(AItem);
      sitItem3: Self.FSkinVirtualListIntf.Prop.FItem3ItemStyleSetting.MarkCacheUsed(AItem);
      sitSearchBar: Self.FSkinVirtualListIntf.Prop.FSearchBarItemStyleSetting.MarkCacheUsed(AItem);
      sitUseMaterialDraw: ;
      sitItem4: Self.FSkinVirtualListIntf.Prop.FItem4ItemStyleSetting.MarkCacheUsed(AItem);
      sitUseDrawItemDesignerPanel: ;
    end;
    
  end;

end;

procedure TSkinVirtualListDefaultType.ProcessItemDrawParams(
                                    ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    AItemEffectStates:TDPEffectStates);
var
  ASkinVirtualItemMaterial:TSkinListItemMaterial;
  ASkinVirtualListMaterial:TSkinVirtualListDefaultMaterial;
begin
  inherited;

  ASkinVirtualItemMaterial:=TSkinListItemMaterial(ASkinItemMaterial);
  ASkinVirtualListMaterial:=TSkinVirtualListDefaultMaterial(ASkinMaterial);


  
  ASkinVirtualItemMaterial.FDrawItemCaptionParam.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemCaptionParam);
  ASkinVirtualItemMaterial.FDrawItemIconParam.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemIconParam);
  ASkinVirtualItemMaterial.FDrawItemPicParam.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemPicParam);

  ASkinVirtualItemMaterial.FDrawItemDetailParam.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemDetailParam);
  ASkinVirtualItemMaterial.FDrawItemDetail1Param.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemDetail1Param);
  ASkinVirtualItemMaterial.FDrawItemDetail2Param.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemDetail2Param);
  ASkinVirtualItemMaterial.FDrawItemDetail3Param.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemDetail3Param);
  ASkinVirtualItemMaterial.FDrawItemDetail4Param.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemDetail4Param);
  ASkinVirtualItemMaterial.FDrawItemDetail5Param.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemDetail5Param);
  ASkinVirtualItemMaterial.FDrawItemDetail6Param.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualItemMaterial.FDrawItemDetail6Param);

  ASkinVirtualListMaterial.FDrawGroupBeginDevideParam.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualListMaterial.FDrawGroupBeginDevideParam);
  ASkinVirtualListMaterial.FDrawGroupEndDevideParam.StaticEffectStates:=AItemEffectStates;
  ProcessDrawParamDrawAlpha(ASkinVirtualListMaterial.FDrawGroupEndDevideParam);


end;

function TSkinVirtualListDefaultType.CustomDrawItemBegin(ACanvas: TDrawCanvas;
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
  ASkinItem:TSkinItem;
  ASkinVirtualListMaterial:TSkinVirtualListDefaultMaterial;
begin
  ASkinItem:=TSkinItem(AItem);
  ASkinVirtualListMaterial:=TSkinVirtualListDefaultMaterial(ASkinMaterial);

  //确定出绘制的设计面板
  ASkinItem.FDrawItemDesignerPanel:=Self.FSkinVirtualListIntf.Prop.DecideItemDesignerPanel(ASkinItem);



  //调用OnPrepareDrawItem事件
  Inherited;





  //判断分组开始与结束
  //分隔项下一个和下一个分隔项前一个,
  //就算是一个分组
  FIsGroupBegin:=False;
  FIsGroupEnd:=False;
  if (ASkinItem.ItemType<>sitSpace) and (ASkinItem.ItemType<>sitRowDevideLine) then
  begin
      if
            //第一个
            (AItemIndex=0)
            //后面几个
        or (AItemIndex>0)
            //并且
          and (Self.FSkinVirtualListIntf.Prop.ListLayoutsManager.GetVisibleItems(AItemIndex-1).ItemType=sitSpace) then
      begin
        FIsGroupBegin:=True;
      end;
      if (AItemIndex=Self.FSkinVirtualListIntf.Prop.FListLayoutsManager.GetVisibleItemsCount - 1)
        or (AItemIndex>0) and (Self.FSkinVirtualListIntf.Prop.ListLayoutsManager.GetVisibleItems(AItemIndex+1).ItemType=sitSpace) then
      begin
        FIsGroupEnd:=True;
      end;
  end;

  

  //准备分组框
  if ASkinVirtualListMaterial.FIsSimpleDrawGroupRoundRect then
  begin

      FOriginStaticRectCorners:=ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners;
      ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners:=[];
      if FIsGroupBegin or FIsGroupEnd then
      begin
          //绘制分组开始分隔线
          if FIsGroupBegin then
          begin
              case Self.FSkinVirtualListIntf.Prop.ItemLayoutType of
                iltVertical:
                begin
                  ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners:=[rcTopLeft,rcTopRight];
                end;
                iltHorizontal:
                begin
                  ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners:=[rcTopLeft,rcBottomLeft];
                end;
              end;
          end;
          //绘制分组结束分隔线
          if FIsGroupEnd then
          begin
              case Self.FSkinVirtualListIntf.Prop.ItemLayoutType of
                iltVertical:
                begin
                  ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners:=
                      ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners
                      +[rcBottomLeft,rcBottomRight];
                end;
                iltHorizontal:
                begin
                  ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners:=
                      ASkinItemMaterial.DrawItemBackColorParam.StaticRectCorners
                      +[rcTopRight,rcBottomRight];
                end;
              end;
          end;
      end;

  end;

  

end;

function TSkinVirtualListDefaultType.CustomDrawItemContent(
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
  AItemBackPicture:TDrawPicture;
  ATempColor:TDelphiColor;
  AItemDesignerPanel:TSkinItemDesignerPanel;
  AItemPaintData:TPaintData;
  
  ASkinItem:TSkinItem;
  ASkinVirtualListMaterial:TSkinVirtualListDefaultMaterial;
  ASkinVirtualItemMaterial:TSkinListItemMaterial;
  ACustomListItemPaintOtherData:TVirtualListItemPaintOtherData;

  AValue:Variant;
//  AOldIsFill:Boolean;
//  AIsDrawedItemBackColor:Boolean;
begin

  ASkinItem:=TSkinItem(AItem);
  ASkinVirtualListMaterial:=TSkinVirtualListDefaultMaterial(ASkinMaterial);
  ASkinVirtualItemMaterial:=TSkinListItemMaterial(ASkinItemMaterial);



  if (ASkinItem.ItemType=sitSpace) then
  begin
    //绘制空行
    ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawSpaceParam,AItemDrawRect);
    Exit;
  end;

  if (ASkinItem.ItemType=sitRowDevideLine) then
  begin
    //绘制行分隔线
    //需要画分隔线
//    AOldIsFill:=ASkinVirtualListMaterial.FDrawItemDevideParam.StaticIsFill;
//    ASkinVirtualListMaterial.FDrawItemDevideParam.StaticIsFill:=True;
//    ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawItemDevideParam,
//                    RectF(AItemDrawRect.Left,
//                        AItemDrawRect.Bottom,
//                        AItemDrawRect.Right,
//                        AItemDrawRect.Bottom)
//                        );
    ASkinVirtualListMaterial.FDrawItemDevideLineParam.DrawRectSetting.Assign(ASkinVirtualListMaterial.FDrawItemDevideParam.DrawRectSetting);
    ASkinVirtualListMaterial.FDrawItemDevideLineParam.Color.FColor:=ASkinVirtualListMaterial.FDrawItemDevideParam.FillColor.Color;
    ACanvas.DrawLine(ASkinVirtualListMaterial.FDrawItemDevideLineParam,AItemDrawRect.Left,
                        AItemDrawRect.Bottom,
                        AItemDrawRect.Right,
                        AItemDrawRect.Bottom);
//    ASkinVirtualListMaterial.FDrawItemDevideParam.StaticIsFill:=AOldIsFill;
    Exit;
  end;

  

  //绘制的设计面板
  AItemDesignerPanel:=TSkinItemDesignerPanel(ASkinItem.FDrawItemDesignerPanel);




//  AIsDrawedItemBackColor:=False;


  if (AItemDesignerPanel<>nil) then
  begin

//      //绘制分组开始矩形
//      if ASkinVirtualListMaterial.FIsSimpleDrawGroupRoundRect then
//      begin
//        AIsDrawedItemBackColor:=True;
//        ACanvas.DrawRect(ASkinVirtualItemMaterial.FDrawItemBackColorParam,AItemDrawRect);
//        ASkinVirtualItemMaterial.FDrawItemBackColorParam.StaticRectCorners:=FOriginStaticRectCorners;
//      end;


      //自动调整ItemDesignerPanel的尺寸(区分设计时与运行时)
      if  ASkinVirtualListMaterial.FIsAutoAdjustItemDesignerPanelSize then
      begin
        AutoAdjustItemDesignerPanelSize(AItemDesignerPanel,ASkinItem);
      end;



      //准备绘制列表项
      FSkinVirtualListIntf.Prop.CallOnPrepareDrawItemEvent(
            Self,
            ACanvas,
            ASkinItem,
            AItemDrawRect,
            AIsDrawItemInteractiveState);



      //AItemDesignerPanel绘制
      if (AItemDesignerPanel.SkinControlType<>nil) then
      begin


              //备份颜色
              if (Self.FSkinVirtualListIntf.Prop.ItemColorType<>sictNone)
                and (ASkinItem.Color<>NullColor) then
              begin
                AItemDesignerPanel.Prop.ProcessItemBindingControlColor(Self.FSkinVirtualListIntf.Prop.ItemColorType,ASkinItem.Color,ATempColor);
              end;


              //绘制列表项背景色(因为有些功能要启动,比如GroupRoundRect)
//              if not AIsDrawedItemBackColor then
//              begin
//                ACanvas.DrawRect(ASkinVirtualItemMaterial.FDrawItemBackColorParam,AItemDrawRect);
//              end;

              //绘制列表项背景色
              ACanvas.DrawRect(ASkinVirtualItemMaterial.FDrawItemBackColorParam,AItemDrawRect);

              //还原简单分组
              if ASkinVirtualListMaterial.FIsSimpleDrawGroupRoundRect then
              begin
                ASkinVirtualItemMaterial.FDrawItemBackColorParam.StaticRectCorners:=FOriginStaticRectCorners;
              end;



              AItemDesignerPanel.SkinControlType.IsUseCurrentEffectStates:=True;
              AItemDesignerPanel.SkinControlType.CurrentEffectStates:=AItemEffectStates;

              //绘制ItemDesignerPanel的背景,背景色
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=True;
              AItemPaintData.IsInDrawDirectUI:=True;
              AItemDesignerPanel.SkinControlType.Paint(ACanvas,
                        AItemDesignerPanel.SkinControlType.GetPaintCurrentUseMaterial,
                        AItemDrawRect,
                        AItemPaintData);
              //绘制ItemDesignerPanel的子控件
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=AIsDrawItemInteractiveState;
              AItemPaintData.IsInDrawDirectUI:=True;
              //正在编辑的绑定控件不绘制
              ACustomListItemPaintOtherData.IsEditingItem:=(Self.FSkinVirtualListIntf.Prop.FEditingItem=ASkinItem);
//              ACustomListItemPaintOtherData.EditingItemDataType:=Self.FSkinVirtualListIntf.Prop.FEditingItem_DataType;
//              ACustomListItemPaintOtherData.EditingSubItemsIndex:=Self.FSkinVirtualListIntf.Prop.FEditingItem_SubItemsIndex;
//              ACustomListItemPaintOtherData.EditingItemDataType:=Self.FSkinVirtualListIntf.Prop.FEditingItem_DataType;
              ACustomListItemPaintOtherData.EditingItemFieldName:=Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName;
              AItemPaintData.OtherData:=@ACustomListItemPaintOtherData;
              AItemDesignerPanel.SkinControlType.DrawChildControls(ACanvas,AItemDrawRect,AItemPaintData,ADrawRect);




              //更新编辑框的位置和尺寸
              if Self.FSkinVirtualListIntf.Prop.FEditingItem<>nil then
              begin
                  If Self.FSkinVirtualListIntf.Prop.FEditingItem<>ASkinItem then
                  begin

                      //使用相同的绘制面板
                      if ASkinItem.FDrawItemDesignerPanel=
                        TSkinItem(Self.FSkinVirtualListIntf.Prop.FEditingItem).FDrawItemDesignerPanel then
                      begin
                          //如果BindingControl和EditControl相同
                          //那么编辑时,BindingControl的Parent设置为了ListBox
                          //没有在ItemDesignerPanel上面了
                          //所以需要自己将它画上去
                          if Self.FSkinVirtualListIntf.Prop.FEditingItem_BindingControl
                              =Self.FSkinVirtualListIntf.Prop.FEditingItem_EditControl then
                          begin
                              Self.FSkinVirtualListIntf.Prop.FEditingItem_BindingControlIntf.GetSkinControlType.Paint(
                                  ACanvas,
                                  Self.FSkinVirtualListIntf.Prop.FEditingItem_BindingControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial,
                                  RectF(AItemDrawRect.Left
                                            +Self.FSkinVirtualListIntf.Prop.FEditingItem_EditControlPutRect.Left,
                                        AItemDrawRect.Top
                                            +Self.FSkinVirtualListIntf.Prop.FEditingItem_EditControlPutRect.Top,
                                        AItemDrawRect.Left
                                            +Self.FSkinVirtualListIntf.Prop.FEditingItem_EditControlPutRect.Left
                                            +Self.FSkinVirtualListIntf.Prop.FEditingItem_EditControlPutRect.Width,
                                        AItemDrawRect.Top
                                           +Self.FSkinVirtualListIntf.Prop.FEditingItem_EditControlPutRect.Top
                                           +Self.FSkinVirtualListIntf.Prop.FEditingItem_EditControlPutRect.Height
                                        ),
                                  AItemPaintData
                                  );
                          end;
                      end;


                  end;
              end;




              //还原颜色
              if (Self.FSkinVirtualListIntf.Prop.ItemColorType<>sictNone)
                  and (ASkinItem.Color<>NullColor) then
              begin
                AItemDesignerPanel.Prop.RestoreItemBindingControlColor(Self.FSkinVirtualListIntf.Prop.ItemColorType,ASkinItem.Color,ATempColor);
              end;


      end;


  end
  //默认绘制
  else if (ASkinVirtualListMaterial<>nil) then
  begin




      //备份颜色
      if (Self.FSkinVirtualListIntf.Prop.ItemColorType<>sictNone)
        and (ASkinItem.Color<>NullColor) then
      begin
          case Self.FSkinVirtualListIntf.Prop.ItemColorType of
            sictNone: ;
            sictBackColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemBackColorParam.FillDrawColor.FColor;
              ASkinVirtualItemMaterial.FDrawItemBackColorParam.FillDrawColor.FColor:=ASkinItem.Color;
            end;
            sictCaptionFontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemCaptionParam.FontColor;
              ASkinVirtualItemMaterial.DrawItemCaptionParam.FontColor:=ASkinItem.Color;
            end;
            sictDetailFontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetailParam.FontColor;
              ASkinVirtualItemMaterial.FDrawItemDetailParam.FontColor:=ASkinItem.Color;
            end;
            sictDetail1FontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail1Param.FontColor;
              ASkinVirtualItemMaterial.FDrawItemDetail1Param.FontColor:=ASkinItem.Color;
            end;
            sictDetail2FontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail2Param.FontColor;
              ASkinVirtualItemMaterial.FDrawItemDetail2Param.FontColor:=ASkinItem.Color;
            end;
            sictDetail3FontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail3Param.FontColor;
              ASkinVirtualItemMaterial.FDrawItemDetail3Param.FontColor:=ASkinItem.Color;
            end;
            sictDetail4FontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail4Param.FontColor;
              ASkinVirtualItemMaterial.FDrawItemDetail4Param.FontColor:=ASkinItem.Color;
            end;
            sictDetail5FontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail5Param.FontColor;
              ASkinVirtualItemMaterial.FDrawItemDetail5Param.FontColor:=ASkinItem.Color;
            end;
            sictDetail6FontColor:
            begin
              ATempColor:=ASkinVirtualItemMaterial.FDrawItemDetail6Param.FontColor;
              ASkinVirtualItemMaterial.FDrawItemDetail6Param.FontColor:=ASkinItem.Color;
            end;
          end;
      end;


      //绘制列表项背景色
      ACanvas.DrawRect(ASkinVirtualItemMaterial.FDrawItemBackColorParam,AItemDrawRect);

      //还原简单分组
      if ASkinVirtualListMaterial.FIsSimpleDrawGroupRoundRect then
      begin
        ASkinVirtualItemMaterial.FDrawItemBackColorParam.StaticRectCorners:=FOriginStaticRectCorners;
      end;




      //绘制列表项背景图片
      AItemBackPicture:=nil;
      if ASkinItem.Selected then
      begin
        AItemBackPicture:=ASkinVirtualItemMaterial.FItemBackPushedPicture;
      end
      else
      if ASkinItem=Self.FSkinVirtualListIntf.Prop.MouseDownItem then
      begin
        AItemBackPicture:=ASkinVirtualItemMaterial.FItemBackDownPicture;
      end
      else
      if ASkinItem=Self.FSkinVirtualListIntf.Prop.MouseOverItem then
      begin
        AItemBackPicture:=ASkinVirtualItemMaterial.FItemBackHoverPicture;
      end
      else
      begin
        AItemBackPicture:=ASkinVirtualItemMaterial.FItemBackNormalPicture;
      end;
      if AItemBackPicture.IsEmpty then
      begin
        AItemBackPicture:=ASkinVirtualItemMaterial.FItemBackNormalPicture;
      end;
      ACanvas.DrawPicture(ASkinVirtualItemMaterial.FDrawItemBackGndPictureParam,AItemBackPicture,AItemDrawRect);






      //绘制列表项图片
      if ASkinItem.StaticIcon<>nil then
      begin
        ACanvas.DrawPicture(ASkinVirtualItemMaterial.FDrawItemIconParam,ASkinItem.Icon,AItemDrawRect);
      end;
      if ASkinItem.StaticPic<>nil then
      begin
        ACanvas.DrawPicture(ASkinVirtualItemMaterial.FDrawItemPicParam,ASkinItem.Pic,AItemDrawRect);
      end;

      //绘制列表项展开图片
      ACanvas.DrawPicture(ASkinVirtualItemMaterial.FDrawItemAccessoryPictureParam,ASkinVirtualItemMaterial.FItemAccessoryPicture,AItemDrawRect);



//      if (ASkinItem is TRealSkinItem) or (ASkinItem is TRealSkinTreeViewItem) then
//      begin
      if ASkinItem<>Self.FSkinVirtualListIntf.Prop.FEditingItem then
      begin
          //绘制列表项标题
          AValue:=ASkinItem.GetValueByBindItemField('ItemCaption');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemCaptionParam,AValue,AItemDrawRect);

          //绘制列表项明细
          AValue:=ASkinItem.GetValueByBindItemField('ItemDetail');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetailParam,AValue,AItemDrawRect);
          AValue:=ASkinItem.GetValueByBindItemField('ItemDetail1');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail1Param,AValue,AItemDrawRect);
          AValue:=ASkinItem.GetValueByBindItemField('ItemDetail2');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail2Param,AValue,AItemDrawRect);
          AValue:=ASkinItem.GetValueByBindItemField('ItemDetail3');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail3Param,AValue,AItemDrawRect);
          AValue:=ASkinItem.GetValueByBindItemField('ItemDetail4');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail4Param,AValue,AItemDrawRect);
          AValue:=ASkinItem.GetValueByBindItemField('ItemDetail5');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail5Param,AValue,AItemDrawRect);
          AValue:=ASkinItem.GetValueByBindItemField('ItemDetail6');
          ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail6Param,AValue,AItemDrawRect);

      end
      else
      begin
          //如果当前正在编辑Caption属性,那么就不绘制Caption属性
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemCaption' then
          begin
            //绘制列表项标题
            AValue:=ASkinItem.GetValueByBindItemField('ItemCaption');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemCaptionParam,AValue,AItemDrawRect);
          end;

          //绘制列表项明细
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemDetail' then
          begin
            AValue:=ASkinItem.GetValueByBindItemField('ItemDetail');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetailParam,AValue,AItemDrawRect);
          end;
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemDetail1' then
          begin
            AValue:=ASkinItem.GetValueByBindItemField('ItemDetail1');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail1Param,AValue,AItemDrawRect);
          end;
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemDetail2' then
          begin
            AValue:=ASkinItem.GetValueByBindItemField('ItemDetail2');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail2Param,AValue,AItemDrawRect);
          end;
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemDetail3' then
          begin
            AValue:=ASkinItem.GetValueByBindItemField('ItemDetail3');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail3Param,AValue,AItemDrawRect);
          end;
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemDetail4' then
          begin
            AValue:=ASkinItem.GetValueByBindItemField('ItemDetail4');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail4Param,AValue,AItemDrawRect);
          end;
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemDetail5' then
          begin
            AValue:=ASkinItem.GetValueByBindItemField('ItemDetail5');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail5Param,AValue,AItemDrawRect);
          end;
          if Self.FSkinVirtualListIntf.Prop.FEditingItem_FieldName<>'ItemDetail6' then
          begin
            AValue:=ASkinItem.GetValueByBindItemField('ItemDetail6');
            ACanvas.DrawText(ASkinVirtualItemMaterial.FDrawItemDetail6Param,AValue,AItemDrawRect);
          end;

      end;
//      end;







      //还原颜色
      if (Self.FSkinVirtualListIntf.Prop.ItemColorType<>sictNone)
        and (ASkinItem.Color<>NullColor) then
      begin
        case Self.FSkinVirtualListIntf.Prop.ItemColorType of
          sictNone: ;
          sictBackColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemBackColorParam.FillDrawColor.FColor:=ATempColor;
          end;
          sictCaptionFontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemCaptionParam.FontColor:=ATempColor;
          end;
          sictDetailFontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemDetailParam.FontColor:=ATempColor;
          end;
          sictDetail1FontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemDetail1Param.FontColor:=ATempColor;
          end;
          sictDetail2FontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemDetail2Param.FontColor:=ATempColor;
          end;
          sictDetail3FontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemDetail3Param.FontColor:=ATempColor;
          end;
          sictDetail4FontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemDetail4Param.FontColor:=ATempColor;
          end;
          sictDetail5FontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemDetail5Param.FontColor:=ATempColor;
          end;
          sictDetail6FontColor:
          begin
            ASkinVirtualItemMaterial.FDrawItemDetail6Param.FontColor:=ATempColor;
          end;
        end;
      end;





  end;



end;

function TSkinVirtualListDefaultType.CustomDrawItemEnd(ACanvas: TDrawCanvas;
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
  ASkinItem:TSkinItem;
  ASkinVirtualListMaterial:TSkinVirtualListDefaultMaterial;
begin

  ASkinItem:=TSkinItem(AItem);
  ASkinVirtualListMaterial:=TSkinVirtualListDefaultMaterial(ASkinMaterial);




    if FIsGroupBegin or FIsGroupEnd then
    begin

        //绘制分组开始分隔线
        if FIsGroupBegin then
        begin
            if ASkinVirtualListMaterial.FIsSimpleDrawGroupBeginDevide then
            begin
//                ASkinVirtualListMaterial.FDrawGroupBeginDevideParam.DrawRectSetting.Enabled:=False;

                case Self.FSkinVirtualListIntf.Prop.ItemLayoutType of
                  iltVertical:
                  begin
                    ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawGroupBeginDevideParam,
                                      RectF(AItemDrawRect.Left,
                                          AItemDrawRect.Top,
                                          AItemDrawRect.Right,
                                          AItemDrawRect.Top+1
                                          )
                                          );
                  end;
                  iltHorizontal:
                  begin
                    ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawGroupBeginDevideParam,
                                      RectF(AItemDrawRect.Left,
                                          AItemDrawRect.Top,
                                          AItemDrawRect.Left+1,
                                          AItemDrawRect.Bottom
                                          )
                                          );
                  end;
                end;
            end
            else
            begin
              ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawGroupBeginDevideParam,AItemDrawRect);
            end;
        end;


        //绘制分组结束分隔线
        if FIsGroupEnd then
        begin
            if ASkinVirtualListMaterial.FIsSimpleDrawGroupEndDevide then
            begin
//                ASkinVirtualListMaterial.FDrawGroupEndDevideParam.DrawRectSetting.Enabled:=False;


                case Self.FSkinVirtualListIntf.Prop.ItemLayoutType of
                  iltVertical:
                  begin
                    ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawGroupEndDevideParam,
                                    RectF(AItemDrawRect.Left,
                                        AItemDrawRect.Bottom,
                                        AItemDrawRect.Right,
                                        AItemDrawRect.Bottom+1
                                        )
                                        );
                  end;
                  iltHorizontal:
                  begin
                    ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawGroupEndDevideParam,
                                    RectF(AItemDrawRect.Right,
                                        AItemDrawRect.Top,
                                        AItemDrawRect.Right+1,
                                        AItemDrawRect.Bottom
                                        )
                                        );
                  end;
                end;
            end
            else
            begin
              ACanvas.DrawRect(ASkinVirtualListMaterial.FDrawGroupEndDevideParam,AItemDrawRect);
            end;
        end;
    end;



    if (Not FIsGroupEnd) and (ASkinItem.ItemType<>sitSpace) then
    begin
        //绘制普通分隔线
        Inherited;
        
    end;

end;




{ TSkinVirtualListDefaultMaterial }


procedure TSkinVirtualListDefaultMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinVirtualListDefaultMaterial;
begin
  if Dest is TSkinVirtualListDefaultMaterial then
  begin
    Inherited;

    DestObject:=TSkinVirtualListDefaultMaterial(Dest);

    DestObject.FIsSimpleDrawGroupBeginDevide:=FIsSimpleDrawGroupBeginDevide;
    DestObject.FIsSimpleDrawGroupEndDevide:=FIsSimpleDrawGroupEndDevide;

    DestObject.FIsSimpleDrawGroupRoundRect:=FIsSimpleDrawGroupRoundRect;


  end;
  inherited;
end;

function TSkinVirtualListDefaultMaterial.GetSkinCustomListItemMaterialClass:TBaseSkinItemMaterialClass;
begin
  Result:=TSkinListItemMaterial;
end;

constructor TSkinVirtualListDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FIsAutoAdjustItemDesignerPanelSize:=True;



  FDrawSpaceParam:=CreateDrawRectParam('DrawSpaceParam','间隔项背景绘制参数');
  FDrawSpaceParam.IsControlParam:=False;

  FDrawGroupBeginDevideParam:=CreateDrawRectParam('DrawGroupBeginDevideParam','分组开始分隔线绘制参数');
  FDrawGroupBeginDevideParam.FillDrawColor.InitDefaultColor(Const_DefaultBorderColor);
  FDrawGroupBeginDevideParam.BorderDrawColor.InitDefaultColor(Const_DefaultBorderColor);
  FDrawGroupBeginDevideParam.IsControlParam:=False;

  FDrawGroupEndDevideParam:=CreateDrawRectParam('DrawGroupEndDevideParam','分组结束分隔线绘制参数');
  FDrawGroupEndDevideParam.IsControlParam:=False;
  FDrawGroupEndDevideParam.FillDrawColor.InitDefaultColor(Const_DefaultBorderColor);
  FDrawGroupEndDevideParam.BorderDrawColor.InitDefaultColor(Const_DefaultBorderColor);

  FIsSimpleDrawGroupRoundRect:=False;


  FIsSimpleDrawGroupBeginDevide:=True;
  FIsSimpleDrawGroupEndDevide:=True;
end;

function TSkinVirtualListDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];


    if ABTNode.NodeName='IsSimpleDrawGroupBeginDevide' then
    begin
      FIsSimpleDrawGroupBeginDevide:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsSimpleDrawGroupEndDevide' then
    begin
      FIsSimpleDrawGroupEndDevide:=ABTNode.ConvertNode_Bool32.Data;
    end

    else if ABTNode.NodeName='IsSimpleDrawGroupRoundRect' then
    begin
      FIsSimpleDrawGroupRoundRect:=ABTNode.ConvertNode_Bool32.Data;
    end


    ;
  end;

  Result:=True;
end;

function TSkinVirtualListDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsSimpleDrawGroupBeginDevide','是否简单绘制分组开始分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsSimpleDrawGroupBeginDevide;
  ABTNode:=ADocNode.AddChildNode_Bool32('IsSimpleDrawGroupEndDevide','是否简单绘制分组结束分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsSimpleDrawGroupEndDevide;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsSimpleDrawGroupRoundRect','是否简单绘制分组矩形');
  ABTNode.ConvertNode_Bool32.Data:=FIsSimpleDrawGroupRoundRect;


  Result:=True;
end;

destructor TSkinVirtualListDefaultMaterial.Destroy;
begin

  FreeAndNil(FDrawSpaceParam);

  FreeAndNil(FDrawGroupBeginDevideParam);
  FreeAndNil(FDrawGroupEndDevideParam);
  inherited;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemCaptionParam: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemCaptionParam;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemDetail1Param: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemDetail1Param;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemDetail2Param: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemDetail2Param;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemDetail3Param: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemDetail3Param;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemDetail4Param: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemDetail4Param;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemDetail5Param: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemDetail5Param;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemDetail6Param: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemDetail6Param;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemDetailParam: TDrawTextParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemDetailParam;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemIconParam: TDrawPictureParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemIconParam;
end;

function TSkinVirtualListDefaultMaterial.GetDrawItemPicParam: TDrawPictureParam;
begin
  Result:=DefaultTypeItemMaterial.FDrawItemPicParam;
end;

function TSkinVirtualListDefaultMaterial.GetItem1TypeItemMaterial: TSkinListItemMaterial;
begin
  Result:=TSkinListItemMaterial(FItem1TypeItemMaterial);
end;

procedure TSkinVirtualListDefaultMaterial.SetIsSimpleDrawGroupBeginDevide(const Value: Boolean);
begin
  if FIsSimpleDrawGroupBeginDevide<>Value then
  begin
    FIsSimpleDrawGroupBeginDevide := Value;
    Self.DoChange;
  end;
end;

procedure TSkinVirtualListDefaultMaterial.SetIsSimpleDrawGroupEndDevide(const Value: Boolean);
begin
  if FIsSimpleDrawGroupEndDevide<>Value then
  begin
    FIsSimpleDrawGroupEndDevide := Value;
    Self.DoChange;
  end;
end;

procedure TSkinVirtualListDefaultMaterial.SetIsSimpleDrawGroupRoundRect(const Value: Boolean);
begin
  if FIsSimpleDrawGroupRoundRect<>Value then
  begin
    FIsSimpleDrawGroupRoundRect := Value;
    Self.DoChange;
  end;
end;

procedure TSkinVirtualListDefaultMaterial.SetItem1TypeItemMaterial(
  const Value: TSkinListItemMaterial);
begin
  FItem1TypeItemMaterial.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDefaultTypeItemMaterial(const Value: TSkinListItemMaterial);
begin
  FDefaultTypeItemMaterial.Assign(Value);
end;

function TSkinVirtualListDefaultMaterial.GetDefaultTypeItemMaterial: TSkinListItemMaterial;
begin
  Result:=TSkinListItemMaterial(FDefaultTypeItemMaterial);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawGroupBeginDevideParam(const Value: TDrawRectParam);
begin
  FDrawGroupBeginDevideParam.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawGroupEndDevideParam(const Value: TDrawRectParam);
begin
  FDrawGroupEndDevideParam.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemCaptionParam(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemCaptionParam.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemDetailParam(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemDetailParam.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemDetail1Param(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemDetail1Param.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemDetail2Param(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemDetail2Param.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemDetail3Param(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemDetail3Param.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemDetail4Param(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemDetail4Param.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemDetail5Param(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemDetail5Param.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemDetail6Param(const Value: TDrawTextParam);
begin
  DefaultTypeItemMaterial.FDrawItemDetail6Param.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawSpaceParam(const Value: TDrawRectParam);
begin
  FDrawSpaceParam.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemPicParam(const Value: TDrawPictureParam);
begin
  DefaultTypeItemMaterial.FDrawItemPicParam.Assign(Value);
end;

procedure TSkinVirtualListDefaultMaterial.SetDrawItemIconParam(const Value: TDrawPictureParam);
begin
  DefaultTypeItemMaterial.FDrawItemIconParam.Assign(Value);
end;






{ TSkinListItemMaterial }


constructor TSkinListItemMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawItemIconParam:=CreateDrawPictureParam('DrawItemIconParam','图标绘制参数');
  FDrawItemIconParam.IsControlParam:=False;

  FDrawItemPicParam:=CreateDrawPictureParam('DrawItemPicParam','图片绘制参数');
  FDrawItemPicParam.IsControlParam:=False;

  FDrawItemCaptionParam:=CreateDrawTextParam('DrawItemCaptionParam','标题绘制参数');
  FDrawItemCaptionParam.IsControlParam:=False;


  FDrawItemDetailParam:=CreateDrawTextParam('DrawItemDetailParam','明细绘制参数');
  FDrawItemDetailParam.IsControlParam:=False;
  FDrawItemDetail1Param:=CreateDrawTextParam('DrawItemDetail1Param','明细1绘制参数');
  FDrawItemDetail1Param.IsControlParam:=False;
  FDrawItemDetail2Param:=CreateDrawTextParam('DrawItemDetail2Param','明细2绘制参数');
  FDrawItemDetail2Param.IsControlParam:=False;
  FDrawItemDetail3Param:=CreateDrawTextParam('DrawItemDetail3Param','明细3绘制参数');
  FDrawItemDetail3Param.IsControlParam:=False;
  FDrawItemDetail4Param:=CreateDrawTextParam('DrawItemDetail4Param','明细4绘制参数');
  FDrawItemDetail4Param.IsControlParam:=False;
  FDrawItemDetail5Param:=CreateDrawTextParam('DrawItemDetail5Param','明细5绘制参数');
  FDrawItemDetail5Param.IsControlParam:=False;
  FDrawItemDetail6Param:=CreateDrawTextParam('DrawItemDetail6Param','明细6绘制参数');
  FDrawItemDetail6Param.IsControlParam:=False;


end;

destructor TSkinListItemMaterial.Destroy;
begin
  FreeAndNil(FDrawItemIconParam);
  FreeAndNil(FDrawItemPicParam);
  FreeAndNil(FDrawItemCaptionParam);

  FreeAndNil(FDrawItemDetailParam);
  FreeAndNil(FDrawItemDetail1Param);
  FreeAndNil(FDrawItemDetail2Param);
  FreeAndNil(FDrawItemDetail3Param);
  FreeAndNil(FDrawItemDetail4Param);
  FreeAndNil(FDrawItemDetail5Param);
  FreeAndNil(FDrawItemDetail6Param);

  inherited;
end;

procedure TSkinListItemMaterial.SetDrawItemCaptionParam(const Value: TDrawTextParam);
begin
  FDrawItemCaptionParam.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemDetailParam(const Value: TDrawTextParam);
begin
  FDrawItemDetailParam.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemDetail1Param(const Value: TDrawTextParam);
begin
  FDrawItemDetail1Param.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemDetail2Param(const Value: TDrawTextParam);
begin
  FDrawItemDetail2Param.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemDetail3Param(const Value: TDrawTextParam);
begin
  FDrawItemDetail3Param.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemDetail4Param(const Value: TDrawTextParam);
begin
  FDrawItemDetail4Param.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemDetail5Param(const Value: TDrawTextParam);
begin
  FDrawItemDetail5Param.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemDetail6Param(const Value: TDrawTextParam);
begin
  FDrawItemDetail6Param.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemIconParam(const Value: TDrawPictureParam);
begin
  FDrawItemIconParam.Assign(Value);
end;

procedure TSkinListItemMaterial.SetDrawItemPicParam(const Value: TDrawPictureParam);
begin
  FDrawItemPicParam.Assign(Value);
end;




{ TSkinVirtualList }

function TSkinVirtualList.Material:TSkinVirtualListDefaultMaterial;
begin
  Result:=TSkinVirtualListDefaultMaterial(SelfOwnMaterial);
end;

function TSkinVirtualList.SelfOwnMaterialToDefault:TSkinVirtualListDefaultMaterial;
begin
  Result:=TSkinVirtualListDefaultMaterial(SelfOwnMaterial);
end;

function TSkinVirtualList.CurrentUseMaterialToDefault:TSkinVirtualListDefaultMaterial;
begin
  Result:=TSkinVirtualListDefaultMaterial(CurrentUseMaterial);
end;

function TSkinVirtualList.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TVirtualListProperties;
end;

function TSkinVirtualList.GetVirtualListProperties: TVirtualListProperties;
begin
  Result:=TVirtualListProperties(Self.FProperties);
end;

procedure TSkinVirtualList.SetVirtualListProperties(Value: TVirtualListProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinVirtualList.TranslateControlLang(APrefix: String; ALang: TLang;ACurLang: String);
var
  I: Integer;
  ATag:String;
begin
  inherited;

  Prop.Items.BeginUpdate;
  try
      for I := 0 to Self.Prop.Items.Count-1 do
      begin
        if (Self.Prop.Items[I].Name<>'') then
        begin
            //ListBox.Item.send_addr.Caption
            ATag:=APrefix+Name+'.Item.';

            Self.Prop.Items[I].TranslateControlLang(ATag,ALang,ACurLang);

        end;

      end;
  finally
    Prop.Items.EndUpdate;
  end;
end;

function TSkinVirtualList.GetItems:TBaseSkinItems;
begin
  Result:=Self.Properties.Items;
end;

procedure TSkinVirtualList.Loaded;
begin
  Inherited;
  Self.Properties.Items.EndUpdate(True);

  //默认选中居中显示项
  if Properties.IsEnabledCenterItemSelectMode then
  begin
    Properties.DoAdjustCenterItemPositionAnimateEnd(Self);
  end;
end;

procedure TSkinVirtualList.ReadState(Reader: TReader);
begin
  Self.Properties.Items.BeginUpdate;
  inherited ReadState(Reader);
end;

procedure TSkinVirtualList.RecordControlLangIndex(APrefix: String; ALang: TLang;
  ACurLang: String);
var
  I: Integer;
  ATag:String;
begin
  inherited;

  for I := 0 to Self.Prop.Items.Count-1 do
  begin
    if (Self.Prop.Items[I].Name<>'') then
    begin
        //ListBox.Item.send_addr.Caption
        ATag:=APrefix+Name+'.Item.';

        Self.Prop.Items[I].RecordControlLangIndex(ATag,ALang,ACurLang);

    end;

  end;
end;

procedure TSkinVirtualList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin

      //所关联的Component释放之后,清除引用

      if (AComponent=Self.Properties.ItemDesignerPanel) then
      begin
        Self.Properties.ItemDesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.Item1DesignerPanel) then
      begin
        Self.Properties.Item1DesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.Item2DesignerPanel) then
      begin
        Self.Properties.Item2DesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.Item3DesignerPanel) then
      begin
        Self.Properties.Item3DesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.Item4DesignerPanel) then
      begin
        Self.Properties.Item4DesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.HeaderDesignerPanel) then
      begin
        Self.Properties.HeaderDesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.FooterDesignerPanel) then
      begin
        Self.Properties.FooterDesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.SearchBarDesignerPanel) then
      begin
        Self.Properties.SearchBarDesignerPanel:=nil;
      end;
      if (AComponent=Self.Properties.ItemPanDragDesignerPanel) then
      begin
        Self.Properties.ItemPanDragDesignerPanel:=nil;
      end;


      if (AComponent=Self.Properties.DownloadPictureManager) then
      begin
        Self.Properties.DownloadPictureManager:=nil;
      end;



      if (AComponent=Self.Properties.SkinImageList) then
      begin
        Self.Properties.SkinImageList:=nil;
      end;

    end
    ;
  end;
end;



function TSkinVirtualList.GetOnAdvancedDrawItem: TVirtualListDrawItemEvent;
begin
  Result:=FOnAdvancedDrawItem;
end;

function TSkinVirtualList.GetOnClickItem: TVirtualListClickItemEvent;
begin
  Result:=FOnClickItem;
end;

function TSkinVirtualList.GetOnLongTapItem: TVirtualListDoItemEvent;
begin
  Result:=FOnLongTapItem;
end;

function TSkinVirtualList.GetOnClickItemEx: TVirtualListClickItemExEvent;
begin
  Result:=FOnClickItemEx;
end;

function TSkinVirtualList.GetOnCenterItemChange: TVirtualListDoItemEvent;
begin
  Result:=FOnCenterItemChange;
end;

function TSkinVirtualList.GetOnPrepareDrawItem: TVirtualListDrawItemEvent;
begin
  Result:=FOnPrepareDrawItem;
end;

function TSkinVirtualList.GetOnGetItemBufferCacheTag:TVirtualListGetItemBufferCacheTagEvent;
begin
  Result:=FOnGetItemBufferCacheTag;
end;

function TSkinVirtualList.GetOnSelectedItem: TVirtualListDoItemEvent;
begin
  Result:=FOnSelectedItem;
end;

function TSkinVirtualList.GetOnStartEditingItem: TVirtualListEditingItemEvent;
begin
  Result:=FOnStartEditingItem;
end;

function TSkinVirtualList.GetOnStopEditingItem: TVirtualListEditingItemEvent;
begin
  Result:=FOnStopEditingItem;
end;

function TSkinVirtualList.GetOnPrepareItemPanDrag: TVirtualListPrepareItemPanDragEvent;
begin
  Result:=FOnPrepareItemPanDrag;
end;





{ TSkinListItemMaterialItem }

constructor TSkinListItemMaterialItem.Create(Collection: TCollection);
begin
  inherited;

  FMaterial:=TSkinListItemMaterial.Create(nil);
  FMaterial.SetSubComponent(True);

end;

destructor TSkinListItemMaterialItem.Destroy;
begin
  FreeAndNil(FMaterial);

  inherited;
end;

procedure TSkinListItemMaterialItem.SetMaterial(
  const Value: TSkinListItemMaterial);
begin
  FMaterial.AssignTo(Value);
end;

{ TSkinItemMaterialStylePackage }

constructor TSkinItemMaterialStylePackage.Create(AOwner: TComponent);
begin
  inherited;
  FMaterials:=TSkinListItemMaterials.Create(TSkinListItemMaterialItem);

end;

destructor TSkinItemMaterialStylePackage.Destroy;
begin
  FreeAndNil(FMaterials);
  inherited;
end;

function TSkinItemMaterialStylePackage.GetMaterial(
  AStyleName: String): TSkinListItemMaterial;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.FMaterials.Count-1 do
  begin
    if SameText(FMaterials[I].FStyleName,AStyleName) then
    begin
      Result:=FMaterials[I].FMaterial;
      Break;
    end;
  end;
end;

procedure TSkinItemMaterialStylePackage.SetMaterials(
  const Value: TSkinListItemMaterials);
begin
  FMaterials.Assign(Value);
end;

{ TSkinListItemMaterials }

function TSkinListItemMaterials.GetItem(Index: Integer): TSkinListItemMaterialItem;
begin
  Result:=TSkinListItemMaterialItem(Inherited Items[Index]);
end;



var
  AMaterialItem:TSkinListItemMaterialItem;

initialization
  GlobalSkinItemMaterialStylePackage:=TSkinItemMaterialStylePackage.Create(nil);

  //添加列表项的风格
  AMaterialItem:=TSkinListItemMaterialItem(GlobalSkinItemMaterialStylePackage.FMaterials.Add);
  AMaterialItem.StyleName:='CaptionBigLeft';
  AMaterialItem.Desc:='标题字体大,16号,水平居左垂直居中显示,左边有24个像素的边距'+#13#10
                      +'背景色点击的时候会变淡灰色'+#13#10
                      +'从PopupMenuFrame中获取';
  AMaterialItem.Material.DrawItemCaptionParam.FontSize := 16;
  AMaterialItem.Material.DrawItemCaptionParam.DrawFont.Size := 16;
  AMaterialItem.Material.DrawItemCaptionParam.FontVertAlign := fvaCenter;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.Left := 24;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.Right := 24;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.Enabled := True;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.SizeType := dpstPixel;
  AMaterialItem.Material.DrawItemBackColorParam.DrawEffectSetting.MouseDownEffect.IsFill := True;
  AMaterialItem.Material.DrawItemBackColorParam.DrawEffectSetting.MouseDownEffect.FillColor.Color := LightgrayColor;
  AMaterialItem.Material.DrawItemBackColorParam.DrawEffectSetting.MouseDownEffect.EffectTypes := [drpetFillColorChange, drpetIsFillChange];


  //添加列表项的风格
  AMaterialItem:=TSkinListItemMaterialItem(GlobalSkinItemMaterialStylePackage.FMaterials.Add);
  AMaterialItem.StyleName:='CaptionBigLeft_DetailGrayRight';
  AMaterialItem.Desc:='标题字体大,16号,水平居左垂直居中,左边有24个像素的边距'+#13#10
                     +'明细字体灰色,水平居右垂直居中'+#13#10
                     +'背景色点击的时候会变淡灰色';
  AMaterialItem.Material.DrawItemCaptionParam.FontSize := 16;
  AMaterialItem.Material.DrawItemCaptionParam.DrawFont.Size := 16;
  AMaterialItem.Material.DrawItemCaptionParam.FontVertAlign := fvaCenter;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.Left := 24;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.Right := 24;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.Enabled := True;
  AMaterialItem.Material.DrawItemCaptionParam.DrawRectSetting.SizeType := dpstPixel;
  AMaterialItem.Material.DrawItemDetailParam.FontSize := 16;
  AMaterialItem.Material.DrawItemDetailParam.DrawFont.Color := LightgrayColor;
  AMaterialItem.Material.DrawItemDetailParam.DrawFont.Size := 16;
  AMaterialItem.Material.DrawItemDetailParam.FontVertAlign := fvaCenter;
  AMaterialItem.Material.DrawItemDetailParam.FontHorzAlign := fhaRight;
  AMaterialItem.Material.DrawItemDetailParam.DrawRectSetting.Left := 24;
  AMaterialItem.Material.DrawItemDetailParam.DrawRectSetting.Right := 24;
  AMaterialItem.Material.DrawItemDetailParam.DrawRectSetting.Enabled := True;
  AMaterialItem.Material.DrawItemDetailParam.DrawRectSetting.SizeType := dpstPixel;
  AMaterialItem.Material.DrawItemBackColorParam.DrawEffectSetting.MouseDownEffect.IsFill := True;
  AMaterialItem.Material.DrawItemBackColorParam.DrawEffectSetting.MouseDownEffect.FillColor.Color := LightgrayColor;
  AMaterialItem.Material.DrawItemBackColorParam.DrawEffectSetting.MouseDownEffect.EffectTypes := [drpetFillColorChange, drpetIsFillChange];



finalization
  FreeAndNil(GlobalSkinItemMaterialStylePackage);

end.



