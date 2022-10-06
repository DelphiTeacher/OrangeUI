//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction, FMX.Controls.Presentation, uFrameContext;

type
  TFrameMain = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    btnShowSecondFrame: TButton;
    Panel2: TPanel;
    FrameContext1: TFrameContext;
    procedure btnShowSecondFrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
    procedure DoReturnFromFirstFrame(AFromFrame:TFrame);
    { Public declarations }
  end;

var
  GlobalMainFrame:TFrameMain;

implementation

uses
  MainForm,
  SecondFrame;

{$R *.fmx}

procedure TFrameMain.btnShowSecondFrameClick(Sender: TObject);
var
  ASecondFrame:TFrameSecond;
begin
  //先隐藏当前页
  HideFrame(Self,hfcttBeforeShowFrame);
  //显示第二页
  ASecondFrame:=nil;
  ShowFrame(TFrame(ASecondFrame),TFrameSecond,frmMain,nil,nil,DoReturnFromFirstFrame,Application);

end;

procedure TFrameMain.DoReturnFromFirstFrame(AFromFrame: TFrame);
begin
  if AFromFrame<>nil then
  begin

    if AFromFrame is TFrameSecond then
    begin
      FMX.Types.Log.d('OrangeUI Return From SecondFrame!');
    end;
  end
  else
  begin
      FMX.Types.Log.d('OrangeUI Return From nil!');
  end;
end;

end.
