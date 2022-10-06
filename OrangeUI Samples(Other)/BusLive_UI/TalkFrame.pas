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
  uBufferBitmap,
  uBaseList,
  uFileCommon,
  uFuncCommon,
  uDrawTextParam,

  ChatBoxFrame,
  ChatInputFrame,
  BusLiveCommonSkinMaterialModule,
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
  private
    //是否自动处理虚拟键盘
    function IsAutoPorcessVirtualKeyboard:Boolean;
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    //虚拟键盘放在哪里
    function GetVirtualKeyboardControlParent:TControl;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FChatBox:TFrameChatBox;
    FChatInput:TFrameChatInput;

    procedure DoSendMsgButtonClick(Sender: TObject);

    { Public declarations }
  end;

var
  GlobalTalkFrame:TFrameTalk;

implementation

{$R *.fmx}

{ TFrameTalk }


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
end;

function TFrameTalk.GetCurrentPorcessControl(AFocusedControl:TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameTalk.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

destructor TFrameTalk.Destroy;
begin
  inherited;
end;

procedure TFrameTalk.btnReturnClick(Sender: TObject);
begin

  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

function TFrameTalk.IsAutoPorcessVirtualKeyboard: Boolean;
begin
  Result:=True;
end;


end.

