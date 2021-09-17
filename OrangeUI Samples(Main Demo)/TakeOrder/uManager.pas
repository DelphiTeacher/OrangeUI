//convert pas to utf8 by ¥

unit uManager;

interface

uses
  Classes,
  SysUtils,
  IniFiles,
  Types,
  UITypes,

  Variants,
  IdURI,

//  uThumbCommon,
  uFuncCommon,
  uFileCommon,
  uBaseList,
  uDataSetToJson,
  uEasyServiceCommon,

  XSuperObject,
  XSuperJson
  ;


type
  TBaseJsonObjectClass=class of TBaseJsonObject;
  TBaseJsonObject=class(TPersistent)
  public
    constructor Create;virtual;
    function ParseFromJson(AJson: ISuperObject): Boolean;virtual;abstract;
  end;
  TBaseJsonObjectList=class(TBaseList)
  public
    procedure Assign(Source: TBaseJsonObjectList;JsonObjectClass:TBaseJsonObjectClass);
  public
    function ParseFromJsonArray(JsonObjectClass:TBaseJsonObjectClass;JsonArray:ISuperArray):Boolean;virtual;
  end;


//  //页面的使用类型
//  TFrameUseType=(futManage,     //用于管理
//                  futSelectList,//用于列表选择
//                  futViewList   //用于查看列表
//                  );


  TUser=class(TBaseJsonObject)
  public
    fid:Int64;//2,
    //appid:Int64;//1001,
    phone:String;//"18957901025",
    name:String;//"ggggcexx",
    password:String;//"123456",
    headpicpath:String;//"",
    sex:Integer;//"",

    id_code:String;//"",
    id_front_picpath:String;//"",
    id_back_picpath:String;//"",
    id_withman_picpath:String;//"",

    province:String;//"",
    city:String;//"",
    area:String;//"",
    addr:String;//"",

    phone_imei:String;//"",
    phone_uuid:String;//""
    phone_type:String;//"",

    createtime:String;//"2017-07-12 16:08:54",

    is_hotel_manager:Integer;//"",
    is_emp:Integer;//"",
    is_admin:Integer;//"",

    is_deleted:Integer;//"",
    is_leave:Integer;//"",

    cert_audit_user_fid:Int64;//0,
    cert_audit_state:Int64;//0,
    cert_audit_remark:String;//"",
    cert_audit_time:String;//"",


    bind_introducer_fid:Int64;//2,
    bind_introducer_name:String;//"",
    bind_introducer_phone:String;//"",

    audit_user_fid:Int64;//1,
    audit_state:Int64;//1,
    audit_remark:String;//"",
    audit_time:String;//"2017-07-13 07:12:40",

    remark:String;//"",
    tel:String;//"",

    notice_unread_count:Int64;//14,

    key:String;//登录令牌,用于确认用户已经登录

    region_fids:String;//管辖区域fid
    region_names:String; //管辖区域名称

//  public
//    //公司主页
//    CompanyWebUrl:String;
//    //更新网址
//    UpdateUrl:String;
//
//    //是否显示服务信息
//    IsShowServiceHint:Boolean;

  public
    function GetArea:String;
    function GetHeadPicUrl: String;
    function GetIDFrontPicUrl: String;
    function GetIDBackPicUrl: String;
    function GetIDWithManPicUrl: String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TUserList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TUser;
  public
    property Items[Index:Integer]:TUser read GetItem;default;
  end;



  //酒店收货地址
  THotelRecvAddr=class(TBaseJsonObject)
  public
    fid:Int64;//4,
    //appid:Int64;//1001,
    hotel_fid:Int64;//9,
    name:String;//"1",
    phone:String;//"18957901025",
    addr:String;//"rrrrrrrr",
    createtime:String;//"2017-07-18 17:04:31",
    is_default:Int64;//1,
    province:String;//"",
    city:String;//""
    area:String;//"",
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure Clear;
    function GetArea:String;
    function GetLongAddr:String;
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  THotelRecvAddrList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): THotelRecvAddr;
  public
    function GetDefaultRecvAddr:THotelRecvAddr;
    property Items[Index:Integer]:THotelRecvAddr read GetItem;default;
  end;




  //酒店
  THotel=class(TBaseJsonObject)
  public
    fid:Int64;//2
    //appid:Int64;//1001,
    name:String;//"国贸大酒店",
    star:Int64;//5,
    room_num:Int64;
    classify_name:String;
    classify_fid:Int64;
    tel:String;//"0579-82388888",
    user_fid:Int64;//12,
    user_name:String;

    createtime:String;//"2017-07-17 10:11:27",
    pic1path:String;//"",
    pic2path:String;//"",
    pic3path:String;//"",
    pic4path:String;//"",
    pic5path:String;//"",
    pic6path:String;//"",



    province:String;//"浙江省",
    city:String;//"金华市",
    area:String;//"",

    longitude:Double;//0,
    latitude:Double;//0,
    addr:String;//"浙江省金华市婺城区八一北街888号",

    is_ordered:Int64;//0,
    audit_user_fid:Int64;//0,
    audit_user_name:String;//admin,
    audit_state:Int64;//0,
    audit_remark:String;//"",
    audit_time:String;//"",
    is_deleted:Int64;//0,



    RecvAddrList:THotelRecvAddrList;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  public
    function GetPic1Url: String;
    function GetPic2Url: String;
    function GetPic3Url: String;
    function GetPic4Url: String;
    function GetPic5Url: String;
    function GetPic6Url: String;
    function GetArea: String;
  private
  public
    constructor Create;override;
    destructor Destroy;override;
  end;
  THotelList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): THotel;
  public
    property Items[Index:Integer]:THotel read GetItem;default;
  end;



  //商品
  TGoods=class(TBaseJsonObject)
  public
    fid:Int64;//1,
    //appid:Int64;//1001,
    name:String;//"肥皂",
    marque:String;//"小",
    is_deleted:Int64;//0,

    createtime:String;//"2017-07-22 13:04:01",
    pic1path:String;//"",
    pic2path:String;//"",
    pic3path:String;//"",
    pic4path:String;//"",
    pic5path:String;//"",
    pic6path:String;//"",
    classify_name:String;//"酒店大堂用品",
    classify_fid:Int64;//10 分类id

    price:Double;
    commission:Double;//5,
    orderno:Double;//500,

    goods_unit:String;
    code:String;//"10001",


    is_recommend:Int64;
    is_new:Int64;
    is_offsell:Int64;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure Clear;
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  public
    function GetPic1Url: String;
    function GetPic2Url: String;
    function GetPic3Url: String;
    function GetPic4Url: String;
    function GetPic5Url: String;
    function GetPic6Url: String;
  end;

  TGoodsList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TGoods;
  public
    function FindItemByFID(AFID:Integer):TGoods;
    property Items[Index:Integer]:TGoods read GetItem;default;
  end;


  //商品分类
  TGoodsClassify=class(TBaseJsonObject)
  public
    fid:Int64;//1,
    //appid:Int64;//1001,
    name:String;//"酒店大堂用品",
    orderno:Double;//"",
    createtime:String;//"2017-07-22 13:04:01",
  public
    function ParseFromJson(AJson:ISuperObject): Boolean;Override;
  end;
  TGoodsClassifyList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TGoodsClassify;
  public
    function FindItemByFID(AFID:Integer):TGoodsClassify;
    property Items[Index:Integer]:TGoodsClassify read GetItem;default;
  end;


  //酒店分类
  THotelClassify=class(TBaseJsonObject)
  public
    fid:Int64;//1,
    //appid:Int64;//1001,
    name:String;//"商务酒店",
    orderno:Double;//"",
    createtime:String;//"2017-07-22 13:04:01",
  public
    function ParseFromJson(AJson:ISuperObject): Boolean;Override;
  end;
  THotelClassifyList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): THotelClassify;
  public
    function FindItemByFID(AFID:Integer):THotelClassify;
    property Items[Index:Integer]:THotelClassify read GetItem;default;
  end;





  //用户银行卡
  TBankCard=Class(TBaseJsonObject)
  public
    fid:Int64;//1,
    //appid:Int64;//1001,
    name:String;
    bankname:String;
    account:String;
    createtime:String;
    is_default:Int64;
    is_deleted:Int64;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure Clear;
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TBankCardList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TBankCard;
  public
    property Items[Index:Integer]:TBankCard read GetItem;default;
  end;


  //通知
  TNotice=class(TBaseJsonObject)
  public
    fid:Int64;//1,
    //appid:Int64;//1001,
    sender_fid:Int64;
    notice_classify:String;
    notice_sub_type:String;
    caption:String;

    content:String;
    content_html_filepath:String;
    content_url:String;

    custom_data_json:String;
    createtime:String;
    is_deleted:Int64;

    is_readed:Int64;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TNoticeList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TNotice;
  public
    property Items[Index:Integer]:TNotice read GetItem;default;
  end;




  //通知分类
  TNoticeClassify=class(TBaseJsonObject)
  public
    notice_classify:String;
    notice_classify_count:Int64;
    notice_classify_name:String;
    notice_classify_unread_count:Int64;

