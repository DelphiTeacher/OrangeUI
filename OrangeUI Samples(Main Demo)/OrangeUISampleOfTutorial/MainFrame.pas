//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, DateUtils,


  DemoViewFrame,

  MessageBoxFrame,
  WaitingFrame,
  HintFrame,
  SelectCityFrame,
  SelectAreaFrame,
  SelectMonthFrame,
  TakePictureMenuFrame,
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  AllImageFrame,
  PopupMenuFrame,
  AddressBookListFrame,
  SingleSelectFrame,
  MultiSelectFrame,
  {$ENDIF}


  uFuncCommon,
  uTimerTaskEvent,
  uVersion,
  uBaseLog,
  uLang,
  uUIFunction,
  uSkinItems,
  uFrameContext,

  uSkinFireMonkeyPanel,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, FMX.Edit,
  FMX.Controls.Presentation, uSkinFireMonkeyEdit, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel, uTimerTask,
  uSkinFireMonkeyCustomList, uSkinPanelType, uSkinLabelType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uDrawCanvas;

type
  TFrameMain = class(TFrame,IFrameChangeLanguageEvent)
    lbDemos: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    ItemMenu: TSkinFMXItemDesignerPanel;
    lblItemMenuCaption: TSkinFMXLabel;
    ItemHeader: TSkinFMXItemDesignerPanel;
    lblHeaderCaption: TSkinFMXLabel;
    pnlItemHeaderSign: TSkinFMXPanel;
    TimerTaskEventWaiting: TTimerTaskEvent;
    procedure lbDemosClickItem(Sender: TSkinItem);
    procedure TimerTaskEventWaitingExecute(Sender: TTimerTask);
    procedure TimerTaskEventWaitingExecuteEnd(Sender: TTimerTask);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  private
    FDemoViewFrame:TFrame;
  private
    //对话框返回
    procedure DoMessageBoxFrameModalResult(AMessageBoxFrame:TObject);
    //对话框返回
    procedure DoOneInputMessageBoxFrameModalResult(AMessageBoxFrame:TObject);
    //对话框返回
    procedure DoTwoInputMessageBoxFrameModalResult(AMessageBoxFrame:TObject);
  private
    //单选框返回
    procedure DoReturnFromSingleSelectFrame(ASingleSelectFrame:TFrame);
  private
    //多选框返回
    procedure DoReturnFromMultiSelectFrame(AMultiSelectFrame:TFrame);
  private
    //弹出框菜单点击
    procedure DoMenuClickFromPopupMenuFrame(APopupMenuFrame:TFrame);
  private
    //月份选择框返回
    procedure DoReturnFromSelectMonthFrame(ASelectMonthFrame:TFrame);
    procedure DoReturnFrameFromAllImageFrame(AFrame:TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;


var
  GlobalMainFrame:TFrameMain;


implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameMain.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.pnlToolBar.Text:=GetLangString(Self.pnlToolBar.Name+'Main',ALangKind);

  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(BasicControl)').Caption:=GetLangString('(BasicControl)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Button)').Caption:=GetLangString('(Button)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Label)').Caption:=GetLangString('(Label)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Image)').Caption:=GetLangString('(Image)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(CheckBox)').Caption:=GetLangString('(CheckBox)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(RadioButton)').Caption:=GetLangString('(RadioButton)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ImageList)').Caption:=GetLangString('(ImageList)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PageControl)').Caption:=GetLangString('(PageControl)',ALangKind);


  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ListControl)').Caption:=GetLangString('(ListControl)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ListBox)').Caption:=GetLangString('(ListBox)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ListView)').Caption:=GetLangString('(ListView)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TreeView)').Caption:=GetLangString('(TreeView)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ItemGrid)').Caption:=GetLangString('(ItemGrid)',ALangKind);


  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(EditControl)').Caption:=GetLangString('(EditControl)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Edit)').Caption:=GetLangString('(Edit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Memo)').Caption:=GetLangString('(Memo)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ComboBox)').Caption:=GetLangString('(ComboBox)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ComboEdit)').Caption:=GetLangString('(ComboEdit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(DateEdit)').Caption:=GetLangString('(DateEdit)',ALangKind);



  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SpecialControl)').Caption:=GetLangString('(SpecialControl)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(RollLabel)').Caption:=GetLangString('(RollLabel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ButtonGroup)').Caption:=GetLangString('(ButtonGroup)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(RoundImage)').Caption:=GetLangString('(RoundImage)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MultiColorLabel)').Caption:=GetLangString('(MultiColorLabel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ImageListPlayer)').Caption:=GetLangString('(ImageListPlayer)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ImageListViewer)').Caption:=GetLangString('(ImageListViewer)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(NotifyNumberIcon)').Caption:=GetLangString('(NotifyNumberIcon)',ALangKind);



  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Other)').Caption:=GetLangString('(Other)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Panel)').Caption:=GetLangString('(Panel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ScrollBar)').Caption:=GetLangString('(ScrollBar)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TrackBar)').Caption:=GetLangString('(TrackBar)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ScrollBox)').Caption:=GetLangString('(ScrollBox)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Material)').Caption:=GetLangString('(Material)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ProgressBar)').Caption:=GetLangString('(ProgressBar)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(DrawPanel)').Caption:=GetLangString('(DrawPanel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(FrameImage)').Caption:=GetLangString('(FrameImage)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ScrollControl)').Caption:=GetLangString('(ScrollControl)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PullLoadPanel)').Caption:=GetLangString('(PullLoadPanel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(DownloadPictureManager)').Caption:=GetLangString('(DownloadPictureManager)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SetBackColor)').Caption:=GetLangString('(SetBackColor)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HideVKBoard)').Caption:=GetLangString('(HideVKBoard)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TestFreeVersion)').Caption:=GetLangString('(TestFreeVersion)',ALangKind);



  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(CommonFrame)').Caption:=GetLangString('(CommonFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-Hint)').Caption:=GetLangString('(MessageBoxFrame-Hint)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-Select)').Caption:=GetLangString('(MessageBoxFrame-Select)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-Two)').Caption:=GetLangString('(MessageBoxFrame-Two)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-OneInput)').Caption:=GetLangString('(MessageBoxFrame-OneInput)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-TwoInput)').Caption:=GetLangString('(MessageBoxFrame-TwoInput)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(WaitingFrame)').Caption:=GetLangString('(WaitingFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HintFrame)').Caption:=GetLangString('(HintFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SingleSelectFrame)').Caption:=GetLangString('(SingleSelectFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MultiSelectFrame-Multi)').Caption:=GetLangString('(MultiSelectFrame-Multi)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MultiSelectFrame-Single)').Caption:=GetLangString('(MultiSelectFrame-Single)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SelectMonthFrame)').Caption:=GetLangString('(SelectMonthFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SelectCityFrame)').Caption:=GetLangString('(SelectCityFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SelectAreaFrame)').Caption:=GetLangString('(SelectAreaFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PopupMenuFrame)').Caption:=GetLangString('(PopupMenuFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TakePictureMenuFrame)').Caption:=GetLangString('(TakePictureMenuFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AllImageFrame)').Caption:=GetLangString('(AllImageFrame)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AddressBookListFrame)').Caption:=GetLangString('(AddressBookListFrame)',ALangKind);



