//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     列表项设计面板
///   </para>
///   <para>
///     ListItem designer panel
///   </para>
/// </summary>
unit uSkinItemDesignerPanelType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  Forms,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Forms,
  FMX.Types,
  FMX.Controls,
  uSkinFireMonkeyControl,
  {$ENDIF}
  Types,

  DB,
  uFuncCommon,
  uBaseLog,
  uBaseSkinControl,
  uSkinItems,
  uDrawParam,
  uBaseList,
  uSkinImageList,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;



const
  IID_ISkinItemDesignerPanel:TGUID='{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E7}';

type
  TItemDesignerPanelProperties=class;
  TSkinItemDesignerPanel=class;

  TOnPrepareDrawItemEvent=procedure(Sender:TObject;
                                      ACanvas:TDrawCanvas;
                                      AItemDesignerPanel:TSkinItemDesignerPanel;
                                      AItem:TSkinItem;
                                      AItemDrawRect:TRectF) of object;


  TOnSetControlsValueEndEvent=procedure(Sender:TObject;
                                      AItem:TSkinItem) of object;



  /// <summary>
  ///   <para>
  ///     列表项设计面板接口
  ///   </para>
  ///   <para>
  ///     Interface of ListItem designer panel
  ///   </para>
  /// </summary>
  ISkinItemDesignerPanel=interface//(ISkinControl)
  ['{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E7}']
    function GetOnPrepareDrawItem: TOnPrepareDrawItemEvent;
    function GetOnSetControlsValueEnd: TOnSetControlsValueEndEvent;

    function GetItemDesignerPanelProperties:TItemDesignerPanelProperties;

    //每次绘制列表项之前准备
    property OnPrepareDrawItem:TOnPrepareDrawItemEvent read GetOnPrepareDrawItem;
    property OnSetControlsValueEnd:TOnSetControlsValueEndEvent read GetOnSetControlsValueEnd;
    property Properties:TItemDesignerPanelProperties read GetItemDesignerPanelProperties;
    property Prop:TItemDesignerPanelProperties read GetItemDesignerPanelProperties;
  end;







  /// <summary>
  ///   <para>
  ///     绑定列表项字符串列表的控件项
  ///   </para>
  ///   <para>
  ///     Bind ListItem string control
  ///   </para>
  /// </summary>
  TItemBindingStringsControlItem=class(TCollectionItem)
  private
    FStringsKey:String;
    FStringsIndex:Integer;
    FBindControl: TChildControl;
    FColorIntf:IProcessItemColor;
    FIntf: IBindSkinItemTextControl;
    procedure SetControl(const Value: TChildControl);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  public
    property Intf: IBindSkinItemTextControl read FIntf;
    function BindItemFieldName:String;
  published
    /// <summary>
    ///   <para>
    ///   绑定的字符串列表的下标
    ///   </para>
    ///   <para>
    ///     Bind string index
    ///   </para>
    /// </summary>
    property StringsIndex:Integer read FStringsIndex write FStringsIndex;
    ///   绑定的字符串列表的Key
    property StringsKey:String read FStringsKey write FStringsKey;
    /// <summary>
    ///   <para>
    ///     绑定的控件
    ///   </para>
    ///   <para>
    ///     Bingding control
    ///   </para>
    /// </summary>
    property BindingControl:TChildControl read FBindControl write SetControl;
  end;

  /// <summary>
  ///   <para>
  ///     绑定列表项字符串列表的控件项集合
  ///   </para>
  ///   <para>
  ///     Set of binding ListItem string controls
  ///   </para>
  /// </summary>
  TItemBindingStringsControls=class(TCollection)
  private
    FProperties:TItemDesignerPanelProperties;
    function GetItem(Index: Integer): TItemBindingStringsControlItem;
    procedure SetItem(Index: Integer;const Value: TItemBindingStringsControlItem);
  public
    function Add:TItemBindingStringsControlItem;
  public
    constructor Create(AProperties:TItemDesignerPanelProperties);
    destructor Destroy;override;
  public
    property Properties:TItemDesignerPanelProperties read FProperties;
    property Prop:TItemDesignerPanelProperties read FProperties;
    property Items[Index:Integer]:TItemBindingStringsControlItem read GetItem write SetItem;default;
  end;




  TItemBindingControlItem=class
  public
    FChildControl:TControl;
//    FFieldName:String;
    FSkinItemBindingControlIntf:ISkinItemBindingControl;
    FBindSkinItemValueControlIntf:IBindSkinItemValueControl;
    FBindSkinItemObjectControlIntf:IBindSkinItemObjectControl;
  end;
  TItemBindingControlList=class(TBaseList)
  private
    function GetItem(Index: Integer): TItemBindingControlItem;
  public
    property Items[Index:Integer]:TItemBindingControlItem read GetItem;default;
  end;





  /// <summary>
  ///   <para>
  ///     列表项设计面板属性
  ///   </para>
  ///   <para>
  ///     ListItem designer panel property
  ///   </para>
  /// </summary>
  TItemDesignerPanelProperties=class(TSkinControlProperties)
  protected
    FSkinItemDesignerPanelIntf:ISkinItemDesignerPanel;
  protected
    //绑定控件的接口
    FItemCheckedIntf: IBindSkinItemBoolControl;
    FItemSelectedIntf: IBindSkinItemBoolControl;
    FItemExpandedIntf: IBindSkinItemBoolControl;

    FItemDetailIntf: IBindSkinItemTextControl;
    FItemDetail1Intf: IBindSkinItemTextControl;
    FItemDetail2Intf: IBindSkinItemTextControl;
    FItemDetail3Intf: IBindSkinItemTextControl;
    FItemDetail4Intf: IBindSkinItemTextControl;
    FItemDetail5Intf: IBindSkinItemTextControl;
    FItemDetail6Intf: IBindSkinItemTextControl;
    FItemCaptionIntf: IBindSkinItemTextControl;
    FItemAccessoryMoreIntf: ISkinControl;

    FItemIconIntf: IBindSkinItemIconControl;
    FItemPicIntf: IBindSkinItemIconControl;


  protected
    //绑定控件
    FItemCheckedControl: TChildControl;
    FItemSelectedControl: TChildControl;
    FItemExpandedControl: TChildControl;
    FItemDetailControl: TChildControl;
    FItemDetail1Control: TChildControl;
    FItemDetail2Control: TChildControl;
    FItemDetail3Control: TChildControl;
    FItemDetail4Control: TChildControl;
    FItemDetail5Control: TChildControl;
    FItemDetail6Control: TChildControl;
    FItemCaptionControl: TChildControl;
    FItemAccessoryMoreControl: TChildControl;

    FItemIconControl: TChildControl;
    FItemPicControl: TChildControl;

    FItemSubItemsBindingControls: TItemBindingStringsControls;

  protected
    //处理颜色
    FItemCaptionColorIntf: IProcessItemColor;
    FItemDetailColorIntf: IProcessItemColor;
    FItemDetail1ColorIntf: IProcessItemColor;
    FItemDetail2ColorIntf: IProcessItemColor;
    FItemDetail3ColorIntf: IProcessItemColor;
    FItemDetail4ColorIntf: IProcessItemColor;
    FItemDetail5ColorIntf: IProcessItemColor;
    FItemDetail6ColorIntf: IProcessItemColor;
  protected

    FBindControlInvalidateChange:TSkinObjectChangeManager;

  protected
    procedure SetItemCheckedControl(const Value: TChildControl);
    procedure SetItemSelectedControl(const Value: TChildControl);
    procedure SetItemExpandedControl(const Value: TChildControl);

    procedure SetItemDetailControl(const Value: TChildControl);
    procedure SetItemDetail1Control(const Value: TChildControl);
    procedure SetItemDetail2Control(const Value: TChildControl);
    procedure SetItemDetail3Control(const Value: TChildControl);
    procedure SetItemDetail4Control(const Value: TChildControl);
    procedure SetItemDetail5Control(const Value: TChildControl);
    procedure SetItemDetail6Control(const Value: TChildControl);
    procedure SetItemCaptionControl(const Value: TChildControl);
    procedure SetItemAccessoryMoreControl(const Value: TChildControl);

    procedure SetItemIconControl(const Value: TChildControl);
    procedure SetItemPicControl(const Value: TChildControl);
    procedure SetItemStringsBindingControlCollection(const Value: TItemBindingStringsControls);
  private
    //设计面板设计时预览的列表项
    FPreviewItem:TDesignTimeRealSkinTreeViewItem;
    FIsPreview: Boolean;
    procedure SetPreviewItem(const Value: TDesignTimeRealSkinTreeViewItem);
    procedure DoPreviewItemChange(Sender:TObject);
    procedure SetIsPreview(const Value: Boolean);
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    FIsSyncedSkinItemBindingControls:Boolean;
    FItemBindingControlList:TItemBindingControlList;
  public
    //更改的时候通知ListBox进行刷新
    property BindControlInvalidateChange:TSkinObjectChangeManager read FBindControlInvalidateChange;
    //处理列表项的颜色
    procedure ProcessItemBindingControlColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;var AOldColor:TDelphiColor);
    //恢复列表项的颜色
    procedure RestoreItemBindingControlColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;AOldColor:TDelphiColor);


    //获取绑定控件列表
    function IsControlHasOldBindingType(AControl:TControl):Boolean;
    procedure SyncSkinItemBindingControls(AParent:TControl);


    //将列表项的值赋给绑定控件
    procedure SetSkinItemBindingControlsValueByItem(AParent:TControl;
                                              ASkinImageList:TSkinImageList;
                                              AItem:TSkinItem;
                                              AIsDrawItemInteractiveState:Boolean);


    //
    procedure SetSkinItemBindingControlValueByItem(AControl:TChildControl;
                                              ASkinImageList:TSkinImageList;
                                              AItem:TBaseSkinItem;
//                                              AControl:TChildControl;
                                              AFieldName:String;
                                              AValueType:TVarType;
                                              AValue:Variant;
                                              AValueObject:TObject;
                                              AIsDrawItemInteractiveState:Boolean);


    //根据绑定的字段,获取对应的控件,用于列表项编辑某个字段时不绘制它
    function FindControlByBindItemFieldName(AParent:TParentControl;AFieldName:String):TChildControl;
    //准备绘制Item之前调用,将列表项的值赋给子控件
    procedure SetControlsValueByItem(ASkinImageList:TSkinImageList;
                                    AItem:TSkinItem;
                                    AIsDrawItemInteractiveState:Boolean);
  public
    //缓存标记,
    LastItem:TBaseSkinItem;
//    LastCol:TOB;
    LastItemBufferCacheTag:Integer;

    procedure Clear;

