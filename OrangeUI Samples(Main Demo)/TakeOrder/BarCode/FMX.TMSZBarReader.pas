unit FMX.TMSZBarReader;

interface

uses
  Classes
  {$IFDEF IOS}
  ,MacApi.ObjectiveC
  ,iOSApi.CocoaTypes
  ,iOSApi.Foundation
  ,iOSApi.UIKit
  ,iOSApi.QuartzCore
  ,iOSApi.CoreMedia
  ,iOSApi.CoreVideo
  ,iOSApi.AVFoundation
  ,Macapi.Helpers
  {$ENDIF}
  ;

type
  TTMSFMXZBarReader = class;

  {$IFDEF IOS}
  zbar_symbol_type_t = Cardinal;
  zbar_config_t = Cardinal;
  zbar_symbol_s = Pointer;
  zbar_symbol_set_s = Pointer;
  zbar_symbol_t = zbar_symbol_s;
  zbar_symbol_set_t = zbar_symbol_set_s;

  ZBarSymbolClass = interface(NSObjectClass)
  ['{35FAE888-4088-4C6D-8564-E65E728653E4}']
  end;

  ZBarSymbol = interface(NSObject)
  ['{D5B645FC-1CF7-4966-BA44-17787FADD524}']
    function data: NSString; cdecl;
    function initWithSymbol(symbol: zbar_symbol_t): Pointer; cdecl;
  end;
  TZBarSymbol = class(TOCGenericImport<ZBarSymbolClass, ZBarSymbol>) end;

  ZBarSymbolSetClass = interface(NSObjectClass)
  ['{A285BD5D-32AD-43F9-BA75-3F002DF4D7B2}']
  end;

  ZBarSymbolSet = interface(NSObject)
  ['{1A6960EA-B523-4057-81F6-0DB227FA8CA5}']
  function count: Integer; cdecl;
  function zbarSymbolSet: Pointer; cdecl;
  end;
  TZBarSymbolSet = class(TOCGenericImport<ZBarSymbolSetClass, ZBarSymbolSet>) end;


  ZBarReaderDelegate = interface(IObjectiveC)
    ['{2B97F7C6-8FA8-4BC3-B8B1-EB913D0A8F77}']
    procedure imagePickerController(reader: UIImagePickerController; didFinishPickingMediaWithInfo: NSDictionary); cdecl;
  end;

  TZBarReaderDelegate = class(TOCLocal, ZBarReaderDelegate)
  private
    FZBarReader: TTMSFMXZBarReader;
  public
    procedure imagePickerController(reader: UIImagePickerController; didFinishPickingMediaWithInfo: NSDictionary); cdecl;
  end;

  ZBarImageScannerClass = interface(NSObjectClass)
    ['{A162FBBE-1BC8-451F-B783-302BDDF4E58B}']
  end;

  ZBarImageScanner = interface(NSObject)
    ['{779D918F-9CCF-4E4B-AA8E-C0461D3B6060}']
    procedure setSymbology(symbology: zbar_symbol_type_t; config: zbar_config_t; _to: NSInteger); cdecl;
  end;
  TZBarImageScanner = class(TOCGenericImport<ZBarImageScannerClass, ZBarImageScanner>) end;

  ZBarReaderViewControllerClass = interface(UIViewControllerClass)
  ['{A23DB840-F5FE-44FF-B80E-FA251FFE78B7}']
  end;
  ZBarReaderViewController = interface(UIViewController)
  ['{B9431ED6-C67D-46D8-ABB7-7CCAB9DB8703}']
     procedure setReaderDelegate(newValue: Pointer); cdecl;
     function readerDelegate: Pointer; cdecl;
     procedure setSupportedOrientationsMask(supportedOrientationsMask: NSUInteger); cdecl;
     function scanner: ZBarImageScanner; cdecl;
     procedure start; cdecl;
     procedure stop; cdecl;
   end;
  TZBarReaderViewController = class(TOCGenericImport<ZBarReaderViewControllerClass, ZBarReaderViewController>) end;
  {$ENDIF}

  TTMSFMXZBarReaderGetResult = procedure(Sender: TObject; AResult: String) of object;

  [ComponentPlatformsAttribute(pidiOSDevice or pidiOSDevice64)]
  TTMSFMXZBarReader = class(TComponent)
  private
    FOnGetResult: TTMSFMXZBarReaderGetResult;
    {$IFDEF IOS}
    FZBarReaderDelegate: TZBarReaderDelegate;
    FZBarReaderViewController: ZBarReaderViewController;
    {$ENDIF}
  public
    procedure Show;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnGetResult: TTMSFMXZBarReaderGetResult read FOnGetResult write FOnGetResult;
  end;


