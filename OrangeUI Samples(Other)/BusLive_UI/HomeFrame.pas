//convert pas to utf8 by ¥
unit HomeFrame;

interface

uses
  System.SysUtils,uFuncCommon, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinItems,
  uBaseLog,
  Math,
  StrUtils,
  uSkinFireMonkeyButton,
  uSkinPageControlType,
  uSkinFireMonkeyPageControl,
  uSkinFireMonkeyControl,
  uSkinImageList, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox,
  uSkinFireMonkeyListView,
  uSkinFireMonkeyImageListPlayer,
  CityListFrame,
  LoginFrame,
  BusLineFrame,
  MyFrame,
  FilmHomeFrame,
  GoTalkRoomFrame,
  NearbyShoppingFrame,
  NewsFrame,
  GoWhereFrame,
  CarDistanceHintFrame,
  FilterBusLineFrame,
  ScanWifiFrame,
  BuyGoodsFrame,
  uUIFunction,
  uFrameContext,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage,
  uSkinFireMonkeyNotifyNumberIcon,
  uSkinFireMonkeyImageListViewer,
  uSkinFireMonkeyItemDesignerPanel, uSkinButtonType,
  uSkinFireMonkeySwitchPageListPanel, uDrawPicture, uSkinFireMonkeyVirtualList,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinPanelType,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType,
  uSkinScrollControlType, uSkinImageListViewerType, uDrawCanvas;

type
  TFrameHome = class(TFrame,IFrameHistroyVisibleEvent)
    imglistPlayer: TSkinImageList;
    imgPlayer: TSkinFMXImageListViewer;
    btnPlayer: TSkinFMXButtonGroup;
    lblMenu: TSkinFMXListView;
    idpMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnCity: TSkinFMXButton;
    btnLogin: TSkinFMXButton;
    imglistIcon: TSkinImageList;
    btnSearchBusLine: TSkinFMXButton;
    procedure lblMenuResize(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btnCityClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure imgPlayerStayClick(Sender: TObject);
    procedure lblMenuClickItem(Sender: TSkinItem);
    procedure btnSearchBusLineClick(Sender: TObject);
  private
    procedure DoShow;
    procedure DoHide;
  private
    procedure DoReturnFrameFromSelectCityListFrame(AFrame:TFrame);
    procedure DoReturnFrameFromFilterBusLine(Frame:TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalHomeFrame:TFrameHome;

implementation

{$R *.fmx}

uses
  MainForm;

procedure TFrameHome.btnCityClick(Sender: TObject);
begin
  HideFrame;//(Self);
  //显示城市列表
  ShowFrame(TFrame(GlobalCityListFrame),TFrameCityList,frmMain,nil,nil,DoReturnFrameFromSelectCityListFrame,Application);
//  GlobalCityListFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameHome.btnLoginClick(Sender: TObject);
begin
  //登陆
  HideFrame;//(Self);
  //显示登录界面
  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
end;

constructor TFrameHome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFrameHome.Destroy;
begin
  inherited;
end;

procedure TFrameHome.DoHide;
begin
  Self.imgPlayer.Properties.ImageListAnimated:=False;
end;

procedure TFrameHome.DoReturnFrameFromFilterBusLine(Frame: TFrame);
begin
  frmMain.ShowHomeFrame;

  //查看线路
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalBusLineFrame),TFrameBusLine,frmMain,nil,nil,nil,Application);
//  GlobalBusLineFrame.FrameHistroy:=FrameHistroy;
end;

procedure TFrameHome.DoReturnFrameFromSelectCityListFrame(AFrame: TFrame);
begin
  //设置当前的城市
  if GlobalCityListFrame.lbCityList.Properties.SelectedItem<>nil then
  begin
    //去掉市
    Self.btnCity.Caption:=GlobalCityListFrame.lbCityList.Properties.SelectedItem.Caption;
    Self.btnCity.Caption:=ReplaceStr(Self.btnCity.Caption,'市','');
  end;
end;

procedure TFrameHome.DoShow;
begin
  Self.imgPlayer.Properties.ImageListAnimated:=True;
end;

procedure TFrameHome.FrameResize(Sender: TObject);
begin
  if Height>Width then
  begin
    //广告保持这个比例320,128
    Self.imgPlayer.Height:=Width*128/320;
  end;
end;

procedure TFrameHome.imgPlayerStayClick(Sender: TObject);
begin
  //购买商品
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalBuyGoodsFrame),TFrameBuyGoods,frmMain,nil,nil,nil,Application);
//  GlobalBuyGoodsFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameHome.lblMenuClickItem(Sender: TSkinItem);
begin
  if TSkinItem(Sender).Caption='公交WIFI' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalScanWifiFrame),TFrameScanWifi,frmMain,nil,nil,nil,Application);
//    GlobalScanWifiFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).Caption='去哪儿' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalGoWhereFrame),TFrameGoWhere,frmMain,nil,nil,nil,Application);
//    GlobalGoWhereFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).Caption='影视' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalFilmHomeFrame),TFrameFilmHome,frmMain,nil,nil,nil,Application);
//    GlobalFilmHomeFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).Caption='Bus聊天室' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalGoTalkRoomFrame),TFrameGoTalkRoom,frmMain,nil,nil,nil,Application);
//    GlobalGoTalkRoomFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).Caption='周边购物' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalNearbyShoppingFrame),TFrameNearbyShopping,frmMain,nil,nil,nil,Application);
//    GlobalNearbyShoppingFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).Caption='预约提醒' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalCarDistanceHintFrame),TFrameCarDistanceHint,frmMain,nil,nil,nil,Application);
//    GlobalCarDistanceHintFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).Caption='扫描结算' then
  begin
//    HideFrame;//(Self);
//    ShowFrame(TFrame(GlobalMyFrame),TFrameMy,frmMain,nil,nil,nil,Application);
//    GlobalMyFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).Caption='个人中心' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalMyFrame),TFrameMy,frmMain,nil,nil,nil,Application);
//    GlobalMyFrame.FrameHistroy:=CurrentFrameHistroy;
  end;

end;

procedure TFrameHome.lblMenuResize(Sender: TObject);
begin
//  Self.lblMenu.Properties.ItemWidth:=Self.lblMenu.WidthInt div 3;
end;

procedure TFrameHome.btnSearchBusLineClick(Sender: TObject);
begin
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalFilterBusLineFrame),TFrameFilterBusLine,frmMain,nil,nil,DoReturnFrameFromFilterBusLine,Application);
//  GlobalFilterBusLineFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalFilterBusLineFrame.LoadData('');

end;

end.







