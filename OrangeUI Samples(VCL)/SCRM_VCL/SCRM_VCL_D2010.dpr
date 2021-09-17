program SCRM_VCL_D2010;

uses
  Forms,
  Windows,
  Controls,
  MainForm in 'MainForm.pas' {frmMain},
  LoginForm in 'LoginForm.pas' {frmLogin},
  ListItemStyle_IconLeft_CaptionRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconLeft_CaptionRight.pas',
  ListItemStyle_MailList2 in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_MailList2.pas' {FrameListItemStyle_MailList2},
  ListItemStyle_MailListWithTag in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_MailListWithTag.pas',
  ListItemStyle_MailList in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_MailList.pas',
  ListItemStyle_CompanyInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CompanyInfo.pas',
  ListItemStyle_ContactInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_ContactInfo.pas',
  ListItemStyle_CustomerInfo in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CustomerInfo.pas',
  ListItemStyle_CustomerTag in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CustomerTag.pas',
  ListItemStyle_CaptionDetailItem in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_CaptionDetailItem.pas',
  ListItemStyle_TreeMainMenu_LabelAndArrow in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenu_LabelAndArrow.pas',
  ListItemStyle_IconButton in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconButton.pas',
  EasyServiceCommonMaterialDataMoudle_VCL in '..\..\OrangeProjectCommon\EasyServiceCommonMaterialDataMoudle_VCL.pas' {dmEasyServiceCommonMaterial: TDataModule},
  uIdHttpControl in '..\..\OrangeProjectCommon\uIdHttpControl.pas',
  CustomerInfoFrame in '..\..\OrangeProjectCommon\MXSearcher\CustomerInfoFrame.pas',
  TagLabelManageFrame in '..\..\OrangeProjectCommon\MXSearcher\TagLabelManageFrame.pas',
  HostForm in '..\..\OrangeProjectCommon\MXSearcher\HostForm.pas',
  superobject in '..\..\OrangeProjectCommon\SuperObject\superobject.pas',
  superobjecthelper in '..\..\OrangeProjectCommon\SuperObject\superobjecthelper.pas',
  uListItemStyleJsonHelper in '..\..\OrangeProjectCommon\uListItemStyleJsonHelper.pas',
  uSkinItemJsonHelper in '..\..\OrangeProjectCommon\uSkinItemJsonHelper.pas';

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
