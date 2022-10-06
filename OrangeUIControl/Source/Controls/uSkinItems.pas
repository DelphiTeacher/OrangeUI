//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     列表项
///   </para>
///   <para>
///     ListItems
///   </para>
/// </summary>
unit uSkinItems;

interface
{$I FrameWork.inc}

{$I Version.inc}


uses
  Classes,
  SysUtils,
  Types,
  Math,

  {$IFDEF VCL}
  Controls,
  Forms,
  Dialogs,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Controls,
  FMX.Types,
  FMX.Dialogs,
  FMX.Forms,
  {$ENDIF}

  DB,
  uLang,


//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}



  uFuncCommon,
  uBaseList,
  uBasePageStructure,
  uBinaryObjectList,
  uSkinPicture,
  uDrawPicture,
  uBinaryTreeDoc,
  uDrawEngine,
  uUrlPicture,
  uDownloadPictureManager,
  uSkinListLayouts,
  uGraphicCommon,
  uSkinBufferBitmap,
  uSkinImageList,
//  uBasePageStructure,
  uBaseLog;

  {$IF CompilerVersion >= 30.0}
  {$ELSE}
  const varObject=varDispatch;
  {$IFEND}


const
  IID_ISkinItems:TGUID='{A8FF386A-7240-4E3A-B37F-55D730DD10A7}';

type
  TRealSkinItem=class;

  TBaseSkinItem=class;
  TBaseSkinItemClass=class of TBaseSkinItem;

  TBaseSkinItems=class;
  TBaseSkinItemsClass=class of TBaseSkinItems;

  TSkinItems=class;
  TSkinItemsClass=class of TSkinItems;


  TSkinVirtualListLayoutsManager=class;


  //用于设计时编辑列表项
  ISkinItems=interface
    ['{A8FF386A-7240-4E3A-B37F-55D730DD10A7}']
    function GetItems:TBaseSkinItems;
    property Items:TBaseSkinItems read GetItems;
  end;






  {$REGION 'TBaseSkinItem 仅实现基本的排列功能'}
  //仅实现基本的排列功能,没有Caption
  TBaseSkinItem=class(TBinaryObject,ISkinItem)
  protected
    //是否选中
    FSelected:Boolean;


    FWidth: Double;
    FHeight: Double;

    FVisible:Boolean;

    //在释放的时候移除自己,在加载节点的时候,如果没有它,那么Selected就不会被设置到
    FOwner:TBaseSkinItems;
    //宽度和高度更改时候,通知它进行重新排列
    FSkinListIntf:ISkinList;

    FChecked: Boolean;

  public
    function GetHeight: Double;
    function GetVisible: Boolean;
    function GetWidth: Double;virtual;
    //层级
    function GetLevel:Integer;virtual;
    function GetObject:TObject;
    function GetItemRect:TRectF;
    function GetItemDrawRect:TRectF;
    function GetSelected: Boolean;virtual;

    procedure SetItemRect(Value:TRectF);
    procedure SetItemDrawRect(Value:TRectF);
    function GetIsRowEnd:Boolean;
    function GetThisRowItemCount:Integer;

    procedure SetVisible(const Value: Boolean);
    procedure SetSelected(const Value: Boolean);virtual;

    procedure SetHeight(const Value: Double);
    procedure SetChecked(const Value: Boolean);
    //鼠标是否在Item里面
    function PtInItem(APoint:TPointF):Boolean;virtual;
  protected
    //实现ISkinItem接口,用于排列

    //清空显示矩形
    procedure ClearItemRect;virtual;

    //设置列表排列接口
    procedure SetSkinListIntf(ASkinListIntf:ISkinList);
    function GetListLayoutsManager:TSkinListLayoutsManager;virtual;
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
    //根据绑定的FieldName获取Item的值,然后赋给绑定的控件
    function GetValueTypeByBindItemField(AFieldName:String):TVarType;virtual;
    function GetValueByBindItemField(AFieldName:String):Variant;virtual;
    function GetObjectByBindItemField(AFieldName:String):TObject;virtual;abstract;
    procedure SetValueByBindItemField(AFieldName:String;AValue:Variant;APageDataDir:String='';AImageServerUrl:String='');virtual;
  public
    FIsRowEnd:Boolean;

    //列表中的矩形
    FItemRect:TRectF;

    //绘制矩形(加上了滚动偏移)
    FItemDrawRect:TRectF;
    FLastItemDrawRect:TRectF;



    //临时绑定的图片列表,当Image绑定了Item.Detail***,
    //而且Item.Detail为http://这种链接格式的,
    //那么FTempBindDrawPictureList就会添加一张图片,
    //赋给Image
    FTempBindDrawPictureList:TDrawPictureList;




    FOnChange:TNotifyEvent;
  protected

    /// <summary>
    ///   <para>
    ///     尺寸更改(需要重新计算所有列表项的显示矩形)
    ///   </para>
    ///   <para>
    ///     Size change
    ///   </para>
    /// </summary>
    procedure DoSizeChange;virtual;

    /// <summary>
    ///   <para>
    ///     显示更改(需要重新计算可见列表,需要重新计算所有列表项的显示矩形)
    ///   </para>
    ///   <para>
    ///     Visible change
    ///   </para>
    /// </summary>
    procedure DoVisibleChange;virtual;
  public
    /// <summary>
    ///   <para>
    ///     属性更改
    ///   </para>
    ///   <para>
    ///     Property change
    ///   </para>
    /// </summary>
    procedure DoPropChange(Sender:TObject=nil);virtual;
//    procedure AfterConstruction; override;
    constructor Create;virtual;
    //这个方法可以不用了,因为Add的时候会设置FOwner一遍
//    constructor Create(AOwner: TBaseSkinItems);overload;virtual;
    destructor Destroy; override;
  private
    procedure SetOwner(const Value: TBaseSkinItems);
  protected
    //在列表中的顺序
    function GetIndex:Integer;
  public
    //不需要绘制分隔线
    IsNotNeedDrawDevide:Boolean;
    //是否需要重绘,用了缓存设计面板功能之后需要
    IsBufferNeedChange:Boolean;
    FItemStyleConfig:TStringList;

    /// <summary>
    ///   <para>
    ///     在列表中的下标
    ///   </para>
    ///   <para>
    ///     Index
    ///   </para>
    /// </summary>
    property Index:Integer read GetIndex;
    /// <summary>
    ///   <para>
    ///     是否选中
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property StaticSelected:Boolean read FSelected write FSelected;

    /// <summary>
    ///   <para>
    ///     所属的列表
    ///   </para>
    ///   <para>
    ///     Owner
    ///   </para>
    /// </summary>
    property Owner:TBaseSkinItems read FOwner write SetOwner;

    /// <summary>
    ///   <para>
    ///     列表项矩形
    ///   </para>
    ///   <para>
    ///     ListItem rectangle
    ///   </para>
    /// </summary>
    property ItemRect:TRectF read GetItemRect write SetItemRect;
    /// <summary>
    ///   <para>
    ///     列表项绘制矩形
    ///   </para>
    ///   <para>
    ///     Draw rectangle of ListItem
    ///   </para>
    /// </summary>
    property ItemDrawRect:TRectF read GetItemDrawRect write SetItemDrawRect;
    property StaticHeight:Double read FHeight write FHeight;
    property StaticWidth:Double read FWidth write FWidth;
  published

    /// <summary>
    ///   <para>
    ///     设置是否选中
    ///   </para>
    ///   <para>
    ///     Set whether select
    ///   </para>
    /// </summary>
    property Selected:Boolean read GetSelected write SetSelected;
    /// <summary>
    ///   <para>
    ///     是否被勾选
    ///   </para>
    ///   <para>
    ///     Whether is checked
    ///   </para>
    /// </summary>
    property Checked:Boolean read FChecked write SetChecked;

    /// <summary>
    ///   <para>
    ///     高度,如果为-1,表示使用列表项的默认高度ListBox.Prop.ItemHeight
    ///   </para>
    ///   <para>
    ///     Height ,if it is -1,means use default height
    ///   </para>
    /// </summary>
    property Height:Double read GetHeight write SetHeight;

    /// <summary>
    ///   <para>
    ///     是否显示
    ///   </para>
    ///   <para>
    ///     Is visible
    ///   </para>
    /// </summary>
    property Visible:Boolean read GetVisible write SetVisible;

  end;
  {$ENDREGION 'TBaseSkinItem 仅实现基本的排列功能'}




  {$REGION 'TBaseSkinItems 列表项列表基类'}
  /// <summary>
  ///   <para>
  ///     列表项列表
  ///   </para>
  ///   <para>
  ///     ListItem list
  ///   </para>
  /// </summary>
  TBaseSkinItems=class(TBinaryObjectList,ISkinList,ISkinItems)
  private
    function GetBaseSkinItem(Index: Integer): TBaseSkinItem;
    procedure SetBaseSkinItem(Index: Integer; const Value: TBaseSkinItem);
  protected
    //所属的布局管理者
    FListLayoutsManager:TSkinListLayoutsManager;
  protected
    //创建列表项
    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;virtual;
    function GetSkinItemClass:TBaseSkinItemClass;virtual;
  protected
    //ISkinItems接口,用于设计时编辑
    function GetItems:TBaseSkinItems;
  public
    SkinItemClass:TBaseSkinItemClass;
    constructor Create(
                        const AObjectOwnership:TObjectOwnership=ooOwned;
                        const AIsCreateObjectChangeManager:Boolean=True
                        );override;
  public

    //ISkinList接口
    //更新个数
    function GetUpdateCount:Integer;
    //获取某一项
    function GetSkinItem(const Index:Integer):ISkinItem;
    function GetSkinObject(const Index:Integer):TObject;
    //设置排列布局管理者
    procedure SetListLayoutsManager(ALayoutsManager:TSkinListLayoutsManager);virtual;
    //获取排列布局管理者
    function GetListLayoutsManager:TSkinListLayoutsManager;virtual;
    function GetObject:TObject;
  public
    procedure DoChange;override;
  public
    procedure DoAdd(AObject:TObject);override;
    procedure DoDelete(AObject:TObject;AIndex:Integer);override;
    procedure DoInsert(AObject:TObject;AIndex:Integer);override;
    function SelectedCount:Integer;
    function SelectedList:TBaseList;
  public
    /// <summary>
    ///   <para>
    ///     开始更新
    ///   </para>
    ///   <para>
    ///     Begin update
    ///   </para>
    /// </summary>
    procedure BeginUpdate;override;

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
    /// <summary>
    ///   <para>
    ///     获取指定下标的列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Items[Index:Integer]:TBaseSkinItem read GetBaseSkinItem write SetBaseSkinItem;default;
  public
    /// <summary>
    ///   <para>
    ///     列表项排序
    ///   </para>
    ///   <para>
    ///     Sort
    ///   </para>
    /// </summary>
    procedure Sort(Compare: TListSortCompare);override;
  end;
  {$ENDREGION 'TBaseSkinItems 列表项列表基类'}









  /// <summary>
  ///   <para>
  ///     列表项绘制类型,根据此类型来选择使用哪个设计面板
  ///   </para>
  ///   <para>
  ///     ListItem type
  ///   </para>
  /// </summary>
  TSkinItemType=(
                //表示此列表项使用ListBox.Prop.ItemDesignerPanel来绘制
                sitDefault,
                //表示此列表项使用ListBox.Prop.HeaderDesignerPanel来绘制
                sitHeader,
                //表示此列表项使用ListBox.Prop.FooterDesignerPanel来绘制
                sitFooter,
                //表示此列表项空白
                sitSpace,
                //表示此列表项使用ListBox.Prop.Item1DesignerPanel来绘制
                sitItem1,
                //表示此列表项使用ListBox.Prop.Item2DesignerPanel来绘制
                sitItem2,
                //表示此列表项使用ListBox.Prop.Item3DesignerPanel来绘制
                sitItem3,
                //表示此列表项使用ListBox.Prop.SearchBarDesignerPanel来绘制
                sitSearchBar,
                //表示此列表项使用SelfOwnMaterial来绘制
                sitUseMaterialDraw,


                //在最后面添加新的类型,因为保存到DFM中用的是整型
                //表示此列表项使用ListBox.Prop.SearchBarDesignerPanel来绘制
                sitItem4,


                //使用自定义的TSkinItem.FDrawItemDesignerPanel来绘制
                sitUseDrawItemDesignerPanel,

                sitParentItem,
                //分隔线
                sitRowDevideLine

                );






  //绑定控件是否隐藏还是显示
  TSkinAccessoryType = (satNone,
                        satMore);
                        //, satCheckmark, satDetail);




//  {$IFDEF CBUILDER}
//  ISuperObject=interface
//
//  end;
//  {$ENDIF}


  TSkinItemData=record
    Value:Variant;
    Picture:TSkinPicture;
  end;


  {$REGION 'TSkinItem 基类'}
  //多了名称、图标、Tag、ItemType、Data等属性，但是Caption、Detail这些要继承才能实现
  TSkinItem=class(TBaseSkinItem,IControlForPageFramework)
  protected
    FData:Pointer;
    FDataObject: TObject;
    FDataJsonStr:String;
//    FDataJson:ISuperObject;



    FTag:Integer;
    FTag1:Integer;

    FName:String;


    //ItemDesignerPanel的类型
    FItemType:TSkinItemType;




    FIcon:TBaseDrawPicture;
    //用这两个属性,
    //不再需要每个Item都创建一个Icon,
    //在Icon.CurrentPicture为Empty的时候使用
    FIconImageIndex:Integer;
    FIconRefPicture:TSkinPicture;




    FPic:TBaseDrawPicture;
    //用这两个属性,
    //不再需要每个Item都创建一个Pic,
    //在Pic.CurrentPicture为Empty的时候使用
    FPicImageIndex:Integer;
    FPicRefPicture:TSkinPicture;





    //颜色属性,根据ListBox.Prop.ItemColorType来决定这个Color赋给谁
    FColor:TDrawColor;


    //设置自带的数据
    procedure SetItemType(const Value: TSkinItemType);
    procedure SetWidth(const Value: Double);
    procedure SetDataObject(const Value: TObject);


//    function GetStaticIcon: TBaseDrawPicture;virtual;abstract;
//    function GetStaticPic: TBaseDrawPicture;virtual;abstract;

//    procedure SetColor(const Value: TDelphiColor);virtual;abstract;
//
//    procedure SetIconImageIndex(const Value: Integer);virtual;abstract;
//    procedure SetIconRefPicture(const Value: TSkinPicture);virtual;abstract;
//
//    procedure SetPicImageIndex(const Value: Integer);virtual;abstract;
//    procedure SetPicRefPicture(const Value: TSkinPicture);virtual;abstract;

    procedure SetColor(const Value: TDelphiColor);virtual;

    procedure SetIconImageIndex(const Value: Integer);virtual;
    procedure SetIconRefPicture(const Value: TSkinPicture);virtual;

    procedure SetPicImageIndex(const Value: Integer);virtual;
    procedure SetPicRefPicture(const Value: TSkinPicture);virtual;

    function GetIcon: TBaseDrawPicture;virtual;
    function GetPic: TBaseDrawPicture;virtual;
//
//    function GetColor: TDelphiColor;virtual;abstract;

//    function GetIconRefPicture: TSkinPicture;virtual;abstract;
//    function GetPicRefPicture: TSkinPicture;virtual;abstract;
//
//    function GetIconImageIndex: Integer;virtual;abstract;
//    function GetPicImageIndex: Integer;virtual;abstract;
    function GetColor: TDelphiColor;virtual;
//    function GetIconRefPicture: TSkinPicture;virtual;
//    function GetPicRefPicture: TSkinPicture;virtual;
//
//    function GetStaticIcon: TBaseDrawPicture;virtual;
//    function GetStaticPic: TBaseDrawPicture;virtual;
//
//    function GetIconImageIndex: Integer;virtual;
//    function GetPicImageIndex: Integer;virtual;



    procedure SetIcon(const Value: TBaseDrawPicture);virtual;
    procedure SetPic(const Value: TBaseDrawPicture);virtual;


  protected

    //获取数据的方法-需要实现
    function GetCaption: String;virtual;abstract;
    function GetDetail: String;virtual;abstract;
    function GetDetail1: String;virtual;abstract;
    function GetDetail2: String;virtual;abstract;
    function GetDetail3: String;virtual;abstract;
    function GetDetail4: String;virtual;abstract;
    function GetDetail5: String;virtual;abstract;
    function GetDetail6: String;virtual;abstract;
    function GetSubItems: TStringList;virtual;abstract;
    function GetAccessory: TSkinAccessoryType;virtual;abstract;

    //设置数据的方法-需要实现
    procedure SetCaption(const Value: String);virtual;abstract;
    procedure SetSubItems(const Value: TStringList); virtual;abstract;

    procedure SetDetail(const Value: String);virtual;abstract;
    procedure SetDetail1(const Value: String);virtual;abstract;
    procedure SetDetail2(const Value: String);virtual;abstract;
    procedure SetDetail3(const Value: String);virtual;abstract;
    procedure SetDetail4(const Value: String);virtual;abstract;
    procedure SetDetail5(const Value: String);virtual;abstract;
    procedure SetDetail6(const Value: String);virtual;abstract;
    procedure SetAccessory(const Value: TSkinAccessoryType);virtual;abstract;
  protected
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
//    function DoGetAbstractValueByBindItemField(AFieldName:String):Variant;
    //根据绑定的FieldName获取Item的值,然后赋给绑定的控件
    function GetValueTypeByBindItemField(AFieldName:String):TVarType;override;
    function GetValueByBindItemField(AFieldName:String):Variant;override;
    function GetObjectByBindItemField(AFieldName:String):TObject;override;
    procedure SetValueByBindItemField(AFieldName:String;AValue:Variant;APageDataDir:String='';AImageServerUrl:String='');override;
  public
    //IControlForPageFramework接口
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);

    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            //可以获取其他字段的值
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
//    //设置属性
//    function GetProp(APropName:String):Variant;
//    procedure SetProp(APropName:String;APropValue:Variant);
    procedure DoReturnFrame(AFromFrame:TFrame);virtual;
  public

    /// <summary>
    ///   <para>
    ///     图标更改
    ///   </para>
    ///   <para>
    ///     Icon change
    ///   </para>
    /// </summary>
    procedure DoIconChange(Sender:TObject);
    /// <summary>
    ///   <para>
    ///     图片更改
    ///   </para>
    ///   <para>
    ///     Icon change
    ///   </para>
    /// </summary>
    procedure DoPicChange(Sender:TObject);

    /// <summary>
    ///   <para>
    ///     获取图标列表
    ///   </para>
    ///   <para>
    ///     Get icon list
    ///   </para>
    /// </summary>
    procedure DoGetIconSkinImageList(Sender:TObject;var ASkinImageList:TSkinBaseImageList);virtual;

    /// <summary>
    ///   <para>
    ///     获取用于下载Item.Icon的图片下载管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoGetDownloadPictureManager(Sender:TObject;var ADownloadPictureManager:TBaseDownloadPictureManager);virtual;
  public
    constructor Create;override;
//    procedure AfterConstruction; override;
    destructor Destroy; override;
  public
    //FDataObject是否是属于自己的,释放的时候要释放它
    FIsOwnDataObject:Boolean;


    /// <summary>
    ///   <para>
    ///     用来绘制此列表项的设计面板(鼠标事件中需要使用,自动赋值,请不要设置)
    ///   </para>
    ///   <para>
    ///    ItemDesignerPanel used for Draw this ListItem (need to be used in MouseEvent)
    ///   </para>
    /// </summary>
    FDrawItemDesignerPanel: TControl;
//    //当前Item绘制所使用的风格设置
//    FDrawListItemTypeStyleSetting:TObject;
    FDrawColIndex:Integer;



    function CreateOwnDataObject(AClass:TClass):TObject;

    /// <summary>
    ///   <para>
    ///     静态的获取图标,默认FIcon不创建,调用Icon属性时如果为nil才会创建,避免占用内存
    ///   </para>
    ///   <para>
    ///     Static icon
    ///   </para>
    /// </summary>
    property StaticIcon:TBaseDrawPicture read FIcon;//GetStaticIcon;
    /// <summary>
    ///   <para>
    ///     静态的获取图片,默认FPic不创建,调用FPic属性时如果为nil才会创建,避免占用内存
    ///   </para>
    ///   <para>
    ///     Static icon
    ///   </para>
    /// </summary>
    property StaticPic:TBaseDrawPicture read FPic;//GetStaticPic;

    /// <summary>
    ///   <para>
    ///     附加数据
    ///   </para>
    ///   <para>
    ///     Additional data
    ///   </para>
    /// </summary>
    property Data:Pointer read FData write FData;
