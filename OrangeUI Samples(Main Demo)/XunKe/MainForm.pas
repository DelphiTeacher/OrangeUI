//convert pas to utf8 by ¥

unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  uBaseLog,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  {$ENDIF}
  uUIFunction,
  uDrawCanvas,
  LoginFrame,
  MainFrame, uSkinFireMonkeyControl, uSkinFireMonkeyImage, FMX.Objects,
  uSkinFireMonkeyRoundRect, uSkinFireMonkeyPanel;

type
  TfrmMain = class(TForm)
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
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

{$R *.fmx}

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (Key = vkHardwareBack)
    //Windows下Escape键模拟返回键
    or (Key = vkEscape) then
  begin
    //返回
    if (CurrentFrameHistroy.ToFrame<>nil)
       and (CurrentFrameHistroy.ToFrame<>GlobalMainFrame)
       and (CurrentFrameHistroy.ToFrame<>GlobalLoginFrame)
       then
    begin
      if CanReturnFrame(CurrentFrameHistroy) then
      begin
        HideFrame;////(CurrentFrameHistroy.ToFrame,hfcttBeforeReturnFrame);
        ReturnFrame;//(CurrentFrameHistroy);

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

procedure TfrmMain.FormShow(Sender: TObject);
begin

  //修复Android下的虚拟键盘隐藏和显示
//  GetGlobalVirtualKeyboardFixer.StartSync(Self);


  //显示登陆界面
  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  uBaseLog.OutputDebugString('FormVirtualKeyboardHidden');
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  uBaseLog.OutputDebugString('FormVirtualKeyboardShown');
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);
end;

end.
