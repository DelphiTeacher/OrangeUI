unit GetPositionFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyPanel, uSkinFireMonkeyControl,
  MainForm, uSkinFireMonkeyRadioButton, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyCustomList, uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinItems, AddSpiritFrame,XSuperObject,uTimerTask,

  uGPSLocation,
  uBaseHttpControl,uIdHttpControl,

  uGPSUtils,
//  uGPSLocation,

  uUIFunction,ClientModuleUnit1,
  FMX.ListView,MessageBoxFrame,uSkinListViewType,WaitingFrame,
  uSkinFireMonkeyListBox, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit,
  uSkinFireMonkeyCheckBox, uSkinRadioButtonType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinButtonType, uBaseSkinControl, uSkinPanelType;

type
  TFrameGetPosition = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlGetPosition: TSkinFMXPanel;
    lvPosition: TSkinFMXListView;
    pnlSitItem1: TSkinFMXItemDesignerPanel;
    lblName: TSkinFMXLabel;
    pnlSitDefault: TSkinFMXItemDesignerPanel;
    lblPositionName: TSkinFMXLabel;
    lblPositionDetil: TSkinFMXLabel;
    chkColor5: TSkinFMXRadioButton;
    chkColor6: TSkinFMXRadioButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lvPositionClickItem(AItem: TSkinItem);
    procedure lvPositionPullUpLoadMore(Sender: TObject);
  private

    procedure DoSelectedAddrExecute(ATimerTask:TObject);
    procedure DoSelectedAddrExecuteEnd(ATimerTask:TObject);
    procedure DoSelectedAddrAddExecute(ATimerTask:TObject);
    procedure DoSelectedAddrAddExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public

    FSelectedAddr:String;
    FSelectedAddrDetail:String;
    FrameHistroy:TFrameHistroy;
    procedure Load(ALastSeletedAddr:String;ALastSeletedAddrDetail:String);
    { Public declarations }
  end;

var
  GlobalGetPositionFrame:TFrameGetPosition;

implementation

{$R *.fmx}

uses
  uManager;


procedure TFrameGetPosition.btnReturnClick(Sender: TObject);
begin
  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

procedure TFrameGetPosition.DoSelectedAddrAddExecute(ATimerTask: TObject);
var
  AResponseStream:TStringStream;
  AHttpControl:THttpControl;
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    AHttpControl:=TSystemHttpControl.Create;
    AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
    try
      //调用百度接口
      //把返回的数据放入AResponseStream
      AHttpControl.Get(

                uBaseHttpControl.FixSupportIPV6URL('http://api.map.baidu.com')
                +'/geocoder/v2/?'
                +'location='+FloatToStr(GlobalGPSLocation.Latitude)+','+FloatToStr(GlobalGPSLocation.Longitude)//固定地址
                +'&output=json'
                +'&pois=1'
                +'&radius=1000'
                +'&coordtype=gcj02ll'
                +'&ak='+uGPSUtils.BaiduAPIKey
                ,
                AResponseStream
                );

      TTimerTask(ATimerTask).TaskDesc:=AResponseStream.DataString;

      TTimerTask(ATimerTask).TaskTag:=0;

    finally
      AResponseStream.Free;
      FreeAndNil(AHttpControl);
    end;
  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameGetPosition.DoSelectedAddrAddExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListViewItem:TSkinListViewItem;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      Self.lvPosition.Prop.Items.BeginUpdate;
      try

          for I := 0 to ASuperObject.O['result'].A['pois'].Length-1 do
          begin

            if (FSelectedAddr<>ASuperObject.O['result'].A['pois'].O[I].S['name'])
              and (Self.lvPosition.Prop.Items.FindItemByCaption(ASuperObject.O['result'].A['pois'].O[I].S['name'])=nil) then
            begin

              AListViewItem:=Self.lvPosition.Prop.Items.Add;
              AListViewItem.Caption:=ASuperObject.O['result'].A['pois'].O[I].S['name'];
              AListViewItem.Detail:=ASuperObject.O['result'].A['pois'].O[I].S['addr'];
            end;

          end;

      finally
        Self.lvPosition.Prop.Items.EndUpdate;
      end;
    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    Self.lvPosition.Prop.StopPullUpLoadMore();
  end;
