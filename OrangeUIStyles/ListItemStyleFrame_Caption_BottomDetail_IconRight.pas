//convert pas to utf8 by ¥
unit ListItemStyleFrame_Caption_BottomDetail_IconRight;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, uSkinButtonType, uSkinFireMonkeyButton,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uDrawPicture,
  uSkinImageList, uSkinImageType, uSkinFireMonkeyImage;


type
  //桑拿项目房态
  TFrameListItemStyle_Caption_BottomDetail_IconRight = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgItemIcon: TSkinFMXImage;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
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



{ TFrameListItemStyleFrame_Caption_BottomDetail_IconRight }

constructor TFrameListItemStyle_Caption_BottomDetail_IconRight.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;



end;

function TFrameListItemStyle_Caption_BottomDetail_IconRight.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('Caption_BottomDetail_IconRight',TFrameListItemStyle_Caption_BottomDetail_IconRight);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_Caption_BottomDetail_IconRight);

end.
