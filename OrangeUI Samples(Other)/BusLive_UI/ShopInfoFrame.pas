//convert pas to utf8 by ¥
unit ShopInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  BuyGoodsFrame,
  BusLiveCommonSkinMaterialModule,
  uSkinItems,
  uSkinListBoxType,
  uTimerTask,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinPageControlType,
  uSkinFireMonkeyPageControl, uSkinFireMonkeySwitchPageListPanel,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinMaterial, uSkinButtonType, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinCustomListType, uSkinVirtualListType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinPanelType, uDrawCanvas;

type
  TFrameShopInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pcShop: TSkinFMXPageControl;
    tsShop: TSkinFMXTabSheet;
    tsBuy: TSkinFMXTabSheet;
    lbCategory: TSkinFMXListBox;
    lbGoods: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgIcon: TSkinFMXImage;
    lblCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    lblPrice: TSkinFMXLabel;
    imgStar5: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar1: TSkinFMXImage;
    btnAdd: TSkinFMXButton;
    ItemItem1: TSkinFMXItemDesignerPanel;
    imgItem1Icon: TSkinFMXImage;
    lblItem1Caption: TSkinFMXLabel;
    lblItem1Detail: TSkinFMXLabel;
    lblItem1Price: TSkinFMXLabel;
    imgItem1Star5: TSkinFMXImage;
    imgItem1Star4: TSkinFMXImage;
    imgItem1Star3: TSkinFMXImage;
    imgItem1Star2: TSkinFMXImage;
    imgItem1Star1: TSkinFMXImage;
    btmAdd1: TSkinFMXButton;
    btnDec1: TSkinFMXButton;
    edtNumber: TSkinFMXEdit;
    ItemLoadMore: TSkinFMXItemDesignerPanel;
    btnLoadMore: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    lbComment: TSkinFMXListBox;
    ItemComment: TSkinFMXItemDesignerPanel;
    imgCommentIcon: TSkinFMXImage;
    lblCommentCaption: TSkinFMXLabel;
    lblCommentDetail1: TSkinFMXLabel;
    SkinFMXImage12: TSkinFMXImage;
    SkinFMXImage13: TSkinFMXImage;
    SkinFMXImage14: TSkinFMXImage;
    SkinFMXImage15: TSkinFMXImage;
    SkinFMXImage16: TSkinFMXImage;
    lblCommentDetail: TSkinFMXLabel;
    lblCommentDetail2: TSkinFMXLabel;
    ItemLoadMoreComment: TSkinFMXItemDesignerPanel;
    btnLoadMoreComment: TSkinFMXButton;
    pnlCommentGap: TSkinFMXPanel;
    pnlSumComment: TSkinFMXPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXImage2: TSkinFMXImage;
    SkinFMXImage3: TSkinFMXImage;
    SkinFMXImage4: TSkinFMXImage;
    SkinFMXImage5: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXImage6: TSkinFMXImage;
    SkinFMXImage7: TSkinFMXImage;
    SkinFMXImage8: TSkinFMXImage;
    SkinFMXImage9: TSkinFMXImage;
    SkinFMXImage10: TSkinFMXImage;
    pnlFilter: TSkinFMXPanel;
    SkinFMXPanel4: TSkinFMXPanel;
    btnAllComment: TSkinFMXButton;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXButton2: TSkinFMXButton;
    SkinFMXButton3: TSkinFMXButton;
    pnlComment: TSkinFMXPanel;
    memContent: TSkinFMXMemo;
    SkinFMXLabel7: TSkinFMXLabel;
    SkinFMXImage11: TSkinFMXImage;
    SkinFMXImage17: TSkinFMXImage;
    SkinFMXImage18: TSkinFMXImage;
    SkinFMXImage19: TSkinFMXImage;
    SkinFMXImage20: TSkinFMXImage;
    SkinFMXLabel8: TSkinFMXLabel;
    SkinFMXLabel9: TSkinFMXLabel;
    SkinFMXImage21: TSkinFMXImage;
    SkinFMXImage22: TSkinFMXImage;
    SkinFMXImage23: TSkinFMXImage;
    SkinFMXImage24: TSkinFMXImage;
    SkinFMXImage25: TSkinFMXImage;
    btnSubmitComment: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbGoodsClickItem(Sender: TSkinItem);
    procedure btnAddClick(Sender: TObject);
    procedure btnDec1Click(Sender: TObject);
    procedure lbCommentClickItem(Sender: TSkinItem);
  private
    procedure SyncContentHeight;

    procedure DoLoadTimerTaskExecute(ATimerTask:TObject);
    procedure DoLoadTimerTaskExecuteEnd(ATimerTask:TObject);

    procedure DoLoadCommentTimerTaskExecute(ATimerTask:TObject);
    procedure DoLoadCommentTimerTaskExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    Constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalShopInfoFrame:TFrameShopInfo;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameShopInfo.btnAddClick(Sender: TObject);
