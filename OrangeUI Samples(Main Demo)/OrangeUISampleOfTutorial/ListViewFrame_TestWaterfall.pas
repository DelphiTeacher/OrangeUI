//convert pas to utf8 by ¥

unit ListViewFrame_TestWaterfall;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyLabel,

  uLang,
  uFrameContext,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyListView, uSkinFireMonkeyImage, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel,
  uSkinItems,
  uDrawCanvas,
  uSkinImageList, FMX.TabControl, uSkinFireMonkeyButton, uSkinFireMonkeyPanel,
  uDrawPicture, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType;

type
  TFrameListView_TestWaterfall = class(TFrame,IFrameChangeLanguageEvent)
    lb9BoxMenu: TSkinFMXListView;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
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


{ TFrameListView_TestWaterfall }

procedure TFrameListView_TestWaterfall.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lb9BoxMenu.Prop.Items[0].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 0',ALangKind);
  Self.lb9BoxMenu.Prop.Items[1].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 1',ALangKind);
  Self.lb9BoxMenu.Prop.Items[2].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 2',ALangKind);
  Self.lb9BoxMenu.Prop.Items[3].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 3',ALangKind);
  Self.lb9BoxMenu.Prop.Items[4].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 4',ALangKind);
  Self.lb9BoxMenu.Prop.Items[5].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 5',ALangKind);
  Self.lb9BoxMenu.Prop.Items[6].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 6',ALangKind);
  Self.lb9BoxMenu.Prop.Items[7].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 7',ALangKind);

end;

constructor TFrameListView_TestWaterfall.Create(AOwner: TComponent);
begin
  inherited;
  //初始多语言
  RegLangString(Self.lb9BoxMenu.Name+'Caption 0',[Self.lb9BoxMenu.Prop.Items[0].Caption,'News']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 1',[Self.lb9BoxMenu.Prop.Items[1].Caption,'Inspection']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 2',[Self.lb9BoxMenu.Prop.Items[2].Caption,'Product']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 3',[Self.lb9BoxMenu.Prop.Items[3].Caption,'Supervision']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 4',[Self.lb9BoxMenu.Prop.Items[4].Caption,'Query']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 5',[Self.lb9BoxMenu.Prop.Items[5].Caption,'Investment']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 6',[Self.lb9BoxMenu.Prop.Items[6].Caption,'Supervisor']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 7',[Self.lb9BoxMenu.Prop.Items[7].Caption,'Communication']);


end;

end.
