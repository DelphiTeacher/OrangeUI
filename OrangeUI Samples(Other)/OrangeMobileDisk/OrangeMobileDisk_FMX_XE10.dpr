program OrangeMobileDisk_FMX_XE8;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  FileManageFrame in 'FileManageFrame.pas' {FrameFileManage: TFrame},
  NewFolderFrame in 'NewFolderFrame.pas' {FrameNewFolder: TFrame},
  PictureFileFrame in 'PictureFileFrame.pas' {FramePictureFile: TFrame},
  TextFileFrame in 'TextFileFrame.pas' {FrameTextFile: TFrame},
  uFileManage in 'uFileManage.pas',
  MainForm in 'MainForm.pas' {frmMain},
  uUIFunction in '..\..\OrangeProjectCommon\uUIFunction.pas',
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  InputFrame in '..\..\OrangeProjectCommon\CommonFrames\InputFrame.pas' {FrameInput: TFrame},
  HintFrame in '..\..\OrangeProjectCommon\CommonFrames\HintFrame.pas' {FrameHint: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
