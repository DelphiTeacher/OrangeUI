//convert pas to utf8 by ¥

unit MobileHomeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  DateUtils,
  Math,
  uBaseLog,
  uSinaWeiboManager,
  uWeiboUtils,
  uTimerTask,
  uFileCommon,
  uIdHttpControl,
  uOpenPlatform,
  uDataStructure,
//  uAPIItem_statuses_update,
  uAPIItem_statuses_home_timeline,
  uAPIItem_statuses_public_timeline,
  uSkinItems,
  uUIFunction,
  uFuncCommon,
  uDrawCanvas,
  uSkinListBoxType,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton,
  uSkinImageList,
  uSkinScrollBarType,
  uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uSkinAnimator, uDrawPicture,
  uSkinPullLoadPanelType, uSkinFireMonkeyPullLoadPanel, FMX.Objects,
  uSkinFireMonkeyPopup, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinImageType, uSkinButtonType,
  uSkinPanelType;

type
  TFrameMobileHome = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnAddFriend: TSkinFMXButton;
    btnPop: TSkinFMXButton;
    btnMyInfo: TSkinFMXButton;
    lbStatuses: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgHead: TSkinFMXImage;
    lblNick: TSkinFMXLabel;
    lblTime: TSkinFMXLabel;
    lblFrom: TSkinFMXLabel;
    lblText: TSkinFMXLabel;
    btnreposts_count: TSkinFMXButton;
    pnlDevide: TSkinFMXPanel;
    btncomments_count: TSkinFMXButton;
    btnattitudes_count: TSkinFMXButton;
    imgDevide1: TSkinFMXImage;
    imgDevide2: TSkinFMXImage;
    imgLine: TSkinFMXImage;
    SkinFMXImage1: TSkinFMXImage;
    plpTop: TSkinFMXPullLoadPanel;
    plpBottom: TSkinFMXPullLoadPanel;
    imgLoad: TSkinFMXImage;
    lblLoad: TSkinFMXLabel;
    imgSync: TSkinFMXImage;
    lblSyncFlag: TSkinFMXLabel;
    imgSyncFlag: TSkinFMXImage;
    lblTopLoadInfo: TSkinFMXLabel;
    popScan: TSkinFMXPopup;
    lbFunction: TSkinFMXListBox;
    popGroup: TSkinFMXPopup;
    lbMenu: TSkinFMXListBox;
    procedure lbStatusesPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure lbStatusesResize(Sender: TObject);
    procedure btnMyInfoClick(Sender: TObject);
    procedure plpTopExecuteLoad(Sender: TObject);
    procedure plpBottomExecuteLoad(Sender: TObject);
    procedure lbMenuClickItem(Sender: TSkinItem);
    procedure btnPopClick(Sender: TObject);
    procedure lbFunctionClickItem(Sender: TSkinItem);
  private

    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure OnAsync_Getusers_show_ExecuteEnd(ATimerTask:TObject);
    procedure OnAsync_Gethome_timeline_ExecuteEnd(ATimerTask:TObject);
    procedure OnAload_Gethome_timeline_ExecuteEnd(ATimerTask:TObject);
    { Public declarations }
  end;


var
  GlobalMobileHomeFrame:TFrameMobileHome;

implementation



{$R *.fmx}


procedure TFrameMobileHome.btnMyInfoClick(Sender: TObject);
begin
    //弹出菜单
    if not popGroup.IsOpen then
    begin
        //绝对位置
        popGroup.PlacementRectangle.Left:=Self.LocalToScreen(PointF(Self.btnMyInfo.Position.X,0)).X;
        popGroup.PlacementRectangle.Top:=Self.LocalToScreen(PointF(0,Self.pnlToolBar.Height)).Y-25;

        popGroup.IsOpen := True;
    end
    else
    begin
        popGroup.IsOpen := False;
    end;
end;

procedure TFrameMobileHome.btnPopClick(Sender: TObject);
begin
    //弹出菜单
    if not popScan.IsOpen then
    begin
        //绝对位置
        popScan.PlacementRectangle.Left:=Self.LocalToScreen(PointF(Self.btnPop.Position.X+Self.btnPop.Width,0)).X-Self.popScan.Width;
        popScan.PlacementRectangle.Top:=Self.LocalToScreen(PointF(0,Self.pnlToolBar.Height)).Y-25;
        popScan.IsOpen := True;
    end
    else
    begin
        popScan.IsOpen := False;
    end;
