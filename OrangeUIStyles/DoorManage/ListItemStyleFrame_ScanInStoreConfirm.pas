//convert pas to utf8 by ¥
unit ListItemStyleFrame_ScanInStoreConfirm;

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
  uSkinFireMonkeyImage, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinButtonType, uSkinFireMonkeyButton, uSkinPanelType,
  uSkinFireMonkeyPanel;


type
  //
  TFrameListItemStyle_ScanInStoreConfirm = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    btnDelFee: TSkinFMXButton;
    btnEditFee: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXLabel4: TSkinFMXLabel;
    edtRightNumber: TSkinFMXEdit;
    lblDetail1: TSkinFMXLabel;
    lblFeeCountHint: TSkinFMXLabel;
    edtLeftNumber: TSkinFMXEdit;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXLabel7: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    lblCaption: TSkinFMXLabel;
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

constructor TFrameListItemStyle_ScanInStoreConfirm.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ScanInStoreConfirm.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ScanInStoreConfirm',TFrameListItemStyle_ScanInStoreConfirm);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ScanInStoreConfirm);

end.
