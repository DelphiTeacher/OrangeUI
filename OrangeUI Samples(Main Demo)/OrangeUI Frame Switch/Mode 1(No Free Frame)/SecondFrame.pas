//convert pas to utf8 by ¥

unit SecondFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  //引用uUIFunction
  uUIFunction,

  FMX.Objects, FMX.Edit, FMX.Controls.Presentation;

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
    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  //声明全局的Frame
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
  ReturnFrame(Self.FrameHistroy,
              1,    //默认值为1,表示返回上一页
              False //默认值为False,表示不释放
              );

end;

procedure TFrameSecond.btnReturnMainFrameClick(Sender: TObject);
begin
  //先隐藏自己
  HideFrame(Self,hfcttBeforeReturnFrame);
  //再返回前两页
  ReturnFrame(Self.FrameHistroy,
              2,    //返回前两页
              False //默认值为False,表示不释放
              );

end;

procedure TFrameSecond.Button1Click(Sender: TObject);
begin
  //GlobalFirstFrame不释放,不需要重新创建


  //先隐藏当前页
  HideFrame(Self,hfcttBeforeShowFrame);
  //显示第一页
  ShowFrame(TFrame(GlobalFirstFrame),TFrameFirst,frmMain,nil,nil,nil,Application);
  //记录页面切换的上下文
  GlobalFirstFrame.FrameHistroy:=CurrentFrameHistroy;


end;

end.