end;

constructor TFrameMobileHome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if GlobalManager.Current_user.idstr='' then
  begin
    btnMyInfo.Caption:='正在加载...';
  end
  else
  begin
    Self.btnMyInfo.Caption:=GlobalManager.Current_user.screen_name;
  end;

  //首次加载
  Self.plpTop.Properties.StartLoad();
end;

destructor TFrameMobileHome.Destroy;
var
  I: Integer;
  ATempObject:TObject;
begin
  Self.lbStatuses.Properties.Items.BeginUpdate;
  try
    //释放绑定的微博项
    for I := Self.lbStatuses.Properties.Items.Count - 1 downto 0 do
    begin
      ATempObject:=TObject(Self.lbStatuses.Properties.Items[I].Data);
      FreeAndNil(ATempObject);
    end;
  finally
    Self.lbStatuses.Properties.Items.EndUpdate;
  end;


  inherited;
end;

procedure TFrameMobileHome.lbStatusesPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
var
  Astatus:Tstatus;
  ATimeBetween:Int64;
  AFromBeginIndex:Integer;
  AFromEndIndex:Integer;
begin
  Astatus:=Tstatus(Item.Data);

  Self.lblNick.Caption:=Astatus.user.screen_name;
  Self.lblText.Caption:=Astatus.Text;

  Self.lblFrom.Caption:='';
  AFromBeginIndex:=Pos('>',Astatus.source);
  if AFromBeginIndex>0 then
  begin
    AFromEndIndex:=Pos('<',Astatus.source,AFromBeginIndex+1);
    if AFromEndIndex>0 then
    begin
      Self.lblFrom.Caption:='来自'+Copy(Astatus.source,AFromBeginIndex+1,AFromEndIndex-AFromBeginIndex-1);
    end;
  end;



  Self.btnreposts_count.Caption:=IntToStr(Astatus.reposts_count);
  Self.btncomments_count.Caption:=IntToStr(Astatus.comments_count);
  Self.btnattitudes_count.Caption:=IntToStr(Astatus.attitudes_count);



  ATimeBetween:=(DateUtils.SecondsBetween(WeiBoRfc822ToDateTime(Astatus.created_at),Now));
  if ATimeBetween<60 then
  begin
    //小于一分钟
    Self.lblTime.Caption:='刚刚';
  end
  else
  begin
    ATimeBetween:=(DateUtils.MinutesBetween(WeiBoRfc822ToDateTime(Astatus.created_at),Now));
    if ATimeBetween<60 then
    begin
      //大于一分钟,小于一小时
      Self.lblTime.Caption:=IntToStr(ATimeBetween)+'分钟前';
    end
    else
    begin
      ATimeBetween:=(DateUtils.HoursBetween(WeiBoRfc822ToDateTime(Astatus.created_at),Now));
      if ATimeBetween<24 then
      begin
        //大于一小时,小于一天
        Self.lblTime.Caption:=IntToStr(ATimeBetween)+'小时前';
      end
      else
      begin
        ATimeBetween:=(DateUtils.DaysBetween(WeiBoRfc822ToDateTime(Astatus.created_at),Now));

        //大于一天
        Self.lblTime.Caption:=IntToStr(ATimeBetween)+'天前';

      end;
    end;
  end;


end;

procedure TFrameMobileHome.lbStatusesResize(Sender: TObject);
begin
  Self.btnreposts_count.Width:=(Width-4) / 3;
  Self.btncomments_count.Width:=(Width-4) / 3+2;
  Self.btnattitudes_count.Width:=(Width-4) / 3+2;

  Self.btnreposts_count.Left:=0;
  Self.imgDevide1.Left:=btnreposts_count.Left+btnreposts_count.WidthInt;

  Self.btncomments_count.Left:=btnreposts_count.Left+btnreposts_count.WidthInt+2;
  Self.imgDevide2.Left:=btncomments_count.Left+btncomments_count.WidthInt;

  Self.btnattitudes_count.Left:=btncomments_count.Left+btncomments_count.WidthInt+2;


  Self.plpTop.Left:=(Self.lbStatuses.WidthInt-Self.plpTop.WidthInt) div 2;
  Self.plpBottom.Left:=(Self.lbStatuses.WidthInt-Self.plpBottom.WidthInt) div 2;



end;


procedure TFrameMobileHome.OnAsync_Gethome_timeline_ExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  ListItem:TSkinListBoxItem;
  J: Integer;
  ExistedIndex:Integer;
