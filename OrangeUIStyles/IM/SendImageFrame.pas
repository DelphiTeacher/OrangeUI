unit SendImageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uDrawCanvas,
  uSkinItems,

//  CommonImageDataMoudle,

//  FastMsg.Client,
  System.IOUtils,

  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyItemDesignerPanel,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uBaseSkinControl,
  uSkinItemDesignerPanelType, uSkinButtonType;

type
  //头像点击事件
  TOnClickHeadEvent=procedure(Sender:TObject) of Object;


  TFrameSendImage = class(TFrame)
    idpImage: TSkinFMXItemDesignerPanel;
    imgUserPic: TSkinFMXImage;
    imgPic: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    imgUserVip: TSkinFMXImage;
//    procedure imgUserPicClick(Sender: TObject);
    procedure idpImagePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
//    OnClickHead:TOnClickHeadEvent;
    { Public declarations }
  end;

var
  GlobalSendImageFrame:TFrameSendImage;

implementation

{$R *.fmx}

{ TFrameSendImage }



//procedure TFrameSendImage.imgUserPicClick(Sender: TObject);
//begin
//  if Assigned(OnClickHead) then
//  begin
//    OnClickHead(Sender);
//  end;
//end;

procedure TFrameSendImage.idpImagePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRectF);
begin

  if AItem.Accessory=TSkinAccessoryType.satNone then
  begin
    Self.imgPic.Top:=Self.imgUserPic.Top;
  end
  else
  begin
    Self.imgPic.Top:=Self.lblName.Top+Self.lblName.Height;
  end;

end;

end.
