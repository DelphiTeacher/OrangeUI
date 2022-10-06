unit ListItemStyleFrame_SubscribeKeyWordItem;

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
  TFrameListItemStyle_SubscribeKeyWordItem = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    pnlUser: TSkinFMXPanel;
    pnlPostContainer: TSkinFMXPanel;
    pnlUserInfo: TSkinFMXPanel;
    labKeyWordDetail: TSkinFMXLabel;
    pnlItemDetail: TSkinFMXPanel;
    pnlClue: TSkinFMXPanel;
    labKeyWordContent: TSkinFMXLabel;
    labClueCount: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    imglistExpanded: TSkinImageList;
    imgAccessory: TSkinFMXImage;
    SkinFMXLabel4: TSkinFMXLabel;
    labCountry: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    labCreatetime: TSkinFMXLabel;
    labKeyWord: TSkinFMXLabel;
    chkIsChecked: TSkinFMXCheckBox;
    pnlContainer: TSkinFMXPanel;
    pnlCancel: TSkinFMXPanel;
    btnCancel: TSkinFMXButton;
    pnlCountry: TSkinFMXPanel;
    pnlCreatetime: TSkinFMXPanel;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListItemStyle_SubscribeKeyWordItem }

function TFrameListItemStyle_SubscribeKeyWordItem.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

initialization
  RegisterListItemStyle('SubscribeKeyWordItem',TFrameListItemStyle_SubscribeKeyWordItem);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SubscribeKeyWordItem);

end.
