//convert pas to utf8 by ¥
unit FilterBusLineFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  BusLiveCommonSkinMaterialModule,
  uSkinItems,
  uUIFunction,
  BusLineFrame,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uDrawPicture, uSkinImageList,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameFilterBusLine = class(TFrame)
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
    procedure LoadData(AKeyword:String);
    { Public declarations }
  end;

var
  GlobalFilterBusLineFrame:TFrameFilterBusLine;

implementation

uses
  MainForm;


{$R *.fmx}

procedure TFrameFilterBusLine.btnReturnClick(Sender: TObject);
begin
//  FrameHistroy.OnReturnFrame:=nil;

  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameFilterBusLine.lblStationsClickItem(Sender: TSkinItem);
begin
  Self.edtKeyword.Text:=TSkinItem(Sender).Caption;

  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameFilterBusLine.LoadData(AKeyword: String);
begin
  Self.edtKeyword.Text:=AKeyword;
end;

end.