//    property DataJson:ISuperObject read FDataJson write FDataJson;
    property DataJsonStr:String read FDataJsonStr write FDataJsonStr;

    /// <summary>
    ///   <para>
    ///     附加对象
    ///   </para>
    ///   <para>
    ///     Additional object
    ///   </para>
    /// </summary>
    property DataObject:TObject read FDataObject write SetDataObject;

    /// <summary>
    ///   <para>
    ///     图标下标
    ///   </para>
    ///   <para>
    ///     Icon index
    ///   </para>
    /// </summary>
    property IconImageIndex:Integer read FIconImageIndex write SetIconImageIndex;
    /// <summary>
    ///   <para>
    ///     图片下标
    ///   </para>
    ///   <para>
    ///     Icon index
    ///   </para>
    /// </summary>
    property PicImageIndex:Integer read FPicImageIndex write SetPicImageIndex;
    /// <summary>
    ///   <para>
    ///     图标的引用
    ///   </para>
    ///   <para>
    ///     refrence picture
    ///   </para>
    /// </summary>
    property IconRefPicture:TSkinPicture read FIconRefPicture write SetIconRefPicture;
    /// <summary>
    ///   <para>
    ///    图片的引用
    ///   </para>
    ///   <para>
    ///     refrence picture
    ///   </para>
    /// </summary>
    property PicRefPicture:TSkinPicture read FPicRefPicture write SetPicRefPicture;
  public
    //启用动画,忘了用在什么时候的了?
    AnimateEnable:Boolean;
    //动画是否已经启动
    AnimateStarted:Boolean;
    //动画哪个属性
    AnimateItemBindingName:String;
    //是否第一次启动动画
    AnimateIsFirstStart:Boolean;
    AnimateIsFirstStop:Boolean;
    //动画启动时的初始时间片
    AnimateStartTicket:Integer;

    FDataRect:TRectF;

    //启用动画
    procedure StartAnimate;
    //关闭动画
    procedure StopAnimate;
  public
    //用于Items.ClearData,用于清除某项数据
