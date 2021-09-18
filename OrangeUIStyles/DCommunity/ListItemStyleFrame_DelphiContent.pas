//convert pas to utf8 by ¥
unit ListItemStyleFrame_DelphiContent;

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
  TFrameDelphiContentListItemStyle = class(TFrameBaseListItemStyle,IFrameBaseListItemStyle)
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


constructor TFrameDelphiContentListItemStyle.Create(AOwner: TComponent);
begin
  inherited;
  Self.imgItemBigPic.Prop.Picture.Clear;
  //Self.imgItemBigPic.Material.IsDrawClipRound:=False;

  lblItemCaption.Text:='';

end;

procedure TFrameDelphiContentListItemStyle.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
var
//  Self:TFrameDelphiContentListItemStyle;
  I: Integer;
  AItemDataJson:ISuperObject;
  APic1Width:Integer;
  APic1Height:Integer;
  APicCount:Integer;
  APicturesHeight:Double;
  AContentHeight:Double;
  AOneLineHeight:Double;
  AIsLongContent:Boolean;
  ADrawPicture:TDrawPicture;
  AComment:String;
//  AStr:String;
begin

  inherited;

//  if FIsFixedItemStyle then Exit;


  if AItem.DataObject=nil then Exit;
  if TSkinItemJsonObject(AItem.DataObject).Json=nil then Exit;

  AItemDataJson:=GetItemJsonObject(AItem).Json;



//  //准备控件
//  if (AItemDesignerPanel<>nil)
//    //设计面板是内容内容
//    and (AItemDesignerPanel.Parent is TFrameDelphiContentListItemStyle) then
//  begin
//
//      Self:=TFrameDelphiContentListItemStyle(AItemDesignerPanel.Parent);


      Self.btnFocus.Visible:=False;
      Self.btnFocused.Visible:=False;

      //if AItemDataJson.V['user_fid']=GlobalManager.User.fid then
      if AItemDataJson.I['is_self']=1 then
      begin
          //自己发布的内容,不需要关注状态
          Self.btnFocus.Visible:=False;
          Self.btnFocused.Visible:=False;
      end
      else
      begin
          //当前用户关注发布者的状态
          if AItemDataJson.I['is_user_focused']=1 then
          begin
            Self.btnFocus.Visible:=False;

            Self.btnFocused.Visible:=True;
            Self.btnFocused.Caption:='已关注';
          end
          else if AItemDataJson.I['is_user_focused']=0 then
          begin
            Self.btnFocused.Visible:=False;

            Self.btnFocus.Visible:=True;
            Self.btnFocus.Caption:='关注';
          end
          else
          begin
            Self.btnFocus.Visible:=False;
            Self.btnFocused.Visible:=False;
          end;
      end;



      //内容
      if AItem.Detail4<>'' then
      begin
            Self.lblItemCaptionRegEx.Text:=AItem.Detail4;
            Self.lblItemCaption.Text:=AItem.Detail4;
//            if Self.lblItemCaptionRegEx.Prop.FElementList.Count>1 then
//            begin
//                //有链接
//                Self.lblItemCaptionRegEx.Visible:=True;
//                Self.lblItemCaption.Visible:=False;
//                Self.lblItemCaptionRegEx.Height:=Self.lblItemCaptionRegEx.Prop.GetContentHeight;
//                AContentHeight:=Self.lblItemCaptionRegEx.Prop.GetContentHeight;
//            end
//            else
//            begin
                //没有链接
                Self.lblItemCaptionRegEx.Visible:=False;
                Self.lblItemCaption.Visible:=True;
                AContentHeight:=
                        uSkinBufferBitmap.GetStringHeight(AItem.Detail4,
                            RectF(0,0,Self.lblItemCaptionRegEx.Width,MaxInt),
                            Self.lblItemCaption.Material.DrawCaptionParam);
                Self.lblItemCaption.Height:=AContentHeight;
//            end;

            //内容内容,或者文章内容

//            if AItem.ItemType=sitItem1 then
//            begin
//                //Item1是文章内容
//                AOneLineHeight:=
//                          uSkinBufferBitmap.GetStringHeight('悟能',
//                              RectF(0,0,Self.lblItemCaptionRegEx.Width,MaxInt),
//                              Self.lblItemCaptionRegEx.Material.DrawCaptionParam);
//
//                //是不是超长的内容
//                //超过3行就是超长的内容了
//                AIsLongContent:=False;
//                if (AContentHeight / AOneLineHeight > 3) then
//                begin
//                    AIsLongContent:=True;
//                    //没有展开
//                    if not AItem.Selected then
//                    begin
//                      //没有展开
//                      AContentHeight:=3*AOneLineHeight;
//                      AArticleStyleFrame.lblExpand.Caption:='展开全文...';
//                    end
//                    else
//                    begin
//                      //已展开
//                      AContentHeight:=AContentHeight
//                        //加上每行的误差
//                        +(AContentHeight / AOneLineHeight)
//                        *{$IFDEF MSWINDOWS}2.5{$ELSE}1{$ENDIF};
//                      AArticleStyleFrame.lblExpand.Caption:='收拢...';
//                    end;
//                end;
//                AArticleStyleFrame.lblExpand.Visible:=AIsLongContent;//False;//not AItem.Selected;
//            end;

      end
      else
      begin
            //没有文本内容
            AContentHeight:=0;
      end;
      //弥补误差
      Self.lblItemCaptionRegEx.Height:=AContentHeight+5;
      Self.lblItemCaption.Height:=AContentHeight+5;
