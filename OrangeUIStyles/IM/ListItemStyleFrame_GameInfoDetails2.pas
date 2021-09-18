//convert pas to utf8 by ¥
unit ListItemStyleFrame_GameInfoDetails2;

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
  uSkinFireMonkeyNotifyNumberIcon, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyButton, uSkinPanelType, uSkinFireMonkeyPanel;


type
  //根基类
  TFrameListItemStyle_GameInfoDetails2 = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXButton2: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXButton3: TSkinFMXButton;
    SkinFMXButton4: TSkinFMXButton;
    SkinFMXImage2: TSkinFMXImage;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXButton5: TSkinFMXButton;
    SkinFMXButton6: TSkinFMXButton;
    SkinFMXImage3: TSkinFMXImage;
    SkinFMXPanel4: TSkinFMXPanel;
    SkinFMXButton7: TSkinFMXButton;
    SkinFMXButton8: TSkinFMXButton;
    SkinFMXImage4: TSkinFMXImage;
    SkinFMXPanel5: TSkinFMXPanel;
    SkinFMXButton9: TSkinFMXButton;
    SkinFMXButton10: TSkinFMXButton;
    SkinFMXImage5: TSkinFMXImage;
    SkinFMXPanel6: TSkinFMXPanel;
    SkinFMXButton11: TSkinFMXButton;
    SkinFMXButton12: TSkinFMXButton;
    SkinFMXImage6: TSkinFMXImage;
    SkinFMXPanel7: TSkinFMXPanel;
    SkinFMXButton13: TSkinFMXButton;
    SkinFMXButton14: TSkinFMXButton;
    SkinFMXImage7: TSkinFMXImage;
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

constructor TFrameListItemStyle_GameInfoDetails2.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;

end;

function TFrameListItemStyle_GameInfoDetails2.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

initialization
  RegisterListItemStyle('GameInfoDetails2',TFrameListItemStyle_GameInfoDetails2);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_GameInfoDetails2);

end.
