//convert pas to utf8 by ¥
unit uEasyServiceCommon;

interface



const

  //订单状态,要用小写,在url要用到//
  //待付款                              (待付款)
  Const_OrderState_WaitPay='wait_pay';
  //已取消                              (已取消)
  Const_OrderState_Cancelled='cancelled';
  //已付款/待审核                       (已付款/待审核)
  Const_OrderState_WaitAudit='wait_audit';
  //----忽略    审核通过/待发货         (待发货)
  Const_OrderState_WaitDelivery='wait_delivery';
  //被拒绝/审核拒绝/拒绝发货            (拒绝发货)
  Const_OrderState_AuditReject='audit_reject';
  //待收货/审核通过/已发货              (待收货)
  Const_OrderState_WaitReceive='wait_receive';
  //已完成                              (已完成)
  Const_OrderState_Done='done';



const
  //付款状态,要用小写,在url要用到//
  //未付款
  Const_PayState_WaitPay='wait_pay';
  //已付款
  Const_PayState_Payed='payed';
  //付款失败
  Const_PayState_PayFail='pay_fail';
  //不需要付款
  Const_PayState_NoNeedPay='no_need_pay';




const
  //通知大分类,要用小写,在url要用到//
  //系统公告,所有人都能看的到的消息
  Const_NoticeCalssify_System='system';
  //订单消息,订单状态更改的通知
  Const_NoticeCalssify_Order='order';
  //其他消息,如申请挂勾码、酒店审核通过、
  Const_NoticeCalssify_Other='other';
  //站内信,员工通知酒店经理
  Const_NoticeCalssify_Mail='mail';



const
  //通知的小分类,要用小写,在url要用到//
  //账号注册成功
  Const_NoticeSubType_UserRegSucc='user_reg_succ';
  //注册用户申请挂勾码
  Const_NoticeSubType_RegisterRequestBindCode='register_request_bind_code';
  //账号实名认证审核结果
  Const_NoticeSubType_UserCertAuditResult='user_cert_audit_result';
  //账号审核结果
  Const_NoticeSubType_UserAuditResult='user_audit_result';

  //酒店审核结果
  Const_NoticeSubType_HotelAuditResult='hotel_audit_result';



  //订单审核结果
  Const_NoticeSubType_OrderAuditResult='order_audit_result';
  //订单已发货
  Const_NoticeSubType_OrderDelivery='order_delivery';
  //订单完成
  Const_NoticeSubType_OrderDone='order_done';
  //订单佣金支付通知
  Const_NoticeSubType_CommissionPayed='order_commmission_payed';





const
  //付款类型//
  //线下转账
  Const_PaymentType_BankTranser='bank_transer';
  //微信支付
  Const_PaymentType_WeiXinPay='wxpay';
  //支付宝支付
  Const_PaymentType_Alipay='alipay';


//const
//  //配送类型//
//  //物流
//  Const_DeliveryType_Logistics='logistics';
//  //快递
//  Const_DeliveryType_Express='express';



type
  //不能随便改
  //审核状态
  TAuditState=( asRequestAudit=-1,        //申请审核
                asDefault=0,              //0
                asAuditPass=1,            //1审核通过
                asAuditReject=2           //2审核拒绝
                );



//获取通知分类名
function GetNoticeCalssifyName(ANoticeCalssify:String):String;
//获取审核状态
function GetAuditStateStr(AAuditState:TAuditState):String;
//获取支付方式
function GetPaymentTypeStr(APaymentType:String):String;
//获取订单状态
function GetOrderStateStr(AOrderState:String):String;
//获取付款状态
function GetPayStateStr(APayState:String):String;


implementation



function GetNoticeCalssifyName(ANoticeCalssify:String):String;
begin
  Result:='';
  if ANoticeCalssify=Const_NoticeCalssify_System then Result:='系统公告';
  if ANoticeCalssify=Const_NoticeCalssify_Order then Result:='订单消息';
//  if ANoticeCalssify=Const_NoticeCalssify_Account then Result:='账号消息';
  if ANoticeCalssify=Const_NoticeCalssify_Other then Result:='其他消息';
  if ANoticeCalssify=Const_NoticeCalssify_Mail then Result:='站内信';
end;

function GetAuditStateStr(AAuditState:TAuditState):String;
begin
  case AAuditState of
    asRequestAudit: Result:='待审核';
    asDefault: Result:='未审核';
    asAuditPass: Result:='审核通过';
    asAuditReject: Result:='审核拒绝';
  end;
end;

function GetPaymentTypeStr(APaymentType:String):String;
begin
  Result:='';
  if APaymentType=Const_PaymentType_BankTranser then Result:='线下转账';
  if APaymentType=Const_PaymentType_WeiXinPay then Result:='微信支付';
  if APaymentType=Const_PaymentType_Alipay then Result:='支付宝支付';
end;

function GetOrderStateStr(AOrderState:String):String;
begin
  Result:='';
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
//
  if AOrderState=Const_OrderState_WaitPay then Result:='待付款';
  if AOrderState=Const_OrderState_Cancelled then Result:='已取消';
  if AOrderState=Const_OrderState_WaitAudit then Result:='待审核';
  if AOrderState=Const_OrderState_WaitDelivery then Result:='待发货';
  if AOrderState=Const_OrderState_AuditReject then Result:='被拒绝';
  if AOrderState=Const_OrderState_WaitReceive then Result:='待收货';
  if AOrderState=Const_OrderState_Done then Result:='已完成';
end;

function GetPayStateStr(APayState:String):String;
begin
  Result:='';
//const
//  //付款状态,要用小写,在url要用到//
//  //未付款
//  Const_PayState_WaitPay='wait_pay';
//  //已付款
//  Const_PayState_Payed='payed';
//  //付款失败
//  Const_PayState_PayFail='pay_fail';
  if APayState=Const_PayState_WaitPay then Result:='未付款';
  if APayState=Const_PayState_Payed then Result:='已付款';
  if APayState=Const_PayState_PayFail then Result:='付款失败';
  if APayState=Const_PayState_NoNeedPay then Result:='不需要付款';
end;



end.
