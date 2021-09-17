//convert pas to utf8 by ¥
unit OrderInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,
  HintFrame,
  WaitingFrame,
  MessageBoxFrame,

  uManager,
  uDrawCanvas,
  uSkinItems,
  uTimerTask,
  uEasyServiceCommon,
  XSuperObject,
  uInterfaceClass,
  uBaseHttpControl,
//  ApplyIntroducerFrame,
  EasyServiceCommonMaterialDataMoudle,
  uMobileUtils,

  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, uSkinFireMonkeyImage,
  uSkinImageType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinButtonType, uBaseSkinControl, uSkinPanelType;

type
  TFrameOrderInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbOrderInfo: TSkinFMXListBox;
    idpDefault: TSkinFMXItemDesignerPanel;
    lblItemName: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    btnReturn: TSkinFMXButton;
    pnlItemOper: TSkinFMXPanel;
    btnItemOper2: TSkinFMXButton;
    btnItemOper1: TSkinFMXButton;
    btnViewDetail: TSkinFMXButton;
    itpItem1: TSkinFMXItemDesignerPanel;
    lblItem1Caption: TSkinFMXLabel;
    lblItem1Detail: TSkinFMXLabel;
    btnViewDetail1: TSkinFMXButton;
    pnlItem1Top: TSkinFMXPanel;
    pnlItem1Top1: TSkinFMXPanel;
    lblItemDetail1: TSkinFMXLabel;
    lblItemDetail2: TSkinFMXLabel;
    pnlItem1Top2: TSkinFMXPanel;
    lblItemDetail3: TSkinFMXLabel;
    lblItemDetail4: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    imgItem1Icon: TSkinFMXImage;
    btnItemOper3: TSkinFMXButton;
    btnItemOper4: TSkinFMXButton;
    btnEdit: TSkinFMXButton;
    btnItemDetail3: TSkinFMXButton;
    btnIsFirstOrder: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure lbOrderInfoClickItem(AItem: TSkinItem);
    procedure btnItemOper1Click(Sender: TObject);
    procedure pnlItemOperResize(Sender: TObject);
    procedure lbOrderInfoPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnItemDetail3Click(Sender: TObject);
  private
    FOrder:TOrder;

    //获取订单接口
    procedure DoGetOrderExecute(ATimerTask:TObject);
    procedure DoGetOrderExecuteEnd(ATimerTask:TObject);

  private
    FUser:TUser;
    procedure DoGetOrderUserInfoExecute(ATimerTask:TObject);
    procedure DoGetOrderUserInfoExecuteEnd(ATimerTask:TObject);

  private
    FHotel:THotel;
    procedure DoGetOrderHotelInfoExecute(ATimerTask:TObject);
    procedure DoGetOrderHotelInfoExecuteEnd(ATimerTask:TObject);

  private
    //按钮个数
    FButtonCount:Integer;
  private
    //编辑订单返回
    procedure OnReturnFrameFromEditOrderFrame(Frame: TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Clear;
    procedure Load(AOrder:TOrder);overload;
    procedure Sync;
    { Public declarations }
  end;


var
  GlobalOrderInfoFrame:TFrameOrderInfo;


implementation

uses
  MainForm,
  MainFrame,
//  AuditFrame,
  TakeOrderFrame,
  OrderGoodsListFrame,
//  CommissionPaymentInfoFrame,
  OrderStateFrame,
//  OrderPayRecordFrame,
//  UserInfoFrame,
//  OrderDeliveryInfoFrame,
  HotelInfoFrame,
  AuditInfoFrame;

{$R *.fmx}

//procedure TFrameOrderInfo.DoDelOrderExecute(ATimerTask: TObject);
//var
//  AHttpControl:THttpControl;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  AHttpControl:=TSystemHttpControl.Create;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('del_user',
//                                                    AHttpControl,
//                                                    InterfaceUrl,
//                                                    [
//                                                    'appid',
//                                                    'emp_fid',
//                                                    'key',
//                                                    'man_fid'
//                                                    ],
//                                                    [AppID,
//                                                    GlobalManager.Order.fid,
//                                                    GlobalManager.Order.key,
//                                                    FOrder.fid
//                                                    ]
//                                                    );
//
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
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
//procedure TFrameOrderInfo.DoDelOrderExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//
//        //删除用户成功
//        HideFrame;//(Self,hfcttBeforeReturnFrame);
//        ReturnFrame;//(Self.FrameHistroy);
//
//
//      end
//      else
//      begin
//        //注册失败
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

destructor TFrameOrderInfo.Destroy;
begin
  FreeAndNil(FUser);
  FreeAndNil(FHotel);
  inherited;
end;

procedure TFrameOrderInfo.DoGetOrderExecute(ATimerTask: TObject);
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

procedure TFrameOrderInfo.DoGetOrderExecuteEnd(ATimerTask: TObject);
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

            Load(FOrder);

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
    Self.lbOrderInfo.Prop.StopPullDownRefresh();
  end;
end;

procedure TFrameOrderInfo.DoGetOrderHotelInfoExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                              SimpleCallAPI('get_hotel',
                              AHttpControl,
                              InterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'hotel_fid'],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              FOrder.hotel_fid
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

procedure TFrameOrderInfo.DoGetOrderHotelInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //获取酒店信息成功
        FHotel.ParseFromJson(ASuperObject.O['Data'].A['Hotel'].O[0]);
        //显示酒店信息
        //隐藏
        HideFrame(Self,hfcttBeforeShowFrame);

        //审核意见
        ShowFrame(TFrame(GlobalHotelInfoFrame),TFrameHotelInfo,frmMain,nil,nil,nil,Application);
        GlobalHotelInfoFrame.Load(FHotel);
//        GlobalHotelInfoFrame.FrameHistroy:=CurrentFrameHistroy;



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

procedure TFrameOrderInfo.DoGetOrderUserInfoExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    [
                                                    'appid',
                                                    'emp_fid',
                                                    'key',
                                                    'man_fid'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FOrder.user_fid
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

procedure TFrameOrderInfo.DoGetOrderUserInfoExecuteEnd(ATimerTask: TObject);
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
        FUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);


        //显示用户信息
        //隐藏
//        HideFrame(Self,hfcttBeforeShowFrame);
//
//        ShowFrame(TFrame(GlobalUserInfoFrame),TFrameUserInfo,frmMain,nil,nil,nil,Application);
//        GlobalUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//
//        GlobalUserInfoFrame.Load(FUser);
//        GlobalUserInfoFrame.Sync;

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

procedure TFrameOrderInfo.lbOrderInfoClickItem(AItem: TSkinItem);
begin


  //查看订单状态
  if AItem.Caption='订单状态' then
  begin
        //隐藏
    HideFrame(Self,hfcttBeforeShowFrame);

    //审核意见
    ShowFrame(TFrame(GlobalOrderStateFrame),TFrameOrderState,frmMain,nil,nil,nil,Application);
    
    GlobalOrderStateFrame.Clear;
    GlobalOrderStateFrame.Load(FOrder);
//    GlobalOrderStateFrame.FrameHistroy:=CurrentFrameHistroy;
  end;


  //查看订单商品清单
  if AItem.Caption='商品清单' then
  begin
      //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);

    //商品清单列表
    ShowFrame(TFrame(GlobalOrderGoodsListFrame),TFrameOrderGoodsList,frmMain,nil,nil,nil,Application);

    GlobalOrderGoodsListFrame.Load(FOrder);
//    GlobalOrderGoodsListFrame.FrameHistroy:=CurrentFrameHistroy;
  end;

  //查看下单经理信息
  if AItem.Caption='下单经理' then
  begin
    ShowWaitingFrame(Self,'加载中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                   DoGetOrderUserInfoExecute,
                                   DoGetOrderUserInfoExecuteEnd);
  end;

  //查看下单酒店信息
  if AItem.Caption='下单酒店' then
  begin
    ShowWaitingFrame(Self,'加载中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                 DoGetOrderHotelInfoExecute,
                                 DoGetOrderHotelInfoExecuteEnd);
  end;

  //查看订单付款记录
  if AItem.Caption='付款记录' then
  begin



//    if FOrder.pay_state=Const_PayState_Payed then
//    begin
//        //隐藏
//      HideFrame(Self,hfcttBeforeShowFrame);
//
//      //审核意见
//      ShowFrame(TFrame(GlobalOrderPayRecordFrame),TFrameOrderPayRecord,frmMain,nil,nil,nil,Application);
//      GlobalOrderPayRecordFrame.Clear;
//      GlobalOrderPayRecordFrame.Load(FOrder);
//      GlobalOrderPayRecordFrame.FrameHistroy:=CurrentFrameHistroy;
//    end;
//    else
//    begin
//      if AItem.Detail='不需要付款' then
//      begin
//        ShowMessageBoxFrame(Self,'您不需要付款，所以没有付款记录!','',TMsgDlgType.mtInformation,['确定'],nil);
//        Exit;
//      end
//      else
//      begin
//        ShowMessageBoxFrame(Self,'您还未付款，所以没有付款记录，请您先去付款!','',TMsgDlgType.mtInformation,['确定'],nil);
//        Exit;
//      end;
//    end;

  end;

  if AItem.Caption='审核记录' then
  begin
//      if (GetAuditStateStr(TAuditState(FOrder.audit_state))='审核通过')
//        or (GetAuditStateStr(TAuditState(FOrder.audit_state))='审核拒绝') then
      if (FOrder.audit_state=Ord(asAuditPass))
        or (FOrder.audit_state=Ord(asAuditReject)) then
      begin
        //隐藏
        HideFrame(Self,hfcttBeforeShowFrame);

        //审核意见
        ShowFrame(TFrame(GlobalAuditInfoFrame),TFrameAuditInfo,frmMain,nil,nil,nil,Application);
        GlobalAuditInfoFrame.Clear;
        GlobalAuditInfoFrame.LoadOrder(FOrder);
//        GlobalAuditInfoFrame.FrameHistroy:=CurrentFrameHistroy;
      end;
  end;

//  //查看订单发货记录
//  if AItem.Caption='发货记录' then
//  begin
//      if (FOrder.order_state=Const_OrderState_WaitReceive)
//        or (FOrder.order_state=Const_OrderState_Done) then
//      begin
////
////        if Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail<>'已完成' then
////        begin
////          ShowMessageBoxFrame(Self,'您暂时没有发货记录!','',TMsgDlgType.mtInformation,['确定'],nil);
////          Exit;
////        end
////        else
////        begin
////          //隐藏
////          HideFrame(Self,hfcttBeforeShowFrame);
////
////          //发货记录
////          ShowFrame(TFrame(GlobalOrderDeliveryInfoFrame),TFrameOrderDelivery,frmMain,nil,nil,nil,Application);
////          GlobalOrderDeliveryInfoFrame.FrameHistroy:=CurrentFrameHistroy;
////
////          GlobalOrderDeliveryInfoFrame.Clear;
////          GlobalOrderDeliveryInfoFrame.Load(FOrder);
////        end;
////      end
////      else
////      begin
//        //隐藏
//        HideFrame(Self,hfcttBeforeShowFrame);
//
//        //发货记录
//        ShowFrame(TFrame(GlobalOrderDeliveryInfoFrame),TFrameOrderDeliveryInfo,frmMain,nil,nil,nil,Application);
//        GlobalOrderDeliveryInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//
//        GlobalOrderDeliveryInfoFrame.Load(FOrder);
//        GlobalOrderDeliveryInfoFrame.Sync;
//      end;
//
//  end;

//  if AItem.Caption='经理佣金' then
//  begin
//    if FOrder.is_pay_manager=1 then
//    begin
//      //隐藏
//      HideFrame(Self,hfcttBeforeShowFrame);
//
//      //审核意见
//      ShowFrame(TFrame(GlobalCommissionPaymentInfoFrame),TFrameCommissionPaymentInfo,frmMain,nil,nil,nil,Application);
//      GlobalCommissionPaymentInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalCommissionPaymentInfoFrame.Clear;
//      GlobalCommissionPaymentInfoFrame.Load('经理佣金支付详情',
//                                            FOrder.fid,
//                                            0);
//    end;
//
//  end;


//  if AItem.Caption='介绍人佣金' then
//  begin
//    if FOrder.is_pay_introducer=1 then
//    begin
//      //隐藏
//      HideFrame(Self,hfcttBeforeShowFrame);
//
//      //审核意见
//      ShowFrame(TFrame(GlobalCommissionPaymentInfoFrame),TFrameCommissionPaymentInfo,frmMain,nil,nil,nil,Application);
//      GlobalCommissionPaymentInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalCommissionPaymentInfoFrame.Clear;
//      GlobalCommissionPaymentInfoFrame.Load('介绍人佣金支付详情',
//                                            FOrder.fid,
//                                            1);
//    end;
//
//  end;



end;

procedure TFrameOrderInfo.lbOrderInfoPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin

  if AItem.Caption='订单状态' then
  begin
    Self.btnItemDetail3.Visible:=True;
    if FOrder.is_first_order=1 then
    begin
      Self.btnIsFirstOrder.Visible:=True;
    end
    else
    begin
      Self.btnIsFirstOrder.Visible:=False;
    end;
  end
  else
  begin
    Self.btnItemDetail3.Visible:=False;
    Self.btnIsFirstOrder.Visible:=False;
  end;
//  //
//  if AItem.Caption='删除用户' then
//  begin
//    Self.lblItemName.Material.DrawCaptionParam.FontColor:=SkinThemeColor;
//  end
//  else
//  begin
//    Self.lblItemName.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
//  end;

end;

procedure TFrameOrderInfo.btnItemDetail3Click(Sender: TObject);
begin
  //复制单号
  MySetClipboard(
              //Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail2
              FOrder.bill_code
              );
  ShowHintFrame(Self,'复制成功!');

end;

procedure TFrameOrderInfo.btnItemOper1Click(Sender: TObject);
begin

  GlobalMainFrame.DoOrderOper(TSkinFMXButton(Sender).Caption,
                              FOrder);

end;

procedure TFrameOrderInfo.btnEditClick(Sender: TObject);
begin
  //隐藏
  HideFrame(Self,hfcttBeforeShowFrame);

  //编辑订单
  ShowFrame(TFrame(GlobalTakeOrderFrame),TFrameTakeOrder,frmMain,nil,nil,OnReturnFrameFromEditOrderFrame,Application);
//  GlobalTakeOrderFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalTakeOrderFrame.Clear;
  GlobalTakeOrderFrame.EditOrder(FOrder);

end;

procedure TFrameOrderInfo.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameOrderInfo.Clear;
begin
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail2:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail4:='';

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('下单酒店').Detail:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('下单经理').Detail:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('商品清单').Detail:='';


  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单金额').Detail:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单金额').Detail2:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('付款记录').Detail:='';

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('审核记录').Detail:='';

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('发货记录').Detail:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('收货人信息').Detail1:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('收货人信息').Detail2:='';
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('收货人信息').Detail4:='';

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('备注').Detail:='';
end;

