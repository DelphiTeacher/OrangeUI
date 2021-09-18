unit SendEmotionFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  CommonImageDataMoudle,

  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyItemDesignerPanel,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uBaseSkinControl,
  uSkinItemDesignerPanelType;

type
  //头像点击事件
  TOnClickHeadEvent=procedure(Sender:TObject) of Object;

  TFrameSendEmotion = class(TFrame)
    idpEmotion: TSkinFMXItemDesignerPanel;
    imgUserPic: TSkinFMXImage;
    imgEmotion: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    procedure imgUserPicClick(Sender: TObject);
  private
    { Private declarations }
  public
    OnClickHead:TOnClickHeadEvent;
    { Public declarations }
  end;

var
  GlobalSendEmotionFrame:TFrameSendEmotion;

implementation

{$R *.fmx}

procedure TFrameSendEmotion.imgUserPicClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

end.
