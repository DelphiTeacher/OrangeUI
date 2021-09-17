//convert pas to utf8 by ¥

unit HomeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uBaseHttpControl,
  uBaseList,
  uBaseLog,
  uTimerTask,
  uManager,
  uUIFunction,
  uSkinItems,
  XSuperObject,
  uDrawCanvas,
  uInterfaceClass,
  uEasyServiceCommon,

  uSkinListBoxType,
  uSkinControlGestureManager,
  EasyServiceCommonMaterialDataMoudle,


  WaitingFrame,
  MessageBoxFrame,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinImageList,
  uSkinFireMonkeyButton, uSkinButtonType, uSkinFireMonkeyImageListViewer,
  uDrawPicture, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uSkinMaterial, uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyNotifyNumberIcon,
  uSkinPanelType, uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinNotifyNumberIconType, uSkinImageListViewerType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType;

type
  TFrameHome = class(TFrame)
    lbHome: TSkinFMXListBox;
    idpImageListViewer: TSkinFMXItemDesignerPanel;
    imgPlayer: TSkinFMXImageListViewer;
    imglistPlayer: TSkinImageList;
    bgIndicator: TSkinFMXButtonGroup;
    pnlToolBar: TSkinFMXPanel;
    idpCommonButton: TSkinFMXItemDesignerPanel;
    btnItemButton2: TSkinFMXButton;
    btnItemButton3: TSkinFMXButton;
    btnItemButton4: TSkinFMXButton;
    btnItemButton1: TSkinFMXButton;
    idpDefault: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail_2: TSkinFMXMultiColorLabel;
    btnAddGoodsToCart: TSkinFMXButton;
    lblItemDetail3Hint: TSkinFMXLabel;
    lblItemDetail3: TSkinFMXLabel;
    idpType: TSkinFMXItemDesignerPanel;
    lblTypeName: TSkinFMXLabel;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblOrder: TSkinFMXLabel;
    lblOrderTime: TSkinFMXLabel;
    lblOrderInfo: TSkinFMXLabel;
    btnSearchGoodsHistory: TSkinFMXButton;
    btnScanBarCode: TSkinFMXButton;
    lblExistedInGoodsCart: TSkinFMXLabel;
    nniItemButton3: TSkinFMXNotifyNumberIcon;
    nniItemButton4: TSkinFMXNotifyNumberIcon;
    nniNumber: TSkinFMXNotifyNumberIcon;
    procedure lbHomeClickItem(Sender: TSkinItem);
    procedure lbHomeResize(Sender: TObject);
    procedure btnItemButton1Click(Sender: TObject);
    procedure btnUserCartClick(Sender: TObject);
    procedure imgPlayerResize(Sender: TObject);
    procedure lbHomePullDownRefresh(Sender: TObject);
    procedure lbHomePullUpLoadMore(Sender: TObject);
    procedure imgPlayerClick(Sender: TObject);
    procedure btnSearchGoodsHistoryClick(Sender: TObject);
    procedure btnAddGoodsToCartClick(Sender: TObject);
    procedure lbHomePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure nniNumberClick(Sender: TObject);
    procedure btnScanBarCodeClick(Sender: TObject);
  private
    FPageIndex:Integer;

    //最近通知列表
    FNoticeList:TNoticeList;
    //最新新品推荐列表
    FGoodsList:TGoodsList;
    //广告图片
    FHomeAdList:THomeAdList;

    //获取用户首页
    procedure DoGetUserHomePageExecute(ATimerTask:TObject);
    procedure DoGetUserHomePageExecuteEnd(ATimerTask:TObject);
  private
    //处理手势冲突
    procedure DoListBoxVertManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);

  private
    //按钮操作
    procedure DoItemOper(AOperType:String);
    //从通知分类页面返回
    procedure OnReturnFrameFromNoticeClassifyListFrame(Frame:TFrame);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load;
    { Public declarations }
  end;




implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame,
  HotelListFrame,
  UserCartFrame,
  GoodsInfoFrame,
  WebBrowserFrame,
  OrderListFrame,
  NoticeClassifyListFrame,
  SearchHistoryFrame,
  BuyGoodsListFrame;

{ TFrameHome }

procedure TFrameHome.btnAddGoodsToCartClick(Sender: TObject);
var
  AAddGoodsFID:Integer;
begin
  //添加商品到购物车

  if Self.lbHome.Prop.InteractiveItem<>nil then
  begin

    AAddGoodsFID:=TGoods(Self.lbHome.Prop.InteractiveItem.Data).fid;
    //购物车中没有此商品
    if GlobalManager.UserCartGoodsList.FindItemByFID(AAddGoodsFID)=nil then
    begin
      ShowWaitingFrame(Self,'处理中...');
      GlobalMainFrame.AddGoodsToCart(AAddGoodsFID,1);
    end;
  end;

end;

procedure TFrameHome.btnItemButton1Click(Sender: TObject);
begin
  DoItemOper(TSkinFMXButton(Sender).Caption);
end;

procedure TFrameHome.btnScanBarCodeClick(Sender: TObject);
begin
  //扫描二维码
  frmMain.ScanBarCode;
end;

procedure TFrameHome.btnSearchGoodsHistoryClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  //显示搜索历史搜索
  ShowFrame(TFrame(GlobalSearchHistoryFrame),TFrameSearchHistory,frmMain,nil,nil,nil,Application);
//  GlobalSearchHistoryFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalSearchHistoryFrame.Load(Self.btnSearchGoodsHistory.Prop.HelpText,
                                'BuyGoodsAtHomeFrame',
                                GlobalManager.BuyGoodsSearchHistoryList
                                );
end;

procedure TFrameHome.btnUserCartClick(Sender: TObject);
begin
  DoItemOper('购物车');
end;

constructor TFrameHome.Create(AOwner: TComponent);
begin
  inherited;

  //分类标识颜色
  Self.idpType.Material.BackColor.FillColor.Color:=SkinThemeColor;


  FGoodsList:=TGoodsList.Create;
  FHomeAdList:=THomeAdList.Create;
  FNoticeList:=TNoticeList.Create;



  Self.nniNumber.Prop.Number:=0;

  Self.nniItemButton3.Prop.Number:=0;
  Self.nniItemButton4.Prop.Number:=0;


  Self.imglistPlayer.PictureList.Clear(True);


  Self.lbHome.Prop.Items.ClearItemsByType(sitItem1);
  Self.lbHome.Prop.Items.ClearItemsByType(sitDefault);


  //先隐藏分类
  //能获取到相应的数据再显示出来,避免一个空的分类显示在页面上
  if Self.lbHome.Prop.Items.FindItemByCaption('最近通知')<>nil then
  begin
    Self.lbHome.Prop.Items.FindItemByCaption('最近通知').Visible:=False;
  end;
  if Self.lbHome.Prop.Items.FindItemByCaption('新品推荐')<>nil then
  begin
    Self.lbHome.Prop.Items.FindItemByCaption('新品推荐').Visible:=False;
  end;



  //处理手势冲突
  Self.lbHome.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.lbHome.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
    Self.DoListBoxVertManagerPrepareDecidedFirstGestureKind;
end;

procedure TFrameHome.DoItemOper(AOperType: String);
var
  AFilterManFID:String;
  AFilterOrderState:String;
begin
  if Pos('补货',AOperType)>0 then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    //补货
    ShowFrame(TFrame(GlobalBuyGoodsListFrame),TFrameBuyGoodsList,frmMain,nil,nil,nil,Application);
//    GlobalBuyGoodsListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalBuyGoodsListFrame.Load('',True);

  end;
  if Pos('酒店',AOperType)>0 then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    //酒店管理
    ShowFrame(TFrame(GlobalMainFrame.FHotelListFrame),TFrameHotelList,frmMain,nil,nil,nil,Application);
