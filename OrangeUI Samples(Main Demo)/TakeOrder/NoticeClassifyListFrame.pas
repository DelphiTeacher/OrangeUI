//convert pas to utf8 by ¥
unit NoticeClassifyListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,

  uTimerTask,
  uManager,


  uFuncCommon,
  uBaseList,
  uSkinItems,

  WaitingFrame,
  MessageBoxFrame,
  uSkinListBoxType,

  uInterfaceClass,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,


  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyNotifyNumberIcon, uDrawPicture, uSkinImageList,
  uSkinNotifyNumberIconType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameNoticeClassifyList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbNoticeList: TSkinFMXListBox;
    idpNotice: TSkinFMXItemDesignerPanel;
    imgNoticePic: TSkinFMXImage;
    lblNoticeName: TSkinFMXLabel;
    lblNoticeDetail: TSkinFMXLabel;
    btnItem: TSkinFMXButton;
    imgListNoticeIcon: TSkinImageList;
    nniNumber: TSkinFMXNotifyNumberIcon;
    procedure lbNoticeListPullDownRefresh(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbNoticeListClickItem(AItem: TSkinItem);
  private
    FNoticeClassifyList:TNoticeClassifyList;
    FNoticeClassifyFID:Integer;

    procedure GetNoticeClassifyListExecute(ATimerTask:TObject);
    procedure GetNoticeClassifyListExecuteEnd(ATimerTask:TObject);

  private
    procedure OnReturnFromNoticeListFrame(Frame:TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load;
    { Public declarations }
  end;

var
  GlobalNoticeClassifyListFrame:TFrameNoticeClassifyList;


implementation

{$R *.fmx}
uses
  NoticeListFrame,
  MainFrame,
  MainForm;

{ TFrameNotice }

procedure TFrameNoticeClassifyList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

constructor TFrameNoticeClassifyList.Create(AOwner: TComponent);
begin
  inherited;
  FNoticeClassifyList:=TNoticeClassifyList.Create;
  Self.lbNoticeList.Prop.Items.Clear(True);
end;

destructor TFrameNoticeClassifyList.Destroy;
begin
  FreeAndNil(FNoticeClassifyList);
  inherited;
end;

procedure TFrameNoticeClassifyList.GetNoticeClassifyListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user_notice_classify',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key]
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

procedure TFrameNoticeClassifyList.GetNoticeClassifyListExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  ANoticeClassifyList:TNoticeClassifyList;
  AListBoxItem:TSkinListBoxItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          ANoticeClassifyList:=TNoticeClassifyList.Create(ooReference);
          ANoticeClassifyList.ParseFromJsonArray(TNoticeClassify,ASuperObject.O['Data'].A['NoticeClassify']);
          Self.lbNoticeList.Prop.Items.BeginUpdate;
          try
              Self.lbNoticeList.Prop.Items.Clear(True);
              for I := 0 to ANoticeClassifyList.Count-1 do
              begin

                FNoticeClassifyList.Add(ANoticeClassifyList[I]);

                AListBoxItem:=Self.lbNoticeList.Prop.Items.Add;
                AListBoxItem.Data:=ANoticeClassifyList[I];
                AListBoxItem.Caption:=ANoticeClassifyList[I].notice_classify_name;

//                if ANoticeClassifyList[I].notice_classify_name='账号消息' then
//                begin
//                  AListBoxItem.Detail:='有关账号的审核等的通知';
//                end;
                if ANoticeClassifyList[I].notice_classify_name='其他消息' then
                begin
                  AListBoxItem.Detail:='例如审核结果通知等';
                end;
                if ANoticeClassifyList[I].notice_classify_name='系统公告' then
                begin
                  AListBoxItem.Detail:='系统平台的通知，例如：升级';
                end;
                if ANoticeClassifyList[I].notice_classify_name='订单消息' then
                begin
                  AListBoxItem.Detail:='供货商对订单操作的通知';
                end;
                if ANoticeClassifyList[I].notice_classify_name='站内信' then
                begin
                  AListBoxItem.Detail:='员工给酒店经理发送的通知';
                end;
                AListBoxItem.Detail1:=IntToStr(ANoticeClassifyList[I].notice_classify_unread_count);
                AListBoxItem.Icon.ImageIndex:=GetNoticeIconIndex(ANoticeClassifyList[I].notice_classify_name);

              end;
          finally
            Self.lbNoticeList.Prop.Items.EndUpdate();
            FreeAndNil(ANoticeClassifyList);
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
    Self.lbNoticeList.Prop.StopPullDownRefresh('刷新成功!',600);
  end;

end;

procedure TFrameNoticeClassifyList.lbNoticeListClickItem(AItem: TSkinItem);
var
  ANoticeClassify:TNoticeClassify;
begin
  ANoticeClassify:=AItem.Data;

  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
  //显示消息列表
  ShowFrame(TFrame(GlobalNoticeListFrame),TFrameNoticeList,frmMain,nil,nil,OnReturnFromNoticeListFrame,Application);
//  GlobalNoticeListFrame.FrameHistroy:=CurrentFrameHistroy;


  GlobalNoticeListFrame.Load(ANoticeClassify);

end;

procedure TFrameNoticeClassifyList.lbNoticeListPullDownRefresh(Sender: TObject);
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                   GetNoticeClassifyListExecute,
                                   GetNoticeClassifyListExecuteEnd);
end;

procedure TFrameNoticeClassifyList.Load;
begin
  Self.lbNoticeList.Prop.StartPullDownRefresh;
end;

procedure TFrameNoticeClassifyList.OnReturnFromNoticeListFrame(Frame: TFrame);
begin
  if GlobalIsNoticeListChanged then
  begin
    GlobalIsNoticeListChanged:=False;

    Self.lbNoticeList.Prop.StartPullDownRefresh;
    //刷新未读通知数
    GlobalMainFrame.GetUserNoticeUnReadCount;
  end;

end;

end.
