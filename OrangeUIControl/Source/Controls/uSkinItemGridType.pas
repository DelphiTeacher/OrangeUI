//convert pas to utf8 by ¥
unit uSkinItemGridType;

interface
{$I FrameWork.inc}

{$I Version.inc}



uses
  Classes,
  SysUtils,
  Types,
  DateUtils,
  Math,
  Variants,
  DB,
  RTLConsts,
  DBConsts,

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


  uFuncCommon,
  uSkinAnimator,
  uBaseList,
  uBaseLog,
  uSkinItems,
  uSkinListLayouts,
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
  uSkinVirtualGridType,
  uSkinControlGestureManager,
  uSkinScrollControlType,
  uDrawPictureParam;


const
  IID_ISkinItemGrid:TGUID='{076173C7-BBA6-447A-91EB-657C78E0D8C8}';



type
  TItemGridProperties=class;
  TSkinItemGridColumnMaterial=class;


  ISkinItemGrid=interface
    ['{076173C7-BBA6-447A-91EB-657C78E0D8C8}']

    function GetItemGridProperties:TItemGridProperties;
    property Properties:TItemGridProperties read GetItemGridProperties;
    property Prop:TItemGridProperties read GetItemGridProperties;

  end;



  //列表项数据类型,
  //用于Grid中的列设置,显示什么数据
  //也用于列表项编辑,回写的时候写到Item的哪个属性中
  //不再使用,今后统一用FieldName了,ItemCaption,ItemDetail,ItemDetail1,ItemChecked等
  TSkinItemDataType=(
                  idtNone,
                  idtCaption,

                  idtIcon,
                  idtPic,

                  idtChecked,
                  idtSelected,
                  idtAccessory,

                  idtDetail,
                  idtDetail1,
                  idtDetail2,
                  idtDetail3,
                  idtDetail4,
                  idtDetail5,
                  idtDetail6,
                  idtSubItems,

                  idtExpanded
                  );



  //表格列(可以同时显示两个元素)
  TSkinItemGridColumn = class(TSkinVirtualGridColumn)
  private
//    //已弃用
//    //数据类型,显示Item的哪个属性
//    FItemDataType:TSkinItemDataType;
//    FSubItemsIndex: Integer;
//
//    FItemDataType1:TSkinItemDataType;
//    FSubItemsIndex1: Integer;
//
//    procedure SyncBindItemFieldName;
//
//    procedure SetItemDataType(const Value: TSkinItemDataType);
//    procedure SetItemDataType1(const Value: TSkinItemDataType);
//    procedure SetSubItemsIndex(const Value: Integer);
//    procedure SetSubItemsIndex1(const Value: Integer);

    function GetSelfOwnMaterial: TSkinItemGridColumnMaterial;
    procedure SetSelfOwnMaterial(const Value: TSkinItemGridColumnMaterial);
  private
    FBindItemFieldName:String;
    FBindItemFieldName1:String;

    procedure SetBindItemFieldName(const Value: String);
    procedure SetBindItemFieldName1(const Value: String);
    function GetBindItemFieldName: String;override;
    function GetBindItemFieldName1: String;override;
//    function GetContentTypes: TSkinGridColumnContentTypes;//override;
  protected
//    //获取表格列的内容类型(文本,勾选框,图片)
//    function GetContentTypes:TSkinGridColumnContentTypes;override;
    function GetValueType(ARow:TBaseSkinItem):TVarType;override;
    function GetValueType1(ARow:TBaseSkinItem):TVarType;override;
    //获取表格列的素材类型
    function GetColumnMaterialClass:TSkinVirtualGridColumnMaterialClass;override;
  public
    constructor Create(Collection: TCollection); override;
