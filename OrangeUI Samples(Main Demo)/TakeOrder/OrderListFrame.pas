//convert pas to utf8 by ¥
unit OrderListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uDrawCanvas,

  uFuncCommon,
  uManager,
  uBaseList,
  uSkinItems,
  uSkinListBoxType,
  uEasyServiceCommon,

  EasyServiceCommonMaterialDataMoudle,
  MessageBoxFrame,
  WaitingFrame,
  HintFrame,

  uUIFunction,
  uTimerTask,
  uSkinBufferBitmap,
  XSuperObject,
  uInterfaceClass,
  uBaseHttpControl,

  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyLabel, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage,
  uSkinFireMonkeyPullLoadPanel, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinMaterial, uSkinLabelType, uSkinFireMonkeyCustomList,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  uSkinFireMonkeyNotifyNumberIcon, uSkinButtonType, uSkinNotifyNumberIconType,
  uDrawPicture, uSkinImageList, uSkinImageType, uSkinPanelType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType;



type
  TFrameOrderList = class(TFrame)
    ItemOrder: TSkinFMXItemDesignerPanel;
    lblItemOrderHotelName: TSkinFMXLabel;
    lblItemOrderState: TSkinFMXLabel;
    lblItemOrderDate: TSkinFMXLabel;
    lbOrderList: TSkinFMXListBox;
    pnlItemDevide: TSkinFMXPanel;
    btnItemOper2: TSkinFMXButton;
    btnItemOper1: TSkinFMXButton;
    pnlToolBar: TSkinFMXPanel;
    lbOrderState: TSkinFMXListBox;
    lblItemGoodsNum: TSkinFMXLabel;
    lblItemGoodsNumHint: TSkinFMXLabel;
    lblItemBillCodeHint: TSkinFMXLabel;
    lblItemBillCode: TSkinFMXLabel;
    lblItemSumMoney: TSkinFMXLabel;
    pnlItemBottomDevide: TSkinFMXPanel;
    btnItemOper3: TSkinFMXButton;
    lblItemSumMoneyHint: TSkinFMXLabel;
    btnItemOper4: TSkinFMXButton;
    btnIsFirstOrder: TSkinFMXButton;
    nniNumber: TSkinFMXNotifyNumberIcon;
    btnScanBarCode: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    imgOrderState: TSkinFMXImage;
    imglistOrderState: TSkinImageList;
    lblPayVouchar: TSkinFMXLabel;
    lblPayVoucharCount: TSkinFMXLabel;
    procedure lbOrderListClickItem(Sender: TSkinItem);
    procedure lbOrderListPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure btnItemOper1Click(Sender: TObject);
    procedure lbOrderListPullDownRefresh(Sender: TObject);
    procedure lbOrderListPullUpLoadMore(Sender: TObject);
    procedure lbOrderStateClickItem(AItem: TSkinItem);
    procedure nniNumberClick(Sender: TObject);
    procedure btnScanBarCodeClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    FPageIndex:Integer;

    FUseType:TFrameUseType;

    //过滤的订单拥有人
    FFilterOrderOwnerFID:String;
    //过滤的订单状态
    FFilterOrderState:String;

    FOrderList:TOrderList;

    procedure DoGetOrderListExecute(ATimerTask:TObject);
    procedure DoGetOrderListExecuteEnd(ATimerTask:TObject);

  private

    //从订单明细返回
    procedure DoReturnFrameFromOrderInfoFrame(Frame:TFrame);

    procedure OnReturnFrameFromNoticeClassifyListFrame(Frame:TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load( //标题
                    ACaption:String;
                    //页面使用类型
                    AUseType:TFrameUseType;
                    //过滤的订单拥有人
                    AFilterOrderOwnerFID:String;
                    //过滤的订单状态
                    AFilterOrderState:String
                    );
    { Public declarations }
  end;

var
  GlobalOrderListFrame:TFrameOrderList;

implementation

uses
  MainForm,
  MainFrame,
  PayOrderFrame,
//  AuditFrame,
  OrderInfoFrame,
//  DeliveryOrderFrame,
  NoticeClassifyListFrame;


{$R *.fmx}

procedure TFrameOrderList.btnItemOper1Click(Sender: TObject);
begin
  GlobalMainFrame.DoOrderOper(TSkinFMXButton(Sender).Caption,
                              TOrder(Self.lbOrderList.Prop.InteractiveItem.Data));
end;


procedure TFrameOrderList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;


procedure TFrameOrderList.btnScanBarCodeClick(Sender: TObject);
begin
  //扫描二维码
  frmMain.ScanBarCode;
end;


constructor TFrameOrderList.Create(AOwner: TComponent);
var
  AListBoxItem:TSkinListBoxItem;
begin
  inherited;

  Self.nniNumber.Prop.Number:=0;

  Self.lblPayVoucharCount.Caption:='';

  FOrderList:=TOrderList.Create;
  Self.lbOrderList.Prop.Items.Clear(True);


  Self.lbOrderState.Prop.Items.BeginUpdate;
  try
    Self.lbOrderState.Prop.Items.Clear(True);


//  const
//
//    //订单状态,要用小写,在url要用到//
//    //待付款                              (待付款)
//    Const_OrderState_WaitPay='wait_pay';
//    //已取消                              (已取消)
//    Const_OrderState_Cancelled='cancelled';
//    //已付款/待审核                     (已付款/待审核)
//    Const_OrderState_WaitAudit='wait_audit';
//    //----忽略    审核通过/待发货       (待发货)
//    Const_OrderState_WaitDelivery='wait_delivery';
//    //被拒绝/审核拒绝/拒绝发货                   (拒绝发货)
//    Const_OrderState_AuditReject='audit_reject';
//    //待收货/审核通过/已发货            (待收货)
//    Const_OrderState_WaitReceive='wait_receive';
//    //已完成                              (已完成)
//    Const_OrderState_Done='done';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='全部';
    AListBoxItem.Name:='';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='待付款';
    AListBoxItem.Name:='wait_pay';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='待审核';
    AListBoxItem.Name:='wait_audit';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='待发货';
    AListBoxItem.Name:='wait_delivery';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='待收货';
    AListBoxItem.Name:='wait_receive';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='已完成';
    AListBoxItem.Name:='done';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='被拒绝';
    AListBoxItem.Name:='audit_reject';

    AListBoxItem:=Self.lbOrderState.Prop.Items.Add;
    AListBoxItem.Caption:='已取消';
    AListBoxItem.Name:='cancelled';


  finally
    Self.lbOrderState.Prop.Items.EndUpdate;
  end;

end;

destructor TFrameOrderList.Destroy;
begin
  uFuncCommon.FreeAndNil(FOrderList);

  inherited;
end;


procedure TFrameOrderList.DoGetOrderListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                SimpleCallAPI('get_order_list',
                              AHttpControl,
                              InterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'filer_order_owner_fid',
                              'filer_order_state',
                              'pageindex',
                              'pagesize'],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              Self.FFilterOrderOwnerFID,
                              Self.FFilterOrderState,
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



procedure TFrameOrderList.DoGetOrderListExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  AOrderList:TOrderList;
  ASuperObject:ISuperObject;
begin

  try
      if TTimerTask(ATimerTask).TaskTag=0 then
      begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        if ASuperObject.I['Code']=200 then
        begin

          AOrderList:=TOrderList.Create(ooReference);

          //获取订单列表成功
          AOrderList.ParseFromJsonArray(TOrder,ASuperObject.O['Data'].A['OrderList']);


          Self.lbOrderList.Prop.Items.BeginUpdate;
          try
            if FPageIndex=1 then
            begin
              Self.lbOrderList.Prop.Items.ClearItemsByType(sitDefault);
              FOrderList.Clear(True);
            end;
            for I := 0 to AOrderList.Count-1 do
            begin

              FOrderList.Add(AOrderList[I]);


              AListBoxItem:=Self.lbOrderList.Prop.Items.Add;
              AListBoxItem.Data:=AOrderList[I];

              AListBoxItem.Caption:=AOrderList[I].hotel_name;

              AListBoxItem.Detail:=GetOrderStateStr(AOrderList[I].order_state);

              AListBoxItem.Detail1:=AOrderList[I].bill_code;
              AListBoxItem.Detail2:=AOrderList[I].createtime;
              AListBoxItem.Detail3:='共'+IntToStr(AOrderList[I].goods_kind_num)+'种'+IntToStr(AOrderList[I].goods_num)+'件';
              AListBoxItem.Detail4:='¥'+Format('%.2f',[AOrderList[I].summoney]);
              AListBoxItem.Detail5:=AOrderList[I].user_name;

            end;

          finally
            Self.lbOrderList.Prop.Items.EndUpdate();
            uFuncCommon.FreeAndNil(AOrderList);
          end;

        end
        else
        begin
          //获取用户列表失败
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
          if ASuperObject.O['Data'].A['OrderList'].Length>0 then
          begin
            Self.lbOrderList.Prop.StopPullUpLoadMore('加载成功!',0,True);
          end
          else
          begin
            Self.lbOrderList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
          end;
      end
      else
      begin
          Self.lbOrderList.Prop.StopPullDownRefresh('刷新成功!',600);
      end;

  end;
end;


procedure TFrameOrderList.DoReturnFrameFromOrderInfoFrame(Frame: TFrame);
begin
  //从订单详情返回
  if GlobalIsOrderInfoChanged then
  begin
    GlobalIsOrderInfoChanged:=False;
  
    //刷新
    Self.lbOrderList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameOrderList.lbOrderListClickItem(Sender: TSkinItem);
begin
  //订单详细
  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //订单详细
  ShowFrame(TFrame(GlobalOrderInfoFrame),TFrameOrderInfo,frmMain,nil,nil,DoReturnFrameFromOrderInfoFrame,Application);
//  GlobalOrderInfoFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalOrderInfoFrame.Load(TOrder(Sender.Data));
  GlobalOrderInfoFrame.Sync;
  
end;

procedure TFrameOrderList.lbOrderListPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
var
  AOrder:TOrder;
  I: Integer;
begin
  AOrder:=TOrder(Item.Data);


  //订单的付款凭证
  if AOrder.transer_payment_voucher='' then
  begin
    Self.lblPayVoucharCount.Caption:='无';
  end
  else
  begin
    Self.lblPayVoucharCount.Caption:=AOrder.transer_payment_voucher;
  end;

//  //设置佣金
//  Self.lblHotelCommissionValue.Caption:='¥'+Format('%.2f',[AOrder.manager_commission]);
//  Self.lblIntroductorCommissionValue.Caption:='¥'+Format('%.2f',[AOrder.introducer_commission]);
//  Self.lblIntroductorName.Caption:=AOrder.introducer_name;
//
//
//  if GlobalManager.User.is_hotel_manager=0 then
//  begin
//    //员工可以看到酒店经理佣金和介绍人佣金
//    if AOrder.is_first_order=1 then
//    begin
//      Self.lblHotelcommission.Visible:=False;
//      Self.lblHotelCommissionValue.Visible:=False;
//      Self.lblIntroductorCommission.Visible:=False;
//      Self.lblIntroductorCommissionValue.Visible:=False;
//      Self.lblManagerIsPay.Visible:=False;
//      Self.lblInterductorIsPay.Visible:=False;
//    end
//    else
//    begin
//
//      if AOrder.order_state=Const_OrderState_Done then
//      begin
//        if AOrder.manager_commission<>0 then
//        begin
//          Self.lblHotelcommission.Visible:=True;
//          Self.lblHotelCommissionValue.Visible:=True;
//          Self.lblIntroductorCommission.Visible:=True;
//          Self.lblIntroductorCommissionValue.Visible:=True;
//          Self.lblManagerIsPay.Visible:=True;
//          Self.lblInterductorIsPay.Visible:=True;
//        end
//        else
//        begin
//          Self.lblHotelcommission.Visible:=False;
//          Self.lblHotelCommissionValue.Visible:=False;
//          Self.lblIntroductorCommission.Visible:=False;
//          Self.lblIntroductorCommissionValue.Visible:=False;
//          Self.lblManagerIsPay.Visible:=False;
//          Self.lblInterductorIsPay.Visible:=False;
//        end;
//
//      end
//      else
//      begin
//        Self.lblHotelcommission.Visible:=False;
//        Self.lblHotelCommissionValue.Visible:=False;
//        Self.lblIntroductorCommission.Visible:=False;
//        Self.lblIntroductorCommissionValue.Visible:=False;
//        Self.lblManagerIsPay.Visible:=False;
//        Self.lblInterductorIsPay.Visible:=False;
//
//      end;
//    end;
//  end
//  else
//  begin
//    Self.lblHotelcommission.Visible:=False;
//    Self.lblHotelCommissionValue.Visible:=False;
//    Self.lblIntroductorCommission.Visible:=False;
//    Self.lblIntroductorCommissionValue.Visible:=False;
//    Self.lblManagerIsPay.Visible:=False;
//    Self.lblInterductorIsPay.Visible:=False;
//  end;
//
//
//  //酒店经理的佣金是否已支付
//  if AOrder.is_pay_manager=1 then
//  begin
//    Self.lblManagerIsPay.Caption:='已支付';
//    Self.lblManagerIsPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
//  end
//  else
//  begin
//    Self.lblManagerIsPay.Caption:='未支付';
//    Self.lblManagerIsPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
//  end;
//
//  //介绍人的佣金是否已支付
//  if AOrder.is_pay_introducer=1 then
//  begin
//    Self.lblInterductorIsPay.Caption:='已支付';
//    Self.lblInterductorIsPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
//  end
//  else
//  begin
//    Self.lblInterductorIsPay.Caption:='未支付';
//    Self.lblInterductorIsPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
//  end;




  Self.imgOrderState.Prop.Picture.StaticImageIndex:=-1;
  lblItemOrderState.Material.DrawCaptionParam.FontColor:=SkinThemeColor;
  //待付款
  if AOrder.order_state=Const_OrderState_WaitPay then
  begin
  end;
  //已取消
  if AOrder.order_state=Const_OrderState_Cancelled then
  begin
    lblItemOrderState.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
  end;
  //待审核
  if AOrder.order_state=Const_OrderState_WaitAudit then
  begin
  end;
  //待发货
  if AOrder.order_state=Const_OrderState_WaitDelivery then
  begin
  end;
  //被拒绝
  if AOrder.order_state=Const_OrderState_AuditReject then
  begin
    lblItemOrderState.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
  end;
  //待收货
  if AOrder.order_state=Const_OrderState_WaitReceive then
  begin
  end;
  //已完成
  if AOrder.order_state=Const_OrderState_Done then
  begin
    //显示图标,不显示订单状态
    Self.imgOrderState.Prop.Picture.StaticImageIndex:=0;
    Self.lblItemOrderState.StaticText:='';
    lblItemOrderState.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
  end;



  //是否首单
  btnIsFirstOrder.Visible:=(AOrder.is_first_order=1);


  if FUseType=futManage then
  begin

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


      Self.btnItemOper1.Visible:=False;
      Self.btnItemOper2.Visible:=False;
      Self.btnItemOper3.Visible:=False;
      Self.btnItemOper4.Visible:=False;


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
        end
        else
        begin
          //员工
          //取消订单、修改订单
          Self.btnItemOper1.Caption:='取消订单';
          Self.btnItemOper1.Visible:=True;
          Self.btnItemOper2.Caption:='修改订单';
          Self.btnItemOper2.Visible:=False;
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
            Self.btnItemOper1.Visible:=True;
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
            Self.btnItemOper1.Visible:=True;
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
            Self.btnItemOper1.Visible:=True;

            if AOrder.is_first_order=0 then
            begin
              if (AOrder.is_pay_manager=1) and (AOrder.is_pay_introducer=1) then
              begin
                Self.btnItemOper2.Visible:=False;
                Self.btnItemOper3.Visible:=False;
                Self.btnItemOper4.Visible:=False;
              end
              else
              begin
                if (AOrder.is_pay_manager=0) and (AOrder.is_pay_introducer=0) then
                begin
                  if (AOrder.manager_commission<>0) and (AOrder.introducer_commission<>0) then
                  begin
                    Self.btnItemOper2.Visible:=True;
                    Self.btnItemOper2.Caption:='支付经理';
                    Self.btnItemOper3.Visible:=True;
                    Self.btnItemOper3.Caption:='支付介绍人';
                  end
                  else if (AOrder.manager_commission=0) and (AOrder.introducer_commission=0) then
                  begin
                    Self.btnItemOper2.Visible:=False;
                    Self.btnItemOper3.Visible:=False;

                  end
                  else if AOrder.introducer_commission=0 then
                  begin
                    Self.btnItemOper2.Visible:=True;
                    Self.btnItemOper2.Caption:='支付经理';
                    Self.btnItemOper3.Visible:=False;
                  end
                  else
                  begin
                    Self.btnItemOper2.Visible:=True;
                    Self.btnItemOper2.Caption:='支付介绍人';
                    Self.btnItemOper3.Visible:=False;
                  end;

                  Self.btnItemOper4.Visible:=False;
                end
                else
                begin
                  if AOrder.is_pay_manager=0 then
                  begin
                    if AOrder.manager_commission<>0 then
                    begin
                      Self.btnItemOper2.Visible:=True;
                      Self.btnItemOper2.Caption:='支付经理';
                    end
                    else
                    begin
                      Self.btnItemOper2.Visible:=False;
                    end;
                    Self.btnItemOper3.Visible:=False;
                    Self.btnItemOper4.Visible:=False;
                  end
                  else
                  begin
                    if AOrder.introducer_commission<>0 then
                    begin
                      Self.btnItemOper2.Visible:=True;
                      Self.btnItemOper2.Caption:='支付介绍人';
                    end
                    else
                    begin
                      Self.btnItemOper2.Visible:=False;
                    end;
                    Self.btnItemOper3.Visible:=False;
                    Self.btnItemOper4.Visible:=False;
                  end;
                end;
              end;
            end
            else
            begin
              Self.btnItemOper2.Visible:=False;
              Self.btnItemOper3.Visible:=False;
              Self.btnItemOper4.Visible:=False;
            end;
          end;
      end;

  end;



  //查看酒店经理的订单列表
  if FUseType=futViewList then
  begin
    Self.btnItemOper1.Caption:='查看订单';
    Self.btnItemOper1.Visible:=True;
    Self.btnItemOper2.Visible:=False;
    Self.btnItemOper3.Visible:=False;
    Self.btnItemOper4.Visible:=False;
  end;


  //右边第一个按钮,默认设置成红色,提醒要处理
  //默认是红色,如果是查看订单或者再次订购,就是灰色
  btnItemOper1.Material.BackColor.BorderColor.FColor:=SkinThemeColor;
  btnItemOper1.Material.DrawCaptionParam.FontColor:=SkinThemeColor;
  if (Self.btnItemOper1.Caption='查看订单')
    or (Self.btnItemOper1.Caption='再次购买') then
  begin
    btnItemOper1.Material.BackColor.BorderColor.FColor:=TAlphaColorRec.Gray;
    btnItemOper1.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
  end;






end;

procedure TFrameOrderList.lbOrderListPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  GetGlobalTimerThread.RunTempTask(DoGetOrderListExecute,
                                  DoGetOrderListExecuteEnd);
end;

procedure TFrameOrderList.lbOrderListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  GetGlobalTimerThread.RunTempTask(DoGetOrderListExecute,
                                DoGetOrderListExecuteEnd);
end;

procedure TFrameOrderList.lbOrderStateClickItem(AItem: TSkinItem);
begin
  //点击切换订单分类
  if FFilterOrderState<>AItem.Name then
  begin
    FFilterOrderState:=AItem.Name;
    Self.lbOrderList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameOrderList.Load(ACaption:String;
                              AUseType:TFrameUseType;
                              AFilterOrderOwnerFID:String;
                              AFilterOrderState:String);
begin

  Self.pnlToolBar.Caption:=ACaption;

  FUseType:=AUseType;
  FFilterOrderOwnerFID:=AFilterOrderOwnerFID;
  FFilterOrderState:=AFilterOrderState;


//  如果是员工查看订单列表,那么显示出酒店经理
//  if GlobalManager.User.is_emp=1 then
//  begin
//    Self.lblHotelManager.Visible:=True;
//    Self.lblManager.Visible:=True;
//    Self.lblHotelcommission.Visible:=True;
//    Self.lblHotelCommissionValue.Visible:=True;
//    Self.lblIntroductorCommission.Visible:=True;
//    Self.lblIntroductorCommissionValue.Visible:=True;
//    Self.lblManagerIsPay.Visible:=True;
//    Self.lblInterductorIsPay.Visible:=True;
//    Self.lblIntroductor.Visible:=True;
//    Self.lblIntroductorName.Visible:=True;
//    Self.lbOrderList.Properties.ItemHeight:=210;
//
//  end
//  else
//  begin
//    Self.lblHotelManager.Visible:=False;
//    Self.lblManager.Visible:=False;
//    Self.lblHotelcommission.Visible:=False;
//    Self.lblHotelCommissionValue.Visible:=False;
//    Self.lblIntroductorCommission.Visible:=False;
//    Self.lblIntroductorCommissionValue.Visible:=False;
//    Self.lblIntroductor.Visible:=False;
//    Self.lblIntroductorName.Visible:=False;
//    Self.lblManagerIsPay.Visible:=False;
//    Self.lblInterductorIsPay.Visible:=False;
//    Self.lbOrderList.Properties.ItemHeight:=160;
//    Self.lblItemBillCodeHint.Position.Y:=36;
//    Self.lblItemBillCode.Position.Y:=36;
//    Self.lblItemOrderDate.Position.Y:=36;
//    Self.lblItemGoodsNumHint.Position.Y:=60;
//    Self.lblItemGoodsNum.Position.Y:=60;
//    Self.lblItemSumMoneyHint.Position.Y:=60;
//    Self.lblItemSumMoney.Position.Y:=60;
//    Self.lblPayVouchar.Position.Y:=83;
//    Self.lblPayVoucharCount.Position.Y:=83;
//    Self.pnlItemBottomDevide.Position.Y:=108;
//    Self.btnItemOper1.Position.Y:=115;
//    Self.btnItemOper2.Position.Y:=115;
//    Self.btnItemOper3.Position.Y:=115;
//    Self.btnItemOper4.Position.Y:=115;
//    Self.btnIsFirstOrder.Position.Y:=115;
//  end;


  //订单管理
  if AUseType=futManage then
  begin
    Self.btnReturn.Visible:=False;
    Self.btnScanBarCode.Visible:=True;
    Self.nniNumber.Visible:=True;
    Self.lbOrderState.Visible:=True;
  end;


  //查看用户订单列表
  if AUseType=futViewList then
  begin
    Self.btnReturn.Visible:=True;
    Self.btnScanBarCode.Visible:=False;
    Self.nniNumber.Visible:=False;
    Self.lbOrderState.Visible:=True;//False;
  end;



  //选中当前的分类
  if Self.lbOrderState.Prop.Items.FindItemByName(AFilterOrderState)<>nil then
  begin
    Self.lbOrderState.Prop.Items.FindItemByName(AFilterOrderState).Selected:=True;
  end;


  //暂时去掉了
//  if GlobalManager.User.is_emp=1 then
//  begin
//    //员工需要显示待审核,待发货
//    Self.lbOrderState.Prop.Items.FindItemByName(Const_OrderState_WaitAudit).Visible:=True;
//    Self.lbOrderState.Prop.Items.FindItemByName(Const_OrderState_WaitDelivery).Visible:=True;
//  end
//  else
//  begin
//    //酒店经理不需要显示待审核,待发货
//    Self.lbOrderState.Prop.Items.FindItemByName(Const_OrderState_WaitAudit).Visible:=False;
//    Self.lbOrderState.Prop.Items.FindItemByName(Const_OrderState_WaitDelivery).Visible:=False;
//  end;



  //未读通知数
  Self.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;



  //刷新订单列表
  Self.lbOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameOrderList.nniNumberClick(Sender: TObject);
begin
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //消息通知列表
  ShowFrame(TFrame(GlobalNoticeClassifyListFrame),TFrameNoticeClassifyList,frmMain,nil,nil,OnReturnFrameFromNoticeClassifyListFrame,Application);
//  GlobalNoticeClassifyListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalNoticeClassifyListFrame.Load;

end;

procedure TFrameOrderList.OnReturnFrameFromNoticeClassifyListFrame(Frame: TFrame);
begin
//  Self.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
end;

end.
