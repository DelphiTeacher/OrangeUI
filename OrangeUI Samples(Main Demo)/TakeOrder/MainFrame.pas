//convert pas to utf8 by ¥
unit MainFrame;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  Math,
  uBaseLog,
  uTimerTask,
  XSuperObject,
  XSuperJson,
  uManager,
  uBaseHttpControl,
  uInterfaceClass,
  uDataSetToJson,

  HomeFrame,
  MyFrame,
//  UserListFrame,
  NoticeClassifyListFrame,
  GoodsInfoFrame,
  HotelListFrame,
  BuyGoodsListFrame,
  UserCartFrame,
  OrderListFrame,
  HintFrame,
  OrderInfoFrame,
  MessageBoxFrame,
  EasyServiceCommonMaterialDataMoudle,
  AuditInfoFrame,

  uUIFunction,
  uFuncCommon,
  uSkinListBoxType,
  WaitingFrame,
  SystemNotificationInfoFrame,


  uSkinFireMonkeyPageControl, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel, uDrawPicture, uSkinImageList,
  System.Notification, uSkinFireMonkeyButton, uSkinFireMonkeyNotifyNumberIcon,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  uSkinFireMonkeyPanel, uSkinPanelType, uSkinPageControlType, uSkinButtonType,
  uSkinNotifyNumberIconType;

