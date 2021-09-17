//convert pas to utf8 by ¥
unit TakeOrderFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uGetDeviceInfo,
  FMX.DeviceInfo,
  EasyServiceCommonMaterialDataMoudle,

//  uCommonUtils,
  uEasyServiceCommon,
  uInterfaceClass,
  uBaseHttpControl,
  uTimerTask,
  WaitingFrame,
  MessageBoxFrame,

  uUIFunction,
  XSuperObject,
  XSuperJson,

  uManager,
  uMobileUtils,
  uSkinListViewType,
  uSkinListBoxType,


  uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinFireMonkeyRadioButton, uSkinMaterial,
  uSkinButtonType, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyCustomList, uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyListBox,
  uSkinMultiColorLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinLabelType, uSkinPanelType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uDrawCanvas, uSkinItems;

type
  TFrameTakeOrder = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent,IFrameVirtualKeyboardEvent)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlEmptyBottom: TSkinFMXPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlRecvAddr: TSkinFMXPanel;
    pnlRemark: TSkinFMXPanel;
    memRemark: TSkinFMXMemo;
    SkinFMXPanel3: TSkinFMXPanel;
    pnlHotel: TSkinFMXPanel;
    btnSelectHotel: TSkinFMXButton;
    pnlBuyGoodsList: TSkinFMXPanel;
    lbBuyGoodsList: TSkinFMXListBox;
    idpItemBuyGoods: TSkinFMXItemDesignerPanel;
    ImgPic: TSkinFMXImage;
    btnViewBuyGoodsList: TSkinFMXButton;
    SkinFMXPanel5: TSkinFMXPanel;
    btnSelectRecvAddr: TSkinFMXButton;
    lblRecvAddr: TSkinFMXLabel;
    SkinFMXPanel6: TSkinFMXPanel;
    lblRecvName: TSkinFMXLabel;
    lblRecvPhone: TSkinFMXLabel;
    pnlBottomBar: TSkinFMXPanel;
    btnOK: TSkinFMXButton;
    lblSumMoney: TSkinFMXMultiColorLabel;
    pnlManager: TSkinFMXPanel;
    btnSelectManager: TSkinFMXButton;
    pnlReduce: TSkinFMXPanel;
    edtReduce: TSkinFMXEdit;
    SkinFMXPanel1: TSkinFMXPanel;
    pnlGoodsSumMoney: TSkinFMXPanel;
    SkinFMXPanel4: TSkinFMXPanel;
    lblGoodsSumMoney: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSelectHotelStayClick(Sender: TObject);
    procedure btnSelectRecvAddrStayClick(Sender: TObject);
    procedure btnViewBuyGoodsListStayClick(Sender: TObject);
    procedure btnSelectManagerStayClick(Sender: TObject);
    procedure edtReduceChange(Sender: TObject);
    procedure edtReduceChangeTracking(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
  private
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
  private

    //下单的购物车商品有
    FBuyGoodsList:TBuyGoodsList;

    //收货地址
    FHotelRecvAddr:THotelRecvAddr;

    //备注
    FRemark:String;

    //减免金额
    FReduce:Double;

    //选择的酒店
    FSelectedHotelFID:Integer;
    //选择的酒店经理
    FSelectedManagerFID:Integer;

    //下单
    procedure DoTakeOrderExecute(ATimerTask:TObject);
    procedure DoTakeOrderExecuteEnd(ATimerTask:TObject);

  private
    //获取订单接口
    procedure DoGetOrderExecute(ATimerTask:TObject);
    procedure DoGetOrderExecuteEnd(ATimerTask:TObject);
  private

    //编辑的订单
    FOrder:TOrder;
    //编辑订单
    procedure DoUpdateOrderExecute(ATimerTask:TObject);
    procedure DoUpdateOrderExecuteEnd(ATimerTask:TObject);

  private
    //首单消息通知
    procedure OnFirstOrderMessageBoxModalResult(Sender: TObject);

    //放弃订单
    procedure OnModalResultFromLeaveOrder(Frame:TObject);
  private
    //获取酒店收货地址列表
    procedure DoGetHotelRecvAddrListExecute(ATimerTask:TObject);
    procedure DoGetHotelRecvAddrListExecuteEnd(ATimerTask:TObject);

  private
    //选择介绍人返回
    procedure OnReturnFrameFromSelectManager(Frame:TFrame);
    //选择酒店返回
    procedure OnReturnFrameFromSelectHotel(Frame:TFrame);
    //选择酒店收货地址返回
    procedure OnReturnFrameFromSelectRecvAddr(Frame:TFrame);

    { Private declarations }
  private
    procedure SyncSummary;
    //清除收货地址
    procedure ClearHotelRecvAddr;
    //加载收货地址
    procedure LoadHotelRecvAddrToUI(AHotelRecvAddr:THotelRecvAddr);
    procedure LoadOrder(AOrder:TOrder);
  public
    procedure Clear;

    //加载购买的商品列表
    procedure LoadBuyGoodsList(ABuyGoodsList:TBuyGoodsList);

    //编辑订单
    procedure EditOrder(AOrder:TOrder);
    //添加订单
    procedure AddOrder;
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;


var
  GlobalTakeOrderFrame:TFrameTakeOrder;


implementation

{$R *.fmx}

uses
//  UserListFrame,
  OrderGoodsListFrame,
  PayOrderFrame,
//  SelectUserListFrame,
  HotelRecvAddrListFrame,
  HotelListFrame,
  MainFrame,
  MainForm;



procedure TFrameTakeOrder.Clear;
begin
  FOrder:=nil;

  Self.btnViewBuyGoodsList.Caption:='';
  Self.lbBuyGoodsList.Prop.Items.Clear(True);

  Self.btnSelectManager.Caption:='';
  FSelectedManagerFID:=0;

  Self.btnSelectHotel.Caption:='';
  FSelectedHotelFID:=0;

  //清除收货信息
  ClearHotelRecvAddr;

  //备注
  Self.memRemark.Text:='';
  FRemark:='';

  //商品总金额
  Self.lblGoodsSumMoney.Text:='0.00';

  //减免金额
  FReduce:=0;
  edtReduce.Text:='0.00';


  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[0.00]);

  Self.sbClient.VertScrollBar.Prop.Position:=0;
