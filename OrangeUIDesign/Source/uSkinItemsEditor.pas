//convert pas to utf8 by ¥

unit uSkinItemsEditor;

interface
{$I FrameWork.inc}

uses
  Classes,
//  VCL.Menus,


//  {$IFDEF VCL}
//  Dialogs,
//  VCL_SkinItemsPropertyeditorForm,
//  {$ENDIF}

  {$IF CompilerVersion >= 30.0}
//    {$IFDEF FMX}
        FMX.Forms,
        FMX.Dialogs,
        FMX_XE_SkinItemsPropertyeditorForm,
        FMX.Types,
        uSkinItemJsonHelper,
//    {$ELSE}
//    Dialogs,
//    VCL_SkinItemsPropertyeditorForm,
//    {$ENDIF}
  {$ELSE}
    Dialogs,
    VCL_SkinItemsPropertyeditorForm,
  {$IFEND}

  ColnEdit,
  DesignEditors,
  DesignMenus,
  DesignIntf,


  uLang,
  uLanguage,
  uComponentTypeNameEditor,
  uSkinItems
  ;


const
  //打开设计器
  EDITOR_OPEN_DESIGNER = 0;
  //创建顶目
  EDITOR_CREATE_ITEM = 1;
const
  //表格列
  EDITOR_OPEN_COLUMN_DESIGNER = 0;


type
  TItemsEditor = class(TSkinControlComponentEditor)
  protected
    FAllowChild: Boolean;
    FItemsClasses: array of TItemClassDesc;
//    procedure DoCreateItem(Sender: TObject); virtual;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
//    procedure PrepareItem(Index: Integer; const AItem: IMenuItem); override;
    procedure Edit; override;
  end;


  TCustomListEditor = class(TItemsEditor)
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

  TVirtualListEditor = class(TItemsEditor)
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

  TListBoxEditor = class(TItemsEditor)
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

  TListViewEditor = class(TItemsEditor)
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

  TTreeViewEditor = class(TItemsEditor)
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

  TVirtualGridEditor = class(TItemsEditor)
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TItemGridEditor = class(TVirtualGridEditor)
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

  TDBGridEditor = class(TDefaultEditor)
  public
    procedure Edit;override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;


  TCustomListSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;





procedure Register;

implementation

uses
  TypInfo,
  SysUtils,
  {$IFDEF FMX}
    uSkinFireMonkeyCustomList,
    uSkinFireMonkeyVirtualList,
    uSkinFireMonkeyListBox,
    {$IFDEF OPENSOURCE_VERSION}
    //开源版没有ListView,TreeView,Grid
    {$ELSE}
    uSkinFireMonkeyListView,
    uSkinFireMonkeyTreeView,
    uSkinFireMonkeyVirtualGrid,
    uSkinFireMonkeyItemGrid,
    uSkinFireMonkeyDBGrid,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
//  uSkinWindowsVirtualList,
//  uSkinWindowsListBox,
//  uSkinWindowsListView,
//  uSkinWindowsTreeView,
  {$ENDIF}
  uSkinVirtualListType,


  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  uSkinVirtualGridType,
  uSkinListViewType,
  uSkinTreeViewType,
//  uSkinVirtualGridType,
  uSkinItemGridType,
  {$ENDIF}


  uSkinListBoxType;


