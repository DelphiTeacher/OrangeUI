﻿//convert pas to utf8 by ¥
unit ListItemStyleFrame_SangNa_VIPConsumeHabitGridRow;

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
  uSkinFireMonkeyCheckBox;


type
  //桑拿项目房态
  TFrameListItemStyle_SangNa_VIPConsumeHabitGridRow = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblDetail: TSkinFMXLabel;
    lblCaption: TSkinFMXLabel;
    lblDetail4: TSkinFMXLabel;
    lblDetail6: TSkinFMXLabel;
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



{ TFrameListItemStyleFrame_SangNa_VIPConsumeHabitGridRow }

constructor TFrameListItemStyle_SangNa_VIPConsumeHabitGridRow.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_SangNa_VIPConsumeHabitGridRow.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('SangNa_VIPConsumeHabitGridRow',TFrameListItemStyle_SangNa_VIPConsumeHabitGridRow);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SangNa_VIPConsumeHabitGridRow);

end.
