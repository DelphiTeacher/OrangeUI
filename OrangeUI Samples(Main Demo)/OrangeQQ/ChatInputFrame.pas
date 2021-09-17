//convert pas to utf8 by ¥

unit ChatInputFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  Math,
  uSkinItems,
  uUIFunction,
  QQCommonSkinMaterialFrame,

  uSkinFireMonkeyButton, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, FMX.MediaLibrary.Actions, System.Actions,
  FMX.ActnList, FMX.StdActns, uSkinFireMonkeyCustomList, uDrawCanvas,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinButtonType, uSkinPanelType;


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
    btnAdd: TSkinFMXButton;
    lvAddMenu: TSkinFMXListView;
    ActionList1: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    tmrSyncMemoHeight: TTimer;
    procedure memMsgInputChangeTracking(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnSendMsgClick(Sender: TObject);
    procedure lvAddMenuClickItem(Sender: TSkinItem);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure memMsgInputStayClick(Sender: TObject);
    procedure tmrSyncMemoHeightTimer(Sender: TObject);
  private
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
    { Private declarations }
  public
    OnSendBitmapClick:TSendBitmapClickEvent;
    OnSendMsgButtonClick:TNotifyEvent;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure SyncHeight;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameChatInput }

procedure TFrameChatInput.btnAddClick(Sender: TObject);
begin
  //跳出选择图片窗体
  if Not lvAddMenu.Visible then
  begin
    HideVirtualKeyboard;

    lvAddMenu.Visible:=True;
    SyncHeight;
  end
  else
  begin
    lvAddMenu.Visible:=False;

    SyncHeight;
  end;
end;

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
  Self.btnAdd.Visible:=True;
  Self.btnSendMsg.Visible:=False;

  lvAddMenu.Visible:=False;
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
  Self.lvAddMenu.Visible:=False;
  SyncHeight;
end;

procedure TFrameChatInput.lvAddMenuClickItem(Sender: TSkinItem);
var
  I: Integer;
  Image:TBitmap;
  OpenDialog: TOpenDialog;
begin
  if TSkinItem(Sender).Caption='照片' then
  begin
    {$IFDEF MSWINDOWS}
    //如果图片是空的,那么添加
    //拍照
    OpenDialog := TOpenDialog.Create(nil);
    try
      OpenDialog.Filter := TBitmapCodecManager.GetFilterString;
      OpenDialog.Options:=OpenDialog.Options+[TOpenOption.ofAllowMultiSelect];
      if OpenDialog.Execute then
      begin
        for I := 0 to OpenDialog.Files.Count-1 do
        begin
          Image:=TBitmap.CreateFromFile(OpenDialog.Files[I]);
          TakePhotoFromLibraryAction1DidFinishTaking(Image);
          FreeAndNil(Image);
        end;
      end;
    finally
      FreeAndNil(OpenDialog);
    end;
    {$ELSE}
    //照片
    Self.TakePhotoFromLibraryAction1.ExecuteTarget(Self);
    {$ENDIF}

  end;
  if TSkinItem(Sender).Caption='拍照' then
  begin
    //拍照
    Self.TakePhotoFromCameraAction1.ExecuteTarget(Self);
  end;

end;

procedure TFrameChatInput.memMsgInputChangeTracking(Sender: TObject);
begin
  Self.btnSendMsg.Prop.IsPushed:=Trim(Self.memMsgInput.Text)<>'';
  Self.btnSendMsg.Enabled:=Trim(Self.memMsgInput.Text)<>'';
  Self.btnSendMsg.Visible:=Trim(Self.memMsgInput.Text)<>'';
  Self.btnAdd.Visible:=Trim(Self.memMsgInput.Text)='';

  SyncHeight;
end;

procedure TFrameChatInput.memMsgInputStayClick(Sender: TObject);
begin
  ShowVirtualKeyboard(memMsgInput);
end;

procedure TFrameChatInput.SyncHeight;
begin
  if lvAddMenu.Visible then
  begin
    Height:=Self.pnlInput.Height+lvAddMenu.Height;
  end
  else
  begin
    Height:=Self.pnlInput.Height;
  end;
end;

procedure TFrameChatInput.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  //拍照返回
  if Assigned(OnSendBitmapClick) then
  begin
    OnSendBitmapClick(Self,Image);
  end;
end;

procedure TFrameChatInput.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  //相册返回
  if Assigned(OnSendBitmapClick) then
  begin
    OnSendBitmapClick(Self,Image);
  end;
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
