//convert pas to utf8 by ¥
unit ListItemStyleFrame_DefaultCenterSelected;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel;


type
  //根基类
  TFrameListItemStyle_DefaultCenterSelected = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
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



{ TFrameListItemStyle_DefaultCenterSelected }

constructor TFrameListItemStyle_DefaultCenterSelected.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_DefaultCenterSelected.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('BaseSelected',TFrameListItemStyle_DefaultCenterSelected);
  RegisterListItemStyle('DefaultCenterSelected',TFrameListItemStyle_DefaultCenterSelected);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_DefaultCenterSelected);
  UnRegisterListItemStyle(TFrameListItemStyle_DefaultCenterSelected);

end.
