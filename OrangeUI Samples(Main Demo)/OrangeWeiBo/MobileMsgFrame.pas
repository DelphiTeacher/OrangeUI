//convert pas to utf8 by ¥

unit MobileMsgFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyImage, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyButton, uDrawPicture, uSkinImageList, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyListBox, uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList;

type
  TFrameMobileMsg = class(TFrame)
    imgExpandState: TSkinImageList;
    imglstHead: TSkinImageList;
    lblProfile: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    lblMenu: TSkinFMXLabel;
    SkinFMXImage3: TSkinFMXImage;
    imgMenu: TSkinFMXImage;
    pnlToolBar: TSkinFMXPanel;
    imgLine: TSkinFMXImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalMobileMsgFrame:TFrameMobileMsg;

implementation

{$R *.fmx}

end.
