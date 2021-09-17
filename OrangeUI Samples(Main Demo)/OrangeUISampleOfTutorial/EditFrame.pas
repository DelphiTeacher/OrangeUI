//convert pas to utf8 by ¥

unit EditFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Edit, uSkinFireMonkeyEdit,
  FMX.Controls.Presentation, FMX.Layouts, uSkinFireMonkeyControl,

  uLang,
  uFrameContext,
  uUIFunction,
  uSkinFireMonkeyPanel, uSkinFireMonkeyImage, uDrawPicture, uSkinImageList,
  uSkinMaterial, uSkinEditType;

type
  TFrameEdit = class(TFrame,IFrameChangeLanguageEvent)
    edtBackColor: TSkinFMXEdit;
    btnClearPass: TClearEditButton;
    ClearEditButton3: TClearEditButton;
    edtBackgroundPictureAndHelpText: TSkinFMXEdit;
    ClearEditButton2: TClearEditButton;
    edtBackgroundPictureAndHelpIcon: TSkinFMXEdit;
    ClearEditButton4: TClearEditButton;
    edtBackColor1: TSkinFMXEdit;
    lblEditCanSetBackgroundPicture: TLabel;
    lblEditCanSetHelpText: TLabel;
    lblEditCanSetHelpIcon: TLabel;
    lblEditCanSetBackColorAndBorder: TLabel;
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameEdit }

{ TFrameEdit }

procedure TFrameEdit.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblEditCanSetBackgroundPicture.Text:=GetLangString(Self.lblEditCanSetBackgroundPicture.Name,ALangKind);
  Self.lblEditCanSetHelpText.Text:=GetLangString(Self.lblEditCanSetHelpText.Name,ALangKind);
  Self.lblEditCanSetHelpIcon.Text:=GetLangString(Self.lblEditCanSetHelpIcon.Name,ALangKind);
  Self.lblEditCanSetBackColorAndBorder.Text:=GetLangString(Self.lblEditCanSetBackColorAndBorder.Name,ALangKind);

end;

constructor TFrameEdit.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblEditCanSetBackgroundPicture.Name,
      [Self.lblEditCanSetBackgroundPicture.Text,
      'Can set background picture']);
  RegLangString(Self.lblEditCanSetHelpText.Name,
      [Self.lblEditCanSetHelpText.Text,
      'Can set help text']);

  RegLangString(Self.lblEditCanSetHelpIcon.Name,
      [Self.lblEditCanSetHelpIcon.Text,
      'Can set help icon']);

  RegLangString(Self.lblEditCanSetBackColorAndBorder.Name,
      [Self.lblEditCanSetBackColorAndBorder.Text,
      'Can set background color and border']);

end;

end.
