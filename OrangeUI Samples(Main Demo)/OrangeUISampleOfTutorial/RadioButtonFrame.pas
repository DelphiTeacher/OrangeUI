//convert pas to utf8 by ¥

unit RadioButtonFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uVersion,
  uLang,
  uFrameContext,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyRadioButton,
  uSkinFireMonkeySwitch, FMX.Controls.Presentation, uSkinFireMonkeyPanel,
  uSkinRadioButtonType, uBaseSkinControl, uSkinPanelType;

type
  TFrameRadioButton = class(TFrame,IFrameChangeLanguageEvent)
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXPanel4: TSkinFMXPanel;
    rbColor3: TSkinFMXRadioButton;
    rbColor5: TSkinFMXRadioButton;
    rbColor7: TSkinFMXRadioButton;
    rbColor2: TSkinFMXRadioButton;
    rbColor4: TSkinFMXRadioButton;
    rbColor6: TSkinFMXRadioButton;
    rbColor8: TSkinFMXRadioButton;
    SkinFMXRadioButton1: TSkinFMXRadioButton;
    SkinFMXPanel5: TSkinFMXPanel;
    lblCanSetCheckStateColor: TLabel;
    lblCanSetCheckStatePicture: TLabel;
    rbColor1: TSkinFMXRadioButton;
    SkinFMXPanel6: TSkinFMXPanel;
    rbPicture1: TSkinFMXRadioButton;
    rbPicture2: TSkinFMXRadioButton;
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

{ TFrameRadioButton }

procedure TFrameRadioButton.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblCanSetCheckStatePicture.Text:=GetLangString(Self.lblCanSetCheckStatePicture.Name,ALangKind);
  Self.rbPicture1.Text:=GetLangString('PictureCheckBox',ALangKind);
  Self.rbPicture2.Text:=GetLangString('PictureCheckBox',ALangKind);


  Self.lblCanSetCheckStateColor.Text:=GetLangString(Self.lblCanSetCheckStateColor.Name,ALangKind);
  Self.rbColor1.Text:=GetLangString('ColorRadioButton',ALangKind);
  Self.rbColor2.Text:=GetLangString('ColorRadioButton',ALangKind);
  Self.rbColor3.Text:=GetLangString('ColorRadioButton',ALangKind);
  Self.rbColor4.Text:=GetLangString('ColorRadioButton',ALangKind);
  Self.rbColor5.Text:=GetLangString('ColorRadioButton',ALangKind);
  Self.rbColor6.Text:=GetLangString('ColorRadioButton',ALangKind);
  Self.rbColor7.Text:=GetLangString('ColorRadioButton',ALangKind);
  Self.rbColor8.Text:=GetLangString('ColorRadioButton',ALangKind);

end;

constructor TFrameRadioButton.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblCanSetCheckStatePicture.Name,[Self.lblCanSetCheckStatePicture.Text,'Can set picture of check state']);
  RegLangString('PictureCheckBox',['图片单选框','Picture RadioButton']);


  RegLangString(Self.lblCanSetCheckStateColor.Name,
    [Self.lblCanSetCheckStateColor.Text,'Can set color of check state']);
  RegLangString('ColorRadioButton',['颜色单选框','Color RadioButton']);


end;

end.
