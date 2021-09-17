//convert pas to utf8 by ¥

unit DownloadPictureManagerFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uLang,
  uFrameContext,
  uUrlPicture,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDownloadPictureManager, uSkinFireMonkeyControl, uSkinFireMonkeyImage,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinMaterial,
  uSkinImageType, uBaseSkinControl;

type
  TFrameDownloadPictureManager = class(TFrame,IFrameChangeLanguageEvent)
    imgTestManualDownloadPicture: TSkinFMXImage;
    DownloadPictureManager1: TDownloadPictureManager;
    edtUrl: TEdit;
    btnDownloadPictureByDownloadPictureManager: TButton;
    imgTestAutoDownloadPicture1: TSkinFMXImage;
    btnSetUrlOfPicture: TButton;
    imgTestAutoDownloadPicture2: TSkinFMXImage;
    imgTestAutoDownloadPicture3: TSkinFMXImage;
    btnSetUrlOfPicture1: TButton;
    imgTestAutoDownloadPicture11: TSkinFMXImage;
    imgTestAutoDownloadPicture12: TSkinFMXImage;
    imgTestAutoDownloadPicture13: TSkinFMXImage;
    lblUrlOfPicture: TLabel;
    lblImageNotSetDownloadPictureManager: TLabel;
    lblImageSettedDownloadPictureManager: TLabel;
    procedure DownloadPictureManager1DownloadSucc(Sender: TObject;
      AUrlPicture: TUrlPicture);
    procedure DownloadPictureManager1DownloadError(Sender: TObject;
      AUrlPicture: TUrlPicture);
    procedure btnDownloadPictureByDownloadPictureManagerClick(Sender: TObject);
    procedure btnSetUrlOfPictureClick(Sender: TObject);
    procedure btnSetUrlOfPicture1Click(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameDownloadPictureManager.btnSetUrlOfPicture1Click(Sender: TObject);
begin
  imgTestAutoDownloadPicture11.Prop.Picture.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/testgif.gif';
  imgTestAutoDownloadPicture12.Prop.Picture.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/testpng.png';
  imgTestAutoDownloadPicture13.Prop.Picture.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/testjpg.jpg';
end;

procedure TFrameDownloadPictureManager.btnSetUrlOfPictureClick(Sender: TObject);
begin
  imgTestAutoDownloadPicture1.Prop.Picture.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/testgif.gif';
  imgTestAutoDownloadPicture2.Prop.Picture.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/testpng.png';
  imgTestAutoDownloadPicture3.Prop.Picture.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/testjpg.jpg';
end;

procedure TFrameDownloadPictureManager.btnDownloadPictureByDownloadPictureManagerClick(Sender: TObject);
begin
  //下载图片
//  Self.DownloadPictureManager1.DownloadPicture('http://www.orangeui.cn/download/testdownloadpicturemanager/testpng.png');
//  Self.DownloadPictureManager1.DownloadPicture('http://www.orangeui.cn/download/testdownloadpicturemanager/testjpg.jpg');
//  Self.DownloadPictureManager1.DownloadPicture('http://www.orangeui.cn/download/testdownloadpicturemanager/testgif.gif');


//  //自动判断链接图片的后缀名.bmp
//  Self.DownloadPictureManager1.DownloadPicture('http://www.orangeui.cn/download/testdownloadpicturemanager/testpng.png');

//  //中文下载测试
//  Self.DownloadPictureManager1.DownloadPicture('http://www.orangeui.cn/download/testdownloadpicturemanager/中文下载测试.jpg');


  //下载文本框中指定的图片
  Self.DownloadPictureManager1.DownloadPicture(Self.edtUrl.Text);
end;

procedure TFrameDownloadPictureManager.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblUrlOfPicture.Text:=GetLangString(Self.lblUrlOfPicture.Name,ALangKind);
  Self.btnDownloadPictureByDownloadPictureManager.Text:=GetLangString(Self.btnDownloadPictureByDownloadPictureManager.Name,ALangKind);

  Self.lblImageNotSetDownloadPictureManager.Text:=GetLangString(Self.lblImageNotSetDownloadPictureManager.Name,ALangKind);
  Self.btnSetUrlOfPicture.Text:=GetLangString(Self.btnSetUrlOfPicture.Name,ALangKind);

  Self.lblImageSettedDownloadPictureManager.Text:=GetLangString(Self.lblImageSettedDownloadPictureManager.Name,ALangKind);
  Self.btnSetUrlOfPicture1.Text:=GetLangString(Self.btnSetUrlOfPicture1.Name,ALangKind);
end;

constructor TFrameDownloadPictureManager.Create(AOwner: TComponent);
begin
  inherited;

//  //图片自动下载所使用的DownloadPictureManager
//  GetGlobalDownloadPictureManager.WaitDownloadPicture.Assign(Self.DownloadPictureManager1.WaitDownloadPicture);
//  GetGlobalDownloadPictureManager.DownloadingPicture.Assign(Self.DownloadPictureManager1.DownloadingPicture);
//  GetGlobalDownloadPictureManager.DownloadFailPicture.Assign(Self.DownloadPictureManager1.DownloadFailPicture);
//  GetGlobalDownloadPictureManager.ImageInvalidPicture.Assign(Self.DownloadPictureManager1.ImageInvalidPicture);



  //初始多语言
  RegLangString(Self.lblUrlOfPicture.Name,
    [Self.lblUrlOfPicture.Text,'Url of picture']);
  RegLangString(Self.btnDownloadPictureByDownloadPictureManager.Name,
    [Self.btnDownloadPictureByDownloadPictureManager.Text,'Download picture by TDownloadPictureManager']);

  RegLangString(Self.lblImageNotSetDownloadPictureManager.Name,
    [Self.lblImageNotSetDownloadPictureManager.Text,'Image that not seted DownloadPictureMnager']);
  RegLangString(Self.btnSetUrlOfPicture.Name,
    [Self.btnSetUrlOfPicture.Text,'Set url of picture']);

  RegLangString(Self.lblImageSettedDownloadPictureManager.Name,
    [Self.lblImageSettedDownloadPictureManager.Text,'Image that seted DownloadPictureMnager']);
  RegLangString(Self.btnSetUrlOfPicture1.Name,
    [Self.btnSetUrlOfPicture1.Text,'Set url of picture']);



end;

procedure TFrameDownloadPictureManager.DownloadPictureManager1DownloadError(
  Sender: TObject; AUrlPicture: TUrlPicture);
begin
  //图片下载失败事件
  case AUrlPicture.state of
    dpsNone: ;
    dpsWaitDownload: ;
    dpsDownloading: ;
    dpsDownloadSucc: ;
    dpsDownloadFail:
    begin
      ShowMessage('图片下载失败');
    end;
    dpsDownloadImageInvalid:
    begin
      ShowMessage('图片格式出错');
    end;
  end;
end;

procedure TFrameDownloadPictureManager.DownloadPictureManager1DownloadSucc(
  Sender: TObject; AUrlPicture: TUrlPicture);
begin
  //图片下载成功事件
  Self.imgTestManualDownloadPicture.Properties.Picture.LoadFromFile(AUrlPicture.GetOriginFilePath);
  Self.imgTestManualDownloadPicture.Invalidate;

end;

end.
