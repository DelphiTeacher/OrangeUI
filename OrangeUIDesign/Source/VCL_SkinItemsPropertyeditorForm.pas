
unit VCL_SkinItemsPropertyeditorForm;

interface

uses
  SysUtils,
  Types,
  Classes,
  Variants,
  {$IF CompilerVersion >= 30.0}
  System.UITypes,
  {$IFEND}
  Controls,
  Forms,
  Dialogs,
  DesignWindows,
  uSkinItems,
  DesignIntf,
  TypInfo, ComCtrls, StdCtrls, ExtCtrls;



type
   // Not every item can accept similar item
   // For Example: TListBoxItem doesn't accept TListBox Item
   //              TMenuItem can accept TMenuItem
   TItemClassDesc = record
     ItemClass: TBaseSkinItemClass;
     CanContainSimilarItem: Boolean; // Can accept ItemClass Items
     ShowOnlyInMenu: Boolean;
     constructor Create(const AItemClass: TBaseSkinItemClass;
       const ACanContaineSimilarItem: Boolean = False;
       const AShowOnlyInMenu: Boolean = False);
   end;


  TfrmSkinItemsPropertyEditor = class(TForm)
    ControlsLayout: TPanel;
    ItemsClasses: TComboBox;
    btnAdd: TButton;
    btnAddChild: TButton;
    Layout2: TPanel;
    btnUp: TButton;
    btnDown: TButton;
    btnDelete: TButton;
    btnInsert: TButton;
    btnClear: TButton;
    ItemsTree: TTreeView;
    procedure btnAddClick(Sender: TObject);
    procedure btnAddChildClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure ItemsTreeChange(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ItemsTreeClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private

    FItemsDescription: array of TItemClassDesc;
    FItems: TBaseSkinItems;
    FDeletedItem: TTreeNode;

    procedure SyncTree;
    procedure UpdateTree;
    procedure UpdateStates;
    function AcceptsChildItem(const AItem: TObject): Boolean;
    procedure RealignItems;
  protected
    procedure FreeNotification(AObject: TObject);// override;
  public
    Designer:IDesigner;

    destructor Destroy; override;
    procedure SetItemClasses(const AItems: TBaseSkinItems; const AItemDescriptions: array of TItemClassDesc);
//    procedure ItemDeleted(const ADesigner: IDesigner; Item: TPersistent); override;
//    procedure ItemsModified(const Designer: IDesigner); override;
//    procedure DesignerClosed(const Designer: IDesigner; AGoingDormant: Boolean); override;
  end;

var
  frmSkinItemsPropertyEditor: TfrmSkinItemsPropertyEditor;

implementation

uses
  Math;

{$R *.dfm}

type
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

procedure TfrmSkinItemsPropertyEditor.SetItemClasses(const AItems: TBaseSkinItems; const AItemDescriptions: array of TItemClassDesc);
var
  I: Integer;
  ItemIndex: Integer;
begin
  if Length(AItemDescriptions) = 0 then Exit;

  ItemsClasses.Clear;


  SetLength(FItemsDescription, Length(AItemDescriptions));
  ItemIndex := 0;
  for I := 0 to High(AItemDescriptions) do
  begin
    if AItemDescriptions[I].ShowOnlyInMenu then
      Continue;

    ItemsClasses.Items.Add(AItemDescriptions[I].ItemClass.ClassName);

    FItemsDescription[ItemIndex] := AItemDescriptions[I];
    Inc(ItemIndex);
  end;
  SetLength(FItemsDescription, ItemIndex);
  ItemsClasses.ItemIndex := 0;


  FItems := AItems;

  UpdateTree;
end;

procedure TfrmSkinItemsPropertyEditor.SyncTree;
var
  Node: TTreeNode;
  IsItem: Boolean;
  i, j: integer;
begin
  for i := 0 to Self.ItemsTree.Items.Count - 1 do
  begin
    IsItem := false;
    for j := 0 to High(FItemsDescription) do
      if (FItems[I] is FItemsDescription[j].ItemClass) and (FItems[I].Owner <> nil)
      then
      begin
        IsItem := true;
        Break;
      end;



    if not IsItem then Continue;



    Node := ItemsTree.Items[I];
    if Node.Data<>nil then
    begin
      if TSkinItem(Node.Data).ItemType=sitSpace then
      begin
        Node.Text :='----------';
      end
      else
      begin
        Node.Text :=TSkinItem(Node.Data).Caption;
      end;
      if Node.Text = '' then
        Node.Text := 'Œ¥√¸¡Ó';
    end;

  end;
end;

function TfrmSkinItemsPropertyEditor.AcceptsChildItem(const AItem: TObject): Boolean;

  function FindItemDescription(AItemClass: TClass): Integer;
  var
    I: Integer;
    Founded: Boolean;
  begin
    I := 0;
    Founded := False;
    while (I < Length(FItemsDescription)) and not Founded do
      if FItemsDescription[I].ItemClass = AItemClass then
        Founded := True
      else
        Inc(I);
    if Founded then
      Result := I
    else
      Result := -1;
  end;

var
  Index: Integer;
begin
  Result := True;
  if Assigned(AItem) then
  begin
    Index := FindItemDescription(AItem.ClassType);
    Result := (Index <> -1) and FItemsDescription[Index].CanContainSimilarItem;
  end;
end;

procedure TfrmSkinItemsPropertyEditor.btnAddChildClick(Sender: TObject);
//var
//  Node: TTreeNode;
//  Item: TSkinItem;
//  SelectedItem: TTreeNode;
begin
//  Node := TTreeNode.Create(Self.ItemsTree.Items);
//  SelectedItem:= ItemsTree.Selected;
////  if ItemsTree.Selected <> nil then
////    Node.Parent := ItemsTree.Selected
////  else
////    Node.Parent := ItemsTree;
//
//  Item := FItemsDescription[ItemsClasses.ItemIndex].ItemClass.Create(Self.FItems);
//  FItems.Add(Item);
////  if Node.ParentItem <> nil then
////    Item.Parent := TSkinItem(Node.ParentItem.Data)
////  else
////    Item.Parent := FContainer.GetObject;
////  Item.Name := Designer.UniqueName(Item.ClassName);
//
////  if GetPropInfo(Item, 'Caption') <> nil then
////    Node.Text := GetStrProp(Item, 'Caption');
////  if Node.Text = '' then
////    Node.Text := Item.Name;
////  if Node.Text = '' then
////    Node.Text := 'Œ¥√¸¡Ó';
//  Node.Data := Item;
//
//  if Node.Data<>nil then
//  begin
//    if TSkinItem(Node.Data).ItemType=sitSpace then
//    begin
//      Node.Text :='----------';
//    end
//    else
//    begin
//      Node.Text :=TSkinItem(Node.Data).Caption;
//    end;
//    if Node.Text = '' then
//      Node.Text := 'Œ¥√¸¡Ó';
//  end;
//
//
////  ItemsTree.Selected := Node;
//  ItemsTree.Selected:= SelectedItem;
////  ItemsTree.Selected.IsExpanded:= True;
//
//  Designer.Modified;
//  UpdateStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnAddClick(Sender: TObject);
var
  Node: TTreeNode;
  Item: TBaseSkinItem;
begin
//  Node := TTreeNode.Create(Self.ItemsTree.Items);
  Node:=Self.ItemsTree.Items.Add(nil,'');
//  if ItemsTree.Selected <> nil then
//    Node.Parent := ItemsTree.Selected.Parent
//  else
//    Node.Parent := ItemsTree;

  Item := FItemsDescription[ItemsClasses.ItemIndex].ItemClass.Create;//(Self.FItems);
//  Item.Caption:='Test';
  FItems.Add(Item);
//  if Node.ParentItem <> nil then
//    Item.Parent := TSkinItem(Node.ParentItem.Data)
//  else
//    Item.Parent := FContainer.GetObject;
//  Item.Name := Designer.UniqueName(Item.ClassName);

//  if GetPropInfo(Item, 'Caption') <> nil then
//    Node.Text := GetStrProp(Item, 'Caption');
//  if Node.Text = '' then
//    Node.Text := Item.Name;
//  if Node.Text = '' then
//    Node.Text := 'Œ¥√¸¡Ó';
  Node.Data := Item;

  if Node.Data<>nil then
  begin
    if TSkinItem(Node.Data).ItemType=sitSpace then
    begin
      Node.Text :='----------';
    end
    else
    begin
      Node.Text :=TSkinItem(Node.Data).Caption;
    end;
    if Node.Text = '' then
      Node.Text := 'Œ¥√¸¡Ó';
  end;


  ItemsTree.Selected := Node;

  Designer.Modified;
  UpdateStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnClearClick(Sender: TObject);
begin
  ItemsTree.Items.Clear;

  Designer.Modified;
  UpdateStates;

  FItems.Clear(True);

  Designer.Modified;
  UpdateStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnDeleteClick(Sender: TObject);
var
  Idx: integer;
  Item: TTreeNode;
  Obj: TObject;
begin
  if ItemsTree.Selected <> nil then
  begin
    Idx := ItemsTree.Selected.Index;

    if ItemsTree.Items.Count > 0 then
    begin
      if Idx > 0 then
        ItemsTree.Selected := ItemsTree.Items[Idx - 1]
      else
        ItemsTree.Selected := ItemsTree.Items[0];
    end
    else
    begin
      ItemsTree.Selected:=nil;
    end;

    if ItemsTree.Selected<>nil then
    begin
      Designer.SelectComponent(TSkinItem(ItemsTree.Selected.Data));
    end
    else
    begin
      Designer.SelectComponent(FItems);
    end;

    Designer.Modified;
    UpdateStates;



    FDeletedItem := nil;
    Item := ItemsTree.Items[Idx];
    if Assigned(Item) then
    begin
      Obj := Item.Data;
      try
        Item.Data := nil;
        if FDeletedItem = nil then
        begin
          FreeAndNil(Item);
        end;

      finally
        Self.FItems.Remove(Obj,True);
      end;
    end;


    Designer.Modified;
    UpdateStates;

  end;
end;

procedure TfrmSkinItemsPropertyEditor.btnDownClick(Sender: TObject);
var
  ACaption:String;
  AData:Pointer;
begin
  { down }
  if (ItemsTree.Selected <> nil) then
  begin
    ACaption:=ItemsTree.Selected.Text;
    AData:=ItemsTree.Selected.Data;

    ItemsTree.Selected.Text:=ItemsTree.Items[ItemsTree.Selected.Index+1].Text;
    ItemsTree.Selected.Data:=ItemsTree.Items[ItemsTree.Selected.Index+1].Data;

    ItemsTree.Items[ItemsTree.Selected.Index+1].Text:=ACaption;
    ItemsTree.Items[ItemsTree.Selected.Index+1].Data:=AData;

    if (ItemsTree.Selected.Data <> nil) then
    begin
      Self.FItems.Move(ItemsTree.Selected.Index,ItemsTree.Selected.Index+1);
    end;
    RealignItems;
  end;
  Designer.Modified;
  UpdateStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnInsertClick(Sender: TObject);
var
  Node: TTreeNode;
  Item: TBaseSkinItem;
begin
//  Node := TTreeNode.Create(Self.ItemsTree.Items);

    Node := Self.ItemsTree.Items.Insert(ItemsTree.Selected,'');
//  if ItemsTree.Selected <> nil then
//  begin
//    Node := Self.ItemsTree.Items.Add(ItemsTree.Selected,'');
////    Node.Parent := ItemsTree.Selected.Parent;
////    Node.Index:=ItemsTree.Selected.Index;
//  end
//  else
//  begin
//    Node := Self.ItemsTree.Items.Add(ItemsTree.Selected,'');
////    Node.Parent := ItemsTree;
//  end;

  Item := FItemsDescription[ItemsClasses.ItemIndex].ItemClass.Create;//(Self.FItems);
//  Item.Caption:='Test';
  FItems.Insert(Node.Index,Item);
//  if Node.ParentItem <> nil then
//    Item.Parent := TSkinItem(Node.ParentItem.Data)
//  else
//    Item.Parent := FContainer.GetObject;
//  Item.Name := Designer.UniqueName(Item.ClassName);

//  if GetPropInfo(Item, 'Caption') <> nil then
//    Node.Text := GetStrProp(Item, 'Caption');
//  if Node.Text = '' then
//    Node.Text := Item.Name;
//  if Node.Text = '' then
//    Node.Text := 'Œ¥√¸¡Ó';
  Node.Data := Item;

  if Node.Data<>nil then
  begin
    if TSkinItem(Node.Data).ItemType=sitSpace then
    begin
      Node.Text :='----------';
    end
    else
    begin
      Node.Text :=TSkinItem(Node.Data).Caption;
    end;
    if Node.Text = '' then
      Node.Text := 'Œ¥√¸¡Ó';
  end;


  ItemsTree.Selected := Node;

  Designer.Modified;
  UpdateStates;
end;

procedure TfrmSkinItemsPropertyEditor.btnUpClick(Sender: TObject);
var
  ACaption:String;
  AData:Pointer;
begin
  { up }
  if (ItemsTree.Selected <> nil) then
  begin
    ACaption:=ItemsTree.Selected.Text;
    AData:=ItemsTree.Selected.Data;

    ItemsTree.Selected.Text:=ItemsTree.Items[ItemsTree.Selected.Index-1].Text;
    ItemsTree.Selected.Data:=ItemsTree.Items[ItemsTree.Selected.Index-1].Data;

    ItemsTree.Items[ItemsTree.Selected.Index-1].Text:=ACaption;
    ItemsTree.Items[ItemsTree.Selected.Index-1].Data:=AData;

    if (ItemsTree.Selected.Data <> nil) then
    begin
      Self.FItems.Move(ItemsTree.Selected.Index,ItemsTree.Selected.Index-1);
    end;
    RealignItems;
  end;
  Designer.Modified;
  UpdateStates;
end;

//procedure TfrmSkinItemsPropertyEditor.DesignerClosed(const Designer: IDesigner;
//  AGoingDormant: Boolean);
//begin
//  inherited;
//  if Assigned(FContainer) then
//  begin
//    FContainer.GetObject.RemoveFreeNotify(Self);
//    FContainer := nil;
//  end;
//  Close;
//end;

destructor TfrmSkinItemsPropertyEditor.Destroy;
begin
//  if Assigned(FContainer) then
//  begin
//    FContainer.GetObject.RemoveFreeNotify(Self);
//    FContainer := nil;
//  end;
  inherited;
end;

procedure TfrmSkinItemsPropertyEditor.FormCreate(Sender: TObject);
const
  ButtonMargin: Integer = 8;
var
  RequiredWidth: Integer;
begin
//  // Layout buttons for localization
//  RequiredWidth := Round(Canvas.TextWidth(btnAdd.Text)) + ButtonMargin * 2;
//  RequiredWidth := Math.Max(RequiredWidth,
//    Round(Canvas.TextWidth(btnAddChild.Text)) + ButtonMargin * 2);
//
//  // Finally examine the UpDownDelete buttons as a group
//  RequiredWidth := Math.Max(RequiredWidth,
//    Round(btnUp.Width) + ButtonMargin + Round(btnDown.Width) + ButtonMargin +
//    Round(Canvas.TextWidth(btnDelete.Text)) + ButtonMargin * 2);
//
//  // Make the changes
//  ControlsLayout.Width := RequiredWidth + 2 * ButtonMargin;

  // Setup the watcher
  if not Assigned(Watcher) then
    Watcher := TCloseWatcher.Create;
  OnClose := Watcher.DesignerClosed;
end;

procedure TfrmSkinItemsPropertyEditor.FreeNotification(AObject: TObject);
begin
//  inherited;
//  if Assigned(FContainer) and (AObject = FContainer.GetObject) then
//  begin
//    FContainer := nil;
//    Close;
//  end;
end;

//procedure TfrmSkinItemsPropertyEditor.ItemDeleted(const ADesigner: IDesigner;
//  Item: TPersistent);
//var
//  I: Integer;
//begin
//  inherited;
//  { check for deletion }
//  for I := 0 to ItemsTree.GlobalCount - 1 do
//    if ItemsTree.ItemByGlobalIndex(I).Data = Item then
//    begin
//      FDeletedItem := ItemsTree.ItemByGlobalIndex(I);
//      FDeletedItem.Free;
//      Exit;
//    end;
//end;
//
//procedure TfrmSkinItemsPropertyEditor.ItemsModified(const Designer: IDesigner);
//var
//  I, J: Integer;
//  Sel: TDesignerSelections;
//  Obj: TPersistent;
//  Node: TTreeNode;
//begin
//  inherited;
//  { check selection for object in tree }
//  Sel := TDesignerSelections.Create;
//  Designer.GetSelections(Sel);
//  for I := 0 to IDesignerSelections(Sel).Count - 1 do
//  begin
//    Obj := IDesignerSelections(Sel).Items[i];
//    for J := 0 to ItemsTree.GlobalCount - 1 do
//    begin
//      Node := ItemsTree.ItemByGlobalIndex(J);
//      if Node.Data = Obj then
//      begin
//        { change text }
//        if GetPropInfo(Obj, 'text') <> nil then
//          Node.Text := GetStrProp(Obj, 'text');
//        if Node.Text = '' then
//          if Obj is TComponent then
//            Node.Text := TComponent(Obj).Name
//          else
//            Node.Text := 'Unnamed';
//        Break;
//      end;
//    end;
//  end;
//end;

procedure TfrmSkinItemsPropertyEditor.ItemsTreeChange(Sender: TObject);
begin
//  if ItemsTree.Selected<>nil then
//  begin
//      if ItemsTree.Selected.Data<>nil then
//      begin
//        ShowMessage('a');

  Designer.SelectComponent(TSkinItem(ItemsTree.Selected.Data));
  SyncTree;
  UpdateStates;

//      end;
//
//  end;

end;

procedure TfrmSkinItemsPropertyEditor.ItemsTreeClick(Sender: TObject);
begin

  if ItemsTree.Selected<>nil then
  begin
    Designer.SelectComponent(TSkinItem(ItemsTree.Selected.Data));
    SyncTree;
    UpdateStates;
  end;

end;

//procedure TfrmSkinItemsPropertyEditor.ItemsTreeDragChange(SourceItem,
//  DestItem: TTreeNode; var Allow: Boolean);
//var
//  i: integer;
//begin
////  Allow := btnAddChild.Visible;
//
////  if Assigned(DestItem) and not (SourceItem.IsChild(TSkinItem(DestItem)))
////      and AcceptsChildItem(DestItem.Data) then
////  begin
////    TSkinItem(SourceItem.Data).Parent := TSkinItem(DestItem.Data);
////  end
////  else
////  begin
////    if DestItem = nil then
////      if not (TSkinItem(SourceItem).Parent is TScrollContent) then
////          TSkinItem(SourceItem.Data).Parent:= FContainer.GetObject
////      else
////      begin
////        for i := 1 to ItemsTree.Count - SourceItem.Index - 1  do
////        begin
////          TSkinItem(SourceItem).Index:= TSkinItem(SourceItem).Index + 1;
////          TSkinItem(SourceItem.Data).Index:= TSkinItem(SourceItem.Data).Index  + 1;
////        end;
////      end
////    else
////      //changing the order of the THeaderItems/ TListBoxItem/ TTabItem; dragged item will be moved before/after DestItem
////      if not AcceptsChildItem(DestItem.Data) then
////      begin
////        if DestItem.Index > SourceItem.Index then
////          for i := 1 to DestItem.Index - SourceItem.Index  do
////          begin
////            TSkinItem(SourceItem).Index:= TSkinItem(SourceItem).Index + 1;
////            TSkinItem(SourceItem.Data).Index:= TSkinItem(SourceItem.Data).Index  + 1;
////          end
////        else
////          for i := 1 to SourceItem.Index - DestItem.Index  do
////          begin
////            TSkinItem(SourceItem).Index:= TSkinItem(SourceItem).Index - 1;
////            TSkinItem(SourceItem.Data).Index:= TSkinItem(SourceItem.Data).Index  - 1;
////          end
////      end;
////  end;
//
//
////  UpdateStates;
////  RealignItems;
//end;

procedure TfrmSkinItemsPropertyEditor.RealignItems;
//var
//  AlignRoot: IAlignRoot;
begin
//  if FContainer.GetObject.GetInterface(IAlignRoot, IInterface(AlignRoot)) then
//  begin
//    AlignRoot.Realign;
//    AlignRoot := nil;
//  end;
  Designer.SelectComponent(TSkinItem(ItemsTree.Selected.Data));
end;

procedure TfrmSkinItemsPropertyEditor.UpdateStates;
begin
  btnUp.Enabled := (ItemsTree.Selected <> nil) and (ItemsTree.Selected.Index > 0);
  btnDown.Enabled := (ItemsTree.Selected <> nil) //and (ItemsTree.Selected.Parent <> nil)
           and (ItemsTree.Selected.Index < ItemsTree.Items.Count - 1);
  btnDelete.Enabled := ItemsTree.Selected <> nil;
  btnAddChild.Enabled := ItemsTree.Selected <> nil;
end;

procedure TfrmSkinItemsPropertyEditor.UpdateTree;

 procedure UpdateItem(AItems:TBaseSkinItems; AParentNode: TTreeNode);
  var
    Node: TTreeNode;
//    ChildContainer: IItemsContainer;
    IsItem: Boolean;
    i, j: integer;
  begin
    for i := 0 to AItems.Count - 1 do
    begin
      IsItem := false;
      for j := 0 to High(FItemsDescription) do
      begin
        if (AItems[I] is FItemsDescription[j].ItemClass) and (AItems[I].Owner <> nil)
        then
        begin
          IsItem := true;
          Break;
        end
        else
        begin
          ShowMessage('Not ItemClass'+AItems[I].ClassName);
        end;
      end;

      if not IsItem then Continue;


      Node:=ItemsTree.Items.Add(nil,'');
//      Node := TTreeNode.Create(nil);
//      Node.Parent := AParentNode;
//      if GetPropInfo(AItems[I], 'Caption') <> nil then
//        Node.Text := GetStrProp(AItems[I], 'Caption');
//      if Node.Text = '' then
//        Node.Text := AItems.GetItem(i).Name;
//      if Node.Text = '' then
//        Node.Text := 'Œ¥√¸¡Ó';
      Node.Data := AItems[I];

      if Node.Data<>nil then
      begin
        if TSkinItem(Node.Data).ItemType=sitSpace then
        begin
          Node.Text :='----------';
        end
        else
        begin
          Node.Text :=TSkinItem(Node.Data).Caption;
        end;

        if Node.Text = '' then
        begin
          Node.Text := 'Œ¥√¸¡Ó';
        end;
      end;

//      if Supports(AItems.GetItem(i), IItemsContainer, ChildContainer) then
//        UpdateItem(ChildContainer, Node);
    end;
  end;

begin
  if FItems = nil then Exit;
  ItemsTree.Items.Clear;
  UpdateItem(FItems, nil);
  UpdateStates;
end;

{ TItemClassDesc }

constructor TItemClassDesc.Create(const AItemClass: TBaseSkinItemClass;
  const ACanContaineSimilarItem: Boolean;
  const AShowOnlyInMenu: Boolean);
begin
  Self.ItemClass := AItemClass;
  Self.CanContainSimilarItem := ACanContaineSimilarItem;
  Self.ShowOnlyInMenu := AShowOnlyInMenu;
end;

initialization

finalization

//  if Assigned(DesignItemsForm) then
//    DesignItemsForm.Free;

  if Assigned(Watcher) then
    Watcher.Free;



end.

