//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconTopCenter_CaptionBottomCenterBlack_Notify;

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
  uDrawPicture, uSkinImageList, uSkinButtonType, uSkinNotifyNumberIconType,
  uSkinFireMonkeyNotifyNumberIcon;

type
  TFrameListItemStyle_IconTopCenter_CaptionBottomCenterBlack_Notify = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    nniNumber: TSkinFMXNotifyNumberIcon;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


implementation

{$R *.fmx}




{ TFrameListItemStyle_IconTopCenter_CaptionBottomCenterBlack_Notify }

constructor TFrameListItemStyle_IconTopCenter_CaptionBottomCenterBlack_Notify.Create(
  AOwner: TComponent);
begin
  inherited;

  Self.imgItemIcon.Prop.Picture.Clear;
end;

function TFrameListItemStyle_IconTopCenter_CaptionBottomCenterBlack_Notify.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

initialization
  RegisterListItemStyle('IconTopCenter_CaptionBottomCenterBlack_Notify',TFrameListItemStyle_IconTopCenter_CaptionBottomCenterBlack_Notify);


finalization
  UnRegisterListItemStyle(TFrameListItemStyle_IconTopCenter_CaptionBottomCenterBlack_Notify);



end.