//    RecentNotice:TNotice;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  public
    constructor Create;override;
    destructor Destroy;override;
  end;

  TNoticeClassifyList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TNoticeClassify;
  public
    property Items[Index:Integer]:TNoticeClassify read GetItem;default;
  end;



  //选择的商品
  TBuyGoods=class(TGoods)
  public
    goods_fid:Int64;
    number:Int64;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  end;
  TBuyGoodsList=class(TGoodsList)
  private
    function GetItem(Index: Integer): TBuyGoods;
  public
    property Items[Index:Integer]:TBuyGoods read GetItem;default;
  end;




  //购物车商品项
  TUserCartGoods=class(TBuyGoods)
  public
    user_cart_goods_fid:Int64;
    user_fid:Int64;
    is_checked:Int64;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TUserCartGoodsList=class(TBuyGoodsList)
  private
    function GetItem(Index: Integer): TUserCartGoods;
  public
    function FindItemByUserCartGoodsFID(AUserCartGoodsFID:Integer):TUserCartGoods;
    property Items[Index:Integer]:TUserCartGoods read GetItem;default;
  end;




   //区域管理省份
  TRegionProvince=class(TBaseJsonObject)
  public
    fid:Int64;
    //appid:Int64;
    regin_fid:Int64;
    name:String;
//    orderno:String;
    createtime:String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TRegionProvinceList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TRegionProvince;
  public
    property Items[Index:Integer]:TRegionProvince read GetItem;default;
  end;



  //订单商品
  TOrderGoods=class(TBuyGoods)
  public
    order_fid:Int64;//6,
    order_goods_price:Double;//18,
    order_goods_commission:Double;//5,
    order_goods_orderno:Double;//0
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TOrderGoodsList=class(TBuyGoodsList)
  private
    function GetItem(Index: Integer): TOrderGoods;
  public
    property Items[Index:Integer]:TOrderGoods read GetItem;default;
  end;



  //汇总的条件
  TSummaryFilterType=(sftDateArea,
                     sftMonth,
                     sftCustom,
                     sftRegion,
                     sftManager,
                     sftIsPay,
                     sftHotel
                    );
  TSummaryFilterItem=class
    FFilterType:TSummaryFilterType;
    //过滤名称
    FFilterName:String;
    //过滤值
    FFilterValue:String;
    //过滤值的标题
    FFilterValueCaption:String;
    FFilterValue1:String;

    FFilterSelections:TStringList;
    FFilterSelectionsCaption:TStringList;
    //条件的标题
    function GetCaption:String;
  public
    constructor Create;
    destructor Destroy;override;
  end;
  TSummaryFilterList=class(TBaseList)
  private
    function GetItem(Index: Integer): TSummaryFilterItem;
  public
    function FindItemByFilterName(AFilterName:String):TSummaryFilterItem;
    property Items[Index:Integer]:TSummaryFilterItem read GetItem;default;
  end;



  //商品汇总
  TGoodsSummary=class(TBaseJsonObject)
  public
    summoney:Double;
    sumnumber:Int64;
    sumcount:Int64;
    goods_fid:Int64;
    caption:String;
    goods_unit:String;
    region_fid:Int64;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TGoodsSummaryList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TGoodsSummary;
  public
    property Items[Index:Integer]:TGoodsSummary read GetItem;default;
  end;


  //商品汇总单据
  TGoodsSummaryBill=class(TBaseJsonObject)
  public
    fid:Int64;
    //appid:Int64;
    order_fid:Int64;
    goods_fid:Int64;
    number:Int64;
    price:Double;
    orderno:Int64;
    createtime:String;
    commission:Int64;
    goods_name:String;
    marque:String;
    goods_unit:String;
    goods_code:String;
    goods_classify_fid:Int64;
    goods_classify_name:String;
    bill_code:String;
    hotel_fid:Int64;
    user_fid:Int64;
    goods_origin_summoney:Double;
    goods_summoney:Double;
    summoney:Double;
    goods_sum_commission:Int64;
    done_time:String;
    goods_kind_num:Int64;
    goods_num:Int64;
    is_deleted:Int64;
    is_first_order:Int64;
    order_date:String;
    order_month:String;
    order_year:String;
    hotel_name:String;
    hotel_star:Int64;
    hotel_user_fid:Int64;
    hotel_province:String;
    user_phone:String;
    user_name:String;
    region_fid:Int64;
    region_name:String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TGoodsSummaryBillList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TGoodsSummaryBill;
  public
    property Items[Index:Integer]:TGoodsSummaryBill read GetItem;default;
  end;


  //订单单据汇总
  TOrderSummaryBill=class(TBaseJsonObject)
  public
    fid:Int64;
    //appid:Int64;
    bill_code:String;
    hotel_fid:Int64;
    user_fid:Int64;
    goods_origin_summoney:Double;
    goods_summoney:Double;
    freight:Int64;
    summoney:Double;
    goods_sum_commission:Int64;
    recv_addr_fid:Int64;
    recv_name:String;
    recv_phone:String;
    recv_province:String;
    recv_city:String;
    recv_area:String;
    recv_addr:String;
    remark:String;
    createtime:String;
    done_time:String;
    order_state:String;
    pay_state:String;
    is_deleted:Int64;
    is_first_order:Int64;
    goods_kind_num:Int64;
    goods_num:Int64;
    is_hide:Int64;
    reduce:Int64;
    order_date:String;
    order_month:String;
    order_year:String;
    hotel_name:String;
    hotel_star:Int64;
    hotel_addr:String;
    hotel_tel:String;
    hotel_user_fid:Int64;
    hotel_province:String;
    hotel_city:String;
    hotel_area:String;
    hotel_is_ordered:Int64;
    user_phone:String;
    user_name:String;
    region_fid:Int64;
    region_name:String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TOrderSummaryBillList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TOrderSummaryBill;
  public
    property Items[Index:Integer]:TOrderSummaryBill read GetItem;default;
  end;


  //订单
  TOrder=class(TBaseJsonObject)
  public
    fid:Int64;//6,
    //appid:Int64;//1001,
    bill_code:String;//"",
    hotel_fid:Int64;//2,
    hotel_name:String;//"",
    user_fid:Int64;//12,
    user_name:String;//"",
    introducer_name:String;//"丁丽花",
    goods_summoney:Double;//0,
    goods_origin_summoney:Double;//210,
    goods_sum_commission:Double;//60,
    freight:Double;
    reduce:Double;
    summoney:Double;//0,
    goods_kind_num:Int64;
    goods_num:Int64;
    recv_addr_fid:Int64;//0,
    recv_name:String;//"王能",
    recv_phone:String;//"18957901025",
    recv_province:String;//"",
    recv_city:String;//"",
    recv_area:String;//"",
    recv_addr:String;//"浙江省金华市婺城区丹溪路1171号826室",
    remark:String;//"快点发货",

    transer_bankaccount_name:String;
    transer_bankaccount_bankname:String;
    transer_bankaccount_account:String;
    transer_payment_voucher:String;

    manager_commission:Double;
    introducer_commission:Double;

    createtime:String;//"2017-07-17 17:26:13",
    order_state:String;//"done",

    is_pay_manager:Int64;
    is_pay_introducer:Int64;

    is_deleted:Int64;//0,
    is_first_order:Int64;//1,
    audit_user_fid:Int64;//1,
    audit_user_name:String;//admin,
    audit_state:Int64;//1,
    audit_remark:String;//"可以给他发货了",
    audit_time:String;//"2017-07-18 11:10:23",
    source:String;//"浏览器端",
    pay_state:String;//"wait_pay",

    OrderGoodsList:TOrderGoodsList;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  public
    constructor Create;override;
    destructor Destroy;override;
  end;
  TOrderList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TOrder;
  public
    property Items[Index:Integer]:TOrder read GetItem;default;
  end;




  //订单付款
  TOrderPayment=class(TBaseJsonObject)
  public
    fid:Int64;//5,
    //appid:Int64;//1001,
    order_fid:Int64;//6,
    user_fid:Int64;//12,
    payment_type:String;//"bank_transer",
    transer_time:String;//"2017-07-30 00:00:00",
    transer_bankaccount_name:String;//"王能",
    transer_bankaccount_bankname:String;//"建行",
    transer_bankaccount_account:String;//"6443556555432232",
    transer_payment_voucher:String;//"123456789",
    money:Double;//100.1,
    remark:String;//"",
    pay_state:String;
    pic1path:String;//"",
    pic2path:String;//"",
    pic3path:String;//"",
    pic4path:String;//"",
    pic5path:String;//"",
    pic6path:String;//"",
    audit_user_fid:Int64;//0,
    audit_state:Int64;//0,
    audit_time:String;//"",
    audit_remark:String;//"",
    createtime:String;//"2017-08-02 15:22:57"
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  public
    function GetPic1Url: String;
    function GetPic2Url: String;
    function GetPic3Url: String;
    function GetPic4Url: String;
    function GetPic5Url: String;
    function GetPic6Url: String;
  end;

  TOrderPaymentList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TOrderPayment;
  public
    property Items[Index:Integer]:TOrderPayment read GetItem;default;
  end;


  //订单发货
  TOrderDelivery=class(TBaseJsonObject)
  public
    fid:Int64;
    //appid:Int64;
    order_fid:Int64;
    emp_fid:Int64;
    delivery_type:String;
    delivery_company:String;
    delivery_bill_code:String;
    createtime:String;
    remark:String;
    delivery_time:String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TOrderDeliveryList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TOrderDelivery;
  public
    property Items[Index:Integer]:TOrderDelivery read GetItem;default;
  end;



  //区域管理
  TRegion=class(TBaseJsonObject)
  public
    fid:Int64;
    //appid:Int64;
    name:String;
    orderno:String;
    manager_fid:Int64;
    manager_name:String;
    createtime:String;

    RegionProvinceList:TRegionProvinceList;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  public
    constructor Create;override;
    destructor Destroy;override;
  end;
  TRegionList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TRegion;
  public
    property Items[Index:Integer]:TRegion read GetItem;default;
  end;

  //广告
  THomeAd=class(TBaseJsonObject)
  public
    fid:Int64;//3,
    //appid:Int64;//1001,
    name:String;//"首页广告3",
    picpath:String;//"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3355283602,2380210295",
    url:String;//"http://www.baidu.com",
    goods_fid:Int64;//0,
    orderno:Int64;//0,
    goods_name:String;//'饮水机'
    createtime:String;//"2017-08-05 23:31:25",
    is_deleted:Int64;
    content:string;
  public
    function GetPicUrl: String;//0
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  THomeAdList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): THomeAd;
  public
    property Items[Index:Integer]:THomeAd read GetItem;default;
  end;


  //佣金
  TUserBillMoney=class(TBaseJsonObject)
  public
    fid:Int64;
    //appid:Int64;
    user_fid:Int64;
    bill_fid:Int64;
    bill_type:String;
    bill_code:String;
    from_hotel_fid:Int64;
    from_user_fid:Int64;
    manager_rate:Double;
    introducer_rate:Double;
    is_introducer:Int64;
    money:Double;
    createtime:String;
    from_user_name:String;
    from_hotel_name:String;
    is_pay:Int64;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TUserBillMoneyList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TUserBillMoney;
  public
    property Items[Index:Integer]:TUserBillMoney read GetItem;default;
  end;




  TManager=class
  public

    //用户名
    LastLoginUser:String;
    //密码
    LastLoginPass:String;


    //用户信息
    User:TUser;

    //购物车商品列表
    UserCartGoodsList:TUserCartGoodsList;

    //登录过的用户
    LoginedUserList:TStringList;

    //购物车商品搜索历史列表
    BuyGoodsSearchHistoryList:TStringList;

    //商品搜索历史列表
    GoodsSearchHistoryList:TStringList;

    //用户搜索列表
    UserSearchHistoryList:TStringList;

  public
    function LoadFromINI(AINIFilePath: String): Boolean;
    function SaveToINI(AINIFilePath: String): Boolean;
  public
    constructor Create;
    destructor Destroy;override;
  public
    procedure Load;
    procedure Save;
  public
    //存放搜索历史的目录
    function GetUserLocalDir:String;
    //加载本地搜索历史
    procedure LoadUserConfig;
    //保存本地搜索历史
    procedure SaveUserConfig;
  end;




