//convert pas to utf8 by ¥
unit ScanWifiFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  uUIFunction,
  uSkinItems,
  uFrameContext,
  uFuncCommon,
  FMX.TKRBarCodeScanner,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyButton,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel,
  FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinButtonType, uSkinPanelType;

type
  TFrameScanWifi = class(TFrame,IFrameHistroyVisibleEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    memScanReturnCode: TSkinFMXMemo;
    btnScan: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
  private
    TKRBarCodeScanner1: TTKRBarCodeScanner;
    procedure DoShow;
    procedure DoHide;
    procedure TKRBarCodeScanner1ScanResult(Sender: TObject; AResult: string);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalScanWifiFrame:TFrameScanWifi;

implementation

{$R *.fmx}

procedure TFrameScanWifi.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameScanWifi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

procedure TFrameScanWifi.DoHide;
begin
  FreeAndNil(TKRBarCodeScanner1);
end;

procedure TFrameScanWifi.DoShow;
begin
  if TKRBarCodeScanner1=nil then
  begin
    TKRBarCodeScanner1:=TTKRBarCodeScanner.Create(Self);
    TKRBarCodeScanner1.OnScanResult:=TKRBarCodeScanner1ScanResult;
  end;
  TKRBarCodeScanner1.Scan;
end;

procedure TFrameScanWifi.btnScanClick(Sender: TObject);
begin
  DoShow;
end;

procedure TFrameScanWifi.TKRBarCodeScanner1ScanResult(Sender: TObject;AResult: string);
begin
  Self.memScanReturnCode.Text:=AResult;
end;

end.