//    //绑定控件,用于页面框架
//    procedure BindControl(AItemDataType:String;
//                          ASubItemsIndex:Integer;
//                          ABindingControl:TControl);

    //绑定标题的控件
    property ItemCaptionIntf:IBindSkinItemTextControl read FItemCaptionIntf;
    property ItemAccessoryMoreIntf:ISkinControl read FItemAccessoryMoreIntf;


    //绑定明细的控件
    property ItemDetailIntf:IBindSkinItemTextControl read FItemDetailIntf;
    property ItemDetail1Intf:IBindSkinItemTextControl read FItemDetail1Intf;
    property ItemDetail2Intf:IBindSkinItemTextControl read FItemDetail2Intf;
    property ItemDetail3Intf:IBindSkinItemTextControl read FItemDetail3Intf;
    property ItemDetail4Intf:IBindSkinItemTextControl read FItemDetail4Intf;
    property ItemDetail5Intf:IBindSkinItemTextControl read FItemDetail5Intf;
    property ItemDetail6Intf:IBindSkinItemTextControl read FItemDetail6Intf;

    //绑定图标的控件
    property ItemIconIntf:IBindSkinItemIconControl read FItemIconIntf;
    //绑定图片的控件
    property ItemPicIntf:IBindSkinItemIconControl read FItemPicIntf;


    //绑定勾选的控件
    property ItemCheckedIntf:IBindSkinItemBoolControl read FItemCheckedIntf;
    //绑定选中的控件
    property ItemSelectedIntf:IBindSkinItemBoolControl read FItemSelectedIntf;
    //绑定是否展开的控件
    property ItemExpandedIntf:IBindSkinItemBoolControl read FItemExpandedIntf;

    //将字符串属性与控件绑定
    procedure SetBindSkinItemTextControl(const ANewBindingControl: TChildControl;
                                        var AOldItemBindingControl: TChildControl;
                                        var AItemIntf: IBindSkinItemTextControl;
                                        var AItemColorIntf: IProcessItemColor;
                                        const AItemDesignerPanel:TChildControl;
                                        const ABindControlInvalidateChange:TSkinObjectChangeManager;
                                        const ABindingItemDataTypeName:String);

    //将布尔属性与控件绑定
    procedure SetBindSkinItemBoolControl(const ANewBindingControl: TChildControl;
                                          var AOldItemBindingControl: TChildControl;
                                          var AItemIntf: IBindSkinItemBoolControl;
                                          const AItemDesignerPanel:TChildControl;
                                          const ABindControlInvalidateChange:TSkinObjectChangeManager);

    //将图片属性与控件绑定
    procedure SetBindSkinItemIconControl(const ANewBindingControl: TChildControl;
                                          var AOldItemBindingControl: TChildControl;
                                          var AItemIntf: IBindSkinItemIconControl;
                                          const AItemDesignerPanel:TChildControl;
                                          const ABindControlInvalidateChange:TSkinObjectChangeManager);
  published
    property IsPreview:Boolean read FIsPreview write SetIsPreview;
    //
//    property PreviewJsonStr:String read FPreviewJsonStr write FPreviewJsonStr;
    //设计时预览Item
    property PreviewItem:TDesignTimeRealSkinTreeViewItem read FPreviewItem write SetPreviewItem;
    /// <summary>
    ///   <para>
    ///     绑定列表项标题的控件
    ///   </para>
    ///   <para>
    ///     Control of binding caption
    ///   </para>
    /// </summary>
    property ItemCaptionBindingControl:TChildControl read FItemCaptionControl write SetItemCaptionControl;
    property ItemAccessoryMoreBindingControl:TChildControl read FItemAccessoryMoreControl write SetItemAccessoryMoreControl;
    /// <summary>
    ///   <para>
    ///     绑定列表项明细的控件
    ///   </para>
    ///   <para>
    ///     Control of binding detail
    ///   </para>
    /// </summary>
    property ItemDetailBindingControl:TChildControl read FItemDetailControl write SetItemDetailControl;
    /// <summary>
    ///   <para>
    ///     绑定列表项明细1的控件
    ///   </para>
    ///   <para>
    ///     Control of binding detail1
    ///   </para>
    /// </summary>
    property ItemDetail1BindingControl:TChildControl read FItemDetail1Control write SetItemDetail1Control;
    /// <summary>
    ///   <para>
    ///     绑定列表项明细2的控件
    ///   </para>
    ///   <para>
    ///     Control of binding detail2
    ///   </para>
    /// </summary>
    property ItemDetail2BindingControl:TChildControl read FItemDetail2Control write SetItemDetail2Control;
    /// <summary>
    ///   <para>
    ///     绑定列表项明细3的控件
    ///   </para>
    ///   <para>
    ///     Control of binding detail3
    ///   </para>
    /// </summary>
    property ItemDetail3BindingControl:TChildControl read FItemDetail3Control write SetItemDetail3Control;
    /// <summary>
    ///   <para>
    ///     绑定列表项明细4的控件
    ///   </para>
    ///   <para>
    ///     Control of binding detail4
    ///   </para>
    /// </summary>
    property ItemDetail4BindingControl:TChildControl read FItemDetail4Control write SetItemDetail4Control;
    /// <summary>
    ///   <para>
    ///     绑定列表项明细5的控件
    ///   </para>
    ///   <para>
    ///     Control of binding detail5
    ///   </para>
    /// </summary>
    property ItemDetail5BindingControl:TChildControl read FItemDetail5Control write SetItemDetail5Control;
    /// <summary>
    ///   <para>
    ///     绑定列表项明细6的控件
    ///   </para>
    ///   <para>
    ///     Control of binding detail6
    ///   </para>
    /// </summary>
    property ItemDetail6BindingControl:TChildControl read FItemDetail6Control write SetItemDetail6Control;
    //
    /// <summary>
    ///   <para>
    ///     绑定列表项图标的控件
    ///   </para>
    ///   <para>
    ///     Control of binding icon
    ///   </para>
    /// </summary>
    property ItemIconBindingControl:TChildControl read FItemIconControl write SetItemIconControl;
    //
    /// <summary>
    ///   <para>
    ///     绑定列表项图片的控件
    ///   </para>
    ///   <para>
    ///     Control of binding icon
    ///   </para>
    /// </summary>
    property ItemPicBindingControl:TChildControl read FItemPicControl write SetItemPicControl;
    //
    /// <summary>
    ///   <para>
    ///     绑定列表项Checked属性的控件
    ///   </para>
    ///   <para>
    ///     Control of binding ListItem's Checked property
    ///   </para>
    /// </summary>
    property ItemCheckedBindingControl:TChildControl read FItemCheckedControl write SetItemCheckedControl;
    /// <summary>
    ///   <para>
    ///     绑定列表项Selected属性的控件
    ///   </para>
    ///   <para>
    ///     Control of binding ListItem's Selected property
    ///   </para>
    /// </summary>
    property ItemSelectedBindingControl:TChildControl read FItemSelectedControl write SetItemSelectedControl;
    /// <summary>
    ///   <para>
    ///     绑定列表项Expanded属性的控件
    ///   </para>
    ///   <para>
    ///     Control of binding ListItem's Expanded property
    ///   </para>
    /// </summary>
    property ItemExpandedBindingControl:TChildControl read FItemExpandedControl write SetItemExpandedControl;

    /// <summary>
    ///   <para>
    ///     绑定列表项字符串列表的控件项集合
    ///   </para>
    ///   <para>
    ///     Set of binding string control
    ///   </para>
    /// </summary>
    property ItemStringsBindingControlCollection: TItemBindingStringsControls read FItemSubItemsBindingControls write SetItemStringsBindingControlCollection;
  end;










  /// <summary>
  ///   <para>
  ///     列表项设计面板素材基类
  ///   </para>
  ///   <para>
  ///     ListItem designer panel material base class
  ///   </para>
  /// </summary>
  TSkinItemDesignerPanelMaterial=class(TSkinControlMaterial)
  end;


  TVirtualListItemPaintOtherData=record
    //当前是否正在编辑列表项
    IsEditingItem:Boolean;
    //当前编辑的字段名,比如ItemCaption,那么当设计面板绘制的时候,如果ItemCaption绑定了一个Label,那么这个Label不绘制
    EditingItemFieldName:String;

//    //当前正在编辑的列表项数据类型
//    EditingItemDataType:TSkinItemDataType;
//    //当前正在编辑的列表项数据类型的下标
//    EditingSubItemsIndex:Integer;
  end;
  PVirtualListItemPaintOtherData=^TVirtualListItemPaintOtherData;

  TSkinItemDesignerPanelType=class(TSkinControlType)
  protected
    FSkinItemDesignerPanelIntf:ISkinItemDesignerPanel;
    function GetSkinMaterial:TSkinItemDesignerPanelMaterial;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  protected
    function CanDrawChildControl(AChildControl:TChildControl;APaintData:TPaintData):Boolean;override;
    //绘制
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;











  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinItemDesignerPanelDefaultMaterial=class(TSkinItemDesignerPanelMaterial);
  TSkinItemDesignerPanelDefaultType=TSkinItemDesignerPanelType;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinItemDesignerPanel=class(TBaseSkinControl,
                              ISkinItemDesignerPanel,
                              IDirectUIParent)
  private
    FOnPrepareDrawItem: TOnPrepareDrawItemEvent;
    FOnSetControlsValueEnd: TOnSetControlsValueEndEvent;
    function GetOnPrepareDrawItem: TOnPrepareDrawItemEvent;
    function GetOnSetControlsValueEnd: TOnSetControlsValueEndEvent;

    function GetItemDesignerPanelProperties:TItemDesignerPanelProperties;
    procedure SetItemDesignerPanelProperties(Value:TItemDesignerPanelProperties);
  protected
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;

    //子控件刷新的时候,刷新整个ListBox
    procedure UpdateChild(AControl:TChildControl;AControlIntf:IDirectUIControl);

    procedure Loaded;override;
    {$IFDEF FMX}
    procedure AfterPaint; override;
    {$ENDIF}

    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinItemDesignerPanelDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinItemDesignerPanelDefaultMaterial;
    function Material:TSkinItemDesignerPanelDefaultMaterial;
  public
    property Prop:TItemDesignerPanelProperties read GetItemDesignerPanelProperties write SetItemDesignerPanelProperties;
  published
    property OnPrepareDrawItem: TOnPrepareDrawItemEvent read GetOnPrepareDrawItem write FOnPrepareDrawItem;
    property OnSetControlsValueEnd: TOnSetControlsValueEndEvent read GetOnSetControlsValueEnd write FOnSetControlsValueEnd;
    //属性
    property Properties:TItemDesignerPanelProperties read GetItemDesignerPanelProperties write SetItemDesignerPanelProperties;
  end;


  {$IFDEF VCL}
  TSkinWinItemDesignerPanel=class(TSkinItemDesignerPanel)
  end;

  TItemDesignerPanel=TSkinItemDesignerPanel;//{$IFDEF VCL}TSkinWinItemDesignerPanel{$ENDIF}{$IFDEF FMX}TSkinFMXItemDesignerPanel{$ENDIF};
