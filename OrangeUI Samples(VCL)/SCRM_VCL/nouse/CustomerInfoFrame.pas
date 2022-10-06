unit CustomerInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, uDrawCanvas, uSkinItems,

  Math,
  uSkinBufferBitmap,
  uGraphicCommon,
  uDrawTextParam,
  ListItemStyle_IconLeft_CaptionRight,
//  ListItemStyle_MailList,
  uSkinItemDesignerPanelType,

  ListItemStyle_CustomerInfo,
  ListItemStyle_ContactInfo,
  ListItemStyle_CompanyInfo,
  ListItemStyle_TreeMainMenu_LabelAndArrow,
  ListItemStyle_CaptionDetailItem,
  EasyServiceCommonMaterialDataMoudle_VCL,
  uGDIPlusDrawCanvas,
  uUrlPicture,
  uIdHttpControl,

  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinTreeViewType, uSkinWindowsControl, uSkinButtonType, uDrawPicture,
  uSkinImageList;

type
  TFrameCustomerInfo = class(TFrame)
    SkinWinButton1: TSkinWinButton;
    tvData: TSkinWinTreeView;
    imglistPictures: TSkinImageList;
    procedure tvDataClickItem(AItem: TSkinItem);
  private
//    procedure LoadData(vDatas: Variant);
    { Private declarations }
  public
    FCustomerInfoListItemStyleFrame:TFrameListItemStyle_CustomerInfo;
//    FCustomerInfoItem:TSkinItem;
    FCustomerOwnerItem:TSkinItem;
    FCompanyInfoItem:TSkinItem;
    FParentItem:TSkinTreeViewItem;
//    FFrameListItemStyle_CustomerInfo:TFrameListItemStyle_CustomerInfo;
    procedure Clear;
    procedure Load;
    procedure SyncParentItem(AExpanded:Boolean);
//    procedure LoadData(vDatas: Variant);
    constructor Create(AOwner:TComponent);override;
    procedure ClearHead;

    procedure SyncCustomerInfoListItemStyleFrameHeight;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrameCustomerInfo }

procedure TFrameCustomerInfo.Clear;
//var
//  AItem:TSkinItem;
//  AParent:TSkinTreeViewItem;
//  AFrameListItemStyle_CustomerInfo:TFrameListItemStyle_CustomerInfo;
begin

  Self.tvData.Prop.Items.BeginUpdate;
  try
    //��ϵ��
//    FCustomerInfoItem:=Self.tvData.Prop.Items.FindItemByName('customer_info');
//    if FCustomerInfoItem<>nil then
//    begin
//      //��ϵ������
//      FCustomerInfoItem.Caption:='İ���ͻ�';
//      //��ϵ�˹�˾
//      FCustomerInfoItem.Detail:='';
////      FCustomerInfoItem.Icon.Clear;
////      FCustomerInfoItem.Icon.Url:='';
////      FCustomerInfoItem.Icon.SkinImageList:=Self.imglistPictures;
////      FCustomerInfoItem.Icon.ImageIndex:=0;
//
////      //��ϵ�˵ı�ǩ
////      FFrameListItemStyle_CustomerInfo:=TFrameListItemStyle_CustomerInfo(Self.tvData.Prop.FItem1ItemStyleSetting.GetItemStyleFrameCache(FCustomerInfoItem).FItemStyleFrame);
////      FFrameListItemStyle_CustomerInfo.lvTags.Prop.Items[0].Visible:=False;
////      FFrameListItemStyle_CustomerInfo.lvTags.Prop.Items.ClearItemsByType(sitDefault);
//    end;
//    FCustomerInfoListItemStyleFrame.imgHead.Prop.Picture.Clear;
//    FCustomerInfoListItemStyleFrame.imgHead.Prop.Picture.SkinImageList:=Self.imglistPictures;
//    FCustomerInfoListItemStyleFrame.imgHead.Prop.Picture.ImageIndex:=0;

    //���ز�����ͻ���ǩ
