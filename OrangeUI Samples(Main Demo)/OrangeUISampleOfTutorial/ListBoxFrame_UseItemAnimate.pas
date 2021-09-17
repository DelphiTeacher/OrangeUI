//convert pas to utf8 by ¥

unit ListBoxFrame_UseItemAnimate;

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
  uSkinImageList, uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer;

type
  TFrameListBox_UseItemAnimate = class(TFrame,IFrameChangeLanguageEvent)
    lbSimple: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    btnShowDetail: TSkinFMXButton;
    imlistLoading2: TSkinImageList;
    SkinFMXImage1: TSkinFMXImage;
    procedure btnShowDetailClick(Sender: TObject);
    procedure lbSimpleClickItem(AItem: TSkinItem);
    procedure ItemDefaultPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameListBox_UseItemAnimate.btnShowDetailClick(Sender: TObject);
begin
  if not Self.lbSimple.Prop.InteractiveItem.AnimateStarted then
  begin
    Self.lbSimple.Prop.InteractiveItem.AnimateItemBindingName:='ItemDetail1';
    Self.lbSimple.Prop.InteractiveItem.StartAnimate;
  end
  else
  begin
    Self.lbSimple.Prop.InteractiveItem.StopAnimate;
  end;
end;

procedure TFrameListBox_UseItemAnimate.ChangeLanguage(ALangKind: TLangKind);
begin

end;

constructor TFrameListBox_UseItemAnimate.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TFrameListBox_UseItemAnimate.ItemDefaultPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
begin
  //
end;

procedure TFrameListBox_UseItemAnimate.lbSimpleClickItem(AItem: TSkinItem);
begin
  ShowMessage(AItem.Caption);
end;

end.