//  published
//    //已弃用
//    property ItemDataType:TSkinItemDataType read FItemDataType write SetItemDataType;// stored False;
//    property ItemDataType1:TSkinItemDataType read FItemDataType1 write SetItemDataType1;// stored False;
//
//    property SubItemsIndex:Integer read FSubItemsIndex write SetSubItemsIndex;// stored False;
//    property SubItemsIndex1:Integer read FSubItemsIndex1 write SetSubItemsIndex1;// stored False;

  published
    //绑定的字段
    property BindItemFieldName:String read GetBindItemFieldName write FBindItemFieldName;//SetBindItemFieldName;
    //绑定的字段1
    property BindItemFieldName1:String read GetBindItemFieldName1 write FBindItemFieldName1;//SetBindItemFieldName1;

    //自带素材
    property SelfOwnMaterial:TSkinItemGridColumnMaterial read GetSelfOwnMaterial write SetSelfOwnMaterial;
  end;

  TSkinItemGridColumns=class(TSkinVirtualGridColumns)
  private
    function GetItem(Index: Integer): TSkinItemGridColumn;
  public
    function Add:TSkinItemGridColumn;overload;
    function Find(ABindItemFieldName:String):TSkinItemGridColumn;
    property Items[Index:Integer]:TSkinItemGridColumn read GetItem;default;
  end;

  //表格列布局类型
  TSkinItemGridColumnLayoutsManager=TSkinVirtualGridColumnLayoutsManager;






  //表格数据行
  TSkinItemGridRow=class(TRealSkinItem)
  protected
    //表格列的总宽度
    function GetWidth: Double;override;
  end;


  //表格数据行列表
  TSkinItemGridRows=class(TSkinItems)
  public
    procedure DoAdd(AObject:TObject);override;
  public
    //添加数据行
    function Add:TSkinItemGridRow;overload;
    procedure EndUpdate(AIsForce:Boolean=False);override;
  public
//    //创建列表项
//    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
//    procedure InitSkinItemClass;override;
    function GetSkinItemClass:TBaseSkinItemClass;override;
  end;

  //表格数据行布局类型
  TSkinItemGridRowLayoutsManager=TSkinVirtualGridRowLayoutsManager;






  TItemGridProperties=class(TVirtualGridProperties)
  protected
    function GetItems: TSkinItemGridRows;
    procedure SetItems(const Value: TSkinItemGridRows);

    function GetColumns: TSkinItemGridColumns;
    procedure SetColumns(const Value: TSkinItemGridColumns);
  protected
    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
    //ListLayoutsManager传递出的列表项属性更改事件(重绘列表)
    procedure DoItemPropChange(Sender:TObject);override;
    //ListLayoutsManager传递出的列表项隐藏显示更改事件(需要重新计算内容尺寸,重绘列表)
    procedure DoItemVisibleChange(Sender:TObject);override;
  protected
    //获取表格数据行的列表类
    function GetItemsClass:TBaseSkinItemsClass;override;
    //获取表格数据行的列表布局管理者
    function GetCustomListLayoutsManagerClass:TSkinCustomListLayoutsManagerClass;override;
    //创建列管理
    function GetColumnClass:TSkinVirtualGridColumnClass;override;
    function GetColumnsClass:TSkinVirtualGridColumnsClass;override;

    //获取表格列排列管理类
    function GetColumnLayoutsManagerClass:TSkinListLayoutsManagerClass;override;
  public
    //更新统计汇总
    procedure UpdateFooter;
//
//    //点击单元格事件
//    procedure DoClickCell(ARow:TBaseSkinItem;ACol:TSkinVirtualGridColumn);override;

    //获取指定单元格的文本
    function GetGridCellText(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem):String;override;
    function GetGridCellText1(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem):String;override;

    function GetCellValue(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem):Variant;override;

    function GetCellValueObject(ACol:TSkinVirtualGridColumn;
                              ARow:TBaseSkinItem):TObject;override;

    function GetCellValue1(ACol:TSkinVirtualGridColumn;
                                ARow:TBaseSkinItem):Variant;override;
    function GetCellValue1Object(ACol:TSkinVirtualGridColumn;
                                ARow:TBaseSkinItem):TObject;override;


//    //获取指定单元格是否勾选
//    function GetGridCellChecked(ACol:TSkinVirtualGridColumn;
//                                ARow:TBaseSkinItem
//                                ):Boolean;override;
    //设置单元格的值
    procedure SetGridCellValue(ACol:TSkinVirtualGridColumn;
                                ARow:TBaseSkinItem;
                                AValue:Variant
                                );override;

//    //获取指定单元格的文本1
//    function GetGridCellText1(ACol:TSkinVirtualGridColumn;
//                              ARow:TBaseSkinItem):String;
  published
    //表格列
    property Columns:TSkinItemGridColumns read GetColumns write SetColumns;
    //表格数据行
    property Items:TSkinItemGridRows read GetItems write SetItems;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinItemGridColumnMaterial=class(TSkinVirtualGridColumnMaterial)
  private
