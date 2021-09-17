//convert pas to utf8 by ¥
unit PayOrderFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 


  DateUtils,
  uFuncCommon,
  uSkinItems,
  uSkinTreeViewType,

  EasyServiceCommonMaterialDataMoudle,
  MessageBoxFrame,
  WaitingFrame,

  uManager,
  uUIFunction,
  uTimerTask,
  XSuperObject,
  uInterfaceClass,
  uBaseHttpControl,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyLabel, uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyCheckBox, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyRadioButton, uSkinRadioButtonType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFramePayOrder = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    SkinFMXPanel1: TSkinFMXPanel;
    pnlTakeOrderResult: TSkinFMXPanel;
    imglistTakeOrderState: TSkinImageList;
    imgTakeOrderResult: TSkinFMXImage;
    lblTakeOrderResult: TSkinFMXLabel;
    pnlSumMoney: TSkinFMXPanel;
    lblSumMoney: TSkinFMXMultiColorLabel;
    btnOK: TSkinFMXButton;
    pnlEmpty2: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    pnlPaymentType: TSkinFMXPanel;
    lbPaymentTypeList: TSkinFMXListBox;
    idpDefault: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    chkItemDefaultIsSelected: TSkinFMXRadioButton;
    lblItemDetail: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FOrder:TOrder;
    //是否是刚下的订单
    FIsNewOrder:Boolean;

    //取消付款
    procedure OnModalResultFromCancelPay(Frame:TObject);
    { Private declarations }
  public
    procedure Load(AOrder:TOrder;AIsNewOrder:Boolean);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalPayOrderFrame:TFramePayOrder;

implementation


{$R *.fmx}

uses
  MainForm,
  MainFrame,
  PayOrderByTranserFrame;

procedure TFramePayOrder.btnOKClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  //付款
  if Self.lbPaymentTypeList.Prop.SelectedItem<>nil then
  begin
    if Self.lbPaymentTypeList.Prop.SelectedItem.Caption='线下转账' then
    begin

      //隐藏
      HideFrame;//(Self,hfcttBeforeShowFrame);

      //显示线下转账页面
      ShowFrame(TFrame(GlobalPayOrderByTranserFrame),TFramePayOrderByTranser,frmMain,nil,nil,nil,Application);
//      GlobalPayOrderByTranserFrame.FrameHistroy:=CurrentFrameHistroy;
      GlobalPayOrderByTranserFrame.Load(FOrder);

    end;
  end;

end;

procedure TFramePayOrder.btnReturnClick(Sender: TObject);
begin
  //判断是否可以返回
  //如果是下单成功之后,如果按返回,则跳转到主界面

  if FIsNewOrder then
  begin
    ShowMessageBoxFrame(Self,'是否取消付款?','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromCancelPay);

  end
  else
  begin
    //返回
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

end;

constructor TFramePayOrder.Create(AOwner: TComponent);
begin
  inherited;

  FOrder:=TOrder.Create;

//  //暂时不支持微信支付和支付宝支付
//  Self.lbPaymentTypeList.Prop.Items.FindItemByCaption('支付宝').Visible:=False;
//  Self.lbPaymentTypeList.Prop.Items.FindItemByCaption('微信支付').Visible:=False;
  Self.lbPaymentTypeList.Height:=lbPaymentTypeList.Prop.GetContentHeight;

end;

destructor TFramePayOrder.Destroy;
begin
  FreeAndNil(FOrder);
  inherited;
end;

procedure TFramePayOrder.Load(AOrder: TOrder;AIsNewOrder:Boolean);
begin
  FOrder.Assign(AOrder);
  FIsNewOrder:=AIsNewOrder;

  //总金额
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[FOrder.summoney]);

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;


procedure TFramePayOrder.OnModalResultFromCancelPay(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin

    //查看订单

    GlobalMainFrame.ShowOrderFrame;


  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;

end;


end.

