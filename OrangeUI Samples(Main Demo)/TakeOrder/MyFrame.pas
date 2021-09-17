//convert pas to utf8 by ¥
unit MyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

//  SpiritFrame,
//  EditMyFrame,
  uEasyServiceCommon,
  uDrawCanvas,

  uSkinItems,
  uDrawPicture,

  WaitingFrame,
  MessageBoxFrame,
  PopupMenuFrame,

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uInterfaceClass,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyRoundImage, uSkinFireMonkeyCustomList, uSkinFireMonkeyListView,
  uSkinFireMonkeyButton, uSkinFireMonkeyNotifyNumberIcon, uSkinImageList,
  uSkinLabelType, uSkinPanelType, uSkinImageType, uSkinItemDesignerPanelType,
  uBaseSkinControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType;

type
  TFrameMy = class(TFrame)
    lbMenu: TSkinFMXListView;
    ItemHeader: TSkinFMXItemDesignerPanel;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgItemMenuIcon: TSkinFMXImage;
    lblItemMenuCaption: TSkinFMXLabel;
    SkinFMXPanel3: TSkinFMXPanel;
    imgHeadBack: TSkinFMXImage;
    imgHead: TSkinFMXImage;
    SkinFMXPanel1: TSkinFMXPanel;
    lblPhone: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    lblUserName: TSkinFMXLabel;
    lblAuditState: TSkinFMXLabel;
    ImgList: TSkinImageList;
    imgPic: TSkinFMXImage;
    procedure lbMenuClickItem(Sender: TSkinItem);
  private
    //从认证信息页面返回
    procedure OnReturnFromFillInfoFrame(Frame:TFrame);
    //从申请介绍人页面返回
    procedure OnReturnFromApplyIntroducerFrame(Frame:TFrame);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load;
    { Public declarations }
  end;


implementation

uses
  MainForm,
  MainFrame,
//  LookCertificationInfoFrame,
//  MyInvitationCodeFrame,
//  ApplyIntroducerFrame,
  ChangePasswordFrame,
//  FillUserInfoFrame,
  AboutUsFrame,
  LoginFrame,
//  SelectFilterDateFrame,
//  UserListFrame,
  MyBankCardListFrame;

{$R *.fmx}

{ TFrameMy }

constructor TFrameMy.Create(AOwner:TComponent);
begin
  inherited;


end;

destructor TFrameMy.Destroy;
begin

  inherited;
end;

procedure TFrameMy.lbMenuClickItem(Sender: TSkinItem);
begin
  if Sender.ItemType=sitItem1 then
  begin
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //编辑个人资料
//    ShowFrame(TFrame(GlobalEditMyFrame),TFrameEditMyFrame,frmMain,nil,nil,nil,Application);
//    GlobalEditMyFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalEditMyFrame.Load;
  end;
//  if Sender.Caption='我的佣金' then
//  begin
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //显示实名认证信息
//    ShowFrame(TFrame(GlobalGetBillMoneyFrame),TFrameGetBillMoney,frmMain,nil,nil,nil,Application);
//    GlobalGetBillMoneyFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalGetBillMoneyFrame.Clear;
//    GlobalGetBillMoneyFrame.Load('我的佣金',
//                                  FormatDateTime('YYYY-MM-DD',Now-30),
//                                  FormatDateTime('YYYY-MM-DD',Now),'',
//                                  IntToStr(GlobalManager.User.fid),
//                                  '',
//                                  nil,
//                                  '',
//                                  '');
//
//  end;
//  if Sender.Caption='实名认证' then
//  begin
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//    //显示实名认证界面
//    ShowFrame(TFrame(GlobalFillUserInfoFrame),TFrameFillUserInfo,frmMain,nil,nil,OnReturnFromFillInfoFrame,Application);
//    GlobalFillUserInfoFrame.Clear;
//    GlobalFillUserInfoFrame.FPageIndex:=2;
//  end;

//  if Sender.Caption='查询汇总' then
//  begin
//
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //显示设置页面
//    ShowFrame(TFrame(GlobalSummaryFrame),TFrameSummary,frmMain,nil,nil,nil,Application);
//    GlobalSummaryFrame.FrameHistroy:=CurrentFrameHistroy;
//
//  end;

