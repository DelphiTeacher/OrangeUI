unit ShoppingCartFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinMaterial,
  uSkinCheckBoxType, uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel,
  uSkinFireMonkeyButton, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyVirtualList;

type
  TFrameShoppingCart = class(TFrame)
    SkinFMXPanel1: TSkinFMXPanel;
    lbShoppingCart: TSkinFMXListBox;
    SkinFMXCheckBox1: TSkinFMXCheckBox;
    defCheckBoxMaterial: TSkinCheckBoxDefaultMaterial;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    ItemHeader: TSkinFMXItemDesignerPanel;
    chkHeaderFromCaption: TSkinFMXCheckBox;
    lblHeaderDetail: TSkinFMXLabel;
    ItemDefault: TSkinFMXItemDesignerPanel;
    chkDefaultChecked: TSkinFMXCheckBox;
    imgDefaultIcon: TSkinFMXImage;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultDetail: TSkinFMXLabel;
    lblDefaultDetail1: TSkinFMXLabel;
    lblDefaultDetail2: TSkinFMXLabel;
    lblDefaultDetail3: TSkinFMXLabel;
    ItemFooter: TSkinFMXItemDesignerPanel;
    lblFooterCaption: TSkinFMXLabel;
    lblFooterDetail: TSkinFMXLabel;
    lblFooterDetail1: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    procedure chkDefaultCheckedClick(Sender: TObject);
    procedure chkHeaderFromCaptionClick(Sender: TObject);
  private
    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


var
  GlobalShoppingCartFrame:TFrameShoppingCart;

implementation

{$R *.fmx}

procedure TFrameShoppingCart.chkDefaultCheckedClick(Sender: TObject);
begin
  //��ѡ��ȡ����ѡ
  if Self.lbShoppingCart.Properties.InteractiveItem<>nil then
  begin
    Self.lbShoppingCart.Properties.InteractiveItem.Checked:=
      not Self.lbShoppingCart.Properties.InteractiveItem.Checked;
  end;
end;

procedure TFrameShoppingCart.chkHeaderFromCaptionClick(Sender: TObject);
begin
  //��ѡ��ȡ����ѡ
  if Self.lbShoppingCart.Properties.InteractiveItem<>nil then
  begin
    Self.lbShoppingCart.Properties.InteractiveItem.Checked:=
      not Self.lbShoppingCart.Properties.InteractiveItem.Checked;
  end;
end;

constructor TFrameShoppingCart.Create(AOwner: TComponent);
begin
  inherited;
end;

end.
