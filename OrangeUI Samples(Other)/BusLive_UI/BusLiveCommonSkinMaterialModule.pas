//convert pas to utf8 by ¥
unit BusLiveCommonSkinMaterialModule;

interface

uses
  System.SysUtils, System.Classes, uSkinMaterial, uSkinButtonType,
  uBaseLog,
  uSkinPanelType, uSkinLabelType, uSkinEditType, uSkinComboBoxType,
  uSkinMemoType, uDrawPicture, uSkinImageList, uSkinImageType,
  uSkinScrollControlType, uSkinVirtualListType, uSkinListViewType,
  uSkinRoundImageType, uSkinCustomListType;

type
  TBusLiveDataModuleCommonSkinMaterial = class(TDataModule)
    bdmReturnButton: TSkinButtonDefaultMaterial;
    pnlToolBarMaterial: TSkinPanelDefaultMaterial;
    lblInputPanelCaptionMaterial: TSkinLabelDefaultMaterial;
    pnlInputPanelMaterial: TSkinPanelDefaultMaterial;
    lblInputPanelValueMaterial: TSkinLabelDefaultMaterial;
    pnlGrayPanelMaterial: TSkinPanelDefaultMaterial;
    btnTurnToNextPageMaterial: TSkinButtonDefaultMaterial;
    lblInputValueHintMaterial: TSkinLabelDefaultMaterial;
    edtInputValueMaterial: TSkinEditDefaultMaterial;
    btnOKButtonMaterial: TSkinButtonDefaultMaterial;
    cmbSelectValueMaterial: TSkinComboBoxDefaultMaterial;
    btnLocationMaterial: TSkinButtonDefaultMaterial;
    btnDropDownMaterial: TSkinButtonDefaultMaterial;
    lblTaskInfoMaterial: TSkinLabelDefaultMaterial;
    btnSmallOKMateiral: TSkinButtonDefaultMaterial;
    memInputValueMaterial: TSkinMemoDefaultMaterial;
    imglistTaskType: TSkinImageList;
    imglistPlayer: TSkinImageList;
    btnDotButtonGroupMaterial: TSkinButtonGroupDefaultMaterial;
    btnGroupLastMaterial: TSkinButtonDefaultMaterial;
    btngroupFirstMaterial: TSkinButtonDefaultMaterial;
    btngroupMiddleMaterial: TSkinButtonDefaultMaterial;
    lblAlwaysUseMaterial: TSkinLabelDefaultMaterial;
    lblFeeYellowMaterial: TSkinLabelDefaultMaterial;
    btnSettingButtonMaterial: TSkinButtonDefaultMaterial;
    btnTextButtonMaterial: TSkinButtonDefaultMaterial;
    btnRedButtonMaterial: TSkinButtonDefaultMaterial;
    eddtGrayBorderCenterHintMaterial: TSkinEditDefaultMaterial;
    btnGreenButtonMaterial: TSkinButtonDefaultMaterial;
    eddtGrayBorderLeftHintMaterial: TSkinEditDefaultMaterial;
    lblInputPanelCaptionRightAlignMaterial: TSkinLabelDefaultMaterial;
    btnExpandButtonMaterial: TSkinButtonDefaultMaterial;
    eddtGrayBorderLeftHintHasIconMaterial: TSkinEditDefaultMaterial;
    imglistStation: TSkinImageList;
    imglistStations: TSkinImageList;
    imglistStar: TSkinImageList;
    imgStarMaterial: TSkinImageDefaultMaterial;
    imglistDecNumber: TSkinImageList;
    imglistAddNumber: TSkinImageList;
    btnAddNumberMaterial: TSkinButtonDefaultMaterial;
    btnDecNumberMaterial: TSkinButtonDefaultMaterial;
    lvActorMaterial: TSkinListViewDefaultMaterial;
    lvPlayListMaterial: TSkinListViewDefaultMaterial;
    btnCaptionDetailArrowMaterial: TSkinButtonDefaultMaterial;
    SkinPanelDefaultMaterial1: TSkinPanelDefaultMaterial;
    imglistDefaultHead: TSkinImageList;
    imglistTreeViewExpanded: TSkinImageList;
    bdmTalkMsg_Content_MyVoiceMsg: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_MyVoiceMsgLen: TSkinButtonDefaultMaterial;
    imgVoiceTalkSign: TSkinImageList;
    btnReturnMaterial: TSkinButtonDefaultMaterial;
    imglistReturnButtonState: TSkinImageList;
    imgRoundHeadMaterial: TSkinRoundImageDefaultMaterial;
    SkinEditDefaultMaterial1: TSkinEditDefaultMaterial;
    SkinLabelDefaultMaterial1: TSkinLabelDefaultMaterial;
    SkinPanelDefaultMaterial2: TSkinPanelDefaultMaterial;
    btnWhiteTextButtonMaterial: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_MyTextMsg: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_YourTextMsg: TSkinButtonDefaultMaterial;
    imglistArrowState: TSkinImageList;
    imglistAddMenu: TSkinImageList;
    ldmTalkMsg_Content_Default: TSkinLabelDefaultMaterial;
    bdmTalkMsg_Content_YourTextMsgBackUP: TSkinButtonDefaultMaterial;
    bdmTalkMsg_Content_MyTextMsgBackUp: TSkinButtonDefaultMaterial;
    imglistDownloadState: TSkinImageList;
    SkinButtonDefaultMaterial1: TSkinButtonDefaultMaterial;
    pnlSettingPanelMaterial: TSkinPanelDefaultMaterial;
    lblSettingPanelCaptionMaterial: TSkinLabelDefaultMaterial;
    btnDefaultButtonMaterial: TSkinButtonDefaultMaterial;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure FreeAllComponent;
    { Public declarations }
  end;

