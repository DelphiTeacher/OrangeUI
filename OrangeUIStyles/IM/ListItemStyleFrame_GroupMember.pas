//convert pas to utf8 by ¥
unit ListItemStyleFrame_GroupMember;

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
  TFrameListItemStyle_GroupMember = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgUserHead: TSkinFMXImage;
    lblUserName: TSkinFMXLabel;
    lblUserContent: TSkinFMXLabel;
    nniNumber: TSkinFMXNotifyNumberIcon;
    imgUserVip: TSkinFMXImage;
    nniRole: TSkinFMXNotifyNumberIcon;
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

constructor TFrameListItemStyle_GroupMember.Create(AOwner: TComponent);
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

function TFrameListItemStyle_GroupMember.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('GroupMember',TFrameListItemStyle_GroupMember);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_GroupMember);

end.
