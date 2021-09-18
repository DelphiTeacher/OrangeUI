//convert pas to utf8 by ¥
unit ListItemStyleFrame_SangNa_Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
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
  //桑拿项目房态
  TFrameListItemStyle_SangNa_Item = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemDetail1_2: TSkinFMXMultiColorLabel;
    imglistAdd: TSkinImageList;
    btnDec: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnAdd: TSkinFMXButton;
    cbIsSelected: TSkinFMXCheckBox;
    btnSelectCookType: TSkinFMXButton;
    lblItemDetail3: TSkinFMXLabel;
    btnDelete: TSkinFMXButton;
    lblCookTypeHint: TSkinFMXLabel;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameListItemStyleFrame_SangNa_Item }

constructor TFrameListItemStyle_SangNa_Item.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;



end;

function TFrameListItemStyle_SangNa_Item.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('SangNa_Item',TFrameListItemStyle_SangNa_Item);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SangNa_Item);

end.