//    FDrawCellText1Param:TDrawTextParam;
//    procedure SetDrawCellText1Param(const Value: TDrawTextParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
//    //单元格文本绘制参数
//    property DrawCellText1Param:TDrawTextParam read FDrawCellText1Param write SetDrawCellText1Param;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinItemGridDefaultMaterial=class(TSkinVirtualGridDefaultMaterial)
  private
    function GetDrawColumnMaterial: TSkinItemGridColumnMaterial;
    procedure SetDrawColumnMaterial(const Value: TSkinItemGridColumnMaterial);
  protected
    function GetColumnMaterialClass:TSkinVirtualGridColumnMaterialClass;override;
  public
    //默认的列标题,单元格文本绘制参数
    property DrawColumnMaterial:TSkinItemGridColumnMaterial read GetDrawColumnMaterial write SetDrawColumnMaterial;
  end;




  TSkinItemGridDefaultType=class(TSkinVirtualGridDefaultType)
  protected

    FSkinItemGridIntf:ISkinItemGrid;

    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
//  protected
//    //绘制单元格
//    function CustomPaintCellContent(ACanvas: TDrawCanvas;
//                                        ARowIndex:Integer;
//                                        ARow:TBaseSkinItem;
//                                        ARowDrawRect:TRectF;
//                                        AColumn:TSkinVirtualGridColumn;
//                                        AColumnIndex:Integer;
//                                        ACellDrawRect:TRectF;
//                                        ARowEffectStates:TDPEffectStates;
//                                        ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
//                                        ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
//                                        const ADrawRect: TRectF;
//                                        AVirtualGridPaintData:TPaintData
//                                        ): Boolean;override;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinItemGrid=class(TSkinVirtualGrid,ISkinItemGrid)
  private

    function GetItemGridProperties:TItemGridProperties;
    procedure SetItemGridProperties(Value:TItemGridProperties);

  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinItemGridDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinItemGridDefaultMaterial;
    function Material:TSkinItemGridDefaultMaterial;
  public
    property Prop:TItemGridProperties read GetItemGridProperties write SetItemGridProperties;
  published
    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TItemGridProperties read GetItemGridProperties write SetItemGridProperties;

    //垂直滚动条
    property VertScrollBar;

    //水平滚动条
    property HorzScrollBar;
  end;


  {$IFDEF VCL}
  TSkinWinItemGrid=class(TSkinItemGrid)
  end;
  {$ENDIF VCL}



////根据sitItemCaption获取ItemCaption,用于ItemGrid
//function GetItemDataTypeName(AItemDataType:TSkinItemDataType;ASubItemsIndex:Integer):String;


implementation



//function GetItemDataTypeName(AItemDataType:TSkinItemDataType;ASubItemsIndex:Integer):String;
//begin
//  Result:='';
//  case AItemDataType of
//    idtNone: ;
//    idtCaption: Result:='ItemCaption';
//    idtIcon: Result:='ItemIcon';
//    idtPic: Result:='ItemPic';
//    idtChecked: Result:='ItemChecked';
//    idtSelected: Result:='ItemSelected';
//    idtExpanded: Result:='ItemExpanded';
//    idtAccessory: Result:='ItemAccessory';
//    idtDetail: Result:='ItemDetail';
//    idtDetail1: Result:='ItemDetail1';
//    idtDetail2: Result:='ItemDetail2';
//    idtDetail3: Result:='ItemDetail3';
//    idtDetail4: Result:='ItemDetail4';
//    idtDetail5: Result:='ItemDetail5';
//    idtDetail6: Result:='ItemDetail6';
//    idtSubItems: Result:='ItemSubItems'+IntToStr(ASubItemsIndex);
//  end;
//end;


{ TSkinItemGridRow }

function TSkinItemGridRow.GetWidth: Double;
begin
  Result:=Inherited;
  if Self.GetListLayoutsManager<>nil then
  begin
//    Result:=TItemGridProperties(TSkinItemGridRowLayoutsManager(GetListLayoutsManager).FProperties).CalcContentWidth;
    Result:=TScrollControlProperties(TSkinItemGridRowLayoutsManager(GetListLayoutsManager).FVirtualGridProperties).CalcContentWidth;
//    Result:=GetListLayoutsManager.ContentWidth;
  end;
end;


{ TSkinItemGridRows }

function TSkinItemGridRows.Add: TSkinItemGridRow;
begin
  Result:=TSkinItemGridRow(Inherited Add);
end;

//function TSkinItemGridRows.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
//begin
//  Result:=SkinItemClass.Create;//(Self);
//end;

procedure TSkinItemGridRows.DoAdd(AObject: TObject);
begin
  inherited;

  {$IFDEF FREE_VERSION}
  if Count=200 then
  begin
    ShowMessage('OrangeUI免费版限制(Grid只能200条记录数)');
  end;
  {$ENDIF}