//  TItemDesignerPanel=TSkinItemDesignerPanel;//{$IFDEF VCL}TSkinWinItemDesignerPanel{$ENDIF}{$IFDEF FMX}TSkinFMXItemDesignerPanel{$ENDIF};


  TVirtualListDrawItemEvent=procedure(Sender:TObject;
                                      ACanvas:TDrawCanvas;
                                      AItemDesignerPanel:TItemDesignerPanel;
                                      AItem:TSkinItem;
                                      AItemDrawRect:TRect) of object;
  {$ENDIF VCL}









//根据绑定的控件获取ItemDataType,根据ItemDesignerPanel上面的子控件来启动编辑
function GetItemFieldNameByEditingControl(AItemDesignerPanelProperties:TItemDesignerPanelProperties;
                                          ABindingControl:TChildControl//;
//                                          var AItemDataType:TSkinItemDataType;
//                                          var ASubItemsIndex:Integer
                                          ):String;
//根据ItemDataType获取绑定的控件,在ItemDesignerPanel中绘制子控件时,如果当前的字段正在编辑,那么不绘制该控件
function GetEditingControlByItemFieldName(AItemDesignerPanelProperties:TItemDesignerPanelProperties;
                                         ABindItemFieldName:String
//                                          AItemDataType:TSkinItemDataType;
//                                          ASubItemsIndex:Integer
                                          ):TChildControl;

//获取子控件所属的设计面板
function GetParentItemDesignerPanel(AChild:TChildControl):TSkinItemDesignerPanel;
function GetParentByControlClass(AChild:TChildControl;AClass:TClass):TControl;




implementation


uses
//  uSkinImageList,
  uSkinVirtualListType,
//  uSkinTreeViewType,
  uSkinMultiColorLabelType;



function GetParentItemDesignerPanel(AChild:TChildControl):TSkinItemDesignerPanel;
var
  AParent:TChildControl;
begin
  Result:=nil;

  AParent:=TChildControl(AChild).Parent;
  while (AParent<>nil) do
  begin
    if (AParent is TSkinItemDesignerPanel) then
    begin
      Result:=TSkinItemDesignerPanel(AParent);
      Break;
    end;

    //判断下一个
    AParent:=AParent.Parent;
  end;

end;

function GetParentByControlClass(AChild:TChildControl;AClass:TClass):TControl;
var
  AParent:TChildControl;
begin
  Result:=nil;

  AParent:=TChildControl(AChild).Parent;
  while (AParent<>nil) do
  begin
    if (AParent is AClass) then
    begin
      Result:=TControl(AParent);
      Break;
    end;

    //判断下一个
    AParent:=AParent.Parent;
  end;


end;




function GetItemFieldNameByEditingControl(AItemDesignerPanelProperties:TItemDesignerPanelProperties;
                                          ABindingControl:TChildControl//;
//                                          var AItemDataType:TSkinItemDataType;
//                                          var ASubItemsIndex:Integer
                                          ):String;
var
  I: Integer;
  AItemBindingStringsControlItem:TItemBindingStringsControlItem;
  ASkinItemBindingControlIntf:ISkinItemBindingControl;
begin
  Result:='';
//  AItemDataType:=idtNone;
//  ASubItemsIndex:=-1;


  if AItemDesignerPanelProperties.ItemCaptionBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtCaption;
    Result:='ItemCaption';
  end;
  if AItemDesignerPanelProperties.ItemDetailBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtDetail;
    Result:='ItemDetail';
  end;
  if AItemDesignerPanelProperties.ItemDetail1BindingControl=ABindingControl then
  begin
//    AItemDataType:=idtDetail1;
    Result:='ItemDetail1';
  end;
  if AItemDesignerPanelProperties.ItemDetail2BindingControl=ABindingControl then
  begin
//    AItemDataType:=idtDetail2;
    Result:='ItemDetail2';
  end;
  if AItemDesignerPanelProperties.ItemDetail3BindingControl=ABindingControl then
  begin
//    AItemDataType:=idtDetail3;
    Result:='ItemDetail3';
  end;
  if AItemDesignerPanelProperties.ItemDetail4BindingControl=ABindingControl then
  begin
//    AItemDataType:=idtDetail4;
    Result:='ItemDetail4';
  end;
  if AItemDesignerPanelProperties.ItemDetail5BindingControl=ABindingControl then
  begin
//    AItemDataType:=idtDetail5;
    Result:='ItemDetail5';
  end;
  if AItemDesignerPanelProperties.ItemDetail6BindingControl=ABindingControl then
  begin
//    AItemDataType:=idtDetail6;
    Result:='ItemDetail6';
  end;

  if AItemDesignerPanelProperties.ItemIconBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtIcon;
    Result:='ItemIcon';
  end;
  if AItemDesignerPanelProperties.ItemPicBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtPic;
    Result:='ItemPic';
  end;


  if AItemDesignerPanelProperties.ItemCheckedBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtChecked;
    Result:='ItemChecked';
  end;
  if AItemDesignerPanelProperties.ItemSelectedBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtSelected;
    Result:='ItemSelected';
  end;
  if AItemDesignerPanelProperties.ItemExpandedBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtExpanded;
    Result:='ItemExpanded';
  end;

  if AItemDesignerPanelProperties.ItemAccessoryMoreBindingControl=ABindingControl then
  begin
//    AItemDataType:=idtAccessory;
    Result:='ItemAccessory';
  end;


  for I := 0 to AItemDesignerPanelProperties.ItemStringsBindingControlCollection.Count-1 do
  begin
    AItemBindingStringsControlItem:=AItemDesignerPanelProperties.ItemStringsBindingControlCollection[I];
    if AItemBindingStringsControlItem.BindingControl=ABindingControl then
    begin
//        AItemDataType:=idtSubItems;
//        ASubItemsIndex:=AItemBindingStringsControlItem.StringsIndex;

        Result:=AItemBindingStringsControlItem.BindItemFieldName;
        
//        if AItemBindingStringsControlItem.StringsIndex>=0 then
//        begin
//          Result:='ItemSubItems'+IntToStr(AItemBindingStringsControlItem.StringsIndex);
//          Break;
//        end
//        else if AItemBindingStringsControlItem.StringsKey<>'' then
//        begin
//          Result:='ItemSubItems'+'_'+AItemBindingStringsControlItem.StringsKey;
//          Break;
//        end;
    end;
  end;



  if Result='' then
  begin
    if ABindingControl.GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf) then
    begin
      Result:=ASkinItemBindingControlIntf.GetBindItemFieldName;
    end;
  end;

end;

function GetEditingControlByItemFieldName(AItemDesignerPanelProperties:TItemDesignerPanelProperties;
                                          ABindItemFieldName:String
//                                          AItemDataType:TSkinItemDataType;
//                                          ASubItemsIndex:Integer
                                          ):TChildControl;
var
  I:Integer;
  ASubItemsIndexStr:String;
  ASubItemsIndex:Integer;
  ASubItemsKey:String;
begin
  Result:=nil;



  if ABindItemFieldName='ItemCaption' then
  begin
    Result:=AItemDesignerPanelProperties.FItemCaptionControl;
  end
  else if ABindItemFieldName='ItemIcon' then
  begin
    Result:=AItemDesignerPanelProperties.FItemIconControl;
  end
  else if ABindItemFieldName='ItemPic' then
  begin
    Result:=AItemDesignerPanelProperties.FItemPicControl;
  end
  else if ABindItemFieldName='ItemChecked' then
  begin
    Result:=AItemDesignerPanelProperties.FItemCheckedControl;
  end
  else if ABindItemFieldName='ItemSelected' then
  begin
    Result:=AItemDesignerPanelProperties.FItemSelectedControl;
  end
  else if ABindItemFieldName='ItemExpanded' then
  begin
    Result:=AItemDesignerPanelProperties.FItemExpandedControl;
  end
  else if ABindItemFieldName='ItemAccessory' then
  begin
    Result:=AItemDesignerPanelProperties.FItemAccessoryMoreControl;
  end
  else if ABindItemFieldName='ItemDetail' then
  begin
    Result:=AItemDesignerPanelProperties.FItemDetailControl;
  end
  else if ABindItemFieldName='ItemDetail1' then
  begin
    Result:=AItemDesignerPanelProperties.FItemDetail1Control;
  end
  else if ABindItemFieldName='ItemDetail2' then
  begin
    Result:=AItemDesignerPanelProperties.FItemDetail2Control;
  end
  else if ABindItemFieldName='ItemDetail3' then
  begin
    Result:=AItemDesignerPanelProperties.FItemDetail3Control;
  end
  else if ABindItemFieldName='ItemDetail4' then
  begin
    Result:=AItemDesignerPanelProperties.FItemDetail4Control;
  end
  else if ABindItemFieldName='ItemDetail5' then
  begin
    Result:=AItemDesignerPanelProperties.FItemDetail5Control;
  end
  else if ABindItemFieldName='ItemDetail6' then
  begin
    Result:=AItemDesignerPanelProperties.FItemDetail6Control;
  end

  {$IF CompilerVersion >= 30.0}
  else if ABindItemFieldName.Substring(0,12)='ItemSubItems' then
  begin

      ASubItemsIndex:=-1;
      ASubItemsKey:='';

      ASubItemsIndexStr:=ABindItemFieldName.Substring(12,MaxInt);
      if ASubItemsIndexStr.Chars[0]<>'_' then
      begin
        //是下标
        ASubItemsIndex:=StrToInt(ASubItemsIndexStr);
      end
      else
      begin
        //是Key
        ASubItemsKey:=ASubItemsIndexStr.Substring(1,MaxInt);
      end;
      

      for I := 0 to AItemDesignerPanelProperties.ItemStringsBindingControlCollection.Count-1 do
      begin
          if (ASubItemsIndex>=0) and (AItemDesignerPanelProperties.ItemStringsBindingControlCollection[I].StringsIndex=ASubItemsIndex) then
          begin
              Result:=AItemDesignerPanelProperties.ItemStringsBindingControlCollection[I].BindingControl;
              Break;
          end;
          if (ASubItemsKey<>'') and (AItemDesignerPanelProperties.ItemStringsBindingControlCollection[I].StringsKey=ASubItemsKey) then
          begin
              Result:=AItemDesignerPanelProperties.ItemStringsBindingControlCollection[I].BindingControl;
              Break;
          end;
      end;


  end
  {$IFEND}

  else
  begin
      Result:=AItemDesignerPanelProperties.FindControlByBindItemFieldName(TParentControl(AItemDesignerPanelProperties.SkinControl),ABindItemFieldName);

  end;
end;



{ TSkinItemDesignerPanelType }

function TSkinItemDesignerPanelType.CanDrawChildControl(AChildControl: TChildControl; APaintData: TPaintData): Boolean;
var
  APPaintOtherData:PVirtualListItemPaintOtherData;
