//convert pas to utf8 by ¥
unit AddHotelFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  System.IOUtils,

  uSkinListViewType,
  uUIFunction,
//  uCommonUtils,
  uFuncCommon,
  uAPPCommon,
  uSkinItems,

  uTimerTask,
  uManager,
  uEasyServiceCommon,
  uBaseHttpControl,
  uInterfaceClass,

  SelectAreaFrame,
//  GetPositionFrame,
  MessageBoxFrame,
  WaitingFrame,
  TakePictureMenuFrame,
  ClipHeadFrame,
  EasyServiceCommonMaterialDataMoudle,

  XSuperObject,
  XSuperJson,
  IDURI,

  uSkinBufferBitmap,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyImage, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyLabel, uDrawPicture,
  uSkinImageList, uSkinFireMonkeyCustomList, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, uSkinFireMonkeyItemDesignerPanel,
  uSkinItemDesignerPanelType, uSkinCustomListType, uSkinVirtualListType,
  uSkinImageType, uSkinLabelType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas;

type
  TFrameAddHotel = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbHotelList: TSkinFMXScrollBox;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlName: TSkinFMXPanel;
    edtName: TSkinFMXEdit;
    pnlAddr: TSkinFMXPanel;
    pnlRecvAddr: TSkinFMXPanel;
    btnOK: TSkinFMXButton;
    pnlEmpty1: TSkinFMXPanel;
    pnlEmpty: TSkinFMXPanel;
    pnlRank: TSkinFMXPanel;
    pnlEmpty3: TSkinFMXPanel;
    pnlArea: TSkinFMXPanel;
    btnArea: TSkinFMXButton;
    pnlPhoneNumber: TSkinFMXPanel;
    edtPhone: TSkinFMXEdit;
    pnlEmpty4: TSkinFMXPanel;
    btnRecvAddr: TSkinFMXButton;
    pnlPicture: TSkinFMXPanel;
    pnlEmpty5: TSkinFMXPanel;
    lvPictures: TSkinFMXListView;
    edtAddr: TSkinFMXEdit;
    imgStar1: TSkinFMXImage;
    imgStar5: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    pnlDeletePic: TSkinFMXItemDesignerPanel;
    ImgPic: TSkinFMXImage;
    btnDelPic: TSkinFMXButton;
    lblHint: TSkinFMXLabel;
    SkinFMXPanel6: TSkinFMXPanel;
    lblRecvName: TSkinFMXLabel;
    lblRecvPhone: TSkinFMXLabel;
    lblRecvAddr: TSkinFMXLabel;
    pnlClassify: TSkinFMXPanel;
    btnSelectClassify: TSkinFMXButton;
    pnlRoomNumber: TSkinFMXPanel;
    edtRoomNumber: TSkinFMXEdit;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lvPicturesClickItem(AItem: TSkinItem);
    procedure imgStar1Click(Sender: TObject);
    procedure imgStar2Click(Sender: TObject);
    procedure imgStar3Click(Sender: TObject);
    procedure imgStar4Click(Sender: TObject);
    procedure imgStar5Click(Sender: TObject);
    procedure btnDelPicClick(Sender: TObject);
    procedure btnRecvAddrStayClick(Sender: TObject);
    procedure btnAreaStayClick(Sender: TObject);
    procedure btnAddrStayClick(Sender: TObject);
    procedure btnSelectClassifyClick(Sender: TObject);
  private
    FName:String;
    FPhone:String;
    FRank:Integer;
    FStar:Integer;

    //省市区
    FProvince:String;
    FCity:String;
    FArea:String;

    //酒店类别
    FClassifyFID:Integer;
    FClassifyName:String;
    //酒店房间数
    FRoomNumber:Integer;


    //地址名称
    FAddr:String;
    //地址明细
    FAddrDetail:String;

    //酒店默认的收货地址
    FHotelRecvAddr:THotelRecvAddr;


    //当前显示的酒店
    FHotel:THotel;
  private
    //添加酒店信息
    procedure DoAddHotelExecute(ATimerTask:TObject);
    procedure DoAddHotelExecuteEnd(ATimerTask:TObject);

  private
    //修改酒店信息
    procedure DoUpdateHotelInfoExecute(ATimerTask:TObject);
    procedure DoUpdateHotelInfoExecuteEnd(ATimerTask:TObject);
  private
    FPicLocalTempFileNameAndStreamList:TStringList;
    FPicLocalTempFilePathList:TStringList;
    FPicRemoteTempFileNameList:TStringList;

    FEditPictureItem:TSkinItem;

    procedure DoAddPictureFromMenu(Sender: TObject;ABitmap:TBitmap);
    procedure DoEditPictureFromMenu(Sender: TObject;ABitmap:TBitmap);

    //剪裁图片返回
    procedure DoReturnFrameFromClipAddHeadFrame(Frame:TFrame);
    procedure DoReturnFrameFromClipEditHeadFrame(Frame:TFrame);

  public
    procedure AlignControls;
    //选择省市页面返回
    procedure OnReturnFrameFromSelectArea(Frame:TFrame);
    //添加酒店页面-填写收货地址页面返回
    procedure OnReturnFrameFromInputRecvAddr(Frame:TFrame);
    //管理收货地址页面返回
    procedure OnReturnFrameFromHotelRecvAddrList(Frame:TFrame);
    //选择地址页面返回
    procedure OnReturnFrameFromGetPosition(Frame:TFrame);
    //选择酒店类型页面返回
    procedure OnReturnFrameFromSingleSelectHotelClassify(Frame:TFrame);
    { Private declarations }
  private
    //清除收货地址
    procedure ClearHotelRecvAddr;
    //加载收货地址
    procedure LoadHotelRecvAddrToUI(AHotelRecvAddr:THotelRecvAddr);
    //编辑酒店
    procedure Load(AHotel:THotel);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  public