end;

procedure TSkinItemGridRows.EndUpdate(AIsForce: Boolean);
var
  AVirtualGridProperties:TVirtualGridProperties;
begin
  //如果有自适应尺寸的列
  AVirtualGridProperties:=TSkinVirtualGridRowLayoutsManager(Self.FListLayoutsManager).FVirtualGridProperties;
  AVirtualGridProperties.CalcAutoSizeColumnWidth;

  inherited;

end;

function TSkinItemGridRows.GetSkinItemClass: TBaseSkinItemClass;
begin
  Result:=TSkinItemGridRow;
end;

//procedure TSkinItemGridRows.InitSkinItemClass;
//begin
//  SkinItemClass:=TSkinItemGridRow;
//end;

{ TItemGridProperties }

procedure TItemGridProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;


end;

function TItemGridProperties.GetComponentClassify: String;
begin
  Result:='SkinItemGrid';
end;

function TItemGridProperties.GetItemsClass: TBaseSkinItemsClass;
begin
  Result:=TSkinItemGridRows;
end;

function TItemGridProperties.GetCustomListLayoutsManagerClass: TSkinCustomListLayoutsManagerClass;
begin
  Result:=TSkinItemGridRowLayoutsManager;
end;

function TItemGridProperties.GetColumnsClass: TSkinVirtualGridColumnsClass;
begin
  Result:=TSkinItemGridColumns;
end;

//procedure TItemGridProperties.DoClickCell(ARow: TBaseSkinItem;ACol: TSkinVirtualGridColumn);
//begin
//  inherited;
//
//end;

procedure TItemGridProperties.DoItemPropChange(Sender: TObject);
begin
  inherited;

  //如果有统计区,而且有统计值,那要刷新
  if Self.FFooterRowCount>0 then
  begin
    UpdateFooter;
  end;

end;

procedure TItemGridProperties.DoItemVisibleChange(Sender: TObject);
begin
  inherited;


  //如果有统计区,而且有统计值,那要刷新
  if Self.FFooterRowCount>0 then
  begin
    UpdateFooter;
  end;
end;

function TItemGridProperties.GetCellValue(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): Variant;
var
  AItemRow:TSkinItemGridRow;
  AItemColumn:TSkinItemGridColumn;
begin
  Result:='';


  AItemRow:=TSkinItemGridRow(ARow);
  AItemColumn:=TSkinItemGridColumn(ACol);

  //绘制单元格内容
  Result:=AItemRow.GetValueByBindItemField(AItemColumn.FBindItemFieldName);

end;

function TItemGridProperties.GetCellValue1(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): Variant;
var
  AItemRow:TSkinItemGridRow;
  AItemColumn:TSkinItemGridColumn;
begin
  Result:='';


  AItemRow:=TSkinItemGridRow(ARow);
  AItemColumn:=TSkinItemGridColumn(ACol);

  //绘制单元格内容
  Result:=AItemRow.GetValueByBindItemField(AItemColumn.FBindItemFieldName1);

end;

function TItemGridProperties.GetCellValueObject(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): TObject;
var
  AItemRow:TSkinItemGridRow;
  AItemColumn:TSkinItemGridColumn;
begin
  Result:=nil;


  AItemRow:=TSkinItemGridRow(ARow);
  AItemColumn:=TSkinItemGridColumn(ACol);

  //绘制单元格内容
  Result:=AItemRow.GetObjectByBindItemField(AItemColumn.FBindItemFieldName);

end;

function TItemGridProperties.GetCellValue1Object(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem): TObject;
var
  AItemRow:TSkinItemGridRow;
  AItemColumn:TSkinItemGridColumn;
begin
  Result:=nil;


  AItemRow:=TSkinItemGridRow(ARow);
  AItemColumn:=TSkinItemGridColumn(ACol);

  //绘制单元格内容
  Result:=AItemRow.GetObjectByBindItemField(AItemColumn.FBindItemFieldName1);

end;

function TItemGridProperties.GetColumnClass: TSkinVirtualGridColumnClass;
begin
  Result:=TSkinItemGridColumn;
end;

function TItemGridProperties.GetColumnLayoutsManagerClass: TSkinListLayoutsManagerClass;
begin
  Result:=TSkinItemGridColumnLayoutsManager;
end;

