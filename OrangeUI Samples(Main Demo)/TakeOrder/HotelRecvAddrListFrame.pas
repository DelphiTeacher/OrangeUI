//convert pas to utf8 by ¥
unit HotelRecvAddrListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,
  uTimerTask,

  uInterfaceClass,
  uManager,
  uBaseHttpControl,
  uSkinListBoxType,

  WaitingFrame,
  MessageBoxFrame,
  EasyServiceCommonMaterialDataMoudle,


  XSuperObject,
  XSuperJson,

  uDrawCanvas,
  uSkinItems,
  uBaseList,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyRadioButton,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  uSkinFireMonkeyCheckBox, uSkinRadioButtonType, uSkinCheckBoxType,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uSkinPanelType;

type
  TFrameHotelRecvAddrList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbHotelAddrList: TSkinFMXListBox;
    idpItemDefault: TSkinFMXItemDesignerPanel;
    lblName: TSkinFMXLabel;
    lblPhone: TSkinFMXLabel;
    btnEdit: TSkinFMXButton;
    btnDelete: TSkinFMXButton;
    pnlAddRecvAddr: TSkinFMXPanel;
    btnAdd: TSkinFMXButton;
    lblRecvAddr: TSkinFMXLabel;
    chkItemIsDefault: TSkinFMXCheckBox;
    pnlItemDevide: TSkinFMXPanel;
    rbItemSelected: TSkinFMXRadioButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbHotelAddrListPullDownRefresh(Sender: TObject);
    procedure chkItemIsDefaultClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lbHotelAddrListClickItem(AItem: TSkinItem);
  private
    //页面使用类型
    FUseType:TFrameUseType;

    function CurrentRecvAddrList:THotelRecvAddrList;
  private
    FHotel:THotel;

    //收货地址列表
    FRecvAddrList:THotelRecvAddrList;

    //所属的酒店
    FHotelFID:Integer;


    //获取收货地址列表
    procedure DoGetHotelRecvAddrListExecute(ATimerTask:TObject);
    procedure DoGetHotelRecvAddrListExecuteEnd(ATimerTask:TObject);

  private
    FNeedDeleteRecvAddrFID:Integer;
    FNeedDeleteHotelAddrItem:TSkinItem;

    //删除收货地址
    procedure DoDelHotelRecvAddrExecute(ATimerTask:TObject);
    procedure DoDelHotelRecvAddrExecuteEnd(ATimerTask:TObject);
  private
    FNeedSetIsDefaultItem:TSkinItem;
    FNeedSetIsDefaultRecvAddrFID:Integer;
    //设置收货地址为默认
    procedure DoSetHotelRecvAddrIsDefaultExecute(ATimerTask:TObject);
    procedure DoSetHotelRecvAddrIsDefaultExecuteEnd(ATimerTask:TObject);

  private
    //删除收货地址返回
    procedure OnModalResultFromDeleteHotelAddr(Frame:TObject);
    //编辑收货地址返回
    procedure OnReturnFrameFromEditHotelRecvAddr(Frame:TFrame);
    //添加收货地址返回
    procedure OnReturnFrameFromAddHotelRecvAddr(Frame:TFrame);

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FSelectedRecvAddrFID:Integer;
    FSelectedRecvAddr:THotelRecvAddr;

    procedure Load(
                    //标题
                    ACaption:String;
                    //使用类型,HotelRecvAddrManage,SelectHotelRecvAddr
                    AUseType:TFrameUseType;
                    //所属酒店
                    AHotelFID:Integer;
                    //
                    AHotel:THotel;
                    //选中的收货地址列表
                    ASelectedRecvAddrFID:Integer
                    );
    { Public declarations }
  end;


var
  GlobalHotelRecvAddrListFrame:TFrameHotelRecvAddrList;

implementation

{$R *.fmx}

uses
  MainForm,
  AddHotelRecvAddrFrame;


procedure TFrameHotelRecvAddrList.btnDeleteClick(Sender: TObject);
var
  AHotelRecvAddr:THotelRecvAddr;
begin
  //删除收货地址
  AHotelRecvAddr:=Self.lbHotelAddrList.Prop.InteractiveItem.Data;
  FNeedDeleteRecvAddrFID:=AHotelRecvAddr.fid;
  FNeedDeleteHotelAddrItem:=Self.lbHotelAddrList.Prop.InteractiveItem;

  ShowMessageBoxFrame(Self,'确定删除?','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromDeleteHotelAddr);

end;

procedure TFrameHotelRecvAddrList.btnEditClick(Sender: TObject);
var
  AHotelRecvAddr:THotelRecvAddr;
begin
  AHotelRecvAddr:=Self.lbHotelAddrList.Prop.InteractiveItem.Data;

  //编辑收货地址
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalAddHotelRecvAddrFrame),TFrameAddHotelRecvAddr,frmMain,nil,nil,OnReturnFrameFromEditHotelRecvAddr,Application);
//  GlobalAddHotelRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddHotelRecvAddrFrame.Edit(AHotelRecvAddr);