type
  TFrameMain = class(TFrame)
    pcMain: TSkinFMXPageControl;
    tsHome: TSkinFMXTabSheet;
    tsOrder: TSkinFMXTabSheet;
    tsMy: TSkinFMXTabSheet;
    tsUserCart: TSkinFMXTabSheet;
    nniUserCartNumber: TSkinFMXNotifyNumberIcon;
    pnlCancelOrderMessageBoxContent: TSkinFMXPanel;
    pnlCancelReason: TSkinFMXPanel;
    memCancelReason: TSkinFMXMemo;
    tmrGetMyInfo: TTimer;
    procedure pcMainChange(Sender: TObject);
    procedure tmrGetMyInfoTimer(Sender: TObject);
  public
    { Private declarations }



    //酒店经理//
    //首页
    FHomeFrame:TFrameHome;
    //酒店管理页面
    FHotelListFrame:TFrameHotelList;
    //订单页面
    FOrderListFrame:TFrameOrderList;
    //用户购物车页面
    FUserCartFrame:TFrameUserCart;





    //我的页面
    FMyFrame:TFrameMy;

  private
    //获取用户接口
    //刷新用户的审核状态
    procedure DoGetMyInfoExecute(ATimerTask:TObject);
    procedure DoGetMyInfoExecuteEnd(ATimerTask:TObject);

    //是否需要认证
    procedure OnModalResultFromSelfFrame(Frame:TObject);

  public
    //更新商品购物车列表
    procedure GetUserCartGoodsList;
    //更新购物车商品列表到界面
    procedure SyncUserCartGoodsListToUI;
    //获取购物车商品列表
    procedure DoGetUserCartGoodsListExecute(ATimerTask:TObject);
    procedure DoGetUserCartGoodsListExecuteEnd(ATimerTask:TObject);

  public
    //获取未读通知数
    procedure GetUserNoticeUnReadCount;
    procedure DoGetUserNoticeUnReadCountExecute(ATimerTask:TObject);
    procedure DoGetUserNoticeUnReadCountExecuteEnd(ATimerTask:TObject);

  public

    FAddGoodsFID:Integer;
    FAddGoodsNumber:Integer;

    //购物车添加商品
    procedure AddGoodsToCart(AGoodsFID:Integer;AGoodsNumber:Integer);

    procedure DoAddUserCartGoodsExecute(ATimerTask:TObject);
    procedure DoAddUserCartGoodsExecuteEnd(ATimerTask:TObject);


    ///////////////////////////////////////////////
  public
    //操作订单
    procedure DoOrderOper(AOperType:String;AOrder:TOrder);

  private
    FNeedBuyTwiceOrderFID:Integer;

    //再次购买
    //获取订单接口
    procedure DoGetOrderForBuyTwiceExecute(ATimerTask:TObject);
    procedure DoGetOrderForBuyTwiceExecuteEnd(ATimerTask:TObject);

  private
    FNeedPayManager:Integer;
    FNeedOrderFID:Integer;

    //获取订单佣金收款人的银行信息
    procedure DoGetAccepterBankMassageExecute(ATimerTask:TObject);
    procedure DoGetAccepterBankMassageExecuteEnd(ATimerTask:TObject);

  private
    FNeedHideOrderFID:Integer;
    //隐藏订单对话框返回
    procedure OnHideOrderMessageBoxModalResult(Sender: TObject);

    procedure DoHideOrderExecute(ATimerTask:TObject);
    procedure DoHideOrderExecuteEnd(ATimerTask:TObject);
  private
    FNeedCancelOrderFID:Integer;
    FNeedCancelReason:String;
    //取消订单对话框返回
    procedure OnCancelOrderMessageBoxModalResult(Sender: TObject);

    procedure DoCancelOrderExecute(ATimerTask:TObject);
    procedure DoCancelOrderExecuteEnd(ATimerTask:TObject);
  private
    FNeedReceiveOrderFID:Integer;
    //订单确认收货对话框返回
    procedure OnReceiveOrderMessageBoxModalResult(Sender: TObject);

    procedure DoReceiveOrderExecute(ATimerTask:TObject);
    procedure DoReceiveOrderExecuteEnd(ATimerTask:TObject);

  private
    //获取订单接口
    procedure DoGetNoticeOrderExecute(ATimerTask:TObject);
    procedure DoGetNoticeOrderExecuteEnd(ATimerTask:TObject);


    //////////////////////////////////////////////
  public
    //通知详情
    FNoticeFID:Integer;
    FOrder:TOrder;
    FHotel:THotel;
    FNotice:TNotice;
    FNoticeClassify:TNoticeClassify;


    //获取通知详情
    procedure GetAllNoticeInfo(ANotice:TNotice);

    procedure DoGetNoticeExecute(ATimerTask:TObject);
    procedure DoGetNoticeExecuteEnd(ATimerTask:TObject);

  private
    procedure SyncOrderListFrame;
    //从审核订单页面返回
    procedure DoReturnFrameFromAuditOrderFrame(Frame:TFrame);
    //从编辑订单页面返回
    procedure DoReturnFrameFromTakeOrderFrame(Frame:TFrame);
    //从订单付款页面返回
    procedure DoReturnFrameFromPayOrderFrame(Frame:TFrame);
    //从订单发货页面返回
    procedure DoReturnFrameFromDeliveryOrderFrame(Frame:TFrame);
    //从订单佣金支付页面返回
    procedure OnReturnFromPaymentCommissionFrame(Frame:TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //登陆初始
    procedure Login;
    //退出
    procedure Logout;
    //刷新我的信息
    procedure SyncMyInfo;
  public
    //显示订单页面(从付款页面返回)
    procedure ShowOrderFrame;
    //根据不同通知跳转详情界面
    procedure GetNoticeInfo(Frame:TFrame;ANotice:TNotice);
    { Public declarations }
  end;



var
  GlobalMainFrame:TFrameMain;
  //订单是否修改过
  GlobalIsOrderInfoChanged:Boolean;


//把商品加载到ListBoxItem里面
procedure LoadGoodsToListBoxItem(AGoods:TGoods;AListBoxItem:TSkinListBoxItem);

implementation

{$R *.fmx}

uses
  MainForm,
  TakeOrderFrame,
  NoticeListFrame,
//  FillUserInfoFrame,
//  LookCertificationInfoFrame,
//  BuyGoodsListFrame,
//  OrderDeliveryInfoFrame,
  PayOrderFrame;


procedure LoadGoodsToListBoxItem(AGoods:TGoods;AListBoxItem:TSkinListBoxItem);
var
  AFloat:String;
begin
  AListBoxItem.Data:=AGoods;
  AListBoxItem.Caption:=AGoods.name;

  //99.38
  //99
  AListBoxItem.Detail:=IntToStr(Floor(AGoods.price));
  //0.38
  AFloat:=Format('%.2f',[  Ceil(AGoods.price*100) mod 100 / 100 ]);
  AListBoxItem.Detail1:=Copy(AFloat,2,3);
  //单位
  AListBoxItem.Detail2:=AGoods.goods_unit;

  //规格
  AListBoxItem.Detail3:=AGoods.marque;


  //自动下载
  AListBoxItem.Icon.Url:=AGoods.GetPic1Url;

end;

procedure TFrameMain.AddGoodsToCart(AGoodsFID, AGoodsNumber: Integer);
begin
  //添加商品到购物车
  FAddGoodsFID:=AGoodsFID;
  FAddGoodsNumber:=AGoodsNumber;
  GetGlobalTimerThread.RunTempTask(
                          Self.DoAddUserCartGoodsExecute,
                          Self.DoAddUserCartGoodsExecuteEnd
                          );
end;

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;

  FOrder:=TOrder.Create;

  FHotel:=THotel.Create;

  FNoticeClassify:=TNoticeClassify.Create;


  Self.pnlCancelOrderMessageBoxContent.Visible:=False;

end;

destructor TFrameMain.Destroy;
begin
  FreeAndNil(FOrder);

  FreeAndNil(FHotel);

  FreeAndNil(FNoticeClassify);
  inherited;
end;

procedure TFrameMain.DoAddUserCartGoodsExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('add_goods_to_cart',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'goods_fid',
                                                      'number'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FAddGoodsFID,
                                                      FAddGoodsNumber
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

procedure TFrameMain.DoAddUserCartGoodsExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserCartGoods:TUserCartGoods;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //购物车商品添加成功
        AUserCartGoods:=TUserCartGoods.Create;
        AUserCartGoods.ParseFromJson(ASuperObject.O['Data'].A['UserCartGoods'].O[0]);
        GlobalManager.UserCartGoodsList.Add(AUserCartGoods);


        Self.SyncUserCartGoodsListToUI;


      end
      else
      begin
        //购物车商品添加失败
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
  end;

end;
procedure TFrameMain.DoGetNoticeExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user_notice',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'notice_fid'
                                                      ],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNoticeFID
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

procedure TFrameMain.DoGetNoticeExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
//        FNotice.ParseFromJson(ASuperObject.O['Data'].A['Notice'].O[0]);

        if FNotice.is_readed=1 then
        begin
          FNoticeClassify.notice_classify_unread_count:=FNoticeClassify.notice_classify_unread_count;
        end
        else
        begin
          //未读设置为已读
          FNoticeClassify.notice_classify_unread_count:=FNoticeClassify.notice_classify_unread_count-1;

          //返回需要刷新
          GlobalIsNoticeListChanged:=True;
        end;


        FNotice.ParseFromJson(ASuperObject.O['Data'].A['Notice'].O[0]);
        ASuperObject:=TSuperObject.Create(FNotice.custom_data_json);

        //订单消息
        if FNotice.notice_classify='order' then
        begin
          if ASuperObject.Contains('order_fid') then
          begin
              //是订单消息
              FOrder.fid:=ASuperObject.I['order_fid'];

              //订单详情
              uTimerTask.GetGlobalTimerThread.RunTempTask(
                                                          DoGetNoticeOrderExecute,
                                                          DoGetNoticeOrderExecuteEnd);
          end;
        end
        //其他消息
        else if FNotice.notice_classify='other' then
        begin
          //酒店审核结果    FNotice.notice_sub_type='hotel_audit_result'
          //挂钩信息、实名认证等
          //有要用的属性就先借用了
          FHotel.audit_user_name:=ASuperObject.S['audit_user_name'];
          FHotel.audit_state:=ASuperObject.I['audit_state'];
          FHotel.audit_remark:=ASuperObject.S['audit_remark'];
          FHotel.audit_time:=FNotice.createtime;

          //隐藏
          HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

          //审核意见
          ShowFrame(TFrame(GlobalAuditInfoFrame),TFrameAuditInfo,frmMain,nil,nil,nil,Application);
          GlobalAuditInfoFrame.Clear;
          GlobalAuditInfoFrame.LoadHotel(FHotel);
//          GlobalAuditInfoFrame.FrameHistroy:=CurrentFrameHistroy;

        end
        else
        begin

          //隐藏
          HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
          //详情界面
          ShowFrame(TFrame(GlobalSystemNotificationInfoFrame),TFrameSystemNotificationInfo,frmMain,nil,nil,nil,Application);
//          GlobalSystemNotificationInfoFrame.FrameHistroy:=CurrentFrameHistroy;
          //系统通知
          if FNotice.notice_classify='system' then
          begin
            GlobalSystemNotificationInfoFrame.Load('公告详情',FNotice);
          end
          //站内信
          else if FNotice.notice_classify='mail' then
          begin
            GlobalSystemNotificationInfoFrame.Load('消息详情',FNotice);
          end;
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
  end;

end;

procedure TFrameMain.DoGetUserCartGoodsListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_goods_list_to_cart',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key
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

procedure TFrameMain.DoGetUserCartGoodsListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //购物车商品列表获取成功
          GlobalManager.UserCartGoodsList.Clear(True);
          GlobalManager.UserCartGoodsList.ParseFromJsonArray(TUserCartGoods,ASuperObject.O['Data'].A['UserCartGoodsList']);

          //同步购物车商品列表到界面
          SyncUserCartGoodsListToUI;

      end
      else
      begin
        //购物车商品列表获取失败
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
    if Self.FUserCartFrame<>nil then
    begin
      FUserCartFrame.lbUserCartGoodsList.Prop.StopPullDownRefresh();
    end;
  end;

end;



procedure TFrameMain.DoGetUserNoticeUnReadCountExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user_notice_unread_count',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key
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

procedure TFrameMain.DoGetUserNoticeUnReadCountExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //获取未读通知数
        GlobalManager.User.notice_unread_count:=ASuperObject.O['Data'].I['notice_unread_count'];
        if FOrderListFrame<>nil then
        begin
          FOrderListFrame.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
        end;
        if FHomeFrame<>nil then
        begin
          FHomeFrame.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
        end;
//        if FEmpHomeFrame<>nil then
//        begin
//          FEmpHomeFrame.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
//        end;


      end
      else
      begin
        //调用失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally

  end;

end;

procedure TFrameMain.GetUserNoticeUnReadCount;
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                             DoGetUserNoticeUnReadCountExecute,
                             DoGetUserNoticeUnReadCountExecuteEnd);
