//convert pas to utf8 by ¥

unit RegisterFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uMobileUtils,
  uFuncCommon,
//  uCommonUtils,

  WaitingFrame,
  MessageBoxFrame,
  RegisterProtocolFrame,


  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,
  ClientModuleUnit1,
  FriendCircleCommonMaterialDataMoudle,

  uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel, uSkinFireMonkeyButton,
  FMX.Edit, FMX.Controls.Presentation, uSkinFireMonkeyEdit,
   uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinCheckBoxType,
  uSkinLabelType, uSkinScrollBoxContentType, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameRegister = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    SkinFMXPanel2: TSkinFMXPanel;
    edtName: TSkinFMXEdit;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXPanel4: TSkinFMXPanel;
    edtPhone: TSkinFMXEdit;
    SkinFMXPanel5: TSkinFMXPanel;
    edtCaptcha: TSkinFMXEdit;
    btnSendCaptcha: TSkinFMXButton;
    SkinFMXPanel6: TSkinFMXPanel;
    SkinFMXPanel7: TSkinFMXPanel;
    edtPass: TSkinFMXEdit;
    SkinFMXPanel8: TSkinFMXPanel;
    edtRePass: TSkinFMXEdit;
    btnReg: TSkinFMXButton;
    SkinFMXPanel13: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    tmrSendCaptchaCheck: TTimer;
    SkinFMXPanel12: TSkinFMXPanel;
    lblProtocol: TSkinFMXLabel;
    chkAgree: TSkinFMXCheckBox;
    procedure btnRegClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnSendCaptchaClick(Sender: TObject);
    procedure tmrSendCaptchaCheckTimer(Sender: TObject);
    procedure lblProtocolClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
  private
    FPhone:String;
    FCaptcha:String;

    FName:String;
    FPassword:String;
    FRePassword:String;


    procedure DoRegisterExecute(ATimerTask:TObject);
    procedure DoRegisterExecuteEnd(ATimerTask:TObject);

    procedure DoSendCaptchaExecute(ATimerTask:TObject);
    procedure DoSendCaptchaExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Clear;
    { Public declarations }
  end;

var
  GlobalRegisterFrame:TFrameRegister;

implementation

uses
  MainForm,
  LoginFrame,
  MainFrame;

{$R *.fmx}

{ TFrame1 }

procedure TFrameRegister.btnRegClick(Sender: TObject);
begin
  HideVirtualKeyboard;


  if Self.edtName.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入姓名!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入手机号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入验证码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Not IsMobPhone(Self.edtPhone.Text) then
  begin
    ShowMessageBoxFrame(Self,'手机号码格式不正确!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


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




  if Not chkAgree.Prop.Checked then
  begin
    ShowMessageBoxFrame(Self,'请阅读'+lblProtocol.Caption+'!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;




  ShowWaitingFrame(Self,'注册中...');


  FPhone:=Trim(Self.edtPhone.Text);
  FName:=Trim(Self.edtName.Text);
  FCaptcha:=Trim(Self.edtCaptcha.Text);
  FPassword:=Trim(Self.edtPass.Text);
  FRePassword:=Trim(Self.edtRePass.Text);



  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoRegisterExecute,
      DoRegisterExecuteEnd
    );

end;

procedure TFrameRegister.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameRegister.btnSendCaptchaClick(Sender: TObject);
begin


  HideVirtualKeyboard;



  if Trim(Self.edtPhone.Text)='' then
  begin
    ShowMessageBoxFrame(Self,'请输入手机号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Not IsMobPhone(Self.edtPhone.Text) then
  begin
    ShowMessageBoxFrame(Self,'手机号码格式不正确!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  ShowWaitingFrame(Self,'发送中...');

  Self.btnSendCaptcha.Tag:=0;
  Self.btnSendCaptcha.Enabled:=False;


  FPhone:=Trim(Self.edtPhone.Text);


  //线程发送验证码
  GetGlobalTimerThread.RunTempTask(DoSendCaptchaExecute,DoSendCaptchaExecuteEnd);


end;

procedure TFrameRegister.Clear;
begin
  Self.edtName.Text:='';

  Self.edtPhone.Text:='';
  Self.edtCaptcha.Text:='';

  Self.edtPass.Text:='';
  Self.edtRePass.Text:='';

  Self.chkAgree.Prop.Checked:=False;

//  Self.tmrSendCaptchaCheck.Enabled:=False;
//
//  //恢复正常状态
//  Self.btnSendCaptcha.Caption:='发送验证码';
//  Self.btnSendCaptcha.Enabled:=True;
//  Self.btnSendCaptcha.Prop.IsPushed:=False;
//

  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

procedure TFrameRegister.DoRegisterExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.RegisterUser(
        FName,
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

procedure TFrameRegister.DoRegisterExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //注册成功

        //显示登录界面
        HideFrame;//(Self,hfcttBeforeShowFrame);
        //显示登陆界面
        ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//        GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;

        GlobalLoginFrame.edtUser.Text:=FPhone;
        GlobalLoginFrame.edtPass.Text:=FPassword;
      end
      else
      begin
        //注册失败
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

procedure TFrameRegister.DoSendCaptchaExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.SendRegisterCaptcha(
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

procedure TFrameRegister.DoSendCaptchaExecuteEnd(ATimerTask: TObject);
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

function TFrameRegister.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameRegister.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

procedure TFrameRegister.lblProtocolClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  FreeAndNil(GlobalRegisterProtocolFrame);
  //查看协议
  ShowFrame(TFrame(GlobalRegisterProtocolFrame),TFrameRegisterProtocol,frmMain,nil,nil,nil,Application,False,False,ufsefNone);
  GlobalRegisterProtocolFrame.Load;

end;

procedure TFrameRegister.tmrSendCaptchaCheckTimer(Sender: TObject);
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








