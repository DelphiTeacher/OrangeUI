unit ListItemStyleFrame_SignDay;

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
  uSkinFireMonkeyPanel, uDrawPicture, uSkinImageList, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox;

type
  TFrameListItemStyle_SignDay = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    labday: TSkinFMXLabel;
    ckbxSelect: TSkinFMXCheckBox;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrame1 }

function TFrameListItemStyle_SignDay.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;

end;




initialization
  RegisterListItemStyle('SignDay',TFrameListItemStyle_SignDay);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SignDay);

end.
