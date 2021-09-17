﻿//convert pas to utf8 by ¥

unit ListViewFrame_UseSelfOwnMaterial_9BoxMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uSkinItems,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyListView,
  uSkinFireMonkeyCustomList, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType, uDrawCanvas;

type
  TFrameListView_UseSelfOwnMaterial_9BoxMenu = class(TFrame,IFrameChangeLanguageEvent)
    lb9BoxMenu: TSkinFMXListView;
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

{ TFrameListView_UseSelfOwnMaterial_9BoxMenu }

procedure TFrameListView_UseSelfOwnMaterial_9BoxMenu.ChangeLanguage(ALangKind: TLangKind);
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

constructor TFrameListView_UseSelfOwnMaterial_9BoxMenu.Create(
  AOwner: TComponent);
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
