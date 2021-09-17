//convert pas to utf8 by ¥
unit HotelInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uTimerTask,
  uUIFunction,
  uManager,
  uSkinItems,
  uEasyServiceCommon,
  uInterfaceClass,
  uBaseHttpControl,
  uSkinControlGestureManager,

  HintFrame,
  WaitingFrame,
  MessageBoxFrame,


  XSuperObject,
  XSuperJson,
  EasyServiceCommonMaterialDataMoudle,

  uSkinBufferBitmap,
//  AuditFrame,


  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyImageListViewer, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uDrawPicture,
  uSkinImageList, uSkinFireMonkeyImage, uSkinFireMonkeyLabel, uSkinButtonType,
  uSkinImageListViewerType, uSkinImageType, uSkinLabelType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinPanelType;

type
  TFrameHotelInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlName: TSkinFMXPanel;
    pnlLastDevide: TSkinFMXPanel;
    pnlStar: TSkinFMXPanel;
    pnlEmpty3: TSkinFMXPanel;
    pnlHotelStar: TSkinFMXPanel;
    pnlEmpty4: TSkinFMXPanel;
    imgPlayer: TSkinFMXImageListViewer;
    pnlAddr: TSkinFMXPanel;
    pnlRecvAddr: TSkinFMXPanel;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    imgStar5: TSkinFMXImage;
    lblHotelName: TSkinFMXLabel;
    lblHotelPhone: TSkinFMXLabel;
    lblAddr: TSkinFMXLabel;
    IlPictureList2: TSkinImageList;
    btnRecvAddr: TSkinFMXButton;
    pnlArea: TSkinFMXPanel;
    lblArea: TSkinFMXLabel;
    btnDelete: TSkinFMXButton;
    btnEdit: TSkinFMXButton;
    bgPictureGroup: TSkinFMXButtonGroup;
    pnlUser: TSkinFMXPanel;
    lblRecvName: TSkinFMXLabel;
    lblRecvPhone: TSkinFMXLabel;
    lblRecvAddr: TSkinFMXLabel;
    pnlButton: TSkinFMXPanel;
    btnItemOper1: TSkinFMXButton;
    lblAuditState: TSkinFMXLabel;
    pnlHotelFirstGoodsList: TSkinFMXPanel;
    btnLookFirstGoods: TSkinFMXButton;
    pnlRoomNumber: TSkinFMXPanel;
    pnlClassify: TSkinFMXPanel;
    lblClassify: TSkinFMXLabel;
    lblRoomNumber: TSkinFMXLabel;
    pnlEmpty5: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    pnlHotelManager: TSkinFMXPanel;
    btnHotelManager: TSkinFMXButton;
    SkinFMXPanel3: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure sbcClientResize(Sender: TObject);
    procedure imgPlayerResize(Sender: TObject);
    procedure btnRecvAddrStayClick(Sender: TObject);
    procedure btnDeleteStayClick(Sender: TObject);
    procedure btnItemOper1Click(Sender: TObject);
    procedure btnLookFirstGoodsClick(Sender: TObject);
    procedure btnHotelManagerStayClick(Sender: TObject);
  private
    //引用
    FHotel:THotel;
    FUser:TUser;

    FOrderGoodsList:TOrderGoodsList;
    FHotelManagerFID:Integer;

    //获取酒店详情
    procedure DoGetHotelInfoExecute(ATimerTask:TObject);
    procedure DoGetHotelInfoExecuteEnd(ATimerTask:TObject);

    //获取酒店经理个人信息
    procedure DoGetUserExecute(ATimerTask:TObject);
    procedure DoGetUserExecuteEnd(ATimerTask:TObject);

  private

    //获取酒店首次铺货列表
    procedure DoGetHotelFirstGoodsListExecute(ATimerTask:TObject);
    procedure DoGetHotelFirstGoodsListExecuteEnd(ATimerTask:TObject);

  private
    //删除酒店
    procedure DoDelHotelExecute(ATimerTask:TObject);
    procedure DoDelHotelExecuteEnd(ATimerTask:TObject);

  private
    //申请审核酒店
    procedure DoRequestAuditHotelExecute(ATimerTask:TObject);
    procedure DoRequestAuditHotelExecuteEnd(ATimerTask:TObject);

  private
    //审核酒店返回
    procedure OnReturnFrameFromAuditHotelFrame(Frame:TFrame);

  private
    //删除酒店对话框
    procedure OnModalResultFromDeleteHotel(Frame:TObject);
    //申请审核酒店对话框
    procedure OnModalResultFromRequestAuditHotel(Frame:TObject);
    //修改酒店返回
    procedure OnReturnFrameFromEditHotel(Frame:TFrame);
    //酒店收货地址返回(可能修改过默认的收货地址或编辑过)
    procedure OnReturnFrameFromHotelRecvAddrList(Frame:TFrame);
  private
    //清除收货地址
    procedure ClearHotelRecvAddr;
    //加载收货地址
    procedure LoadHotelRecvAddrToUI(AHotelRecvAddr:THotelRecvAddr);
  private
    //处理ImageListViewer和ScrollBox的手势冲突
    procedure DoScrollBoxVertManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load(AHotel:THotel);
    //刷新
    procedure Sync;
    { Public declarations }
  end;


