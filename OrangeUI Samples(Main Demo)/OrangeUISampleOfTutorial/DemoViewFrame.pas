//convert pas to utf8 by ¥

unit DemoViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,

  ButtonFrame,
  LabelFrame,
  ImageListFrame,
  ImageFrame,
  ImageListPalyerFrame,
  CheckBoxFrame,
  RadioButtonFrame,
  TrackBarFrame,
  ScrollBarFrame,
  ListBoxFrame_Main,
  ListViewFrame_Main,
  TreeViewFrame_Main,
  PageControlFrame,
  EditFrame,
  MemoFrame,
  NotifyNumberIconFrame,
  PullLoadPanelFrame,
  ImageListViewerFrame,
  ProgressBarFrame,
  MaterialFrame,
  ButtonGroupFrame,
  FrameImageFrame,
  RoundImageFrame,
  ScrollControlFrame,
  PanelFrame,
  ComboBoxFrame,
  ComboEditFrame,
  DateEditFrame,
  ScrollBoxFrame,
  MultiColorLabelFrame,
  DownloadPictureManagerFrame,
  SetBackColorFrame,
  HideVKBoardFrame,
  RollLabelFrame,


  ListBoxFrame_UseCenterSelect,
  ListBoxFrame_UseHorzListBox,
  ListBoxFrame_UseItemDesignerPanel,
  ListBoxFrame_UseItemEdit,
  ListBoxFrame_UseItemComboBox,
  ListBoxFrame_UseItemPanDrag,
  ListBoxFrame_UseDynamicBinding,
  ListBoxFrame_UseSelfOwnMaterial,
  ListBoxFrame_UseAutoDownloadIcon,
  ListBoxFrame_MouseEventTest,
  ListBoxFrame_GetSkinItemDataIntf,
  ListBoxFrame_SortItems,
  ListBoxFrame_FilterItems,
  ListBoxFrame_BindingMultiPic,
  ListBoxFrame_BindingMultiPic2,
  ListBoxFrame_UseMultiDesignerPanel,
  ListBoxFrame_AutoPullDownRefresh,
  ListBoxFrame_UseItemAnimate,



  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  ListBoxFrame_SpeedCompare,
  ListBoxFrame_ItemOperCode,
  DrawPanelFrame,
  ListViewFrame_ItemDesignTimeColor,
  TestFreeVersionFrame,

  ListViewFrame_UseSelfOwnMaterial,
  ListViewFrame_UseSelfOwnMaterial_9BoxMenu,
  ListViewFrame_ItemDesignerPanel_9BoxMenu,
  ListViewFrame_UseHorzListView,
  ListViewFrame_TestWaterfall,
  ListViewFrame_TestListView,
  ListViewFrame_HuaBanWaterfall,
  ListViewFrame_FixColCountNotFit,
  ListViewFrame_FixColCountFit,
  ListViewFrame_AutoColCountNotFit,
  ListViewFrame_AutoColCountFit,
  ListViewFrame_HorzFixColCountNotFit,
  ListViewFrame_HorzFixColCountFit,
  ListViewFrame_HorzAutoColCountNotFit,
  ListViewFrame_HorzAutoColCountFit,


  TreeViewFrame_Common,
  TreeViewFrame_BlackStyle,

  ItemGridFrame_Main,
  ItemGridFrame_Simple,
  ItemGridFrame_IndicatorCol,
  ItemGridFrame_FixedCol,
  ItemGridFrame_Footer,
  ItemGridFrame_UseItemDesignerPanel,
  ItemGridFrame_WhiteBackColor,
  ItemGridFrame_CustomRowColor,
  ItemGridFrame_GridDevideLine,
  ItemGridFrame,
  {$ENDIF}



  uLang,
  uFuncCommon,
  uFrameContext,

  uUIFunction, uSkinFireMonkeyLabel, uSkinLabelType, uSkinButtonType,
  uBaseSkinControl, uSkinPanelType;

