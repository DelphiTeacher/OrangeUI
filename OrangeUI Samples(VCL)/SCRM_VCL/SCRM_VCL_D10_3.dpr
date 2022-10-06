program SCRM_VCL_D10_3;



uses
  Forms,
  Windows,
  Controls,
  MainForm in 'MainForm.pas' {frmMain},
  LoginForm in 'LoginForm.pas' {frmLogin},
  ListItemStyle_IconLeft_CaptionRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconLeft_CaptionRight.pas',
  EasyServiceCommonMaterialDataMoudle_VCL in '..\..\OrangeProjectCommon\EasyServiceCommonMaterialDataMoudle_VCL.pas' {dmEasyServiceCommonMaterial: TDataModule},
  ListItemStyle_IconButton in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconButton.pas',
  ListItemStyle_TreeMainMenu_LabelAndArrow in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenu_LabelAndArrow.pas',
  uIdHttpControl in '..\..\OrangeProjectCommon\uIdHttpControl.pas',
  ListItemStyle_CaptionDetailItem in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CaptionDetailItem.pas',
  ListItemStyle_MailList in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_MailList.pas',
  uSkinItemJsonHelper in '..\..\OrangeProjectCommon\uSkinItemJsonHelper.pas',
  uDataSetToJson in '..\..\OrangeProjectCommon\uDataSetToJson.pas',
  uOpenCommon in '..\..\OrangeProjectCommon\uOpenCommon.pas',
  uDataInterface in '..\..\OrangeProjectCommon\uDataInterface.pas',
  uRestInterfaceCall in '..\..\OrangeProjectCommon\uRestInterfaceCall.pas',
  uSelectMediaDialog in '..\..\OrangeProjectCommon\uSelectMediaDialog.pas',
  uFuncCommon_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uFuncCommon_Copy.pas',
  uBaseList_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uBaseList_Copy.pas',
  uFileCommon_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uFileCommon_Copy.pas',
  uBaseLog_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uBaseLog_Copy.pas',
  uSelectMediaUI_OpenDialog in '..\..\OrangeProjectCommon\uSelectMediaUI_OpenDialog.pas',
  ListItemStyle_IconLeft_CaptionRight_CloseBtnRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconLeft_CaptionRight_CloseBtnRight.pas',
  uOpenClientCommon in '..\..\OrangeProjectCommon\uOpenClientCommon.pas',
  uGPSUtils in '..\..\OrangeProjectCommon\uGPSUtils.pas',
  ViewPictureListFrame_VCL in '..\..\OrangeProjectCommon\VCLFrames\ViewPictureListFrame_VCL.pas',
  uViewPictureListFrame in '..\..\OrangeProjectCommon\uViewPictureListFrame.pas',
  ClipHeadFrame_VCL in '..\..\OrangeProjectCommon\VCLFrames\ClipHeadFrame_VCL.pas',
  HintFrame_VCL in '..\..\OrangeProjectCommon\VCLFrames\HintFrame_VCL.pas',
  uPhotoManager in '..\..\OrangeProjectCommon\MultiSelectPhotos\uPhotoManager.pas',
  uPhotoManager.Windows in '..\..\OrangeProjectCommon\MultiSelectPhotos\uPhotoManager.Windows.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
//  Application.CreateForm(TfrmLogin, frmLogin);
  frmLogin:=TfrmLogin.Create(nil);
  if frmLogin.ShowModal=mrOK then
  begin
    Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmEasyServiceCommonMaterial, dmEasyServiceCommonMaterial);
  Application.Run;


  end
  else
  begin
    frmLogin.Hide;
    frmLogin.Free;
  end;
end.