procedure Register;
begin
  {$IFDEF FMX}
    RegisterComponentEditor(TSkinFMXCustomList,TCustomListEditor);
    RegisterComponentEditor(TSkinFMXVirtualList,TVirtualListEditor);
    RegisterComponentEditor(TSkinFMXListBox,TListBoxEditor);


    {$IFDEF OPENSOURCE_VERSION}
    //开源版没有ListView,TreeView,Grid
    {$ELSE}
    RegisterComponentEditor(TSkinFMXListView,TListViewEditor);
    RegisterComponentEditor(TSkinFMXTreeView,TTreeViewEditor);
    RegisterComponentEditor(TSkinTreeView,TTreeViewEditor);
    RegisterComponentEditor(TSkinFMXVirtualGrid,TVirtualGridEditor);
    RegisterComponentEditor(TSkinFMXItemGrid,TItemGridEditor);
    RegisterComponentEditor(TSkinFMXDBGrid,TDBGridEditor);
    {$ENDIF}


    RegisterSelectionEditor(TSkinFMXVirtualList,TCustomListSelectionEditor);
    RegisterSelectionEditor(TSkinFMXListBox,TCustomListSelectionEditor);


    {$IFDEF OPENSOURCE_VERSION}
    //开源版没有ListView,TreeView,Grid
    {$ELSE}
    RegisterSelectionEditor(TSkinFMXListView,TCustomListSelectionEditor);
    RegisterSelectionEditor(TSkinFMXTreeView,TCustomListSelectionEditor);
    RegisterSelectionEditor(TSkinTreeView,TCustomListSelectionEditor);
    RegisterSelectionEditor(TSkinFMXVirtualGrid,TCustomListSelectionEditor);
    RegisterSelectionEditor(TSkinFMXItemGrid,TCustomListSelectionEditor);
    RegisterSelectionEditor(TSkinFMXDBGrid,TCustomListSelectionEditor);
    {$ENDIF}
  {$ENDIF}

  {$IFDEF VCL}
  //  RegisterComponentEditor(TSkinWinCustomList,TCustomListEditor);
    RegisterComponentEditor(TSkinWinVirtualList,TVirtualListEditor);
    RegisterComponentEditor(TSkinWinListBox,TListBoxEditor);
    {$IFDEF OPENSOURCE_VERSION}
    //开源版没有ListView,TreeView,Grid
    {$ELSE}
      RegisterComponentEditor(TSkinWinListView,TListViewEditor);
      RegisterComponentEditor(TSkinWinTreeView,TTreeViewEditor);
      RegisterComponentEditor(TSkinTreeView,TTreeViewEditor);
      RegisterComponentEditor(TSkinWinVirtualGrid,TVirtualGridEditor);
      RegisterComponentEditor(TSkinWinItemGrid,TItemGridEditor);
    //  RegisterComponentEditor(TSkinWinDBGrid,TDBGridEditor);
    {$ENDIF}


    RegisterSelectionEditor(TSkinWinVirtualList,TCustomListSelectionEditor);
    RegisterSelectionEditor(TSkinWinListBox,TCustomListSelectionEditor);
    {$IFDEF OPENSOURCE_VERSION}
    //开源版没有ListView,TreeView,Grid
    {$ELSE}
      RegisterSelectionEditor(TSkinWinListView,TCustomListSelectionEditor);
      RegisterSelectionEditor(TSkinWinTreeView,TCustomListSelectionEditor);
      RegisterSelectionEditor(TSkinTreeView,TCustomListSelectionEditor);
      RegisterSelectionEditor(TSkinWinVirtualGrid,TCustomListSelectionEditor);
      RegisterSelectionEditor(TSkinWinItemGrid,TCustomListSelectionEditor);
    //  RegisterSelectionEditor(TSkinWinDBGrid,TCustomListSelectionEditor);
    {$ENDIF}
  {$ENDIF}


//  {$IFDEF VCL}
//  RegisterComponentEditor(TSkinWinVirtualList,TVirtualListEditor);
//  RegisterComponentEditor(TSkinWinListBox,TListBoxEditor);
//  RegisterComponentEditor(TSkinWinListView,TListViewEditor);
//  RegisterComponentEditor(TSkinWinTreeView,TTreeViewEditor);
//  RegisterComponentEditor(TSkinWinVirtualGrid,TVirtualGridEditor);
////  RegisterComponentEditor(TSkinWinItemGrid,TItemGridEditor);
//
//
//  RegisterSelectionEditor(TSkinWinVirtualList,TCustomListSelectionEditor);
//  RegisterSelectionEditor(TSkinWinListBox,TCustomListSelectionEditor);
//  RegisterSelectionEditor(TSkinWinListView,TCustomListSelectionEditor);
//  RegisterSelectionEditor(TSkinWinTreeView,TCustomListSelectionEditor);
//  RegisterSelectionEditor(TSkinWinVirtualGrid,TCustomListSelectionEditor);
////  RegisterSelectionEditor(TSkinWinItemGrid,TCustomListSelectionEditor);
//  {$ENDIF}



end;


{ TItemsEditor }

