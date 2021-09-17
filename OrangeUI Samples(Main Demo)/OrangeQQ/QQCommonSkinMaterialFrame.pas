//convert pas to utf8 by ¥

unit QQCommonSkinMaterialFrame;

interface

uses
  System.SysUtils, System.Classes, uSkinMaterial, uSkinPanelType, uDrawPicture,
  uSkinImageList, uSkinButtonType, uSkinImageType, uSkinRoundImageType,
  uSkinLabelType, uSkinEditType;

const
  Const_DefaultContactHead_ImageIndex=0;
  Const_DefaultGroupHead_ImageIndex=1;
  Const_DefaultRoomHead_ImageIndex=2;


type
  TQQCommonSkinMaterialDataModule = class(TDataModule)
    pnlToolBarMaterial: TSkinPanelDefaultMaterial;
    imglistDefaultHead: TSkinImageList;
    imglistTreeViewExpanded: TSkinImageList;
    bdmTalkMsg_Content_MyVoiceMsg: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_MyVoiceMsgLen: TSkinButtonDefaultMaterial;
    imgVoiceTalkSign: TSkinImageList;
    btnReturnMaterial: TSkinButtonDefaultMaterial;
    imglistReturnButtonState: TSkinImageList;
    imgRoundHeadMaterial: TSkinRoundImageDefaultMaterial;
    edtInputValueMaterial: TSkinEditDefaultMaterial;
    lblInputPanelCaptionMaterial: TSkinLabelDefaultMaterial;
    pnlInputPanelMaterial: TSkinPanelDefaultMaterial;
    btnWhiteTextButtonMaterial: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_MyTextMsg: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_YourTextMsg: TSkinButtonDefaultMaterial;
    imglistArrowState: TSkinImageList;
    imglistAddMenu: TSkinImageList;
    ldmTalkMsg_Content_Default: TSkinLabelDefaultMaterial;
    bdmTalkMsg_Content_YourTextMsgBackUP: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_MyTextMsgBackUp: TSkinButtonDefaultMaterial;
    imglistDownloadState: TSkinImageList;
    btnSettingButtonMaterial: TSkinButtonDefaultMaterial;
    pnlSettingPanelMaterial: TSkinPanelDefaultMaterial;
    lblSettingPanelCaptionMaterial: TSkinLabelDefaultMaterial;
    btnDefaultButtonMaterial: TSkinButtonDefaultMaterial;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QQCommonSkinMaterialDataModule: TQQCommonSkinMaterialDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
