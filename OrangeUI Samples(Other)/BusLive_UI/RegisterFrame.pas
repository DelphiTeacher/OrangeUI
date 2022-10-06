//convert pas to utf8 by ¥
unit RegisterFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyImage,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyLabel,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType;

type
  TFrameRegister = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    edtPhone: TSkinFMXEdit;
    edtVerifyCode: TSkinFMXEdit;
    btnRegister: TSkinFMXButton;
    btnGetVerifyCode: TSkinFMXButton;
    edtPass: TSkinFMXEdit;
    edtPassAgain: TSkinFMXEdit;
    edtNickName: TSkinFMXEdit;
    procedure btnReturnClick(Sender: TObject);
    procedure btnRegisterStayClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalRegisterFrame:TFrameRegister;


implementation

{$R *.fmx}

procedure TFrameRegister.btnRegisterStayClick(Sender: TObject);
begin
  //跳转到之前的页面
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameRegister.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameRegister.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
