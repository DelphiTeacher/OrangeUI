//convert pas to utf8 by ¥
unit BusLineListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  uSkinItems,
  RealTimeBusLineFrame,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas;

type
  TFrameBusLineList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbLines: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    pnlTop: TSkinFMXPanel;
    btnSetting: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbLinesClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalBusLineListFrame:TFrameBusLineList;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameBusLineList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameBusLineList.lbLinesClickItem(Sender: TSkinItem);
begin
  HideFrame;////(Self);
  ShowFrame(TFrame(GlobalRealTimeBusLineFrame),TFrameRealTimeBusLine,frmMain,nil,nil,nil,Application);
//  GlobalRealTimeBusLineFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.
