//convert pas to utf8 by ¥

unit WaterfallSpiritFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Math,


  uSkinBufferBitmap,
  uDrawCanvas,
  uDrawPicture,
  uSkinItems,
  uBaseList,
  uFuncCommon,
  uGraphicCommon,
  uSkinListBoxType,
  uSkinListViewType,



  WaitingFrame,
  MessageBoxFrame,
  {$IFNDEF IS_LISTVIEW_DEMO}
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
  uSkinFireMonkeyCustomList, uSkinLabelType, uSkinImageType,
  uSkinRoundImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uSkinPanelType;

type
  TFrameWaterfallSpirit = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbSpiritList: TSkinFMXListView;
    btnWriteMind: TSkinFMXButton;
    tmrRePaint: TTimer;
    idpHuaBan: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXRoundImage;
    pnlItemInfo: TSkinFMXPanel;
    imgItemPic: TSkinFMXRoundImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    procedure btnWriteMindClick(Sender: TObject);
    procedure plpTopExecuteLoad(Sender: TObject);
    procedure plpBottomExecuteLoad(Sender: TObject);
    procedure lbSpiritListResize(Sender: TObject);
    procedure tmrRePaintTimer(Sender: TObject);
    procedure lbSpiritListClickItem(AItem: TSkinItem);
    procedure lbSpiritListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure imgItemPicClick(Sender: TObject);
  private

    FPageIndex:Integer;
    FPageCount:Integer;
    FWantedUserID:Integer;
    FUserSpiritList:TUserSpiritList;

    procedure DoReturnFrameFromAddSpiritFrame(Frame:TFrame);

    procedure CalcSpiritListItemSize(AWidth:Double);

    procedure DoGetUserSpiritListExecute(ATimerTask:TObject);
    procedure DoGetUserSpiritListExecuteEnd(ATimerTask:TObject);

    procedure DoGetUserInfoExecute(ATimerTask:TObject);
    procedure DoGetUserInfoExecuteEnd(ATimerTask:TObject);
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
  ViewPictureListFrame,
  uViewPictureListFrame,
  AddSpiritFrame
  {$ENDIF}
  ;


const
  ColorArray:Array [0..7] of TAlphaColor=
      ($FFF3C639,$FFFE7322,$FFE92C40,$FFC61317,
      $FF508B17,$FF2595AB,$FF0A5193,$FF4A2E9D)
          ;

{$R *.fmx}

procedure TFrameWaterfallSpirit.btnWriteMindClick(Sender: TObject);
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

procedure TFrameWaterfallSpirit.DoReturnFrameFromAddSpiritFrame(Frame: TFrame);
begin
  Self.lbSpiritList.Prop.StartPullDownRefresh;
end;

procedure TFrameWaterfallSpirit.imgItemPicClick(Sender: TObject);
var
  AUserSpirit:TUserSpirit;
begin
    AUserSpirit:=TUserSpirit(Self.lbSpiritList.Prop.InteractiveItem.Data);
    FWantedUserID:=AUserSpirit.UserID;
    ShowWaitingFrame(Self,'加载中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                    DoGetUserInfoExecute,
                    DoGetUserInfoExecuteEnd
                    );

end;

procedure TFrameWaterfallSpirit.lbSpiritListClickItem(AItem: TSkinItem);
begin

    {$IFNDEF IS_LISTVIEW_DEMO}
  //传入Index
  if (AItem.Icon.Url<>'') then
  begin
    //查看照片信息
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    //查看照片信息
    ShowFrame(TFrame(GlobalViewPictureListFrame),TFrameViewPictureList,frmMain,nil,nil,nil);
//    GlobalViewPictureListFrame.FrameHistroy:=CurrentFrameHistroy;
    TUserSpirit(AItem.Data).PicList[0].WebUrlPicture;
    GlobalViewPictureListFrame.Init('照片',
        TUserSpirit(AItem.Data).PicList,
        0,
        //原图URL
        TUserSpirit(AItem.Data).OriginPicUrlList
        );
  end;
  {$ENDIF}
end;

procedure TFrameWaterfallSpirit.lbSpiritListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if (AItem.Icon.UrlPicture<>nil) and (AItem.Icon.UrlPicture.Picture<>nil) then
  begin
    //图片已经下载
    //不用画背景色
    Self.imgItemIcon.SelfOwnMaterialToDefault.BackColor.IsFill:=False;
  end
  else
  begin
    //图片已经下载
    //不用画背景色
    Self.imgItemIcon.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
    Self.imgItemIcon.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=AItem.Color;
  end;
end;

procedure TFrameWaterfallSpirit.lbSpiritListResize(Sender: TObject);
begin
  CalcSpiritListItemSize(Application.MainForm.Width);

end;

