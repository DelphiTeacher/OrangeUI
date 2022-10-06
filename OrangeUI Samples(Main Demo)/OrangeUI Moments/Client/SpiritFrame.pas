//convert pas to utf8 by ¥

unit SpiritFrame;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.DeviceInfo,
  Math,
  StrUtils,
  DateUtils,

  uBaseLog,
  uSkinBufferBitmap,
  uDrawCanvas,
  uDrawPicture,
  uSkinItems,
  uBaseList,
  uFuncCommon,
  uSkinListBoxType,

  InputFrame,

  WaitingFrame,
  MessageBoxFrame,
  {$IFNDEF IS_LISTVIEW_DEMO}
//  GetPositionFrame,
  GetUserInfoFrame,
  {$ENDIF}

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,

  ClientModuleUnit1,
//  FriendCircleCommonMaterialDataMoudle,




  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyButton, uSkinFireMonkeyPullLoadPanel, uSkinFireMonkeyRoundImage,
  uSkinFireMonkeyListView, uUrlPicture, uDownloadPictureManager,
  uSkinFireMonkeyPopup, uSkinFireMonkeyMultiColorLabel, uSkinMaterial,
  uSkinImageType, uSkinMultiColorLabelType, uSkinFireMonkeyCustomList,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uBaseSkinControl,
  uSkinPanelType;




type
  TFrameSpirit = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbSpiritList: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblItemDefaultCaption: TSkinFMXLabel;
    lblItemDefaultDetail: TSkinFMXLabel;
    btnWriteMind: TSkinFMXButton;
    lblItemDefaultDetail1: TSkinFMXLabel;
    imgItemDefaultPicture: TSkinFMXImage;
    lblItemDefaultDelete: TSkinFMXLabel;
    tmrRePaint: TTimer;
    btnItemOper: TSkinFMXButton;
    popItemOper: TSkinFMXPopup;
    btnItemLike: TSkinFMXButton;
    btnItemComment: TSkinFMXButton;
    pnlItemLikes: TSkinFMXPanel;
    imgItemLike: TSkinFMXImage;
    lblItemLikes: TSkinFMXMultiColorLabel;
    imgPic1: TSkinFMXImage;
    imgPic2: TSkinFMXImage;
    imgPic3: TSkinFMXImage;
    imgPic5: TSkinFMXImage;
    imgPic6: TSkinFMXImage;
    imgPic4: TSkinFMXImage;
    imgPic8: TSkinFMXImage;
    imgPic9: TSkinFMXImage;
    imgPic7: TSkinFMXImage;
    pnlItemComments: TSkinFMXPanel;
    lblComment1: TSkinFMXMultiColorLabel;
    lblComment2: TSkinFMXMultiColorLabel;
    lblComment3: TSkinFMXMultiColorLabel;
    lblComment4: TSkinFMXMultiColorLabel;
    lblComment5: TSkinFMXMultiColorLabel;
    imgItemDefaultIcon: TSkinFMXImage;
    lblItemDefaultDetail2: TSkinFMXLabel;
    lblItemDefaultDetail3: TSkinFMXLabel;
    procedure btnWriteMindClick(Sender: TObject);
    procedure lbSpiritListPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure lbSpiritListResize(Sender: TObject);
    procedure lblItemDefaultDeleteClick(Sender: TObject);
    procedure imgItemDefaultPictureClick(Sender: TObject);
    procedure tmrRePaintTimer(Sender: TObject);
    procedure btnItemOperClick(Sender: TObject);
    procedure btnItemLikeClick(Sender: TObject);
    procedure btnItemCommentClick(Sender: TObject);
    procedure imgPic1Click(Sender: TObject);
    procedure lbSpiritListPullUpLoadMore(Sender: TObject);
    procedure lbSpiritListPullDownRefresh(Sender: TObject);

    procedure lblComment1Click(Sender: TObject);
    procedure lbSpiritListClickItem(AItem: TSkinItem);
    procedure imgItemDefaultIconClick(Sender: TObject);
  private
    FPageIndex:Integer;
    FPageCount:Integer;

    FUserSpiritList:TUserSpiritList;


    procedure CalcSpiritListItemsSize(AWidth:Double);

    procedure CalcSpiritItemSize(AListBoxItem:TSkinItem);

    procedure DoGetUserSpiritListExecute(ATimerTask:TObject);
    procedure DoGetUserSpiritListExecuteEnd(ATimerTask:TObject);

  private
    procedure DoReturnFrameFromAddSpiritFrame(Frame:TFrame);
    procedure DoReturnFrameFromInputFrame(Sender:TFrame);

  private
    FNeedDeleteSpiritID:Integer;
    FNeedDeleteSpiritItem:TSkinItem;

    procedure DoDelSpiritExecute(ATimerTask:TObject);
    procedure DoDelSpiritExecuteEnd(ATimerTask:TObject);

  private

    FNeedOperSpiritID:Integer;
    FNeedReplyUserID:Integer;
    FNeedReplyUserName:String;

    procedure DoLikeSpiritExecute(ATimerTask:TObject);
    procedure DoLikeSpiritExecuteEnd(ATimerTask:TObject);

    procedure DoCancelLikeSpiritExecute(ATimerTask:TObject);
    procedure DoCancelLikeSpiritExecuteEnd(ATimerTask:TObject);

    procedure DoCommentSpiritExecute(ATimerTask:TObject);
    procedure DoCommentSpiritExecuteEnd(ATimerTask:TObject);

    procedure DoGetUserInfoExecute(ATimerTask:TObject);
    procedure DoGetUserInfoExecuteEnd(ATimerTask:TObject);
  private
    FNeedGetUserID:Integer;
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load;
    { Public declarations }
  end;


