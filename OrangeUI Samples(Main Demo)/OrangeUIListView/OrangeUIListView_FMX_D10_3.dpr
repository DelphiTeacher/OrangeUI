program OrangeUIListView_FMX_D10_3;













uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  Box9Menu_CZNYT_MainFrame in 'Box9Menu_CZNYT_MainFrame.pas' {FrameBox9Menu_CZNYT_Main: TFrame},
  Box9Menu_ZiMaYou_MineFrame in 'Box9Menu_ZiMaYou_MineFrame.pas' {FrameBox9Menu_ZiMaYou_Mine: TFrame},
  ListViewDemoViewFrame in 'ListViewDemoViewFrame.pas' {FrameListViewDemoView: TFrame},
  Box9Menu_XunKe_HomeFrame in 'Box9Menu_XunKe_HomeFrame.pas' {FrameBox9Menu_XunKe_Home: TFrame},
  Basic_DesignerPanel_MessageFrame in 'Basic_DesignerPanel_MessageFrame.pas' {FrameBasic_DesignerPanel_Message: TFrame},
  Bind_MultiColorLabel_ProductListFrame in 'Bind_MultiColorLabel_ProductListFrame.pas' {FrameBind_MultiColorLabel_ProductList: TFrame},
  Basic_PanDrag_ShoppingCartFrame in 'Basic_PanDrag_ShoppingCartFrame.pas' {FrameBasic_PanDrag_ShoppingCart: TFrame},
  Basic_DesignTimePreview_ListBoxFrame in 'Basic_DesignTimePreview_ListBoxFrame.pas' {FrameBasic_DesignTimePreview_ListBox: TFrame},
  ViewMode_CenterSelect_SelectCityFrame in 'ViewMode_CenterSelect_SelectCityFrame.pas' {FrameViewMode_CenterSelect_SelectCity: TFrame},
  ViewMode_Switch_SearchResultFrame in 'ViewMode_Switch_SearchResultFrame.pas' {FrameViewMode_Switch_SearchResult: TFrame},
  Bind_RoundImage_MessageFrame in 'Bind_RoundImage_MessageFrame.pas' {FrameBind_RoundImage_Message: TFrame},
  ViewMode_Horz_BusLineFrame in 'ViewMode_Horz_BusLineFrame.pas' {FrameViewMode_Horz_BusLine: TFrame},
  Basic_MultiDesignerPanel_ListBoxFarme in 'Basic_MultiDesignerPanel_ListBoxFarme.pas' {FrameBasic_MultiDesignerPanel_ListBox: TFrame},
  Basic_Filter_ListBoxFrame in 'Basic_Filter_ListBoxFrame.pas' {FrameBasic_Filter_ListBox: TFrame},
  HzSpell in '..\..\OrangeProjectCommon\HzSpell\HzSpell.pas',
  Bind_ImageListViewer_HomeFrame in 'Bind_ImageListViewer_HomeFrame.pas' {FrameBind_ImageListViewer_Home: TFrame},
  ViewMode_Complex_ListViewFarme in 'ViewMode_Complex_ListViewFarme.pas' {FrameViewMode_Complex_ListView: TFrame},
  TreeView_Nomal_ContactorFrame in 'TreeView_Nomal_ContactorFrame.pas' {FrameTreeView_Nomal_Contactor: TFrame},
  TreeView_Complex_AssistantFrame in 'TreeView_Complex_AssistantFrame.pas' {FrameTreeView_Complex_Assistant: TFrame},
  FMX.DeviceInfo in '..\..\OrangeProjectCommon\FMX.DeviceInfo.pas',
  uAPPCommon in '..\..\OrangeProjectCommon\uAPPCommon.pas',
  uVirtualListDataController in '..\..\OrangeProjectCommon\uVirtualListDataController.pas',
  uOpenCommon in '..\..\OrangeProjectCommon\uOpenCommon.pas',
  uModule_InterfaceSign in '..\..\OrangeProjectCommon\uModule_InterfaceSign.pas';

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
