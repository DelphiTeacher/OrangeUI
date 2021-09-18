//convert pas to utf8 by ¥
unit ListItemStyleFrame_SimpleGameInfo2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage, uDrawPicture, uSkinImageList, uSkinPanelType,
  uSkinFireMonkeyPanel;


type
  //根基类
  TFrameListItemStyle_SimpleGameInfo2 = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    imgMore: TSkinFMXImage;
    SkinImageList1: TSkinImageList;
    imgbg: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    lblArea: TSkinFMXLabel;
    lblZhiYe: TSkinFMXLabel;
    lblLevel: TSkinFMXLabel;
    lblShengWang: TSkinFMXLabel;
    lblShengWangDetail: TSkinFMXLabel;
    pnlTop: TSkinFMXPanel;
    pnlBottom: TSkinFMXPanel;
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



{ TFrameBaseListItemStyle }

constructor TFrameListItemStyle_SimpleGameInfo2.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;

  Self.imgItemIcon.Prop.Picture.Clear;
end;

function TFrameListItemStyle_SimpleGameInfo2.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('SimpleGameInfo2',TFrameListItemStyle_SimpleGameInfo2);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SimpleGameInfo2);

end.

