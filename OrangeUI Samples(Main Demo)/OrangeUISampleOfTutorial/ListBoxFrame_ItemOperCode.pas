//convert pas to utf8 by ¥

unit ListBoxFrame_ItemOperCode;

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
  TFrameListBox_ItemOperCode = class(TFrame,IFrameChangeLanguageEvent)
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
    btnInsertItem: TSkinFMXButton;
    SkinFMXButton1: TSkinFMXButton;
    procedure btnAddItemClick(Sender: TObject);
    procedure btnClearItemClick(Sender: TObject);
    procedure btnDelItemClick(Sender: TObject);
    procedure btnInsertItemClick(Sender: TObject);
    procedure pnlToolBarInnerResize(Sender: TObject);
    procedure SkinFMXButton1Click(Sender: TObject);
  private
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

procedure TFrameListBox_ItemOperCode.btnAddItemClick(Sender: TObject);
var
  I: Integer;
  ASkinItem:TSkinItem;
begin
  //准备批量添加
  Self.lbTicketProductList.Prop.Items.BeginUpdate;
  try
    //先清空所有Item
    Self.lbTicketProductList.Prop.Items.Clear(True);

    for I := 0 to 20-1 do
    begin
        //添加Item
        ASkinItem:=Self.lbTicketProductList.Prop.Items.Add;

        if LangKind=lkZH then
        begin
          ASkinItem.Caption:=IntToStr(I)+' '+'南靖土楼云水谣';
          ASkinItem.Detail:='南靖土楼小区12栋';
        end
        else if LangKind=lkEN then
        begin
          ASkinItem.Caption:=IntToStr(I)+' '+'Places of historic interest';
          ASkinItem.Detail:='address of places of historic interest';
        end;


        ASkinItem.Detail1:='109';
        ASkinItem.Detail2:='100';
        //如果有图片的网址,那么可以直接指定Icon的Url
        if I mod 2 = 0 then
        begin
          ASkinItem.Icon.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/TicketProduct1.png';
        end
        else
        begin
          ASkinItem.Icon.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/TicketProduct2.png';
        end;
        {
        //如果图标是文件,则可以使用LoadFromFile
        ASkinItem.Icon.LoadFromFile(AFilePath);
        //如果图标是数据流,则可以使用LoadFromStream
        ASkinItem.Icon.LoadFromStream(AMemoryStream);
        }


        Randomize;
//        ASkinItem.Height:=Random(105);
    end;

  finally
    Self.lbTicketProductList.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameListBox_ItemOperCode.btnClearItemClick(Sender: TObject);
begin
  //准备批量删除
  Self.lbTicketProductList.Prop.Items.BeginUpdate;
  try
    //清空所有Item
    Self.lbTicketProductList.Prop.Items.Clear(True);

  finally
    Self.lbTicketProductList.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameListBox_ItemOperCode.btnDelItemClick(Sender: TObject);
begin
  if Self.lbTicketProductList.Prop.Items.Count>0 then
  begin
      Self.lbTicketProductList.Prop.Items.Delete(0);
      //或使用Remove()
      //Self.lbTicketProductList.Prop.Items.Remove(ASkinItem);
  end;
end;

procedure TFrameListBox_ItemOperCode.btnInsertItemClick(Sender: TObject);
var
  ASkinItem:TSkinItem;
begin
  //插入Item
  ASkinItem:=Self.lbTicketProductList.Prop.Items.Insert(0);

  if LangKind=lkZH then
  begin
    ASkinItem.Caption:='南靖土楼云水谣';
    ASkinItem.Detail:='南靖土楼小区12栋';
  end
  else if LangKind=lkEN then
  begin
    ASkinItem.Caption:='Places of historic interest';
    ASkinItem.Detail:='address of places of historic interest';
  end;

  ASkinItem.Detail1:='109';
  ASkinItem.Detail2:='100';
  ASkinItem.Icon.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/TicketProduct1.png';
end;

