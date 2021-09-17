//convert pas to utf8 by ¥

unit Basic_PanDrag_ShoppingCartFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uComponentType,
  uFuncCommon,
  uUIFunction,

  Math,
  uTimerTask,
  WaitingFrame,
  MessageBoxFrame,
  FMX.Platform,

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
  uSkinFireMonkeyCustomList, uSkinImageType, uSkinLabelType,
  uSkinMultiColorLabelType, uSkinCheckBoxType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinPanelType;

type
  TFrameBasic_PanDrag_ShoppingCart = class(TFrame)
    pnlClient: TSkinFMXPanel;
    lbCartList: TSkinFMXListBox;
    ItemCart: TSkinFMXItemDesignerPanel;
    btnItemCartDec: TSkinFMXButton;
    btnItemCartInc: TSkinFMXButton;
    edtItemCartNumber: TSkinFMXEdit;
    chkItemCartChecked: TSkinFMXCheckBox;
    pnlItemCartInfo: TSkinFMXPanel;
    lblItemCartPrice: TSkinFMXMultiColorLabel;
    lblItemCartCaption: TSkinFMXLabel;
    idpItemPanDrag: TSkinFMXItemDesignerPanel;
    btnDel: TSkinFMXButton;
    pnlPay: TSkinFMXPanel;
    btnPay: TSkinFMXButton;
    btnSelectAll: TSkinFMXButton;
    lblSumMoney: TSkinFMXMultiColorLabel;
    imgItemGoodsPic: TSkinFMXImage;
    procedure btnItemCartDecClick(Sender: TObject);
    procedure btnItemCartIncClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure lbCartListClickItemEx(Sender: TObject; Item: TSkinItem; X,
      Y: Double);
    procedure btnDelClick(Sender: TObject);
  private
   { Private declarations }
  private
    SumMoney:Double;

    //更新购物车数量
    procedure SyncCartNumber;
    //计算总金额
    procedure SyncMoney;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;





implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameBasic_PanDrag_ShoppingCart.lbCartListClickItemEx(Sender: TObject; Item: TSkinItem; X,
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

procedure TFrameBasic_PanDrag_ShoppingCart.btnDelClick(Sender: TObject);
begin
  Self.lbCartList.Properties.PanDragItem.Detail1:='0';

  Self.lbCartList.Properties.Items.Remove(Self.lbCartList.Properties.PanDragItem,True);

  Self.SyncCartNumber;
  Self.SyncMoney;

end;

procedure TFrameBasic_PanDrag_ShoppingCart.btnItemCartDecClick(Sender: TObject);
begin
  //减一
  if StrToInt(Self.lbCartList.Prop.InteractiveItem.Detail1)>0 then
  begin
    Self.lbCartList.Prop.InteractiveItem.Detail1:=
      IntToStr(StrToInt(Self.lbCartList.Prop.InteractiveItem.Detail1)-1);

    //刷新总金额
    SyncMoney;
  end;

end;

procedure TFrameBasic_PanDrag_ShoppingCart.btnItemCartIncClick(Sender: TObject);
begin
  //加一
  Self.lbCartList.Prop.InteractiveItem.Detail1:=
    IntToStr(StrToInt(Self.lbCartList.Prop.InteractiveItem.Detail1)+1);

  //刷新总金额
  SyncMoney;

end;

procedure TFrameBasic_PanDrag_ShoppingCart.btnSelectAllClick(Sender: TObject);
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


constructor TFrameBasic_PanDrag_ShoppingCart.Create(AOwner: TComponent);
begin
  inherited;

  Self.SyncCartNumber;
  Self.SyncMoney;

end;

destructor TFrameBasic_PanDrag_ShoppingCart.Destroy;
begin
  inherited;
end;

procedure TFrameBasic_PanDrag_ShoppingCart.SyncCartNumber;
var
  I: Integer;
  ASelectedItemCount:Integer;
begin
  ASelectedItemCount:=0;


  for I := 0 to Self.lbCartList.Prop.Items.Count-1 do
  begin
    if Self.lbCartList.Prop.Items[I].Checked then
    begin
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

procedure TFrameBasic_PanDrag_ShoppingCart.SyncMoney;
var
  I: Integer;
begin
  SumMoney:=0;
  for I := 0 to Self.lbCartList.Prop.Items.Count-1 do
  begin
    if Self.lbCartList.Prop.Items[I].Checked then
    begin
      SumMoney:=SumMoney
          +StrToFloat(Self.lbCartList.Prop.Items[I].Detail)
          *StrToInt(Self.lbCartList.Prop.Items[I].Detail1);
    end;
  end;
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=FloatToStr(SumMoney);
end;




end.
