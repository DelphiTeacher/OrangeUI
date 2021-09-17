//convert pas to utf8 by ¥

unit Box9Menu_CZNYT_MainFrame;

interface

uses
  System.SysUtils,uFuncCommon, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinItems,
  uBaseLog,
  Math,
  uFrameContext,
  uUIFunction, uSkinMaterial, uSkinNotifyNumberIconType, uDrawPicture,
  uSkinImageList, uSkinFireMonkeyPanel, uSkinFireMonkeyNotifyNumberIcon,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyImageListViewer, uSkinFireMonkeyCustomList, uSkinPanelType,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType, uSkinButtonType,
  uSkinScrollControlType, uSkinImageListViewerType;



type
  TFrameBox9Menu_CZNYT_Main = class(TFrame)
    imglistViewer: TSkinImageList;
    imgPlayer: TSkinFMXImageListViewer;
    SkinFMXButtonGroup2: TSkinFMXButtonGroup;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXButton2: TSkinFMXButton;
    SkinFMXButton3: TSkinFMXButton;
    SkinFMXButton4: TSkinFMXButton;
    lblMenu: TSkinFMXListView;
    idpMenu: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    nniMenuHintCount: TSkinFMXNotifyNumberIcon;
    pnlToolBar: TSkinFMXPanel;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;


implementation

{$R *.fmx}

uses
  MainForm;

constructor TFrameBox9Menu_CZNYT_Main.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TFrameBox9Menu_CZNYT_Main.Destroy;
begin
  inherited;
end;


end.








