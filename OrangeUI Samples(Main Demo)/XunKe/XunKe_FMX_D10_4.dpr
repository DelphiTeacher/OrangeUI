program XunKe_FMX_D10_4;

uses
  System.StartUpCopy,
  FMX.Forms,
  MyFrame in 'MyFrame.pas' {FrameMy: TFrame},
  TodayOrderFrame in 'TodayOrderFrame.pas' {FrameTodayOrder: TFrame},
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  SettingFrame in 'SettingFrame.pas' {FrameSetting: TFrame},
  LoginFrame in 'LoginFrame.pas' {FrameLogin: TFrame},
  TradeCenterFrame in 'TradeCenterFrame.pas' {FrameTradeCenter: TFrame},
  MyBillFrame in 'MyBillFrame.pas' {FrameMyBill: TFrame},
  ShopFrame in 'ShopFrame.pas' {FrameShop: TFrame},
  ContactorFrame in 'ContactorFrame.pas' {FrameContactor: TFrame},
  TalkFrame in 'TalkFrame.pas' {FrameTalk: TFrame},
  XunKeCommonSkinMaterialModule in 'XunKeCommonSkinMaterialModule.pas' {XunKeDataModuleCommonSkinMaterial: TDataModule},
  ProductInfoFrame in 'ProductInfoFrame.pas' {FrameProductInfo: TFrame},
  HomeFrame in 'HomeFrame.pas' {FrameHome: TFrame},
  SearchFrame in 'SearchFrame.pas' {FrameSearch: TFrame},
  CategoryFrame in 'CategoryFrame.pas' {FrameCategory: TFrame},
  SearchResultFrame in 'SearchResultFrame.pas' {FrameSearchResult: TFrame},
  BuyProductFrame in 'BuyProductFrame.pas' {FrameBuyProduct: TFrame},
  ShopCartFrame in 'ShopCartFrame.pas' {FrameShopCart: TFrame},
  SubmitOrderFrame in 'SubmitOrderFrame.pas' {FrameSubmitOrder: TFrame},
  PayFrame in 'PayFrame.pas' {FramePay: TFrame},
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Pickers.iOS in '..\..\OrangeProjectCommon\FMX.Pickers.iOS.pas',
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas';

{$R *.res}

begin
  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.CreateForm(TXunKeDataModuleCommonSkinMaterial, XunKeDataModuleCommonSkinMaterial);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