//    FrameHistroy:TFrameHistroy;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  public
    procedure Clear;
    //编辑酒店
    procedure Edit(AHotel:THotel);
    //添加酒店
    procedure Add;
  end;


var
  GlobalIsAddHotelChanged:Boolean;
  GlobalAddHotelFrame:TFrameAddHotel;


implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame,
  HotelListFrame,
  HotelInfoFrame,
  AddHotelRecvAddrFrame,
  SelectedHotelClassifyFrame,
  HotelRecvAddrListFrame;




procedure TFrameAddHotel.Add;
begin
  Self.pnlToolBar.Caption:='添加酒店';

  AlignControls;
  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

procedure TFrameAddHotel.AlignControls;
begin
  //隐藏添加按钮
  Self.lvPictures.Prop.Items.FindItemByType(sitItem1).Visible:=
    Self.lvPictures.Prop.Items.Count<=6;

  Self.pnlPicture.Height:=Self.lvPictures.Prop.GetContentHeight;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameAddHotel.btnAddrStayClick(Sender: TObject);
begin
//  if frmMain.FGPSLocation.HasLocated then
//  begin
//    HideFrame;//(Self,hfcttBeforeShowframe);
//    ShowFrame(TFrame(GlobalGetPositionFrame),TFrameGetPosition,frmMain,nil,nil,OnReturnFrameFromGetPosition,Application);
//    GlobalGetPositionFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalGetPositionFrame.Load(FAddr,FAddrDetail);
//  end
//  else
//  begin
//    ShowMessageBoxFrame(Self,'您没有开启定位或尚位定位到您所在的位置!','',TMsgDlgType.mtInformation,['确定'],nil);
//  end;
end;

procedure TFrameAddHotel.btnAreaStayClick(Sender: TObject);
begin
  //选择所在地区
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalSelectAreaFrame),TFrameSelectArea,frmMain,nil,nil,OnReturnFrameFromSelectArea,Application);
//  GlobalSelectAreaFrame.FrameHistroy:=CurrentFrameHistroy;

  if (FProvince<>'') and (FCity<>'') then
  begin
    GlobalSelectAreaFrame.Init(FProvince,FCity,FArea);
  end;
end;

procedure TFrameAddHotel.btnDelPicClick(Sender: TObject);
begin
  //删除图片
  Self.lvPictures.Prop.Items.Remove(Self.lvPictures.Prop.InteractiveItem);
  AlignControls;
end;

procedure TFrameAddHotel.btnOKClick(Sender: TObject);
var
  I: Integer;
  APicStream:TMemoryStream;
  AFileName:String;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
