//convert pas to utf8 by ¥

unit ScrollBoxFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  Math,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uUIFunction,
  uMobileUtils,
  MessageBoxFrame,

  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinScrollBoxContentType, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyPanel, uSkinFireMonkeyScrollControlCorner,
  uSkinFireMonkeyScrollBar, uSkinFireMonkeyButton, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyImage, uSkinFireMonkeyFrameImage,
  uSkinMemoType, uSkinComboBoxType, uSkinButtonType, uSkinEditType,
  uSkinPanelType, uSkinMaterial, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyPullLoadPanel, FMX.ListBox, uSkinFireMonkeyComboBox,
  uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameScrollBox = class(TFrame,
                            IFrameChangeLanguageEvent,
                            IFrameVirtualKeyboardAutoProcessEvent
                                )
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    SkinFMXPanel2: TSkinFMXPanel;
    lblGoodsName: TSkinFMXLabel;
    edtGoodsName: TSkinFMXEdit;
    SkinFMXPanel7: TSkinFMXPanel;
    lblSenderAddr: TSkinFMXLabel;
    edtSenderAddr: TSkinFMXEdit;
    SkinFMXPanel8: TSkinFMXPanel;
    lblReceiverAddr: TSkinFMXLabel;
    edtReceiverAddr: TSkinFMXEdit;
    SkinFMXPanel12: TSkinFMXPanel;
    lblSenderMobile: TSkinFMXLabel;
    edtSenderMobile: TSkinFMXEdit;
    SkinFMXPanel13: TSkinFMXPanel;
    lblSender: TSkinFMXLabel;
    edtSender: TSkinFMXEdit;
    SkinFMXPanel14: TSkinFMXPanel;
    lblReceiver: TSkinFMXLabel;
    edtReceiver: TSkinFMXEdit;
    SkinFMXPanel15: TSkinFMXPanel;
    lblReceiverMobile: TSkinFMXLabel;
    edtReceiverMobile: TSkinFMXEdit;
    btnPublish: TSkinFMXButton;
    pnlVirtualKeyboard: TSkinFMXPanel;
    lblInputPanelCaptionMaterial: TSkinLabelDefaultMaterial;
    pnlInputPanelMaterial: TSkinPanelDefaultMaterial;
    edtInputValueMaterial: TSkinEditDefaultMaterial;
    pnlPickTime: TSkinFMXPanel;
    lblFetchTime: TSkinFMXLabel;
    cmbFetchTime: TSkinFMXComboBox;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXEdit1: TSkinFMXEdit;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXEdit2: TSkinFMXEdit;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXEdit3: TSkinFMXEdit;
    SkinFMXPanel5: TSkinFMXPanel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXEdit4: TSkinFMXEdit;
    procedure btnPublishClick(Sender: TObject);
    procedure lblSenderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
  end;


implementation

{$R *.fmx}


procedure TFrameScrollBox.btnPublishClick(Sender: TObject);
begin
  ShowMessageBoxFrame(Self,'保存成功');
end;

procedure TFrameScrollBox.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblFetchTime.Text:=GetLangString(Self.lblFetchTime.Name,ALangKind);
  Self.lblGoodsName.Text:=GetLangString(Self.lblGoodsName.Name,ALangKind);

  Self.lblSender.Text:=GetLangString(Self.lblSender.Name,ALangKind);
  Self.lblSenderMobile.Text:=GetLangString(Self.lblSenderMobile.Name,ALangKind);
  Self.lblSenderAddr.Text:=GetLangString(Self.lblSenderAddr.Name,ALangKind);

  Self.lblReceiver.Text:=GetLangString(Self.lblReceiver.Name,ALangKind);
  Self.lblReceiverMobile.Text:=GetLangString(Self.lblReceiverMobile.Name,ALangKind);
  Self.lblReceiverAddr.Text:=GetLangString(Self.lblReceiverAddr.Name,ALangKind);

  Self.btnPublish.Text:=GetLangString(Self.btnPublish.Name,ALangKind);

  Self.cmbFetchTime.Items[0]:=GetLangString(Self.cmbFetchTime.Name+'Caption 0',ALangKind);
  Self.cmbFetchTime.Items[1]:=GetLangString(Self.cmbFetchTime.Name+'Caption 1',ALangKind);

  Self.edtGoodsName.Prop.HelpText:=GetLangString(Self.edtGoodsName.Name+'HelpText',ALangKind);
  Self.edtSender.Prop.HelpText:=GetLangString(Self.edtGoodsName.Name+'HelpText',ALangKind);
  Self.edtSenderMobile.Prop.HelpText:=GetLangString(Self.edtGoodsName.Name+'HelpText',ALangKind);
  Self.edtSenderAddr.Prop.HelpText:=GetLangString(Self.edtGoodsName.Name+'HelpText',ALangKind);
  Self.edtReceiver.Prop.HelpText:=GetLangString(Self.edtGoodsName.Name+'HelpText',ALangKind);
  Self.edtReceiverMobile.Prop.HelpText:=GetLangString(Self.edtGoodsName.Name+'HelpText',ALangKind);
  Self.edtReceiverAddr.Prop.HelpText:=GetLangString(Self.edtGoodsName.Name+'HelpText',ALangKind);

  Self.cmbFetchTime.Prop.HelpText:=GetLangString(Self.cmbFetchTime.Name+'HelpText',ALangKind);

end;

constructor TFrameScrollBox.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblFetchTime.Name,[Self.lblFetchTime.Text,'Fetch time']);
  RegLangString(Self.lblGoodsName.Name,[Self.lblGoodsName.Text,'Goods name']);

  RegLangString(Self.lblSender.Name,[Self.lblSender.Text,'Sender']);
  RegLangString(Self.lblSenderMobile.Name,[Self.lblSenderMobile.Text,'S-Mobile']);
  RegLangString(Self.lblSenderAddr.Name,[Self.lblSenderAddr.Text,'S-Addr']);

  RegLangString(Self.lblReceiver.Name,[Self.lblReceiver.Text,'Receiver']);
  RegLangString(Self.lblReceiverMobile.Name,[Self.lblReceiverMobile.Text,'R-Mobile']);
  RegLangString(Self.lblReceiverAddr.Name,[Self.lblReceiverAddr.Text,'R-Addr']);

  RegLangString(Self.btnPublish.Name,[Self.btnPublish.Text,'Publish']);

  RegLangString(Self.cmbFetchTime.Name+'Caption 0',
                [Self.cmbFetchTime.Items[0],'Right Now']);
  RegLangString(Self.cmbFetchTime.Name+'Caption 1',
                [Self.cmbFetchTime.Items[1],'An Hour Later']);


  RegLangString(Self.edtGoodsName.Name+'HelpText',[Self.edtGoodsName.Prop.HelpText,'please input...']);
  RegLangString(Self.cmbFetchTime.Name+'HelpText',[Self.cmbFetchTime.Prop.HelpText,'please select...']);

end;

function TFrameScrollBox.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameScrollBox.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;



procedure TFrameScrollBox.lblSenderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  ShowMessageBoxFrame(Self,'保存成功');

end;

end.
