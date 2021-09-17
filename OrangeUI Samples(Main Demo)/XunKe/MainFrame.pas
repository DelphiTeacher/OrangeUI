//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinPageControlType, uSkinFireMonkeyPageControl,
  ShopCartFrame,
  HomeFrame,
  TalkFrame,
  SettingFrame,
  ContactorFrame,
  uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel,uUIFunction, uDrawPicture, uSkinImageList,
  uSkinButtonType, uSkinNotifyNumberIconType, uSkinSwitchPageListPanelType;

type
  TFrameMain = class(TFrame)
    pcMain: TSkinFMXPageControl;
    tsTalk: TSkinFMXTabSheet;
    tsDiscovery: TSkinFMXTabSheet;
    tsHome: TSkinFMXTabSheet;
    tsMessage: TSkinFMXTabSheet;
    nniTalkCount: TSkinFMXNotifyNumberIcon;
    imglistTabIcon: TSkinImageList;
    tsShopCart: TSkinFMXTabSheet;
    procedure pcMainChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalMainFrame:TFrameMain;

implementation

{$R *.fmx}

uses
  MainForm;

{ TFrameMain }

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;

  Self.pcMain.Properties.ActivePageIndex:=0;

  //显示首页
  ShowFrame(TFrame(GlobalHomeFrame),TFrameHome,tsHome,nil,nil,nil,Application,False,True,ufsefNone);

end;

procedure TFrameMain.pcMainChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
  if NewIndex=tsMessage.Properties.PageIndex then
  begin
    AllowChange:=False;
    HideFrame;//(Self,hfcttBeforeShowFrame);
    //显示消息界面
    ShowFrame(TFrame(GlobalContactorFrame),TFrameContactor,frmMain,nil,nil,nil,Application,True,True);
//    GlobalContactorFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if NewIndex=tsTalk.Properties.PageIndex then
  begin
    AllowChange:=False;
    HideFrame;//(Self,hfcttBeforeShowFrame);
    //显示聊天界面
    ShowFrame(TFrame(GlobalTalkFrame),TFrameTalk,frmMain,nil,nil,nil,Application,True,True);
//    GlobalTalkFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if NewIndex=tsShopCart.Properties.PageIndex then
  begin
    AllowChange:=False;
    HideFrame;//(Self,hfcttBeforeShowFrame);
    //显示店铺界面
    ShowFrame(TFrame(GlobalShopCartFrame),TFrameShopCart,frmMain,nil,nil,nil,Application,True,True);
//    GlobalShopCartFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if NewIndex=tsDiscovery.Properties.PageIndex then
  begin
    AllowChange:=False;
    HideFrame;//(Self,hfcttBeforeShowFrame);
    //显示发现界面
    ShowFrame(TFrame(GlobalSettingFrame),TFrameSetting,frmMain,nil,nil,nil,Application,True,True);
//    GlobalSettingFrame.FrameHistroy:=CurrentFrameHistroy;
  end;

end;

end.