begin
  HideVirtualKeyboard;


  if Self.edtName.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入酒店名称!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.btnSelectClassify.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择酒店类型!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.edtRoomNumber.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入酒店房间数!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;




  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入酒店电话号码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if FHotel=nil then
  begin
    //添加酒店
    if Self.lblRecvAddr.Text='' then
    begin
      ShowMessageBoxFrame(Self,'请填写收货地址!','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end;
  end;

  if Self.edtAddr.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请选择酒店地址!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.btnArea.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请选择酒店所在省份城市!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  FRoomNumber:=StrToInt(Self.edtRoomNumber.Text);
  FName:=Trim(Self.edtName.text);
  FPhone:=Trim(Self.edtPhone.Text);
  FAddr:=Trim(Self.edtAddr.Text);



  FPicLocalTempFilePathList.Clear;
  //清空一下里面的Stream,万一没有释放
  FreeStringListObjects(FPicLocalTempFileNameAndStreamList);


  for I := 0 to Self.lvPictures.Prop.Items.Count-2 do
  begin


    if (Self.lvPictures.Prop.Items[I].Icon.Url='') then
    begin
        //新添加或修改过的图片
        AFileName:=CreateGUIDString+'.jpg';
        ABitmapCodecSaveParams.Quality:=70;
        Self.lvPictures.Prop.Items[I].Icon.SaveToFile(
                                                      System.IOUtils.TPath.GetDocumentsPath+PathDelim+AFileName,
                                                      @ABitmapCodecSaveParams
                                                      );


        APicStream:=TMemoryStream.Create;
        APicStream.LoadFromFile(System.IOUtils.TPath.GetDocumentsPath+PathDelim+AFileName);

        FPicLocalTempFileNameAndStreamList.AddObject(AFileName,APicStream);
        Self.FPicLocalTempFilePathList.Add(System.IOUtils.TPath.GetDocumentsPath+PathDelim+AFileName);

    end
    else
    begin
        //原图
        FPicLocalTempFileNameAndStreamList.AddObject(Self.lvPictures.Prop.Items[I].Icon.Name,nil);
        Self.FPicLocalTempFilePathList.Add(Self.lvPictures.Prop.Items[I].Icon.Name);
    end;

  end;


  if FHotel=nil then
  begin

    ShowWaitingFrame(Self,'添加中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                          DoAddHotelExecute,
                                          DoAddHotelExecuteEnd);
  end;

  if FHotel<>nil then
  begin
    ShowWaitingFrame(Self,'修改中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                   DoUpdateHotelInfoExecute,
                                   DoUpdateHotelInfoExecuteEnd);
  end;

end;

procedure TFrameAddHotel.btnRecvAddrStayClick(Sender: TObject);
begin
  if FHotel=nil then
  begin
    //添加酒店收货地址

    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

    //添加收货地址
    ShowFrame(TFrame(GlobalAddHotelRecvAddrFrame),TFrameAddHotelRecvAddr,frmMain,nil,nil,OnReturnFrameFromInputRecvAddr,Application);
//    GlobalAddHotelRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;

    GlobalAddHotelRecvAddrFrame.Clear;
    GlobalAddHotelRecvAddrFrame.Input(Self.FHotelRecvAddr);

  end;
  if FHotel<>nil then
  begin
    //修改收货地址

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

procedure TFrameAddHotel.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameAddHotel.btnSelectClassifyClick(Sender: TObject);
begin
  //选择商品分类
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalSelectedHotelClassifyFrame),TFrameSelectedHotelClassify,frmMain,nil,nil,OnReturnFrameFromSingleSelectHotelClassify,Application);
//  GlobalSelectedHotelClassifyFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalSelectedHotelClassifyFrame.ToolBarCaption:='选择酒店类型';
  GlobalSelectedHotelClassifyFrame.Load;
end;

procedure TFrameAddHotel.Clear;
begin
  FName:='';
  FPhone:='';
  FHotel:=nil;

  FHotelRecvAddr.Clear;
  ClearHotelRecvAddr;

  FProvince:='';
  FCity:='';
  FArea:='';
  Self.edtName.Text:='';

  Self.imgStar1.Prop.Picture.ImageIndex:=0;
  Self.imgStar2.Prop.Picture.ImageIndex:=0;
  Self.imgStar3.Prop.Picture.ImageIndex:=0;
  Self.imgStar4.Prop.Picture.ImageIndex:=0;
  Self.imgStar5.Prop.Picture.ImageIndex:=0;
  Self.edtPhone.Text:='';

  FAddr:='';
  FAddrDetail:='';

  Self.lvPictures.Prop.Items.ClearItemsByType(sitDefault);
  //显示添加按钮
  Self.lvPictures.Prop.Items.FindItemByType(sitItem1).Visible:=True;
  Self.edtAddr.Text:='';
  Self.btnArea.Text:='';
  Self.btnRecvAddr.Text:='';

  AlignControls;
  Self.sbClient.VertScrollBar.Prop.Position:=0;


end;

procedure TFrameAddHotel.ClearHotelRecvAddr;
begin
  Self.lblRecvName.Caption:='';
  Self.lblRecvPhone.Caption:='';
  Self.lblRecvAddr.Caption:='';
  Self.FHotelRecvAddr.Clear;

end;

constructor TFrameAddHotel.Create(AOwner: TComponent);
begin
  inherited;

//  Self.btnAddr.Visible:=False;

  FPicLocalTempFilePathList:=TStringList.Create;
  FPicLocalTempFileNameAndStreamList:=TStringList.Create;
  FPicRemoteTempFileNameList:=TStringList.Create;
  Self.lvPictures.Prop.Items.ClearItemsByType(sitDefault);

  FHotelRecvAddr:=THotelRecvAddr.Create;
