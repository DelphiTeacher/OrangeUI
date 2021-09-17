//convert pas to utf8 by ¥

unit ListBoxFrame_UseDynamicBinding;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uFrameContext,
  uLang,
  uDrawCanvas,
  uSkinItems,
  uSkinFireMonkeyCheckBox, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uDrawPicture, uSkinImageList, uSkinFireMonkeyButton,
  uSkinFireMonkeyPanel, uSkinFireMonkeyCustomList, uSkinButtonType,
  uSkinPanelType, uSkinCheckBoxType, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType;

type
  TFrameListBox_UseDynamicBinding = class(TFrame,IFrameChangeLanguageEvent)
    lbFileList: TSkinFMXListBox;
    idpFileDetail: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    imgFileExtIcon: TSkinFMXImage;
    lblFileDate: TSkinFMXLabel;
    lblFileSize: TSkinFMXLabel;
    imgArrow: TSkinFMXImage;
    chkItemChecked: TSkinFMXCheckBox;
    imglistFileExt: TSkinImageList;
    pnlToolBarInner: TSkinFMXPanel;
    btnCheckAllItem: TSkinFMXButton;
    btnUnCheckAllItem: TSkinFMXButton;
    chkDetail2: TSkinFMXCheckBox;
    procedure chkItemCheckedClick(Sender: TObject);
    procedure lbFileListPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure btnCheckAllItemClick(Sender: TObject);
    procedure btnUnCheckAllItemClick(Sender: TObject);
    procedure pnlToolBarInnerResize(Sender: TObject);
    procedure chkDetail2Click(Sender: TObject);
    procedure idpFileDetailPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}


constructor TFrameListBox_UseDynamicBinding.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString('UseDynamicBinding Item 0 Caption',
    [Self.lbFileList.Prop.Items[0].Caption,'OrangeUI Video Tutorials']);
  RegLangString('UseDynamicBinding Item 1 Caption',
    [Self.lbFileList.Prop.Items[1].Caption,'Delphi Mobile Development Guide']);
  RegLangString('UseDynamicBinding Item 2 Caption',
    [Self.lbFileList.Prop.Items[2].Caption,'Livy lecture']);

  RegLangString(Self.btnCheckAllItem.Name,[Self.btnCheckAllItem.Text,'Check all']);
  RegLangString(Self.btnUnCheckAllItem.Name,[Self.btnUnCheckAllItem.Text,'Check none']);

end;

procedure TFrameListBox_UseDynamicBinding.idpFileDetailPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
begin

  Self.chkDetail2.Prop.StaticChecked:=
      AItem.Detail2='1';

end;

procedure TFrameListBox_UseDynamicBinding.lbFileListPrepareDrawItem(
  Sender: TObject; Canvas: TDrawCanvas;
  ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
  ItemRect: TRect);
begin
  //动态绑定在OnPrepareDrawItem事件中处理
  //把Item的属性赋给ItemDesignerPanel上的控件即可
  //比如列表项上的CheckBox的勾选状态是根据Item.Checked来设置
  Self.chkItemChecked.Prop.StaticChecked:=Item.Checked;
end;

procedure TFrameListBox_UseDynamicBinding.pnlToolBarInnerResize(
  Sender: TObject);
begin
  Self.btnCheckAllItem.Width:=Self.pnlToolBarInner.Width/2;
  Self.btnUnCheckAllItem.Width:=Self.pnlToolBarInner.Width/2;
end;

procedure TFrameListBox_UseDynamicBinding.btnCheckAllItemClick(Sender: TObject);
var
  I: Integer;
begin
  Self.lbFileList.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lbFileList.Prop.Items.Count-1 do
    begin
      Self.lbFileList.Prop.Items[I].Checked:=True;
    end;
  finally
    Self.lbFileList.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameListBox_UseDynamicBinding.btnUnCheckAllItemClick(
  Sender: TObject);
var
  I: Integer;
begin
  Self.lbFileList.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lbFileList.Prop.Items.Count-1 do
    begin
      Self.lbFileList.Prop.Items[I].Checked:=False;
    end;
  finally
    Self.lbFileList.Prop.Items.EndUpdate();
  end;

end;

procedure TFrameListBox_UseDynamicBinding.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbFileList.Prop.Items[0].Caption:=GetLangString('UseDynamicBinding Item 0 Caption',ALangKind);
  Self.lbFileList.Prop.Items[1].Caption:=GetLangString('UseDynamicBinding Item 1 Caption',ALangKind);
  Self.lbFileList.Prop.Items[2].Caption:=GetLangString('UseDynamicBinding Item 2 Caption',ALangKind);

  Self.btnCheckAllItem.Text:=GetLangString(Self.btnCheckAllItem.Name,ALangKind);
  Self.btnUnCheckAllItem.Text:=GetLangString(Self.btnUnCheckAllItem.Name,ALangKind);

end;

procedure TFrameListBox_UseDynamicBinding.chkDetail2Click(Sender: TObject);
begin
  if Self.lbFileList.Properties.InteractiveItem<>nil then
  begin
      if Self.lbFileList.Properties.InteractiveItem.Detail2='1' then
      begin
        Self.lbFileList.Properties.InteractiveItem.Detail2:='0';
      end
      else
      begin
        Self.lbFileList.Properties.InteractiveItem.Detail2:='1';
      end;
  end;

end;

procedure TFrameListBox_UseDynamicBinding.chkItemCheckedClick(Sender: TObject);
begin
  //点击列表项上的CheckBox,设置当前点击的Item.Checked
  if Self.lbFileList.Properties.InteractiveItem<>nil then
  begin
    Self.lbFileList.Properties.InteractiveItem.Checked:=
      Not Self.lbFileList.Properties.InteractiveItem.Checked;
  end;
end;

end.
