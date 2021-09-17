//convert pas to utf8 by ¥

unit MobileMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox,
  MobileMainFrame,
  MobileLoginFrame,
  MobileAuthFrame,
  uSinaWeiboManager,
  uTimerTask,
  uUIFunction,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel,
  uSkinFireMonkeyImage,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox,
  uSkinFireMonkeyButton;

type
  TfrmMobileMain = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure ShowMainFrame;
    { Public declarations }
  end;

var
  frmMobileMain: TfrmMobileMain;

implementation

{$R *.fmx}

procedure TfrmMobileMain.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack)
    //Windows下Escape键模拟返回键
    or (Key = vkEscape) then
  begin
    //返回
    if (CurrentFrameHistroy.ToFrame<>nil)
       and (CurrentFrameHistroy.ToFrame<>GlobalMobileMainFrame)
       and (CurrentFrameHistroy.ToFrame<>GlobalMobileLoginFrame)
       then
    begin
      if CanReturnFrame(CurrentFrameHistroy) then
      begin
        HideFrame(CurrentFrameHistroy.ToFrame,hfcttBeforeReturnFrame);
        ReturnFrame(CurrentFrameHistroy);

        Key:=0;
        KeyChar:=#0;
      end;
    end;
  end;
end;

procedure TfrmMobileMain.FormShow(Sender: TObject);
begin

  //登录
  ShowFrame(TFrame(GlobalMobileLoginFrame),TFrameMobileLogin,Self,nil,nil,nil,Application,True,True,ufsefNone);
  GlobalMobileLoginFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TfrmMobileMain.ShowMainFrame;
begin
  //显示主界面
  ShowFrame(TFrame(GlobalMobileMainFrame),TFrameMobileMain,Self,nil,nil,nil,Application);
  GlobalMobileMainFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalMobileMainFrame.Show;
end;

end.
