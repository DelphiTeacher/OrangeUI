//convert pas to utf8 by ¥
unit GoodsInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uTimerTask,
  uUIFunction,
  uManager,
  uSkinItems,
  uInterfaceClass,
  uBaseHttpControl,
  uSkinControlGestureManager,

  WaitingFrame,
  MessageBoxFrame,
  EasyServiceCommonMaterialDataMoudle,


  XSuperObject,
  XSuperJson,

  uDrawPicture, uSkinImageList, uSkinFireMonkeyButton,
  uSkinFireMonkeyImageListViewer, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyNotifyNumberIcon, uDrawCanvas, uSkinMaterial, uSkinButtonType,
  uSkinNotifyNumberIconType, uSkinLabelType, uSkinImageListViewerType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinPanelType;

type
  TFrameGoodsInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnChange: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlLastDevide: TSkinFMXPanel;
    pnlEmpty3: TSkinFMXPanel;
    btnDelete: TSkinFMXButton;
    IlPictureList2: TSkinImageList;
    imgPlayer: TSkinFMXImageListViewer;
    bgPictureGroup: TSkinFMXButtonGroup;
    pnlName: TSkinFMXPanel;
    pnlCode: TSkinFMXPanel;
    pnlMarque: TSkinFMXPanel;
    pnlUnit: TSkinFMXPanel;
    pnlPrice: TSkinFMXPanel;
    pnlEmpty4: TSkinFMXPanel;
    lblMarque: TSkinFMXLabel;
    lblCode: TSkinFMXLabel;
    lblPrice: TSkinFMXLabel;
    lblUnit: TSkinFMXLabel;
    lblName: TSkinFMXLabel;
    pnlCommission: TSkinFMXPanel;
    lblCommission: TSkinFMXLabel;
    pnlEmpty5: TSkinFMXPanel;
    pnlAddMyCart: TSkinFMXPanel;
    btnAddUserCard: TSkinFMXButton;
    btnUserCart: TSkinFMXButton;
    nniNumber: TSkinFMXNotifyNumberIcon;
    pnlEmpty6: TSkinFMXPanel;
    pnlClassify: TSkinFMXPanel;
    lblClassify: TSkinFMXLabel;
    pnlEmpty7: TSkinFMXPanel;
    pnlEmpty8: TSkinFMXPanel;
    pnlIsNew: TSkinFMXPanel;
    lblIsNew: TSkinFMXLabel;
    pnlIsOffSell: TSkinFMXPanel;
    lblIsOffSell: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure sbcClientResize(Sender: TObject);
    procedure imgPlayerResize(Sender: TObject);
    procedure btnAddUserCardClick(Sender: TObject);
    procedure btnUserCartClick(Sender: TObject);

  private
    FGoods:TGoods;
    //获取商品详情
    procedure DoGetGoodsInfoExecute(ATimerTask:TObject);
    procedure DoGetGoodsInfoExecuteEnd(ATimerTask:TObject);

    //从编辑商品页面返回
    procedure OnReturnFrameFromEditGoods(Frame:TFrame);
  private
    FDeleteGoodsFID:Integer;

    //删除商品
    procedure DoDelGoodsExecute(ATimerTask:TObject);
    procedure DoDelGoodsExecuteEnd(ATimerTask:TObject);

    //删除对话框返回
    procedure OnReturnFrameFromDeleteGoods(Frame:TObject);
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
    procedure Clear;
    //检测商品是否添加到了购物车
    procedure CheckIsExistedInCart;
    procedure Load(AGoods:TGoods);overload;
    procedure Load(AGoodsFID:Integer);overload;
    { Public declarations }
  end;


var
  GlobalIsGoodsInfoChanged:Boolean;
  GlobalGoodsInfoFrame:TFrameGoodsInfo;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  UserCartFrame,
  BuyGoodsListFrame;



procedure TFrameGoodsInfo.btnAddUserCardClick(Sender: TObject);
begin
  //添加商品到购物车



  //购物车中没有此商品
  if GlobalManager.UserCartGoodsList.FindItemByFID(FGoods.fid)=nil then
  begin

    ShowWaitingFrame(Self,'处理中...');
    GlobalMainFrame.AddGoodsToCart(FGoods.fid,1);

    GlobalMainFrame.GetUserCartGoodsList;

  end;

end;

