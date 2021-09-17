//convert pas to utf8 by ¥

unit ListBoxFrame_AutoPullDownRefresh;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uDrawCanvas,
  uTimerTaskEvent,
  uSkinItems,
  uDrawPicture,
  uSkinListBoxType,

  uSkinFireMonkeyCheckBox, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox,  uSkinImageList, uSkinFireMonkeyButton,
  uSkinFireMonkeyPanel, uTimerTask, uSkinFireMonkeyCustomList, uSkinButtonType,
  uSkinPanelType, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uBaseSkinControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType;

type
  TFrameListBox_AutoPullDownRefresh = class(TFrame,IFrameChangeLanguageEvent)
    lbAutoPull: TSkinFMXListBox;
    idpMultiPic: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    pnlToolBarInner: TSkinFMXPanel;
    btnPullDownRefresh: TSkinFMXButton;
    taskRefresh: TTimerTaskEvent;
    SkinFMXPanel1: TSkinFMXPanel;
    btnPullUpLoadMore: TSkinFMXButton;
    taskLoadMore: TTimerTaskEvent;
    procedure taskRefreshExecute(Sender: TTimerTask);
    procedure taskRefreshExecuteEnd(Sender: TTimerTask);
    procedure lbAutoPullPullDownRefresh(Sender: TObject);
    procedure btnPullDownRefreshClick(Sender: TObject);
    procedure btnPullUpLoadMoreClick(Sender: TObject);
    procedure taskLoadMoreExecute(Sender: TTimerTask);
    procedure taskLoadMoreExecuteEnd(Sender: TTimerTask);
    procedure lbAutoPullPullUpLoadMore(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

implementation

{$R *.fmx}


procedure TFrameListBox_AutoPullDownRefresh.btnPullDownRefreshClick(Sender: TObject);
begin
  Self.lbAutoPull.Prop.StartPullDownRefresh();
end;

procedure TFrameListBox_AutoPullDownRefresh.btnPullUpLoadMoreClick(Sender: TObject);
begin
  Self.lbAutoPull.Prop.StartPullUpLoadMore();
end;

procedure TFrameListBox_AutoPullDownRefresh.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnPullDownRefresh.Text:=GetLangString(Self.btnPullDownRefresh.Name,ALangKind);
  Self.btnPullUpLoadMore.Text:=GetLangString(Self.btnPullUpLoadMore.Name,ALangKind);

  Self.lbAutoPull.SelfOwnMaterialToDefault.PullDownRefreshPanelMaterial.LoadingCaption:=
      GetLangString('PullDownRefresh LoadingCaption',ALangKind);
  Self.lbAutoPull.SelfOwnMaterialToDefault.PullDownRefreshPanelMaterial.DecidedLoadCaption:=
      GetLangString('PullDownRefresh DecidedLoadCaption',ALangKind);
  Self.lbAutoPull.SelfOwnMaterialToDefault.PullDownRefreshPanelMaterial.UnDecidedLoadCaption:=
      GetLangString('PullDownRefresh UnDecidedLoadCaption',ALangKind);

  Self.lbAutoPull.SelfOwnMaterialToDefault.PullUpLoadMorePanelMaterial.LoadingCaption:=
      GetLangString('PullUpLoadMore LoadingCaption',ALangKind);
  Self.lbAutoPull.SelfOwnMaterialToDefault.PullUpLoadMorePanelMaterial.DecidedLoadCaption:=
      GetLangString('PullUpLoadMore DecidedLoadCaption',ALangKind);
  Self.lbAutoPull.SelfOwnMaterialToDefault.PullUpLoadMorePanelMaterial.UnDecidedLoadCaption:=
      GetLangString('PullUpLoadMore UnDecidedLoadCaption',ALangKind);

end;

constructor TFrameListBox_AutoPullDownRefresh.Create(AOwner: TComponent);
begin
  inherited;

  //清空列表
  Self.lbAutoPull.Prop.Items.Clear(True);


  //初始多语言
  RegLangString(Self.btnPullDownRefresh.Name,[Self.btnPullDownRefresh.Text,'Pull down to refresh']);
  RegLangString(Self.btnPullUpLoadMore.Name,[Self.btnPullUpLoadMore.Text,'Pull up to load more data']);


  RegLangString('PullDownRefresh LoadingCaption',['正在加载...','Loading']);
  RegLangString('PullDownRefresh DecidedLoadCaption',['松开刷新','Release to refresh']);
  RegLangString('PullDownRefresh UnDecidedLoadCaption',['下拉刷新','Pulldown to refresh']);

  RegLangString('PullUpLoadMore LoadingCaption',['正在加载...','Loading']);
  RegLangString('PullUpLoadMore DecidedLoadCaption',['松开加载更多','Release to load more']);
  RegLangString('PullUpLoadMore UnDecidedLoadCaption',['上拉加载更多','Pullup to load more']);

  RegLangString('RefreshSucc',['刷新成功!','Refresh succ!']);
  RegLangString('LoadSucc',['加载成功!','Load succ!']);


  taskLoadMoreExecuteEnd(nil);
end;

destructor TFrameListBox_AutoPullDownRefresh.Destroy;
begin

  inherited;
end;

procedure TFrameListBox_AutoPullDownRefresh.lbAutoPullPullDownRefresh(Sender: TObject);
begin
  //执行
  taskRefresh.Run;
end;

procedure TFrameListBox_AutoPullDownRefresh.lbAutoPullPullUpLoadMore(Sender: TObject);
begin
  //执行
  taskLoadMore.Run;

end;

procedure TFrameListBox_AutoPullDownRefresh.taskLoadMoreExecute(Sender: TTimerTask);
begin
  //模拟从网络获取数据
  Sleep(3000);

end;

procedure TFrameListBox_AutoPullDownRefresh.taskLoadMoreExecuteEnd(Sender: TTimerTask);
var
  APicServerUrl:String;
  AListBoxItem:TSkinListBoxItem;
begin
  //把从网络获取到的数据加载到ListBox中
  //加载
  Self.lbAutoPull.Prop.Items.BeginUpdate;
  try

      //图片服务器链接地址
      APicServerUrl:='http://www.orangeui.cn/download/'
                    +'testdownloadpicturemanager/mobileposthumbpic/';


      //添加列表项

      AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
      AListBoxItem.Caption:='Cabernet Sauvignon';
      AListBoxItem.Icon.Url:=APicServerUrl+'1.jpg';
      AListBoxItem.Icon.IsClipRound:=True;
      AListBoxItem.Icon.ClipRoundXRadis:=10;
      AListBoxItem.Icon.ClipRoundYRadis:=10;
      AListBoxItem.Icon.ClipRoundCorners:=[TCorner.TopLeft, TCorner.BottomLeft];

      AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
      AListBoxItem.Caption:='ARDECHE';
      AListBoxItem.Icon.Url:=APicServerUrl+'2.jpg';

      AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
      AListBoxItem.Caption:='Tieguanyin Tea';
      AListBoxItem.Icon.Url:=APicServerUrl+'3.jpg';

      AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
      AListBoxItem.Caption:='Wahaha tea coffee';
      AListBoxItem.Icon.Url:=APicServerUrl+'5.jpg';

      AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
      AListBoxItem.Caption:='Wahaha cat coffee';
      AListBoxItem.Icon.Url:=APicServerUrl+'6.jpg';

      AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
      AListBoxItem.Caption:='series';
      AListBoxItem.Icon.Url:=APicServerUrl+'7.jpg';

      AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
      AListBoxItem.Caption:='Food Combo';
      AListBoxItem.Icon.Url:=APicServerUrl+'8.jpg';



  finally
      Self.lbAutoPull.Prop.Items.EndUpdate();
      //结束上拉加载更多
  //    TControl(Self.lbAutoPull.Prop.AutoPullDownRefreshPanel.Prop.LoadingLabel).
      Self.lbAutoPull.Prop.StopPullUpLoadMore(
        GetLangString('RefreshSucc',LangKind),//'刷新成功!',
        0,
        True
        );
  end;

end;

procedure TFrameListBox_AutoPullDownRefresh.taskRefreshExecute(
  Sender: TTimerTask);
begin
  //模拟从网络获取数据
  Sleep(3000);
end;

procedure TFrameListBox_AutoPullDownRefresh.taskRefreshExecuteEnd(
  Sender: TTimerTask);
var
  APicServerUrl:String;
  AListBoxItem:TSkinListBoxItem;
begin
  //把从网络获取到的数据加载到ListBox中
  //加载
  Self.lbAutoPull.Prop.Items.BeginUpdate;
  try
    //清空列表项
    Self.lbAutoPull.Prop.Items.Clear(True);

    //图片服务器链接地址
    APicServerUrl:='http://www.orangeui.cn/download/'
                  +'testdownloadpicturemanager/mobileposthumbpic/';


    //添加列表项

    AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
    AListBoxItem.Caption:='Cabernet Sauvignon';
    AListBoxItem.Icon.Url:=APicServerUrl+'1.jpg';
    AListBoxItem.Icon.IsClipRound:=True;
    AListBoxItem.Icon.ClipRoundXRadis:=10;
    AListBoxItem.Icon.ClipRoundYRadis:=10;
    AListBoxItem.Icon.ClipRoundCorners:=[TCorner.TopLeft, TCorner.BottomLeft];

    AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
    AListBoxItem.Caption:='ARDECHE';
    AListBoxItem.Icon.Url:=APicServerUrl+'2.jpg';

    AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
    AListBoxItem.Caption:='Tieguanyin Tea';
    AListBoxItem.Icon.Url:=APicServerUrl+'3.jpg';

    AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
    AListBoxItem.Caption:='Wahaha tea coffee';
    AListBoxItem.Icon.Url:=APicServerUrl+'5.jpg';

    AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
    AListBoxItem.Caption:='Wahaha cat coffee';
    AListBoxItem.Icon.Url:=APicServerUrl+'6.jpg';

    AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
    AListBoxItem.Caption:='series';
    AListBoxItem.Icon.Url:=APicServerUrl+'7.jpg';

    AListBoxItem:=Self.lbAutoPull.Prop.Items.Add;
    AListBoxItem.Caption:='Food Combo';
    AListBoxItem.Icon.Url:=APicServerUrl+'8.jpg';



  finally
    Self.lbAutoPull.Prop.Items.EndUpdate();
    //结束下拉刷新
//    TControl(Self.lbAutoPull.Prop.AutoPullDownRefreshPanel.Prop.LoadingLabel).Width:=300;
    Self.lbAutoPull.Prop.StopPullDownRefresh(
      GetLangString('RefreshSucc',LangKind)//'刷新成功'
      );
  end;
end;

end.