//      FCustomerInfoListItemStyleFrame.lvTags.Visible:=False;
    FCustomerInfoListItemStyleFrame.lvTags.Prop.Items.ClearItemsByType(sitDefault);
    FCustomerInfoListItemStyleFrame.lvTags.Prop.Items.FindItemByName('space').Visible:=False;
    FCustomerInfoListItemStyleFrame.lvTags.Prop.Items.FindItemByName('memo').Visible:=False;
    FCustomerInfoListItemStyleFrame.lvTags.Height:=FCustomerInfoListItemStyleFrame.lvTags.Prop.CalcContentHeight;

//      FCustomerInfoListItemStyleFrame.pnlOperation.Visible:=True;

    FCustomerInfoListItemStyleFrame.Clear;
    Self.FCustomerInfoListItemStyleFrame.SyncButtonBounds;

    SyncCustomerInfoListItemStyleFrameHeight;




    Self.tvData.Prop.Items.FindItemByName('row_devide_line').Visible:=False;

    //��ϵ�˵�ӵ������Ϣ
    FCustomerOwnerItem:=Self.tvData.Prop.Items.FindItemByName('customer_owner');
    if FCustomerOwnerItem<>nil then
    begin
      //ӵ��������
      FCustomerOwnerItem.Caption:='-';
      //��ϵ�˹�˾
      FCustomerOwnerItem.Detail:='������';

      FCustomerOwnerItem.Detail1:='-';
      FCustomerOwnerItem.Detail2:='-';
      FCustomerOwnerItem.Detail3:='-';

//      FCustomerOwnerItem.Visible:=False;
    end;


    //��˾��Ϣ
    FCompanyInfoItem:=Self.tvData.Prop.Items.FindItemByName('company_info');
    if FCompanyInfoItem<>nil then
    begin
      //�ͻ����
      FCompanyInfoItem.Caption:='��˾��Ϣ';
      //�ͻ�
      FCompanyInfoItem.Detail1:='';
      FCompanyInfoItem.Detail2:='';


      FCompanyInfoItem.Visible:=False;
    end;
    Self.tvData.Prop.Items.FindItemByName('company_state').Visible:=False;
    Self.tvData.Prop.Items.FindItemByName('company_seas_flag').Visible:=False;
    Self.tvData.Prop.Items.FindItemByName('company_country').Visible:=False;

    Self.tvData.Prop.Items.FindItemByName('company_creator').Visible:=False;
    Self.tvData.Prop.Items.FindItemByName('company_create_time').Visible:=False;
    Self.tvData.Prop.Items.FindItemByName('company_editor').Visible:=False;
    Self.tvData.Prop.Items.FindItemByName('company_edit_time').Visible:=False;
    Self.tvData.Prop.Items.FindItemByName('company_last_tracker').Visible:=False;
    Self.tvData.Prop.Items.FindItemByName('company_last_track_time').Visible:=False;




    //������ϵ���б�
    FParentItem:=Self.tvData.Prop.Items.FindItemByName('parent_item');
    FParentItem.Childs.Clear();
    FParentItem.Visible:=False;

  finally
    Self.tvData.Prop.Items.EndUpdate();
  end;


end;

procedure TFrameCustomerInfo.ClearHead;
begin
  //��ϵ��
//  FCustomerInfoItem:=Self.tvData.Prop.Items.FindItemByName('customer_info');
//  if FCustomerInfoItem<>nil then
//  begin
//    FCustomerInfoItem.Icon.Clear;
//    FCustomerInfoItem.Icon.Url:='';
//    FCustomerInfoItem.Icon.SkinImageList:=Self.imglistPictures;
//    FCustomerInfoItem.Icon.ImageIndex:=0;
//  end;

  FCustomerInfoListItemStyleFrame.imgHead.Prop.Picture.Clear;
  Self.FCustomerInfoListItemStyleFrame.imgHead.Prop.Picture.Url:='';
  Self.FCustomerInfoListItemStyleFrame.imgHead.Prop.Picture.SkinImageList:=Self.imglistPictures;
  Self.FCustomerInfoListItemStyleFrame.imgHead.Prop.Picture.ImageIndex:=0;
  Self.FCustomerInfoListItemStyleFrame.SyncButtonBounds;
end;