var
  GlobalHotelInfoFrame:TFrameHotelInfo;


implementation

{$R *.fmx}

uses
  HotelListFrame,
  HotelRecvAddrListFrame,
  OrderGoodsListFrame,
//  UserInfoFrame,
  MainForm,
  MainFrame,
  AddHotelFrame;



{ TFrameHotelInfo }

procedure TFrameHotelInfo.btnEditClick(Sender: TObject);
begin
  //编辑酒店
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalAddHotelFrame),TFrameAddHotel,frmMain,nil,nil,OnReturnFrameFromEditHotel,Application);
//  GlobalAddHotelFrame.FrameHistroy:=CurrentFrameHistroy;

  GlobalAddHotelFrame.Clear;
  GlobalAddHotelFrame.Edit(FHotel);
end;


procedure TFrameHotelInfo.btnHotelManagerStayClick(Sender: TObject);
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                         DoGetUserExecute,
                         DoGetUserExecuteEnd);
end;

procedure TFrameHotelInfo.btnItemOper1Click(Sender: TObject);
begin

  if TSkinFMXButton(Sender).Caption='请求审核' then
  begin
      //发送审核请求
      ShowMessageBoxFrame(Self,
                          '是否立即申请审核？'+'请确保酒店资料齐全',
                          '',
                          TMsgDlgType.mtInformation,
                          ['确定','取消'],
                          OnModalResultFromRequestAuditHotel);
  end
//  else
//  if TSkinFMXButton(Sender).Caption='审核' then
//  begin
//      //隐藏
//      HideFrame;//(Self,hfcttBeforeShowFrame);
//
//      //审核意见
//      ShowFrame(TFrame(GlobalAuditFrame),TFrameAudit,frmMain,nil,nil,OnReturnFrameFromAuditHotelFrame,Application);
//      GlobalAuditFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalAuditFrame.Load('审核酒店',
//                            'audit_hotel',
//                            'audit',
//                            FHotel.fid);
//
//  end
  ;

end;


procedure TFrameHotelInfo.btnLookFirstGoodsClick(Sender: TObject);
begin
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                       DoGetHotelFirstGoodsListExecute,
                       DoGetHotelFirstGoodsListExecuteEnd);
end;


