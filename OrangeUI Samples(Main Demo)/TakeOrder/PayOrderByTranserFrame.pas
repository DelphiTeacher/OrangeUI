//convert pas to utf8 by ¥
unit PayOrderByTranserFrame;

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
  uBaseHttpControl,
  uInterfaceClass,
  uEasyServiceCommon,

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
  uSkinFireMonkeyListView, uSkinFireMonkeyItemDesignerPanel, FMX.ScrollBox,
  FMX.Memo, uSkinFireMonkeyMemo, FMX.DateTimeCtrls, uSkinFireMonkeyDateEdit,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas, FMX.Memo.Types;

type
  TFramePayOrderByTranser = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    dedtTranserTime: TSkinFMXDateEdit;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlTranserTime: TSkinFMXPanel;
    btnTranserTime: TSkinFMXButton;
    pnlEmpty1: TSkinFMXPanel;
    pnlEmpty: TSkinFMXPanel;
    pnlEmpty3: TSkinFMXPanel;
    pnlEmpty4: TSkinFMXPanel;
    pnlPicture: TSkinFMXPanel;
    lvPictures: TSkinFMXListView;
    pnlDeletePic: TSkinFMXItemDesignerPanel;
    ImgPic: TSkinFMXImage;
    btnDelPic: TSkinFMXButton;
    lblHint: TSkinFMXLabel;
    pnlRemark: TSkinFMXPanel;
    memRemark: TSkinFMXMemo;
    pnlTranserBankAccount: TSkinFMXPanel;
    btnSelectBankAccount: TSkinFMXButton;
    lblBankAccountBankName: TSkinFMXLabel;
    SkinFMXPanel6: TSkinFMXPanel;
    lblBankAccountName: TSkinFMXLabel;
    lblBankAccountAccount: TSkinFMXLabel;
    pnlPaymentVoucher: TSkinFMXPanel;
    edtPaymentVoucher: TSkinFMXEdit;
    SkinFMXPanel1: TSkinFMXPanel;
    btnOK: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lvPicturesClickItem(AItem: TSkinItem);
    procedure btnDelPicClick(Sender: TObject);
    procedure btnTranserTimeStayClick(Sender: TObject);
    procedure btnSelectBankAccountStayClick(Sender: TObject);
    procedure dedtTranserTimeChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
  private
    //支付的订单
    FOrder:TOrder;

    FTranserTime:String;
    FPaymentVoucher:String;
    FRemark:String;

    //汇款账号
    FTranserBankAccount:TBankCard;

    //付款
    procedure DoPayOrderByTranserExecute(ATimerTask:TObject);
    procedure DoPayOrderByTranserExecuteEnd(ATimerTask:TObject);
  private
    //选择汇款账号返回
    procedure OnReturnFrameFromSelectMyBankCardList(Frame:TFrame);
  private

    FPicLocalTempFileNameAndStreamList:TStringList;
    FPicLocalTempFilePathList:TStringList;
    FPicRemoteTempFileNameList:TStringList;

    FEditPictureItem:TSkinItem;
    //拍照
    procedure AlignControls;
    procedure DoReturnFrameFromClipAddHeadFrame(Frame:TFrame);
    procedure DoReturnFrameFromClipEditHeadFrame(Frame:TFrame);

    procedure DoAddPictureFromMenu(Sender: TObject;ABitmap:TBitmap);
    procedure DoEditPictureFromMenu(Sender: TObject;ABitmap:TBitmap);

    { Private declarations }
  public
    procedure Load(AOrder:TOrder);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalPayOrderByTranserFrame:TFramePayOrderByTranser;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame,
  PayOrderResultFrame,
  MyBankCardListFrame;

procedure TFramePayOrderByTranser.AlignControls;
begin
  //隐藏添加按钮
  Self.lvPictures.Prop.Items.FindItemByType(sitItem1).Visible:=
    Self.lvPictures.Prop.Items.Count<=6;

  Self.pnlPicture.Height:=Self.lvPictures.Prop.GetContentHeight;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);

end;

procedure TFramePayOrderByTranser.btnSelectBankAccountStayClick(
  Sender: TObject);
begin
  //选择汇款账户
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalMyBankCardListFrame),TFrameMyBankCardList,frmMain,nil,nil,OnReturnFrameFromSelectMyBankCardList,Application);
//  GlobalMyBankCardListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalMyBankCardListFrame.Load('选择汇款账户',
                                futSelectList,
                                Self.FTranserBankAccount.fid);
end;

procedure TFramePayOrderByTranser.btnDelPicClick(Sender: TObject);
begin
  //删除图片
  Self.lvPictures.Prop.Items.Remove(Self.lvPictures.Prop.InteractiveItem);
  AlignControls;
