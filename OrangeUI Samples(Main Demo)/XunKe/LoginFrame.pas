//convert pas to utf8 by ¥

unit LoginFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyButton,
  uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel,
  Math,
  uBaseLog,
  uUIFunction, uSkinFireMonkeyPanel, uSkinFireMonkeyFrameImage, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox,
  uSkinFireMonkeyListView, uSkinAnimator, FMX.Controls.Presentation,
  uSkinImageList, uDrawPicture,
  uSkinFireMonkeyScrollBoxContent, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBox, uSkinMaterial, uSkinEditType, uSkinButtonType,
  uSkinLabelType, uSkinFrameImageType, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinPanelType, uBaseSkinControl, uSkinImageType;

type
  TFrameLogin = class(TFrame
//                          ,IFrameVirtualKeyboardEvent
                          )
    imgBackground: TSkinFMXImage;
    imglistHead: TSkinImageList;
    pnlVirtualKeyboard: TSkinFMXPanel;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    edtUser: TSkinFMXEdit;
    edtPass: TSkinFMXEdit;
    btnLogin: TSkinFMXButton;
    edmLogin: TSkinEditDefaultMaterial;
    imglistLogin: TSkinImageList;
    imglistThird: TSkinImageList;
    imglistCenterButton: TSkinImageList;
    bdmCenterButton: TSkinButtonDefaultMaterial;
    SkinFMXButton4: TSkinFMXButton;
    SkinFMXButton5: TSkinFMXButton;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    pnlLogo: TSkinFMXPanel;
    imgHead: TSkinFMXFrameImage;
    SkinFMXFrameImage1: TSkinFMXFrameImage;
    SkinFMXFrameImage2: TSkinFMXFrameImage;
    pnlLoginType: TSkinFMXPanel;
    lblOtherWay: TSkinFMXLabel;
    pnlDevideLeft: TSkinFMXPanel;
    pnlDevideRight: TSkinFMXPanel;
    SkinFMXImage3: TSkinFMXImage;
    SkinFMXImage4: TSkinFMXImage;
    SkinFMXImage5: TSkinFMXImage;
    procedure imgBackgroundResize(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalLoginFrame:TFrameLogin;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame;

{ TFrameLogin }

procedure TFrameLogin.DoVirtualKeyboardHide(KeyboardVisible: Boolean;const Bounds: TRect);
begin
  uBaseLog.OutputDebugString('TFrameLogin.DoVirtualKeyboardHide Begin '+FloatToStr(Self.sbClient.Height));
  Self.pnlVirtualKeyboard.Height:=0;
  Self.sbClient.Prop.UpdateScrollBars;
  uBaseLog.OutputDebugString('TFrameLogin.DoVirtualKeyboardHide End '+FloatToStr(Self.sbClient.Height));
end;

procedure TFrameLogin.DoVirtualKeyboardShow(KeyboardVisible: Boolean;const Bounds: TRect);
var
  AFixTop:Double;
begin
  if Bounds.Height-GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight
      >Self.pnlVirtualKeyboard.Height then
  begin
    Self.pnlVirtualKeyboard.Height:=RectHeight(Bounds)-GetGlobalVirtualKeyboardFixer.VirtualKeyboardHideHeight;
    //计算出合理的位置
    AFixTop:=Self.btnLogin.Top+Self.btnLogin.Height-Self.pnlVirtualKeyboard.Top;
    Self.sbClient.VertScrollBar.Properties.Position:=AFixTop;
  end;
end;

procedure TFrameLogin.FrameResize(Sender: TObject);
begin
  Self.sbcClient.Height:=frmMain.ClientHeight;
end;

procedure TFrameLogin.btnLoginClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //显示主界面
  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application,True,True);
//  GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
end;

constructor TFrameLogin.Create(AOwner: TComponent);
begin
  inherited;
  Self.pnlVirtualKeyboard.Height:=0;
  Self.sbcClient.Height:=Max(frmMain.ClientHeight,frmMain.ClientWidth);
end;

procedure TFrameLogin.imgBackgroundResize(Sender: TObject);
begin
  Self.pnlLogo.Left:=Ceil(Width-Self.pnlLogo.Width) div 2;
  Self.pnlLoginType.Left:=Ceil(Width-Self.pnlLoginType.Width) div 2;
end;

end.
