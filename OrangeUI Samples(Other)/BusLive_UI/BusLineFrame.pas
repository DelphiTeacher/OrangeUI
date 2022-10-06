//convert pas to utf8 by ¥
unit BusLineFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics,
  uUIFunction,
  uSkinItems,
  uFrameContext,
  CarListFrame,
//  BaiduMapFrame,
  VertBusLineFrame,
  HorzBusLineFrame,
  CarDistanceHintFrame,
  BusLiveCommonSkinMaterialModule,
  FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyButton,
  uSkinFireMonkeyImage, uSkinFireMonkeyLabel, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeySwitchPageListPanel,
  uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinSwitchPageListPanelType, uSkinButtonType, uSkinImageType, uSkinLabelType,
  uSkinPanelType;

type
  TFrameBusLine = class(TFrame,IFrameHistroyVisibleEvent)
    pnlTop: TSkinFMXPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pcMain: TSkinFMXPageControl;
    tsHorzMode: TSkinFMXTabSheet;
    tsMapMode: TSkinFMXTabSheet;
    tsCarList: TSkinFMXTabSheet;
    tsCarDistanceHint: TSkinFMXTabSheet;
    tsVertMode: TSkinFMXTabSheet;
    pnlRight: TSkinFMXPanel;
    lblPrice: TSkinFMXLabel;
    lblTimeArea: TSkinFMXLabel;
    pnlLineFromTo: TSkinFMXPanel;
    lblFromStation: TSkinFMXLabel;
    imgArrow: TSkinFMXImage;
    lblToStation: TSkinFMXLabel;
    btnSwitch: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure pcMainChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
  private
//    FBaiduMapFrame:TFrameBaiduMap;
    procedure DoShow;
    procedure DoHide;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    Constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalBusLineFrame:TFrameBusLine;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameBusLine.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameBusLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShowFrame(TFrame(GlobalVertBusLineFrame),TFrameVertBusLine,Self.tsVertMode,nil,nil,nil,Application,False);
end;

procedure TFrameBusLine.DoHide;
begin
//  if FBaiduMapFrame<>nil then FBaiduMapFrame.HideMapView;
end;

procedure TFrameBusLine.DoShow;
begin
//  if Self.pcMain.Properties.ActivePage=tsMapMode then
//  begin
//    FBaiduMapFrame.ShowMapView;
////    ShowFrame(TFrame(GlobalCarListFrame),TFrameCarList,Self.tsCarList,nil,nil,nil,Application,False);
//  end;
end;

procedure TFrameBusLine.pcMainChange(Sender: TObject);
begin
//  if Self.pcMain.Properties.ActivePage=tsVertMode then
//  begin
//    if FBaiduMapFrame<>nil then FBaiduMapFrame.HideMapView;
//    ShowFrame(TFrame(GlobalVertBusLineFrame),TFrameVertBusLine,Self.tsVertMode,nil,nil,nil,Application,False);
//  end;
//  if Self.pcMain.Properties.ActivePage=tsHorzMode then
//  begin
//    if FBaiduMapFrame<>nil then FBaiduMapFrame.HideMapView;
//    ShowFrame(TFrame(GlobalHorzBusLineFrame),TFrameHorzBusLine,Self.tsHorzMode,nil,nil,nil,Application,False);
//  end;
//  if Self.pcMain.Properties.ActivePage=tsCarList then
//  begin
//    if FBaiduMapFrame<>nil then FBaiduMapFrame.HideMapView;
//    ShowFrame(TFrame(GlobalCarListFrame),TFrameCarList,Self.tsCarList,nil,nil,nil,Application,False);
//  end;
//  if Self.pcMain.Properties.ActivePage=tsMapMode then
//  begin
//    if FBaiduMapFrame=nil then
//    begin
//      FBaiduMapFrame:=TFrameBaiduMap.Create(Self);
//      SetFrameName(FBaiduMapFrame);
//      FBaiduMapFrame.Parent:=tsMapMode;
//      FBaiduMapFrame.Align:=TAlignLayout.Client;
//      FBaiduMapFrame.SetBounds(0,Self.pcMain.Top,Width,tsMapMode.Height);
//      FBaiduMapFrame.CreateMapView;
//    end;
//    FBaiduMapFrame.ShowMapView;
////    ShowFrame(TFrame(GlobalCarListFrame),TFrameCarList,Self.tsCarList,nil,nil,nil,Application,False);
//  end;
////  if Self.pcMain.Properties.ActivePage=tsCarDistanceHint then
////  begin
////    ShowFrame(TFrame(GlobalCarDistanceHintFrame),TFrameCarDistanceHint,Self.tsCarDistanceHint,nil,nil,nil,Application,False);
//////    AllowChange:=False;
////  end;

end;

procedure TFrameBusLine.pcMainChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
//  if Self.pcMain.Properties.Pages[NewIndex]=tsCarDistanceHint then
//  begin
//    if FBaiduMapFrame<>nil then FBaiduMapFrame.HideMapView;
//
//    HideFrame;//(Self);
//    ShowFrame(TFrame(GlobalCarDistanceHintFrame),TFrameCarDistanceHint,frmMain,nil,nil,nil,Application);
//    GlobalCarDistanceHintFrame.FrameHistroy:=CurrentFrameHistroy;
//    AllowChange:=False;
//  end;
end;

end.
