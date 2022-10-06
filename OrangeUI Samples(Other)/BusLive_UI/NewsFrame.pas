//convert pas to utf8 by ¥
unit NewsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  NewsListFrame,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyPanel, uDrawPicture, uSkinImageList, uSkinFireMonkeyButton,
  uSkinButtonType, uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyImageListViewer, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyLabel, uSkinLabelType, uSkinMaterial, uSkinPanelType,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinScrollControlType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListView,
  uSkinListViewType, uSkinCustomListType, uSkinImageListViewerType,
  uSkinScrollBoxContentType, uSkinScrollBoxType, uDrawCanvas, uSkinItems;

type
  TFrameNews = class(TFrame)
    imglistPlayer: TSkinImageList;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXScrollBox1: TSkinFMXScrollBox;
    SkinFMXScrollBoxContent1: TSkinFMXScrollBoxContent;
    imgPlayer: TSkinFMXImageListViewer;
    btnPlayer: TSkinFMXButtonGroup;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXListView1: TSkinFMXListView;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXButton2: TSkinFMXButton;
    SkinFMXListView2: TSkinFMXListView;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXButton3: TSkinFMXButton;
    SkinFMXListView3: TSkinFMXListView;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXButton5: TSkinFMXButton;
    SkinFMXListView4: TSkinFMXListView;
    SkinFMXListView5: TSkinFMXListView;
    SkinFMXPanel5: TSkinFMXPanel;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXButton6: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure SkinFMXButton1StayClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalNewsFrame:TFrameNews;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameNews.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameNews.SkinFMXButton1StayClick(Sender: TObject);
begin
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalNewsListFrame),TFrameNewsList,frmMain,nil,nil,nil,Application);
//  GlobalNewsListFrame.FrameHistroy:=CurrentFrameHistroy;

end;

end.
