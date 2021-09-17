//convert pas to utf8 by ¥
unit ShieldUserListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton,
  uSkinFireMonkeyPanel,
  uSkinFireMonkeyControl,
  uUIFunction,
  uSkinFireMonkeyScrollControl,
  uSkinListBoxType,
  uSkinFireMonkeyCustomList,
  uManager,
  uDrawPicture,
  uSkinItems,
  uTimerTask,

  ClientModuleUnit1,
  XSuperObject,
  GetUserInfoFrame,

  MainFrame,
  MainForm,
  MessageBoxFrame,
  WaitingFrame,

  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel, uSkinButtonType,
  uSkinPanelType, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType, uDrawCanvas;

type
  TFrameShieldUserList = class(TFrame)
    lbList: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlList: TSkinFMXItemDesignerPanel;
    imgListPicture: TSkinFMXImage;
    lblListName: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbListClickItem(AItem: TSkinItem);
  private
    FUserID:Integer;
    procedure DoGetUserInfoExecute(ATimerTask:TObject);
    procedure DoGetUserInfoExecuteEnd(ATimerTask:TObject);

  private
    procedure DoReturnFrameFromGetUserInfoFrame(Frame:TFrame);

    procedure DoGetShieldUserListExecute(ATimerTask:TObject);
    procedure DoGetShieldUserListExecuteEnd(ATimerTask:TObject);


    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load;
    { Public declarations }
  end;
var
  GlobalShieldUserListFrame:TFrameShieldUserList;
implementation

{$R *.fmx}

{ TFrameShieldUserList }


procedure TFrameShieldUserList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;




procedure TFrameShieldUserList.DoGetUserInfoExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;


    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.GetUserInfo(
        FUserID,
        GlobalManager.User.FID
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

procedure TFrameShieldUserList.DoGetUserInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUser:TUser;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        AUser:=TUser.Create;
        try

          AUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);

          HideFrame;//(GlobalMainFrame);
          ShowFrame(TFrame(GlobalGetUserInfoFrame),TFrameGetUserInfo,frmMain,nil,nil,DoReturnFrameFromGetUserInfoFrame,Application);
//          GlobalGetUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
          GlobalGetUserInfoFrame.Load(AUser,ASuperObject.O['Data'].B['IsShield']);

        finally
          FreeAndNil(AUser);
        end;
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
procedure TFrameShieldUserList.DoGetShieldUserListExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.GetShieldUserList(
           GlobalManager.User.FID
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

procedure TFrameShieldUserList.DoGetShieldUserListExecuteEnd(
  ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AUser:TUser;
  AListBoxItem:TSkinListBoxItem;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        Self.lbList.BeginUpdate;
        try
          Self.lbList.Prop.Items.Clear;
          if ASuperObject.O['Data'].A['User'].Length-1<0 then
          begin
            ShowMessageBoxFrame(Self,'您目前没有屏蔽的人!','',TMsgDlgType.mtInformation,['确定'],nil);
          end
          else
          begin
            for I := 0 to ASuperObject.O['Data'].A['User'].Length-1 do
            begin
              AUser:=TUser.Create;
              try
                AUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[I]);

                AListBoxItem:=Self.lbList.Prop.Items.Add;
                AListBoxItem.Caption:=AUser.Name;
                AListBoxItem.Icon.Url:=AUser.GetHeadPicUrl;
                AListBoxItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
                AListBoxItem.Tag:=AUser.FID;
              finally
                FreeAndNil(AUser);
              end;
            end;
          end;
        finally
          Self.lbList.EndUpdate;
        end;

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

procedure TFrameShieldUserList.DoReturnFrameFromGetUserInfoFrame(Frame: TFrame);
begin
  Load;
end;

procedure TFrameShieldUserList.lbListClickItem(AItem: TSkinItem);
begin
  ShowWaitingFrame(Self,'加载中...');

  FUserID:=AItem.Tag;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
        DoGetUserInfoExecute,
        DoGetUserInfoExecuteEnd
        );
end;

procedure TFrameShieldUserList.Load;
begin
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoGetShieldUserListExecute,
              DoGetShieldUserListExecuteEnd
              );

end;

end.
