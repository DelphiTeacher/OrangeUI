//convert pas to utf8 by ¥
unit ChangeSignFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, uSkinFireMonkeyEdit,
  uSkinBufferBitmap,MessageBoxFrame,uTimerTask,
  uUIFunction,uManager,ClientModuleUnit1,XSuperObject,
  EditMyFrame,MainFrame,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo, uSkinFireMonkeyLabel,
  uSkinLabelType, uSkinButtonType, uBaseSkinControl, uSkinPanelType,
  FMX.Memo.Types;

type
  TFrameChangeSign = class(TFrame)
    pnlChangeSign: TSkinFMXPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnOk: TSkinFMXButton;
    pnlSign: TSkinFMXPanel;
    lblCharCount: TSkinFMXLabel;
    memSign: TSkinFMXMemo;
    tmrCalcCharCount: TTimer;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure memSignChange(Sender: TObject);
    procedure tmrCalcCharCountTimer(Sender: TObject);
  private
    procedure DoChangeSignExecute(ATimerTask:TObject);
    procedure DoChangeSignExecuteEnd(ATimerTask:TObject);
    { Private declarations }
    
  public
    { Public declarations }
//     FrameHistroy:TFrameHistroy;
     FSign:String;
  end;


var
  GlobalChangeSignFrame:TFrameChangeSign;


implementation

{$R *.fmx}

uses MainForm;


procedure TFrameChangeSign.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameChangeSign.DoChangeSignExecute(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    ASuperObject:=TSuperObject.Create;
    ASuperObject.S['Sign']:=FSign;


    TTimerTask(ATimerTask).TaskDesc:=
      ClientModuleUnit1.ClientModule.ServerMethods1Client.UpdateUserInfo(
          GlobalManager.User.FID,
          GlobalManager.LoginKey,
          ASuperObject.AsJSON);


    TTimerTask(ATimerTask).TaskTag:=0;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameChangeSign.DoChangeSignExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        GlobalManager.User.Sign:=Self.memSign.Text;
        GlobalEditMyFrame.load;
        HideFrame;////(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);

      end
      else
      begin
        //失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
end;

procedure TFrameChangeSign.memSignChange(Sender: TObject);
begin
  lblCharCount.Caption:=IntToStr(Length(Self.memSign.Text))+'/250';
end;

procedure TFrameChangeSign.tmrCalcCharCountTimer(Sender: TObject);
begin
  Self.memSignChange(Self.memSign);
end;

procedure TFrameChangeSign.btnOkClick(Sender: TObject);
begin


  if Length(Self.memSign.Text)>250 then
  begin
    ShowMessageBoxFrame(Self,'输入的签名字数超出!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoChangeSignExecute,
      DoChangeSignExecuteEnd
      );
  FSign:=Self.memSign.Text;
end;


end.
