//convert pas to utf8 by ¥
unit ShopListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  ShopInfoFrame,
  uTimerTask,
  uSkinItems,
  uSkinListBoxType,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinMaterial, uSkinImageType, uDrawPicture,
  uSkinImageList, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameShopList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbShop: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgIcon: TSkinFMXImage;
    lblCaption: TSkinFMXLabel;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    imgStar5: TSkinFMXImage;
    lblSellCount: TSkinFMXLabel;
    lblTel: TSkinFMXLabel;
    lblAddress: TSkinFMXLabel;
    lblDistance: TSkinFMXLabel;
    ItemLoadMore: TSkinFMXItemDesignerPanel;
    btnLoadMore: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbShopClickItem(Sender: TSkinItem);
  private
    procedure DoLoadTimerTaskExecute(ATimerTask:TObject);
    procedure DoLoadTimerTaskExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalShopListFrame:TFrameShopList;


implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameShopList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

procedure TFrameShopList.DoLoadTimerTaskExecute(ATimerTask: TObject);
begin
  //模拟加载数据延时
  Sleep(3000);

end;

procedure TFrameShopList.DoLoadTimerTaskExecuteEnd(ATimerTask: TObject);
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
  Self.btnLoadMore.Caption:='点击展开下20条记录';
end;

procedure TFrameShopList.lbShopClickItem(Sender: TSkinItem);
var
  ATimerTask:TTimerTask;
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    //商家详情
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

end.
