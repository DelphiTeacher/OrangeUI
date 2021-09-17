//convert pas to utf8 by ¥

unit ListBoxFrame_UseCenterSelect;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uLang,
  uFrameContext,
  uSkinMaterial, uSkinScrollControlType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyPanel, uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, FMX.Controls.Presentation,
  uSkinCustomListType, uSkinFireMonkeyCustomList, uSkinPanelType,
  uBaseSkinControl, uDrawCanvas, uSkinItems;

type
  TFrameListBox_UseCenterSelect = class(TFrame,IFrameChangeLanguageEvent)
    lblListBoxHorzCenterSelectMode: TLabel;
    lbProvinceHorz: TSkinFMXListBox;
    lblListBoxVertCenterSelectMode: TLabel;
    pnlCenterSelect: TSkinFMXPanel;
    lbProvince: TSkinFMXListBox;
    lbCity: TSkinFMXListBox;
    lbArea: TSkinFMXListBox;
    lbAddressMaterial: TSkinListBoxDefaultMaterial;
    lbHorzAddrMaterial: TSkinListBoxDefaultMaterial;
    procedure pnlCenterSelectResize(Sender: TObject);
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

{ TFrameListBox_UseCenterSelect }

procedure TFrameListBox_UseCenterSelect.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblListBoxHorzCenterSelectMode.Text:=GetLangString(Self.lblListBoxHorzCenterSelectMode.Name,ALangKind);
  Self.lblListBoxVertCenterSelectMode.Text:=GetLangString(Self.lblListBoxVertCenterSelectMode.Name,ALangKind);

  Self.lbProvinceHorz.Prop.Items[0].Caption:=GetLangString(Self.lbProvinceHorz.Name+'Caption 0',ALangKind);
  Self.lbProvinceHorz.Prop.Items[1].Caption:=GetLangString(Self.lbProvinceHorz.Name+'Caption 1',ALangKind);
  Self.lbProvinceHorz.Prop.Items[2].Caption:=GetLangString(Self.lbProvinceHorz.Name+'Caption 2',ALangKind);

  Self.lbProvince.Prop.Items[0].Caption:=GetLangString(Self.lbProvince.Name+'Caption 0',ALangKind);
  Self.lbProvince.Prop.Items[1].Caption:=GetLangString(Self.lbProvince.Name+'Caption 1',ALangKind);
  Self.lbProvince.Prop.Items[2].Caption:=GetLangString(Self.lbProvince.Name+'Caption 2',ALangKind);

  Self.lbCity.Prop.Items[0].Caption:=GetLangString(Self.lbCity.Name+'Caption 0',ALangKind);
  Self.lbCity.Prop.Items[1].Caption:=GetLangString(Self.lbCity.Name+'Caption 1',ALangKind);
  Self.lbCity.Prop.Items[2].Caption:=GetLangString(Self.lbCity.Name+'Caption 2',ALangKind);
  Self.lbCity.Prop.Items[3].Caption:=GetLangString(Self.lbCity.Name+'Caption 3',ALangKind);
  Self.lbCity.Prop.Items[4].Caption:=GetLangString(Self.lbCity.Name+'Caption 4',ALangKind);
  Self.lbCity.Prop.Items[5].Caption:=GetLangString(Self.lbCity.Name+'Caption 5',ALangKind);
  Self.lbCity.Prop.Items[6].Caption:=GetLangString(Self.lbCity.Name+'Caption 6',ALangKind);
  Self.lbCity.Prop.Items[7].Caption:=GetLangString(Self.lbCity.Name+'Caption 7',ALangKind);


  Self.lbArea.Prop.Items[0].Caption:=GetLangString(Self.lbArea.Name+'Caption 0',ALangKind);
  Self.lbArea.Prop.Items[1].Caption:=GetLangString(Self.lbArea.Name+'Caption 1',ALangKind);
  Self.lbArea.Prop.Items[2].Caption:=GetLangString(Self.lbArea.Name+'Caption 2',ALangKind);
  Self.lbArea.Prop.Items[3].Caption:=GetLangString(Self.lbArea.Name+'Caption 3',ALangKind);
  Self.lbArea.Prop.Items[4].Caption:=GetLangString(Self.lbArea.Name+'Caption 4',ALangKind);
  Self.lbArea.Prop.Items[5].Caption:=GetLangString(Self.lbArea.Name+'Caption 5',ALangKind);
  Self.lbArea.Prop.Items[6].Caption:=GetLangString(Self.lbArea.Name+'Caption 6',ALangKind);



