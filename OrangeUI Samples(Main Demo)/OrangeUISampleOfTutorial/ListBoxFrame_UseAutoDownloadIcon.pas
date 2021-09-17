//convert pas to utf8 by ¥

unit ListBoxFrame_UseAutoDownloadIcon;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,

  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uUrlPicture,
  uDownloadPictureManager, uSkinFireMonkeyCustomList, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uDrawCanvas, uSkinItems;

type
  TFrameListBox_UseAutoDownloadIcon = class(TFrame,IFrameChangeLanguageEvent)
    lbAutoDownloadItemIcon: TSkinFMXListBox;
    DownloadPictureManager1: TDownloadPictureManager;
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListBox_UseAutoDownloadIcon }

procedure TFrameListBox_UseAutoDownloadIcon.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbAutoDownloadItemIcon.Prop.Items[0].Caption:=
    GetLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 0',ALangKind);
//  Self.lbAutoDownloadItemIcon.Prop.Items[1].Caption:=
//    GetLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 1',ALangKind);
//  Self.lbAutoDownloadItemIcon.Prop.Items[2].Caption:=
//    GetLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 2',ALangKind);
//  Self.lbAutoDownloadItemIcon.Prop.Items[3].Caption:=
//    GetLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 3',ALangKind);

end;

constructor TFrameListBox_UseAutoDownloadIcon.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 0',
                [Self.lbAutoDownloadItemIcon.Prop.Items[0].Caption,'Just set ListBoxItem.Icon.Url']);


//  RegLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 1',
//                [Self.lbAutoDownloadItemIcon.Prop.Items[1].Caption,'will download picture from internet']);
//  RegLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 2',
//                [Self.lbAutoDownloadItemIcon.Prop.Items[2].Caption,'then be cached to local']);
//  RegLangString(Self.lbAutoDownloadItemIcon.Name+'Caption 3',
//                [Self.lbAutoDownloadItemIcon.Prop.Items[3].Caption,'no download next time']);

end;

end.
