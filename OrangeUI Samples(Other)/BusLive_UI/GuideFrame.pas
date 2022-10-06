//convert pas to utf8 by ¥
unit GuideFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinImageList,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyImageListViewer,
  uSkinFireMonkeySwitchPageListPanel,
  uUIFunction,
  IniFiles,
  uFileCommon,
  BusLiveCommonSkinMaterialModule,
  uSkinPageControlType,
  uSkinFireMonkeyPageControl,
  uSkinFireMonkeyButton,
  uDrawPicture, uSkinButtonType, uSkinScrollControlType,
  uSkinImageListViewerType;

type
  TFrameGuide = class(TFrame)
    imglistGuide: TSkinImageList;
    tmrGoToHomeFrame: TTimer;
    imgGuide: TSkinFMXImageListViewer;
    btngroupGuide: TSkinFMXButtonGroup;
    btnGo: TSkinFMXButton;
    procedure btnGoClick(Sender: TObject);
    procedure tmrGoToHomeFrameTimer(Sender: TObject);
    procedure imgGuideImageListSwitchEnd(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;

    procedure GoToHomeFrame;
    { Public declarations }
  end;

var
  GlobalGuideFrame:TFrameGuide;

implementation

{$R *.fmx}
uses
  MainForm;


{ TFrameGuide }

constructor TFrameGuide.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  Self.imgGuide.Properties.Picture.ImageIndex:=0;
//  Self.SkinFMXPageControl1.Properties.Orientation:=toNone;
//
//  Self.SkinFMXPageControl1.Properties.TabHeaderHeight:=0;
//  Self.SkinFMXPageControl1.Properties.ActivePageIndex:=0;
//
//  Self.SkinFMXPageControl1.Properties.SwitchPageListControlGestureManager.ControlGestureManager.ScrollingToInitialAnimator.Speed:=3;
//  Self.SkinFMXPageControl1.Properties.SwitchPageListControlGestureManager.ControlGestureManager.InertiaScrollAnimator.Speed:=3;
//
//  Self.SkinFMXPageControl1.Properties.SwitchPageListControlGestureManager.GestureSwitchLooped:=False;
//  Self.SkinFMXPageControl1.Properties.SwitchPageListControlGestureManager.CanGestureSwitchDistance:=0.1;
//
//
//  //首面停两秒
//  Self.tmrEnabled.Enabled:=True;
//  Self.SkinFMXPageControl1.Properties.SwitchPageListControlGestureManager.CanGestureSwitch:=False;//True;
end;

procedure TFrameGuide.FrameResize(Sender: TObject);
begin
  btnGO.Left:=(Self.Width-btnGO.Width) / 2;
  Self.btngroupGuide.Left:=(Self.Width-Self.btngroupGuide.Width)/2;
end;

procedure TFrameGuide.GoToHomeFrame;
var
  AIniFile:TIniFile;
begin
  AIniFile:=TIniFile.Create(uFileCommon.GetApplicationPath+'Config.ini');
  AIniFile.WriteBool('','IsFirstRunApp',False);
  AIniFile.Free;

  HideFrame;//(Self);
  //显示主界面
  frmMain.ShowHomeFrame;

end;

procedure TFrameGuide.imgGuideImageListSwitchEnd(Sender: TObject);
begin
//  if Self.imgGuide.Properties.Picture.ImageIndex=3 then
//  begin
    Self.tmrGoToHomeFrame.Enabled:=Self.imgGuide.Properties.Picture.ImageIndex=3;
//  end;
end;

procedure TFrameGuide.btnGoClick(Sender: TObject);
begin
  GoToHomeFrame;
end;

procedure TFrameGuide.tmrGoToHomeFrameTimer(Sender: TObject);
begin
  Self.tmrGoToHomeFrame.Enabled:=False;
  GoToHomeFrame;
end;

end.
