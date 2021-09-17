//convert pas to utf8 by ¥
unit BuyGoodsListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  Math,

  WaitingFrame,
  MessageBoxFrame,

  uManager,
  uSkinItems,
  uBaseList,
  uTimerTask,
  XSuperObject,
  uInterfaceClass,
  uBaseHttpControl,
  uUIFunction,
  uDrawCanvas,
  EasyServiceCommonMaterialDataMoudle,

  uSkinListBoxType,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyMultiColorLabel, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyNotifyNumberIcon,
  uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinNotifyNumberIconType, uSkinButtonType,
  uSkinPanelType;

type
  TFrameBuyGoodsList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbBuyGoodsList: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail_2: TSkinFMXMultiColorLabel;
    btnAddGoodsToCart: TSkinFMXButton;
    lblItemDetail3Hint: TSkinFMXLabel;
    lblItemDetail3: TSkinFMXLabel;
    btnReturn: TSkinFMXButton;
    btnSearchGoodsHistory: TSkinFMXButton;
    lblExistedInGoodsCart: TSkinFMXLabel;
    btnUserCart: TSkinFMXNotifyNumberIcon;
    btnScanBarCode: TSkinFMXButton;
    procedure lbBuyGoodsListPullDownRefresh(Sender: TObject);
    procedure lbBuyGoodsListPullUpLoadMore(Sender: TObject);
    procedure btnAddGoodsToCartClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnUserCartClick(Sender: TObject);
    procedure btnSearchGoodsHistoryClick(Sender: TObject);
    procedure lbBuyGoodsListPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRect);
    procedure lbBuyGoodsListClickItem(AItem: TSkinItem);
    procedure btnScanBarCodeClick(Sender: TObject);
  private
    FPageIndex:Integer;
    FFilterKeyword:String;
    FGoodsList:TGoodsList;

    //获取商品列表
    procedure DoGetGoodsListExecute(ATimerTask:TObject);
    procedure DoGetGoodsListExecuteEnd(ATimerTask:TObject);

    procedure OnReturnFromSearchHistory(Frame:TFrame);


    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load(AFilterKeyword:String;
                    AIsNeedReturn:Boolean);
    { Public declarations }
  end;

var
  GlobalBuyGoodsListFrame:TFrameBuyGoodsList;


implementation

uses
  MainForm,
  MainFrame,
  UserCartFrame,
  GoodsInfoFrame,
  SearchHistoryFrame;

{$R *.fmx}


procedure TFrameBuyGoodsList.btnAddGoodsToCartClick(Sender: TObject);
var
  AAddGoodsFID:Integer;
begin
  //添加商品到购物车

  if Self.lbBuyGoodsList.Prop.InteractiveItem<>nil then
  begin
    AAddGoodsFID:=TGoods(Self.lbBuyGoodsList.Prop.InteractiveItem.Data).fid;
    //购物车中没有此商品
    if GlobalManager.UserCartGoodsList.FindItemByFID(AAddGoodsFID)=nil then
    begin
      ShowWaitingFrame(Self,'处理中...');

      GlobalMainFrame.AddGoodsToCart(AAddGoodsFID,1);
    end;
  end;

end;

procedure TFrameBuyGoodsList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

constructor TFrameBuyGoodsList.Create(AOwner: TComponent);
begin
  inherited;
  FGoodsList:=TGoodsList.Create;
  Self.lbBuyGoodsList.Prop.Items.Clear(True);
end;

destructor TFrameBuyGoodsList.Destroy;
begin
  FreeAndNil(FGoodsList);
  inherited;
end;