implementation



uses
  MainForm
  {$IFNDEF IS_LISTVIEW_DEMO}
  ,
  MainFrame,
  MyFrame,
  ViewPictureListFrame,
  uViewPictureListFrame,
  AddSpiritFrame
  {$ENDIF}
  ;



{$R *.fmx}

procedure TFrameSpirit.btnItemCommentClick(Sender: TObject);
begin
  //评论朋友圈
  Self.popItemOper.IsOpen:=False;


  FNeedReplyUserID:=0;
  //显示输入框
  ShowFrame(TFrame(GlobalInputFrame),TFrameInput,frmMain,nil,nil,DoReturnFrameFromInputFrame,Application,True,True,ufsefNone);
  GlobalInputFrame.memMsgInput.Prop.HelpText:='';
  GlobalInputFrame.memMsgInput.SetFocus;
end;

procedure TFrameSpirit.btnItemLikeClick(Sender: TObject);
var
  ATimerTask:TTimerTask;
begin
  //点赞朋友圈
  ATimerTask:=TTimerTask.Create;
  ATimerTask.TaskOtherInfo.Add(IntToStr(Self.FNeedOperSpiritID));

  if Self.btnItemLike.Caption='点赞' then
  begin
      ATimerTask.OnExecute:=DoLikeSpiritExecute;
      ATimerTask.OnExecuteEnd:=DoLikeSpiritExecuteEnd;
  end
  else
  begin
      //取消点赞
      ATimerTask.OnExecute:=DoCancelLikeSpiritExecute;
      ATimerTask.OnExecuteEnd:=DoCancelLikeSpiritExecuteEnd;
  end;

  uTimerTask.GetGlobalTimerThread.RunTask(ATimerTask);

  Self.popItemOper.IsOpen:=False;
end;

procedure TFrameSpirit.btnItemOperClick(Sender: TObject);
var
  AUserSpirit:TUserSpirit;
begin
  AUserSpirit:=TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data);
  FNeedOperSpiritID:=AUserSpirit.FID;

  //判断是点赞还是取消赞
  if AUserSpirit.LikeList.FindByUserID(GlobalManager.User.FID)<>nil then
  begin
    Self.btnItemLike.Caption:='取消';
  end
  else
  begin
    Self.btnItemLike.Caption:='点赞';
  end;


  //点击,弹出菜单
  //弹出菜单
  if not popItemOper.IsOpen then
  begin
      //绝对位置
      popItemOper.PlacementRectangle.Left:=
        Self.lbSpiritList.LocalToScreen(PointF(
                Self.btnItemOper.Position.X,0
                                )).X
                                -Self.popItemOper.Width-5;
      popItemOper.PlacementRectangle.Top:=
        Self.lbSpiritList.LocalToScreen(PointF(
                0,Self.lbSpiritList.Prop.InteractiveItem.ItemDrawRect.Top
                    +Self.btnItemOper.Top
                    -(popItemOper.Height-btnItemOper.Height)/2
                          )).Y;
      popItemOper.IsOpen := True;
  end
  else
  begin
      popItemOper.IsOpen := False;
  end;
end;

procedure TFrameSpirit.btnWriteMindClick(Sender: TObject);
begin
  {$IFNDEF IS_LISTVIEW_DEMO}
  //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  //写朋友圈
  ShowFrame(TFrame(GlobalAddSpiritFrame),TFrameAddSpirit,frmMain,nil,nil,DoReturnFrameFromAddSpiritFrame,Application);
