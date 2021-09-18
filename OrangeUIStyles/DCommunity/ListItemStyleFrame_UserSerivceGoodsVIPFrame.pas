//convert pas to utf8 by ¥
unit ListItemStyleFrame_UserSerivceGoodsVIPFrame;

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
  TFrameListItemStyle_UserSerivceGoodsVIP = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgGoodsIcon: TSkinFMXImage;
    lblGoodsPriceArea: TSkinFMXLabel;
    btnEditGoods: TSkinFMXButton;
    btnGoodsInfo: TSkinFMXButton;
    lblEndDate: TSkinFMXLabel;
    lblSumStorage: TSkinFMXLabel;
    lblEndDateHint: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    imgBackground: TSkinFMXImage;
    btnBuy: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    lblGoodsName: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
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



{ TFrameListItemStyle_UserSerivceGoodsVIP }

constructor TFrameListItemStyle_UserSerivceGoodsVIP.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_UserSerivceGoodsVIP.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('UserSerivceGoodsVIP',TFrameListItemStyle_UserSerivceGoodsVIP);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_UserSerivceGoodsVIP);

end.
