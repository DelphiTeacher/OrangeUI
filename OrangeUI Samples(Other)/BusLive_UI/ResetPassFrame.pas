//convert pas to utf8 by ¥
unit ResetPassFrame;

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
  uSkinLabelType, uSkinScrollBoxContentType, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameResetPass = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    edtPhone: TSkinFMXEdit;
    edtVerifyCode: TSkinFMXEdit;
    btnOK: TSkinFMXButton;
    lblFirstStep: TSkinFMXLabel;
    btnGetVerifyCode: TSkinFMXButton;
    lblSecondStep: TSkinFMXLabel;
    edtNewPass: TSkinFMXEdit;
    edtNewPassAgain: TSkinFMXEdit;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKStayClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalResetPassFrame:TFrameResetPass;


implementation

{$R *.fmx}

procedure TFrameResetPass.btnOKStayClick(Sender: TObject);
begin
  //返回前一页
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameResetPass.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

constructor TFrameResetPass.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  Self.pnlVirtualKeyboard.Height:=0;
end;

end.
