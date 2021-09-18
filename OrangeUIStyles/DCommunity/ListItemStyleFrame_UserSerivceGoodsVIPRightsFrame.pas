//convert pas to utf8 by ¥
unit ListItemStyleFrame_UserSerivceGoodsVIPRightsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinImageType, uSkinFireMonkeyImage,
  FMX.Objects, uSkinPanelType, uSkinFireMonkeyPanel;


type
  //根基类
  TFrameListItemStyle_UserSerivceGoodsVIPRights = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblGoodsName: TSkinFMXLabel;
    imgGoodsIcon: TSkinFMXImage;
    lblGoodsPriceArea: TSkinFMXLabel;
    btnEditGoods: TSkinFMXButton;
    btnGoodsInfo: TSkinFMXButton;
    lblSumStorage: TSkinFMXLabel;
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



{ TFrameListItemStyle_UserSerivceGoodsVIPRights }

constructor TFrameListItemStyle_UserSerivceGoodsVIPRights.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_UserSerivceGoodsVIPRights.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('UserSerivceGoodsVIPRights',TFrameListItemStyle_UserSerivceGoodsVIPRights);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_UserSerivceGoodsVIPRights);

end.
