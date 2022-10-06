program OrangeShopping_FMX_XE8;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  MainFrame in 'MainFrame.pas' {FrameMain: TFrame},
  HomeFrame in 'HomeFrame.pas' {FrameHome: TFrame},
  ClassifyFrame in 'ClassifyFrame.pas' {FrameClassify: TFrame},
  ShoppingCartFrame in 'ShoppingCartFrame.pas' {FrameShoppingCart: TFrame},
  MyFrame in 'MyFrame.pas' {FrameMy: TFrame},
  KindProductListFrame in 'KindProductListFrame.pas' {FrameKindProductList: TFrame},
  ProductInfoFrame in 'ProductInfoFrame.pas' {FrameProductInfo: TFrame},
  ClassifyProductListFrame in 'ClassifyProductListFrame.pas' {FrameClassifyProductList: TFrame},
  BuyProductFrame in 'BuyProductFrame.pas' {FrameBuyProduct: TFrame},
  uUIFunction in '..\..\OrangeProjectCommon\uUIFunction.pas',
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas';

{$R *.res}

begin
//  ReportMemoryLeaksONShutdown:=DebugHook<>0;

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
