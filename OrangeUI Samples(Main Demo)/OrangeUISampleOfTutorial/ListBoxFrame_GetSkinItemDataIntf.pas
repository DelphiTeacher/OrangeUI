//convert pas to utf8 by ¥

unit ListBoxFrame_GetSkinItemDataIntf;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.StdCtrls,FMX.Controls,  FMX.Forms,


  DateUtils,

  uDrawCanvas,
  uFrameContext,
  uFuncCommon,
  uLang,
  uBaseList,
  uSkinItems,
  uSkinListBoxType,
  uUIFunction,
  uTimerTask,
  uDrawPicture,
  uSkinPicture,
  uGraphicCommon,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeySwitchBar,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyPullLoadPanel, FMX.Controls.Presentation,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyButton,
  uSkinFireMonkeyCustomList, uSkinButtonType, uSkinPanelType,
  uSkinMultiColorLabelType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType;

type
  //旅游景点
  TFeatureSpot=class(TInterfacedObject,IGetSkinItemData)
    //景点名称
    Name:String;
    //地址
    Addr:String;
    //建议价
    SuggestPrice:Double;
    //成本价
    Cost:Double;
//    //图标
//    Icon:TDrawPicture;
//
//    Item:TSkinItem;
//    procedure DoIconChange(Sender:TObject);
  public
    constructor Create;
    destructor Destroy;override;
  protected
    //IGetSkinItemData实现
    function GetItemCaption: String;
    function GetItemDetail: String;
    function GetItemDetail1: String;
    function GetItemDetail2: String;
    function GetItemDetail3: String;
    function GetItemDetail4: String;
    function GetItemDetail5: String;
    function GetItemDetail6: String;

    function GetItemSubItems: TStringList;


    function GetItemAccessory: TSkinAccessoryType;

//    function GetItemColor: TDelphiColor;
//    function GetItemIcon: TBaseDrawPicture;
//    function GetItemPic: TBaseDrawPicture;
//    function GetItemIconRefPicture: TSkinPicture;
//    function GetItemPicRefPicture: TSkinPicture;
//
//    function GetItemIconImageIndex: Integer;
//    function GetItemPicImageIndex: Integer;

  end;


  TFrameListBox_GetSkinItemDataIntf = class(TFrame,IFrameChangeLanguageEvent)
    lbTicketProductList: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail2: TSkinFMXMultiColorLabel;
    lblItemDetail1: TSkinFMXMultiColorLabel;
    lblItemSuggestedPrice: TSkinFMXLabel;
    lblItemCostPrice: TSkinFMXLabel;
    imgShareBarCode: TSkinFMXImage;
    pnlToolBarInner: TSkinFMXPanel;
    btnAddItem: TSkinFMXButton;
    btnClearItem: TSkinFMXButton;
    btnDelItem: TSkinFMXButton;
    procedure btnAddItemClick(Sender: TObject);
    procedure btnClearItemClick(Sender: TObject);
    procedure btnDelItemClick(Sender: TObject);
    procedure pnlToolBarInnerResize(Sender: TObject);
  private
    FFeatureSpotList:TBaseList;
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;



implementation



{$R *.fmx}

procedure TFrameListBox_GetSkinItemDataIntf.btnAddItemClick(Sender: TObject);
var
  I: Integer;
  AFeatureSpot:TFeatureSpot;
  AListBoxItem:TIntfSkinItem;
begin
  //准备批量添加
  Self.lbTicketProductList.Prop.Items.BeginUpdate;
  try
    //先清空所有Item
    Self.lbTicketProductList.Prop.Items.Clear(True);
    Self.FFeatureSpotList.Clear(False);

    for I := 0 to 20-1 do
    begin
        //添加Item
        Self.lbTicketProductList.Prop.Items.SkinItemClass:=TIntfSkinItem;
        AListBoxItem:=TIntfSkinItem(Self.lbTicketProductList.Prop.Items.Add);

        AFeatureSpot:=TFeatureSpot.Create;

        if LangKind=lkZH then
        begin
          AFeatureSpot.Name:=IntToStr(I)+' '+'南靖土楼云水谣';
          AFeatureSpot.Addr:='南靖土楼小区12栋';
        end
        else if LangKind=lkEN then
        begin
          AFeatureSpot.Name:=IntToStr(I)+' '+'Places of historic interest';
          AFeatureSpot.Addr:='address of places of historic interest';
        end;


        AFeatureSpot.SuggestPrice:=109;
        AFeatureSpot.Cost:=100;

        //如果有图片的网址,那么可以直接指定Icon的Url
        if I mod 2 = 0 then
        begin
          AListBoxItem.Icon.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/TicketProduct1.png';
        end
        else
        begin
          AListBoxItem.Icon.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/TicketProduct2.png';
        end;

        AListBoxItem.FGetSkinItemDataIntf:=AFeatureSpot;
        //用于刷新
//        AFeatureSpot.Item:=AListBoxItem;
//        AListBoxItem.Icon.OnChange:=AListBoxItem.DoIconChange;
        Self.FFeatureSpotList.Add(AFeatureSpot);

    end;

  finally
    Self.lbTicketProductList.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameListBox_GetSkinItemDataIntf.btnClearItemClick(Sender: TObject);
