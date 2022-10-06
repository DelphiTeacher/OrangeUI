//convert pas to utf8 by ¥
unit FilmHomeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uSkinItems,
  FilmListFrame,
  FilmPlayListFrame,
  uUIFunction,
  uTimerTask,
  uSkinListBoxType,
  FilmPlayInfoFrame,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyListView, uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinButtonType, uSkinFireMonkeySwitchPageListPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinMaterial,
  uSkinScrollControlType, uSkinVirtualListType, uSkinListViewType, uDrawPicture,
  uSkinImageList, uSkinCustomListType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollBoxContentType, uSkinScrollBoxType,
  uSkinPanelType, uDrawCanvas;

type
  TFrameFilmHome = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    imslistIcon: TSkinImageList;
    lvMenuMaterial: TSkinListViewDefaultMaterial;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlNewest: TSkinFMXPanel;
    lbFilm: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    ItemLoadMore: TSkinFMXItemDesignerPanel;
    btnLoadMore: TSkinFMXButton;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXLabel7: TSkinFMXLabel;
    SkinFMXLabel8: TSkinFMXLabel;
    lbMenu: TSkinFMXListView;
    procedure btnReturnClick(Sender: TObject);
    procedure lbFilmClickItem(Sender: TSkinItem);
    procedure lbMenuClickItem(Sender: TSkinItem);
  private
    procedure SyncContentHeight;
    procedure DoLoadTimerTaskExecute(ATimerTask:TObject);
    procedure DoLoadTimerTaskExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


var
  GlobalFilmHomeFrame:TFrameFilmHome;


implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameFilmHome.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameFilmHome.Create(AOwner: TComponent);
begin
  inherited;
  SyncContentHeight;
end;

procedure TFrameFilmHome.DoLoadTimerTaskExecute(ATimerTask: TObject);
begin
  //模拟加载数据延时
  Sleep(3000);
end;

procedure TFrameFilmHome.DoLoadTimerTaskExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  Self.lbFilm.Prop.Items.BeginUpdate;
  try
    for I := 0 to 20 do
    begin
      AListBoxItem:=Self.lbFilm.Prop.Items.Insert(Self.lbFilm.Prop.Items.Count-1);
      AListBoxItem.Caption:='黑瞳';
      AListBoxItem.Detail:='杜云萍';
      AListBoxItem.Detail1:='王姬 成泰乐';
      AListBoxItem.Detail2:='2.3万';
      AListBoxItem.Detail3:='3.6';
      AListBoxItem.Icon.Assign(Self.lbFilm.Prop.Items[I].Icon);
    end;
  finally
    Self.lbFilm.Prop.Items.EndUpdate();
  end;
  SyncContentHeight;
  Self.btnLoadMore.Caption:='点击展开下20条记录';
end;

procedure TFrameFilmHome.lbFilmClickItem(Sender: TSkinItem);
var
  ATimerTask:TTimerTask;
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    //查看电影
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalFilmPlayInfoFrame),TFrameFilmPlayInfo,frmMain,nil,nil,nil,Application);
//    GlobalFilmPlayInfoFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if TSkinItem(Sender).ItemType=sitFooter then
  begin
    //加载更多
    Self.btnLoadMore.Caption:='正在加载...';

    ATimerTask:=TTimerTask.Create(0);
    ATimerTask.OnExecute:=Self.DoLoadTimerTaskExecute;
    ATimerTask.OnExecuteEnd:=Self.DoLoadTimerTaskExecuteEnd;
    GetGlobalTimerThread.RunTask(ATimerTask);
  end;
end;

procedure TFrameFilmHome.lbMenuClickItem(Sender: TSkinItem);
begin
  //列表
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalFilmListFrame),TFrameFilmList,frmMain,nil,nil,nil,Application);
//  GlobalFilmListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalFilmListFrame.LoadClassify(TSkinItem(Sender).Caption);
end;

procedure TFrameFilmHome.SyncContentHeight;
begin
  Self.sbClient.Prop.ContentHeight:=Self.lbMenu.Height
        +Self.pnlNewest.Height
        +Self.lbFilm.Prop.GetContentHeight;
end;

end.
