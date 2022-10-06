//convert pas to utf8 by ¥

unit HideVKboardFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, FMX.Edit, FMX.Controls.Presentation,
  uUIFunction,
  uSkinFireMonkeyEdit, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinButtonType,
  uSkinPanelType, uSkinScrollBoxContentType, uBaseSkinControl,
  uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameHideVKboard = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    SkinFMXScrollBox1: TSkinFMXScrollBox;
    SkinFMXScrollBoxContent1: TSkinFMXScrollBoxContent;
    SkinFMXPanel1: TSkinFMXPanel;
    edtUser: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
    SkinFMXPanel2: TSkinFMXPanel;
    edtPass: TSkinFMXEdit;
    ClearEditButton2: TClearEditButton;
    btnHideVKboardByMethod: TSkinFMXButton;
    btnHideVKBoardBySetFocus: TSkinFMXButton;
    procedure btnHideVKboardByMethodClick(Sender: TObject);
    procedure btnHideVKBoardBySetFocusClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameHideVKboard }

procedure TFrameHideVKboard.btnHideVKboardByMethodClick(Sender: TObject);
begin
  uUIFunction.HideVirtualKeyboard;
end;

procedure TFrameHideVKboard.btnHideVKBoardBySetFocusClick(Sender: TObject);
begin
  btnHideVKBoardBySetFocus.CanFocus:=True;
  btnHideVKBoardBySetFocus.SetFocus;
end;

function TFrameHideVKboard.GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
begin
  Result:=btnHideVKBoardBySetFocus;
end;

function TFrameHideVKboard.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;



function TFrameHideVKboard.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

end.
