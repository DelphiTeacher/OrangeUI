//convert pas to utf8 by ¥

unit CategoryFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyPanel,
  uUIFunction,
  uSkinItems,
  SearchFrame,
  SearchResultFrame,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox,
  uSkinFireMonkeyListView, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyButton, uSkinFireMonkeyCustomList,
  uDrawCanvas, uSkinButtonType, uSkinPanelType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinListViewType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType;

type
  TFrameCategory = class(TFrame)
    lbCategory: TSkinFMXListBox;
    lvSubCategory: TSkinFMXListView;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    ItemHeader: TSkinFMXItemDesignerPanel;
    ItemHeaderCaption: TSkinFMXLabel;
    btnSearch: TSkinFMXButton;
    btnScan: TSkinFMXButton;
    procedure ItemDefaultResize(Sender: TObject);
    procedure lvSubCategoryClickItem(Sender: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalCategoryFrame:TFrameCategory;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame;

{ TFrameCategory }

procedure TFrameCategory.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameCategory.btnSearchClick(Sender: TObject);
begin
  //跳转到搜索界面
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalSearchFrame),TFrameSearch,frmMain,nil,nil,nil,Application);
//  GlobalSearchFrame.FrameHistroy:=CurrentFrameHistroy;


end;

procedure TFrameCategory.ItemDefaultResize(Sender: TObject);
begin
  Self.lvSubCategory.Properties.ItemWidth:=(Self.Width-Self.lbCategory.Width)/3;
  //宽高成比例
  Self.lvSubCategory.Properties.ItemHeight:=
    Self.lvSubCategory.Properties.ItemWidth*120/100;
end;

procedure TFrameCategory.lvSubCategoryClickItem(Sender: TSkinItem);
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);

    //执行搜索
    ShowFrame(TFrame(GlobalSearchResultFrame),TFrameSearchResult,frmMain,nil,nil,nil,Application);
//    GlobalSearchResultFrame.FrameHistroy:=CurrentFrameHistroy;

  end;
end;

end.
