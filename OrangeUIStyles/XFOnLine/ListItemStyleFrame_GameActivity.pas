unit ListItemStyleFrame_GameActivity;

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
  TFrameListItemStyle_GameActivity = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgGoods1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    btnTake: TSkinFMXButton;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXButton2: TSkinFMXButton;
    SkinFMXLabel3: TSkinFMXLabel;
    imgGoods2: TSkinFMXImage;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    imgGoods3: TSkinFMXImage;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrame1 }

function TFrameListItemStyle_GameActivity.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;

end;




initialization
  RegisterListItemStyle('GameActivity',TFrameListItemStyle_GameActivity);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_GameActivity);

end.