constructor TFrameOrderInfo.Create(AOwner: TComponent);
begin
  inherited;
  FUser:=TUser.Create;
  FHotel:=THotel.Create;
end;

procedure TFrameOrderInfo.Load(AOrder:TOrder);
begin

  FOrder:=AOrder;

  if AOrder.is_pay_manager=1 then
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('经理佣金').Accessory:=satMore;
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('经理佣金').Detail:='已支付';
  end
  else
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('经理佣金').Accessory:=satNone;
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('经理佣金').Detail:='未支付';
  end;

  if AOrder.pay_state=Const_PayState_Payed then
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('付款记录').Accessory:=satMore;
  end
  else
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('付款记录').Accessory:=satNone;
  end;

  if AOrder.is_pay_introducer=1 then
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Accessory:=satMore;
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Detail:='已支付';
  end
  else
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Accessory:=satNone;
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Detail:='未支付';
  end;


  if GlobalManager.User.is_emp=1 then
  begin
    //员工
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('下单经理').Visible:=True;
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('下单经理').Detail:=AOrder.user_name;
    if AOrder.introducer_commission<>0 then
    begin
      Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Visible:=True;
      Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Detail2:='¥'+Format('%.2f',[AOrder.introducer_commission]);

    end
    else
    begin
      Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Visible:=False;
    end;
  end
  else
  begin
    //酒店经理
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('下单经理').Visible:=False;
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('介绍人佣金').Visible:=False;
  end;



  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail:=GetOrderStateStr(AOrder.order_state);
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail2:=AOrder.bill_code;

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单状态').Detail4:=AOrder.createtime;
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('下单酒店').Detail:=AOrder.hotel_name;
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('商品清单').Detail:=
    '共'+IntToStr(AOrder.goods_kind_num)+'种'+IntToStr(AOrder.goods_num)+'件';;
  if AOrder.manager_commission<>0 then
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('经理佣金').Visible:=True;
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('经理佣金').Detail2:='¥'+Format('%.2f',[AOrder.manager_commission]);

  end
  else
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('经理佣金').Visible:=False;
  end;

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单金额').Detail:='¥'+Format('%.2f',[AOrder.summoney]);
  //商品金额
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('订单金额').Detail2:='¥'+Format('%.2f',[AOrder.goods_summoney]);
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('付款记录').Detail:=GetPayStateStr(AOrder.pay_state);

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('审核记录').Detail:=GetAuditStateStr(TAuditState(FOrder.audit_state));
//  if (GetAuditStateStr(TAuditState(FOrder.audit_state))='待审核')
//    or (GetAuditStateStr(TAuditState(FOrder.audit_state))='未审核') then
  if (FOrder.audit_state=Ord(asRequestAudit))
    or (FOrder.audit_state=Ord(asDefault)) then
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('审核记录').Accessory:=satNone;
  end
  else
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('审核记录').Accessory:=satMore;
  end;


  if (AOrder.order_state=Const_OrderState_Done)
    or (AOrder.order_state=Const_OrderState_WaitReceive) then
  begin
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('发货记录').Detail:='有1条记录';
    Self.lbOrderInfo.Prop.Items.FindItemByCaption('发货记录').Accessory:=satMore;
  end
  else
  begin
