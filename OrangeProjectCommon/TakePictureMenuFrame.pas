//convert pas to utf8 by ¥

unit TakePictureMenuFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,


  uUIFunction,
  uVersion,
  uSkinItems,

  uFuncCommon,
  uLang,
  uBaseLog,
  uFrameContext,
  uSkinFireMonkeyEdit,
  uSkinFireMonkeyMemo,
  uProcessNativeControlModalShowPanel,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, FMX.Controls.Presentation,
  uSkinAnimator, uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, FMX.MediaLibrary.Actions, System.Actions,
  FMX.ActnList, FMX.StdActns, uSkinFireMonkeyCustomList, uSkinButtonType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uBaseSkinControl, uSkinPanelType, uDrawCanvas;


type
  THideMenuType=(hmtNone,hmtHasPicture);
  TTakedPictureEvent=procedure(Sender:TObject;ABitmap:TBitmap) of object;

  TFrameTakePictureMenu = class(TFrame,
                                IFrameChangeLanguageEvent,
                                IFrameHistroyReturnEvent)
    pnlBackground: TSkinFMXPanel;
    pnlBottom: TSkinFMXPanel;
    lbMenu: TSkinFMXListBox;
    scmaPopup: TSkinControlMoveAnimator;
    ActionList: TActionList;
    ActionTakePhotoFromLibrary: TTakePhotoFromLibraryAction;
    ActionTakePhotoFromCamera: TTakePhotoFromCameraAction;
    btnUseInIPadSetPosition: TSkinFMXButton;
    procedure FrameResize(Sender: TObject);
    procedure pnlBackgroundClick(Sender: TObject);
    procedure ActionTakePhotoFromLibraryDidFinishTaking(Image: TBitmap);
    procedure ActionTakePhotoFromCameraDidFinishTaking(Image: TBitmap);
    procedure lbMenuClickItem(Sender: TSkinItem);
    procedure scmaPopupAnimateEnd(Sender: TObject);
  private
    HideMenuType:THideMenuType;

    procedure TakePhotoFromCamera;
    procedure TakePhotoFromAlbum;
    { Private declarations }
  protected
    procedure ChangeLanguage(ALangKind:TLangKind);
  protected
    function CanReturn:TFrameReturnActionType;
  public
    FRawBitmap: TBitmap;
    OnTakedPicture:TTakedPictureEvent;
    FOnCustomPickPhoto:TNotifyEvent;

    procedure HideMenu;
    procedure ShowMenu;
  public
    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;



var
  GlobalTakePictureMenuFrame:TFrameTakePictureMenu;

procedure CopyBitmap(ASrcBitmap:TBitmap;ADestBitmap:TBitmap);

implementation

procedure CopyBitmap(ASrcBitmap:TBitmap;ADestBitmap:TBitmap);
begin
  ADestBitmap.SetSize(ASrcBitmap.Width,ASrcBitmap.Height);
  ADestBitmap.Canvas.BeginScene();
  try
    ADestBitmap.Canvas.Clear(0);
    ADestBitmap.Canvas.DrawBitmap(
            ASrcBitmap,
            RectF(0,0,ASrcBitmap.Width,ASrcBitmap.Height),
            RectF(0,0,ADestBitmap.Width,ADestBitmap.Height),
            1
            );
  finally
    ADestBitmap.Canvas.EndScene;
  end;
end;


{$R *.fmx}



{ TFrameTakePictureMenu }

procedure TFrameTakePictureMenu.TakePhotoFromAlbum;
var
  Image:TBitmap;
  OpenDialog: TOpenDialog;
  I: Integer;
begin
  //如果图片是空的,那么添加
  //弹出菜单
