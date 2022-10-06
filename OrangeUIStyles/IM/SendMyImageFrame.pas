unit SendMyImageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

//  CommonImageDataMoudle,
//  FastMsg.Client,
  System.IOUtils,

  uDrawCanvas,
  uSkinItems,

  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyItemDesignerPanel,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uBaseSkinControl,
  uSkinItemDesignerPanelType, uSkinImageListPlayerType,
  uSkinFireMonkeyImageListPlayer;

type
  //头像点击事件
  TOnClickHeadEvent=procedure(Sender:TObject)of Object;

  TFrameSendMyImage = class(TFrame)
    idpMyPic: TSkinFMXItemDesignerPanel;
    imgMyHead: TSkinFMXImage;
    imgMyPic: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    imgUserVip: TSkinFMXImage;
    procedure imgMyHeadClick(Sender: TObject);
  private
    { Private declarations }
  public
    //事件
    OnClickHead:TOnClickHeadEvent;
    { Public declarations }
  end;

var
  GlobalSendMyImageFrame:TFrameSendMyImage;

implementation

{$R *.fmx}

{ TFrameSendMyImage }


procedure TFrameSendMyImage.imgMyHeadClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

end.