var
  GlobalManager:TManager;
var
  //当前客户端版本号
//  CurrentVersion:String;
  //接口地址
  InterfaceUrl:String;
  //图片上传下载url
  ImageHttpServerUrl:String;
  //宜服应用ID
  AppID:Integer;

  //签到/定位
  UploadLocationCaption:String;

//  //安卓服务的包名
//  AndroidServicePackage:String;
//  //安卓服务的标题
//  AndroidServiceNotificationTitle:String;
//  //安卓服务的内容
//  AndroidServiceNotificationMessage:String;
//
//
//  //是否有自动签到功能
//  HasAutoUploadLocationFunction:Boolean;

function GetAuditStateColor(AAuditState:TAuditState;AAuditRejectColor:TAlphaColor=TAlphaColorRec.Red):TAlphaColor;


function HideBankCardNumber( num:string ):String;

implementation

function HideBankCardNumber( num:string ):String;
var
  I: Integer;
begin
  Result:=num;
  for I := Low(num) to High(num)-4 do
  begin
    Result[I]:='*';
  end;
end;

function GetAuditStateColor(AAuditState:TAuditState;AAuditRejectColor:TAlphaColor):TAlphaColor;
begin
  Result:=TAlphaColorRec.Gray;

  //根据审核状态设置标题的颜色
  if AAuditState=asRequestAudit then
  begin
    Result:=TAlphaColorRec.Orange;
  end
  else if AAuditState=asAuditPass then
  begin
    Result:=$FF1296db;//#FF35B34A
  end
  else if AAuditState=asAuditReject then
  begin
    Result:=AAuditRejectColor;//TAlphaColorRec.Red;
  end
  else
  begin
    Result:=TAlphaColorRec.Gray;
  end;

end;


{ TManager }

constructor TManager.Create;
begin
  User:=TUser.Create;
  LoginedUserList:=TStringList.Create;
  UserCartGoodsList:=TUserCartGoodsList.Create;
  BuyGoodsSearchHistoryList:=TStringList.Create;
  GoodsSearchHistoryList:=TStringList.Create;
  UserSearchHistoryList:=TStringList.Create;
end;

destructor TManager.Destroy;
begin
  uFuncCommon.FreeAndNil(User);
  uFuncCommon.FreeAndNil(LoginedUserList);
  uFuncCommon.FreeAndNil(UserCartGoodsList);
  uFuncCommon.FreeAndNil(BuyGoodsSearchHistoryList);
  uFuncCommon.FreeAndNil(GoodsSearchHistoryList);
  uFuncCommon.FreeAndNil(UserSearchHistoryList);
  inherited;
end;

function TManager.GetUserLocalDir: String;
begin
  Result:=uFileCommon.GetApplicationPath+IntToStr(Self.User.fid)+PathDelim;
end;

procedure TManager.Load;
begin
  Self.LoadFromINI(uFileCommon.GetApplicationPath+'Config.ini');

end;

function TManager.LoadFromINI(AINIFilePath: String): Boolean;
var
  AIniFile:TIniFile;
begin
  Result:=False;

  AIniFile:=TIniFile.Create(AINIFilePath);

  Self.LastLoginUser:=AIniFile.ReadString('','LastLoginUser','');
  Self.LastLoginPass:=AIniFile.ReadString('','LastLoginPass','');

//  Self.User.UpdateUrl:=AIniFile.ReadString('','UpdateUrl','');

  Self.LoginedUserList.CommaText:=AIniFile.ReadString('','LoginedUser','');

  uFuncCommon.FreeAndNil(AIniFile);


  Result:=True;

end;

procedure TManager.LoadUserConfig;
begin
  BuyGoodsSearchHistoryList.Clear;
  if FileExists(GetUserLocalDir+'BuyGoodsSearchHistory.txt') then
  begin
    BuyGoodsSearchHistoryList.LoadFromFile(GetUserLocalDir+'BuyGoodsSearchHistory.txt',TEncoding.UTF8);
  end;

  GoodsSearchHistoryList.Clear;
  if FileExists(GetUserLocalDir+'GoodsSearchHistory.txt') then
  begin
    GoodsSearchHistoryList.LoadFromFile(GetUserLocalDir+'GoodsSearchHistory.txt',TEncoding.UTF8);
  end;

  UserSearchHistoryList.Clear;
  if FileExists(GetUserLocalDir+'UserSearchHistory.txt') then
  begin
    UserSearchHistoryList.LoadFromFile(GetUserLocalDir+'UserSearchHistory.txt',TEncoding.UTF8);
  end;

end;

procedure TManager.Save;
begin
  Self.SaveToINI(uFileCommon.GetApplicationPath+'Config.ini');

end;

function TManager.SaveToINI(AINIFilePath: String): Boolean;
var
  AIniFile:TIniFile;
begin
  Result:=False;
  AIniFile:=TIniFile.Create(AINIFilePath);

  AIniFile.WriteString('','LastLoginUser',Self.LastLoginUser);
  AIniFile.WriteString('','LastLoginPass',Self.LastLoginPass);

//  //更新网址
//  AIniFile.WriteString('','UpdateUrl',Self.User.UpdateUrl);

  AIniFile.WriteString('','LoginedUser',Self.LoginedUserList.CommaText);

  uFuncCommon.FreeAndNil(AIniFile);
  Result:=True;

