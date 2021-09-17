//convert pas to utf8 by ¥
unit HotelListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uUIFunction,
  uTimerTask,
  uManager,
  uBaseHttpControl,
  uInterfaceClass,

  MessageBoxFrame,
  WaitingFrame,
  EasyServiceCommonMaterialDataMoudle,

  XSuperObject,
  XSuperJson,

  uDrawCanvas,
  uSkinItems,
  uSkinListBoxType,
  uBaseList,
  uEasyServiceCommon,


  uSkinFireMonkeyButton, uSkinFireMonkeyPanel, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyRadioButton, uSkinButtonType,
  uSkinPanelType, uSkinRadioButtonType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType;

type
  TFrameHotelList = class(TFrame)
    lbHotelList: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    btnAdd: TSkinFMXButton;
    idpHotelList: TSkinFMXItemDesignerPanel;
    imgHotelPicture: TSkinFMXImage;
    lblHotelAddrCaption: TSkinFMXLabel;
    lblHotelNameCaption: TSkinFMXLabel;
    lblHotelPhoneCaption: TSkinFMXLabel;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    imgStar5: TSkinFMXImage;
    btnReturn: TSkinFMXButton;
    rbItemSelected: TSkinFMXRadioButton;
    lbHotelState: TSkinFMXListBox;
    btnSearchUserHistory: TSkinFMXButton;
    lblState: TSkinFMXLabel;
    procedure btnAddClick(Sender: TObject);
    procedure lbHotelListPullUpLoadMore(Sender: TObject);
    procedure lbHotelListPullDownRefresh(Sender: TObject);
    procedure lbHotelListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure lbHotelListClickItem(AItem: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
    procedure lbHotelStateClickItem(AItem: TSkinItem);
    procedure btnSearchUserHistoryClick(Sender: TObject);
  private
    //使用类型,比如酒店管理,选择酒店
    FUseType:TFrameUseType;

    //查看谁的酒店列表
    FFilterHotelOwnerFID:String;

    //过滤的关键字
    FFilterKeyword:String;

    FPageIndex:Integer;

    FHotelList:THotelList;

    //酒店状态
    FFilterAuditState:String;

    //是否选择酒店
    FIsNotSelected:Integer;

    //获取酒店列表
    procedure DoGetHotelListExecute(ATimerTask:TObject);
    procedure DoGetHotelListExecuteEnd(ATimerTask:TObject);
  private
    //从酒店信息页面返回
    procedure OnReturnFrameFromHotelInfo(Frame:TFrame);
    //从添加酒店页面返回
    procedure OnReturnFrameFromAddHotel(Frame:TFrame);
    //从搜索页面返回
    procedure OnReturnFromSearchHistory(Frame:TFrame);
    //从认证页面返回
    procedure OnModalResultFromSelfFrame(Frame:TObject);
    //重新认证
    procedure OnModalResultFromFillInfoFrame(Frame:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //当前选择的酒店FID
    FSelectedHotelFID:Integer;
    FSelectedHotel:THotel;

    procedure Load(
                    //标题
                    ACaption:String;
                    //使用类型,比如酒店管理,选择酒店
                    AUseType:TFrameUseType;
                    //查看谁的酒店列表
                    AFilterHotelOwnerFID:String;
                    //酒店审核状态
                    AFilterAuditState:String;
                    //上次选中的酒店
                    ASelectedHotelFID:Integer;
                    //是否需要返回按钮
                    AIsNeedReturn:Boolean;
                    //搜索关键字
                    AFilterKeyword:String;
                    //是否选择
                    AIsNotSelected:Integer
                    );
    { Public declarations }
  end;


var
  GlobalHotelListFrame:TFrameHotelList;


implementation


{$R *.fmx}

uses
  MainForm,
  MainFrame,
  AddHotelFrame,
  SearchHistoryFrame,
//  FillUserInfoFrame,
  HotelInfoFrame;


procedure TFrameHotelList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;


procedure TFrameHotelList.btnSearchUserHistoryClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //显示搜索历史搜索
  ShowFrame(TFrame(GlobalSearchHistoryFrame),TFrameSearchHistory,frmMain,nil,nil,OnReturnFromSearchHistory,Application);
//  GlobalSearchHistoryFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalSearchHistoryFrame.Load(Self.btnSearchUserHistory.Prop.HelpText,
                                'Hotel',
                                GlobalManager.UserSearchHistoryList);
end;


constructor TFrameHotelList.Create(AOwner: TComponent);
begin
  inherited;

  FHotelList:=THotelList.Create;
  Self.lbHotelList.Prop.Items.Clear(True);
end;

destructor TFrameHotelList.Destroy;
begin
  FreeAndNil(FHotelList);
  inherited;
end;

procedure TFrameHotelList.DoGetHotelListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_hotel_list',
                          AHttpControl,
                          InterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'filter_hotel_owner_fid',
                          'filter_audit_state',
                          'filter_keyword',
                          'pageindex',
                          'pagesize'],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FFilterHotelOwnerFID,
                          FFilterAuditState,
                          FFilterKeyword,
                          FPageIndex,
                          20
                          ]
                          );
      if TTimerTask(ATimerTask).TaskDesc<>'' then
      begin
        TTimerTask(ATimerTask).TaskTag:=0;
      end;

    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;
  finally
    FreeAndNil(AHttpControl);
  end;
