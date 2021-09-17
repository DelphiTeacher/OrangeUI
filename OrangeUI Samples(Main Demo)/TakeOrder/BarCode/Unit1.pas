unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TKRBarCodeScanner, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.StdCtrls;

type
  TForm1 = class(TForm)
    ButtonScan: TButton;
    MemoScanResult: TMemo;
    procedure ButtonScanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    TKRBarCodeScanner: TTKRBarCodeScanner;
    procedure TKRBarCodeScannerScanResult(Sender: TObject; AResult: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.ButtonScanClick(Sender: TObject);
begin
  TKRBarCodeScanner.Scan;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TKRBarCodeScanner:=TTKRBarCodeScanner.Create(Self);
  TKRBarCodeScanner.OnScanResult:=TKRBarCodeScannerScanResult;
end;

procedure TForm1.TKRBarCodeScannerScanResult(Sender: TObject; AResult: string);
begin
  MemoScanResult.Text := AResult;
end;

end.
