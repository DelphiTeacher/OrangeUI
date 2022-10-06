//convert pas to utf8 by ¥

unit AddSpiritFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  IDURI,
  uAppCommon,
  uSkinBufferBitmap,
  uIdHttpControl,
  uNativeHttpControl,
  uSkinListViewType,
  uFileCommon,
  uGPSLocation,
  uFrameContext,


  uPhotoManager,
  uSkinItems,
  uBaseList,
  uFuncCommon,
  uSkinListBoxType,

  WaitingFrame,
  MessageBoxFrame,
  uLang,

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,
  uDownloadPictureManager,
  ClientModuleUnit1,
  FriendCircleCommonMaterialDataMoudle,
  System.Generics.Collections,
  uDrawPicture,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, FMX.DeviceInfo,
  uSkinFireMonkeyScrollBoxContent,  FMX.ListView.Appearances,FMX.ListView,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinFireMonkeyLabel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, FMX.ScrollBox,
  FMX.Memo, uSkinFireMonkeyMemo, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyImage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, uSkinFireMonkeyCustomList, System.Sensors,
  System.Sensors.Components, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinCustomListType, uSkinVirtualListType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uBaseSkinControl, uSkinPanelType, uDrawCanvas, FMX.Memo.Types;

type
  TFrameAddSpirit = class(TFrame,IFrameHistroyReturnEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    lvPictures: TSkinFMXListView;
    pnlDevide1: TSkinFMXPanel;
    pnlSpirit: TSkinFMXPanel;
    memSpirit: TSkinFMXMemo;
    btnOK: TSkinFMXButton;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    pnlDevide2: TSkinFMXPanel;
    lblCharCount: TSkinFMXLabel;
    tmrCalcCharCount: TTimer;
    btnDelPic: TSkinFMXButton;
    SkinFMXItemDesignerPanel2: TSkinFMXItemDesignerPanel;
    SkinFMXImage2: TSkinFMXImage;
    btnPosition: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    procedure lvPicturesClickItem(Sender: TSkinItem);
    procedure btnOKClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure memSpiritChange(Sender: TObject);
    procedure tmrCalcCharCountTimer(Sender: TObject);
    procedure btnDelPicClick(Sender: TObject);
    procedure btnPositionClick(Sender: TObject);
  private
    //是否可以返回上一个Frame
    function CanReturn:TFrameReturnActionType;
  private
    //提交成功后返回
    procedure OnModalResultFromSuccess(AFrame:TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
  private
    FSpirit:String;
    FPic1Width:Integer;
    FPic1Height:Integer;

    FPicLocalTempFileNameAndStreamList:TStringList;
    FPicLocalTempFilePathList:TStringList;
    FPicRemoteTempFileNameList:TStringList;


    FEditPictureItem:TSkinItem;


    procedure AlignControls;

    procedure DoAddPictureFromMenu(Sender: TObject;ADrawPictureList:TList<TPhoto>);
//    procedure DoEditPictureFromMenu(Sender: TObject;ADrawPictureList:TList<TDrawPicture>);

    procedure DoGetPictureFromCamera(Sender: TObject;Image:TBitmap);

    procedure DoAddSpiritExecute(ATimerTask:TObject);
    procedure DoAddSpiritExecuteEnd(ATimerTask: TObject);

    { Private declarations }
  public
    //选中的地址
    FAddr:String;
    FAddrDetail:String;
    //区分照片从哪获取  内存释放
    FImgComeFrom:String;

//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Clear;
    procedure DoReturnFrameFromAllImageFrame(AFrame:TFrame);
    { Public declarations }
  end;

var
  GlobalAddSpiritFrame:TFrameAddSpirit;

implementation

uses
  MainForm,
//  GetpositionFrame,
  AllImageFrame;

{$R *.fmx}

procedure TFrameAddSpirit.btnReturnClick(Sender: TObject);
begin
  if CanReturnFrame(CurrentFrameHistroy)=TFrameReturnActionType.fratDefault then
  begin

    if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

end;

function TFrameAddSpirit.CanReturn: TFrameReturnActionType;
begin
  if Self.memSpirit.Text<>'' then
  begin
    Result:=TFrameReturnActionType.fratCanNotReturn;

    ShowMessageBoxFrame(Self,Trans('您确定要退出吗？'),'',TMsgDlgType.mtInformation,['取消','确定'],OnModalResultFromSuccess);

  end
  else
  begin
    Result:=TFrameReturnActionType.fratDefault;
    if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;
  end;

end;

procedure TFrameAddSpirit.Clear;
begin
  FAddr:='';
  FAddrDetail:='';
  GlobalAddSpiritFrame.btnPosition.Text:='所在位置';
  GlobalAddSpiritFrame.btnPosition.Prop.StaticIsPushed:=False;


  Self.lvPictures.Prop.Items.ClearItemsByType(sitDefault);
  Self.memSpirit.Text:='';

  //显示添加按钮
  Self.lvPictures.Prop.Items.FindItemByType(sitItem1).Visible:=True;

  Self.sbClient.VertScrollBar.Prop.Position:=0;

  AlignControls;
end;

constructor TFrameAddSpirit.Create(AOwner: TComponent);
begin
  inherited;
  FPicLocalTempFilePathList:=TStringList.Create;
  FPicLocalTempFileNameAndStreamList:=TStringList.Create;
  FPicRemoteTempFileNameList:=TStringList.Create;
  Self.lvPictures.Prop.Items.ClearItemsByType(sitDefault);
end;

procedure TFrameAddSpirit.DoAddSpiritExecute(ATimerTask: TObject);
var
  I: Integer;
  AResponseStream:TStringStream;
  ASuperObject:ISuperObject;
  AHttpControl:THttpControl;
  APicStream:TMemoryStream;
  APicUploadSucc:Boolean;
begin
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
        //出错
        TTimerTask(ATimerTask).TaskTag:=1;



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

          for I := 0 to 9-FPicRemoteTempFileNameList.Count-1 do
          begin
            FPicRemoteTempFileNameList.Add('');
          end;


          TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.AddSpirit_V2(
              GlobalManager.User.FID,
              GlobalManager.LoginKey,
              Self.FSpirit,

              FPicRemoteTempFileNameList[0],
              FPicRemoteTempFileNameList[1],
              FPicRemoteTempFileNameList[2],
              FPicRemoteTempFileNameList[3],
              FPicRemoteTempFileNameList[4],
              FPicRemoteTempFileNameList[5],
              FPicRemoteTempFileNameList[6],
              FPicRemoteTempFileNameList[7],
              FPicRemoteTempFileNameList[8],

              FPic1Width,
              FPic1Height,

              //经纬度
              0,//frmMain.FGPSLocation.Latitude,
              0,//frmMain.FGPSLocation.Longitude,


              //地址
              FAddr,
              //设备
              DeviceInfo.diDevice
              );


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
    uFuncCommon.FreeAndNil(AHttpControl);
  end;

end;

procedure TFrameAddSpirit.DoAddSpiritExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AUserSpiritFID:Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //所添加朋友圈的FID
          AUserSpiritFID:=ASuperObject.O['Data'].A['UserSpirit'].O[0].I['FID'];


//          //把生成的本地图片添加到缓存中
//          for I := 0 to FPicLocalTempFilePathList.Count-1 do
//          begin
//            //本地文件
//            GetGlobalDownloadPictureManager.AddPictureToUrlPictureList(
//                                  //GUID
//                                  GetFileNameWithoutExt(FPicLocalTempFilePathList[I]),
//                                  //Url
//                                  GetUserSpiritPicUrl(AUserSpiritFID,
//                                                      ExtractFileName(FPicRemoteTempFileNameList[I]),
//                                                      False),
//                                  //C:\Users\Administrator\Documents\8F898D2E3D154C53A3E77E4E2C934670.jpg
//                                  FPicLocalTempFilePathList[I],
//                                  '',
//                                  '.jpg'
//                                  );
//          end;
//          //保存缓存文件
//          GetGlobalDownloadPictureManager.SaveUrlPictureListDataFile;



          //返回并刷新列表
          HideFrame;////(Self,hfcttBeforeReturnFrame);
          ReturnFrame;//(Self.FrameHistroy);

      end
      else
      begin
        //添加朋友圈失败
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

procedure TFrameAddSpirit.DoGetPictureFromCamera(Sender: TObject;
  Image: TBitmap);
var
  ScaleFactor: Single;
  AImage: TDrawPicture;
  APhoto:TPhoto;
  ASkinPictureList:TList<TPhoto>;
  AFilePath:String;
begin
  //通过相册中的相机入口返回
  if GAllImageFrame<>nil then
  begin
    HideFrame;//(GAllImageFrame,hfcttBeforeReturnFrame);
    ReturnFrame;//(GAllImageFrame.FrameHistroy);
  end;

  //拍照返回
  if Image.Width > 1024 then
  begin
    ScaleFactor := Image.Width / 1024;
    Image.Resize(Round(Image.Width / ScaleFactor), Round(Image.Height / ScaleFactor));
  end;

  Self.FImgComeFrom:='Camera';

  AImage:=TDrawPicture.Create('','');
  CopyBitmap(Image,AImage);


  AFilePath:=GetApplicationPath+CreateGUIDString()+'.png';
  Image.SaveToFile(AFilePath);


  APhoto:=TPhoto.Create(nil);
  APhoto.ThumbFilePath:=AFilePath;
  APhoto.OriginFilePath:=AFilePath;


  ASkinPictureList:=TList<TPhoto>.Create;
  ASkinPictureList.Add(APhoto);
  Self.DoAddPictureFromMenu(nil,ASkinPictureList);
end;

procedure TFrameAddSpirit.DoReturnFrameFromAllImageFrame(AFrame: TFrame);
//var
//  I: Integer;
//  ScaleFactor: Single;
begin
//  if GAllImageFrame.FBtnSure then
//  begin


      Self.FImgComeFrom:='Libary';
//      for I := 0 to GAllImageFrame.FSelectedOriginPhotoList.Count-1 do
//      begin
//        //照片返回
//        if GAllImageFrame.FSelectedOriginPhotoList[I].Width > 1024 then
//        begin
//          ScaleFactor := GAllImageFrame.FSelectedOriginPhotoList[I].Width / 1024;
//          GAllImageFrame.FSelectedOriginPhotoList[I].Resize(Round(GAllImageFrame.FSelectedOriginPhotoList[I].Width / ScaleFactor), Round(GAllImageFrame.FSelectedOriginPhotoList[I].Height / ScaleFactor));
//        end;
//      end;
      Self.DoAddPictureFromMenu(nil,GAllImageFrame.FSelectedOriginPhotoList);


//  end
//  else
//  begin
//    //不做操作
//  end;
end;

//procedure TFrameAddSpirit.DoEditPictureFromMenu(Sender: TObject;ADrawPictureList:TList<TDrawPicture>);
//begin
//  if Not ADrawPictureList[0].IsEmpty then
//  begin
//    FEditPictureItem.Icon.Assign(ADrawPictureList[0]);
//  end;
//end;

destructor TFrameAddSpirit.Destroy;
begin

  //清空一下里面的Stream,万一没有释放
  FreeStringListObjects(FPicLocalTempFileNameAndStreamList);

  uFuncCommon.FreeAndNil(FPicLocalTempFilePathList);
  uFuncCommon.FreeAndNil(FPicLocalTempFileNameAndStreamList);
  uFuncCommon.FreeAndNil(FPicRemoteTempFileNameList);
  inherited;
end;

procedure TFrameAddSpirit.DoAddPictureFromMenu(Sender: TObject;ADrawPictureList:TList<TPhoto>);
var
  AListViewItem:TSkinListViewItem;
  I: Integer;
begin
  Self.lvPictures.Prop.Items.BeginUpdate;
  try
    for I := 0 to ADrawPictureList.Count-1 do
    begin
      //添加一张图片
      AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//      CopyBitmap(ADrawPictureList[I],AListViewItem.Icon);
      AListViewItem.Icon.LoadFromFile(ADrawPictureList[I].OriginFilePath);
    end;
  finally
    Self.lvPictures.Prop.Items.EndUpdate;
  end;

  AlignControls;


  //清理一下,减少内存占用
//  if GlobalMultiTakePictureMenuFrame<>nil then
//  begin
//    GlobalMultiTakePictureMenuFrame.Clear;
//  end;

  //内存释放  相机返回
  if FImgComeFrom='Camera'then
  begin
    for I := 0 to ADrawPictureList.Count-1 do
    begin
      if ADrawPictureList[I]<>nil then ADrawPictureList[I].Free;
    end;
    //若使用GlobalMultiTakePictureMenuFrame需注释
    ADrawPictureList.Free;
  end;
end;

function TFrameAddSpirit.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameAddSpirit.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

procedure TFrameAddSpirit.AlignControls;
begin
  //隐藏添加按钮
  Self.lvPictures.Prop.Items.FindItemByType(sitItem1).Visible:=
    Self.lvPictures.Prop.Items.Count<=9;


  Self.lvPictures.Height:=Self.lvPictures.Prop.GetContentHeight;
  Self.sbcClient.Height:=Self.lvPictures.Height
                        +pnlDevide1.Height
                        +pnlSpirit.Height
                        +pnlDevide2.Height
                        +btnOK.Height
                        +pnlDevide2.Height;
end;

procedure TFrameAddSpirit.btnDelPicClick(Sender: TObject);
begin
  Self.lvPictures.Prop.Items.Remove(Self.lvPictures.Prop.InteractiveItem);
  AlignControls;
end;

procedure TFrameAddSpirit.btnOKClick(Sender: TObject);
var
  I: Integer;
  APicStream:TMemoryStream;
  AFileName:String;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
begin
  HideVirtualKeyboard;

  DeviceInfoByPlatform;


  if Self.memSpirit.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入朋友圈内容!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Length(Self.memSpirit.Text)>250 then
  begin
    ShowMessageBoxFrame(Self,'朋友圈内容字数超出!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  ShowWaitingFrame(Self,'添加中...');



  //添加朋友圈
  FSpirit:=Self.memSpirit.Text;


  //第一张图片的尺寸
  FPic1Width:=0;
  FPic1Height:=0;


  FPicLocalTempFilePathList.Clear;


  //清空一下里面的Stream,万一没有释放
  FreeStringListObjects(FPicLocalTempFileNameAndStreamList);




  for I := 0 to Self.lvPictures.Prop.Items.Count-2 do
  begin

    //第一张图片的尺寸
    if I=0 then
    begin
      FPic1Width:=Self.lvPictures.Prop.Items[I].Icon.Width;
      FPic1Height:=Self.lvPictures.Prop.Items[I].Icon.Height;
    end;

    AFileName:=CreateGUIDString+'.jpg';
    //压缩图片
    ABitmapCodecSaveParams.Quality:=70;
    Self.lvPictures.Prop.Items[I].Icon.SaveToFile(
                                                  GetApplicationPath+AFileName,
                                                  @ABitmapCodecSaveParams
                                                  );
    //加载图片到内存流
    APicStream:=TMemoryStream.Create;
    APicStream.LoadFromFile(GetApplicationPath+AFileName);
    FPicLocalTempFileNameAndStreamList.AddObject(AFileName,APicStream);
    Self.FPicLocalTempFilePathList.Add(GetApplicationPath+AFileName);

  end;


  GetGlobalTimerThread.RunTempTask(DoAddSpiritExecute,
                                  DoAddSpiritExecuteEnd,
                                  'AddSpirit',
                                  True);
end;

procedure TFrameAddSpirit.lvPicturesClickItem(Sender: TSkinItem);
begin
  //查看
  //添加
  if Sender.ItemType=sitItem1 then
  begin
      HideVirtualKeyboard;

      //拍照
//      ShowFrame(TFrame(GlobalMultiTakePictureMenuFrame),TFrameMultiTakePictureMenu,frmMain,nil,nil,nil,Application,True,False,ufsefNone);
//      GlobalMultiTakePictureMenuFrame.FrameHistroy:=CurrentFrameHistroy;
      //添加
//      if Sender.ItemType=sitItem1 then
//      begin
//        GlobalMultiTakePictureMenuFrame.OnTakedPicture:=DoAddPictureFromMenu;
//      end
//      else
//      //修改
//      if Sender.ItemType=sitDefault then
//      begin
//        FEditPictureItem:=Sender;
//        GlobalMultiTakePictureMenuFrame.OnTakedPicture:=DoEditPictureFromMenu;
//      end;
//      GlobalMultiTakePictureMenuFrame.ShowMenu;

    //多选照片
    ShowFrame(TFrame(GAllImageFrame),TFrameAllImage,frmMain,nil,nil,DoReturnFrameFromAllImageFrame,Application,True,False,ufsefNone);
//    GAllImageFrame.FrameHistroy:=CurrentFrameHistroy;
    //相机结果回调事件
    GAllImageFrame.OnGetPhotoFromCamera:=DoGetPictureFromCamera;
    GAllImageFrame.Load(True,Self.lvPictures.Prop.Items.Count-1,9);
  end;
end;

procedure TFrameAddSpirit.memSpiritChange(Sender: TObject);
begin
  lblCharCount.Caption:=IntToStr(Length(Self.memSpirit.Text))+'/250';
end;

procedure TFrameAddSpirit.OnModalResultFromSuccess(AFrame: TObject);
begin
  if TFrameMessageBox(AFrame).ModalResult=Trans('确定') then
  begin
    //清空,表示可以退出
    Self.memSpirit.Text:='';
    //返回
    HideFrame;//(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

end;

procedure TFrameAddSpirit.btnPositionClick(Sender: TObject);
begin
//  if GlobalGPSLocation.HasLocated then
//  begin
//    HideFrame;//(Self,hfcttBeforeShowframe);
//    ShowFrame(TFrame(GlobalGetPositionFrame),TFrameGetPosition,frmMain,nil,nil,nil,Application);
//
//    GlobalGetPositionFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalGetPositionFrame.Load(FAddr,FAddrDetail);
//  end
//  else
//  begin
//    ShowMessageBoxFrame(Self,'您没有开启定位或尚位定位到您所在的位置!','',TMsgDlgType.mtInformation,['确定'],nil);
//
//  end;
end;

procedure TFrameAddSpirit.tmrCalcCharCountTimer(Sender: TObject);
begin
  Self.memSpiritChange(Self.memSpirit);
end;

end.

