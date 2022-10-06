//convert pas to utf8 by ¥

unit ListBoxFrame_SpeedCompare;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types,
//  {$IF CompilerVersion >= 30.0}
//  FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
//  {$ENDIF}
  FMX.ListView, uSkinFireMonkeyButton, uSkinFireMonkeyPanel,
  DateUtils,

  uLang,
  uFrameContext,

  uSkinListBoxType,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, FMX.TabControl,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, uDrawPicture,
  uSkinImageList, uSkinFireMonkeyCustomList, uSkinButtonType, uSkinPanelType,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uDrawCanvas, uSkinItems;

type
  TFrameListBox_SpeedCompare = class(TFrame,IFrameChangeLanguageEvent)
    tcTestListBoxSpeed: TTabControl;
    tabTSkinFMXListView: TTabItem;
    lbProductList: TSkinFMXListBox;
    ListItemDefault: TSkinFMXItemDesignerPanel;
    imgListItemDefaultIcon: TSkinFMXImage;
    lblListItemDefaultCaption: TSkinFMXLabel;
    lblListItemDefaultPrice: TSkinFMXLabel;
    lblListItemDefaultDetail1: TSkinFMXLabel;
    lblListItemDefaultDetail2: TSkinFMXLabel;
    pnlListItemDefaultDevide: TSkinFMXPanel;
    lblListItemDefaultDetail3: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    tabTListView: TTabItem;
    ListView1: TListView;
    SkinFMXPanel1: TSkinFMXPanel;
    btnLoad2WTListViewItem: TSkinFMXButton;
    btnLoad2WTSkinListBoxItem: TSkinFMXButton;
    imglistIcon: TSkinImageList;
    procedure btnLoad2WTSkinListBoxItemClick(Sender: TObject);
    procedure btnLoad2WTListViewItemClick(Sender: TObject);
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameListBox_SpeedCompare.btnLoad2WTListViewItemClick(Sender: TObject);
var
  I: Integer;
  AListViewItem:TListViewItem;
  ANow:TDateTime;
begin
  ANow:=Now;


  Self.ListView1.BeginUpdate;
  for I := 0 to 20000 do
  begin
      AListViewItem:=Self.ListView1.Items.Add;

      if LangKind=lkZH then
      begin
        AListViewItem.Text:=IntToStr(I)+' '+'2015新款李字智能跑鞋';
        AListViewItem.Detail:='月销2.4万笔 李宁官方网店';
      end
      else if LangKind=lkEN then
      begin
        AListViewItem.Text:=IntToStr(I)+' '+'2015 new words Lee smart shoes';
        AListViewItem.Detail:='monthly sales of 24,000';
//        AListViewItem.Accessory
      end;

      AListViewItem.BitmapRef:=imglistIcon.PictureList[0];
  end;
  Self.ListView1.EndUpdate;

  if LangKind=lkZH then
  begin
    ShowMessage('加载结束,用耗时'+FloatToStr(DateUtils.MilliSecondsBetween(ANow,Now)/1000)+'秒');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('Load end,take '+FloatToStr(DateUtils.MilliSecondsBetween(ANow,Now)/1000)+' seconds');
  end;

end;

procedure TFrameListBox_SpeedCompare.btnLoad2WTSkinListBoxItemClick(Sender: TObject);
var
  I: Integer;
  ANow:TDateTime;
  AItem:TSkinListBoxItem;
begin

  ANow:=Now;
  Self.lbProductList.Prop.Items.BeginUpdate;
  try
    for I := 0 to 20000 do
    begin
        AItem:=Self.lbProductList.Prop.Items.Add;

        if LangKind=lkZH then
        begin
          AItem.Caption:=IntToStr(I)+' '+'2015新款李字智能跑鞋';
          AItem.Detail:='¥199';
          AItem.Detail1:='商场同款';
          AItem.Detail2:='免运费';
          AItem.Detail3:='月销2.4万笔 李宁官方网店';
        end
        else if LangKind=lkEN then
        begin
          AItem.Caption:=IntToStr(I)+' '+'2015 new words Lee smart shoes';
          AItem.Detail:='¥199';
          AItem.Detail1:='mall same';
          AItem.Detail2:='free freight';
          AItem.Detail3:='monthly sales of 24,000';
        end;

        AItem.Icon.RefPicture:=imglistIcon.PictureList[0];

    end;
  finally
    Self.lbProductList.Prop.Items.EndUpdate();
  end;

  if LangKind=lkZH then
  begin
    ShowMessage('加载结束,用耗时'+FloatToStr(DateUtils.MilliSecondsBetween(ANow,Now)/1000)+'秒');
  end
  else if LangKind=lkEN then
  begin
    ShowMessage('Load end,take '+FloatToStr(DateUtils.MilliSecondsBetween(ANow,Now)/1000)+' seconds');
  end;

end;

procedure TFrameListBox_SpeedCompare.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnLoad2WTSkinListBoxItem.Text:=GetLangString(Self.btnLoad2WTSkinListBoxItem.Name,ALangKind);

  Self.btnLoad2WTListViewItem.Text:=GetLangString(Self.btnLoad2WTListViewItem.Name,ALangKind);
end;

constructor TFrameListBox_SpeedCompare.Create(AOwner: TComponent);
begin
  inherited;

  if LangKind=lkEN then
  begin
    Self.lbProductList.Prop.Items.Clear(True);
  end;

  //初始多语言
  RegLangString(Self.btnLoad2WTSkinListBoxItem.Name,[Self.btnLoad2WTSkinListBoxItem.Text,'TSKinFMXListView load 2w items']);


  RegLangString(Self.btnLoad2WTListViewItem.Name,[Self.btnLoad2WTListViewItem.Text,'TListView load 2w items']);

end;

end.