procedure TFrameGoodsInfo.btnChangeClick(Sender: TObject);
begin
//  //编辑商品
//  HideFrame;//(Self,hfcttBeforeShowFrame);
//
//  ShowFrame(TFrame(GlobalAddGoodsFrame),TFrameAddGoods,frmMain,nil,nil,OnReturnFrameFromEditGoods,Application);
//  GlobalAddGoodsFrame.FrameHistroy:=CurrentFrameHistroy;
//
//  GlobalAddGoodsFrame.Clear;
//  GlobalAddGoodsFrame.Edit(FGoods);
end;

procedure TFrameGoodsInfo.btnDeleteClick(Sender: TObject);
begin
  //删除商品
  ShowMessageBoxFrame(Self,
                      '确定删除?',
                      '',
                      TMsgDlgType.mtInformation,
                      ['确定','取消'],
                      OnReturnFrameFromDeleteGoods);
end;

procedure TFrameGoodsInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameGoodsInfo.btnUserCartClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
  //购物车
  ShowFrame(TFrame(GlobalMainFrame.FUserCartFrame),TFrameUserCart,frmMain,nil,nil,nil,Application);
//  GlobalMainFrame.FUserCartFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalMainFrame.FUserCartFrame.Load(True);
end;

procedure TFrameGoodsInfo.CheckIsExistedInCart;
begin
  if GlobalManager.UserCartGoodsList.FindItemByFID(FGoods.fid)=nil then
  begin
    Self.btnAddUserCard.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
    Self.btnAddUserCard.Caption:='加入购物车';
  end
  else
  begin
    Self.btnAddUserCard.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=TAlphaColorRec.Gray;
    Self.btnAddUserCard.Caption:='已加入购物车';
  end;

end;

procedure TFrameGoodsInfo.Clear;
begin
  FGoods.Clear;

  Self.imgPlayer.Prop.Picture.ImageIndex:=-1;
  Self.IlPictureList2.PictureList.Clear(True);
  Self.imgPlayerResize(imgPlayer);


  Self.lblName.Caption:='';
  Self.lblCode.Caption:='';
  Self.lblMarque.Caption:='';
  Self.lblPrice.Caption:=Format('%.2f',[0.0]);
  Self.lblUnit.Caption:='';
//  Self.lblCost.Caption:=Format('%.2f',[0.0]);
  Self.lblCommission.Caption:=Format('%.2f',[0.0]);



  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);

  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

constructor TFrameGoodsInfo.Create(AOwner: TComponent);
begin
  inherited;
  FGoods:=TGoods.Create;

  //处理ImageListViewer和ScrollBox的手势冲突
  Self.sbClient.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.sbClient.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
            Self.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind;

end;

destructor TFrameGoodsInfo.Destroy;
begin
  FreeAndNil(FGoods);
  inherited;
end;

