//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TFrameMain = class(TFrame)
    Panel1: TPanel;
    btnShowFirstFrame: TButton;
    Label1: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    procedure btnShowFirstFrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DoReturnFromFirstFrame(AFromFrame:TFrame);
    { Public declarations }
  end;




var
  GlobalMainFrame:TFrameMain;

implementation

uses
  MainForm,
  FirstFrame;

{$R *.fmx}

procedure TFrameMain.btnShowFirstFrameClick(Sender: TObject);
begin

  //GlobalFirstFrame返回需要释放,所以先置空
  GlobalFirstFrame:=nil;

  //先隐藏当前页
  HideFrameBeforeShow(Self);
  //显示第一页
  ShowFrame(TFrame(GlobalFirstFrame),TFrameFirst,frmMain,nil,nil,DoReturnFromFirstFrame,Application);

  //调用加载方法
  GlobalFirstFrame.LoadData('我是ShowFrame时传入的字符串');
end;

procedure TFrameMain.DoReturnFromFirstFrame(AFromFrame: TFrame);
begin
  if AFromFrame<>nil then
  begin
    if AFromFrame is TFrameFirst then
    begin
      FMX.Types.Log.d('OrangeUI Return From FirstFrame!');
      Self.Memo1.Lines.Add('您输入了 '+TFrameFirst(AFromFrame).edtData.Text);
    end;
  end
  else
  begin
      FMX.Types.Log.d('OrangeUI Return From nil!');
  end;
end;

end.
