//convert pas to utf8 by ¥
unit AuditInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uManager,uSkinBufferBitmap,
  uEasyServiceCommon, uSkinFireMonkeyImage, System.ImageList, FMX.ImgList,
  uDrawPicture, uSkinImageList, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas, uSkinItems;

type
  TFrameAuditInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnEdit: TSkinFMXButton;
    lbAuditInfo: TSkinFMXListBox;
    idpDefault: TSkinFMXItemDesignerPanel;
    lblItemName: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    imgAuditPic: TSkinFMXImage;
    imglistAuditState: TSkinImageList;
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
    FOrder:TOrder;
    FHotel:THotel;
  public
    { Public declarations }
//    FrameHistroy:TFrameHistroy;

    destructor Destroy;override;

    procedure LoadOrder(AOrder:TOrder);
    procedure LoadHotel(AHotel:THotel);
    procedure Clear;
  end;

var
  GlobalAuditInfoFrame:TFrameAuditInfo;


implementation

{$R *.fmx}

procedure TFrameAuditInfo.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameAuditInfo.Clear;
begin
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核操作人').Detail:='';
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核时间').Detail:='';
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Detail:='';
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核意见').Detail:='';
  Self.imgAuditPic.Prop.Picture.ClearPicture;
end;

destructor TFrameAuditInfo.Destroy;
begin
  FreeAndNil(Self.lbAuditInfo);
  inherited;
end;

procedure TFrameAuditInfo.LoadOrder(AOrder: TOrder);
begin
  FOrder:=AOrder;



  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Icon.ImageIndex:=-1;
  if (FOrder.audit_state=Ord(asAuditPass)) then
  begin
    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Icon.ImageIndex:=1;
  end;
  if (FOrder.audit_state=Ord(asAuditReject)) then
  begin
    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Icon.ImageIndex:=0;
  end;

//  if GetAuditStateStr(TAuditState(FOrder.audit_state))='审核通过' then
//  begin
//    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Pic:=Self.imglAuditIcon.PictureList.Items[1];
//  end
//  else if GetAuditStateStr(TAuditState(FOrder.audit_state))='审核拒绝' then
//  begin
//    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Pic:=Self.imglAuditIcon.PictureList.Items[0];
//  end;

  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核操作人').Detail:=FOrder.audit_user_name;
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核时间').Detail:=FOrder.audit_time;
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Detail:='';// 不显示
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核意见').Detail:=FOrder.audit_remark;
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核意见').Height:=
//                                GetStringHeight(FOrder.audit_remark,
//                                RectF(0,0,Self.lblItemDetail.Width,MaxInt))+11+11;
                                GetSuitContentHeight(lblItemDetail.Width,
                                            FOrder.audit_remark,
                                            14,
                                            Self.lbAuditInfo.Prop.ItemHeight
                                            );


end;

procedure TFrameAuditInfo.LoadHotel(AHotel: THotel);
begin
  FHotel:=AHotel;


  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Icon.ImageIndex:=-1;
  if (FHotel.audit_state=Ord(asAuditPass)) then
  begin
    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Icon.ImageIndex:=1;
  end;
  if (FHotel.audit_state=Ord(asAuditReject)) then
  begin
    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Icon.ImageIndex:=0;
  end;


  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核操作人').Detail:=FHotel.audit_user_name;
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核时间').Detail:=FHotel.audit_time;
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Detail:='';// 不显示
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核意见').Detail:=FHotel.audit_remark;
  Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核意见').Height:=
//                                GetStringHeight(FHotel.audit_remark,
//                                RectF(0,0,Self.lblItemDetail.Width,MaxInt))+11+11;
                                GetSuitContentHeight(lblItemDetail.Width,
                                            FHotel.audit_remark,
                                            14,
                                            Self.lbAuditInfo.Prop.ItemHeight
                                            );


//  if GetAuditStateStr(TAuditState(FHotel.audit_state))='审核通过' then
//  begin
//    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Pic:=Self.imglAuditIcon.PictureList.Items[1];
//  end
//  else if GetAuditStateStr(TAuditState(FHotel.audit_state))='审核拒绝' then
//  begin
//    Self.lbAuditInfo.Prop.Items.FindItemByCaption('审核结果').Pic:=Self.imglAuditIcon.PictureList.Items[0];
//  end;


end;

end.