end;

procedure TFrameMain.Login;
begin
  Self.nniUserCartNumber.Prop.Number:=0;

  //获取未读通知数
  GetUserNoticeUnReadCount;



  //根据角色,设置不同的主页
  if (GlobalManager.User.is_hotel_manager=1)
    and (GlobalManager.User.is_emp=0) then
  begin
    if GlobalManager.User.cert_audit_state=0 then
    begin
      ShowMessageBoxFrame(Self,'您还未进行实名认证,是否去认证?','',TMsgDlgType.mtInformation,['暂时不去','去认证'],OnModalResultFromSelfFrame);
    end;

    //仅酒店经理
    tsHome.Prop.TabVisible:=True;
//      tsBuyGoods.Prop.TabVisible:=False;
//    tsHotel.Prop.TabVisible:=False;
    tsOrder.Prop.TabVisible:=True;
    tsUserCart.Prop.TabVisible:=True;

//    tsEmpHome.Prop.TabVisible:=False;
//    tsGoods.Prop.TabVisible:=False;
//    tsUser.Prop.TabVisible:=False;
//      tsNotice.Prop.TabVisible:=False;
    tsMy.Prop.TabVisible:=True;

    //显示首页
    Self.pcMain.Prop.ActivePage:=tsHome;
    Self.pcMainChange(Self.pcMain);
  end
  else
  begin
    //仅员工
    tsHome.Prop.TabVisible:=False;