end;

procedure TFramePayOrderByTranser.btnOKClick(Sender: TObject);
var
  I: Integer;
  APicStream:TMemoryStream;
  AFileName:String;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
begin
  HideVirtualKeyboard;


  if Self.btnTranserTime.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择汇款日期!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPaymentVoucher.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入汇款凭证!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
//  if Self.edtAddr.Text='' then
//  begin
//    ShowMessageBoxFrame(Self,'请选择酒店地址!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;
//  if Self.btnArea.Text='' then
//  begin
//    ShowMessageBoxFrame(Self,'请选择酒店所在省份城市!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;
//
//  FName:=Trim(Self.edtName.text);
//  FPhone:=Trim(Self.edtPhone.Text);
//  FAddr:=Trim(Self.edtAddr.Text);


  Self.FTranserTime:=Self.btnTranserTime.Caption;
  Self.FPaymentVoucher:=Self.edtPaymentVoucher.Text;
  FRemark:=Self.memRemark.Text;



  FPicLocalTempFilePathList.Clear;
  //清空一下里面的Stream,万一没有释放
  FreeStringListObjects(FPicLocalTempFileNameAndStreamList);



  for I := 0 to Self.lvPictures.Prop.Items.Count-2 do
  begin

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

  end;


  ShowWaitingFrame(Self,'提交中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                        DoPayOrderByTranserExecute,
                                        DoPayOrderByTranserExecuteEnd);

end;

procedure TFramePayOrderByTranser.btnTranserTimeStayClick(Sender: TObject);
begin
  //选择日期
  if Self.dedtTranserTime.DateTime=0 then
  begin
    Self.dedtTranserTime.DateTime:=Now;
  end;
  Self.dedtTranserTime.OpenPicker;

end;

procedure TFramePayOrderByTranser.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

constructor TFramePayOrderByTranser.Create(AOwner: TComponent);
begin
  inherited;
  FOrder:=TOrder.Create;

  FPicLocalTempFilePathList:=TStringList.Create;
  FPicLocalTempFileNameAndStreamList:=TStringList.Create;
  FPicRemoteTempFileNameList:=TStringList.Create;
  Self.lvPictures.Prop.Items.ClearItemsByType(sitDefault);

  FTranserBankAccount:=TBankCard.Create;

  Self.dedtTranserTime.Visible:=False;
end;

procedure TFramePayOrderByTranser.dedtTranserTimeChange(Sender: TObject);
begin
  Self.btnTranserTime.Caption:=FormatDateTime('YYYY-MM-DD',Self.dedtTranserTime.Date);
end;

destructor TFramePayOrderByTranser.Destroy;
begin
  FreeAndNil(FOrder);

  FreeAndNil(FTranserBankAccount);

  FreeAndNil(FPicLocalTempFilePathList);
  //清空一下里面的Stream,万一没有释放
  FreeStringListObjects(FPicLocalTempFileNameAndStreamList);
  FreeAndNil(FPicLocalTempFileNameAndStreamList);

  FreeAndNil(FPicRemoteTempFileNameList);
  inherited;
end;

