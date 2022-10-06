program OrangeQQ_FMX_D11;


uses
  System.StartUpCopy,
  FMX.Forms,
  uBaseLog,
  ContactorFrame in 'ContactorFrame.pas' {FrameContactor: TFrame},
  LoginFrame in 'LoginFrame.pas' {FrameLogin: TFrame},
  MainForm in 'MainForm.pas' {frmMain},
  MessageFrame in 'MessageFrame.pas' {FrameMessage: TFrame},
  SettingFrame in 'SettingFrame.pas' {FrameSetting: TFrame},
  StateFrame in 'StateFrame.pas' {FrameState: TFrame},
  ChatBoxFrame in 'ChatBoxFrame.pas' {FrameChatBox: TFrame},
  ChatInputFrame in 'ChatInputFrame.pas' {FrameChatInput: TFrame},
  QQCommonSkinMaterialFrame in 'QQCommonSkinMaterialFrame.pas' {QQCommonSkinMaterialDataModule: TDataModule},
  TalkFrame in 'TalkFrame.pas' {FrameTalk: TFrame},
  TalkMsgContentFrame in 'TalkMsgContentFrame.pas' {FrameTalkMsgContent: TFrame},
  TalkMsgTimeFrame in 'TalkMsgTimeFrame.pas' {FrameTalkMsgTime: TFrame},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas';

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;
  Application.Initialize;

  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TQQCommonSkinMaterialDataModule, QQCommonSkinMaterialDataModule);
  Application.Run;
end.