begin
  //数量加1
  if Self.lbGoods.Prop.InteractiveItem.ItemType=sitDefault then
  begin
    Self.lbGoods.Prop.InteractiveItem.Detail2:='1';
    Self.lbGoods.Prop.InteractiveItem.ItemType:=sitItem1;
  end
  else
  begin
    Self.lbGoods.Prop.InteractiveItem.Detail2:=
      IntToStr(StrToInt(Self.lbGoods.Prop.InteractiveItem.Detail2)+1);
  end;
end;

procedure TFrameShopInfo.btnDec1Click(Sender: TObject);
begin
  //数量减一
  Self.lbGoods.Prop.InteractiveItem.Detail2:=
    IntToStr(StrToInt(Self.lbGoods.Prop.InteractiveItem.Detail2)-1);
  if Self.lbGoods.Prop.InteractiveItem.Detail2='0' then
  begin
    Self.lbGoods.Prop.InteractiveItem.Detail2:='';
    Self.lbGoods.Prop.InteractiveItem.ItemType:=sitDefault;
  end;
end;

procedure TFrameShopInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameShopInfo.Create(AOwner: TComponent);
begin
  inherited;
  SyncContentHeight;
end;

procedure TFrameShopInfo.DoLoadCommentTimerTaskExecute(ATimerTask: TObject);
begin
  //模拟加载数据延时
  Sleep(3000);

end;

procedure TFrameShopInfo.DoLoadCommentTimerTaskExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  Self.lbComment.Prop.Items.BeginUpdate;
  try
    for I := 0 to 20 do
    begin
      AListBoxItem:=Self.lbComment.Prop.Items.Insert(Self.lbComment.Prop.Items.Count-1);
      AListBoxItem.Caption:='不够甜，料太少';
      AListBoxItem.Detail:='x*****a';
      AListBoxItem.Detail1:='2015-12-09 23:28';
      AListBoxItem.Detail:='奶茶烧仙草';
      AListBoxItem.Icon.Assign(Self.lbComment.Prop.Items[I].Icon);
    end;
  finally
    Self.lbComment.Prop.Items.EndUpdate();
  end;
  SyncContentHeight;
  Self.btnLoadMoreComment.Caption:='点击展开下20条记录';

end;

procedure TFrameShopInfo.DoLoadTimerTaskExecute(ATimerTask: TObject);
begin
  //模拟加载数据延时
  Sleep(3000);

end;

procedure TFrameShopInfo.DoLoadTimerTaskExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  Self.lbGoods.Prop.Items.BeginUpdate;
  try
    for I := 0 to 20 do
    begin
      AListBoxItem:=Self.lbGoods.Prop.Items.Insert(Self.lbGoods.Prop.Items.Count-1);
      AListBoxItem.Caption:='DIOR 真我香水100ml';
      AListBoxItem.Detail:='[望京]美梦成真:迪奥真我香水100ml,免费送!';
      AListBoxItem.Detail1:='￥9.9元';
      AListBoxItem.Icon.Assign(Self.lbGoods.Prop.Items[I].Icon);
    end;
  finally
    Self.lbGoods.Prop.Items.EndUpdate();
  end;
  Self.btnLoadMore.Caption:='点击展开下20条记录';
end;

procedure TFrameShopInfo.lbCommentClickItem(Sender: TSkinItem);
var
  ATimerTask:TTimerTask;
begin
  if TSkinItem(Sender).ItemType=sitFooter then
  begin
    //加载更多
    Self.btnLoadMoreComment.Caption:='正在加载...';

    ATimerTask:=TTimerTask.Create(0);
    ATimerTask.OnExecute:=Self.DoLoadCommentTimerTaskExecute;
    ATimerTask.OnExecuteEnd:=Self.DoLoadCommentTimerTaskExecuteEnd;
    GetGlobalTimerThread.RunTask(ATimerTask);
  end;

end;

procedure TFrameShopInfo.lbGoodsClickItem(Sender: TSkinItem);
var
  ATimerTask:TTimerTask;
begin
  if (TSkinItem(Sender).ItemType=sitDefault)
    or (TSkinItem(Sender).ItemType=sitItem1) then
  begin
    //点击购买商品
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalBuyGoodsFrame),TFrameBuyGoods,frmMain,nil,nil,nil,Application);
//    GlobalBuyGoodsFrame.FrameHistroy:=CurrentFrameHistroy;
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

procedure TFrameShopInfo.SyncContentHeight;
begin
  Self.sbClient.Prop.ContentHeight:=
        Self.pnlSumComment.Height
        +Self.pnlCommentGap.Height
        +Self.pnlFilter.Height
        +Self.lbComment.Prop.GetContentHeight
        +Self.pnlComment.Height;

end;

end.
