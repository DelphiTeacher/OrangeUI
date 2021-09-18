//convert pas to utf8 by ¥
unit BaseParentItemStyleFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uDrawPicture, uSkinImageList, uSkinImageType, uSkinFireMonkeyImage;


type
  TFrameBaseParentItemStyle = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgGroupExpanded: TSkinFMXImage;
    lblGroupName: TSkinFMXLabel;
    imglistExpanded: TSkinImageList;
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameBaseParentItemStyle }

constructor TFrameBaseParentItemStyle.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameBaseParentItemStyle.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;




initialization
  RegisterListItemStyle('ParentBase',TFrameBaseParentItemStyle);
  RegisterListItemStyle('ParentDefault',TFrameBaseParentItemStyle);


finalization
  UnRegisterListItemStyle(TFrameBaseParentItemStyle);
  UnRegisterListItemStyle(TFrameBaseParentItemStyle);

end.

