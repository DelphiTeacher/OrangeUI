//convert pas to utf8 by ¥

unit TradeCenterFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  XunKeCommonSkinMaterialModule,
  uUIFunction,
  uDrawCanvas,
  uSkinItems,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinImageList,
  uDrawPicture, uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyButton,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uSkinNotifyNumberIconType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameTradeCenter = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbMenu: TSkinFMXListBox;
    imglistState: TSkinImageList;
    imglistIcon: TSkinImageList;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    imgExpandState: TSkinFMXImage;
    nniCount: TSkinFMXNotifyNumberIcon;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbMenuPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalTradeCenterFrame:TFrameTradeCenter;


implementation

{$R *.fmx}

procedure TFrameTradeCenter.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameTradeCenter.lbMenuPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
  nniCount.Visible:=(Item.Caption='实体店订单') or (Item.Caption='等待付款');

end;

end.
