//convert pas to utf8 by ¥

unit XunKeCommonSkinMaterialModule;

interface

uses
  System.SysUtils, System.Classes, uSkinMaterial, uSkinButtonType,
  uSkinPanelType;

type
  TXunKeDataModuleCommonSkinMaterial = class(TDataModule)
    bdmReturnButton: TSkinButtonDefaultMaterial;
    btnIconButton: TSkinButtonDefaultMaterial;
    btnIconCaptionBottomButton: TSkinButtonDefaultMaterial;
    pnlListItemDefaultDevideMaterial: TSkinPanelDefaultMaterial;
    pnlCaptionPanelMaterial: TSkinPanelDefaultMaterial;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  XunKeDataModuleCommonSkinMaterial: TXunKeDataModuleCommonSkinMaterial;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
