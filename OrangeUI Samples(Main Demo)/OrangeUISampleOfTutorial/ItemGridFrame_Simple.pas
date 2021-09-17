unit ItemGridFrame_Simple;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinFireMonkeyEdit,
  uComponentType,
//  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinFireMonkeyItemGrid, uDrawCanvas,
  uSkinItems, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinPanelType, uSkinFireMonkeyPanel;

type
  TFrameItemGrid_Simple = class(TFrame)
    SkinFMXItemGrid1: TSkinFMXItemGrid;
    SkinFMXPanel1: TSkinFMXPanel;
    btnTestColumnAutoSize: TSkinFMXButton;
    procedure SkinFMXItemGrid1StartEditingItem(Sender: TObject;
      AItem: TBaseSkinItem; AEditControl: TFmxObject);
    procedure SkinFMXItemGrid1ClickColumn(Sender: TObject;
      ACol: TSkinVirtualGridColumn);
    procedure btnTestColumnAutoSizeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameItemGrid_Simple.btnTestColumnAutoSizeClick(Sender: TObject);
var
  ASkinItem:TSkinItem;
begin
  Self.SkinFMXItemGrid1.Prop.Items.BeginUpdate;
  try
    ASkinItem:=Self.SkinFMXItemGrid1.Prop.Items.Add;

    ASkinItem.Caption:='测试';
    ASkinItem.Detail:='测试员测试员测试员测试员测试员测试员';

  finally
    Self.SkinFMXItemGrid1.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameItemGrid_Simple.SkinFMXItemGrid1ClickColumn(Sender: TObject;
  ACol: TSkinVirtualGridColumn);
begin
  ShowMessage(ACol.Caption);
end;

procedure TFrameItemGrid_Simple.SkinFMXItemGrid1StartEditingItem(
  Sender: TObject; AItem: TBaseSkinItem; AEditControl: TFmxObject);
begin
  //单元格编辑时不允许拖动
  if AEditControl is TSkinEdit then
  begin

    TSkinEdit(AEditControl).ParentMouseEvent:=False;
    TSkinEdit(AEditControl).MouseEventTransToParentType:=mettptNotTrans;
  end;
  
end;

end.