end;

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;


//  Self.lvOrangeUIControlDemo.Prop.HorzScrollBarShowType:=sbstNone;


//  //1.第一种情况,垂直方向为主,水平方向一旦确定方向,垂直方向就不能再拖动了
//
//  //水平方向
//  Self.lvOrangeUIControlDemo.Prop.HorzControlGestureManager.IsNeedDecideFirstMouseMoveKind:=True;
//  Self.lvOrangeUIControlDemo.Prop.HorzControlGestureManager.DecideFirstMouseMoveKindCrement:=10;
//  Self.lvOrangeUIControlDemo.Prop.HorzControlGestureManager.DecideFirstMouseMoveKindAngle:=10;
//  //水平方向只能往右划
//  Self.lvOrangeUIControlDemo.Prop.HorzControlGestureManager.DecideFirstMouseMoveKindDirections:=[isdScrollToMax];
//  //水平方向只能往左划
//  Self.lvOrangeUIControlDemo.Prop.HorzControlGestureManager.DecideFirstMouseMoveKindDirections:=[isdScrollToMin];




//  //2.第一种情况,水平方向为主,垂直方向一旦确定方向,水平方向就不能再拖动了
//  Self.lvOrangeUIControlDemo.Prop.VertControlGestureManager.IsNeedDecideFirstMouseMoveKind:=True;
//  Self.lvOrangeUIControlDemo.Prop.VertControlGestureManager.DecideFirstMouseMoveKindCrement:=10;
//  Self.lvOrangeUIControlDemo.Prop.VertControlGestureManager.DecideFirstMouseMoveKindAngle:=10;
//  //垂直方向只能往下划
//  Self.lvOrangeUIControlDemo.Prop.VertControlGestureManager.DecideFirstMouseMoveKindDirections:=[isdScrollToMax];
//  //垂直方向只能往上划
//  Self.lvOrangeUIControlDemo.Prop.VertControlGestureManager.DecideFirstMouseMoveKindDirections:=[isdScrollToMin];


  //初始多语言
  RegLangString(Self.pnlToolBar.Name+'Main',[Self.pnlToolBar.Text,'OrangeUI']);


  RegLangString('(BasicControl)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(BasicControl)').Caption,'-(BasicControl)']);
  RegLangString('(Button)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Button)').Caption,'(Button)']);
  RegLangString('(Label)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Label)').Caption,'(Label)']);
  RegLangString('(Image)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Image)').Caption,'(Image)']);
  RegLangString('(CheckBox)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(CheckBox)').Caption,'(CheckBox)']);
  RegLangString('(RadioButton)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(RadioButton)').Caption,'(RadioButton)']);
  RegLangString('(ImageList)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ImageList)').Caption,'(ImageList)']);
  RegLangString('(PageControl)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PageControl)').Caption,'(PageControl)']);




  RegLangString('(ListControl)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ListControl)').Caption,'-(ListControl)']);
  RegLangString('(ListBox)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ListBox)').Caption,'(ListBox)']);
  RegLangString('(ListView)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ListView)').Caption,'(ListView)']);
  RegLangString('(TreeView)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TreeView)').Caption,'(TreeView)']);
  RegLangString('(ItemGrid)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ItemGrid)').Caption,'(ItemGrid)']);




  RegLangString('(EditControl)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(EditControl)').Caption,'-(EditControl)']);
  RegLangString('(Edit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Edit)').Caption,'(Edit)']);
  RegLangString('(Memo)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Memo)').Caption,'(Memo)']);
  RegLangString('(ComboBox)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ComboBox)').Caption,'(ComboBox)']);
  RegLangString('(ComboEdit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ComboEdit)').Caption,'(ComboEdit)']);
  RegLangString('(DateEdit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(DateEdit)').Caption,'(DateEdit)']);



  RegLangString('(SpecialControl)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SpecialControl)').Caption,'-(SpecialControl)']);
  RegLangString('(RollLabel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(RollLabel)').Caption,'(RollLabel)']);
  RegLangString('(ButtonGroup)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ButtonGroup)').Caption,'(ButtonGroup)']);
  RegLangString('(RoundImage)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(RoundImage)').Caption,'(RoundImage)']);
  RegLangString('(MultiColorLabel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MultiColorLabel)').Caption,'(MultiColorLabel)']);
  RegLangString('(ImageListPlayer)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ImageListPlayer)').Caption,'(ImageListPlayer)']);
  RegLangString('(ImageListViewer)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ImageListViewer)').Caption,'(ImageListViewer)']);
  RegLangString('(NotifyNumberIcon)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(NotifyNumberIcon)').Caption,'(NotifyNumberIcon)']);



 RegLangString('(Other)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Other)').Caption,'-(Other)']);
 RegLangString('(Panel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Panel)').Caption,'(Panel)']);
 RegLangString('(ScrollBar)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ScrollBar)').Caption,'(ScrollBar)']);
 RegLangString('(TrackBar)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TrackBar)').Caption,'(TrackBar)']);
 RegLangString('(ScrollBox)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ScrollBox)').Caption,'(ScrollBox)']);
 RegLangString('(Material)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Material)').Caption,'(Material)']);
 RegLangString('(ProgressBar)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ProgressBar)').Caption,'(ProgressBar)']);
 RegLangString('(DrawPanel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(DrawPanel)').Caption,'(DrawPanel)']);
 RegLangString('(FrameImage)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(FrameImage)').Caption,'(FrameImage)']);
 RegLangString('(ScrollControl)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(ScrollControl)').Caption,'(ScrollControl)']);
 RegLangString('(PullLoadPanel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PullLoadPanel)').Caption,'(PullLoadPanel)']);
 RegLangString('(DownloadPictureManager)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(DownloadPictureManager)').Caption,'(DownloadPictureManager)']);
 RegLangString('(SetBackColor)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SetBackColor)').Caption,'(SetBackColor)']);
 RegLangString('(HideVKBoard)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HideVKBoard)').Caption,'(HideVKBoard)']);
 RegLangString('(TestFreeVersion)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TestFreeVersion)').Caption,'(TestFreeVersion)']);



 RegLangString('(CommonFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(CommonFrame)').Caption,'-(CommonFrame)']);
 RegLangString('(MessageBoxFrame-Hint)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-Hint)').Caption,'(MessageBoxFrame-Hint)']);
 RegLangString('(MessageBoxFrame-Select)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-Select)').Caption,'(MessageBoxFrame-Select)']);
 RegLangString('(MessageBoxFrame-Two)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-Two)').Caption,'(MessageBoxFrame-Two)']);
 RegLangString('(MessageBoxFrame-OneInput)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-OneInput)').Caption,'(MessageBoxFrame-OneInput)']);
 RegLangString('(MessageBoxFrame-TwoInput)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MessageBoxFrame-TwoInput)').Caption,'(MessageBoxFrame-TwoInput)']);
 RegLangString('(WaitingFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(WaitingFrame)').Caption,'(WaitingFrame)']);
 RegLangString('(HintFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HintFrame)').Caption,'(HintFrame)']);
 RegLangString('(SingleSelectFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SingleSelectFrame)').Caption,'(SingleSelectFrame)']);
 RegLangString('(MultiSelectFrame-Multi)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MultiSelectFrame-Multi)').Caption,'(MultiSelectFrame-Multi)']);
 RegLangString('(MultiSelectFrame-Single)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(MultiSelectFrame-Single)').Caption,'(MultiSelectFrame-Single)']);
 RegLangString('(SelectMonthFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SelectMonthFrame)').Caption,'(SelectMonthFrame)']);
 RegLangString('(SelectCityFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SelectCityFrame)').Caption,'(SelectCityFrame)']);
 RegLangString('(SelectAreaFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(SelectAreaFrame)').Caption,'(SelectAreaFrame)']);
 RegLangString('(PopupMenuFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PopupMenuFrame)').Caption,'(PopupMenuFrame)']);
 RegLangString('(TakePictureMenuFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(TakePictureMenuFrame)').Caption,'(TakePictureMenuFrame)']);
 RegLangString('(AllImageFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AllImageFrame)').Caption,'(AllImageFrame)']);
 RegLangString('(AddressBookListFrame)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AddressBookListFrame)').Caption,'(AddressBookListFrame)']);


