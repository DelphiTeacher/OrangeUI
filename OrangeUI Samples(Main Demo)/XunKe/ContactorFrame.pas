//convert pas to utf8 by ¥

unit ContactorFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Math,uUIFunction,
  uSkinTreeViewType,
  XunKeCommonSkinMaterialModule,
  uSkinImageList, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyImage,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  uSkinFireMonkeyTreeView, uSkinFireMonkeyNotifyNumberIcon, uSkinMaterial,
  uSkinItemDesignerPanelType, uSkinButtonType, uDrawPicture,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList, uDrawCanvas,
  uSkinItems, uSkinPanelType, uSkinLabelType, uSkinImageType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType;

type
  TFrameContactor = class(TFrame)
    imglistExpanded: TSkinImageList;
    tvContactor: TSkinFMXTreeView;
    ItemContactor: TSkinFMXItemDesignerPanel;
    imgMessageHead: TSkinFMXImage;
    lblMessageNickName: TSkinFMXLabel;
    lblMessageDetail: TSkinFMXLabel;
    imgMessageNetworkState: TSkinFMXImage;
    ItemGroup: TSkinFMXItemDesignerPanel;
    imgGroupExpanded: TSkinFMXImage;
    lblGroupName: TSkinFMXLabel;
    lblGroupFriendCount: TSkinFMXLabel;
    ItemItem1: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    SkinFMXImage2: TSkinFMXImage;
    SkinFMXImage3: TSkinFMXImage;
    imglistSign: TSkinImageList;
    pnlToolBar: TSkinFMXPanel;
    btnAdd: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
  public
    { Public declarations }
  end;

var
  GlobalContactorFrame:TFrameContactor;

implementation

{$R *.fmx}

procedure TFrameContactor.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;


end.
