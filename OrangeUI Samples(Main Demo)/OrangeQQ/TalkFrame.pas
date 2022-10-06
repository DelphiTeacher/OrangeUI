//convert pas to utf8 by ¥

unit TalkFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinImageList, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyImage,
  uUIFunction,
  FMX.VirtualKeyboard,
  FMX.Platform,
  uSkinItems,
  uDrawCanvas,
//  uSkinPackage,
  uComponentType,
  uSkinBufferBitmap,
  uBaseList,
  uFileCommon,
  uFuncCommon,
  uDrawTextParam,

  ChatBoxFrame,
  ChatInputFrame,
  QQCommonSkinMaterialFrame,
  uSkinListBoxType,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, FMX.Layouts,
  FMX.Memo, uSkinFireMonkeyMemo, uDrawPicture,
  FMX.ScrollBox,
  uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinFireMonkeySwitchPageListPanel, uSkinMaterial, uSkinButtonType,
  uSkinFireMonkeyFrameImage, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyScrollControlCorner, uSkinFireMonkeyScrollBar, uSkinPanelType;

type
  TFrameTalk = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    //虚拟键盘放在哪里
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
  public
    FChatBox:TFrameChatBox;
    FChatInput:TFrameChatInput;

    procedure DoSendBitmapClick(Sender: TObject;Bitmap:TBitmap);
    procedure DoSendMsgButtonClick(Sender: TObject);

    { Public declarations }
  end;

var
  GlobalTalkFrame:TFrameTalk;

implementation

{$R *.fmx}

{ TFrameTalk }

procedure TFrameTalk.DoSendBitmapClick(Sender: TObject; Bitmap: TBitmap);
var
  strMsgId: String;
  bImportant: Boolean;
  dtSendTime: TDateTime;
var
  AFileName:String;
  strSuperObjectCode: string;
begin
  //保存成临时文件
  AFileName:=uFileCommon.GetApplicationPath+CreateGUIDStringHasDevide+'.jpg';
  Bitmap.SaveToFile(AFileName);

  //发送图片
  strSuperObjectCode := '[Msg_Image]1111[/Msg_Image]';

  FChatBox.AddContactMessage(
    0,
//    FUserId,
    strMsgId,
//    MsgType,
//    MsgLevel,
    strSuperObjectCode,
    '',
    strSuperObjectCode + '|' +AFileName,
    Now);

end;

procedure TFrameTalk.DoSendMsgButtonClick(Sender: TObject);
begin

  FChatBox.AddContactMessage(
    0,
//    FUserId,
    '1',
//    MsgType,
//    MsgLevel,
    FChatInput.memMsgInput.Text,
    FontToString(FChatInput.memMsgInput.Font),
    '',//strSuperObjects.Text,
    Now);


  FChatInput.memMsgInput.Text:='';//Lines.Clear();

end;

constructor TFrameTalk.Create(AOwner: TComponent);
begin
  inherited;
  FChatBox:=TFrameChatBox.Create(Self);
  FChatBox.Parent:=Self;
  FChatBox.Align:=TAlignLayout.Client;

  FChatInput:=TFrameChatInput.Create(Self);
  FChatInput.Parent:=Self;
  FChatInput.Align:=TAlignLayout.Bottom;
  FChatInput.OnSendMsgButtonClick:=Self.DoSendMsgButtonClick;
  FChatInput.OnSendBitmapClick:=Self.DoSendBitmapClick;
end;

function TFrameTalk.GetCurrentPorcessControl(AFocusedControl:TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameTalk.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameTalk.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameTalk.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;



end.

