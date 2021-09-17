unit ProcessTaskOrderListFrame;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uComponentType,
  uFuncCommon,
  uUIFunction,
  uFrameContext,
  uFileCommon,
  uBaseHttpControl,
  uGetDeviceInfo,

  Math,
//  uManager,
  uTimerTask,
  uDrawCanvas,
  uRestInterfaceCall,
//  ClientModuleUnit1,
  uSkinItemJsonHelper,
  WaitingFrame,
  MessageBoxFrame,
//  SettingFrame,
  PopupMenuFrame,
//  YieldTaskOrderInfoFrame,
//  SelectFilterFrame,
  uOpenCommon,
  uOpenClientCommon,
  ListItemStyleFrame_ProcessTaskOrder,
//  ListItemStyleFrame_FinishedProcessTask,
  ListItemStyleFrame_Page,
//  ProcessTaskOrderInfoFrame,
  ListItemStyleListFrame,
  HintFrame,

  HZSpell,

  FMX.Platform,

  XSuperObject,
  XSuperJson,

  uBaseList,
  uSkinItems,
  uSkinListBoxType,
  uSkinListViewType,

  uPageStructure,

  EasyServiceCommonMaterialDataMoudle,
//  CarRepairCommonMaterialDataMoudle,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uSkinFireMonkeyButton, uSkinFireMonkeyLabel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyListView,
  uSkinFireMonkeyImage, uSkinFireMonkeyPanel, uSkinFireMonkeyMultiColorLabel,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyNotifyNumberIcon,
  uSkinFireMonkeyCheckBox, uSkinMaterial, uSkinButtonType,
  uSkinFireMonkeyCustomList, uSkinNotifyNumberIconType, uSkinCheckBoxType,
  uSkinMultiColorLabelType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinPanelType, uSkinPageControlType,
  uSkinSwitchPageListPanelType, uSkinFireMonkeyPageControl,
  uSkinScrollBoxContentType, uSkinFireMonkeyScrollBoxContent,
  uSkinScrollBoxType, uSkinFireMonkeyScrollBox, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, FMX.Objects, FMX.Layouts, FMX.ListBox,
  uSkinFireMonkeyComboBox, uDrawPicture, uSkinImageList, uSkinEditType,
  uTimerTaskEvent, FMX.DateTimeCtrls, uSkinCommonFrames;



