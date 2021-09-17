//convert pas to utf8 by ¥
unit SearchHistoryFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uManager,
  uSkinItems,
  uUIFunction,
  uSkinListViewType,
  EasyServiceCommonMaterialDataMoudle,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameSearchHistory = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    edtSearch: TSkinFMXEdit;
    btnReturn: TSkinFMXButton;
    lvSearchHistory: TSkinFMXListView;
    ItemDefault: TSkinFMXItemDesignerPanel;
    ItemHeader: TSkinFMXItemDesignerPanel;
    lblItemHeaderCaption: TSkinFMXLabel;
    lblItemDefaultCaption: TSkinFMXLabel;
    ItemFooter: TSkinFMXItemDesignerPanel;
    btnClearHistory: TSkinFMXButton;
    btnSearch: TSkinFMXButton;
    procedure btnClearHistoryClick(Sender: TObject);
    procedure lvSearchHistoryClickItem(AItem: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    FSearchType:String;
    FSearchHistoryList:TStringList;

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load(ACaption:String;
                    ASearchType:String;
                    ASearchHistoryList:TStringList);
    { Public declarations }
  end;


var
  GlobalSearchHistoryFrame:TFrameSearchHistory;

implementation

uses
  MainForm,
  BuyGoodsListFrame
//  ,
//  UserListFrame
  ;

{$R *.fmx}

procedure TFrameSearchHistory.btnClearHistoryClick(Sender: TObject);
begin
  //清空历史记录
  FSearchHistoryList.Clear;
  GlobalManager.Save;
  Load(Self.edtSearch.Prop.HelpText,
        FSearchType,
        FSearchHistoryList);
end;

procedure TFrameSearchHistory.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameSearchHistory.btnSearchClick(Sender: TObject);
begin
  HideVirtualKeyboard;


  if FSearchType='BuyGoodsAtHomeFrame' then
  begin
    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);
    //补货
    ShowFrame(TFrame(GlobalBuyGoodsListFrame),TFrameBuyGoodsList,frmMain,nil,nil,nil,Application);
//    GlobalBuyGoodsListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalBuyGoodsListFrame.Load(Self.edtSearch.Text,True);
  end;

  if FSearchType='BuyGoods' then
  begin
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

  if FSearchType='Goods' then
  begin
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

  if FSearchType='User' then
  begin
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

  if FSearchType='Hotel' then
  begin
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;


  if (Trim(Self.edtSearch.Text)<>'')
    and (FSearchHistoryList.IndexOf(Self.edtSearch.Text)=-1) then
  begin
    //添加到搜索历史
    FSearchHistoryList.Insert(0,Self.edtSearch.Text);
    //保存
    GlobalManager.SaveUserConfig;
    Load(Self.edtSearch.Prop.HelpText,
          FSearchType,
          FSearchHistoryList);
  end;

end;

procedure TFrameSearchHistory.Load(ACaption:String;
                                  ASearchType:String;
                                  ASearchHistoryList:TStringList);
var
  I: Integer;
  AListViewItem:TSkinListViewItem;
begin
  Self.edtSearch.Prop.HelpText:=ACaption;
  FSearchType:=ASearchType;
  FSearchHistoryList:=ASearchHistoryList;


  Self.edtSearch.Text:='';

  Self.lvSearchHistory.Prop.Items.BeginUpdate;
  try
    Self.lvSearchHistory.Prop.Items.ClearItemsByType(sitDefault);

    for I := 0 to FSearchHistoryList.Count-1 do
    begin

      AListViewItem:=Self.lvSearchHistory.Prop.Items.Insert(I+1);
      AListViewItem.Caption:=FSearchHistoryList[I];

    end;

    Self.lvSearchHistory.Prop.Items.FindItemByType(sitItem1).Visible:=
      FSearchHistoryList.Count=0;

    Self.lvSearchHistory.Prop.Items.FindItemByType(sitFooter).Visible:=
      FSearchHistoryList.Count>0;

  finally
    Self.lvSearchHistory.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameSearchHistory.lvSearchHistoryClickItem(
  AItem: TSkinItem);
begin
  if AItem.ItemType=sitDefault then
  begin
    Self.edtSearch.Text:=AItem.Caption;
    btnSearchClick(Self);


  end;
end;


end.