end;

procedure TFrameTakeOrder.ClearHotelRecvAddr;
begin
  Self.lblRecvName.Caption:='';
  Self.lblRecvPhone.Caption:='';
  Self.lblRecvAddr.Caption:='';
  Self.FHotelRecvAddr.Clear;
end;

constructor TFrameTakeOrder.Create(AOwner: TComponent);
begin
  inherited;

  FBuyGoodsList:=TBuyGoodsList.Create();
  FHotelRecvAddr:=THotelRecvAddr.Create;

end;

destructor TFrameTakeOrder.Destroy;
begin
  FreeAndNil(FBuyGoodsList);
  FreeAndNil(FHotelRecvAddr);
  inherited;
end;

procedure TFrameTakeOrder.DoTakeOrderExecute(ATimerTask: TObject);
var
  I:Integer;
  AGoodsListSuperObject:ISuperArray;
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try

      AGoodsListSuperObject:=TSuperArray.Create();
      for I := 0 to Self.FBuyGoodsList.Count-1 do
      begin
        if FBuyGoodsList[I] is TUserCartGoods then
        begin
          //下单了之后,要删除购物车中的商品
          AGoodsListSuperObject.O[I].I['user_cart_goods_fid']:=TUserCartGoods(FBuyGoodsList[I]).user_cart_goods_fid;
        end;
        AGoodsListSuperObject.O[I].I['goods_fid']:=FBuyGoodsList[I].fid;
        AGoodsListSuperObject.O[I].I['number']:=FBuyGoodsList[I].number;
      end;


      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('take_order',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'hotel_fid',
                                                    'goods_list_json_str',
                                                    'freight',
                                                    'recv_addr_fid',
                                                    'recv_name',
                                                    'recv_phone',
                                                    'recv_province',
                                                    'recv_city',
                                                    'recv_area',
                                                    'recv_addr',
                                                    'remark',
                                                    'source',
                                                    'order_owner_fid'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FSelectedHotelFID,
                                                    AGoodsListSuperObject.AsJSON,
                                                    0,
                                                    Self.FHotelRecvAddr.fid,
                                                    Self.FHotelRecvAddr.name,
                                                    Self.FHotelRecvAddr.phone,
                                                    Self.FHotelRecvAddr.province,
                                                    Self.FHotelRecvAddr.city,
                                                    Self.FHotelRecvAddr.area,
                                                    Self.FHotelRecvAddr.addr,
                                                    FRemark,
                                                    'app',
                                                    FSelectedManagerFID
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

procedure TFrameTakeOrder.DoTakeOrderExecuteEnd(ATimerTask: TObject);
var
  AOrder:TOrder;
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          //下单成功,跳转到付款页面
          AOrder:=TOrder.Create;
          try
            AOrder.ParseFromJson(ASuperObject.O['Data'].A['Order'].O[0]);

            if AOrder.is_first_order=1 then
            begin

                //首单不需要付款
                ShowMessageBoxFrame(frmMain,
                                    '这是此酒店第一次补货,不需要付款,请耐心等待审核通过!',
                                    '',
                                    TMsgDlgType.mtInformation,
                                    ['查看订单'],
                                    OnFirstOrderMessageBoxModalResult);


            end
            else
            begin

                //隐藏
                HideFrame;//(Self,hfcttBeforeShowFrame);

                //显示用户信息
                ShowFrame(TFrame(GlobalPayOrderFrame),TFramePayOrder,frmMain,nil,nil,nil,Application);
//                GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
                GlobalPayOrderFrame.Load(AOrder,True);

            end;

          finally
            FreeAndNil(AOrder);
          end;


      end
      else
      begin
        //下单失败
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

procedure TFrameTakeOrder.DoUpdateOrderExecute(ATimerTask: TObject);
var
  I:Integer;
  AGoodsListSuperObject:ISuperArray;
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try

      AGoodsListSuperObject:=TSuperArray.Create();
      for I := 0 to Self.FBuyGoodsList.Count-1 do
      begin
        AGoodsListSuperObject.O[I].I['goods_fid']:=FBuyGoodsList[I].fid;
        AGoodsListSuperObject.O[I].I['number']:=FBuyGoodsList[I].number;
      end;


      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('update_order',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'order_fid',
                                                    'hotel_fid',
                                                    'goods_list_json_str',
                                                    'freight',
                                                    'reduce',
                                                    'recv_addr_fid',
                                                    'recv_name',
                                                    'recv_phone',
                                                    'recv_province',
                                                    'recv_city',
                                                    'recv_area',
                                                    'recv_addr',
                                                    'remark',
                                                    'source',
                                                    'order_owner_fid'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FOrder.fid,
                                                    FSelectedHotelFID,
                                                    AGoodsListSuperObject.AsJSON,
                                                    0,
                                                    FReduce,
                                                    Self.FHotelRecvAddr.fid,
                                                    Self.FHotelRecvAddr.name,
                                                    Self.FHotelRecvAddr.phone,
                                                    Self.FHotelRecvAddr.province,
                                                    Self.FHotelRecvAddr.city,
                                                    Self.FHotelRecvAddr.area,
                                                    Self.FHotelRecvAddr.addr,
                                                    FRemark,
                                                    'app',
                                                    FSelectedManagerFID
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

procedure TFrameTakeOrder.DoUpdateOrderExecuteEnd(ATimerTask: TObject);
var
  AOrder:TOrder;
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          //修改订单成功,跳转到付款页面
          AOrder:=TOrder.Create;
          try
            AOrder.ParseFromJson(ASuperObject.O['Data'].A['Order'].O[0]);

            if AOrder.is_first_order=1 then
            begin

                //首单不需要付款
                ShowMessageBoxFrame(frmMain,
                                    '这是此酒店第一次补货,不需要付款,请耐心等待审核通过!',
                                    '',
                                    TMsgDlgType.mtInformation,
                                    ['查看订单'],
                                    OnFirstOrderMessageBoxModalResult);


            end
            else
            begin

                //隐藏
                HideFrame;//(Self,hfcttBeforeShowFrame);

                //显示用户信息
                ShowFrame(TFrame(GlobalPayOrderFrame),TFramePayOrder,frmMain,nil,nil,nil,Application);
//                GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
                GlobalPayOrderFrame.Load(AOrder,True);

            end;

          finally
            FreeAndNil(AOrder);
          end;


      end
      else
      begin
        //修改订单失败
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

procedure TFrameTakeOrder.DoVirtualKeyboardHide(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.pnlBottomBar.Visible:=True;
end;

procedure TFrameTakeOrder.DoVirtualKeyboardShow(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.pnlBottomBar.Visible:=False;
end;

procedure TFrameTakeOrder.EditOrder(AOrder: TOrder);
begin
  Self.pnlToolBar.Caption:='修改订单';

  //权限控制
  if GlobalManager.User.is_emp=0 then
  begin
    //酒店经理不能看到减免金额的设置
    Self.pnlReduce.Visible:=False;
    //不能代下单
    Self.pnlManager.Visible:=False;
  end
  else
  begin
    //员工可以看到减免金额的设置
    Self.pnlReduce.Visible:=True;
    //员工可以代下单
    Self.pnlManager.Visible:=True;
  end;


  LoadOrder(AOrder);




  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);



  //获取订单详情
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                               DoGetOrderExecute,
                               DoGetOrderExecuteEnd);

end;

procedure TFrameTakeOrder.edtReduceChange(Sender: TObject);
begin
  //刷新总金额
  Self.SyncSummary;
end;

procedure TFrameTakeOrder.edtReduceChangeTracking(Sender: TObject);
begin
  //刷新总金额
  Self.SyncSummary;
end;

function TFrameTakeOrder.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameTakeOrder.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

procedure TFrameTakeOrder.DoGetHotelRecvAddrListExecute(
  ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_hotel_recv_addr_list',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'hotel_fid'
                                                      ],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FSelectedHotelFID
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

procedure TFrameTakeOrder.DoGetHotelRecvAddrListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ARecvAddrList:THotelRecvAddrList;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //获取酒店收货地址列表成功
        ARecvAddrList:=THotelRecvAddrList.Create();
        ARecvAddrList.ParseFromJsonArray(THotelRecvAddr,ASuperObject.O['Data'].A['HotelRecvAddrList']);
        try

          if ARecvAddrList.GetDefaultRecvAddr<>nil then
          begin
            Self.FHotelRecvAddr.Assign(ARecvAddrList.GetDefaultRecvAddr);

            LoadHotelRecvAddrToUI(FHotelRecvAddr);

          end
          else
          begin
            Self.ClearHotelRecvAddr;
          end;


        finally
          FreeAndNil(ARecvAddrList);
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

procedure TFrameTakeOrder.OnReturnFrameFromSelectManager(Frame: TFrame);
begin
  //选择酒店经理返回
//  if FSelectedManagerFID<>GlobalUserListFrame.FSelectedUserFID then
//  begin
//
//    FSelectedManagerFID:=GlobalUserListFrame.FSelectedUserFID;
//    if GlobalUserListFrame.FSelectedUser<>nil then
//    begin
//      Self.btnSelectManager.Caption:=GlobalUserListFrame.FSelectedUser.Name;
//    end
//    else
//    begin
//      Self.btnSelectManager.Caption:='';
//    end;
//
//    //要清除原酒店经理的酒店和收货地址
//    Self.FSelectedHotelFID:=0;
//    Self.btnSelectHotel.Caption:='';
//
//    Self.ClearHotelRecvAddr;
//
//  end;
end;

procedure TFrameTakeOrder.OnReturnFrameFromSelectRecvAddr(Frame:TFrame);
begin
  //选择收货地址返回
  if GlobalHotelRecvAddrListFrame.FSelectedRecvAddr<>nil then
  begin
    Self.FHotelRecvAddr.Assign(GlobalHotelRecvAddrListFrame.FSelectedRecvAddr);
    LoadHotelRecvAddrToUI(FHotelRecvAddr);
  end
  else
  begin
    Self.ClearHotelRecvAddr;
  end;
end;

procedure TFrameTakeOrder.SyncSummary;
var
  ASumMoney:Double;
begin
  if TryStrToFloat(Self.edtReduce.Text,FReduce) then
  begin
    //订单总金额=商品总金额-减免
    ASumMoney:=StrToFloat(Self.lblGoodsSumMoney.Text)-FReduce;

    Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
      Format('%.2f',[ASumMoney]);
  end;

end;

procedure TFrameTakeOrder.OnFirstOrderMessageBoxModalResult(Sender: TObject);
begin
  //返回到我的订单页面

  //查看订单
  GlobalMainFrame.ShowOrderFrame;

end;

procedure TFrameTakeOrder.OnModalResultFromLeaveOrder(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin

    if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;


    //返回
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);

  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;
end;

procedure TFrameTakeOrder.OnReturnFrameFromSelectHotel(Frame: TFrame);
begin
  //选择酒店返回
  if Self.FSelectedHotelFID<>GlobalHotelListFrame.FSelectedHotelFID then
  begin

    Self.FSelectedHotelFID:=GlobalHotelListFrame.FSelectedHotelFID;
    if GlobalHotelListFrame.FSelectedHotel<>nil then
    begin
      Self.btnSelectHotel.Caption:=GlobalHotelListFrame.FSelectedHotel.Name;
    end
    else
    begin
      Self.btnSelectHotel.Caption:='';
    end;

    //清除原酒店的收货地址
    Self.ClearHotelRecvAddr;


    ShowWaitingFrame(Self,'获取收货地址...');
    //设置好默认的收货地址
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                           DoGetHotelRecvAddrListExecute,
                                           DoGetHotelRecvAddrListExecuteEnd);
  end;

end;

procedure TFrameTakeOrder.btnReturnClick(Sender: TObject);
begin
  ShowMessageBoxFrame(Self,
                      '是否放弃此订单?',
                      '',
                      TMsgDlgType.mtInformation,
                      ['确定','取消'],
                      OnModalResultFromLeaveOrder);
end;

procedure TFrameTakeOrder.btnSelectHotelStayClick(Sender: TObject);
begin
  //选择酒店
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //选择酒店
  ShowFrame(TFrame(GlobalHotelListFrame),TFrameHotelList,frmMain,nil,nil,OnReturnFrameFromSelectHotel,Application);
//  GlobalHotelListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalHotelListFrame.Load('选择酒店',
                              futSelectList,
                              IntToStr(FSelectedManagerFID),
                              IntToStr(Ord(asAuditPass)),
                              FSelectedHotelFID,
                              True,
                              '',
                              0);

