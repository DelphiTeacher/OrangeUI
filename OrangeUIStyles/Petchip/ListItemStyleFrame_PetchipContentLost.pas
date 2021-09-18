//convert pas to utf8 by ¥
unit ListItemStyleFrame_PetchipContentLost;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uGraphicCommon,
  uSkinItems,
  uSkinBufferBitmap,
  BaseListItemStyleFrame,
  ListItemStyleFrame_Comment,

  ListItemStyleFrame_PetchipContent, uSkinMaterial, uSkinButtonType,
  uDrawPicture, uSkinImageList, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageListViewerType,
  uSkinFireMonkeyImageListViewer, uDrawCanvas;

type
  TFrameListItemStyle_PetchipContentLost = class(TFramePetchipContentListItemStyle)
    imgMapPosition: TSkinFMXImage;
    pnlLostInfo: TSkinFMXPanel;
    lblPetNameHint: TSkinFMXLabel;
    lblPetName: TSkinFMXLabel;
    lblPetVarietyHint: TSkinFMXLabel;
    lblPetVariety: TSkinFMXLabel;
    lblPetAgeHint: TSkinFMXLabel;
    lblPetAge: TSkinFMXLabel;
    lblPetSex: TSkinFMXLabel;
    lblPetSexHint: TSkinFMXLabel;
    lblPetLostTimeHint: TSkinFMXLabel;
    lblPetLostTime: TSkinFMXLabel;
    lblPetPoint: TSkinFMXLabel;
    lblPetAddr: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    btnFind: TSkinFMXButton;
    btnIsFound: TSkinFMXButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}



initialization
  RegisterListItemStyle('PetchipContentLost',TFrameListItemStyle_PetchipContentLost);


finalization
  UnRegisterListItemStyle(TFrameListItemStyle_PetchipContentLost);

end.
