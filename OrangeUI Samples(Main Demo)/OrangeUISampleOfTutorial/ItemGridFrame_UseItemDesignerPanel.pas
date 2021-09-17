unit ItemGridFrame_UseItemDesignerPanel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinFireMonkeyItemGrid,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinButtonType,
  uSkinFireMonkeyButton, uDrawCanvas, uSkinItems, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinPanelType, uSkinFireMonkeyPanel, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox;

type
  TFrameItemGrid_UseItemDesignerPanel = class(TFrame)
    SkinFMXItemGrid1: TSkinFMXItemGrid;
    idpOperation: TSkinFMXItemDesignerPanel;
    btnDelRow: TSkinFMXButton;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    chkColor1: TSkinFMXCheckBox;
    SkinFMXItemDesignerPanel2: TSkinFMXItemDesignerPanel;
    SkinFMXCheckBox1: TSkinFMXCheckBox;
    procedure SkinFMXItemGrid1PrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItem: TBaseSkinItem; AItemDrawRect: TRect);
    procedure btnDelRowClick(Sender: TObject);
    procedure SkinFMXItemGrid1ClickCell(Sender: TObject;
      ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameItemGrid_UseItemDesignerPanel.btnDelRowClick(Sender: TObject);
begin
  //删除所在行
  Self.SkinFMXItemGrid1.Prop.Items.Remove(SkinFMXItemGrid1.Prop.InteractiveItem);
end;

procedure TFrameItemGrid_UseItemDesignerPanel.SkinFMXItemGrid1ClickCell(
  Sender: TObject; ACol: TSkinVirtualGridColumn; ARow: TBaseSkinItem);
begin
  //

end;

procedure TFrameItemGrid_UseItemDesignerPanel.SkinFMXItemGrid1PrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas; AItem: TBaseSkinItem;
  AItemDrawRect: TRect);
begin
  //
  if TSkinItem(AItem).Caption='张三' then
  begin
    Self.btnDelRow.Enabled:=True;
  end
  else
  begin
    Self.btnDelRow.Enabled:=False;
  end;

end;

end.