type
  TFrameDemoView = class(TFrame,IFrameChangeLanguageEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblDemo: TSkinFMXLabel;
    pnlClient: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
  private
    FDemoFrame:TFrame;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure ShowDemo(Demo:String;Classify:String);
    procedure ShowFrame(FrameClass:TFrameClass);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;



implementation


{$R *.fmx}

uses
  MainForm;


procedure TFrameDemoView.btnReturnClick(Sender: TObject);
begin
  //测试1:没有效果
//  HideFrame;////(Self,hfcttBeforeReturnFrame,ufsefNone);
//  ReturnFrame;//(Self.FrameHistroy);


  //测试2:有效果
  //<- Self(From) -< GlobalDemoViewFrame(To)
  HideFrame;////(Self,hfcttBeforeReturnFrame,ufsefDefault);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameDemoView.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.pnlToolBar.Text:=GetLangString(Self.pnlToolBar.Name+'Demo',ALangKind);

end;

constructor TFrameDemoView.Create(AOwner: TComponent);
begin
  inherited;
  //初始多语言
  RegLangString(Self.pnlToolBar.Name+'Demo',[Self.pnlToolBar.Text,'Introduce']);

end;

procedure TFrameDemoView.ShowDemo(Demo: String;Classify:String);
begin

  Self.lblDemo.Caption:=Demo;


  if Pos('(Button)',Demo)>0 then ShowFrame(TFrameButton);
  if Pos('(Label)',Demo)>0 then ShowFrame(TFrameLabel);
  if Pos('(Image)',Demo)>0 then ShowFrame(TFrameImage);
  if Pos('(CheckBox)',Demo)>0 then ShowFrame(TFrameCheckBox);
  if Pos('(RadioButton)',Demo)>0 then ShowFrame(TFrameRadioButton);
  if Pos('(ImageList)',Demo)>0 then ShowFrame(TFrameImageList);
  if Pos('(PageControl)',Demo)>0 then ShowFrame(TFramePageControl);


  if Pos('(ListBox)',Demo)>0 then ShowFrame(TFrameListBox_Main);


  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  if Pos('(ListView)',Demo)>0 then ShowFrame(TFrameListView_Main);
  if Pos('(TreeView)',Demo)>0 then ShowFrame(TFrameTreeView_Main);
  if Pos('(ItemGrid)',Demo)>0 then ShowFrame(TFrameItemGrid_Main);
  {$ENDIF}

  if Pos('(Edit)',Demo)>0 then ShowFrame(TFrameEdit);
  if Pos('(Memo)',Demo)>0 then ShowFrame(TFrameMemo);
  if Pos('(ComboBox)',Demo)>0 then ShowFrame(TFrameComboBox);
  if Pos('(ComboEdit)',Demo)>0 then ShowFrame(TFrameComboEdit);
  if Pos('(DateEdit)',Demo)>0 then ShowFrame(TFrameDateEdit);



  if Pos('(RollLabel)',Demo)>0 then ShowFrame(TFrameRollLabel);
  if Pos('(ButtonGroup)',Demo)>0 then ShowFrame(TFrameButtonGroup);
  if Pos('(RoundImage)',Demo)>0 then ShowFrame(TFrameRoundImage);
  if Pos('(MultiColorLabel)',Demo)>0 then ShowFrame(TFrameMultiColorLabel);
  if Pos('(ImageListPlayer)',Demo)>0 then ShowFrame(TFrameImageListPlayer);
  if Pos('(ImageListViewer)',Demo)>0 then ShowFrame(TFrameImageListViewer);
  if Pos('(NotifyNumberIcon)',Demo)>0 then ShowFrame(TFrameNotifyNumberIcon);


  if Pos('(Panel)',Demo)>0 then ShowFrame(TFramePanel);
  if Pos('(ScrollBar)',Demo)>0 then ShowFrame(TFrameScrollBar);
  if Pos('(TrackBar)',Demo)>0 then ShowFrame(TFrameTrackBar);
  if Pos('(ScrollBox)',Demo)>0 then ShowFrame(TFrameScrollBox);
  if Pos('(Material)',Demo)>0 then ShowFrame(TFrameMaterial);
  if Pos('(ProgressBar)',Demo)>0 then ShowFrame(TFrameProgressBar);
  if Pos('(FrameImage)',Demo)>0 then ShowFrame(TFrameFrameImage);
  if Pos('(ScrollControl)',Demo)>0 then ShowFrame(TFrameScrollControl);
  if Pos('(PullLoadPanel)',Demo)>0 then ShowFrame(TFramePullLoadPanel);
  if Pos('(DownloadPictureManager)',Demo)>0 then ShowFrame(TFrameDownloadPictureManager);
  if Pos('(TrackBar)',Demo)>0 then ShowFrame(TFrameTrackBar);
//  if Pos('(Animator)',Demo)>0 then ShowFrame(TFrameAnimator);
  if Pos('(SetBackColor)',Demo)>0 then ShowFrame(TFrameSetBackColor);
  if Pos('(HideVKBoard)',Demo)>0 then ShowFrame(TFrameHideVKBoard);





  if Classify='ListBox' then
  begin

    {$IFDEF OPENSOURCE_VERSION}
    //开源版没有ListView,TreeView,Grid
    {$ELSE}
    if Pos('(Add Item By Code)',Demo)>0 then ShowFrame(TFrameListBox_ItemOperCode);
    if Pos('(Test Speed Of Batch Add)',Demo)>0 then ShowFrame(TFrameListBox_SpeedCompare);
    {$ENDIF}



    if Pos('(Use SelfOwnMaterial)',Demo)>0 then ShowFrame(TFrameListBox_UseSelfOwnMaterial);
    if Pos('(Use ItemDesignerPanel)',Demo)>0 then ShowFrame(TFrameListBox_UseItemDesignerPanel);
    if Pos('(Dynamic Binding)',Demo)>0 then ShowFrame(TFrameListBox_UseDynamicBinding);
    if Pos('(Edit Item By ComboBox)',Demo)>0 then ShowFrame(TFrameListBox_UseItemComboBox);
    if Pos('(Edit Item By EditBox)',Demo)>0 then ShowFrame(TFrameListBox_UseItemEdit);
    if Pos('(PanDrag Item)',Demo)>0 then ShowFrame(TFrameListBox_UseItemPanDrag);
    if Pos('(Horz Mode)',Demo)>0 then ShowFrame(TFrameListBox_UseHorzListBox);
    if Pos('(Center-Select Mode)',Demo)>0 then ShowFrame(TFrameListBox_UseCenterSelect);
    if Pos('(Download Icon Auto)',Demo)>0 then ShowFrame(TFrameListBox_UseAutoDownloadIcon);
    if Pos('(Test MouseEvent)',Demo)>0 then ShowFrame(TFrameListBox_MouseEventTest);
    if Pos('(Sort)',Demo)>0 then ShowFrame(TFrameListBox_SortItems);
    if Pos('(Filter)',Demo)>0 then ShowFrame(TFrameListBox_FilterItems);
    if Pos('(Bind Multi Images 1)',Demo)>0 then ShowFrame(TFrameListBox_BindingMultiPic);
    if Pos('(Bind Multi Images 2)',Demo)>0 then ShowFrame(TFrameListBox_BindingMultiPic2);
    if Pos('(Use Multi ItemDesignerPanel)',Demo)>0 then ShowFrame(TFrameListBox_UseMultiDesignerPanel);
    if Pos('(PullDownRefresh Auto)',Demo)>0 then ShowFrame(TFrameListBox_AutoPullDownRefresh);
    if Pos('(GetSkinItemDataIntf)',Demo)>0 then ShowFrame(TFrameListBox_GetSkinItemDataIntf);
    if Pos('(Use ItemAnimate)',Demo)>0 then ShowFrame(TFrameListBox_UseItemAnimate);
  end;


  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  if Pos('(DrawPanel)',Demo)>0 then ShowFrame(TFrameDrawPanel);
  if Pos('(TestFreeVersion)',Demo)>0 then ShowFrame(TFrameTestFreeVersion);

  if Classify='ListView' then
  begin
    if Pos('(Use SelfOwnMaterial)',Demo)>0 then ShowFrame(TFrameListView_UseSelfOwnMaterial);
    if Pos('(Custom Item Color)',Demo)>0 then ShowFrame(TFrameListView_ItemDesignTimeColor);
    if Pos('(9BoxMenu by SelfOwnMaterial)',Demo)>0 then ShowFrame(TFrameListView_UseSelfOwnMaterial_9BoxMenu);
    if Pos('(9BoxMenu by ItemDesignerPanel)',Demo)>0 then ShowFrame(TFrameListView_ItemDesignerPanel_9BoxMenu);
    if Pos('(Horz mode)',Demo)>0 then ShowFrame(TFrameListView_UseHorzListView);
    if Pos('(Test Waterfall mode 1)',Demo)>0 then ShowFrame(TFrameListView_TestWaterfall);
    if Pos('(Test Waterfall mode 2)',Demo)>0 then ShowFrame(TFrameListView_HuaBanWaterfall);

    if Pos('(Test ListView)',Demo)>0 then ShowFrame(TFrameListView_TestListView);

    if Pos('(FixColCount NotFit)',Demo)>0 then ShowFrame(TFrameListView_FixColCountNotFit);
    if Pos('(FixColCount Fit)',Demo)>0 then ShowFrame(TFrameListView_FixColCountFit);
    if Pos('(AutoColCount NotFit)',Demo)>0 then ShowFrame(TFrameListView_AutoColCountNotFit);
    if Pos('(AutoColCount Fit)',Demo)>0 then ShowFrame(TFrameListView_AutoColCountFit);

    if Pos('(HorzMode FixColCount NotFit)',Demo)>0 then ShowFrame(TFrameListView_HorzFixColCountNotFit);
    if Pos('(HorzMode FixColCount Fit)',Demo)>0 then ShowFrame(TFrameListView_HorzFixColCountFit);
    if Pos('(HorzMode AutoColCount NotFit)',Demo)>0 then ShowFrame(TFrameListView_HorzAutoColCountNotFit);
    if Pos('(HorzMode AutoColCount Fit)',Demo)>0 then ShowFrame(TFrameListView_HorzAutoColCountFit);
  end;

  if Classify='TreeView' then
  begin
    if Pos('(Common)',Demo)>0 then ShowFrame(TFrameTreeView_Common);
    if Pos('(Black Style)',Demo)>0 then ShowFrame(TFrameTreeView_BlackStyle);
  end;

  if Classify='ItemGrid' then
  begin
    if Pos('(Simple)',Demo)>0 then ShowFrame(TFrameItemGrid_Simple);
    if Pos('(IndicatorColumn)',Demo)>0 then ShowFrame(TFrameItemGrid_IndicatorCol);
    if Pos('(FixedColumn)',Demo)>0 then ShowFrame(TFrameItemGrid_FixedCol);
    if Pos('(Footer)',Demo)>0 then ShowFrame(TFrameItemGrid_Footer);
    if Pos('(ItemDesignerPanel)',Demo)>0 then ShowFrame(TFrameItemGrid_UseItemDesignerPanel);
    if Pos('(WhiteBackColor)',Demo)>0 then ShowFrame(TFrameItemGrid_WhiteBackColor);
    if Pos('(CustomRowColor)',Demo)>0 then ShowFrame(TFrameItemGrid_CustomRowColor);
//    if Pos('(SetRowColorAtDesignTime)',Demo)>0 then ShowFrame(TFrameItemGrid_SetRowColorAtDesignTime);
    if Pos('(GridDevideLine)',Demo)>0 then ShowFrame(TFrameItemGrid_GridDevideLine);
  end;

  {$ENDIF}

end;

procedure TFrameDemoView.ShowFrame(FrameClass: TFrameClass);
begin
  if FDemoFrame<>nil then
  begin
    FDemoFrame.Visible:=False;
    FreeAndNil(FDemoFrame);
  end;


//  FDemoFrame:=FrameClass.Create(frmMain);
//  SetFrameName(FDemoFrame);
//  FDemoFrame.Parent:=pnlClient;
//  FDemoFrame.Align:=TAlignLayout.alClient;
  uUIFunction.ShowFrame(FDemoFrame,FrameClass,pnlClient,nil,nil,nil,frmMain,False,True,ufsefNone);

end;

end.

