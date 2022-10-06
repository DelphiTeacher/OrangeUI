//convert pas to utf8 by ¥
unit StationInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  StationMapFrame,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyButton,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel,
  uSkinMaterial,
  uSkinButtonType,
  uDrawPicture,
  uSkinImageList, uSkinLabelType, uSkinPanelType;

type
  TFrameStationInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlClient: TSkinFMXPanel;
    lblStationName: TSkinFMXLabel;
    lblStationAddress: TSkinFMXLabel;
    lblDistance: TSkinFMXLabel;
    btnFuncButtonMaterial: TSkinButtonDefaultMaterial;
    btnTo: TSkinFMXButton;
    btnStationMap: TSkinFMXButton;
    btnFrom: TSkinFMXButton;
    btnSearch: TSkinFMXButton;
    imglistFuncButtonIcon: TSkinImageList;
    btnRealTime: TSkinFMXButton;
    imglistFuncButtonIcon2: TSkinImageList;
    btnCheckIn: TSkinFMXButton;
    btnComment: TSkinFMXButton;
    btnShare: TSkinFMXButton;
    procedure btnFromClick(Sender: TObject);
    procedure btnToClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnStationMapClick(Sender: TObject);
    procedure pnlClientResize(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalStationInfoFrame:TFrameStationInfo;

implementation

uses
  NearByFrame,
  FindBusMethodFrame,
  MainForm;

{$R *.fmx}

procedure TFrameStationInfo.btnToClick(Sender: TObject);
begin
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalFindBusMethodFrame),TFrameFindBusMethod,frmMain,nil,nil,nil,Application);
  GlobalFindBusMethodFrame.pnlToolBar.Visible:=True;
//  GlobalFindBusMethodFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalFindBusMethodFrame.LoadData('','东葛古城站');
end;

procedure TFrameStationInfo.pnlClientResize(Sender: TObject);
begin
  //
  Self.btnRealTime.Left:=(Width-Self.btnRealTime.Left)/2;
  Self.btnCheckIn.Left:=(Width-Self.btnCheckIn.Left)/2;
  Self.btnComment.Left:=(Width-Self.btnComment.Left)/2;
  Self.btnShare.Left:=(Width-Self.btnShare.Left)/2;
end;

procedure TFrameStationInfo.btnStationMapClick(Sender: TObject);
begin
  //显示站点地图
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalStationMapFrame),TFrameStationMap,frmMain,nil,nil,nil,Application);
//  GlobalStationMapFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalStationMapFrame.LoadData;
end;

procedure TFrameStationInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameStationInfo.btnFromClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ShowFrame(TFrame(GlobalFindBusMethodFrame),TFrameFindBusMethod,frmMain,nil,nil,nil,Application);
  GlobalFindBusMethodFrame.pnlToolBar.Visible:=True;
//  GlobalFindBusMethodFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalFindBusMethodFrame.LoadData('东葛古城站','');
end;

procedure TFrameStationInfo.btnSearchClick(Sender: TObject);
begin
  //搜索
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalNearByFrame),TFrameNearBy,frmMain,nil,nil,nil,Application);
//  GlobalNearByFrame.FrameHistroy:=CurrentFrameHistroy;
end;



end.
