//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uComponentType,
  uFuncCommon,
  uUIFunction,

  Math,
  uManager,
  uTimerTask,
  ClientModuleUnit1,
  WaitingFrame,
  MessageBoxFrame,
  SettingFrame,

  HZSpell,

  FMX.Platform,

  XSuperObject,
  XSuperJson,

  uBaseList,
  uSkinItems,
  uSkinListBoxType,
  uSkinListViewType,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uSkinFireMonkeyButton, uSkinFireMonkeyLabel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyListView,
  uSkinFireMonkeyImage, uSkinFireMonkeyPanel, uSkinFireMonkeyMultiColorLabel,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyNotifyNumberIcon,
  uSkinFireMonkeyCheckBox, uSkinMaterial, uSkinButtonType,
  uSkinFireMonkeyCustomList, uSkinNotifyNumberIconType, uSkinCheckBoxType,
  uSkinMultiColorLabelType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinPanelType, uDrawCanvas;

type
  TFrameMain = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnSetting: TSkinFMXButton;
    pnlClient: TSkinFMXPanel;
    pnlLeft: TSkinFMXPanel;
    lbCategory: TSkinFMXListBox;
    ItemCategory: TSkinFMXItemDesignerPanel;
    lblItemCategoryCaption: TSkinFMXLabel;
    pnlMiddle: TSkinFMXPanel;
    lvGoodsList: TSkinFMXListView;
    ItemGoods: TSkinFMXItemDesignerPanel;
    imgItemGoodsPic: TSkinFMXImage;
    ItemGoodsCaption: TSkinFMXLabel;
    lblItemGoodsPrice: TSkinFMXMultiColorLabel;
    pnlRight: TSkinFMXPanel;
    lbCartList: TSkinFMXListBox;
    ItemCart: TSkinFMXItemDesignerPanel;
    btnItemCartDec: TSkinFMXButton;
    btnItemCartInc: TSkinFMXButton;
    edtItemCartNumber: TSkinFMXEdit;
    pnlPay: TSkinFMXPanel;
    btnPay: TSkinFMXButton;
    pnlItemGoodsOperate: TSkinFMXPanel;
    btnItemGoodsInc: TSkinFMXButton;
    edtItemGoodsNumber: TSkinFMXEdit;
    btnItemGoodsDec: TSkinFMXButton;
    chkItemCartChecked: TSkinFMXCheckBox;
    imgShoppingCart: TSkinFMXImage;
    nniCartNumber: TSkinFMXNotifyNumberIcon;
    btnSelectAll: TSkinFMXButton;
    pnlItemCartInfo: TSkinFMXPanel;
    lblItemCartPrice: TSkinFMXMultiColorLabel;
    lblItemCartCaption: TSkinFMXLabel;
    lblSumMoney: TSkinFMXMultiColorLabel;
    idpItemPanDrag: TSkinFMXItemDesignerPanel;
    btnDel: TSkinFMXButton;
    pnlSearchBar: TSkinFMXPanel;
    edtFilter: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
    procedure btnItemGoodsDecClick(Sender: TObject);
    procedure btnItemGoodsIncClick(Sender: TObject);
    procedure btnItemCartDecClick(Sender: TObject);
    procedure btnItemCartIncClick(Sender: TObject);
    procedure edtFilterKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnSelectAllClick(Sender: TObject);
    procedure pnlToolBarClick(Sender: TObject);
    procedure btnSettingClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure lbCartListClickItemEx(Sender: TObject; Item: TSkinItem; X,
      Y: Double);
    procedure edtFilterChange(Sender: TObject);
    procedure edtFilterChangeTracking(Sender: TObject);
    procedure lbCategoryClickItem(Sender: TSkinItem);
    procedure btnPayClick(Sender: TObject);
  private
    FFilter:String;

    FGoodsList:TGoodsList;

    FGoodsCategoryList:TGoodsCategoryList;

    procedure DoFilter;

    procedure DoGetGoodsListExecute(ATimerTask:TObject);
    procedure DoGetGoodsListExecuteEnd(ATimerTask:TObject);

    procedure DoGetGoodsClassfiyExecute(ATimerTask:TObject);
    procedure DoGetGoodsClassfiyExecuteEnd(ATimerTask:TObject);
  private
    FRoomNO:String;
    FWaitorNO:String;
    FGoodsListJsonStr:String;
    FMoney:Double;

    procedure DoBuyGoodsExecute(ATimerTask:TObject);
    procedure DoBuyGoodsExecuteEnd(ATimerTask:TObject);

    procedure DoBuyGoodsMessageBoxFrameModalResult(Sender:TObject);
    procedure DoBuyGoodsMessageBoxFrameSuccModalResult(Sender:TObject);
    { Private declarations }
  private
    SumMoney:Double;

    //把商品列表中的数量同步到购物车列表
    procedure CopyGoodsListNumberToCartListNumber;
    //把购物车列表中的数量同步到商品列表
    procedure CopyCartListNumberToGoodsListNumber;


    //更新购物车数量
    procedure SyncCartNumber;
    //计算总金额
    procedure SyncMoney;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure SyncCaption;
    //刷新商品分类和商品列表
    procedure Load;
    { Public declarations }
  end;





