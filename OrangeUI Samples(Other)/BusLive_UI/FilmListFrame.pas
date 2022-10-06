//convert pas to utf8 by ¥
unit FilmListFrame;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  uUIFunction,
  uSkinItems,
  uTimerTask,
  uSkinListBoxType,
  FilmPlayListFrame,
  uSkinTreeViewType,
  BusLiveCommonSkinMaterialModule,
  FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyTreeView, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas;

type
  TFrameFilmList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbFilm: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXLabel7: TSkinFMXLabel;
    SkinFMXLabel8: TSkinFMXLabel;
    ItemLoadMore: TSkinFMXItemDesignerPanel;
    btnLoadMore: TSkinFMXButton;
    tvCategory: TSkinFMXTreeView;
    ItemTreeDefault: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    ItemTreeParent: TSkinFMXItemDesignerPanel;
    lblParentCaption: TSkinFMXLabel;
    procedure tvCategorySelectedItem(Sender:TObject;AItem:TSkinItem);
    procedure btnReturnClick(Sender: TObject);
    procedure lbFilmClickItem(Sender: TSkinItem);
  private
    FClassify:String;
    procedure DoLoadTimerTaskExecute(ATimerTask:TObject);
    procedure DoLoadTimerTaskExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure LoadClassify(AClassify:String);
    { Public declarations }
  end;

var
  GlobalFilmListFrame:TFrameFilmList;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameFilmList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

procedure TFrameFilmList.DoLoadTimerTaskExecute(ATimerTask: TObject);
begin
  //模拟加载数据延时
  Sleep(3000);

end;

procedure TFrameFilmList.DoLoadTimerTaskExecuteEnd(ATimerTask: TObject);
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
  Self.btnLoadMore.Caption:='点击展开下20条记录';
end;

procedure TFrameFilmList.lbFilmClickItem(Sender: TSkinItem);
var
  ATimerTask:TTimerTask;
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    //显示播放列表
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalFilmPlayListFrame),TFrameFilmPlayList,frmMain,nil,nil,nil,Application);
//    GlobalFilmPlayListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalFilmPlayListFrame.LoadData(FClassify,TSkinItem(Sender).Caption);
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

procedure TFrameFilmList.LoadClassify(AClassify: String);
begin
  FClassify:=AClassify;
  Self.pnlToolBar.Caption:=AClassify+'列表';
end;

procedure TFrameFilmList.tvCategorySelectedItem(Sender:TObject;AItem:TSkinItem);
var
  I: Integer;
begin
  //先将所有的Item的Childs的Selected为False
  for I := 0 to TSkinTreeViewItem(Sender).Parent.Childs.Count-1 do
  begin
    if TSkinTreeViewItem(Sender).Parent.Childs[I]<>Sender then
    begin
      TSkinTreeViewItem(Sender).Parent.Childs[I].Selected:=False;
    end;
  end;
end;

end.
