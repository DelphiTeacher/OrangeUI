//convert pas to utf8 by ¥

unit ListBoxFrame_UseItemEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyPanel, uSkinFireMonkeyImage,
  FMX.Controls.Presentation, FMX.ComboEdit, uSkinFireMonkeyComboEdit,
  FMX.ListBox, uSkinFireMonkeyComboBox, uSkinFireMonkeyItemDesignerPanel,

  uLang,
  uSkinItems,
  uFrameContext,
  uUIFunction,
  uComponentType,

  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyLabel, uSkinFireMonkeyCustomList, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, FMX.DateTimeCtrls, uSkinFireMonkeyDateEdit,
  uSkinFireMonkeyTimeEdit, uSkinPanelType, uSkinLabelType, uSkinButtonType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uDrawCanvas,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, FMX.Memo.Types;

type
  TFrameListBox_UseItemEdit = class(TFrame,IFrameVirtualKeyboardEvent,IFrameChangeLanguageEvent)
    lbEditTest: TSkinFMXListBox;
    idtItemEdit: TSkinFMXItemDesignerPanel;
    btnDecCount: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnAddCount: TSkinFMXButton;
    lbGoodsName: TSkinFMXLabel;
    SkinFMXItemDesignerPanel2: TSkinFMXItemDesignerPanel;
    lblItemTestEditWhenMultiItemDesignerPanel: TSkinFMXLabel;
    pnlToolBarInner: TSkinFMXPanel;
    btnStopEditingItem: TButton;
    btnCancelEditingItem: TButton;
    btnStartEditingItem: TButton;
    SkinFMXEdit1: TSkinFMXEdit;
    Button1: TButton;
    lblItemSubItems1: TSkinFMXLabel;
    btnStartEditingSubItems: TButton;
    idpItemMemo: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    edtMemo: TSkinFMXMemo;
    SkinFMXTimeEdit1: TSkinFMXTimeEdit;
    SkinFMXDateEdit1: TSkinFMXDateEdit;
    lblItemSubItems2: TSkinFMXLabel;
    lblItemSubItems3: TSkinFMXLabel;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
    SkinFMXMultiColorLabel2: TSkinFMXMultiColorLabel;
    btnChangeSubItemsByCode: TButton;
    procedure edtCountClick(Sender: TObject);
    procedure btnDecCountClick(Sender: TObject);
    procedure btnAddCountClick(Sender: TObject);
    procedure btnStopEditingItemClick(Sender: TObject);
    procedure btnCancelEditingItemClick(Sender: TObject);
    procedure btnStartEditingItemClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnStartEditingSubItemsClick(Sender: TObject);
    procedure edtMemoClick(Sender: TObject);
    procedure lblItemSubItems1Click(Sender: TObject);
    procedure lblItemSubItems2Click(Sender: TObject);
    procedure lblItemSubItems3Click(Sender: TObject);
    procedure btnChangeSubItemsByCodeClick(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameListBox_UseItemEdit.btnAddCountClick(Sender: TObject);
begin
  //加一
  Self.lbEditTest.Properties.InteractiveItem.Detail:=
    IntToStr(StrToInt(Self.lbEditTest.Properties.InteractiveItem.Detail)+1);
end;

procedure TFrameListBox_UseItemEdit.btnCancelEditingItemClick(Sender: TObject);
begin
  Self.lbEditTest.Prop.CancelEditingItem;
end;

procedure TFrameListBox_UseItemEdit.btnChangeSubItemsByCodeClick(
  Sender: TObject);
begin
  if Self.lbEditTest.Prop.Items[1].SubItems.Count=0 then
  begin
    Self.lbEditTest.Prop.Items[1].SubItems.Add('');
  end;
  if Self.lbEditTest.Prop.Items[1].SubItems.Count=1 then
  begin
    Self.lbEditTest.Prop.Items[1].SubItems.Add('');
  end;
  Self.lbEditTest.Prop.Items[1].SubItems[1]:=Self.SkinFMXEdit1.Text;
  Self.lbEditTest.Invalidate;
end;

procedure TFrameListBox_UseItemEdit.btnDecCountClick(Sender: TObject);
begin
  //减一
  Self.lbEditTest.Properties.InteractiveItem.Detail:=
    IntToStr(StrToInt(Self.lbEditTest.Properties.InteractiveItem.Detail)-1);
end;

procedure TFrameListBox_UseItemEdit.btnStartEditingItemClick(Sender: TObject);
begin
  //启动编辑
  Self.lbEditTest.Properties.StartEditingItem(
                                            Self.lbEditTest.Prop.Items[2],
                                            edtCount,
                                            nil,
                                            edtCount.Width-1,0
                                            );

end;

procedure TFrameListBox_UseItemEdit.btnStartEditingSubItemsClick(
  Sender: TObject);
begin
  //启动编辑

//  //第一种方法,传入BindingControl
//  Self.lbEditTest.Properties.StartEditingItem(
//                                            Self.lbEditTest.Prop.Items[3],
//                                            Self.lbItemSubItems1,
//                                            Self.SkinFMXEdit1,
//                                            0,0
//                                            );

  //第二种方法,传入ItemDataType
//  Self.lbEditTest.Properties.StartEditingItemByDataType(
  Self.lbEditTest.Properties.StartEditingItemByFieldName(
                    Self.lbEditTest.Prop.Items[3],
//                    idtSubItems,
//                    1,
                    'ItemSubItems1',
                    Self.SkinFMXEdit1,
                    RectF(Self.lblItemSubItems1.Left,
                          Self.lblItemSubItems1.Top,
                          Self.lblItemSubItems1.Left+100,
                          Self.lblItemSubItems1.Top+30),
                    0,0
                    );

end;

procedure TFrameListBox_UseItemEdit.btnStopEditingItemClick(Sender: TObject);
begin
  Self.lbEditTest.Prop.StopEditingItem;
end;

procedure TFrameListBox_UseItemEdit.Button1Click(Sender: TObject);
begin
  //启动编辑

  //第一种方法,传入BindingControl
//  Self.lbEditTest.Properties.StartEditingItem(
//                                            Self.lbEditTest.Prop.Items[2],
//                                            edtCount,
//                                            Self.SkinFMXEdit1,
//                                            SkinFMXEdit1.Width-1,0
//                                            );

  //第二种方法,传入ItemDataType
//  Self.lbEditTest.Properties.StartEditingItemByDataType(
  Self.lbEditTest.Properties.StartEditingItemByFieldName(
                    Self.lbEditTest.Prop.Items[2],
                    'ItemDetail',
//                    idtDetail,
//                    -1,
                    Self.SkinFMXEdit1,
                    RectF(Self.edtCount.Left,
                          Self.edtCount.Top,
                          Self.edtCount.Left+100,
                          Self.edtCount.Top+30),
                    SkinFMXEdit1.Width-1,0
                    );

end;

procedure TFrameListBox_UseItemEdit.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblItemTestEditWhenMultiItemDesignerPanel.Text:=
    GetLangString(Self.lblItemTestEditWhenMultiItemDesignerPanel.Name,ALangKind);

end;

constructor TFrameListBox_UseItemEdit.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;

  //初始多语言
  RegLangString(Self.lblItemTestEditWhenMultiItemDesignerPanel.Name,
                [Self.lblItemTestEditWhenMultiItemDesignerPanel.Text,'Test edit item when using multi ItemDesignerPanel']);


  edtCount.ParentMouseEvent:=False;
  edtCount.MouseEventTransToParentType:=mettptNotTrans;

  for I := 0 to Self.lbEditTest.Prop.Items.Count-1 do
  begin
    Self.lbEditTest.Prop.Items[I].SubItems.Values['key']:=IntToStr(I);
  end;

end;

procedure TFrameListBox_UseItemEdit.DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
begin
  //处理虚拟键盘隐藏


end;

procedure TFrameListBox_UseItemEdit.DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
begin
  //处理虚拟键盘弹出


end;

procedure TFrameListBox_UseItemEdit.edtCountClick(Sender: TObject);
begin
  //启动编辑
  Self.lbEditTest.Properties.StartEditingItem(
                                            Self.lbEditTest.Properties.MouseOverItem,
                                            edtCount,
                                            edtCount,
                                            edtCount.SkinControlType.FMouseDownPt.X,
                                            edtCount.SkinControlType.FMouseDownPt.Y
                                            );
  edtCount.ParentMouseEvent:=False;
  edtCount.MouseEventTransToParentType:=mettptNotTrans;
end;

procedure TFrameListBox_UseItemEdit.edtMemoClick(Sender: TObject);
begin
  //启动编辑
  Self.lbEditTest.Properties.StartEditingItem(
                                            Self.lbEditTest.Properties.MouseOverItem,
                                            edtMemo,
                                            nil,
                                            edtMemo.SkinControlType.FMouseDownPt.X,
                                            edtMemo.SkinControlType.FMouseDownPt.Y
                                            );

end;

procedure TFrameListBox_UseItemEdit.lblItemSubItems1Click(Sender: TObject);
begin
  //启动编辑
  Self.lbEditTest.Properties.StartEditingItem(
                                            Self.lbEditTest.Properties.MouseOverItem,
                                            lblItemSubItems1,
                                            Self.SkinFMXEdit1,
                                            lblItemSubItems1.SkinControlType.FMouseDownPt.X,
                                            lblItemSubItems1.SkinControlType.FMouseDownPt.Y
                                            );

end;

procedure TFrameListBox_UseItemEdit.lblItemSubItems2Click(Sender: TObject);
begin
  //启动编辑
  Self.lbEditTest.Properties.StartEditingItem(
                                            Self.lbEditTest.Properties.MouseOverItem,
                                            lblItemSubItems2,
                                            Self.SkinFMXEdit1,
                                            lblItemSubItems2.SkinControlType.FMouseDownPt.X,
                                            lblItemSubItems2.SkinControlType.FMouseDownPt.Y
                                            );

end;

procedure TFrameListBox_UseItemEdit.lblItemSubItems3Click(Sender: TObject);
begin
  //启动编辑
  Self.lbEditTest.Properties.StartEditingItem(
                                            Self.lbEditTest.Properties.MouseOverItem,
                                            lblItemSubItems3,
                                            Self.SkinFMXEdit1,
                                            lblItemSubItems3.SkinControlType.FMouseDownPt.X,
                                            lblItemSubItems3.SkinControlType.FMouseDownPt.Y
                                            );


end;

end.
