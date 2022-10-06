//convert pas to utf8 by ¥
unit VertBusLineFrame;

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
  BusLineListFrame,
  CarDistanceHintFrame,
  uUIFunction,
  PopupMenuFrame,
  uDrawTextParam,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyListBox, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uDrawPicture, uSkinImageList, uSkinMaterial,
  uSkinButtonType, uSkinImageType, uSkinFireMonkeyPopup, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType;

type
  TFrameVertBusLine = class(TFrame)
    lbStations: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    imglistIcon: TSkinImageList;
    imglistState: TSkinImageList;
    imgDirection: TSkinFMXImage;
    lblDirection: TSkinFMXLabel;
    SkinFMXPopup2: TSkinFMXPopup;
    btnHint: TSkinFMXButton;
    btnLines: TSkinFMXButton;
    btnShops: TSkinFMXButton;
    procedure lbStationsPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure ItemDefaultResize(Sender: TObject);
    procedure lbStationsLongTapItem(Sender: TObject; Item: TSkinItem);
  private
    procedure DoPopupMenuFrameClick(Sender:TObject;Menu:String);
//    function GetBtnLinesHitTestVisible(Sender: TObject):Boolean;
//    function GetBtnHintHitTestVisible(Sender: TObject):Boolean;
//    function GetBtnShopsHitTestVisible(Sender: TObject):Boolean;
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalVertBusLineFrame:TFrameVertBusLine;

implementation

uses
  MainForm,
  BusLineFrame,
  GoWhereFrame;

{$R *.fmx}

constructor TFrameVertBusLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.lbStations.Properties.SelectedItem:=nil;


//  Self.btnLines.OnGetNeedHitTestVisible:=GetBtnLinesHitTestVisible;
//  Self.btnHint.OnGetNeedHitTestVisible:=GetBtnHintHitTestVisible;
//  Self.btnShops.OnGetNeedHitTestVisible:=GetBtnShopsHitTestVisible;

end;

procedure TFrameVertBusLine.DoPopupMenuFrameClick(Sender: TObject;Menu: String);
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

//function TFrameVertBusLine.GetBtnHintHitTestVisible(Sender: TObject): Boolean;
//begin
//  Result:=Self.lbStations.Properties.InteractiveItem.Selected;
//end;
//
//function TFrameVertBusLine.GetBtnLinesHitTestVisible(Sender: TObject): Boolean;
//begin
//  Result:=Self.lbStations.Properties.InteractiveItem.Selected;
//end;
//
//function TFrameVertBusLine.GetBtnShopsHitTestVisible(Sender: TObject): Boolean;
//begin
//  Result:=Self.lbStations.Properties.InteractiveItem.Selected;
//end;

procedure TFrameVertBusLine.lbStationsLongTapItem(Sender: TObject;Item: TSkinItem);
begin
  //长按弹出事件
  ShowPopupMenuFrame(frmMain,Item.Caption,['周边商城','途径路线','到站提醒'],
                DoPopupMenuFrameClick,0,nil);
end;

procedure TFrameVertBusLine.lbStationsPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
//  Self.btnLines.Visible:=(Item=Self.lbStations.Properties.SelectedItem);
//  Self.btnShops.Visible:=btnLines.Visible;
//  Self.btnHint.Visible:=btnLines.Visible;
//  Self.imgItemDevide.Visible:=False;//btnLines.Visible;
//  Self.SkinFMXImage2.Visible:=False;
//  Self.=imgTop.Visible:=(Item<>Self.lbStations.Properties.Items[0])
////         and Self.btnLines.Visible
//         ;
//  Self.imgBottom.Visible:=(Item<>Self.lbStations.Properties.Items[
//      Self.lbStations.Properties.Items.Count-1])
////      and Self.btnLines.Visible
//      ;

//  if Self.lbStations.Properties.SelectedItem<>Item then
//  begin
//    Self.lblItemDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontVertAlign:=fvaCenter;//fvaBottom;
//  end
//  else
//  begin
//    Self.lblItemDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontVertAlign:=fvaCenter;
//  end;

//  Self.imgTop.Height:=(Self.lbStations.Properties.CalcItemHeight(Item)-40)/2;
//  Self.imgBottom.Height:=imgTop.Height;


end;

procedure TFrameVertBusLine.ItemDefaultResize(Sender: TObject);
begin
//  Self.btnLines.Width:=(Width-Self.btnLines.Left)/3;
//  Self.btnShops.Width:=btnLines.Width;
//  Self.btnHint.Width:=btnLines.Width;
//
//  Self.btnShops.Left:=Self.btnLines.Left+Self.btnLines.Width;
//  Self.btnHint.Left:=Self.btnShops.Left+Self.btnShops.Width;

end;

end.