//    if AOrder.order_state='wait_receive' then
//    begin
//      Self.lbOrderInfo.Prop.Items.FindItemByCaption('发货记录').Detail:='有1条记录';
//      Self.lbOrderInfo.Prop.Items.FindItemByCaption('发货记录').Accessory:=satMore;
//    end
//    else
//    begin
      Self.lbOrderInfo.Prop.Items.FindItemByCaption('发货记录').Detail:='无';
      Self.lbOrderInfo.Prop.Items.FindItemByCaption('发货记录').Accessory:=satNone;
//    end;
  end;
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('收货人信息').Detail1:=AOrder.recv_name;
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('收货人信息').Detail2:=AOrder.recv_phone;
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('收货人信息').Detail4:=AOrder.recv_addr;

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('备注').Detail:=AOrder.remark;
  Self.lbOrderInfo.Prop.Items.FindItemByCaption('备注').Height:=
                                GetSuitContentHeight(lblItemDetail.Width,
                                            AOrder.remark,
                                            14,
                                            Self.lbOrderInfo.Prop.ItemHeight
                                            );

  Self.lbOrderInfo.Prop.Items.FindItemByCaption('操作日志').Visible:=False;



  Self.lbOrderInfo.VertScrollBar.Prop.Position:=0;



  Self.btnEdit.Visible:=False;


