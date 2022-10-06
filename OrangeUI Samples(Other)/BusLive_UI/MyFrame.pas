//convert pas to utf8 by ¥
unit MyFrame;

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
//  uUIFunction,
  LoginFrame,
  uSkinItems,
  AccountFrame,
  uSkinImageType, uSkinFireMonkeyVirtualList, uSkinPanelType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uDrawCanvas;

type
  TFrameMy = class(TFrame)
    lbMenu: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    lblMenuCaption: TSkinFMXLabel;
    imgExpandState: TSkinFMXImage;
    Header: TSkinFMXItemDesignerPanel;
    imgItemBackGround: TSkinFMXImage;
    imgHead: TSkinFMXImage;
    pnlItemBottom: TSkinFMXPanel;
    imglistItem1: TSkinImageList;
    btnmItem1: TSkinButtonDefaultMaterial;
    btnCircle: TSkinFMXButton;
    btnAddressBook: TSkinFMXButton;
    btnGroup: TSkinFMXButton;
    btnPublic: TSkinFMXButton;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXImage2: TSkinFMXImage;
    SkinFMXImage3: TSkinFMXImage;
    idmDevide: TSkinImageDefaultMaterial;
    SkinFMXLabel1: TSkinFMXLabel;
    bdmLoginButton: TSkinButtonDefaultMaterial;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXLabel2: TSkinFMXLabel;
    procedure lbMenuResize(Sender: TObject);
    procedure SkinFMXButton2Click(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbMenuClickItem(Sender: TSkinItem);
    procedure btnCircleClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalMyFrame:TFrameMy;


implementation

{$R *.fmx}

uses
  MainForm;


procedure TFrameMy.btnCircleClick(Sender: TObject);
begin
  //

end;

procedure TFrameMy.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameMy.lbMenuClickItem(Sender: TSkinItem);
begin
  if TSkinItem(Sender).ItemType=sitHeader then
  begin
    HideFrame;//(Self);

    ShowFrame(TFrame(GlobalAccountFrame),TFrameAccount,frmMain,nil,nil,nil,Application);
//    GlobalAccountFrame.FrameHistroy:=CurrentFrameHistroy;
//    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;

  end;
end;

procedure TFrameMy.lbMenuResize(Sender: TObject);
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

procedure TFrameMy.SkinFMXButton2Click(Sender: TObject);
begin
//  HideFrame;//(GlobalMainFrame);
//
//  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.
