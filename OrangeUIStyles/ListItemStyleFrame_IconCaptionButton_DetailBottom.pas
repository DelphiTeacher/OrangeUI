//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconCaptionButton_DetailBottom;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,

  BaseListItemStyleFrame, uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinPanelType, uSkinFireMonkeyPanel;

type
  TFrameIconCaptionButton_DetailBottomListItemStyle = class(TFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    btnButton: TSkinFMXButton;
    lblItemDetail: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    procedure ItemDesignerPanelResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}

//uses
//  uSkinCustomListType;



procedure TFrameIconCaptionButton_DetailBottomListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;

  //图标的尺寸保持正方形
  Self.imgItemIcon.Width:=Self.imgItemIcon.Height;

end;

initialization
  RegisterListItemStyle('IconCaptionButton_DetailBottom',TFrameIconCaptionButton_DetailBottomListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameIconCaptionButton_DetailBottomListItemStyle);


end.
