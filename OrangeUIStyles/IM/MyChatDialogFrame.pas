unit MyChatDialogFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
//  CommonImageDataMoudle,

  uDrawCanvas,
  uSkinItems,

  uSkinFireMonkeyButton, uSkinFireMonkeyImage, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyItemDesignerPanel, uSkinButtonType,
  uSkinImageType, uBaseSkinControl, uSkinItemDesignerPanelType, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer,
  uDrawPicture, uSkinImageList, uSkinCalloutRectType;

type
  //ͷ�����¼�
  TOnClickHeadEvent=procedure(Sender:TObject) of Object;

  TFrameMyChatDialog = class(TFrame)
    idpMyChat: TSkinFMXItemDesignerPanel;
    imgMyHead: TSkinFMXImage;
    crMyDialog: TSkinFMXCalloutRect;
    lblName: TSkinFMXLabel;
    imgUserVip: TSkinFMXImage;
    procedure idpMyChatPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
    procedure imgMyHeadClick(Sender: TObject);  private
    { Private declarations }
  public
    OnClickHead:TOnClickHeadEvent;
    { Public declarations }
  end;

var
  GlobalMyChatDialogFrame:TFrameMyChatDialog;

implementation

{$R *.fmx}

procedure TFrameMyChatDialog.idpMyChatPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRectF);
begin
  Self.crMyDialog.Anchors:=[TAnchorKind.akLeft,TAnchorKind.akTop];
//  //����Button�Ŀ�Ⱥ͸߶�
//  if AItem.Tag1>(AItemDrawRect.Width-Self.imgMyHead.Width-45) then
//  begin
//    //��ȳ�����
//    Self.crMyDialog.Width:=AItemDrawRect.Width-Self.imgMyHead.Width-20-20-5;
//    Self.crMyDialog.Left:=20;
//
//  end
//  else
//  begin
    Self.crMyDialog.Width:=AItem.Tag1;//+20;
    Self.crMyDialog.Left:=AItemDrawRect.Width
                          -AItem.Tag1
                          //ͷ�����Ϣ�ļ��
                          -10
                           -Self.imgMyHead.Width
                           //ͷ����ұ߾�ļ��
                           -10;
//  end;

  Self.crMyDialog.Height:=AItem.Tag;



//  Self.imgListPlay.Left:=Self.crMyDialog.Left-50;
//  Self.imgListPlay.Top:=Self.crMyDialog.Height-10;

end;

procedure TFrameMyChatDialog.imgMyHeadClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

end.
