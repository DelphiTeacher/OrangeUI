//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     树型视图
///   </para>
///   <para>
///     Tree View
///   </para>
/// </summary>
unit uSkinTreeViewType;

interface
{$I FrameWork.inc}

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
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  {$ENDIF}
  uSkinItems,
  uSkinListLayouts,
  uDrawParam,
  uGraphicCommon,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uBinaryTreeDoc,
  uDrawPicture,
  uSkinMaterial,
  uDrawTextParam,
  uDrawRectParam,
  uSkinImageList,
  uSkinVirtualListType,
  uSkinCustomListType,
  uSkinItemDesignerPanelType,

  {$IFDEF VCL}
//  uSkinWindowsItemDesignerPanel,
  {$ENDIF}
  {$IFDEF FMX}
  uSkinFireMonkeyItemDesignerPanel,
  {$ENDIF}

  uSkinScrollControlType,
  uDrawPictureParam;



const
  IID_ISkinTreeView:TGUID='{BBF52037-4955-40D6-AF2A-1626E1F7502E}';


type
  TTreeViewProperties=class;
  TSkinTreeViewItems=TRealSkinTreeViewItems;
  TSkinTreeViewItem=TRealSkinTreeViewItem;
//  TSkinTreeViewLayoutsManager=class;




//  TTreeViewEditingItemEvent=procedure(Sender:TObject;AItem:TSkinTreeViewItem;ABindingControl:TChildControl;AEditControl:TChildControl) of object;
//  TTreeViewClickItemExEvent=procedure(Sender:TObject;AItem:TSkinTreeViewItem;X:Double;Y:Double) of object;
//  TTreeViewClickItemEvent=procedure(Sender:TObject;AItem:TSkinTreeViewItem) of object;
//  TTreeViewDoItemEvent=procedure(Sender:TObject;AItem:TSkinTreeViewItem) of object;
//  TTreeViewDrawItemEvent=procedure(Sender:TObject;ACanvas:TObject;AItemDesignerPanel:TObject;AItem:TSkinTreeViewItem;AItemDrawRect:TRect) of object;



  //选中列表项的事件
  TItemExpandedChangeEvent=procedure(Sender:TObject;
                                    AItem:TSkinTreeViewItem) of object;



  /// <summary>
  ///   <para>
  ///     树型视图接口
  ///   </para>
  ///   <para>
  ///     Interface of TreeView
  ///   </para>
  /// </summary>
  ISkinTreeView=interface//(ISkinScrollControl)
  ['{BBF52037-4955-40D6-AF2A-1626E1F7502E}']

    function GetOnItemExpandedChange:TItemExpandedChangeEvent;
    property OnItemExpandedChange:TItemExpandedChangeEvent read GetOnItemExpandedChange;

    function GetTreeViewProperties:TTreeViewProperties;
    property Properties:TTreeViewProperties read GetTreeViewProperties;
    property Prop:TTreeViewProperties read GetTreeViewProperties;
  end;








  /// <summary>
  ///   <para>
  ///     树型视图属性
  ///   </para>
  ///   <para>
  ///     TreeView properties
  ///   </para>
  /// </summary>
  TTreeViewProperties=class(TVirtualListProperties)
  protected
    //自动展开
    FIsAutoExpanded:Boolean;
    //父节点不选中
    FParentItemNoSelect:Boolean;