end;


procedure TManager.SaveUserConfig;
begin
  ForceDirectories(GetUserLocalDir);
  BuyGoodsSearchHistoryList.SaveToFile(GetUserLocalDir+'BuyGoodsSearchHistory.txt',TEncoding.UTF8);

  GoodsSearchHistoryList.SaveToFile(GetUserLocalDir+'GoodsSearchHistory.txt',TEncoding.UTF8);

  UserSearchHistoryList.SaveToFile(GetUserLocalDir+'UserSearchHistory.txt',TEncoding.UTF8)
end;

{ TBaseJsonObjectList }

procedure TBaseJsonObjectList.Assign(Source: TBaseJsonObjectList;
  JsonObjectClass: TBaseJsonObjectClass);
var
  I:Integer;
  ABaseJsonObject:TBaseJsonObject;
begin

  Self.Clear(True);
  for I := 0 to Source.Count - 1 do
  begin
    ABaseJsonObject:=JsonObjectClass.Create();
    ABaseJsonObject.Assign(TPersistent(Source.Items[I]));
    Self.Add(ABaseJsonObject);
  end;

end;

function TBaseJsonObjectList.ParseFromJsonArray(JsonObjectClass:TBaseJsonObjectClass;JsonArray: ISuperArray): Boolean;
var
  I:Integer;
  ABaseJsonObject:TBaseJsonObject;
begin
  Result:=False;

  for I := 0 to JsonArray.Length - 1 do
  begin
    ABaseJsonObject:=JsonObjectClass.Create();
    ABaseJsonObject.ParseFromJson(JsonArray.O[I]);
    Self.Add(ABaseJsonObject);
  end;

  Result:=True;
end;

{ TBaseJsonObject }

constructor TBaseJsonObject.Create;
begin

end;


{ TUser }

function TUser.GetArea: String;
begin
  Result:=Self.province+' '+Self.city+' '+Self.area;
end;

function TUser.GetHeadPicUrl: String;
begin
  if HeadPicPath='' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/UserHead/'+'default.png';
  end
  else
  begin
    Result:=ImageHttpServerUrl+'/Upload/UserHead/'+Self.HeadPicPath;
  end;
end;

function TUser.GetIDBackPicUrl: String;
begin
  Result:='';
  if id_back_picpath<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/ID_Pic/'+Self.id_back_picpath;
  end;
end;

function TUser.GetIDFrontPicUrl: String;
begin
  Result:='';
  if id_front_picpath<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/ID_Pic/'+Self.id_front_picpath;
  end;
end;

function TUser.GetIDWithManPicUrl: String;
begin
  Result:='';
  if id_withman_picpath<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/ID_Pic/'+Self.id_withman_picpath;
  end;
end;


function TUser.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//2,
  //Self.appid:=AJson.I['appid'];//1001,
  phone:=AJson.S['phone'];//"18957901025",
  name:=AJson.S['name'];//"ggggcexx",
  id_code:=AJson.S['id_code'];//"",
  id_front_picpath:=AJson.S['id_front_picpath'];//"",
  id_back_picpath:=AJson.S['id_back_picpath'];//"",
  id_withman_picpath:=AJson.S['id_withman_picpath'];//"",
  province:=AJson.S['province'];//"",
  city:=AJson.S['city'];//"",
  area:=AJson.S['area'];//"",
  phone_imei:=AJson.S['phone_imei'];//"",
  phone_uuid:=AJson.S['phone_uuid'];//""
  addr:=AJson.S['addr'];//"",
  phone_type:=AJson.S['phone_type'];//"",
  password:=AJson.S['password'];//"123456",
  headpicpath:=AJson.S['headpicpath'];//"",
  createtime:=AJson.S['createtime'];//"2017-07-12 16:08:54",
  sex:=AJson.I['sex'];//"",
  is_hotel_manager:=AJson.I['is_hotel_manager'];//"",
  is_emp:=AJson.I['is_emp'];//"",
  is_admin:=AJson.I['is_admin'];//"",
  is_deleted:=AJson.I['is_deleted'];//"",
  is_leave:=AJson.I['is_leave'];//"",

  cert_audit_user_fid:=AJson.I['cert_audit_user_fid'];//0,
  cert_audit_state:=AJson.I['cert_audit_state'];//0,
  cert_audit_remark:=AJson.S['cert_audit_remark'];//"",
  cert_audit_time:=AJson.S['cert_audit_time'];//"",

//  is_valid_manager:=AJson.I['is_valid_manager'];//"",
  bind_introducer_fid:=AJson.I['bind_introducer_fid'];//2,
  bind_introducer_name:=AJson.S['bind_introducer_name'];//"",
  bind_introducer_phone:=AJson.S['bind_introducer_phone'];//"",

  audit_user_fid:=AJson.I['audit_user_fid'];//1,
  audit_state:=AJson.I['audit_state'];//1,
  audit_remark:=AJson.S['audit_remark'];//"",
  audit_time:=AJson.S['audit_time'];//"2017-07-13 07:12:40",

  remark:=AJson.S['remark'];//"",
  tel:=AJson.S['tel'];//"",

  notice_unread_count:=AJson.I['notice_unread_count'];

  region_fids:=AJson.S['region_fids'];//管辖区域fid
  region_names:=AJson.S['region_names']; //管辖区域名称
end;


{ TUserList }

function TUserList.GetItem(Index: Integer): TUser;
begin
  Result:=TUser(Inherited Items[Index]);
end;

{ THotelList }

function THotelList.GetItem(Index: Integer): THotel;
begin
  Result:=THotel(Inherited Items[Index]);
end;

{ THotel }

constructor THotel.Create;
begin
  inherited;
  RecvAddrList:=THotelRecvAddrList.Create;

end;

destructor THotel.Destroy;
begin
  FreeAndNil(RecvAddrList);
  inherited;
end;

function THotel.GetPic1Url: String;
begin
  Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Hotel_Pic/'+Self.pic1path;
  end;

end;

function THotel.GetPic2Url: String;
begin
  Result:='';
  if Self.pic2path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Hotel_Pic/'+Self.pic2path;
  end;
end;

function THotel.GetPic3Url: String;
begin
  Result:='';
  if Self.pic3path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Hotel_Pic/'+Self.pic3path;
  end;
end;

function THotel.GetPic4Url: String;
begin
  Result:='';
  if Self.pic4path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Hotel_Pic/'+Self.pic4path;
  end;
end;

function THotel.GetPic5Url: String;
begin
  Result:='';
  if Self.pic5path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Hotel_Pic/'+Self.pic5path;
  end;
end;

function THotel.GetPic6Url: String;
begin
  Result:='';
  if Self.pic6path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Hotel_Pic/'+Self.pic6path;
  end;
end;

function THotel.GetArea: String;
begin
  Result:=Self.province+' '+Self.city+' '+Self.area;
end;

function THotel.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//2
  //Self.appid:=AJson.I['appid'];//1001,
  name:=AJson.S['name'];//"国贸大酒店",
  star:=AJson.I['star'];//5,
  room_num:=AJson.I['room_num'];
  classify_name:=AJson.S['classify_name'];
  classify_fid:=AJson.I['classify_fid'];
  addr:=AJson.S['addr'];//"浙江省金华市婺城区八一北街888号",
  tel:=AJson.S['tel'];//"0579-82388888",
  user_fid:=AJson.I['user_fid'];//12,
  user_name:=AJson.S['user_name'];
  createtime:=AJson.S['createtime'];//"2017-07-17 10:11:27",
  pic1path:=AJson.S['pic1path'];//"",
  pic2path:=AJson.S['pic2path'];//"",
  pic3path:=AJson.S['pic3path'];//"",
  pic4path:=AJson.S['pic4path'];//"",
  pic5path:=AJson.S['pic5path'];//"",
  pic6path:=AJson.S['pic6path'];//"",
  province:=AJson.S['province'];//"浙江省",

  city:=AJson.S['city'];//"金华市",
  area:=AJson.S['area'];//"",
  is_ordered:=AJson.I['is_ordered'];//0,
  audit_user_fid:=AJson.I['audit_user_fid'];//0,
  audit_state:=AJson.I['audit_state'];//0,
  audit_remark:=AJson.S['audit_remark'];//"",
  audit_time:=AJson.S['audit_time'];//"",
  is_deleted:=AJson.I['is_deleted'];//0,
//  recv_addr_id:=AJson.I['recv_addr_id'];//0,
//  longitude:=GetJsonDoubleValue(AJson,'longitude');//0,
//  latitude:=GetJsonDoubleValue(AJson,'latitude');//0,

  RecvAddrList.Clear(True);
  Self.RecvAddrList.ParseFromJsonArray(THotelRecvAddr,AJson.A['HotelRecvAddrList']);
end;



{ THotelRecvAddr }

