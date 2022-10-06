unit LoginFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyPanel, FMX.Edit, FMX.Controls.Presentation, uSkinFireMonkeyEdit,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameLogin = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    lblUserName: TLabel;
    edtUserName: TSkinFMXEdit;
    lblPassword: TLabel;
    edtPassword: TSkinFMXEdit;
    btnLogin: TButton;
    Label3: TLabel;
    SkinFMXEdit3: TSkinFMXEdit;
    Label4: TLabel;
    SkinFMXEdit4: TSkinFMXEdit;
    Label5: TLabel;
    SkinFMXEdit5: TSkinFMXEdit;
    Label6: TLabel;
    SkinFMXEdit6: TSkinFMXEdit;
    Label7: TLabel;
    SkinFMXEdit7: TSkinFMXEdit;
    Label8: TLabel;
    SkinFMXEdit8: TSkinFMXEdit;
    Label9: TLabel;
    SkinFMXEdit9: TSkinFMXEdit;
    Label10: TLabel;
    SkinFMXEdit10: TSkinFMXEdit;
    Label1: TLabel;
    Label2: TLabel;
    SkinFMXEdit1: TSkinFMXEdit;
    SkinFMXEdit2: TSkinFMXEdit;
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    //虚拟键盘放在哪里
    function GetVirtualKeyboardControlParent:TControl;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameLogin }


function TFrameLogin.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameLogin.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

end.