begin
  Result:=True;
  if APaintData.OtherData<>nil then
  begin
    APPaintOtherData:=APaintData.OtherData;
    if APPaintOtherData.IsEditingItem then
    begin
      Result:=GetEditingControlByItemFieldName(Self.FSkinItemDesignerPanelIntf.Properties,
                                               APPaintOtherData.EditingItemFieldName

//                                              APPaintOtherData.EditingItemDataType,
//                                              APPaintOtherData.EditingSubItemsIndex
                                              )
                <>AChildControl;
      //Result:=Not (APVirtualListItemPaintOtherData.EditingControl=AChildControl);
    end;
  end;
end;

function TSkinItemDesignerPanelType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinItemDesignerPanel,Self.FSkinItemDesignerPanelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinItemDesignerPanel Interface');
    end;
  end;
end;

//function TSkinCustomListDefaultType_ProcessItemDrawEffectStates(AItem: TBaseSkinItem): TDPEffectStates;
//begin
//  Result:=[];
//
//  if Self.FSkinCustomListIntf.Prop.FMouseOverItem=AItem then
//  begin
//    Result:=Result+[dpstMouseOver];
//  end;
//
//  if (Self.FSkinCustomListIntf.Prop.FMouseDownItem=AItem) then
//  begin
//      //当前按下,且移动距离不超过5个像素，触发了OnClickItem事件,需要重绘
//      if Self.FSkinCustomListIntf.Prop.FIsStayPressedItem then
//      begin
//        Result:=Result+[dpstMouseDown];
//
//        Self.FSkinCustomListIntf.Prop.StopCheckStayPressedItemTimer;
//      end;
//  end;
//
//
//  //上次按下的列表项,调用了OnClickItem之后会清空
//  if (Self.FSkinCustomListIntf.Prop.FLastMouseDownItem=AItem) then
//  begin
//    Result:=Result+[dpstMouseDown];
//  end;
//
//  //选中的效果
//  if AItem.Selected then
//  begin
//    Result:=Result+[dpstPushed];
//  end;
//
//end;



function TSkinItemDesignerPanelType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  {$IFDEF VCL}
  AParentDC:HDC;
  {$ENDIF}
  AParentCanvas:TDrawCanvas;
  FPaintData:TPaintData;

  AItemDrawRect:TRectF;
  AItemPaintData:TPaintData;
  AItemEffectStates:TDPEffectStates;

  //AOldEffectStates:TDPEffectStates;
begin
  //设计时绘制虚线框和控件名称
  if (csDesigning in Self.FSkinControl.ComponentState)
    and
    not APaintData.IsInDrawDirectUI then
  begin
      ACanvas.DrawDesigningRect(ADrawRect,GlobalItemDesignerPanelDesignRectBorderColor);


      if not (FSkinControl.Parent is TFrame) then Exit;
      

      //在设计时,父控件那里输出各种状态下的效果图
      //AOldEffectStates:=CurrentEffectStates;
      {$IFDEF VCL}
      AParentDC := GetDC(Self.FSkinControl.Parent.Handle);
      {$ENDIF}
      try
        AParentCanvas:=CreateDrawCanvas('TSkinItemDesignerPanelType.CustomPaint');
        if AParentCanvas<>nil then
        begin
          try

              {$IFDEF VCL}
              AParentCanvas.Prepare(AParentDC);
              {$ELSE}
              AParentCanvas.Prepare(TControl(Self.FSkinControl.Parent).Canvas);
              {$ENDIF}

              FPaintData:=GlobalNullPaintData;
              FPaintData.IsDrawInteractiveState:=True;
              FPaintData.IsInDrawDirectUI:=False;

  //            TSkinEditDefaultType(Self.GetSkinControlType).CustomPaintHelpText(
  //                  AParentCanvas,
  //                  Self.GetCurrentUseMaterial,
  //                  RectF(Self.GetClientRect.Left,Self.GetClientRect.Top,Self.GetClientRect.Right,Self.GetClientRect.Bottom),
  //                  FPaintData);

              {$IFDEF VCL}
              AItemDrawRect:=RectF(Self.FSkinControl.Left+Self.FSkinControl.Width+10,
                                  Self.FSkinControl.Top,
                                  Self.FSkinControl.Left+Self.FSkinControl.Width+10+Self.FSkinControl.Width,
                                  Self.FSkinControl.Top+Self.FSkinControl.Height);
              {$ELSE}
              AItemDrawRect:=RectF(Self.FSkinControl.Width+10,
                                  0,
                                  Self.FSkinControl.Width+10+Self.FSkinControl.Width,
                                  Self.FSkinControl.Height);
              {$ENDIF}

              //绘制ItemPanDragDesignerPanel
              //选择ItemPanDragDesignerPanel的绘制风格,一是跟随,二是一直显示在那里


              AItemEffectStates:=[];
              //剪裁显示
              Self.IsUseCurrentEffectStates:=True;
              Self.CurrentEffectStates:=AItemEffectStates;
              //绘制ItemDesignerPanel的背景
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=True;
              AItemPaintData.IsInDrawDirectUI:=True;
              Self.Paint(AParentCanvas,
                                    Self.GetPaintCurrentUseMaterial,
                                    AItemDrawRect,
                                    AItemPaintData);
              //绘制ItemDesignerPanel的子控件
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=True;
              AItemPaintData.IsInDrawDirectUI:=True;
              Self.DrawChildControls(AParentCanvas,
                                    AItemDrawRect,
                                    AItemPaintData,
                                    RectF(ADrawRect.Left+AItemDrawRect.Left,
                                          ADrawRect.Top+AItemDrawRect.Top,
                                          ADrawRect.Right+AItemDrawRect.Left,
                                          ADrawRect.Bottom+AItemDrawRect.Top)
                                        );





              OffsetRect(AItemDrawRect,0,Self.FSkinControl.Height+10);
              AItemEffectStates:=[dpstPushed];
              //剪裁显示
              Self.IsUseCurrentEffectStates:=True;
              Self.CurrentEffectStates:=AItemEffectStates;
              //绘制ItemDesignerPanel的背景
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=True;
              AItemPaintData.IsInDrawDirectUI:=True;
              Self.Paint(AParentCanvas,
                                    Self.GetPaintCurrentUseMaterial,
                                    AItemDrawRect,
                                    AItemPaintData);
              //绘制ItemDesignerPanel的子控件
              AItemPaintData:=GlobalNullPaintData;
              AItemPaintData.IsDrawInteractiveState:=True;
              AItemPaintData.IsInDrawDirectUI:=True;
              Self.DrawChildControls(AParentCanvas,
                                    AItemDrawRect,
                                    AItemPaintData,
                                    RectF(ADrawRect.Left+AItemDrawRect.Left,
                                          ADrawRect.Top+AItemDrawRect.Top,
                                          ADrawRect.Right+AItemDrawRect.Left,
                                          ADrawRect.Bottom+AItemDrawRect.Top)
                                        );

              //再清除子控件的状态



          finally
            FreeAndNil(AParentCanvas);
          end;
        end;
      finally
        {$IFDEF VCL}
        ReleaseDC(Self.FSkinControl.Parent.Handle,AParentDC);
        {$ENDIF}


        CurrentEffectStates:=[];//AOldEffectStates;
        IsUseCurrentEffectStates:=False;
      end;


  end;

end;

procedure TSkinItemDesignerPanelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinItemDesignerPanelIntf:=nil;
end;

function TSkinItemDesignerPanelType.GetSkinMaterial: TSkinItemDesignerPanelMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinItemDesignerPanelMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


{ TItemDesignerPanelProperties }


procedure TItemDesignerPanelProperties.SetBindSkinItemTextControl(const ANewBindingControl: TChildControl;
                                    var AOldItemBindingControl: TChildControl;
                                    var AItemIntf: IBindSkinItemTextControl;
                                    var AItemColorIntf: IProcessItemColor;
                                    const AItemDesignerPanel:TChildControl;
                                    const ABindControlInvalidateChange:TSkinObjectChangeManager;
                                    const ABindingItemDataTypeName:String);
begin
  if AOldItemBindingControl<>ANewBindingControl then
  begin

      if AOldItemBindingControl<>nil then
      begin
          RemoveFreeNotification(AOldItemBindingControl,AItemDesignerPanel);
      end;

      if ANewBindingControl<>nil then
      begin
          if Not ANewBindingControl.GetInterface(IID_IBindSkinItemTextControl,AItemIntf) then
          begin
    //        ShowException('This Component Do not Support IBindSkinItemTextControl Interface');
          end
          else
          begin
              AOldItemBindingControl := ANewBindingControl;
              AddFreeNotification(AOldItemBindingControl,AItemDesignerPanel);

              if ANewBindingControl is TSkinMultiColorLabel then
              begin
                TSkinMultiColorLabel(AOldItemBindingControl).CheckAutoBinding(ABindingItemDataTypeName);
              end;

          end;

          ANewBindingControl.GetInterface(IID_IProcessItemColor,AItemColorIntf);
      end
      else
      begin
          //取消绑定
          AOldItemBindingControl:=nil;
          AItemIntf:=nil;
      end;

      //并重绘
      //子控件刷新的时候调用绑定的ListBox,ListView进行刷新
      ABindControlInvalidateChange.DoChange(AItemDesignerPanel);

      Self.DoPreviewItemChange(nil);

  end;
end;


procedure TItemDesignerPanelProperties.SetBindSkinItemBoolControl(const ANewBindingControl: TChildControl;
                                    var AOldItemBindingControl: TChildControl;
                                    var AItemIntf: IBindSkinItemBoolControl;
                                    const AItemDesignerPanel:TChildControl;
                                    const ABindControlInvalidateChange:TSkinObjectChangeManager);
begin
  if AOldItemBindingControl<>ANewBindingControl then
  begin

      if AOldItemBindingControl<>nil then
      begin
          RemoveFreeNotification(AOldItemBindingControl,AItemDesignerPanel);
      end;

      if ANewBindingControl<>nil then
      begin
        if Not ANewBindingControl.GetInterface(IID_IBindSkinItemBoolControl,AItemIntf) then
        begin
            ShowException('This Component Do not Support IBindSkinItemBoolControl Interface');
        end
        else
        begin
            AOldItemBindingControl := ANewBindingControl;
            AddFreeNotification(AOldItemBindingControl,AItemDesignerPanel);
        end;
      end
      else
      begin
        AOldItemBindingControl:=nil;
        AItemIntf:=nil;
      end;


      //并重绘
      //子控件刷新的时候调用绑定的ListBox,ListView进行刷新
      ABindControlInvalidateChange.DoChange(AItemDesignerPanel);


      Self.DoPreviewItemChange(nil);

  end;
end;

procedure TItemDesignerPanelProperties.SetBindSkinItemIconControl(const ANewBindingControl: TChildControl;
                                      var AOldItemBindingControl: TChildControl;
                                      var AItemIntf: IBindSkinItemIconControl;
                                      const AItemDesignerPanel:TChildControl;
                                      const ABindControlInvalidateChange:TSkinObjectChangeManager);
