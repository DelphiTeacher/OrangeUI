//convert pas to utf8 by ¥

unit ListViewFrame_Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uSkinItems,
  uUIFunction,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uSkinFireMonkeyCustomList, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uDrawCanvas;

type
  TFrameListView_Main = class(TFrame,IFrameChangeLanguageEvent)
    lbDemos: TSkinFMXListBox;
    procedure lbDemosClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    FDemoViewFrame:TFrame;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  MainForm,
  DemoViewFrame;

procedure TFrameListView_Main.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use SelfOwnMaterial)').Caption:=GetLangString('(Use SelfOwnMaterial)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(9BoxMenu by SelfOwnMaterial)').Caption:=GetLangString('(9BoxMenu by SelfOwnMaterial)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(9BoxMenu by ItemDesignerPanel)').Caption:=GetLangString('(9BoxMenu by ItemDesignerPanel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Horz mode)').Caption:=GetLangString('(Horz mode)',ALangKind);

  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test Waterfall mode 1)').Caption:=GetLangString('(Test Waterfall mode 1)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test Waterfall mode 2)').Caption:=GetLangString('(Test Waterfall mode 2)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test ListView)').Caption:=GetLangString('(Test ListView)',ALangKind);

  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(FixColCount NotFit)').Caption:=GetLangString('(FixColCount NotFit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(FixColCount Fit)').Caption:=GetLangString('(FixColCount Fit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AutoColCount NotFit)').Caption:=GetLangString('(AutoColCount NotFit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AutoColCount Fit)').Caption:=GetLangString('(AutoColCount Fit)',ALangKind);

  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode FixColCount NotFit)').Caption:=GetLangString('(HorzMode FixColCount NotFit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode FixColCount Fit)').Caption:=GetLangString('(HorzMode FixColCount Fit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode AutoColCount NotFit)').Caption:=GetLangString('(HorzMode AutoColCount NotFit)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode AutoColCount Fit)').Caption:=GetLangString('(HorzMode AutoColCount Fit)',ALangKind);

end;

constructor TFrameListView_Main.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString('(Use SelfOwnMaterial)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use SelfOwnMaterial)').Caption,'(Use SelfOwnMaterial)']);
  RegLangString('(9BoxMenu by SelfOwnMaterial)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(9BoxMenu by SelfOwnMaterial)').Caption,'(9BoxMenu by SelfOwnMaterial)']);
  RegLangString('(9BoxMenu by ItemDesignerPanel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(9BoxMenu by ItemDesignerPanel)').Caption,'(9BoxMenu by ItemDesignerPanel)']);
  RegLangString('(Horz mode)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Horz mode)').Caption,'(Horz mode)']);

  RegLangString('(Test Waterfall mode 1)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test Waterfall mode 1)').Caption,'(Test Waterfall mode 1)']);
  RegLangString('(Test Waterfall mode 2)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test Waterfall mode 2)').Caption,'(Test Waterfall mode 2)']);
  RegLangString('(Test ListView)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test ListView)').Caption,'(Test ListView)']);


  RegLangString('(FixColCount NotFit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(FixColCount NotFit)').Caption,'(FixColCount NotFit)']);
  RegLangString('(FixColCount Fit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(FixColCount Fit)').Caption,'(FixColCount Fit)']);
  RegLangString('(AutoColCount NotFit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AutoColCount NotFit)').Caption,'(AutoColCount NotFit)']);
  RegLangString('(AutoColCount Fit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(AutoColCount Fit)').Caption,'(AutoColCount Fit)']);


  RegLangString('(HorzMode FixColCount NotFit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode FixColCount NotFit)').Caption,'(HorzMode FixColCount NotFit)']);
  RegLangString('(HorzMode FixColCount Fit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode FixColCount Fit)').Caption,'(HorzMode FixColCount Fit)']);
  RegLangString('(HorzMode AutoColCount NotFit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode AutoColCount NotFit)').Caption,'(HorzMode AutoColCount NotFit)']);
  RegLangString('(HorzMode AutoColCount Fit)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(HorzMode AutoColCount Fit)').Caption,'(HorzMode AutoColCount Fit)']);

end;

procedure TFrameListView_Main.lbDemosClickItem(Sender: TSkinItem);
begin
  if Sender.Caption='' then Exit;
  if Sender.ItemType<>sitDefault then Exit;

  HideFrame;////(TFrame(Self.Parent.Parent),hfcttBeforeShowFrame);
  //测试3:有切换效果
  ShowFrame(TFrame(FDemoViewFrame),TFrameDemoView,frmMain,nil,nil,nil,frmMain,True,True,ufsefDefault);
//  TFrameDemoView(FDemoViewFrame).FrameHistroy:=CurrentFrameHistroy;
  TFrameDemoView(FDemoViewFrame).ShowDemo(Sender.Caption,'ListView');

end;

end.
