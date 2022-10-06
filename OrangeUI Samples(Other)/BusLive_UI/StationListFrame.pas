//convert pas to utf8 by ¥
unit StationListFrame;

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
  TFrameStationList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbStation: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    imglistIndex: TSkinImageList;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    lblDistanceHint: TSkinFMXLabel;
    btnInfo: TSkinFMXButton;
    pnlLineFromTo: TSkinFMXPanel;
    lblFromStation: TSkinFMXLabel;
    imgArrow: TSkinFMXImage;
    lblFindHint: TSkinFMXLabel;
    lblAt: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbStationClickItem(Sender: TSkinItem);
    procedure btnInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure LoadData(AClassify:String);
    { Public declarations }
  end;

var
  GlobalStationListFrame:TFrameStationList;

implementation

{$R *.fmx}

uses
  MainForm;


procedure TFrameStationList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameStationList.btnInfoClick(Sender: TObject);
begin
  //显示站点详情
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalStationInfoFrame),TFrameStationInfo,frmMain,nil,nil,nil,Application);
//  GlobalStationInfoFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameStationList.lbStationClickItem(Sender: TSkinItem);
begin
  //显示站点地图
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalStationMapFrame),TFrameStationMap,frmMain,nil,nil,nil,Application);
//  GlobalStationMapFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalStationMapFrame.LoadData;
end;

procedure TFrameStationList.LoadData(AClassify: String);
begin
  Self.pnlToolBar.Caption:=AClassify+'查询';
end;

end.
