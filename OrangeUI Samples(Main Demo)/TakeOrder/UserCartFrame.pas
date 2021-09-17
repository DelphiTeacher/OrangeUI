//convert pas to utf8 by ¥
unit UserCartFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  Math,

  WaitingFrame,
  MessageBoxFrame,

  uManager,
  uDrawCanvas,
  uSkinItems,
  uBaseList,
  uTimerTask,
  XSuperObject,
  uInterfaceClass,
  uEasyServiceCommon,
  uBaseHttpControl,
  uUIFunction,
  EasyServiceCommonMaterialDataMoudle,

  uSkinListBoxType,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyMultiColorLabel, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyCheckBox, uSkinEditType, uSkinMaterial,
  uSkinButtonType, uSkinCheckBoxType, uSkinMultiColorLabelType, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinPanelType;

type
  TFrameUserCart = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbUserCartGoodsList: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail_2: TSkinFMXMultiColorLabel;
    btnItemDec: TSkinFMXButton;
    edtItemDetail4: TSkinFMXEdit;
    btnItemAdd: TSkinFMXButton;
    btnEdit: TSkinFMXButton;
    pnlBottomBar: TSkinFMXPanel;
    chkBuyAll: TSkinFMXCheckBox;
    btnTakeOrder: TSkinFMXButton;
    chkItemChecked: TSkinFMXCheckBox;
    lblItemDetail3Hint: TSkinFMXLabel;
    lblItemDetail3: TSkinFMXLabel;
    pnlEditBar: TSkinFMXPanel;
    lblSumMoney: TSkinFMXMultiColorLabel;
    btnOK: TSkinFMXButton;
    chkEditAll: TSkinFMXCheckBox;
    pnlInputNumberMessageBoxContent: TSkinFMXPanel;
    pnlInputNumberContent: TSkinFMXPanel;
    btnInputNumberDec: TSkinFMXButton;
    btnInputNumberAdd: TSkinFMXButton;
    edtInputNumber: TSkinFMXEdit;
    btnDelete: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    procedure lbUserCartGoodsListPullDownRefresh(Sender: TObject);
    procedure chkBuyAllClick(Sender: TObject);
    procedure chkItemCheckedClick(Sender: TObject);
    procedure btnItemAddClick(Sender: TObject);
    procedure btnItemDecClick(Sender: TObject);
    procedure lbUserCartGoodsListPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRect);
    procedure chkEditAllClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnTakeOrderClick(Sender: TObject);
    procedure edtItemDetail4Click(Sender: TObject);
    procedure edtInputNumberChangeTracking(Sender: TObject);
    procedure btnInputNumberDecClick(Sender: TObject);
    procedure btnInputNumberAddClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbUserCartGoodsListClickItem(AItem: TSkinItem);