//    //父节点设计面板
//    FParentItemDesignerPanel: TSkinItemDesignerPanel;
//    FInnerParentItemDesignerPanel: TSkinItemDesignerPanel;



    FSkinTreeViewIntf:ISkinTreeView;


    function GetParentTypeItemStyle: String;
    procedure SetParentTypeItemStyle(const Value: String);
    function GetParentItemDesignerPanel: TSkinItemDesignerPanel;
    procedure SetParentItemDesignerPanel(const Value: TSkinItemDesignerPanel);
  protected
    function GetMouseDownItem: TBaseSkinTreeViewItem;
    function GetMouseOverItem: TBaseSkinTreeViewItem;
    function GetSelectedItem: TBaseSkinTreeViewItem;
    function GetPanDragItem: TBaseSkinTreeViewItem;

    procedure SetMouseDownItem(Value: TBaseSkinTreeViewItem);
    procedure SetMouseOverItem(Value: TBaseSkinTreeViewItem);
    procedure SetSelectedItem(Value: TBaseSkinTreeViewItem);
    procedure SetPanDragItem(Value: TBaseSkinTreeViewItem);
  protected


    function GetLevelLeftOffset: TControlSize;
    function GetLevelRightIsFitControlWidth: Boolean;
    procedure SetLevelRightIsFitControlWidth(const Value: Boolean);
    function GetParentItemHeight: TControlSize;
    procedure SetLevelLeftOffset(const Value: TControlSize);
    procedure SetParentItemHeight(const Value: TControlSize);

  protected
    procedure DoClickItem(AItem:TBaseSkinItem;X:Double;Y:Double);override;
    procedure DoSetSelectedItem(Value: TBaseSkinItem);override;
