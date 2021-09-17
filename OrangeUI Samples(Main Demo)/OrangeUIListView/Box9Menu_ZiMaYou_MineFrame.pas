//convert pas to utf8 by ¥

unit Box9Menu_ZiMaYou_MineFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,



  uFuncCommon,
  uUIFunction,


  uSkinFireMonkeyControl, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, FMX.Objects, uSkinFireMonkeyButton,
  uSkinFireMonkeyPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyCustomList, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType, uSkinButtonType,
  uSkinPanelType, uSkinLabelType, uSkinImageType, uDrawCanvas, uSkinItems;




type
  TFrameBox9Menu_ZiMaYou_Mine = class(TFrame)
    pnlToolBar: TSkinFMXImage;
    lvMenu: TSkinFMXListView;
    lblStoreName: TSkinFMXLabel;
    lblSellerName: TSkinFMXLabel;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgItemMenuIcon: TSkinFMXImage;
    lblItemMenuCaption: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    btnMyCard: TSkinFMXButton;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    imgHeadBack: TSkinFMXImage;
    rrHead: TRoundRect;
    imgShareBarCode: TSkinFMXImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  MainForm;


{$R *.fmx}



end.
