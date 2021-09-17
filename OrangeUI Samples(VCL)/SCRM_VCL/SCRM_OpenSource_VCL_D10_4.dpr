program SCRM_OpenSource_VCL_D10_4;





uses
  Forms,
  Windows,
  Controls,
  MainForm in 'MainForm.pas' {frmMain},
  LoginForm in 'LoginForm.pas' {frmLogin},
  ListItemStyle_IconLeft_CaptionRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconLeft_CaptionRight.pas',
  ListItemStyle_MailList in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_MailList.pas',
  ListItemStyle_CaptionDetailItem in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CaptionDetailItem.pas',
  ListItemStyle_ClassifyHasSelectedEffect in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_ClassifyHasSelectedEffect.pas',
  ListItemStyle_CompanyInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CompanyInfo.pas',
  ListItemStyle_ContactInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_ContactInfo.pas',
  ListItemStyle_HistoryMadical in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_HistoryMadical.pas',
  ListItemStyle_HospitalDoctorForRegisterNumber in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_HospitalDoctorForRegisterNumber.pas',
  ListItemStyle_IconButton in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconButton.pas',
  ListItemStyle_IconTop_CaptionBottom in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconTop_CaptionBottom.pas',
  ListItemStyle_TreeChildListBox in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeChildListBox.pas',
  ListItemStyle_TreeHistoryMadicalList_Child in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeHistoryMadicalList_Child.pas',
  ListItemStyle_TreeHistoryMadicalList_Diag in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeHistoryMadicalList_Diag.pas',
  ListItemStyle_TreeHistoryMadicalList_Item in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeHistoryMadicalList_Item.pas',
  ListItemStyle_TreeMainMenu in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenu.pas',
  ListItemStyle_TreeMainMenu_LabelAndArrow in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenu_LabelAndArrow.pas',
  ListItemStyle_TreeMainMenuItem in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenuItem.pas',
  ListItemStyle_VertSelectedSignLeft_CaptionRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_VertSelectedSignLeft_CaptionRight.pas',
  uSkinItemJsonHelper in '..\..\OrangeProjectCommon\uSkinItemJsonHelper.pas',
  uDataSetToJson in '..\..\OrangeProjectCommon\uDataSetToJson.pas',
  uIdHttpControl in '..\..\OrangeProjectCommon\uIdHttpControl.pas',
  HostForm in '..\..\OrangeProjectCommon\MXSearcher\HostForm.pas';

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
