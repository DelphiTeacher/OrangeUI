//convert pas to utf8 by ¥

unit ComboBoxFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, uSkinFireMonkeyComboBox, uSkinFireMonkeyControl,

  uLang,
  uFrameContext,
  uSkinFireMonkeyImage, uSkinFireMonkeyLabel, FMX.Controls.Presentation,
  uSkinMaterial, uSkinComboBoxType;

type
  TFrameComboBox = class(TFrame,IFrameChangeLanguageEvent)
    cmbComboBox: TSkinFMXComboBox;
    lblComboBoxCanSetHelpText: TLabel;
    lblComboBoxCanSetBackColorAndBorder: TLabel;
    lblComboBoxCanSetDropDownIcon: TLabel;
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameComboBox }

procedure TFrameComboBox.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblComboBoxCanSetBackColorAndBorder.Text:=GetLangString(Self.lblComboBoxCanSetBackColorAndBorder.Name,ALangKind);
  Self.lblComboBoxCanSetHelpText.Text:=GetLangString(Self.lblComboBoxCanSetHelpText.Name,ALangKind);
  Self.lblComboBoxCanSetDropDownIcon.Text:=GetLangString(Self.lblComboBoxCanSetDropDownIcon.Name,ALangKind);


  Self.cmbComboBox.Items[0]:=GetLangString(Self.cmbComboBox.Name+'Caption 0',ALangKind);
  Self.cmbComboBox.Items[1]:=GetLangString(Self.cmbComboBox.Name+'Caption 1',ALangKind);
  Self.cmbComboBox.Items[2]:=GetLangString(Self.cmbComboBox.Name+'Caption 2',ALangKind);

  Self.cmbComboBox.Prop.HelpText:=GetLangString(Self.cmbComboBox.Name+'HelpText',ALangKind);


end;

constructor TFrameComboBox.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblComboBoxCanSetBackColorAndBorder.Name,
      [Self.lblComboBoxCanSetBackColorAndBorder.Text,
      'Can set background color and border']);
  RegLangString(Self.lblComboBoxCanSetHelpText.Name,
      [Self.lblComboBoxCanSetHelpText.Text,
      'Can set help text']);

  RegLangString(Self.lblComboBoxCanSetDropDownIcon.Name,
      [Self.lblComboBoxCanSetDropDownIcon.Text,
      'Can set icon of dropdown']);

  RegLangString(Self.cmbComboBox.Name+'Caption 0',
                [Self.cmbComboBox.Items[0],'Shang hai']);
  RegLangString(Self.cmbComboBox.Name+'Caption 1',
                [Self.cmbComboBox.Items[1],'Bei jing']);
  RegLangString(Self.cmbComboBox.Name+'Caption 2',
                [Self.cmbComboBox.Items[2],'Zhe jiang']);

  RegLangString(Self.cmbComboBox.Name+'HelpText',
                [Self.cmbComboBox.Prop.HelpText,'Address']);


end;

end.
