//convert pas to utf8 by ¥
unit ListItemStyleFrame_ScoreExchangeGoods;

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
  uSkinFireMonkeyImage, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinButtonType, uSkinFireMonkeyButton;


type
  //根基类
  TFrameListItemStyle_ScoreExchangeGoods = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblGoodsName: TSkinFMXLabel;
    imgGoodsIcon: TSkinFMXImage;
    lblMonth: TSkinFMXLabel;
    btnDesc: TSkinFMXButton;
    btnAdd: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    lblRate: TSkinFMXLabel;
    mcPrice: TSkinFMXMultiColorLabel;
    imgGoodsSign: TSkinFMXImage;
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

constructor TFrameListItemStyle_ScoreExchangeGoods.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ScoreExchangeGoods.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ScoreExchangeGoods',TFrameListItemStyle_ScoreExchangeGoods);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ScoreExchangeGoods);

end.
