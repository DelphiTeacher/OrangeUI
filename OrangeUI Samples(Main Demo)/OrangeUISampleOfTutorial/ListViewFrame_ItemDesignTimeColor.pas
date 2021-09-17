//convert pas to utf8 by ¥

unit ListViewFrame_ItemDesignTimeColor;

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
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel;

type
  TFrameListView_ItemDesignTimeColor = class(TFrame,IFrameChangeLanguageEvent)
    SkinFMXListBox1: TSkinFMXListView;
    SkinFMXListView1: TSkinFMXListView;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
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

{ TFrameListView_ItemDesignTimeColor }

procedure TFrameListView_ItemDesignTimeColor.ChangeLanguage(ALangKind: TLangKind);
begin

end;

constructor TFrameListView_ItemDesignTimeColor.Create(
  AOwner: TComponent);
begin
  inherited;

end;

end.

