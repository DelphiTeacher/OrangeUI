//convert pas to utf8 by ¥
unit FilterBusStationFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  BusLiveCommonSkinMaterialModule,
  uSkinItems,
  uUIFunction,
  BusStationFrame,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uDrawPicture, uSkinImageList,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameFilterBusStation = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblStations: TSkinFMXListBox;
    edtKeyword: TSkinFMXEdit;
    procedure btnReturnClick(Sender: TObject);
    procedure lblStationsClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalFilterBusStationFrame:TFrameFilterBusStation;

implementation

uses
  MainForm;


{$R *.fmx}

procedure TFrameFilterBusStation.btnReturnClick(Sender: TObject);
begin
//  FrameHistroy.OnReturnFrame:=nil;

  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameFilterBusStation.lblStationsClickItem(Sender: TSkinItem);
begin
  Self.edtKeyword.Text:=TSkinItem(Sender).Caption;

  //查看线路
  HideFrame;//(Self);
  ReturnFrame;//(FrameHistroy);
end;

end.
