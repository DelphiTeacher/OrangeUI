//convert pas to utf8 by ¥

unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  LoginFrame,uUIFunction, uSkinFireMonkeyControl, uSkinFireMonkeyFrameImage,
  uSkinFireMonkeyPanel, uSkinFireMonkeyPageControl,
  uSkinFireMonkeyImage, FMX.Edit, uSkinFireMonkeyEdit, FMX.Objects, FMX.Effects,
  FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.ExtCtrls, FMX.Header,
  FMX.Styles.Switch, FMX.Ani, FMX.Styles, FMX.Styles.Objects,
  uSkinBufferBitmap,
  uComponentType,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  {$ENDIF}
  Math,
  uDrawTextParam,
  uSkinPageControlType, uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyLabel,
  uSkinFireMonkeySwitchPageListPanel, uSkinPanelType;

type
  TfrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormShow(Sender: TObject);
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

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  Self.ClientWidth:=320;
  Self.ClientHeight:=480;
  {$ENDIF}


  //显示登录界面
  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True,False,ufsefNone);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;

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

//  GetGlobalVirtualKeyboardFixer.StartSync(Self);

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
