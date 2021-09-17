//convert pas to utf8 by ¥

unit Basic_MultiDesignerPanel_ListBoxFarme;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDrawCanvas,
  uSkinItems,
  uSkinFireMonkeyCheckBox, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyCustomList, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType;

type
  TFrameBasic_MultiDesignerPanel_ListBox = class(TFrame)
    SkinFMXListBox1: TSkinFMXListBox;
    idpHeader: TSkinFMXItemDesignerPanel;
    imgHead: TSkinFMXImage;
    lblNickName: TSkinFMXLabel;
    lblAccount: TSkinFMXLabel;
    idpMenu: TSkinFMXItemDesignerPanel;
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