//  GlobalAddSpiritFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddSpiritFrame.Clear;
  {$ENDIF}
end;

procedure TFrameSpirit.DoReturnFrameFromAddSpiritFrame(Frame: TFrame);
begin
  Self.lbSpiritList.Prop.StartPullDownRefresh();
end;

procedure TFrameSpirit.DoReturnFrameFromInputFrame(Sender: TFrame);
var
  ATimerTask:TTimerTask;
begin
  if GlobalInputFrame.memMsgInput.Text<>'' then
  begin

    //评论朋友圈
    ATimerTask:=TTimerTask.Create;
    ATimerTask.TaskParams.AddParam('NeedOperSpiritID',Self.FNeedOperSpiritID);
    ATimerTask.TaskParams.AddParam('Comment',GlobalInputFrame.memMsgInput.Text);
    ATimerTask.OnExecute:=DoCommentSpiritExecute;
    ATimerTask.OnExecuteEnd:=DoCommentSpiritExecuteEnd;

    uTimerTask.GetGlobalTimerThread.RunTask(ATimerTask);

  end;

  GlobalInputFrame.memMsgInput.Text:='';
end;

procedure TFrameSpirit.imgItemDefaultIconClick(Sender: TObject);
var
  AUserSpirit:TUserSpirit;
begin
    AUserSpirit:=TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data);

    FNeedGetUserID:=AUserSpirit.UserID;
    ShowWaitingFrame(Self,'加载中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                    DoGetUserInfoExecute,
                    DoGetUserInfoExecuteEnd
                    );


end;

procedure TFrameSpirit.imgItemDefaultPictureClick(Sender: TObject);
begin
  {$IFNDEF IS_LISTVIEW_DEMO}

  //查看照片信息
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //查看照片信息
  ShowFrame(TFrame(GlobalViewPictureListFrame),TFrameViewPictureList,frmMain,nil,nil,nil);
//  GlobalViewPictureListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalViewPictureListFrame.Init('照片',
        TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data).PicList,
        0,
        //原图URL
        TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data).OriginPicUrlList
        );
  {$ENDIF}
end;

procedure TFrameSpirit.imgPic1Click(Sender: TObject);
var
  AImageIndex:Integer;
begin
  {$IFNDEF IS_LISTVIEW_DEMO}

  //传入Index
  AImageIndex:=StrToInt(ReplaceStr(TSkinFMXImage(Sender).Name,'imgPic',''))-1;

  //查看照片信息
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //查看照片信息
  ShowFrame(TFrame(GlobalViewPictureListFrame),TFrameViewPictureList,frmMain,nil,nil,nil);
//  GlobalViewPictureListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalViewPictureListFrame.Init('照片',
      TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data).PicList,
      AImageIndex,
      //原图URL
      TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data).OriginPicUrlList
      );
  {$ENDIF}

end;

procedure TFrameSpirit.lblComment1Click(Sender: TObject);
var
  AUserSpirit:TUserSpirit;
  AMultiColorLabel:TSkinFMXMultiColorLabel;
begin
  AUserSpirit:=TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data);
  FNeedOperSpiritID:=AUserSpirit.FID;
  //回复评论

  AMultiColorLabel:=TSkinFMXMultiColorLabel(Sender);

  FNeedReplyUserID:=StrToInt(AMultiColorLabel.Prop.RefColorTextCollection[0].Name);
  FNeedReplyUserName:=AMultiColorLabel.Prop.RefColorTextCollection[0].Text;
  //显示输入框
  ShowFrame(TFrame(GlobalInputFrame),TFrameInput,frmMain,nil,nil,DoReturnFrameFromInputFrame,Application,False,True,ufsefNone);
  GlobalInputFrame.memMsgInput.Prop.HelpText:='回复'+FNeedReplyUserName+':';

end;

procedure TFrameSpirit.lblItemDefaultDeleteClick(Sender: TObject);
var
  AUserSpirit:TUserSpirit;
begin
  //删除朋友圈
  AUserSpirit:=TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data);
  FNeedDeleteSpiritID:=AUserSpirit.FID;
  FNeedDeleteSpiritItem:=Self.lbSpiritList.Prop.InteractiveItem;

  ShowWaitingFrame(Self,'删除中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                    Self.DoDelSpiritExecute,
                    DoDelSpiritExecuteEnd
                    );
end;

procedure TFrameSpirit.lbSpiritListClickItem(AItem: TSkinItem);
begin
  if AItem.ItemType=sitDefault then
  begin
  end;

end;