//  uBaseLog.OutputDebugString('拍照','');
  //拍照
  {$IFDEF MSWINDOWS}
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := TBitmapCodecManager.GetFilterString;
    OpenDialog.Options:=OpenDialog.Options+[TOpenOption.ofAllowMultiSelect];
    if OpenDialog.Execute then
    begin
      for I := 0 to OpenDialog.Files.Count-1 do
      begin
        Image:=TBitmap.CreateFromFile(OpenDialog.Files[I]);
        ActionTakePhotoFromLibraryDidFinishTaking(Image);
        FreeAndNil(Image);
      end;
    end;
  finally
    FreeAndNil(OpenDialog);
  end;
  {$ENDIF}
  {$IFNDEF MSWINDOWS}
  //btnUseInIPadSetPosition在IPAD中用于设置位置
  ActionTakePhotoFromLibrary.ExecuteTarget(btnUseInIPadSetPosition);
  {$ENDIF}
end;

procedure TFrameTakePictureMenu.TakePhotoFromCamera;
var
  Image:TBitmap;
  OpenDialog: TOpenDialog;
  I: Integer;
begin
  //如果图片是空的,那么添加
  //弹出菜单
//  uBaseLog.OutputDebugString('拍照','');
  //拍照
  {$IFDEF MSWINDOWS}
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := TBitmapCodecManager.GetFilterString;
    OpenDialog.Options:=OpenDialog.Options+[TOpenOption.ofAllowMultiSelect];
    if OpenDialog.Execute then
    begin
      for I := 0 to OpenDialog.Files.Count-1 do
      begin
        Image:=TBitmap.CreateFromFile(OpenDialog.Files[I]);
        ActionTakePhotoFromLibraryDidFinishTaking(Image);
        FreeAndNil(Image);
      end;
    end;
  finally
    FreeAndNil(OpenDialog);
  end;
  {$ENDIF}
  {$IFNDEF MSWINDOWS}
  try
    ActionTakePhotoFromCamera.ExecuteTarget(Self);
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'ActionTakePhotoFromCamera.ExecuteTarget');
    end;
  end;
  {$ENDIF}
end;

procedure TFrameTakePictureMenu.ActionTakePhotoFromCameraDidFinishTaking(Image: TBitmap);
//var
//  ScaleFactor: Single;
begin
  //拍照返回

//  //照片返回
//  if Image.Width > 1024 then
//  begin
//    ScaleFactor := Image.Width / 1024;
//    Image.Resize(Round(Image.Width / ScaleFactor), Round(Image.Height / ScaleFactor));
//  end;
//  FRawBitmap.Assign(Image);
  CopyBitmap(Image,FRawBitmap);



  //隐藏弹出菜单
  HideMenuType:=hmtHasPicture;
  HideMenu;

end;

procedure TFrameTakePictureMenu.ActionTakePhotoFromLibraryDidFinishTaking(Image: TBitmap);
//var
//  ScaleFactor: Single;
begin
  //相册返回

//  //照片返回
//  if Image.Width > 1024 then
//  begin
//    ScaleFactor := Image.Width / 1024;
//    Image.Resize(Round(Image.Width / ScaleFactor), Round(Image.Height / ScaleFactor));
//  end;
//  FRawBitmap.Assign(Image);
  CopyBitmap(Image,FRawBitmap);

  //隐藏弹出菜单
  HideMenuType:=hmtHasPicture;
  HideMenu;

end;

procedure TFrameTakePictureMenu.HideMenu;
begin
  scmaPopup.GoForward;
end;

procedure TFrameTakePictureMenu.ShowMenu;
begin

  FOnCustomPickPhoto:=nil;
  lbMenu.Position.Y := lbMenu.Height;
  scmaPopup.p:=lbMenu.Height;


  //先隐藏原生控件
  //设置Edit的ControlType,避免MessageBoxFrame被原生控件挡住
  SetGlobalEditListAsStyleType;
  SetGlobalMemoListAsStyleType;
  ProcessNativeControlBeginModalShow;



  Self.pnlBackground.Visible:=True;
  Self.pnlBackground.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}None{$ELSE}alNone{$IFEND};
  Self.pnlBackground.SetBounds(0,0,Width,Height);
  Self.lbMenu.Width:=Width;
  Self.pnlBackground.BringToFront;
  scmaPopup.GoBackward;
end;

