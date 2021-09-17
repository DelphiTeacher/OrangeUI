unit LoginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uSkinWindowsControl, uSkinPanelType, uSkinImageType, uSkinWindowsForm,
  StdCtrls, uSkinWindowsEdit, uSkinLabelType, uSkinButtonType, uSkinMaterial,
  ExtCtrls;

type
  TfrmLogin = class(TForm)
    pnlBottom: TSkinWinPanel;
    fsdForm: TSkinWinForm;
    pnlUser: TSkinWinPanel;
    pnlPassword: TSkinWinPanel;
    edtUser: TSkinWinEdit;
    edtPassword: TSkinWinEdit;
    chkRememberPassword: TCheckBox;
    lblForget: TSkinWinLabel;
    btnLogin: TSkinWinButton;
    Timer1: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure btnMinClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateParams(var Params: TCreateParams); override;
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  Self.ModalResult:=mrOK;
end;

procedure TfrmLogin.btnMinClick(Sender: TObject);
begin
  Self.WindowState:=wsMinimized;
end;

procedure TfrmLogin.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //无边框,但也不能拉伸
  Params.Style:=Params.Style and not WS_THICKFRAME;// or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
  //在任务栏显示
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;


end;

procedure TfrmLogin.Timer1Timer(Sender: TObject);
begin
//  SetFormShadow(Handle,True,Self.fsdForm.FIsSetedFormShadow);

end;

end.
