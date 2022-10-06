//convert pas to utf8 by ¥
unit RealTimeBusLineFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList,
  uSkinItems,
  uDrawCanvas,
  NearByFrame,
  PopupMenuFrame,
  CarDistanceHintFrame,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyListBox, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uDrawPicture, uSkinImageList, uSkinMaterial,
  uSkinButtonType, uSkinImageType, uSkinPanelType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType;

type
  TFrameRealTimeBusLine = class(TFrame)
    lbStations: TSkinFMXListBox;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    imglistState: TSkinImageList;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXImage3: TSkinFMXImage;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXLabel7: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXButton2: TSkinFMXButton;
    lblItemDetail: TSkinFMXLabel;
//    procedure lbStationsPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
//      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
//      ItemRect: TRect);
//    procedure SkinFMXItemDesignerPanel1Resize(Sender: TObject);
//    procedure btnLinesClick(Sender: TObject);
//    procedure btnShopsClick(Sender: TObject);
//    procedure btnHintClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbStationsLongTapItem(Sender: TObject; Item: TSkinItem);
  private
    procedure DoPopupMenuFrameClick(Sender: TObject; Menu: String);
//    function GetBtnLinesHitTestVisible(Sender: TObject):Boolean;
//    function GetBtnHintHitTestVisible(Sender: TObject):Boolean;
//    function GetBtnShopsHitTestVisible(Sender: TObject):Boolean;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalRealTimeBusLineFrame:TFrameRealTimeBusLine;

implementation

uses
  MainForm,
  BusLineFrame,
  BusLineListFrame,
  GoWhereFrame;

{$R *.fmx}

//procedure TFrameRealTimeBusLine.btnHintClick(Sender: TObject);
//begin
//  //到站提醒
//  HideFrame;//(Self);
//  ShowFrame(TFrame(GlobalCarDistanceHintFrame),TFrameCarDistanceHint,frmMain,nil,nil,nil,Application);
//  GlobalCarDistanceHintFrame.FrameHistroy:=CurrentFrameHistroy;
//end;
//
//procedure TFrameRealTimeBusLine.btnLinesClick(Sender: TObject);
//begin
//  //途径线路
//  HideFrame;//(Self);
//  ShowFrame(TFrame(GlobalBusLineListFrame),TFrameBusLineList,frmMain,nil,nil,nil,Application);
//  GlobalBusLineListFrame.FrameHistroy:=CurrentFrameHistroy;
//
//end;

procedure TFrameRealTimeBusLine.DoPopupMenuFrameClick(Sender: TObject;Menu: String);
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

procedure TFrameRealTimeBusLine.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

//procedure TFrameRealTimeBusLine.btnShopsClick(Sender: TObject);
//begin
//  //周边商城
//  HideFrame;//(Self);
//  ShowFrame(TFrame(GlobalNearByFrame),TFrameNearBy,frmMain,nil,nil,nil,Application);
//  GlobalNearByFrame.FrameHistroy:=CurrentFrameHistroy;
//end;

constructor TFrameRealTimeBusLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.lbStations.Properties.SelectedItem:=nil;
//  Self.btnLines.OnGetNeedHitTestVisible:=GetBtnLinesHitTestVisible;
//  Self.btnHint.OnGetNeedHitTestVisible:=GetBtnHintHitTestVisible;
//  Self.btnShops.OnGetNeedHitTestVisible:=GetBtnShopsHitTestVisible;

end;

procedure TFrameRealTimeBusLine.lbStationsLongTapItem(Sender: TObject;Item: TSkinItem);
begin
  //长按弹出事件
  ShowPopupMenuFrame(frmMain,Item.Caption,['周边商城','途径路线','到站提醒'],
                DoPopupMenuFrameClick,0,nil);
end;

//function TFrameRealTimeBusLine.GetBtnHintHitTestVisible(Sender: TObject): Boolean;
//begin
//  Result:=Self.lbStations.Properties.InteractiveItem.Selected;
//end;
//
//function TFrameRealTimeBusLine.GetBtnLinesHitTestVisible(Sender: TObject): Boolean;
//begin
//  Result:=Self.lbStations.Properties.InteractiveItem.Selected;
//end;
//
//function TFrameRealTimeBusLine.GetBtnShopsHitTestVisible(Sender: TObject): Boolean;
//begin
//  Result:=Self.lbStations.Properties.InteractiveItem.Selected;
//end;

//procedure TFrameRealTimeBusLine.lbStationsPrepareDrawItem(Sender: TObject;
//  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
//  Item: TSkinItem; ItemRect: TRect);
//begin
//
//  Self.btnLines.Visible:=(Item=Self.lbStations.Properties.SelectedItem);
//  Self.btnShops.Visible:=btnLines.Visible;
//  Self.btnHint.Visible:=btnLines.Visible;
//  Self.imgItemDevide.Visible:=btnLines.Visible;
//
//  Self.imgTop.Visible:=(Item<>Self.lbStations.Properties.Items[0])
////         and Self.btnLines.Visible
//         ;
//  Self.imgBottom.Visible:=(Item<>Self.lbStations.Properties.Items[
//      Self.lbStations.Properties.Items.Count-1])
////      and Self.btnLines.Visible
//      ;
//
//  Self.imgTop.Height:=(Self.lbStations.Properties.CalcItemHeight(Item)-40)/2;
//  Self.imgBottom.Height:=imgTop.Height;
//end;
//
//procedure TFrameRealTimeBusLine.SkinFMXItemDesignerPanel1Resize(Sender: TObject);
//begin
//  Self.btnLines.Width:=(Width-Self.btnLines.Left)/3;
//  Self.btnShops.Width:=btnLines.Width;
//  Self.btnHint.Width:=btnLines.Width;
//
//  Self.btnShops.Left:=Self.btnLines.Left+Self.btnLines.Width;
//  Self.btnHint.Left:=Self.btnShops.Left+Self.btnShops.Width;
//
//end;

end.
