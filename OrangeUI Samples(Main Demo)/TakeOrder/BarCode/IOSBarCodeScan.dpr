program IOSBarCodeScan;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  FMX.TKRBarCodeScanner in 'FMX.TKRBarCodeScanner.pas',
  FMX.TMSZBarReader in 'FMX.TMSZBarReader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
