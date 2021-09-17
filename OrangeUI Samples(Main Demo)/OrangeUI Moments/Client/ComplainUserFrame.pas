//convert pas to utf8 by ¥
unit ComplainUserFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  ClientModuleUnit1,
  XSuperObject,

  uUIFunction,
  uTimerTask,
  uManager,


  WaitingFrame,
  MessageBoxFrame,

  uSkinFireMonkeyPopup, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyCheckBox, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo, uSkinMaterial, Math,
  uSkinRadioButtonType, uSkinFireMonkeyRadioButton, uSkinFireMonkeyLabel,
  uSkinLabelType, uSkinButtonType, uSkinPanelType;

type
  TFrameComplainUser = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    btnOK: TSkinFMXButton;
    chkColor1: TSkinFMXRadioButton;
    chkColor2: TSkinFMXRadioButton;
    chkColor3: TSkinFMXRadioButton;
    chkColor4: TSkinFMXRadioButton;
    SkinFMXPanel2: TSkinFMXPanel;
    memSpirit: TSkinFMXMemo;
    tmrCalcCharCount: TTimer;
    lblCharCount: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure memSpiritChange(Sender: TObject);
    procedure tmrCalcCharCountTimer(Sender: TObject);
    procedure SkinFMXPanel1Resize(Sender: TObject);
  private

    FComplainType:String;
    FComplainContant:String;
    procedure DoUserWantedComplainSomeoneTypeandComplainContantExecute(ATimerTask:TObject);
    procedure DoUserWantedComplainSomeoneTypeandComplainContantExecuteEnd(ATimerTask:TObject);
    procedure OnComplainUserReturn(Sender: TObject);

    { Private declarations }
  public
    FUserFID:Integer;
//    FrameHistroy:TFrameHistroy;

    procedure clear;
    { Public declarations }
  end;

var
  GlobalComplainUserFrame:TFrameComplainUser;

implementation

{$R *.fmx}

procedure TFrameComplainUser.btnOKClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  if (Self.chkColor1.Prop.Checked=False)
      and (Self.chkColor2.Prop.Checked=False)
     and (Self.chkColor3.Prop.Checked=False)
     and (Self.chkColor4.Prop.Checked=False) then
  begin
    ShowMessageBoxFrame(Self,'请选择投诉类型!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.memSpirit.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入投诉详情!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Length(Self.memSpirit.Text)>250 then
  begin
    ShowMessageBoxFrame(Self,'投诉内容不能超过250字!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;



  if Self.chkColor1.Prop.Checked=True then
  begin
    FComplainType:=Self.chkColor1.Text;
  end;
  if Self.chkColor2.Prop.Checked=True then
  begin
    FComplainType:=Self.chkColor2.Text;
  end;
  if Self.chkColor3.Prop.Checked=True then
  begin
    FComplainType:=Self.chkColor3.Text;
  end;
  if Self.chkColor4.Prop.Checked=True then
  begin
    FComplainType:=Self.chkColor4.Text;
  end;
  FComplainContant:=Self.memSpirit.Text;

  ShowWaitingFrame(Self,'提交中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
          DoUserWantedComplainSomeoneTypeandComplainContantExecute,
          DoUserWantedComplainSomeoneTypeandComplainContantExecuteEnd
          );

end;

procedure TFrameComplainUser.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameComplainUser.clear;
begin
  Self.memSpirit.Lines.Clear;
  Self.chkColor1.Prop.Checked:=False;
  Self.chkColor2.Prop.Checked:=False;
  Self.chkColor3.Prop.Checked:=False;
  Self.chkColor4.Prop.Checked:=False;
end;

procedure TFrameComplainUser.DoUserWantedComplainSomeoneTypeandComplainContantExecute(ATimerTask: TObject);
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.WantedComplainUser(
           GlobalManager.User.FID,
           FUserFID,
           FComplainType,
           FComplainContant
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

procedure TFrameComplainUser.DoUserWantedComplainSomeoneTypeandComplainContantExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


        clear;
        ShowMessageBoxFrame(Self,'投诉成功!','',TMsgDlgType.mtInformation,['确定'],OnComplainUserReturn);
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

procedure TFrameComplainUser.memSpiritChange(Sender: TObject);
begin
  Self.lblCharCount.Caption:=IntToStr(Length(Self.memSpirit.Text))+'/250';
end;

procedure TFrameComplainUser.OnComplainUserReturn(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameComplainUser.SkinFMXPanel1Resize(Sender: TObject);
begin
  Self.chkColor1.Position.X:=10;
  Self.chkColor2.Position.X:=Self.chkColor1.Position.X+Self.chkColor1.Width+10;
  Self.chkColor3.Position.X:=10;
  Self.chkColor4.Position.X:=Self.chkColor3.Position.X+Self.chkColor3.Width+10;
  Self.chkColor1.Width:=(Self.Width-3*10)/2;
  Self.chkColor2.Width:=(Self.Width-3*10)/2;
  Self.chkColor3.Width:=(Self.Width-3*10)/2;
  Self.chkColor4.Width:=(Self.Width-3*10)/2;
end;


procedure TFrameComplainUser.tmrCalcCharCountTimer(Sender: TObject);
begin
  Self.memSpiritChange(Self.memSpirit);
end;

end.
