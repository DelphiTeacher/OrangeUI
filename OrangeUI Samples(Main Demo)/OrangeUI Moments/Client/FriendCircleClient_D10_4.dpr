program FriendCircleClient_D10_4;






uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Types,
  FMX.Platform.iOS in '..\..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  AddSpiritFrame in 'AddSpiritFrame.pas' {FrameAddSpirit: TFrame},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule: TDataModule},
  ForgetPasswordFrame in 'ForgetPasswordFrame.pas' {FrameForgetPassword: TFrame},
  LoginFrame in 'LoginFrame.pas' {FrameLogin: TFrame},
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  MyFrame in 'MyFrame.pas' {FrameMy: TFrame},
  RegisterFrame in 'RegisterFrame.pas' {FrameRegister: TFrame},
  SpiritFrame in 'SpiritFrame.pas' {FrameSpirit: TFrame},
  uManager in 'uManager.pas',
  AboutUsFrame in 'AboutUsFrame.pas' {FrameAboutUs: TFrame},
  WaterfallSpiritFrame in 'WaterfallSpiritFrame.pas' {FrameWaterfallSpirit: TFrame},
  ChangePasswordFrame in 'ChangePasswordFrame.pas' {FrameChangePassword: TFrame},
  ChangeNameFrame in 'ChangeNameFrame.pas' {FrameChangeName: TFrame},
  ChangeSignFrame in 'ChangeSignFrame.pas' {FrameChangeSign: TFrame},
  EditMyFrame in 'EditMyFrame.pas' {FrameEditMyFrame: TFrame},
  ResetPassWordFrame in 'ResetPassWordFrame.pas' {FrameResetPassword: TFrame},
  RegisterProtocolFrame in 'RegisterProtocolFrame.pas' {FrameRegisterProtocol: TFrame},
  FMX.DeviceInfo in '..\..\..\OrangeProjectCommon\FMX.DeviceInfo.pas',
  uAPPCommon in '..\..\..\OrangeProjectCommon\uAPPCommon.pas',
  uAndroidLog in '..\..\..\OrangeProjectCommon\Android\uAndroidLog.pas',
  FlyUtils.Android.PostRunnableAndTimer in '..\..\..\OrangeProjectCommon\FlyFilesUtils\FlyUtils.Android.PostRunnableAndTimer.pas',
  GetUserInfoFrame in 'GetUserInfoFrame.pas' {FrameGetUserInfo: TFrame},
  ShieldUserListFrame in 'ShieldUserListFrame.pas' {FrameShieldUserList: TFrame},
  ComplainUserFrame in 'ComplainUserFrame.pas' {FrameComplainUser: TFrame},
  FriendCircleCommonMaterialDataMoudle in 'FriendCircleCommonMaterialDataMoudle.pas' {dmFriendCircleCommonMaterial: TDataModule},
  HzSpell in '..\..\..\OrangeProjectCommon\HzSpell\HzSpell.pas',
  uIdHttpControl in '..\..\..\OrangeProjectCommon\uIdHttpControl.pas',
  uNativeHttpControl in '..\..\..\OrangeProjectCommon\uNativeHttpControl.pas',
  uGPSLocation in '..\..\..\OrangeProjectCommon\uGPSLocation.pas',
  uMapCommon in '..\..\..\OrangeProjectCommon\uMapCommon.pas',
  PopupMenuFrame in '..\..\..\OrangeProjectCommon\CommonFrames\PopupMenuFrame.pas',
  MultiSelectFrame in '..\..\..\OrangeProjectCommon\CommonFrames\MultiSelectFrame.pas',
  uVirtualListDataController in '..\..\..\OrangeProjectCommon\uVirtualListDataController.pas',
  uModule_InterfaceSign in '..\..\..\OrangeProjectCommon\uModule_InterfaceSign.pas',
  uOpenCommon in '..\..\..\OrangeProjectCommon\uOpenCommon.pas';

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TdmFriendCircleCommonMaterial, dmFriendCircleCommonMaterial);
  Application.CreateForm(TClientModule, ClientModule);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
