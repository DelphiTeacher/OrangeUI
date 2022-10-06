//convert pas to utf8 by ¥
unit ListItemStyleFrame_ScanBarCodeItemOut;

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
  uSkinFireMonkeyEdit, uSkinButtonType, uSkinFireMonkeyButton;


type
  //根基类
  TFrameListItemStyle_ScanBarCodeItemOut = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    btnDec1: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnInc1: TSkinFMXButton;
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

constructor TFrameListItemStyle_ScanBarCodeItemOut.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ScanBarCodeItemOut.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ScanBarCodeItemOut',TFrameListItemStyle_ScanBarCodeItemOut);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ScanBarCodeItemOut);



end.
