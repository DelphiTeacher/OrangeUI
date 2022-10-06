unit ListItemStyleFrame_SubscribeShopItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,

  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinMaterial, uDrawPicture,
  uSkinImageList, uSkinCheckBoxType, uSkinFireMonkeyCheckBox;

type
  TFrameListItemStyle_SubscribeShopItem = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    pnlUser: TSkinFMXPanel;
    pnlPostContainer: TSkinFMXPanel;
    pnlUserInfo: TSkinFMXPanel;
    labUserName: TSkinFMXLabel;
    pnlUserHead: TSkinFMXPanel;
    pnlUserContainer: TSkinFMXPanel;
    imgUserHead: TSkinFMXImage;
    pnlItemDetail: TSkinFMXPanel;
    pnlClue: TSkinFMXPanel;
    labKeyWordContent: TSkinFMXLabel;
    labClueCount: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    imglistExpanded: TSkinImageList;
    imgAccessory: TSkinFMXImage;
    pnlAccount: TSkinFMXPanel;
    SkinFMXLabel2: TSkinFMXLabel;
    labAccount: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    labCountry: TSkinFMXLabel;
    pnlCreatetime: TSkinFMXPanel;
    SkinFMXLabel6: TSkinFMXLabel;
    labCreatetime: TSkinFMXLabel;
    chkIsChecked: TSkinFMXCheckBox;
    pnlContainer: TSkinFMXPanel;
    pnlCancel: TSkinFMXPanel;
    btnCancel: TSkinFMXButton;
    pnlCountry: TSkinFMXPanel;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListItemStyle_SubscribeShopItem }

function TFrameListItemStyle_SubscribeShopItem.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

initialization
  RegisterListItemStyle('SubscribeShopItem',TFrameListItemStyle_SubscribeShopItem);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SubscribeShopItem);

end.
