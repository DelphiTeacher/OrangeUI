unit ListItemStyleFrame_ScoreExchangeActivity;

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
  uSkinFireMonkeyPanel, uDrawPicture, uSkinImageList;

type
  TFrameListItemStyle_ScoreExchangeActivity = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXButton2: TSkinFMXButton;
    imgBackGround: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    btnTake: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    imgIcon: TSkinFMXImage;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinImageList1: TSkinImageList;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrame1 }

function TFrameListItemStyle_ScoreExchangeActivity.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;

end;




initialization
  RegisterListItemStyle('ScoreExchangeActivity',TFrameListItemStyle_ScoreExchangeActivity);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ScoreExchangeActivity);

end.
