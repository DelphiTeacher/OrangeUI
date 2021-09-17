program DataSnapClientTest_XE10;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit2 in 'Unit2.pas' {Form2},
  ClientClassesUnit2 in 'ClientClassesUnit2.pas',
  ClientModuleUnit2 in 'ClientModuleUnit2.pas' {ClientModule2: TDataModule},
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TClientModule2, ClientModule2);
  Application.Run;
end.