//  private
//    //获取购物车商品列表
//    procedure DoGetUserCartGoodsListExecute(ATimerTask:TObject);
//    procedure DoGetUserCartGoodsListExecuteEnd(ATimerTask:TObject);

  private
    FNeedUpdateUserCartGoodsFID:Integer;
    FNeedUpdateUserCartGoodsNumber:Integer;
    //修改购物车商品数量
    procedure UpdateGoodsToCart(AUserCartGoodsFID:Integer;AUserCartGoodsNumber:Integer);
    procedure DoUpdateUserCartGoodsExecute(ATimerTask:TObject);
    procedure DoUpdateUserCartGoodsExecuteEnd(ATimerTask:TObject);

  private
    FNeedCheckedUserCartGoodsFID:Integer;
    FNeedCheckedUserCartGoods:Integer;
    //修改购物车商品勾选状态
    procedure CheckedGoodsToCart(AUserCartGoodsFID:Integer;AIsChecked:Integer);
    procedure DoCheckedUserCartGoodsExecute(ATimerTask:TObject);
    procedure DoCheckedUserCartGoodsExecuteEnd(ATimerTask:TObject);
  private
    FNeedCheckedAllUserCartGoods:Integer;
    //修改购物车全部商品勾选状态
    procedure CheckedAllGoodsToCart(AIsCheckedAll:Integer);
    procedure DoCheckedAllUserCartGoodsExecute(ATimerTask:TObject);
    procedure DoCheckedAllUserCartGoodsExecuteEnd(ATimerTask:TObject);

  private
    FSelectedUserCartGoodsFIDList:TStringList;
    //批量删除购物车商品列表
    procedure DoDelUserCartGoodsExecute(ATimerTask:TObject);
    procedure DoDelUserCartGoodsExecuteEnd(ATimerTask:TObject);

  private
    //删除购物车商品的对话框返回
    procedure OnDelUserCartGoodsMessageBoxModalResult(Sender: TObject);
    //认证信息页面返回
    procedure OnModalResultFromSelfFrame(Frame:TObject);
    //重新认证
    procedure OnModalResultFromFillInfoFrame(Frame:TObject);
  private
    procedure SyncInputNumberPanel;
    //修改购物车商品数量的对话框返回
    procedure OnInputNumberMessageBoxModalResult(Sender: TObject);
    { Private declarations }

  public
    //初始购物车商品列表
    procedure InitUserCartGoodsListToUI;
    //同步购物车商品列表(删除或更新购买数量)
    procedure SyncUserCartGoodsListToUI;
    //更新合计
    procedure SyncSummary;
    //更新编辑状态
    procedure SyncEditMode;

  public
    procedure Load(AIsNeedReturn:Boolean);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;



implementation

uses
  MainForm,
  MainFrame,
  GoodsInfoFrame,
//  FillUserInfoFrame,
  TakeOrderFrame;


{$R *.fmx}


procedure TFrameUserCart.btnInputNumberAddClick(Sender: TObject);
begin
  //数量减一
  Self.edtInputNumber.Text:=
    IntToStr(StrToInt(Self.edtInputNumber.Text)+1);
  SyncInputNumberPanel;
end;

procedure TFrameUserCart.btnInputNumberDecClick(Sender: TObject);
begin
  //数量加一
  Self.edtInputNumber.Text:=
    IntToStr(StrToInt(Self.edtInputNumber.Text)-1);
  SyncInputNumberPanel;
end;

procedure TFrameUserCart.btnDeleteClick(Sender: TObject);
var
  I: Integer;
  AUserCartGoods:TUserCartGoods;
begin

  //弹出对话框确认
  FSelectedUserCartGoodsFIDList.Clear;
  for I := 0 to Self.lbUserCartGoodsList.Prop.Items.Count-1 do
  begin
    if Self.lbUserCartGoodsList.Prop.Items[I].Checked then
    begin
      AUserCartGoods:=TUserCartGoods(Self.lbUserCartGoodsList.Prop.Items[I].Data);
      FSelectedUserCartGoodsFIDList.Add(IntToStr(AUserCartGoods.user_cart_goods_fid));
    end;
  end;

  if FSelectedUserCartGoodsFIDList.Count=0 then
  begin
    ShowMessageBoxFrame(Self,'您还没有选择商品!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  ShowMessageBoxFrame(Self,
                      '您确认要删除这'+IntToStr(FSelectedUserCartGoodsFIDList.Count)+'种商品吗?',
                      '',
                      TMsgDlgType.mtInformation,
                      ['确定','取消'],
                      OnDelUserCartGoodsMessageBoxModalResult);


end;

procedure TFrameUserCart.btnEditClick(Sender: TObject);
begin
  //编辑模式

  Self.btnEdit.Visible:=False;
  Self.btnOK.Visible:=True;
  Self.pnlBottomBar.Visible:=False;
  Self.pnlEditBar.Visible:=True;

  Self.lbUserCartGoodsList.Prop.Items.UnCheckAll;
  Self.chkEditAll.Prop.Checked:=False;
end;

procedure TFrameUserCart.btnItemAddClick(Sender: TObject);
var
  AUserCartGoods:TUserCartGoods;
begin
  //加一
  if Self.lbUserCartGoodsList.Prop.InteractiveItem<>nil then
  begin
    //更新到服务器
    AUserCartGoods:=TUserCartGoods(Self.lbUserCartGoodsList.Prop.InteractiveItem.Data);
    Self.UpdateGoodsToCart(AUserCartGoods.user_cart_goods_fid,
                            AUserCartGoods.number+1);
  end;
