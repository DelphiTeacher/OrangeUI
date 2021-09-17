//convert pas to utf8 by ¥

unit ListBoxFrame_UseItemComboBox;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyPanel, uSkinFireMonkeyImage,
  FMX.Controls.Presentation, FMX.ComboEdit, uSkinFireMonkeyComboEdit,
  FMX.ListBox, uSkinFireMonkeyComboBox, uSkinFireMonkeyItemDesignerPanel,

  uLang,
  uFrameContext,

  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyLabel, uSkinFireMonkeyCustomList, uSkinLabelType,
  uSkinItemDesignerPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType;

type
  TFrameListBox_UseItemComboBox = class(TFrame,IFrameChangeLanguageEvent)
    lbEditTest: TSkinFMXListBox;
    idtItemEdit: TSkinFMXItemDesignerPanel;
    cmbItemCaption: TSkinFMXComboBox;
    idpTestMulti: TSkinFMXItemDesignerPanel;
    lblItemTestEditWhenMultiItemDesignerPanel: TSkinFMXLabel;
    procedure cmbItemCaptionStayClick(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}


procedure TFrameListBox_UseItemComboBox.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lbEditTest.Prop.Items[0].Caption:=GetLangString(Self.cmbItemCaption.Name+'Caption 0',ALangKind);
  Self.lbEditTest.Prop.Items[1].Caption:=GetLangString(Self.cmbItemCaption.Name+'Caption 1',ALangKind);
  Self.lbEditTest.Prop.Items[2].Caption:=GetLangString(Self.cmbItemCaption.Name+'Caption 2',ALangKind);

  Self.cmbItemCaption.Items[0]:=GetLangString(Self.cmbItemCaption.Name+'Caption 0',ALangKind);
  Self.cmbItemCaption.Items[1]:=GetLangString(Self.cmbItemCaption.Name+'Caption 1',ALangKind);
  Self.cmbItemCaption.Items[2]:=GetLangString(Self.cmbItemCaption.Name+'Caption 2',ALangKind);

  Self.cmbItemCaption.Prop.HelpText:=GetLangString(Self.cmbItemCaption.Name+'HelpText',ALangKind);

  Self.lblItemTestEditWhenMultiItemDesignerPanel.Text:=
    GetLangString(Self.lblItemTestEditWhenMultiItemDesignerPanel.Name,ALangKind);

end;

procedure TFrameListBox_UseItemComboBox.cmbItemCaptionStayClick(Sender: TObject);
begin
  //启动编辑
  Self.lbEditTest.Properties.StartEditingItem(
                                            Self.lbEditTest.Properties.MouseOverItem,
                                            Self.cmbItemCaption,
                                            nil,
                                            cmbItemCaption.SkinControlType.FMouseDownPt.X,
                                            cmbItemCaption.SkinControlType.FMouseDownPt.Y
                                            );
end;

constructor TFrameListBox_UseItemComboBox.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.cmbItemCaption.Name+'Caption 0',
                [Self.cmbItemCaption.Items[0],'Shang hai']);
  RegLangString(Self.cmbItemCaption.Name+'Caption 1',
                [Self.cmbItemCaption.Items[1],'Bei jing']);
  RegLangString(Self.cmbItemCaption.Name+'Caption 2',
                [Self.cmbItemCaption.Items[2],'Zhe jiang']);

  RegLangString(Self.cmbItemCaption.Name+'HelpText',
                [Self.cmbItemCaption.Prop.HelpText,'Address']);

  RegLangString(Self.lblItemTestEditWhenMultiItemDesignerPanel.Name,
                [Self.lblItemTestEditWhenMultiItemDesignerPanel.Text,'Test edit item when using multi ItemDesignerPanel']);

end;

end.