//      uBaseLog.OutputDebugString('Self.lblItemCaptionRegEx.Height '+FloatToStr(AContentHeight+10));






//      Self.imgItemBigPic.Width:=Self.lvData.Width-20;
//      Self.imglistviewItemBigPic.Width:=Self.lvData.Width-20;

//      if AItem.Tag1=1 then
//      begin
//            //多图模式
//            Self.imglistviewItemBigPic.Visible:=True;
//            Self.imgItemBigPic.Visible:=False;
//            //第一张图片的尺寸
//            APic1Width:=AItemDataJson.I['pic1_width'];
//            APic1Height:=AItemDataJson.I['pic1_height'];
//            //只有一张图片
//            APicturesHeight:=160;
////            if APic1Width=0 then
////            begin
////              //没有宽度,那么使用默认的高度
////              APicturesHeight:=320;
////            end
////            else
////            begin
////              //根据宽度比例,计算出高度
////              APicturesHeight:=(APic1Height/APic1Width)
////                                *Self.imglistviewItemBigPic.Width;
////            end;
//
//
//            Self.imglistviewItemBigPic.Prop.Picture.ImageIndex:=0;
//            Self.imglistContent.PictureList.Clear(True);
//            //广告图片轮播
//            if AItemDataJson.S['pic1_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic1_path']);
//            end;
//            if AItemDataJson.S['pic2_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic2_path']);
//            end;
//            if AItemDataJson.S['pic3_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic3_path']);
//            end;
//            if AItemDataJson.S['pic4_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic4_path']);
//            end;
//            if AItemDataJson.S['pic5_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic5_path']);
//            end;
//            if AItemDataJson.S['pic6_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic6_path']);
//            end;
//            if AItemDataJson.S['pic7_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic7_path']);
//            end;
//            if AItemDataJson.S['pic8_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic8_path']);
//            end;
//            if AItemDataJson.S['pic9_path']<>'' then
//            begin
//              ADrawPicture:=Self.imglistContent.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic9_path']);
//            end;
//            Self.imglistviewItemBigPic.Prop.Picture.ImageIndex:=0;
//            Self.pnlBottomBar.Visible:=
//                                (Self.imglistContent.PictureList.Count>1);
//            Self.imglistviewItemBigPic.Prop.CanGestureSwitch:=
//                                (Self.imglistContent.PictureList.Count>1);
//            //保存FDrawRect,需要使用
//            AItem.FDataRect:=RectF(Self.imglistviewItemBigPic.Left,
//                                  Self.imglistviewItemBigPic.Top,
//                                  Self.imglistviewItemBigPic.Left+Self.imglistviewItemBigPic.Width,
//                                  Self.imglistviewItemBigPic.Top+Self.imglistviewItemBigPic.Height);
//      end
//      else
//      begin
            //单图模式
//            Self.imglistviewItemBigPic.Visible:=False;
            APicturesHeight:=0;
            if AItemDataJson.S['pic1_path']<>'' then
            begin
              Self.imgItemBigPic.Visible:=True;
              //第一张图片的尺寸
              APic1Width:=AItemDataJson.I['pic1_width'];
              APic1Height:=AItemDataJson.I['pic1_height'];
              APicturesHeight:=160;
            end;


            //只有一张图片
//            if APic1Width=0 then
//            begin
//              //没有宽度,那么使用默认的高度
//              APicturesHeight:=320;
//            end
//            else
//            begin
//              //根据宽度比例,计算出高度
//              APicturesHeight:=(APic1Height/APic1Width)
//                    *Self.imgItemBigPic.Width;
//
//
//            end;
//            Self.imgItemBigPic.Prop.Picture.Url:=GetImageUrl(AItemDataJson.S['pic1_path']);
//            Self.imgItemBigPic.Prop.Picture.ClipRoundXRadis:=20;
//            Self.imgItemBigPic.Prop.Picture.ClipRoundYRadis:=20;
//            Self.imgItemBigPic.Prop.Picture.IsClipRound:=True;
//      end;
      //图片框不能太高,限制其最大高度
      if APicturesHeight>320 then
      begin
        APicturesHeight:=320;
      end;
