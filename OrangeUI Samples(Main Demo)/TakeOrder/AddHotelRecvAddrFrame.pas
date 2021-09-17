//convert pas to utf8 by ¥

unit AddHotelRecvAddrFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,

  uTimerTask,
  uInterfaceClass,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  XSuperObject,
  XSuperJson,

  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyRadioButton, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinFireMonkeyCheckBox, uSkinCheckBoxType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType;

type
  TFrameAddHotelRecvAddr = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlName: TSkinFMXPanel;
    edtName: TSkinFMXEdit;
    pnlEmpty: TSkinFMXPanel;
    pnlPhoneNumber: TSkinFMXPanel;
    edtPhone: TSkinFMXEdit;
    pnlEmpty5: TSkinFMXPanel;
    pnlArea: TSkinFMXPanel;
    btnArea: TSkinFMXButton;
    pnlEmpty6: TSkinFMXPanel;
    pnlIsDefault: TSkinFMXPanel;
    chkIsDefault: TSkinFMXCheckBox;
    pnlAddr: TSkinFMXPanel;
    memAddr: TSkinFMXMemo;
    btnOk: TSkinFMXButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnAreaStayClick(Sender: TObject);
  private

    FHotelFID:Integer;

    //添加酒店收货地址
    procedure DoAddHotelRecvAddrExecute(ATimerTask:TObject);
    procedure DoAddHotelRecvAddrExecuteEnd(ATimerTask:TObject);

  private
    //修改酒店收货地址
    procedure DoUpdateHotelRecvAddrExecute(ATimerTask:TObject);
    procedure DoUpdateHotelRecvAddrExecuteEnd(ATimerTask:TObject);
    { Private declarations }

  private
    //选择省市返回
    procedure OnReturnFrameFromSelectArea(Frame:TFrame);
    procedure LoadHotelRecvAddrToUI(AHotelRecvAddr:THotelRecvAddr);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
  public
    FHotelRecvAddr:THotelRecvAddr;
    procedure Clear;
    //修改收货地址
    procedure Edit(AHotelRecvAddr:THotelRecvAddr);
    //添加收货地址
    procedure Add(AHotelFID:Integer);
    //新增酒店的的时候填写收货地址
    procedure Input(AHotelRecvAddr:THotelRecvAddr);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;


var
  GlobalIsHotelRecvAddrChanged:Boolean;
  GlobalAddHotelRecvAddrFrame:TFrameAddHotelRecvAddr;


implementation

{$R *.fmx}

uses
  MainForm,
  HotelRecvAddrListFrame;

procedure TFrameAddHotelRecvAddr.btnAreaStayClick(Sender: TObject);
begin
  //选择省市
  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalSelectAreaFrame),TFrameSelectArea,frmMain,nil,nil,OnReturnFrameFromSelectArea,Application);
//  GlobalSelectAreaFrame.FrameHistroy:=CurrentFrameHistroy;

  if (FHotelRecvAddr.province<>'') and (FHotelRecvAddr.city<>'') then
  begin
    GlobalSelectAreaFrame.Init(FHotelRecvAddr.province,FHotelRecvAddr.city,FHotelRecvAddr.area);
  end;

end;

procedure TFrameAddHotelRecvAddr.btnOKClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  if Self.edtName.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入收货人姓名!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入收货人电话号码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.memAddr.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入收货人详细地址!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  FHotelRecvAddr.name:=Self.edtName.Text;
  FHotelRecvAddr.phone:=Self.edtPhone.Text;
  FHotelRecvAddr.addr:=Self.memAddr.Text;

  //是否默认
  FHotelRecvAddr.is_default:=Ord(Self.chkIsDefault.Prop.Checked);


  if FHotelFID=0 then
  begin
    //添加酒店时的返回
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
    Exit;
  end;


  if FHotelRecvAddr.fid=0 then
  begin
    //添加收货地址
    ShowWaitingFrame(Self,'添加中');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                             DoAddHotelRecvAddrExecute,
                                             DoAddHotelRecvAddrExecuteEnd);
    Exit;
  end;


  if FHotelRecvAddr.fid<>0 then
  begin
    //修改收货地址
    ShowWaitingFrame(Self,'加载中');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                          DoUpdateHotelRecvAddrExecute,
                                          DoUpdateHotelRecvAddrExecuteEnd);

    Exit;
  end;

end;

procedure TFrameAddHotelRecvAddr.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameAddHotelRecvAddr.Clear;
begin
  Self.FHotelRecvAddr.Clear;
  FHotelFID:=0;

  Self.btnArea.Caption:='';
  Self.chkIsDefault.Prop.Checked:=False;
  Self.memAddr.Text:='';
  Self.edtName.Text:='';
  Self.edtPhone.Text:='';

  Self.pnlIsDefault.Visible:=True;

  Self.pnlToolBar.Caption:='添加收货地址';
end;

constructor TFrameAddHotelRecvAddr.Create(AOwner: TComponent);
begin
  inherited;

  FHotelRecvAddr:=THotelRecvAddr.Create;

end;

destructor TFrameAddHotelRecvAddr.Destroy;
begin
  FreeAndNil(FHotelRecvAddr);
  inherited;
end;

