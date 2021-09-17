//convert pas to utf8 by ¥

unit HomeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinItems,
  uSkinListBoxType,
  ShopFrame,
  SearchFrame,
  CategoryFrame,
  uSkinControlGestureManager,
  XunKeCommonSkinMaterialModule,
  uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinImageList,
  uSkinFireMonkeyButton, uSkinButtonType, uSkinFireMonkeyImageListViewer,
  uDrawPicture, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyFrameImage, uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollBox, uSkinMaterial,
  uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyListView,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList, uSkinPanelType,
  uSkinImageListViewerType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinScrollBoxContentType, uSkinScrollControlType,
  uSkinScrollBoxType, uDrawCanvas;

type
  TFrameHome = class(TFrame)
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
    procedure btnSearchClick(Sender: TObject);
    procedure btnCategoryClick(Sender: TObject);
    procedure lblMenuClickItem(Sender: TSkinItem);
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

var
  GlobalHomeFrame:TFrameHome;

implementation

uses
  MainForm,
  MainFrame;


{$R *.fmx}

procedure TFrameHome.btnCategoryClick(Sender: TObject);
begin
  //打开类目
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalCategoryFrame),TFrameCategory,frmMain,nil,nil,nil,Application);
//  GlobalCategoryFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameHome.btnSearchClick(Sender: TObject);
begin
  //跳转到搜索界面
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalSearchFrame),TFrameSearch,frmMain,nil,nil,nil,Application);
//  GlobalSearchFrame.FrameHistroy:=CurrentFrameHistroy;

end;

constructor TFrameHome.Create(AOwner: TComponent);
begin
  inherited;

  //处理手势冲突
  Self.sbClient.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.sbClient.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
            Self.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind;

end;

procedure TFrameHome.DoScrollBoxVertManagerPrepareDecidedFirstGestureKind(
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

procedure TFrameHome.lblMenuClickItem(Sender: TSkinItem);
begin
  //打开类目
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalCategoryFrame),TFrameCategory,frmMain,nil,nil,nil,Application);
//  GlobalCategoryFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.