//procedure TItemsEditor.DoCreateItem(Sender: TObject);
//var
//  MenuItem: VCL.Menus.TMenuItem;
//  Item: TBaseSkinItem;
//  IndexOfItemClass: Integer;
//  SkinItemsIntf:ISkinItems;
//begin
//  if Sender is VCL.Menus.TMenuItem then
//  begin
//    MenuItem := Sender as VCL.Menus.TMenuItem;
//
//    if Supports(Component, ISkinItems, SkinItemsIntf) then
//    begin
//        IndexOfItemClass := MenuItem.Tag;
//
//        Item := FItemsClasses[IndexOfItemClass].ItemClass.Create(SkinItemsIntf.Items);
//        SkinItemsIntf.Items.Add(Item);
//        Designer.SelectComponent(Item);
//    end;
//  end;
//end;

procedure TItemsEditor.Edit;
begin
  ExecuteVerb((Inherited GetVerbCount));
end;

procedure TItemsEditor.ExecuteVerb(Index: Integer);
var
  SkinItemsIntf:ISkinItems;
  Item: TBaseSkinItem;
begin
  inherited ExecuteVerb(Index);



  if (Index-(Inherited GetVerbCount)) = EDITOR_OPEN_DESIGNER then
  begin

      if Assigned(frmSkinItemsPropertyEditor) then
      begin
        FreeAndNil(frmSkinItemsPropertyEditor);
      end;


      frmSkinItemsPropertyEditor := TfrmSkinItemsPropertyEditor.Create(nil);
      if Supports(Component, ISkinItems, SkinItemsIntf) then
      begin

        frmSkinItemsPropertyEditor.btnAddChild.Visible := FAllowChild;
        frmSkinItemsPropertyEditor.Designer := Designer;
        frmSkinItemsPropertyEditor.SetItemClasses(SkinItemsIntf.Items, FItemsClasses);
        frmSkinItemsPropertyEditor.Show;

      end
      else
      begin
        ShowMessage('Not Support ISkinItems interface');
      end;

  end;



  if (Index-(Inherited GetVerbCount)) = EDITOR_CREATE_ITEM then
  begin
      if Supports(Component, ISkinItems, SkinItemsIntf) then
      begin
        Item := FItemsClasses[0].ItemClass.Create;//(SkinItemsIntf.Items);
        SkinItemsIntf.Items.Add(Item);
        Designer.SelectComponent(Item);
      end;
  end;


end;

function TItemsEditor.GetVerb(Index: Integer): string;
begin
  Result:=Inherited GetVerb(Index);

  case Index-(Inherited GetVerbCount) of
    EDITOR_CREATE_ITEM:
    begin
      //新建一个列表项
      Result := Langs_NewItem[LangKind];
    end;
    EDITOR_OPEN_DESIGNER:
    begin
      //打开列表项编辑器
      Result := Langs_ItemsEditor[LangKind];
    end;
  end;
end;

function TItemsEditor.GetVerbCount: Integer;
begin
  Result := 2 + (Inherited GetVerbCount);
end;

//procedure TItemsEditor.PrepareItem(Index: Integer; const AItem: IMenuItem);
//var
//  I: Integer;
//  MenuItem: IMenuItem;
//begin
//  inherited PrepareItem(Index, AItem);
//
//  //添加子菜单
//  if (Index-(Inherited GetVerbCount)) = EDITOR_CREATE_ITEM then
//  begin
//    for I := 0 to High(FItemsClasses) do
//    begin
//      MenuItem := AItem.AddItem(FItemsClasses[I].ItemClass.ClassName,
//                                0,
//                                False,
//                                True,
//                                DoCreateItem);
//      MenuItem := nil;
//    end;
//  end;
//
//end;

{ TCustomListEditor }

constructor TCustomListEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);

  FAllowChild := False;
  SetLength(FItemsClasses, 1);
  FItemsClasses[0] := TItemClassDesc.Create(TBaseSkinItem);
end;

{ TVirtualListEditor }

constructor TVirtualListEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);

  FAllowChild := False;
  SetLength(FItemsClasses, 1);
  FItemsClasses[0] := TItemClassDesc.Create(TSkinItem);
end;

