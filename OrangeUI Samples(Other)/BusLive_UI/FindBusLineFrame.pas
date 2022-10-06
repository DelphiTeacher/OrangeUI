//convert pas to utf8 by ¥
unit FindBusLineFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  BusLiveCommonSkinMaterialModule,
  uSkinItems,
  uUIFunction,
  BusLineFrame,
  FilterBusLineFrame,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyLabel, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uDrawPicture, uSkinImageList, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uSkinLabelType, uSkinPanelType, uDrawCanvas;

type
  TFrameFindBusLine = class(TFrame)
    pnlTop: TSkinFMXPanel;
    lblFind: TSkinFMXLabel;
    lbHistroy: TSkinFMXListBox;
    btnClearHistroy: TSkinFMXButton;
    edtKeyword: TSkinFMXEdit;
    btnGO: TSkinFMXButton;
    lblHistroyHint: TSkinFMXLabel;
    procedure lbHistroyClickItem(Sender: TSkinItem);
    procedure btnClearHistroyClick(Sender: TObject);
    procedure edtKeywordClick(Sender: TObject);
    procedure btnGOClick(Sender: TObject);
  private
    procedure DoReturnFrameFromFilterBusLine(Frame:TFrame);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalFindBusLineFrame:TFrameFindBusLine;

implementation

uses
  MainForm,
  GoWhereFrame;

{$R *.fmx}

procedure TFrameFindBusLine.btnClearHistroyClick(Sender: TObject);
begin
  Self.lbHistroy.Properties.Items.Clear(True);
end;

procedure TFrameFindBusLine.btnGOClick(Sender: TObject);
begin
  //查看线路
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalBusLineFrame),TFrameBusLine,frmMain,nil,nil,nil,Application);
//  GlobalBusLineFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameFindBusLine.DoReturnFrameFromFilterBusLine(Frame: TFrame);
begin
  Self.edtKeyword.Text:=GlobalFilterBusLineFrame.edtKeyword.Text;
end;

procedure TFrameFindBusLine.edtKeywordClick(Sender: TObject);
begin
  HideFrame;//(GlobalGoWhereFrame);
  ShowFrame(TFrame(GlobalFilterBusLineFrame),TFrameFilterBusLine,frmMain,nil,nil,DoReturnFrameFromFilterBusLine,Application);
//  GlobalFilterBusLineFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalFilterBusLineFrame.LoadData(Self.edtKeyword.Text);
end;

procedure TFrameFindBusLine.lbHistroyClickItem(Sender: TSkinItem);
begin
  Self.edtKeyword.Text:=TSkinItem(Sender).Caption;
end;

end.
