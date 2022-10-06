//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     列表视图
///   </para>
///   <para>
///     List view
///   </para>
/// </summary>
unit uSkinListViewType;



interface
{$I FrameWork.inc}

{$I Version.inc}


uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  Math,
  uBaseList,
  uBaseLog,
  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  Dialogs,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,
  {$ENDIF}
  uSkinItems,
  uSkinListLayouts,
  uDrawParam,
  uGraphicCommon,
  uSkinBufferBitmap,

//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}


  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uBinaryTreeDoc,
  uDrawPicture,
  uSkinMaterial,
  uDrawTextParam,
  uDrawLineParam,
  uDrawRectParam,
  uSkinImageList,
  uSkinVirtualListType,
  uSkinCustomListType,
  uSkinItemDesignerPanelType,
  uSkinControlGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;







const
  IID_ISkinListView:TGUID='{D3D65F7C-398C-42DA-B745-B095EF372A4B}';


type
  TListViewProperties=class;
  TSkinListViewItems=class;
  TSkinListViewLayoutsManager=class;



  /// <summary>
  ///   <para>
  ///     列表项
  ///   </para>
  ///   <para>
  ///     ListItem
  ///   </para>
  /// </summary>
  TSkinListViewItem=TRealSkinItem;


//  TListViewEditingItemEvent=procedure(Sender:TObject;AItem:TSkinListViewItem;ABindingControl:TChildControl;AEditControl:TChildControl) of object;
//  TListViewClickItemExEvent=procedure(Sender:TObject;AItem:TSkinListViewItem;X:Double;Y:Double) of object;
//  TListViewClickItemEvent=procedure(Sender:TObject;AItem:TSkinListViewItem) of object;
//  TListViewDoItemEvent=procedure(Sender:TObject;AItem:TSkinListViewItem) of object;
//  TListViewDrawItemEvent=procedure(Sender:TObject;ACanvas:TObject;AItemDesignerPanel:TObject;AItem:TSkinListViewItem;AItemDrawRect:TRect) of object;


  TRectFList=class
  private
    FItems:TList;
    function GetItem(Index: Integer): TRectF;
    procedure SetItem(Index: Integer; const Value: TRectF);
    function GetItemP(Index: Integer): PRectF;
  public
    constructor Create;
    destructor Destroy;override;
  public
    procedure Clear;
    procedure Delete(Index:Integer);
    function Count:Integer;
    procedure Add(ARectF:TRectF);
    procedure Insert(AIndex:Integer;ARectF:TRectF);
    property Items[Index:Integer]:TRectF read GetItem write SetItem;default;
    property PItems[Index:Integer]:PRectF read GetItemP;
  end;


  /// <summary>
  ///   <para>
  ///     列表视图接口
  ///   </para>
  ///   <para>
  ///     Interface of ListView
  ///   </para>
  /// </summary>
  ISkinListView=interface//(ISkinScrollControl)
  ['{D3D65F7C-398C-42DA-B745-B095EF372A4B}']


    function GetListViewProperties:TListViewProperties;
    property Properties:TListViewProperties read GetListViewProperties;
    property Prop:TListViewProperties read GetListViewProperties;
  end;



  /// <summary>
  ///   <para>
  ///     列表视图类型
  ///   </para>
  ///   <para>
  ///     Type of ListView
  ///   </para>
  /// </summary>
  TListViewType=(

                /// <summary>
                ///   列表模式
                ///   <para>
                ///     List Pattern
                ///   </para>
                /// </summary>
                lvtList,
                /// <summary>
                ///   图标模式
                ///   <para>
                ///     Icon Pattern
                ///   </para>
                /// </summary>
                lvtIcon,
                /// <summary>
                ///   瀑布流模式
                ///   <para>
                ///     Waterfall Pattern
                ///   </para>
                /// </summary>
                lvtWaterfall
                );






  /// <summary>
  ///   <para>
  ///     列表视图属性
  ///   </para>
  ///   <para>
  ///     ListView properties
  ///   </para>
  /// </summary>
  TListViewProperties=class(TVirtualListProperties)
  protected

    FSkinListViewIntf:ISkinListView;

    //视图类型
    function GetViewType: TListViewType;
    procedure SetViewType(const Value: TListViewType);

    function GetItemCountPerLine: Integer;
    procedure SetItemCountPerLine(const Value: Integer);

    function GetIsItemCountFitControl: Boolean;
    procedure SetIsItemCountFitControl(const Value: Boolean);

    function GetListLayoutsManager: TSkinListViewLayoutsManager;

  protected
    function GetMouseDownItem: TSkinItem;
    function GetMouseOverItem: TSkinItem;
    function GetSelectedItem: TSkinItem;
    function GetPanDragItem: TSkinItem;

    procedure SetMouseDownItem(Value: TSkinItem);
    procedure SetMouseOverItem(Value: TSkinItem);
    procedure SetSelectedItem(Value: TSkinItem);
    procedure SetPanDragItem(Value: TSkinItem);
  protected
    function GetItems: TSkinListViewItems;
    procedure SetItems(const Value: TSkinListViewItems);

    function GetItemsClass:TBaseSkinItemsClass;override;
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;override;

    //开放平台的框架所需要使用的,存储不同控件的特殊属性,不可能每个属性都加个字段的吧,你说是不是
    procedure GetPropJson(ASuperObject:ISuperObject);override;
    procedure SetPropJson(ASuperObject:ISuperObject);override;

    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;

    //是否可以启用列表项平拖
    function CanEnableItemPanDrag:Boolean;override;
  protected
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public

    /// <summary>
    ///   <para>
    ///     列表项布局管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ListLayoutsManager:TSkinListViewLayoutsManager read GetListLayoutsManager;



    /// <summary>
    ///   <para>
    ///     获取当前交互的列表项
    ///   </para>
    ///   <para>
    ///     Get interactive ListItem
    ///   </para>
    /// </summary>
    function GetInteractiveItem:TSkinItem;
    /// <summary>
    ///   <para>
    ///     获取当前交互的列表项
    ///   </para>
    ///   <para>
    ///     Get interactive ListItem
    ///   </para>
    /// </summary>
    property InteractiveItem:TSkinItem read GetInteractiveItem;



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
    ///     按下的列表项
    ///   </para>
    ///   <para>
    ///     Pressed ListItem
    ///   </para>
    /// </summary>
    property MouseDownItem:TSkinItem read GetMouseDownItem write SetMouseDownItem;

    /// <summary>
    ///   <para>
    ///     停靠的列表项
    ///   </para>
    ///   <para>
    ///     Hovered ListItem
    ///   </para>
    /// </summary>
    property MouseOverItem:TSkinItem read GetMouseOverItem write SetMouseOverItem;


    /// <summary>
    ///   <para>
    ///     平拖的列表项
    ///   </para>
    ///   <para>
    ///     PanDrag ListItem
    ///   </para>
    /// </summary>
    property PanDragItem:TSkinItem read GetPanDragItem write SetPanDragItem;

  published


    /// <summary>
    ///   <para>
    ///     每行列数(-1表示自动计算,0表示横排列,大于0表示指定的值)
    ///   </para>
    ///   <para>
    ///     Columns of every row(-1 means calculate aotumatically,0 means align
    ///     horizontally, bigger than 0 means assigned number)
    ///   </para>
    /// </summary>
    property ColCount:Integer read GetItemCountPerLine write SetItemCountPerLine;

    /// <summary>
    ///   每行列数(-1表示自动计算,0表示横排列,大于0表示指定的值)
    ///   <para>
    ///     Columns of every row(-1 means calculate aotumatically,0 means align
    ///     horizontally, bigger than 0 means assigned number
    ///   </para>
    /// </summary>
    property ItemCountPerLine:Integer read GetItemCountPerLine write SetItemCountPerLine;




    /// <summary>
    ///   <para>
    ///     ItemWidth是否根据ColCount来自动填充控件,比如ListView宽度120,ColCount为3,那么ItemWidth为40
    ///   </para>
    ///   <para>
    ///     Fill Control
    ///   </para>
    /// </summary>
    property IsItemCountFitControl:Boolean read GetIsItemCountFitControl write SetIsItemCountFitControl;




    /// <summary>
    ///   <para>
    ///     列表视图显示类型
    ///   </para>
    ///   <para>
    ///     List view show type
    ///   </para>
    /// </summary>
    property ViewType:TListViewType read GetViewType write SetViewType;




    /// <summary>
    ///   <para>
    ///     列表项列表
    ///   </para>
    ///   <para>
    ///     ListItem List
    ///   </para>
    /// </summary>
    property Items:TSkinListViewItems read GetItems write SetItems;

  end;










  /// <summary>
  ///   <para>
  ///     列表项列表
  ///   </para>
  ///   <para>
  ///     ListItem List
  ///   </para>
  /// </summary>
  TSkinListViewItems=class(TSkinItems)
  private
    function GetItem(Index: Integer): TSkinListViewItem;
    procedure SetItem(Index: Integer; const Value: TSkinListViewItem);
  protected
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
  public
    function Add:TSkinListViewItem;overload;
    function Insert(Index:Integer):TSkinListViewItem;overload;
    property Items[Index:Integer]:TSkinListViewItem read GetItem write SetItem;default;
  end;








  /// <summary>
  ///   <para>
  ///     列表视图逻辑
  ///   </para>
  ///   <para>
  ///     ListView Logic
  ///   </para>
  /// </summary>
  TSkinListViewLayoutsManager=class(TSkinVirtualListLayoutsManager)
  protected

    //实际显示的,每行列表
    //FDisplayItemCountPerLine: Integer;

    procedure SetViewType(const Value: TListViewType);
    procedure SetItemCountPerLine(const Value: Integer);
    procedure SetIsItemCountFitControl(const Value: Boolean);

    procedure DoCalcAllSkinListItemRectAtIconMode(ASkinItems:TBaseList);
    procedure DoCalcAllSkinListItemRectAtWaterfallMode(ASkinItems:TBaseList);
  public
    constructor Create(ASkinList:ISkinList);override;
    destructor Destroy;override;
  public
    FViewType: TListViewType;
    FItemCountPerLine: Integer;
    FIsItemCountFitControl: Boolean;
    //严格限制每行个数再换行
    FIsStrictItemCountPerLine:Boolean;
    //超出控件宽度之后再换行,而不是一个Item显示不下立即换行,用于D区
