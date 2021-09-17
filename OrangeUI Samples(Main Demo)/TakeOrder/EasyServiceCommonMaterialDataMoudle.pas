//convert pas to utf8 by ¥

unit EasyServiceCommonMaterialDataMoudle;

interface

uses
  System.SysUtils, System.Classes, uSkinPanelType, uSkinMaterial,
  uSkinButtonType, uSkinEditType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinCheckBoxType, uDrawPicture, uSkinImageList, uSkinLabelType,
  uSkinImageType, uSkinFrameImageType, uSkinRadioButtonType,
  uSkinNotifyNumberIconType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinSwitchPageListPanelType, uSkinPageControlType;

type
  TdmEasyServiceCommonMaterial = class(TDataModule)
    bdmReturnButton: TSkinButtonDefaultMaterial;
    pnlToolBarMaterial: TSkinPanelDefaultMaterial;
    edtHelpTextMaterial: TSkinEditDefaultMaterial;
    pnlBlackCaptionLeftMarginPanelMaterial: TSkinPanelDefaultMaterial;
    btnBlueColorButtonMaterial: TSkinButtonDefaultMaterial;
    lblNoticeTypeLabelMaterial: TSkinLabelDefaultMaterial;
    sbDefaultColorBackgroundScrollBoxMaterial: TSkinScrollBoxDefaultMaterial;
    btnRedColorButtonMaterial: TSkinButtonDefaultMaterial;
    pnlInputBlackCaptionPanelMaterial: TSkinPanelDefaultMaterial;
    btnOrangeRedBorderWhiteBackButtonMaterial: TSkinButtonDefaultMaterial;
    edtInputEditHasHelpTextMaterial: TSkinEditDefaultMaterial;
    chkDefaultCheckBoxMaterial: TSkinCheckBoxColorMaterial;
    btnGrayBorderButtonMaterial: TSkinButtonDefaultMaterial;
    btnTransparentWhiteCaptionButtonMaterial: TSkinButtonDefaultMaterial;
    btnRedBorderButtonMaterial: TSkinButtonDefaultMaterial;
    rbRedRadioButtonMaterial: TSkinRadioButtonColorMaterial;
    btnSelectButtonMaterial: TSkinButtonDefaultMaterial;
    pnlInputMemoBlackCaptionPanelMaterial: TSkinPanelDefaultMaterial;
    imglistBankIcon: TSkinImageList;
    edtSearchGoodsMaterial: TSkinEditDefaultMaterial;
    btnDeleteButtonMaterial: TSkinButtonDefaultMaterial;
    ilPictureList: TSkinImageList;
    btnIconButtonMaterial: TSkinButtonDefaultMaterial;
    btnSearchButtonMaterial: TSkinButtonDefaultMaterial;
    btnNoticeNotifyNumberIconMaterial: TSkinNotifyNumberIconColorMaterial;
    nniRedNotifyNumberMaterial: TSkinNotifyNumberIconDefaultMaterial;
    imgPayTypePicList: TSkinImageList;
    lbFilterHorzListBoxMaterial: TSkinListBoxDefaultMaterial;
    imgTakePicList: TSkinImageList;
    btnRedRectButtonMaterial: TSkinButtonDefaultMaterial;
    imglistAppIcon: TSkinImageList;
    imglistAppIconList: TSkinImageList;
    bgIndicator_Material: TSkinButtonGroupDefaultMaterial;
    edtInputPhone_Material: TSkinEditDefaultMaterial;
    pcMain_Material: TSkinPageControlDefaultMaterial;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  dmEasyServiceCommonMaterial: TdmEasyServiceCommonMaterial;

function GetBankIconIndex(ABankName:String):Integer;

function GetNoticeIconIndex(notice_classify_name:String):Integer;

implementation

uses
  uUIFunction;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


function GetBankIconIndex(ABankName:String):Integer;
begin
  Result:=0;
  if Pos('交通银行',ABankName)>0 then
  begin
    Result:=1;
  end;
  if Pos('兴业银行',ABankName)>0 then
  begin
    Result:=2;
  end;
  if Pos('工商银行',ABankName)>0 then
  begin
    Result:=3;
  end;
  if Pos('建设银行',ABankName)>0 then
  begin
    Result:=4;
  end;
  if Pos('农业银行',ABankName)>0 then
  begin
    Result:=5;
  end;
  if Pos('中国银行',ABankName)>0 then
  begin
    Result:=6;
  end;
end;


function GetNoticeIconIndex(notice_classify_name:String):Integer;
begin
  Result:=0;
  if Pos('系统公告',notice_classify_name)>0 then
  begin
    Result:=1;
  end;
  if Pos('订单消息',notice_classify_name)>0 then
  begin
    Result:=2;
  end;
  if Pos('账号消息',notice_classify_name)>0 then
  begin
    Result:=3;
  end;
  if Pos('留言',notice_classify_name)>0 then
  begin
    Result:=4;
  end;
  if Pos('站内信',notice_classify_name)>0 then
  begin
    Result:=5;
  end;
end;

{ TdmEasyServiceCommonMaterial }

constructor TdmEasyServiceCommonMaterial.Create(AOwner: TComponent);
begin
  inherited;

  //工具栏
  Self.pnlToolBarMaterial.BackColor.FillColor.Color:=SkinThemeColor;

  //常用背景色按钮
  Self.btnRedColorButtonMaterial.BackColor.FillColor.Color:=SkinThemeColor;
  Self.btnRedRectButtonMaterial.BackColor.FillColor.Color:=SkinThemeColor;

  //常用边框按钮
  Self.btnRedBorderButtonMaterial.BackColor.BorderColor.Color:=SkinThemeColor;
  Self.btnRedBorderButtonMaterial.DrawCaptionParam.FontColor:=SkinThemeColor;

  //小标题直角边框按钮
  Self.btnOrangeRedBorderWhiteBackButtonMaterial.BackColor.BorderColor.Color:=SkinThemeColor;
  Self.btnOrangeRedBorderWhiteBackButtonMaterial.DrawCaptionParam.FontColor:=SkinThemeColor;


  //分类水平列表框
  Self.lbFilterHorzListBoxMaterial.DrawItemBackColorParam.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;

  //复选框
  Self.chkDefaultCheckBoxMaterial.DrawCheckRectParam.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;

  //单选框
  Self.rbRedRadioButtonMaterial.DrawCheckRectParam.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;
  Self.rbRedRadioButtonMaterial.DrawCheckStateParam.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;


  //删除按钮
  Self.btnDeleteButtonMaterial.DrawCaptionParam.FontColor:=SkinThemeColor;


  //未读数按钮
  Self.btnNoticeNotifyNumberIconMaterial.DrawCaptionParam.FontColor:=SkinThemeColor;

end;

end.