procedure TFrameSpirit.lbSpiritListPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
var
  AUserSpirit:TUserSpirit;
  I: Integer;
  ATop:Double;
begin
  AUserSpirit:=TUserSpirit(Item.Data);


  //奇怪,要先设置lblItemDefaultDetail.Height,
  //它的高度才会刚好合适
  Self.lblItemDefaultDetail.Height:=Item.Tag;



  if AUserSpirit.Pic1Path='' then
  begin
    //没有图片
    Self.imgPic1.Visible:=False;
    Self.imgPic2.Visible:=False;
    Self.imgPic3.Visible:=False;
    Self.imgPic4.Visible:=False;
    Self.imgPic5.Visible:=False;
    Self.imgPic6.Visible:=False;
    Self.imgPic7.Visible:=False;
    Self.imgPic8.Visible:=False;
    Self.imgPic9.Visible:=False;
    Self.imgItemDefaultPicture.Visible:=False;
  end
  else if AUserSpirit.Pic2Path='' then
  begin
    //只有一张图片
    Self.imgPic1.Visible:=False;
    Self.imgPic2.Visible:=False;
    Self.imgPic3.Visible:=False;
    Self.imgPic4.Visible:=False;
    Self.imgPic5.Visible:=False;
    Self.imgPic6.Visible:=False;
    Self.imgPic7.Visible:=False;
    Self.imgPic8.Visible:=False;
    Self.imgPic9.Visible:=False;
    Self.imgItemDefaultPicture.Visible:=True;
    Self.imgItemDefaultPicture.Prop.Picture.StaticPictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgItemDefaultPicture.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic1;

    Self.lblItemDefaultDetail.Height:=Item.Tag;
    Self.imgItemDefaultPicture.Height:=Item.Tag1;
    Self.imgItemDefaultPicture.Top:=lblItemDefaultDetail.Top+Item.Tag+5;


  end
  else
  begin
    //有两张以上图片
    Self.imgItemDefaultPicture.Visible:=False;

    Self.imgPic1.Visible:=(AUserSpirit.Pic1Path<>'');
    Self.imgPic2.Visible:=(AUserSpirit.Pic2Path<>'');
    Self.imgPic3.Visible:=(AUserSpirit.Pic3Path<>'');
    Self.imgPic4.Visible:=(AUserSpirit.Pic4Path<>'');
    Self.imgPic5.Visible:=(AUserSpirit.Pic5Path<>'');
    Self.imgPic6.Visible:=(AUserSpirit.Pic6Path<>'');
    Self.imgPic7.Visible:=(AUserSpirit.Pic7Path<>'');
    Self.imgPic8.Visible:=(AUserSpirit.Pic8Path<>'');
    Self.imgPic9.Visible:=(AUserSpirit.Pic9Path<>'');

    Self.imgPic1.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic2.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic3.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic4.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic5.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic6.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic7.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic8.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
    Self.imgPic9.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;

    Self.imgPic1.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic1;
    Self.imgPic2.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic2;
    Self.imgPic3.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic3;
    Self.imgPic4.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic4;
    Self.imgPic5.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic5;
    Self.imgPic6.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic6;
    Self.imgPic7.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic7;
    Self.imgPic8.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic8;
    Self.imgPic9.Prop.Picture.StaticRefDrawPicture:=AUserSpirit.Pic9;

    Self.lblItemDefaultDetail.Height:=Item.Tag;
    Self.imgPic1.Top:=lblItemDefaultDetail.Top+Item.Tag+5;
    Self.imgPic2.Top:=imgPic1.Top;
    Self.imgPic3.Top:=imgPic1.Top;

    Self.imgPic4.Top:=imgPic1.Top+imgPic1.Height+10;
    Self.imgPic5.Top:=imgPic4.Top;
    Self.imgPic6.Top:=imgPic4.Top;

    Self.imgPic7.Top:=imgPic4.Top+imgPic4.Height+10;
    Self.imgPic8.Top:=imgPic7.Top;
    Self.imgPic9.Top:=imgPic7.Top;

  end;


  //删除按钮
  Self.lblItemDefaultDelete.Visible:=('15216873386'=GlobalManager.User.Phone);
  //删除按钮
  Self.lblItemDefaultDelete.Top:=lblItemDefaultDetail.Top+lblItemDefaultDetail.Height+Item.Tag1-35;

  //所在位置
  Self.lblItemDefaultDetail2.Top:=lblItemDefaultDetail.Top+lblItemDefaultDetail.Height+Item.Tag1+10;
  //日期
  Self.lblItemDefaultDetail1.Top:=lblItemDefaultDetail2.Top+lblItemDefaultDetail2.Height;
  //手机型号
  Self.lblItemDefaultDetail3.Top:=lblItemDefaultDetail1.Top;
  Self.lblItemDefaultDetail3.Left:=Self.lblItemDefaultDetail1.Left+Self.lblItemDefaultDetail1.Width;
  //操作
  Self.btnItemOper.Top:=lblItemDefaultDetail.Top+lblItemDefaultDetail.Height+Item.Tag1+5;

  ATop:=lblItemDefaultDetail1.Top+lblItemDefaultDetail1.Height;




  //点赞

  Self.pnlItemLikes.Visible:=AUserSpirit.LikeList.Count>0;
  if AUserSpirit.LikeList.Count>0 then
  begin
      Self.pnlItemLikes.Top:=ATop;
      lblItemLikes.Prop.RefColorTextCollection:=AUserSpirit.LikesDrawColorTextCollection;

      ATop:=pnlItemLikes.Top+pnlItemLikes.Height;
  end;




  //评论
  if AUserSpirit.CommentList.Count>0 then
  begin
    Self.lblComment1.Visible:=True;
    Self.lblComment1.Prop.RefColorTextCollection:=AUserSpirit.CommentList[0].DrawColorTextCollection;
  end
  else
  begin
    Self.lblComment1.Visible:=False;
  end;
  if AUserSpirit.CommentList.Count>1 then
  begin
    Self.lblComment2.Visible:=True;
    Self.lblComment2.Prop.RefColorTextCollection:=AUserSpirit.CommentList[1].DrawColorTextCollection;
  end
  else
  begin
    Self.lblComment2.Visible:=False;
  end;
  if AUserSpirit.CommentList.Count>2 then
  begin
    Self.lblComment3.Visible:=True;
    Self.lblComment3.Prop.RefColorTextCollection:=AUserSpirit.CommentList[2].DrawColorTextCollection;
  end
  else
  begin
    Self.lblComment3.Visible:=False;
  end;
  if AUserSpirit.CommentList.Count>3 then
  begin
    Self.lblComment4.Visible:=True;
    Self.lblComment4.Prop.RefColorTextCollection:=AUserSpirit.CommentList[3].DrawColorTextCollection;
  end
  else
  begin
    Self.lblComment4.Visible:=False;
  end;
  if AUserSpirit.CommentList.Count>4 then
  begin
    Self.lblComment5.Visible:=True;
    Self.lblComment5.Prop.RefColorTextCollection:=AUserSpirit.CommentList[4].DrawColorTextCollection;
  end
  else
  begin
    Self.lblComment5.Visible:=False;
  end;
  Self.pnlItemComments.Height:=Min(5,AUserSpirit.CommentList.Count)*Self.lblComment1.Height;
  Self.pnlItemComments.Top:=ATop;


