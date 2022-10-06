﻿//convert pas to utf8 by ¥
unit ListItemStyleFrame_GoodsManageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinImageType, uSkinFireMonkeyImage;


type
  //根基类
  TFrameListItemStyle_GoodsManage = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblGoodsName: TSkinFMXLabel;
    imgGoodsIcon: TSkinFMXImage;
    lblGoodsPriceArea: TSkinFMXLabel;
    btnEditGoods: TSkinFMXButton;
    btnGoodsInfo: TSkinFMXButton;
    lblMonthSale: TSkinFMXLabel;
    lblSumStorage: TSkinFMXLabel;
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



{ TFrameListItemStyle_GoodsManage }

constructor TFrameListItemStyle_GoodsManage.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_GoodsManage.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('GoodsManage',TFrameListItemStyle_GoodsManage);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_GoodsManage);

end.