/// <summary>
///   <para>
///     自定义列表框
///   </para>
///   <para>
///     Custom List Box
///   </para>
/// </summary>
unit uSkinCustomListType;


interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,
  DateUtils,
  Math,
  StrUtils,

  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  Forms,
  StdCtrls,
  Graphics,
  Dialogs,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,
  FMX.Graphics,

  FMX.Edit,
  FMX.Memo,
  FMX.ListBox,
  FMX.ComboEdit,
  FMX.Forms,
  {$ENDIF}


  uSkinPicture,
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
  uSkinImageType,
  uBasePageStructure,

//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}



//  BaseListItemStyleFrame,
  uSkinItemDesignerPanelType,

  {$IFDEF VCL}
//  uSkinWindowsItemDesignerPanel,
  {$ENDIF}
  {$IFDEF FMX}
  uSkinFireMonkeyItemDesignerPanel,
  {$ENDIF}


  uSkinControlGestureManager,
  uSkinControlPanDragGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;



const
  IID_ISkinCustomList:TGUID='{5DDEC959-1404-4586-878C-B9FA44EEE20C}';


const
  IID_IFrameBaseListItemStyle:TGUID='{5600B7F4-122E-4E7B-AD72-F9F3C3B4CB1D}';
  IID_IFrameBaseListItemStyle_Init:TGUID='{BE00E25C-17BF-42D6-A703-F25F84F86F6D}';


type
  TSkinCustomListLayoutsManagerClass=class of TSkinCustomListLayoutsManager;
  TBaseSkinItemMaterialClass=class of TBaseSkinListItemMaterial;
  TCustomListProperties=class;






  //ListBox.Prop.ItemHeight,
  //如果是-1,表示是控件的高度,
  //如果是>=0,设置多少就是多少
  //ListBox.Prop.ItemWidth,
  //如果是-1,表示是控件的宽度,
  //如果是>=0,那么设置多少就是多少


  //TBaseSkinItem.Width,
  //如果是-1,表示使用ListBox.Prop.ItemWidth,
  //如果是是>=0,那么设置多少就是多少
  //TBaseSkinItem.Height,
  //如果是-1,表示使用ListBox.Prop.ItemHeight,
  //如果是>=0,那么设置多少就是多少



  //编辑列表项的事件
  TCustomListEditingItemEvent=procedure(Sender:TObject;
                                        AItem:TBaseSkinItem;
                                        AEditControl:TChildControl) of object;
  //绘制列表项事件
  TCustomListDrawItemEvent=procedure(Sender:TObject;
                                      ACanvas:TDrawCanvas;
                                      AItem:TBaseSkinItem;
                                      AItemDrawRect:TRect) of object;
  //列表项点击扩展事件
  TCustomListClickItemExEvent=procedure(Sender:TObject;
                                        AItem:TBaseSkinItem;
                                        X:Double;Y:Double) of object;
  TCustomListClickItemEvent=procedure(AItem:TBaseSkinItem) of object;
  //选中列表项的事件
  TCustomListDoItemEvent=procedure(Sender:TObject;
                                  AItem:TBaseSkinItem) of object;
  //点击设计面板上面子控件的事件
  TCustomListClickItemDesignerPanelChildEvent=procedure(Sender:TObject;
                                        AItem:TBaseSkinItem;//这里应该用TBaseSkinItem
                                        AItemDesignerPanel:TItemDesignerPanel;
                                        AChild:TChildControl) of object;
//  //设计面板上面的子控件是否可以启动编辑
//  TCustomListItemDesignerPanelChildCanStartEditEvent=procedure(Sender:TObject;
//                                        AItem:TSkinItem;
//                                        AItemDesignerPanel:TSkinItemDesignerPanel;
//                                        AChild:TChildControl;
//                                        var AIsCanStartEditingItem:Boolean) of object;


  //初始列表项平拖所使用的ItemPanDragDesignerPanel
  TCustomListPrepareItemPanDragEvent=procedure(Sender:TObject;
      AItem:TBaseSkinItem;
      var AItemIsCanPanDrag:Boolean) of object;


  TPanDragGestureDirectionType=(
                                ipdgdtLeft,
                                ipdgdtRight//,
//                                ipdgdtTop,
//                                ipdgdtBottom
                                );



  TListItemStyleReg=class;



  /// <summary>
  ///   <para>
  ///     虚拟列表框接口
  ///   </para>
  ///   <para>
  ///     Interface of CustomList Box
  ///   </para>
  /// </summary>
  ISkinCustomList=interface//(ISkinScrollControl)
    ['{5DDEC959-1404-4586-878C-B9FA44EEE20C}']

    function GetOnClickItem: TCustomListClickItemEvent;
    function GetOnLongTapItem: TCustomListDoItemEvent;
    function GetOnClickItemEx: TCustomListClickItemExEvent;
    function GetOnSelectedItem: TCustomListDoItemEvent;
    function GetOnCenterItemChange:TCustomListDoItemEvent;

    function GetOnPrepareDrawItem: TCustomListDrawItemEvent;
    function GetOnAdvancedDrawItem: TCustomListDrawItemEvent;

    function GetOnStartEditingItem: TCustomListEditingItemEvent;
    function GetOnStopEditingItem: TCustomListEditingItemEvent;

    function GetOnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent;

    function GetOnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent;
//    function GetOnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent;

    function GetOnMouseOverItemChange:TNotifyEvent;
    property OnMouseOverItemChange:TNotifyEvent read GetOnMouseOverItemChange;

    //居中列表项更改事件
    property OnCenterItemChange:TCustomListDoItemEvent read GetOnCenterItemChange;

    //点击列表项事件
    property OnClickItem:TCustomListClickItemEvent read GetOnClickItem;
    //长按列表项事件
    property OnLongTapItem:TCustomListDoItemEvent read GetOnLongTapItem;
    //点击列表项事件
    property OnClickItemEx:TCustomListClickItemExEvent read GetOnClickItemEx;
    //列表项被选中的事件
    property OnSelectedItem:TCustomListDoItemEvent read GetOnSelectedItem;


    //每次绘制列表项之前准备
    property OnPrepareDrawItem:TCustomListDrawItemEvent read GetOnPrepareDrawItem;
    //增强绘制列表项事件
    property OnAdvancedDrawItem:TCustomListDrawItemEvent read GetOnAdvancedDrawItem;

    //准备平拖事件(可以根据Item设置ItemPanDragDesignerPanel,是否允许平拖的功能)
    property OnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent read GetOnPrepareItemPanDrag;

    //列表项开始编辑事件
    property OnStartEditingItem:TCustomListEditingItemEvent read GetOnStartEditingItem;
    //列表项结束编辑事件
    property OnStopEditingItem:TCustomListEditingItemEvent read GetOnStopEditingItem;

    //用于一个设计面板共享给多个ListBox使用的时候,
    //可以在ListBox中的此事件分别处理对应的操作
    property OnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent read GetOnClickItemDesignerPanelChild;
//    property OnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent read GetOnItemDesignerPanelChildCanStartEdit;


    function GetCustomListProperties:TCustomListProperties;
    property Properties:TCustomListProperties read GetCustomListProperties;
    property Prop:TCustomListProperties read GetCustomListProperties;
  end;














  TFrameClass=class of TFrame;

  IFrameBaseListItemStyle=interface
    ['{5600B7F4-122E-4E7B-AD72-F9F3C3B4CB1D}']
    function GetItemDesignerPanel:TSkinItemDesignerPanel;

    property ItemDesignerPanel:TSkinItemDesignerPanel read GetItemDesignerPanel;
  end;


  //同一个Frame给多个样式使用时,根据不同Reg.DataObject来初始
  IFrameBaseListItemStyle_Init=interface
    ['{BE00E25C-17BF-42D6-A703-F25F84F86F6D}']
    procedure Init(AListItemStyleReg:TListItemStyleReg);
    procedure SetPage(APage:TObject);
  end;



  //列表项风格注册项
  TListItemStyleReg=class
  public
    //风格名称
    Name:String;
    //设计面板Frame,使用的时候创建一个Frame,
    //并且使用里面的ItemDesignerPanel
    FrameClass:TFrameClass;
    //默认列表项高度
    DefaultItemHeight:Double;
    //是否需要自适应尺寸
    IsAutoSize:Boolean;
    //自定义数据,在Frame创建的时候使用的
    DataObject:TObject;
  end;
  TListItemStyleRegList=class(TBaseList)
  private
    function GetItem(Index: Integer): TListItemStyleReg;
  public
    property Items[Index:Integer]:TListItemStyleReg read GetItem;default;
    function FindItemByName(AName:String):TListItemStyleReg;
    function FindItemByClass(AFrameClass:TFrameClass):TListItemStyleReg;
  end;




  //每个ListBox的设计面板Frame的缓存
  TListItemStyleFrameCache=class
  public
    //是否被使用
    FIsUsed:Boolean;
    //是哪个Item使用了
    FSkinItem:TBaseSkinItem;
    FItemStyleFrame:TFrame;
    FItemStyleFrameIntf:IFrameBaseListItemStyle;
    FItemStyleFrameInitIntf:IFrameBaseListItemStyle_Init;
    destructor Destroy;override;
  end;
  TListItemStyleFrameCacheList=class(TBaseList)
  private
    function GetItem(Index: Integer): TListItemStyleFrameCache;
  public
    property Items[Index:Integer]:TListItemStyleFrameCache read GetItem;default;
  end;

  TListItemTypeStyleSetting=class;
  TNewListItemStyleFrameCacheInitEvent=procedure(Sender:TObject;AListItemTypeStyleSetting:TListItemTypeStyleSetting;ANewListItemStyleFrameCache:TListItemStyleFrameCache) of object;
  //列表项类型的风格设置,每个类型一个,Default,Item1,Item2,Header,Footer等
  TListItemTypeStyleSetting=class
  private
  private
    //用于给用户在设计时指定的设计面板,而不使用风格
    //原来是直接ListBox.FItemDesignerPanel,现在是设置到StyleSetting.FItemDesignerPanel
    FItemDesignerPanel:TSkinItemDesignerPanel;
  private
    FItemType:TSkinItemType;



    //默认是使用缓存的
    //ListItemStyleFrame可以缓存,ItemDesignerPanel也可以缓存的
    FIsUseCache: Boolean;
    //缓存列表
    FFrameCacheList:TListItemStyleFrameCacheList;
//    //自定义绑定,格式：
//    FCustomBinding: String;



    procedure SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
    procedure SetStyle(const Value: String);
    procedure SetIsUseUrlStyle(const Value: Boolean);
    procedure SetStyleRootUrl(const Value: String);
    procedure DoDownloadListItemStyleStateChange(Sender:TObject;AUrlCacheItem:TUrlCacheItem);
    procedure SetListItemStyleReg(AListItemStyleReg:TListItemStyleReg);
    procedure SetConfig(const Value: TStringList);
    procedure ReConfig;
  public
    procedure Clear;
    constructor Create(AProp:TCustomListProperties;AItemType:TSkinItemType);
    destructor Destroy;override;
  public
    //0.开始绘制时,先将所有的缓存 标记为不使用,仅将FIsUsed设置为False,但是FSkinItem不清除
    procedure MarkAllCacheNoUsed;
    //1.将对应Item的缓存标记为使用,找回属于FSkinItem自己的缓存
    procedure MarkCacheUsed(ASkinItem:TBaseSkinItem);
    //2.接着,获取Item对应的缓存,
    //获取未使用的Frame,并占为已用,如果在绘制时没有可用的缓存时,再创建一个
    //获取可用的Frame缓存
    function GetItemStyleFrameCache(ASkinItem:TBaseSkinItem):TListItemStyleFrameCache;
      function NewListItemStyleFrameCache:TListItemStyleFrameCache;
        //3.获取可用的设计面板
        function GetInnerItemDesignerPanel(ASkinItem:TBaseSkinItem):TSkinItemDesignerPanel;
  public
    //自动计算列表项的尺寸
    function CalcItemAutoSize(AItem: TBaseSkinItem;const ABottomSpace:TControlSize=20): TSizeF;
  public
    //个性化配置,比如同一个列表项样式给不用的ListBox使用,大致上样式差不多，有时候可能只需要改个字体颜色之类的
    //当然这也可以在OnPrepareDrawItem事件中初始
    FConfig:TStringList;
    //风格名
    FStyle:String;
    FStyleRootUrl: String;
    FIsUseUrlStyle: Boolean;
    //风格注册项,省的创建的时候每次找
    FListItemStyleReg:TListItemStyleReg;
    FCustomListProperties:TCustomListProperties;

    //列表项样式Frame初始事件
    FOnInit:TNewListItemStyleFrameCacheInitEvent;
    procedure ResetStyle;

    //是否使用缓存,默认是使用的
    property IsUseCache:Boolean read FIsUseCache write FIsUseCache;
    //列表项风格名称
    property Style:String read FStyle write SetStyle;
    //列表项设计面板
    property ItemDesignerPanel:TSkinItemDesignerPanel read FItemDesignerPanel write SetItemDesignerPanel;


    //property UrlStyle:String read FUrlStyle write SetUrlStyle;
    //是否使用来源链接
    property IsUseUrlStyle:Boolean read FIsUseUrlStyle write SetIsUseUrlStyle;
    //来源链接
    property StyleRootUrl:String read FStyleRootUrl write SetStyleRootUrl;

//    //自定义绑定
//    property CustomBinding:String read FCustomBinding write FCustomBinding;
    property Config:TStringList read FConfig write SetConfig;

  end;
  TListItemTypeStyleSettingList=class(TBaseList)
  private
    function GetItem(Index: Integer): TListItemTypeStyleSetting;
  public
    function FindByItemType(AItemType:TSkinItemType):TListItemTypeStyleSetting;
    function FindByStyle(AStyle:String):TListItemTypeStyleSetting;
    property Items[Index:Integer]:TListItemTypeStyleSetting read GetItem;default;
  end;




  //获取在线列表项样式的事件
//  TGetUrlListItemStyleRegEvent=procedure(Sender:TObject;
//                                          AListItemTypeStyleSetting:TListItemTypeStyleSetting;
//                                          AUrlCacheItem:TUrlCacheItem;
//                                          var AListItemStyleReg:TListItemStyleReg);
  TGetUrlListItemStyleRegEvent=procedure(AListItemTypeStyleSetting:TListItemTypeStyleSetting;AOnDownloadStateChange:TDownloadProgressStateChangeEvent);
  TBaseUrlListItemStyle=class(TUrlCacheItem)
  public
    FListItemStyleReg:TListItemStyleReg;
  end;












  /// <summary>
  ///   <para>
  ///     虚拟列表框属性
  ///   </para>
  ///   <para>
  ///     Properties of CustomList Box
  ///   </para>
  /// </summary>
  TCustomListProperties=class(TScrollControlProperties)
  protected
    //是否启用列表项多选
    FMultiSelect:Boolean;


    //是否点击列表项就自动选中
    FIsAutoSelected:Boolean;


    //居中选择项
    FCenterItem:TBaseSkinItem;
    //是否启用居中选择模式
    FIsEnabledCenterItemSelectMode: Boolean;


    //鼠标按下的列表项
    //有时候鼠标点击在ItemDesignerPanel的子控件上,
    //那么MouseDownItem为nil,不然列表项会有点击效果
    FMouseDownItem:TBaseSkinItem;
    FInteractiveMouseDownItem:TBaseSkinItem;

    //延迟调用ClickItem事件中使用
    FLastMouseDownItem:TBaseSkinItem;
    FLastMouseDownX:Double;
    FLastMouseDownY:Double;
    //鼠标按下的列表项
    //即使鼠标点击在ItemDesignerPanel的子控件上,
    //MouseDownItem为nil,InnerMouseDownItem指向鼠标所在行
    FInnerMouseDownItem:TBaseSkinItem;


    //鼠标停靠的列表项
    FMouseOverItem:TBaseSkinItem;

    //选中的列表项
    FSelectedItem:TBaseSkinItem;



    //平拖列表项的设计面板
    FItemPanDragDesignerPanel: TSkinItemDesignerPanel;
    //平拖的列表项
    FPanDragItem:TBaseSkinItem;
    //是否启用平拖
    FEnableItemPanDrag:Boolean;
    //允许列表项平拖的方向
    FItemPanDragGestureDirection:TPanDragGestureDirectionType;
    //平拖列表项手势管理
    FItemPanDragGestureManager:TSkinControlGestureManager;
    //列表项设计面板重绘链接
    FItemDesignerPanelInvalidateLink: TSkinObjectChangeLink;



    //居中项位置调整滚动器
    FAdjustCenterItemPositionAnimator:TSkinAnimator;


    FEmptyContentCaption: String;
    FEmptyContentDescription: String;
    FEmptyContentPicture: TDrawPicture;

    FSkinCustomListIntf:ISkinCustomList;

    FEmptyContentControl: TControl;
    procedure SetEmptyContentControl(const Value: TControl);

    procedure SetMouseDownItem(Value: TBaseSkinItem);
    procedure SetMouseOverItem(Value: TBaseSkinItem);
    procedure SetSelectedItem(Value: TBaseSkinItem);
    procedure SetCenterItem(Value: TBaseSkinItem);
    procedure SetPanDragItem(Value: TBaseSkinItem);


    procedure SetEmptyContentCaption(const Value: String);
    procedure SetEmptyContentDescription(const Value: String);
    procedure SetEmptyContentPicture(const Value: TDrawPicture);

    //需要执行原MouseOverItem.DrawItemDesignerPanel.MouseLeave事件
    procedure DoMouseOverItemChange(ANewItem,AOldItem: TBaseSkinItem);virtual;
  protected
    //当前编辑的列表项
    FEditingItem:TBaseSkinItem;

    //用来编辑的控件(一般是Edit,但也可以是ComboBox,ComboEdit,DateEdit等)
    FEditingItem_EditControl:TControl;
    FEditingItem_EditControlIntf:ISkinControl;
    //绑定控件的相对ItemDesignerPanel矩形(用于摆放EditControl的位置)
    FEditingItem_EditControlPutRect:TRectF;
    //可以设置鼠标消息事件,可以把输入值赋回给Item
    FEditingItem_EditControl_ItemEditorIntf:ICustomListItemEditor;


    //原始信息,用于结束编辑时恢复//
    //原Parent,结束编辑的时候赋回原Parent
    FEditingItem_EditControlOldParent:TChildControl;
    //原位置,结束编辑的时候设置回原位置
    FEditingItem_EditControlOldRect:TRectF;
    //原Align,结束编辑的时候设置回原Align
    FEditingItem_EditControlOldAlign:TAlignLayout;


    //结束编辑的时候把编辑框的值赋给Item的属性
    procedure DoSetValueToEditingItem;virtual;
    //结束编辑时调用,清空一些变量
    procedure DoStopEditingItemEnd;virtual;


    //控件手势管理者位置更改,相应更改滚动条的位置
    //滚动条滑动时更改编辑框的位置
    procedure DoVert_InnerPositionChange(Sender:TObject);override;
    procedure DoHorz_InnerPositionChange(Sender:TObject);override;

    //更新编辑控件的位置(在绘制的时候)
    procedure SyncEditControlBounds;
  public
    /// <summary>
    ///   <para>
    ///     开始编辑列表项
    ///   </para>
    ///   <para>
    ///     Start editing ListItem
    ///   </para>
    /// </summary>
    function StartEditingItem(
                                //编辑哪个列表项
                                AItem:TBaseSkinItem;
                                //编辑控件
                                AEditControl:TControl;
                                //编辑控件相对位置
                                AEditControlPutRect:TRectF;
                                //初始值
                                AEditValue:String;
                                //鼠标点击的相对坐标,用来确定输入光标的位置
                                X, Y: Double):Boolean;

    /// <summary>
    ///   <para>
    ///     结束编辑列表项
    ///   </para>
    ///   <para>
    ///     Stop editing ListItem
    ///   </para>
    /// </summary>
    procedure StopEditingItem;
    /// <summary>
    ///   <para>
    ///     取消编辑列表项
    ///   </para>
    ///   <para>
    ///     Cancel editing ListItem
    ///   </para>
    /// </summary>
    procedure CancelEditingItem;

    /// <summary>
    ///   <para>
    ///     获取当前编辑的项
    ///   </para>
    ///   <para>
    ///     Get editing item
    ///   </para>
    /// </summary>
    property EditingItem:TBaseSkinItem read FEditingItem;
  protected
    //列表项布局管理者
    FListLayoutsManager:TSkinCustomListLayoutsManager;

    //获取列表类
    function GetItemsClass:TBaseSkinItemsClass;virtual;
    //获取列表布局管理者
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;virtual;
  protected
    //FListLayoutsManager的属性//

    //获取列表项高度
    function GetItemHeight: Double;
    //获取列表项宽度
    function GetItemWidth: Double;
    //获取列表项间隔
    function GetItemSpace: Double;
    //获取列表项间隔类型
    function GetItemSpaceType: TSkinItemSpaceType;

    //获取列表项选中时的高度
    function GetSelectedItemHeight: Double;
    //获取列表项选中时的宽度
    function GetSelectedItemWidth: Double;


    //设置列表项高度
    procedure SetItemHeight(const Value: Double);
    //设置列表项宽度
    procedure SetItemWidth(const Value: Double);
    //设置列表项间隔
    procedure SetItemSpace(const Value: Double);
    //设置列表项间隔类型
    procedure SetItemSpaceType(const Value: TSkinItemSpaceType);

    //设置列表项选中时的高度
    procedure SetSelectedItemHeight(const Value: Double);
    //设置列表项选中时的宽度
    procedure SetSelectedItemWidth(const Value: Double);



    //列表项尺寸计算类型
    function GetItemHeightCalcType: TItemSizeCalcType;
    function GetItemWidthCalcType: TItemSizeCalcType;
    procedure SetItemHeightCalcType(const Value: TItemSizeCalcType);
    procedure SetItemWidthCalcType(const Value: TItemSizeCalcType);

    //列表的排列方式
    function GetItemLayoutType: TItemLayoutType;
    procedure SetItemLayoutType(const Value: TItemLayoutType);

  protected
    //FListLayoutsManager需要的事件


    //把控件高度传递给ListLayoutsManager
    function DoGetListLayoutsManagerControlHeight(Sender:TObject):Double;
    //把控件宽度传递给ListLayoutsManager
    function DoGetListLayoutsManagerControlWidth(Sender:TObject):Double;


    //ListLayoutsManager把选中Item的列表项传递给ListBox
    procedure DoSetListLayoutsManagerSelectedItem(Sender:TObject);


    //ListLayoutsManager传递出的列表项尺寸更改事件(需要重新计算内容尺寸,重绘列表)
    procedure DoItemSizeChange(Sender:TObject);virtual;
    //ListLayoutsManager传递出的列表项属性更改事件(重绘列表)
    procedure DoItemPropChange(Sender:TObject);virtual;
    //ListLayoutsManager传递出的列表项隐藏显示更改事件(需要重新计算内容尺寸,重绘列表)
    procedure DoItemVisibleChange(Sender:TObject);virtual;

  public
    //
    function GetItemTopDrawOffset:Double;virtual;

    //计算内容尺寸(用于处理滚动条的Max)
    function CalcContentWidth:Double;override;
    function CalcContentHeight:Double;override;
  protected

    //给列表项赋值
    procedure SetItems(const Value: TBaseSkinItems);

    //列表更改事件
    procedure DoItemsChange(Sender:TObject);virtual;
    //列表项删除事件
    procedure DoItemDelete(Sender:TObject;AItem:TObject;AIndex:Integer);virtual;
  protected
    //长按列表项事件处理//

    //是否已经调用了OnLongTapItem事件,
    //如果已经调用了OnLongTapItem事件,
    //那么不再调用OnClickItem事件
    FHasCalledOnLongTapItem:Boolean;
    //检测长按定时器
    FCheckLongTapItemTimer:TTimer;
    //超过多长时间算长按(默认一秒)
    FLongTapItemInterval:Integer;


    //根据是否给OnLongTapItem赋值来判断是否需要检查长按列表项事件
    Procedure CreateCheckLongTapItemTimer;
    Procedure StartCheckLongTapItemTimer;
    Procedure StopCheckLongTapItemTimer;
    procedure DoCheckLongTapItemTimer(Sender:TObject);

  protected
    //检测鼠标是否按住没有移动
    //判断是否需要绘制按下的效果
    //如果鼠标按住移动了8个像素
    //那么表示当前动作是滑动,而不是点击
    FIsStayPressedItem:Boolean;
    FCheckStayPressedItemTimer:TTimer;
    FStayPressedItemInterval:Integer;

    Procedure CreateCheckStayPressedItemTimer;
    Procedure StartCheckStayPressedItemTimer;
    Procedure StopCheckStayPressedItemTimer;
    procedure DoCheckStayPressedItemTimer(Sender:TObject);

  protected
    //延迟调用OnClickItem
    FCallOnClickItemTimer:TTimer;

    Procedure CreateCallOnClickItemTimer;
    Procedure StartCallOnClickItemTimer;
    Procedure StopCallOnClickItemTimer;
    procedure DoCallOnClickItemTimer(Sender:TObject);
  public
    //列表项列表
    FItems:TBaseSkinItems;

    //是否正在停止列表项平拖
    FIsStopingItemPanDrag:Boolean;

    //用于判断当前列表项是否允许平拖,在PrepareItemPanDrag中确定
    FIsCurrentMouseDownItemCanPanDrag:Boolean;

    //平拖列表项的速度
    FStartItemPanDragVelocity:Double;

    //开始平拖
    procedure StartItemPanDrag(AItem:TBaseSkinItem);
    //停止平拖
    procedure StopItemPanDrag;

    //准备平拖列表项,DoItemPanDragGestureManagerFirstMouseDown中调用
    procedure PrepareItemPanDrag(AMouseDownItem:TBaseSkinItem);

    //是否可以启用列表项平拖
    function CanEnableItemPanDrag:Boolean;virtual;
    //列表项已经平拖
    function IsStartedItemPanDrag:Boolean;virtual;


    //平拖项的绘制矩形
    function GetPanDragItemDrawRect:TRectF;
    //平拖项面板的绘制矩形
    function GetPanDragItemDesignerPanelDrawRect:TRectF;


    //平拖手势鼠标第一次按下,准备平拖列表项
    procedure DoItemPanDragGestureManagerFirstMouseDown(Sender:TObject;X,Y:Double);

    //平拖手势开始拖动
    procedure DoItemPanDragGestureManagerStartDrag(Sender:TObject);

    //平拖手势位置更改
    procedure DoItemPanDragGestureManagerPositionChange(Sender:TObject);


    //平拖手势管理者最小值越界
    procedure DoItemPanDragGestureManagerMinOverRangePosValueChange(
                                                  Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);
    //平拖手势管理者最大值越界
    procedure DoItemPanDragGestureManagerMaxOverRangePosValueChange(
                                                  Sender:TObject;
                                                  NextValue:Double;
                                                  LastValue:Double;
                                                  Step:Double;
                                                  var NewValue:Double;
                                                  var CanChange:Boolean);

    //计算需要惯性滚动的距离
    procedure DoItemPanDragGestureManagerCalcInertiaScrollDistance(
                                                  Sender:TObject;
                                                  var InertiaDistance:Double;
                                                  var CanInertiaScroll:Boolean
                                                  );

    //平拖列表项滚回到初始结束
    procedure DoItemPanDragGestureManagerScrollToInitialAnimateEnd(Sender:TObject);

  protected
    //设计面板更改事件(需要重绘列表)
    procedure DoItemDesignerPanelChange(Sender: TObject);

    procedure SetItemPanDragDesignerPanel(const Value: TSkinItemDesignerPanel);

    //移除列表项设计面板
    procedure RemoveOldDesignerPanel(const AOldItemDesignerPanel: TSkinItemDesignerPanel);
    //添加列表项设计面板,设计面板更改的时候,刷新整个ListBox
    procedure AddNewDesignerPanel(const ANewItemDesignerPanel: TSkinItemDesignerPanel);
    //列表项设计面板重绘链接
    property ItemDesignerPanelInvalidateLink:TSkinObjectChangeLink read FItemDesignerPanelInvalidateLink;
  protected
    //点击列表项,TreeView需要扩展它来实现自动展开
    procedure DoClickItem(AItem:TBaseSkinItem;X:Double;Y:Double);virtual;
    //设置选中的列表项
    procedure DoSetSelectedItem(Value: TBaseSkinItem);virtual;
    //设置居中的列表项
    procedure DoSetCenterItem(Value: TBaseSkinItem);
  protected
    //事件//

    //平拖列表项准备事件
    procedure CallOnPrepareItemPanDrag(Sender:TObject;AItem:TBaseSkinItem; var AItemIsCanPanDrag: Boolean);virtual;

    //居中的列表项更改事件
    procedure CallOnCenterItemChangeEvent(Sender:TObject;AItem:TBaseSkinItem);virtual;

    //点击列表项事件
    procedure CallOnClickItemEvent(AItem:TBaseSkinItem);virtual;
    //是否设置了长按列表项事件(因为每个控件类型的OnLongTapItem不一样,所以需要覆盖)
    function HasOnLongTapItemEvent:Boolean;virtual;
    //长按列表项事件
    procedure CallOnLongTapItemEvent(Sender:TObject;AItem:TBaseSkinItem);virtual;
    //点击列表项扩展事件
    procedure CallOnClickItemExEvent(AItem:TBaseSkinItem;X:Double;Y:Double);virtual;
    //列表项被选中的事件
    procedure CallOnSelectedItemEvent(Sender:TObject;AItem:TBaseSkinItem);virtual;

    //列表项开始编辑事件
    procedure CallOnStartEditingItemEvent(Sender:TObject;AItem:TBaseSkinItem;AEditControl:TChildControl);virtual;
    //列表项结束编辑事件
    procedure CallOnStopEditingItemEvent(Sender:TObject;AItem:TBaseSkinItem;AEditControl:TChildControl);virtual;
  public
    //每次绘制列表项之前准备
    procedure CallOnPrepareDrawItemEvent(
                Sender:TObject;
                ACanvas:TDrawCanvas;
                AItem:TBaseSkinItem;
                AItemDrawRect:TRectF;
                AIsDrawItemInteractiveState:Boolean);virtual;
    //增强绘制列表项事件
    procedure CallOnAdvancedDrawItemEvent(
                Sender:TObject;
                ACanvas:TDrawCanvas;
                AItem:TBaseSkinItem;
                AItemDrawRect:TRectF);virtual;

  protected
    //获取当前交互的列表项,用于显示设计面板上按钮的事件中
    function GetInteractiveItem:TBaseSkinItem;
  protected
    //居中选择的列表项
    function GetCenterItem:TBaseSkinItem;

    //居中选择模式的绘制偏移
    function GetCenterItemSelectModeTopDrawOffset:Double;
    function GetCenterItemSelectModeLeftDrawOffset:Double;

    //是否启用居中选择模式
    procedure SetIsEnabledCenterItemSelectMode(const Value: Boolean);


    //如果越界了,那么滚回边界,回弹
    procedure DoAdjustCenterItemPositionAnimate(Sender:TObject);
    //滚回边界结束事件
    procedure DoAdjustCenterItemPositionAnimateBegin(Sender:TObject);

    //居中选择时,滚回到初始结束
    procedure DoVert_InnerScrollToInitialAnimateEnd(Sender:TObject);override;
    procedure DoHorz_InnerScrollToInitialAnimateEnd(Sender:TObject);override;
  private
    FIsEmptyContent: Boolean;
    procedure SetIsEmptyContent(const Value: Boolean);
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
    //设置列表项的风格
    function SetListBoxItemStyle(AItemType:TSkinItemType;
                                  AListItemStyle:String):Boolean;virtual;
    //调整居中选择列表项的位置(需要在居中选择滑动时确定所选择的Item)
    procedure DoAdjustCenterItemPositionAnimateEnd(Sender:TObject);
  public
    /// <summary>
    ///   <para>
    ///     列表项布局管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ListLayoutsManager:TSkinCustomListLayoutsManager read FListLayoutsManager;

    /// <summary>
    ///   <para>
    ///     滚动到指定列表项
    ///   </para>
    ///   <para>
    ///     Scroll to assigned ListItem
    ///   </para>
    /// </summary>
    procedure ScrollToItem(Item: TBaseSkinItem);
    /// <summary>
    ///   <para>
    ///     获取列表项的宽度
    ///   </para>
    ///   <para>
    ///     Get ListItem's width
    ///   </para>
    /// </summary>
    function CalcItemWidth(AItem:TBaseSkinItem):Double;
    /// <summary>
    ///   <para>
    ///     获取列表项的高度
    ///   </para>
    ///   <para>
    ///     Get ListItem's height
    ///   </para>
    /// </summary>
    function CalcItemHeight(AItem:TBaseSkinItem):Double;

    /// <summary>
    ///   <para>
    ///     居中列表项的位置(固定)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetCenterItemRect:TRectF;

    /// <summary>
    ///   <para>
    ///     获取列表项所在的矩形(TreeView中要改,只在ItemDrawRect()中被调用)
    ///   </para>
    ///   <para>
    ///     Get ListItem's rectangle
    ///   </para>
    /// </summary>
    function VisibleItemRect(AVisibleItemIndex:Integer): TRectF;virtual;
    /// <summary>
    ///   <para>
    ///     列表项所在的绘制矩形(TreeView中要改)
    ///   </para>
    ///   <para>
    ///     ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemDrawRect(AVisibleItemIndex:Integer): TRectF;overload;
    /// <summary>
    ///   <para>
    ///     获取列表项所在的绘制矩形
    ///   </para>
    ///   <para>
    ///     Get ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemDrawRect(AVisibleItem:TBaseSkinItem): TRectF;overload;
    /// <summary>
    ///   <para>
    ///     获取坐标所在的列表项
    ///   </para>
    ///   <para>
    ///     Get ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemIndexAt(X, Y: Double):Integer;
    /// <summary>
    ///   <para>
    ///     获取坐标所在的列表项
    ///   </para>
    ///   <para>
    ///     Get ListItem's draw rectangle
    ///   </para>
    /// </summary>
    function VisibleItemAt(X, Y: Double):TBaseSkinItem;
  public

    /// <summary>
    ///   <para>
    ///     获取当前交互的项
    ///   </para>
    ///   <para>
    ///     Get interactive Item
    ///   </para>
    /// </summary>
    property InteractiveItem:TBaseSkinItem read GetInteractiveItem;

    /// <summary>
    ///   <para>
    ///     选中的列表项
    ///   </para>
    ///   <para>
    ///     Selected ListItem
    ///   </para>
    /// </summary>
    property SelectedItem:TBaseSkinItem read FSelectedItem write SetSelectedItem;

    /// <summary>
    ///   <para>
    ///     鼠标按下的列表项
    ///   </para>
    ///   <para>
    ///     Pressed ListItem
    ///   </para>
    /// </summary>
    property MouseDownItem:TBaseSkinItem read FMouseDownItem write SetMouseDownItem;
    property InnerMouseDownItem:TBaseSkinItem read FInnerMouseDownItem write FInnerMouseDownItem;

    /// <summary>
    ///   <para>
    ///     居中的列表项
    ///   </para>
    ///   <para>
    ///     Centered ListItem
    ///   </para>
    /// </summary>
    property CenterItem:TBaseSkinItem read GetCenterItem write SetCenterItem;

    /// <summary>
    ///   <para>
    ///     停靠的列表项
    ///   </para>
    ///   <para>
    ///     Hovered :ListItem
    ///   </para>
    /// </summary>
    property MouseOverItem:TBaseSkinItem read FMouseOverItem write SetMouseOverItem;
    /// <summary>
    ///   <para>
    ///     平拖的列表项
    ///   </para>
    ///   <para>
    ///     PanDragged ListItem
    ///   </para>
    /// </summary>
    property PanDragItem:TBaseSkinItem read FPanDragItem write SetPanDragItem;
    /// <summary>
    ///   <para>
    ///     平拖列表项的手势管理
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemPanDragGestureManager:TSkinControlGestureManager read FItemPanDragGestureManager;
    /// <summary>
    ///   <para>
    ///     启用列表项平拖
    ///   </para>
    ///   <para>
    ///     Enable Item PanDrag
    ///   </para>
    /// </summary>
    property EnableItemPanDrag:Boolean read FEnableItemPanDrag write FEnableItemPanDrag;//SetEnableItemPanDrag;
  public
    //基类不发布的属性

    /// <summary>
    ///   <para>
    ///     选中的列表项宽度
    ///   </para>
    ///   <para>
    ///     Selected ListItem's width
    ///   </para>
    /// </summary>
    property SelectedItemWidth:Double read GetSelectedItemWidth write SetSelectedItemWidth;
    /// <summary>
    ///   <para>
    ///     列表项宽度计算方式
    ///   </para>
    ///   <para>
    ///     Calculate type of LIstItem width
    ///   </para>
    /// </summary>
    property ItemWidthCalcType:TItemSizeCalcType read GetItemWidthCalcType write SetItemWidthCalcType;
    /// <summary>
    ///   <para>
    ///     列表项的排列类型
    ///   </para>
    ///   <para>
    ///     ListItem's layout type
    ///   </para>
    /// </summary>
    property ItemLayoutType:TItemLayoutType read GetItemLayoutType write SetItemLayoutType;
    /// <summary>
    ///   <para>
    ///     列表项列表
    ///   </para>
    ///   <para>
    ///     List of ListItem
    ///   </para>
    /// </summary>
    property Items:TBaseSkinItems read FItems write SetItems;

    /// <summary>
    ///   <para>
    ///     是否启用居中选择模式
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsEnabledCenterItemSelectMode:Boolean read FIsEnabledCenterItemSelectMode write SetIsEnabledCenterItemSelectMode;

    /// <summary>
    ///   <para>
    ///     列表项宽度
    ///   </para>
    ///   <para>
    ///     ListItem's width
    ///   </para>
    /// </summary>
    property ItemWidth:Double read GetItemWidth write SetItemWidth;
  published
    /// <summary>
    ///   <para>
    ///     垂直滚动条显示类型
    ///   </para>
    ///   <para>
    ///     ShowType of vertical scrollbar
    ///   </para>
    /// </summary>
    property VertScrollBarShowType;
    /// <summary>
    ///   <para>
    ///     水平滚动条显示类型
    ///   </para>
    ///   <para>
    ///     ShowType of horizontal scrollbar
    ///   </para>
    /// </summary>
    property HorzScrollBarShowType;
    /// <summary>
    ///   <para>
    ///     启用多选
    ///   </para>
    ///   <para>
    ///     Enable multiselect
    ///   </para>
    /// </summary>
    property MultiSelect:Boolean read FMultiSelect write FMultiSelect;
    /// <summary>
    ///   <para>
    ///     鼠标点击的时候是否自动选中列表项
    ///   </para>
    ///   <para>
    ///     Whether select ListItem automatically
    ///   </para>
    ///   <para>
    ///     when mouse clicking
    ///   </para>
    /// </summary>
    property IsAutoSelected:Boolean read FIsAutoSelected write FIsAutoSelected ;//default True;

    /// <summary>
    ///   <para>
    ///     列表项高度
    ///   </para>
    ///   <para>
    ///     ListItem's height
    ///   </para>
    /// </summary>
    property ItemHeight:Double read GetItemHeight write SetItemHeight;

    /// <summary>
    ///   <para>
    ///     列表项间隔
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSpace:Double read GetItemSpace write SetItemSpace;
    /// <summary>
    ///   <para>
    ///     列表项间隔类型
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemSpaceType:TSkinItemSpaceType read GetItemSpaceType write SetItemSpaceType;
    /// <summary>
    ///   <para>
    ///     选中的列表项高度
    ///   </para>
    ///   <para>
    ///     Selected ListItem's height
    ///   </para>
    /// </summary>
    property SelectedItemHeight:Double read GetSelectedItemHeight write SetSelectedItemHeight;
    /// <summary>
    ///   <para>
    ///     列表项高度计算方式
    ///   </para>
    ///   <para>
    ///     Calculate type of ListItem height
    ///   </para>
    /// </summary>
    property ItemHeightCalcType:TItemSizeCalcType read GetItemHeightCalcType write SetItemHeightCalcType;

    /// <summary>
    ///   <para>
    ///     平拖列表项的方向
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemPanDragGestureDirection:TPanDragGestureDirectionType read FItemPanDragGestureDirection write FItemPanDragGestureDirection;

    /// <summary>
    ///   <para>
    ///     平拖列表项的设计面板(用于放删除按钮等)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemPanDragDesignerPanel: TSkinItemDesignerPanel read FItemPanDragDesignerPanel write SetItemPanDragDesignerPanel;

    //空白内容时的
    property IsEmptyContent:Boolean read FIsEmptyContent write SetIsEmptyContent;
    property EmptyContentControl:TControl read FEmptyContentControl write SetEmptyContentControl;
    property EmptyContentPicture:TDrawPicture read FEmptyContentPicture write SetEmptyContentPicture;
    property EmptyContentCaption:String read FEmptyContentCaption write SetEmptyContentCaption;
    property EmptyContentDescription:String read FEmptyContentDescription write SetEmptyContentDescription;
  end;








  //列表项素材基类
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinListItemMaterial=class(TSkinMaterial)
  protected
    //背景颜色绘制参数
    FDrawItemBackColorParam:TDrawRectParam;
    //背景图片绘制参数
    FDrawItemBackGndPictureParam:TDrawPictureParam;


    //展开图片
    FItemAccessoryPicture:TDrawPicture;
    //展开图片绘制参数
    FDrawItemAccessoryPictureParam:TDrawPictureParam;



    //正常状态图片
    FItemBackNormalPicture: TDrawPicture;
    //鼠标停靠状态图片
    FItemBackHoverPicture: TDrawPicture;
    //鼠标按下状态图片
    FItemBackDownPicture: TDrawPicture;
    //按下状态图片
    FItemBackPushedPicture: TDrawPicture;

