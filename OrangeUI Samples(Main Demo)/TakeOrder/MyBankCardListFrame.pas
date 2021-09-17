//convert pas to utf8 by ¥
unit MyBankCardListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

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

  EasyServiceCommonMaterialDataMoudle,


  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyPageControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyCustomList, uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeySwitchPageListPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyRadioButton, uSkinRadioButtonType, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas;

type
  TFrameMyBankCardList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlBottomBar: TSkinFMXPanel;
    btnAdd: TSkinFMXButton;
    lbBankList: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    lblItemBackCardDefault: TSkinFMXLabel;
    rbItemSelected: TSkinFMXRadioButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure imgAddClick(Sender: TObject);
    procedure lblAddClick(Sender: TObject);
    procedure lbBankListClickItem(AItem: TSkinItem);
    procedure lbBankListPullDownRefresh(Sender: TObject);
  private
    FUseType:TFrameUseType;
    FBankCardList:TBankCardList;
    //获取银行卡列表
    procedure DoGetBankCardListExecute(ATimerTask:TObject);
    procedure DoGetBankCardListExecuteEnd(ATimerTask:TObject);

    //从添加银行卡页面返回
    procedure OnReturnFromAddMyBankCard(Frame:TFrame);
    //从修改银行卡页面返回
    procedure OnReturnFromChangeMyBankCard(Frame:TFrame);

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FSelectedBankCardFID:Integer;
    FSelectedBankCard:TBankCard;
    procedure Load(ACaption:String;
                    AUseType:TFrameUseType;
                    ASelectedBankCardFID:Integer);
    { Public declarations }
  end;

var
  GlobalMyBankCardListFrame:TFrameMyBankCardList;

implementation

{$R *.fmx}

uses
  MainForm,
  AddMyBankCardFrame;

{ TFrameMyBankCard }

procedure TFrameMyBankCardList.btnAddClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //我的银行卡
  ShowFrame(TFrame(GlobalAddMyBankCardFrame),TFrameAddMyBankCard,frmMain,nil,nil,OnReturnFromAddMyBankCard,Application);
  GlobalAddMyBankCardFrame.btnDel.Visible:=False;
  GlobalAddMyBankCardFrame.pnlToolBar.Caption:='绑定银行卡';
//  GlobalAddMyBankCardFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddMyBankCardFrame.Clear;
end;

procedure TFrameMyBankCardList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

constructor TFrameMyBankCardList.Create(AOwner: TComponent);
begin
  inherited;
  FBankCardList:=TBankCardList.Create;
  Self.lbBankList.Prop.Items.Clear(True);
end;

destructor TFrameMyBankCardList.Destroy;
begin
  FreeAndNil(FBankCardList);
  inherited;
end;

procedure TFrameMyBankCardList.DoGetBankCardListExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  AHttpControl:=TSystemHttpControl.Create;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_user_bankcard_list',
                          AHttpControl,
                          InterfaceUrl,
                          ['appid',
                          'user_fid',
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

procedure TFrameMyBankCardList.DoGetBankCardListExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          FBankCardList.Clear(True);
          FBankCardList.ParseFromJsonArray(TBankCard,ASuperObject.O['Data'].A['BankCardList']);
//          if FBankCardList.Count-1<0 then
//          begin
//            //银行卡列表个数为0
//            Self.pcPage.Prop.ActivePage:=tsAdd;
//            Self.btnAdd.Visible:=False;
//          end
//          else
//          begin
//            Self.pcPage.Prop.ActivePage:=tsList;

            Self.lbBankList.Prop.Items.BeginUpdate;
            try
              Self.lbBankList.Prop.Items.Clear(True);

              for I := 0 to FBankCardList.Count-1 do
              begin
                AListBoxItem:=Self.lbBankList.Prop.Items.Add;
                AListBoxItem.Data:=FBankCardList[I];
                AListBoxItem.Caption:=FBankCardList[I].name;
                AListBoxItem.Detail:=FBankCardList[I].bankname;
                AListBoxItem.Detail1:=HideBankCardNumber(FBankCardList[I].account);

                if FBankCardList[I].is_default=1 then
                begin
                  AListBoxItem.Detail2:='默认';
                end
                else
                begin
                  AListBoxItem.Detail2:='';
                end;

                //设置选中
                if (Self.FSelectedBankCardFID=FBankCardList[I].fid) then
                begin
                  AListBoxItem.Selected:=True;
                  FSelectedBankCard:=FBankCardList[I];
                end;

                //设置银行图标
                AListBoxItem.IconImageIndex:=GetBankIconIndex(FBankCardList[I].bankname);

              end;
            finally
              Self.lbBankList.Prop.Items.EndUpdate();
            end;

//          end;

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
    Self.lbBankList.Prop.StopPullDownRefresh('刷新成功!',600);
  end;
end;


procedure TFrameMyBankCardList.imgAddClick(Sender: TObject);
begin
  btnAddClick(btnAdd);
end;

procedure TFrameMyBankCardList.lbBankListClickItem(AItem: TSkinItem);
var
  ABankCard:TBankCard;
begin
  ABankCard:=TBankCard(AItem.Data);

  if FUseType=futManage then
  begin
    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);

    //我的银行卡
    ShowFrame(TFrame(GlobalAddMyBankCardFrame),TFrameAddMyBankCard,frmMain,nil,nil,OnReturnFromChangeMyBankCard,Application);
//    GlobalAddMyBankCardFrame.FrameHistroy:=CurrentFrameHistroy;

    GlobalAddMyBankCardFrame.btnDel.Visible:=True;
    GlobalAddMyBankCardFrame.pnlToolBar.Caption:='修改银行卡信息';
    GlobalAddMyBankCardFrame.btnOk.Caption:='确定';
    GlobalAddMyBankCardFrame.Load(ABankCard);
  end;

  if FUseType=futSelectList then
  begin
    FSelectedBankCardFID:=ABankCard.fid;
    FSelectedBankCard:=ABankCard;

    //返回
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

end;

procedure TFrameMyBankCardList.lbBankListPullDownRefresh(Sender: TObject);
begin
  //下拉刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoGetBankCardListExecute,
                              DoGetBankCardListExecuteEnd);
end;

procedure TFrameMyBankCardList.lblAddClick(Sender: TObject);
begin
  btnAddClick(btnAdd);
end;

procedure TFrameMyBankCardList.Load(ACaption:String;
                                    AUseType:TFrameUseType;
                                    ASelectedBankCardFID:Integer);
begin
  Self.pnlToolBar.Caption:=ACaption;

  FUseType:=AUseType;
  FSelectedBankCardFID:=ASelectedBankCardFID;
  FSelectedBankCard:=nil;

  if FUseType=futManage then
  begin
    Self.rbItemSelected.Visible:=False;
  end;

  if FUseType=futSelectList then
  begin
    Self.rbItemSelected.Visible:=True;
  end;

  Self.lbBankList.Prop.StartPullDownRefresh;
end;

procedure TFrameMyBankCardList.OnReturnFromAddMyBankCard(Frame: TFrame);
begin
  Self.lbBankList.Prop.StartPullDownRefresh;
end;

procedure TFrameMyBankCardList.OnReturnFromChangeMyBankCard(Frame: TFrame);
begin
  Self.lbBankList.Prop.StartPullDownRefresh;
end;

end.
