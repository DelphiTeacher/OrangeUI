//convert pas to utf8 by ¥

unit LoginFrame;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uFuncCommon,

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


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyScrollBoxContent, uSkinMaterial, uSkinPanelType,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinEditType,
  uSkinFireMonkeyButton, uSkinFireMonkeyLabel, uSkinFireMonkeyCheckBox,
  uSkinLabelType, uSkinButtonType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameLogin = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    SkinFMXScrollBox1: TSkinFMXScrollBox;
    SkinFMXScrollBoxContent1: TSkinFMXScrollBoxContent;
    SkinFMXPanel1: TSkinFMXPanel;
    edtUser: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
    SkinFMXPanel2: TSkinFMXPanel;
    edtPass: TSkinFMXEdit;
    ClearEditButton2: TClearEditButton;
    btnLogin: TSkinFMXButton;
    btnReg: TSkinFMXButton;
    lblForgetPassword: TSkinFMXLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure btnRegClick(Sender: TObject);
    procedure lblForgetPasswordClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
  private
    FLoginUser:String;
    FLoginPass:String;
    procedure DoLoginExecute(ATimerTask:TObject);
    procedure DoLoginExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalLoginFrame:TFrameLogin;

implementation

uses
  MainForm,
  RegisterFrame,
  ForgetPasswordFrame,
  MainFrame;

{$R *.fmx}

procedure TFrameLogin.btnLoginClick(Sender: TObject);
begin
  HideVirtualKeyboard;


  if Self.edtUser.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入账号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPass.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  FLoginUser:=Self.edtUser.Text;
  FLoginPass:=Self.edtPass.Text;


  ShowWaitingFrame(Self,'登录中...');
  //登录
  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoLoginExecute,
      DoLoginExecuteEnd
      );
end;

procedure TFrameLogin.btnRegClick(Sender: TObject);
begin
  //注册
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalRegisterFrame),TFrameRegister,frmMain,nil,nil,nil,Application);
//  GlobalRegisterFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalRegisterFrame.Clear;

end;

constructor TFrameLogin.Create(AOwner: TComponent);
begin
  inherited;

  Self.edtUser.Text:=uManager.GlobalManager.LastLoginUser;
  Self.edtPass.Text:=uManager.GlobalManager.LastLoginPass;

//  //默认测试的用户名密码
//  if Self.edtUser.Text='' then
//  begin
//    Self.edtUser.Text:='18957901025';
//    Self.edtPass.Text:='123456';
//  end;
end;

procedure TFrameLogin.DoLoginExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=
      ClientModuleUnit1.ClientModule.ServerMethods1Client.Login(
        FLoginUser,
        FLoginPass,
        '1.0'
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

procedure TFrameLogin.DoLoginExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        GlobalManager.User.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);



        //登录成功
        uManager.GlobalManager.LastLoginUser:=FLoginUser;
        uManager.GlobalManager.LastLoginPass:=FLoginPass;
        uManager.GlobalManager.Save;


        uFuncCommon.FreeAndNil(GlobalMainFrame);

        //显示主界面
        HideFrame;//(Self,hfcttBeforeShowFrame);
        ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application);
//        GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
        frmMain.Login;

      end
      else
      begin
        //登录失败
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

function TFrameLogin.GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameLogin.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

procedure TFrameLogin.lblForgetPasswordClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //忘记密码
  ShowFrame(TFrame(GlobalForgetPasswordFrame),TFrameForgetPassword,frmMain,nil,nil,nil,Application);
//  GlobalForgetPasswordFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalForgetPasswordFrame.Clear;

end;

end.