procedure TFrameHotelInfo.btnDeleteStayClick(Sender: TObject);
begin
  //删除酒店
  ShowMessageBoxFrame(Self,'确定删除?','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromDeleteHotel);

end;


procedure TFrameHotelInfo.btnRecvAddrStayClick(Sender: TObject);
begin
  if GlobalManager.User.fid=FHotel.user_fid then
  begin
    //只能酒店经理自己管理酒店的收货地址

    //收货地址管理
    HideFrame;//(Self,hfcttBeforeShowFrame);

    ShowFrame(TFrame(GlobalHotelRecvAddrListFrame),TFrameHotelRecvAddrList,frmMain,nil,nil,OnReturnFrameFromHotelRecvAddrList,Application);
//    GlobalHotelRecvAddrListFrame.FrameHistroy:=CurrentFrameHistroy;

    GlobalHotelRecvAddrListFrame.Load('收货地址管理',
                                        futManage,
                                        FHotel.fid,
                                        FHotel,
                                        0);
  end;
end;

procedure TFrameHotelInfo.btnReturnClick(Sender: TObject);
begin

  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameHotelInfo.ClearHotelRecvAddr;
begin
  Self.lblRecvName.Caption:='';
  Self.lblRecvPhone.Caption:='';
  Self.lblRecvAddr.Caption:='';

end;

constructor TFrameHotelInfo.Create(AOwner: TComponent);
begin
  inherited;
  FOrderGoodsList:=TOrderGoodsList.Create;
  FUser:=TUser.Create;
  //处理ImageListViewer和ScrollBox的手势冲突
  Self.sbClient.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.sbClient.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
            Self.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind;

end;


destructor TFrameHotelInfo.Destroy;
begin
  inherited;
  FreeAndNil(FOrderGoodsList);
  FreeAndNil(FUser);
end;


procedure TFrameHotelInfo.DoRequestAuditHotelExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
              SimpleCallAPI('request_audit_hotel',
                            AHttpControl,
                            InterfaceUrl,
                            ['appid',
                            'user_fid',
                            'key',
                            'hotel_fid'],
                            [AppID,
                            GlobalManager.User.fid,
                            GlobalManager.User.key,
                            FHotel.fid//酒店FID
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


procedure TFrameHotelInfo.DoRequestAuditHotelExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //申请审核过酒店,返回需要刷新
          GlobalIsAddHotelChanged:=True;

          //获取酒店信息成功
          FHotel.ParseFromJson(ASuperObject.O['Data'].A['Hotel'].O[0]);
          Load(FHotel);

          ShowHintFrame(Self,'申请成功!');

      end
      else
      begin
        //调用失败
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
    Self.sbClient.Prop.StopPullDownRefresh();
  end;
end;


procedure TFrameHotelInfo.DoDelHotelExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
              SimpleCallAPI('del_hotel',
                            AHttpControl,
                            InterfaceUrl,
                            ['appid',
                            'user_fid',
                            'key',
                            'hotel_fid'],
                            [AppID,
                            GlobalManager.User.fid,
                            GlobalManager.User.key,
                            FHotel.fid//酒店FID
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


procedure TFrameHotelInfo.DoDelHotelExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //删除酒店成功
          //返回刷新
          HideFrame;////(Self,hfcttBeforeReturnFrame);
          ReturnFrame;//(Self.FrameHistroy);

      end
      else
      begin
          //删除失败
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


procedure TFrameHotelInfo.DoGetHotelFirstGoodsListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                SimpleCallAPI('get_hotel_first_order_goods_list',
                              AHttpControl,
                              InterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'hotel_fid'
                              ],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              Self.FHotel.fid]
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


procedure TFrameHotelInfo.DoGetHotelFirstGoodsListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FOrderGoodsList.Clear(True);

        FOrderGoodsList.ParseFromJsonArray(TOrderGoods,ASuperObject.O['Data'].A['HotelFirstOrderGoodsList']);
        //获取首次铺货商品列表成功
        //隐藏
        HideFrame;//(Self,hfcttBeforeShowFrame);

        //获取首次铺货商品列表
        ShowFrame(TFrame(GlobalOrderGoodsListFrame),TFrameOrderGoodsList,frmMain,nil,nil,nil,Application);

        GlobalOrderGoodsListFrame.LoadGoodsList(FOrderGoodsList);
//        GlobalOrderGoodsListFrame.FrameHistroy:=CurrentFrameHistroy;
      end
      else
      begin
        //调用失败
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


procedure TFrameHotelInfo.DoGetHotelInfoExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                SimpleCallAPI('get_hotel',
                              AHttpControl,
                              InterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'hotel_fid'],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              Self.FHotel.fid
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



procedure TFrameHotelInfo.DoGetHotelInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //获取酒店信息成功
          FHotel.ParseFromJson(ASuperObject.O['Data'].A['Hotel'].O[0]);
          Load(FHotel);


      end
      else
      begin
        //调用失败
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
    Self.sbClient.Prop.StopPullDownRefresh();
  end;
end;

procedure TFrameHotelInfo.DoGetUserExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    [
                                                    'appid',
                                                    'emp_fid',
                                                    'key',
                                                    'man_fid'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FHotelManagerFID
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

procedure TFrameHotelInfo.DoGetUserExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //获取用户信息成功

        //刷新用户信息
        FUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);

        //隐藏
        HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

        //显示用户信息
//        ShowFrame(TFrame(GlobalUserInfoFrame),TFrameUserInfo,frmMain,nil,nil,nil,Application);
//        GlobalUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//        GlobalUserInfoFrame.Load(FUser);
//        GlobalUserInfoFrame.Sync;


      end
      else
      begin
        //注册失败
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

procedure TFrameHotelInfo.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  APlayerOriginPoint:TPointF;
  AFirstItemRect:TRectF;
begin
  //传给ScrollBox的是相对窗体的绝对坐标
  //广告轮播Item的绘制区域
  APlayerOriginPoint:=PointF(0,0);
  APlayerOriginPoint:=imgPlayer.LocalToAbsolute(APlayerOriginPoint);
  AFirstItemRect:=RectF(APlayerOriginPoint.X,APlayerOriginPoint.Y,
                        APlayerOriginPoint.X+Self.imgPlayer.Width,
                        APlayerOriginPoint.Y+Self.imgPlayer.Height
                        );
  if PtInRect(AFirstItemRect,PointF(AMouseMoveX,AMouseMoveY)) then
  begin
    //在广告轮播控件内,那么要检查初始手势方向
  end
  else
  begin
    //不在在广告轮播控件内,那么随意滑动
    //AIsDecidedFirstGestureKind表示我已经确定好方向了，不需要再判断了
    //ADecidedFirstGestureKind表示判断好的方向
    AIsDecidedFirstGestureKind:=True;
    ADecidedFirstGestureKind:=TGestureKind.gmkVertical;
  end;

end;

procedure TFrameHotelInfo.imgPlayerResize(Sender: TObject);
begin
  //设置按钮分组的位置
  Self.bgPictureGroup.Position.X:=Self.sbClient.Width
                          -Self.IlPictureList2.Count*Self.bgPictureGroup.Height
                          -20;
  Self.bgPictureGroup.Position.Y:=Self.imgPlayer.Height-20;
end;

procedure TFrameHotelInfo.Load(AHotel:THotel);
var
  I:Integer;
  ADrawPicture:TDrawPicture;
begin
  FHotel:=AHotel;


  //编辑和删除,只有酒店经理能删除
  Self.btnEdit.Visible:=(GlobalManager.User.fid=AHotel.user_fid);
  Self.btnDelete.Visible:=(GlobalManager.User.fid=AHotel.user_fid);
  Self.btnDelete.Top:=Self.pnlLastDevide.Top+Self.pnlLastDevide.Height;
  //只有酒店经理能管理收货地址按钮
  //其他人看酒店详情时,收货地址按钮的箭头不显示
  Self.btnRecvAddr.Prop.IsPushed:=(GlobalManager.User.fid<>AHotel.user_fid);


  if AHotel.is_ordered=1 then
  begin
    Self.pnlHotelFirstGoodsList.Visible:=True;
  end
  else
  begin
    Self.pnlHotelFirstGoodsList.Visible:=False;
  end;


  if GlobalManager.User.is_hotel_manager=1 then
  begin
    Self.pnlHotelManager.Visible:=False;
  end
  else
  begin
    Self.pnlHotelManager.Visible:=True;
    Self.btnHotelManager.Caption:=AHotel.user_name;
    FHotelManagerFID:=AHotel.user_fid;
  end;

  if AHotel.audit_state=Ord(asRequestAudit) then
  begin
    //待审核
    if GlobalManager.User.is_hotel_manager=1 then
    begin
      Self.pnlButton.Visible:=False;
      if GlobalManager.User.fid=FHotel.user_fid then
      begin
        Self.btnDelete.Visible:=True;
      end
      else
      begin
        Self.btnDelete.Visible:=False;
      end;
    end
    else
    begin
      Self.pnlButton.Visible:=True;
      Self.btnItemOper1.Caption:='审核';
    end;
  end
  else if AHotel.audit_state=Ord(asDefault) then
  begin
    //未审核
    if GlobalManager.User.is_hotel_manager=1 then
    begin
      if GlobalManager.User.fid=FHotel.user_fid then
      begin
        Self.btnDelete.Visible:=True;
        Self.pnlButton.Visible:=True;
        Self.btnItemOper1.Caption:='请求审核';
      end
      else
      begin
        Self.btnDelete.Visible:=False;
        Self.pnlButton.Visible:=False;
        Self.btnDelete.Visible:=False;
      end;
    end
    else
    begin
      Self.pnlButton.Visible:=False;
    end;
  end
  else if AHotel.audit_state=Ord(asAuditPass) then
  begin
    //审核通过
    Self.pnlButton.Visible:=False;
    Self.btnDelete.Visible:=False;
  end
  else if AHotel.audit_state=Ord(asAuditReject) then
  begin
    //审核拒绝
    if GlobalManager.User.is_hotel_manager=1 then
    begin
      if GlobalManager.User.fid=FHotel.user_fid then
      begin
        Self.btnDelete.Visible:=True;
        Self.pnlButton.Visible:=True;
        Self.btnItemOper1.Caption:='请求审核';
      end
      else
      begin
        Self.btnDelete.Visible:=False;
        Self.pnlButton.Visible:=False;
        Self.btnDelete.Visible:=False;
      end;
    end
    else
    begin
      Self.pnlButton.Visible:=False;
    end;
  end;



  //添加酒店图片
  Self.IlPictureList2.PictureList.Clear(True);
  if AHotel.pic1path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AHotel.GetPic1Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AHotel.pic2path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AHotel.GetPic2Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AHotel.pic3path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AHotel.GetPic3Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AHotel.pic4path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AHotel.GetPic4Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AHotel.pic5path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AHotel.GetPic5Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AHotel.pic6path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AHotel.GetPic6Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  Self.imgPlayer.Prop.Picture.ImageIndex:=0;
  Self.imgPlayer.Prop.AlignSwitchButtons;
  Self.imgPlayerResize(Self);



  Self.lblHotelName.Caption:=AHotel.name;
  //审核状态
  Self.lblAuditState.Caption:=GetAuditStateStr(TAuditState(AHotel.audit_state));
  Self.lblAuditState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=GetAuditStateColor(TAuditState(AHotel.audit_state));
  //酒店类型
  Self.lblClassify.Caption:=AHotel.classify_name;
  //酒店房间数
  Self.lblRoomNumber.Caption:=IntToStr(AHotel.room_num);
  Self.lblHotelPhone.Caption:=AHotel.tel;
  //所在地区
  Self.lblArea.Text:=AHotel.GetArea;
  //详细地址
  Self.lblAddr.Caption:=AHotel.addr;
  Self.pnlAddr.Height:=GetSuitContentHeight(lblAddr.Width,
                                            lblAddr.Caption,
                                            14,
                                            Self.pnlArea.Height
                                            );




  //设置酒店星级
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


  //默认收货地址
  ClearHotelRecvAddr;
  Self.LoadHotelRecvAddrToUI(FHotel.RecvAddrList.GetDefaultRecvAddr);


  Self.sbcClientResize(Self);


  //初始位置
  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

procedure TFrameHotelInfo.LoadHotelRecvAddrToUI(AHotelRecvAddr: THotelRecvAddr);
begin
  if AHotelRecvAddr<>nil then
  begin
    Self.lblRecvName.Caption:=AHotelRecvAddr.name;
    Self.lblRecvPhone.Caption:=AHotelRecvAddr.phone;
    Self.lblRecvAddr.Caption:=AHotelRecvAddr.GetLongAddr;
  end;
end;

procedure TFrameHotelInfo.OnReturnFrameFromAuditHotelFrame(Frame: TFrame);
begin
//  //审核酒店返回
//  if GlobalIsAuditChanged then
//  begin
//    GlobalIsAuditChanged:=False;
//
//    //酒店信息更改过了,返回需要刷新
//    GlobalIsAddHotelChanged:=True;
//
//    Self.Load(FHotel);
//
//    Sync;
//  end;
end;

procedure TFrameHotelInfo.OnModalResultFromDeleteHotel(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin

    ShowWaitingFrame(Self,'删除中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                  DoDelHotelExecute,
                                  DoDelHotelExecuteEnd);
    //不能直接返回,要接口调用成功才能返回

  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;

end;

procedure TFrameHotelInfo.OnModalResultFromRequestAuditHotel(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin

    ShowWaitingFrame(Self,'处理中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                  DoRequestAuditHotelExecute,
                                  DoRequestAuditHotelExecuteEnd);
    //不能直接返回,要接口调用成功才能返回

  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;
end;

procedure TFrameHotelInfo.OnReturnFrameFromEditHotel(Frame: TFrame);
begin
//  //编辑酒店返回
//  if GlobalIsAddHotelChanged then
//  begin
//    GlobalIsAuditChanged:=False;
//
//    Self.Load(FHotel);
//
//    Sync;
//  end;
end;

procedure TFrameHotelInfo.OnReturnFrameFromHotelRecvAddrList(Frame: TFrame);
//var
//  I:Integer;
begin
  //从收货地址管理页面返回
  //重新获取默认的收货地址

  //添加酒店页面-填写收货地址返回
  Self.ClearHotelRecvAddr;
  LoadHotelRecvAddrToUI(FHotel.RecvAddrList.GetDefaultRecvAddr);

//  //刷新
//  Sync;

//  for I :=0 to FHotel.RecvAddrList.Count-1 do
//  begin
//    if FHotel.RecvAddrList[I].is_default=1 then
//    begin
//      Self.btnRecvAddr.Caption:=FHotel.RecvAddrList[I].province+FHotel.RecvAddrList[I].city
//                                                  +FHotel.RecvAddrList[I].addr;
//    end;
//  end;
end;

procedure TFrameHotelInfo.sbcClientResize(Sender: TObject);
begin
  Self.imgPlayer.Height:=Self.sbClient.Width/4*3;
  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameHotelInfo.Sync;
begin

  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                    DoGetHotelInfoExecute,
                                    DoGetHotelInfoExecuteEnd);


end;

end.


