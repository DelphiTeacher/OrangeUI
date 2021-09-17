program FriendCircleServer_D10_3;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'FormUnit1.pas' {Form1},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  uGenerateThumb in '..\..\..\OrangeProjectCommon\ImageHttpServerModule\uGenerateThumb.pas',
  ImageIndyHttpServerModule in '..\..\..\OrangeProjectCommon\ImageHttpServerModule\ImageIndyHttpServerModule.pas' {dmImageIndyHttpServer: TDataModule},
  uDataBaseConfig in '..\..\..\OrangeProjectCommon\ServerCommon\Config\uDataBaseConfig.pas',
  DataBaseConfigForm in '..\..\..\OrangeProjectCommon\ServerCommon\Config\DataBaseConfigForm.pas',
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TdmImageIndyHttpServer, dmImageIndyHttpServer);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
