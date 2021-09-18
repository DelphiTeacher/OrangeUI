unit SendMyVioceFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  CommonImageDataMoudle,

  uDrawCanvas,
  uSkinItems,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyImage, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinLabelType,
  uSkinButtonType, uSkinImageType, uBaseSkinControl, uSkinItemDesignerPanelType,
  uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer;

type
  //����������ͷ�����¼�
  TOnClickHeadEvent=procedure(Sender:TObject)of Object;


  TFrameSendMyVioce = class(TFrame)
    idpMyVioce: TSkinFMXItemDesignerPanel;
    imgMyHead: TSkinFMXImage;
    btnUserChatContent: TSkinFMXButton;
    lblMy: TSkinFMXLabel;
    imgListPlay: TSkinFMXImageListPlayer;
    procedure FrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    //�¼�
    OnClickHead:TOnClickHeadEvent;
    { Public declarations }
  end;

var
  GlobalSendMyVioceFrame:TFrameSendMyVioce;

implementation

{$R *.fmx}

procedure TFrameSendMyVioce.FrameClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

end.
