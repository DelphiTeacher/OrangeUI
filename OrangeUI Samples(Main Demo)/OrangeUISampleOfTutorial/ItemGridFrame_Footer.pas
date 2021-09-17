unit ItemGridFrame_Footer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinFireMonkeyItemGrid, uDrawCanvas,
  uSkinItems, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel;

type
  TFrameItemGrid_Footer = class(TFrame)
    SkinFMXItemGrid1: TSkinFMXItemGrid;
    idpOperation: TSkinFMXItemDesignerPanel;
    btnDelRow: TSkinFMXButton;
    procedure btnDelRowClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameItemGrid_Footer.btnDelRowClick(Sender: TObject);
begin
  Self.SkinFMXItemGrid1.Prop.Items.Remove(Self.SkinFMXItemGrid1.Prop.InteractiveItem);
end;

end.
