program HospitalRegisterNumber_VCL_D10_3;

uses
  Vcl.Forms,
  Unit9 in 'Unit9.pas' {Form9},
  ListItemStyle_HospitalDoctorForRegisterNumber in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_HospitalDoctorForRegisterNumber.pas' {FrameListItemStyle_HospitalDoctorForRegisterNumber: TFrame},
  ListItemStyle_ClassifyHasSelectedEffect in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_ClassifyHasSelectedEffect.pas' {FrameListItemStyle_ClassifyHasSelectedEffect: TFrame},
  EasyServiceCommonMaterialDataMoudle_VCL in '..\..\OrangeProjectCommon\EasyServiceCommonMaterialDataMoudle_VCL.pas' {dmEasyServiceCommonMaterial: TDataModule},
  ListItemStyle_TreeMainMenu in 'C:\医生工作站项目程序\服务端\三方控件\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenu.pas',
  ListItemStyle_TreeMainMenuItem in 'C:\医生工作站项目程序\服务端\三方控件\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TreeMainMenuItem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TdmEasyServiceCommonMaterial, dmEasyServiceCommonMaterial);
  Application.Run;
end.
