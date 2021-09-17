//convert pas to utf8 by ¥

unit ListBoxFrame_BindingMultiPic2;

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
  TFrameListBox_BindingMultiPic2 = class(TFrame,IFrameChangeLanguageEvent)
    lbMultiPic: TSkinFMXListBox;
    idpMultiPic: TSkinFMXItemDesignerPanel;
    imgPic1: TSkinFMXImage;
    lblCaption1: TSkinFMXLabel;
    lblCaption2: TSkinFMXLabel;
    imgPic2: TSkinFMXImage;
    pnlToolBarInner: TSkinFMXPanel;
    btnLoad: TSkinFMXButton;
    imgPic3: TSkinFMXImage;
    procedure btnLoadClick(Sender: TObject);
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



{ TFrameListBox_BindingMultiPic }

procedure TFrameListBox_BindingMultiPic2.btnLoadClick(Sender: TObject);
var
  I: Integer;
  APicServerUrl:String;
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
    AListBoxItem:=Self.lbMultiPic.Prop.Items.Add;
    AListBoxItem.Caption:='Cabernet Sauvignon';
    AListBoxItem.Detail:='ARDECHE';
    AListBoxItem.Detail1:=APicServerUrl+'1.jpg';
    AListBoxItem.Detail2:=APicServerUrl+'2.jpg';
    AListBoxItem.Detail3:=APicServerUrl+'3.jpg';


    //添加列表项
    AListBoxItem:=Self.lbMultiPic.Prop.Items.Add;
    AListBoxItem.Caption:='Tieguanyin Tea';
    AListBoxItem.Detail:='Longjing Tea';
    AListBoxItem.Detail1:=APicServerUrl+'4.jpg';
    AListBoxItem.Detail2:=APicServerUrl+'5.jpg';
    AListBoxItem.Detail3:=APicServerUrl+'6.jpg';


  finally
    Self.lbMultiPic.Prop.Items.EndUpdate();
  end;

end;

procedure TFrameListBox_BindingMultiPic2.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnLoad.Text:=GetLangString(Self.btnLoad.Name,ALangKind);

end;

constructor TFrameListBox_BindingMultiPic2.Create(AOwner: TComponent);
begin
  inherited;

  //清空列表
  Self.lbMultiPic.Prop.Items.Clear(True);


  //初始多语言
  RegLangString(Self.btnLoad.Name,[Self.btnLoad.Text,'Load']);

end;

destructor TFrameListBox_BindingMultiPic2.Destroy;
begin

  inherited;
end;

end.
