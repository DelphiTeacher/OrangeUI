unit FMX.TKRBarCodeScanner;

//  TTKRBarCodeScanner is an iOS and Android Bar Code Delphi XE5 Component
//  TTKRBarCodeScanner is released under the Mozilla Public License 1.1
//  http://www.mozilla.org/MPL/MPL-1.1.html
//
// The code is heavly based on Jim McKeeth work (TAndroidBarcodeScanner).
// http://cc.embarcadero.com/Download.aspx?id=29699
// For the iOS part it uses the free TMS TTMSFMXZBarReader component
// http://www.tmssoftware.com/site/blog.asp?post=280


interface

uses
  System.Classes,FMX.Platform
  {$IFDEF IOS}
  ,FMX.TMSZBarReader
  {$ENDIF}
  {$IFDEF ANDROID}
  , FMX.Helpers.Android, System.Rtti, FMX.Types, System.SysUtils,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.JavaTypes,  Androidapi.Helpers,
  FMX.StdCtrls, FMX.Edit
  {$ENDIF}
  ;
type
  TTKRBarCodeScannerResult = procedure(Sender: TObject; AResult: String) of object;

type
  [ComponentPlatformsAttribute(pidAndroid or pidiOSDevice or pidiOSDevice64)]
  TTKRBarCodeScanner = class(TComponent)
  public
    type TBarcodeMode = (bmOneD, bmQRCode, bmProduct, bmDataMatrix);
    type TBarcodeModes = set of TBarcodeMode;
  protected
    FOnScanResult: TTKRBarCodeScannerResult;
    FBarcodeModes: TBarcodeModes;
  {$IFDEF IOS}
    FTMSFMXZBarReader: TTMSFMXZBarReader;
  {$ENDIF}
  {$IFDEF ANDROID}
    FClipService: IFMXClipboardService;
    FPreservedClipboardValue: TValue;
    FMonitorClipboard: Boolean;
    const ClipboardCanary = 'waiting';
    const BarcodeModesStrArry: array [bmOneD .. bmDataMatrix] of string =
      ('ONE_D_MODE', 'QR_CODE_MODE', 'PRODUCT_MODE', 'DATA_MATRIX_MODE');
    function HandleAppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
    function GetBarcodeValue(): Boolean;
    procedure CallScan();
    function GetModeString(): string;
  {$ENDIF}
    procedure SetOnScanResult(const Value: TTKRBarCodeScannerResult);
  public
    procedure Scan;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property BarcodeModes: TBarcodeModes read FBarcodeModes write FBarcodeModes;
    property OnScanResult: TTKRBarCodeScannerResult read FOnScanResult write SetOnScanResult;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TKR Bar Code Scanner', [TTKRBarCodeScanner]);
end;

{ TKRBarCodeScanner }

constructor TTKRBarCodeScanner.Create(AOwner: TComponent);
{$IFDEF ANDROID}
var
  aFMXApplicationEventService: IFMXApplicationEventService;
{$ENDIF}
begin
  inherited Create(AOwner);
  {$IFDEF IOS}
  FTMSFMXZBarReader := TTMSFMXZBarReader.Create(AOwner);
  {$ENDIF}
  {$IFDEF ANDROID}
  FMonitorClipboard := False;

  if not TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(FClipService)) then
  begin
    FClipService := nil;
  end;

  if TPlatformServices.Current.SupportsPlatformService(IFMXApplicationEventService, IInterface(aFMXApplicationEventService)) then
  begin
    aFMXApplicationEventService.SetApplicationEventHandler(HandleAppEvent);
  end
  else
  begin
    Log.d('Application Event Service is not supported.');
  end;
  {$ENDIF}
  FBarcodeModes := [bmOneD, bmQRCode, bmProduct, bmDataMatrix];
end;

destructor TTKRBarCodeScanner.Destroy;
begin
  {$IFDEF IOS}
  FTMSFMXZBarReader.Free;
  {$ENDIF}
  {$IFDEF ANDROID}
  {$ENDIF}
  inherited Destroy;
end;

procedure TTKRBarCodeScanner.SetOnScanResult(const Value: TTKRBarCodeScannerResult);
begin
  FOnScanResult := Value;
  {$IFDEF IOS}
  FTMSFMXZBarReader.OnGetResult := FOnScanResult;
  {$ENDIF}
  {$IFDEF ANDROID}
  {$ENDIF}
end;

procedure TTKRBarCodeScanner.Scan;
begin
  {$IFDEF IOS}
  FTMSFMXZBarReader.Show;
  {$ENDIF}
  {$IFDEF ANDROID}
  CallScan;
  {$ENDIF}
end;

{$IFDEF ANDROID}
function TTKRBarCodeScanner.HandleAppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
  Result := False;
  if FMonitorClipboard and (AAppEvent = TApplicationEvent.BecameActive) then
  begin
    Result := GetBarcodeValue;
  end;
end;
{$ENDIF}

{$IFDEF ANDROID}
function TTKRBarCodeScanner.GetBarcodeValue():Boolean;
var
  value: String;
begin
  Result := False;
  FMonitorClipboard := False;
  if (FClipService.GetClipboard.ToString <> ClipboardCanary) then
  begin
    value := FClipService.GetClipboard.ToString;
    if assigned(FOnScanResult) then
      FOnScanResult(Self, FClipService.GetClipboard.ToString);
    FClipService.SetClipboard(FPreservedClipboardValue);
    Result := True;
  end;
end;
{$ENDIF}

{$IFDEF ANDROID}
procedure TTKRBarCodeScanner.CallScan();
var
  intent: JIntent;
  aScanCmd: string;
begin
  if Assigned(FClipService) then
  begin
    FPreservedClipboardValue := FClipService.GetClipboard;
    FMonitorClipboard := True;
    FClipService.SetClipboard(ClipboardCanary);
    intent := tjintent.Create;
    intent.setAction(stringtojstring('com.google.zxing.client.android.SCAN'));
    aScanCmd := GetModeString;
    intent.putExtra(tjintent.JavaClass.EXTRA_TEXT, stringtojstring(aScanCmd));
    sharedactivity.startActivityForResult(intent, 0);
  end;
end;
{$ENDIF}

{$IFDEF ANDROID}
function TTKRBarCodeScanner.GetModeString(): string;
var
  mode: TBarcodeMode;
  aBarcodeModes: TBarcodeModes;
begin
  Result := '';
  if FBarcodeModes = [] then
  begin
    aBarcodeModes := [bmOneD,bmQRCode,bmProduct,bmDataMatrix];
  end
  else
  begin
    aBarcodeModes := FBarcodeModes;
  end;

  for mode in FBarcodeModes do
  begin
    Result := Result + ',' + BarcodeModesStrArry[mode];
  end;
  Result := StringReplace(Result, ',', '"SCAN_MODE","', []) + '"';
end;
{$ENDIF}

end.
