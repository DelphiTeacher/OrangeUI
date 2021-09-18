//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconCaption_NotifyNumberIconRight;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage, uSkinPanelType, uSkinFireMonkeyPanel, uSkinButtonType,
  uSkinNotifyNumberIconType, uSkinFireMonkeyNotifyNumberIcon;


type
  //根基类
  TFrameListItemStyle_IconCaption_NotifyNumberIconRight = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    nniNumber: TSkinFMXNotifyNumberIcon;
    SkinFMXPanel1: TSkinFMXPanel;
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



{ TFrameBaseListItemStyle }

constructor TFrameListItemStyle_IconCaption_NotifyNumberIconRight.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_IconCaption_NotifyNumberIconRight.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('IconCaption_NotifyNumberIconRight',TFrameListItemStyle_IconCaption_NotifyNumberIconRight);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_IconCaption_NotifyNumberIconRight);

end.
