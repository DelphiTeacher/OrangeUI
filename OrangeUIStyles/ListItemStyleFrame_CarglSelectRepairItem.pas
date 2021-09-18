//convert pas to utf8 by ¥
unit ListItemStyleFrame_CarglSelectRepairItem;

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
  TFrameCarglSelectRepairItemListItemStyle = class(TFrameBaseListItemStyleBase,IFrameBaseListItemStyle)
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
  private
    { Private declarations }
  public
//    function GetItemDesignerPanel:TSkinItemDesignerPanel;override;
    { Public declarations }
  end;


implementation

{$R *.fmx}

{ TFrameCarglSelectRepairItemListItemStyle }

//function TFrameCarglSelectRepairItemListItemStyle.GetItemDesignerPanel: TSkinItemDesignerPanel;
//begin
//  Result:=Inherited;
//end;

initialization
  RegisterListItemStyle('CarglSelectRepairItem',TFrameCarglSelectRepairItemListItemStyle);


finalization
  UnRegisterListItemStyle(TFrameCarglSelectRepairItemListItemStyle);

end.