//    FIsDelayChangeRowWhenOverflowControlSize:Boolean;
    //只根据Item.IsRowEnd来换行
    FIsChangeRowOnlyByItemIsRowEnd:Boolean;


    /// <summary>
    ///   <para>
    ///     计算每行能摆放列表项的个数
    ///   </para>
    ///   <para>
    ///     Calculate numbers of each line
    ///   </para>
    /// </summary>
    function CalcItemCountPerLine:Integer;

    /// <summary>
    ///   <para>
    ///     获取列表项的默认宽度
    ///   </para>
    ///   <para>
    ///     Get ListItem's default width
    ///   </para>
    /// </summary>
    function GetItemDefaultWidth:Double;override;
    /// <summary>
    ///   <para>
    ///     获取列表项的默认高度
    ///   </para>
    ///   <para>
    ///     Get ListItem's default height
    ///   </para>
    /// </summary>
    function GetItemDefaultHeight:Double;override;

    /// <summary>
    ///   <para>
    ///     计算列表项宽度
    ///   </para>
    ///   <para>
    ///     Calculate ListItem's width
    ///   </para>
    /// </summary>
    function CalcItemWidth(AItem:ISkinItem):Double;override;



    /// <summary>
    ///   <para>
    ///     计算内容宽度(用于处理滚动条的Max)
    ///   </para>
    ///   <para>
    ///     Calculate content's width(used for dealing with Max of ScrollBar)
    ///   </para>
    /// </summary>
//    function CalcContentWidth:TControlSize;override;
    /// <summary>
    ///   <para>
    ///     计算内容高度(用于处理滚动条的Max)
    ///   </para>
    ///   <para>
    ///     Calculate content's height(used for dealing with Max of scroll
    ///     bar)
    ///   </para>
    /// </summary>
//    function CalcContentHeight:TControlSize;override;





    /// <summary>
    ///   <para>
    ///     计算绘制的起始和结束下标
    ///   </para>
    ///   <para>
    ///     Calculate start and end index of drawing
    ///   </para>
    /// </summary>
    procedure CalcDrawStartAndEndIndex(ADrawLeftOffset,
                                      ADrawTopOffset//,
//                                      ADrawRightOffset,
//                                      ADrawBottomOffset
                                      :Double;
                                      AControlWidth,AControlHeight:Double;
                                      var ADrawStartIndex:Integer;
                                      var ADrawEndIndex:Integer);override;







    /// <summary>
    ///   <para>
    ///     计算每个列表项的绘制矩形
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure DoCalcAllSkinListItemRect(ASkinItems:TBaseList);override;


    /// <summary>
    ///   <para>
    ///     列表视图的显示类型
    ///   </para>
    ///   <para>
    ///     ListView Type
    ///   </para>
    /// </summary>
    property ViewType:TListViewType read FViewType write SetViewType;




    /// <summary>
    ///   <para>
    ///     每行列数
    ///   </para>
    ///   <para>
    ///     Columns of each line
    ///   </para>
    /// </summary>
    property ItemCountPerLine:Integer read FItemCountPerLine write SetItemCountPerLine;




    /// <summary>
    ///   <para>
    ///     填充控件
    ///   </para>
    ///   <para>
    ///     Fill control
    ///   </para>
    /// </summary>
    property IsItemCountFitControl:Boolean read FIsItemCountFitControl write SetIsItemCountFitControl;
  end;


  TControlLayoutItems=class;

  TControlLayoutItem=class(TInterfacedPersistent,ISkinItem)
  public
    //比如TTS是Component,而不是Control
    Component:TComponent;

  public
    //ISkinItem接口,用于排列

    //列表中的矩形
    FItemRect:TRectF;
    //绘制矩形(加上了滚动偏移)
    FItemDrawRect:TRectF;

    FSkinListIntf:ISkinList;


    FHeight:Double;
    FWidth:Double;
//    FIsRowEnd:Boolean;
    FThisRowItemCount:Integer;

    function GetWidth:Double;virtual;
    function GetHeight:Double;virtual;
    function GetLevel:Integer;
    function GetVisible:Boolean;virtual;
    function GetSelected:Boolean;
    function GetObject:TObject;
    //设置所属的列表(用于更改Width,Height等其他属性的时候调用OnChange事件)
    procedure SetSkinListIntf(ASkinListIntf:ISkinList);
//    function GetListLayoutsManager:TSkinListLayoutsManager;
    function GetIsRowEnd:Boolean;
    function GetThisRowItemCount:Integer;
    procedure ClearItemRect;

    function GetItemRect:TRectF;
    procedure SetItemRect(Value:TRectF);

    function GetItemDrawRect:TRectF;
    procedure SetItemDrawRect(Value:TRectF);
    //鼠标是否在Item里面
    function PtInItem(APoint:TPointF):Boolean;
  public
    constructor Create();virtual;

  end;




  TControlLayoutItems=class(TBaseList,ISkinList)
  private
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
  private
    function GetItem(Index: Integer): TControlLayoutItem;
  public
    property Items[Index:Integer]:TControlLayoutItem read GetItem;default;
  public
    FListLayoutsManager:TSkinListViewLayoutsManager;

    //调用DoItemVisibleChange
    procedure DoChange;override;
    //调用DoItemVisibleChange
    procedure EndUpdate(AIsForce:Boolean=False);override;
  public
    constructor Create(
                        const AObjectOwnership:TObjectOwnership=ooOwned;
                        const AIsCreateObjectChangeManager:Boolean=True
                        );
    destructor Destroy;override;
    //排列控件
    procedure AlignControls;
    function Add(AControl:TControl;
                  AItemWidth:Double;
                  AItemHeight:Double):TControlLayoutItem;overload;
  end;





  TSkinListViewDefaultType=class(TSkinVirtualListDefaultType)
  protected
    FSkinListViewIntf:ISkinListView;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  protected
    function GetSkinMaterial:TSkinListViewDefaultMaterial;
    //绘制分隔线
    function AdvancedCustomPaintContent(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinListView=class(TSkinVirtualList,ISkinListView,ISkinItems)
  private


    function GetListViewProperties:TListViewProperties;
    procedure SetListViewProperties(Value:TListViewProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;

  public
    function SelfOwnMaterialToDefault:TSkinListViewDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinListViewDefaultMaterial;
    function Material:TSkinListViewDefaultMaterial;
  public
    property Prop:TListViewProperties read GetListViewProperties write SetListViewProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TListViewProperties read GetListViewProperties write SetListViewProperties;

    //垂直滚动条
    property VertScrollBar;
    //水平滚动条
    property HorzScrollBar;

  end;




  {$IFDEF VCL}
  TSkinWinListView=class(TSkinListView)
  end;
  {$ENDIF VCL}




function GetViewTypeStr(AViewType:TListViewType):String;
function GetViewTypeByStr(AViewTypeStr:String):TListViewType;


implementation



function GetViewTypeStr(AViewType:TListViewType):String;
begin
  case AViewType of
    lvtList: Result:='List';
    lvtIcon: Result:='Icon';
    lvtWaterfall: Result:='Waterfall';
  end;
end;

function GetViewTypeByStr(AViewTypeStr:String):TListViewType;
begin
  if SameText(AViewTypeStr,'Waterfall') then
  begin
    Result:=lvtWaterfall;
  end
  else if SameText(AViewTypeStr,'Icon') then
  begin
    Result:=lvtIcon;
  end
  else
  begin
    Result:=lvtList;
  end;
end;





{ TListViewProperties }

function TListViewProperties.GetInteractiveItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited InteractiveItem);
end;

function TListViewProperties.GetIsItemCountFitControl: Boolean;
begin
  Result:=ListLayoutsManager.IsItemCountFitControl;
end;

function TListViewProperties.GetItems: TSkinListViewItems;
begin
  Result:=TSkinListViewItems(FItems);
end;

function TListViewProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TSkinListViewItems;
end;

function TListViewProperties.GetListLayoutsManager: TSkinListViewLayoutsManager;
begin
  Result:=TSkinListViewLayoutsManager(Self.FListLayoutsManager);
end;

function TListViewProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinListViewLayoutsManager;
end;

function TListViewProperties.GetMouseDownItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited MouseDownItem);
end;