end;

procedure TFrameTakeOrder.btnSelectRecvAddrStayClick(Sender: TObject);
begin
  //选择收货地址

  if FSelectedHotelFID=0 then
  begin
    ShowMessageBoxFrame(Self,'请先选择酒店!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  //收货地址管理
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalHotelRecvAddrListFrame),TFrameHotelRecvAddrList,frmMain,nil,nil,OnReturnFrameFromSelectRecvAddr,Application);
//  GlobalHotelRecvAddrListFrame.FrameHistroy:=CurrentFrameHistroy;

  GlobalHotelRecvAddrListFrame.Load('选择收货地址',
                                      futSelectList,
                                      FSelectedHotelFID,
                                      nil,
                                      FHotelRecvAddr.fid);

end;

procedure TFrameTakeOrder.btnSelectManagerStayClick(Sender: TObject);
begin
  //选择酒店经理
//  HideFrame;//(Self,hfcttBeforeShowFrame);
//  ShowFrame(TFrame(GlobalUserListFrame),TFrameUserList,frmMain,nil,nil,OnReturnFrameFromSelectManager,Application);
//  GlobalUserListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalUserListFrame.Load('',
//                            '',
//                            futSelectList,
//                            '',
//                            '1',
//                            '',
//                            0,
//                            Self.FSelectedManagerFID,
//                            True);

