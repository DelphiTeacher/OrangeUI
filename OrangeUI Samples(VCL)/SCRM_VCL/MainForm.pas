unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uSkinWindowsForm, ExtCtrls, pngimage, uSkinWindowsControl,
  uSkinPanelType, uDrawCanvas, uSkinItems, uSkinScrollControlType,

  Math,
  uSkinBufferBitmap,
  uGraphicCommon,
  uDrawTextParam,
  ListItemStyle_IconLeft_CaptionRight,
  ListItemStyle_MailList,
//  ListItemStyle_MailListWithTag,
  uSkinItemDesignerPanelType,

//  ListItemStyle_CustomerInfo,
  ListItemStyle_ContactInfo,
  ListItemStyle_CompanyInfo,
  ListItemStyle_TreeMainMenu_LabelAndArrow,
//  EasyServiceCommonMaterialDataMoudle_VCL,
  uGDIPlusDrawCanvas,
  uUrlPicture,
  uIdHttpControl,

//  CustomerInfoFrame,

  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uSkinMaterial, uSkinPageControlType, uSkinImageType, uSkinLabelType, StdCtrls,
  uSkinWindowsMemo, uSkinWindowsEdit, uSkinEditType, Menus;

type
  TfrmMain = class(TForm)
    fsdForm: TSkinWinForm;
    imgLogo: TImage;
    pnlClient: TSkinWinPanel;
    lbSubMenu: TSkinWinListBox;
    btnClose_Material: TSkinButtonDefaultMaterial;
    imgUserHead: TImage;
    lbMainMenu: TSkinWinListBox;
    pcRightInfo: TSkinWinPageControl;
    tsInformation: TSkinTabSheet;
    tsQuickReply: TSkinTabSheet;
    tsTask: TSkinTabSheet;
    btnAddSubMenu: TSkinWinButton;
    tsMailList: TSkinTabSheet;
    SkinWinPanel1: TSkinWinPanel;
    SkinWinEdit1: TSkinWinEdit;
    lbContact: TSkinWinListBox;
    btnSearch: TSkinWinButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    pmMore: TPopupMenu;
    miChatHistory: TMenuItem;
    miDelete: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    btnDeleteRightTabSheet: TSkinWinButton;
    btnAddRightTabSheet: TSkinWinButton;
    SkinTheme1: TSkinTheme;
    DrawCanvasSetting1: TDrawCanvasSetting;
    Timer1: TTimer;
    btnCreateCustomer: TSkinWinButton;
    edtCompany: TSkinWinEdit;
    edtEmail: TSkinWinEdit;
    edtPhoneNO: TSkinWinEdit;
    imgCustomerUserHead: TSkinWinImage;
    lblCompany: TSkinWinLabel;
    lblCustomerName: TSkinWinLabel;
    lblCustomerPhone: TSkinWinLabel;
    memProgress: TSkinWinMemo;
    SkinWinLabel1: TSkinWinLabel;
    SkinWinLabel2: TSkinWinLabel;
    SkinWinLabel3: TSkinWinLabel;
    pcLeftAlign: TSkinPageControlDefaultMaterial;
    pcMainFramePageControlMaterial: TSkinPageControlDefaultMaterial;
    pcMain_Material: TSkinPageControlDefaultMaterial;
    pcOrder_Material: TSkinPageControlDefaultMaterial;
    pcLeftMargin2: TSkinPageControlDefaultMaterial;
    procedure btnMinClick(Sender: TObject);
    procedure btnNormalClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lbMainMenuClickItem(AItem: TSkinItem);
    procedure lbSubMenuClickItem(AItem: TSkinItem);
    procedure lbSubMenuPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure lbSubMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbSubMenuClickItemDesignerPanelChild(Sender: TObject;
      AItem: TBaseSkinItem; AItemDesignerPanel: TSkinItemDesignerPanel;
      AChild: TControl);
    procedure btnAddSubMenuClick(Sender: TObject);
    procedure btnCreateCustomerClick(Sender: TObject);
    procedure fsdFormSyncSystemControls(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure lbContactClickItemDesignerPanelChild(Sender: TObject;
      AItem: TBaseSkinItem; AItemDesignerPanel: TSkinItemDesignerPanel;
      AChild: TControl);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure btnDeleteRightTabSheetClick(Sender: TObject);
    procedure btnAddRightTabSheetClick(Sender: TObject);
    procedure lbSubMenuMouseLeave(Sender: TObject);
    procedure lbContactPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
//    FCustomerInfoFrame:TFrameCustomerInfo;
    { Private declarations }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure Load;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnAddRightTabSheetClick(Sender: TObject);
var
  ATabSheet: TSkinWinTabSheet;
begin
  ATabSheet:=TSkinWinTabSheet.Create(Self);
  ATabSheet.Prop.PageControl:=Self.pcRightInfo;
  ATabSheet.Caption:='新分页';
  Self.pcRightInfo.Prop.ActivePage:=ATabSheet;
end;

procedure TfrmMain.btnAddSubMenuClick(Sender: TObject);
var
  ASkinItem:TSkinItem;
begin
  Self.lbSubMenu.Prop.Items.BeginUpdate;
  try
    ASkinItem:=Self.lbSubMenu.Prop.Items.Add;
    ASkinItem.Icon.Assign(Self.imgCustomerUserHead.Prop.Picture);
    ASkinItem.Caption:='标题';
  finally
    Self.lbSubMenu.Prop.Items.EndUpdate;
  end;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnCreateCustomerClick(Sender: TObject);
begin
  //
end;

procedure TfrmMain.btnMinClick(Sender: TObject);
begin
  WindowState:=wsMinimized;
end;

procedure TfrmMain.btnNormalClick(Sender: TObject);
begin
  if WindowState=wsNormal then
  begin
    WindowState:=wsMaximized;
  end
  else
  begin
    WindowState:=wsNormal;
  end;
end;

procedure TfrmMain.btnSearchClick(Sender: TObject);
begin
  ShowMessage('搜索');
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //无边框,但也不能拉伸
//  Params.Style:=Params.Style and not WS_THICKFRAME;// or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  ASkinItem:TSkinItem;
  ACaptionArray:Array of String;
  AColorArray:Array of TColor;
  I: Integer;
begin


  /// <summary>
  ///   <para>
  ///     是否使用系统默认的字体
  ///   </para>
  ///   <para>
  ///     Whetehr use default font
  ///   </para>
  /// </summary>
  GlobalIsUseDefaultFontFamily:=True;

  /// <summary>
  ///   <para>
  ///     默认的字体名称
  ///   </para>
  ///   <para>
  ///     Default font name
  ///   </para>
  /// </summary>
  GlobalDefaultFontFamily:='微软雅黑';


//  //客户信息
//  FCustomerInfoFrame:=TFrameCustomerInfo.Create(Self);
//  FCustomerInfoFrame.Parent:=tsInformation;
//  FCustomerInfoFrame.Align:=alClient;



//  //客户标签测试
//  ACaptionArray:=['成交客户','意向客户','已审核供应商','已用SAP','a','改约客户','的迹象大大的磊'];
//  AColorArray:=[clBlue,clBlack,clRed,clGray,clGreen];
//  Self.lbCustomerTags.Prop.Items.BeginUpdate;
//  try
//    for I := 0 to Length(ACaptionArray)-1 do
//    begin
//      ASkinItem:=Self.lbCustomerTags.Prop.Items.Add;
//      ASkinItem.Caption:=ACaptionArray[I];
//      ASkinItem.Width:=Ceil(uSkinBufferBitmap.GetStringWidth(ACaptionArray[I],8))+50;
//      ASkinItem.Color:=AColorArray[I mod Length(AColorArray)]
//    end;
//
//  finally
//    lbCustomerTags.Prop.Items.EndUpdate();
//  end;




  //通讯录标签测试
  Self.lbContact.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lbContact.Prop.Items.Count-1 do
    begin
      if i mod 3 = 0 then Self.lbContact.Prop.Items[I].SubItems.Values['tags']:='[10159,10979,11016,10159,10979,11016]';
      if i mod 3 = 1 then Self.lbContact.Prop.Items[I].SubItems.Values['tags']:='[10979,11016]';
      if i mod 3 = 2 then Self.lbContact.Prop.Items[I].SubItems.Values['tags']:='[11016]';

      //设置Item的高度
      Self.lbContact.Prop.CalcItemAutoSize(Self.lbContact.Prop.Items[I])
    end;
  finally
    Self.lbContact.Prop.Items.EndUpdate();
  end;



  Self.lbSubMenu.Prop.FDefaultItemStyleSetting.IsUseCache:=False;

//  RoundSkinPicture(imgHead.Prop.Picture
//
//                    );
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Load;
end;

procedure TfrmMain.fsdFormSyncSystemControls(Sender: TObject);
begin
  fsdForm.CloseSysBtn.DirectUIVisible:=True;
  fsdForm.MaxRestoreSysBtn.DirectUIVisible:=True;
  fsdForm.MinSysBtn.DirectUIVisible:=True;


end;

procedure TfrmMain.lbMainMenuClickItem(AItem: TSkinItem);
begin
  ShowMessage(AItem.Caption);
end;

procedure TfrmMain.lbSubMenuClickItem(AItem: TSkinItem);
begin
  //ShowMessage(AItem.Caption);

end;

procedure TfrmMain.lbSubMenuClickItemDesignerPanelChild(Sender: TObject;
  AItem: TBaseSkinItem; AItemDesignerPanel: TSkinItemDesignerPanel;
  AChild: TControl);
begin
  if AChild.Name='imgRefresh' then
  begin
    ShowMessage('刷新');
  end;
end;

procedure TfrmMain.lbSubMenuMouseLeave(Sender: TObject);
begin
  //鼠标离开的时候,MouseOverItem要设置为0,要重绘一下
  if lbSubMenu.Prop.MouseOverItem<>nil then
  begin
    lbSubMenu.Prop.MouseOverItem.IsBufferNeedChange:=True;
    lbSubMenu.Prop.MouseOverItem:=nil;
  end;
  Self.lbSubMenu.Repaint;
end;

procedure TfrmMain.lbSubMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  I: Integer;
begin
  //鼠标移动的时候,要切换MouseOverItem,要重绘一下
  for I := 0 to lbSubMenu.Prop.Items.Count - 1 do
  begin
    lbSubMenu.Prop.Items[I].IsBufferNeedChange:=True;
  end;
  lbSubMenu.Repaint;
end;

procedure TfrmMain.lbSubMenuPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin

  if (AItemDesignerPanel<>nil) and (AItemDesignerPanel.Parent is TFrameListItemStyle_IconLeft_CaptionRight) then
  begin
    //如果当前绘制的Item为鼠标所在的Item则显示
    TFrameListItemStyle_IconLeft_CaptionRight(AItemDesignerPanel.Parent).imgRefresh.Visible:=(AItem=lbSubMenu.Prop.MouseOverItem);
    TFrameListItemStyle_IconLeft_CaptionRight(AItemDesignerPanel.Parent).btnDelete.Visible:=(AItem=lbSubMenu.Prop.MouseOverItem);


  end;

end;

procedure TfrmMain.Load;
begin
//  Self.FCustomerInfoFrame.Load;
end;


procedure TfrmMain.N1Click(Sender: TObject);
begin
  ShowMessage('聊天记录');
end;

procedure TfrmMain.N2Click(Sender: TObject);
begin
  ShowMessage('删除');
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  ShowMessage('转交');
end;

procedure TfrmMain.N4Click(Sender: TObject);
begin
  ShowMessage('建群');
end;

procedure TfrmMain.N5Click(Sender: TObject);
begin
  ShowMessage('客户详情');
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
//  SetFormShadow(Handle,True,Self.fsdForm.FIsSetedFormShadow);

end;

procedure TfrmMain.btnDeleteRightTabSheetClick(Sender: TObject);
begin
  //删除右边分页测试
  Self.pcRightInfo.Prop.ActivePage.Free;

end;

procedure TfrmMain.lbContactClickItemDesignerPanelChild(Sender: TObject;
  AItem: TBaseSkinItem; AItemDesignerPanel: TSkinItemDesignerPanel;
  AChild: TControl);
var
  AItemRectF:TRectF;
  APopupPoint:TPoint;
begin
  if AChild.Name='btnChat' then
  begin

    ShowMessage('聊天');
//    TSkinWinButton(AChild).Properties.IsPushed:=False;
//    AItem.IsBufferNeedChange:=True;

  end;

  if AChild.Name='btnMenu' then
  begin

    AItemRectF:=AItem.ItemDrawRect;
    APopupPoint.X:=Ceil(AItemRectF.Right-AChild.Width);
    APopupPoint.Y:=Ceil(AItemRectF.Bottom);
    APopupPoint:=Self.lbContact.ClientToScreen(APopupPoint);

//    ShowMessage('弹出菜单');
    Self.pmMore.Popup(APopupPoint.X,APopupPoint.Y);
//    TSkinWinButton(AChild).Properties.IsPushed:=False;
//    AItem.IsBufferNeedChange:=True;

  end;

end;

procedure TfrmMain.lbContactPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
//var
//  AListItemStyle_MailListFrame:TFrameListItemStyle_MailList;
//  AListItemStyle_MailListWithTagFrame:TFrameListItemStyle_MailListWithTag;
begin

//  if AItemDesignerPanel.Parent is TFrameListItemStyle_MailListWithTag then
//  begin
//    AListItemStyle_MailListWithTagFrame:=TFrameListItemStyle_MailListWithTag(AItemDesignerPanel.Parent);
////    AListItemStyle_MailListWithTagFrame.Load
//  end;

//  //在OnPrepareDrawItem事件中设置设计面板
//  AListItemStyle_MailListFrame:=TFrameListItemStyle_MailList(AItemDesignerPanel.Parent);
//
//  AListItemStyle_MailListFrame.lblTag1.Visible:=False;
//  AListItemStyle_MailListFrame.lblTag2.Visible:=False;
//
//  if AItem.Caption='Mike' then
//  begin
//    AListItemStyle_MailListFrame.lblTag1.Visible:=True;
//    AListItemStyle_MailListFrame.lblTag1.Material.BackColor.FillColor.Color:=clGreen;
//    AListItemStyle_MailListFrame.lblTag1.Caption:='新客户';
//
//    AListItemStyle_MailListFrame.lblTag2.Visible:=True;
//    AListItemStyle_MailListFrame.lblTag2.Material.BackColor.FillColor.Color:=clBlue;
//    AListItemStyle_MailListFrame.lblTag2.Caption:='新成交';
//  end;
//
//
//  if AItem.Caption='who' then
//  begin
//    AListItemStyle_MailListFrame.lblTag1.Visible:=True;
//    AListItemStyle_MailListFrame.lblTag1.Material.BackColor.FillColor.Color:=clBlack;
//    AListItemStyle_MailListFrame.lblTag1.Caption:='黑名单';
//
//  end;

end;

end.