end;

procedure TFrameSpirit.lbSpiritListPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
        DoGetUserSpiritListExecute,
        DoGetUserSpiritListExecuteEnd
        );

end;

procedure TFrameSpirit.lbSpiritListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
        DoGetUserSpiritListExecute,
        DoGetUserSpiritListExecuteEnd
        );

end;

procedure TFrameSpirit.lbSpiritListResize(Sender: TObject);
begin
  CalcSpiritListItemsSize(lbSpiritList.Width);

end;

procedure TFrameSpirit.Load;
begin
  Self.lbSpiritList.Prop.StartPullDownRefresh;
end;


procedure TFrameSpirit.tmrRePaintTimer(Sender: TObject);
begin
  Self.lbSpiritList.Invalidate;
end;

procedure TFrameSpirit.CalcSpiritItemSize(AListBoxItem: TSkinItem);
var
  I: Integer;
  AUserSpirit:TUserSpirit;
  ATextHeight:Double;
  AImageDrawRect:TRectF;
  APicturesHeight:Double;
  AThumbPicturesSize:TSizeF;

  AOriginHeight:Double;
begin
  AUserSpirit:=TUserSpirit(AListBoxItem.Data);
  if AUserSpirit=nil then Exit;


  //文字的高度
  ATextHeight:=GetStringHeight(AUserSpirit.Spirit,
                  RectF(0,0,Self.lblItemDefaultDetail.Width,MaxInt),
                  lblItemDefaultDetail.CurrentUseMaterialToDefault.DrawCaptionParam
                  )
                  +10;