begin
  Self.lbStatuses.Properties.Items.BeginUpdate;
  try
    //刷新显示
    //只添加或更新增量
    for I := TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses.Count - 1 downto 0 do
    begin
      ExistedIndex:=-1;
      for J := 0 to Self.lbStatuses.Properties.Items.Count-1 do
      begin
        if Tstatus(Self.lbStatuses.Properties.Items[J].Data).id=
          TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses[I].id then
        begin
          //存在
          ExistedIndex:=J;
          Break;
        end;
      end;
      if ExistedIndex=-1 then
      begin
        //插入
        ListItem:=Self.lbStatuses.Properties.Items.Insert(0);
      end
      else
      begin
        //更新
        ListItem:=Self.lbStatuses.Properties.Items[ExistedIndex];
        Tstatus(Self.lbStatuses.Properties.Items[ExistedIndex].Data).Free;
      end;
      ListItem.Data:=TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses[I];
    end;

    //释放返回
    TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses.Clear(False);
    FreeAndNil(GlobalManager.Gethome_timeline_APIResponse);
  finally
    Self.lbStatuses.Properties.Items.EndUpdate;

    Self.plpTop.Properties.StopLoad;
  end;

end;

procedure TFrameMobileHome.OnAsync_Getusers_show_ExecuteEnd(ATimerTask: TObject);
begin
  Self.btnMyInfo.Caption:=GlobalManager.Current_user.screen_name;
end;

procedure TFrameMobileHome.plpBottomExecuteLoad(Sender: TObject);
var
  ALast_status:Tstatus;
begin
  //加载更多
  //开始加载更多
  if Self.lbStatuses.Properties.Items.Count>0 then
  begin

    ALast_status:=Tstatus(Self.lbStatuses.Properties.Items[Self.lbStatuses.Properties.Items.Count-1].Data);
    GlobalManager.Async_Gethome_timeline('1','',ALast_status.idstr,OnAload_Gethome_timeline_ExecuteEnd);

    Self.imgLoad.Properties.Rotated:=True;
  end
  else
  begin
    //刷新
    GlobalManager.Async_Gethome_timeline('1','','',OnAsync_Gethome_timeline_ExecuteEnd);
  end;
end;

procedure TFrameMobileHome.plpTopExecuteLoad(Sender: TObject);
begin
  //下拉更新
  //开始刷新
  GlobalManager.Async_Gethome_timeline('1','','',OnAsync_Gethome_timeline_ExecuteEnd);

end;

procedure TFrameMobileHome.lbFunctionClickItem(Sender: TSkinItem);
begin
  popScan.IsOpen:=False;
end;

procedure TFrameMobileHome.lbMenuClickItem(Sender: TSkinItem);
begin
  Self.popGroup.IsOpen:=False;
  //加载(切换)
  Self.plpTop.Properties.StartLoad;
end;

procedure TFrameMobileHome.OnAload_Gethome_timeline_ExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  ListItem:TSkinListBoxItem;
  J: Integer;
  ExistedIndex:Integer;
begin
  Self.lbStatuses.Properties.Items.BeginUpdate;
  try
    //加载显示
    //只添加或更新增量
    for I := 0 to TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses.Count - 1 do
    begin
      ExistedIndex:=-1;
      for J := 0 to Self.lbStatuses.Properties.Items.Count-1 do
      begin
        if Tstatus(Self.lbStatuses.Properties.Items[J].Data).id=
          TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses[I].id then
        begin
          //存在
          ExistedIndex:=J;
          Break;
        end;
      end;
      if ExistedIndex=-1 then
      begin
        //插入
        ListItem:=Self.lbStatuses.Properties.Items.Add;
      end
      else
      begin
        //更新
        ListItem:=Self.lbStatuses.Properties.Items[ExistedIndex];
        Tstatus(Self.lbStatuses.Properties.Items[ExistedIndex].Data).Free;
      end;
      ListItem.Data:=TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses[I];
    end;


    //释放返回
    TAPIResponse_statuses_home_timeline(GlobalManager.Gethome_timeline_APIResponse).statuses.Clear(False);
    FreeAndNil(GlobalManager.Gethome_timeline_APIResponse);

  finally
    Self.lbStatuses.Properties.Items.EndUpdate;

    Self.plpBottom.Properties.StopLoad;
  end;


end;


end.