//function TItemGridProperties.GetGridCellChecked(ACol: TSkinVirtualGridColumn;
//  ARow: TBaseSkinItem): Boolean;
//begin
////  Result:=TSkinItem(ARow).Checked;
//  Result:=ARow.GetValueByBindItemField(TSkinItemGridColumn(ACol).FBindItemFieldName);
//end;

function TItemGridProperties.GetGridCellText(ACol: TSkinVirtualGridColumn;
                                            ARow: TBaseSkinItem
                                            ): String;
var
  AItemRow:TSkinItemGridRow;
  AItemColumn:TSkinItemGridColumn;
begin
  Result:='';


  AItemRow:=TSkinItemGridRow(ARow);
  AItemColumn:=TSkinItemGridColumn(ACol);

  //绘制单元格内容
  Result:=AItemRow.GetValueByBindItemField(AItemColumn.FBindItemFieldName);
//  Result:=GetItemDataText(AItemRow,
//                          AItemColumn.FItemDataType,
//                          AItemColumn.FSubItemsIndex);
end;

function TItemGridProperties.GetGridCellText1(ACol: TSkinVirtualGridColumn;
                                            ARow: TBaseSkinItem
                                            ): String;
var
  AItemRow:TSkinItemGridRow;
  AItemColumn:TSkinItemGridColumn;
begin
  Result:='';


  AItemRow:=TSkinItemGridRow(ARow);
  AItemColumn:=TSkinItemGridColumn(ACol);

  //绘制单元格内容
  Result:=AItemRow.GetValueByBindItemField(AItemColumn.FBindItemFieldName1);
//  Result:=GetItemDataText(AItemRow,
//                          AItemColumn.FItemDataType,
//                          AItemColumn.FSubItemsIndex);

  //从自定义的过程中获取
  if Assigned(Self.FSkinVirtualGridIntf.OnGetCellDisplayText) then
  begin
    Self.FSkinVirtualGridIntf.OnGetCellDisplayText(Self,
                                                ACol,
                                                ARow,
//                                                        AVisibleColIndex,AVisibleRowIndex,
                                                Result);
  end;


end;

//function TItemGridProperties.GetGridCellText1(ACol: TSkinVirtualGridColumn;ARow: TBaseSkinItem): String;
//var
//  AItemRow:TSkinItemGridRow;
//  AItemColumn:TSkinItemGridColumn;
//begin
//  Result:='';
//
//  AItemRow:=TSkinItemGridRow(ARow);
//  AItemColumn:=TSkinItemGridColumn(ACol);
//
//  //绘制单元格内容
//  Result:=ARow.GetValueByBindItemField(AItemColumn.FBindItemFieldName1)
////  Result:=GetItemDataText(AItemRow,
////                          AItemColumn.FItemDataType1,
////                          AItemColumn.FSubItemsIndex1);
//end;

procedure TItemGridProperties.SetColumns(const Value: TSkinItemGridColumns);
begin
  FColumns.Assign(Value);
end;

procedure TItemGridProperties.SetGridCellValue(ACol: TSkinVirtualGridColumn;
  ARow: TBaseSkinItem; AValue: Variant);
begin
  //将编辑控件的值赋回给列表项的属性
  ARow.SetValueByBindItemField(TSkinItemGridColumn(ACol).FBindItemFieldName,AValue);
//  SetItemValueByItemDataType(
//                            TSkinItem(ARow),
//                            TSkinItemGridColumn(ACol).FItemDataType,
//                            TSkinItemGridColumn(ACol).FSubItemsIndex,
//                            AValue
//                            );
end;

function TItemGridProperties.GetItems: TSkinItemGridRows;
begin
  Result:=TSkinItemGridRows(FItems);
end;

procedure TItemGridProperties.SetItems(const Value: TSkinItemGridRows);
begin
  FItems.Assign(Value);
end;

procedure TItemGridProperties.UpdateFooter;
var
  I: Integer;
  OldActiveRecord:Integer;
  J: Integer;
  AHasSumFooter:Boolean;
  ASumFooterList:TList;
begin
  AHasSumFooter:=False;
  ASumFooterList:=nil;
  for I := 0 to Self.Columns.Count-1 do
  begin

      //暂时清空统计值
      Self.Columns[I].FFooter.SumValue:=0;
      Self.Columns[I].FFooter.AverageValue:=0;
      Self.Columns[I].FFooter.RecordCount:=0;


      if (Self.Columns[I].FFooter.ValueType=fvtSum)
        or (Self.Columns[I].FFooter.ValueType=fvtAverage) then
      begin

          if Self.Columns[I].BindItemFieldName<>'' then
          begin
              AHasSumFooter:=True;
              if ASumFooterList=nil then
              begin
                ASumFooterList:=TList.Create;
              end;
              ASumFooterList.Add(Columns[I]);
          end;

      end;

  end;




