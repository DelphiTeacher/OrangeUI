program SCRM;

uses
  Forms,
  Windows,
  Controls,
  MainForm in 'MainForm.pas' {frmMain},
  LoginForm in 'LoginForm.pas' {frmLogin},
  ListItemStyle_IconLeft_CaptionRight in '..\..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconLeft_CaptionRight.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
//  Application.CreateForm(TfrmLogin, frmLogin);
  frmLogin:=TfrmLogin.Create(nil);
  if frmLogin.ShowModal=mrOK then
  begin
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;


  end
  else
  begin
    frmLogin.Hide;
    frmLogin.Free;
  end;
end.
