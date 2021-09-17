//convert pas to utf8 by ¥

unit Basic_DesignerPanel_MessageFrame;

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
  uSkinListBoxType,
  uSkinFireMonkeyButton, uSkinFireMonkeyFrameImage,
  uSkinFireMonkeyNotifyNumberIcon, uDrawPicture, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyRoundImage, uSkinFireMonkeyCustomList, uSkinButtonType,
  uSkinNotifyNumberIconType, uSkinLabelType, uSkinImageType,
  uSkinRoundImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType;

type
  TFrameBasic_DesignerPanel_Message = class(TFrame)
    lbMessageList: TSkinFMXListBox;
    imglistHead: TSkinImageList;
    ItemMessage: TSkinFMXItemDesignerPanel;
    imgMessageHead: TSkinFMXRoundImage;
    lblMessageNickName: TSkinFMXLabel;
    lblMessageDetail: TSkinFMXLabel;
    lblMessageTime: TSkinFMXLabel;
    idpItemPanDrag: TSkinFMXItemDesignerPanel;
    SkinFMXButton2: TSkinFMXButton;
    btnDel: TSkinFMXButton;
    nniMessageUnReadCount: TSkinFMXNotifyNumberIcon;
    procedure btnDelClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


implementation

{$R *.fmx}

uses
  MainForm;


{ TFrameMessage }

procedure TFrameBasic_DesignerPanel_Message.btnDelClick(Sender: TObject);
begin
  Self.lbMessageList.Properties.Items.Remove(Self.lbMessageList.Properties.PanDragItem,True);
end;

constructor TFrameBasic_DesignerPanel_Message.Create(AOwner: TComponent);
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

end.

