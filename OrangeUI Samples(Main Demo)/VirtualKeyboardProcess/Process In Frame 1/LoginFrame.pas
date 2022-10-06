unit LoginFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyPanel, FMX.Edit, FMX.Controls.Presentation, uSkinPanelType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameLogin = class(TFrame,IFrameVirtualKeyboardEvent)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlVirtualKeyboard: TSkinFMXPanel;
    lblUserName: TLabel;
    edtUserName: TEdit;
    lblPassword: TLabel;
    edtPassword: TEdit;
    btnLogin: TButton;
  private
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameLogin }

constructor TFrameLogin.Create(AOwner: TComponent);
begin
  inherited;
  Self.pnlVirtualKeyboard.Height:=0;
end;

procedure TFrameLogin.DoVirtualKeyboardHide(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.pnlVirtualKeyboard.Height:=0;

end;

procedure TFrameLogin.DoVirtualKeyboardShow(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  if Bounds.Height-GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight>Self.pnlVirtualKeyboard.Height then
  begin
    Self.pnlVirtualKeyboard.Height:=RectHeight(Bounds)-GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight;
    //计算出合理的位置
    Self.sbClient.VertScrollBar.Properties.Position:=
        Self.btnLogin.Position.Y+Self.btnLogin.Height-Self.pnlVirtualKeyboard.Top;
  end;

end;

end.
