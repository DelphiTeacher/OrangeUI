//convert pas to utf8 by ¥

unit ListBoxFrame_UseItemDesignerPanel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,

  uDrawCanvas,

  uFrameContext,
  uLang,
  uSkinItems,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyButton, uSkinFireMonkeyPanel, FMX.Controls.Presentation,
  uSkinFireMonkeyCustomList, uSkinButtonType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uDrawPicture,
  uSkinImageList, uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer,
  uSkinCalloutRectType, uSkinCheckBoxType, uSkinFireMonkeyCheckBox;

type
  TFrameListBox_UseItemDesignerPanel = class(TFrame,IFrameChangeLanguageEvent)
    lbSimple: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    btnShowDetail: TSkinFMXButton;
    SkinFMXCalloutRect1: TSkinFMXCalloutRect;
    btnOK1: TSkinFMXButton;
    chkDetail2: TSkinFMXCheckBox;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    procedure btnShowDetailClick(Sender: TObject);
    procedure lbSimpleClickItem(AItem: TSkinItem);
    procedure ItemDefaultPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
    procedure chkDetail2Click(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameListBox_UseItemDesignerPanel.btnShowDetailClick(Sender: TObject);
begin
  ShowMessage(Self.lbSimple.Prop.InteractiveItem.Detail);
end;

procedure TFrameListBox_UseItemDesignerPanel.ChangeLanguage(ALangKind: TLangKind);
begin
end;

procedure TFrameListBox_UseItemDesignerPanel.chkDetail2Click(Sender: TObject);
begin
  if Self.lbSimple.Prop.InteractiveItem.Detail2='1' then
  begin
    Self.lbSimple.Prop.InteractiveItem.Detail2:='0'
  end
  else
  begin
    Self.lbSimple.Prop.InteractiveItem.Detail2:='1'
  end;
end;

constructor TFrameListBox_UseItemDesignerPanel.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TFrameListBox_UseItemDesignerPanel.ItemDefaultPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
begin
  //
end;

procedure TFrameListBox_UseItemDesignerPanel.lbSimpleClickItem(AItem: TSkinItem);
begin
  ShowMessage(AItem.Caption);
end;

end.
