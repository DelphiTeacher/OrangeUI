//convert pas to utf8 by ¥
unit ListItemStyleFrame_WorkOrderContent;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uGraphicCommon,
  uSkinItems,
  uSkinBufferBitmap,
  XSuperObject,
  uSkinItemJsonHelper,
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
  TFrameWorkOrderContentListItemStyle = class(TFrameBaseListItemStyle,IFrameBaseListItemStyle)
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
    imgItemBigPic: TSkinFMXRoundImage;
    lblItemCaptionRegEx: TSkinRegExTagLabelView;
    btnReadCount: TSkinFMXButton;
    lblItemDetail: TSkinFMXLabel;
    SkinFMXMultiColorLabel1: TSkinFMXLabel;
    lblAuthor: TSkinFMXLabel;
    lblCreatetime: TSkinFMXLabel;
    lblProcess: TSkinFMXLabel;
    lblComment: TSkinFMXLabel;
    imgError: TSkinFMXImage;
    labErrorHint: TSkinFMXLabel;
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


constructor TFrameWorkOrderContentListItemStyle.Create(AOwner: TComponent);
begin
  inherited;
  Self.imgItemBigPic.Prop.Picture.Clear;
  //Self.imgItemBigPic.Material.IsDrawClipRound:=False;

  lblItemCaption.Text:='';

end;

procedure TFrameWorkOrderContentListItemStyle.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
var
//  Self:TFrameDelphiContentListItemStyle;
//  I: Integer;
  AItemDataJson:ISuperObject;
  APicCount:Integer;
//  APicturesHeight:Double;
  AContentHeight:Double;
//  AOneLineHeight:Double;
//  AIsLongContent:Boolean;
//  ADrawPicture:TDrawPicture;
//  AComment:String;
//  AStr:String;
//  AContentHeight:Double;
begin

  inherited;


  if AItem.DataObject=nil then Exit;
  if TSkinItemJsonObject(AItem.DataObject).Json=nil then Exit;

  AItemDataJson:=GetItemJsonObject(AItem).Json;



      Self.btnFocus.Visible:=False;
      Self.btnFocused.Visible:=False;


      //内容
      if AItem.Detail4<>'' then
      begin

          Self.lblItemCaptionRegEx.Text:=AItem.Detail4;
          Self.lblItemCaption.Text:=AItem.Detail4;

          //没有链接
          Self.lblItemCaptionRegEx.Visible:=False;
          Self.lblItemCaption.Visible:=True;
          AContentHeight:=
                  uSkinBufferBitmap.GetStringHeight(AItem.Detail4,
                      RectF(0,0,Self.lblItemCaptionRegEx.Width,MaxInt),
                      Self.lblItemCaption.Material.DrawCaptionParam);
//          Self.lblItemCaption.Height:=AContentHeight;

      end
      else
      begin
            //没有文本内容
            AContentHeight:=0;
      end;
      //弥补误差
      Self.lblItemCaptionRegEx.Height:=AContentHeight+5;
      Self.lblItemCaption.Height:=AContentHeight+5;




      //单图模式
      Self.imgItemBigPic.Visible:=True;
      //第一张图片的尺寸
      //APicturesHeight:=90;
      //Self.imgItemBigPic.Height:=APicturesHeight;

      //显示图片数量
      APicCount:=Ord(AItemDataJson.S['pic1_path']<>'')
                 +Ord(AItemDataJson.S['pic2_path']<>'')
                 +Ord(AItemDataJson.S['pic3_path']<>'')
                 +Ord(AItemDataJson.S['pic4_path']<>'')
                 +Ord(AItemDataJson.S['pic5_path']<>'')
                 +Ord(AItemDataJson.S['pic6_path']<>'')
                 +Ord(AItemDataJson.S['pic7_path']<>'')
                 +Ord(AItemDataJson.S['pic8_path']<>'')
                 +Ord(AItemDataJson.S['pic9_path']<>'');
      Self.btnPicCount.Caption:=IntToStr(APicCount);

      if APicCount = 0 then
      begin
//        APicturesHeight:=0;
        Self.imgItemBigPic.Visible:=False;
        Self.btnPicCount.Visible:=False;
      end
      else
      begin
        Self.imgItemBigPic.Visible:=True;
        Self.btnPicCount.Visible:=True;
        AContentHeight:=Self.imgItemBigPic.Height;

      end;




      Self.lblAuthor.Caption:=AItemDataJson.S['name']+' '+AItemDataJson.S['process'];
      Self.lblAuthor.Top:=Self.lblItemCaption.Top+AContentHeight;


      Self.lblCreatetime.Caption:=AItemDataJson.S['createtime'];


      Self.lblCreatetime.Top:=Self.lblAuthor.Top+lblAuthor.Height;
      Self.lblComment.Top:=Self.lblCreatetime.Top;
      Self.lblDelete.Top:=Self.lblCreatetime.Top;


//      Self.lblProcess.Caption:=AItemDataJson.S['process'];

end;

procedure TFrameWorkOrderContentListItemStyle.lbCommentListGetItemBufferCacheTag(
  Sender: TObject; AItem: TSkinItem; var ACacheTag: Integer);
begin
  ACacheTag:=Integer(AItem);
end;

initialization
  RegisterListItemStyle('WorkOrderContent',TFrameWorkOrderContentListItemStyle,130,True);


finalization
  UnRegisterListItemStyle(TFrameWorkOrderContentListItemStyle);

end.