type
  TFrameProcessTaskOrderList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lvOrderList: TSkinFMXListView;
    idtDefault: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    lblItemCarPlateNumber: TSkinFMXLabel;
    lblItemContactsName: TSkinFMXLabel;
    lblItemCarType: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    lblItemContactsPhone: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXLabel8: TSkinFMXLabel;
    btnButton1: TSkinFMXButton;
    tteGetProcessTaskOrderList: TTimerTaskEvent;
    lblItemSumMoney: TSkinFMXMultiColorLabel;
    lblItemCreateTime: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    lblItemOrderState: TSkinFMXLabel;
    SkinFMXLabel7: TSkinFMXLabel;
    SkinFMXLabel9: TSkinFMXLabel;
    pnlFilter: TSkinFMXPanel;
    edtFilter: TSkinFMXEdit;
    msgboxCheckProcessTaskOrder: TSkinMessageBox;
    tteCompleteProcessTaskOrder: TTimerTaskEvent;
    idtDefault1: TSkinFMXItemDesignerPanel;
    SkinFMXLabel10: TSkinFMXLabel;
    SkinFMXLabel11: TSkinFMXLabel;
    SkinFMXLabel12: TSkinFMXLabel;
    SkinFMXLabel13: TSkinFMXLabel;
    SkinFMXLabel14: TSkinFMXLabel;
    SkinFMXLabel15: TSkinFMXLabel;
    SkinFMXLabel16: TSkinFMXLabel;
    SkinFMXLabel17: TSkinFMXLabel;
    SkinFMXLabel18: TSkinFMXLabel;
    SkinFMXLabel19: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
    SkinFMXLabel20: TSkinFMXLabel;
    SkinFMXLabel21: TSkinFMXLabel;
    SkinFMXLabel22: TSkinFMXLabel;
    SkinFMXLabel23: TSkinFMXLabel;
    SkinFMXLabel24: TSkinFMXLabel;
    btnButton2: TSkinFMXButton;
    SkinFMXButton2: TSkinFMXButton;
    lbOrderState: TSkinFMXListBox;
    ClearEditButton1: TClearEditButton;
    btnBatchEdit: TSkinFMXButton;
    btnBatchCancel: TSkinFMXButton;
    pnlBottom: TSkinFMXPanel;
    btnBatchOK: TSkinFMXButton;
    btnDel: TSkinFMXButton;
    chkSelectedAllItem: TSkinFMXCheckBox;
    btnFilter: TSkinFMXButton;
    btnSelectListItemStyle: TSkinFMXButton;
    procedure tteGetProcessTaskOrderListExecute(Sender: TTimerTask);
    procedure tteGetProcessTaskOrderListExecuteEnd(Sender: TTimerTask);
    procedure btnReturnClick(Sender: TObject);
    procedure lvOrderListPullDownRefresh(Sender: TObject);
    procedure lvOrderListPullUpLoadMore(Sender: TObject);
    procedure lbOrderStateClickItem(AItem: TSkinItem);
    procedure lvOrderListClickItem(AItem: TSkinItem);
    procedure edtFilterChange(Sender: TObject);
    procedure edtFilterChangeTracking(Sender: TObject);
    procedure msgboxCheckProcessTaskOrderCanModalResult(Sender: TObject;
                                  AModalResult:String;
                                  AModalResultName:String;
                                  var AIsCanModalResult: Boolean);
    procedure msgboxCheckProcessTaskOrderModalResult(Sender: TObject);
    procedure tteCompleteProcessTaskOrderBegin(ATimerTask: TTimerTask);
    procedure tteCompleteProcessTaskOrderExecute(ATimerTask: TTimerTask);
    procedure tteCompleteProcessTaskOrderExecuteEnd(ATimerTask: TTimerTask);
    procedure lvOrderListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure lvOrderListClickItemDesignerPanelChild(Sender: TObject;
      AItem: TBaseSkinItem; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AChild: TFmxObject);
    procedure btnBatchEditClick(Sender: TObject);
    procedure btnBatchOKClick(Sender: TObject);
    procedure chkSelectedAllItemClick(Sender: TObject);
    procedure btnBatchCancelClick(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure btnSelectListItemStyleClick(Sender: TObject);
  private
    FPageIndex:Integer;
//    FFrameUseType:TFrameUseType;
    FItemButtonCaption:String;

    //显示指定车辆的维修历史
    FFilterIsFinished:String;
    FFilterFinishedStartDate:String;
    FFilterFinishedEndDate:String;

    FFilterStartDate:String;
    FFilterEndDate:String;


    FProcessTaskOrderListItemStyle:String;

    //包含验收员和验收日期,维修单号
    //FCompleteJson:ISuperObject;

    procedure Clear;

//    //派工返回
//    procedure DoReturnFrameFromDispatchWork(AFrame:TFrame);
//
//    //领料返回
//    procedure DoReturnFrameFromPickMaterial(AFrame:TFrame);

    //选择过滤条件
    procedure DoReturnFrameFromSelectFilterFrame(AFrame:TFrame);
    procedure DoReturnFrameFromSelectListItemStyle(AFrame:TFrame);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FUserFID:String;
    FilterOrderState:String;
    //FListItemStyle:String;
    //FListItemStylePage:TPage;
    procedure Load(ACaption:String;
                    //页面使用的类型
                    //AFrameUseType:TFrameUseType;
                    //按钮
                    //AItemButtonCaption:String;
                    //某辆车的维修历史
                    AFilterIsFinished:String;
                    AFilterFinishedStartDate:String;
                    AFilterFinishedEndDate:String;
                    AFilterStartDate:String;
                    AFilterEndDate:String
                    );
    { Public declarations }
  end;


var
  GlobalProcessTaskOrderListFrame:TFrameProcessTaskOrderList;
//  //待派工单列表
//  GlobalWaitDispatchOrderListFrame:TFrameProcessTaskOrderList;
//  //待领料工单列表
//  GlobalWaitPickOrderListFrame:TFrameProcessTaskOrderList;
//  //待验收工单列表
//  GlobalWaitCheckOrderListFrame:TFrameProcessTaskOrderList;
//  //车辆维修历史列表
//  GlobalCarRepairHistoryOrderListFrame:TFrameProcessTaskOrderList;


implementation


//uses
//  MainForm,
//  CheckProcessTaskOrderFrame,
//  PickMaterialFrame,
//  DispatchWorkFrame
//  ;

{$R *.fmx}

procedure TFrameProcessTaskOrderList.btnBatchCancelClick(Sender: TObject);
var
  I: Integer;
begin
  Self.btnBatchEdit.Visible:=True;
  Self.btnBatchCancel.Visible:=False;
  pnlBottom.Visible:=False;

  Self.lvOrderList.Prop.MultiSelect:=False;

  //先全部取消全选
  Self.lvOrderList.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lvOrderList.Prop.Items.Count-1 do
    begin
      Self.lvOrderList.Prop.Items[I].Selected:=False;
      Self.lvOrderList.Prop.Items[I].IsBufferNeedChange:=True;
    end;
  finally
    Self.lvOrderList.Prop.Items.EndUpdate;
  end;
end;

procedure TFrameProcessTaskOrderList.btnBatchEditClick(Sender: TObject);
var
  I: Integer;
begin
  Self.btnBatchEdit.Visible:=False;
  Self.btnBatchCancel.Visible:=True;
  pnlBottom.Visible:=True;



  Self.lvOrderList.Prop.MultiSelect:=True;


  //先全部取消全选
  Self.lvOrderList.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lvOrderList.Prop.Items.Count-1 do
    begin
      Self.lvOrderList.Prop.Items[I].Selected:=False;
      Self.lvOrderList.Prop.Items[I].IsBufferNeedChange:=True;
    end;
  finally
    Self.lvOrderList.Prop.Items.EndUpdate;
  end;



//  //编辑、取消共用按钮
//  if Self.btnEdit.Caption='编辑' then
//  begin
//    if Self.lvOrderList.Prop.Items.Count>0 then
//    begin
//       Self.btnEdit.Caption:='完成';
//
//      Self.pnlBottom.Visible:=True;
//      Self.btnSetAllRead.Enabled:=True;
//      //编辑状态显示选中框
//      Self.chkOrderItemSelected.Visible:=True;
//    end;
//  end
//  else
//  begin
//    Self.btnEdit.Caption:='编辑';
//
//    Self.pnlBottom.Visible:=False;
//    Self.chkSelectedAllItem.Prop.Checked:=False;
//    Self.btnDel.Enabled:=False;
//
//    //非编辑状态不显示选中框
//    Self.chkOrderItemSelected.Visible:=False;
//
//    //恢复为未选中
//    for I := 0 to Self.lvOrderList.Prop.Items.Count-1 do
//    begin
//      if Self.lvOrderList.Prop.Items.Items[I].Checked then
//      begin
//        Self.lvOrderList.Prop.Items.Items[I].Checked:=False;
//      end;
//    end;
//  end;


end;

procedure TFrameProcessTaskOrderList.btnBatchOKClick(Sender: TObject);
var
  I:Integer;
  AHasData:Boolean;
begin
  Self.btnBatchEdit.Visible:=True;
  Self.btnBatchCancel.Visible:=False;


  Self.lvOrderList.Prop.MultiSelect:=False;


  AHasData:=False;
  Self.lvOrderList.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lvOrderList.Prop.Items.Count-1 do
    begin
      Self.lvOrderList.Prop.Items[I].IsBufferNeedChange:=True;
      if Self.lvOrderList.Prop.Items[I].Selected then
      begin
        AHasData:=True;
        Break;
      end;
    end;
  finally
    Self.lvOrderList.Prop.Items.EndUpdate;
  end;


  if AHasData then
  begin
    Self.tteCompleteProcessTaskOrder.Run;
  end;


end;

procedure TFrameProcessTaskOrderList.btnFilterClick(Sender: TObject);
begin
//  //搜索
//  HideFrame;
//  ShowFrame(TFrame(GlobalSelectFilterFrame),TFrameSelectFilter,DoReturnFrameFromSelectFilterFrame);
//
//  if Self.FFilterIsFinished='1' then
//  begin
//    //完成日期
//    GlobalSelectFilterFrame.Load(
//                                Self.FFilterFinishedStartDate,
//                                FFilterFinishedEndDate,
//                                ''
//                                );
//    GlobalSelectFilterFrame.pnlToolBar.Caption:='选择完成日期';
//
//  end
//  else
//  begin
//    //未完成
//    //日期
//    GlobalSelectFilterFrame.Load(
//                                FFilterStartDate,
//                                FFilterEndDate,
//                                ''
//                                );
//
//    GlobalSelectFilterFrame.pnlToolBar.Caption:='选择日期';
//  end;

end;

procedure TFrameProcessTaskOrderList.btnReturnClick(Sender: TObject);
begin
  HideFrame(Self);
  ReturnFrame(Self);
end;

procedure TFrameProcessTaskOrderList.btnSelectListItemStyleClick(
  Sender: TObject);
begin
  HideFrame;
  ShowFrame(TFrame(GlobalListItemStyleListFrame),TFrameListItemStyleList,DoReturnFrameFromSelectListItemStyle);
  //把样式列表放在网站上的pages.json，会展示出来
  GlobalListItemStyleListFrame.Load('http://www.orangeui.cn/list_item_style/door_manage/'+'ProcessTaskOrderList/',FProcessTaskOrderListItemStyle);
end;

procedure TFrameProcessTaskOrderList.chkSelectedAllItemClick(Sender: TObject);
begin
  //全选/全不选
  if Self.lvOrderList.Prop.Items.Count>0 then
  begin


      //编辑状态
      //全选/全不选
      if Not Self.lvOrderList.Prop.Items.IsSelectedAll then
      begin
        Self.lvOrderList.Prop.Items.SelectAll;
      end
      else
      begin
        Self.lvOrderList.Prop.Items.UnSelectAll;
      end;

      Self.chkSelectedAllItem.Prop.Checked:=
        (Self.lvOrderList.Prop.Items.Count>0)
        and Self.lvOrderList.Prop.Items.IsSelectedAll;

  //    //全选按钮状态与删除按钮状态同步
  //    if Self.chkSelectedAllItem.Prop.Checked then
  //    begin
  //      Self.btnDel.Enabled:=True;
  //    end
  //    else
  //    begin
  //      Self.btnDel.Enabled:=False;
  //    end;

  end
  else
  begin

  end;

end;

procedure TFrameProcessTaskOrderList.Clear;
begin

  Self.lvOrderList.Prop.Items.BeginUpdate;
  try
    Self.lvOrderList.Prop.Items.Clear();
  finally
    Self.lvOrderList.Prop.Items.EndUpdate;
  end;



end;

constructor TFrameProcessTaskOrderList.Create(AOwner: TComponent);
begin
  inherited;

//  if Not IsPadDevice then
//  begin
//    Self.lvOrderList.Properties.ItemDesignerPanel:=Self.idtDefault1;
//    Self.lvOrderList.Properties.ItemHeight:=131;
//  end
//  else
//  begin
//    Self.lvOrderList.Properties.ItemDesignerPanel:=Self.idtDefault;
//    Self.lvOrderList.Properties.ItemHeight:=90;
//  end;


  Self.lvOrderList.Prop.Items.BeginUpdate;
  try
    Self.lvOrderList.Prop.Items.Clear();
  finally
    Self.lvOrderList.Prop.Items.EndUpdate;
  end;


  pnlBottom.Visible:=False;

//  FListItemStylePage:=TPage.Create(nil);

//  FilterOrderState:='(''待派'',''已派工'')';

end;

destructor TFrameProcessTaskOrderList.Destroy;
begin
//  FreeAndNil(FListItemStylePage);

  inherited;
end;

//procedure TFrameProcessTaskOrderList.DoReturnFrameFromDispatchWork(AFrame: TFrame);
//begin
//  //刷新
//  Self.lvOrderList.Prop.StartPullDownRefresh;
//
//  //派工之后还要领料,不需要删除
////  //派工成功,返回
////  Self.lvOrderList.Prop.Items.Remove(Self.lvOrderList.Prop.InteractiveItem);
//end;
//
//procedure TFrameProcessTaskOrderList.DoReturnFrameFromPickMaterial(AFrame: TFrame);
//begin
//  //刷新
//  Self.lvOrderList.Prop.StartPullDownRefresh;
//
//
//  //领料成功,返回
//  //Self.lvOrderList.Prop.Items.Remove(Self.lvOrderList.Prop.InteractiveItem);
//end;

procedure TFrameProcessTaskOrderList.DoReturnFrameFromSelectFilterFrame(
  AFrame: TFrame);
begin
  //
//  GlobalSelectFilterFrame//


//  if Self.FFilterIsFinished='1' then
//  begin
//    //完成日期
//    FFilterFinishedStartDate:=GlobalSelectFilterFrame.FStartDate;
//    FFilterFinishedEndDate:=GlobalSelectFilterFrame.FEndDate;
//
//  end
//  else
//  begin
//    //未完成
//    //日期
//    FFilterStartDate:=GlobalSelectFilterFrame.FStartDate;
//    FFilterEndDate:=GlobalSelectFilterFrame.FEndDate;
//
//  end;
//
//  Self.tteGetProcessTaskOrderList.Run();

end;

procedure TFrameProcessTaskOrderList.DoReturnFrameFromSelectListItemStyle(
  AFrame: TFrame);
begin
  FProcessTaskOrderListItemStyle:=TFrameListItemStyleList(AFrame).lvData.Prop.SelectedItem.Detail;

  if FProcessTaskOrderListItemStyle='' then
  begin
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FStyleRootUrl:='http://www.orangeui.cn/list_item_style/door_manage/ProcessTaskOrderList/';
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FStyle:='ProcessTaskOrder';
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FIsUseUrlStyle:=False;
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.ResetStyle;

  end
  else
  begin
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FStyleRootUrl:='http://www.orangeui.cn/list_item_style/door_manage/ProcessTaskOrderList/';
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FStyle:=FProcessTaskOrderListItemStyle;
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FIsUseUrlStyle:=True;
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.ResetStyle;
  end;

  //刷新列表
//  Self.FListItemStylePage.fid:=0;
  Self.lvOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameProcessTaskOrderList.edtFilterChange(Sender: TObject);
begin
  //输入跟踪事件,重新过滤
  FPageIndex:=1;
  Self.tteGetProcessTaskOrderList.Run;
end;

procedure TFrameProcessTaskOrderList.edtFilterChangeTracking(Sender: TObject);
begin
  //输入跟踪事件,重新过滤
  FPageIndex:=1;
  Self.tteGetProcessTaskOrderList.Run;
end;

procedure TFrameProcessTaskOrderList.lbOrderStateClickItem(AItem: TSkinItem);
begin
  FilterOrderState:=AItem.Name;
  Self.lvOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameProcessTaskOrderList.Load(
                                          ACaption:String;
                                          //AFrameUseType:TFrameUseType;
                                          //AItemButtonCaption:String;
                                          //AFilterCar:String
                                          AFilterIsFinished:String;
                                          AFilterFinishedStartDate:String;
                                          AFilterFinishedEndDate:String;
                                          AFilterStartDate:String;
                                          AFilterEndDate:String
                                          );
var
  ADesc:String;
begin

  Clear;

//  FFrameUseType:=AFrameUseType;


  FUserFID:='003';//GlobalManager.User.fid;



  Self.pnlToolbar.Caption:=ACaption;

  FItemButtonCaption:='表面配置';//GlobalManager.EmployeeJson.S['岗位'];//AItemButtonCaption;


//  FFilterIsFinished:=AFilterCar;
  FFilterIsFinished:=AFilterIsFinished;
  FFilterFinishedStartDate:=AFilterFinishedStartDate;
  FFilterFinishedEndDate:=AFilterFinishedEndDate;

  FFilterStartDate:=AFilterStartDate;
  FFilterEndDate:=AFilterEndDate;



//  case FFrameUseType of
//    futManage:
//    begin
//      Self.btnReturn.Visible:=False;
//      Self.lbOrderState.Visible:=True;
//    end;
//    futSelectList:
//    begin
//      Self.btnReturn.Visible:=True;
//      Self.lbOrderState.Visible:=False;
//
//    end;
//    futViewList:
//    begin
//      Self.btnReturn.Visible:=True;
//      Self.lbOrderState.Visible:=False;
//    end;
//  end;


  if FProcessTaskOrderListItemStyle<>'' then
  begin
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FStyleRootUrl:='http://www.orangeui.cn/list_item_style/door_manage/ProcessTaskOrderList/';
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FStyle:=FProcessTaskOrderListItemStyle;
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.FIsUseUrlStyle:=True;
    Self.lvOrderList.Prop.FDefaultItemStyleSetting.ResetStyle;
  end;


  //加载
  Self.lvOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameProcessTaskOrderList.lvOrderListClickItem(AItem: TSkinItem);
//var
//  AWaitPostProcessTaskOrder:ISuperObject;
begin
//  AWaitPostProcessTaskOrder:=TSuperObject.Create(Self.lvOrderList.Prop.InteractiveItem.DataJsonStr);

//  if Self.btnBatchEdit.Visible then
//  begin
//      //非批处理模式
//
//      //显示工单详情
//      HideFrame;
//      ShowFrame(TFrame(GlobalYieldTaskOrderInfoFrame),TFrameYieldTaskOrderInfo);
//      GlobalYieldTaskOrderInfoFrame.Load(AItem.Json);
//
//  end
//  else
//  begin
//      //
//
//
//  end;


end;

procedure TFrameProcessTaskOrderList.lvOrderListClickItemDesignerPanelChild(
  Sender: TObject; AItem: TBaseSkinItem;
  AItemDesignerPanel: TSkinFMXItemDesignerPanel; AChild: TFmxObject);
var
  AWaitPostProcessTaskOrder:ISuperObject;
  ASenderButton:TSkinFMXButton;
begin
  if AChild.Name='btnComplete' then
  begin
      //完成工序任务

      Self.lvOrderList.Prop.InteractiveItem.Selected:=True;
      AWaitPostProcessTaskOrder:=Self.lvOrderList.Prop.InteractiveItem.Json;
      ASenderButton:=TSkinFMXButton(AChild);



    //  if ASenderButton.Caption='查看' then
    //  begin
    //    //显示工单详情
    //    HideFrame(CurrentFrame);
    //    ShowFrame(TFrame(GlobalProcessTaskOrderInfoFrame),TFrameProcessTaskOrderInfo);
    //    GlobalProcessTaskOrderInfoFrame.Clear;
    //    GlobalProcessTaskOrderInfoFrame.Load(AWaitPostProcessTaskOrder);
    //  end;
    //
    //  if ASenderButton.Caption='派工' then
    //  begin
    //      //在待派工单列表中选择某一单
    //      HideFrame(CurrentFrame);
    //      ShowFrame(TFrame(GlobalDispatchWorkFrame),TFrameDispatchWork,DoReturnFrameFromDispatchWork);
    //      GlobalDispatchWorkFrame.Clear;
    //      GlobalDispatchWorkFrame.Load(AWaitPostProcessTaskOrder);
    //  end;
    //
    //  if ASenderButton.Caption='领料' then
    //  begin
    //      //在待领料单列表中选择某一单
    //      HideFrame(CurrentFrame);
    //      ShowFrame(TFrame(GlobalPickMaterialFrame),TFramePickMaterial,DoReturnFrameFromPickMaterial);
    //      GlobalPickMaterialFrame.Clear;
    //      GlobalPickMaterialFrame.Load(AWaitPostProcessTaskOrder);
    //  end;

//      if ASenderButton.Caption='完成' then
//      begin



//          Self.tteCompleteProcessTaskOrder.Run;

//          //在待验收单列表中选择某一单
//          //显示修改维修项目的对话框
//          if GlobalCheckProcessTaskOrderFrame=nil then
//          begin
//            GlobalCheckProcessTaskOrderFrame:=TFrameCheckProcessTaskOrder.Create(Application);
//            GlobalCheckProcessTaskOrderFrame.pnlToolBar.Visible:=False;
//          end;
//          GlobalCheckProcessTaskOrderFrame.Clear;
//          GlobalCheckProcessTaskOrderFrame.Height:=GlobalCheckProcessTaskOrderFrame.sbcClient.Height;
//
//          //加载数据
//          GlobalCheckProcessTaskOrderFrame.LoadFromJson(AWaitPostProcessTaskOrder);
//
//          msgboxCheckProcessTaskOrder.CustomControl:=GlobalCheckProcessTaskOrderFrame;

//          msgboxCheckProcessTaskOrder.Msg:='确认完成'+GlobalManager.EmployeeJson.S['岗位']+'吗?';
//          msgboxCheckProcessTaskOrder.ShowMessageBox;

      Self.tteCompleteProcessTaskOrder.Run;

//      end;

  end;
end;

procedure TFrameProcessTaskOrderList.lvOrderListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  btnComplete:TSkinButton;
  imgError:TSkinImage;
  chkItemSelected:TSkinCheckBox;
  labErrorHint:TSkinLabel;
  lblBillNO:TSkinLabel;
begin
    if AItemDesignerPanel=nil then
    begin
      Exit;
    end;

//  if AItemDesignerPanel.Parent is TFrameListItemStyle_ProcessTaskOrder then
//  begin

    btnComplete:=TSkinButton(AItemDesignerPanel.Parent.FindComponent('btnComplete'));
    imgError:=TSkinImage(AItemDesignerPanel.Parent.FindComponent('imgError'));
    chkItemSelected:=TSkinCheckBox(AItemDesignerPanel.Parent.FindComponent('chkItemSelected'));
    labErrorHint:=TSkinLabel(AItemDesignerPanel.Parent.FindComponent('labErrorHint'));
    lblBillNO:=TSkinLabel(AItemDesignerPanel.Parent.FindComponent('lblBillNO'));


    if btnComplete<>nil then
    begin
      btnComplete.Caption:=FItemButtonCaption;
      btnComplete.Visible:=(btnBatchEdit.Visible and not AItem.Json.B['完成否']);
    end;

    if AItem.Json.S['ifError'] = '1' then
    begin
      if lblBillNO<>nil then
      begin
        lblBillNO.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
        lblBillNO.Material.DrawCaptionParam.FontStyle:=[TFontStyle.fsBold];
      end;
    end
    else
    begin
      if lblBillNO<>nil then
      begin
        lblBillNO.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
        lblBillNO.Material.DrawCaptionParam.FontStyle:=[];
      end;
    end;
    if imgError<>nil then imgError.Visible:=AItem.Json.S['ifError'] = '1';
    if labErrorHint<>nil then labErrorHint.Visible:=AItem.Json.S['ifError'] = '1';

//    if chkItemSelected<>nil then chkItemSelected.Visible:=not btnBatchEdit.Visible;





    //      //编辑状态显示选中框
  //      Self.chkOrderItemSelected.Visible:=True;

  //  Self.btnButton1.Visible:=False;
  //  Self.SkinFMXButton1.Visible:=False;
  //
  //  Self.btnButton2.Visible:=False;
  //  Self.SkinFMXButton2.Visible:=False;
  //
  //  if AItem.Detail5='待派' then
  //  begin
  //    Self.btnButton1.Caption:='派工';
  //    Self.SkinFMXButton1.Caption:='派工';
  //
  //    Self.btnButton1.Visible:=True;
  //    Self.SkinFMXButton1.Visible:=True;
  //
  //
  //    SkinFMXLabel22.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Orange;
  //    lblItemOrderState.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Orange;
  //  end
  //  else
  //  if AItem.Detail5='已派工' then
  //  begin
  //
  //    Self.btnButton2.Caption:='领料';
  //    Self.SkinFMXButton2.Caption:='领料';
  //
  //    Self.btnButton2.Visible:=True;
  //    Self.SkinFMXButton2.Visible:=True;
  //
  //
  //    Self.btnButton1.Caption:='验收';
  //    Self.SkinFMXButton1.Caption:='验收';
  //
  //    Self.btnButton1.Visible:=True;
  //    Self.SkinFMXButton1.Visible:=True;
  //
  //
  //    SkinFMXLabel22.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
  //    lblItemOrderState.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
  //  end
  //  else
  //  begin
  //
  //    SkinFMXLabel22.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Blue;
  //    lblItemOrderState.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Blue;
  //  end;


//  end;

end;

procedure TFrameProcessTaskOrderList.lvOrderListPullDownRefresh(
  Sender: TObject);
begin
  FPageIndex:=1;
  Self.tteGetProcessTaskOrderList.Run;
end;

procedure TFrameProcessTaskOrderList.lvOrderListPullUpLoadMore(
  Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  Self.tteGetProcessTaskOrderList.Run;
end;

procedure TFrameProcessTaskOrderList.msgboxCheckProcessTaskOrderCanModalResult(
  Sender: TObject;
  AModalResult:String;
  AModalResultName:String;
  var AIsCanModalResult: Boolean);
begin
//  //是否可以关闭对话框
//  if SameText(TFrameMessageBox(Sender).ModalResultName,'ok') then
//  begin
//    //检查参数
//    if not GlobalCheckProcessTaskOrderFrame.Check then
//    begin
//      //检查不通过,不关闭对话框
//      AIsCanModalResult:=False;
//    end
//    else
//    begin
//      //检查通过,可以关闭对话框了
//    end;
//  end;
end;

procedure TFrameProcessTaskOrderList.msgboxCheckProcessTaskOrderModalResult(
  Sender: TObject);
begin
  //关闭了对话框
  if SameText(TFrameMessageBox(Sender).ModalResultName,'ok') then
  begin
    //调用验收接口
    //Self.FCompleteJson:=GlobalCheckProcessTaskOrderFrame.SaveToJson;
    Self.tteCompleteProcessTaskOrder.Run;
  end;
end;

procedure TFrameProcessTaskOrderList.tteCompleteProcessTaskOrderBegin(
  ATimerTask: TTimerTask);
begin
  //
  ShowWaitingFrame(Self,'保存中...');
end;

procedure TFrameProcessTaskOrderList.tteCompleteProcessTaskOrderExecute(
  ATimerTask: TTimerTask);
var
  I: Integer;
  ASuperObject:ISuperObject;
  ASuperArray:ISuperArray;
  APostStream:TStringStream;
begin
  try
    ATimerTask.TaskTag:=TASK_FAIL;

    ASuperArray:=TSuperArray.Create();
    for I := 0 to Self.lvOrderList.Prop.Items.Count-1 do
    begin
      if Self.lvOrderList.Prop.Items[I].Selected then
      begin
        ASuperObject:=TSuperObject.Create();
        ASuperObject.S['bill_no']:=Self.lvOrderList.Prop.Items[I].Json.S['单据编码'];
        ASuperObject.I['number']:=Self.lvOrderList.Prop.Items[I].Json.I['数量'];
        ASuperArray.O[ASuperArray.Length]:=ASuperObject;
      end;

    end;


//    TTimerTask(ATimerTask).TaskDesc:=
//        SimpleCallAPIPostString('arrange_yieldtask_bill',
//                      nil,
//                      DoorManageInterfaceUrl,
//                      ['appid','user_fid','key',
//                      'bill_no',
//                      'action'],
//                      [AppID,
//                      GlobalManager.User.fid,
//                      '',
//                      '1RW-21-2-01',
//                      'new'
//                      ],
//                      GlobalRestAPISignType,
//                      GlobalRestAPIAppSecret
//                      );



//    TTimerTask(ATimerTask).TaskDesc:=
//        SimpleCallAPIPostString('batch_complete_process_task',
//                      nil,
//                      DoorManageInterfaceUrl,
//                      ['appid','user_fid','key',
//                      //'bill_no',
//                      'process',
//                      //'number',
//                      'remark','pic1_path'],
//                      [AppID,
//                      FUserFID,
//                      '',
//
//                      //生产任务单号
//                      //Self.lvOrderList.Prop.InteractiveItem.Json.S['单据编码'],
//                      '表面配置',//GlobalManager.EmployeeJson.S['岗位'],
//                      //Self.lvOrderList.Prop.InteractiveItem.Json.I['数量'],
//                      '',
//                      ''
//                      ],
//                      GlobalRestAPISignType,
//                      GlobalRestAPIAppSecret,
//                      True,
//                      ASuperArray.AsJSON
//                      );





      TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;


  except
    on E:Exception do
    begin
      ATimerTask.TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameProcessTaskOrderList.tteCompleteProcessTaskOrderExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASkinItem:TSkinItem;
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        ShowHintFrame(Self,'保存成功!');


        Self.lvOrderList.Prop.Items.BeginUpdate;
        try
          for I := Self.lvOrderList.Prop.Items.Count-1 downto 0 do
          begin
            if Self.lvOrderList.Prop.Items[I].Selected then
            begin
              Self.lvOrderList.Prop.Items.Remove(Self.lvOrderList.Prop.Items[I]);
            end;
          end;
        finally
          Self.lvOrderList.Prop.Items.EndUpdate();
        end;


//        //找到该工单,然后删除
//        ASkinItem:=Self.lvOrderList.Prop.Items.FindItemByDetail6(
//            Self.FCompleteJson.S['维修单号']);
//
//        if ASkinItem<>nil then
//        begin
//          Self.lvOrderList.Prop.Items.Remove(ASkinItem);
//        end;

//        HideFrame(Self);
//        ReturnFrame(Self);

      end
      else
      begin
        //验收失败
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

procedure TFrameProcessTaskOrderList.tteGetProcessTaskOrderListExecute(
  Sender: TTimerTask);
var
  ADesc:String;
  AIsUsedCache:Boolean;
begin

  try
      //出错
      TTimerTask(Sender).TaskTag:=1;



//      //获取样式页面是否存在
//      //或者可以让用户选择样式即可
//      //样式更新怎么办?
//      //获取样式
//      if (FListItemStylePage.fid=0) and (GlobalManager.ProcessTaskOrderListItemStyle<>'') then
//      begin
//          //从接口获取列表项样式
//          if FListItemStylePage.LoadFromServer(CenterInterfaceUrl,
//                                                Const_OpenPlatform_AppID,
//                                                'door_manage_list_item_style',
//                                                '',
//                                                'list_item_style',
//                                                'app',
//                                                GlobalManager.ProcessTaskOrderListItemStyle,
//                                                //'CustomListItemStyle_ProcessTaskOrder',
//                                                True,
//                                                ADesc,
//                                                AIsUsedCache
//                                                ) then
//          begin
//              //注册为列表项样式
//              RegisterListItemStyle(//'CustomListItemStyle_ProcessTaskOrder',
//                                    GlobalManager.ProcessTaskOrderListItemStyle,
//                                    TFrameListItemStyle_Page,
//                                    -1,
//                                    True,
//                                    FListItemStylePage
//                                    );
//
//              TThread.Synchronize(nil,procedure
//              begin
//                Self.lvOrderList.Prop.DefaultItemStyle:=GlobalManager.ProcessTaskOrderListItemStyle;
//                          //'CustomListItemStyle_ProcessTaskOrder';
//              end);
//          end;
//      end;





       TTimerTask(Sender).TaskDesc :=SimpleCallAPI('get_yieldtask_process_task_list',
                                                  nil,
                                                  'http://www.orangeui.cn:10050/door_manage/',//DoorManageInterfaceUrl,
                                                  ['appid',
                                                  'user_fid',
                                                  'key',
                                                  'process',
                                                  'pageindex',
                                                  'pagesize',
                                                  'filter_is_finished',
                                                  'filter_finished_start_date',
                                                  'filter_finished_end_date',
                                                  'filter_keyword',
                                                  'filter_start_date',
                                                  'filter_end_date'
                                                  ],
                                                  [1013,//AppID,
                                                  FUserFID,//GlobalManager.User.fid,
                                                  '',//GlobalManager.User.key,
                                                  '表面配置',//GlobalManager.EmployeeJson.S['岗位'],
                                                  FPageIndex,
                                                  20,
                                                  FFilterIsFinished,
                                                  FFilterFinishedStartDate,
                                                  FFilterFinishedEndDate,
                                                  Self.edtFilter.Text,
                                                  FFilterStartDate,
                                                  FFilterEndDate
                                                  ],
                                                  GlobalRestAPISignType,
                                                  GlobalRestAPIAppSecret
                                                  );

    if TTimerTask(Sender).TaskDesc<>'' then
    begin
      TTimerTask(Sender).TaskTag:=TASK_SUCC;
    end;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(Sender).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameProcessTaskOrderList.tteGetProcessTaskOrderListExecuteEnd(
  Sender: TTimerTask);
var
  I: Integer;
  AListViewItem:TJsonSkinItem;
  ASuperObject:ISuperObject;
  AProcessTaskOrder:ISuperObject;
  AListItemStyle:String;
  AListItemStyleReg:TListItemStyleReg;
begin
  try
    if TTimerTask(Sender).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(Sender).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          Self.lvOrderList.Prop.Items.BeginUpdate;
          try
            if FPageIndex=1 then
            begin
              Self.lvOrderList.Prop.Items.ClearItemsByType(sitDefault);
            end;
            for I := 0 to ASuperObject.O['Data'].A['RecordList'].Length-1 do
            begin
              AProcessTaskOrder:=ASuperObject.O['Data'].A['RecordList'].O[I];




              AListViewItem:=TJsonSkinItem.Create;//Self.lvOrderList.Prop.Items.Add;
              Self.lvOrderList.Prop.Items.Add(AListViewItem);
              AListViewItem.Json:=AProcessTaskOrder;


              //AListItemStyle:=lvOrderList.Prop.GetItemStyleByItemType(AListViewItem.ItemType);
              //设置Item的高度
              //AListItemStyleReg:=GlobalListItemStyleRegList.FindItemByName(AListItemStyle);
              AListItemStyleReg:=lvOrderList.Prop.FDefaultItemStyleSetting.FListItemStyleReg;


              if (AListItemStyleReg<>nil)
                and (AListItemStyleReg.DefaultItemHeight<>0)
                and (AListItemStyleReg.DefaultItemHeight<>-1)
                and not AListItemStyleReg.IsAutoSize then
              begin
                AListViewItem.Height:=AListItemStyleReg.DefaultItemHeight;
              end;

              if //AIsAutoSize or
                  (AListItemStyleReg<>nil) and AListItemStyleReg.IsAutoSize then
              begin
                  //设置自动高度
                  AListViewItem.Height:=
                      lvOrderList.Prop.CalcItemAutoSize(AListViewItem).cy;
              end;



//              AListViewItem.Caption:=AProcessTaskOrder.S['车牌号'];
//
//              AListViewItem.Detail:=AProcessTaskOrder.S['车辆品牌']+' '+AProcessTaskOrder.S['车型'];
//
//              AListViewItem.Detail1:=AProcessTaskOrder.S['联系人'];
//              AListViewItem.Detail2:=AProcessTaskOrder.S['联系电话'];
//
//              AListViewItem.Detail3:=Format('%.2f',[AProcessTaskOrder.F['合计费用']]);
//              AListViewItem.Detail4:=AProcessTaskOrder.S['进厂日期'];
//              AListViewItem.Detail5:=AProcessTaskOrder.S['维修进度'];
//              AListViewItem.Detail6:=AProcessTaskOrder.S['维修单号'];
//
//
//              AListViewItem.SubItems.Add(FItemButtonCaption);




//              if AProcessTaskOrder.S['维修进度']='待派' then
//              begin
//                AListViewItem.SubItems.Add('派工');
//              end
//              else if AProcessTaskOrder.S['维修进度']='已派工' then
//              begin
//                AListViewItem.SubItems.Add('领料');
//              end
//              else
//              begin
//                AListViewItem.SubItems.Add('查看');
//              end;

            end;

          finally
            Self.lvOrderList.Prop.Items.EndUpdate();
          end;
      end
      else
      begin
        //获取订单列表失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
//    else if TTimerTask(Sender).TaskTag=2 then
//    begin
//      //图片上传失败
//      ShowMessageBoxFrame(Self,'图片上传失败!','',TMsgDlgType.mtInformation,['确定'],nil);
//    end
    else if TTimerTask(Sender).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(Sender).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;


    if FPageIndex>1 then
    begin
        if (TTimerTask(Sender).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['RecordList'].Length>0) then
        begin
          Self.lvOrderList.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.lvOrderList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
        Self.lvOrderList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;


  end;

end;

end.
