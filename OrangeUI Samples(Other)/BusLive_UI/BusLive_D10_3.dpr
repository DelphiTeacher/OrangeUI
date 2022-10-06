program BusLive_D10_3;

























uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  GuideFrame in 'GuideFrame.pas' {FrameGuide: TFrame},
  BusLiveCommonSkinMaterialModule in 'BusLiveCommonSkinMaterialModule.pas' {BusLiveDataModuleCommonSkinMaterial: TDataModule},
  HomeFrame in 'HomeFrame.pas' {FrameHome: TFrame},
  CityListFrame in 'CityListFrame.pas' {FrameCityList: TFrame},
  LoginFrame in 'LoginFrame.pas' {FrameLogin: TFrame},
  ResetPassFrame in 'ResetPassFrame.pas' {FrameResetPass: TFrame},
  RegisterFrame in 'RegisterFrame.pas' {FrameRegister: TFrame},
  ScanWifiFrame in 'ScanWifiFrame.pas' {FrameScanWifi: TFrame},
  GoWhereFrame in 'GoWhereFrame.pas' {FrameGoWhere: TFrame},
  VertBusLineFrame in 'VertBusLineFrame.pas' {FrameVertBusLine: TFrame},
  HorzBusLineFrame in 'HorzBusLineFrame.pas' {FrameHorzBusLine: TFrame},
  BusLineFrame in 'BusLineFrame.pas' {FrameBusLine: TFrame},
  CarDistanceHintFrame in 'CarDistanceHintFrame.pas' {FrameCarDistanceHint: TFrame},
  BuyGoodsFrame in 'BuyGoodsFrame.pas' {FrameBuyGoods: TFrame},
  FMX.TMSZBarReader in 'FMX.TMSZBarReader.pas',
  FMX.TKRBarCodeScanner in 'FMX.TKRBarCodeScanner.pas',
  CarListFrame in 'CarListFrame.pas' {FrameCarList: TFrame},
  NearByFrame in 'NearByFrame.pas' {FrameNearBy: TFrame},
  StationListFrame in 'StationListFrame.pas' {FrameStationList: TFrame},
  FindBusStationFrame in 'FindBusStationFrame.pas' {FrameFindBusStation: TFrame},
  FilterBusLineFrame in 'FilterBusLineFrame.pas' {FrameFilterBusLine: TFrame},
  FindBusCarNoFrame in 'FindBusCarNoFrame.pas' {FrameFindBusCarNo: TFrame},
  FindBusLineFrame in 'FindBusLineFrame.pas' {FrameFindBusLine: TFrame},
  FindBusMethodFrame in 'FindBusMethodFrame.pas' {FrameFindBusMethod: TFrame},
  NewsFrame in 'NewsFrame.pas' {FrameNews: TFrame},
  NewsListFrame in 'NewsListFrame.pas' {FrameNewsList: TFrame},
  GoTalkRoomFrame in 'GoTalkRoomFrame.pas' {FrameGoTalkRoom: TFrame},
  TalkFrame in 'TalkFrame.pas' {FrameTalk: TFrame},
  NearbyShoppingFrame in 'NearbyShoppingFrame.pas' {FrameNearbyShopping: TFrame},
  StationInfoFrame in 'StationInfoFrame.pas' {FrameStationInfo: TFrame},
  FilterBusStationFrame in 'FilterBusStationFrame.pas' {FrameFilterBusStation: TFrame},
  BusStationFrame in 'BusStationFrame.pas' {FrameBusStation: TFrame},
  FilterBusCarNoFrame in 'FilterBusCarNoFrame.pas' {FrameFilterBusCarNo: TFrame},
  NewsDetailFrame in 'NewsDetailFrame.pas' {FrameNewsDetail: TFrame},
  SearchResultListFrame in 'SearchResultListFrame.pas' {FrameSearchResultList: TFrame},
  MyFrame in 'MyFrame.pas' {FrameMy: TFrame},
  AccountFrame in 'AccountFrame.pas' {FrameAccount: TFrame},
  StationMapFrame in 'StationMapFrame.pas' {FrameStationMap: TFrame},
  BusLineListFrame in 'BusLineListFrame.pas' {FrameBusLineList: TFrame},
  RealTimeBusLineFrame in 'RealTimeBusLineFrame.pas' {FrameRealTimeBusLine: TFrame},
  BusMethodFrame in 'BusMethodFrame.pas' {FrameBusMethod: TFrame},
  AddRecvAddressFrame in 'AddRecvAddressFrame.pas' {FrameAddRecvAddress: TFrame},
  StationSensorFrame in 'StationSensorFrame.pas' {FrameStationSensor: TFrame},
  ShopListFrame in 'ShopListFrame.pas' {FrameShopList: TFrame},
  ShopInfoFrame in 'ShopInfoFrame.pas' {FrameShopInfo: TFrame},
  CartFrame in 'CartFrame.pas' {FrameCart: TFrame},
  FilmHomeFrame in 'FilmHomeFrame.pas' {FrameFilmHome: TFrame},
  FilmListFrame in 'FilmListFrame.pas' {FrameFilmList: TFrame},
  FilmPlayListFrame in 'FilmPlayListFrame.pas' {FrameFilmPlayList: TFrame},
  FilmPlayInfoFrame in 'FilmPlayInfoFrame.pas' {FrameFilmPlayInfo: TFrame},
  PlayVideoFrame in 'PlayVideoFrame.pas' {FramePlayVideo: TFrame},
  FilmActorInfoFrame in 'FilmActorInfoFrame.pas' {FrameFilmActorInfo: TFrame},
  TalkMsgContentFrame in 'TalkMsgContentFrame.pas' {FrameTalkMsgContent: TFrame},
  TalkMsgTimeFrame in 'TalkMsgTimeFrame.pas' {FrameTalkMsgTime: TFrame},
  ChatBoxFrame in 'ChatBoxFrame.pas' {FrameChatBox: TFrame},
  ChatInputFrame in 'ChatInputFrame.pas' {FrameChatInput: TFrame},
  FMX.Platform.iOS in '..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TBusLiveDataModuleCommonSkinMaterial, BusLiveDataModuleCommonSkinMaterial);
  Application.Run;
end.
