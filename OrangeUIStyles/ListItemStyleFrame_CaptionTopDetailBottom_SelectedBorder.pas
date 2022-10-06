//convert pas to utf8 by ¥
unit ListItemStyleFrame_CaptionTopDetailBottom_SelectedBorder;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uDrawCanvas,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage;


type
  //根基类
  TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    imgSelected: TSkinFMXImage;
    procedure ItemDesignerPanelResize(Sender: TObject);
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder }

constructor TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
begin
  //
  Self.imgSelected.Visible:=AItem.Selected;
end;

procedure TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder.ItemDesignerPanelResize(
  Sender: TObject);
begin
  lblItemDetail.Height:=ItemDesignerPanel.Height*0.5;

end;

initialization
  RegisterListItemStyle('CaptionTopDetailBottom_SelectedBorder',TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_CaptionTopDetailBottom_SelectedBorder);

end.
