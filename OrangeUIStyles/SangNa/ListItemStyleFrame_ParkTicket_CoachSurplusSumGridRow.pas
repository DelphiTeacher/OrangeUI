﻿//convert pas to utf8 by ¥
unit ListItemStyleFrame_ParkTicket_CoachSurplusSumGridRow;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, uSkinButtonType, uSkinFireMonkeyButton;


type
  //桑拿项目房态
  TFrameListItemStyle_ParkTicket_CoachSurplusSumGridRow = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblDetail1: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    lblCaption: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail4: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameListItemStyleFrame_ParkTicket_CoachSurplusSumGridRow }

constructor TFrameListItemStyle_ParkTicket_CoachSurplusSumGridRow.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ParkTicket_CoachSurplusSumGridRow.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ParkTicket_CoachSurplusSumGridRow',TFrameListItemStyle_ParkTicket_CoachSurplusSumGridRow);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ParkTicket_CoachSurplusSumGridRow);

end.