//    //禁用状态图片
//    FItemBackDisabledPicture: TDrawPicture;
//    //得到焦点状态图片
//    FItemBackFocusedPicture: TDrawPicture;


    procedure SetItemBackPushedPicture(const Value: TDrawPicture);
    procedure SetItemBackHoverPicture(const Value: TDrawPicture);
    procedure SetItemBackNormalPicture(const Value: TDrawPicture);
    procedure SetItemBackDownPicture(const Value: TDrawPicture);
//    procedure SetItemBackDisabledPicture(const Value: TDrawPicture);
//    procedure SetItemBackFocusedPicture(const Value: TDrawPicture);

    procedure SetItemAccessoryPicture(const Value:TDrawPicture);
    procedure SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);

    procedure SetDrawItemBackColorParam(const Value: TDrawRectParam);
    procedure SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published


    /// <summary>
    ///   <para>
    ///     列表项的展开图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemAccessoryPicture:TDrawPicture read FItemAccessoryPicture write SetItemAccessoryPicture;
    /// <summary>
    ///   <para>
    ///     列表项的展开图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemAccessoryPictureParam:TDrawPictureParam read FDrawItemAccessoryPictureParam write SetDrawItemAccessoryPictureParam;
    /// <summary>
    ///   <para>
    ///     列表项的正常状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackNormalPicture:TDrawPicture read FItemBackNormalPicture write SetItemBackNormalPicture;

    /// <summary>
    ///   <para>
    ///     列表项的鼠标停靠状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackHoverPicture:TDrawPicture read FItemBackHoverPicture write SetItemBackHoverPicture;

    /// <summary>
    ///   <para>
    ///     列表项的鼠标按下状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackDownPicture: TDrawPicture read FItemBackDownPicture write SetItemBackDownPicture;
//    //列表项的禁用状态图片
//    property ItemBackDisabledPicture: TDrawPicture read FItemBackDisabledPicture write SetItemBackDisabledPicture;
//    //列表项的得到焦点状态图片
//    property ItemBackFocusedPicture: TDrawPicture read FItemBackFocusedPicture write SetItemBackFocusedPicture;

    /// <summary>
    ///   <para>
    ///     列表项的按下状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackPushedPicture:TDrawPicture read FItemBackPushedPicture write SetItemBackPushedPicture;

    /// <summary>
    ///   <para>
    ///     列表项的背景颜色绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackColorParam:TDrawRectParam read FDrawItemBackColorParam write SetDrawItemBackColorParam;

    /// <summary>
    ///   <para>
    ///     列表项的背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackGndPictureParam:TDrawPictureParam read FDrawItemBackGndPictureParam write SetDrawItemBackGndPictureParam;
  end;






  //列表素材基类
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinCustomListDefaultMaterial=class(TSkinScrollControlDefaultMaterial)
  protected
    //分隔线
    FDrawItemDevideParam:TDrawRectParam;
    FDrawItemDevideLineParam:TDrawLineParam;


    //只是简单的画一条一个像素的直线
    FIsSimpleDrawItemDevide: Boolean;

    //是否绘制中心项矩形
    FIsDrawCenterItemRect: Boolean;
    //中心项矩形绘制参数
    FDrawCenterItemRectParam: TDrawRectParam;


    //默认类型列表项绘制素材
    FDefaultTypeItemMaterial:TBaseSkinListItemMaterial;
    FItem1TypeItemMaterial:TBaseSkinListItemMaterial;

    FDrawEmptyContentCaptionParam: TDrawTextParam;
    FDrawEmptyContentDescriptionParam: TDrawTextParam;
    FDrawEmptyContentPictureParam: TDrawPictureParam;

    //默认类型的列表项绘制风格，TBaseSkinListItemMaterial的StyleName
    FDefaultTypeItemStyle: String;


    procedure SetDrawEmptyContentCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawEmptyContentDescriptionParam(const Value: TDrawTextParam);
    procedure SetDrawEmptyContentPictureParam(const Value: TDrawPictureParam);

    function GetItemBackHoverPicture: TDrawPicture;
    function GetItemBackNormalPicture: TDrawPicture;
    function GetItemBackPushedPicture: TDrawPicture;
    function GetItemBackDownPicture: TDrawPicture;

    function GetDrawItemBackColorParam: TDrawRectParam;
    function GetDrawItemBackGndPictureParam: TDrawPictureParam;

    function GetItemAccessoryPicture: TDrawPicture;
    function GetDrawItemAccessoryPictureParam: TDrawPictureParam;

    procedure SetItemBackPushedPicture(const Value: TDrawPicture);
    procedure SetItemBackHoverPicture(const Value: TDrawPicture);
    procedure SetItemBackNormalPicture(const Value: TDrawPicture);
    procedure SetItemBackDownPicture(const Value: TDrawPicture);
//    procedure SetItemBackDisabledPicture(const Value: TDrawPicture);
//    procedure SetItemBackFocusedPicture(const Value: TDrawPicture);

    procedure SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
    procedure SetDrawItemBackColorParam(const Value: TDrawRectParam);

    procedure SetItemAccessoryPicture(const Value:TDrawPicture);
    procedure SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);

  protected
    procedure SetIsDrawCenterItemRect(const Value: Boolean);
    procedure SetDrawCenterItemRectParam(const Value: TDrawRectParam);

    procedure SetDrawItemDevideParam(const Value: TDrawRectParam);
    procedure SetIsSimpleDrawItemDevide(const Value: Boolean);

    procedure SetDefaultTypeItemMaterial(const Value: TBaseSkinListItemMaterial);
    procedure SetItem1TypeItemMaterial(const Value: TBaseSkinListItemMaterial);

    procedure SetDefaultTypeItemStyle(const Value: String);
  protected
    FItemMaterialChangeLink:TSkinObjectChangeLink;

    procedure AssignTo(Dest: TPersistent); override;

    //获取列表项素材基类
    function GetSkinCustomListItemMaterialClass:TBaseSkinItemMaterialClass;virtual;

  protected
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public

    /// <summary>
    ///   <para>
    ///     列表项的正常状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackNormalPicture:TDrawPicture read GetItemBackNormalPicture write SetItemBackNormalPicture;
    /// <summary>
    ///   <para>
    ///     列表项的鼠标停靠状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackHoverPicture:TDrawPicture read GetItemBackHoverPicture write SetItemBackHoverPicture;

    /// <summary>
    ///   <para>
    ///     列表项的鼠标按下状态图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemBackDownPicture: TDrawPicture read GetItemBackDownPicture write SetItemBackDownPicture;
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
    property ItemBackPushedPicture:TDrawPicture read GetItemBackPushedPicture write SetItemBackPushedPicture;
    /// <summary>
    ///   <para>
    ///     列表项的背景颜色绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackColorParam:TDrawRectParam read GetDrawItemBackColorParam write SetDrawItemBackColorParam;

    /// <summary>
    ///   <para>
    ///     列表项的背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemBackGndPictureParam:TDrawPictureParam read GetDrawItemBackGndPictureParam write SetDrawItemBackGndPictureParam;
    /// <summary>
    ///   <para>
    ///     列表项的展开图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ItemAccessoryPicture:TDrawPicture read GetItemAccessoryPicture write SetItemAccessoryPicture;

    /// <summary>
    ///   <para>
    ///     列表项的展开图片绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemAccessoryPictureParam:TDrawPictureParam read GetDrawItemAccessoryPictureParam write SetDrawItemAccessoryPictureParam;
  public


    //默认类型列表项的风格，TBaseSkinListItemMaterial的StyleName,可以被淘汰了
    property DefaultTypeItemStyle:String read FDefaultTypeItemStyle write SetDefaultTypeItemStyle;


    /// <summary>
    ///   <para>
    ///     默认类型列表项绘制素材
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DefaultTypeItemMaterial:TBaseSkinListItemMaterial read FDefaultTypeItemMaterial write SetDefaultTypeItemMaterial;
    property Item1TypeItemMaterial:TBaseSkinListItemMaterial read FItem1TypeItemMaterial write SetItem1TypeItemMaterial;

    /// <summary>
    ///   <para>
    ///     是否绘制中心矩形块
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsDrawCenterItemRect:Boolean read FIsDrawCenterItemRect write SetIsDrawCenterItemRect;

    /// <summary>
    ///   <para>
    ///     中心矩形块绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawCenterItemRectParam:TDrawRectParam read FDrawCenterItemRectParam write SetDrawCenterItemRectParam;

    /// <summary>
    ///   <para>
    ///     是否简单绘制分隔线
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property IsSimpleDrawItemDevide:Boolean read FIsSimpleDrawItemDevide write SetIsSimpleDrawItemDevide ;//default True;

    /// <summary>
    ///   <para>
    ///     分隔线绘制参数
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawItemDevideParam:TDrawRectParam read FDrawItemDevideParam write SetDrawItemDevideParam;
  published
    //内容为空时的标题
    property DrawEmptyContentCaptionParam: TDrawTextParam read FDrawEmptyContentCaptionParam write SetDrawEmptyContentCaptionParam;
    //内容为空时的描述
    property DrawEmptyContentDescriptionParam: TDrawTextParam read FDrawEmptyContentDescriptionParam write SetDrawEmptyContentDescriptionParam;
    //内容为空时的图片
    property DrawEmptyContentPictureParam: TDrawPictureParam read FDrawEmptyContentPictureParam write SetDrawEmptyContentPictureParam;
  end;






  //列表项控件类型基类
  TSkinCustomListDefaultType=class(TSkinScrollControlDefaultType)
  public

    //绘制开始和结束项
    FDrawStartIndex:Integer;
    FDrawEndIndex:Integer;

    //第一个绘制项
    FFirstDrawItem:TBaseSkinItem;
    FFirstDrawItemRect:TRectF;

    //最后一列的绘制项
    FLastColDrawItem:TBaseSkinItem;
    FLastColDrawItemRect:TRectF;

    //最后一个绘制项
    FLastRowDrawItem:TBaseSkinItem;
    FLastRowDrawItemRect:TRectF;


    FSkinCustomListIntf:ISkinCustomList;

  protected
    //用于处理ItemDsignerPanel的事件
    //处理列表项的鼠标点击事件
    //判断鼠标点击事件是否被列表项的ItemDesignerPanel处理了
    function DoProcessItemCustomMouseDown(AMouseOverItem:TBaseSkinItem;
                                          AItemDrawRect:TRectF;
                                          Button: TMouseButton; Shift: TShiftState;X, Y: Double):Boolean;virtual;
    //用于处理ItemDsignerPanel的事件
    //处理列表项的鼠标消息
    //判断鼠标消息是否被列表项的DrawItemDesignerPanel上面的子控件处理
    function DoProcessItemCustomMouseUp(AMouseDownItem:TBaseSkinItem;
                                        Button: TMouseButton; Shift: TShiftState;X, Y: Double):Boolean;virtual;
    //用于处理ItemDsignerPanel的事件
    function DoProcessItemCustomMouseMove(AMouseOverItem:TBaseSkinItem;
                                          Shift: TShiftState;X,Y:Double):Boolean;virtual;
    //用于处理ItemDsignerPanel的事件
    procedure DoProcessItemCustomMouseLeave(AMouseLeaveItem:TBaseSkinItem);virtual;

  protected
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState;X,Y:Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;

    procedure SizeChanged;override;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  protected
    function GetSkinMaterial:TSkinCustomListDefaultMaterial;
    //决定列表项所使用的素材
    function DecideItemMaterial(AItem:TBaseSkinItem;ASkinMaterial:TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;virtual;


    //自定义绘制方法
    function CustomPaintContent(ACanvas:TDrawCanvas;
                                ASkinMaterial:TSkinControlMaterial;
                                const ADrawRect:TRectF;
                                APaintData:TPaintData
                                ):Boolean;override;
    //自定义绘制方法-准备
    function CustomPaintContentBegin(ACanvas:TDrawCanvas;
                                    ASkinMaterial:TSkinControlMaterial;
                                    const ADrawRect:TRectF;
                                    APaintData:TPaintData
                                    ):Boolean;virtual;
    procedure MarkAllListItemTypeStyleSettingCacheUnUsed(
                        //起始下标
                        ADrawStartIndex:Integer;
                        ADrawEndIndex:Integer);virtual;
    //绘制指定起始下标的列表项
    function PaintItems(ACanvas:TDrawCanvas;
                        ASkinMaterial:TSkinControlMaterial;
                        const ADrawRect:TRectF;
                        AControlClientRect:TRectF;

                        //居中选择框的偏移
                        ADrawRectCenterItemSelectModeTopOffset,
                        ADrawRectCenterItemSelectModeLeftOffset,

                        //滚动内容的偏移
                        ADrawRectTopOffset,
                        ADrawRectLeftOffset,
                        ADrawRectRightOffset,
                        ADrawRectBottomOffset:Double;

                        //起始下标
                        ADrawStartIndex:Integer;
                        ADrawEndIndex:Integer;

                        APaintData:TPaintData
                        ):Boolean;
    //绘制Item
    function PaintItem(ACanvas: TDrawCanvas;
                        AItemIndex:Integer;
                        AItem:TBaseSkinItem;
                        AItemDrawRect:TRectF;
                        ASkinMaterial:TSkinCustomListDefaultMaterial;
                        const ADrawRect: TRectF;
                        ACustomListPaintData:TPaintData
                        ): Boolean;
    //处理Item的状态
    function ProcessItemDrawEffectStates(AItem:TBaseSkinItem):TDPEffectStates;virtual;
    //处理Item绘制参数
    procedure ProcessItemDrawParams(ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    AItemEffectStates:TDPEffectStates);virtual;
    //准备,调用OnPrepareDrawItem事件
    function CustomDrawItemBegin(ACanvas: TDrawCanvas;
                                  AItemIndex:Integer;
                                  AItem:TBaseSkinItem;
                                  AItemDrawRect:TRectF;
                                  ASkinMaterial:TSkinCustomListDefaultMaterial;
                                  const ADrawRect: TRectF;
                                  ACustomListPaintData:TPaintData;
                                  ASkinItemMaterial:TBaseSkinListItemMaterial;
                                  AItemEffectStates:TDPEffectStates;
                                  AIsDrawItemInteractiveState:Boolean
                                  ): Boolean;virtual;
    //绘制内容(绘制背景色)
    function CustomDrawItemContent(ACanvas: TDrawCanvas;
                                    AItemIndex:Integer;
                                    AItem:TBaseSkinItem;
                                    AItemDrawRect:TRectF;
                                    ASkinMaterial:TSkinCustomListDefaultMaterial;
                                    const ADrawRect: TRectF;
                                    ACustomListPaintData:TPaintData;
                                    ASkinItemMaterial:TBaseSkinListItemMaterial;
                                    AItemEffectStates:TDPEffectStates;
                                    AIsDrawItemInteractiveState:Boolean
                                    ): Boolean;virtual;
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
                                AIsDrawItemInteractiveState:Boolean
                                ): Boolean;virtual;

    //绘制ListView行列分隔线
    function AdvancedCustomPaintContent(ACanvas:TDrawCanvas;
                                        ASkinMaterial:TSkinControlMaterial;
                                        const ADrawRect:TRectF;
                                        APaintData:TPaintData
                                        ):Boolean;virtual;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinCustomList=class(TSkinScrollControl,
                        ISkinCustomList,
                        ISkinItems)
  private
    //准备平拖事件(可以根据Item设置ItemPanDragDesignerPanel)
    FOnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent;

    //点击列表项事件
    FOnClickItem:TCustomListClickItemEvent;
    //长按列表项事件
    FOnLongTapItem:TCustomListDoItemEvent;
    //点击列表项事件
    FOnClickItemEx:TCustomListClickItemExEvent;
    //列表项被选中的事件
    FOnSelectedItem:TCustomListDoItemEvent;
    //中间列表项更改事件
    FOnCenterItemChange:TCustomListDoItemEvent;

    //绘制列表项准备事件
    FOnPrepareDrawItem: TCustomListDrawItemEvent;
    FOnAdvancedDrawItem: TCustomListDrawItemEvent;

    //开始编辑列表项事件
    FOnStartEditingItem:TCustomListEditingItemEvent;
    //结束编辑列表项事件
    FOnStopEditingItem:TCustomListEditingItemEvent;

    FOnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent;
