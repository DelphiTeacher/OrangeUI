//convert pas to utf8 by ¥

unit TodayOrderFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uUIFunction,
  uSkinItems,
  uSkinListBoxType,
  XunKeCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinImageList, uSkinFireMonkeyLabel, uSkinButtonType,
  uSkinFireMonkeyImageListViewer, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyImage,
  uDrawPicture, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uDrawCanvas, uSkinLabelType, uSkinPanelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType;

type
  TFrameTodayOrder = class(TFrame)
    lbProductList: TSkinFMXListBox;
    imglistProduct: TSkinImageList;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgDefaultIcon: TSkinFMXImage;
    SkinFMXPanel4: TSkinFMXPanel;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultSize: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    lblDefaultCount: TSkinFMXLabel;
    lblDeafultNewPrice: TSkinFMXLabel;
    lblDeafultOldPrice: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    lblDefaultSendState: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    lblDefaultOrderNo: TSkinFMXLabel;
    lblDefaultProductNo: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalKindProductListFrame:TFrameTodayOrder;

implementation

{$R *.fmx}

uses
  MainForm,MainFrame;

procedure TFrameTodayOrder.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

end.