//  //判断出有几行
//  ALineHeight:=GetStringHeight('判断有几行',
//                  RectF(0,0,Self.lblItemDefaultDetail.Width,MaxInt),
//                  lblItemDefaultDetail.CurrentUseMaterialToDefault.DrawCaptionParam);
//  //每行再加上5个点的偏移
//  ATextHeight:=Ceil(ATextHeight/ALineHeight)*10+ATextHeight;





  //计算出图片需要的高度
  if (AUserSpirit.Pic1Path='') then
  begin
      //没有图片
      APicturesHeight:=0;
  end
  else
  if (AUserSpirit.Pic2Path='') then
  begin
      //只有一张图片
      //最大高度Self.lvItemDefaultPictures.Prop.ItemHeight*3
      if AUserSpirit.Pic1Width=0 then
      begin
        APicturesHeight:=Self.imgItemDefaultPicture.Height;
      end
      else
      begin
        //AUserSpirit.Pic1Height是原图的尺寸
        //但是ListView中显示的是缩略图的尺寸,
        //所以，先取到缩略图的尺寸
        AThumbPicturesSize:=AutoFitPictureDrawRect(
                AUserSpirit.Pic1Width,
                AUserSpirit.Pic1Height,
                300,
                300
                );
        //再计算出图片所需要的高度
        CalcImageDrawRect(
                imgItemDefaultPicture.SelfOwnMaterialToDefault.DrawPictureParam,
                Ceil(AThumbPicturesSize.cx),
                Ceil(AThumbPicturesSize.cy),
                RectF(0,0,
                      Self.imgItemDefaultPicture.Width,
                      AThumbPicturesSize.cy),
                AImageDrawRect
                );
        APicturesHeight:=AImageDrawRect.Height;
      end;


  end
  else
  if (AUserSpirit.Pic4Path='') then
  begin
      //只有一行图片
      APicturesHeight:=Self.imgPic1.Height;
  end
  else
  if (AUserSpirit.Pic7Path='') then
  begin
      //只有两行图片
      APicturesHeight:=Self.imgPic1.Height*2+10;
  end
  else
  begin
      //有三行图片
      APicturesHeight:=Self.imgPic1.Height*3+20;
  end;

  //文本高度
  AListBoxItem.Tag:=Ceil(ATextHeight);
  //图片高度
  AListBoxItem.Tag1:=Ceil(APicturesHeight);


  AOriginHeight:=90;

  //判断有没有点赞
  if AUserSpirit.LikeList.Count>0 then
  begin
    AOriginHeight:=AOriginHeight+Self.pnlItemLikes.Height+5;
  end;


  //判断有没有评论
  if AUserSpirit.CommentList.Count>0 then
  begin
    AOriginHeight:=AOriginHeight+Min(AUserSpirit.CommentList.Count,5)*Self.lblComment1.Height+5;
  end;


  AListBoxItem.Height:=AOriginHeight+ATextHeight+APicturesHeight;

end;

procedure TFrameSpirit.CalcSpiritListItemsSize(AWidth:Double);
var
  I: Integer;
begin
  ItemDefault.Width:=AWidth;

  Self.lbSpiritList.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lbSpiritList.Prop.Items.Count-1 do
    begin
        CalcSpiritItemSize(Self.lbSpiritList.Prop.Items[I]);
    end;
  finally
    Self.lbSpiritList.Prop.Items.EndUpdate();
  end;
end;

constructor TFrameSpirit.Create(AOwner: TComponent);
begin
  inherited;



  Self.imgItemDefaultPicture.Prop.Picture.Clear;


  FUserSpiritList:=TUserSpiritList.Create;


  Self.lbSpiritList.Properties.Items.Clear(True);



  {$IFDEF IS_LISTVIEW_DEMO}
  //示例时隐藏滚动条
  Self.pnlToolBar.Visible:=False;

  GlobalManager.User.FID:=4;
  GlobalManager.User.Name:='测试';
  GlobalManager.User.Phone:='18957901025';
  GlobalManager.User.CompanyName:='OrangeUI开发部';


  ClientModule.DSRestConnection1.Host:='www.orangeui.cn';
  ImageHttpServerUrl:='http://www.orangeui.cn:7041';

  Self.lbSpiritList.Prop.StartPullDownRefresh;
  {$ENDIF}



end;

destructor TFrameSpirit.Destroy;
begin

  uFuncCommon.FreeAndNil(FUserSpiritList);

  inherited;
end;

