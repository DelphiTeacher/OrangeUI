//convert pas to utf8 by ¥

unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,


  uUIFunction,
  uComponentType,
  uFrameContext,


  {$IFDEF ANDROID}
  Androidapi.Helpers,
  {$ENDIF}


  FMX.ExtCtrls,
  FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinPanelType,
  FMX.Controls.Presentation, FMX.Layouts;




type
  TfrmMain = class(TForm)
    pnlVirtualKeyBoard: TSkinFMXPanel;
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    { Private declarations }
  public
    { Public declarations }
  end;




var
  frmMain: TfrmMain;



implementation

{$R *.fmx}

uses
  MainFrame;


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
       then
    begin
      if CanReturnFrame(CurrentFrameHistroy)=TFrameReturnActionType.fratDefault then
      begin
        HideFrame;//(CurrentFrameHistroy.ToFrame);
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
var
  AFrame:TFrame;
begin



  //在Windows平台下的模拟虚拟键盘控件
  SimulateWindowsVirtualKeyboardHeight:=160;
  IsSimulateVirtualKeyboardOnWindows:=True;
  GlobalAutoProcessVirtualKeyboardControlClass:=TSkinFMXPanel;
  GlobalAutoProcessVirtualKeyboardControl:=pnlVirtualKeyBoard;
  GlobalAutoProcessVirtualKeyboardControl.Visible:=False;


  {$IFNDEF MSWINDOWS}
  pnlVirtualKeyBoard.SelfOwnMaterialToDefault.IsTransparent:=True;
  pnlVirtualKeyBoard.Caption:='';
  {$ENDIF}




//  GetGlobalVirtualKeyboardFixer.StartSync(Self);


  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,frmMain,True,True,ufsefNone);


end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);
end;

end.

