//convert pas to utf8 by ¥
unit ListItemStyleFrame_CarglSelectRepairMaterial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  BaseListItemStyleFrame,

  ListItemStyleFrame_Base, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinMultiColorLabelType,
  uSkinFireMonkeyMultiColorLabel;

type
  TFrameCarglSelectRepairMaterialListItemStyle = class(TFrameBaseListItemStyleBase,IFrameBaseListItemStyle)
    lblItemDetail: TSkinFMXLabel;
  private
    { Private declarations }
  public
//    function GetItemDesignerPanel:TSkinItemDesignerPanel;override;
    { Public declarations }
  end;


implementation

{$R *.fmx}

{ TFrameCarglSelectRepairMaterialListItemStyle }

//function TFrameCarglSelectRepairMaterialListItemStyle.GetItemDesignerPanel: TSkinItemDesignerPanel;
//begin
//  Result:=Inherited;
//end;

initialization
  RegisterListItemStyle('CarglSelectRepairMaterial',TFrameCarglSelectRepairMaterialListItemStyle);


finalization
  UnRegisterListItemStyle(TFrameCarglSelectRepairMaterialListItemStyle);

end.
