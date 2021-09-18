//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconTopCenter_CaptionBottomCenter_Selected;

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
  TFrameListItemStyle_IconTopCenter_CaptionBottomCenter_Selected = class(TFrameBaseListItemStyleBase)
    imgItemIcon: TSkinFMXImage;
    imgChecked: TSkinFMXImage;
    imglistSelected: TSkinImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}




initialization
  RegisterListItemStyle('IconTopCenter_CaptionBottomCenter_Selected',TFrameListItemStyle_IconTopCenter_CaptionBottomCenter_Selected);


finalization
  UnRegisterListItemStyle(TFrameListItemStyle_IconTopCenter_CaptionBottomCenter_Selected);



end.