//      Self.imglistviewItemBigPic.Height:=APicturesHeight;
      Self.imgItemBigPic.Height:=APicturesHeight;
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
      Self.btnPicCount.Visible:=(APicCount>0);









//      //显示前三个点赞的头像列表
//      Self.lbLikeList.Prop.Items.BeginUpdate;
//      try
//          for I := 0 to Self.lbLikeList.Prop.Items.Count-2 do
//          begin
//            //"fid": 3,
//            //"appid": 1005,
//            //"content_fid": 2,
//            //"user_fid": 138,
//            //"is_like": 1,
//            //"like_time": "2018-10-27 01:57:04",
//            //"is_read": 0,
//            //"read_time": "",
//            //"is_fav": 0,
//            //"fav_time": "",
//            //"createtime": "2018-10-27 01:57:05",
//            //"is_deleted": 0,
//            //"orderno": 0,
//            //"is_comment": 0,
//            //"comment_time": "",
//            //"user_name": "悟能",
//            //"user_head_pic_path": "/Upload/1005/userhead_Pic/2018/2018-10-22/26B3FD7D7C59410792A5B5F7D2C5BB60.jpg"
//            if I<AItemDataJson.A['LikeList'].Length then
//            begin
//                Self.lbLikeList.Prop.Items[I].Visible:=True;
//                Self.lbLikeList.Prop.Items[I].Icon.IsClipRound:=True;
//                Self.lbLikeList.Prop.Items[I].Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
//                Self.lbLikeList.Prop.Items[I].Icon.Url:=
//                  GetImageUrl(AItemDataJson.A['LikeList'].O[I].S['user_head_pic_path'],itUserHead);
//            end
//            else
//            begin
//                Self.lbLikeList.Prop.Items[I].Visible:=False;
//            end;
//          end;
//          Self.lbLikeList.Prop.Items[Self.lbLikeList.Prop.Items.Count-1].Caption:=
//            IntToStr(AItemDataJson.I['like_count'])+'赞';
//
//      finally
//        Self.lbLikeList.Prop.Items.EndUpdate;
//      end;
      //是否已赞
      if AItemDataJson.I['like_count']>0 then
      begin
        Self.btnLikeState.Caption:=IntToStr(AItemDataJson.I['like_count']);
      end
      else
      begin
        Self.btnLikeState.Caption:='0';
      end;
      Self.btnLikeState.Prop.IsPushed:=(AItemDataJson.O['UserState'].I['is_like']=1);



      //是否已收藏
      if AItemDataJson.I['fav_count']>0 then
      begin
        Self.btnFavState.Caption:=IntToStr(AItemDataJson.I['fav_count']);
      end
      else
      begin
        Self.btnFavState.Caption:='0';
      end;
      Self.btnFavState.Prop.IsPushed:=(AItemDataJson.O['UserState'].I['is_fav']=1);








//      //显示前三条评论
//      Self.lbCommentList.Prop.Items.BeginUpdate;
//      try
//        for I := 0 to Self.lbCommentList.Prop.Items.Count-1 do
//        begin
//          if I<AItemDataJson.A['CommentList'].Length then
//          begin
//              Self.lbCommentList.Prop.Items[I].Visible:=True;
//              //"fid": 13,
//              //"appid": 1005,
//              //"content_fid": 1,
//              //"user_fid": 138,
//              //"reply_to_user_fid": 138,
//              //"reply_to_comment_fid": 1,
//              //"comment": "你的评论不错!",
//              //"createtime": "2018-10-29 21:33:32",
//              //"is_deleted": 0,
//              //"orderno": 0,
//              //"user_name": "悟能",
//              //"user_head_pic_path": "/Upload/1005/userhead_Pic/2018/2018-10-22/26B3FD7D7C59410792A5B5F7D2C5BB60.jpg"
//              Self.lbCommentList.Prop.Items[I].Caption:=
//                  AItemDataJson.A['CommentList'].O[I].S['user_name'];
//              AComment:=ReplaceStr(AItemDataJson.A['CommentList'].O[I].S['comment'],#13#10,'');
//              AComment:=ReplaceStr(AComment,#13,'');
//              AComment:=ReplaceStr(AComment,#10,'');
//              Self.lbCommentList.Prop.Items[I].Detail:=AComment;
//
//
//
//              Self.lbCommentList.Prop.Items[I].Detail1:='';
//              Self.lbCommentList.Prop.Items[I].Detail2:='';
//              if AItemDataJson.A['CommentList'].O[I].I['reply_to_user_fid']<>0 then
//              begin
//                Self.lbCommentList.Prop.Items[I].Detail1:='回复';
//                Self.lbCommentList.Prop.Items[I].Detail2:=
//                  AItemDataJson.A['CommentList'].O[I].S['reply_to_user_name'];
//              end;
//
//          end
//          else
//          begin
//              Self.lbCommentList.Prop.Items[I].Visible:=False;
//          end;
//        end;
//      finally
//        Self.lbCommentList.Prop.Items.EndUpdate();
//      end;
      //评论数
      if AItemDataJson.I['comment_count']>0 then
      begin
