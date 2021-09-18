unit ListItemStyleFrame_GameList;

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
  TFrameListItemStyle_GameList = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgIcon: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    btnTake: TSkinFMXButton;
    SkinFMXPanel2: TSkinFMXPanel;
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

function TFrameListItemStyle_GameList.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;

end;

initialization
  RegisterListItemStyle('GameList',TFrameListItemStyle_GameList);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_GameList);

end.