//    FOnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent;

    FOnMouseOverItemChange:TNotifyEvent;


    function GetOnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent;

    function GetOnSelectedItem: TCustomListDoItemEvent;
    function GetOnClickItem: TCustomListClickItemEvent;
    function GetOnLongTapItem: TCustomListDoItemEvent;
    function GetOnClickItemEx: TCustomListClickItemExEvent;
    function GetOnCenterItemChange:TCustomListDoItemEvent;

    function GetOnPrepareDrawItem: TCustomListDrawItemEvent;
    function GetOnAdvancedDrawItem: TCustomListDrawItemEvent;

    function GetOnStartEditingItem: TCustomListEditingItemEvent;
    function GetOnStopEditingItem: TCustomListEditingItemEvent;

    function GetOnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent;
//    function GetOnItemDesignerPanelChildCanStartEdit:TCustomListItemDesignerPanelChildCanStartEditEvent;
    function GetOnMouseOverItemChange:TNotifyEvent;

    function GetCustomListProperties:TCustomListProperties;
    procedure SetCustomListProperties(Value:TCustomListProperties);

  protected
    procedure ReadState(Reader: TReader); override;

    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;

  protected
    //ISkinItems接口的实现
    function GetItems:TBaseSkinItems;
    property Items:TBaseSkinItems read GetItems;
  public
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;override;
//    //获取合适的高度
//    function GetSuitDefaultItemHeight:Double;
//    //获取与设置自定义属性
//    function GetPropJsonStr:String;override;
//    procedure SetPropJsonStr(AJsonStr:String);override;

    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;override;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);override;
//    //设置属性
//    function GetProp(APropName:String):Variant;override;
//    procedure SetProp(APropName:String;APropValue:Variant);override;
  public
    function SelfOwnMaterialToDefault:TSkinCustomListDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinCustomListDefaultMaterial;
    function Material:TSkinCustomListDefaultMaterial;
  public
    property Prop:TCustomListProperties read GetCustomListProperties write SetCustomListProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TCustomListProperties read GetCustomListProperties write SetCustomListProperties;

    //垂直滚动条
    property VertScrollBar;

    //水平滚动条
    property HorzScrollBar;

    //点击列表项事件
    property OnClickItem:TCustomListClickItemEvent read GetOnClickItem write FOnClickItem;
    //长按列表项事件
    property OnLongTapItem:TCustomListDoItemEvent read GetOnLongTapItem write FOnLongTapItem;
    //点击列表项事件
    property OnClickItemEx:TCustomListClickItemExEvent read GetOnClickItemEx write FOnClickItemEx;
    //列表项被选中事件
    property OnSelectedItem:TCustomListDoItemEvent read GetOnSelectedItem write FOnSelectedItem;

    //中间项列表项事件
    property OnCenterItemChange:TCustomListDoItemEvent read GetOnCenterItemChange write FOnCenterItemChange;

    //每次绘制列表项之前准备
    property OnPrepareDrawItem:TCustomListDrawItemEvent read GetOnPrepareDrawItem write FOnPrepareDrawItem;
    //增强绘制列表项事件
    property OnAdvancedDrawItem:TCustomListDrawItemEvent read GetOnAdvancedDrawItem write FOnAdvancedDrawItem;

    //准备平拖事件(可以根据Item设置ItemPanDragDesignerPanel)
    property OnPrepareItemPanDrag:TCustomListPrepareItemPanDragEvent read GetOnPrepareItemPanDrag write FOnPrepareItemPanDrag;

    property OnMouseOverItemChange:TNotifyEvent read GetOnMouseOverItemChange write FOnMouseOverItemChange;

    property OnStartEditingItem:TCustomListEditingItemEvent read GetOnStartEditingItem write FOnStartEditingItem;
    property OnStopEditingItem:TCustomListEditingItemEvent read GetOnStopEditingItem write FOnStopEditingItem;

    property OnClickItemDesignerPanelChild:TCustomListClickItemDesignerPanelChildEvent
                read GetOnClickItemDesignerPanelChild write FOnClickItemDesignerPanelChild;

  end;










var
  //列表项风格列表
  GlobalListItemStyleRegList:TListItemStyleRegList;
  //获取在线列表项样式的事件
  GlobalOnGetUrlListItemStyleReg:TGetUrlListItemStyleRegEvent;


//将值赋给Edit控件
procedure SetValueToEditControl(AEditControl:TControl;AValue:String);
//从Edit控件获取值
function GetValueFromEditControl(AEditControl:TControl):String;
////设置ListBox列表项的风格
//function SetListBoxItemStyle(AListBox:TSkinCustomList;
//                            AItemType:TSkinItemType;
//                            AItemStyle:String):Boolean;

function GetGlobalListItemStyleRegList:TListItemStyleRegList;
//注册列表项的风格
function RegisterListItemStyle(//风格名称
                                AStyle:String;
                                //设计面板所在的Frame
                                AListItemStyleFrameClass:TFrameClass;
                                //-1表示根据ListBox的默认
                                ADefaultItemHeight:Double=-1;
                                //是否自动尺寸
                                AIsAutoSize:Boolean=False;
                                //同一个Frame有多个风格名称的时候,使用它来区别初始,如何传给Frame初始的时候？
                                //把TListItemStyleReg传给Frame
                                ADataObject:TObject=nil):TListItemStyleReg;
procedure UnRegisterListItemStyle(AStyle:String);overload;
procedure UnRegisterListItemStyle(AListItemStyleFrameClass:TFrameClass);overload;



function GetItemSizeCalcTypeStr(AItemSizeCalcType:TItemSizeCalcType):String;
function GetItemLayoutTypeStr(AItemLayoutType:TItemLayoutType):String;
function GetItemSpaceTypeStr(AItemSpaceType:TSkinItemSpaceType):String;
function GetScrollBarShowTypeStr(AScrollBarShowType:TScrollBarShowType):String;

function GetItemSizeCalcTypeByStr(AItemSizeCalcTypeStr:String):TItemSizeCalcType;
function GetItemLayoutTypeByStr(AItemLayoutTypeStr:String):TItemLayoutType;
function GetItemSpaceTypeByStr(AItemSpaceTypeStr:String):TSkinItemSpaceType;
function GetScrollBarShowTypeByStr(AScrollBarShowTypeStr:String):TScrollBarShowType;
function GetScrollBarOverRangeTypeByStr(AScrollBarOverRangeTypeStr:String):TCanOverRangeTypes;


//加载ListItemStyleFrame的自定义设置
procedure LoadListItemStyleFrameConfig(AFrame:TFrame;AConfig:TStringList);




implementation



uses
//  uDownloadListItemStyleManager,
  uSkinVirtualListType;



