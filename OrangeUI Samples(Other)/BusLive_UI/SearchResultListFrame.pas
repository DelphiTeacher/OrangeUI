//convert pas to utf8 by ¥
unit SearchResultListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  uSkinItems,
  BusLiveCommonSkinMaterialModule,
  StationInfoFrame,
  StationMapFrame,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyLabel, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uSkinPanelType, uDrawCanvas;

type
  TFrameSearchResultList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXListBox1: TSkinFMXListBox;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    imglistIndex: TSkinImageList;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    btnInfo: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure SkinFMXListBox1ClickItem(Sender: TSkinItem);
    procedure btnInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalSearchResultListFrame:TFrameSearchResultList;

implementation

{$R *.fmx}

uses
  MainForm;


procedure TFrameSearchResultList.btnInfoClick(Sender: TObject);
begin
  //显示站点地图
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalStationMapFrame),TFrameStationMap,frmMain,nil,nil,nil,Application);
//  GlobalStationMapFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalStationMapFrame.LoadData;

end;

procedure TFrameSearchResultList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameSearchResultList.SkinFMXListBox1ClickItem(Sender: TSkinItem);
begin
  //显示站点详情
  HideFrame;////(Self);
  ShowFrame(TFrame(GlobalStationInfoFrame),TFrameStationInfo,frmMain,nil,nil,nil,Application);
//  GlobalStationInfoFrame.FrameHistroy:=CurrentFrameHistroy;

end;

end.
