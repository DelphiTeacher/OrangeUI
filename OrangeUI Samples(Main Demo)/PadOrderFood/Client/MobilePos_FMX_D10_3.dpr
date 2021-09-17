program MobilePos_FMX_D10_3;



uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  FMX.Platform.iOS in '..\..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  SettingFrame in 'SettingFrame.pas' {FrameSetting: TFrame},
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule: TDataModule},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  uManager in 'uManager.pas',
  HzSpell in '..\..\..\OrangeProjectCommon\HzSpell\HzSpell.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas';

{$R *.res}

begin
//  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TClientModule, ClientModule);
  Application.Run;
end.
