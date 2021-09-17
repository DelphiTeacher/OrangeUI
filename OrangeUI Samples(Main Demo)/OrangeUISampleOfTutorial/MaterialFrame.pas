//convert pas to utf8 by ¥

unit MaterialFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyButton, uSkinMaterial,

  uLang,
  uFrameContext,
  uSkinButtonType, uSkinComboBoxType, FMX.Controls.Presentation,
  uBaseSkinControl;

type
  TFrameMaterial = class(TFrame,IFrameChangeLanguageEvent)
    DefaultButtonMaterial: TSkinButtonDefaultMaterial;
    btnUseSameMaterial3: TSkinFMXButton;
    btnUseSameMaterial2: TSkinFMXButton;
    btnUseSameMaterial1: TSkinFMXButton;
    btnLogin: TSkinFMXButton;
    btnOK: TSkinFMXButton;
    lblCanSetRefMaterial: TLabel;
    lblSomeControlCanUseSameMaterial: TLabel;
  private
    { Private declarations }
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameMaterial }

procedure TFrameMaterial.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblCanSetRefMaterial.Text:=GetLangString(Self.lblCanSetRefMaterial.Name,ALangKind);
  Self.lblSomeControlCanUseSameMaterial.Text:=GetLangString(Self.lblSomeControlCanUseSameMaterial.Name,ALangKind);

  Self.btnLogin.Text:=GetLangString(Self.btnLogin.Name,ALangKind);
  Self.btnOK.Text:=GetLangString(Self.btnOK.Name,ALangKind);

  Self.btnUseSameMaterial1.Text:=GetLangString(Self.btnUseSameMaterial1.Name,ALangKind);
  Self.btnUseSameMaterial2.Text:=GetLangString(Self.btnUseSameMaterial1.Name,ALangKind);
  Self.btnUseSameMaterial3.Text:=GetLangString(Self.btnUseSameMaterial1.Name,ALangKind);

end;

constructor TFrameMaterial.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblCanSetRefMaterial.Name,
      [Self.lblCanSetRefMaterial.Text,
      'Can set RefMaterial']);
  RegLangString(Self.lblSomeControlCanUseSameMaterial.Name,
      [Self.lblSomeControlCanUseSameMaterial.Text,
      'Controls can use same material']);

  RegLangString(Self.btnLogin.Name,[Self.btnLogin.Text,'Login']);
  RegLangString(Self.btnOK.Name,[Self.btnOK.Text,'OK']);

  RegLangString(Self.btnUseSameMaterial1.Name,
    [Self.btnUseSameMaterial1.Text,
    'We use same material']);

end;

end.
