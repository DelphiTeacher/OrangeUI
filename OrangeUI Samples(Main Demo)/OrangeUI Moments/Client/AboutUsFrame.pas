//convert pas to utf8 by ¥

unit AboutUsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uMobileUtils,
  uBaseHttpControl,
  ClientModuleUnit1,
  FriendCircleCommonMaterialDataMoudle,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel, uSkinLabelType, uSkinImageType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uBaseSkinControl, uSkinPanelType;

type
  TFrameAboutUs = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXScrollBox1: TSkinFMXScrollBox;
    SkinFMXScrollBoxContent1: TSkinFMXScrollBoxContent;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXPanel2: TSkinFMXPanel;
    lblVersion: TSkinFMXLabel;
    lblUrl: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lblUrlClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


var
  GlobalAboutUsFrame:TFrameAboutUs;

implementation

uses
  MainForm;


{$R *.fmx}

procedure TFrameAboutUs.btnReturnClick(Sender: TObject);
begin

  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

constructor TFrameAboutUs.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TFrameAboutUs.lblUrlClick(Sender: TObject);
begin
  uMobileUtils.OpenWebBrowserAndNavigateURL(
      'www.orangeui.cn');
end;

end.