end;

destructor TFrameMain.Destroy;
begin

  inherited;
end;

procedure TFrameMain.DoMenuClickFromPopupMenuFrame(APopupMenuFrame: TFrame);
begin
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  ShowMessage('您选择的是 '+TFramePopupMenu(APopupMenuFrame).ModalResult);
  {$ENDIF}
end;

procedure TFrameMain.DoMessageBoxFrameModalResult(AMessageBoxFrame: TObject);
begin
  ShowMessage('您选择的是 '+TFrameMessageBox(AMessageBoxFrame).ModalResult);
end;

procedure TFrameMain.DoOneInputMessageBoxFrameModalResult(
  AMessageBoxFrame: TObject);
begin
  if TFrameMessageBox(AMessageBoxFrame).ModalResult='确定' then
  begin
    ShowMessage('您的姓名是 '+TFrameMessageBox(AMessageBoxFrame).edtInput1.Text);
  end;
end;

procedure TFrameMain.DoTwoInputMessageBoxFrameModalResult(
  AMessageBoxFrame: TObject);
begin
  if TFrameMessageBox(AMessageBoxFrame).ModalResult='确定' then
  begin
    ShowMessage('您的姓名是 '+TFrameMessageBox(AMessageBoxFrame).edtInput1.Text+#13#10
                +'您的年龄是 '+TFrameMessageBox(AMessageBoxFrame).edtInput2.Text
                );
  end;
