unit ListItemStyleFrame_GameGiftPackage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,


  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinPanelType,
  uSkinFireMonkeyPanel;

type
  TFrameListItemStyle_GameGiftPackage = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgIcon: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    btnTake: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    imgGoods1: TSkinFMXImage;
    lblGoods1: TSkinFMXLabel;
    imgGoods2: TSkinFMXImage;
    lblGoods12: TSkinFMXLabel;
    imgGoods3: TSkinFMXImage;
    lblGoods3: TSkinFMXLabel;
    SkinFMXButton2: TSkinFMXButton;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrame1 }

function TFrameListItemStyle_GameGiftPackage.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;

end;




initialization
  RegisterListItemStyle('GameGiftPackage',TFrameListItemStyle_GameGiftPackage);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_GameGiftPackage);

end.