//    GlobalMainFrame.FHotelListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalMainFrame.FHotelListFrame.Load('酒店管理',
                                          futManage,
                                          IntToStr(GlobalManager.User.fid),
                                          '',
                                          0,
                                          True,
                                          '',
                                          0);

  end;
  if AOperType='购物车' then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    //购物车
    ShowFrame(TFrame(GlobalMainFrame.FUserCartFrame),TFrameUserCart,frmMain,nil,nil,nil,Application);
//    GlobalMainFrame.FUserCartFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalMainFrame.FUserCartFrame.Load(True);

  end;
  if (AOperType='待付款')
    or (AOperType='待审核')
    or (AOperType='待发货')
    or (AOperType='待收货')
    or (AOperType='待付款订单')
    or (AOperType='待审核订单')
    or (AOperType='待发货订单')
    or (AOperType='待收货订单') then
  begin
      //订单列表
      ShowFrame(TFrame(GlobalMainFrame.FOrderListFrame),TFrameOrderList,GlobalMainFrame.tsOrder,nil,nil,nil,GlobalMainFrame,False,True,ufsefNone);
      GlobalMainFrame.pcMain.Prop.ActivePage:=GlobalMainFrame.tsOrder;

      if Pos('待付款',AOperType)>0 then AFilterOrderState:=Const_OrderState_WaitPay;
      if Pos('待审核',AOperType)>0 then AFilterOrderState:=Const_OrderState_WaitAudit;
      if Pos('待发货',AOperType)>0 then AFilterOrderState:=Const_OrderState_WaitDelivery;
      if Pos('待收货',AOperType)>0 then AFilterOrderState:=Const_OrderState_WaitReceive;

      if GlobalManager.User.is_emp=1 then
      begin
        //是员工
        //管理所有人的订单
        AFilterManFID:='';
      end
      else
      begin
        //是酒店经理
        //只看自己的订单
        AFilterManFID:=IntToStr(GlobalManager.User.fid);
      end;

      GlobalMainFrame.FOrderListFrame.Load('订单列表',
                                          futManage,
                                          AFilterManFID,
                                          AFilterOrderState);

  end;
end;

procedure TFrameHome.DoListBoxVertManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  AFirstItemRect:TRectF;
begin
  //广告轮播Item的绘制区域
  AFirstItemRect:=Self.lbHome.Prop.Items[0].ItemDrawRect;
  if PtInRect(AFirstItemRect,PointF(AMouseMoveX,AMouseMoveY)) then
  begin
      //在广告轮播控件内,那么要检查初始手势方向
  end
  else
  begin
      //不在在广告轮播控件内,那么随意滑动
      AIsDecidedFirstGestureKind:=True;
      ADecidedFirstGestureKind:=TGestureKind.gmkVertical;
  end;

end;

destructor TFrameHome.Destroy;
begin
  FreeAndNil(FGoodsList);
  FreeAndNil(FHomeAdList);
  FreeAndNil(FNoticeList);
  inherited;
end;

procedure TFrameHome.DoGetUserHomePageExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                  SimpleCallAPI('get_user_home_page',
                                AHttpControl,
                                InterfaceUrl,
                                ['appid',
                                'user_fid',
                                'key',
                                'pageindex',
                                'pagesize'],
                                [AppID,
                                GlobalManager.User.fid,
                                GlobalManager.User.key,
                                FPageIndex,
                                20
                                ]
                                );
      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;

    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;
end;

