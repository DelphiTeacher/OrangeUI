//convert pas to utf8 by ¥
unit ListItemStyleFrame_SangNa_WineWaterItem;

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
  uSkinImageList;


type
  //桑拿项目房态
  TFrameListItemStyle_SangNa_WineWaterItem = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblItemDetail_1: TSkinFMXMultiColorLabel;
    btnDelete: TSkinFMXButton;
    lblItemDetai3: TSkinFMXLabel;
    imglistAdd: TSkinImageList;
    btnDec: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnAdd: TSkinFMXButton;
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



{ TFrameListItemStyleFrame_SangNa_WineWaterItem }

constructor TFrameListItemStyle_SangNa_WineWaterItem.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_SangNa_WineWaterItem.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('SangNa_WineWaterItem',TFrameListItemStyle_SangNa_WineWaterItem);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_SangNa_WineWaterItem);

end.
