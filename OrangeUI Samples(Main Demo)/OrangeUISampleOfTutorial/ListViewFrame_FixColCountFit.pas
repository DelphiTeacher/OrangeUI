//convert pas to utf8 by ¥

unit ListViewFrame_FixColCountFit;

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
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uBaseSkinControl, uSkinImageType;

type
  TFrameListView_FixColCountFit = class(TFrame,IFrameChangeLanguageEvent)
    imglistSwitchState: TSkinImageList;
    SkinFMXImage1: TSkinFMXImage;
    lbLights: TSkinFMXListView;
    procedure lbLightsClickItem(AItem: TSkinItem);
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


procedure TFrameListView_FixColCountFit.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbLights.Prop.Items[0].Caption:=GetLangString(Self.lbLights.Name+'Caption 0',ALangKind);
  Self.lbLights.Prop.Items[1].Caption:=GetLangString(Self.lbLights.Name+'Caption 1',ALangKind);
  Self.lbLights.Prop.Items[2].Caption:=GetLangString(Self.lbLights.Name+'Caption 2',ALangKind);
  Self.lbLights.Prop.Items[3].Caption:=GetLangString(Self.lbLights.Name+'Caption 3',ALangKind);
  Self.lbLights.Prop.Items[4].Caption:=GetLangString(Self.lbLights.Name+'Caption 4',ALangKind);
  Self.lbLights.Prop.Items[5].Caption:=GetLangString(Self.lbLights.Name+'Caption 5',ALangKind);
  Self.lbLights.Prop.Items[6].Caption:=GetLangString(Self.lbLights.Name+'Caption 6',ALangKind);
  Self.lbLights.Prop.Items[7].Caption:=GetLangString(Self.lbLights.Name+'Caption 7',ALangKind);

end;

constructor TFrameListView_FixColCountFit.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lbLights.Name+'Caption 0',[Self.lbLights.Prop.Items[0].Caption,'Tail light']);
  RegLangString(Self.lbLights.Name+'Caption 1',[Self.lbLights.Prop.Items[1].Caption,'Blue light']);
  RegLangString(Self.lbLights.Name+'Caption 2',[Self.lbLights.Prop.Items[2].Caption,'Pendant lamp']);
  RegLangString(Self.lbLights.Name+'Caption 3',[Self.lbLights.Prop.Items[3].Caption,'Room headlight']);
  RegLangString(Self.lbLights.Name+'Caption 4',[Self.lbLights.Prop.Items[4].Caption,'Bedroom headlight']);
  RegLangString(Self.lbLights.Name+'Caption 5',[Self.lbLights.Prop.Items[5].Caption,'Heater']);
  RegLangString(Self.lbLights.Name+'Caption 6',[Self.lbLights.Prop.Items[6].Caption,'Microwave Oven']);
  RegLangString(Self.lbLights.Name+'Caption 7',[Self.lbLights.Prop.Items[7].Caption,'Kitchen light']);


end;

procedure TFrameListView_FixColCountFit.lbLightsClickItem(
  AItem: TSkinItem);
begin
  if AItem.Icon.ImageIndex=0 then
  begin
    AItem.Icon.ImageIndex:=1;
  end
  else
  begin
    AItem.Icon.ImageIndex:=0;
  end;

end;

end.
