//convert pas to utf8 by ¥

unit Bind_MultiColorLabel_ProductListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  DateUtils,
  uDrawCanvas,
  uFuncCommon,

  uBaseList,
  uSkinItems,
  uSkinListBoxType,


  uUIFunction,

  uSkinFireMonkeyControl, uSkinFireMonkeyPullLoadPanel,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyPanel,
  uSkinMultiColorLabelType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType;

type
  TFrameBind_MultiColorLabel_ProductList = class(TFrame)
    lbProductList: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail2: TSkinFMXMultiColorLabel;
    lblItemDetail1: TSkinFMXMultiColorLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    lblItemDetail2Hint: TSkinFMXLabel;
    imgShareBarCode: TSkinFMXImage;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    { Public declarations }
  end;

implementation


uses
  MainForm;

{$R *.fmx}


constructor TFrameBind_MultiColorLabel_ProductList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TFrameBind_MultiColorLabel_ProductList.Destroy;
begin
  inherited;
end;

end.
