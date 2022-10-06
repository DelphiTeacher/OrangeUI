//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconCaptionCheckBox;

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
  uSkinCheckBoxType, uSkinFireMonkeyCheckBox;

type
  TFrameIconCaptionCheckBoxListItemStyle = class(TFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    cbIsSelected: TSkinFMXCheckBox;
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



procedure TFrameIconCaptionCheckBoxListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;

  //图标的尺寸保持正方形
  Self.imgItemIcon.Width:=Self.imgItemIcon.Height;

end;

initialization
  RegisterListItemStyle('IconCaptionCheckBox',TFrameIconCaptionCheckBoxListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameIconCaptionCheckBoxListItemStyle);


end.