function TListViewProperties.GetMouseOverItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited MouseOverItem);
end;

function TListViewProperties.GetPanDragItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited PanDragItem);
end;

procedure TListViewProperties.GetPropJson(ASuperObject: ISuperObject);
begin
  inherited;
//    ListLayoutsManager.FViewType:=lvtIcon;
//    ListLayoutsManager.FItemCountPerLine:=-1;
//    ListLayoutsManager.StaticItemWidth:=Const_DefaultItemWidth;

  if ColCount<>-1 then ASuperObject.I['ColCount']:=ColCount;
  if not IsItemCountFitControl then ASuperObject.B['IsItemCountFitControl']:=IsItemCountFitControl;
  if ViewType<>lvtIcon then ASuperObject.S['ViewType']:=GetViewTypeStr(ViewType);

end;

function TListViewProperties.GetSelectedItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited SelectedItem);
end;

function TListViewProperties.GetViewType: TListViewType;
begin
  Result:=ListLayoutsManager.FViewType;
end;

function TListViewProperties.CanEnableItemPanDrag: Boolean;
begin
  Result:=(Self.ViewType=lvtList)
    and (Inherited CanEnableItemPanDrag);
end;

constructor TListViewProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinListView,Self.FSkinListViewIntf) then
  begin
    ShowException('This Component Do not Support ISkinListView Interface');
  end
  else
  begin

    ListLayoutsManager.FViewType:=lvtIcon;
    ListLayoutsManager.FItemCountPerLine:=-1;
    ListLayoutsManager.StaticItemWidth:=Const_DefaultItemWidth;

  end;
end;

destructor TListViewProperties.Destroy;
begin
  inherited;
end;

function TListViewProperties.GetItemCountPerLine: Integer;
begin
  Result:=ListLayoutsManager.FItemCountPerLine;
end;

function TListViewProperties.GetComponentClassify: String;
begin
  Result:='SkinListView';
end;

procedure TListViewProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;

  ColCount:=TListViewProperties(Src).ColCount;
  IsItemCountFitControl:=TListViewProperties(Src).IsItemCountFitControl;

end;

procedure TListViewProperties.SetViewType(const Value: TListViewType);
begin
  ListLayoutsManager.ViewType:=Value;
end;

procedure TListViewProperties.SetIsItemCountFitControl(const Value: Boolean);
begin
  ListLayoutsManager.IsItemCountFitControl:=Value;
end;

procedure TListViewProperties.SetItemCountPerLine(const Value: Integer);
begin
  ListLayoutsManager.ItemCountPerLine:=Value;
end;

procedure TListViewProperties.SetItems(const Value: TSkinListViewItems);
begin
  Inherited SetItems(Value);
end;

procedure TListViewProperties.SetMouseDownItem(Value: TSkinItem);
begin
  Inherited MouseDownItem:=Value;
end;

procedure TListViewProperties.SetMouseOverItem(Value: TSkinItem);
begin
  Inherited MouseOverItem:=Value;
end;

procedure TListViewProperties.SetSelectedItem(Value: TSkinItem);
begin
  Inherited SelectedItem:=Value;
end;

procedure TListViewProperties.SetPanDragItem(Value: TSkinItem);
begin
  Inherited PanDragItem:=Value;
end;

procedure TListViewProperties.SetPropJson(ASuperObject: ISuperObject);
begin
  inherited;
//    ListLayoutsManager.FViewType:=lvtIcon;
//    ListLayoutsManager.FItemCountPerLine:=-1;
//    ListLayoutsManager.StaticItemWidth:=Const_DefaultItemWidth;


  {$IF CompilerVersion >= 30.0}
  if ASuperObject.Contains('ColCount') then ColCount:=ASuperObject.I['ColCount'];
  if ASuperObject.Contains('IsItemCountFitControl') then IsItemCountFitControl:=ASuperObject.B['IsItemCountFitControl'];
  if ASuperObject.Contains('ViewType') then ViewType:=GetViewTypeByStr(ASuperObject.S['ViewType']);
  {$IFEND}

end;

{ TSkinListViewDefaultType }

function TSkinListViewDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinListView,Self.FSkinListViewIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinListView Interface');
    end;
  end;
end;

function TSkinListViewDefaultType.AdvancedCustomPaintContent(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF; APaintData: TPaintData): Boolean;
var
  Temp:Double;
  First:Boolean;
begin

  if (Self.FSkinListViewIntf.Prop.ViewType=lvtIcon)
    //每行列数大于1
    and (Self.FSkinListViewIntf.Prop.ListLayoutsManager.CalcItemCountPerLine>1)
    //存在绘制项
    and (FFirstDrawItem<>nil)
    //绘制行列线
    and (GetSkinMaterial.IsDrawRowLine or GetSkinMaterial.IsDrawColLine) then
  begin



      if GetSkinMaterial.IsDrawColLine then
      begin
          //画列列分隔线
          Temp:=FFirstDrawItemRect.Left;
          First:=True;
          while SmallerEqualDouble(Temp,FLastColDrawItemRect.Right) do
          begin
              if
                //需要绘制首列分隔线
                not (First and not GetSkinMaterial.FIsDrawColBeginLine)
                //需要绘制末列分隔线
                and Not (IsSameDouble(Temp,FLastColDrawItemRect.Right) and not GetSkinMaterial.FIsDrawColEndLine) then
              begin
                if First then
                begin
                    //首列的列头线
                    if EqualDouble(FFirstDrawItemRect.Left,ADrawRect.Left) then
                    begin
                      //最左边
                      ACanvas.DrawLine(GetSkinMaterial.DrawColLineParam,
                                        Temp+GetSkinMaterial.DrawColLineParam.PenWidth/2,
                                        FFirstDrawItemRect.Top,
                                        Temp+GetSkinMaterial.DrawColLineParam.PenWidth/2,
                                        FLastRowDrawItemRect.Bottom);
                    end
                    else
                    begin
                      ACanvas.DrawLine(GetSkinMaterial.DrawColLineParam,
                                        Temp,
                                        FFirstDrawItemRect.Top,
                                        Temp,
                                        FLastRowDrawItemRect.Bottom);
                    end;

                end
                else if IsSameDouble(Temp,FLastColDrawItemRect.Right) then
                begin
                    //尾列的列尾线
                    if EqualDouble(FLastColDrawItemRect.Right,ADrawRect.Right) then
                    begin
                      //最右边
                      ACanvas.DrawLine(GetSkinMaterial.DrawColLineParam,
                                        Temp-GetSkinMaterial.DrawColLineParam.PenWidth/2,
                                        FFirstDrawItemRect.Top,
                                        Temp-GetSkinMaterial.DrawColLineParam.PenWidth/2,
                                        FLastRowDrawItemRect.Bottom);
                    end
                    else
                    begin
                      ACanvas.DrawLine(GetSkinMaterial.DrawColLineParam,
                                        Temp,
                                        FFirstDrawItemRect.Top,
                                        Temp,
                                        FLastRowDrawItemRect.Bottom);
                    end;
                end
                else
                begin
                  ACanvas.DrawLine(GetSkinMaterial.DrawColLineParam,
                                    Temp,FFirstDrawItemRect.Top,
                                    Temp,FLastRowDrawItemRect.Bottom);

                end;
              end;
              First:=False;
              Temp:=Temp+RectWidthF(FFirstDrawItemRect);
          end;
      end;



    if GetSkinMaterial.IsDrawRowLine then
    begin
        //画行行分隔线
        Temp:=FFirstDrawItemRect.Top;
        First:=True;
        while SmallerEqualDouble(Temp,FLastRowDrawItemRect.Bottom) do
        begin
          if not (First and not GetSkinMaterial.FIsDrawRowBeginLine)
            //是否绘制末行分隔线
            and Not (IsSameDouble(Temp,FLastRowDrawItemRect.Bottom) and not GetSkinMaterial.FIsDrawRowEndLine) then
          begin
              if First then
              begin
                  //首行的行开始线
                  if EqualDouble(FFirstDrawItemRect.Top,ADrawRect.Top) then
                  begin
                    //最顶部
                    ACanvas.DrawLine(GetSkinMaterial.DrawRowLineParam,
                                      FFirstDrawItemRect.Left,
                                      Temp+GetSkinMaterial.DrawRowLineParam.PenWidth/2,
                                      FLastColDrawItemRect.Right,
                                      Temp+GetSkinMaterial.DrawRowLineParam.PenWidth/2);
                  end
                  else
                  begin
                    ACanvas.DrawLine(GetSkinMaterial.DrawRowLineParam,
                                      FFirstDrawItemRect.Left,
                                      Temp,
                                      FLastColDrawItemRect.Right,
                                      Temp);
                  end;
              end
              else
              begin
                  ACanvas.DrawLine(GetSkinMaterial.DrawRowLineParam,
                                    FFirstDrawItemRect.Left,Temp,
                                    FLastColDrawItemRect.Right,Temp);
              end;
            end;
            First:=False;
            Temp:=Temp+RectHeightF(FFirstDrawItemRect);
        end;
    end;

  end;


