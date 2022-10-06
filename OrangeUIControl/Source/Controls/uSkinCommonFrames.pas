//convert pas to utf8 by ¥
unit uSkinCommonFrames;

interface
{$I FrameWork.inc}



uses
  Classes,

  {$IFDEF FMX}
  Types,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  {$ENDIF}

  {$IFDEF VCL}
  Windows,
  Controls,
  Forms,
  {$ENDIF}

  {$IF CompilerVersion > 21.0}
  UITypes,
  {$IFEND}


//  System.UITypes,
  SysUtils;



type
  {$IFDEF VCL}
  TFmxObject=TWinControl;
  {$ENDIF}

  {$IF CompilerVersion <= 21.0}
  TMsgDlgType = (mtWarning, mtError, mtInformation, mtConfirmation, mtCustom);
  {$IFEND}

  TSkinMessageBox=class;

  TModalResultExEvent=procedure(Sender:TObject;
                                AModalResult:String;
                                AModalResultName:String;
                                AInputEditText1:String;
                                AInputEditText2:String) of object;
  TModalResultExProc=reference to procedure(Sender:TObject;
                                AModalResult:String;
                                AModalResultName:String;
                                AInputEditText1:String;
                                AInputEditText2:String);




  TCanModalResultEvent=procedure(Sender:TObject;
                                  AModalResult:String;
                                  AModalResultName:String;
                                  var AIsCanModalResult:Boolean) of object;


  TCanModalResultProc=reference to procedure(Sender:TObject;
                                  AModalResult:String;
                                  AModalResultName:String;
                                  var AIsCanModalResult:Boolean);




  //实现显示对话框,在MessageBoxFrame中实现
  TDoShowMessageBoxEvent=function(Sender:TObject;
                                   ASkinMessageBox:TSkinMessageBox):TFrame;
  //实现显示简单的对话框,在MessageBoxFrame中实现
  TDoShowSimpleMessageBoxEvent=function(Sender:TFmxObject;
                                        AMsg:String;
                                        AOtherMsg:String):TFrame;
  //实现显示等待框,在WaitingFrame中实现
  TDoShowWaitingEvent=procedure(Sender:TFmxObject;AHint:String);
  //实现隐藏对话框,在WaitingFrame中实现
  TDoHideWaitingEvent=procedure();
  //实现显示提示框,在HintFrame中实现
  TDoShowHintEvent=procedure(Sender:TFmxObject;AHint:String);

  //对话框显示的事件
  TMessageBoxFrameShowEvent=procedure(Sender:TObject;
                                     AMessageBoxFrame:TFrame) of object;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinMessageBox=class(TComponent)
  private
    FOnModalResult: TNotifyEvent;
    FButtonCaptions: String;
    FButtonNames: String;
    FOtherMsg: string;
    FMsg: String;
    FDlgType: TMsgDlgType;
    FCustomDlgType: String;
    FOnCanModalResult: TCanModalResultEvent;
    FOnShow: TMessageBoxFrameShowEvent;
    FOnModalResultEx: TModalResultExEvent;
    FInputEditCount: Integer;
  public
    //显示自定义控件
    CustomControl:TControl;
    procedure ShowMessageBox;
  public
    constructor Create(AOwner:TComponent);override;
  published
    //标题
    property Msg:String read FMsg write FMsg;
    //内容
    property OtherMsg: string read FOtherMsg write FOtherMsg;
    //对话框类型-提示、提醒、警告、报错
    property DlgType: TMsgDlgType read FDlgType write FDlgType;
    //按钮标题
    property ButtonCaptions:String read FButtonCaptions write FButtonCaptions;
    //按钮名字
    property ButtonNames:String read FButtonNames write FButtonNames;
    property OnShow:TMessageBoxFrameShowEvent read FOnShow write FOnShow;
    //点击事件
    property OnModalResult:TNotifyEvent read FOnModalResult write FOnModalResult;
    //开始点击事件
    property OnCanModalResult:TCanModalResultEvent read FOnCanModalResult write FOnCanModalResult;
    //自定义对话框类型
    property CustomDlgType:String read FCustomDlgType write FCustomDlgType;

    //输入框个数
    property InputEditCount:Integer read FInputEditCount write FInputEditCount;
    property OnModalResultEx:TModalResultExEvent read FOnModalResultEx write FOnModalResultEx;

  end;





