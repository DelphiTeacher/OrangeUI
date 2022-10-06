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

  uUIFunction;

type
  TfrmMain = class(TForm)
    btnShowMainFrame: TButton;
    procedure btnShowMainFrameClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  MainFrame;

{$R *.fmx}

procedure TfrmMain.btnShowMainFrameClick(Sender: TObject);
begin
  //显示主页的时候,不需要动画,因为主页是立即显示的，
  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application,True,True,ufsefNone);

  btnShowMainFrame.Visible:=False;
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