procedure TFrameHome.DoGetUserHomePageExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  ADrawPicture:TDrawPicture;
  AGoodsList:TGoodsList;
  ANoticeTypeItemIndex:Integer;
  AGoodsTypeItemIndex:Integer;
  AListBoxItem:TSkinListBoxItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


        if FPageIndex=1 then
        begin


            Self.nniItemButton3.Prop.Number:=ASuperObject.O['Data'].I['wait_pay_order_count'];
            Self.nniItemButton4.Prop.Number:=ASuperObject.O['Data'].I['wait_receive_order_count'];


            //加载首页五张广告图片
            Self.imglistPlayer.PictureList.Clear(True);
            Self.FHomeAdList.Clear(True);
            FHomeAdList.ParseFromJsonArray(THomeAd,ASuperObject.O['Data'].A['HomeAdList']);

            for I := 0 to FHomeAdList.Count-1 do
            begin
              ADrawPicture:=Self.imglistPlayer.PictureList.Add;
              ADrawPicture.Url:=FHomeAdList[I].GetPicUrl;
              //立即下载
              ADrawPicture.WebUrlPicture;
              ADrawPicture.Data:=FHomeAdList[I];
            end;

            //显示第一页
            if Self.imglistPlayer.PictureList.Count>0 then
            begin
              Self.imgPlayer.Prop.Picture.ImageIndex:=0;
            end
            else
            begin
              Self.imgPlayer.Prop.Picture.ImageIndex:=-1;
            end;

            //排列按钮分组的位置
            Self.imgPlayerResize(imgPlayer);


            //清除最近通知
            Self.FNoticeList.Clear(True);
            FNoticeList.ParseFromJsonArray(TNotice,ASuperObject.O['Data'].A['RecentNoticeList']);

            //清除商品列表
            FGoodsList.Clear(True);

        end;



        //加载新品推荐的商品列表
        AGoodsList:=TGoodsList.Create(ooReference);

        AGoodsList.ParseFromJsonArray(TGoods,ASuperObject.O['Data'].A['RecommendGoodsList']);


        Self.lbHome.Prop.Items.BeginUpdate;
        try

          if FPageIndex=1 then
          begin

              //清除最近通知
              Self.lbHome.Prop.Items.ClearItemsByType(sitItem1);
              //清除新品推荐
              Self.lbHome.Prop.Items.ClearItemsByType(sitDefault);


              //添加最近通知
              ANoticeTypeItemIndex:=-1;
              if Self.lbHome.Prop.Items.FindItemByCaption('最近通知')<>nil then
              begin
                ANoticeTypeItemIndex:=Self.lbHome.Prop.Items.FindItemByCaption('最近通知').Index;
              end;
              for I := 0 to FNoticeList.Count-1 do
              begin
                AListBoxItem:=Self.lbHome.Prop.Items.Insert(ANoticeTypeItemIndex+1);
                AListBoxItem.ItemType:=sitItem1;
                AListBoxItem.Data:=FNoticeList[I];
                AListBoxItem.Caption:=FNoticeList[I].caption;
                AListBoxItem.Detail:=FNoticeList[I].createtime;
                AListBoxItem.Detail1:=FNoticeList[I].content;

                Inc(ANoticeTypeItemIndex);
              end;


              if Self.lbHome.Prop.Items.FindItemByCaption('最近通知')<>nil then
              begin
                Self.lbHome.Prop.Items.FindItemByCaption('最近通知').Visible:=(FNoticeList.Count>0);
              end;
              if Self.lbHome.Prop.Items.FindItemByCaption('新品推荐')<>nil then
              begin
                Self.lbHome.Prop.Items.FindItemByCaption('新品推荐').Visible:=(AGoodsList.Count>0);
              end;


          end;



          //添加新品推荐
          AGoodsTypeItemIndex:=-1;
          if Self.lbHome.Prop.Items.FindItemByCaption('新品推荐')<>nil then
          begin
            AGoodsTypeItemIndex:=Self.lbHome.Prop.Items.FindItemByCaption('新品推荐').Index;
          end;
          for I := 0 to AGoodsList.Count-1 do
          begin

            FGoodsList.Add(AGoodsList[I]);

            AListBoxItem:=Self.lbHome.Prop.Items.Insert(AGoodsTypeItemIndex+1);
            AListBoxItem.ItemType:=sitDefault;
            MainFrame.LoadGoodsToListBoxItem(AGoodsList[I],AListBoxItem);

            Inc(AGoodsTypeItemIndex);
          end;

        finally
          Self.lbHome.Prop.Items.EndUpdate();
          FreeAndNil(AGoodsList);
        end;

      end
      else
      begin
        //获取失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;

    if FPageIndex>1 then
    begin
        if ASuperObject.O['Data'].A['GoodsList'].Length>0 then
        begin
          Self.lbHome.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.lbHome.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
        Self.lbHome.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;
