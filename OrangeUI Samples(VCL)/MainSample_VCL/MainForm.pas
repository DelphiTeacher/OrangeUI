unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uSkinWindowsForm, ExtCtrls, pngimage, uSkinWindowsControl,
  uSkinPanelType, uDrawCanvas, uSkinItems, uSkinScrollControlType,

  System.Types,
  Math,
  uSkinBufferBitmap,
  uGraphicCommon,
  uDrawTextParam,
  ListItemStyle_Default,
  ListItemStyle_IconLeft_CaptionRight,
  ListItemStyle_MailList,
//  ListItemStyle_MailListWithTag,
  uSkinItemDesignerPanelType,

//  ListItemStyle_CustomerInfo,
//  ListItemStyle_ContactInfo,
//  ListItemStyle_CompanyInfo,
  ListItemStyle_TreeMainMenu_LabelAndArrow,
  ListItemStyle_IconCaptionLeft_DetailRight,
  ListItemStyle_IconCaptionLeft_NotifyNumberRight,
  ListItemStyle_IconCaptionLeft_NotifyIconRight,
  ListItemStyle_IconCaptionLeft_ArrowRight,
  EasyServiceCommonMaterialDataMoudle_VCL,
  uGDIPlusDrawCanvas,
  uUrlPicture,
  uIdHttpControl,



  //数据看板
  DashBoard_AnalyseFrame,
  DashBoard_ProjectsFrame,


  //基本控件
//  CustomerInfoFrame,
//  uAddPictureListSubFrame,
  ButtonFrame,
  MemoFrame,
  EditFrame,
  CheckBoxFrame,
  PageControlFrame,
  TestChartFrame,



  MultiSelectFrame_VCL,
  uMultiSelectFrame,

  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uSkinMaterial, uSkinPageControlType, uSkinImageType, uSkinLabelType, StdCtrls,
  uSkinWindowsMemo, uSkinWindowsEdit, uSkinEditType, Menus, uSkinListViewType,
  uSkinTreeViewType, Vcl.ExtDlgs, uSkinNotifyNumberIconType;


type
  TfrmMain = class(TForm)
    fsdForm: TSkinWinForm;
    lbSubMenu: TSkinWinTreeView;
    imgUserHead: TImage;
    SkinTheme1: TSkinTheme;
    DrawCanvasSetting1: TDrawCanvasSetting;
    btnShowHideMainMenu: TSkinWinButton;
    pnlSearch: TSkinWinPanel;
    imgSearchIcon: TSkinWinImage;
    edtSearch: TEdit;
    btnSearch: TSkinWinButton;
    btnSelectCountry: TSkinWinButton;
    nniMessage: TSkinWinNotifyNumberIcon;
    btnMore: TSkinWinButton;
    btnSetting: TSkinWinButton;
    btnMy: TSkinWinButton;
    sbClient: TScrollBox;
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
    procedure btnAddRightTabSheetClick(Sender: TObject);
    procedure lbSubMenuMouseLeave(Sender: TObject);
    procedure lbContactPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCurrentFrame:TFrame;
    FLastHintItem:TSkinItem;
//    FCustomerInfoFrame:TFrameCustomerInfo;
//    FCustomerInfoFrame:TFrameCustomerInfo;
//    OpenPictureDialog1: TOpenPictureDialog;
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
//var
//  ATabSheet: TSkinWinTabSheet;
begin
//  ATabSheet:=TSkinWinTabSheet.Create(Self);
//  ATabSheet.Prop.PageControl:=Self.pcRightInfo;
//  ATabSheet.Caption:='新分页';
//  Self.pcRightInfo.Prop.ActivePage:=ATabSheet;
end;

procedure TfrmMain.btnAddSubMenuClick(Sender: TObject);
//var
//  ASkinItem:TSkinItem;
begin
//  Self.lbSubMenu.Prop.Items.BeginUpdate;
//  try
//    ASkinItem:=Self.lbSubMenu.Prop.Items.Add;
//    ASkinItem.Icon.Assign(Self.imgCustomerUserHead.Prop.Picture);
//    ASkinItem.Caption:='标题';
//  finally
//    Self.lbSubMenu.Prop.Items.EndUpdate;
//  end;
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




//  //通讯录标签测试
//  Self.lbContact.Prop.Items.BeginUpdate;
//  try
//    for I := 0 to Self.lbContact.Prop.Items.Count-1 do
//    begin
//      if i mod 3 = 0 then Self.lbContact.Prop.Items[I].SubItems.Values['tags']:='[10159,10979,11016,10159,10979,11016]';
//      if i mod 3 = 1 then Self.lbContact.Prop.Items[I].SubItems.Values['tags']:='[10979,11016]';
//      if i mod 3 = 2 then Self.lbContact.Prop.Items[I].SubItems.Values['tags']:='[11016]';
//
//      //设置Item的高度
//      Self.lbContact.Prop.CalcItemAutoSize(Self.lbContact.Prop.Items[I])
//    end;
//  finally
//    Self.lbContact.Prop.Items.EndUpdate();
//  end;



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

  FreeAndNil(FCurrentFrame);


  //数据看板


  //分析
  if (AItem.Name='dashboard_analyse') then
  begin
    FCurrentFrame:=TFrameDashBoard_Analyse.Create(Self);
  end;
  //项目
  if (AItem.Name='dashboard_projects') then
  begin
    FCurrentFrame:=TFrameDashBoard_Projects.Create(Self);
  end;






  //按钮
  if AItem.Name='button' then
  begin
    FCurrentFrame:=TFrameButton.Create(Self);
  end;
  //文本框
  if AItem.Name='edit' then
  begin
    FCurrentFrame:=TFrameEdit.Create(Self);
  end;
  //备注框
  if AItem.Name='memo' then
  begin
    FCurrentFrame:=TFrameMemo.Create(Self);
  end;
  //复选框
  if AItem.Name='checkbox' then
  begin
    FCurrentFrame:=TFrameCheckBox.Create(Self);
  end;
  //分页控件
  if AItem.Name='pagecontrol' then
  begin
    FCurrentFrame:=TFramePageControl.Create(Self);
  end;






  //图片多选框
  if AItem.Name='add_picture_list_sub_frame' then
  begin