procedure TFrameAddHotelRecvAddr.DoAddHotelRecvAddrExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
              SimpleCallAPI('add_hotel_recv_addr',
                            AHttpControl,
                            InterfaceUrl,
                           ['appid',
                            'user_fid',
                            'key',
                            'hotel_fid',
                            'name',
                            'phone',
                            'province',
                            'city',
                            'area',
                            'addr',
                            'is_default'
                            ],
                            [AppID,
                            GlobalManager.User.fid,
                            GlobalManager.User.key,
                            FHotelFID,
                            FHotelRecvAddr.name,
                            FHotelRecvAddr.phone,
                            FHotelRecvAddr.province,
                            FHotelRecvAddr.city,
                            FHotelRecvAddr.area,
                            FHotelRecvAddr.addr,
                            FHotelRecvAddr.is_default
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

procedure TFrameAddHotelRecvAddr.DoAddHotelRecvAddrExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //添加过酒店收货地址,返回需要刷新
        GlobalIsHotelRecvAddrChanged:=True;

        //添加酒店收货地址返回
        HideFrame;//(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);


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

procedure TFrameAddHotelRecvAddr.DoUpdateHotelRecvAddrExecute(
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
                    SimpleCallAPI('update_hotel_recv_addr',
                                  AHttpControl,
                                  InterfaceUrl,
                                  ['appid',
                                  'user_fid',
                                  'key',
                                  'hotel_fid',
                                  'hotel_recv_addr_fid',
                                  'name',
                                  'phone',
                                  'province',
                                  'city',
                                  'area',
                                  'addr',
                                  'is_default'
                                  ],
                                  [AppID,
                                  GlobalManager.User.fid,
                                  GlobalManager.User.key,
                                  FHotelFID,
                                  FHotelRecvAddr.fid,
                                  FHotelRecvAddr.name,
                                  FHotelRecvAddr.phone,
                                  FHotelRecvAddr.province,
                                  FHotelRecvAddr.city,
                                  FHotelRecvAddr.area,
                                  FHotelRecvAddr.addr,
                                  FHotelRecvAddr.is_default
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

procedure TFrameAddHotelRecvAddr.DoUpdateHotelRecvAddrExecuteEnd(
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

          //修改过酒店收货地址,返回需要刷新
          GlobalIsHotelRecvAddrChanged:=True;

          //返回
          HideFrame;//(Self,hfcttBeforeReturnFrame);
          ReturnFrame;//(Self.FrameHistroy);

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

procedure TFrameAddHotelRecvAddr.Edit(AHotelRecvAddr: THotelRecvAddr);
begin

  Self.pnlToolBar.Caption:='编辑收货地址';

  FHotelRecvAddr.Assign(AHotelRecvAddr);

  FHotelFID:=AHotelRecvAddr.hotel_fid;

  LoadHotelRecvAddrToUI(AHotelRecvAddr);

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

function TFrameAddHotelRecvAddr.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameAddHotelRecvAddr.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

procedure TFrameAddHotelRecvAddr.Input(AHotelRecvAddr:THotelRecvAddr);
begin
  Self.pnlToolBar.Caption:='填写收货地址';

  FHotelRecvAddr.Assign(AHotelRecvAddr);

  LoadHotelRecvAddrToUI(AHotelRecvAddr);

  //添加酒店时输入收货地址,
  //本身就是做为默认地址
  //不用选择
  Self.pnlIsDefault.Visible:=False;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameAddHotelRecvAddr.LoadHotelRecvAddrToUI(AHotelRecvAddr: THotelRecvAddr);
begin
  Self.edtName.Text:=AHotelRecvAddr.name;
  Self.edtPhone.Text:=AHotelRecvAddr.phone;

  Self.btnArea.Text:=AHotelRecvAddr.GetArea;
  Self.memAddr.Text:=AHotelRecvAddr.addr;

  Self.chkIsDefault.Prop.Checked:=(AHotelRecvAddr.is_default=1);

end;

procedure TFrameAddHotelRecvAddr.OnReturnFrameFromSelectArea(Frame: TFrame);
begin
//  FHotelRecvAddr.province:='';
//  FHotelRecvAddr.city:='';
//  FHotelRecvAddr.area:='';
//  //选择省市返回
//  if GlobalSelectAreaFrame.lbProvince.Prop.SelectedItem<>nil then
//  begin
//    FHotelRecvAddr.province:=GlobalSelectAreaFrame.lbProvince.Prop.SelectedItem.Caption;
//  end;
//  if GlobalSelectAreaFrame.lbCity.Prop.SelectedItem<>nil then
//  begin
//    FHotelRecvAddr.city:=GlobalSelectAreaFrame.lbCity.Prop.SelectedItem.Caption;
//  end;

  FHotelRecvAddr.province:=GlobalSelectAreaFrame.FSelectedProvince;
  FHotelRecvAddr.city:=GlobalSelectAreaFrame.FSelectedCity;
  FHotelRecvAddr.area:=GlobalSelectAreaFrame.FSelectedArea;

  Self.btnArea.Caption:=FHotelRecvAddr.GetArea;

end;

procedure TFrameAddHotelRecvAddr.Add(AHotelFID:Integer);
begin
  Self.pnlToolBar.Caption:='添加收货地址';

  FHotelFID:=AHotelFID;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

end.