end;

procedure TFrameHome.imgPlayerClick(Sender: TObject);
var
  AHomeAd:THomeAd;
begin
  //广告图片
  if (Self.imglistPlayer.PictureList.Count>0)
    and (Self.imgPlayer.Prop.Picture.ImageIndex>=0) then
  begin
    AHomeAd:=Self.FHomeAdList[Self.imgPlayer.Prop.Picture.ImageIndex];

    if AHomeAd.url<>'' then
    begin
        HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

        //网页链接

        //显示网页界面
        ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser,frmMain,nil,nil,nil,Application);
//        GlobalWebBrowserFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalWebBrowserFrame.LoadUrl(AHomeAd.url);

    end
    else if AHomeAd.goods_fid>0 then
    begin
        HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

        //图片FID
        //显示商品信息界面
        ShowFrame(TFrame(GlobalGoodsInfoFrame),TFrameGoodsInfo,frmMain,nil,nil,nil,Application);
//        GlobalGoodsInfoFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalGoodsInfoFrame.Clear;
        GlobalGoodsInfoFrame.Load(AHomeAd.goods_fid);

    end
    else if AHomeAd.content<>'' then
    begin
        HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

        //网页源码

        //显示网页界面
        ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser,frmMain,nil,nil,nil,Application);
//        GlobalWebBrowserFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalWebBrowserFrame.LoadBodyHtml(AHomeAd.content,
                                IntToStr(GlobalManager.User.fid)+'_'+IntToStr(AHomeAd.fid)+'.html');
    end;

  end;
end;

procedure TFrameHome.imgPlayerResize(Sender: TObject);
begin
  //设置按钮分组的位置
  Self.bgIndicator.Position.X:=Self.imgPlayer.Width
                                -Self.imglistPlayer.Count*bgIndicator.Height-20;
  Self.bgIndicator.Position.Y:=Self.imgPlayer.Height-20;

end;

procedure TFrameHome.lbHomeClickItem(Sender: TSkinItem);
var
  AGoods:TGoods;
  ANotice:TNotice;
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    AGoods:=TGoods(Sender.Data);
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //显示商品信息界面
    ShowFrame(TFrame(GlobalGoodsInfoFrame),TFrameGoodsInfo,frmMain,nil,nil,nil,Application);
//    GlobalGoodsInfoFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalGoodsInfoFrame.Load(AGoods);

  end;
  if TSkinItem(Sender).ItemType=sitItem1 then
  begin
    ANotice:=TNotice(Sender.Data);

    GlobalMainFrame.GetNoticeInfo(Self,ANotice);


//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //显示通知详情界面
//    ShowFrame(TFrame(GlobalGoodsInfoFrame),TFrameGoodsInfo,frmMain,nil,nil,nil,Application);
//    GlobalGoodsInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalGoodsInfoFrame.Load(AGoods);

  end;
end;

procedure TFrameHome.lbHomePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AGoods:TGoods;
  AIsExistedInGoodsCart:Boolean;
  ANotice:TNotice;
begin
  if AItem.ItemType=sitDefault then
  begin
    AGoods:=TGoods(AItem.Data);
    AIsExistedInGoodsCart:=(GlobalManager.UserCartGoodsList.FindItemByFID(AGoods.fid)<>nil);
    lblExistedInGoodsCart.Visible:=AIsExistedInGoodsCart;
    Self.btnAddGoodsToCart.Visible:=Not AIsExistedInGoodsCart;
  end;
  if AItem.ItemType=sitItem1 then
  begin
    ANotice:=TNotice(AItem.Data);
    if ANotice.is_readed=1 then
    begin
      Self.lblOrder.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
    end
    else
    begin
      Self.lblOrder.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
    end;

  end;