procedure TFrameBuyGoodsList.DoGetGoodsListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try

        TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_buy_goods_list',
                                                        AHttpControl,
                                                        InterfaceUrl,
                                                        ['appid',
                                                        'user_fid',
                                                        'key',
                                                        'pageindex',
                                                        'pagesize',
                                                        'filter_keyword'],
                                                        [AppID,
                                                        GlobalManager.User.fid,
                                                        GlobalManager.User.key,
                                                        FPageIndex,
                                                        20,
                                                        FFilterKeyword
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

procedure TFrameBuyGoodsList.DoGetGoodsListExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AGoodsList:TGoodsList;
  AListBoxItem:TSkinListBoxItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          AGoodsList:=TGoodsList.Create(ooReference);

          AGoodsList.ParseFromJsonArray(TGoods,ASuperObject.O['Data'].A['BuyGoodsList']);

          Self.lbBuyGoodsList.Prop.Items.BeginUpdate;
          try
            if FPageIndex=1 then
            begin
              Self.lbBuyGoodsList.Prop.Items.ClearItemsByType(sitDefault);
              FGoodsList.Clear(True);
            end;
            for I := 0 to AGoodsList.Count-1 do
            begin

              FGoodsList.Add(AGoodsList[I]);


              AListBoxItem:=Self.lbBuyGoodsList.Prop.Items.Add;
              MainFrame.LoadGoodsToListBoxItem(AGoodsList[I],AListBoxItem);
              AListBoxItem.Data:=AGoodsList[I];

            end;

          finally
            Self.lbBuyGoodsList.Prop.Items.EndUpdate();
            FreeAndNil(AGoodsList);
          end;

      end
      else
      begin
        //获取失败
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


    if FPageIndex>1 then
    begin
        if ASuperObject.O['Data'].A['GoodsList'].Length>0 then
        begin
          Self.lbBuyGoodsList.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.lbBuyGoodsList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
        Self.lbBuyGoodsList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;
end;

procedure TFrameBuyGoodsList.lbBuyGoodsListClickItem(AItem: TSkinItem);
var
  AGoods:TGoods;
begin
  AGoods:=AItem.Data;
  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //显示商品详情页面
  ShowFrame(TFrame(GlobalGoodsInfoFrame),TFrameGoodsInfo,frmMain,nil,nil,nil,Application);
//  GlobalGoodsInfoFrame.FrameHistroy:=CurrentFrameHistroy;

  GlobalGoodsInfoFrame.Load(AGoods);
end;

procedure TFrameBuyGoodsList.lbBuyGoodsListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AGoods:TGoods;
  AIsExistedInGoodsCart:Boolean;
begin
  if AItem.ItemType=sitDefault then
  begin
    AGoods:=TGoods(AItem.Data);
    AIsExistedInGoodsCart:=(GlobalManager.UserCartGoodsList.FindItemByFID(AGoods.fid)<>nil);
    lblExistedInGoodsCart.Visible:=AIsExistedInGoodsCart;
    Self.btnAddGoodsToCart.Visible:=Not AIsExistedInGoodsCart;
  end;

end;

procedure TFrameBuyGoodsList.lbBuyGoodsListPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                    DoGetGoodsListExecute,
                                    DoGetGoodsListExecuteEnd);

end;

procedure TFrameBuyGoodsList.lbBuyGoodsListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                    DoGetGoodsListExecute,
                                    DoGetGoodsListExecuteEnd);

end;

procedure TFrameBuyGoodsList.Load(AFilterKeyword:String;AIsNeedReturn:Boolean);
begin
  FFilterKeyword:=AFilterKeyword;

  //购物车的商品数量
  Self.btnUserCart.Prop.Number:=GlobalManager.UserCartGoodsList.Count;


  if (AFilterKeyword<>'') then
  begin

    //有过滤的情况
    Self.btnSearchGoodsHistory.Caption:=AFilterKeyword;
    Self.btnReturn.Visible:=AIsNeedReturn;
    Self.lbBuyGoodsList.Prop.Items.Clear(True);

  end
  else
  begin

    //无过滤的情况
    Self.btnSearchGoodsHistory.Caption:='';
    Self.btnReturn.Visible:=AIsNeedReturn;

  end;


  //有了返回按钮,就不能再有扫描二维码的接口
  if AIsNeedReturn=True then
  begin
    Self.btnScanBarCode.Visible:=False;
  end
  else
  begin
    Self.btnScanBarCode.Visible:=True;
  end;


  Self.lbBuyGoodsList.Prop.StartPullDownRefresh;
end;

procedure TFrameBuyGoodsList.OnReturnFromSearchHistory(Frame: TFrame);
begin
  //从搜索历史返回
  FFilterKeyword:=GlobalSearchHistoryFrame.edtSearch.Text;
  Self.btnSearchGoodsHistory.Caption:=FFilterKeyword;
  Self.lbBuyGoodsList.Prop.StartPullDownRefresh;
end;

procedure TFrameBuyGoodsList.btnScanBarCodeClick(Sender: TObject);
begin
  //扫描二维码
  frmMain.ScanBarCode;
end;

procedure TFrameBuyGoodsList.btnSearchGoodsHistoryClick(Sender: TObject);
begin

  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //显示搜索历史搜索
  ShowFrame(TFrame(GlobalSearchHistoryFrame),TFrameSearchHistory,frmMain,nil,nil,OnReturnFromSearchHistory,Application);
//  GlobalSearchHistoryFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalSearchHistoryFrame.Load(Self.btnSearchGoodsHistory.Prop.HelpText,
                                'BuyGoods',
                                GlobalManager.BuyGoodsSearchHistoryList);

end;

procedure TFrameBuyGoodsList.btnUserCartClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
  //购物车
  ShowFrame(TFrame(GlobalMainFrame.FUserCartFrame),TFrameUserCart,frmMain,nil,nil,nil,Application);
//  GlobalMainFrame.FUserCartFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalMainFrame.FUserCartFrame.Load(True);

end;


end.
