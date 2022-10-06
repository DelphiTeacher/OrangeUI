program VirtualKeyboardProcessInFrame2_FMX_D10_3;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  uUIFunction in '..\..\..\OrangeProjectCommon\uUIFunction.pas',
  LoginFrame in 'LoginFrame.pas' {FrameLogin: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
