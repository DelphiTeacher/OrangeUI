//convert pas to utf8 by ¥

//convert pas to utf8 by ¥
unit ResetPasswordFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  WaitingFrame,
  MessageBoxFrame,

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,
  ClientModuleUnit1,
  FriendCircleCommonMaterialDataMoudle,

  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameResetPassword = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    SkinFMXPanel6: TSkinFMXPanel;
    SkinFMXPanel7: TSkinFMXPanel;
    edtPass: TSkinFMXEdit;
    SkinFMXPanel8: TSkinFMXPanel;
    edtRePass: TSkinFMXEdit;
    btnReg: TSkinFMXButton;
    SkinFMXPanel13: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnRegClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  private
    FPassword:String;
    FRePassword:String;

    FPhone:String;
    FCaptcha:String;

    procedure DoResetPasswordExecute(ATimerTask:TObject);
    procedure DoResetPasswordExecuteEnd(ATimerTask:TObject);

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load(
                  APhone:String;
                  ACaptcha:String
                  );
    { Public declarations }
  end;

var
  GlobalResetPasswordFrame:TFrameResetPassword;

implementation

uses
  MainForm,
  LoginFrame;

{$R *.fmx}

procedure TFrameResetPassword.btnRegClick(Sender: TObject);
var
  ATimerTask:TTimerTask;
begin
  HideVirtualKeyboard;



  if Self.edtPass.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtRePass.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入确认密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPass.Text<>Self.edtRePass.Text then
  begin
    ShowMessageBoxFrame(Self,'两次密码不一致!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  ShowWaitingFrame(Self,'重置密码中...');




  FPassword:=Trim(Self.edtPass.Text);
  FRePassword:=Trim(Self.edtRePass.Text);



  GetGlobalTimerThread.RunTempTask(DoResetPasswordExecute,
            DoResetPasswordExecuteEnd);

end;

procedure TFrameResetPassword.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameResetPassword.DoResetPasswordExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.ReSetPassword(
        FPhone,
        FCaptcha,
        FPassword,
        FRePassword
        );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameResetPassword.DoResetPasswordExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //密码重置成功
        //重设密码成功
        //显示登陆界面


        HideFrame;//(Self,hfcttBeforeShowFrame);
        //显示登陆界面
        ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//        GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalLoginFrame.edtUser.Text:=Self.FPhone;
        GlobalLoginFrame.edtPass.Text:=Self.FPassword;

      end
      else
      begin
        //密码重置失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

function TFrameResetPassword.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameResetPassword.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameResetPassword.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameResetPassword.Load(APhone, ACaptcha: String);
begin
  FPhone:=APhone;
  FCaptcha:=ACaptcha;

  Self.edtPass.Text:='';
  Self.edtRePass.Text:='';

  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

end.
