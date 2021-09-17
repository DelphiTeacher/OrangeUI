//convert pas to utf8 by ¥

unit ListBoxFrame_UseSelfOwnMaterial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uDrawCanvas,
  uSkinItems,
  uSkinFireMonkeyItemDesignerPanel,

  uLang,
  uFrameContext,

  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyButton, uSkinFireMonkeyPanel, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinPanelType, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType;

type
  TFrameListBox_UseSelfOwnMaterial = class(TFrame,IFrameChangeLanguageEvent)
    lbAppList: TSkinFMXListBox;
    pnlToolBarInner: TSkinFMXPanel;
    Edit1: TEdit;
    btnStartEditingItem: TButton;
    SkinFMXEdit1: TSkinFMXEdit;
    btnStopEditingItem: TButton;
    btnCancelEditingItem: TButton;
    btnStartEditingItem1: TButton;
    Button1: TButton;
    procedure btnStartEditingItemClick(Sender: TObject);
    procedure btnStopEditingItemClick(Sender: TObject);
    procedure btnStartEditingItem1Click(Sender: TObject);
    procedure btnCancelEditingItemClick(Sender: TObject);
    procedure lbAppListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure Button1Click(Sender: TObject);
    procedure lbAppListClickItem(AItem: TSkinItem);
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

{ TFrameListBox_UseSelfOwnMaterial }

procedure TFrameListBox_UseSelfOwnMaterial.btnStartEditingItemClick(Sender: TObject);
begin
//  Self.lbAppList.Prop.StartEditingItemByDataType(
  Self.lbAppList.Prop.StartEditingItemByFieldName(
                    Self.lbAppList.Prop.Items[0],
                    'ItemCaption',
//                    idtCaption,
//                    -1,
                    Self.Edit1,
                    RectF(60,10,200,30),
                    0,0
                    );
end;

procedure TFrameListBox_UseSelfOwnMaterial.btnStopEditingItemClick(
  Sender: TObject);
begin
  Self.lbAppList.Prop.StopEditingItem;
end;

procedure TFrameListBox_UseSelfOwnMaterial.Button1Click(Sender: TObject);
begin
  if Self.lbAppList.Prop.SelectedItem<>nil then
  begin
    Self.lbAppList.Prop.Items.BeginUpdate;
    try
      Self.lbAppList.Prop.Items.Move(
                  Self.lbAppList.Prop.SelectedItem.Index,
                  Self.lbAppList.Prop.SelectedItem.Index-1
                  );
    finally
      Self.lbAppList.Prop.Items.EndUpdate();
    end;
  end;
end;

procedure TFrameListBox_UseSelfOwnMaterial.btnCancelEditingItemClick(
  Sender: TObject);
begin
  Self.lbAppList.Prop.CancelEditingItem;
end;

procedure TFrameListBox_UseSelfOwnMaterial.btnStartEditingItem1Click(Sender: TObject);
begin
//  Self.lbAppList.Prop.StartEditingItemByDataType(
  Self.lbAppList.Prop.StartEditingItemByFieldName(
                    Self.lbAppList.Prop.Items[0],
                    'ItemCaption',
//                    idtCaption,
//                    -1,
                    Self.SkinFMXEdit1,
                    RectF(60,10,200,30),
                    0,0
                    );

end;

procedure TFrameListBox_UseSelfOwnMaterial.ChangeLanguage(ALangKind: TLangKind);
begin

end;

constructor TFrameListBox_UseSelfOwnMaterial.Create(AOwner: TComponent);
begin
  inherited;


end;

procedure TFrameListBox_UseSelfOwnMaterial.lbAppListClickItem(AItem: TSkinItem);
begin
  //
end;

procedure TFrameListBox_UseSelfOwnMaterial.lbAppListPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRect);
begin
  if AItem.Selected then
  begin
    Self.lbAppList.SelfOwnMaterialToDefault.DrawItemIconParam.DrawRectSetting.Height:=70;
  end
  else
  begin
    Self.lbAppList.SelfOwnMaterialToDefault.DrawItemIconParam.DrawRectSetting.Height:=50;
  end;
end;

end.
