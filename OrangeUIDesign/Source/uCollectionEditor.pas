//convert pas to utf8 by ¥

unit uCollectionEditor;

interface
{$I FrameWork.inc}
{$I Version.inc}

uses
  Classes,


  {$IFDEF VCL}
  VCL.Dialogs,
  {$ENDIF}

  {$IFDEF FMX}
  FMX.Forms,
  FMX.Dialogs,
  FMX.Types,
  {$ENDIF}

  ColnEdit,
  DesignEditors,
  DesignMenus,
  DesignIntf,

  uLanguage,
  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
  uSkinDBGridType,
  uSkinVirtualGridType,
  {$ENDIF}
  uSkinItemDesignerPanelType,
  uSkinMultiColorLabelType,
  uComponentTypeNameEditor,
  uDrawPathParam,
  uSkinItems;


type
  //表格列编辑器
  TSkinVirtualGridColumnsProperty = class(TCollectionProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;




  //双击DBGrid可以编辑列
  TSkinDBGridEditor = class(TDefaultEditor)
  public
    procedure Edit; override;
  end;

  //DBGrid的表格列中的FieldName属性
  TSkinDBGridFieldNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;





  //路径,用于CheckBox的勾选素材
  TPathActionCollectionProperty = class(TCollectionProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;



  //多彩文本,用于MultiColorLabel
  TColorTextsProperty = class(TCollectionProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;


  //多彩文本
  TSkinMultiColorLabelEditor = class(TSkinControlComponentEditor)
  public
    procedure Edit; override;
  end;



  //图表序列,用于VirtualChart
  TVirtualChartSeriesListProperty = class(TCollectionProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;




procedure Register;


implementation

uses
  TypInfo,
  {$IFDEF FMX}
    {$IFDEF OPENSOURCE_VERSION}
    {$ELSE}
      uSkinFireMonkeyDBGrid,
    {$ENDIF}
    uSkinFireMonkeyMultiColorLabel,
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}

  uSkinVirtualChartType,
  SysUtils
  ;


procedure Register;
begin
  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
  RegisterPropertyEditor(TypeInfo(TSkinVirtualGridColumns),
                          TVirtualGridProperties,
                          'Columns',
                          TSkinVirtualGridColumnsProperty);

  RegisterPropertyEditor(TypeInfo(String),
                          TSkinDBGridColumn,
                          'FieldName',
                          TSkinDBGridFieldNameProperty);
  {$ENDIF}


  RegisterPropertyEditor(TypeInfo(TPathActionCollection),
                          TDrawPathParam,
                          'PathActions',
                          TPathActionCollectionProperty);

  RegisterPropertyEditor(TypeInfo(TColorTexts),
                          TMultiColorLabelProperties,
                          'ColorTextCollection',
                          TColorTextsProperty);

  RegisterPropertyEditor(TypeInfo(TVirtualChartSeriesList),
                          //父属性
                          TVirtualChartProperties,
                          //属性名称
                          'SeriesList',
                          TVirtualChartSeriesListProperty);

  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
    {$IFDEF FMX}
    RegisterComponentEditor(TSkinFMXDBGrid,TSkinDBGridEditor);
    RegisterComponentEditor(TSkinFMXMultiColorLabel,TSkinMultiColorLabelEditor);
    {$ENDIF}
    {$IFDEF VCL}
    RegisterComponentEditor(TSkinWinDBGrid,TSkinDBGridEditor);
    {$ENDIF}
  {$ENDIF}
end;



{ TSkinVirtualGridColumnsProperty }

procedure TSkinVirtualGridColumnsProperty.Edit;
begin
  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
  ShowCollectionEditor(Designer,
                      TComponent(TSkinVirtualGridColumns(GetOrdValue).FVirtualGridProperties.SkinControl),
                      TSkinVirtualGridColumns(GetOrdValue),
                      GetName);
  {$ENDIF}
end;

function TSkinVirtualGridColumnsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly{$IFDEF LINUX}, paVCL{$ENDIF}];
end;

{ TPathActionCollectionProperty }

procedure TPathActionCollectionProperty.Edit;
begin
  ShowCollectionEditor(Designer,
                      TComponent(TPathActionCollection(GetOrdValue).FDrawPathParam.SkinMaterial),
                      TPathActionCollection(GetOrdValue),
                      GetName);
end;

function TPathActionCollectionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly{$IFDEF LINUX}, paVCL{$ENDIF}];
end;

{ TColorTextsProperty }

procedure TColorTextsProperty.Edit;
begin
  ShowCollectionEditor(Designer,
                        TComponent(TColorTexts(GetOrdValue).Properties.SkinControl),
                        TColorTexts(GetOrdValue),
                        GetName);
end;

function TColorTextsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly{$IFDEF LINUX}, paVCL{$ENDIF}];
end;


