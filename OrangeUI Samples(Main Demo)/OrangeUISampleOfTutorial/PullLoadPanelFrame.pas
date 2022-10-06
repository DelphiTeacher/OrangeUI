//convert pas to utf8 by ¥

unit PullLoadPanelFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyPullLoadPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinFireMonkeyButton, uSkinImageList, uSkinFireMonkeyPanel, uDrawPicture,
  uSkinPullLoadPanelType, uSkinFireMonkeyVirtualList, FMX.TabControl,
  FMX.Controls.Presentation, uSkinMaterial, uSkinScrollControlType,
  uTimerTask,
  uGraphicCommon,
  uSkinVirtualListType, uSkinListBoxType, uSkinCustomListType,
  uSkinFireMonkeyCustomList, uSkinButtonType, uSkinPanelType, uSkinLabelType,
  uSkinImageType, uBaseSkinControl, uDrawCanvas, uSkinItems;

type
  TFramePullLoadPanel = class(TFrame)
    lbDefaultPro: TSkinFMXListBox;
    plpDefaultProSync: TSkinFMXPullLoadPanel;
    SkinFMXLabel18: TSkinFMXLabel;
    SkinFMXLabel19: TSkinFMXLabel;
    SkinFMXImage12: TSkinFMXImage;
    SkinFMXImage13: TSkinFMXImage;
    plpDefaultProLoadMore: TSkinFMXPullLoadPanel;
    SkinFMXLabel20: TSkinFMXLabel;
    SkinFMXImage14: TSkinFMXImage;
    tcMain: TTabControl;
    tabDefaultPro: TTabItem;
    pnlTop: TSkinFMXPanel;
    btnSyncStopLoad: TSkinFMXButton;
    btnSyncStartLoad: TSkinFMXButton;
    pnlBottom: TSkinFMXPanel;
    btnLoadMoreStartLoad: TSkinFMXButton;
    btnLoadMoreStopLoad: TSkinFMXButton;
    tabDefault: TTabItem;
    lbDefault: TSkinFMXListBox;
    plpDefaultSync: TSkinFMXPullLoadPanel;
    imgDefaultTopLoading: TSkinFMXImage;
    plpDefaultLoadMore: TSkinFMXPullLoadPanel;
    imgDefaultBottomLoading: TSkinFMXImage;
    imglistHead: TSkinImageList;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXPanel5: TSkinFMXPanel;
    imglistIndicator: TSkinImageList;
    SkinImageList1: TSkinImageList;
    btnClear: TSkinFMXButton;
    procedure btnSyncStartLoadClick(Sender: TObject);
    procedure btnLoadMoreStartLoadClick(Sender: TObject);
    procedure btnLoadMoreStopLoadClick(Sender: TObject);
    procedure btnSyncStopLoadClick(Sender: TObject);
    procedure plpDefaultSyncExecuteLoad(Sender: TObject);
    procedure plpDefaultProSyncExecuteLoad(Sender: TObject);
    procedure plpDefaultProLoadMoreExecuteLoad(Sender: TObject);
    procedure plpDefaultLoadMoreExecuteLoad(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    //执行线程加载
    procedure DoThreadExecuteLoad(Sender:TObject);

    //执行线程加载结束
    procedure DoDefaultSyncThreadExecuteLoadEnd(Sender:TObject);
    procedure DoDefaultLoadMoreThreadExecuteLoadEnd(Sender:TObject);

    procedure DoDefaultProSyncThreadExecuteLoadEnd(Sender:TObject);
    procedure DoDefaultProLoadMoreThreadExecuteLoadEnd(Sender:TObject);

    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFramePullLoadPanel.DoThreadExecuteLoad(Sender: TObject);
begin
  //模拟线程加载数据的延时
  Sleep(4000);
end;

procedure TFramePullLoadPanel.DoDefaultSyncThreadExecuteLoadEnd(Sender: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  //模拟加载数据到ListBox
  //刷新
  Self.lbDefault.Prop.Items.BeginUpdate();
  try

    //刷新需要先清除
    Self.lbDefault.Prop.Items.Clear(True);

    for I := 0 to 10 do
    begin
      AListBoxItem:=Self.lbDefault.Prop.Items.Add;
      AListBoxItem.Caption:='好友昵称'+IntToStr(Self.lbDefault.Prop.Items.Count);
      AListBoxItem.Detail:='刷新添加';
      AListBoxItem.Icon.ImageIndex:=0;
    end;


  finally
    Self.lbDefault.Prop.Items.EndUpdate();

    //停止加载
//    Self.lbDefault.Prop.StopPullDownRefresh('刷新成功!',600);
    Self.plpDefaultSync.Properties.StopLoad;
  end;
end;

procedure TFramePullLoadPanel.DoDefaultLoadMoreThreadExecuteLoadEnd(Sender: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  //模拟加载数据到ListBox
  //加载更多
  Self.lbDefault.Prop.Items.BeginUpdate();
  try


    for I := 0 to 10 do
    begin
      AListBoxItem:=Self.lbDefault.Prop.Items.Add;
      AListBoxItem.Caption:='好友昵称'+IntToStr(Self.lbDefault.Prop.Items.Count);
      AListBoxItem.Detail:='加载更多添加';
      AListBoxItem.Icon.ImageIndex:=0;
    end;


  finally
    Self.lbDefault.Prop.Items.EndUpdate();

    //停止加载
//    Self.lbDefault.Prop.StopPullUpLoadMore(
//      '刷新成功!',
//      0,
//      True//加载到了更多的列表项,不回滚到初始,而是继续向下滚动
//      );
    Self.plpDefaultLoadMore.Properties.StopLoad;
  end;
end;


procedure TFramePullLoadPanel.DoDefaultProSyncThreadExecuteLoadEnd(Sender: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  //模拟加载数据到ListBox
  //刷新
  Self.lbDefaultPro.Prop.Items.BeginUpdate();
  try

    //刷新需要先清除
    Self.lbDefaultPro.Prop.Items.Clear(True);

    for I := 0 to 10 do
    begin
      AListBoxItem:=Self.lbDefaultPro.Prop.Items.Add;
      AListBoxItem.Caption:='好友昵称'+IntToStr(Self.lbDefaultPro.Prop.Items.Count);
      AListBoxItem.Detail:='刷新添加';
      AListBoxItem.Icon.ImageIndex:=0;
    end;


  finally
    Self.lbDefaultPro.Prop.Items.EndUpdate();

    //停止加载
    Self.plpDefaultProSync.Properties.StopLoad;
  end;
end;

procedure TFramePullLoadPanel.DoDefaultProLoadMoreThreadExecuteLoadEnd(Sender: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  //模拟加载数据到ListBox
  //加载更多
  Self.lbDefaultPro.Prop.Items.BeginUpdate();
  try


    for I := 0 to 10 do
    begin
      AListBoxItem:=Self.lbDefaultPro.Prop.Items.Add;
      AListBoxItem.Caption:='好友昵称'+IntToStr(Self.lbDefaultPro.Prop.Items.Count);
      AListBoxItem.Detail:='加载更多添加';
      AListBoxItem.Icon.ImageIndex:=0;
    end;


  finally
    Self.lbDefaultPro.Prop.Items.EndUpdate();

    //停止加载
    Self.plpDefaultProLoadMore.Properties.StopLoad;
  end;
end;

procedure TFramePullLoadPanel.plpDefaultSyncExecuteLoad(Sender: TObject);
var
  ATimerTask:TTimerTask;
begin
  //刷新
  ATimerTask:=TTimerTask.Create();
  ATimerTask.OnExecute:=DoThreadExecuteLoad;
  ATimerTask.OnExecuteEnd:=DoDefaultSyncThreadExecuteLoadEnd;
  GetGlobalTimerThread.RunTask(ATimerTask);
end;

procedure TFramePullLoadPanel.plpDefaultLoadMoreExecuteLoad(Sender: TObject);
var
  ATimerTask:TTimerTask;
begin
  //加载更多
  ATimerTask:=TTimerTask.Create();
  ATimerTask.OnExecute:=DoThreadExecuteLoad;
  ATimerTask.OnExecuteEnd:=DoDefaultLoadMoreThreadExecuteLoadEnd;
  GetGlobalTimerThread.RunTask(ATimerTask);

end;

procedure TFramePullLoadPanel.plpDefaultProLoadMoreExecuteLoad(Sender: TObject);
var
  ATimerTask:TTimerTask;
begin
  //加载更多
  ATimerTask:=TTimerTask.Create();
  ATimerTask.OnExecute:=DoThreadExecuteLoad;
  ATimerTask.OnExecuteEnd:=DoDefaultProLoadMoreThreadExecuteLoadEnd;
  GetGlobalTimerThread.RunTask(ATimerTask);

end;

procedure TFramePullLoadPanel.plpDefaultProSyncExecuteLoad(Sender: TObject);
var
  ATimerTask:TTimerTask;
begin
  //刷新
  ATimerTask:=TTimerTask.Create();
  ATimerTask.OnExecute:=DoThreadExecuteLoad;
  ATimerTask.OnExecuteEnd:=DoDefaultProSyncThreadExecuteLoadEnd;
  GetGlobalTimerThread.RunTask(ATimerTask);

end;

procedure TFramePullLoadPanel.btnClearClick(Sender: TObject);
begin
  Self.lbDefaultPro.Prop.Items.BeginUpdate;
  try
    Self.lbDefaultPro.Prop.Items.Clear(True);
  finally
    Self.lbDefaultPro.Prop.Items.EndUpdate;
  end;
end;

procedure TFramePullLoadPanel.btnLoadMoreStartLoadClick(Sender: TObject);
begin
  //开始加载更多
  Self.plpDefaultProLoadMore.Properties.StartLoad(TScrollBarKind.sbVertical);
end;

procedure TFramePullLoadPanel.btnLoadMoreStopLoadClick(Sender: TObject);
begin
  //停止加载更多
  Self.plpDefaultProLoadMore.Properties.StopLoad;
end;

procedure TFramePullLoadPanel.btnSyncStartLoadClick(Sender: TObject);
begin
  //开始刷新
  Self.plpDefaultProSync.Properties.StartLoad(TScrollBarKind.sbVertical);
end;

procedure TFramePullLoadPanel.btnSyncStopLoadClick(Sender: TObject);
begin
  //停止刷新
  Self.plpDefaultProSync.Properties.StopLoad;
end;

end.