end;

procedure TFrameHotelList.DoGetHotelListExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AHotelList:THotelList;
  AListBoxItem:TSkinListBoxItem;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //获取酒店列表成功

        AHotelList:=THotelList.Create(ooReference);
        AHotelList.ParseFromJsonArray(THotel,ASuperObject.O['Data'].A['HotelList']);


        try
          if FPageIndex=1 then
          begin
            Self.lbHotelList.Prop.Items.ClearItemsByType(sitDefault);
            FHotelList.Clear(True);


            if FUseType=futSelectList then
            begin
              if FIsNotSelected=1 then
              begin
                AListBoxItem:=Self.lbHotelList.Prop.Items.Add;
                AListBoxItem.Caption:='不选择';
                AListBoxItem.Height:=50;
                if FSelectedHotelFID=0 then
                begin
                  AListBoxItem.Selected:=True;
                end;
                Self.imgStar1.Visible:=False;
                Self.imgStar2.Visible:=False;
                Self.imgStar3.Visible:=False;
                Self.imgStar4.Visible:=False;
                Self.imgStar5.Visible:=False;
              end
              else
              begin
                Self.imgStar1.Visible:=True;
                Self.imgStar2.Visible:=True;
                Self.imgStar3.Visible:=True;
                Self.imgStar4.Visible:=True;
                Self.imgStar5.Visible:=True;
              end;
            end;

          end;

          Self.lbHotelList.Prop.Items.BeginUpdate;
          for I := 0 to AHotelList.Count-1 do
          begin

            FHotelList.Add(AHotelList[I]);


            AListBoxItem:=Self.lbHotelList.Prop.Items.Add;
            AListBoxItem.Data:=AHotelList[I];

            AListBoxItem.Caption:=AHotelList[I].name;
            AListBoxItem.Detail:=AHotelList[I].tel;
            AListBoxItem.Detail1:=AHotelList[I].addr;
            AListBoxItem.Detail2:=GetAuditStateStr(TAuditState(AHotelList[I].audit_state));

            //自动下载图标
            AListBoxItem.Icon.Url:=AHotelList[I].GetPic1Url;


            if (AHotelList[I].fid=FSelectedHotelFID) then
            begin
              AListBoxItem.Selected:=True;
              FSelectedHotel:=AHotelList[I];
            end;

          end;

        finally
          Self.lbHotelList.Prop.Items.EndUpdate();
          FreeAndNil(AHotelList);
        end;

      end
      else
      begin
        //获取失败
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
        //加载更多
        if ASuperObject.O['Data'].A['HotelList'].Length>0 then
        begin
          Self.lbHotelList.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.lbHotelList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
      //刷新
      Self.lbHotelList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;
end;

procedure TFrameHotelList.lbHotelListClickItem(AItem: TSkinItem);
var
  AHotel:THotel;
begin
  AHotel:=THotel(AItem.Data);

  if (FUseType=futManage) or (FUseType=futViewList)  then
  begin

   //查看酒店详情

    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
    //显示酒店详情
    ShowFrame(TFrame(GlobalHotelInfoFrame),TFrameHotelInfo,frmMain,nil,nil,OnReturnFrameFromHotelInfo,Application);
//    GlobalHotelInfoFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalHotelInfoFrame.Load(AHotel);
    GlobalHotelInfoFrame.Sync;

  end;


  if FUseType=futSelectList then
  begin
    if AItem.Caption='不选择' then
    begin
      FSelectedHotelFID:=0;
    end
    else
    begin
      FSelectedHotelFID:=AHotel.fid;
      FSelectedHotel:=AHotel;
    end;

    //选择完酒店,返回
    HideFrame;//(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

end;

