program OrangeVideoPlayer_VCL_D10_4;

uses
  Vcl.Forms,
  QQPlayerWinForm in 'QQPlayerWinForm.pas' {frmQQPlayerWin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmQQPlayerWin, frmQQPlayerWin);
  frmQQPlayerWin.Show;
  Application.Run;
end.
