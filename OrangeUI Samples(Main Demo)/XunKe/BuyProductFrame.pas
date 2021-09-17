//convert pas to utf8 by ¥

unit BuyProductFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  SubmitOrderFrame,
  XunKeCommonSkinMaterialModule,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyRoundRect,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinMaterial,
  uSkinScrollControlType, uSkinVirtualListType, uSkinListViewType,
  uSkinPanelType, uSkinLabelType, uSkinCustomListType, uSkinFireMonkeyCustomList,
  uDrawCanvas, uSkinItems, uSkinRoundRectType, uSkinButtonType,
  uSkinScrollBoxContentType, uSkinScrollBoxType;

type
  TFrameBuyProduct = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    btnOK: TSkinFMXButton;
    pnlInfo: TSkinFMXPanel;
    lblDefaultPrice: TSkinFMXLabel;
    lblHint: TSkinFMXLabel;
    btnClose: TSkinFMXButton;
    pnlImage: TSkinFMXPanel;
    rrImage: TSkinFMXRoundRect;
    pnlColorHint: TSkinFMXPanel;
    lvColors: TSkinFMXListView;
    pnlListItemDefaultDevide: TSkinFMXPanel;
    pnlListItemDefaultDevide2: TSkinFMXPanel;
    pnlSize: TSkinFMXPanel;
    lvSizes: TSkinFMXListView;
    pnlListItemDefaultDevide1: TSkinFMXPanel;
    pnlCount: TSkinFMXPanel;
    SkinFMXPanel11: TSkinFMXPanel;
    btnDecCount: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnAddCount: TSkinFMXButton;
    pnlTop: TSkinFMXPanel;
    lblLeftCount: TSkinFMXLabel;
    pnlGap: TSkinFMXPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnAddCountClick(Sender: TObject);
    procedure btnDecCountClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
//    ProductInfoFrame:TFrame;
    { Public declarations }
  end;


var
  GlobalBuyProductFrame:TFrameBuyProduct;


implementation

uses
  MainForm,
  MainFrame,
  ProductInfoFrame;

{$R *.fmx}

procedure TFrameBuyProduct.FrameResize(Sender: TObject);
begin
  Self.lvColors.Height:=Self.lvColors.Properties.VisibleItemDrawRect(
                            Self.lvColors.Properties.Items[Self.lvColors.Properties.Items.Count-1]).Bottom;
  Self.lvSizes.Height:=Self.lvSizes.Properties.VisibleItemDrawRect(
                            Self.lvSizes.Properties.Items[Self.lvSizes.Properties.Items.Count-1]).Bottom;
  Self.sbcClient.Height:=Self.Height-Self.btnOK.Height;
end;

procedure TFrameBuyProduct.btnDecCountClick(Sender: TObject);
begin
  if StrToInt(Self.edtCount.Text)>1 then
  begin
    Self.edtCount.Text:=IntToStr(StrToInt(Self.edtCount.Text)-1);
  end;
end;

procedure TFrameBuyProduct.btnAddCountClick(Sender: TObject);
begin
  Self.edtCount.Text:=IntToStr(StrToInt(Self.edtCount.Text)+1);
end;

procedure TFrameBuyProduct.btnOKClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //跳转到提交
  ShowFrame(TFrame(GlobalSubmitOrderFrame),TFrameSubmitOrder,frmMain,nil,nil,nil,Application);
//  GlobalSubmitOrderFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameBuyProduct.btnCloseClick(Sender: TObject);
begin
  //直接隐藏
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self);
end;

end.
