//convert pas to utf8 by ¥
unit PayOrderResultFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
  MessageBoxFrame,
  WaitingFrame,

  uManager,
  uUIFunction,
  uTimerTask,
  XSuperObject,
  uInterfaceClass,
  uBaseHttpControl,
  uEasyServiceCommon,

  uSkinFireMonkeyControl, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyMultiColorLabel, uDrawPicture, uSkinImageList,
  uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType;

type
  TFramePayOrderResult = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgPayOrderResult: TSkinFMXImage;
    pnlPayInfo: TSkinFMXPanel;
    pnlPayInfoCenter: TSkinFMXPanel;
    btnViewOrder: TSkinFMXButton;
    lblPayOrderResult: TSkinFMXLabel;
    lblPayHint: TSkinFMXLabel;
    btnOK: TSkinFMXButton;
    lblPaymentTypeHint: TSkinFMXLabel;
    lblPaymentType: TSkinFMXLabel;
    lblSumMoneyHint: TSkinFMXLabel;
    lblSumMoney: TSkinFMXMultiColorLabel;
    imglistPayOrderResult: TSkinImageList;
    procedure btnViewOrderClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FOrder:TOrder;
    { Private declarations }
  public
    procedure Load(AOrder:TOrder;AOrderPayment:TOrderPayment);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalPayOrderResultFrame:TFramePayOrderResult;

implementation

uses
  MainForm,
  MainFrame,
  OrderListFrame;

{$R *.fmx}

procedure TFramePayOrderResult.Load(AOrder: TOrder;AOrderPayment:TOrderPayment);
begin

  FOrder.Assign(AOrder);

  //是否支付成功
  if AOrderPayment.pay_state=Const_PayState_Payed then
  begin
    Self.lblPayOrderResult.Caption:='付款成功';
    Self.lblPayHint.Caption:='请耐心等待审核通过';
    Self.imgPayOrderResult.Prop.Picture.ImageIndex:=1;
  end
  else
  begin
    Self.lblPayOrderResult.Caption:='付款失败';
    Self.lblPayHint.Caption:='';
    Self.imgPayOrderResult.Prop.Picture.ImageIndex:=0;
  end;


  //支付方式
  Self.lblPaymentType.Caption:=GetPaymentTypeStr(AOrderPayment.payment_type);
  //支付金额
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[FOrder.summoney]);

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFramePayOrderResult.btnOKClick(Sender: TObject);
begin
  //返回首页
  GlobalMainFrame.ShowOrderFrame;

//  //隐藏
//  HideFrame;//(Self,hfcttBeforeShowFrame);
//  //显示主界面
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application);
//  GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
//
//  //刷新购物车列表
//  GlobalMainFrame.GetUserCartGoodsList;
//  //刷新未读通知数
//  GlobalMainFrame.GetUserNoticeUnReadCount;

end;

procedure TFramePayOrderResult.btnViewOrderClick(Sender: TObject);
begin
  //查看订单
  GlobalMainFrame.ShowOrderFrame;
end;

constructor TFramePayOrderResult.Create(AOwner: TComponent);
begin
  inherited;
  FOrder:=TOrder.Create;

end;

destructor TFramePayOrderResult.Destroy;
begin
  FreeAndNil(FOrder);

  inherited;
end;

end.
