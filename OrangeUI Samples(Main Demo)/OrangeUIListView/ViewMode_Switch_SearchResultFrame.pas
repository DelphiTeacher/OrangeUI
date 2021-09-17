//convert pas to utf8 by ¥

unit ViewMode_Switch_SearchResultFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uSkinItems,
  uUIFunction,
  uSkinListViewType,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyPullLoadPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinMaterial,
  uSkinButtonType, uDrawPicture, uSkinImageList, uSkinFireMonkeyCustomList,
  uSkinPanelType, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType, uDrawCanvas;

type
  TFrameViewMode_Switch_SearchResult = class(TFrame)
    lbProductList: TSkinFMXListView;
    ListItemDefault: TSkinFMXItemDesignerPanel;
    imgListItemDefaultIcon: TSkinFMXImage;
    lblListItemDefaultCaption: TSkinFMXLabel;
    lblListItemDefaultPrice: TSkinFMXLabel;
    lblListItemDefaultDetail1: TSkinFMXLabel;
    lblListItemDefaultDetail2: TSkinFMXLabel;
    ViewItemDefault: TSkinFMXItemDesignerPanel;
    imgViewItemDefaultIcon: TSkinFMXImage;
    lblViewItemDefaultPrice: TSkinFMXLabel;
    lblViewItemDefaultDetail1: TSkinFMXLabel;
    pnlSortType: TSkinFMXPanel;
    btnSortByDefault: TSkinFMXButton;
    btnSortBySellCount: TSkinFMXButton;
    btnViewType: TSkinFMXButton;
    btnSortByPrice: TSkinFMXButton;
    imglistViewTypes: TSkinImageList;
    lblListItemDefaultDetail3: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    procedure btnViewTypeClick(Sender: TObject);
    procedure lbProductListResize(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;



implementation



uses
  MainForm;

{$R *.fmx}

procedure TFrameViewMode_Switch_SearchResult.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameViewMode_Switch_SearchResult.btnViewTypeClick(Sender: TObject);
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

procedure TFrameViewMode_Switch_SearchResult.lbProductListResize(Sender: TObject);
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