procedure TFramePayOrderByTranser.DoPayOrderByTranserExecute(ATimerTask: TObject);
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
          APicUploadSucc:=AHttpControl.Post(ImageHttpServerUrl+'/Upload'
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
        TTimerTask(ATimerTask).TaskDesc:=
                  SimpleCallAPI('pay_order',
                                AHttpControl,
                                InterfaceUrl,
                                ['appid',
                                'user_fid',
                                'key',
                                'order_fid',
                                'payment_type',
                                'money',
                                'remark',
                                'transer_time',
                                'transer_bankaccount_name',
                                'transer_bankaccount_bankname',
                                'transer_bankaccount_account',
                                'transer_payment_voucher',
                                'pic1path',
                                'pic2path',
                                'pic3path',
                                'pic4path',
                                'pic5path',
                                'pic6path'
                                ],
                                [AppID,
                                GlobalManager.User.fid,
                                GlobalManager.User.key,
                                FOrder.fid,
                                Const_PaymentType_BankTranser,
                                FOrder.summoney,
                                FRemark,
                                Self.FTranserTime,
                                Self.FTranserBankAccount.name,
                                Self.FTranserBankAccount.bankname,
                                Self.FTranserBankAccount.account,
                                FPaymentVoucher,
                                FPicRemoteTempFileNameList[0],
                                FPicRemoteTempFileNameList[1],
                                FPicRemoteTempFileNameList[2],
                                FPicRemoteTempFileNameList[3],
                                FPicRemoteTempFileNameList[4],
                                FPicRemoteTempFileNameList[5]
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

procedure TFramePayOrderByTranser.DoPayOrderByTranserExecuteEnd(ATimerTask: TObject);
var
  AOrderPayment:TOrderPayment;
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          AOrderPayment:=TOrderPayment.Create;
          try

            AOrderPayment.ParseFromJson(ASuperObject.O['Data'].A['OrderPayment'].O[0]);
            FOrder.ParseFromJson(ASuperObject.O['Data'].A['Order'].O[0]);

            //付款成功
            HideFrame;//(Self,hfcttBeforeShowFrame);
            ShowFrame(TFrame(GlobalPayOrderResultFrame),TFramePayOrderResult,frmMain,nil,nil,nil,Application);
//            GlobalPayOrderResultFrame.FrameHistroy:=CurrentFrameHistroy;

            GlobalPayOrderResultFrame.Load(FOrder,AOrderPayment);


          finally
            FreeAndNil(AOrderPayment);
          end;


      end
      else
      begin
        //付款失败
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

procedure TFramePayOrderByTranser.DoAddPictureFromMenu(Sender: TObject;
  ABitmap: TBitmap);
begin
  //剪裁图片
  HideFrame;//(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalClipHeadFrame),TFrameClipHead,frmMain,nil,nil,DoReturnFrameFromClipAddHeadFrame,Application);
  GlobalClipHeadFrame.Init(ABitmap,400,300);
end;

procedure TFramePayOrderByTranser.DoEditPictureFromMenu(Sender: TObject;
  ABitmap: TBitmap);
begin
  //剪裁图片
  HideFrame;//(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalClipHeadFrame),TFrameClipHead,frmMain,nil,nil,DoReturnFrameFromClipEditHeadFrame,Application);
  GlobalClipHeadFrame.Init(ABitmap,400,300);
end;

procedure TFramePayOrderByTranser.DoReturnFrameFromClipEditHeadFrame(Frame: TFrame);
var
  ABitmap:TBitmap;
begin
  ABitmap:=GlobalClipHeadFrame.GetClipBitmap;
  try
    FEditPictureItem.Icon.Assign(ABitmap);
  finally
    FreeAndNil(ABitmap);
  end;
end;

procedure TFramePayOrderByTranser.DoReturnFrameFromClipAddHeadFrame(Frame: TFrame);
var
  AListViewItem:TSkinListViewItem;
  ABitmap:TBitmap;
begin
  ABitmap:=GlobalClipHeadFrame.GetClipBitmap;
  try
    //添加一张图片
    AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
    AListViewItem.Icon.Assign(ABitmap);

    AlignControls;
  finally
    FreeAndNil(ABitmap);
  end;
end;

function TFramePayOrderByTranser.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFramePayOrderByTranser.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

procedure TFramePayOrderByTranser.Load(AOrder: TOrder);
begin
  FOrder.Assign(AOrder);

  FTranserBankAccount.Clear;

  //汇款日期
  //默认今天
  Self.dedtTranserTime.DateTime:=Now;
  Self.btnTranserTime.Caption:=FormatDateTime('YYYY-MM-DD',Self.dedtTranserTime.Date);

  //汇款账户
  Self.lblBankAccountName.Caption:='';
  Self.lblBankAccountAccount.Caption:='';
  Self.lblBankAccountBankName.Caption:='';

  //凭证
  Self.edtPaymentVoucher.Text:='';

  //备注
  Self.memRemark.Text:='';


  Self.lvPictures.Prop.Items.ClearItemsByType(sitDefault);


  Self.btnOK.Caption:='确认汇款 '+'¥'+Format('%.2f',[FOrder.summoney]);


  AlignControls;
  Self.sbClient.VertScrollBar.Prop.Position:=0;
end;

procedure TFramePayOrderByTranser.lvPicturesClickItem(AItem: TSkinItem);
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

procedure TFramePayOrderByTranser.OnReturnFrameFromSelectMyBankCardList(Frame: TFrame);
begin
  //选择汇款账号返回
  if GlobalMyBankCardListFrame.FSelectedBankCardFID<>Self.FTranserBankAccount.fid then
  begin
    //选择过了
    Self.FTranserBankAccount.Assign(GlobalMyBankCardListFrame.FSelectedBankCard);
    Self.lblBankAccountName.Caption:=FTranserBankAccount.name;
    Self.lblBankAccountAccount.Caption:=FTranserBankAccount.account;
    Self.lblBankAccountBankName.Caption:=FTranserBankAccount.bankname;
  end;
end;

end.