function GetStringValue(AValueStr:String):String;
begin
  Result:=ReplaceStr(AValueStr,'''','');
end;


procedure LoadListItemStyleFrameConfigCodeLine(AFrame:TFrame;AConfigCodeLine:String);
var
  APosIndex:Integer;
  AName:String;
  AValueStr:String;
  {$IFDEF FMX}
  AColorValue:TAlphaColor;
  {$ENDIF}
  {$IFDEF VCL}
  AColorValue:TColor;
  {$ENDIF}
  AComponent:TComponent;
  ASkinControlIntf:ISkinControl;
  ASkinMaterial:TSkinControlMaterial;
  ADrawParam:TDrawParam;
  ADrawTextParam:TDrawTextParam;
  ADrawRectParam:TDrawRectParam;

  AVariableName:String;
  ASkinItemBindingControlIntf:ISkinItemBindingControl;
begin
//{$IFDEF FMX}
  //lblItemCaption.SelfOwnMaterial.DrawCaptionParam.FontColor:=$FFFFFFFF
  //lblItemCaption.SelfOwnMaterial.DrawCaptionParam.FontSize:=16
  //ItemDesignerPanel.SelfOwnMaterial.DrawCaptionParam.FontSize:=16
  //ItemDesignerPanel.SelfOwnMaterial.DrawBackColorParam.IsFill:=True
  //lblItemCaption.BindItemFieldName:='username';


  {$IF CompilerVersion>31.0}
  //先找到控件lblItemCaption
  //先找到变量名


  //找到属性串FontColor:=$FFFFFFFF
  APosIndex:=AConfigCodeLine.IndexOf(':=');//不存在是返回-1
  if APosIndex=-1 then Exit;
  //取出变量名,比如lblItemCaption.SelfOwnMaterial.DrawCaptionParam.FontColor
  //比如lblItemCaption.BindItemFieldName
  //取出值
  AVariableName:=AConfigCodeLine.Substring(0,APosIndex);
  AValueStr:=AConfigCodeLine.Substring(APosIndex+2);
  if AValueStr.Substring(AValueStr.Length-1)=';' then
  begin
    AValueStr:=AValueStr.Substring(0,AValueStr.Length-1);
  end;



  //找到控件名
//  APosIndex:=AVariableName.IndexOf('.');
  APosIndex:=AVariableName.IndexOf('.');//不存在是返回-1
  if APosIndex=-1 then Exit;
  AName:=AVariableName.Substring(0,APosIndex);
  //剩下的
  AVariableName:=AVariableName.Substring(APosIndex+1);
  
  AComponent:=AFrame.FindComponent(AName);
  if AComponent=nil then Exit;

  if not AComponent.GetInterface(IID_ISkinControl,ASkinControlIntf) then Exit;
  



  //找到属性名,比如素材SelfOwnMaterail,比如BindItemFieldName,比如Properties
  APosIndex:=AVariableName.IndexOf('.');//不存在是返回-1
  if APosIndex=-1 then
  begin
    APosIndex:=AVariableName.Length;
  end;
  AName:=AVariableName.Substring(0,APosIndex);
  //剩下的
  AVariableName:=AVariableName.Substring(APosIndex+1);


  //设置控件的绑定字段
  if (AName='BindItemFieldName') then
  begin
    if AComponent.GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf) then
    begin
      ASkinItemBindingControlIntf.SetBindItemFieldName(GetStringValue(AValueStr));
    end;
    Exit;
  end;
  if (AName='Visible') then
  begin
    TControl(AComponent).Visible:=StrToBool(AValueStr);
    Exit;
  end;
  if (AName='Height') then
  begin
    TControl(AComponent).Height:=ControlSize(StrToFloat(AValueStr));
    Exit;
  end;
  if (AName='Align') then
  begin
    TControl(AComponent).Align:=GetAlign(AValueStr);
    Exit;
  end;
  if (AName='Width') then
  begin
    TControl(AComponent).Width:=ControlSize(StrToFloat(AValueStr));
    Exit;
  end;
  if (AName='Margins') then
  begin

    if AVariableName='Left' then
    begin
      TControl(AComponent).Margins.Left:=ControlSize(StrToFloat(AValueStr));
    end;
    if AVariableName='Top' then
    begin
      TControl(AComponent).Margins.Top:=ControlSize(StrToFloat(AValueStr));
    end;
    if AVariableName='Right' then
    begin
      TControl(AComponent).Margins.Right:=ControlSize(StrToFloat(AValueStr));
    end;
    if AVariableName='Bottom' then
    begin
      TControl(AComponent).Margins.Bottom:=ControlSize(StrToFloat(AValueStr));
    end;

    {$IFDEF VCL}
    TControl(AComponent).AlignWithMargins:=True;
    {$ENDIF}

    Exit;
  end;

  if (AName='Properties') then
  begin

    if AVariableName='Picture.SkinImageListName' then
    begin
      TSkinImage(AComponent).Prop.Picture.SkinImageListName:=GetStringValue(AValueStr);
    end;
    if AVariableName='Picture.DefaultImageIndex' then
    begin
      TSkinImage(AComponent).Prop.Picture.DefaultImageIndex:=StrToInt(AValueStr);
    end;
    if AVariableName='Picture.IsClipRound' then
    begin
      TSkinImage(AComponent).Prop.Picture.IsClipRound:=StrToBool(AValueStr);
    end;



    Exit;
  end;



  if (AName<>'SelfOwnMaterial') and (AName<>'Material') then Exit;


  ASkinMaterial:=ASkinControlIntf.GetCurrentUseMaterial;
  if ASkinMaterial=nil then Exit;


  if AVariableName='IsTransparent' then
  begin
    ASkinMaterial.IsTransparent:=StrToBool(AValueStr);
  end
  ;

  //找到绘制参数DrawTextParam
  APosIndex:=AVariableName.IndexOf('.');
  if APosIndex=-1 then Exit;
  AName:=AVariableName.Substring(0,APosIndex);
  AVariableName:=AVariableName.Substring(APosIndex+1);
  ADrawParam:=ASkinMaterial.FindParamByName(AName);
  if AName='BackColor' then
  begin
    ADrawParam:=ASkinMaterial.BackColor;
  end;





  if ADrawParam=nil then
  begin


    Exit;
  end;

  if AVariableName='Alpha' then
  begin
    ADrawParam.Alpha:=StrToInt(AValueStr);
  end;


  if ADrawParam is TDrawRectParam then
  begin
      ADrawRectParam:=TDrawRectParam(ADrawParam);
      if AVariableName='FillColor' then
      begin
        {$IFDEF FMX}
        AColorValue:=StrToInt(AValueStr);
        ADrawRectParam.FillColor.Color:=AColorValue;
        {$ENDIF FMX}
      end
      else if AVariableName='IsFill' then
      begin
        ADrawRectParam.IsFill:=StrToBool(AValueStr);
      end
      else if AVariableName='IsRound' then
      begin
        ADrawRectParam.IsRound:=StrToBool(AValueStr);
      end
      //
      //背景透明,并且不需要选中的白底效果
      //+'ItemDesignerPanel.SelfOwnMaterial.BackColor.DrawEffectSetting.PushedEffect.IsFill:=False;'
      else if AVariableName='DrawEffectSetting.PushedEffect.IsFill' then
      begin
        ADrawRectParam.DrawEffectSetting.PushedEffect.IsFill:=StrToBool(AValueStr);
      end
      ;
  end;


  if ADrawParam is TDrawTextParam then
  begin

      ADrawTextParam:=TDrawTextParam(ADrawParam);
      if AVariableName='FontColor' then
      begin

        {$IFDEF FMX}
        AColorValue:=StrToInt(AValueStr);
        ADrawTextParam.FontColor:=AColorValue;
        {$ENDIF FMX}
        {$IFDEF VCL}
        if Pos('$',AValueStr)>0 then
        begin
          //VCL中是BGR,转成RGB
          //$FF FF FF FF
          //012 34 56 78
          AValueStr:='$'+AValueStr.Substring(7,2)
                    +AValueStr.Substring(5,2)
                    +AValueStr.Substring(3,2);
          AColorValue:=StrToInt(AValueStr);
        end
        else
        begin
          AColorValue:=ColorNameToColor(AValueStr);
        end;
        ADrawTextParam.FontColor:=AColorValue;
        {$ENDIF VCL}

      end
      else if AVariableName='FontSize' then
      begin
        ADrawTextParam.FontSize:=Ceil(StrToFloat(AValueStr));
      end
      else if AVariableName='FontHorzAlign' then
      begin
        ADrawTextParam.FontHorzAlign:=GetFontHorzAlign(AValueStr);
      end
      else if AVariableName='FontVertAlign' then
      begin
        ADrawTextParam.FontVertAlign:=GetFontVertAlign(AValueStr);
      end
      ;


  end;
  {$IFEND}


//{$ENDIF FMX}

end;

procedure LoadListItemStyleFrameConfig(AFrame:TFrame;AConfig:TStringList);
var
  I:Integer;
begin
  for I := 0 to AConfig.Count-1 do
  begin
    LoadListItemStyleFrameConfigCodeLine(AFrame,AConfig[I]);
  end;
end;

function GetItemSizeCalcTypeStr(AItemSizeCalcType:TItemSizeCalcType):String;
begin
  Result:='';
  case AItemSizeCalcType of
    isctFixed: Result:='Fixed';
    isctSeparate: Result:='Separate';
  end;
end;

function GetItemLayoutTypeStr(AItemLayoutType:TItemLayoutType):String;
begin
  case AItemLayoutType of
    iltVertical: Result:='Vertical';
    iltHorizontal: Result:='Horizontal';
  end;
end;

function GetItemSpaceTypeStr(AItemSpaceType:TSkinItemSpaceType):String;
begin
  case AItemSpaceType of
    sistDefault: Result:='Default';
    sistMiddle: Result:='Middle';
  end;
end;

function GetScrollBarShowTypeStr(AScrollBarShowType:TScrollBarShowType):String;
begin
  case AScrollBarShowType of
    sbstNone: Result:='None';
    sbstAlwaysCoverShow: Result:='AlwaysCoverShow';
    sbstAlwaysClipShow: Result:='AlwaysClipShow';
    sbstAutoCoverShow: Result:='AutoCoverShow';
    sbstAutoClipShow: Result:='AutoClipShow';
    sbstHide: Result:='Hide';
  end;
end;


function GetItemSizeCalcTypeByStr(AItemSizeCalcTypeStr:String):TItemSizeCalcType;
begin
  if SameText(AItemSizeCalcTypeStr,'Fixed') then
  begin
    Result:=isctFixed;
  end
  else
  begin
    Result:=isctSeparate;
  end;

end;

function GetItemLayoutTypeByStr(AItemLayoutTypeStr:String):TItemLayoutType;
begin

  if SameText(AItemLayoutTypeStr,'Horizontal') then
  begin
    Result:=iltHorizontal;
  end
  else
  begin
    Result:=iltVertical;
  end;

end;

function GetItemSpaceTypeByStr(AItemSpaceTypeStr:String):TSkinItemSpaceType;
begin
  if SameText(AItemSpaceTypeStr,'Middle') then
  begin
    Result:=sistMiddle;
  end
  else
  begin
    Result:=sistDefault;
  end;

end;

function GetScrollBarOverRangeTypeByStr(AScrollBarOverRangeTypeStr:String):TCanOverRangeTypes;
begin
  Result:=[];
  if Pos('Min',AScrollBarOverRangeTypeStr)>0 then
  begin
    Result:=Result+[TCanOverRangeType.cortMin];
  end;
  if Pos('Max',AScrollBarOverRangeTypeStr)>0 then
  begin
    Result:=Result+[TCanOverRangeType.cortMax];
  end;

end;

function GetScrollBarShowTypeByStr(AScrollBarShowTypeStr:String):TScrollBarShowType;
begin
  if SameText(AScrollBarShowTypeStr,'AlwaysCoverShow') then
  begin
    Result:=sbstAlwaysCoverShow;
  end
  else if SameText(AScrollBarShowTypeStr,'AlwaysClipShow') then
  begin
    Result:=sbstAlwaysClipShow;
  end
  else if SameText(AScrollBarShowTypeStr,'None') then
  begin
    Result:=sbstNone;
  end
  else if SameText(AScrollBarShowTypeStr,'AutoCoverShow') then
  begin
    Result:=sbstAutoCoverShow;
  end
  else if SameText(AScrollBarShowTypeStr,'AutoClipShow') then
  begin
    Result:=sbstAutoClipShow;
  end
  else if SameText(AScrollBarShowTypeStr,'Hide') then
  begin
    Result:=sbstHide;
  end
  else
  begin
    Result:=sbstAutoCoverShow;
  end;

end;





function GetGlobalListItemStyleRegList:TListItemStyleRegList;
begin
  if GlobalListItemStyleRegList=nil then
  begin
    GlobalListItemStyleRegList:=TListItemStyleRegList.Create();
  end;
  Result:=GlobalListItemStyleRegList;
end;

function RegisterListItemStyle(
                              AStyle:String;
                              AListItemStyleFrameClass:TFrameClass;
                              ADefaultItemHeight:Double=-1;
                              AIsAutoSize:Boolean=False;
                              ADataObject:TObject=nil):TListItemStyleReg;
//var
//  AListItemStyleReg:TListItemStyleReg;
begin
  Result:=TListItemStyleReg.Create;
  Result.Name:=AStyle;
  Result.FrameClass:=AListItemStyleFrameClass;
  Result.DefaultItemHeight:=ADefaultItemHeight;
  Result.IsAutoSize:=AIsAutoSize;
  Result.DataObject:=ADataObject;
  GetGlobalListItemStyleRegList.Add(Result);
end;

procedure UnRegisterListItemStyle(AStyle:String);
var
  AListItemStyleReg:TListItemStyleReg;
begin
  if GlobalListItemStyleRegList<>nil then
  begin
    AListItemStyleReg:=GlobalListItemStyleRegList.FindItemByName(AStyle);
    GlobalListItemStyleRegList.Remove(AListItemStyleReg);
  end;
end;

procedure UnRegisterListItemStyle(AListItemStyleFrameClass:TFrameClass);
var
  AListItemStyleReg:TListItemStyleReg;
begin
  if GlobalListItemStyleRegList<>nil then
  begin
    AListItemStyleReg:=GlobalListItemStyleRegList.FindItemByClass(AListItemStyleFrameClass);
    GlobalListItemStyleRegList.Remove(AListItemStyleReg);
  end;
end;

//function SetListBoxItemStyle(AListBox:TSkinCustomList;
//                            AItemType:TSkinItemType;
//                            AItemStyle:String):Boolean;
//var
//  AListItemStyle:TListItemStyleReg;
//begin
//  Result:=False;
//  AListItemStyle:=GlobalListItemStyleRegList.FindItemByName(AItemStyle);
//  if AListItemStyle<>nil then
//  begin
//    Result:=AListBox.Prop.SetListBoxItemStyle(AListItemStyle);
//  end;
//end;

function GetValueFromEditControl(AEditControl:TControl):String;
begin
  Result:='';

  if AEditControl is TCustomEdit then
  begin
    Result:=TCustomEdit(AEditControl).Text;
  end;

  if AEditControl is TCustomMemo then
  begin
    Result:=TCustomMemo(AEditControl).Text;
  end;

  if AEditControl is TCustomComboBox then
  begin
    if TCustomComboBox(AEditControl).ItemIndex<>-1 then
    begin
      Result:=TCustomComboBox(AEditControl).Items[TCustomComboBox(AEditControl).ItemIndex];
    end;
  end;

  {$IFDEF FMX}
  if AEditControl is TCustomComboEdit then
  begin
    Result:=TCustomComboEdit(AEditControl).Text;
  end;
  {$ENDIF FMX}

end;

procedure SetValueToEditControl(AEditControl:TControl;AValue:String);
begin
  if AEditControl is TCustomEdit then
  begin
    TCustomEdit(AEditControl).Text:=AValue;
  end;

  if AEditControl is TCustomMemo then
  begin
    TCustomMemo(AEditControl).Text:=AValue;
  end;

  if AEditControl is TCustomComboBox then
  begin
    TCustomComboBox(AEditControl).ItemIndex:=
      TCustomComboBox(AEditControl).Items.IndexOf(AValue);
  end;

  {$IFDEF FMX}
  if AEditControl is TCustomComboEdit then
  begin
    TCustomComboEdit(AEditControl).Text:=AValue;
  end;
  {$ENDIF FMX}

end;



{ TCustomListProperties }


function TCustomListProperties.CalcContentHeight:Double;
begin
  Result:=Self.FListLayoutsManager.ContentHeight;

  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        //垂直居中选择模式
        Result:=Result
                +Self.GetClientRect.Height
                -Self.FListLayoutsManager.ItemHeight;
      end;
      iltHorizontal:
      begin
      end;
    end;
  end;
end;

function TCustomListProperties.CalcContentWidth:Double;
begin
  Result:=Self.FListLayoutsManager.ContentWidth;

  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
      end;
      iltHorizontal:
      begin
        //水平居中选择模式
        Result:=Result
                +Self.GetClientRect.Width
                -Self.FListLayoutsManager.ItemWidth;
      end;
    end;
  end;
end;

constructor TCustomListProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);

  if Not ASkinControl.GetInterface(IID_ISkinCustomList,Self.FSkinCustomListIntf) then
  begin
    ShowException('This Component Do not Support ISkinCustomList Interface');
  end
  else
  begin

      //内容宽度
      FContentWidth:=-1;
      //内容高度
      FContentHeight:=-1;

      //是否自动选择
      FIsAutoSelected:=True;


      //长按时间为1秒钟
      FHasCalledOnLongTapItem:=False;
      FLongTapItemInterval:=1000;


      //短按时间
      FStayPressedItemInterval:=300;

      FIsStayPressedItem:=False;


      FItemDesignerPanelInvalidateLink:=TSkinObjectChangeLink.Create;
      FItemDesignerPanelInvalidateLink.OnChange:=DoItemDesignerPanelChange;


      FSelectedItem:=nil;
      FMouseDownItem:=nil;
      FInteractiveMouseDownItem:=nil;
      FLastMouseDownItem:=nil;
      FInnerMouseDownItem:=nil;
      FCenterItem:=nil;
      FMouseOverItem:=nil;
      FPanDragItem:=nil;


      FEditingItem:=nil;
      FEditingItem_EditControl:=nil;
      FEditingItem_EditControlIntf:=nil;
      FEditingItem_EditControlOldParent:=nil;
      FEditingItem_EditControl_ItemEditorIntf:=nil;



      //默认没有水平滚动条
      Self.FHorzScrollBarShowType:=sbstNone;


      //创建列表
      FItems:=GetItemsClass.Create;
      FItems.OnChange:=DoItemsChange;
      FItems.OnItemDelete:=DoItemDelete;



      //创建布局管理者
      FListLayoutsManager:=GetCustomListLayoutsManagerClass.Create(FItems);
      FListLayoutsManager.StaticItemWidth:=-1;
      FListLayoutsManager.StaticItemHeight:=Const_DefaultItemHeight;
      //默认就设置成isctSeparate,避免用户使用上出现问题
      FListLayoutsManager.StaticItemSizeCalcType:=isctSeparate;

      FListLayoutsManager.OnItemPropChange:=DoItemPropChange;
      FListLayoutsManager.OnItemSizeChange:=DoItemSizeChange;
      FListLayoutsManager.OnItemVisibleChange:=DoItemVisibleChange;

      FListLayoutsManager.OnGetControlWidth:=Self.DoGetListLayoutsManagerControlWidth;
      FListLayoutsManager.OnGetControlHeight:=Self.DoGetListLayoutsManagerControlHeight;

      FListLayoutsManager.OnSetSelectedItem:=Self.DoSetListLayoutsManagerSelectedItem;





      //是否启用平拖
      FEnableItemPanDrag:=True;

      //启动平拖时的速度
      FStartItemPanDragVelocity:=1000;

      //列表项平拖的方向
      FItemPanDragGestureDirection:=ipdgdtLeft;




      //居中列表项滚动到初始位置的定时器
      FAdjustCenterItemPositionAnimator:=TSkinAnimator.Create(nil);
      FAdjustCenterItemPositionAnimator.TweenType:=TTweenType.Quadratic;//TTweenType.Linear;//Quartic;//Quadratic;
      FAdjustCenterItemPositionAnimator.EaseType:=TEaseType.easeOut;
      FAdjustCenterItemPositionAnimator.EndTimesCount:=6;//5;//
      FAdjustCenterItemPositionAnimator.OnAnimate:=Self.DoAdjustCenterItemPositionAnimate;
      FAdjustCenterItemPositionAnimator.OnAnimateBegin:=Self.DoAdjustCenterItemPositionAnimateBegin;
      FAdjustCenterItemPositionAnimator.OnAnimateEnd:=Self.DoAdjustCenterItemPositionAnimateEnd;
      FAdjustCenterItemPositionAnimator.Speed:=Const_Deafult_AnimatorSpeed;//6;//15帧




      //平拖控件手势管理
      FItemPanDragGestureManager:=TSkinControlGestureManager.Create(nil,Self.FSkinControl);
      //是否需要判断第一次手势的方向
      FItemPanDragGestureManager.IsNeedDecideFirstGestureKind:=True;


      FItemPanDragGestureManager.OnFirstMouseDown:=DoItemPanDragGestureManagerFirstMouseDown;
      //Position更改
      FItemPanDragGestureManager.OnPositionChange:=DoItemPanDragGestureManagerPositionChange;
      FItemPanDragGestureManager.OnStartDrag:=DoItemPanDragGestureManagerStartDrag;
      //最小值越界更改
      FItemPanDragGestureManager.OnMinOverRangePosValueChange:=DoItemPanDragGestureManagerMinOverRangePosValueChange;
      //最大值越界更改
      FItemPanDragGestureManager.OnMaxOverRangePosValueChange:=DoItemPanDragGestureManagerMaxOverRangePosValueChange;
      //滚回到初始
      FItemPanDragGestureManager.OnScrollToInitialAnimateEnd:=DoItemPanDragGestureManagerScrollToInitialAnimateEnd;
      //计算滚动速度和距离
      FItemPanDragGestureManager.OnCalcInertiaScrollDistance:=Self.DoItemPanDragGestureManagerCalcInertiaScrollDistance;


      FEmptyContentPicture:=CreateDrawPicture('EmptyContentPicture','内容为空的图片','');

  end;
end;

procedure TCustomListProperties.CreateCheckLongTapItemTimer;
begin
  //检测是否长按列表项
  if HasOnLongTapItemEvent then
  begin
    if FCheckLongTapItemTimer=nil then
    begin
      FCheckLongTapItemTimer:=TTimer.Create(nil);
      FCheckLongTapItemTimer.OnTimer:=Self.DoCheckLongTapItemTimer;
    end;
    FCheckLongTapItemTimer.Interval:=FLongTapItemInterval;
  end;
end;

procedure TCustomListProperties.CreateCheckStayPressedItemTimer;
begin
  //检测是否短按列表项
  if FCheckStayPressedItemTimer=nil then
  begin
    FCheckStayPressedItemTimer:=TTimer.Create(nil);
    FCheckStayPressedItemTimer.OnTimer:=Self.DoCheckStayPressedItemTimer;
  end;
  FCheckStayPressedItemTimer.Interval:=FStayPressedItemInterval;
end;

procedure TCustomListProperties.CreateCallOnClickItemTimer;
begin
  if FCallOnClickItemTimer=nil then
  begin
    FCallOnClickItemTimer:=TTimer.Create(nil);
    FCallOnClickItemTimer.OnTimer:=Self.DoCallOnClickItemTimer;
  end;
  FCallOnClickItemTimer.Interval:=100;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerPositionChange(Sender: TObject);
begin
  //平拖列表项移动的时候需要不断的重绘
  Invalidate;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerCalcInertiaScrollDistance(
          Sender: TObject;
          var InertiaDistance: Double;
          var CanInertiaScroll: Boolean);
begin


  Self.FItemPanDragGestureManager.InertiaScrollAnimator.TweenType:=TTweenType.Cubic;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.EaseType:=TEaseType.easeOut;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.d:=10;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.Speed:=Const_Deafult_AnimatorSpeed;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.InitialSpeed:=3;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.MaxSpeed:=3;
  Self.FItemPanDragGestureManager.InertiaScrollAnimator.minps:=6;


  case FItemPanDragGestureDirection of
    ipdgdtLeft:
    begin
      case Self.FItemPanDragGestureManager.MouseMoveDirection of
        isdScrollToMin:
        begin
          //返回
          //正在停止
//          OutputDebugString('平拖返回');
          Self.FIsStopingItemPanDrag:=True;
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
        isdScrollToMax:
        begin
          //往左拖
//          OutputDebugString('平拖前进');
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
      end;
    end;
    ipdgdtRight:
    begin
      case Self.FItemPanDragGestureManager.MouseMoveDirection of
        isdScrollToMin:
        begin
          //往右拖
//          OutputDebugString('平拖前进');
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
        isdScrollToMax:
        begin
          //返回
          //正在停止
//          OutputDebugString('平拖返回');
          Self.FIsStopingItemPanDrag:=True;
          InertiaDistance:=Self.FItemPanDragGestureManager.Max+20;
        end;
      end;
    end;
//    ipdgdtTop: ;
//    ipdgdtBottom: ;
  end;

end;

procedure TCustomListProperties.DoItemPanDragGestureManagerMaxOverRangePosValueChange(Sender: TObject;
      NextValue:Double;
      LastValue:Double;
      Step:Double;
      var NewValue: Double;
      var CanChange: Boolean);
begin
//  uBaseLog.OutputDebugString('Max '+FloatToStr(NewValue));
//  //刷新
//  Self.Invalidate;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerFirstMouseDown(Sender:TObject;X,Y:Double);
var
  AMouseDownItem:TBaseSkinItem;
begin
  AMouseDownItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);
  if AMouseDownItem<>nil then
  begin
    Self.PrepareItemPanDrag(AMouseDownItem);
  end;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerMinOverRangePosValueChange(Sender: TObject;
        NextValue:Double;
        LastValue:Double;
        Step:Double;
        var NewValue: Double;
        var CanChange: Boolean);
begin
//  uBaseLog.OutputDebugString('Min '+FloatToStr(NewValue));
//  //刷新
//  Self.Invalidate;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerScrollToInitialAnimateEnd(Sender: TObject);
begin
    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
            //如果滚动到了初始位置,那么平拖结束
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Min)) then
            begin
//              OutputDebugString('平拖结束');
              Self.FPanDragItem:=nil;
              FIsStopingItemPanDrag:=False;
              Self.Invalidate;
            end
            else
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Max)) then
            begin
              //判断是Max,不需要操作

            end
            else
            begin
                  //判断是不是Min还是Max,不能在中间
                  //判断方向
                  case Self.FItemPanDragGestureManager.MouseMoveDirection of
                    isdScrollToMin:
                    begin
                      //返回
//                      OutputDebugString('平拖返回');
                      Self.StopItemPanDrag;
                    end;
                    isdScrollToMax:
                    begin
                      //往左拖
//                      OutputDebugString('平拖前进');
                      Self.StartItemPanDrag(FPanDragItem);
                    end;
                  end;
            end;
      end;
      ipdgdtRight:
      begin
            //如果滚动到了初始位置,那么平拖结束
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Max)) then
            begin
//              OutputDebugString('平拖结束');
              Self.FPanDragItem:=nil;
              FIsStopingItemPanDrag:=False;
              Self.Invalidate;
            end
            else
            if (IsSameDouble(Self.FItemPanDragGestureManager.Position,Self.FItemPanDragGestureManager.Min)) then
            begin
              //判断是Max,不需要操作
              Self.Invalidate;

            end
            else
            begin
                  //判断是不是Min还是Max,不能在中间
                  //判断方向
                  case Self.FItemPanDragGestureManager.MouseMoveDirection of
                    isdScrollToMin:
                    begin
                      //往右拖
//                      OutputDebugString('平拖前进');
                      Self.StartItemPanDrag(FPanDragItem);
                    end;
                    isdScrollToMax:
                    begin
                      //返回
//                      OutputDebugString('平拖返回');
                      Self.StopItemPanDrag;
                    end;
                  end;
            end;

      end;
//      ipdgdtTop: ;
//      ipdgdtBottom: ;
    end;
end;

procedure TCustomListProperties.DoItemPanDragGestureManagerStartDrag(Sender: TObject);
begin

  if not FIsStopingItemPanDrag
      //可以启动列表项平拖
      and Self.CanEnableItemPanDrag then
  begin
      //尚未开始平拖
      if (FPanDragItem=nil) then
      begin

          if FIsCurrentMouseDownItemCanPanDrag then
          begin
    //        OutputDebugString('确定平拖的列表项');
            //平拖的列表项
            Self.FPanDragItem:=Self.FMouseDownItem;
          end;

      end;
  end;

end;

procedure TCustomListProperties.DoItemDesignerPanelChange(Sender: TObject);
begin
  //列表项设计面板更新事件
  Self.Invalidate;
end;

procedure TCustomListProperties.PrepareItemPanDrag(AMouseDownItem:TBaseSkinItem);
begin
    FIsCurrentMouseDownItemCanPanDrag:=True;
    CallOnPrepareItemPanDrag(Self,AMouseDownItem,FIsCurrentMouseDownItemCanPanDrag);

    //控件手势管理
    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
          FItemPanDragGestureManager.Kind:=TGestureKind.gmkHorizontal;
          if Self.FPanDragItem=nil then
          begin
            Self.FVertControlGestureManager.Enabled:=True;

            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=True;
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin];
          end
          else
          begin
            Self.FVertControlGestureManager.Enabled:=False;

            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=False;
            //返回的时候,左右都能拖动
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin,isdScrollToMax];
          end;
          //平拖到的最大值
          if FItemPanDragDesignerPanel<>nil then
          begin
            Self.FItemPanDragGestureManager.StaticMax:=Self.FItemPanDragDesignerPanel.Width;
          end
          else
          begin
            Self.FItemPanDragGestureManager.StaticMax:=0;
          end;
      end;
      ipdgdtRight:
      begin
          FItemPanDragGestureManager.Kind:=TGestureKind.gmkHorizontal;
          if Self.FPanDragItem=nil then
          begin
            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=True;
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMax];
          end
          else
          begin
            FItemPanDragGestureManager.FIsNeedDecideFirstGestureKind:=False;
            //返回的时候,左右都能拖动
            FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin,isdScrollToMax];
          end;
          //平拖到的最大值
          if FItemPanDragDesignerPanel<>nil then
          begin
            Self.FItemPanDragGestureManager.StaticMax:=Self.FItemPanDragDesignerPanel.Width;
          end
          else
          begin
            Self.FItemPanDragGestureManager.StaticMax:=0;
          end;
          if Self.FPanDragItem=nil then
          begin
            Self.FItemPanDragGestureManager.StaticPosition:=Self.FItemPanDragGestureManager.StaticMax;
          end;
        end;
  //      ipdgdtTop:
  //      begin
  //        FItemPanDragGestureManager.Kind:=TGestureKind.gmkVertical;
  //        FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMin];
  //      end;
  //      ipdgdtBottom:
  //      begin
  //        FItemPanDragGestureManager.Kind:=TGestureKind.gmkVertical;
  //        FItemPanDragGestureManager.DecideFirstGestureKindDirections:=[isdScrollToMax];
  //      end;
    end;


end;

procedure TCustomListProperties.RemoveOldDesignerPanel(const AOldItemDesignerPanel: TSkinItemDesignerPanel);
begin
  if AOldItemDesignerPanel<>nil then
  begin
    if AOldItemDesignerPanel.Properties<>nil then
    begin
      AOldItemDesignerPanel.Properties.BindControlInvalidateChange.UnRegisterChanges(Self.FItemDesignerPanelInvalidateLink);
    end;
    //去除释放通知
    RemoveFreeNotification(AOldItemDesignerPanel,Self.FSkinControl);
  end;
end;

destructor TCustomListProperties.Destroy;
begin
  try
      FreeAndNil(FAdjustCenterItemPositionAnimator);

      SetItemPanDragDesignerPanel(nil);

      FreeAndNil(FItemDesignerPanelInvalidateLink);


      //按下的列表项
      FMouseDownItem:=nil;
      FInteractiveMouseDownItem:=nil;
      FLastMouseDownItem:=nil;
      FInnerMouseDownItem:=nil;
      FCenterItem:=nil;
      //鼠标停靠的列表项
      FMouseOverItem:=nil;
      //选中的列表项
      FSelectedItem:=nil;

      FPanDragItem:=nil;



      FEditingItem:=nil;
      FEditingItem_EditControl:=nil;
      FEditingItem_EditControlIntf:=nil;
      FEditingItem_EditControlOldParent:=nil;
      FEditingItem_EditControl_ItemEditorIntf:=nil;



      FListLayoutsManager.OnItemPropChange:=nil;
      FListLayoutsManager.OnItemSizeChange:=nil;
      FListLayoutsManager.OnItemVisibleChange:=nil;
      FListLayoutsManager.OnGetItemIconSkinImageList:=nil;
      FListLayoutsManager.OnGetItemIconDownloadPictureManager:=nil;
      FListLayoutsManager.OnGetControlWidth:=nil;
      FListLayoutsManager.OnGetControlHeight:=nil;
      FListLayoutsManager.OnSetSelectedItem:=nil;
      FreeAndNil(FListLayoutsManager);

      if FItems<>nil then
      begin
        FItems.OnChange:=nil;
        FItems.OnItemDelete:=nil;
        FreeAndNil(FItems);
      end;


      FreeAndNil(FItemPanDragGestureManager);

      FreeAndNil(FCheckLongTapItemTimer);

      FreeAndNil(FCheckStayPressedItemTimer);

      FreeAndNil(FCallOnClickItemTimer);

      FreeAndNil(FEmptyContentPicture);

      inherited;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TCustomListProperties.Destroy');
    end;
  end;
end;

procedure TCustomListProperties.DoAdjustCenterItemPositionAnimate(Sender: TObject);
begin
  //居中列表项时设置滚动动画

  //设置位置
  if Self.FAdjustCenterItemPositionAnimator.Tag=1 then
  begin
    //垂直
    Self.FVertControlGestureManager.Position:=
        Self.FVertControlGestureManager.Position
        +(Self.FAdjustCenterItemPositionAnimator.Position-Self.FAdjustCenterItemPositionAnimator.LastPosition);
  end;
  //设置位置
  if Self.FAdjustCenterItemPositionAnimator.Tag=2 then
  begin
    //水平
    Self.FHorzControlGestureManager.Position:=
        Self.FHorzControlGestureManager.Position
        +(Self.FAdjustCenterItemPositionAnimator.Position-Self.FAdjustCenterItemPositionAnimator.LastPosition);
  end;
end;

procedure TCustomListProperties.DoAdjustCenterItemPositionAnimateBegin(Sender: TObject);
begin

end;

procedure TCustomListProperties.DoAdjustCenterItemPositionAnimateEnd(Sender: TObject);
var
  ACenterItem:TBaseSkinItem;
begin
  //判断居中的列表项
  ACenterItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
      Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
      Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
      );

  //让它居中
  DoSetCenterItem(ACenterItem);

  //调用选中事件
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    DoSetSelectedItem(ACenterItem);
  end;
end;

procedure TCustomListProperties.DoCheckLongTapItemTimer(Sender: TObject);
begin
  Self.FCheckLongTapItemTimer.Enabled:=False;
  Self.CallOnLongTapItemEvent(Sender,MouseDownItem);
end;

procedure TCustomListProperties.DoCallOnClickItemTimer(Sender: TObject);
begin
  Self.FCallOnClickItemTimer.Enabled:=False;

  if FLastMouseDownItem<>nil then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.DoCallOnClickItemTimer Item');

    //呼叫点击事件
    //选中列表项
    Self.DoClickItem(Self.FLastMouseDownItem,
                      FLastMouseDownX,
                      FLastMouseDownY);

    //取消按下效果,然后重绘
    Self.FLastMouseDownItem:=nil;
  end;
  Invalidate;
end;

procedure TCustomListProperties.DoCheckStayPressedItemTimer(Sender: TObject);
begin
  Self.FCheckStayPressedItemTimer.Enabled:=False;

  //过了一段时间,鼠标没有弹起,也没有移动过位置,那么表示手指按下了没动
  //重绘
  FIsStayPressedItem:=True;
  Self.Invalidate;

end;

procedure TCustomListProperties.DoClickItem(AItem: TBaseSkinItem;X:Double;Y:Double);
begin

  //如果设置自动选中,那么选中列表项
  if not Self.FIsEnabledCenterItemSelectMode and Self.FIsAutoSelected then
  begin
    if not Self.FMultiSelect then
    begin
      Self.SetSelectedItem(AItem);
    end
    else
    begin
      if not AItem.Selected then
      begin
        Self.SetSelectedItem(AItem);
      end
      else
      begin
//        Self.SetSelectedItem(nil);
        AItem.Selected:=False;
        CallOnSelectedItemEvent(Self,nil);
      end;
      
    end;

  end;

  //点击列表
  if (Self.FListLayoutsManager.GetVisibleItemObjectIndex(AItem)<>-1) then
  begin
    CallOnClickItemEvent(AItem);
    CallOnClickItemExEvent(AItem,X,Y);
  end;

end;

function TCustomListProperties.DoGetListLayoutsManagerControlHeight(Sender: TObject): Double;
begin
  Result:=Self.FSkinControlIntf.Height;
end;

function TCustomListProperties.DoGetListLayoutsManagerControlWidth(Sender: TObject): Double;
begin
  Result:=Self.FSkinControlIntf.Width;
end;

procedure TCustomListProperties.DoHorz_InnerPositionChange(Sender: TObject);
begin
  inherited;

  //更新当前编辑的编辑框
  SyncEditControlBounds;
end;

procedure TCustomListProperties.DoHorz_InnerScrollToInitialAnimateEnd(Sender: TObject);
var
  ALeftItem,ARightItem:TBaseSkinItem;
begin
  inherited;

  //居中选择模式
  if Self.FIsEnabledCenterItemSelectMode
    //有滚动方向
    and (Self.FHorzControlGestureManager.MouseMoveDirection<>isdNone)
    //个数大于1
    and (Self.FItems.Count>1) then
  begin
      //判断当前居中项以及方向
      FAdjustCenterItemPositionAnimator.Tag:=2;
      //计算出两个项
      ALeftItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
        );
      ARightItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right-1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
        );


      //比一下哪个距离大
      if (ALeftItem<>ARightItem)
        and (ALeftItem<>nil)
        and (ARightItem<>nil) then
      begin

        case Self.FHorzControlGestureManager.MouseMoveDirection of
          isdScrollToMin:
          begin
            //从下往上滚动
            if (ALeftItem.ItemDrawRect.Right
                -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left)
                //用所占比例来判断
              /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight>0.3
  //            >8
            then
            begin//下一个
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemWidth
                  -(ALeftItem.ItemDrawRect.Right
                -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left));
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
            end
            else
            begin//返回
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(ALeftItem.ItemDrawRect.Right
                -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left);
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
            end;

          end;
          isdScrollToMax:
          begin
            //从上往下滚动
            //过去一点点就移动
            //下一个,从上往下滚动
            if (Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right
                  -ARightItem.ItemDrawRect.Left)
                  //比例
              /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemWidth>0.3
              //像素
  //            >8
              then
            begin//下一个
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemWidth
                  -(Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right
                    -ARightItem.ItemDrawRect.Left));
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
            end
            else
            begin//返回
              FAdjustCenterItemPositionAnimator.Min:=0;
              FAdjustCenterItemPositionAnimator.Max:=(
                Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Right
                -ARightItem.ItemDrawRect.Left);
              FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
            end;

          end;
        end;

        FAdjustCenterItemPositionAnimator.Start;
      end
      else
      begin
        //位置刚好
        DoAdjustCenterItemPositionAnimateEnd(Self);
      end;
  end;
end;

procedure TCustomListProperties.DoItemDelete(Sender:TObject;AItem:TObject;AIndex:Integer);
begin
  //判断一下选中的,鼠标停靠的项目还存在不存在
  if (FMouseDownItem<>nil) and (FMouseDownItem=AItem) then
  begin
    FMouseDownItem:=nil;
  end;
  if (FInteractiveMouseDownItem<>nil) and (FInteractiveMouseDownItem=AItem) then
  begin
    FInteractiveMouseDownItem:=nil;
  end;

  if (FLastMouseDownItem<>nil) and (FLastMouseDownItem=AItem) then
  begin
    FLastMouseDownItem:=nil;
  end;
  if (FInnerMouseDownItem<>nil) and (FInnerMouseDownItem=AItem) then
  begin
    FInnerMouseDownItem:=nil;
  end;
  if (FCenterItem<>nil) and (FCenterItem=AItem) then
  begin
    FCenterItem:=nil;
  end;
  if (FMouseOverItem<>nil) and (FMouseOverItem=AItem) then
  begin
    FMouseOverItem:=nil;
  end;
  if (FEditingItem<>nil) and (FEditingItem=AItem) then
  begin
    CancelEditingItem;
  end;
  if (FSelectedItem<>nil) and (FSelectedItem=AItem) then
  begin
//    uBaseLog.OutputDebugString('FSelectedItem 为nil DoItemDelete');
    FSelectedItem:=nil;
  end;
  if (FPanDragItem<>nil) and (FPanDragItem=AItem) then
  begin
    SetPanDragItem(nil);
  end;
end;

procedure TCustomListProperties.DoItemsChange(Sender: TObject);
begin
  if Self.FItems.HasItemDeleted
    //FVisibleItems已经处理好了
    //不然，
    and Not Self.FListLayoutsManager.FIsNeedReCalcVisibleItems then
  begin
      //判断一下选中的,鼠标停靠的项目还存在不存在
      if (FMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FMouseDownItem)=-1) then
      begin
        FMouseDownItem:=nil;
      end;
      if (FInteractiveMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FInteractiveMouseDownItem)=-1) then
      begin
        FInteractiveMouseDownItem:=nil;
      end;

      if (FLastMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FLastMouseDownItem)=-1) then
      begin
        FLastMouseDownItem:=nil;
      end;
      if (FInnerMouseDownItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FInnerMouseDownItem)=-1) then
      begin
        FInnerMouseDownItem:=nil;
      end;
      if (FCenterItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FCenterItem)=-1) then
      begin
        FCenterItem:=nil;
      end;
      if (FMouseOverItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FMouseOverItem)=-1) then
      begin
        FMouseOverItem:=nil;
      end;
      if (FEditingItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FEditingItem)=-1) then
      begin
        CancelEditingItem;
      end;
      if (FSelectedItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FSelectedItem)=-1) then
      begin
//        uBaseLog.OutputDebugString('FSelectedItem 为nil DoItemsChange');
        FSelectedItem:=nil;
      end;
      if (FPanDragItem<>nil) and (Self.FListLayoutsManager.GetVisibleItemObjectIndex(Self.FPanDragItem)=-1) then
      begin
        SetPanDragItem(nil);
      end;
  end;
end;

procedure TCustomListProperties.DoItemSizeChange(Sender: TObject);
begin
//  uBaseLog.OutputDebugString('UpdateScrollBars In DoItemSizeChange');

  Self.UpdateScrollBars;
  Invalidate;
end;

procedure TCustomListProperties.DoItemVisibleChange(Sender: TObject);
begin
  //如果居中项隐藏了,那么需要设置居中项为空
  if (FCenterItem<>nil) and (not FCenterItem.Visible) then
  begin
    FCenterItem:=nil;
    //更新
    Self.DoAdjustCenterItemPositionAnimateEnd(Self);
  end;

//  uBaseLog.OutputDebugString('UpdateScrollBars In DoItemVisibleChange');
  Self.UpdateScrollBars;

  Invalidate;
end;

procedure TCustomListProperties.DoMouseOverItemChange(ANewItem,AOldItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnMouseOverItemChange) then
  begin
    Self.FSkinCustomListIntf.OnMouseOverItemChange(Self);
  end;

end;

procedure TCustomListProperties.DoSetListLayoutsManagerSelectedItem(Sender: TObject);
begin
  //设置选中的列表项
  SelectedItem:=TBaseSkinItem(Sender);
end;


procedure TCustomListProperties.DoVert_InnerPositionChange(Sender: TObject);
begin
  inherited;

  //更新当前编辑的编辑框
  SyncEditControlBounds;

end;

procedure TCustomListProperties.DoVert_InnerScrollToInitialAnimateEnd(Sender: TObject);
var
  ATopItem,ABottomItem:TBaseSkinItem;
begin
  inherited;

  //启用居中选择模式
  if Self.FIsEnabledCenterItemSelectMode
    //有滚动方向
    and (Self.FVertControlGestureManager.MouseMoveDirection<>isdNone)
    //个数大于1
    and (Self.FItems.Count>1) then
  begin
      //判断当前居中项以及方向
      FAdjustCenterItemPositionAnimator.Tag:=1;
      //计算出两个项
      ATopItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top+1
        );
      ABottomItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Left+1,
        Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom-1
        );


      //比一下哪个距离大
      if (ATopItem<>ABottomItem)
        and (ATopItem<>nil)
        and (ABottomItem<>nil) then
      begin

          case Self.FVertControlGestureManager.MouseMoveDirection of
            isdScrollToMin:
            begin
              //从下往上滚动
              if (ATopItem.ItemDrawRect.Bottom
                  -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top)
                  //比例
                /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight>0.3
              then
              begin//下一个
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight
                    -(ATopItem.ItemDrawRect.Bottom
                  -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top));
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
              end
              else
              begin//返回
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(ATopItem.ItemDrawRect.Bottom
                  -Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Top);
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
              end;

            end;
            isdScrollToMax:
            begin
              //从上往下滚动
              //过去一点点就移动
              //下一个,从上往下滚动
              if (Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom
                    -ABottomItem.ItemDrawRect.Top)
                    //比例
                /Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight>0.3
                then
              begin//下一个
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.ItemHeight
                    -(Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom
                      -ABottomItem.ItemDrawRect.Top));
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtForward;
              end
              else
              begin//返回
                FAdjustCenterItemPositionAnimator.Min:=0;
                FAdjustCenterItemPositionAnimator.Max:=(
                  Self.FSkinCustomListIntf.Prop.GetCenterItemRect.Bottom
                  -ABottomItem.ItemDrawRect.Top);
                FAdjustCenterItemPositionAnimator.DirectionType:=TAnimateDirectionType.adtBackward;
              end;

            end;
          end;

          FAdjustCenterItemPositionAnimator.Start;
      end
      else
      begin
          //位置刚好
          DoAdjustCenterItemPositionAnimateEnd(Self);
      end;
  end;
end;

procedure TCustomListProperties.DoItemPropChange(Sender: TObject);
begin
  //列表项属性更改,需要重绘
  Invalidate;
end;

function TCustomListProperties.GetComponentClassify: String;
begin
  Result:='SkinCustomList';
end;

procedure TCustomListProperties.CancelEditingItem;
begin
  try
    if FEditingItem<>nil then
    begin

        //赋回原Parent,设置原位置,原Align
        FEditingItem_EditControl.Parent:=TParentControl(FEditingItem_EditControlOldParent);
  //      FEditingItem_EditControlIntf.SetBounds(FEditingItem_EditControlOldRect);
        FEditingItem_EditControl.SetBounds(ControlSize(FEditingItem_EditControlOldRect.Left),
                                           ControlSize(FEditingItem_EditControlOldRect.Top),
                                           ControlSize(FEditingItem_EditControlOldRect.Width),
                                           ControlSize(FEditingItem_EditControlOldRect.Height)
                                           );
        FEditingItem_EditControl.Align:=FEditingItem_EditControlOldAlign;


        FEditingItem:=nil;
        DoStopEditingItemEnd;

        FEditingItem_EditControl:=nil;
        FEditingItem_EditControlIntf:=nil;
        FEditingItem_EditControlOldParent:=nil;
        FEditingItem_EditControl_ItemEditorIntf:=nil;

    end;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUIControl','uSkinCustomListType','TCustomListProperties.CancelEditingItem');
    end;
  end;
end;

function TCustomListProperties.CanEnableItemPanDrag: Boolean;
begin
  Result:=False;
  if
      Self.FEnableItemPanDrag                 //启用
    and (Self.FItemPanDragDesignerPanel<>nil) //存在平拖显示面板
    then
  begin
    Result:=True;
  end;
end;

function TCustomListProperties.GetCenterItem: TBaseSkinItem;
begin
  if FCenterItem=nil then
  begin
    DoAdjustCenterItemPositionAnimateEnd(Self);
  end;
  Result:=FCenterItem;
end;

function TCustomListProperties.GetCenterItemRect: TRectF;
begin
  Result:=Self.FListLayoutsManager.GetCenterItemRect;
end;

function TCustomListProperties.IsStartedItemPanDrag: Boolean;
begin
  Result:=False;
  if Self.CanEnableItemPanDrag
    and (Self.FPanDragItem<>nil) then
  begin
    Result:=True;
  end;
end;

function TCustomListProperties.GetInteractiveItem: TBaseSkinItem;
begin
  Result:=FInteractiveMouseDownItem;//FMouseOverItem;
end;

function TCustomListProperties.CalcItemHeight(AItem: TBaseSkinItem): Double;
begin
  Result:=FListLayoutsManager.CalcItemHeight(AItem);
end;

function TCustomListProperties.CalcItemWidth(AItem: TBaseSkinItem): Double;
begin
  Result:=FListLayoutsManager.CalcItemWidth(AItem);
end;

procedure TCustomListProperties.CallOnClickItemEvent(AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnClickItem) then
  begin
    Self.FSkinCustomListIntf.OnClickItem(AItem);
  end;
end;

procedure TCustomListProperties.CallOnAdvancedDrawItemEvent(Sender: TObject;
  ACanvas: TDrawCanvas; AItem: TBaseSkinItem; AItemDrawRect: TRectF);
begin
  if Assigned(Self.FSkinCustomListIntf.OnAdvancedDrawItem) then
  begin
    Self.FSkinCustomListIntf.OnAdvancedDrawItem(Self,ACanvas,AItem,RectF2Rect(AItemDrawRect));
  end;
end;

procedure TCustomListProperties.CallOnCenterItemChangeEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnCenterItemChange) then
  begin
    Self.FSkinCustomListIntf.OnCenterItemChange(Self,AItem);
  end;
end;

procedure TCustomListProperties.CallOnStartEditingItemEvent(Sender: TObject;
  AItem: TBaseSkinItem; AEditControl: TChildControl);
begin
  if Assigned(Self.FSkinCustomListIntf.OnStartEditingItem) then
  begin
    FSkinCustomListIntf.OnStartEditingItem(Sender,TBaseSkinItem(AItem),AEditControl);
  end;
end;

procedure TCustomListProperties.CallOnStopEditingItemEvent(Sender: TObject;
  AItem: TBaseSkinItem; AEditControl: TChildControl);
begin
  if Assigned(Self.FSkinCustomListIntf.OnStopEditingItem) then
  begin
    FSkinCustomListIntf.OnStopEditingItem(Sender,TBaseSkinItem(AItem),AEditControl);
  end;
end;

procedure TCustomListProperties.CallOnClickItemExEvent(AItem: TBaseSkinItem; X,Y: Double);
begin
  if Assigned(Self.FSkinCustomListIntf.OnClickItemEx) then
  begin
    Self.FSkinCustomListIntf.OnClickItemEx(Self.FSkinControl,
                                            AItem,
                                            X-AItem.ItemDrawRect.Left,
                                            Y-AItem.ItemDrawRect.Top);
  end;
end;

procedure TCustomListProperties.CallOnLongTapItemEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnLongTapItem) and (MouseDownItem<>nil) then
  begin
    FHasCalledOnLongTapItem:=True;
    //调用了LongTap之后,就不再调用ClickItem了
    Self.FSkinCustomListIntf.OnLongTapItem(Self,AItem);
  end;
end;

procedure TCustomListProperties.CallOnPrepareDrawItemEvent(
  Sender: TObject;
  ACanvas: TDrawCanvas;
  AItem: TBaseSkinItem;
  AItemDrawRect: TRectF;
  AIsDrawItemInteractiveState:Boolean);
begin
  if Assigned(Self.FSkinCustomListIntf.OnPrepareDrawItem) then
  begin
    //手动绑定值
    Self.FSkinCustomListIntf.OnPrepareDrawItem(Self,ACanvas,AItem,RectF2Rect(AItemDrawRect));
  end;
end;

procedure TCustomListProperties.CallOnPrepareItemPanDrag(Sender: TObject;AItem: TBaseSkinItem; var AItemIsCanPanDrag: Boolean);
begin
  if Assigned(Self.FSkinCustomListIntf.OnPrepareItemPanDrag) then
  begin
    Self.FSkinCustomListIntf.OnPrepareItemPanDrag(Self,AItem,AItemIsCanPanDrag);
  end;
end;

procedure TCustomListProperties.CallOnSelectedItemEvent(Sender: TObject;AItem: TBaseSkinItem);
begin
  if Assigned(Self.FSkinCustomListIntf.OnSelectedItem) then
  begin
    FSkinCustomListIntf.OnSelectedItem(Sender,AItem);
  end;
end;

function TCustomListProperties.HasOnLongTapItemEvent: Boolean;
begin
  Result:=Assigned(Self.FSkinCustomListIntf.OnLongTapItem);
end;

function TCustomListProperties.GetPanDragItemDesignerPanelDrawRect: TRectF;
begin
    //获取平拖设计面板的绘制矩形
    Result:=Self.VisibleItemDrawRect(FPanDragItem);

    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
        Result.Left:=Result.Right
                      -Self.FItemPanDragGestureManager.Position;
        Result.Right:=Result.Left+Self.FItemPanDragGestureManager.Max;
      end;
      ipdgdtRight:
      begin
        Result.Left:=Result.Left
                      -Self.FItemPanDragGestureManager.Position;
        Result.Right:=Result.Left+Self.FItemPanDragGestureManager.Max;
      end;
//      ipdgdtTop:
//      begin
//        Result.Top:=Result.Bottom-Self.FItemPanDragDesignerPanel.Height;
//      end;
//      ipdgdtBottom:
//      begin
//        Result.Bottom:=Result.Top+Self.FItemPanDragDesignerPanel.Height;
//      end;
    end;

end;

function TCustomListProperties.GetPanDragItemDrawRect: TRectF;
begin
    //获取平拖列表项的绘制面板
    Result:=Self.VisibleItemDrawRect(FPanDragItem);

    case Self.FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
        //获取平拖的位移,向左移
        OffsetRect(Result,-Self.FItemPanDragGestureManager.Position,0);
      end;
      ipdgdtRight:
      begin
        //获取平拖的位移,向右移
        OffsetRect(Result,
              Self.FItemPanDragGestureManager.Max-Self.FItemPanDragGestureManager.Position,0);
      end;
//      ipdgdtTop:
//      begin
//        //获取平拖的位移
//        OffsetRect(Result,
//              0,-Self.FItemPanDragGestureManager.Position
//              );
//      end;
//      ipdgdtBottom:
//      begin
//        //获取平拖的位移
//        OffsetRect(Result,
//              0,Self.FItemPanDragGestureManager.Position
//              );
//      end;
    end;
end;

procedure TCustomListProperties.GetPropJson(ASuperObject: ISuperObject);
begin
  inherited;

  if ItemWidthCalcType<>isctSeparate then ASuperObject.S['ItemSizeCalcType']:=GetItemSizeCalcTypeStr(ItemWidthCalcType);
  if ItemLayoutType<>iltVertical then ASuperObject.S['ItemLayoutType']:=GetItemLayoutTypeStr(ItemLayoutType);


  {$IFDEF FMX}
  ASuperObject.F['ItemWidth']:=ItemWidth;
  ASuperObject.F['ItemHeight']:=ItemHeight;
  if SelectedItemWidth<>-1 then ASuperObject.F['SelectedItemWidth']:=SelectedItemWidth;
  if SelectedItemHeight<>-1 then ASuperObject.F['SelectedItemHeight']:=SelectedItemHeight;
  if ItemSpace<>0 then ASuperObject.F['ItemSpace']:=ItemSpace;
  {$ENDIF FMX}


  if ItemSpaceType<>sistDefault then ASuperObject.S['ItemSpaceType']:=GetItemSpaceTypeStr(ItemSpaceType);

//      //自动隐藏显示滚动条
//      FHorzScrollBarShowType:=sbstNone;
//      FVertScrollBarShowType:=sbstAutoCoverShow;

  if VertScrollBarShowType<>sbstAutoCoverShow then ASuperObject.S['VertScrollBarShowType']:=GetScrollBarShowTypeStr(VertScrollBarShowType);
  if HorzScrollBarShowType<>sbstNone then ASuperObject.S['HorzScrollBarShowType']:=GetScrollBarShowTypeStr(HorzScrollBarShowType);



  if MultiSelect then ASuperObject.B['MultiSelect']:=MultiSelect;
  if not IsAutoSelected then ASuperObject.B['IsAutoSelected']:=IsAutoSelected;

end;

function TCustomListProperties.GetItemHeight: Double;
begin
  Result:=Self.FListLayoutsManager.ItemHeight;
end;

function TCustomListProperties.GetItemSpace: Double;
begin
  Result:=Self.FListLayoutsManager.ItemSpace;
end;

function TCustomListProperties.GetItemSpaceType: TSkinItemSpaceType;
begin
  Result:=Self.FListLayoutsManager.ItemSpaceType;
end;

function TCustomListProperties.GetItemTopDrawOffset: Double;
begin
  Result:=0;
end;

function TCustomListProperties.GetSelectedItemHeight: Double;
begin
  Result:=Self.FListLayoutsManager.SelectedItemHeight;
end;

function TCustomListProperties.GetSelectedItemWidth: Double;
begin
  Result:=Self.FListLayoutsManager.SelectedItemWidth;
end;

function TCustomListProperties.GetCenterItemSelectModeTopDrawOffset: Double;
begin
  Result:=0;
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        Result:=Result+(Self.GetClientRect.Height-FListLayoutsManager.ItemHeight)/2;
      end;
      iltHorizontal:
      begin
        Result:=0;
      end;
    end;
  end;
end;

function TCustomListProperties.GetItemHeightCalcType: TItemSizeCalcType;
begin
  Result:=Self.FListLayoutsManager.ItemSizeCalcType;
end;

function TCustomListProperties.GetItemLayoutType: TItemLayoutType;
begin
  Result:=Self.FListLayoutsManager.ItemLayoutType;
end;

function TCustomListProperties.GetItemWidthCalcType: TItemSizeCalcType;
begin
  Result:=Self.FListLayoutsManager.ItemSizeCalcType;
end;

function TCustomListProperties.GetCenterItemSelectModeLeftDrawOffset: Double;
begin
  Result:=0;
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        Result:=0;
      end;
      iltHorizontal:
      begin
        Result:=Result+(Self.GetClientRect.Width-FListLayoutsManager.ItemWidth)/2;
      end;
    end;
  end;
end;

function TCustomListProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TBaseSkinItems;
end;

function TCustomListProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinCustomListLayoutsManager;
end;

function TCustomListProperties.GetItemWidth: Double;
begin
  Result:=Self.FListLayoutsManager.ItemWidth;
end;

procedure TCustomListProperties.AddNewDesignerPanel(const ANewItemDesignerPanel: TSkinItemDesignerPanel);
begin
  if ANewItemDesignerPanel<>nil then
  begin
    ANewItemDesignerPanel.Properties.BindControlInvalidateChange.RegisterChanges(Self.FItemDesignerPanelInvalidateLink);
    //ANewItemDesignerPanel释放的时候通知FSkinControl
    AddFreeNotification(ANewItemDesignerPanel,Self.FSkinControl);
  end;
  Invalidate;
end;

procedure TCustomListProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
//  FIsAutoSelected:=TCustomListProperties(Src).FIsAutoSelected;
//
//
//  FItemDrawType:=TCustomListProperties(Src).FItemDrawType;
//
//  FItems.Assign(TCustomListProperties(Src).FItems);
//
//  FListLayoutsManager.StaticItemWidth:=TCustomListProperties(Src).FListLayoutsManager.StaticItemWidth;
//  FListLayoutsManager.StaticItemHeight:=TCustomListProperties(Src).FListLayoutsManager.StaticItemHeight;
//  FListLayoutsManager.StaticItemSizeCalcType:=TCustomListProperties(Src).FListLayoutsManager.StaticItemSizeCalcType;
//
//  FSkinImageList:=TCustomListProperties(Src).FSkinImageList;
//  SetSkinImageList(FSkinImageList);
//
//
//
//  FItemDesignerPanel:=TCustomListProperties(Src).FItemDesignerPanel;
//  FItem1DesignerPanel:=TCustomListProperties(Src).FItem1DesignerPanel;
//  FItem2DesignerPanel:=TCustomListProperties(Src).FItem2DesignerPanel;
//  FItem3DesignerPanel:=TCustomListProperties(Src).FItem3DesignerPanel;
//  FItem4DesignerPanel:=TCustomListProperties(Src).FItem4DesignerPanel;
//  FHeaderDesignerPanel:=TCustomListProperties(Src).FHeaderDesignerPanel;
//  FFooterDesignerPanel:=TCustomListProperties(Src).FFooterDesignerPanel;
//  FSearchBarDesignerPanel:=TCustomListProperties(Src).FSearchBarDesignerPanel;
//  FItemPanDragDesignerPanel:=TCustomListProperties(Src).FItemPanDragDesignerPanel;
//
//
//
//
//  //列表项平拖的方向
//  FItemPanDragGestureDirection:=TCustomListProperties(Src).FItemPanDragGestureDirection;
//
////  //最大的平拖位置
////  FMaxItemPanDragPosition:=TCustomListProperties(Src).FMaxItemPanDragPosition;
////  //最小的平拖位置
////  FMinItemPanDragPosition:=TCustomListProperties(Src).FMinItemPanDragPosition;
//
//
//  //是否启用平拖
//  FEnableItemPanDrag:=TCustomListProperties(Src).FEnableItemPanDrag;
//
//
////  //开始平拖的增量
////  FDecideStartItemPanDragPosition:=TCustomListProperties(Src).FDecideStartItemPanDragPosition;


end;

procedure TCustomListProperties.ScrollToItem(Item: TBaseSkinItem);
var
  AVisibleItemIndex:Integer;
  AItemRect:TRectF;
begin
//  uBaseLog.OutputDebugString('UpdateScrollBars In ScrollToItem');
  UpdateScrollBars;

  AVisibleItemIndex:=Self.FListLayoutsManager.GetVisibleItemObjectIndex(Item);
  if (AVisibleItemIndex <> -1) and (AVisibleItemIndex<Self.FListLayoutsManager.GetVisibleItemsCount) then
  begin
        //如果选中的列表项在可视区域外,那么移动的可视区域内
        AItemRect:=Self.FListLayoutsManager.VisibleItemRectByIndex(AVisibleItemIndex);


        if (AItemRect.Top - Self.FVertControlGestureManager.Position < Self.GetClientRect.Top) then
        begin
          Self.FVertControlGestureManager.Position:=AItemRect.Top;
        end;
        if (AItemRect.Bottom - Self.FVertControlGestureManager.Position > Self.GetClientRect.Bottom) then
        begin
          if Self.FVertControlGestureManager.Max<AItemRect.Bottom then
          begin
            Self.FVertControlGestureManager.Position:=AItemRect.Bottom;
          end
          else
          begin
            Self.FVertControlGestureManager.Position:=AItemRect.Top;
          end;
        end;

  end;
end;

procedure TCustomListProperties.SetIsEmptyContent(const Value: Boolean);
begin
  if FIsEmptyContent<>Value then
  begin
    FIsEmptyContent := Value;
    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetIsEnabledCenterItemSelectMode(const Value: Boolean);
begin
  if FIsEnabledCenterItemSelectMode<>Value then
  begin
    FIsEnabledCenterItemSelectMode := Value;
    DoAdjustCenterItemPositionAnimateEnd(Self);
  end;
end;

procedure TCustomListProperties.SetItemPanDragDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  if FItemPanDragDesignerPanel <> Value then
  begin
    RemoveOldDesignerPanel(FItemPanDragDesignerPanel);
    FItemPanDragDesignerPanel:=Value;
    AddNewDesignerPanel(FItemPanDragDesignerPanel);
  end;
end;

procedure TCustomListProperties.SetCenterItem(Value: TBaseSkinItem);
begin
  DoSetCenterItem(Value);
  if Self.FIsEnabledCenterItemSelectMode then
  begin
    DoSetSelectedItem(Value);
  end;
end;

procedure TCustomListProperties.SetEmptyContentCaption(
  const Value: String);
begin
  if FEmptyContentCaption<>Value then
  begin
    FEmptyContentCaption := Value;
    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetEmptyContentControl(const Value: TControl);
begin
  if FEmptyContentControl<>Value then
  begin


    if FEmptyContentControl<>nil then
    begin
      RemoveFreeNotification(FEmptyContentControl,Self.FSkinControl);
    end;


    FEmptyContentControl := Value;

    if FEmptyContentControl<>nil then
    begin
      AddFreeNotification(FEmptyContentControl,Self.FSkinControl);
    end;

    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetEmptyContentDescription(
  const Value: String);
begin
  if FEmptyContentDescription<>Value then
  begin
    FEmptyContentDescription := Value;
    Self.Invalidate;
  end;
end;

procedure TCustomListProperties.SetEmptyContentPicture(
  const Value: TDrawPicture);
begin
  FEmptyContentPicture.Assign(Value);
end;

procedure TCustomListProperties.StartCheckLongTapItemTimer;
begin
  if FCheckLongTapItemTimer<>nil then
  begin
    FCheckLongTapItemTimer.Enabled:=True;
  end;
end;

procedure TCustomListProperties.StartCheckStayPressedItemTimer;
begin
  if FCheckStayPressedItemTimer<>nil then
  begin
    FCheckStayPressedItemTimer.Enabled:=True;
  end;
end;

procedure TCustomListProperties.SyncEditControlBounds;
var
  AItemDrawRect:TRectF;
  AParent:TControl;
begin
  if Self.FEditingItem<>nil then
  begin
    AItemDrawRect:=Self.VisibleItemDrawRect(FEditingItem);

    Self.FEditingItem_EditControl.SetBounds(
                //得加上层级偏移
                ControlSize(AItemDrawRect.Left
                              +FEditingItem_EditControlPutRect.Left),
                ControlSize(AItemDrawRect.Top
                              +FEditingItem_EditControlPutRect.Top),
                ControlSize(Self.FEditingItem_EditControlPutRect.Width),
                ControlSize(Self.FEditingItem_EditControlPutRect.Height)
                );

  end;

end;

function TCustomListProperties.StartEditingItem(
                                                AItem: TBaseSkinItem;
                                                AEditControl: TControl;
                                                AEditControlPutRect: TRectF;
                                                AEditValue:String;
                                                X, Y: Double):Boolean;
begin

    Result:=False;

    if (FEditingItem=AItem)
      and (FEditingItem_EditControl=AEditControl) then
    begin
      //重复调用相同的编辑,那么直接退出
      Exit;
    end;


    //停止编辑上次的列表项
    if FEditingItem<>nil then
    begin
      FEditingItem.DoPropChange;
      StopEditingItem;
    end;


    if AItem=nil then
    begin
      Exit;
    end;


    //必须要有编辑控件
    if AEditControl=nil then
    begin
      Exit;
    end;


    FEditingItem_EditControl:=TControl(AEditControl);
    //不一定要支持ISkinControl,
    //如果支持最好ISkinControl,这样就能够设置ParentMouseEvent
    FEditingItem_EditControl.GetInterface(IID_ISkinControl,FEditingItem_EditControlIntf);



    //把EditControl从原来的地方去掉,
    //显示到ListBox中,
    //即设置Parent为ListBox
    FEditingItem:=AItem;
    FEditingItem.DoPropChange;
    Invalidate;


    //编辑框相对于ItemRect的位置
    FEditingItem_EditControlPutRect:=AEditControlPutRect;



    //保存原信息,以结束编辑时用于恢复//
    //原Parent
    FEditingItem_EditControlOldParent:=FEditingItem_EditControl.Parent;
    //原位置和尺寸
    FEditingItem_EditControlOldRect.Left:=GetControlLeft(FEditingItem_EditControl);
    FEditingItem_EditControlOldRect.Top:=GetControlTop(FEditingItem_EditControl);
    FEditingItem_EditControlOldRect.Width:=FEditingItem_EditControl.Width;
    FEditingItem_EditControlOldRect.Height:=FEditingItem_EditControl.Height;
    //原Align
    FEditingItem_EditControlOldAlign:=FEditingItem_EditControl.Align;



    //设置新位置
    FEditingItem_EditControl.Align:={$IFDEF FMX}TAlignLayout.None{$ENDIF}{$IFDEF VCL}TAlignLayout.alNone{$ENDIF};
    if FEditingItem_EditControlIntf<>nil then
    begin
      //滑动的时候传递消息给ListBox
//      FEditingItem_EditControlIntf.ParentMouseEvent:=True;
      FEditingItem_EditControlIntf.ParentMouseEvent:=False;
      FEditingItem_EditControlIntf.MouseEventTransToParentType:=mettptNotTrans;
      //  edtCount.ParentMouseEvent:=False;
      //  edtCount.MouseEventTransToParentType:=mettptNotTrans;
    end;
    //设置新的位置
    Self.SyncEditControlBounds;

    //设置编辑控件的Parent为ListBox
    FEditingItem_EditControl.Parent:=TParentControl(Self.FSkinControl);
    //显示
    FEditingItem_EditControl.Visible:=True;



    //把鼠标点击消息传递给Edit,以便可以定位到是编辑哪个字符
    if (FEditingItem_EditControl<>nil)
      and FEditingItem_EditControl.GetInterface(IID_ICustomListItemEditor,FEditingItem_EditControl_ItemEditorIntf) then
    begin

        //复制值
        FEditingItem_EditControl_ItemEditorIntf.EditSetValue(AEditValue);
        //定位输入光标
        FEditingItem_EditControl_ItemEditorIntf.EditMouseDown(TMouseButton.mbLeft,[ssLeft],X,Y);
        FEditingItem_EditControl_ItemEditorIntf.EditMouseMove([],X,Y);
        FEditingItem_EditControl_ItemEditorIntf.EditMouseUp(TMouseButton.mbLeft,[ssLeft],X,Y);

    end
    else
    begin

        //把列表项的值赋给编辑控件TEdit,TComboBox之类的
        //并获取焦点
        SetValueToEditControl(FEditingItem_EditControl,AEditValue);


        {$IFDEF FMX}
        if TControl(FEditingItem_EditControl).CanFocus then
        begin
          TControl(FEditingItem_EditControl).SetFocus;
        end;
        {$ELSE}
        if TParentControl(FEditingItem_EditControl).CanFocus then
        begin
          TParentControl(FEditingItem_EditControl).SetFocus;
        end;
        {$ENDIF}

    end;


    //启动编辑,此时,可以给FEditingItem_EditControl赋初值,
    //比如把AItem.Detail赋给TEdit
    CallOnStartEditingItemEvent(Self,
                                AItem,
                                FEditingItem_EditControl
                                );

    Result:=True;
end;

procedure TCustomListProperties.StartCallOnClickItemTimer;
begin
  if FCallOnClickItemTimer<>nil then
  begin
    FCallOnClickItemTimer.Enabled:=True;
  end;
end;

procedure TCustomListProperties.StartItemPanDrag(AItem: TBaseSkinItem);
begin
  if CanEnableItemPanDrag and (AItem<>nil) then
  begin

      FPanDragItem:=AItem;
      FIsStopingItemPanDrag:=False;
      Self.FItemPanDragGestureManager.ScrollingToInitialAnimator.Pause;

      PrepareItemPanDrag(AItem);

//      OutputDebugString('手动开始平拖');
      case FItemPanDragGestureDirection of
        ipdgdtLeft:
        begin
          Self.FItemPanDragGestureManager.DoInertiaScroll(
                                    FStartItemPanDragVelocity,
                                    Self.FItemPanDragGestureManager.Max+20);
        end;
        ipdgdtRight:
        begin
          Self.FItemPanDragGestureManager.DoInertiaScroll(
                                    -FStartItemPanDragVelocity,
                                    Self.FItemPanDragGestureManager.Max+20);
        end;
  //      ipdgdtTop: ;
  //      ipdgdtBottom: ;
      end;

  end;
end;

procedure TCustomListProperties.StopCheckLongTapItemTimer;
begin
  if FCheckLongTapItemTimer<>nil then
  begin
    FCheckLongTapItemTimer.Enabled:=False;
  end;
end;

procedure TCustomListProperties.StopCheckStayPressedItemTimer;
begin
  if FCheckStayPressedItemTimer<>nil then
  begin
    FCheckStayPressedItemTimer.Enabled:=False;
  end;
end;

procedure TCustomListProperties.StopEditingItem;
begin
  try
    if FEditingItem<>nil then
    begin


        //赋回值
        DoSetValueToEditingItem;


        //把EditControl修改好的值赋回给EditingItem
        CallOnStopEditingItemEvent(Self,FEditingItem,FEditingItem_EditControl);



        //赋回原Parent,设置原位置,原Align
        FEditingItem_EditControl.Parent:=TParentControl(FEditingItem_EditControlOldParent);
        FEditingItem_EditControl.SetBounds(
                                          ControlSize(FEditingItem_EditControlOldRect.Left),
                                          ControlSize(FEditingItem_EditControlOldRect.Top),
                                          ControlSize(FEditingItem_EditControlOldRect.Width),
                                          ControlSize(FEditingItem_EditControlOldRect.Height)
                                          );
        FEditingItem_EditControl.Align:=FEditingItem_EditControlOldAlign;



        FEditingItem:=nil;

        DoStopEditingItemEnd;

        FEditingItem_EditControl:=nil;
        FEditingItem_EditControlIntf:=nil;
        FEditingItem_EditControlOldParent:=nil;
        FEditingItem_EditControl_ItemEditorIntf:=nil;


    end;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUIControl','uSkinCustomListType','TCustomListProperties.StopEditingItem');
    end;
  end;

end;

procedure TCustomListProperties.StopCallOnClickItemTimer;
begin
  if FCallOnClickItemTimer<>nil then
  begin
    FCallOnClickItemTimer.Enabled:=False;
  end;
end;

procedure TCustomListProperties.StopItemPanDrag;
begin
  if (FPanDragItem<>nil) then
  begin
//    OutputDebugString('手动结束平拖');
    FIsStopingItemPanDrag:=True;
    Self.FItemPanDragGestureManager.InertiaScrollAnimator.Pause;
    case FItemPanDragGestureDirection of
      ipdgdtLeft:
      begin
        Self.FItemPanDragGestureManager.DoInertiaScroll(-FStartItemPanDragVelocity,
                                      FItemPanDragGestureManager.Max+20);
      end;
      ipdgdtRight:
      begin
        Self.FItemPanDragGestureManager.DoInertiaScroll(FStartItemPanDragVelocity,
                                      FItemPanDragGestureManager.Max+20);
      end;
//      ipdgdtTop: ;
//      ipdgdtBottom: ;
    end;
  end;
end;

procedure TCustomListProperties.SetItemHeight(const Value: Double);
begin
  FListLayoutsManager.ItemHeight:=Value;
end;

procedure TCustomListProperties.SetSelectedItem(Value: TBaseSkinItem);
begin
  if FSelectedItem<>Value then
  begin
    DoSetSelectedItem(Value);


    //居中选择
    if Self.FIsEnabledCenterItemSelectMode then
    begin
      DoSetCenterItem(Value);
    end;
  end;
end;

procedure TCustomListProperties.SetSelectedItemHeight(const Value: Double);
begin
  FListLayoutsManager.SelectedItemHeight:=Value;
end;

procedure TCustomListProperties.SetSelectedItemWidth(const Value: Double);
begin
  FListLayoutsManager.SelectedItemWidth:=Value;
end;

procedure TCustomListProperties.SetItemWidth(const Value: Double);
begin
  FListLayoutsManager.ItemWidth:=Value;
end;

procedure TCustomListProperties.SetItemSpace(const Value: Double);
begin
  FListLayoutsManager.ItemSpace:=Value;
end;

procedure TCustomListProperties.SetItemSpaceType(const Value: TSkinItemSpaceType);
begin
  FListLayoutsManager.ItemSpaceType:=Value;
end;

procedure TCustomListProperties.SetItemHeightCalcType(const Value: TItemSizeCalcType);
begin
  FListLayoutsManager.ItemSizeCalcType:=Value;
end;

procedure TCustomListProperties.SetItemLayoutType(const Value: TItemLayoutType);
begin
  FListLayoutsManager.ItemLayoutType:=Value;
end;

procedure TCustomListProperties.SetItemWidthCalcType(const Value: TItemSizeCalcType);
begin
  //兼容老的
  FListLayoutsManager.ItemSizeCalcType:=Value;
end;

function TCustomListProperties.SetListBoxItemStyle(AItemType: TSkinItemType;
  AListItemStyle: String): Boolean;
begin
  Result:=True;
end;

procedure TCustomListProperties.SetItems(const Value: TBaseSkinItems);
begin
  FItems.Assign(Value);
end;

procedure TCustomListProperties.SetMouseDownItem(Value: TBaseSkinItem);
begin
  if FMouseDownItem<>Value then
  begin
    FMouseDownItem := Value;
    Invalidate;
  end;
end;

procedure TCustomListProperties.DoSetCenterItem(Value: TBaseSkinItem);
begin

  //设置CenterItem
  if FCenterItem<>nil then
  begin
    FCenterItem.DoPropChange;
  end;

  FCenterItem := Value;

  Self.CallOnCenterItemChangeEvent(Self,FCenterItem);

  if FCenterItem<>nil then
  begin
    FCenterItem.DoPropChange;
  end;


  Invalidate;


  if (FCenterItem<>nil) then
  begin
    case Self.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
        //设置位置(让居中选择的列表项显示在界面上)
        Self.FVertControlGestureManager.Position:=
          //可视
          Self.VisibleItemRect(Self.FListLayoutsManager.GetVisibleItemObjectIndex(FCenterItem)).Top
          ;
      end;
      iltHorizontal: ;
    end;
  end;
end;

procedure TCustomListProperties.SetPanDragItem(Value: TBaseSkinItem);
begin
  if FPanDragItem<>Value then
  begin
    if FPanDragItem<>nil then
    begin
      FPanDragItem.DoPropChange;
    end;

    FPanDragItem:=Value;

    if FPanDragItem<>nil then
    begin
      FPanDragItem.DoPropChange;
    end;


    Invalidate;
  end;
end;

procedure TCustomListProperties.SetPropJson(ASuperObject: ISuperObject);
begin
  inherited;



//  {$IFDEF FMX}
  {$IF CompilerVersion >= 30.0}
  if ASuperObject.Contains('ItemSizeCalcType') then ItemWidthCalcType:=GetItemSizeCalcTypeByStr(ASuperObject.S['ItemSizeCalcType']);
  if ASuperObject.Contains('ItemLayoutType') then ItemLayoutType:=GetItemLayoutTypeByStr(ASuperObject.S['ItemLayoutType']);

  if ASuperObject.Contains('ItemWidth') then ItemWidth:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['ItemWidth'];
  if ASuperObject.Contains('ItemHeight') then ItemHeight:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['ItemHeight'];
  if ASuperObject.Contains('SelectedItemWidth') then SelectedItemWidth:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['SelectedItemWidth'];
  if ASuperObject.Contains('SelectedItemHeight') then SelectedItemHeight:=ASuperObject.{$IFDEF FMX}F{$ELSE}F{$ENDIF}['SelectedItemHeight'];
  if ASuperObject.Contains('ItemSpace') then ItemSpace:=ASuperObject.{$IFDEF FMX}F{$ELSE}I{$ENDIF}['ItemSpace'];
  if ASuperObject.Contains('ItemSpaceType') then ItemSpaceType:=GetItemSpaceTypeByStr(ASuperObject.S['ItemSpaceType']);

  if ASuperObject.Contains('VertScrollBarShowType') then VertScrollBarShowType:=GetScrollBarShowTypeByStr(ASuperObject.S['VertScrollBarShowType']);
  if ASuperObject.Contains('HorzScrollBarShowType') then HorzScrollBarShowType:=GetScrollBarShowTypeByStr(ASuperObject.S['HorzScrollBarShowType']);

  if ASuperObject.Contains('VertCanOverRangeTypes') then Self.VertCanOverRangeTypes:=GetScrollBarOverRangeTypeByStr(ASuperObject.S['VertCanOverRangeTypes']);
  if ASuperObject.Contains('HorzCanOverRangeTypes') then HorzCanOverRangeTypes:=GetScrollBarOverRangeTypeByStr(ASuperObject.S['HorzCanOverRangeTypes']);

//  AFieldControlSetting.PropJson.B['EnableAutoPullDownRefreshPanel']:=False;
//  AFieldControlSetting.PropJson.B['EnableAutoPullUpLoadMorePanel']:=False;
  if ASuperObject.Contains('EnableAutoPullDownRefreshPanel') then EnableAutoPullDownRefreshPanel:=ASuperObject.B['EnableAutoPullDownRefreshPanel'];
  if ASuperObject.Contains('EnableAutoPullUpLoadMorePanel') then EnableAutoPullUpLoadMorePanel:=ASuperObject.B['EnableAutoPullUpLoadMorePanel'];

  if ASuperObject.Contains('MultiSelect') then MultiSelect:=ASuperObject.B['MultiSelect'];
  if ASuperObject.Contains('IsAutoSelected') then IsAutoSelected:=ASuperObject.B['IsAutoSelected'];
  {$IFEND}
//  {$ENDIF FMX}


end;

procedure TCustomListProperties.SetMouseOverItem(Value: TBaseSkinItem);
begin
  if FMouseOverItem<>Value then
  begin
    if FMouseOverItem<>nil then
    begin
      FMouseOverItem.IsBufferNeedChange:=True;
    end;

    DoMouseOverItemChange(Value,FMouseOverItem);

    FMouseOverItem := Value;

    //因为FMouseOverItem改过来之后,要再执行一下
    DoMouseOverItemChange(FMouseOverItem,nil);


    if FMouseOverItem<>nil then
    begin
      FMouseOverItem.IsBufferNeedChange:=True;
    end;

    Invalidate;
  end;
end;

procedure TCustomListProperties.DoSetSelectedItem(Value: TBaseSkinItem);
begin
  if FSelectedItem<>Value then
  begin

      //如果是单选的,那么之前选中的列表项取消选择
      if FSelectedItem<>nil then
      begin
  //        uBaseLog.OutputDebugString('--取消选中 ');
          if not Self.FMultiSelect then
          begin
            FSelectedItem.StaticSelected:=False;
          end;
          FSelectedItem.DoPropChange;

      end
      else
      begin
  //        uBaseLog.OutputDebugString('FSelectedItem 为nil');
      end;

      FSelectedItem := Value;

      if FSelectedItem<>nil then
      begin
  //        uBaseLog.OutputDebugString('--选中 ');
          FSelectedItem.StaticSelected:=True;
          FSelectedItem.DoPropChange;

          CallOnSelectedItemEvent(Self,FSelectedItem);
      end;


      //如果选中列表项的宽度和高度与正常的宽度和高度不一样,
      //那么需要重新计算每个列表项的绘制尺寸
      if IsNotSameDouble(Self.FListLayoutsManager.SelectedItemHeight,-1)
        or IsNotSameDouble(Self.FListLayoutsManager.SelectedItemWidth,-1) then
      begin
        //重新计算尺寸
        Self.FListLayoutsManager.DoItemSizeChange(Self);
      end;

      Invalidate;

  end
  else
  begin
//    uBaseLog.OutputDebugString('已经选中此Item');
  end;
end;

procedure TCustomListProperties.DoSetValueToEditingItem;
begin
  //赋回值
end;

procedure TCustomListProperties.DoStopEditingItemEnd;
begin

end;

function TCustomListProperties.VisibleItemDrawRect(AVisibleItem:TBaseSkinItem): TRectF;
//var
//  AVisibleItemIndex:Integer;
begin

  Result:=Self.FListLayoutsManager.VisibleItemRectByItem(AVisibleItem);

  Result.Top:=Result.Top
              -Self.GetTopDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Bottom:=Result.Bottom
              -Self.GetBottomDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Left:=Result.Left
                -Self.GetLeftDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;
  Result.Right:=Result.Right
                -Self.GetRightDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;

  AVisibleItem.ItemDrawRect:=Result;

//  Result:=RectF(0,0,0,0);
//  AVisibleItemIndex:=Self.FListLayoutsManager.GetVisibleItemObjectIndex(AVisibleItem);
//  if AVisibleItemIndex<>-1 then
//  begin
//    Result:=VisibleItemDrawRect(AVisibleItemIndex);
//  end;
end;

function TCustomListProperties.VisibleItemRect(AVisibleItemIndex:Integer): TRectF;
begin
  Result:=Self.FListLayoutsManager.VisibleItemRectByIndex(AVisibleItemIndex)
end;

function TCustomListProperties.VisibleItemAt(X, Y: Double):TBaseSkinItem;
var
  AVisibleItemIndex:Integer;
begin
  Result:=nil;
  AVisibleItemIndex:=Self.VisibleItemIndexAt(X,Y);
  if AVisibleItemIndex<>-1 then
  begin
    Result:=TBaseSkinItem(Self.FListLayoutsManager.GetVisibleItemObject(AVisibleItemIndex));
  end
  else
  begin
    Result:=nil;
  end;
end;

function TCustomListProperties.VisibleItemDrawRect(AVisibleItemIndex: Integer): TRectF;
begin
  Result:=VisibleItemRect(AVisibleItemIndex);

  Result.Top:=Result.Top
              -Self.GetTopDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Bottom:=Result.Bottom
              -Self.GetBottomDrawOffset
              +GetItemTopDrawOffset
              +GetCenterItemSelectModeTopDrawOffset;
  Result.Left:=Result.Left
                -Self.GetLeftDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;
  Result.Right:=Result.Right
                -Self.GetRightDrawOffset
                +GetCenterItemSelectModeLeftDrawOffset;

  Self.FListLayoutsManager.GetVisibleItem(AVisibleItemIndex).ItemDrawRect:=Result;
end;

function TCustomListProperties.VisibleItemIndexAt(X, Y: Double):Integer;
var
  I: Integer;
  ADrawStartIndex,ADrawEndIndex:Integer;
begin
  Result:=-1;
  if Self.FListLayoutsManager.GetVisibleItemsCount>0 then
  begin
    Self.FListLayoutsManager.CalcDrawStartAndEndIndex(

                                                      Self.GetLeftDrawOffset,
                                                      Self.GetTopDrawOffset,
                                          //            Self.GetRightDrawOffset,
                                          //            Self.GetBottomDrawOffset,
                                                      Self.FListLayoutsManager.GetControlWidth,
                                                      Self.FListLayoutsManager.GetControlHeight,
                                                      ADrawStartIndex,
                                                      ADrawEndIndex
                                                      );

    for I:=ADrawStartIndex to ADrawEndIndex do
    begin
      if PtInRect(VisibleItemDrawRect(TBaseSkinItem(Self.FListLayoutsManager.GetVisibleItemObject(I))),PointF(X,Y)) then
      begin
        Result:=I;
        Break;
      end;
    end;

  end;
end;



{ TSkinCustomListDefaultType }

function TSkinCustomListDefaultType.PaintItem(ACanvas: TDrawCanvas;
                                              AItemIndex:Integer;
                                              AItem:TBaseSkinItem;
                                              AItemDrawRect:TRectF;
                                              ASkinMaterial:TSkinCustomListDefaultMaterial;
                                              const ADrawRect: TRectF;
                                              ACustomListPaintData:TPaintData): Boolean;
var
  AItemEffectStates:TDPEffectStates;
  AIsDrawItemInteractiveState:Boolean;
  AItemPaintData:TPaintData;
  ASkinItemMaterial:TBaseSkinListItemMaterial;
  AItemDesignerPanel:TSkinItemDesignerPanel;
begin


    //计算列表项效果状态
    AIsDrawItemInteractiveState:=(AItem=Self.FSkinCustomListIntf.Prop.FMouseOverItem);


    AItemEffectStates:=ProcessItemDrawEffectStates(AItem);



    //绘制平拖的列表项设计面板
    if (Self.FSkinCustomListIntf.Prop.FPanDragItem=AItem)
      and (Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel<>nil)
      then
    begin
        AItemDesignerPanel:=Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel;


        AItemDrawRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDrawRect;
        //绘制ItemPanDragDesignerPanel
        //选择ItemPanDragDesignerPanel的绘制风格,一是跟随,二是一直显示在那里

        //剪裁显示
        AItemDesignerPanel.SkinControlType.IsUseCurrentEffectStates:=True;
        AItemDesignerPanel.SkinControlType.CurrentEffectStates:=AItemEffectStates;
        //绘制ItemDesignerPanel的背景
        AItemPaintData:=GlobalNullPaintData;
        AItemPaintData.IsDrawInteractiveState:=True;
        AItemPaintData.IsInDrawDirectUI:=True;
        AItemDesignerPanel.SkinControlType.Paint(ACanvas,
                              AItemDesignerPanel.SkinControlType.GetPaintCurrentUseMaterial,
                              Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect,
                              AItemPaintData);
        //绘制ItemDesignerPanel的子控件
        AItemPaintData:=GlobalNullPaintData;
        AItemPaintData.IsDrawInteractiveState:=True;
        AItemPaintData.IsInDrawDirectUI:=True;
        AItemDesignerPanel.SkinControlType.DrawChildControls(ACanvas,
                              Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect,
                              AItemPaintData,
                              ADrawRect);
    end;






    //决定AItem使用哪个TBaseSkinItemMaterial来绘制
    ASkinItemMaterial:=DecideItemMaterial(AItem,ASkinMaterial);
    ProcessItemDrawParams(ASkinMaterial,ASkinItemMaterial,AItemEffectStates);

    //绘制列表项开始
    CustomDrawItemBegin(ACanvas,
                        AItemIndex,
                        AItem,
                        AItemDrawRect,

                        ASkinMaterial,
                        ADrawRect,
                        ACustomListPaintData,
                        ASkinItemMaterial,
                        AItemEffectStates,
                        AIsDrawItemInteractiveState);
    //绘制列表项内容
    CustomDrawItemContent(ACanvas,
                          AItemIndex,
                          AItem,
                          AItemDrawRect,

                          ASkinMaterial,
                          ADrawRect,
                          ACustomListPaintData,
                          ASkinItemMaterial,
                          AItemEffectStates,
                          AIsDrawItemInteractiveState);

    //绘制列表项结束
    CustomDrawItemEnd(ACanvas,
                      AItemIndex,
                      AItem,
                      AItemDrawRect,

                      ASkinMaterial,
                      ADrawRect,
                      ACustomListPaintData,
                      ASkinItemMaterial,
                      AItemEffectStates,
                      AIsDrawItemInteractiveState);

    //增强绘制
    Self.FSkinCustomListIntf.Prop.CallOnAdvancedDrawItemEvent(Self,ACanvas,AItem,AItemDrawRect);


end;

function TSkinCustomListDefaultType.CustomPaintContent(
                                ACanvas:TDrawCanvas;
                                ASkinMaterial:TSkinControlMaterial;
                                const ADrawRect:TRectF;
                                APaintData:TPaintData
                                ):Boolean;
//var
//  BeginTickCount:Cardinal;
//  BeginTickCount2:Cardinal;
var
//  I:Integer;
//  AItem:TSkinItem;
  ABeginTime:TDateTime;
  AControlClientRect:TRectF;
begin
  ABeginTime:=Now;
//  BeginTickCount:=UIGetTickCount;
//  BeginTickCount2:=UIGetTickCount;

//  if Self.FSkinControl.ClassName='TSkinFMXItemGrid' then  Exit;



  FFirstDrawItem:=nil;

  FLastColDrawItem:=nil;
  FLastRowDrawItem:=nil;



  Inherited CustomPaintContent(ACanvas,ASkinMaterial,ADrawRect,APaintData);


  if (Self.FSkinCustomListIntf.Prop.FItems.SkinObjectChangeManager<>nil)
    and (Self.FSkinCustomListIntf.Prop.FItems.SkinObjectChangeManager.UpdateCount>0) then
  begin
    //在修改中不刷新
//    uBaseLog.OutputDebugString('CustomList.Items在修改中,不刷新');
    Exit;
  end;



  CustomPaintContentBegin(ACanvas,ASkinMaterial,ADrawRect,APaintData);






  //居中选择项的左右偏移
  FDrawRectCenterItemSelectModeTopOffset:=Self.FSkinCustomListIntf.Prop.GetCenterItemSelectModeTopDrawOffset;
  FDrawRectCenterItemSelectModeLeftOffset:=Self.FSkinCustomListIntf.Prop.GetCenterItemSelectModeLeftDrawOffset;


  //滚动框的上下左右偏移
  FDrawRectTopOffset:=Self.FSkinScrollControlIntf.Prop.GetTopDrawOffset;
  FDrawRectLeftOffset:=Self.FSkinScrollControlIntf.Prop.GetLeftDrawOffset;
  FDrawRectRightOffset:=Self.FSkinScrollControlIntf.Prop.GetRightDrawOffset;
  FDrawRectBottomOffset:=Self.FSkinScrollControlIntf.Prop.GetBottomDrawOffset;



  //获取需要绘制的开始下标和结束下标
  Self.FSkinCustomListIntf.Prop.FListLayoutsManager.CalcDrawStartAndEndIndex(

                                                    FDrawRectLeftOffset
                                                      -FDrawRectCenterItemSelectModeLeftOffset,
                                                    FDrawRectTopOffset
                                                      -Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset
                                                      -FDrawRectCenterItemSelectModeTopOffset,
//                                                    FDrawRectRightOffset,
//                                                    FDrawRectBottomOffset
//                                                      -Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset,

                                                    Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetControlWidth,
                                                    Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetControlHeight,
                                                    FDrawStartIndex,
                                                    FDrawEndIndex
                                                    );



//  uBaseLog.OutputDebugString(Self.FSkinControl.Name
//                            +'的列表项绘制起始下标 FDrawStartIndex:'+IntToStr(FDrawStartIndex)
//                            +' FDrawEndIndex:'+IntToStr(FDrawEndIndex)
//                            );



  //客户区矩形(用来判断哪些Item需要绘制)
  AControlClientRect:=Self.FSkinScrollControlIntf.Prop.GetClientRect;


//  if not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
    //在运行时,需要锁住ItemDesignerPanel上子控件的刷新,
    //实测,在VCL平台下，也会造成不断的刷新，造成设计时卡顿
    LockSkinControlInvalidate;
//  end;
  try



      //有需要绘制的列表项
      if Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetVisibleItemsCount>0 then
      begin

        if Self.FSkinCustomListIntf.Prop.FEmptyContentControl<>nil then
        begin
          if Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible then
          begin
            Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible:=False;
          end;
        end;



        //绘制列表
        PaintItems(ACanvas,
                    ASkinMaterial,
                    ADrawRect,
                    AControlClientRect,

                    FDrawRectCenterItemSelectModeTopOffset,
                    FDrawRectCenterItemSelectModeLeftOffset,

                    FDrawRectTopOffset,
                    FDrawRectLeftOffset,
                    FDrawRectRightOffset,
                    FDrawRectBottomOffset,

                    FDrawStartIndex,
                    FDrawEndIndex,

                    APaintData
                    );


      end
      else
      begin
          //没有需要绘制的列表项
          if Self.FSkinCustomListIntf.Prop.FIsEmptyContent then
          begin
            //绘制空白内容
            ACanvas.DrawPicture(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawEmptyContentPictureParam,
                    Self.FSkinCustomListIntf.Prop.FEmptyContentPicture,
                    ADrawRect);
            ACanvas.DrawText(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawEmptyContentCaptionParam,
                    Self.FSkinCustomListIntf.Prop.FEmptyContentCaption,
                    ADrawRect);
            ACanvas.DrawText(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawEmptyContentDescriptionParam,
                    Self.FSkinCustomListIntf.Prop.FEmptyContentDescription,
                    ADrawRect);
            if Self.FSkinCustomListIntf.Prop.FEmptyContentControl<>nil then
            begin
              if Not Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible then
              begin
                Self.FSkinCustomListIntf.Prop.FEmptyContentControl.Visible:=True;
              end;
            end;
          end;
      end;



      //绘制居中选择框
      if TSkinCustomListDefaultMaterial(ASkinMaterial).IsDrawCenterItemRect then
      begin
        ACanvas.DrawRect(TSkinCustomListDefaultMaterial(ASkinMaterial).FDrawCenterItemRectParam,
                        Self.FSkinCustomListIntf.Prop.GetCenterItemRect);
      end;









      //ListView用来绘制行列分隔线
      AdvancedCustomPaintContent(ACanvas,ASkinMaterial,ADrawRect,APaintData);


//      uBaseLog.OutputDebugString(Self.FSkinControl.Name+' Paint TickCount:'+IntToStr(UIGetTickCount-BeginTickCount));
//      uBaseLog.OutputDebugString(Self.FSkinControl.Name+' Paint Cost :'+IntToStr(DateUtils.MilliSecondsBetween(ABeginTime,Now)));




//      //绘制固定行
//      for I := 0 to Self.FSkinCustomListIntf.Prop.FListLayoutsManager.FFixedItems.Count-1 do
//      begin
//          AItem:=TSkinItem(Self.FSkinCustomListIntf.Prop.FListLayoutsManager.FFixedItems[I]);
//
//          //绘制列表项
//          PaintItem(ACanvas,
//                    I,
//                    AItem,
//                    AItem.ItemRect,
//                    TSkinCustomListDefaultMaterial(ASkinMaterial),
//                    ADrawRect,
//                    APaintData);
//      end;





  finally
//    if not (csDesigning in Self.FSkinControl.ComponentState) then
//    begin
      UnLockSkinControlInvalidate;
//    end;
  end;

end;

function TSkinCustomListDefaultType.CustomPaintContentBegin(
                                ACanvas:TDrawCanvas;
                                ASkinMaterial:TSkinControlMaterial;
                                const ADrawRect:TRectF;
                                APaintData:TPaintData
                                ):Boolean;
begin

end;

function TSkinCustomListDefaultType.PaintItems(ACanvas: TDrawCanvas;
                                                ASkinMaterial: TSkinControlMaterial;
                                                const ADrawRect:TRectF;
                                                AControlClientRect:TRectF;

                                                ADrawRectCenterItemSelectModeTopOffset,
                                                ADrawRectCenterItemSelectModeLeftOffset,

                                                ADrawRectTopOffset,
                                                ADrawRectLeftOffset,
                                                ADrawRectRightOffset,
                                                ADrawRectBottomOffset:Double;

                                                ADrawStartIndex, ADrawEndIndex: Integer;

                                                APaintData: TPaintData): Boolean;
var
  I: Integer;
  AItem:TBaseSkinItem;

  AItemDrawRect:TRectF;
  ALastItemDrawRect:TRectF;

  ASkinCustomListMaterial:TSkinCustomListDefaultMaterial;
//var
//  BeginTickCount:Cardinal;
begin
      ASkinCustomListMaterial:=TSkinCustomListDefaultMaterial(ASkinMaterial);



      //先将所有的缓存设置为不占用
      MarkAllListItemTypeStyleSettingCacheUnUsed(ADrawStartIndex,ADrawEndIndex);




      //开始绘制每个Item
      for I:=ADrawStartIndex to ADrawEndIndex do
      begin

//          uBaseLog.OutputDebugString(
//            Self.FSkinControl.Name+' '+'Item '+IntToStr(I)+'------------------ ');
//
//          BeginTickCount:=UIGetTickCount;


          AItem:=Self.FSkinCustomListIntf.Prop.FListLayoutsManager.GetVisibleItems(I);


          //不需要判断AItem.Visible
//          if not AItem.Visible then Continue;


          //ItemRect是已经计算好的
          AItemDrawRect:=AItem.ItemRect;



          //如果宽度和高度为0,那么不绘制
          //不判断,因为可以直接设置Visible来解决
//          if IsSameDouble(RectWidthF(AItemDrawRect),0)
//            or IsSameDouble(RectHeightF(AItemDrawRect),0) then
//          begin
//            Continue;
//          end;


          //算上居中偏移
          AItemDrawRect.Left:=AItemDrawRect.Left
                              -ADrawRectLeftOffset
                              +ADrawRectCenterItemSelectModeLeftOffset;
          AItemDrawRect.Top:=AItemDrawRect.Top
                              -ADrawRectTopOffset
                              //加上表格列头
                              +Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset
                              +ADrawRectCenterItemSelectModeTopOffset;
          AItemDrawRect.Right:=AItemDrawRect.Right
                              -ADrawRectRightOffset
                              +ADrawRectCenterItemSelectModeLeftOffset;
          AItemDrawRect.Bottom:=AItemDrawRect.Bottom
                                -ADrawRectBottomOffset
                                //加上表格列头
                                +Self.FSkinCustomListIntf.Prop.GetItemTopDrawOffset
                                +ADrawRectCenterItemSelectModeTopOffset;
          AItem.ItemDrawRect:=AItemDrawRect;


          //超出绘制范围不绘制
          //ADrawStartIndex和ADrawEndIndex难免会算错,
          //少绘制一点就优化一点,很重要,在手机上滑动起来效果很明显
          if Not ((AItemDrawRect.Bottom <= AControlClientRect.Top)
                  or (AItemDrawRect.Top >= AControlClientRect.Bottom)
                  or (AItemDrawRect.Right <= AControlClientRect.Left)
                  or (AItemDrawRect.Left >= AControlClientRect.Right)
                  ) then
          begin

              //算上绘制矩形偏移
              OffsetRect(AItemDrawRect,ADrawRect.Left,ADrawRect.Top);


              //用于绘制行列分隔线
              //第一个行列的Item
              if FFirstDrawItem=nil then
              begin
                  //第一个Item

                  //列头
                  FFirstDrawItem:=AItem;
                  FFirstDrawItemRect:=AItemDrawRect;
                  //行尾
                  FLastColDrawItem:=AItem;
                  FLastColDrawItemRect:=AItemDrawRect;
                  //行头
                  FLastRowDrawItem:=AItem;
                  FLastRowDrawItemRect:=AItemDrawRect;
              end
              else
              begin

                  //判断换行
                  //行尾,只要找出Right最大的Item就可以了
                  if BiggerDouble(AItemDrawRect.Right,FLastColDrawItemRect.Right) then
                  begin
                    FLastColDrawItem:=AItem;
                    FLastColDrawItemRect:=AItemDrawRect;
                  end;

                  if IsNotSameDouble(AItemDrawRect.Top,ALastItemDrawRect.Top) then
                  begin
                    //行头
                    //最后一行
                    FLastRowDrawItem:=AItem;
                    FLastRowDrawItemRect:=AItemDrawRect;
                  end;

              end;




              //绘制列表项
              PaintItem(ACanvas,
                        I,
                        AItem,
                        AItemDrawRect,
                        ASkinCustomListMaterial,
                        ADrawRect,
                        APaintData);



              ALastItemDrawRect:=AItemDrawRect;


              //如果是换行了
              //那么需要绘制行列分隔线
              //如果行列数不一样了

//              uBaseLog.OutputDebugString(
//                Self.FSkinControl.Name+' '+'Item '+IntToStr(I)+'------------------ Paint TickCount:'+IntToStr(UIGetTickCount-BeginTickCount)
//                );


          end;
      end;




end;

function TSkinCustomListDefaultType.AdvancedCustomPaintContent(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF; APaintData: TPaintData): Boolean;
begin
end;

function TSkinCustomListDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinCustomList,Self.FSkinCustomListIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinCustomList Interface');
    end;
  end;
end;

function TSkinCustomListDefaultType.CustomDrawItemContent(ACanvas: TDrawCanvas;
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
  AItemPaintData:TPaintData;
begin
  //默认绘制
  if (ASkinMaterial<>nil) then
  begin


      //绘制列表项背景色
      ACanvas.DrawRect(ASkinItemMaterial.FDrawItemBackColorParam,AItemDrawRect);



      //绘制列表项背景图片
      AItemBackPicture:=nil;
      if AItem.Selected then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackPushedPicture;
      end
      else
      if AItem=Self.FSkinCustomListIntf.Prop.MouseDownItem then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackDownPicture;
      end
      else
      if AItem=Self.FSkinCustomListIntf.Prop.MouseOverItem then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackHoverPicture;
      end
      else
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackNormalPicture;
      end;
      if AItemBackPicture.IsEmpty then
      begin
        AItemBackPicture:=ASkinItemMaterial.FItemBackNormalPicture;
      end;
      ACanvas.DrawPicture(ASkinItemMaterial.FDrawItemBackGndPictureParam,AItemBackPicture,AItemDrawRect);


      //绘制列表项展开图片
      ACanvas.DrawPicture(ASkinItemMaterial.FDrawItemAccessoryPictureParam,ASkinItemMaterial.FItemAccessoryPicture,AItemDrawRect);

  end;

end;

function TSkinCustomListDefaultType.CustomDrawItemBegin(ACanvas: TDrawCanvas;
                                                        AItemIndex:Integer;
                                                        AItem:TBaseSkinItem;
                                                        AItemDrawRect:TRectF;
                                                        ASkinMaterial:TSkinCustomListDefaultMaterial;
                                                        const ADrawRect: TRectF;
                                                        ACustomListPaintData:TPaintData;
                                                        ASkinItemMaterial:TBaseSkinListItemMaterial;
                                                        AItemEffectStates:TDPEffectStates;
                                                        AIsDrawItemInteractiveState:Boolean): Boolean;
begin

  //准备绘制列表项
  Self.FSkinCustomListIntf.Prop.CallOnPrepareDrawItemEvent(
          Self,
          ACanvas,
          AItem,
          AItemDrawRect,
          AIsDrawItemInteractiveState);

end;

function TSkinCustomListDefaultType.CustomDrawItemEnd(ACanvas: TDrawCanvas;
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
  ADrawItemDevideRect:TRectF;
begin

    if ASkinMaterial.FIsSimpleDrawItemDevide then
    begin

        case Self.FSkinCustomListIntf.Prop.ItemLayoutType of
          iltVertical:
          begin
            if Not AItem.IsNotNeedDrawDevide then
            begin
              //需要画分隔线
              ACanvas.DrawRect(ASkinMaterial.FDrawItemDevideParam,
                              RectF(AItemDrawRect.Left,
                                  AItemDrawRect.Bottom,
                                  AItemDrawRect.Right,
                                  AItemDrawRect.Bottom+1)
                                  );
            end;
          end;
          iltHorizontal:
          begin
            if Not AItem.IsNotNeedDrawDevide then
            begin
              //需要画分隔线
              ACanvas.DrawRect(ASkinMaterial.FDrawItemDevideParam,
                              RectF(AItemDrawRect.Right,
                                  AItemDrawRect.Top,
                                  AItemDrawRect.Right+1,
                                  AItemDrawRect.Bottom)
                                  );
            end;

          end;
        end;

    end
    else
    begin
      ACanvas.DrawRect(ASkinMaterial.FDrawItemDevideParam,AItemDrawRect);
    end;

end;

procedure TSkinCustomListDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinCustomListIntf:=nil;
end;

function TSkinCustomListDefaultType.DecideItemMaterial(AItem:TBaseSkinItem;ASkinMaterial:TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;
begin
  Result:=ASkinMaterial.FDefaultTypeItemMaterial;
end;

function TSkinCustomListDefaultType.DoProcessItemCustomMouseDown(AMouseOverItem:TBaseSkinItem;AItemDrawRect:TRectF;Button: TMouseButton; Shift: TShiftState; X, Y: Double): Boolean;
begin
  Result:=False;
end;

procedure TSkinCustomListDefaultType.DoProcessItemCustomMouseLeave(AMouseLeaveItem:TBaseSkinItem);
begin

end;

function TSkinCustomListDefaultType.DoProcessItemCustomMouseMove(
                                              AMouseOverItem: TBaseSkinItem;
                                              Shift: TShiftState;
                                              X, Y: Double): Boolean;
begin
  Result:=False;
end;

function TSkinCustomListDefaultType.DoProcessItemCustomMouseUp(
                                              AMouseDownItem: TBaseSkinItem;
                                              Button: TMouseButton;
                                              Shift: TShiftState;
                                              X, Y: Double):Boolean;
var
  AItemDrawRect:TRectF;
begin
  Result:=False;

  if FSkinCustomListIntf.Prop.FEditingItem<>nil then
  begin
        //如果正在编辑列表项属性,然后点击其他地方,就取消编辑
        if (Self.FMouseDownAbsolutePt.X<>0)
          and (Abs(Self.FMouseDownAbsolutePt.X-Self.FMouseMoveAbsolutePt.X)<Const_CanCallClickEventDistance)
          and (Abs(Self.FMouseDownAbsolutePt.Y-Self.FMouseMoveAbsolutePt.Y)<Const_CanCallClickEventDistance) then
        begin

            if Self.FSkinCustomListIntf.Prop.FMouseOverItem<>FSkinCustomListIntf.Prop.FEditingItem then
            begin
                //列表项切换过了
                Self.FSkinCustomListIntf.Prop.StopEditingItem;
            end
            else
            begin

                AItemDrawRect:=AMouseDownItem.ItemDrawRect;

                //是否点击了编辑控件的外面
                if Not PtInRect(
        //                      RectF(FSkinCustomListIntf.Prop.FEditingItem_EditControl.Left,
        //                             FSkinCustomListIntf.Prop.FEditingItem_EditControl.Top,
        //                             FSkinCustomListIntf.Prop.FEditingItem_EditControl.Left
        //                              +FSkinCustomListIntf.Prop.FEditingItem_EditControl.Width,
        //                              FSkinCustomListIntf.Prop.FEditingItem_EditControl.Top
        //                              +FSkinCustomListIntf.Prop.FEditingItem_EditControl.Height
        //                                )
                                FSkinCustomListIntf.Prop.FEditingItem_EditControlPutRect
                                ,PointF(X-AItemDrawRect.Left,Y-AItemDrawRect.Top)) then
                begin
                  Self.FSkinCustomListIntf.Prop.StopEditingItem;
                end;
            end;

        end;
  end;


end;

function TSkinCustomListDefaultType.GetSkinMaterial: TSkinCustomListDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinCustomListDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinCustomListDefaultType.MarkAllListItemTypeStyleSettingCacheUnUsed(
  ADrawStartIndex, ADrawEndIndex: Integer);
begin

end;

function TSkinCustomListDefaultType.ProcessItemDrawEffectStates(AItem: TBaseSkinItem): TDPEffectStates;
begin
  Result:=[];

  if Self.FSkinCustomListIntf.Prop.FMouseOverItem=AItem then
  begin
    Result:=Result+[dpstMouseOver];
  end;

  if (Self.FSkinCustomListIntf.Prop.FMouseDownItem=AItem) then
  begin
      //当前按下,且移动距离不超过5个像素，触发了OnClickItem事件,需要重绘
      if Self.FSkinCustomListIntf.Prop.FIsStayPressedItem then
      begin
        Result:=Result+[dpstMouseDown];

        Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;
      end;
  end;


  //上次按下的列表项,调用了OnClickItem之后会清空
  if (Self.FSkinCustomListIntf.Prop.FLastMouseDownItem=AItem) then
  begin
    Result:=Result+[dpstMouseDown];
  end;

  //选中的效果
  if AItem.Selected then
  begin
    Result:=Result+[dpstPushed];
  end;

end;

procedure TSkinCustomListDefaultType.ProcessItemDrawParams(
                                            ASkinMaterial:TSkinCustomListDefaultMaterial;
                                            ASkinItemMaterial: TBaseSkinListItemMaterial;
                                            AItemEffectStates: TDPEffectStates);
begin

    ASkinItemMaterial.FDrawItemBackColorParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinItemMaterial.FDrawItemBackColorParam);
    ASkinItemMaterial.FDrawItemBackGndPictureParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinItemMaterial.FDrawItemBackGndPictureParam);

    ASkinItemMaterial.FDrawItemAccessoryPictureParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinItemMaterial.FDrawItemAccessoryPictureParam);

    ASkinMaterial.FDrawItemDevideParam.StaticEffectStates:=AItemEffectStates;
    ProcessDrawParamDrawAlpha(ASkinMaterial.FDrawItemDevideParam);

end;

procedure TSkinCustomListDefaultType.CustomMouseDown(Button: TMouseButton;Shift: TShiftState;X, Y: Double);
var
  AItemDrawRect:TRectF;
  APanDragItemDrawRect:TRectF;
  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
  APanDragItemDesignerPanelClipRect:TRectF;
begin
//  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown');


  inherited;


  //去掉子控件传递过来的鼠标消息
  if Self.FCurrentMouseEventIsChildOwn then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown IsChildMouseEvent');
    Exit;
  end;


    //启动长按列表项事件的定时器
    Self.FSkinCustomListIntf.Prop.FHasCalledOnLongTapItem:=False;
    Self.FSkinCustomListIntf.Prop.CreateCheckLongTapItemTimer;
    Self.FSkinCustomListIntf.Prop.StartCheckLongTapItemTimer;


    Self.FSkinCustomListIntf.Prop.FIsStayPressedItem:=False;
    Self.FSkinCustomListIntf.Prop.FLastMouseDownItem:=nil;
    Self.FSkinCustomListIntf.Prop.CreateCheckStayPressedItemTimer;
    Self.FSkinCustomListIntf.Prop.StartCheckStayPressedItemTimer;



    //获取列表项绘制矩形
    AItemDrawRect:=RectF(0,0,0,0);
    if Self.FSkinCustomListIntf.Prop.FMouseOverItem<>nil then
    begin
        AItemDrawRect:=Self.FSkinCustomListIntf.Prop.VisibleItemDrawRect(Self.FSkinCustomListIntf.Prop.FMouseOverItem);
        //平拖过了,则获取平拖列表项的绘制矩形(加下平拖之后的偏移)
        if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag
          and (Self.FSkinCustomListIntf.Prop.FMouseOverItem=Self.FSkinCustomListIntf.Prop.FPanDragItem) then
        begin
          AItemDrawRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDrawRect;
        end;
    end;





    //设置鼠标点击的内部的列表项
    //用于鼠标弹起的时候,调用该Item.FDrawItemDesignerPanel的弹起事件
    //避免点击了ItemDesignerPanel中的子控件,而不知道点击的是哪个列表项
    if PtInRect(AItemDrawRect,PointF(X,Y)) then
    begin
        Self.FSkinCustomListIntf.Prop.InnerMouseDownItem:=
              Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);
        Self.FSkinCustomListIntf.Prop.FInteractiveMouseDownItem:=
              Self.FSkinCustomListIntf.Prop.InnerMouseDownItem;


        if Self.FSkinCustomListIntf.Prop.FInnerMouseDownItem<>
          Self.FSkinCustomListIntf.Prop.FEditingItem then
        begin
          //点击的列表项切换过了,结束编辑
          Self.FSkinCustomListIntf.Prop.StopEditingItem;
        end
    end;




    //处理列表项的鼠标点击事件
    //判断鼠标点击事件是否被列表项的ItemDesignerPanel处理了
    if DoProcessItemCustomMouseDown(Self.FSkinCustomListIntf.Prop.FMouseOverItem,
                                    AItemDrawRect,Button,Shift,X,Y) then
    begin
      //点击到HitTest为True的子控件
      Self.Invalidate;
      Exit;
    end
    else
    begin
      //如果事件没有被处理,那么传递给Item,也就是点击列表项
    end;
    





    //如果鼠标没有点击到ItemDesignerPanel上面的子控件
    //那么设置鼠标点击的列表项
    Self.FSkinCustomListIntf.Prop.MouseDownItem:=
        Self.FSkinCustomListIntf.Prop.InnerMouseDownItem;



    //平拖列表项的事件
    //如果开始了列表项平拖,获取平拖列表项的鼠标按下事件,并且鼠标在平拖列表设计面板上
    if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
    begin
        APanDragItemDrawRect:=Self.FSkinCustomListIntf.Prop.VisibleItemDrawRect(Self.FSkinCustomListIntf.Prop.FPanDragItem);
        APanDragItemDesignerPanelClipRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect;

        if PtInRect(APanDragItemDrawRect,PointF(X,Y)) then
        begin

            Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseDown(Button,Shift,X,Y);


            if PtInRect(APanDragItemDesignerPanelClipRect,PointF(X,Y)) then
            begin
              APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel);
              //初始事件没有被处理
              APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;
              //处理鼠标按下消息
              APanDragItemDrawItemDesignerPanel.SkinControlType
                              .DirectUIMouseDown(Self.FSkinControl,Button,Shift,X-APanDragItemDesignerPanelClipRect.Left,Y-APanDragItemDesignerPanelClipRect.Top);
              if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
              begin
                Self.Invalidate;
                //消息被平拖列表项的控件处理过了
                Exit;
              end
              else
              begin
                //如果事件没有被处理,那么传递给Item,也就是点击列表项
              end;
            end;


        end
        else
        begin
          //在别的地方平拖
          //停止平拖
          Self.FSkinCustomListIntf.Prop.StopItemPanDrag;
        end;


    end
    else
    begin

        //尚没有启动平拖
        if Self.FSkinCustomListIntf.Prop.CanEnableItemPanDrag
          and (Self.FSkinCustomListIntf.Prop.FMouseDownItem<>nil) then
        begin
          Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseDown(Button,Shift,X,Y);
        end;


    end;

end;

procedure TSkinCustomListDefaultType.CustomMouseEnter;
begin
  Inherited;

  Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseEnter;

end;

procedure TSkinCustomListDefaultType.CustomMouseLeave;
begin
  inherited;

  Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseLeave;

  //如果开始项目平拖了
  if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
  begin
    TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel).SkinControlType.DirectUIMouseLeave;
  end;

  DoProcessItemCustomMouseLeave(Self.FSkinCustomListIntf.Prop.MouseOverItem);

  Self.FSkinCustomListIntf.Prop.MouseOverItem:=nil;

end;

procedure TSkinCustomListDefaultType.CustomMouseMove(Shift: TShiftState;X,Y:Double);
var
  AItemDrawRect:TRectF;
  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
  APanDragItemDesignerPanelClipRect:TRectF;
begin
  inherited;


  //去掉子控件传递过来的鼠标消息
  if Self.FCurrentMouseEventIsChildOwn then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseMove IsChildMouseEvent');
    Exit;
  end;



  //在一段时间内鼠标超出一段距离
  //就表示不是鼠标点击事件
  //需要停止长按的定时器
  if (Self.FSkinCustomListIntf.Prop.FMouseDownItem<>nil)
    and (GetDis(PointF(X,Y),FMouseDownPt)>8) then
  begin
    Self.FSkinCustomListIntf.Prop.StopCheckLongTapItemTimer;
    Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;
  end;





  //在这里也要判断是否需要平拖列表项,因为移动平台上有可能MouseMove消息比MousrDown消息早
  if
    Self.FSkinCustomListIntf.Prop.CanEnableItemPanDrag
    and not Self.FSkinCustomListIntf.Prop.FIsStopingItemPanDrag
   then
  begin
    Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseMove(Shift,X,Y);
  end;






  //原ItemDesignerPanel处理鼠标离开效果
  Self.FSkinCustomListIntf.Prop.MouseOverItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);





  //获取平拖列表项的鼠标移动事件
  if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
  begin
      APanDragItemDesignerPanelClipRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect;
      APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel);

      //初始事件没有被处理
      APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;
      //处理鼠标按下消息
      APanDragItemDrawItemDesignerPanel.SkinControlType.DirectUIMouseMove(Self.FSkinControl,Shift,X-APanDragItemDesignerPanelClipRect.Left,Y-APanDragItemDesignerPanelClipRect.Top);
      if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
      begin
        Exit;
      end;
  end;



  //现ItemDesignerPanel处理鼠标移动效果
  Self.DoProcessItemCustomMouseMove(Self.FSkinCustomListIntf.Prop.FMouseOverItem,
                  Shift,X,Y);


end;

procedure TSkinCustomListDefaultType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
var
  AItem:TBaseSkinItem;
  APanDragItemDrawItemDesignerPanel:TSkinItemDesignerPanel;
  APanDragItemDesignerPanelClipRect:TRectF;

  AIsDoProcessItemCustomMouseUp:Boolean;
begin
//  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp');

  inherited;

  //去掉子控件传递过来的鼠标消息
  if Self.FCurrentMouseEventIsChildOwn then
  begin
//    uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseDown IsChildMouseEvent');
    Exit;
  end;


      //停止检测长按列表项事件
      Self.FSkinCustomListIntf.Prop.StopCheckLongTapItemTimer;
      Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;



      //平拖列表项处理
      if Self.FSkinCustomListIntf.Prop.CanEnableItemPanDrag
        and Not Self.FSkinCustomListIntf.Prop.FIsStopingItemPanDrag then
      begin
        Self.FSkinCustomListIntf.Prop.FItemPanDragGestureManager.MouseUp(Button,Shift,X,Y);
      end;




      //获取平拖列表项的鼠标弹起事件
      if Self.FSkinCustomListIntf.Prop.IsStartedItemPanDrag then
      begin
          APanDragItemDesignerPanelClipRect:=Self.FSkinCustomListIntf.Prop.GetPanDragItemDesignerPanelDrawRect;
          APanDragItemDrawItemDesignerPanel:=TSkinItemDesignerPanel(Self.FSkinCustomListIntf.Prop.FItemPanDragDesignerPanel);
          //初始事件没有被处理
          APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild:=False;

          //处理鼠标按下消息
          APanDragItemDrawItemDesignerPanel.SkinControlType
                          .DirectUIMouseUp(Self.FSkinControl,Button,
                                Shift,
                                X-APanDragItemDesignerPanelClipRect.Left,
                                Y-APanDragItemDesignerPanelClipRect.Top,
                                True);
          if APanDragItemDrawItemDesignerPanel.SkinControlType.EventProcessedByChild then
          begin
            Invalidate;

            Exit;
          end;

      end;



      //处理列表项的鼠标消息
      //判断鼠标消息是否被列表项的DrawItemDesignerPanel上面的子控件处理
      AIsDoProcessItemCustomMouseUp:=DoProcessItemCustomMouseUp(
                                Self.FSkinCustomListIntf.Prop.FInnerMouseDownItem,
                                Button,Shift,X,Y
                                );



      if
        Not Self.FSkinCustomListIntf.Prop.FHasCalledOnLongTapItem
        and Not AIsDoProcessItemCustomMouseUp
        then
      begin

          //选中列表项
          AItem:=Self.FSkinCustomListIntf.Prop.VisibleItemAt(X,Y);
          if
            (AItem = Self.FSkinCustomListIntf.Prop.FMouseDownItem)

              and (Abs(FMouseDownAbsolutePt.X-Self.FMouseUpAbsolutePt.X)<Const_CanCallClickEventDistance)
                and (Abs(FMouseDownAbsolutePt.Y-FMouseUpAbsolutePt.Y)<Const_CanCallClickEventDistance) then
              begin



                  //也可以呼叫点击事件
                  //选中列表项
//                  Self.FSkinCustomListIntf.Prop.DoClickItem(AItem,X,Y);

//                  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp ClickItem');


                  //在Timer中调用DoClickItem
                  Self.FSkinCustomListIntf.Prop.CreateCallOnClickItemTimer;
                  Self.FSkinCustomListIntf.Prop.StartCallOnClickItemTimer;

                  //需要绘制点击效果
                  Self.FSkinCustomListIntf.Prop.FLastMouseDownItem:=AItem;
                  Self.FSkinCustomListIntf.Prop.FLastMouseDownX:=X;
                  Self.FSkinCustomListIntf.Prop.FLastMouseDownY:=Y;
              end
              else
              begin
//                  uBaseLog.OutputDebugString('TSkinCustomListDefaultType.CustomMouseUp Move Over 5Pixel,Not Click');

              end;

      end;



      Self.FSkinCustomListIntf.Prop.FMouseDownItem:=nil;
      Self.FSkinCustomListIntf.Prop.FInnerMouseDownItem:=nil;

      Invalidate;


end;

procedure TSkinCustomListDefaultType.SizeChanged;
begin
  inherited;

  if (FSkinCustomListIntf<>nil)
    and (Self.FSkinCustomListIntf.Properties<>nil)
    and (Self.FSkinCustomListIntf.Prop.FListLayoutsManager<>nil) then
  begin
    Self.FSkinCustomListIntf.Prop.FListLayoutsManager.DoItemSizeChange(nil);
  end;

end;


{ TSkinCustomListDefaultMaterial }

function TSkinCustomListDefaultMaterial.GetSkinCustomListItemMaterialClass:TBaseSkinItemMaterialClass;
begin
  Result:=TBaseSkinListItemMaterial;
end;

procedure TSkinCustomListDefaultMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinCustomListDefaultMaterial;
begin
  if Dest is TSkinCustomListDefaultMaterial then
  begin

    DestObject:=TSkinCustomListDefaultMaterial(Dest);


    DestObject.FDefaultTypeItemMaterial.Assign(FDefaultTypeItemMaterial);

    DestObject.FItem1TypeItemMaterial.Assign(FItem1TypeItemMaterial);

    DestObject.FIsSimpleDrawItemDevide:=FIsSimpleDrawItemDevide;


  end;
  inherited;
end;

constructor TSkinCustomListDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  //默认类型列表项绘制素材
  FDefaultTypeItemMaterial:=GetSkinCustomListItemMaterialClass.Create(Self);
  FDefaultTypeItemMaterial.SetSubComponent(True);
  FDefaultTypeItemMaterial.Name:='DefaultTypeItemMaterial';



  //Item1类型列表项绘制素材
  FItem1TypeItemMaterial:=GetSkinCustomListItemMaterialClass.Create(Self);
  FItem1TypeItemMaterial.SetSubComponent(True);
  FItem1TypeItemMaterial.Name:='Item1TypeItemMaterial';


  //创建素材更改通知链接
  FItemMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FItemMaterialChangeLink.OnChange:=DoChange;
  FDefaultTypeItemMaterial.RegisterChanges(Self.FItemMaterialChangeLink);
  FItem1TypeItemMaterial.RegisterChanges(Self.FItemMaterialChangeLink);


  FDrawItemDevideLineParam:=TDrawLineParam.Create('','');

  FDrawItemDevideParam:=CreateDrawRectParam('DrawItemDevideParam','分隔线绘制参数');
  FDrawItemDevideParam.IsControlParam:=False;
  FDrawItemDevideParam.FillDrawColor.InitDefaultColor(Const_DefaultBorderColor);
  FDrawItemDevideParam.BorderDrawColor.InitDefaultColor(Const_DefaultBorderColor);

  FIsDrawCenterItemRect:=False;

  FDrawCenterItemRectParam:=CreateDrawRectParam('DrawCenterItemRectParam','中间块绘制参数');
  FDrawCenterItemRectParam.IsControlParam:=False;
  FDrawCenterItemRectParam.FillDrawColor.InitDefaultColor(Const_DefaultBorderColor);
  FDrawCenterItemRectParam.BorderDrawColor.InitDefaultColor(Const_DefaultBorderColor);



  FDrawEmptyContentCaptionParam:=CreateDrawTextParam('DrawEmptyContentCaptionParam','空白内容时标题的绘制参数');
  FDrawEmptyContentCaptionParam.IsControlParam:=False;

  FDrawEmptyContentDescriptionParam:=CreateDrawTextParam('DrawEmptyContentDescriptionParam','空白内容时描述的绘制参数');
  FDrawEmptyContentDescriptionParam.IsControlParam:=False;

  FDrawEmptyContentPictureParam:=CreateDrawPictureParam('DrawEmptyContentPictureParam','空白内容时图片的绘制参数');
  FDrawEmptyContentPictureParam.IsControlParam:=False;




  FIsSimpleDrawItemDevide:=True;
end;

function TSkinCustomListDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];


    if ABTNode.NodeName='IsSimpleDrawItemDevide' then
    begin
      FIsSimpleDrawItemDevide:=ABTNode.ConvertNode_Bool32.Data;
    end

    else if ABTNode.NodeName='DefaultTypeItemMaterial' then
    begin
      FDefaultTypeItemMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    else if ABTNode.NodeName='Item1TypeItemMaterial' then
    begin
      FItem1TypeItemMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    ;
  end;

  Result:=True;
end;

function TSkinCustomListDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsSimpleDrawItemDevide','是否简单绘制分隔线');
  ABTNode.ConvertNode_Bool32.Data:=FIsSimpleDrawItemDevide;

  ABTNode:=ADocNode.AddChildNode_Class('DefaultTypeItemMaterial','默认列表项绘制参数');
  Self.FDefaultTypeItemMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);


  ABTNode:=ADocNode.AddChildNode_Class('Item1TypeItemMaterial','Item1类型列表项绘制参数');
  Self.FItem1TypeItemMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  Result:=True;
end;

destructor TSkinCustomListDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawItemDevideParam);
  FreeAndNil(FDrawItemDevideLineParam);

  FreeAndNil(FDrawCenterItemRectParam);



  FDefaultTypeItemMaterial.UnRegisterChanges(Self.FItemMaterialChangeLink);
  FItem1TypeItemMaterial.UnRegisterChanges(Self.FItemMaterialChangeLink);
  FreeAndNil(FDefaultTypeItemMaterial);
  FreeAndNil(FItem1TypeItemMaterial);





  FreeAndNil(FDrawEmptyContentCaptionParam);
  FreeAndNil(FDrawEmptyContentDescriptionParam);
  FreeAndNil(FDrawEmptyContentPictureParam);


  //FItemMaterialChangeLink要放在FDefaultTypeItemMaterial释放之后,不然会报错
  FreeAndNil(FItemMaterialChangeLink);
  inherited;
end;

function TSkinCustomListDefaultMaterial.GetDrawItemAccessoryPictureParam: TDrawPictureParam;
begin
  Result:=FDefaultTypeItemMaterial.FDrawItemAccessoryPictureParam;
end;

function TSkinCustomListDefaultMaterial.GetDrawItemBackColorParam: TDrawRectParam;
begin
  Result:=FDefaultTypeItemMaterial.FDrawItemBackColorParam;
end;

function TSkinCustomListDefaultMaterial.GetDrawItemBackGndPictureParam: TDrawPictureParam;
begin
  Result:=FDefaultTypeItemMaterial.FDrawItemBackGndPictureParam;
end;

function TSkinCustomListDefaultMaterial.GetItemAccessoryPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemAccessoryPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackDownPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackDownPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackHoverPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackHoverPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackNormalPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackNormalPicture;
end;

function TSkinCustomListDefaultMaterial.GetItemBackPushedPicture: TDrawPicture;
begin
  Result:=FDefaultTypeItemMaterial.FItemBackPushedPicture;
end;

//procedure TSkinCustomListDefaultMaterial.SetItemBackDisabledPicture(const Value: TDrawPicture);
//begin
//  FDefaultTypeItemMaterial.FItemBackDisabledPicture.Assign(Value);
//end;

procedure TSkinCustomListDefaultMaterial.SetItemBackDownPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackDownPicture.Assign(Value);
end;

//procedure TSkinCustomListDefaultMaterial.SetItemBackFocusedPicture(const Value: TDrawPicture);
//begin
//  FDefaultTypeItemMaterial.FItemBackFocusedPicture.Assign(Value);
//end;

procedure TSkinCustomListDefaultMaterial.SetItemBackHoverPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackHoverPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetItemBackNormalPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackNormalPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetIsDrawCenterItemRect(const Value: Boolean);
begin
  if FIsDrawCenterItemRect<>Value then
  begin
    FIsDrawCenterItemRect := Value;
    DoChange;
  end;
end;

procedure TSkinCustomListDefaultMaterial.SetIsSimpleDrawItemDevide(const Value: Boolean);
begin
  if FIsSimpleDrawItemDevide<>Value then
  begin
    FIsSimpleDrawItemDevide := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCustomListDefaultMaterial.SetItemAccessoryPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemAccessoryPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetItemBackPushedPicture(const Value: TDrawPicture);
begin
  FDefaultTypeItemMaterial.FItemBackPushedPicture.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDefaultTypeItemMaterial(const Value: TBaseSkinListItemMaterial);
begin
  FDefaultTypeItemMaterial.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetItem1TypeItemMaterial(const Value: TBaseSkinListItemMaterial);
begin
  FItem1TypeItemMaterial.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDefaultTypeItemStyle(const Value: String);
begin
  if FDefaultTypeItemStyle<>Value then
  begin
    FDefaultTypeItemStyle := Value;
    Self.DoChange;
  end;
end;

procedure TSkinCustomListDefaultMaterial.SetDrawCenterItemRectParam(const Value: TDrawRectParam);
begin
  FDrawCenterItemRectParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawEmptyContentCaptionParam(
  const Value: TDrawTextParam);
begin
  FDrawEmptyContentCaptionParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawEmptyContentDescriptionParam(
  const Value: TDrawTextParam);
begin
  FDrawEmptyContentDescriptionParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawEmptyContentPictureParam(
  const Value: TDrawPictureParam);
begin
  FDrawEmptyContentPictureParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemDevideParam(const Value: TDrawRectParam);
begin
  FDrawItemDevideParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemBackColorParam(const Value: TDrawRectParam);
begin
  FDefaultTypeItemMaterial.FDrawItemBackColorParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDefaultTypeItemMaterial.FDrawItemBackGndPictureParam.Assign(Value);
end;

procedure TSkinCustomListDefaultMaterial.SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);
begin
  FDefaultTypeItemMaterial.FDrawItemAccessoryPictureParam.Assign(Value);
end;




{ TBaseSkinListItemMaterial }


constructor TBaseSkinListItemMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  FDrawItemBackColorParam:=CreateDrawRectParam('DrawItemBackColorParam','背景绘制参数');
  FDrawItemBackColorParam.IsControlParam:=False;

  FDrawItemBackGndPictureParam:=CreateDrawPictureParam('DrawItemBackGndPictureParam','背景图片绘制参数');
  FDrawItemBackGndPictureParam.IsControlParam:=False;



  FItemAccessoryPicture:=CreateDrawPicture('ItemAccessoryPicture','展开图片');
  FDrawItemAccessoryPictureParam:=CreateDrawPictureParam('DrawItemAccessoryPictureParam','展开图片绘制参数');
  FDrawItemAccessoryPictureParam.IsControlParam:=False;



  FItemBackNormalPicture:=CreateDrawPicture('ItemBackNormalPicture','正常状态图片','所有状态图片');
  FItemBackHoverPicture:=CreateDrawPicture('ItemBackHoverPicture','鼠标停靠状态图片','所有状态图片');
  FItemBackDownPicture:=CreateDrawPicture('ItemBackDownPicture','鼠标按下状态图片','所有状态图片');
//  FItemBackDisabledPicture:=CreateDrawPicture('ItemBackDisabledPicture','禁用状态图片','所有状态图片');
//  FItemBackFocusedPicture:=CreateDrawPicture('ItemBackFocusedPicture','得到焦点状态图片','所有状态图片');
  FItemBackPushedPicture:=CreateDrawPicture('ItemBackPushedPicture','按下状态图片','所有状态图片');


end;

destructor TBaseSkinListItemMaterial.Destroy;
begin
  FreeAndNil(FDrawItemBackColorParam);
  FreeAndNil(FDrawItemBackGndPictureParam);

  FreeAndNil(FItemAccessoryPicture);
  FreeAndNil(FDrawItemAccessoryPictureParam);

  FreeAndNil(FItemBackHoverPicture);
  FreeAndNil(FItemBackNormalPicture);
  FreeAndNil(FItemBackDownPicture);
  FreeAndNil(FItemBackPushedPicture);
//  FreeAndNil(FItemBackFocusedPicture);
//  FreeAndNil(FItemBackDisabledPicture);

  inherited;
end;

//procedure TBaseSkinListItemMaterial.SetItemBackDisabledPicture(const Value: TDrawPicture);
//begin
//  FItemBackDisabledPicture.Assign(Value);
//end;

procedure TBaseSkinListItemMaterial.SetItemBackDownPicture(const Value: TDrawPicture);
begin
  FItemBackDownPicture.Assign(Value);
end;

//procedure TBaseSkinListItemMaterial.SetItemBackFocusedPicture(const Value: TDrawPicture);
//begin
//  FItemBackFocusedPicture.Assign(Value);
//end;

procedure TBaseSkinListItemMaterial.SetItemBackHoverPicture(const Value: TDrawPicture);
begin
  FItemBackHoverPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetItemBackNormalPicture(const Value: TDrawPicture);
begin
  FItemBackNormalPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetItemAccessoryPicture(const Value: TDrawPicture);
begin
  FItemAccessoryPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetItemBackPushedPicture(const Value: TDrawPicture);
begin
  FItemBackPushedPicture.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetDrawItemBackColorParam(const Value: TDrawRectParam);
begin
  FDrawItemBackColorParam.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetDrawItemBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDrawItemBackGndPictureParam.Assign(Value);
end;

procedure TBaseSkinListItemMaterial.SetDrawItemAccessoryPictureParam(const Value: TDrawPictureParam);
begin
  FDrawItemAccessoryPictureParam.Assign(Value);
end;




{ TSkinCustomList }

function TSkinCustomList.Material:TSkinCustomListDefaultMaterial;
begin
  Result:=TSkinCustomListDefaultMaterial(SelfOwnMaterial);
end;

function TSkinCustomList.SelfOwnMaterialToDefault:TSkinCustomListDefaultMaterial;
begin
  Result:=TSkinCustomListDefaultMaterial(SelfOwnMaterial);
end;

function TSkinCustomList.CurrentUseMaterialToDefault:TSkinCustomListDefaultMaterial;
begin
  Result:=TSkinCustomListDefaultMaterial(CurrentUseMaterial);
end;

function TSkinCustomList.GetPostValue(ASetting: TFieldControlSetting;
  APageDataDir: String; ASetRecordFieldValueIntf: ISetRecordFieldValue;
  var AErrorMessage: String): Variant;
var
  I: Integer;
  AItem:TSkinItem;
  AStringList:TStringList;
begin
  Result:=Inherited;


  //给控件设置值
  //判断AValue是否是字符串列表,
  //应用在建群的时候返回群成员ID列表
  AStringList:=TStringList.Create;
  Self.Prop.Items.BeginUpdate;
  try

    for I := 0 to Self.Prop.Items.Count - 1 do
    begin
      AItem:=TSkinItem(Self.Prop.Items[I]);
      AStringList.Add(AItem.Caption);

    end;

    Result:=AStringList.CommaText;

  finally
    Self.Prop.Items.EndUpdate;
    FreeAndNil(AStringList);
  end;

end;

//function TSkinCustomList.GetProp(APropName: String): Variant;
//begin
//  Result:=Inherited;
//
//
//end;

function TSkinCustomList.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TCustomListProperties;
end;

//function TSkinCustomList.GetPropJsonStr: String;
//begin
//  Result:=Inherited;
//
//
//end;

function TSkinCustomList.GetCustomListProperties: TCustomListProperties;
begin
  Result:=TCustomListProperties(Self.FProperties);
end;

procedure TSkinCustomList.SetControlValue(ASetting: TFieldControlSetting;
  APageDataDir, AImageServerUrl: String; AValue: Variant; AValueCaption: String;
  AGetDataIntfResultFieldValueIntf: IGetDataIntfResultFieldValue);
var
  AStringList:TStringList;
  I: Integer;
  AItem:TSkinItem;
begin
  inherited;

  //给控件设置值
  //判断AValue是否是字符串列表
  AStringList:=TStringList.Create;
  Self.Prop.Items.BeginUpdate;
  try
    Self.Prop.Items.Clear;
    AStringList.CommaText:=AValue;

    for I := 0 to AStringList.Count - 1 do
    begin
      AItem:=TSkinItem(Self.Prop.Items.Add);
      AItem.Caption:=AStringList[I];
    end;

  finally
    Self.Prop.Items.EndUpdate;
    FreeAndNil(AStringList);
  end;
end;

procedure TSkinCustomList.SetCustomListProperties(Value: TCustomListProperties);
begin
  Self.FProperties.Assign(Value);
end;

//procedure TSkinCustomList.SetProp(APropName: String; APropValue: Variant);
//begin
//  inherited;
//
//end;

//procedure TSkinCustomList.SetPropJsonStr(AJsonStr: String);
//begin
//  inherited;
//
//end;

function TSkinCustomList.GetItems:TBaseSkinItems;
begin
  Result:=Self.Properties.Items;
end;

procedure TSkinCustomList.Loaded;
begin
  Inherited;

  //结束更新
  Self.Properties.Items.EndUpdate(True);


  //默认选中居中显示项
  if Properties.IsEnabledCenterItemSelectMode then
  begin
    Properties.DoAdjustCenterItemPositionAnimateEnd(Self);
  end;
end;

function TSkinCustomList.LoadFromFieldControlSetting(ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
begin
  Result:=Inherited;

  Self.Prop.MultiSelect:=(ASetting.options_is_multi_select=1);


//  if (ASetting.options_value<>'')
//    or (ASetting.options_page_name<>'') then
//  begin
//
//  end;

end;

procedure TSkinCustomList.ReadState(Reader: TReader);
begin
  //开始更新
  Self.Properties.Items.BeginUpdate;

  LockSkinControlInvalidate;
  try
    inherited ReadState(Reader);
  finally
    UnLockSkinControlInvalidate;
  end;


end;

procedure TSkinCustomList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);

  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin

      //所关联的Component释放之后,清除引用
      if (AComponent=Self.Properties.ItemPanDragDesignerPanel) then
      begin
        Self.Properties.ItemPanDragDesignerPanel:=nil;
      end;

      //所关联的Component释放之后,清除引用
      if (AComponent=Self.Properties.EmptyContentControl) then
      begin
        Self.Properties.EmptyContentControl:=nil;
      end;

    end;
  end;
end;

function TSkinCustomList.GetOnAdvancedDrawItem: TCustomListDrawItemEvent;
begin
  Result:=FOnAdvancedDrawItem;
end;

function TSkinCustomList.GetOnClickItem: TCustomListClickItemEvent;
begin
  Result:=FOnClickItem;
end;

function TSkinCustomList.GetOnClickItemDesignerPanelChild: TCustomListClickItemDesignerPanelChildEvent;
begin
  Result:=FOnClickItemDesignerPanelChild;
end;

//function TSkinCustomList.GetOnItemDesignerPanelChildCanStartEdit: TCustomListItemDesignerPanelChildCanStartEditEvent;
//begin
//  Result:=FOnItemDesignerPanelChildCanStartEdit;
//end;

function TSkinCustomList.GetOnLongTapItem: TCustomListDoItemEvent;
begin
  Result:=FOnLongTapItem;
end;

function TSkinCustomList.GetOnMouseOverItemChange: TNotifyEvent;
begin
  Result:=FOnMouseOverItemChange;
end;

function TSkinCustomList.GetOnClickItemEx: TCustomListClickItemExEvent;
begin
  Result:=FOnClickItemEx;
end;

function TSkinCustomList.GetOnCenterItemChange: TCustomListDoItemEvent;
begin
  Result:=FOnCenterItemChange;
end;

function TSkinCustomList.GetOnPrepareDrawItem: TCustomListDrawItemEvent;
begin
  Result:=FOnPrepareDrawItem;
end;

function TSkinCustomList.GetOnSelectedItem: TCustomListDoItemEvent;
begin
  Result:=FOnSelectedItem;
end;

function TSkinCustomList.GetOnPrepareItemPanDrag: TCustomListPrepareItemPanDragEvent;
begin
  Result:=FOnPrepareItemPanDrag;
end;

function TSkinCustomList.GetOnStartEditingItem: TCustomListEditingItemEvent;
begin
  Result:=FOnStartEditingItem;
end;

function TSkinCustomList.GetOnStopEditingItem: TCustomListEditingItemEvent;
begin
  Result:=FOnStopEditingItem;
end;



{ TListItemStyleRegList }

function TListItemStyleRegList.FindItemByClass(AFrameClass: TFrameClass): TListItemStyleReg;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if AFrameClass=Items[I].FrameClass then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TListItemStyleRegList.FindItemByName(AName: String): TListItemStyleReg;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if SameText(AName,Items[I].Name) then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TListItemStyleRegList.GetItem(Index: Integer): TListItemStyleReg;
begin
  Result:=TListItemStyleReg(Inherited Items[Index]);
end;

function GetSuitControlContentHeight(AControl:TParentControl;const ABottomSpace:TControlSize):TControlSize;
var
  I: Integer;
  AChild:TControl;
//  ALastControl:TControl;
begin
  Result:=0;
//  ALastControl:=nil;

  for I := 0 to GetParentChildControlCount(AControl)-1 do
  begin
    AChild:=GetParentChildControl(AControl,I);
    if  //必须要统计显示的控件
        AChild.Visible
      and BiggerDouble(AChild.Height,0)
      and (GetControlTop(AChild)+AChild.Height>Result) then
    begin
//      ALastControl:=GetParentChildControl(AControl,I);
      Result:=GetControlTop(AChild)+AChild.Height;
    end;
  end;
  Result:=Result+ABottomSpace;


//  //仅用于测试
//  if ALastControl<>nil then
//  begin
//    uBaseLog.OutputDebugString('GetSuitControlContentHeight LastControl '+ALastControl.Name);
//  end;
end;

{ TListItemTypeStyleSetting }

function TListItemTypeStyleSetting.CalcItemAutoSize(AItem: TBaseSkinItem; const ABottomSpace: TControlSize): TSizeF;
var
  AItemDrawRect:TRect;
  AItemDrawRectF:TRectF;
  AItemDesignerPanel:TSkinItemDesignerPanel;
begin
  //默认值
  Result.cx:=AItem.GetWidth;
  Result.cy:=AItem.GetHeight;


  //使用了设计面板
  AItemDesignerPanel:=GetInnerItemDesignerPanel(nil);


  if (AItemDesignerPanel<>nil) and (FCustomListProperties<>nil) then
  begin
      //计算出Item的矩形,不需要位置,只需要高度和宽度
      AItemDrawRect:=Rect(0,
                          0,
                          Ceil(Self.FCustomListProperties.CalcItemWidth(AItem)),
                          Ceil(Self.FCustomListProperties.CalcItemHeight(AItem))
                          );
      AItemDrawRectF:=RectF(0,
                          0,
                          Ceil(Self.FCustomListProperties.CalcItemWidth(AItem)),
                          Ceil(Self.FCustomListProperties.CalcItemHeight(AItem))
                          );
      //设置尺寸,因为有些控件需要拉抻
      AItemDesignerPanel.Height:=ControlSize(RectHeight(AItemDrawRect));
      AItemDesignerPanel.Width:=ControlSize(RectWidth(AItemDrawRect));


      AItemDesignerPanel.Prop.SetControlsValueByItem(
                                                    TSkinVirtualList(Self.FCustomListProperties.FSkinControl).Prop.SkinImageList,
                                                    TSkinItem(AItem),
                                                    False);


      if Assigned(AItemDesignerPanel.OnPrepareDrawItem) then
      begin
        AItemDesignerPanel.OnPrepareDrawItem(
                                            nil,
                                            nil,
                                            TItemDesignerPanel(AItemDesignerPanel),
                                            TSkinItem(AItem),
                                            AItemDrawRectF
                                            );
      end;



      if Assigned(TSkinVirtualList(Self.FCustomListProperties.FSkinControl).OnPrepareDrawItem) then
      begin
        TSkinVirtualList(Self.FCustomListProperties.FSkinControl).OnPrepareDrawItem(
              nil,
              nil,
              TItemDesignerPanel(AItemDesignerPanel),
              TSkinItem(AItem),
              AItemDrawRect
              );
      end;

      Result.cy:=GetSuitControlContentHeight(AItemDesignerPanel,ABottomSpace);
  end;

//    Result:=Self.GetItemStyleFrameCache(nil)
//                .FItemStyleFrame.CalcItemSize(
//                  TSkinVirtualList(Self.FSkinControl),
//                  AItem,
//                  Rect(0,0,
//                        Ceil(Self.FSkinControl.Width),
//                        Ceil(Self.ItemHeight)
//                        )
//                  );


end;

procedure TListItemTypeStyleSetting.Clear;
begin
  //列表项风格名称
  Style:='';// read FStyle write SetStyle;
  //列表项设计面板
  ItemDesignerPanel:=nil;// read FItemDesignerPanel write SetItemDesignerPanel;
end;

constructor TListItemTypeStyleSetting.Create(AProp: TCustomListProperties;AItemType:TSkinItemType);
begin
  FConfig:=TStringList.Create;
  FCustomListProperties:=AProp;
  FItemType:=AItemType;
  FIsUseCache:=True;
  FFrameCacheList:=TListItemStyleFrameCacheList.Create;
end;

destructor TListItemTypeStyleSetting.Destroy;
begin
  try
    SetItemDesignerPanel(nil);

    FreeAndNil(FFrameCacheList);

    FreeAndNil(FConfig);

    inherited;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TListItemTypeStyleSetting.Destroy');
    end;
  end;
end;

procedure TListItemTypeStyleSetting.DoDownloadListItemStyleStateChange(
  Sender: TObject; AUrlCacheItem: TUrlCacheItem);
begin
  //下载成功
  if (AUrlCacheItem.State=dpsDownloadSucc) and (AUrlCacheItem.IsLoaded) then
  begin
    Self.SetListItemStyleReg(TBaseUrlListItemStyle(AUrlCacheItem).FListItemStyleReg);
  end;
end;

function TListItemTypeStyleSetting.GetInnerItemDesignerPanel(ASkinItem: TBaseSkinItem): TSkinItemDesignerPanel;
var
  AItemStyleFrameCache:TListItemStyleFrameCache;
begin
//  if ASkinItem<>nil then
//  begin
//    //要用它来
//    TBaseSkinItem(ASkinItem).FDrawListItemTypeStyleSetting:=Self;
//  end;

  if (Self.FStyle<>'') and (FListItemStyleReg<>nil) then
  begin

      //使用了风格
      //获取缓存
      AItemStyleFrameCache:=GetItemStyleFrameCache(ASkinItem);


      if AItemStyleFrameCache<>nil then
      begin
        Result:=AItemStyleFrameCache.FItemStyleFrameIntf.ItemDesignerPanel;
      end
      else
      begin
        uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetInnerItemDesignerPanel AItemStyleFrame is nil');
      end;

  end
  else
  begin

      //不使用风格,直接使用设计面板
      Result:=Self.FItemDesignerPanel;
  end;
end;

function TListItemTypeStyleSetting.GetItemStyleFrameCache(ASkinItem: TBaseSkinItem): TListItemStyleFrameCache;
var
  I:Integer;
begin
  Result:=nil;
  if (Self.Style<>'') and (FListItemStyleReg<>nil) then
  begin
      if FIsUseCache then
      begin




          //使用缓存
          //如果有,直接找到上次使用的
          for I := 0 to FFrameCacheList.Count-1 do
          begin
            if (FFrameCacheList[I].FSkinItem=ASkinItem) then
            begin
              Result:=FFrameCacheList[I];
              Exit;
            end;
          end;




          //寻找出可用的,或者叫空闲的
          if Result=nil then
          begin
              for I := 0 to FFrameCacheList.Count-1 do
              begin
                if not FFrameCacheList[I].FIsUsed then
                begin

                    Result:=FFrameCacheList[I];
                    //标记为已使用
                    FFrameCacheList[I].FSkinItem:=ASkinItem;
                    FFrameCacheList[I].FIsUsed:=True;

                    //加载设置
                    if ASkinItem<>nil then
                    begin
                      LoadListItemStyleFrameConfig(FFrameCacheList[I].FItemStyleFrame,ASkinItem.FItemStyleConfig);
                    end;

                    Exit;
                end;
              end;
          end;




          //实在没有,就创建一个新的
          //但也不能一直创建新的
          if Result=nil then
          begin
              uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsUseCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);

              //要创建一个StyleFrameCache,
              Result:=NewListItemStyleFrameCache;

              //wn
              Result.FSkinItem:=ASkinItem;

              Result.FIsUsed:=True;

              //加载设置
              //加载设置
              if ASkinItem<>nil then
              begin
                LoadListItemStyleFrameConfig(Result.FItemStyleFrame,ASkinItem.FItemStyleConfig);
              end;

          end;



      end
      else
      begin
          //不使用缓存,那么只取第一个就行了
          if FFrameCacheList.Count=0 then
          begin
              //要创建一个Frame,
              uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);

              Result:=NewListItemStyleFrameCache;

//              TListItemStyleFrameCache.Create;
//              Self.FFrameCacheList.Add(Result);//先添加,避免在XP系统下面一个创建失败,会连续创建多个的问题
//              try
//                  Result.FItemStyleFrame:=FListItemStyleReg.FrameClass.Create(nil);
//
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 1');
//
//                  SetFrameName(Result.FItemStyleFrame);
//                  LoadListItemStyleFrameConfig(Result.FItemStyleFrame,Self.FConfig);
//                  Result.FItemStyleFrame.GetInterface(IID_IFrameBaseListItemStyle,Result.FItemStyleFrameIntf);
//
//
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 2');
//                  {$IFDEF FMX}
//    //              Result.FItemStyleFrame.Position.X:=-1000;
//    //              Result.FItemStyleFrame.Position.Y:=-1000;
//                  {$ELSE}
//                  Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 3');
//                  Result.FItemStyleFrame.Left:=-1000;
//                  Result.FItemStyleFrame.Top:=-1000;
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 4');
//                  Result.FItemStyleFrame.Width:=0;
//                  Result.FItemStyleFrame.Height:=0;
//                  {$ENDIF}
//
//
////                  uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache 5');
//
//                  //设计面板刷新的时候,刷新整个ListBox
//                  if FCustomListProperties<>nil then
//                  begin
//                    Result.FItemStyleFrameIntf.ItemDesignerPanel.Properties.BindControlInvalidateChange.RegisterChanges(
//                      Self.FCustomListProperties.FItemDesignerPanelInvalidateLink);
//                  end;
//
//              except
//                on E:Exception do
//                begin
//                  uBaseLog.HandleException(E,'TListItemTypeStyleSetting.GetItemStyleFrame IsNoCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);
//                end;
//              end;

          end
          else
          begin
              //只创建一个,直接使用第一个
              Result:=FFrameCacheList[0];
          end;
      end;
  end;
end;

procedure TListItemTypeStyleSetting.MarkAllCacheNoUsed;
var
  I:Integer;
begin
  for I := 0 to Self.FFrameCacheList.Count-1 do
  begin
    Self.FFrameCacheList[I].FIsUsed:=False;
  end;
end;

procedure TListItemTypeStyleSetting.MarkCacheUsed(ASkinItem: TBaseSkinItem);
var
  I:Integer;
begin
  for I := 0 to FFrameCacheList.Count-1 do
  begin
    if (FFrameCacheList[I].FSkinItem=ASkinItem) then
    begin
      FFrameCacheList[I].FIsUsed:=True;
      Break;
    end;
  end;
end;

function TListItemTypeStyleSetting.NewListItemStyleFrameCache: TListItemStyleFrameCache;
begin
        LockSkinControlInvalidate;
        try
          Result:=TListItemStyleFrameCache.Create;
          Self.FFrameCacheList.Add(Result);
          try

              //创建一个Frame
              Result.FItemStyleFrame:=FListItemStyleReg.FrameClass.Create(nil);
              SetFrameName(Result.FItemStyleFrame);

              //加载用户对ListItemStyleFrame所做的自定义设置
              LoadListItemStyleFrameConfig(Result.FItemStyleFrame,Self.FConfig);


              Result.FItemStyleFrame.GetInterface(IID_IFrameBaseListItemStyle,Result.FItemStyleFrameIntf);


              {$IFDEF FMX}
//              Result.FItemStyleFrame.Position.X:=-1000;
//              Result.FItemStyleFrame.Position.Y:=-1000;
              if not (csDesigning in FCustomListProperties.FSkinControl.ComponentState) then
              begin
                //必须要设置parent,不然透明度没有效果了
                Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
                Result.FItemStyleFrame.Visible:=False;
              end;
              {$ELSE}
//              //设置Parent,这会导致ListBox刷新,导致后调用FOnInit和Init
//              Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
//              Result.FItemStyleFrame.Left:=-1000;
//              Result.FItemStyleFrame.Top:=-1000;
//              Result.FItemStyleFrame.Width:=0;
//              Result.FItemStyleFrame.Height:=0;
              {$ENDIF}



              if Assigned(FOnInit) then
              begin
                FOnInit(Self,Self,Result);
              end;


              //初始
              //同一个Frame给多个样式使用时,根据不同Reg.DataObject来初始
              //比如ListItemStyleFrame_Page
              if Result.FItemStyleFrame.GetInterface(IID_IFrameBaseListItemStyle_Init,Result.FItemStyleFrameInitIntf) then
              begin
                Result.FItemStyleFrameInitIntf.Init(FListItemStyleReg);
              end;


//              //因为拉伸有问题
//              SetComponentUniqueName(Result.FItemStyleFrame);
//              Result.FItemStyleFrame.Parent:=Application.MainForm;
//              Result.FItemStyleFrame.Position.X:=2000;
//              Result.FItemStyleFrameIntf.ItemDesignerPanel.Visible:=True;

              uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.GetItemStyleFrame '+FListItemStyleReg.FrameClass.ClassName+' Count:'+IntToStr(Self.FFrameCacheList.Count));
//              procedure SetComponentUniqueName(AComponent:TComponent);



              //设计面板刷新的时候,刷新整个ListBox
              if FCustomListProperties<>nil then
              begin
                Result.FItemStyleFrameIntf.ItemDesignerPanel.Properties.BindControlInvalidateChange.RegisterChanges(
                  Self.FCustomListProperties.FItemDesignerPanelInvalidateLink);
              end;


              {$IFDEF VCL}
              //这会导致ListBox刷新
              Result.FItemStyleFrame.Parent:=TParentControl(FCustomListProperties.FSkinControl);
              Result.FItemStyleFrame.Left:=-1000;
              Result.FItemStyleFrame.Top:=-1000;
              Result.FItemStyleFrame.Width:=0;
              Result.FItemStyleFrame.Height:=0;
              {$ENDIF}



          except
            on E:Exception do
            begin
              uBaseLog.HandleException(E,'TListItemTypeStyleSetting.GetItemStyleFrame IsUseCache Create A New FrameCache '+FListItemStyleReg.FrameClass.ClassName);
            end;
          end;
        finally
          UnLockSkinControlInvalidate;
        end;

end;

procedure TListItemTypeStyleSetting.ReConfig;
var
  I: Integer;
begin
  for I := 0 to Self.FFrameCacheList.Count-1 do
  begin
    //加载用户对ListItemStyleFrame所做的自定义设置
    LoadListItemStyleFrameConfig(FFrameCacheList[I].FItemStyleFrame,Self.FConfig);
  end;

end;

procedure TListItemTypeStyleSetting.ResetStyle;
var
  AUrlCacheItem:TUrlCacheItem;
  AListItemStyleReg: TListItemStyleReg;
begin
  if FIsUseUrlStyle then
  begin


      if (Self.FStyleRootUrl<>'')
          and (Self.FStyle<>'') then
      begin

        //使用在线样式
        //Self.FListItemStyleReg:=
        if Assigned(GlobalOnGetUrlListItemStyleReg) then
        begin
          GlobalOnGetUrlListItemStyleReg(Self,Self.DoDownloadListItemStyleStateChange);
        end
        else
        begin
          raise Exception.Create('GlobalOnGetUrlListItemStyleReg未赋值,请引用uDownloadListItemStyleManager单元');
        end;

      end
      else
      begin
        //参数不齐,暂不处理
        //Self.FListItemStyleReg:=nil;


      end;

  end
  else
  begin

      //使用本地样式

      //根据名称找到列表项风格注册项
      AListItemStyleReg:=GetGlobalListItemStyleRegList.FindItemByName(FStyle);
//      if (FStyle<>'') and (AListItemStyleReg=nil) then
//      begin
//        ShowMessage('未注册列表项样式'+FStyle+',请安装OrangeUIStyles包并引用对应的样式单元');
//      end;
      uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.ResetStyle 未注册列表项样式'+FStyle+',请安装OrangeUIStyles包并引用对应的样式单元');
      SetListItemStyleReg(AListItemStyleReg);


  end;
end;

procedure TListItemTypeStyleSetting.SetConfig(const Value: TStringList);
begin
  FConfig.Assign(Value);
  ReConfig;
end;

procedure TListItemTypeStyleSetting.SetIsUseUrlStyle(const Value: Boolean);
begin
  if FIsUseUrlStyle<>Value then
  begin
    FIsUseUrlStyle := Value;

    ResetStyle;
  end;
end;

procedure TListItemTypeStyleSetting.SetItemDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  if FItemDesignerPanel <> Value then
  begin
    if FCustomListProperties<>nil then
    begin
      FCustomListProperties.RemoveOldDesignerPanel(FItemDesignerPanel);
    end;

    FItemDesignerPanel:=Value;

    if FCustomListProperties<>nil then
    begin
      FCustomListProperties.AddNewDesignerPanel(FItemDesignerPanel);
    end;
  end;
end;

procedure TListItemTypeStyleSetting.SetListItemStyleReg(
  AListItemStyleReg: TListItemStyleReg);
begin
  if AListItemStyleReg<>FListItemStyleReg then
  begin
    //清除缓存
    FFrameCacheList.Clear(True);


    //同时只能用一种方式
    //将ItemDesignerPanel设置为nil,避免发生歧义,到底用的是哪个设置?
    Self.SetItemDesignerPanel(nil);

    FListItemStyleReg:=AListItemStyleReg;
  end;
end;

procedure TListItemTypeStyleSetting.SetStyle(const Value: String);
begin
  if FStyle<>Value then
  begin
    FStyle := Value;

    uBaseLog.HandleException(nil,'TListItemTypeStyleSetting.SetStyle '+Value);


    ResetStyle;

  end;
end;

procedure TListItemTypeStyleSetting.SetStyleRootUrl(const Value: String);
begin
  if FStyleRootUrl<>Value then
  begin
    FStyleRootUrl := Value;

    ResetStyle;

  end;
end;

{ TListItemStyleFrameCacheList }

function TListItemStyleFrameCacheList.GetItem(Index: Integer): TListItemStyleFrameCache;
begin
  Result:=TListItemStyleFrameCache(Inherited Items[Index]);
end;

{ TListItemStyleFrameCache }

destructor TListItemStyleFrameCache.Destroy;
begin
  FItemStyleFrameIntf:=nil;
  FreeAndNil(FItemStyleFrame);
  inherited;
end;

{ TListItemTypeStyleSettingList }

function TListItemTypeStyleSettingList.FindByItemType(AItemType: TSkinItemType): TListItemTypeStyleSetting;
var
  I:Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FItemType=AItemType then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TListItemTypeStyleSettingList.FindByStyle(AStyle: String): TListItemTypeStyleSetting;
var
  I:Integer;
begin
  Result:=nil;
  if AStyle<>'' then
  begin
    for I := 0 to Self.Count-1 do
    begin
      if SameText(Items[I].FStyle,AStyle) then
      begin
        Result:=Items[I];
        Break;
      end;
    end;
  end;
end;

function TListItemTypeStyleSettingList.GetItem(Index: Integer): TListItemTypeStyleSetting;
begin
  Result:=TListItemTypeStyleSetting(Inherited Items[Index]);
end;

initialization

finalization
  FreeAndNil(GlobalListItemStyleRegList);


end.



