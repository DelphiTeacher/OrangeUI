program FriendCircleServer_XE10;
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
  uDataSetToJson in '..\..\..\OrangeProjectCommon\ServerCommon\uDataSetToJson.pas',
  uBaseDBHelper in '..\..\..\OrangeProjectCommon\DataBase\uBaseDBHelper.pas',
  uObjectPool in '..\..\..\OrangeProjectCommon\DataBase\uObjectPool.pas',
  uADODBHelper in '..\..\..\OrangeProjectCommon\DataBase\uADODBHelper.pas',
  uADODBHelperPool in '..\..\..\OrangeProjectCommon\DataBase\uADODBHelperPool.pas',
  uDataBaseConfig in '..\..\..\OrangeProjectCommon\ServerCommon\Config\uDataBaseConfig.pas',
  uThumbCommon in '..\..\..\OrangeProjectCommon\uThumbCommon.pas',
  uTaoBaoPublic in '..\..\..\OrangeProjectCommon\阿里大于\Client\uTaoBaoPublic.pas',
  uTaoBaoAuth_TopProtocal in '..\..\..\OrangeProjectCommon\阿里大于\Client\uTaoBaoAuth_TopProtocal.pas',
  uTaoBaoAuth in '..\..\..\OrangeProjectCommon\阿里大于\Client\uTaoBaoAuth.pas',
  uTaoBaoAPIParam in '..\..\..\OrangeProjectCommon\阿里大于\Client\uTaoBaoAPIParam.pas',
  uTaoBaoAPI in '..\..\..\OrangeProjectCommon\阿里大于\Client\uTaoBaoAPI.pas',
  uIdHttpControl in '..\..\..\OrangeProjectCommon\阿里大于\Client\uIdHttpControl.pas',
  uWorkThreadPool in '..\..\..\OrangeProjectCommon\阿里大于\Thread\uWorkThreadPool.pas',
  uWorkThreadList in '..\..\..\OrangeProjectCommon\阿里大于\Thread\uWorkThreadList.pas',
  uTaoBaoManager in '..\..\..\OrangeProjectCommon\阿里大于\uTaoBaoManager.pas',
  DataBaseConfigForm in '..\..\..\OrangeProjectCommon\ServerCommon\Config\DataBaseConfigForm.pas',
  uCommonUtils in '..\..\..\OrangeProjectCommon\uCommonUtils.pas',
  uCaptcha in '..\..\..\OrangeProjectCommon\阿里大于\uCaptcha.pas',
  uBaseLog in '..\..\..\OrangeProjectCommon\OrangeUI\uBaseLog.pas',
  uFuncCommon in '..\..\..\OrangeProjectCommon\OrangeUI\uFuncCommon.pas',
  uFileCommon in '..\..\..\OrangeProjectCommon\OrangeUI\uFileCommon.pas',
  uBaseList in '..\..\..\OrangeProjectCommon\OrangeUI\uBaseList.pas',
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