procedure TFrameWaterfallSpirit.Load;
begin
  Self.lbSpiritList.Prop.StartPullDownRefresh;
end;

procedure TFrameWaterfallSpirit.plpBottomExecuteLoad(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
        DoGetUserSpiritListExecute,
        DoGetUserSpiritListExecuteEnd
        );
end;

procedure TFrameWaterfallSpirit.plpTopExecuteLoad(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
        DoGetUserSpiritListExecute,
        DoGetUserSpiritListExecuteEnd
        );
end;

procedure TFrameWaterfallSpirit.tmrRePaintTimer(Sender: TObject);
begin
  Self.lbSpiritList.Invalidate;
end;

procedure TFrameWaterfallSpirit.CalcSpiritListItemSize(AWidth:Double);
var
  I: Integer;
  AUserSpirit:TUserSpirit;
  APicturesHeight:Double;
  AThumbPicturesSize:TSizeF;
  AImageDrawRect:TRectF;
  AListViewItem:TSkinListViewItem;
begin

  Self.lbSpiritList.Prop.Items.BeginUpdate;
  try


    for I := 0 to Self.lbSpiritList.Prop.Items.Count-1 do
    begin
      AListViewItem:=Self.lbSpiritList.Prop.Items[I];
      AUserSpirit:=TUserSpirit(AListViewItem.Data);
      if AUserSpirit=nil then Continue;

      if (AUserSpirit.Pic1Path='') then
      begin
        //没有图片
        APicturesHeight:=30;

      end
      else
      begin
        //有图片
        if AUserSpirit.Pic1Width=0 then
        begin
          //没有宽度
          APicturesHeight:=100;
        end
        else
        begin
          //有宽度
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
          //图片参数先设置成自适应,
          //因为在界面上我设计时用了拉伸效果，
          imgItemIcon.SelfOwnMaterialToDefault.DrawPictureParam.IsStretch:=False;
          imgItemIcon.SelfOwnMaterialToDefault.DrawPictureParam.IsAutoFit:=True;
          CalcImageDrawRect(
                  imgItemIcon.SelfOwnMaterialToDefault.DrawPictureParam,
                  Ceil(AThumbPicturesSize.cx),
                  Ceil(AThumbPicturesSize.cy),
                  RectF(0,0,
                        Self.lbSpiritList.Prop.ListLayoutsManager.GetItemDefaultWidth,
                        AThumbPicturesSize.cy),
                  AImageDrawRect
                  );
          APicturesHeight:=AImageDrawRect.Height;
        end;

      end;

      AListViewItem.Height:=Self.pnlItemInfo.Height+APicturesHeight;

    end;
  finally
    Self.lbSpiritList.Prop.Items.EndUpdate();
  end;
end;

constructor TFrameWaterfallSpirit.Create(AOwner: TComponent);
begin
  inherited;

  Self.lbSpiritList.Prop.IsItemMouseEventNeedCallPrepareDrawItem:=False;

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

destructor TFrameWaterfallSpirit.Destroy;
begin

  uFuncCommon.FreeAndNil(FUserSpiritList);

  inherited;
end;

procedure TFrameWaterfallSpirit.DoGetUserSpiritListExecute(ATimerTask: TObject);
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

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameWaterfallSpirit.DoGetUserSpiritListExecuteEnd(ATimerTask: TObject);
var
  I: Integer;
  AColorIndex:Integer;
  AListViewItem:TSkinListViewItem;
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

          AColorIndex:=0;
          for I := 0 to AUserSpiritList.Count-1 do
          begin
            FUserSpiritList.Add(AUserSpiritList[I]);


            AListViewItem:=Self.lbSpiritList.Prop.Items.Add;
            AListViewItem.Data:=AUserSpiritList[I];

            AListViewItem.Color:=ColorArray[AColorIndex mod 8];
            if AUserSpiritList[I].Pic1Path='' then
            begin
              Inc(AColorIndex);
            end;

            //标题
            AListViewItem.Caption:=AUserSpiritList[I].Spirit;

            //作者
            AListViewItem.Detail:=AUserSpiritList[I].UserName;
            //日期
            AListViewItem.Detail1:=FormatDateTime('MM-DD HH:MM',StandardStrToDateTime(AUserSpiritList[I].AddTime));


            //自动下载
            AListViewItem.Icon.Url:=AUserSpiritList[I].GetPic1Url(True);
            AListViewItem.Pic.Url:=AUserSpiritList[I].GetUserHeadPicUrl;

          end;

          CalcSpiritListItemSize(Application.MainForm.Width);
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


procedure TFrameWaterfallSpirit.DoGetUserInfoExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;


    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.GetUserInfo(
        FWantedUserID,
        GlobalManager.User.FID);


    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameWaterfallSpirit.DoGetUserInfoExecuteEnd(ATimerTask: TObject);
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

end.
