//convert pas to utf8 by ¥
unit AccountFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinImageList,
  uDrawPicture, uSkinMaterial, uSkinButtonType, uSkinFireMonkeyButton,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  LoginFrame,
  uSkinImageType, uSkinFireMonkeyVirtualList, uSkinPanelType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uDrawCanvas, uSkinItems;

type
  TFrameAccount = class(TFrame)
    lbMenu: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    lblMenuCaption: TSkinFMXLabel;
    imgExpandState: TSkinFMXImage;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    imgMenuIcon: TSkinFMXImage;
    imglistIcon: TSkinImageList;
    ItemItem1: TSkinFMXItemDesignerPanel;
    lblItem1Caption: TSkinFMXLabel;
    lblItem1Detail1: TSkinFMXLabel;
    lblItem1Detail: TSkinFMXLabel;
    pnlItem1Gap: TSkinFMXPanel;
    pnlMenuGap: TSkinFMXPanel;
    lblMenuDetail: TSkinFMXLabel;
    lblMenuDetail1: TSkinFMXLabel;
    procedure lbMenuResize(Sender: TObject);
    procedure SkinFMXButton2Click(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalAccountFrame:TFrameAccount;


implementation

{$R *.fmx}

uses
  MainForm;


procedure TFrameAccount.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameAccount.lbMenuResize(Sender: TObject);
begin
//  pnlWaitRecv.WidthInt:=Self.lbMenu.WidthInt div 2;
//  pnlWaitPay.WidthInt:=Self.lbMenu.WidthInt div 2;
//  //
//  lblWaitRecv.WidthInt:=Self.lbMenu.WidthInt div 2;
//  lblWaitRecvCount.WidthInt:=Self.lbMenu.WidthInt div 2;
//  //
//  lblWaitPay.WidthInt:=Self.lbMenu.WidthInt div 2;
//  lblWaitPayCount.WidthInt:=Self.lbMenu.WidthInt div 2;
end;

procedure TFrameAccount.SkinFMXButton2Click(Sender: TObject);
begin
//  HideFrame;//(GlobalMainFrame);
//
//  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.