//          Self.lblCommentCount.StaticCaption:=
//            '查看所有'+IntToStr(AItemDataJson.I['comment_count'])+'条评论';
        Self.btnComment.Caption:=IntToStr(AItemDataJson.I['comment_count']);
      end
      else
      begin
//          Self.lblCommentCount.StaticCaption:='暂无评论';
        Self.btnComment.Caption:='0';
      end;
//      Self.lblCommentCount.Height:=22;
//      Self.lbCommentList.Height:=
//        Self.lbCommentList.Prop.GetContentHeight;
//      uBaseLog.OutputDebugString('Self.lbCommentList.Height '+FloatToStr(Self.lbCommentList.Height));
//      Self.lblCommentCount.Visible:=AItemDataJson.I['comment_count']>0;
//      if AItemDataJson.I['comment_count']>0 then
//      begin
//        Self.lblCommentCount.Height:=22;
//      end
//      else
//      begin
//        Self.lblCommentCount.Height:=0;
//      end;

      //分享数
      if AItemDataJson.I['share_count']>0 then
      begin
        Self.btnTransmit.Caption:=IntToStr(AItemDataJson.I['share_count']);
      end
      else
      begin
        Self.btnTransmit.Caption:='0';
      end;

//      Self.btnLikeState.Left:=Self.imgItemBigPic.Left;
//      Self.btnFavState.Left:=Self.imgItemBigPic.Left
//                      +Self.imgItemBigPic.Width/4*1;
//      Self.btnComment.Left:=Self.imgItemBigPic.Left
//                      +Self.imgItemBigPic.Width/4*2;
//      Self.btnTransmit.Left:=Self.imgItemBigPic.Left
//                      +Self.imgItemBigPic.Width/4*3;






      if AItem.ItemType=sitDefault then
      begin
          //内容
          //排列控件
          //文本
          //图片在文本下面
          if Self.lblItemCaptionRegEx.Visible then
          begin
            Self.imgItemBigPic.Position.Y:=
                  Self.lblItemCaptionRegEx.Position.Y
                  +Self.lblItemCaptionRegEx.Height
                  +5;
          end
          else
          begin
            Self.imgItemBigPic.Position.Y:=
                  Self.lblItemCaption.Position.Y
                  +Self.lblItemCaption.Height
                  +5;
          end;
          //按钮区在图片下面
          Self.pnlButtons.Position.Y:=
                Self.imgItemBigPic.Position.Y
                +Self.imgItemBigPic.Height
                ;//+5;
//          //评论
//          Self.lbCommentList.Position.Y:=
//                Self.pnlButtons.Position.Y
//                +Self.pnlButtons.Height
//                ;//+5;
//          //评论数
//          Self.lblCommentCount.Position.Y:=
//                Self.lbCommentList.Position.Y
//                +Self.lbCommentList.Height
////                +5
//                ;
          Self.btnPicCount.Position.Y:=Self.imgItemBigPic.Top
                                                  +Self.imgItemBigPic.Height
                                                  -30;

//        uBaseLog.OutputDebugString('Self.lblCommentCount.Height '+FloatToStr(Self.lblCommentCount.Height));
//        uBaseLog.OutputDebugString('Self.lblCommentCount.Position.Y '+FloatToStr(Self.lblCommentCount.Position.Y));
      end;

      //删除按钮
      Self.lblDelete.Visible:=False;
//        (AItemDataJson.V['user_fid']=GlobalManager.User.fid)//;
////          or (GlobalManager.User.fid=269)
////          or (GlobalManager.User.fid=243)
//          or (GlobalManager.User.phone='18957901025');
//      Self.lblDelete.Position.Y:=
//            Self.pnlButtons.Position.Y
//            +Self.pnlButtons.Height
////            +5
//            ;
//      uBaseLog.OutputDebugString('Self.lblDelete.Position.Y '+FloatToStr(Self.lblDelete.Position.Y));



//  end;

end;

procedure TFrameDelphiContentListItemStyle.lbCommentListGetItemBufferCacheTag(
  Sender: TObject; AItem: TSkinItem; var ACacheTag: Integer);
begin
  ACacheTag:=Integer(AItem);
end;

initialization
  RegisterListItemStyle('DelphiContent',TFrameDelphiContentListItemStyle,160,True);


finalization
  UnRegisterListItemStyle(TFrameDelphiContentListItemStyle);

end.
