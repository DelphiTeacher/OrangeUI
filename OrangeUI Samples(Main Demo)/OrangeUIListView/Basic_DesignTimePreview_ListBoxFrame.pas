//convert pas to utf8 by ¥

unit Basic_DesignTimePreview_ListBoxFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uDrawPicture, uSkinImageList, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uSkinImageType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType;

type
  TFrameBasic_DesignTimePreview_ListBox = class(TFrame)
    imgExpandState: TSkinImageList;
    imglstHead: TSkinImageList;
    lblProfile: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    lblMenu: TSkinFMXLabel;
    SkinFMXImage3: TSkinFMXImage;
    imgMenu: TSkinFMXImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}

end.

