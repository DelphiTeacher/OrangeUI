//convert pas to utf8 by ¥

unit ImageListViewerFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinImageList, uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,

  uLang,
//  FMX.Types,
  uFrameContext,
  uSkinFireMonkeyImageListViewer, uDrawPicture, FMX.TabControl,
  uSkinFireMonkeyButton, FMX.Controls.Presentation, uSkinButtonType,
  uBaseSkinControl, uSkinScrollControlType, uSkinImageListViewerType;

type
  TFrameImageListViewer = class(TFrame,IFrameChangeLanguageEvent)
    imglistWelcome: TSkinImageList;
    tcImageListViewer: TTabControl;
    tabCommon: TTabItem;
    imglistviewerCommon: TSkinFMXImageListViewer;
    imglistPlayer: TSkinImageList;
    SkinImageList1: TSkinImageList;
    Panel1: TPanel;
    Button1: TButton;
    SkinImageList2: TSkinImageList;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    procedure btnDeleteFirstPictureClick(Sender: TObject);
    procedure btnClearImageListClick(Sender: TObject);
    procedure imglistviewerBindButtonGroupImageListSwitchBegin(Sender: TObject;
      ABeforeIndex, AAfterIndex: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    Constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;



implementation



{$R *.fmx}

{ TFrameImageListViewer }

procedure TFrameImageListViewer.btnDeleteFirstPictureClick(Sender: TObject);
begin
  //删除第一张图片
  Self.imglistPlayer.PictureList.Delete(0);
end;

procedure TFrameImageListViewer.btnClearImageListClick(Sender: TObject);
begin
  //清除所有图片
  Self.imglistPlayer.PictureList.Clear(True);
end;

procedure TFrameImageListViewer.Button1Click(Sender: TObject);
var
  Handled:Boolean;
  EventInfo: TGestureEventInfo;
begin
  //模拟手势绽放
  EventInfo.GestureID := igiZoom;
  EventInfo.Distance:=0;
  EventInfo.Flags:=[TInteractiveGestureFlag.gfBegin];
  imglistviewerCommon.SkinControlType.Gesture(EventInfo,Handled);


  EventInfo.Distance:=80;
  EventInfo.Flags:=[];
  imglistviewerCommon.SkinControlType.Gesture(EventInfo,Handled);

  EventInfo.Distance:=0;
  EventInfo.Flags:=[TInteractiveGestureFlag.gfEnd];
  imglistviewerCommon.SkinControlType.Gesture(EventInfo,Handled);
  imglistviewerCommon.Invalidate;
end;

procedure TFrameImageListViewer.Button2Click(Sender: TObject);
var
  Handled:Boolean;
  EventInfo: TGestureEventInfo;
begin
  //两个手指所在的位置
//  gFormTouch1.X:=10;//imglistviewerCommon.Width/2-10;
//  gFormTouch1.Y:=10;//imglistviewerCommon.Height/2;
//
//  gFormTouch2.X:=50;//imglistviewerCommon.Width/2+10;
//  gFormTouch2.Y:=50;//imglistviewerCommon.Height/2;

  gFormTouch1.X:=114-30;//imglistviewerCommon.Width/2-10;
  gFormTouch1.Y:=184;//imglistviewerCommon.Height/2;

  gFormTouch2.X:=114+30;//imglistviewerCommon.Width/2+10;
  gFormTouch2.Y:=184;//imglistviewerCommon.Height/2;


//  gFormTouch1.X:=imglistviewerCommon.Width/2-30;
//  gFormTouch1.Y:=imglistviewerCommon.Height/2;
//
//  gFormTouch2.X:=imglistviewerCommon.Width/2+30;
//  gFormTouch2.Y:=imglistviewerCommon.Height/2;


  EventInfo.GestureID := igiZoom;
  EventInfo.Distance:=0;
  EventInfo.Flags:=[TInteractiveGestureFlag.gfBegin];
  imglistviewerCommon.SkinControlType.Gesture(EventInfo,Handled);
  imglistviewerCommon.Invalidate;

end;

procedure TFrameImageListViewer.Button3Click(Sender: TObject);
var
  Handled:Boolean;
  EventInfo: TGestureEventInfo;
begin
  //模拟手势绽放
  EventInfo.GestureID := igiZoom;
  EventInfo.Distance:=0;
  EventInfo.Flags:=[TInteractiveGestureFlag.gfBegin];
  imglistviewerCommon.SkinControlType.Gesture(EventInfo,Handled);


  EventInfo.Distance:=-80;
  EventInfo.Flags:=[];
  imglistviewerCommon.SkinControlType.Gesture(EventInfo,Handled);

  EventInfo.Distance:=0;
  EventInfo.Flags:=[TInteractiveGestureFlag.gfEnd];
  imglistviewerCommon.SkinControlType.Gesture(EventInfo,Handled);
  imglistviewerCommon.Invalidate;

end;

procedure TFrameImageListViewer.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.tabCommon.Text:=
    GetLangString(Self.tabCommon.Name,ALangKind);


end;

constructor TFrameImageListViewer.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.tabCommon.Name,
      [Self.tabCommon.Text,
      'Common']);
  imglistviewerCommon.Prop.ContentWidth:=-1;
  imglistviewerCommon.Prop.ContentHeight:=-1;
end;

procedure TFrameImageListViewer.imglistviewerBindButtonGroupImageListSwitchBegin(
  Sender: TObject; ABeforeIndex, AAfterIndex: Integer);
begin
  //
  //FMX.Types.Log.d(IntToStr(ABeforeIndex)+' -> '+IntToStr(AAfterIndex));
end;

end.