end;

procedure TFrameUserCart.btnItemDecClick(Sender: TObject);
var
  AUserCartGoods:TUserCartGoods;
begin
  //减一
  if Self.lbUserCartGoodsList.Prop.InteractiveItem<>nil then
  begin
    AUserCartGoods:=TUserCartGoods(Self.lbUserCartGoodsList.Prop.InteractiveItem.Data);
    if AUserCartGoods.number>1 then
    begin
      //更新到服务器
      Self.UpdateGoodsToCart(AUserCartGoods.user_cart_goods_fid,
                              AUserCartGoods.number-1);
    end;
  end;
end;

procedure TFrameUserCart.edtInputNumberChangeTracking(Sender: TObject);
begin
  //更新输入框的数量
  SyncInputNumberPanel;
end;

procedure TFrameUserCart.edtItemDetail4Click(Sender: TObject);
var
  AUserCartGoods:TUserCartGoods;
begin
  if Self.lbUserCartGoodsList.Prop.InteractiveItem<>nil then
  begin
    AUserCartGoods:=TUserCartGoods(Self.lbUserCartGoodsList.Prop.InteractiveItem.Data);

    FNeedUpdateUserCartGoodsFID:=AUserCartGoods.user_cart_goods_fid;
    FNeedUpdateUserCartGoodsNumber:=AUserCartGoods.number;

    Self.edtInputNumber.Text:=IntToStr(AUserCartGoods.number);
    SyncInputNumberPanel;

    //显示修改数量的对话框
    ShowMessageBoxFrame(frmMain,'单位: '+AUserCartGoods.goods_unit,'',TMsgDlgType.mtCustom,['确定','取消'],
                        OnInputNumberMessageBoxModalResult,
                        Self.pnlInputNumberMessageBoxContent,
                        '修改购买数量');
  end;
end;

procedure TFrameUserCart.btnOKClick(Sender: TObject);
begin

  //完成编辑

  //浏览状态
  Self.btnEdit.Visible:=True;
  Self.btnOK.Visible:=False;
  Self.pnlBottomBar.Visible:=True;
  Self.pnlEditBar.Visible:=False;

  //全部取消勾选
  Self.lbUserCartGoodsList.Prop.Items.UnCheckAll;
  //全部取消勾选 更新到服务器
  Self.CheckedAllGoodsToCart(0);

  Self.SyncSummary;

end;

procedure TFrameUserCart.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameUserCart.btnTakeOrderClick(Sender: TObject);
var
  I: Integer;
  AUserCartGoods:TUserCartGoods;
  AUserCartGoodsList:TUserCartGoodsList;
