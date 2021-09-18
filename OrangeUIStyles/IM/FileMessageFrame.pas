unit FileMessageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  CommonImageDataMoudle,


  uSkinFireMonkeyControl, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage,
  uSkinFireMonkeyButton, uSkinButtonType, uSkinImageType, uBaseSkinControl,
  uSkinItemDesignerPanelType, uSkinLabelType, uSkinFireMonkeyLabel;

type
  //头像点击事件
  TOnClickHeadEvent=procedure(Sender:TObject)of Object;

  TFrameFileMessage = class(TFrame)
    idpFile: TSkinFMXItemDesignerPanel;
    imgHeader: TSkinFMXImage;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXLabel1: TSkinFMXLabel;
    procedure imgHeaderClick(Sender: TObject);
  private
    { Private declarations }
  public
    //点击事件
    OnClickHead:TOnClickHeadEvent;
    //加载图标
    procedure LoadPicture(AString:String);
    { Public declarations }
  end;
var
  GlobalFileMessageFrame:TFrameFileMessage;

implementation

{$R *.fmx}

{ TFrameFileMessage }

procedure TFrameFileMessage.imgHeaderClick(Sender: TObject);
begin
  if Assigned(OnClickHead) then
  begin
    OnClickHead(Sender);
  end;
end;

procedure TFrameFileMessage.LoadPicture(AString: String);
var
  I: Integer;
begin
  for I := 0 to dmCommonImageDataMoudle.imgFilePicList.Count-1 do
  begin
    if dmCommonImageDataMoudle.imgFilePicList.PictureList[I].Name=AString then
    begin
      Self.SkinFMXButton1.Prop.Icon.ImageIndex:=dmCommonImageDataMoudle.imgFilePicList.PictureList[I].CurrentEffectImageIndex;
    end;
  end;

end;

end.
