program ImageClient_D10_4;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit4 in 'Unit4.pas' {Form4},
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  uUrlPicture in '..\..\..\OrangeUIControl\Source\Base\uUrlPicture.pas',
  uDownloadPictureManager in '..\..\..\OrangeUIControl\Source\Base\uDownloadPictureManager.pas',
  uDrawPicture in '..\..\..\OrangeUIControl\Source\Base\uDrawPicture.pas',
  uAndroidNativePictuerDownloadManager in '..\..\..\OrangeProjectCommon\NativePictuerDownloadManager\uAndroidNativePictuerDownloadManager.pas',
  uFireMonkeyDrawCanvas in '..\..\..\OrangeUIControl\Source\Engines\FMX\uFireMonkeyDrawCanvas.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