end;

destructor TFrameAddHotel.Destroy;
begin

  FreeAndNil(FHotelRecvAddr);

  FreeAndNil(FPicLocalTempFilePathList);
  //清空一下里面的Stream,万一没有释放
  FreeStringListObjects(FPicLocalTempFileNameAndStreamList);
  FreeAndNil(FPicLocalTempFileNameAndStreamList);

  FreeAndNil(FPicRemoteTempFileNameList);
  inherited;
end;

procedure TFrameAddHotel.DoAddHotelExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
  I: Integer;
  AResponseStream:TStringStream;
  ASuperObject:ISuperObject;
  APicStream:TMemoryStream;
  APicUploadSucc:Boolean;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try

      APicUploadSucc:=True;
      //上传图片
      FPicRemoteTempFileNameList.Clear;
      for I := 0 to Self.FPicLocalTempFilePathList.Count-1 do
      begin
        APicUploadSucc:=False;
        APicStream:=TMemoryStream(FPicLocalTempFileNameAndStreamList.Objects[I]);
        AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
        try
          APicUploadSucc:=AHttpControl.Post(
                  ImageHttpServerUrl+'/Upload'
                  +'?FileName='+FPicLocalTempFileNameAndStreamList[I]
                  +'&FileDir='+'Temp',
                  //图片文件
                  APicStream,
                  //返回数据流
                  AResponseStream
                  );
          if APicUploadSucc then
          begin
            AResponseStream.Position:=0;



            //ASuperObject:=TSuperObject.ParseStream(AResponseStream);
            //会报错'Access violation at address 004B6C7C in module ''Server.exe''. Read of address 00000000'
            //要从AResponseStream.DataString加载
            ASuperObject:=TSuperObject.Create(AResponseStream.DataString);

            if ASuperObject.I['Code']=200 then
            begin
              FPicRemoteTempFileNameList.Add(ASuperObject.O['Data'].S['FileName']);
            end;


          end
          else
          begin
            //图片上传失败
          end;

        finally
          FPicLocalTempFileNameAndStreamList.Objects[I]:=nil;
          uFuncCommon.FreeAndNil(APicStream);
          uFuncCommon.FreeAndNil(AResponseStream);
        end;

        if Not APicUploadSucc then
        begin
          //图片上传失败
          TTimerTask(ATimerTask).TaskTag:=2;
          //退出循环
          Break;
        end;
      end;



     if APicUploadSucc then
      begin

        for I:= 0 to 9-FPicRemoteTempFileNameList.Count-1 do
        begin
          FPicRemoteTempFileNameList.Add('');
        end;
        TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('add_hotel',
                                                    AHttpControl,
                                                    InterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'name',
                                                    'star',
                                                    'room_num',
                                                    'classify_fid',
                                                    'tel',
                                                    'province',
                                                    'city',
                                                    'area',
                                                    'addr',
                                                    'longitude',
                                                    'latitude',
                                                    'pic1path','pic2path','pic3path','pic4path','pic5path','pic6path',
                                                    'audit_state',
                                                    'default_recv_name',
                                                    'default_recv_phone',
                                                    'default_recv_province',
                                                    'default_recv_city',
                                                    'default_recv_area',
                                                    'default_recv_addr'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FName,
                                                    FRank,
                                                    FRoomNumber,
                                                    FClassifyFID,
                                                    FPhone,
                                                    FProvince,
                                                    FCity,
                                                    FArea,
                                                    FAddr,
                                                    0,
                                                    0,
                                                    FPicRemoteTempFileNameList[0],
                                                    FPicRemoteTempFileNameList[1],
                                                    FPicRemoteTempFileNameList[2],
                                                    FPicRemoteTempFileNameList[3],
                                                    FPicRemoteTempFileNameList[4],
                                                    FPicRemoteTempFileNameList[5],
                                                    Ord(asRequestAudit),
                                                    FHotelRecvAddr.name,
                                                    FHotelRecvAddr.phone,
                                                    FHotelRecvAddr.province,
                                                    FHotelRecvAddr.city,
                                                    FHotelRecvAddr.area,
                                                    FHotelRecvAddr.addr
                                                    ]
                                                    );
          if TTimerTask(ATimerTask).TaskDesc<>'' then
          begin
            TTimerTask(ATimerTask).TaskTag:=0;
          end;
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

procedure TFrameAddHotel.DoAddHotelExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


        //添加过酒店,返回并刷新酒店列表
        GlobalIsAddHotelChanged:=True;

        HideFrame;////(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);

      end
      else
      begin
        //添加酒店失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=2 then
    begin
      //图片上传失败
      ShowMessageBoxFrame(Self,'图片上传失败!','',TMsgDlgType.mtInformation,['确定'],nil);
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