end;

procedure TFrameMain.DoReturnFrameFromAllImageFrame(AFrame: TFrame);
var
  I: Integer;
//  ScaleFactor: Single;
//var
//  AListViewItem:TSkinListViewItem;
//  ABitmap:TBitmap;
begin
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  ShowMessage('您选择了'+IntToStr(GAllImageFrame.FSelectedOriginPhotoList.Count)+'张图片');
  {$ENDIF}

//  for I := 0 to GAllImageFrame.FSelectedOriginPhotoList.Count-1 do
//  begin
//      //照片返回
//      //尺寸如果超过1024,那么需要按比例缩小
//      if GAllImageFrame.FSelectedOriginPhotoList[I].Width > 1024 then
//      begin
//        ScaleFactor := GAllImageFrame.FSelectedOriginPhotoList[I].Width / 1024;
//        GAllImageFrame.FSelectedOriginPhotoList[I].Resize(Round(GAllImageFrame.FSelectedOriginPhotoList[I].Width / ScaleFactor), Round(GAllImageFrame.FSelectedOriginPhotoList[I].Height / ScaleFactor));
//      end;
//
//
//      ABitmap:=GAllImageFrame.FSelectedOriginPhotoList[I];
//      //添加一张图片
//      AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//      //要放在Icon.Assign前面
//      AListViewItem.Icon.Url:='';
//      AListViewItem.Icon.Assign(ABitmap);
//      //避免花掉
//      CopyBitmap(ABitmap,AListViewItem.Icon);
//
//  end;