//      tsBuyGoods.Prop.TabVisible:=False;//可以代下单
//    tsHotel.Prop.TabVisible:=True;
    tsOrder.Prop.TabVisible:=True;
    tsUserCart.Prop.TabVisible:=False;//可以代下单

//    tsEmpHome.Prop.TabVisible:=True;
//    tsGoods.Prop.TabVisible:=True;
//    tsUser.Prop.TabVisible:=True;
//      tsNotice.Prop.TabVisible:=False;
    tsMy.Prop.TabVisible:=True;


    //显示首页
    Self.pcMain.Prop.ActivePage:=tsHome;//tsEmpHome;
    Self.pcMainChange(Self.pcMain);


  end;




  //获取购物车商品列表
  Self.GetUserCartGoodsList;


  tmrGetMyInfo.Enabled:=True;
end;

procedure TFrameMain.Logout;
begin
  tmrGetMyInfo.Enabled:=False;
end;

procedure TFrameMain.pcMainChange(Sender: TObject);
var
  IsFirstCreate:Boolean;
begin

  //酒店经理
  if Self.pcMain.Prop.ActivePage=tsHome then
  begin
    IsFirstCreate:=FHomeFrame=nil;
    ShowFrame(TFrame(FHomeFrame),TFrameHome,Self.tsHome,nil,nil,nil,Self,False,True,ufsefNone);
    if IsFirstCreate then FHomeFrame.Load;
  end;

//  if Self.pcMain.Prop.ActivePage=tsBuyGoods then
//  begin
//    IsFirstCreate:=FBuyGoodsListFrame=nil;
//    ShowFrame(TFrame(FBuyGoodsListFrame),TFrameBuyGoodsList,Self.tsBuyGoods,nil,nil,nil,Self,False,True,ufsefNone);
//    if IsFirstCreate then FBuyGoodsListFrame.Load('',False);
//  end;

//  if Self.pcMain.Prop.ActivePage=tsHotel then
//  begin
//    IsFirstCreate:=FHotelListFrame=nil;
//    ShowFrame(TFrame(FHotelListFrame),TFrameHotelList,Self.tsHotel,nil,nil,nil,Self,False,True,ufsefNone);
//    if IsFirstCreate then
//    begin
//      if GlobalManager.User.is_emp=0 then
//      begin
//        //酒店经理管理自己的酒店
//        FHotelListFrame.Load('酒店管理',
//                              futManage,
//                              IntToStr(GlobalManager.User.fid),
//                              '',
//                              0,
//                              False,
//                              '',
//                              0);
//      end
//      else
//      begin
//        //员工管理所有的酒店
//        FHotelListFrame.Load('酒店管理',
//                              futManage,
//                              '',
//                              '',
//                              0,
//                              False,
//                              '',
//                              0);
//      end;
//    end;
//  end;

  if Self.pcMain.Prop.ActivePage=tsOrder then
  begin
    IsFirstCreate:=FOrderListFrame=nil;
    ShowFrame(TFrame(FOrderListFrame),TFrameOrderList,Self.tsOrder,nil,nil,nil,Self,False,True,ufsefNone);
    if IsFirstCreate then
    begin
      if GlobalManager.User.is_emp=0 then
      begin
        //酒店经理查看自己的酒店列表
        FOrderListFrame.Load('订单管理',
                              futManage,
                              IntToStr(GlobalManager.User.fid),
                              '');
      end
      else
      begin
        //员工管理所有的订单列表
        FOrderListFrame.Load('订单管理',
                              futManage,
                              '',
                              '');
      end;
    end;
  end;

  if Self.pcMain.Prop.ActivePage=tsUserCart then
  begin
    IsFirstCreate:=FUserCartFrame=nil;
    ShowFrame(TFrame(FUserCartFrame),TFrameUserCart,Self.tsUserCart,nil,nil,nil,Self,False,True,ufsefNone);
    if IsFirstCreate then FUserCartFrame.Load(False);
    if Not IsFirstCreate  then  FUserCartFrame.Load(False);


  end;