procedure THotelRecvAddr.AssignTo(Dest: TPersistent);
begin
  if Dest is THotelRecvAddr then
  begin

    THotelRecvAddr(Dest).fid:=fid;//4,
//    THotelRecvAddr(Dest).appid:=appid;//1001,
    THotelRecvAddr(Dest).hotel_fid:=hotel_fid;//9,
    THotelRecvAddr(Dest).name:=name;//"1",
    THotelRecvAddr(Dest).phone:=phone;//"18957901025",
    THotelRecvAddr(Dest).addr:=addr;//"rrrrrrrr",
    THotelRecvAddr(Dest).createtime:=createtime;//"2017-07-18 17:04:31",
    THotelRecvAddr(Dest).is_default:=is_default;//1,
    THotelRecvAddr(Dest).province:=province;//"",
    THotelRecvAddr(Dest).city:=city;//""
    THotelRecvAddr(Dest).area:=area;//""

  end;

end;

procedure THotelRecvAddr.Clear;
begin

  fid:=0;//4,
  //Self.appid:=0;//1001,
  hotel_fid:=0;//9,
  name:='';//"1",
  phone:='';//"18957901025",
  addr:='';//"rrrrrrrr",
  createtime:='';//"2017-07-18 17:04:31",
  is_default:=0;//1,
  province:='';//"",
  city:='';//""
  area:='';//""

end;

function THotelRecvAddr.GetArea: String;
begin
  Result:=Self.province+' '+Self.city+' '+Self.area;
end;

function THotelRecvAddr.GetLongAddr: String;
begin
  Result:=Self.province+Self.city+Self.area+Self.addr;
end;

function THotelRecvAddr.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//4,
  //Self.appid:=AJson.I['appid'];//1001,
  hotel_fid:=AJson.I['hotel_fid'];//9,
  name:=AJson.S['name'];//"1",
  phone:=AJson.S['phone'];//"18957901025",
  addr:=AJson.S['addr'];//"rrrrrrrr",
  createtime:=AJson.S['createtime'];//"2017-07-18 17:04:31",
  is_default:=AJson.I['is_default'];//1,
  province:=AJson.S['province'];//"",
  city:=AJson.S['city'];//""
  area:=AJson.S['area'];//""
end;

{ THotelRecvAddrList }

function THotelRecvAddrList.GetDefaultRecvAddr: THotelRecvAddr;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].is_default=1 then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function THotelRecvAddrList.GetItem(Index: Integer): THotelRecvAddr;
begin
  Result:=THotelRecvAddr(Inherited Items[Index]);
end;

{ TGoods }


procedure TGoods.AssignTo(Dest: TPersistent);
begin
  if Dest is TGoods then
  begin
    TGoods(Dest).fid:=fid;
//    TGoods(Dest).appid:=appid;//1001,
    TGoods(Dest).name:=name;//"肥皂",
    TGoods(Dest).marque:=marque;//"小",
    TGoods(Dest).is_deleted:=is_deleted;//0,

    TGoods(Dest).createtime:=createtime;//"2017-07-22 13:04:01",
    TGoods(Dest).pic1path:=pic1path;//"",
    TGoods(Dest).pic2path:=pic2path;//"",
    TGoods(Dest).pic3path:=pic3path;//"",
    TGoods(Dest).pic4path:=pic4path;//"",
    TGoods(Dest).pic5path:=pic5path;//"",
    TGoods(Dest).pic6path:=pic6path;//"",
    TGoods(Dest).classify_name:=classify_name;//"酒店大堂用品",
    TGoods(Dest).classify_fid:=classify_fid;//分类id,

    TGoods(Dest).price:=price;
    TGoods(Dest).commission:=commission;//5,
    TGoods(Dest).orderno:=orderno;//500,

    TGoods(Dest).goods_unit:=goods_unit;
    TGoods(Dest).code:=code;//"10001",

    TGoods(Dest).is_recommend:=is_recommend;
    TGoods(Dest).is_new:=is_new;
    TGoods(Dest).is_offsell:=is_offsell;
  end;
end;

procedure TGoods.Clear;
begin
  fid:=0;//1,
  //Self.appid:=0;//1001,
  name:='';//"肥皂",
  marque:='';//"小",
  is_deleted:=0;//0,

  createtime:='';//"2017-07-22 13:04:01",
  pic1path:='';//"",
  pic2path:='';//"",
  pic3path:='';//"",
  pic4path:='';//"",
  pic5path:='';//"",
  pic6path:='';//"",
  classify_name:='';//"酒店大堂用品",
  classify_fid:=0;//分类id

  price:=0;
  commission:=0;//5,
  orderno:=0;//500,

  goods_unit:='';
  code:='';//"10001",


  is_recommend:=0;
  is_new:=0;
  is_offsell:=0;

end;

function TGoods.GetPic1Url: String;
begin
   Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Goods_Pic/'+Self.pic1path;
  end;
end;

function TGoods.GetPic2Url: String;
begin
  Result:='';
  if Self.pic2path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Goods_Pic/'+Self.pic2path;
  end;
end;

function TGoods.GetPic3Url: String;
begin
  Result:='';
  if Self.pic3path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Goods_Pic/'+Self.pic3path;
  end;
end;

function TGoods.GetPic4Url: String;
begin
  Result:='';
  if Self.pic4path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Goods_Pic/'+Self.pic4path;
  end;
end;
function TGoods.GetPic5Url: String;
begin
  Result:='';
  if Self.pic5path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Goods_Pic/'+Self.pic5path;
  end;
end;

function TGoods.GetPic6Url: String;
begin
  Result:='';
  if Self.pic6path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Goods_Pic/'+Self.pic6path;
  end;
end;
function TGoods.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//2
  //Self.appid:=AJson.I['appid'];//1001,
  name:=AJson.S['name'];
  marque:=AJson.S['marque'];
  is_deleted:=AJson.I['is_deleted'];

  createtime:=AJson.S['createtime'];//"2017-07-17 10:11:27",
  pic1path:=AJson.S['pic1path'];//"",
  pic2path:=AJson.S['pic2path'];//"",
  pic3path:=AJson.S['pic3path'];//"",
  pic4path:=AJson.S['pic4path'];//"",
  pic5path:=AJson.S['pic5path'];//"",
  pic6path:=AJson.S['pic6path'];//"",
  classify_name:=AJson.S['classify_name'];//"酒店大堂用品",
  classify_fid:=AJson.I['classify_fid'];//分类id

  price:=GetJsonDoubleValue(AJson,'price');
  commission:=GetJsonDoubleValue(AJson,'commission');
  orderno:=GetJsonDoubleValue(AJson,'orderno');

  goods_unit:=AJson.S['unit'];
  code:=AJson.S['goods_code'];

  is_recommend:=AJson.I['is_recommend'];
  is_new:=AJson.I['is_new'];
  is_offsell:=AJson.I['is_offsell'];

end;

{ TGoodsList }

function TGoodsList.FindItemByFID(AFID: Integer): TGoods;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.GetCount-1 do
  begin
    if Self.Items[I].fid=AFID then
    begin
      Result:=Self.Items[I];
      Break;
    end;
  end;
end;

function TGoodsList.GetItem(Index: Integer): TGoods;
begin
  Result:=TGoods(Inherited Items[Index]);
end;

{ TBankCard }

procedure TBankCard.AssignTo(Dest: TPersistent);
begin
  if Dest is TBankCard then
  begin
    TBankCard(Dest).fid:=fid;//1,
//    TBankCard(Dest).appid:=appid;//1001,
    TBankCard(Dest).name:=name;
    TBankCard(Dest).bankname:=bankname;
    TBankCard(Dest).account:=account;
    TBankCard(Dest).createtime:=createtime;
    TBankCard(Dest).is_default:=is_default;
    TBankCard(Dest).is_deleted:=is_deleted;
  end;
end;

procedure TBankCard.Clear;
begin
  fid:=0;//1,
  //Self.appid:=0;//1001,
  name:='';
  bankname:='';
  account:='';
  createtime:='';
  is_default:=0;
  is_deleted:=0;

end;

function TBankCard.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//2
  //Self.appid:=AJson.I['appid'];//1001,
  name:=AJson.S['name'];
  bankname:=AJson.S['bankname'];
  account:=AJson.S['account'];
  createtime:=AJson.S['createtime'];
  is_default:=AJson.I['is_default'];
  is_deleted:=AJson.I['is_deleted'];

end;

{ TBankCardList }

function TBankCardList.GetItem(Index: Integer): TBankCard;
begin
  Result:=TBankCard(Inherited Items[Index]);
end;

{ TUserCartGoodsList }

function TUserCartGoodsList.FindItemByUserCartGoodsFID(
  AUserCartGoodsFID: Integer): TUserCartGoods;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.GetCount-1 do
  begin
    if Self.Items[I].user_cart_goods_fid=AUserCartGoodsFID then
    begin
      Result:=Self.Items[I];
      Break;
    end;
  end;
