//convert pas to utf8 by ¥

unit ListBoxFrame_UseListItemStyleFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,

  uDrawCanvas,
  ListItemStyleFrame_IconCaption,

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
  TFrameListBox_UseListItemStyleFrame = class(TFrame,IFrameChangeLanguageEvent)
    lbSimple: TSkinFMXListBox;
    Label1: TLabel;
    procedure btnShowDetailClick(Sender: TObject);
    procedure lbSimpleClickItem(AItem: TSkinItem);
    procedure ItemDefaultPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
    procedure chkDetail2Click(Sender: TObject);
    procedure lbSimpleNewListItemStyleFrameCacheInit(Sender: TObject;
      AListItemTypeStyleSetting: TListItemTypeStyleSetting;
      ANewListItemStyleFrameCache: TListItemStyleFrameCache);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameListBox_UseListItemStyleFrame.btnShowDetailClick(Sender: TObject);
begin
  ShowMessage(Self.lbSimple.Prop.InteractiveItem.Detail);
end;

procedure TFrameListBox_UseListItemStyleFrame.ChangeLanguage(ALangKind: TLangKind);
begin
end;

procedure TFrameListBox_UseListItemStyleFrame.chkDetail2Click(Sender: TObject);
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

constructor TFrameListBox_UseListItemStyleFrame.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TFrameListBox_UseListItemStyleFrame.ItemDefaultPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
begin
  //
end;

procedure TFrameListBox_UseListItemStyleFrame.lbSimpleClickItem(AItem: TSkinItem);
begin
  ShowMessage(AItem.Caption);
end;

procedure TFrameListBox_UseListItemStyleFrame.lbSimpleNewListItemStyleFrameCacheInit(
  Sender: TObject; AListItemTypeStyleSetting: TListItemTypeStyleSetting;
  ANewListItemStyleFrameCache: TListItemStyleFrameCache);
begin
  //列表项样式Frame初始事件
  //初始标题颜色
  TFrameIconCaptionListItemStyle(ANewListItemStyleFrameCache.FItemStyleFrame).lblItemCaption.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
end;

end.
