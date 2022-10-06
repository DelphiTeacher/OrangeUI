//convert pas to utf8 by ¥
unit BusMethodFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyMultiColorLabel, uDrawPicture,
  uSkinImageList, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinMaterial, uSkinItemDesignerPanelType,
  uSkinImageType, uSkinLabelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinMultiColorLabelType,
  uSkinButtonType, uSkinPanelType, uDrawCanvas, uSkinItems;

type
  TFrameBusMethod = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
    SkinFMXMultiColorLabel2: TSkinFMXMultiColorLabel;
    SkinFMXListBox1: TSkinFMXListBox;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    imglistInfo: TSkinImageList;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXImage2: TSkinFMXImage;
    SkinFMXLabel7: TSkinFMXLabel;
    SkinFMXImage3: TSkinFMXImage;
    SkinFMXLabel8: TSkinFMXLabel;
    SkinFMXImage4: TSkinFMXImage;
    SkinFMXLabel9: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalBusMethodFrame:TFrameBusMethod;

implementation

{$R *.fmx}


procedure TFrameBusMethod.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

end.