begin
  if AOldItemBindingControl<>ANewBindingControl then
  begin

      if AOldItemBindingControl<>nil then
      begin
          RemoveFreeNotification(AOldItemBindingControl,AItemDesignerPanel);
      end;


      if ANewBindingControl<>nil then
      begin
        if Not ANewBindingControl.GetInterface(IID_IBindSkinItemIconControl,AItemIntf) then
        begin
          ShowException('This Component Do not Support IBindSkinItemIconControl Interface');
        end
        else
        begin
            AOldItemBindingControl := ANewBindingControl;
            AddFreeNotification(AOldItemBindingControl,AItemDesignerPanel);
        end;
      end
      else
      begin
        AOldItemBindingControl:=nil;
        AItemIntf:=nil;
      end;

      //并重绘
      //子控件刷新的时候调用绑定的ListBox,ListView进行刷新
      ABindControlInvalidateChange.DoChange(AItemDesignerPanel);


      Self.DoPreviewItemChange(nil);

  end;
end;

procedure TItemDesignerPanelProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;

//  FItemCheckedControl:=TItemDesignerPanelProperties(Src).FItemCheckedControl;
//  FItemSelectedControl:=TItemDesignerPanelProperties(Src).FItemSelectedControl;
//  FItemExpandedControl:=TItemDesignerPanelProperties(Src).FItemExpandedControl;
//
//  FItemDetailControl:=TItemDesignerPanelProperties(Src).FItemDetailControl;
//  FItemDetail1Control:=TItemDesignerPanelProperties(Src).FItemDetail1Control;
//  FItemDetail2Control:=TItemDesignerPanelProperties(Src).FItemDetail2Control;
//  FItemDetail3Control:=TItemDesignerPanelProperties(Src).FItemDetail3Control;
//  FItemDetail4Control:=TItemDesignerPanelProperties(Src).FItemDetail4Control;
//  FItemDetail5Control:=TItemDesignerPanelProperties(Src).FItemDetail5Control;
//  FItemDetail6Control:=TItemDesignerPanelProperties(Src).FItemDetail6Control;
//  FItemCaptionControl:=TItemDesignerPanelProperties(Src).FItemCaptionControl;
//  FItemAccessoryMoreControl:=TItemDesignerPanelProperties(Src).FItemAccessoryMoreControl;
//
//  FItemIconControl:=TItemDesignerPanelProperties(Src).FItemIconControl;
//  FItemPicControl:=TItemDesignerPanelProperties(Src).FItemPicControl;
//
//
//
//
//  FItemCheckedIntf:=TItemDesignerPanelProperties(Src).FItemCheckedIntf;
//  FItemSelectedIntf:=TItemDesignerPanelProperties(Src).FItemSelectedIntf;
//  FItemExpandedIntf:=TItemDesignerPanelProperties(Src).FItemExpandedIntf;
//
//  FItemDetailIntf:=TItemDesignerPanelProperties(Src).FItemDetailIntf;
//  FItemDetail1Intf:=TItemDesignerPanelProperties(Src).FItemDetail1Intf;
//  FItemDetail2Intf:=TItemDesignerPanelProperties(Src).FItemDetail2Intf;
//  FItemDetail3Intf:=TItemDesignerPanelProperties(Src).FItemDetail3Intf;
//  FItemDetail4Intf:=TItemDesignerPanelProperties(Src).FItemDetail4Intf;
//  FItemDetail5Intf:=TItemDesignerPanelProperties(Src).FItemDetail5Intf;
//  FItemDetail6Intf:=TItemDesignerPanelProperties(Src).FItemDetail6Intf;
//  FItemCaptionIntf:=TItemDesignerPanelProperties(Src).FItemCaptionIntf;
//  FItemAccessoryMoreIntf:=TItemDesignerPanelProperties(Src).FItemAccessoryMoreIntf;
//
//  FItemIconIntf:=TItemDesignerPanelProperties(Src).FItemIconIntf;
end;

//procedure TItemDesignerPanelProperties.BindControl(AItemDataType: String;
//  ASubItemsIndex: Integer; ABindingControl: TControl);
//var
//  I: Integer;
//  AIsExisted:Boolean;
//  AItem:TItemBindingStringsControlItem;
//begin
//
//  if SameText(AItemDataType,'ItemCaption') then
//  begin
//    Self.ItemCaptionBindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemDetail') then
//  begin
//    Self.ItemDetailBindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemDetail1') then
//  begin
//    Self.ItemDetail1BindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemDetail2') then
//  begin
//    Self.ItemDetail2BindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemDetail3') then
//  begin
//    Self.ItemDetail3BindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemDetail4') then
//  begin
//    Self.ItemDetail4BindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemDetail5') then
//  begin
//    Self.ItemDetail5BindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemDetail6') then
//  begin
//    Self.ItemDetail6BindingControl:=ABindingControl;
//  end;
//
//  if SameText(AItemDataType,'ItemAccessory') then
//  begin
//    Self.ItemAccessoryMoreBindingControl:=ABindingControl;
//  end;
//
//  if SameText(AItemDataType,'ItemIcon') then
//  begin
//    Self.ItemIconBindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemPic') then
//  begin
//    Self.ItemPicBindingControl:=ABindingControl;
//  end;
//
//  if SameText(AItemDataType,'ItemChecked') then
//  begin
//    Self.ItemCheckedBindingControl:=ABindingControl;
//  end;
//  if SameText(AItemDataType,'ItemSelected') then
//  begin
//    Self.ItemSelectedBindingControl:=ABindingControl;
//  end;
//
//
//  if SameText(AItemDataType,'ItemSubItems') then
//  begin
//      AIsExisted:=False;
//      //已经存在,则修改
//      for I := 0 to Self.FItemSubItemsBindingControls.Count-1 do
//      begin
//        if Self.FItemSubItemsBindingControls[I].FStringsIndex=ASubItemsIndex then
//        begin
//          Self.FItemSubItemsBindingControls[I].BindingControl:=ABindingControl;
//          AIsExisted:=True;
//          Break;
//        end;
//      end;
//      //不存在,则添加
//      if not AIsExisted then
//      begin
//        AItem:=FItemSubItemsBindingControls.Add;
//        AItem.BindingControl:=ABindingControl;
//        AItem.StringsIndex:=ASubItemsIndex;
//      end;
//  end;
//
//end;

procedure TItemDesignerPanelProperties.SetControlsValueByItem(
  ASkinImageList:TSkinImageList;
  AItem: TSkinItem;
  AIsDrawItemInteractiveState: Boolean);
var
  I: Integer;
  AValue:Variant;
//  ASkinImageList:TSkinImageList;
  AControlItem:TItemBindingStringsControlItem;
begin
//  uBaseLog.HandleException(nil,'TItemDesignerPanelProperties.SetControlsValueByItem Begin');

  //静态绑定的
  //给设计面板上的控件赋值
  if Self.ItemCaptionBindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemCaption');
    Self.ItemCaptionIntf.BindingItemText('ItemCaption',AValue,AItem,AIsDrawItemInteractiveState);
  end;
  if Self.ItemDetailBindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemDetail');
    Self.ItemDetailIntf.BindingItemText('ItemDetail',AValue,AItem,AIsDrawItemInteractiveState);
  end;
  if Self.ItemDetail1BindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemDetail1');
    Self.ItemDetail1Intf.BindingItemText('ItemDetail1',AValue,AItem,AIsDrawItemInteractiveState);
  end;
  if Self.ItemDetail2BindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemDetail2');
    Self.ItemDetail2Intf.BindingItemText('ItemDetail2',AValue,AItem,AIsDrawItemInteractiveState);
  end;
  if Self.ItemDetail3BindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemDetail3');
    Self.ItemDetail3Intf.BindingItemText('ItemDetail3',AValue,AItem,AIsDrawItemInteractiveState);
  end;
  if Self.ItemDetail4BindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemDetail4');
    Self.ItemDetail4Intf.BindingItemText('ItemDetail4',AValue,AItem,AIsDrawItemInteractiveState);
  end;
  if Self.ItemDetail5BindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemDetail5');
    Self.ItemDetail5Intf.BindingItemText('ItemDetail5',AValue,AItem,AIsDrawItemInteractiveState);
  end;
  if Self.ItemDetail6BindingControl<>nil then
  begin
    AValue:=AItem.GetValueByBindItemField('ItemDetail6');
    Self.ItemDetail6Intf.BindingItemText('ItemDetail6',AValue,AItem,AIsDrawItemInteractiveState);
  end;



  //设置控件是否隐藏或显示
  if Self.ItemAccessoryMoreBindingControl<>nil then
  begin
    Self.ItemAccessoryMoreIntf.Visible:=(AItem.Accessory<>satNone);
  end;



  if Self.ItemIconBindingControl<>nil then
  begin
//    ASkinImageList:=nil;
//    if AListProp<>nil then
//    begin
//      ASkinImageList:=TVirtualListProperties(AListProp).SkinImageList;
//    end;

    //必须用
    Self.ItemIconIntf.BindingItemIcon(
                  AItem.StaticIcon,
                  ASkinImageList,
                  AItem.IconImageIndex,
                  AItem.IconRefPicture,
                  AIsDrawItemInteractiveState
                  );
  end;



  if Self.ItemPicBindingControl<>nil then
  begin
    //必须用
    Self.ItemPicIntf.BindingItemIcon(
                  AItem.StaticPic,
                  nil,
                  AItem.PicImageIndex,
                  AItem.PicRefPicture,
                  AIsDrawItemInteractiveState);
  end;



  if Self.ItemCheckedBindingControl<>nil then
  begin
    Self.ItemCheckedIntf.BindingItemBool(AItem.Checked,AIsDrawItemInteractiveState);
  end;

  if Self.ItemSelectedBindingControl<>nil then
  begin
    Self.ItemSelectedIntf.BindingItemBool(AItem.Selected,AIsDrawItemInteractiveState);
  end;

  if (Self.ItemExpandedBindingControl<>nil) and (AItem is TBaseSkinTreeViewItem) then
  begin
    Self.ItemExpandedIntf.BindingItemBool(TBaseSkinTreeViewItem(AItem).Expanded,AIsDrawItemInteractiveState);
  end;


  //设计时
  if AItem is TDesignTimeRealSkinTreeViewItem then
  begin
    if Self.ItemExpandedBindingControl<>nil then
    begin
      Self.ItemExpandedIntf.BindingItemBool(TDesignTimeRealSkinTreeViewItem(AItem).Expanded,AIsDrawItemInteractiveState);
    end;
  end;




  for I := 0 to Self.ItemStringsBindingControlCollection.Count-1 do
  begin
      AControlItem:=Self.ItemStringsBindingControlCollection[I];
      if (AControlItem.Intf<>nil) and (AControlItem.BindItemFieldName<>'') then
      begin

          AValue:=AItem.GetValueByBindItemField(AControlItem.BindItemFieldName);
                                                //'ItemSubItems'+IntToStr(AControlItem.StringsIndex));
  //      if (AControlItem.StringsIndex>-1)
  //        and (AControlItem.StringsIndex<AItem.SubItems.Count) then
  //      begin
          AControlItem.Intf.BindingItemText(
                                            AControlItem.BindItemFieldName,//'ItemSubItems'+IntToStr(AControlItem.StringsIndex),
                                            AValue,//AItem.SubItems[AControlItem.StringsIndex],
                                            AItem,
                                            AIsDrawItemInteractiveState);
  //      end
  //      else
  //      begin
  //        AControlItem.Intf.BindingItemText(
  //              'ItemSubItems'+IntToStr(AControlItem.StringsIndex),
  //              '',
  //              AItem,
  //              AIsDrawItemInteractiveState);
  //      end;

      end;
  end;


  //自动搜索子控件,获取它们是否支持ISkinItemBindingControl接口
