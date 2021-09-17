//convert pas to utf8 by ¥

unit Bind_RoundImage_MessageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyRoundImage,
  uSkinFireMonkeyImage, uSkinFireMonkeyButton, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uDrawPicture,
  uSkinImageList, FMX.Objects, FMX.TabControl, uSkinFireMonkeyCustomList,
  uSkinLabelType, uSkinImageType, uSkinRoundImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType;

type
  TFrameBind_RoundImage_Message = class(TFrame)
    imglistHead: TSkinImageList;
    lbMessageList: TSkinFMXListBox;
    ItemMessage: TSkinFMXItemDesignerPanel;
    SkinFMXRoundImage1: TSkinFMXRoundImage;
    lblMessageNickName: TSkinFMXLabel;
    lblMessageDetail: TSkinFMXLabel;
    lblMessageTime: TSkinFMXLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