constructor TFrameCustomerInfo.Create(AOwner: TComponent);
begin
  inherited;

  FCustomerInfoListItemStyleFrame:=TFrameListItemStyle_CustomerInfo.Create(Self);
  FCustomerInfoListItemStyleFrame.Parent:=Self;
  FCustomerInfoListItemStyleFrame.Align:=alTop;
  FCustomerInfoListItemStyleFrame.Height:=300;

  FCustomerInfoListItemStyleFrame.ItemDesignerPanel.Visible:=True;
  FCustomerInfoListItemStyleFrame.ItemDesignerPanel.Align:=alTop;


  ClearHead;
end;

procedure TFrameCustomerInfo.Load;
//const
//  AColorArray=[$000C7FF2,$006A71FB,$00EF8399,$00DECE3B,$0070D68B,$00C591F9];
//  AColorArray:array of TColor=[$000C7FF2,$006A71FB,$00EF8399,$00DECE3B,$0070D68B,$00C591F9];
var
//  AParent:TSkinTreeViewItem;
  AItem:TSkinItem;
//  AFrameListItemStyle_CustomerInfo:TFrameListItemStyle_CustomerInfo;
  I: Integer;
  ASizeF:TSizeF;
  AColorArray:Array[0..6] of TColor;
begin
  Clear;
//  Exit;

  DownloadItemHttpControlClass:=uIdHttpControl.TSystemHttpControl;
  dmEasyServiceCommonMaterial.btnThemeColorCaptionLeftIconRight.DrawCaptionParam.FontSize:=11;

  Self.tvData.Prop.Items.BeginUpdate;
  try
//    //��ϵ��
//    FCustomerInfoItem:=Self.tvData.Prop.Items.FindItemByName('customer_info');
//    if FCustomerInfoItem<>nil then
//    begin
//      //��ϵ������
//      FCustomerInfoItem.Caption:='����';
//      //��ϵ�˹�˾
//      FCustomerInfoItem.Detail:='Jinhua Jinjie Info.Co., ltd.';
//      FCustomerInfoItem.Icon.Clear;
//      FCustomerInfoItem.Icon.Url:='http://www.orangeui.cn/customer_cases/D%E5%8C%BA/icon.png';
//
////      //��ϵ�˵ı�ǩ
////      FFrameListItemStyle_CustomerInfo:=TFrameListItemStyle_CustomerInfo(Self.tvData.Prop.FItem1ItemStyleSetting.GetItemStyleFrameCache(FCustomerInfoItem).FItemStyleFrame);
////      FFrameListItemStyle_CustomerInfo.lvTags.Prop.Items[0].Visible:=True;
////      FFrameListItemStyle_CustomerInfo.lvTags.Prop.Items[0].Caption:='Jinhua Jinjie Info.Co., ltd.';
////      FFrameListItemStyle_CustomerInfo.lvTags.Prop.Items.ClearItemsByType(sitDefault);
//
//    end;


    //�����ǩ
    AColorArray[0]:=$000C7FF2;
    AColorArray[1]:=$006A71FB;
    AColorArray[2]:=$00EF8399;
    AColorArray[3]:=$00DECE3B;
    AColorArray[4]:=$0070D68B;
    AColorArray[5]:=$00C591F9;
    Self.FCustomerInfoListItemStyleFrame.lvTags.Prop.Items.BeginUpdate;
    try
      for I := 0 to 9-1 do
      begin
        AItem:=Self.FCustomerInfoListItemStyleFrame.lvTags.Prop.Items.Insert(I);
        AItem.Caption:=Copy('HelloWorld,DelphiTeacher',1,I+2);
        GetGlobalDrawTextParam.IsWordWrap:=False;
        GetGlobalDrawTextParam.FontSize:=9;
        AItem.Width:=Ceil(uSkinBufferBitmap.GetStringWidth(AItem.Caption,GetGlobalDrawTextParam.FontSize))+10;
        AItem.Color:=AColorArray[I mod Length(AColorArray)];
      end;
    finally
      Self.FCustomerInfoListItemStyleFrame.lvTags.Prop.Items.EndUpdate();
    end;



    //���뱸ע
    AItem:=Self.FCustomerInfoListItemStyleFrame.lvTags.Prop.Items.FindItemByName('memo');
    if AItem<>nil then
    begin
      AItem.Caption:='HelloWorld,DelphiTeacher!  I''m from USA';
      GetGlobalDrawTextParam.IsWordWrap:=True;
      GetGlobalDrawTextParam.FontSize:=10;
      ASizeF:=uSkinBufferBitmap.GetStringSize(AItem.Caption,
                                            RectF(0,0,Self.FCustomerInfoListItemStyleFrame.lvTags.Width-36,MaxInt),
                                            GetGlobalDrawTextParam);
      AItem.Width:=Ceil(ASizeF.cx);
      AItem.Height:=Ceil(ASizeF.cy);
    end;
    Self.FCustomerInfoListItemStyleFrame.SyncButtonBounds;
    Self.SyncCustomerInfoListItemStyleFrameHeight;


    //��ϵ�˵�ӵ������Ϣ
    FCustomerOwnerItem:=Self.tvData.Prop.Items.FindItemByName('customer_owner');
    if FCustomerOwnerItem<>nil then
    begin
      //ӵ��������
      FCustomerOwnerItem.Caption:='���� ������';
      //��ϵ�˹�˾
      FCustomerOwnerItem.Detail:='������';

      FCustomerOwnerItem.Detail1:='ggggcexx@163.com';
      FCustomerOwnerItem.Detail2:='18957901025';
      FCustomerOwnerItem.Detail3:='+8618957901025';

