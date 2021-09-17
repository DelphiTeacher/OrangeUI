//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     列表框
///   </para>
///   <para>
///     List Box
///   </para>
/// </summary>
unit uSkinListBoxType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
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
  uSkinImageList,
  uSkinCustomListType,
  uSkinVirtualListType,
  uSkinControlGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;

const
  IID_ISkinListBox:TGUID='{D3D65F7C-398C-42DA-B745-B095EF372A4A}';




type
  TSkinListBoxItems=class;
  TSkinListBoxItemsClass=class of TSkinListBoxItems;
  TListBoxProperties=class;
  TSkinListBoxLayoutsManager=class;

  /// <summary>
  ///   <para>
  ///     列表项
  ///   </para>
  ///   <para>
  ///     ListItem
  ///   </para>
  /// </summary>
  TSkinListBoxItem=TRealSkinItem;




  /// <summary>
  ///   <para>
  ///     列表框接口
  ///   </para>
  ///   <para>
  ///     Interface of ListBox
  ///   </para>
  /// </summary>
  ISkinListBox=interface//(ISkinScrollControl)
  ['{D3D65F7C-398C-42DA-B745-B095EF372A4A}']


    function GetListBoxProperties:TListBoxProperties;
    property Properties:TListBoxProperties read GetListBoxProperties;
    property Prop:TListBoxProperties read GetListBoxProperties;
  end;







  /// <summary>
  ///   <para>
  ///     列表框属性
  ///   </para>
  ///   <para>
  ///     Properties of ListBox
  ///   </para>
  /// </summary>
  TListBoxProperties=class(TVirtualListProperties)
  protected
    FSkinListBoxIntf:ISkinListBox;
    function GetItems: TSkinListBoxItems;
    procedure SetItems(const Value: TSkinListBoxItems);
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
    //列表逻辑
    function GetListLayoutsManager: TSkinListBoxLayoutsManager;
    //获取列表项列表的类
    function GetItemsClass:TBaseSkinItemsClass;override;
    //获取列表逻辑类
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;override;

  protected
    //获取分类名称
    function GetComponentClassify:String;override;
  protected
  public
    constructor Create(ASkinControl:TControl);override;
  public

    /// <summary>
    ///   <para>
    ///     列表项布局管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ListLayoutsManager:TSkinListBoxLayoutsManager read GetListLayoutsManager;

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
    ///     Pressed ListeItem
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
    ///     列表项列表
    ///   </para>
    ///   <para>
    ///     ListItem List
    ///   </para>
    /// </summary>
    property Items:TSkinListBoxItems read GetItems write SetItems;

    /// <summary>
    ///   <para>
    ///     是否启用居中选择模式
    ///   </para>
    ///   <para>
    ///     Center selected pattern
    ///   </para>
    /// </summary>
    property IsEnabledCenterItemSelectMode;
  end;














  /// <summary>
  ///   <para>
  ///     列表项列表
  ///   </para>
  ///   <para>
  ///     ListItem List
  ///   </para>
  /// </summary>
  TSkinListBoxItems=class(TSkinItems)
  private
    function GetItem(Index: Integer): TSkinListBoxItem;
    procedure SetItem(Index: Integer; const Value: TSkinListBoxItem);
  protected
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
  public
    function Add:TSkinListBoxItem;overload;
    function Insert(Index:Integer):TSkinListBoxItem;
    property Items[Index:Integer]:TSkinListBoxItem read GetItem write SetItem;default;
  end;






  /// <summary>
  ///   <para>
  ///     列表项逻辑
  ///   </para>
  ///   <para>
  ///     ListItem Logic
  ///   </para>
  /// </summary>
  TSkinListBoxLayoutsManager=class(TSkinVirtualListLayoutsManager)
  end;



  /// <summary>
  ///   <para>
  ///     列表框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of ListBox material
  ///   </para>
  /// </summary>
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinListBoxDefaultMaterial=class(TSkinVirtualListDefaultMaterial)
  end;

  TSkinListBoxDefaultType=class(TSkinVirtualListDefaultType)
  protected
    FSkinListBoxIntf:ISkinListBox;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  protected
    function GetSkinMaterial:TSkinListBoxDefaultMaterial;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinListBox=class(TSkinVirtualList,ISkinListBox)
  private

    function GetListBoxProperties:TListBoxProperties;
    procedure SetListBoxProperties(Value:TListBoxProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinListBoxDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinListBoxDefaultMaterial;
    function Material:TSkinListBoxDefaultMaterial;

    property Prop:TListBoxProperties read GetListBoxProperties write SetListBoxProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TListBoxProperties read GetListBoxProperties write SetListBoxProperties;

  end;



  {$IFDEF VCL}
  TSkinWinListBox=class(TSkinListBox)
  end;
  {$ENDIF VCL}



implementation




{ TListBoxProperties }


constructor TListBoxProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinListBox,Self.FSkinListBoxIntf) then
  begin
    ShowException('This Component Do not Support ISkinListBox Interface');
  end
  else
  begin
  end;