procedure TFrameGoodsInfo.DoDelGoodsExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('del_goods',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'emp_fid',
                                                      'key',
                                                      'goods_fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FDeleteGoodsFID
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

procedure TFrameGoodsInfo.DoDelGoodsExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //删除过商品,返回要刷新
        GlobalIsGoodsInfoChanged:=True;

        //删除商品之后返回列表
        HideFrame;//(Self,hfcttBeforeReturnFrame);
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

procedure TFrameGoodsInfo.DoGetGoodsInfoExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_goods',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'goods_fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FGoods.fid
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

procedure TFrameGoodsInfo.DoGetGoodsInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FGoods.ParseFromJson(ASuperObject.O['Data'].A['Goods'].O[0]);

        //显示商品详情
        Load(FGoods);

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

procedure TFrameGoodsInfo.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind(
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

procedure TFrameGoodsInfo.imgPlayerResize(Sender: TObject);
begin
  Self.bgPictureGroup.Position.X:=Self.sbClient.Width
              -Self.IlPictureList2.Count*Self.bgPictureGroup.Height-20;
  Self.bgPictureGroup.Position.Y:=Self.imgPlayer.Height-20;
end;

procedure TFrameGoodsInfo.Load(AGoodsFID: Integer);
begin
  FGoods.fid:=AGoodsFID;

  ShowWaitingFrame(Self,'加载中...');
  //获取商品资料
  GetGlobalTimerThread.RunTempTask(
                Self.DoGetGoodsInfoExecute,
                Self.DoGetGoodsInfoExecuteEnd
                );
end;

procedure TFrameGoodsInfo.Load(AGoods: TGoods);
var
  ADrawPicture:TDrawPicture;
begin
  FGoods.Assign(AGoods);


  CheckIsExistedInCart;


  Self.imgPlayer.Prop.Picture.ImageIndex:=0;
  Self.IlPictureList2.PictureList.Clear(True);
  if AGoods.pic1path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AGoods.GetPic1Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AGoods.pic2path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AGoods.GetPic2Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AGoods.pic3path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AGoods.GetPic3Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AGoods.pic4path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AGoods.GetPic4Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AGoods.pic5path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AGoods.GetPic5Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  if AGoods.pic6path<>'' then
  begin
    ADrawPicture:=Self.IlPictureList2.PictureList.Add;
    ADrawPicture.Url:=AGoods.GetPic6Url;
    //立即下载
    ADrawPicture.WebUrlPicture;
  end;
  //设置ImageListViewer的尺寸和ScrollBoxContent的高度
  Self.imgPlayer.Prop.AlignSwitchButtons;
  Self.imgPlayerResize(imgPlayer);




  Self.lblName.Caption:=AGoods.name;
  Self.lblCode.Caption:=AGoods.code;
  Self.lblMarque.Caption:=AGoods.marque;
  Self.lblUnit.Caption:=AGoods.goods_unit;
  Self.lblPrice.Caption:=Format('%.2f',[AGoods.price]);
  Self.lblCommission.Caption:=Format('%.2f',[AGoods.commission]);
  Self.lblClassify.Caption:=AGoods.classify_name;

  Self.lblIsNew.Text:='暂无';
  if (AGoods.is_new=0) AND (AGoods.is_recommend=1) then
  begin
    Self.lblIsNew.Text:='推荐';
  end
  else if (AGoods.is_new=1) AND (AGoods.is_recommend=0) then
  begin
    Self.lblIsNew.Text:='新品';
  end
  else if (AGoods.is_new=1) AND (AGoods.is_recommend=1) then
  begin
    Self.lblIsNew.Text:='新品、推荐';
  end;


  Self.lblIsOffSell.Text:='下架';
  if AGoods.is_offsell=0 then
  begin
    Self.lblIsOffSell.Text:='上架';
  end;


  if GlobalManager.User.is_emp=1 then
  begin
    //员工
    //能看到编辑按钮
    Self.btnChange.Visible:=True;
    //能看到删除按钮
    Self.btnDelete.Visible:=True;
//    Self.pnlcost.Visible:=True;
    //能看到佣金
    Self.pnlCommission.Visible:=True;
    //不能看到添加到购物车
    Self.pnlAddMyCart.Visible:=False;

    Self.pnlEmpty3.Visible:=True;
    Self.pnlEmpty7.Visible:=True;
    //能看到新品
    Self.pnlIsNew.Visible:=True;
    //能看到上架
    Self.pnlIsOffSell.Visible:=True;
  end
  else
  begin
    //酒店经理
    Self.btnChange.Visible:=False;
    Self.btnDelete.Visible:=False;
    Self.pnlAddMyCart.Visible:=True;
//    Self.pnlcost.Visible:=False;
    Self.pnlCommission.Visible:=False;
    Self.nniNumber.Prop.Number:=GlobalManager.UserCartGoodsList.Count;

    Self.pnlEmpty3.Visible:=False;
    Self.pnlEmpty7.Visible:=False;
    Self.pnlIsNew.Visible:=False;
    Self.pnlIsOffSell.Visible:=False;
  end;
  Self.btnDelete.Top:=Self.pnlLastDevide.Top+Self.pnlLastDevide.Height;


  sbcClientResize(Self);
  Self.sbClient.VertScrollBar.Prop.Position:=0;
end;

procedure TFrameGoodsInfo.OnReturnFrameFromDeleteGoods(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin
    //无用,直接可以用FHotel.fid
    FDeleteGoodsFID:=FGoods.fid;
    //不能再这里用InteractiveItem


    ShowWaitingFrame(Self,'删除中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                  DoDelGoodsExecute,
                                  DoDelGoodsExecuteEnd);
    //不能直接返回,要接口调用成功才能返回

  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;


end;

procedure TFrameGoodsInfo.OnReturnFrameFromEditGoods(Frame: TFrame);
begin
//  if GlobalIsAddGoodsChanged then
//  begin
//    GlobalIsAddGoodsChanged:=False;
//
//    //修改过商品,返回要刷新
//    GlobalIsGoodsInfoChanged:=True;
//
//
//    //获取商品资料
//    GetGlobalTimerThread.RunTempTask(
//                  Self.DoGetGoodsInfoExecute,
//                  Self.DoGetGoodsInfoExecuteEnd
//                  );
//  end;
end;

procedure TFrameGoodsInfo.sbcClientResize(Sender: TObject);
begin
  Self.imgPlayer.Height:=Self.sbClient.Width/4*3;
  //设置合适的高度
  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;


end.
