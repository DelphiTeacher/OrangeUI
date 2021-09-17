//convert pas to utf8 by ¥
unit OrderGoodsListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  EasyServiceCommonMaterialDataMoudle,

  uTimerTask,
  uManager,


  uFuncCommon,
  uBaseList,
  uSkinItems,

  WaitingFrame,
  MessageBoxFrame,
  uSkinListBoxType,

  uInterfaceClass,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uSkinMultiColorLabelType, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas;

type
  TFrameOrderGoodsList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    pnlBottomBar: TSkinFMXPanel;
    btnItemOper1: TSkinFMXButton;
    lbProList: TSkinFMXListBox;
    idpProInfoList: TSkinFMXItemDesignerPanel;
    imgProPicture: TSkinFMXImage;
    lblProName: TSkinFMXLabel;
    mclPrice: TSkinFMXMultiColorLabel;
    lblGoodsCost: TSkinFMXLabel;
    lblGoodsNumber: TSkinFMXLabel;
    lblGoodsUnit: TSkinFMXLabel;
    btnReturn: TSkinFMXButton;
    lblGoodsModel: TSkinFMXLabel;
    lblGoodsModelNumber: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbProListClickItem(AItem: TSkinItem);
  private

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
  public
    //显示订单的商品列表
    procedure Load(AOrder:TOrder);
    //下单时的商品列表
    procedure LoadGoodsList(ABuyGoodsList:TBuyGoodsList);
    { Public declarations }
  end;

var
  GlobalOrderGoodsListFrame:TFrameOrderGoodsList;

implementation

{$R *.fmx}

uses
  GoodsInfoFrame,
  MainFrame,
  MainForm;

{ TFrameOrderGoodsList }

procedure TFrameOrderGoodsList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameOrderGoodsList.lbProListClickItem(AItem: TSkinItem);
var
  AGoods:TGoods;
begin
  AGoods:=AItem.Data;
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //显示商品详情页面
  ShowFrame(TFrame(GlobalGoodsInfoFrame),TFrameGoodsInfo,frmMain,nil,nil,nil,Application);
//  GlobalGoodsInfoFrame.FrameHistroy:=CurrentFrameHistroy;

  GlobalGoodsInfoFrame.Load(AGoods);
end;

procedure TFrameOrderGoodsList.Load(AOrder:TOrder);
//var
//  AListBoxItem:TSkinListBoxItem;
//  I:Integer;
begin
  LoadGoodsList(AOrder.OrderGoodsList);

  Self.pnlBottomBar.Visible:=True;

//  Self.lbProList.Prop.Items.Clear(True);
//
//  Self.lbProList.Prop.Items.BeginUpdate;
//  for I := 0 to AOrder.OrderGoodsList.Count-1  do
//  begin
//
//
//    AListBoxItem:=Self.lbProList.Prop.Items.Add;
//    AListBoxItem.Data:=AOrder.OrderGoodsList[I];
//
//    AListBoxItem.Caption:=AOrder.OrderGoodsList[I].name;
//    AListBoxItem.Detail:=AOrder.OrderGoodsList[I].marque;
//    AListBoxItem.Detail2:=AOrder.OrderGoodsList[I].goods_unit;
//    AListBoxItem.Detail1:=FloatToStr(AOrder.OrderGoodsList[I].cost);
//    AListBoxItem.Detail3:=IntToStr(AOrder.OrderGoodsList[I].number);
//    AListBoxItem.Detail4:=AOrder.OrderGoodsList[I].goods_unit;
//    AListBoxItem.Icon.Url:=AOrder.OrderGoodsList[I].GetPic1Url;
//
//  end;
//  Self.lbProList.Prop.Items.EndUpdate();
end;

procedure TFrameOrderGoodsList.LoadGoodsList(ABuyGoodsList: TBuyGoodsList);
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  Self.pnlBottomBar.Visible:=False;

  Self.lbProList.Prop.Items.BeginUpdate;
  try
    Self.lbProList.Prop.Items.Clear(True);
    for I := 0 to ABuyGoodsList.Count-1 do
    begin
      AListBoxItem:=Self.lbProList.Prop.Items.Add;
      AListBoxItem.Data:=ABuyGoodsList[I];

      AListBoxItem.Caption:=ABuyGoodsList[I].name;
      AListBoxItem.Detail2:=ABuyGoodsList[I].goods_unit;
      if ABuyGoodsList[I] is TOrderGoods then
      begin
        AListBoxItem.Detail1:=FloatToStr(TOrderGoods(ABuyGoodsList[I]).order_goods_price);
      end
      else
      begin
        AListBoxItem.Detail1:=FloatToStr(ABuyGoodsList[I].price);
      end;
      AListBoxItem.Detail:=ABuyGoodsList[I].marque;
      AListBoxItem.Detail3:=IntToStr(ABuyGoodsList[I].number);
      AListBoxItem.Detail4:=ABuyGoodsList[I].goods_unit;

      AListBoxItem.Icon.Url:=ABuyGoodsList[I].GetPic1Url;

    end;
  finally
    Self.lbProList.Prop.Items.EndUpdate();
  end;

end;

end.
