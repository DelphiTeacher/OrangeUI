﻿//convert pas to utf8 by ¥
unit ListItemStyleFrame_SangNa_LastLeaveRoom;

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
  TFrameListItemStyle_SangNa_LastLeaveRoom = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblDetail: TSkinFMXLabel;
    lblCaption: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    lblDetail6: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
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



{ TFrameListItemStyleFrame_SangNa_LastLeaveRoom }

constructor TFrameListItemStyle_SangNa_LastLeaveRoom.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_SangNa_LastLeaveRoom.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('SangNa_LastLeaveRoom',TFrameListItemStyle_SangNa_LastLeaveRoom);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SangNa_LastLeaveRoom);

end.
