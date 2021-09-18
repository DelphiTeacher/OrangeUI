//convert pas to utf8 by ¥
unit ListItemStyleFrame_RecentContact;

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
  uSkinFireMonkeyImage, uSkinButtonType, uSkinNotifyNumberIconType,
  uSkinFireMonkeyNotifyNumberIcon;


type
  //根基类
  TFrameListItemStyle_RecentContact = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgUserHead: TSkinFMXImage;
    lblUserName: TSkinFMXLabel;
    lblUserContent: TSkinFMXLabel;
    nniNumber: TSkinFMXNotifyNumberIcon;
    lblTime: TSkinFMXLabel;
    imgUserVip: TSkinFMXImage;
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

constructor TFrameListItemStyle_RecentContact.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;

  Self.imgUserHead.Prop.Picture.Clear;

  Self.imgUserHead.Prop.Picture.ClipRoundXRadis:=0.1;
  Self.imgUserHead.Prop.Picture.ClipRoundYRadis:=0.1;
  Self.imgUserHead.Prop.Picture.IsClipRound:=True;

end;

function TFrameListItemStyle_RecentContact.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('RecentContact',TFrameListItemStyle_RecentContact);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_RecentContact);

end.

