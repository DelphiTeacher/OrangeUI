//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconCaption_BottomDetail_WhiteBackPic;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uDrawCanvas,
  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,


  BaseListItemStyleFrame, uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel;

type
  TFrameIconCaption_BottomDetail_WhiteBackPicListItemStyle = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    imgItemBackPic: TSkinFMXImage;
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;


implementation

{$R *.fmx}

//uses
//  uSkinCustomListType;



function TFrameIconCaption_BottomDetail_WhiteBackPicListItemStyle.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;

end;

procedure TFrameIconCaption_BottomDetail_WhiteBackPicListItemStyle.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
begin
//  //图标的尺寸保持正方形
//  Self.imgItemIcon.Width:=Self.imgItemIcon.Height;

  //平分
  Self.lblItemCaption.Height:=(Self.imgItemBackPic.Height-imgItemBackPic.Padding.Top-imgItemBackPic.Padding.Bottom)/2;

end;

initialization
  RegisterListItemStyle('IconCaption_BottomDetail_WhiteBackPic',TFrameIconCaption_BottomDetail_WhiteBackPicListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameIconCaption_BottomDetail_WhiteBackPicListItemStyle);


end.
