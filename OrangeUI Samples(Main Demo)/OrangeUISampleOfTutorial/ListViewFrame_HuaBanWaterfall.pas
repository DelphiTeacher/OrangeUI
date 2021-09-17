//convert pas to utf8 by ¥

unit ListViewFrame_HuaBanWaterfall;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyLabel,

  uLang,
  uFrameContext,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyListView, uSkinFireMonkeyImage, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel,
  uSkinItems,
  uDrawCanvas,
  uSkinImageList, FMX.TabControl, uSkinFireMonkeyButton, uSkinFireMonkeyPanel,
  uDrawPicture, uSkinFireMonkeyVirtualList, uSkinFireMonkeyRoundImage,
  uSkinFireMonkeyCustomList, uSkinLabelType, uSkinPanelType, uSkinImageType,
  uSkinRoundImageType, uSkinItemDesignerPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType;

type
  TFrameListView_HuaBanWaterfall = class(TFrame,IFrameChangeLanguageEvent)
    lvHuaBan: TSkinFMXListView;
    idpHuaBan: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXRoundImage;
    pnlItemInfo: TSkinFMXPanel;
    imgItemPic: TSkinFMXRoundImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
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


{ TFrameListView_HuaBanWaterfall }

procedure TFrameListView_HuaBanWaterfall.ChangeLanguage(ALangKind: TLangKind);
begin

end;

constructor TFrameListView_HuaBanWaterfall.Create(AOwner: TComponent);
begin
  inherited;

end;

end.
