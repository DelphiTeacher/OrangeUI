//convert pas to utf8 by ¥
unit CartFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinMaterial,
  uSkinCheckBoxType, uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel,
  uSkinFireMonkeyButton, uSkinFireMonkeyItemDesignerPanel, uSkinPageControlType,
  uSkinFireMonkeyPageControl, uSkinFireMonkeySwitchPageListPanel,
  uUIFunction,
  LoginFrame,
  Math,
  uSkinItems,
  uComponentType,
  uSkinListBoxType,
  uSkinButtonType, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyVirtualList, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinPanelType, uDrawCanvas;

type
  TFrameCart = class(TFrame,IFrameVirtualKeyboardEvent)
    defCheckBoxMaterial: TSkinCheckBoxDefaultMaterial;
    bdmLoginButton: TSkinButtonDefaultMaterial;
    pnlVirtualKeyboard: TSkinFMXPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbShoppingCart: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    chkDefaultChecked: TSkinFMXCheckBox;
    imgDefaultIcon: TSkinFMXImage;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultDetail: TSkinFMXLabel;
    lblDefaultDetail1: TSkinFMXLabel;
    edtBindingEdit: TSkinFMXEdit;
    ItemFooter: TSkinFMXItemDesignerPanel;
    lblFooterCaption: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    pnlBottomBar: TSkinFMXPanel;
    SkinFMXCheckBox1: TSkinFMXCheckBox;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    procedure edtBindingEditStayClick(Sender: TObject);
    procedure edtEditPriceKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure btnReturnClick(Sender: TObject);
  private
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


var
  GlobalCartFrame:TFrameCart;

implementation

{$R *.fmx}


uses
  MainForm;


procedure TFrameCart.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameCart.Create(AOwner: TComponent);
begin
  inherited;
  Self.pnlVirtualKeyboard.Height:=0;
end;

procedure TFrameCart.DoVirtualKeyboardHide(KeyboardVisible: Boolean;const Bounds: TRect);
begin
  Self.pnlVirtualKeyboard.Height:=0;
end;

procedure TFrameCart.DoVirtualKeyboardShow(KeyboardVisible: Boolean;const Bounds: TRect);
var
  AEditingItemRect:TRectF;
begin
  if Bounds.Height-GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight>Self.pnlVirtualKeyboard.Height then
  begin
    Self.pnlVirtualKeyboard.Height:=RectHeight(Bounds)-GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight-50;

    if Self.lbShoppingCart.Properties.EditingItem<>nil then
    begin
      AEditingItemRect:=Self.lbShoppingCart.Properties.VisibleItemRect(
        Self.lbShoppingCart.Properties.EditingItem.Index
        );

      Self.lbShoppingCart.VertScrollBar.Properties.Position:=
        AEditingItemRect.Top;
    end;
  end;
end;

procedure TFrameCart.edtBindingEditStayClick(Sender: TObject);
begin
  Self.lbShoppingCart.Properties.StartEditingItem(
          Self.lbShoppingCart.Properties.MouseOverItem,
          edtBindingEdit,
          nil,
          edtBindingEdit.SkinControlType.FMouseDownPt.X,
          edtBindingEdit.SkinControlType.FMouseDownPt.Y
          );

end;

procedure TFrameCart.edtEditPriceKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key=13 then
  begin
    Self.lbShoppingCart.Properties.StopEditingItem;
  end;
end;

end.