//    procedure ClearData(AItemDataType:TSkinItemDataType);virtual;
    procedure ClearData(AFieldName:String);virtual;
  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);virtual;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);virtual;
  published

    /// <summary>
    ///   <para>
    ///     颜色
    ///   </para>
    ///   <para>
    ///     Color
    ///   </para>
    /// </summary>
    property Color:TDelphiColor read GetColor write SetColor;
    /// <summary>
    ///   <para>
    ///     名字
    ///   </para>
    ///   <para>
    ///     Name
    ///   </para>
    /// </summary>
    property Name: String read FName write FName;

    /// <summary>
    ///   <para>
    ///     宽度,如果为-1,表示使用列表项的默认宽度ListBox.Prop.ItemWidth
    ///   </para>
    ///   <para>
    ///     Width ,if it is -1,means use default width
    ///   </para>
    /// </summary>
    property Width:Double read GetWidth write SetWidth;

    /// <summary>
    ///   <para>
    ///     图标(延迟创建,调用Icon属性时才会创建,避免资源占用过多)
    ///   </para>
    ///   <para>
    ///     Icon(delay create)
    ///   </para>
    /// </summary>
    property Icon:TBaseDrawPicture read GetIcon write SetIcon;
    /// <summary>
    ///   <para>
    ///     图片(延迟创建,调用Pic属性时才会创建,避免资源占用过多)
    ///   </para>
    ///   <para>
    ///     Pic(delay create)
    ///   </para>
    /// </summary>
    property Pic:TBaseDrawPicture read GetPic write SetPic;

    /// <summary>
    ///   <para>
    ///     标记
    ///   </para>
    ///   <para>
    ///     Tag
    ///   </para>
    /// </summary>
    property Tag:Integer read FTag write FTag;

    /// <summary>
    ///   <para>
    ///     标记1
    ///   </para>
    ///   <para>
    ///     Tag1
    ///   </para>
    /// </summary>
    property Tag1:Integer read FTag1 write FTag1;

    /// <summary>
    ///   <para>
    ///     列表项类型(决定根据哪个ItemDesignerPanel来绘制)
    ///   </para>
    ///   <para>
    ///     ListItem type(according to which ItemDesignPanel to decide draw)
    ///   </para>
    /// </summary>
    property ItemType:TSkinItemType read FItemType write SetItemType;
  public
    //抽象属性
    /// <summary>
    ///   <para>
    ///     标题
    ///   </para>
    ///   <para>
    ///     Caption
    ///   </para>
    /// </summary>
    property Caption: String read GetCaption write SetCaption;
    /// <summary>
    ///   <para>
    ///     明细
    ///   </para>
    ///   <para>
    ///     Detail
    ///   </para>
    /// </summary>
    property Detail: String read GetDetail write SetDetail;
    /// <summary>
    ///   <para>
    ///     明细1
    ///   </para>
    ///   <para>
    ///     Detail1
    ///   </para>
    /// </summary>
    property Detail1: String read GetDetail1 write SetDetail1;
    /// <summary>
    ///   <para>
    ///     明细2
    ///   </para>
    ///   <para>
    ///     Detail2
    ///   </para>
    /// </summary>
    property Detail2: String read GetDetail2 write SetDetail2;
    /// <summary>
    ///   <para>
    ///     明细3
    ///   </para>
    ///   <para>
    ///     Detail3
    ///   </para>
    /// </summary>
    property Detail3: String read GetDetail3 write SetDetail3;
    /// <summary>
    ///   <para>
    ///     明细4
    ///   </para>
    ///   <para>
    ///     Detail4
    ///   </para>
    /// </summary>
    property Detail4: String read GetDetail4 write SetDetail4;
    /// <summary>
    ///   <para>
    ///     明细5
    ///   </para>
    ///   <para>
    ///     Detail5
    ///   </para>
    /// </summary>
    property Detail5: String read GetDetail5 write SetDetail5;
    /// <summary>
    ///   <para>
    ///     明细6
    ///   </para>
    ///   <para>
    ///     Detail6
    ///   </para>
    /// </summary>
    property Detail6: String read GetDetail6 write SetDetail6;

    /// <summary>
    ///   <para>
    ///     附加数据字符串列表
    ///   </para>
    ///   <para>
    ///     Additional data string list
    ///   </para>
    /// </summary>
    property SubItems:TStringList read GetSubItems write SetSubItems;
    //隐藏或显示绑定的控件
    property Accessory:TSkinAccessoryType read GetAccessory write SetAccessory;
 end;
  {$ENDREGION 'TSkinItem 基类'}




  {$REGION 'TSkinItems 列表项列表基类'}
  TSkinItems=class(TBaseSkinItems)
  protected
    function GetSkinItem(Index: Integer): TSkinItem;
    procedure SetSkinItem(Index: Integer; const Value: TSkinItem);
  protected
    //创建列表项
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
  public
    /// <summary>
    ///   <para>
    ///     获取指定下标的列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Items[Index:Integer]:TSkinItem read GetSkinItem write SetSkinItem;default;
  public
    /// <summary>
    ///   <para>
    ///     全部勾选
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure CheckAll;
    function IsCheckedAll:Boolean;
    /// <summary>
    ///   <para>
    ///     全部取消勾选
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure UnCheckAll;

    procedure UnSelectAll;
    procedure SelectAll;
    function IsSelectedAll:Boolean;


    /// <summary>
    ///   <para>
    ///     清除指定类型的列表项
    ///   </para>
    ///   <para>
    ///     Clear ListItem of appointed type
    ///   </para>
    /// </summary>
    procedure ClearItemsByType(AItemType:TSkinItemType);
    /// <summary>
    ///   <para>
    ///     清除除指定类型之外的列表项
    ///   </para>
    ///   <para>
    ///     Clear ListItem of beside appointed type
    ///   </para>
    /// </summary>
    procedure ClearItemsByTypeNot(AItemType:TSkinItemType);
    /// <summary>
    ///   <para>
    ///     根据Data搜索列表项
    ///   </para>
    ///   <para>
    ///     search by Data
    ///   </para>
    /// </summary>
    function FindItemByData(AData:Pointer):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据DataObject搜索列表项
    ///   </para>
    ///   <para>
    ///     Search by DataObeject
    ///   </para>
    /// </summary>
    function FindItemByDataObject(ADataObject:TObject):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据标题搜索列表项
    ///   </para>
    ///   <para>
    ///     Search by caption
    ///   </para>
    /// </summary>
    function FindItemByCaption(const ACaption:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据标题搜索列表项
    ///   </para>
    ///   <para>
    ///     Search by caption contains
    ///   </para>
    /// </summary>
    function FindItemByCaptionContains(const ASubStr:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Name搜索列表项
    ///   </para>
    ///   <para>
    ///     Search by name
    ///   </para>
    /// </summary>
    function FindItemByName(const AName:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Detail搜索列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function FindItemByDetail(const ADetail:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Detail1搜索列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function FindItemByDetail1(const ADetail1:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Detail2搜索列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function FindItemByDetail2(const ADetail2:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Detail3搜索列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function FindItemByDetail3(const ADetail3:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Detail4搜索列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function FindItemByDetail4(const ADetail4:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Detail5搜索列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function FindItemByDetail5(const ADetail5:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据Detail6搜索列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function FindItemByDetail6(const ADetail6:String):TSkinItem;
    /// <summary>
    ///   <para>
    ///     根据类型搜索列表项
    ///   </para>
    ///   <para>
    ///     Search by type
    ///   </para>
    /// </summary>
    function FindItemByType(AItemType:TSkinItemType):TSkinItem;
  public
    //用于Items.ClearData
//    procedure ClearData(AItemDataType:TSkinItemDataType);
    procedure ClearData(AFieldName:String);
  end;
  {$ENDREGION 'TSkinItems 列表项列表基类'}




  {$REGION 'TRealSkinItem 列表项对象实现类'}
  /// <summary>
  ///   <para>
  ///     列表项基类
  ///   </para>
  ///   <para>
  ///     ListItem base
  ///   </para>
  /// </summary>
  TRealSkinItem=class(TSkinItem)
  protected

    FCaption:String;
    FDetail: String;
    FDetail1: String;
    FDetail2: String;
    FDetail3: String;
    FDetail4: String;
    FDetail5: String;
    FDetail6: String;

    FSubItems:TStringList;

    //隐藏或显示绑定的控件
    FAccessory:TSkinAccessoryType;


    function GetCaption: String;override;
    function GetDetail: String;override;
    function GetDetail1: String;override;
    function GetDetail2: String;override;
    function GetDetail3: String;override;
    function GetDetail4: String;override;
    function GetDetail5: String;override;
    function GetDetail6: String;override;
    function GetSubItems: TStringList;override;
//    function GetIcon: TBaseDrawPicture;override;
//    function GetPic: TBaseDrawPicture;override;
    function GetAccessory: TSkinAccessoryType;override;


    procedure SetCaption(const Value: String);override;
    procedure SetSubItems(const Value: TStringList);override;
//    procedure SetIcon(const Value: TBaseDrawPicture);override;
//    procedure SetPic(const Value: TBaseDrawPicture);override;
    procedure SetDetail(const Value: String);override;
    procedure SetDetail1(const Value: String);override;
    procedure SetDetail2(const Value: String);override;
    procedure SetDetail3(const Value: String);override;
    procedure SetDetail4(const Value: String);override;
    procedure SetDetail5(const Value: String);override;
    procedure SetDetail6(const Value: String);override;
    procedure SetAccessory(const Value: TSkinAccessoryType);override;
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
    //根据FieldName设置获取值
    function GetValueByBindItemField(AFieldName:String):Variant;override;
    procedure SetValueByBindItemField(AFieldName:String;AValue:Variant;APageDataDir:String='';AImageServerUrl:String='');override;
  public
    //清除指定某一项的数据,通用,用于Items.ClearData
//    procedure ClearData(AItemDataType:TSkinItemDataType);override;
//    procedure ClearData(AFieldName:String);override;
  public
    destructor Destroy; override;
  published
    property Caption;
    property Detail;
    property Detail1;
    property Detail2;
    property Detail3;
    property Detail4;
    property Detail5;
    property Detail6;
    property SubItems;
    property Accessory;
  end;
  {$ENDREGION 'TRealSkinItem 列表项对象实现类'}





  {$REGION 'TIntfSkinItem 列表项接口实现类'}
  //获取列表项数据的接口
  IGetSkinItemData=interface
    ['{BEBD7C9A-43B8-4800-A050-1894F872C143}']

    function GetItemCaption: String;
    function GetItemDetail: String;
    function GetItemDetail1: String;
    function GetItemDetail2: String;
    function GetItemDetail3: String;
    function GetItemDetail4: String;
    function GetItemDetail5: String;
    function GetItemDetail6: String;

    function GetItemSubItems: TStringList;

//    function GetItemIcon: TBaseDrawPicture;
//    function GetItemPic: TBaseDrawPicture;
//
//    function GetItemColor: TDelphiColor;
    function GetItemAccessory: TSkinAccessoryType;

//    function GetItemIconRefPicture: TSkinPicture;
//    function GetItemPicRefPicture: TSkinPicture;
//
//    function GetItemIconImageIndex: Integer;
//    function GetItemPicImageIndex: Integer;
  end;





  TIntfSkinItem=class(TSkinItem)
  protected
    function GetCaption: String;override;
    function GetDetail: String;override;
    function GetDetail1: String;override;
    function GetDetail2: String;override;
    function GetDetail3: String;override;
    function GetDetail4: String;override;
    function GetDetail5: String;override;
    function GetDetail6: String;override;
    function GetSubItems: TStringList;override;
    function GetAccessory: TSkinAccessoryType;override;

//    function GetIcon: TBaseDrawPicture;override;
//    function GetPic: TBaseDrawPicture;override;
//    function GetColor: TDelphiColor;override;
//    function GetIconRefPicture: TSkinPicture;override;
//    function GetPicRefPicture: TSkinPicture;override;
//
//    function GetStaticIcon: TBaseDrawPicture;override;
//    function GetStaticPic: TBaseDrawPicture;override;
//
//    function GetIconImageIndex: Integer;override;
//    function GetPicImageIndex: Integer;override;


//    procedure SetCaption(const Value: String);override;
//    procedure SetSubItems(const Value: TStringList);override;
////    procedure SetIcon(const Value: TBaseDrawPicture);override;
////    procedure SetPic(const Value: TBaseDrawPicture);override;
//    procedure SetDetail(const Value: String);override;
//    procedure SetDetail1(const Value: String);override;
//    procedure SetDetail2(const Value: String);override;
//    procedure SetDetail3(const Value: String);override;
//    procedure SetDetail4(const Value: String);override;
//    procedure SetDetail5(const Value: String);override;
//    procedure SetDetail6(const Value: String);override;
//    procedure SetAccessory(const Value: TSkinAccessoryType);override;

//    procedure SetColor(const Value: TDelphiColor);override;
//
//    procedure SetIconImageIndex(const Value: Integer);override;
//    procedure SetIconRefPicture(const Value: TSkinPicture);override;
//
//    procedure SetPicImageIndex(const Value: Integer);override;
//    procedure SetPicRefPicture(const Value: TSkinPicture);override;
  public
    FGetSkinItemDataIntf:IGetSkinItemData;
    function GetValueByBindItemField(AFieldName:String):Variant;override;
  end;
  {$ENDREGION 'TIntfSkinItem 列表项接口实现类'}







  {$REGION 'TSkinCustomListLayoutsManager 列表项排列基类'}
  /// <summary>
  ///   <para>
  ///     列表的逻辑行为,用于排列各个列表项
  ///   </para>
  ///   <para>
  ///     Logic action of list
  ///   </para>
  /// </summary>
  TSkinCustomListLayoutsManager=class(TSkinListLayoutsManager)
  protected
//    FItems:TBaseSkinItems;
  public
//    constructor Create(AItems:TBaseSkinItems);virtual;
//    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     获取列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetVisibleItems(AIndex:Integer):TBaseSkinItem;
  end;
  {$ENDREGION 'TSkinCustomListLayoutsManager 列表项排列基类'}






  {$REGION 'TSkinVirtualListLayoutsManager 列表项排列基类'}
  /// <summary>
  ///   <para>
  ///     列表的逻辑行为,用于排列各个列表项
  ///   </para>
  ///   <para>
  ///     Logic action of list
  ///   </para>
  /// </summary>
  TSkinVirtualListLayoutsManager=class(TSkinCustomListLayoutsManager)
  public
    /// <summary>
    ///   <para>
    ///     获取列表项
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetVisibleItems(AIndex:Integer):TSkinItem;
  end;
  {$ENDREGION 'TSkinVirtualListLayoutsManager 列表项排列基类'}






  {$REGION 'TRealSkinTreeViewItem 树型节点'}
  TBaseSkinTreeViewItems=class;
  TBaseSkinTreeViewItemsClass=class of TBaseSkinTreeViewItems;

  //树型节点
  TBaseSkinTreeViewItem=class(TSkinItem,ISkinItems)
  protected
    function GetIsParent: Boolean;
    procedure SetIsParent(const Value: Boolean);
    function GetLevel: Integer;override;
    procedure SetExpanded(const Value: Boolean);
    procedure SetParent(const Value: TBaseSkinTreeViewItem);
    procedure SetChilds(const Value: TBaseSkinTreeViewItems);
  protected
    //是否展开
    FExpanded: Boolean;
    //子节点列表
    FChilds:TBaseSkinTreeViewItems;
    //是否是父节点
    FIsParent:Boolean;

    //父节点
    FParent:TBaseSkinTreeViewItem;

    function GetChildsClass:TBaseSkinTreeViewItemsClass;virtual;
  protected
    procedure ClearItemRect;override;
    //获取父节点的SkinListIntf
    function GetListLayoutsManager:TSkinListLayoutsManager;override;

    procedure AssignTo(Dest: TPersistent); override;
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
//    procedure AfterConstruction; override;
    constructor Create;override;
    destructor Destroy; override;
  public
    //用于设置器中编辑
    function GetItems:TBaseSkinItems;

    /// <summary>
    ///   <para>
    ///     级数
    ///   </para>
    ///   <para>
    ///     Level
    ///   </para>
    /// </summary>
    property Level:Integer read GetLevel;

    /// <summary>
    ///   <para>
    ///     父节点
    ///   </para>
    ///   <para>
    ///     ParentItem
    ///   </para>
    /// </summary>
    property Parent:TBaseSkinTreeViewItem read FParent write SetParent;
  published
    /// <summary>
    ///   <para>
    ///     是否是父节点
    ///   </para>
    ///   <para>
    ///     Whether is ParentItem
    ///   </para>
    /// </summary>
    property IsParent:Boolean read GetIsParent write SetIsParent;

    /// <summary>
    ///   <para>
    ///     是否展开
    ///   </para>
    ///   <para>
    ///     Whether expand
    ///   </para>
    /// </summary>
    property Expanded:Boolean read FExpanded write SetExpanded;


    /// <summary>
    ///   <para>
    ///     子节点列表
    ///   </para>
    ///   <para>
    ///     ChildItem list
    ///   </para>
    /// </summary>
    property Childs:TBaseSkinTreeViewItems read FChilds write SetChilds;
  end;




  /// <summary>
  ///   <para>
  ///     树型节点列表
  ///   </para>
  ///   <para>
  ///     ItemList
  ///   </para>
  /// </summary>
  TBaseSkinTreeViewItems=class(TSkinItems)
  private
    FParent:TBaseSkinTreeViewItem;
    function GetRootOwner:TBaseSkinTreeViewItems;
    function GetItem(Index: Integer): TBaseSkinTreeViewItem;
    procedure SetItem(Index: Integer; const Value: TBaseSkinTreeViewItem);
  protected
    //调用Root.Delete,反馈给VirtualList调用它的DoItemDelete
    procedure DoDelete(AObject:TObject;AIndex:Integer);override;

    function GetListLayoutsManager:TSkinListLayoutsManager;override;

  protected
    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
  public
    constructor Create(AParent:TBaseSkinTreeViewItem;
                      AObjectOwnership:TObjectOwnership=ooOwned;
                      CreateObjectChange:Boolean=True);
  public
    /// <summary>
    ///   <para>
    ///     添加节点
    ///   </para>
    ///   <para>
    ///     Add item
    ///   </para>
    /// </summary>
    function Add:TBaseSkinTreeViewItem;overload;
    /// <summary>
    ///   <para>
    ///     插入节点
    ///   </para>
    ///   <para>
    ///     Insert item
    ///   </para>
    /// </summary>
    function Insert(Index:Integer):TBaseSkinTreeViewItem;
    /// <summary>
    ///   <para>
    ///     节点数组
    ///   </para>
    ///   <para>
    ///     Item array
    ///   </para>
    /// </summary>
    property Items[Index:Integer]:TBaseSkinTreeViewItem read GetItem write SetItem;default;

    /// <summary>
    ///   <para>
    ///     父节点
    ///   </para>
    ///   <para>
    ///     Parent Item
    ///   </para>
    /// </summary>
    property Parent:TBaseSkinTreeViewItem read FParent;
  public
    /// <summary>
    ///   <para>
    ///     设置所有节点的展开状态
    ///   </para>
    ///   <para>
    ///     Set all items' expand state
    ///   </para>
    /// </summary>
    procedure SetTreeViewItemsAllExpandState(ATreeViewItems:TBaseSkinTreeViewItems;State:Boolean;Level:Integer);
    /// <summary>
    ///   <para>
    ///     设置所有节点的展开状态
    ///   </para>
    ///   <para>
    ///     Set all Items' expand state
    ///   </para>
    /// </summary>
    procedure SetAllExpandState(State:Boolean;Level:Integer);

    /// <summary>
    ///   <para>
    ///     展开到第几层
    ///   </para>
    ///   <para>
    ///     Expand to which level
    ///   </para>
    /// </summary>
    procedure ExpanedAll(Level:Integer=-1);

    /// <summary>
    ///   <para>
    ///     收拢几层以下
    ///   </para>
    ///   <para>
    ///     Collapse to which level
    ///   </para>
    /// </summary>
    procedure CollapseAll(Level:Integer=-1);
//  public
//    //搜索
//    function FindItemByData(const Data:Pointer):TBaseSkinTreeViewItem;overload;
//    function FindItemByCaption(const Caption:String):TBaseSkinTreeViewItem;overload;
//    function FindItemByName(const Name:String):TBaseSkinTreeViewItem;overload;
  end;





  TRealSkinTreeViewItems=class;
  TRealSkinTreeViewItem=class(TBaseSkinTreeViewItem)
  protected

    FCaption:String;
    FDetail: String;
    FDetail1: String;
    FDetail2: String;
    FDetail3: String;
    FDetail4: String;
    FDetail5: String;
    FDetail6: String;

    FSubItems:TStringList;

    //隐藏或显示绑定的控件
    FAccessory:TSkinAccessoryType;


    function GetCaption: String;override;
    function GetDetail: String;override;
    function GetDetail1: String;override;
    function GetDetail2: String;override;
    function GetDetail3: String;override;
    function GetDetail4: String;override;
    function GetDetail5: String;override;
    function GetDetail6: String;override;
    function GetSubItems: TStringList;override;
//    function GetIcon: TBaseDrawPicture;override;
//    function GetPic: TBaseDrawPicture;override;
    function GetAccessory: TSkinAccessoryType;override;


    procedure SetCaption(const Value: String);override;
    procedure SetSubItems(const Value: TStringList);override;
//    procedure SetIcon(const Value: TBaseDrawPicture);override;
//    procedure SetPic(const Value: TBaseDrawPicture);override;
    procedure SetDetail(const Value: String);override;
    procedure SetDetail1(const Value: String);override;
    procedure SetDetail2(const Value: String);override;
    procedure SetDetail3(const Value: String);override;
    procedure SetDetail4(const Value: String);override;
    procedure SetDetail5(const Value: String);override;
    procedure SetDetail6(const Value: String);override;
    procedure SetAccessory(const Value: TSkinAccessoryType);override;
  private
    FJsonStr: String;
    FJson:ISuperObject;

    function GetChildsClass:TBaseSkinTreeViewItemsClass;override;
    function GetChilds: TRealSkinTreeViewItems;
    procedure SetChilds(const Value: TRealSkinTreeViewItems);
    procedure SetJsonStr(const Value: String);
    property JsonStr:String read FJsonStr write SetJsonStr;
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
    function GetValueByBindItemField(AFieldName:String):Variant;override;
    procedure SetValueByBindItemField(AFieldName: String;AValue: Variant;APageDataDir:String='';AImageServerUrl:String='');override;
  public
    //清除指定某一项的数据,通用,用于Items.ClearData
//    procedure ClearData(AItemDataType:TSkinItemDataType);override;
//    procedure ClearData(AFieldName:String);override;
  public
//    constructor Create; override;
    destructor Destroy; override;
  published
    property Caption;
    property Detail;
    property Detail1;
    property Detail2;
    property Detail3;
    property Detail4;
    property Detail5;
    property Detail6;
    property SubItems;
    property Accessory;

    property Childs:TRealSkinTreeViewItems read GetChilds write SetChilds;
  end;


  TDesignTimeRealSkinTreeViewItem=class(TRealSkinTreeViewItem)
  published
    property JsonStr;//:String read FJsonStr write SetJsonStr;
  end;


  /// <summary>
  ///   <para>
  ///     树型节点列表
  ///   </para>
  ///   <para>
  ///     ItemList
  ///   </para>
  /// </summary>
  TRealSkinTreeViewItems=class(TBaseSkinTreeViewItems)
  private
//    FParent:TRealSkinTreeViewItem;
//    function GetRootOwner:TRealSkinTreeViewItems;
    function GetItem(Index: Integer): TRealSkinTreeViewItem;
    procedure SetItem(Index: Integer; const Value: TRealSkinTreeViewItem);
//  protected
//    //调用Root.Delete,反馈给VirtualList调用它的DoItemDelete
//    procedure DoDelete(AObject:TObject;AIndex:Integer);override;
//
//    function GetListLayoutsManager:TSkinListLayoutsManager;override;
  protected
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
//  public
//    constructor Create(AParent:TRealSkinTreeViewItem;
//                      AObjectOwnership:TObjectOwnership=ooOwned;
//                      CreateObjectChange:Boolean=True);
  public
    /// <summary>
    ///   <para>
    ///     添加节点
    ///   </para>
    ///   <para>
    ///     Add item
    ///   </para>
    /// </summary>
    function Add:TRealSkinTreeViewItem;overload;
    /// <summary>
    ///   <para>
    ///     插入节点
    ///   </para>
    ///   <para>
    ///     Insert item
    ///   </para>
    /// </summary>
    function Insert(Index:Integer):TRealSkinTreeViewItem;
    /// <summary>
    ///   <para>
    ///     节点数组
    ///   </para>
    ///   <para>
    ///     Item array
    ///   </para>
    /// </summary>
    property Items[Index:Integer]:TRealSkinTreeViewItem read GetItem write SetItem;default;

//    /// <summary>
//    ///   <para>
//    ///     父节点
//    ///   </para>
//    ///   <para>
//    ///     Parent Item
//    ///   </para>
//    /// </summary>
//    property Parent:TRealSkinTreeViewItem read FParent;
//  public
//    /// <summary>
//    ///   <para>
//    ///     设置所有节点的展开状态
//    ///   </para>
//    ///   <para>
//    ///     Set all items' expand state
//    ///   </para>
//    /// </summary>
//    procedure SetTreeViewItemsAllExpandState(ATreeViewItems:TRealSkinTreeViewItems;State:Boolean;Level:Integer);
//    /// <summary>
//    ///   <para>
//    ///     设置所有节点的展开状态
//    ///   </para>
//    ///   <para>
//    ///     Set all Items' expand state
//    ///   </para>
//    /// </summary>
//    procedure SetAllExpandState(State:Boolean;Level:Integer);
//
//    /// <summary>
//    ///   <para>
//    ///     展开到第几层
//    ///   </para>
//    ///   <para>
//    ///     Expand to which level
//    ///   </para>
//    /// </summary>
//    procedure ExpanedAll(Level:Integer=-1);
//
//    /// <summary>
//    ///   <para>
//    ///     收拢几层以下
//    ///   </para>
//    ///   <para>
//    ///     Collapse to which level
//    ///   </para>
//    /// </summary>
//    procedure CollapseAll(Level:Integer=-1);
  public
    //搜索
    function FindItemByData(const Data:Pointer):TRealSkinTreeViewItem;overload;
    function FindItemByCaption(const Caption:String):TRealSkinTreeViewItem;overload;
    function FindItemByName(const Name:String):TRealSkinTreeViewItem;overload;
  end;





//  //树型节点
//  TRealSkinTreeViewItem=class(TRealSkinItem,ISkinItems)
//  protected
//    function GetIsParent: Boolean;
//    procedure SetIsParent(const Value: Boolean);
//    function GetLevel: Integer;
//    procedure SetExpanded(const Value: Boolean);
//    procedure SetParent(const Value: TRealSkinTreeViewItem);
//    procedure SetChilds(const Value: TRealSkinTreeViewItems);
//  protected
//    //是否展开
//    FExpanded: Boolean;
//    //子节点列表
//    FChilds:TRealSkinTreeViewItems;
//    //是否是父节点
//    FIsParent:Boolean;
//
//    //父节点
//    FParent:TRealSkinTreeViewItem;
//
//
//  protected
//    procedure ClearItemRect;override;
//    //获取父节点的SkinListIntf
//    function GetListLayoutsManager:TSkinListLayoutsManager;override;
//
//    procedure AssignTo(Dest: TPersistent); override;
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//  public
//    constructor Create(AOwner: TBaseSkinItems);override;
//    destructor Destroy; override;
//  public
//    //用于设置器中编辑
//    function GetItems:TBaseSkinItems;
//
//    /// <summary>
//    ///   <para>
//    ///     级数
//    ///   </para>
//    ///   <para>
//    ///     Level
//    ///   </para>
//    /// </summary>
//    property Level:Integer read GetLevel;
//
//    /// <summary>
//    ///   <para>
//    ///     父节点
//    ///   </para>
//    ///   <para>
//    ///     ParentItem
//    ///   </para>
//    /// </summary>
//    property Parent:TRealSkinTreeViewItem read FParent write SetParent;
//  published
//    /// <summary>
//    ///   <para>
//    ///     是否是父节点
//    ///   </para>
//    ///   <para>
//    ///     Whether is ParentItem
//    ///   </para>
//    /// </summary>
//    property IsParent:Boolean read GetIsParent write SetIsParent;
//
//    /// <summary>
//    ///   <para>
//    ///     是否展开
//    ///   </para>
//    ///   <para>
//    ///     Whether expand
//    ///   </para>
//    /// </summary>
//    property Expanded:Boolean read FExpanded write SetExpanded;
//
//
//    /// <summary>
//    ///   <para>
//    ///     子节点列表
//    ///   </para>
//    ///   <para>
//    ///     ChildItem list
//    ///   </para>
//    /// </summary>
//    property Childs:TRealSkinTreeViewItems read FChilds write SetChilds;
//  end;










  TSkinTreeViewLayoutsManager=class(TSkinVirtualListLayoutsManager)
  private
    FParentItemHeight: TControlSize;

    FLevelLeftOffset: TControlSize;
    FLevelRightIsFitControlWidth:Boolean;

    //计算显示列表
    procedure DoCalcVisibleItems(AItems: TBaseSkinTreeViewItems);

    procedure SetLevelLeftOffset(const Value: TControlSize);
    procedure SetParentItemHeight(const Value: TControlSize);
    procedure SetLevelRightIsFitControlWidth(const Value: Boolean);
  protected
    //计算显示的列表
    procedure CalcVisibleItems;override;

    //右偏移固定
    function CalcItemWidth(AItem:ISkinItem):Double;override;
    function CalcItemHeight(AItem:ISkinItem):Double;override;
    function CalcItemLevelLeftOffsetAtVerticalLayout(AItem:ISkinItem):Double;override;
    function CalcItemLevelRightIsFitControlWidthAtVerticalLayout:Boolean;
  public
    constructor Create(ASkinList:ISkinList);override;
    destructor Destroy;override;
  public

    /// <summary>
    ///   <para>
    ///     计算出所有节点列表
    ///   </para>
    ///   <para>
    ///     Calculate all ItemList
    ///   </para>
    /// </summary>
    procedure DoCalcAllItems(AllItems:TBaseList;AItems: TBaseSkinTreeViewItems);
//    /// <summary>
//    ///   <para>
//    ///     获取显示的节点列表
//    ///   </para>
//    ///   <para>
//    ///     Get visible ItemList
//    ///   </para>
//    /// </summary>
//    function GetVisibleItems:TSkinBaseItems;override;


    /// <summary>
    ///   <para>
    ///     层级左偏移
    ///   </para>
    ///   <para>
    ///     Level Offset horizontally
    ///   </para>
    /// </summary>
    property LevelLeftOffset:TControlSize read FLevelLeftOffset write SetLevelLeftOffset;
    //层级右偏移固定
    property LevelRightIsFitControlWidth:Boolean read FLevelRightIsFitControlWidth write SetLevelRightIsFitControlWidth;

    /// <summary>
    ///   <para>
    ///     父节点的高度
    ///   </para>
    ///   <para>
    ///     ParentItem height
    ///   </para>
    /// </summary>
    property ParentItemHeight:TControlSize read FParentItemHeight write SetParentItemHeight;
  end;
  {$ENDREGION 'TRealSkinTreeViewItem 树型节点'}



  //用于在加载含有不同类型TSkinItem时
  //比如TSkinItems中同时含有TRealSkinItem和TJsonSkinItem
  TSkinItemClassItem=class
  public
//    ClassName:String;
    SkinItemClass:TBaseSkinItemClass;
  end;










////编辑时获取文本,
////获取单元格的绘制文本
//function GetItemDataText(AItem:TSkinItem;
//            AItemDataType:TSkinItemDataType;
//            ASubItemsIndex:Integer):String;
//
////根据绑定控件把编辑后的值赋回给编辑Item
//procedure SetItemValueByItemDataType(AItem:TSkinItem;
//            AItemDataType:TSkinItemDataType;
//            ASubItemsIndex:Integer;
//            const Value:Variant);



//根据ItemCaption获取idtCaption,用于页面框架
//function GetItemDataType(AItemDataTypeName:String):TSkinItemDataType;


//var
//  GlobalSkinItemDataJsonObject:TClass;
var
  GlobalSkinItemClasses:TBaseList;
//  GlobalDrawPictureRecrod:TDrawPictureRecrod;


procedure RegisterSkinItemClass(ASkinItemClass:TBaseSkinItemClass);
function FindSkinItemClass(ASkinItemClassName:String):TBaseSkinItemClass;
function GetGlobalSkinItemClasses:TBaseList;


implementation

uses
  uSkinImageType;

function GetGlobalSkinItemClasses:TBaseList;
begin
  if GlobalSkinItemClasses=nil then
  begin
    GlobalSkinItemClasses:=TBaseList.Create;
  end;
  Result:=GlobalSkinItemClasses;
end;

procedure RegisterSkinItemClass(ASkinItemClass:TBaseSkinItemClass);
var
  ASkinItemClassItem:TSkinItemClassItem;
begin
  ASkinItemClassItem:=TSkinItemClassItem.Create;
//  ASkinItemClassItem.ClassName:=ASkinItemClass.ClassName;
  ASkinItemClassItem.SkinItemClass:=ASkinItemClass;

  GetGlobalSkinItemClasses.Add(ASkinItemClassItem);
end;

function FindSkinItemClass(ASkinItemClassName:String):TBaseSkinItemClass;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to GlobalSkinItemClasses.Count-1 do
  begin
    if TSkinItemClassItem(GlobalSkinItemClasses[I]).SkinItemClass.ClassName=ASkinItemClassName then
    begin
      Result:=TSkinItemClassItem(GlobalSkinItemClasses[I]).SkinItemClass;
      Break;
    end;
  end;
end;

//function GetItemDataType(AItemDataTypeName:String):TSkinItemDataType;
//begin
//  Result:=idtNone;
//  if SameText(AItemDataTypeName,'ItemCaption') then Result:=idtCaption;
//
//  if SameText(AItemDataTypeName,'ItemDetail') then Result:=idtDetail;
//  if SameText(AItemDataTypeName,'ItemDetail1') then Result:=idtDetail1;
//  if SameText(AItemDataTypeName,'ItemDetail2') then Result:=idtDetail2;
//  if SameText(AItemDataTypeName,'ItemDetail3') then Result:=idtDetail3;
//  if SameText(AItemDataTypeName,'ItemDetail4') then Result:=idtDetail4;
//  if SameText(AItemDataTypeName,'ItemDetail5') then Result:=idtDetail5;
//  if SameText(AItemDataTypeName,'ItemDetail6') then Result:=idtDetail6;
//
//  if SameText(AItemDataTypeName,'ItemIcon') then Result:=idtIcon;
//  if SameText(AItemDataTypeName,'ItemPic') then Result:=idtPic;
//
//  if SameText(AItemDataTypeName,'ItemChecked') then Result:=idtChecked;
//  if SameText(AItemDataTypeName,'ItemSelected') then Result:=idtSelected;
//  if SameText(AItemDataTypeName,'ItemAccessory') then Result:=idtAccessory;
//
//  if SameText(AItemDataTypeName,'ItemSubItems') then Result:=idtSubItems;
//
//end;
//
//procedure SetItemValueByItemDataType(
//                                    AItem:TSkinItem;
//                                    AItemDataType:TSkinItemDataType;
//                                    ASubItemsIndex:Integer;
//                                    const Value:Variant);
//var
//  I: Integer;
//begin
//  case AItemDataType of
//
//    idtIcon: AItem.Icon.Url:=Value;
//    idtPic: AItem.Pic.Url:=Value;
//
//    idtChecked: AItem.Checked:=Value;
//    idtSelected: AItem.Selected:=Value;
//    idtAccessory: AItem.Accessory:=Value;
//
//    idtCaption: AItem.Caption:=Value;
//    idtDetail: AItem.Detail:=Value;
//    idtDetail1: AItem.Detail1:=Value;
//    idtDetail2: AItem.Detail2:=Value;
//    idtDetail3: AItem.Detail3:=Value;
//    idtDetail4: AItem.Detail4:=Value;
//    idtDetail5: AItem.Detail5:=Value;
//    idtDetail6: AItem.Detail6:=Value;
//
//    idtSubItems:
//    begin
//
//        //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
//        //自动补齐
//        if (ASubItemsIndex>-1) and (ASubItemsIndex<AItem.SubItems.Count) then
//        begin
//            AItem.SubItems[ASubItemsIndex]:=Value;
//        end
//        else if ASubItemsIndex>=AItem.SubItems.Count then
//        begin
//            for I := 0 to ASubItemsIndex-AItem.SubItems.Count-1 do
//            begin
//              AItem.SubItems.Add('');
//            end;
//            AItem.SubItems.Add(Value);
//        end;
//
//    end;
//  end;
//
//end;
//
//function GetItemDataText(AItem:TSkinItem;
//                          AItemDataType: TSkinItemDataType;
//                          ASubItemsIndex:Integer): String;
//begin
//  Result:='';
//  case AItemDataType of
//    idtCaption: Result:=AItem.Caption;
//    idtDetail: Result:=AItem.Detail;
//    idtDetail1: Result:=AItem.Detail1;
//    idtDetail2: Result:=AItem.Detail2;
//    idtDetail3: Result:=AItem.Detail3;
//    idtDetail4: Result:=AItem.Detail4;
//    idtDetail5: Result:=AItem.Detail5;
//    idtDetail6: Result:=AItem.Detail6;
//
//    idtSubItems:
//    begin
//      if (ASubItemsIndex>=0)
//        and (ASubItemsIndex<AItem.SubItems.Count) then
//      begin
//        Result:=AItem.SubItems[ASubItemsIndex];
//      end;
//    end;
//  end;
//end;
//




{ TSkinItems }

function TSkinItems.GetSkinItem(Index: Integer): TSkinItem;
begin
  Result:=TSkinItem(Inherited Items[Index]);
end;

function TSkinItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TSkinItem;
end;

//procedure TSkinItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TSkinItem;
//end;

function TSkinItems.IsCheckedAll: Boolean;
var
  I: Integer;
begin
  Result:=True;
  for I := 0 to Count-1 do
  begin
    if Not Items[I].FChecked then
    begin
      Result:=False;
      Break;
    end;
  end;
end;

function TSkinItems.IsSelectedAll: Boolean;
var
  I: Integer;
begin
  Result:=True;
  for I := 0 to Count-1 do
  begin
    if Not Items[I].FSelected then
    begin
      Result:=False;
      Break;
    end;
  end;
end;

procedure TSkinItems.SetSkinItem(Index: Integer;const Value: TSkinItem);
begin
  Inherited Items[Index]:=Value;
end;

procedure TSkinItems.UnCheckAll;
var
  I: Integer;
begin
  Self.BeginUpdate;
  try
    for I := 0 to Count-1 do
    begin
      if Items[I].FChecked then
      begin
        Items[I].Checked:=False;
      end;
    end;
  finally
    Self.EndUpdate();
  end;
end;

procedure TSkinItems.UnSelectAll;
var
  I: Integer;
begin
  Self.BeginUpdate;
  try
    for I := 0 to Count-1 do
    begin
      if Items[I].FSelected then
      begin
        Items[I].Selected:=False;
      end;
    end;
  finally
    Self.EndUpdate();
  end;
end;

procedure TSkinItems.CheckAll;
var
  I: Integer;
begin
  Self.BeginUpdate;
  try
    for I := 0 to Count-1 do
    begin
      if Not Items[I].FChecked then
      begin
        Items[I].Checked:=True;
      end;
    end;
  finally
    Self.EndUpdate();
  end;
end;

procedure TSkinItems.SelectAll;
var
  I: Integer;
begin
  Self.BeginUpdate;
  try
    for I := 0 to Count-1 do
    begin
      if Not Items[I].FSelected then
      begin
        Items[I].Selected:=True;
      end;
    end;
  finally
    Self.EndUpdate();
  end;
end;

procedure TSkinItems.ClearData(AFieldName: String);
var
  I:Integer;
begin
  Self.BeginUpdate;
  try
    for I := Self.Count-1 downto 0 do
    begin
      Self.Items[I].ClearData(AFieldName);
    end;
  finally
    Self.EndUpdate();
  end;
end;

//procedure TSkinItems.ClearData(AItemDataType: TSkinItemDataType);
//var
//  I:Integer;
//begin
//  Self.BeginUpdate;
//  try
//    for I := Self.Count-1 downto 0 do
//    begin
//      Self.Items[I].ClearData(AItemDataType);
//    end;
//  finally
//    Self.EndUpdate();
//  end;
//end;

procedure TSkinItems.ClearItemsByType(AItemType: TSkinItemType);
var
  I:Integer;
begin
  Self.BeginUpdate;
  try
    for I := Self.Count-1 downto 0 do
    begin
      if Self.Items[I].ItemType=AItemType then
      begin
        Self.Delete(I);
      end;
    end;
  finally
    Self.EndUpdate();
  end;
end;

procedure TSkinItems.ClearItemsByTypeNot(AItemType: TSkinItemType);
var
  I:Integer;
begin
  Self.BeginUpdate;
  try
    for I := Self.Count-1 downto 0 do
    begin
      if Self.Items[I].ItemType<>AItemType then
      begin
        Self.Delete(I);
      end;
    end;
  finally
    Self.EndUpdate();
  end;
end;

//function TSkinItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=SkinItemClass.Create;//(Self);
//end;

function TSkinItems.FindItemByCaption(const ACaption: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Caption=ACaption then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByCaptionContains(const ASubStr: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if NewDelphiStringIndexOf(ASubStr,Items[I].Caption) then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByName(const AName: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Name=AName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDetail(const ADetail: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Detail=ADetail then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDetail1(const ADetail1: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Detail1=ADetail1 then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDetail2(const ADetail2: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Detail2=ADetail2 then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDetail3(const ADetail3: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Detail3=ADetail3 then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDetail4(const ADetail4: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Detail4=ADetail4 then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDetail5(const ADetail5: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Detail5=ADetail5 then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDetail6(const ADetail6: String): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Detail6=ADetail6 then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByType(AItemType: TSkinItemType): TSkinItem;
var
  I: Integer;
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

function TSkinItems.FindItemByData(AData: Pointer): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Data=AData then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItems.FindItemByDataObject(ADataObject: TObject): TSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].DataObject=ADataObject then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

{ TBaseSkinItems }

function TBaseSkinItems.GetBaseSkinItem(Index: Integer): TBaseSkinItem;
begin
  Result:=TBaseSkinItem(Inherited Items[Index]);
end;

function TBaseSkinItems.GetSkinItem(const Index: Integer): ISkinItem;
begin
  Result:=Items[Index] as ISkinItem;
end;

function TBaseSkinItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TBaseSkinItem;
end;

function TBaseSkinItems.GetSkinObject(const Index: Integer): TObject;
begin
  Result:=Items[Index];
end;

function TBaseSkinItems.GetListLayoutsManager: TSkinListLayoutsManager;
begin
  Result:=FListLayoutsManager;
end;

function TBaseSkinItems.GetObject: TObject;
begin
  Result:=Self;
end;

function TBaseSkinItems.SelectedCount: Integer;
var
  I: Integer;
begin
  Result:=0;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Selected then
    begin
      Inc(Result);
    end;
  end;
end;

function TBaseSkinItems.SelectedList: TBaseList;
var
  I: Integer;
begin
  Result:=TBaseList.Create(ooReference);
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Selected then
    begin
      Result.Add(Items[I]);
    end;
  end;
end;

procedure TBaseSkinItems.SetBaseSkinItem(Index: Integer;const Value: TBaseSkinItem);
begin
  Inherited Items[Index]:=Value;
end;

procedure TBaseSkinItems.SetListLayoutsManager(ALayoutsManager: TSkinListLayoutsManager);
begin
  FListLayoutsManager:=ALayoutsManager;
end;

procedure TBaseSkinItems.Sort(Compare: TListSortCompare);
begin
  BeginUpdate;
  try
    Self.FItems.Sort(Compare);
  finally
    //需要重新计算可视的列表
    if GetListLayoutsManager<>nil then
    begin
      Self.GetListLayoutsManager.DoItemVisibleChange(nil,False);
    end;
    //刷新
    EndUpdate(True);
  end;
end;

function TBaseSkinItems.GetUpdateCount: Integer;
begin
  Result:=0;
  if (Self.FSkinObjectChangeManager<>nil) then
  begin
    Result:=Self.FSkinObjectChangeManager.UpdateCount;
  end;
end;

//procedure TBaseSkinItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TBaseSkinItem;
//end;

procedure TBaseSkinItems.BeginUpdate;
begin
  inherited;
end;

procedure TBaseSkinItems.DoChange;
begin
  inherited;

  if //Not IsLoading
    //and
    (FSkinObjectChangeManager<>nil)
    and not FSkinObjectChangeManager.IsDestroy then
  begin
    if (ictAdd in Self.FLastItemChangeTypes)
      or (ictDel in Self.FLastItemChangeTypes)
      or (ictMove in Self.FLastItemChangeTypes)
      then
    begin
      if GetListLayoutsManager<>nil then
      begin
        Self.GetListLayoutsManager.DoItemVisibleChange(nil);
      end;
    end;
  end;

end;

constructor TBaseSkinItems.Create(const AObjectOwnership: TObjectOwnership;
  const AIsCreateObjectChangeManager: Boolean);
begin
  SkinItemClass:=GetSkinItemClass;

  inherited;

end;

function TBaseSkinItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
var
  ASkinItemClass:TBaseSkinItemClass;
begin

  if AClassName<>'' then
  begin
    ASkinItemClass:=FindSkinItemClass(AClassName);
    if ASkinItemClass<>nil then
    begin
      Result:=ASkinItemClass.Create;
    end;
  end
  else
  begin
    Result:=SkinItemClass.Create;//(Self);
  end;
end;

procedure TBaseSkinItems.DoAdd(AObject: TObject);
begin
  inherited;

  TBaseSkinItem(AObject).Owner:=Self;
//  TBaseSkinItem(AObject).FOwner:=Self;
//  TBaseSkinItem(AObject).SetSkinListIntf(Self);


  {$IFDEF FREE_VERSION}
  if Count=600 then
  begin
    ShowMessage('OrangeUI免费版限制(列表控件只能600条记录数)');
  end;
  {$ENDIF}
  

end;

procedure TBaseSkinItems.DoInsert(AObject: TObject; AIndex: Integer);
begin
  inherited;

  TBaseSkinItem(AObject).Owner:=Self;
//  TBaseSkinItem(AObject).FOwner:=Self;
//  TBaseSkinItem(AObject).SetSkinListIntf(Self);
end;

procedure TBaseSkinItems.DoDelete(AObject: TObject; AIndex: Integer);
begin

  //删除的时候清除Owner
  if AObject<>nil then
  begin
    TBaseSkinItem(AObject).Owner:=nil;
//    TBaseSkinItem(AObject).FOwner:=nil;
//    TBaseSkinItem(AObject).SetSkinListIntf(nil);
  end;

  inherited;
end;

procedure TBaseSkinItems.EndUpdate(AIsForce:Boolean);
var
  AIsDoItemVisibleChange:Boolean;
begin
  AIsDoItemVisibleChange:=False;

  if (ictAdd in Self.FLastItemChangeTypes)
    or (ictDel in Self.FLastItemChangeTypes)
    or (ictMove in Self.FLastItemChangeTypes)
    then
  begin
    //需要重新排列列表项
    AIsDoItemVisibleChange:=True;
  end;

  inherited EndUpdate(AIsForce);


  //判断列表项是否改变过大小再调用
  //万一有Item的Visible更改过了,也需要调用的
  if GetListLayoutsManager<>nil then
  begin
    Self.GetListLayoutsManager.DoItemVisibleChange(nil,not AIsDoItemVisibleChange);
    Self.GetListLayoutsManager.DoItemPropChange(nil);
  end;

end;

function TBaseSkinItems.GetItems: TBaseSkinItems;
begin
  Result:=Self;
end;


{ TSkinCustomListLayoutsManager }

function TSkinCustomListLayoutsManager.GetVisibleItems(AIndex:Integer):TBaseSkinItem;
begin
  Result:=TBaseSkinItem(Self.GetVisibleItemObject(AIndex));
end;

//constructor TSkinCustomListLayoutsManager.Create(AItems:TBaseSkinItems);
//begin
//  Inherited Create(AItems);
//
//  FItems:=AItems;
//end;
//
//destructor TSkinCustomListLayoutsManager.Destroy;
//begin
//  Inherited;
//end;


{ TSkinVirtualListLayoutsManager }

function TSkinVirtualListLayoutsManager.GetVisibleItems(AIndex:Integer):TSkinItem;
begin
  Result:=TSkinItem(Self.GetVisibleItemObject(AIndex));
end;





{ TRealSkinItem }

procedure TRealSkinItem.AssignTo(Dest: TPersistent);
var
  DestObject:TRealSkinItem;
begin
  if Dest is TRealSkinItem then
  begin

    DestObject:=Dest as TRealSkinItem;

    DestObject.FCaption:=Self.FCaption;

    DestObject.FAccessory:=Self.FAccessory;
    if Self.FSubItems=nil then
    begin
      FreeAndNil(DestObject.FSubItems);
    end
    else
    begin
      DestObject.SubItems.Assign(Self.FSubItems);
    end;


    DestObject.FDetail:=Self.FDetail;
    DestObject.FDetail1:=Self.FDetail1;
    DestObject.FDetail2:=Self.FDetail2;
    DestObject.FDetail3:=Self.FDetail3;
    DestObject.FDetail4:=Self.FDetail4;
    DestObject.FDetail5:=Self.FDetail5;
    DestObject.FDetail6:=Self.FDetail6;

    //inherited里面已经有了DestObject.DoPropChange;
    inherited;

  end
  else
  begin
    inherited;
  end;
end;

//procedure TRealSkinItem.ClearData(AFieldName:String);
//begin
//  Self.SetValueByBindItemField(AFieldName,'');
//
////  case AItemDataType of
////    idtNone: ;
////    idtCaption: Self.FCaption:='';
////
////
//////    idtIcon: if Self.FIcon<>nil then FIcon.Clear;
//////    idtPic: if Self.FPic<>nil then FPic.Clear;
//////    idtChecked: Self.FChecked:=False;
//////    idtSelected: Self.FSelected:=False;
////
////
////    idtAccessory: Self.FAccessory:=TSkinAccessoryType.satNone;
////    idtDetail: Self.FDetail:='';
////    idtDetail1: Self.FDetail1:='';
////    idtDetail2: Self.FDetail2:='';
////    idtDetail3: Self.FDetail3:='';
////    idtDetail4: Self.FDetail4:='';
////    idtDetail5: Self.FDetail5:='';
////    idtDetail6: Self.FDetail6:='';
////    idtSubItems: Self.SubItems.Clear;
////  end;
//
//end;

//procedure TRealSkinItem.ClearData(AItemDataType:TSkinItemDataType);
//begin
//  case AItemDataType of
//    idtNone: ;
//    idtCaption: Self.FCaption:='';
//
//
////    idtIcon: if Self.FIcon<>nil then FIcon.Clear;
////    idtPic: if Self.FPic<>nil then FPic.Clear;
////    idtChecked: Self.FChecked:=False;
////    idtSelected: Self.FSelected:=False;
//
//
//    idtAccessory: Self.FAccessory:=TSkinAccessoryType.satNone;
//    idtDetail: Self.FDetail:='';
//    idtDetail1: Self.FDetail1:='';
//    idtDetail2: Self.FDetail2:='';
//    idtDetail3: Self.FDetail3:='';
//    idtDetail4: Self.FDetail4:='';
//    idtDetail5: Self.FDetail5:='';
//    idtDetail6: Self.FDetail6:='';
//    idtSubItems: Self.SubItems.Clear;
//  end;
//
//end;

destructor TRealSkinItem.Destroy;
begin
  FreeAndNil(FSubItems);

  inherited;
end;

function TRealSkinItem.GetAccessory: TSkinAccessoryType;
begin
  Result:=FAccessory;
end;

function TRealSkinItem.GetCaption: String;
begin
  Result:=FCaption;
end;

function TRealSkinItem.GetDetail: String;
begin
  Result:=FDetail;
end;

function TRealSkinItem.GetDetail1: String;
begin
  Result:=FDetail1;
end;

function TRealSkinItem.GetDetail2: String;
begin
  Result:=FDetail2;
end;

function TRealSkinItem.GetDetail3: String;
begin
  Result:=FDetail3;
end;

function TRealSkinItem.GetDetail4: String;
begin
  Result:=FDetail4;
end;

function TRealSkinItem.GetDetail5: String;
begin
  Result:=FDetail5;
end;

function TRealSkinItem.GetDetail6: String;
begin
  Result:=FDetail6;
end;

function TRealSkinItem.GetSubItems: TStringList;
begin
  if FSubItems=nil then
  begin
    FSubItems:=TStringList.Create;
  end;
  Result:=FSubItems;
end;

function GetValueByBindItemSubItems(ASubItems:TStringList;AFieldName:String):Variant;
var
  ASubItemsIndexStr:String;
  ASubItemsIndex:Integer;
begin
  ASubItemsIndex:=-1;

  {$IF CompilerVersion >= 30.0}
  ASubItemsIndexStr:=AFieldName.Substring(12,MaxInt);
  {$ELSE}
  //低版本Delphi VCL
  //ItemSubItems
  ASubItemsIndexStr:=Copy(AFieldName,13,MaxInt);
  {$IFEND}

  if {$IF CompilerVersion >= 30.0}ASubItemsIndexStr.Chars[0]{$ELSE}ASubItemsIndexStr[1]{$IFEND}<>'_' then
  begin
      //下标
      TryStrToInt(ASubItemsIndexStr,ASubItemsIndex);
      //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
      //自动补齐
      if (ASubItemsIndex>-1) and (ASubItemsIndex<ASubItems.Count) then
      begin
          Result:=ASubItems[ASubItemsIndex];
      end
      else
      begin
          Result:='';
      end;

  end
  else
  begin

      {$IF CompilerVersion >= 30.0}
      ASubItemsIndexStr:=ASubItemsIndexStr.Substring(1,MaxInt);
      {$ELSE}
      //低版本Delphi VCL
      ASubItemsIndexStr:=Copy(ASubItemsIndexStr,2,MaxInt);
      {$IFEND}


      //是Key
      Result:=ASubItems.Values[ASubItemsIndexStr];

  end;

end;

function TRealSkinItem.GetValueByBindItemField(AFieldName:String):Variant;
begin
  if AFieldName='ItemCaption' then
  begin
    Result:=Self.FCaption;
  end
  else if AFieldName='ItemDetail' then
  begin
    Result:=FDetail;
  end
  else if AFieldName='ItemDetail1' then
  begin
    Result:=FDetail1;
  end
  else if AFieldName='ItemDetail2' then
  begin
    Result:=FDetail2;
  end
  else if AFieldName='ItemDetail3' then
  begin
    Result:=FDetail3;
  end
  else if AFieldName='ItemDetail4' then
  begin
    Result:=FDetail4;
  end
  else if AFieldName='ItemDetail5' then
  begin
    Result:=FDetail5;
  end
  else if AFieldName='ItemDetail6' then
  begin
    Result:=FDetail6;
  end
  else if AFieldName='ItemIndex' then
  begin
    Result:=IntToStr(Index+1);
  end
  else if AFieldName='ItemAccessory' then
  begin
    Result:=FAccessory;
  end
  else if AFieldName='ItemColor' then
  begin
    Result:=FColor.Color;
  end
  else if {$IF CompilerVersion >= 30.0}AFieldName.Substring(0,12){$ELSE}Copy(AFieldName,1,12){$IFEND}='ItemSubItems' then
  begin
      Result:=GetValueByBindItemSubItems(SubItems,AFieldName);

//      ASubItemsIndex:=-1;
//      ASubItemsIndexStr:=AFieldName.Substring(12,MaxInt);
//      if ASubItemsIndexStr.Substring[0]<>'_' then
//      begin
//          //下标
//          TryStrToInt(ASubItemsIndexStr,ASubItemsIndex);
//          //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
//          //自动补齐
//          if (ASubItemsIndex>-1) and (ASubItemsIndex<Self.SubItems.Count) then
//          begin
//              Result:=Self.SubItems[ASubItemsIndex];
//          end
//          else
//          begin
//              Result:='';
//          end;
//
//      end
//      else
//      begin
//          ASubItemsIndexStr:=ASubItemsIndexStr.Substring(1,MaxInt);
//          //是Key
//          Result:=Self.SubItems.Values[ASubItemsIndexStr];
//
//      end;

  end
  else if SubItems.IndexOfName(AFieldName)>-1 then
  begin
    Result:=SubItems.Values[AFieldName];
  end
  else
  begin
    Result:=Inherited GetValueByBindItemField(AFieldName);
  end;

end;

function TRealSkinItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  ADataStream:TMemoryStream;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Caption' then
    begin
      FCaption:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail' then
    begin
      FDetail:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail1' then
    begin
      FDetail1:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail2' then
    begin
      FDetail2:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail3' then
    begin
      FDetail3:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail4' then
    begin
      FDetail4:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail5' then
    begin
      FDetail5:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail6' then
    begin
      FDetail6:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Accessory' then
    begin
      FAccessory:=TSkinAccessoryType(ABTNode.ConvertNode_Int32.Data);
    end

    else if ABTNode.NodeName='SubItems' then
    begin
      ADataStream:=TMemoryStream.Create;
      try
        ABTNode.ConvertNode_Binary.SaveToStream(ADataStream);
        ADataStream.Position:=0;
        try
          SubItems.LoadFromStream(ADataStream,TEncoding.UTF8);
        except

        end;
      finally
        FreeAndNil(ADataStream);
      end;
    end
    ;

  end;

  Result:=True;
end;

function TRealSkinItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
  ADataStream:TMemoryStream;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);
  ABTNode:=ADocNode.AddChildNode_WideString('Caption');//,'标题');
  ABTNode.ConvertNode_WideString.Data:=FCaption;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail');//,'明细');
  ABTNode.ConvertNode_WideString.Data:=FDetail;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail1');//,'明细1');
  ABTNode.ConvertNode_WideString.Data:=FDetail1;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail2');//,'明细2');
  ABTNode.ConvertNode_WideString.Data:=FDetail2;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail3');//,'明细3');
  ABTNode.ConvertNode_WideString.Data:=FDetail3;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail4');//,'明细4');
  ABTNode.ConvertNode_WideString.Data:=FDetail4;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail5');//,'明细5');
  ABTNode.ConvertNode_WideString.Data:=FDetail5;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail6');//,'明细6');
  ABTNode.ConvertNode_WideString.Data:=FDetail6;


  ABTNode:=ADocNode.AddChildNode_Int32('Accessory');//,'Accessory');
  ABTNode.ConvertNode_Int32.Data:=Ord(FAccessory);

  if (FSubItems<>nil) and (FSubItems.Count>0) then
  begin
    ABTNode:=ADocNode.AddChildNode_Binary('SubItems');//,'字符串列表');
    ADataStream:=TMemoryStream.Create;
    try
      FSubItems.SaveToStream(ADataStream,TEncoding.UTF8);
      ADataStream.Position:=0;
      ABTNode.ConvertNode_Binary.LoadFromStream(ADataStream);
    finally
      FreeAndNil(ADataStream);
    end;
  end;

  Result:=True;
end;

procedure TRealSkinItem.SetSubItems(const Value: TStringList);
begin
  FSubItems.Assign(Value);
end;

procedure SetValueByBindItemSubItems(ASubItems:TStringList;AFieldName: String;AValue: Variant;APageDataDir:String;AImageServerUrl:String);
var
  I:Integer;
  ASubItemsIndexStr:String;
  ASubItemsIndex:Integer;
begin
      ASubItemsIndex:=-1;

      {$IF CompilerVersion >= 30.0}
      ASubItemsIndexStr:=AFieldName.Substring(12,MaxInt);
      {$ELSE}
      ASubItemsIndexStr:=Copy(AFieldName,13,MaxInt);
      {$IFEND}

      if {$IF CompilerVersion >= 30.0}ASubItemsIndexStr.Chars[0]{$ELSE}AFieldName[1]{$IFEND}<>'_' then
      begin
          //是下标


          //ItemSubItemsXXX,ItemSubItems1,ItemSubItems13,ItemSubItems244
          TryStrToInt(ASubItemsIndexStr,ASubItemsIndex);
          //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
          //自动补齐
          //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
          //自动补齐
          if (ASubItemsIndex>-1) and (ASubItemsIndex<ASubItems.Count) then
          begin
              ASubItems[ASubItemsIndex]:=AValue;
          end
          else if ASubItemsIndex>=ASubItems.Count then
          begin
              for I := 0 to ASubItemsIndex-ASubItems.Count-1 do
              begin
                ASubItems.Add('');
              end;
              ASubItems.Add(AValue);
          end;

      end
      else
      begin


          {$IF CompilerVersion >= 30.0}
          ASubItemsIndexStr:=ASubItemsIndexStr.Substring(1,MaxInt);
          {$ELSE}
          ASubItemsIndexStr:=Copy(ASubItemsIndexStr,2,MaxInt);
          {$IFEND}

          ASubItems.Values[ASubItemsIndexStr]:=AValue;
      end;


end;

procedure TRealSkinItem.SetValueByBindItemField(AFieldName: String;AValue: Variant;APageDataDir:String;AImageServerUrl:String);
begin

  if AFieldName='ItemCaption' then
  begin
    Self.Caption:=AValue;
  end
  else if AFieldName='ItemDetail' then
  begin
    Detail:=AValue;
  end
  else if AFieldName='ItemDetail1' then
  begin
    Detail1:=AValue;
  end
  else if AFieldName='ItemDetail2' then
  begin
    Detail2:=AValue;
  end
  else if AFieldName='ItemDetail3' then
  begin
    Detail3:=AValue;
  end
  else if AFieldName='ItemDetail4' then
  begin
    Detail4:=AValue;
  end
  else if AFieldName='ItemDetail5' then
  begin
    Detail5:=AValue;
  end
  else if AFieldName='ItemDetail6' then
  begin
    Detail6:=AValue;
  end
  else if AFieldName='ItemAccessory' then
  begin
    Accessory:=AValue;
  end
  else if AFieldName='ItemColor' then
  begin
    FColor.Color:=AValue;
  end
  else if {$IF CompilerVersion >= 30.0}AFieldName.Substring(0,12){$ELSE}Copy(AFieldName,1,12){$IFEND}='ItemSubItems' then
  begin
    SetValueByBindItemSubItems(SubItems,AFieldName,AValue,APageDataDir,AImageServerUrl);
  end
  else if SubItems.IndexOfName(AFieldName)>-1 then
  begin
    SubItems.Values[AFieldName]:=AValue;
  end
  else
  begin
    Inherited SetValueByBindItemField(AFieldName,AValue,APageDataDir,AImageServerUrl);
  end;

end;

//procedure TRealSkinItem.SetWidth(const Value: TControlSize);
//begin
//  if FWidth<>Value then
//  begin
//    FWidth := Value;
//
//    DoSizeChange;
//
//    DoPropChange;
//  end;
//end;
//
//procedure TRealSkinItem.StartAnimate;
//begin
//  AnimateEnable:=True;
//
//  AnimateStarted:=True;
//  AnimateIsFirstStart:=True;
//  Self.DoPropChange;
//end;
//
//procedure TRealSkinItem.StopAnimate;
//begin
//  if AnimateStarted then
//  begin
//    AnimateStarted:=False;
//    AnimateIsFirstStop:=True;
//    Self.DoPropChange;
//  end;
//end;
//
//procedure TRealSkinItem.SetItemType(const Value: TSkinItemType);
//begin
//  if FItemType<>Value then
//  begin
//    FItemType := Value;
//
//    DoPropChange;
//  end;
//end;

procedure TRealSkinItem.SetAccessory(const Value: TSkinAccessoryType);
begin
  if Value<>FAccessory then
  begin
    FAccessory:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinItem.SetCaption(const Value: String);
begin
  if Value<>Caption then
  begin
    FCaption:=Value;

    DoPropChange;
  end;
end;

//procedure TRealSkinItem.SetChecked(const Value: Boolean);
//begin
//  if Value<>FChecked then
//  begin
//    FChecked:=Value;
//
//    DoPropChange;
//  end;
//end;

//procedure TRealSkinItem.SetDataObject(const Value: TObject);
//begin
//  if FDataObject<>Value then
//  begin
//    if FDataObject<>nil then
//    begin
//      ObjRelease(FDataObject);
//    end;
//    FDataObject := Value;
//    if FDataObject<>nil then
//    begin
//      ObjAddRef(FDataObject);
//    end;
//  end;
//end;

procedure TRealSkinItem.SetDetail(const Value: String);
begin
  if Value<>FDetail then
  begin
    FDetail:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinItem.SetDetail1(const Value: String);
begin
  if Value<>FDetail1 then
  begin
    FDetail1:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinItem.SetDetail2(const Value: String);
begin
  if Value<>FDetail2 then
  begin
    FDetail2:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinItem.SetDetail3(const Value: String);
begin
  if Value<>FDetail3 then
  begin
    FDetail3:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinItem.SetDetail4(const Value: String);
begin
  if Value<>FDetail4 then
  begin
    FDetail4:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinItem.SetDetail5(const Value: String);
begin
  if Value<>FDetail5 then
  begin
    FDetail5:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinItem.SetDetail6(const Value: String);
begin
  if Value<>FDetail6 then
  begin
    FDetail6:=Value;

    DoPropChange;
  end;
end;



{ TBaseSkinItem }

procedure TBaseSkinItem.ClearItemRect;
begin
  FItemRect:=RectF(0,0,0,0);
  FItemDrawRect:=RectF(0,0,0,0);

  IsBufferNeedChange:=True;

end;

constructor TBaseSkinItem.Create;
begin
  inherited Create;


  //-1表示默认
  FHeight:=-1;
  //-1表示默认
  FWidth:=-1;

  FVisible:=True;

  FTempBindDrawPictureList:=TDrawPictureList.Create;
  FItemStyleConfig:=TStringList.Create;
end;

procedure TBaseSkinItem.SetHeight(const Value: Double);
begin
  if FHeight<>Value then
  begin
    FHeight:=Value;

    DoSizeChange;

    DoPropChange;
  end;
end;

//procedure TBaseSkinItem.AfterConstruction;
//begin
//  inherited;
//
//  //-1表示默认
//  FHeight:=-1;
//  //-1表示默认
//  FWidth:=-1;
//
//  FVisible:=True;
//
//end;

procedure TBaseSkinItem.AssignTo(Dest: TPersistent);
var
  DestObject:TBaseSkinItem;
begin
  if Dest is TBaseSkinItem then
  begin
    DestObject:=Dest as TBaseSkinItem;

    DestObject.FHeight:=Self.FHeight;
    DestObject.FWidth:=Self.FWidth;
    DestObject.FVisible:=Self.FVisible;

    DestObject.DoPropChange;
  end
  else
  begin
    inherited;
  end;
end;
//
//constructor TBaseSkinItem.Create(AOwner: TBaseSkinItems);
//begin
//  Create;
//
//
//  FOwner:=AOwner;
//  SetSkinListIntf(AOwner);
////
////  //-1表示默认
////  FHeight:=-1;
////  //-1表示默认
////  FWidth:=-1;
////
////  FVisible:=True;
//
//end;

destructor TBaseSkinItem.Destroy;
begin

  FreeAndNil(FTempBindDrawPictureList);
  FreeAndNil(FItemStyleConfig);

  //删除
  if FOwner<>nil then
  begin
    FOwner.Remove(Self,False);
  end;

  inherited;
end;

procedure TBaseSkinItem.DoPropChange(Sender:TObject);
begin
  IsBufferNeedChange:=True;

  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;

  if (GetListLayoutsManager<>nil) then
  begin
    GetListLayoutsManager.DoItemPropChange(Self);
  end;
end;

procedure TBaseSkinItem.DoSizeChange;
begin

  if (GetListLayoutsManager<>nil) then
  begin
    GetListLayoutsManager.DoItemSizeChange(Self);
  end;
end;

procedure TBaseSkinItem.DoVisibleChange;
begin
  if (Self.GetListLayoutsManager<>nil) then
  begin
    Self.GetListLayoutsManager.DoItemVisibleChange(Self);
  end;
end;

function TBaseSkinItem.GetHeight: Double;
begin
  Result:=FHeight;
end;

function TBaseSkinItem.GetSelected: Boolean;
begin
  Result:=FSelected;
end;

function TBaseSkinItem.GetThisRowItemCount: Integer;
begin
  Result:=0;
end;

function TBaseSkinItem.GetObject: TObject;
begin
  Result:=Self;
end;

function TBaseSkinItem.GetItemRect: TRectF;
begin
  Result:=FItemRect;
end;

function TBaseSkinItem.GetItemDrawRect: TRectF;
begin
  Result:=FItemDrawRect;
end;

function TBaseSkinItem.GetListLayoutsManager: TSkinListLayoutsManager;
begin
  Result:=nil;
  if FSkinListIntf<>nil then
  begin
    Result:=Self.FSkinListIntf.GetListLayoutsManager;
  end;
end;

function TBaseSkinItem.GetValueByBindItemField(AFieldName: String): Variant;
begin
  if AFieldName='ItemChecked' then
  begin
    Result:=FChecked;
  end
  else if AFieldName='ItemSelected' then
  begin
    Result:=FSelected;
  end
  else
  begin
    Result:='';
  end;
end;

function TBaseSkinItem.GetValueTypeByBindItemField(AFieldName: String): TVarType;
begin
  Result:=varVariant;

  if (AFieldName='ItemSelected') or (AFieldName='ItemChecked') then
  begin
    Result:=varBoolean;
  end;

end;

function TBaseSkinItem.GetVisible: Boolean;
begin
  Result:=FVisible;
end;

function TBaseSkinItem.GetWidth: Double;
begin
  Result:=FWidth;
end;

function TBaseSkinItem.GetLevel: Integer;
begin
  Result:=0;
end;

function TBaseSkinItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Height' then
    begin
        if ABTNode is TBTNode20_Real64 then
        begin
          //现在是浮点型
          FHeight:=ABTNode.ConvertNode_Real64.Data;
        end
        else
        if ABTNode is TBTNode20_Int32 then
        begin
          //以前是整型
          FHeight:=ABTNode.ConvertNode_Int32.Data;
        end;
    end
    else if ABTNode.NodeName='Width' then
    begin
        if ABTNode is TBTNode20_Real64 then
        begin
          //现在是浮点型
          FWidth:=ABTNode.ConvertNode_Real64.Data;
        end
        else
        if ABTNode is TBTNode20_Int32 then
        begin
          //以前是整型
          FWidth:=ABTNode.ConvertNode_Int32.Data;
        end;
    end
    else if ABTNode.NodeName='Selected' then
    begin
      if ABTNode.ConvertNode_Bool32.Data then
      begin
        Selected:=ABTNode.ConvertNode_Bool32.Data;
      end;
    end
    else if ABTNode.NodeName='Visible' then
    begin
      FVisible:=ABTNode.ConvertNode_Bool32.Data;
    end
    ;

  end;

  Result:=True;
end;

function TBaseSkinItem.PtInItem(APoint:TPointF): Boolean;
begin
  Result:=PtInRect(Self.FItemDrawRect,APoint);
end;

function TBaseSkinItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Real64('Height');//,'高度');
  ABTNode.ConvertNode_Real64.Data:=FHeight;

  ABTNode:=ADocNode.AddChildNode_Real64('Width');//,'宽度');
  ABTNode.ConvertNode_Real64.Data:=FWidth;


  if Selected then
  begin
    //选中了才需要存储
    ABTNode:=ADocNode.AddChildNode_Bool32('Selected');//,'选中');
    ABTNode.ConvertNode_Bool32.Data:=Selected;
  end;


  ABTNode:=ADocNode.AddChildNode_Bool32('Visible');//,'显示');
  ABTNode.ConvertNode_Bool32.Data:=FVisible;


  Result:=True;
end;

procedure TBaseSkinItem.SetSelected(const Value: Boolean);
begin

  if (Self.GetListLayoutsManager<>nil) then
  begin
      if not Value and Self.Selected then
      begin
        //取消选中
        Self.GetListLayoutsManager.DoItemSelected(nil);
      end;
  end;

  if FSelected<>Value then
  begin
    FSelected:=Value;
    DoPropChange;
  end;

  if (Self.GetListLayoutsManager<>nil) then
  begin
      if Value then
      begin
        //选中
        Self.GetListLayoutsManager.DoItemSelected(Self);
      end;
  end;

end;

procedure TBaseSkinItem.SetValueByBindItemField(AFieldName: String;
  AValue: Variant; APageDataDir, AImageServerUrl: String);
begin
  if AFieldName='ItemChecked' then
  begin
    Checked:=AValue;
  end
  else if AFieldName='ItemSelected' then
  begin
    Selected:=AValue;
  end;
end;

procedure TBaseSkinItem.SetVisible(const Value: Boolean);
begin
  if FVisible<>Value then
  begin

    FVisible := Value;

    DoVisibleChange;

    DoPropChange;
  end;
end;

procedure TBaseSkinItem.SetItemRect(Value: TRectF);
begin
  FItemRect:=Value;
end;

procedure TBaseSkinItem.SetChecked(const Value: Boolean);
begin
  if Value<>FChecked then
  begin
    FChecked:=Value;

    DoPropChange;
  end;
end;

procedure TBaseSkinItem.SetOwner(const Value: TBaseSkinItems);
begin
  if FOwner<>Value then
  begin
    FOwner:=Value;
    SetSkinListIntf(Value);

    if FSelected and (FOwner<>nil) then
    begin
        if (Self.GetListLayoutsManager<>nil) then
        begin
          //选中
          Self.GetListLayoutsManager.DoItemSelected(Self);
        end;
    end;
  end;
end;

procedure TBaseSkinItem.SetItemDrawRect(Value: TRectF);
begin
  FItemDrawRect:=Value;
end;

procedure TBaseSkinItem.SetSkinListIntf(ASkinListIntf: ISkinList);
begin
  FSkinListIntf:=ASkinListIntf;
end;

function TBaseSkinItem.GetIndex: Integer;
begin
  Result:=-1;
  if Self.FOwner<>nil then
  begin
    Result:=Self.FOwner.IndexOf(Self);
  end;
end;

function TBaseSkinItem.GetIsRowEnd: Boolean;
begin
  Result:=FIsRowEnd;
end;

{ TSkinItem }

//procedure TSkinItem.AfterConstruction;
//begin
//  inherited;
//
//  FColor:=TDrawColor.Create('Color','颜色');
//  FColor.FAlpha:=0;
//  FColor.FColor:=0;
//
//
//  FVisible:=True;
//  FTempBindDrawPictureList:=TDrawPictureList.Create;
////  FColor.OnChange:=Self.DoColorChange;
//
//
////  FVisible:=True;
//
//
//  FIconImageIndex:=-1;
//  FPicImageIndex:=-1;
//
//end;

procedure TSkinItem.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinItem;
begin
  if Dest is TSkinItem then
  begin

    DestObject:=Dest as TSkinItem;


    DestObject.FData:=Self.FData;
    DestObject.FDataJsonStr:=Self.FDataJsonStr;
    DestObject.FDataObject:=Self.FDataObject;

    DestObject.FWidth:=Self.FWidth;
    DestObject.FHeight:=Self.FHeight;


    DestObject.FName:=Self.FName;


    DestObject.FTag:=Self.FTag;
    DestObject.FTag1:=Self.FTag1;

    DestObject.FChecked:=Self.FChecked;

    DestObject.FItemType:=Self.FItemType;


    DestObject.FColor.Assign(Self.FColor);


    if Self.FIcon=nil then
    begin
      //如果不存在Icon,那么释放掉
      FreeAndNil(DestObject.FIcon);
    end
    else
    begin
      //不能是FIcon,因为可能没有创建
      DestObject.Icon.Assign(Self.FIcon);
    end;
    DestObject.FIconImageIndex:=Self.FIconImageIndex;
    DestObject.FIconRefPicture:=Self.FIconRefPicture;


    if Self.FPic=nil then
    begin
      //如果不存在Pic,那么释放掉
      FreeAndNil(DestObject.FPic);
    end
    else
    begin
      //不能是FPic,因为可能没有创建
      DestObject.Pic.Assign(Self.FPic);
    end;
    DestObject.FPicImageIndex:=Self.FPicImageIndex;
    DestObject.FPicRefPicture:=Self.FPicRefPicture;

    //inherited里面已经有了DestObject.DoPropChange;
    inherited;

  end
  else
  begin
    inherited;
  end;


end;
//
//procedure TSkinItem.ClearData(AItemDataType: TSkinItemDataType);
//begin
//  case AItemDataType of
//    idtNone: ;
////    idtCaption: Self.FCaption:='';
//
//
//    idtIcon: if Self.FIcon<>nil then FIcon.Clear;
//    idtPic: if Self.FPic<>nil then FPic.Clear;
//    idtChecked: Self.FChecked:=False;
//    idtSelected: Self.FSelected:=False;
//
//
////    idtAccessory: Self.FAccessory:=TSkinAccessoryType.satNone;
////    idtDetail: Self.FDetail:='';
////    idtDetail1: Self.FDetail1:='';
////    idtDetail2: Self.FDetail2:='';
////    idtDetail3: Self.FDetail3:='';
////    idtDetail4: Self.FDetail4:='';
////    idtDetail5: Self.FDetail5:='';
////    idtDetail6: Self.FDetail6:='';
//    idtSubItems: Self.SubItems.Clear;
//  end;
//
//end;

procedure TSkinItem.ClearData(AFieldName: String);
begin
  Self.SetValueByBindItemField(AFieldName,'');

//  if AFieldName='ItemIcon' then
//  begin
//    FIcon.Clear;
//  end
//  else if AFieldName='ItemPic' then
//  begin
//    FPic.Clear;
//  end


//  else if AFieldName='ItemChecked' then
//  begin
//    FChecked:=False;
//  end
//  else if AFieldName='ItemSelected' then
//  begin
//    FSelected:=False;
//  end;


//  case AItemDataType of
//    idtNone: ;
////    idtCaption: Self.FCaption:='';
//
//
//    idtIcon: if Self.FIcon<>nil then FIcon.Clear;
//    idtPic: if Self.FPic<>nil then FPic.Clear;
//    idtChecked: Self.FChecked:=False;
//    idtSelected: Self.FSelected:=False;
//
//
////    idtAccessory: Self.FAccessory:=TSkinAccessoryType.satNone;
////    idtDetail: Self.FDetail:='';
////    idtDetail1: Self.FDetail1:='';
////    idtDetail2: Self.FDetail2:='';
////    idtDetail3: Self.FDetail3:='';
////    idtDetail4: Self.FDetail4:='';
////    idtDetail5: Self.FDetail5:='';
////    idtDetail6: Self.FDetail6:='';
//    idtSubItems: Self.SubItems.Clear;
//  end;

end;

constructor TSkinItem.Create;
begin
  FColor:=TDrawColor.Create('Color','颜色');
  FColor.FAlpha:=0;
  FColor.FColor:=0;


  inherited Create;

  FVisible:=True;
//  FColor.OnChange:=Self.DoColorChange;


//  FVisible:=True;


  FIconImageIndex:=-1;
  FPicImageIndex:=-1;

end;

function TSkinItem.CreateOwnDataObject(AClass: TClass): TObject;
begin
  if FIsOwnDataObject and (FDataObject<>nil) then
  begin
    FreeAndNil(Self.FDataObject);
  end;

  FIsOwnDataObject:=True;

  Self.FDataObject:=AClass.Create;
  Result:=FDataObject;
end;

destructor TSkinItem.Destroy;
begin
  if FIsOwnDataObject and (FDataObject<>nil) then
  begin
    FreeAndNil(FDataObject);
  end;


  FreeAndNil(FIcon);
  FreeAndNil(FPic);
  FreeAndNil(FColor);



  inherited;
end;

procedure TSkinItem.DoGetIconSkinImageList(Sender: TObject;var ASkinImageList: TSkinBaseImageList);
begin
  if (Self.GetListLayoutsManager<>nil) then
  begin
    GetListLayoutsManager.DoGetItemIconDefaultSkinImageList(Sender,ASkinImageList);
  end;
end;

//function TSkinItem.DoGetAbstractValueByBindItemField(AFieldName: String): Variant;
//var
//  ASubItemsIndex:Integer;
//begin
//  if AFieldName='ItemCaption' then
//  begin
//    Result:=Self.Caption;
//  end
//  else if AFieldName='ItemDetail' then
//  begin
//    Result:=Detail;
//  end
//  else if AFieldName='ItemDetail1' then
//  begin
//    Result:=Detail1;
//  end
//  else if AFieldName='ItemDetail2' then
//  begin
//    Result:=Detail2;
//  end
//  else if AFieldName='ItemDetail3' then
//  begin
//    Result:=Detail3;
//  end
//  else if AFieldName='ItemDetail4' then
//  begin
//    Result:=Detail4;
//  end
//  else if AFieldName='ItemDetail5' then
//  begin
//    Result:=Detail5;
//  end
//  else if AFieldName='ItemDetail6' then
//  begin
//    Result:=Detail6;
//  end
//  else if AFieldName='ItemAccessory' then
//  begin
//    Result:=Accessory;
//  end
//  else if AFieldName='ItemColor' then
//  begin
//    Result:=FColor.Color;
//  end
//  else if AFieldName.Substring(0,12)='ItemSubItems' then
//  begin
//      Result:=GetValueByBindItemSubItems(SubItems,AFieldName);
//
////    ASubItemsIndex:=-1;
////    TryStrToInt(AFieldName.Substring(12,MaxInt),ASubItemsIndex);
////    //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
////    //自动补齐
////    if (ASubItemsIndex>-1) and (ASubItemsIndex<Self.SubItems.Count) then
////    begin
////        Result:=Self.SubItems[ASubItemsIndex];
////    end
////    else
////    begin
////        Result:='';
////    end;
//
//
//  end;
//end;

procedure TSkinItem.DoGetDownloadPictureManager(Sender: TObject;var ADownloadPictureManager: TBaseDownloadPictureManager);
begin
  if (Self.GetListLayoutsManager<>nil) then
  begin
    GetListLayoutsManager.DoGetItemIconDefaultDownloadPictureManager(Sender,ADownloadPictureManager);
  end;
end;

procedure TSkinItem.DoIconChange(Sender: TObject);
begin
  Self.DoPropChange;
end;

procedure TSkinItem.DoPicChange(Sender: TObject);
begin
  Self.DoPropChange;
end;

function TSkinItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Name' then
    begin
      FName:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Tag' then
    begin
      FTag:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='Tag1' then
    begin
      FTag1:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='Checked' then
    begin
      FChecked:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='ItemType' then
    begin
      FItemType:=TSkinItemType(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='Icon' then
    begin
      Icon.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='Pic' then
    begin
      Pic.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='Color' then
    begin
      FColor.Assign(ABTNode.ConvertNode_Color.Data);
    end

    ;

  end;

  Result:=True;

end;

procedure TSkinItem.RecordControlLangIndex(APrefix: String; ALang: TLang;ACurLang: String);
begin

  if Self.Caption<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Caption',ACurLang,Self.Caption);
  end;
  if Self.Detail<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail',ACurLang,Self.Detail);
  end;
  if Self.Detail1<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail1',ACurLang,Self.Detail1);
  end;
  if Self.Detail2<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail2',ACurLang,Self.Detail2);
  end;
  if Self.Detail3<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail3',ACurLang,Self.Detail3);
  end;
  if Self.Detail4<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail4',ACurLang,Self.Detail4);
  end;
  if Self.Detail5<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail5',ACurLang,Self.Detail5);
  end;
  if Self.Detail6<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail6',ACurLang,Self.Detail6);
  end;

end;

procedure TSkinItem.SetWidth(const Value: Double);
begin
  if FWidth<>Value then
  begin
    FWidth := Value;

    DoSizeChange;

    DoPropChange;
  end;
end;

procedure TSkinItem.StartAnimate;
begin
  AnimateEnable:=True;

  AnimateStarted:=True;
  AnimateIsFirstStart:=True;
  Self.DoPropChange;
end;

procedure TSkinItem.StopAnimate;
begin
  if AnimateStarted then
  begin
    AnimateStarted:=False;
    AnimateIsFirstStop:=True;
    Self.DoPropChange;
  end;
end;

procedure TSkinItem.TranslateControlLang(APrefix: String; ALang: TLang;
  ACurLang: String);
begin
  if GetLangValue(ALang,APrefix+Name+'.Caption',ACurLang)<>'' then
  begin
    Caption:=GetLangValue(ALang,APrefix+Name+'.Caption',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.Detail',ACurLang)<>'' then
  begin
    Detail:=GetLangValue(ALang,APrefix+Name+'.Detail',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.Detail1',ACurLang)<>'' then
  begin
    Detail1:=GetLangValue(ALang,APrefix+Name+'.Detail1',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.Detail2',ACurLang)<>'' then
  begin
    Detail2:=GetLangValue(ALang,APrefix+Name+'.Detail2',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.Detail3',ACurLang)<>'' then
  begin
    Detail3:=GetLangValue(ALang,APrefix+Name+'.Detail3',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.Detail4',ACurLang)<>'' then
  begin
    Detail4:=GetLangValue(ALang,APrefix+Name+'.Detail4',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.Detail5',ACurLang)<>'' then
  begin
    Detail5:=GetLangValue(ALang,APrefix+Name+'.Detail5',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.Detail6',ACurLang)<>'' then
  begin
    Detail6:=GetLangValue(ALang,APrefix+Name+'.Detail6',ACurLang);
  end;

end;

procedure TSkinItem.SetItemType(const Value: TSkinItemType);
begin
  if FItemType<>Value then
  begin
    FItemType := Value;

    DoPropChange;
  end;
end;

function TSkinItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_WideString('Name');//,'名称');
  ABTNode.ConvertNode_WideString.Data:=FName;

  ABTNode:=ADocNode.AddChildNode_Int32('Tag');//,'标记');
  ABTNode.ConvertNode_Int32.Data:=FTag;

  ABTNode:=ADocNode.AddChildNode_Int32('Tag1');//,'标记1');
  ABTNode.ConvertNode_Int32.Data:=FTag1;

  ABTNode:=ADocNode.AddChildNode_Bool32('Checked');//,'勾选');
  ABTNode.ConvertNode_Bool32.Data:=FChecked;

  ABTNode:=ADocNode.AddChildNode_Int32('ItemType');//,'类型');
  ABTNode.ConvertNode_Int32.Data:=Ord(FItemType);


  if FIcon<>nil then
  begin
    ABTNode:=ADocNode.AddChildNode_Class('Icon');//,'图标');
    FIcon.SaveToDocNode(ABTNode.ConvertNode_Class);
  end;

  if FPic<>nil then
  begin
    ABTNode:=ADocNode.AddChildNode_Class('Pic');//,'图片');
    FPic.SaveToDocNode(ABTNode.ConvertNode_Class);
  end;

  ABTNode:=ADocNode.AddChildNode_Int32('ItemType');//,'类型');
  ABTNode.ConvertNode_Int32.Data:=Ord(FItemType);

  if FColor.FColor<>0 then
  begin
    ABTNode:=ADocNode.AddChildNode_Color('Color');//,'颜色');
    ABTNode.ConvertNode_Color.Data.Assign(FColor);
  end;



  Result:=True;

end;


procedure TSkinItem.SetDataObject(const Value: TObject);
begin
  if FDataObject<>Value then
  begin
      if FDataObject<>nil then
      begin
        ObjRelease(FDataObject);
      end;

      FDataObject := Value;

      if FDataObject<>nil then
      begin
        ObjAddRef(FDataObject);
      end;
  end;
end;

procedure TSkinItem.SetIcon(const Value: TBaseDrawPicture);
begin
  if FIcon<>nil then
  begin
    FIcon.Assign(Value);
  end;
end;

procedure TSkinItem.SetIconImageIndex(const Value: Integer);
begin
  if FIconImageIndex<>Value then
  begin
    FIconImageIndex:=Value;
    DoPropChange;
  end;
end;

procedure TSkinItem.SetIconRefPicture(const Value: TSkinPicture);
begin
  if FIconRefPicture<>Value then
  begin
    FIconRefPicture:=Value;
    DoPropChange;
  end;
end;

procedure TSkinItem.SetPic(const Value: TBaseDrawPicture);
begin
  if FPic<>nil then
  begin
    FPic.Assign(Value);
  end;
end;

procedure TSkinItem.SetPicImageIndex(const Value: Integer);
begin
  if FPicImageIndex<>Value then
  begin
    FPicImageIndex:=Value;
    DoPropChange;
  end;
end;

procedure TSkinItem.SetPicRefPicture(const Value: TSkinPicture);
begin
  if FPicRefPicture<>Value then
  begin
    FPicRefPicture:=Value;
    DoPropChange;
  end;
end;

//IControlForPageFramework接口
//针对页面框架的控件接口
function TSkinItem.LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
begin
  Name:=ASetting.name;
  Caption:=ASetting.field_caption;

  if ASetting.icon_image_name<>'' then
  begin
    Self.Icon.RefDrawPicture:=GetGlobalPageFrameworkDataSourceManager.GetDrawPicture(ASetting.icon_image_name);
  end;

  //初始值
  Detail:=ASetting.value;
  Visible:=(ASetting.visible=1);
  Width:=ASetting.width;
  Height:=ASetting.height;
end;

////获取与设置自定义属性
//function TSkinItem.GetProp(APropName: String): Variant;
//begin
//  Result:='';
//end;

function TSkinItem.GetPropJsonStr:String;
begin
  Result:='';
end;
//
//procedure TSkinItem.SetProp(APropName: String; APropValue: Variant);
//begin
//
//end;

procedure TSkinItem.SetPropJsonStr(AJsonStr:String);
begin

end;


//获取提交的值
function TSkinItem.GetPostValue(ASetting:TFieldControlSetting;
                                APageDataDir:String;
                                //可以获取其他字段的值
                                ASetRecordFieldValueIntf:ISetRecordFieldValue;
                                var AErrorMessage:String):Variant;
begin
  Result:=Detail;
end;

//设置值
procedure TSkinItem.SetControlValue(ASetting:TFieldControlSetting;
                                    APageDataDir:String;
                                    AImageServerUrl:String;
                                    AValue:Variant;
                                    AValueCaption:String;
                                    //要设置多个值,整个字段的记录
                                    AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  Detail:=AValue;
end;

procedure TSkinItem.DoReturnFrame(AFromFrame:TFrame);
begin
end;

procedure TSkinItem.SetValueByBindItemField(AFieldName: String;AValue: Variant;APageDataDir:String;AImageServerUrl:String);
begin
  if AFieldName='ItemIconImageIndex' then
  begin
    IconImageIndex:=AValue;
  end
  else if AFieldName='ItemPicImageIndex' then
  begin
    PicImageIndex:=AValue;
  end
  else if AFieldName='ItemIconUrl' then
  begin
    Icon.Url:=AValue;
  end
  else if AFieldName='ItemPicUrl' then
  begin
    Pic.Url:=AValue;
  end
  else if AFieldName='ItemIcon' then
  begin
    uSkinImageType.SetDrawPictureValue(Icon,APageDataDir,AImageServerUrl,AValue)
  end
  else if AFieldName='ItemPic' then
  begin
    uSkinImageType.SetDrawPictureValue(Pic,APageDataDir,AImageServerUrl,AValue)
  end


//  else if AFieldName='ItemChecked' then
//  begin
//    Checked:=AValue;
//  end
//  else if AFieldName='ItemSelected' then
//  begin
//    Selected:=AValue;
//  end


  else if AFieldName='ItemTag' then
  begin
    Tag:=AValue;
  end
  else if AFieldName='ItemTag1' then
  begin
    Tag1:=AValue;
  end
  else
  begin
    Inherited SetValueByBindItemField(AFieldName,AValue,APageDataDir,AImageServerUrl);
  end;

end;

procedure TSkinItem.SetColor(const Value: TDelphiColor);
begin
  if FColor.FColor<>Value then
  begin
    FColor.FColor:=Value;

    DoPropChange;
  end;
end;

//function TSkinItem.GetStaticIcon: TBaseDrawPicture;
//begin
//  Result:=FIcon;
//end;

function TSkinItem.GetColor: TDelphiColor;
begin
  Result:=FColor.FColor;
end;

function TSkinItem.GetIcon: TBaseDrawPicture;
begin
  if FIcon=nil then
  begin
    FIcon:=TBaseDrawPicture.Create('Icon','图标');
    FIcon.OnChange:=Self.DoIconChange;
    FIcon.OnGetSkinImageList:=DoGetIconSkinImageList;
    FIcon.OnGetDownloadPictureManager:=DoGetDownloadPictureManager;
  end;
  Result:=FIcon;
end;

//function TSkinItem.GetIconImageIndex: Integer;
//begin
//  Result:=FIconImageIndex;
//end;
//
//function TSkinItem.GetIconRefPicture: TSkinPicture;
//begin
//  Result:=FIconRefPicture;
//end;
//
//function TSkinItem.GetStaticPic: TBaseDrawPicture;
//begin
//  Result:=FPic;
//end;

function TSkinItem.GetObjectByBindItemField(AFieldName: String): TObject;
begin
  Result:=nil;
  if AFieldName='ItemIcon' then
  begin
//    if FIcon<>nil then
//    begin
      Result:=Self.FIcon;//.CurrentPicture;
//    end;
  end
  else if AFieldName='ItemIconRefPicture' then
  begin
    Result:=Self.FIconRefPicture;
  end


  else if AFieldName='ItemPic' then
  begin
//    if FPic<>nil then
//    begin
      Result:=Self.FPic;//.CurrentPicture;
//    end;
  end
  else if AFieldName='ItemPicRefPicture' then
  begin
    Result:=Self.FPicRefPicture;
  end;


end;

function TSkinItem.GetValueByBindItemField(AFieldName: String): Variant;
begin
//  Result.Picture:=nil;

//  if AFieldName='ItemIcon' then
//  begin
//    if FIcon<>nil then
//    begin
//      Result.Picture:=Self.FIcon.CurrentPicture;
//    end;
//  end
//  else
  if AFieldName='ItemIconImageIndex' then
  begin
    Result.Value:=Self.FIconImageIndex;
  end
  else if AFieldName='ItemIconUrl' then
  begin
    Result.Value:=Self.FIcon.Url;
  end
//  else if AFieldName='ItemIconRefPicture' then
//  begin
//    Result.Picture:=Self.FIconRefPicture;
//  end


//  else if AFieldName='ItemPic' then
//  begin
//    if FPic<>nil then
//    begin
//      Result.Picture:=Self.FPic.CurrentPicture;
//    end;
//  end
  else if AFieldName='ItemPicImageIndex' then
  begin
    Result.Value:=Self.FPicImageIndex;
  end
  else if AFieldName='ItemPicUrl' then
  begin
    Result.Value:=Self.FPic.Url;
  end
//  else if AFieldName='ItemPicRefPicture' then
//  begin
//    Result.Picture:=Self.FPicRefPicture;
//  end



//  else if AFieldName='ItemChecked' then
//  begin
//    Result:=FChecked;
//  end
//  else if AFieldName='ItemSelected' then
//  begin
//    Result:=FSelected;
//  end


  else if AFieldName='ItemTag' then
  begin
    Result:=FTag;
  end
  else if AFieldName='ItemTag1' then
  begin
    Result:=FTag1;
  end
  else
  begin
    Result:=Inherited GetValueByBindItemField(AFieldName);
  end;


end;

function TSkinItem.GetValueTypeByBindItemField(AFieldName: String): TVarType;
begin
  Result:=varVariant;
  if (AFieldName='ItemIcon') or (AFieldName='ItemPic') then
  begin
    Result:=varObject;
  end
  else
  begin
    Result:=Inherited GetValueTypeByBindItemField(AFieldName);
  end
//  if (AFieldName='ItemSelected') or (AFieldName='ItemChecked') then
//  begin
//    Result:=varBoolean;
//  end
  ;
end;

function TSkinItem.GetPic: TBaseDrawPicture;
begin
  if FPic=nil then
  begin
    FPic:=TBaseDrawPicture.Create('Pic','图片');
    FPic.OnChange:=Self.DoPicChange;
    FPic.OnGetSkinImageList:=DoGetIconSkinImageList;
    FPic.OnGetDownloadPictureManager:=DoGetDownloadPictureManager;
  end;
  Result:=FPic;
end;

//function TSkinItem.GetPicImageIndex: Integer;
//begin
//  Result:=FPicImageIndex;
//end;
//
//function TSkinItem.GetPicRefPicture: TSkinPicture;
//begin
//  Result:=FPicRefPicture;
//end;



{ TIntfSkinItem }

function TIntfSkinItem.GetAccessory: TSkinAccessoryType;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemAccessory;
end;

function TIntfSkinItem.GetCaption: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemCaption;
end;

//function TIntfSkinItem.GetColor: TDelphiColor;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemColor;
//end;

function TIntfSkinItem.GetDetail: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemDetail;
end;

function TIntfSkinItem.GetDetail1: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemDetail1;
end;

function TIntfSkinItem.GetDetail2: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemDetail2;
end;

function TIntfSkinItem.GetDetail3: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemDetail3;
end;

function TIntfSkinItem.GetDetail4: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemDetail4;
end;

function TIntfSkinItem.GetDetail5: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemDetail5;
end;

function TIntfSkinItem.GetDetail6: String;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemDetail6;
end;

//function TIntfSkinItem.GetIcon: TBaseDrawPicture;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemIcon;
//
//end;
//
//function TIntfSkinItem.GetIconImageIndex: Integer;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemIconImageIndex;
//
//end;
//
//function TIntfSkinItem.GetIconRefPicture: TSkinPicture;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemIconRefPicture;
//
//end;
//
//function TIntfSkinItem.GetPic: TBaseDrawPicture;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemPic;
//
//end;
//
//function TIntfSkinItem.GetPicImageIndex: Integer;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemPicImageIndex;
//
//end;
//
//function TIntfSkinItem.GetPicRefPicture: TSkinPicture;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemPicRefPicture;
//
//end;
//
//function TIntfSkinItem.GetStaticIcon: TBaseDrawPicture;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemIcon;
//
//end;
//
//function TIntfSkinItem.GetStaticPic: TBaseDrawPicture;
//begin
//  Result:=Self.FGetSkinItemDataIntf.GetItemPic;
//
//end;

function TIntfSkinItem.GetSubItems: TStringList;
begin
  Result:=Self.FGetSkinItemDataIntf.GetItemSubItems;
end;

function TIntfSkinItem.GetValueByBindItemField(AFieldName: String): Variant;
var
  ASubItemsIndex:Integer;
begin
  if AFieldName='ItemCaption' then
  begin
    Result:=Self.Caption;
  end
  else if AFieldName='ItemDetail' then
  begin
    Result:=Detail;
  end
  else if AFieldName='ItemDetail1' then
  begin
    Result:=Detail1;
  end
  else if AFieldName='ItemDetail2' then
  begin
    Result:=Detail2;
  end
  else if AFieldName='ItemDetail3' then
  begin
    Result:=Detail3;
  end
  else if AFieldName='ItemDetail4' then
  begin
    Result:=Detail4;
  end
  else if AFieldName='ItemDetail5' then
  begin
    Result:=Detail5;
  end
  else if AFieldName='ItemDetail6' then
  begin
    Result:=Detail6;
  end
  else if AFieldName='ItemIndex' then
  begin
    Result:=IntToStr(Index+1);
  end
  else if AFieldName='ItemAccessory' then
  begin
    Result:=Accessory;
  end
  else if AFieldName='ItemColor' then
  begin
    Result:=FColor.Color;
  end
  else if (SubItems<>nil) and ({$IF CompilerVersion >= 30.0}AFieldName.Substring(0,12){$ELSE}Copy(AFieldName,1,12){$IFEND}='ItemSubItems') then
  begin
      Result:=GetValueByBindItemSubItems(SubItems,AFieldName);

//    ASubItemsIndex:=-1;
//    TryStrToInt(AFieldName.Substring(12,MaxInt),ASubItemsIndex);
//    //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
//    //自动补齐
//    if (ASubItemsIndex>-1) and (ASubItemsIndex<Self.SubItems.Count) then
//    begin
//        Result:=Self.SubItems[ASubItemsIndex];
//    end
//    else
//    begin
//        Result:='';
//    end;
  end
  else if (SubItems<>nil) and (SubItems.IndexOfName(AFieldName)>-1) then
  begin
    Result:=SubItems.Values[AFieldName];
  end
  else
  begin
    Result:=Inherited GetValueByBindItemField(AFieldName);
  end;



end;

//procedure TIntfSkinItem.SetAccessory(const Value: TSkinAccessoryType);
//begin
//
//end;
//
//procedure TIntfSkinItem.SetCaption(const Value: String);
//begin
//
//end;
//
////procedure TIntfSkinItem.SetColor(const Value: TDelphiColor);
////begin
////
////end;
//
//procedure TIntfSkinItem.SetDetail(const Value: String);
//begin
//
//end;
//
//procedure TIntfSkinItem.SetDetail1(const Value: String);
//begin
//
//end;
//
//procedure TIntfSkinItem.SetDetail2(const Value: String);
//begin
//
//end;
//
//procedure TIntfSkinItem.SetDetail3(const Value: String);
//begin
//
//end;
//
//procedure TIntfSkinItem.SetDetail4(const Value: String);
//begin
//
//end;
//
//procedure TIntfSkinItem.SetDetail5(const Value: String);
//begin
//
//end;
//
//procedure TIntfSkinItem.SetDetail6(const Value: String);
//begin
//
//end;
//
////procedure TIntfSkinItem.SetIcon(const Value: TBaseDrawPicture);
////begin
////
////end;
////
////procedure TIntfSkinItem.SetIconImageIndex(const Value: Integer);
////begin
////
////end;
////
////procedure TIntfSkinItem.SetIconRefPicture(const Value: TSkinPicture);
////begin
////
////end;
////
////procedure TIntfSkinItem.SetPic(const Value: TBaseDrawPicture);
////begin
////
////end;
////
////procedure TIntfSkinItem.SetPicImageIndex(const Value: Integer);
////begin
////
////end;
////
////procedure TIntfSkinItem.SetPicRefPicture(const Value: TSkinPicture);
////begin
////
////end;
//
//procedure TIntfSkinItem.SetSubItems(const Value: TStringList);
//begin
//
//end;




//
//{ TRealSkinTreeViewItem }
//
//procedure TRealSkinTreeViewItem.AssignTo(Dest: TPersistent);
//var
//  DestObject:TRealSkinTreeViewItem;
//begin
//
//  if Dest is TRealSkinTreeViewItem then
//  begin
//    DestObject:=Dest as TRealSkinTreeViewItem;
//
//    DestObject.FChilds.Assign(Self.FChilds);
//    DestObject.FExpanded:=Self.FExpanded;
//    DestObject.FIsParent:=Self.FIsParent;
//  end;
//
//  Inherited AssignTo(Dest);
//end;
//
//procedure TRealSkinTreeViewItem.ClearItemRect;
//var
//  I: Integer;
//begin
//  inherited;
//  for I := 0 to Self.Childs.Count-1 do
//  begin
//
//  end;
//end;
//
//constructor TRealSkinTreeViewItem.Create(AOwner: TBaseSkinItems);
//begin
//  inherited;
//
//  //默认展开
//  FExpanded:=True;
//
//  //子节点列表
//  FChilds:=TRealSkinTreeViewItems.Create(Self);
//end;
//
//function TRealSkinTreeViewItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I: Integer;
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited LoadFromDocNode(ADocNode);
//
//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
//
//    if ABTNode.NodeName='Childs' then
//    begin
//      Self.FChilds.LoadFromDocNode(ABTNode.ConvertNode_Directory);
//    end
//    else if ABTNode.NodeName='Expanded' then
//    begin
//      FExpanded:=ABTNode.ConvertNode_Bool32.Data;
//    end
//    else if ABTNode.NodeName='IsParent' then
//    begin
//      FIsParent:=ABTNode.ConvertNode_Bool32.Data;
//    end
//    ;
//
//  end;
//
//  Result:=True;
//end;
//
//function TRealSkinTreeViewItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
//  ABTNode:=ADocNode.AddChildNode_Directory('Childs','子节点列表');
//  Self.FChilds.SaveToDocNode(ABTNode.ConvertNode_Directory);
//
//  ABTNode:=ADocNode.AddChildNode_Bool32('Expanded','展开');
//  ABTNode.ConvertNode_Bool32.Data:=FExpanded;
//
//  ABTNode:=ADocNode.AddChildNode_Bool32('IsParent','父节点');
//  ABTNode.ConvertNode_Bool32.Data:=FIsParent;
//
//  Result:=True;
//end;
//
//destructor TRealSkinTreeViewItem.Destroy;
//begin
//  SetParent(nil);
//
//  FreeAndNil(FChilds);
//
//  inherited;
//
//end;
//
//function TRealSkinTreeViewItem.GetIsParent: Boolean;
//begin
//  Result := FIsParent or (FChilds<>nil) and (FChilds.Count>0);
//end;
//
//function TRealSkinTreeViewItem.GetListLayoutsManager:TSkinListLayoutsManager;
//var
//  AParentItem:TRealSkinTreeViewItem;
//begin
//  Result:=Inherited;
//  if (Result=nil) then
//  begin
//    AParentItem:=Self.FParent;
//
//    while (AParentItem<>nil) do
//    begin
//      Result:=AParentItem.GetListLayoutsManager;
//      if (Result<>nil) then
//      begin
//        Break;
//      end;
//      AParentItem:=AParentItem.FParent;
//    end;
//
//  end;
//end;
//
//function TRealSkinTreeViewItem.GetItems: TBaseSkinItems;
//begin
//  Result:=Self.FChilds;
//end;
//
//function TRealSkinTreeViewItem.GetLevel: Integer;
//var
//  AParent:TRealSkinTreeViewItem;
//begin
//  Result:=0;
//  if FParent<>nil then
//  begin
//    Inc(Result);
//    AParent:=Self.FParent.FParent;
//
//    while AParent<>nil do
//    begin
//      Inc(Result);
//
//      AParent:=AParent.FParent;
//    end;
//  end;
//
//end;
//
//procedure TRealSkinTreeViewItem.SetChilds(const Value: TRealSkinTreeViewItems);
//begin
//  FChilds.Assign(Value);
//end;
//
//procedure TRealSkinTreeViewItem.SetExpanded(const Value: Boolean);
//begin
//  if FExpanded<>Value then
//  begin
//    FExpanded := Value;
//
//    Self.DoPropChange;
//
//    if Self.FChilds.Count>0 then
//    begin
//      Self.DoVisibleChange;
//    end;
//  end;
//end;
//
//procedure TRealSkinTreeViewItem.SetIsParent(const Value: Boolean);
//begin
//  if FIsParent<>Value then
//  begin
//    FIsParent:=Value;
//    Self.DoSizeChange;
//    Self.DoPropChange;
//  end;
//end;
//
//procedure TRealSkinTreeViewItem.SetParent(const Value: TRealSkinTreeViewItem);
//begin
//  if FParent<>Value then
//  begin
//    //从原父节点中去除
//    if (FParent<>nil) and (FParent.FChilds<>nil) then
//    begin
//      //其实在Remove中调用DoChange就会调用DoVisibleChange
//      FParent.FChilds.Remove(Self,False);
//    end;
//
//    FParent := Value;
//
//    //加入新父节点中
//    if (FParent<>nil) and (FParent.FChilds<>nil) then
//    begin
//      //在这里会设置SkinListIntf
//      //其实在Remove中调用DoChange就会调用DoVisibleChange
//      FParent.FChilds.Add(Self);
//    end;
//
//  end;
//end;



{ TRealSkinTreeViewItems }

//procedure TRealSkinTreeViewItems.CollapseAll(Level: Integer);
//begin
//  SetAllExpandState(False,Level);
//end;
//
//constructor TRealSkinTreeViewItems.Create(AParent:TRealSkinTreeViewItem;
//                                      AObjectOwnership:TObjectOwnership=ooOwned;
//                                      CreateObjectChange:Boolean=True);
//begin
//  Inherited Create(AObjectOwnership,CreateObjectChange);
//  FParent:=AParent;
//end;

function TRealSkinTreeViewItems.Add: TRealSkinTreeViewItem;
begin
  Result:=TRealSkinTreeViewItem(Inherited Add);
end;

//procedure TRealSkinTreeViewItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TRealSkinTreeViewItem;
//end;

function TRealSkinTreeViewItems.Insert(Index:Integer):TRealSkinTreeViewItem;
begin
  Result:=TRealSkinTreeViewItem(Inherited Insert(Index));
end;

//procedure TRealSkinTreeViewItems.SetAllExpandState(State: Boolean; Level: Integer);
//begin
//  SetTreeViewItemsAllExpandState(Self,State,Level);
//end;

procedure TRealSkinTreeViewItems.SetItem(Index: Integer;const Value: TRealSkinTreeViewItem);
begin
  Inherited Items[Index]:=Value;
end;

//procedure TRealSkinTreeViewItems.SetTreeViewItemsAllExpandState(
//  ATreeViewItems: TRealSkinTreeViewItems; State: Boolean; Level: Integer);
//var
//  I: Integer;
//begin
//  for I := 0 to ATreeViewItems.Count-1 do
//  begin
//    if (Level=-1)
//      or (    (ATreeViewItems[I].Level<=Level) and (State=True)
//          or (ATreeViewItems[I].Level>=Level) and (State=False)
//          ) then
//    begin
//      ATreeViewItems[I].Expanded:=State;
//    end;
//    SetTreeViewItemsAllExpandState(ATreeViewItems[I].FChilds,State,Level);
//  end;
//end;
//
//function TRealSkinTreeViewItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=Inherited;//SkinItemClass.Create;//(Self);
//  TRealSkinTreeViewItem(Result).FParent:=Self.FParent;
//end;
//
//procedure TRealSkinTreeViewItems.DoDelete(AObject: TObject; AIndex: Integer);
//var
//  ARootOwner:TRealSkinTreeViewItems;
//begin
//  inherited;
//
//
//  //如果父节点删除子节点,要通知到顶层节点
//  //VirtualList的顶层节点要清除MouseDownItem,MouseMoveItem等引用
//
//
//  ARootOwner:=Self.GetRootOwner;
//  if (ARootOwner<>nil) and (ARootOwner<>Self) then
//  begin
//    ARootOwner.DoDelete(AObject,AIndex);//调用VirtualList.DoItemDelete,因为VirtualList.DoItemDelete只赋给顶层的List
//  end;
//end;
//
////procedure TRealSkinTreeViewItems.DoItemPropChange(Sender:TObject;IsCheckNeed:Boolean=False);
////var
////  ARootOwner:TRealSkinTreeViewItems;
////begin
////  ARootOwner:=Self.GetRootOwner;
////  if (ARootOwner<>nil) and (ARootOwner<>Self) then
////  begin
////    ARootOwner.DoItemPropChange(Self);
////  end
////  else
////  begin
////    inherited;
////  end;
////end;
////
////procedure TRealSkinTreeViewItems.DoItemSizeChange(Sender:TObject;IsCheckNeed:Boolean=False);
////var
////  ARootOwner:TRealSkinTreeViewItems;
////begin
////  ARootOwner:=Self.GetRootOwner;
////  if (ARootOwner<>nil) and (ARootOwner<>Self) then
////  begin
////    ARootOwner.DoItemSizeChange(Self);
////  end
////  else
////  begin
////    inherited;
////  end;
////end;
////
////procedure TRealSkinTreeViewItems.DoItemVisibleChange(Sender:TObject;IsCheckNeed:Boolean=False);
////var
////  ARootOwner:TRealSkinTreeViewItems;
////begin
////  ARootOwner:=Self.GetRootOwner;
////  if (ARootOwner<>nil) and (ARootOwner<>Self) then
////  begin
////    ARootOwner.DoItemVisibleChange(Self);
////  end
////  else
////  begin
////    inherited;
////  end;
////end;
//
//procedure TRealSkinTreeViewItems.ExpanedAll(Level: Integer);
//begin
//  SetAllExpandState(True,Level);
//end;

function TRealSkinTreeViewItems.FindItemByCaption(const Caption: String): TRealSkinTreeViewItem;
var
  I: Integer;
begin
  Result:=TRealSkinTreeViewItem(TSkinItems(Self).FindItemByCaption(Caption));
  if Result=nil then
  begin
    for I := 0 to Self.Count-1 do
    begin
      Result:=TRealSkinTreeViewItem(TRealSkinTreeViewItems(Items[I].FChilds).FindItemByCaption(Caption));
      if Result<>nil then Exit;
    end;
  end;
end;

function TRealSkinTreeViewItems.FindItemByName(const Name: String): TRealSkinTreeViewItem;
var
  I: Integer;
begin
  Result:=TRealSkinTreeViewItem(TSkinItems(Self).FindItemByName(Name));
  if Result=nil then
  begin
    for I := 0 to Self.Count-1 do
    begin
      Result:=TRealSkinTreeViewItem(TRealSkinTreeViewItems(Items[I].FChilds).FindItemByName(Name));
      if Result<>nil then Exit;
    end;
  end;
end;

function TRealSkinTreeViewItems.FindItemByData(const Data: Pointer): TRealSkinTreeViewItem;
var
  I: Integer;
begin
  Result:=TRealSkinTreeViewItem(TSkinItems(Self).FindItemByData(Data));
  if Result=nil then
  begin
    for I := 0 to Self.Count-1 do
    begin
      Result:=TRealSkinTreeViewItem(TRealSkinTreeViewItems(Items[I].FChilds).FindItemByData(Data));
      if Result<>nil then Exit;
    end;
  end;
end;

function TRealSkinTreeViewItems.GetItem(Index: Integer): TRealSkinTreeViewItem;
begin
  Result:=TRealSkinTreeViewItem(Inherited Items[Index]);
end;

function TRealSkinTreeViewItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TRealSkinTreeViewItem;
end;

//function TRealSkinTreeViewItems.GetListLayoutsManager: TSkinListLayoutsManager;
//begin
//  Result:=Inherited;
//  if (Result=nil) and (Self.FParent<>nil) then
//  begin
//    Result:=FParent.GetListLayoutsManager;
//  end;
//end;
//
//function TRealSkinTreeViewItems.GetRootOwner: TRealSkinTreeViewItems;
//begin
//  Result:=nil;
//  if (Self.FParent<>nil) then
//  begin
//    Result:=TRealSkinTreeViewItems(Self.FParent.FOwner);
//    while (Result<>nil) and (Result.FParent<>nil) and (Result.FParent.FOwner<>nil) do
//    begin
//      Result:=TRealSkinTreeViewItems(Result.FParent.FOwner);
//    end;
//  end;
//end;



{ TSkinTreeViewLayoutsManager }

function TSkinTreeViewLayoutsManager.CalcItemHeight(AItem: ISkinItem): Double;
begin
  if (Self.FItemSizeCalcType<>isctFixed)
    and TBaseSkinTreeViewItem(AItem.GetObject).IsParent
    and IsSameDouble(AItem.Height,Const_Tag_UseListItemHeight)
    and BiggerDouble(Self.FParentItemHeight,0) then
  begin
    Result:=FParentItemHeight;
  end
  else
  begin
    Result:=Inherited CalcItemHeight(AItem);
  end;
end;

function TSkinTreeViewLayoutsManager.CalcItemLevelLeftOffsetAtVerticalLayout(AItem: ISkinItem): Double;
begin
  //根据层级
  Result:=AItem.GetLevel*Self.FLevelLeftOffset;
end;

function TSkinTreeViewLayoutsManager.CalcItemLevelRightIsFitControlWidthAtVerticalLayout: Boolean;
begin
  Result:=Self.FLevelRightIsFitControlWidth;
end;

function TSkinTreeViewLayoutsManager.CalcItemWidth(AItem: ISkinItem): Double;
begin
  Result:=Inherited CalcItemWidth(AItem);

  if CalcItemLevelRightIsFitControlWidthAtVerticalLayout then
  begin
    Result:=Result-CalcItemLevelLeftOffsetAtVerticalLayout(AItem);
  end;
end;

procedure TSkinTreeViewLayoutsManager.CalcVisibleItems;
begin
  if FIsNeedReCalcVisibleItems then
  begin
    FIsNeedReCalcVisibleItems:=False;

    Self.FVisibleItems.Clear(False);
    DoCalcVisibleItems(TBaseSkinTreeViewItems(Self.FSkinListIntf.GetObject));
  end;
end;

constructor TSkinTreeViewLayoutsManager.Create(ASkinList:ISkinList);
begin
  Inherited Create(ASkinList);

  FParentItemHeight:=-1;
  FLevelLeftOffset:=0;
  FLevelRightIsFitControlWidth:=False;
end;

destructor TSkinTreeViewLayoutsManager.Destroy;
begin
  inherited;
end;

procedure TSkinTreeViewLayoutsManager.SetLevelLeftOffset(const Value: TControlSize);
begin
  if FLevelLeftOffset<>Value then
  begin
    FLevelLeftOffset := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinTreeViewLayoutsManager.SetLevelRightIsFitControlWidth(
  const Value: Boolean);
begin
  if FLevelRightIsFitControlWidth<>Value then
  begin
    FLevelRightIsFitControlWidth := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinTreeViewLayoutsManager.SetParentItemHeight(const Value: TControlSize);
begin
  if FParentItemHeight<>Value then
  begin
    FParentItemHeight := Value;
    DoItemSizeChange(Self);
  end;
end;

procedure TSkinTreeViewLayoutsManager.DoCalcAllItems(AllItems:TBaseList;AItems: TBaseSkinTreeViewItems);
var
  I:Integer;
  AItem:TBaseSkinTreeViewItem;
begin
  for I:=0 to AItems.Count - 1 do
  begin
    AItem:=AItems.Items[I];
    AllItems.Add(AItem);
    //如果包含子节点,那么加入子节点列表
    if (AItem.FChilds.Count > 0) then
    begin
      DoCalcAllItems(AllItems,AItem.FChilds);
    end;
  end;
end;

procedure TSkinTreeViewLayoutsManager.DoCalcVisibleItems(AItems:TBaseSkinTreeViewItems);
var
  I:Integer;
  AVisible:Boolean;
  AItem:TBaseSkinTreeViewItem;
begin
  for I:=0 to AItems.Count - 1 do
  begin
    AItem:=AItems.Items[I];

    //如果是根节点,那么直接显示,如果是子节点,那么如果父节点显示,那么子节点它也显示
    if AItems.FParent = nil then
    begin
      AVisible:=AItem.FVisible;
    end
    else
    begin
      AVisible:=AItems.FParent.Expanded and AItem.FVisible;
    end;


    //加入显示的项目列表中,计算是否需要绘制
    if AVisible then
    begin
      FVisibleItems.Add(AItem);
    end;

    //如果包含子节点,那么加入子节点列表
    if AVisible and AItem.Expanded and (AItem.FChilds.Count > 0) then
    begin
      DoCalcVisibleItems(AItem.FChilds);
    end;

  end;
end;








{ TBaseSkinTreeViewItem }

//procedure TBaseSkinTreeViewItem.AfterConstruction;
//begin
//  inherited;
//
//
//  //默认展开
//  FExpanded:=True;
//
//  //子节点列表
//  FChilds:=GetChildsClass.Create(Self);
//end;

procedure TBaseSkinTreeViewItem.AssignTo(Dest: TPersistent);
var
  DestObject:TBaseSkinTreeViewItem;
begin

  if Dest is TBaseSkinTreeViewItem then
  begin
    DestObject:=Dest as TBaseSkinTreeViewItem;

    DestObject.FChilds.Assign(Self.FChilds);
    DestObject.FExpanded:=Self.FExpanded;
    DestObject.FIsParent:=Self.FIsParent;
  end;

  Inherited AssignTo(Dest);
end;

procedure TBaseSkinTreeViewItem.ClearItemRect;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Self.Childs.Count-1 do
  begin

  end;
end;

constructor TBaseSkinTreeViewItem.Create;
begin
  inherited;

  //默认展开
  FExpanded:=True;

  //子节点列表
  FChilds:=GetChildsClass.Create(Self);
end;

function TBaseSkinTreeViewItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Childs' then
    begin
      Self.FChilds.LoadFromDocNode(ABTNode.ConvertNode_Directory);
    end
    else if ABTNode.NodeName='Expanded' then
    begin
      FExpanded:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsParent' then
    begin
      FIsParent:=ABTNode.ConvertNode_Bool32.Data;
    end
    ;

  end;

  Result:=True;
end;

function TBaseSkinTreeViewItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Directory('Childs','子节点列表');
  Self.FChilds.SaveToDocNode(ABTNode.ConvertNode_Directory);

  ABTNode:=ADocNode.AddChildNode_Bool32('Expanded','展开');
  ABTNode.ConvertNode_Bool32.Data:=FExpanded;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsParent','父节点');
  ABTNode.ConvertNode_Bool32.Data:=FIsParent;

  Result:=True;
end;

destructor TBaseSkinTreeViewItem.Destroy;
begin
  SetParent(nil);

  FreeAndNil(FChilds);

  inherited;

end;

function TBaseSkinTreeViewItem.GetIsParent: Boolean;
begin
  Result := FIsParent or (FChilds<>nil) and (FChilds.Count>0);
end;

function TBaseSkinTreeViewItem.GetListLayoutsManager:TSkinListLayoutsManager;
var
  AParentItem:TBaseSkinTreeViewItem;
begin
  Result:=Inherited;
  if (Result=nil) then
  begin
    AParentItem:=Self.FParent;

    while (AParentItem<>nil) do
    begin
      Result:=AParentItem.GetListLayoutsManager;
      if (Result<>nil) then
      begin
        Break;
      end;
      AParentItem:=AParentItem.FParent;
    end;

  end;
end;

function TBaseSkinTreeViewItem.GetChildsClass: TBaseSkinTreeViewItemsClass;
begin
  Result:=TBaseSkinTreeViewItems;
end;

function TBaseSkinTreeViewItem.GetItems: TBaseSkinItems;
begin
  Result:=Self.FChilds;
end;

function TBaseSkinTreeViewItem.GetLevel: Integer;
var
  AParent:TBaseSkinTreeViewItem;
begin
  Result:=0;
  if FParent<>nil then
  begin
    Inc(Result);
    AParent:=Self.FParent.FParent;

    while AParent<>nil do
    begin
      Inc(Result);

      AParent:=AParent.FParent;
    end;
  end;

end;

procedure TBaseSkinTreeViewItem.SetChilds(const Value: TBaseSkinTreeViewItems);
begin
  FChilds.Assign(Value);
end;

procedure TBaseSkinTreeViewItem.SetExpanded(const Value: Boolean);
begin
  if FExpanded<>Value then
  begin
    FExpanded := Value;



    if (Self.GetListLayoutsManager<>nil) then
    begin
      Self.GetListLayoutsManager.DoItemExpandedChange(Self);
    end;



    Self.DoPropChange;

    if Self.FChilds.Count>0 then
    begin
      Self.DoVisibleChange;
    end;
  end;
end;

procedure TBaseSkinTreeViewItem.SetIsParent(const Value: Boolean);
begin
  if FIsParent<>Value then
  begin
    FIsParent:=Value;
    Self.DoSizeChange;
    Self.DoPropChange;
  end;
end;

procedure TBaseSkinTreeViewItem.SetParent(const Value: TBaseSkinTreeViewItem);
begin
  if FParent<>Value then
  begin
    //从原父节点中去除
    if (FParent<>nil) and (FParent.FChilds<>nil) then
    begin
      //其实在Remove中调用DoChange就会调用DoVisibleChange
      FParent.FChilds.Remove(Self,False);
    end;

    FParent := Value;

    //加入新父节点中
    if (FParent<>nil) and (FParent.FChilds<>nil) then
    begin
      //在这里会设置SkinListIntf
      //其实在Remove中调用DoChange就会调用DoVisibleChange
      FParent.FChilds.Add(Self);
    end;

  end;
end;




{ TBaseSkinTreeViewItems }

procedure TBaseSkinTreeViewItems.CollapseAll(Level: Integer);
begin
  SetAllExpandState(False,Level);
end;

constructor TBaseSkinTreeViewItems.Create(AParent:TBaseSkinTreeViewItem;
                                      AObjectOwnership:TObjectOwnership=ooOwned;
                                      CreateObjectChange:Boolean=True);
begin
  Inherited Create(AObjectOwnership,CreateObjectChange);
  FParent:=AParent;
end;

function TBaseSkinTreeViewItems.Add: TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited Add);
end;

//procedure TBaseSkinTreeViewItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TBaseSkinTreeViewItem;
//end;

function TBaseSkinTreeViewItems.Insert(Index:Integer):TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited Insert(Index));
end;

procedure TBaseSkinTreeViewItems.SetAllExpandState(State: Boolean; Level: Integer);
begin
  SetTreeViewItemsAllExpandState(Self,State,Level);
end;

procedure TBaseSkinTreeViewItems.SetItem(Index: Integer;const Value: TBaseSkinTreeViewItem);
begin
  Inherited Items[Index]:=Value;
end;

procedure TBaseSkinTreeViewItems.SetTreeViewItemsAllExpandState(
  ATreeViewItems: TBaseSkinTreeViewItems; State: Boolean; Level: Integer);
var
  I: Integer;
begin
  for I := 0 to ATreeViewItems.Count-1 do
  begin
    if (Level=-1)
      or (    (ATreeViewItems[I].Level<=Level) and (State=True)
          or (ATreeViewItems[I].Level>=Level) and (State=False)
          ) then
    begin
      ATreeViewItems[I].Expanded:=State;
    end;
    SetTreeViewItemsAllExpandState(ATreeViewItems[I].FChilds,State,Level);
  end;
end;

function TBaseSkinTreeViewItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
begin
  Result:=Inherited;//SkinItemClass.Create;//(Self);
  TBaseSkinTreeViewItem(Result).FParent:=Self.FParent;
end;

procedure TBaseSkinTreeViewItems.DoDelete(AObject: TObject; AIndex: Integer);
var
  ARootOwner:TBaseSkinTreeViewItems;
begin
  inherited;


  //如果父节点删除子节点,要通知到顶层节点
  //VirtualList的顶层节点要清除MouseDownItem,MouseMoveItem等引用


  ARootOwner:=Self.GetRootOwner;
  if (ARootOwner<>nil) and (ARootOwner<>Self) then
  begin
    ARootOwner.DoDelete(AObject,AIndex);//调用VirtualList.DoItemDelete,因为VirtualList.DoItemDelete只赋给顶层的List
  end;
end;

//procedure TBaseSkinTreeViewItems.DoItemPropChange(Sender:TObject;IsCheckNeed:Boolean=False);
//var
//  ARootOwner:TBaseSkinTreeViewItems;
//begin
//  ARootOwner:=Self.GetRootOwner;
//  if (ARootOwner<>nil) and (ARootOwner<>Self) then
//  begin
//    ARootOwner.DoItemPropChange(Self);
//  end
//  else
//  begin
//    inherited;
//  end;
//end;
//
//procedure TBaseSkinTreeViewItems.DoItemSizeChange(Sender:TObject;IsCheckNeed:Boolean=False);
//var
//  ARootOwner:TBaseSkinTreeViewItems;
//begin
//  ARootOwner:=Self.GetRootOwner;
//  if (ARootOwner<>nil) and (ARootOwner<>Self) then
//  begin
//    ARootOwner.DoItemSizeChange(Self);
//  end
//  else
//  begin
//    inherited;
//  end;
//end;
//
//procedure TBaseSkinTreeViewItems.DoItemVisibleChange(Sender:TObject;IsCheckNeed:Boolean=False);
//var
//  ARootOwner:TBaseSkinTreeViewItems;
//begin
//  ARootOwner:=Self.GetRootOwner;
//  if (ARootOwner<>nil) and (ARootOwner<>Self) then
//  begin
//    ARootOwner.DoItemVisibleChange(Self);
//  end
//  else
//  begin
//    inherited;
//  end;
//end;

procedure TBaseSkinTreeViewItems.ExpanedAll(Level: Integer);
begin
  SetAllExpandState(True,Level);
end;

//function TBaseSkinTreeViewItems.FindItemByCaption(const Caption: String): TBaseSkinTreeViewItem;
//var
//  I: Integer;
//begin
//  Result:=TBaseSkinTreeViewItem(TSkinItems(Self).FindItemByCaption(Caption));
//  if Result=nil then
//  begin
//    for I := 0 to Self.Count-1 do
//    begin
//      Result:=TBaseSkinTreeViewItem(TBaseSkinTreeViewItems(Items[I].FChilds).FindItemByCaption(Caption));
//      if Result<>nil then Exit;
//    end;
//  end;
//end;
//
//function TBaseSkinTreeViewItems.FindItemByName(const Name: String): TBaseSkinTreeViewItem;
//var
//  I: Integer;
//begin
//  Result:=TBaseSkinTreeViewItem(TSkinItems(Self).FindItemByName(Name));
//  if Result=nil then
//  begin
//    for I := 0 to Self.Count-1 do
//    begin
//      Result:=TBaseSkinTreeViewItem(TBaseSkinTreeViewItems(Items[I].FChilds).FindItemByName(Name));
//      if Result<>nil then Exit;
//    end;
//  end;
//end;
//
//function TBaseSkinTreeViewItems.FindItemByData(const Data: Pointer): TBaseSkinTreeViewItem;
//var
//  I: Integer;
//begin
//  Result:=TBaseSkinTreeViewItem(TSkinItems(Self).FindItemByData(Data));
//  if Result=nil then
//  begin
//    for I := 0 to Self.Count-1 do
//    begin
//      Result:=TBaseSkinTreeViewItem(TBaseSkinTreeViewItems(Items[I].FChilds).FindItemByData(Data));
//      if Result<>nil then Exit;
//    end;
//  end;
//end;

function TBaseSkinTreeViewItems.GetItem(Index: Integer): TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited Items[Index]);
end;

function TBaseSkinTreeViewItems.GetListLayoutsManager: TSkinListLayoutsManager;
begin
  Result:=Inherited;
  if (Result=nil) and (Self.FParent<>nil) then
  begin
    Result:=FParent.GetListLayoutsManager;
  end;
end;

function TBaseSkinTreeViewItems.GetRootOwner: TBaseSkinTreeViewItems;
begin
  Result:=nil;
  if (Self.FParent<>nil) then
  begin
    Result:=TBaseSkinTreeViewItems(Self.FParent.FOwner);
    while (Result<>nil) and (Result.FParent<>nil) and (Result.FParent.FOwner<>nil) do
    begin
      Result:=TBaseSkinTreeViewItems(Result.FParent.FOwner);
    end;
  end;
end;

function TBaseSkinTreeViewItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TBaseSkinTreeViewItem;
end;

{ TRealSkinTreeViewItem }

procedure TRealSkinTreeViewItem.AssignTo(Dest: TPersistent);
var
  DestObject:TRealSkinTreeViewItem;
begin
  if Dest is TRealSkinTreeViewItem then
  begin

    DestObject:=Dest as TRealSkinTreeViewItem;

    DestObject.FCaption:=Self.FCaption;

    DestObject.FAccessory:=Self.FAccessory;
    if Self.FSubItems=nil then
    begin
      FreeAndNil(DestObject.FSubItems);
    end
    else
    begin
      DestObject.SubItems.Assign(Self.FSubItems);
    end;


    DestObject.FDetail:=Self.FDetail;
    DestObject.FDetail1:=Self.FDetail1;
    DestObject.FDetail2:=Self.FDetail2;
    DestObject.FDetail3:=Self.FDetail3;
    DestObject.FDetail4:=Self.FDetail4;
    DestObject.FDetail5:=Self.FDetail5;
    DestObject.FDetail6:=Self.FDetail6;

    DestObject.FJson:=Self.FJson;
    DestObject.FJsonStr:=Self.FJsonStr;


    //inherited里面已经有了DestObject.DoPropChange;
    inherited;

  end
  else
  begin
    inherited;
  end;
end;

//procedure TRealSkinTreeViewItem.ClearData(AFieldName:String);
//begin
//  Self.SetValueByBindItemField(AFieldName,'');
//
////  case AItemDataType of
////    idtNone: ;
////    idtCaption: Self.FCaption:='';
////
////
//////    idtIcon: if Self.FIcon<>nil then FIcon.Clear;
//////    idtPic: if Self.FPic<>nil then FPic.Clear;
//////    idtChecked: Self.FChecked:=False;
//////    idtSelected: Self.FSelected:=False;
////
////
////    idtAccessory: Self.FAccessory:=TSkinAccessoryType.satNone;
////    idtDetail: Self.FDetail:='';
////    idtDetail1: Self.FDetail1:='';
////    idtDetail2: Self.FDetail2:='';
////    idtDetail3: Self.FDetail3:='';
////    idtDetail4: Self.FDetail4:='';
////    idtDetail5: Self.FDetail5:='';
////    idtDetail6: Self.FDetail6:='';
////    idtSubItems: Self.SubItems.Clear;
////  end;
//
//end;

//procedure TRealSkinTreeViewItem.ClearData(AItemDataType:TSkinItemDataType);
//begin
//  case AItemDataType of
//    idtNone: ;
//    idtCaption: Self.FCaption:='';
//
//
////    idtIcon: if Self.FIcon<>nil then FIcon.Clear;
////    idtPic: if Self.FPic<>nil then FPic.Clear;
////    idtChecked: Self.FChecked:=False;
////    idtSelected: Self.FSelected:=False;
//
//
//    idtAccessory: Self.FAccessory:=TSkinAccessoryType.satNone;
//    idtDetail: Self.FDetail:='';
//    idtDetail1: Self.FDetail1:='';
//    idtDetail2: Self.FDetail2:='';
//    idtDetail3: Self.FDetail3:='';
//    idtDetail4: Self.FDetail4:='';
//    idtDetail5: Self.FDetail5:='';
//    idtDetail6: Self.FDetail6:='';
//    idtSubItems: Self.SubItems.Clear;
//  end;
//
//end;

//constructor TRealSkinTreeViewItem.Create;
//begin
//  inherited;
//
//end;

destructor TRealSkinTreeViewItem.Destroy;
begin
  FreeAndNil(FSubItems);

  inherited;
end;

function TRealSkinTreeViewItem.GetAccessory: TSkinAccessoryType;
begin
  Result:=FAccessory;
end;

function TRealSkinTreeViewItem.GetCaption: String;
begin
  Result:=FCaption;
end;

function TRealSkinTreeViewItem.GetChilds: TRealSkinTreeViewItems;
begin
  Result:=TRealSkinTreeViewItems(FChilds);
end;

function TRealSkinTreeViewItem.GetChildsClass: TBaseSkinTreeViewItemsClass;
begin
  Result:=TRealSkinTreeViewItems;
end;

function TRealSkinTreeViewItem.GetDetail: String;
begin
  Result:=FDetail;
end;

function TRealSkinTreeViewItem.GetDetail1: String;
begin
  Result:=FDetail1;
end;

function TRealSkinTreeViewItem.GetDetail2: String;
begin
  Result:=FDetail2;
end;

function TRealSkinTreeViewItem.GetDetail3: String;
begin
  Result:=FDetail3;
end;

function TRealSkinTreeViewItem.GetDetail4: String;
begin
  Result:=FDetail4;
end;

function TRealSkinTreeViewItem.GetDetail5: String;
begin
  Result:=FDetail5;
end;

function TRealSkinTreeViewItem.GetDetail6: String;
begin
  Result:=FDetail6;
end;

function TRealSkinTreeViewItem.GetSubItems: TStringList;
begin
  if FSubItems=nil then
  begin
    FSubItems:=TStringList.Create;
  end;
  Result:=FSubItems;
end;


procedure TRealSkinTreeViewItem.SetValueByBindItemField(AFieldName: String;AValue: Variant;APageDataDir:String;AImageServerUrl:String);
//var
//  I:Integer;
//  ASubItemsIndex:Integer;
begin
  if AFieldName='ItemCaption' then
  begin
    Self.Caption:=AValue;
  end
  else if AFieldName='ItemDetail' then
  begin
    Detail:=AValue;
  end
  else if AFieldName='ItemDetail1' then
  begin
    Detail1:=AValue;
  end
  else if AFieldName='ItemDetail2' then
  begin
    Detail2:=AValue;
  end
  else if AFieldName='ItemDetail3' then
  begin
    Detail3:=AValue;
  end
  else if AFieldName='ItemDetail4' then
  begin
    Detail4:=AValue;
  end
  else if AFieldName='ItemDetail5' then
  begin
    Detail5:=AValue;
  end
  else if AFieldName='ItemDetail6' then
  begin
    Detail6:=AValue;
  end
  else if AFieldName='ItemAccessory' then
  begin
    Accessory:=AValue;
  end
  else if AFieldName='ItemColor' then
  begin
    FColor.Color:=AValue;
  end
  else if NewDelphiSubString(AFieldName,0,12)='ItemSubItems' then
  begin
      SetValueByBindItemSubItems(SubItems,AFieldName,AValue,APageDataDir,AImageServerUrl);

//    ASubItemsIndex:=-1;
//    TryStrToInt(AFieldName.Substring(12,MaxInt),ASubItemsIndex);
//    //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
//    //自动补齐
//    //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
//    //自动补齐
//    if (ASubItemsIndex>-1) and (ASubItemsIndex<Self.SubItems.Count) then
//    begin
//        Self.SubItems[ASubItemsIndex]:=AValue;
//    end
//    else if ASubItemsIndex>=Self.SubItems.Count then
//    begin
//        for I := 0 to ASubItemsIndex-Self.SubItems.Count-1 do
//        begin
//          Self.SubItems.Add('');
//        end;
//        Self.SubItems.Add(AValue);
//    end;

  end
  else if SubItems.IndexOfName(AFieldName)>-1 then
  begin
      SubItems.Values[AFieldName]:=AValue;
  end
  else
  begin
    Inherited SetValueByBindItemField(AFieldName,AValue,APageDataDir,AImageServerUrl);
  end;

end;


function TRealSkinTreeViewItem.GetValueByBindItemField(AFieldName: String): Variant;
var
  ASubItemsIndex:Integer;
begin
  if AFieldName='ItemCaption' then
  begin
    Result:=Self.FCaption;
  end
  else if AFieldName='ItemDetail' then
  begin
    Result:=FDetail;
  end
  else if AFieldName='ItemDetail1' then
  begin
    Result:=FDetail1;
  end
  else if AFieldName='ItemDetail2' then
  begin
    Result:=FDetail2;
  end
  else if AFieldName='ItemDetail3' then
  begin
    Result:=FDetail3;
  end
  else if AFieldName='ItemDetail4' then
  begin
    Result:=FDetail4;
  end
  else if AFieldName='ItemDetail5' then
  begin
    Result:=FDetail5;
  end
  else if AFieldName='ItemDetail6' then
  begin
    Result:=FDetail6;
  end
  else if AFieldName='ItemIndex' then
  begin
    Result:=IntToStr(Index+1);
  end
  else if AFieldName='ItemAccessory' then
  begin
    Result:=FAccessory;
  end
  else if AFieldName='ItemColor' then
  begin
    Result:=FColor.Color;
  end
  else if AFieldName='ItemExpanded' then
  begin
    Result:=Self.FExpanded;
  end
  else if NewDelphiSubString(AFieldName,0,12)='ItemSubItems' then
  begin
      Result:=GetValueByBindItemSubItems(SubItems,AFieldName);

//    ASubItemsIndex:=-1;
//    TryStrToInt(AFieldName.Substring(12,MaxInt),ASubItemsIndex);
//    //如ASubItemsIndex=3,需要4个,AItem.SubItems.Count=2,还差2个
//    //自动补齐
//    if (ASubItemsIndex>-1) and (ASubItemsIndex<Self.SubItems.Count) then
//    begin
//        Result:=Self.SubItems[ASubItemsIndex];
//    end;
  end
  else if SubItems.IndexOfName(AFieldName)>-1 then
  begin
      Result:=SubItems.Values[AFieldName];
  end

  {$IF CompilerVersion >= 30.0}
  else if (FJson<>nil) and (FJson.Contains(AFieldName)) then
  begin
    Result:=FJson.V[AFieldName];
  end
  {$IFEND}

  else
  begin
    Result:=Inherited GetValueByBindItemField(AFieldName);
  end;

end;

function TRealSkinTreeViewItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  ADataStream:TMemoryStream;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Caption' then
    begin
      FCaption:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail' then
    begin
      FDetail:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail1' then
    begin
      FDetail1:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail2' then
    begin
      FDetail2:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail3' then
    begin
      FDetail3:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail4' then
    begin
      FDetail4:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail5' then
    begin
      FDetail5:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Detail6' then
    begin
      FDetail6:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Accessory' then
    begin
      FAccessory:=TSkinAccessoryType(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='JsonStr' then
    begin
      JsonStr:=ABTNode.ConvertNode_WideString.Data;
    end

    else if ABTNode.NodeName='SubItems' then
    begin
      ADataStream:=TMemoryStream.Create;
      try
        ABTNode.ConvertNode_Binary.SaveToStream(ADataStream);
        ADataStream.Position:=0;
        try
          SubItems.LoadFromStream(ADataStream,TEncoding.UTF8);
        except

        end;
      finally
        FreeAndNil(ADataStream);
      end;
    end
    ;

  end;

  Result:=True;
end;

function TRealSkinTreeViewItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
  ADataStream:TMemoryStream;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);
  ABTNode:=ADocNode.AddChildNode_WideString('Caption');//,'标题');
  ABTNode.ConvertNode_WideString.Data:=FCaption;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail');//,'明细');
  ABTNode.ConvertNode_WideString.Data:=FDetail;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail1');//,'明细1');
  ABTNode.ConvertNode_WideString.Data:=FDetail1;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail2');//,'明细2');
  ABTNode.ConvertNode_WideString.Data:=FDetail2;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail3');//,'明细3');
  ABTNode.ConvertNode_WideString.Data:=FDetail3;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail4');//,'明细4');
  ABTNode.ConvertNode_WideString.Data:=FDetail4;

  ABTNode:=ADocNode.AddChildNode_WideString('Detail5');//,'明细5');
  ABTNode.ConvertNode_WideString.Data:=FDetail5;

//  if FDetail6<>'' then
//  begin
    ABTNode:=ADocNode.AddChildNode_WideString('Detail6');//,'明细6');
    ABTNode.ConvertNode_WideString.Data:=FDetail6;
//  end;


  if FJsonStr<>'' then
  begin
    ABTNode:=ADocNode.AddChildNode_WideString('JsonStr');//,'明细6');
    ABTNode.ConvertNode_WideString.Data:=FJsonStr;
  end;


  ABTNode:=ADocNode.AddChildNode_Int32('Accessory');//,'Accessory');
  ABTNode.ConvertNode_Int32.Data:=Ord(FAccessory);

  if (FSubItems<>nil) and (FSubItems.Count>0) then
  begin
    ABTNode:=ADocNode.AddChildNode_Binary('SubItems');//,'字符串列表');
    ADataStream:=TMemoryStream.Create;
    try
      FSubItems.SaveToStream(ADataStream,TEncoding.UTF8);
      ADataStream.Position:=0;
      ABTNode.ConvertNode_Binary.LoadFromStream(ADataStream);
    finally
      FreeAndNil(ADataStream);
    end;
  end;

  Result:=True;
end;

procedure TRealSkinTreeViewItem.SetSubItems(const Value: TStringList);
begin
  FSubItems.Assign(Value);
end;

//procedure TRealSkinTreeViewItem.SetWidth(const Value: TControlSize);
//begin
//  if FWidth<>Value then
//  begin
//    FWidth := Value;
//
//    DoSizeChange;
//
//    DoPropChange;
//  end;
//end;
//
//procedure TRealSkinTreeViewItem.StartAnimate;
//begin
//  AnimateEnable:=True;
//
//  AnimateStarted:=True;
//  AnimateIsFirstStart:=True;
//  Self.DoPropChange;
//end;
//
//procedure TRealSkinTreeViewItem.StopAnimate;
//begin
//  if AnimateStarted then
//  begin
//    AnimateStarted:=False;
//    AnimateIsFirstStop:=True;
//    Self.DoPropChange;
//  end;
//end;
//
//procedure TRealSkinTreeViewItem.SetItemType(const Value: TSkinItemType);
//begin
//  if FItemType<>Value then
//  begin
//    FItemType := Value;
//
//    DoPropChange;
//  end;
//end;

procedure TRealSkinTreeViewItem.SetAccessory(const Value: TSkinAccessoryType);
begin
  if Value<>FAccessory then
  begin
    FAccessory:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetCaption(const Value: String);
begin
  if Value<>Caption then
  begin
    FCaption:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetChilds(const Value: TRealSkinTreeViewItems);
begin
  FChilds.Assign(Value);
end;

//procedure TRealSkinTreeViewItem.SetChecked(const Value: Boolean);
//begin
//  if Value<>FChecked then
//  begin
//    FChecked:=Value;
//
//    DoPropChange;
//  end;
//end;

//procedure TRealSkinTreeViewItem.SetDataObject(const Value: TObject);
//begin
//  if FDataObject<>Value then
//  begin
//    if FDataObject<>nil then
//    begin
//      ObjRelease(FDataObject);
//    end;
//    FDataObject := Value;
//    if FDataObject<>nil then
//    begin
//      ObjAddRef(FDataObject);
//    end;
//  end;
//end;

procedure TRealSkinTreeViewItem.SetDetail(const Value: String);
begin
  if Value<>FDetail then
  begin
    FDetail:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetDetail1(const Value: String);
begin
  if Value<>FDetail1 then
  begin
    FDetail1:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetDetail2(const Value: String);
begin
  if Value<>FDetail2 then
  begin
    FDetail2:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetDetail3(const Value: String);
begin
  if Value<>FDetail3 then
  begin
    FDetail3:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetDetail4(const Value: String);
begin
  if Value<>FDetail4 then
  begin
    FDetail4:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetDetail5(const Value: String);
begin
  if Value<>FDetail5 then
  begin
    FDetail5:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetDetail6(const Value: String);
begin
  if Value<>FDetail6 then
  begin
    FDetail6:=Value;

    DoPropChange;
  end;
end;

procedure TRealSkinTreeViewItem.SetJsonStr(const Value: String);
begin
  if FJsonStr<>Value then
  begin
    FJsonStr := Value;

    FJson:=SO(FJsonStr);

    DoPropChange;
  end;

end;



initialization

finalization
  FreeAndNil(GlobalSkinItemClasses);


end.



