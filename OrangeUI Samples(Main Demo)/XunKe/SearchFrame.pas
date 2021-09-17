//convert pas to utf8 by ¥

unit SearchFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinItems,
  uUIFunction,
  SearchResultFrame,
  uSkinFireMonkeyEdit, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, uSkinFireMonkeyLabel, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyCustomList, uDrawCanvas, uSkinLabelType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameSearch = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    edtSearch: TSkinFMXEdit;
    btnAdd: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    lvHotKeywords: TSkinFMXListView;
    pnlHint: TSkinFMXPanel;
    lblHotSearchHint: TSkinFMXLabel;
    pnlLeftGap: TSkinFMXPanel;
    btnSearch: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lvHotKeywordsClickItem(Sender: TSkinItem);
    procedure btnSearchClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalSearchFrame:TFrameSearch;

implementation

uses
  MainForm,
  MainFrame;

{$R *.fmx}

procedure TFrameSearch.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameSearch.btnSearchClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //执行搜索
  ShowFrame(TFrame(GlobalSearchResultFrame),TFrameSearchResult,frmMain,nil,nil,nil,Application);
//  GlobalSearchResultFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameSearch.lvHotKeywordsClickItem(Sender: TSkinItem);
begin
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //执行搜索
  ShowFrame(TFrame(GlobalSearchResultFrame),TFrameSearchResult,frmMain,nil,nil,nil,Application);
//  GlobalSearchResultFrame.FrameHistroy:=CurrentFrameHistroy;


end;

end.