//  AlignControls;


end;

procedure TFrameMain.DoReturnFromMultiSelectFrame(AMultiSelectFrame: TFrame);
begin
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  ShowMessage('您选择的是 '+TFrameMultiSelect(AMultiSelectFrame).SelectedList.CommaText);
  {$ENDIF}
end;

procedure TFrameMain.DoReturnFromSelectMonthFrame(ASelectMonthFrame: TFrame);
begin
  ShowMessage('您选择的是 '+FormatDateTime('YYYY年MM月',TFrameSelectMonth(ASelectMonthFrame).GetMonth));
end;

procedure TFrameMain.DoReturnFromSingleSelectFrame(ASingleSelectFrame: TFrame);
begin
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  ShowMessage('您选择的是 '+TFrameSingleSelect(ASingleSelectFrame).Selected);
  {$ENDIF}
end;

procedure TFrameMain.lbDemosClickItem(Sender: TSkinItem);
begin
  if Sender.Caption='' then Exit;
  if Sender.ItemType<>sitDefault then Exit;

  if Sender.Name='CommonFrame' then
  begin

      //常用界面示例

      //单个对话框,常用提示对话框
      if Pos('(MessageBoxFrame-Hint)',Sender.Caption)>0 then
      begin
          ShowMessageBoxFrame(frmMain,'请输入手机号!');
