//convert pas to utf8 by ¥

unit SettingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  XunKeCommonSkinMaterialModule,
  uDrawCanvas,
  uSkinItems,
  uUIFunction,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinImageList,
  uDrawPicture, uSkinFireMonkeyButton, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyCustomList, uSkinLabelType, uSkinImageType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinButtonType, uSkinPanelType;

type
  TFrameSetting = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbMenu: TSkinFMXListBox;
    Header: TSkinFMXItemDesignerPanel;
    imgHead: TSkinFMXImage;
    lblNickName: TSkinFMXLabel;
    imgExpandState1: TSkinFMXImage;
    SkinFMXImage5: TSkinFMXImage;
    imglistState: TSkinImageList;
    SkinFMXLabel1: TSkinFMXLabel;
    imglistIcon: TSkinImageList;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    imgExpandState: TSkinFMXImage;
    imgMenuSign: TSkinFMXImage;
    btnReturn: TSkinFMXButton;
    procedure lbMenuPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalSettingFrame:TFrameSetting;


implementation

{$R *.fmx}

procedure TFrameSetting.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameSetting.lbMenuPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin
  imgMenuSign.Visible:=Item.Caption='设置';

end;

end.
