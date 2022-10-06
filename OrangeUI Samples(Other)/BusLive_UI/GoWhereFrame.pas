//convert pas to utf8 by ¥
unit GoWhereFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uUIFunction,
  uSkinItems,
  NearByFrame,
  FindBusLineFrame,
  FindBusStationFrame,
  FindBusMethodFrame,
  FindBusCarNoFrame,
  uSkinListBoxType,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeySwitchPageListPanel,
  uSkinPageControlType, uSkinFireMonkeyPageControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas;

type
  TFrameGoWhere = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pcSwitch: TSkinFMXPageControl;
    tsMenu: TSkinFMXTabSheet;
    tsClient: TSkinFMXTabSheet;
    pcMain: TSkinFMXPageControl;
    tsFindStation: TSkinFMXTabSheet;
    tsMethod: TSkinFMXTabSheet;
    tsSearchCardNo: TSkinFMXTabSheet;
    tsShop: TSkinFMXTabSheet;
    tsBusLine: TSkinFMXTabSheet;
    lbMenu: TSkinFMXListBox;
    SkinFMXListBox1: TSkinFMXListBox;
    procedure lbMenuClickItem(Sender: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalGoWhereFrame:TFrameGoWhere;

implementation

uses
  MainForm;

{$R *.fmx}

{ TFrameGoWhere }

procedure TFrameGoWhere.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameGoWhere.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.pcMain.Properties.Orientation:=toNone;
  Self.pcSwitch.Properties.Orientation:=toNone;

  Self.pcSwitch.Properties.ActivePage:=Self.tsClient;
  Self.pcMain.Properties.ActivePage:=Self.tsBusLine;

  Self.lbMenu.OnClickItem(Self.lbMenu.Properties.SelectedItem);

//  Self.pcSwitch.Properties.SwitchPageListControlGestureManager.CanGestureSwitch:=True;
//  Self.pcSwitch.Properties.SwitchPageListControlGestureManager.GestureSwitchLooped:=False;
//  Self.pcSwitch.Properties.SwitchPageListControlGestureManager.ControlGestureManager.IsUseDecideFirstMouseMoveKind:=True;
//
//  Self.pcSwitch.Properties.SwitchPageListControlGestureManager.SwitchPrior;
end;

procedure TFrameGoWhere.lbMenuClickItem(Sender: TSkinItem);
begin
  //选中某一项，显示某一页
  if TSkinItem(Sender).Caption='公交线路' then
  begin
    Self.pcMain.Properties.ActivePage:=Self.tsBusLine;
    ShowFrame(TFrame(GlobalFindBusLineFrame),TFrameFindBusLine,tsBusLine,nil,nil,nil,Application,False);
  end;
  if TSkinItem(Sender).Caption='站点搜寻' then
  begin
    Self.pcMain.Properties.ActivePage:=Self.tsFindStation;
    ShowFrame(TFrame(GlobalFindBusStationFrame),TFrameFindBusStation,tsFindStation,nil,nil,nil,Application,False);
  end;
  if TSkinItem(Sender).Caption='出行方案' then
  begin
    Self.pcMain.Properties.ActivePage:=Self.tsMethod;
    ShowFrame(TFrame(GlobalFindBusMethodFrame),TFrameFindBusMethod,tsMethod,nil,nil,nil,Application,False);
    GlobalFindBusMethodFrame.pnlToolBar.Visible:=False;
  end;
  if TSkinItem(Sender).Caption='查车牌号' then
  begin
    Self.pcMain.Properties.ActivePage:=Self.tsSearchCardNo;
    ShowFrame(TFrame(GlobalFindBusCarNoFrame),TFrameFindBusCarNo,tsSearchCardNo,nil,nil,nil,Application,False);
  end;
  if TSkinItem(Sender).Caption='周边商城' then
  begin
//    Self.pcMain.Properties.ActivePage:=Self.tsShop;
//    ShowFrame(TFrame(GlobalNearByFrame),TFrameNearBy,tsShop,nil,nil,nil,Application,False);
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalNearByFrame),TFrameNearBy,frmMain,nil,nil,nil,Application);
//    GlobalNearByFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
end;

end.