procedure TFrameSpirit.DoCommentSpiritExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.CommentSpirit(
        GlobalManager.User.FID,
        GlobalManager.LoginKey,
        TTimerTask(ATimerTask).TaskParams[0].Value,
        TTimerTask(ATimerTask).TaskParams[1].Value,
        FNeedReplyUserID
        );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameSpirit.DoCommentSpiritExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ANeedOperItem:TSkinItem;
  ASpiritComment:TSpiritComment;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          ANeedOperItem:=Self.lbSpiritList.Prop.Items.FindItemByName(TTimerTask(ATimerTask).TaskParams[0].Value);
          if (ANeedOperItem<>nil) then
          begin
            //评论朋友圈成功
            ASpiritComment:=TSpiritComment.Create;
            ASpiritComment.UserID:=GlobalManager.User.FID;
            ASpiritComment.UserName:=GlobalManager.User.Name;

            ASpiritComment.Comment:=TTimerTask(ATimerTask).TaskParams[1].Value;

            ASpiritComment.ReplyUserID:=FNeedReplyUserID;
            ASpiritComment.ReplyUserName:=FNeedReplyUserName;

            ASpiritComment.SyncDrawColorTextCollection;

            TUserSpirit(ANeedOperItem.Data).CommentList.Add(ASpiritComment);

            Self.CalcSpiritItemSize(ANeedOperItem);

          end;

      end
      else
      begin
        //评论朋友圈失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
  end;


end;

procedure TFrameSpirit.DoDelSpiritExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.DelSpirit(
        GlobalManager.User.FID,
        GlobalManager.LoginKey,
        Self.FNeedDeleteSpiritID
        );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameSpirit.DoDelSpiritExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //删除朋友圈成功
        Self.lbSpiritList.Prop.Items.Remove(FNeedDeleteSpiritItem);

      end
      else
      begin
        //删除朋友圈失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TFrameSpirit.DoGetUserInfoExecute(ATimerTask: TObject);
begin
    try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;


    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.GetUserInfo(
        FNeedGetUserID,
        GlobalManager.User.FID
        );


    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameSpirit.DoGetUserInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUser:TUser;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        AUser:=TUser.Create;
        AUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);


        {$IFNDEF IS_LISTVIEW_DEMO}
        HideFrame;//(GlobalMainFrame);
        ShowFrame(TFrame(GlobalGetUserInfoFrame),TFrameGetUserInfo,frmMain,nil,nil,nil,Application);
//        GlobalGetUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalGetUserInfoFrame.Load(AUser,ASuperObject.O['Data'].B['IsShield']);
        {$ENDIF}


        FreeAndNil(AUser);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;

procedure TFrameSpirit.DoGetUserSpiritListExecute(ATimerTask: TObject);
//var
//  AStringStream:TStringStream;
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;


    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.GetUserSpiritList(
        GlobalManager.User.FID,
        GlobalManager.LoginKey,
        FPageIndex,
        0
        );

//    AStringStream:=TStringStream.Create;
//    AStringStream.WriteString(TTimerTask(ATimerTask).TaskDesc);
//    AStringStream.Position:=0;
//    AStringStream.SaveToFile('E:\aa.json');
//    AStringStream.Free;


    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameSpirit.DoGetUserSpiritListExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  ALastTime:TDateTime;
  ADay:TDateTime;
  AListBoxItem:TSkinListBoxItem;
var
  AUserSpiritList:TUserSpiritList;
  ASuperObject:ISuperObject;
