//convert pas to utf8 by ¥
unit MyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  SpiritFrame,
  EditMyFrame,

  uSkinItems,
  uDrawPicture,

  WaitingFrame,
  MessageBoxFrame,

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,
  ClientModuleUnit1,
  FriendCircleCommonMaterialDataMoudle,

  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyRoundImage, uSkinFireMonkeyCustomList, uSkinImageType,
  uSkinRoundImageType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uBaseSkinControl, uSkinPanelType, uDrawCanvas;

type
  TFrameMy = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbMenu: TSkinFMXListBox;
    Item1: TSkinFMXItemDesignerPanel;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblItem1CaptionHint: TSkinFMXLabel;
    lblItem1Caption: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    lblItem1Detail: TSkinFMXLabel;
    SkinFMXImage3: TSkinFMXImage;
    SkinFMXLabel7: TSkinFMXLabel;
    imgItem1Icon: TSkinFMXRoundImage;
    SkinFMXLabel1: TSkinFMXLabel;
    lblItem1Detail1: TSkinFMXLabel;
    procedure lbMenuClickItem(Sender: TSkinItem);
  private

    { Private declarations }
  public
    procedure Load;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

implementation

uses
  MainForm,
  MainFrame,
  ChangePasswordFrame,
  AboutUsFrame,
  ShieldUserListFrame,
  LoginFrame;

{$R *.fmx}

{ TFrameMy }

constructor TFrameMy.Create(AOwner:TComponent);
begin
  inherited;


end;

destructor TFrameMy.Destroy;
begin

  inherited;
end;




procedure TFrameMy.lbMenuClickItem(Sender: TSkinItem);
begin
  if Sender.ItemType=sitItem1 then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //编辑
    ShowFrame(TFrame(GlobalEditMyFrame),TFrameEditMyFrame,frmMain,nil,nil,nil,Application);
//    GlobalEditMyFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalEditMyFrame.Load;
  end;
  if Sender.Caption='退出登录' then
  begin
    frmMain.Logout;


    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //显示登录
    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;

  end;
  if Sender.Caption='屏蔽的人' then
  begin
    HideFrame;//(GlobalMainFrame);
    ShowFrame(TFrame(GlobalShieldUserListFrame),TFrameShieldUserList,frmMain,nil,nil,nil,Application);
    GlobalShieldUserListFrame.lbList.Prop.Items.Clear;
    GlobalShieldUserListFrame.Load;
  end;
  if Sender.Caption='密码修改' then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //修改密码
    ShowFrame(TFrame(GlobalChangePasswordFrame),TFrameChangePassword,frmMain,nil,nil,nil,Application);
//    GlobalChangePasswordFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalChangePasswordFrame.Clear;

  end;
  if Sender.Caption='关于我们' then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //关于我们
    ShowFrame(TFrame(GlobalAboutUsFrame),TFrameAboutUs,frmMain,nil,nil,nil,Application);
//    GlobalAboutUsFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
end;

procedure TFrameMy.Load;
begin
  //头像
  Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Icon.Url:=
    GlobalManager.User.GetHeadPicUrl;
  Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Icon.PictureDrawType:=
    TPictureDrawType.pdtUrl;
  Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Caption:=
    GlobalManager.User.Name;
  Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Detail:=
    GlobalManager.User.CompanyName;
  Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Detail1:=
    GlobalManager.User.Phone;

end;

end.
