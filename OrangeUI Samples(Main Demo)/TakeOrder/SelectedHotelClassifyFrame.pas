//convert pas to utf8 by ¥
unit SelectedHotelClassifyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,

  uBaseHttpControl,XSuperObject,uTimerTask,EasyServiceCommonMaterialDataMoudle,
  uInterfaceClass,uManager,WaitingFrame,uSkinBufferBitmap,HzSpell,
  MessageBoxFrame,uSkinListViewType,uSkinItems,

  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, FMX.Edit,
  FMX.Controls.Presentation, uSkinFireMonkeyEdit, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameSelectedHotelClassify = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnAdd: TSkinFMXButton;
    pnlSearchBar: TSkinFMXPanel;
    edtFilter: TSkinFMXEdit;
    btnClearFilter: TClearEditButton;
    lbList: TSkinFMXListView;
    ItemValue: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    idpDelete: TSkinFMXItemDesignerPanel;
    btnDel: TSkinFMXButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbListClickItem(AItem: TSkinItem);
    procedure btnDelClick(Sender: TObject);
  private
    //酒店类型列表
    FHotelClassifyList:THotelClassifyList;

    FNeedAddHotelClassifyName:String;
    FNeedUpdateHotelClassifyName:String;

    FNeedDelHotelClassifyFid:Integer;

    //获取酒店分类列表
    procedure DoGetHotelClassifylistExecute(ATimerTask:TObject);
    procedure DoGetHotelClassifylistExecuteEnd(ATimerTask:TObject);

    //添加酒店分类列表
    procedure DoAddHotelClassifyExecute(ATimerTask:TObject);
    procedure DoAddHotelClassifyExecuteEnd(ATimerTask:TObject);

    //修改酒店分类列表
    procedure DoUpdateHotelClassifyExecute(ATimerTask:TObject);
    procedure DoUpdateHotelClassifyExecuteEnd(ATimerTask:TObject);

    //删除酒店分类列表
    procedure DoDelHotelClassifyExecute(ATimerTask:TObject);
    procedure DoDelHotelClassifyExecuteEnd(ATimerTask:TObject);

    //从添加酒店分类页面返回
    procedure OnReturnFrameFromAddInputName(Frame:TFrame);
    //从修改酒店分类页面返回
    procedure OnReturnFrameFromUpdateInputName(Frame:TFrame);

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;

    //当前选择的项
    Selected:String;
    //当前选中项的fid
    SelectedFid:Integer;
    ToolBarCaption:String;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;


    procedure Load;

    { Public declarations }
  end;

var
  GlobalSelectedHotelClassifyFrame:TFrameSelectedHotelClassify;

implementation

{$R *.fmx}
uses
  InputNameFrame,
  MainForm,
  MainFrame;

procedure TFrameSelectedHotelClassify.btnAddClick(Sender: TObject);
begin

  HideVirtualKeyboard;
  //隐藏
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  //添加商品分类
  ShowFrame(TFrame(GlobalInputNameFrame),TFrameInputName,frmMain,nil,nil,OnReturnFrameFromAddInputName,Application);
//  GlobalInputNameFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalInputNameFrame.Load('添加酒店类型',
                            '酒店类型',
                            '请输入酒店类型',
                            '');

end;

procedure TFrameSelectedHotelClassify.btnDelClick(Sender: TObject);
begin

  FNeedDelHotelClassifyFid:=Self.lbList.Properties.PanDragItem.Tag;

  ShowWaitingFrame(Self,'删除中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                      DoDelHotelClassifyExecute,
                      DoDelHotelClassifyExecuteEnd);
end;

procedure TFrameSelectedHotelClassify.btnReturnClick(Sender: TObject);
begin
  //什么也不做
  //清空返回事件,也就是返回的时候不调用它
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self);
end;

constructor TFrameSelectedHotelClassify.Create(AOwner: TComponent);
begin
  inherited;
  FHotelClassifyList:=THotelClassifyList.Create;
  Self.lbList.Prop.Items.Clear(True);
end;

destructor TFrameSelectedHotelClassify.Destroy;
begin
  FreeAndNil(FHotelClassifyList);
  inherited;
end;

