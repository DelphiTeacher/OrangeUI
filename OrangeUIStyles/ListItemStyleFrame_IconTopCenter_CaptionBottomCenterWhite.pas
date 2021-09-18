//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconTopCenter_CaptionBottomCenterWhite;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uGraphicCommon,
  uSkinItems,
  uSkinBufferBitmap,
  uSkinCustomListType,
  BaseListItemStyleFrame,


  ListItemStyleFrame_Base, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList;

type
  TFrameListItemStyle_IconTopCenter_CaptionBottomCenterWhite = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}




{ TFrameListItemStyle_IconTopCenter_CaptionBottomCenterWhite }

function TFrameListItemStyle_IconTopCenter_CaptionBottomCenterWhite.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

initialization
  RegisterListItemStyle('IconTopCenter_CaptionBottomCenterWhite',TFrameListItemStyle_IconTopCenter_CaptionBottomCenterWhite);


finalization
  UnRegisterListItemStyle(TFrameListItemStyle_IconTopCenter_CaptionBottomCenterWhite);



end.
