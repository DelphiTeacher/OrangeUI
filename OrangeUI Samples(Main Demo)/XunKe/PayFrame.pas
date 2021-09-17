//convert pas to utf8 by ¥

unit PayFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uUIFunction,
  uSkinItems,
  uFrameContext,
  XunKeCommonSkinMaterialModule,
  uSkinListBoxType,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinImageList, uSkinFireMonkeyLabel, uSkinButtonType,
  uSkinFireMonkeyImageListViewer, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyImage,
  uDrawPicture, uSkinFireMonkeyFrameImage, uSkinFireMonkeyListView,
  uSkinFireMonkeyCheckBox, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uDrawCanvas, uSkinPanelType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType;

type
  TFramePay= class(TFrame)
    lblPayMethod: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    ItemPayMethod: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    ItemSelectPayMethod: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnBuyClick(Sender: TObject);
    procedure lblPayMethodClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalPayFrame:TFramePay;

implementation

{$R *.fmx}

uses
  MainForm,
  ProductInfoFrame,
  MainFrame;

procedure TFramePay.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFramePay.btnBuyClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFramePay.lblPayMethodClickItem(Sender: TSkinItem);
begin
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
    //付款
    HideFrame;//(Self,hfcttBeforeShowFrame);

    if GlobalProductInfoFrame<>nil then
    begin
      GlobalProductInfoFrame.Visible:=False;
    end;



    //付款结束
    //回到原点
    uFrameContext.GlobalFrameHistoryLogList.Clear(True);
    //显示主界面
    ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application);
//    GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
end;



end.
