//convert pas to utf8 by ¥

unit NotifyNumberIconFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyNotifyNumberIcon,

  uLang,
  uFrameContext,
  uSkinMaterial, uSkinNotifyNumberIconType, uSkinFireMonkeyLabel,
  FMX.Controls.Presentation, uSkinFireMonkeyButton, uBaseSkinControl,
  uSkinButtonType;

type
  TFrameNotifyNumberIcon = class(TFrame,IFrameChangeLanguageEvent)
    SkinFMXNotifyNumberIcon3: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon12: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon13: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon14: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon15: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon16: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon17: TSkinFMXNotifyNumberIcon;
    lblNotifyCanSetNotifyIcon: TLabel;
    lblNotifyCanSetBackgroudPicture: TLabel;
    nniUnRead1: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon2: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon4: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon5: TSkinFMXNotifyNumberIcon;
    lblNotifyCanSetNotifyColor: TLabel;
    lblNitifyNumberCenter: TLabel;
    lblNotifyPicLeft: TLabel;
    SkinFMXNotifyNumberIcon1: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon6: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon7: TSkinFMXNotifyNumberIcon;
    lblNotifyPicCenter: TLabel;
    SkinFMXNotifyNumberIcon8: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon9: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon10: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon11: TSkinFMXNotifyNumberIcon;
    lblNotifyPicRight: TLabel;
    lblNotifyCanDrawNumberByPicturePosition: TLabel;
    SkinFMXNotifyNumberIcon18: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon19: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon20: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon21: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon22: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon23: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon24: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon25: TSkinFMXNotifyNumberIcon;
    SkinFMXNotifyNumberIcon26: TSkinFMXNotifyNumberIcon;
  private
    { Private declarations }
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameNotifyNumberIcon }

procedure TFrameNotifyNumberIcon.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblNotifyCanSetNotifyColor.Text:=GetLangString(Self.lblNotifyCanSetNotifyColor.Name,ALangKind);
  Self.lblNitifyNumberCenter.Text:=GetLangString(Self.lblNitifyNumberCenter.Name,ALangKind);

  Self.lblNotifyCanSetBackgroudPicture.Text:=GetLangString(Self.lblNotifyCanSetBackgroudPicture.Name,ALangKind);
  Self.lblNotifyCanDrawNumberByPicturePosition.Text:=GetLangString(Self.lblNotifyCanDrawNumberByPicturePosition.Name,ALangKind);
  Self.lblNotifyPicRight.Text:=GetLangString(Self.lblNotifyPicRight.Name,ALangKind);
  Self.lblNotifyPicCenter.Text:=GetLangString(Self.lblNotifyPicCenter.Name,ALangKind);
  Self.lblNotifyPicLeft.Text:=GetLangString(Self.lblNotifyPicLeft.Name,ALangKind);

  Self.lblNotifyCanSetNotifyIcon.Text:=GetLangString(Self.lblNotifyCanSetNotifyIcon.Name,ALangKind);

end;

constructor TFrameNotifyNumberIcon.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblNotifyCanSetNotifyColor.Name,
        [Self.lblNotifyCanSetNotifyColor.Text,
        'Can set color of notify']);
  RegLangString(Self.lblNitifyNumberCenter.Name,
        [Self.lblNitifyNumberCenter.Text,
        'number center']);

  RegLangString(Self.lblNotifyCanSetBackgroudPicture.Name,
        [Self.lblNotifyCanSetBackgroudPicture.Text,
        'Can set background picture of notify']);
  RegLangString(Self.lblNotifyCanDrawNumberByPicturePosition.Name,
        [Self.lblNotifyCanDrawNumberByPicturePosition.Text,
        'Can draw number at position of picture']);
  RegLangString(Self.lblNotifyPicRight.Name,
        [Self.lblNotifyPicRight.Text,
        'picture right']);
  RegLangString(Self.lblNotifyPicCenter.Name,
        [Self.lblNotifyPicCenter.Text,
        'picture center']);
  RegLangString(Self.lblNotifyPicLeft.Name,
        [Self.lblNotifyPicLeft.Text,
        'picture left']);


  RegLangString(Self.lblNotifyCanSetNotifyIcon.Name,
        [Self.lblNotifyCanSetNotifyIcon.Text,
        'Can set icon of notify']);


end;

end.
