program MobilePos_FMX_XE10;



uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  uUIFunction in '..\..\..\OrangeProjectCommon\uUIFunction.pas',
  uNativeHttpControl in '..\..\..\OrangeProjectCommon\uNativeHttpControl.pas',
  uMobileUtils in '..\..\..\OrangeProjectCommon\uMobileUtils.pas',
  FMX.Platform.iOS in '..\..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  SettingFrame in 'SettingFrame.pas' {FrameSetting: TFrame},
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule: TDataModule},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  uManager in 'uManager.pas',
  WaitingFrame in '..\..\..\OrangeProjectCommon\CommonFrames\WaitingFrame.pas' {FrameWaiting: TFrame},
  MessageBoxFrame in '..\..\..\OrangeProjectCommon\CommonFrames\MessageBoxFrame.pas' {FrameMessageBox: TFrame},
  HzSpell in '..\..\..\OrangeProjectCommon\HzSpell\HzSpell.pas';

{$R *.res}

begin
//  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TClientModule, ClientModule);
  Application.Run;
end.
