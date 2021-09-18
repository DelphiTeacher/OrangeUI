//convert pas to utf8 by ¥
unit ListItemStyleFrame_PetchipContent;

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
  uSkinImageListViewerType, uSkinFireMonkeyImageListViewer;

type
  TFramePetchipContentListItemStyle = class(TFrameBaseListItemStyle,IFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXMultiColorLabel;
    imglistviewItemBigPic: TSkinFMXImageListViewer;
    btnFocus: TSkinFMXButton;
    lblPetInfo: TSkinFMXMultiColorLabel;
    imglistFoot: TSkinImageList;
    imgPetHead: TSkinFMXImage;
    SkinFMXImage2: TSkinFMXImage;
    lbCommentList: TSkinFMXListBox;
    lblCommentCount: TSkinFMXLabel;
    pnlButtons: TSkinFMXPanel;
    btnTransmit: TSkinFMXButton;
    lbLikeList: TSkinFMXListBox;
    btnLikeState: TSkinFMXButton;
    btnComment: TSkinFMXButton;
    btnFocused: TSkinFMXButton;
    btnFavState: TSkinFMXButton;
    lblDelete: TSkinFMXLabel;
    imglistContent: TSkinImageList;
    pnlBottomBar: TSkinFMXPanel;
    bgIndicator: TSkinFMXButtonGroup;
    imgItemBigPic: TSkinFMXImage;
    btnPicCount: TSkinFMXButton;
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


constructor TFramePetchipContentListItemStyle.Create(AOwner: TComponent);
begin
  inherited;
  Self.imgItemBigPic.Prop.Picture.Clear;
end;

procedure TFramePetchipContentListItemStyle.lbCommentListGetItemBufferCacheTag(
  Sender: TObject; AItem: TSkinItem; var ACacheTag: Integer);
begin
  ACacheTag:=Integer(AItem);
end;

initialization
  RegisterListItemStyle('PetchipContent',TFramePetchipContentListItemStyle);


finalization
  UnRegisterListItemStyle(TFramePetchipContentListItemStyle);

end.