procedure TFrameAddHotel.DoAddPictureFromMenu(Sender: TObject;
  ABitmap: TBitmap);
begin
  //剪裁图片
  HideFrame;//(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalClipHeadFrame),TFrameClipHead,frmMain,nil,nil,DoReturnFrameFromClipAddHeadFrame,Application);
  GlobalClipHeadFrame.Init(ABitmap,400,300);
end;

procedure TFrameAddHotel.DoUpdateHotelInfoExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
  I: Integer;
  AResponseStream:TStringStream;
  ASuperObject:ISuperObject;
  APicStream:TMemoryStream;
  APicUploadSucc:Boolean;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try

      APicUploadSucc:=True;
      //上传图片
      FPicRemoteTempFileNameList.Clear;
      for I := 0 to Self.FPicLocalTempFilePathList.Count-1 do
      begin
          APicUploadSucc:=False;

          APicStream:=TMemoryStream(FPicLocalTempFileNameAndStreamList.Objects[I]);
          if APicStream<>nil then
          begin
                //添加图片
                AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
                try
                  APicUploadSucc:=AHttpControl.Post(
                                                //上传接口
                                                ImageHttpServerUrl
                                                +'/Upload'
                                                  +'?FileName='+FPicLocalTempFileNameAndStreamList[I]
                                                  +'&FileDir='+'Temp',


                                                //图片文件
                                                APicStream,
                                                //返回数据流
                                                AResponseStream
                                                );
                  if APicUploadSucc then
                  begin
                    AResponseStream.Position:=0;



                    //ASuperObject:=TSuperObject.ParseStream(AResponseStream);
                    //会报错'Access violation at address 004B6C7C in module ''Server.exe''. Read of address 00000000'
                    //要从AResponseStream.DataString加载
                    ASuperObject:=TSuperObject.Create(AResponseStream.DataString);

                    if ASuperObject.I['Code']=200 then
                    begin
                      FPicRemoteTempFileNameList.Add(ASuperObject.O['Data'].S['FileName']);
                    end;


                  end
                  else
                  begin
                    //图片上传失败
                  end;

                finally
                  FPicLocalTempFileNameAndStreamList.Objects[I]:=nil;
                  uFuncCommon.FreeAndNil(APicStream);
                  uFuncCommon.FreeAndNil(AResponseStream);
                end;
          end
          else
          begin
                  //没有修改过图片,不用上传
                  APicUploadSucc:=True;
                  FPicRemoteTempFileNameList.Add(FPicLocalTempFileNameAndStreamList[I]);

          end;

          if Not APicUploadSucc then
          begin
            //图片上传失败
            TTimerTask(ATimerTask).TaskTag:=2;
            //退出循环
            Break;
          end;

      end;

     if APicUploadSucc then
      begin

        for I:= 0 to 9-FPicRemoteTempFileNameList.Count-1 do
        begin
          FPicRemoteTempFileNameList.Add('');
        end;
        TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('update_hotel',
                                                           AHttpControl,
                                                           InterfaceUrl,
                                                          ['appid',
                                                            'user_fid',
                                                            'key',
                                                            'hotel_fid',
                                                            'name',
                                                            'star',
                                                            'room_num',
                                                            'classify_fid',
                                                            'tel',
                                                            'province',
                                                            'city',
                                                            'area',
                                                            'addr',
                                                            'longitude',
                                                            'latitude',
                                                            'pic1path','pic2path','pic3path','pic4path','pic5path','pic6path',
                                                            'audit_state'
                                                            ],
                                                            [AppID,
                                                            GlobalManager.User.fid,
                                                            GlobalManager.User.key,
                                                            FHotel.fid,
                                                            FName,
                                                            FRank,
                                                            FRoomNumber,
                                                            FClassifyFID,
                                                            FPhone,
                                                            FProvince,
                                                            FCity,
                                                            FArea,
                                                            FAddr,
                                                            0,
                                                            0,
                                                            FPicRemoteTempFileNameList[0],
                                                            FPicRemoteTempFileNameList[1],
                                                            FPicRemoteTempFileNameList[2],
                                                            FPicRemoteTempFileNameList[3],
                                                            FPicRemoteTempFileNameList[4],
                                                            FPicRemoteTempFileNameList[5],
                                                            FHotel.audit_state
                                                            ]
                                                            );
          if TTimerTask(ATimerTask).TaskDesc<>'' then
          begin
            TTimerTask(ATimerTask).TaskTag:=0;
          end;
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