//      FCustomerOwnerItem.Visible:=True;
    end;

    Self.tvData.Prop.Items.FindItemByName('row_devide_line').Visible:=True;

    //��˾��Ϣ
    FCompanyInfoItem:=Self.tvData.Prop.Items.FindItemByName('company_info');
    if FCompanyInfoItem<>nil then
    begin
      //�ͻ����
      FCompanyInfoItem.Caption:='��˾��Ϣ';
      //�ͻ�
      FCompanyInfoItem.Detail1:='����0020';
      FCompanyInfoItem.Detail2:='�Ϻ�����������޹�˾';

      FCompanyInfoItem.Visible:=True;
    end;

    //������ϵ���б�
    FParentItem:=Self.tvData.Prop.Items.FindItemByName('parent_item');
    FParentItem.Childs.Clear();
    for I := 0 to 2-1 do
    begin
      AItem:=FParentItem.Childs.Add;
      //��ϵ������
      AItem.Caption:='��Ӧ��';
      //
      AItem.Detail:='������';

      AItem.Detail1:='summer@163.com';
      AItem.Detail2:='18006890741';
      AItem.Detail3:='+8618006890741';

    end;

    SyncParentItem(FParentItem.Expanded);

  finally
    Self.tvData.Prop.Items.EndUpdate();
  end;


end;

//procedure TFrameCustomerInfo.LoadData(vDatas: Variant);
//begin
//
//end;

procedure TFrameCustomerInfo.SyncCustomerInfoListItemStyleFrameHeight;
begin
  FCustomerInfoListItemStyleFrame.lvTags.Height:=FCustomerInfoListItemStyleFrame.lvTags.Prop.CalcContentHeight;
  FCustomerInfoListItemStyleFrame.Height:=
    FCustomerInfoListItemStyleFrame.pnlClient.Top
    +FCustomerInfoListItemStyleFrame.lvTags.Top
    +FCustomerInfoListItemStyleFrame.lvTags.Height+10;
end;

procedure TFrameCustomerInfo.SyncParentItem(AExpanded:Boolean);
begin
  if not AExpanded then
  begin
    FParentItem.Caption:='չ����ϵ��('+IntToStr(FParentItem.Childs.Count)+')';
  end
  else
  begin
    FParentItem.Caption:='��£��ϵ��('+IntToStr(FParentItem.Childs.Count)+')';
  end;
  FParentItem.Visible:=(FParentItem.Childs.Count>0);

end;

procedure TFrameCustomerInfo.tvDataClickItem(AItem: TSkinItem);
begin
  SyncParentItem(not FParentItem.Expanded);
end;

end.
