﻿//convert pas to utf8 by ¥
unit ListItemStyleFrame_SangNaTech_AchievementChartDetailGridRow;

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
  TFrameListItemStyle_SangNaTech_AchievementChartDetailGridRow = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    lblHandCode: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
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



{ TFrameListItemStyleFrame_SangNaTech_AchievementChartDetailGridRow }

constructor TFrameListItemStyle_SangNaTech_AchievementChartDetailGridRow.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_SangNaTech_AchievementChartDetailGridRow.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('SangNaTech_AchievementChartDetailGridRow',TFrameListItemStyle_SangNaTech_AchievementChartDetailGridRow);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SangNaTech_AchievementChartDetailGridRow);

end.
