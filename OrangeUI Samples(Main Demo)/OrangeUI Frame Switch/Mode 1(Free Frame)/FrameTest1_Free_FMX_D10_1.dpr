program FrameTest1_Free_FMX_D10_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  FirstFrame in 'FirstFrame.pas' {FrameFirst: TFrame},
  SecondFrame in 'SecondFrame.pas' {FrameSecond: TFrame},
  uFrameContext in '..\..\..\OrangeUIControl\Source\Base\uFrameContext.pas',
  uUIFunction in '..\..\..\OrangeUIControl\Source\Common\uUIFunction.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
