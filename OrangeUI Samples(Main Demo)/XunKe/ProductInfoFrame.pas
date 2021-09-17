//convert pas to utf8 by ¥

unit ProductInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinItems,
  Math,
  uSkinControlGestureManager,
  ShopCartFrame,
  BuyProductFrame,
  uSkinListBoxType,
  XunKeCommonSkinMaterialModule,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinImageList,
  uSkinFireMonkeyButton, uSkinButtonType, uSkinFireMonkeyImageListViewer,
  uDrawPicture, uSkinMaterial, uSkinFireMonkeyListView,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollBox, uSkinImageType, uSkinImageListViewerType,
  uSkinLabelType, uSkinScrollBoxContentType, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinPanelType;

type
  TFrameProductInfo = class(TFrame)
    imglistPlayer: TSkinImageList;
    imglistProduct: TSkinImageList;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnShopCart: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    SkinFMXPanel1: TSkinFMXPanel;
    imgPlayer: TSkinFMXImageListViewer;
    bgIndicator: TSkinFMXButtonGroup;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXPanel5: TSkinFMXPanel;
    SkinFMXPanel6: TSkinFMXPanel;
    SkinFMXPanel8: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXLabel7: TSkinFMXLabel;
    SkinFMXLabel8: TSkinFMXLabel;
    SkinFMXLabel9: TSkinFMXLabel;
    SkinFMXLabel10: TSkinFMXLabel;
    SkinFMXLabel11: TSkinFMXLabel;
    SkinFMXPanel7: TSkinFMXPanel;
    SkinFMXPanel9: TSkinFMXPanel;
    SkinFMXImage1: TSkinFMXImage;
    pnlMemo: TSkinFMXPanel;
    SkinFMXPanel11: TSkinFMXPanel;
    imgDetail1: TSkinFMXImage;
    imgDetail4: TSkinFMXImage;
    imgDetail3: TSkinFMXImage;
    imgDetail2: TSkinFMXImage;
    pnlBottomBar: TSkinFMXPanel;
    btnService: TSkinFMXButton;
    btnFav: TSkinFMXButton;
    btnShop: TSkinFMXButton;
    btnAddToShopCart: TSkinFMXButton;
    btnBuy: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btnShopCartClick(Sender: TObject);
    procedure btnAddToShopCartClick(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
    procedure btnShopClick(Sender: TObject);
  private
    procedure DolbHomeVertSkinControlGestureManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalProductInfoFrame:TFrame;


implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame,
  ShopFrame;

{ TFrameHome }

procedure TFrameProductInfo.btnShopCartClick(Sender: TObject);
begin
  //打开购物车界面
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalShopCartFrame),TFrameShopCart,frmMain,nil,nil,nil,Application);
//  GlobalShopCartFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameProductInfo.btnShopClick(Sender: TObject);
begin
  //显示店铺界面
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalShopFrame),TFrameShop,frmMain,nil,nil,nil,Application);
//  TFrameShop(GlobalShopFrame).FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameProductInfo.btnAddToShopCartClick(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalBuyProductFrame),TFrameBuyProduct,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//  GlobalBuyProductFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameProductInfo.btnBuyClick(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalBuyProductFrame),TFrameBuyProduct,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//  GlobalBuyProductFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameProductInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameProductInfo.Create(AOwner: TComponent);
begin
  inherited;

  Self.sbClient.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.sbClient.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
    Self.DolbHomeVertSkinControlGestureManagerPrepareDecidedFirstGestureKind;
end;

procedure TFrameProductInfo.DolbHomeVertSkinControlGestureManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  APlayerOriginPoint:TPointF;
  AFirstItemRect:TRectF;
begin
  //传给ScrollBox的是相对窗体的绝对坐标
  //广告轮播Item的绘制区域
  APlayerOriginPoint:=PointF(0,0);
  APlayerOriginPoint:=imgPlayer.LocalToAbsolute(APlayerOriginPoint);
  AFirstItemRect:=RectF(APlayerOriginPoint.X,
                        APlayerOriginPoint.Y,
                        APlayerOriginPoint.X+Self.imgPlayer.Width,
                        APlayerOriginPoint.Y+Self.imgPlayer.Height
                        );
  if PtInRect(AFirstItemRect,PointF(AMouseMoveX,AMouseMoveY)) then
  begin
    //在广告轮播控件内,那么要检查初始手势方向
  end
  else
  begin
    //不在在广告轮播控件内,那么随意滑动
    AIsDecidedFirstGestureKind:=True;
    ADecidedFirstGestureKind:=TGestureKind.gmkVertical;
  end;

end;

procedure TFrameProductInfo.FrameResize(Sender: TObject);
  procedure FitImageHeight(AImage:TSkinFMXImage);
  begin
    if AImage.Properties.Picture.CurrentPictureWidth<Width then
    begin
      AImage.Height:=
        AImage.Properties.Picture.CurrentPictureHeight;
    end
    else
    begin
      AImage.Height:=
        Ceil(AImage.Properties.Picture.CurrentPictureHeight
            *Width/AImage.Properties.Picture.CurrentPictureWidth);
    end;

  end;
begin
  FitImageHeight(Self.imgDetail1);
  FitImageHeight(Self.imgDetail2);
  FitImageHeight(Self.imgDetail3);
  FitImageHeight(Self.imgDetail4);

  Self.sbcClient.Height:=imgDetail4.Top+imgDetail4.Height;
end;

end.



