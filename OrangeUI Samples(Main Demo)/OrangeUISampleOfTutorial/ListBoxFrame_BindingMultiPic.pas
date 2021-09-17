//convert pas to utf8 by ¥

unit ListBoxFrame_BindingMultiPic;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uDrawCanvas,
  uSkinItems,
  uDrawPicture,
  uSkinListBoxType,

  uSkinFireMonkeyCheckBox, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox,  uSkinImageList, uSkinFireMonkeyButton,
  uSkinFireMonkeyPanel, uSkinFireMonkeyCustomList, uSkinButtonType,
  uSkinPanelType, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uBaseSkinControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType;

type
  //商品组
  TGoodsPair=class(TObject)
  public
    //商品1名称
    Caption1:String;
    //商品1图片
    Pic1:TDrawPicture;

    //商品2名称
    Caption2:String;
    //商品2图片
    Pic2:TDrawPicture;
  public
    constructor Create;
    destructor Destroy;override;
  end;



  TFrameListBox_BindingMultiPic = class(TFrame,IFrameChangeLanguageEvent)
    lbMultiPic: TSkinFMXListBox;
    idpMultiPic: TSkinFMXItemDesignerPanel;
    imgPic1: TSkinFMXImage;
    lblCaption1: TSkinFMXLabel;
    lblCaption2: TSkinFMXLabel;
    imgPic2: TSkinFMXImage;
    pnlToolBarInner: TSkinFMXPanel;
    btnLoad: TSkinFMXButton;
    procedure btnLoadClick(Sender: TObject);
    procedure lbMultiPicPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
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


{ TGoodsPair }

constructor TGoodsPair.Create;
begin
  Pic1:=TDrawPicture.Create;
  Pic2:=TDrawPicture.Create;
end;

destructor TGoodsPair.Destroy;
begin
  FreeAndNil(Pic1);
  FreeAndNil(Pic2);
  inherited;
end;

{ TFrameListBox_BindingMultiPic }

procedure TFrameListBox_BindingMultiPic.btnLoadClick(Sender: TObject);
var
  I: Integer;
  APicServerUrl:String;
  AGoodsPair:TGoodsPair;
  AListBoxItem:TSkinListBoxItem;
begin
  //加载
  Self.lbMultiPic.Prop.Items.BeginUpdate;
  try
    //释放之前的DataObject
    for I := 0 to Self.lbMultiPic.Prop.Items.Count-1 do
    begin
      Self.lbMultiPic.Prop.Items[I].DataObject.Free;
    end;
    //清空列表项
    Self.lbMultiPic.Prop.Items.Clear(True);

    //图片服务器链接地址
    APicServerUrl:='http://www.orangeui.cn/download/testdownloadpicturemanager/mobileposthumbpic/';


    //添加列表项
    AGoodsPair:=TGoodsPair.Create;
    AGoodsPair.Caption1:='Cabernet Sauvignon';
    AGoodsPair.Pic1.Url:=APicServerUrl+'1.jpg';
    AGoodsPair.Caption2:='ARDECHE';
    AGoodsPair.Pic2.Url:=APicServerUrl+'2.jpg';
    AListBoxItem:=Self.lbMultiPic.Prop.Items.Add;
    AListBoxItem.DataObject:=AGoodsPair;


    //添加列表项
    AGoodsPair:=TGoodsPair.Create;
    AGoodsPair.Caption1:='Tieguanyin Tea';
    AGoodsPair.Pic1.Url:=APicServerUrl+'3.jpg';
    AGoodsPair.Caption2:='Longjing Tea';
    AGoodsPair.Pic2.Url:=APicServerUrl+'4.jpg';
    AListBoxItem:=Self.lbMultiPic.Prop.Items.Add;
    AListBoxItem.DataObject:=AGoodsPair;

    //添加列表项
    AGoodsPair:=TGoodsPair.Create;
    AGoodsPair.Caption1:='Wahaha tea coffee';
    AGoodsPair.Pic1.Url:=APicServerUrl+'5.jpg';
    AGoodsPair.Caption2:='Wahaha cat coffee';
    AGoodsPair.Pic2.Url:=APicServerUrl+'6.jpg';
    AListBoxItem:=Self.lbMultiPic.Prop.Items.Add;
    AListBoxItem.DataObject:=AGoodsPair;

    //添加列表项
    AGoodsPair:=TGoodsPair.Create;
    AGoodsPair.Caption1:='series';
    AGoodsPair.Pic1.Url:=APicServerUrl+'7.jpg';
    AGoodsPair.Caption2:='Food Combo';
    AGoodsPair.Pic2.Url:=APicServerUrl+'8.jpg';
    AListBoxItem:=Self.lbMultiPic.Prop.Items.Add;
    AListBoxItem.DataObject:=AGoodsPair;


  finally
    Self.lbMultiPic.Prop.Items.EndUpdate();
  end;

end;

procedure TFrameListBox_BindingMultiPic.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnLoad.Text:=GetLangString(Self.btnLoad.Name,ALangKind);

end;

constructor TFrameListBox_BindingMultiPic.Create(AOwner: TComponent);
begin
  inherited;

  //清空列表
  Self.lbMultiPic.Prop.Items.Clear(True);


  //初始多语言
  RegLangString(Self.btnLoad.Name,[Self.btnLoad.Text,'Load']);

end;

destructor TFrameListBox_BindingMultiPic.Destroy;
var
  I:Integer;
begin
  //释放之前设置的DataObject
  for I := 0 to Self.lbMultiPic.Prop.Items.Count-1 do
  begin
    Self.lbMultiPic.Prop.Items[I].DataObject.Free;
  end;

  inherited;
end;

procedure TFrameListBox_BindingMultiPic.lbMultiPicPrepareDrawItem(
  Sender: TObject; Canvas: TDrawCanvas;
  ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
  ItemRect: TRect);
var
  AGoodsPair:TGoodsPair;
begin
  //取出设置在Item.DataObject中的GoodsPair对象
  AGoodsPair:=TGoodsPair(Item.DataObject);


  //把GoodsPair对象中的数据赋给ItemDesignerPanel上面的控件
  Self.lblCaption1.Caption:=AGoodsPair.Caption1;
  Self.imgPic1.Prop.Picture.RefDrawPicture:=AGoodsPair.Pic1;
  Self.imgPic1.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;

  Self.lblCaption2.Caption:=AGoodsPair.Caption2;
  Self.imgPic2.Prop.Picture.RefDrawPicture:=AGoodsPair.Pic2;
  Self.imgPic2.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;

end;

end.