end;

function TUserCartGoodsList.GetItem(Index: Integer): TUserCartGoods;
begin
  Result:=TUserCartGoods(Inherited Items[Index]);
end;

{ TUserCartGoods }

procedure TUserCartGoods.AssignTo(Dest: TPersistent);
begin
  inherited;
  if Dest is TUserCartGoods then
  begin
    TUserCartGoods(Dest).user_cart_goods_fid:=user_cart_goods_fid;
    TUserCartGoods(Dest).user_fid:=user_fid;
    TUserCartGoods(Dest).goods_fid:=goods_fid;
    TUserCartGoods(Dest).number:=number;
    TUserCartGoods(Dest).is_checked:=is_checked;
  end;
end;

function TUserCartGoods.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  Inherited;

  user_cart_goods_fid:=AJson.I['user_cart_goods_fid'];//2
  user_fid:=AJson.I['user_fid'];//12
  goods_fid:=AJson.I['goods_fid'];
  number:=AJson.I['number'];
  is_checked:=AJson.I['is_checked'];

end;

{ TNotice }

function TNotice.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//2
  //Self.appid:=AJson.I['appid'];//1001,
  sender_fid:=AJson.I['sender_fid'];
  notice_classify:=AJson.S['notice_classify'];
  notice_sub_type:=AJson.S['notice_sub_type'];
  caption:=AJson.S['caption'];
  content:=AJson.S['content'];
  content_html_filepath:=AJson.S['content_html_filepath'];
  custom_data_json:=AJson.S['custom_data_json'];
  content_url:=AJson.S['content_url'];
  createtime:=AJson.S['createtime'];
  is_deleted:=AJson.I['is_deleted'];

//  is_readed:=StrToInt(AJson.S['is_readed']);
  is_readed:=AJson.I['is_readed'];
end;

{ TNoticeList }

function TNoticeList.GetItem(Index: Integer): TNotice;
begin
  Result:=TNotice(Inherited Items[Index]);
end;

{ TNoticeClassify }

constructor TNoticeClassify.Create;
begin
  inherited;
//  RecentNotice:=TNotice.Create;
end;

destructor TNoticeClassify.Destroy;
begin
//  FreeAndNil(RecentNotice);
  inherited;
end;

function TNoticeClassify.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  notice_classify:=AJson.S['notice_classify'];
  notice_classify_count:=AJson.I['notice_classify_count'];
  notice_classify_name:=AJson.S['notice_classify_name'];
  notice_classify_unread_count:=AJson.I['notice_classify_unread_count'];

//  Self.RecentNotice.ParseFromJson(AJson.A['RecentNotice'].O[0]);
end;

{ TNoticeClassifyList }

function TNoticeClassifyList.GetItem(Index: Integer): TNoticeClassify;
begin
  Result:=TNoticeClassify(Inherited Items[Index]);
end;

{ TOrderList }

function TOrderList.GetItem(Index: Integer): TOrder;
begin
  Result:=TOrder(Inherited Items[Index]);
end;

{ TOrder }

procedure TOrder.AssignTo(Dest: TPersistent);
begin
  if Dest is TOrder then
  begin
    TOrder(Dest).fid:=fid;//6,
//    TOrder(Dest).appid:=appid;//1001,
    TOrder(Dest).bill_code:=bill_code;//"",
    TOrder(Dest).hotel_fid:=hotel_fid;//2,
    TOrder(Dest).hotel_name:=hotel_name;//"",
    TOrder(Dest).user_fid:=user_fid;//12,
    TOrder(Dest).user_name:=user_name;//"",
    TOrder(Dest).goods_summoney:=goods_summoney;//0,
    TOrder(Dest).goods_origin_summoney:=goods_origin_summoney;//210,
    TOrder(Dest).goods_sum_commission:=goods_sum_commission;//60,
    TOrder(Dest).freight:=freight;//0,
    TOrder(Dest).reduce:=reduce;//0,
    TOrder(Dest).summoney:=summoney;//0,
    TOrder(Dest).goods_kind_num:=goods_kind_num;//60,
    TOrder(Dest).goods_num:=goods_num;//60,
    TOrder(Dest).recv_addr_fid:=recv_addr_fid;//0,
    TOrder(Dest).recv_name:=recv_name;//"王能",
    TOrder(Dest).recv_phone:=recv_phone;//"18957901025",
    TOrder(Dest).recv_province:=recv_province;//"",
    TOrder(Dest).recv_city:=recv_city;//"",
    TOrder(Dest).recv_area:=recv_area;//"",
    TOrder(Dest).recv_addr:=recv_addr;//"浙江省金华市婺城区丹溪路1171号826室",
    TOrder(Dest).remark:=remark;//"快点发货",
    TOrder(Dest).createtime:=createtime;//"2017-07-17 17:26:13",
    TOrder(Dest).order_state:=order_state;//"done",
    TOrder(Dest).is_deleted:=is_deleted;//0,
    TOrder(Dest).is_first_order:=is_first_order;//1,
    TOrder(Dest).audit_user_fid:=audit_user_fid;//1,
    TOrder(Dest).audit_state:=audit_state;//1,
    TOrder(Dest).audit_remark:=audit_remark;//"可以给他发货了",
    TOrder(Dest).audit_time:=audit_time;//"2017-07-18 11:10:23",
    TOrder(Dest).source:=source;//"浏览器端",
    TOrder(Dest).pay_state:=pay_state;//"wait_pay",

    TOrder(Dest).OrderGoodsList.Assign(OrderGoodsList,TOrderGoods);
  end;

end;

constructor TOrder.Create;
begin
  inherited;
  OrderGoodsList:=TOrderGoodsList.Create;

end;

destructor TOrder.Destroy;
begin
  FreeAndNil(OrderGoodsList);
  inherited;
end;

function TOrder.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//6,
  //Self.appid:=AJson.I['appid'];//1001,
  bill_code:=AJson.S['bill_code'];//"",
  hotel_fid:=AJson.I['hotel_fid'];//2,
  hotel_name:=AJson.S['hotel_name'];//2,
  user_fid:=AJson.I['user_fid'];//12,
  user_name:=AJson.S['user_name'];//12,
  introducer_name:=AJson.S['introducer_name'];
  goods_summoney:=GetJsonDoubleValue(AJson,'goods_summoney');//AJson.I[''];//0,
  goods_origin_summoney:=GetJsonDoubleValue(AJson,'goods_origin_summoney');//AJson.I[''];//210,
  goods_sum_commission:=GetJsonDoubleValue(AJson,'goods_sum_commission');//AJson.I[''];//60,
  freight:=GetJsonDoubleValue(AJson,'freight');//AJson.I[''];//0,
  reduce:=GetJsonDoubleValue(AJson,'reduce');//AJson.I[''];//0,
  summoney:=GetJsonDoubleValue(AJson,'summoney');//AJson.I[''];//0,
  goods_kind_num:=AJson.I['goods_kind_num'];//0,
  goods_num:=AJson.I['goods_num'];//0,
  recv_addr_fid:=AJson.I['recv_addr_fid'];//0,
  recv_name:=AJson.S['recv_name'];//"王能",
  recv_phone:=AJson.S['recv_phone'];//"18957901025",
  recv_province:=AJson.S['recv_province'];//"",
  recv_city:=AJson.S['recv_city'];//"",
  recv_area:=AJson.S['recv_area'];//"",
  recv_addr:=AJson.S['recv_addr'];//"浙江省金华市婺城区丹溪路1171号826室",
  remark:=AJson.S['remark'];//"快点发货",

  transer_bankaccount_name:=AJson.S['transer_bankaccount_name'];
  transer_bankaccount_bankname:=AJson.S['transer_bankaccount_bankname'];
  transer_bankaccount_account:=AJson.S['transer_bankaccount_account'];
  transer_payment_voucher:=AJson.S['transer_payment_voucher'];

  manager_commission:=GetJsonDoubleValue(AJson,'manager_commission');
  introducer_commission:=GetJsonDoubleValue(AJson,'introducer_commission');


  createtime:=AJson.S['createtime'];//"2017-07-17 17:26:13",
  order_state:=AJson.S['order_state'];//"done",

  is_pay_manager:=AJson.I['is_pay_manager'];
  is_pay_introducer:=AJson.I['is_pay_introducer'];

  is_deleted:=AJson.I['is_deleted'];//0,
  is_first_order:=AJson.I['is_first_order'];//1,
  audit_user_fid:=AJson.I['audit_user_fid'];//1,
  audit_user_name:=AJson.S['audit_user_name'];//admin,
  audit_state:=AJson.I['audit_state'];//1,
  audit_remark:=AJson.S['audit_remark'];//"可以给他发货了",
  audit_time:=AJson.S['audit_time'];//"2017-07-18 11:10:23",
  source:=AJson.S['source'];//"浏览器端",
  pay_state:=AJson.S['pay_state'];//"wait_pay",


  OrderGoodsList.Clear(True);
  OrderGoodsList.ParseFromJsonArray(TOrderGoods,AJson.A['OrderGoodsList']);