//    procedure BindItemDesignerPanelAndItem(AItemDesignerPanel:TSkinItemDesignerPanel;AItem:TSkinItem;AIsDrawItemInteractiveState:Boolean);override;

    //决定列表项所绘制的设计面板
    function DecideItemDesignerPanel(AItem:TSkinItem):TSkinItemDesignerPanel;override;
  private
    function GetParentTypeItemStyleConfig: TStringList;
    procedure SetParentTypeItemStyleConfig(const Value: TStringList);
  protected
    function GetVirtualListLayoutsManager:TSkinTreeViewLayoutsManager;

    function GetItems: TSkinTreeViewItems;
    procedure SetItems(const Value: TSkinTreeViewItems);

    function GetItemsClass:TBaseSkinItemsClass;override;
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;override;
    procedure DoListLayoutsManagerItemExpandedChange(Sender:TObject);virtual;

    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    FParentItemStyleSetting:TListItemTypeStyleSetting;
    property ListLayoutsManager:TSkinTreeViewLayoutsManager read GetVirtualListLayoutsManager;



    /// <summary>
    ///   <para>
    ///     获取当前交互的项
    ///   </para>
    ///   <para>
    ///     Get interactive Item
    ///   </para>
    /// </summary>
    function GetInteractiveItem:TBaseSkinTreeViewItem;
    property InteractiveItem:TBaseSkinTreeViewItem read GetInteractiveItem;



    /// <summary>
    ///   <para>
    ///     选中的节点
    ///   </para>
    ///   <para>
    ///     Selected Item
    ///   </para>
    /// </summary>
    property SelectedItem:TBaseSkinTreeViewItem read GetSelectedItem write SetSelectedItem;

    /// <summary>
    ///   <para>
    ///     按下的节点
    ///   </para>
    ///   <para>
    ///     Pressed Item
    ///   </para>
    /// </summary>
    property MouseDownItem:TBaseSkinTreeViewItem read GetMouseDownItem write SetMouseDownItem;

    /// <summary>
    ///   <para>
    ///     停靠的节点
    ///   </para>
    ///   <para>
    ///     Hovering Item
    ///   </para>
    /// </summary>
    property MouseOverItem:TBaseSkinTreeViewItem read GetMouseOverItem write SetMouseOverItem;


    /// <summary>
    ///   <para>
    ///     平拖的节点
    ///   </para>
    ///   <para>
    ///     PanDragged Item
    ///   </para>
    /// </summary>
    property PanDragItem:TBaseSkinTreeViewItem read GetPanDragItem write SetPanDragItem;
  published
    /// <summary>
    ///   <para>
    ///     父节点不选中
    ///   </para>
    ///   <para>
    ///     Don't select Parent Item
    ///   </para>
    /// </summary>
    property ParentItemNoSelect:Boolean read FParentItemNoSelect write FParentItemNoSelect;


    //节点列表
    property Items:TSkinTreeViewItems read GetItems write SetItems;




    /// <summary>
    ///   <para>
    ///     层级之间的左偏移
    ///   </para>
    ///   <para>
    ///     Left offset between levels
    ///   </para>
    /// </summary>
    property LevelLeftOffset:TControlSize read GetLevelLeftOffset write SetLevelLeftOffset;

    /// <summary>
    ///   <para>
    ///     层级之间是否右对齐
    ///   </para>
    ///   <para>
    ///     Whether right align between levels
    ///   </para>
    /// </summary>
    property LevelRightIsFitControlWidth:Boolean read GetLevelRightIsFitControlWidth write SetLevelRightIsFitControlWidth;

    /// <summary>
    ///   <para>
    ///     父节点的高度
    ///   </para>
    ///   <para>
    ///     Height of ParentItem
    ///   </para>
    /// </summary>
    property ParentItemHeight:TControlSize read GetParentItemHeight write SetParentItemHeight;


    /// <summary>
    ///   <para>
    ///     鼠标点击的时候是否自动展开节点
    ///   </para>
    ///   <para>
    ///     Wheteher expand automaticly when mouse clicking
    ///   </para>
    /// </summary>
    property IsAutoExpanded:Boolean read FIsAutoExpanded write FIsAutoExpanded;



    /// <summary>
    ///   <para>
    ///     父节点设计面板
    ///   </para>
    ///   <para>
    ///     ParentItem design panel
    ///   </para>
    /// </summary>
    property ParentItemDesignerPanel: TSkinItemDesignerPanel read GetParentItemDesignerPanel write SetParentItemDesignerPanel;
    property ParentTypeItemStyle: String read GetParentTypeItemStyle write SetParentTypeItemStyle;
    property ParentTypeItemStyleConfig:TStringList read GetParentTypeItemStyleConfig write SetParentTypeItemStyleConfig;
  end;












  /// <summary>
  ///   <para>
  ///     树型视图素材基类
  ///   </para>
  ///   <para>
  ///     Base class of TreeView material
  ///   </para>
  /// </summary>
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTreeViewDefaultMaterial=class(TSkinVirtualListDefaultMaterial)
  private
    //父节点节点绘制素材
    FParentItemMaterial:TSkinListItemMaterial;

    procedure SetParentItemMaterial(const Value: TSkinListItemMaterial);
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

    /// <summary>
    ///   <para>
    ///     父节点绘制素材
    ///   </para>
    ///   <para>
    ///     Draw material of ParentItem
    ///   </para>
    /// </summary>
    property ParentItemMaterial:TSkinListItemMaterial read FParentItemMaterial write SetParentItemMaterial;
  end;

  TSkinTreeViewDefaultType=class(TSkinVirtualListDefaultType)
  protected
    FSkinTreeViewIntf:ISkinTreeView;
  protected
    function DecideItemMaterial(AItem:TBaseSkinItem;ASkinMaterial:TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    procedure MarkAllListItemTypeStyleSettingCacheUnUsed(
                        //起始下标
                        ADrawStartIndex:Integer;
                        ADrawEndIndex:Integer);override;
  protected
    function GetSkinMaterial:TSkinTreeViewDefaultMaterial;
  end;






  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTreeView=class(TSkinVirtualList,ISkinTreeView,ISkinItems)
  private
    FOnItemExpandedChange: TItemExpandedChangeEvent;


    function GetTreeViewProperties:TTreeViewProperties;
    procedure SetTreeViewProperties(Value:TTreeViewProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;

    function GetOnItemExpandedChange:TItemExpandedChangeEvent;


  public
    function SelfOwnMaterialToDefault:TSkinTreeViewDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinTreeViewDefaultMaterial;
    function Material:TSkinTreeViewDefaultMaterial;
  public
    property Prop:TTreeViewProperties read GetTreeViewProperties write SetTreeViewProperties;
  published

    property OnItemExpandedChange:TItemExpandedChangeEvent read FOnItemExpandedChange write FOnItemExpandedChange;


    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TTreeViewProperties read GetTreeViewProperties write SetTreeViewProperties;

    //垂直滚动条
    property VertScrollBar;

    //水平滚动条
    property HorzScrollBar;



  end;




  {$IFDEF VCL}
  TSkinWinTreeView=class(TSkinTreeView)
  end;
  {$ENDIF VCL}





implementation




{ TTreeViewProperties }


function TTreeViewProperties.GetInteractiveItem: TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited InteractiveItem);
end;

function TTreeViewProperties.GetVirtualListLayoutsManager:TSkinTreeViewLayoutsManager;
begin
  Result:=TSkinTreeViewLayoutsManager(Self.FListLayoutsManager);
end;

function TTreeViewProperties.GetItems: TSkinTreeViewItems;
begin
  Result:=TSkinTreeViewItems(FItems);
end;

function TTreeViewProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TSkinTreeViewItems;
end;

function TTreeViewProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinTreeViewLayoutsManager;
end;

function TTreeViewProperties.GetLevelLeftOffset: TControlSize;
begin
  Result:=Self.ListLayoutsManager.LevelLeftOffset;
end;

function TTreeViewProperties.GetLevelRightIsFitControlWidth: Boolean;
begin
  Result:=Self.ListLayoutsManager.LevelRightIsFitControlWidth;
end;

function TTreeViewProperties.GetMouseDownItem: TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited MouseDownItem);
end;