end;

procedure TFrameTakeOrder.btnViewBuyGoodsListStayClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //审核意见
  ShowFrame(TFrame(GlobalOrderGoodsListFrame),TFrameOrderGoodsList,frmMain,nil,nil,nil,Application);

  GlobalOrderGoodsListFrame.LoadGoodsList(FBuyGoodsList);
//  GlobalOrderGoodsListFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameTakeOrder.LoadBuyGoodsList(ABuyGoodsList:TBuyGoodsList);
var
  I: Integer;
  ASumMoney:Double;
  ASumNumber:Integer;
  ABuyGoods:TBuyGoods;
  AListBoxItem:TSkinListBoxItem;
begin

  //加载商品列表
  Self.lbBuyGoodsList.Prop.Items.BeginUpdate;
  try

    Self.FBuyGoodsList.Clear(True);
    Self.lbBuyGoodsList.Prop.Items.Clear(True);


    //总金额
    ASumMoney:=0;
    ASumNumber:=0;
    for I := 0 to ABuyGoodsList.Count-1 do
    begin
      ABuyGoods:=TBuyGoods(ABuyGoodsList[I].ClassType.Create);
      ABuyGoods.Assign(ABuyGoodsList[I]);
      FBuyGoodsList.Add(ABuyGoods);

      ASumMoney:=ASumMoney+ABuyGoods.number*ABuyGoods.price;
      ASumNumber:=ASumNumber+ABuyGoods.number;

      AListBoxItem:=Self.lbBuyGoodsList.Prop.Items.Add;
      AListBoxItem.Data:=ABuyGoods;

      AListBoxItem.Icon.Url:=ABuyGoods.GetPic1Url;
    end;

  finally
    Self.lbBuyGoodsList.Prop.Items.EndUpdate();
  end;

  //总金额根据商品来计算
  Self.lblGoodsSumMoney.Text:=
    Format('%.2f',[ASumMoney]);

  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[ASumMoney]);

  Self.btnViewBuyGoodsList.Caption:='共'+IntToStr(FBuyGoodsList.Count)+'种'
                                    +IntToStr(ASumNumber)+'个商品';


