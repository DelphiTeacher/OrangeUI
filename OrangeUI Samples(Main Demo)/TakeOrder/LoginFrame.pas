//convert pas to utf8 by ¥
unit LoginFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uFuncCommon,
  uSkinItems,


  WaitingFrame,
  MessageBoxFrame,

  uSkinListBoxType,

  uManager,
  uGetDeviceInfo,
  uInterfaceClass,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyScrollBoxContent, uSkinMaterial, uSkinPanelType,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinEditType,
  uSkinFireMonkeyButton, uSkinFireMonkeyLabel, uSkinFireMonkeyCheckBox,
  uSkinFireMonkeyImage, uSkinFireMonkeyCustomList, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel,
  uSkinItemDesignerPanelType, uSkinCustomListType, uSkinVirtualListType,
  uSkinLabelType, uSkinImageType, uSkinButtonType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uDrawCanvas;

type
  TFrameLogin = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    sbLogin: TSkinFMXScrollBox;
    sbcLogin: TSkinFMXScrollBoxContent;
    pnlUserName: TSkinFMXPanel;
    edtUser: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
    pnlPassword: TSkinFMXPanel;
    edtPass: TSkinFMXEdit;
    ClearEditButton2: TClearEditButton;
    btnLogin: TSkinFMXButton;
    pnlLogo: TSkinFMXPanel;
    imgLogo: TSkinFMXImage;
    pnlBottom: TSkinFMXPanel;
    lblForgetPassword: TSkinFMXLabel;
    lblRegister: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    lblHint: TSkinFMXLabel;
    btnSelectedLogin: TSkinFMXButton;
    lbLoginList: TSkinFMXListBox;
    idpLogion: TSkinFMXItemDesignerPanel;
    lblLogion: TSkinFMXLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure lblRegisterClick(Sender: TObject);
    procedure lblForgetPasswordClick(Sender: TObject);
    procedure btnSelectedLoginClick(Sender: TObject);
    procedure edtUserClick(Sender: TObject);
    procedure edtPassClick(Sender: TObject);
    procedure lbLoginListClickItem(AItem: TSkinItem);
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
  end;



var
  GlobalLoginFrame:TFrameLogin;


implementation

uses
  MainForm,
  RegisterFrame,
//  ApplyIntroducerFrame,
  ForgetPasswordFrame,
//  LookCertificationInfoFrame,
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

procedure TFrameLogin.btnSelectedLoginClick(Sender: TObject);
var
  AListBoxItem:TSkinListBoxItem;
  I: Integer;
begin
  HideVirtualKeyboard;
  Self.lbLoginList.Height:=0;
  if Self.btnSelectedLogin.Properties.IsPushed=False then
  begin
    if GlobalManager.LoginedUserList<>nil then
    begin
      Self.lbLoginList.Visible:=True;
      Self.btnSelectedLogin.Properties.IsPushed:=True;
      Self.lbLoginList.Prop.Items.Clear(True);
      try
        Self.lbLoginList.Prop.Items.BeginUpdate;
        for I:=GlobalManager.LoginedUserList.Count-1 Downto 0 do
        begin

          AListBoxItem:=Self.lbLoginList.Prop.Items.Add;
          AListBoxItem.Caption:=GlobalManager.LoginedUserList[I];

        end;

        if Self.lbLoginList.Prop.Items.Count<=3 then
        begin
          Self.lbLoginList.Height:=Self.lbLoginList.Prop.Items.Count*40;
        end
        else
        begin
          Self.lbLoginList.Height:=120;
        end;
      finally
        Self.lbLoginList.Prop.Items.EndUpdate();
      end;

    end
    else
    begin
      Self.lbLoginList.Visible:=False;
    end;
  end
  else
  begin
    Self.lbLoginList.Visible:=False;
    Self.btnSelectedLogin.Properties.IsPushed:=False;
  end;
end;

constructor TFrameLogin.Create(AOwner: TComponent);
begin
  inherited;

  Self.lblRegister.Material.DrawCaptionParam.FontColor:=SkinThemeColor;
  Self.lblForgetPassword.Material.DrawCaptionParam.FontColor:=SkinThemeColor;


  //加载上次登录的用户名和密码
  GlobalManager.Load;

  Self.lbLoginList.Visible:=False;
  Self.btnSelectedLogin.Properties.IsPushed:=False;

  Self.lbLoginList.Prop.Items.Clear(True);




  //设置上次登录的用户名和密码
  Self.edtUser.Text:='18957901025';//uManager.GlobalManager.LastLoginUser;
  Self.edtPass.Text:='123456';//uManager.GlobalManager.LastLoginPass;
end;

procedure TFrameLogin.DoLoginExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('login',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    ['appid',
                                                    'username',
                                                    'password',
                                                    'phone_imei',
                                                    'phone_uuid',
                                                    'phone_type',
                                                    'version',
                                                    'os',
                                                    'os_version'],
                                                    [AppID,
                                                    FLoginUser,
                                                    FLoginPass,
                                                    '',//GetIMEI,
                                                    '',//GetUUID,
                                                    GetPhoneType,
                                                    '',
                                                    GetOS,
                                                    GetOSVersion
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

procedure TFrameLogin.DoLoginExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        GlobalManager.User.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);

        //登录令牌,用于确认用户已经登录
        GlobalManager.User.key:=ASuperObject.O['Data'].S['Key'];

        //登录成功
        uManager.GlobalManager.LastLoginUser:=FLoginUser;
        uManager.GlobalManager.LastLoginPass:=FLoginPass;
        if uManager.GlobalManager.LoginedUserList.IndexOf(FLoginUser)=-1 then
        begin
          uManager.GlobalManager.LoginedUserList.Add(FLoginUser);
        end
        else
        begin
          uManager.GlobalManager.LoginedUserList.Move(
                                          uManager.GlobalManager.LoginedUserList.IndexOf(FLoginUser),
                                              uManager.GlobalManager.LoginedUserList.Count-1);

        end;


        uManager.GlobalManager.Save;
        uManager.GlobalManager.LoadUserConfig;



        //释放原主界面
        uFuncCommon.FreeAndNil(GlobalMainFrame);

        //显示主界面
        HideFrame;//(Self,hfcttBeforeShowFrame);
        ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application);
//        GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
        frmMain.Login;

//        GlobalVersionChecker.CheckNewVersion;

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

procedure TFrameLogin.edtPassClick(Sender: TObject);
begin
  Self.lbLoginList.Visible:=False;
  Self.btnSelectedLogin.Properties.IsPushed:=False;
end;

procedure TFrameLogin.edtUserClick(Sender: TObject);
begin
  Self.lbLoginList.Visible:=False;
  Self.btnSelectedLogin.Properties.IsPushed:=False;
end;

function TFrameLogin.GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameLogin.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

procedure TFrameLogin.lblRegisterClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

//  //显示申请介绍人页面
//  ShowFrame(TFrame(GlobalApplyIntroducerFrame),TFrameApplyIntroducer,frmMain,nil,nil,nil,Application);
//  GlobalApplyIntroducerFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalApplyIntroducerFrame.Clear;
//  GlobalApplyIntroducerFrame.LoadApplyIntroducerType(aitBeforeRegister);


  //注册
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalRegisterFrame),TFrameRegister,frmMain,nil,nil,nil,Application);
//  GlobalRegisterFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalRegisterFrame.Clear;
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

procedure TFrameLogin.lbLoginListClickItem(AItem: TSkinItem);
begin
  Self.edtUser.Text:=AItem.Caption;
  Self.lbLoginList.Visible:=False;
  Self.btnSelectedLogin.Properties.IsPushed:=False;
end;

end.