{$IFDEF IOS}
{$IFNDEF CPUX86}
{$O-}
function lzld: ZBarReaderViewController; cdecl; external '..\BarCode\ZBarSDK\libzbar.a' name 'OBJC_CLASS_$_ZBarReaderViewController';
{$O+}
function zbar_symbol_set_first_symbol(symbols : zbar_symbol_set_t): zbar_symbol_t; cdecl; external '..\BarCode\ZBarSDK\libzbar.a' name 'zbar_symbol_set_first_symbol';
{$ENDIF}
{$ENDIF}

implementation

{$IFDEF IOS}
function GetSharedApplication: UIApplication;
begin
  Result := TUIApplication.Wrap(TUIApplication.OCClass.sharedApplication);
end;
{$ENDIF}

{ TTMSFMXZBarReader }

constructor TTMSFMXZBarReader.Create(AOwner: TComponent);
begin
  inherited;
  {$IFDEF IOS}
  FZBarReaderDelegate := TZBarReaderDelegate.Create;
  FZBarReaderDelegate.FZBarReader := Self;
  FZBarReaderViewController := TZBarReaderViewController.Wrap(TZBarReaderViewController.Wrap(TZBarReaderViewController.OCClass.alloc).init);
  FZBarReaderViewController.setReaderDelegate(FZBarReaderDelegate.GetObjectID);
  FZBarReaderViewController.setSupportedOrientationsMask(UIInterfaceOrientationMaskAll);
  {$ENDIF}
end;

destructor TTMSFMXZBarReader.Destroy;
begin
  {$IFDEF IOS}
  if Assigned(FZBarReaderDelegate) then
  begin
    FZBarReaderDelegate.Free;
    FZBarReaderDelegate := nil;
  end;
  if Assigned(FZBarReaderViewController) then
  begin
    FZBarReaderViewController.release;
    FZBarReaderViewController := nil;
  end;
  {$ENDIF}
  inherited;
end;

procedure TTMSFMXZBarReader.Show;
{$IFDEF IOS}
var
  app: UIApplication;
{$ENDIF}
begin
  {$IFDEF IOS}
  app := GetSharedApplication;
  if Assigned(app) and Assigned(app.keyWindow) then
    app.keyWindow.rootViewController.presentModalViewController(FZBarReaderViewController, True);
  {$ENDIF}
end;

{$IFDEF IOS}

{ TZBarReaderDelegate }

procedure TZBarReaderDelegate.imagePickerController(
  reader: UIImagePickerController; didFinishPickingMediaWithInfo: NSDictionary);
var
  val: ZBarSymbolSet;
  symbol: ZBarSymbol;
  sym : zbar_symbol_t;
  res: NSString;
begin
  val := TZBarSymbolSet.Wrap(didFinishPickingMediaWithInfo.objectForKey((strtonsstr('ZBarReaderControllerResults') as ILocalObject).GetObjectID));
  {$IFNDEF CPUX86}
  sym := zbar_symbol_set_first_symbol(val.zbarSymbolSet);
  {$ENDIF}
  symbol := TZBarSymbol.Wrap(TZBarSymbol.Wrap(TZBarSymbol.OCClass.alloc).initWithSymbol(sym));
  res := symbol.data;
  symbol.release;
  symbol := nil;

  if Assigned(FZBarReader.OnGetResult) then
    FZBarReader.OnGetResult(FZBarReader, UTF8ToString(res.UTF8String));

  if not FZBarReader.FZBarReaderViewController.isBeingDismissed then
    FZBarReader.FZBarReaderViewController.dismissModalViewControllerAnimated(True);
end;

{$ENDIf}

end.
