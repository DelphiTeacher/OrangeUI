//convert pas to utf8 by ¥

unit RoundImageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyRoundImage,

  uLang,
  uSkinPicture,
  uFrameContext,
  uSkinFireMonkeyImage, uSkinFireMonkeyButton, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uDrawPicture,
  uSkinImageList, FMX.Objects, FMX.TabControl, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, uSkinFireMonkeyCustomList, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinPanelType, uBaseSkinControl,
  uSkinImageType, uSkinRoundImageType, uDrawCanvas, uSkinItems, FMX.Layouts;

type
  TFrameRoundImage = class(TFrame,IFrameChangeLanguageEvent)
    imglistHead: TSkinImageList;
    tcRoundImage: TTabControl;
    tabCommon: TTabItem;
    tabBindItem: TTabItem;
    lbMessageList: TSkinFMXListBox;
    ItemMessage: TSkinFMXItemDesignerPanel;
    imgMessageHead: TSkinFMXRoundImage;
    lblMessageNickName: TSkinFMXLabel;
    lblMessageDetail: TSkinFMXLabel;
    lblMessageTime: TSkinFMXLabel;
    ScrollBox1: TScrollBox;
    imgItemBigPic: TSkinFMXRoundImage;
    imgRoundImageAddBorderByPanel: TSkinFMXRoundImage;
    pnlRoundImageBorder: TSkinFMXPanel;
    imgRoundImageCanSetClipRect: TSkinFMXRoundImage;
    imgRoundImageCanSetColorThatOutOfClipRect: TSkinFMXRoundImage;
    imgRoundImageSameColor: TSkinFMXRoundImage;
    lblRoundImageAddBorderByPanel: TLabel;
    lblRoundImageCanSetClipRect: TLabel;
    lblRoundImageCanSetColorThatOutOfClipRect: TLabel;
    lblRoundImageSetSameColor: TLabel;
    RoundRect1: TRoundRect;
    SkinFMXImage1: TSkinFMXImage;
  private
    { Private declarations }
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameRoundImage }

procedure TFrameRoundImage.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.tabCommon.Text:=
    GetLangString(Self.tabCommon.Name,ALangKind);
  Self.tabBindItem.Text:=
    GetLangString(Self.tabBindItem.Name,ALangKind);

  Self.lblRoundImageCanSetColorThatOutOfClipRect.Text:=
    GetLangString(Self.lblRoundImageCanSetColorThatOutOfClipRect.Name,ALangKind);
  Self.lblRoundImageCanSetClipRect.Text:=
    GetLangString(Self.lblRoundImageCanSetClipRect.Name,ALangKind);
  Self.lblRoundImageSetSameColor.Text:=
    GetLangString(Self.lblRoundImageSetSameColor.Name,ALangKind);
  Self.lblRoundImageAddBorderByPanel.Text:=
    GetLangString(Self.lblRoundImageAddBorderByPanel.Name,ALangKind);

  if ALangKind=lkEN then
  begin
    Self.lbMessageList.Prop.Items[0].Caption:='DelphiTeacher';
    Self.lbMessageList.Prop.Items[0].Detail:='Thanks for your support!';

    Self.lbMessageList.Prop.Items[1].Caption:='OrangeUI';
    Self.lbMessageList.Prop.Items[1].Detail:='Please contact me if you have any questions!';
  end;

end;

constructor TFrameRoundImage.Create(AOwner: TComponent);
var
  ARoundBitmap:TBitmap;
begin
  inherited;

  Self.tcRoundImage.ActiveTab:=tabCommon;


  //将Bitmap剪裁成圆形
  ARoundBitmap:=RoundSkinPicture(Self.imglistHead.PictureList[0]);
  Self.SkinFMXImage1.Prop.Picture.Assign(ARoundBitmap);
  FreeAndNil(ARoundBitmap);


  //初始多语言
  RegLangString(Self.tabCommon.Name,
      [Self.tabCommon.Text,
      'Common']);
  RegLangString(Self.tabBindItem.Name,
      [Self.tabBindItem.Text,
      'Bind Item']);

  RegLangString(Self.lblRoundImageCanSetColorThatOutOfClipRect.Name,
      [Self.lblRoundImageCanSetColorThatOutOfClipRect.Text,
      'Can set color that out of cliprect']);
  RegLangString(Self.lblRoundImageCanSetClipRect.Name,
      [Self.lblRoundImageCanSetClipRect.Text,
      'Can set cliprect']);

  RegLangString(Self.lblRoundImageSetSameColor.Name,
      [Self.lblRoundImageSetSameColor.Text,
      'Can set color that same with parent''s backcolor']);
  RegLangString(Self.lblRoundImageAddBorderByPanel.Name,
      [Self.lblRoundImageAddBorderByPanel.Text,
      'Can can add border by using panel']);


end;

end.