end;

procedure TFrameTakeOrder.LoadHotelRecvAddrToUI(AHotelRecvAddr:THotelRecvAddr);
begin
  if AHotelRecvAddr<>nil then
  begin
    Self.lblRecvName.Caption:=AHotelRecvAddr.name;
    Self.lblRecvPhone.Caption:=AHotelRecvAddr.phone;
    Self.lblRecvAddr.Caption:=AHotelRecvAddr.addr;
  end;
end;

procedure TFrameTakeOrder.LoadOrder(AOrder: TOrder);
begin
  FOrder:=AOrder;


  //订单的酒店经理
  Self.FSelectedManagerFID:=AOrder.user_fid;
  Self.btnSelectManager.Caption:=AOrder.user_name;

  //订单的酒店
  Self.FSelectedHotelFID:=AOrder.hotel_fid;
  Self.btnSelectHotel.Caption:=AOrder.hotel_name;


  //收货地址
  Self.FHotelRecvAddr.name:=AOrder.recv_name;
  Self.FHotelRecvAddr.phone:=AOrder.recv_phone;
  Self.FHotelRecvAddr.province:=AOrder.recv_province;
  Self.FHotelRecvAddr.city:=AOrder.recv_city;
  Self.FHotelRecvAddr.area:=AOrder.recv_area;
  Self.FHotelRecvAddr.addr:=AOrder.recv_addr;
  Self.LoadHotelRecvAddrToUI(FHotelRecvAddr);

  //备注
  Self.memRemark.Text:=AOrder.remark;

  //减免金额
  Self.edtReduce.Text:=Format('%.2f',[AOrder.reduce]);


  //加载订单商品列表
  LoadBuyGoodsList(AOrder.OrderGoodsList);


  Self.SyncSummary;