function TTreeViewProperties.GetMouseOverItem: TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited MouseOverItem);
end;

function TTreeViewProperties.GetSelectedItem: TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited SelectedItem);
end;

function TTreeViewProperties.GetPanDragItem: TBaseSkinTreeViewItem;
begin
  Result:=TBaseSkinTreeViewItem(Inherited PanDragItem);
end;

function TTreeViewProperties.GetParentItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=FParentItemStyleSetting.ItemDesignerPanel;
end;

function TTreeViewProperties.GetParentItemHeight: TControlSize;
begin
  Result:=Self.ListLayoutsManager.ParentItemHeight;
end;

function TTreeViewProperties.GetParentTypeItemStyle: String;
begin
  Result:=FParentItemStyleSetting.Style;
end;

function TTreeViewProperties.GetParentTypeItemStyleConfig: TStringList;
begin
  Result:=FParentItemStyleSetting.Config;
end;

//procedure TTreeViewProperties.BindItemDesignerPanelAndItem(AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;AIsDrawItemInteractiveState:Boolean);
//begin
//  inherited;
//  if AItemDesignerPanel.Properties.ItemExpandedBindingControl<>nil then
//  begin
//    AItemDesignerPanel.Properties.ItemExpandedIntf.BindingItemBool(TSkinTreeViewItem(AItem).Expanded,AIsDrawItemInteractiveState);
//  end;
//end;

constructor TTreeViewProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinTreeView,Self.FSkinTreeViewIntf) then
  begin
    ShowException('This Component Do not Support ISkinTreeView Interface');
  end
  else
  begin

    FParentItemNoSelect:=False;

    FIsAutoExpanded:=True;

    FParentItemStyleSetting:=TListItemTypeStyleSetting.Create(Self,sitParentItem);
    FParentItemStyleSetting.FOnInit:=Self.DoNewListItemStyleFrameCacheInit;
    FListItemTypeStyleSettingList.Add(FParentItemStyleSetting);

    FListLayoutsManager.OnItemExpandedChange:=Self.DoListLayoutsManagerItemExpandedChange;

  end;
end;

function TTreeViewProperties.DecideItemDesignerPanel(AItem: TSkinItem): TSkinItemDesignerPanel;
begin
  if TSkinTreeViewItem(AItem).IsParent and (AItem.ItemType=sitDefault) then
  begin
      //Result:=FInnerParentItemDesignerPanel;

      Result:=Self.FParentItemStyleSetting.GetInnerItemDesignerPanel(AItem);

  end
  else
  begin
      Result:=Inherited DecideItemDesignerPanel(AItem);
  end;
end;

destructor TTreeViewProperties.Destroy;
begin
  SetParentItemDesignerPanel(nil);

  FreeAndNil(FParentItemStyleSetting);


  inherited;
end;

procedure TTreeViewProperties.SetParentItemDesignerPanel(const Value: TSkinItemDesignerPanel);
begin
  FParentItemStyleSetting.ItemDesignerPanel:=Value;