//          ShowMessageBoxFrame(frmMain,'请输入手机号!','',TMsgDlgType.mtInformation,['确定'],nil);
      end;

      //选择对话框
      if Pos('(MessageBoxFrame-Select)',Sender.Caption)>0 then
      begin
//          ShowMessageBoxFrame(frmMain,
//                                '您今天过的开心吗?',
//                                '选择开心程度',
//                                TMsgDlgType.mtInformation,
//                                ['很开心','一般'],
//                                //回调事件
//                                DoMessageBoxFrameModalResult);

          ShowMessageBoxFrame(frmMain,
                                'Are you happy today?',
                                'Select',
                                TMsgDlgType.mtCustom,
                                ['Very Happy','Just so so'],
                                //Call Back
                                DoMessageBoxFrameModalResult,
                                nil,
                                'Information'
                                );
      end;

      //同时弹出两个以上的对话框
      if Pos('(MessageBoxFrame-Two)',Sender.Caption)>0 then
      begin
          ShowMessageBoxFrame(frmMain,'我是被压在底下的第一个对话框!');
          ShowMessageBoxFrame(frmMain,'我是突然弹出的第二个对话框!');
      end;

      //输入对话框
      if Pos('(MessageBoxFrame-OneInput)',Sender.Caption)>0 then
      begin
          ShowMessageBoxFrame(frmMain,
                              '',
                              '',
                              TMsgDlgType.mtInformation,
                              ['确定','取消'],
                              DoOneInputMessageBoxFrameModalResult,
                              nil,
                              '请输入你的年龄',
                              ConvertToStringDynArray([]),
                              nil,
                              1);
          GlobalMessageBoxFrame.pnlInput1.Caption:='姓名';
          GlobalMessageBoxFrame.edtInput1.Text:='';
          GlobalMessageBoxFrame.edtInput1.TextPrompt:='请输入您的姓名';
          GlobalMessageBoxFrame.edtInput1.FilterChar:='';
          GlobalMessageBoxFrame.edtInput1.KeyboardType:=TVirtualKeyboardType.Default;
          GlobalMessageBoxFrame.btnDec1.Visible:=False;
          GlobalMessageBoxFrame.btnInc1.Visible:=False;
      end;


      //输入对话框
      if Pos('(MessageBoxFrame-TwoInput)',Sender.Caption)>0 then
      begin
          ShowMessageBoxFrame(frmMain,
                              '',
                              '',
                              TMsgDlgType.mtInformation,
                              ['确定','取消'],
                              DoTwoInputMessageBoxFrameModalResult,
                              nil,
                              '请输入你的个人信息',
                              ConvertToStringDynArray([]),
                              nil,
                              2);
          GlobalMessageBoxFrame.pnlInput1.Caption:='姓名';
          GlobalMessageBoxFrame.edtInput1.Text:='';
          GlobalMessageBoxFrame.edtInput1.TextPrompt:='请输入您的姓名';
          GlobalMessageBoxFrame.edtInput1.FilterChar:='';
          GlobalMessageBoxFrame.edtInput1.KeyboardType:=TVirtualKeyboardType.Default;
          GlobalMessageBoxFrame.btnDec1.Visible:=False;
          GlobalMessageBoxFrame.btnInc1.Visible:=False;

          GlobalMessageBoxFrame.pnlInput2.Caption:='年龄';
          GlobalMessageBoxFrame.edtInput2.Text:='';
          GlobalMessageBoxFrame.edtInput2.TextPrompt:='请输入您的年龄';
          GlobalMessageBoxFrame.edtInput2.FilterChar:='0123456789';
          GlobalMessageBoxFrame.edtInput2.KeyboardType:=TVirtualKeyboardType.NumberPad;
          GlobalMessageBoxFrame.btnDec2.Visible:=True;
          GlobalMessageBoxFrame.btnInc2.Visible:=True;
      end;

      //等待框
      if Pos('(WaitingFrame)',Sender.Caption)>0 then
      begin
          ShowWaitingFrame(frmMain,'正在加载...');
          //执行线程任务,任务结束之后,关闭等待框
          Self.TimerTaskEventWaiting.Run;
      end;

      //自动消息的提示框
      if Pos('(HintFrame)',Sender.Caption)>0 then
      begin
          ShowHintFrame(frmMain,'任务执行成功!');
      end;

      {$IFDEF OPENSOURCE_VERSION}
      //开源版没有ListView,TreeView,Grid
      {$ELSE}
          //单选页面
          if Pos('(SingleSelectFrame)',Sender.Caption)>0 then
          begin
              HideFrame;//(Self,hfcttBeforeShowFrame);
              //OK
              //显示单选择界面
              ShowFrame(TFrame(GlobalSingleSelectFrame),TFrameSingleSelect,DoReturnFromSingleSelectFrame);//,frmMain,nil,nil,DoReturnFromSingleSelectFrame,Application);
    //          GlobalSingleSelectFrame.FrameHistroy:=CurrentFrameHistroy;
              GlobalSingleSelectFrame.Init('单选性别','男,女,保密','');
          end;

          //多选页面
          if Pos('(MultiSelectFrame-Multi)',Sender.Caption)>0 then
          begin
              HideFrame;//(Self,hfcttBeforeShowFrame);
              //OK
              //显示多选择界面
              ShowFrame(TFrame(GlobalMultiSelectFrame),TFrameMultiSelect,DoReturnFromMultiSelectFrame);//frmMain,nil,nil,DoReturnFromMultiSelectFrame,Application);
    //          GlobalMultiSelectFrame.FrameHistroy:=CurrentFrameHistroy;
              GlobalMultiSelectFrame.Init('点菜','鱼香肉丝,红烧肉,番茄炒蛋','红烧肉');
          end;

          //多选页面
          if Pos('(MultiSelectFrame-Single)',Sender.Caption)>0 then
          begin
              HideFrame;//(Self,hfcttBeforeShowFrame);
              //OK
              //显示多选择界面-单选模式
              ShowFrame(TFrame(GlobalMultiSelectFrame),TFrameMultiSelect,DoReturnFromMultiSelectFrame);//frmMain,nil,nil,DoReturnFromMultiSelectFrame,Application);
    //          GlobalMultiSelectFrame.FrameHistroy:=CurrentFrameHistroy;
              GlobalMultiSelectFrame.Init('你喜欢','游戏,听歌,运动','运动',False);
          end;

          //弹出窗体
          if Pos('(PopupMenuFrame)',Sender.Caption)>0 then
          begin
              //OK
              //弹出选择时间段,ShowFrame可以按返回键返回
              ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoMenuClickFromPopupMenuFrame,Application,True,True,ufsefNone);
              GlobalPopupMenuFrame.Init('现在是?',['上午','中午','下午','晚上']);
          end;

          //多选照片
          if Pos('(AllImageFrame)',Sender.Caption)>0 then
          begin
              HideFrame;//(Self,hfcttBeforeShowFrame);
              //拍照
              ShowFrame(TFrame(GAllImageFrame),TFrameAllImage,Application.MainForm,nil,nil,DoReturnFrameFromAllImageFrame,Application,True,False,ufsefNone);
    //          GAllImageFrame.FrameHistroy:=CurrentFrameHistroy;
              //相机结果回调事件
    //          GAllImageFrame.OnGetPhotoFromCamera:=DoAddPictureFromMenu;
              GAllImageFrame.Load(True,
                                  0,
                                  6);//Self.lvPictures.Prop.Items.Count-1,
    //                              Self.FMaxCount);
          end;


          //通讯录
          if Pos('(AddressBookListFrame)',Sender.Caption)>0 then
          begin
              HideFrame;//(Self,hfcttBeforeShowFrame);
              //通讯录
              ShowFrame(TFrame(GlobalAddressBookListFrame),TFrameAddressBookList);
              GlobalAddressBookListFrame.Load;
          end;

      {$ENDIF}

      //城市选择页面
      if Pos('(SelectCityFrame)',Sender.Caption)>0 then
      begin
          HideFrame;//(Self,hfcttBeforeShowFrame);
          //OK
          //选择城市
          ShowFrame(TFrame(GlobalSelectCityFrame),TFrameSelectCity,frmMain,nil,nil,nil,Application);
