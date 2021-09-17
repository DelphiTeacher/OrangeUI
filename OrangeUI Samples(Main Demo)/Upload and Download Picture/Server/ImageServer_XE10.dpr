program ImageServer_XE10;

uses
  Vcl.Forms,
  Unit5 in 'Unit5.pas' {Form5},
  ImageIndyHttpServerModule in '..\..\..\OrangeProjectCommon\ImageHttpServerModule\ImageIndyHttpServerModule.pas' {dmImageIndyHttpServer: TDataModule},
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  uDataSetToJson in '..\..\..\OrangeProjectCommon\ServerCommon\uDataSetToJson.pas',
  uGenerateThumb in '..\..\..\OrangeProjectCommon\ImageHttpServerModule\uGenerateThumb.pas',
  uThumbCommon in '..\..\..\OrangeProjectCommon\uThumbCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TdmImageIndyHttpServer, dmImageIndyHttpServer);
  Application.Run;
end.
