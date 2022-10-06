//convert pas to utf8 by ¥

unit ForgetPasswordFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uMobileUtils,
  uFuncCommon,
//  uCommonUtils,

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

  uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, RegisterFrame,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uBaseSkinControl, uSkinPanelType;

type
  TFrameForgetPassword = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXPanel4: TSkinFMXPanel;
    edtPhone: TSkinFMXEdit;
    SkinFMXPanel5: TSkinFMXPanel;
    edtCaptcha: TSkinFMXEdit;
    btnSendCaptcha: TSkinFMXButton;
    SkinFMXPanel6: TSkinFMXPanel;
    btnNext: TSkinFMXButton;
    tmrSendCaptchaCheck: TTimer;
    procedure btnReturnClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnSendCaptchaClick(Sender: TObject);
    procedure tmrSendCaptchaCheckTimer(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  private
    FPhone:String;
    FCaptcha:String;

    procedure DoSendCaptchaExecute(ATimerTask:TObject);
    procedure DoSendCaptchaExecuteEnd(ATimerTask:TObject);

  private

    procedure DoCheckCaptchaExecute(ATimerTask:TObject);
    procedure DoCheckCaptchaExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Clear;
    { Public declarations }
  end;


var
  GlobalForgetPasswordFrame:TFrameForgetPassword;

implementation

uses
  MainForm,
  ResetPasswordFrame;


{$R *.fmx}

procedure TFrameForgetPassword.btnNextClick(Sender: TObject);
begin
  HideVirtualKeyboard;




  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入手机号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtCaptcha.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入验证码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Not IsMobPhone(Self.edtPhone.Text) then
  begin
    ShowMessageBoxFrame(Self,'手机号码格式不对!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  ShowWaitingFrame(Self,'验证中...');


  FPhone:=Trim(Self.edtPhone.Text);
  FCaptcha:=Trim(Self.edtCaptcha.Text);


  GetGlobalTimerThread.RunTempTask(DoCheckCaptchaExecute,DoCheckCaptchaExecuteEnd);


end;

procedure TFrameForgetPassword.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameForgetPassword.btnSendCaptchaClick(Sender: TObject);
var
  ATimerTask:TTimerTask;
begin
  HideVirtualKeyboard;

  if Trim(Self.edtPhone.Text)='' then
  begin
    ShowMessageBoxFrame(Self,'请输入手机号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Not IsMobPhone(Self.edtPhone.Text) then
  begin
    ShowMessageBoxFrame(Self,'手机号码格式不对!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  ShowWaitingFrame(Self,'发送中...');

  Self.btnSendCaptcha.Tag:=0;
  Self.btnSendCaptcha.Enabled:=False;


  //发送验证码
  FPhone:=Trim(Self.edtPhone.Text);


  GetGlobalTimerThread.RunTempTask(
                  DoSendCaptchaExecute,
                  DoSendCaptchaExecuteEnd
                  );

end;

procedure TFrameForgetPassword.Clear;
begin
  Self.edtPhone.Text:='';
  Self.edtCaptcha.Text:='';

//  Self.tmrSendCaptchaCheck.Enabled:=False;
//
//  //恢复正常状态
//  Self.btnSendCaptcha.Caption:='发送验证码';
//  Self.btnSendCaptcha.Enabled:=True;
//  Self.btnSendCaptcha.Prop.IsPushed:=False;


  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

procedure TFrameForgetPassword.DoCheckCaptchaExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.CheckForgetPasswordCaptcha(
        FPhone,
        FCaptcha
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

procedure TFrameForgetPassword.DoCheckCaptchaExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //验证码检查成功
        //下一步
        //隐藏
        HideFrame;//(Self,hfcttBeforeShowFrame);

        //重置密码
        ShowFrame(TFrame(GlobalResetPasswordFrame),TFrameResetPassword,frmMain,nil,nil,nil,Application);
//        GlobalResetPasswordFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalResetPasswordFrame.Load(FPhone,FCaptcha);

      end
      else
      begin
        //验证码检查失败
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

procedure TFrameForgetPassword.DoSendCaptchaExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.SendForgetPasswordCaptcha(
        FPhone
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

procedure TFrameForgetPassword.DoSendCaptchaExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //发送验证码成功
        tmrSendCaptchaCheck.Enabled:=True;

      end
      else
      begin

        Self.btnSendCaptcha.Enabled:=True;

        //验证码发送失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      Self.btnSendCaptcha.Enabled:=True;

      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

function TFrameForgetPassword.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameForgetPassword.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameForgetPassword.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameForgetPassword.tmrSendCaptchaCheckTimer(Sender: TObject);
begin
  Self.btnSendCaptcha.Tag:=Self.btnSendCaptcha.Tag+1;
  if Self.btnSendCaptcha.Tag>60 then
  begin
    Self.btnSendCaptcha.Caption:='发送验证码';
    Self.btnSendCaptcha.Enabled:=True;
    Self.btnSendCaptcha.Prop.IsPushed:=False;

    tmrSendCaptchaCheck.Enabled:=False;

  end
  else
  begin
    Self.btnSendCaptcha.Caption:='剩余'+IntToStr(60-Self.btnSendCaptcha.Tag)+'秒';
    Self.btnSendCaptcha.Enabled:=False;
    Self.btnSendCaptcha.Prop.IsPushed:=True;
  end;

end;





end.









