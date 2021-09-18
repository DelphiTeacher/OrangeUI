//convert pas to utf8 by ¥
unit ListItemStyleFrame_GameInfoDetails;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage, uSkinButtonType, uSkinNotifyNumberIconType,
  uSkinFireMonkeyNotifyNumberIcon;


type
  //根基类
  TFrameListItemStyle_GameInfoDetails = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblDengJi: TSkinFMXLabel;
    lblShengWang: TSkinFMXLabel;
    lblDengJiDetail: TSkinFMXLabel;
    lblShengWangDetail: TSkinFMXLabel;
    lblNowExperience: TSkinFMXLabel;
    lblNowExperienceDetail: TSkinFMXLabel;
    lblNeedExperience: TSkinFMXLabel;
    lblNeedExperienceDetail: TSkinFMXLabel;
    lblTiLiZhi: TSkinFMXLabel;
    lblTiLiZhiDetail: TSkinFMXLabel;
    lblMoFaZhi: TSkinFMXLabel;
    lblMoFaZhiDetail: TSkinFMXLabel;
    lblChuangShiBi: TSkinFMXLabel;
    lblChuangShiBiDetail: TSkinFMXLabel;
    lblYuanBao: TSkinFMXLabel;
    lblYuanBaoDetail: TSkinFMXLabel;
    lblZhiYe: TSkinFMXLabel;
    lblZhiYeDetail: TSkinFMXLabel;
    lblChongZhiJiFen: TSkinFMXLabel;
    lblChongZhiJiFenDetail: TSkinFMXLabel;
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

{ TFrameBaseListItemStyle }

constructor TFrameListItemStyle_GameInfoDetails.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;

end;

function TFrameListItemStyle_GameInfoDetails.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

initialization
  RegisterListItemStyle('GameInfoDetails',TFrameListItemStyle_GameInfoDetails);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_GameInfoDetails);

end.