end;

procedure TFrameHotelRecvAddrList.btnAddClick(Sender: TObject);
begin

  //添加收货地址
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalAddHotelRecvAddrFrame),TFrameAddHotelRecvAddr,frmMain,nil,nil,OnReturnFrameFromAddHotelRecvAddr,Application);
//  GlobalAddHotelRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddHotelRecvAddrFrame.Clear;
  GlobalAddHotelRecvAddrFrame.Clear;
  GlobalAddHotelRecvAddrFrame.Add(FHotelFID);


end;

procedure TFrameHotelRecvAddrList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

constructor TFrameHotelRecvAddrList.Create(AOwner: TComponent);
begin
  inherited;

  FRecvAddrList:=THotelRecvAddrList.Create;
  Self.lbHotelAddrList.Prop.Items.Clear(True);

end;

function TFrameHotelRecvAddrList.CurrentRecvAddrList: THotelRecvAddrList;
begin
  if FHotel<>nil then
  begin
    Result:=FHotel.RecvAddrList;
  end
  else
  begin
    Result:=FRecvAddrList;
  end;
end;

destructor TFrameHotelRecvAddrList.Destroy;
begin
  FreeAndNil(FRecvAddrList);

  inherited;
end;

procedure TFrameHotelRecvAddrList.DoDelHotelRecvAddrExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('del_hotel_recv_addr',
                          AHttpControl,
                          InterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'hotel_fid',
                          'hotel_recv_addr_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FHotelFID,
                          FNeedDeleteRecvAddrFID
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

procedure TFrameHotelRecvAddrList.DoDelHotelRecvAddrExecuteEnd(
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

        //删除收货地址成功

        Self.lbHotelAddrList.Prop.Items.Remove(FNeedDeleteHotelAddrItem);

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

procedure TFrameHotelRecvAddrList.DoGetHotelRecvAddrListExecute(
  ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
              SimpleCallAPI('get_hotel_recv_addr_list',
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
                            FHotelFID
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

procedure TFrameHotelRecvAddrList.DoGetHotelRecvAddrListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  I:Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


        //查询收货地址列表成功
        CurrentRecvAddrList.Clear;
        CurrentRecvAddrList.ParseFromJsonArray(THotelRecvAddr,ASuperObject.O['Data'].A['HotelRecvAddrList']);




        Self.lbHotelAddrList.Prop.Items.BeginUpdate;
        try

          Self.lbHotelAddrList.Prop.Items.ClearItemsByType(sitDefault);

          for I := 0 to CurrentRecvAddrList.Count-1 do
          begin


            AListBoxItem:=Self.lbHotelAddrList.Prop.Items.Add;
            AListBoxItem.Data:=CurrentRecvAddrList[I];
            AListBoxItem.Caption:=CurrentRecvAddrList[I].name;

            AListBoxItem.Detail:=CurrentRecvAddrList[I].phone;
            AListBoxItem.Detail1:=CurrentRecvAddrList[I].GetLongAddr;
            AListBoxItem.Checked:=CurrentRecvAddrList[I].is_default=1;

            if (FSelectedRecvAddrFID=CurrentRecvAddrList[I].fid) then
            begin
              AListBoxItem.Selected:=True;
              FSelectedRecvAddr:=CurrentRecvAddrList[I];
            end;

          end;

        finally
          Self.lbHotelAddrList.Prop.Items.EndUpdate();
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
    Self.lbHotelAddrList.Prop.StopPullDownRefresh('刷新成功!',600);
  end;
end;

procedure TFrameHotelRecvAddrList.DoSetHotelRecvAddrIsDefaultExecute(
  ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
                  SimpleCallAPI('set_hotel_recv_addr_is_default',
                                AHttpControl,
                                InterfaceUrl,
                                ['appid',
                                'user_fid',
                                'key',
                                'hotel_fid',
                                'hotel_recv_addr_fid'
                                ],
                                [AppID,
                                GlobalManager.User.fid,
                                GlobalManager.User.key,
                                FHotelFID,
                                FNeedSetIsDefaultRecvAddrFID
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

procedure TFrameHotelRecvAddrList.DoSetHotelRecvAddrIsDefaultExecuteEnd(
  ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AHotelRecAddr:THotelRecvAddr;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //设置收货地址为默认成功
          Self.lbHotelAddrList.Prop.Items.UnCheckAll;
          for I := 0 to CurrentRecvAddrList.Count-1 do
          begin
            CurrentRecvAddrList[I].is_default:=0;
          end;

          FNeedSetIsDefaultItem.Checked:=True;
          AHotelRecAddr:=FNeedSetIsDefaultItem.Data;
          AHotelRecAddr.is_default:=1;

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
procedure TFrameHotelRecvAddrList.lbHotelAddrListClickItem(AItem: TSkinItem);
var
  AHotelRecvAddr:THotelRecvAddr;
begin
  AHotelRecvAddr:=AItem.Data;


  //编辑收货地址
  if FUseType=futManage then
  begin
    HideFrame;//(Self,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalAddHotelRecvAddrFrame),TFrameAddHotelRecvAddr,frmMain,nil,nil,OnReturnFrameFromEditHotelRecvAddr,Application);
//    GlobalAddHotelRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalAddHotelRecvAddrFrame.Edit(AHotelRecvAddr);
  end;


  //选择收货地址
  if FUseType=futSelectList then
  begin
    FSelectedRecvAddr:=AHotelRecvAddr;
    Self.FSelectedRecvAddrFID:=AHotelRecvAddr.fid;

    //返回
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);

  end;

end;

procedure TFrameHotelRecvAddrList.lbHotelAddrListPullDownRefresh(
  Sender: TObject);
begin
  //刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                         DoGetHotelRecvAddrListExecute,
                                         DoGetHotelRecvAddrListExecuteEnd);
end;

procedure TFrameHotelRecvAddrList.Load(ACaption:String;
                                        AUseType:TFrameUseType;
                                        AHotelFID:Integer;
                                        AHotel:THotel;
                                        ASelectedRecvAddrFID:Integer);
//var
//  AListBoxItem:TSkinListBoxItem;
//  I:Integer;
begin
//  FHotel:=AHotel;
//  FHotelFID:=AHotel.fid;
  FHotel:=AHotel;

  FHotelFID:=AHotelFID;
  FUseType:=AUseType;
  FSelectedRecvAddrFID:=ASelectedRecvAddrFID;
  FSelectedRecvAddr:=nil;


  Self.pnlToolBar.Caption:=ACaption;

  //收货地址管理
  if FUseType=futManage then
  begin
    Self.chkItemIsDefault.Visible:=True;
//    Self.btnEdit.Visible:=True;
//    Self.btnDelete.Visible:=True;
//    Self.pnlItemDevide.Visible:=True;
//    Self.lbHotelAddrList.Prop.ItemHeight:=130;
//
//    //分隔线
//    Self.idpItemDefault.Material.BackColor.DrawRectSetting.Bottom:=5;
//    Self.lbHotelAddrList.Material.DrawItemDevideParam.IsFill:=False;

    Self.rbItemSelected.Visible:=False;
  end;

  //选择收货地址
  if FUseType=futSelectList then
  begin
    Self.chkItemIsDefault.Visible:=False;
//    Self.btnEdit.Visible:=False;
//    Self.btnDelete.Visible:=False;
//    Self.pnlItemDevide.Visible:=False;
//    Self.lbHotelAddrList.Prop.ItemHeight:=100;
//    //分隔线
//    Self.idpItemDefault.Material.BackColor.DrawRectSetting.Bottom:=0;
//    Self.lbHotelAddrList.Material.DrawItemDevideParam.IsFill:=True;

    Self.rbItemSelected.Visible:=True;
  end;


  Self.lbHotelAddrList.Prop.StartPullDownRefresh;


end;

procedure TFrameHotelRecvAddrList.OnReturnFrameFromAddHotelRecvAddr(Frame: TFrame);
begin
  //添加收货地址返回
  if GlobalIsHotelRecvAddrChanged then
  begin
    GlobalIsHotelRecvAddrChanged:=False;
    Self.lbHotelAddrList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameHotelRecvAddrList.OnReturnFrameFromEditHotelRecvAddr(
  Frame: TFrame);
begin
  //编辑收货地址返回
  if GlobalIsHotelRecvAddrChanged then
  begin
    GlobalIsHotelRecvAddrChanged:=False;

    Self.lbHotelAddrList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameHotelRecvAddrList.OnModalResultFromDeleteHotelAddr(
  Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin
    ShowWaitingFrame(Self,'删除中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                  DoDelHotelRecvAddrExecute,
                                  DoDelHotelRecvAddrExecuteEnd);
  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;

end;

procedure TFrameHotelRecvAddrList.chkItemIsDefaultClick(Sender: TObject);
var
  AHotelRecAddr:THotelRecvAddr;
begin
  //设置收货地址为默认

  AHotelRecAddr:=Self.lbHotelAddrList.Prop.InteractiveItem.Data;
  FNeedSetIsDefaultRecvAddrFID:=AHotelRecAddr.fid;
  FNeedSetIsDefaultItem:=Self.lbHotelAddrList.Prop.InteractiveItem;


  if AHotelRecAddr.is_default=0 then
  begin
    ShowWaitingFrame(Self,'处理中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                          DoSetHotelRecvAddrIsDefaultExecute,
                                          DoSetHotelRecvAddrIsDefaultExecuteEnd);
  end;

end;

end.
