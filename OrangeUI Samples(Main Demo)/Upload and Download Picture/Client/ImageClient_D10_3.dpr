program ImageClient_D10_3;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit4 in 'Unit4.pas' {Form4},
  TakePictureMenuFrame in '..\..\..\OrangeProjectCommon\CommonFrames\TakePictureMenuFrame.pas' {FrameTakePictureMenu: TFrame},
  uUIFunction in '..\..\..\OrangeProjectCommon\uUIFunction.pas',
  uIdHttpControl in '..\..\..\OrangeProjectCommon\uIdHttpControl.pas',
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  uThumbCommon in '..\..\..\OrangeProjectCommon\uThumbCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
