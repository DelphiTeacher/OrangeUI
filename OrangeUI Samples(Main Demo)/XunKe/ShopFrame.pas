//convert pas to utf8 by ¥

unit ShopFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinItems,
  uSkinListBoxType,
  uSkinControlGestureManager,
  XunKeCommonSkinMaterialModule,
  ProductInfoFrame,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinImageList,
  uSkinFireMonkeyButton, uSkinButtonType, uSkinFireMonkeyImageListViewer,
  uDrawPicture, uSkinMaterial, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyCustomList, uDrawCanvas, uSkinLabelType, uSkinPanelType,
  uSkinImageType, uSkinImageListViewerType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType;

type
  TFrameShop = class(TFrame)
    lbHome: TSkinFMXListBox;
    ItemHeader: TSkinFMXItemDesignerPanel;
    imgPlayer: TSkinFMXImageListViewer;
    imglistPlayer: TSkinImageList;
    bgIndicator: TSkinFMXButtonGroup;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imglistProduct: TSkinImageList;
    imgDefaultIcon: TSkinFMXImage;
    SkinFMXPanel4: TSkinFMXPanel;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultCount: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    ItemFooter: TSkinFMXItemDesignerPanel;
    pnlFooterDevide: TSkinFMXPanel;
    lblDefaultPrice: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXButton2: TSkinFMXButton;
    SkinFMXButton3: TSkinFMXButton;
    SkinFMXButton4: TSkinFMXButton;
    bdmTypeButton: TSkinButtonDefaultMaterial;
    btnReturn: TSkinFMXButton;
    procedure lbHomeClickItem(Sender: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    procedure DoListBoxVertManagerPrepareDecidedFirstGestureKind(
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
    GlobalShopFrame:TFrame;


implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame;

{ TFrameHome }

procedure TFrameShop.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameShop.Create(AOwner: TComponent);
begin
  inherited;

  Self.lbHome.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.lbHome.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
    Self.DoListBoxVertManagerPrepareDecidedFirstGestureKind;
end;

procedure TFrameShop.DoListBoxVertManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  AFirstItemRect:TRectF;
begin
  //广告轮播Item的绘制区域
  AFirstItemRect:=Self.lbHome.Prop.Items[0].ItemDrawRect;
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

procedure TFrameShop.FrameResize(Sender: TObject);
begin
  SkinFMXButton1.Width:=Self.Width / 4;
  SkinFMXButton2.Width:=Self.Width / 4;
  SkinFMXButton3.Width:=Self.Width / 4;
  SkinFMXButton4.Width:=Self.Width / 4;

end;

procedure TFrameShop.lbHomeClickItem(Sender: TSkinItem);
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    HideFrame;//(Self,hfcttBeforeShowFrame);

    //显示产品信息界面
    ShowFrame(TFrame(GlobalProductInfoFrame),TFrameProductInfo,frmMain,nil,nil,nil,Application);
//    TFrameProductInfo(GlobalProductInfoFrame).FrameHistroy:=CurrentFrameHistroy;
  end;
end;

end.
