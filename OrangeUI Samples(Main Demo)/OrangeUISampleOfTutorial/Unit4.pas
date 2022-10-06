unit Unit4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  DateUtils,
  uUIFunction,
  SelectMonthFrame,
  MainFrame,
  uSkinItems,

  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm4 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    //月份选择框返回
    procedure DoReturnFromSelectMonthFrame(ASelectMonthFrame:TFrame);
    procedure lbDemosClickItem(Sender: TSkinItem);
    { Public declarations }
  end;

var
  Form4: TForm4;
  GlobalMainFrame2:TFrameMain;

implementation

{$R *.fmx}


procedure TForm4.Button1Click(Sender: TObject);
begin
//  ShowFrame(TFrame(GlobalMainFrame2),TFrameMain,Self,nil,nil,nil,Application);
//  GlobalMainFrame2.lbDemos.OnClickItem:=lbDemosClickItem;

  //OK
  //选择月份
  ShowFrame(TFrame(GlobalSelectMonthFrame),TFrameSelectMonth,Self,nil,nil,DoReturnFromSelectMonthFrame,Application,True,True,ufsefNone);
  GlobalSelectMonthFrame.Init(2010,YearOf(Now),Now);
end;

procedure TForm4.DoReturnFromSelectMonthFrame(ASelectMonthFrame: TFrame);
begin
  ShowMessage('您选择的是 '+FormatDateTime('YYYY年MM月',TFrameSelectMonth(ASelectMonthFrame).GetMonth));

end;

procedure TForm4.lbDemosClickItem(Sender: TSkinItem);
begin
  //OK
  //选择月份
  ShowFrame(TFrame(GlobalSelectMonthFrame),TFrameSelectMonth,GlobalMainFrame2,nil,nil,DoReturnFromSelectMonthFrame,Application,True,True,ufsefNone);
  GlobalSelectMonthFrame.Init(2010,YearOf(Now),Now);

end;

end.
