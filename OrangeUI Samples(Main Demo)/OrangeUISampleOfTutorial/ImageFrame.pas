//convert pas to utf8 by ¥

unit ImageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Math,


  uVersion,
  uLang,
  uFrameContext,
  uFileCommon,
  uDrawPicture,
  uUrlPicture,
  uSkinPicture,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyLabel,
  FMX.Controls.Presentation, uSkinImageList, uSkinMaterial, uSkinImageType,
  uDownloadPictureManager, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinScrollBoxContentType, uBaseSkinControl, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinButtonType, uSkinFireMonkeyButton, FMX.Layouts,
  FMX.ExtCtrls, FMX.Objects;

type
  TFrameImage = class(TFrame,IFrameChangeLanguageEvent)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgAutoFitAndStretch: TSkinFMXImage;
    imgHorzThreeDevideStretch: TSkinFMXImage;
    imgNormalStretch: TSkinFMXImage;
    imgOriginPicture: TSkinFMXImage;
    imgSquareStretch: TSkinFMXImage;
    imgUrlPicture: TSkinFMXImage;
    lblImageHasSomeStretchMode: TLabel;
    imgVertThreeDevideStretch: TSkinFMXImage;
    lblHorzThreeDevideStretch: TLabel;
    lblVertThreeDevideStretch: TLabel;
    lblSquareStretch: TLabel;
    lblNormalStretch: TLabel;
    lblUrlPicture: TLabel;
    lblOriginPicture: TLabel;
    lblAutoFitAndStretch: TLabel;
    imgOriginPicture1: TSkinFMXImage;
    imgNormalStretch1: TSkinFMXImage;
    imgAutoFitAndStretch1: TSkinFMXImage;
    SkinFMXButton1: TSkinFMXButton;
    btnUserChatContent: TSkinFMXButton;
    imlistLoading2: TSkinImageList;
    imgRotateSkinImageList: TSkinFMXImage;
    lblRotateSkinImageList: TLabel;
    lblUseOnGetPictureEvent: TLabel;
    imgUseOnGetPictureEvent: TSkinFMXImage;
    SkinImageList1: TSkinImageList;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXImage2: TSkinFMXImage;
    ImageViewer1: TImageViewer;
    Button1: TButton;
    Image1: TImage;
    SkinFMXImage3: TSkinFMXImage;
    procedure Button1Click(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  private
    FPicture:TSkinPicture;
    procedure DoGetPicture(Sender:TObject;var ASkinPicture:TSkinPicture);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;


implementation


{$R *.fmx}

{ TFrameImage }

procedure TFrameImage.Button1Click(Sender: TObject);
begin
  Self.imgUrlPicture.Prop.Picture.WebUrlPicture.SaveToFile('C:\aaaa.png');
//  Self.ImageViewer1.Bitmap.Assign(Self.imgUrlPicture.Prop.Picture.WebUrlPicture);
//  Self.ImageViewer1.Bitmap.LoadFromFile('C:\aaaa.png');
  Self.Image1.Bitmap.LoadFromFile('C:\aaaa.png');
  ImageViewer1.Repaint;
end;

procedure TFrameImage.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblImageHasSomeStretchMode.Text:=GetLangString(lblImageHasSomeStretchMode.Name,ALangKind);
  Self.lblOriginPicture.Text:=GetLangString(lblOriginPicture.Name,ALangKind);
  Self.lblNormalStretch.Text:=GetLangString(lblNormalStretch.Name,ALangKind);
  Self.lblAutoFitAndStretch.Text:=GetLangString(lblAutoFitAndStretch.Name,ALangKind);
  Self.lblSquareStretch.Text:=GetLangString(lblSquareStretch.Name,ALangKind);
  Self.lblHorzThreeDevideStretch.Text:=GetLangString(lblHorzThreeDevideStretch.Name,ALangKind);
  Self.lblVertThreeDevideStretch.Text:=GetLangString(lblVertThreeDevideStretch.Name,ALangKind);
  Self.lblUrlPicture.Text:=GetLangString(lblUrlPicture.Name,ALangKind);
  Self.lblRotateSkinImageList.Text:=GetLangString(lblRotateSkinImageList.Name,ALangKind);
  Self.lblUseOnGetPictureEvent.Text:=GetLangString(lblUseOnGetPictureEvent.Name,ALangKind);

end;

constructor TFrameImage.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblImageHasSomeStretchMode.Name,
    [Self.lblImageHasSomeStretchMode.Text,
    'Image has some stretch mode']);
  RegLangString(Self.lblOriginPicture.Name,
    [Self.lblOriginPicture.Text,
    'Origin picture']);
  RegLangString(Self.lblNormalStretch.Name,
    [Self.lblNormalStretch.Text,
    'Normal stretch mode']);
  RegLangString(Self.lblAutoFitAndStretch.Name,
    [Self.lblAutoFitAndStretch.Text,
    'Autofit and stretch,can keep the ratio']);
  RegLangString(Self.lblSquareStretch.Name,
    [Self.lblSquareStretch.Text,
    'Square stretch mode,can keep border and corner clear']);
  RegLangString(Self.lblHorzThreeDevideStretch.Name,
    [Self.lblHorzThreeDevideStretch.Text,
    'Horz three devide stretch mode']);
  RegLangString(Self.lblVertThreeDevideStretch.Name,
    [Self.lblVertThreeDevideStretch.Text,
    'Vert three devide stretch mode']);
  RegLangString(Self.lblUrlPicture.Name,
    [Self.lblUrlPicture.Text,
    'Display picture from url,and cached to local']);
  RegLangString(Self.lblRotateSkinImageList.Name,
    [Self.lblRotateSkinImageList.Text,
    'Set SkinImageList and Rotated,can timing switch']);
  RegLangString(Self.lblUseOnGetPictureEvent.Name,
    [Self.lblUseOnGetPictureEvent.Text,
    'Get picture from event named OnGetPicture']);



  FPicture:=TSkinPicture.Create;
  FPicture.Assign(Self.SkinImageList1.PictureList[0]);

  Self.imgUseOnGetPictureEvent.Prop.Picture.PictureDrawType:=pdtOnGetPictureEvent;
  Self.imgUseOnGetPictureEvent.Prop.Picture.OnGetPicture:=DoGetPicture;


  imgUrlPicture.Prop.Picture.IsClipRound:=True;



//  SkinFMXImage3.Prop.Picture.IsClipRound:=False;
//  SkinFMXImage3.Prop.Picture.ClipRoundCorners:=[TCorner.BottomLeft, TCorner.BottomRight];
//  SkinFMXImage3.Prop.Picture.IsClipRound:=True;
//  SkinFMXImage3.Prop.Picture.Assign(Self.imgOriginPicture1);

end;

destructor TFrameImage.Destroy;
begin
  FreeAndNil(FPicture);
  inherited;
end;

procedure TFrameImage.DoGetPicture(Sender: TObject;var ASkinPicture: TSkinPicture);
begin
  //返回图片给imgUseOnGetPictureEvent显示
  ASkinPicture:=FPicture;
end;

end.










