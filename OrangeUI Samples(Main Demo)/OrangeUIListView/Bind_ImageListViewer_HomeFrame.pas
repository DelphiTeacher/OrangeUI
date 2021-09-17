//convert pas to utf8 by ¥

unit Bind_ImageListViewer_HomeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinItems,
  uSkinListBoxType,
  uSkinControlGestureManager,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinImageList,
  uSkinFireMonkeyButton, uSkinButtonType, uSkinFireMonkeyImageListViewer,
  uDrawPicture, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uSkinImageType, uSkinLabelType, uSkinPanelType, uSkinImageListViewerType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uDrawCanvas;

type
  TFrameBind_ImageListViewer_Home = class(TFrame)
    lbHome: TSkinFMXListBox;
    ItemHeader: TSkinFMXItemDesignerPanel;
    imgPlayer: TSkinFMXImageListViewer;
    imglistPlayer: TSkinImageList;
    bgIndicator: TSkinFMXButtonGroup;
    ItemFooter: TSkinFMXItemDesignerPanel;
    imglistLeft: TSkinImageList;
    pnlFooterHeader: TSkinFMXPanel;
    imglistRight: TSkinImageList;
    pnlFooterSign: TSkinFMXPanel;
    lblFooterCaption: TSkinFMXLabel;
    ItemSearchBar: TSkinFMXItemDesignerPanel;
    imgSearchBarRightTop: TSkinFMXImage;
    imgSearchBarLeft: TSkinFMXImage;
    imgSearchBarRightBottom: TSkinFMXImage;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imglistProduct: TSkinImageList;
    imgDefaultIcon: TSkinFMXImage;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultPrice: TSkinFMXLabel;
    imgDefaultFrom: TSkinFMXImage;
  private
    procedure DoListBoxVertManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


implementation

{$R *.fmx}

uses
  MainForm;

{ TFrameHome }

constructor TFrameBind_ImageListViewer_Home.Create(AOwner: TComponent);
begin
  inherited;


  Self.lbHome.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.lbHome.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
    Self.DoListBoxVertManagerPrepareDecidedFirstGestureKind;

end;

procedure TFrameBind_ImageListViewer_Home.DoListBoxVertManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  AFirstItemRect:TRectF;
begin
  //广告轮播Item的绘制区域
  AFirstItemRect:=Self.lbHome.Prop.Items[0].ItemDrawRect;
  if PtInRect(AFirstItemRect,PointF(AMouseMoveX,AMouseMoveY)) then
  begin
      //在广告轮播控件内,那么要检查初始手势方向
  end
  else
  begin
      //不在在广告轮播控件内,那么随意滑动
      AIsDecidedFirstGestureKind:=True;
      ADecidedFirstGestureKind:=TGestureKind.gmkVertical;
  end;
end;


end.

