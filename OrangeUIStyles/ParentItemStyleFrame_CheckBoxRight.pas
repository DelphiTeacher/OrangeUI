//convert pas to utf8 by ¥
unit ParentItemStyleFrame_CheckBoxRight;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uDrawCanvas,
  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  uComponentType,
  EasyServiceCommonMaterialDataMoudle,


  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uDrawPicture, uSkinImageList, uSkinImageType, uSkinFireMonkeyImage,
  uSkinCheckBoxType, uSkinFireMonkeyCheckBox;


type
  TFrameParentItemStyle_CheckBoxRight = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgGroupExpanded: TSkinFMXImage;
    lblGroupName: TSkinFMXLabel;
    imglistExpanded: TSkinImageList;
    lblItemCaption: TSkinFMXLabel;
    chkSelected: TSkinFMXCheckBox;
    procedure imgGroupExpandedClick(Sender: TObject);
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameParentItemStyle_CheckBox }

constructor TFrameParentItemStyle_CheckBoxRight.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameParentItemStyle_CheckBoxRight.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameParentItemStyle_CheckBoxRight.imgGroupExpandedClick(Sender: TObject);
var
  ASkinItem:TBaseSkinTreeViewItem;
begin
  if (GlobalCurrentDirectUIMouseControl<>nil)
      and (TSkinVirtualList(GlobalCurrentDirectUIMouseControl).Prop.InteractiveItem<>nil)
      and (TSkinVirtualList(GlobalCurrentDirectUIMouseControl).Prop.InteractiveItem is TBaseSkinTreeViewItem) then
  begin
    ASkinItem:=TBaseSkinTreeViewItem(TSkinVirtualList(GlobalCurrentDirectUIMouseControl).Prop.InteractiveItem);
    ASkinItem.Expanded:=not ASkinItem.Expanded;

  end;
end;

procedure TFrameParentItemStyle_CheckBoxRight.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
begin
  if AItem is TBaseSkinTreeViewItem then
  begin
    if TBaseSkinTreeViewItem(AItem).IsParent then
    begin
      Self.imgGroupExpanded.Prop.Picture.SkinImageList:=imglistExpanded;
    end
    else
    begin
      Self.imgGroupExpanded.Prop.Picture.SkinImageList:=nil;
    end;
  end;

end;

initialization
  RegisterListItemStyle('ParentItemStyle_CheckBoxRight',TFrameParentItemStyle_CheckBoxRight);


finalization
  UnRegisterListItemStyle(TFrameParentItemStyle_CheckBoxRight);

end.

