//convert pas to utf8 by ¥

unit MyBillFrame;

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
  uSkinNotifyNumberIconType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinLabelType,
  uSkinImageType, uSkinButtonType, uSkinPanelType;

type
  TFrameMyBill = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    imglistState: TSkinImageList;
    imglistIcon: TSkinImageList;
    Header: TSkinFMXPanel;
    imgHead: TSkinFMXImage;
    lblNickName: TSkinFMXLabel;
    lblAllMoney: TSkinFMXLabel;
    imgMenuBack: TSkinFMXImage;
    lbMenu: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    imgExpandState: TSkinFMXImage;
    nniCount: TSkinFMXNotifyNumberIcon;
    pnlDevide: TSkinFMXPanel;
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
  GlobalMyBillFrame:TFrameMyBill;


implementation

{$R *.fmx}

procedure TFrameMyBill.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameMyBill.lbMenuPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
  nniCount.Visible:=(Item.Caption='我的应收账款');
end;

end.