//  if (Self.FDataLink.DataSet<>nil)
//    and Self.FDataLink.DataSet.Active then
//  begin
      //数据集打开

      //更新汇总表格列



      //统计记录数
      for I := 0 to Self.Columns.Count-1 do
      begin
//        if (Self.Columns[I].Field<>nil) and (Self.Columns[I].FFooter.ValueType=fvtCount) then
//        begin
//            Self.Columns[I].FFooter.StaticValue:=IntToStr(Self.FDataLink.DataSet.RecordCount);
            Self.Columns[I].FFooter.RecordCount:=Self.FItems.Count;
//        end;
      end;




      if AHasSumFooter then
      begin
//        OldActiveRecord:=Self.FDataLink.ActiveRecord;
//        try


              //计算每列的统计值
              for I := 0 to Self.FItems.Count-1 do
              begin

                if FItems[I].Visible then
                begin
                
    //                Self.FDataLink.ActiveRecord:=I;
                    for J := 0 to ASumFooterList.Count-1 do
                    begin
                      try
    //                    if not VarIsNull(TSkinDBGridColumn(ASumFooterList[J]).Field.Value) then
    //                    begin
                          TSkinVirtualGridColumn(ASumFooterList[J]).Footer.SumValue:=
                                TSkinVirtualGridColumn(ASumFooterList[J]).Footer.SumValue
                                  +FItems[I].GetValueByBindItemField(TSkinItemGridColumn(ASumFooterList[J]).FBindItemFieldName);
    //                    end;
                      except

                      end;
                    end;


                end;
              end;


              //计算平均值
              for J := 0 to ASumFooterList.Count-1 do
              begin
                try
                  TSkinVirtualGridColumn(ASumFooterList[J]).Footer.AverageValue:=
                      TSkinVirtualGridColumn(ASumFooterList[J]).Footer.SumValue/Self.FItems.Count;
                except

                end;
              end;

//        finally
//          Self.FDataLink.ActiveRecord:=OldActiveRecord;
//        end;
      end;

//  end;




  if AHasSumFooter then
  begin
    FreeAndNil(ASumFooterList);
  end;



end;

function TItemGridProperties.GetColumns: TSkinItemGridColumns;
begin
  Result:=TSkinItemGridColumns(FColumns);
end;


{ TSkinItemGridDefaultType }

//function TSkinItemGridDefaultType.CustomPaintCellContent(ACanvas: TDrawCanvas;
//                                                      ARowIndex:Integer;
//                                                      ARow:TBaseSkinItem;
//                                                      ARowDrawRect:TRectF;
//                                                      AColumn:TSkinVirtualGridColumn;
//                                                      AColumnIndex:Integer;
//                                                      ACellDrawRect:TRectF;
//                                                      ARowEffectStates:TDPEffectStates;
//                                                      ASkinVirtualGridMaterial:TSkinVirtualGridDefaultMaterial;
//                                                      ADrawColumnMaterial:TSkinVirtualGridColumnMaterial;
//                                                      const ADrawRect: TRectF;
//                                                      AVirtualGridPaintData:TPaintData): Boolean;
//var
//  AItemRow:TSkinItemGridRow;
//  AItemColumn:TSkinItemGridColumn;
//  ADrawItemColumnMaterial:TSkinItemGridColumnMaterial;
//begin
//  AItemRow:=TSkinItemGridRow(ARow);
//  AItemColumn:=TSkinItemGridColumn(AColumn);
//  ADrawItemColumnMaterial:=TSkinItemGridColumnMaterial(ADrawColumnMaterial);
//
//  if ADrawColumnMaterial<>nil then
//  begin
//      if AItemRow.GetValueTypeByBindItemField(AItemColumn.FBindItemFieldName)=varObject then
//      begin
//        ACanvas.DrawPicture(ADrawColumnMaterial.DrawCellPictureParam,TBaseDrawPicture(AItemRow.GetObjectByBindItemField(AItemColumn.FBindItemFieldName)),ACellDrawRect);
//      end
//      else
//      begin
//        Inherited;
//      end;
//
////      //绘制单元格内容
////      case AItemColumn.FItemDataType of
////        idtNone: ;
////        idtIcon:
////        begin
////          ACanvas.DrawPicture(ADrawColumnMaterial.DrawCellPictureParam,AItemRow.Icon,ACellDrawRect);
////        end;
////        idtPic:
////        begin
////          ACanvas.DrawPicture(ADrawColumnMaterial.DrawCellPictureParam,AItemRow.Pic,ACellDrawRect);
////        end;
////        else
////        begin
////          Inherited;
////        end;
////      end;
//
//      if AItemRow.GetValueTypeByBindItemField(AItemColumn.FBindItemFieldName1)=varObject then
//      begin
//        //是图片
//        ACanvas.DrawPicture(ADrawColumnMaterial.DrawCellPictureParam,
//                            TBaseDrawPicture(AItemRow.GetObjectByBindItemField(AItemColumn.FBindItemFieldName1)),ACellDrawRect);
//      end
//      else
//      begin
//        ADrawItemColumnMaterial.DrawCellText1Param.StaticEffectStates:=ARowEffectStates;
//        ACanvas.DrawText(ADrawItemColumnMaterial.FDrawCellText1Param,
//                        Self.FSkinItemGridIntf.Prop.GetGridCellText1(AColumn,ARow),
//                        ACellDrawRect);
//      end;
//
//
////      case AItemColumn.FItemDataType1 of
////        idtNone: ;
////        idtIcon:
////        begin
////        end;
////        idtPic:
////        begin
////        end;
////        else
////        begin
////
////          ADrawItemColumnMaterial.DrawCellText1Param.StaticEffectStates:=ARowEffectStates;
////          ACanvas.DrawText(ADrawItemColumnMaterial.FDrawCellText1Param,
////                          Self.FSkinItemGridIntf.Prop.GetGridCellText1(AColumn,ARow),
////                          ACellDrawRect);
////
////        end;
////      end;
//
//
//  end;
//end;

