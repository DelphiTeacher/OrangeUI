//convert pas to utf8 by ¥
unit ListItemStyleFrame_CaptionBottomDetailTop;

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
  TFrameListItemStyle_CaptionBottomDetailTop = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
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



{ TFrameListItemStyle_CaptionBottomDetailTop }

constructor TFrameListItemStyle_CaptionBottomDetailTop.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_CaptionBottomDetailTop.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_CaptionBottomDetailTop.ItemDesignerPanelResize(
  Sender: TObject);
begin
  lblItemDetail.Height:=ItemDesignerPanel.Height*0.3;

end;

initialization
  RegisterListItemStyle('CaptionBottomDetailTop',TFrameListItemStyle_CaptionBottomDetailTop);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_CaptionBottomDetailTop);

end.
