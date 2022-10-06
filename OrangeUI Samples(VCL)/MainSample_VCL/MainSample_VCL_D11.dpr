program MainSample_VCL_D11;





uses
  Forms,
  Windows,
  Controls,
  MainForm in 'MainForm.pas' {frmMain},
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
  ButtonFrame in 'ButtonFrame.pas' {FrameButton: TFrame},
  EditFrame in 'EditFrame.pas' {FrameEdit: TFrame},
  MemoFrame in 'MemoFrame.pas' {FrameMemo: TFrame},
  XSuperJSON in '..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  uMultiSelectFrame in '..\..\OrangeProjectCommon\uMultiSelectFrame.pas',
  MultiSelectFrame_VCL in '..\..\OrangeProjectCommon\VCLFrames\MultiSelectFrame_VCL.pas',
  MessageBoxFrame_VCL in '..\..\OrangeProjectCommon\VCLFrames\MessageBoxFrame_VCL.pas',
  uVirtualListDataController in '..\..\OrangeProjectCommon\uVirtualListDataController.pas',
  CheckBoxFrame in 'CheckBoxFrame.pas' {FrameCheckBox: TFrame},
  HintFrame_VCL in '..\..\OrangeProjectCommon\VCLFrames\HintFrame_VCL.pas',
  uPhotoManager in '..\..\OrangeProjectCommon\MultiSelectPhotos\uPhotoManager.pas',
  uPhotoManager.Windows in '..\..\OrangeProjectCommon\MultiSelectPhotos\uPhotoManager.Windows.pas',
  FrameParentForm_VCL in '..\..\OrangeProjectCommon\VCLFrames\FrameParentForm_VCL.pas',
  ListItemStyle_Default in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_Default.pas',
  ListItemStyle_IconCaptionLeft_NotifyNumberRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconCaptionLeft_NotifyNumberRight.pas' {FrameListItemStyle_IconCaptionLeft_NotifyNumberRight: TFrame},
  ListItemStyle_IconCaptionLeft_NotifyIconRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconCaptionLeft_NotifyIconRight.pas' {FrameListItemStyle_IconCaptionLeft_NotifyIconRight: TFrame},
  ListItemStyle_IconCaptionLeft_DetailRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconCaptionLeft_DetailRight.pas' {FrameListItemStyle_IconCaptionLeft_DetailRight: TFrame},
  ListItemStyle_IconCaptionLeft_ArrowRight in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconCaptionLeft_ArrowRight.pas' {FrameListItemStyle_IconCaptionLeft_ArrowRight: TFrame},
  PageControlFrame in 'PageControlFrame.pas' {FramePageControl: TFrame},
  ListBoxFrame in 'ListBoxFrame.pas' {Frame2: TFrame},
  ListViewFrame in 'ListViewFrame.pas' {Frame4: TFrame},
  DashBoard_AnalyseFrame in 'DashBoard_AnalyseFrame.pas' {FrameDashBoard_Analyse: TFrame},
  ListItemStyle_DashBoardSummaryItem in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_DashBoardSummaryItem.pas',
  DashBoard_Analyse_ItemGrid_MutliColorProgressBarColumnFrame in 'DashBoard_Analyse_ItemGrid_MutliColorProgressBarColumnFrame.pas' {FrameItemGrid_MultiColorProgressBarColumn: TFrame},
  DashBoard_Analyse_ItemGrid_TwoCellTextFrame in 'DashBoard_Analyse_ItemGrid_TwoCellTextFrame.pas' {FrameItemGrid_TwoCellText: TFrame},
  ListItemStyle_ProgressBar in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_ProgressBar.pas',
  ListItemStyle_IconTop_CaptionDetailBottom in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_IconTop_CaptionDetailBottom.pas',
  DashBoard_ProjectsFrame in 'DashBoard_ProjectsFrame.pas' {FrameDashBoard_Projects},
  TestChartFrame in 'TestChartFrame.pas' {FrameTestChart},
  Unit5 in 'Unit5.pas' {Form5},
  DashBoard_Analyse_BarChart_MonthSummaryFrame in 'DashBoard_Analyse_BarChart_MonthSummaryFrame.pas',
  DashBoard_Projects_PieChart_ProjectStatusFrame in 'DashBoard_Projects_PieChart_ProjectStatusFrame.pas' {FramePieChart_ProjectStatus},
  DashBoard_Projects_ItemGrid_TwoCellTextHasBackColorFrame in 'DashBoard_Projects_ItemGrid_TwoCellTextHasBackColorFrame.pas' {FrameItemGrid_TwoCellTextHasBackColor},
  ListItemStyle_TwoIconButton in '..\..\OrangeProjectCommon\OrangeUIStyles_VCL\ListItemStyle_TwoIconButton.pas';

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;


  Application.Initialize;
  Application.MainFormOnTaskbar := True;
//  Application.CreateForm(TfrmLogin, frmLogin);
//  frmLogin:=TfrmLogin.Create(nil);
//  if frmLogin.ShowModal=mrOK then
//  begin
  Application.CreateForm(TdmEasyServiceCommonMaterial, dmEasyServiceCommonMaterial);
    Application.CreateForm(TfrmMain, frmMain);
//    Application.CreateForm(TForm5, Form5);
  Application.Run;


//  end
//  else
//  begin
//    frmLogin.Hide;
//    frmLogin.Free;
//  end;
end.
