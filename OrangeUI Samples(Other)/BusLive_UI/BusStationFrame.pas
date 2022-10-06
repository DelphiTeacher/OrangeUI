//convert pas to utf8 by ¥
unit BusStationFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyImage, uSkinFireMonkeySwitch,
  uSkinFireMonkeyCheckBox, uSkinCheckBoxType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinButtonType, uSkinPanelType,
  uDrawCanvas, uSkinItems;

type
  TFrameBusStation = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbStation: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    chkHint: TSkinFMXCheckBox;
    procedure btnReturnClick(Sender: TObject);
    procedure chkHintClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalBusStationFrame:TFrameBusStation;

implementation

{$R *.fmx}

procedure TFrameBusStation.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameBusStation.chkHintClick(Sender: TObject);
begin
  if Self.lbStation.Prop.InteractiveItem<>nil then
  begin
    Self.lbStation.Prop.InteractiveItem.Checked:=
      Not Self.lbStation.Prop.InteractiveItem.Checked;
  end;
end;

end.
