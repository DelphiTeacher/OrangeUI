unit ChatDialogFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
//  CommonImageDataMoudle,

  uDrawCanvas,
  uSkinItems,

//  FastMsg.Client.Database,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel, uDrawPicture,
  uSkinImageList, uSkinButtonType, uSkinImageType, uBaseSkinControl,
  uSkinItemDesignerPanelType, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinCalloutRectType;

type
  //头像点击事件
  TOnClickHeadEvent=procedure(Sender:TObject) of Object;

  TFrameChatDialog = class(TFrame)
    idpChat: TSkinFMXItemDesignerPanel;
    imgUserPic: TSkinFMXImage;
    crDialog: TSkinFMXCalloutRect;
    lblName: TSkinFMXLabel;
    imgUserVip: TSkinFMXImage;
    procedure idpChatPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
//    procedure imgUserPicClick(Sender: TObject);  private
    { Private declarations }
  public
    //头像点击事件
    OnClickHead:TOnClickHeadEvent;
    //加载对话框
//    procedure LoadChat(ARecord_Message:TDBRecord_Message);
    { Public declarations }
  end;



var
  GlobalChatDialogFrame:TFrameChatDialog;

implementation

{$R *.fmx}

{ TFrameChatDialog }

procedure TFrameChatDialog.idpChatPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRectF);
begin
  //设置Botton的高度和宽度
//  if AItem.Tag1>(AItemDrawRect.Width-Self.imgUserPic.Width-20-25) then
//  begin
//    Self.crDialog.Width:=AItemDrawRect.Width-Self.imgUserPic.Width-20-25;
//  end
//  else
//  begin
    Self.crDialog.Width:=AItem.Tag1;//+15;
//  end;

//  Self.crDialog.Left:=Self.imgUserPic.Width+15;

  Self.crDialog.Height:=AItem.Tag;

  if AItem.Accessory=TSkinAccessoryType.satNone then
  begin
    Self.crDialog.Top:=Self.imgUserPic.Top;
  end
  else
  begin
    Self.crDialog.Top:=Self.lblName.Top+Self.lblName.Height;
  end;
end;
//
//procedure TFrameChatDialog.imgUserPicClick(Sender: TObject);
//begin
//  if Assigned(OnClickHead) then
//  begin
//    OnClickHead(Sender);
//  end;
//
//end;

//procedure TFrameChatDialog.LoadChat(ARecord_Message: TDBRecord_Message);
//begin
//  Self.crDialog.Caption:=ARecord_Message.Content;
//end;

end.