//    function GetBindItemFieldName:String;
//    procedure SetBindItemFieldName(AValue:String);
  SetSkinItemBindingControlsValueByItem(Self.FSkinControl,
                                        ASkinImageList,
                                        AItem,
                                        AIsDrawItemInteractiveState);

//  uBaseLog.HandleException(nil,'TItemDesignerPanelProperties.SetControlsValueByItem end');

  if Assigned(Self.FSkinItemDesignerPanelIntf.OnSetControlsValueEnd) then
  begin
    FSkinItemDesignerPanelIntf.OnSetControlsValueEnd(
                                        Self.FSkinControl,
                                        TSkinItem(AItem)
                                        );
  end;
end;

procedure TItemDesignerPanelProperties.Clear;
begin
  Self.ItemCaptionBindingControl:=nil;
  Self.ItemDetailBindingControl:=nil;
  Self.ItemDetail1BindingControl:=nil;
  Self.ItemDetail2BindingControl:=nil;
  Self.ItemDetail3BindingControl:=nil;
  Self.ItemDetail4BindingControl:=nil;
  Self.ItemDetail5BindingControl:=nil;
  Self.ItemDetail6BindingControl:=nil;

  
  Self.ItemAccessoryMoreBindingControl:=nil;

  Self.ItemIconBindingControl:=nil;
  Self.ItemPicBindingControl:=nil;


  Self.ItemCheckedBindingControl:=nil;
  Self.ItemSelectedBindingControl:=nil;
  Self.ItemExpandedBindingControl:=nil;

  Self.ItemStringsBindingControlCollection.Clear;

  
end;

constructor TItemDesignerPanelProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinItemDesignerPanel,Self.FSkinItemDesignerPanelIntf) then
  begin
    ShowException('This Component Do not Support ISkinItemDesignerPanel Interface');
  end
  else
  begin

    FPreviewItem:=TDesignTimeRealSkinTreeViewItem.Create;//(nil);
    FPreviewItem.FOnChange:=DoPreviewItemChange;

    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=60;

    FBindControlInvalidateChange:=TSkinObjectChangeManager.Create(Self);

    FItemSubItemsBindingControls:=TItemBindingStringsControls.Create(Self);


    FItemBindingControlList:=TItemBindingControlList.Create;

  end;
end;

destructor TItemDesignerPanelProperties.Destroy;
begin
  FreeAndNil(FPreviewItem);
  FreeAndNil(FItemSubItemsBindingControls);
  FreeAndNil(FBindControlInvalidateChange);
  FreeAndNil(FItemBindingControlList);
  inherited;
end;

procedure TItemDesignerPanelProperties.DoPreviewItemChange(Sender: TObject);
begin
  //[csLoading,csReading,csFreeNotification]
  if (csDesigning in Self.FSkinControl.ComponentState) then
  begin
      //设计时才需要预览Item
      if FIsPreview then
      begin
        Self.SetControlsValueByItem(nil,Self.FPreviewItem,False);
      end;
    //  Self.Invalidate;
  end;
end;

function TItemDesignerPanelProperties.FindControlByBindItemFieldName(AParent:TParentControl;AFieldName: String): TChildControl;
var
  I: Integer;
  ASkinItemBindingControlIntf:ISkinItemBindingControl;
begin
  Result:=nil;
  for I := 0 to GetParentChildControlCount(TParentControl(AParent))-1 do
  begin
    if (AParent is TParentControl) and GetParentChildControl(TParentControl(AParent),I).GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf) then
    begin
        if AFieldName=ASkinItemBindingControlIntf.GetBindItemFieldName then
        begin
          //找到了
          Result:=GetParentChildControl(TParentControl(AParent),I);
          Exit;
        end;
    end;

    if (AParent is TParentControl) and (GetParentChildControl(TParentControl(AParent),I) is TParentControl) and (GetParentChildControlCount(TParentControl(GetParentChildControl(TParentControl(AParent),I)))>0) then
    begin
        //递归
        Result:=FindControlByBindItemFieldName(TParentControl(GetParentChildControl(TParentControl(AParent),I)),AFieldName);
        if Result<>nil then
        begin
          //找到了
          Exit;
        end;
    end;
  end;

end;

function TItemDesignerPanelProperties.GetComponentClassify: String;
begin
  Result:='SkinItemDesignerPanel';
end;

function TItemDesignerPanelProperties.IsControlHasOldBindingType(AControl: TControl): Boolean;
var
  I: Integer;
begin
  Result:=False;

    //绑定控件
    if (FItemCheckedControl=AControl)
    or (FItemSelectedControl=AControl)
    or (FItemExpandedControl=AControl)
    or (FItemDetailControl=AControl)
    or (FItemDetail1Control=AControl)
    or (FItemDetail2Control=AControl)
    or (FItemDetail3Control=AControl)
    or (FItemDetail4Control=AControl)
    or (FItemDetail5Control=AControl)
    or (FItemDetail6Control=AControl)
    or (FItemCaptionControl=AControl)
    or (FItemAccessoryMoreControl=AControl)

    or (FItemIconControl=AControl)
    or (FItemPicControl=AControl) then
  begin
    Result:=True;
    Exit;
  end;

  for I := 0 to FItemSubItemsBindingControls.Count-1 do
  begin
    if FItemSubItemsBindingControls[I].FBindControl=AControl then
    begin
      Result:=True;
      Exit;
    end;
  end;

end;

procedure TItemDesignerPanelProperties.ProcessItemBindingControlColor(AItemColorType: TSkinItemColorType; AItemColor: TDelphiColor;var AOldColor:TDelphiColor);
begin
  case AItemColorType of
    sictNone: ;
    sictBackColor:
    begin
      //背景颜色
      AOldColor:=Self.FSkinControlIntf.GetCurrentUseMaterial.BackColor.FillDrawColor.FColor;
      Self.FSkinControlIntf.GetCurrentUseMaterial.BackColor.FillDrawColor.FColor:=AItemColor;
    end;
    sictCaptionFontColor:
    begin
      //标题字体颜色
      if Self.FItemCaptionColorIntf<>nil then FItemCaptionColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetailFontColor:
    begin
      if Self.FItemDetailColorIntf<>nil then FItemDetailColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail1FontColor:
    begin
      if Self.FItemDetail1ColorIntf<>nil then FItemDetail1ColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail2FontColor:
    begin
      if Self.FItemDetail2ColorIntf<>nil then FItemDetail2ColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail3FontColor:
    begin
      if Self.FItemDetail3ColorIntf<>nil then FItemDetail3ColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail4FontColor:
    begin
      if Self.FItemDetail4ColorIntf<>nil then FItemDetail4ColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail5FontColor:
    begin
      if Self.FItemDetail5ColorIntf<>nil then FItemDetail5ColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail6FontColor:
    begin
      if Self.FItemDetail6ColorIntf<>nil then FItemDetail6ColorIntf.ProcessItemColor(AItemColorType,AItemColor,AOldColor);
    end;
  end;
end;

procedure TItemDesignerPanelProperties.RestoreItemBindingControlColor(AItemColorType: TSkinItemColorType; AItemColor, AOldColor: TDelphiColor);
begin
  case AItemColorType of
    sictNone: ;
    sictBackColor:
    begin
      //背景颜色
      Self.FSkinControlIntf.GetCurrentUseMaterial.BackColor.FillDrawColor.FColor:=AOldColor;
    end;
    sictCaptionFontColor:
    begin
      //标题字体颜色
      if Self.FItemCaptionColorIntf<>nil then FItemCaptionColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetailFontColor:
    begin
      if Self.FItemDetailColorIntf<>nil then FItemDetailColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail1FontColor:
    begin
      if Self.FItemDetail1ColorIntf<>nil then FItemDetail1ColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail2FontColor:
    begin
      if Self.FItemDetail2ColorIntf<>nil then FItemDetail2ColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail3FontColor:
    begin
      if Self.FItemDetail3ColorIntf<>nil then FItemDetail3ColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail4FontColor:
    begin
      if Self.FItemDetail4ColorIntf<>nil then FItemDetail4ColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail5FontColor:
    begin
      if Self.FItemDetail5ColorIntf<>nil then FItemDetail5ColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
    sictDetail6FontColor:
    begin
      if Self.FItemDetail6ColorIntf<>nil then FItemDetail6ColorIntf.RestoreItemColor(AItemColorType,AItemColor,AOldColor);
    end;
  end;
end;

procedure TItemDesignerPanelProperties.SetItemCaptionControl(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
      FItemCaptionControl,
      FItemCaptionIntf,
      FItemCaptionColorIntf,
      FSkinControl,
      FBindControlInvalidateChange,
      'ItemCaption');
end;

procedure TItemDesignerPanelProperties.SetIsPreview(const Value: Boolean);
begin
  if FIsPreview<>Value then
  begin
    FIsPreview := Value;

    //设计时才需要有效果

    DoPreviewItemChange(nil);
  end;
end;

procedure TItemDesignerPanelProperties.SetItemAccessoryMoreControl(const Value: TChildControl);
begin
  if FItemAccessoryMoreControl<>Value then
  begin
    if Value<>nil then
    begin
      if Not Value.GetInterface(IID_ISkinControl,FItemAccessoryMoreIntf) then
      begin

      end
      else
      begin
        FItemAccessoryMoreControl := Value;
        AddFreeNotification(FItemAccessoryMoreControl,FSkinControl);
      end;
    end
    else
    begin
      FItemAccessoryMoreControl:=nil;
    end;

    //并重绘
    //子控件刷新的时候调用绑定的ListBox,ListView进行刷新
    FBindControlInvalidateChange.DoChange(FSkinControl);

  end;
end;

procedure TItemDesignerPanelProperties.SetItemCheckedControl(const Value: TChildControl);
begin
  SetBindSkinItemBoolControl(Value,
    FItemCheckedControl,FItemCheckedIntf,FSkinControl,FBindControlInvalidateChange);
end;

procedure TItemDesignerPanelProperties.SetItemSelectedControl(const Value: TChildControl);
begin
  SetBindSkinItemBoolControl(Value,
    FItemSelectedControl,FItemSelectedIntf,FSkinControl,FBindControlInvalidateChange);
end;

