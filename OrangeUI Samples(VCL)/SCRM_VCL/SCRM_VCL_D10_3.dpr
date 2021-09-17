program SCRM_VCL_D10_3;

uses
  Forms,
  Windows,
  Controls,
  MainForm in 'MainForm.pas' {frmMain},
  LoginForm in 'LoginForm.pas' {frmLogin},
  ListItemStyle_IconLeft_CaptionRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconLeft_CaptionRight.pas',
  EasyServiceCommonMaterialDataMoudle_VCL in '..\..\OrangeProjectCommon\EasyServiceCommonMaterialDataMoudle_VCL.pas' {dmEasyServiceCommonMaterial: TDataModule},
  ListItemStyle_CustomerTag in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CustomerTag.pas',
  ListItemStyle_CustomerInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CustomerInfo.pas',
  ListItemStyle_IconButton in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconButton.pas',
  ListItemStyle_ContactInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_ContactInfo.pas',
  ListItemStyle_CompanyInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CompanyInfo.pas',
  ListItemStyle_TreeMainMenu_LabelAndArrow in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenu_LabelAndArrow.pas',
  uIdHttpControl in '..\..\OrangeProjectCommon\uIdHttpControl.pas',
  ListItemStyle_CaptionDetailItem in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CaptionDetailItem.pas',
  ListItemStyle_MailList in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_MailList.pas',
  ListItemStyle_MailListWithTag in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_MailListWithTag.pas',
  CustomerInfoFrame in '..\..\OrangeProjectCommon\MXSearcher\CustomerInfoFrame.pas',
  TagLabelManageFrame in '..\..\OrangeProjectCommon\MXSearcher\TagLabelManageFrame.pas' {FrameTagLabelManage: TFrame},
  uSkinItemJsonHelper in '..\..\OrangeProjectCommon\uSkinItemJsonHelper.pas',
  uDataSetToJson in '..\..\OrangeProjectCommon\uDataSetToJson.pas';

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
