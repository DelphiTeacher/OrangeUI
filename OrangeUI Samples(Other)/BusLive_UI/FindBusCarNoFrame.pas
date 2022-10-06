//convert pas to utf8 by ¥
unit FindBusCarNoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  BusLiveCommonSkinMaterialModule,
  uSkinItems,
  uUIFunction,
  BusLineFrame,
  RealTimeBusLineFrame,
  FilterBusCarNoFrame,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyLabel, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uDrawPicture, uSkinImageList, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uSkinLabelType, uSkinPanelType, uDrawCanvas;

type
  TFrameFindBusCarNo = class(TFrame)
    pnlTop: TSkinFMXPanel;
    lblFind: TSkinFMXLabel;
    lbHistroy: TSkinFMXListBox;
    imglistStation: TSkinImageList;
    btnClearHistroy: TSkinFMXButton;
    lblHistroyHint: TSkinFMXLabel;
    edtKeyword: TSkinFMXEdit;
    btnGO: TSkinFMXButton;
    procedure lbHistroyClickItem(Sender: TSkinItem);
    procedure btnClearHistroyClick(Sender: TObject);
    procedure btnGOClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalFindBusCarNoFrame:TFrameFindBusCarNo;

implementation

uses
  MainForm,
  GoWhereFrame;

{$R *.fmx}

procedure TFrameFindBusCarNo.btnClearHistroyClick(Sender: TObject);
begin
  Self.lbHistroy.Properties.Items.Clear(True);
end;

procedure TFrameFindBusCarNo.btnGOClick(Sender: TObject);
begin
  //查看线路
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalRealTimeBusLineFrame),TFrameRealTimeBusLine,frmMain,nil,nil,nil,Application);
//  GlobalRealTimeBusLineFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameFindBusCarNo.lbHistroyClickItem(Sender: TSkinItem);
begin
  Self.edtKeyword.Text:=TSkinItem(Sender).Caption;
end;

end.
