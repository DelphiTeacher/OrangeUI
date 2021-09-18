//convert pas to utf8 by ¥
unit ListItemStyleFrame_ObjectInspector_CaptionLeft_DetailRightComboEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

//  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, FMX.ListBox, uSkinFireMonkeyComboBox, FMX.ComboEdit,
  uSkinFireMonkeyComboEdit;


type
  //根基类
  TFrameListItemStyle_ObjectInspector_CaptionLeft_DetailRightComboEdit = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    cmbDetail: TSkinFMXComboEdit;
    procedure ItemDesignerPanelResize(Sender: TObject);
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



{ TFrameListItemStyle_CaptionLeft_DetailRightComboEdit }

constructor TFrameListItemStyle_ObjectInspector_CaptionLeft_DetailRightComboEdit.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ObjectInspector_CaptionLeft_DetailRightComboEdit.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_ObjectInspector_CaptionLeft_DetailRightComboEdit.ItemDesignerPanelResize(
  Sender: TObject);
begin
//  lblItemDetail.Height:=ItemDesignerPanel.Height*0.3;

end;

initialization
  RegisterListItemStyle('CaptionLeft_ObjectInspector_DetailRightComboEdit',TFrameListItemStyle_ObjectInspector_CaptionLeft_DetailRightComboEdit);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ObjectInspector_CaptionLeft_DetailRightComboEdit);

end.
