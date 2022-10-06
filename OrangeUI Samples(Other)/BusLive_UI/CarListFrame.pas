//convert pas to utf8 by ¥
unit CarListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinMaterial, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uDrawCanvas, uSkinItems;

type
  TFrameCarList = class(TFrame)
    lbCars: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgIcon: TSkinFMXImage;
    lblCarNoHint: TSkinFMXLabel;
    lblLineHint: TSkinFMXLabel;
    lblDirectionHint: TSkinFMXLabel;
    lblDistanceHint: TSkinFMXLabel;
    lblFarFromMeHint: TSkinFMXLabel;
    lblItemCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    lblValueMaterial: TSkinLabelDefaultMaterial;
    SkinFMXImage2: TSkinFMXImage;
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalCarListFrame:TFrameCarList;

implementation

{$R *.fmx}

end.