function TSkinItemGridDefaultType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinItemGrid,Self.FSkinItemGridIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinItemGrid Interface');
    end;
  end;
end;

procedure TSkinItemGridDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinItemGridIntf:=nil;
end;


{ TSkinItemGridColumns }

function TSkinItemGridColumns.Add: TSkinItemGridColumn;
begin
  Result:=TSkinItemGridColumn(Inherited Add);
end;




function TSkinItemGridColumns.Find(
  ABindItemFieldName: String): TSkinItemGridColumn;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Count-1 do
  begin
    if Items[I].BindItemFieldName=ABindItemFieldName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinItemGridColumns.GetItem(Index: Integer): TSkinItemGridColumn;
begin
  Result:=TSkinItemGridColumn(Inherited Items[Index]);
end;

{ TSkinItemGridDefaultMaterial }

function TSkinItemGridDefaultMaterial.GetColumnMaterialClass: TSkinVirtualGridColumnMaterialClass;
begin
  Result:=TSkinItemGridColumnMaterial;
end;

function TSkinItemGridDefaultMaterial.GetDrawColumnMaterial: TSkinItemGridColumnMaterial;
begin
  Result:=TSkinItemGridColumnMaterial(FDrawColumnMaterial);
end;

procedure TSkinItemGridDefaultMaterial.SetDrawColumnMaterial(const Value: TSkinItemGridColumnMaterial);
begin
  FDrawColumnMaterial.Assign(Value);
end;

{ TSkinItemGridColumn }

constructor TSkinItemGridColumn.Create(Collection: TCollection);
begin
  inherited;

//  FSubItemsIndex:=-1;
//  FSubItemsIndex1:=-1;

end;

function TSkinItemGridColumn.GetBindItemFieldName: String;
begin
  Result := FBindItemFieldName;
end;

function TSkinItemGridColumn.GetBindItemFieldName1: String;
begin
  Result := FBindItemFieldName1;
end;

function TSkinItemGridColumn.GetColumnMaterialClass: TSkinVirtualGridColumnMaterialClass;
begin
  Result:=TSkinItemGridColumnMaterial;
end;

//function TSkinItemGridColumn.GetContentTypes: TSkinGridColumnContentTypes;
//begin
//  Result:=Inherited;
//
//  if (Self.FBindItemFieldName='ItemChecked')
//    or (Self.FBindItemFieldName1='ItemChecked')
//    or (Self.FBindItemFieldName='ItemSelected')
//    or (Self.FBindItemFieldName1='ItemSelected') then
//  begin
//    Result:=[cctCheckBox];
//  end;
//
////  if FItemDataType=idtChecked then
////  begin
////    Result:=[cctCheckBox];
////  end;
//end;

