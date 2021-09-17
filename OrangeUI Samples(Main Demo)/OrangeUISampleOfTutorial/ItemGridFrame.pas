//convert pas to utf8 by ¥

unit ItemGridFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uSkinItems,
  uDrawRectParam,
  uDrawPathParam,
  uDrawPictureParam,
  uGraphicCommon,
  uDrawTextParam,
  uSkinControlGestureManager,
  uSkinVirtualGridType,
  uSkinScrollControlType,
  uSkinItemGridType,
  uSkinFireMonkeyItemGrid,
  uSkinFireMonkeyImage,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualGrid, FMX.Edit, uBaseSkinControl, uSkinCustomListType,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uDrawCanvas;

type
  TFrameItemGrid = class(TFrame)
    Panel1: TPanel;
    Button2: TButton;
    SkinFMXItemGrid1: TSkinFMXItemGrid;
    edtIndicatorWidth: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtColumnHeaderHeight: TEdit;
    chkIsRowSelect: TCheckBox;
    idpButton: TSkinFMXItemDesignerPanel;
    btnDelete: TSkinFMXButton;
    Button3: TButton;
    idpBindItemDetail3: TSkinFMXItemDesignerPanel;
    lblGridCellValue: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    Label3: TLabel;
    edtFixCols: TEdit;
    Label4: TLabel;
    edtItemHeight: TEdit;
    SkinFMXImage2: TSkinFMXImage;
    chkReadOnly: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure SkinFMXItemGrid1ClickCell(Sender: TObject;
      ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem);
    procedure btnDeleteClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SkinFMXItemGrid1GetCellDisplayText(Sender: TObject;
      ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem;
      var ADisplayText: string);
    procedure SkinFMXItemGrid1GetFooterCellDisplayText(Sender: TObject;
      ACol: TSkinVirtualGridColumn; AFooterRowIndex: Integer;
      var ADisplayText: string);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameItemGrid }

procedure TFrameItemGrid.btnDeleteClick(Sender: TObject);
begin
  //删除某一项
  Self.SkinFMXItemGrid1.Prop.Items.Remove(
    Self.SkinFMXItemGrid1.Prop.InteractiveItem
    );
end;

procedure TFrameItemGrid.Button1Click(Sender: TObject);
begin
  Self.SkinFMXItemGrid1.Prop.IndicatorWidth:=StrToFloat(Self.edtIndicatorWidth.Text);
  Self.SkinFMXItemGrid1.Prop.ColumnsHeaderHeight:=StrToFloat(Self.edtColumnHeaderHeight.Text);
  Self.SkinFMXItemGrid1.Prop.FixedCols:=StrToInt(Self.edtFixCols.Text);
  Self.SkinFMXItemGrid1.Prop.ItemHeight:=StrToFloat(Self.edtItemHeight.Text);
  Self.SkinFMXItemGrid1.Prop.IsRowSelect:=Self.chkIsRowSelect.IsChecked;
  Self.SkinFMXItemGrid1.Prop.ReadOnly:=Self.chkReadOnly.IsChecked;

end;

procedure TFrameItemGrid.Button2Click(Sender: TObject);
begin
  Self.SkinFMXItemGrid1.Prop.Items[0].Selected:=True;
//  ShowMessage(Self.SkinFMXItemGrid1.Prop.SelectedText);
end;

procedure TFrameItemGrid.Button3Click(Sender: TObject);
begin
  ShowMessage(Self.SkinFMXItemGrid1.Prop.GetGridCellText(
              Self.SkinFMXItemGrid1.Prop.Columns[0],
              Self.SkinFMXItemGrid1.Prop.Items[0]));
end;

constructor TFrameItemGrid.Create(AOwner: TComponent);
//var
//  AColumn:TSkinItemGridColumn;
//  ARow:TSkinItemGridRow;
//  AImage:TSkinFMXImage;
begin
  inherited;

  Self.edtIndicatorWidth.Text:=FloatToStr(Self.SkinFMXItemGrid1.Prop.IndicatorWidth);
  Self.edtColumnHeaderHeight.Text:=FloatToStr(Self.SkinFMXItemGrid1.Prop.ColumnsHeaderHeight);
  Self.edtFixCols.Text:=FloatToStr(Self.SkinFMXItemGrid1.Prop.FixedCols);
  Self.edtItemHeight.Text:=FloatToStr(Self.SkinFMXItemGrid1.Prop.ItemHeight);
  Self.chkIsRowSelect.IsChecked:=Self.SkinFMXItemGrid1.Prop.IsRowSelect;
  Self.chkReadOnly.IsChecked:=Self.SkinFMXItemGrid1.Prop.ReadOnly;


//  Self.SkinFMXItemGrid1.Prop.FIsNeedClip:=False;


//  AImage:=TSkinFMXImage.Create(Self);
//  AImage.Parent:=Self;
//  AImage.SkinControlType;
//  AImage.SelfOwnMaterial;
//  AImage.Prop.Picture.LoadFromFile('E:\QQ图片20170606083812.jpg');



