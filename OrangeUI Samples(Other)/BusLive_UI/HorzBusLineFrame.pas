//convert pas to utf8 by ¥
unit HorzBusLineFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  uSkinItems,
  PopupMenuFrame,
  BusLineListFrame,
  CarDistanceHintFrame,
  NearByFrame,
  uDrawCanvas,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyPanel, uSkinPanelType,
  uSkinImageType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType;

type
  TFrameHorzBusLine = class(TFrame)
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
    procedure DoPopupMenuFrameClick(Sender:TObject;Menu:String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalHorzBusLineFrame:TFrameHorzBusLine;


implementation

uses
  BusLineFrame,
  MainForm;

{$R *.fmx}

procedure TFrameHorzBusLine.DoPopupMenuFrameClick(Sender: TObject;
  Menu: String);
begin
  if Menu='途径路线' then
  begin
      //途径线路
      HideFrame;//(GlobalBusLineFrame);
      ShowFrame(TFrame(GlobalBusLineListFrame),TFrameBusLineList,frmMain,nil,nil,nil,Application);
//      GlobalBusLineListFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if Menu='周边商城' then
  begin
      //周边商城
      HideFrame;//(GlobalBusLineFrame);
      ShowFrame(TFrame(GlobalNearByFrame),TFrameNearBy,frmMain,nil,nil,nil,Application);
//      GlobalNearByFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
  if Menu='到站提醒' then
  begin
      //到站提醒
      HideFrame;//(GlobalBusLineFrame);
      ShowFrame(TFrame(GlobalCarDistanceHintFrame),TFrameCarDistanceHint,frmMain,nil,nil,nil,Application);
//      GlobalCarDistanceHintFrame.FrameHistroy:=CurrentFrameHistroy;
  end;
end;

procedure TFrameHorzBusLine.lbStationsLongTapItem(Sender: TObject;
  Item: TSkinItem);
begin
  //长按弹出事件
  ShowPopupMenuFrame(frmMain,Item.Caption,['周边商城','途径路线','到站提醒'],
                DoPopupMenuFrameClick,0,nil);

end;

procedure TFrameHorzBusLine.lbStationsPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
  Self.imgLeft.Visible:=Item<>Self.lbStations.Properties.Items[0];
  Self.imgRight.Visible:=Item<>Self.lbStations.Properties.Items[
      Self.lbStations.Properties.Items.Count-1];
end;

end.
