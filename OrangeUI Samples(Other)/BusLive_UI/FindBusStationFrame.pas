//convert pas to utf8 by ¥
unit FindBusStationFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  uSkinItems,
//  BusLineFrame,
  BusStationFrame,
  StationSensorFrame,
  FilterBusLineFrame,
  FilterBusStationFrame,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyLabel, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uDrawPicture, uSkinImageList, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uSkinLabelType, uSkinPanelType, uDrawCanvas;

type
  TFrameFindBusStation = class(TFrame)
    pnlTop: TSkinFMXPanel;
    lblFind: TSkinFMXLabel;
    lbHistroy: TSkinFMXListBox;
    imglistStation: TSkinImageList;
    btnClearHistroy: TSkinFMXButton;
    btnLocation: TSkinFMXButton;
    lblHistroyHint: TSkinFMXLabel;
    pnlKeyword: TSkinFMXPanel;
    edtKeyword: TSkinFMXEdit;
    btnGO: TSkinFMXButton;
    procedure lbHistroyClickItem(Sender: TSkinItem);
    procedure btnClearHistroyClick(Sender: TObject);
    procedure btnLocationClick(Sender: TObject);
    procedure edtKeywordClick(Sender: TObject);
    procedure btnGOClick(Sender: TObject);
  private
    procedure DoReturnFrameFromFilterBusStation(Frame:TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalFindBusStationFrame:TFrameFindBusStation;

implementation

uses
  MainForm,
  GoWhereFrame;

{$R *.fmx}

procedure TFrameFindBusStation.btnClearHistroyClick(Sender: TObject);
begin
  Self.lbHistroy.Properties.Items.Clear(True);
end;

procedure TFrameFindBusStation.DoReturnFrameFromFilterBusStation(Frame: TFrame);
begin
  Self.edtKeyword.Text:=GlobalFilterBusStationFrame.edtKeyword.Text;
//  HideFrame;//(Self);
//
//  ShowFrame(TFrame(GlobalBusStationFrame),TFrameBusStation,frmMain,nil,nil,nil,Application);
//  GlobalBusStationFrame.FrameHistroy:=FrameHistroy;
end;

procedure TFrameFindBusStation.edtKeywordClick(Sender: TObject);
begin
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalFilterBusStationFrame),TFrameFilterBusStation,frmMain,nil,nil,DoReturnFrameFromFilterBusStation,Application);
//  GlobalFilterBusStationFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameFindBusStation.lbHistroyClickItem(Sender: TSkinItem);
begin
  Self.edtKeyword.Text:=TSkinItem(Sender).Caption;

end;

procedure TFrameFindBusStation.btnGOClick(Sender: TObject);
begin
  //查看线路
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalBusStationFrame),TFrameBusStation,frmMain,nil,nil,nil,Application);
//  GlobalBusStationFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameFindBusStation.btnLocationClick(Sender: TObject);
begin
  //智能感知当前站点
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalStationSensorFrame),TFrameStationSensor,frmMain,nil,nil,nil,Application);
//  GlobalStationSensorFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalStationSensorFrame.LoadData;

//  //智能感知当前站点
//  Self.edtKeyword.Text:='我的当前位置';
end;

end.
