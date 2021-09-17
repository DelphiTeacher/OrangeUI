//convert pas to utf8 by ¥

unit ViewMode_Horz_BusLineFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uUIFunction,
  uSkinItems,
  PopupMenuFrame,
  uDrawCanvas,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyPanel, uSkinFireMonkeyCustomList,
  uSkinPanelType, uSkinImageType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType;

type
  TFrameViewMode_Horz_BusLine = class(TFrame)
    lbStations: TSkinFMXListBox;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    imglistStationIndex: TSkinImageList;
    imgLeft: TSkinFMXImage;
    imgRight: TSkinFMXImage;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    imglistState: TSkinImageList;
    imgGoing: TSkinFMXImage;
    imgHere: TSkinFMXImage;
    procedure lbStationsPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure lbStationsLongTapItem(Sender: TObject; Item: TSkinItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

uses
  MainForm;

{$R *.fmx}


procedure TFrameViewMode_Horz_BusLine.lbStationsLongTapItem(Sender: TObject;Item: TSkinItem);
begin
  //长按弹出事件
  ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
  GlobalPopupMenuFrame.Init(
                            Item.Caption,
                            ['周边商城','途径路线','到站提醒']);

end;

procedure TFrameViewMode_Horz_BusLine.lbStationsPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
  Self.imgLeft.Visible:=Item<>Self.lbStations.Properties.Items[0];
  Self.imgRight.Visible:=Item<>Self.lbStations.Properties.Items[
      Self.lbStations.Properties.Items.Count-1];
end;

end.