//          GlobalSelectCityFrame.FrameHistroy:=CurrentFrameHistroy;
          GlobalSelectCityFrame.Init('浙江省','金华市');
      end;

      //获取选择页面
      if Pos('(SelectAreaFrame)',Sender.Caption)>0 then
      begin
          HideFrame;//(Self,hfcttBeforeShowFrame);
          //OK
          //选择区域
          ShowFrame(TFrame(GlobalSelectAreaFrame),TFrameSelectArea,frmMain,nil,nil,nil,Application);
//          GlobalSelectAreaFrame.FrameHistroy:=CurrentFrameHistroy;

          //使用接口返回的数据

//          //新西兰
//          GlobalSelectAreaFrame.LoadDataFromWeb(
//                    'http://www.orangeui.cn:10000/basicdatamanage/',
//                    'New Zealand'
//                    );
//          //英文
//          GlobalSelectAreaFrame.Init('','','',False,True);


//          //中国
//          GlobalSelectAreaFrame.LoadDataFromWeb(
//                    'http://www.orangeui.cn:10000/basicdatamanage/',
//                    'China'
//                    );
//          GlobalSelectAreaFrame.Init('浙江省','金华市','婺城区',False);


//          GlobalSelectAreaFrame.Init('浙江','金华','婺城区',False,True);



          //使用默认数据
          GlobalSelectAreaFrame.Init('浙江省','金华市','婺城区',True);
      end;

      //月份选择页面
      if Pos('(SelectMonthFrame)',Sender.Caption)>0 then
      begin
          //OK
          //选择月份
          ShowFrame(TFrame(GlobalSelectMonthFrame),TFrameSelectMonth,frmMain,nil,nil,DoReturnFromSelectMonthFrame,Application,True,True,ufsefNone);
          GlobalSelectMonthFrame.Init(2010,YearOf(Now),Now);
      end;

      //拍照弹出框
      if Pos('(TakePictureMenuFrame)',Sender.Caption)>0 then
      begin
          //拍照
          ShowFrame(TFrame(GlobalTakePictureMenuFrame),TFrameTakePictureMenu,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
          GlobalTakePictureMenuFrame.OnTakedPicture:=nil;
          GlobalTakePictureMenuFrame.ShowMenu;
      end;


  end
  else
  begin
      //控件示例
      HideFrame;//(Self,hfcttBeforeShowFrame);
      ShowFrame(TFrame(FDemoViewFrame),TFrameDemoView,frmMain,nil,nil,nil,frmMain,True,True,ufsefDefault);
//      TFrameDemoView(FDemoViewFrame).FrameHistroy:=CurrentFrameHistroy;
      TFrameDemoView(FDemoViewFrame).ShowDemo(Sender.Caption,'Main');
  end;


end;

procedure TFrameMain.TimerTaskEventWaitingExecute(Sender: TTimerTask);
begin
  //在线程中调用接口
  Sleep(3000);
end;

procedure TFrameMain.TimerTaskEventWaitingExecuteEnd(Sender: TTimerTask);
begin
  //线程任务执行结束
  //隐藏等待框
  HideWaitingFrame;
end;

end.
