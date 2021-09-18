﻿//convert pas to utf8 by ¥
unit ListItemStyleFrame_SangNa_TechnicinaInfo;

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
  TFrameListItemStyle_SangNa_TechnicinaInfo = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    pnlTop: TSkinFMXPanel;
    lblCaption: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
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



{ TFrameListItemStyleFrame_SangNa_TechnicinaInfo }

constructor TFrameListItemStyle_SangNa_TechnicinaInfo.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_SangNa_TechnicinaInfo.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('SangNa_TechnicinaInfo',TFrameListItemStyle_SangNa_TechnicinaInfo);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SangNa_TechnicinaInfo);

end.