end;

procedure TSkinListViewDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinListViewIntf:=nil;
end;

function TSkinListViewDefaultType.GetSkinMaterial: TSkinListViewDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinListViewDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;




{ TSkinListViewItems }


function TSkinListViewItems.Add: TSkinListViewItem;
begin
  Result:=TSkinListViewItem(Inherited Add);
end;

//procedure TSkinListViewItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TSkinListViewItem;
//end;

function TSkinListViewItems.Insert(Index:Integer):TSkinListViewItem;
begin
  Result:=TSkinListViewItem(Inherited Insert(Index));
end;

procedure TSkinListViewItems.SetItem(Index: Integer;const Value: TSkinListViewItem);
begin
  Inherited Items[Index]:=Value;
end;

//function TSkinListViewItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=SkinItemClass.Create(Self);
//end;

function TSkinListViewItems.GetItem(Index: Integer): TSkinListViewItem;
begin
  Result:=TSkinListViewItem(Inherited Items[Index]);
end;




function TSkinListViewItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TSkinListViewItem;
end;

{ TSkinListViewItem }






{ TSkinListViewLayoutsManager }

//function TSkinListViewLayoutsManager.CalcContentHeight: TControlSize;
//begin
////  if Self.FViewType=TListViewType.lvtList then
////  begin
//    Result:=(inherited CalcContentHeight);
////  end
////  else
////  begin
////    case Self.FItemLayoutType of
////      iltVertical:
////      begin
////        //垂直列表
//////        case Self.FItemSizeCalcType of
//////          isctFixed:
//////          begin
//////            //每个列表项固定高度
//////            //行数*行高
//////            Result:=Ceil(Self.GetVisibleItemsCount/Self.CalcItemCountPerLine)
//////                    *Self.GetItemDefaultHeight
//////                    +FItemSpace
//////                    ;
//////          end;
//////          isctSeparate:
//////          begin
////            //每个
////            Result:=CalcItemsMaxBottom
//////                    +FItemSpace
////                    ;
//////          end;
//////        end;
////      end;
////      iltHorizontal:
////      begin
////        //水平列表
////        Result:=CalcItemsMaxBottom;
////      end;
////    end;
////  end;
//end;
//
//function TSkinListViewLayoutsManager.CalcContentWidth: TControlSize;
//begin
////  if Self.FViewType=TListViewType.lvtList then
////  begin
//    Result:=(inherited CalcContentWidth);
////  end
////  else
////  begin
////    case Self.FItemLayoutType of
////      iltVertical:
////      begin
////        //垂直列表
////        //如果是简单计算
////        case Self.FItemSizeCalcType of
////          isctFixed:
////          begin
////            //列数*项目宽度
////            Result:=Self.CalcItemCountPerLine*Self.GetItemDefaultWidth;
////          end;
////          isctSeparate:
////          begin
////            Result:=CalcItemsMaxRight;
////          end;
////        end;
////
////      end;
////      iltHorizontal:
////      begin
////        Result:=CalcItemsMaxRight
//////                +FItemSpace
////                ;
////      end;
////    end;
////  end;
//end;

procedure TSkinListViewLayoutsManager.CalcDrawStartAndEndIndex(ADrawLeftOffset,
                                      ADrawTopOffset//,
//                                      ADrawRightOffset,
//                                      ADrawBottomOffset
                                      :Double;
                                      AControlWidth,AControlHeight:Double;
                                      var ADrawStartIndex:Integer;
                                      var ADrawEndIndex:Integer);
var
  AItemCountPerLine:Integer;
begin
  if Self.FViewType=TListViewType.lvtList then
  begin
    //列表模式下使用默认
    inherited;
  end
  else
  begin


    if (Self.FItemSizeCalcType=TItemSizeCalcType.isctFixed)
      //and (Self.FItemCountPerLine>0)
      and (Self.FItemLayoutType=iltVertical) then
    begin

        AItemCountPerLine:=CalcItemCountPerLine;




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





        //列表项宽高固定的情况
        //高度固定
        ADrawStartIndex:=Floor(
                            ADrawTopOffset
                              /(Self.GetItemDefaultHeight+Self.FItemSpace)
                          )
                          //每行个数
                          *AItemCountPerLine
  //                        -1*AItemCountPerLine
                          ;//误差

        ADrawEndIndex:=ADrawStartIndex
                        +Ceil(
                              AControlHeight
                              /(GetItemDefaultHeight+Self.FItemSpace)
                              )
                        //每行个数
                        *AItemCountPerLine
                        +1*AItemCountPerLine
                        ;//误差





        if (ADrawStartIndex<0) then
        begin
          ADrawStartIndex:=0;
        end;

        if (ADrawEndIndex>Self.GetVisibleItemsCount-1) then
        begin
          ADrawEndIndex:=Self.GetVisibleItemsCount-1;
        end;

    end
    else
    begin

          //不能这样,这样的话会造成列表项样式缓存超出
//        ADrawStartIndex:=0;
//        ADrawEndIndex:=Self.GetVisibleItemsCount-1;


        //使用默认
        inherited;

    end;


  end;
end;

constructor TSkinListViewLayoutsManager.Create(ASkinList:ISkinList);
begin
  inherited;

  FIsStrictItemCountPerLine:=False;

  FViewType:=TListViewType.lvtList;

  FItemCountPerLine:=-1;
  FIsItemCountFitControl:=True;
end;

destructor TSkinListViewLayoutsManager.Destroy;
begin

  inherited;
end;

procedure TSkinListViewLayoutsManager.DoCalcAllSkinListItemRect(ASkinItems:TBaseList);
begin

  case FViewType of
    //列表模式
    lvtList: inherited;
    //图标模式
    lvtIcon: DoCalcAllSkinListItemRectAtIconMode(ASkinItems);
    //瀑布流模式
    lvtWaterfall: DoCalcAllSkinListItemRectAtWaterfallMode(ASkinItems);
  end;

end;

procedure TSkinListViewLayoutsManager.DoCalcAllSkinListItemRectAtIconMode(ASkinItems:TBaseList);
var
  I: Integer;

  ASkinItem:ISkinItem;
  ALastSkinItem:ISkinItem;
  AItemRect:TRectF;
  AItemWidth:Double;
  AItemHeight:Double;

  AItemCountPerLine:Integer;

  ALastRowMaxItemHeight:Double;
  ALastRowMaxItemWidth:Double;

//  AIsNeedDelayChangeLine:Boolean;
begin

    ALastSkinItem:=nil;
    FCalcItemsMaxBottom:=0;
    FCalcItemsMaxRight:=0;

    case Self.FItemLayoutType of
      iltVertical:
      begin
                //垂直列表
                //逐个排列


                //初始
                AItemRect.Left:=0;
                AItemRect.Top:=0;
                AItemRect.Bottom:=0;
                AItemRect.Right:=0;
                case Self.FItemSpaceType of
                  sistDefault:
                  begin
                    //每个列表项都有间隔
                    AItemRect.Left:=AItemRect.Left+FItemSpace;
                    AItemRect.Top:=AItemRect.Top+FItemSpace;
                  end;
                  sistMiddle:
                  begin
                    //首末无间隔
                  end;
                end;

                AItemCountPerLine:=0;
//                FDisplayItemCountPerLine:=0;

                ALastRowMaxItemHeight:=0;





                //一个个计算
//                for I := 0 to Self.GetVisibleItemsCount-1 do
                for I := 0 to ASkinItems.Count-1 do
                begin
//                        ASkinItem:=Self.GetVisibleItem(I);
                        ASkinItems[I].GetInterface(IID_ISkinItem,ASkinItem);


                        AItemWidth:=CalcItemWidth(ASkinItem);
                        AItemHeight:=CalcItemHeight(ASkinItem);


                        //在VCL下有误差
//                        uBaseLog.OutputDebugString('AItemRect.Left+AItemWidth'+FloatToStr(AItemRect.Left+AItemWidth));
//                        uBaseLog.OutputDebugString('GetControlWidth'+FloatToStr(GetControlWidth));


//                        AIsNeedDelayChangeLine:=False;
//                        //延迟换行
//                        if (I>0) and BiggerDouble(AItemRect.Left+AItemWidth,Self.GetControlWidth) and FIsDelayChangeRowWhenOverflowControlSize
//                                  //不严格列数,那么立即换行
//                                  and (not FIsStrictItemCountPerLine //and (FItemCountPerLine<=0)
//                                        //严格列数,并且设置了每行个数
//                                        or FIsStrictItemCountPerLine and (FItemCountPerLine>0) ) then
//                        begin
//                          AIsNeedDelayChangeLine:=True;
//                        end;


                        //有些是快要超出了就换行,有些是超出了,再换行
                        //之前累加的宽度加上当前这个列表项的宽度超出控件宽度了,则换行
                        if (I>0) and BiggerDouble(AItemRect.Left+AItemWidth,Self.GetControlWidth) //and not FIsDelayChangeRowWhenOverflowControlSize
                                  //不严格列数,那么立即换行
                                  and (not FIsStrictItemCountPerLine //and (FItemCountPerLine<=0)
                                        //严格列数,并且设置了每行个数
                                        or FIsStrictItemCountPerLine and (FItemCountPerLine>0) )
                                  and not Self.FIsChangeRowOnlyByItemIsRowEnd

                          //或者个数超出固定数了要换行
                          or (FItemCountPerLine>0) and (AItemCountPerLine=Self.FItemCountPerLine)

                          //上一个是行末Item
                          or (I>0) and (ALastSkinItem.GetIsRowEnd)
                           then
                        begin
