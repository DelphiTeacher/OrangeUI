//convert pas to utf8 by ¥

unit ListViewFrame_TestListView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyLabel,

  uLang,
  uFrameContext,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyListView, uSkinFireMonkeyImage, uSkinFireMonkeyControl,
  uSkinFireMonkeyItemDesignerPanel,
  uSkinItems,
  uDrawCanvas,
  uGraphicCommon,
  uSkinListViewType,
  uSkinImageList, FMX.TabControl, uSkinFireMonkeyButton, uSkinFireMonkeyPanel,
  uDrawPicture, uSkinFireMonkeyVirtualList, FMX.ListBox, uSkinFireMonkeyComboBox,
  uSkinFireMonkeyCheckBox, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyCustomList, uSkinCheckBoxType,
  uSkinPanelType, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType;

type
  TFrameListView_TestListView = class(TFrame,IFrameChangeLanguageEvent)
    lb9BoxMenu: TSkinFMXListView;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    pnlToolBarInner: TSkinFMXPanel;
    cmbViewType: TSkinFMXComboBox;
    chkItemSizeCalcType: TSkinFMXCheckBox;
    lblItemHeight: TSkinFMXLabel;
    lblItemWidth: TSkinFMXLabel;
    edtItemWidth: TSkinFMXEdit;
    edtItemHeight: TSkinFMXEdit;
    lblItemSpace: TSkinFMXLabel;
    edtItemSpace: TSkinFMXEdit;
    cmbSpaceType: TSkinFMXComboBox;
    lblColCount: TSkinFMXLabel;
    edtColCount: TSkinFMXEdit;
    chkIsFit: TSkinFMXCheckBox;
    lblViewType: TSkinFMXLabel;
    lblSpaceType: TSkinFMXLabel;
    procedure cmbViewTypeChange(Sender: TObject);
    procedure edtItemWidthChangeTracking(Sender: TObject);
    procedure edtItemHeightChangeTracking(Sender: TObject);
    procedure edtItemSpaceChangeTracking(Sender: TObject);
    procedure cmbSpaceTypeChange(Sender: TObject);
    procedure edtColCountChangeTracking(Sender: TObject);
    procedure chkItemSizeCalcTypeChange(Sender: TObject);
    procedure chkIsFitChange(Sender: TObject);
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


procedure TFrameListView_TestListView.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.lblViewType.Text:=GetLangString(Self.lblViewType.Name,ALangKind);
  Self.lblItemHeight.Text:=GetLangString(Self.lblItemHeight.Name,ALangKind);
  Self.lblItemWidth.Text:=GetLangString(Self.lblItemWidth.Name,ALangKind);
  
  Self.cmbViewType.Items[0]:=GetLangString(Self.cmbViewType.Name+'Caption 0',ALangKind);
  Self.cmbViewType.Items[1]:=GetLangString(Self.cmbViewType.Name+'Caption 1',ALangKind);
  Self.cmbViewType.Items[2]:=GetLangString(Self.cmbViewType.Name+'Caption 2',ALangKind);

  Self.lblSpaceType.Text:=GetLangString(Self.lblSpaceType.Name,ALangKind);
  
  Self.cmbSpaceType.Items[0]:=GetLangString(Self.cmbSpaceType.Name+'Caption 0',ALangKind);
  Self.cmbSpaceType.Items[1]:=GetLangString(Self.cmbSpaceType.Name+'Caption 1',ALangKind);

  Self.lblItemSpace.Text:=GetLangString(Self.lblItemSpace.Name,ALangKind);
  Self.lblColCount.Text:=GetLangString(Self.lblColCount.Name,ALangKind);
  
  Self.chkItemSizeCalcType.Text:=GetLangString(Self.chkItemSizeCalcType.Name,ALangKind);
  Self.chkIsFit.Text:=GetLangString(Self.chkIsFit.Name,ALangKind);
  

  
  Self.lb9BoxMenu.Prop.Items[0].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 0',ALangKind);
  Self.lb9BoxMenu.Prop.Items[1].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 1',ALangKind);
  Self.lb9BoxMenu.Prop.Items[2].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 2',ALangKind);
  Self.lb9BoxMenu.Prop.Items[3].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 3',ALangKind);
  Self.lb9BoxMenu.Prop.Items[4].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 4',ALangKind);
  Self.lb9BoxMenu.Prop.Items[5].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 5',ALangKind);
  Self.lb9BoxMenu.Prop.Items[6].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 6',ALangKind);
  Self.lb9BoxMenu.Prop.Items[7].Caption:=GetLangString(Self.lb9BoxMenu.Name+'Caption 7',ALangKind);

end;

procedure TFrameListView_TestListView.chkIsFitChange(Sender: TObject);
begin
  Self.lb9BoxMenu.Prop.IsItemCountFitControl:=Self.chkIsFit.Prop.Checked;

end;

procedure TFrameListView_TestListView.chkItemSizeCalcTypeChange(
  Sender: TObject);
begin
  if chkItemSizeCalcType.Prop.Checked then
  begin
    Self.lb9BoxMenu.Prop.ItemHeightCalcType:=TItemSizeCalcType.isctFixed;
  end
  else
  begin
    Self.lb9BoxMenu.Prop.ItemHeightCalcType:=TItemSizeCalcType.isctSeparate;
  end;

end;

