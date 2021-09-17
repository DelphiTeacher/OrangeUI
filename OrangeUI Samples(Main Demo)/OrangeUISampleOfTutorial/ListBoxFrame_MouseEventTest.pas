//convert pas to utf8 by ¥

unit ListBoxFrame_MouseEventTest;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uSkinItems,
  uSkinControlGestureManager,
  uDrawPicture, uSkinImageList, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, uSkinFireMonkeyImageListViewer,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinMaterial, uSkinImageType,
  uSkinFireMonkeyCustomList, uSkinLabelType, uSkinPanelType, uSkinButtonType,
  uSkinImageListViewerType, uSkinItemDesignerPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uDrawCanvas;

type
  TFrameListBox_MouseEventTest = class(TFrame,IFrameChangeLanguageEvent)
    lbMouseEvent: TSkinFMXListBox;
    ItemHeader: TSkinFMXItemDesignerPanel;
    imgPlayer: TSkinFMXImageListViewer;
    bgIndicator: TSkinFMXButtonGroup;
    ItemFooter: TSkinFMXItemDesignerPanel;
    pnlFooterHeader: TSkinFMXPanel;
    pnlFooterSign: TSkinFMXPanel;
    lblFooterCaption: TSkinFMXLabel;
    pnlFooterDevide: TSkinFMXPanel;
    ItemSearchBar: TSkinFMXItemDesignerPanel;
    imgSearchBarRightTop: TSkinFMXImage;
    imgSearchBarLeft: TSkinFMXImage;
    imgSearchBarRightBottom: TSkinFMXImage;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgDefaultIcon: TSkinFMXImage;
    SkinFMXPanel4: TSkinFMXPanel;
    lblDefaultCaption: TSkinFMXLabel;
    lblDefaultPrice: TSkinFMXLabel;
    imgDefaultFrom: TSkinFMXImage;
    imglistPlayer: TSkinImageList;
    imglistLeft: TSkinImageList;
    imglistRight: TSkinImageList;
    imglistProduct: TSkinImageList;
    ItemItem1: TSkinFMXItemDesignerPanel;
    imgItem1RightTop: TSkinFMXImage;
    imgItem1Left: TSkinFMXImage;
    imgItem1RightBottom: TSkinFMXImage;
    ItemItem2: TSkinFMXItemDesignerPanel;
    imgItem2RightTop: TSkinFMXImage;
    imgItem2Left: TSkinFMXImage;
    imgItem2RightBottom: TSkinFMXImage;
    procedure imgSearchBarLeftClick(Sender: TObject);
    procedure imgSearchBarRightTopClick(Sender: TObject);
    procedure imgSearchBarRightBottomClick(Sender: TObject);
    procedure lbMouseEventClickItem(Sender: TSkinItem);
    procedure imgItem1RightTopClick(Sender: TObject);
    procedure imgItem1LeftClick(Sender: TObject);
    procedure imgItem1RightBottomClick(Sender: TObject);
    procedure imgItem2RightTopClick(Sender: TObject);
    procedure imgItem2LeftClick(Sender: TObject);
    procedure imgItem2RightBottomClick(Sender: TObject);
    procedure lbMouseEventLongTapItem(Sender: TObject; Item: TSkinItem);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  private
    procedure DolbMouseEventVertSkinControlGestureManagerPrepareDecidedFirstGestureKind(
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

procedure TFrameListBox_MouseEventTest.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbMouseEvent.Prop.Items[0].Caption:=GetLangString(Self.lbMouseEvent.Name+'Caption 0',ALangKind);
  Self.lbMouseEvent.Prop.Items[2].Caption:=GetLangString(Self.lbMouseEvent.Name+'Caption 2',ALangKind);
  Self.lbMouseEvent.Prop.Items[4].Caption:=GetLangString(Self.lbMouseEvent.Name+'Caption 4',ALangKind);
  Self.lbMouseEvent.Prop.Items[6].Caption:=GetLangString(Self.lbMouseEvent.Name+'Caption 6',ALangKind);
  Self.lbMouseEvent.Prop.Items[8].Caption:=GetLangString(Self.lbMouseEvent.Name+'Caption 8',ALangKind);

end;

constructor TFrameListBox_MouseEventTest.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.lbMouseEvent.Name+'Caption 0',
                [Self.lbMouseEvent.Prop.Items[0].Caption,'Test switch picture and scroll updown,could''t conflict']);
  RegLangString(Self.lbMouseEvent.Name+'Caption 2',
                [Self.lbMouseEvent.Prop.Items[2].Caption,'Test clicked multi child']);
  RegLangString(Self.lbMouseEvent.Name+'Caption 4',
                [Self.lbMouseEvent.Prop.Items[4].Caption,'Test clicked child that multi-tier']);
  RegLangString(Self.lbMouseEvent.Name+'Caption 6',
                [Self.lbMouseEvent.Prop.Items[6].Caption,'Test clicked item']);
  RegLangString(Self.lbMouseEvent.Name+'Caption 8',
                [Self.lbMouseEvent.Prop.Items[8].Caption,'Test clicked child that innermost']);

  Self.lbMouseEvent.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.lbMouseEvent.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
    Self.DolbMouseEventVertSkinControlGestureManagerPrepareDecidedFirstGestureKind;
end;

procedure TFrameListBox_MouseEventTest.imgItem1LeftClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('点击了第二层图片');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you clicked image that middle tier');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgItem1RightBottomClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('点击了最顶层图片');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you clicked image that top tier');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgItem1RightTopClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('点击了最底层图片');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you clicked image that bottom tier');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgItem2LeftClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('HitTest设置为了False,你不应该看到此对话框');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you should not see this dialog');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgItem2RightBottomClick(
  Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('点击了最顶层图片');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you clicked image that top tier');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgItem2RightTopClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('HitTest设置为了False,你不应该看到此对话框');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you should not see this dialog');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgSearchBarLeftClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('点击了左边图片');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you clicked image that left');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgSearchBarRightBottomClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('点击了右下图片');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you clicked image that right-bottom');
  end;
end;

procedure TFrameListBox_MouseEventTest.imgSearchBarRightTopClick(Sender: TObject);
begin
  if LangKind=lkZH then
  begin
    ShowMessage('点击了右上图片');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('you clicked image that right-top');
  end;
end;

procedure TFrameListBox_MouseEventTest.lbMouseEventClickItem(Sender: TSkinItem);
begin
  if Sender.ItemType=sitDefault then
  begin
    if LangKind=lkZH then
    begin
      ShowMessage('你点击了默认的列表项');
    end
    else if LangKind=lkEN then
    begin
      ShowMessage('you clicked item');
    end;
  end;
end;

procedure TFrameListBox_MouseEventTest.lbMouseEventLongTapItem(Sender: TObject;Item: TSkinItem);
begin
  if Item.ItemType=sitDefault then
  begin
      if LangKind=lkZH then
      begin
        ShowMessage('你长按了默认的列表项');
      end
      else if LangKind=lkEN then
      begin
        ShowMessage('you long-taped item');
      end;
  end;
end;

procedure TFrameListBox_MouseEventTest.
  DolbMouseEventVertSkinControlGestureManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  AFirstItemRect:TRectF;
begin
  //广告轮播Item的绘制区域
  AFirstItemRect:=Self.lbMouseEvent.Prop.Items[1].ItemDrawRect;
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
