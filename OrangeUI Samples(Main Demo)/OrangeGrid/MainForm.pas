//convert pas to utf8 by ¥

unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,


  uDrawParam,
  uDrawCanvas,
  uComponentType,
  uGraphicCommon,
  uSkinItems,
  uFuncCommon,
  uFileCommon,
  uDrawRectParam,
  uDrawTextParam,
  uSkinDBGridType,
  uSkinVirtualGridType,
  uSkinControlGestureManager,

  uSkinFireMonkeyDBGrid,
  uSkinFireMonkeyVirtualGrid,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinMaterial,
  uSkinFireMonkeyPanel, uSkinFireMonkeyLabel,uSkinFireMonkeyCustomList, uSkinFireMonkeyButton,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.UI,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ListBox,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, FMX.ComboEdit,
  uSkinButtonType, uSkinLabelType, uSkinPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, FMX.StdCtrls, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage;

type
  TfrmMain = class(TForm)
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    DataSource1: TDataSource;
    SkinFMXDBGrid1: TSkinFMXDBGrid;
    pnlToolBar: TSkinFMXPanel;
    lblDemo: TSkinFMXLabel;
    pnlToolBarInner: TSkinFMXPanel;
    btnOpenDataSet: TSkinFMXButton;
    btnClearColumns: TSkinFMXButton;
    btnSwitchTable: TSkinFMXButton;
    pnlToolBarInner2: TSkinFMXPanel;
    btnSetColumnIndex: TSkinFMXButton;
    btnHideColumn: TSkinFMXButton;
    pnlToolBarInner3: TSkinFMXPanel;
    btnIndicatorWidth: TSkinFMXButton;
    btnFixCols: TSkinFMXButton;
    btnSetColumnWidth: TSkinFMXButton;
    btnAddColumns: TSkinFMXButton;
    btnDeleteColumn: TSkinFMXButton;
    btnNoOverRange: TSkinFMXButton;
    btnRowSelect: TSkinFMXButton;
    FDTable1: TFDTable;
    SkinFMXEdit1: TSkinFMXEdit;
    cmbFieldName: TComboEdit;
    SkinFMXPanel1: TSkinFMXPanel;
    btnAppend: TSkinFMXButton;
    btnDelete: TSkinFMXButton;
    cmbTableName: TComboEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtColumnWidth: TEdit;
    edtIndicatorWidth: TEdit;
    edtFixedCols: TEdit;
    idpIsAdmin: TSkinFMXItemDesignerPanel;
    chkColor1: TSkinFMXCheckBox;
    SkinFMXButton1: TSkinFMXButton;
    idpUserName: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    idpButton: TSkinFMXItemDesignerPanel;
    btnDelRow: TSkinFMXButton;
    btnPrior: TSkinFMXButton;
    btnNext: TSkinFMXButton;
    btnGetSelectedCellText: TSkinFMXButton;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXCheckBox1: TSkinFMXCheckBox;
    idpCellImage: TSkinFMXItemDesignerPanel;
    SkinFMXImage2: TSkinFMXImage;
    procedure FormShow(Sender: TObject);
    procedure btnOpenDataSetClick(Sender: TObject);
    procedure btnClearColumnsClick(Sender: TObject);
    procedure btnAddColumnsClick(Sender: TObject);
    procedure btnSetColumnIndexClick(Sender: TObject);
    procedure btnHideColumnClick(Sender: TObject);
    procedure btnSetColumnWidthClick(Sender: TObject);
    procedure btnSwitchTableClick(Sender: TObject);
    procedure btnIndicatorWidthClick(Sender: TObject);
    procedure btnFixColsClick(Sender: TObject);
    procedure SkinFMXDBGrid1ClickItem(AItem: TBaseSkinItem);
    procedure btnDeleteColumnClick(Sender: TObject);
    procedure btnNoOverRangeClick(Sender: TObject);
    procedure btnRowSelectClick(Sender: TObject);
    procedure SkinFMXDBGrid1GetCellEditControl(Sender: TObject;
      ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem;
      var AEditControl: TControl);
    procedure SkinFMXDBGrid1CustomPaintCellBegin(ACanvas: TDrawCanvas;
      ARowIndex: Integer; ARow: TBaseSkinItem; ARowDrawRect: TRectF;
      AColumn: TSkinVirtualGridColumn; AColumnIndex: Integer;
      ACellDrawRect: TRectF; ARowEffectStates: TDPEffectStates;
      ASkinVirtualGridMaterial: TSkinVirtualGridDefaultMaterial;
      ADrawColumnMaterial: TSkinVirtualGridColumnMaterial;
      const ADrawRect: TRectF; AVirtualGridPaintData: TPaintData);
    procedure FormCreate(Sender: TObject);
    procedure btnAppendClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure SkinFMXButton1Click(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPriorClick(Sender: TObject);
    procedure btnDelRowClick(Sender: TObject);
    procedure btnGetSelectedCellTextClick(Sender: TObject);
    procedure SkinFMXCheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.btnAddColumnsClick(Sender: TObject);
var
  AColumn:TSkinDBGridColumn;
begin
  Self.SkinFMXDBGrid1.Prop.Columns.BeginUpdate;
  try
    AColumn:=Self.SkinFMXDBGrid1.Prop.Columns.Add;
    AColumn.FieldName:=Self.cmbFieldName.Text;
  finally
    Self.SkinFMXDBGrid1.Prop.Columns.EndUpdate;
  end;
end;

procedure TfrmMain.btnAppendClick(Sender: TObject);
begin
  Self.FDTable1.Append;
  Self.FDTable1.FieldByName('id').AsString:=CreateGUIDString;
  Self.FDTable1.FieldByName('name').AsString:='test_append';
  Self.FDTable1.Post;

end;

procedure TfrmMain.btnClearColumnsClick(Sender: TObject);
begin
  //清空列
  Self.SkinFMXDBGrid1.Prop.Columns.Clear;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin
  Self.FDTable1.Delete;
end;

procedure TfrmMain.btnDeleteColumnClick(Sender: TObject);
//var
//  AColumn:TSkinDBGridColumn;
begin
//  AColumn:=Self.SkinFMXDBGrid1.Prop.Columns[Self.SkinFMXDBGrid1.Prop.Columns.Count-1];
//  AColumn.Free;

  Self.SkinFMXDBGrid1.Prop.Columns.Delete(Self.SkinFMXDBGrid1.Prop.Columns.Count-1);

end;

procedure TfrmMain.btnDelRowClick(Sender: TObject);
begin
  //
  ShowMessage(
      Self.SkinFMXDBGrid1.Prop.GetGridCellText(
          Self.SkinFMXDBGrid1.Prop.Columns[0],
          Self.SkinFMXDBGrid1.Prop.InteractiveItem
          )
      );
end;

procedure TfrmMain.btnFixColsClick(Sender: TObject);
begin
  //设置固定列
//  if (Self.SkinFMXDBGrid1.Prop.FixedCols>0) then
//  begin
//    Self.SkinFMXDBGrid1.Prop.FixedCols:=0;
//  end
//  else
//  begin
    Self.SkinFMXDBGrid1.Prop.FixedCols:=StrToInt(Self.edtFixedCols.Text);
//  end;
end;

procedure TfrmMain.btnGetSelectedCellTextClick(Sender: TObject);
begin
  ShowMessage(Self.SkinFMXDBGrid1.Prop.SelectedText);
end;

procedure TfrmMain.btnHideColumnClick(Sender: TObject);
begin
  //隐藏/显示列
  if Self.SkinFMXDBGrid1.Prop.Columns[0].Visible then
  begin
    Self.SkinFMXDBGrid1.Prop.Columns[0].Visible:=False;

    Self.btnHideColumn.Caption:='显示列';
  end
  else
  begin
    Self.SkinFMXDBGrid1.Prop.Columns[0].Visible:=True;

    Self.btnHideColumn.Caption:='隐藏列';
  end;
end;

procedure TfrmMain.btnIndicatorWidthClick(Sender: TObject);
begin
  //设置指示列的宽度
//  if (Self.SkinFMXDBGrid1.Prop.IndicatorWidth>1) then
//  begin
//    Self.SkinFMXDBGrid1.Prop.IndicatorWidth:=0;
//  end
//  else
//  begin
    Self.SkinFMXDBGrid1.Prop.IndicatorWidth:=StrToFloat(Self.edtIndicatorWidth.Text);
//  end;
end;

procedure TfrmMain.btnNextClick(Sender: TObject);
begin
  Self.FDTable1.Next;
end;

procedure TfrmMain.btnNoOverRangeClick(Sender: TObject);
begin
//  if Self.SkinFMXDBGrid1.Prop.HorzCanOverRangeTypes<>[] then
//  begin
//    Self.SkinFMXDBGrid1.Prop.HorzCanOverRangeTypes:=[];
//    Self.SkinFMXDBGrid1.Prop.VertCanOverRangeTypes:=[];
//  end
//  else
//  begin
//    Self.SkinFMXDBGrid1.Prop.HorzCanOverRangeTypes:=[cortMin,cortMax];
//    Self.SkinFMXDBGrid1.Prop.VertCanOverRangeTypes:=[cortMin,cortMax];
//  end;
end;

procedure TfrmMain.btnSetColumnIndexClick(Sender: TObject);
begin
  //设置列的顺序
  Self.SkinFMXDBGrid1.Prop.Columns
    [Self.SkinFMXDBGrid1.Prop.Columns.Count-1].Index:=1;
end;

procedure TfrmMain.btnSetColumnWidthClick(Sender: TObject);
begin
  //设置列的宽度
  Self.SkinFMXDBGrid1.Prop.Columns[0].Width:=StrToFloat(Self.edtColumnWidth.Text);
end;

procedure TfrmMain.btnSwitchTableClick(Sender: TObject);
var
  I:Integer;
  ADBGridColumn:TSkinDBGridColumn;
begin
  //切换表数据
//  if Self.FDTable1.TableName='Detector' then
//  begin
    Self.FDTable1.Active:=False;
//    Self.FDTable1.TableName:='Ent';
    Self.FDTable1.TableName:=Self.cmbTableName.Text;
    Self.FDTable1.Active:=True;
//  end
//  else
//  begin
//    Self.FDTable1.Active:=False;
//    Self.FDTable1.TableName:='Detector';
//    Self.FDTable1.Active:=True;
//  end;
      Self.cmbFieldName.BeginUpdate;
      try
        for I := 0 to Self.FDTable1.FieldDefList.Count-1 do
        begin
          Self.cmbFieldName.Items.Add(Self.FDTable1.FieldDefList[I].Name);
        end;
      finally
        Self.cmbFieldName.EndUpdate;
      end;


//  ADBGridColumn:=Self.SkinFMXDBGrid1.Prop.Columns.FindItemByFieldName('address');
//  if ADBGridColumn<>nil then
//  begin
//    ADBGridColumn.ItemDesignerPanel:=Self.idpCellImage;
//  end;




  ADBGridColumn:=Self.SkinFMXDBGrid1.Prop.Columns.FindItemByFieldName('name');
  if ADBGridColumn<>nil then
  begin
    ADBGridColumn.AutoSize:=True;
  end;
  ADBGridColumn:=Self.SkinFMXDBGrid1.Prop.Columns.FindItemByFieldName('id');
  if ADBGridColumn<>nil then
  begin
    ADBGridColumn.AutoSize:=True;
  end;
  SkinFMXDBGrid1.Prop.Items.BeginUpdate;
  try

  finally
    SkinFMXDBGrid1.Prop.Items.EndUpdate();
  end;

end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

//  Self.SkinFMXDBGrid1.Prop.FIsNeedClip:=False;
//  Self.SkinFMXDBGrid1.ClipChildren:=False;


//  Self.SkinFMXDBGrid1.Material.DrawIndicatorHeaderBackColor.BorderWidth:=1;
//
//  //表格行分隔线
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.IsDrawRowBeginLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.IsDrawRowEndLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.IsDrawColBeginLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.IsDrawColEndLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.IsDrawRowLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.IsDrawColLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.DrawRowLineParam.PenWidth:=1;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.DrawRowLineParam.Color.Color:=BlackColor;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.DrawColLineParam.PenWidth:=1;
//  Self.SkinFMXDBGrid1.Material.DrawGridCellDevideMaterial.DrawColLineParam.Color.Color:=BlackColor;
//
//
//  //表格列分隔线
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.IsDrawRowBeginLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.IsDrawRowEndLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.IsDrawColBeginLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.IsDrawColEndLine:=True;
////  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.IsDrawRowLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.IsDrawColLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.DrawRowLineParam.PenWidth:=1;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.DrawRowLineParam.Color.Color:=BlackColor;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.DrawColLineParam.PenWidth:=1;
//  Self.SkinFMXDBGrid1.Material.DrawColumnDevideMaterial.DrawColLineParam.Color.Color:=BlackColor;
//
//
//  //指示列分隔线
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.IsDrawRowBeginLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.IsDrawRowEndLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.IsDrawColBeginLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.IsDrawColEndLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.IsDrawRowLine:=True;
////  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.IsDrawColLine:=True;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.DrawRowLineParam.PenWidth:=1;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.DrawRowLineParam.Color.Color:=BlackColor;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.DrawColLineParam.PenWidth:=1;
//  Self.SkinFMXDBGrid1.Material.DrawIndicatorDevideMaterial.DrawColLineParam.Color.Color:=BlackColor;



end;

procedure TfrmMain.btnOpenDataSetClick(Sender: TObject);
var
  I: Integer;
begin
  if Not Self.FDConnection1.Connected then
  begin
      //打开数据集
      Self.FDConnection1.Connected:=True;
      Self.SkinFMXDBGrid1.Prop.DataSource:=Self.DataSource1;
      Self.DataSource1.DataSet.Active:=True;


      Self.cmbFieldName.BeginUpdate;
      try
        for I := 0 to Self.FDTable1.FieldDefList.Count-1 do
        begin
          Self.cmbFieldName.Items.Add(Self.FDTable1.FieldDefList[I].Name);
        end;
      finally
        Self.cmbFieldName.EndUpdate;
      end;

      Self.btnOpenDataSet.Caption:='断开';
  end
  else
  begin
      //关闭数据集
      Self.FDConnection1.Connected:=False;
      Self.DataSource1.DataSet.Active:=False;
      Self.SkinFMXDBGrid1.Prop.DataSource:=nil;

      Self.btnOpenDataSet.Caption:='连接';
  end;
end;

procedure TfrmMain.btnPriorClick(Sender: TObject);
begin
  Self.FDTable1.Prior;
end;

procedure TfrmMain.btnRowSelectClick(Sender: TObject);
begin
  Self.SkinFMXDBGrid1.Prop.IsRowSelect:=
    Not Self.SkinFMXDBGrid1.Prop.IsRowSelect;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
//var
//  ASkinDBGridColumn:TSkinDBGridColumn;
begin
////      Self.SkinFMXDBGrid1.Properties.Columns.BeginUpdate;
//      try
//        Self.SkinFMXDBGrid1.Properties.Columns.Clear;
//
//        ASkinDBGridColumn:=Self.SkinFMXDBGrid1.Properties.Columns.Add;
//        ASkinDBGridColumn.FieldName:='charge';
//
//
//      finally
////        Self.SkinFMXDBGrid1.Properties.Columns.EndUpdate;
//      end;
//
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin



  {$IFDEF IOS}
  Self.FDConnection1.Params.Database:=uFileCommon.GetApplicationPath+'DataBase.s3db';
  {$ENDIF}
  {$IFDEF ANDROID}
  Self.FDConnection1.Params.Database:=uFileCommon.GetApplicationPath+'DataBase.s3db';
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  Self.FDConnection1.Params.Database:=GetApplicationPath+'..\..\DataBase.s3db';
//  if Not FileExists(Self.FDConnection1.Params.Database) then
//  begin
//      if Not FileExists('C:\DataBase.s3db') then
//      begin
//        ShowMessage(Self.FDConnection1.Params.Database+'不存在');
//        Exit;
//      end;
//      Self.FDConnection1.Params.Database:='C:\DataBase.s3db';
//  end;
//  if Not FileExists(Self.FDConnection1.Params.Database) then
//  begin
//      if Not FileExists(GetApplicationPath+'..\..\DataBase.s3db') then
//      begin
//        ShowMessage(Self.FDConnection1.Params.Database+'不存在');
//        Exit;
//      end;
//      Self.FDConnection1.Params.Database:='C:\DataBase.s3db';
//  end;
  {$ENDIF}

  if Not FileExists(Self.FDConnection1.Params.Database) then
  begin
    ShowMessage(Self.FDConnection1.Params.Database+'不存在');
    Exit;
  end;




//  Self.SkinFMXDBGrid1.Properties.FooterRowCount:=1;
//
//  Self.SkinFMXDBGrid1.Properties.Columns.BeginUpdate;
//  try
//
//    Self.SkinFMXDBGrid1.Properties.Columns[0].Footer.Value:='总计:';
//    Self.SkinFMXDBGrid1.Properties.Columns[0].Footer.ValueType:=fvtStatic;
//
//
//    Self.SkinFMXDBGrid1.Properties.Columns[1].ValueFormat:='';
//    Self.SkinFMXDBGrid1.Properties.Columns[1].Footer.Value:='';
//    Self.SkinFMXDBGrid1.Properties.Columns[1].Footer.ValueType:=fvtCount;
//
//    Self.SkinFMXDBGrid1.Properties.Columns[3].ValueFormat:='%n';
//    Self.SkinFMXDBGrid1.Properties.Columns[3].Footer.Value:='';
//    Self.SkinFMXDBGrid1.Properties.Columns[3].Footer.ValueType:=fvtSum;
//
////    Self.SkinFMXDBGrid1.Properties.Columns[13].ValueFormat:='%n';
////    Self.SkinFMXDBGrid1.Properties.Columns[13].Footer.Value:='';
////    Self.SkinFMXDBGrid1.Properties.Columns[13].Footer.ValueType:=fvtSum;
//
////
////
////    Self.SkinFMXDBGrid1.Properties.Columns[4].ValueFormat:='';
////    Self.SkinFMXDBGrid1.Properties.Columns[4].Footer.Value:='';
////    Self.SkinFMXDBGrid1.Properties.Columns[4].Footer.ValueType:=fvtCount;
//  finally
//    Self.SkinFMXDBGrid1.Properties.Columns.EndUpdate;
//  end;


end;

procedure TfrmMain.SkinFMXButton1Click(Sender: TObject);
var
  AColumn:TSkinDBGridColumn;
begin
  Self.SkinFMXDBGrid1.Prop.Columns.BeginUpdate;
  try
    AColumn:=TSkinDBGridColumn(Self.SkinFMXDBGrid1.Prop.Columns.Insert(0));
    AColumn.FieldName:=Self.cmbFieldName.Text;
  finally
    Self.SkinFMXDBGrid1.Prop.Columns.EndUpdate;
  end;

end;

procedure TfrmMain.SkinFMXCheckBox1Click(Sender: TObject);
begin
  //
  Self.SkinFMXDBGrid1.Prop.InteractiveItem.Checked:=
    not Self.SkinFMXDBGrid1.Prop.InteractiveItem.Checked;
end;

procedure TfrmMain.SkinFMXDBGrid1ClickItem(AItem: TBaseSkinItem);
begin
  //点击表格行
//  ShowMessage('SkinFMXDBGrid1ClickRow'
//    +
//    Self.FDTable1.FieldByName('FID').AsString
//    );

//  ShowMessage('SkinFMXDBGrid1ClickRow'
//    +
//    Self.SkinFMXDBGrid1.Prop.GetGridCellText(
//          nil,
//          nil,
//          0,//列下标
//          TSkinDBGridRow(AItem).RecordIndex//行下标
//          )
//    );

end;

procedure TfrmMain.SkinFMXDBGrid1CustomPaintCellBegin(ACanvas: TDrawCanvas;
  ARowIndex: Integer; ARow: TBaseSkinItem; ARowDrawRect: TRectF;
  AColumn: TSkinVirtualGridColumn; AColumnIndex: Integer; ACellDrawRect: TRectF;
  ARowEffectStates: TDPEffectStates;
  ASkinVirtualGridMaterial: TSkinVirtualGridDefaultMaterial;
  ADrawColumnMaterial: TSkinVirtualGridColumnMaterial; const ADrawRect: TRectF;
  AVirtualGridPaintData: TPaintData);
//var
//  ALatitude:String;
//  ATEL:String;
begin
//  ADrawColumnMaterial.DrawCellTextParam.FontColor:=TAlphaColorRec.Black;
//
//  //设置背景色
//  if TSkinDBGridColumn(AColumn).FieldName='latitude' then
//  begin
//
//    ADrawColumnMaterial.DrawCellTextParam.FontColor:=TAlphaColorRec.Red;
//
//    ALatitude:=Self.SkinFMXDBGrid1.Prop.GetGridCellText(AColumn,ARow);
//
//    if ALatitude<>'0' then
//    begin
//      uDrawRectParam.GlobalDrawRectParam.FillDrawColor.FColor:=TAlphaColorRec.Dodgerblue;
//      uDrawRectParam.GlobalDrawRectParam.IsFill:=True;
//      ACanvas.DrawRect(TDrawRectParam(GlobalDrawRectParam),
//                        ACellDrawRect);
//    end;
//
//  end;
//  if TSkinDBGridColumn(AColumn).FieldName='tel' then
//  begin
//    ATEL:=Self.SkinFMXDBGrid1.Prop.GetGridCellText(AColumn,ARow);
//
//    if Copy(ATEL,1,3)='153' then
//    begin
//      uDrawRectParam.GlobalDrawRectParam.FillDrawColor.FColor:=TAlphaColorRec.Orange;
//      uDrawRectParam.GlobalDrawRectParam.IsFill:=True;
//      ACanvas.DrawRect(TDrawRectParam(GlobalDrawRectParam),
//                        ACellDrawRect);
//    end;
//
//  end;
end;

procedure TfrmMain.SkinFMXDBGrid1GetCellEditControl(Sender: TObject;
  ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem;
  var AEditControl: TControl);
begin
  AEditControl:=Self.SkinFMXEdit1;
end;

end.
