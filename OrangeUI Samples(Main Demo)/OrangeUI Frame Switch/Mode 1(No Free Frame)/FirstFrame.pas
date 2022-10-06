//convert pas to utf8 by ¥

unit FirstFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation,

  //引用
  uUIFunction,

  FMX.Edit;

type
  TFrameFirst = class(TFrame)
    Panel1: TPanel;
    btnReturn: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Panel2: TPanel;
    btnShowSecondFrame: TButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnShowSecondFrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
    procedure LoadData(AData:String);
    { Public declarations }
  end;

var
  //声明全局的Frame
  GlobalFirstFrame:TFrameFirst;

implementation

{$R *.fmx}


uses
  MainForm,
  SecondFrame;


procedure TFrameFirst.btnReturnClick(Sender: TObject);
begin
  //先隐藏自己
  HideFrame(Self,hfcttBeforeReturnFrame);
  //再返回上一页
  ReturnFrame(Self.FrameHistroy,
              1,    //默认值为1,表示返回上一页
              False //默认值为False,表示不释放
              );

end;

procedure TFrameFirst.btnShowSecondFrameClick(Sender: TObject);
begin
  //GlobalSecondFrame,不需要重新创建

  //先隐藏当前页
  HideFrame(Self,hfcttBeforeShowFrame);
  //显示编辑资料页
  ShowFrame(TFrame(GlobalSecondFrame),TFrameSecond,frmMain,nil,nil,nil,Application);
  //记录页面切换的上下文
  GlobalSecondFrame.FrameHistroy:=CurrentFrameHistroy;


end;

procedure TFrameFirst.LoadData(AData: String);
begin
  //加载数据
end;

end.
