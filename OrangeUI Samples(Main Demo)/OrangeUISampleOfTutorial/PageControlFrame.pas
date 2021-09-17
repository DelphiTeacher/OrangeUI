//convert pas to utf8 by ¥

unit PageControlFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyNotifyNumberIcon, uSkinPageControlType,

  uVersion,
  uLang,
  uFrameContext,

  uSkinFireMonkeyPageControl, uSkinFireMonkeyControl,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyLabel,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, FMX.Controls.Presentation, uSkinFireMonkeyButton,
  uSkinButtonType, uSkinNotifyNumberIconType,
  uSkinScrollBoxContentType, uBaseSkinControl, uSkinScrollControlType,
  uSkinScrollBoxType;

type
  TFramePageControl = class(TFrame,IFrameChangeLanguageEvent)
    sbClient: TSkinFMXScrollBox;
    sbcContent: TSkinFMXScrollBoxContent;
    pcCommonStyle: TSkinFMXPageControl;
    nniMessage: TSkinFMXNotifyNumberIcon;
    tsContactor: TSkinFMXTabSheet;
    tsState: TSkinFMXTabSheet;
    tsSetting: TSkinFMXTabSheet;
    tsMessage: TSkinFMXTabSheet;
    pcColorStyle: TSkinFMXPageControl;
    tsNotice: TSkinFMXTabSheet;
    tsRule: TSkinFMXTabSheet;
    tsNew: TSkinFMXTabSheet;
    pcCenterCommonStyle: TSkinFMXPageControl;
    tsInspectGoods: TSkinFMXTabSheet;
    tsInspectFactory: TSkinFMXTabSheet;
    tsCalendar: TSkinFMXTabSheet;
    pcCenterColorStyle: TSkinFMXPageControl;
    SkinFMXTabSheet2: TSkinFMXTabSheet;
    SkinFMXTabSheet3: TSkinFMXTabSheet;
    SkinFMXTabSheet1: TSkinFMXTabSheet;
    lblPageControlCanSetColorOfTabHeaderAndTabButton: TLabel;
    lblPageControlCanSetTabButtonCenter: TLabel;
    pcCommonLeft: TSkinFMXPageControl;
    tsInspectGoods1: TSkinFMXTabSheet;
    tsInspectFactory1: TSkinFMXTabSheet;
    tsCalendar1: TSkinFMXTabSheet;
    pcCommonRight: TSkinFMXPageControl;
    tsInspectGoods2: TSkinFMXTabSheet;
    tsInspectFactory2: TSkinFMXTabSheet;
    tsCalendar2: TSkinFMXTabSheet;
    imglistTabIcon: TSkinImageList;
    lblTabSheetCanSetIconOfTwoStates: TLabel;
    lblTabSheetCanBindNotifyNumberIcon: TLabel;
    lblPageControlCanSetFontOfTwoStates: TLabel;
    lblPageControlCanSetTabButtonCenter1: TLabel;
    lblPageControlCanSetTabHeaderLeft: TLabel;
    lblPageControlCanSetTabHeaderRight: TLabel;
    SkinFMXNotifyNumberIcon2: TSkinFMXNotifyNumberIcon;
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


{ TFramePageControl }

