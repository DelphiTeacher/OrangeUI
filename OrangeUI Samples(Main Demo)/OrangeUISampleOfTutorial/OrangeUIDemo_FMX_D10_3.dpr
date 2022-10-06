program OrangeUIDemo_FMX_D10_3;



























uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  HzSpell in '..\..\OrangeProjectCommon\HzSpell\HzSpell.pas',
  AnimatorFrame in 'AnimatorFrame.pas' {FrameAnimator: TFrame},
  ButtonFrame in 'ButtonFrame.pas' {FrameButton: TFrame},
  ButtonGroupFrame in 'ButtonGroupFrame.pas' {FrameButtonGroup: TFrame},
  CheckBoxFrame in 'CheckBoxFrame.pas' {FrameCheckBox: TFrame},
  ComboBoxFrame in 'ComboBoxFrame.pas' {FrameComboBox: TFrame},
  ComboEditFrame in 'ComboEditFrame.pas' {FrameComboEdit: TFrame},
  ControlGestureManagerFrame in 'ControlGestureManagerFrame.pas' {FrameControlGestureManager: TFrame},
  DateEditFrame in 'DateEditFrame.pas' {FrameDateEdit: TFrame},
  DemoViewFrame in 'DemoViewFrame.pas' {FrameDemoView: TFrame},
  DownloadPictureManagerFrame in 'DownloadPictureManagerFrame.pas' {FrameDownloadPictureManager: TFrame},
  DrawPanelFrame in 'DrawPanelFrame.pas' {FrameDrawPanel: TFrame},
  EditFrame in 'EditFrame.pas' {FrameEdit: TFrame},
  FrameImageFrame in 'FrameImageFrame.pas' {FrameFrameImage: TFrame},
  HideVKboardFrame in 'HideVKboardFrame.pas' {FrameHideVKboard: TFrame},
  ImageFrame in 'ImageFrame.pas' {FrameImage: TFrame},
  ImageListFrame in 'ImageListFrame.pas' {FrameImageList: TFrame},
  ImageListPalyerFrame in 'ImageListPalyerFrame.pas' {FrameImageListPlayer: TFrame},
  ImageListViewerFrame in 'ImageListViewerFrame.pas' {FrameImageListViewer: TFrame},
  LabelFrame in 'LabelFrame.pas' {FrameLabel: TFrame},
  ListBoxFrame_AutoPullDownRefresh in 'ListBoxFrame_AutoPullDownRefresh.pas' {FrameListBox_AutoPullDownRefresh: TFrame},
  ListBoxFrame_BindingMultiPic2 in 'ListBoxFrame_BindingMultiPic2.pas' {FrameListBox_BindingMultiPic2: TFrame},
  ListBoxFrame_FilterItems in 'ListBoxFrame_FilterItems.pas' {FrameListBox_FilterItems: TFrame},
  ListBoxFrame_ItemOperCode in 'ListBoxFrame_ItemOperCode.pas' {FrameListBox_ItemOperCode: TFrame},
  ListBoxFrame_Main in 'ListBoxFrame_Main.pas' {FrameListBox_Main: TFrame},
  ListBoxFrame_MouseEventTest in 'ListBoxFrame_MouseEventTest.pas' {FrameListBox_MouseEventTest: TFrame},
  ListBoxFrame_SortItems in 'ListBoxFrame_SortItems.pas' {FrameListBox_SortItems: TFrame},
  ListBoxFrame_SpeedCompare in 'ListBoxFrame_SpeedCompare.pas' {FrameListBox_SpeedCompare: TFrame},
  ListBoxFrame_UseAutoDownloadIcon in 'ListBoxFrame_UseAutoDownloadIcon.pas' {FrameListBox_UseAutoDownloadIcon: TFrame},
  ListBoxFrame_UseCenterSelect in 'ListBoxFrame_UseCenterSelect.pas' {FrameListBox_UseCenterSelect: TFrame},
  ListBoxFrame_UseDynamicBinding in 'ListBoxFrame_UseDynamicBinding.pas' {FrameListBox_UseDynamicBinding: TFrame},
  ListBoxFrame_UseHorzListBox in 'ListBoxFrame_UseHorzListBox.pas' {FrameListBox_UseHorzListBox: TFrame},
  ListBoxFrame_UseItemComboBox in 'ListBoxFrame_UseItemComboBox.pas' {FrameListBox_UseItemComboBox: TFrame},
  ListBoxFrame_UseItemDesignerPanel in 'ListBoxFrame_UseItemDesignerPanel.pas' {FrameListBox_UseItemDesignerPanel: TFrame},
  ListBoxFrame_UseItemEdit in 'ListBoxFrame_UseItemEdit.pas' {FrameListBox_UseItemEdit: TFrame},
  ListBoxFrame_UseItemPanDrag in 'ListBoxFrame_UseItemPanDrag.pas' {FrameListBox_UseItemPanDrag: TFrame},
  ListBoxFrame_UseMultiDesignerPanel in 'ListBoxFrame_UseMultiDesignerPanel.pas' {FrameListBox_UseMultiDesignerPanel: TFrame},
  ListBoxFrame_UseSelfOwnMaterial in 'ListBoxFrame_UseSelfOwnMaterial.pas' {FrameListBox_UseSelfOwnMaterial: TFrame},
  ListViewFrame_AutoColCountFit in 'ListViewFrame_AutoColCountFit.pas' {FrameListView_AutoColCountFit: TFrame},
  ListViewFrame_AutoColCountNotFit in 'ListViewFrame_AutoColCountNotFit.pas' {FrameListView_AutoColCountNotFit: TFrame},
  ListViewFrame_FixColCountFit in 'ListViewFrame_FixColCountFit.pas' {FrameListView_FixColCountFit: TFrame},
  ListViewFrame_FixColCountNotFit in 'ListViewFrame_FixColCountNotFit.pas' {FrameListView_FixColCountNotFit: TFrame},
  ListViewFrame_HorzAutoColCountFit in 'ListViewFrame_HorzAutoColCountFit.pas' {FrameListView_HorzAutoColCountFit: TFrame},
  ListViewFrame_HorzAutoColCountNotFit in 'ListViewFrame_HorzAutoColCountNotFit.pas' {FrameListView_HorzAutoColCountNotFit: TFrame},
  ListViewFrame_HorzFixColCountFit in 'ListViewFrame_HorzFixColCountFit.pas' {FrameListView_HorzFixColCountFit: TFrame},
  ListViewFrame_HorzFixColCountNotFit in 'ListViewFrame_HorzFixColCountNotFit.pas' {FrameListView_HorzFixColCountNotFit: TFrame},
  ListViewFrame_HuaBanWaterfall in 'ListViewFrame_HuaBanWaterfall.pas' {FrameListView_HuaBanWaterfall: TFrame},
  ListViewFrame_Main in 'ListViewFrame_Main.pas' {FrameListView_Main: TFrame},
  ListViewFrame_TestComplexLayout in 'ListViewFrame_TestComplexLayout.pas' {FrameListView_TestComplexLayout: TFrame},
  ListViewFrame_TestListView in 'ListViewFrame_TestListView.pas' {FrameListView_TestListView: TFrame},
  ListViewFrame_TestWaterfall in 'ListViewFrame_TestWaterfall.pas' {FrameListView_TestWaterfall: TFrame},
  ListViewFrame_UseHorzListView in 'ListViewFrame_UseHorzListView.pas' {FrameListView_UseHorzListView: TFrame},
  ListViewFrame_UseSelfOwnMaterial in 'ListViewFrame_UseSelfOwnMaterial.pas' {FrameListView_UseSelfOwnMaterial: TFrame},
  ListViewFrame_UseSelfOwnMaterial_9BoxMenu in 'ListViewFrame_UseSelfOwnMaterial_9BoxMenu.pas' {FrameListView_UseSelfOwnMaterial_9BoxMenu: TFrame},
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  MaterialFrame in 'MaterialFrame.pas' {FrameMaterial: TFrame},
  MemoFrame in 'MemoFrame.pas' {FrameMemo: TFrame},
  MultiColorLabelFrame in 'MultiColorLabelFrame.pas' {FrameMultiColorLabel: TFrame},
  NotifyNumberIconFrame in 'NotifyNumberIconFrame.pas' {FrameNotifyNumberIcon: TFrame},
  PageControlFrame in 'PageControlFrame.pas' {FramePageControl: TFrame},
  PanelFrame in 'PanelFrame.pas' {FramePanel: TFrame},
  ProgressBarFrame in 'ProgressBarFrame.pas' {FrameProgressBar: TFrame},
  PullLoadPanelFrame in 'PullLoadPanelFrame.pas' {FramePullLoadPanel: TFrame},
  RoundImageFrame in 'RoundImageFrame.pas' {FrameRoundImage: TFrame},
  ScrollBarFrame in 'ScrollBarFrame.pas' {FrameScrollBar: TFrame},
  ScrollBoxFrame in 'ScrollBoxFrame.pas' {FrameScrollBox: TFrame},
  ScrollControlFrame in 'ScrollControlFrame.pas' {FrameScrollControl: TFrame},
  SetBackColorFrame in 'SetBackColorFrame.pas' {FrameSetBackColor: TFrame},
  SwitchFrame in 'SwitchFrame.pas' {FrameSwitch: TFrame},
  TrackBarFrame in 'TrackBarFrame.pas' {FrameTrackBar: TFrame},
  TreeViewFrame_Common in 'TreeViewFrame_Common.pas' {FrameTreeView_Common: TFrame},
  TreeViewFrame_Main in 'TreeViewFrame_Main.pas' {FrameTreeView_Main: TFrame},
  FlyFmxUtils in '..\..\OrangeProjectCommon\FlyFilesUtils\FlyFmxUtils.pas',
  RadioButtonFrame in 'RadioButtonFrame.pas' {FrameRadioButton: TFrame},
  ItemGridFrame in 'ItemGridFrame.pas' {FrameItemGrid: TFrame},
  ItemGridFrame_Simple in 'ItemGridFrame_Simple.pas',
  ItemGridFrame_Main in 'ItemGridFrame_Main.pas' {FrameItemGrid_Main},
  ItemGridFrame_IndicatorCol in 'ItemGridFrame_IndicatorCol.pas' {FrameItemGrid_IndicatorCol},
  ItemGridFrame_FixedCol in 'ItemGridFrame_FixedCol.pas',
  ItemGridFrame_Footer in 'ItemGridFrame_Footer.pas',
  ItemGridFrame_UseItemDesignerPanel in 'ItemGridFrame_UseItemDesignerPanel.pas',
  TestFreeVersionFrame in 'TestFreeVersionFrame.pas',
  RollLabelFrame in 'RollLabelFrame.pas',
  uVirtualListDataController in '..\..\OrangeProjectCommon\uVirtualListDataController.pas',
  ItemGridFrame_WhiteBackColor in 'ItemGridFrame_WhiteBackColor.pas',
  ItemGridFrame_CustomRowColor in 'ItemGridFrame_CustomRowColor.pas' {FrameItemGrid_CustomRowColor},
  ItemGridFrame_DiffOddAndEvenRowColor in 'ItemGridFrame_DiffOddAndEvenRowColor.pas' {FrameItemGrid_DiffOddAndEvenRowColor},
  ItemGridFrame_GridDevideLine in 'ItemGridFrame_GridDevideLine.pas' {FrameItemGrid_GridDevideLine},
  ListViewFrame_ItemDesignTimeColor in 'ListViewFrame_ItemDesignTimeColor.pas',
  ListViewFrame_UseItemDesignerPanel in 'ListViewFrame_UseItemDesignerPanel.pas',
  uOpenCommon in '..\..\OrangeProjectCommon\uOpenCommon.pas',
  uModule_InterfaceSign in '..\..\OrangeProjectCommon\uModule_InterfaceSign.pas',
  EasyServiceCommonMaterialDataMoudle in '..\..\OrangeProjectCommon\EasyServiceCommonMaterialDataMoudle.pas' {dmEasyServiceCommonMaterial: TDataModule},
  uBaseList_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uBaseList_Copy.pas',
  uBaseLog_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uBaseLog_Copy.pas',
  uFuncCommon_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uFuncCommon_Copy.pas',
  uFileCommon_Copy in '..\..\OrangeProjectCommon\OrangeUI_Copy\uFileCommon_Copy.pas',
  ListItemStyleFrame_IconCaption in '..\..\OrangeUIStyles\ListItemStyleFrame_IconCaption.pas',
  BaseListItemStyleFrame in '..\..\OrangeUIStyles\BaseListItemStyleFrame.pas',
  ListItemStyleFrame_IconTopCenter_CaptionBottomCenterBlack in '..\..\OrangeUIStyles\ListItemStyleFrame_IconTopCenter_CaptionBottomCenterBlack.pas',
  ListItemStyleFrame_Base in '..\..\OrangeUIStyles\ListItemStyleFrame_Base.pas';

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmEasyServiceCommonMaterial, dmEasyServiceCommonMaterial);
  Application.Run;
end.