procedure TFrameAddHotel.DoUpdateHotelInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //修改过酒店,返回需要刷新
        GlobalIsAddHotelChanged:=True;

        //返回并刷新酒店列表
        FHotel.ParseFromJson(ASuperObject.O['Data'].A['Hotel'].O[0]);


        HideFrame;////(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);

        GlobalHotelInfoFrame.Load(FHotel);


      end
      else
      begin
        //修改酒店失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=2 then
    begin
      //图片上传失败
      ShowMessageBoxFrame(Self,'图片上传失败!','',TMsgDlgType.mtInformation,['确定'],nil);
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

procedure TFrameAddHotel.DoEditPictureFromMenu(Sender: TObject;
  ABitmap: TBitmap);
begin
  HideFrame;//(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalClipHeadFrame),TFrameClipHead,frmMain,nil,nil,DoReturnFrameFromClipEditHeadFrame,Application);
  GlobalClipHeadFrame.Init(ABitmap,400,300);

end;

procedure TFrameAddHotel.DoReturnFrameFromClipEditHeadFrame(Frame: TFrame);
var
  ABitmap:TBitmap;
begin
  ABitmap:=GlobalClipHeadFrame.GetClipBitmap;
  FEditPictureItem.Icon.Url:='';
  FEditPictureItem.Icon.Assign(ABitmap);
  FreeAndNil(ABitmap);
end;

procedure TFrameAddHotel.DoReturnFrameFromClipAddHeadFrame(Frame: TFrame);
var
  AListViewItem:TSkinListViewItem;
  ABitmap:TBitmap;
begin
  ABitmap:=GlobalClipHeadFrame.GetClipBitmap;
  //添加一张图片
  AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
  AListViewItem.Icon.Url:='';
  AListViewItem.Icon.Assign(ABitmap);
  FreeAndNil(ABitmap);

  AlignControls;
end;

procedure TFrameAddHotel.Edit(AHotel: THotel);
begin
  Self.pnlToolBar.Caption:='编辑酒店';

  Load(AHotel);

  AlignControls;
  Self.sbClient.VertScrollBar.Prop.Position:=0;

end;

function TFrameAddHotel.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameAddHotel.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameAddHotel.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameAddHotel.imgStar1Click(Sender: TObject);
begin
  Self.imgStar1.Prop.Picture.ImageIndex:=0;
  Self.imgStar2.Prop.Picture.ImageIndex:=0;
  Self.imgStar3.Prop.Picture.ImageIndex:=0;
  Self.imgStar4.Prop.Picture.ImageIndex:=0;
  Self.imgStar5.Prop.Picture.ImageIndex:=0;
  Self.imgStar1.Prop.Picture.ImageIndex:=1;
  FRank:=1;
end;

procedure TFrameAddHotel.imgStar2Click(Sender: TObject);
begin
  Self.imgStar1.Prop.Picture.ImageIndex:=0;
  Self.imgStar2.Prop.Picture.ImageIndex:=0;
  Self.imgStar3.Prop.Picture.ImageIndex:=0;
  Self.imgStar4.Prop.Picture.ImageIndex:=0;
  Self.imgStar5.Prop.Picture.ImageIndex:=0;
  Self.imgStar1.Prop.Picture.ImageIndex:=1;
  Self.imgStar2.Prop.Picture.ImageIndex:=1;
  FRank:=2;
end;

procedure TFrameAddHotel.imgStar3Click(Sender: TObject);
begin
  Self.imgStar1.Prop.Picture.ImageIndex:=0;
  Self.imgStar2.Prop.Picture.ImageIndex:=0;
  Self.imgStar3.Prop.Picture.ImageIndex:=0;
  Self.imgStar4.Prop.Picture.ImageIndex:=0;
  Self.imgStar5.Prop.Picture.ImageIndex:=0;
  Self.imgStar1.Prop.Picture.ImageIndex:=1;
  Self.imgStar2.Prop.Picture.ImageIndex:=1;
  Self.imgStar3.Prop.Picture.ImageIndex:=1;
  FRank:=3;
end;

procedure TFrameAddHotel.imgStar4Click(Sender: TObject);
begin
  Self.imgStar1.Prop.Picture.ImageIndex:=0;
  Self.imgStar2.Prop.Picture.ImageIndex:=0;
  Self.imgStar3.Prop.Picture.ImageIndex:=0;
  Self.imgStar4.Prop.Picture.ImageIndex:=0;
  Self.imgStar5.Prop.Picture.ImageIndex:=0;
  Self.imgStar1.Prop.Picture.ImageIndex:=1;
  Self.imgStar2.Prop.Picture.ImageIndex:=1;
  Self.imgStar3.Prop.Picture.ImageIndex:=1;
  Self.imgStar4.Prop.Picture.ImageIndex:=1;
  FRank:=4;
end;

