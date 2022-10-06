unit DashBoard_Analyse_ItemGrid_MutliColorProgressBarColumnFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,

  System.Types,

  uGraphicCommon,
  uSkinItemDesignerPanelType,
  uDrawParam,
  uComponentType,
  ListItemStyle_ProgressBar,
  //公共素材模块
  EasyServiceCommonMaterialDataMoudle_VCL,
  uSkinProgressBarType,

  uSkinWindowsControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinButtonType, Vcl.StdCtrls,
  uSkinPanelType;

type
  TFrameItemGrid_MultiColorProgressBarColumn = class(TFrame)
    pnlClient: TSkinWinPanel;
    lblCaption: TLabel;
    gridData: TSkinWinItemGrid;
    SkinWinButton1: TSkinWinButton;
    procedure gridDataResize(Sender: TObject);
    procedure gridDataPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItem: TBaseSkinItem; AItemDrawRect: TRect);
    procedure gridDataCustomPaintCellBegin(ACanvas: TDrawCanvas;
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
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TFrameItemGrid_MultiColorProgressBarColumn.Create(
  AOwner: TComponent);
begin
  inherited;
end;

procedure TFrameItemGrid_MultiColorProgressBarColumn.gridDataCustomPaintCellBegin(
  ACanvas: TDrawCanvas; ARowIndex: Integer; ARow: TBaseSkinItem;
  ARowDrawRect: TRectF; AColumn: TSkinVirtualGridColumn; AColumnIndex: Integer;
  ACellDrawRect: TRectF; ARowEffectStates: TDPEffectStates;
  ASkinVirtualGridMaterial: TSkinVirtualGridDefaultMaterial;
  ADrawColumnMaterial: TSkinVirtualGridColumnMaterial;
  ASkinItemColDesignerPanel: TSkinItemDesignerPanel; const ADrawRect: TRectF;
  AVirtualGridPaintData: TPaintData);
const
  PROGRESSBAR_COLORS:array [0..3] of integer=($00F57C72,$00D1AF39,$0000BCFF,$007C5CFA);
begin
  //自定义进度条的颜色
  if AColumn.GetBindItemFieldName='ItemDetail1' then
  begin
    if ASkinItemColDesignerPanel<>nil then
    begin
      //TFrameListItemStyle_ProgressBar(ASkinItemColDesignerPanel.Parent).SkinWinProgressBar1.Prop.StaticPosition:=20;
      TSkinProgressBarColorMaterial(TFrameListItemStyle_ProgressBar(ASkinItemColDesignerPanel.Parent).SkinWinProgressBar1.SelfOwnMaterial).ForeColor.FillColor.FColor:=PROGRESSBAR_COLORS[ARowIndex mod 4];
    end;
  end;
end;

procedure TFrameItemGrid_MultiColorProgressBarColumn.gridDataPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas; AItem: TBaseSkinItem;
  AItemDrawRect: TRect);
begin
  //



end;

procedure TFrameItemGrid_MultiColorProgressBarColumn.gridDataResize(
  Sender: TObject);
begin
  //如果表格列是按比例的,那么每次拖动尺寸,都要重新计算
  Self.gridData.Prop.Columns.GetListLayoutsManager.DoItemSizeChange(nil);

end;

end.