//                            FDisplayItemCountPerLine:=AItemCountPerLine;


                            //要换行了,加上上一行的最大高度及间隔
                            AItemRect.Top:=AItemRect.Top+ALastRowMaxItemHeight+FItemSpace;
                            AItemRect.Left:=0;
                            case Self.FItemSpaceType of
                              sistDefault:
                              begin
                                //每个列表项都有间隔
                                AItemRect.Left:=AItemRect.Left+FItemSpace;
                              end;
                              sistMiddle:
                              begin
                                //首末无间隔
                              end;
                            end;

                            //每行个数清0
                            AItemCountPerLine:=0;
                            //最大高度清0
                            ALastRowMaxItemHeight:=0;

//                            if ASkinItems[I] is TSkinItem then
//                            begin
//                              TSkinItem(ASkinItems[I]).FDrawColIndex:=0;
//                            end;

                        end;

                        AItemRect.Right:=AItemRect.Left+AItemWidth;
                        AItemRect.Bottom:=AItemRect.Top+AItemHeight;

                        //计算最大行高,以便下次换行时添加
                        if AItemHeight>ALastRowMaxItemHeight then
                        begin
                          ALastRowMaxItemHeight:=AItemHeight;
                        end;

                        //设置列表项绘制矩形
                        ASkinItem.SetItemRect(AItemRect);

                        Inc(AItemCountPerLine);


                        if FCalcItemsMaxRight<AItemRect.Right then
                        begin
                          FCalcItemsMaxRight:=AItemRect.Right;
                        end;
                        if FCalcItemsMaxBottom<AItemRect.Bottom then
                        begin
                          FCalcItemsMaxBottom:=AItemRect.Bottom;
                        end;




                        //加上间隔
                        AItemRect.Left:=AItemRect.Right+FItemSpace;


//                        if AIsNeedDelayChangeLine then
//                        begin
//                            //要换行了,加上上一行的最大高度及间隔
//                            AItemRect.Top:=AItemRect.Top+ALastRowMaxItemHeight+FItemSpace;
//                            AItemRect.Left:=0;
//                            case Self.FItemSpaceType of
//                              sistDefault:
//                              begin
//                                //每个列表项都有间隔
//                                AItemRect.Left:=AItemRect.Left+FItemSpace;
//                              end;
//                              sistMiddle:
//                              begin
//                                //首末无间隔
//                              end;
//                            end;
//
//                            //每行个数清0
//                            AItemCountPerLine:=0;
//                            //最大高度清0
//                            ALastRowMaxItemHeight:=0;
//
//                        end;


                        ALastSkinItem:=ASkinItem;
                end;


      end;
      iltHorizontal:
      begin
                //水平列表

                //初始
                AItemRect.Top:=0;
                AItemRect.Bottom:=0;
                AItemRect.Left:=0;
                AItemRect.Right:=0;
                case Self.FItemSpaceType of
                  sistDefault:
                  begin
                    //每个列表项都有间隔
                    AItemRect.Left:=AItemRect.Left+FItemSpace;
                    AItemRect.Top:=AItemRect.Top+FItemSpace;
                  end;
                  sistMiddle:
                  begin
                    //首末无间隔
                  end;
                end;


                AItemCountPerLine:=0;

                ALastRowMaxItemWidth:=0;





                //一个个计算
//                for I := 0 to Self.GetVisibleItemsCount-1 do
                for I := 0 to ASkinItems.Count-1 do
                begin
//                      ASkinItem:=Self.GetVisibleItem(I);
                      ASkinItems[I].GetInterface(IID_ISkinItem,ASkinItem);


                      AItemWidth:=CalcItemWidth(ASkinItem);
                      AItemHeight:=CalcItemHeight(ASkinItem);


                      //宽度超出了
                      if (I>0) and BiggerDouble(AItemRect.Top+AItemHeight,Self.GetControlHeight) and (FItemCountPerLine<=0)
                          //个数超出固定数了
                          or (FItemCountPerLine>0) and (AItemCountPerLine=Self.FItemCountPerLine)
                          then
                      begin
//                            FDisplayItemCountPerLine:=AItemCountPerLine;

                            //要换行了,加上上一行的最大高度
                            AItemRect.Left:=AItemRect.Left+ALastRowMaxItemWidth+FItemSpace;
                            AItemRect.Top:=0;
                             case Self.FItemSpaceType of
                              sistDefault:
                              begin
                                //每个列表项都有间隔
                                AItemRect.Top:=AItemRect.Top+FItemSpace;
                              end;
                              sistMiddle:
                              begin
                                //首末无间隔
                              end;
                            end;


                            //每行个数清0
                            AItemCountPerLine:=0;
                            //最大宽度清0
                            ALastRowMaxItemWidth:=0;
                      end;


                      AItemRect.Right:=AItemRect.Left+AItemWidth;
                      AItemRect.Bottom:=AItemRect.Top+AItemHeight;


                      if AItemWidth>ALastRowMaxItemWidth then
                      begin
                        ALastRowMaxItemWidth:=AItemWidth;
                      end;


                      ASkinItem.SetItemRect(AItemRect);

                      Inc(AItemCountPerLine);



                      if FCalcItemsMaxRight<AItemRect.Right then
                      begin
                        FCalcItemsMaxRight:=AItemRect.Right;
                      end;
                      if FCalcItemsMaxBottom<AItemRect.Bottom then
                      begin
                        FCalcItemsMaxBottom:=AItemRect.Bottom;
                      end;







                      //加上间隔
                      AItemRect.Top:=AItemRect.Bottom+FItemSpace;

                end;


      end;
    end;



end;

procedure TSkinListViewLayoutsManager.DoCalcAllSkinListItemRectAtWaterfallMode(ASkinItems:TBaseList);
var
  I:Integer;
  J:Integer;

  AItemRect:TRectF;
  ASkinItem:ISkinItem;
  AItemWidth:Double;
  AItemHeight:Double;

  ALastRowRectListStr:String;
  ALastRowRectList:TRectFList;
  ATempLastRowRectList:Array [0..100] of TRectF;
  AMinBottomRectIndex:Integer;
  ALastMinBottomRectIndex:Integer;
  ASumRowSpace:Double;

  ALastAddSumRowSpaceIndex:Integer;

  ALeftItemWidth:Double;
  ANewItemRect:TRectF;
  AIsNeedInsertNewRect:Boolean;

  ANullRect:TRectF;
begin
  ANullRect:=RectF(0,0,0,0);
  FCalcItemsMaxBottom:=0;
  FCalcItemsMaxRight:=0;


  case Self.FItemLayoutType of
    iltVertical:
    begin
              //垂直列表
              //逐个排列
              ALastRowRectList:=TRectFList.Create;


              
              //初始一个Item,宽度是控件的宽度
              AItemRect.Left:=0;
              AItemRect.Top:=0;
              AItemRect.Bottom:=0;
              AItemRect.Right:=GetControlWidth;

              //初始ALastRowRectList
              ALastRowRectList.Add(AItemRect);
              



              //一个个计算
//              for I := 0 to Self.GetVisibleItemsCount-1 do
              for I := 0 to ASkinItems.Count-1 do
              begin
//                      ASkinItem:=Self.GetVisibleItem(I);
                      ASkinItems[I].GetInterface(IID_ISkinItem,ASkinItem);


                      AItemWidth:=CalcItemWidth(ASkinItem);
                      AItemHeight:=CalcItemHeight(ASkinItem);


                      //初始
                      //先找出最小高度的矩形
                      AMinBottomRectIndex:=0;
                      //可放下的宽度
                      ASumRowSpace:=0;
                      //上次添加空间的下标
                      ALastAddSumRowSpaceIndex:=0;





                      //清空
                      for J := 0 to Length(ATempLastRowRectList)-1 do
                      begin
                        ATempLastRowRectList[J]:=ANullRect;
                      end;

                      //如果相同高度,那么合并
                      for J := ALastRowRectList.Count-1 downto 1 do
                      begin
                        if IsSameDouble(ALastRowRectList[J].Bottom,ALastRowRectList[J-1].Bottom)
                          and IsSameDouble(ALastRowRectList[J].Left,ALastRowRectList[J-1].Right) then
                        begin
                          uBaseLog.OutputDebugString('合并');
                          ALastRowRectList.PItems[J-1].Right:=ALastRowRectList[J].Right;
                          ALastRowRectList.Delete(J);
                          if ALastRowRectList.PItems[J-1].Width<0 then
                          begin
                            uBaseLog.OutputDebugString('合并 宽度竟然小于0');
                          end;
                        end
                        else if IsSameDouble(ALastRowRectList[J].Left,ALastRowRectList[J].Right) then
                        begin
                          uBaseLog.OutputDebugString('删除');
                          ALastRowRectList.Delete(J);
                        end;

                      end;
                      //备份
                      ALastRowRectListStr:='ItemIndex:'+IntToStr(I);
                      for J := 0 to ALastRowRectList.Count-1 do
                      begin
                        ATempLastRowRectList[J]:=ALastRowRectList[J];
                        ALastRowRectListStr:=ALastRowRectListStr+' '+'Rect:'+IntToStr(J)+'='
                                              +'('+IntToStr(Ceil(ALastRowRectList[J].Left))+','
                                                  +IntToStr(Ceil(ALastRowRectList[J].Top))+','
                                                  +IntToStr(Ceil(ALastRowRectList[J].Right))+','
                                                  +IntToStr(Ceil(ALastRowRectList[J].Bottom))
                                                  +')';
                      end;
                      uBaseLog.OutputDebugString(ALastRowRectListStr);

