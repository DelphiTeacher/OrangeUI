//convert pas to utf8 by ¥

unit ImageListPalyerFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinImageList,

  uLang,
  uFrameContext,
  uSkinFireMonkeyFrameImage, uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyDrawPanel, uSkinFireMonkeyProgressBar,
  uSkinFireMonkeyImageListViewer, uSkinFireMonkeyPullLoadPanel, FMX.Objects, FMX.ListBox, FMX.Layouts, FMX.Memo, uSkinFireMonkeyMemo, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinPageControlType, uSkinFireMonkeyPageControl, uSkinFireMonkeyNotifyNumberIcon,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyScrollBar,
  uSkinFireMonkeyTrackBar, uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinFireMonkeyImageListPlayer, FMX.TabControl,
  uDrawPicture, uSkinImageListPlayerType, uBaseSkinControl, uSkinLabelType;

type
  TFrameImageListPlayer = class(TFrame,IFrameChangeLanguageEvent)
    imlistLoading1: TSkinImageList;
    imglistLoading: TSkinImageList;
    lblImageListPlayerCanDisplayPictureInImageList: TSkinFMXLabel;
    ilpLoading: TSkinFMXImageListPlayer;
    ilpLoading1: TSkinFMXImageListPlayer;
    imlistLoading2: TSkinImageList;
    ilpLoading2: TSkinFMXImageListPlayer;
  private
    { Private declarations }
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameImageListPlayer }

procedure TFrameImageListPlayer.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblImageListPlayerCanDisplayPictureInImageList.Text:=
    GetLangString(Self.lblImageListPlayerCanDisplayPictureInImageList.Name,ALangKind);

end;

constructor TFrameImageListPlayer.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblImageListPlayerCanDisplayPictureInImageList.Name,
      [Self.lblImageListPlayerCanDisplayPictureInImageList.Text,
      'Can loop pictures in imagelist']);
end;

end.

