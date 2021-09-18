unit SendVioceFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  CommonImageDataMoudle,

  uSkinFireMonkeyControl, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyButton, uSkinLabelType, uSkinButtonType,
  uSkinImageType, uBaseSkinControl, uSkinItemDesignerPanelType;

type
  //头像点击事件
  TOnClickHeadEvent=procedure(Sender:TObject)of Object;

  TFrameSendVioce = class(TFrame)
    idpVioce: TSkinFMXItemDesignerPanel;
    imgUserPic: TSkinFMXImage;
    btnUserChatContent: TSkinFMXButton;
    lblOther: TSkinFMXLabel;
    imgUnListen: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    procedure imgUserPicClick(Sender: TObject);
  private
    { Private declarations }
  public
    //事件
    OnClickHead:TOnClickHeadEvent;
    { Public declarations }
  end;

var
  GlobalSendVioceFrame:TFrameSendVioce;

implementation

{$R *.fmx}

procedure TFrameSendVioce.imgUserPicClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

end.
