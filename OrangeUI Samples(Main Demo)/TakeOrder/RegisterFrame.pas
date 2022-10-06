//convert pas to utf8 by ¥
unit RegisterFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uGetDeviceInfo,
  FMX.DeviceInfo,
  EasyServiceCommonMaterialDataMoudle,

//  uCommonUtils,
  uInterfaceClass,
  uFuncCommon,
  uBaseHttpControl,
  uTimerTask,
  WaitingFrame,
  MessageBoxFrame,

  uUIFunction,
  XSuperObject,
  XSuperJson,

  uManager,
  uMobileUtils,


  uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinButtonType, uSkinPanelType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameRegister = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    edtName: TSkinFMXEdit;
    pnlEmpty2: TSkinFMXPanel;
    pnlPassword: TSkinFMXPanel;
    edtPass: TSkinFMXEdit;
    pnlRepeatPassword: TSkinFMXPanel;
    edtRePass: TSkinFMXEdit;
    btnRegister: TSkinFMXButton;
    pnlEmpty1: TSkinFMXPanel;
    pnlEmpty: TSkinFMXPanel;
    pnlVerification: TSkinFMXPanel;
    edtCaptcha: TSkinFMXEdit;
    btnSendCaptcha: TSkinFMXButton;
    tmrSendCaptchaCheck: TTimer;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlEmpty3: TSkinFMXPanel;
    pnlArea: TSkinFMXPanel;
    btnArea: TSkinFMXButton;
    pnlPhone: TSkinFMXPanel;
    edtPhone: TSkinFMXEdit;
    pnlEmpty4: TSkinFMXPanel;
    pnlName: TSkinFMXPanel;
    procedure tmrSendCaptchaCheckTimer(Sender: TObject);
    procedure btnSendCaptchaClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnAreaStayClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  private
    FName:String;
    FPassword:String;
    FRePassword:String;
    FPhone:String;
    FCaptcha:String;

    FProvince:String;
    FCity:String;
    FArea:String;

    //注册用户
    procedure DoRegisterUserExecute(ATimerTask:TObject);
    procedure DoRegisterUserExecuteEnd(ATimerTask:TObject);
  private
    //发送验证码
    procedure DoSendRegisterCaptchaExecute(ATimerTask:TObject);
    procedure DoSendRegisterCaptchaExecuteEnd(ATimerTask:TObject);
  private
    //选择区域返回
    procedure OnReturnFrameFromSelectArea(Frame:TFrame);

    //注册成功
    procedure OnModalResultFromRegisterSucc(Frame:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Clear;

  public
    //传递进来的
    FBindCode:String;
    FIntroducerPhone:String;
    procedure Load(ABindCode:String;AIntroducerPhone:String);
    { Public declarations }
  end;

var
  GlobalRegisterFrame:TFrameRegister;

implementation

{$R *.fmx}

uses
  LoginFrame,
//  FillUserInfoFrame,
  SelectAreaFrame,
  MainForm;

procedure TFrameRegister.btnAreaStayClick(Sender: TObject);
begin

  HideFrame;//(Self,hfcttBeforeShowFrame);

  //选择省市
  ShowFrame(TFrame(GlobalSelectAreaFrame),TFrameSelectArea,frmMain,nil,nil,OnReturnFrameFromSelectArea,Application);
//  GlobalSelectAreaFrame.FrameHistroy:=CurrentFrameHistroy;

  if (FProvince<>'') and (FCity<>'') then
  begin
    GlobalSelectAreaFrame.Init(FProvince,FCity,FArea);
  end;

end;

procedure TFrameRegister.btnRegisterClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  if Trim(Self.edtName.Text)='' then
  begin
    ShowMessageBoxFrame(Self,'请输入姓名!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

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

  if Trim(Self.edtCaptcha.Text)='' then
  begin
    ShowMessageBoxFrame(Self,'请输入验证码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Trim(Self.edtPass.Text)=''then
  begin
    ShowMessageBoxFrame(Self,'请输入密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Trim(Self.edtRePass.Text)=''then
  begin
    ShowMessageBoxFrame(Self,'请输入确认密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  FName:=Trim(Self.edtName.Text);
  FPhone:=Trim(Self.edtPhone.Text);
  FCaptcha:=Trim(Self.edtCaptcha.Text);
  FPassword:=Trim(Self.edtPass.Text);
  FRePassword:=Trim(Self.edtRePass.Text);

  ShowWaitingFrame(Self,'注册中...');

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                               DoRegisterUserExecute,
                               DoRegisterUserExecuteEnd);

end;

procedure TFrameRegister.btnSendCaptchaClick(Sender: TObject);
begin
  HideVirtualKeyboard;


  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入手机号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Not IsMobPhone(Self.edtPhone.Text) then
  begin
    ShowMessageBoxFrame(Self,'手机号码格式不正确!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  FPhone:=Trim(Self.edtPhone.Text);

  ShowWaitingFrame(Self,'发送中...');

  Self.btnSendCaptcha.Tag:=0;
  Self.btnSendCaptcha.Enabled:=False;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoSendRegisterCaptchaExecute,
                 DoSendRegisterCaptchaExecuteEnd);

end;

procedure TFrameRegister.Clear;
begin
  Self.edtName.Text:='';
  Self.edtPhone.Text:='';
  Self.edtCaptcha.Text:='';
  Self.edtPass.Text:='';
  Self.edtRePass.Text:='';
  Self.btnArea.Text:='';
  FProvince:='';
  FCity:='';
  FArea:='';

  Self.sbClient.VertScrollBar.Prop.Position:=0;
end;

procedure TFrameRegister.DoRegisterUserExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('register_user',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    ['appid',
                                                    'name',
                                                    'phone',
                                                    'captcha',
                                                    'password',
                                                    'repassword',
                                                    'province',
                                                    'city',
                                                    'area',
                                                    'phone_imei',
                                                    'phone_uuid',
                                                    'phone_type',
                                                    'bind_code',
                                                    'introducer_phone'],
                                                    [AppID,
                                                    FName,
                                                    FPhone,
                                                    FCaptcha,
                                                    FPassword,
                                                    FRePassword,
                                                    FProvince,
                                                    FCity,
                                                    FArea,
                                                    GetIMEI,
                                                    GetUUID,
                                                    GetPhoneType,
                                                    FBindCode,
                                                    FIntroducerPhone
                                                    ]
                                                    );

      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;


    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;

end;

procedure TFrameRegister.DoRegisterUserExecuteEnd(ATimerTask: TObject);
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

        ShowMessageBoxFrame(frmMain,
                            '注册成功!',
                            '',
                            TMsgDlgType.mtInformation,
                            ['确定'],
                            OnModalResultFromRegisterSucc);




//        GlobalManager.User.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);
//        //显示实名认证界面
//        HideFrame;//(Self,hfcttBeforeShowFrame);
//        //显示实名认证界面
//        ShowFrame(TFrame(GlobalFillUserInfoFrame),TFrameFillUserInfo,frmMain,nil,nil,nil,Application);
//        GlobalFillUserInfoFrame.FPageIndex:=0;
//        GlobalFillUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//        GlobalFillUserInfoFrame.Clear;



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

procedure TFrameRegister.DoSendRegisterCaptchaExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('send_register_captcha',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    ['appid',
                                                    'phone'],
                                                    [AppID,
                                                    FPhone
                                                    ]
                                                    );

      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;


    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;
end;

procedure TFrameRegister.DoSendRegisterCaptchaExecuteEnd(ATimerTask: TObject);
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
        //发送验证码失败
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


function TFrameRegister.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameRegister.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameRegister.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameRegister.Load(ABindCode:String;AIntroducerPhone: String);
begin

  FBindCode:=ABindCode;
  FIntroducerPhone:=AIntroducerPhone;

end;

procedure TFrameRegister.OnModalResultFromRegisterSucc(Frame: TObject);
begin

  //注册成功

  //显示登录界面
  HideFrame;//(Self,hfcttBeforeShowFrame);
  //显示登陆界面
  ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//  GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;

  //在登录页面输入用户名密码
  GlobalLoginFrame.edtUser.Text:=FPhone;
  GlobalLoginFrame.edtPass.Text:=FPassword;

end;

procedure TFrameRegister.OnReturnFrameFromSelectArea(Frame:TFrame);
begin
//  FProvince:='';
//  FCity:='';
//  if GlobalSelectAreaFrame.lbProvince.Prop.SelectedItem<>nil then
//  begin
//    FProvince:=GlobalSelectAreaFrame.lbProvince.Prop.SelectedItem.Caption;
//  end;
//  if GlobalSelectAreaFrame.lbCity.Prop.SelectedItem<>nil then
//  begin
//    FCity:=GlobalSelectAreaFrame.lbCity.Prop.SelectedItem.Caption;
//  end;

    FProvince:=GlobalSelectAreaFrame.FSelectedProvince;
    FCity:=GlobalSelectAreaFrame.FSelectedCity;
    FArea:=GlobalSelectAreaFrame.FSelectedArea;

  Self.btnArea.Caption:=FProvince+' '+FCity+' '+FArea;
end;

procedure TFrameRegister.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
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

