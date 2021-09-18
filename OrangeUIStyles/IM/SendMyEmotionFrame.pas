unit SendMyEmotionFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  CommonImageDataMoudle,

  uDrawCanvas,
  uSkinItems,

  uSkinFireMonkeyControl, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uBaseSkinControl,
  uSkinItemDesignerPanelType, uSkinImageListPlayerType,
  uSkinFireMonkeyImageListPlayer;

type
  //头像点击事件
  TOnClickHeadEvent=procedure(Sender:TObject) of Object;

  TFrameSendMyEmotion = class(TFrame)
    idpMyEmotion: TSkinFMXItemDesignerPanel;
    imgMyHead: TSkinFMXImage;
    imgMyEmotion: TSkinFMXImage;
    imgListPlay: TSkinFMXImageListPlayer;
    procedure imgMyHeadClick(Sender: TObject);
  private
    { Private declarations }
  public
    OnClickHead:TOnClickHeadEvent;
    { Public declarations }
  end;

var
  GlobalSendMyEmotionFrame:TFrameSendMyEmotion;

implementation

{$R *.fmx}

procedure TFrameSendMyEmotion.imgMyHeadClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

end.
