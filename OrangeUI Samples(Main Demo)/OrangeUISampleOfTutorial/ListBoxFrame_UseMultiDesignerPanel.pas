//convert pas to utf8 by ¥

unit ListBoxFrame_UseMultiDesignerPanel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uDrawCanvas,
  uSkinItems,
  uSkinFireMonkeyCheckBox, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyCustomList, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType;

type
  TFrameListBox_UseMultiDesignerPanel = class(TFrame,IFrameChangeLanguageEvent)
    lbXunKeSetting: TSkinFMXListBox;
    idpHeader: TSkinFMXItemDesignerPanel;
    imgHead: TSkinFMXImage;
    lblNickName: TSkinFMXLabel;
    lblAccount: TSkinFMXLabel;
    idpMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
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


{ TFrameListBox_UseMultiDesignerPanel }

procedure TFrameListBox_UseMultiDesignerPanel.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbXunKeSetting.Prop.Items[0].Detail:=GetLangString(Self.lbXunKeSetting.Name+'Detail 0',ALangKind);
  Self.lbXunKeSetting.Prop.Items[2].Caption:=GetLangString(Self.lbXunKeSetting.Name+'Caption 2',ALangKind);
  Self.lbXunKeSetting.Prop.Items[3].Caption:=GetLangString(Self.lbXunKeSetting.Name+'Caption 3',ALangKind);
  Self.lbXunKeSetting.Prop.Items[4].Caption:=GetLangString(Self.lbXunKeSetting.Name+'Caption 4',ALangKind);
  Self.lbXunKeSetting.Prop.Items[6].Caption:=GetLangString(Self.lbXunKeSetting.Name+'Caption 6',ALangKind);
  Self.lbXunKeSetting.Prop.Items[8].Caption:=GetLangString(Self.lbXunKeSetting.Name+'Caption 8',ALangKind);

end;

constructor TFrameListBox_UseMultiDesignerPanel.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lbXunKeSetting.Name+'Detail 0',[Self.lbXunKeSetting.Prop.Items[0].Detail,'id:happy520']);
  RegLangString(Self.lbXunKeSetting.Name+'Caption 2',[Self.lbXunKeSetting.Prop.Items[2].Caption,'Album']);
  RegLangString(Self.lbXunKeSetting.Name+'Caption 3',[Self.lbXunKeSetting.Prop.Items[3].Caption,'Favorite']);
  RegLangString(Self.lbXunKeSetting.Name+'Caption 4',[Self.lbXunKeSetting.Prop.Items[4].Caption,'Wallet']);
  RegLangString(Self.lbXunKeSetting.Name+'Caption 6',[Self.lbXunKeSetting.Prop.Items[6].Caption,'Emoticon']);
  RegLangString(Self.lbXunKeSetting.Name+'Caption 8',[Self.lbXunKeSetting.Prop.Items[8].Caption,'Setting']);

end;

end.
