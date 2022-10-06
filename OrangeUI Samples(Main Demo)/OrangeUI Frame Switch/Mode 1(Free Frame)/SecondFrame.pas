//convert pas to utf8 by ¥

unit SecondFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  //引用uUIFunction
  uUIFunction,

  FMX.Objects, FMX.Edit, FMX.Controls.Presentation, FMX.WebBrowser;

type
  TFrameSecond = class(TFrame)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Panel2: TPanel;
    Panel1: TPanel;
    btnReturn: TButton;
    Text1: TText;
    btnReturnMainFrame: TButton;
    procedure btnReturnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnReturnMainFrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    destructor Destroy;override;
    { Public declarations }
  end;


var
  GlobalSecondFrame:TFrameSecond;

implementation

{$R *.fmx}

uses
  MainForm,
  FirstFrame;


procedure TFrameSecond.btnReturnClick(Sender: TObject);
begin
  //先隐藏自己
  HideFrame(Self,hfcttBeforeReturnFrame);
  //再返回上一页
  ReturnFrame(Self,
              1,    //默认值为1,表示返回上一页
              True  //为True,表示返回之后释放当前页
              );

end;

procedure TFrameSecond.btnReturnMainFrameClick(Sender: TObject);
begin
  //先隐藏自己
  HideFrame(Self,hfcttBeforeReturnFrame);
  //再返回上一页
  ReturnFrame(Self,
              2,    //默认值为1,表示返回上一页
              True  //为True,表示返回之后释放当前页
              );

end;

procedure TFrameSecond.Button1Click(Sender: TObject);
begin
  //GlobalFirstFrame返回需要释放,先置空
  GlobalFirstFrame:=nil;


  //先隐藏当前页
  HideFrame(Self,hfcttBeforeShowFrame);
  //显示第一页
  ShowFrame(TFrame(GlobalFirstFrame),TFrameFirst,frmMain,nil,nil,nil,Application);


end;

destructor TFrameSecond.Destroy;
begin

  inherited;
end;

end.