var
  BusLiveDataModuleCommonSkinMaterial: TBusLiveDataModuleCommonSkinMaterial;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TBusLiveDataModuleCommonSkinMaterial }

uses
  uFuncCommon;

procedure TBusLiveDataModuleCommonSkinMaterial.FreeAllComponent;
begin
  //uBaseLog.OutputDebugString('OrangeUI '+'TBusLiveDataModuleCommonSkinMaterial.FreeAllComponent Begin');

    //uBaseLog.OutputDebugString('OrangeUI '+'bdmReturnButton');
    FreeAndNil(bdmReturnButton);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'pnlToolBarMaterial');
    FreeAndNil(pnlToolBarMaterial);//TSkinPanelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'lblInputPanelCaptionMaterial');
    FreeAndNil(lblInputPanelCaptionMaterial);//TSkinLabelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'pnlInputPanelMaterial');
    FreeAndNil(pnlInputPanelMaterial);//TSkinPanelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'lblInputPanelValueMaterial');
    FreeAndNil(lblInputPanelValueMaterial);//TSkinLabelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'pnlGrayPanelMaterial');
    FreeAndNil(pnlGrayPanelMaterial);//TSkinPanelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnTurnToNextPageMaterial');
    FreeAndNil(btnTurnToNextPageMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'lblInputValueHintMaterial');
    FreeAndNil(lblInputValueHintMaterial);//TSkinLabelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'edtInputValueMaterial');
    FreeAndNil(edtInputValueMaterial);//TSkinEditDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnOKButtonMaterial');
    FreeAndNil(btnOKButtonMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'cmbSelectValueMaterial');
    FreeAndNil(cmbSelectValueMaterial);//TSkinComboBoxDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnLocationMaterial');
    FreeAndNil(btnLocationMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnDropDownMaterial');
    FreeAndNil(btnDropDownMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'lblTaskInfoMaterial');
    FreeAndNil(lblTaskInfoMaterial);//TSkinLabelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnSmallOKMateiral');
    FreeAndNil(btnSmallOKMateiral);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'memInputValueMaterial');
    FreeAndNil(memInputValueMaterial);//TSkinMemoDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'imglistTaskType');
    FreeAndNil(imglistTaskType);//TSkinImageList;
    //uBaseLog.OutputDebugString('OrangeUI '+'imglistPlayer');
    FreeAndNil(imglistPlayer);//TSkinImageList;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnDotButtonGroupMaterial');
    FreeAndNil(btnDotButtonGroupMaterial);//TSkinButtonGroupDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnGroupLastMaterial');
    FreeAndNil(btnGroupLastMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btngroupFirstMaterial');
    FreeAndNil(btngroupFirstMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btngroupMiddleMaterial');
    FreeAndNil(btngroupMiddleMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'lblAlwaysUseMaterial');
    FreeAndNil(lblAlwaysUseMaterial);//TSkinLabelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'lblFeeYellowMaterial');
    FreeAndNil(lblFeeYellowMaterial);//TSkinLabelDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnSettingButtonMaterial');
    FreeAndNil(btnSettingButtonMaterial);//TSkinButtonDefaultMaterial;
    //uBaseLog.OutputDebugString('OrangeUI '+'btnTextButtonMaterial');
    FreeAndNil(btnTextButtonMaterial);//TSkinButtonDefaultMaterial;
  //uBaseLog.OutputDebugString('OrangeUI '+'TBusLiveDataModuleCommonSkinMaterial.FreeAllComponent End');

end;

constructor TBusLiveDataModuleCommonSkinMaterial.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TBusLiveDataModuleCommonSkinMaterial.Destroy;
begin
  //uBaseLog.OutputDebugString('OrangeUI '+'TBusLiveDataModuleCommonSkinMaterial.Destroy Begin');
//  FreeAndNil(GlobalTaskRoomFrame);
  inherited;
  //uBaseLog.OutputDebugString('OrangeUI '+'TBusLiveDataModuleCommonSkinMaterial.Destroy End');
end;

end.