//  //员工权限//
//  if Self.pcMain.Prop.ActivePage=tsEmpHome then
//  begin
//    IsFirstCreate:=FEmpHomeFrame=nil;
//    ShowFrame(TFrame(FEmpHomeFrame),TFrameEmpHome,Self.tsEmpHome,nil,nil,nil,Self,False,True,ufsefNone);
//    if IsFirstCreate then FEmpHomeFrame.Load;
//  end;
//
//  //商品管理
//  if Self.pcMain.Prop.ActivePage=tsGoods then
//  begin
//    IsFirstCreate:=FGoodsListFrame=nil;
//    ShowFrame(TFrame(FGoodsListFrame),TFrameGoodsList,Self.tsGoods,nil,nil,nil,Self,False,True,ufsefNone);
//    if IsFirstCreate then FGoodsListFrame.Load('',futManage,False);
//  end;
//
//  //用户管理
//  if Self.pcMain.Prop.ActivePage=tsUser then
//  begin
//    IsFirstCreate:=FUserListFrame=nil;
//    ShowFrame(TFrame(FUserListFrame),TFrameUserList,Self.tsUser,nil,nil,nil,Self,False,True,ufsefNone);
//
//    //员工登录
//    if GlobalManager.User.is_emp=1 then
//    begin
//      //管理员登录
//      if GlobalManager.User.is_admin=1 then
//      begin
//        if IsFirstCreate then FUserListFrame.Load('',
//                                                  '',
//                                                  futManage,
//                                                  '',
//                                                  //可以看员工和酒店经理
//                                                  '',
//                                                  '',
//                                                  1,
//                                                  0,
//                                                  False
//                                                  );
//
//      end
//      else
//      begin
//        if IsFirstCreate then FUserListFrame.Load('',
//                                                  '',
//                                                  futManage,
//                                                  '',
//                                                  //只能看酒店经理
//                                                  '1',
//                                                  '',
//                                                  0,
//                                                  0,
//                                                  False
//                                                  );
//      end;
//    end;
//
//  end;



//  if Self.pcMain.Prop.ActivePage=tsNotice then
//  begin
//    IsFirstCreate:=FNoticeClassifyListFrame=nil;
//    ShowFrame(TFrame(FNoticeClassifyListFrame),TFrameNoticeClassifyList,Self.tsNotice,nil,nil,nil,Self,False,True,ufsefNone);
//    if IsFirstCreate then FNoticeClassifyListFrame.Load;
//  end;

  if Self.pcMain.Prop.ActivePage=tsMy then
  begin
    IsFirstCreate:=FMyFrame=nil;
    ShowFrame(TFrame(FMyFrame),TFrameMy,Self.tsMy,nil,nil,nil,Self,False,True,ufsefNone);
    if IsFirstCreate then FMyFrame.Load;
  end;

end;


procedure TFrameMain.GetAllNoticeInfo(ANotice: TNotice);
begin
  FNoticeFID:=ANotice.fid;
  FNotice:=ANotice;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetNoticeExecute,
                                              DoGetNoticeExecuteEnd);
end;



procedure TFrameMain.GetNoticeInfo(Frame:TFrame;ANotice: TNotice);
begin

  ShowWaitingFrame(Frame,'加载中...');
  FNoticeFID:=ANotice.fid;
  FNotice:=ANotice;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetNoticeExecute,
                                              DoGetNoticeExecuteEnd);
end;

procedure TFrameMain.DoGetAccepterBankMassageExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_commission_accepter_account_info',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'order_fid',
                                                      'Is_pay_manager'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNeedOrderFID,
                                                      FNeedPayManager
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

procedure TFrameMain.DoGetAccepterBankMassageExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AMessageObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        AMessageObject:=ASuperObject.O['Data'].A['AccepterBankMessage'].O[0];


//        //隐藏
//        HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//
//        //支付经理佣金
//        ShowFrame(TFrame(GlobalPayCommissionFrame),TFramePayCommission,frmMain,nil,nil,OnReturnFromPaymentCommissionFrame,Application);
//        GlobalPayCommissionFrame.FrameHistroy:=CurrentFrameHistroy;
//        GlobalPayCommissionFrame.Clear;
//        GlobalPayCommissionFrame.Load(GetJsonDoubleValue(AMessageObject,'commission'),
//                                      AMessageObject.S['bill_code'],
//                                      AMessageObject.S['name'],
//                                      AMessageObject.S['bank_account'],
//                                      AMessageObject.S['bank_name'],
//                                      AMessageObject.I['is_manager'],
//                                      AMessageObject.I['order_fid']
//                                       );
//        GlobalIsOrderInfoChanged:=True;
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
  end;
end;



procedure TFrameMain.GetUserCartGoodsList;
begin
  //获取购物车商品列表
  GetGlobalTimerThread.RunTempTask(
          Self.DoGetUserCartGoodsListExecute,
          Self.DoGetUserCartGoodsListExecuteEnd
          );
end;

procedure TFrameMain.ShowOrderFrame;
begin
  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //显示主界面
  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application);
//  GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;

  //刷新订单页面
  GlobalMainFrame.pcMain.Prop.ActivePage:=GlobalMainFrame.tsOrder;
  GlobalMainFrame.FOrderListFrame.lbOrderList.Prop.StartPullDownRefresh;

  //刷新购物车列表
  GlobalMainFrame.GetUserCartGoodsList;
  //刷新未读通知数
  GlobalMainFrame.GetUserNoticeUnReadCount;

end;

procedure TFrameMain.SyncMyInfo;
begin
  tmrGetMyInfoTimer(Self);
end;

procedure TFrameMain.SyncOrderListFrame;
begin
  if (CurrentFrame=GlobalMainFrame) and (FOrderListFrame<>nil) then
  begin
    GlobalIsOrderInfoChanged:=False;
    //如果已经在订单列表页面,只需要刷新
    FOrderListFrame.lbOrderList.Prop.StartPullDownRefresh;
  end