end;

constructor TFrameListBox_UseCenterSelect.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblListBoxHorzCenterSelectMode.Name,
    [Self.lblListBoxHorzCenterSelectMode.Text,'Horz center-select mode']);
  RegLangString(Self.lblListBoxVertCenterSelectMode.Name,
    [Self.lblListBoxVertCenterSelectMode.Text,'Vert center-select mode']);

  RegLangString(Self.lbProvinceHorz.Name+'Caption 0',[Self.lbProvinceHorz.Prop.Items[0].Caption,'Zhe jiang']);
  RegLangString(Self.lbProvinceHorz.Name+'Caption 1',[Self.lbProvinceHorz.Prop.Items[1].Caption,'Shang hai']);
  RegLangString(Self.lbProvinceHorz.Name+'Caption 2',[Self.lbProvinceHorz.Prop.Items[2].Caption,'Bei jing']);

  RegLangString(Self.lbProvince.Name+'Caption 0',[Self.lbProvince.Prop.Items[0].Caption,'Zhe jiang']);
  RegLangString(Self.lbProvince.Name+'Caption 1',[Self.lbProvince.Prop.Items[1].Caption,'Shang hai']);
  RegLangString(Self.lbProvince.Name+'Caption 2',[Self.lbProvince.Prop.Items[2].Caption,'Bei jing']);

  RegLangString(Self.lbCity.Name+'Caption 0',[Self.lbCity.Prop.Items[0].Caption,'Jin hua']);
  RegLangString(Self.lbCity.Name+'Caption 1',[Self.lbCity.Prop.Items[1].Caption,'Hang zhou']);
  RegLangString(Self.lbCity.Name+'Caption 2',[Self.lbCity.Prop.Items[2].Caption,'Shao xing']);
  RegLangString(Self.lbCity.Name+'Caption 3',[Self.lbCity.Prop.Items[3].Caption,'Ning bo']);
  RegLangString(Self.lbCity.Name+'Caption 4',[Self.lbCity.Prop.Items[4].Caption,'Li sui']);
  RegLangString(Self.lbCity.Name+'Caption 5',[Self.lbCity.Prop.Items[5].Caption,'Tai zhou']);
  RegLangString(Self.lbCity.Name+'Caption 6',[Self.lbCity.Prop.Items[6].Caption,'Wen zhou']);
  RegLangString(Self.lbCity.Name+'Caption 7',[Self.lbCity.Prop.Items[7].Caption,'Zhou shan']);

  RegLangString(Self.lbArea.Name+'Caption 0',[Self.lbArea.Prop.Items[0].Caption,'Wu cheng']);
  RegLangString(Self.lbArea.Name+'Caption 1',[Self.lbArea.Prop.Items[1].Caption,'Jing dong']);
  RegLangString(Self.lbArea.Name+'Caption 2',[Self.lbArea.Prop.Items[2].Caption,'Yong kang']);
  RegLangString(Self.lbArea.Name+'Caption 3',[Self.lbArea.Prop.Items[3].Caption,'Wu yi']);
  RegLangString(Self.lbArea.Name+'Caption 4',[Self.lbArea.Prop.Items[4].Caption,'Yi wu']);
  RegLangString(Self.lbArea.Name+'Caption 5',[Self.lbArea.Prop.Items[5].Caption,'Dong yang']);
  RegLangString(Self.lbArea.Name+'Caption 6',[Self.lbArea.Prop.Items[6].Caption,'Lan xi']);


end;

procedure TFrameListBox_UseCenterSelect.pnlCenterSelectResize(Sender: TObject);
begin
  Self.lbProvince.Width:=Self.pnlCenterSelect.Width/3;
  Self.lbCity.Width:=Self.pnlCenterSelect.Width/3;
  Self.lbArea.Width:=Self.pnlCenterSelect.Width/3;
end;

end.
