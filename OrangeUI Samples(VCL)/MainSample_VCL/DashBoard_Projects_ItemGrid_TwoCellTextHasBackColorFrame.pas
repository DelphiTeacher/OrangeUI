unit DashBoard_Projects_ItemGrid_TwoCellTextHasBackColorFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,

  System.Types,
//  uDrawCanvas,
  uDrawParam,
  uSkinItemDesignerPanelType,
  uGraphicCommon,
  uComponentType,

  ListItemStyle_TwoIconButton,

  //公共素材模块
  EasyServiceCommonMaterialDataMoudle_VCL,

  uSkinWindowsControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinPanelType, Vcl.StdCtrls,
  uSkinButtonType;

type
  TFrameItemGrid_TwoCellTextHasBackColor = class(TFrame)
    gridData: TSkinWinItemGrid;
    pnlClient: TSkinWinPanel;
    lblCaption: TLabel;
    SkinWinButton1: TSkinWinButton;
    procedure gridDataResize(Sender: TObject);
    procedure gridDataCustomPaintCellBegin(ACanvas: TDrawCanvas;
      ARowIndex: Integer; ARow: TBaseSkinItem; ARowDrawRect: TRectF;
      AColumn: TSkinVirtualGridColumn; AColumnIndex: Integer;
      ACellDrawRect: TRectF; ARowEffectStates: TDPEffectStates;
      ASkinVirtualGridMaterial: TSkinVirtualGridDefaultMaterial;
      ADrawColumnMaterial: TSkinVirtualGridColumnMaterial;
      ASkinItemColDesignerPanel: TSkinItemDesignerPanel;
      const ADrawRect: TRectF; AVirtualGridPaintData: TPaintData);
    procedure gridDataCustomPaintCellEnd(ACanvas: TDrawCanvas;
      ARowIndex: Integer; ARow: TBaseSkinItem; ARowDrawRect: TRectF;
      AColumn: TSkinVirtualGridColumn; AColumnIndex: Integer;
      ACellDrawRect: TRectF; ARowEffectStates: TDPEffectStates;
      ASkinVirtualGridMaterial: TSkinVirtualGridDefaultMaterial;
      ADrawColumnMaterial: TSkinVirtualGridColumnMaterial;
      ASkinItemColDesignerPanel: TSkinItemDesignerPanel;
      const ADrawRect: TRectF; AVirtualGridPaintData: TPaintData);
  private
    { Private declarations }
  public
    FOldFontColor:TDelphiColor;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrameItemGrid_TwoCellTextHasBackColor.gridDataCustomPaintCellBegin(
  ACanvas: TDrawCanvas; ARowIndex: Integer; ARow: TBaseSkinItem;
  ARowDrawRect: TRectF; AColumn: TSkinVirtualGridColumn; AColumnIndex: Integer;
  ACellDrawRect: TRectF; ARowEffectStates: TDPEffectStates;
  ASkinVirtualGridMaterial: TSkinVirtualGridDefaultMaterial;
  ADrawColumnMaterial: TSkinVirtualGridColumnMaterial;
  ASkinItemColDesignerPanel: TSkinItemDesignerPanel; const ADrawRect: TRectF;
  AVirtualGridPaintData: TPaintData);
var
  AStatus:String;
begin
  FOldFontColor:=ADrawColumnMaterial.DrawCellText1Param.DrawFont.FontColor.FColor;
  if AColumn.GetBindItemFieldName='ItemDetail1' then
  begin
    //状态
    AStatus:=Self.gridData.Prop.GetGridCellText1(AColumn,ARow);
//  FSkinVirtualChart.SelfOwnMaterialToDefault.FPieColorArray[0]:=$97CF0A;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.FPieColorArray[1]:=$F57C72;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.FPieColorArray[2]:=$7C5CFA;
    if AStatus='进行中' then
    begin
      ADrawColumnMaterial.DrawCellText1Param.DrawFont.FontColor.FColor:=OrangeColor;
    end;
    if AStatus='已完成' then
    begin
      ADrawColumnMaterial.DrawCellText1Param.DrawFont.FontColor.FColor:=$97CF0A;
    end;
    if AStatus='已超期' then
    begin
      ADrawColumnMaterial.DrawCellText1Param.DrawFont.FontColor.FColor:=$7C5CFA;
    end;

  end;

end;

procedure TFrameItemGrid_TwoCellTextHasBackColor.gridDataCustomPaintCellEnd(
  ACanvas: TDrawCanvas; ARowIndex: Integer; ARow: TBaseSkinItem;
  ARowDrawRect: TRectF; AColumn: TSkinVirtualGridColumn; AColumnIndex: Integer;
  ACellDrawRect: TRectF; ARowEffectStates: TDPEffectStates;
  ASkinVirtualGridMaterial: TSkinVirtualGridDefaultMaterial;
  ADrawColumnMaterial: TSkinVirtualGridColumnMaterial;
  ASkinItemColDesignerPanel: TSkinItemDesignerPanel; const ADrawRect: TRectF;
  AVirtualGridPaintData: TPaintData);
begin
  ADrawColumnMaterial.DrawCellText1Param.DrawFont.FontColor.FColor:=FOldFontColor;
end;

procedure TFrameItemGrid_TwoCellTextHasBackColor.gridDataResize(Sender: TObject);
begin
  //如果表格列是按比例的,那么每次拖动尺寸,都要重新计算
  //Self.gridData.Prop.Columns.GetListLayoutsManager.DoItemSizeChange(nil);
end;

end.