//  else
//  //如果在订单发货详情页面确认收货,那么刷新
//  if (CurrentFrame=GlobalOrderDeliveryInfoFrame) and (GlobalOrderDeliveryInfoFrame<>nil) then
//  begin
//    GlobalIsOrderInfoChanged:=True;//返回订单列表页面还需要刷新
//    //刷新
//    GlobalOrderDeliveryInfoFrame.SyncOrder;
//  end
  else
  //如果在订单详情页面,那么刷新
  if (CurrentFrame=GlobalOrderInfoFrame) and (GlobalOrderInfoFrame<>nil) then
  begin
    GlobalIsOrderInfoChanged:=True;//返回订单列表页面还需要刷新
    //刷新
    GlobalOrderInfoFrame.Sync;
  end
  else
  begin
    GlobalIsOrderInfoChanged:=True;
  end;

end;

procedure TFrameMain.SyncUserCartGoodsListToUI;
begin

  //更新到界面上
  if Self.FUserCartFrame<>nil then
  begin
    //重新初始购物车列表
    //直接清空,加载
    FUserCartFrame.InitUserCartGoodsListToUI;
  end;


  //更新主页面购物车的商品数量
  nniUserCartNumber.Prop.Number:=GlobalManager.UserCartGoodsList.Count;

  //更新购物商品列表页面的购物车的商品数量
  if GlobalBuyGoodsListFrame<>nil then
  begin
    GlobalBuyGoodsListFrame.btnUserCart.Prop.Number:=GlobalManager.UserCartGoodsList.Count;
  end;

  //更新商品详情页的购物车商品数量
  if GlobalGoodsInfoFrame<>nil then
  begin
    GlobalGoodsInfoFrame.nniNumber.Prop.Number:=GlobalManager.UserCartGoodsList.Count;
  end;


  //判断商品是否已经加入到购物车
  if (CurrentFrame=GlobalGoodsInfoFrame) and (GlobalGoodsInfoFrame<>nil) then
  begin
    GlobalGoodsInfoFrame.CheckIsExistedInCart;
  end;


end;

procedure TFrameMain.tmrGetMyInfoTimer(Sender: TObject);
begin

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                               DoGetMyInfoExecute,
                               DoGetMyInfoExecuteEnd);

end;

procedure TFrameMain.DoOrderOper(AOperType:String;AOrder:TOrder);
begin

  if AOperType='取消订单' then
  begin
    FNeedCancelOrderFID:=AOrder.fid;
    Self.memCancelReason.Text:='';
    ShowMessageBoxFrame(frmMain,
                        '',
                        '',
                        TMsgDlgType.mtCustom,
                        ['确定','取消'],
                        OnCancelOrderMessageBoxModalResult,
                        Self.pnlCancelOrderMessageBoxContent,
                        '取消订单');

  end;

  if AOperType='去付款' then
  begin

    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

    //支付
    ShowFrame(TFrame(GlobalPayOrderFrame),TFramePayOrder,frmMain,nil,nil,DoReturnFrameFromPayOrderFrame,Application);
//    GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalPayOrderFrame.Load(AOrder,False);

  end;

  if AOperType='确认收货' then
  begin
    FNeedReceiveOrderFID:=AOrder.fid;
    ShowMessageBoxFrame(frmMain,
                        '您是否收到该订单商品?',
                        '',
                        TMsgDlgType.mtCustom,
                        ['已收货','未收货'],
                        OnReceiveOrderMessageBoxModalResult,
                        nil,
                        '确认收货');

  end;

  if AOperType='再次购买' then
  begin
      FNeedBuyTwiceOrderFID:=AOrder.fid;

      //刷新
      ShowWaitingFrame(frmMain,'加载中...');
      //下拉刷新
      uTimerTask.GetGlobalTimerThread.RunTempTask(
                                   DoGetOrderForBuyTwiceExecute,
                                   DoGetOrderForBuyTwiceExecuteEnd);


  end;

  if AOperType='删除订单' then
  begin
    FNeedHideOrderFID:=AOrder.fid;
    ShowMessageBoxFrame(frmMain,
                        '是否删除订单?',
                        '',
                        TMsgDlgType.mtCustom,
                        ['确定','取消'],
                        OnHideOrderMessageBoxModalResult,
                        nil,
                        '删除订单');

  end;


  //员工可以操作
  if AOperType='修改订单' then
  begin

    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

    //确认下单
    ShowFrame(TFrame(GlobalTakeOrderFrame),TFrameTakeOrder,frmMain,nil,nil,DoReturnFrameFromTakeOrderFrame,Application);
//    GlobalTakeOrderFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalTakeOrderFrame.Clear;
    GlobalTakeOrderFrame.EditOrder(AOrder);

  end;

//  //员工可以操作
//  if AOperType='审核' then
//  begin
//    //隐藏
//    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//
//    //审核意见
//    ShowFrame(TFrame(GlobalAuditFrame),TFrameAudit,frmMain,nil,nil,DoReturnFrameFromAuditOrderFrame,Application);
//    GlobalAuditFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalAuditFrame.Load('审核订单','audit_order','audit',AOrder.fid);
//
//  end;

