//convert pas to utf8 by ¥
unit ParentItemStyleFrame_ObjectInspector;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  uComponentType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uDrawPicture, uSkinImageList, uSkinImageType, uSkinFireMonkeyImage;


type
  TFrameParentItemStyle_ObjectInspector = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgGroupExpanded: TSkinFMXImage;
    lblGroupName: TSkinFMXLabel;
    imglistExpanded: TSkinImageList;
    lblItemCaption: TSkinFMXLabel;
    procedure imgGroupExpandedClick(Sender: TObject);
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



{ TFrameParentItemStyle_ObjectInspector }

constructor TFrameParentItemStyle_ObjectInspector.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameParentItemStyle_ObjectInspector.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameParentItemStyle_ObjectInspector.imgGroupExpandedClick(Sender: TObject);
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

initialization
  RegisterListItemStyle('ParentItemStyle_ObjectInspector',TFrameParentItemStyle_ObjectInspector);


finalization
  UnRegisterListItemStyle(TFrameParentItemStyle_ObjectInspector);

end.