end;

procedure TFrameTakeOrder.AddOrder;
begin

  Self.pnlToolBar.Caption:='确认下单';


  if (GlobalManager.User.is_emp=0) then
  begin
    //是酒店经理
    Self.pnlManager.Visible:=False;
    Self.FSelectedManagerFID:=GlobalManager.User.fid;

    //酒店经理不能看到减免金额的设置
    Self.pnlReduce.Visible:=False;
    Self.pnlManager.Visible:=False;
  end
  else
  begin
    //是员工
    Self.pnlManager.Visible:=True;
    Self.FSelectedManagerFID:=0;
    //员工可以看到减免金额的设置
    Self.pnlReduce.Visible:=True;
    //员工可以代下单
    Self.pnlManager.Visible:=True;
  end;


  //获取酒店列表


  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);

end;

procedure TFrameTakeOrder.btnOKClick(Sender: TObject);
begin
  HideVirtualKeyboard;



  if Self.FBuyGoodsList.Count=0 then
  begin
    ShowMessageBoxFrame(Self,'请选择商品!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if FSelectedManagerFID=0 then
  begin
    ShowMessageBoxFrame(Self,'请选择酒店经理!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if FSelectedHotelFID=0 then
  begin
    ShowMessageBoxFrame(Self,'请选择酒店!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if (Self.FHotelRecvAddr.name='')
    or (Self.FHotelRecvAddr.phone='')
    or (Self.FHotelRecvAddr.addr='') then
  begin
    ShowMessageBoxFrame(Self,'请选择收货地址!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  FRemark:=Trim(Self.memRemark.Text);

  FReduce:=StrToFloat(Self.edtReduce.Text);


  ShowWaitingFrame(Self,'提交中...');

  if FOrder=nil then
  begin
    //下单
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                 DoTakeOrderExecute,
                                 DoTakeOrderExecuteEnd);
  end
  else
  begin
    //修改订单
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                 DoUpdateOrderExecute,
                                 DoUpdateOrderExecuteEnd);
  end;

end;
procedure TFrameTakeOrder.DoGetOrderExecute(ATimerTask: TObject);
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

procedure TFrameTakeOrder.DoGetOrderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //获取订单信息成功

          //刷新订单信息
          FOrder.ParseFromJson(ASuperObject.O['Data'].A['Order'].O[0]);

          Self.LoadOrder(FOrder);

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


end.



