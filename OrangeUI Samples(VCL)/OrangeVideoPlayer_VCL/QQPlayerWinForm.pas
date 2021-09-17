unit QQPlayerWinForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  MPlayer,
  pngimage,
  ExtCtrls,
  StdCtrls,
  Menus,
  ImgList,
  uSkinImageList,
  uDrawPicture,
  uDrawEngine, uSkinWindowsForm,uSkinWindowsControl, uSkinLabelType,
  uSkinImageType, uSkinTrackBarType, uSkinButtonType;

type
  TfrmQQPlayerWin = class(TForm)
    btnFoot: TSkinWinButton;
    btnStop: TSkinWinButton;
    btnPrior: TSkinWinButton;
    btnNext: TSkinWinButton;
    btnPlayPause: TSkinWinButton;
    SkinButton6: TSkinWinButton;
    SkinButton7: TSkinWinButton;
    btnSetting: TSkinWinButton;
    SkinButton9: TSkinWinButton;
    tbProgress: TSkinWinTrackBar;
    SkinTrackBar2: TSkinWinTrackBar;
    btnVoice: TSkinWinButton;
    btnSpeedLeft: TSkinWinButton;
    btnSpeedRight: TSkinWinButton;
    SkinImage1: TSkinWinImage;
    btnOpenFile: TSkinWinButton;
    btnOpenFileDropDown: TSkinWinButton;
    SkinLabel1: TSkinWinLabel;
    fsdQQPlayer: TSkinWinForm;
    tmrPlay: TTimer;
    procedure FormResize(Sender: TObject);
    procedure SkinFormButton1Click(Sender: TObject);
    procedure btnOpenFileDropDownClick(Sender: TObject);
    procedure tmrPlayTimer(Sender: TObject);
    procedure btnPlayPauseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmQQPlayerWin: TfrmQQPlayerWin;

implementation

{$R *.dfm}

procedure TfrmQQPlayerWin.btnPlayPauseClick(Sender: TObject);
begin
  if Self.btnPlayPause.Properties.IsPushed then
  begin
    Self.tmrPlay.Enabled:=True;
  end
  else
  begin
    Self.tmrPlay.Enabled:=False;
  end;
end;

procedure TfrmQQPlayerWin.FormResize(Sender: TObject);
begin
  btnStop.Left:=(Width-180) div 2;
//  SkinLabel1.Left:=btnStop.Left-SkinLabel1.Width;

  BtnPrior.Left:=btnStop.Left+btnStop.Width;
  btnPlayPause.Left:=BtnPrior.Left+BtnPrior.Width+2;
  btnNext.Left:=btnPlayPause.Left+btnPlayPause.Width+1;
  btnVoice.Left:=btnNext.Left+btnNext.Width+1;
  SkinTrackBar2.Left:=btnVoice.Left+btnVoice.Width+1;

  SkinImage1.Left:=(Width-SkinImage1.Width) div 2;
  SkinImage1.Top:=(Height-SkinImage1.Height-100) div 2;

  btnOpenFile.Left:=SkinImage1.Left+30;
  btnOpenFile.Top:=SkinImage1.Top+SkinImage1.Height;
  btnOpenFileDropDown.Left:=btnOpenFile.Left+btnOpenFile.Width;
  btnOpenFileDropDown.Top:=btnOpenFile.Top;

end;

procedure TfrmQQPlayerWin.btnOpenFileDropDownClick(Sender: TObject);
begin
//  Self.pmOpenFile.Popup(
//    Left+btnOpenFile.Left,
//    Top+btnOpenFile.Top+btnOpenFile.Height);
end;

procedure TfrmQQPlayerWin.SkinFormButton1Click(Sender: TObject);
begin
//  Self.pmMain.Popup(Left+SkinFormButton1.Left,Top+SkinFormButton1.Top+SkinFormButton1.Height);
end;

procedure TfrmQQPlayerWin.tmrPlayTimer(Sender: TObject);
begin
  Self.tbProgress.Properties.Position:=Self.tbProgress.Properties.Position+1;
  if Self.tbProgress.Properties.Position=Self.tbProgress.Properties.Max then
  begin
    Self.tbProgress.Properties.Position:=0;
    Self.tmrPlay.Enabled:=False;
    Self.btnPlayPause.Properties.IsPushed:=False;
  end;
end;

end.