begin
  //准备批量删除
  Self.lbTicketProductList.Prop.Items.BeginUpdate;
  try
    //清空所有Item
    Self.lbTicketProductList.Prop.Items.Clear(True);
    Self.FFeatureSpotList.Clear(False);
  finally
    Self.lbTicketProductList.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameListBox_GetSkinItemDataIntf.btnDelItemClick(Sender: TObject);
begin
  if Self.lbTicketProductList.Prop.Items.Count>0 then
  begin
      Self.lbTicketProductList.Prop.Items.Delete(0);
      //或使用Remove()
      //Self.lbTicketProductList.Prop.Items.Remove(AListBoxItem);
  end;
end;

procedure TFrameListBox_GetSkinItemDataIntf.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnAddItem.Text:=GetLangString(Self.btnAddItem.Name,ALangKind);
  Self.btnClearItem.Text:=GetLangString(Self.btnClearItem.Name,ALangKind);
  Self.btnDelItem.Text:=GetLangString(Self.btnDelItem.Name,ALangKind);

  Self.lblItemSuggestedPrice.Text:=GetLangString(Self.lblItemSuggestedPrice.Name,ALangKind);
  Self.lblItemCostPrice.Text:=GetLangString(Self.lblItemCostPrice.Name,ALangKind);
end;

constructor TFrameListBox_GetSkinItemDataIntf.Create(AOwner: TComponent);
begin
  inherited;

  FFeatureSpotList:=TBaseList.Create();


  if LangKind=lkEN then
  begin
    Self.lbTicketProductList.Prop.Items.Clear(True);
  end;

  //初始多语言
  RegLangString(Self.btnAddItem.Name,[Self.btnAddItem.Text,'Add']);
  RegLangString(Self.btnClearItem.Name,[Self.btnClearItem.Text,'Clear']);
  RegLangString(Self.btnDelItem.Name,[Self.btnDelItem.Text,'Delete']);

  RegLangString(Self.lblItemSuggestedPrice.Name,[Self.lblItemSuggestedPrice.Text,'price:']);
  RegLangString(Self.lblItemCostPrice.Name,[Self.lblItemCostPrice.Text,'cost:']);
end;

destructor TFrameListBox_GetSkinItemDataIntf.Destroy;
begin

  FFeatureSpotList.Clear(False);
  FreeAndNil(FFeatureSpotList);
  inherited;
end;

procedure TFrameListBox_GetSkinItemDataIntf.pnlToolBarInnerResize(Sender: TObject);
begin
  Self.btnAddItem.Width:=Self.pnlToolBarInner.Width/3;
  Self.btnClearItem.Width:=Self.pnlToolBarInner.Width/3;
  Self.btnDelItem.Width:=Self.pnlToolBarInner.Width/3;
end;

{ TFeatureSpot }

constructor TFeatureSpot.Create;
begin
//  Icon:=TDrawPicture.Create;
//  Icon.OnChange:=DoIconChange;
end;

destructor TFeatureSpot.Destroy;
begin
//  FreeAndNil(Icon);
  inherited;
end;

//procedure TFeatureSpot.DoIconChange(Sender: TObject);
//begin
//  if Item<>nil then
//  begin
//    Item.DoPropChange;
//  end;
//end;

function TFeatureSpot.GetItemAccessory: TSkinAccessoryType;
begin

end;

function TFeatureSpot.GetItemCaption: String;
begin
  Result:=Name;
end;

//function TFeatureSpot.GetItemColor: TDelphiColor;
//begin
//
//end;

function TFeatureSpot.GetItemDetail: String;
begin
  Result:=Addr;
end;

function TFeatureSpot.GetItemDetail1: String;
begin
  Result:=FloatToStr(Self.SuggestPrice);
end;

function TFeatureSpot.GetItemDetail2: String;
begin
  Result:=FloatToStr(Self.Cost);
end;

function TFeatureSpot.GetItemDetail3: String;
begin

end;

function TFeatureSpot.GetItemDetail4: String;
begin

end;

function TFeatureSpot.GetItemDetail5: String;
begin

end;

function TFeatureSpot.GetItemDetail6: String;
begin

end;

//function TFeatureSpot.GetItemIcon: TBaseDrawPicture;
//begin
//  Result:=Icon;
//end;
//
//function TFeatureSpot.GetItemIconImageIndex: Integer;
//begin
//  Result:=-1;
//end;
//
//function TFeatureSpot.GetItemIconRefPicture: TSkinPicture;
//begin
//  Result:=nil;
//end;
//
//function TFeatureSpot.GetItemPic: TBaseDrawPicture;
//begin
//  Result:=nil;
//end;
//
//function TFeatureSpot.GetItemPicImageIndex: Integer;
//begin
//  Result:=-1;
//end;
//
//function TFeatureSpot.GetItemPicRefPicture: TSkinPicture;
//begin
//  Result:=nil;
//end;

function TFeatureSpot.GetItemSubItems: TStringList;
begin

end;

end.
