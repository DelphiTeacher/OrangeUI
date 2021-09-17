﻿//convert pas to utf8 by ¥

unit MobileMyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinImageList, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uUIFunction,uDrawCanvas,uSkinItems,
  uSinaWeiboManager,
  uTimerTask,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uDrawPicture, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList;

type
  TFrameMobileMy = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    imgLine: TSkinFMXImage;
    lblProfile: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    Header: TSkinFMXItemDesignerPanel;
    lblMenu: TSkinFMXLabel;
    imgHead: TSkinFMXImage;
    lblNick: TSkinFMXLabel;
    imgMenuExpand: TSkinFMXImage;
    imgExpandState: TSkinImageList;
    imgExpand: TSkinFMXImage;
    imgVIP: TSkinFMXImage;
    lblDesc: TSkinFMXLabel;
    pnlDevide: TSkinFMXPanel;
    imglstHead: TSkinImageList;
    imgMenu: TSkinFMXImage;
    ItemItem1: TSkinFMXItemDesignerPanel;
    pnlItemItem1Devide: TSkinFMXPanel;
    pnlstatuses_count: TSkinFMXPanel;
    lblstatuses_count: TSkinFMXLabel;
    lblstatuses: TSkinFMXLabel;
    pnlfriends_count: TSkinFMXPanel;
    lblfriends_count: TSkinFMXLabel;
    lblfriends: TSkinFMXLabel;
    pnlfollowers_count: TSkinFMXPanel;
    lblfollowers_count: TSkinFMXLabel;
    lblfollowers: TSkinFMXLabel;
    procedure lblProfilePrepareDrawItem(Sender: TObject;
      Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
      Item: TSkinItem; ItemRect: TRect);
    procedure lblProfileResize(Sender: TObject);
    procedure btnSettingClick(Sender: TObject);
  private
    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
  public
    constructor Create(AOwner:TComponent);override;
  public
    procedure SyncUI;
    procedure Sync;

    procedure OnAsync_Getusers_show_ExecuteEnd(ATimerTask:TObject);
    { Public declarations }
  end;



var
  GlobalMobileMyFrame:TFrameMobileMy;

implementation

{$R *.fmx}

{ TFrameSetting }

procedure TFrameMobileMy.OnAsync_Getusers_show_ExecuteEnd(ATimerTask: TObject);
begin
  SyncUI;
end;


procedure TFrameMobileMy.Sync;
begin
  //获取用户信息
  GlobalManager.Asyc_Getusers_show(GlobalManager.OAuth2User.Uid,Self.OnAsync_Getusers_show_ExecuteEnd);
end;

procedure TFrameMobileMy.SyncUI;
begin
  Self.lblNick.Caption:=GlobalManager.Current_user.screen_name;
  Self.imgVIP.Left:=Self.lblNick.Left+Self.lblNick.WidthInt+20;
  if GlobalManager.Current_user.description<>'' then
  begin
    Self.lblDesc.Caption:='简介:'+GlobalManager.Current_user.description;
  end
  else
  begin
    Self.lblDesc.Caption:='简介:暂无简介';
  end;
  Self.lblstatuses_count.Caption:=IntToStr(GlobalManager.Current_user.statuses_count);
  Self.lblfollowers_count.Caption:=IntToStr(GlobalManager.Current_user.followers_count);
  Self.lblfriends_count.Caption:=IntToStr(GlobalManager.Current_user.friends_count);

end;

procedure TFrameMobileMy.btnSettingClick(Sender: TObject);
begin
  //设置

end;

constructor TFrameMobileMy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SyncUI;
end;

procedure TFrameMobileMy.lblProfilePrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
  Self.imgMenu.Properties.Picture.ImageIndex:=Item.Icon.ImageIndex;
  Self.lblMenu.Caption:=Item.Caption;
end;

procedure TFrameMobileMy.lblProfileResize(Sender: TObject);
begin
  Self.pnlstatuses_count.Width:=(Width) / 3;
  Self.pnlfriends_count.Width:=(Width) / 3;
  Self.pnlfollowers_count.Width:=(Width) / 3;

  Self.pnlstatuses_count.Left:=0;

  Self.pnlfriends_count.Left:=pnlstatuses_count.Left+pnlstatuses_count.WidthInt;

  Self.pnlfollowers_count.Left:=pnlfriends_count.Left+pnlfriends_count.WidthInt;

end;

end.
