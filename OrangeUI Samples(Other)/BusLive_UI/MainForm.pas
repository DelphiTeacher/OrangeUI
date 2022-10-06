//convert pas to utf8 by ¥
unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uUIFunction,
  IniFiles,
  GuideFrame,
  HomeFrame,
//  uUIFunction,
  uFileCommon,
  uComponentType,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinPanelType;

type
  TfrmMain = class(TForm)
    pnlVirtualKeyBoard: TSkinFMXPanel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
  private
    { Private declarations }
  public
    procedure ShowHomeFrame;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  //在Windows平台下的模拟虚拟键盘控件
  SimulateWindowsVirtualKeyboardHeight:=160;
  IsSimulateVirtualKeyboardOnWindows:=True;
  GlobalAutoProcessVirtualKeyboardControlClass:=TSkinFMXPanel;
  GlobalAutoProcessVirtualKeyboardControl:=pnlVirtualKeyBoard;
  GlobalAutoProcessVirtualKeyboardControl.Visible:=False;


  {$IFNDEF MSWINDOWS}
  pnlVirtualKeyBoard.SelfOwnMaterialToDefault.IsTransparent:=True;
  pnlVirtualKeyBoard.Caption:='';
  {$ENDIF}


end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  AIniFile:TIniFile;
  AIsFirstRunApp:Boolean;
begin
//  GetGlobalVirtualKeyboardFixer.StartSync(Self);

  AIniFile:=TIniFile.Create(uFileCommon.GetApplicationPath+'Config.ini');
  AIsFirstRunApp:=AIniFile.ReadBool('','IsFirstRunApp',True);
  AIniFile.Free;

  if AIsFirstRunApp then
  begin
    //显示引导界面
    ShowFrame(TFrame(GlobalGuideFrame),TFrameGuide,Self,nil,nil,nil,Application,False);
//    GlobalGuideFrame.FrameHistroy:=CurrentFrameHistroy;
  end
  else
  begin
    //显示主界面
    ShowHomeFrame;
  end;

end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.ShowHomeFrame;
begin
  //显示主界面
  ShowFrame(TFrame(GlobalHomeFrame),TFrameHome,frmMain,nil,nil,nil,Application);
//  GlobalHomeFrame.FrameHistroy:=CurrentFrameHistroy;
end;





end.
