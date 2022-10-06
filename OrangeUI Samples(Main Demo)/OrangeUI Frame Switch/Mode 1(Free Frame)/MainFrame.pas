//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.Memo.Types;

type
  TFrameMain = class(TFrame)
    Panel1: TPanel;
    btnShowFirstFrame: TButton;
    Label1: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    procedure btnShowFirstFrameClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  FirstFrame,
  SecondFrame;

{$R *.fmx}

procedure TFrameMain.btnShowFirstFrameClick(Sender: TObject);
begin

  //GlobalFirstFrame返回需要释放,先置空
  GlobalFirstFrame:=nil;

  //先隐藏当前页
  HideFrame(Self,hfcttBeforeShowFrame,TUseFrameSwitchEffectType.ufsefAlpha);
  //显示第一页
  ShowFrame(TFrame(GlobalFirstFrame),TFrameFirst,frmMain,nil,nil,DoReturnFromFirstFrame,Application);

  //调用加载方法
  GlobalFirstFrame.LoadData('Data');
end;

procedure TFrameMain.Button1Click(Sender: TObject);
begin
  HideFrame(Self);
  //显示第一页
  ShowFrame(TFrame(GlobalFirstFrame),TFrameFirst,frmMain,nil,nil,DoReturnFromFirstFrame,Application);

  HideFrame(GlobalFirstFrame);
  //显示编辑资料页
  ShowFrame(TFrame(GlobalSecondFrame),TFrameSecond,frmMain,nil,nil,nil,Application);

end;

procedure TFrameMain.DoReturnFromFirstFrame(AFromFrame: TFrame);
begin
  if AFromFrame<>nil then
  begin
    if AFromFrame is TFrameFirst then
    begin
      FMX.Types.Log.d('OrangeUI Return From FirstFrame!');
      Self.Memo1.Lines.Add('您输入了 '+TFrameFirst(AFromFrame).Edit1.Text);
    end;
  end
  else
  begin
      FMX.Types.Log.d('OrangeUI Return From nil!');
  end;
end;

end.