//  if Sender.Caption='申请介绍人' then
//  begin
//     //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //显示申请页面
//    ShowFrame(TFrame(GlobalApplyIntroducerFrame),TFrameApplyIntroducer,frmMain,nil,nil,OnReturnFromApplyIntroducerFrame,Application);
//    GlobalApplyIntroducerFrame.FrameHistroy:=CurrentFrameHistroy;
//
//    GlobalApplyIntroducerFrame.Clear;
//    GlobalApplyIntroducerFrame.LoadApplyIntroducerType(aitAfterRegister);
//  end;


//  if Sender.Caption='合同须知' then
//  begin
//    //合同须知
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    ShowFrame(TFrame(GlobalContractListFrame),TFrameContractList,frmMain,nil,nil,nil,Application);
//    GlobalContractListFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalContractListFrame.Clear;
//    GlobalContractListFrame.Load(futViewList);
//  end;


//  if Sender.Caption='我介绍的人' then
//  begin
//
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //显示设置页面
//    ShowFrame(TFrame(GlobalUserListFrame),TFrameUserList,frmMain,nil,nil,nil,Application);
//    GlobalUserListFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalUserListFrame.Load('',
//                              IntToStr(GlobalManager.User.fid),
//                              futViewList,
//                              IntToStr(Ord(asAuditPass)),
//                              '1',
//                              '',
//                              0,
//                              0,
//                              True);
//  end;

//  if Sender.Caption='设置' then
//  begin
//       //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //显示设置页面
//    ShowFrame(TFrame(GlobalSettingFrame),TFrameSetting,frmMain,nil,nil,nil,Application);
//    GlobalSettingFrame.FrameHistroy:=CurrentFrameHistroy;
//  end;

//  if Sender.Caption='邀请码' then
//  begin
//     //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    //显示我的邀请码
//    ShowFrame(TFrame(GlobalMyInvitationCodeFrame),TFrameMyInvitationCode,frmMain,nil,nil,nil,Application);
//    GlobalMyInvitationCodeFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalMyInvitationCodeFrame.Load;
//  end;
  if Sender.Caption='退出登录' then
  begin
    frmMain.Logout;
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //显示登录
    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;

  end;
  if Sender.Caption='我的银行卡' then
  begin
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalMyBankCardListFrame),TFrameMyBankCardList,frmMain,nil,nil,nil,Application);
//    GlobalMyBankCardListFrame.FrameHistroy:=CurrentFrameHistroy;

    GlobalMyBankCardListFrame.lbBankList.Prop.Items.Clear;
    GlobalMyBankCardListFrame.Load('我的银行卡',futManage,0);
  end;
  if Sender.Caption='密码修改' then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //修改密码
    ShowFrame(TFrame(GlobalChangePasswordFrame),TFrameChangePassword,frmMain,nil,nil,nil,Application);
//    GlobalChangePasswordFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalChangePasswordFrame.Clear;

  end;
  if Sender.Caption='关于我们' then
  begin
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

    //关于我们
    ShowFrame(TFrame(GlobalAboutUsFrame),TFrameAboutUs,frmMain,nil,nil,nil,Application);
//    GlobalAboutUsFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
end;

procedure TFrameMy.Load;
begin

  //头像
  Self.lbMenu.Prop.Items.FindItemByType(sitHeader).Icon.Url:=
    GlobalManager.User.GetHeadPicUrl;
  Self.lbMenu.Prop.Items.FindItemByType(sitHeader).Icon.PictureDrawType:=
    TPictureDrawType.pdtUrl;
  //姓名
  Self.lbMenu.Prop.Items.FindItemByType(sitHeader).Caption:=
    GlobalManager.User.Name;
  //手机号
  Self.lbMenu.Prop.Items.FindItemByType(sitHeader).Detail:=
    GlobalManager.User.Phone;
  //审核状态
  Self.lblAuditState.Caption:=GetAuditStateStr(TAuditState(GlobalManager.User.audit_state));
  Self.lblAuditState.Material.DrawCaptionParam.FontColor:=
    GetAuditStateColor(TAuditState(GlobalManager.User.audit_state),
                      TAlphaColorRec.White);
  Self.lblAuditState.Material.BackColor.BorderColor.Color:=
    GetAuditStateColor(TAuditState(GlobalManager.User.audit_state),
                      TAlphaColorRec.White);


  if GlobalManager.User.is_emp=1 then
  begin
