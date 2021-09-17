//convert pas to utf8 by ¥


unit FMX_XE_SkinItemsPropertyeditorForm;

interface

uses
  SysUtils,
  Types,
  Math,
  Classes,
  Variants,
  System.UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.ListBox,
  FMX.Layouts,
  FMX.TreeView,
  FMX.StdCtrls,
  FMX.Platform.Win,
  WinApi.Windows,
  FMX.Objects,


  uLang,
  uSkinItems,
  uBaseLog,
  uLanguage,


  FmxDesignWindows,
  DesignWindows,
  DesignIntf,
  TypInfo, FMX.Controls.Presentation;



type
  TItemClassDesc = record
    //所添加的列表项类
    // Can accept ItemClass Items
    ItemClass: TBaseSkinItemClass;
    //
    ShowOnlyInMenu: Boolean;
    constructor Create(const AItemClass: TBaseSkinItemClass;
                      const AShowOnlyInMenu: Boolean = False);
  end;


  TfrmSkinItemsPropertyEditor = class(TFmxDesignWindow,
                                       IFreeNotification)
    ItemsTree: TTreeView;
    ItemsClasses: TComboBox;
    btnAdd: TButton;
    ControlsLayout: TLayout;
    btnAddChild: TButton;
    btnDelete: TButton;
    Layout2: TLayout;
    btnUp: TButton;
    btnDown: TButton;
    Path1: TPath;
    Path2: TPath;
    btnInsert: TButton;
    btnClear: TButton;
    chkCopy: TCheckBox;
    tmrBringToFront: TTimer;
    TreeViewItem1: TTreeViewItem;
    btnSaveToFile: TButton;
    SaveDialog1: TSaveDialog;
    btnAddFromFile: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnAddClick(Sender: TObject);
    procedure btnAddChildClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure ItemsTreeChange(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure ItemsTreeDragChange(SourceItem, DestItem: TTreeViewItem;
      var Allow: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure tmrBringToFrontTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure btnAddFromFileClick(Sender: TObject);
  private

    FItemsDescription: array of TItemClassDesc;
    FItems: TBaseSkinItems;

    //当前选中结点的列表
    function SelectedItems:TBaseSkinItems;

    procedure UpdateNodeCaption(Node:TTreeViewItem);

    //更新树
    procedure SyncTree;
    //生成树
    procedure UpdateTree;
    procedure UpdateButtonStates;
    procedure RealignItems;
  protected
    procedure FreeNotification(AObject: TObject);override;
  public
    Designer:IDesigner;

    destructor Destroy; override;
    procedure SetItemClasses(const AItems: TBaseSkinItems;
                              const AItemDescriptions: array of TItemClassDesc);
  public
    procedure ItemDeleted(const ADesigner: IDesigner; Item: TPersistent); override;
    procedure ItemsModified(const Designer: IDesigner); override;
    procedure DesignerClosed(const Designer: IDesigner; AGoingDormant: Boolean); override;
  end;


var
  frmSkinItemsPropertyEditor: TfrmSkinItemsPropertyEditor;


implementation


{$R *.fmx}

uses
  {$IFDEF FMX}
  FMX_XE_DrawPicturePropertyEditorForm,
  {$ENDIF FMX}
  StringsEdit;


type
  //关闭监视器
  TCloseWatcher = class
    procedure DesignerClosed(Sender: TObject; var Action: TCloseAction);
  end;

var
  Watcher: TCloseWatcher;

procedure TCloseWatcher.DesignerClosed(Sender: TObject; var Action: TCloseAction);
begin
  if Sender = frmSkinItemsPropertyEditor then
  begin
    Action := TCloseAction.caFree;
    frmSkinItemsPropertyEditor := nil;
  end;
end;


{ TfrmSkinItemsPropertyEditor }

function TfrmSkinItemsPropertyEditor.SelectedItems: TBaseSkinItems;
begin
  Result:=Self.FItems;
  if (ItemsTree.Selected <> nil) then
  begin
    if (ItemsTree.Selected.TagObject <> nil) then
    begin
      Result:=TBaseSkinItem(ItemsTree.Selected.TagObject).Owner;
    end;
  end;
end;

procedure TfrmSkinItemsPropertyEditor.SetItemClasses(const AItems: TBaseSkinItems; const AItemDescriptions: array of TItemClassDesc);
var
  I: Integer;
  Item: TListBoxItem;
  ItemIndex: Integer;
begin
  if Length(AItemDescriptions) = 0 then Exit;


  ItemsClasses.Clear;



  //添加允许添加的列表
  SetLength(FItemsDescription, Length(AItemDescriptions));
  ItemIndex := 0;
  for I := 0 to High(AItemDescriptions) do
  begin
    if AItemDescriptions[I].ShowOnlyInMenu then
      Continue;
    Item := TListBoxItem.Create(nil);
    Item.Parent := ItemsClasses;
    Item.Text := AItemDescriptions[I].ItemClass.ClassName;
    Item.TextAlign := TTextAlign.taCenter;

    FItemsDescription[ItemIndex] := AItemDescriptions[I];
    Inc(ItemIndex);
  end;
  SetLength(FItemsDescription, ItemIndex);
  ItemsClasses.ItemIndex := 0;



  FItems := AItems;



  //生成树
  UpdateTree;
end;

procedure TfrmSkinItemsPropertyEditor.SyncTree;
  procedure SyncTreeNode(AParentNode:TTreeViewItem);
  var
    Node: TTreeViewItem;
    ChildContainer: ISkinItems;
    I: Integer;
  begin
    for I := 0 to AParentNode.Count - 1 do
    begin

      Node := AParentNode.Items[I];
      UpdateNodeCaption(Node);
      SyncTreeNode(Node);
    end;
  end;


var
  Node: TTreeViewItem;
  ChildContainer: ISkinItems;
  I: Integer;
begin
  for I := 0 to Self.ItemsTree.Count - 1 do
  begin
    Node := ItemsTree.Items[I];
    UpdateNodeCaption(Node);
    SyncTreeNode(Node);
  end;

end;

procedure TfrmSkinItemsPropertyEditor.tmrBringToFrontTimer(Sender: TObject);
var
  ps: array[0..254] of Char;
  ActiveWindowHandle:HWND;
begin


  ActiveWindowHandle:=WinApi.Windows.GetActiveWindow;
  if (ActiveWindowHandle>0)
      //当前激活的窗口不是Item的设计器,表示被覆盖了
      and (ActiveWindowHandle<>FmxHandleToHWND(Self.Handle))
      then
  begin

      //获取窗口类名
      GetClassName(ActiveWindowHandle, ps, 255);
      FMX.Types.Log.d('TfrmSkinItemsPropertyEditor.tmrBringToFrontTimer ActiveWindow'+ps);


      if
          //subitems编辑框
          (Pos('StringsEditDlg',ps)>0)
          //图片编辑框
        or (Pos('frmDrawPicturePropertyEditor',ps)>0)
        or (Pos('FMTBrushDesigner',ps)>0)
          //打开图片对话框
        or (Pos('#32770',ps)>0) then
      begin
        Hide;

      end
      else
      begin
        if Not Visible then Show;
        Self.BringToFront;
      end;

  end
  else
  begin
    if Not Visible then Show;
    Self.BringToFront;
  end;

end;

procedure TfrmSkinItemsPropertyEditor.btnAddChildClick(Sender: TObject);
var
  Node: TTreeViewItem;
  ASkinItem: TBaseSkinItem;
  ParentItem: TBaseSkinItem;
  Owner:TBaseSkinItems;
  SelectedItem: TTreeViewItem;
  ParentItems:ISkinItems;
begin
  Node := TTreeViewItem.Create(Self);

  SelectedItem:= ItemsTree.Selected;

  //子节点的父节点
  if ItemsTree.Selected <> nil then
    Node.Parent := ItemsTree.Selected
  else
    Node.Parent := ItemsTree;


  if SelectedItem<>nil then
  begin
    ParentItem:=TBaseSkinItem(SelectedItem.TagObject);

    if Supports(ParentItem, ISkinItems, ParentItems) then
    begin
      Owner:=ParentItems.Items;
    end
    else
    begin
      Owner:=FItems;
    end;

  end
  else
  begin
    Owner:=FItems;
  end;

  //添加子节点
  Owner.SkinItemClass:=Self.FItemsDescription[Self.ItemsClasses.ItemIndex].ItemClass;
  ASkinItem := TBaseSkinItem(Owner.Add);
  if chkCopy.IsChecked and (Self.ItemsTree.Selected<>nil) then
  begin
    ASkinItem.Assign(TBaseSkinItem(Self.ItemsTree.Selected.TagObject));
  end;

  Node.TagObject := ASkinItem;


  UpdateNodeCaption(Node);


  ItemsTree.Selected:= SelectedItem;
  ItemsTree.Selected.IsExpanded:= True;

  Designer.Modified;
  UpdateButtonStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnAddClick(Sender: TObject);
var
  Node: TTreeViewItem;
  ASkinItem: TBaseSkinItem;
begin
  Node := TTreeViewItem.Create(Self);
  //设置父节点
  if ItemsTree.Selected <> nil then
  begin
    Node.Parent := ItemsTree.Selected.Parent;
  end
  else
  begin
    Node.Parent := ItemsTree;
  end;


  //设置所添加的列表项类
  SelectedItems.SkinItemClass:=Self.FItemsDescription[Self.ItemsClasses.ItemIndex].ItemClass;
  ASkinItem:=TBaseSkinItem(SelectedItems.Add);
  if chkCopy.IsChecked and (Self.ItemsTree.Selected<>nil) then
  begin
    ASkinItem.Assign(TBaseSkinItem(Self.ItemsTree.Selected.TagObject));
  end;


  //添加绑定的对象
  Node.TagObject := ASkinItem;
  //更新节点标题
  UpdateNodeCaption(Node);
  //设置选中的节点
  ItemsTree.Selected := Node;
  //更新设计器
  Designer.Modified;
  UpdateButtonStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnAddFromFileClick(Sender: TObject);
begin
  if Self.OpenDialog1.Execute then
  begin
    Self.FItems.LoadFromFile(Self.OpenDialog1.FileName,False);
    //重新加载一遍
    //生成树
    UpdateTree;
  end;
end;

procedure TfrmSkinItemsPropertyEditor.btnClearClick(Sender: TObject);
begin
  ItemsTree.Clear;

  Designer.Modified;
  UpdateButtonStates;

  FItems.Clear(True);

  Designer.Modified;
  UpdateButtonStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnDeleteClick(Sender: TObject);
var
  Idx: Integer;
  Item: TTreeViewItem;
  Obj: TObject;
begin
  if ItemsTree.Selected <> nil then
  begin
    Idx := ItemsTree.Selected.GlobalIndex;

    if ItemsTree.GlobalCount > 1 then
    begin

      if (Idx > 0) then
      begin
        ItemsTree.Selected := ItemsTree.ItemByGlobalIndex(Idx - 1)
      end
      else
      begin
        ItemsTree.Selected := ItemsTree.ItemByGlobalIndex(1);
      end;

      if ItemsTree.Selected<>nil then
      begin
        Designer.SelectComponent(TBaseSkinItem(ItemsTree.Selected.TagObject));
      end;

    end
    else
    begin
      Designer.SelectComponent(Self.FItems);
    end;

    Designer.Modified;

    Item := ItemsTree.ItemByGlobalIndex(Idx);
    if Assigned(Item) then
    begin
      Obj := Item.TagObject;
      Self.FItems.BeginUpdate;
      try
        Item.TagObject := nil;
        FreeAndNil(Item);
        FreeAndNil(Obj);
      finally
        Self.FItems.EndUpdate;
      end;
    end;

    if ItemsTree.GlobalCount =0 then
    begin
      Designer.SelectComponent(Self.FItems);
      Designer.Modified;
    end;

    UpdateButtonStates;

  end;
end;

procedure TfrmSkinItemsPropertyEditor.btnDownClick(Sender: TObject);
begin
  { down }
  if (ItemsTree.Selected <> nil) then
  begin
    ItemsTree.Selected.Index := ItemsTree.Selected.Index + 1;
    ItemsTree.RealignContent;
    if (ItemsTree.Selected.TagObject <> nil) then
    begin
      Self.SelectedItems.Move(ItemsTree.Selected.Index,ItemsTree.Selected.Index-1);
    end;
    RealignItems;
  end;
  Designer.Modified;
  UpdateButtonStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnInsertClick(Sender: TObject);
var
  Node: TTreeViewItem;
  ASkinItem: TBaseSkinItem;
begin
  Node := TTreeViewItem.Create(Self);

  //设置父结点
  if ItemsTree.Selected <> nil then
  begin
    Node.Parent := ItemsTree.Selected.Parent;
    Node.Index:=ItemsTree.Selected.Index;
  end
  else
  begin
    Node.Parent := ItemsTree;
  end;

  //插入结点
  SelectedItems.SkinItemClass:=Self.FItemsDescription[Self.ItemsClasses.ItemIndex].ItemClass;
  ASkinItem:=TBaseSkinItem(Self.SelectedItems.Insert(Node.Index));
  //复制数据
  if chkCopy.IsChecked and (Self.ItemsTree.Selected<>nil) then
  begin
    ASkinItem.Assign(TBaseSkinItem(Self.ItemsTree.Selected.TagObject));
  end;

  Node.TagObject := ASkinItem;

  UpdateNodeCaption(Node);


  ItemsTree.Selected := Node;

  Designer.Modified;
  UpdateButtonStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnSaveToFileClick(Sender: TObject);
var
  I: Integer;
begin
  if Self.SaveDialog1.Execute then
  begin
    for I := 0 to FItems.Count-1 do
    begin
      if FItems[I] is TSkinItem then
      begin
        if not TSkinItem(FItems[I]).Icon.IsEmpty then
        begin
          TSkinItem(FItems[I]).Icon.SaveToFile(ExtractFilePath(Self.SaveDialog1.FileName)+TSkinItem(FItems[I]).Caption+'.png');
        end;
      end;
    end;

    Self.FItems.SaveToFile(Self.SaveDialog1.FileName);
  end;
end;

procedure TfrmSkinItemsPropertyEditor.btnUpClick(Sender: TObject);
begin
  { up }
  if (ItemsTree.Selected <> nil) then
  begin
    ItemsTree.Selected.Index := ItemsTree.Selected.Index - 1;
    ItemsTree.RealignContent;
    if (ItemsTree.Selected.TagObject <> nil) then
    begin
      Self.SelectedItems.Move(ItemsTree.Selected.Index+1,ItemsTree.Selected.Index);
    end;
    RealignItems;
  end;
  Designer.Modified;
  UpdateButtonStates;
end;

procedure TfrmSkinItemsPropertyEditor.DesignerClosed(const Designer: IDesigner;
  AGoingDormant: Boolean);
begin
  inherited;

end;

destructor TfrmSkinItemsPropertyEditor.Destroy;
begin
  {$IFDEF FMX}
  FMX_XE_DrawPicturePropertyEditorForm.frmSkinItemsPropertyEditor:=nil;
  {$ENDIF FMX}

  inherited;
end;

procedure TfrmSkinItemsPropertyEditor.FormCreate(Sender: TObject);
begin
  {$IFDEF FMX}
  FMX_XE_DrawPicturePropertyEditorForm.frmSkinItemsPropertyEditor:=Self;
  {$ENDIF FMX}

  Self.ItemsTree.Clear;


  // Setup the watcher
  if not Assigned(Watcher) then
    Watcher := TCloseWatcher.Create;
  OnClose := Watcher.DesignerClosed;


  //翻译
  Self.Caption:=Langs_ItemsEditor[LangKind];

  btnAdd.Text:=Langs_AddItem[LangKind];
  btnInsert.Text:=Langs_InsertItem[LangKind];
  btnAddChild.Text:=Langs_AddChildItem[LangKind];
  btnDelete.Text:=Langs_DeleteItem[LangKind];
  btnClear.Text:=Langs_ClearAllItems[LangKind];

end;

procedure TfrmSkinItemsPropertyEditor.FormDestroy(Sender: TObject);
begin
  frmSkinItemsPropertyEditor:=nil;
end;

procedure TfrmSkinItemsPropertyEditor.FreeNotification(AObject: TObject);
begin
  inherited;
//  if Assigned(FContainer) and (AObject = FContainer.GetObject) then
//  begin
//    FContainer := nil;
//    Close;
//  end;
end;

procedure TfrmSkinItemsPropertyEditor.ItemDeleted(const ADesigner: IDesigner;
  Item: TPersistent);
begin
  inherited;
  uBaseLog.OutputDebugString('TfrmSkinItemsPropertyEditor.ItemDeleted');
end;

procedure TfrmSkinItemsPropertyEditor.ItemsModified(const Designer: IDesigner);
begin
  inherited;
  uBaseLog.OutputDebugString('TfrmSkinItemsPropertyEditor.ItemsModified');

end;

procedure TfrmSkinItemsPropertyEditor.ItemsTreeChange(Sender: TObject);
begin
  Designer.SelectComponent(TBaseSkinItem(ItemsTree.Selected.TagObject));
  SyncTree;
  UpdateButtonStates;
end;

procedure TfrmSkinItemsPropertyEditor.ItemsTreeDragChange(
          SourceItem,
          DestItem: TTreeViewItem; var Allow: Boolean);
var
  ASourceSkinItem:TBaseSkinItem;
  ADestSkinItem:TBaseSkinItem;
  ADestIndex:Integer;
begin

  Allow:=False;

  uBaseLog.OutputDebugString('TfrmSkinItemsPropertyEditor.ItemsTreeDragChange');

  ASourceSkinItem:=TBaseSkinItem(SourceItem.TagObject);
  ADestSkinItem:=TBaseSkinItem(DestItem.TagObject);


  if (ASourceSkinItem<>nil)
    and (ADestSkinItem<>nil) then
  begin
    if (ASourceSkinItem.Owner=ADestSkinItem.Owner) then
    begin
      ADestIndex:=ADestSkinItem.Owner.IndexOf(ADestSkinItem);

      //同一个列表,只需要改变顺序
      ASourceSkinItem.Owner.Remove(ASourceSkinItem,False);

      ADestSkinItem.Owner.Insert(ADestIndex,ASourceSkinItem);

      uBaseLog.OutputDebugString('TfrmSkinItemsPropertyEditor.ItemsTreeDragChange '
                                +'Insert '+IntToStr(ADestIndex));

      //更改顺序
      SourceItem.Index:=DestItem.Index;

      DestItem.Deselect;
      DestItem.Repaint;

      SourceItem.Select;
      SourceItem.Repaint;
    end;
  end;
end;

procedure TfrmSkinItemsPropertyEditor.RealignItems;
begin
  Designer.SelectComponent(TBaseSkinItem(ItemsTree.Selected.TagObject));
end;

procedure TfrmSkinItemsPropertyEditor.UpdateNodeCaption(Node: TTreeViewItem);
begin
  if Node.TagObject<>nil then
  begin
    if (Node.TagObject is TRealSkinItem) or (Node.TagObject is TRealSkinTreeViewItem) then
    begin
      if TSkinItem(Node.TagObject).ItemType=sitSpace then
      begin
        Node.Text :='----------';
      end
      else
      begin
        Node.Text :=TSkinItem(Node.TagObject).Caption;
      end;
    end;

    if Node.Text = '' then
    begin
      Node.Text := '未命令';
    end;
  end;
end;

procedure TfrmSkinItemsPropertyEditor.UpdateButtonStates;
begin
  btnUp.Enabled := (ItemsTree.Selected <> nil) and (ItemsTree.Selected.Index > 0);
  btnDown.Enabled := (ItemsTree.Selected <> nil) and (ItemsTree.Selected.Parent <> nil) and (ItemsTree.Selected.Index < ItemsTree.Selected.Parent.ChildrenCount - 1);
  btnDelete.Enabled := ItemsTree.Selected <> nil;
  btnAddChild.Enabled := ItemsTree.Selected <> nil;
end;

procedure TfrmSkinItemsPropertyEditor.UpdateTree;

  //更新节点列表
  procedure UpdateItem(AItems:TBaseSkinItems; AParentNode: TFmxObject);
  var
    Node: TTreeViewItem;
    ChildContainer: ISkinItems;
    I: Integer;
  begin
    for I := 0 to AItems.Count - 1 do
    begin

      Node := TTreeViewItem.Create(nil);
      Node.Parent := AParentNode;
      Node.TagObject := AItems[I];

      UpdateNodeCaption(Node);

      //子节点
      if Supports(AItems[I], ISkinItems, ChildContainer) then
      begin
        UpdateItem(ChildContainer.Items, Node);
      end;

    end;
  end;

begin
  if FItems = nil then
  begin
    Exit;
  end;

  ItemsTree.Clear;

  UpdateItem(FItems, ItemsTree);

  //展开全部
  ItemsTree.ExpandAll;

  UpdateButtonStates;
end;

{ TItemClassDesc }

constructor TItemClassDesc.Create(
                  const AItemClass: TBaseSkinItemClass;
                  const AShowOnlyInMenu: Boolean);
begin
  Self.ItemClass := AItemClass;
  Self.ShowOnlyInMenu := AShowOnlyInMenu;
end;



initialization

finalization
  if Assigned(Watcher) then
    Watcher.Free;


end.

