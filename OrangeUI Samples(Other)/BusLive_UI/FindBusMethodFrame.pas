//convert pas to utf8 by ¥
unit FindBusMethodFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  uSkinItems,
  BusLineFrame,
  BusMethodFrame,
  FilterBusStationFrame,
//  FilterBusLineFrame,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyLabel, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uDrawPicture, uSkinImageList, uSkinFireMonkeyImage,
  uSkinMaterial, uSkinButtonType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinLabelType, uSkinPanelType,
  uDrawCanvas;

type
  TFrameFindBusMethod = class(TFrame)
    pnlTop: TSkinFMXPanel;
    lblFind: TSkinFMXLabel;
    lbHistroy: TSkinFMXListBox;
    imglistStation: TSkinImageList;
    btnClearHistroy: TSkinFMXButton;
    imgPlaceType: TSkinImageList;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblHistroyHint: TSkinFMXLabel;
    edtFromKeyword: TSkinFMXEdit;
    edtToKeyword: TSkinFMXEdit;
    btnSwitch: TSkinFMXButton;
    btnGO: TSkinFMXButton;
    procedure lbHistroyClickItem(Sender: TSkinItem);
    procedure btnGOClick(Sender: TObject);
    procedure btnClearHistroyClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure edtFromKeywordClick(Sender: TObject);
    procedure edtToKeywordClick(Sender: TObject);
    procedure btnSwitchClick(Sender: TObject);
  private
    procedure DoReturnFrameFromFilterBusStation_From(Frame:TFrame);
    procedure DoReturnFrameFromFilterBusStation_To(Frame:TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure LoadData(AFrom:String;ATo:String);
    { Public declarations }
  end;

var
  GlobalFindBusMethodFrame:TFrameFindBusMethod;

implementation

uses
  MainForm,
  GoWhereFrame;

{$R *.fmx}

procedure TFrameFindBusMethod.lbHistroyClickItem(Sender: TSkinItem);
begin
  Self.edtFromKeyword.Text:='我的位置';
  Self.edtToKeyword.Text:='公交南站';

end;

procedure TFrameFindBusMethod.LoadData(AFrom:String;ATo:String);
begin
  Self.edtFromKeyword.Text:=AFrom;
  Self.edtToKeyword.Text:=ATo;
end;

procedure TFrameFindBusMethod.btnGOClick(Sender: TObject);
begin
  //显示出行方案页面
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalBusMethodFrame),TFrameBusMethod,frmMain,nil,nil,nil,Application);
//  GlobalBusMethodFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameFindBusMethod.btnClearHistroyClick(Sender: TObject);
begin
  Self.lbHistroy.Properties.Items.Clear(True);
end;

procedure TFrameFindBusMethod.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameFindBusMethod.btnSwitchClick(Sender: TObject);
var
  AText:String;
begin
  AText:=Self.edtFromKeyword.Text;
  Self.edtFromKeyword.Text:=Self.edtToKeyword.Text;
  Self.edtToKeyword.Text:=AText;
end;

procedure TFrameFindBusMethod.DoReturnFrameFromFilterBusStation_From(Frame: TFrame);
begin
  Self.edtFromKeyword.Text:=GlobalFilterBusStationFrame.edtKeyword.Text;

end;

procedure TFrameFindBusMethod.DoReturnFrameFromFilterBusStation_To(Frame: TFrame);
begin
  Self.edtToKeyword.Text:=GlobalFilterBusStationFrame.edtKeyword.Text;

end;

procedure TFrameFindBusMethod.edtFromKeywordClick(Sender: TObject);
begin
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalFilterBusStationFrame),TFrameFilterBusStation,frmMain,nil,nil,DoReturnFrameFromFilterBusStation_From,Application);
//  GlobalFilterBusStationFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameFindBusMethod.edtToKeywordClick(Sender: TObject);
begin
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalFilterBusStationFrame),TFrameFilterBusStation,frmMain,nil,nil,DoReturnFrameFromFilterBusStation_To,Application);
//  GlobalFilterBusStationFrame.FrameHistroy:=CurrentFrameHistroy;

end;

end.
