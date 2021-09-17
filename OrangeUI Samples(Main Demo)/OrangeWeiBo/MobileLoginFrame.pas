//convert pas to utf8 by ¥

unit MobileLoginFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyImage, FMX.Controls.Presentation,
  uUIFunction,
  Math,
  uSinaWeiboManager,
  MobileAuthFrame,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyButton, uSkinFireMonkeyLabel,
  uSkinFireMonkeyPanel, uDrawPicture, uSkinImageList;

type
  TFrameMobileLogin = class(TFrame)
    imgLogo: TSkinFMXImage;
    imgLoginBackPic: TSkinFMXImage;
    edtPass: TSkinFMXEdit;
    edtUser: TSkinFMXEdit;
    imgUserHint: TSkinFMXImage;
    imgPassHint: TSkinFMXImage;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    btnLogin: TSkinFMXButton;
    lblHelp: TSkinFMXLabel;
    lblRegister: TSkinFMXLabel;
    imglistLoginEdit: TSkinImageList;
    imgToolBarDevide: TSkinFMXImage;
    lblReAuth: TSkinFMXLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure SkinFMXImage5Click(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure lblReAuthClick(Sender: TObject);
  private
    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
    destructor Destroy;override;
    { Public declarations }
  end;



var
  GlobalMobileLoginFrame:TFrameMobileLogin;


implementation

uses
  MobileMainForm,
  MobileMainFrame;

{$R *.fmx}

procedure TFrameMobileLogin.btnLoginClick(Sender: TObject);
begin
  //返回
  HideFrame(Self,hfcttBeforeShowFrame);


  if Now>GlobalManager.OAuth2User.ExpiresTime then
  begin
    //授权码已到期，重新授权
    ShowFrame(TFrame(GlobalMobileAuthFrame),TFrameMobileAuth,frmMobileMain,nil,nil,nil{OnReturnFrameAfterAuth},Application);
    GlobalMobileAuthFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalMobileAuthFrame.btnAuthClick(Self);
  end
  else
  begin
    //显示主界面
    frmMobileMain.ShowMainFrame;
  end;
end;

destructor TFrameMobileLogin.Destroy;
begin
  inherited;
end;

procedure TFrameMobileLogin.FrameResize(Sender: TObject);
begin
//  Self.SkinFMXLabel1.Left:=Ceil(Self.Width-Self.SkinFMXLabel1.WidthInt) div 2;
  Self.imgLogo.Left:=Ceil(Self.Width-Self.imgLogo.WidthInt) div 2;
end;

procedure TFrameMobileLogin.SkinFMXImage5Click(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;
  //返回
  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(FrameHistroy);
end;

procedure TFrameMobileLogin.lblReAuthClick(Sender: TObject);
begin
  HideFrame(Self,hfcttBeforeShowFrame);

  //授权
  ShowFrame(TFrame(GlobalMobileAuthFrame),TFrameMobileAuth,frmMobileMain,nil,nil,nil{OnReturnFrameAfterAuth},Application);
  GlobalMobileAuthFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalMobileAuthFrame.btnAuthClick(Self);

end;

end.
