//convert pas to utf8 by ¥

unit ShopCartFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinItems,
  uUIFunction,
  SubmitOrderFrame,
  XunKeCommonSkinMaterialModule,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinMaterial,
  uSkinCheckBoxType, uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel,
  uSkinFireMonkeyButton, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyMultiColorLabel,
  uSkinFireMonkeyCustomList, uDrawCanvas, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinLabelType,
  uSkinMultiColorLabelType, uSkinButtonType, uSkinPanelType;

type
  TFrameShopCart = class(TFrame)
    pnlBottomBar: TSkinFMXPanel;
    lbShoppingCart: TSkinFMXListBox;
    chkSelectAll: TSkinFMXCheckBox;
    defCheckBoxMaterial: TSkinCheckBoxDefaultMaterial;
    ItemHeader: TSkinFMXItemDesignerPanel;
    chkHeaderFromCaption: TSkinFMXCheckBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    chkDefaultChecked: TSkinFMXCheckBox;
    imgDefaultIcon: TSkinFMXImage;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultDetail: TSkinFMXLabel;
    lblDefaultDetail1: TSkinFMXLabel;
    lblDefaultDetail2: TSkinFMXLabel;
    lblDefaultDetail3: TSkinFMXLabel;
    btnBuy: TSkinFMXButton;
    lblPrice: TSkinFMXMultiColorLabel;
    lblFee: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    imgItemHeaderIcon: TSkinFMXImage;
    lblItemHeaderCaption: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    procedure chkDefaultCheckedClick(Sender: TObject);
    procedure chkHeaderFromCaptionClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
    procedure chkSelectAllClick(Sender: TObject);
    procedure lbShoppingCartClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalShopCartFrame:TFrameShopCart;

implementation

uses
  MainForm,
  MainFrame;

{$R *.fmx}

procedure TFrameShopCart.btnBuyClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);
  //跳转到提交
  ShowFrame(TFrame(GlobalSubmitOrderFrame),TFrameSubmitOrder,frmMain,nil,nil,nil,Application);
//  GlobalSubmitOrderFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameShopCart.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameShopCart.chkDefaultCheckedClick(Sender: TObject);
begin
  //选中,动态绑定CheckBox
  if Self.lbShoppingCart.Properties.InteractiveItem<>nil then
  begin
    Self.lbShoppingCart.Properties.InteractiveItem.Checked:=
      not Self.lbShoppingCart.Properties.InteractiveItem.Checked;
  end;
end;

procedure TFrameShopCart.chkHeaderFromCaptionClick(Sender: TObject);
begin
  //选中,动态绑定CheckBox
  if Self.lbShoppingCart.Properties.InteractiveItem<>nil then
  begin
    Self.lbShoppingCart.Properties.InteractiveItem.Checked:=
      not Self.lbShoppingCart.Properties.InteractiveItem.Checked;
  end;
end;

procedure TFrameShopCart.chkSelectAllClick(Sender: TObject);
var
  I: Integer;
begin
  //全选
  for I := 0 to Self.lbShoppingCart.Properties.Items.Count-1 do
  begin
    Self.lbShoppingCart.Properties.Items[I].Checked:=
      Self.chkSelectAll.Properties.Checked;
  end;
end;

procedure TFrameShopCart.lbShoppingCartClickItem(Sender: TSkinItem);
begin
  //选中
  if Self.lbShoppingCart.Properties.InteractiveItem<>nil then
  begin
    Self.lbShoppingCart.Properties.InteractiveItem.Checked:=
      not Self.lbShoppingCart.Properties.InteractiveItem.Checked;
  end;

end;


end.