procedure TFrameAddHotel.imgStar5Click(Sender: TObject);
begin
  Self.imgStar1.Prop.Picture.ImageIndex:=0;
  Self.imgStar2.Prop.Picture.ImageIndex:=0;
  Self.imgStar3.Prop.Picture.ImageIndex:=0;
  Self.imgStar4.Prop.Picture.ImageIndex:=0;
  Self.imgStar5.Prop.Picture.ImageIndex:=0;
  Self.imgStar1.Prop.Picture.ImageIndex:=1;
  Self.imgStar2.Prop.Picture.ImageIndex:=1;
  Self.imgStar3.Prop.Picture.ImageIndex:=1;
  Self.imgStar4.Prop.Picture.ImageIndex:=1;
  Self.imgStar5.Prop.Picture.ImageIndex:=1;
  FRank:=5;
end;

procedure TFrameAddHotel.Load(AHotel: THotel);
var
  I: Integer;
  AListViewItem:TSkinListViewItem;
begin

  FHotel:=AHotel;

  FProvince:=AHotel.province;
  FCity:=AHotel.city;
  FArea:=AHotel.area;

  FRank:=AHotel.star;
  FRoomNumber:=AHotel.room_num;

  FClassifyFID:=AHotel.classify_fid;
  FClassifyName:=AHotel.classify_name;

  Self.edtName.Text:=AHotel.name;
  Self.edtPhone.Text:=AHotel.tel;
  Self.edtAddr.Text:=AHotel.addr;

  Self.btnSelectClassify.Caption:=AHotel.classify_name;
  Self.edtRoomNumber.Text:=IntToStr(AHotel.room_num);




  Self.lvPictures.Prop.Items.ClearItemsByTypeNot(sitItem1);
  if AHotel.pic1path<>'' then
  begin
    AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//    AListViewItem.Icon.IsLoadUrlPictureToSelf:=True;
    AListViewItem.Icon.Url:=AHotel.GetPic1Url;
    //存下文件名
    AListViewItem.Icon.Name:=AHotel.pic1path;
    //立即下载
    AListViewItem.Icon.WebUrlPicture;
  end;
  if AHotel.pic2path<>'' then
  begin
    AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//    AListViewItem.Icon.IsLoadUrlPictureToSelf:=True;
    AListViewItem.Icon.Url:=AHotel.GetPic2Url;
    //存下文件名
    AListViewItem.Icon.Name:=AHotel.pic2path;
    //立即下载
    AListViewItem.Icon.WebUrlPicture;
  end;
  if AHotel.pic3path<>'' then
  begin
    AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//    AListViewItem.Icon.IsLoadUrlPictureToSelf:=True;
    AListViewItem.Icon.Url:=AHotel.GetPic3Url;
    //存下文件名
    AListViewItem.Icon.Name:=AHotel.pic3path;
    //立即下载
    AListViewItem.Icon.WebUrlPicture;
  end;
  if AHotel.pic4path<>'' then
  begin
    AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//    AListViewItem.Icon.IsLoadUrlPictureToSelf:=True;
    AListViewItem.Icon.Url:=AHotel.GetPic4Url;
    //存下文件名
    AListViewItem.Icon.Name:=AHotel.pic4path;
    //立即下载
    AListViewItem.Icon.WebUrlPicture;
  end;
  if AHotel.pic5path<>'' then
  begin
    AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//    AListViewItem.Icon.IsLoadUrlPictureToSelf:=True;
    AListViewItem.Icon.Url:=AHotel.GetPic5Url;
    //存下文件名
    AListViewItem.Icon.Name:=AHotel.pic5path;
    //立即下载
    AListViewItem.Icon.WebUrlPicture;
  end;
  if AHotel.pic6path<>'' then
  begin
    AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//    AListViewItem.Icon.IsLoadUrlPictureToSelf:=True;
    AListViewItem.Icon.Url:=AHotel.GetPic6Url;
    //存下文件名
    AListViewItem.Icon.Name:=AHotel.pic6path;
    //立即下载
    AListViewItem.Icon.WebUrlPicture;
  end;




  //星级
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


  //默认的收货地址
  ClearHotelRecvAddr;
  Self.LoadHotelRecvAddrToUI(FHotel.RecvAddrList.GetDefaultRecvAddr);



//  Self.btnAddr.Prop.IsPushed:=True;
  Self.btnArea.Text:=AHotel.GetArea;

end;

procedure TFrameAddHotel.LoadHotelRecvAddrToUI(AHotelRecvAddr: THotelRecvAddr);
begin
  if AHotelRecvAddr<>nil then
  begin
    Self.lblRecvName.Caption:=AHotelRecvAddr.name;
    Self.lblRecvPhone.Caption:=AHotelRecvAddr.phone;
    Self.lblRecvAddr.Caption:=AHotelRecvAddr.addr;
  end;
end;