function TSkinItemGridColumn.GetSelfOwnMaterial: TSkinItemGridColumnMaterial;
begin
  Result:=TSkinItemGridColumnMaterial(FMaterial);
end;

function TSkinItemGridColumn.GetValueType(ARow: TBaseSkinItem): TVarType;
begin
  Result:=ARow.GetValueTypeByBindItemField(Self.GetBindItemFieldName);
end;

function TSkinItemGridColumn.GetValueType1(ARow: TBaseSkinItem): TVarType;
begin
  Result:=ARow.GetValueTypeByBindItemField(Self.GetBindItemFieldName1);
end;

procedure TSkinItemGridColumn.SetBindItemFieldName(const Value: String);
begin
  if FBindItemFieldName<>Value then
  begin
    FBindItemFieldName := Value;
    DoPropChange;
  end;
end;

procedure TSkinItemGridColumn.SetBindItemFieldName1(const Value: String);
begin
  if FBindItemFieldName1<>Value then
  begin
    FBindItemFieldName1 := Value;
    DoPropChange;
  end;
end;

//procedure TSkinItemGridColumn.SetItemDataType(const Value: TSkinItemDataType);
//begin
//  if FItemDataType<>Value then
//  begin
//    FItemDataType := Value;
//
//    SyncBindItemFieldName;
//
//    DoPropChange;
//  end;
//end;
//
//procedure TSkinItemGridColumn.SetItemDataType1(const Value: TSkinItemDataType);
//begin
//  if FItemDataType1<>Value then
//  begin
//    FItemDataType1 := Value;
//
//    SyncBindItemFieldName;
//
//    DoPropChange;
//  end;
//end;

procedure TSkinItemGridColumn.SetSelfOwnMaterial(const Value: TSkinItemGridColumnMaterial);
begin
  FMaterial.Assign(Value);
end;

//procedure TSkinItemGridColumn.SetSubItemsIndex(const Value: Integer);
//begin
//  if FSubItemsIndex<>Value then
//  begin
//    FSubItemsIndex := Value;
//
//    SyncBindItemFieldName;
//
//    DoPropChange;
//  end;
//end;
//
//procedure TSkinItemGridColumn.SetSubItemsIndex1(const Value: Integer);
//begin
//  if FSubItemsIndex1<>Value then
//  begin
//    FSubItemsIndex1 := Value;
//
//    SyncBindItemFieldName;
//
//    DoPropChange;
//  end;
//end;
//
//procedure TSkinItemGridColumn.SyncBindItemFieldName;
//begin
//  FBindItemFieldName:=GetItemDataTypeName(Self.FItemDataType,Self.FSubItemsIndex);
//  FBindItemFieldName1:=GetItemDataTypeName(Self.FItemDataType1,Self.FSubItemsIndex1);
//end;

{ TSkinItemGridColumnMaterial }

constructor TSkinItemGridColumnMaterial.Create(AOwner: TComponent);
begin
  inherited;
//  FDrawCellText1Param:=CreateDrawTextParam('DrawCellText1Param','单元格文本1绘制参数');

end;

destructor TSkinItemGridColumnMaterial.Destroy;
begin
//  FreeAndNil(FDrawCellText1Param);

  inherited;
end;

//procedure TSkinItemGridColumnMaterial.SetDrawCellText1Param(const Value: TDrawTextParam);
//begin
//  FDrawCellText1Param.Assign(Value);
//end;



{ TSkinItemGrid }

function TSkinItemGrid.Material:TSkinItemGridDefaultMaterial;
begin
  Result:=TSkinItemGridDefaultMaterial(SelfOwnMaterial);
end;

function TSkinItemGrid.SelfOwnMaterialToDefault:TSkinItemGridDefaultMaterial;
begin
  Result:=TSkinItemGridDefaultMaterial(SelfOwnMaterial);
end;

function TSkinItemGrid.CurrentUseMaterialToDefault:TSkinItemGridDefaultMaterial;
begin
  Result:=TSkinItemGridDefaultMaterial(CurrentUseMaterial);
end;

function TSkinItemGrid.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TItemGridProperties;
end;

function TSkinItemGrid.GetItemGridProperties: TItemGridProperties;
begin
  Result:=TItemGridProperties(Self.FProperties);
end;

procedure TSkinItemGrid.SetItemGridProperties(Value: TItemGridProperties);
begin
  Self.FProperties.Assign(Value);
end;




end.