//  //订单状态,要用小写,在url要用到//
//  //待付款                              (待付款)
//  Const_OrderState_WaitPay='wait_pay';
//  //已取消                              (已取消)
//  Const_OrderState_Cancelled='cancelled';
//  //已付款/待审核                     (已付款/待审核)
//  Const_OrderState_WaitAudit='wait_audit';
//  //----忽略    审核通过/待发货       (待发货)
//  Const_OrderState_WaitDelivery='wait_delivery';
//  //被拒绝/审核拒绝/拒绝发货                   (拒绝发货)
//  Const_OrderState_AuditReject='audit_reject';
//  //待收货/审核通过/已发货            (待收货)
//  Const_OrderState_WaitReceive='wait_receive';
//  //已完成                              (已完成)
//  Const_OrderState_Done='done';



      //待付款
      if AOrder.order_state=Const_OrderState_WaitPay then
      begin
          if (GlobalManager.User.is_emp=0) then
          begin
            //酒店经理
            //去付款、取消订单、修改订单
            Self.btnItemOper1.Caption:='去付款';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Caption:='取消订单';
            Self.btnItemOper2.Visible:=True;
            Self.btnItemOper3.Caption:='修改订单';
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end
          else
          begin
            //员工
            //修改订单、取消订单、去付款
            Self.btnItemOper1.Caption:='取消订单';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Caption:='修改订单';
            Self.btnItemOper2.Visible:=False;
