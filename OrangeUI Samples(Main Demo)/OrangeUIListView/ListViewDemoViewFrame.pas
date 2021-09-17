//convert pas to utf8 by ¥

unit ListViewDemoViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uFrameContext,


  Box9Menu_CZNYT_MainFrame,
  Box9Menu_ZiMaYou_MineFrame,
  Box9Menu_XunKe_HomeFrame,


  Basic_DesignerPanel_MessageFrame,
//  SpiritFrame,
//  WaterfallSpiritFrame,

  Basic_PanDrag_ShoppingCartFrame,
  Basic_DesignTimePreview_ListBoxFrame,
  Basic_MultiDesignerPanel_ListBoxFarme,
//  NewsListFrame,
  Basic_Filter_ListBoxFrame,


  Bind_MultiColorLabel_ProductListFrame,
  Bind_RoundImage_MessageFrame,
  Bind_ImageListViewer_HomeFrame,



  ViewMode_CenterSelect_SelectCityFrame,
  ViewMode_Switch_SearchResultFrame,
  ViewMode_Horz_BusLineFrame,
  ViewMode_Complex_ListViewFarme,


  TreeView_Nomal_ContactorFrame,
  TreeView_Complex_AssistantFrame,

  uFuncCommon,

  uUIFunction,
  uSkinFireMonkeyLabel, uSkinLabelType, uSkinButtonType, uSkinPanelType;




type
  TFrameListViewDemoView = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblDemo: TSkinFMXLabel;
    pnlClient: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
  private
    FDemoFrame:TFrame;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure ShowDemo(Demo:String;Memo:String);
    procedure ShowFrame(FrameClass:TFrameClass);
    { Public declarations }
  end;


var
  GlobalListViewDemoViewFrame:TFrameListViewDemoView;


implementation


{$R *.fmx}

uses
  MainForm;


procedure TFrameListViewDemoView.btnReturnClick(Sender: TObject);
begin

  HideFrame;////(Self);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameListViewDemoView.ShowDemo(Demo:String;Memo:String);
begin

  Self.pnlToolBar.Caption:='';//Caption;
  Self.lblDemo.Caption:=Memo;




  //九宫格
  if Pos('智慧农业APP的主页面',Demo)>0 then ShowFrame(TFrameBox9Menu_CZNYT_Main);
  if Pos('芝麻游APP的个人页面',Demo)>0 then ShowFrame(TFrameBox9Menu_ZiMaYou_Mine);
  if Pos('讯客APP的主页面',Demo)>0 then ShowFrame(TFrameBox9Menu_XunKe_Home);


  //基本
  if Pos('利用面板来设计样式',Demo)>0 then ShowFrame(TFrameBasic_DesignerPanel_Message);
  if Pos('多个设计面板实现不同的样式',Demo)>0 then ShowFrame(TFrameBasic_MultiDesignerPanel_ListBox);
//  if Pos('装逼要遭雷劈',Demo)>0 then ShowFrame(TFrameSpirit);
  if Pos('设计时直接预览效果',Demo)>0 then ShowFrame(TFrameBasic_DesignTimePreview_ListBox);
//  if Pos('轻松实现下拉刷新、上拉加载更多',Demo)>0 then ShowFrame(TFrameNewsList);
//  if Pos('自动下载图络图片及缓存管理',Demo)>0 then ShowFrame(TFrameNewsList);
  if Pos('列表过滤',Demo)>0 then ShowFrame(TFrameBasic_Filter_ListBox);
  if Pos('自定义左右平移功能按钮',Demo)>0 then ShowFrame(TFrameBasic_PanDrag_ShoppingCart);




  //绑定
  if Pos('绑定多颜色标签',Demo)>0 then ShowFrame(TFrameBind_MultiColorLabel_ProductList);
  if Pos('裁剪成圆形头像',Demo)>0 then ShowFrame(TFrameBind_RoundImage_Message);
  if Pos('放置广告轮播',Demo)>0 then ShowFrame(TFrameBind_ImageListViewer_Home);




  //显示模式
  if Pos('随意排列',Demo)>0 then ShowFrame(TFrameViewMode_Complex_ListView);
//  if Pos('瀑布流视图模式',Demo)>0 then ShowFrame(TFrameWaterfallSpirit);
  if Pos('水平排列模式',Demo)>0 then ShowFrame(TFrameViewMode_Horz_BusLine);
  if Pos('居中选择模式',Demo)>0 then ShowFrame(TFrameViewMode_CenterSelect_SelectCity);
  if Pos('可以随时切换模式',Demo)>0 then ShowFrame(TFrameViewMode_Switch_SearchResult);



  //树型视图
  if Pos('联系人列表',Demo)>0 then ShowFrame(TFrameTreeView_Nomal_Contactor);
  if Pos('体彩列表',Demo)>0 then ShowFrame(TFrameTreeView_Complex_Assistant);




end;

procedure TFrameListViewDemoView.ShowFrame(FrameClass: TFrameClass);
begin
  if FDemoFrame<>nil then
  begin
    FDemoFrame.Visible:=False;
    FreeAndNil(FDemoFrame);
  end;


  FDemoFrame:=FrameClass.Create(frmMain);
  SetFrameName(FDemoFrame);
  FDemoFrame.Parent:=pnlClient;
  FDemoFrame.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}Client{$ELSE}alClient{$IFEND};
end;

end.