end;

function TListBoxProperties.GetComponentClassify: String;
begin
  Result:='SkinListBox';
end;

function TListBoxProperties.GetInteractiveItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited InteractiveItem);
end;

function TListBoxProperties.GetItems: TSkinListBoxItems;
begin
  Result:=TSkinListBoxItems(FItems);
end;

function TListBoxProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TSkinListBoxItems;
end;

function TListBoxProperties.GetListLayoutsManager: TSkinListBoxLayoutsManager;
begin
  Result:=TSkinListBoxLayoutsManager(Self.FListLayoutsManager);
end;

function TListBoxProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinListBoxLayoutsManager;
end;

procedure TListBoxProperties.SetItems(const Value: TSkinListBoxItems);
begin
  Inherited SetItems(Value);
end;

function TListBoxProperties.GetMouseDownItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited MouseDownItem);
end;

function TListBoxProperties.GetMouseOverItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited MouseOverItem);
end;

function TListBoxProperties.GetPanDragItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited PanDragItem);
end;

function TListBoxProperties.GetSelectedItem: TSkinItem;
begin
  Result:=TSkinItem(Inherited SelectedItem);
end;

procedure TListBoxProperties.SetMouseDownItem(Value: TSkinItem);
begin
  Inherited MouseDownItem:=Value;
end;

procedure TListBoxProperties.SetMouseOverItem(Value: TSkinItem);
begin
  Inherited MouseOverItem:=Value;
end;

procedure TListBoxProperties.SetSelectedItem(Value: TSkinItem);
begin
  Inherited SelectedItem:=Value;
end;

procedure TListBoxProperties.SetPanDragItem(Value: TSkinItem);
begin
  Inherited PanDragItem:=Value;
end;

{ TSkinListBoxDefaultType }

function TSkinListBoxDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinListBox,Self.FSkinListBoxIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinListBox Interface');
    end;
  end;
end;

procedure TSkinListBoxDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinListBoxIntf:=nil;
end;

function TSkinListBoxDefaultType.GetSkinMaterial: TSkinListBoxDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinListBoxDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

{ TSkinListBoxItems }


function TSkinListBoxItems.Add: TSkinListBoxItem;
begin
  Result:=TSkinListBoxItem(Inherited Add);
end;

//procedure TSkinListBoxItems.InitSkinItemClass;
//begin
//  SkinItemClass:=TSkinListBoxItem;
//end;

function TSkinListBoxItems.Insert(Index:Integer): TSkinListBoxItem;
begin
  Result:=TSkinListBoxItem(Inherited Insert(Index));
end;

procedure TSkinListBoxItems.SetItem(Index: Integer;const Value: TSkinListBoxItem);
begin
  Inherited Items[Index]:=Value;
end;

//function TSkinListBoxItems.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=SkinItemClass.Create;//(Self);
//end;

function TSkinListBoxItems.GetItem(Index: Integer): TSkinListBoxItem;
begin
  Result:=TSkinListBoxItem(Inherited Items[Index]);
end;

function TSkinListBoxItems.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TSkinListBoxItem;
end;

{ TSkinListBox }

function TSkinListBox.Material:TSkinListBoxDefaultMaterial;
begin
  Result:=TSkinListBoxDefaultMaterial(SelfOwnMaterial);
end;

function TSkinListBox.SelfOwnMaterialToDefault:TSkinListBoxDefaultMaterial;
begin
  Result:=TSkinListBoxDefaultMaterial(SelfOwnMaterial);
end;

function TSkinListBox.CurrentUseMaterialToDefault:TSkinListBoxDefaultMaterial;
begin
  Result:=TSkinListBoxDefaultMaterial(CurrentUseMaterial);
end;

function TSkinListBox.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TListBoxProperties;
end;

function TSkinListBox.GetListBoxProperties: TListBoxProperties;
begin
  Result:=TListBoxProperties(Self.FProperties);
end;

procedure TSkinListBox.SetListBoxProperties(Value: TListBoxProperties);
begin
  Self.FProperties.Assign(Value);
end;






end.



