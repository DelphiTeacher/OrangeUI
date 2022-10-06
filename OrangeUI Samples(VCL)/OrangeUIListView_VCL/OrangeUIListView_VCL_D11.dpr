program OrangeUIListView_VCL_D11;

uses
  Vcl.Forms,
  HomeForm in 'HomeForm.pas' {frmHome},
  ListItemStyle_IconTop_CaptionBottom in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconTop_CaptionBottom.pas' {FrameListItemStyle_IconTop_CaptionBottom: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmHome, frmHome);
  Application.Run;
end.
