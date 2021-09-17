//convert pas to utf8 by ¥

unit SubmitOrderFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  XunKeCommonSkinMaterialModule,
  uUIFunction,
  PayFrame,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyLabel,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyCheckBox, uSkinFireMonkeyImage,
  uSkinMaterial, uSkinPanelType, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, FMX.ListBox, uSkinFireMonkeyComboBox,
  uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType;

type
  TFrameSubmitOrder = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlBottomBar: TSkinFMXPanel;
    btnBuy: TSkinFMXButton;
    lblPrice: TSkinFMXMultiColorLabel;
    btnRecvInfo: TSkinFMXButton;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXImage2: TSkinFMXImage;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    lblItemHeaderCaption: TSkinFMXLabel;
    imgItemHeaderIcon: TSkinFMXImage;
    ItemDefault: TSkinFMXPanel;
    imgDefaultIcon: TSkinFMXImage;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultDetail: TSkinFMXLabel;
    lblDefaultDetail2: TSkinFMXLabel;
    lblDefaultDetail3: TSkinFMXLabel;
    SkinFMXPanel3: TSkinFMXPanel;
    btnDeliveryType: TSkinFMXButton;
    SkinFMXPanel4: TSkinFMXPanel;
    btnFeeType: TSkinFMXButton;
    SkinFMXPanel5: TSkinFMXPanel;
    edtMemo: TSkinFMXEdit;
    SkinFMXPanel6: TSkinFMXPanel;
    cmbFeeType: TSkinFMXComboBox;
    cmbDeliveryType: TSkinFMXComboBox;
    procedure cmbFeeTypeChange(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure cmbDeliveryTypeChange(Sender: TObject);
    procedure btnDeliveryTypeStayClick(Sender: TObject);
    procedure btnFeeTypeStayClick(Sender: TObject);
    procedure btnRecvInfoStayClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalSubmitOrderFrame:TFrameSubmitOrder;

implementation

uses
  MainForm,
  ProductInfoFrame,
  MainFrame;

{$R *.fmx}

procedure TFrameSubmitOrder.cmbDeliveryTypeChange(Sender: TObject);
begin
  Self.btnDeliveryType.Detail:=Self.cmbDeliveryType.GetText;

end;

procedure TFrameSubmitOrder.cmbFeeTypeChange(Sender: TObject);
begin
  Self.btnFeeType.Detail:=Self.cmbFeeType.GetText;
end;

procedure TFrameSubmitOrder.btnBuyClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);


  //显示支付界面
  ShowFrame(TFrame(GlobalPayFrame),TFramePay,frmMain,nil,nil,nil,Application);
//  GlobalPayFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameSubmitOrder.btnDeliveryTypeStayClick(Sender: TObject);
begin
  Self.cmbDeliveryType.DropDown;

end;

procedure TFrameSubmitOrder.btnFeeTypeStayClick(Sender: TObject);
begin
  Self.cmbFeeType.DropDown;

end;

procedure TFrameSubmitOrder.btnRecvInfoStayClick(Sender: TObject);
begin
  //选择收货地址

end;

procedure TFrameSubmitOrder.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

end.
