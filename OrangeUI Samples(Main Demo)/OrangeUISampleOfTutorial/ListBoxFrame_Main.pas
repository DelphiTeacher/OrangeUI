//convert pas to utf8 by ¥

unit ListBoxFrame_Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uVersion,
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
  TFrameListBox_Main = class(TFrame,IFrameChangeLanguageEvent)
    lbDemos: TSkinFMXListBox;
    procedure lbDemosClickItem(Sender: TSkinItem);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  private
    { Private declarations }
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

procedure TFrameListBox_Main.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Add Item By Code)').Caption:=GetLangString('(Add Item By Code)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test Speed Of Batch Add)').Caption:=GetLangString('(Test Speed Of Batch Add)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use SelfOwnMaterial)').Caption:=GetLangString('(Use SelfOwnMaterial)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use ItemDesignerPanel)').Caption:=GetLangString('(Use ItemDesignerPanel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Dynamic Binding)').Caption:=GetLangString('(Dynamic Binding)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Edit Item By ComboBox)').Caption:=GetLangString('(Edit Item By ComboBox)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Edit Item By EditBox)').Caption:=GetLangString('(Edit Item By EditBox)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PanDrag Item)').Caption:=GetLangString('(PanDrag Item)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Horz Mode)').Caption:=GetLangString('(Horz Mode)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Center-Select Mode)').Caption:=GetLangString('(Center-Select Mode)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Download Icon Auto)').Caption:=GetLangString('(Download Icon Auto)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test MouseEvent)').Caption:=GetLangString('(Test MouseEvent)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Sort)').Caption:=GetLangString('(Sort)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Filter)').Caption:=GetLangString('(Filter)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Bind Multi Images 1)').Caption:=GetLangString('(Bind Multi Images 1)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Bind Multi Images 2)').Caption:=GetLangString('(Bind Multi Images 2)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use Multi ItemDesignerPanel)').Caption:=GetLangString('(Use Multi ItemDesignerPanel)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PullDownRefresh Auto)').Caption:=GetLangString('(PullDownRefresh Auto)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use ItemAnimate)').Caption:=GetLangString('(Use ItemAnimate)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(GetSkinItemDataIntf)').Caption:=GetLangString('(GetSkinItemDataIntf)',ALangKind);

end;

constructor TFrameListBox_Main.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString('(Add Item By Code)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Add Item By Code)').Caption,'(Add Item By Code)']);
  RegLangString('(Test Speed Of Batch Add)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test Speed Of Batch Add)').Caption,'(Test Speed Of Batch Add)']);
  RegLangString('(Use SelfOwnMaterial)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use SelfOwnMaterial)').Caption,'(Use SelfOwnMaterial)']);
  RegLangString('(Use ItemDesignerPanel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use ItemDesignerPanel)').Caption,'(Use ItemDesignerPanel)']);
  RegLangString('(Dynamic Binding)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Dynamic Binding)').Caption,'(Dynamic Binding)']);
  RegLangString('(Edit Item By ComboBox)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Edit Item By ComboBox)').Caption,'(Edit Item By ComboBox)']);
  RegLangString('(Edit Item By EditBox)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Edit Item By EditBox)').Caption,'(Edit Item By EditBox)']);
  RegLangString('(PanDrag Item)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PanDrag Item)').Caption,'(PanDrag Item)']);
  RegLangString('(Center-Select Mode)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Center-Select Mode)').Caption,'(Center-Select Mode)']);
  RegLangString('(Horz Mode)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Horz Mode)').Caption,'(Horz Mode)']);
  RegLangString('(Download Icon Auto)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Download Icon Auto)').Caption,'(Download Icon Auto)']);
  RegLangString('(Test MouseEvent)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Test MouseEvent)').Caption,'(Test MouseEvent)']);
  RegLangString('(Sort)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Sort)').Caption,'(Sort)']);
  RegLangString('(Filter)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Filter)').Caption,'(Filter)']);
  RegLangString('(Bind Multi Images 1)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Bind Multi Images 1)').Caption,'(Bind Multi Images 1)']);
  RegLangString('(Bind Multi Images 2)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Bind Multi Images 2)').Caption,'(Bind Multi Images 2)']);
  RegLangString('(Use Multi ItemDesignerPanel)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use Multi ItemDesignerPanel)').Caption,'(Use Multi ItemDesignerPanel)']);
  RegLangString('(PullDownRefresh Auto)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(PullDownRefresh Auto)').Caption,'(PullDownRefresh Auto)']);
  RegLangString('(Use ItemAnimate)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Use ItemAnimate)').Caption,'(Use ItemAnimate)']);
  RegLangString('(GetSkinItemDataIntf)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(GetSkinItemDataIntf)').Caption,'(GetSkinItemDataIntf)']);


end;

procedure TFrameListBox_Main.lbDemosClickItem(Sender: TSkinItem);
begin
  if Sender.Caption='' then Exit;
  if Sender.ItemType<>sitDefault then Exit;

  HideFrame;////(TFrame(Self.Parent.Parent),hfcttBeforeShowFrame);
  //测试3:有切换效果
  ShowFrame(TFrame(FDemoViewFrame),TFrameDemoView,frmMain,nil,nil,nil,frmMain,True,True,ufsefDefault);
//  TFrameDemoView(FDemoViewFrame).FrameHistroy:=CurrentFrameHistroy;
  TFrameDemoView(FDemoViewFrame).ShowDemo(Sender.Caption,'ListBox');

end;

end.