procedure TFrameAddHotel.lvPicturesClickItem(AItem: TSkinItem);
begin
  HideVirtualKeyboard;
  //拍照
  ShowFrame(TFrame(GlobalTakePictureMenuFrame),TFrameTakePictureMenu,frmMain,nil,nil,nil,Application,True,False,ufsefNone);
//  GlobalTakePictureMenuFrame.FrameHistroy:=CurrentFrameHistroy;
  //添加
  if AItem.ItemType=sitItem1 then
  begin
    GlobalTakePictureMenuFrame.OnTakedPicture:=DoAddPictureFromMenu;
  end
  else
  //修改
  if AItem.ItemType=sitDefault then
  begin
    FEditPictureItem:=AItem;
    GlobalTakePictureMenuFrame.OnTakedPicture:=DoEditPictureFromMenu;
  end;
  GlobalTakePictureMenuFrame.ShowMenu;

end;

procedure TFrameAddHotel.OnReturnFrameFromGetPosition(Frame: TFrame);
begin
//  //选择地址返回
//  Self.FAddr:=GlobalGetPositionFrame.FSelectedAddr;
//  Self.FAddrDetail:=GlobalGetPositionFrame.FSelectedAddrDetail;
//
//  Self.edtAddr.Text:=GlobalGetPositionFrame.FSelectedAddr;
//  Self.btnAddr.Prop.StaticIsPushed:=(GlobalGetPositionFrame.FSelectedAddr<>'');

//  if AItem.Caption='不显示位置' then
//  begin
//    Self.edtAddr.Text:='';
//    Self.btnAddr.Prop.StaticIsPushed:=False;
//
//    Self.FAddr:='';
//    Self.FAddrDetail:='';
//  end;

end;

procedure TFrameAddHotel.OnReturnFrameFromHotelRecvAddrList(Frame: TFrame);
//var
//  I:Integer;
begin
  //在HotelRecvAddrListFrame中会把收货地址列表加载到FHotel中
  ClearHotelRecvAddr;
  Self.LoadHotelRecvAddrToUI(FHotel.RecvAddrList.GetDefaultRecvAddr);

//  for I :=0 to FHotel.RecvAddrList.Count-1 do
//  begin
//    if FHotel.RecvAddrList[I].is_default=1 then
//    begin
//      Self.btnRecvAddr.Caption:=FHotel.RecvAddrList[I].province
//                                      +FHotel.RecvAddrList[I].city
//                                      +FHotel.RecvAddrList[I].addr;
//    end;
//  end;
end;

procedure TFrameAddHotel.OnReturnFrameFromInputRecvAddr(Frame: TFrame);
begin
  //添加酒店页面-填写收货地址返回
  FHotelRecvAddr.Assign(GlobalAddHotelRecvAddrFrame.FHotelRecvAddr);
  LoadHotelRecvAddrToUI(FHotelRecvAddr);
//  FReceivingName:=GlobalAddHotelRecvAddrFrame.edtName.Text;
//  FReceivingPhone:=GlobalAddHotelRecvAddrFrame.edtPhone.Text;
//  FRecvAddr:=GlobalAddHotelRecvAddrFrame.memAddr.Text;
//  Self.btnRecvAddr.Text:=FHotelRecvAddr.GetLongAddr;
end;

procedure TFrameAddHotel.OnReturnFrameFromSelectArea(Frame: TFrame);
begin
  //选择所在地址返回

//  FProvince:='';
//  FCity:='';
//
//  if GlobalSelectAreaFrame.lbProvince.Prop.SelectedItem<>nil then
//  begin
//    FProvince:=GlobalSelectAreaFrame.FSelectedProvince;
//  end;
//  if GlobalSelectAreaFrame.lbCity.Prop.SelectedItem<>nil then
//  begin
//    FCity:=GlobalSelectAreaFrame.FSelectedCity;
//  end;
  FProvince:=GlobalSelectAreaFrame.FSelectedProvince;
  FCity:=GlobalSelectAreaFrame.FSelectedCity;
  FArea:=GlobalSelectAreaFrame.FSelectedArea;

  Self.btnArea.Caption:=FProvince+' '+FCity+' '+FArea;

end;

procedure TFrameAddHotel.OnReturnFrameFromSingleSelectHotelClassify(
  Frame: TFrame);
begin
  FClassifyFID:=GlobalSelectedHotelClassifyFrame.SelectedFid;
  if IntToStr(GlobalSelectedHotelClassifyFrame.SelectedFid)='0' then
  begin
    Self.btnSelectClassify.Caption:='';
    FClassifyName:='';
  end
  else
  begin
    Self.btnSelectClassify.Caption:=GlobalSelectedHotelClassifyFrame.Selected;
    FClassifyName:=GlobalSelectedHotelClassifyFrame.Selected;
  end;
end;

end.
