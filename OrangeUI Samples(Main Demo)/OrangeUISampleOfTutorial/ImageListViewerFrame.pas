//convert pas to utf8 by ¥

unit ImageListViewerFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinImageList, uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,

  uLang,
  uFrameContext,
  uSkinFireMonkeyImageListViewer, uDrawPicture, FMX.TabControl,
  uSkinFireMonkeyButton, FMX.Controls.Presentation, uSkinButtonType,
  uBaseSkinControl, uSkinScrollControlType, uSkinImageListViewerType;

type
  TFrameImageListViewer = class(TFrame,IFrameChangeLanguageEvent)
    imglistWelcome: TSkinImageList;
    tcImageListViewer: TTabControl;
    tabCommon: TTabItem;
    tabBindButtonGroup: TTabItem;
    imglistviewerCommon: TSkinFMXImageListViewer;
    imglistPlayer: TSkinImageList;
    imglistviewerBindButtonGroup: TSkinFMXImageListViewer;
    btngroupIndicator: TSkinFMXButtonGroup;
    btnDeleteFirstPicture: TButton;
    btnClearImageList: TButton;
    btnSwitchImageList: TButton;
    lblTestImageListChangeThenButtonCountChange: TLabel;
    procedure btnDeleteFirstPictureClick(Sender: TObject);
    procedure btnClearImageListClick(Sender: TObject);
    procedure btnSwitchImageListClick(Sender: TObject);
    procedure imglistviewerBindButtonGroupImageListSwitchBegin(Sender: TObject;
      ABeforeIndex, AAfterIndex: Integer);
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

procedure TFrameImageListViewer.btnSwitchImageListClick(Sender: TObject);
begin
  //切换ImageList
  if Self.imglistviewerBindButtonGroup.Prop.Picture.SkinImageList<>imglistWelcome then
  begin
    Self.imglistviewerBindButtonGroup.Prop.Picture.SkinImageList:=Self.imglistWelcome;
  end
  else
  begin
    Self.imglistviewerBindButtonGroup.Prop.Picture.SkinImageList:=Self.imglistPlayer;
  end;
end;

procedure TFrameImageListViewer.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.tabCommon.Text:=
    GetLangString(Self.tabCommon.Name,ALangKind);
  Self.tabBindButtonGroup.Text:=
    GetLangString(Self.tabBindButtonGroup.Name,ALangKind);

  Self.lblTestImageListChangeThenButtonCountChange.Text:=
    GetLangString(Self.lblTestImageListChangeThenButtonCountChange.Name,ALangKind);

  Self.btnDeleteFirstPicture.Text:=
    GetLangString(Self.btnDeleteFirstPicture.Name,ALangKind);
  Self.btnClearImageList.Text:=
    GetLangString(Self.btnClearImageList.Name,ALangKind);
  Self.btnSwitchImageList.Text:=
    GetLangString(Self.btnSwitchImageList.Name,ALangKind);

end;

constructor TFrameImageListViewer.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.tabCommon.Name,
      [Self.tabCommon.Text,
      'Common']);
  RegLangString(Self.tabBindButtonGroup.Name,
      [Self.tabBindButtonGroup.Text,
      'Bind ButtonGroup']);

  RegLangString(Self.lblTestImageListChangeThenButtonCountChange.Name,
      [Self.lblTestImageListChangeThenButtonCountChange.Text,
      'Test button count same as picture count']);

  RegLangString(Self.btnDeleteFirstPicture.Name,
      [Self.btnDeleteFirstPicture.Text,
      'Delete first picture']);
  RegLangString(Self.btnClearImageList.Name,
      [Self.btnClearImageList.Text,
      'Clear ImageList']);
  RegLangString(Self.btnSwitchImageList.Name,
      [Self.btnSwitchImageList.Text,
      'Switch ImageList']);

end;

procedure TFrameImageListViewer.imglistviewerBindButtonGroupImageListSwitchBegin(
  Sender: TObject; ABeforeIndex, AAfterIndex: Integer);
begin
  //
  FMX.Types.Log.d(IntToStr(ABeforeIndex)+' -> '+IntToStr(AAfterIndex));
end;

end.
