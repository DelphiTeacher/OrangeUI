//convert pas to utf8 by ¥
unit GetUserInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  XSuperObject,WaitingFrame,
  uSkinItems,uSkinBufferBitmap,ClientModuleUnit1,uTimerTask,MessageBoxFrame,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,uManager,uDrawPicture,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,uUIFunction,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinFireMonkeyLabel,
  uSkinFireMonkeyListBox, uSkinFireMonkeyPopup, FMX.Controls.Presentation,
  FMX.Objects, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameGetUserInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lvGetUserInfo: TSkinFMXListBox;
    pnlItem1: TSkinFMXItemDesignerPanel;
    imgUserPicture: TSkinFMXImage;
    lblUserNickName: TSkinFMXLabel;
    pnlItem2: TSkinFMXItemDesignerPanel;
    lblUserInfo: TSkinFMXLabel;
    lblUserDetil: TSkinFMXLabel;
    lblUserPhoneNumber: TSkinFMXLabel;
    lblDepartMent: TSkinFMXLabel;
    lblUserName: TSkinFMXLabel;
    lblUserPhone: TSkinFMXLabel;
    lblUserSector: TSkinFMXLabel;
    btnPop: TSkinFMXButton;
    popScan: TSkinFMXPopup;
    CalloutRectangle1: TCalloutRectangle;
    lbFunction: TSkinFMXListBox;
    procedure btnReturnClick(Sender: TObject);
    procedure btnPopClick(Sender: TObject);
    procedure lbFunctionClickItem(AItem: TSkinItem);
  private

    FShiledUserFID:Integer;

    procedure DoWantedShieldUserExecute(ATimerTask:TObject);
    procedure DoWantedShieldUserExecuteEnd(ATimerTask:TObject);

    procedure DoCancelledShieldUserExecute(ATimerTask:TObject);
    procedure DoCancelledShieldUserExecuteEnd(ATimerTask:TObject);

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load(AUser:TUser;IsShield:Boolean);
    { Public declarations }
  end;

var
  GlobalGetUserInfoFrame:TFrameGetUserInfo;

implementation

uses
  SpiritFrame,
  MainForm,
  MainFrame,
  ComplainUserFrame,
  ShieldUserListFrame;

{$R *.fmx}

procedure TFrameGetUserInfo.btnPopClick(Sender: TObject);
begin

    //弹出菜单
    if not popScan.IsOpen then
    begin
        //绝对位置
        popScan.PlacementRectangle.Left:=Self.LocalToScreen(PointF(Self.btnPop.Position.X+Self.btnPop.Width,Self.btnPop.Position.Y)).X-Self.popScan.Width;
        popScan.PlacementRectangle.Top:=Self.LocalToScreen(PointF(0,Self.pnlToolBar.Height+10)).Y-25;
        popScan.IsOpen := True;
    end
    else
    begin
        popScan.IsOpen := False;
    end;
end;

procedure TFrameGetUserInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameGetUserInfo.DoCancelledShieldUserExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.CanCelledShieldUser(
           GlobalManager.User.FID,
           FShiledUserFID
        );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameGetUserInfo.DoCancelledShieldUserExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        Self.lbFunction.Prop.Items.FindItemByCaption('取消屏蔽他的动态').Visible:=False;
        Self.lbFunction.Prop.Items.FindItemByCaption('屏蔽他的动态').Visible:=True;
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

procedure TFrameGetUserInfo.DoWantedShieldUserExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.WantedShieldUser(
           GlobalManager.User.FID,
           FShiledUserFID
        );

    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameGetUserInfo.DoWantedShieldUserExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        Self.lbFunction.Prop.Items.FindItemByCaption('屏蔽他的动态').Visible:=False;
        Self.lbFunction.Prop.Items.FindItemByCaption('取消屏蔽他的动态').Visible:=True;
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

procedure TFrameGetUserInfo.lbFunctionClickItem(AItem: TSkinItem);
begin
  if AItem.Caption='屏蔽他的动态' then
  begin

    ShowWaitingFrame(Self,'屏蔽中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoWantedShieldUserExecute,
              DoWantedShieldUserExecuteEnd
              );

    Self.popScan.IsOpen:=False;
  end;
  if AItem.Caption='取消屏蔽他的动态' then
  begin
    ShowWaitingFrame(Self,'取消中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoCancelledShieldUserExecute,
              DoCancelledShieldUserExecuteEnd
              );

    Self.popScan.IsOpen:=False;
  end;
  if AItem.Caption='投诉他' then
  begin
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalComplainUserFrame),TFrameComplainUser,frmMain,nil,nil,nil,Application);
    Self.popScan.IsOpen:=False;
    GlobalComplainUserFrame.clear;
    GlobalComplainUserFrame.FUserFID:=FShiledUserFID;
  end;
end;

procedure TFrameGetUserInfo.Load(AUser:TUser;IsShield:Boolean);
begin
  Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1).Icon.Url:=AUser.GetHeadPicUrl;
  Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1).Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
  Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1).Detail1:=AUser.CompanyName;
  Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1).Caption:=AUser.Name;
  Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1).Detail:=AUser.Phone;
  Self.lvGetUserInfo.Prop.Items.FindItemByCaption('签名').Detail:=AUser.Sign;
  Self.lvGetUserInfo.Prop.Items.FindItemByCaption('签名').Height:=uSkinBufferBitmap.GetStringHeight(AUser.Sign,
                                RectF(0,0,Self.lblUserDetil.Width,MaxInt))
                                +11+11;
  if AUser.Sex=True then
  begin
    Self.lvGetUserInfo.Prop.Items.FindItemByCaption('性别').Detail:='男';
  end
  else
  begin
    Self.lvGetUserInfo.Prop.Items.FindItemByCaption('性别').Detail:='女';
  end;
  if AUser.FID=GlobalManager.User.FID then
  begin
    Self.btnPop.Visible:=False;
  end
  else
  begin
    Self.btnPop.Visible:=True;
  end;
  if IsShield=True then
  begin
    Self.lbFunction.Prop.Items.FindItemByCaption('屏蔽他的动态').Visible:=False;
    Self.lbFunction.Prop.Items.FindItemByCaption('取消屏蔽他的动态').Visible:=True;
  end
  else
  begin
    Self.lbFunction.Prop.Items.FindItemByCaption('屏蔽他的动态').Visible:=True;
    Self.lbFunction.Prop.Items.FindItemByCaption('取消屏蔽他的动态').Visible:=False;
  end;


  FShiledUserFID:=AUser.FID;
end;

end.