//                      ANeedCompareItemWidth:=AItemWidth;
//                      case Self.FItemSpaceType of
//                        sistDefault:
//                        begin
//                          ANeedCompareItemWidth:=AItemWidth+FItemSpace;
//                        end;
//                        sistMiddle:
//                        begin
//                          ANeedCompareItemWidth:=AItemWidth;
////                          if (AColIndex>0) and () then
////                          begin
////                            ANeedCompareItemWidth:=ANeedCompareItemWidth+FItemSpace;
////                          end;
//
//                        end;
//                      end;


                      ALastMinBottomRectIndex:=-1;
                      //判断是否能塞得下
                      while SmallerDouble(ASumRowSpace,AItemWidth) do//ANeedCompareItemWidth) do
                      begin


                          //找出最低的Bottom
                          for J := 0 to ALastRowRectList.Count-1 do
                          begin
                            if BiggerDouble(ATempLastRowRectList[AMinBottomRectIndex].Bottom,ATempLastRowRectList[J].Bottom) then
                            begin
                               AMinBottomRectIndex:=J;
                            end;
                          end;


                          //计算最低的Bottom有多少空间
                          for J := AMinBottomRectIndex to ALastRowRectList.Count-1 do
                          begin
                            if IsSameDouble(ATempLastRowRectList[AMinBottomRectIndex].Bottom,ATempLastRowRectList[J].Bottom) then
                            begin
                              //增加可容纳的宽度
                              ASumRowSpace:=ASumRowSpace+ATempLastRowRectList[J].Width;
                              ALastAddSumRowSpaceIndex:=J;
                            end
                            else
                            begin
                              Break;
                            end;
                          end;



                          //判断空间是否放得下
                          if BiggerEqualDouble(ASumRowSpace,AItemWidth) then//ANeedCompareItemWidth) then
                          begin
                            Break;
                          end;



                          //放不下
                          //填平它,并且继续适配
                          if (AMinBottomRectIndex=0) then
                          begin
                              if (ALastAddSumRowSpaceIndex=ALastRowRectList.Count-1)  then
                              begin
                                //从第一个加上了最后一个了
                                Break;
                              end
                              else
                              begin
                                //第一个,填成右边一样高
                                ATempLastRowRectList[AMinBottomRectIndex].Bottom:=ATempLastRowRectList[AMinBottomRectIndex+1].Bottom;
                              end;
                          end
                          else if (AMinBottomRectIndex=ALastRowRectList.Count-1) then
                          begin
                              //最后一个,填成左边一样高
                              ATempLastRowRectList[AMinBottomRectIndex].Bottom:=ATempLastRowRectList[AMinBottomRectIndex-1].Bottom;
                          end
                          else if (ALastAddSumRowSpaceIndex=ALastRowRectList.Count-1) then
                          begin
                              //加上最后一个还是不够高,填成左边一样高
                              ATempLastRowRectList[AMinBottomRectIndex].Bottom:=ATempLastRowRectList[AMinBottomRectIndex-1].Bottom;
                          end
                          else
                          begin
                            if BiggerDouble(ATempLastRowRectList[AMinBottomRectIndex+1].Bottom,ATempLastRowRectList[AMinBottomRectIndex-1].Bottom) then
                            begin
                              //右边比左边高,填成左边的
                              ATempLastRowRectList[AMinBottomRectIndex].Bottom:=ATempLastRowRectList[AMinBottomRectIndex-1].Bottom;
                            end
                            else
                            begin
//                              if ATempLastRowRectList[AMinBottomRectIndex].Bottom<>ATempLastRowRectList[AMinBottomRectIndex+1].Bottom then
//                              begin
                                ATempLastRowRectList[AMinBottomRectIndex].Bottom:=ATempLastRowRectList[AMinBottomRectIndex+1].Bottom;
//                              end
//                              else
//                              begin
//                                uBaseLog.OutputDebugString('合并 宽度竟然小于0');
//                                Break;
//                              end;
                            end;
                          end;

                          if (ALastMinBottomRectIndex<>-1) and (ALastMinBottomRectIndex=AMinBottomRectIndex) then
                          begin
                            //要死循环
                            uBaseLog.OutputDebugString('要死循环');
                            Break;
                          end;



                          ALastMinBottomRectIndex:=AMinBottomRectIndex;


                          //重新计算
                          AMinBottomRectIndex:=0;
                          ASumRowSpace:=0;
                          ALastAddSumRowSpaceIndex:=0;



                      end;
//                      uBaseLog.OutputDebugString('MinBottomRectIndex:'+IntToStr(AMinBottomRectIndex)+' ASumRowSpace:'+FloatToStr(ASumRowSpace));




                      //放得下
                      AItemRect.Top:=ATempLastRowRectList[AMinBottomRectIndex].Bottom;
                      AItemRect.Left:=ATempLastRowRectList[AMinBottomRectIndex].Left;
                      case Self.FItemSpaceType of
                        sistDefault:
                        begin
                          //加上间隔
                          AItemRect.Top:=AItemRect.Top+FItemSpace;
                          AItemRect.Left:=AItemRect.Left+FItemSpace;
                        end;
                        sistMiddle:
                        begin
                          //没有分隔
                          if BiggerDouble(AItemRect.Top,0) then
                          begin
                            AItemRect.Top:=AItemRect.Top+FItemSpace;
                          end;
                        end;
                      end;
                      AItemRect.Right:=AItemRect.Left+CalcItemWidth(ASkinItem);
                      AItemRect.Bottom:=AItemRect.Top+CalcItemHeight(ASkinItem);

                      //设置列表项绘制矩形
                      ASkinItem.SetItemRect(AItemRect);


                      if FCalcItemsMaxRight<AItemRect.Right then
                      begin
                        FCalcItemsMaxRight:=AItemRect.Right;
                      end;
                      if FCalcItemsMaxBottom<AItemRect.Bottom then
                      begin
                        FCalcItemsMaxBottom:=AItemRect.Bottom;
                      end;




                      
                      //找出最低的这个,判断是否放得下
                      ALeftItemWidth:=AItemWidth;//ANeedCompareItemWidth;
                      AIsNeedInsertNewRect:=False;
                      //更新ALastRowRectList的Bottom
                      for J := AMinBottomRectIndex to ALastRowRectList.Count-1 do
                      begin

                          if BiggerDouble(ALastRowRectList.Items[J].Width,ALeftItemWidth) then
                          begin
                          
                              //宽度多余,那么拆分成两个
                              AIsNeedInsertNewRect:=True;



                              ANewItemRect:=ALastRowRectList.Items[J];
                              //分离出来的新Rect要加上间隔
                              ANewItemRect.Left:=ANewItemRect.Left+ALeftItemWidth+FItemSpace;

                              if SmallerEqualDouble(ANewItemRect.Right,ANewItemRect.Left) then
                              begin
                                uBaseLog.OutputDebugString('合并 宽度竟然小于0');
                                AIsNeedInsertNewRect:=False;
                              end;

                              //加上间隔
                              ALastRowRectList.PItems[J].Width:=ALeftItemWidth+FItemSpace;
                              ALastRowRectList.PItems[J].Bottom:=AItemRect.Bottom;




                              Break;
                          end
                          else
                          begin
                              ALastRowRectList.PItems[J].Bottom:=AItemRect.Bottom;

                              ALeftItemWidth:=ALeftItemWidth-ALastRowRectList.Items[J].Width;
                          end;

                        
                          //宽度刚好够了
                          if SmallerEqualDouble(ALeftItemWidth,0) then
                          begin
                            Break;
                          end;
                                              
                      end;


                      if AIsNeedInsertNewRect then
                      begin
                        ALastRowRectList.Insert(J+1,ANewItemRect);
                      end;
                      
                      

              end;

              ALastRowRectList.Free;

    end;
    iltHorizontal:
    begin

    end;
  end;


end;

