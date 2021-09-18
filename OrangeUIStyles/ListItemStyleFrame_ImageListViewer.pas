//convert pas to utf8 by ¥
unit ListItemStyleFrame_ImageListViewer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uDrawCanvas,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,


  ListItemStyleFrame_Base,
  uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uDrawPicture, uSkinImageList,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinScrollControlType,
  uSkinImageListViewerType, uSkinFireMonkeyImageListViewer, uSkinPanelType,
  uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameImageListViewerListItemStyle = class(TFrameBaseListItemStyleBase,IFrameBaseListItemStyle)
    imgPlayer: TSkinFMXImageListViewer;
    bgIndicator: TSkinFMXButtonGroup;
    imglistPlayer: TSkinImageList;
    pnlBottomBar: TSkinFMXPanel;
    imgBackground: TSkinFMXImage;
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

//uses
//  uSkinCustomListType;

constructor TFrameImageListViewerListItemStyle.Create(AOwner: TComponent);
begin
  inherited;

  imglistPlayer.PictureList.Clear(True);

//  imgPlayer.Material.IsDrawClipRound:=False;
//  imgPlayer.Prop.Picture.ClipRoundXRadis:=20;
//  imgPlayer.Prop.Picture.ClipRoundYRadis:=20;
//  imgPlayer.Prop.Picture.IsClipRound:=True;

end;

procedure TFrameImageListViewerListItemStyle.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
var
  I:Integer;
  ADrawPicture:TDrawPicture;
begin
  inherited;
  //加载
  //图片列表的Url保存在Item.SubItems中


//  if AItem.SubItems.Count>0 then
//  begin
    imglistPlayer.PictureList.Clear(True);
    //广告图片轮播
    for I := 0 to AItem.SubItems.Count-1 do
    begin
      ADrawPicture:=Self.imglistPlayer.PictureList.Add;
      ADrawPicture.Url:=AItem.SubItems[I];
//      ADrawPicture.ClipRoundXRadis:=30;
//      ADrawPicture.ClipRoundYRadis:=30;
//      ADrawPicture.IsClipRound:=True;
      //立即下载
      ADrawPicture.WebUrlPicture;
    end;
    Self.imgPlayer.Prop.Picture.ImageIndex:=0;
//  end;

end;




initialization
  RegisterListItemStyle('ImageListViewer',TFrameImageListViewerListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameImageListViewerListItemStyle);

end.