//      //员工
//      Self.lbMenu.Prop.Items.FindItemByCaption('我的佣金').Visible:=False;
//      Self.lbMenu.Prop.Items.FindItemByCaption('申请介绍人').Visible:=False;
//      Self.lbMenu.Prop.Items.FindItemByCaption('邀请码').Visible:=False;
//      Self.lbMenu.Prop.Items.FindItemByCaption('实名认证').Visible:=False;
//      Self.lbMenu.Prop.Items.FindItemByCaption('我的银行卡').Visible:=False;
//      Self.lbMenu.Prop.Items.FindItemByCaption('合同须知').Visible:=False;
//
//
//      Self.lbMenu.Prop.Items.FindItemByCaption('查询汇总').Visible:=True;
//      Self.lbMenu.Prop.Items.FindItemByCaption('设置').Visible:=True;
//      Self.lbMenu.Prop.Items.FindItemByCaption('我介绍的人').Visible:=False;
  end
  else
  begin
//      //酒店经理
//      if (GlobalManager.User.audit_state=Ord(asDefault))
//        or (GlobalManager.User.audit_state=Ord(asAuditReject)) then
//      begin
//        //未审核,或审核拒绝,需要显示申请介绍人
//        //没有介绍人
//        Self.lbMenu.Prop.Items.FindItemByCaption('申请介绍人').Visible:=True;
//        Self.lbMenu.Prop.Items.FindItemByCaption('申请介绍人').PicImageIndex:=0;
//      end
//      else
//      begin
//        Self.lbMenu.Prop.Items.FindItemByCaption('申请介绍人').Visible:=False;
//        Self.lbMenu.Prop.Items.FindItemByCaption('申请介绍人').PicImageIndex:=-1;
//      end;
//
//
//      if (GlobalManager.User.cert_audit_state=Ord(asDefault))
//        or (GlobalManager.User.cert_audit_state=Ord(asAuditReject)) then
//      begin
//        //实名认证未审核,或审核拒绝,需要显示实名认证
//        Self.lbMenu.Prop.Items.FindItemByCaption('实名认证').Visible:=True;
//        Self.lbMenu.Prop.Items.FindItemByCaption('实名认证').PicImageIndex:=0;
//      end
//      else
//      begin
//        Self.lbMenu.Prop.Items.FindItemByCaption('实名认证').Visible:=False;
//        Self.lbMenu.Prop.Items.FindItemByCaption('实名认证').PicImageIndex:=-1;
//      end;

//      //提交实名认证和审核通过才显示合同须知
//      if GlobalManager.User.cert_audit_state<>0 then
//      begin
//
//        Self.lbMenu.Prop.Items.FindItemByCaption('合同须知').Visible:=
//            GlobalManager.User.audit_state=Ord(asAuditPass);
//
//      end
//      else
//      begin
//        Self.lbMenu.Prop.Items.FindItemByCaption('合同须知').Visible:=False;
//      end;
//
//
//      //审核通过
//      //才显示我的佣金
//      Self.lbMenu.Prop.Items.FindItemByCaption('我的佣金').Visible:=
//          GlobalManager.User.audit_state=Ord(asAuditPass);

//      //才显示我的介绍人
//      Self.lbMenu.Prop.Items.FindItemByCaption('我介绍的人').Visible:=
//          GlobalManager.User.audit_state=Ord(asAuditPass);
//      //才显示有邀请码,
//      Self.lbMenu.Prop.Items.FindItemByCaption('邀请码').Visible:=
//          GlobalManager.User.audit_state=Ord(asAuditPass);


      Self.lbMenu.Prop.Items.FindItemByCaption('我的银行卡').Visible:=True;
//      Self.lbMenu.Prop.Items.FindItemByCaption('查询汇总').Visible:=False;
//      Self.lbMenu.Prop.Items.FindItemByCaption('设置').Visible:=False;
  end;

end;


procedure TFrameMy.OnReturnFromApplyIntroducerFrame(Frame: TFrame);
begin
  GlobalMainFrame.SyncMyInfo;
end;

procedure TFrameMy.OnReturnFromFillInfoFrame(Frame: TFrame);
begin
  GlobalMainFrame.SyncMyInfo;
end;

end.