function TSkinListViewLayoutsManager.CalcItemCountPerLine: Integer;
begin

  Result:=FItemCountPerLine;

  //小于零,
  //表示自动计算,
  //控件宽度除以ItemWidth
  if (FItemCountPerLine<=0) then
  begin

          case Self.FItemLayoutType of
            iltVertical:
            begin
                //垂直列表
                if Self.FItemWidth>0 then
                begin
                    //水平,宽度
                    Result:=Floor(Self.GetControlWidth / FItemWidth);

                    //去掉空隙,重新计算
                    if BiggerDouble(FItemSpace,0) and (Result>=1) then
                    begin

                        case Self.FItemSpaceType of
                          sistDefault:
                          begin
                            if Self.FIsStrictItemCountPerLine then
                            begin
                              Result:=Floor((Self.GetControlWidth-(Result+1)*FItemSpace) / FItemWidth);
                            end
                            else
                            begin
                              Result:=Ceil((Self.GetControlWidth-(Result+1)*FItemSpace) / FItemWidth);
                            end;
                          end;
                          sistMiddle:
                          begin
                            if Self.FIsStrictItemCountPerLine then
                            begin
                              Result:=Floor((Self.GetControlWidth-(Result+1-2)*FItemSpace) / FItemWidth);
                            end
                            else
                            begin
                              Result:=Ceil((Self.GetControlWidth-(Result+1-2)*FItemSpace) / FItemWidth);
                            end;
                          end;
                        end;


                    end;
                end;

            end;
            iltHorizontal:
            begin
                //水平列表
                if Self.FItemHeight>0 then
                begin
                    //垂直,高度
                    Result:=Floor(Self.GetControlHeight / FItemHeight);

                    //去掉空隙,重新计算
                    if BiggerDouble(FItemSpace,0) and (Result>=1) then
                    begin
                      case FItemSpaceType of
                        sistDefault:
                        begin
                            if Self.FIsStrictItemCountPerLine then
                            begin
                              Result:=Floor((Self.GetControlHeight-(Result+1)*FItemSpace) / FItemHeight);
                            end
                            else
                            begin
                              Result:=Ceil((Self.GetControlHeight-(Result+1)*FItemSpace) / FItemHeight);
                            end;
                        end;
                        sistMiddle:
                        begin
                            if Self.FIsStrictItemCountPerLine then
                            begin
                              Result:=Floor((Self.GetControlHeight-(Result+1-2)*FItemSpace) / FItemHeight);
                            end
                            else
                            begin
                              Result:=Ceil((Self.GetControlHeight-(Result+1-2)*FItemSpace) / FItemHeight);
                            end;
                        end;
                      end;
                    end;
                end;

            end;
          end;


  end;

  if Result<1 then Result:=1;
end;

function TSkinListViewLayoutsManager.CalcItemWidth(AItem: ISkinItem): Double;
begin
  if (Self.FItemSizeCalcType=isctSeparate) and IsSameDouble(AItem.Width,Const_Tag_UseListViewItemIsControlWidth) then
  begin
      //占用一整行
      Result:=GetControlWidth;

      //图标模式和瀑布模式有间隔
      if Self.FViewType<>lvtList then
      begin
        case Self.FItemSpaceType of
          sistDefault: Result:=Result-2*FItemSpace;
          sistMiddle: ;
        end;
      end;

  end
  else
  begin
    Result:=(inherited CalcItemWidth(AItem));
  end;
end;

function TSkinListViewLayoutsManager.GetItemDefaultWidth: Double;
begin
  if (Self.FViewType=TListViewType.lvtList) then
  begin

      //如果是列表状态
      Result:=(inherited GetItemDefaultWidth);

  end
  else
  begin
      case Self.FItemLayoutType of
        iltVertical:
        begin
              //不填充控件宽度,那么使用默认宽度
              if (not FIsItemCountFitControl) then
              begin

                  //如果是列表状态,或是不适配控件的宽度,那么使用默认宽度
                  Result:=(inherited GetItemDefaultWidth);

              end
              else
              begin
                  //填充控件宽度
                  //如果处在适配情况下,那么计算出适配的宽度
                  //控件宽度/每行个数
                  case Self.FItemSpaceType of
                    sistDefault:
                    begin
                      //首末有间隔
                      Result:=
                              (Self.GetControlWidth
                                -(CalcItemCountPerLine+1)*FItemSpace
                              )
                              / Self.CalcItemCountPerLine

                              ;
                    end;
                    sistMiddle:
                    begin
                      //首末无间隔
                      Result:=
                              (Self.GetControlWidth
                                -(CalcItemCountPerLine+1-2)*FItemSpace
                                )
                              / Self.CalcItemCountPerLine

                              ;
                    end;
                  end;

              end;
        end;
        iltHorizontal:
        begin
            //水平列表,则宽度使用默认
            Result:=(inherited GetItemDefaultWidth);
        end;
      end;
  end;
end;

function TSkinListViewLayoutsManager.GetItemDefaultHeight: Double;
begin
  if (Self.FViewType=TListViewType.lvtList) then
  begin

      //如果是列表状态
      Result:=(inherited GetItemDefaultHeight);

  end
  else
  begin
      case Self.FItemLayoutType of
        iltVertical:
        begin
            //垂直列表情况下,高度使用默认
            Result:=(inherited GetItemDefaultHeight);
        end;
        iltHorizontal:
        begin
          //水平列表情况下
          if (not FIsItemCountFitControl) then
          begin
              //如果不适配控件的高度,那么高度使用默认
              Result:=(inherited GetItemDefaultHeight);
          end
          else
          begin
                //如果适配控件的高度,那么高度除以适配数
                //每行个数
                case FItemSpaceType of
                  sistDefault:
                  begin
                    //首末有间隔
                    Result:=
                            (Self.GetControlHeight-
                              (CalcItemCountPerLine+1)*FItemSpace
                            )
                            / Self.CalcItemCountPerLine

                            ;
                  end;
                  sistMiddle:
                  begin
                    //首末无间隔
                    Result:=
                            (Self.GetControlHeight-
                                (CalcItemCountPerLine+1-2)*FItemSpace
                                )
                            / Self.CalcItemCountPerLine

                            ;
                  end;
                end;

          end;
        end;
      end;
  end;
end;

procedure TSkinListViewLayoutsManager.SetIsItemCountFitControl(const Value: Boolean);
begin
  if FIsItemCountFitControl<>Value then
  begin
    FIsItemCountFitControl := Value;
    Self.DoItemSizeChange(Self);
  end;
end;

procedure TSkinListViewLayoutsManager.SetItemCountPerLine(const Value: Integer);
begin
  if FItemCountPerLine<>Value then
  begin
    FItemCountPerLine := Value;
    Self.DoItemSizeChange(Self);
  end;
end;

procedure TSkinListViewLayoutsManager.SetViewType(const Value: TListViewType);
begin
  if FViewType<>Value then
  begin
    FViewType := Value;
    Self.DoItemSizeChange(Self);


    {$IFDEF FREE_VERSION}
    if FViewType=lvtWaterfall then
    begin
      ShowMessage('OrangeUI免费版限制(不支持瀑布流模式)');
    end;
    {$ENDIF}

  end;
end;



{ TRectFList }

procedure TRectFList.Add(ARectF:TRectF);
var
  P:PRectF;
begin
  New(P);
  P^:=ARectF;
  FItems.Add(P);
end;

procedure TRectFList.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count-1 do
  begin
    Dispose(FItems[I]);
  end;
  FItems.Clear;
end;

function TRectFList.Count: Integer;
begin
  Result:=FItems.Count;
end;

constructor TRectFList.Create;
begin
  FItems:=TList.Create;
end;

procedure TRectFList.Delete(Index: Integer);
begin
  Dispose(FItems[Index]);
  Self.FItems.Delete(Index);
end;

destructor TRectFList.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  inherited;
end;

function TRectFList.GetItem(Index: Integer): TRectF;
begin
  Result:=PRectF(FItems[Index])^;
end;

function TRectFList.GetItemP(Index: Integer): PRectF;
begin
  Result:=PRectF(FItems[Index]);
end;

procedure TRectFList.Insert(AIndex: Integer; ARectF: TRectF);
var
  P:PRectF;
begin
  New(P);
  P^:=ARectF;
  FItems.Insert(AIndex,P);
end;

procedure TRectFList.SetItem(Index: Integer; const Value: TRectF);
begin
  PRectF(FItems[Index])^:=Value;
end;



{ TSkinListView }

function TSkinListView.Material:TSkinListViewDefaultMaterial;
begin
  Result:=TSkinListViewDefaultMaterial(SelfOwnMaterial);
end;


function TSkinListView.SelfOwnMaterialToDefault:TSkinListViewDefaultMaterial;
begin
  Result:=TSkinListViewDefaultMaterial(SelfOwnMaterial);
end;

function TSkinListView.CurrentUseMaterialToDefault:TSkinListViewDefaultMaterial;
begin
  Result:=TSkinListViewDefaultMaterial(CurrentUseMaterial);
end;

function TSkinListView.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TListViewProperties;
end;

function TSkinListView.GetListViewProperties: TListViewProperties;
begin
  Result:=TListViewProperties(Self.FProperties);
end;