procedure TItemDesignerPanelProperties.SetItemExpandedControl(const Value: TChildControl);
begin
  SetBindSkinItemBoolControl(Value,
    FItemExpandedControl,FItemExpandedIntf,FSkinControl,FBindControlInvalidateChange);
end;

procedure TItemDesignerPanelProperties.SetItemDetail1Control(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
      FItemDetail1Control,
      FItemDetail1Intf,
      FItemDetail1ColorIntf,
      FSkinControl,
      FBindControlInvalidateChange,
      'ItemDetail1');
end;

procedure TItemDesignerPanelProperties.SetItemDetail2Control(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
    FItemDetail2Control,
    FItemDetail2Intf,
    FItemDetail2ColorIntf,
    FSkinControl,
    FBindControlInvalidateChange,
    'ItemDetail2');
end;

procedure TItemDesignerPanelProperties.SetItemDetail3Control(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
    FItemDetail3Control,
    FItemDetail3Intf,
    FItemDetail3ColorIntf,
    FSkinControl,
    FBindControlInvalidateChange,
    'ItemDetail3');
end;

procedure TItemDesignerPanelProperties.SetItemDetail4Control(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
    FItemDetail4Control,
    FItemDetail4Intf,
    FItemDetail4ColorIntf,
    FSkinControl,
    FBindControlInvalidateChange,
    'ItemDetail4');
end;

procedure TItemDesignerPanelProperties.SetItemDetail5Control(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
    FItemDetail5Control,
    FItemDetail5Intf,
    FItemDetail5ColorIntf,
    FSkinControl,
    FBindControlInvalidateChange,
    'ItemDetail5');
end;

procedure TItemDesignerPanelProperties.SetItemDetail6Control(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
    FItemDetail6Control,
    FItemDetail6Intf,
    FItemDetail6ColorIntf,
    FSkinControl,
    BindControlInvalidateChange,
    'ItemDetail6');
end;

procedure TItemDesignerPanelProperties.SetItemDetailControl(const Value: TChildControl);
begin
  SetBindSkinItemTextControl(Value,
    FItemDetailControl,
    FItemDetailIntf,
    FItemDetailColorIntf,
    FSkinControl,
    FBindControlInvalidateChange,
    'ItemDetail');
end;

procedure TItemDesignerPanelProperties.SetItemIconControl(const Value: TChildControl);
begin
  SetBindSkinItemIconControl(Value,
    FItemIconControl,FItemIconIntf,FSkinControl,FBindControlInvalidateChange);
end;

procedure TItemDesignerPanelProperties.SetItemPicControl(const Value: TChildControl);
begin
  SetBindSkinItemIconControl(Value,
    FItemPicControl,FItemPicIntf,FSkinControl,FBindControlInvalidateChange);
end;

procedure TItemDesignerPanelProperties.SetItemStringsBindingControlCollection(const Value: TItemBindingStringsControls);
begin
  FItemSubItemsBindingControls.Assign(Value);
end;

procedure TItemDesignerPanelProperties.SetPreviewItem(const Value: TDesignTimeRealSkinTreeViewItem);
begin
  FPreviewItem.Assign(Value);
end;

procedure TItemDesignerPanelProperties.SetSkinItemBindingControlsValueByItem(
  AParent:TControl;
  ASkinImageList: TSkinImageList;
  AItem: TSkinItem;
  AIsDrawItemInteractiveState: Boolean);
var
  I: Integer;
  AItemBindingControl:TItemBindingControlItem;
//  AChildControl:TControl;
  ABindItemFieldName:String;
//  ASkinItemBindingControlIntf:ISkinItemBindingControl;
//  ABindSkinItemValueControlIntf:IBindSkinItemValueControl;
//  ABindSkinItemObjectControlIntf:IBindSkinItemObjectControl;
begin
  if not FIsSyncedSkinItemBindingControls then
  begin
    Self.SyncSkinItemBindingControls(AParent);
  end;


  for I := 0 to Self.FItemBindingControlList.Count-1 do
  begin
      AItemBindingControl:=Self.FItemBindingControlList[I];


      //if AItemBindingControl.FChildControl.Visible then//去掉这段代码,因为虽然隐藏了,但是会在OnPrepareDrawItem事件中显示出来,如果不赋值,那么值就不对了
//      begin

          ABindItemFieldName:=AItemBindingControl.FSkinItemBindingControlIntf.GetBindItemFieldName;
          //判断字段值的类型
          if AItem.GetValueTypeByBindItemField(ABindItemFieldName)<>varObject then
          begin
              //普通的值,String,Variant,Boolean
              AItemBindingControl.FBindSkinItemValueControlIntf.SetControlValueByBindItemField(
                                                            ABindItemFieldName,
                                                            //取值,如果是远程图片文件路径,要加上图片服务器地址,页面框架中使用时
                                                            AItem.GetValueByBindItemField(ABindItemFieldName),
                                                            AItem,
                                                            AIsDrawItemInteractiveState
                                                            );
          end
          else
          begin
              //比如ItemIcon,ItemPic
              //图片
              if AItemBindingControl.FBindSkinItemObjectControlIntf<>nil then
              begin
                AItemBindingControl.FBindSkinItemObjectControlIntf.SetControlObjectByBindItemField(
                                                            ABindItemFieldName,
                                                            AItem.GetObjectByBindItemField(ABindItemFieldName),
                                                            AItem,
                                                            AIsDrawItemInteractiveState
                                                            );
              end;
          end;
//      end;
  end;



//  for I := 0 to GetParentChildControlCount(TParentControl(AParent))-1 do
//  begin
//        AChildControl:=GetParentChildControl(TParentControl(AParent),I);
//
//        if AChildControl.GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf)
//          and AChildControl.GetInterface(IID_IBindSkinItemValueControl,ABindSkinItemValueControlIntf) then
//        begin
//
//            AFieldName:=ASkinItemBindingControlIntf.GetBindItemFieldName;
//
//
//
//            if AChildControl is TSkinMultiColorLabel then
//            begin
//              AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name1;
//              if AFieldName='' then AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name2;
//              if AFieldName='' then AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name3;
//              if AFieldName='' then AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name4;
//            end;
//
//
//            if AFieldName<>'' then
//            begin
//                //判断字段值的类型
//                if AItem.GetValueTypeByBindItemField(AFieldName)<>varObject then
//                begin
//                    //普通的值,String,Variant,Boolean
//                    ABindSkinItemValueControlIntf.SetControlValueByBindItemField(
//                                                                  AFieldName,
//                                                                  //取值,如果是远程图片文件路径,要加上图片服务器地址,页面框架中使用时
//                                                                  AItem.GetValueByBindItemField(AFieldName),
//                                                                  AItem,
//                                                                  AIsDrawItemInteractiveState
//                                                                  );
//                end
//                else
//                begin
//                    //比如ItemIcon,ItemPic
//                    //图片
//                    if AChildControl.GetInterface(IID_IBindSkinItemObjectControl,ABindSkinItemObjectControlIntf) then
//                    begin
//                      ABindSkinItemObjectControlIntf.SetControlObjectByBindItemField(
//                                                                  AFieldName,
//                                                                  AItem.GetObjectByBindItemField(AFieldName),
//                                                                  AItem,
//                                                                  AIsDrawItemInteractiveState
//                                                                  );
//                    end;
//
//                end;
//            end
//            else
//            begin
//                //没有绑定字段
//            end;
//        end;
//
//
//
//        if (AChildControl is TParentControl) and (GetParentChildControlCount(TParentControl(AChildControl))>0) then
//        begin
//            //递归
//            SetSkinItemBindingControlsValueByItem(TControl(AChildControl),
//                                                  ASkinImageList,
//                                                  AItem,
//                                                  AIsDrawItemInteractiveState
//                                                  );
//        end;
//  end;
end;


procedure TItemDesignerPanelProperties.SyncSkinItemBindingControls(AParent:TControl);
var
  I: Integer;
  AChildControl:TControl;
  AFieldName:String;
  ASkinItemBindingControlIntf:ISkinItemBindingControl;
  ABindSkinItemValueControlIntf:IBindSkinItemValueControl;
  ABindSkinItemObjectControlIntf:IBindSkinItemObjectControl;

  AItemBindingControl:TItemBindingControlItem;
begin
  if AParent=Self.FSkinControl then
  begin
    Self.FItemBindingControlList.Clear();
  end;

//  if GetParentChildControlCount(TParentControl(AParent))=0 then
//  begin
//    FMX.Types.Log.d('OrangeUI TItemDesignerPanelProperties.SyncSkinItemBindingControls AParent.ChildCount=0');
//  end;

  for I := 0 to GetParentChildControlCount(TParentControl(AParent))-1 do
  begin

        //有子控件才表示取到了
        FIsSyncedSkinItemBindingControls:=True;


        AChildControl:=GetParentChildControl(TParentControl(AParent),I);

        if not IsControlHasOldBindingType(AChildControl)
          and AChildControl.GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf)
          and AChildControl.GetInterface(IID_IBindSkinItemValueControl,ABindSkinItemValueControlIntf) then
        begin

            AFieldName:=ASkinItemBindingControlIntf.GetBindItemFieldName;

            if AChildControl is TSkinMultiColorLabel then
            begin
              AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name1;
              if AFieldName='' then AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name2;
              if AFieldName='' then AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name3;
              if AFieldName='' then AFieldName:=TSkinMultiColorLabel(AChildControl).Prop.Name4;
            end;

            if AFieldName<>'' then
            begin
                AItemBindingControl:=TItemBindingControlItem.Create;
//                AItemBindingControl.FFieldName:=AFieldName;

                AItemBindingControl.FChildControl:=AChildControl;

                AItemBindingControl.FSkinItemBindingControlIntf:=ASkinItemBindingControlIntf;
                AItemBindingControl.FBindSkinItemValueControlIntf:=ABindSkinItemValueControlIntf;

                Self.FItemBindingControlList.Add(AItemBindingControl);


                //比如ItemIcon,ItemPic
                //图片
                if AChildControl.GetInterface(IID_IBindSkinItemObjectControl,ABindSkinItemObjectControlIntf) then
                begin
                  AItemBindingControl.FBindSkinItemObjectControlIntf:=ABindSkinItemObjectControlIntf;
                end;

            end
            else
            begin
                //没有绑定字段
            end;
        end;



        if (AChildControl is TParentControl) and (GetParentChildControlCount(TParentControl(AChildControl))>0) then
        begin
            //递归
            SyncSkinItemBindingControls(TControl(AChildControl));
        end;
  end;
end;

procedure TItemDesignerPanelProperties.SetSkinItemBindingControlValueByItem(
  AControl: TChildControl;
  ASkinImageList: TSkinImageList;
  AItem: TBaseSkinItem;
//  AControl:TChildControl;
  AFieldName:String;
  AValueType: TVarType; AValue: Variant; AValueObject: TObject;
  AIsDrawItemInteractiveState: Boolean);
var
//  I: Integer;
//  AFieldName:String;
//  ASkinItemBindingControlIntf:ISkinItemBindingControl;
  ABindSkinItemValueControlIntf:IBindSkinItemValueControl;
  ABindSkinItemObjectControlIntf:IBindSkinItemObjectControl;