procedure TFrameTakePictureMenu.scmaPopupAnimateEnd(Sender: TObject);
begin
  if Self.scmaPopup.DirectionType=adtForward then
  begin
      //隐藏弹出菜单结束
      Self.pnlBackground.Visible:=False;
      Self.Visible:=False;




      //一定要放在隐藏WaitingFrame的后面
      //还原所有的Edit的ControlType为Platform
      RestoreGlobalEditListAsPlatformType;
      RestoreGlobalMemoListAsPlatformType;
      //先隐藏WaitingFrame,再还原,免得WaitingFrame被盖住
      ProcessNativeControlEndModalShow;



      HideFrame;//(Self,hfcttBeforeReturnFrame,ufsefNone);
      ReturnFrame;//(Self);




      case HideMenuType of
        hmtHasPicture:
        begin

          if Assigned(FOnCustomPickPhoto) then
          begin
            FOnCustomPickPhoto(Self);
          end
          else
          begin
            if Assigned(OnTakedPicture) then
            begin
              OnTakedPicture(Self,FRawBitmap);
            end;
          end;



        end;
      end;


  end;
end;

function TFrameTakePictureMenu.CanReturn: TFrameReturnActionType;
begin
  if Self.Visible then
  begin

    //如果当前页面显示
    //要执行返回上一页
    //不允许执行返回上一页
    Result:=TFrameReturnActionType.fratCanNotReturn;
    //隐藏菜单
    HideMenu;

  end
  else
  begin

    //直接返回
    Result:=TFrameReturnActionType.fratDefault;

  end;
end;

procedure TFrameTakePictureMenu.ChangeLanguage(ALangKind: TLangKind);
const
  Langs_Button_Caption_Camera : array[Low(TLangKind)..High(TLangKind)] of string =
      ('拍照','Take Photo','');
  Langs_Button_Caption_Album : array[Low(TLangKind)..High(TLangKind)] of string =
      ('从相册选择','Select From Album','');
//  Langs_Button_Caption_Cancel : array[Low(TLangKind)..High(TLangKind)] of string =
//      ('从相册选择','Select From Album','');
  Langs_Button_Caption_CANCEL : array[Low(TLangKind)..High(TLangKind)] of string =
      ('取消','Cancel','');
begin
  //翻译
  Self.lbMenu.Properties.Items.FindItemByName('拍照').Caption:=Langs_Button_Caption_Camera[ALangKind];
  Self.lbMenu.Properties.Items.FindItemByName('从相册选择').Caption:=Langs_Button_Caption_Album[ALangKind];
  Self.lbMenu.Properties.Items.FindItemByName('取消').Caption:=Langs_Button_Caption_Cancel[ALangKind];
end;

constructor TFrameTakePictureMenu.Create(AOwner: TComponent);
begin
  inherited;
  FRawBitmap := TBitmap.Create(0, 0);


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameTakePictureMenu.Destroy;
begin
  FreeAndNil(FRawBitmap);
  inherited;
end;

procedure TFrameTakePictureMenu.FrameResize(Sender: TObject);
begin
  Self.pnlBackground.SetBounds(0,0,Width,Height);
  Self.lbMenu.Width:=Width;
end;

procedure TFrameTakePictureMenu.lbMenuClickItem(Sender: TSkinItem);
begin
  if TSkinItem(Sender).Name='拍照' then
  begin
    FOnCustomPickPhoto:=nil;
    TakePhotoFromCamera;
  end;
  if TSkinItem(Sender).Name='从相册选择' then
  begin
    if Assigned(FOnCustomPickPhoto) then
    begin
//      FOnCustomPickPhoto(Self);
//      HideMenuType:=hmtNone;
//      HideMenu;
      //隐藏弹出菜单
      HideMenuType:=hmtHasPicture;
      HideMenu;
    end
    else
    begin
      TakePhotoFromAlbum;
    end;
  end;
  if TSkinItem(Sender).Name='取消' then
  begin
    HideMenuType:=hmtNone;
    HideMenu;
  end;
end;

procedure TFrameTakePictureMenu.pnlBackgroundClick(Sender: TObject);
begin
  OnTakedPicture:=nil;
  HideMenuType:=hmtNone;
  HideMenu;
end;

end.