begin
  if GlobalManager.User.cert_audit_state=0 then
  begin
    ShowMessageBoxFrame(Self,'您还没有进行实名认证,是否去认证!','',TMsgDlgType.mtInformation,['暂时不去','去认证'],OnModalResultFromSelfFrame);
    Exit;
  end;

  if GlobalManager.User.cert_audit_state=-1 then
  begin
    ShowMessageBoxFrame(Self,'您的实名认证信息正在审核中,请您耐心等待!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if GlobalManager.User.cert_audit_state=2 then
  begin
    ShowMessageBoxFrame(Self,'您的实名认证信息被拒绝,是否继续认证?','',TMsgDlgType.mtInformation,['取消','继续认证'],OnModalResultFromFillInfoFrame);
    Exit;
  end;



  if GlobalManager.User.audit_state=Ord(asDefault) then
  begin
    ShowMessageBoxFrame(Self,'账号审核通过才能下单,请先申请介绍人!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if GlobalManager.User.audit_state=Ord(asRequestAudit) then
  begin
    ShowMessageBoxFrame(Self,'您的账号正在审核中，请耐心等待!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if GlobalManager.User.audit_state=Ord(asAuditReject) then
  begin
    ShowMessageBoxFrame(Self,'您的挂钩申请审核拒绝，请您重新申请介绍人!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  //跳转到下单界面

  //判断是否选择了商品

  //弹出对话框确认
  FSelectedUserCartGoodsFIDList.Clear;
  for I := 0 to Self.lbUserCartGoodsList.Prop.Items.Count-1 do
  begin
    if Self.lbUserCartGoodsList.Prop.Items[I].Checked then
    begin
      AUserCartGoods:=TUserCartGoods(Self.lbUserCartGoodsList.Prop.Items[I].Data);
      FSelectedUserCartGoodsFIDList.Add(IntToStr(AUserCartGoods.user_cart_goods_fid));
    end;
  end;

  if FSelectedUserCartGoodsFIDList.Count=0 then
  begin
    ShowMessageBoxFrame(Self,'您还没有选择商品!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  //跳转到下单界面
  AUserCartGoodsList:=TUserCartGoodsList.Create;
  try


    for I := 0 to Self.lbUserCartGoodsList.Prop.Items.Count-1 do
    begin
      if Self.lbUserCartGoodsList.Prop.Items[I].Checked then
      begin
        AUserCartGoods:=TUserCartGoods.Create;
        AUserCartGoods.Assign(TUserCartGoods(Self.lbUserCartGoodsList.Prop.Items[I].Data));
        AUserCartGoodsList.Add(AUserCartGoods);
      end;
    end;



    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

    //确认下单
    ShowFrame(TFrame(GlobalTakeOrderFrame),TFrameTakeOrder,frmMain,nil,nil,nil,Application);
//    GlobalTakeOrderFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalTakeOrderFrame.Clear;
    GlobalTakeOrderFrame.LoadBuyGoodsList(AUserCartGoodsList);
    GlobalTakeOrderFrame.AddOrder;

  finally
    FreeAndNil(AUserCartGoodsList);
  end;


end;

procedure TFrameUserCart.chkItemCheckedClick(Sender: TObject);
var
  AUserCartGoods:TUserCartGoods;
  AIsChecked:Integer;
begin
  if Self.lbUserCartGoodsList.Prop.InteractiveItem<>nil then
  begin
      //勾选/取消勾选
      AUserCartGoods:=TUserCartGoods(Self.lbUserCartGoodsList.Prop.InteractiveItem.Data);

      Self.lbUserCartGoodsList.Prop.InteractiveItem.Checked:=
        Not Self.lbUserCartGoodsList.Prop.InteractiveItem.Checked;


      //不在编辑状态
      if Self.btnEdit.Visible then
      begin
          SyncSummary;
          //更新到服务器
          AIsChecked:=Ord(Self.lbUserCartGoodsList.Prop.InteractiveItem.Checked);
          AUserCartGoods.is_checked:=AIsChecked;
          Self.CheckedGoodsToCart(AUserCartGoods.user_cart_goods_fid,AIsChecked);
      end;


      //在编辑状态
      if Not Self.btnEdit.Visible then
      begin

        SyncEditMode;
      end;

  end;
end;

procedure TFrameUserCart.chkBuyAllClick(Sender: TObject);
var
  AIsChecked:Integer;
  I: Integer;
begin
  //全选/全不选
  if Self.lbUserCartGoodsList.Prop.Items.Count>0 then
  begin

      //有商品
      if Not Self.lbUserCartGoodsList.Prop.Items.IsCheckedAll then
      begin
        Self.lbUserCartGoodsList.Prop.Items.CheckAll;
        AIsChecked:=1;
      end
      else
      begin
        Self.lbUserCartGoodsList.Prop.Items.UnCheckAll;
        AIsChecked:=0;
      end;

      for I := 0 to GlobalManager.UserCartGoodsList.Count-1 do
      begin
        GlobalManager.UserCartGoodsList[I].is_checked:=AIsChecked;
      end;

      //更新到服务器
      CheckedAllGoodsToCart(AIsChecked);

      Self.SyncSummary;


  end;
end;

procedure TFrameUserCart.chkEditAllClick(Sender: TObject);
begin
  //全选/全不选
  if Self.lbUserCartGoodsList.Prop.Items.Count>0 then
  begin


    //编辑状态
    //全选/全不选
    if Not Self.lbUserCartGoodsList.Prop.Items.IsCheckedAll then
    begin
      Self.lbUserCartGoodsList.Prop.Items.CheckAll;
    end
    else
    begin
      Self.lbUserCartGoodsList.Prop.Items.UnCheckAll;
    end;

    Self.chkEditAll.Prop.Checked:=
      (Self.lbUserCartGoodsList.Prop.Items.Count>0)
      and Self.lbUserCartGoodsList.Prop.Items.IsCheckedAll;

  end
  else
  begin

  end;
end;

constructor TFrameUserCart.Create(AOwner: TComponent);
begin
  inherited;

  Self.pnlInputNumberMessageBoxContent.Visible:=False;

  Self.lbUserCartGoodsList.Prop.Items.Clear(True);
  FSelectedUserCartGoodsFIDList:=TStringList.Create;

  Self.SyncSummary;
end;

destructor TFrameUserCart.Destroy;
begin
  FreeAndNil(FSelectedUserCartGoodsFIDList);
  inherited;
end;

procedure TFrameUserCart.lbUserCartGoodsListClickItem(AItem: TSkinItem);
var
  AUserCartGoods:TUserCartGoods;
begin
  AUserCartGoods:=AItem.Data;

  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //显示商品详情页面
  ShowFrame(TFrame(GlobalGoodsInfoFrame),TFrameGoodsInfo,frmMain,nil,nil,nil,Application);
  GlobalGoodsInfoFrame.Load(AUserCartGoods);
//  GlobalGoodsInfoFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameUserCart.lbUserCartGoodsListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AUserCartGoods:TUserCartGoods;
begin
  AUserCartGoods:=TUserCartGoods(AItem.Data);
  Self.btnItemDec.Enabled:=(AUserCartGoods.number>1);
end;

procedure TFrameUserCart.lbUserCartGoodsListPullDownRefresh(Sender: TObject);
begin
  //获取用户购物车商品列表
  GlobalMainFrame.GetUserCartGoodsList;
end;

procedure TFrameUserCart.Load(AIsNeedReturn:Boolean);
begin

  Self.btnReturn.Visible:=AIsNeedReturn;

  Self.lbUserCartGoodsList.Prop.StartPullDownRefresh;

  //浏览状态
  Self.btnEdit.Visible:=True;
  Self.btnOK.Visible:=False;
  Self.pnlBottomBar.Visible:=True;
  Self.pnlEditBar.Visible:=False;
end;

procedure TFrameUserCart.OnDelUserCartGoodsMessageBoxModalResult(Sender: TObject);
begin
  if TFrameMessageBox(Sender).ModalResult='确定' then
  begin
    //删除购物车商品
    ShowWaitingFrame(Self,'处理中...');
    GetGlobalTimerThread.RunTempTask(
                                  Self.DoDelUserCartGoodsExecute,
                                  Self.DoDelUserCartGoodsExecuteEnd
                                  );
  end;
end;

procedure TFrameUserCart.OnInputNumberMessageBoxModalResult(Sender: TObject);
begin
  //修改购物车数量
  if TFrameMessageBox(Sender).ModalResult='确定' then
  begin
    //更新到服务器
    //修改过数量
    if FNeedUpdateUserCartGoodsNumber<>StrToInt(Self.edtInputNumber.Text) then
    begin
      FNeedUpdateUserCartGoodsNumber:=StrToInt(Self.edtInputNumber.Text);
      UpdateGoodsToCart(FNeedUpdateUserCartGoodsFID,FNeedUpdateUserCartGoodsNumber);
    end;
  end;
end;

procedure TFrameUserCart.OnModalResultFromFillInfoFrame(Frame: TObject);
begin
//  if TFrameMessageBox(Frame).ModalResult='取消' then
//  begin
//    //留在本页面
//  end;
//  if TFrameMessageBox(Frame).ModalResult='继续认证' then
//  begin
//
//    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//    //显示实名认证界面
//    ShowFrame(TFrame(GlobalFillUserInfoFrame),TFrameFillUserInfo,frmMain,nil,nil,nil,Application);
//    GlobalFillUserInfoFrame.Clear;
//    GlobalFillUserInfoFrame.FPageIndex:=2;
//
//  end;
end;

procedure TFrameUserCart.OnModalResultFromSelfFrame(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='暂时不用' then
  begin
    //留在本页面
  end;
//  if TFrameMessageBox(Frame).ModalResult='去认证' then
//  begin
//
//    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//    //显示实名认证界面
//    ShowFrame(TFrame(GlobalFillUserInfoFrame),TFrameFillUserInfo,frmMain,nil,nil,nil,Application);
//    GlobalFillUserInfoFrame.Clear;
//    GlobalFillUserInfoFrame.FPageIndex:=2;
//
//  end;
end;

procedure TFrameUserCart.SyncEditMode;
begin
  //全选
  Self.chkEditAll.Prop.Checked:=
    (Self.lbUserCartGoodsList.Prop.Items.Count>0)
    and Self.lbUserCartGoodsList.Prop.Items.IsCheckedAll;

end;

procedure TFrameUserCart.SyncInputNumberPanel;
var
  AInputNumber:Integer;
begin

  if TryStrToInt(Self.edtInputNumber.Text,AInputNumber) then
  begin
    Self.btnInputNumberDec.Enabled:=(AInputNumber>1);
  end;
end;

procedure TFrameUserCart.SyncSummary;
var
  I: Integer;
  ASumMoney:Double;
  AUserCartGoods:TUserCartGoods;
begin
  //全选
  Self.chkBuyAll.Prop.Checked:=
    (Self.lbUserCartGoodsList.Prop.Items.Count>0)
    and Self.lbUserCartGoodsList.Prop.Items.IsCheckedAll;

  //合计
  ASumMoney:=0;
  for I := 0 to Self.lbUserCartGoodsList.Prop.Items.Count-1 do
  begin
    if Self.lbUserCartGoodsList.Prop.Items[I].Checked then
    begin
      //勾选了
      AUserCartGoods:=TUserCartGoods(Self.lbUserCartGoodsList.Prop.Items[I].Data);
      ASumMoney:=ASumMoney+AUserCartGoods.number*AUserCartGoods.price;
    end;
  end;
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[ASumMoney]);


end;

procedure TFrameUserCart.SyncUserCartGoodsListToUI;
var
  I: Integer;
  AUserCartGoods:TUserCartGoods;
  AListBoxItem:TSkinListBoxItem;
begin
  Self.lbUserCartGoodsList.Prop.Items.BeginUpdate;
  try

    //删除已经不存在的
    for I := Self.lbUserCartGoodsList.Prop.Items.Count-1 downto 0 do
    begin

      AListBoxItem:=Self.lbUserCartGoodsList.Prop.Items[I];
      AUserCartGoods:=TUserCartGoods(AListBoxItem.Data);

      //此购物车商品不存在了
      if GlobalManager.UserCartGoodsList.IndexOf(AUserCartGoods)=-1 then
      begin
        Self.lbUserCartGoodsList.Prop.Items.Delete(I);
      end;

    end;



    //更新已经存在的
    for I := 0 to Self.lbUserCartGoodsList.Prop.Items.Count-1 do
    begin

      AListBoxItem:=Self.lbUserCartGoodsList.Prop.Items[I];
      AUserCartGoods:=TUserCartGoods(AListBoxItem.Data);

      MainFrame.LoadGoodsToListBoxItem(AUserCartGoods,AListBoxItem);
      //加载数量
      AListBoxItem.Detail4:=FloatToStr(AUserCartGoods.number);

      if Not Self.btnEdit.Visible then

      //不在编辑状态
      if Self.btnEdit.Visible then
      begin
        //加载勾选状态
        AListBoxItem.Checked:=(AUserCartGoods.is_checked=1);
      end;

    end;



    //添加新增的
    for I := 0 to GlobalManager.UserCartGoodsList.Count-1 do
    begin

      AUserCartGoods:=GlobalManager.UserCartGoodsList[I];
      if Self.lbUserCartGoodsList.Prop.Items.FindItemByData(AUserCartGoods)=nil then
      begin

        AListBoxItem:=Self.lbUserCartGoodsList.Prop.Items.Add;

        MainFrame.LoadGoodsToListBoxItem(AUserCartGoods,AListBoxItem);
        //加载数量
        AListBoxItem.Detail4:=FloatToStr(AUserCartGoods.number);

        //不在编辑状态
        if Self.btnEdit.Visible then
        begin
          //加载勾选状态
          AListBoxItem.Checked:=(AUserCartGoods.is_checked=1);
        end;

      end;

    end;

  finally
    Self.lbUserCartGoodsList.Prop.Items.EndUpdate();
  end;

  SyncSummary;

end;

procedure TFrameUserCart.DoDelUserCartGoodsExecute(ATimerTask: TObject);
var
  I: Integer;
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
        //批量删除购物车商品列表
        TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('del_goods_to_cart',
                                                        AHttpControl,
                                                        InterfaceUrl,
                                                        ['appid',
                                                        'user_fid',
                                                        'key',
                                                        'user_cart_goods_fids'],
                                                        [AppID,
                                                        GlobalManager.User.fid,
                                                        GlobalManager.User.key,
                                                        FSelectedUserCartGoodsFIDList.CommaText
                                                        ]
                                                        );


      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;

    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;

end;

procedure TFrameUserCart.DoDelUserCartGoodsExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AUserCartGoods:TUserCartGoods;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //购物车商品删除成功
        for I := 0 to Self.FSelectedUserCartGoodsFIDList.Count-1 do
        begin
          AUserCartGoods:=GlobalManager.UserCartGoodsList.FindItemByUserCartGoodsFID(
                        StrToInt(FSelectedUserCartGoodsFIDList[I])
                        );
          GlobalManager.UserCartGoodsList.Remove(AUserCartGoods);
        end;

        //同步购物车页面
        SyncUserCartGoodsListToUI;

        SyncEditMode;
      end
      else
      begin
        //购物车商品删除失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;

//procedure TFrameUserCart.DoGetUserCartGoodsListExecute(ATimerTask: TObject);
//var
//  AHttpControl:THttpControl;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  AHttpControl:=TSystemHttpControl.Create;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_goods_list_to_cart',
//                                                      AHttpControl,
//                                                      InterfaceUrl,
//                                                      ['appid',
//                                                      'user_fid',
//                                                      'key'],
//                                                      [AppID,
//                                                      GlobalManager.User.fid,
//                                                      GlobalManager.User.key
//                                                      ]
//                                                      );
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
//    except
//      on E:Exception do
//      begin
//        //异常
//        TTimerTask(ATimerTask).TaskDesc:=E.Message;
//      end;
//    end;
//  finally
//    FreeAndNil(AHttpControl);
//  end;
//
//end;
//
//procedure TFrameUserCart.DoGetUserCartGoodsListExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//
//          //购物车商品列表获取成功
//          GlobalManager.UserCartGoodsList.Clear(True);
//          GlobalManager.UserCartGoodsList.ParseFromJsonArray(TUserCartGoods,ASuperObject.O['Data'].A['UserCartGoodsList']);
//
//          //重新初始购物车列表
//          InitUserCartGoodsList;
//
//      end
//      else
//      begin
//        //购物车商品列表获取失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    Self.lbUserCartGoodsList.Prop.StopPullDownRefresh();
//  end;
//
//end;

procedure TFrameUserCart.InitUserCartGoodsListToUI;
var
  I: Integer;
  AUserCartGoods:TUserCartGoods;
  AListBoxItem:TSkinListBoxItem;
begin
  Self.lbUserCartGoodsList.Prop.Items.BeginUpdate;
  try

    Self.lbUserCartGoodsList.Prop.Items.Clear(True);

    for I := 0 to GlobalManager.UserCartGoodsList.Count-1 do
    begin

      AUserCartGoods:=GlobalManager.UserCartGoodsList[I];
      AListBoxItem:=Self.lbUserCartGoodsList.Prop.Items.Add;
      AListBoxItem.Data:=GlobalManager.UserCartGoodsList[I];
      MainFrame.LoadGoodsToListBoxItem(AUserCartGoods,AListBoxItem);

      //加载数量
      AListBoxItem.Detail4:=FloatToStr(AUserCartGoods.number);
      //FloatToStr(AUserCartGoods.number);


      //不在编辑状态
      if Self.btnEdit.Visible then
      begin
        //加载勾选状态
        AListBoxItem.Checked:=(AUserCartGoods.is_checked=1);
      end;

    end;

  finally
    Self.lbUserCartGoodsList.Prop.Items.EndUpdate();
  end;

  SyncSummary;
end;

procedure TFrameUserCart.DoUpdateUserCartGoodsExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('update_goods_to_cart',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'user_cart_goods_fid',
                                                      'number'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNeedUpdateUserCartGoodsFID,
                                                      FNeedUpdateUserCartGoodsNumber
                                                      ]
                                                      );
      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;

    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;

end;

procedure TFrameUserCart.DoUpdateUserCartGoodsExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserCartGoods:TUserCartGoods;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //购物车商品修改成功
        AUserCartGoods:=GlobalManager.UserCartGoodsList.FindItemByUserCartGoodsFID(FNeedUpdateUserCartGoodsFID);
        if AUserCartGoods<>nil then
        begin
          AUserCartGoods.ParseFromJson(ASuperObject.O['Data'].A['UserCartGoods'].O[0]);
        end;

        //同步购物车页面
        SyncUserCartGoodsListToUI;

      end
      else
      begin
        //购物车商品修改失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;

procedure TFrameUserCart.DoCheckedUserCartGoodsExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('checked_goods_to_cart',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'user_cart_goods_fid',
                                                      'is_checked'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNeedCheckedUserCartGoodsFID,
                                                      FNeedCheckedUserCartGoods
                                                      ]
                                                      );
      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;

    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;

end;

procedure TFrameUserCart.DoCheckedUserCartGoodsExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserCartGoods:TUserCartGoods;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


      end
      else
      begin
        //购物车商品勾选状态修改失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;

procedure TFrameUserCart.DoCheckedAllUserCartGoodsExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('checked_all_goods_to_cart',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'is_checked'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNeedCheckedAllUserCartGoods
                                                      ]
                                                      );
      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;

    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;

end;

procedure TFrameUserCart.DoCheckedAllUserCartGoodsExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserCartGoods:TUserCartGoods;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


      end
      else
      begin
        //购物车全部商品勾选状态修改失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;

procedure TFrameUserCart.UpdateGoodsToCart(AUserCartGoodsFID, AUserCartGoodsNumber: Integer);
begin
  ShowWaitingFrame(Self,'处理中...');

  FNeedUpdateUserCartGoodsFID:=AUserCartGoodsFID;
  FNeedUpdateUserCartGoodsNumber:=AUserCartGoodsNumber;
  GetGlobalTimerThread.RunTempTask(
                          Self.DoUpdateUserCartGoodsExecute,
                          Self.DoUpdateUserCartGoodsExecuteEnd
                          );
end;

procedure TFrameUserCart.CheckedGoodsToCart(AUserCartGoodsFID, AIsChecked: Integer);
begin
  ShowWaitingFrame(Self,'处理中...');

  FNeedCheckedUserCartGoodsFID:=AUserCartGoodsFID;
  FNeedCheckedUserCartGoods:=AIsChecked;
  GetGlobalTimerThread.RunTempTask(
                          Self.DoCheckedUserCartGoodsExecute,
                          Self.DoCheckedUserCartGoodsExecuteEnd
                          );
end;

procedure TFrameUserCart.CheckedAllGoodsToCart(AIsCheckedAll: Integer);
begin
  ShowWaitingFrame(Self,'处理中...');

  FNeedCheckedAllUserCartGoods:=AIsCheckedAll;
  GetGlobalTimerThread.RunTempTask(
                          Self.DoCheckedAllUserCartGoodsExecute,
                          Self.DoCheckedAllUserCartGoodsExecuteEnd
                          );
end;

end.

