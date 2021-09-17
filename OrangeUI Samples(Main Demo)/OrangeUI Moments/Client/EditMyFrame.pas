//convert pas to utf8 by ¥
unit EditMyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,PopupMenuFrame,ChangeNameFrame,uManager,System.IOUtils,IdHTTP,IdURI,
  uSkinItems, ClientModuleUnit1, XSuperObject,uDrawPicture,uSkinBufferBitmap,
  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  ClipHeadFrame,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,uTimerTask,
  MessageBoxFrame,uIdHttpControl, uBaseHttpControl,uFuncCommon,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyImage,
  uSkinFireMonkeyCustomList, uSkinFireMonkeyButton, uSkinFireMonkeyPanel,
  IdAuthentication, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  FMX.Gestures,
  System.Generics.Collections,
  uSkinPicture, uSkinButtonType, uSkinPanelType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uDrawCanvas;

type
  TFrameEditMyFrame = class(TFrame)
    lbdata: TSkinFMXListBox;
    pnl2: TSkinFMXItemDesignerPanel;
    lblHead: TSkinFMXLabel;
    imgHead: TSkinFMXImage;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnl1: TSkinFMXItemDesignerPanel;
    lblItemName: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    procedure lbdataClickItem(AItem: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
    FPicRemoteTempFileNameList:TStringList;
    procedure DoEditPictureFromMenu(Sender: TObject;ABitmap:TBitmap);
    procedure DoMenuClickFromPopupMenuFrame(APopupMenuFrame:TFrame);
    procedure DoReturnFrameFromClipHeadFrame(AFromFrame:TFrame);
    procedure DoSexExecute(ATimerTask:TObject);
    procedure DoSexExecuteEnd(ATimerTask:TObject);
    procedure DoImageExecute(ATimerTask:TObject);
    procedure DoImageExecuteEnd(ATimerTask:TObject);
  public
    FSex:String;
    FFilePath:String;
    FFileName:String;
//    FrameHistroy:TFrameHistroy;
    procedure Load;

    { Public declarations }
  end;

var
  GlobalEditMyFrame:TFrameEditMyFrame;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame,
  TakePictureMenuFrame,
  MyFrame,
  ChangeSignFrame;

procedure TFrameEditMyFrame.btnReturnClick(Sender: TObject);
begin
  GlobalMainFrame.FMyFrame.Load;

  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameEditMyFrame.DoEditPictureFromMenu(Sender: TObject;ABitmap:TBitmap);

begin
  HideFrame;//(GlobalEditMyFrame,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalClipHeadFrame),TFrameClipHead,frmMain,nil,nil,DoReturnFrameFromClipHeadFrame,Application);
  GlobalClipHeadFrame.Init(ABitmap,100,100);
end;

procedure TFrameEditMyFrame.DoImageExecute(ATimerTask: TObject);
var
  I: Integer;
  ASuperObject:ISuperObject;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
  APicStream:TFileStream;
  AResponseStream:TStringStream;
  AHttpControl:THttpControl;
  APicUploadSucc:Boolean;
begin
  AHttpControl:=TSystemHttpControl.Create;
  try
    TTimerTask(ATimerTask).TaskTag:=1;



     APicUploadSucc:=True;
      //上传到服务器
     APicStream:=TFileStream.Create(FFilePath,fmOpenRead or fmShareDenyNone);
     AResponseStream:=TStringStream.Create('',TEncoding.UTF8);

      try

        APicUploadSucc:=AHttpControl.Post(
                          TIdURI.URLEncode(//对中文进行编码

                            //上传接口
                            uBaseHttpControl.FixSupportIPV6URL(ImageHttpServerUrl)
                            +'/Upload'
                              //文件名
                              +'?FileName='+FFileName
                              //文件存放目录
                              +'&FileDir='+'Temp'
                              ),

                            //图片文件的数据流
                            APicStream,
                            //返回数据流
                            AResponseStream
                            );
        if APicUploadSucc then
        begin

          AResponseStream.Position:=0;
          //解析返回的Json数据
          ASuperObject:=TSuperObject.Create(AResponseStream.DataString);



          if ASuperObject.I['Code']=200 then
          begin
            //ShowMessage('上传成功');

            //GlobalManager.User.HeadPicPath:=AFileName;
            TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.UpdateUserHead(
                    GlobalManager.User.FID,
                    GlobalManager.LoginKey,
                    FFileName);
            GlobalManager.User.HeadPicPath:=FFileName;
            Self.lbdata.Prop.Items.FindItemByCaption('头像').Icon.Url:=GlobalManager.User.GetHeadPicUrl;

            TTimerTask(ATimerTask).TaskTag:=0;

          end;
        end
        else
        begin
          //图片上传失败
          TTimerTask(ATimerTask).TaskTag:=2;
        end;



      finally
        FreeAndNil(APicStream);
        FreeAndNil(AResponseStream);

      end;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
  FreeAndNil(AHttpControl);
end;

procedure TFrameEditMyFrame.DoImageExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ABitmap:TBitmap;

begin
   if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        Self.lbdata.Prop.Items.FindItemByCaption('头像').Icon.Clear;
        Self.lbdata.Prop.Items.FindItemByCaption('头像').Icon.LoadFromFile(FFilePath);
        Self.lbdata.Prop.Items.FindItemByCaption('头像').Icon.PictureDrawType:=TPictureDrawType.pdtAuto;

      end
      else
      begin
        //失败
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
end;

procedure TFrameEditMyFrame.DoSexExecute(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
   try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    ASuperObject:=TSuperObject.Create;
    if FSex='男' then
    begin
      ASuperObject.B['Sex']:=True;
    end
    else
    begin
      ASuperObject.B['Sex']:=False;
    end;

    TTimerTask(ATimerTask).TaskDesc:=
      ClientModuleUnit1.ClientModule.ServerMethods1Client.UpdateUserInfo(
            GlobalManager.User.FID,
            GlobalManager.LoginKey,
            ASuperObject.AsJSON);


    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameEditMyFrame.DoSexExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        Self.lbdata.Prop.Items.FindItemByCaption('性别').Detail:= FSex;
        if FSex='男' then
        begin
          GlobalManager.User.Sex:=True;
        end
        else
        begin
          GlobalManager.User.Sex:=False;
        end;
      end
      else
      begin
        //失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
end;

procedure TFrameEditMyFrame.DoMenuClickFromPopupMenuFrame(APopupMenuFrame: TFrame);
begin

  FSex:=TFramePopupMenu(APopupMenuFrame).ModalResult;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoSexExecute,
      DoSexExecuteEnd
      );

 end;



procedure TFrameEditMyFrame.DoReturnFrameFromClipHeadFrame(AFromFrame: TFrame);
var
  ABitmap:TBitmap;
  AFileName:String;
  AFilePath:String;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
begin
  ABitmap:=GlobalClipHeadFrame.GetClipBitmap;
  AFileName:=CreateGUIDString+'.jpg';


  //C:\Users\Administrator\Documents\testhead 2017-06-06 08-01-07-603.jpg
  AFilePath:=System.IOUtils.TPath.GetDocumentsPath+PathDelim+AFileName;

//  //图片上传接口的url
//  AServerUrl:='http://www.orangeui.cn:7041';

  //压缩比70%
  ABitmapCodecSaveParams.Quality:=70;
  ABitmap.SaveToFile(
                    //保存到文档目录
                    AFilePath,
                    @ABitmapCodecSaveParams
                    );
  FFileName:=AFileName;
  FFilePath:=AFilePath;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
    DoImageExecute,
    DoImageExecuteEnd
    );
   FreeAndNil(ABitmap);
