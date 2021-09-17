//convert pas to utf8 by ¥
unit Basic_Filter_ListBoxFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.StdCtrls,FMX.Controls,  FMX.Forms,


  DateUtils,
  uDrawCanvas,
  uFuncCommon,

  uBaseList,
  uSkinItems,
  uSkinListBoxType,

  uUIFunction,
  uTimerTask,

  HzSpell,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeySwitchBar,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyPullLoadPanel, FMX.Controls.Presentation,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyButton, uDrawPicture,
  uSkinImageList, uSkinFireMonkeyListView, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinPanelType;

type
  TFrameBasic_Filter_ListBox = class(TFrame)
    pnlSearchBar: TSkinFMXPanel;
    edtFilter: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
    lvGoodsList: TSkinFMXListBox;
    ItemGoods: TSkinFMXItemDesignerPanel;
    imgItemGoodsPic: TSkinFMXImage;
    ItemGoodsCaption: TSkinFMXLabel;
    lblItemGoodsPrice: TSkinFMXMultiColorLabel;
    procedure edtFilterChange(Sender: TObject);
    procedure edtFilterChangeTracking(Sender: TObject);
    procedure edtFilterKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure DoFilter;
    { Public declarations }
  end;



implementation



{$R *.fmx}

{ TFrameListBox_FilterItems }

procedure TFrameBasic_Filter_ListBox.DoFilter;
var
  I: Integer;
  AFilter:String;
  AListBoxItem:TSkinListBoxItem;
begin
  AFilter:=Trim(Self.edtFilter.Text);

  //过滤
  Self.lvGoodsList.Properties.Items.BeginUpdate;
  try

    for I := 0 to Self.lvGoodsList.Properties.Items.Count-1 do
    begin
      //名称过滤
      Self.lvGoodsList.Properties.Items[I].Visible:=(
            //没有输入过滤关键字,则全部显示
            (AFilter='')
            //关键字符合过滤条件
        or (Pos(AFilter,Self.lvGoodsList.Properties.Items[I].Caption)>0)
            //关键字符合过滤条件-简拼
        or (Pos(LowerCase(AFilter),GetHzPy(Self.lvGoodsList.Properties.Items[I].Caption))>0)
        );
    end;

  finally
    Self.lvGoodsList.VertScrollBar.Prop.Position:=0;
    Self.lvGoodsList.Properties.Items.EndUpdate;
  end;
end;

procedure TFrameBasic_Filter_ListBox.edtFilterChange(Sender: TObject);
begin
  DoFilter;
end;

procedure TFrameBasic_Filter_ListBox.edtFilterChangeTracking(Sender: TObject);
begin
  DoFilter;
end;

procedure TFrameBasic_Filter_ListBox.edtFilterKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key=vkReturn then
  begin
    //搜索
    DoFilter;
  end;
end;

end.
