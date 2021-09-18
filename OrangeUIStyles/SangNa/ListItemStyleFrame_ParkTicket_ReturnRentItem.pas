//convert pas to utf8 by ¥
unit ListItemStyleFrame_ParkTicket_ReturnRentItem;

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
  TFrameListItemStyle_ParkTicket_ReturnRentItem = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    btnDec: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnAdd: TSkinFMXButton;
    cbIsSelected: TSkinFMXCheckBox;
    lblItemDetail3: TSkinFMXLabel;
    btnDelete: TSkinFMXButton;
    lblCookTypeHint: TSkinFMXLabel;
    lblCaption: TSkinFMXLabel;
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



{ TFrameListItemStyleFrame_ParkTicket_ReturnRentItem }

constructor TFrameListItemStyle_ParkTicket_ReturnRentItem.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;



end;

function TFrameListItemStyle_ParkTicket_ReturnRentItem.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ParkTicket_ReturnRentItem',TFrameListItemStyle_ParkTicket_ReturnRentItem);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ParkTicket_ReturnRentItem);

end.
