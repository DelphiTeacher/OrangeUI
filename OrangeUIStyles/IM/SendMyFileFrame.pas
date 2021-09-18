unit SendMyFileFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  CommonImageDataMoudle,

  uDrawCanvas,
  uSkinItems,

  uSkinFireMonkeyButton, uSkinFireMonkeyImage, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinButtonType, uSkinImageType, uBaseSkinControl, uSkinItemDesignerPanelType,
  uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer;

type
  TOnClickHeadEvent=procedure(Sender:TObject)of Object;

  TFrameSendMyFile = class(TFrame)
    idpMyFile: TSkinFMXItemDesignerPanel;
    imgMyHead: TSkinFMXImage;
    btnMyFile: TSkinFMXButton;
    imgListPlay: TSkinFMXImageListPlayer;
    procedure imgMyHeadClick(Sender: TObject);
  private
    { Private declarations }
  public
    //头像点击事件
    OnClickHead:TOnClickHeadEvent;
    procedure LoadPicture(AString:String);
    { Public declarations }
  end;

var
  GlobalSendMyFileFrame:TFrameSendMyFile;

implementation

{$R *.fmx}

{ TFrame1 }

procedure TFrameSendMyFile.imgMyHeadClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

procedure TFrameSendMyFile.LoadPicture(AString: String);
var
  I: Integer;
begin
  for I := 0 to dmCommonImageDataMoudle.imgFilePicList.Count-1 do
  begin
    if dmCommonImageDataMoudle.imgFilePicList.PictureList[I].Name=AString then
    begin
      Self.btnMyFile.Prop.Icon.ImageIndex:=dmCommonImageDataMoudle.imgFilePicList.PictureList[I].CurrentEffectImageIndex;
    end;
  end;

end;

end.