begin

  try
      if TTimerTask(ATimerTask).TaskTag=0 then
      begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        if ASuperObject.I['Code']=200 then
        begin

          AUserSpiritList:=TUserSpiritList.Create(ooReference);

          //获取朋友圈列表成功
          AUserSpiritList.ParseFromJsonArray(TUserSpirit,ASuperObject.O['Data'].A['UserSpiritList']);


          Self.lbSpiritList.Prop.Items.BeginUpdate;
          try
            if FPageIndex=1 then
            begin
              Self.lbSpiritList.Prop.Items.ClearItemsByType(sitDefault);
              FUserSpiritList.Clear(True);
            end;
            for I := 0 to AUserSpiritList.Count-1 do
            begin

              FUserSpiritList.Add(AUserSpiritList[I]);


              AListBoxItem:=Self.lbSpiritList.Prop.Items.Add;
              AListBoxItem.Data:=AUserSpiritList[I];
              AListBoxItem.Name:=IntToStr(AUserSpiritList[I].FID);
              AListBoxItem.Caption:=AUserSpiritList[I].UserName+' '+AUserSpiritList[I].CompanyName;

              AListBoxItem.Detail:=AUserSpiritList[I].Spirit;
             // AListBoxItem.Detail1:=GlobalAddSpiritFrame.btnPosition.Text;

              AListBoxItem.Detail2:=AUserSpiritList[I].Addr;
              AListBoxItem.Detail3:=AUserSpiritList[I].PhoneType;


              ADay:=Now();
              ALastTime:=StandardStrToDateTime(AUserSpiritList[I].AddTime);
              if MinutesBetween(ALastTime,ADay)<1 then
              begin
                AListBoxItem.Detail1:='刚刚';
              end
              else if MinutesBetween(ALastTime,ADay)<60 then
              begin
                AListBoxItem.Detail1:=IntToStr(MinutesBetween(ALastTime,ADay))+'分钟前';
              end
              else
              begin
                if (1<=HoursBetween(ALastTime,ADay)) and (HoursBetween(ALastTime,ADay)<24)  then
                begin
                  AListBoxItem.Detail1:=IntToStr(HoursBetween(ALastTime,ADay))+'小时前';
                end
                else
                begin
                  AListBoxItem.Detail1:=IntToStr(DaysBetween(ALastTime,ADay))+'天前';
                end;
              end;
              //自动下载
              AListBoxItem.Icon.Url:=AUserSpiritList[I].GetUserHeadPicUrl;

            end;

            CalcSpiritListItemsSize(Application.MainForm.Width);
          finally
            Self.lbSpiritList.Prop.Items.EndUpdate();
            uFuncCommon.FreeAndNil(AUserSpiritList);
          end;



        end
        else
        begin
          //获取朋友圈列表失败
          ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
        end;

      end
      else if TTimerTask(ATimerTask).TaskTag=1 then
      begin
        //网络异常
        ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
      end;
  finally
      HideWaitingFrame;


      if FPageIndex>1 then
      begin
          if ASuperObject.O['Data'].A['UserSpiritList'].Length>0 then
          begin
            Self.lbSpiritList.Prop.StopPullUpLoadMore('加载成功!',0,True);
          end
          else
          begin
            Self.lbSpiritList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
          end;
      end
      else
      begin
          Self.lbSpiritList.Prop.StopPullDownRefresh('刷新成功!',600);
      end;

  end;

end;


procedure TFrameSpirit.DoLikeSpiritExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.LikeSpirit(
        GlobalManager.User.FID,
        GlobalManager.LoginKey,
        StrToInt(TTimerTask(ATimerTask).TaskOtherInfo[0])
        );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameSpirit.DoLikeSpiritExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ANeedOperItem:TSkinItem;
  ASpiritLike:TSpiritLike;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        ANeedOperItem:=Self.lbSpiritList.Prop.Items.FindItemByName(TTimerTask(ATimerTask).TaskOtherInfo[0]);
        if (ANeedOperItem<>nil) then
        begin

          //点赞朋友圈成功
          //插入新的点赞
          ASpiritLike:=TSpiritLike.Create;
          ASpiritLike.UserID:=GlobalManager.User.FID;
          ASpiritLike.UserName:=GlobalManager.User.Name;

          TUserSpirit(ANeedOperItem.Data).LikeList.Add(ASpiritLike);
          TUserSpirit(ANeedOperItem.Data).SyncLikesDrawColorTextCollection;

          Self.CalcSpiritItemSize(ANeedOperItem);
        end;

      end
      else
      begin
        //点赞朋友圈失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
  end;

end;


procedure TFrameSpirit.DoCancelLikeSpiritExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.CancelLikeSpirit(
        GlobalManager.User.FID,
        GlobalManager.LoginKey,
        StrToInt(TTimerTask(ATimerTask).TaskOtherInfo[0])
        );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameSpirit.DoCancelLikeSpiritExecuteEnd(ATimerTask: TObject);
var
  AUserSpirit:TUserSpirit;
  ASuperObject:ISuperObject;
  ANeedOperItem:TSkinItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        ANeedOperItem:=Self.lbSpiritList.Prop.Items.FindItemByName(TTimerTask(ATimerTask).TaskOtherInfo[0]);
        if (ANeedOperItem<>nil) then
        begin

          //取消点赞朋友圈成功
          //删除点赞
          AUserSpirit:=TUserSpirit(ANeedOperItem.Data);
          if AUserSpirit.LikeList.FindByUserID(GlobalManager.User.FID)<>nil then
          begin
            AUserSpirit.LikeList.Remove(AUserSpirit.LikeList.FindByUserID(GlobalManager.User.FID));
          end;
          AUserSpirit.SyncLikesDrawColorTextCollection;

          Self.CalcSpiritItemSize(ANeedOperItem);
          
        end;

      end
      else
      begin
        //点赞朋友圈失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
  end;

end;


end.
