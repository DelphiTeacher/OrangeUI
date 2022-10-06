program OrangeGrid_FMX_XE10;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  uUIFunction in '..\..\OrangeProjectCommon\uUIFunction.pas',
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas';

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
