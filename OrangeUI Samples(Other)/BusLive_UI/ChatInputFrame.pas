//convert pas to utf8 by ¥
unit ChatInputFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  Math,
  uSkinItems,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,

  uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, FMX.MediaLibrary.Actions, System.Actions,
  FMX.ActnList, FMX.StdActns, uSkinButtonType, uSkinPanelType;


const
  Const_MaxMemoLineCount=3;
  Const_MemoLineHeight=24;


type
  TSendBitmapClickEvent=procedure(Sender:TObject;Bitmap:TBitmap) of object;

  TFrameChatInput = class(TFrame,IFrameVirtualKeyboardEvent)
    pnlInput: TSkinFMXPanel;
    memMsgInput: TSkinFMXMemo;
    pnlSendButton: TSkinFMXPanel;
    btnSendMsg: TSkinFMXButton;
    tmrSyncMemoHeight: TTimer;
    procedure memMsgInputChangeTracking(Sender: TObject);
    procedure btnSendMsgClick(Sender: TObject);
    procedure memMsgInputStayClick(Sender: TObject);
    procedure tmrSyncMemoHeightTimer(Sender: TObject);
  private
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
    { Private declarations }
  public
    OnSendMsgButtonClick:TNotifyEvent;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure SyncHeight;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameChatInput }

procedure TFrameChatInput.btnSendMsgClick(Sender: TObject);
begin
  if Assigned(OnSendMsgButtonClick) then
  begin
    OnSendMsgButtonClick(Sender);
  end;
end;

constructor TFrameChatInput.Create(AOwner: TComponent);
begin
  inherited;
  SyncHeight;
end;

destructor TFrameChatInput.Destroy;
begin

  inherited;
end;

procedure TFrameChatInput.DoVirtualKeyboardHide(KeyboardVisible: Boolean;const Bounds: TRect);
begin
  SyncHeight;
end;

procedure TFrameChatInput.DoVirtualKeyboardShow(KeyboardVisible: Boolean;const Bounds: TRect);
begin
  SyncHeight;
end;

procedure TFrameChatInput.memMsgInputChangeTracking(Sender: TObject);
begin
  Self.btnSendMsg.Prop.IsPushed:=Trim(Self.memMsgInput.Text)<>'';
  Self.btnSendMsg.Enabled:=Trim(Self.memMsgInput.Text)<>'';

  SyncHeight;
end;

procedure TFrameChatInput.memMsgInputStayClick(Sender: TObject);
begin
  ShowVirtualKeyboard(memMsgInput);
end;

procedure TFrameChatInput.SyncHeight;
begin
    Height:=Self.pnlInput.Height;
end;

procedure TFrameChatInput.tmrSyncMemoHeightTimer(Sender: TObject);
var
  I:Integer;
  ARect:TRectF;
  ALineCount:Integer;
  ATotalLine:Integer;
begin
  ATotalLine:=0;
  for I := 0 to memMsgInput.Lines.Count-1 do
  begin
    if Trim(memMsgInput.Lines[I])<>'' then
    begin
      ARect:=RectF(0,0,memMsgInput.Width,memMsgInput.Height);
      //更新Memo的高度
      Self.memMsgInput.Canvas.MeasureText(ARect,
                                          memMsgInput.Lines[I],
                                          True,
                                          [],
                                          memMsgInput.TextSettings.VertAlign);
      ALineCount:=Ceil(ARect.Height
                      /Self.memMsgInput.Canvas.TextHeight(memMsgInput.Lines[I]));
      //判断行数
      ATotalLine:=ATotalLine+ALineCount;
    end
    else
    begin
      ATotalLine:=ATotalLine+1;
    end;
  end;

  if ATotalLine=0 then
  begin
    ATotalLine:=1;
  end;

  if ATotalLine<=Const_MaxMemoLineCount then
  begin
    //默认
    Self.pnlInput.Height:=ATotalLine*30+memMsgInput.Margins.Top+memMsgInput.Margins.Bottom;
  end
  else
  begin
    //最大
    Self.pnlInput.Height:=3*Const_MemoLineHeight+memMsgInput.Margins.Top+memMsgInput.Margins.Bottom;
  end;


  SyncHeight;
end;

end.
