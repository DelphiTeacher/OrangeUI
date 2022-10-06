//convert pas to utf8 by ¥

unit BuyProductFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinLabelType, uSkinImageType,
  uSkinButtonType, uSkinPanelType;

type
  TFrameBuyProduct = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    btnClose: TSkinFMXButton;
    ItemDefault: TSkinFMXPanel;
    imgDefaultIcon: TSkinFMXImage;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultPrice: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    imgBuy: TSkinFMXImage;
    btnOK: TSkinFMXButton;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    btnDec: TSkinFMXButton;
    btnInc: TSkinFMXButton;
    edtNumber: TSkinFMXEdit;
    SkinFMXPanel6: TSkinFMXPanel;
    SkinFMXPanel8: TSkinFMXPanel;
    SkinFMXPanel7: TSkinFMXPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure imgBuyResize(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnIncClick(Sender: TObject);
    procedure btnDecClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalBuyProductFrame:TFrameBuyProduct;

implementation

{$R *.fmx}

procedure TFrameBuyProduct.imgBuyResize(Sender: TObject);
begin
  btnOK.Left:=(Self.imgBuy.WidthInt-btnOK.WidthInt) div 2;
end;

procedure TFrameBuyProduct.btnDecClick(Sender: TObject);
begin
  if StrToInt(Self.edtNumber.Text)>1 then
  begin
    Self.edtNumber.Text:=IntToStr(StrToInt(Self.edtNumber.Text)-1);
  end;
end;

procedure TFrameBuyProduct.btnIncClick(Sender: TObject);
begin
  Self.edtNumber.Text:=IntToStr(StrToInt(Self.edtNumber.Text)+1);
end;

procedure TFrameBuyProduct.btnOKClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameBuyProduct.btnCloseClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

end.
