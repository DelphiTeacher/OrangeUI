program FrameTest2_FrameContext_FMX_XE10;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  uUIFunction in '..\..\..\OrangeProjectCommon\uUIFunction.pas',
  FMX.Platform.iOS in '..\..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  SecondFrame in 'SecondFrame.pas' {FrameSecond: TFrame},
  ThirdFrame in 'ThirdFrame.pas' {FrameThird: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
