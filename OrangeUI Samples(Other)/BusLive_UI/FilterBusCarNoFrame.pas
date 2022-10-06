//convert pas to utf8 by ¥
unit FilterBusCarNoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  uSkinItems,
  RealTimeBusLineFrame,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uDrawPicture, uSkinImageList,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameFilterBusCarNo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblStations: TSkinFMXListBox;
    edtPhone: TSkinFMXEdit;
    procedure btnReturnClick(Sender: TObject);
    procedure lblStationsClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalFilterBusCarNoFrame:TFrameFilterBusCarNo;

implementation

uses
  MainForm;


{$R *.fmx}

procedure TFrameFilterBusCarNo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameFilterBusCarNo.lblStationsClickItem(Sender: TSkinItem);
begin
  //查看线路
  HideFrame;////(Self);
  ShowFrame(TFrame(GlobalRealTimeBusLineFrame),TFrameRealTimeBusLine,frmMain,nil,nil,nil,Application);
//  GlobalRealTimeBusLineFrame.FrameHistroy:=CurrentFrameHistroy;

end;

end.