//  //自动创建一个ItemGrid
//  FItemGrid:=TSkinFMXItemGrid.Create(Self);
//  FItemGrid.SkinControlType;
//  FItemGrid.SelfOwnMaterial;
//  FItemGrid.VertScrollBar;
//  FItemGrid.HorzScrollBar;
//  FItemGrid.Parent:=Self;
//  FItemGrid.Top:=50;
//  FItemGrid.Width:=310;
//  FItemGrid.Height:=300;
//  FItemGrid.Align:=TAlignLayout.Client;
//  FItemGrid.Margins.Left:=10;
//  FItemGrid.Margins.Top:=10;
//  FItemGrid.Margins.Right:=10;
//  FItemGrid.Margins.Bottom:=10;
//
//
//  FItemGrid.Prop.ColumnsHeaderHeight:=40;
//  FItemGrid.Prop.ItemHeight:=50;
//
//
//  //设置单元格图片绘制参数
//  FItemGrid.Material.DrawColumnMaterial.DrawCellPictureParam.IsAutoFit:=True;
//  FItemGrid.Material.DrawColumnMaterial.DrawCellPictureParam.PictureVertAlign:=pvaCenter;
//  FItemGrid.Material.DrawColumnMaterial.DrawCellPictureParam.PictureHorzAlign:=phaCenter;
//
//
//  //表格行分隔线
//  FItemGrid.Material.DrawGridCellDevideMaterial.IsDrawRowBeginLine:=True;
//  FItemGrid.Material.DrawGridCellDevideMaterial.IsDrawRowEndLine:=True;
//  FItemGrid.Material.DrawGridCellDevideMaterial.IsDrawColBeginLine:=True;
//  FItemGrid.Material.DrawGridCellDevideMaterial.IsDrawColEndLine:=True;
//  FItemGrid.Material.DrawGridCellDevideMaterial.IsDrawRowLine:=True;
//  FItemGrid.Material.DrawGridCellDevideMaterial.IsDrawColLine:=True;
//  FItemGrid.Material.DrawGridCellDevideMaterial.DrawRowLineParam.PenWidth:=1;
//  FItemGrid.Material.DrawGridCellDevideMaterial.DrawRowLineParam.Color.Color:=BlackColor;
//  FItemGrid.Material.DrawGridCellDevideMaterial.DrawColLineParam.PenWidth:=1;
//  FItemGrid.Material.DrawGridCellDevideMaterial.DrawColLineParam.Color.Color:=BlackColor;
//
//
//  //表格列分隔线
//  FItemGrid.Material.DrawColumnDevideMaterial.IsDrawRowBeginLine:=True;
//  FItemGrid.Material.DrawColumnDevideMaterial.IsDrawRowEndLine:=True;
//  FItemGrid.Material.DrawColumnDevideMaterial.IsDrawColBeginLine:=True;
//  FItemGrid.Material.DrawColumnDevideMaterial.IsDrawColEndLine:=True;
//  FItemGrid.Material.DrawColumnDevideMaterial.IsDrawRowLine:=True;
//  FItemGrid.Material.DrawColumnDevideMaterial.IsDrawColLine:=True;
//  FItemGrid.Material.DrawColumnDevideMaterial.DrawRowLineParam.PenWidth:=1;
//  FItemGrid.Material.DrawColumnDevideMaterial.DrawRowLineParam.Color.Color:=BlackColor;
//  FItemGrid.Material.DrawColumnDevideMaterial.DrawColLineParam.PenWidth:=1;
//  FItemGrid.Material.DrawColumnDevideMaterial.DrawColLineParam.Color.Color:=BlackColor;
//
//
//  FItemGrid.Material.DrawCheckBoxColorMaterial.DrawCheckStateParam.PenColor.Color := OrangeColor;
//  FItemGrid.Material.DrawCheckBoxColorMaterial.DrawCheckStateParam.DrawEffectSetting.PushedEffect.PenWidth := 2;
//  FItemGrid.Material.DrawCheckBoxColorMaterial.DrawCheckStateParam.DrawEffectSetting.PushedEffect.EffectTypes := [dppetPenWidthChange];
//  FItemGrid.Material.DrawCheckBoxColorMaterial.DrawCheckRectParam.BorderColor.Color := TAlphaColorRec.Lightgray;
//  FItemGrid.Material.DrawCheckBoxColorMaterial.DrawCheckRectParam.BorderWidth := 2;
//  FItemGrid.Material.DrawCheckBoxColorMaterial.DrawCheckRectParam.DrawEffectSetting.PushedEffect.BorderColor.Color := TAlphaColorRec.Orange;
//  FItemGrid.Material.DrawCheckBoxColorMaterial.DrawCheckRectParam.DrawEffectSetting.PushedEffect.EffectTypes := [drpetBorderColorChange];
//
//  FItemGrid.Material.Init(False,
//                          $FF799CB0,
//                          $FF8AADC8,
//                          BlackColor,
//                          $FFF5F5F5,
//                          $FFE0E0E0,
//                          WhiteColor,
//                          $FFEDEDED,
//                          $FFA0A0A0);
//
//
//
//  //添加数据行
//  FItemGrid.Prop.Items.BeginUpdate;
//  try
//    ARow:=FItemGrid.Prop.Items.Add;
//    ARow.Caption:='Caption 1';
//    ARow.Detail:='Detail 1';
//    ARow.Detail1:='Detail1 1';
//    ARow.Detail2:='Detail2 1';
//    ARow.Detail3:='Detail3 1';
////    ARow.Icon.LoadFromFile('E:\1_delphiteacher.jpg');
//    ARow.Checked:=True;
//
//
//    ARow:=FItemGrid.Prop.Items.Add;
//    ARow.Caption:='Caption 2';
//    ARow.Detail:='Detail 2';
//    ARow.Detail1:='Detail1 2';
//    ARow.Detail2:='Detail2 2';
//    ARow.Detail3:='Detail3 2';
//    ARow.Icon.Url:='http://avatar.csdn.net/7/9/6/1_delphiteacher.jpg';
//
//
//    ARow:=FItemGrid.Prop.Items.Add;
//    ARow.Caption:='Caption 3';
//    ARow.Detail:='Detail 3';
//    ARow.Detail1:='Detail1 3';
//    ARow.Detail2:='Detail2 3';
//    ARow.Detail3:='Detail3 3';
//    ARow.Checked:=True;
//  finally
//    FItemGrid.Prop.Items.EndUpdate;
//  end;
//
//
//
//  //添加表格列
//  FItemGrid.Prop.Columns.BeginUpdate;
//  try
//    AColumn:=FItemGrid.Prop.Columns.Add;
//    AColumn.Caption:='列1';
//    AColumn.ItemDataType:=idtCaption;
//    AColumn.FooterValue:='统计:';
//    AColumn.FooterValueType:=fvtStatic;
//
//    AColumn:=FItemGrid.Prop.Columns.Add;
//    AColumn.Caption:='列2';
//    AColumn.ItemDataType:=idtDetail;
//    AColumn.FooterValue:='b';
//    AColumn.FooterValueType:=fvtStatic;
//
//    AColumn:=FItemGrid.Prop.Columns.Add;
//    AColumn.Caption:='列3';
//    AColumn.ItemDataType:=idtDetail1;
//
//    AColumn:=FItemGrid.Prop.Columns.Add;
//    AColumn.Caption:='列4';
//    AColumn.ItemDataType:=idtDetail2;
//    AColumn.FooterValue:='c';
//    AColumn.FooterValueType:=fvtStatic;
//    AColumn.ItemDataType1:=idtDetail3;
//    AColumn.IsUseDefaultGridColumnMaterial:=False;
//    AColumn.SelfOwnMaterial.Assign(Self.FItemGrid.Material.DrawColumnMaterial);
//    AColumn.SelfOwnMaterial.DrawCellTextParam.FontVertAlign:=fvaTop;
//    AColumn.SelfOwnMaterial.DrawCellText1Param.FontColor:=RedColor;
//    AColumn.SelfOwnMaterial.DrawCellText1Param.FontVertAlign:=fvaBottom;
//    AColumn.SelfOwnMaterial.DrawCellText1Param.FontHorzAlign:=fhaCenter;
//
//    AColumn:=FItemGrid.Prop.Columns.Add;
//    AColumn.Caption:='列5';
//    AColumn.ItemDataType:=idtIcon;
//
//    AColumn:=FItemGrid.Prop.Columns.Add;
//    AColumn.Caption:='列6';
//    AColumn.ItemDataType:=idtChecked;
//
//  finally
//    FItemGrid.Prop.Columns.EndUpdate;
//  end;

end;

procedure TFrameItemGrid.SkinFMXItemGrid1ClickCell(Sender: TObject;
  ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem);
begin
  if ACol.ReadOnly then
  begin
    ShowMessage(Self.SkinFMXItemGrid1.Prop.GetGridCellText(ACol,ARow));
  end;


//  //点击单元格编辑
//  Self.SkinFMXItemGrid1.Prop.StartEditingItem(
//        ARow,
//        Self.Edit1,
//        RectF(100,10,200,30),
//        '123',
//        0,0
//        );
end;

procedure TFrameItemGrid.SkinFMXItemGrid1GetCellDisplayText(Sender: TObject;
  ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem; var ADisplayText: string);
begin
  //
end;

procedure TFrameItemGrid.SkinFMXItemGrid1GetFooterCellDisplayText(
  Sender: TObject; ACol: TSkinVirtualGridColumn; AFooterRowIndex: Integer;
  var ADisplayText: string);
begin
  //
end;

end.