//  //员工可以操作
//  if AOperType='发货' then
//  begin
//    //隐藏
//    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//
//    //发货
//    ShowFrame(TFrame(GlobalDeliveryOrderFrame),TFrameDeliveryOrder,frmMain,nil,nil,DoReturnFrameFromDeliveryOrderFrame,Application);
//    GlobalDeliveryOrderFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalDeliveryOrderFrame.Load(AOrder);
//
//  end;

  //员工可以操作
  if AOperType='查看订单' then
  begin
    //订单详情
    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

    //订单详情
    ShowFrame(TFrame(GlobalOrderInfoFrame),TFrameOrderInfo,frmMain,nil,nil,nil,Application);
//    GlobalOrderInfoFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalOrderInfoFrame.Clear;
    GlobalOrderInfoFrame.Load(AOrder);
    GlobalOrderInfoFrame.Sync;
  end;

  //员工可以操作
  if AOperType='支付经理' then
  begin

    FNeedPayManager:=1;
    FNeedOrderFID:=AOrder.fid;

    ShowWaitingFrame(Self,'加载中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                           DoGetAccepterBankMassageExecute,
                           DoGetAccepterBankMassageExecuteEnd);

  end;

  //员工可以操作
  if AOperType='支付介绍人' then
  begin

    FNeedPayManager:=0;
    FNeedOrderFID:=AOrder.fid;

    ShowWaitingFrame(Self,'加载中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                           DoGetAccepterBankMassageExecute,
                           DoGetAccepterBankMassageExecuteEnd);
  end;



end;

procedure TFrameMain.DoReceiveOrderExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                SimpleCallAPI('receive_order',
                              AHttpControl,
                              InterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'order_fid'],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              FNeedReceiveOrderFID
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

procedure TFrameMain.DoReceiveOrderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
      if TTimerTask(ATimerTask).TaskTag=0 then
      begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        if ASuperObject.I['Code']=200 then
        begin

            //确认收货成功,返回需要刷新
            GlobalIsOrderInfoChanged:=True;

            //确认收货成功
            ShowHintFrame(frmMain,'确认收货成功!');

            //如果在订单页面,那么刷新
            SyncOrderListFrame;





            //刷新未读通知数
            GlobalMainFrame.GetUserNoticeUnReadCount;

        end
        else
        begin
          //确认收货失败
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
  end;

end;

procedure TFrameMain.DoCancelOrderExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                SimpleCallAPI('cancel_order',
                              AHttpControl,
                              InterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'order_fid',
                              'cancel_reason'],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              FNeedCancelOrderFID,
                              FNeedCancelReason
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

procedure TFrameMain.DoCancelOrderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
      if TTimerTask(ATimerTask).TaskTag=0 then
      begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        if ASuperObject.I['Code']=200 then
        begin

            //取消订单成功,返回需要刷新
            GlobalIsOrderInfoChanged:=True;

            //取消订单成功
            ShowHintFrame(frmMain,'取消订单成功!');

            //如果在订单页面,那么刷新
            SyncOrderListFrame;

        end
        else
        begin
          //取消订单失败
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
  end;
end;

procedure TFrameMain.DoHideOrderExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                SimpleCallAPI('hide_order',
                              AHttpControl,
                              InterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'order_fid'],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              FNeedHideOrderFID
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

procedure TFrameMain.DoHideOrderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
      if TTimerTask(ATimerTask).TaskTag=0 then
      begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        if ASuperObject.I['Code']=200 then
        begin

            //删除订单成功,返回需要刷新
            GlobalIsOrderInfoChanged:=True;

            //隐藏订单成功
            ShowHintFrame(frmMain,'删除订单成功!');

            //如果在订单页面,那么刷新
            SyncOrderListFrame;

            //如果在订单详情页面,那么返回
            if (CurrentFrame=GlobalOrderInfoFrame) and (GlobalOrderInfoFrame<>nil) then
            begin
              GlobalOrderInfoFrame.btnReturnClick(Self);
            end;

        end
        else
        begin
          //删除订单失败
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
  end;

end;

