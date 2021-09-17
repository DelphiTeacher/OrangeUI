program AndroidBarCodeScan;

uses
  System.StartUpCopy,
  FMX.Forms,
  Umain in 'Umain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
