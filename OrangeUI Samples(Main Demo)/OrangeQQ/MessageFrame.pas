﻿//convert pas to utf8 by ¥

unit MessageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinImageList,
  uSkinFireMonkeyImage, uSkinFireMonkeyLabel,uUIFunction,uDrawCanvas,
  uSkinScrollBarType,
  uSkinItems,
  uBaseLog,
  TalkFrame,
  uSkinListBoxType,
  uSkinFireMonkeyButton, uSkinFireMonkeyFrameImage,
  uSkinFireMonkeyNotifyNumberIcon, uDrawPicture, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyRoundImage, uSkinFireMonkeyCustomList,
  uSkinNotifyNumberIconType, uSkinRoundImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinFrameImageType, uSkinButtonType, uSkinImageType,
  uSkinPanelType;

type
  TFrameMessage = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbMessageList: TSkinFMXListBox;
    ItemSearchBar: TSkinFMXItemDesignerPanel;
    imglistHead: TSkinImageList;
    imgToolBarDevide: TSkinFMXImage;
    btnFunctionList: TSkinFMXButton;
    ItemMessage: TSkinFMXItemDesignerPanel;
    imgMessageHead: TSkinFMXRoundImage;
    lblMessageNickName: TSkinFMXLabel;
    lblMessageDetail: TSkinFMXLabel;
    lblMessageTime: TSkinFMXLabel;
    imgSearchBackground: TSkinFMXImage;
    imgSearchIcon: TSkinFMXImage;
    lblSearchHint: TSkinFMXLabel;
    btnCall: TSkinFMXButton;
    btnMessage: TSkinFMXButton;
    idpItemPanDrag: TSkinFMXItemDesignerPanel;
    SkinFMXButton2: TSkinFMXButton;
    btnDel: TSkinFMXButton;
    imgHeader: TSkinFMXFrameImage;
    pnlDevide: TSkinFMXPanel;
    nniMessageUnReadCount: TSkinFMXNotifyNumberIcon;
    procedure imgSearchBackgroundResize(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure pnlToolBarResize(Sender: TObject);
    procedure lbMessageListClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalMessageFrame:TFrameMessage;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame;


{ TFrameMessage }

procedure TFrameMessage.btnDelClick(Sender: TObject);
begin
  Self.lbMessageList.Properties.Items.Remove(Self.lbMessageList.Properties.PanDragItem,True);
end;

procedure TFrameMessage.pnlToolBarResize(Sender: TObject);
begin
  btnMessage.Left:=(pnlToolBar.WidthInt-btnMessage.WidthInt*2) div 2;
  btnCall.Left:=btnMessage.Left+btnMessage.WidthInt;
end;

constructor TFrameMessage.Create(AOwner: TComponent);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  inherited;
  Self.lbMessageList.Properties.Items.BeginUpdate;
  try
    for I := 0 to 10 do
    begin
      AListBoxItem:=Self.lbMessageList.Properties.Items.Add;

      AListBoxItem.Caption:='测试昵称'+IntToStr(I);
      AListBoxItem.Detail:='测试消息 测试消息 测试消息';
      AListBoxItem.Detail1:='12:44';
      if I mod 3=0 then
      begin
        AListBoxItem.Icon.ImageIndex:=0;
      end;
      if I mod 3=1 then
      begin
        AListBoxItem.Icon.ImageIndex:=3;
      end;
      if I mod 3=2 then
      begin
        AListBoxItem.Icon.ImageIndex:=4;
      end;
    end;
  finally
    Self.lbMessageList.Properties.Items.EndUpdate;
  end;

end;

procedure TFrameMessage.imgSearchBackgroundResize(Sender: TObject);
begin
  Self.imgSearchIcon.Left:=(Self.imgSearchBackground.WidthInt-40) div 2;
  Self.lblSearchHint.Left:=Self.imgSearchIcon.Left+Self.imgSearchIcon.WidthInt;;
end;

procedure TFrameMessage.lbMessageListClickItem(Sender: TSkinItem);
begin
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示聊天界面
  ShowFrame(TFrame(GlobalTalkFrame),TFrameTalk,frmMain,nil,nil,nil,Application);
//  GlobalTalkFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.