end;

procedure TFrameGetPosition.DoSelectedAddrExecute(ATimerTask: TObject);
var
  AResponseStream:TStringStream;
  AHttpControl:THttpControl;
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    AHttpControl:=TSystemHttpControl.Create;
    AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
    try
      //调用百度接口
      //把返回的数据放入AResponseStream
      AHttpControl.Get(
                'http://api.map.baidu.com/geocoder/v2/?'
                +'location='+FloatToStr(GlobalGPSLocation.Latitude)+','+FloatToStr(GlobalGPSLocation.Longitude)//固定地址
                +'&output=json'
                +'&pois=1'
                //半径
                +'&radius=1000'
                +'&coordtype=gcj02ll'
                +'&ak='+uGPSUtils.BaiduAPIKey
                ,
                AResponseStream
                );

      TTimerTask(ATimerTask).TaskDesc:=AResponseStream.DataString;

      TTimerTask(ATimerTask).TaskTag:=0;

    finally
      AResponseStream.Free;
      FreeAndNil(AHttpControl);
    end;
  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameGetPosition.DoSelectedAddrExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListViewItem:TSkinListViewItem;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      Self.lvPosition.Prop.Items.BeginUpdate;
      try

          for I := 0 to ASuperObject.O['result'].A['pois'].Length-1 do
          begin
            if FSelectedAddr<>ASuperObject.O['result'].A['pois'].O[I].S['name'] then
            begin
              AListViewItem:=Self.lvPosition.Prop.Items.Add;
              AListViewItem.Caption:=ASuperObject.O['result'].A['pois'].O[I].S['name'];
              AListViewItem.Detail:=ASuperObject.O['result'].A['pois'].O[I].S['addr'];
            end;

          end;

      finally
        Self.lvPosition.Prop.Items.EndUpdate;
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

procedure TFrameGetPosition.lvPositionClickItem(AItem: TSkinItem);
begin
  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);

  GlobalAddSpiritFrame.btnPosition.Text:=AItem.Caption;
  GlobalAddSpiritFrame.btnPosition.Prop.StaticIsPushed:=True;

  GlobalAddSpiritFrame.FAddr:=AItem.Caption;
  GlobalAddSpiritFrame.FAddrDetail:=AItem.Detail;


  if AItem.Caption='不显示位置' then
  begin
    GlobalAddSpiritFrame.btnPosition.Text:='所在位置';
    GlobalAddSpiritFrame.btnPosition.Prop.StaticIsPushed:=False;

    GlobalAddSpiritFrame.FAddr:='';
    GlobalAddSpiritFrame.FAddrDetail:='';
  end;

end;

procedure TFrameGetPosition.lvPositionPullUpLoadMore(Sender: TObject);
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
    DoSelectedAddrAddExecute,
    DoSelectedAddrAddExecuteEnd
    );
end;

procedure TFrameGetPosition.Load(ALastSeletedAddr:String;ALastSeletedAddrDetail:String);
var
  AListViewItem:TSkinListViewItem;
begin

  FSelectedAddr:=ALastSeletedAddr;
  FSelectedAddrDetail:=ALastSeletedAddrDetail;

  Self.lvPosition.Prop.Items.ClearItemsByTypeNot(sitItem1);
  if FSelectedAddr<>'' then
  begin
    AListViewItem:=Self.lvPosition.Prop.Items.Add;
    AListViewItem.Caption:=FSelectedAddr;
    AListViewItem.Detail:=FSelectedAddrDetail;
    Self.lvPosition.Prop.Items.FindItemByCaption(FSelectedAddr).Selected:=True;
  end;

  ShowWaitingFrame(Self,'正在获取位置...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoSelectedAddrExecute,
      DoSelectedAddrExecuteEnd,
      '获取附近地址列表',
      True
      );

end;

end.

