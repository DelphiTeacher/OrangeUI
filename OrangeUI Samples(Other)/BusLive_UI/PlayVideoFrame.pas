//convert pas to utf8 by ¥
unit PlayVideoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyImage, uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uSkinFireMonkeyTrackBar, uSkinTrackBarType,
  uSkinButtonType, uSkinPanelType, uSkinImageType;

type
  TFramePlayVideo = class(TFrame)
    imgScreenShot: TSkinFMXImage;
    pnlBottom: TSkinFMXPanel;
    btnPlay: TSkinFMXButton;
    tbProgress: TSkinFMXTrackBar;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}

procedure TFramePlayVideo.btnReturnClick(Sender: TObject);
begin
  //返回半屏播放

end;

end.
