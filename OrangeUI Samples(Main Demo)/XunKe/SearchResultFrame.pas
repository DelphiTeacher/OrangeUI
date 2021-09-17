//convert pas to utf8 by ¥

unit SearchResultFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uSkinItems,
  uUIFunction,
  ProductInfoFrame,
  uSkinListViewType,
  XunKeCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyPullLoadPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinMaterial,
  uSkinButtonType, uDrawPicture, uSkinImageList, uSkinFireMonkeyCustomList,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uBaseSkinControl, uSkinPanelType, uDrawCanvas;

type
  TFrameSearchResult = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbProductList: TSkinFMXListView;
    ListItemDefault: TSkinFMXItemDesignerPanel;
    imgListItemDefaultIcon: TSkinFMXImage;
    lblListItemDefaultCaption: TSkinFMXLabel;
    lblListItemDefaultPrice: TSkinFMXLabel;
    lblListItemDefaultDetail1: TSkinFMXLabel;
    lblListItemDefaultDetail2: TSkinFMXLabel;
    pnlListItemDefaultDevide: TSkinFMXPanel;
    ViewItemDefault: TSkinFMXItemDesignerPanel;
    imgViewItemDefaultIcon: TSkinFMXImage;
    lblViewItemDefaultPrice: TSkinFMXLabel;
    lblViewItemDefaultDetail1: TSkinFMXLabel;
    pnlSortType: TSkinFMXPanel;
    btnSortByDefault: TSkinFMXButton;
    btnSortBySellCount: TSkinFMXButton;
    btnViewType: TSkinFMXButton;
    btnSortByPrice: TSkinFMXButton;
    imglistPriceSortTypes: TSkinImageList;
    imglistViewTypes: TSkinImageList;
    lblListItemDefaultDetail3: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    btnSearch: TSkinFMXButton;
    btnScan: TSkinFMXButton;
    procedure btnViewTypeClick(Sender: TObject);
    procedure lbProductListResize(Sender: TObject);
    procedure lbProductListClickItem(Sender: TSkinItem);
    procedure btnSortByPriceClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalSearchResultFrame:TFrameSearchResult;

implementation

uses
  MainForm,
  SearchFrame,
  MainFrame;

{$R *.fmx}

procedure TFrameSearchResult.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameSearchResult.btnSearchClick(Sender: TObject);
begin
  //跳转到搜索界面
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalSearchFrame),TFrameSearch,frmMain,nil,nil,nil,Application);
//  GlobalSearchFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameSearchResult.btnSortByPriceClick(Sender: TObject);
begin
  if not Self.btnSortByPrice.Properties.IsPushed then
  begin
    Self.btnSortByPrice.Properties.IsPushed:=True;
  end
  else
  begin
    if Self.btnSortByPrice.Properties.PushedIcon.ImageIndex=0 then
    begin
      Self.btnSortByPrice.Properties.PushedIcon.ImageIndex:=1;
    end
    else
    if Self.btnSortByPrice.Properties.PushedIcon.ImageIndex=1 then
    begin
      Self.btnSortByPrice.Properties.PushedIcon.ImageIndex:=2;
    end
    else
    if Self.btnSortByPrice.Properties.PushedIcon.ImageIndex=2 then
    begin
      Self.btnSortByPrice.Properties.PushedIcon.ImageIndex:=1;
    end;
  end;
end;

procedure TFrameSearchResult.btnViewTypeClick(Sender: TObject);
begin
  Self.btnViewType.Properties.IsPushed:=Not Self.btnViewType.Properties.IsPushed ;
  if Self.btnViewType.Properties.IsPushed then
  begin
    //图标
    Self.lbProductList.Properties.ItemDesignerPanel:=nil;
    Self.lbProductList.Properties.ViewType:=lvtIcon;

    Self.lbProductList.Properties.ItemWidth:=Self.Width/2;
    Self.lbProductList.Properties.ItemHeight:=
      Self.lbProductList.Properties.ItemWidth*200/120;

    Self.lbProductList.Properties.ItemDesignerPanel:=ViewItemDefault;
  end
  else
  begin
    //列表
    Self.lbProductList.Properties.ItemDesignerPanel:=nil;
    Self.lbProductList.Properties.ViewType:=lvtList;
    Self.lbProductList.Properties.ItemWidth:=-1;
    Self.lbProductList.Properties.ItemHeight:=120;
    Self.lbProductList.Properties.ItemDesignerPanel:=ListItemDefault;
  end;
end;

procedure TFrameSearchResult.lbProductListClickItem(Sender: TSkinItem);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //显示产品信息界面
  ShowFrame(TFrame(GlobalProductInfoFrame),TFrameProductInfo,frmMain,nil,nil,nil,Application);
//  TFrameProductInfo(GlobalProductInfoFrame).FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameSearchResult.lbProductListResize(Sender: TObject);
begin
  //宽高成比例
  if Self.lbProductList.Properties.ViewType=lvtIcon then
  begin
    Self.lbProductList.Properties.ItemWidth:=Self.Width/2;
    Self.lbProductList.Properties.ItemHeight:=
      Self.lbProductList.Properties.ItemWidth*200/120;
  end;

  Self.btnSortByDefault.Width:=(Width-Self.btnViewType.Width)/3;
  Self.btnSortBySellCount.Width:=Self.btnSortByDefault.Width;
  Self.btnSortByPrice.Width:=Self.btnSortByPrice.Width;
end;

end.