procedure TFrameMain.DoGetNoticeOrderExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                            SimpleCallAPI('get_order',
                            AHttpControl,
                            InterfaceUrl,
                            [
                            'appid',
                            'user_fid',
                            'key',
                            'order_fid'
                            ],
                            [AppID,
                            GlobalManager.User.fid,
                            GlobalManager.User.key,
                            FOrder.fid
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

procedure TFrameMain.DoGetNoticeOrderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

            //刷新订单信息
            FOrder.ParseFromJson(ASuperObject.O['Data'].A['Order'].O[0]);

            //订单详情
            //隐藏
            HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

            //订单详情
            ShowFrame(TFrame(GlobalOrderInfoFrame),TFrameOrderInfo,frmMain,nil,nil,nil,Application);
//            GlobalOrderInfoFrame.FrameHistroy:=CurrentFrameHistroy;
            GlobalOrderInfoFrame.Clear;
            GlobalOrderInfoFrame.Load(FOrder);
            GlobalOrderInfoFrame.Sync;

            FNotice.is_readed:=1;

      end
      else
      begin
        //获取订单失败
        ShowMessageBoxFrame(frmMain,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
        FNotice.is_readed:=0;
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(frmMain,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;


procedure TFrameMain.DoGetOrderForBuyTwiceExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                            SimpleCallAPI('get_order',
                            AHttpControl,
                            InterfaceUrl,
                            [
                            'appid',
                            'user_fid',
                            'key',
                            'order_fid'
                            ],
                            [AppID,
                            GlobalManager.User.fid,
                            GlobalManager.User.key,
                            FNeedBuyTwiceOrderFID
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

procedure TFrameMain.DoGetOrderForBuyTwiceExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AOrder:TOrder;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

            //刷新订单信息
            FOrder.ParseFromJson(ASuperObject.O['Data'].A['Order'].O[0]);

            //再次购买

            //隐藏
            HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

            //确认下单
            ShowFrame(TFrame(GlobalTakeOrderFrame),TFrameTakeOrder,frmMain,nil,nil,nil,Application);
//            GlobalTakeOrderFrame.FrameHistroy:=CurrentFrameHistroy;

            GlobalTakeOrderFrame.Clear;
            //这里面要取的是商品的价格,而不是上次购买的价格
            GlobalTakeOrderFrame.LoadBuyGoodsList(FOrder.OrderGoodsList);
            GlobalTakeOrderFrame.AddOrder;

      end
      else
      begin
        //获取订单失败
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
  end;
end;



procedure TFrameMain.OnCancelOrderMessageBoxModalResult(Sender: TObject);
begin
  if TFrameMessageBox(Sender).ModalResult='确定' then
  begin
    FNeedCancelReason:=Self.memCancelReason.Text;
    ShowWaitingFrame(frmMain,'处理中...');
    GetGlobalTimerThread.RunTempTask(DoCancelOrderExecute,
                                    DoCancelOrderExecuteEnd);
  end;
end;


procedure TFrameMain.OnHideOrderMessageBoxModalResult(Sender: TObject);
begin
  if TFrameMessageBox(Sender).ModalResult='确定' then
  begin
    ShowWaitingFrame(frmMain,'处理中...');
    GetGlobalTimerThread.RunTempTask(DoHideOrderExecute,
                                    DoHideOrderExecuteEnd);
  end;
end;


procedure TFrameMain.OnModalResultFromSelfFrame(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='暂时不用' then
  begin
    //留在本页面
  end;
//  if TFrameMessageBox(Frame).ModalResult='去认证' then
//  begin
//
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//    //显示实名认证界面
//    ShowFrame(TFrame(GlobalFillUserInfoFrame),TFrameFillUserInfo,frmMain,nil,nil,nil,Application);
//    GlobalFillUserInfoFrame.Clear;
//    GlobalFillUserInfoFrame.FPageIndex:=2;
//
//  end;
end;


procedure TFrameMain.OnReceiveOrderMessageBoxModalResult(Sender: TObject);
begin
  if (TFrameMessageBox(Sender).ModalResult='确定')
    or (TFrameMessageBox(Sender).ModalResult='已收货') then
  begin
    ShowWaitingFrame(frmMain,'处理中...');
    GetGlobalTimerThread.RunTempTask(DoReceiveOrderExecute,
                                    DoReceiveOrderExecuteEnd);
  end;
end;

procedure TFrameMain.OnReturnFromPaymentCommissionFrame(Frame: TFrame);
begin
  //从订单佣金页面返回
  if GlobalIsOrderInfoChanged then
  begin
    GlobalIsOrderInfoChanged:=False;

    //如果在订单页面,那么刷新
    SyncOrderListFrame;
  end;
end;

procedure TFrameMain.DoReturnFrameFromAuditOrderFrame(Frame: TFrame);
begin
//  //从审核页面返回
//  if GlobalIsAuditChanged then
//  begin
//    GlobalIsAuditChanged:=False;
//
//    SyncOrderListFrame;
//
//  end;
end;

procedure TFrameMain.DoReturnFrameFromDeliveryOrderFrame(Frame: TFrame);
begin
//  //从订单发货页面返回
//  if GlobalIsDeliveryOrderChanged then
//  begin
//    GlobalIsDeliveryOrderChanged:=False;
//
//    //如果在订单页面,那么刷新
//    SyncOrderListFrame;
//
//  end;
end;

procedure TFrameMain.DoReturnFrameFromPayOrderFrame(Frame: TFrame);
begin
  //从订单付款页面返回
  if GlobalIsOrderInfoChanged then
  begin
    GlobalIsOrderInfoChanged:=False;

    //如果在订单页面,那么刷新
    SyncOrderListFrame;
  end;
end;

procedure TFrameMain.DoReturnFrameFromTakeOrderFrame(Frame: TFrame);
begin
  //从编辑订单页面返回
  if GlobalIsOrderInfoChanged then
  begin
    GlobalIsOrderInfoChanged:=False;

    //如果在订单页面,那么刷新
    SyncOrderListFrame;
  end;
end;



procedure TFrameMain.DoGetMyInfoExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_my_info',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    [
                                                    'appid',
                                                    'user_fid',
                                                    'key'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key
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

procedure TFrameMain.DoGetMyInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //获取用户信息成功

          //刷新用户信息
          GlobalManager.User.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);

          if FMyFrame<>nil then
          begin
            FMyFrame.Load();
          end;

      end
      else
      begin
        //注册失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
//    HideWaitingFrame;
  end;
end;

end.
