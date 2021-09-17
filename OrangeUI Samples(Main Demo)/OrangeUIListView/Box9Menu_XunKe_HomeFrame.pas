//convert pas to utf8 by ¥

unit Box9Menu_XunKe_HomeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinItems,
  uSkinListBoxType,
  uSkinControlGestureManager,
  uSkinFireMonkeyLabel, uDrawPicture, uSkinImageList, uSkinFireMonkeyButton,
  uSkinFireMonkeyImageListViewer, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyCustomList, uSkinPanelType, uSkinButtonType,
  uSkinImageListViewerType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinScrollBoxContentType, uSkinScrollControlType,
  uSkinScrollBoxType;



type
  TFrameBox9Menu_XunKe_Home = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    lblMenu: TSkinFMXListView;
    idpMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    imglistMenu: TSkinImageList;
    imglistPlayer: TSkinImageList;
    imgPlayer: TSkinFMXImageListViewer;
    bgIndicator: TSkinFMXButtonGroup;
    pnlToolBar: TSkinFMXPanel;
    btnSearch: TSkinFMXButton;
    btnScan: TSkinFMXButton;
    btnCategory: TSkinFMXButton;
  private
    procedure DoScrollBoxVertManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


implementation

uses
  MainForm;


{$R *.fmx}

constructor TFrameBox9Menu_XunKe_Home.Create(AOwner: TComponent);
begin
  inherited;

  Self.sbClient.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.sbClient.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
            Self.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind;

end;

procedure TFrameBox9Menu_XunKe_Home.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  APlayerOriginPoint:TPointF;
  AFirstItemRect:TRectF;
begin
  //传给ScrollBox的是相对窗体的绝对坐标
  //广告轮播Item的绘制区域
  APlayerOriginPoint:=PointF(0,0);
  APlayerOriginPoint:=imgPlayer.LocalToAbsolute(APlayerOriginPoint);
  AFirstItemRect:=RectF(APlayerOriginPoint.X,APlayerOriginPoint.Y,
                        APlayerOriginPoint.X+Self.imgPlayer.Width,
                        APlayerOriginPoint.Y+Self.imgPlayer.Height
                        );
  if PtInRect(AFirstItemRect,PointF(AMouseMoveX,AMouseMoveY)) then
  begin
    //在广告轮播控件内,那么要检查初始手势方向
  end
  else
  begin
    //不在在广告轮播控件内,那么随意滑动
    //AIsDecidedFirstGestureKind表示我已经确定好方向了，不需要再判断了
    //ADecidedFirstGestureKind表示判断好的方向
    AIsDecidedFirstGestureKind:=True;
    ADecidedFirstGestureKind:=TGestureKind.gmkVertical;
  end;
end;

end.