procedure TFrameListView_TestListView.cmbSpaceTypeChange(Sender: TObject);
begin
  Self.lb9BoxMenu.Prop.ItemSpaceType:=TSkinItemSpaceType(cmbSpaceType.ItemIndex);
end;

procedure TFrameListView_TestListView.cmbViewTypeChange(Sender: TObject);
begin
  Self.lb9BoxMenu.Prop.ViewType:=TListViewType(cmbViewType.ItemIndex);
end;

constructor TFrameListView_TestListView.Create(AOwner: TComponent);
begin
  inherited;

  Self.edtItemHeight.Text:=FloatToStr(Self.lb9BoxMenu.Prop.ItemHeight);
  Self.edtItemWidth.Text:=FloatToStr(Self.lb9BoxMenu.Prop.ItemWidth);
  Self.edtItemSpace.Text:=FloatToStr(Self.lb9BoxMenu.Prop.ItemSpace);
  Self.edtColCount.Text:=FloatToStr(Self.lb9BoxMenu.Prop.ColCount);

  cmbViewType.ItemIndex:=Ord(Self.lb9BoxMenu.Prop.ViewType);
  cmbSpaceType.ItemIndex:=Ord(Self.lb9BoxMenu.Prop.ItemSpaceType);
  chkIsFit.Prop.Checked:=Self.lb9BoxMenu.Prop.IsItemCountFitControl;
  case Self.lb9BoxMenu.Prop.ItemHeightCalcType of
    isctFixed: chkItemSizeCalcType.Prop.Checked:=True;
    isctSeparate: chkItemSizeCalcType.Prop.Checked:=False;
  end;



  //初始多语言
  RegLangString(Self.lblViewType.Name,[Self.lblViewType.Text,'ViewType']);
  RegLangString(Self.lblItemHeight.Name,[Self.lblItemHeight.Text,'ItemHeight']);
  RegLangString(Self.lblItemWidth.Name,[Self.lblItemWidth.Text,'ItemWidth']);

  RegLangString(Self.cmbViewType.Name+'Caption 0',
                [Self.cmbViewType.Items[0],'List mode']);
  RegLangString(Self.cmbViewType.Name+'Caption 1',
                [Self.cmbViewType.Items[1],'Icon mode']);
  RegLangString(Self.cmbViewType.Name+'Caption 2',
                [Self.cmbViewType.Items[2],'Waterfall mode']);

  RegLangString(Self.lblSpaceType.Name,[Self.lblSpaceType.Text,'SpaceType']);

  RegLangString(Self.cmbSpaceType.Name+'Caption 0',
                [Self.cmbSpaceType.Items[0],'default']);
  RegLangString(Self.cmbSpaceType.Name+'Caption 1',
                [Self.cmbSpaceType.Items[1],'middle']);

  RegLangString(Self.lblItemSpace.Name,[Self.lblItemSpace.Text,'ItemSpace']);
  RegLangString(Self.lblColCount.Name,[Self.lblColCount.Text,'ColCount']);

  RegLangString(Self.chkItemSizeCalcType.Name,[Self.chkItemSizeCalcType.Text,'ItemSize Fixed']);
  RegLangString(Self.chkIsFit.Name,[Self.chkIsFit.Text,'Fit ListView']);

  RegLangString(Self.lb9BoxMenu.Name+'Caption 0',[Self.lb9BoxMenu.Prop.Items[0].Caption,'News']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 1',[Self.lb9BoxMenu.Prop.Items[1].Caption,'Inspection']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 2',[Self.lb9BoxMenu.Prop.Items[2].Caption,'Product']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 3',[Self.lb9BoxMenu.Prop.Items[3].Caption,'Supervision']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 4',[Self.lb9BoxMenu.Prop.Items[4].Caption,'Query']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 5',[Self.lb9BoxMenu.Prop.Items[5].Caption,'Investment']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 6',[Self.lb9BoxMenu.Prop.Items[6].Caption,'Supervisor']);
  RegLangString(Self.lb9BoxMenu.Name+'Caption 7',[Self.lb9BoxMenu.Prop.Items[7].Caption,'Communication']);

end;

procedure TFrameListView_TestListView.edtColCountChangeTracking(
  Sender: TObject);
begin
  if Trim(Self.edtColCount.Text)<>'' then
  begin
    Self.lb9BoxMenu.Prop.ColCount:=StrToInt(Self.edtColCount.Text);
  end;

end;

procedure TFrameListView_TestListView.edtItemHeightChangeTracking(
  Sender: TObject);
begin
  if Trim(Self.edtItemHeight.Text)<>'' then
  begin
    Self.lb9BoxMenu.Prop.ItemHeight:=StrToFloat(Self.edtItemHeight.Text);
  end;

end;

procedure TFrameListView_TestListView.edtItemSpaceChangeTracking(
  Sender: TObject);
begin
  if Trim(Self.edtItemSpace.Text)<>'' then
  begin
    Self.lb9BoxMenu.Prop.ItemSpace:=StrToFloat(Self.edtItemSpace.Text);
  end;

end;

procedure TFrameListView_TestListView.edtItemWidthChangeTracking(
  Sender: TObject);
begin
  if Trim(Self.edtItemWidth.Text)<>'' then
  begin
    Self.lb9BoxMenu.Prop.ItemWidth:=StrToFloat(Self.edtItemWidth.Text);
  end;

end;

end.