procedure TFramePageControl.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblPageControlCanSetFontOfTwoStates.Text:=GetLangString(Self.lblPageControlCanSetFontOfTwoStates.Name,ALangKind);
  Self.lblTabSheetCanSetIconOfTwoStates.Text:=GetLangString(Self.lblTabSheetCanSetIconOfTwoStates.Name,ALangKind);
  Self.lblTabSheetCanBindNotifyNumberIcon.Text:=GetLangString(Self.lblTabSheetCanBindNotifyNumberIcon.Name,ALangKind);
  Self.tsMessage.Text:=GetLangString(Self.tsMessage.Name,ALangKind);
  Self.tsContactor.Text:=GetLangString(Self.tsContactor.Name,ALangKind);
  Self.tsState.Text:=GetLangString(Self.tsState.Name,ALangKind);
  Self.tsSetting.Text:=GetLangString(Self.tsSetting.Name,ALangKind);

  Self.lblPageControlCanSetColorOfTabHeaderAndTabButton.Text:=GetLangString(Self.lblPageControlCanSetColorOfTabHeaderAndTabButton.Name,ALangKind);
  Self.tsNew.Text:=GetLangString(Self.tsNew.Name,ALangKind);
  Self.tsNotice.Text:=GetLangString(Self.tsNotice.Name,ALangKind);
  Self.tsRule.Text:=GetLangString(Self.tsRule.Name,ALangKind);

  Self.lblPageControlCanSetTabButtonCenter.Text:=GetLangString(Self.lblPageControlCanSetTabButtonCenter.Name,ALangKind);
  Self.lblPageControlCanSetTabButtonCenter1.Text:=GetLangString(Self.lblPageControlCanSetTabButtonCenter1.Name,ALangKind);
  Self.tsCalendar.Text:=GetLangString(Self.tsCalendar.Name,ALangKind);
  Self.tsInspectGoods.Text:=GetLangString(Self.tsInspectGoods.Name,ALangKind);
  Self.tsInspectFactory.Text:=GetLangString(Self.tsInspectFactory.Name,ALangKind);

  Self.lblPageControlCanSetTabHeaderLeft.Text:=GetLangString(Self.lblPageControlCanSetTabHeaderLeft.Name,ALangKind);
  Self.lblPageControlCanSetTabHeaderRight.Text:=GetLangString(Self.lblPageControlCanSetTabHeaderRight.Name,ALangKind);
  Self.tsCalendar1.Text:=GetLangString(Self.tsCalendar.Name,ALangKind);
  Self.tsInspectGoods1.Text:=GetLangString(Self.tsInspectGoods.Name,ALangKind);
  Self.tsInspectFactory1.Text:=GetLangString(Self.tsInspectFactory.Name,ALangKind);
  Self.tsCalendar2.Text:=GetLangString(Self.tsCalendar.Name,ALangKind);
  Self.tsInspectGoods2.Text:=GetLangString(Self.tsInspectGoods.Name,ALangKind);
  Self.tsInspectFactory2.Text:=GetLangString(Self.tsInspectFactory.Name,ALangKind);

end;

constructor TFramePageControl.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblPageControlCanSetFontOfTwoStates.Name,[Self.lblPageControlCanSetFontOfTwoStates.Text,'PageControl can set font of two states']);
  RegLangString(Self.lblTabSheetCanSetIconOfTwoStates.Name,[Self.lblTabSheetCanSetIconOfTwoStates.Text,'TabSheet can set icon of two states']);
  RegLangString(Self.lblTabSheetCanBindNotifyNumberIcon.Name,[Self.lblTabSheetCanBindNotifyNumberIcon.Text,'TabSheet can bind NotifyNumberIcon']);
  RegLangString(Self.tsMessage.Name,[Self.tsMessage.Text,'Message']);
  RegLangString(Self.tsContactor.Name,[Self.tsContactor.Text,'Contactor']);
  RegLangString(Self.tsState.Name,[Self.tsState.Text,'State']);
  RegLangString(Self.tsSetting.Name,[Self.tsSetting.Text,'Setting']);

  RegLangString(Self.lblPageControlCanSetColorOfTabHeaderAndTabButton.Name,[Self.lblPageControlCanSetColorOfTabHeaderAndTabButton.Text,'PageControl can set color of TabHeader and TabButton']);
  RegLangString(Self.tsNew.Name,[Self.tsNew.Text,'New']);
  RegLangString(Self.tsNotice.Name,[Self.tsNotice.Text,'Notice']);
  RegLangString(Self.tsRule.Name,[Self.tsRule.Text,'Rule']);

  RegLangString(Self.lblPageControlCanSetTabButtonCenter.Name,[Self.lblPageControlCanSetTabButtonCenter.Text,'PageControl can set TabButton ceter']);
  RegLangString(Self.lblPageControlCanSetTabButtonCenter1.Name,[Self.lblPageControlCanSetTabButtonCenter1.Text,'PageControl can set TabButton ceter']);
  RegLangString(Self.tsCalendar.Name,[Self.tsCalendar.Text,'Calendar']);
  RegLangString(Self.tsInspectGoods.Name,[Self.tsInspectGoods.Text,'Goods']);
  RegLangString(Self.tsInspectFactory.Name,[Self.tsInspectFactory.Text,'Factory']);

  RegLangString(Self.lblPageControlCanSetTabHeaderLeft.Name,[Self.lblPageControlCanSetTabHeaderLeft.Text,'PageControl can set TabHeader left']);
  RegLangString(Self.lblPageControlCanSetTabHeaderRight.Name,[Self.lblPageControlCanSetTabHeaderRight.Text,'PageControl can set TabHeader right']);

end;

end.