end;

procedure TFrameEditMyFrame.Load;
begin
  if GlobalManager.User.Sex then
  begin
    Self.lbdata.Prop.Items.FindItemByCaption('性别').Detail:='男';
  end
  else
  Self.lbdata.Prop.Items.FindItemByCaption('性别').Detail:='女';


  Self.lbdata.Prop.Items.FindItemByCaption('签名').Detail:=GlobalManager.User.Sign;
  Self.lbdata.Prop.Items.FindItemByCaption('签名').Height:=uSkinBufferBitmap.GetStringHeight(GlobalManager.User.Sign,
                                RectF(0,0,Self.lblItemDetail.Width,MaxInt))
                                +11+11;


  Self.lbdata.Prop.Items.FindItemByCaption('手机').Detail:=GlobalManager.User.Phone;

  Self.lbdata.Prop.Items.FindItemByCaption('昵称').Detail:=GlobalManager.User.Name;

  Self.lbdata.Prop.Items.FindItemByCaption('头像').Icon.Url:=GlobalManager.User.GetHeadPicUrl;
  Self.lbdata.Prop.Items.FindItemByCaption('头像').Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
end;

procedure TFrameEditMyFrame.lbdataClickItem(AItem: TSkinItem);
begin
  if AItem.Caption='昵称'  then
  begin
    HideFrame;//(GlobalEditMyFrame,hfcttBeforeShowframe);
    ShowFrame(TFrame(GlobalChangeNameFrame),TFrameChangeName,frmMain,nil,nil,nil,Application);
    GlobalChangeNameFrame.edtNickName.Text:=Self.lbdata.Prop.Items.FindItemByCaption('昵称').Detail;
//    GlobalChangeNameFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if AItem.Caption='性别'  then
  begin

    ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoMenuClickFromPopupMenuFrame,Application,True,True,ufsefNone);
    GlobalPopupMenuFrame.Init('您的性别是?',['男','女']);
  end;
  if AItem.Caption='头像' then
  begin
    HideVirtualKeyboard;
    ShowFrame(TFrame(GlobalTakePictureMenuFrame),TFrameTakePictureMenu,frmMain,nil,nil,nil,Application,True,False,ufsefNone);
//    GlobalTakePictureMenuFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalTakePictureMenuFrame.OnTakedPicture:=DoEditPictureFromMenu;
    GlobalTakePictureMenuFrame.ShowMenu;
  end;
  if AItem.Caption='签名' then
  begin
    HideFrame;//(GlobalEditMyFrame,hfcttBeforeShowframe);
    ShowFrame(TFrame(GlobalChangeSignFrame),TFrameChangeSign,frmMain,nil,nil,nil,Application);
    GlobalChangeSignFrame.memSign.Text:=Self.lbdata.Prop.Items.FindItemByCaption('签名').Detail;
//    GlobalChangeSignFrame.FrameHistroy:=CurrentFrameHistroy;
  end;

end;


end.