end;

{ TOrderGoodsList }

function TOrderGoodsList.GetItem(Index: Integer): TOrderGoods;
begin
  Result:=TOrderGoods(Inherited Items[Index]);

end;

{ TOrderGoods }

procedure TOrderGoods.AssignTo(Dest: TPersistent);
begin
  inherited;
  if Dest is TOrderGoods then
  begin
    TOrderGoods(Dest).order_fid:=order_fid;
    TOrderGoods(Dest).goods_fid:=goods_fid;
    TOrderGoods(Dest).number:=number;
    TOrderGoods(Dest).order_goods_price:=order_goods_price;
    TOrderGoods(Dest).order_goods_commission:=order_goods_commission;
    TOrderGoods(Dest).order_goods_orderno:=order_goods_orderno;
  end;

end;

function TOrderGoods.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  Inherited;

  order_fid:=AJson.I['order_fid'];//6,
  goods_fid:=AJson.I['goods_fid'];//1,
  number:=AJson.I['number'];//10,
  order_goods_price:=GetJsonDoubleValue(AJson,'order_goods_price');//AJson.I[''];//18,
  order_goods_commission:=GetJsonDoubleValue(AJson,'order_goods_commission');//AJson.I[''];//5,
  order_goods_orderno:=GetJsonDoubleValue(AJson,'order_goods_orderno');//AJson.I[''];//0

end;

{ TRegin }

constructor TRegion.Create;
begin
  inherited;
  RegionProvinceList:=TRegionProvinceList.Create;
end;

destructor TRegion.Destroy;
begin
  FreeAndNil(RegionProvinceList);
  inherited;
end;

function TRegion.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];
  //Self.appid:=AJson.I['appid'];
  name:=AJson.S['name'];
//  orderno:=AJson.S['orderno'];
  manager_fid:=AJson.I['manager_fid'];
  manager_name:=AJson.S['manager_name'];
  createtime:=AJson.S['createtime'];
  Self.RegionProvinceList.ParseFromJsonArray(TRegionProvince,AJson.A['RegionProvinceList']);
end;

{ TReginList }

function TRegionList.GetItem(Index: Integer): TRegion;
begin
  Result:=TRegion(Inherited  Items[Index]);
end;

{ TReginProvince }

function TRegionProvince.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];
  //Self.appid:=AJson.I['appid'];
  regin_fid:=AJson.I['regin_fid'];
  name:=AJson.S['name'];
//  orderno:=AJson.S['orderno'];
  createtime:=AJson.S['createtime'];

end;

{ TReginProvinceList }

function TRegionProvinceList.GetItem(Index: Integer): TRegionProvince;
begin
  Result:=TRegionProvince(Inherited  Items[Index]);
end;

{ TOrderPayment }

function TOrderPayment.GetPic1Url: String;
begin
   Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Pay_Pic/'+Self.pic1path;
  end;
end;

function TOrderPayment.GetPic2Url: String;
begin
   Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Pay_Pic/'+Self.pic2path;
  end;
end;

function TOrderPayment.GetPic3Url: String;
begin
   Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Pay_Pic/'+Self.pic3path;
  end;
end;

function TOrderPayment.GetPic4Url: String;
begin
   Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Pay_Pic/'+Self.pic4path;
  end;
end;
function TOrderPayment.GetPic5Url: String;
begin
   Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Pay_Pic/'+Self.pic5path;
  end;
end;
function TOrderPayment.GetPic6Url: String;
begin
   Result:='';
  if Self.pic1path<>'' then
  begin
    Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/Pay_Pic/'+Self.pic6path;
  end;
end;

function TOrderPayment.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//5,
  //Self.appid:=AJson.I['appid'];//1001,
  order_fid:=AJson.I['order_fid'];//6,
  user_fid:=AJson.I['user_fid'];//12,
  payment_type:=AJson.S['payment_type'];//"bank_transer",
  transer_time:=AJson.S['transer_time'];//"2017-07-30 00:00:00",
  transer_bankaccount_name:=AJson.S['transer_bankaccount_name'];//"王能",
  transer_bankaccount_bankname:=AJson.S['transer_bankaccount_bankname'];//"建行",
  transer_bankaccount_account:=AJson.S['transer_bankaccount_account'];//"6443556555432232",
  transer_payment_voucher:=AJson.S['transer_payment_voucher'];//"123456789",
  money:=GetJsonDoubleValue(AJson,'money');//AJson.F['money'];//100.1,
  remark:=AJson.S['remark'];//"",
  pay_state:=AJson.S['pay_state'];//"",
  pic1path:=AJson.S['pic1path'];//"",
  pic2path:=AJson.S['pic2path'];//"",
  pic3path:=AJson.S['pic3path'];//"",
  pic4path:=AJson.S['pic4path'];//"",
  pic5path:=AJson.S['pic5path'];//"",
  pic6path:=AJson.S['pic6path'];//"",
  audit_user_fid:=AJson.I['audit_user_fid'];//0,
  audit_state:=AJson.I['audit_state'];//0,
  audit_time:=AJson.S['audit_time'];//"",
  audit_remark:=AJson.S['audit_remark'];//"",
  createtime:=AJson.S['createtime'];//"2017-08-02 15:22:57"
end;

{ THomeAd }

function THomeAd.GetPicUrl: String;
begin
  Result:='';
  if Self.picpath<>'' then
  begin
    if Pos('http',Self.picpath)>0 then
    begin
      Result:=picpath;
    end
    else
    begin
      Result:=ImageHttpServerUrl+'/Upload/'+IntToStr(appid)+'/HomeAd_Pic/'+Self.picpath;
    end;
  end;
end;

function THomeAd.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];//3,
  //Self.appid:=AJson.I['appid'];//1001,
  name:=AJson.S['name'];//"首页广告3",
  picpath:=AJson.S['picpath'];//"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3355283602,2380210295",
  url:=AJson.S['url'];//"http://www.baidu.com",
  goods_fid:=AJson.I['goods_fid'];//0,
  orderno:=AJson.I['orderno'];//0,
  goods_name:=AJson.S['goods_name'];//"饮水机" ，
  createtime:=AJson.S['createtime'];//"2017-08-05 23:31:25",
  is_deleted:=AJson.I['is_deleted'];//0
  content:=AJson.S['content'];//"<B>内容</B>",
end;

{ THomeAdList }

function THomeAdList.GetItem(Index: Integer): THomeAd;
begin
  Result:=THomeAd(Inherited Items[Index]);
end;


{ TOrderPaymentList }

function TOrderPaymentList.GetItem(Index: Integer): TOrderPayment;
begin
  Result:=TOrderPayment(Inherited  Items[Index]);
end;

{ TBuyGoodsList }

function TBuyGoodsList.GetItem(Index: Integer): TBuyGoods;
begin
  Result:=TBuyGoods(Inherited  Items[Index]);
end;

{ TBuyGoods }

procedure TBuyGoods.AssignTo(Dest: TPersistent);
begin
  inherited;
  if Dest is TBuyGoods then
  begin
    TBuyGoods(Dest).goods_fid:=goods_fid;
    TBuyGoods(Dest).number:=number;
  end;
end;

{ TOrderDelivery }

function TOrderDelivery.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];
  //Self.appid:=AJson.I['appid'];
  order_fid:=AJson.I['order_fid'];
  emp_fid:=AJson.I['emp_fid'];
  delivery_type:=AJson.S['delivery_type'];
  delivery_company:=AJson.S['delivery_company'];
  delivery_bill_code:=AJson.S['delivery_bill_code'];;
  createtime:=AJson.S['createtime'];;
  remark:=AJson.S['remark'];;
  delivery_time:=AJson.S['delivery_time'];;
end;

{ TOrderDeliveryList }

function TOrderDeliveryList.GetItem(Index: Integer): TOrderDelivery;
begin
  Result:=TOrderDelivery(Inherited  Items[Index]);
end;

{ TUserBillMoney }

function TUserBillMoney.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];
  //Self.appid:=AJson.I['appid'];
  user_fid:=AJson.I['user_fid'];
  bill_fid:=AJson.I['bill_fid'];
  bill_type:=AJson.S['bill_type'];
  bill_code:=AJson.S['bill_code'];
  from_hotel_fid:=AJson.I['from_hotel_fid'];
  from_user_fid:=AJson.I['from_user_fid'];
  manager_rate:=GetJsonDoubleValue(AJson,'manager_rate');
  introducer_rate:=GetJsonDoubleValue(AJson,'introducer_rate');
  is_introducer:=AJson.I['is_introducer'];
  money:=GetJsonDoubleValue(AJson,'money');
  createtime:=AJson.S['createtime'];
  from_user_name:=AJson.S['from_user_name'];
  from_hotel_name:=AJson.S['from_hotel_name'];
  is_pay:=AJson.I['is_pay'];
