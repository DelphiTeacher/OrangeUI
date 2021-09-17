//convert pas to utf8 by ¥

unit ImageListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  Math,

  uVersion,
  uLang,
  uFrameContext,

  FMX.StdCtrls, uSkinImageList, uSkinFireMonkeyTrackBar, uSkinFireMonkeyImage,
  uSkinFireMonkeyControl, uSkinFireMonkeyLabel, uDrawPicture, FMX.ListBox,
  uSkinTrackBarType, uSkinImageType, uBaseSkinControl, uSkinLabelType;

type
  TFrameImageList = class(TFrame,IFrameChangeLanguageEvent)
    lblImageCanShowPictureInImageList: TSkinFMXLabel;
    imgFileExtByImageIndex: TSkinFMXImage;
    lblShowPictureBySetImageIndex: TSkinFMXLabel;
    tbChangeImageIndex: TSkinFMXTrackBar;
    imglistFileExt: TSkinImageList;
    imgFileExtByImageName: TSkinFMXImage;
    lblShowPictureBySetImageName: TSkinFMXLabel;
    cmbChangeImageName: TComboBox;
    SkinImageList1: TSkinImageList;
    procedure tbChangeImageIndexChange(Sender: TObject);
    procedure cmbChangeImageNameChange(Sender: TObject);
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameImageList.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblImageCanShowPictureInImageList.Text:=GetLangString(Self.lblImageCanShowPictureInImageList.Name,ALangKind);
  Self.lblShowPictureBySetImageIndex.Text:=GetLangString(Self.lblShowPictureBySetImageIndex.Name,ALangKind);
  Self.lblShowPictureBySetImageName.Text:=GetLangString(Self.lblShowPictureBySetImageName.Name,ALangKind);

end;

procedure TFrameImageList.cmbChangeImageNameChange(Sender: TObject);
begin
  imgFileExtByImageName.Properties.Picture.ImageName:=
    Self.cmbChangeImageName.Items[Self.cmbChangeImageName.ItemIndex]
end;

constructor TFrameImageList.Create(AOwner: TComponent);
var
  ADrawPicture:TDrawPicture;
  I: Integer;
begin
  inherited;

  cmbChangeImageName.OnChange:=nil;
  Self.cmbChangeImageName.Items.Clear;
  for I := 0 to Self.imglistFileExt.Count-1 do
  begin
    Self.cmbChangeImageName.Items.Add(Self.imglistFileExt.PictureList[I].ImageName);
  end;
  cmbChangeImageName.OnChange:=Self.cmbChangeImageNameChange;


  //ImageList最后一张图片改成从网上下载测试
  ADrawPicture:=Self.imglistFileExt.PictureList.Add;
  ADrawPicture.Url:='http://avatar.csdn.net/7/9/6/1_delphiteacher.jpg';


  //初始多语言
  RegLangString(Self.lblImageCanShowPictureInImageList.Name,[Self.lblImageCanShowPictureInImageList.Text,'Image can display picture in imagelist']);
  RegLangString(Self.lblShowPictureBySetImageIndex.Name,[Self.lblShowPictureBySetImageIndex.Text,'diplay by set ImageIndex']);
  RegLangString(Self.lblShowPictureBySetImageName.Name,[Self.lblShowPictureBySetImageName.Text,'diplay by set ImageName']);

end;

procedure TFrameImageList.tbChangeImageIndexChange(Sender: TObject);
begin
  imgFileExtByImageIndex.Properties.Picture.ImageIndex:=
    Ceil(Self.tbChangeImageIndex.Properties.Position);
end;

end.
