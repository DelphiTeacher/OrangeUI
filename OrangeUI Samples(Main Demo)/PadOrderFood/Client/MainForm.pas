//convert pas to utf8 by ¥

unit MainForm;

interface


{$I Config.inc}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

         //['{41913539-A5A2-4D6D-9AAE-DCEB9B9B0DC5}']
  MessageBoxFrame,

  uComponentType,
  uFuncCommon,
  uUIFunction,
  uGraphicCommon,
//  uOpenClientCommon,

  uManager,
  ClientModuleUnit1,
  FMX.Platform,
  uDownloadPictureManager,
//  uNativeHttpControl,

  XSuperObject,
  XSuperJson,


  {$IFDEF ANDROID}
  FMX.Platform.Android,
  {$ENDIF}
  {$IFDEF ANDROID}
  AndroidApi.JNI.OS,
  AndroidApi.Helpers,

  {$ENDIF}


  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, IdBaseComponent, IdComponent,
  IdIPWatch, uSkinPanelType;

type
  TfrmMain = class(TForm)
    IdIPWatch1: TIdIPWatch;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;




implementation

{$R *.fmx}

uses
  MainFrame;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  {$IFDEF ANDROID}
  //自动判断是否是X86架构的CPU
  FMX.Types.Log.d('OrangeUI '+JStringToString(TJBuild.JavaClass.model));
  if Trim(JStringToString(TJBuild.JavaClass.model))='MI PAD 2' then
  begin
    //小米平板2
    uComponentType.IsAndroidIntelCPU:=True;
    FMX.Types.Log.d('OrangeUI Is AndroidIntelCPU');
  end
  else
  begin
    uComponentType.IsAndroidIntelCPU:=False;
    FMX.Types.Log.d('OrangeUI Is not AndroidIntelCPU');
  end;
  {$ENDIF}


  //主题颜色
  uGraphicCommon.SkinThemeColor:=$FF1F65C0;





//  //修复Android下的虚拟键盘隐藏和显示
//  GetGlobalVirtualKeyboardFixer.StartSync(Self);


end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  {$IFDEF MSWINDOWS}
  Self.ClientWidth:=1024;
  Self.ClientHeight:=600;
  {$ENDIF}



  //当前版本号
//  CurrentVersion:='1.1';
  //需要在工程设置中改版本号






  //等ClientModule创建才行
  {$IFDEF LOCALNETWORK}
  ClientModule.DSRestConnection1.Host:=
                                        {$IFDEF MSWINDOWS}
                                        Self.IdIPWatch1.LocalIP
                                        {$ELSE}
                                        '192.168.1.114'
                                        {$ENDIF}
                                        ;
  ServerUrl:='http://'+ClientModule.DSRestConnection1.Host+':7011';
  {$ELSE}
  ClientModule.DSRestConnection1.Host:='www.orangeui.cn';
  ServerUrl:='http://'+ClientModule.DSRestConnection1.Host+':7011';
  {$ENDIF}


//  //下载图片的类
//  DownloadPictureHttpControlClass:=TNativeHttpControl;


  //加载房间号服务员号
  GlobalManager.Load;


  //显示主界面
  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
  GlobalMainFrame.Load;

end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);

end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);

end;

end.
