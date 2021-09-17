program Baidu_POISearch_D10_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
