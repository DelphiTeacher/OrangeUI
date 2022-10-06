program TakeOrderClient_D10_3;



uses
  System.StartUpCopy,
  FMX.Forms,
  uGraphicCommon,
  uAPPCommon in '..\..\..\OrangeProjectCommon\uAPPCommon.pas',
  FMX.Platform.iOS in '..\..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.DeviceInfo in '..\..\..\OrangeProjectCommon\FMX.DeviceInfo.pas',
  FMX.Context.GLES.iOS in '..\..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  uAndroidLog in '..\..\..\OrangeProjectCommon\Android\uAndroidLog.pas',
  FlyUtils.Android.PostRunnableAndTimer in '..\..\..\OrangeProjectCommon\FlyFilesUtils\FlyUtils.Android.PostRunnableAndTimer.pas',
  uGetDeviceInfo in '..\..\..\OrangeProjectCommon\uGetDeviceInfo.pas',
  HzSpell in '..\..\..\OrangeProjectCommon\HzSpell\HzSpell.pas',
  MainForm in '..\MainForm.pas' {frmMain},
  FlyFmxUtils in '..\..\..\OrangeProjectCommon\FlyFilesUtils\FlyFmxUtils.pas',
  EasyServiceCommonMaterialDataMoudle in '..\EasyServiceCommonMaterialDataMoudle.pas' {dmEasyServiceCommonMaterial: TDataModule},
  FMX.TMSZBarReader in '..\BarCode\FMX.TMSZBarReader.pas',
  FMX.TKRBarCodeScanner in '..\BarCode\FMX.TKRBarCodeScanner.pas',
  AboutUsFrame in '..\AboutUsFrame.pas' {FrameAboutUs: TFrame},
  AddHotelFrame in '..\AddHotelFrame.pas' {FrameAddHotel: TFrame},
  AddHotelRecvAddrFrame in '..\AddHotelRecvAddrFrame.pas' {FrameAddHotelRecvAddr: TFrame},
  AddMyBankCardFrame in '..\AddMyBankCardFrame.pas' {FrameAddMyBankCard: TFrame},
  AuditInfoFrame in '..\AuditInfoFrame.pas' {FrameAuditInfo: TFrame},
  BuyGoodsListFrame in '..\BuyGoodsListFrame.pas' {FrameBuyGoodsList: TFrame},
  ChangePasswordFrame in '..\ChangePasswordFrame.pas' {FrameChangePassword: TFrame},
  ClipHeadFrame in '..\ClipHeadFrame.pas' {FrameClipHead: TFrame},
  ForgetPasswordFrame in '..\ForgetPasswordFrame.pas' {FrameForgetPassword: TFrame},
  GoodsInfoFrame in '..\GoodsInfoFrame.pas' {FrameGoodsInfo: TFrame},
  HomeFrame in '..\HomeFrame.pas' {FrameHome: TFrame},
  HotelInfoFrame in '..\HotelInfoFrame.pas' {FrameHotelInfo: TFrame},
  HotelListFrame in '..\HotelListFrame.pas' {FrameHotelList: TFrame},
  HotelRecvAddrListFrame in '..\HotelRecvAddrListFrame.pas' {FrameHotelRecvAddrList: TFrame},
  InputNameFrame in '..\InputNameFrame.pas' {FrameInputName: TFrame},
  LoginFrame in '..\LoginFrame.pas' {FrameLogin: TFrame},
  MainFrame in '..\MainFrame.pas' {FrameMain: TFrame},
  MyBankCardListFrame in '..\MyBankCardListFrame.pas' {FrameMyBankCardList: TFrame},
  MyFrame in '..\MyFrame.pas' {FrameMy: TFrame},
  NoticeClassifyListFrame in '..\NoticeClassifyListFrame.pas' {FrameNoticeClassifyList: TFrame},
  NoticeListFrame in '..\NoticeListFrame.pas' {FrameNoticeList: TFrame},
  OrderGoodsListFrame in '..\OrderGoodsListFrame.pas' {FrameOrderGoodsList: TFrame},
  OrderInfoFrame in '..\OrderInfoFrame.pas' {FrameOrderInfo: TFrame},
  OrderListFrame in '..\OrderListFrame.pas' {FrameOrderList: TFrame},
  OrderStateFrame in '..\OrderStateFrame.pas' {FrameOrderState: TFrame},
  PayOrderByTranserFrame in '..\PayOrderByTranserFrame.pas' {FramePayOrderByTranser: TFrame},
  PayOrderFrame in '..\PayOrderFrame.pas' {FramePayOrder: TFrame},
  PayOrderResultFrame in '..\PayOrderResultFrame.pas' {FramePayOrderResult: TFrame},
  RegisterFrame in '..\RegisterFrame.pas' {FrameRegister: TFrame},
  ResetPassWordFrame in '..\ResetPassWordFrame.pas' {FrameResetPassword: TFrame},
  SearchHistoryFrame in '..\SearchHistoryFrame.pas' {FrameSearchHistory: TFrame},
  SelectedHotelClassifyFrame in '..\SelectedHotelClassifyFrame.pas' {FrameSelectedHotelClassify: TFrame},
  SystemNotificationInfoFrame in '..\SystemNotificationInfoFrame.pas' {FrameSystemNotificationInfo: TFrame},
  TakeOrderFrame in '..\TakeOrderFrame.pas' {FrameTakeOrder: TFrame},
  uEasyServiceCommon in '..\uEasyServiceCommon.pas',
  uInterfaceClass in '..\uInterfaceClass.pas',
  uManager in '..\uManager.pas',
  UserCartFrame in '..\UserCartFrame.pas' {FrameUserCart: TFrame},
  DelphiZXIngQRCode in '..\DelphiZXIngQRCode.pas',
  uIdHttpControl in '..\..\..\OrangeProjectCommon\uIdHttpControl.pas',
  WebBrowserFrame in '..\WebBrowserFrame.pas' {FrameWebBrowser: TFrame},
  uVirtualListDataController in '..\..\..\OrangeProjectCommon\uVirtualListDataController.pas',
  uOpenCommon in '..\..\..\OrangeProjectCommon\uOpenCommon.pas',
  uModule_InterfaceSign in '..\..\..\OrangeProjectCommon\uModule_InterfaceSign.pas',
  XSuperJSON in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas';

{$R *.res}

begin
  //主题色 蓝色
  uGraphicCommon.SkinThemeColor:=$FF438DF5;


  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TdmEasyServiceCommonMaterial, dmEasyServiceCommonMaterial);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