//  if FParentItemDesignerPanel <> Value then
//  begin
//    RemoveOldDesignerPanel(FParentItemDesignerPanel);
//    FParentItemDesignerPanel:=Value;
//    FInnerParentItemDesignerPanel:=Value;
//    AddNewDesignerPanel(FParentItemDesignerPanel);
//  end;
end;

procedure TTreeViewProperties.SetParentItemHeight(const Value: TControlSize);
begin
  Self.ListLayoutsManager.ParentItemHeight:=Value;
end;

procedure TTreeViewProperties.SetParentTypeItemStyle(const Value: String);
begin
  FParentItemStyleSetting.Style:=Value;
end;

procedure TTreeViewProperties.SetParentTypeItemStyleConfig(
  const Value: TStringList);
begin
  FParentItemStyleSetting.Config:=Value;
end;

procedure TTreeViewProperties.DoClickItem(AItem: TBaseSkinItem;X:Double;Y:Double);
begin
  inherited;

  //自动展开
  if FIsAutoExpanded then
  begin
    TSkinTreeViewItem(AItem).Expanded:=Not TSkinTreeViewItem(AItem).Expanded;
  end;
end;

procedure TTreeViewProperties.DoListLayoutsManagerItemExpandedChange(
  Sender: TObject);
begin
  if Assigned(Self.FSkinTreeViewIntf.OnItemExpandedChange) then
  begin
    Self.FSkinTreeViewIntf.OnItemExpandedChange(Self,TSkinTreeViewItem(Sender));
  end;
end;

procedure TTreeViewProperties.DoSetSelectedItem(Value: TBaseSkinItem);
begin
  if FParentItemNoSelect and TSkinTreeViewItem(Value).IsParent then
  begin
    //父节点不选中
  end
  else
  begin
    inherited;
  end;
end;

function TTreeViewProperties.GetComponentClassify: String;
begin
  Result:='SkinTreeView';
end;

procedure TTreeViewProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;

  //自动展开
  FIsAutoExpanded:=TTreeViewProperties(Src).FIsAutoExpanded;
  //父节点不选中
  FParentItemNoSelect:=TTreeViewProperties(Src).FParentItemNoSelect;

  Self.ParentTypeItemStyle:=TTreeViewProperties(Src).ParentTypeItemStyle;


//  //父节点设计面板
//  SetParentItemDesignerPanel(TTreeViewProperties(Src).FParentItemDesignerPanel);

end;

procedure TTreeViewProperties.SetItems(const Value: TSkinTreeViewItems);
begin
  Inherited SetItems(Value);
end;

procedure TTreeViewProperties.SetLevelLeftOffset(const Value: TControlSize);
begin
  Self.ListLayoutsManager.LevelLeftOffset:=Value;
end;

procedure TTreeViewProperties.SetLevelRightIsFitControlWidth(const Value: Boolean);
begin
  Self.ListLayoutsManager.LevelRightIsFitControlWidth:=Value;
end;

procedure TTreeViewProperties.SetMouseDownItem(Value: TBaseSkinTreeViewItem);
begin
  Inherited MouseDownItem:=Value;
end;

procedure TTreeViewProperties.SetMouseOverItem(Value: TBaseSkinTreeViewItem);
begin
  Inherited MouseOverItem:=Value;
end;

procedure TTreeViewProperties.SetSelectedItem(Value: TBaseSkinTreeViewItem);
begin
  Inherited SelectedItem:=Value;
end;

procedure TTreeViewProperties.SetPanDragItem(Value: TBaseSkinTreeViewItem);
begin
  Inherited PanDragItem:=Value;
end;


{ TSkinTreeViewDefaultType }

function TSkinTreeViewDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinTreeView,Self.FSkinTreeViewIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinTreeView Interface');
    end;
  end;
end;

procedure TSkinTreeViewDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinTreeViewIntf:=nil;
end;

function TSkinTreeViewDefaultType.DecideItemMaterial(AItem: TBaseSkinItem;ASkinMaterial: TSkinCustomListDefaultMaterial): TBaseSkinListItemMaterial;
begin
  if TSkinTreeViewItem(AItem).IsParent then
  begin
    Result:=TSkinTreeViewDefaultMaterial(ASkinMaterial).FParentItemMaterial;
  end
  else
  begin
    Result:=(Inherited DecideItemMaterial(AItem,ASkinMaterial));
  end;
