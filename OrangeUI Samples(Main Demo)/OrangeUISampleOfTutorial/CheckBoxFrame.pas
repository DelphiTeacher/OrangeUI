//convert pas to utf8 by ¥

unit CheckBoxFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uVersion,
  uLang,
  uFrameContext,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyCheckBox,
  uSkinFireMonkeySwitch, FMX.Controls.Presentation, uBaseSkinControl,
  uSkinCheckBoxType;

type
  TFrameCheckBox = class(TFrame,IFrameChangeLanguageEvent)
    chkPicture1: TSkinFMXCheckBox;
    SkinFMXCheckBox2: TSkinFMXCheckBox;
    chkColor1: TSkinFMXCheckBox;
    chkColor5: TSkinFMXCheckBox;
    lblCanSetCheckStatePicture: TLabel;
    lblCanSetCheckStateColor: TLabel;
    lblCanSetCheckStatePictureOnly: TLabel;
    chkColor7: TSkinFMXCheckBox;
    chkColor3: TSkinFMXCheckBox;
    chkPicture2: TSkinFMXCheckBox;
    chkColor2: TSkinFMXCheckBox;
    chkColor6: TSkinFMXCheckBox;
    chkColor8: TSkinFMXCheckBox;
    chkColor4: TSkinFMXCheckBox;
    SkinFMXCheckBox8: TSkinFMXCheckBox;
    SkinFMXCheckBox1: TSkinFMXCheckBox;
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

{ TFrameCheckBox }


procedure TFrameCheckBox.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblCanSetCheckStatePicture.Text:=GetLangString(Self.lblCanSetCheckStatePicture.Name,ALangKind);
  Self.chkPicture1.Text:=GetLangString('PictureCheckBox',ALangKind);
  Self.chkPicture2.Text:=GetLangString('PictureCheckBox',ALangKind);

  Self.lblCanSetCheckStateColor.Text:=GetLangString(Self.lblCanSetCheckStateColor.Name,ALangKind);
  Self.chkColor1.Text:=GetLangString('ColorCheckBox',ALangKind);
  Self.chkColor2.Text:=GetLangString('ColorCheckBox',ALangKind);
  Self.chkColor3.Text:=GetLangString('ColorCheckBox',ALangKind);
  Self.chkColor4.Text:=GetLangString('ColorCheckBox',ALangKind);
  Self.chkColor5.Text:=GetLangString('ColorCheckBox',ALangKind);
  Self.chkColor6.Text:=GetLangString('ColorCheckBox',ALangKind);
  Self.chkColor7.Text:=GetLangString('ColorCheckBox',ALangKind);
  Self.chkColor8.Text:=GetLangString('ColorCheckBox',ALangKind);

  Self.lblCanSetCheckStatePictureOnly.Text:=GetLangString(Self.lblCanSetCheckStatePictureOnly.Name,ALangKind);

end;

constructor TFrameCheckBox.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblCanSetCheckStatePicture.Name,[Self.lblCanSetCheckStatePicture.Text,'Can set picture of check state']);
  RegLangString('PictureCheckBox',['图片复选框','Picture CheckBox']);

  RegLangString(Self.lblCanSetCheckStateColor.Name,
    [Self.lblCanSetCheckStateColor.Text,'Can set color of check state']);
  RegLangString('ColorCheckBox',['颜色复选框','Color CheckBox']);

  RegLangString(Self.lblCanSetCheckStatePictureOnly.Name,
    [Self.lblCanSetCheckStatePictureOnly.Text,'Can set picture of check state only']);

end;

end.
