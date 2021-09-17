//convert pas to utf8 by ¥

unit PanelFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects,

  uLang,
  uFrameContext,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinLabelType, uBaseSkinControl, uSkinPanelType;

type
  TFramePanel = class(TFrame,IFrameChangeLanguageEvent)
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXPanel5: TSkinFMXPanel;
    SkinFMXPanel6: TSkinFMXPanel;
    SkinFMXPanel7: TSkinFMXPanel;
    SkinFMXPanel8: TSkinFMXPanel;
    SkinFMXPanel9: TSkinFMXPanel;
    lblBorder_1_No_Fill: TSkinFMXLabel;
    lblBorder_1_Fill: TSkinFMXLabel;
    lblBorder_2_No_Fill: TSkinFMXLabel;
    lblBorder_2_Fill: TSkinFMXLabel;
    lblRound_Border_2_No_Fill: TSkinFMXLabel;
    lblRound_Border_2_Fill: TSkinFMXLabel;
    lblRound_Border_1_No_Fill: TSkinFMXLabel;
    lblRound_Border_1_Fill: TSkinFMXLabel;
    lblPanelIsLine: TSkinFMXLabel;
    lblPanelHeight1_Fill: TSkinFMXLabel;
    SkinFMXPanel11: TSkinFMXPanel;
    SkinFMXPanel10: TSkinFMXPanel;
    lblPanelIsRound: TSkinFMXLabel;
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

{ TFramePanel }

procedure TFramePanel.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblBorder_1_No_Fill.Text:=GetLangString(Self.lblBorder_1_No_Fill.Name,ALangKind);
  Self.lblRound_Border_1_No_Fill.Text:=GetLangString(Self.lblRound_Border_1_No_Fill.Name,ALangKind);

  Self.lblBorder_1_Fill.Text:=GetLangString(Self.lblBorder_1_Fill.Name,ALangKind);
  Self.lblRound_Border_1_Fill.Text:=GetLangString(Self.lblRound_Border_1_Fill.Name,ALangKind);

  Self.lblBorder_2_No_Fill.Text:=GetLangString(Self.lblBorder_2_No_Fill.Name,ALangKind);
  Self.lblRound_Border_2_No_Fill.Text:=GetLangString(Self.lblRound_Border_2_No_Fill.Name,ALangKind);

  Self.lblBorder_2_Fill.Text:=GetLangString(Self.lblBorder_2_Fill.Name,ALangKind);
  Self.lblRound_Border_2_Fill.Text:=GetLangString(Self.lblRound_Border_2_Fill.Name,ALangKind);

  Self.lblPanelIsLine.Text:=GetLangString(Self.lblPanelIsLine.Name,ALangKind);
  Self.lblPanelHeight1_Fill.Text:=GetLangString(Self.lblPanelHeight1_Fill.Name,ALangKind);

  Self.lblPanelIsRound.Text:=GetLangString(Self.lblPanelIsRound.Name,ALangKind);


end;

constructor TFramePanel.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblBorder_1_No_Fill.Name,[Self.lblBorder_1_No_Fill.Text,
          'Border 1px,no fill']);
  RegLangString(Self.lblRound_Border_1_No_Fill.Name,[Self.lblRound_Border_1_No_Fill.Text,
          'Round,Border 1px,no fill']);

  RegLangString(Self.lblBorder_1_Fill.Name,[Self.lblBorder_1_Fill.Text,
          'Border 1px,fill']);
  RegLangString(Self.lblRound_Border_1_Fill.Name,[Self.lblRound_Border_1_Fill.Text,
          'Round,Border 1px,fill']);

  RegLangString(Self.lblBorder_2_No_Fill.Name,[Self.lblBorder_2_No_Fill.Text,
          'Border 2px,no fill']);
  RegLangString(Self.lblRound_Border_2_No_Fill.Name,[Self.lblRound_Border_2_No_Fill.Text,
          'Round,Border 2px,no fill']);

  RegLangString(Self.lblBorder_2_Fill.Name,[Self.lblBorder_2_Fill.Text,
          'Border 2px,fill']);
  RegLangString(Self.lblRound_Border_2_Fill.Name,[Self.lblRound_Border_2_Fill.Text,
          'Round,Border 2px,fill']);

  RegLangString(Self.lblPanelIsLine.Name,[Self.lblPanelIsLine.Text,
          'Set IsLine as true']);
  RegLangString(Self.lblPanelHeight1_Fill.Name,[Self.lblPanelHeight1_Fill.Text,
          'Set panel''s height as 1px']);

  RegLangString(Self.lblPanelIsRound.Name,[Self.lblPanelIsRound.Text,
          'Set RoundWidth、RoundHeight as -1']);

end;

end.
