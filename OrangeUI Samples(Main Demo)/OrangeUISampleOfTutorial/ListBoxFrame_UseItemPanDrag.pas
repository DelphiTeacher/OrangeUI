//convert pas to utf8 by ¥

unit ListBoxFrame_UseItemPanDrag;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uSkinItems,
  uFrameContext,
  uUIFunction,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyCustomList,
  uSkinPanelType, uSkinButtonType, uSkinItemDesignerPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uDrawCanvas;

type
  TFrameListBox_UseItemPanDrag = class(TFrame,IFrameChangeLanguageEvent)
    lbAppList: TSkinFMXListBox;
    idpItemPanDrag: TSkinFMXItemDesignerPanel;
    btnCall: TSkinFMXButton;
    btnDel: TSkinFMXButton;
    pnlToolBarInner: TSkinFMXPanel;
    btnStartItemPanDrag: TSkinFMXButton;
    btnStopItemPanDrag: TSkinFMXButton;
    procedure btnStartItemPanDragClick(Sender: TObject);
    procedure btnStopItemPanDragClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnCallClick(Sender: TObject);
    procedure pnlToolBarInnerResize(Sender: TObject);
    procedure lbAppListPrepareItemPanDrag(Sender: TObject; AItem: TSkinItem;
      var AItemIsCanPanDrag: Boolean);
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

procedure TFrameListBox_UseItemPanDrag.btnCallClick(Sender: TObject);
begin
  Self.lbAppList.Prop.StopItemPanDrag;
end;

procedure TFrameListBox_UseItemPanDrag.btnDelClick(Sender: TObject);
begin
  //删除平移的列表项
  Self.lbAppList.Properties.Items.Remove(
      Self.lbAppList.Properties.PanDragItem,True
      );
end;

procedure TFrameListBox_UseItemPanDrag.btnStartItemPanDragClick(Sender: TObject);
begin
  Self.lbAppList.Prop.StartItemPanDrag(Self.lbAppList.Prop.Items[0]);
end;

procedure TFrameListBox_UseItemPanDrag.btnStopItemPanDragClick(Sender: TObject);
begin
  Self.lbAppList.Prop.StopItemPanDrag;
end;

procedure TFrameListBox_UseItemPanDrag.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnStartItemPanDrag.Text:=
    GetLangString(Self.btnStartItemPanDrag.Name,ALangKind);
  Self.btnStopItemPanDrag.Text:=
    GetLangString(Self.btnStopItemPanDrag.Name,ALangKind);

end;

constructor TFrameListBox_UseItemPanDrag.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.btnStartItemPanDrag.Name,
                [Self.btnStartItemPanDrag.Text,'Start PanDrag']);
  RegLangString(Self.btnStopItemPanDrag.Name,
                [Self.btnStopItemPanDrag.Text,'Stop PanDrag']);

end;

procedure TFrameListBox_UseItemPanDrag.lbAppListPrepareItemPanDrag(
  Sender: TObject; AItem: TSkinItem; var AItemIsCanPanDrag: Boolean);
begin
  if AItem.Index=3 then
  begin
    //最后一个Item不允许平拖
    AItemIsCanPanDrag:=False;
  end
  else
  begin

      if AItem.Index=1 then
      begin
        //第二个Item没有删除按钮
        Self.btnDel.Visible:=False;
        Self.idpItemPanDrag.Width:=Self.btnCall.Width;
      end
      else
      begin
        Self.btnDel.Visible:=True;
        Self.idpItemPanDrag.Width:=Self.btnCall.Width*2;
      end;

  end;
end;

procedure TFrameListBox_UseItemPanDrag.pnlToolBarInnerResize(Sender: TObject);
begin
  Self.btnStartItemPanDrag.Width:=Self.pnlToolBarInner.Width/2;
  Self.btnStopItemPanDrag.Width:=Self.pnlToolBarInner.Width/2;

end;

end.