procedure TFrameSelectedHotelClassify.DoAddHotelClassifyExecute(
  ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('add_hotel_classify',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'emp_fid',
                                                      'key',
                                                      'name'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNeedAddHotelClassifyName
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


procedure TFrameSelectedHotelClassify.DoAddHotelClassifyExecuteEnd(
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
        //刷新
        Load;
      end
      else
      begin
        //添加失败
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

procedure TFrameSelectedHotelClassify.DoDelHotelClassifyExecute(
  ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('del_goods_classify',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'emp_fid',
                                                      'key',
                                                      'fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNeedDelHotelClassifyFid
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

procedure TFrameSelectedHotelClassify.DoDelHotelClassifyExecuteEnd(
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
        //删除平移的列表项
        Self.lbList.Properties.Items.Remove(
            Self.lbList.Properties.PanDragItem,True
            );
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

procedure TFrameSelectedHotelClassify.DoGetHotelClassifylistExecute(
  ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_hotel_classify_list',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'emp_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key
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



procedure TFrameSelectedHotelClassify.DoGetHotelClassifylistExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I:Integer;
  AListViewItem:TSkinListViewItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //获取用户列表成功
          FHotelClassifyList.Clear(True);
          FHotelClassifyList.ParseFromJsonArray(THotelClassify,ASuperObject.O['Data'].A['HotelClassifyList']);

          Self.lbList.Prop.Items.BeginUpdate;
          try

            Self.lbList.Prop.Items.ClearItemsByType(sitDefault);

            for I := 0 to FHotelClassifyList.Count-1 do
            begin

              AListViewItem:=Self.lbList.Prop.Items.Add;
              AListViewItem.Data:=FHotelClassifyList[I];

              AListViewItem.Caption:=FHotelClassifyList[I].name;
              AListViewItem.Tag:=FHotelClassifyList[I].fid;
            end;

          finally
            Self.lbList.Prop.Items.EndUpdate();
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


procedure TFrameSelectedHotelClassify.DoUpdateHotelClassifyExecute(
  ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('update_hotel_classify',
                                                      AHttpControl,
                                                      InterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'name',
                                                      'fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FNeedUpdateHotelClassifyName,
                                                      SelectedFid
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


procedure TFrameSelectedHotelClassify.DoUpdateHotelClassifyExecuteEnd(
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
        //刷新
        Load;
      end
      else
      begin
        //修改失败
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


procedure TFrameSelectedHotelClassify.lbListClickItem(AItem: TSkinItem);
begin
  Selected:=AItem.Caption;
  SelectedFid:=AItem.Tag;

  if Self.pnlToolBar.Caption='选择酒店类型' then
  begin
    //选中某一项，关闭窗体
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self);
  end;

  if Self.pnlToolBar.Caption='酒店类型' then
  begin
    HideVirtualKeyboard;
    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

    //修改商品分类
    ShowFrame(TFrame(GlobalInputNameFrame),TFrameInputName,frmMain,nil,nil,OnReturnFrameFromUpdateInputName,Application);
//    GlobalInputNameFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalInputNameFrame.Load('修改酒店类型',
                              '酒店类型',
                              '请输入酒店类型',
                              Selected
                              );
  end;

end;




procedure TFrameSelectedHotelClassify.Load;
begin
  Selected:='';
  SelectedFid:=-1;

  if GlobalManager.User.is_hotel_manager=1 then
  begin
    Self.btnAdd.Visible:=False;
    Self.btnDel.Visible:=False;
  end
  else
  begin
    Self.btnAdd.Visible:=True;
    Self.btnDel.Visible:=True;
  end;

  Self.pnlSearchBar.Visible:=False;
  Self.pnlToolBar.Caption:=Self.ToolBarCaption;
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                         DoGetHotelClassifylistExecute,
                         DoGetHotelClassifylistExecuteEnd);
end;

procedure TFrameSelectedHotelClassify.OnReturnFrameFromAddInputName(
  Frame:TFrame);
begin
  Self.FNeedAddHotelClassifyName:=GlobalInputNameFrame.edtName.Text;

  ShowWaitingFrame(Self,'添加中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoAddHotelClassifyExecute,
                     DoAddHotelClassifyExecuteEnd);
end;

procedure TFrameSelectedHotelClassify.OnReturnFrameFromUpdateInputName(
  Frame:TFrame);
begin
  Self.FNeedUpdateHotelClassifyName:=GlobalInputNameFrame.edtName.Text;

  ShowWaitingFrame(Self,'修改中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                       DoUpdateHotelClassifyExecute,
                       DoUpdateHotelClassifyExecuteEnd);
end;

end.
