//convert pas to utf8 by ¥

unit ThirdFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  uFrameContext, FMX.Controls.Presentation, FMX.Edit;

type
  TFrameThird = class(TFrame)
    FrameContext1: TFrameContext;
    Panel1: TPanel;
    btnReturn: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Panel2: TPanel;
    btnReturnMainFrame: TButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnReturnMainFrameClick(Sender: TObject);
  private
    { Private declarations }
  public
    destructor Destroy;override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameThird.btnReturnClick(Sender: TObject);
begin
  //返回前先隐藏
  HideFrame(Self,
            hfcttBeforeReturnFrame, //表示当前返回
            ufsefDefault            //隐藏的效果

            );
  //返回
  ReturnFrame(FrameContext1.FrameHistory,
              1,
              True  //返回后需要释放
              );

end;

procedure TFrameThird.btnReturnMainFrameClick(Sender: TObject);
begin
  //返回前先隐藏
  HideFrame(Self,
            hfcttBeforeReturnFrame, //表示当前返回
            ufsefDefault            //有切换效果
            );
  //返回
  ReturnFrame(FrameContext1.FrameHistory,
              2,
              True  //返回后需要释放
              );

end;

destructor TFrameThird.Destroy;
begin
  FMX.Types.Log.d('OrangeUI TFrameThird.Destroy');

  inherited;
end;

end.
