//convert pas to utf8 by ¥

unit MemoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,


  uLang,
  uFrameContext,

  {$IFDEF VER290}
  FMX.ScrollBox,
  {$ENDIF}
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Layouts, FMX.Memo, uSkinFireMonkeyMemo,
  FMX.Controls.Presentation, FMX.ScrollBox;

type
  TFrameMemo = class(TFrame,IFrameChangeLanguageEvent)
    memBackgroundPictureAndHelpText: TSkinFMXMemo;
    memContent: TSkinFMXMemo;
    lblMemoCanSetBackgroundPicture: TLabel;
    lblMemoCanSetHelpText: TLabel;
    lblMemoCanSetBackColorAndBorder: TLabel;
    SkinFMXMemo1: TSkinFMXMemo;
    SkinFMXMemo2: TSkinFMXMemo;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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


{ TFrameMemo }

procedure TFrameMemo.Button1Click(Sender: TObject);
begin
  if SkinFMXMemo2.GetStyleEdit<>nil then
  begin
    SkinFMXMemo2.GetStyleEdit.BringToFront;
    SkinFMXMemo2.GetStyleEdit.RePaint;
  end;
end;

procedure TFrameMemo.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblMemoCanSetBackgroundPicture.Text:=GetLangString(Self.lblMemoCanSetBackgroundPicture.Name,ALangKind);
  Self.lblMemoCanSetHelpText.Text:=GetLangString(Self.lblMemoCanSetHelpText.Name,ALangKind);
  Self.lblMemoCanSetBackColorAndBorder.Text:=GetLangString(Self.lblMemoCanSetBackColorAndBorder.Name,ALangKind);

end;

constructor TFrameMemo.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblMemoCanSetBackgroundPicture.Name,
      [Self.lblMemoCanSetBackgroundPicture.Text,
      'Can set background picture']);
  RegLangString(Self.lblMemoCanSetHelpText.Name,
      [Self.lblMemoCanSetHelpText.Text,
      'Can set help text']);

  RegLangString(Self.lblMemoCanSetBackColorAndBorder.Name,
      [Self.lblMemoCanSetBackColorAndBorder.Text,
      'Can set background color and border']);


  //  Self.Label1.SendToBack;
  if SkinFMXMemo2.GetStyleEdit<>nil then
  begin
    SkinFMXMemo2.GetStyleEdit.BringToFront;
    SkinFMXMemo2.GetStyleEdit.RePaint;
  end;


end;

end.
