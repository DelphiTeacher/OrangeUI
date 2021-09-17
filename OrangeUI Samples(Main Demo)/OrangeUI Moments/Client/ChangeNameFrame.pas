//convert pas to utf8 by ¥
unit ChangeNameFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, uUIFunction,  ClientModuleUnit1,
  uManager,XSuperObject,MessageBoxFrame,uTimerTask,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyLabel, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyPanel, uSkinButtonType,
  uSkinPanelType;

type
  TFrameChangeName = class(TFrame)
    pnlChangeName: TSkinFMXPanel;
    btnOk: TSkinFMXButton;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    edtNickName: TSkinFMXEdit;
    ClearEditButton2: TClearEditButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    procedure DoChangeNameExecute(ATimerTask:TObject);
    procedure DoChangeNameExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    { Public declarations }
//      FrameHistroy:TFrameHistroy;
      FName:String;
  end;

var
  GlobalChangeNameFrame:TFrameChangeName;

implementation

{$R *.fmx}

uses
  EditMyFrame;

procedure TFrameChangeName.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameChangeName.DoChangeNameExecute(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
     //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    ASuperObject:=TSuperObject.Create;
    ASuperObject.S['Name']:=FName;

    TTimerTask(ATimerTask).TaskDesc:=ClientModuleUnit1.ClientModule.ServerMethods1Client.UpdateUserInfo(
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

procedure TFrameChangeName.DoChangeNameExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        GlobalManager.User.Name:=Self.edtNickName.Text;
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

procedure TFrameChangeName.btnOkClick(Sender: TObject);
begin
   if self.edtNickName.Text='' then
  begin
    ShowMessageBoxFrame(self,'请输入昵称','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
   if Length(Self.edtNickName.Text)>10 then
  begin
    ShowMessageBoxFrame(Self,'输入的昵称不能超过10个字!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


   FName:=self.edtNickName.Text;
   uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoChangeNameExecute,
      DoChangeNameExecuteEnd
      );
end;

end.