//      Self.FCurrentFrame:=TFrameAddPictureListSub.Create(Self);
//
//      TFrameAddPictureListSub(FCurrentFrame).pnlToolBar.Visible:=False;
//      TFrameAddPictureListSub(FCurrentFrame).lvPictures.Align:=alClient;
//      TFrameAddPictureListSub(FCurrentFrame).lvPictures.Margins.Left:=0;
//      TFrameAddPictureListSub(FCurrentFrame).Init(
//                                                  '',
//                                                  [],//
//                                                  [],//
//                                                  False,//不裁剪
//                                                  0,
//                                                  0,
//                                                  3//最多3张
//                                                  );




  end;
  //多选页面
  if AItem.Name='multi_select_frame' then
  begin
    FCurrentFrame:=TFrameMultiSelect.Create(Self);
    TFrameMultiSelect(FCurrentFrame).lbList.Prop.ItemDesignerPanel:=nil;
    TFrameMultiSelect(FCurrentFrame).lbList.Prop.DefaultItemStyle:='IconCaptionLeft_DetailRight';
    TFrameMultiSelect(FCurrentFrame).Init('点菜','鱼香肉丝,红烧肉,番茄炒蛋','红烧肉');
    Self.FCurrentFrame.Parent:=Self.sbClient;
    FCurrentFrame.Left:=Self.lbSubMenu.Width;
    FCurrentFrame.Top:=0;
    Exit;
  end;


  if FCurrentFrame=nil then
  begin
    Exit;
  end;

  Self.FCurrentFrame.Parent:=Self.sbClient;
  Self.FCurrentFrame.Align:=alTop;

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
//  //鼠标离开的时候,MouseOverItem要设置为0,要重绘一下
//  if lbSubMenu.Prop.MouseOverItem<>nil then
//  begin
//    lbSubMenu.Prop.MouseOverItem.IsBufferNeedChange:=True;
//    lbSubMenu.Prop.MouseOverItem:=nil;
//  end;
//  Self.lbSubMenu.Repaint;
end;

procedure TfrmMain.lbSubMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
//var
//  I: Integer;
//  AItem:TSkinItem;
//  AScreenPos:TPoint;
begin
//  AItem:=Self.lbSubMenu.Prop.VisibleItemAt(X,Y);
//  if FLastHintItem<>AItem then
//  begin
//    FLastHintItem:=AItem;
//    if AItem<>nil then
//    begin
//      //设置提示
//      Self.lbSubMenu.Hint:=AItem.Caption;
//      Self.lbSubMenu.ShowHint:=True;
//      //显示提示
//      AScreenPos:=Point(X,Y);
//      AScreenPos:=Self.lbSubMenu.ClientToScreen(AScreenPos);
//      Application.ActivateHint(AScreenPos);
//
//
//    end
//    else
//    begin
//      //不显示提示
//      Self.lbSubMenu.Hint:='';
//      Self.lbSubMenu.ShowHint:=False;
//    end;
//  end;
//
//
//
//  //鼠标移动的时候,要切换MouseOverItem,要重绘一下
//  for I := 0 to lbSubMenu.Prop.Items.Count - 1 do
//  begin
//    lbSubMenu.Prop.Items[I].IsBufferNeedChange:=True;
//  end;
//  lbSubMenu.Repaint;
end;

procedure TfrmMain.lbSubMenuPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin

//  if (AItemDesignerPanel<>nil) and (AItemDesignerPanel.Parent is TFrameListItemStyle_IconLeft_CaptionRight) then
//  begin
//    //如果当前绘制的Item为鼠标所在的Item则显示
//    TFrameListItemStyle_IconLeft_CaptionRight(AItemDesignerPanel.Parent).imgRefresh.Visible:=(AItem=lbSubMenu.Prop.MouseOverItem);
//    TFrameListItemStyle_IconLeft_CaptionRight(AItemDesignerPanel.Parent).btnDelete.Visible:=(AItem=lbSubMenu.Prop.MouseOverItem);
//
//
//  end;

end;

procedure TfrmMain.Load;
var
  ATestChartFrame:TFrameTestChart;
begin
//  Self.FCustomerInfoFrame.Load;

  Self.lbSubMenu.Prop.Items.FindItemByName('dashboard_analyse').Selected:=True;
  Self.lbSubMenuClickItem(Self.lbSubMenu.Prop.Items.FindItemByName('dashboard_analyse'));


//  ATestChartFrame:=TFrameTestChart.Create(Self);
//  ATestChartFrame.Parent:=Self.sbClient;
//  ATestChartFrame.Align:=alClient;


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

//  if AChild.Name='btnMenu' then
//  begin
//
//    AItemRectF:=AItem.ItemDrawRect;
//    APopupPoint.X:=Ceil(AItemRectF.Right-AChild.Width);
//    APopupPoint.Y:=Ceil(AItemRectF.Bottom);
//    APopupPoint:=Self.lbContact.ClientToScreen(APopupPoint);
//
////    ShowMessage('弹出菜单');
//    Self.pmMore.Popup(APopupPoint.X,APopupPoint.Y);
////    TSkinWinButton(AChild).Properties.IsPushed:=False;
////    AItem.IsBufferNeedChange:=True;
//
//  end;

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
