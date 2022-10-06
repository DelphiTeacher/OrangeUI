//convert pas to utf8 by ¥
unit NearbyShoppingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  uSkinItems,
  uTimerTask,
  uSkinListBoxType,
  ShopListFrame,
//  GoodsListFrame,
  ShopInfoFrame,
  BusLiveCommonSkinMaterialModule,
//  FoodShopInfoFrame,
//  FoodPreferentialInfoFrame,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinFireMonkeySwitchPageListPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, uDrawPicture, uSkinImageList, uSkinMaterial,
  uSkinScrollControlType, uSkinVirtualListType, uSkinListViewType,
  uSkinButtonType, uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyImage, uSkinFireMonkeyLabel, uSkinFireMonkeyMultiColorLabel,
  uSkinImageType, uSkinCustomListType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollBoxContentType, uSkinScrollBoxType,
  uSkinPanelType, uDrawCanvas;

type
  TFrameNearbyShopping = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    imslistIcon: TSkinImageList;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlNearbyShop: TSkinFMXPanel;
    lbShop: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgIcon: TSkinFMXImage;
    lblCaption: TSkinFMXLabel;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    SkinFMXImage6: TSkinFMXImage;
    lblSellCount: TSkinFMXLabel;
    lblTel: TSkinFMXLabel;
    lblAddress: TSkinFMXLabel;
    lblDistance: TSkinFMXLabel;
    pcType: TSkinFMXPageControl;
    btnPlayer: TSkinFMXButtonGroup;
    tsPage2: TSkinFMXTabSheet;
    SkinFMXListView2: TSkinFMXListView;
    tsPage1: TSkinFMXTabSheet;
    SkinFMXListView1: TSkinFMXListView;
    ItemLoadMore: TSkinFMXItemDesignerPanel;
    btnLoadMore: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbShopClickItem(Sender: TSkinItem);
    procedure SkinFMXListView1ClickItem(Sender: TSkinItem);
    procedure btnLoadMoreClick(Sender: TObject);
  private
    procedure SyncContentHeight;
    procedure DoLoadTimerTaskExecute(ATimerTask:TObject);
    procedure DoLoadTimerTaskExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalNearbyShoppingFrame:TFrameNearbyShopping;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameNearbyShopping.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameNearbyShopping.btnLoadMoreClick(Sender: TObject);
begin
  //点击展开下20条记录

end;

constructor TFrameNearbyShopping.Create(AOwner: TComponent);
begin
  inherited;
  //可以左右滑动
  Self.pcType.Properties.CanGesutreSwitch:=True;

//  Self.pcType.Properties.SwitchPageListControlGestureManager.CanGestureSwitch:=True;
//  Self.pcType.Properties.SwitchPageListControlGestureManager.ControlGestureManager.IsUseDecideFirstMouseMoveKind:=True;
//  Self.pcType.Properties.SwitchPageListControlGestureManager.ControlGestureManager.DecideFirstMouseMoveKindPrecision:=5;
//  Self.pcType.Properties.SwitchPageListControlGestureManager.ControlGestureManager.DecideFirstMouseMoveKindCrement:=10;

  SyncContentHeight;
end;

procedure TFrameNearbyShopping.DoLoadTimerTaskExecute(ATimerTask: TObject);
begin
  //模拟加载数据延时
  Sleep(3000);
end;

procedure TFrameNearbyShopping.DoLoadTimerTaskExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  Self.lbShop.Prop.Items.BeginUpdate;
  try
    for I := 0 to 20 do
    begin
      AListBoxItem:=Self.lbShop.Prop.Items.Insert(Self.lbShop.Prop.Items.Count-1);
      AListBoxItem.Caption:='龙摄影婚纱国际连锁';
      AListBoxItem.Detail:='月售199单';
      AListBoxItem.Detail1:='138384765';
      AListBoxItem.Detail2:='何宅';
      AListBoxItem.Detail3:='0.5km';
      AListBoxItem.Icon.Assign(Self.lbShop.Prop.Items[I].Icon);
    end;
  finally
    Self.lbShop.Prop.Items.EndUpdate();
  end;
  SyncContentHeight;
  Self.btnLoadMore.Caption:='点击展开下20条记录';
end;

procedure TFrameNearbyShopping.lbShopClickItem(Sender: TSkinItem);
var
  ATimerTask:TTimerTask;
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,frmMain,nil,nil,nil,Application);
//    GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).ItemType=sitFooter then
  begin
    //加载更多
    Self.btnLoadMore.Caption:='正在加载...';

    ATimerTask:=TTimerTask.Create(0);
    ATimerTask.OnExecute:=Self.DoLoadTimerTaskExecute;
    ATimerTask.OnExecuteEnd:=Self.DoLoadTimerTaskExecuteEnd;
    GetGlobalTimerThread.RunTask(ATimerTask);
  end;
end;

procedure TFrameNearbyShopping.SkinFMXListView1ClickItem(Sender: TSkinItem);
begin
  //商家列表
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalShopListFrame),TFrameShopList,frmMain,nil,nil,nil,Application);
//  GlobalShopListFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameNearbyShopping.SyncContentHeight;
begin
  Self.sbClient.Prop.ContentHeight:=
        Self.pcType.Height
        +Self.pnlNearbyShop.Height
        +Self.lbShop.Prop.GetContentHeight;
end;

end.
