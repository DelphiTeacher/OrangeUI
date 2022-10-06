//convert pas to utf8 by ¥

unit FirstFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation,

  //引用
  uUIFunction,

  FMX.Edit, FMX.WebBrowser;

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
    procedure LoadData(AData:String);
    destructor Destroy;override;
    { Public declarations }
  end;

var
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
  ReturnFrame(Self,
              1,  //默认值为1,表示返回上一页
              True//为True,表示返回之后释放当前页
              );

end;

procedure TFrameFirst.btnShowSecondFrameClick(Sender: TObject);
begin
  //GlobalSecondFrame返回需要释放,先置空
  GlobalSecondFrame:=nil;

  //先隐藏当前页
  HideFrame(Self,hfcttBeforeShowFrame);
  //显示编辑资料页
  ShowFrame(TFrame(GlobalSecondFrame),TFrameSecond,frmMain,nil,nil,nil,Application);


end;

destructor TFrameFirst.Destroy;
begin

  inherited;
end;

procedure TFrameFirst.LoadData(AData: String);
begin
  //加载数据
end;

end.
