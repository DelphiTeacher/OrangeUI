unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  TestChartFrame,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSkinWindowsControl,
  uSkinVirtualChartType, Vcl.StdCtrls;

type
  TForm5 = class(TForm)
    SkinWinVirtualChart1: TSkinWinVirtualChart;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
  SkinWinVirtualChart1.Prop.SeriesList[0].ChartType:=sctPie;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  SkinWinVirtualChart1.Prop.SeriesList[0].ChartType:=sctLine;
end;

procedure TForm5.FormCreate(Sender: TObject);
var
  ATestChartFrame:TFrameTestChart;
begin
//  Self.FCustomerInfoFrame.Load;

//  Self.lbSubMenu.Prop.Items.FindItemByName('dashboard_analyse').Selected:=True;
//  Self.lbSubMenuClickItem(Self.lbSubMenu.Prop.Items.FindItemByName('dashboard_analyse'));


//  ATestChartFrame:=TFrameTestChart.Create(Self);
//  ATestChartFrame.Parent:=Self;

end;

end.