var
  GlobalMainFrame:TFrameMain;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameMain.DoGetGoodsListExecute(ATimerTask:TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.GetGoodsList;

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameMain.DoGetGoodsListExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  AListViewItem:TSkinListViewItem;
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          //获取商品列表成功
          FGoodsList.Clear(True);
          FGoodsList.ParseFromJsonArray(TGoods,ASuperObject.O['Data'].A['GoodsList']);


          //清空购物车
          Self.lbCartList.Prop.Items.Clear(True);
          Self.SyncCartNumber;
          Self.SyncMoney;
          Self.SyncCaption;


          DoFilter;

//          Self.lvGoodsList.Prop.Items.BeginUpdate;
//          try
//
//            Self.lvGoodsList.Prop.Items.Clear(True);
//
//            for I := 0 to FGoodsList.Count-1 do
//            begin
//
//              AListViewItem:=Self.lvGoodsList.Prop.Items.Add;
//              AListViewItem.Data:=FGoodsList[I];
//              AListViewItem.Caption:=FGoodsList[I].Name;
//              AListViewItem.Detail:=FloatToStr(FGoodsList[I].Price);
//              //清空选择的数量
//              AListViewItem.Detail1:='0';
//              AListViewItem.Detail2:=FGoodsList[I].Unit_;
//
//
//              //自动下载图标
//              AListViewItem.Icon.Url:=FGoodsList[I].GetThumbPicUrl;
//
//
//            end;
//          finally
//            Self.lvGoodsList.Prop.Items.EndUpdate();
//          end;

      end
      else
      begin
        //获取商品列表失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定']);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定']);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TFrameMain.edtFilterChange(Sender: TObject);
begin
  if FFilter=Trim(Self.edtFilter.Text) then Exit;
  DoFilter;
end;

procedure TFrameMain.edtFilterChangeTracking(Sender: TObject);
begin
  if FFilter=Trim(Self.edtFilter.Text) then Exit;
  DoFilter;
end;

procedure TFrameMain.edtFilterKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key=vkReturn then
  begin
    //搜索
    if FFilter=Trim(Self.edtFilter.Text) then Exit;
    DoFilter;
  end;
end;

procedure TFrameMain.lbCartListClickItemEx(Sender: TObject; Item: TSkinItem; X,
  Y: Double);
begin

  if PtInRect(RectF(Self.btnItemCartDec.Left,
                    Self.btnItemCartDec.Top,
                    Self.btnItemCartDec.Left+Self.btnItemCartDec.Width,
                    Self.btnItemCartDec.Top+Self.btnItemCartDec.Height),
                    PointF(X,Y)) then
  begin

      //减小
      //减一
      if StrToInt(Item.Detail1)>0 then
      begin
        Item.Detail1:=
          IntToStr(StrToInt(Item.Detail1)-1);

        //同步商品列表
        CopyCartListNumberToGoodsListNumber;

        //刷新总金额
        SyncMoney;
      end;

  end
  else
  if PtInRect(RectF(Self.btnItemCartInc.Left,
                    Self.btnItemCartInc.Top,
                    Self.btnItemCartInc.Left+Self.btnItemCartInc.Width,
                    Self.btnItemCartInc.Top+Self.btnItemCartInc.Height),
                    PointF(X,Y)) then
  begin

      //增大
      //加一
      Item.Detail1:=
        IntToStr(StrToInt(Item.Detail1)+1);

      //同步商品列表
      CopyCartListNumberToGoodsListNumber;

      //刷新总金额
      SyncMoney;


  end
  else
  begin

      //勾选
      Item.Checked:=Not Item.Checked;

      SyncCartNumber;
      SyncMoney;


  end;

end;

procedure TFrameMain.lbCategoryClickItem(Sender: TSkinItem);
//var
//  I: Integer;
//  AFirstCategoryItem:TSkinItem;
begin

  //过滤
  DoFilter;


//  //定位
//  AFirstCategoryItem:=nil;
//  for I := 0 to Self.lvGoodsList.Prop.Items.Count-1 do
//  begin
//    if TGoods(Self.lvGoodsList.Prop.Items[I].Data).GoodsCategoryID=
//      TGoodsCategory(Sender.Data).FID then
//    begin
//      AFirstCategoryItem:=Self.lvGoodsList.Prop.Items[I];
//      Break;
//    end;
//  end;
//  if AFirstCategoryItem<>nil then
//  begin
//    Self.lvGoodsList.Prop.ScrollToItem(AFirstCategoryItem);
//  end;

end;

procedure TFrameMain.btnDelClick(Sender: TObject);
begin
  Self.lbCartList.Properties.PanDragItem.Detail1:='0';
  Self.CopyCartListNumberToGoodsListNumber;

  Self.lbCartList.Properties.Items.Remove(Self.lbCartList.Properties.PanDragItem,True);

  Self.CopyCartListNumberToGoodsListNumber;
  Self.SyncCartNumber;
  Self.SyncMoney;
end;

procedure TFrameMain.btnItemCartDecClick(Sender: TObject);
begin
  //减一
  if StrToInt(Self.lbCartList.Prop.InteractiveItem.Detail1)>0 then
  begin
    Self.lbCartList.Prop.InteractiveItem.Detail1:=
      IntToStr(StrToInt(Self.lbCartList.Prop.InteractiveItem.Detail1)-1);

    //同步商品列表
    CopyCartListNumberToGoodsListNumber;

    //刷新总金额
    SyncMoney;
  end;

end;

procedure TFrameMain.btnItemCartIncClick(Sender: TObject);
begin
  //加一
  Self.lbCartList.Prop.InteractiveItem.Detail1:=
    IntToStr(StrToInt(Self.lbCartList.Prop.InteractiveItem.Detail1)+1);

  //同步商品列表
  CopyCartListNumberToGoodsListNumber;

  //刷新总金额
  SyncMoney;

end;

procedure TFrameMain.btnItemGoodsDecClick(Sender: TObject);
begin
  //减一
  if StrToInt(Self.lvGoodsList.Prop.InteractiveItem.Detail1)>0 then
  begin
    Self.lvGoodsList.Prop.InteractiveItem.Detail1:=
      IntToStr(StrToInt(Self.lvGoodsList.Prop.InteractiveItem.Detail1)-1);


    //同步购物车列表
    CopyGoodsListNumberToCartListNumber;

    //刷新总金额
    SyncMoney;
  end;

end;

procedure TFrameMain.btnItemGoodsIncClick(Sender: TObject);
begin
  //加一
  Self.lvGoodsList.Prop.InteractiveItem.Detail1:=
    IntToStr(StrToInt(Self.lvGoodsList.Prop.InteractiveItem.Detail1)+1);



  //同步购物车列表
  CopyGoodsListNumberToCartListNumber;

  //刷新总金额
  SyncMoney;

end;

procedure TFrameMain.btnPayClick(Sender: TObject);
var
  I: Integer;
  AGoods:TGoods;
  AMessageBoxContent:String;
  ASuperObject:ISuperObject;
begin
  //下单
  if GlobalManager.RoomNO='' then
  begin
    ShowMessageBoxFrame(Self,'请设置房间号!','',TMsgDlgType.mtInformation,['确定']);
    Exit;
  end;

  if GlobalManager.WaitorNO='' then
  begin
    ShowMessageBoxFrame(Self,'请选择服务员号!','',TMsgDlgType.mtInformation,['确定']);
    Exit;
  end;

  if Self.lbCartList.Prop.Items.Count=0 then
  begin
    ShowMessageBoxFrame(Self,'请选择商品!','',TMsgDlgType.mtInformation,['确定']);
    Exit;
  end;



  FRoomNO:=GlobalManager.RoomNO;
  FWaitorNO:=GlobalManager.WaitorNO;
  FMoney:=Self.SumMoney;

  FGoodsListJsonStr:='';
  AMessageBoxContent:='';

  ASuperObject:=TSuperObject.Create();
  for I := 0 to Self.lbCartList.Prop.Items.Count-1 do
  begin
    if Self.lbCartList.Prop.Items[I].Checked then
    begin

      AGoods:=TGoods(Self.lbCartList.Prop.Items[I].Data);
      ASuperObject.A['GoodsList'].O[I].I['GoodsFID']:=AGoods.FID;
      ASuperObject.A['GoodsList'].O[I].S['Name']:=AGoods.Name;
      ASuperObject.A['GoodsList'].O[I].F['Price']:=AGoods.Price;
      ASuperObject.A['GoodsList'].O[I].F['Number']:=StrToFloat(Self.lbCartList.Prop.Items[I].Detail1);
      ASuperObject.A['GoodsList'].O[I].S['Unit']:=AGoods.Unit_;


      AMessageBoxContent:=AMessageBoxContent+AGoods.Name+' '+Self.lbCartList.Prop.Items[I].Detail1+' '+AGoods.Unit_+#13#10;

    end;
  end;
  FGoodsListJsonStr:=ASuperObject.AsJSON;




  //弹出对话框确认
  ShowMessageBoxFrame(Self,AMessageBoxContent+#13#10+'共消费'+' '+FloatToStr(SumMoney)+' '+'元!','',TMsgDlgType.mtCustom,['确定下单','取消'],DoBuyGoodsMessageBoxFrameModalResult,nil,'您选择的商品如下,请确认!');




end;

procedure TFrameMain.btnSelectAllClick(Sender: TObject);
var
  I: Integer;
begin
  Self.btnSelectAll.Prop.IsPushed:=Not Self.btnSelectAll.Prop.IsPushed;
  for I := 0 to Self.lbCartList.Prop.Items.Count-1 do
  begin
    Self.lbCartList.Prop.Items[I].Checked:=Self.btnSelectAll.Prop.IsPushed;
  end;
  Self.SyncCartNumber;
  Self.SyncMoney;
end;

procedure TFrameMain.btnSettingClick(Sender: TObject);
begin

  ShowFrame(TFrame(GlobalSettingFrame),TFrameSetting,frmMain,nil,nil,nil,Application,True,True,ufsefNone);

end;

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;
  FGoodsList:=TGoodsList.Create;

  FGoodsCategoryList:=TGoodsCategoryList.Create;

end;

destructor TFrameMain.Destroy;
begin
  uFuncCommon.FreeAndNil(FGoodsList);
  uFuncCommon.FreeAndNil(FGoodsCategoryList);

  inherited;
end;

procedure TFrameMain.DoBuyGoodsExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=
      ClientModuleUnit1.ClientModule.ServerMethods1Client.BuyGoods(
          FRoomNO,
          FWaitorNO,
          FGoodsListJsonStr,
          FMoney
          );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameMain.DoBuyGoodsExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


        //生成订单成功
        ShowMessageBoxFrame(Self,'下单成功!','',TMsgDlgType.mtInformation,['确定'],DoBuyGoodsMessageBoxFrameSuccModalResult);



      end
      else
      begin
        //生成订单失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定']);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定']);
    end;
  finally
    HideWaitingFrame;
  end;

end;

procedure TFrameMain.DoBuyGoodsMessageBoxFrameModalResult(Sender: TObject);
begin
  if GlobalMessageBoxFrame.ModalResult='确定下单' then
  begin
    ShowWaitingFrame(Self,'下单中...');

    //下单
    uTimerTask.GetGlobalTimerThread.RunTempTask(
          DoBuyGoodsExecute,
          DoBuyGoodsExecuteEnd);

  end;
end;

procedure TFrameMain.DoBuyGoodsMessageBoxFrameSuccModalResult(Sender: TObject);
var
  I: Integer;
begin
  Self.lbCartList.Prop.Items.Clear(True);
  for I := 0 to Self.lvGoodsList.Prop.Items.Count-1 do
  begin
    Self.lvGoodsList.Prop.Items[I].Detail1:='0';
  end;
  Self.SyncCartNumber;
  Self.SyncMoney;
  Self.SyncCaption;
end;

procedure TFrameMain.DoFilter;
var
  I: Integer;
  AFilter:String;
  ACartItem:TSkinItem;
  AListViewItem:TSkinListViewItem;
begin
  AFilter:=Trim(Self.edtFilter.Text);

//  if FFilter=AFilter then Exit;

  FFilter:=AFilter;


  //过滤
  Self.lvGoodsList.Properties.Items.BeginUpdate;
  try

    Self.lvGoodsList.Properties.Items.Clear(True);


    for I := 0 to Self.FGoodsList.Count-1 do
    begin

      if
        //名称过滤
        (
            (AFilter='')
        or (Pos(AFilter,TGoods(Self.FGoodsList[I]).Name)>0)
        or (Pos(LowerCase(AFilter),GetHzPy(TGoods(Self.FGoodsList[I]).Name))>0)
        )
        and
        //分类过滤
        (
            //没有选择分类
            (Self.lbCategory.Prop.SelectedItem=nil)
            //全部分类
            or (Self.lbCategory.Prop.SelectedItem.Data=nil)
            //指定分类
            or (Self.lbCategory.Prop.SelectedItem.Data<>nil)
              and (TGoodsCategory(Self.lbCategory.Prop.SelectedItem.Data).FID=TGoods(Self.FGoodsList[I]).GoodsCategoryID)
        )

        then
      begin

          AListViewItem:=Self.lvGoodsList.Prop.Items.Add;
          AListViewItem.Data:=FGoodsList[I];
          AListViewItem.Caption:=FGoodsList[I].Name;
          AListViewItem.Detail:=FloatToStr(FGoodsList[I].Price);


          //如果在购物车中存在,那么恢复它的数量
          ACartItem:=Self.lbCartList.Prop.Items.FindItemByData(FGoodsList[I]);
          if ACartItem<>nil then
          begin
            AListViewItem.Detail1:=ACartItem.Detail1;
          end
          else
          begin
            AListViewItem.Detail1:='0';
          end;
          


          AListViewItem.Detail2:=FGoodsList[I].Unit_;


          //自动下载
          AListViewItem.Icon.Url:=FGoodsList[I].GetThumbPicUrl;

      end;

//      Self.lvGoodsList.Prop.Items[I].Visible:=(
//                    (AFilter='')
//                  or (Pos(AFilter,Self.lvGoodsList.Prop.Items[I].Caption)>0)
//                  or (Pos(LowerCase(AFilter),GetHzPy(Self.lvGoodsList.Prop.Items[I].Caption))>0)
//                  );



    end;



//    for I := 0 to Self.lvGoodsList.Properties.Items.Count-1 do
//    begin
//
//      Self.lvGoodsList.Prop.Items[I].Visible:=(
//                    (AFilter='')
//                  or (Pos(AFilter,Self.lvGoodsList.Prop.Items[I].Caption)>0)
//                  or (Pos(LowerCase(AFilter),GetHzPy(Self.lvGoodsList.Prop.Items[I].Caption))>0)
//                  );
//
//    end;

  finally
    Self.lvGoodsList.VertScrollBar.Prop.Position:=0;
    Self.lvGoodsList.Properties.Items.EndUpdate;
  end;

end;

procedure TFrameMain.DoGetGoodsClassfiyExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.GetGoodsCategory;

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameMain.DoGetGoodsClassfiyExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  ASkinListBoxItem:TSkinListBoxItem;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取商品分类成功
        FGoodsCategoryList.Clear(True);
        FGoodsCategoryList.ParseFromJsonArray(TGoodsCategory,ASuperObject.O['Data'].A['GoodsCategorys']);

        Self.lbCategory.Prop.Items.BeginUpdate;
        try
          Self.lbCategory.Prop.Items.Clear(True);



//          //添加全部
//          ASkinListBoxItem:=Self.lbCategory.Prop.Items.Add;
//          ASkinListBoxItem.Caption:='全部';
//          ASkinListBoxItem.Data:=nil;
//          //默认选择全部
//          ASkinListBoxItem.Selected:=True;




          for I := 0 to FGoodsCategoryList.Count-1 do
          begin
            ASkinListBoxItem:=Self.lbCategory.Prop.Items.Add;
            ASkinListBoxItem.Caption:=FGoodsCategoryList[I].Name;
            ASkinListBoxItem.Data:=FGoodsCategoryList[I];

            //第一个定位
            ASkinListBoxItem.Selected:=(I=0);
          end;


        finally
          Self.lbCategory.Prop.Items.EndUpdate;
        end;


      end
      else
      begin
        //获取商品分类失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定']);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定']);
    end;
  finally
    HideWaitingFrame;
  end;

  if TTimerTask(ATimerTask).TaskTag=0 then
  begin
    if ASuperObject.I['Code']=200 then
    begin

      ShowWaitingFrame(Self,'加载商品...');

      //加载商品
      GetGlobalTimerThread.RunTempTask(DoGetGoodsListExecute,
                      DoGetGoodsListExecuteEnd);
    end;
  end;

end;

procedure TFrameMain.Load;
begin
//  Exit;

  ShowWaitingFrame(Self,'加载分类...');

  SyncCaption;

  Self.lbCategory.Prop.Items.Clear(True);
  Self.lvGoodsList.Prop.Items.Clear(True);
  Self.lbCartList.Prop.Items.Clear(True);

  Self.SyncCartNumber;
  Self.SyncMoney;

  //加载分类
  uTimerTask.GetGlobalTimerThread.RunTempTask(
        DoGetGoodsClassfiyExecute,
        DoGetGoodsClassfiyExecuteEnd);
end;

procedure TFrameMain.pnlToolBarClick(Sender: TObject);
begin
//  Load;
end;

procedure TFrameMain.CopyGoodsListNumberToCartListNumber;
var
  I:Integer;
  AGoods:TGoods;
  ACartItem:TSkinItem;
begin
  Self.lvGoodsList.Prop.Items.BeginUpdate;
  Self.lbCartList.Prop.Items.BeginUpdate;
  try
    //商品列表中数量要同步到购物车的列表中去
    for I := 0 to Self.lvGoodsList.Prop.Items.Count-1 do
    begin
      AGoods:=TGoods(Self.lvGoodsList.Prop.Items[I].Data);
      ACartItem:=Self.lbCartList.Prop.Items.FindItemByData(AGoods);

      if (ACartItem=nil) and (Self.lvGoodsList.Prop.Items[I].Detail1<>'0') then
      begin
        //不存在,添加
        ACartItem:=Self.lbCartList.Prop.Items.Add;

        ACartItem.Data:=AGoods;
        ACartItem.Caption:=AGoods.Name;
        ACartItem.Detail:=FloatToStr(AGoods.Price);
        ACartItem.Detail2:=AGoods.Unit_;
        //自动下载
        ACartItem.Icon.Url:=AGoods.GetThumbPicUrl;


        ACartItem.Checked:=True;
      end;

      if ACartItem<>nil then
      begin
        //存在,则同步
        ACartItem.Detail1:=Self.lvGoodsList.Prop.Items[I].Detail1;

        //如果数量为零,那要删除
        if ACartItem.Detail1='0' then
        begin
          Self.lbCartList.Prop.Items.Remove(ACartItem);
        end;
      end;

    end;
  finally
    Self.lvGoodsList.Prop.Items.EndUpdate();
    Self.lbCartList.Prop.Items.EndUpdate();
  end;

  SyncCartNumber;
end;

procedure TFrameMain.CopyCartListNumberToGoodsListNumber;
var
  I:Integer;
  AGoods:TGoods;
  AGoodsItem:TSkinItem;
begin
  Self.lbCartList.Prop.Items.BeginUpdate;
  try
    //购物车中存在的商品,相对应商品列表中也同步更新
    //如果购物车中数量为0了,就删除
    for I := lbCartList.Prop.Items.Count-1 downto 0 do
    begin
      AGoods:=TGoods(Self.lbCartList.Prop.Items[I].Data);

      AGoodsItem:=Self.lvGoodsList.Prop.Items.FindItemByData(AGoods);
      if AGoodsItem<>nil then
      begin
        //存在,则同步
        AGoodsItem.Detail1:=Self.lbCartList.Prop.Items[I].Detail1;
      end;

      //先同步再删除
      if Self.lbCartList.Prop.Items[I].Detail1='0' then
      begin
        //数量为0,删除
        Self.lbCartList.Prop.Items.Delete(I);
      end;

    end;
  finally
    Self.lbCartList.Prop.Items.EndUpdate();
  end;

  SyncCartNumber;

end;

procedure TFrameMain.SyncCaption;
begin

  Self.pnlToolBar.Caption:='酒水选购 '+'房间号'+GlobalManager.RoomNO+' 服务员号'+GlobalManager.WaitorNO;

end;

procedure TFrameMain.SyncCartNumber;
var
  I: Integer;
  ASelectedItemCount:Integer;
begin
  Self.nniCartNumber.Prop.Number:=0;
  ASelectedItemCount:=0;


  for I := 0 to Self.lbCartList.Prop.Items.Count-1 do
  begin
    if Self.lbCartList.Prop.Items[I].Checked then
    begin
      Self.nniCartNumber.Prop.Number:=
          Self.nniCartNumber.Prop.Number
          +StrToInt(Self.lbCartList.Prop.Items[I].Detail1);
      ASelectedItemCount:=ASelectedItemCount+1;
    end;
  end;



  Self.btnSelectAll.Prop.IsPushed:=
    (Self.lbCartList.Prop.Items.Count<>0)
    and (ASelectedItemCount=Self.lbCartList.Prop.Items.Count);


  if Self.btnSelectAll.Prop.IsPushed then
  begin
    Self.btnSelectAll.Caption:='全不选';
  end
  else
  begin
    Self.btnSelectAll.Caption:='全选';
  end;


end;

procedure TFrameMain.SyncMoney;
var
  I: Integer;
  AGoods:TGoods;
begin
  SumMoney:=0;
  for I := 0 to Self.lbCartList.Prop.Items.Count-1 do
  begin
    AGoods:=TGoods(Self.lbCartList.Prop.Items[I].Data);
    if Self.lbCartList.Prop.Items[I].Checked then
    begin
      SumMoney:=SumMoney+AGoods.Price*StrToInt(Self.lbCartList.Prop.Items[I].Detail1);
    end;
  end;
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=FloatToStr(SumMoney);
end;




end.
