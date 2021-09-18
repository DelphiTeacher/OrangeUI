//convert pas to utf8 by ¥
unit ListItemStyleFrame_LiveStream;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uGraphicCommon,
  uSkinItems,
  uSkinBufferBitmap,
  BaseListItemStyleFrame,
  ListItemStyleFrame_Comment,


  uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinButtonType,
  uSkinFireMonkeyButton, uDrawCanvas, uDrawPicture, uSkinImageList,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinMaterial,
  FMX.Controls.Presentation, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinImageListViewerType, uSkinFireMonkeyImageListViewer, uSkinRoundImageType,
  uSkinFireMonkeyRoundImage, uSkinListViewType, uSkinRegExTagLabelViewType;

type
  TFrameListItemStyle_LiveStream = class(TFrameBaseListItemStyle,IFrameBaseListItemStyle)
    lblItemDetail: TSkinFMXMultiColorLabel;
    btnFocus: TSkinFMXButton;
    pnlButtons: TSkinFMXPanel;
    btnTransmit: TSkinFMXButton;
    btnLikeState: TSkinFMXButton;
    btnComment: TSkinFMXButton;
    btnFocused: TSkinFMXButton;
    btnFavState: TSkinFMXButton;
    lblDelete: TSkinFMXLabel;
    btnPicCount: TSkinFMXButton;
    SkinFMXMultiColorLabel1: TSkinFMXLabel;
    imgItemBigPic: TSkinFMXRoundImage;
    lblItemCaptionRegEx: TSkinRegExTagLabelView;
    lblItemDetail1: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    SkinFMXLabel2: TSkinFMXLabel;
    btnReadCount: TSkinFMXButton;
    procedure lbCommentListGetItemBufferCacheTag(Sender: TObject;
      AItem: TSkinItem; var ACacheTag: Integer);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


implementation

{$R *.fmx}


constructor TFrameListItemStyle_LiveStream.Create(AOwner: TComponent);
begin
  inherited;
  Self.imgItemBigPic.Prop.Picture.Clear;
  Self.lblItemCaption.BringToFront;
end;

procedure TFrameListItemStyle_LiveStream.lbCommentListGetItemBufferCacheTag(
  Sender: TObject; AItem: TSkinItem; var ACacheTag: Integer);
begin
  ACacheTag:=Integer(AItem);
end;

initialization
  RegisterListItemStyle('LiveStream',TFrameListItemStyle_LiveStream);


finalization
  UnRegisterListItemStyle(TFrameListItemStyle_LiveStream);

end.
