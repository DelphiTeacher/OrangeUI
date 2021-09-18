//convert pas to utf8 by ¥
unit ListItemStyleFrame_ProcessTaskOrder;

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
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage;


type
  TFrameListItemStyle_ProcessTaskOrder = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    SkinFMXLabel10: TSkinFMXLabel;
    SkinFMXLabel11: TSkinFMXLabel;
    SkinFMXLabel12: TSkinFMXLabel;
    SkinFMXLabel13: TSkinFMXLabel;
    lblStyle: TSkinFMXLabel;
    SkinFMXLabel15: TSkinFMXLabel;
    SkinFMXLabel16: TSkinFMXLabel;
    SkinFMXLabel17: TSkinFMXLabel;
    SkinFMXLabel18: TSkinFMXLabel;
    SkinFMXLabel19: TSkinFMXLabel;
    btnComplete: TSkinFMXButton;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
    SkinFMXLabel20: TSkinFMXLabel;
    SkinFMXLabel21: TSkinFMXLabel;
    SkinFMXLabel22: TSkinFMXLabel;
    SkinFMXLabel23: TSkinFMXLabel;
    lblBillNO: TSkinFMXLabel;
    SkinFMXButton2: TSkinFMXButton;
    pnlClient: TSkinFMXPanel;
    chkItemSelected: TSkinFMXCheckBox;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    imgError: TSkinFMXImage;
    labErrorHint: TSkinFMXLabel;
    lblCompleteTime: TSkinFMXLabel;
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



{ TFrameListItemStyleFrame_ProcessTaskOrder }

constructor TFrameListItemStyle_ProcessTaskOrder.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ProcessTaskOrder.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ProcessTaskOrder',TFrameListItemStyle_ProcessTaskOrder);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ProcessTaskOrder);

end.