//            Self.btnItemOper3.Caption:='去付款';
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end;
      end;
      //已取消
      if AOrder.order_state=Const_OrderState_Cancelled then
      begin
          //再次购买、删除订单
          Self.btnItemOper1.Caption:='再次购买';
          Self.btnItemOper1.Visible:=True;
          Self.btnItemOper2.Caption:='删除订单';
          Self.btnItemOper2.Visible:=True;
          Self.btnItemOper3.Visible:=False;
          Self.btnItemOper4.Visible:=False;
      end;
      //待审核
      if AOrder.order_state=Const_OrderState_WaitAudit then
      begin
          if (GlobalManager.User.is_emp=0) then
          begin
            //酒店经理
            //重新付款、提醒发货、留言
            Self.btnItemOper1.Caption:='再次购买';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;

          end
          else
          begin
            //员工
            //审核、修改订单
            Self.btnItemOper1.Caption:='审核';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Caption:='修改订单';
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end;
      end;
      //待发货
      if AOrder.order_state=Const_OrderState_WaitDelivery then
      begin
          if (GlobalManager.User.is_emp=0) then
          begin
            //酒店经理
            //提醒发货、留言
            Self.btnItemOper1.Caption:='再次购买';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end
          else
          begin
            //员工
            //发货
            Self.btnItemOper1.Caption:='发货';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end;
      end;
      //被拒绝
      if AOrder.order_state=Const_OrderState_AuditReject then
      begin
          if (GlobalManager.User.is_emp=0) then
          begin
            //酒店经理
            //再次购买
            Self.btnItemOper1.Caption:='再次购买';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end
          else
          begin
            //员工
            Self.btnItemOper1.Caption:='查看订单';
            Self.btnItemOper1.Visible:=False;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end;
      end;
      //待收货
      if AOrder.order_state=Const_OrderState_WaitReceive then
      begin
          if (GlobalManager.User.is_emp=0) then
          begin
            //酒店经理
            //确认收货、查看物流、再次购买
            Self.btnItemOper1.Caption:='确认收货';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end
          else
          begin
            //员工
            Self.btnItemOper1.Caption:='查看订单';
            Self.btnItemOper1.Visible:=False;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end;
      end;
      //已完成
      if AOrder.order_state=Const_OrderState_Done then
      begin
          if (GlobalManager.User.is_emp=0) then
          begin
            //酒店经理
            //再次购买、删除订单、退货、评价晒单、
            Self.btnItemOper1.Caption:='再次购买';
            Self.btnItemOper1.Visible:=True;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end
          else
          begin
            //员工
            Self.btnItemOper1.Caption:='查看订单';
            Self.btnItemOper1.Visible:=False;
            Self.btnItemOper2.Visible:=False;
            Self.btnItemOper3.Visible:=False;
            Self.btnItemOper4.Visible:=False;
          end;
      end;


  FButtonCount:=
    Ord(Self.btnItemOper1.Visible)
    +Ord(Self.btnItemOper2.Visible)
    +Ord(Self.btnItemOper3.Visible)
    +Ord(Self.btnItemOper4.Visible);

  Self.pnlItemOper.Visible:=FButtonCount>0;
  pnlItemOperResize(pnlItemOper);





