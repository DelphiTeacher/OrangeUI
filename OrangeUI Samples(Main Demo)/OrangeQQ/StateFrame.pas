//convert pas to utf8 by ¥

unit StateFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinImageList, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel, uDrawCanvas,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyButton,
  uSkinListBoxType,uSkinItems,uUIFunction,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uDrawPicture, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinImageType, uSkinPanelType;

type
  TFrameState = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    imgToolBarDevide: TSkinFMXImage;
    imglistMenu: TSkinImageList;
    imglistState: TSkinImageList;
    lbMenus: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    imgExpandState: TSkinFMXImage;
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
  public
    { Public declarations }
  end;

var
  GlobalStateFrame:TFrameState;

implementation

{$R *.fmx}


end.
