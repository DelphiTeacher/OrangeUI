//convert pas to utf8 by ¥
unit LoginFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uUIFunction,
  RegisterFrame,
  ResetPassFrame,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyImage,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyLabel,
  uSkinLabelType, uSkinImageType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameLogin = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgHead: TSkinFMXImage;
    edtPhone: TSkinFMXEdit;
    edtPass: TSkinFMXEdit;
    btnLogin: TSkinFMXButton;
    lblForgetPass: TSkinFMXLabel;
    btnReg: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnLoginStayClick(Sender: TObject);
    procedure btnRegStayClick(Sender: TObject);
    procedure lblForgetPassStayClick(Sender: TObject);
  private
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
  MainForm;


{$R *.fmx}

procedure TFrameLogin.btnLoginStayClick(Sender: TObject);
begin
  //登陆返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameLogin.btnRegStayClick(Sender: TObject);
begin
  //注册
  HideFrame;//(Self);
  //显示注册界面
  ShowFrame(TFrame(GlobalRegisterFrame),TFrameRegister,frmMain,nil,nil,nil,Application);
//  GlobalRegisterFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameLogin.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameLogin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Self.pnlVirtualKeyboard.Height:=0;
end;

procedure TFrameLogin.lblForgetPassStayClick(Sender: TObject);
begin
  //重置密码
  //忘记密码
  HideFrame;//(Self);
  //显示重置密码界面
  ShowFrame(TFrame(GlobalResetPassFrame),TFrameResetPass,frmMain,nil,nil,nil,Application);
//  GlobalResetPassFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.
