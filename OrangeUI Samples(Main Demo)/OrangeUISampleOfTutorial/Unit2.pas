//convert pas to utf8 by ¥
unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel, uSkinLabelType,
  uSkinImageType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType;

type
  TFrame2 = class(TFrame)
    lblMenu: TSkinFMXListView;
    SkinFMXItemDesignerPanel1: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