begin
  if AControl.GetInterface(IID_IBindSkinItemValueControl,ABindSkinItemValueControlIntf) then
  begin
      if AValueType<>varObject then//AItem.GetValueTypeByBindItemField(AFieldName)<>varObject then
      begin
          //普通的值
          ABindSkinItemValueControlIntf.SetControlValueByBindItemField(
                                AFieldName,
                                AValue,//AItem.GetValueByBindItemField(AFieldName),
                                AItem,
                                AIsDrawItemInteractiveState
                                );
      end
      else
      begin
          //图片
          if AControl.GetInterface(IID_IBindSkinItemObjectControl,ABindSkinItemObjectControlIntf) then
          begin
            ABindSkinItemObjectControlIntf.SetControlObjectByBindItemField(
                                AFieldName,
                                AValueObject,//AItem.GetObjectByBindItemField(AFieldName),
                                AItem,
                                AIsDrawItemInteractiveState
                                );
          end;

      end;

  end;
end;

{ TItemBindingStringsControls }

function TItemBindingStringsControls.Add: TItemBindingStringsControlItem;
begin
  Result:=TItemBindingStringsControlItem(Inherited Add);
end;

constructor TItemBindingStringsControls.Create(AProperties:TItemDesignerPanelProperties);
begin
  Inherited Create(TItemBindingStringsControlItem);
  FProperties:=AProperties;
end;

destructor TItemBindingStringsControls.Destroy;
begin
  inherited;
end;

function TItemBindingStringsControls.GetItem(Index: Integer): TItemBindingStringsControlItem;
begin
  Result:=TItemBindingStringsControlItem(Inherited Items[Index]);
end;

procedure TItemBindingStringsControls.SetItem(Index: Integer;const Value: TItemBindingStringsControlItem);
begin
  Inherited Items[Index]:=Value;
end;



{ TItemBindingStringsControlItem }

procedure TItemBindingStringsControlItem.AssignTo(Dest: TPersistent);
begin
  if (Dest<>nil) and (Dest is TItemBindingStringsControlItem) then
  begin
    TItemBindingStringsControlItem(Dest).FStringsIndex:=FStringsIndex;
    TItemBindingStringsControlItem(Dest).FStringsKey:=FStringsKey;
    TItemBindingStringsControlItem(Dest).FBindControl:=FBindControl;
    TItemBindingStringsControlItem(Dest).FIntf:=FIntf;
    TItemBindingStringsControlItem(Dest).FColorIntf:=FColorIntf;
  end
  else
  begin
    TItemBindingStringsControlItem(Dest).FStringsIndex:=-1;
    TItemBindingStringsControlItem(Dest).FStringsKey:='';
    TItemBindingStringsControlItem(Dest).FBindControl:=nil;
    TItemBindingStringsControlItem(Dest).FIntf:=nil;
    TItemBindingStringsControlItem(Dest).FColorIntf:=nil;
  end;
end;

function TItemBindingStringsControlItem.BindItemFieldName: String;
begin
  Result:='';
  if Self.FStringsIndex>=0 then
  begin
    Result:='ItemSubItems'+IntToStr(Self.FStringsIndex);
  end
  else if Self.FStringsKey<>'' then
  begin
    Result:='ItemSubItems'+'_'+FStringsKey;
  end;
  
end;

constructor TItemBindingStringsControlItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FStringsKey:='';
  FStringsIndex:=-1;
  FBindControl:=nil;
  FIntf:=nil;
  FColorIntf:=nil;
end;

destructor TItemBindingStringsControlItem.Destroy;
begin
  BindingControl:=nil;
  inherited;
end;

procedure TItemBindingStringsControlItem.SetControl(const Value: TChildControl);
begin
  TItemBindingStringsControls(Collection).FProperties.SetBindSkinItemTextControl(Value,
        FBindControl,
        FIntf,
        FColorIntf,
        TItemBindingStringsControls(Collection).FProperties.FSkinControl,
        TItemBindingStringsControls(Collection).FProperties.BindControlInvalidateChange,
        //这里不好判断啊
        '');
//        'ItemSubStrings'+IntToStr(Self.FStringsIndex));
end;




{ TSkinItemDesignerPanel }

function TSkinItemDesignerPanel.Material:TSkinItemDesignerPanelDefaultMaterial;
begin
  Result:=TSkinItemDesignerPanelDefaultMaterial(SelfOwnMaterial);
end;

function TSkinItemDesignerPanel.SelfOwnMaterialToDefault:TSkinItemDesignerPanelDefaultMaterial;
begin
  Result:=TSkinItemDesignerPanelDefaultMaterial(SelfOwnMaterial);
end;

function TSkinItemDesignerPanel.CurrentUseMaterialToDefault:TSkinItemDesignerPanelDefaultMaterial;
begin
  Result:=TSkinItemDesignerPanelDefaultMaterial(CurrentUseMaterial);
end;

function TSkinItemDesignerPanel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TItemDesignerPanelProperties;
end;

function TSkinItemDesignerPanel.GetItemDesignerPanelProperties: TItemDesignerPanelProperties;
begin
  Result:=TItemDesignerPanelProperties(Self.FProperties);
end;

function TSkinItemDesignerPanel.GetOnPrepareDrawItem: TOnPrepareDrawItemEvent;
begin
  Result := FOnPrepareDrawItem;
end;

function TSkinItemDesignerPanel.GetOnSetControlsValueEnd: TOnSetControlsValueEndEvent;
begin
  Result := FOnSetControlsValueEnd;
end;

procedure TSkinItemDesignerPanel.SetItemDesignerPanelProperties(Value: TItemDesignerPanelProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinItemDesignerPanel.UpdateChild(AControl: TChildControl;AControlIntf:IDirectUIControl);
begin
  //子控件刷新的时候调用绑定的ListBox,ListView进行刷新
  Properties.BindControlInvalidateChange.DoChange(Self);
end;

procedure TSkinItemDesignerPanel.Loaded;
begin
  Inherited;
  //运行时隐藏
  if not (csDesigning in Self.ComponentState) then
  begin
    //运行时不显示
    {$IFDEF FMX}
    //不预览
    Self.Prop.IsPreview:=False;
    Visible:=False;
    {$ENDIF}
    {$IFDEF VCL}
    //不预览
    Self.Prop.IsPreview:=False;
    Align:=TAlign.alNone;
    Left:=-1000;
    Top:=-1000;
    {$ENDIF}

  end;
  if (csDesigning in Self.ComponentState) then
  begin
    Self.Prop.DoPreviewItemChange(nil);
  end;
end;


{$IFDEF FMX}
procedure TSkinItemDesignerPanel.AfterPaint;
//var
//  AScrollBarRect:TRectF;
//var
//  ASkinMaterial:TSkinControlMaterial;
begin
  inherited;



  //绘制绑定项描述
  if csDesigning in Self.ComponentState then
  begin

  end;

//  if TScrollControlProperties(Self.Properties).ScrollBarEmbeddedType=sbetVirtualControl then
//  begin
//      FCanvas.Prepare(Canvas);
//
//
//      //绘制垂直滚动条
//      if TScrollControlProperties(Self.Properties).GetVertScrollBarVisible then
//      begin
//        AScrollBarRect:=TScrollControlProperties(Self.Properties).GetVertScrollBarRect;
//        ASkinMaterial:=Self.FVertScrollBarControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
//        Self.FVertScrollBarControlIntf.GetSkinControlType.Paint(FCanvas,ASkinMaterial,AScrollBarRect,FPaintData);
//      end;
//
//
//      //绘制水平滚动条
//      if TScrollControlProperties(Self.Properties).GetHorzScrollBarVisible then
//      begin
//        AScrollBarRect:=TScrollControlProperties(Self.Properties).GetHorzScrollBarRect;
//        ASkinMaterial:=Self.FHorzScrollBarControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
//        Self.FHorzScrollBarControlIntf.GetSkinControlType.Paint(FCanvas,ASkinMaterial,AScrollBarRect,FPaintData);
//      end;
//
//
//      //绘制滚动框角
//      if TScrollControlProperties(Self.Properties).GetScrollControlCornerVisible then
//      begin
//        AScrollBarRect:=TScrollControlProperties(Self.Properties).GetScrollControlCornerRect;
//        ASkinMaterial:=Self.FScrollControlCornerControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
//        Self.FScrollControlCornerControlIntf.GetSkinControlType.Paint(FCanvas,ASkinMaterial,AScrollBarRect,FPaintData);
//      end;
//
//
//      FCanvas.UnPrepare;
//  end;



end;
{$ENDIF}


procedure TSkinItemDesignerPanel.Notification(AComponent: TComponent; Operation: TOperation);
var
  I:Integer;
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin
      if (AComponent=Self.Properties.ItemCaptionBindingControl) then
      begin
        Self.Properties.ItemCaptionBindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemDetailBindingControl) then
      begin
        Self.Properties.ItemDetailBindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemDetail1BindingControl) then
      begin
        Self.Properties.ItemDetail1BindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemDetail2BindingControl) then
      begin
        Self.Properties.ItemDetail2BindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemDetail3BindingControl) then
      begin
        Self.Properties.ItemDetail3BindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemDetail4BindingControl) then
      begin
        Self.Properties.ItemDetail4BindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemDetail5BindingControl) then
      begin
        Self.Properties.ItemDetail5BindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemDetail6BindingControl) then
      begin
        Self.Properties.ItemDetail6BindingControl:=nil;
      end


      else if (AComponent=Self.Properties.ItemIconBindingControl) then
      begin
        Self.Properties.ItemIconBindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemPicBindingControl) then
      begin
        Self.Properties.ItemPicBindingControl:=nil;
      end


      else if (AComponent=Self.Properties.ItemCheckedBindingControl) then
      begin
        Self.Properties.ItemCheckedBindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemSelectedBindingControl) then
      begin
        Self.Properties.ItemSelectedBindingControl:=nil;
      end
      else if (AComponent=Self.Properties.ItemExpandedBindingControl) then
      begin
        Self.Properties.ItemExpandedBindingControl:=nil;
      end

      else if (AComponent=Self.Properties.ItemAccessoryMoreBindingControl) then
      begin
        Self.Properties.ItemAccessoryMoreBindingControl:=nil;
      end

      else
      begin
        for I := 0 to Self.Properties.ItemStringsBindingControlCollection.Count-1 do
        begin
          if AComponent=Self.Properties.ItemStringsBindingControlCollection[I].BindingControl then
          begin
            Self.Properties.ItemStringsBindingControlCollection[I].BindingControl:=nil;
          end;
        end;
      end;
    end
    ;
  end;
end;




{ TItemBindingControlList }

function TItemBindingControlList.GetItem(Index: Integer): TItemBindingControlItem;
begin
  Result:=TItemBindingControlItem(Inherited Items[Index]);
end;

end.

