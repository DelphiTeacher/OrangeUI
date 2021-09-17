//convert pas to utf8 by ¥

unit MyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinItems,
  uSkinListBoxType,
  TodayOrderFrame,
  TradeCenterFrame,
  MyBillFrame,
  ShopFrame,
  uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinImageList,
  uSkinFireMonkeyButton, uSkinButtonType, uSkinFireMonkeyImageListViewer,
  uDrawPicture, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyFrameImage, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollBox, uSkinMaterial,
  uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyListView,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList, uDrawCanvas,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType, uSkinPanelType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameMy = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    bdmMoneyButton: TSkinButtonDefaultMaterial;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXButton3: TSkinFMXButton;
    SkinFMXButton2: TSkinFMXButton;
    imglistMoneyButton: TSkinImageList;
    SkinFMXPanel3: TSkinFMXPanel;
    bdmCenterButton: TSkinButtonDefaultMaterial;
    imglistCenterButton: TSkinImageList;
    btnMyBill: TSkinFMXButton;
    btnTradeCenter: TSkinFMXButton;
    lblMenu: TSkinFMXListView;
    idpMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    imglistMenu: TSkinImageList;
    imgTopClient: TSkinFMXImage;
    imgHead: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXPanel5: TSkinFMXPanel;
    SkinFMXPanel6: TSkinFMXPanel;
    procedure btnMyBillClick(Sender: TObject);
    procedure btnTradeCenterClick(Sender: TObject);
    procedure lblMenuClickItem(Sender: TSkinItem);
    procedure FrameResize(Sender: TObject);
  private
    GlobalShopFrame:TFrameShop;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalMyFrame:TFrameMy;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame;

{ TFrameHome }

procedure TFrameMy.btnMyBillClick(Sender: TObject);
begin
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示我的账单
  ShowFrame(TFrame(GlobalMyBillFrame),TFrameMyBill,frmMain,nil,nil,nil,Application);
//  GlobalMyBillFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameMy.btnTradeCenterClick(Sender: TObject);
begin
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示交易中心
  ShowFrame(TFrame(GlobalTradeCenterFrame),TFrameTradeCenter,frmMain,nil,nil,nil,Application);
//  GlobalTradeCenterFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameMy.FrameResize(Sender: TObject);
begin
  Self.SkinFMXButton1.Width:=Self.Width/2;
  Self.SkinFMXButton2.Width:=Self.Width/2;
  Self.SkinFMXButton3.Width:=Self.Width/2;

  Self.btnMyBill.Width:=Self.Width/2;
  Self.btnTradeCenter.Width:=Self.Width/2;

end;

procedure TFrameMy.lblMenuClickItem(Sender: TSkinItem);
begin
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示店铺
  ShowFrame(TFrame(GlobalShopFrame),TFrameShop,frmMain,nil,nil,nil,Application);
//  GlobalShopFrame.FrameHistroy:=CurrentFrameHistroy;

end;



end.
