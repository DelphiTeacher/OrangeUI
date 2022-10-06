program HospitalTerminal_VCL_D11;

uses
  Vcl.Forms,
  Unit12 in 'Unit12.pas' {Form12},
  ListItemStyle_IconTop_CaptionBottom in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconTop_CaptionBottom.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
