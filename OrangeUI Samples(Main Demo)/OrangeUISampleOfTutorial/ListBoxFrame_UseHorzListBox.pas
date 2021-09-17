//convert pas to utf8 by ¥

unit ListBoxFrame_UseHorzListBox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,

  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyCustomList, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uDrawCanvas, uSkinItems;

type
  TFrameListBox_UseHorzListBox = class(TFrame,IFrameChangeLanguageEvent)
    lbWeek: TSkinFMXListBox;
    lbProductList: TSkinFMXListBox;
    ViewItemDefault: TSkinFMXItemDesignerPanel;
    imgViewItemDefaultIcon: TSkinFMXImage;
    lblViewItemDefaultPrice: TSkinFMXLabel;
    lblViewItemDefaultDetail1: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
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

{ TFrameListBox_UseHorzListBox }

procedure TFrameListBox_UseHorzListBox.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbWeek.Prop.Items[0].Caption:=GetLangString(Self.lbWeek.Name+'Caption 0',ALangKind);
  Self.lbWeek.Prop.Items[1].Caption:=GetLangString(Self.lbWeek.Name+'Caption 1',ALangKind);
  Self.lbWeek.Prop.Items[2].Caption:=GetLangString(Self.lbWeek.Name+'Caption 2',ALangKind);
  Self.lbWeek.Prop.Items[3].Caption:=GetLangString(Self.lbWeek.Name+'Caption 3',ALangKind);
  Self.lbWeek.Prop.Items[4].Caption:=GetLangString(Self.lbWeek.Name+'Caption 4',ALangKind);
  Self.lbWeek.Prop.Items[5].Caption:=GetLangString(Self.lbWeek.Name+'Caption 5',ALangKind);
  Self.lbWeek.Prop.Items[6].Caption:=GetLangString(Self.lbWeek.Name+'Caption 6',ALangKind);

  Self.lbProductList.Prop.Items[0].Caption:=GetLangString(Self.lbProductList.Name+'Caption 0',ALangKind);
  Self.lbProductList.Prop.Items[1].Caption:=GetLangString(Self.lbProductList.Name+'Caption 1',ALangKind);
  Self.lbProductList.Prop.Items[2].Caption:=GetLangString(Self.lbProductList.Name+'Caption 2',ALangKind);
  Self.lbProductList.Prop.Items[3].Caption:=GetLangString(Self.lbProductList.Name+'Caption 3',ALangKind);

  Self.lbProductList.Prop.Items[0].Detail1:=GetLangString(Self.lbProductList.Name+'Detail1 0',ALangKind);
  Self.lbProductList.Prop.Items[1].Detail1:=GetLangString(Self.lbProductList.Name+'Detail1 1',ALangKind);
  Self.lbProductList.Prop.Items[2].Detail1:=GetLangString(Self.lbProductList.Name+'Detail1 2',ALangKind);
  Self.lbProductList.Prop.Items[3].Detail1:=GetLangString(Self.lbProductList.Name+'Detail1 3',ALangKind);
end;

constructor TFrameListBox_UseHorzListBox.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lbWeek.Name+'Caption 0',[Self.lbWeek.Prop.Items[0].Caption,'Mon']);
  RegLangString(Self.lbWeek.Name+'Caption 1',[Self.lbWeek.Prop.Items[1].Caption,'Tue']);
  RegLangString(Self.lbWeek.Name+'Caption 2',[Self.lbWeek.Prop.Items[2].Caption,'Wed']);
  RegLangString(Self.lbWeek.Name+'Caption 3',[Self.lbWeek.Prop.Items[3].Caption,'Thu']);
  RegLangString(Self.lbWeek.Name+'Caption 4',[Self.lbWeek.Prop.Items[4].Caption,'Fri']);
  RegLangString(Self.lbWeek.Name+'Caption 5',[Self.lbWeek.Prop.Items[5].Caption,'Sat']);
  RegLangString(Self.lbWeek.Name+'Caption 6',[Self.lbWeek.Prop.Items[6].Caption,'Sun']);


  RegLangString(Self.lbProductList.Name+'Caption 0',[Self.lbProductList.Prop.Items[0].Caption,'2016 new words Lee smart shoes']);
  RegLangString(Self.lbProductList.Name+'Caption 1',[Self.lbProductList.Prop.Items[1].Caption,'XTEP Mens mesh sport shoes']);
  RegLangString(Self.lbProductList.Name+'Caption 2',[Self.lbProductList.Prop.Items[2].Caption,'2017 new words Lee smart shoes']);
  RegLangString(Self.lbProductList.Name+'Caption 3',[Self.lbProductList.Prop.Items[3].Caption,'New Balance/NB 373 series']);

  RegLangString(Self.lbProductList.Name+'Detail1 0',[Self.lbProductList.Prop.Items[0].Detail1,'monthly sales of 24,000']);
  RegLangString(Self.lbProductList.Name+'Detail1 1',[Self.lbProductList.Prop.Items[1].Detail1,'monthly sales of 12,000']);
  RegLangString(Self.lbProductList.Name+'Detail1 2',[Self.lbProductList.Prop.Items[2].Detail1,'monthly sales of 27,000']);
  RegLangString(Self.lbProductList.Name+'Detail1 3',[Self.lbProductList.Prop.Items[3].Detail1,'monthly sales of 33,000']);


end;

end.
