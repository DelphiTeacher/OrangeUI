//convert pas to utf8 by ¥

unit SecondFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uFrameContext, FMX.ScrollBox, FMX.Memo,

  uUIFunction;

type
  TFrameSecond = class(TFrame)
    Panel1: TPanel;
    btnReturn: TButton;
    Label1: TLabel;
    FrameContext1: TFrameContext;
    Memo1: TMemo;
    btnShowThirdFrame: TButton;
    Panel2: TPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure FrameContext1Create(Sender: TObject);
    procedure FrameContext1Hide(Sender: TObject);
    procedure FrameContext1Show(Sender: TObject);
    procedure FrameContext1CanReturn(Sender: TObject;
      var AIsCanReturn: Boolean);
    procedure FrameContext1Destroy(Sender: TObject);
    procedure FrameContext1ReturnFrom(Sender: TObject; AFromFrame: TFrame);
    procedure btnShowThirdFrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    destructor Destroy;override;
    { Public declarations }
  end;


implementation

uses
  MainForm,
  ThirdFrame;

{$R *.fmx}

procedure TFrameSecond.btnReturnClick(Sender: TObject);
begin
  //返回前先隐藏
  HideFrame(Self,
            hfcttBeforeReturnFrame,//表示当前返回
            ufsefDefault //隐藏的效果

            );
  //返回
  ReturnFrame(FrameContext1.FrameHistory,
              1,
              True//返回后需要释放
              );

end;

procedure TFrameSecond.btnShowThirdFrameClick(Sender: TObject);
var
  AThirdFrame:TFrameThird;
begin
  //先隐藏当前页
  HideFrame(Self,hfcttBeforeShowFrame);
  //显示第三页
  AThirdFrame:=nil;
  ShowFrame(TFrame(AThirdFrame),TFrameThird,frmMain,nil,nil,nil,Application);

end;

destructor TFrameSecond.Destroy;
begin
  FMX.Types.Log.d('OrangeUI TFrameSecond.Destroy');
  inherited;
end;

procedure TFrameSecond.FrameContext1CanReturn(Sender: TObject;
  var AIsCanReturn: Boolean);
begin
  FMX.Types.Log.d('OrangeUI Frame CanReturn');
end;

procedure TFrameSecond.FrameContext1Create(Sender: TObject);
begin
  FMX.Types.Log.d('OrangeUI Frame Create');
  Memo1.Lines.Add('Frame Create');
end;

procedure TFrameSecond.FrameContext1Destroy(Sender: TObject);
begin
  FMX.Types.Log.d('OrangeUI Frame Destroy');
end;

procedure TFrameSecond.FrameContext1Hide(Sender: TObject);
begin
  FMX.Types.Log.d('OrangeUI Frame Hide');
  Memo1.Lines.Add('Frame Hide');
end;

procedure TFrameSecond.FrameContext1ReturnFrom(Sender: TObject;
  AFromFrame: TFrame);
begin
  FMX.Types.Log.d('OrangeUI Frame ReturnFrom '+AFromFrame.ClassName);
  Memo1.Lines.Add('Frame ReturnFrom '+AFromFrame.ClassName);
  Memo1.Lines.Add('Value '+TFrameThird(AFromFrame).Edit1.Text);

end;

procedure TFrameSecond.FrameContext1Show(Sender: TObject);
begin
  FMX.Types.Log.d('OrangeUI Frame Show');
  Memo1.Lines.Add('Frame Show');

end;

end.
