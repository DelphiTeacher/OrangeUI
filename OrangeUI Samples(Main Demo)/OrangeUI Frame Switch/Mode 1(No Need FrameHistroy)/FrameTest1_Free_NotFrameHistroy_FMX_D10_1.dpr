program FrameTest1_Free_NotFrameHistroy_FMX_D10_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  uUIFunction in '..\..\..\OrangeProjectCommon\uUIFunction.pas',
  FMX.Platform.iOS in '..\..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  FirstFrame in 'FirstFrame.pas' {FrameFirst: TFrame},
  SecondFrame in 'SecondFrame.pas' {FrameSecond: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
