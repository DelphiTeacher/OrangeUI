//convert pas to utf8 by ¥

unit ChangePasswordFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  WaitingFrame,
  MessageBoxFrame,
  uInterfaceClass,

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,

  EasyServiceCommonMaterialDataMoudle,

  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameChangePassword = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    SkinFMXPanel2: TSkinFMXPanel;
    edtOldPass: TSkinFMXEdit;
    SkinFMXPanel6: TSkinFMXPanel;
    SkinFMXPanel7: TSkinFMXPanel;
    edtPass: TSkinFMXEdit;
    SkinFMXPanel8: TSkinFMXPanel;
    edtRePass: TSkinFMXEdit;
    btnReg: TSkinFMXButton;
    SkinFMXPanel13: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnRegClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  private
    FOldPass:String;
    FPassword:String;
    FRePassword:String;


    procedure DoChangePasswordExecute(ATimerTask:TObject);
    procedure DoChangePasswordExecuteEnd(ATimerTask:TObject);

    procedure OnChangePasswordMessageBoxModalResult(Sender: TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Clear;
    { Public declarations }
  end;

var
  GlobalChangePasswordFrame:TFrameChangePassword;

implementation

{$R *.fmx}

procedure TFrameChangePassword.btnRegClick(Sender: TObject);
begin
  HideVirtualKeyboard;




  if Self.edtOldPass.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入原密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPass.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入新密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtRePass.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入确认密码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtRePass.Text<>Self.edtPass.Text then
  begin
    ShowMessageBoxFrame(Self,'两次密码不一致!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  ShowWaitingFrame(Self,'修改密码中...');



  FOldPass:=Trim(Self.edtOldPass.Text);
  FPassword:=Trim(Self.edtPass.Text);
  FRePassword:=Trim(Self.edtRePass.Text);

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                           DoChangePasswordExecute,
                                           DoChangePasswordExecuteEnd  );

end;

procedure TFrameChangePassword.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameChangePassword.Clear;
begin
  Self.edtOldPass.Text:='';
  Self.edtPass.Text:='';
  Self.edtRePass.Text:='';

  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

procedure TFrameChangePassword.DoChangePasswordExecute(ATimerTask: TObject);
var
  AHttpControl:TSystemHttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('change_password',
                                                        AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'oldpassword',
                                                      'password',
                                                      'repassword'
                                                      ],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      FOldPass,
                                                      FPassword,
                                                     FRePassword]
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

procedure TFrameChangePassword.DoChangePasswordExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //密码修改成功

        ShowMessageBoxFrame(Self,'密码修改成功!','',TMsgDlgType.mtInformation,['确定'],OnChangePasswordMessageBoxModalResult);


      end
      else
      begin
        //密码修改失败
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

function TFrameChangePassword.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameChangePassword.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameChangePassword.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameChangePassword.OnChangePasswordMessageBoxModalResult(
  Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

end.