end;

procedure TFrameOrderInfo.OnReturnFrameFromEditOrderFrame(Frame: TFrame);
begin
  Self.Load(FOrder);
end;

procedure TFrameOrderInfo.pnlItemOperResize(Sender: TObject);
begin
  if FButtonCount=0 then
  begin

  end;
  if FButtonCount=1 then
  begin
    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/FButtonCount;
    Self.btnItemOper1.Left:=Width-Self.btnItemOper1.Width-20;
  end;
  if FButtonCount=2 then
  begin
    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/FButtonCount;
    Self.btnItemOper1.Left:=Width-Self.btnItemOper1.Width-20;

    Self.btnItemOper2.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper2.Left:=Self.btnItemOper1.Left-Self.btnItemOper1.Width-20;
  end;
  if FButtonCount=3 then
  begin
    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/FButtonCount;
    Self.btnItemOper1.Left:=Width-Self.btnItemOper1.Width-20;

    Self.btnItemOper2.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper2.Left:=Self.btnItemOper1.Left-Self.btnItemOper1.Width-20;

    Self.btnItemOper3.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper3.Left:=Self.btnItemOper2.Left-Self.btnItemOper2.Width-20;
  end;
  if FButtonCount=4 then
  begin
    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/FButtonCount;
    Self.btnItemOper1.Left:=Width-Self.btnItemOper1.Width-20;

    Self.btnItemOper2.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper2.Left:=Self.btnItemOper1.Left-Self.btnItemOper1.Width-20;

    Self.btnItemOper3.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper3.Left:=Self.btnItemOper2.Left-Self.btnItemOper2.Width-20;

    Self.btnItemOper4.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper4.Left:=Self.btnItemOper3.Left-Self.btnItemOper3.Width-20;
  end;
end;


procedure TFrameOrderInfo.Sync;
begin

  //刷新
  ShowWaitingFrame(Self,'加载中...');
  //下拉刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                               DoGetOrderExecute,
                               DoGetOrderExecuteEnd);


end;

end.