procedure TSkinListView.SetListViewProperties(Value: TListViewProperties);
begin
  Self.FProperties.Assign(Value);
end;





{ TControlLayoutItem }


procedure TControlLayoutItem.SetItemDrawRect(Value: TRectF);
begin
  FItemDrawRect:=Value;
end;

procedure TControlLayoutItem.SetItemRect(Value: TRectF);
begin
  FItemRect:=Value;
end;

procedure TControlLayoutItem.SetSkinListIntf(ASkinListIntf: ISkinList);
begin
  FSkinListIntf:=ASkinListIntf;
end;

procedure TControlLayoutItem.ClearItemRect;
begin
  FItemRect:=RectF(0,0,0,0);
  FItemDrawRect:=RectF(0,0,0,0);
end;

constructor TControlLayoutItem.Create;//(AOwner: TControlLayoutItems);
begin
//  SetSkinListIntf(AOwner);
  FHeight:=-1;
  FWidth:=-1;

end;

function TControlLayoutItem.GetHeight: Double;
begin
//  Result:=Height;//ControlMap.Setting.height;
//  if Self.Setting.height=0 then
//  begin
//    Result:=40;
//    Exit;
//  end
//  else
//  begin
//  if FIsUseSelfHeight then
//  begin

//    if Self.InputPanel=nil then
//    begin
//      //因为ItemHeight在绘制的时候，会乘以屏幕缩放比例，所以设置的时候要除一下
//      Result:=Ceil(TControl(Self.Component).Height/GetScreenScaleRate);
//    end
//    else
//    begin
//      Result:=Ceil(TControl(Self.InputPanel).Height/GetScreenScaleRate);
//    end;
    Result:=Self.FHeight;///GetScreenScaleRate;
//  end
//  else
//  begin
//    //这个高度是固定的
//    Result:=Self.Setting.height;
//  end;

//  end;
end;

function TControlLayoutItem.GetIsRowEnd: Boolean;
begin
  Result:=False;//FIsRowEnd;
//  Result:=FIsRowEnd;
end;

function TControlLayoutItem.GetItemDrawRect: TRectF;
begin
  Result:=FItemDrawRect;
end;

function TControlLayoutItem.GetItemRect: TRectF;
begin
  Result:=FItemRect;
end;

function TControlLayoutItem.GetLevel: Integer;
begin
  Result:=0;
end;

function TControlLayoutItem.GetObject: TObject;
begin
  Result:=Self;
end;

function TControlLayoutItem.GetSelected: Boolean;
begin
  Result:=False;
end;

function TControlLayoutItem.GetThisRowItemCount: Integer;
begin
  Result:=FThisRowItemCount;
end;

function TControlLayoutItem.GetVisible: Boolean;
begin
//  if Self.FIsUseSelfWidth and (FWidth=0) then
//  begin
//    Result:=False;
//    Exit;
//  end;

//  if Self.Component=nil then
//  begin
//    Result:=(Self.Setting.visible=1);
//  end
//  else

  if Self.Component is TControl then
  begin
    Result:=//(Self.Setting.visible=1) and
            TControl(Component).Visible;
  end;
end;

function TControlLayoutItem.GetWidth: Double;
begin
//  if BiggerDouble( then

//  if FIsUseSelfWidth then
//  begin

//    if Self.InputPanel=nil then
//    begin
//      //因为ItemHeight在绘制的时候，会乘以屏幕缩放比例，所以设置的时候要除一下
//      Result:=Ceil(TControl(Self.Component).Height/GetScreenScaleRate);
//    end
//    else
//    begin
//      Result:=Ceil(TControl(Self.InputPanel).Height/GetScreenScaleRate);
//    end;
    Result:=Self.FWidth;///GetScreenScaleRate;
//  end
//  else
//  begin
//    //这个高度是固定的
//    Result:=Self.Setting.width;
//  end;
end;


function TControlLayoutItem.PtInItem(APoint: TPointF): Boolean;
begin
  Result:=PtInRect(Self.FItemDrawRect,APoint);

end;

{ TControlLayoutItems }


function TControlLayoutItems.Add(AControl: TControl; AItemWidth,
  AItemHeight: Double): TControlLayoutItem;
begin
  Result:=TControlLayoutItem.Create;//(nil);
  Result.Component:=AControl;
  Result.FWidth:=AItemWidth;
  Result.FHeight:=AItemHeight;

  Self.Add(Result);
end;

procedure TControlLayoutItems.AlignControls;
var
  I: Integer;
  ASkinItem:ISkinItem;
  AControlLayoutItem:TControlLayoutItem;
  AItemRect:TRectF;
begin

      //for I := 0 to Self.FListLayoutsManager.GetVisibleItemsCount-1 do
      for I := 0 to Self.FListLayoutsManager.SkinListIntf.Count-1 do
      begin
//        ASkinItem:=Self.FListLayoutsManager.GetVisibleItem(I);
        ASkinItem:=Self.FListLayoutsManager.SkinListIntf.GetSkinItem(I);
        AControlLayoutItem:=TControlLayoutItem(ASkinItem.GetObject);
        if ASkinItem.Visible and (AControlLayoutItem.Component is TControl) then
        begin
//            AControlLayoutItem.SetVisible(True);

            AItemRect:=ASkinItem.ItemRect;
//            AItemRect.Left:=AItemRect.Left;//+ScreenScaleSizeInt(LayoutSetting.margins_left);//+AParentMarginsLeft;
//            AItemRect.Right:=AItemRect.Right;//+ScreenScaleSizeInt(LayoutSetting.margins_left);//+AParentMarginsLeft;
//            AItemRect.Top:=AItemRect.Top;//+ScreenScaleSizeInt(LayoutSetting.margins_top);//+AParentMarginsTop;
//            AItemRect.Bottom:=AItemRect.Bottom;//+ScreenScaleSizeInt(LayoutSetting.margins_top);//+AParentMarginsTop;



            //设置控件的位置和尺寸
            //AControlLayoutItem.AlignControl(AItemRect,LayoutSetting);

            TControl(AControlLayoutItem.Component).SetBounds(
                ControlSize(AItemRect.Left),
                ControlSize(AItemRect.Top),
                ControlSize(AItemRect.Width),
                ControlSize(AItemRect.Height)
                );

        end
        else
        begin
//            AControlLayoutItem.SetVisible(False);
        end;
      end;


end;

constructor TControlLayoutItems.Create(
  const AObjectOwnership: TObjectOwnership;
  const AIsCreateObjectChangeManager: Boolean);
begin
  inherited Create(AObjectOwnership,AIsCreateObjectChangeManager);

  //布局管理
  FListLayoutsManager:=TSkinListViewLayoutsManager.Create(Self);
  FListLayoutsManager.ItemSizeCalcType:=isctSeparate;//isctFixed;
  TSkinListViewLayoutsManager(FListLayoutsManager).ViewType:=TListViewType.lvtIcon;

end;


destructor TControlLayoutItems.Destroy;
begin
  FreeAndNil(FListLayoutsManager);

  inherited;
end;

procedure TControlLayoutItems.DoChange;
begin
  inherited;

  if //Not IsLoading
    //and
    (FSkinObjectChangeManager<>nil)
    and not FSkinObjectChangeManager.IsDestroy then
  begin
    if (ictAdd in Self.FLastItemChangeTypes)
      or (ictDel in Self.FLastItemChangeTypes) then
    begin
      if GetListLayoutsManager<>nil then
      begin
        Self.GetListLayoutsManager.DoItemVisibleChange(nil);
      end;
    end;
  end;

end;

procedure TControlLayoutItems.EndUpdate(AIsForce: Boolean);
begin

  inherited EndUpdate(AIsForce);

  //判断列表项是否改变过大小再调用
  //万一有Item的Visible更改过了,也需要调用的
  if GetListLayoutsManager<>nil then
  begin
    Self.GetListLayoutsManager.DoItemVisibleChange(nil,True);
    Self.GetListLayoutsManager.DoItemPropChange(nil);
  end;

end;

function TControlLayoutItems.GetListLayoutsManager: TSkinListLayoutsManager;
begin
  Result:=FListLayoutsManager;
end;

function TControlLayoutItems.GetObject: TObject;
begin
  Result:=Self;
end;

function TControlLayoutItems.GetSkinItem(const Index: Integer): ISkinItem;
begin
  Result:=Items[Index] as ISkinItem;
end;

function TControlLayoutItems.GetSkinObject(const Index: Integer): TObject;
begin
  Result:=Items[Index];
end;

function TControlLayoutItems.GetUpdateCount: Integer;
begin
  Result:=0;
  if (Self.FSkinObjectChangeManager<>nil) then
  begin
    Result:=Self.FSkinObjectChangeManager.UpdateCount;
  end;
end;

procedure TControlLayoutItems.SetListLayoutsManager(ALayoutsManager: TSkinListLayoutsManager);
begin
  FListLayoutsManager:=TSkinListViewLayoutsManager(ALayoutsManager);
end;


function TControlLayoutItems.GetItem(Index: Integer): TControlLayoutItem;
begin
  Result:=TControlLayoutItem(Inherited Items[Index]);
end;



end.


