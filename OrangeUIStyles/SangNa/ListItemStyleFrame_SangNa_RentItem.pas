// convert pas to utf8 by ¥
unit ListItemStyleFrame_SangNa_RentItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, uSkinButtonType, uSkinFireMonkeyButton,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uDrawPicture,
  uSkinImageList;

type
  // 桑拿项目房态
  TFrameListItemStyle_SangNa_RentItem = class(TFrame, IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemDetail2_1: TSkinFMXMultiColorLabel;
    imglistAdd: TSkinImageList;
    btnDec: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnAdd: TSkinFMXButton;
    cbIsSelected: TSkinFMXCheckBox;
    btnSelectCookType: TSkinFMXButton;
    lblItemDetail3: TSkinFMXLabel;
    btnDelete: TSkinFMXButton;
    lblCookTypeHint: TSkinFMXLabel;
    lblItemDetail2_2: TSkinFMXMultiColorLabel;
    lblItemDetail2_3: TSkinFMXMultiColorLabel;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  public
    function GetItemDesignerPanel: TSkinItemDesignerPanel; virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}
{ TFrameListItemStyleFrame_SangNa_RentItem }

constructor TFrameListItemStyle_SangNa_RentItem.Create(AOwner: TComponent);
begin
  inherited;

  // ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  // 避免Client拉伸不了
  ItemDesignerPanel.Align := TAlignLayout.None;

end;

function TFrameListItemStyle_SangNa_RentItem.GetItemDesignerPanel
  : TSkinItemDesignerPanel;
begin
  Result := ItemDesignerPanel;
end;

initialization

RegisterListItemStyle('SangNa_RentItem', TFrameListItemStyle_SangNa_RentItem);

finalization

UnRegisterListItemStyle(TFrameListItemStyle_SangNa_RentItem);

end.
