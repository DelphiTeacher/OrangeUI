//convert pas to utf8 by ¥
unit NearByFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  StationListFrame,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyPanel, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList, uSkinMaterial, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinButtonType, uSkinPanelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uDrawCanvas, uSkinItems;

type
  TFrameNearBy = class(TFrame)
    lbClassify: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgDetail1: TSkinFMXImage;
    imglistClassify: TSkinImageList;
    imglistClassifyBack: TSkinImageList;
    lblSubItem0: TSkinFMXLabel;
    lblCaption: TSkinFMXLabel;
    imgDetail: TSkinFMXImage;
    lblSubItem1: TSkinFMXLabel;
    lblSubItem2: TSkinFMXLabel;
    lblSubItem3: TSkinFMXLabel;
    lblSubItem4: TSkinFMXLabel;
    lblSubItem5: TSkinFMXLabel;
    lblSubItem6: TSkinFMXLabel;
    lblSubItem7: TSkinFMXLabel;
    lblSubItem8: TSkinFMXLabel;
    lblSubItem9: TSkinFMXLabel;
    pnlLineFromTo: TSkinFMXPanel;
    lblFromStation: TSkinFMXLabel;
    imgArrow: TSkinFMXImage;
    lblFindHint: TSkinFMXLabel;
    lblAt: TSkinFMXLabel;
    procedure lblSubItem0Click(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalNearByFrame:TFrameNearBy;


implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameNearBy.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameNearBy.lblSubItem0Click(Sender: TObject);
begin
  if (Sender<>nil) and (Self.lbClassify.Properties.InteractiveItem<>nil) then
  begin
    HideFrame;//(Self);

    ShowFrame(TFrame(GlobalStationListFrame),TFrameStationList,frmMain,nil,nil,nil,Application);
//    GlobalStationListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalStationListFrame.LoadData(
        Self.lbClassify.Properties.InteractiveItem.SubItems[
                                                      TSkinFMXLabel(Sender).Tag
                                                      ]
        );
  end;
end;

end.
