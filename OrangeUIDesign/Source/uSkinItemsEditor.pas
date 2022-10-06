//convert pas to utf8 by ¥

unit uSkinItemsEditor;

interface
{$I FrameWork.inc}
{$I Version.inc}

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
//  //创建顶目
//  EDITOR_CREATE_ITEM = 1;
//  //选择默认列表项样式
//  EDITOR_SELECT_DEFAULT_ITEM_STYLE = 2;
  //打开图表序列设计器
  EDITOR_OPEN_CHART_SERIES_LIST_DESIGNER = 1;
  //打开图表第一个序列的数据项设计器
  EDITOR_OPEN_CHART_FIRST_SERIES_DATAITEM_DESIGNER = 2;
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



  //图片控件编译器
  TVirtualChartEditor = class(TSkinControlComponentEditor)
  protected
    FAllowChild: Boolean;
    FItemsClasses: array of TItemClassDesc;
//    procedure DoCreateItem(Sender: TObject); virtual;
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
//    procedure PrepareItem(Index: Integer; const AItem: IMenuItem); override;
    procedure Edit; override;
  end;




  //列表项编译器
  TSkinItemsProperty = class(TPropertyEditor)
  protected
    FAllowChild: Boolean;
    FItemsClasses: array of TItemClassDesc;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;




  TVirtualChartSeriesDataItemsProperty = class(TSkinItemsProperty)
  public
    constructor Create(const ADesigner: IDesigner; APropCount: Integer); override;
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
  uSkinVirtualChartType,


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
  RegisterPropertyEditor(TypeInfo(TVirtualChartSeriesDataItems),
                          //父属性
                          TVirtualChartSeries,
                          //属性名称
                          'DataItems',
                          TVirtualChartSeriesDataItemsProperty);
  RegisterComponentEditor(TSkinVirtualChart,TVirtualChartEditor);


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



//  if (Index-(Inherited GetVerbCount)) = EDITOR_CREATE_ITEM then
//  begin
//      if Supports(Component, ISkinItems, SkinItemsIntf) then
//      begin
//        Item := FItemsClasses[0].ItemClass.Create;//(SkinItemsIntf.Items);
//        SkinItemsIntf.Items.Add(Item);
//        Designer.SelectComponent(Item);
//      end;
//  end;


//  if (Index-(Inherited GetVerbCount)) = EDITOR_SELECT_DEFAULT_ITEM_STYLE then
//  begin
//    //选择默认列表项样式
//
//
//  end;


end;

function TItemsEditor.GetVerb(Index: Integer): string;
begin
  Result:=Inherited GetVerb(Index);

  case Index-(Inherited GetVerbCount) of
//    EDITOR_CREATE_ITEM:
//    begin
//      //新建一个列表项
//      Result := Langs_NewItem[LangKind];
//    end;
    EDITOR_OPEN_DESIGNER:
    begin
      //打开列表项编辑器
      Result := Langs_ItemsEditor[LangKind];
    end;
//    EDITOR_SELECT_DEFAULT_ITEM_STYLE:
//    begin
//      //选择默认列表项样式
//      Result := Langs_SelectDefaultItemStyle[LangKind];
//    end;
  end;
end;

function TItemsEditor.GetVerbCount: Integer;
begin
  Result := 1 + (Inherited GetVerbCount);
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




{ TVirtualChartEditor }

//procedure TVirtualChartEditor.DoCreateItem(Sender: TObject);
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

constructor TVirtualChartEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited;

  FAllowChild := False;
  SetLength(FItemsClasses, 1);
  FItemsClasses[0] := TItemClassDesc.Create(TSkinListBoxItem);

end;

procedure TVirtualChartEditor.Edit;
begin
  ExecuteVerb((Inherited GetVerbCount));
end;

procedure TVirtualChartEditor.ExecuteVerb(Index: Integer);
var
//  SkinItemsIntf:ISkinItems;
  Item: TBaseSkinItem;
  AItemsClasses: array of TItemClassDesc;
begin
  inherited ExecuteVerb(Index);



  if (Index-(Inherited GetVerbCount)) = EDITOR_OPEN_DESIGNER then
  begin

      //打开坐标刻度列表项编辑器
      if Assigned(frmSkinItemsPropertyEditor) then
      begin
        FreeAndNil(frmSkinItemsPropertyEditor);
      end;


      frmSkinItemsPropertyEditor := TfrmSkinItemsPropertyEditor.Create(nil);
      frmSkinItemsPropertyEditor.Caption := Langs_ChartAxisItemsEditor[LangKind];

      frmSkinItemsPropertyEditor.btnAddChild.Visible := FAllowChild;
      frmSkinItemsPropertyEditor.Designer := Designer;
      frmSkinItemsPropertyEditor.SetItemClasses(TSkinVirtualChart(Component).Prop.AxisItems, FItemsClasses);
      frmSkinItemsPropertyEditor.Show;

  end;


  if (Index-(Inherited GetVerbCount)) = EDITOR_OPEN_CHART_SERIES_LIST_DESIGNER then
  begin
      ShowCollectionEditor(Designer,
                            TSkinVirtualChart(Component),
                            TSkinVirtualChart(Component).Prop.SeriesList,
                            'SeriesList');

  end;


  if (Index-(Inherited GetVerbCount)) = EDITOR_OPEN_CHART_FIRST_SERIES_DATAITEM_DESIGNER then
  begin

      if Assigned(frmSkinItemsPropertyEditor) then
      begin
        FreeAndNil(frmSkinItemsPropertyEditor);
      end;

      if TSkinVirtualChart(Component).Prop.SeriesList.Count>0 then
      begin
        SetLength(AItemsClasses, 1);
        AItemsClasses[0] := TItemClassDesc.Create(TVirtualChartSeriesDataItem);

        frmSkinItemsPropertyEditor := TfrmSkinItemsPropertyEditor.Create(nil);
        frmSkinItemsPropertyEditor.Caption := Langs_ChartFirstSeriesDataItemsEditor[LangKind];

        frmSkinItemsPropertyEditor.btnAddChild.Visible := FAllowChild;
        frmSkinItemsPropertyEditor.Designer := Designer;
        frmSkinItemsPropertyEditor.SetItemClasses(TSkinVirtualChart(Component).Prop.SeriesList[0].DataItems, AItemsClasses);
        frmSkinItemsPropertyEditor.Show;

      end;

  end;