procedure TFrameHotelList.lbHotelListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AHotel:THotel;
begin
 if AItem.Data<>nil then
 begin
    AHotel:=THotel(AItem.Data);

    Self.rbItemSelected.Position.Y:=38;

    //根据审核状态设置标题的颜色
    Self.lblState.Material.DrawCaptionParam.FontColor:=
      GetAuditStateColor(TAuditState(AHotel.audit_state));


    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=0;
    Self.imgStar5.Prop.Picture.ImageIndex:=0;
    if AHotel.star=1 then
    begin
      Self.imgStar1.Prop.Picture.ImageIndex:=1;
    end;
    if AHotel.star=2 then
    begin
      Self.imgStar1.Prop.Picture.ImageIndex:=1;
      Self.imgStar2.Prop.Picture.ImageIndex:=1;
    end
    else if AHotel.star=3 then
    begin
      Self.imgStar1.Prop.Picture.ImageIndex:=1;
      Self.imgStar2.Prop.Picture.ImageIndex:=1;
      Self.imgStar3.Prop.Picture.ImageIndex:=1;
    end
    else if AHotel.star=4 then
    begin
      Self.imgStar1.Prop.Picture.ImageIndex:=1;
      Self.imgStar2.Prop.Picture.ImageIndex:=1;
      Self.imgStar3.Prop.Picture.ImageIndex:=1;
      Self.imgStar4.Prop.Picture.ImageIndex:=1;
    end
    else if AHotel.star=5 then
    begin
      Self.imgStar1.Prop.Picture.ImageIndex:=1;
      Self.imgStar2.Prop.Picture.ImageIndex:=1;
      Self.imgStar3.Prop.Picture.ImageIndex:=1;
      Self.imgStar4.Prop.Picture.ImageIndex:=1;
      Self.imgStar5.Prop.Picture.ImageIndex:=1;
    end;

 end
 else
 begin
   Self.rbItemSelected.Position.Y:=10;
 end;

end;

procedure TFrameHotelList.lbHotelListPullDownRefresh(Sender: TObject);
begin
  //刷新
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                         DoGetHotelListExecute,
                                         DoGetHotelListExecuteEnd);
end;

procedure TFrameHotelList.lbHotelListPullUpLoadMore(Sender: TObject);
begin
  //加载下一页
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                         DoGetHotelListExecute,
                                         DoGetHotelListExecuteEnd);
end;

procedure TFrameHotelList.lbHotelStateClickItem(AItem: TSkinItem);
begin
  Self.lbHotelList.Prop.Items.Clear(True);
  //点击酒店分类
  if FFilterAuditState<>AItem.Name then
  begin
    FFilterAuditState:=AItem.Name;
    Self.lbHotelList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameHotelList.Load(ACaption:String;
                                AUseType:TFrameUseType;
                                AFilterHotelOwnerFID:String;
                                AFilterAuditState:String;
                                ASelectedHotelFID:Integer;
                                AIsNeedReturn:Boolean;
                                AFilterKeyword:String;
                                AIsNotSelected:Integer);
begin

  FUseType:=AUseType;

  FIsNotSelected:=AIsNotSelected;

  FFilterHotelOwnerFID:=AFilterHotelOwnerFID;
  FFilterAuditState:=AFilterAuditState;
  FFilterKeyword:=AFilterKeyword;

  //上次选中的酒店
  FSelectedHotelFID:=ASelectedHotelFID;


//  Self.rbItemSelected.Visible:=True;
//  Self.btnAdd.Visible:=True;
//  Self.btnSearchUserHistory.Visible:=False;



  //酒店管理
  if FUseType=futManage then
  begin
      Self.btnReturn.Visible:=AIsNeedReturn;
      Self.rbItemSelected.Visible:=False;
      Self.btnSearchUserHistory.Visible:=False;
      Self.pnlToolBar.Caption:=ACaption;

      if GlobalManager.User.is_hotel_manager=1 then
      begin
        //酒店经理登录
        Self.lbHotelState.Visible:=False;
        //可以添加酒店
        Self.btnAdd.Visible:=True;
        //有添加按钮,右边不需要空出来
        Self.btnSearchUserHistory.Margins.Right:=0;
      end
      else
      begin
        //员工
        Self.lbHotelState.Visible:=True;
        //不能添加酒店
        Self.btnAdd.Visible:=False;
        //有添加按钮,右边不需要空出来
        Self.btnSearchUserHistory.Margins.Right:=20;
      end;

  end;

  //选择酒店
  if FUseType=futSelectList then
  begin
      Self.btnReturn.Visible:=AIsNeedReturn;
      Self.btnAdd.Visible:=False;
      Self.rbItemSelected.Visible:=True;

      Self.btnSearchUserHistory.Visible:=True;
      Self.pnlToolBar.Caption:='';

      //选择酒店不需要显示审核状态栏
      Self.lbHotelState.Visible:=False;

      //没有添加按钮,右边需要空出来
      Self.btnSearchUserHistory.Margins.Right:=20;
  end;

  //仅查看酒店列表(指定酒店经理的)
  if FUseType=futViewList then
  begin
      Self.btnReturn.Visible:=AIsNeedReturn;
      Self.btnAdd.Visible:=False;
      Self.rbItemSelected.Visible:=False;
      Self.btnSearchUserHistory.Visible:=False;
      Self.pnlToolBar.Caption:=ACaption;
      //选择酒店不需要显示审核状态栏
      Self.lbHotelState.Visible:=False;
      //没有添加按钮,右边需要空出来
      Self.btnSearchUserHistory.Margins.Right:=20;
  end;



  if Self.lbHotelState.Prop.Items.FindItemByName(AFilterAuditState)<>nil then
  begin
    Self.lbHotelState.Prop.Items.FindItemByName(AFilterAuditState).Selected:=True;
  end;


  //刷新酒店列表
  Self.lbHotelList.Prop.Items.Clear(True);
  Self.lbHotelList.Prop.StartPullDownRefresh;

 end;

