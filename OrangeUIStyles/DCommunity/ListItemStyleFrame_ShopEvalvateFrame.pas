//convert pas to utf8 by ¥
unit ListItemStyleFrame_ShopEvalvateFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinImageType, uSkinFireMonkeyImage,
  uDrawCanvas, uSkinScrollControlType, uSkinListViewType,
  uSkinFireMonkeyListView;


type
  //根基类
  TFrameListItemStyle_ShopEvalvate = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgHead: TSkinFMXImage;
    lblUserName: TSkinFMXLabel;
    imgUserStar1: TSkinFMXImage;
    imgUserStar2: TSkinFMXImage;
    imgUserStar3: TSkinFMXImage;
    imgUserStar4: TSkinFMXImage;
    imgUserStar5: TSkinFMXImage;
    lblScoreValue: TSkinFMXLabel;
    lblScoreTime: TSkinFMXLabel;
    lblEvaluate: TSkinFMXLabel;
    lblShopReply: TSkinFMXLabel;
    lvGoodsName: TSkinFMXListView;
    imgScore: TSkinFMXImage;
    imgScorePic1: TSkinFMXImage;
    imgScorePic3: TSkinFMXImage;
    imgScorePic4: TSkinFMXImage;
    imgScorePic2: TSkinFMXImage;
    imgScorePic: TSkinFMXImage;
    btnItemOper1: TSkinFMXButton;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameListItemStyle_ShopEvalvate }

constructor TFrameListItemStyle_ShopEvalvate.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ShopEvalvate.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ShopEvalvate',TFrameListItemStyle_ShopEvalvate);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ShopEvalvate);

end.