end;

function TSkinTreeViewDefaultType.GetSkinMaterial: TSkinTreeViewDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinTreeViewDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinTreeViewDefaultType.MarkAllListItemTypeStyleSettingCacheUnUsed(
  ADrawStartIndex, ADrawEndIndex: Integer);
//begin
//  inherited;
var
  I:Integer;
  AItem:TSkinTreeViewItem;
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


  Self.FSkinTreeViewIntf.Prop.FParentItemStyleSetting.MarkAllCacheNoUsed;




  //再将使用的缓存标记为已使用
  for I:=ADrawStartIndex to ADrawEndIndex do
  begin
    //将不再绘制的Item的缓存设置为不使用
    AItem:=TSkinTreeViewItem(Self.FSkinCustomListIntf.Prop.ListLayoutsManager.GetVisibleItems(I));

    case AItem.ItemType of
      sitDefault:
      begin
          if AItem.IsParent then
          begin
              Self.FSkinTreeViewIntf.Prop.FParentItemStyleSetting.MarkCacheUsed(AItem);
          end
          else
          begin
              Self.FSkinVirtualListIntf.Prop.FDefaultItemStyleSetting.MarkCacheUsed(AItem);
          end;
      end;
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

{ TSkinTreeViewItem }


{ TSkinTreeViewDefaultMaterial }

procedure TSkinTreeViewDefaultMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinTreeViewDefaultMaterial;
begin
  if Dest is TSkinTreeViewDefaultMaterial then
  begin

    DestObject:=TSkinTreeViewDefaultMaterial(Dest);

    DestObject.FParentItemMaterial.Assign(FParentItemMaterial);

  end;
  inherited;

end;

constructor TSkinTreeViewDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //父节点绘制素材
  FParentItemMaterial:=TSkinListItemMaterial.Create(Self);
  FParentItemMaterial.SetSubComponent(True);
  FParentItemMaterial.Name:='ParentItemMaterial';
end;

function TSkinTreeViewDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='ParentItemMaterial' then
    begin
      FParentItemMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    ;
  end;

  Result:=True;
end;

function TSkinTreeViewDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Class('ParentItemMaterial','父节点绘制素材');
  Self.FParentItemMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  Result:=True;
end;

destructor TSkinTreeViewDefaultMaterial.Destroy;
begin
  FreeAndNil(FParentItemMaterial);
  inherited;
end;

procedure TSkinTreeViewDefaultMaterial.SetParentItemMaterial(const Value: TSkinListItemMaterial);
begin
  FParentItemMaterial.Assign(Value);
end;




{ TSkinTreeView }

function TSkinTreeView.Material:TSkinTreeViewDefaultMaterial;
begin
  Result:=TSkinTreeViewDefaultMaterial(SelfOwnMaterial);
end;

function TSkinTreeView.SelfOwnMaterialToDefault:TSkinTreeViewDefaultMaterial;
begin
  Result:=TSkinTreeViewDefaultMaterial(SelfOwnMaterial);
end;

function TSkinTreeView.CurrentUseMaterialToDefault:TSkinTreeViewDefaultMaterial;
begin
  Result:=TSkinTreeViewDefaultMaterial(CurrentUseMaterial);
end;

function TSkinTreeView.GetOnItemExpandedChange: TItemExpandedChangeEvent;
begin
  Result:=FOnItemExpandedChange;
end;

function TSkinTreeView.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TTreeViewProperties;
end;

function TSkinTreeView.GetTreeViewProperties: TTreeViewProperties;
begin
  Result:=TTreeViewProperties(Self.FProperties);
end;

procedure TSkinTreeView.SetTreeViewProperties(Value: TTreeViewProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinTreeView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin

      if (AComponent=Self.Properties.ParentItemDesignerPanel) then
      begin
        Self.Properties.ParentItemDesignerPanel:=nil;
      end;

    end
    ;
  end;
end;



end.