//  //实现显示对话框,在MessageBoxFrame中实现
//  TDoShowMessageBoxEvent=function(Sender:TObject;
//                                   ASkinMessageBox:TSkinMessageBox):TFrame;
//  //实现显示等待框,在WaitingFrame中实现
//  TDoShowWaitingEvent=procedure(Sender:TObject;AHint:String);
//  //实现隐藏对话框,在WaitingFrame中实现
//  TDoHideWaitingEvent=procedure();
var
  GlobalDoShowMessageBox:TDoShowMessageBoxEvent;
  GlobalDoShowSimpleMessageBox:TDoShowSimpleMessageBoxEvent;
  GlobalDoShowWaiting:TDoShowWaitingEvent;
  GlobalDoHideWaiting:TDoHideWaitingEvent;
  GlobalDoShowHint:TDoShowHintEvent;


//显示对话框
procedure GlobalShowMessageBox(AParent:TFmxObject;AMsg:String;AOtherMsg:String);
//显示等待框
procedure GlobalShowWaiting(AParent:TFmxObject;AHint:String);
//隐藏等待框
procedure GlobalHideWaiting;

//显示提示框
procedure GlobalShowHint(AParent:TFmxObject;AHint:String);


implementation


procedure GlobalShowMessageBox(AParent:TFmxObject;AMsg:String;AOtherMsg:String);
begin
  if Assigned(GlobalDoShowSimpleMessageBox) then
  begin
    GlobalDoShowSimpleMessageBox(AParent,AMsg,AOtherMsg);
  end
  else
  begin
    raise Exception.Create('GlobalShowMessageBox'
            +' GlobalDoShowSimpleMessageBox Is Nil,'
            +' Please Use Unit MessageBoxFrame.pas'
            );
  end;
end;

procedure GlobalShowWaiting(AParent:TFmxObject;AHint:String);
begin
  if Assigned(GlobalDoShowWaiting) then
  begin
    GlobalDoShowWaiting(AParent,AHint);
  end
  else
  begin
    raise Exception.Create('GlobalShowWaiting'
            +' GlobalDoShowWaiting Is Nil,'
            +' Please Use Unit WaitingFrame.pas'
            );
  end;
end;

procedure GlobalShowHint(AParent:TFmxObject;AHint:String);
begin
  if Assigned(GlobalDoShowHint) then
  begin
    GlobalDoShowHint(AParent,AHint);
  end
  else
  begin
    raise Exception.Create('GlobalShowHint'
            +' GlobalDoShowHint Is Nil,'
            +' Please Use Unit HintFrame.pas'
            );
  end;
end;

procedure GlobalHideWaiting;
begin
  if Assigned(GlobalDoHideWaiting) then
  begin
    GlobalDoHideWaiting;
  end
  else
  begin
    raise Exception.Create('GlobalHideWaiting'
            +' GlobalDoHideWaiting Is Nil,'
            +' Please Use Unit WaitingFrame.pas'
            );
  end;
end;

{ TSkinMessageBox }

constructor TSkinMessageBox.Create(AOwner: TComponent);
begin
  inherited;

  FButtonCaptions:='确定,取消';
  FButtonNames:='ok,cancel';
  FDlgType:=TMsgDlgType.mtInformation;
end;

procedure TSkinMessageBox.ShowMessageBox;
var
  AFrame:TFrame;
begin
  if Assigned(GlobalDoShowMessageBox) then
  begin
    AFrame:=GlobalDoShowMessageBox(Self,Self);

    if Assigned(FOnShow) then
    begin
      FOnShow(Self,AFrame);
    end;

  end
  else
  begin
    raise Exception.Create('TSkinMessageBox.ShowMessageBox'
            +' GlobalDoShowMessageBox Is Nil,'
            +' Please Use Unit MessageBoxFrame.pas'
            );
  end;
end;

end.
