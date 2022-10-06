program ViewOrangeUIStyles_FMX_D10_4;

uses
  System.StartUpCopy,
  FMX.Forms,
  uSkinItems,
  uSkinListViewType,
  FMX_SelectItemStyleForm in 'FMX_SelectItemStyleForm.pas' {frmSelectItemStyle},
  ListItemStyleFrame_Comment in 'ListItemStyleFrame_Comment.pas' {FrameCommentListItemStyle: TFrame},
  ListItemStyleFrame_IconCaption in 'ListItemStyleFrame_IconCaption.pas' {FrameIconCaptionListItemStyle: TFrame},
  ListItemStyleFrame_IconCaption_BottomDetail_RightGrayDetail1 in 'ListItemStyleFrame_IconCaption_BottomDetail_RightGrayDetail1.pas' {FrameIconCaption_BottomDetail_RightGrayDetail1ListItemStyle: TFrame},
  ListItemStyleFrame_CommentDetail in 'ListItemStyleFrame_CommentDetail.pas' {FrameCommentDetailListItemStyle: TFrame},
  ListItemStyleFrame_Base in 'ListItemStyleFrame_Base.pas' {FrameBaseListItemStyleBase: TFrame},
  ListItemStyleFrame_ImageListViewer in 'ListItemStyleFrame_ImageListViewer.pas' {FrameImageListViewerListItemStyle: TFrame},
  ListItemStyleFrame_CarglSelectRepairItem in 'ListItemStyleFrame_CarglSelectRepairItem.pas' {FrameCarglSelectRepairItemListItemStyle: TFrame},
  ListItemStyleFrame_CarglSelectRepairMaterial in 'ListItemStyleFrame_CarglSelectRepairMaterial.pas' {FrameBaseListItemStyleBase1: TFrame},
  BaseListItemStyleFrame in 'BaseListItemStyleFrame.pas' {FrameBaseListItemStyle: TFrame},
  BaseParentItemStyleFrame in 'BaseParentItemStyleFrame.pas' {FrameBaseParentItemStyle},
  ListItemStyleFrame_YCLiving_TelRecord in 'ListItemStyleFrame_YCLiving_TelRecord.pas' {FrameListItemStyle_YCLiving_TelRecord: TFrame},
  ListItemStyleFrame_YCLiving_RechargeOption in 'ListItemStyleFrame_YCLiving_RechargeOption.pas' {FrameListItemStyle_YCLiving_RechargeOption: TFrame},
  ListItemStyleFrame_YCLiving_CaptionTopDetailLeft in 'ListItemStyleFrame_YCLiving_CaptionTopDetailLeft.pas' {FrameListItemStyle_YCLiving_CaptionTopDetailLeft: TFrame},
  ListItemStyleFrame_CaptionTopDetailBottom in 'ListItemStyleFrame_CaptionTopDetailBottom.pas',
  ListItemStyleFrame_SearchBar in 'ListItemStyleFrame_SearchBar.pas' {FrameListItemStyle_SearchBar},
  ListItemStyleFrame_IconCaption_BottomDetail_Service_Item_Book in 'ListItemStyleFrame_IconCaption_BottomDetail_Service_Item_Book.pas',
  ListItemStyleFrame_IconTopCenter_CaptionBottomCenter_Selected in 'ListItemStyleFrame_IconTopCenter_CaptionBottomCenter_Selected.pas',
  ListItemStyleFrame_IconTopCenter_CaptionBottomCenterWhite in 'ListItemStyleFrame_IconTopCenter_CaptionBottomCenterWhite.pas',
  ListItemStyleFrame_Caption_DelButton in 'ListItemStyleFrame_Caption_DelButton.pas',
  ListItemStyleFrame_SaleManageOrderFrame in 'DCommunity\ListItemStyleFrame_SaleManageOrderFrame.pas',
  ListItemStyleFrame_GoodsManageFrame in 'DCommunity\ListItemStyleFrame_GoodsManageFrame.pas',
  ListItemStyleFrame_ShopEvalvateFrame in 'DCommunity\ListItemStyleFrame_ShopEvalvateFrame.pas' {FrameListItemStyle_ShopEvalvate: TFrame},
  EasyServiceCommonMaterialDataMoudle in '..\OrangeProjectCommon\EasyServiceCommonMaterialDataMoudle.pas' {dmEasyServiceCommonMaterial: TDataModule},
  ListItemStyleFrame_IconTopCenter_CaptionBottomCenterBlack in 'ListItemStyleFrame_IconTopCenter_CaptionBottomCenterBlack.pas',
  ListItemStyleFrame_GameGiftPackage in 'XFOnLine\ListItemStyleFrame_GameGiftPackage.pas',
  ListItemStyleFrame_MyGameGiftPackage in 'XFOnLine\ListItemStyleFrame_MyGameGiftPackage.pas',
  ListItemStyleFrame_IconCaptionMultiColor in 'ListItemStyleFrame_IconCaptionMultiColor.pas',
  ListItemStyleFrame_SimpleContact in 'IM\ListItemStyleFrame_SimpleContact.pas' {FrameListItemStyle_SimpleContact: TFrame},
  ListItemStyleFrame_CaptionGrayCenter in 'ListItemStyleFrame_CaptionGrayCenter.pas',
  ListItemStyleFrame_AddContact in 'IM\ListItemStyleFrame_AddContact.pas',
  ListItemStyleFrame_RecentContact in 'IM\ListItemStyleFrame_RecentContact.pas' {FrameListItemStyle_RecentContact},
  ListItemStyleFrame_ThemeColorButton in 'ListItemStyleFrame_ThemeColorButton.pas',
  ListItemStyleFrame_SearchBar_BottomMargin in 'ListItemStyleFrame_SearchBar_BottomMargin.pas',
  ListItemStyleFrame_RadioButton in 'ListItemStyleFrame_RadioButton.pas',
  ListItemStyleFrame_PushedButton in 'ListItemStyleFrame_PushedButton.pas',
  ListItemStyleFrame_Caption_BottomDetail_IconRight in 'ListItemStyleFrame_Caption_BottomDetail_IconRight.pas',
  ListItemStyleFrame_CaptionTop16_DetailBottom in 'ListItemStyleFrame_CaptionTop16_DetailBottom.pas',
  ListItemStyleFrame_ContentCommentDetail in 'ListItemStyleFrame_ContentCommentDetail.pas',
  ListItemStyleFrame_Group in 'ListItemStyleFrame_Group.pas',
  ListItemStyleFrame_HorzImageListBox in 'ListItemStyleFrame_HorzImageListBox.pas',
  ListItemStyleFrame_IconCaption_RightGrayDetail in 'ListItemStyleFrame_IconCaption_RightGrayDetail.pas',
  ListItemStyleFrame_ItemDevide in 'ListItemStyleFrame_ItemDevide.pas',
  ListItemStyleFrame_SmallCoupon in 'ListItemStyleFrame_SmallCoupon.pas',
  ListItemStyleFrame_CaptionLeft_DetailRight_Accessory in 'ListItemStyleFrame_CaptionLeft_DetailRight_Accessory.pas',
  ListItemStyleFrame_GroupMember in 'IM\ListItemStyleFrame_GroupMember.pas',
  ListItemStyleFrame_ScanInStoreConfirm in 'DoorManage\ListItemStyleFrame_ScanInStoreConfirm.pas',
  ListItemStyleFrame_HorzListBox in 'ListItemStyleFrame_HorzListBox.pas',
  ListItemStyleFrame_4Buttons in 'ListItemStyleFrame_4Buttons.pas',
  ListItemStyleFrame_GameActivity in 'XFOnLine\ListItemStyleFrame_GameActivity.pas',
  ListItemStyleFrame_GameList in 'XFOnLine\ListItemStyleFrame_GameList.pas',
  ListItemStyleFrame_LiveStream in 'DCommunity\ListItemStyleFrame_LiveStream.pas',
  ListItemStyleFrame_ScoreExchangeActivity in 'XFOnLine\ListItemStyleFrame_ScoreExchangeActivity.pas',
  ListItemStyleFrame_SignDay in 'XFOnLine\ListItemStyleFrame_SignDay.pas',
  ListItemStyleFrame_PopupMenuItem in 'ListItemStyleFrame_PopupMenuItem.pas',
  ListItemStyleFrame_ScanBarCodeItem in 'ListItemStyleFrame_ScanBarCodeItem.pas',
  ListItemStyleFrame_ScoreExchangeGoods in 'ListItemStyleFrame_ScoreExchangeGoods.pas',
  ListItemStyleFrame_News1 in 'DCommunity\ListItemStyleFrame_News1.pas',
  ListItemStyleFrame_ShortVideo in 'DCommunity\ListItemStyleFrame_ShortVideo.pas',
  ListItemStyleFrame_UserSerivceGoodsVIPFrame in 'DCommunity\ListItemStyleFrame_UserSerivceGoodsVIPFrame.pas',
  ListItemStyleFrame_UserSerivceGoodsVIPRightsFrame in 'DCommunity\ListItemStyleFrame_UserSerivceGoodsVIPRightsFrame.pas',
  ListItemStyleFrame_ContentNews in 'DCommunity\ListItemStyleFrame_ContentNews.pas',
  ListItemStyleFrame_ContentNews2 in 'DCommunity\ListItemStyleFrame_ContentNews2.pas',
  ListItemStyleFrame_DelphiContent in 'DCommunity\ListItemStyleFrame_DelphiContent.pas',
  ListItemStyleFrame_News in 'DCommunity\ListItemStyleFrame_News.pas',
  ListItemStyleFrame_ScoreRecharge in 'XFOnLine\ListItemStyleFrame_ScoreRecharge.pas',
  ListItemStyleFrame_XFOnlineNews in 'XFOnLine\ListItemStyleFrame_XFOnlineNews.pas',
  ListItemStyleFrame_CaptionRightCheckBox in 'ListItemStyleFrame_CaptionRightCheckBox.pas',
  ListItemStyleFrame_ProcessTaskOrder in 'DoorManage\ListItemStyleFrame_ProcessTaskOrder.pas' {FrameListItemStyle_ProcessTaskOrder},
  ListItemStyleFrame_FinishedProcessTask in 'DoorManage\ListItemStyleFrame_FinishedProcessTask.pas',
  ListItemStyleFrame_DefaultSelected in 'ListItemStyleFrame_DefaultSelected.pas',
  ListItemStyleFrame_IconCaption_NotifyNumberIconRight in 'ListItemStyleFrame_IconCaption_NotifyNumberIconRight.pas',
  ListItemStyleFrame_IconCaption_BottomDetail_WhiteBackPic in 'ListItemStyleFrame_IconCaption_BottomDetail_WhiteBackPic.pas';

{$R *.res}

var
  ASkinItem:TSkinItem;
begin
  Application.Initialize;
//  Application.CreateForm(TfrmSelectItemStyle, frmSelectItemStyle);
  frmSelectItemStyle:=TfrmSelectItemStyle.Create(Application);
  frmSelectItemStyle.lvData.Prop.ViewType:=lvtList;
  frmSelectItemStyle.lvData.Prop.ItemWidth:=-1;
  frmSelectItemStyle.Show;

  ASkinItem:=TRealSkinItem.Create;
  ASkinItem.Caption:='Caption';
  ASkinItem.Detail:='Detail';
  ASkinItem.Detail1:='Detail1';
  ASkinItem.Detail2:='Detail2';
  ASkinItem.Detail3:='Detail3';
  ASkinItem.Detail4:='Detail4';
  ASkinItem.Detail5:='Detail5';
  ASkinItem.Detail6:='Detail6';
//  ASkinItem.Detail7:='Detail7';

  frmSelectItemStyle.Load(nil,ASkinItem);
  Application.Run;
end.
