//convert pas to utf8 by ¥

unit ListViewFrame_UseListItemStyleFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  ListItemStyleFrame_IconTopCenter_CaptionBottomCenterBlack,

  uLang,
  uFrameContext,
  uSkinItems,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyListView,
  uSkinFireMonkeyCustomList, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType, uDrawCanvas,
  uSkinListBoxType, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinImageType,
  uSkinFireMonkeyImage, uSkinButtonType, uSkinNotifyNumberIconType,
  uSkinFireMonkeyNotifyNumberIcon, FMX.Controls.Presentation;

type
  TFrameListView_UseListItemStyleFrame = class(TFrame,IFrameChangeLanguageEvent)
    SkinFMXListView1: TSkinFMXListView;

    Label1: TLabel;  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListView_UseListItemStyleFrame }

procedure TFrameListView_UseListItemStyleFrame.ChangeLanguage(ALangKind: TLangKind);
begin

end;

constructor TFrameListView_UseListItemStyleFrame.Create(
  AOwner: TComponent);
begin
  inherited;

end;

end.

