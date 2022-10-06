//convert pas to utf8 by ¥

unit ComboEditFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.ComboEdit, uSkinFireMonkeyComboEdit,

  uLang,
  uFrameContext,
  uUIFunction,
  uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinFireMonkeyImage,
  FMX.ListBox, uSkinFireMonkeyComboBox,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinScrollBoxContentType, uBaseSkinControl,
  uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameComboEdit = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent,IFrameChangeLanguageEvent)
    cmbeditComboEdit: TSkinFMXComboEdit;
    sbClient: TSkinFMXScrollBox;
    sbcConent: TSkinFMXScrollBoxContent;
    lblComboEditCanSetBackColorAndBorder: TLabel;
    lblComboEditCanSetHelpText: TLabel;
    lblComboEditCanSetHelpIcon: TLabel;
    ComboEdit1: TComboEdit;
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

constructor TFrameComboEdit.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言

  RegLangString(Self.lblComboEditCanSetBackColorAndBorder.Name,
      [Self.lblComboEditCanSetBackColorAndBorder.Text,
      'Can set background color and border']);
  RegLangString(Self.lblComboEditCanSetHelpText.Name,
      [Self.lblComboEditCanSetHelpText.Text,
      'Can set help text']);
  RegLangString(Self.lblComboEditCanSetHelpIcon.Name,
      [Self.lblComboEditCanSetHelpIcon.Text,
      'Can set icon of dropdown']);

  RegLangString(Self.cmbeditComboEdit.Name+'Caption 0',
                [Self.cmbeditComboEdit.Items[0],'Shang hai']);
  RegLangString(Self.cmbeditComboEdit.Name+'Caption 1',
                [Self.cmbeditComboEdit.Items[1],'Bei jing']);
  RegLangString(Self.cmbeditComboEdit.Name+'Caption 2',
                [Self.cmbeditComboEdit.Items[2],'Zhe jiang']);

  RegLangString(Self.cmbeditComboEdit.Name+'HelpText',
                [Self.cmbeditComboEdit.Prop.HelpText,'Address']);
end;

function TFrameComboEdit.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameComboEdit.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameComboEdit.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameComboEdit.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblComboEditCanSetBackColorAndBorder.Text:=GetLangString(Self.lblComboEditCanSetBackColorAndBorder.Name,ALangKind);
  Self.lblComboEditCanSetHelpText.Text:=GetLangString(Self.lblComboEditCanSetHelpText.Name,ALangKind);
  Self.lblComboEditCanSetHelpIcon.Text:=GetLangString(Self.lblComboEditCanSetHelpIcon.Name,ALangKind);


  Self.cmbeditComboEdit.Items[0]:=GetLangString(Self.cmbeditComboEdit.Name+'Caption 0',ALangKind);
  Self.cmbeditComboEdit.Items[1]:=GetLangString(Self.cmbeditComboEdit.Name+'Caption 1',ALangKind);
  Self.cmbeditComboEdit.Items[2]:=GetLangString(Self.cmbeditComboEdit.Name+'Caption 2',ALangKind);

  Self.cmbeditComboEdit.Prop.HelpText:=GetLangString(Self.cmbeditComboEdit.Name+'HelpText',ALangKind);



end;

end.
