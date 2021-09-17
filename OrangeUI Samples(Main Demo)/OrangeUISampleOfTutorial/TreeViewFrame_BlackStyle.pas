//convert pas to utf8 by ¥

unit TreeViewFrame_BlackStyle;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uBaseLog,
  uSkinButtonType,
  uDrawPicture,
  uSkinImageList,

  uDrawCanvas,
  uSkinTreeViewType,
  uSkinItems,

  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyTreeView,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyVirtualList, FMX.TabControl, uSkinFireMonkeyCustomList,
  uSkinImageType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uBaseSkinControl, uSkinPanelType;




type
  TFrameTreeView_BlackStyle = class(TFrame)
    imglistExpanded: TSkinImageList;
    pnlTopBar: TSkinFMXPanel;
    tvSimple: TSkinFMXTreeView;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXItemDesignerPanel2: TSkinFMXItemDesignerPanel;
    SkinFMXImage3: TSkinFMXImage;
    SkinFMXLabel3: TSkinFMXLabel;
    idpItemPanDrag: TSkinFMXItemDesignerPanel;
    btnCall: TSkinFMXButton;
    btnDel: TSkinFMXButton;
    procedure btnDelClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;




implementation



{$R *.fmx}

{ TFrameTreeView }

procedure TFrameTreeView_BlackStyle.btnDelClick(Sender: TObject);
var
  AItem:TBaseSkinTreeViewItem;
begin
  if Self.tvSimple.Prop.PanDragItem.Parent<>nil then
  begin
    AItem:=Self.tvSimple.Prop.PanDragItem;
    TSkinTreeViewItem(AItem.Parent).Childs.Remove(AItem);
  end;
end;

constructor TFrameTreeView_BlackStyle.Create(AOwner: TComponent);
begin
  inherited;


end;


end.
