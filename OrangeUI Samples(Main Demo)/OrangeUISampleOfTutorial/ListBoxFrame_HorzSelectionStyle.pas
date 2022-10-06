//convert pas to utf8 by ¥

unit ListBoxFrame_HorzSelectionStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.StdCtrls,FMX.Controls,  FMX.Forms,


  DateUtils,


  uDrawCanvas,
  uFuncCommon,
  uLang,
  uFrameContext,
  uBaseList,
  uSkinItems,
  uSkinListBoxType,

  uUIFunction,
  uTimerTask,

  HzSpell,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeySwitchBar,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyPullLoadPanel, FMX.Controls.Presentation,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyButton, uDrawPicture,
  uSkinImageList, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyCustomList, uSkinMultiColorLabelType, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uBaseSkinControl, uSkinPanelType;

type
  TFrameListBox_HorzSelectionStyle = class(TFrame,IFrameChangeLanguageEvent)
    SkinFMXListBox1: TSkinFMXListBox;
    SkinFMXListBox2: TSkinFMXListBox;
    SkinFMXListBox3: TSkinFMXListBox;
    SkinFMXListBox4: TSkinFMXListBox;
    procedure edtFilterChange(Sender: TObject);
    procedure edtFilterChangeTracking(Sender: TObject);
    procedure edtFilterKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    procedure DoFilter;
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation



{$R *.fmx}

{ TFrameListBox_HorzSelectionStyle }

procedure TFrameListBox_HorzSelectionStyle.ChangeLanguage(ALangKind: TLangKind);
begin
//  //翻译
//  Self.edtFilter.Prop.HelpText:=GetLangString(Self.edtFilter.Name+'HelpText',ALangKind);
//
//  Self.lvGoodsList.Prop.Items[0].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 0',ALangKind);
//  Self.lvGoodsList.Prop.Items[1].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 1',ALangKind);
//  Self.lvGoodsList.Prop.Items[2].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 2',ALangKind);
//  Self.lvGoodsList.Prop.Items[3].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 3',ALangKind);
//  Self.lvGoodsList.Prop.Items[4].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 4',ALangKind);
//  Self.lvGoodsList.Prop.Items[5].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 5',ALangKind);
//  Self.lvGoodsList.Prop.Items[6].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 6',ALangKind);
//  Self.lvGoodsList.Prop.Items[7].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 7',ALangKind);
//  Self.lvGoodsList.Prop.Items[8].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 8',ALangKind);
//  Self.lvGoodsList.Prop.Items[9].Caption:=GetLangString(Self.lvGoodsList.Name+'Caption 9',ALangKind);
//
//  Self.lvGoodsList.Prop.Items[0].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 0',ALangKind);
//  Self.lvGoodsList.Prop.Items[1].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 1',ALangKind);
//  Self.lvGoodsList.Prop.Items[2].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 2',ALangKind);
//  Self.lvGoodsList.Prop.Items[3].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 3',ALangKind);
//  Self.lvGoodsList.Prop.Items[4].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 4',ALangKind);
//  Self.lvGoodsList.Prop.Items[5].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 5',ALangKind);
//  Self.lvGoodsList.Prop.Items[6].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 6',ALangKind);
//  Self.lvGoodsList.Prop.Items[7].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 7',ALangKind);
//  Self.lvGoodsList.Prop.Items[8].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 8',ALangKind);
//  Self.lvGoodsList.Prop.Items[9].Detail2:=GetLangString(Self.lvGoodsList.Name+'Detail2 9',ALangKind);

end;

constructor TFrameListBox_HorzSelectionStyle.Create(AOwner: TComponent);
begin
  inherited;

//  //初始多语言
//  RegLangString(Self.edtFilter.Name+'HelpText',[Self.edtFilter.Prop.HelpText,'Input filter char']);
//
//  RegLangString(Self.lvGoodsList.Name+'Caption 0',[Self.lvGoodsList.Prop.Items[0].Caption,'Cabernet Sauvignon silver label']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 1',[Self.lvGoodsList.Prop.Items[1].Caption,'Anxi Tieguanyin Tea']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 2',[Self.lvGoodsList.Prop.Items[2].Caption,'Pumpkin seed']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 3',[Self.lvGoodsList.Prop.Items[3].Caption,'Bacardi white']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 4',[Self.lvGoodsList.Prop.Items[4].Caption,'Budweiser ice beer']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 5',[Self.lvGoodsList.Prop.Items[5].Caption,'Bean']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 6',[Self.lvGoodsList.Prop.Items[6].Caption,'Fanta']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 7',[Self.lvGoodsList.Prop.Items[7].Caption,'The Spring Snail']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 8',[Self.lvGoodsList.Prop.Items[8].Caption,'Bud Genuine Draft']);
//  RegLangString(Self.lvGoodsList.Name+'Caption 9',[Self.lvGoodsList.Prop.Items[9].Caption,'Hongta mountain classic 100']);
//
//  RegLangString(Self.lvGoodsList.Name+'Detail2 0',[Self.lvGoodsList.Prop.Items[0].Detail2,'bottle']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 1',[Self.lvGoodsList.Prop.Items[1].Detail2,'cup']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 2',[Self.lvGoodsList.Prop.Items[2].Detail2,'disc']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 3',[Self.lvGoodsList.Prop.Items[3].Detail2,'bottle']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 4',[Self.lvGoodsList.Prop.Items[4].Detail2,'pack']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 5',[Self.lvGoodsList.Prop.Items[5].Detail2,'disc']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 6',[Self.lvGoodsList.Prop.Items[6].Detail2,'tank']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 7',[Self.lvGoodsList.Prop.Items[7].Detail2,'cup']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 8',[Self.lvGoodsList.Prop.Items[8].Detail2,'bottle']);
//  RegLangString(Self.lvGoodsList.Name+'Detail2 9',[Self.lvGoodsList.Prop.Items[9].Detail2,'carton']);

end;

procedure TFrameListBox_HorzSelectionStyle.DoFilter;
//var
//  I: Integer;
//  AFilter:String;
//  AListBoxItem:TSkinListBoxItem;
begin
//  AFilter:=Trim(Self.edtFilter.Text);
//
//  //过滤
//  Self.lvGoodsList.Properties.Items.BeginUpdate;
//  try
//
//    for I := 0 to Self.lvGoodsList.Properties.Items.Count-1 do
//    begin
//      //名称过滤
//      Self.lvGoodsList.Properties.Items[I].Visible:=(
//            //没有输入过滤关键字,则全部显示
//            (AFilter='')
//            //关键字符合过滤条件
//        or (Pos(LowerCase(AFilter),LowerCase(Self.lvGoodsList.Properties.Items[I].Caption))>0)
//            //关键字符合过滤条件-简拼
//        or (Pos(LowerCase(AFilter),GetHzPy(Self.lvGoodsList.Properties.Items[I].Caption))>0)
//        );
//    end;
//
//  finally
//    Self.lvGoodsList.VertScrollBar.Prop.Position:=0;
//    Self.lvGoodsList.Properties.Items.EndUpdate;
//  end;
end;

procedure TFrameListBox_HorzSelectionStyle.edtFilterChange(Sender: TObject);
begin
  DoFilter;
end;

procedure TFrameListBox_HorzSelectionStyle.edtFilterChangeTracking(Sender: TObject);
begin
  DoFilter;
end;

procedure TFrameListBox_HorzSelectionStyle.edtFilterKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key=vkReturn then
  begin
    //搜索
    DoFilter;
  end;
end;

end.