{ TListBoxEditor }

constructor TListBoxEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);

  FAllowChild := False;
  SetLength(FItemsClasses, 2);
  FItemsClasses[0] := TItemClassDesc.Create(TSkinListBoxItem);
  FItemsClasses[1] := TItemClassDesc.Create({$IF CompilerVersion >= 30.0}TJsonSkinItem{$ELSE}TSkinListBoxItem{$IFEND});
end;

{ TListViewEditor }

constructor TListViewEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);

  FAllowChild := False;
  SetLength(FItemsClasses, 2);
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  FItemsClasses[0] := TItemClassDesc.Create(TSkinListViewItem);
  FItemsClasses[1] := TItemClassDesc.Create({$IF CompilerVersion >= 30.0}TJsonSkinItem{$ELSE}TSkinListBoxItem{$IFEND});
  {$ENDIF}
end;

{ TTreeViewEditor }

constructor TTreeViewEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);
  FAllowChild := true;
  SetLength(FItemsClasses, 1);
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  FItemsClasses[0] := TItemClassDesc.Create(TSkinTreeViewItem);
//  FItemsClasses[1] := TItemClassDesc.Create(TSkinTreeViewItem);
  {$ENDIF}
end;

{ TItemGridEditor }

constructor TItemGridEditor.Create(AComponent: TComponent; ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);
  FAllowChild := False;
  SetLength(FItemsClasses, 1);
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  FItemsClasses[0] := TItemClassDesc.Create(TSkinItemGridRow);
//  FItemsClasses[1] := TItemClassDesc.Create(TSkinJsonItemGridRow);
  {$ENDIF}
end;

{ TVirtualGridEditor }

constructor TVirtualGridEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited Create(AComponent, ADesigner);
  FAllowChild := False;
  SetLength(FItemsClasses, 1);
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  FItemsClasses[0] := TItemClassDesc.Create(TSkinVirtualGridRow);
//  FItemsClasses[1] := TItemClassDesc.Create(TSkinJsonItemGridRow);
  {$ENDIF}
end;


procedure TVirtualGridEditor.ExecuteVerb(Index: Integer);
begin
  inherited ExecuteVerb(Index);

  if (Index-(Inherited GetVerbCount)) = EDITOR_OPEN_COLUMN_DESIGNER then
  begin
    {$IFDEF OPENSOURCE_VERSION}
    //开源版没有ListView,TreeView,Grid
    {$ELSE}
    ShowCollectionEditor(Designer,
                          Self.Component,
                          TSkinVirtualGrid(Component).Prop.Columns,
                          '表格列');
    {$ENDIF}
  end;
end;

function TVirtualGridEditor.GetVerb(Index: Integer): string;
begin
  Result:=Inherited GetVerb(Index);

  case Index-(Inherited GetVerbCount) of
    EDITOR_OPEN_COLUMN_DESIGNER:
    begin
      //打开列编辑器
      Result := Langs_GridColumnsEditor[LangKind];
    end;
  end;
end;

function TVirtualGridEditor.GetVerbCount: Integer;
begin
  Result:=Inherited GetVerbCount+1;
end;

{ TDBGridEditor }

procedure TDBGridEditor.Edit;
begin
  ExecuteVerb(0);
end;

procedure TDBGridEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:
    begin
      {$IFDEF OPENSOURCE_VERSION}
      //开源版没有ListView,TreeView,Grid
      {$ELSE}
      ShowCollectionEditor(Designer,
                            Self.Component,
                            TSkinVirtualGrid(Component).Prop.Columns,
                            '表格列');
      {$ENDIF}
    end;

  end;
end;

function TDBGridEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    EDITOR_OPEN_COLUMN_DESIGNER:
    begin
      //打开列编辑器
      Result := Langs_GridColumnsEditor[LangKind];
    end;
  end;
end;

function TDBGridEditor.GetVerbCount: Integer;
begin
  Result:=1;
end;

{ TCustomListSelectionEditor }

procedure TCustomListSelectionEditor.RequiresUnits(Proc: TGetStrProc);
begin
//  Add needed used units to the uses clauses of the form where the component is located.
  Proc('uDrawCanvas');
  Proc('uSkinItems');

end;

end.