{ TSkinDBGridEditor }

procedure TSkinDBGridEditor.Edit;
begin
  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
    {$IFDEF FMX}
    ShowCollectionEditor(Designer,
                        Self.Component,
                        TSkinFMXDBGrid(Component).Properties.Columns,
                        'Columns');
    {$ENDIF}

    {$IFDEF VCL}
    ShowCollectionEditor(Designer,
                        Self.Component,
                        TSkinWinDBGrid(Component).Properties.Columns,
                        'Columns');
    {$ENDIF}
  {$ENDIF}
end;

{ TSkinMultiColorLabelEditor }

procedure TSkinMultiColorLabelEditor.Edit;
begin
  {$IFDEF FMX}
  ShowCollectionEditor(Designer,
                      Self.Component,
                      TSkinFMXMultiColorLabel(Component).Properties.ColorTextCollection,
                      'ColorTextCollection');
  {$ENDIF}

  {$IFDEF VCL}
  ShowCollectionEditor(Designer,
                      Self.Component,
                      TSkinWinMultiColorLabel(Component).Properties.ColorTextCollection,
                      'ColorTextCollection');
  {$ENDIF}

end;

{ TSkinDBGridFieldNameProperty }

function TSkinDBGridFieldNameProperty.GetAttributes: TPropertyAttributes;
begin
  //值列表
  Result := [paValueList];
end;

procedure TSkinDBGridFieldNameProperty.GetValues(Proc: TGetStrProc);
var
  List: IDesignerSelections;
  I: Integer;
  {$IFDEF OPENSOURCE_VERSION}
  {$ELSE}
  AColumn:TSkinDBGridColumn;
  AProperties:TDBGridProperties;
  {$ENDIF}
begin
  //把每个控件类型的可以ComponentType列出来
  //皮肤组件接口

  List := CreateSelectionList;
  if Designer<>nil then
  begin
    Designer.GetSelections(List);
  end;
  if (List.Count = 0) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;
  if (List.Count > 1) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;


  {$IFDEF OPENSOURCE_VERSION}
    inherited GetValues(Proc);
  {$ELSE}
  if List[0] is TSkinDBGridColumn then
  begin
    AColumn:=TSkinDBGridColumn(List[0]);
    if AColumn.Owner<>nil then
    begin
      AProperties:=TDBGridProperties(AColumn.Owner.FVirtualGridProperties);
      if (AProperties.DataSource<>nil)
        and (AProperties.DataSource.DataSet.Active)
        and (AProperties.DataSource.DataSet<>nil) then
      begin
        for I := 0 to AProperties.DataSource.DataSet.FieldDefList.Count-1 do
        begin
          Proc(AProperties.DataSource.DataSet.FieldDefList[I].Name);
        end;
      end;
    end;
  end
  else
  begin
    inherited GetValues(Proc);
  end;
  {$ENDIF}


end;

{ TVirtualChartSeriesListProperty }

procedure TVirtualChartSeriesListProperty.Edit;
begin
  ShowCollectionEditor(Designer,
                        TComponent(TVirtualChartSeriesList(GetOrdValue).FSkinVirtualChartIntf.Properties.SkinControl),
                        TVirtualChartSeriesList(GetOrdValue),
                        GetName);
end;

function TVirtualChartSeriesListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly{$IFDEF LINUX}, paVCL{$ENDIF}];
end;

end.
