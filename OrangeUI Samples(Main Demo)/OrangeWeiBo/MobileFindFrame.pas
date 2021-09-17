//convert pas to utf8 by ¥

unit MobileFindFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyButton, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyCustomList;

type
  TFrameMobileFind = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    imgLine: TSkinFMXImage;
    imgSearchBar: TSkinFMXImage;
    imgSearchIcon: TSkinFMXImage;
    lblSearchHint: TSkinFMXLabel;
    lblProfile: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgMenu: TSkinFMXImage;
    imglstHead: TSkinImageList;
    pnlMenuInfo: TSkinFMXPanel;
    lblMenuCaption: TSkinFMXLabel;
    lblMenuDetail: TSkinFMXLabel;
    ItemHeader: TSkinFMXItemDesignerPanel;
    imgAdv: TSkinFMXImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalMobileFindFrame:TFrameMobileFind;

implementation

{$R *.fmx}

end.