end;

procedure TFrameHome.lbHomePullDownRefresh(Sender: TObject);
begin
  //下拉刷新
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                    DoGetUserHomePageExecute,
                                    DoGetUserHomePageExecuteEnd);

end;

procedure TFrameHome.lbHomePullUpLoadMore(Sender: TObject);
begin
  //上拉加载更多
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                    DoGetUserHomePageExecute,
                                    DoGetUserHomePageExecuteEnd);

end;

procedure TFrameHome.lbHomeResize(Sender: TObject);
begin
  //广告图片轮播保持一个5:2的比例
  Self.lbHome.Prop.Items[0].Height:=
    Self.lbHome.Width/5*2;


  //四个按钮
  Self.btnItemButton1.Width:=Width/4;
  Self.btnItemButton2.Width:=Width/4;
  Self.btnItemButton3.Width:=Width/4;
  Self.btnItemButton4.Width:=Width/4;

  Self.nniItemButton3.Left:=Self.btnItemButton3.Width/2-10;
  Self.nniItemButton4.Left:=Self.btnItemButton4.Width/2-10;

end;

procedure TFrameHome.Load;
begin
  Self.lbHome.Prop.StartPullDownRefresh;
end;

procedure TFrameHome.nniNumberClick(Sender: TObject);
begin
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  //消息通知列表
  ShowFrame(TFrame(GlobalNoticeClassifyListFrame),TFrameNoticeClassifyList,frmMain,nil,nil,OnReturnFrameFromNoticeClassifyListFrame,Application);
//  GlobalNoticeClassifyListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalNoticeClassifyListFrame.Load;

end;

procedure TFrameHome.OnReturnFrameFromNoticeClassifyListFrame(Frame: TFrame);
begin
  Self.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
end;

//procedure TFrameHome.AddGoodsToCart(AGoodsFID, AGoodsNumber: Integer);
//begin
//  ShowWaitingFrame(Self,'处理中...');
//  FAddGoodsFID:=AGoodsFID;
//  FAddGoodsNumber:=AGoodsNumber;
//  GetGlobalTimerThread.RunTempTask(
//                          Self.DoAddUserCartGoodsExecute,
//                          Self.DoAddUserCartGoodsExecuteEnd
//                          );
//end;
//
//procedure TFrameHome.DoAddUserCartGoodsExecute(ATimerTask: TObject);
//var
//  AHttpControl:THttpControl;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  AHttpControl:=TSystemHttpControl.Create;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('add_goods_to_cart',
//                                                      AHttpControl,
//                                                      InterfaceUrl,
//                                                      ['appid',
//                                                      'user_fid',
//                                                      'key',
//                                                      'goods_fid',
//                                                      'number'],
//                                                      [AppID,
//                                                      GlobalManager.User.fid,
//                                                      GlobalManager.User.key,
//                                                      FAddGoodsFID,
//                                                      FAddGoodsNumber
//                                                      ]
//                                                      );
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
//    except
//      on E:Exception do
//      begin
//        //异常
//        TTimerTask(ATimerTask).TaskDesc:=E.Message;
//      end;
//    end;
//  finally
//    FreeAndNil(AHttpControl);
//  end;
//
//end;
//
//procedure TFrameHome.DoAddUserCartGoodsExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  AUserCartGoods:TUserCartGoods;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//
//        //购物车商品添加成功
//        AUserCartGoods:=TUserCartGoods.Create;
//        AUserCartGoods.ParseFromJson(ASuperObject.O['Data'].A['UserCartGoods'].O[0]);
//        GlobalManager.UserCartGoodsList.Add(AUserCartGoods);
//
//
//        //同步购物车页面
//        GlobalMainFrame.SyncUserCartGoodsListToUI;
//        GlobalMainFrame.GetUserCartGoodsList;
//
//      end
//      else
//      begin
//        //购物车商品添加失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//
//end;

end.