end;

{ TUserBillMoneyList }

function TUserBillMoneyList.GetItem(Index: Integer): TUserBillMoney;
begin
  Result:=TUserBillMoney(Inherited Items[Index]);
end;

{ TGoodsClassify }

function TGoodsClassify.ParseFromJson(AJson:ISuperObject): Boolean;
begin
  fid:=AJsOn.I['fid'];//1,
  //Self.appid:=AJsOn.I['appid'];//1001,
  name:=AJsOn.S['name'];//"酒店大堂用品",
  orderno:=GetJsonDoubleValue(AJson,'orderno');//"",
  createtime:=AJsOn.S['createtime'];//"2017-07-22 13:04:01",
end;

{ TGoodsClassifyList }

function TGoodsClassifyList.FindItemByFID(AFID: Integer): TGoodsClassify;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.GetCount-1 do
  begin
    if Self.Items[I].fid=AFID then
    begin
      Result:=Self.Items[I];
      Break;
    end;
  end;
end;

function TGoodsClassifyList.GetItem(Index: Integer): TGoodsClassify;
begin
  Result:=TGoodsClassify(Inherited Items[Index]);
end;


{ TGoodsSummary }

function TGoodsSummary.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  summoney:=GetJsonDoubleValue(AJson,'summoney');
  sumnumber:=AJson.I['sumnumber'];
  sumcount:=AJson.I['sumcount'];
  goods_fid:=AJson.I['goods_fid'];
  caption:=AJson.S['caption'];
  goods_unit:=AJson.S['unit'];
  region_fid:=AJson.I['region_fid'];
end;

{ TGoodsSummaryList }

function TGoodsSummaryList.GetItem(Index: Integer): TGoodsSummary;
begin
  Result:=TGoodsSummary(Inherited Items[Index]);
end;

{ TOrderSummaryBill }

function TOrderSummaryBill.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];
  //Self.appid:=AJson.I['appid'];
  bill_code:=AJson.S['bill_code'];
  hotel_fid:=AJson.I['hotel_fid'];
  user_fid:=AJson.I['user_fid'];
  goods_origin_summoney:=GetJsonDoubleValue(AJson,'goods_origin_summoney');
  goods_summoney:=GetJsonDoubleValue(AJson,'goods_summoney');
  freight:=AJson.I['freight'];
  summoney:=GetJsonDoubleValue(AJson,'summoney');
  goods_sum_commission:=AJson.I['goods_sum_commission'];
  recv_addr_fid:=AJson.I['recv_addr_fid'];
  recv_name:=AJson.S['recv_name'];
  recv_phone:=AJson.S['recv_phone'];
  recv_province:=AJson.S['recv_province'];
  recv_city:=AJson.S['recv_city'];
  recv_area:=AJson.S['recv_area'];
  recv_addr:=AJson.S['recv_addr'];
  remark:=AJson.S['recv_phone'];
  createtime:=AJson.S['createtime'];
  done_time:=AJson.S['done_time'];
  order_state:=AJson.S['order_state'];
  pay_state:=AJson.S['pay_state'];
  is_deleted:=AJson.I['is_deleted'];
  is_first_order:=AJson.I['is_first_order'];
  goods_kind_num:=AJson.I['goods_kind_num'];
  goods_num:=AJson.I['goods_num'];
  is_hide:=AJson.I['is_hide'];
  reduce:=AJson.I['reduce'];
  order_date:=AJSon.S['order_date'];
  order_month:=AJson.S['order_month'];
  order_year:=AJson.S['order_year'];
  hotel_name:=AJson.S['hotel_name'];
  hotel_star:=AJson.I['hotel_star'];
  hotel_addr:=AJson.S['hotel_addr'];
  hotel_tel:=AJson.S['hotel_tel'];
  hotel_user_fid:=AJson.I['hotel_user_fid'];
  hotel_province:=AJson.S['hotel_province'];
  hotel_city:=AJson.S['hotel_city'];
  hotel_area:=AJson.S['hotel_area'];
  hotel_is_ordered:=AJson.I['hotel_is_ordered'];
  user_phone:=AJson.S['user_phone'];
  user_name:=AJson.S['user_name'];
  region_fid:=AJson.I['region_fid'];
  region_name:=AJson.S['region_name'];
end;

{ TOrderSummaryBillList }

function TOrderSummaryBillList.GetItem(Index: Integer): TOrderSummaryBill;
begin
  Result:=TOrderSummaryBill(Inherited Items[Index]);
end;

{ TGoodsSummaryBill }

function TGoodsSummaryBill.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJson.I['fid'];
  //Self.appid:=AJson.I['appid'];
  order_fid:=AJson.I['order_fid'];
  goods_fid:=AJson.I['goods_fid'];
  number:=AJson.I['number'];
  price:=GetJsonDoubleValue(AJson,'price');
  orderno:=AJson.I['orderno'];
  goods_name:=AJson.S['goods_name'];
  marque:=AJson.S['marque'];
  goods_unit:=AJson.S['unit'];
  goods_code:=AJson.S['goods_code'];
  goods_classify_fid:=AJson.I['goods_classify_fid'];
  goods_classify_name:=AJson.S['goods_classify_name'];
  bill_code:=AJson.S['bill_code'];
  hotel_fid:=AJson.I['hotel_fid'];
  user_fid:=AJson.I['user_fid'];
  goods_origin_summoney:=GetJsonDoubleValue(AJson,'goods_origin_summoney');
  goods_summoney:=GetJsonDoubleValue(AJson,'goods_summoney');
  summoney:=GetJsonDoubleValue(AJson,'summoney');;
  goods_sum_commission:=AJson.I['goods_sum_commission'];
  done_time:=AJson.S['done_time'];
  goods_kind_num:=AJson.I['goods_kind_num'];
  goods_num:=AJson.I['goods_num'];
  is_deleted:=AJson.I['is_delete'];
  is_first_order:=AJson.I['is_first_order'];
  order_date:=AJson.S['order_date'];
  order_month:=AJson.S['order_month'];
  order_year:=AJson.S['order_year'];
  hotel_name:=AJson.S['hotel_name'];
  hotel_star:=AJson.I['hotel_star'];
  hotel_user_fid:=AJson.I['hotel_user_fid'];
  hotel_province:=AJson.S['hotel_province'];
  user_phone:=AJson.S['user_phone'];
  user_name:=AJson.S['user_name'];
  region_fid:=AJson.I['region_fid'];
  region_name:=AJson.S['region_name'];
end;

{ TGoodsSummaryBillList }

function TGoodsSummaryBillList.GetItem(Index: Integer): TGoodsSummaryBill;
begin
  Result:=TGoodsSummaryBill(Inherited Items[Index]);
end;

{ TSummaryFilterList }

function TSummaryFilterList.FindItemByFilterName(AFilterName: String): TSummaryFilterItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FFilterName=AFilterName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSummaryFilterList.GetItem(Index: Integer): TSummaryFilterItem;
begin
  Result:=TSummaryFilterItem(Inherited Items[Index]);
end;

{ TSummaryFilterItem }

constructor TSummaryFilterItem.Create;
begin
  FFilterSelections:=TStringList.Create;
  FFilterSelectionsCaption:=TStringList.Create;

end;

destructor TSummaryFilterItem.Destroy;
begin
  FreeAndNil(FFilterSelections);
  FreeAndNil(FFilterSelectionsCaption);
  inherited;
end;

function TSummaryFilterItem.GetCaption: String;
begin
  Result:=FFilterValueCaption;
  case FFilterType of
    sftDateArea:
    begin
      //时间范围
      if FFilterValue<>FFilterValue1 then
      begin
        Result:=FFilterValue+'至'+FFilterValue1;
      end
      else
      begin
        Result:=FFilterValue;
      end;
    end;
  end;
end;


{ THotelClassify }

function THotelClassify.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  fid:=AJsOn.I['fid'];//1,
  //Self.appid:=AJsOn.I['appid'];//1001,
  name:=AJsOn.S['name'];//"商务酒店",
  orderno:=GetJsonDoubleValue(AJson,'orderno');//"",
  createtime:=AJsOn.S['createtime'];//"2017-07-22 13:04:01",
end;

{ THotelClassifyList }

function THotelClassifyList.FindItemByFID(AFID: Integer): THotelClassify;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.GetCount-1 do
  begin
    if Self.Items[I].fid=AFID then
    begin
      Result:=Self.Items[I];
      Break;
    end;
  end;
end;

function THotelClassifyList.GetItem(Index: Integer): THotelClassify;
begin
  Result:=THotelClassify(Inherited Items[Index]);
end;

initialization
  GlobalManager:=TManager.Create;


finalization
  uFuncCommon.FreeAndNil(GlobalManager);



end.
