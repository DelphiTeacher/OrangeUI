//convert pas to utf8 by ¥

unit TreeViewFrame_Main;

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
  TFrameTreeView_Main = class(TFrame,IFrameChangeLanguageEvent)
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

procedure TFrameTreeView_Main.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Common)').Caption:=GetLangString('(Common)',ALangKind);
  Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Black Style)').Caption:=GetLangString('(Black Style)',ALangKind);

end;

constructor TFrameTreeView_Main.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString('(Common)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Common)').Caption,'(Common)']);
  RegLangString('(Black Style)',
    [Self.lbDemos.Prop.Items.FindItemByCaptionContains('(Black Style)').Caption,'(Black Style)']);

end;

procedure TFrameTreeView_Main.lbDemosClickItem(Sender: TSkinItem);
begin
  if Sender.Caption='' then Exit;
  if Sender.ItemType<>sitDefault then Exit;

  HideFrame;//(TFrame(Self.Parent.Parent),hfcttBeforeShowFrame);
  //测试3:有切换效果
  ShowFrame(TFrame(FDemoViewFrame),TFrameDemoView,frmMain,nil,nil,nil,frmMain,True,True,ufsefDefault);
//  TFrameDemoView(FDemoViewFrame).FrameHistroy:=CurrentFrameHistroy;
  TFrameDemoView(FDemoViewFrame).ShowDemo(TSkinItem(Sender).Caption,'TreeView');




end;

end.
