//convert pas to utf8 by ¥
unit OrderStateFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  EasyServiceCommonMaterialDataMoudle,
  uTimerTask,
  uManager,
  uDrawCanvas,

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

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinButtonType, uSkinPanelType;

type
  TFrameOrderState = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbOrderState: TSkinFMXListBox;
    idpOrderState: TSkinFMXItemDesignerPanel;
    lblOrdercode: TSkinFMXLabel;
    lblOrderTime: TSkinFMXLabel;
    idpOrderStateList: TSkinFMXItemDesignerPanel;
    imgPic1: TSkinFMXImage;
    imgPic2: TSkinFMXImage;
    imgListPic: TSkinImageList;
    lblName: TSkinFMXLabel;
    lblCreatTime: TSkinFMXLabel;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbOrderStatePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
  private
    FOrderState:String;
    FOrderFID:Integer;
    procedure DoGetOrderStateListExecute(ATimerTask:TObject);
    procedure DoGetOrderStateListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load(AOrder:TOrder);
    constructor Create(AOwner:TComponent);override;
    procedure Clear;
    { Public declarations }
  end;

var
  GlobalOrderStateFrame:TFrameOrderState;

implementation

{$R *.fmx}

{ TFrameOrderState }

procedure TFrameOrderState.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameOrderState.Clear;
begin
  Self.lbOrderState.Prop.Items.FindItemByCaption('订单号').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('下单时间').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('确认收货').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('拒绝发货').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('确认发货').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('等待审核').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('审核通过').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('创建订单').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('已取消').Detail:='';
  FOrderState:='';
end;

constructor TFrameOrderState.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbOrderState.Prop.Items.FindItemByCaption('订单号').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('下单时间').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('确认收货').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('拒绝发货').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('确认发货').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('等待审核').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('审核通过').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('创建订单').Detail:='';
  Self.lbOrderState.Prop.Items.FindItemByCaption('已取消').Detail:='';
  FOrderState:='';


end;

procedure TFrameOrderState.DoGetOrderStateListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_order_state_track_list',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'order_fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FOrderFID//订单FID
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

procedure TFrameOrderState.DoGetOrderStateListExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  AOrderState:String;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FOrderState:=ASuperObject.O['Data'].A['OrderStateTrackList'].O[0].S['order_state'];
        if FOrderState='cancelled' then
        begin
          Self.lbOrderState.Prop.Items.FindItemByCaption('已取消').Visible:=True;
          Self.lbOrderState.Prop.Items.FindItemByCaption('等待审核').Visible:=False;
          Self.lbOrderState.Prop.Items.FindItemByCaption('拒绝发货').Visible:=False;
          Self.lbOrderState.Prop.Items.FindItemByCaption('审核通过').Visible:=False;
          Self.lbOrderState.Prop.Items.FindItemByCaption('确认收货').Visible:=False;
          Self.lbOrderState.Prop.Items.FindItemByCaption('确认发货').Visible:=False;
        end
        else
        begin
          if FOrderState='wait_pay' then
          begin
            Self.lbOrderState.Prop.Items.FindItemByCaption('已取消').Visible:=False;
            Self.lbOrderState.Prop.Items.FindItemByCaption('拒绝发货').Visible:=False;
          end
          else
          begin
            Self.lbOrderState.Prop.Items.FindItemByCaption('已取消').Visible:=False;
            if FOrderState='audit_reject' then
            begin
              Self.lbOrderState.Prop.Items.FindItemByCaption('确认收货').Visible:=False;
              Self.lbOrderState.Prop.Items.FindItemByCaption('确认发货').Visible:=False;
              Self.lbOrderState.Prop.Items.FindItemByCaption('审核通过').Visible:=False;
              Self.lbOrderState.Prop.Items.FindItemByCaption('拒绝发货').Visible:=True;
            end
            else
            begin
              Self.lbOrderState.Prop.Items.FindItemByCaption('审核通过').Visible:=True;
              Self.lbOrderState.Prop.Items.FindItemByCaption('确认收货').Visible:=True;
              Self.lbOrderState.Prop.Items.FindItemByCaption('确认发货').Visible:=True;
              Self.lbOrderState.Prop.Items.FindItemByCaption('拒绝发货').Visible:=False;
            end;


          end;

          Self.lbOrderState.Prop.Items.FindItemByCaption('等待审核').Visible:=True;




        end;
        for I := 0 to ASuperObject.O['Data'].A['OrderStateTrackList'].Length-1  do
        begin
          AOrderState:=ASuperObject.O['Data'].A['OrderStateTrackList'].O[I].S['order_state'];
          Self.lbOrderState.Prop.Items.FindItemByName(AOrderState).Detail:=
                      ASuperObject.O['Data'].A['OrderStateTrackList'].O[I].S['createtime'];
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

  end;
end;

procedure TFrameOrderState.lbOrderStatePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Name=FOrderState then
  begin

    Self.lblName.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
    Self.lblCreatTime.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
    AItem.Pic.ImageIndex:=0;
  end
  else
  begin
    if AItem.Detail<>'' then
    begin
    Self.lblName.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
    Self.lblCreatTime.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
    AItem.Pic.ImageIndex:=1;
    end
    else
    begin
      Self.lblName.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
      Self.lblCreatTime.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
      AItem.Pic.ImageIndex:=1;
    end;
  end;




end;

procedure TFrameOrderState.Load(AOrder: TOrder);
begin
  FOrderFID:=AOrder.fid;
  Self.lbOrderState.Prop.Items.FindItemByCaption('订单号').Detail:=AOrder.bill_code;
  Self.lbOrderState.Prop.Items.FindItemByCaption('下单时间').Detail:=AOrder.createtime;

  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                         DoGetOrderStateListExecute,
                                         DoGetOrderStateListExecuteEnd);
end;

end.
