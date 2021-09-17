//convert pas to utf8 by ¥

unit ListViewFrame_UseItemDesignerPanel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

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
  uSkinFireMonkeyNotifyNumberIcon;

type
  TFrameListView_UseItemDesignerPanel = class(TFrame,IFrameChangeLanguageEvent)
    SkinFMXListView1: TSkinFMXListView;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXNotifyNumberIcon1: TSkinFMXNotifyNumberIcon;
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

{ TFrameListView_UseItemDesignerPanel }

procedure TFrameListView_UseItemDesignerPanel.ChangeLanguage(ALangKind: TLangKind);
begin

end;

constructor TFrameListView_UseItemDesignerPanel.Create(
  AOwner: TComponent);
begin
  inherited;

end;

end.

