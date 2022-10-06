unit ListItemStyleFrame_IntendWordItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,

  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinMaterial;

type
  TFrameListItemStyle_IntendWordItem = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    labIntendWord: TSkinFMXLabel;
    labDelete: TSkinFMXLabel;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListItemStyle_IntendWordItem }

function TFrameListItemStyle_IntendWordItem.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

initialization
  RegisterListItemStyle('IntendWordItem',TFrameListItemStyle_IntendWordItem);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_IntendWordItem);

end.
