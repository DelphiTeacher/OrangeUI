//convert pas to utf8 by ¥
unit BuyGoodsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uUIFunction,
  CartFrame,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyImageListViewer, uSkinButtonType, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyLabel, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinLabelType, uSkinImageListViewerType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinPanelType;

type
  TFrameBuyGoods = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imglistPlayer: TSkinImageList;
    imgPlayer: TSkinFMXImageListViewer;
    btnPlayer: TSkinFMXButtonGroup;
    pnlPrice: TSkinFMXPanel;
    lblPrice: TSkinFMXLabel;
    pnlNumber: TSkinFMXPanel;
    lblNumberHint: TSkinFMXLabel;
    btnDecNumber: TSkinFMXButton;
    edtNumber: TSkinFMXEdit;
    btnAddNumber: TSkinFMXButton;
    pnlGoodsInfo: TSkinFMXPanel;
    lblGoodsInfoHint: TSkinFMXLabel;
    btnGoodsInfo: TSkinFMXButton;
    pnlComment: TSkinFMXPanel;
    lblCommentHint: TSkinFMXLabel;
    btnComment: TSkinFMXButton;
    pnlBottomBar: TSkinFMXPanel;
    pnlAddShopCart: TSkinFMXButton;
    btnShopCart: TSkinFMXButton;
    pnlGoodsName: TSkinFMXPanel;
    lblGoodsName: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnDecNumberStayClick(Sender: TObject);
    procedure btnAddNumberStayClick(Sender: TObject);
    procedure pnlAddShopCartClick(Sender: TObject);
    procedure btnShopCartClick(Sender: TObject);
    procedure imgPlayerImageListSwitchEnd(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalBuyGoodsFrame:TFrameBuyGoods;

implementation

uses
  MainForm;


{$R *.fmx}

procedure TFrameBuyGoods.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameBuyGoods.btnDecNumberStayClick(Sender: TObject);
begin
  if StrToInt(Self.edtNumber.Text)>1 then
  begin
    Self.edtNumber.Text:=IntToStr(StrToInt(Self.edtNumber.Text)-1);
  end;

end;

procedure TFrameBuyGoods.btnAddNumberStayClick(Sender: TObject);
begin
  Self.edtNumber.Text:=IntToStr(StrToInt(Self.edtNumber.Text)+1);

end;

procedure TFrameBuyGoods.pnlAddShopCartClick(Sender: TObject);
begin
  //加入购物车
  //只是加入购物车,不弹出页面
end;

procedure TFrameBuyGoods.btnShopCartClick(Sender: TObject);
begin
  //购物车页面
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalCartFrame),TFrameCart,frmMain,nil,nil,nil,Application);
//  GlobalCartFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameBuyGoods.imgPlayerImageListSwitchEnd(Sender: TObject);
begin
  //切换图片的时候就是切换商品

end;

end.
