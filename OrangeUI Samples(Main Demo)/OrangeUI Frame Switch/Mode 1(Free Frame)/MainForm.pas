//convert pas to utf8 by ¥

unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,

  {$IFDEF ANDROID}
  Androidapi.Helpers,
  {$ENDIF}
  uFrameContext,

  uUIFunction;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    btnShowMainFrame: TButton;
    btnShowFirstFrame: TButton;
    Button1: TButton;
    procedure btnShowMainFrameClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnShowFirstFrameClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure DoReturnFromFirstFrame(AFromFrame:TFrame);
    { Private declarations }
  public
    { Public declarations }
  end;



var
  frmMain: TfrmMain;

implementation

uses
  MainFrame,
  FirstFrame;

{$R *.fmx}

procedure TfrmMain.btnShowFirstFrameClick(Sender: TObject);
begin


  //先隐藏当前页
//  HideFrame();
  //显示第一页
  ShowFrame(TFrame(GlobalFirstFrame),TFrameFirst,Self,nil,nil,DoReturnFromFirstFrame,Application);

  //调用加载方法
  GlobalFirstFrame.LoadData('Data');

end;

procedure TfrmMain.btnShowMainFrameClick(Sender: TObject);
begin
  //显示主页的时候,不需要动画,因为主页是立即显示的，
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,Self,nil,nil,nil,Application,True,True,ufsefNone);
  //垂直效果
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,Self,nil,nil,nil,Application,True,True,ufsefMoveVert);
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,Self,nil,nil,nil,Application,True,True,ufsefDefault);
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,Self,nil,nil,nil,Application,True,True,ufsefDefaultAndAlpha);
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,Self,nil,nil,nil,Application,True,True,ufsefMoveVertAndAlpha);
  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,Self,nil,nil,nil,Application,True,True,ufsefAlpha);


//  btnShowMainFrame.Visible:=False;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  HideFrame(GlobalMainFrame);
end;

procedure TfrmMain.DoReturnFromFirstFrame(AFromFrame: TFrame);
begin
  if AFromFrame<>nil then
  begin
    if AFromFrame is TFrameFirst then
    begin
      FMX.Types.Log.d('OrangeUI Return From FirstFrame!');
//      ShowMessage('您输入了 '+TFrameFirst(AFromFrame).Edit1.Text);
    end;
  end
  else
  begin
      FMX.Types.Log.d('OrangeUI Return From nil!');
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  GlobalFrameOperManager.FrameSwitchEffectAnimator.Speed:=20;//80;

  btnShowMainFrameClick(nil);
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (Key = vkHardwareBack)
    //Windows下Escape键模拟返回键
    or (Key = vkEscape) then
  begin
    //返回
    if (CurrentFrameHistroy.ToFrame<>nil)
       and (CurrentFrameHistroy.ToFrame<>GlobalMainFrame) then
    begin
      if CanReturnFrame(CurrentFrameHistroy) then
      begin
        //返回上一页
        HideFrame(CurrentFrameHistroy.ToFrame,hfcttBeforeReturnFrame);
        ReturnFrame(CurrentFrameHistroy);

        //表示不关闭APP
        Key:=0;
        KeyChar:=#0;
      end
      else
      begin
        //表示当前Frame不允许返回
      end;
    end
    else
    begin
      {$IFDEF ANDROID}
      //程序退到后台挂起,需要引用Androidapi.Helpers单元
      FMX.Types.Log.d('OrangeUI moveTaskToBack');
      SharedActivity.moveTaskToBack(False);

      //表示不关闭APP
      Key:=0;
      KeyChar:=#0;
      {$ENDIF}
    end;
  end;
end;

end.