procedure TFrameHotelList.OnModalResultFromFillInfoFrame(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在本页面
  end;
//  if TFrameMessageBox(Frame).ModalResult='继续' then
//  begin
//
//    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//    //显示实名认证界面
//    ShowFrame(TFrame(GlobalFillUserInfoFrame),TFrameFillUserInfo,frmMain,nil,nil,nil,Application);
//    GlobalFillUserInfoFrame.Clear;
//    GlobalFillUserInfoFrame.FPageIndex:=2;
//
//  end;
end;

procedure TFrameHotelList.OnModalResultFromSelfFrame(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='暂时不用' then
  begin
    //留在本页面
  end;
//  if TFrameMessageBox(Frame).ModalResult='去认证' then
//  begin
//
//    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//    //显示实名认证界面
//    ShowFrame(TFrame(GlobalFillUserInfoFrame),TFrameFillUserInfo,frmMain,nil,nil,nil,Application);
//    GlobalFillUserInfoFrame.Clear;
//    GlobalFillUserInfoFrame.FPageIndex:=2;
//
//  end;
end;

procedure TFrameHotelList.OnReturnFrameFromAddHotel(Frame: TFrame);
begin
  //添加酒店之后,返回需要刷新
  Self.lbHotelList.Prop.StartPullDownRefresh;
end;

procedure TFrameHotelList.OnReturnFrameFromHotelInfo(Frame: TFrame);
begin
  if GlobalIsAddHotelChanged then
  begin
    GlobalIsAddHotelChanged:=False;
    //修改酒店之后,返回需要刷新
    Self.lbHotelList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameHotelList.OnReturnFromSearchHistory(Frame: TFrame);
begin
  FFilterKeyword:=GlobalSearchHistoryFrame.edtSearch.Text;
  Self.btnSearchUserHistory.Caption:=FFilterKeyword;

  Self.lbHotelList.Prop.StartPullDownRefresh;
end;

procedure TFrameHotelList.btnAddClick(Sender: TObject);
begin

  if GlobalManager.User.cert_audit_state=0 then
  begin
    ShowMessageBoxFrame(Self,'您还没有进行实名认证,是否去认证?','',TMsgDlgType.mtInformation,['暂时不去','去认证'],OnModalResultFromSelfFrame);
    Exit;
  end;

  if GlobalManager.User.cert_audit_state=-1 then
  begin
    ShowMessageBoxFrame(Self,'您的实名认证信息正在审核中，请您耐心等待!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if GlobalManager.User.cert_audit_state=2 then
  begin
    ShowMessageBoxFrame(Self,'您的实名认证信息被拒绝,是否继续认证?','',TMsgDlgType.mtInformation,['取消','继续认证'],OnModalResultFromFillInfoFrame);
    Exit;
  end;

  if GlobalManager.User.audit_state=Ord(asDefault) then
  begin
    ShowMessageBoxFrame(Self,'账号审核通过才能添加酒店,请先申请介绍人!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if GlobalManager.User.audit_state=Ord(asRequestAudit) then
  begin
    ShowMessageBoxFrame(Self,'您的账号正在审核中，请耐心等待!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if GlobalManager.User.audit_state=Ord(asAuditReject) then
  begin
    ShowMessageBoxFrame(Self,'您的挂钩申请审核拒绝，请您重新申请介绍人!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //添加酒店
  ShowFrame(TFrame(GlobalAddHotelFrame),TFrameAddHotel,frmMain,nil,nil,OnReturnFrameFromAddHotel,Application);
//  GlobalAddHotelFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddHotelFrame.Clear;
  GlobalAddHotelFrame.Add;
end;

end.
