//convert pas to utf8 by ¥
unit ListItemStyleFrame_ContentSuggestNews;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uGraphicCommon,
  uSkinItems,
  uSkinBufferBitmap,
  BaseListItemStyleFrame,
  ListItemStyleFrame_Comment,
  EasyServiceCommonMaterialDataMoudle,


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
  TFrameContentSuggestNewsListItemStyle = class(TFrameBaseListItemStyle,IFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
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
    btnReadCount: TSkinFMXButton;
    imglistBestAndTop: TSkinImageList;
    lblItemDetail: TSkinFMXLabel;
    imgItemPlay: TSkinFMXImage;
    btnAttend: TSkinFMXButton;
    pnlDevide: TSkinFMXPanel;
    imgUserHead1: TSkinFMXImage;
    lblAttendInfo: TSkinFMXLabel;
    imgUserHead2: TSkinFMXImage;
    imgUserHead3: TSkinFMXImage;
    procedure lbCommentListGetItemBufferCacheTag(Sender: TObject;
      AItem: TSkinItem; var ACacheTag: Integer);
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;



implementation



{$R *.fmx}


constructor TFrameContentSuggestNewsListItemStyle.Create(AOwner: TComponent);
begin
  inherited;
  Self.imgItemBigPic.Prop.Picture.Clear;


  imgUserHead1.Prop.Picture.Clear;
  imgUserHead2.Prop.Picture.Clear;
  imgUserHead3.Prop.Picture.Clear;


end;

procedure TFrameContentSuggestNewsListItemStyle.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
var
  ALeft:Double;
begin
  inherited;

  //视频是否显示
  imgItemPlay.Visible:=(AItem.SubItems.Values['is_video']='1');


  imgUserHead1.Visible:=(AItem.SubItems.Values['user1_head_pic_path']<>'');
  imgUserHead1.Prop.Picture.Url:=AItem.SubItems.Values['user1_head_pic_path'];

  imgUserHead2.Visible:=(AItem.SubItems.Values['user2_head_pic_path']<>'');
  imgUserHead2.Prop.Picture.Url:=AItem.SubItems.Values['user2_head_pic_path'];

  imgUserHead3.Visible:=(AItem.SubItems.Values['user3_head_pic_path']<>'');
  imgUserHead3.Prop.Picture.Url:=AItem.SubItems.Values['user3_head_pic_path'];

  if imgUserHead3.Visible then
  begin
    ALeft:=imgUserHead3.Left+imgUserHead3.Width;
  end
  else if imgUserHead2.Visible then
  begin
    ALeft:=imgUserHead2.Left+imgUserHead1.Width;
  end
  else if imgUserHead1.Visible then
  begin
    ALeft:=imgUserHead1.Left+imgUserHead1.Width;
  end;

  Self.lblAttendInfo.Left:=ALeft;
  Self.lblAttendInfo.Width:=pnlButtons.Left-Self.lblAttendInfo.Left;



  //AItem.IsBufferNeedChange:=True;

end;

procedure TFrameContentSuggestNewsListItemStyle.lbCommentListGetItemBufferCacheTag(
  Sender: TObject; AItem: TSkinItem; var ACacheTag: Integer);
begin
  ACacheTag:=Integer(AItem);
end;

initialization
  RegisterListItemStyle('ContentSuggestNews',TFrameContentSuggestNewsListItemStyle,105,False);


finalization
  UnRegisterListItemStyle(TFrameContentSuggestNewsListItemStyle);

end.
