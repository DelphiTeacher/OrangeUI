program MobilePosServer_VCL_XE10;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'FormUnit1.pas' {Form1},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas',
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  uObjectPool in '..\..\..\OrangeProjectCommon\DataBase\uObjectPool.pas',
  uADODBHelper in '..\..\..\OrangeProjectCommon\DataBase\uADODBHelper.pas',
  uADODBHelperPool in '..\..\..\OrangeProjectCommon\DataBase\uADODBHelperPool.pas',
  uBaseDBHelper in '..\..\..\OrangeProjectCommon\DataBase\uBaseDBHelper.pas',
  uConfig in 'uConfig.pas',
  DataBaseConfigForm in '..\..\..\OrangeProjectCommon\ServerCommon\Config\DataBaseConfigForm.pas' {frmDataBaseConfig},
  uDataBaseConfig in '..\..\..\OrangeProjectCommon\ServerCommon\Config\uDataBaseConfig.pas',
  uBaseHttpControl in '..\..\..\OrangeProjectCommon\OrangeUI\uBaseHttpControl.pas',
  uBaseList in '..\..\..\OrangeProjectCommon\OrangeUI\uBaseList.pas',
  uBaseLog in '..\..\..\OrangeProjectCommon\OrangeUI\uBaseLog.pas',
  uFileCommon in '..\..\..\OrangeProjectCommon\OrangeUI\uFileCommon.pas',
  uFuncCommon in '..\..\..\OrangeProjectCommon\OrangeUI\uFuncCommon.pas',
  uLang in '..\..\..\OrangeProjectCommon\OrangeUI\uLang.pas',
  uTimerTask in '..\..\..\OrangeProjectCommon\OrangeUI\uTimerTask.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
