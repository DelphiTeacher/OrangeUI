unit ListItemStyleFrame_SelectedCloth;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,

  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uDrawCanvas, uSkinItems, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinFireMonkeyItemGrid,
  uSkinLabelType, uSkinFireMonkeyLabel;

type
  TFrameListItemStyle_SelectedCloth = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblModelNO: TSkinFMXLabel;
    gridColorAndCount: TSkinFMXItemGrid;
    lblSummary: TSkinFMXLabel;
    procedure ItemDesignerPanelResize(Sender: TObject);
  private
    function GetItemDesignerPanel:TSkinItemDesignerPanel;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListItemStyle_SelectedCloth }

function TFrameListItemStyle_SelectedCloth.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;


procedure TFrameListItemStyle_SelectedCloth.ItemDesignerPanelResize(
  Sender: TObject);
begin
  Self.gridColorAndCount.Prop.Columns.BeginUpdate;
  try
    Self.gridColorAndCount.Prop.Columns[0].Width:=(Self.ItemDesignerPanel.Width-Self.imgItemIcon.Margins.Left-Self.imgItemIcon.Width-Self.lblModelNO.Width-Self.lblSummary.Width) / 8;
    Self.gridColorAndCount.Prop.Columns[1].Width:=Self.gridColorAndCount.Prop.Columns[0].Width;
    Self.gridColorAndCount.Prop.Columns[2].Width:=Self.gridColorAndCount.Prop.Columns[0].Width;
    Self.gridColorAndCount.Prop.Columns[3].Width:=Self.gridColorAndCount.Prop.Columns[0].Width;
    Self.gridColorAndCount.Prop.Columns[4].Width:=Self.gridColorAndCount.Prop.Columns[0].Width;
    Self.gridColorAndCount.Prop.Columns[5].Width:=Self.gridColorAndCount.Prop.Columns[0].Width;
    Self.gridColorAndCount.Prop.Columns[6].Width:=Self.gridColorAndCount.Prop.Columns[0].Width;
    Self.gridColorAndCount.Prop.Columns[7].Width:=Self.gridColorAndCount.Prop.Columns[0].Width;
  finally
    Self.gridColorAndCount.Prop.Columns.EndUpdate;
  end;
end;

initialization
  RegisterListItemStyle('SelectedCloth',TFrameListItemStyle_SelectedCloth);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SelectedCloth);

end.