//  if (Index-(Inherited GetVerbCount)) = EDITOR_CREATE_ITEM then
//  begin
////      if Supports(Component, ISkinItems, SkinItemsIntf) then
//      begin
//        Item := FItemsClasses[0].ItemClass.Create;//(SkinItemsIntf.Items);
////        SkinItemsIntf.Items.Add(Item);
//        TSkinVirtualChart(Component).Prop.XAxisItems.Add(Item);
//        Designer.SelectComponent(Item);
//      end;
//  end;
//
//
//  if (Index-(Inherited GetVerbCount)) = EDITOR_SELECT_DEFAULT_ITEM_STYLE then
//  begin
//    //选择默认列表项样式
//
//
//  end;


end;

function TVirtualChartEditor.GetVerb(Index: Integer): string;
begin
  Result:=Inherited GetVerb(Index);

  case Index-(Inherited GetVerbCount) of
//    EDITOR_CREATE_ITEM:
//    begin
//      //新建一个坐标刻度列表项
//      Result := Langs_NewChartAxisItem[LangKind];
//    end;
    EDITOR_OPEN_DESIGNER:
    begin
      //打开坐标刻度列表项编辑器
      Result := Langs_ChartAxisItemsEditor[LangKind];
    end;
    EDITOR_OPEN_CHART_SERIES_LIST_DESIGNER:
    begin
      //坐标序列列表编辑器
      Result := Langs_ChartSeriesListEditor[LangKind];
    end;
    EDITOR_OPEN_CHART_FIRST_SERIES_DATAITEM_DESIGNER:
    begin
      //坐标第一个序列的数据列表编辑器
      Result := Langs_ChartFirstSeriesDataItemsEditor[LangKind];
    end;
  end;
end;

function TVirtualChartEditor.GetVerbCount: Integer;
begin
  Result := 3 + (Inherited GetVerbCount);
end;

//procedure TVirtualChartEditor.PrepareItem(Index: Integer; const AItem: IMenuItem);
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

{ TSkinItemsProperty }


procedure TSkinItemsProperty.Edit;
//var
//  ASkinPictureList:TSkinPictureList;
//  PictureEditor: TSkinPictureListEditorPopupForm;
begin

      frmSkinItemsPropertyEditor := TfrmSkinItemsPropertyEditor.Create(nil);
//      if Supports(Component, ISkinItems, SkinItemsIntf) then
//      begin

        frmSkinItemsPropertyEditor.btnAddChild.Visible := FAllowChild;
        frmSkinItemsPropertyEditor.Designer := Designer;
        frmSkinItemsPropertyEditor.SetItemClasses(TSkinItems(Pointer(GetOrdValue)), FItemsClasses);
        frmSkinItemsPropertyEditor.Show;

//  PictureEditor := TSkinPictureListEditorPopupForm.Create(nil);
//  try
//    ASkinPictureList:=TSkinPictureList(Pointer(GetOrdValue));
//    PictureEditor.FPicDlg.PictureList:=ASkinPictureList;
//    if PictureEditor.Execute then
//    begin
//      SetOrdValue(Longint(PictureEditor.FPicDlg.PictureList));
//    end;
//  finally
//    PictureEditor.Free;
//  end;
end;

function TSkinItemsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TSkinItemsProperty.GetValue: string;
var
  ASkinItems: TSkinItems;
begin
  ASkinItems := TSkinItems(GetOrdValue);
  Result:=Format(Langs_SkinItemsCount[LangKind],[ASkinItems.Count]);
end;

procedure TSkinItemsProperty.SetValue(const Value: string);
begin
  if Value = '' then
  begin
    SetOrdValue(0);
  end;
end;



{ TVirtualChartSeriesDataItemsProperty }

{ TVirtualChartSeriesDataItemsProperty }

constructor TVirtualChartSeriesDataItemsProperty.Create(
  const ADesigner: IDesigner; APropCount: Integer);
begin
  inherited;

  FAllowChild := False;
  SetLength(FItemsClasses, 1);
  FItemsClasses[0] := TItemClassDesc.Create(TVirtualChartSeriesDataItem);


end;

end.
