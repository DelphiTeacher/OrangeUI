program OrangeVirtualKeyboardProcessInForm;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  uUIFunction in '..\..\..\OrangeProjectCommon\uUIFunction.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