procedure TFrameListBox_ItemOperCode.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnAddItem.Text:=GetLangString(Self.btnAddItem.Name,ALangKind);
  Self.btnClearItem.Text:=GetLangString(Self.btnClearItem.Name,ALangKind);
  Self.btnDelItem.Text:=GetLangString(Self.btnDelItem.Name,ALangKind);
  Self.btnInsertItem.Text:=GetLangString(Self.btnInsertItem.Name,ALangKind);

  Self.lblItemSuggestedPrice.Text:=GetLangString(Self.lblItemSuggestedPrice.Name,ALangKind);
  Self.lblItemCostPrice.Text:=GetLangString(Self.lblItemCostPrice.Name,ALangKind);
end;

constructor TFrameListBox_ItemOperCode.Create(AOwner: TComponent);
begin
  inherited;

  if LangKind=lkEN then
  begin
    Self.lbTicketProductList.Prop.Items.Clear(True);
  end;

  //初始多语言
  RegLangString(Self.btnAddItem.Name,[Self.btnAddItem.Text,'Add']);
  RegLangString(Self.btnClearItem.Name,[Self.btnClearItem.Text,'Clear']);
  RegLangString(Self.btnDelItem.Name,[Self.btnDelItem.Text,'Delete']);
  RegLangString(Self.btnInsertItem.Name,[Self.btnInsertItem.Text,'Insert']);

  RegLangString(Self.lblItemSuggestedPrice.Name,[Self.lblItemSuggestedPrice.Text,'price:']);
  RegLangString(Self.lblItemCostPrice.Name,[Self.lblItemCostPrice.Text,'cost:']);
end;

destructor TFrameListBox_ItemOperCode.Destroy;
begin
  inherited;
end;



procedure TFrameListBox_ItemOperCode.pnlToolBarInnerResize(Sender: TObject);
begin
  Self.btnAddItem.Width:=Self.pnlToolBarInner.Width/4;
  Self.btnClearItem.Width:=Self.pnlToolBarInner.Width/4;
  Self.btnDelItem.Width:=Self.pnlToolBarInner.Width/4;
  Self.btnInsertItem.Width:=Self.pnlToolBarInner.Width/4;
end;

procedure TFrameListBox_ItemOperCode.SkinFMXButton1Click(Sender: TObject);
var
//  I: Integer;
  ASkinItem:TSkinItem;
begin
//  //准备批量添加
//  Self.lbTicketProductList.Prop.Items.BeginUpdate;
//  try
//    //先清空所有Item
//    Self.lbTicketProductList.Prop.Items.Clear(True);
//
//    for I := 0 to 20-1 do
//    begin
        //添加Item
        ASkinItem:=Self.lbTicketProductList.Prop.Items.Add;

        if LangKind=lkZH then
        begin
          ASkinItem.Caption:='南靖土楼云水谣';
          ASkinItem.Detail:='南靖土楼小区12栋';
        end
        else if LangKind=lkEN then
        begin
          ASkinItem.Caption:='Places of historic interest';
          ASkinItem.Detail:='address of places of historic interest';
        end;


        ASkinItem.Detail1:='109';
        ASkinItem.Detail2:='100';
        //如果有图片的网址,那么可以直接指定Icon的Url
//        if I mod 2 = 0 then
//        begin
          ASkinItem.Icon.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/TicketProduct1.png';
//        end
//        else
//        begin
//          ASkinItem.Icon.Url:='http://www.orangeui.cn/download/testdownloadpicturemanager/TicketProduct2.png';
//        end;
        {
        //如果图标是文件,则可以使用LoadFromFile
        ASkinItem.Icon.LoadFromFile(AFilePath);
        //如果图标是数据流,则可以使用LoadFromStream
        ASkinItem.Icon.LoadFromStream(AMemoryStream);
        }


        Randomize;
//        ASkinItem.Height:=105+Random(105);
//    end;
//
//  finally
//    Self.lbTicketProductList.Prop.Items.EndUpdate();
//  end;
end;

end.
